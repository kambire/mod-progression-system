# 🎮 Progression System Module - AzerothCore
# This module is not ready yet. Do not use it on live/production servers.

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
| **Bracket_80_2_1** | 80 | - | T7 raids (Naxx/OS/EoE) | Nov 13, 2008 |
| **Bracket_80_2_2** | 80 | **S6** | Ulduar (T8) | Apr 16, 2009 |
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
| **S6** | 80_2_2 | (approx.) 2009 | (per `ExtendedCost`) | Furious | `ExtendedCost` (new + legacy) |
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

### Heroic iLvl Gate (optional)

This module can block heroic dungeon entry if a player's average equipped item level is below a threshold.
Configure it with `ProgressionSystem.HeroicGs.*` in the module config; values are average iLvl (not GearScore).

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
ProgressionSystem.Bracket_80_2_2 = 1  # Arena S6
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

### How it works (high level)
This module keeps PvP/Arena vendors aligned with the active bracket/season using SQL updates.

- You enable the bracket(s) you want.
- The server applies that bracket’s SQL updates at startup (via AzerothCore `DBUpdater`) when `ProgressionSystem.LoadDatabase = 1`.
- Each bracket update ensures vendors offer only the intended season items and prices.

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

src/Bracket_80_2_2/sql/templates/
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

Quick sanity check (to detect accidental gold pricing):
- If items show up “for gold”, it usually means `ExtendedCost = 0`.
- Fix by using the correct `ExtendedCost` IDs from your core/DB.

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
Identify the NPC entries used as arena/PvP vendors in your database. This varies by DB pack, so use whichever tooling you prefer (SQL editor, DB browser, or in-game GM inspection).

### Step 2: Map Items by Season
Decide which item sets belong to each season in your environment. The repository provides templates per season; you only need to fill in the correct item IDs and vendor NPC entries for your DB.

### Step 3: Create SQL Scripts

**Template for each bracket:**
Start from the corresponding template under `src/Bracket_*/sql/templates/` and replace the placeholders:

- Vendor NPC entry IDs
- Item IDs for that season
- `ExtendedCost` IDs (from your DB/core)

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

### Module not applying bracket SQL / looks like it "doesn't run"
- Verify the module is loaded: you should see `[mod-progression-blizzlike] Effective config:` in the worldserver console/logs at startup.
- Ensure you are editing the active config in `etc/modules/*.conf` (not `conf/*.conf.dist`) and that it contains a `[worldserver]` section.
- If the server is started with a different working directory (Windows service, IDE, etc), set `ProgressionSystem.BracketSqlRoot` to an absolute path to `.../modules/mod-progression-blizzlike/src` so the module can find `Bracket_*` SQL folders.
- If your core logs `Config: Missing property ProgressionSystem.BracketSqlRoot`, add `ProgressionSystem.BracketSqlRoot = ""` to your module config to silence it (empty means auto-detect).
- Confirm AzerothCore DBUpdater is enabled in your `worldserver.conf` (Updates settings), otherwise no module SQL will be applied.
- If you edited a bracket `.sql` file but changes don't apply: DBUpdater remembers applied updates in the `updates` table (often by filename). Enable `ProgressionSystem.ReapplyUpdates = 1`, rename the SQL file, or delete its row from `updates`.

### Vendor not visible
- Check the vendor NPC is spawned and has the vendor flag enabled (vendor flag / `npcflag` depends on core/DB).
- Verify the bracket that controls that vendor is enabled and its SQL updates were applied.

### Incorrect items showing
- Confirm you filled the correct template for the current season.
- Confirm no other update pack/custom SQL is re-adding items after cleanup.

### Incorrect ExtendedCost / items cost gold
- If an item costs gold, it usually means `ExtendedCost = 0`.
- Fix by applying the correct `ExtendedCost` IDs for that season.

### Module disabled but DB changes remain
- Disabling `ProgressionSystem.LoadDatabase` stops new SQL from applying, but it does not rollback existing DB changes.
- Use backups or the manual vendor-flag restore in `audit/NPCFLAG_VENDOR_FIX.sql` if you need to revert defaults.

---

## 📚 Additional Documentation

- **BRACKET_DESCRIPTIONS_COMPLETE.md** - Detailed description of each of the 38 brackets
- **ARENA_SEASONS_VALIDATION.md** - Complete mapping of 8 Arena Seasons
- **PARAMETROS_TECNICOS_DESARROLLO.md** - Technical parameters and SQL validations

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
