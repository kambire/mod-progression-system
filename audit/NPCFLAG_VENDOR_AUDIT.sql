-- NPC vendor flag audit (npcflag bit 128) for mod-progression-blizzlike.
-- MySQL 8.6 compatible.
--
-- Usage:
--   SET @target_bracket := 'Bracket_0';
--   -- then run the queries below.
--
-- Brackets covered (only those that toggle npcflag 128 in this module):
--   Bracket_0, Bracket_50_59_2, Bracket_60_1_1, Bracket_61_64,
--   Bracket_70_2_1, Bracket_71_74, Bracket_80_1_1

SET @target_bracket := 'Bracket_0';

WITH expected AS (
  -- Bracket_0: disable endgame PvP vendors + arena vendors (S4/S7).
  SELECT 'Bracket_0' AS bracket, 28225 AS entry, 0 AS should_vendor, 'Arena S4 vendor (BRD)' AS note
  UNION ALL SELECT 'Bracket_0', 34093, 0, 'Arena S7 vendor'
  UNION ALL SELECT 'Bracket_0', 33939, 0, 'Arena S7 vendor'
  UNION ALL SELECT 'Bracket_0', 33935, 0, 'Arena S7 vendor'
  UNION ALL SELECT 'Bracket_0', 33929, 0, 'Arena S7 vendor'
  UNION ALL SELECT 'Bracket_0', 12784, 0, 'Endgame PvP vendor'
  UNION ALL SELECT 'Bracket_0', 12785, 0, 'Endgame PvP vendor'
  UNION ALL SELECT 'Bracket_0', 12778, 0, 'Endgame PvP vendor'
  UNION ALL SELECT 'Bracket_0', 12794, 0, 'Endgame PvP vendor'
  UNION ALL SELECT 'Bracket_0', 12795, 0, 'Endgame PvP vendor'
  UNION ALL SELECT 'Bracket_0', 12788, 0, 'Endgame PvP vendor'
  UNION ALL SELECT 'Bracket_0', 34075, 0, 'Endgame PvP vendor'
  UNION ALL SELECT 'Bracket_0', 34078, 0, 'Endgame PvP vendor'
  UNION ALL SELECT 'Bracket_0', 34081, 0, 'Endgame PvP vendor'
  UNION ALL SELECT 'Bracket_0', 34043, 0, 'Endgame PvP vendor'
  UNION ALL SELECT 'Bracket_0', 34038, 0, 'Endgame PvP vendor'
  UNION ALL SELECT 'Bracket_0', 34060, 0, 'Endgame PvP vendor'
  UNION ALL SELECT 'Bracket_0', 34063, 0, 'Endgame PvP vendor'
  UNION ALL SELECT 'Bracket_0', 40607, 0, 'Endgame PvP vendor'

  -- Bracket_50_59_2: enable PvP vendors (S0).
  UNION ALL SELECT 'Bracket_50_59_2', 12785, 1, 'PvP vendor (Alliance)'
  UNION ALL SELECT 'Bracket_50_59_2', 12795, 1, 'PvP vendor (Horde)'

  -- Bracket_60_1_1: enable PvP vendors (S0).
  UNION ALL SELECT 'Bracket_60_1_1', 12785, 1, 'PvP vendor (Alliance)'
  UNION ALL SELECT 'Bracket_60_1_1', 12795, 1, 'PvP vendor (Horde)'

  -- Bracket_61_64: enable PvP vendors + disable Netherstorm arena vendors.
  UNION ALL SELECT 'Bracket_61_64', 12784, 1, 'PvP vendor (Alliance)'
  UNION ALL SELECT 'Bracket_61_64', 12794, 1, 'PvP vendor (Horde)'
  UNION ALL SELECT 'Bracket_61_64', 26352, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 32355, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 33916, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 33932, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 33933, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 40206, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 34089, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 34091, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 34094, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 40209, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 32356, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 32405, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 33918, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 33931, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 33940, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 40207, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 24392, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 32354, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 33919, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 33930, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 33941, 0, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_61_64', 40208, 0, 'Netherstorm arena vendor'

  -- Bracket_70_2_1: restore Netherstorm arena vendors.
  UNION ALL SELECT 'Bracket_70_2_1', 26352, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 32355, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 33916, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 33932, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 33933, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 40206, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 34089, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 34091, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 34094, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 40209, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 32356, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 32405, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 33918, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 33931, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 33940, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 40207, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 24392, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 32354, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 33919, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 33930, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 33941, 1, 'Netherstorm arena vendor'
  UNION ALL SELECT 'Bracket_70_2_1', 40208, 1, 'Netherstorm arena vendor'

  -- Bracket_71_74: restore arena S4 vendor.
  UNION ALL SELECT 'Bracket_71_74', 28225, 1, 'Arena S4 vendor (BRD)'

  -- Bracket_80_1_1: restore arena S7 vendors.
  UNION ALL SELECT 'Bracket_80_1_1', 34093, 1, 'Arena S7 vendor'
  UNION ALL SELECT 'Bracket_80_1_1', 33939, 1, 'Arena S7 vendor'
  UNION ALL SELECT 'Bracket_80_1_1', 33935, 1, 'Arena S7 vendor'
  UNION ALL SELECT 'Bracket_80_1_1', 33929, 1, 'Arena S7 vendor'
)
SELECT
  e.bracket,
  e.entry,
  ct.name,
  ct.npcflag,
  (ct.npcflag & 128) <> 0 AS has_vendor_flag,
  e.should_vendor,
  CASE
    WHEN ct.entry IS NULL THEN 'MISSING'
    WHEN ((ct.npcflag & 128) <> 0) = e.should_vendor THEN 'OK'
    ELSE 'MISMATCH'
  END AS status,
  e.note
FROM expected e
LEFT JOIN creature_template ct ON ct.entry = e.entry
WHERE e.bracket = @target_bracket
ORDER BY e.entry;

-- Mismatches only
SELECT
  e.bracket,
  e.entry,
  ct.name,
  ct.npcflag,
  (ct.npcflag & 128) <> 0 AS has_vendor_flag,
  e.should_vendor,
  e.note
FROM expected e
LEFT JOIN creature_template ct ON ct.entry = e.entry
WHERE e.bracket = @target_bracket
  AND (ct.entry IS NULL OR ((ct.npcflag & 128) <> 0) <> e.should_vendor)
ORDER BY e.entry;
