/* =================================================================================================
   [mod-progression-blizzlike] Deny-by-default locks (world.disables)

   How to use:
   - Everything below is intentionally LOCKED by default.
   - When a bracket becomes active, you UNLOCK its content by DELETE-ing the matching rows from `disables`.

   Comment format (inside disables.comment):
   [mod-progression-blizzlike] Locked (<type>, Id=<id>): <name> | Unlock: Bracket_<...>

   Notes about flags (kept exactly as your original):
   - flags=1/3/15 are used as you provided (do not change unless you know your core rules for disables.flags).
================================================================================================= */


/* =================================================================================================
   VANILLA (LEVELING) BRACKETS
================================================================================================= */

/* ---------------------------------------------
   Bracket_1_19
   Unlocks: early vanilla dungeons (low level)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (33,36,43,48,389);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 33,  1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=33): Shadowfang Keep | Unlock: Bracket_1_19'),
(2, 36,  1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=36): The Deadmines | Unlock: Bracket_1_19'),
(2, 43,  1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=43): Wailing Caverns | Unlock: Bracket_1_19'),
(2, 48,  1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=48): Blackfathom Deeps | Unlock: Bracket_1_19'),
(2, 389, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=389): Ragefire Chasm | Unlock: Bracket_1_19');

/* ---------------------------------------------
   Bracket_20_29
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (34,47,90);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 34, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=34): Stormwind Stockades | Unlock: Bracket_20_29'),
(2, 47, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=47): Razorfen Kraul | Unlock: Bracket_20_29'),
(2, 90, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=90): Gnomeregan | Unlock: Bracket_20_29');

/* ---------------------------------------------
   Bracket_30_39
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (70,129,189);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 70,  1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=70): Uldaman | Unlock: Bracket_30_39'),
(2, 129, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=129): Razorfen Downs | Unlock: Bracket_30_39'),
(2, 189, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=189): Scarlet Monastery (all wings) | Unlock: Bracket_30_39');

/* ---------------------------------------------
   Bracket_40_49
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (109,209,349);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 109, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=109): Sunken Temple | Unlock: Bracket_40_49'),
(2, 209, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=209): Zul''Farrak | Unlock: Bracket_40_49'),
(2, 349, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=349): Maraudon (all wings) | Unlock: Bracket_40_49');

/* ---------------------------------------------
   Bracket_50_59_2
   (Using your original grouping for late-vanilla dungeons)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (230,429,229,289,329);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 230, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=230): Blackrock Depths | Unlock: Bracket_50_59_2'),
(2, 429, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=429): Dire Maul (all wings) | Unlock: Bracket_50_59_2'),
(2, 229, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=229): Blackrock Spire (LBRS/UBRS) | Unlock: Bracket_50_59_2'),
(2, 289, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=289): Scholomance | Unlock: Bracket_50_59_2'),
(2, 329, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=329): Stratholme | Unlock: Bracket_50_59_2');


/* =================================================================================================
   VANILLA RAID BRACKETS
================================================================================================= */

/* ---------------------------------------------
   Bracket_60_1_1
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (409);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 409, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=409): Molten Core | Unlock: Bracket_60_1_1');

/* ---------------------------------------------
   Bracket_60_2_1
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (469);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 469, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=469): Blackwing Lair | Unlock: Bracket_60_2_1');

/* ---------------------------------------------
   Bracket_60_2_2
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (309);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 309, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=309): Zul''Gurub | Unlock: Bracket_60_2_2');

/* ---------------------------------------------
   Bracket_60_3_1 and Bracket_60_3_2
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (509,531);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 509, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=509): Ruins of Ahn''Qiraj (AQ20) | Unlock: Bracket_60_3_1'),
(2, 531, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=531): Temple of Ahn''Qiraj (AQ40) | Unlock: Bracket_60_3_2');


/* =================================================================================================
   TBC BRACKETS
================================================================================================= */

/* ---------------------------------------------
   Bracket_61_64 (early Outland dungeons)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (542,543,546,547,557);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 542, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=542): The Blood Furnace | Unlock: Bracket_61_64'),
(2, 543, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=543): Hellfire Ramparts | Unlock: Bracket_61_64'),
(2, 546, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=546): The Underbog | Unlock: Bracket_61_64'),
(2, 547, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=547): The Slave Pens | Unlock: Bracket_61_64'),
(2, 557, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=557): Mana Tombs | Unlock: Bracket_61_64');

/* ---------------------------------------------
   Bracket_65_69 (mid Outland dungeons)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (269,556,558,560);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 269, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=269): The Black Morass | Unlock: Bracket_65_69'),
(2, 556, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=556): Sethekk Halls | Unlock: Bracket_65_69'),
(2, 558, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=558): Auchenai Crypts | Unlock: Bracket_65_69'),
(2, 560, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=560): Escape from Durnholde | Unlock: Bracket_65_69');

/* ---------------------------------------------
   Bracket_70_1_1 (level 70 normal dungeons)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (540,545,552,553,554,555);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 540, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=540): The Shattered Halls | Unlock: Bracket_70_1_1'),
(2, 545, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=545): The Steamvault | Unlock: Bracket_70_1_1'),
(2, 552, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=552): The Arcatraz | Unlock: Bracket_70_1_1'),
(2, 553, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=553): The Botanica | Unlock: Bracket_70_1_1'),
(2, 554, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=554): The Mechanar | Unlock: Bracket_70_1_1'),
(2, 555, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=555): Shadow Labyrinth | Unlock: Bracket_70_1_1');

/* ---------------------------------------------
   Bracket_70_2_1 (TBC Raid Tier 1: Gruul/Mag)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (544,565);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 544, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=544): Magtheridon''s Lair | Unlock: Bracket_70_2_1'),
(2, 565, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=565): Gruul''s Lair | Unlock: Bracket_70_2_1');

/* ---------------------------------------------
   Bracket_70_2_2 (Karazhan)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (532);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 532, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=532): Karazhan | Unlock: Bracket_70_2_2');

/* ---------------------------------------------
   Bracket_70_3_1 (Serpentshrine Cavern)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (548);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 548, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=548): Serpentshrine Cavern | Unlock: Bracket_70_3_1');

/* ---------------------------------------------
   Bracket_70_3_2 (The Eye / Tempest Keep)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (550);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 550, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=550): The Eye | Unlock: Bracket_70_3_2');

/* ---------------------------------------------
   Bracket_70_4_1 (Hyjal Summit)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (534);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 534, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=534): Hyjal Summit | Unlock: Bracket_70_4_1');

/* ---------------------------------------------
   Bracket_70_4_2 (Black Temple)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (564);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 564, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=564): Black Temple | Unlock: Bracket_70_4_2');

/* ---------------------------------------------
   Bracket_70_5 (Zul'Aman)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (568);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 568, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=568): Zul''Aman | Unlock: Bracket_70_5');

/* ---------------------------------------------
   Bracket_70_6_1 (Magisters' Terrace)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (585);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 585, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=585): Magisters'' Terrace | Unlock: Bracket_70_6_1');

/* ---------------------------------------------
   Bracket_70_6_2 (Sunwell Plateau)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (580);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 580, 1, '', '', '[mod-progression-blizzlike] Locked (Map, Id=580): Sunwell Plateau | Unlock: Bracket_70_6_2');


/* =================================================================================================
   WOTLK LEVELING BRACKETS
================================================================================================= */

/* ---------------------------------------------
   Bracket_71_74 (WotLK leveling dungeons - early Northrend)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (574,576,601,619);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 574, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=574): Utgarde Keep | Unlock: Bracket_71_74'),
(2, 576, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=576): The Nexus | Unlock: Bracket_71_74'),
(2, 601, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=601): Azjol-Nerub | Unlock: Bracket_71_74'),
(2, 619, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=619): Ahn''kahet: The Old Kingdom | Unlock: Bracket_71_74');

/* ---------------------------------------------
   Bracket_75_79 (WotLK leveling dungeons - mid Northrend)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (575,578,595,599,600,602,604,608);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 575, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=575): Utgarde Pinnacle | Unlock: Bracket_75_79'),
(2, 578, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=578): The Oculus | Unlock: Bracket_75_79'),
(2, 595, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=595): The Culling of Stratholme | Unlock: Bracket_75_79'),
(2, 599, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=599): Halls of Stone | Unlock: Bracket_75_79'),
(2, 600, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=600): Drak''Tharon Keep | Unlock: Bracket_75_79'),
(2, 602, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=602): Halls of Lightning | Unlock: Bracket_75_79'),
(2, 604, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=604): Gundrak | Unlock: Bracket_75_79'),
(2, 608, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=608): The Violet Hold | Unlock: Bracket_75_79');


/* =================================================================================================
   WOTLK ENDGAME BRACKETS (THIS IS THE PART YOU ASKED TO CLARIFY MOST)
================================================================================================= */

/* ---------------------------------------------
   Bracket_80_2_1 (T7 launch raids)
   Unlocks:
   - Naxxramas (533)
   - The Obsidian Sanctum (615)
   - The Eye of Eternity (616)
   - Vault of Archavon (624) OPTIONAL (your config says it can be enabled here)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (533,615,616,624);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 533, 3,  '', '', '[mod-progression-blizzlike] Locked (Map, Id=533): Naxxramas | Unlock: Bracket_80_2_1'),
(2, 615, 3,  '', '', '[mod-progression-blizzlike] Locked (Map, Id=615): The Obsidian Sanctum | Unlock: Bracket_80_2_1'),
(2, 616, 3,  '', '', '[mod-progression-blizzlike] Locked (Map, Id=616): The Eye of Eternity | Unlock: Bracket_80_2_1'),
(2, 624, 3,  '', '', '[mod-progression-blizzlike] Locked (Map, Id=624): Vault of Archavon (optional) | Unlock: Bracket_80_2_1');

/* ---------------------------------------------
   Bracket_80_2_2_1 (Ulduar unlock entry-point)
   Unlocks:
   - Ulduar (603)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (603);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 603, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=603): Ulduar | Unlock: Bracket_80_2_2_1');

/* ---------------------------------------------
   Bracket_80_3 (ToC era + Onyxia 80)
   Unlocks:
   - Trial of the Crusader (649)
   - Trial of the Champion (650)
   - Onyxia''s Lair (249) as level 80 content in your timeline
   - LK Statistic (13276) related to Onyxia 80
---------------------------------------------- */
DELETE FROM `disables` WHERE (`sourceType`=2 AND `entry` IN (249,649,650))
                        OR (`sourceType`=4 AND `entry` IN (13276));
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 249,   3,  '', '', '[mod-progression-blizzlike] Locked (Map, Id=249): Onyxia''s Lair (level 80 timeline) | Unlock: Bracket_80_3'),
(4, 13276, 0,  '', '', '[mod-progression-blizzlike] Locked (Statistic, Id=13276): Onyxia''s Lair LK Statistic | Unlock: Bracket_80_3'),
(2, 649,   15, '', '', '[mod-progression-blizzlike] Locked (Map, Id=649): Trial of the Crusader | Unlock: Bracket_80_3'),
(2, 650,   3,  '', '', '[mod-progression-blizzlike] Locked (Map, Id=650): Trial of the Champion | Unlock: Bracket_80_3');

/* ---------------------------------------------
   Bracket_80_3_2 (Frozen Halls 5-mans)
   Unlocks:
   - The Forge of Souls (632)
   - Pit of Saron (658)
   - Halls of Reflection (668)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (632,658,668);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 632, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=632): The Forge of Souls | Unlock: Bracket_80_3_2'),
(2, 658, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=658): Pit of Saron | Unlock: Bracket_80_3_2'),
(2, 668, 3, '', '', '[mod-progression-blizzlike] Locked (Map, Id=668): Halls of Reflection | Unlock: Bracket_80_3_2');

/* ---------------------------------------------
   Bracket_80_4_0 (ICC entry unlock; wing gating is handled elsewhere, e.g. phasing)
   Unlocks:
   - Icecrown Citadel (631)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (631);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 631, 15, '', '', '[mod-progression-blizzlike] Locked (Map, Id=631): Icecrown Citadel | Unlock: Bracket_80_4_0');

/* ---------------------------------------------
   Bracket_80_4_3 (WotLK epilogue)
   Unlocks:
   - The Ruby Sanctum (724)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (724);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(2, 724, 15, '', '', '[mod-progression-blizzlike] Locked (Map, Id=724): The Ruby Sanctum | Unlock: Bracket_80_4_3');


/* =================================================================================================
   RDF / LFG TELEPORT HARD LOCKS (sourceType=8)
   These are deny-by-default even if a map is enabled, to prevent teleporting into locked content.
   Delete the sourceType=8 row in the SAME bracket where you unlock the instance.
================================================================================================= */

DELETE FROM `disables` WHERE `sourceType`=8 AND `entry` IN (249,631,632,649,650,658,668);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(8, 249, 3,  '', '', '[mod-progression-blizzlike] Locked (RDF, MapId=249): Onyxia''s Lair | Unlock: Bracket_80_3'),
(8, 649, 15, '', '', '[mod-progression-blizzlike] Locked (RDF, MapId=649): Trial of the Crusader | Unlock: Bracket_80_3'),
(8, 650, 3,  '', '', '[mod-progression-blizzlike] Locked (RDF, MapId=650): Trial of the Champion | Unlock: Bracket_80_3'),
(8, 632, 3,  '', '', '[mod-progression-blizzlike] Locked (RDF, MapId=632): The Forge of Souls | Unlock: Bracket_80_3_2'),
(8, 658, 3,  '', '', '[mod-progression-blizzlike] Locked (RDF, MapId=658): Pit of Saron | Unlock: Bracket_80_3_2'),
(8, 668, 3,  '', '', '[mod-progression-blizzlike] Locked (RDF, MapId=668): Halls of Reflection | Unlock: Bracket_80_3_2'),
(8, 631, 15, '', '', '[mod-progression-blizzlike] Locked (RDF, MapId=631): Icecrown Citadel | Unlock: Bracket_80_4_0');


/* =================================================================================================
   QUEST LOCKS (sourceType=1)
================================================================================================= */

/* ---------------------------------------------
   Bracket_80_2_2 (Ulduar weekly)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=1 AND `entry` IN (24586);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(1, 24586, 0, '', '', '[mod-progression-blizzlike] Locked (Quest, Id=24586): Razorscale Must Die | Unlock: Bracket_80_2_2');

/* ---------------------------------------------
   Bracket_80_4_3 (Ruby Sanctum quest)
---------------------------------------------- */
DELETE FROM `disables` WHERE `sourceType`=1 AND `entry` IN (26013);
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(1, 26013, 0, '', '', '[mod-progression-blizzlike] Locked (Quest, Id=26013): Assault on the Sanctum | Unlock: Bracket_80_4_3');


/* =================================================================================================
   OPTIONAL: WOTLK UNLOCK TEMPLATES (COPY/PASTE INTO EACH BRACKET SQL)
   (These are the exact deletes you would put inside the bracket folder to enable content.)
================================================================================================= */

-- Bracket_80_2_1 (T7)
-- DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (533,615,616,624);

-- Bracket_80_2_2_1 (Ulduar entry)
-- DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (603);
-- Bracket_80_2_2 (Ulduar weekly)
-- DELETE FROM `disables` WHERE `sourceType`=1 AND `entry` IN (24586);

-- Bracket_80_3 (ToC + Onyxia 80)
-- DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (249,649,650);
-- DELETE FROM `disables` WHERE `sourceType`=4 AND `entry` IN (13276);
-- DELETE FROM `disables` WHERE `sourceType`=8 AND `entry` IN (249,649,650);

-- Bracket_80_3_2 (Frozen Halls)
-- DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (632,658,668);
-- DELETE FROM `disables` WHERE `sourceType`=8 AND `entry` IN (632,658,668);

-- Bracket_80_4_0 (ICC access)
-- DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (631);
-- DELETE FROM `disables` WHERE `sourceType`=8 AND `entry` IN (631);

-- Bracket_80_4_3 (Ruby Sanctum)
-- DELETE FROM `disables` WHERE `sourceType`=2 AND `entry` IN (724);
-- DELETE FROM `disables` WHERE `sourceType`=1 AND `entry` IN (26013);
