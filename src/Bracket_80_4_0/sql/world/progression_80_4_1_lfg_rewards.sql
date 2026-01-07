-- Propósito: reasignar las quest de recompensas LFG para el bracket 80_4_1 (heroic RDF).
-- Alcance: solo cambia los IDs de quest en `lfg_dungeon_rewards` para heroicas 261/262, la recompensa se define en progression_80_4_1_rdf_quests.sql.
UPDATE `lfg_dungeon_rewards` SET `firstQuestId` = 24788, `otherQuestId`=24789 WHERE `dungeonId` IN (261, 262) AND `maxLevel`=80;
