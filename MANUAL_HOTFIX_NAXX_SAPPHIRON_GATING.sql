-- Manual hotfix: prevent bypassing Naxxramas progression to Sapphiron (AzerothCore world DB)
-- Run this manually against your `world` database.
--
-- Why this exists:
-- If players can reach Sapphiron without clearing prior wings, the most common non-core causes are:
--  1) Teleport gameobjects (Orb of Naxxramas) being visible/usable.
--  2) Missing/incorrect instance script binding for Naxxramas (map 533) in instance_template.
--
-- This script:
--  - Hides Orb of Naxxramas teleports (GO entries 202277/202278) by phasemask.
--  - Ensures instance_template for map 533 uses the Naxx instance script (dynamic column detection).
--
-- NOTE: If you are reaching Sapphiron via GM commands/teleports or via an already-saved cleared instance,
-- this is not a DB bug.

START TRANSACTION;

-- =====================================================
-- A) Quick diagnostics
-- =====================================================
-- Are the Orb of Naxxramas teleport GOs present and visible?
SELECT `guid`, `id`, `map`, `phaseMask`, `position_x`, `position_y`, `position_z`
FROM `gameobject`
WHERE `id` IN (202277, 202278);

-- Instance template row for Naxxramas (map 533)
SELECT * FROM `instance_template` WHERE `map` = 533;

-- =====================================================
-- B) Hide Orb of Naxxramas (teleport to/from Sapphiron)
-- =====================================================
-- Using a non-default phasemask to effectively hide it.
UPDATE `gameobject`
SET `phaseMask` = 16384
WHERE `id` IN (202277, 202278);

-- =====================================================
-- C) Ensure Naxx instance script binding
-- =====================================================
-- AzerothCore DBs may name this column `script` (common). Some forks use ScriptName/scriptname.
-- We detect the column and update it via dynamic SQL.
SET @it_col := (
  SELECT `COLUMN_NAME`
  FROM `INFORMATION_SCHEMA`.`COLUMNS`
  WHERE `TABLE_SCHEMA` = DATABASE()
    AND `TABLE_NAME` = 'instance_template'
    AND `COLUMN_NAME` IN ('script', 'ScriptName', 'scriptname')
  LIMIT 1
);

-- If no column found, do nothing (better than failing mid-script).
SET @sql := IF(
  @it_col IS NULL,
  'SELECT "WARN: instance_template has no script column (script/ScriptName/scriptname). Skipping." AS msg;',
  CONCAT('UPDATE `instance_template` SET `', @it_col, '` = ''instance_naxxramas'' WHERE `map` = 533;')
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

COMMIT;

-- =====================================================
-- D) Post-checks
-- =====================================================
SELECT `guid`, `id`, `map`, `phaseMask` FROM `gameobject` WHERE `id` IN (202277, 202278);
SELECT * FROM `instance_template` WHERE `map` = 533;
