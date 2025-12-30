-- WotLK weekly raid quests emblem audit (world.quest_template)
-- MySQL 8.x compatible (uses CTE).
--
-- What this checks:
-- - Weekly raid quest rewards (24579..24590) use the expected emblem for the selected bracket
-- - No extra emblem rewards are present in RewardItem2..4
--
-- Usage:
--   1) Set the target bracket below
--   2) Run the file against the `world` database

SET @BRACKET := '80_2_1';

WITH
expected AS (
	SELECT '80_1_1' AS bracket, 40752 AS emblem UNION ALL
	SELECT '80_1_2' AS bracket, 40752 AS emblem UNION ALL
	SELECT '80_2_1' AS bracket, 40752 AS emblem UNION ALL
	SELECT '80_2_2' AS bracket, 40753 AS emblem UNION ALL
	SELECT '80_3'   AS bracket, 45624 AS emblem UNION ALL
	SELECT '80_4_1' AS bracket, 47241 AS emblem UNION ALL
	SELECT '80_4_2' AS bracket, 47241 AS emblem
),
target AS (
	SELECT bracket, emblem
	FROM expected
	WHERE bracket = @BRACKET
),
quests AS (
	SELECT 24579 AS id, 'Sartharion Must Die!' AS name UNION ALL
	SELECT 24580 AS id, 'Anub''Rekhan Must Die!' AS name UNION ALL
	SELECT 24581 AS id, 'Noth the Plaguebringer Must Die!' AS name UNION ALL
	SELECT 24582 AS id, 'Instructor Razuvious Must Die!' AS name UNION ALL
	SELECT 24583 AS id, 'Patchwerk Must Die!' AS name UNION ALL
	SELECT 24584 AS id, 'Malygos Must Die!' AS name UNION ALL
	SELECT 24585 AS id, 'Flame Leviathan Must Die!' AS name UNION ALL
	SELECT 24586 AS id, 'Razorscale Must Die!' AS name UNION ALL
	SELECT 24587 AS id, 'Ignis the Furnace Master Must Die!' AS name UNION ALL
	SELECT 24588 AS id, 'XT-002 Deconstructor Must Die!' AS name UNION ALL
	SELECT 24589 AS id, 'Lord Jaraxxus Must Die!' AS name UNION ALL
	SELECT 24590 AS id, 'Lord Marrowgar Must Die!' AS name
),
actual AS (
	SELECT
		q.id,
		q.name,
		qt.`RewardItem1`,
		qt.`RewardAmount1`,
		qt.`RewardItem2`,
		qt.`RewardAmount2`,
		qt.`RewardItem3`,
		qt.`RewardAmount3`,
		qt.`RewardItem4`,
		qt.`RewardAmount4`
	FROM quests q
	LEFT JOIN `quest_template` qt ON qt.`ID` = q.id
)
SELECT
	t.bracket,
	a.id,
	a.name,
	t.emblem AS expected_emblem,
	a.`RewardItem1` AS actual_rewarditem1,
	a.`RewardAmount1` AS actual_rewardamount1,
	a.`RewardItem2` AS rewarditem2,
	a.`RewardItem3` AS rewarditem3,
	a.`RewardItem4` AS rewarditem4
FROM actual a
JOIN target t
WHERE
	-- Missing quest row
	a.`RewardItem1` IS NULL
	-- Wrong emblem in slot 1
	OR a.`RewardItem1` <> t.emblem
	-- Extra emblem rewards present in other slots
	OR a.`RewardItem2` IN (40752,40753,45624,47241,49426)
	OR a.`RewardItem3` IN (40752,40753,45624,47241,49426)
	OR a.`RewardItem4` IN (40752,40753,45624,47241,49426)
ORDER BY a.id;

