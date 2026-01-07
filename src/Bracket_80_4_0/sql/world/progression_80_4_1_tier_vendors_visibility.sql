-- Propósito: asegurar que todos los vendors de tier T7-T10 estén visibles y con flag de vendedor cuando se habilita T10 (bracket 80_4_1).
-- Alcance: activa phaseMask=1 y npcflag vendor (128) para vendors de T7, T8, T9 y T10 listados abajo.
-- Vendors cubiertos: T7 (33964,35578,35577,31582), T8 (35494,35574), T9 (35579,35580), T10 (31579,35573,31580,37942).

-- T7 vendors (ensure enabled)
UPDATE `creature` SET `phaseMask` = 1 WHERE `id1` IN (33964,35578,35577,31582);
UPDATE `creature_template` SET `npcflag` = `npcflag` | 128 WHERE `entry` IN (33964,35578,35577,31582);

-- T8 vendors (ensure enabled)
UPDATE `creature` SET `phaseMask` = 1 WHERE `id1` IN (35494,35574);
UPDATE `creature_template` SET `npcflag` = `npcflag` | 128 WHERE `entry` IN (35494,35574);

-- T9 vendors (ensure enabled)
UPDATE `creature` SET `phaseMask` = 1 WHERE `id1` IN (35579,35580);
UPDATE `creature_template` SET `npcflag` = `npcflag` | 128 WHERE `entry` IN (35579,35580);

-- T10 vendors (enable)
UPDATE `creature` SET `phaseMask` = 1 WHERE `id1` IN (31579,35573,31580,37942);
UPDATE `creature_template` SET `npcflag` = `npcflag` | 128 WHERE `entry` IN (
    31579, -- Matilda Brightlink
    35573, -- Magistrix Lambriesse
    31580, -- Lugrah
    37942  -- Arcanist Uovril
);
