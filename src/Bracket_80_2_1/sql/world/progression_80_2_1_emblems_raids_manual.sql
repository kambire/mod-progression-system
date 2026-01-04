/* ============================================================
   T7 Emblems fix (Bracket 80_2_1)
   - 10-man: Emblem of Heroism (40752)
   - 25-man: Emblem of Valor   (40753)

   Afecta:
   - Naxxramas (bosses que listaste)
   - Obsidian Sanctum (Sartharion + drakes)
   - Eye of Eternity (Malygos)
   - Vault of Archavon (Archavon)  [si lo usas en T7]
   - Reference loot usado por Sartharion 25: reference 34349

   Navicat/MySQL 8.x safe, sin variables.
   ============================================================ */

/* 1) BACKUP de filas afectadas (loot directo + referencias) */
DROP TABLE IF EXISTS backupKambi_T7Emblems_20260104_creature_loot_template;
CREATE TABLE backupKambi_T7Emblems_20260104_creature_loot_template AS
SELECT *
FROM creature_loot_template
WHERE
  (Entry IN (
    -- NAXX 10
    15956,15932,16060,15953,15931,15936,16061,15990,16011,15952,15954,16028,15989,15928,
    -- NAXX 25
    29249,29417,29955,29268,29373,29701,29940,30061,29718,29278,29615,29324,29991,29448,

    -- OS 10
    28860,30451,30452,30449,
    -- OS 25
    31311,31520,31534,31535,

    -- EOE 10/25
    28859,31734,

    -- VOA 10/25 (opcional)
    31125,31722
  )
  AND Item IN (40752,40753,47241))
  OR
  (Entry IN (
    -- si el boss usa reference, lo cubrimos también
    31311
  )
  AND Reference IN (34349));

DROP TABLE IF EXISTS backupKambi_T7Emblems_20260104_reference_loot_template;
CREATE TABLE backupKambi_T7Emblems_20260104_reference_loot_template AS
SELECT *
FROM reference_loot_template
WHERE Entry IN (34349)
  AND Item IN (40752,40753,47241);

/* 2) Asegurar que NO existan duplicados raros (opcional pero sano)
      (No borramos nada, solo vamos a normalizar Item en updates) */


/* 3) DEFINIR listas de Entry 10 y 25 (según tus IDs “buenos”) */

/* --- 3a) 10-man entries: deben quedar en 40752 (Heroism) --- */
UPDATE creature_loot_template
SET Item = 40752
WHERE Entry IN (
  -- NAXX 10
  15956,15932,16060,15953,15931,15936,16061,15990,16011,15952,15954,16028,15989,15928,
  -- OS 10
  28860,30451,30452,30449,
  -- EOE 10
  28859,
  -- VOA 10 (opcional)
  31125
)
AND Item IN (40753,47241);

/* Si por algún motivo existiera Triumph en un reference usado por 10-man (raro), lo cubrimos:
   (No debería tocar nada si 10-man no usa reference 34349) */
UPDATE reference_loot_template
SET Item = 40752
WHERE Entry IN (34349)
  AND Item IN (47241)
  AND Entry IN (34349); -- solo para dejar explícito


/* --- 3b) 25-man entries: deben quedar en 40753 (Valor) --- */
UPDATE creature_loot_template
SET Item = 40753
WHERE Entry IN (
  -- NAXX 25
  29249,29417,29955,29268,29373,29701,29940,30061,29718,29278,29615,29324,29991,29448,
  -- OS 25
  31311,31520,31534,31535,
  -- EOE 25
  31734,
  -- VOA 25 (opcional)
  31722
)
AND Item IN (40752,47241);

/* 4) FIX para el reference de Sartharion 25 (REFERENCE(34349))
      Lo que esté en Triumph dentro del reference debe pasar a Valor */
UPDATE reference_loot_template
SET Item = 40753
WHERE Entry = 34349
  AND Item = 47241;


/* 5) VERIFICACIÓN: mostrar qué emblemas quedan por boss/dificultad */
SELECT
  clt.Entry,
  ct.name AS boss_name,
  clt.Item AS emblem_item,
  it.name AS emblem_name,
  clt.MinCount,
  clt.MaxCount,
  clt.Chance,
  clt.Reference
FROM creature_loot_template clt
JOIN creature_template ct ON ct.entry = clt.Entry
JOIN item_template it ON it.entry = clt.Item
WHERE clt.Entry IN (
  15956,15932,16060,15953,15931,15936,16061,15990,16011,15952,15954,16028,15989,15928,
  29249,29417,29955,29268,29373,29701,29940,30061,29718,29278,29615,29324,29991,29448,
  28860,30451,30452,30449,
  31311,31520,31534,31535,
  28859,31734,
  31125,31722
)
AND clt.Item IN (40752,40753,47241)
ORDER BY clt.Entry, clt.Item;

SELECT
  rlt.Entry AS reference_entry,
  rlt.Item AS emblem_item,
  it.name AS emblem_name,
  rlt.MinCount,
  rlt.MaxCount,
  rlt.Chance
FROM reference_loot_template rlt
JOIN item_template it ON it.entry = rlt.Item
WHERE rlt.Entry = 34349
  AND rlt.Item IN (40752,40753,47241)
ORDER BY rlt.Item;
