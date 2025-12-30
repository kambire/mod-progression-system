-- Usuri Brightcoin (35790) emblem exchange audit (world.npc_vendor)
-- MySQL 8.x compatible.
--
-- Goal:
--   Validate that the emblem exchange helper vendor only allows HIGHER => CURRENT conversions
--   for the selected bracket (and does NOT allow lower => higher).
--
-- Usage:
--   1) Set the target bracket below
--   2) Run against the `world` database
--
-- Notes:
-- - This checks ONLY npc_vendor rows for entry=35790.
-- - ExtendedCost IDs are validated by expected numeric values (AzerothCore WotLK 3.3.5a).

SET @BRACKET := '80_2_1';

WITH
expected AS (
	-- Bracket -> which target emblem should be BUYABLE at this stage (current heroic emblem)
	SELECT '80_1_2' AS bracket, 40752 AS target UNION ALL
	SELECT '80_2_1' AS bracket, 40752 AS target UNION ALL
	SELECT '80_2_2' AS bracket, 40753 AS target UNION ALL
	SELECT '80_3'   AS bracket, 45624 AS target UNION ALL
	SELECT '80_4_1' AS bracket, 47241 AS target UNION ALL
	SELECT '80_4_2' AS bracket, 47241 AS target
),
rules AS (
	-- Target emblem -> which ExtendedCost IDs are allowed (paying higher emblems only)
	-- 2589: pay Valor (40753)
	-- 2637: pay Conquest (45624)
	-- 2707: pay Triumph (47241)
	-- 2743: pay Frost (49426)
	SELECT 40752 AS target, 2589 AS extCost UNION ALL
	SELECT 40752 AS target, 2637 AS extCost UNION ALL
	SELECT 40752 AS target, 2707 AS extCost UNION ALL
	SELECT 40752 AS target, 2743 AS extCost UNION ALL
	SELECT 40753 AS target, 2637 AS extCost UNION ALL
	SELECT 40753 AS target, 2707 AS extCost UNION ALL
	SELECT 40753 AS target, 2743 AS extCost UNION ALL
	SELECT 45624 AS target, 2707 AS extCost UNION ALL
	SELECT 45624 AS target, 2743 AS extCost UNION ALL
	SELECT 47241 AS target, 2743 AS extCost
),
target AS (
	SELECT e.bracket, e.target
	FROM expected e
	WHERE e.bracket = @BRACKET
),
actual AS (
	SELECT `entry`, `slot`, `item`, `ExtendedCost`
	FROM `npc_vendor`
	WHERE `entry` = 35790
)
SELECT
	t.bracket,
	t.target AS expected_target_item,
	a.`slot`,
	a.`item` AS actual_item,
	a.`ExtendedCost` AS actual_extendedcost,
	CASE
		WHEN a.`item` IS NULL THEN 'MISSING_VENDOR'
		WHEN a.`item` <> t.target THEN 'WRONG_TARGET_ITEM'
		WHEN NOT EXISTS (SELECT 1 FROM rules r WHERE r.target = t.target AND r.extCost = a.`ExtendedCost`) THEN 'WRONG_EXTENDEDCOST'
		ELSE 'OK'
	END AS status
FROM target t
LEFT JOIN actual a ON 1=1
WHERE
	a.`item` IS NULL
	OR a.`item` <> t.target
	OR NOT EXISTS (SELECT 1 FROM rules r WHERE r.target = t.target AND r.extCost = a.`ExtendedCost`)
ORDER BY a.`slot`;

-- Optional: show full vendor state
SELECT `entry`, `slot`, `item`, `ExtendedCost`
FROM `npc_vendor`
WHERE `entry` = 35790
ORDER BY `slot`;

