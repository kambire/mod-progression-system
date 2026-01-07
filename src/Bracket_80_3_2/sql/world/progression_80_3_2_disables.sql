-- Bracket 80_3_2 (Frozen Halls solo) - abre FoS/PoS/HoR sin habilitar ICC ni RS
-- Objetivo: intermedio entre ToC y ICC. Desbloquea ICC5 (632/658/668) y sus quests, mantiene ICC raid (631) y RS (724) cerrados.

-- Limpia locks previos y vuelve a aplicar baseline para futuros tiers
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

-- Bloqueo RDF baseline
DELETE FROM `disables` WHERE `sourceType` = 8 AND `entry` IN (249, 631, 632, 649, 650, 658, 668);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(8, 249, 3, '', '', '[mod-progression-blizzlike] Locked (RDF): Onyxia 80'),
(8, 631, 15, '', '', '[mod-progression-blizzlike] Locked (RDF): Icecrown Citadel'),
(8, 632, 3, '', '', '[mod-progression-blizzlike] Locked (RDF): The Forge of Souls'),
(8, 649, 15, '', '', '[mod-progression-blizzlike] Locked (RDF): Trial of the Crusader'),
(8, 650, 3, '', '', '[mod-progression-blizzlike] Locked (RDF): Trial of the Champion'),
(8, 658, 3, '', '', '[mod-progression-blizzlike] Locked (RDF): Pit of Saron'),
(8, 668, 3, '', '', '[mod-progression-blizzlike] Locked (RDF): Halls of Reflection');

-- Abrir Frozen Halls (solo 5-man) en este bracket
DELETE FROM `disables` WHERE `sourceType` IN (2, 8) AND `entry` IN (632, 658, 668);

-- ICC raid y RS siguen bloqueados
-- Nada que tocar aquí: 631 y 724 permanecen en disables anteriores.

-- Quitar bloqueo de quests internas de ICC5
DELETE FROM `disables`
WHERE `sourceType` = 1 AND `comment` LIKE '[mod-progression-blizzlike] ICC5:%';

-- Mantener bloqueadas las quests de ICC raid y Ruby Sanctum
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` IN (24506, 24510);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(1, 24506, 0, '', '', 'Inside the Frozen Citadel (Horde)'),
(1, 24510, 0, '', '', 'Inside the Frozen Citadel (Alliance)')
ON DUPLICATE KEY UPDATE `flags`=VALUES(`flags`),`comment`=VALUES(`comment`);

DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` = 26013;
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(1, 26013, 0, '', '', 'Assault on the Sanctum')
ON DUPLICATE KEY UPDATE `flags`=VALUES(`flags`),`comment`=VALUES(`comment`);

-- Lan'dalock sigue bloqueado (solo se abre en 80_4_1)
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` = 24582;
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(1, 24582, 0, '', '', "[mod-progression-blizzlike] Lan'dalock: Instructor Razuvious Must Die")
ON DUPLICATE KEY UPDATE `flags`=VALUES(`flags`),`comment`=VALUES(`comment`);
