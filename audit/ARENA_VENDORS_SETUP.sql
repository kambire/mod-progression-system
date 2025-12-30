-- Arena Season Vendor Verification and Setup
-- This script validates that seasonal PvP vendors are correctly configured

-- ==========================================
-- SEASON VENDOR MASTER LIST
-- ==========================================

-- Common Arena Vendor NPCs by faction
-- Horde vendors in Orgrimmar
-- Alliance vendors in Stormwind

-- Season 1 Vendors
-- Entry: 26351 (Zul'Aman), etc.

-- Season 2-8 Vendors  
-- Entry: 33609 (Nargle Lashsnarl) - Horde in Orgrimmar
-- Entry: 33610 (Joran Steelsmythe) - Alliance in Stormwind

-- ==========================================
-- DISABLE FUTURE SEASON VENDORS
-- ==========================================

-- When enabling Bracket_70_2_1 (Season 1), disable Season 2+ vendors
UPDATE `creature_template` SET `npcflag`=`npcflag`&~128 WHERE `entry` IN (
    33609,  -- Nargle Lashsnarl (will be re-enabled in proper bracket)
    33610   -- Joran Steelsmythe (will be re-enabled in proper bracket)
);

-- ==========================================
-- SEASONAL VENDOR PHASES
-- ==========================================

-- When Bracket_70_2_1 (Arena Season 1) is ACTIVE:
-- ENABLE Season 1 vendors (OLD: 26351, etc.)
-- DISABLE Season 2+ vendors

-- When Bracket_70_4_1 (Arena Season 2) is ACTIVE:
-- ENABLE Season 2 vendors (33609, 33610)
-- Keep Season 1 vendors available (legacy items cheaper)

-- When Bracket_70_5 (Arena Season 3) is ACTIVE:
-- ENABLE Season 3 vendors
-- Keep previous seasons available

-- When Bracket_70_6_2 (Arena Season 4) is ACTIVE:
-- ENABLE Season 4 vendors
-- Keep previous seasons available

-- When Bracket_80_1_2 (Arena Season 5) is ACTIVE:
-- ENABLE Season 5 vendors
-- Keep previous seasons available

-- When Bracket_80_2_2 (Arena Season 6) is ACTIVE:
-- ENABLE Season 6 vendors (Glorious Gladiator)
-- Keep Season 5 vendors (Deadly Gladiator)

-- When Bracket_80_3 (Arena Season 7) is ACTIVE:
-- ENABLE Season 7 vendors (Furious Gladiator)
-- Keep previous seasons available

-- When Bracket_80_4_1 (Arena Season 8) is ACTIVE:
-- ENABLE Season 8 vendors (Wrathful Gladiator)
-- Keep previous seasons available (legacy)

-- ==========================================
-- IMPORTANT: SEASONAL ITEM AVAILABILITY
-- ==========================================

-- Items to check in npc_vendor table:
-- - Item IDs for each season's armor pieces
-- - Item IDs for each season's weapons
-- - Item IDs for seasonal mounts
-- - Item IDs for off-pieces and accessories

-- Example verification query:
-- SELECT `entry`, `item_template`, `Comment` FROM `npc_vendor`
-- WHERE `entry` IN (33609, 33610)
-- AND `item_template` BETWEEN 40000 AND 50000
-- ORDER BY `item_template`;

-- ==========================================
-- SEASONAL MOUNT AND COSMETICS
-- ==========================================

-- Each season typically has:
-- 1. Seasonal PvP mount (for rating thresholds)
-- 2. Tabard (seasonal design)
-- 3. Achievement-specific rewards
-- 4. Rating-specific titles

-- These should be enabled when their respective brackets are active

-- ==========================================
-- CONQUEST POINT MANAGEMENT
-- ==========================================

-- Note: Conquest points are typically:
-- - Awarded from arena wins
-- - Capped weekly per season
-- - Converted to honor if not spent at season end

-- Each season may have different point caps:
-- - Season 1-3: No point cap (early seasons)
-- - Season 4-8: Weekly caps (4000+ per week typically)

-- Verify your world database has proper conquest point rewards configured
-- for each arena bracket/season combination
