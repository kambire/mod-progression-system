-- Propósito: normalizar las recompensas de emblemas de las weekly raid quests (Archmage Lan'dalock) en bracket 80_4_1.
-- Resultado: todas las semanales 24579-24590 otorgan Emblema de Escarcha (49426) con cantidad por defecto 5 si estaba vacía.
-- Limpieza: elimina emblemas previos en RewardItem2-4 si son de WotLK para evitar duplicados.
-- Compatibilidad: válido para MySQL 8.x.

SET @TARGET_EMBLEM := 49426; -- Frost

UPDATE `quest_template`
SET
  `RewardItem1` = @TARGET_EMBLEM,
  `RewardAmount1` = IF(`RewardAmount1` > 0, `RewardAmount1`, 5),
  `RewardItem2` = IF(`RewardItem2` IN (40752,40753,45624,47241,49426), 0, `RewardItem2`),
  `RewardAmount2` = IF(`RewardItem2` IN (40752,40753,45624,47241,49426), 0, `RewardAmount2`),
  `RewardItem3` = IF(`RewardItem3` IN (40752,40753,45624,47241,49426), 0, `RewardItem3`),
  `RewardAmount3` = IF(`RewardItem3` IN (40752,40753,45624,47241,49426), 0, `RewardAmount3`),
  `RewardItem4` = IF(`RewardItem4` IN (40752,40753,45624,47241,49426), 0, `RewardItem4`),
  `RewardAmount4` = IF(`RewardItem4` IN (40752,40753,45624,47241,49426), 0, `RewardAmount4`)
WHERE `ID` IN (24579,24580,24581,24582,24583,24584,24585,24586,24587,24588,24589,24590);

