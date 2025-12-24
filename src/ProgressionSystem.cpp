/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license: https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

#include "ProgressionSystem.h"
#include "DBUpdater.h"
#include "Tokenize.h"
#include "StringConvert.h"

inline std::vector<std::string> GetDatabaseDirectories(std::string const& folderName)
{
    std::vector<std::string> directories;

    std::string const path = "/modules/mod-progression-blizzlike/src/Bracket_";
    for (std::string const& bracketName : ProgressionBracketsNames)
    {
        if (!(sConfigMgr->GetOption<bool>("ProgressionSystem.Bracket_" + bracketName, false)))
        {
            continue;
        }

        std::string bracketPath = path + bracketName + "/sql/" + folderName;
        directories.push_back(std::move(bracketPath));
        
        // Log which bracket SQL is being loaded
        LOG_DEBUG("server.loading", "    -> Queued SQL from Bracket_{} ({})", bracketName, folderName);
    }

    return directories;
}

class ProgressionSystemLoadingDBUpdates : public DatabaseScript
{
public:
    ProgressionSystemLoadingDBUpdates() : DatabaseScript("ProgressionSystemLoadingDBUpdates") {}

    void OnAfterDatabasesLoaded(uint32 updateFlags) override
    {
        LOG_INFO("server.loading", ">> Loading mod-progression-blizzlike database updates...");

        bool reapplyUpdates = sConfigMgr->GetOption<bool>("ProgressionSystem.ReapplyUpdates", false);
        if (reapplyUpdates)
        {
            LOG_WARN("server.loading", ">> Progression System: ReapplyUpdates is ENABLED - all SQL will be reapplied (slow)");
        }

        if (DBUpdater<LoginDatabaseConnection>::IsEnabled(updateFlags))
        {
            if (reapplyUpdates)
            {
                LoginDatabase.Query("DELETE FROM updates WHERE name LIKE '%progression%'");
            }

            std::vector<std::string> loginDatabaseDirectories = GetDatabaseDirectories("auth");
            if (!loginDatabaseDirectories.empty())
            {
                LOG_INFO("server.loading", "  -> Loading auth database updates for {} bracket(s)", loginDatabaseDirectories.size());
                DBUpdater<LoginDatabaseConnection>::Update(LoginDatabase, &loginDatabaseDirectories);
            }
        }

        if (DBUpdater<CharacterDatabaseConnection>::IsEnabled(updateFlags))
        {
            if (reapplyUpdates)
            {
                CharacterDatabase.Query("DELETE FROM updates WHERE name LIKE '%progression%'");
            }

            std::vector<std::string> charactersDatabaseDirectories = GetDatabaseDirectories("characters");
            if (!charactersDatabaseDirectories.empty())
            {
                LOG_INFO("server.loading", "  -> Loading characters database updates for {} bracket(s)", charactersDatabaseDirectories.size());
                DBUpdater<CharacterDatabaseConnection>::Update(CharacterDatabase, &charactersDatabaseDirectories);
            }
        }

        if (DBUpdater<WorldDatabaseConnection>::IsEnabled(updateFlags))
        {
            if (reapplyUpdates)
            {
                WorldDatabase.Query("DELETE FROM updates WHERE name LIKE '%progression%'");
            }

            std::vector<std::string> worldDatabaseDirectories = GetDatabaseDirectories("world");
            if (!worldDatabaseDirectories.empty())
            {
                LOG_INFO("server.loading", "  -> Loading world database updates for {} bracket(s)", worldDatabaseDirectories.size());
                DBUpdater<WorldDatabaseConnection>::Update(WorldDatabase, &worldDatabaseDirectories);
            }
        }

        // Remove disabled attunements
        std::string disabledAttunements = sConfigMgr->GetOption<std::string>("ProgressionSystem.DisabledAttunements", "");
        if (!disabledAttunements.empty())
        {
            LOG_INFO("server.loading", "  -> Removing disabled attunements: {}", disabledAttunements);
            for (auto& itr : Acore::Tokenize(disabledAttunements, ',', false))
                WorldDatabase.Query("DELETE FROM dungeon_access_requirements WHERE dungeon_access_id = {}", Acore::StringTo<uint32>(itr).value());
        }

        LOG_INFO("server.loading", ">> mod-progression-blizzlike database updates loaded successfully");
    }
};

void AddProgressionSystemScripts()
{
    if (sConfigMgr->GetOption<bool>("ProgressionSystem.LoadDatabase", true))
    {
        new ProgressionSystemLoadingDBUpdates();
    }
}
