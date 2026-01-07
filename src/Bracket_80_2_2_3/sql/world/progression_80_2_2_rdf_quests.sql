-- ProgressionSystem - dungeon dailies & RDF rewards (Bracket_80_2_2)
-- SERVER SOURCE OF TRUTH (Ulduar / T8 era):
-- - Heroic 5-man bosses: Valor (40753) [handled in progression_80_2_2_emblems.sql]
-- - Daily normal ("Timear Foresees..."): Valor (40753) x2
-- - Daily heroic ("Proof of Demise..."): Conquest (45624) x2
--
-- RDF / Random heroic isn't part of the original 3.1 timeline, but if you run it on the server,
-- keep it coherent with this bracket.

-- RDF / Random dungeon (common AzerothCore WotLK):
-- 24788: Daily heroic random (1st)
-- 24789: Daily heroic random (Nth)
-- 24790: Daily normal random (Nth)
UPDATE `quest_template` SET `rewarditem1` = 40753, `RewardAmount1` = 1 WHERE `ID` IN (24788,24789,24790);

-- Dalaran normal dungeon daily quests (Archmage Timear): "Timear Foresees..."
UPDATE `quest_template` SET `rewarditem1` = 40753, `RewardAmount1` = 2 WHERE `ID` IN (13240,13241,13243,13244);

-- Dalaran heroic dungeon daily quests ("Proof of Demise...")
UPDATE `quest_template` SET `rewarditem1` = 45624, `RewardAmount1` = 2
WHERE `ID` IN (13245,13246,13247,13248,13249,13250,13251,13252,13253,13254,13255,13256);
