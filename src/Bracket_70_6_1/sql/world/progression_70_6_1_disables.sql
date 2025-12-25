-- TBC Phase 5 - Magister's Terrace and Isle of Quel'Danas
DELETE FROM `disables` WHERE `entry` IN (585);

-- WotLK future lock (deny-by-default): keep ToC/Onyxia80 unavailable before Bracket_80_3 is enabled.
-- This is needed because some setups reach 70.x brackets before starting WotLK brackets, and RDF can bypass map-only locks.
DELETE FROM `disables` WHERE `sourceType` IN (2, 8) AND `entry` IN (249, 649, 650);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 249, 3, '', '', '[mod-progression-blizzlike] Locked (pre-80_3): Onyxia 80'),
(8, 249, 3, '', '', '[mod-progression-blizzlike] Locked (RDF, pre-80_3): Onyxia 80'),
(2, 649, 15, '', '', '[mod-progression-blizzlike] Locked (pre-80_3): Trial of the Crusader'),
(8, 649, 15, '', '', '[mod-progression-blizzlike] Locked (RDF, pre-80_3): Trial of the Crusader'),
(2, 650, 3, '', '', '[mod-progression-blizzlike] Locked (pre-80_3): Trial of the Champion'),
(8, 650, 3, '', '', '[mod-progression-blizzlike] Locked (RDF, pre-80_3): Trial of the Champion');
