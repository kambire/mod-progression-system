# WotLK weekly raid quests audit guide

This guide validates WotLK weekly raid quest rewards (`world.quest_template`) for Archmage Lan'dalock quests (24579..24590).

## Requirements

- Database: MySQL 8.x (compatible with MySQL 8.6; the audit uses CTE).
- Run against the `world` database.

## How to run

1) Open `audit/WOTLK_WEEKLY_RAID_QUESTS_AUDIT.sql`
2) Set the bracket you want to validate:

```sql
SET @BRACKET := '80_2_1';
```

Valid values:
- `80_1_1`, `80_1_2`
- `80_2_1`, `80_2_2`
- `80_3`
- `80_4_1`, `80_4_2`

3) Execute the SQL file.

## How to read results

- **No rows returned**: rewards match the expected emblem for that bracket.
- **Rows returned**: each row is a mismatch (missing quest row, wrong emblem, or extra emblem rewards).

