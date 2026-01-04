/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license: https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

#include "ProgressionSystem.h"
#include "DBUpdater.h"
#include "Log.h"
#include "Tokenize.h"
#include "StringConvert.h"

#include <algorithm>
#include <array>
#include <chrono>
#include <filesystem>
#include <thread>
#include <unordered_set>
#include <vector>

namespace
{
    struct ArenaSeasonMappingDefault
    {
        char const* seasonKey;
        char const* enabledKey;
        char const* defaultValue;
    };

    ArenaSeasonMappingDefault constexpr kArenaSeasonDefaults[] =
    {
        { "ProgressionSystem.Bracket.ArenaSeason1", "ProgressionSystem.Bracket.ArenaSeason1.Enabled", "Bracket_70_2_1,Bracket_70_2_2" },
        { "ProgressionSystem.Bracket.ArenaSeason2", "ProgressionSystem.Bracket.ArenaSeason2.Enabled", "Bracket_70_2_2,Bracket_70_3_2,Bracket_70_4_1" },
        { "ProgressionSystem.Bracket.ArenaSeason3", "ProgressionSystem.Bracket.ArenaSeason3.Enabled", "Bracket_70_5" },
        { "ProgressionSystem.Bracket.ArenaSeason4", "ProgressionSystem.Bracket.ArenaSeason4.Enabled", "Bracket_70_6_2" },
        { "ProgressionSystem.Bracket.ArenaSeason5", "ProgressionSystem.Bracket.ArenaSeason5.Enabled", "Bracket_80_1_2" },
        { "ProgressionSystem.Bracket.ArenaSeason6", "ProgressionSystem.Bracket.ArenaSeason6.Enabled", "Bracket_80_2_2" },
        { "ProgressionSystem.Bracket.ArenaSeason7", "ProgressionSystem.Bracket.ArenaSeason7.Enabled", "Bracket_80_3" },
        { "ProgressionSystem.Bracket.ArenaSeason8", "ProgressionSystem.Bracket.ArenaSeason8.Enabled", "Bracket_80_4_1" },
    };

    inline std::string Trim(std::string s)
    {
        auto const first = s.find_first_not_of(" \t\r\n");
        if (first == std::string::npos)
            return std::string();
        auto const last = s.find_last_not_of(" \t\r\n");
        s = s.substr(first, last - first + 1);
        return s;
    }
}

bool IsProgressionBracketEnabled(std::string const& bracketName)
{
    if (sConfigMgr->GetOption<bool>("ProgressionSystem.Bracket_" + bracketName, false, false))
        return true;

    // ArenaSeason mapping aliases (if enabled).
    for (ArenaSeasonMappingDefault const& season : kArenaSeasonDefaults)
    {
        if (!sConfigMgr->GetOption<bool>(season.enabledKey, false, false))
            continue;

        std::string mapping = sConfigMgr->GetOption<std::string>(season.seasonKey, season.defaultValue, false);
        mapping = Trim(std::move(mapping));
        if (mapping.empty())
            continue;

        for (auto tokenView : Acore::Tokenize(mapping, ',', false))
        {
            std::string token(tokenView);
            token = Trim(std::move(token));
            if (token.empty())
                continue;

            // Accept both "Bracket_80_2" and "80_2".
            constexpr char const* kPrefix = "Bracket_";
            if (token.rfind(kPrefix, 0) == 0)
                token.erase(0, std::char_traits<char>::length(kPrefix));

            if (token == bracketName)
                return true;
        }
    }

    return false;
}

inline std::string DetermineModuleBracketBasePath()
{
    static std::string const cached = []() -> std::string
    {
        namespace fs = std::filesystem;

        auto Normalize = [](fs::path const& p)
        {
            // Use forward slashes for consistency across platforms and to avoid mixing separators
            // when composing update names.
            return p.generic_string();
        };

        // Optional: explicit path override for environments where cwd is unreliable (Windows service, etc).
        // This should point to the module's `src` directory that contains `Bracket_0`, `Bracket_1_19`, ...
        std::string configuredRoot = sConfigMgr->GetOption<std::string>("ProgressionSystem.BracketSqlRoot", "");
        configuredRoot = Trim(std::move(configuredRoot));
        if (!configuredRoot.empty())
        {
            fs::path rootPath(configuredRoot);

            // Accept values like ".../src", ".../src/Bracket_0", or ".../src/Bracket_".
            std::string const leaf = rootPath.filename().generic_string();
            if (leaf.rfind("Bracket_", 0) == 0)
                rootPath = rootPath.parent_path();

            // Accept either ".../src" OR ".../<moduleRoot>" (where brackets live under "src/").
            std::array<fs::path, 2> const candidates =
            {
                rootPath,
                rootPath / "src"
            };

            fs::path foundBracket0;
            for (fs::path const& candidate : candidates)
            {
                fs::path const probe = candidate / "Bracket_0";
                if (fs::exists(probe) && fs::is_directory(probe))
                {
                    foundBracket0 = probe;
                    break;
                }
            }

            if (!foundBracket0.empty())
            {
                fs::path canonicalProbe;
                try
                {
                    canonicalProbe = fs::canonical(foundBracket0);
                }
                catch (...)
                {
                    canonicalProbe = fs::absolute(foundBracket0);
                }

                std::string const stableBase = Normalize(canonicalProbe.parent_path()) + "/Bracket_";
                LOG_INFO("server.server",
                    "[mod-progression-blizzlike] Using bracket SQL base path from ProgressionSystem.BracketSqlRoot: '{}'",
                    stableBase);
                return stableBase;
            }

            LOG_WARN("server.server",
                "[mod-progression-blizzlike] ProgressionSystem.BracketSqlRoot='{}' is set but Bracket_0 was not found under it (tried '<root>/Bracket_0' and '<root>/src/Bracket_0'); falling back to auto-detect.",
                configuredRoot);
        }

        // Worldserver's working directory differs depending on how it is launched (Windows service,
        // IDE, acore.sh, etc). Probe a few common relative locations.
        std::array<std::string, 5> const candidates =
        {
            "modules/mod-progression-blizzlike/src/Bracket_",
            "../modules/mod-progression-blizzlike/src/Bracket_",
            "../../modules/mod-progression-blizzlike/src/Bracket_",
            "../../../modules/mod-progression-blizzlike/src/Bracket_",
            "../../../../modules/mod-progression-blizzlike/src/Bracket_",
        };

        for (std::string const& base : candidates)
        {
            // Probe only the module/bracket folder itself (independent of auth/characters/world).
            // Not every bracket ships sql/auth or sql/characters, so those folders must not be required.
            fs::path const probe = fs::path(base + "0");
            if (fs::exists(probe) && fs::is_directory(probe))
            {
                // Note: depending on the core/customization, `updates.name` may store only the SQL filename
                // ("file.sql") or a directory-prefixed name (".../sql/world/file.sql").
                // Resolve to a stable absolute path to keep the directory-prefixed case consistent and to
                // keep logs predictable across different working directories.
                fs::path canonicalProbe;
                try
                {
                    canonicalProbe = fs::canonical(probe);
                }
                catch (...)
                {
                    canonicalProbe = fs::absolute(probe);
                }

                std::string const stableBase = Normalize(canonicalProbe.parent_path()) + "/Bracket_";
                LOG_INFO("server.server", "[mod-progression-blizzlike] Using bracket SQL base path: '{}'", stableBase);
                return stableBase;
            }
        }

        std::string cwd = "<unknown>";
        try
        {
            cwd = Normalize(fs::current_path());
        }
        catch (...)
        {
        }

        LOG_WARN("server.server",
            "[mod-progression-blizzlike] Could not locate bracket SQL folders from the current working directory. "
            "cwd='{}'. Tried common relative paths like './modules/...'. You can also set ProgressionSystem.BracketSqlRoot "
            "to an absolute path to '.../modules/mod-progression-blizzlike/src'. Falling back to 'modules/mod-progression-blizzlike/src/Bracket_'.",
            cwd);
        return "modules/mod-progression-blizzlike/src/Bracket_";
    }();

    return cached;
}

template <typename TDatabase>
static void DeleteModuleUpdatesForEnabledBrackets(TDatabase& db, std::string const& folderName);

template <typename TDatabase>
static void LogModulePendingSqlFiles(TDatabase& db, std::vector<std::string> const& directories, std::string const& folderName);

namespace
{
    std::string EscapeSqlString(std::string const& s)
    {
        std::string out;
        out.reserve(s.size());
        for (char c : s)
        {
            if (c == '\\' || c == '\'')
                out.push_back('\\');
            out.push_back(c);
        }
        return out;
    }

    std::vector<std::string> CollectSqlUpdateFilenames(std::vector<std::string> const& directories)
    {
        namespace fs = std::filesystem;

        std::vector<std::string> names;
        names.reserve(512);

        for (std::string const& dir : directories)
        {
            fs::path const p(dir);
            if (!fs::exists(p) || !fs::is_directory(p))
                continue;

            for (fs::directory_iterator it(p); it != fs::directory_iterator(); ++it)
            {
                if (!it->is_regular_file())
                    continue;
                if (it->path().extension() != ".sql")
                    continue;

                names.push_back(it->path().filename().string());
            }
        }

        std::sort(names.begin(), names.end());
        names.erase(std::unique(names.begin(), names.end()), names.end());
        return names;
    }

    std::string BuildSqlInList(std::vector<std::string> const& items, size_t begin, size_t end)
    {
        std::string in;
        for (size_t i = begin; i < end; ++i)
        {
            if (!in.empty())
                in += ",";
            in += "'";
            in += EscapeSqlString(items[i]);
            in += "'";
        }
        return in;
    }
}

template <typename TDatabase>
static std::unordered_set<std::string> CollectAppliedUpdateNames(TDatabase& db, std::vector<std::string> const& directories)
{
    std::unordered_set<std::string> applied;
    applied.reserve(4096);

    for (std::string const& dir : directories)
    {
        auto result = db.Query("SELECT name FROM updates WHERE name LIKE '{}'", dir + "/%");
        if (!result)
            continue;

        do
        {
            applied.insert((*result)[0].template Get<std::string>());
        } while (result->NextRow());
    }

    // AzerothCore's `updates.name` is commonly stored as the SQL filename only (no directory prefix).
    // We support both formats to make ReapplyUpdates/LogPendingSql work across setups.
    std::vector<std::string> const filenames = CollectSqlUpdateFilenames(directories);
    constexpr size_t kChunkSize = 200;
    for (size_t i = 0; i < filenames.size(); i += kChunkSize)
    {
        size_t const end = std::min(filenames.size(), i + kChunkSize);
        std::string const inList = BuildSqlInList(filenames, i, end);
        if (inList.empty())
            continue;

        auto result = db.Query("SELECT name FROM updates WHERE name IN ({})", inList);
        if (!result)
            continue;

        do
        {
            applied.insert((*result)[0].template Get<std::string>());
        } while (result->NextRow());
    }

    return applied;
}

template <typename TConnection, typename TDatabase>
static void ApplyDbUpdatesInBracketOrder(TDatabase& db, uint32 updateFlags, std::string const& folderName)
{
    if (!DBUpdater<TConnection>::IsEnabled(updateFlags))
    {
        // This typically means core database updates are disabled (e.g. Updates.EnableDatabases=0 or a --no-db-updates flag).
        // Without DBUpdater, bracket SQL cannot be auto-applied.
        LOG_WARN("server.server",
            "[mod-progression-blizzlike] Core DBUpdater is disabled for '{}' (updateFlags=0x{:X}). Bracket SQL will NOT be auto-applied. "
            "Enable DB updates in your core config (worldserver.conf) or apply the bracket SQL manually.",
            folderName,
            updateFlags);
        return;
    }

    if (sConfigMgr->GetOption<bool>("ProgressionSystem.ReapplyUpdates", false))
    {
        DeleteModuleUpdatesForEnabledBrackets(db, folderName);
    }

    namespace fs = std::filesystem;

    std::string const base = DetermineModuleBracketBasePath();

    bool const logPending = sConfigMgr->GetOption<bool>("ProgressionSystem.Debug.LogPendingSql", false);
    bool const logApplied = sConfigMgr->GetOption<bool>("ProgressionSystem.Debug.LogAppliedSql", false);
    bool const auditSql = sConfigMgr->GetOption<bool>("ProgressionSystem.Debug.AuditSqlExecution", false);
    uint32 const bracketDelayMs = static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.Debug.BracketApplyDelayMs", 0)));

    uint32 totalDirs = 0;
    uint32 enabledBrackets = 0;
    std::string firstEnabledBracket;
    std::string firstMissingDir;
    for (std::string const& bracketName : ProgressionBracketsNames)
    {
        if (!IsProgressionBracketEnabled(bracketName))
            continue;

        ++enabledBrackets;
        if (firstEnabledBracket.empty())
            firstEnabledBracket = bracketName;

        std::string const dir = base + bracketName + "/sql/" + folderName;
        fs::path const bracketDir = fs::path(dir);

        if (!fs::exists(bracketDir) || !fs::is_directory(bracketDir))
        {
            if (firstMissingDir.empty())
                firstMissingDir = dir;

            if (folderName == "world")
            {
                LOG_WARN("server.server",
                    "[mod-progression-blizzlike] Enabled bracket '{}' but SQL directory not found: '{}' (cwd-sensitive)",
                    bracketName, dir);
            }
            continue;
        }

        ++totalDirs;

        // Apply strictly in bracket order: one DBUpdater call per bracket.
        std::vector<std::string> dirs = { dir };

        if (logPending || logApplied)
        {
            LOG_INFO("server.server", "[mod-progression-blizzlike] Applying {} SQL updates for bracket '{}' from '{}'",
                folderName, bracketName, dir);
        }

        std::unordered_set<std::string> appliedBefore;
        if (logApplied || auditSql)
        {
            appliedBefore = CollectAppliedUpdateNames(db, dirs);
        }

        LogModulePendingSqlFiles(db, dirs, folderName);
        DBUpdater<TConnection>::Update(db, &dirs);

        if (logApplied || auditSql)
        {
            std::unordered_set<std::string> appliedAfter = CollectAppliedUpdateNames(db, dirs);

            std::vector<std::string> newlyApplied;
            newlyApplied.reserve(appliedAfter.size());
            for (std::string const& name : appliedAfter)
            {
                if (appliedBefore.find(name) == appliedBefore.end())
                    newlyApplied.push_back(name);
            }

            std::sort(newlyApplied.begin(), newlyApplied.end());

            uint32 const delayMs = static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.Debug.SqlLogDelayMs", 0)));

            if (logApplied)
            {
                if (newlyApplied.empty())
                {
                    LOG_INFO("server.server", "[mod-progression-blizzlike] {} SQL bracket '{}': no new updates applied.",
                        folderName, bracketName);
                }
                else
                {
                    LOG_INFO("server.server", "[mod-progression-blizzlike] {} SQL bracket '{}': applied {} update(s):",
                        folderName, bracketName, static_cast<uint32>(newlyApplied.size()));

                    for (std::string const& name : newlyApplied)
                    {
                        LOG_INFO("server.server", "[mod-progression-blizzlike] {} SQL (applied): {}",
                            folderName, name);
                        if (delayMs > 0)
                            std::this_thread::sleep_for(std::chrono::milliseconds(delayMs));
                    }
                }
            }

            if (auditSql && !newlyApplied.empty())
            {
                static bool tableReady = false;
                if (!tableReady)
                {
                    db.Execute("CREATE TABLE IF NOT EXISTS progression_sql_audit ("
                               "id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,"
                               "name VARCHAR(255) NOT NULL,"
                               "bracket VARCHAR(64) NOT NULL,"
                               "db_folder VARCHAR(32) NOT NULL,"
                               "applied_at DATETIME NOT NULL,"
                               "PRIMARY KEY (id),"
                               "KEY idx_name (name),"
                               "KEY idx_bracket (bracket)")");
                    tableReady = true;
                }

                for (std::string const& name : newlyApplied)
                {
                    db.Execute("INSERT INTO progression_sql_audit (name, bracket, db_folder, applied_at) VALUES ({}, {}, {}, NOW())",
                        name, bracketName, folderName);
                }
            }
        }

        if (bracketDelayMs > 0)
            std::this_thread::sleep_for(std::chrono::milliseconds(bracketDelayMs));
    }

    if (totalDirs == 0)
    {
        // This module currently ships world DB updates only; scanning 0 auth/characters directories is expected.
        if (folderName != "world")
        {
            LOG_INFO("server.server",
                "[mod-progression-blizzlike] DBUpdater will scan 0 '{}' directories (this can be normal).",
                folderName);
        }
        else if (enabledBrackets == 0)
        {
            LOG_WARN("server.server",
                "[mod-progression-blizzlike] DBUpdater will scan 0 '{}' directories because no brackets are effectively enabled. "
                "Enable at least one `ProgressionSystem.Bracket_* = 1` in your active config (etc/modules/*.conf) and ensure it has a [worldserver] section.",
                folderName);
        }
        else
        {
            LOG_WARN("server.server",
                "[mod-progression-blizzlike] DBUpdater will scan 0 '{}' directories even though {} bracket(s) are enabled. "
                "Example expected directory: '{}{}{}' (check that the module files are present in your runtime container and that ProgressionSystem.BracketSqlRoot points to the module's `src`). "
                "First missing path seen: '{}'.",
                folderName,
                enabledBrackets,
                base,
                firstEnabledBracket.empty() ? "<bracket>" : firstEnabledBracket,
                "/sql/" + folderName,
                firstMissingDir.empty() ? "<none>" : firstMissingDir);
        }
    }
    else
    {
        LOG_INFO("server.server",
            "[mod-progression-blizzlike] DBUpdater applied '{}' updates for {} bracket directories in order.",
            folderName, totalDirs);
    }
}

template <typename TDatabase>
static void DeleteModuleUpdatesForEnabledBrackets(TDatabase& db, std::string const& folderName)
{
    // DBUpdater records executed updates into the `updates` table.
    // To force reapply, delete only rows that belong to this module's enabled bracket directories.
    // This is intentionally scoped (we do NOT delete global 'progression_%' entries).
    std::string const base = DetermineModuleBracketBasePath();
    namespace fs = std::filesystem;

    std::vector<std::string> filenames;
    filenames.reserve(1024);

    for (std::string const& bracketName : ProgressionBracketsNames)
    {
        if (!IsProgressionBracketEnabled(bracketName))
            continue;

        std::string const dir = base + bracketName + "/sql/" + folderName;
        std::string const dirPrefix = dir + "/";

        // Some setups store a directory prefix in `updates.name` (e.g. "…/sql/world/file.sql").
        // Always clear those rows if present.
        db.Query("DELETE FROM updates WHERE name LIKE '{}'", dirPrefix + "%");

        // AzerothCore commonly stores ONLY the filename in `updates.name` (e.g. "file.sql").
        // Collect the filenames present in this directory to clear those rows too.
        fs::path const p(dir);
        if (!fs::exists(p) || !fs::is_directory(p))
            continue;

        for (fs::directory_iterator it(p); it != fs::directory_iterator(); ++it)
        {
            if (!it->is_regular_file())
                continue;
            if (it->path().extension() != ".sql")
                continue;
            filenames.push_back(it->path().filename().string());
        }
    }

    if (!filenames.empty())
    {
        std::sort(filenames.begin(), filenames.end());
        filenames.erase(std::unique(filenames.begin(), filenames.end()), filenames.end());

        constexpr size_t kChunkSize = 200;
        for (size_t i = 0; i < filenames.size(); i += kChunkSize)
        {
            size_t const end = std::min(filenames.size(), i + kChunkSize);
            std::string const inList = BuildSqlInList(filenames, i, end);
            if (inList.empty())
                continue;

            db.Query("DELETE FROM updates WHERE name IN ({})", inList);
        }
    }
}

template <typename TDatabase>
static void LogModulePendingSqlFiles(TDatabase& db, std::vector<std::string> const& directories, std::string const& folderName)
{
    bool const enabled = sConfigMgr->GetOption<bool>("ProgressionSystem.Debug.LogPendingSql", false);
    if (!enabled)
        return;

    uint32 const maxLines = static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.Debug.MaxSqlLogLines", 200)));
    bool const reapply = sConfigMgr->GetOption<bool>("ProgressionSystem.ReapplyUpdates", false);
    uint32 const delayMs = static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.Debug.SqlLogDelayMs", 0)));

    namespace fs = std::filesystem;

    // Collect already-applied update names for these directories (best-effort).
    std::unordered_set<std::string> applied = CollectAppliedUpdateNames(db, directories);

    uint32 printed = 0;
    uint32 totalPending = 0;
    uint32 totalFiles = 0;

    struct SqlLogItem
    {
        std::string updateName;
        bool isApplied = false;
    };

    std::vector<SqlLogItem> items;
    items.reserve(512);

    for (std::string const& dir : directories)
    {
        fs::path const p(dir);
        if (!fs::exists(p) || !fs::is_directory(p))
            continue;

        for (fs::directory_iterator it(p); it != fs::directory_iterator(); ++it)
        {
            if (!it->is_regular_file())
                continue;
            if (it->path().extension() != ".sql")
                continue;

            ++totalFiles;

            std::string const filename = it->path().filename().string();
            std::string const updateName = dir + "/" + filename;
            bool const isApplied =
                (applied.find(updateName) != applied.end()) ||
                (applied.find(filename) != applied.end());
            bool const shouldPrint = reapply ? true : !isApplied;

            if (!isApplied)
                ++totalPending;

            if (!shouldPrint)
                continue;

            items.push_back(SqlLogItem{ updateName, isApplied });
        }
    }

    std::sort(items.begin(), items.end(), [](SqlLogItem const& a, SqlLogItem const& b)
    {
        return a.updateName < b.updateName;
    });

    for (SqlLogItem const& item : items)
    {
        if (printed >= maxLines)
            break;

        LOG_INFO("server.server", "[mod-progression-blizzlike] {} SQL {}: {}",
            folderName,
            reapply ? "(reapply)" : "(pending)",
            item.updateName);
        ++printed;

        if (delayMs > 0)
            std::this_thread::sleep_for(std::chrono::milliseconds(delayMs));
    }

    LOG_INFO("server.server",
        "[mod-progression-blizzlike] SQL summary for '{}': files_found={} pending_estimated={} printed={} max={} reapply={}",
        folderName, totalFiles, totalPending, printed, maxLines, reapply ? 1 : 0);
}

class ProgressionSystemLoadingDBUpdates : public DatabaseScript
{
public:
    ProgressionSystemLoadingDBUpdates() : DatabaseScript("ProgressionSystemLoadingDBUpdates") {}

    void OnAfterDatabasesLoaded(uint32 updateFlags) override
    {
        if (!sConfigMgr->GetOption<bool>("ProgressionSystem.LoadDatabase", true))
        {
            LOG_INFO("server.server", "[mod-progression-blizzlike] LoadDatabase=0: skipping DBUpdater for bracket SQL.");
            return;
        }

        // Restore any previously-applied custom locks to base state BEFORE DBUpdater runs.
        // This keeps bracket SQL deterministic and makes CustomLocks reversible by config.
        extern void ProgressionSystemRestoreCustomLocks();
        ProgressionSystemRestoreCustomLocks();

        LOG_INFO("server.server", "Loading mod-progression-blizzlike updates...");

        ApplyDbUpdatesInBracketOrder<LoginDatabaseConnection>(LoginDatabase, updateFlags, "auth");
        ApplyDbUpdatesInBracketOrder<CharacterDatabaseConnection>(CharacterDatabase, updateFlags, "characters");
        ApplyDbUpdatesInBracketOrder<WorldDatabaseConnection>(WorldDatabase, updateFlags, "world");

        // Remove disabled attunements
        std::string disabledAttunements = sConfigMgr->GetOption<std::string>("ProgressionSystem.DisabledAttunements", "");
        disabledAttunements = Trim(std::move(disabledAttunements));
        for (auto tokenView : Acore::Tokenize(disabledAttunements, ',', false))
        {
            std::string token(tokenView);
            token = Trim(std::move(token));
            if (token.empty())
                continue;

            auto parsed = Acore::StringTo<uint32>(token);
            if (!parsed)
            {
                LOG_WARN("server.server",
                    "[mod-progression-blizzlike] Ignoring invalid dungeon_access_id '{}' in ProgressionSystem.DisabledAttunements (expected comma-separated integers).",
                    token);
                continue;
            }

            WorldDatabase.Query(
                "DELETE FROM dungeon_access_requirements WHERE dungeon_access_id = {}",
                parsed.value());
        }

        // Apply any custom lock overlays AFTER bracket SQL updates.
        extern void ProgressionSystemApplyCustomLocks();
        ProgressionSystemApplyCustomLocks();
    }
};

void AddProgressionSystemScripts()
{
    if (sConfigMgr->GetOption<bool>("ProgressionSystem.LoadDatabase", true))
    {
        new ProgressionSystemLoadingDBUpdates();
    }

    // Optional: avg item level gate for heroic dungeons (based on equipped average item level).
    // Enabled via ProgressionSystem.HeroicGs.Enabled.
    extern void AddProgressionSystemHeroicGsScripts();
    AddProgressionSystemHeroicGsScripts();
}
