# Production Deployment (Windows / AzerothCore)

This module is designed for production use under these rules:

- SQL that **auto-loads** (via DBUpdater) lives under `src/Bracket_*/sql/{world,characters,auth}` and **must not contain placeholders**.
- SQL that requires real IDs from your DB (vendors/arena) lives under `src/Bracket_*/sql/templates/*.sql.template` and must be applied **manually** (or as already “materialized” real updates).

## 0) Pre-flight (before touching prod)

1) DB backup (at minimum `world`):
- Full backup is recommended.
- If you will touch arena vendors: back up `npc_vendor`, `creature_template`, `item_extended_cost`.

2) Config backup:
- Save your `etc/modules/*.conf`.

3) Choose the target bracket:
- Decide which `ProgressionSystem.Bracket_*` you will enable in production.

## 1) Validate and build a release (on your PC)

Run packaging/validation from the repo root:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\production_package.ps1
```

This will:
- Fail if it detects dangerous placeholders in autoload SQL.
- Create a zip under `dist/` ready to copy to the server.

## 2) Install on the server (AzerothCore)

1) Copy the module into the core (exact path required by the code):
- It must end up as: `azerothcore-wotlk/modules/mod-progression-blizzlike/`

2) Config:
- Copy `conf/progression_system.conf.dist` into your module config directory:
  - Typical example: `azerothcore-wotlk/etc/modules/progression_system.conf`
- Edit it and enable **only** the desired brackets:
  - `ProgressionSystem.LoadDatabase = 1`
  - `ProgressionSystem.LoadScripts = 1`
  - `ProgressionSystem.ReapplyUpdates = 0` (recommended in prod)
  - `ProgressionSystem.Bracket_<...> = 1`

3) Build:
- Rebuild the core with the module.

4) First startup:
- On startup, DBUpdater will apply SQL for the enabled brackets.

## 3) Apply arena vendors (manual, blizzlike)

Arena templates are NOT auto-executed by design (to avoid `ExtendedCost=0` or placeholders breaking production).

Recommended steps:

1) Complete the season template (with your real entries and real ExtendedCost IDs):
- Example: `src/Bracket_80_1_2/sql/templates/arena_s5_vendors_cleanup.sql.template`

2) Save a “materialized” copy as `.sql` (outside of autoload; e.g., in your own deploy folder).

3) Execute it against `world`.

4) Verify there is **no gold pricing**:
- If there are rows with `ExtendedCost=0`, that vendor is selling for gold.

## 4) Post-deploy verification

- Run `SQL_VERIFICATION.sql` against your `world` database.
- In particular:
  - `Arena Vendors - GOLD PRICED (ExtendedCost=0)` should return **0**.

## Rollback

- Restore the `world` backup.
- Disable brackets (set them to 0) and restart.
