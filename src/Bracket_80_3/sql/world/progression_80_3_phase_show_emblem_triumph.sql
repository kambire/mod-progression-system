-- Activa el vendedor de emblemas de Triunfo al abrir Trial of the Crusader (bracket 80_3).
-- Revertimos la fase 64 inicial para que el vendedor sea visible al público.
-- NPC: 35495 (Triunfo/ToC)

START TRANSACTION;

UPDATE creature
SET phaseMask = 1
WHERE id1 = 35495;

COMMIT;
