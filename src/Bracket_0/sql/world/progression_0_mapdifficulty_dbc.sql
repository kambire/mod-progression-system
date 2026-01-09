-- Ajuste base de tamaños de banda (progresión clásica):
-- - Limpia IDs 24/34/39/44 de mapdifficulty_dbc por si existen.
-- - Reinsertar con los nuevos tamaños:
--   229 Blackrock Spire 10p (Difficulty=0, sin lockout)
--   409 Molten Core 20p (lockout 7d)  [nota: más adelante se sube a 25p en el bracket 60_2_2]
--   469 Blackwing Lair 25p (lockout 7d)
--   531 AQ40 25p (lockout 7d)
-- El campo Difficultystring queda con la etiqueta 40p por compatibilidad visual; el límite real lo impone MaxPlayers.
DELETE FROM `mapdifficulty_dbc` WHERE `ID` IN (24,34,39,44);
INSERT INTO `mapdifficulty_dbc` (`ID`, `MapID`, `Difficulty`, `RaidDuration`, `MaxPlayers`, `Difficultystring`) VALUES
(24, 229, 0, 0, 10, ''), -- Blackrock Spire
(34, 409, 0, 604800, 20, 'RAID_DIFFICULTY_40PLAYER'), -- MC - Updated to 25 in the 60_2_2 Bracket
(39, 469, 0, 604800, 25, 'RAID_DIFFICULTY_40PLAYER'), -- BWL
(44, 531, 0, 604800, 25, 'RAID_DIFFICULTY_40PLAYER'); -- AQ40