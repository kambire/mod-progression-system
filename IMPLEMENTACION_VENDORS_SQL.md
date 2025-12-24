# 🚀 Complete and Apply SQL Scripts

**Status**: Templates are ready (blizzlike); you must fill them with your real IDs

---

## 📍 Script Locations

All template scripts are already in the correct folders:

```
src/Bracket_70_2_1/sql/templates/arena_s1_vendors_cleanup.sql.template
src/Bracket_70_2_2/sql/templates/arena_s2_vendors_cleanup.sql.template
src/Bracket_70_5/sql/templates/arena_s3_vendors_cleanup.sql.template
src/Bracket_70_6_2/sql/templates/arena_s4_vendors_cleanup.sql.template
src/Bracket_80_1_2/sql/templates/transition_tbc_to_wotlk_vendors.sql.template
src/Bracket_80_1_2/sql/templates/arena_s5_vendors_cleanup.sql.template
src/Bracket_80_2/sql/templates/arena_s6_vendors_cleanup.sql.template
src/Bracket_80_3/sql/templates/arena_s7_vendors_cleanup.sql.template
src/Bracket_80_4_1/sql/templates/arena_s8_vendors_cleanup.sql.template
```

> Production note: files like `src/**/sql/world/vendors_*.sql` are stubs (comments only) so DBUpdater will not execute placeholders.
> To apply changes, complete the `.sql.template`, save a copy as `.sql`, and run it manually (or as an AzerothCore update).

---

## 🔍 STEP 1: Find IDs in your Database

Run these MySQL queries to get the required IDs.

> Blizzlike note (AzerothCore): PvP/Arena costs are controlled by `npc_vendor.ExtendedCost` (table `item_extended_cost`).
> The new templates use `npc_vendor.item` + `ExtendedCost` (NOT gold).

### Query 1: Find Arena/PvP vendors (entries)
```sql
-- Search vendors by name (adjust LIKE for your locale/DB)
SELECT entry, name
FROM creature_template
WHERE name LIKE '%Gladiator%'
  OR name LIKE '%Arena%'
  OR name LIKE '%PvP%'
LIMIT 50;
```

### Query 2: Validate known entries (typical WotLK)
```sql
SELECT entry, name
FROM creature_template
WHERE entry IN (33609, 33610);
```

### Query 3: See what a vendor sells (to confirm)
```sql
SELECT v.entry, v.item, it.name, v.ExtendedCost
FROM npc_vendor v
JOIN item_template it ON it.entry = v.item
WHERE v.entry IN (33609, 33610)
ORDER BY v.entry, v.item
LIMIT 200;
```

### Query 4: Items per Season (examples; adjust names for your DB)

```sql
-- TBC Season 1 (Gladiator)
SELECT entry, name FROM item_template WHERE name LIKE '%Gladiator%' ORDER BY entry;

-- TBC Season 2 (Merciless)
SELECT entry, name FROM item_template WHERE name LIKE '%Merciless%' ORDER BY entry;

-- TBC Season 3 (Vengeful)
SELECT entry, name FROM item_template WHERE name LIKE '%Vengeful%' ORDER BY entry;

-- TBC Season 4 (Brutal)
SELECT entry, name FROM item_template WHERE name LIKE '%Brutal%' ORDER BY entry;

-- WotLK Season 5 (Deadly)
SELECT entry, name FROM item_template WHERE name LIKE '%Deadly%' ORDER BY entry;

-- WotLK Season 6 (Furious)
SELECT entry, name FROM item_template WHERE name LIKE '%Furious%' ORDER BY entry;

-- WotLK Season 7 (Relentless)
SELECT entry, name FROM item_template WHERE name LIKE '%Relentless%' ORDER BY entry;

-- WotLK Season 8 (Wrathful)
SELECT entry, name FROM item_template WHERE name LIKE '%Wrathful%' ORDER BY entry;

-- If your DB uses other names or a different language, adjust the LIKE filters.
-- The important part is building lists S1_ITEM_IDS ... S8_ITEM_IDS with the correct IDs.

### Query 5: Find ExtendedCost IDs (costs) for PvP/Arena
```sql
-- Search ExtendedCost IDs used by your current vendors
SELECT DISTINCT v.ExtendedCost
FROM npc_vendor v
WHERE v.entry IN (33609, 33610)
ORDER BY v.ExtendedCost;

-- Inspect extended cost details
SELECT *
FROM item_extended_cost
WHERE id IN (
  SELECT DISTINCT v.ExtendedCost
  FROM npc_vendor v
  WHERE v.entry IN (33609, 33610)
)
ORDER BY id;
```
```

---

## ✏️ STEP 2: Complete the Templates

### Completed Script Format

```sql
-- Example: arena_s1_vendors_cleanup.sql (generated from the .template)

DELETE FROM `npc_vendor`
WHERE `entry` IN (33609, 33610)  -- REPLACE WITH YOUR ENTRIES
  AND `item` NOT IN (
    23001,23002,23003,23004,23005,23006,23007,23008,23009,23010,  -- 10
    23011,23012,23013,23014,23015,23016,23017,23018,23019,23020,  -- 20
    23021,23022,23023,23024,23025,23026,23027,23028,23029,23030,  -- 30
    23031,23032,23033,23034,23035,23036,23037,23038,23039,23040,  -- 40
    23041,23042,23043,23044,23045,23046,23047,23048,23049,23050,  -- 50
    23051,23052,23053,23054,23055,23056,23057,23058,23059,23060   -- 60
  );

INSERT INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`)
VALUES
  (33609, 0, 23001, 0, 0, 1234, 0),
  (33609, 0, 23002, 0, 0, 1234, 0),
  (33610, 0, 23003, 0, 0, 1234, 0),
  -- ... 60 items total ...
  (33610, 0, 23060, 0, 0, 1234, 0)
;
```

---

## 📋 Replacement Checklist

### Vendors (entries) per Season

- [ ] **Replace `[S1_VENDOR_ENTRIES]`, `[S2_VENDOR_ENTRIES]`, ...**
  - In: all `arena_s*_vendors_cleanup.sql.template` templates
  - With: real entries (Horde/Alliance) from your DB
  - Typical WotLK example: `33609, 33610`

- [ ] **Replace `[S1_ITEM_IDS]`**
  - In: arena_s1_vendors_cleanup, arena_s2_vendors_cleanup, arena_s3_vendors_cleanup, arena_s4_vendors_cleanup
  - With: Gladiator/Season 1 item IDs
  - Count: ~60 items

- [ ] **Replace `[S2_ITEM_IDS]`**
  - In: arena_s2_vendors_cleanup, arena_s3_vendors_cleanup, arena_s4_vendors_cleanup
  - With: Merciless/Season 2 item IDs
  - Count: ~60 items

- [ ] **Replace `[S3_ITEM_IDS]`**
  - In: arena_s3_vendors_cleanup, arena_s4_vendors_cleanup
  - With: Vengeful/Season 3 item IDs
  - Count: ~60 items

- [ ] **Replace `[S4_ITEM_IDS]`**
  - In: arena_s4_vendors_cleanup
  - With: Brutal/Season 4 item IDs
  - Count: ~60 items

### ExtendedCost (blizzlike)

- [ ] **Replace placeholders `*_WITH_EXTENDEDCOST_*`**
  - In: all `arena_s*_vendors_cleanup.sql.template` templates
  - With: real INSERT lines that include the correct `ExtendedCost`
  - Source: Query 5 (`item_extended_cost`) or values already used by your core

- [ ] **Replace `[S5_ITEM_IDS]`**
  - In: arena_s5_vendors_cleanup, arena_s6_vendors_cleanup, arena_s7_vendors_cleanup, arena_s8_vendors_cleanup
  - With: Deadly/Season 5 item IDs
  - Count: ~60 items

- [ ] **Replace `[S6_ITEM_IDS]`**
  - In: arena_s6_vendors_cleanup, arena_s7_vendors_cleanup, arena_s8_vendors_cleanup
  - With: Furious/Season 6 item IDs
  - Count: ~60 items

- [ ] **Replace `[S7_ITEM_IDS]`**
  - In: arena_s7_vendors_cleanup, arena_s8_vendors_cleanup
  - With: Relentless/Season 7 item IDs
  - Count: ~60 items

- [ ] **Replace `[S8_ITEM_IDS]`**
  - In: arena_s8_vendors_cleanup
  - With: Wrathful/Season 8 item IDs
  - Count: ~60 items

---

## 🔗 TBC → WotLK Transition

- [ ] **Replace `[TBC_VENDOR_ENTRIES]` and `[WOTLK_VENDOR_ENTRIES]`**
  - In: `transition_tbc_to_wotlk_vendors.sql.template`
  - In: `transition_tbc_to_wotlk_vendors.sql.template`
  - With: real entries you want to disable/enable

---

## ⚡ STEP 3: Execute on the Server

### Option 1: Copy to server (automatic)
```bash
# Production: `vendors_*` under `sql/world` are stubs and do NOT auto-run.
# This is intentional to prevent placeholders from breaking DBUpdater autoload.
```

### Option 2: Execute manually
```sql
-- Connect to MySQL and run:
mysql world < src/Bracket_70_2_1/sql/templates/arena_s1_vendors_cleanup.sql
mysql world < src/Bracket_70_2_2/sql/templates/arena_s2_vendors_cleanup.sql
-- ... etc ...
```

### Option 3: Copy scripts into updates
```bash
cp src/Bracket_*/sql/templates/*.sql.template ~/path/to/updates/
# Rename to .sql, fill placeholders, and AzerothCore's updater will execute them automatically
```

---

## ✅ STEP 4: Validate In-Game

```
[ ] Enter the corresponding bracket and verify:
  - Correct vendors (Horde/Alliance)
  - Only items from the allowed season
  - Correct costs (Arena Points/Honor/Rating depending on your core)

[ ] Enter Bracket_70_2_2 and verify:
  - Vendor visible in Gadgetzan
  - S1 (100k) and S2 (200k) items
  - Total ~120 items

[ ] Enter Bracket_80_1_2 and verify:
  - Gadgetzan vendor disappears
  - New vendor in Dalaran
  - Only S5 items

[ ] Enter Bracket_80_4_1 and verify:
    - All items available
  - Correct costs (ExtendedCost)
```

---

## 📝 Quick Summary

| Step | Action | Time |
|------|--------|--------|
| 1 | Run 6 queries on your DB | 5 min |
| 2 | Complete 9 SQL templates | 30 min |
| 3 | Copy scripts to the server | 5 min |
| 4 | Restart worldserver (if needed) | 2 min |
| 5 | Validate in-game | 15 min |
| **Total** | | **57 minutes** |

---

## 🎯 Important Files

- **README.md** - Full documentation
- **PARAMETROS_TECNICOS_DESARROLLO.md** - Technical configuration
- **BRACKET_DESCRIPTIONS_COMPLETE.md** - Bracket descriptions
- **ARENA_SEASONS_VALIDATION.md** - Season mapping

---

**Need help?** See the README section "PHASE 0 - Full Vendor Control"
