-- Propósito: restaurar el Kor'Kron Overseer en Entrañas (map 0) usando entry 36213 con su equipo por defecto.
-- Acción: actualiza criaturas con id1=5624 para asignar id1=36213 y equipment_id=1.
UPDATE `creature` SET `id1`=36213, `equipment_id`=1 WHERE `map`=0 AND `id1`=5624;
