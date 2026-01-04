-- Propósito: corregir los emblemas de los jefes de ICC para que suelten Escarcha (49426) en T10 (bracket 80_4_1).
-- Alcance: solo botín de jefes de la banda Icecrown Citadel (map 631), sin afectar otras raids.
-- Lógica: reemplaza cualquier emblema previo (40752/40753/45624/47241/49426) por 49426 en loot directo y referencias.
-- Compatibilidad: detecta si el core usa creature.id1 o creature.id antes de aplicar.

SET @TARGET_EMBLEM := 49426; -- Frost
SET @RAID_MAPS := '631';

-- Schema compatibility: some cores use creature.id1 as templateEntry, others use creature.id.
SELECT COUNT(*) INTO @HAS_CREATURE_ID1
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'creature'
  AND COLUMN_NAME = 'id1';

SET @CREATURE_ENTRY_COL := IF(@HAS_CREATURE_ID1 = 1, 'cr.`id1`', 'cr.`id`');

-- 1) creature_loot_template (direct emblem rows)
SET @SQL := CONCAT(
  'UPDATE `creature_loot_template` cl ',
  'JOIN `creature_template` ct ON ct.`entry` = cl.`entry` ',
  'SET cl.`Item` = ', @TARGET_EMBLEM, ' ',
  'WHERE cl.`Item` IN (40752,40753,45624,47241,49426) ',
  '  AND cl.`Item` <> ', @TARGET_EMBLEM, ' ',
  '  AND ct.`rank` = 3 ',
  '  AND EXISTS (',
  '    SELECT 1 FROM `creature` cr ',
  '    WHERE cr.`map` IN (', @RAID_MAPS, ') ',
  '      AND ', @CREATURE_ENTRY_COL, ' = cl.`entry`',
  '  )'
);
PREPARE stmt FROM @SQL; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 2) reference_loot_template (emblems coming from references)
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
  '    WHERE cr.`map` IN (', @RAID_MAPS, ') ',
  '      AND ', @CREATURE_ENTRY_COL, ' = cl.`entry`',
  '  )'
);
PREPARE stmt FROM @SQL; EXECUTE stmt; DEALLOCATE PREPARE stmt;
