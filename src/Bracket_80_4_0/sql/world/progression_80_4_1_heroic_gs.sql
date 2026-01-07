-- Propósito: definir requisitos de iLvl promedio para heroicas y ICC5 en bracket 80_4_1.
-- Config: tabla mod_progression_heroic_gs (global + thresholds ICC5); requerimiento heroico específico 80_4_1 = iLvl 240.
-- Compatibilidad: inserta/actualiza con ON DUPLICATE KEY para no romper valores existentes.

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
INSERT INTO `mod_progression_heroic_gs`
  (`bracket`, `required_heroic`)
VALUES
  ('80_4_1', 240)
ON DUPLICATE KEY UPDATE
  `required_heroic` = VALUES(`required_heroic`);
