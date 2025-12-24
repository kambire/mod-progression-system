/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license: https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

#include "ProgressionSystem.h"

void AddSC_karazhan_70();

void AddBracket_70_2_B_Scripts()
{
    CHECK_BRACKET_ENABLED("70_2_2");

    AddSC_karazhan_70();
}
