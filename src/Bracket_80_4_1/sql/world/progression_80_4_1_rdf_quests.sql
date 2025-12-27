-- ProgressionSystem - RDF rewards (Bracket_80_4_1)
-- SERVER SOURCE OF TRUTH (ICC / 3.3 era):
-- - Random Heroic (first of day): 2x Frost (49426)
-- - Random Heroic (after first):  2x Triumph (47241)
-- - Random Normal: keep Triumph (47241) x1 (not a focus of 3.3 gearing, but kept consistent)
--
-- Quest IDs (common AzerothCore WotLK):
-- 24788: Daily heroic random (1st)
-- 24789: Daily heroic random (Nth)
-- 24790: Daily normal random (Nth)

UPDATE `quest_template` SET `rewarditem1` = 49426, `RewardAmount1` = 2 WHERE `ID` = 24788;
UPDATE `quest_template` SET `rewarditem1` = 47241, `RewardAmount1` = 2 WHERE `ID` = 24789;
UPDATE `quest_template` SET `rewarditem1` = 47241, `RewardAmount1` = 1 WHERE `ID` = 24790;
