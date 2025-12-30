-- CustomLocks audit (mod-progression-blizzlike)
-- Run on `world` (MySQL 8.x compatible).
--
-- This audits what the CustomLocks system is currently tracking (base state backups)
-- and what is currently present in the live tables.
--
-- Note: if the backup tables don't exist yet, CustomLocks was never enabled/applied.

-- 1) Disables overlay tracking (maps/battlegrounds/etc)
SELECT
	'before_vs_current' AS `section`,
	b.sourceType,
	b.entry,
	b.had_row AS base_had_row,
	b.flags AS base_flags,
	d.flags AS current_flags
FROM mod_progression_custom_lock_disables_backup b
LEFT JOIN disables d
	ON d.sourceType = b.sourceType AND d.entry = b.entry
ORDER BY b.sourceType, b.entry;

-- 2) NPC overlay tracking (creature_template)
SELECT
	'before_vs_current' AS `section`,
	b.entry,
	b.npcflag AS base_npcflag,
	ct.npcflag AS current_npcflag,
	b.gossip_menu_id AS base_gossip_menu_id,
	ct.gossip_menu_id AS current_gossip_menu_id
FROM mod_progression_custom_lock_creature_template_backup b
LEFT JOIN creature_template ct
	ON ct.entry = b.entry
ORDER BY b.entry;

