-- MANUAL_HOTFIX_WINTERGRASP_VENDOR_PROGRESSIVE.sql
-- Purpose:
--   Make Wintergrasp vendors follow bracket progression:
--     - At early WotLK (e.g., S5) remove future-season PvP items.
--     - In later brackets (S6/S7/S8) re-enable them.
--
-- Why this exists:
--   If you DELETE vendor rows to enforce S5, you need a way to restore them later.
--   This script keeps a persistent backup table of the vendor rows *as they exist now*
--   (typically full 3.3.5a / Wrathful DB) and then applies a "season cap" by deleting
--   or restoring rows from that backup.
--
-- IMPORTANT:
--   - Run this on the `world` database.
--   - First run should be done BEFORE you start deleting anything (so the backup captures
--     the full vendor inventory).
--   - This uses item NAME keywords to classify seasons (Deadly/Furious/Relentless/Wrathful).
--     If your DB is localized and names differ, classification will be incomplete.

-- Wintergrasp defaults (WotLK): Northrend map 571, zoneId 4197
SET @WG_MAP = 571;
SET @WG_ZONE_ID = 4197;

-- 5 = Deadly (S5), 6 = Furious (S6), 7 = Relentless (S7), 8 = Wrathful (S8)
SET @ALLOW_UP_TO_SEASON = 5;

-- Enforcement mode:
--   0 = CAP MODE (default): remove only seasons above cap; keep everything else.
--   1 = STRICT MODE: "block all" then enable only what is allowed by season_tag.
--       This matches the progression philosophy of starting closed and opening gradually.
SET @STRICT_MODE = 0;

-- STRICT MODE option:
--   0 = do NOT restore items with unknown/non-season tagging (season_tag=0)
--   1 = restore unknown/non-season items too (useful if your WG vendors have legit items
--       that don't include Deadly/Furious/etc in their name)
SET @STRICT_INCLUDE_UNKNOWN = 0;

-- 1 = create/populate backup for discovered WG vendors
SET @INIT_BACKUP = 1;

-- Optional: focus on a single vendor entry (NULL = all WG vendors)
SET @NPC_ENTRY = NULL;

-- 0) Discover Wintergrasp vendor entries (by spawn location)
DROP TEMPORARY TABLE IF EXISTS tmp_wg_vendor_entries;
CREATE TEMPORARY TABLE tmp_wg_vendor_entries (
  entry INT UNSIGNED NOT NULL PRIMARY KEY
) ENGINE=Memory;

INSERT IGNORE INTO tmp_wg_vendor_entries (entry)
SELECT DISTINCT c.id
FROM creature c
JOIN npc_vendor nv ON nv.entry = c.id
WHERE c.map = @WG_MAP
  AND (c.zoneId = @WG_ZONE_ID OR c.areaId = @WG_ZONE_ID);

DELETE FROM tmp_wg_vendor_entries
WHERE @NPC_ENTRY IS NOT NULL AND entry <> @NPC_ENTRY;

-- Diagnostics: list discovered vendors
SELECT v.entry, ct.name, ct.subname
FROM tmp_wg_vendor_entries v
JOIN creature_template ct ON ct.entry = v.entry
ORDER BY v.entry;

-- 1) Persistent backup table (keeps original vendor rows)
CREATE TABLE IF NOT EXISTS mod_progression_wg_vendor_backup (
  entry INT UNSIGNED NOT NULL,
  slot INT UNSIGNED NOT NULL,
  item INT UNSIGNED NOT NULL,
  maxcount INT UNSIGNED NOT NULL,
  incrtime INT UNSIGNED NOT NULL,
  ExtendedCost INT UNSIGNED NOT NULL,
  season_tag TINYINT UNSIGNED NOT NULL,
  captured_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (entry, slot, item, ExtendedCost)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 2) Populate backup (idempotent)
-- season_tag:
--   8 Wrathful, 7 Relentless, 6 Furious, 5 Deadly, 0 = non-season / unknown

-- Only run when requested
SET @DO_BACKUP = @INIT_BACKUP;

INSERT IGNORE INTO mod_progression_wg_vendor_backup
(entry, slot, item, maxcount, incrtime, ExtendedCost, season_tag)
SELECT
  nv.entry,
  nv.slot,
  nv.item,
  nv.maxcount,
  nv.incrtime,
  IFNULL(nv.ExtendedCost, 0) AS ExtendedCost,
  CASE
    WHEN it.name LIKE '%Wrathful%' THEN 8
    WHEN it.name LIKE '%Relentless%' THEN 7
    WHEN it.name LIKE '%Furious%' THEN 6
    WHEN it.name LIKE '%Deadly%' THEN 5
    ELSE 0
  END AS season_tag
FROM npc_vendor nv
JOIN tmp_wg_vendor_entries v ON v.entry = nv.entry
JOIN item_template it ON it.entry = nv.item
WHERE @DO_BACKUP = 1;

-- 3) Apply season cap:
--   - Delete rows for seasons > cap
--   - Restore rows for seasons <= cap (from backup)

-- 3) STRICT MODE (optional): wipe vendor first ("block all")
-- This guarantees the vendor ends up with ONLY the rows we restore below.
-- NOTE: This is intentionally aggressive.
DELETE nv
FROM npc_vendor nv
JOIN tmp_wg_vendor_entries v ON v.entry = nv.entry
WHERE @STRICT_MODE = 1;

-- 3a) Delete "future" season items
DELETE nv
FROM npc_vendor nv
JOIN tmp_wg_vendor_entries v ON v.entry = nv.entry
JOIN mod_progression_wg_vendor_backup b
  ON b.entry = nv.entry
 AND b.slot = nv.slot
 AND b.item = nv.item
 AND b.ExtendedCost = IFNULL(nv.ExtendedCost, 0)
WHERE @STRICT_MODE = 0
  AND b.season_tag > @ALLOW_UP_TO_SEASON;

-- 3b) Restore allowed season items that might have been deleted earlier
INSERT IGNORE INTO npc_vendor
(entry, slot, item, maxcount, incrtime, ExtendedCost)
SELECT
  b.entry,
  b.slot,
  b.item,
  b.maxcount,
  b.incrtime,
  b.ExtendedCost
FROM mod_progression_wg_vendor_backup b
JOIN tmp_wg_vendor_entries v ON v.entry = b.entry
WHERE (
    -- CAP MODE: restore everything with season_tag <= cap (including unknowns)
    (@STRICT_MODE = 0 AND b.season_tag <= @ALLOW_UP_TO_SEASON)
    OR
    -- STRICT MODE: restore ONLY allowed seasons, optionally include unknowns
    (@STRICT_MODE = 1 AND (
        (b.season_tag BETWEEN 5 AND @ALLOW_UP_TO_SEASON)
        OR (@STRICT_INCLUDE_UNKNOWN = 1 AND b.season_tag = 0)
    ))
  );

-- 4) Report: counts by season_tag after applying
SELECT
  b.entry,
  ct.name AS npc_name,
  b.season_tag,
  COUNT(*) AS items_in_backup
FROM mod_progression_wg_vendor_backup b
JOIN creature_template ct ON ct.entry = b.entry
JOIN tmp_wg_vendor_entries v ON v.entry = b.entry
GROUP BY b.entry, ct.name, b.season_tag
ORDER BY b.entry, b.season_tag;

-- 5) Report: current vendor items that are still above cap (should be 0)
SELECT
  nv.entry,
  ct.name AS npc_name,
  nv.item,
  it.name AS item_name,
  it.ItemLevel,
  IFNULL(nv.ExtendedCost, 0) AS ExtendedCost,
  CASE
    WHEN it.name LIKE '%Wrathful%' THEN 8
    WHEN it.name LIKE '%Relentless%' THEN 7
    WHEN it.name LIKE '%Furious%' THEN 6
    WHEN it.name LIKE '%Deadly%' THEN 5
    ELSE 0
  END AS season_tag
FROM npc_vendor nv
JOIN tmp_wg_vendor_entries v ON v.entry = nv.entry
JOIN creature_template ct ON ct.entry = nv.entry
JOIN item_template it ON it.entry = nv.item
WHERE CASE
    WHEN it.name LIKE '%Wrathful%' THEN 8
    WHEN it.name LIKE '%Relentless%' THEN 7
    WHEN it.name LIKE '%Furious%' THEN 6
    WHEN it.name LIKE '%Deadly%' THEN 5
    ELSE 0
  END > @ALLOW_UP_TO_SEASON
ORDER BY nv.entry, it.ItemLevel DESC, it.name;
