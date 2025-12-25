-- 80 level range - Ruby Sanctum

-- WotLK baseline lock (deny-by-default): ensure Ruby Sanctum is blocked until this bracket unlocks it.
-- This also protects servers that skip earlier WotLK brackets.
DELETE FROM `disables` WHERE `sourceType` = 2 AND `entry` IN (249, 631, 632, 649, 650, 658, 668, 724);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 249, 3, '', '', 'Onyxia Lair'),
(2, 631, 15, '', '', 'Icecrown Citadel'),
(2, 632, 3, '', '', 'The Forge of Souls'),
(2, 649, 15, '', '', 'Trial of The Crusader'),
(2, 650, 3, '', '', 'Trial of the Champion'),
(2, 658, 3, '', '', 'Pit of Saron'),
(2, 668, 3, '', '', 'Halls of Reflection'),
(2, 724, 15, '', '', 'The Ruby Sanctum');

-- Makes instance (and RDF) Ruby Sanctum available again.
DELETE FROM `disables` WHERE `sourceType` IN (2, 8) AND `entry` = 724;

-- Make the quest Assault on the Sanctum available again.
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` = 26013;
