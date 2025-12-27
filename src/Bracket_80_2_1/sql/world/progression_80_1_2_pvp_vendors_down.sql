DELETE FROM `game_event_creature` WHERE `guid` IN (152028, 152031) AND `eventEntry` = 57;
INSERT INTO `game_event_creature` (`eventEntry`, `guid`) VALUES
(57,152028),
(57,152031);

-- Restore vendors visibility for players (unhide from GM-only phasemask).
UPDATE `creature` SET `phaseMask` = 1 WHERE `guid` IN (133920, 125693, 125691, 133917);
