-- 80_4_0: abre Bastion Inferior de ICC.
UPDATE `creature` SET `phaseMask` = 1 WHERE `id1` IN (
  36612, -- Lord Marrowgar
  36855, -- Lady Deathwhisper
  37813, -- Deathbringer Saurfang (Horda)
  36939  -- Muradin Bronzebeard (Alianza)
);
