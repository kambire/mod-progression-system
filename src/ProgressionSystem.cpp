/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license: https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

#include "ProgressionSystem.h"
#include "DBUpdater.h"
#include "Tokenize.h"
#include "StringConvert.h"

#include <filesystem>

inline std::string DetermineModuleBracketBasePath()
{
    namespace fs = std::filesystem;

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
            LOG_INFO("server.server", "[mod-progression-blizzlike] Using bracket SQL base path: '{}'", base);
            return base;
        }
    }

    LOG_WARN("server.server",
        "[mod-progression-blizzlike] Could not locate bracket SQL folders from the current working directory. "
        "Tried common relative paths like './modules/...'. Falling back to 'modules/mod-progression-blizzlike/src/Bracket_'.");
    return "modules/mod-progression-blizzlike/src/Bracket_";
}

inline std::vector<std::string> GetDatabaseDirectories(std::string const& folderName)
{
    std::vector<std::string> directories;

    namespace fs = std::filesystem;

    // DBUpdater expects paths relative to the worldserver working directory.
    // Using a relative path here avoids platform-specific absolute paths.
    std::string const path = DetermineModuleBracketBasePath();
    for (std::string const& bracketName : ProgressionBracketsNames)
    {
        if (!(sConfigMgr->GetOption<bool>("ProgressionSystem.Bracket_" + bracketName, false)))
        {
            continue;
        }

        std::string bracketPath = path + bracketName + "/sql/" + folderName;
        fs::path const bracketDir = fs::path(bracketPath);
        if (!fs::exists(bracketDir) || !fs::is_directory(bracketDir))
        {
            // Many brackets will not have sql/auth or sql/characters folders; that's OK.
            // Warn only for missing world folders since those carry the bulk of progression changes.
            if (folderName == "world")
            {
                LOG_WARN("server.server",
                    "[mod-progression-blizzlike] Enabled bracket '{}' but SQL directory not found: '{}' (cwd-sensitive)",
                    bracketName, bracketPath);
            }
            continue;
        }

        directories.push_back(std::move(bracketPath));
    }

    if (directories.empty())
    {
        LOG_INFO("server.server",
            "[mod-progression-blizzlike] DBUpdater will scan 0 '{}' directories (this can be normal).",
            folderName);
    }
    else
    {
        LOG_INFO("server.server",
            "[mod-progression-blizzlike] DBUpdater will scan {} '{}' directories.",
            directories.size(), folderName);
    }

    return directories;
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
        if (!sConfigMgr->GetOption<bool>("ProgressionSystem.Bracket_" + bracketName, false))
            continue;

        std::string const dirPrefix = base + bracketName + "/sql/" + folderName + "/";

        // Most AzerothCore setups store the relative path (including directory) in `updates.name`.
        // If a custom core stores only the filename, this won't match; in that case, force reapply
        // must be done by clearing `updates` manually.
        db.Query("DELETE FROM updates WHERE name LIKE '{}'", dirPrefix + "%");
    }
}

class ProgressionSystemLoadingDBUpdates : public DatabaseScript
{
public:
    ProgressionSystemLoadingDBUpdates() : DatabaseScript("ProgressionSystemLoadingDBUpdates") {}

    void OnAfterDatabasesLoaded(uint32 updateFlags) override
    {
        LOG_INFO("server.server", "Loading mod-progression-blizzlike updates...");

        if (DBUpdater<LoginDatabaseConnection>::IsEnabled(updateFlags))
        {
            if (sConfigMgr->GetOption<bool>("ProgressionSystem.ReapplyUpdates", false))
            {
                DeleteModuleUpdatesForEnabledBrackets(LoginDatabase, "auth");
            }

            std::vector<std::string> loginDatabaseDirectories = GetDatabaseDirectories("auth");
            if (!loginDatabaseDirectories.empty())
            {
                DBUpdater<LoginDatabaseConnection>::Update(LoginDatabase, &loginDatabaseDirectories);
            }
        }

        if (DBUpdater<CharacterDatabaseConnection>::IsEnabled(updateFlags))
        {
            if (sConfigMgr->GetOption<bool>("ProgressionSystem.ReapplyUpdates", false))
            {
                DeleteModuleUpdatesForEnabledBrackets(CharacterDatabase, "characters");
            }

            std::vector<std::string> charactersDatabaseDirectories = GetDatabaseDirectories("characters");
            if (!charactersDatabaseDirectories.empty())
            {
                DBUpdater<CharacterDatabaseConnection>::Update(CharacterDatabase, &charactersDatabaseDirectories);
            }
        }

        if (DBUpdater<WorldDatabaseConnection>::IsEnabled(updateFlags))
        {
            if (sConfigMgr->GetOption<bool>("ProgressionSystem.ReapplyUpdates", false))
            {
                DeleteModuleUpdatesForEnabledBrackets(WorldDatabase, "world");
            }

            std::vector<std::string> worldDatabaseDirectories = GetDatabaseDirectories("world");
            if (!worldDatabaseDirectories.empty())
            {
                DBUpdater<WorldDatabaseConnection>::Update(WorldDatabase, &worldDatabaseDirectories);
            }
        }

        // Remove disabled attunements
        std::string disabledAttunements = sConfigMgr->GetOption<std::string>("ProgressionSystem.DisabledAttunements", "");
        for (auto& itr : Acore::Tokenize(disabledAttunements, ',', false))
            WorldDatabase.Query("DELETE FROM dungeon_access_requirements WHERE dungeon_access_id = {}", Acore::StringTo<uint32>(itr).value());
    }
};

void AddProgressionSystemScripts()
{
    if (sConfigMgr->GetOption<bool>("ProgressionSystem.LoadDatabase", true))
    {
        new ProgressionSystemLoadingDBUpdates();
    }
}
