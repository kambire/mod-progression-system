-- ProgressionSystem - Heroic avg item level gate (Bracket 80_2_1)
--
-- This module enforces an average item level requirement when players enter heroic 5-man dungeons.
-- Avg iLvl is computed from equipped items (excluding shirt/tabard).
--
-- Apply into the WORLD database.

CREATE TABLE IF NOT EXISTS `mod_progression_heroic_gs` (
  `bracket` VARCHAR(32) NOT NULL,
  `enabled` TINYINT(1) NOT NULL DEFAULT 0,
  `avg_ilvl_multiplier` FLOAT NOT NULL DEFAULT 0,
  `required_heroic` INT UNSIGNED NOT NULL DEFAULT 0,
  `required_icc5_normal` INT UNSIGNED NOT NULL DEFAULT 0,
  `required_icc5_heroic` INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`bracket`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Global enable + ICC5 thresholds (FoS/PoS/HoR).
INSERT INTO `mod_progression_heroic_gs`
  (`bracket`, `enabled`, `avg_ilvl_multiplier`, `required_icc5_normal`, `required_icc5_heroic`)
VALUES
  ('GLOBAL', 1, 1.0, 250, 270)
ON DUPLICATE KEY UPDATE
  `enabled` = VALUES(`enabled`),
  `avg_ilvl_multiplier` = VALUES(`avg_ilvl_multiplier`),
  `required_icc5_normal` = VALUES(`required_icc5_normal`),
  `required_icc5_heroic` = VALUES(`required_icc5_heroic`);

-- Bracket-specific heroic requirement.
-- Required (avg iLvl): 175
INSERT INTO `mod_progression_heroic_gs`
  (`bracket`, `required_heroic`)
VALUES
  ('80_2_1', 175)
ON DUPLICATE KEY UPDATE
  `required_heroic` = VALUES(`required_heroic`);
