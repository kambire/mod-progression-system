-- VERIFICATION SCRIPT - Sistema de Progresión Blizzlike
-- Use this to verify that all changes are correctly applied

-- ========================================
-- 1. VERIFY NAXXRAMAS 80 CONTENT
-- ========================================

-- Check that Naxxramas 80 bosses are configured
SELECT 'Naxxramas 80 Bosses' as `Check`,
       COUNT(*) as BossCount
FROM creature_template
WHERE entry IN (
    29122, -- Anub'Rekhan
    29123, -- Grand Widow Faerlina
    29124, -- Maexxna
    29125, -- Patchwerk
    29126, -- Grobbulus
    29127, -- Gluth
    29128, -- Thaddius
    29129, -- Instructor Razuvious
    29130, -- Four Horsemen
    29131, -- Sapphiron
    29132  -- Kel'Thuzad
);

-- Expected result: 11 (all bosses present)

-- ========================================
-- 2. VERIFY EYE OF ETERNITY
-- ========================================

-- Check Eye of Eternity boss
SELECT 'Eye of Eternity' as `Check`,
       COUNT(*) as BossCount
FROM creature_template
WHERE entry IN (28860, 27635); -- Malygos, Alexstrasza

-- Expected result: 2 (both creatures present)

-- ========================================
-- 3. VERIFY OBSIDIAN SANCTUM
-- ========================================

-- Check Obsidian Sanctum bosses
SELECT 'Obsidian Sanctum' as `Check`,
       COUNT(*) as BossCount
FROM creature_template
WHERE entry IN (
    25038, -- Sartharion
    25040, -- Tenebron
    25041, -- Shadron
    25042  -- Vesperon
);

-- Expected result: 4 (all dragons present)

-- ========================================
-- 4. VERIFY ARENA SEASON 6 VENDORS
-- ========================================

-- Check Arena Season 6 vendors
SELECT 'Arena Season 6 Vendors' as `Check`,
       COUNT(*) as VendorCount,
       name
FROM creature_template
WHERE entry IN (33609, 33610)
GROUP BY entry, name;

-- Expected result: Should show Orgrimmar and Stormwind vendors

-- ========================================
-- 5. VERIFY ARENA SEASON 7 VENDORS
-- ========================================

-- Check Arena Season 7 vendors (same as Season 6 in most cases)
SELECT 'Arena Season 7 Vendors' as `Check`,
       COUNT(*) as VendorCount
FROM npc_vendor
WHERE entry IN (33609, 33610)
AND item > 40000 AND item < 50000;

-- This should show seasonal PvP items available

-- ========================================
-- 6. VERIFY QUEST CONFIGURATION
-- ========================================

-- Verify Trial of the Crusader (not Trial of the Champion)
SELECT 'Trial of the Crusader (Raid)' as `Check`,
       COUNT(*) as QuestCount
FROM quest_template
WHERE (title LIKE '%Trial of the Crusader%' AND NOT title LIKE '%Champion%')
   OR id IN (13664, 13665, 13666, 13667, 13668, 13669, 13670); -- TOTC quest IDs

-- Expected result: Should show TOTC raid quest lines

-- ========================================
-- 7. VERIFY NAXX 80 LOOT
-- ========================================

-- Verify Naxxramas 80 has proper loot tables configured
SELECT 'Naxxramas 80 Loot' as `Check`,
       COUNT(DISTINCT entry) as BossLootTables
FROM creature_loot_template
WHERE entry IN (
    29122, 29123, 29124, 29125, 29126, 29127, 29128, 29129, 29130, 29131, 29132
);

-- Expected result: Should be > 0 (all bosses have loot tables)

-- ========================================
-- 8. VERIFY PVP VENDOR ITEMS BY SEASON
-- ========================================

-- Season 6 Items (Glorious Gladiator)
-- Items typically in range 40000-44999
SELECT 'Season 6 PvP Items' as `Check`,
       COUNT(*) as ItemCount
FROM npc_vendor
WHERE entry IN (33609, 33610)
AND item BETWEEN 40000 AND 44999;

-- Expected result: > 50 items (full seasonal vendor set)

-- Season 7 Items (Furious Gladiator)
-- Items typically in range 47000-50999
SELECT 'Season 7 PvP Items' as `Check`,
       COUNT(*) as ItemCount
FROM npc_vendor
WHERE entry IN (33609, 33610)
AND item BETWEEN 47000 AND 50999;

-- ========================================
-- 8b. VERIFY ARENA VENDORS ARE NOT SELLING FOR GOLD
-- ========================================

-- If this returns rows, those items are being sold for gold (ExtendedCost=0)
-- because npc_vendor.ExtendedCost is missing and the client falls back to item_template.BuyPrice.
SELECT 'Arena Vendors - GOLD PRICED (ExtendedCost=0)' as `Check`,
             COUNT(*) as GoldPricedItems
FROM npc_vendor
WHERE entry IN (33609, 33610)
    AND ExtendedCost = 0;

-- Expected result: 0 (no items should be purchasable for gold)

-- ========================================
-- 9. VERIFY BRACKET CONFIGURATION
-- ========================================

-- Check that bracket names are correctly configured in database
SELECT 'Bracket Configuration' as `Check`,
       COUNT(*) as BracketsFound
FROM progression_brackets; -- Table name may vary

-- Or check via AzerothCore config table if it exists
SELECT 'Progression System Config' as `Check`,
       COUNT(*) as ConfigEntries
FROM `world`.`variable` 
WHERE `name` LIKE 'ProgressionSystem.Bracket%';

-- ========================================
-- 10. VERIFY ACHIEVEMENT/TITLE REWARDS
-- ========================================

-- Verify seasonal titles are available
SELECT 'Seasonal Titles' as `Check`,
       COUNT(*) as TitleCount
FROM achievement_reward
WHERE title LIKE '%Gladiator%'
   OR title LIKE '%Glorious%'
   OR title LIKE '%Furious%'
   OR title LIKE '%Wrathful%';

-- Expected result: Should show Glorious, Furious, Wrathful titles

-- ========================================
-- SUMMARY QUERIES
-- ========================================

-- Overall progression system health check
SELECT 'PROGRESSION SYSTEM STATUS' as Status;

-- Check all raid bosses across tiers
SELECT 
    CASE 
        WHEN entry IN (15960, 15961) THEN 'Molten Core'
        WHEN entry IN (14601, 14602, 14603) THEN 'Onyxia'
        WHEN entry IN (12017, 12018, 12019) THEN 'Blackwing Lair'
        WHEN entry IN (15989, 15990, 15991) THEN 'Zul''Gurub'
        WHEN entry IN (15511, 15512) THEN 'AQ20'
        WHEN entry IN (15369, 15370) THEN 'AQ40'
        WHEN entry IN (19622, 19623) THEN 'Gruul''s Lair'
        WHEN entry IN (20063, 20064) THEN 'SSC'
        WHEN entry IN (20221, 20222) THEN 'The Eye'
        WHEN entry IN (20066, 20067) THEN 'Hyjal'
        WHEN entry IN (25315, 25316) THEN 'Black Temple'
        WHEN entry IN (23574, 23575) THEN 'Zul''Aman'
        WHEN entry IN (25744, 25745) THEN 'Sunwell'
        WHEN entry IN (29122, 29123) THEN 'Naxxramas 80'
        WHEN entry IN (28860, 27635) THEN 'Eye of Eternity'
        WHEN entry IN (25038) THEN 'Obsidian Sanctum'
        WHEN entry IN (33293, 33294) THEN 'Ulduar'
        WHEN entry IN (34564, 34565) THEN 'Trial of Crusader'
        WHEN entry IN (36612, 36613) THEN 'ICC'
        WHEN entry IN (39625) THEN 'Ruby Sanctum'
        ELSE 'Unknown'
    END as RaidTier,
    COUNT(*) as BossPresentCount
FROM creature_template
WHERE entry IN (
    -- Molten Core
    15960, 15961,
    -- Onyxia
    14601, 14602, 14603,
    -- Blackwing Lair
    12017, 12018, 12019,
    -- Zul'Gurub
    15989, 15990, 15991,
    -- AQ20
    15511, 15512,
    -- AQ40
    15369, 15370,
    -- Gruul's Lair
    19622, 19623,
    -- SSC
    20063, 20064,
    -- The Eye
    20221, 20222,
    -- Hyjal
    20066, 20067,
    -- Black Temple
    25315, 25316,
    -- Zul'Aman
    23574, 23575,
    -- Sunwell
    25744, 25745,
    -- Naxxramas 80
    29122, 29123,
    -- Eye of Eternity
    28860, 27635,
    -- Obsidian Sanctum
    25038,
    -- Ulduar
    33293, 33294,
    -- Trial of Crusader
    34564, 34565,
    -- ICC
    36612, 36613,
    -- Ruby Sanctum
    39625
)
GROUP BY RaidTier
ORDER BY RaidTier;

-- ========================================
-- FINAL VALIDATION
-- ========================================

-- If all queries return expected results, the progression system is correctly configured!
SELECT '✅ VERIFICATION COMPLETE' as Result;
SELECT 'Check the CAMBIOS_APLICADOS.md file for complete details' as NextStep;
