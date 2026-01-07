-- ============================================================================
-- Override final de emblemas: fuerza el esquema de 80_2_1 aun con brackets posteriores
-- Objetivo:
--   - Raids 10 -> Heroism (40752), Raids 25 -> Valor (40753)
--   - Heroic 5-man bosses -> Heroism (40752)
--   - RDF: primera heroica del dia (quest 24788) = 2 Valor, resto = Heroism
--   - Dailies de Dalaran: normales 2x Heroism, heroicas 2x Valor
-- Coloca este archivo al final (Bracket_80_4_2) para que se aplique despues de cualquier subida de emblemas.
-- ============================================================================

-- ----------------------------
-- Config comun de emblemas
-- ----------------------------
SET @EMBLEM_HERO := 40752;
SET @EMBLEM_VALOR := 40753;
SET @EMBLEM_SET := '40752,40753,45624,47241,49426';

-- ----------------------------
-- Raids: 10 -> Heroism, 25 -> Valor
-- ----------------------------
SET @RAID_MAPS := '533,615,616';
SELECT COUNT(*) INTO @HAS_CREATURE_ID1
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'creature'
  AND COLUMN_NAME = 'id1';
SET @CREATURE_ENTRY_COL := IF(@HAS_CREATURE_ID1 = 1, 'cr.`id1`', 'cr.`id`');

-- creature_loot_template
SET @SQL := CONCAT(
  'UPDATE `creature_loot_template` cl ',
  'JOIN `creature_template` ct ON ct.`entry` = cl.`entry` ',
  'JOIN `creature` cr ON ', @CREATURE_ENTRY_COL, ' = cl.`entry` ',
  'SET cl.`Item` = IF(cr.`spawnMask` & 2 OR cr.`spawnMask` & 8, ', @EMBLEM_VALOR, ', ', @EMBLEM_HERO, ') ',
  'WHERE cl.`Item` IN (', @EMBLEM_SET, ') ',
  '  AND ct.`rank` = 3 ',
  '  AND cr.`map` IN (', @RAID_MAPS, ')'
);
PREPARE stmt FROM @SQL; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- reference_loot_template
SET @SQL := CONCAT(
  'UPDATE `reference_loot_template` rl ',
  'JOIN `creature_loot_template` cl ON cl.`Reference` = rl.`Entry` ',
  'JOIN `creature_template` ct ON ct.`entry` = cl.`entry` ',
  'JOIN `creature` cr ON ', @CREATURE_ENTRY_COL, ' = cl.`entry` ',
  'SET rl.`Item` = IF(cr.`spawnMask` & 2 OR cr.`spawnMask` & 8, ', @EMBLEM_VALOR, ', ', @EMBLEM_HERO, ') ',
  'WHERE rl.`Item` IN (', @EMBLEM_SET, ') ',
  '  AND ct.`rank` = 3 ',
  '  AND cr.`map` IN (', @RAID_MAPS, ')'
);
PREPARE stmt FROM @SQL; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- gameobject_loot_template (cofres)
UPDATE `gameobject_loot_template` gl
JOIN `gameobject_template` got ON got.`type` = 3 AND got.`data1` = gl.`entry`
JOIN `gameobject` go ON go.`id` = got.`entry`
SET gl.`Item` = IF(go.`spawnMask` & 2 OR go.`spawnMask` & 8, @EMBLEM_VALOR, @EMBLEM_HERO)
WHERE gl.`Item` IN (40752,40753,45624,47241,49426)
  AND go.`map` IN (533, 615, 616);

-- ----------------------------
-- Heroic 5-man bosses -> Heroism
-- ----------------------------
SET @MAPS_HEROIC := '574,575,576,578,595,599,600,601,602,604,608,619';

-- creature_loot_template
SET @SQL := CONCAT(
  'UPDATE `creature_loot_template` cl ',
  'JOIN `creature_template` ct ON ct.`entry` = cl.`entry` ',
  'SET cl.`Item` = ', @EMBLEM_HERO, ' ',
  'WHERE cl.`Item` IN (', @EMBLEM_SET, ') ',
  '  AND cl.`Item` <> ', @EMBLEM_HERO, ' ',
  '  AND ct.`rank` = 3 ',
  '  AND EXISTS (SELECT 1 FROM `creature` cr WHERE cr.`map` IN (', @MAPS_HEROIC, ') AND ', @CREATURE_ENTRY_COL, ' = cl.`entry`)
');
PREPARE stmt FROM @SQL; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- reference_loot_template
SET @SQL := CONCAT(
  'UPDATE `reference_loot_template` rl ',
  'JOIN `creature_loot_template` cl ON cl.`Reference` = rl.`Entry` ',
  'JOIN `creature_template` ct ON ct.`entry` = cl.`entry` ',
  'SET rl.`Item` = ', @EMBLEM_HERO, ' ',
  'WHERE rl.`Item` IN (', @EMBLEM_SET, ') ',
  '  AND rl.`Item` <> ', @EMBLEM_HERO, ' ',
  '  AND ct.`rank` = 3 ',
  '  AND EXISTS (SELECT 1 FROM `creature` cr WHERE cr.`map` IN (', @MAPS_HEROIC, ') AND ', @CREATURE_ENTRY_COL, ' = cl.`entry`)
');
PREPARE stmt FROM @SQL; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- gameobject_loot_template (cofres en heroicos)
UPDATE `gameobject_loot_template` gl
JOIN `gameobject_template` got ON got.`type` = 3 AND got.`data1` = gl.`entry`
JOIN `gameobject` go ON go.`id` = got.`entry`
SET gl.`Item` = @EMBLEM_HERO
WHERE gl.`Item` IN (40752,40753,45624,47241,49426)
  AND gl.`Item` <> @EMBLEM_HERO
  AND go.`map` IN (574,575,576,578,595,599,600,601,602,604,608,619);

-- ----------------------------
-- RDF / Dailies: recompensa de emblemas acorde a 80_2_1
-- ----------------------------
-- RDF first/other
UPDATE `quest_template`
SET `rewarditem1` = @EMBLEM_VALOR, `RewardAmount1` = 2
WHERE `ID` = 24788;

UPDATE `quest_template`
SET `rewarditem1` = @EMBLEM_HERO, `RewardAmount1` = 1
WHERE `ID` IN (24789,24790);

-- Dalaran daily normal (Timear Foresees...)
UPDATE `quest_template` SET `rewarditem1` = @EMBLEM_HERO, `RewardAmount1` = 2
WHERE `ID` IN (13240,13241,13243,13244);

-- Dalaran daily heroic (Proof of Demise...)
UPDATE `quest_template` SET `rewarditem1` = @EMBLEM_VALOR, `RewardAmount1` = 2
WHERE `ID` IN (13245,13246,13247,13248,13249,13250,13251,13252,13253,13254,13255,13256);

-- Asegurar mapping de LFG rewards (heroic RDF apunta a estas quests)
UPDATE `lfg_dungeon_rewards` SET `firstQuestId` = 24788, `otherQuestId` = 24789
WHERE `dungeonId` IN (261, 262) AND `maxLevel` = 80;

-- Fin del override
