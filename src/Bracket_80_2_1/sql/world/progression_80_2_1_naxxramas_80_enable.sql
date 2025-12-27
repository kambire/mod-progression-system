-- Naxxramas 80 (Level 80 Raid Tier 1)
-- Enables Naxxramas at level 80 difficulty
-- Uncomment/Comment bosses based on phase progression

-- Enable Naxxramas 80 version creatures
UPDATE `creature` SET `phaseMask` = 1 WHERE `map` = 533 AND `id1` IN (
    29122, -- Anub'Rekhan (Arachnid Quarter)
    29123, -- Grand Widow Faerlina
    29124, -- Maexxna
    29125, -- Patchwerk (Plague Quarter)
    29126, -- Grobbulus
    29127, -- Gluth
    29128, -- Thaddius
    29129, -- Instructor Razuvious (Military Quarter)
    29130, -- Four Horsemen
    29131, -- Sapphiron (Frost Wing)
    29132  -- Kel'Thuzad
);

-- Naxxramas 80 trash mobs and encounters
-- Already configured by default in AzerothCore Tier 1 content

-- Eye of Eternity (Obsidian Sanctum bonus boss)
-- Enable Malygos encounter
UPDATE `creature` SET `phaseMask` = 1 WHERE `map` = 616 AND `id1` IN (
    28860,  -- Malygos
    27635   -- Alexstrasza the Life-Binder (Phase 3)
);

-- Obsidian Sanctum (Sartharion with Dragons)
UPDATE `creature` SET `phaseMask` = 1 WHERE `map` = 615 AND `id1` IN (
    25038,  -- Sartharion
    25040,  -- Tenebron
    25041,  -- Shadron
    25042   -- Vesperon
);
