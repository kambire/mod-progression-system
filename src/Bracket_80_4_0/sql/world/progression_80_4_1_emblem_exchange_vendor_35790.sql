-- Propósito: ofrecer conversión segura de emblemas altos -> actual (Triunfo) en el vendor Usuri Brightcoin (35790) para T10 (80_4_1).
-- Alcance: solo npc_vendor; respalda inventario, lo reconstruye y fija intercambio Frost(49426) -> Triumph(47241) con ExtendedCost 2743.
-- Seguridad: no toca tablas de botín de jefes; limpia precios de compra/venta de todos los emblemas para evitar oro accidental.

-- Backup vendor inventory (first run only)
CREATE TABLE IF NOT EXISTS `mod_progression_backup_npc_vendor_35790` LIKE `npc_vendor`;
INSERT IGNORE INTO `mod_progression_backup_npc_vendor_35790`
SELECT * FROM `npc_vendor` WHERE `entry` = 35790;

-- Rebuild vendor inventory for this bracket
DELETE FROM `npc_vendor` WHERE `entry` = 35790;

-- Target emblem: Triumph (47241)
INSERT INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) VALUES
(35790, 0, 47241, 0, 0, 2743, 0); -- Frost -> Triumph

-- Prevent gold pricing accidents for emblem items (defensive; should already be 0 in a blizzlike DB)
UPDATE `item_template`
SET `BuyPrice` = 0, `SellPrice` = 0
WHERE `entry` IN (40752,40753,45624,47241,49426);

