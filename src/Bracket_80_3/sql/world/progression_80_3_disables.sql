-- 80 level range - Tier 9 (Call of the Crusade) & Relentless Gladiator

-- WotLK baseline lock (deny-by-default): ensure future 80 content is blocked even if earlier WotLK brackets were skipped.
-- This is safe because this bracket explicitly DELETEs from `disables` to unlock ToC/Onyxia.
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

-- Extra hard-lock for RDF/LFG teleport (deny-by-default):
DELETE FROM `disables` WHERE `sourceType` = 8 AND `entry` IN (631, 632, 658, 668);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(8, 631, 15, '', '', '[mod-progression-blizzlike] Locked (RDF): Icecrown Citadel'),
(8, 632, 3, '', '', '[mod-progression-blizzlike] Locked (RDF): The Forge of Souls'),
(8, 658, 3, '', '', '[mod-progression-blizzlike] Locked (RDF): Pit of Saron'),
(8, 668, 3, '', '', '[mod-progression-blizzlike] Locked (RDF): Halls of Reflection');

-- Makes instances (and RDF) Trial of the Crusader available again.
-- NOTE: Onyxia (249) is intentionally kept locked until Bracket_80_4.
-- NOTE: Trial of the Champion (650) is intentionally kept locked.
DELETE FROM `disables` WHERE `sourceType` IN (2, 8) AND `entry` IN (649);

-- Keep Trial of the Champion locked completely (including RDF).
DELETE FROM `disables` WHERE `sourceType` IN (2, 8) AND `entry` = 650;
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 650, 3, '', '', '[mod-progression-blizzlike] Locked: Trial of the Champion'),
(8, 650, 3, '', '', '[mod-progression-blizzlike] Locked (RDF): Trial of the Champion');

-- Make the quests  Lord Jaraxxus Must Die! and available again.
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` = 24589;

-- Archmage Lan'dalock quest: must NOT be available until Bracket_80_4.
-- https://www.wowhead.com/wotlk/quest=24582/instructor-razuvious-must-die
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` = 24582;
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(1, 24582, 0, '', '', "[mod-progression-blizzlike] Lan'dalock: Instructor Razuvious Must Die");

-- Argent Tournament: unlock in Bracket_80_3.
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` IN (
	13667, 13668, 13633, 13634,
	14016, 14105, 14101, 14102, 14104, 14107, 14108,
	14074, 14143, 14152, 14136, 14080, 14140, 14077, 14144,
	14096, 14142, 14076, 14092, 14090, 14141, 14112, 14145,
	13820, 13681, 13627
);

-- Block quests that require locked ICC content (deny-by-default).
-- Alliance: Inside the Frozen Citadel (24510)
-- Horde: Inside the Frozen Citadel (24506)
-- NOTE: These quests must only be enabled in Bracket_80_4.
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` IN (24506, 24510);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(1, 24506, 0, '', '', "Inside the Frozen Citadel (Horde)"),
(1, 24510, 0, '', '', "Inside the Frozen Citadel (Alliance)");
