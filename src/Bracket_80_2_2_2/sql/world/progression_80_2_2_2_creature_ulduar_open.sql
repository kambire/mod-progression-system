-- Etapa incluye apertura acumulada (Ala de asedio + Antecámara).

-- Oculta todos los jefes de Ulduar antes de abrir el tramo correspondiente.
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

-- Abrir Ala de asedio (etapa previa).
UPDATE `creature` SET `phaseMask` = 1 WHERE `id1` IN (
  33113, -- Flame Leviathan
  33118, -- Ignis the Furnace Master
  33186, -- Razorscale
  33293  -- XT-002 Deconstructor
);

-- Abrir Antecámara.
UPDATE `creature` SET `phaseMask` = 1 WHERE `id1` IN (
  32867, -- Steelbreaker (Assembly of Iron)
  32927, -- Runemaster Molgeim (Assembly of Iron)
  32857, -- Stormcaller Brundir (Assembly of Iron)
  32930, -- Kologarn
  33515  -- Auriaya
);
