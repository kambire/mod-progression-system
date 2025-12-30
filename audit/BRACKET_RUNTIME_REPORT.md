# Bracket Runtime Report (Autoload SQL + Scripts)

Generated: 2025-12-30 18:21:19
Generator: `scripts/generate_bracket_report.ps1`

This document focuses on what each bracket enables **in this module**:
- If `ProgressionSystem.LoadDatabase = 1`: SQL updates are applied via AzerothCore `DBUpdater` from `src/Bracket_*/sql/{world,characters,auth}`.
- If `ProgressionSystem.LoadScripts = 1`: optional C++ scripts are loaded per bracket from `src/Bracket_*/scripts` (registered by each `Bracket_*_loader.cpp`).
- Brackets are applied in this order (important when multiple brackets are enabled at the same time):

```
Bracket_0, Bracket_1_19, Bracket_20_29, Bracket_30_39, Bracket_40_49, Bracket_50_59_1, Bracket_50_59_2, Bracket_60_1_1, Bracket_60_1_2, Bracket_60_2_1, Bracket_60_2_2, Bracket_60_3_1, Bracket_60_3_2, Bracket_60_3_3, Bracket_61_64, Bracket_65_69, Bracket_70_1_1, Bracket_70_1_2, Bracket_70_2_1, Bracket_70_2_2, Bracket_70_2_3, Bracket_70_3_1, Bracket_70_3_2, Bracket_70_4_1, Bracket_70_4_2, Bracket_70_5, Bracket_70_6_1, Bracket_70_6_2, Bracket_70_6_3, Bracket_71_74, Bracket_75_79, Bracket_80_1_1, Bracket_80_1_2, Bracket_80_2_1, Bracket_80_2_2, Bracket_80_3, Bracket_80_4_1, Bracket_80_4_2, Bracket_Custom
```

Notes:
- A bracket is **effectively enabled** if `ProgressionSystem.Bracket_<name> = 1` OR it is included in an enabled `ProgressionSystem.Bracket.ArenaSeasonN` mapping.
- The SQL file header comments below are extracted from each autoload `.sql` file; open the file for full details.

## Bracket_0

- Config key: `ProgressionSystem.Bracket_0`
- Config template notes:
  - Level Range: 1-10 | Vanilla: Pre-Launch | Starting Zones
  - Content: Shadowfang Keep, Deadmines, Wailing Caverns, Blackfathom Deeps, Ragefire Chasm
  - Features: First dungeons for new players, class-specific quests, basic reputation farming
  - Release: November 23, 2004
  - Recommended Duration: 1-2 weeks
- Loader: `src/Bracket_0/Bracket_0_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (16 files)
- `progression_0_creature_Gangrenous.sql` (tables: `creature`)
  - Hide Gangrenus which is accesible from exploits
- `progression_0_creature_KarazhanNPCs.sql` (tables: `creature`)
  - Hide Karazhan NPCs
- `progression_0_creature_template.sql` (tables: `creature_template`, `npc_vendor`)
  - disable NPC vendor of Arena Season 4
  - https://github.com/azerothcore/progression-system/issues/30
- `progression_0_creature_undercity_guardian.sql` (tables: `creature`)
  - Replace Kor'Kron Overseer with Undercity Guardian until ICC
- `progression_0_creature_UngoroCultists.sql` (tables: `creature`)
  - Hide the 11 cultists in Un'Goro (Bracket 70_4)
- `progression_0_creature_VaultofArchavon.sql` (tables: `creature`)
  - Hide Emalon, Koralon and Toravon at Vault of Archavon
- `progression_0_creature_WorldBosses.sql` (tables: `creature`)
  - Hide World Bosses
- `progression_0_disables.sql` (tables: `disables`)
  - 1-19 level range
- `progression_0_disables_AhnQirajWarEffortquests.sql` (tables: `disables`)
  - Disable War Effort and AQ Quests
- `progression_0_disables_ArgentTournamentquests.sql` (tables: `disables`)
  - (no header comment; open the file for details)
- `progression_0_item_loot_template.sql` (tables: `item_loot_template`)
  - set satchel of helpful goods loot 55 to 50
- `progression_0_mapdifficulty_dbc.sql` (tables: `mapdifficulty_dbc`)
  - (no header comment; open the file for details)
- `progression_0_npc_trainer_flying.sql` (tables: `cost`, `npc_trainer`)
  - Update cost for normal flying
- `progression_0_npc_vendor_DarkmoonFaire.sql` (tables: `npc_vendor`)
  - Lhara in Darkmoon Faire, entry: 14846
  - Removes TBC and WotLK items
  - items: (21887, 22572, 22573, 22574, 22575, 22576, 22577, 22578, 22787, 22789, 22790, 22791, 22792, 22793, 22794, 23436, 23437, 23438, 23439, 23440, 23441, 23793, 25707, 25708, 33568, 36901, 36903, 36904, 36905, 36906, 36907, 36908, 37700, 37701, 37702, 37703, 37704, 37705, 37921, 38425, 44128, 46812)
- `progression_0_npc_vendor_PvP.sql` (tables: `npc_vendor`)
  - Alterac vendor entry: (13217, 13219)
  - Thanthaldis Snowgleam <Stormpike Supply Officer> (13217)
  - Jekyll Flandring <Frostwolf Supply Officer> ( )
  - items req lvl 60: (21563, 19325, 19323, 19321, 19312, 19315, 19311, 19310, 19309, 19308)
- `progression_0_prospecting_loot_template_thorium.sql` (tables: `prospecting_loot_template`)
  - Remove TBC gems from Thorium prospecting

## Bracket_1_19

- Config key: `ProgressionSystem.Bracket_1_19`
- Config template notes:
  - Level Range: 10-19 | Vanilla: Early Game | Early Dungeons & World Content
  - Content: Shadowfang Keep, Deadmines, Wailing Caverns, Blackfathom Deeps, Ragefire Chasm
  - Features: Class dungeons unlocking, faction reputation increases, crafting recipes, world boss intro
  - Release: November 23, 2004
  - Recommended Duration: 1-2 weeks
- Loader: `src/Bracket_1_19/Bracket_1_19_loader.cpp`
- C++ scripts:
  - `src/Bracket_1_19/scripts/events/brewfest.cpp`
  - `src/Bracket_1_19/scripts/events/hallows_end.cpp`
  - `src/Bracket_1_19/scripts/events/love_in_air.cpp`
  - `src/Bracket_1_19/scripts/events/midsummer.cpp`

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (7 files)
- `progression_1_19_brewfest.sql` (tables: `creature`, `creature_template`, `game_event_creature`, `item_loot_template`)
  - (no header comment; open the file for details)
- `progression_1_19_bruisers.sql` (tables: `creature_template`)
  - (no header comment; open the file for details)
- `progression_1_19_disables.sql` (tables: `disables`)
  - 1-19 level range
- `progression_1_19_hallows_end.sql` (tables: `creature_template`, `item_loot_template`, `quest_template`)
  - (no header comment; open the file for details)
- `progression_1_19_love_in_air.sql` (tables: `conditions`, `creature`, `creature_loot_template`, `creature_template`, `game_event_creature`, `item_loot_template`, `item_template`)
  - (no header comment; open the file for details)
- `progression_1_19_world_event_Ahune.sql` (tables: `creature_template`, `gameobject_loot_template`, `item_template`, `quest_template`)
  - Change Ahune loot to TBC-Era
- `progression_1_19_world_event_Winter_Hats.sql` (tables: `conditions`, `creature_loot_template`)
  - (no header comment; open the file for details)

## Bracket_20_29

- Config key: `ProgressionSystem.Bracket_20_29`
- Config template notes:
  - Level Range: 20-29 | Vanilla: Early Game | Mid-Level Dungeons
  - Content: Stormwind Stockades, Razorfen Kraul, Gnomeregan
  - Features: Reputation farming, profession recipes, PvP introduction, difficulty increases
  - Release: November 23, 2004
  - Recommended Duration: 1-2 weeks
- Loader: `src/Bracket_20_29/Bracket_20_29_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (1 files)
- `progression_20_29_disables.sql` (tables: `disables`)
  - 20-29 level range

## Bracket_30_39

- Config key: `ProgressionSystem.Bracket_30_39`
- Config template notes:
  - Level Range: 30-39 | Vanilla: Early Game | Advanced Dungeons
  - Content: Uldaman (Dwarven heritage), Razorfen Downs (undead zone), Scarlet Monastery
  - Features: Higher-level enemies, better loot, profession recipes, world bosses become relevant
  - Release: November 23, 2004
  - Recommended Duration: 1-2 weeks
- Loader: `src/Bracket_30_39/Bracket_30_39_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (1 files)
- `progression_30_39_disables.sql` (tables: `disables`)
  - 30-39 level range

## Bracket_40_49

- Config key: `ProgressionSystem.Bracket_40_49`
- Config template notes:
  - Level Range: 40-49 | Vanilla: Mid Game | World Dungeons & Attunement Prep
  - Content: Dire Maul, Blackrock Depths, Scholomance, Stratholme, World Bosses (Dragons, Kazzak)
  - Features: Attunement quest chains begin, world boss farming, pre-raid gear, PvP intensifies
  - Release: November 23, 2004
  - Recommended Duration: 1-2 weeks
- Loader: `src/Bracket_40_49/Bracket_40_49_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (2 files)
- `progression_40_49_disables.sql` (tables: `disables`)
  - 40-49 level range
- `progression_40_49_gossip_menu_option.sql` (tables: `gossip_menu_option`)
  - Dual spec progression prices
  - 40-49     500G
  - 50-59     600G
  - 60        800G
  - 61-70     900G
  - 71-80     1000G

## Bracket_50_59_1

- Config key: `ProgressionSystem.Bracket_50_59_1`
- Config template notes:
  - Level Range: 50-59 | Vanilla: Late Game | UBRS Attunement Phase
  - Content: Upper Blackrock Spire attunement preparation, world bosses (Azuregos, Dragons, Kazzak)
  - Features: Attunement quest chains, raid-level difficulty encounters, epic world boss battles
  - Release: November 23, 2004
  - Recommended Duration: 1-2 weeks
- Loader: `src/Bracket_50_59_1/Bracket_50_59_1_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (4 files)
- `progression_50_59_1_disables.sql` (tables: `disables`)
  - 50-59 level range (BRD, Dire Maul, Scholomance, Stratholme)
- `progression_50_59_1_gossip_menu_option.sql` (tables: `gossip_menu_option`)
  - Dual spec progression prices
  - 40-49     500G
  - 50-59     600G
  - 60        800G
  - 61-70     900G
  - 71-80     1000G
- `progression_50_59_1_lfg_dungeon_rewards.sql` (tables: `lfg_dungeon_rewards`)
  - set satchels for level 59 to be the Classic ones instead of TBC
- `progression_50_59_1_npc_vendor.sql` (tables: `npc_vendor`)
  - STARTING PHASE 50-59

## Bracket_50_59_2

- Config key: `ProgressionSystem.Bracket_50_59_2`
- Config template notes:
  - Level Range: 50-59 | Vanilla: Late Game | Upper Blackrock Spire (10-man Raid-like)
  - Content: UBRS full progression, all bosses available, world boss farming
  - Features: Pre-raid gear optimization, dungeon farming, final preparation for Molten Core
  - Release: November 23, 2004
  - Recommended Duration: 2-3 weeks
- Loader: `src/Bracket_50_59_2/Bracket_50_59_2_loader.cpp`
- C++ scripts:
  - `src/Bracket_50_59_2/scripts/BlackrockSpire/boss_drakkisath.cpp`
  - `src/Bracket_50_59_2/scripts/BlackrockSpire/instance_blackrock_spire.cpp`

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (2 files)
- `progression_50_59_2_disables.sql` (tables: `disables`)
  - 50-59 level range (LBRS / UBRS)
- `progression_50_59_2_npc_vendor_PvP.sql` (tables: `creature_template`, `npc_vendor`)
  - END PHASE 50-59

## Bracket_60_1_1

- Config key: `ProgressionSystem.Bracket_60_1_1`
- Config template notes:
  - Level 60 | Vanilla: Raid Tier 1 | Molten Core (40-man)
  - Bosses (8): Lucifron, Magmadar, Gehennas, Garr, Shazzrah, Baron Geddon, Golemagg, Ragnaros
  - Location: Blackrock Mountain (Molten Core instance)
  - Features: First true raid experience, 40-man coordination, world-class encounters, epic boss mounts
  - Release: November 23, 2004
  - Recommended Duration: 6-8 weeks
- Loader: `src/Bracket_60_1_1/Bracket_60_1_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (4 files)
- `progression_60_1_1_disables.sql` (tables: `disables`)
  - 50-59 level range (LBRS / UBRS)
- `progression_60_1_1_gossip_menu_option.sql` (tables: `gossip_menu_option`)
  - Dual spec progression prices
  - 40-49     500G
  - 50-59     600G
  - 60        800G
  - 61-70     900G
  - 71-80     1000G
- `progression_60_1_1_mail_level_rewards.sql` (tables: `mail_level_reward`)
  - Disable flight trainer mails
- `progression_60_1_1_npc_vendor_PvP.sql` (tables: `creature_template`, `npc_vendor`)
  - END PHASE 50-59

## Bracket_60_1_2

- Config key: `ProgressionSystem.Bracket_60_1_2`
- Config template notes:
  - Level 60 | Vanilla: Raid Tier 1 (Optional) | Onyxia's Lair (40-man)
  - Boss (1): Onyxia (The Broodmother)
  - Location: Onyxia's Lair (Dustwallow Marsh)
  - Features: Iconic dragon encounter, class debuff challenge, first real DPS check, dragon mount
  - Release: November 23, 2004
  - Recommended Duration: 3-4 weeks (can overlap with Molten Core)
- Loader: `src/Bracket_60_1_2/Bracket_60_1_2_loader.cpp`
- C++ scripts:
  - `src/Bracket_60_1_2/scripts/MoltenCore/instance_molten_core.cpp`

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (5 files)
- `progression_60_1_2_disables.sql` (tables: `disables`)
  - 60 level range - Tier 1
- `progression_60_1_2_MC_firelord_runes.sql` (tables: `gameobject_template`)
  - MC - Require dusing the runes
- `progression_60_1_2_MC_poisoned_water.sql` (tables: `creature_queststarter`)
  - (no header comment; open the file for details)
- `progression_60_1_2_spell_dbc.sql` (tables: `spell_dbc`)
  - Change Baron Geddon explosion base damage from 3200 to 2100
- `progression_60_1_2_trash_boe_normalised.sql` (tables: `creature_loot_template`)
  - Ancient Core Hound

## Bracket_60_2_1

- Config key: `ProgressionSystem.Bracket_60_2_1`
- Config template notes:
  - Level 60 | Vanilla: Raid Tier 2 | Blackwing Lair (40-man)
  - Bosses (8): Razorgore, Vaelastrasz, Broodlord Lashlayer, Firemaw, Ebonroc, Taerar, Ysondre, Lord Victor Nefarius
  - Location: Blackrock Mountain (Blackwing Tower)
  - Features: Fire resistance gear requirements, dragon encounters, buff control, complex mechanics
  - Release: January 19, 2005
  - Recommended Duration: 6-8 weeks
- Loader: `src/Bracket_60_2_1/Bracket_60_2_1_loader.cpp`
- C++ scripts:
  - `src/Bracket_60_2_1/scripts/OnyxiasLair/boss_onyxia.cpp`
  - `src/Bracket_60_2_1/scripts/OnyxiasLair/instance_onyxias_lair.cpp`
  - `src/Bracket_60_2_1/scripts/TheMasquerade/quest_jail_break.cpp`
  - `src/Bracket_60_2_1/scripts/TheMasquerade/quest_the_masquerade.cpp`
  - `src/Bracket_60_2_1/scripts/WorldBosses/boss_lord_kazzak.cpp`

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (9 files)
- `progression_0_creature_WorldBosses_down_1.sql` (tables: `creature`)
  - Enable Azuregos
- `progression_60_2_1_conditions.sql` (tables: `conditions`)
  - WSG factions requirements
- `progression_60_2_1_disables.sql` (tables: `disables`)
  - (no header comment; open the file for details)
- `progression_60_2_1_item_template.sql` (tables: `item_template`)
  - Arathi Horde vendor entry: (15126)
  - items: (20068, 20158, 20175, 20176, 20184, 20194, 20203, 20212, 20220, 20214)
- `progression_60_2_1_kazzak.sql` (tables: `creature`, `creature_addon`, `creature_loot_template`, `creature_template`, `creature_text`, `reference_loot_template`, `spell_script_names`, `waypoint_data`)
  - (no header comment; open the file for details)
- `progression_60_2_1_mapdifficulty_dbc.sql` (tables: `mapdifficulty_dbc`)
  - (no header comment; open the file for details)
- `progression_60_2_1_npc_vendor_PvP.sql` (tables: `npc_vendor`)
  - Blue PvP set */
  - SET @EXTENDED_COST = 2560; -- 31600 honor
  - Restore <Legacy Armor Quartermaster> lvl 60 blue items, do not delete the previous items lvl 50-59
  - Sergeant Major Clate (12785) (alliance)
  - First Sergeant Hola'mahi  (12795) (horde)
- `progression_60_2_1_onyxia.sql` (tables: `achievement_criteria_data`, `conditions`, `creature_loot_template`, `creature_questender`, `creature_queststarter`, `creature_template`, `disables`, `dungeon_access_requirements`, `dungeon_access_template`, `gossip_menu`, `gossip_menu_option`, `item_template`, `mapdifficulty_dbc`, `npc_text`, `quest_template_addon`, `reference_loot_template`, `smart_scripts`, `spell_linked_spell`)
  - Onyxia
- `progression_60_2_1_the_masquerade.sql` (tables: `conditions`, `creature`, `creature_questender`, `creature_queststarter`, `creature_template`, `creature_text`, `disables`, `entry`, `gossip_menu`, `gossip_menu_option`, `item_template`, `quest_template`, `script_waypoint`, `smart_scripts`)
  - (no header comment; open the file for details)

## Bracket_60_2_2

- Config key: `ProgressionSystem.Bracket_60_2_2`
- Config template notes:
  - Level 60 | Vanilla: Raid Tier 2.5 (Optional) | Zul'Gurub (20-man)
  - Bosses (6+): High Priest Thekal, High Priestess Mar'li, High Priest Venoxis, Bloodlord Mandokir, Edge of Madness, Gahz'ranka, Hakkar
  - Location: Zul'Gurub (Stranglethorn Vale)
  - Features: Troll aesthetic, 20-man format, voodoo/spirit magic, unique mechanics
  - Release: January 19, 2005
  - Recommended Duration: 4-6 weeks (can overlap with BWL)
- Loader: `src/Bracket_60_2_2/Bracket_60_2_2_loader.cpp`
- C++ scripts:
  - `src/Bracket_60_2_2/scripts/BlackwingLair/boss_chromaggus.cpp`

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (7 files)
- `progression_60_2_2_chromaggus_time_lapse.sql` (tables: `spell_script_names`)
  - (no header comment; open the file for details)
- `progression_60_2_2_Conditions.sql` (tables: `conditions`)
  - WSG factions requirements
- `progression_60_2_2_disables.sql` (tables: `disables`)
  - 60 level range - Tier 2
- `progression_60_2_2_item_template.sql` (tables: `item_template`)
  - Arathi Horde vendor entry: (15126)
  - items: (20068, 20158, 20175, 20176, 20184, 20194, 20203, 20212, 20220, 20214)
- `progression_60_2_2_nefarian_loot.sql` (tables: `creature_loot_template`, `reference_loot_template`)
  - Nefarian
- `progression_60_2_2_npc_vendor_PvP.sql` (tables: `npc_vendor`)
  - Re-inserting the Vanilla PVP gear in Alterac Valley Vendors
- `progression_60_2_2_spell_dbc.sql` (tables: `spell_dbc`)
  - (no header comment; open the file for details)

## Bracket_60_3_1

- Config key: `ProgressionSystem.Bracket_60_3_1`
- Config template notes:
  - Level 60 | Vanilla: Raid Tier 2.5 | Ruins of Ahn'Qiraj (20-man)
  - Bosses (3+): Kurinnaxx, General Rajaxx, Ossirian the Unscarred (optional: Taerar)
  - Location: Silithus Desert (AQ20 entrance)
  - Features: Insectoid encounters, sandstorm mechanics, Cenarion Circle reputation
  - Release: January 19, 2005
  - Recommended Duration: 4-6 weeks (can overlap with BWL)
- Loader: `src/Bracket_60_3_1/Bracket_60_3_1_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (2 files)
- `progression_0_creature_WorldBosses_down_2.sql` (tables: `creature`)
  - Enable Dragons of Nightmare
- `progression_60_3_1_disables.sql` (tables: `disables`)
  - 60 level range - Zulâ€™Gurub

## Bracket_60_3_2

- Config key: `ProgressionSystem.Bracket_60_3_2`
- Config template notes:
  - Level 60 | Vanilla: Raid Tier 3 | Temple of Ahn'Qiraj (40-man)
  - Bosses (9): Dragons, Taerar, Mstruthas, Vem, Yauj, Taur, Fankriss, Viscidus, Princess Huhuran, Twin Emperors Vek'lor & Vek'nilash, C'Thun
  - Location: Silithus (AQ40 - The Temple)
  - Features: Bug encounters, nature vs insect storyline, C'Thun complexity, silithid farming
  - Release: January 19, 2005
  - Recommended Duration: 6-8 weeks
- Loader: `src/Bracket_60_3_2/Bracket_60_3_2_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (7 files)
- `progression_0_disables_AhnQirajWarEffortquests_down.sql` (tables: `disables`)
  - Enable War Effort and AQ Quests
- `progression_60_1_2_MC_poisoned_water_down.sql` (tables: `creature_queststarter`)
  - (no header comment; open the file for details)
- `progression_60_2_pvp_items_reputation_down.sql` (tables: `conditions`, `item_template`)
- `progression_60_3_2_aq20_brood_rep.sql` (tables: `creature_onkill_reputation`)
  - 910, 50
- `progression_60_3_2_disables.sql` (tables: `disables`)
  - 60 level range - Ahnâ€™Qiraj
- `progression_60_3_2_onyxia_requirement.sql` (tables: `conditions`, `dungeon_access_requirements`)
  - (no header comment; open the file for details)
- `progression_60_3_2_pvp_items_price.sql` (tables: `npc_vendor`)
  - Blue PvP set */
  - SET @EXTENDED_COST = 171; -- 31600 honor
  - Sergeant Major Clate (12785) (alliance)
  - First Sergeant Hola'mahi  (12795) (horde)

## Bracket_60_3_3

- Config key: `ProgressionSystem.Bracket_60_3_3`
- Config template notes:
  - Level 60 | Vanilla: Final Phase | AQ Post-Content (World Events)
  - Content: Dragons of Nightmare, Silithus world events, high-end dungeon accessibility
  - Features: World event coordination, dragon hunting, final Vanilla phase preparation
  - Release: January 19, 2005 onwards
  - Recommended Duration: 3-4 weeks (transition phase)
- Loader: `src/Bracket_60_3_3/Bracket_60_3_3_loader.cpp`
- C++ scripts:
  - `src/Bracket_60_3_3/scripts/TempleOfAhnQiraj/temple_of_ahn_qiraj_globalscripts.cpp`

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (2 files)
- `progression_60_3_2_aq20_brood_rep_down.sql` (tables: `creature_onkill_reputation`)
  - 910, 50
- `progression_60_3_3_disables.sql` (tables: `disables`)
  - (no header comment; open the file for details)

## Bracket_61_64

- Config key: `ProgressionSystem.Bracket_61_64`
- Config template notes:
  - Level Range: 61-64 | TBC: Early Game | Outland Introductory Dungeons
  - Content: Hellfire Ramparts, The Blood Furnace, The Shattered Halls (5-man)
  - Features: Fel energy introduction, dark iron enemies, lich king lore begin
  - Release: January 16, 2007
  - Recommended Duration: 1-2 weeks
- Loader: `src/Bracket_61_64/Bracket_61_64_loader.cpp`
- C++ scripts:
  - `src/Bracket_61_64/scripts/misc/tbc_profession_spellcooldowns.cpp`

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (29 files)
- `progression_0_item_loot_template_down.sql` (tables: `item_loot_template`)
  - restore Satchel of Helpful Goods loot (55)
- `progression_0_prospecting_loot_template_thorium_down.sql` (tables: `prospecting_loot_template`)
  - Restore TBC gems from Thorium prospecting
- `progression_1_19_bruisers_vanilla_down.sql` (tables: `creature_template`)
  - (no header comment; open the file for details)
- `progression_1_19_world_event_Winter_Hats_vanilla_down.sql` (tables: `conditions`, `creature_loot_template`)
  - (no header comment; open the file for details)
- `progression_50_59_1_lfg_dungeon_rewards_down_1.sql` (tables: `lfg_dungeon_rewards`)
  - restore the original value (TBC) for the satchel for level 
- `progression_60_1_2_spell_dbc_down.sql` (tables: `spell_dbc`)
  - Revoke change Baron Geddon explosion base damage from 3200 to 2100
- `progression_60_1_2_trash_boe_normalised_down.sql` (tables: `creature_loot_template`)
  - Ancient Core Hound Restore
- `progression_60_2_1_kazzak_down.sql` (tables: `creature`, `creature_addon`, `creature_loot_template`, `creature_template`, `creature_text`, `reference_loot_template`, `spell_script_names`)
  - (no header comment; open the file for details)
- `progression_61_64_attunement_key_recovery.sql` (tables: `conditions`, `creature_template`, `gossip_menu_option`, `smart_scripts`)
  - Alturus
- `progression_61_64_creature_disable_token_vendor.sql` (tables: `creature`)
  - (no header comment; open the file for details)
- `progression_61_64_creature_template_disable_arena_vendors.sql` (tables: `creature_template`)
  - Disable Arena Vendors from Netherstorm
- `progression_61_64_disables.sql` (tables: `disables`)
  - 61-64 level range - The Blood Furnace, Hellfire Ramparts, The Underbog, The Slave Pens, Mana Tombs
- `progression_61_64_disables_quest_BT_attunement.sql` (tables: `disables`)
  - Disable BT attunement quest chain
- `progression_61_64_dungeon_access_requirements_attunements.sql` (tables: `dungeon_access_requirements`)
  - Add attunement requirements for TBC
- `progression_61_64_faction_Netherwing.sql` (tables: `disables`, `gameobject`, `item_template`)
  - Disable quest that unlocks Netherwing (previous chain kept open) and following quests
- `progression_61_64_faction_Ogrila.sql` (tables: `disables`)
  - Disable Ogri'la quests
- `progression_61_64_faction_ShatariSkyguard.sql` (tables: `creature`, `creature_onkill_reputation`, `disables`)
  - Remove onkill reputation gain
- `progression_61_64_gameobject_loot_template_nightmare_seed.sql` (tables: `gameobject_loot_template`)
  - Add Nightmare Seed to Nightmare Vine loot table
- `progression_61_64_gossip_menu_option.sql` (tables: `gossip_menu_option`)
  - Dual spec progression prices
  - 40-49     500G
  - 50-59     600G
  - 60        800G
  - 61-70     900G
  - 71-80     1000G
- `progression_61_64_item_template_revered_heroic_keys.sql` (tables: `item_template`)
  - Set Dungeon Heroic Keys to require Revered with their respective factions
- `progression_61_64_item_template_TBCgems.sql` (tables: `item_template`)
  - Set TBC gems to Unique-Equipped and BoP until last bracket for Heroic gems and 75-79 for PvP gems
- `progression_61_64_item_template_TBCprofs.sql` (tables: `item_template`)
  - Set Primal Nether and Nether Vortex to BoP
- `progression_61_64_item_template_WorldBoss.sql` (tables: `item_template`)
  - Set World Boss loot to BoP until Sunwell
- `progression_61_64_npc_trainer_TBCprofs.sql` (tables: `npc_trainer`)
  - Remove following TBC items from trainers (re-added in Black Temple)
- `progression_61_64_npc_vendor_Geras.sql` (tables: `npc_vendor`)
  - Remove Items from G'eras (Heroic badge vendor)
- `progression_61_64_npc_vendor_PvP.sql` (tables: `creature_template`, `npc_vendor`)
  - Re-add vendor flags to legacy weapons vendor
- `progression_61_64_Phase4_disables.sql` (tables: `disables`)
  - Disable Zul'Aman quests
- `progression_61_64_Phase5_disables.sql` (tables: `creature`, `creature_template`, `disables`, `gameobject`, `pool_quest`)
  - Hide Shattered Sun Offensive NPCs and Vendors near Portal to Isle of Quel'Danas
- `progression_61_64_quest_template_attunement.sql` (tables: `quest_template`)
  - Adds The Tempest Key, and the title Champion of the Naaru to the rewards of Trial of the Naaru: Magtheridon

## Bracket_65_69

- Config key: `ProgressionSystem.Bracket_65_69`
- Config template notes:
  - Level Range: 65-69 | TBC: Mid Game | Mid-Level Outland Dungeons
  - Content: Durnholde Keep, Hellfire Peninsula dungeons, Zangarmarsh dungeons
  - Features: Tier 0.5 pre-raid gear, reputation farming intensifies
  - Release: January 16, 2007
  - Recommended Duration: 1-2 weeks
- Loader: `src/Bracket_65_69/Bracket_65_69_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (5 files)
- `progression_0_npc_vendor_DarkmoonFaire_down_1.sql` (tables: `npc_vendor`)
  - Lhara in Darkmoon Faire, entry: 14846
  - Removes TBC and WotLK items
  - items: (21887, 22572, 22573, 22574, 22575, 22576, 22577, 22578, 22787, 22789, 22790, 22791, 22792, 22793, 22794, 23436, 23437, 23438, 23439, 23440, 23441, 23793, 25707, 25708, 33568, 36901, 36903, 36904, 36905, 36906, 36907, 36908, 37700, 37701, 37702, 37703, 37704, 37705, 37921, 38425, 44128, 46812)
- `progression_60_2_2_spell_dbc_down.sql` (tables: `spell_dbc`)
  - Revoke changes in BWL
- `progression_65_69_creature_onkill_reputation_SethekkHalls.sql` (tables: `creature_onkill_reputation`)
  - Prevents reputation gained from Sethekk Halls to go beyond Honored
- `progression_65_69_disables.sql` (tables: `disables`)
  - 65-69 level range - Sethekk Halls, Auchenai Crypts, The Escape from Durnholde
- `progression_65_69_npc_vendor_PvP.sql` (tables: `npc_vendor`)
  - Added TBC ammunition to Alterac Valley General Goods vendors

## Bracket_70_1_1

- Config key: `ProgressionSystem.Bracket_70_1_1`
- Config template notes:
  - Level 70 | TBC: Early Raid Prep | Normal Dungeons
  - Content: Black Morass, Shattered Halls, Slave Pens, Underbog, Mana Tombs, Auchenai Crypts, Sethekk Halls, Shadow Labyrinth
  - Features: Badge currency introduction, decent pre-raid gear, flying mount availability
  - Release: January 16, 2007
  - Recommended Duration: 2-3 weeks
- Loader: `src/Bracket_70_1_1/Bracket_70_1_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (7 files)
- `progression_0_creature_UngoroCultists_down.sql` (tables: `creature`)
  - Enable the 11 cultists in Un'Goro
- `progression_60_1_2_MC_firelord_runes_down.sql` (tables: `gameobject_template`)
  - MC - Require dusing the runes
- `progression_60_2_2_chromaggus_time_lapse_down.sql` (tables: `spell_script_names`)
  - (no header comment; open the file for details)
- `progression_65_69_creature_onkill_reputation_SethekkHalls_down.sql` (tables: `creature_onkill_reputation`)
  - Restore reputation gained from Sethekk Halls to go beyond Honored
- `progression_70_1_1_brewfest.sql` (tables: `creature_template`)
  - (no header comment; open the file for details)
- `progression_70_1_1_disables.sql` (tables: `disables`)
  - 70 level range - Level 70 Normals - Opening the Dark Portal, The Shattered Halls, The Steamvault, The Arcatraz, The Botanica, The Mechanar, Shadow Labyrinth
- `progression_70_1_1_pvp_dailies.sql` (tables: `disables`, `quest_template`)
  - (no header comment; open the file for details)

## Bracket_70_1_2

- Config key: `ProgressionSystem.Bracket_70_1_2`
- Config template notes:
  - Level 70 | TBC: Raid Prep | Heroic Dungeons
  - Content: All level 70 dungeons in Heroic difficulty (increased mechanics)
  - Features: Badges of Valor for epic gear, attunement requirements, first DPS checks
  - Release: January 16, 2007
  - Recommended Duration: 2-3 weeks
- Loader: `src/Bracket_70_1_2/Bracket_70_1_2_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (3 files)
- `progression_0_creature_KarazhanNPCs_down.sql` (tables: `creature`)
  - Show Karazhan NPCs
- `progression_61_64_npc_vendor_Geras_down_1.sql` (tables: `npc_vendor`)
  - Restore Items from G'eras (Heroic badge vendor)
- `progression_70_1_2_disables.sql` (tables: `disables`)
  - 70 level range - Level 70 Heroics - The Shattered Halls, The Steamvault, The Arcatraz, The Botanica, The Mechanar, Shadow Labyrinth

## Bracket_70_2_1

- Config key: `ProgressionSystem.Bracket_70_2_1`
- Config template notes:
  - Level 70 | TBC: Raid Tier 1 | Gruul's Lair & Magtheridon's Lair + Arena Season 1
  - Raids: Gruul's Lair (25-man, 2 bosses) + Magtheridon's Lair (25-man, 1 boss)
  - Bosses: Gruul, High King Maulgar (Gruul's), Magtheridon (Magtheridon's)
  - Features: First TBC raid experience, world event coordination, T4 epic gear, Arena PvP begins
  - Release: January 16, 2007
  - Recommended Duration: 4-6 weeks
- Loader: `src/Bracket_70_2_1/Bracket_70_2_1_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (6 files)
- `progression_0_creature_loot_template_Badge_of_Justice_Phase1.sql` (tables: `creature_loot_template`)
  - Remove Badge of Justice from Phase 1 Raids
- `progression_0_creature_WorldBosses_down_3.sql` (tables: `creature`)
  - Reveal TBC World Bosses
- `progression_61_64_creature_disable_token_vendor_down_1.sql` (tables: `creature`)
  - (no header comment; open the file for details)
- `progression_61_64_creature_template_disable_arena_vendors_down.sql` (tables: `creature_template`)
  - Disable Arena Vendors from Netherstorm
- `progression_70_2_1_disables.sql` (tables: `disables`)
  - TBC Phase 1 - Gruul's Lair and Magtheridon's Lair
- `vendors_cleanup_s1.sql` (tables: (unknown))
  - STUB / PRODUCTION:
  - This file is intentionally left without executable SQL.
  - Reason: it was a TEMPLATE with placeholders ([...]) and it broke autoloading.
  - Real template: ../templates/arena_s1_vendors_cleanup.sql.template

## Bracket_70_2_2

- Config key: `ProgressionSystem.Bracket_70_2_2`
- Config template notes:
  - Level 70 | TBC: Raid Tier 1 (10-man) | Karazhan + Arena Season 2
  - Raid: Karazhan (10-man, 11 encounters)
  - Bosses: Attumen, Moroes, Maiden of Virtue, Opera, Shade of Aran, Illhoof, Chess Event, Prince Malchezaar
  - Features: 10-man format accessibility, Medivh lore, attunement requirement, tower progression
  - Release: January 16, 2007
  - Recommended Duration: 4-6 weeks (can overlap with Gruul/Mag)
- Loader: `src/Bracket_70_2_2/Bracket_70_2_2_loader.cpp`
- C++ scripts:
  - `src/Bracket_70_2_2/scripts/Karazhan/instance_karazhan.cpp`

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (5 files)
- `progression_0_creature_loot_template.sql` (tables: `creature_template`, `gameobject_loot_template`)
  - Philanthropist should drop gold
- `progression_0_creature_loot_template_kara_enchants.sql` (tables: `creature_loot_template`)
  - (no header comment; open the file for details)
- `progression_0_item_template_blackened_urn.sql` (tables: `item_template`, `quest_template`, `quest_template_addon`)
  - make blackened urn unsellable and give as reward
- `progression_70_2_2_disables.sql` (tables: `disables`)
  - TBC Phase 1 - Karazhan
- `vendors_cleanup_s2.sql` (tables: (unknown))
  - STUB / PRODUCTION:
  - This file is intentionally left without executable SQL.
  - Reason: it was a TEMPLATE with placeholders ([...]) and it broke autoloading.
  - Real template: ../templates/arena_s2_vendors_cleanup.sql.template

## Bracket_70_2_3

- Config key: `ProgressionSystem.Bracket_70_2_3`
- Config template notes:
  - Level 70 | TBC: World Content | Ogri'la Dailies (Blade's Edge Mountains)
  - Content: Ogri'la daily quests, Skyguard reputation farming, world boss phases
  - NOTE: World content only - NOT a raid tier. Should consolidate with Bracket_70_6_1
  - Release: March 19, 2008
  - Recommended Duration: 2-3 weeks (world content, continuous)
- Loader: `src/Bracket_70_2_3/Bracket_70_2_3_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (2 files)
- `progression_61_64_faction_Ogrila_down.sql` (tables: `disables`)
  - Restore Ogri'la quests
- `progression_70_2_3_DEPRECATED.sql` (tables: (unknown))
  - DEPRECATED: This bracket should be reorganized
  - NOTE: Ogri'la world quests and daily content should be in Bracket_70_6_1
  - This is a placeholder to document the current state
  - Ogri'la World Content (Island Content)
  - Blades of the Fallen Prince quests
  - Ogre daily quests
  - This content is WORLD CONTENT, not a raid tier
  - It should be grouped with Isle of Quel'Danas content in Bracket_70_6_1
  - If you have Ogri'la content here:
  - 1. Back up this file
  - 2. Move quest_template entries to Bracket_70_6_1
  - 3. Move NPC vendor entries to Bracket_70_6_1
  - 4. Delete this bracket or repurpose it
  - Example of content that might be here:
  - - Quest: "Bladespire Clan Feud" chain
  - - Repeatable: "Kill Gronn Ogres"
  - - Quest: "Haleskor the Deathless"
  - For now, this bracket is documented as WORLD CONTENT PLACEHOLDER
  - Proper configuration depends on which Ogri'la quests are actually installed
  - Update: This should be reorganized into Bracket_70_6_1 (Isle of Quel'Danas)
  - as per Blizzard's original content release schedule

## Bracket_70_3_1

- Config key: `ProgressionSystem.Bracket_70_3_1`
- Config template notes:
  - Level 70 | TBC: Raid Tier 2 | Serpentshrine Cavern (25-man)
  - Raid: Serpentshrine Cavern (25-man, 6 bosses)
  - Bosses: Hydross the Unstable, The Lurker Below, Leotheras the Blind, Fathom-Lord Karathress, Morogrim Tidewalker, Lady Vashj
  - Features: Water resistance mechanics, Vashj encounters, T5 epic gear, attunement required
  - Release: May 15, 2007
  - Recommended Duration: 5-7 weeks
- Loader: `src/Bracket_70_3_1/Bracket_70_3_1_loader.cpp`
- C++ scripts:
  - `src/Bracket_70_3_1/scripts/SerpentshrineCavern/serpentshrine_cavern.cpp`

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (9 files)
- `progression_61_64_creature_disable_token_vendor_down_2.sql` (tables: `creature`)
  - (no header comment; open the file for details)
- `progression_61_64_disables_quest_BT_attunement_down.sql` (tables: `disables`)
  - Enable BT attunement quest chain
- `progression_61_64_dungeon_access_requirements_attunements_down1.sql` (tables: `dungeon_access_requirements`)
  - Remove attunement requirements for dungeons and Karazhan
- `progression_61_64_item_template_revered_heroic_keys_down.sql` (tables: `item_template`)
  - Restore Dungeon Heroic Keys to require Honored with their respective factions
- `progression_61_64_npc_trainer_TBCprofs_down_1.sql` (tables: `npc_trainer`)
  - Restore following TBC items from trainers (re-added in Black Temple)
- `progression_70_3_1_disables.sql` (tables: `disables`)
  - TBC Phase 2 - Serpentshrine Cavern
- `progression_70_3_1_loot_t5.sql` (tables: `creature_loot_template`)
- `progression_70_3_1_smart_scripts_ssc.sql` (tables: `creature_template`, `smart_scripts`)
- `progression_70_3_1_unnerf_t4_loot.sql` (tables: `creature_loot_template`)
  - (no header comment; open the file for details)

## Bracket_70_3_2

- Config key: `ProgressionSystem.Bracket_70_3_2`
- Config template notes:
  - Level 70 | TBC: Raid Tier 2 | The Eye (25-man) + Sha'tari Skyguard (World Content)
  - Raid: The Eye (25-man, 4 bosses) - Tempest Keep floating fortress
  - Bosses: Al'ar (Phoenix), Void Reaver, Solarian, Kael'thas Sunstrider
  - Features: Arcane encounters, magical themes, T5 epic gear, flight requirements
  - Release: May 15, 2007
  - Recommended Duration: 5-7 weeks (can overlap with SSC)
- Loader: `src/Bracket_70_3_2/Bracket_70_3_2_loader.cpp`
- C++ scripts:
  - `src/Bracket_70_3_2/scripts/the_eye.cpp`

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (3 files)
- `progression_61_64_dungeon_access_requirements_attunements_down_2a.sql` (tables: `dungeon_access_requirements`)
  - Remove attunement requirement for SSC
- `progression_61_64_faction_ShatariSkyguard_down.sql` (tables: `creature`, `creature_onkill_reputation`, `disables`)
  - Restore onkill reputation gain
- `progression_70_3_2_disables.sql` (tables: `disables`)
  - TBC Phase 2 - The Eye

## Bracket_70_4_1

- Config key: `ProgressionSystem.Bracket_70_4_1`
- Config template notes:
  - Level 70 | TBC: Raid Tier 3 | Battle For Mount Hyjal (25-man) + Arena Season 2 + Netherwing
  - Raid: Battle For Mount Hyjal (25-man, 5 bosses)
  - Bosses: Rage Winterchill, Anetheron, Kaz'rogal, Azgalor, Archimonde (final)
  - Features: Night Elf defense lore, demon encounters, outdoor raid setting, T6 epic gear, Arena Season 2
  - Release: August 24, 2007
  - Recommended Duration: 5-7 weeks
- Loader: `src/Bracket_70_4_1/Bracket_70_4_1_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (8 files)
- `progression_0_creature_loot_template_Badge_of_Justice_Phase1_down.sql` (tables: `creature_loot_template`)
  - Restore Badge of Justice from Phase 1 Raids
- `progression_61_64_creature_disable_token_vendor_down_3.sql` (tables: `creature`)
  - (no header comment; open the file for details)
- `progression_61_64_dungeon_access_requirements_attunements_down_2b.sql` (tables: `dungeon_access_requirements`)
  - Remove attunement requirement for The Eye
- `progression_61_64_faction_Netherwing_down.sql` (tables: `disables`, `gameobject`, `item_template`)
  - Restore quest that unlocks Netherwing (previous chain kept open) and following quests
- `progression_61_64_quest_template_attunement_down.sql` (tables: `quest_template`)
  - Remove The Tempest Key from the rewards of Trial of the Naaru: Magtheridon
- `progression_70_4_1_coren_trinkets.sql` (tables: `creature_loot_template`, `creature_template`)
  - TBC Phase 3 - Battle for Mount Hyjal
- `progression_70_4_1_disables.sql` (tables: `disables`)
  - TBC Phase 3 - Battle for Mount Hyjal
- `progression_70_4_1_headless_horseman_loot.sql` (tables: `creature_loot_template`, `creature_template`)
  - (no header comment; open the file for details)

## Bracket_70_4_2

- Config key: `ProgressionSystem.Bracket_70_4_2`
- Config template notes:
  - Level 70 | TBC: Raid Tier 4 | Black Temple (25-man)
  - Raid: Black Temple (25-man, 9 bosses)
  - Bosses: High Warlord Naj'entus, Supremus, Shade of Akama, Teron Gorefiend, Gurtogg Bloodboil, Reliquary of Souls, Mother Shahraz, Illidari Council, Illidan Stormrage (final)
  - Features: Illidan encounter, highest difficulty, T6 epic gear, world-class coordination, Illidan mount
  - Release: September 24, 2007
  - Recommended Duration: 6-8 weeks
- Loader: `src/Bracket_70_4_2/Bracket_70_4_2_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (1 files)
- `progression_70_4_2_disables.sql` (tables: `disables`)
  - TBC Phase 3 - Black Temple

## Bracket_70_5

- Config key: `ProgressionSystem.Bracket_70_5`
- Config template notes:
  - Level 70 | TBC: Raid Tier 2.5 (10-man) | Zul'Aman + Arena Season 3
  - Raid: Zul'Aman (10-man, 6 bosses)
  - Bosses: Nalorakk, Akil'zon, Jan'alai, Halazzi, Hex Lord Malacrass, Zul'jin
  - Features: Troll aesthetic, spirit animal encounters, T5 gear equivalency, 10-man format, Arena Season 3
  - Release: December 11, 2007
  - Recommended Duration: 4-6 weeks (10-man alternative)
- Loader: `src/Bracket_70_5/Bracket_70_5_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (6 files)
- `progression_61_64_dungeon_access_requirements_attunements_down_3.sql` (tables: `dungeon_access_requirements`)
  - Remove all attunement requirements
- `progression_61_64_npc_vendor_Geras_down_2.sql` (tables: `npc_vendor`)
  - Restore All Items from G'eras (Heroic badge vendor)
- `progression_61_64_Phase4_disables_down.sql` (tables: `disables`)
  - Restore Zul'Aman quests
- `progression_70_5_amani_war_bear_loot.sql` (tables: `conditions`, `gameobject_loot_template`, `reference_loot_template`)
  - (no header comment; open the file for details)
- `progression_70_5_disables.sql` (tables: `disables`)
  - TBC Phase 4 - Zul'Aman
- `vendors_cleanup_s3.sql` (tables: (unknown))
  - STUB / PRODUCTION:
  - This file is intentionally left without executable SQL.
  - Reason: it was a TEMPLATE with placeholders ([...]) and it broke autoloading.
  - Real template: ../templates/arena_s3_vendors_cleanup.sql.template

## Bracket_70_6_1

- Config key: `ProgressionSystem.Bracket_70_6_1`
- Config template notes:
  - Level 70 | TBC: World Content | Isle of Quel'Danas (Shattered Sun Island)
  - Content: Magisters' Terrace (5-man & Heroic), daily quests, world bosses, island exploration
  - Features: New flying zones, world boss hunting, Shattered Sun Offensive reputation, zone events
  - Release: May 22, 2008
  - Recommended Duration: 2-3 weeks (world content, overlaps with raids)
- Loader: `src/Bracket_70_6_1/Bracket_70_6_1_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (8 files)
- `progression_61_64_attunement_key_recovery_down.sql` (tables: `conditions`, `creature_template`, `gossip_menu_option`, `smart_scripts`)
  - Alturus
- `progression_61_64_item_template_TBCgems_down_1.sql` (tables: `item_template`)
  - Remove Unique-Equipped from Epic gems acquired from Heroic Dungeons
- `progression_61_64_item_template_TBCprofs_down.sql` (tables: `item_template`)
  - Remove BoP from Primal Nether and Nether Vortex
- `progression_61_64_item_template_WorldBoss_down.sql` (tables: `item_template`)
  - Set World Boss loot to BoP until Sunwell
- `progression_61_64_npc_trainer_TBCprofs_down_2.sql` (tables: `npc_trainer`)
  - Restore Brilliant Glass for Sunwell
- `progression_61_64_Phase5_disables_down.sql` (tables: `creature`, `creature_template`, `disables`, `gameobject`, `pool_quest`)
  - Restore Shattered Sun Offensive NPCs and Vendors near Portal to Isle of Quel'Danas
- `progression_70_3_1_loot_t5_down.sql` (tables: `creature_loot_template`)
- `progression_70_6_1_disables.sql` (tables: `disables`)
  - TBC Phase 5 - Magister's Terrace and Isle of Quel'Danas

## Bracket_70_6_2

- Config key: `ProgressionSystem.Bracket_70_6_2`
- Config template notes:
  - Level 70 | TBC: Raid Tier 5 (Final) | Sunwell Plateau (25-man) + Arena Season 4
  - Raid: Sunwell Plateau (25-man, 6 bosses)
  - Bosses: Kalecgos, Brutallus, Felmyst, Erediss, Muru, Kil'jaeden (final - optional)
  - Features: Highest damage output encounters, T6 final epic gear, PvP Season 4, world-class coordination, Illidan mount
  - Release: May 22, 2008 (Raid), March 25, 2008 (Arena Season 4)
  - Recommended Duration: 8-12 weeks (final raid tier, longest phase)
- Loader: `src/Bracket_70_6_2/Bracket_70_6_2_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (3 files)
- `progression_70_6_2_deathknight_S4.sql` (tables: `npc_vendor`)
  - (no header comment; open the file for details)
- `progression_70_6_2_disables.sql` (tables: `disables`)
  - TBC Phase 5 - Sunwell Plateau
- `vendors_cleanup_s4.sql` (tables: (unknown))
  - STUB / PRODUCTION:
  - This file is intentionally left without executable SQL.
  - Reason: it was a TEMPLATE with placeholders ([...]) and it broke autoloading.
  - Real template: ../templates/arena_s4_vendors_cleanup.sql.template

## Bracket_70_6_3

- Config key: `ProgressionSystem.Bracket_70_6_3`
- Config template notes:
  - Level 70 | TBC: Final Phase | World Events & Expansion Transition
  - Content: Dragons of Nightmare world events, world boss rotations, season finale activities
  - Features: World event participation, expansion transition quests, final TBC achievements
  - Release: August 19, 2008
  - Recommended Duration: 3-4 weeks (transition to WotLK)
- Loader: `src/Bracket_70_6_3/Bracket_70_6_3_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (1 files)
- `progression_0_npc_trainer_flying_down.sql` (tables: `cost`, `npc_trainer`)
  - Update cost for normal flying back to original value

## Bracket_71_74

- Config key: `ProgressionSystem.Bracket_71_74`
- Config template notes:
  - Level Range: 71-74 | WotLK: Early Northrend | Leveling Dungeons (Normal)
  - Content (Normal dungeons):
  - - Utgarde Keep
  - - The Nexus
  - - Azjol-Nerub
  - - Ahn'kahet: The Old Kingdom
  - Features:
  - - IntroducciÃ³n a Northrend: pulls mÃ¡s grandes, primeros â€œstuns/cleavesâ€ serios.
  - - Equipo azul/verdes de leveleo, reputaciones base (ej. Wyrmrest / Kirin Tor / etc.).
  - Release (Patch): 3.0.x (WotLK launch era)
  - Recommended Duration: 1-2 weeks
- Loader: `src/Bracket_71_74/Bracket_71_74_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (16 files)
- `progression_0_creature_Gangrenous_down.sql` (tables: `creature`)
  - Reveal Gangrenus which is accesible from exploits
- `progression_1_19_bruisers_tbc_down.sql` (tables: `creature_template`)
  - (no header comment; open the file for details)
- `progression_1_19_world_event_Winter_Hats_tbc_down.sql` (tables: `conditions`, `creature_loot_template`)
  - (no header comment; open the file for details)
- `progression_50_59_1_lfg_dungeon_rewards_down_2.sql` (tables: `lfg_dungeon_rewards`)
  - WotLK
- `progression_61_64_gameobject_loot_template_nightmare_seed_down.sql` (tables: `gameobject_loot_template`)
  - Remove Nightmare Seed from Nightmare Vine loot table (removed in Patch 3.0.2)
- `progression_70_1_1_pvp_dailies_down.sql` (tables: `quest_template`)
  - (no header comment; open the file for details)
- `progression_70_3_1_smart_scripts_ssc_down.sql` (tables: `creature_template`, `smart_scripts`)
- `progression_70_5_amani_war_bear_loot_down.sql` (tables: `conditions`, `gameobject_loot_template`, `reference_loot_template`)
  - (no header comment; open the file for details)
- `progression_71_74_creature_loot_template_kara_enchants_100.sql` (tables: `creature_loot_template`)
  - (no header comment; open the file for details)
- `progression_71_74_creature_template.sql` (tables: `creature_template`)
  - restore NPC vendor of Arena Season 4 in BRD (Grim Guzzler)
- `progression_71_74_disables.sql` (tables: `disables`)
  - 71-74 level range - Utgarde Keep, The Nexus, Drakâ€™Tharon Keep, Azjol-Nerub, Ahnâ€™kahet: The Old Kingdom
  - IMPORTANT (WotLK baseline lock):
  - This module's first WotLK bracket is 71_74.
  - However, some progression setups choose to "start WotLK" later (e.g. enabling 75_79 first).
  - For that reason, the same baseline lock is also inserted in later WotLK brackets (75_79 and 80_*).
  - We must ensure future 80 content is locked from the start of Northrend.
  - Some servers/world DBs do not have baseline `disables` rows inserted for ICC/ToC/RS/Onyxia80.
  - If these rows do not exist, the instances can be accessible earlier than intended.
  - NOTE: "locked/blocked" here means "access denied" via `world.disables`.
  - It does NOT delete any instance content from the DB; players will simply be prevented from entering.
  - Locks applied here:
  - - WotLK launch raids (deny-by-default): 533, 615, 616
  - - Ulduar + Vault of Archavon (deny-by-default): 603, 624
  - - ICC raid + ICC 5-mans: 631, 632, 658, 668
  - - ToC raid + ToC 5-man: 649, 650
  - - Onyxia (reworked): 249
  - - Ruby Sanctum: 724
- `progression_71_74_flight_master.sql` (tables: `mail_level_reward`)
  - Reenable flight trainer mails
- `progression_71_74_gossip_menu_option.sql` (tables: `gossip_menu_option`)
  - Dual spec progression prices
  - 40-49     500G
  - 50-59     600G
  - 60        800G
  - 61-70     900G
  - 71-80     1000G
- `progression_71_74_npc_vendor.sql` (tables: `npc_vendor`)
  - Lhara in Darkmoon Faire, entry: 14846
  - Restores WotLK items sold by Lhara in Darkmoon Faire
  - items: (33568, 36901, 36903, 36904, 36905, 36906, 36907, 36908, 37700, 37701, 37702, 37703, 37704, 37705, 37921, 38425, 44128, 46812)
- `progression_71_74_npc_vendor_PvP.sql` (tables: `npc_vendor`)
  - Restore PvP Accessory vendor to WotLK values
- `progression_71_74_wintergrasp_vendors_blockall.sql` (tables: `mod_progression_wg_vendor_backup`, `tmp_wg_vendor_entries`)
  - progression_71_74_wintergrasp_vendors_blockall.sql
  - Purpose:
  - Bracket 71-74 must keep Wintergrasp PvP vendor inventories BLOCKED.
  - Later brackets (80_*) will restore items progressively from the backup table.

## Bracket_75_79

- Config key: `ProgressionSystem.Bracket_75_79`
- Config template notes:
  - Level Range: 75-79 | WotLK: Mid Northrend | Leveling Dungeons (Normal)
  - Content (Normal dungeons):
  - - Drak'Tharon Keep
  - - Gundrak
  - - Violet Hold
  - - Halls of Stone
  - - Halls of Lightning
  - - The Oculus
  - - The Culling of Stratholme
  - - Utgarde Pinnacle (se suele hacer 78-80)
  - Features:
  - - Ãšltimo tramo de leveleo, upgrades constantes de iLvl.
  - - PreparaciÃ³n para 80: mecÃ¡nicas mÃ¡s â€œWotLKâ€ (vehÃ­culos en Oculus, waves en Violet Hold, etc.).
  - IMPORTANT:
  - - NO incluir Forge of Souls / Pit of Saron / Halls of Reflection acÃ¡ (son ICC-era, lvl 80, patch 3.3).
  - Release (Patch): 3.0.x (WotLK launch era)
  - Recommended Duration: 1-2 weeks
- Loader: `src/Bracket_75_79/Bracket_75_79_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (5 files)
- `progression_0_npc_vendor_DarkmoonFaire_down_2.sql` (tables: `npc_vendor`)
  - Lhara in Darkmoon Faire, entry: 14846
  - Removes TBC and WotLK items
  - items: (21887, 22572, 22573, 22574, 22575, 22576, 22577, 22578, 22787, 22789, 22790, 22791, 22792, 22793, 22794, 23436, 23437, 23438, 23439, 23440, 23441, 23793, 25707, 25708, 33568, 36901, 36903, 36904, 36905, 36906, 36907, 36908, 37700, 37701, 37702, 37703, 37704, 37705, 37921, 38425, 44128, 46812)
- `progression_61_64_item_template_TBCgems_down_2.sql` (tables: `item_template`)
  - Remove Unique-Equipped from TBC PvP gems and remove BoP from Honor gems
- `progression_75_79_disables.sql` (tables: `disables`)
  - 75-79 level range - Utgarde Pinnacle, The Oculus, The Culling of Stratholme, Halls of Stone, Halls of Lightning, Gundrak, Violet Hold
  - WotLK baseline lock (deny-by-default): ensure future 80 content is blocked even if earlier WotLK brackets were skipped.
  - This is safe because later brackets explicitly DELETE from `disables` to unlock what they need.
- `progression_75_79_npc_vendor_PvP.sql` (tables: `npc_vendor`)
  - Added WOTLK ammunition to Alterac Valley General Goods vendors
- `progression_75_79_wintergrasp_vendors_blockall.sql` (tables: `mod_progression_wg_vendor_backup`, `tmp_wg_vendor_entries`)
  - progression_75_79_wintergrasp_vendors_blockall.sql
  - Purpose:
  - Bracket 75-79 must keep Wintergrasp PvP vendor inventories BLOCKED.
  - Later brackets (80_*) will restore items progressively from the backup table.

## Bracket_80_1_1

- Config key: `ProgressionSystem.Bracket_80_1_1`
- Config template notes:
  - Level 80 | WotLK: Pre-Raid | Normal Dungeons (Launch set)
  - Content:
  - - Todas las dungeons normales de Northrend a nivel 80 (Utgarde Pinnacle, Oculus, CoS, HoL/HoS, Gundrak, Violet Hold, etc.).
  - Features:
  - - "Primer set" a 80: completar reputaciones, terminar quests de zonas, empezar a armar equipo inicial.
  - - PreparaciÃ³n para entrar a heroicas (gemas/enchants bÃ¡sicos).
  - Release (Patch): 3.0.x
  - Recommended Duration: 1-2 weeks
- Loader: `src/Bracket_80_1_1/Bracket_80_1_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (23 files)
- `progression_1_19_brewfest_down.sql` (tables: `creature`, `creature_template`, `game_event_creature`, `item_loot_template`)
  - (no header comment; open the file for details)
- `progression_1_19_hallows_end_down.sql` (tables: `creature_template`, `item_loot_template`, `quest_template`)
  - (no header comment; open the file for details)
- `progression_1_19_love_in_air_down.sql` (tables: `conditions`, `creature`, `creature_loot_template`, `creature_template`, `item_loot_template`, `item_template`)
  - (no header comment; open the file for details)
- `progression_1_19_world_event_Ahune_down.sql` (tables: `creature_template`, `gameobject_loot_template`, `item_template`, `quest_template`)
  - Revert Ahune loot to WotLK-Era
- `progression_60_2_1_onyxia_down.sql` (tables: `achievement_criteria_data`, `conditions`, `creature_loot_template`, `creature_questender`, `creature_queststarter`, `creature_template`, `disables`, `dungeon_access_requirements`, `dungeon_access_template`, `gossip_menu`, `gossip_menu_option`, `item_template`, `mapdifficulty_dbc`, `npc_text`, `quest_template_addon`, `reference_loot_template`, `spell_linked_spell`)
  - Onyxia
- `progression_60_2_2_nefarian_loot_down.sql` (tables: `creature_loot_template`, `reference_loot_template`)
  - Nefarian
- `progression_60_2_the_masquerade_down.sql` (tables: `conditions`, `creature`, `creature_questender`, `creature_queststarter`, `creature_template`, `creature_text`, `disables`, `gossip_menu`, `gossip_menu_option`, `item_template`, `quest_template`, `script_waypoint`, `smart_scripts`)
  - (no header comment; open the file for details)
- `progression_61_64_quest_template_hand_of_adal_down.sql` (tables: `quest_template`)
  - Remove Hand of A'dal Title reward for completing BT attunement
- `progression_70_3_1_loot_t5_down_two.sql` (tables: `creature_loot_template`)
- `progression_80_1_1_npc_vendor.sql` (tables: (unknown))
  - (no header comment; open the file for details)
- `progression_80_1_creature_template.sql` (tables: `creature_template`)
  - restore npc vendors of arena season 7, use this only for the last arena season
  - https://github.com/azerothcore/progression-system/issues/18
- `progression_80_1_disables.sql` (tables: `creature_template`, `disables`)
  - WotLK baseline lock (deny-by-default): ensure future 80 content is blocked even if earlier WotLK brackets were skipped.
  - This is safe because later brackets explicitly DELETE from `disables` to unlock what they need.
- `progression_80_1_dungeon_access_template.sql` (tables: `dungeon_access_template`)
  - (no header comment; open the file for details)
- `progression_80_1_epic_gems.sql` (tables: `disables`, `item_instance`, `npc_vendor`)
  - (no header comment; open the file for details)
- `progression_80_1_frozo_the_renowned.sql` (tables: `creature`)
  - Removes frozo's items
- `progression_80_1_item_template_blackened_urn.sql` (tables: `item_template`, `quest_template`, `quest_template_addon`)
  - revert kara blackened urn
- `progression_80_1_kirin_tor_rings.sql` (tables: `npc_vendor`)
  - (no header comment; open the file for details)
- `progression_80_1_lfg_rewards.sql` (tables: `lfg_dungeon_rewards`)
  - Reset WotLK LFG reward quest IDs
  - Note:
  - - This only assigns which quests are used by random heroic.
  - - The emblem item/amount is controlled by `quest_template`.
- `progression_80_1_npcs.sql` (tables: `creature`)
  - (no header comment; open the file for details)
- `progression_80_1_rdf_quests.sql` (tables: `quest_template`)
  - (no header comment; open the file for details)
- `progression_80_1_t7_orb_of_naxxramas.sql` (tables: `gameobject`)
  - Hide gameobjects
- `progression_80_1_warbear_down.sql` (tables: `conditions`, `gameobject_loot_template`, `reference_loot_template`)
  - (no header comment; open the file for details)
- `progression_80_1_weekly_raid_quests.sql` (tables: `quest_template`)
  - ProgressionSystem - weekly raid quests emblem reward (Bracket_80_1_1)
  - Goal:
  - Normalize weekly raid quest emblem rewards to match this bracket's progression.
  - Weekly raid quest IDs (Archmage Lan'dalock):
  - 24579 Sartharion Must Die!
  - 24580 Anub'Rekhan Must Die!
  - 24581 Noth the Plaguebringer Must Die!
  - 24582 Instructor Razuvious Must Die!
  - 24583 Patchwerk Must Die!
  - 24584 Malygos Must Die!
  - 24585 Flame Leviathan Must Die!
  - 24586 Razorscale Must Die!
  - 24587 Ignis the Furnace Master Must Die!
  - 24588 XT-002 Deconstructor Must Die!
  - 24589 Lord Jaraxxus Must Die!
  - 24590 Lord Marrowgar Must Die!
  - Emblem item IDs (WotLK):
  - Heroism  40752
  - Valor    40753
  - Conquest 45624
  - Triumph  47241
  - Frost    49426
  - MySQL: 8.x compatible.

## Bracket_80_1_2

- Config key: `ProgressionSystem.Bracket_80_1_2`
- Config template notes:
  - Level 80 | WotLK: Pre-Raid | Heroic Dungeons (Launch set) + Arena Season 5
  - Content:
  - - Todas las dungeons de Northrend en Heroic (set original de salida).
  - - PvP: Arena Season 5 (Deadly era)
  - Features:
  - - Empieza el â€œfarmâ€ fuerte de equipo pre-raid (heroicas), badges/emblemas segÃºn tu sistema.
  - - Primera etapa real de gear-check (tanks/heals ya importan).
  - Release (Patch): 3.0.x (heroics de salida) + S5 dentro de la era temprana de WotLK
  - Recommended Duration: 2-3 weeks
- Loader: `src/Bracket_80_1_2/Bracket_80_1_2_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (13 files)
- `80_1_2_emblems_heroic_bosses.sql` (tables: `creature_loot_template`, `IF`, `tmp_heroic_bosses`, `tmp_lootids_fix`, `tmp_maps`)
  - ============================================================================
  - WotLK Bracket 80_1_2 - HEROIC 5-man BOSSES emblem normalization
  - MySQL 8.x | AzerothCore WotLK 3.3.5
  - GOAL:
  - Ensure HEROIC dungeon BOSSES (5-man) drop the emblem for this bracket.
  - IMPORTANT RULES (per spec):
  - - Touch ONLY HEROIC bosses using creature_template.difficulty_entry_1 mapping.
  - - Never modify normal-mode loot.
  - - Loot entry to touch: IF(cth.lootid = 0, cth.entry, cth.lootid)
  - - Limit by MAP IDs for this bracket.
  - - Modify ONLY emblem rows (items in the emblem set).
  - PARTS (in order):
  - A) REPORT  B) BACKUP  C) APPLY  D) VERIFY
  - GM reload note (best effort):
  - If your core supports it: .reload creature_loot_template
  - Otherwise restart worldserver (safest).
  - ============================================================================
  - -------------------------
  - Bracket configuration
  - -------------------------
- `80_1_2_emblems_heroic_bosses_rollback.sql` (tables: `creature_loot_template`, `tmp_restore_keys`)
  - ============================================================================
  - ROLLBACK - WotLK Bracket 80_1_2 - HEROIC 5-man BOSSES emblem normalization
  - Restores rows from backup_80_1_2_emblems_heroic_bosses
  - ============================================================================
- `progression_80_1_2_disables.sql` (tables: `disables`)
  - Enable heroic dungeons
  - WotLK baseline lock (deny-by-default): ensure future 80 content is blocked even if earlier WotLK brackets were skipped.
  - This is safe because later brackets explicitly DELETE from `disables` to unlock what they need.
- `progression_80_1_2_emblem_exchange_vendor_35790.sql` (tables: `item_template`, `mod_progression_backup_npc_vendor_35790`, `npc_vendor`)
  - Emblem exchange helper (Usuri Brightcoin - 35790)
  - Bracket: 80_1_2 (WotLK launch heroics)
  - Goal:
  - Provide a SAFE down-conversion to the bracket's heroic emblem, to mitigate DB mistakes where
  - a heroic boss drops a higher emblem than intended.
  - Rules:
  - - Only allow HIGHER => CURRENT conversions (never lower => higher).
  - - This script ONLY changes npc_vendor (it does not change boss loot tables).
  - Emblems (WotLK):
  - Heroism  40752
  - Valor    40753
  - Conquest 45624
  - Triumph  47241
  - Frost    49426
  - ExtendedCost IDs (AzerothCore WotLK 3.3.5a / item_extended_cost.dbc):
  - 2589 => pay 1x Valor (40753)
  - 2637 => pay 1x Conquest (45624)
  - 2707 => pay 1x Triumph (47241)
  - 2743 => pay 1x Frost (49426)
  - Backup vendor inventory (first run only)
- `progression_80_1_2_emblems.sql` (tables: `creature_loot_template`, `gameobject_loot_template`, `reference_loot_template`)
  - WotLK early-era emblem fix (Bracket 80_1_2):
  - - Heroic 5-man dungeon BOSSES should drop Emblem of Heroism (40752).
  - - This is intentionally scoped to 5-man instance boss creatures to avoid touching raid loot.
  - Emblem item IDs (WotLK):
  - Heroism 40752
  - Valor   40753
  - Conquest 45624
  - Triumph 47241
  - Scope (server-defined): ONLY level-80 5-man dungeon heroic maps
  - Launch set (no ToC / no Frozen Halls):
  - 574,575,576,578,595,599,600,601,602,604,608,619
- `progression_80_1_2_heroic_gs.sql` (tables: `enabled`, `mod_progression_heroic_gs`, `required_heroic`)
  - ProgressionSystem - Heroic avg item level gate (Bracket 80_1_2)
  - Required (avg iLvl): 175
- `progression_80_1_2_lfg_rewards.sql` (tables: `lfg_dungeon_rewards`)
  - Reset WotLK LFG reward quest IDs (Bracket 80_1_2)
  - Note:
  - - This only assigns which quests are used by random heroic.
  - - The emblem item/amount is controlled by `quest_template` and is set per bracket
  - in `progression_80_1_2_rdf_quests.sql`.
- `progression_80_1_2_pvp_vendors.sql` (tables: `creature`, `game_event_creature`)
  - (no header comment; open the file for details)
- `progression_80_1_2_rdf_quests.sql` (tables: `quest_template`)
  - ProgressionSystem - dungeon dailies & RDF rewards (Bracket_80_1_2)
  - SERVER SOURCE OF TRUTH (pre-raid T7):
  - - Heroic 5-man bosses: Heroism (40752) [handled in progression_80_1_2_emblems.sql]
  - - Daily normal ("Timear Foresees..."): Heroism (40752) x2
  - - Daily heroic ("Proof of Demise..."): Valor (40753) x2
  - - RDF (if enabled): keep Heroism (40752)
  - Emblem IDs:
  - Heroism   40752
  - Valor     40753
  - Conquest  45624
  - Triumph   47241
  - Frost     49426
  - RDF / Random dungeon (common AzerothCore WotLK):
  - 24788: Daily heroic random (1st)
  - 24789: Daily heroic random (Nth)
  - 24790: Daily normal random (Nth)
- `progression_80_1_2_weekly_raid_quests.sql` (tables: `quest_template`)
  - ProgressionSystem - weekly raid quests emblem reward (Bracket_80_1_2)
  - Goal:
  - Normalize weekly raid quest emblem rewards to match this bracket's progression.
  - Weekly raid quest IDs (Archmage Lan'dalock):
  - 24579 Sartharion Must Die!
  - 24580 Anub'Rekhan Must Die!
  - 24581 Noth the Plaguebringer Must Die!
  - 24582 Instructor Razuvious Must Die!
  - 24583 Patchwerk Must Die!
  - 24584 Malygos Must Die!
  - 24585 Flame Leviathan Must Die!
  - 24586 Razorscale Must Die!
  - 24587 Ignis the Furnace Master Must Die!
  - 24588 XT-002 Deconstructor Must Die!
  - 24589 Lord Jaraxxus Must Die!
  - 24590 Lord Marrowgar Must Die!
  - Emblem item IDs (WotLK):
  - Heroism  40752
  - Valor    40753
  - Conquest 45624
  - Triumph  47241
  - Frost    49426
  - MySQL: 8.x compatible.
- `progression_80_1_2_wintergrasp_vendors.sql` (tables: `mod_progression_wg_vendor_backup`, `npc_vendor`, `tmp_wg_vendor_entries`)
  - progression_80_1_2_wintergrasp_vendors.sql
  - Purpose:
  - Enforce Wintergrasp PvP vendor inventories up to Season 5 (Deadly).
  - Prevent future-season items being purchasable before their bracket.
  - Notes:
  - - Uses BOTH name keywords and ItemLevel thresholds to tag seasons.
  - - Creates a persistent backup table capturing the original vendor rows.
  - - Safe to re-run (idempotent via INSERT IGNORE).
- `vendors_cleanup_s5.sql` (tables: (unknown))
  - STUB / PRODUCTION:
  - This file is intentionally left without executable SQL.
  - Reason: it was a TEMPLATE with placeholders ([...]) and it broke autoloading.
  - Real template: ../templates/arena_s5_vendors_cleanup.sql.template
- `vendors_transition_tbc_to_wotlk.sql` (tables: (unknown))
  - STUB / PRODUCTION:
  - This file is intentionally left without executable SQL.
  - Reason: it was a TEMPLATE with placeholders ([...]) and it broke autoloading.
  - Real template: ../templates/transition_tbc_to_wotlk_vendors.sql.template

## Bracket_80_2_1

- Config key: `ProgressionSystem.Bracket_80_2_1`
- Config template notes:
  - Level 80 | WotLK: Raid Tier 7 (Launch raids)
  - Content (T7 Launch Raids):
  - - Naxxramas (10/25)
  - - The Obsidian Sanctum (10/25)
  - - The Eye of Eternity (10/25)
  - (Opcional):
  - - Vault of Archavon (VoA) 10/25 (si querÃ©s habilitarlo ya en T7 por simplicidad)
  - Features:
  - - Primer â€œtierâ€ de raids WotLK: coordinaciÃ³n bÃ¡sica, checks de rol, primeras piezas Ã©picas de raid.
  - - Ideal para progresiÃ³n: gatear consumibles/enchants y primeras metas de raid.
  - Release (Patch): 3.0.x (launch raids)
  - Recommended Duration: 6-10 weeks (depende si tu server es casual o competitivo)
- Loader: `src/Bracket_80_2_1/Bracket_80_2_1_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (15 files)
- `80_2_1_emblems_heroic_bosses.sql` (tables: `creature_loot_template`, `IF`, `tmp_heroic_bosses`, `tmp_lootids_fix`, `tmp_maps`)
  - ============================================================================
  - WotLK Bracket 80_2_1 - HEROIC 5-man BOSSES emblem normalization
  - MySQL 8.x | AzerothCore WotLK 3.3.5
  - Desired emblem for HEROIC dungeon BOSSES (5-man):
  - 80_2_1 => Emblem of Heroism (40752)
  - PARTS (in order): A) REPORT  B) BACKUP  C) APPLY  D) VERIFY
  - GM reload note: .reload creature_loot_template (if supported) or restart worldserver.
  - ============================================================================
- `80_2_1_emblems_heroic_bosses_rollback.sql` (tables: `creature_loot_template`, `tmp_restore_keys`)
  - ============================================================================
  - ROLLBACK - WotLK Bracket 80_2_1 - HEROIC 5-man BOSSES emblem normalization
  - Restores rows from backup_80_2_1_emblems_heroic_bosses
  - ============================================================================
- `progression_80_1_1_npc_vendor_down.sql` (tables: `npc_vendor`)
  - (no header comment; open the file for details)
- `progression_80_1_2_pvp_vendors_down.sql` (tables: `creature`, `game_event_creature`)
  - (no header comment; open the file for details)
- `progression_80_2_1_disables.sql` (tables: `disables`)
  - Bracket 80_2_1 (WotLK T7): lock future content, unlock T7 raids elsewhere.
  - This file complements `progression_80_2_1_raids_disables.sql` (which unlocks Naxx/OS/EoE).
  - Goal:
  - - Keep Ulduar/VoA locked until Bracket_80_2_2.
  - - Keep ToC/Onyxia80/ICC/RS + ICC 5-mans locked until their brackets.
  - - Keep heroic 5-man dungeons enabled (T7 era includes heroics).
  - MySQL: 8.x compatible.
  - WotLK baseline lock (deny-by-default): ensure future 80 content is blocked even if earlier WotLK brackets were skipped.
- `progression_80_2_1_emblem_exchange_vendor_35790.sql` (tables: `item_template`, `mod_progression_backup_npc_vendor_35790`, `npc_vendor`)
  - Emblem exchange helper (Usuri Brightcoin - 35790)
  - Bracket: 80_2_1 (WotLK T7 raids)
  - Goal:
  - Provide a SAFE down-conversion to the bracket's heroic emblem, to mitigate DB mistakes where
  - a heroic boss drops a higher emblem than intended.
  - Rules:
  - - Only allow HIGHER => CURRENT conversions (never lower => higher).
  - - This script ONLY changes npc_vendor (it does not change boss loot tables).
  - Emblems (WotLK):
  - Heroism  40752
  - Valor    40753
  - Conquest 45624
  - Triumph  47241
  - Frost    49426
  - ExtendedCost IDs (AzerothCore WotLK 3.3.5a / item_extended_cost.dbc):
  - 2589 => pay 1x Valor (40753)
  - 2637 => pay 1x Conquest (45624)
  - 2707 => pay 1x Triumph (47241)
  - 2743 => pay 1x Frost (49426)
  - Backup vendor inventory (first run only)
- `progression_80_2_1_emblems.sql` (tables: `creature_loot_template`, `gameobject_loot_template`, `reference_loot_template`)
  - ProgressionSystem - WotLK emblems (Bracket_80_2_1)
  - SERVER SOURCE OF TRUTH (T7 raids unlocked; heroics unchanged from launch):
  - - Heroic 5-man bosses => HEROISM (40752)
  - Scope: ONLY level-80 5-man dungeon heroic maps (no raids):
  - Launch set (no ToC / no Frozen Halls):
  - 574,575,576,578,595,599,600,601,602,604,608,619
  - Emblem item IDs (WotLK):
  - Heroism 40752
  - Valor   40753
  - Conquest 45624
  - Triumph 47241
  - Frost   49426
- `progression_80_2_1_emblems_raids.sql` (tables: `creature_loot_template`, `reference_loot_template`)
  - Bracket 80_2_1 (WotLK T7): raid emblem correction
  - Goal:
  - Ensure T7 launch raids drop their intended raid-tier emblem.
  - Design (blizzlike timeline):
  - - Heroic 5-mans: Emblem of Heroism (40752)
  - - T7 raids (Naxx/OS/EoE): Emblem of Valor (40753)
  - This file ONLY touches raid boss loot in the specified raid maps.
  - It does NOT change heroic dungeon loot.
- `progression_80_2_1_heroic_gs.sql` (tables: `enabled`, `mod_progression_heroic_gs`, `required_heroic`)
  - ProgressionSystem - Heroic avg item level gate (Bracket 80_2_1)
  - This module enforces an average item level requirement when players enter heroic 5-man dungeons.
  - Avg iLvl is computed from equipped items (excluding shirt/tabard).
  - Apply into the WORLD database.
- `progression_80_2_1_lfg_rewards.sql` (tables: `lfg_dungeon_rewards`)
  - Reset WotLK LFG reward quest IDs (Bracket 80_2_1)
  - Note:
  - - This only assigns which quests are used by random heroic.
  - - The emblem item/amount is controlled by `quest_template` and is set per bracket
  - in `progression_80_2_1_rdf_quests.sql`.
- `progression_80_2_1_naxxramas_80_enable.sql` (tables: `creature`)
  - Naxxramas 80 (Level 80 Raid Tier 1)
  - Enables Naxxramas at level 80 difficulty
  - Uncomment/Comment bosses based on phase progression
  - Enable Naxxramas 80 version creatures
- `progression_80_2_1_raids_disables.sql` (tables: `disables`)
  - Bracket 80_2_1 (WotLK T7): unlock launch raids
  - Content: Naxxramas (533), Obsidian Sanctum (615), Eye of Eternity (616)
  - Optional: Vault of Archavon (624) is left untouched here.
- `progression_80_2_1_rdf_quests.sql` (tables: `quest_template`)
  - ProgressionSystem - dungeon dailies & RDF rewards (Bracket_80_2_1)
  - SERVER SOURCE OF TRUTH (T7 raids unlocked; heroics unchanged from launch):
  - - Heroic 5-man bosses: Heroism (40752) [handled in progression_80_2_1_emblems.sql]
  - - Daily normal ("Timear Foresees..."): Heroism (40752) x2
  - - Daily heroic ("Proof of Demise..."): Valor (40753) x2
  - - RDF (if enabled): keep Heroism (40752)
  - Emblem IDs:
  - Heroism   40752
  - Valor     40753
  - Conquest  45624
  - Triumph   47241
  - Frost     49426
  - RDF / Random dungeon (common AzerothCore WotLK):
  - 24788: Daily heroic random (1st)
  - 24789: Daily heroic random (Nth)
  - 24790: Daily normal random (Nth)
- `progression_80_2_1_unlock_heroic_dungeons.sql` (tables: `backupKambi_disables_unlock_80_2_1_20251230`, `disables`)
  - Fix: unlock Bracket 80_2_1 heroic dungeons (T7-era heroics)
  - Use this if a bad query accidentally disabled the heroics in `disables`.
  - Applies to:
  - - sourceType=2 (Map)
  - - sourceType=8 (RDF/LFG teleport)
  - Heroic dungeon mapIds:
  - 574 Utgarde Keep
  - 575 Utgarde Pinnacle
  - 576 The Nexus
  - 578 The Oculus
  - 595 The Culling of Stratholme
  - 599 Halls of Stone
  - 600 Drak'Tharon Keep
  - 601 Azjol-Nerub
  - 602 Halls of Lightning
  - 604 Gundrak
  - 608 The Violet Hold
  - 619 Ahn'kahet: The Old Kingdom
  - MySQL: 8.x compatible.
  - 1) Report current disables (should be empty after fix)
- `progression_80_2_1_weekly_raid_quests.sql` (tables: `quest_template`)
  - ProgressionSystem - weekly raid quests emblem reward (Bracket_80_2_1)
  - Goal:
  - Normalize weekly raid quest emblem rewards to match this bracket's progression.
  - Weekly raid quest IDs (Archmage Lan'dalock):
  - 24579 Sartharion Must Die!
  - 24580 Anub'Rekhan Must Die!
  - 24581 Noth the Plaguebringer Must Die!
  - 24582 Instructor Razuvious Must Die!
  - 24583 Patchwerk Must Die!
  - 24584 Malygos Must Die!
  - 24585 Flame Leviathan Must Die!
  - 24586 Razorscale Must Die!
  - 24587 Ignis the Furnace Master Must Die!
  - 24588 XT-002 Deconstructor Must Die!
  - 24589 Lord Jaraxxus Must Die!
  - 24590 Lord Marrowgar Must Die!
  - Emblem item IDs (WotLK):
  - Heroism  40752
  - Valor    40753
  - Conquest 45624
  - Triumph  47241
  - Frost    49426
  - MySQL: 8.x compatible.

## Bracket_80_2_2

- Config key: `ProgressionSystem.Bracket_80_2_2`
- Config template notes:
  - Level 80 | WotLK: Raid Tier 8 | Ulduar (10/25) + Arena Season 6
  - Content:
  - - Ulduar (10/25) completo, incluidos hard-modes si tu progresion los permite.
  - - PvP: Arena Season 6 (Furious era)
  - Features:
  - - Salto real de dificultad: mecÃ¡nicas complejas, hardmodes, mejores upgrades.
  - - "Tier largo": se suele quedar mas tiempo (mucha gente farmea Ulduar bastante).
  - Release (Patch): 3.1.x (Ulduar era) + S6
  - Recommended Duration: 8-12 weeks
- Loader: `src/Bracket_80_2_2/Bracket_80_2_2_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (17 files)
- `80_2_2_emblems_heroic_bosses.sql` (tables: `creature_loot_template`, `IF`, `tmp_heroic_bosses`, `tmp_lootids_fix`, `tmp_maps`)
  - ============================================================================
  - WotLK Bracket 80_2_2 - HEROIC 5-man BOSSES emblem normalization
  - Desired emblem: Emblem of Valor (40753)
  - Maps: WotLK launch dungeon set (no ToC, no ICC 5-mans here)
  - ============================================================================
- `80_2_2_emblems_heroic_bosses_rollback.sql` (tables: `creature_loot_template`, `tmp_restore_keys`)
  - ============================================================================
  - ROLLBACK - WotLK Bracket 80_2_2 - HEROIC 5-man BOSSES emblem normalization
  - Restores rows from backup_80_2_2_emblems_heroic_bosses
  - ============================================================================
- `progression_0_disables_ArgentTournamentConstructionquests_down.sql` (tables: (unknown))
  - Argent Tournament belongs to Bracket_80_3.
  - This file used to UNLOCK some AT quest disables in Bracket_80_2; it is now intentionally a no-op.
  - The unlock is handled in Bracket_80_3/sql/world/progression_80_3_disables.sql
- `progression_80_2_2_arena_season_6.sql` (tables: (unknown))
  - STUB / PRODUCTION:
  - This file is intentionally left without executable SQL.
  - Reason: earlier placeholder SQL here did not match AzerothCore schema
  - (e.g. npc_vendor has no phaseMask column), which can break DBUpdater autoloading.
  - If you need full Season 6 PvP vendors, import a verified SQL dataset
  - for your AzerothCore world DB (npc_vendor entries + extended costs).
- `progression_80_2_2_ArgentTournamentConstructionQuests.sql` (tables: (unknown))
  - Argent Tournament belongs to Bracket_80_3.
  - This file used to enable AT construction quests in Bracket_80_2; it is now intentionally a no-op.
  - See: Bracket_80_3/sql/world/progression_80_3_ArgentTournamentConstructionQuests.sql
- `progression_80_2_2_creature.sql` (tables: `creature`, `creature_template`, `gameobject_loot_template`)
  - 80 level range - Tier 8 & Furious Gladiator
  - restore Emalon at Vaulth of Archavon
- `progression_80_2_2_disables.sql` (tables: `disables`)
  - 80 level range - Tier 8 (Secrets of Ulduar) & Furious Gladiator
  - WotLK baseline lock (deny-by-default): ensure future 80 content is blocked even if earlier WotLK brackets were skipped.
  - This is safe because later brackets explicitly DELETE from `disables` to unlock what they need.
- `progression_80_2_2_emblem_exchange_vendor_35790.sql` (tables: `item_template`, `mod_progression_backup_npc_vendor_35790`, `npc_vendor`)
  - Emblem exchange helper (Usuri Brightcoin - 35790)
  - Bracket: 80_2_2 (WotLK Ulduar / T8)
  - Goal:
  - Provide a SAFE down-conversion to the bracket's heroic emblem, to mitigate DB mistakes where
  - a heroic boss drops a higher emblem than intended.
  - Rules:
  - - Only allow HIGHER => CURRENT conversions (never lower => higher).
  - - This script ONLY changes npc_vendor (it does not change boss loot tables).
  - Emblems (WotLK):
  - Heroism  40752
  - Valor    40753
  - Conquest 45624
  - Triumph  47241
  - Frost    49426
  - ExtendedCost IDs (AzerothCore WotLK 3.3.5a / item_extended_cost.dbc):
  - 2637 => pay 1x Conquest (45624)
  - 2707 => pay 1x Triumph (47241)
  - 2743 => pay 1x Frost (49426)
  - Backup vendor inventory (first run only)
- `progression_80_2_2_emblems.sql` (tables: `creature_loot_template`, `gameobject_loot_template`, `reference_loot_template`)
  - ProgressionSystem - WotLK emblems (Bracket_80_2_2)
  - SERVER SOURCE OF TRUTH (Ulduar / T8 era):
  - - Heroic 5-man bosses => VALOR (40753) (catch-up)
  - Scope: ONLY level-80 5-man dungeon heroic maps (no raids):
  - Launch set + Ulduar era (no ToC / no Frozen Halls):
  - 574,575,576,578,595,599,600,601,602,604,608,619
  - Emblem IDs:
  - Heroism   40752
  - Valor     40753
  - Conquest  45624
  - Triumph   47241
  - Frost     49426
- `progression_80_2_2_emblems_raids.sql` (tables: `creature_loot_template`, `reference_loot_template`)
  - Bracket 80_2_2 (WotLK T8 / Ulduar): raid emblem correction
  - Goal:
  - Ensure Ulduar drops its intended raid-tier emblem.
  - Design (blizzlike timeline):
  - - Heroic 5-mans: Emblem of Heroism (40752)
  - - T7 raids: Emblem of Valor (40753)
  - - Ulduar (T8): Emblem of Conquest (45624)
  - This file ONLY touches raid boss loot in Ulduar (map 603).
- `progression_80_2_2_heroic_gs.sql` (tables: `enabled`, `mod_progression_heroic_gs`, `required_heroic`)
  - ProgressionSystem - Heroic avg item level gate (Bracket 80_2_2)
  - This module enforces an average item level requirement when players enter heroic 5-man dungeons.
  - Avg iLvl is computed from equipped items (excluding shirt/tabard).
  - This SQL configures the requirement for bracket 80_2_2 and (optionally) enables the feature via DB.
  - Apply into the WORLD database.
- `progression_80_2_2_inscribed_kirin_tor_rings.sql` (tables: `npc_vendor`)
  - Adds Inscribed Band, Loop, Ring and Signet of Kirn Tor to Harold Winston with Ulduar Release
- `progression_80_2_2_lfg_rewards.sql` (tables: `lfg_dungeon_rewards`)
  - Reset WotLK LFG reward quest IDs (Bracket 80_2_2)
  - Note:
  - - This only assigns which quests are used by random heroic.
  - - The emblem item/amount is controlled by `quest_template` and is set per bracket
  - in `progression_80_2_2_rdf_quests.sql`.
- `progression_80_2_2_rdf_quests.sql` (tables: `quest_template`)
  - ProgressionSystem - dungeon dailies & RDF rewards (Bracket_80_2_2)
  - SERVER SOURCE OF TRUTH (Ulduar / T8 era):
  - - Heroic 5-man bosses: Valor (40753) [handled in progression_80_2_2_emblems.sql]
  - - Daily normal ("Timear Foresees..."): Valor (40753) x2
  - - Daily heroic ("Proof of Demise..."): Conquest (45624) x2
  - RDF / Random heroic isn't part of the original 3.1 timeline, but if you run it on the server,
  - keep it coherent with this bracket.
  - RDF / Random dungeon (common AzerothCore WotLK):
  - 24788: Daily heroic random (1st)
  - 24789: Daily heroic random (Nth)
  - 24790: Daily normal random (Nth)
- `progression_80_2_2_weekly_raid_quests.sql` (tables: `quest_template`)
  - ProgressionSystem - weekly raid quests emblem reward (Bracket_80_2_2)
  - Goal:
  - Normalize weekly raid quest emblem rewards to match this bracket's progression.
  - Weekly raid quest IDs (Archmage Lan'dalock):
  - 24579 Sartharion Must Die!
  - 24580 Anub'Rekhan Must Die!
  - 24581 Noth the Plaguebringer Must Die!
  - 24582 Instructor Razuvious Must Die!
  - 24583 Patchwerk Must Die!
  - 24584 Malygos Must Die!
  - 24585 Flame Leviathan Must Die!
  - 24586 Razorscale Must Die!
  - 24587 Ignis the Furnace Master Must Die!
  - 24588 XT-002 Deconstructor Must Die!
  - 24589 Lord Jaraxxus Must Die!
  - 24590 Lord Marrowgar Must Die!
  - Emblem item IDs (WotLK):
  - Heroism  40752
  - Valor    40753
  - Conquest 45624
  - Triumph  47241
  - Frost    49426
  - MySQL: 8.x compatible.
- `progression_80_2_2_wintergrasp_vendors.sql` (tables: `mod_progression_wg_vendor_backup`, `npc_vendor`, `tmp_wg_vendor_entries`)
  - progression_80_2_wintergrasp_vendors.sql
  - Purpose:
  - Enforce Wintergrasp PvP vendor inventories up to Season 6 (Furious).
- `vendors_cleanup_s6.sql` (tables: (unknown))
  - STUB / PRODUCTION:
  - This file is intentionally left without executable SQL.
  - Reason: it was a TEMPLATE with placeholders ([...]) and it broke autoloading.
  - Real template: ../templates/arena_s6_vendors_cleanup.sql.template

## Bracket_80_3

- Config key: `ProgressionSystem.Bracket_80_3`
- Config template notes:
  - Level 80 | WotLK: Raid Tier 9 | Trial of the Crusader + Onyxia 80 + Arena Season 7
  - Content:
  - - Trial of the Crusader / Trial of the Grand Crusader (10/25)
  - - Onyxia's Lair (nivel 80) 10/25 (entra dentro de la era ToC)
  - - PvP: Arena Season 7 (Relentless era)
  - Features:
  - - ProgresiÃ³n â€œrÃ¡pidaâ€: raid corto, gear sube muy rÃ¡pido.
  - - Excelente bracket para setear reglas de vendors/recompensas y evitar â€œsaltoâ€ de tiers.
  - Release (Patch): 3.2.x (ToC era) + 3.2.2 (Onyxia 80) + S7
  - Recommended Duration: 6-10 weeks
- Loader: `src/Bracket_80_3/Bracket_80_3_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (18 files)
- `80_3_emblems_heroic_bosses.sql` (tables: `creature_loot_template`, `IF`, `tmp_heroic_bosses`, `tmp_lootids_fix`, `tmp_maps`)
  - ============================================================================
  - WotLK Bracket 80_3 - HEROIC 5-man BOSSES emblem normalization
  - Desired emblem: Emblem of Conquest (45624)
  - Maps: WotLK launch + Trial of the Champion (650)
  - ============================================================================
- `80_3_emblems_heroic_bosses_rollback.sql` (tables: `creature_loot_template`, `tmp_restore_keys`)
  - ============================================================================
  - ROLLBACK - WotLK Bracket 80_3 - HEROIC 5-man BOSSES emblem normalization
  - Restores rows from backup_80_3_emblems_heroic_bosses
  - ============================================================================
- `progression_80_1_epic_gems_down.sql` (tables: `disables`, `npc_vendor`)
  - (no header comment; open the file for details)
- `progression_80_2_ArgentTournamentConstructionQuests_down.sql` (tables: (unknown))
  - Argent Tournament belongs to Bracket_80_3.
  - This file used to DISABLE AT construction quests in Bracket_80_3; it is now intentionally a no-op.
  - See: Bracket_80_3/sql/world/progression_80_3_ArgentTournamentConstructionQuests.sql
- `progression_80_3_arena_season_7.sql` (tables: `npc_vendor`)
  - Arena Season 7 Support (Bracket_80_3)
  - Season 7: August 2009 - December 2009
  - T9 Tier sets from Trial of the Crusader drops
  - Trial of the Crusader Tier 9 Loot
  - Already configured by default in AzerothCore
  - Tier 9 vendors will be enabled when Trial is active
  - Arena Season 7 vendors and items
  - These items are PvP gear for Season 7
  - Vendors located in: Orgrimmar, Stormwind
- `progression_80_3_ArgentTournamentConstructionQuests.sql` (tables: `creature_questender`, `creature_queststarter`, `creature_template`)
  - Argent Tournament (AT) construction quests should become available in Bracket_80_3.
- `progression_80_3_creature.sql` (tables: `creature`)
  - 80 level range - Tier 9 & Relentless Gladiator
  - restore Koralon at Vaulth of Archavon
- `progression_80_3_disables.sql` (tables: `disables`)
  - 80 level range - Tier 9 (Call of the Crusade) & Relentless Gladiator
  - WotLK baseline lock (deny-by-default): ensure future 80 content is blocked even if earlier WotLK brackets were skipped.
  - This is safe because this bracket explicitly DELETEs from `disables` to unlock ToC/Onyxia.
- `progression_80_3_emblem_exchange_vendor_35790.sql` (tables: `item_template`, `mod_progression_backup_npc_vendor_35790`, `npc_vendor`)
  - Emblem exchange helper (Usuri Brightcoin - 35790)
  - Bracket: 80_3 (WotLK ToC / T9)
  - Goal:
  - Provide a SAFE down-conversion to the bracket's heroic emblem, to mitigate DB mistakes where
  - a heroic boss drops a higher emblem than intended.
  - Rules:
  - - Only allow HIGHER => CURRENT conversions (never lower => higher).
  - - This script ONLY changes npc_vendor (it does not change boss loot tables).
  - Emblems (WotLK):
  - Heroism  40752
  - Valor    40753
  - Conquest 45624
  - Triumph  47241
  - Frost    49426
  - ExtendedCost IDs (AzerothCore WotLK 3.3.5a / item_extended_cost.dbc):
  - 2707 => pay 1x Triumph (47241)
  - 2743 => pay 1x Frost (49426)
  - Backup vendor inventory (first run only)
- `progression_80_3_emblems.sql` (tables: `creature_loot_template`, `gameobject_loot_template`, `reference_loot_template`)
  - ProgressionSystem - WotLK emblems (Bracket_80_3)
  - SERVER SOURCE OF TRUTH:
  - - Heroicas (bosses) => CONQUISTA (45624)
  - Scope: ONLY level-80 5-man dungeon heroic maps (no raids):
  - Include ToC 5-man (650), exclude Frozen Halls (632/658/668):
  - 574,575,576,578,595,599,600,601,602,604,608,619,650
  - Emblem IDs:
  - Heroism   40752
  - Valor     40753
  - Conquest  45624
  - Triumph   47241
  - Frost     49426
- `progression_80_3_emblems_raids.sql` (tables: `creature_loot_template`, `reference_loot_template`)
  - Bracket 80_3 (WotLK T9 / ToC + Onyxia 80): raid emblem correction
  - Goal:
  - Ensure ToC and Onyxia (level 80 rework era) drop their intended raid-tier emblem.
  - Design (blizzlike timeline):
  - - ToC / Ony 80 raids (T9 era): Emblem of Triumph (47241)
  - This file ONLY touches raid boss loot in the specified raid maps.
- `progression_80_3_etched_kirin_tor_rings.sql` (tables: `npc_vendor`)
  - Adds Etched Band, Loop, Ring and Signet of Kirn Tor to Harold Winston with Trial of the Crusader Release
- `progression_80_3_heroic_gs.sql` (tables: `enabled`, `mod_progression_heroic_gs`, `required_heroic`)
  - ProgressionSystem - Heroic avg item level gate (Bracket 80_3)
  - Required (avg iLvl): 220
- `progression_80_3_lfg_rewards.sql` (tables: `lfg_dungeon_rewards`)
  - Reset WotLK LFG reward quest IDs (Bracket 80_3)
  - Note:
  - - This only assigns which quests are used by random heroic.
  - - The emblem item/amount is controlled by `quest_template` and is set per bracket
  - in `progression_80_3_rdf_quests.sql`.
- `progression_80_3_rdf_quests.sql` (tables: `quest_template`)
  - ProgressionSystem - dungeon dailies & RDF rewards (Bracket_80_3)
  - SERVER SOURCE OF TRUTH (ToC / 3.2 era):
  - - Heroic 5-man bosses: Conquest (45624) [handled in progression_80_3_emblems.sql]
  - - Daily normal dungeon quest: Conquest (45624) x1
  - - Daily heroic dungeon quest: Triumph (47241) x2
  - RDF / Random dungeon (common AzerothCore WotLK):
  - 24788: Daily heroic random (1st)
  - 24789: Daily heroic random (Nth)
  - 24790: Daily normal random (Nth)
- `progression_80_3_weekly_raid_quests.sql` (tables: `quest_template`)
  - ProgressionSystem - weekly raid quests emblem reward (Bracket_80_3)
  - Goal:
  - Normalize weekly raid quest emblem rewards to match this bracket's progression.
  - Weekly raid quest IDs (Archmage Lan'dalock):
  - 24579 Sartharion Must Die!
  - 24580 Anub'Rekhan Must Die!
  - 24581 Noth the Plaguebringer Must Die!
  - 24582 Instructor Razuvious Must Die!
  - 24583 Patchwerk Must Die!
  - 24584 Malygos Must Die!
  - 24585 Flame Leviathan Must Die!
  - 24586 Razorscale Must Die!
  - 24587 Ignis the Furnace Master Must Die!
  - 24588 XT-002 Deconstructor Must Die!
  - 24589 Lord Jaraxxus Must Die!
  - 24590 Lord Marrowgar Must Die!
  - Emblem item IDs (WotLK):
  - Heroism  40752
  - Valor    40753
  - Conquest 45624
  - Triumph  47241
  - Frost    49426
  - MySQL: 8.x compatible.
- `progression_80_3_wintergrasp_vendors.sql` (tables: `mod_progression_wg_vendor_backup`, `npc_vendor`, `tmp_wg_vendor_entries`)
  - progression_80_3_wintergrasp_vendors.sql
  - Purpose:
  - Enforce Wintergrasp PvP vendor inventories up to Season 7 (Relentless).
- `vendors_cleanup_s7.sql` (tables: (unknown))
  - STUB / PRODUCTION:
  - This file is intentionally left without executable SQL.
  - Reason: it was a TEMPLATE with placeholders ([...]) and it broke autoloading.
  - Real template: ../templates/arena_s7_vendors_cleanup.sql.template

## Bracket_80_4_1

- Config key: `ProgressionSystem.Bracket_80_4_1`
- Config template notes:
  - Level 80 | WotLK: Raid Tier 10 | Icecrown Citadel + Frozen Halls 5-man + Arena Season 8
  - Content:
  - - Icecrown Citadel (10/25) + modos (normal/heroic) segÃºn tu progresiÃ³n
  - - ICC 5-man (Frozen Halls, lvl 80):
  - * Forge of Souls (632)
  - * Pit of Saron (658)
  - * Halls of Reflection (668)
  - - PvP: Arena Season 8 (Wrathful era)
  - Features:
  - - Ãšltimo tier principal: mayor exigencia, mejores recompensas, y aquÃ­ sÃ­ entra el â€œpack ICCâ€ de dungeons.
  - - Ideal para aplicar el gate de iLvl de ICC5 (normal/heroic) si lo usas.
  - Release (Patch): 3.3.x (ICC + Frozen Halls) + 3.3.2 (S8 era)
  - Recommended Duration: 10-16 weeks (o mÃ¡s si querÃ©s endgame largo)
- Loader: `src/Bracket_80_4_1/Bracket_80_4_1_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (17 files)
- `80_4_1_emblems_heroic_bosses.sql` (tables: `creature_loot_template`, `IF`, `tmp_heroic_bosses`, `tmp_lootids_fix`, `tmp_maps`)
  - ============================================================================
  - WotLK Bracket 80_4_1 - HEROIC 5-man BOSSES emblem normalization
  - Desired emblem: Emblem of Triumph (47241)
  - Maps: WotLK launch + Trial of the Champion (650) + ICC 5-mans (632/658/668)
  - NOTE: "wrong" = any emblem in the emblem set except @EMBLEM_RIGHT.
  - ============================================================================
- `80_4_1_emblems_heroic_bosses_rollback.sql` (tables: `creature_loot_template`, `tmp_restore_keys`)
  - ============================================================================
  - ROLLBACK - WotLK Bracket 80_4_1 - HEROIC 5-man BOSSES emblem normalization
  - Restores rows from backup_80_4_1_emblems_heroic_bosses
  - ============================================================================
- `progression_0_creature_undercity_guardian_down.sql` (tables: `creature`)
  - Restore Kor'Kron Overseer in Undercity
- `progression_60_3_2_scarab_lord_quests_down.sql` (tables: `creature_loot_template`)
  - Revert drop rate for Nightmare_corruption
- `progression_80_4_1_creature.sql` (tables: `creature`)
  - 80 level range - Tier 10 & Wrathful Gladiator
  - restore Toravon at Vaulth of Archavon
- `progression_80_4_1_disables.sql` (tables: `creature_template`, `disables`)
  - 80 level range - Tier 10 (Fall of the Lich King) & Wrathful Gladiator
  - WotLK baseline lock (deny-by-default): ensure future 80 content is blocked even if earlier WotLK brackets were skipped.
  - This is safe because this bracket explicitly DELETEs from `disables` to unlock ICC 5-mans and ICC raid.
- `progression_80_4_1_emblem_exchange_vendor_35790.sql` (tables: `item_template`, `mod_progression_backup_npc_vendor_35790`, `npc_vendor`)
  - Emblem exchange helper (Usuri Brightcoin - 35790)
  - Bracket: 80_4_1 (WotLK ICC / T10)
  - Goal:
  - Provide a SAFE down-conversion to the bracket's heroic emblem, to mitigate DB mistakes where
  - a heroic boss drops a higher emblem than intended.
  - Rules:
  - - Only allow HIGHER => CURRENT conversions (never lower => higher).
  - - This script ONLY changes npc_vendor (it does not change boss loot tables).
  - Emblems (WotLK):
  - Heroism  40752
  - Valor    40753
  - Conquest 45624
  - Triumph  47241
  - Frost    49426
  - ExtendedCost IDs (AzerothCore WotLK 3.3.5a / item_extended_cost.dbc):
  - 2743 => pay 1x Frost (49426)
  - Backup vendor inventory (first run only)
- `progression_80_4_1_emblems.sql` (tables: `creature_loot_template`, `gameobject_loot_template`, `reference_loot_template`)
  - ProgressionSystem - WotLK emblems (Bracket_80_4_1)
  - SERVER SOURCE OF TRUTH:
  - - Heroicas (bosses) => TRIUNFO (47241)
  - Scope: ONLY level-80 5-man dungeon heroic maps (no raids):
  - 574,575,576,578,595,599,600,601,602,604,608,619,650,632,658,668
  - Emblem item IDs (WotLK):
  - Heroism 40752
  - Valor   40753
  - Conquest 45624
  - Triumph 47241
  - Frost   49426
- `progression_80_4_1_emblems_raids.sql` (tables: `creature_loot_template`, `reference_loot_template`)
  - Bracket 80_4_1 (WotLK T10 / ICC): raid emblem correction
  - Goal:
  - Ensure Icecrown Citadel drops its intended raid-tier emblem.
  - Design (blizzlike timeline):
  - - ICC raid bosses: Emblem of Frost (49426)
  - This file ONLY touches raid boss loot in Icecrown Citadel (map 631).
- `progression_80_4_1_frozo_the_renowned.sql` (tables: `creature`, `npc_vendor`)
  - Back to phase 1 frozo
- `progression_80_4_1_heroic_gs.sql` (tables: `enabled`, `mod_progression_heroic_gs`, `required_heroic`)
  - ProgressionSystem - Heroic avg item level gate (Bracket 80_4_1)
  - Required (avg iLvl): 240
- `progression_80_4_1_lfg_rewards.sql` (tables: `lfg_dungeon_rewards`)
  - Reset WotLK LFG reward quest IDs (Bracket 80_4_1)
  - Note:
  - - This only assigns which quests are used by random heroic.
  - - The emblem item/amount is controlled by `quest_template` and is set per bracket
  - in `progression_80_4_1_rdf_quests.sql`.
- `progression_80_4_1_rdf_quests.sql` (tables: `quest_template`)
  - ProgressionSystem - RDF rewards (Bracket_80_4_1)
  - SERVER SOURCE OF TRUTH (ICC / 3.3 era):
  - - Random Heroic (first of day): 2x Frost (49426)
  - - Random Heroic (after first):  2x Triumph (47241)
  - - Random Normal: keep Triumph (47241) x1 (not a focus of 3.3 gearing, but kept consistent)
  - Quest IDs (common AzerothCore WotLK):
  - 24788: Daily heroic random (1st)
  - 24789: Daily heroic random (Nth)
  - 24790: Daily normal random (Nth)
- `progression_80_4_1_runed_kirin_tor_rings.sql` (tables: `npc_vendor`)
  - Adds Etched Band, Loop, Ring and Signet of Kirn Tor to Harold Winston with Icecrown Citadel Release
- `progression_80_4_1_weekly_raid_quests.sql` (tables: `quest_template`)
  - ProgressionSystem - weekly raid quests emblem reward (Bracket_80_4_1)
  - Goal:
  - Normalize weekly raid quest emblem rewards to match this bracket's progression.
  - Weekly raid quest IDs (Archmage Lan'dalock):
  - 24579 Sartharion Must Die!
  - 24580 Anub'Rekhan Must Die!
  - 24581 Noth the Plaguebringer Must Die!
  - 24582 Instructor Razuvious Must Die!
  - 24583 Patchwerk Must Die!
  - 24584 Malygos Must Die!
  - 24585 Flame Leviathan Must Die!
  - 24586 Razorscale Must Die!
  - 24587 Ignis the Furnace Master Must Die!
  - 24588 XT-002 Deconstructor Must Die!
  - 24589 Lord Jaraxxus Must Die!
  - 24590 Lord Marrowgar Must Die!
  - Emblem item IDs (WotLK):
  - Heroism  40752
  - Valor    40753
  - Conquest 45624
  - Triumph  47241
  - Frost    49426
  - MySQL: 8.x compatible.
- `progression_80_4_1_wintergrasp_vendors.sql` (tables: `mod_progression_wg_vendor_backup`, `npc_vendor`, `tmp_wg_vendor_entries`)
  - progression_80_4_1_wintergrasp_vendors.sql
  - Purpose:
  - Enforce Wintergrasp PvP vendor inventories up to Season 8 (Wrathful).
  - (Effectively restores full 3.3.5a WG vendor inventories.)
- `vendors_cleanup_s8.sql` (tables: (unknown))
  - STUB / PRODUCTION:
  - This file is intentionally left without executable SQL.
  - Reason: it was a TEMPLATE with placeholders ([...]) and it broke autoloading.
  - Real template: ../templates/arena_s8_vendors_cleanup.sql.template

## Bracket_80_4_2

- Config key: `ProgressionSystem.Bracket_80_4_2`
- Config template notes:
  - Level 80 | WotLK: Post-ICC Bonus Raid | Ruby Sanctum
  - Content:
  - - Ruby Sanctum (10/25)
  - Features:
  - - â€œBonus raidâ€ final antes de Cataclysm; sirve como cierre y mini-progresiÃ³n extra.
  - Release (Patch): 3.3.5
  - Recommended Duration: 4-8 weeks
- Loader: `src/Bracket_80_4_2/Bracket_80_4_2_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (13 files)
- `80_4_2_emblems_heroic_bosses.sql` (tables: `creature_loot_template`, `IF`, `tmp_heroic_bosses`, `tmp_lootids_fix`, `tmp_maps`)
  - ============================================================================
  - WotLK Bracket 80_4_2 - HEROIC 5-man BOSSES emblem normalization
  - Desired emblem: Emblem of Triumph (47241)
  - Maps: WotLK launch + Trial of the Champion (650) + ICC 5-mans (632/658/668)
  - NOTE: "wrong" = any emblem in the emblem set except @EMBLEM_RIGHT.
  - ============================================================================
- `80_4_2_emblems_heroic_bosses_rollback.sql` (tables: `creature_loot_template`, `tmp_restore_keys`)
  - ============================================================================
  - ROLLBACK - WotLK Bracket 80_4_2 - HEROIC 5-man BOSSES emblem normalization
  - Restores rows from backup_80_4_2_emblems_heroic_bosses
  - ============================================================================
- `progression_80_1_kirin_tor_rings_down.sql` (tables: `npc_vendor`)
  - (no header comment; open the file for details)
- `progression_80_4_2_disables.sql` (tables: `disables`)
  - 80 level range - Ruby Sanctum
  - WotLK baseline lock (deny-by-default): ensure Ruby Sanctum is blocked until this bracket unlocks it.
  - This also protects servers that skip earlier WotLK brackets.
- `progression_80_4_2_emblem_exchange_vendor_35790.sql` (tables: `item_template`, `mod_progression_backup_npc_vendor_35790`, `npc_vendor`)
  - Emblem exchange helper (Usuri Brightcoin - 35790)
  - Bracket: 80_4_2 (WotLK Ruby Sanctum)
  - Goal:
  - Provide a SAFE down-conversion to the bracket's heroic emblem, to mitigate DB mistakes where
  - a heroic boss drops a higher emblem than intended.
  - Rules:
  - - Only allow HIGHER => CURRENT conversions (never lower => higher).
  - - This script ONLY changes npc_vendor (it does not change boss loot tables).
  - Emblems (WotLK):
  - Heroism  40752
  - Valor    40753
  - Conquest 45624
  - Triumph  47241
  - Frost    49426
  - ExtendedCost IDs (AzerothCore WotLK 3.3.5a / item_extended_cost.dbc):
  - 2743 => pay 1x Frost (49426)
  - Backup vendor inventory (first run only)
- `progression_80_4_2_emblems.sql` (tables: `creature_loot_template`, `gameobject_loot_template`, `reference_loot_template`)
  - ProgressionSystem - WotLK emblems (Bracket_80_4_2)
  - SERVER SOURCE OF TRUTH:
  - - Heroicas (bosses) => TRIUNFO (47241)
  - Scope: ONLY level-80 5-man dungeon heroic maps (no raids):
  - 574,575,576,578,595,599,600,601,602,604,608,619,650,632,658,668
  - Emblem item IDs (WotLK):
  - Heroism 40752
  - Valor   40753
  - Conquest 45624
  - Triumph 47241
  - Frost   49426
- `progression_80_4_2_emblems_raids.sql` (tables: `creature_loot_template`, `reference_loot_template`)
  - Bracket 80_4_2 (WotLK Ruby Sanctum): raid emblem correction
  - Goal:
  - Ensure Ruby Sanctum drops Frost, consistent with the final WotLK era.
  - Design (blizzlike timeline):
  - - Ruby Sanctum raid bosses: Emblem of Frost (49426)
  - This file ONLY touches raid boss loot in Ruby Sanctum (map 724).
- `progression_80_4_2_heroic_gs.sql` (tables: `enabled`, `mod_progression_heroic_gs`, `required_heroic`)
  - ProgressionSystem - Heroic avg item level gate (Bracket 80_4_2)
  - Required (avg iLvl): 240
- `progression_80_4_2_lfg_rewards.sql` (tables: `lfg_dungeon_rewards`)
  - Reset WotLK LFG reward quest IDs (Bracket 80_4_2)
  - Note:
  - - This only assigns which quests are used by random heroic.
  - - The emblem item/amount is controlled by `quest_template` and is set per bracket
  - in `progression_80_4_2_rdf_quests.sql`.
- `progression_80_4_2_rdf_quests.sql` (tables: `quest_template`)
  - ProgressionSystem - RDF rewards (Bracket_80_4_2)
  - SERVER SOURCE OF TRUTH (Ruby Sanctum era):
  - - Random Heroic (first of day): 2x Frost (49426)
  - - Random Heroic (after first):  2x Triumph (47241)
  - - Random Normal: Triumph (47241) x1
- `progression_80_4_2_t7_orb_of_naxxramas.sql` (tables: `gameobject`)
  - Restore gameobjects
- `progression_80_4_2_weekly_raid_quests.sql` (tables: `quest_template`)
  - ProgressionSystem - weekly raid quests emblem reward (Bracket_80_4_2)
  - Goal:
  - Normalize weekly raid quest emblem rewards to match this bracket's progression.
  - Weekly raid quest IDs (Archmage Lan'dalock):
  - 24579 Sartharion Must Die!
  - 24580 Anub'Rekhan Must Die!
  - 24581 Noth the Plaguebringer Must Die!
  - 24582 Instructor Razuvious Must Die!
  - 24583 Patchwerk Must Die!
  - 24584 Malygos Must Die!
  - 24585 Flame Leviathan Must Die!
  - 24586 Razorscale Must Die!
  - 24587 Ignis the Furnace Master Must Die!
  - 24588 XT-002 Deconstructor Must Die!
  - 24589 Lord Jaraxxus Must Die!
  - 24590 Lord Marrowgar Must Die!
  - Emblem item IDs (WotLK):
  - Heroism  40752
  - Valor    40753
  - Conquest 45624
  - Triumph  47241
  - Frost    49426
  - MySQL: 8.x compatible.
- `progression_80_4_2_wintergrasp_vendors.sql` (tables: `mod_progression_wg_vendor_backup`, `npc_vendor`, `tmp_wg_vendor_entries`)
  - progression_80_4_2_wintergrasp_vendors.sql
  - Purpose:
  - Bracket_80_4_2 is still Season 8 era; keep Wintergrasp vendors fully enabled.
  - This is the same enforcement as Bracket_80_4_1 (S8).

## Bracket_Custom

- Config key: `ProgressionSystem.Bracket_Custom`
- Config template notes:
  - ==============================================
  - PROGRESSION SYSTEM ADVANCED FEATURES
  - ==============================================
  - IMPORTANT:
  - The options in this section are currently placeholders.
  - They are documented for future work but are NOT enforced by the current C++ module code.
  - Setting them will have no effect beyond potential future compatibility.
  - The only options that currently have effect are:
  - - ProgressionSystem.LoadScripts / ProgressionSystem.LoadDatabase / ProgressionSystem.ReapplyUpdates
  - - ProgressionSystem.Bracket_* (bracket enable/disable)
  - - ProgressionSystem.DisabledAttunements
  - - The bracket-specific options used by existing scripts (e.g. MoltenCore/SSC/TheEye)
  - ProgressionSystem.EnforceItemRestrictions
  - Description: Prevents players from equipping items that belong to future brackets
  - Impact: Players in Vanilla bracket cannot wear TBC/WotLK items until progression advances
  - Default:   0 - Disabled
  - 1 - Enabled (Recommended for strict progression)
  - ProgressionSystem.BlockFutureVendors
  - Description: Hides vendors and their shops from players whose bracket level is too low
  - Impact: Tier 2+ vendors are invisible to players in Tier 1 bracket
  - Default:   0 - Disabled
  - 1 - Enabled (Recommended for immersion)
  - ProgressionSystem.EnforceArenaVendorProgression
  - Description: CRITICAL - Restricts Arena PvP vendors to only their corresponding season
  - Season 1 (TBC) vendors only appear during TBC brackets
  - Season 5+ (WotLK) vendors only appear during WotLK brackets
  - Impact: Players CANNOT buy Season 2 items while in Season 1 (enforces seasonal progression)
  - Default:   0 - Disabled
  - 1 - Enabled (HIGHLY RECOMMENDED - fixes arena vendor issues)
  - ProgressionSystem.RestrictArenaRewards
  - Description: Prevents arena rewards from seasons beyond the current bracket season
  - Impact: No Season 4 arena gear available until Sunwell Plateau bracket
  - Default:   0 - Disabled
  - 1 - Enabled (Strict control)
  - ProgressionSystem.EnforceDungeonAttunement
  - Description: Requires players to complete attunement quests before accessing dungeons/raids
  - Impact: Cannot enter Molten Core without attunement quest
  - Default:   0 - Disabled
  - 1 - Enabled
  - ProgressionSystem.RequireSequentialProgression
  - Description: Forces players to complete brackets in order (cannot skip content)
  - Impact: Must complete Vanilla before accessing TBC content
  - Default:   0 - Disabled
  - 1 - Enabled (Full progression control)
  - ProgressionSystem.AllowDungeonBypass
  - Description: If disabled, dungeon-only brackets cannot be skipped
  - Impact: Must run Karazhan before moving to Hyjal (if enabled)
  - Default:   1 - Enabled (Allow bypassing)
  - 0 - Disabled (Enforce all dungeons)
  - ProgressionSystem.RaidDifficultyScaling
  - Description: Automatically scales raid encounter difficulty based on player count
  - Impact: 10-player raids are easier than 40-player raids with proportional scaling
  - Default:   0 - Disabled
  - 1 - Enabled (Dynamic difficulty)
  - ProgressionSystem.LootProgressionSystem
  - Description: Prevents item inflation by blocking outdated loot from being too powerful
  - Impact: Items from older content have reduced stats in newer brackets
  - Default:   0 - Disabled
  - 1 - Enabled (Strict loot progression)
  - ProgressionSystem.AnnounceNewBracket
  - Description: Broadcasts to all players when a new bracket becomes available
  - Impact: Global message like "[Progression] Bracket 70_2_1 is now active!"
  - Default:   0 - Disabled
  - 1 - Enabled
  - ProgressionSystem.BroadcastBracketActivation
  - Description: Sends personal notification to affected players when their bracket opens
  - Impact: Players receive a popup/message when reaching bracket level
  - Default:   0 - Disabled
  - 1 - Enabled
  - ProgressionSystem.TrackBracketProgress
  - Description: Logs boss kills and bracket completion achievements
  - Impact: Enables statistics, ranking systems, and progression tracking
  - Default:   0 - Disabled
  - 1 - Enabled
  - ProgressionSystem.LogBracketActivity
  - Description: Creates detailed database logs of all bracket-related activities
  - Impact: Useful for admin debugging and audit trails
  - Default:   0 - Disabled
  - 1 - Enabled
  - ProgressionSystem.AutoEventScheduling
  - Description: Automatically triggers world events (invasions, boss spawns) when brackets change
  - Impact: Dragons spawn when Vanilla ends, Burning Legion invades when TBC tier completes
  - Default:   0 - Disabled
  - 1 - Enabled (Immersive events)
  - ProgressionSystem.WorldEventCooldown
  - Description: Time (in seconds) between automatic world event triggers
  - Impact: Prevents event spam. 604800 = 7 days, 86400 = 1 day
  - Default:   604800 (7 days)
  - ProgressionSystem.TierCompletionBonus
  - Description: Grants rewards when all bosses in a tier are defeated
  - Impact: +10% XP/Rep bonus for 1 week after tier completion
  - Default:   0 - Disabled
  - 1 - Enabled
  - ProgressionSystem.FirstKillBonus
  - Description: Special rewards for the first kill of each new boss encounter
  - Impact: Extra gold, achievement points, faction reputation boost
  - Default:   0 - Disabled
  - 1 - Enabled
  - ProgressionSystem.DynamicDifficultyScaling
  - Description: Increases raid difficulty if players farm content too easily
  - Impact: After 10+ kills, boss HP/damage increases by 10% per week
  - Default:   0 - Disabled
  - 1 - Enabled (Keeps content challenging)
  - ProgressionSystem.ResetRaidInstanceTimer
  - Description: How often raid instances reset (in hours)
  - Impact: 0 = once per week (Blizzard-like), 24 = daily resets (faster progression)
  - Default:   0 (Weekly reset)
  - ProgressionSystem.DisableNextBracketItems
  - Description: Prevents items from next bracket from being accessible early
  - Impact: No T5 items until you reach T5 bracket
  - Default:   0 - Disabled
  - 1 - Enabled (Strict item control)
  - ProgressionSystem.BlockBracketTransition
  - Description: Prevents players from changing to next bracket until objectives met
  - Impact: Cannot progress to TBC until Vanilla raid final boss defeated
  - Default:   0 - Disabled
  - 1 - Enabled (Mandatory progression)
  - ProgressionSystem.EnforceReputationRequirements
  - Description: Requires specific faction reputation to access bracket vendors
  - Impact: Need Honored with Cenarion Circle before accessing AQ40 vendor
  - Default:   0 - Disabled
  - 1 - Enabled
  - ProgressionSystem.RestrictBracketTeleporters
  - Description: Blocks teleportation to zones from future brackets
  - Impact: Cannot use portal to Shattrath if still in Vanilla bracket
  - Default:   0 - Disabled
  - 1 - Enabled
  - ProgressionSystem.NotifyRaidLeadersNewContent
  - Description: Sends email/message to raid leaders when new tier content opens
  - Impact: Leaders get notified automatically to organize raids
  - Default:   0 - Disabled
  - 1 - Enabled
  - ProgressionSystem.ReminderTimerHours
  - Description: How often players receive reminders about uncompleted bracket objectives
  - Impact: 24 = daily reminders, 168 = weekly, 0 = disabled
  - Default:   0 (Disabled)
  - ==============================================
  - BRACKET-SPECIFIC CONFIGURATIONS
  - ==============================================
  - ProgressionSystem.60.MoltenCore.ManualRuneHandling
  - Description: Defines whether Molten Core runes are handled manually (dousing through Aqual Quintessence) or automatic when bosses are defeated (WotLK default)
  - Default:   1 - Enabled (requires dousing)
  - 0 - Disabled (automatic, handled when bosses are defeated)
  - ProgressionSystem.60.MoltenCore.AqualEssenceCooldownReduction
  - Description: Reduces the cooldown of Eternal Quintessences by the amount specified.
  - Default:   0 - Disabled (1 hour cooldown)
  - 60 - (No cooldown)
  - ProgressionSystem.60.WorldBosses.KazzakPhasing
  - Description: Enables phasing out players and boss when Lord Kazzak is engaged.
  - Default:   1 - Enabled (Players and boss will be phased)
  - 0 - Disabled
  - ProgressionSystem.70.SerpentshrineCavern.RequireAllBosses
  - Description: Requires all bosses being killed before accessing Vashj's console panel.
  - Default:   1 - Enabled
  - 0 - Disabled
  - ProgressionSystem.70.TheEye.RequireAllBosses
  - Description: Requires all bosses being killed to open the doors to Kael
  - Default:   1 - Enabled
  - 0 - Disabled
  - ProgressionSystem.DisabledAttunements
  - ProgressionSystem.Arena.Season1.BracketRestriction
  - Description: CRITICAL - Restricts Season 1 Arena vendors to Bracket_70_2_1 and Bracket_70_2_2 only
  - Season 1 items cannot be purchased in earlier or later brackets
  - Default:   0 - Disabled
  - 1 - Enabled (RECOMMENDED)
  - ProgressionSystem.Arena.Season2.BracketRestriction
  - Description: CRITICAL - Restricts Season 2 Arena vendors to Season 2 brackets only
  - Season 2 items (Merciless gear) available only during Season 2 phase
  - Default:   0 - Disabled
  - 1 - Enabled (RECOMMENDED)
  - ProgressionSystem.Arena.Season3.BracketRestriction
  - Description: CRITICAL - Restricts Season 3 Arena vendors to Season 3 brackets only
  - Season 3 items (Vengeful gear) available only during Season 3 phase
  - Default:   0 - Disabled
  - 1 - Enabled (RECOMMENDED)
  - ProgressionSystem.Arena.Season4.BracketRestriction
  - Description: CRITICAL - Restricts Season 4 Arena vendors to Bracket_70_6_2 only
  - Season 4 items (Brutal gear) available only during Sunwell Plateau tier
  - Default:   0 - Disabled
  - 1 - Enabled (RECOMMENDED)
  - ProgressionSystem.Arena.Season5.BracketRestriction
  - Description: CRITICAL - Restricts Season 5 Arena vendors to WotLK brackets (80_1_1 and later)
  - Season 5 items (Deadly gear) available only during WotLK expansion
  - Default:   0 - Disabled
  - 1 - Enabled (RECOMMENDED)
  - ProgressionSystem.Arena.Season6.BracketRestriction
  - Description: CRITICAL - Restricts Season 6 Arena vendors to Bracket_80_2_2 only
  - Season 6 items (Furious gear) available only during Ulduar tier
  - Default:   0 - Disabled
  - 1 - Enabled (RECOMMENDED)
  - ProgressionSystem.Arena.Season7.BracketRestriction
  - Description: CRITICAL - Restricts Season 7 Arena vendors to Bracket_80_3 only
  - Season 7 items (Relentless gear) available only during Trial of Crusader tier
  - Default:   0 - Disabled
  - 1 - Enabled (RECOMMENDED)
  - ProgressionSystem.Arena.Season8.BracketRestriction
  - Description: CRITICAL - Restricts Season 8 Arena vendors to Bracket_80_4_1 only
  - Season 8 items (Wrathful gear) available only during Icecrown Citadel tier
  - Default:   0 - Disabled
  - 1 - Enabled (RECOMMENDED)
  - ProgressionSystem.Vendor.BlockOutdatedInventory
  - Description: Hides previous tier vendor inventories from current bracket
  - Impact: Old vendor items greyed out or completely hidden
  - Default:   0 - Disabled
  - 1 - Enabled (Clean vendor experience)
  - ProgressionSystem.Vendor.AllowPreviousTierPurchase
  - Description: If disabled, players CANNOT buy items from previous brackets
  - Impact: Cannot buy T3 items while in T4 bracket (unless set to 1)
  - Default:   1 - Enabled (Allow buying previous tier)
  - 0 - Disabled (Strict progression only)
  - ProgressionSystem.Vendor.RestrictPVPVendors
  - Description: Prevents access to PvP/Arena vendors outside their bracket
  - Impact: Arena vendor completely hidden if bracket doesn't match
  - Default:   0 - Disabled
  - 1 - Enabled (Strict vendor control - RECOMMENDED with ArenaRestriction)
  - ProgressionSystem.Vendor.ShowCompatibleVendorsOnly
  - Description: Only shows vendors that sell items for current player bracket level
  - Impact: Much cleaner vendor interface with only relevant options
  - Default:   0 - Disabled
  - 1 - Enabled (Recommended)
  - Description: Clears the selected attunements (dungeon_access_requirement) from database, even if SQL reapply mode is on.
  - Use this to end an attunement requirement prematurely, or debug.
  - Use `dungeon_access_id` separated by a comma, e.g "32, 64" to disable the attunements for Hyjal & Black Temple, respectively.
  - ProgressionSystem.CustomLocks.*
  - Description: Manual per-ID locks applied on startup (world DB), on top of bracket SQL.
  - Useful to temporarily block specific maps (dungeons/raids/BGs), heroic-only access, or NPC interactions.
  - Reversible:
  - - Removing an ID from the config and restarting restores the base state.
  - - Base state is captured AFTER bracket SQL updates are applied on startup.
  - Requirements:
  - - `ProgressionSystem.LoadDatabase = 1` (this feature writes to the DB).
  - Default:     Disabled
  - Log what will be applied (counts + masks).
  - Maps/instances by mapId (world.disables sourceType=2)
  - Bitmask ORed into `disables.flags` when LockAll applies.
  - Recommended:
  - - 15 = lock all WotLK instance difficulties (safe default for raids/dungeons)
  - Lock heroic only (keeps normal enabled): sets `disables.flags` to (flags|2)&~1
  - Battlegrounds:
  - Option A: by Battleground ID (world.disables sourceType=3; depends on core/db)
  - Option B: by mapId (world.disables sourceType=2), e.g. WSG=489, AB=529, AV=30, EotS=566, SotA=607, IoC=628
  - NPCs (creature_template entry IDs):
  - Clears bits from creature_template.npcflag to disable interaction (default: vendor => 128)
  - BRACKET -> ARENA SEASON MAPPING (Simple mapping keys)
  - Description: Define which bracket(s) host each Arena Season's PvP vendors/items.
  - Use comma-separated bracket identifiers. Each season also has an Enabled toggle.
  - NOTE: In this module, enabling an ArenaSeason mapping makes the listed brackets
  - effectively enabled (same behavior as setting ProgressionSystem.Bracket_<name> = 1)
  - for both SQL loading and script loading.
  - Example: ProgressionSystem.Bracket.ArenaSeason1 = Bracket_70_2_1,Bracket_70_2_2
  - ProgressionSystem.Bracket.ArenaSeason1.Enabled = 0
  - Default: All season mappings are set to canonical brackets and Disabled by default.
  - Season 1: Gruul/Mag & Karazhan era (TBC)
  - Season 2: Merciless era (TBC)
  - Season 3: Vengeful era (TBC)
  - Season 4: Sunwell Plateau era (TBC end)
  - Season 5: WotLK early Arena seasons (WotLK transition)
  - Season 6: Ulduar era
  - Season 7: Trial of the Crusader era
  - Season 8: Icecrown Citadel era
- Loader: `src/Bracket_Custom/Bracket_Custom_loader.cpp`
- C++ scripts: (none)

### Autoload SQL

#### auth (0 files)
- (directory missing)

#### characters (0 files)
- (directory missing)

#### world (0 files)
- (directory missing)
