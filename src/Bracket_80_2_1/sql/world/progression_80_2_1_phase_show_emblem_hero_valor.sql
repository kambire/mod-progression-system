-- Activa los vendedores de emblemas de Heroísmo/Valor al abrir Naxxramas (T7, bracket 80_2_1).
-- Revertimos la fase 64 aplicada en 71_74 para que sean visibles de forma normal.
-- NPCs: 31581 (Alianza), 31582 (Horda)

START TRANSACTION;

UPDATE creature
SET phaseMask = 1
WHERE id1 IN (31581,31582);

COMMIT;
