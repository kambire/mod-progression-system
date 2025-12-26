-- Winter Veil vendors audit (AzerothCore world DB)
-- Run this manually against your `world` database.
--
-- Goal:
--  - List Winter Veil (and winter-themed) event NPCs that are vendors
--  - List what they sell (npc_vendor) with RequiredLevel/ItemLevel/ExtendedCost
--  - Flag items that don't fit the current progression bracket max level
--
-- How to use:
--  1) Set @BRACKET_MAX_LEVEL to your current bracket cap (e.g. 19 / 39 / 59 / 70 / 80).
--  2) (Optional) Set @NPC_ENTRY if you want to audit a single vendor entry.
--
-- Notes:
--  - This is an audit/report script; it does not modify anything unless you uncomment the cleanup section.

SET @BRACKET_MAX_LEVEL := 80;
SET @NPC_ENTRY := 0; -- 0 = all matched vendors

-- -----------------------------------------------------
-- A) Find candidate Winter Veil event entries
-- -----------------------------------------------------
-- AzerothCore typically stores event metadata in `game_event`.
SELECT `eventEntry`, `description`
FROM `game_event`
WHERE `description` LIKE '%Winter%'
   OR `description` LIKE '%Veil%'
   OR `description` LIKE '%Feast%'
ORDER BY `eventEntry`;

-- -----------------------------------------------------
-- B) Find NPCs spawned by those events (if any)
-- -----------------------------------------------------
-- This catches event-spawned vendors (common for seasonal NPCs).
DROP TEMPORARY TABLE IF EXISTS `tmp_winter_event_npcs`;
CREATE TEMPORARY TABLE `tmp_winter_event_npcs` AS
SELECT DISTINCT
    cr.`id1`      AS `npc_entry`,
    ct.`name`     AS `npc_name`,
    ct.`subname`  AS `npc_subname`,
    ge.`eventEntry` AS `eventEntry`,
    ge.`description` AS `event_description`
FROM `game_event` ge
JOIN `game_event_creature` gec ON gec.`eventEntry` = ge.`eventEntry`
JOIN `creature` cr ON cr.`guid` = gec.`guid`
JOIN `creature_template` ct ON ct.`entry` = cr.`id1`
WHERE (ge.`description` LIKE '%Winter%'
    OR ge.`description` LIKE '%Veil%'
    OR ge.`description` LIKE '%Feast%');

-- -----------------------------------------------------
-- C) Add name-based candidates (covers always-spawned vendors)
-- -----------------------------------------------------
DROP TEMPORARY TABLE IF EXISTS `tmp_winter_name_npcs`;
CREATE TEMPORARY TABLE `tmp_winter_name_npcs` AS
SELECT DISTINCT
    ct.`entry` AS `npc_entry`,
    ct.`name`  AS `npc_name`,
    ct.`subname` AS `npc_subname`,
    NULL AS `eventEntry`,
    NULL AS `event_description`
FROM `creature_template` ct
WHERE ct.`name` LIKE '%Smokywood%'
   OR ct.`name` LIKE '%Greatfather%'
   OR ct.`name` LIKE '%Winter%'
   OR ct.`subname` LIKE '%Winter%'
   OR ct.`subname` LIKE '%Veil%';

-- -----------------------------------------------------
-- D) Consolidate vendor entries we care about
-- -----------------------------------------------------
DROP TEMPORARY TABLE IF EXISTS `tmp_winter_vendors`;
CREATE TEMPORARY TABLE `tmp_winter_vendors` AS
SELECT DISTINCT
    x.`npc_entry`,
    x.`npc_name`,
    x.`npc_subname`,
    x.`eventEntry`,
    x.`event_description`
FROM (
    SELECT * FROM `tmp_winter_event_npcs`
    UNION ALL
    SELECT * FROM `tmp_winter_name_npcs`
) x
JOIN `npc_vendor` nv ON nv.`entry` = x.`npc_entry`
WHERE (@NPC_ENTRY = 0 OR x.`npc_entry` = @NPC_ENTRY);

-- Show vendor list
SELECT *
FROM `tmp_winter_vendors`
ORDER BY `npc_name`, `npc_entry`;

-- -----------------------------------------------------
-- E) Full vendor item listing + bracket classification
-- -----------------------------------------------------
SELECT
    v.`npc_entry`,
    v.`npc_name`,
    v.`npc_subname`,
    v.`eventEntry`,
    v.`event_description`,
    nv.`item` AS `item_entry`,
    it.`name` AS `item_name`,
    it.`Quality`,
    it.`ItemLevel`,
    it.`RequiredLevel`,
    nv.`ExtendedCost`,
    CASE
      WHEN it.`RequiredLevel` IS NULL THEN 'UNKNOWN'
      WHEN it.`RequiredLevel` = 0 THEN 'COSMETIC/NO-REQ'
      WHEN it.`RequiredLevel` <= 19 THEN 'Bracket_1_19'
      WHEN it.`RequiredLevel` <= 29 THEN 'Bracket_20_29'
      WHEN it.`RequiredLevel` <= 39 THEN 'Bracket_30_39'
      WHEN it.`RequiredLevel` <= 49 THEN 'Bracket_40_49'
      WHEN it.`RequiredLevel` <= 59 THEN 'Bracket_50_59'
      WHEN it.`RequiredLevel` <= 64 THEN 'Bracket_61_64'
      WHEN it.`RequiredLevel` <= 69 THEN 'Bracket_65_69'
      WHEN it.`RequiredLevel` <= 79 THEN 'Bracket_70_1_1+' -- WotLK leveling range
      ELSE 'Level_80+'
    END AS `suggested_bracket_by_level`,
    CASE
      WHEN it.`RequiredLevel` IS NULL THEN 0
      WHEN it.`RequiredLevel` = 0 THEN 0
      WHEN it.`RequiredLevel` > @BRACKET_MAX_LEVEL THEN 1
      ELSE 0
    END AS `is_above_bracket_max_level`
FROM `tmp_winter_vendors` v
JOIN `npc_vendor` nv ON nv.`entry` = v.`npc_entry`
LEFT JOIN `item_template` it ON it.`entry` = nv.`item`
ORDER BY `is_above_bracket_max_level` DESC, v.`npc_name`, nv.`item`;

-- -----------------------------------------------------
-- F) Items that exceed the current bracket cap (action list)
-- -----------------------------------------------------
SELECT
    v.`npc_entry`,
    v.`npc_name`,
    nv.`item` AS `item_entry`,
    it.`name` AS `item_name`,
    it.`RequiredLevel`,
    it.`ItemLevel`,
    nv.`ExtendedCost`
FROM `tmp_winter_vendors` v
JOIN `npc_vendor` nv ON nv.`entry` = v.`npc_entry`
JOIN `item_template` it ON it.`entry` = nv.`item`
WHERE it.`RequiredLevel` > 0
  AND it.`RequiredLevel` > @BRACKET_MAX_LEVEL
ORDER BY it.`RequiredLevel` DESC, it.`ItemLevel` DESC, v.`npc_entry`, nv.`item`;

-- -----------------------------------------------------
-- G) OPTIONAL cleanup (UNCOMMENT to apply)
-- -----------------------------------------------------
-- Deletes vendor items above current bracket max.
--
-- DELETE nv
-- FROM `npc_vendor` nv
-- JOIN `item_template` it ON it.`entry` = nv.`item`
-- WHERE nv.`entry` IN (SELECT `npc_entry` FROM `tmp_winter_vendors`)
--   AND it.`RequiredLevel` > 0
--   AND it.`RequiredLevel` > @BRACKET_MAX_LEVEL;
