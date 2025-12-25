-- Removes frozo's items
UPDATE `creature` SET `phaseMask` = 16384 WHERE `guid`=202846 AND `id1` = 40160;
