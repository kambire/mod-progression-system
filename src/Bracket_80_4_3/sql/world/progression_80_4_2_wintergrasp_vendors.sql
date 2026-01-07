-- progression_80_4_2_wintergrasp_vendors.sql
-- Purpose:
--   Bracket_80_4_2 is still Season 8 era; keep Wintergrasp vendors fully enabled.
--   This is the same enforcement as Bracket_80_4_1 (S8).

SET @WG_MAP = 571;
SET @WG_ZONE_ID = 4197;
SET @NPC_ENTRY = NULL;

SET @ALLOW_UP_TO_SEASON = 8;
SET @STRICT_MODE = 0;
SET @STRICT_INCLUDE_UNKNOWN = 0;
SET @INIT_BACKUP = 1;

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

INSERT IGNORE INTO mod_progression_wg_vendor_backup
(entry, slot, item, maxcount, incrtime, ExtendedCost, season_tag)
SELECT
  nv.entry,
  nv.slot,
  nv.item,
  nv.maxcount,
  nv.incrtime,
  IFNULL(nv.ExtendedCost, 0) AS ExtendedCost,
  COALESCE(
    CASE
      WHEN it.name LIKE '%Wrathful%' THEN 8
      WHEN it.name LIKE '%Relentless%' THEN 7
      WHEN it.name LIKE '%Furious%' THEN 6
      WHEN it.name LIKE '%Deadly%' THEN 5
      ELSE NULL
    END,
    CASE
      WHEN it.ItemLevel >= 264 THEN 8
      WHEN it.ItemLevel >= 251 THEN 7
      WHEN it.ItemLevel >= 232 THEN 6
      WHEN it.ItemLevel >= 213 THEN 5
      ELSE 0
    END
  ) AS season_tag
FROM npc_vendor nv
JOIN tmp_wg_vendor_entries v ON v.entry = nv.entry
JOIN item_template it ON it.entry = nv.item
WHERE @INIT_BACKUP = 1;

DELETE nv
FROM npc_vendor nv
JOIN tmp_wg_vendor_entries v ON v.entry = nv.entry
WHERE @STRICT_MODE = 1;

DELETE nv
FROM npc_vendor nv
JOIN tmp_wg_vendor_entries v ON v.entry = nv.entry
JOIN mod_progression_wg_vendor_backup b
  ON b.entry = nv.entry
 AND b.slot = nv.slot
 AND b.item = nv.item
 AND b.ExtendedCost = IFNULL(nv.ExtendedCost, 0)
WHERE @STRICT_MODE = 0
  AND b.season_tag BETWEEN 5 AND 8
  AND b.season_tag > @ALLOW_UP_TO_SEASON;

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
    (@STRICT_MODE = 0 AND b.season_tag <= @ALLOW_UP_TO_SEASON)
    OR
    (@STRICT_MODE = 1 AND (
        (b.season_tag BETWEEN 5 AND @ALLOW_UP_TO_SEASON)
        OR (@STRICT_INCLUDE_UNKNOWN = 1 AND b.season_tag = 0)
    ))
  );
