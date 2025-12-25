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

-- Enable normal dungeons
UPDATE `disables` SET `flags` = `flags` &~1 WHERE `entry` IN (574, 575, 576, 578, 595, 599, 600, 601, 602, 604, 608, 619) AND `sourceType` = 2;

-- Don't allow to pick up quests that require you to go into locked instances.
DELETE FROM `disables` WHERE `sourceType`= 1 AND `entry` IN (24506, 24510, 24589, 26013);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES 
(1, 24506, 0, '', '', "Inside the Frozen Citadel (Horde)"),
(1, 24510, 0, '', '', "Inside the Frozen Citadel (Alliance)"), 
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
