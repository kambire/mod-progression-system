-- Bracket 80_3_2 - Emblemas para Frozen Halls (FoS/PoS/HoR) en parche 3.3
-- Heroicas en mapas 632/658/668 deben dar Triunfo (47241)

SET @TARGET_EMBLEM := 47241; -- Triumph
SET @MAPS := '632,658,668';

-- Compatibilidad id/id1
SELECT COUNT(*) INTO @HAS_CREATURE_ID1
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'creature'
  AND COLUMN_NAME = 'id1';

SET @CREATURE_ENTRY_COL := IF(@HAS_CREATURE_ID1 = 1, 'cr.`id1`', 'cr.`id`');

-- Loot directo
SET @SQL := CONCAT(
  'UPDATE `creature_loot_template` cl ',
  'JOIN `creature_template` ct ON ct.`entry` = cl.`entry` ',
  'SET cl.`Item` = ', @TARGET_EMBLEM, ' ',
  'WHERE cl.`Item` IN (40752,40753,45624,47241,49426) ',
  '  AND cl.`Item` <> ', @TARGET_EMBLEM, ' ',
  '  AND ct.`rank` = 3 ',
  '  AND EXISTS (',
  '    SELECT 1 FROM `creature` cr ',
  '    WHERE cr.`map` IN (', @MAPS, ') ',
  '      AND ', @CREATURE_ENTRY_COL, ' = cl.`entry`',
  '  )'
);
PREPARE stmt FROM @SQL; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Loot por referencia
SET @SQL := CONCAT(
  'UPDATE `reference_loot_template` rl ',
  'JOIN `creature_loot_template` cl ON cl.`Reference` = rl.`Entry` ',
  'JOIN `creature_template` ct ON ct.`entry` = cl.`entry` ',
  'SET rl.`Item` = ', @TARGET_EMBLEM, ' ',
  'WHERE rl.`Item` IN (40752,40753,45624,47241,49426) ',
  '  AND rl.`Item` <> ', @TARGET_EMBLEM, ' ',
  '  AND ct.`rank` = 3 ',
  '  AND EXISTS (',
  '    SELECT 1 FROM `creature` cr ',
  '    WHERE cr.`map` IN (', @MAPS, ') ',
  '      AND ', @CREATURE_ENTRY_COL, ' = cl.`entry`',
  '  )'
);
PREPARE stmt FROM @SQL; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Cofres finales dentro de estos mapas
UPDATE `gameobject_loot_template` gl
JOIN `gameobject_template` got ON got.`type` = 3 AND got.`data1` = gl.`entry`
JOIN `gameobject` go ON go.`id` = got.`entry`
SET gl.`Item` = @TARGET_EMBLEM
WHERE gl.`Item` IN (40752,40753,45624,47241,49426)
  AND gl.`Item` <> @TARGET_EMBLEM
  AND go.`map` IN (632,658,668);
