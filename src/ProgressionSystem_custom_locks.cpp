/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license:
 * https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

#include "Config.h"
#include "DatabaseEnv.h"
#include "Log.h"
#include "Tokenize.h"
#include "StringConvert.h"

#include <algorithm>
#include <string>
#include <unordered_set>
#include <vector>

namespace
{
    constexpr char const* kDisablesBackupTable = "mod_progression_custom_lock_disables_backup";
    constexpr char const* kCreatureTemplateBackupTable = "mod_progression_custom_lock_creature_template_backup";

    std::string Trim(std::string s)
    {
        auto const first = s.find_first_not_of(" \t\r\n");
        if (first == std::string::npos)
            return std::string();
        auto const last = s.find_last_not_of(" \t\r\n");
        s = s.substr(first, last - first + 1);
        return s;
    }

    std::unordered_set<uint32> ParseIdList(std::string const& raw)
    {
        std::unordered_set<uint32> ids;
        std::string list = Trim(raw);
        if (list.empty())
            return ids;

        for (auto tokenView : Acore::Tokenize(list, ',', false))
        {
            std::string token(tokenView);
            token = Trim(std::move(token));
            if (token.empty())
                continue;

            if (auto parsed = Acore::StringTo<uint32>(token))
                ids.insert(parsed.value());
        }

        return ids;
    }

    bool TableExists(char const* tableName)
    {
        QueryResult probe = WorldDatabase.Query("SHOW TABLES LIKE '{}'", tableName);
        return probe != nullptr;
    }

    void EnsureBackupTablesExist()
    {
        // Numeric-only backup state to avoid needing to store/escape comments/params.
        WorldDatabase.Execute(
            "CREATE TABLE IF NOT EXISTS {} ("
            "  sourceType TINYINT UNSIGNED NOT NULL,"
            "  entry INT UNSIGNED NOT NULL,"
            "  had_row TINYINT(1) NOT NULL,"
            "  flags INT UNSIGNED NOT NULL,"
            "  PRIMARY KEY (sourceType, entry)"
            ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            kDisablesBackupTable);

        WorldDatabase.Execute(
            "CREATE TABLE IF NOT EXISTS {} ("
            "  entry INT UNSIGNED NOT NULL,"
            "  npcflag INT UNSIGNED NOT NULL,"
            "  gossip_menu_id INT UNSIGNED NOT NULL,"
            "  PRIMARY KEY (entry)"
            ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            kCreatureTemplateBackupTable);
    }

    struct DisableBaseState
    {
        bool hadRow = false;
        uint32 flags = 0;
    };

    DisableBaseState GetDisableBaseState(uint32 sourceType, uint32 entry)
    {
        QueryResult result = WorldDatabase.Query(
            "SELECT flags FROM disables WHERE sourceType = {} AND entry = {}",
            sourceType, entry);

        if (!result)
            return DisableBaseState{ false, 0 };

        Field* fields = result->Fetch();
        return DisableBaseState{ true, fields[0].Get<uint32>() };
    }

    void BackupDisableState(uint32 sourceType, uint32 entry, DisableBaseState const& state)
    {
        WorldDatabase.Execute(
            "REPLACE INTO {} (sourceType, entry, had_row, flags) VALUES ({}, {}, {}, {})",
            kDisablesBackupTable,
            sourceType,
            entry,
            state.hadRow ? 1 : 0,
            state.flags);
    }

    void RestoreDisableState(uint32 sourceType, uint32 entry, DisableBaseState const& state)
    {
        if (!state.hadRow)
        {
            WorldDatabase.Execute(
                "DELETE FROM disables WHERE sourceType = {} AND entry = {}",
                sourceType, entry);
            return;
        }

        // If the row exists, restore flags. If it doesn't, recreate with a safe comment.
        QueryResult existing = WorldDatabase.Query(
            "SELECT 1 FROM disables WHERE sourceType = {} AND entry = {}",
            sourceType, entry);

        if (existing)
        {
            WorldDatabase.Execute(
                "UPDATE disables SET flags = {} WHERE sourceType = {} AND entry = {}",
                state.flags, sourceType, entry);
        }
        else
        {
            WorldDatabase.Execute(
                "INSERT INTO disables (sourceType, entry, flags, params_0, params_1, comment) "
                "VALUES ({}, {}, {}, '', '', '[mod-progression-blizzlike] Restored base (custom lock)')",
                sourceType, entry, state.flags);
        }
    }

    struct CreatureTemplateBaseState
    {
        bool hadRow = false;
        uint32 npcflag = 0;
        uint32 gossipMenuId = 0;
    };

    CreatureTemplateBaseState GetCreatureTemplateBaseState(uint32 entry)
    {
        QueryResult result = WorldDatabase.Query(
            "SELECT npcflag, gossip_menu_id FROM creature_template WHERE entry = {}",
            entry);

        if (!result)
            return CreatureTemplateBaseState{ false, 0, 0 };

        Field* fields = result->Fetch();
        return CreatureTemplateBaseState{ true, fields[0].Get<uint32>(), fields[1].Get<uint32>() };
    }

    void BackupCreatureTemplateState(uint32 entry, CreatureTemplateBaseState const& state)
    {
        if (!state.hadRow)
            return;

        WorldDatabase.Execute(
            "REPLACE INTO {} (entry, npcflag, gossip_menu_id) VALUES ({}, {}, {})",
            kCreatureTemplateBackupTable,
            entry,
            state.npcflag,
            state.gossipMenuId);
    }

    void RestoreCreatureTemplateState(uint32 entry, CreatureTemplateBaseState const& state)
    {
        if (!state.hadRow)
            return;

        WorldDatabase.Execute(
            "UPDATE creature_template SET npcflag = {}, gossip_menu_id = {} WHERE entry = {}",
            state.npcflag,
            state.gossipMenuId,
            entry);
    }

    struct DesiredDisablesLock
    {
        uint32 sourceType;
        uint32 entry;
        enum class Mode { LockAll, LockHeroicOnly };
        Mode mode;
    };
}

void ProgressionSystemRestoreCustomLocks()
{
    bool const hasDisables = TableExists(kDisablesBackupTable);
    bool const hasCreatureTemplates = TableExists(kCreatureTemplateBackupTable);

    if (!hasDisables && !hasCreatureTemplates)
        return;

    uint32 restoredDisables = 0;
    uint32 restoredCreatures = 0;

    if (hasDisables)
    {
        QueryResult result = WorldDatabase.Query(
            "SELECT sourceType, entry, had_row, flags FROM {}",
            kDisablesBackupTable);

        if (result)
        {
            do
            {
                Field* fields = result->Fetch();
                uint32 const sourceType = fields[0].Get<uint32>();
                uint32 const entry = fields[1].Get<uint32>();
                bool const hadRow = fields[2].Get<uint8>() != 0;
                uint32 const flags = fields[3].Get<uint32>();

                RestoreDisableState(sourceType, entry, DisableBaseState{ hadRow, flags });
                ++restoredDisables;
            } while (result->NextRow());
        }
    }

    if (hasCreatureTemplates)
    {
        QueryResult result = WorldDatabase.Query(
            "SELECT entry, npcflag, gossip_menu_id FROM {}",
            kCreatureTemplateBackupTable);

        if (result)
        {
            do
            {
                Field* fields = result->Fetch();
                uint32 const entry = fields[0].Get<uint32>();
                uint32 const npcflag = fields[1].Get<uint32>();
                uint32 const gossipMenuId = fields[2].Get<uint32>();

                RestoreCreatureTemplateState(entry, CreatureTemplateBaseState{ true, npcflag, gossipMenuId });
                ++restoredCreatures;
            } while (result->NextRow());
        }
    }

    if (restoredDisables || restoredCreatures)
    {
        LOG_INFO("server.server",
            "[mod-progression-blizzlike] Restored custom locks base state: disables={} creature_template={}",
            restoredDisables, restoredCreatures);
    }
}

void ProgressionSystemApplyCustomLocks()
{
    bool const enabled = sConfigMgr->GetOption<bool>("ProgressionSystem.CustomLocks.Enabled", false);
    bool const debug = sConfigMgr->GetOption<bool>("ProgressionSystem.CustomLocks.Debug", false);

    bool const hasDisables = TableExists(kDisablesBackupTable);
    bool const hasCreatureTemplates = TableExists(kCreatureTemplateBackupTable);

    // If disabled, remove any previously tracked locks (state already restored in RestoreCustomLocks()).
    if (!enabled)
    {
        if (hasDisables)
            WorldDatabase.Execute("DELETE FROM {}", kDisablesBackupTable);
        if (hasCreatureTemplates)
            WorldDatabase.Execute("DELETE FROM {}", kCreatureTemplateBackupTable);

        if (debug && (hasDisables || hasCreatureTemplates))
        {
            LOG_INFO("server.server",
                "[mod-progression-blizzlike] CustomLocks.Enabled=0: cleared backup tracking tables.");
        }

        return;
    }

    EnsureBackupTablesExist();

    // -------------------------
    // Build desired lock sets
    // -------------------------
    uint32 const flagsAllMask = static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.CustomLocks.Maps.LockAll.FlagsMask", 15)));

    std::unordered_set<uint32> const lockAllMaps = ParseIdList(
        sConfigMgr->GetOption<std::string>("ProgressionSystem.CustomLocks.Maps.LockAll", ""));
    std::unordered_set<uint32> const lockHeroicOnlyMaps = ParseIdList(
        sConfigMgr->GetOption<std::string>("ProgressionSystem.CustomLocks.Maps.LockHeroicOnly", ""));

    std::unordered_set<uint32> const battlegroundIds = ParseIdList(
        sConfigMgr->GetOption<std::string>("ProgressionSystem.CustomLocks.Battlegrounds.Ids", ""));
    std::unordered_set<uint32> const battlegroundMapIds = ParseIdList(
        sConfigMgr->GetOption<std::string>("ProgressionSystem.CustomLocks.Battlegrounds.MapIds", ""));

    std::unordered_set<uint32> const npcClearFlagsEntries = ParseIdList(
        sConfigMgr->GetOption<std::string>("ProgressionSystem.CustomLocks.Npcs.ClearNpcFlags", ""));
    uint32 const npcClearMask = static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.CustomLocks.Npcs.ClearNpcFlags.Mask", 128)));

    std::unordered_set<uint64> desiredDisableKeys;
    std::vector<DesiredDisablesLock> desiredDisables;

    auto AddDisable = [&](uint32 sourceType, uint32 entry, DesiredDisablesLock::Mode mode)
    {
        uint64 const key = (static_cast<uint64>(sourceType) << 32) | static_cast<uint64>(entry);
        if (desiredDisableKeys.insert(key).second)
            desiredDisables.push_back(DesiredDisablesLock{ sourceType, entry, mode });
    };

    // Dungeons/instances by mapId (sourceType=2)
    for (uint32 id : lockAllMaps)
        AddDisable(2, id, DesiredDisablesLock::Mode::LockAll);
    for (uint32 id : lockHeroicOnlyMaps)
        AddDisable(2, id, DesiredDisablesLock::Mode::LockHeroicOnly);
    for (uint32 id : battlegroundMapIds)
        AddDisable(2, id, DesiredDisablesLock::Mode::LockAll);

    // Battlegrounds by battleground ID (sourceType=3)
    for (uint32 id : battlegroundIds)
        AddDisable(3, id, DesiredDisablesLock::Mode::LockAll);

    if (debug)
    {
        LOG_INFO("server.server",
            "[mod-progression-blizzlike] CustomLocks: maps_lock_all={} maps_lock_heroic_only={} bg_ids={} bg_map_ids={} npc_clear={} flagsAllMask={} npcClearMask={}",
            lockAllMaps.size(),
            lockHeroicOnlyMaps.size(),
            battlegroundIds.size(),
            battlegroundMapIds.size(),
            npcClearFlagsEntries.size(),
            flagsAllMask,
            npcClearMask);
    }

    // -------------------------
    // Cleanup backup entries that are no longer desired
    // (base state is already present after RestoreCustomLocks() + DBUpdater)
    // -------------------------
    if (TableExists(kDisablesBackupTable))
    {
        QueryResult result = WorldDatabase.Query(
            "SELECT sourceType, entry FROM {}",
            kDisablesBackupTable);

        if (result)
        {
            do
            {
                Field* fields = result->Fetch();
                uint32 const sourceType = fields[0].Get<uint32>();
                uint32 const entry = fields[1].Get<uint32>();
                uint64 const key = (static_cast<uint64>(sourceType) << 32) | static_cast<uint64>(entry);

                if (desiredDisableKeys.find(key) == desiredDisableKeys.end())
                    WorldDatabase.Execute("DELETE FROM {} WHERE sourceType = {} AND entry = {}", kDisablesBackupTable, sourceType, entry);
            } while (result->NextRow());
        }
    }

    if (TableExists(kCreatureTemplateBackupTable))
    {
        QueryResult result = WorldDatabase.Query(
            "SELECT entry FROM {}",
            kCreatureTemplateBackupTable);

        if (result)
        {
            do
            {
                Field* fields = result->Fetch();
                uint32 const entry = fields[0].Get<uint32>();
                if (npcClearFlagsEntries.find(entry) == npcClearFlagsEntries.end())
                    WorldDatabase.Execute("DELETE FROM {} WHERE entry = {}", kCreatureTemplateBackupTable, entry);
            } while (result->NextRow());
        }
    }

    // -------------------------
    // Apply disables custom locks
    // -------------------------
    for (DesiredDisablesLock const& lock : desiredDisables)
    {
        DisableBaseState const base = GetDisableBaseState(lock.sourceType, lock.entry);
        BackupDisableState(lock.sourceType, lock.entry, base);

        uint32 targetFlags = base.flags;
        if (lock.sourceType == 3)
        {
            // Battleground disable (sourceType=3): use flag bit 1.
            targetFlags = base.flags | 1;
        }
        else
        {
            // Map disable (sourceType=2): use the map flags mask.
            if (lock.mode == DesiredDisablesLock::Mode::LockHeroicOnly)
                targetFlags = (base.flags | 2) &~ 1;
            else
                targetFlags = base.flags | flagsAllMask;
        }

        if (base.hadRow)
        {
            WorldDatabase.Execute(
                "UPDATE disables SET flags = {} WHERE sourceType = {} AND entry = {}",
                targetFlags, lock.sourceType, lock.entry);
        }
        else
        {
            WorldDatabase.Execute(
                "INSERT INTO disables (sourceType, entry, flags, params_0, params_1, comment) "
                "VALUES ({}, {}, {}, '', '', '[mod-progression-blizzlike] Custom lock (config)')",
                lock.sourceType, lock.entry, targetFlags);
        }
    }

    // -------------------------
    // Apply NPC custom locks
    // -------------------------
    for (uint32 entry : npcClearFlagsEntries)
    {
        CreatureTemplateBaseState const base = GetCreatureTemplateBaseState(entry);
        BackupCreatureTemplateState(entry, base);

        if (!base.hadRow)
        {
            LOG_WARN("server.server",
                "[mod-progression-blizzlike] CustomLocks: creature_template entry {} not found (skipped).",
                entry);
            continue;
        }

        WorldDatabase.Execute(
            "UPDATE creature_template SET npcflag = npcflag &~ {} WHERE entry = {}",
            npcClearMask,
            entry);
    }
}
