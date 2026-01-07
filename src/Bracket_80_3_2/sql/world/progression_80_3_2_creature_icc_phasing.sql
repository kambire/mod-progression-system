-- Fase base ICC: ocultar todos los jefes de la raid hasta que cada bracket los habilite.
-- Se usa phaseMask=0 como deny-by-default. Aperturas progresivas en 80_4_0/1/2/3.

UPDATE `creature` SET `phaseMask` = 0 WHERE `id1` IN (
  36612, -- Lord Marrowgar
  36855, -- Lady Deathwhisper
  37813, -- Deathbringer Saurfang (Horda)
  36939, -- Muradin Bronzebeard (Alianza)
  36626, -- Festergut
  36627, -- Rotface
  36678, -- Professor Putricide
  37972, -- Prince Keleseth
  37973, -- Prince Taldaram
  37970, -- Prince Valanar
  37955, -- Blood-Queen Lana'thel
  36789, -- Valithria Dreamwalker
  36853, -- Sindragosa
  36597  -- The Lich King
);
