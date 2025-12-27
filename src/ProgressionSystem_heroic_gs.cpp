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

#include <mutex>
#include <unordered_map>

namespace
{
    struct DbHeroicGsConfig
    {
        bool tablePresent = false;
        bool enabled = false;
        float avgIlvlMultiplier = 0.0f;
        uint32 requiredIcc5Normal = 0;
        uint32 requiredIcc5Heroic = 0;
        std::unordered_map<std::string, uint32> requiredByBracket;
    };

    DbHeroicGsConfig const& GetDbHeroicGsConfig()
    {
        static DbHeroicGsConfig cfg;
        static std::once_flag once;

        std::call_once(once, []()
        {
            // Probe for table existence without emitting SQL errors.
            QueryResult probe = WorldDatabase.Query("SHOW TABLES LIKE 'mod_progression_heroic_gs'");
            if (!probe)
            {
                cfg.tablePresent = false;
                return;
            }

            cfg.tablePresent = true;

            QueryResult result = WorldDatabase.Query(
                "SELECT bracket, enabled, avg_ilvl_multiplier, required_heroic, required_icc5_normal, required_icc5_heroic "
                "FROM mod_progression_heroic_gs");

            if (!result)
                return;

            do
            {
                Field* fields = result->Fetch();
                std::string const bracket = fields[0].Get<std::string>();
                bool const enabled = fields[1].Get<uint8>() != 0;
                float const mult = fields[2].Get<float>();
                uint32 const requiredHeroic = fields[3].Get<uint32>();
                uint32 const reqIcc5Normal = fields[4].Get<uint32>();
                uint32 const reqIcc5Heroic = fields[5].Get<uint32>();

                if (bracket == "GLOBAL")
                {
                    cfg.enabled = enabled;
                    cfg.avgIlvlMultiplier = mult;
                    cfg.requiredIcc5Normal = reqIcc5Normal;
                    cfg.requiredIcc5Heroic = reqIcc5Heroic;
                }
                else
                {
                    cfg.requiredByBracket[bracket] = requiredHeroic;
                }
            } while (result->NextRow());
        });

        return cfg;
    }

    bool IsHeroicGsGateEnabled()
    {
        bool const enabledByConf = sConfigMgr->GetOption<bool>("ProgressionSystem.HeroicGs.Enabled", false);
        if (enabledByConf)
            return true;

        DbHeroicGsConfig const& dbCfg = GetDbHeroicGsConfig();
        return dbCfg.tablePresent && dbCfg.enabled;
    }

    float GetAvgIlvlMultiplier()
    {
        float const multByConf = sConfigMgr->GetOption<float>("ProgressionSystem.HeroicGs.AvgIlvlMultiplier", 20.0f);
        DbHeroicGsConfig const& dbCfg = GetDbHeroicGsConfig();
        if (dbCfg.tablePresent && dbCfg.avgIlvlMultiplier > 0.0f)
            return dbCfg.avgIlvlMultiplier;
        return multByConf;
    }

    // ICC 5-man dungeons
    constexpr uint32 kMapForgeOfSouls = 632;
    constexpr uint32 kMapPitOfSaron = 658;
    constexpr uint32 kMapHallsOfReflection = 668;

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

    uint32 CalculatePseudoGsFromAvgIlvl(float avgIlvl)
    {
        float const multiplier = GetAvgIlvlMultiplier();
        float const pseudo = avgIlvl * multiplier;
        return pseudo > 0.0f ? static_cast<uint32>(pseudo + 0.5f) : 0;
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

    uint32 GetRequiredGsForCurrentBracket(uint32 mapId, Difficulty difficulty)
    {
        DbHeroicGsConfig const& dbCfg = GetDbHeroicGsConfig();

        // Instance-specific overrides for ICC 5-mans.
        if (IsIcc5Map(mapId))
        {
            if (difficulty == DIFFICULTY_HEROIC)
            {
                if (dbCfg.tablePresent && dbCfg.requiredIcc5Heroic > 0)
                    return dbCfg.requiredIcc5Heroic;
                return static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_Icc5_Heroic", 5400)));
            }

            // Normal mode (still an endgame dungeon set; optional requirement).
            if (dbCfg.tablePresent && dbCfg.requiredIcc5Normal > 0)
                return dbCfg.requiredIcc5Normal;
            return static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_Icc5_Normal", 5000)));
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
        }

        // Only enforce when a bracket explicitly provides a threshold.
        // Defaults target the WotLK heroic brackets.
        if (bracket == "80_1_2")
            return static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_1_2", 3500)));
        if (bracket == "80_2")
            return static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_2", 4000)));
        if (bracket == "80_3")
            return static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_3", 4400)));
        if (bracket == "80_4_1")
            return static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_4_1", 4800)));
        if (bracket == "80_4_2")
            return static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_4_2", 4800)));

        // Everything else: no GS gate by default.
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
            if (difficulty != DIFFICULTY_HEROIC && !IsIcc5Map(mapId))
                return;

            uint32 const requiredGs = GetRequiredGsForCurrentBracket(mapId, difficulty);
            if (requiredGs == 0)
                return;

            float const avgIlvl = CalculateEquippedAverageItemLevel(player);
            uint32 const pseudoGs = CalculatePseudoGsFromAvgIlvl(avgIlvl);

            if (pseudoGs >= requiredGs)
                return;

            ChatHandler(player->GetSession()).PSendSysMessage(
                "Necesitas GS %u (aprox, basado en iLvl promedio) para entrar aqui. Tu GS actual: %u (iLvl %.1f).",
                requiredGs, pseudoGs, avgIlvl);

            // Best-effort safe exit. (Core provides this on AzerothCore/Trinity-derived codebases.)
            player->TeleportToHomebind();
        }
    };
} // namespace

void AddProgressionSystemScripts();

// Register this script by linking it into the module TU set.
// Actual instantiation happens from AddProgressionSystemScripts() in ProgressionSystem.cpp.

void AddProgressionSystemHeroicGsScripts()
{
    new progression_heroic_gs_gate_playerscript();
}
