/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license: https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

#include "ProgressionSystem.h"

void AddSC_the_eye_70();

void AddBracket_70_3_B_Scripts()
{
    CHECK_BRACKET_ENABLED("70_3_2");

    AddSC_the_eye_70();
}
