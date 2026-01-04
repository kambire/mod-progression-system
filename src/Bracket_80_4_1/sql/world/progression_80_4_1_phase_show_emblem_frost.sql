-- Activa el vendedor de emblemas de Escarcha al abrir ICC (bracket 80_4_1).
-- Revertimos la fase 64 inicial para que el vendedor sea visible al público.
-- NPC: 37941 (Emblema de Escarcha)

START TRANSACTION;

UPDATE creature
SET phaseMask = 1
WHERE id1 = 37941;

COMMIT;
