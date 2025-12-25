-- 71-74 level range - Utgarde Keep, The Nexus, Drak’Tharon Keep, Azjol-Nerub, Ahn’kahet: The Old Kingdom

-- IMPORTANT (WotLK baseline lock):
-- This is the first WotLK bracket. We must ensure future 80 content is locked from the start of Northrend.
-- Some servers/world DBs do not have baseline `disables` rows inserted for ICC/ToC/RS/Onyxia80.
-- If these rows do not exist, the instances can be accessible earlier than intended.
--
-- NOTE: "locked/blocked" here means "access denied" via `world.disables`.
-- It does NOT delete any instance content from the DB; players will simply be prevented from entering.
--
-- Locks applied here:
-- - ICC raid + ICC 5-mans: 631, 632, 658, 668
-- - ToC raid + ToC 5-man: 649, 650
-- - Onyxia (reworked): 249
-- - Ruby Sanctum: 724
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

UPDATE `disables` SET `flags`=`flags`&~1 WHERE `entry` IN (574, 576, 600, 601, 619);
