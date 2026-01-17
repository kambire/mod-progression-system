-- Bracket 80_3_2 (Frozen Halls solo) - abre FoS/PoS/HoR sin habilitar ICC ni RS
-- Objetivo: intermedio entre ToC y ICC. Desbloquea ICC5 (632/658/668) y sus quests, mantiene ICC raid (631) y RS (724) cerrados.

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
(1, 24510, 0, '', '', 'Inside the Frozen Citadel (Alliance)');

DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` = 26013;
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(1, 26013, 0, '', '', 'Assault on the Sanctum');

-- Lan'dalock sigue bloqueado (solo se abre en 80_4_1)
DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` = 24582;
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(1, 24582, 0, '', '', "[mod-progression-blizzlike] Lan'dalock: Instructor Razuvious Must Die");
