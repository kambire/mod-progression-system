-- Arena Season Progression Validation
-- Verification script for proper Arena Season 1-8 implementation
-- Timeline note: Exact dates vary by region/server. Here we validate S1-S8 consistency and DB structure.

-- ==========================================
-- ARENA SEASON PROGRESSION GUIDE
-- ==========================================

-- SEASON 1 (Gladiator) - TBC
-- Bracket: Bracket_70_2_1
-- Dates: (approx.) 2007
-- Rating: depends on the item (expressed in item_extended_cost)
-- Rewards: Gladiator
-- Vendors: depends on your core/DB (entries can vary)

-- SEASON 2 (Merciless) - TBC
-- Bracket: Bracket_70_2_2
-- Dates: (approx.) 2007
-- Rating: depends on the item (expressed in item_extended_cost)
-- Rewards: Merciless
-- NOTE: previous gear is usually kept as legacy (cheaper)

-- SEASON 3 (Vengeful) - TBC
-- Bracket: Bracket_70_5
-- Dates: (approx.) 2007-2008
-- Rating: depends on the item (expressed in item_extended_cost)
-- Rewards: Vengeful

-- SEASON 4 (Brutal) - TBC
-- Bracket: Bracket_70_6_2
-- Dates: (approx.) 2008
-- Rating: depends on the item (expressed in item_extended_cost)
-- Rewards: Brutal

-- SEASON 5 (Deadly) - WotLK
-- Bracket: Bracket_80_1_2
-- Dates: (approx.) 2008-2009
-- Rating: depends on the item (expressed in item_extended_cost)
-- Rewards: Deadly

-- SEASON 6 (Furious) - WotLK
-- Bracket: Bracket_80_2
-- Dates: (approx.) 2009
-- Rating: depends on the item (expressed in item_extended_cost)
-- Rewards: Furious

-- SEASON 7 (Relentless) - WotLK
-- Bracket: Bracket_80_3
-- Dates: (approx.) 2009-2010
-- Rating: depends on the item (expressed in item_extended_cost)
-- Rewards: Relentless

-- SEASON 8 (Wrathful) - WotLK
-- Bracket: Bracket_80_4_1
-- Dates: (approx.) 2010
-- Rating: depends on the item (expressed in item_extended_cost)
-- Rewards: Wrathful

-- ==========================================
-- VALIDATION QUERIES
-- ==========================================

-- Check Arena Vendor counts per bracket
SELECT 
    'Bracket_70_2_1 (Season 1)' as Season,
    COUNT(*) as VendorCount
FROM npc_vendor v
JOIN item_template it ON it.entry = v.item
WHERE v.entry IN (33609, 33610, 33611, 33612)
    AND it.name LIKE '%Gladiator%'
UNION ALL
SELECT 'Bracket_70_2_2 (Season 2)', COUNT(*)
FROM npc_vendor v
JOIN item_template it ON it.entry = v.item
WHERE v.entry IN (33609, 33610)
    AND it.name LIKE '%Merciless%'
UNION ALL
SELECT 'Bracket_70_5 (Season 3)', COUNT(*)
FROM npc_vendor v
JOIN item_template it ON it.entry = v.item
WHERE v.entry IN (33609, 33610)
    AND it.name LIKE '%Vengeful%'
UNION ALL
SELECT 'Bracket_70_6_2 (Season 4)', COUNT(*)
FROM npc_vendor v
JOIN item_template it ON it.entry = v.item
WHERE v.entry IN (33609, 33610)
    AND it.name LIKE '%Brutal%'
UNION ALL
SELECT 'Bracket_80_1_2 (Season 5)', COUNT(*)
FROM npc_vendor v
JOIN item_template it ON it.entry = v.item
WHERE v.entry IN (33609, 33610)
    AND it.name LIKE '%Deadly%'
UNION ALL
SELECT 'Bracket_80_2 (Season 6)', COUNT(*)
FROM npc_vendor v
JOIN item_template it ON it.entry = v.item
WHERE v.entry IN (33609, 33610)
    AND it.name LIKE '%Furious%'
UNION ALL
SELECT 'Bracket_80_3 (Season 7)', COUNT(*)
FROM npc_vendor v
JOIN item_template it ON it.entry = v.item
WHERE v.entry IN (33609, 33610)
    AND it.name LIKE '%Relentless%'
UNION ALL
SELECT 'Bracket_80_4_1 (Season 8)', COUNT(*)
FROM npc_vendor v
JOIN item_template it ON it.entry = v.item
WHERE v.entry IN (33609, 33610)
    AND it.name LIKE '%Wrathful%';

-- ==========================================
-- IMPORTANT NOTES FOR ARENA SEASONS
-- ==========================================

-- 1. PvP VENDOR LOCATIONS:
--    Horde: Orgrimmar (exact coordinates per expansion)
--    Alliance: Stormwind (exact coordinates per expansion)

-- 2. SEASON RESET MECHANICS:
--    - Previous gear usually moves to "legacy" (cheaper)
--    - Costs (honor/arena points/rating) are reflected in item_extended_cost

-- 3. ITEM PROGRESSION:
--    - Season 1: 1500+ rating recommended
--    - Season 2-8: 2000+ rating for top-tier pieces
--    - Seasonal weapons > seasonal armor > seasonal off-pieces

-- 4. PvP TIER NAMING:
--    - TBC S1 = Gladiator
--    - TBC S2 = Merciless
--    - TBC S3 = Vengeful
--    - TBC S4 = Brutal
--    - WotLK S5 = Deadly
--    - WotLK S6 = Furious
--    - WotLK S7 = Relentless
--    - WotLK S8 = Wrathful

-- 5. RATINGS AND TITLES:
--    Most seasons require 2000+ arena rating for top-tier items
--    Exception: Season 1 requires 1500+ for Gladiator title

-- 6. VENDOR NPC ENTRIES:
--    These vary by AzerothCore version but typically:
--    - Orgrimmar vendors: 33609, 34089, 32356, 24392
--    - Stormwind vendors: 33610, 34091, 32405, 32354

-- 7. SEASONAL MOUNTS:
--    Each season typically has an exclusive mount for top-rated players
--    Season 5+: Drakes and Hippogryphs based on season

-- 8. CURRENCY NOTE:
--    In TBC/WotLK, the main currencies are Arena Points + Honor (not Conquest).

-- NOTE: Make sure all seasonal vendors are properly enabled/disabled
-- based on which bracket is active in your progression system
