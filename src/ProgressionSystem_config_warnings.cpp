/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license:
 * https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

// NOTE:
// This file is intentionally excluded from compilation.
// Some AzerothCore module build setups compile only the *_loader.cpp TU.
// The warning logic is inlined in ProgressionSystem_loader.cpp.

#if 0

#include "Config.h"
#include "Log.h"

namespace
{
struct BoolOption
{
    char const* key;
    bool defaultValue;
};

struct IntOption
{
    char const* key;
    int32 defaultValue;
};

struct StringOption
{
    char const* key;
    char const* defaultValue;
};

// Options present in mod-progression-blizzlike.conf.dist but currently NOT implemented anywhere in this module.
// We emit warnings only when their configured value differs from the documented default.
BoolOption constexpr kUnsupportedBoolOptions[] =
{
    { "ProgressionSystem.EnforceItemRestrictions", false },
    { "ProgressionSystem.BlockFutureVendors", false },
    { "ProgressionSystem.EnforceArenaVendorProgression", false },
    { "ProgressionSystem.RestrictArenaRewards", false },
    { "ProgressionSystem.EnforceDungeonAttunement", false },
    { "ProgressionSystem.RequireSequentialProgression", false },
    { "ProgressionSystem.AllowDungeonBypass", true },
    { "ProgressionSystem.RaidDifficultyScaling", false },
    { "ProgressionSystem.LootProgressionSystem", false },
    { "ProgressionSystem.AnnounceNewBracket", false },
    { "ProgressionSystem.BroadcastBracketActivation", false },
    { "ProgressionSystem.TrackBracketProgress", false },
    { "ProgressionSystem.LogBracketActivity", false },
    { "ProgressionSystem.AutoEventScheduling", false },
    { "ProgressionSystem.TierCompletionBonus", false },
    { "ProgressionSystem.FirstKillBonus", false },
    { "ProgressionSystem.DynamicDifficultyScaling", false },
    { "ProgressionSystem.ResetRaidInstanceTimer", false },
    { "ProgressionSystem.DisableNextBracketItems", false },
    { "ProgressionSystem.BlockBracketTransition", false },
    { "ProgressionSystem.EnforceReputationRequirements", false },
    { "ProgressionSystem.RestrictBracketTeleporters", false },
    { "ProgressionSystem.NotifyRaidLeadersNewContent", false },

    { "ProgressionSystem.Arena.Season1.BracketRestriction", false },
    { "ProgressionSystem.Arena.Season2.BracketRestriction", false },
    { "ProgressionSystem.Arena.Season3.BracketRestriction", false },
    { "ProgressionSystem.Arena.Season4.BracketRestriction", false },
    { "ProgressionSystem.Arena.Season5.BracketRestriction", false },
    { "ProgressionSystem.Arena.Season6.BracketRestriction", false },
    { "ProgressionSystem.Arena.Season7.BracketRestriction", false },
    { "ProgressionSystem.Arena.Season8.BracketRestriction", false },

    { "ProgressionSystem.Bracket.ArenaSeason1.Enabled", false },
    { "ProgressionSystem.Bracket.ArenaSeason2.Enabled", false },
    { "ProgressionSystem.Bracket.ArenaSeason3.Enabled", false },
    { "ProgressionSystem.Bracket.ArenaSeason4.Enabled", false },
    { "ProgressionSystem.Bracket.ArenaSeason5.Enabled", false },
    { "ProgressionSystem.Bracket.ArenaSeason6.Enabled", false },
    { "ProgressionSystem.Bracket.ArenaSeason7.Enabled", false },
    { "ProgressionSystem.Bracket.ArenaSeason8.Enabled", false },

    { "ProgressionSystem.Vendor.BlockOutdatedInventory", false },
    { "ProgressionSystem.Vendor.AllowPreviousTierPurchase", true },
    { "ProgressionSystem.Vendor.RestrictPVPVendors", false },
    { "ProgressionSystem.Vendor.ShowCompatibleVendorsOnly", false },
};

IntOption constexpr kUnsupportedIntOptions[] =
{
    { "ProgressionSystem.WorldEventCooldown", 604800 },
    { "ProgressionSystem.ReminderTimerHours", 0 },
};

StringOption constexpr kUnsupportedStringOptions[] =
{
    { "ProgressionSystem.Bracket.ArenaSeason1", "Bracket_70_2_1,Bracket_70_2_2" },
    { "ProgressionSystem.Bracket.ArenaSeason2", "Bracket_70_2_2,Bracket_70_3_2,Bracket_70_4_1" },
    { "ProgressionSystem.Bracket.ArenaSeason3", "Bracket_70_5" },
    { "ProgressionSystem.Bracket.ArenaSeason4", "Bracket_70_6_2" },
    { "ProgressionSystem.Bracket.ArenaSeason5", "Bracket_80_1_2" },
    { "ProgressionSystem.Bracket.ArenaSeason6", "Bracket_80_2_2" },
    { "ProgressionSystem.Bracket.ArenaSeason7", "Bracket_80_3" },
    { "ProgressionSystem.Bracket.ArenaSeason8", "Bracket_80_4_1" },
};
} // namespace

void ProgressionSystemWarnUnsupportedConfigOptions()
{
    bool anyWarned = false;

    for (BoolOption const& opt : kUnsupportedBoolOptions)
    {
        bool const value = sConfigMgr->GetOption<bool>(opt.key, opt.defaultValue);
        if (value != opt.defaultValue)
        {
            anyWarned = true;
            LOG_WARN("server.server",
                "[mod-progression-blizzlike] Config option '{}' is set to {} but is NOT implemented in this module (ignored).",
                opt.key, value ? 1 : 0);
        }
    }

    for (IntOption const& opt : kUnsupportedIntOptions)
    {
        int32 const value = sConfigMgr->GetOption<int32>(opt.key, opt.defaultValue);
        if (value != opt.defaultValue)
        {
            anyWarned = true;
            LOG_WARN("server.server",
                "[mod-progression-blizzlike] Config option '{}' is set to {} but is NOT implemented in this module (ignored).",
                opt.key, value);
        }
    }

    for (StringOption const& opt : kUnsupportedStringOptions)
    {
        std::string const value = sConfigMgr->GetOption<std::string>(opt.key, opt.defaultValue);
        if (value != opt.defaultValue)
        {
            anyWarned = true;
            LOG_WARN("server.server",
                "[mod-progression-blizzlike] Config option '{}' is set to '{}' but is NOT implemented in this module (ignored).",
                opt.key, value);
        }
    }

    if (anyWarned)
    {
        LOG_WARN("server.server",
            "[mod-progression-blizzlike] Some ProgressionSystem.* options are currently placeholders. Only keys used via sConfigMgr->GetOption in this module have effect.");
    }
}

#endif
