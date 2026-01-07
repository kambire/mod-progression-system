/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license: https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

#include "Config.h"
#include "Define.h"
#include "Log.h"
#include "ProgressionSystem.h"
#include "GameEventMgr.h"
#include "Tokenize.h"

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

    // Options present in mod-progression-blizzlike.conf.dist but not implemented in this module (currently none).
    BoolOption constexpr kUnsupportedBoolOptions[] = {};

    IntOption constexpr kUnsupportedIntOptions[] = {};

    StringOption constexpr kUnsupportedStringOptions[] = {};
}

namespace
{
    std::string Trim(std::string s)
    {
        auto const first = s.find_first_not_of(" \t\r\n");
        if (first == std::string::npos)
            return std::string();
        auto const last = s.find_last_not_of(" \t\r\n");
        s = s.substr(first, last - first + 1);
        return s;
    }

    bool IsKnownBracket(std::string const& bracketName)
    {
        for (std::string const& known : ProgressionBracketsNames)
        {
            if (known == bracketName)
                return true;
        }
        return false;
    }

    void WarnIfIntOutOfRange(char const* key, int32 value, int32 minInclusive, int32 maxInclusive)
    {
        if (value < minInclusive || value > maxInclusive)
        {
            LOG_WARN("server.server",
                "[mod-progression-blizzlike] Config option '{}'={} is outside expected range [{}..{}].",
                key, value, minInclusive, maxInclusive);
        }
    }

    void ProgressionSystemWarnInvalidConfigOptions()
    {
        // Debug options (sanity only; values are still clamped where used).
        WarnIfIntOutOfRange("ProgressionSystem.Debug.MaxSqlLogLines",
            sConfigMgr->GetOption<int32>("ProgressionSystem.Debug.MaxSqlLogLines", 200),
            0,
            5000);

        WarnIfIntOutOfRange("ProgressionSystem.Debug.SqlLogDelayMs",
            sConfigMgr->GetOption<int32>("ProgressionSystem.Debug.SqlLogDelayMs", 0),
            0,
            10000);

        WarnIfIntOutOfRange("ProgressionSystem.Debug.BracketApplyDelayMs",
            sConfigMgr->GetOption<int32>("ProgressionSystem.Debug.BracketApplyDelayMs", 0),
            0,
            10000);

        // Heroic iLvl gate thresholds (WotLK sanity).
        WarnIfIntOutOfRange("ProgressionSystem.HeroicGs.Required_80_1_2",
            sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_1_2", 175),
            0,
            400);
        WarnIfIntOutOfRange("ProgressionSystem.HeroicGs.Required_80_2_1",
            sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_2_1", 175),
            0,
            400);
        WarnIfIntOutOfRange("ProgressionSystem.HeroicGs.Required_80_2_2",
            sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_2_2", 200),
            0,
            400);
        WarnIfIntOutOfRange("ProgressionSystem.HeroicGs.Required_80_2",
            sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_2", 200),
            0,
            400);
        WarnIfIntOutOfRange("ProgressionSystem.HeroicGs.Required_80_3",
            sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_3", 220),
            0,
            400);
        WarnIfIntOutOfRange("ProgressionSystem.HeroicGs.Required_80_4_1",
            sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_4_1", 240),
            0,
            400);
        WarnIfIntOutOfRange("ProgressionSystem.HeroicGs.Required_80_4_2",
            sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_80_4_2", 240),
            0,
            400);
        WarnIfIntOutOfRange("ProgressionSystem.HeroicGs.Required_Icc5_Normal",
            sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_Icc5_Normal", 250),
            0,
            400);
        WarnIfIntOutOfRange("ProgressionSystem.HeroicGs.Required_Icc5_Heroic",
            sConfigMgr->GetOption<int32>("ProgressionSystem.HeroicGs.Required_Icc5_Heroic", 270),
            0,
            400);

        // CustomLocks masks (these are bitmasks, but common values are small).
        WarnIfIntOutOfRange("ProgressionSystem.CustomLocks.Maps.LockAll.FlagsMask",
            sConfigMgr->GetOption<int32>("ProgressionSystem.CustomLocks.Maps.LockAll.FlagsMask", 15),
            0,
            15);
        WarnIfIntOutOfRange("ProgressionSystem.CustomLocks.Npcs.ClearNpcFlags.Mask",
            sConfigMgr->GetOption<int32>("ProgressionSystem.CustomLocks.Npcs.ClearNpcFlags.Mask", 128),
            0,
            0x7FFFFFFF);

        // Cross-option sanity: some features require LoadDatabase=1 because they run inside DBUpdater hook.
        bool const loadDatabase = sConfigMgr->GetOption<bool>("ProgressionSystem.LoadDatabase", true);
        bool const customLocksEnabled = sConfigMgr->GetOption<bool>("ProgressionSystem.CustomLocks.Enabled", false);
        std::string disabledAttunements = Trim(sConfigMgr->GetOption<std::string>("ProgressionSystem.DisabledAttunements", ""));

        if (!loadDatabase)
        {
            if (customLocksEnabled)
            {
                LOG_WARN("server.server",
                    "[mod-progression-blizzlike] CustomLocks.Enabled=1 but LoadDatabase=0. Custom locks will NOT be applied.");
            }

            if (!disabledAttunements.empty())
            {
                LOG_WARN("server.server",
                    "[mod-progression-blizzlike] DisabledAttunements is set but LoadDatabase=0. Attunements will NOT be cleared.");
            }
        }

        // Arena season mappings: warn for unknown bracket tokens when enabled.
        for (int season = 1; season <= 8; ++season)
        {
            std::string const key = "ProgressionSystem.Bracket.ArenaSeason" + std::to_string(season);
            std::string const enabledKey = key + ".Enabled";

            bool const enabled = sConfigMgr->GetOption<bool>(enabledKey, false, false);
            if (!enabled)
                continue;

            std::string mapping = sConfigMgr->GetOption<std::string>(key, "", false);
            mapping = Trim(std::move(mapping));

            if (mapping.empty())
            {
                LOG_WARN("server.server",
                    "[mod-progression-blizzlike] {}=1 but '{}' is empty; no brackets will be enabled by this mapping.",
                    enabledKey,
                    key);
                continue;
            }

            for (auto tokenView : Acore::Tokenize(mapping, ',', false))
            {
                std::string token(tokenView);
                token = Trim(std::move(token));
                if (token.empty())
                    continue;

                constexpr char const* kPrefix = "Bracket_";
                if (token.rfind(kPrefix, 0) == 0)
                    token.erase(0, std::char_traits<char>::length(kPrefix));

                if (!IsKnownBracket(token))
                {
                    LOG_WARN("server.server",
                        "[mod-progression-blizzlike] '{}' contains unknown bracket token '{}'. Valid examples: Bracket_80_2_1 or 80_2_1.",
                        key,
                        token);
                }
            }
        }
    }
}

static void ProgressionSystemAutoStartArenaEvents()
{
    if (!sConfigMgr->GetOption<bool>("ProgressionSystem.Arena.AutoStartEvents", false, false))
        return;

    struct SeasonEvent
    {
        uint8 season;
        uint32 eventId;
    };

    constexpr SeasonEvent kSeasonEvents[] = {
        {1, 75}, {2, 76}, {3, 55}, {4, 56}, {5, 57}, {6, 58}, {7, 59}, {8, 60}
    };

    for (SeasonEvent const& se : kSeasonEvents)
    {
        std::string const enabledKey = "ProgressionSystem.Bracket.ArenaSeason" + std::to_string(se.season) + ".Enabled";
        bool const enabled = sConfigMgr->GetOption<bool>(enabledKey, false, false);
        if (!enabled)
            continue;

        if (sGameEventMgr->IsActiveEvent(se.eventId))
            continue;

        sGameEventMgr->StartEvent(se.eventId, true);
        LOG_INFO("server.server",
            "[mod-progression-blizzlike] Auto-started Arena Season {} (game_event {}).", se.season, se.eventId);
    }
}
static void ProgressionSystemLogEffectiveConfig()
{
    bool const loadScripts = sConfigMgr->GetOption<bool>("ProgressionSystem.LoadScripts", true);
    bool const loadDatabase = sConfigMgr->GetOption<bool>("ProgressionSystem.LoadDatabase", true);
    bool const reapplyUpdates = sConfigMgr->GetOption<bool>("ProgressionSystem.ReapplyUpdates", false);

    uint32 enabledBrackets = 0;
    for (std::string const& bracketName : ProgressionBracketsNames)
    {
        if (IsProgressionBracketEnabled(bracketName))
            ++enabledBrackets;
    }

    LOG_INFO("server.server",
        "[mod-progression-blizzlike] Effective config: LoadScripts={} LoadDatabase={} ReapplyUpdates={}",
        loadScripts ? 1 : 0, loadDatabase ? 1 : 0, reapplyUpdates ? 1 : 0);
    LOG_INFO("server.server",
        "[mod-progression-blizzlike] If these values do not match your expectations, ensure your config is copied to etc/modules/*.conf (e.g. etc/modules/mod-progression-blizzlike.conf) and contains a [worldserver] section.");

    LOG_INFO("server.server",
        "[mod-progression-blizzlike] Enabled brackets detected: {}",
        enabledBrackets);

    if (enabledBrackets == 0)
    {
        LOG_WARN("server.server",
            "[mod-progression-blizzlike] No ProgressionSystem.Bracket_* are enabled. If you expected bracket SQL/scripts to load, ensure you're editing the active etc/modules/*.conf (not the .conf.dist template).");
    }
}

static void ProgressionSystemWarnUnsupportedConfigOptions()
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

void AddProgressionSystemScripts();
void AddBracket_0_Scripts();
void AddBracket_1_19_Scripts();
void AddBracket_20_29_Scripts();
void AddBracket_30_39_Scripts();
void AddBracket_40_49_Scripts();
void AddBracket_50_59_A_Scripts();
void AddBracket_50_59_B_Scripts();
void AddBracket_60_1_Scripts();
void AddBracket_60_1_A_Scripts();
void AddBracket_60_2_Scripts();
void AddBracket_60_2_A_Scripts();
void AddBracket_60_3_A_Scripts();
void AddBracket_60_3_B_Scripts();
void AddBracket_60_3_C_Scripts();
void AddBracket_61_64_Scripts();
void AddBracket_65_69_Scripts();
void AddBracket_70_1_A_Scripts();
void AddBracket_70_1_B_Scripts();
void AddBracket_70_2_A_Scripts();
void AddBracket_70_2_B_Scripts();
void AddBracket_70_2_C_Scripts();
void AddBracket_70_3_A_Scripts();
void AddBracket_70_3_B_Scripts();
void AddBracket_70_4_A_Scripts();
void AddBracket_70_4_B_Scripts();
void AddBracket_70_5_Scripts();
void AddBracket_70_6_A_Scripts();
void AddBracket_70_6_B_Scripts();
void AddBracket_70_6_C_Scripts();
void AddBracket_71_74_Scripts();
void AddBracket_75_79_Scripts();
void AddBracket_80_1_A_Scripts();
void AddBracket_80_1_B_Scripts();
void AddBracket_80_2_1_Scripts();
void AddBracket_80_2_2_Scripts();
void AddBracket_80_2_2_1_Scripts();
void AddBracket_80_2_2_2_Scripts();
void AddBracket_80_2_2_3_Scripts();
void AddBracket_80_2_2_4_Scripts();
void AddBracket_80_3_Scripts();
void AddBracket_80_3_1_Scripts();
void AddBracket_80_4_0_Scripts();
void AddBracket_80_4_A_Scripts();
void AddBracket_80_4_B_Scripts();
void AddBracket_80_4_3_Scripts();
void AddBracket_Custom_Scripts();
void AddSC_progression_module_commandscript();

void Addmod_progression_systemScripts()
{
    ProgressionSystemWarnUnsupportedConfigOptions();

    ProgressionSystemLogEffectiveConfig();
    ProgressionSystemWarnInvalidConfigOptions();
    ProgressionSystemAutoStartArenaEvents();

    AddProgressionSystemScripts();
    AddSC_progression_module_commandscript();

    if (!sConfigMgr->GetOption<bool>("ProgressionSystem.LoadScripts", true))
        return;

    AddBracket_0_Scripts();
    AddBracket_1_19_Scripts();
    AddBracket_20_29_Scripts();
    AddBracket_30_39_Scripts();
    AddBracket_40_49_Scripts();
    AddBracket_50_59_A_Scripts();
    AddBracket_50_59_B_Scripts();
    AddBracket_60_1_Scripts();
    AddBracket_60_1_A_Scripts();
    AddBracket_60_2_Scripts();
    AddBracket_60_2_A_Scripts();
    AddBracket_60_3_A_Scripts();
    AddBracket_60_3_B_Scripts();
    AddBracket_60_3_C_Scripts();
    AddBracket_61_64_Scripts();
    AddBracket_65_69_Scripts();
    AddBracket_70_1_A_Scripts();
    AddBracket_70_1_B_Scripts();
    AddBracket_70_2_A_Scripts();
    AddBracket_70_2_B_Scripts();
    AddBracket_70_2_C_Scripts();
    AddBracket_70_3_A_Scripts();
    AddBracket_70_3_B_Scripts();
    AddBracket_70_4_A_Scripts();
    AddBracket_70_4_B_Scripts();
    AddBracket_70_5_Scripts();
    AddBracket_70_6_A_Scripts();
    AddBracket_70_6_B_Scripts();
    AddBracket_70_6_C_Scripts();
    AddBracket_71_74_Scripts();
    AddBracket_75_79_Scripts();
    AddBracket_80_1_A_Scripts();
    AddBracket_80_1_B_Scripts();
    AddBracket_80_2_1_Scripts();
    AddBracket_80_2_2_Scripts();
    AddBracket_80_2_2_1_Scripts();
    AddBracket_80_2_2_2_Scripts();
    AddBracket_80_2_2_3_Scripts();
    AddBracket_80_2_2_4_Scripts();
    AddBracket_80_3_Scripts();
    AddBracket_80_3_1_Scripts();
    AddBracket_80_4_0_Scripts();
    AddBracket_80_4_A_Scripts();
    AddBracket_80_4_B_Scripts();
    AddBracket_80_4_3_Scripts();
    AddBracket_Custom_Scripts();
}

// AzerothCore module loader entrypoint (must match module folder name)
void Addmod_progression_blizzlikeScripts()
{
    Addmod_progression_systemScripts();
}
