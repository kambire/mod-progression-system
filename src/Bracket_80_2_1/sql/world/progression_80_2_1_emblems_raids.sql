-- Bracket 80_2_1 (WotLK T7): raid emblem correction
-- Goal:
--   Ensure T7 launch raids drop their intended raid-tier emblem.
--
-- Design (blizzlike timeline):
--   - Heroic 5-mans: Emblem of Heroism (40752)
--   - T7 raids (Naxx/OS/EoE): Emblem of Valor (40753)
--
-- This file ONLY touches raid boss loot in the specified raid maps.
-- It does NOT change heroic dungeon loot.

SET @TARGET_EMBLEM := 40753; -- Valor
SET @RAID_MAPS := '533,615,616';

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
