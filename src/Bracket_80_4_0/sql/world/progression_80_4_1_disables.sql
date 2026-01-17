-- Propósito: desbloquear el contenido de T10 (ICC, ICC5 y Ruby Sanctum) y mantener abiertos contenidos previos al llegar a 80_4_1.
-- Alcance: limpia `disables` para raids/mazmorras/quests de WotLK ya liberadas, y vuelve a bloquear Ruby Sanctum hasta 80_4_2.
-- Seguridad: aplica deny-by-default y luego quita bloqueos para evitar saltos de bracket que dejen contenido cerrado.
-- Extras: reabre quests ICC5 e Archmage Lan'dalock, asegura Torneo Argenta activo desde 80_3 en adelante.

-- Makes instances (and RDF) Icecrown Citadel, The Forge of Souls, Pit of Saron and Halls of Reflection available again.
DELETE FROM `disables` WHERE `sourceType` IN (2, 8) AND `entry` IN (631,632,658,668);

-- Bracket-skip safety: keep ToC/Onyxia/Trial of the Champion available in later phases too.
-- (Onyxia 80 and Trial of the Crusader are enabled in Bracket_80_3.)
DELETE FROM `disables` WHERE `sourceType` IN (2, 8) AND `entry` IN (249, 649, 650);

-- Bracket-skip safety: keep earlier WotLK raids available as well.
DELETE FROM `disables` WHERE `sourceType` IN (2, 8) AND `entry` IN (533, 603, 615, 616, 624);

-- Ensure WotLK heroic dungeons are enabled as well.
DELETE FROM `disables`
WHERE `sourceType` = 2 AND `entry` IN (574, 575, 576, 578, 595, 599, 600, 601, 602, 604, 608, 619);

-- Ensure WotLK heroic dungeons are enabled in RDF/LFG as well (in case they were accidentally disabled).
DELETE FROM `disables`
WHERE `sourceType` = 8 AND `entry` IN (574, 575, 576, 578, 595, 599, 600, 601, 602, 604, 608, 619);

-- Make the quests Inside the Frozen Citadel available again.
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` IN (24506, 24510);

-- Ruby Sanctum: deny-by-default until Bracket_80_4_2.
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` = 26013;
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(1, 26013, 0, '', '', 'Assault on the Sanctum');

-- Unlock Archmage Lan'dalock quest
-- https://www.wowhead.com/wotlk/quest=24582/instructor-razuvious-must-die
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` = 24582;

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
