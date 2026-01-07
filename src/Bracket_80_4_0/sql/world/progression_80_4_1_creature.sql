-- Propósito: restaurar la visibilidad de Toravon en Cámara de Archavon al activar T10 (bracket 80_4_1).
-- Acción: elimina la fase oculta dejando phaseMask en 1 para el NPC 38433.
UPDATE `creature` SET `phaseMask` = 1 WHERE `id1` = 38433;
