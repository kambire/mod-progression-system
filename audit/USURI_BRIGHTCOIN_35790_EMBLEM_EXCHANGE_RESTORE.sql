-- Usuri Brightcoin (35790) emblem exchange RESTORE (world.npc_vendor)
-- Restores vendor inventory from `mod_progression_backup_npc_vendor_35790` (if present).
--
-- Run against the `world` database.

SELECT COUNT(*) INTO @HAS_BACKUP
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'mod_progression_backup_npc_vendor_35790';

SELECT @HAS_BACKUP AS backup_table_present;

-- If @HAS_BACKUP = 0, you don't have a backup (module scripts were not applied yet).

-- Restore
DELETE FROM `npc_vendor` WHERE `entry` = 35790;

INSERT INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`)
SELECT `entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`
FROM `mod_progression_backup_npc_vendor_35790`
WHERE `entry` = 35790;

-- Verify
SELECT `entry`, `slot`, `item`, `ExtendedCost`
FROM `npc_vendor`
WHERE `entry` = 35790
ORDER BY `slot`;

