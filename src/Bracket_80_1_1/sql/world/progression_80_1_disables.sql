-- WotLK baseline lock (deny-by-default): ensure future 80 content is blocked even if earlier WotLK brackets were skipped.
-- This is safe because later brackets explicitly DELETE from `disables` to unlock what they need.
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
DELETE FROM `disables` WHERE `sourceType` = 8 AND `entry` IN (249, 631, 632, 649, 650, 658, 668);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(8, 249, 3, '', '', '[mod-progression-blizzlike] Locked (RDF): Onyxia 80'),
(8, 631, 15, '', '', '[mod-progression-blizzlike] Locked (RDF): Icecrown Citadel'),
(8, 632, 3, '', '', '[mod-progression-blizzlike] Locked (RDF): The Forge of Souls'),
(8, 649, 15, '', '', '[mod-progression-blizzlike] Locked (RDF): Trial of the Crusader'),
(8, 650, 3, '', '', '[mod-progression-blizzlike] Locked (RDF): Trial of the Champion'),
(8, 658, 3, '', '', '[mod-progression-blizzlike] Locked (RDF): Pit of Saron'),
(8, 668, 3, '', '', '[mod-progression-blizzlike] Locked (RDF): Halls of Reflection');

-- Argent Tournament: deny-by-default until Bracket_80_3.
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

-- Enable normal dungeons
UPDATE `disables` SET `flags` = `flags` &~1 WHERE `entry` IN (574, 575, 576, 578, 595, 599, 600, 601, 602, 604, 608, 619) AND `sourceType` = 2;

-- Don't allow to pick up quests that require you to go into locked instances.
DELETE FROM `disables` WHERE `sourceType`= 1 AND `entry` IN (24506, 24510, 24582, 24589, 26013);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES 
(1, 24506, 0, '', '', "Inside the Frozen Citadel (Horde)"),
(1, 24510, 0, '', '', "Inside the Frozen Citadel (Alliance)"), 
(1, 24582, 0, '', '', "[mod-progression-blizzlike] Lan'dalock: Instructor Razuvious Must Die"),
(1, 24589, 0, '', '', "Lord Jaraxxus Must Die!"),
(1, 26013, 0, '', '', "Assault on the Sanctum");

-- ICC 5-mans (FoS/PoS/HoR): block dungeon-internal quests while the dungeons are locked.
-- This is computed dynamically from quest starters/enders that spawn inside maps 632/658/668.
-- We store a stable comment prefix so later brackets can reliably remove these disables.
DELETE FROM `disables`
WHERE `sourceType` = 1 AND `comment` LIKE '[mod-progression-blizzlike] ICC5:%';

INSERT IGNORE INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`)
SELECT
	1 AS sourceType,
	q.quest AS entry,
	0 AS flags,
	'' AS params_0,
	'' AS params_1,
	CONCAT('[mod-progression-blizzlike] ICC5: ', q.quest) AS comment
FROM (
	SELECT DISTINCT qs.`quest`
	FROM `creature_queststarter` qs
	JOIN `creature` c ON c.`id1` = qs.`id`
	WHERE c.`map` IN (632, 658, 668)
	UNION
	SELECT DISTINCT qe.`quest`
	FROM `creature_questender` qe
	JOIN `creature` c ON c.`id1` = qe.`id`
	WHERE c.`map` IN (632, 658, 668)
) q;

-- Removes the weekely gossip and quest/gossip flags for Archmage Lan'dalock
UPDATE `creature_template` SET `gossip_menu_id` = 0, `npcflag` = `npcflag` &~ 3 WHERE `entry` = 20735;
