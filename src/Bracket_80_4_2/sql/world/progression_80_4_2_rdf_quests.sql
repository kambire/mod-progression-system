-- ProgressionSystem - LFG daily rewards (Bracket_80_4_2)
-- SERVER SOURCE OF TRUTH (default):
-- - Diaria LFG: TRIUNFO (47241)
-- If you want this bracket to give FROST (49426), change the item below to 49426.

UPDATE `quest_template` SET `rewarditem1` = 47241, `RewardAmount1` = 1 WHERE `ID` IN (24788,24789,24790);
-- Optional override (uncomment):
-- UPDATE `quest_template` SET `rewarditem1` = 49426, `RewardAmount1` = 1 WHERE `ID` IN (24788,24789,24790);
