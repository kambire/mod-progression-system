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

- `ARENA_SEASONS_VALIDATION.md`
- `PARAMETROS_TECNICOS_DESARROLLO.md`
- `BRACKET_DESCRIPTIONS_COMPLETE.md`
- `IMPLEMENTACION_VENDORS_SQL.md`
  - Supporting documentation and validation guides.

## Naming conventions (recommended)

- Autoload SQL: `progression_<bracket>_<feature>.sql`
- Manual/hotfix SQL: `MANUAL_HOTFIX_<topic>.sql`
- Audit SQL: `<topic>_AUDIT.sql`
