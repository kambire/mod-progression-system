/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license: https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

#include "ProgressionSystem.h"

#include "Chat.h"
#include "Config.h"
#include "DatabaseEnv.h"
#include "DBCEnums.h"
#include "Item.h"
#include "Map.h"
#include "Player.h"
#include "ScriptMgr.h"

#include <algorithm>
#include <mutex>
#include <unordered_map>

namespace
{
    struct DbHeroicGsConfig
    {
        bool tablePresent = false;
        bool enabled = false;
        uint32 requiredIcc5Normal = 0;
        uint32 requiredIcc5Heroic = 0;
        std::unordered_map<std::string, uint32> requiredByBracket;
    };

    DbHeroicGsConfig LoadDbHeroicGsConfig()
    {
        DbHeroicGsConfig cfg;

        // Probe for table existence without emitting SQL errors.
        QueryResult probe = WorldDatabase.Query("SHOW TABLES LIKE 'mod_progression_heroic_gs'");
        if (!probe)
        {
            cfg.tablePresent = false;
            return cfg;
        }

        cfg.tablePresent = true;

        QueryResult result = WorldDatabase.Query(
            "SELECT bracket, enabled, required_heroic, required_icc5_normal, required_icc5_heroic "
            "FROM mod_progression_heroic_gs");

        if (!result)
            return cfg;

        do
        {
            Field* fields = result->Fetch();
            std::string const bracket = fields[0].Get<std::string>();
            bool const enabled = fields[1].Get<uint8>() != 0;
            uint32 const requiredHeroic = fields[2].Get<uint32>();
            uint32 const reqIcc5Normal = fields[3].Get<uint32>();
            uint32 const reqIcc5Heroic = fields[4].Get<uint32>();

            if (bracket == "GLOBAL")
            {
                cfg.enabled = enabled;
                cfg.requiredIcc5Normal = reqIcc5Normal;
                cfg.requiredIcc5Heroic = reqIcc5Heroic;
            }
            else
            {
                cfg.requiredByBracket[bracket] = requiredHeroic;
            }
        } while (result->NextRow());

        return cfg;
    }

    std::mutex& GetDbHeroicGsConfigMutex()
    {
        static std::mutex m;
        return m;
    }

    DbHeroicGsConfig& GetDbHeroicGsConfigStorage()
    {
        static DbHeroicGsConfig cfg;
        return cfg;
    }

    bool& GetDbHeroicGsConfigLoaded()
    {
        static bool loaded = false;
        return loaded;
    }

    DbHeroicGsConfig GetDbHeroicGsConfigSnapshot()
    {
        std::lock_guard<std::mutex> lock(GetDbHeroicGsConfigMutex());
        DbHeroicGsConfig& cfg = GetDbHeroicGsConfigStorage();
        bool& loaded = GetDbHeroicGsConfigLoaded();

        if (!loaded)
        {
            cfg = LoadDbHeroicGsConfig();
            loaded = true;
        }

        return cfg;
    }

    bool ReloadDbHeroicGsConfig()
    {
        std::lock_guard<std::mutex> lock(GetDbHeroicGsConfigMutex());
        DbHeroicGsConfig& cfg = GetDbHeroicGsConfigStorage();
        bool& loaded = GetDbHeroicGsConfigLoaded();

        cfg = LoadDbHeroicGsConfig();
        loaded = true;

        return cfg.tablePresent;
    }

    bool IsHeroicGsGateEnabled()
    {
        bool const enabledByConf = sConfigMgr->GetOption<bool>("ProgressionSystem.HeroicGs.Enabled", false);
        if (enabledByConf)
            return true;

        DbHeroicGsConfig const dbCfg = GetDbHeroicGsConfigSnapshot();
        return dbCfg.tablePresent && dbCfg.enabled;
    }

    // ICC 5-man dungeons
    constexpr uint32 kMapForgeOfSouls = 632;
    constexpr uint32 kMapPitOfSaron = 658;
    constexpr uint32 kMapHallsOfReflection = 668;

    constexpr Difficulty kDungeonDifficultyHeroic = static_cast<Difficulty>(1);

    bool IsIcc5Map(uint32 mapId)
    {
        return mapId == kMapForgeOfSouls || mapId == kMapPitOfSaron || mapId == kMapHallsOfReflection;
    }

    float CalculateEquippedAverageItemLevel(Player* player)
    {
        // Compute based on equipped slots to avoid relying on core-specific helper APIs.
        uint32 sum = 0;
        uint32 count = 0;

        for (uint8 slot = EQUIPMENT_SLOT_START; slot < EQUIPMENT_SLOT_END; ++slot)
        {
            if (slot == EQUIPMENT_SLOT_BODY || slot == EQUIPMENT_SLOT_TABARD)
                continue;

            if (Item* item = player->GetItemByPos(INVENTORY_SLOT_BAG_0, slot))
            {
                if (ItemTemplate const* proto = item->GetTemplate())
                {
                    if (proto->ItemLevel > 0)
                    {
                        sum += proto->ItemLevel;
                        ++count;
                    }
                }
            }
        }

        return count ? (static_cast<float>(sum) / static_cast<float>(count)) : 0.0f;
    }

    std::string GetHighestEnabledBracketName()
    {
        std::string last;
        for (std::string const& bracketName : ProgressionBracketsNames)
        {
            if (!IsProgressionBracketEnabled(bracketName))
                continue;
            last = bracketName;
        }
        return last;
    }

    uint32 GetRequiredIlvlForCurrentBracket(uint32 mapId, Difficulty difficulty)
    {
        DbHeroicGsConfig const dbCfg = GetDbHeroicGsConfigSnapshot();

        // Instance-specific overrides for ICC 5-mans.
        if (IsIcc5Map(mapId))
        {
            if (difficulty == kDungeonDifficultyHeroic)
            {
                if (dbCfg.tablePresent && dbCfg.requiredIcc5Heroic > 0)
                    return dbCfg.requiredIcc5Heroic;
                return static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_Icc5_Heroic", 270)));
            }

            // Normal mode (still an endgame dungeon set; optional requirement).
            if (dbCfg.tablePresent && dbCfg.requiredIcc5Normal > 0)
                return dbCfg.requiredIcc5Normal;
            return static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_Icc5_Normal", 250)));
        }

        // Generic per-bracket requirements.
        std::string const bracket = GetHighestEnabledBracketName();
        if (bracket.empty())
            return 0;

        // DB override per bracket.
        if (dbCfg.tablePresent)
        {
            auto it = dbCfg.requiredByBracket.find(bracket);
            if (it != dbCfg.requiredByBracket.end() && it->second > 0)
                return it->second;

            // Backward compatibility: legacy bracket name used before the 80_2 split.
            if (bracket == "80_2_2")
            {
                auto legacy = dbCfg.requiredByBracket.find("80_2");
                if (legacy != dbCfg.requiredByBracket.end() && legacy->second > 0)
                    return legacy->second;
            }
        }

        // Only enforce when a bracket explicitly provides a threshold.
        // Defaults target the WotLK heroic brackets.
        if (bracket == "80_1_2")
            return static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_1_2", 175)));
        if (bracket == "80_2_1")
            return static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_2_1", 175)));
        if (bracket == "80_2_2")
        {
            int32 const value = sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_2_2",
                sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_2", 200));
            return static_cast<uint32>(std::max<int32>(0, value));
        }
        if (bracket == "80_3")
            return static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_3", 220)));
        if (bracket == "80_4_1")
            return static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_4_1", 240)));
        if (bracket == "80_4_2")
            return static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_4_2", 240)));

        // Everything else: no iLvl gate by default.
        return 0;
    }

    class progression_heroic_gs_gate_playerscript : public PlayerScript
    {
    public:
        progression_heroic_gs_gate_playerscript() : PlayerScript("progression_heroic_gs_gate_playerscript") { }

        void OnPlayerMapChanged(Player* player) override
        {
            if (!player || !player->GetSession())
                return;

            if (!IsHeroicGsGateEnabled())
                return;

            Map* map = player->GetMap();
            if (!map || !map->IsDungeon())
                return;

            uint32 const mapId = map->GetId();
            Difficulty const difficulty = map->GetDifficultyID();

            // Enforce for heroic dungeons, plus optional ICC5 normal-mode gate.
            if (difficulty != kDungeonDifficultyHeroic && !IsIcc5Map(mapId))
                return;

            uint32 const requiredIlvl = GetRequiredIlvlForCurrentBracket(mapId, difficulty);
            if (requiredIlvl == 0)
                return;

            float const avgIlvl = CalculateEquippedAverageItemLevel(player);
            if (avgIlvl >= static_cast<float>(requiredIlvl))
                return;

            ChatHandler(player->GetSession()).PSendSysMessage(
                "Necesitas un iLvl promedio minimo para entrar aqui. Requisito: %u. Tu iLvl promedio: %.1f.",
                requiredIlvl, avgIlvl);

            // Best-effort safe exit. (Core provides this on AzerothCore/Trinity-derived codebases.)
            player->TeleportToHomebind();
        }
    };
} // namespace

bool ProgressionSystemReloadHeroicGsFromDb()
{
    return ReloadDbHeroicGsConfig();
}

void AddProgressionSystemScripts();

// Register this script by linking it into the module TU set.
// Actual instantiation happens from AddProgressionSystemScripts() in ProgressionSystem.cpp.

void AddProgressionSystemHeroicGsScripts()
{
    new progression_heroic_gs_gate_playerscript();
}
