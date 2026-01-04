/*
 * This file is part of the AzerothCore Project. See AUTHORS file for Copyright information
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Affero General Public License as published by the
 * Free Software Foundation; either version 3 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "Chat.h"
#include "Config.h"
#include "DatabaseEnv.h"
#include "DBCEnums.h"
#include "Item.h"
#include "Player.h"
#include "ProgressionSystem.h"
#include "World.h"

#include <algorithm>

using namespace Acore::ChatCommands;

namespace
{
    // ICC 5-man dungeons (FoS/PoS/HoR)
    constexpr uint32 kMapForgeOfSouls = 632;
    constexpr uint32 kMapPitOfSaron = 658;
    constexpr uint32 kMapHallsOfReflection = 668;

    constexpr Difficulty kDungeonDifficultyNormal = static_cast<Difficulty>(0);
    constexpr Difficulty kDungeonDifficultyHeroic = static_cast<Difficulty>(1);

    bool IsIcc5Map(uint32 mapId)
    {
        return mapId == kMapForgeOfSouls || mapId == kMapPitOfSaron || mapId == kMapHallsOfReflection;
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

    float CalculateEquippedAverageItemLevel(Player* player)
    {
        if (!player)
            return 0.0f;

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

    struct HeroicGsDbRowGlobal
    {
        bool tablePresent = false;
        bool enabled = false;
        uint32 reqIcc5Normal = 0;
        uint32 reqIcc5Heroic = 0;
    };

    bool ProbeHeroicGsTablePresent()
    {
        QueryResult probe = WorldDatabase.Query("SHOW TABLES LIKE 'mod_progression_heroic_gs'");
        return !!probe;
    }

    HeroicGsDbRowGlobal ReadHeroicGsDbGlobal()
    {
        HeroicGsDbRowGlobal out;
        out.tablePresent = ProbeHeroicGsTablePresent();
        if (!out.tablePresent)
            return out;

        QueryResult result = WorldDatabase.Query(
            "SELECT enabled, required_icc5_normal, required_icc5_heroic "
            "FROM mod_progression_heroic_gs WHERE bracket='GLOBAL'");

        if (!result)
            return out;

        Field* fields = result->Fetch();
        out.enabled = fields[0].Get<uint8>() != 0;
        out.reqIcc5Normal = fields[1].Get<uint32>();
        out.reqIcc5Heroic = fields[2].Get<uint32>();

        return out;
    }

    uint32 ReadHeroicGsDbRequiredForBracket(std::string const& bracket)
    {
        if (bracket.empty())
            return 0;
        if (!ProbeHeroicGsTablePresent())
            return 0;

        QueryResult result = WorldDatabase.Query(
            "SELECT required_heroic FROM mod_progression_heroic_gs WHERE bracket='{}'",
            bracket);

        if (!result)
            return 0;
        return (*result)[0].Get<uint32>();
    }

    uint32 GetHeroicGsRequiredForCurrentBracket(uint32 mapId, Difficulty difficulty, std::string const& bracket)
    {
        HeroicGsDbRowGlobal const dbGlobal = ReadHeroicGsDbGlobal();

        // ICC5 overrides
        if (IsIcc5Map(mapId))
        {
            if (difficulty == kDungeonDifficultyHeroic)
            {
                if (dbGlobal.tablePresent && dbGlobal.reqIcc5Heroic > 0)
                    return dbGlobal.reqIcc5Heroic;
                return static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_Icc5_Heroic", 270)));
            }

            if (dbGlobal.tablePresent && dbGlobal.reqIcc5Normal > 0)
                return dbGlobal.reqIcc5Normal;
            return static_cast<uint32>(std::max<int32>(0, sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_Icc5_Normal", 250)));
        }

        // DB per bracket override
        if (dbGlobal.tablePresent)
        {
            uint32 const dbValue = ReadHeroicGsDbRequiredForBracket(bracket);
            if (dbValue > 0)
                return dbValue;

            if (bracket == "80_2_2")
            {
                uint32 const legacy = ReadHeroicGsDbRequiredForBracket("80_2");
                if (legacy > 0)
                    return legacy;
            }
        }

        // Conf fallback
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

        return 0;
    }

    bool IsHeroicGsGateEnabledEffective()
    {
        bool const enabledByConf = sConfigMgr->GetOption<bool>("ProgressionSystem.HeroicGs.Enabled", false);
        if (enabledByConf)
            return true;

        HeroicGsDbRowGlobal const dbGlobal = ReadHeroicGsDbGlobal();
        return dbGlobal.tablePresent && dbGlobal.enabled;
    }

    class ProgressionSystemAnnouncer : public PlayerScript
    {
    public:
        ProgressionSystemAnnouncer() : PlayerScript("ProgressionSystemAnnouncer") { }

        void OnLogin(Player* player) /* overrides old signature */
        {
            HandleLogin(player);
        }

        void OnLogin(Player* player, bool /*firstLogin*/) /* overrides new signature */
        {
            HandleLogin(player);
        }

    private:
        void HandleLogin(Player* player)
        {
            bool const announceGlobal = sConfigMgr->GetOption<bool>("ProgressionSystem.AnnounceNewBracket", false);
            bool const announcePersonal = sConfigMgr->GetOption<bool>("ProgressionSystem.BroadcastBracketActivation", false);

            if (!announceGlobal && !announcePersonal)
                return;

            std::string const bracket = GetHighestEnabledBracketName();
            if (bracket.empty())
                return;

            static std::string lastAnnounced;

            if (announceGlobal && bracket != lastAnnounced)
            {
                std::string const message = "[Progression] Nuevo bracket activo: " + bracket;
                // Use SendGlobalText for compatibility with cores lacking SendServerMessage.
                sWorld->SendGlobalText(message.c_str(), nullptr);
                lastAnnounced = bracket;
            }

            if (announcePersonal)
            {
                ChatHandler(player->GetSession()).PSendSysMessage("[Progression] Bracket activo: {}", bracket);
            }
        }
    };

}

class progression_module_commandscript : public CommandScript
{
public:
    progression_module_commandscript() : CommandScript("progression_module_commandscript") { }

    ChatCommandTable GetCommands() const override
    {
        static ChatCommandTable heroicGsTable =
        {
            { "me", HandleProgHeroicGsMeCommand, SEC_PLAYER, Console::No }
        };

        static ChatCommandTable arenaTable =
        {
            { "season", HandleProgArenaSeasonCommand, SEC_MODERATOR, Console::Yes }
        };

        static ChatCommandTable reloadTable =
        {
            { "heroicgs", HandleProgReloadHeroicGsCommand, SEC_ADMINISTRATOR, Console::Yes },
            { "all", HandleProgReloadAllCommand, SEC_ADMINISTRATOR, Console::Yes }
        };

        static ChatCommandTable proTable =
        {
            { "help", HandleProgHelpCommand, SEC_MODERATOR, Console::Yes },
            { "info", HandleProgModuleInfoCommand, SEC_MODERATOR, Console::Yes },
            { "status", HandleProgStatusCommand, SEC_MODERATOR, Console::Yes },
            { "heroicgs", heroicGsTable },
            { "arena", arenaTable },
            { "reload", reloadTable }
        };

        static ChatCommandTable commandTable =
        {
            // Short alias requested for in-game usage.
            { "pro", proTable },
            // Backward-compatible name.
            { "progression", proTable },
        };

        return commandTable;
    }

    static bool HandleProgHelpCommand(ChatHandler* handler)
    {
        handler->SendSysMessage("Progression Module Commands");
        handler->SendSysMessage(".pro help");
        handler->SendSysMessage(".pro info");
        handler->SendSysMessage(".pro status");
        handler->SendSysMessage(".pro heroicgs me");
        handler->SendSysMessage(".pro arena season");
        handler->SendSysMessage(".pro reload heroicgs");
        handler->SendSysMessage(".pro reload all");
        return true;
    }

    static bool HandleProgReloadHeroicGsCommand(ChatHandler* handler)
    {
        bool const tablePresent = ProgressionSystemReloadHeroicGsFromDb();
        if (!tablePresent)
        {
            handler->SendSysMessage("HeroicGs: table 'mod_progression_heroic_gs' not found (DB config disabled). Using .conf fallback.");
            return true;
        }

        handler->SendSysMessage("HeroicGs: reloaded DB config from 'mod_progression_heroic_gs'.");
        return true;
    }

    static bool HandleProgReloadAllCommand(ChatHandler* handler)
    {
        (void)ProgressionSystemReloadHeroicGsFromDb();
        handler->SendSysMessage("Progression: reloaded runtime DB-backed settings (HeroicGs). Note: .conf requires core '.reload config' or restart.");
        return true;
    }

    static bool HandleProgStatusCommand(ChatHandler* handler)
    {
        std::string const bracket = GetHighestEnabledBracketName();

        handler->SendSysMessage("Progression Status");
        handler->PSendSysMessage("Active bracket: {}", bracket.empty() ? "(none)" : bracket);

        bool const heroicEnabled = IsHeroicGsGateEnabledEffective();
        handler->PSendSysMessage("Heroic iLvl gate: {}", heroicEnabled ? "ON" : "OFF");

        HeroicGsDbRowGlobal const dbGlobal = ReadHeroicGsDbGlobal();
        if (dbGlobal.tablePresent)
            handler->PSendSysMessage("HeroicGs DB: present=1 enabled={}", dbGlobal.enabled ? 1 : 0);
        else
            handler->SendSysMessage("HeroicGs DB: present=0 (using .conf fallback)");

        // Bracket requirement summary (heroics). Map/difficulty are generic here.
        if (!bracket.empty())
        {
            uint32 const required = GetHeroicGsRequiredForCurrentBracket(/*mapId*/0, kDungeonDifficultyHeroic, bracket);
            handler->PSendSysMessage("Heroic requirement (avg iLvl): {}", required);
        }

        uint32 const icc5Normal = GetHeroicGsRequiredForCurrentBracket(kMapForgeOfSouls, kDungeonDifficultyNormal, bracket);
        uint32 const icc5Heroic = GetHeroicGsRequiredForCurrentBracket(kMapForgeOfSouls, kDungeonDifficultyHeroic, bracket);
        handler->PSendSysMessage("ICC5 requirements (avg iLvl): normal={} heroic={}", icc5Normal, icc5Heroic);

        return true;
    }

    static bool HandleProgHeroicGsMeCommand(ChatHandler* handler)
    {
        Player* player = handler->GetSession() ? handler->GetSession()->GetPlayer() : nullptr;
        if (!player)
        {
            handler->SendSysMessage("This command is only available in-game.");
            return true;
        }

        std::string const bracket = GetHighestEnabledBracketName();
        float const avgIlvl = CalculateEquippedAverageItemLevel(player);
        uint32 const required = GetHeroicGsRequiredForCurrentBracket(/*mapId*/0, kDungeonDifficultyHeroic, bracket);

        handler->SendSysMessage("HeroicGs (your character)");
        handler->PSendSysMessage("Active bracket: {}", bracket.empty() ? "(none)" : bracket);
        handler->PSendSysMessage("Avg iLvl: {:.1f}", avgIlvl);
        handler->PSendSysMessage("Required (heroics, avg iLvl): {}  Result: {}", required, (required == 0 || avgIlvl >= static_cast<float>(required)) ? "PASS" : "FAIL");
        return true;
    }

    static bool HandleProgArenaSeasonCommand(ChatHandler* handler)
    {
        handler->SendSysMessage("Arena Season -> Bracket mapping (config)");

        for (int season = 1; season <= 8; ++season)
        {
            std::string const key = "ProgressionSystem.Bracket.ArenaSeason" + std::to_string(season);
            std::string const enabledKey = key + ".Enabled";

            bool const enabled = sConfigMgr->GetOption<bool>(enabledKey, false);
            std::string const value = sConfigMgr->GetOption<std::string>(key, "");

            handler->PSendSysMessage("S{}: enabled={} value='{}'", season, enabled ? 1 : 0, value);
        }

        return true;
    }

    static bool HandleProgModuleInfoCommand(ChatHandler* handler)
    {
        handler->SendSysMessage("Progression Module Settings");

        handler->PSendSysMessage("LoadScripts: {}", sConfigMgr->GetOption<bool>("ProgressionSystem.LoadScripts", true));
        handler->PSendSysMessage("LoadDatabase: {}", sConfigMgr->GetOption<bool>("ProgressionSystem.LoadDatabase", true));
        handler->PSendSysMessage("ReapplyUpdates: {}", sConfigMgr->GetOption<bool>("ProgressionSystem.ReapplyUpdates", false));
        handler->PSendSysMessage("DisabledAttunements: '{}'", sConfigMgr->GetOption<std::string>("ProgressionSystem.DisabledAttunements", ""));

        uint32 enabledCount = 0;

        for (std::string const& bracketName : ProgressionBracketsNames)
        {
            bool const configEnabled = sConfigMgr->GetOption<bool>("ProgressionSystem.Bracket_" + bracketName, false);
            bool const enabled = IsProgressionBracketEnabled(bracketName);
            enabledCount += enabled ? 1 : 0;
            handler->PSendSysMessage("Bracket: {} (Config: {} Effective: {})", bracketName, configEnabled, enabled);
        }

        handler->PSendSysMessage("Enabled brackets: {}", enabledCount);

        return true;
    }
};

void AddSC_progression_module_commandscript()
{
    new ProgressionSystemAnnouncer();
    new progression_module_commandscript();
}
