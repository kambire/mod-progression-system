-- Activa el vendedor de emblemas de Conquista al abrir Ulduar (bracket 80_2_2).
-- Revertimos la fase 64 inicial para que el vendedor sea visible al público.
-- NPC: 33963 (Conquista/Ulduar)

START TRANSACTION;

UPDATE creature
SET phaseMask = 1
WHERE id1 = 33963;

COMMIT;
