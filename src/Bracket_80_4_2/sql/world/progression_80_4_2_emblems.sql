-- ProgressionSystem - WotLK emblems (Bracket_80_4_2)
-- SERVER SOURCE OF TRUTH:
-- - Heroicas (bosses) => TRIUNFO (47241)
-- Scope: ONLY level-80 5-man dungeon heroic maps (no raids):
-- 574,576,578,595,599,600,601,602,604,608,619,650,632,658,668
--
-- Emblem item IDs (WotLK):
-- Heroism 40752
-- Valor   40753
-- Conquest 45624
-- Triumph 47241
-- Frost   49426

SET @TARGET_EMBLEM := 47241;
SET @MAPS := '574,576,578,595,599,600,601,602,604,608,619,650,632,658,668';

-- Schema compatibility: some cores use creature.id1 as templateEntry, others use creature.id.
SELECT COUNT(*) INTO @HAS_CREATURE_ID1
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'creature'
  AND COLUMN_NAME = 'id1';

SET @CREATURE_ENTRY_COL := IF(@HAS_CREATURE_ID1 = 1, 'cr.`id1`', 'cr.`id`');

-- =====================================================
-- 1) HEROIC 5-MAN DUNGEON BOSSES => TRIUMPH (47241)
-- =====================================================
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

-- Optional: final chests within the same maps
UPDATE `gameobject_loot_template` gl
JOIN `gameobject_template` got ON got.`type` = 3 AND got.`data1` = gl.`entry`
JOIN `gameobject` go ON go.`id` = got.`entry`
SET gl.`Item` = @TARGET_EMBLEM
WHERE gl.`Item` IN (40752,40753,45624,47241,49426)
  AND gl.`Item` <> @TARGET_EMBLEM
  AND go.`map` IN (574,576,578,595,599,600,601,602,604,608,619,650,632,658,668);
