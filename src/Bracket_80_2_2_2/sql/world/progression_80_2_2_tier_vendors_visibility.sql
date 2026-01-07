-- Tier vendors visibility (Bracket 80_2_2 - T8 activo)
-- Regla: mostrar T7 y T8; ocultar T9-T10.

-- T7 vendors (ensure enabled)
UPDATE `creature` SET `phaseMask` = 1 WHERE `id1` IN (33964,35578,35577,31582);
UPDATE `creature_template` SET `npcflag` = `npcflag` | 128 WHERE `entry` IN (33964,35578,35577,31582);

-- T8 vendors (enable)
UPDATE `creature` SET `phaseMask` = 1 WHERE `id1` IN (35494,35574);
UPDATE `creature_template` SET `npcflag` = `npcflag` | 128 WHERE `entry` IN (
    35494, -- Arcanist Miluria
    35574  -- Magistrix Iruvia
);

-- Ocultar T9-T10
UPDATE `creature_template` SET `npcflag` = `npcflag` &~ 128 WHERE `entry` IN (
    35579,35580,
    31579,35573,31580,37942
);
