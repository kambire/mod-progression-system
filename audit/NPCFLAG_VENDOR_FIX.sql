-- NPC vendor flag fixes (npcflag bit 128) for mod-progression-blizzlike.
-- MySQL 8.6 compatible.
--
-- This file is manual: run ONLY the section that matches your active bracket.
-- It does not rollback npc_vendor item changes. Use DB backups if you need full rollback.

-- ======================================
-- Bracket_0: disable endgame PvP + arena vendors
-- ======================================
-- Arena S4 vendor (BRD)
UPDATE `creature_template` SET `npcflag` = `npcflag` & ~128 WHERE `entry` = 28225;

-- Arena S7 vendors
UPDATE `creature_template` SET `npcflag` = `npcflag` & ~128
WHERE `entry` IN (34093, 33939, 33935, 33929);

-- Endgame PvP vendors (60/70/80)
UPDATE `creature_template` SET `npcflag` = `npcflag` & ~128
WHERE `entry` IN (12784, 12785, 12778, 12794, 12795, 12788, 34075, 34078, 34081, 34043, 34038, 34060, 34063, 40607);
-- Optional: bracket 0 also clears 4096 in the module SQL.
UPDATE `creature_template` SET `npcflag` = `npcflag` & ~4096
WHERE `entry` IN (12784, 12785, 12778, 12794, 12795, 12788, 34075, 34078, 34081, 34043, 34038, 34060, 34063, 40607);

-- ======================================
-- Bracket_50_59_2: enable PvP vendors (S0)
-- ======================================
UPDATE `creature_template` SET `npcflag` = `npcflag` | 128 | 4096
WHERE `entry` IN (12785, 12795);

-- ======================================
-- Bracket_60_1_1: enable PvP vendors (S0)
-- ======================================
UPDATE `creature_template` SET `npcflag` = `npcflag` | 128 | 4096
WHERE `entry` IN (12785, 12795);

-- ======================================
-- Bracket_61_64: enable PvP vendors + disable Netherstorm arena vendors
-- ======================================
UPDATE `creature_template` SET `npcflag` = `npcflag` | 128 | 4096
WHERE `entry` IN (12784, 12794);

UPDATE `creature_template` SET `npcflag` = `npcflag` & ~128
WHERE `entry` IN (
  26352, 32355, 33916, 33932, 33933, 40206,
  34089, 34091, 34094, 40209, 32356, 32405,
  33918, 33931, 33940, 40207, 24392, 32354,
  33919, 33930, 33941, 40208
);

-- ======================================
-- Bracket_70_2_1: restore Netherstorm arena vendors
-- ======================================
UPDATE `creature_template` SET `npcflag` = `npcflag` | 128
WHERE `entry` IN (
  26352, 32355, 33916, 33932, 33933, 40206,
  34089, 34091, 34094, 40209, 32356, 32405,
  33918, 33931, 33940, 40207, 24392, 32354,
  33919, 33930, 33941, 40208
);

-- ======================================
-- Bracket_71_74: restore arena S4 vendor (BRD)
-- ======================================
UPDATE `creature_template` SET `npcflag` = `npcflag` | 128 WHERE `entry` = 28225;

-- ======================================
-- Bracket_80_1_1: restore arena S7 vendors
-- ======================================
UPDATE `creature_template` SET `npcflag` = `npcflag` | 128
WHERE `entry` IN (34093, 33939, 33935, 33929);

-- ======================================
-- Restore defaults (module disabled)
-- ======================================
-- If the module is disabled and you want to return to default vendor visibility,
-- re-enable the vendor flag for every entry touched by this module.
UPDATE `creature_template` SET `npcflag` = `npcflag` | 128
WHERE `entry` IN (
  28225, 34093, 33939, 33935, 33929,
  12784, 12785, 12778, 12794, 12795, 12788,
  34075, 34078, 34081, 34043, 34038, 34060, 34063, 40607,
  26352, 32355, 33916, 33932, 33933, 40206,
  34089, 34091, 34094, 40209, 32356, 32405,
  33918, 33931, 33940, 40207, 24392, 32354,
  33919, 33930, 33941, 40208
);
-- Optional: restore 4096 for endgame PvP vendors (if your default DB uses it).
UPDATE `creature_template` SET `npcflag` = `npcflag` | 4096
WHERE `entry` IN (12784, 12785, 12778, 12794, 12795, 12788, 34075, 34078, 34081, 34043, 34038, 34060, 34063, 40607);
