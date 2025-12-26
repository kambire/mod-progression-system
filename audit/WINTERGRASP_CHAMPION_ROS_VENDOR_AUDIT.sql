-- WINTERGRASP_CHAMPION_ROS_VENDOR_AUDIT.sql
-- Purpose:
--   Audit Wintergrasp-related vendor inventories for bracket/progression correctness,
--   focusing on the NPC the user reported: "Champion Ros Slal" (name varies by DB).
--
-- How to use:
--   1) Run this on your `world` database.
--   2) Review the "Vendor items" and "Flagged" sections.
--   3) If you confirm what should be blocked for your current bracket/season,
--      use the generated DELETE statements (or share the results so we can encode
--      deterministic bracket SQL in the module).
--
-- Notes:
--   - Wintergrasp is not a `game_event` like Winter Veil; it is an outdoor PvP system.
--   - Vendors are typically gated by Wintergrasp control via conditions/AI; we do NOT
--     alter that here. This script focuses only on what items the NPC sells.

SET @NPC_NAME_PATTERN = '%Champion%Ros%';
-- Choose your current progression target (heuristic):
--   5 = Deadly (S5), 6 = Furious (S6), 7 = Relentless (S7), 8 = Wrathful (S8)
-- Example: if your bracket is "Tier 8 & Furious" use 6.
SET @ALLOW_UP_TO_SEASON = 6;

-- Optional: restrict to a single known NPC entry once you identify it.
-- SET @NPC_ENTRY = 00000;
SET @NPC_ENTRY = NULL;

-- 1) Candidates by name
SELECT
  ct.entry,
  ct.name,
  ct.subname,
  ct.minlevel,
  ct.maxlevel,
  ct.faction,
  ct.npcflag
FROM creature_template ct
WHERE (@NPC_ENTRY IS NULL AND ct.name LIKE @NPC_NAME_PATTERN)
   OR (@NPC_ENTRY IS NOT NULL AND ct.entry = @NPC_ENTRY)
ORDER BY ct.entry;

-- 2) Confirm it is a vendor (has rows in npc_vendor)
SELECT
  nv.entry,
  ct.name,
  COUNT(*) AS vendor_items
FROM npc_vendor nv
JOIN creature_template ct ON ct.entry = nv.entry
WHERE ((@NPC_ENTRY IS NULL AND ct.name LIKE @NPC_NAME_PATTERN)
    OR (@NPC_ENTRY IS NOT NULL AND nv.entry = @NPC_ENTRY))
GROUP BY nv.entry, ct.name
ORDER BY vendor_items DESC;

-- 3) Vendor items (detailed)
--    Includes ExtendedCost breakdown when available.
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
  iec.reqitem1, iec.reqitemcount1,
  iec.reqitem2, iec.reqitemcount2,
  iec.reqitem3, iec.reqitemcount3,
  iec.reqitem4, iec.reqitemcount4,
  CASE
    WHEN it.name LIKE '%Wrathful%' THEN 8
    WHEN it.name LIKE '%Relentless%' THEN 7
    WHEN it.name LIKE '%Furious%' THEN 6
    WHEN it.name LIKE '%Deadly%' THEN 5
    ELSE NULL
  END AS season_guess_by_name,
  CASE
    -- backup heuristic if the naming isn't localized the same way
    WHEN it.ItemLevel >= 264 THEN 8
    WHEN it.ItemLevel >= 251 THEN 7
    WHEN it.ItemLevel >= 232 THEN 6
    WHEN it.ItemLevel >= 213 THEN 5
    ELSE NULL
  END AS season_guess_by_ilvl
FROM npc_vendor nv
JOIN creature_template ct ON ct.entry = nv.entry
JOIN item_template it ON it.entry = nv.item
LEFT JOIN item_extended_cost iec ON iec.ID = nv.ExtendedCost
WHERE ((@NPC_ENTRY IS NULL AND ct.name LIKE @NPC_NAME_PATTERN)
    OR (@NPC_ENTRY IS NOT NULL AND nv.entry = @NPC_ENTRY))
ORDER BY nv.entry, it.ItemLevel DESC, it.RequiredLevel DESC, it.name;

-- 4) Flagged as "too new" for current bracket season (heuristic)
--    Rule: if season_guess_by_name OR season_guess_by_ilvl exceeds @ALLOW_UP_TO_SEASON,
--    we consider it out-of-bracket.
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
JOIN creature_template ct ON ct.entry = nv.entry
JOIN item_template it ON it.entry = nv.item
WHERE ((@NPC_ENTRY IS NULL AND ct.name LIKE @NPC_NAME_PATTERN)
    OR (@NPC_ENTRY IS NOT NULL AND nv.entry = @NPC_ENTRY))
HAVING season_guess IS NOT NULL AND season_guess > allow_up_to
ORDER BY nv.entry, season_guess DESC, it.ItemLevel DESC, it.name;

-- 5) Generate suggested DELETE statements for flagged items
--    (Copy/paste the output if you decide to apply manually.)
SELECT
  CONCAT(
    'DELETE FROM npc_vendor WHERE entry = ', nv.entry,
    ' AND item = ', nv.item,
    ' AND ExtendedCost = ', nv.ExtendedCost,
    '; -- ', REPLACE(ct.name, ';', ':'), ' sells ', REPLACE(it.name, ';', ':'),
    ' (ReqLvl=', it.RequiredLevel, ', iLvl=', it.ItemLevel, ')'
  ) AS suggested_sql
FROM npc_vendor nv
JOIN creature_template ct ON ct.entry = nv.entry
JOIN item_template it ON it.entry = nv.item
WHERE ((@NPC_ENTRY IS NULL AND ct.name LIKE @NPC_NAME_PATTERN)
    OR (@NPC_ENTRY IS NOT NULL AND nv.entry = @NPC_ENTRY))
AND COALESCE(
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

-- 6) Diagnostics: where the NPC spawns (if present in creature)
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
JOIN creature_template ct ON ct.entry = c.id
WHERE ((@NPC_ENTRY IS NULL AND ct.name LIKE @NPC_NAME_PATTERN)
    OR (@NPC_ENTRY IS NOT NULL AND c.id = @NPC_ENTRY))
ORDER BY c.map, c.zoneId, c.areaId, c.guid;
