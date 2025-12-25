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

Important note about instance locks (WotLK):
- This module historically relied on early "baseline" brackets (notably `Bracket_0`) to INSERT rows into `disables` for future content.
- For WotLK progression specifically, the first WotLK bracket is `Bracket_71_74` and it is the right place to enforce the baseline lock for ICC/ToC/RS/Onyxia80.
- If your server jumps straight to a later WotLK bracket (e.g. enabling only `Bracket_80_2`), you must ensure the bracket SQL enforces the lock FIRST (INSERT into `disables`) before it unlocks the intended content (DELETE from `disables`).
- Otherwise, ICC/ToC/Ruby Sanctum may be accessible simply because your world DB never had those `disables` rows inserted.

Terminology note: "blocked" means the instance is disabled (access denied) via `world.disables`.
This does NOT delete maps, creatures, loot, or scripts from your database; the portals still exist.
Players attempting to enter a blocked instance should receive an in-game message indicating the instance/content is disabled or they don't have access.

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
- Copy `conf/mod-progression-blizzlike.conf.dist` into your module config directory:
  - Typical example: `azerothcore-wotlk/etc/modules/mod-progression-blizzlike.conf`
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
