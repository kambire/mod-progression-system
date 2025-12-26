-- ICC_ICC5_DUNGEONS_QUESTS_AUDIT.sql
-- Purpose:
--   Audit the ICC 5-man dungeons (FoS/PoS/HoR) and their dungeon-internal quests:
--     - List quest starters/enders that spawn inside maps 632/658/668
--     - Show which quests are currently disabled via `disables` (sourceType=1)
--
-- Notes:
--   - FoS  = map 632 (The Forge of Souls)
--   - PoS  = map 658 (Pit of Saron)
--   - HoR  = map 668 (Halls of Reflection)
--   - This relies on `creature.id1` (AzerothCore modern world DB schema).

SET @MAP_FOS = 632;
SET @MAP_POS = 658;
SET @MAP_HOR = 668;

-- 1) NPCs that exist inside these instances
SELECT
  c.map,
  c.id1 AS npc_entry,
  ct.name,
  ct.subname,
  COUNT(*) AS spawns
FROM creature c
JOIN creature_template ct ON ct.entry = c.id1
WHERE c.map IN (@MAP_FOS, @MAP_POS, @MAP_HOR)
GROUP BY c.map, c.id1, ct.name, ct.subname
ORDER BY c.map, spawns DESC, c.id1;

-- 2) Quests started inside the instances
SELECT
  c.map,
  qs.id AS npc_entry,
  ct.name AS npc_name,
  qs.quest AS quest_id,
  qt.LogTitle AS quest_title,
  CASE WHEN d.entry IS NULL THEN 0 ELSE 1 END AS is_disabled
FROM creature_queststarter qs
JOIN creature c ON c.id1 = qs.id
JOIN creature_template ct ON ct.entry = qs.id
LEFT JOIN quest_template qt ON qt.ID = qs.quest
LEFT JOIN disables d ON d.sourceType = 1 AND d.entry = qs.quest
WHERE c.map IN (@MAP_FOS, @MAP_POS, @MAP_HOR)
ORDER BY c.map, qs.id, qs.quest;

-- 3) Quests ended inside the instances
SELECT
  c.map,
  qe.id AS npc_entry,
  ct.name AS npc_name,
  qe.quest AS quest_id,
  qt.LogTitle AS quest_title,
  CASE WHEN d.entry IS NULL THEN 0 ELSE 1 END AS is_disabled
FROM creature_questender qe
JOIN creature c ON c.id1 = qe.id
JOIN creature_template ct ON ct.entry = qe.id
LEFT JOIN quest_template qt ON qt.ID = qe.quest
LEFT JOIN disables d ON d.sourceType = 1 AND d.entry = qe.quest
WHERE c.map IN (@MAP_FOS, @MAP_POS, @MAP_HOR)
ORDER BY c.map, qe.id, qe.quest;

-- 4) Summary: distinct quest ids inside the instances (starter or ender)
SELECT
  q.quest_id,
  qt.LogTitle AS quest_title,
  CASE WHEN d.entry IS NULL THEN 0 ELSE 1 END AS is_disabled,
  d.comment AS disable_comment
FROM (
  SELECT DISTINCT qs.quest AS quest_id
  FROM creature_queststarter qs
  JOIN creature c ON c.id1 = qs.id
  WHERE c.map IN (@MAP_FOS, @MAP_POS, @MAP_HOR)
  UNION
  SELECT DISTINCT qe.quest AS quest_id
  FROM creature_questender qe
  JOIN creature c ON c.id1 = qe.id
  WHERE c.map IN (@MAP_FOS, @MAP_POS, @MAP_HOR)
) q
LEFT JOIN quest_template qt ON qt.ID = q.quest_id
LEFT JOIN disables d ON d.sourceType = 1 AND d.entry = q.quest_id
ORDER BY is_disabled DESC, q.quest_id;
