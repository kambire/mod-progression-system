-- Bracket 80_2_2_1: Fase base + Ala de asedio (FL/Ignis/Razor/XT)
-- Se usa phaseMask=0 como deny-by-default; cada etapa abre sus jefes con phaseMask=1.

-- Oculta todos los jefes de Ulduar hasta que cada etapa los habilite.
UPDATE `creature` SET `phaseMask` = 0 WHERE `id1` IN (
  33113, -- Flame Leviathan
  33118, -- Ignis the Furnace Master
  33186, -- Razorscale
  33293, -- XT-002 Deconstructor
  32867, -- Steelbreaker (Assembly of Iron)
  32927, -- Runemaster Molgeim (Assembly of Iron)
  32857, -- Stormcaller Brundir (Assembly of Iron)
  32930, -- Kologarn
  33515, -- Auriaya
  32845, -- Hodir
  32865, -- Thorim
  32906, -- Freya
  33350, -- Mimiron
  33271, -- General Vezax
  33288, -- Yogg-Saron
  32871  -- Algalon the Observer
);

-- Etapa 1: abrir Ala de asedio.
UPDATE `creature` SET `phaseMask` = 1 WHERE `id1` IN (
  33113, -- Flame Leviathan
  33118, -- Ignis the Furnace Master
  33186, -- Razorscale
  33293  -- XT-002 Deconstructor
);
