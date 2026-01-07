/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license: https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

#ifndef _PROGRESSION_SYSTEM_H_
#define _PROGRESSION_SYSTEM_H_

#include "Config.h"
#include "ScriptMgr.h"

#define PROGRESSION_BRACKET_MAX 47
std::array<std::string, PROGRESSION_BRACKET_MAX> const ProgressionBracketsNames =
{
    "0",
    "1_19",
    "20_29",
    "30_39",
    "40_49",
    "50_59_1",
    "50_59_2",
    "60_1_1",
    "60_1_2",
    "60_2_1",
    "60_2_2",
    "60_3_1",
    "60_3_2",
    "60_3_3",
    "61_64",
    "65_69",
    "70_1_1",
    "70_1_2",
    "70_2_1",
    "70_2_2",
    "70_2_3",
    "70_3_1",
    "70_3_2",
    "70_4_1",
    "70_4_2",
    "70_5",
    "70_6_1",
    "70_6_2",
    "70_6_3",
    "71_74",
    "75_79",
    "80_1_1",
    "80_1_2",
    "80_2_1",
    "80_2_2",
    "80_2_2_1",
    "80_2_2_2",
    "80_2_2_3",
    "80_2_2_4",
    "80_3",
    "80_3_1",
    "80_3_2",
    "80_4_0",
    "80_4_1",
    "80_4_2",
    "80_4_3",
    "Custom"
};

// Returns whether a bracket is effectively enabled.
// A bracket is enabled if either:
// - ProgressionSystem.Bracket_<name> = 1, OR
// - It is included in any enabled ArenaSeason mapping (ProgressionSystem.Bracket.ArenaSeasonN.Enabled).
bool IsProgressionBracketEnabled(std::string const& bracketName);

// Reloads the optional DB-backed HeroicGs configuration (mod_progression_heroic_gs).
// Returns true if the table is present; false if missing.
bool ProgressionSystemReloadHeroicGsFromDb();

#endif // _PROGRESSION_SYSTEM_H_
