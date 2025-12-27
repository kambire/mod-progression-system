-- ProgressionSystem - Heroic pseudo-GS gate (Bracket 80_1_2)
-- Required (pseudoGS): 3500  (approx iLvl 175 with x20)

CREATE TABLE IF NOT EXISTS `mod_progression_heroic_gs` (
  `bracket` VARCHAR(32) NOT NULL,
  `enabled` TINYINT(1) NOT NULL DEFAULT 0,
  `avg_ilvl_multiplier` FLOAT NOT NULL DEFAULT 0,
  `required_heroic` INT UNSIGNED NOT NULL DEFAULT 0,
  `required_icc5_normal` INT UNSIGNED NOT NULL DEFAULT 0,
  `required_icc5_heroic` INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`bracket`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Global enable + multiplier + ICC5 thresholds (FoS/PoS/HoR).
INSERT INTO `mod_progression_heroic_gs`
  (`bracket`, `enabled`, `avg_ilvl_multiplier`, `required_icc5_normal`, `required_icc5_heroic`)
VALUES
  ('GLOBAL', 1, 20.0, 5000, 5400)
ON DUPLICATE KEY UPDATE
  `enabled` = VALUES(`enabled`),
  `avg_ilvl_multiplier` = VALUES(`avg_ilvl_multiplier`),
  `required_icc5_normal` = VALUES(`required_icc5_normal`),
  `required_icc5_heroic` = VALUES(`required_icc5_heroic`);

-- Bracket-specific heroic requirement.
INSERT INTO `mod_progression_heroic_gs`
  (`bracket`, `required_heroic`)
VALUES
  ('80_1_2', 3500)
ON DUPLICATE KEY UPDATE
  `required_heroic` = VALUES(`required_heroic`);
