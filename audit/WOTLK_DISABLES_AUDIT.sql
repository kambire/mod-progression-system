-- WotLK disables audit (world.disables)
-- MySQL 8.x compatible (uses CTE).
--
-- What this checks:
-- - Northrend dungeons (normal-only vs heroic unlocked)
-- - WotLK raid tier unlocks (T7 -> Ulduar -> ToC/Onyxia -> ICC -> Ruby Sanctum)
-- - RDF/LFG hard-lock rows (sourceType=8) used by this module
--
-- Usage:
--   1) Set the target bracket below
--   2) Run the file against the `world` database

SET @BRACKET := '80_3';

WITH
brackets AS (
	SELECT 1 AS stage, '71_74' AS bracket UNION ALL
	SELECT 2 AS stage, '75_79' AS bracket UNION ALL
	SELECT 3 AS stage, '80_1_1' AS bracket UNION ALL
	SELECT 4 AS stage, '80_1_2' AS bracket UNION ALL
	SELECT 5 AS stage, '80_2_1' AS bracket UNION ALL
	SELECT 6 AS stage, '80_2_2' AS bracket UNION ALL
	SELECT 7 AS stage, '80_3'   AS bracket UNION ALL
	SELECT 8 AS stage, '80_4_1' AS bracket UNION ALL
	SELECT 9 AS stage, '80_4_2' AS bracket
),
target AS (
	SELECT stage, bracket
	FROM brackets
	WHERE bracket = @BRACKET
),
checks AS (
	-- =========================
	-- sourceType=2 (map disables)
	-- =========================

	-- Northrend leveling/launch dungeons
	SELECT 2 AS sourceType, 574 AS entry, 'Utgarde Keep'              AS name, 3 AS mask, 1 AS normal_unlock_stage, 4 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 575 AS entry, 'Utgarde Pinnacle'          AS name, 3 AS mask, 2 AS normal_unlock_stage, 4 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 576 AS entry, 'The Nexus'                AS name, 3 AS mask, 1 AS normal_unlock_stage, 4 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 578 AS entry, 'The Oculus'               AS name, 3 AS mask, 2 AS normal_unlock_stage, 4 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 595 AS entry, 'The Culling of Stratholme' AS name, 3 AS mask, 2 AS normal_unlock_stage, 4 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 599 AS entry, 'Halls of Stone'            AS name, 3 AS mask, 2 AS normal_unlock_stage, 4 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 600 AS entry, 'Drak''Tharon Keep'         AS name, 3 AS mask, 1 AS normal_unlock_stage, 4 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 601 AS entry, 'Azjol-Nerub'               AS name, 3 AS mask, 1 AS normal_unlock_stage, 4 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 602 AS entry, 'Halls of Lightning'        AS name, 3 AS mask, 2 AS normal_unlock_stage, 4 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 604 AS entry, 'Gundrak'                   AS name, 3 AS mask, 2 AS normal_unlock_stage, 4 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 608 AS entry, 'Violet Hold'               AS name, 3 AS mask, 2 AS normal_unlock_stage, 4 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 619 AS entry, 'Ahn''kahet: The Old Kingdom' AS name, 3 AS mask, 1 AS normal_unlock_stage, 4 AS heroic_unlock_stage UNION ALL

	-- T7 raids unlock in 80_2_1
	SELECT 2 AS sourceType, 533 AS entry, 'Naxxramas'          AS name, 3  AS mask, 5 AS normal_unlock_stage, 5 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 615 AS entry, 'The Obsidian Sanctum' AS name, 3 AS mask, 5 AS normal_unlock_stage, 5 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 616 AS entry, 'The Eye of Eternity' AS name, 3 AS mask, 5 AS normal_unlock_stage, 5 AS heroic_unlock_stage UNION ALL

	-- Ulduar + VoA unlock in 80_2_2
	SELECT 2 AS sourceType, 603 AS entry, 'Ulduar'              AS name, 3 AS mask, 6 AS normal_unlock_stage, 6 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 624 AS entry, 'Vault of Archavon'   AS name, 3 AS mask, 6 AS normal_unlock_stage, 6 AS heroic_unlock_stage UNION ALL

	-- ToC / Onyxia 80 unlock in 80_3
	SELECT 2 AS sourceType, 649 AS entry, 'Trial of the Crusader' AS name, 15 AS mask, 7 AS normal_unlock_stage, 7 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 249 AS entry, 'Onyxia''s Lair (lvl 80)' AS name, 3 AS mask, 7 AS normal_unlock_stage, 7 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 650 AS entry, 'Trial of the Champion' AS name, 3 AS mask, 7 AS normal_unlock_stage, 7 AS heroic_unlock_stage UNION ALL

	-- ICC + ICC 5-mans unlock in 80_4_1
	SELECT 2 AS sourceType, 631 AS entry, 'Icecrown Citadel'     AS name, 15 AS mask, 8 AS normal_unlock_stage, 8 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 632 AS entry, 'The Forge of Souls'    AS name, 3  AS mask, 8 AS normal_unlock_stage, 8 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 658 AS entry, 'Pit of Saron'          AS name, 3  AS mask, 8 AS normal_unlock_stage, 8 AS heroic_unlock_stage UNION ALL
	SELECT 2 AS sourceType, 668 AS entry, 'Halls of Reflection'   AS name, 3  AS mask, 8 AS normal_unlock_stage, 8 AS heroic_unlock_stage UNION ALL

	-- Ruby Sanctum unlock in 80_4_2
	SELECT 2 AS sourceType, 724 AS entry, 'The Ruby Sanctum'      AS name, 15 AS mask, 9 AS normal_unlock_stage, 9 AS heroic_unlock_stage UNION ALL

	-- =========================
	-- sourceType=8 (RDF/LFG hard-lock)
	-- =========================
	SELECT 8 AS sourceType, 249 AS entry, '[RDF] Onyxia 80'        AS name, 3  AS mask, 7 AS normal_unlock_stage, 7 AS heroic_unlock_stage UNION ALL
	SELECT 8 AS sourceType, 649 AS entry, '[RDF] Trial of the Crusader' AS name, 15 AS mask, 7 AS normal_unlock_stage, 7 AS heroic_unlock_stage UNION ALL
	SELECT 8 AS sourceType, 650 AS entry, '[RDF] Trial of the Champion' AS name, 3  AS mask, 7 AS normal_unlock_stage, 7 AS heroic_unlock_stage UNION ALL
	SELECT 8 AS sourceType, 631 AS entry, '[RDF] Icecrown Citadel' AS name, 15 AS mask, 8 AS normal_unlock_stage, 8 AS heroic_unlock_stage UNION ALL
	SELECT 8 AS sourceType, 632 AS entry, '[RDF] The Forge of Souls' AS name, 3 AS mask, 8 AS normal_unlock_stage, 8 AS heroic_unlock_stage UNION ALL
	SELECT 8 AS sourceType, 658 AS entry, '[RDF] Pit of Saron'     AS name, 3  AS mask, 8 AS normal_unlock_stage, 8 AS heroic_unlock_stage UNION ALL
	SELECT 8 AS sourceType, 668 AS entry, '[RDF] Halls of Reflection' AS name, 3 AS mask, 8 AS normal_unlock_stage, 8 AS heroic_unlock_stage
),
expected AS (
	SELECT
		t.bracket,
		c.sourceType,
		c.entry,
		c.name,
		c.mask,
		CASE
			WHEN t.stage < c.normal_unlock_stage THEN 'locked'
			WHEN t.stage < c.heroic_unlock_stage THEN 'normal_only'
			ELSE 'unlocked'
		END AS expectation
	FROM target t
	JOIN checks c
),
actual AS (
	SELECT d.sourceType, d.entry, d.flags
	FROM `disables` d
	JOIN checks c
		ON c.sourceType = d.sourceType AND c.entry = d.entry
)
SELECT
	e.bracket,
	e.sourceType,
	e.entry,
	e.name,
	e.expectation,
	a.flags AS actual_flags
FROM expected e
LEFT JOIN actual a
	ON a.sourceType = e.sourceType AND a.entry = e.entry
WHERE
	CASE e.expectation
		WHEN 'locked' THEN (a.entry IS NOT NULL AND (a.flags & e.mask) = e.mask)
		WHEN 'normal_only' THEN (a.entry IS NOT NULL AND (a.flags & e.mask) = 2)
		WHEN 'unlocked' THEN (a.entry IS NULL OR a.flags = 0)
		ELSE 0
	END = 0
ORDER BY e.sourceType, e.entry;

