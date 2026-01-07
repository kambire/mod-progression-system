-- 80_4_1: abre Peste y Cripta Carmesí en ICC.
UPDATE `creature` SET `phaseMask` = 1 WHERE `id1` IN (
  36626, -- Festergut
  36627, -- Rotface
  36678, -- Professor Putricide
  37972, -- Prince Keleseth
  37973, -- Prince Taldaram
  37970, -- Prince Valanar
  37955  -- Blood-Queen Lana'thel
);
