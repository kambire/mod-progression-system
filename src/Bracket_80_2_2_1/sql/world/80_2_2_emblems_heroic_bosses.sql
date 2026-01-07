-- ============================================================================
-- WotLK Bracket 80_2_2 - HEROIC 5-man BOSSES emblem normalization
-- Desired emblem: Emblem of Valor (40753)
-- Maps: WotLK launch dungeon set (no ToC, no ICC 5-mans here)
-- ============================================================================

SET @BRACKET := '80_2_2';
SET @EMBLEM_RIGHT := 40753; -- Valor
SET @EMBLEM_SET := '40752,40753,45624,47241,49426';

DROP TEMPORARY TABLE IF EXISTS tmp_maps;
CREATE TEMPORARY TABLE tmp_maps (mapId INT UNSIGNED NOT NULL PRIMARY KEY) ENGINE=MEMORY;
INSERT INTO tmp_maps (mapId) VALUES
 (574),(575),(576),(578),(595),(599),(600),(601),(602),(604),(608),(619);

SELECT COUNT(*) INTO @HAS_CREATURE_ID1
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'creature'
  AND COLUMN_NAME = 'id1';
SET @CREATURE_ENTRY_COL := IF(@HAS_CREATURE_ID1 = 1, 'cr.`id1`', 'cr.`id`');

DROP TEMPORARY TABLE IF EXISTS tmp_heroic_bosses;
CREATE TEMPORARY TABLE tmp_heroic_bosses (
  mapId INT UNSIGNED NOT NULL,
  normal_entry INT UNSIGNED NOT NULL,
  heroic_entry INT UNSIGNED NOT NULL,
  normal_name VARCHAR(255) NOT NULL,
  heroic_name VARCHAR(255) NOT NULL,
  lootid INT UNSIGNED NOT NULL,
  PRIMARY KEY (mapId, normal_entry)
) ENGINE=MEMORY;

SET @SQL := CONCAT(
  'INSERT IGNORE INTO tmp_heroic_bosses (mapId, normal_entry, heroic_entry, normal_name, heroic_name, lootid)\n',
  'SELECT DISTINCT\n',
  '  cr.`map` AS mapId,\n',
  '  ', @CREATURE_ENTRY_COL, ' AS normal_entry,\n',
  '  ct.`difficulty_entry_1` AS heroic_entry,\n',
  '  ct.`name` AS normal_name,\n',
  '  cth.`name` AS heroic_name,\n',
  '  IF(cth.`lootid` = 0, cth.`entry`, cth.`lootid`) AS lootid\n',
  'FROM `creature` cr\n',
  'JOIN `creature_template` ct ON ct.`entry` = ', @CREATURE_ENTRY_COL, '\n',
  'JOIN tmp_maps m ON m.`mapId` = cr.`map`\n',
  'JOIN `creature_template` cth ON cth.`entry` = ct.`difficulty_entry_1`\n',
  'WHERE ct.`difficulty_entry_1` <> 0\n',
  '  AND ct.`rank` = 3\n'
);
PREPARE stmt FROM @SQL; EXECUTE stmt; DEALLOCATE PREPARE stmt;

DROP TEMPORARY TABLE IF EXISTS tmp_lootids_fix;
CREATE TEMPORARY TABLE tmp_lootids_fix (lootid INT UNSIGNED NOT NULL PRIMARY KEY) ENGINE=MEMORY;

INSERT IGNORE INTO tmp_lootids_fix (lootid)
SELECT DISTINCT b.`lootid`
FROM tmp_heroic_bosses b
JOIN `creature_loot_template` cl ON cl.`entry` = b.`lootid`
WHERE FIND_IN_SET(cl.`Item`, @EMBLEM_SET) > 0
  AND cl.`Item` <> @EMBLEM_RIGHT;

-- A) REPORT
SELECT
  b.`mapId`       AS mapId,
  b.`normal_name` AS normal_name,
  b.`heroic_name` AS heroic_name,
  b.`lootid`      AS heroic_lootid,
  cl.`Item`       AS item,
  cl.`mincount`   AS mincount,
  cl.`maxcount`   AS maxcount
FROM tmp_heroic_bosses b
JOIN `creature_loot_template` cl ON cl.`entry` = b.`lootid`
WHERE FIND_IN_SET(cl.`Item`, @EMBLEM_SET) > 0
  AND cl.`Item` <> @EMBLEM_RIGHT
ORDER BY b.`mapId`, b.`heroic_name`, cl.`Item`;

-- B) BACKUP
SET @BACKUP_TABLE := 'backup_80_2_2_emblems_heroic_bosses';
SET @SQL := CONCAT('CREATE TABLE IF NOT EXISTS `', @BACKUP_TABLE, '` LIKE `creature_loot_template`');
PREPARE stmt FROM @SQL; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @SQL := CONCAT(
  'INSERT INTO `', @BACKUP_TABLE, '`\n',
  'SELECT cl.*\n',
  'FROM `creature_loot_template` cl\n',
  'JOIN tmp_lootids_fix t ON t.`lootid` = cl.`entry`\n',
  'WHERE FIND_IN_SET(cl.`Item`, ''', @EMBLEM_SET, ''') > 0\n',
  '  AND cl.`Item` <> ', @EMBLEM_RIGHT, '\n',
  '  AND NOT EXISTS (\n',
  '    SELECT 1 FROM `', @BACKUP_TABLE, '` b\n',
  '    WHERE b.`entry` = cl.`entry`\n',
  '      AND b.`Item` = cl.`Item`\n',
  '      AND b.`groupid` = cl.`groupid`\n',
  '      AND b.`mincount` = cl.`mincount`\n',
  '      AND b.`maxcount` = cl.`maxcount`\n',
  '  )'
);
PREPARE stmt FROM @SQL; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- C) APPLY
UPDATE `creature_loot_template` cl
JOIN tmp_lootids_fix t ON t.`lootid` = cl.`entry`
SET cl.`Item` = @EMBLEM_RIGHT
WHERE FIND_IN_SET(cl.`Item`, @EMBLEM_SET) > 0
  AND cl.`Item` <> @EMBLEM_RIGHT;

-- D) VERIFY
SELECT @BRACKET AS bracket, COUNT(DISTINCT lootid) AS lootids_targeted FROM tmp_lootids_fix;
SELECT @BRACKET AS bracket, 'WRONG_REMAINING' AS label, COUNT(*) AS rows
FROM `creature_loot_template` cl
JOIN tmp_lootids_fix t ON t.`lootid` = cl.`entry`
WHERE FIND_IN_SET(cl.`Item`, @EMBLEM_SET) > 0
  AND cl.`Item` <> @EMBLEM_RIGHT;
SELECT @BRACKET AS bracket, 'RIGHT_PRESENT' AS label, COUNT(*) AS rows
FROM `creature_loot_template` cl
JOIN tmp_lootids_fix t ON t.`lootid` = cl.`entry`
WHERE cl.`Item` = @EMBLEM_RIGHT;

-- Resumen (GM): .reload creature_loot_template (si existe) o restart worldserver.
