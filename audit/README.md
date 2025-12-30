# audit/

This folder contains **manual** SQL and **read-only audit/validation** helpers.

It is intentionally **NOT** part of the bracket autoload pipeline (DBUpdater).

## What goes where

- **Autoload (DBUpdater)**: `src/Bracket_*/sql/{world,characters,auth}`
  - Must be idempotent or safe to reapply.
  - Must not contain placeholders.

- **Manual / Audit (this folder)**: `audit/`
  - May contain one-off hotfixes or manual maintenance steps.
  - May contain verification queries to run after enabling a bracket.
  - If a script modifies data, it should be treated as a controlled/manual operation.

## Files

- `SQL_VERIFICATION.sql`
  - Post-deploy verification queries (run against `world`).

- `ARENA_VENDORS_SETUP.sql`
  - Manual vendor setup script (run against `world`).

- `MANUAL_HOTFIX_NAXX_SAPPHIRON_GATING.sql`
- `MANUAL_HOTFIX_WINTERGRASP_VENDOR_PROGRESSIVE.sql`
- `MANUAL_HOTFIX_WOTLK_EMBLEMS.sql`
  - One-off manual hotfix scripts.

- `ICC_ICC5_DUNGEONS_QUESTS_AUDIT.sql`
- `PVP_TRINKETS_AUDIT.sql`
- `WINTERGRASP_CHAMPION_ROS_VENDOR_AUDIT.sql`
- `WINTERGRASP_VENDORS_AUDIT.sql`
- `WINTER_VEIL_VENDORS_AUDIT.sql`
  - Audit/inspection queries (typically read-only).

- `NPCFLAG_VENDOR_AUDIT.sql`
  - Audits npcflag vendor bit (128) for NPCs controlled by this module.

- `NPCFLAG_VENDOR_FIX.sql`
  - Manual fixes for npcflag vendor bit by bracket, plus a default restore section.

- `NPCFLAG_VENDOR_GUIDE.md`
  - Step-by-step guide for auditing and fixing vendor flags.

- `CUSTOM_LOCKS_AUDIT.sql`
  - Shows what CustomLocks is currently tracking/applied (base vs current).

- `WOTLK_DISABLES_AUDIT.sql`
  - Validates WotLK instance progression locks/unlocks via `world.disables` (by bracket).

- `WOTLK_DISABLES_GUIDE.md`
  - Step-by-step guide for running the WotLK disables audit.

- `WOTLK_WEEKLY_RAID_QUESTS_AUDIT.sql`
  - Validates WotLK weekly raid quest emblem rewards (24579..24590) via `world.quest_template` (by bracket).

- `WOTLK_WEEKLY_RAID_QUESTS_GUIDE.md`
  - Step-by-step guide for running the WotLK weekly raid quest audit.

- `USURI_BRIGHTCOIN_35790_EMBLEM_EXCHANGE_AUDIT.sql`
  - Validates the emblem exchange helper vendor (npc_vendor entry=35790) by bracket.

- `USURI_BRIGHTCOIN_35790_EMBLEM_EXCHANGE_GUIDE.md`
  - Step-by-step guide for running the emblem exchange vendor audit.

- `USURI_BRIGHTCOIN_35790_EMBLEM_EXCHANGE_RESTORE.sql`
  - Restores npc_vendor entry=35790 from `mod_progression_backup_npc_vendor_35790`.

- `ARENA_SEASONS_VALIDATION.md`
- `PARAMETROS_TECNICOS_DESARROLLO.md`
- `BRACKET_DESCRIPTIONS_COMPLETE.md`
- `IMPLEMENTACION_VENDORS_SQL.md`
  - Supporting documentation and validation guides.

## Naming conventions (recommended)

- Autoload SQL: `progression_<bracket>_<feature>.sql`
- Manual/hotfix SQL: `MANUAL_HOTFIX_<topic>.sql`
- Audit SQL: `<topic>_AUDIT.sql`
