-- 71-74 level range - Utgarde Keep, The Nexus, Drak’Tharon Keep, Azjol-Nerub, Ahn’kahet: The Old Kingdom


-- IMPORTANT (WotLK baseline lock):
-- Los locks deny-by-default (instancias/raids futuras + RDF) se aplican en Bracket_0.
-- Los brackets de expansión (71_74 en adelante) solo deben hacer DELETE para habilitar lo que corresponda.

-- Archmage Lan'dalock quest: must NOT be available until Bracket_80_4.
-- https://www.wowhead.com/wotlk/quest=24582/instructor-razuvious-must-die
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` = 24582;
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(1, 24582, 0, '', '', "[mod-progression-blizzlike] Lan'dalock: Instructor Razuvious Must Die");

-- Block quests that require locked ICC content (deny-by-default).
-- Alliance: Inside the Frozen Citadel (24510)
-- Horde: Inside the Frozen Citadel (24506)
-- https://www.wowhead.com/wotlk/quest=24510/inside-the-frozen-citadel
-- https://www.wowhead.com/wotlk/quest=24506/inside-the-frozen-citadel
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` IN (24506, 24510);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(1, 24506, 0, '', '', "Inside the Frozen Citadel (Horde)"),
(1, 24510, 0, '', '', "Inside the Frozen Citadel (Alliance)");

-- Ruby Sanctum: deny-by-default until Bracket_80_4_2.
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` = 26013;
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(1, 26013, 0, '', '', 'Assault on the Sanctum');

-- Argent Tournament: should NOT be available at the start of WotLK.
-- We block all known AT quest IDs here (deny-by-default). Bracket_80_3 will unlock them.
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` IN (
	13667, 13668, 13633, 13634,
	14016, 14105, 14101, 14102, 14104, 14107, 14108,
	14074, 14143, 14152, 14136, 14080, 14140, 14077, 14144,
	14096, 14142, 14076, 14092, 14090, 14141, 14112, 14145,
	13820, 13681, 13627
);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(1, 13667, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Alliance'),
(1, 13668, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Horde'),
(1, 13633, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Black Knight (Westfall)'),
(1, 13634, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Black Knight (Silverpine)'),
(1, 14016, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Black Knight''s Curse'),
(1, 14105, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Deathspeaker Kharos'),
(1, 14101, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Drottin Hrothgar'),
(1, 14102, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Mistcaller Yngvar'),
(1, 14104, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Ornolf the Scarred'),
(1, 14107, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - The Fate of the Fallen'),
(1, 14108, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Get Kraken!'),
(1, 14074, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - A Leg Up (Alliance)'),
(1, 14143, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - A Leg Up (Horde)'),
(1, 14152, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Rescue at Sea (Alliance)'),
(1, 14136, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Rescue at Sea (Horde)'),
(1, 14080, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Stop the Aggressors (Alliance)'),
(1, 14140, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Stop the Aggressors (Horde)'),
(1, 14077, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - The Light''s Mercy (Alliance)'),
(1, 14144, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - The Light''s Mercy (Horde)'),
(1, 14096, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - You''ve Really Done It This Time, Kul (Alliance)'),
(1, 14142, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - You''ve Really Done It This Time, Kul (Horde)'),
(1, 14076, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Breakfast Of Champions (Alliance)'),
(1, 14092, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Breakfast Of Champions (Horde)'),
(1, 14090, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Gormok Wants His Snobolds (Alliance)'),
(1, 14141, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Gormok Wants His Snobolds (Horde)'),
(1, 14112, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - What Do You Feed a Yeti, Anyway? (Alliance)'),
(1, 14145, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - What Do You Feed a Yeti, Anyway? (Horde)'),
	(1, 13820, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Construction (Blastbolt Brothers)'),
	(1, 13681, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Construction (Ulduar Block)'),
	(1, 13627, 0, '', '', '[mod-progression-blizzlike] Argent Tournament - Construction (Lumber)');

-- Bracket-skip safety: ensure Northrend dungeon rows exist so we can reliably lock heroics.
-- (Some setups enable 71_74 without enabling Bracket_0 which inserts the baseline `disables` rows.)
INSERT IGNORE INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 574, 3, '', '', 'Utgarde Keep'),
(2, 575, 3, '', '', 'Utgarde Pinnacle'),
(2, 576, 3, '', '', 'The Nexus'),
(2, 578, 3, '', '', 'The Oculus'),
(2, 595, 3, '', '', 'The Culling of Stratholme'),
(2, 599, 3, '', '', 'Halls of Stone'),
(2, 600, 3, '', '', 'Drak''Tharon Keep'),
(2, 601, 3, '', '', 'Azjol-Nerub'),
(2, 602, 3, '', '', 'Halls of Lightning'),
(2, 604, 3, '', '', 'Gundrak'),
(2, 608, 3, '', '', 'Violet Hold'),
(2, 619, 3, '', '', 'Ahn''kahet: The Old Kingdom');

-- Keep higher-level Northrend dungeons locked (both normal + heroic).
UPDATE `disables` SET `flags` = `flags` | 3
WHERE `sourceType` = 2 AND `entry` IN (575, 578, 595, 599, 602, 604, 608);

-- Enable 71-74 normal dungeons, keep heroic locked.
UPDATE `disables` SET `flags` = (`flags` | 2) &~ 1
WHERE `sourceType` = 2 AND `entry` IN (574, 576, 600, 601, 619);
