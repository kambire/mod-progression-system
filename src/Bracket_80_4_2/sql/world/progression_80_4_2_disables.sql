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

-- Make the quests Inside the Frozen Citadel available again.
-- https://www.wowhead.com/wotlk/quest=24510/inside-the-frozen-citadel
-- https://www.wowhead.com/wotlk/quest=24506/inside-the-frozen-citadel
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` IN (24506, 24510);

-- Unlock Archmage Lan'dalock quest
-- https://www.wowhead.com/wotlk/quest=24582/instructor-razuvious-must-die
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` = 24582;

-- Argent Tournament: should be available from Bracket_80_3 onward.
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` IN (
	13667, 13668, 13633, 13634,
	14016, 14105, 14101, 14102, 14104, 14107, 14108,
	14074, 14143, 14152, 14136, 14080, 14140, 14077, 14144,
	14096, 14142, 14076, 14092, 14090, 14141, 14112, 14145,
	13820, 13681, 13627
);
