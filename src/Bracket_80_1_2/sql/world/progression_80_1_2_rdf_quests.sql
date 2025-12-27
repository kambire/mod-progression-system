-- ProgressionSystem - LFG daily rewards (Bracket_80_1_2)
-- SERVER SOURCE OF TRUTH:
-- - Diaria LFG: HEROISMO (40752)
--
-- Quest IDs (common AzerothCore WotLK):
-- 24788: Daily heroic random (1st)
-- 24789: Daily heroic random (Nth)
-- 24790: Daily normal random (Nth)

UPDATE `quest_template` SET `rewarditem1` = 40752, `RewardAmount1` = 1 WHERE `ID` IN (24788,24789,24790);
