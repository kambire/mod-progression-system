-- 80_4_2: mantiene ICC abierto y Ruby Sanctum cerrado (Frostwing stage sin RS)

-- Mantener ICC e ICC5 abiertos desde brackets anteriores.
DELETE FROM `disables` WHERE `sourceType` IN (2, 8) AND `entry` IN (631, 632, 658, 668);

-- Ruby Sanctum sigue cerrado en este escalon.
DELETE FROM `disables` WHERE `sourceType` IN (2, 8) AND `entry` = 724;

-- Contenidos previos siguen abiertos.
DELETE FROM `disables` WHERE `sourceType` IN (2, 8) AND `entry` IN (249, 649, 650);
DELETE FROM `disables` WHERE `sourceType` IN (2, 8) AND `entry` IN (533, 603, 615, 616, 624);

-- Heroicas WotLK habilitadas y disponibles en RDF.
DELETE FROM `disables`
WHERE `sourceType` = 2 AND `entry` IN (574, 575, 576, 578, 595, 599, 600, 601, 602, 604, 608, 619);

DELETE FROM `disables`
WHERE `sourceType` = 8 AND `entry` IN (574, 575, 576, 578, 595, 599, 600, 601, 602, 604, 608, 619);

-- ICC raid quests abiertas; RS quest se mantiene cerrada.
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` IN (24506, 24510);

DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` = 26013;
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(1, 26013, 0, '', '', 'Assault on the Sanctum');

-- Archmage Lan'dalock y Argent Tournament siguen habilitados.
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` = 24582;

DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` IN (
	13667, 13668, 13633, 13634,
	14016, 14105, 14101, 14102, 14104, 14107, 14108,
	14074, 14143, 14152, 14136, 14080, 14140, 14077, 14144,
	14096, 14142, 14076, 14092, 14090, 14141, 14112, 14145,
	13820, 13681, 13627
);
