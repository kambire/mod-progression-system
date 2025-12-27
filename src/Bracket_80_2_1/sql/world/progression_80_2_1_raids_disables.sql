-- Bracket 80_2_1 (WotLK T7): unlock launch raids
-- Content: Naxxramas (533), Obsidian Sanctum (615), Eye of Eternity (616)
-- Optional: Vault of Archavon (624) is left untouched here.

DELETE FROM `disables` WHERE `sourceType` = 2 AND `entry` IN (533, 616, 615);
