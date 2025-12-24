# Deployment Checklist

This module is **production-ready** for AzerothCore 3.3.5a (WotLK).

## ✅ Pre-Deployment Verification

All required components are in place:

- [x] CMakeLists.txt (build configuration)
- [x] 38 bracket directories with loaders
- [x] SQL loading infrastructure
- [x] Configuration system
- [x] Documentation (README.md, PRODUCTION.md)
- [x] Arena season templates (S1-S8)
- [x] Vendor control SQL patterns

## 🚀 Quick Start

### 1. Clone Module

```bash
cd ~/azerothcore-wotlk/modules
git clone https://github.com/kambire/mod-progression-blizzlike.git
```

### 2. Configure

```bash
cd mod-progression-blizzlike/conf
cp progression_system.conf.dist progression_system.conf
# Edit progression_system.conf to enable desired brackets
```

### 3. Compile AzerothCore

```bash
cd ~/azerothcore-wotlk
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/azeroth-server
make -j$(nproc)
make install
```

### 4. Copy Configuration

```bash
cp ~/azerothcore-wotlk/modules/mod-progression-blizzlike/conf/progression_system.conf.dist \
   ~/azeroth-server/etc/modules/progression_system.conf
```

### 5. Start Server

The module will automatically:
- Load enabled bracket SQL files on first startup
- Apply database updates from world/characters/auth directories
- Initialize progression system

## 📋 Feature Summary

### Implemented Features

✅ **38 Level-Based Brackets**
- Vanilla (14 brackets): 1-60, raid tiers 1-3
- TBC (15 brackets): 61-70, raid tiers + 4 arena seasons
- WotLK (9 brackets): 71-80, raid tiers + 4 arena seasons

✅ **8 Arena Seasons**
- S1-S4 (TBC): Gladiator, Merciless, Vengeful, Brutal
- S5-S8 (WotLK): Deadly, Furious, Relentless, Wrathful

✅ **Automatic Content Loading**
- SQL files auto-loaded per bracket
- C++ scripts loaded per bracket
- Configuration-based enabling/disabling

✅ **Vendor Control**
- ExtendedCost-based pricing (Arena Points/Honor/Rating)
- Vendor visibility control (npcflag bit 128)
- Season-specific item filtering

✅ **Content Gating**
- Raid/dungeon access restrictions
- Quest gating per bracket
- Attunement system support

✅ **Centralized Configuration**
- Single conf file for all settings
- 50+ advanced options
- Independent bracket control

## 📖 Documentation

- **README.md** - Full feature documentation
- **PRODUCTION.md** - Production deployment guide
- **BRACKET_DESCRIPTIONS_COMPLETE.md** - Detailed bracket info
- **ARENA_SEASONS_VALIDATION.md** - Arena season mapping
- **IMPLEMENTACION_VENDORS_SQL.md** - Vendor implementation guide

## ⚙️ Configuration Examples

### Enable Vanilla Content Only

```ini
ProgressionSystem.LoadScripts = 1
ProgressionSystem.LoadDatabase = 1
ProgressionSystem.Bracket_0 = 1
ProgressionSystem.Bracket_1_19 = 1
ProgressionSystem.Bracket_20_29 = 1
# ... enable all Vanilla brackets ...
ProgressionSystem.Bracket_60_3_3 = 1
```

### Enable TBC Arena Season 1

```ini
ProgressionSystem.Bracket_70_2_1 = 1
ProgressionSystem.Arena.Season1.BracketRestriction = 1
ProgressionSystem.EnforceArenaVendorProgression = 1
```

### Enable WotLK Complete

```ini
# Enable all WotLK brackets
ProgressionSystem.Bracket_71_74 = 1
ProgressionSystem.Bracket_75_79 = 1
ProgressionSystem.Bracket_80_1_1 = 1
ProgressionSystem.Bracket_80_1_2 = 1
ProgressionSystem.Bracket_80_2 = 1
ProgressionSystem.Bracket_80_3 = 1
ProgressionSystem.Bracket_80_4_1 = 1
ProgressionSystem.Bracket_80_4_2 = 1

# Enable Arena Seasons 5-8
ProgressionSystem.Arena.Season5.BracketRestriction = 1
ProgressionSystem.Arena.Season6.BracketRestriction = 1
ProgressionSystem.Arena.Season7.BracketRestriction = 1
ProgressionSystem.Arena.Season8.BracketRestriction = 1
```

## 🔧 Vendor Customization

Vendor templates are located in:
```
src/Bracket_*/sql/templates/*.sql.template
```

To customize vendors:
1. Copy template to a working directory
2. Replace placeholders with your database IDs
3. Execute SQL manually or add to custom updates

See **IMPLEMENTACION_VENDORS_SQL.md** for detailed instructions.

## 🐛 Troubleshooting

### Module Not Loading

```bash
# Check server logs for:
# "Loading mod-progression-blizzlike updates..."
```

### Brackets Not Active

```bash
# In-game command:
.progression info
# Shows which brackets are enabled
```

### Vendor Issues

```sql
-- Check vendor configuration
SELECT entry, item, ExtendedCost 
FROM npc_vendor 
WHERE entry = <VENDOR_ID>;

-- Verify ExtendedCost != 0 for arena items
```

## 📊 System Architecture

```
mod-progression-blizzlike/
├── CMakeLists.txt              # Build configuration
├── conf/
│   └── progression_system.conf.dist  # Configuration template
├── src/
│   ├── ProgressionSystem.h     # Core header
│   ├── ProgressionSystem.cpp   # SQL loading logic
│   ├── ProgressionSystem_loader.cpp  # Bracket loader declarations
│   ├── cs_progression_module.cpp     # Command scripts
│   └── Bracket_*/              # 38 bracket implementations
│       ├── Bracket_*_loader.cpp      # C++ scripts
│       └── sql/
│           ├── world/          # World DB updates
│           ├── characters/     # Character DB updates
│           ├── auth/           # Auth DB updates
│           └── templates/      # Vendor templates
└── scripts/
    └── production_package.ps1  # Windows packaging script
```

## 🔐 Security Notes

- All SQL stub files are safe (no executable placeholders)
- Template files are isolated in templates/ directories
- DBUpdater prevents duplicate SQL execution
- Configuration validation on startup

## 🤝 Contributing

See main README.md for contribution guidelines.

## 📝 License

GNU AGPL v3 - See LICENSE file

## 💬 Support

- AzerothCore Discord: https://discord.gg/azerothcore
- GitHub Issues: https://github.com/kambire/mod-progression-blizzlike/issues

---

**Version**: 1.0  
**Status**: Production Ready  
**Last Updated**: 2024-12-24  
**Compatibility**: AzerothCore 3.3.5a (WotLK)
