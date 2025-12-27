-- Bracket 80_3 (WotLK T9 / ToC + Onyxia 80): raid emblem correction
-- Goal:
--   Ensure ToC and Onyxia (level 80 rework era) drop their intended raid-tier emblem.
--
-- Design (blizzlike timeline):
--   - ToC / Ony 80 raids (T9 era): Emblem of Triumph (47241)
--
-- This file ONLY touches raid boss loot in the specified raid maps.

SET @TARGET_EMBLEM := 47241; -- Triumph
SET @RAID_MAPS := '649,249'; -- Trial of the Crusader, Onyxia's Lair

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
