# 🚀 COMPLETAR E IMPLEMENTAR SQL SCRIPTS

**Estatus**: Templates listos (blizzlike), necesitas completarlos con tus IDs reales

---

## 📍 Ubicación de Scripts

Todos los scripts templates están en sus carpetas correctas:

```
src/Bracket_70_2_1/sql/world/vendors_cleanup_s1.sql
src/Bracket_70_2_2/sql/world/vendors_cleanup_s2.sql
src/Bracket_70_5/sql/world/vendors_cleanup_s3.sql
src/Bracket_70_6_2/sql/world/vendors_cleanup_s4.sql
src/Bracket_80_1_2/sql/world/vendors_cleanup_s5.sql
src/Bracket_80_1_2/sql/world/vendors_transition_tbc_to_wotlk.sql
src/Bracket_80_2/sql/world/vendors_cleanup_s6.sql
src/Bracket_80_3/sql/world/vendors_cleanup_s7.sql
src/Bracket_80_4_1/sql/world/vendors_cleanup_s8.sql
```

---

## 🔍 PASO 1: Encontrar IDs en tu Base de Datos

Ejecuta estas queries en MySQL para obtener los IDs necesarios.

> Nota blizzlike (AzerothCore): los costes de PvP/Arena se controlan por `npc_vendor.ExtendedCost` (tabla `item_extended_cost`).
> Los templates nuevos usan `npc_vendor.item` + `ExtendedCost` (NO oro).

### Query 1: Encontrar vendors de Arena/PvP (entries)
```sql
-- Busca vendors por nombre (ajusta el LIKE a tu idioma/DB)
SELECT entry, name
FROM creature_template
WHERE name LIKE '%Gladiator%'
  OR name LIKE '%Arena%'
  OR name LIKE '%PvP%'
LIMIT 50;
```

### Query 2: Validar entries conocidos (WotLK típico)
```sql
SELECT entry, name
FROM creature_template
WHERE entry IN (33609, 33610);
```

### Query 3: Ver qué vende un vendor (para confirmar)
```sql
SELECT v.entry, v.item, it.name, v.ExtendedCost
FROM npc_vendor v
JOIN item_template it ON it.entry = v.item
WHERE v.entry IN (33609, 33610)
ORDER BY v.entry, v.item
LIMIT 200;
```

### Query 4: Items por Season (ejemplos, ajusta nombres según tu DB)

```sql
-- TBC Season 1 (Gladiator)
SELECT entry, name FROM item_template WHERE name LIKE '%Gladiator%' ORDER BY entry;

-- TBC Season 2 (Merciless)
SELECT entry, name FROM item_template WHERE name LIKE '%Merciless%' ORDER BY entry;

-- TBC Season 3 (Vengeful)
SELECT entry, name FROM item_template WHERE name LIKE '%Vengeful%' ORDER BY entry;

-- TBC Season 4 (Brutal)
SELECT entry, name FROM item_template WHERE name LIKE '%Brutal%' ORDER BY entry;

-- WotLK Season 5 (Deadly)
SELECT entry, name FROM item_template WHERE name LIKE '%Deadly%' ORDER BY entry;

-- WotLK Season 6 (Furious)
SELECT entry, name FROM item_template WHERE name LIKE '%Furious%' ORDER BY entry;

-- WotLK Season 7 (Relentless)
SELECT entry, name FROM item_template WHERE name LIKE '%Relentless%' ORDER BY entry;

-- WotLK Season 8 (Wrathful)
SELECT entry, name FROM item_template WHERE name LIKE '%Wrathful%' ORDER BY entry;

-- Si tu DB usa otros nombres o idioma distinto, ajusta los LIKE.
-- Lo importante es construir listas S1_ITEM_IDS ... S8_ITEM_IDS con los IDs correctos.

### Query 5: Encontrar ExtendedCost IDs (costes) para PvP/Arena
```sql
-- Busca ExtendedCost usados por tus vendors actuales
SELECT DISTINCT v.ExtendedCost
FROM npc_vendor v
WHERE v.entry IN (33609, 33610)
ORDER BY v.ExtendedCost;

-- Inspecciona detalles del extended cost
SELECT *
FROM item_extended_cost
WHERE id IN (
  SELECT DISTINCT v.ExtendedCost
  FROM npc_vendor v
  WHERE v.entry IN (33609, 33610)
)
ORDER BY id;
```
```

---

## ✏️ PASO 2: Completar los Templates

### Formato del Script Completado

```sql
-- Ejemplo: vendors_cleanup_s1.sql

DELETE FROM `npc_vendor`
WHERE `entry` IN (33609, 33610)  -- REEMPLAZAR CON TUS ENTRIES
  AND `item` NOT IN (
    23001,23002,23003,23004,23005,23006,23007,23008,23009,23010,  -- 10
    23011,23012,23013,23014,23015,23016,23017,23018,23019,23020,  -- 20
    23021,23022,23023,23024,23025,23026,23027,23028,23029,23030,  -- 30
    23031,23032,23033,23034,23035,23036,23037,23038,23039,23040,  -- 40
    23041,23042,23043,23044,23045,23046,23047,23048,23049,23050,  -- 50
    23051,23052,23053,23054,23055,23056,23057,23058,23059,23060   -- 60
  );

INSERT INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`)
VALUES
  (33609, 0, 23001, 0, 0, 1234, 0),
  (33609, 0, 23002, 0, 0, 1234, 0),
  (33610, 0, 23003, 0, 0, 1234, 0),
  -- ... 60 items total ...
  (33610, 0, 23060, 0, 0, 1234, 0)
;
```

---

## 📋 Checklist de Reemplazos

### Vendors (entries) por Season

-- [ ] **Reemplazar `[S1_VENDOR_ENTRIES]`, `[S2_VENDOR_ENTRIES]`, ...**
  - En: todos los `vendors_cleanup_s*.sql`
  - Con: entries reales (Horde/Alliance) de tu DB
  - Ejemplo WotLK típico: `33609, 33610`

- [ ] **Reemplazar `[S1_ITEM_IDS]`**
  - En: vendors_cleanup_s1.sql, s2.sql, s3.sql, s4.sql
  - Con: IDs de Gladiator items (Season 1-2)
  - Cantidad: ~60 items

- [ ] **Reemplazar `[S2_ITEM_IDS]`**
  - En: vendors_cleanup_s2.sql, s3.sql, s4.sql
  - Con: IDs de Gladiator items (Season 2)
  - Cantidad: ~60 items

- [ ] **Reemplazar `[S3_ITEM_IDS]`**
  - En: vendors_cleanup_s3.sql, s4.sql
  - Con: IDs de Hateful items
  - Cantidad: ~60 items

- [ ] **Reemplazar `[S4_ITEM_IDS]`**
  - En: vendors_cleanup_s4.sql
  - Con: IDs de Brutal items
  - Cantidad: ~60 items

### ExtendedCost (blizzlike)

- [ ] **Reemplazar placeholders `*_WITH_EXTENDEDCOST_*`**
  - En: todos los `vendors_cleanup_s*.sql`
  - Con: líneas INSERT reales que incluyan el `ExtendedCost` correcto
  - Fuente: Query 5 (item_extended_cost) o valores ya usados por tu core

- [ ] **Reemplazar `[S5_ITEM_IDS]`**
  - En: vendors_cleanup_s5.sql, s6.sql, s7.sql, s8.sql
  - Con: IDs de Wrathful items (Season 5)
  - Cantidad: ~60 items

- [ ] **Reemplazar `[S6_ITEM_IDS]`**
  - En: vendors_cleanup_s6.sql, s7.sql, s8.sql
  - Con: IDs de Wrathful items (Season 6)
  - Cantidad: ~60 items

- [ ] **Reemplazar `[S7_ITEM_IDS]`**
  - En: vendors_cleanup_s7.sql, s8.sql
  - Con: IDs de Vindictive items
  - Cantidad: ~60 items

- [ ] **Reemplazar `[S8_ITEM_IDS]`**
  - En: vendors_cleanup_s8.sql
  - Con: IDs de Relentless items
  - Cantidad: ~60 items

---

## 🔗 Transición TBC → WotLK

- [ ] **Reemplazar `[TBC_VENDOR_ENTRIES]` y `[WOTLK_VENDOR_ENTRIES]`**
  - En: `vendors_transition_tbc_to_wotlk.sql`
  - Con: entries reales que quieras desactivar/activar

---

## ⚡ PASO 3: Ejecutar en Servidor

### Opción 1: Copiar a servidor (automático)
```bash
# Los scripts se cargarán automáticamente si están en las carpetas correctas
# Al reiniciar el servidor o ejecutar update
```

### Opción 2: Ejecutar manualmente
```sql
-- Conectarse a MySQL y ejecutar:
mysql world < src/Bracket_70_2_1/sql/world/vendors_cleanup_s1.sql
mysql world < src/Bracket_70_2_2/sql/world/vendors_cleanup_s2.sql
-- ... etc ...
```

### Opción 3: Copiar scripts a updates
```bash
cp src/Bracket_*/sql/world/vendors_*.sql ~/path/to/updates/
# El updater de AzerothCore los ejecutará automáticamente
```

---

## ✅ PASO 4: Validar en Juego

```
[ ] Entra al bracket correspondiente y verifica:
  - Vendors correctos (Horde/Alliance)
  - Solo items de la season permitida
  - Costes correctos (Arena Points/Honor/Rating según tu core)

[ ] Entra a Bracket_70_2_2 y verifica:
    - Vendor visible en Gadgetzan
    - Items de S1 (100k) y S2 (200k)
    - Total ~120 items

[ ] Entra a Bracket_80_1_2 y verifica:
    - Gadgetzan vendor desaparecido
    - Nuevo vendor en Dalaran
    - Solo items S5

[ ] Entra a Bracket_80_4_1 y verifica:
    - Todos los items disponibles
    - Precios correctos
```

---

## 📝 Resumen Rápido

| Paso | Acción | Tiempo |
|------|--------|--------|
| 1 | Ejecutar 6 queries en BD | 5 min |
| 2 | Completar 9 templates SQL | 30 min |
| 3 | Copiar scripts al servidor | 5 min |
| 4 | Reiniciar worldserver (si aplica) | 2 min |
| 5 | Validar en juego | 15 min |
| **Total** | | **57 minutos** |

---

## 🎯 Archivos Importantes

- **README.md** - Documentación completa
- **PARAMETROS_TECNICOS_DESARROLLO.md** - Configuración técnica
- **BRACKET_DESCRIPTIONS_COMPLETE.md** - Descripción de brackets
- **ARENA_SEASONS_VALIDATION.md** - Mapeo de seasons

---

**¿Necesitas ayuda?** Consulta README.md sección "FASE 0 - Control Total de Vendors"
