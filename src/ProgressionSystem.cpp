/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license: https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

#include "ProgressionSystem.h"
#include "DBUpdater.h"
#include "Log.h"
#include "Tokenize.h"
#include "StringConvert.h"

#include <filesystem>
#include <unordered_set>

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
    if (sConfigMgr->GetOption<bool>("ProgressionSystem.Bracket_" + bracketName, false))
        return true;

    // ArenaSeason mapping aliases (if enabled).
    for (ArenaSeasonMappingDefault const& season : kArenaSeasonDefaults)
    {
        if (!sConfigMgr->GetOption<bool>(season.enabledKey, false))
            continue;

        std::string mapping = sConfigMgr->GetOption<std::string>(season.seasonKey, season.defaultValue);
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
    namespace fs = std::filesystem;

    auto Normalize = [](fs::path const& p)
    {
        // Use forward slashes for consistency across platforms and to avoid mixing separators
        // when composing update names.
        return p.generic_string();
    };

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
            // Important: DBUpdater records the directory prefix into `updates.name`.
            // If worldserver is launched with a different working directory, a relative prefix like
            // "../modules/..." can change across runs and make already-applied SQL look "new".
            // Resolve to a stable absolute path to keep `updates.name` consistent.
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

    LOG_WARN("server.server",
        "[mod-progression-blizzlike] Could not locate bracket SQL folders from the current working directory. "
        "Tried common relative paths like './modules/...'. Falling back to 'modules/mod-progression-blizzlike/src/Bracket_'.");
    return "modules/mod-progression-blizzlike/src/Bracket_";
}

template <typename TDatabase>
static void DeleteModuleUpdatesForEnabledBrackets(TDatabase& db, std::string const& folderName);

template <typename TDatabase>
static void LogModulePendingSqlFiles(TDatabase& db, std::vector<std::string> const& directories, std::string const& folderName);

template <typename TConnection, typename TDatabase>
static void ApplyDbUpdatesInBracketOrder(TDatabase& db, uint32 updateFlags, std::string const& folderName)
{
    if (!DBUpdater<TConnection>::IsEnabled(updateFlags))
        return;

    if (sConfigMgr->GetOption<bool>("ProgressionSystem.ReapplyUpdates", false))
    {
        DeleteModuleUpdatesForEnabledBrackets(db, folderName);
    }

    namespace fs = std::filesystem;

    std::string const base = DetermineModuleBracketBasePath();

    uint32 totalDirs = 0;
    for (std::string const& bracketName : ProgressionBracketsNames)
    {
        if (!IsProgressionBracketEnabled(bracketName))
            continue;

        std::string const dir = base + bracketName + "/sql/" + folderName;
        fs::path const bracketDir = fs::path(dir);

        if (!fs::exists(bracketDir) || !fs::is_directory(bracketDir))
        {
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
        LogModulePendingSqlFiles(db, dirs, folderName);
        DBUpdater<TConnection>::Update(db, &dirs);
    }

    if (totalDirs == 0)
    {
        LOG_INFO("server.server",
            "[mod-progression-blizzlike] DBUpdater will scan 0 '{}' directories (this can be normal).",
            folderName);
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

    for (std::string const& bracketName : ProgressionBracketsNames)
    {
        if (!IsProgressionBracketEnabled(bracketName))
            continue;

        std::string const dirPrefix = base + bracketName + "/sql/" + folderName + "/";

        // Most AzerothCore setups store the relative path (including directory) in `updates.name`.
        // If a custom core stores only the filename, this won't match; in that case, force reapply
        // must be done by clearing `updates` manually.
        db.Query("DELETE FROM updates WHERE name LIKE '{}'", dirPrefix + "%");
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

    namespace fs = std::filesystem;

    // Collect already-applied update names for these directories (best-effort).
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

    uint32 printed = 0;
    uint32 totalPending = 0;
    uint32 totalFiles = 0;

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

            std::string const updateName = dir + "/" + it->path().filename().string();
            bool const isApplied = (applied.find(updateName) != applied.end());
            bool const shouldPrint = reapply ? true : !isApplied;

            if (!isApplied)
                ++totalPending;

            if (!shouldPrint)
                continue;

            if (printed < maxLines)
            {
                LOG_INFO("server.server", "[mod-progression-blizzlike] {} SQL {}: {}",
                    folderName,
                    reapply ? "(reapply)" : "(pending)",
                    updateName);
                ++printed;
            }
        }
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
        for (auto& itr : Acore::Tokenize(disabledAttunements, ',', false))
            WorldDatabase.Query("DELETE FROM dungeon_access_requirements WHERE dungeon_access_id = {}", Acore::StringTo<uint32>(itr).value());

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
