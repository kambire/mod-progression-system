-- Reset WotLK LFG reward quest IDs (Bracket 80_4_2)
-- Note:
-- - This only assigns which quests are used by random heroic.
-- - The emblem item/amount is controlled by `quest_template` and is set per bracket
--   in `progression_80_4_2_rdf_quests.sql`.
UPDATE `lfg_dungeon_rewards` SET `firstQuestId` = 24788, `otherQuestId`=24789 WHERE `dungeonId` IN (261, 262) AND `maxLevel`=80;
