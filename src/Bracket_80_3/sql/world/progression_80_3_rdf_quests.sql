-- ProgressionSystem - dungeon dailies & RDF rewards (Bracket_80_3)
-- SERVER SOURCE OF TRUTH (ToC / 3.2 era):
-- - Heroic 5-man bosses: Conquest (45624) [handled in progression_80_3_emblems.sql]
-- - Daily normal dungeon quest: Conquest (45624) x1
-- - Daily heroic dungeon quest: Triumph (47241) x2

-- RDF / Random dungeon (common AzerothCore WotLK):
-- 24788: Daily heroic random (1st)
-- 24789: Daily heroic random (Nth)
-- 24790: Daily normal random (Nth)
UPDATE `quest_template` SET `rewarditem1` = 47241, `RewardAmount1` = 2 WHERE `ID` IN (24788,24789);
UPDATE `quest_template` SET `rewarditem1` = 45624, `RewardAmount1` = 1 WHERE `ID` IN (24790);

-- Dalaran normal dungeon daily quests ("Timear Foresees...") => Conquest x1
UPDATE `quest_template` SET `rewarditem1` = 45624, `RewardAmount1` = 1 WHERE `ID` IN (13240,13241,13243,13244);

-- Dalaran heroic dungeon daily quests ("Proof of Demise...") => Triumph x2
UPDATE `quest_template` SET `rewarditem1` = 47241, `RewardAmount1` = 2
WHERE `ID` IN (13245,13246,13247,13248,13249,13250,13251,13252,13253,13254,13255,13256,14199);
