-- Emblem exchange helper (Usuri Brightcoin - 35790)
-- Bracket: 80_2_1 (WotLK T7 raids)
--
-- Goal:
--   Provide a SAFE down-conversion to the bracket's heroic emblem, to mitigate DB mistakes where
--   a heroic boss drops a higher emblem than intended.
--
-- Rules:
-- - Only allow HIGHER => CURRENT conversions (never lower => higher).
-- - This script ONLY changes npc_vendor (it does not change boss loot tables).
--
-- Emblems (WotLK):
-- Heroism  40752
-- Valor    40753
-- Conquest 45624
-- Triumph  47241
-- Frost    49426
--
-- ExtendedCost IDs (AzerothCore WotLK 3.3.5a / item_extended_cost.dbc):
-- 2589 => pay 1x Valor (40753)
-- 2637 => pay 1x Conquest (45624)
-- 2707 => pay 1x Triumph (47241)
-- 2743 => pay 1x Frost (49426)

-- Backup vendor inventory (first run only)
CREATE TABLE IF NOT EXISTS `mod_progression_backup_npc_vendor_35790` LIKE `npc_vendor`;
INSERT IGNORE INTO `mod_progression_backup_npc_vendor_35790`
SELECT * FROM `npc_vendor` WHERE `entry` = 35790;

-- Rebuild vendor inventory for this bracket
DELETE FROM `npc_vendor` WHERE `entry` = 35790;

-- Target emblem: Heroism (40752)
INSERT INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) VALUES
(35790, 0, 40752, 0, 0, 2589, 0), -- Valor    -> Heroism
(35790, 1, 40752, 0, 0, 2637, 0), -- Conquest -> Heroism
(35790, 2, 40752, 0, 0, 2707, 0), -- Triumph  -> Heroism
(35790, 3, 40752, 0, 0, 2743, 0); -- Frost    -> Heroism

-- Prevent gold pricing accidents for emblem items (defensive; should already be 0 in a blizzlike DB)
UPDATE `item_template`
SET `BuyPrice` = 0, `SellPrice` = 0
WHERE `entry` IN (40752,40753,45624,47241,49426);

