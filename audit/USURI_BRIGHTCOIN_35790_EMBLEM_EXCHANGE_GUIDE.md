# Usuri Brightcoin (35790) emblem exchange audit guide

This guide validates the **emblem exchange helper** vendor inventory for Usuri Brightcoin (`entry=35790`).

## Intent

- The vendor is used as a **failsafe**: if a heroic boss drops a higher emblem than intended for the current bracket, players can down-convert to the bracket's current heroic emblem.
- It must **never** allow lower emblems to convert into higher emblems.

## How to run

1) Open `audit/USURI_BRIGHTCOIN_35790_EMBLEM_EXCHANGE_AUDIT.sql`
2) Set the bracket:

```sql
SET @BRACKET := '80_2_1';
```

Valid values:
- `80_1_2`, `80_2_1`, `80_2_2`, `80_3`, `80_4_1`, `80_4_2`

3) Execute the SQL file against your `world` database.

## How to read results

- First result set:
  - **No rows** => vendor matches the expected target emblem and allowed ExtendedCost IDs.
  - **Rows present** => something is wrong (missing vendor rows, wrong target item, or wrong ExtendedCost).
- Second result set always prints the current `npc_vendor` rows for `entry=35790`.

