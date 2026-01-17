-- 80 level range - Tier 9 (Call of the Crusade) & Relentless Gladiator

-- Makes instances (and RDF) Trial of the Crusader, Trial of the Champion and Onyxia 80 available again.
DELETE FROM `disables` WHERE `sourceType` IN (2, 8) AND `entry` IN (249, 649, 650);

-- Bracket-skip safety: keep earlier WotLK raids available in later phases too.
DELETE FROM `disables` WHERE `sourceType` IN (2, 8) AND `entry` IN (533, 603, 615, 616, 624);

-- Ensure WotLK heroic dungeons are enabled as well.
DELETE FROM `disables`
WHERE `sourceType` = 2 AND `entry` IN (574, 575, 576, 578, 595, 599, 600, 601, 602, 604, 608, 619);

-- Ensure WotLK heroic dungeons are enabled in RDF/LFG as well (in case they were accidentally disabled).
DELETE FROM `disables`
WHERE `sourceType` = 8 AND `entry` IN (574, 575, 576, 578, 595, 599, 600, 601, 602, 604, 608, 619);

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

-- Ruby Sanctum: deny-by-default until Bracket_80_4_2.
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` = 26013;
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(1, 26013, 0, '', '', 'Assault on the Sanctum');
