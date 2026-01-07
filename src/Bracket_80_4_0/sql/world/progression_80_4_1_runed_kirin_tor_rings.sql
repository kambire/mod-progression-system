-- Propósito: añadir las Runed Band/Loop/Ring/Signet of the Kirin Tor a Harold Winston al abrir ICC (bracket 80_4_1).
-- Acción: limpia entradas previas y reinserta los 4 anillos con sus ExtendedCost (2592-2595) para el vendedor 32172.
DELETE FROM `npc_vendor` WHERE `entry` = 32172 AND `item` IN (51557, 51558, 51559, 51560);
INSERT INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) VALUES
(32172, 0, 51557, 0, 0, 2592, 0), -- Runed Signet of the Kirin Tor
(32172, 0, 51558, 0, 0, 2593, 0), -- Runed Loop of the Kirin Tor
(32172, 0, 51559, 0, 0, 2594, 0), -- Runed Ring of the Kirin Tor
(32172, 0, 51560, 0, 0, 2595, 0); -- Runed Band of the Kirin Tor
