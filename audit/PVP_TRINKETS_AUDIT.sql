-- PVP_TRINKETS_AUDIT.sql
-- Purpose: List PvP/Arena trinkets sold by your vendors and validate pricing (ExtendedCost)
--
-- Notes:
-- - This script does NOT change data (read-only) unless you uncomment the cleanup section.
-- - "Trinket" here is detected by item_template.InventoryType = 12.
-- - Season/tier is inferred heuristically by item name + item level.
-- - Pricing is validated by ensuring npc_vendor.ExtendedCost != 0 and that the cost row exists.
--
-- =====================================================
-- CONFIG
-- =====================================================
-- Option A) If you know vendor names (recommended first pass):
SET @V1 := 'Sergeant Thunderhorn';
SET @V2 := 'Blood Guard Zar''shi';
SET @V3 := 'Magistrix Lambriesse';
SET @V4 := 'Frozo the Renowned';

-- Option B) If you know vendor entries (uncomment and fill):
-- SET @VENDOR_ENTRIES := '33609,33610';

-- Heuristic threshold for "future" WotLK PvP (ICC-era):
SET @ICC_ERA_ILVL := 264;

-- =====================================================
-- STEP 0) Resolve vendor entries (by name)
-- =====================================================
SELECT entry, name
FROM creature_template
WHERE name IN (@V1, @V2, @V3, @V4);

-- =====================================================
-- STEP 1) List TRINKETS sold by those vendors
-- =====================================================
SELECT ct.name AS vendor,
       nv.entry AS vendor_entry,
       nv.item AS item_entry,
       it.name AS item_name,
       it.ItemLevel,
       it.RequiredLevel,
       it.InventoryType,
       nv.ExtendedCost,
       CASE
         WHEN it.name LIKE '%Wrathful%' OR it.ItemLevel >= @ICC_ERA_ILVL THEN 'PvP S8 (Wrathful / ICC-era)'
         WHEN it.name LIKE '%Relentless%' OR it.ItemLevel BETWEEN 251 AND 263 THEN 'PvP S7 (Relentless / ToC-era)'
         WHEN it.name LIKE '%Furious%' OR it.ItemLevel BETWEEN 232 AND 250 THEN 'PvP S6 (Furious / Ulduar-era)'
         WHEN it.name LIKE '%Deadly%' OR it.ItemLevel BETWEEN 213 AND 231 THEN 'PvP S5 (Deadly / Naxx-era)'
         WHEN it.name LIKE '%Hateful%' OR it.ItemLevel BETWEEN 200 AND 212 THEN 'PvP pre-S5 (Hateful)'
         ELSE 'Unknown/Other'
       END AS season_guess
FROM npc_vendor nv
JOIN creature_template ct ON ct.entry = nv.entry
JOIN item_template it ON it.entry = nv.item
WHERE ct.name IN (@V1, @V2, @V3, @V4)
  AND it.InventoryType = 12
ORDER BY ct.name, it.ItemLevel DESC, it.name;

-- =====================================================
-- STEP 2) Flag suspicious trinkets (future season / ICC-era)
-- =====================================================
SELECT ct.name AS vendor,
       nv.entry AS vendor_entry,
       nv.item AS item_entry,
       it.name AS item_name,
       it.ItemLevel,
       nv.ExtendedCost
FROM npc_vendor nv
JOIN creature_template ct ON ct.entry = nv.entry
JOIN item_template it ON it.entry = nv.item
WHERE ct.name IN (@V1, @V2, @V3, @V4)
  AND it.InventoryType = 12
  AND (
    it.name LIKE '%Wrathful%'
    OR it.name LIKE '%Relentless%'
    OR it.ItemLevel >= @ICC_ERA_ILVL
  )
ORDER BY ct.name, it.ItemLevel DESC, it.name;

-- =====================================================
-- STEP 3) Detect broken pricing (ExtendedCost=0 or missing cost row)
-- =====================================================
-- IMPORTANT: Choose ONE variant depending on your schema.

-- Variant A) Old schema: npc_vendor_extended_cost
-- SELECT ct.name AS vendor,
--        nv.entry AS vendor_entry,
--        nv.item AS item_entry,
--        it.name AS item_name,
--        it.ItemLevel,
--        nv.ExtendedCost,
--        ec.ID AS cost_row_exists
-- FROM npc_vendor nv
-- JOIN creature_template ct ON ct.entry = nv.entry
-- JOIN item_template it ON it.entry = nv.item
-- LEFT JOIN npc_vendor_extended_cost ec ON ec.ID = nv.ExtendedCost
-- WHERE ct.name IN (@V1, @V2, @V3, @V4)
--   AND it.InventoryType = 12
--   AND (nv.ExtendedCost = 0 OR ec.ID IS NULL)
-- ORDER BY ct.name, it.ItemLevel DESC, it.name;

-- Variant B) More common: item_extended_cost
-- SELECT ct.name AS vendor,
--        nv.entry AS vendor_entry,
--        nv.item AS item_entry,
--        it.name AS item_name,
--        it.ItemLevel,
--        nv.ExtendedCost,
--        ec.ID AS cost_row_exists
-- FROM npc_vendor nv
-- JOIN creature_template ct ON ct.entry = nv.entry
-- JOIN item_template it ON it.entry = nv.item
-- LEFT JOIN item_extended_cost ec ON ec.ID = nv.ExtendedCost
-- WHERE ct.name IN (@V1, @V2, @V3, @V4)
--   AND it.InventoryType = 12
--   AND (nv.ExtendedCost = 0 OR ec.ID IS NULL)
-- ORDER BY ct.name, it.ItemLevel DESC, it.name;

-- =====================================================
-- OPTIONAL CLEANUP (commented out)
-- =====================================================
-- Example: remove ICC-era trinkets from those vendors by name/ilvl.
-- DELETE nv
-- FROM npc_vendor nv
-- JOIN creature_template ct ON ct.entry = nv.entry
-- JOIN item_template it ON it.entry = nv.item
-- WHERE ct.name IN (@V1, @V2, @V3, @V4)
--   AND it.InventoryType = 12
--   AND (
--     it.name LIKE '%Wrathful%'
--     OR it.name LIKE '%Relentless%'
--     OR it.ItemLevel >= @ICC_ERA_ILVL
--   );
