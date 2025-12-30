# WotLK `disables` audit guide

This guide validates WotLK progression locks/unlocks using `world.disables` (AzerothCore).

## Requirements

- Database: MySQL 8.x (compatible with MySQL 8.6; the audit uses CTE).
- Run against the `world` database.

## How to run

1) Open `audit/WOTLK_DISABLES_AUDIT.sql`
2) Set the bracket you want to validate:

```sql
SET @BRACKET := '80_3';
```

Valid values:
- `71_74`, `75_79`
- `80_1_1`, `80_1_2`
- `80_2_1`, `80_2_2`
- `80_3`
- `80_4_1`, `80_4_2`

3) Execute the SQL file.

## How to read results

- **No rows returned**: matches the expected progression state for that bracket.
- **Rows returned**: each row is a mismatch:
  - `sourceType`: `2` = map lock, `8` = RDF/LFG hard-lock used by this module
  - `entry`: map ID
  - `expectation`: `locked`, `normal_only`, `unlocked`
  - `actual_flags`: current `disables.flags` (or NULL if missing)

## Notes

- This audit assumes the module’s WotLK bracket scripts were applied (via DBUpdater).
- If you run the module with `ProgressionSystem.LoadDatabase = 0`, SQL updates will not run; existing DB changes are not rolled back.

