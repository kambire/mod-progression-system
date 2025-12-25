-- 80 level range - Tier 10 (Fall of the Lich King) & Wrathful Gladiator

-- WotLK baseline lock (deny-by-default): ensure future 80 content is blocked even if earlier WotLK brackets were skipped.
-- This is safe because this bracket explicitly DELETEs from `disables` to unlock ICC 5-mans and ICC raid.
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

-- Makes instances (and RDF) Icecrown Citadel, The Forge of Souls, Pit of Saron and Halls of Reflection available again.
DELETE FROM `disables` WHERE `sourceType` IN (2, 8) AND `entry` IN (631,632,658,668);

-- Make the quests Inside the Frozen Citadel available again.
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` IN (24506, 24510);

-- Argent Tournament: should be available from Bracket_80_3 onward.
-- This also prevents bracket-skips (e.g. 80_2 -> 80_4_1) from leaving AT locked.
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` IN (
	13667, 13668, 13633, 13634,
	14016, 14105, 14101, 14102, 14104, 14107, 14108,
	14074, 14143, 14152, 14136, 14080, 14140, 14077, 14144,
	14096, 14142, 14076, 14092, 14090, 14141, 14112, 14145,
	13820, 13681, 13627
);

-- ICC 5-mans (FoS/PoS/HoR): re-enable dungeon-internal quests.
DELETE FROM `disables`
WHERE `sourceType` = 1 AND `comment` LIKE '[mod-progression-blizzlike] ICC5:%';

-- Makes the weekely gossip and quest/gossip flags for Archmage Lan'dalock
UPDATE `creature_template` SET `gossip_menu_id` = 10061, `npcflag` = `npcflag` | 3 WHERE `entry` = 20735;
