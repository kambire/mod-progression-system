-- 80_4_2: abre Ala Gélida en ICC.
UPDATE `creature` SET `phaseMask` = 1 WHERE `id1` IN (
  36789, -- Valithria Dreamwalker
  36853  -- Sindragosa
);
