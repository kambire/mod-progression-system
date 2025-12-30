-- WINTERGRASP_VENDORS_AUDIT.sql
-- Purpose:
--   Audit Wintergrasp vendors (NPCs physically located in Wintergrasp) and flag items
--   that do not match the intended progression bracket / arena season.
--
-- Key idea:
--   Wintergrasp is not a `game_event`; vendors are usually gated by Wintergrasp control.
--   This script only audits inventories (npc_vendor) and pricing (ExtendedCost).
--
-- Usage:
--   1) Run on your `world` database.
--   2) Set @ALLOW_UP_TO_SEASON according to your active bracket:
--        Bracket_80_1_2 (S5 Deadly)      => 5
--        Bracket_80_2_2 (S6 Furious)     => 6
--        Bracket_80_3   (S7 Relentless)  => 7
--        Bracket_80_4_1 (S8 Wrathful)    => 8
--   3) Review the "Flagged" result set, then decide whether to delete or gate items.

-- Wintergrasp defaults (WotLK): Northrend map 571, zoneId 4197
SET @WG_MAP = 571;
SET @WG_ZONE_ID = 4197;

-- Optional: restrict to one vendor entry once known (NULL = all Wintergrasp vendors)
SET @NPC_ENTRY = NULL;

-- Progression target: 5..8 as described above
SET @ALLOW_UP_TO_SEASON = 6;

-- 0) Discover all vendors present in Wintergrasp (by spawn location)
DROP TEMPORARY TABLE IF EXISTS tmp_wg_vendor_entries;
CREATE TEMPORARY TABLE tmp_wg_vendor_entries (
  entry INT UNSIGNED NOT NULL PRIMARY KEY
) ENGINE=Memory;

INSERT IGNORE INTO tmp_wg_vendor_entries (entry)
SELECT DISTINCT c.id
FROM creature c
JOIN creature_template ct ON ct.entry = c.id
WHERE c.map = @WG_MAP
  AND (c.zoneId = @WG_ZONE_ID OR c.areaId = @WG_ZONE_ID)
  AND (ct.npcflag & 128) = 128; -- vendor flag

-- If the vendor flag isn't set in template (some DBs set vendor only via npc_vendor),
-- include any Wintergrasp-spawned creature that has npc_vendor rows.
INSERT IGNORE INTO tmp_wg_vendor_entries (entry)
SELECT DISTINCT c.id
FROM creature c
JOIN npc_vendor nv ON nv.entry = c.id
WHERE c.map = @WG_MAP
  AND (c.zoneId = @WG_ZONE_ID OR c.areaId = @WG_ZONE_ID);

-- Optional restriction
DELETE FROM tmp_wg_vendor_entries
WHERE @NPC_ENTRY IS NOT NULL AND entry <> @NPC_ENTRY;

-- 1) Vendor list + counts
SELECT
  v.entry,
  ct.name,
  ct.subname,
  ct.minlevel,
  ct.maxlevel,
  ct.faction,
  ct.npcflag,
  COUNT(nv.item) AS vendor_items
FROM tmp_wg_vendor_entries v
JOIN creature_template ct ON ct.entry = v.entry
LEFT JOIN npc_vendor nv ON nv.entry = v.entry
GROUP BY v.entry, ct.name, ct.subname, ct.minlevel, ct.maxlevel, ct.faction, ct.npcflag
ORDER BY vendor_items DESC, v.entry;

-- 2) Inventory details + pricing + season guess
-- Season guess uses (a) name keywords and (b) itemlevel thresholds as fallback.
SELECT
  nv.entry,
  ct.name AS npc_name,
  nv.slot,
  nv.item,
  it.name AS item_name,
  it.RequiredLevel,
  it.ItemLevel,
  it.Quality,
  it.class,
  it.subclass,
  nv.ExtendedCost,
  iec.reqhonorpoints,
  iec.reqarenapoints,
  iec.reqpersonalarenarating,
  CASE
    WHEN it.name LIKE '%Wrathful%' THEN 8
    WHEN it.name LIKE '%Relentless%' THEN 7
    WHEN it.name LIKE '%Furious%' THEN 6
    WHEN it.name LIKE '%Deadly%' THEN 5
    ELSE NULL
  END AS season_guess_by_name,
  CASE
    -- These thresholds align with common iLvl bands for WotLK PvP sets
    WHEN it.ItemLevel >= 264 THEN 8
    WHEN it.ItemLevel >= 251 THEN 7
    WHEN it.ItemLevel >= 232 THEN 6
    WHEN it.ItemLevel >= 213 THEN 5
    ELSE NULL
  END AS season_guess_by_ilvl,
  CASE
    WHEN nv.ExtendedCost = 0 THEN 'GOLD_PRICED'
    WHEN nv.ExtendedCost IS NULL THEN 'NO_COST'
    ELSE 'EXTENDED_COST'
  END AS pricing_flag
FROM npc_vendor nv
JOIN tmp_wg_vendor_entries v ON v.entry = nv.entry
JOIN creature_template ct ON ct.entry = nv.entry
JOIN item_template it ON it.entry = nv.item
LEFT JOIN item_extended_cost iec ON iec.ID = nv.ExtendedCost
ORDER BY nv.entry, it.ItemLevel DESC, it.RequiredLevel DESC, it.name;

-- 3) Flagged: items newer than the allowed season (heuristic)
-- NOTE: Not all Wintergrasp items are season-based (e.g., heirlooms/misc). Those will
-- show season_guess=NULL and will NOT be flagged by this query.
SELECT
  nv.entry,
  ct.name AS npc_name,
  nv.item,
  it.name AS item_name,
  it.RequiredLevel,
  it.ItemLevel,
  nv.ExtendedCost,
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
      ELSE NULL
    END
  ) AS season_guess,
  @ALLOW_UP_TO_SEASON AS allow_up_to
FROM npc_vendor nv
JOIN tmp_wg_vendor_entries v ON v.entry = nv.entry
JOIN creature_template ct ON ct.entry = nv.entry
JOIN item_template it ON it.entry = nv.item
HAVING season_guess IS NOT NULL AND season_guess > allow_up_to
ORDER BY season_guess DESC, it.ItemLevel DESC, it.name;

-- 4) Flagged: gold-priced items (ExtendedCost=0) - almost always wrong for PvP vendors
SELECT
  nv.entry,
  ct.name AS npc_name,
  nv.item,
  it.name AS item_name,
  it.RequiredLevel,
  it.ItemLevel,
  nv.ExtendedCost
FROM npc_vendor nv
JOIN tmp_wg_vendor_entries v ON v.entry = nv.entry
JOIN creature_template ct ON ct.entry = nv.entry
JOIN item_template it ON it.entry = nv.item
WHERE nv.ExtendedCost = 0
ORDER BY nv.entry, it.ItemLevel DESC, it.name;

-- 5) Suggested DELETE statements (for the flagged "newer season" items)
SELECT
  CONCAT(
    'DELETE FROM npc_vendor WHERE entry = ', nv.entry,
    ' AND item = ', nv.item,
    ' AND ExtendedCost = ', nv.ExtendedCost,
    '; -- Wintergrasp vendor ', REPLACE(ct.name, ';', ':'), ' sells ', REPLACE(it.name, ';', ':'),
    ' (ReqLvl=', it.RequiredLevel, ', iLvl=', it.ItemLevel, ')'
  ) AS suggested_sql
FROM npc_vendor nv
JOIN tmp_wg_vendor_entries v ON v.entry = nv.entry
JOIN creature_template ct ON ct.entry = nv.entry
JOIN item_template it ON it.entry = nv.item
WHERE COALESCE(
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
      ELSE NULL
    END
  ) > @ALLOW_UP_TO_SEASON
ORDER BY nv.entry, it.ItemLevel DESC, it.name;

-- 6) Diagnostics: spawn points for the discovered vendors
SELECT
  c.id AS entry,
  ct.name,
  c.guid,
  c.map,
  c.zoneId,
  c.areaId,
  c.position_x,
  c.position_y,
  c.position_z,
  c.orientation,
  c.phaseMask
FROM creature c
JOIN tmp_wg_vendor_entries v ON v.entry = c.id
JOIN creature_template ct ON ct.entry = c.id
ORDER BY c.id, c.guid;
