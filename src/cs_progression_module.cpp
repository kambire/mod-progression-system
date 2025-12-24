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
#include "ProgressionSystem.h"

using namespace Acore::ChatCommands;

class progression_module_commandscript : public CommandScript
{
public:
    progression_module_commandscript() : CommandScript("progression_module_commandscript") { }

    ChatCommandTable GetCommands() const override
    {
        static ChatCommandTable progressionTable =
        {
            { "info",    HandleProgModuleInfoCommand,    SEC_MODERATOR, Console::Yes },
            { "status",  HandleProgModuleStatusCommand,  SEC_MODERATOR, Console::Yes },
            { "list",    HandleProgModuleListCommand,    SEC_MODERATOR, Console::Yes }
        };

        static ChatCommandTable commandTable =
        {
            { "progression", progressionTable },
        };

        return commandTable;
    }

    static bool HandleProgModuleInfoCommand(ChatHandler* handler)
    {
        handler->SendSysMessage("=== Progression System Module ===");
        handler->PSendSysMessage("Version: 1.0");
        handler->PSendSysMessage("Total Brackets: {}", PROGRESSION_BRACKET_MAX);
        handler->PSendSysMessage("Load Scripts: {}", sConfigMgr->GetOption<bool>("ProgressionSystem.LoadScripts", true) ? "Enabled" : "Disabled");
        handler->PSendSysMessage("Load Database: {}", sConfigMgr->GetOption<bool>("ProgressionSystem.LoadDatabase", true) ? "Enabled" : "Disabled");
        handler->PSendSysMessage("Reapply Updates: {}", sConfigMgr->GetOption<bool>("ProgressionSystem.ReapplyUpdates", false) ? "Enabled" : "Disabled");
        handler->SendSysMessage("================================");
        handler->SendSysMessage("Use '.progression list' to see all brackets");
        handler->SendSysMessage("Use '.progression status' to see active brackets");

        return true;
    }

    static bool HandleProgModuleStatusCommand(ChatHandler* handler)
    {
        handler->SendSysMessage("=== Active Progression Brackets ===");
        
        uint32 activeCount = 0;
        for (std::string const& bracketName : ProgressionBracketsNames)
        {
            if (sConfigMgr->GetOption<bool>("ProgressionSystem.Bracket_" + bracketName, false))
            {
                handler->PSendSysMessage("  [ACTIVE] Bracket_{}", bracketName);
                activeCount++;
            }
        }
        
        if (activeCount == 0)
        {
            handler->SendSysMessage("  No brackets are currently active");
        }
        
        handler->PSendSysMessage("================================");
        handler->PSendSysMessage("Total Active: {} / {}", activeCount, PROGRESSION_BRACKET_MAX);

        return true;
    }

    static bool HandleProgModuleListCommand(ChatHandler* handler)
    {
        handler->SendSysMessage("=== All Progression Brackets ===");

        for (std::string const& bracketName : ProgressionBracketsNames)
        {
            bool enabled = sConfigMgr->GetOption<bool>("ProgressionSystem.Bracket_" + bracketName, false);
            handler->PSendSysMessage("  Bracket_{}: {}", bracketName, enabled ? "[ENABLED]" : "[DISABLED]");
        }

        handler->SendSysMessage("================================");
        handler->SendSysMessage("Use '.progression status' to see only active brackets");

        return true;
    }
};

void AddSC_progression_module_commandscript()
{
    new progression_module_commandscript();
}
