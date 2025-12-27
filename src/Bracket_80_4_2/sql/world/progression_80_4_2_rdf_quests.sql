-- ProgressionSystem - RDF rewards (Bracket_80_4_2)
-- SERVER SOURCE OF TRUTH (Ruby Sanctum era):
-- - Random Heroic (first of day): 2x Frost (49426)
-- - Random Heroic (after first):  2x Triumph (47241)
-- - Random Normal: Triumph (47241) x1

UPDATE `quest_template` SET `rewarditem1` = 49426, `RewardAmount1` = 2 WHERE `ID` = 24788;
UPDATE `quest_template` SET `rewarditem1` = 47241, `RewardAmount1` = 2 WHERE `ID` = 24789;
UPDATE `quest_template` SET `rewarditem1` = 47241, `RewardAmount1` = 1 WHERE `ID` = 24790;
