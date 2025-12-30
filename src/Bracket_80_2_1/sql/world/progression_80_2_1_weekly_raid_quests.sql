-- ProgressionSystem - weekly raid quests emblem reward (Bracket_80_2_1)
-- Goal:
--   Normalize weekly raid quest emblem rewards to match this bracket's progression.
--
-- Weekly raid quest IDs (Archmage Lan'dalock):
-- 24579 Sartharion Must Die!
-- 24580 Anub'Rekhan Must Die!
-- 24581 Noth the Plaguebringer Must Die!
-- 24582 Instructor Razuvious Must Die!
-- 24583 Patchwerk Must Die!
-- 24584 Malygos Must Die!
-- 24585 Flame Leviathan Must Die!
-- 24586 Razorscale Must Die!
-- 24587 Ignis the Furnace Master Must Die!
-- 24588 XT-002 Deconstructor Must Die!
-- 24589 Lord Jaraxxus Must Die!
-- 24590 Lord Marrowgar Must Die!
--
-- Emblem item IDs (WotLK):
-- Heroism  40752
-- Valor    40753
-- Conquest 45624
-- Triumph  47241
-- Frost    49426
--
-- MySQL: 8.x compatible.

SET @TARGET_EMBLEM := 40752; -- Heroism

UPDATE `quest_template`
SET
  `RewardItem1` = @TARGET_EMBLEM,
  `RewardAmount1` = IF(`RewardAmount1` > 0, `RewardAmount1`, 5),
  `RewardItem2` = IF(`RewardItem2` IN (40752,40753,45624,47241,49426), 0, `RewardItem2`),
  `RewardAmount2` = IF(`RewardItem2` IN (40752,40753,45624,47241,49426), 0, `RewardAmount2`),
  `RewardItem3` = IF(`RewardItem3` IN (40752,40753,45624,47241,49426), 0, `RewardItem3`),
  `RewardAmount3` = IF(`RewardItem3` IN (40752,40753,45624,47241,49426), 0, `RewardAmount3`),
  `RewardItem4` = IF(`RewardItem4` IN (40752,40753,45624,47241,49426), 0, `RewardItem4`),
  `RewardAmount4` = IF(`RewardItem4` IN (40752,40753,45624,47241,49426), 0, `RewardAmount4`)
WHERE `ID` IN (24579,24580,24581,24582,24583,24584,24585,24586,24587,24588,24589,24590);

