# 🎮 Progression System Module - AzerothCore

**Total control of WoW server progression - 38 brackets, 3 expansions, 8 arena seasons**

[![License](https://img.shields.io/badge/license-AGPL%20v3-blue.svg)](LICENSE)
[![AzerothCore](https://img.shields.io/badge/AzerothCore-3.3.5a-brightgreen.svg)](https://www.azerothcore.org/)
[![C++](https://img.shields.io/badge/C%2B%2B-17-green.svg)]()
[![SQL](https://img.shields.io/badge/Database-MySQL-orange.svg)]()

---

## 📋 Overview

Modular progression system for AzerothCore built around **brackets** (Vanilla/TBC/WotLK + Arena seasons). Each enabled bracket can load its own C++ scripts and SQL updates.

**What this module does (verified in code)**:
- ✅ 38 brackets (Vanilla, TBC, WotLK)
- ✅ Optional bracket script loading (`ProgressionSystem.LoadScripts`)
- ✅ Optional bracket SQL update loading via AzerothCore `DBUpdater` (`ProgressionSystem.LoadDatabase`)
- ✅ Bracket enable/disable flags via config (`ProgressionSystem.Bracket_*`)
- ✅ Optional re-apply of bracket SQL updates on startup (`ProgressionSystem.ReapplyUpdates`)

Note: Some config keys in `conf/mod-progression-blizzlike.conf.dist` are placeholders (documented but not implemented in this module). If you set them away from defaults, the module will log warnings and ignore them.

---

## 🎯 Key Features

### 1. Full Vendor Control per Bracket
Bracket-based SQL setup intended to keep Arena/PvP vendors aligned with the active season:
- Vendors are controlled by **NPC entry** (Horde/Alliance) and limited by season
- Blizzlike cost is applied using **`npc_vendor.ExtendedCost`** (Arena Points/Honor/Rating depending on your core)
- Vendor exact location can vary by DB (in WotLK it is usually Orgrimmar/Stormwind)
- Enable/disable is done by removing/adding the vendor flag (`npcflag` bit 128)

Note: In this repository, most vendor/arena control is applied via SQL loaded per bracket.
The “advanced features” options in the config file are documented, but if they are not read by the module’s C++, they have no effect.

### 2. Bracket-Based SQL / Data Changes
Most progression behavior in this repository is implemented via bracket SQL updates under `src/Bracket_*/sql/{world,characters,auth}` and applied through `DBUpdater` at server startup for enabled brackets.

### 3. Flexible Configuration
```ini
# Enable/disable brackets by name
ProgressionSystem.Bracket_70_2_1 = 1           # Arena S1 active
ProgressionSystem.Bracket_80_4_1 = 0           # Arena S8 disabled

# Note: the module loads SQL per bracket. Vendor/arena logic is defined in SQL.
```

---

## 📦 Project Structure

```
mod-progression-blizzlike/
├── CMakeLists.txt                         # AzerothCore module build integration
├── conf/
│   └── mod-progression-blizzlike.conf.dist # Config template
│   └── conf.sh.dist                       # Bash template
├── src/
│   ├── ProgressionSystem.h                # C++ structure
│   ├── ProgressionSystem.cpp              # Implementation
│   ├── cs_progression_module.cpp          # Load module
│   ├── ProgressionSystem_loader.cpp       # Dynamic loader
│   └── Bracket_*/
│       ├── Bracket_*_loader.cpp           # Bracket scripts
│       └── sql/
│           ├── world/                     # World changes
│           ├── characters/                # Character changes
│           └── auth/                      # Auth changes
├── scripts/
│   └── local_release.ps1                  # Deploy script
└── README.md                              # This file
```

---

## 🚀 Quick Install

### 1. Clone the module
```bash
cd ~/azerothcore-wotlk/modules
git clone https://github.com/kambire/mod-progression-blizzlike.git
```

### 2. Configure brackets
```bash
cd mod-progression-blizzlike/conf
cp mod-progression-blizzlike.conf.dist mod-progression-blizzlike.conf
# Edit mod-progression-blizzlike.conf and enable desired brackets
```

### 3. Build AzerothCore
```bash
cd ~/azerothcore-wotlk
# Rebuild AzerothCore using your usual workflow.
# Example:
./acore.sh compiler build
```

### 4. Run DB update
When `ProgressionSystem.LoadDatabase = 1`, this module uses AzerothCore `DBUpdater` to apply SQL from enabled brackets at startup:

- `modules/mod-progression-blizzlike/src/Bracket_*/sql/world`
- `modules/mod-progression-blizzlike/src/Bracket_*/sql/characters`
- `modules/mod-progression-blizzlike/src/Bracket_*/sql/auth`

### 5. Start the server and verify
```bash
# In the server console
.server info
# Should show loaded modules
```

---

## 🧰 Production (recommended)

- Step-by-step guide: see [PRODUCTION.md](PRODUCTION.md)
- Packaging/validation on Windows: `powershell -ExecutionPolicy Bypass -File .\scripts\production_package.ps1`

---

## 📊 Available Brackets (38 Total)

### Vanilla (14 brackets - Nov 2004 to Jan 2005)
| Bracket | Level | Content | Release Date |
|---------|-------|-----------|---------------|
| **Bracket_0** | 1-10 | Starter zones | Nov 23, 2004 |
| **Bracket_1_19** | 11-19 | Early dungeons | Nov 23, 2004 |
| **Bracket_20_29** | 20-29 | Mid-level dungeons | Nov 23, 2004 |
| **Bracket_30_39** | 30-39 | Advanced dungeons | Nov 23, 2004 |
| **Bracket_40_49** | 40-49 | World dungeons | Nov 23, 2004 |
| **Bracket_50_59_1** | 50-59 | UBRS Attunement | Nov 23, 2004 |
| **Bracket_50_59_2** | 50-59 | Upper Blackrock | Nov 23, 2004 |
| **Bracket_60_1_1** | 60 | Molten Core | Nov 23, 2004 |
| **Bracket_60_1_2** | 60 | Onyxia | Nov 23, 2004 |
| **Bracket_60_2_1** | 60 | Blackwing Lair | Jan 19, 2005 |
| **Bracket_60_2_2** | 60 | Zul'Gurub | Jan 19, 2005 |
| **Bracket_60_3_1** | 60 | Ruins AQ | Jan 19, 2005 |
| **Bracket_60_3_2** | 60 | Temple AQ | Jan 19, 2005 |
| **Bracket_60_3_3** | 60 | AQ Final Phase | Jan 19, 2005 |

### The Burning Crusade (15 brackets - Jan 2007 to May 2008) + Arena S1-S4
| Bracket | Level | Arena | Content | Date |
|---------|-------|-------|-----------|-------|
| **Bracket_61_64** | 61-64 | - | Outland Intro | Jan 16, 2007 |
| **Bracket_65_69** | 65-69 | - | Mid-Level | Jan 16, 2007 |
| **Bracket_70_1_1** | 70 | - | Dungeons | Jan 16, 2007 |
| **Bracket_70_1_2** | 70 | - | Heroic Dungeons | Jan 16, 2007 |
| **Bracket_70_2_1** | 70 | **S1** | Gruul's/Magtheridon | Jan 16, 2007 |
| **Bracket_70_2_2** | 70 | **S2** | Karazhan | May 15, 2007 |
| **Bracket_70_3_1** | 70 | - | SSC Intro | May 15, 2007 |
| **Bracket_70_3_2** | 70 | **S2** | The Eye | May 15, 2007 |
| **Bracket_70_4_1** | 70 | - | Mount Hyjal | Aug 24, 2007 |
| **Bracket_70_4_2** | 70 | - | Black Temple | Sep 24, 2007 |
| **Bracket_70_5** | 70 | **S3** | Zul'Aman | Dec 11, 2007 |
| **Bracket_70_6_1** | 70 | - | Isle of Quel'Danas | May 22, 2008 |
| **Bracket_70_6_2** | 70 | **S4** | Sunwell Plateau | May 22, 2008 |
| **Bracket_70_6_3** | 70 | - | TBC Final | May 22, 2008 |

### Wrath of the Lich King (9 brackets - Nov 2008 to Jun 2010) + Arena S5-S8
| Bracket | Level | Arena | Content | Date |
|---------|-------|-------|-----------|-------|
| **Bracket_71_74** | 71-74 | - | Northrend Intro | Nov 13, 2008 |
| **Bracket_75_79** | 75-79 | - | Mid-Level | Nov 13, 2008 |
| **Bracket_80_1_1** | 80 | - | Dungeons | Nov 13, 2008 |
| **Bracket_80_1_2** | 80 | **S5** | Heroic Dungeons | Nov 13, 2008 |
| **Bracket_80_2** | 80 | **S6** | T7 (Naxx/OS/EoE) + Ulduar | Mar 17, 2009 |
| **Bracket_80_3** | 80 | **S7** | Trial/Coliseum | Aug 4, 2009 |
| **Bracket_80_4_1** | 80 | **S8** | Icecrown Citadel | Dec 8, 2009 |
| **Bracket_80_4_2** | 80 | - | Ruby Sanctum | Jun 29, 2010 |
| **Bracket_Custom** | - | - | Custom content | - |

---

## 🎮 Arena Seasons - Full Details

### Season 1-4 (TBC)
| Season | Bracket | Period | Rating | Gear | Cost (blizzlike) |
|--------|---------|---------|--------------|------|------------------|
| **S1** | 70_2_1 | (approx.) 2007 | (per `ExtendedCost`) | Gladiator | `ExtendedCost` (Arena Points/Honor/Rating) |
| **S2** | 70_2_2 | (approx.) 2007 | (per `ExtendedCost`) | Merciless | `ExtendedCost` (new + legacy) |
| **S3** | 70_5 | (approx.) 2007-2008 | (per `ExtendedCost`) | Vengeful | `ExtendedCost` (new + legacy) |
| **S4** | 70_6_2 | (approx.) 2008 | (per `ExtendedCost`) | Brutal | `ExtendedCost` (new + legacy) |

### Season 5-8 (WotLK)
| Season | Bracket | Period | Rating | Gear | Cost (blizzlike) |
|--------|---------|---------|--------------|------|------------------|
| **S5** | 80_1_2 | (approx.) 2008-2009 | (per `ExtendedCost`) | Deadly | `ExtendedCost` (new) |
| **S6** | 80_2 | (approx.) 2009 | (per `ExtendedCost`) | Furious | `ExtendedCost` (new + legacy) |
| **S7** | 80_3 | (approx.) 2009-2010 | (per `ExtendedCost`) | Relentless | `ExtendedCost` (new + legacy) |
| **S8** | 80_4_1 | (approx.) 2010 | (per `ExtendedCost`) | Wrathful | `ExtendedCost` (new + legacy) |

---

## ⚙️ Detailed Configuration

### Main Parameters

```ini
# Script/SQL loading per bracket
ProgressionSystem.LoadScripts = 1
ProgressionSystem.LoadDatabase = 1

# Optional: re-apply SQL on each startup (slower)
ProgressionSystem.ReapplyUpdates = 0
```

### Enable Brackets by Name

```ini
# VANILLA
ProgressionSystem.Bracket_0 = 1
ProgressionSystem.Bracket_1_19 = 1
# ... etc for all brackets

# TBC WITH ARENAS
ProgressionSystem.Bracket_70_2_1 = 1  # Arena S1
ProgressionSystem.Bracket_70_2_2 = 1  # Arena S2
ProgressionSystem.Bracket_70_5 = 1    # Arena S3
ProgressionSystem.Bracket_70_6_2 = 1  # Arena S4

# WOTLK WITH ARENAS
ProgressionSystem.Bracket_80_1_2 = 1  # Arena S5
ProgressionSystem.Bracket_80_2 = 1    # Arena S6
ProgressionSystem.Bracket_80_3 = 1    # Arena S7
ProgressionSystem.Bracket_80_4_1 = 1  # Arena S8
```

---

## 🛠️ PHASE 0 - Full Vendor Control

### The Problem Solved
```
❌ BEFORE: TBC S1 players see WotLK S8 items
✅ AFTER: Each bracket only sees its correct items
```

### Solution: DELETE + INSERT Pattern
```sql
-- 1. CLEAN - Delete invalid items
DELETE FROM npc_vendor 
WHERE entry = [VENDOR_ID] 
  AND item NOT IN ([VALID_ITEMS_FOR_THIS_SEASON]);

-- 2. ADD - Insert correct items with blizzlike cost (ExtendedCost)
-- Note: the cost is NOT gold; it is defined by `ExtendedCost` (Arena Points/Honor/Rating)
INSERT INTO npc_vendor (entry, slot, item, maxcount, incrtime, ExtendedCost, VerifiedBuild)
VALUES ([VENDOR_ID], 0, [ITEM_ID], 0, 0, [EXTENDED_COST_ID], 0);

-- 3. VALIDATE - Verify it worked
SELECT COUNT(*) FROM npc_vendor WHERE entry = [VENDOR_ID];
```

### SQL Script Structure

```
src/Bracket_70_2_1/sql/templates/
└─ arena_s1_vendors_cleanup.sql.template          # Arena S1 - Template (fill in placeholders)

src/Bracket_70_2_2/sql/templates/
└─ arena_s2_vendors_cleanup.sql.template          # Arena S2 - Template (S1 legacy + S2 new)

src/Bracket_70_5/sql/templates/
└─ arena_s3_vendors_cleanup.sql.template          # Arena S3 - Template (S1-S3)

src/Bracket_70_6_2/sql/templates/
└─ arena_s4_vendors_cleanup.sql.template          # Arena S4 - Template (S1-S4)

src/Bracket_80_1_2/sql/templates/
├─ transition_tbc_to_wotlk_vendors.sql.template   # TBC→WotLK transition template (npcflag 128)
└─ arena_s5_vendors_cleanup.sql.template          # Arena S5 - Template (S5 only)

src/Bracket_80_2/sql/templates/
└─ arena_s6_vendors_cleanup.sql.template          # Arena S6 - Template (S5 legacy + S6 new)

src/Bracket_80_3/sql/templates/
└─ arena_s7_vendors_cleanup.sql.template          # Arena S7 - Template (S5-S7)

src/Bracket_80_4_1/sql/templates/
└─ arena_s8_vendors_cleanup.sql.template          # Arena S8 - Template (S5-S8)
```

### Season Pricing Table

In blizzlike, the `npc_vendor` table uses `ExtendedCost` to define the cost (Arena Points/Honor/Rating). The distinction
between **new** and **legacy** is represented using **different ExtendedCost values**.

Important:
- `ExtendedCost` **is not a gold amount**; it is an **ID** that points to `item_extended_cost`.
- This module typically **does not invent prices**: it reuses existing costs from your core/DB (blizzlike) via those IDs.
- If an item appears “for gold” at the vendor, it is almost always because `ExtendedCost = 0` (and the item has `BuyPrice` > 0).

-- `*_WITH_EXTENDEDCOST_NEW`: current season costs
-- `*_WITH_EXTENDEDCOST_LEGACY`: discounted costs (or no requirements) for previous seasons

Quick check (to detect accidental gold pricing):
```sql
-- If this returns rows for your arena vendors, they are selling for gold (ExtendedCost=0)
SELECT `entry`, `item`, `ExtendedCost`
FROM `npc_vendor`
WHERE `entry` IN ([Sx_VENDOR_ENTRIES])
  AND `ExtendedCost` = 0;
```

### Required Configuration for PHASE 0

```ini
# Required to apply module SQL
ProgressionSystem.LoadDatabase = 1

# Enable the brackets you want to use
ProgressionSystem.Bracket_70_2_1 = 1
# ProgressionSystem.Bracket_80_4_1 = 1
```

---

## 📖 Step-by-Step Implementation

### Step 1: Identify Vendor IDs in your DB

```sql
-- Vendors (entries)
SELECT entry, name
FROM creature_template
WHERE name LIKE '%Gladiator%'
  OR name LIKE '%Arena%'
  OR name LIKE '%PvP%'
LIMIT 50;

-- Costs (ExtendedCost)
SELECT DISTINCT v.ExtendedCost
FROM npc_vendor v
WHERE v.entry IN (33609, 33610)
ORDER BY v.ExtendedCost;
```

### Step 2: Map Items by Season

```sql
-- S1-S2 items
SELECT entry, name FROM item_template WHERE name LIKE '%Gladiator%' ORDER BY entry;

-- S3 items
SELECT entry, name FROM item_template WHERE name LIKE '%Hateful%' ORDER BY entry;

-- S4 items
SELECT entry, name FROM item_template WHERE name LIKE '%Brutal%' ORDER BY entry;

-- S5-S6 items
SELECT entry, name FROM item_template WHERE name LIKE '%Wrathful%' ORDER BY entry;

-- S7 items
SELECT entry, name FROM item_template WHERE name LIKE '%Vindictive%' ORDER BY entry;

-- S8 items
SELECT entry, name FROM item_template WHERE name LIKE '%Relentless%' ORDER BY entry;
```

### Step 3: Create SQL Scripts

**Template for each bracket:**

```sql
-- File (template): src/Bracket_70_2_1/sql/templates/arena_s1_vendors_cleanup.sql.template
-- =====================================================
-- ARENA SEASON 1 - CLEANUP & ADD
-- Bracket: 70_2_1 (TBC S1)
-- =====================================================

-- CLEAN: Delete everything except valid items
DELETE FROM npc_vendor 
WHERE entry = [VENDOR_ID]
  AND item NOT IN ([S1_ITEM_1], [S1_ITEM_2], ... [S1_ITEM_60]);

-- ADD: Insert S1 items with blizzlike ExtendedCost
INSERT INTO npc_vendor (entry, slot, item, maxcount, incrtime, ExtendedCost, VerifiedBuild)
VALUES
  ([VENDOR_ID], 0, [S1_ITEM_1], 0, 0, [EXTENDED_COST_ID_1], 0),
  ([VENDOR_ID], 0, [S1_ITEM_2], 0, 0, [EXTENDED_COST_ID_2], 0)
  -- ... etc ...
;

-- VALIDATE
SELECT COUNT(*) as s1_items FROM npc_vendor 
WHERE entry = [VENDOR_ID];
-- Expected result: 60
```

### Step 4: Run on Server

```bash
# 1. Copy a template and convert it into an executable update (.sql)
# (Fill in placeholders first)
cp src/Bracket_70_2_1/sql/templates/arena_s1_vendors_cleanup.sql.template ~/azerothcore-wotlk/data/sql/updates/arena_s1_vendors_cleanup.sql

# 2. Reload scripts on the server
.server info  # Verify the module is loaded
.reload scripts

# 3. Run the SQL script (if you execute it manually)
mysql world < arena_s1_vendors_cleanup.sql
```

### Step 5: Validate In-Game

```
Bracket_70_2_1 (TBC S1):
[ ] Vendor visible in Gadgetzan
[ ] Only S1 items available
[ ] Costs via ExtendedCost (blizzlike)

Bracket_70_2_2 (TBC S2):
[ ] Vendor visible in Gadgetzan
[ ] S1 (100k) and S2 (200k) items available
[ ] Total ~120 items

Bracket_80_1_2 (WotLK S5):
[ ] Gadgetzan vendor is gone
[ ] New vendor in Dalaran
[ ] Only S5 items available
[ ] Costs via ExtendedCost (blizzlike)
```

---

## 🔧 Troubleshooting

### Vendor not visible
```sql
-- Verify that the NPC has the vendor flag (bit 128)
SELECT entry, name, npcflag
FROM creature_template
WHERE entry = [VENDOR_ID];

-- Enable vendor flag (bit 128)
UPDATE creature_template
SET npcflag = (npcflag | 128)
WHERE entry = [VENDOR_ID];
```

### Incorrect items showing
```sql
-- Check which items the vendor has
SELECT nv.entry, nv.item, it.name, nv.ExtendedCost
FROM npc_vendor nv
INNER JOIN item_template it ON nv.item = it.entry
WHERE nv.entry = [VENDOR_ID]
ORDER BY nv.item;

-- Run cleanup manually
DELETE FROM npc_vendor WHERE entry = [VENDOR_ID];
```

### Incorrect ExtendedCost
```sql
-- Check ExtendedCost
SELECT nv.entry, nv.item, nv.ExtendedCost
FROM npc_vendor nv
WHERE nv.entry = [VENDOR_ID];

-- Update ExtendedCost
UPDATE npc_vendor
SET ExtendedCost = [CORRECT_EXTENDED_COST_ID]
WHERE entry = [VENDOR_ID] AND item = [ITEM_ID];
```

---

## 📚 Additional Documentation

- **BRACKET_DESCRIPTIONS_COMPLETE.md** - Detailed description of each of the 38 brackets
- **audit/README.md** - Manual SQL + audit/validation index
- **audit/ARENA_SEASONS_VALIDATION.md** - Complete mapping of 8 Arena Seasons
- **audit/PARAMETROS_TECNICOS_DESARROLLO.md** - Technical parameters and SQL validations

---

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under AGPL v3. See the [LICENSE](LICENSE) file for more details.

---

## 💬 Support

- **AzerothCore Discord**: [Join the server](https://discord.gg/azerothcore)
- **Documentation**: Check the `.md` files in the project root and `audit/`
- **Issues**: Report problems via GitHub Issues

---

## 📊 Project Status

- ✅ Full analysis of 38 brackets
- ✅ Documentation for 8 Arena Seasons
- ✅ Vendor control system (PHASE 0)
- ✅ Configuration validation
- 🟡 SQL script implementation (see IMPLEMENTACION_VENDORS_SQL.md)
- ⏳ Full production testing

### Implementation Status: SQL Scripts

**What it means when it says "missing implementation of the scripts in MySQL":**

The SQL template files are ready but need to be **customized and executed** in your MySQL database:

1. **Templates created** (in `/src/Bracket_*/sql/templates/`):
  - `arena_s1_vendors_cleanup.sql.template` through `arena_s8_vendors_cleanup.sql.template`
  - `transition_tbc_to_wotlk_vendors.sql.template`

  Production note: `src/**/sql/world/vendors_*.sql` are stubs (comments) so the DBUpdater does not execute placeholders.

2. **What to do now**:
  - Read [IMPLEMENTACION_VENDORS_SQL.md](IMPLEMENTACION_VENDORS_SQL.md)
  - Get the real **vendor entries** (Horde/Alliance) in `creature_template`
  - Get the real **ExtendedCost IDs** in `item_extended_cost` / existing vendors
  - Replace placeholders in each template with real values
  - Save a copy as `.sql` and execute it (manually or as an update)

3. **Estimated time**: ~57 minutes total

---

**Last updated**: 2025-01-09  
**Version**: 1.0  
**Compatibility**: AzerothCore 3.3.5a

---

## 🙏 Credits and Acknowledgements

This project is based on and inspired by the original AzerothCore repository:

- https://github.com/azerothcore/mod-progression-system

Thanks to AzerothCore and the original contributors for the work and technical foundation this fork is built on.

---

## ✍️ Signature

Fork/maintainer: Kambi (mod-progression-blizzlike)

Date: 2025-12-24

```
Created with ❤️ for the AzerothCore community
```
