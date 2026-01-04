-- Hide all WotLK emblem vendors very early (bracket 71_74) so only GMs see them.
-- Each bracket-specific script later removes this phasing when its tier/emblem is due.
-- NPCs cubiertos:
--   31581 (Alianza, emblemas Heroísmo/Valor)
--   31582 (Horda, emblemas Heroísmo/Valor)
--   33963 (Conquista/Ulduar)
--   35495 (Triunfo/ToC)
--   37941 (Escarcha/ICC)

START TRANSACTION;

-- Backup spawns
DROP TABLE IF EXISTS backupKambi_creature_phase_emblems_hide_7174;
CREATE TABLE backupKambi_creature_phase_emblems_hide_7174 LIKE creature;
INSERT INTO backupKambi_creature_phase_emblems_hide_7174
SELECT * FROM creature WHERE id1 IN (31581,31582,33963,35495,37941,33963,35495);

-- Set high phase mask to hide from players (GMs typically bypass phase)
UPDATE creature
SET phaseMask = 8
WHERE id1 IN (31581,31582,33963,35495,37941,33963,35495);

COMMIT;
