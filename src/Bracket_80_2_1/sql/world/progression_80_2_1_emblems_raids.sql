-- Bracket 80_2_1 (WotLK T7): raid emblem correction
-- Objetivo:
--   En esta bracket las raids 10 deben dar Emblema de Heroísmo (40752) y las raids 25 Emblema de Valor (40753).
--   Se eliminan Conquest/Triumph/Frost de estas fuentes.

SET @EMBLEM_10 := 40752; -- Heroism
SET @EMBLEM_25 := 40753; -- Valor
SET @EMBLEM_SET := '40752,40753,45624,47241,49426';
SET @RAID_MAPS := '533,615,616';

-- Compatibilidad de esquema: algunas DB usan creature.id1 como templateEntry, otras creature.id.
SELECT COUNT(*) INTO @HAS_CREATURE_ID1
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'creature'
  AND COLUMN_NAME = 'id1';

SET @CREATURE_ENTRY_COL := IF(@HAS_CREATURE_ID1 = 1, 'cr.`id1`', 'cr.`id`');

-- 1) creature_loot_template (drops directos)
-- spawnMask bits: 1=10N, 2=25N, 4=10H, 8=25H (T7 usa 10/25 normal; cubrimos ambos pares por seguridad).
SET @SQL := CONCAT(
  'UPDATE `creature_loot_template` cl ',
  'JOIN `creature_template` ct ON ct.`entry` = cl.`entry` ',
  'JOIN `creature` cr ON ', @CREATURE_ENTRY_COL, ' = cl.`entry` ',
  'SET cl.`Item` = IF(cr.`spawnMask` & 2 OR cr.`spawnMask` & 8, ', @EMBLEM_25, ', ', @EMBLEM_10, ') ',
  'WHERE FIND_IN_SET(cl.`Item`, ', QUOTE(@EMBLEM_SET), ') > 0 ',
  '  AND ct.`rank` = 3 ',
  '  AND cr.`map` IN (', @RAID_MAPS, ')
');
PREPARE stmt FROM @SQL; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 2) reference_loot_template (drops vía referencias)
SET @SQL := CONCAT(
  'UPDATE `reference_loot_template` rl ',
  'JOIN `creature_loot_template` cl ON cl.`Reference` = rl.`Entry` ',
  'JOIN `creature_template` ct ON ct.`entry` = cl.`entry` ',
  'JOIN `creature` cr ON ', @CREATURE_ENTRY_COL, ' = cl.`entry` ',
  'SET rl.`Item` = IF(cr.`spawnMask` & 2 OR cr.`spawnMask` & 8, ', @EMBLEM_25, ', ', @EMBLEM_10, ') ',
  'WHERE FIND_IN_SET(rl.`Item`, ', QUOTE(@EMBLEM_SET), ') > 0 ',
  '  AND ct.`rank` = 3 ',
  '  AND cr.`map` IN (', @RAID_MAPS, ')
');
PREPARE stmt FROM @SQL; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 3) gameobject_loot_template (cofres de raid como OS/EoE; se distingue por spawnMask de los GO colocados en el mapa).
UPDATE `gameobject_loot_template` gl
JOIN `gameobject_template` got ON got.`type` = 3 AND got.`data1` = gl.`entry`
JOIN `gameobject` go ON go.`id` = got.`entry`
SET gl.`Item` = IF(go.`spawnMask` & 2 OR go.`spawnMask` & 8, @EMBLEM_25, @EMBLEM_10)
WHERE FIND_IN_SET(gl.`Item`, @EMBLEM_SET) > 0
  AND go.`map` IN (533, 615, 616);
