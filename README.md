# 🎮 Progression System Module - AzerothCore

**Control total de progresión del servidor WoW - 38 brackets, 3 expansiones, 8 arena seasons**

[![License](https://img.shields.io/badge/license-GPL%203.0-blue.svg)](LICENSE)
[![AzerothCore](https://img.shields.io/badge/AzerothCore-3.3.5a-brightgreen.svg)](https://www.azerothcore.org/)
[![C++](https://img.shields.io/badge/C%2B%2B-17-green.svg)]()
[![SQL](https://img.shields.io/badge/Database-MySQL-orange.svg)]()

---

## 📋 Descripción General

Sistema modular de progresión para AzerothCore que permite liberar contenido de forma gradual, replicando exactamente el timeline de expansiones de World of Warcraft de **Noviembre 2004 a Junio 2010**.

**Características**:
- ✅ **Carga dinámica sin recompilación** - Cambia timeline solo con configuración
- ✅ 38 brackets independientes (Vanilla, TBC, WotLK)
- ✅ 8 Arena Seasons integradas (S1-S8)
- ✅ Control granular de vendors por season
- ✅ Bloqueo automático de contenido futuro
- ✅ Carga de SQL y scripts dinámicos por bracket
- ✅ Sistema de configuración centralizado

---

## 🚀 Quick Start

1. **Clone the module**:
```bash
cd ~/azerothcore-wotlk/modules
git clone https://github.com/kambire/mod-progression-blizzlike.git
```

2. **Compile** (one-time only):
```bash
cd ~/azerothcore-wotlk/build
make -j$(nproc)
```

3. **Configure brackets**:
```bash
cd ~/azerothcore-wotlk/etc/modules
cp mod-progression-blizzlike/conf/progression_system.conf.dist progression_system.conf
nano progression_system.conf
# Enable desired brackets
```

4. **Restart server** - Changes take effect immediately, no recompilation needed!

5. **Verify**:
```
.progression status   # In-game command to see active brackets
```

📖 **[Read the Dynamic Loading Guide](DYNAMIC_LOADING.md)** for detailed architecture explanation

---

## 🎯 Características Principales

### 1. Control Total de Vendors por Bracket
Sistema automático que asegura que jugadores solo vean items de su season actual:
- Los vendors se controlan por **NPC entry** (Horde/Alliance) y se limitan por season
- El coste blizzlike se aplica con **`npc_vendor.ExtendedCost`** (Arena Points/Honor/Rating según tu core)
- La ubicación exacta de vendors puede variar por DB (en WotLK suele ser Orgrimmar/Stormwind)
- La activación/desactivación se realiza removiendo/agregando el flag de vendor (`npcflag` bit 128)

### 2. Bloqueadores de Contenido
- Restricción automática de acceso a dungeons/raids del futuro
- Validación de nivel y atunement por bracket
- Prevención de compra de items no autorizados
- Sistema de restricción de recompensas PvP

### 3. Configuración Flexible
```ini
# Activar/desactivar brackets por nombre
ProgressionSystem.Bracket_70_2_1 = 1           # Arena S1 activo
ProgressionSystem.Bracket_80_4_1 = 0           # Arena S8 desactivado

# Nota: el módulo carga SQL por bracket. La lógica de vendors/arena se define en SQL.
```

---

## 📦 Estructura del Proyecto

```
mod-progression-blizzlike/
├── conf/
│   ├── progression_system.conf.dist       # Config principal
│   └── conf.sh.dist                       # Template bash
├── src/
│   ├── ProgressionSystem.h                # Estructura C++
│   ├── ProgressionSystem.cpp              # Implementación
│   ├── cs_progression_module.cpp          # Módulo de carga
│   ├── ProgressionSystem_loader.cpp       # Loader dinámico
│   └── Bracket_*/
│       ├── Bracket_*_loader.cpp           # Scripts de bracket
│       └── sql/
│           ├── world/                     # Cambios del mundo
│           ├── characters/                # Cambios de personajes
│           └── auth/                      # Cambios de autenticación
├── scripts/
│   └── local_release.ps1                  # Deploy script
└── README.md                              # Este archivo
```

---

## 🚀 Instalación Rápida

### 1. Clonar el módulo
```bash
cd ~/azerothcore-wotlk/modules
git clone https://github.com/tu-usuario/mod-progression-blizzlike.git
```

### 2. Configurar brackets
```bash
cd mod-progression-blizzlike/conf
cp progression_system.conf.dist progression_system.conf
# Editar progression_system.conf y activar brackets deseados
```

### 3. Compilar AzerothCore
```bash
cd ~/azerothcore-wotlk
./acore.sh client install
# Compilación automática incluye el módulo
```

### 4. Ejecutar actualización de BD
```sql
-- Los scripts SQL se cargan automáticamente
-- Cada bracket activo carga: world, characters, auth
```

### 5. Iniciar servidor y verificar
```bash
# En consola del servidor
.server info
# Debe mostrar módulos cargados
```

---

## 🧰 Producción (recomendado)

- Guía paso a paso: ver [PRODUCTION.md](PRODUCTION.md)
- Empaquetado/validación en Windows: `powershell -ExecutionPolicy Bypass -File .\scripts\production_package.ps1`

---

## 📊 Brackets Disponibles (38 Total)

### Vanilla (14 brackets - Nov 2004 a Jan 2005)
| Bracket | Nivel | Contenido | Fecha Release |
|---------|-------|-----------|---------------|
| **Bracket_0** | 1-10 | Zonas iniciales | Nov 23, 2004 |
| **Bracket_1_19** | 11-19 | Dungeons tempranos | Nov 23, 2004 |
| **Bracket_20_29** | 20-29 | Dungeons medianos | Nov 23, 2004 |
| **Bracket_30_39** | 30-39 | Dungeons avanzados | Nov 23, 2004 |
| **Bracket_40_49** | 40-49 | World dungeons | Nov 23, 2004 |
| **Bracket_50_59_1** | 50-59 | UBRS Attunement | Nov 23, 2004 |
| **Bracket_50_59_2** | 50-59 | Upper Blackrock | Nov 23, 2004 |
| **Bracket_60_1_1** | 60 | Molten Core | Nov 23, 2004 |
| **Bracket_60_1_2** | 60 | Onyxia | Nov 23, 2004 |
| **Bracket_60_2_1** | 60 | Blackwing Lair | Jan 19, 2005 |
| **Bracket_60_2_2** | 60 | Zul'Gurub | Jan 19, 2005 |
| **Bracket_60_3_1** | 60 | Ruins AQ | Jan 19, 2005 |
| **Bracket_60_3_2** | 60 | Temple AQ | Jan 19, 2005 |
| **Bracket_60_3_3** | 60 | AQ Final Phase | Jan 19, 2005 |

### The Burning Crusade (15 brackets - Jan 2007 a May 2008) + Arena S1-S4
| Bracket | Nivel | Arena | Contenido | Fecha |
|---------|-------|-------|-----------|-------|
| **Bracket_61_64** | 61-64 | - | Outland Intro | Jan 16, 2007 |
| **Bracket_65_69** | 65-69 | - | Mid-Level | Jan 16, 2007 |
| **Bracket_70_1_1** | 70 | - | Dungeons | Jan 16, 2007 |
| **Bracket_70_1_2** | 70 | - | Heroic Dungeons | Jan 16, 2007 |
| **Bracket_70_2_1** | 70 | **S1** | Gruul's/Magtheridon | Jan 16, 2007 |
| **Bracket_70_2_2** | 70 | **S2** | Karazhan | May 15, 2007 |
| **Bracket_70_3_1** | 70 | - | SSC Intro | May 15, 2007 |
| **Bracket_70_3_2** | 70 | **S2** | The Eye | May 15, 2007 |
| **Bracket_70_4_1** | 70 | - | Mount Hyjal | Aug 24, 2007 |
| **Bracket_70_4_2** | 70 | - | Black Temple | Sep 24, 2007 |
| **Bracket_70_5** | 70 | **S3** | Zul'Aman | Dec 11, 2007 |
| **Bracket_70_6_1** | 70 | - | Île Quel'Danas | May 22, 2008 |
| **Bracket_70_6_2** | 70 | **S4** | Sunwell Plateau | May 22, 2008 |
| **Bracket_70_6_3** | 70 | - | TBC Final | May 22, 2008 |

### Wrath of the Lich King (9 brackets - Nov 2008 a Jun 2010) + Arena S5-S8
| Bracket | Nivel | Arena | Contenido | Fecha |
|---------|-------|-------|-----------|-------|
| **Bracket_71_74** | 71-74 | - | Northrend Intro | Nov 13, 2008 |
| **Bracket_75_79** | 75-79 | - | Mid-Level | Nov 13, 2008 |
| **Bracket_80_1_1** | 80 | - | Dungeons | Nov 13, 2008 |
| **Bracket_80_1_2** | 80 | **S5** | Heroic Dungeons | Nov 13, 2008 |
| **Bracket_80_2** | 80 | **S6** | T7 (Naxx/OS/EoE) + Ulduar | Mar 17, 2009 |
| **Bracket_80_3** | 80 | **S7** | Trial/Coliseum | Aug 4, 2009 |
| **Bracket_80_4_1** | 80 | **S8** | Icecrown Citadel | Dec 8, 2009 |
| **Bracket_80_4_2** | 80 | - | Ruby Sanctum | Jun 29, 2010 |
| **Bracket_Custom** | - | - | Contenido personalizado | - |

---

## 🎮 Arena Seasons - Detalles Completos

### Season 1-4 (TBC)
| Season | Bracket | Período | Calificación | Gear | Coste (blizzlike) |
|--------|---------|---------|--------------|------|------------------|
| **S1** | 70_2_1 | (aprox) 2007 | (según `ExtendedCost`) | Gladiator | `ExtendedCost` (Arena Points/Honor/Rating) |
| **S2** | 70_2_2 | (aprox) 2007 | (según `ExtendedCost`) | Merciless | `ExtendedCost` (nuevo + legacy) |
| **S3** | 70_5 | (aprox) 2007-2008 | (según `ExtendedCost`) | Vengeful | `ExtendedCost` (nuevo + legacy) |
| **S4** | 70_6_2 | (aprox) 2008 | (según `ExtendedCost`) | Brutal | `ExtendedCost` (nuevo + legacy) |

### Season 5-8 (WotLK)
| Season | Bracket | Período | Calificación | Gear | Coste (blizzlike) |
|--------|---------|---------|--------------|------|------------------|
| **S5** | 80_1_2 | (aprox) 2008-2009 | (según `ExtendedCost`) | Deadly | `ExtendedCost` (nuevo) |
| **S6** | 80_2 | (aprox) 2009 | (según `ExtendedCost`) | Furious | `ExtendedCost` (nuevo + legacy) |
| **S7** | 80_3 | (aprox) 2009-2010 | (según `ExtendedCost`) | Relentless | `ExtendedCost` (nuevo + legacy) |
| **S8** | 80_4_1 | (aprox) 2010 | (según `ExtendedCost`) | Wrathful | `ExtendedCost` (nuevo + legacy) |

---

## ⚙️ Configuración Detallada

### Parámetros Principales

```ini
# Carga de scripts/SQL por bracket
ProgressionSystem.LoadScripts = 1
ProgressionSystem.LoadDatabase = 1

# Opcional: re-aplicar SQL en cada arranque (más lento)
ProgressionSystem.ReapplyUpdates = 0
```

### Habilitar Brackets por Nombre

```ini
# VANILLA
ProgressionSystem.Bracket_0 = 1
ProgressionSystem.Bracket_1_19 = 1
# ... etc para todos los brackets

# TBC CON ARENAS
ProgressionSystem.Bracket_70_2_1 = 1  # Arena S1
ProgressionSystem.Bracket_70_2_2 = 1  # Arena S2
ProgressionSystem.Bracket_70_5 = 1    # Arena S3
ProgressionSystem.Bracket_70_6_2 = 1  # Arena S4

# WOTLK CON ARENAS
ProgressionSystem.Bracket_80_1_2 = 1  # Arena S5
ProgressionSystem.Bracket_80_2 = 1    # Arena S6
ProgressionSystem.Bracket_80_3 = 1    # Arena S7
ProgressionSystem.Bracket_80_4_1 = 1  # Arena S8
```

---

## 🛠️ FASE 0 - Control Total de Vendors

### El Problema Resuelto
```
❌ ANTES: Jugadores de TBC S1 ven items de WotLK S8
✅ DESPUÉS: Cada bracket solo ve sus items correctos
```

### Solución: Patrón DELETE + INSERT
```sql
-- 1. LIMPIAR - Borrar items no válidos
DELETE FROM npc_vendor 
WHERE entry = [VENDOR_ID] 
  AND item NOT IN ([VALID_ITEMS_FOR_THIS_SEASON]);

-- 2. AGREGAR - Insertar items correctos con coste blizzlike (ExtendedCost)
-- Nota: el coste NO es oro; se define por `ExtendedCost` (Arena Points/Honor/Rating)
INSERT INTO npc_vendor (entry, slot, item, maxcount, incrtime, ExtendedCost, VerifiedBuild)
VALUES ([VENDOR_ID], 0, [ITEM_ID], 0, 0, [EXTENDED_COST_ID], 0);

-- 3. VALIDAR - Verificar que funcionó
SELECT COUNT(*) FROM npc_vendor WHERE entry = [VENDOR_ID];
```

### Estructura de Scripts SQL

```
src/Bracket_70_2_1/sql/templates/
└─ arena_s1_vendors_cleanup.sql.template          # Arena S1 - Template (completar placeholders)

src/Bracket_70_2_2/sql/templates/
└─ arena_s2_vendors_cleanup.sql.template          # Arena S2 - Template (S1 legacy + S2 new)

src/Bracket_70_5/sql/templates/
└─ arena_s3_vendors_cleanup.sql.template          # Arena S3 - Template (S1-S3)

src/Bracket_70_6_2/sql/templates/
└─ arena_s4_vendors_cleanup.sql.template          # Arena S4 - Template (S1-S4)

src/Bracket_80_1_2/sql/templates/
├─ transition_tbc_to_wotlk_vendors.sql.template   # Template transición TBC→WotLK (npcflag 128)
└─ arena_s5_vendors_cleanup.sql.template          # Arena S5 - Template (solo S5)

src/Bracket_80_2/sql/templates/
└─ arena_s6_vendors_cleanup.sql.template          # Arena S6 - Template (S5 legacy + S6 new)

src/Bracket_80_3/sql/templates/
└─ arena_s7_vendors_cleanup.sql.template          # Arena S7 - Template (S5-S7)

src/Bracket_80_4_1/sql/templates/
└─ arena_s8_vendors_cleanup.sql.template          # Arena S8 - Template (S5-S8)
```

### Tabla de Precios por Season

En blizzlike, la tabla `npc_vendor` usa `ExtendedCost` para definir el coste (Arena Points/Honor/Rating). La distinción
entre **nuevo** y **legacy** se representa usando **ExtendedCost distintos**.

Importante:
- `ExtendedCost` **no es un número de oro**; es un **ID** que apunta a `item_extended_cost`.
- Este módulo normalmente **no inventa precios**: reutiliza los costes existentes de tu core/DB (blizzlike) vía esos IDs.
- Si un item aparece “por oro” en el vendor, casi siempre es porque `ExtendedCost = 0` (y el item tiene `BuyPrice` > 0).

- `*_WITH_EXTENDEDCOST_NEW`: los costes del season actual
- `*_WITH_EXTENDEDCOST_LEGACY`: los costes rebajados (o sin requisitos) para seasons anteriores

Chequeo rápido (para detectar oro accidental):
```sql
-- Si esto devuelve filas para tus vendors de arena, están vendiendo por oro (ExtendedCost=0)
SELECT `entry`, `item`, `ExtendedCost`
FROM `npc_vendor`
WHERE `entry` IN ([Sx_VENDOR_ENTRIES])
  AND `ExtendedCost` = 0;
```

### Configuración Obligatoria para FASE 0

```ini
# Requerido para aplicar SQL del módulo
ProgressionSystem.LoadDatabase = 1

# Activa los brackets que quieras usar
ProgressionSystem.Bracket_70_2_1 = 1
# ProgressionSystem.Bracket_80_4_1 = 1
```

---

## 📖 Implementación Paso a Paso

### Paso 1: Identificar Vendor IDs en tu BD

```sql
-- Vendors (entries)
SELECT entry, name
FROM creature_template
WHERE name LIKE '%Gladiator%'
  OR name LIKE '%Arena%'
  OR name LIKE '%PvP%'
LIMIT 50;

-- Costs (ExtendedCost)
SELECT DISTINCT v.ExtendedCost
FROM npc_vendor v
WHERE v.entry IN (33609, 33610)
ORDER BY v.ExtendedCost;
```

### Paso 2: Mapear Items por Season

```sql
-- Items S1-S2
SELECT entry, name FROM item_template WHERE name LIKE '%Gladiator%' ORDER BY entry;

-- Items S3
SELECT entry, name FROM item_template WHERE name LIKE '%Hateful%' ORDER BY entry;

-- Items S4
SELECT entry, name FROM item_template WHERE name LIKE '%Brutal%' ORDER BY entry;

-- Items S5-S6
SELECT entry, name FROM item_template WHERE name LIKE '%Wrathful%' ORDER BY entry;

-- Items S7
SELECT entry, name FROM item_template WHERE name LIKE '%Vindictive%' ORDER BY entry;

-- Items S8
SELECT entry, name FROM item_template WHERE name LIKE '%Relentless%' ORDER BY entry;
```

### Paso 3: Crear Scripts SQL

**Template para cada bracket:**

```sql
-- Archivo (template): src/Bracket_70_2_1/sql/templates/arena_s1_vendors_cleanup.sql.template
-- =====================================================
-- ARENA SEASON 1 - CLEANUP & ADD
-- Bracket: 70_2_1 (TBC S1)
-- =====================================================

-- LIMPIAR: Borrar todo excepto items válidos
DELETE FROM npc_vendor 
WHERE entry = [VENDOR_ID]
  AND item NOT IN ([S1_ITEM_1], [S1_ITEM_2], ... [S1_ITEM_60]);

-- AGREGAR: Insertar items S1 con ExtendedCost blizzlike
INSERT INTO npc_vendor (entry, slot, item, maxcount, incrtime, ExtendedCost, VerifiedBuild)
VALUES
  ([VENDOR_ID], 0, [S1_ITEM_1], 0, 0, [EXTENDED_COST_ID_1], 0),
  ([VENDOR_ID], 0, [S1_ITEM_2], 0, 0, [EXTENDED_COST_ID_2], 0)
  -- ... etc ...
;

-- VALIDAR
SELECT COUNT(*) as s1_items FROM npc_vendor 
WHERE entry = [VENDOR_ID];
-- Resultado esperado: 60
```

### Paso 4: Ejecutar en Servidor

```bash
# 1. Copiar un template y convertirlo en update ejecutable (.sql)
# (Completa placeholders antes)
cp src/Bracket_70_2_1/sql/templates/arena_s1_vendors_cleanup.sql.template ~/azerothcore-wotlk/data/sql/updates/arena_s1_vendors_cleanup.sql

# 2. Recargar scripts en servidor
.server info  # Verifica que el módulo está cargado
.reload scripts

# 3. Ejecutar SQL script (si lo ejecutas manualmente)
mysql world < arena_s1_vendors_cleanup.sql
```

### Paso 5: Validar en Juego

```
Bracket_70_2_1 (TBC S1):
[ ] Vendor visible en Gadgetzan
[ ] Solo items de S1 disponibles
[ ] Costes via ExtendedCost (blizzlike)

Bracket_70_2_2 (TBC S2):
[ ] Vendor visible en Gadgetzan
[ ] Items de S1 (100k) y S2 (200k) disponibles
[ ] Total ~120 items

Bracket_80_1_2 (WotLK S5):
[ ] Gadgetzan vendor desaparecido
[ ] Nuevo vendor en Dalaran
[ ] Solo items de S5 disponibles
[ ] Costes via ExtendedCost (blizzlike)
```

---

## 🔧 Troubleshooting

### Vendor no visible
```sql
-- Verificar que el NPC tenga flag de vendor (bit 128)
SELECT entry, name, npcflag
FROM creature_template
WHERE entry = [VENDOR_ID];

-- Activar flag vendor (bit 128)
UPDATE creature_template
SET npcflag = (npcflag | 128)
WHERE entry = [VENDOR_ID];
```

### Items incorrectos mostrando
```sql
-- Verificar qué items tiene el vendor
SELECT nv.entry, nv.item, it.name, nv.ExtendedCost
FROM npc_vendor nv
INNER JOIN item_template it ON nv.item = it.entry
WHERE nv.entry = [VENDOR_ID]
ORDER BY nv.item;

-- Ejecutar limpieza manualmente
DELETE FROM npc_vendor WHERE entry = [VENDOR_ID];
```

### ExtendedCost incorrecto
```sql
-- Verificar ExtendedCost
SELECT nv.entry, nv.item, nv.ExtendedCost
FROM npc_vendor nv
WHERE nv.entry = [VENDOR_ID];

-- Actualizar ExtendedCost
UPDATE npc_vendor
SET ExtendedCost = [CORRECT_EXTENDED_COST_ID]
WHERE entry = [VENDOR_ID] AND item = [ITEM_ID];
```

---

## 📚 Documentación Adicional

- **BRACKET_DESCRIPTIONS_COMPLETE.md** - Descripción detallada de cada uno de los 38 brackets
- **ARENA_SEASONS_VALIDATION.md** - Mapeo completo de 8 Arena Seasons
- **PARAMETROS_TECNICOS_DESARROLLO.md** - Parámetros técnicos y validaciones SQL

---

## 🤝 Contribuir

1. Fork el proyecto
2. Crea tu rama de features (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

---

## 📝 Licencia

Este proyecto está bajo licencia GPL 3.0. Ver archivo [LICENSE](LICENSE) para más detalles.

---

## 💬 Soporte

- **AzerothCore Discord**: [Unirse al servidor](https://discord.gg/azerothcore)
- **Documentación**: Consultar archivos .md en la raíz del proyecto
- **Issues**: Reportar problemas en GitHub Issues

---

## 📊 Estado del Proyecto

- ✅ Análisis completo de 38 brackets
- ✅ Documentación de 8 Arena Seasons
- ✅ Sistema de control de vendors (FASE 0)
- ✅ Validación de configuración
- 🟡 Implementación de scripts SQL (ver IMPLEMENTACION_VENDORS_SQL.md)
- ⏳ Testing completo en producción

### Estado de Implementación: SQL Scripts

**Lo que significa "falta implementar los scripts en MySQL":**

Los archivos SQL template están listos pero necesitan ser **personalizados y ejecutados** en tu base de datos MySQL:

1. **Templates creados** (en `/src/Bracket_*/sql/templates/`):
  - `arena_s1_vendors_cleanup.sql.template` hasta `arena_s8_vendors_cleanup.sql.template`
  - `transition_tbc_to_wotlk_vendors.sql.template`

  Nota producción: `src/**/sql/world/vendors_*.sql` son stubs (comentarios) para que el DBUpdater no ejecute placeholders.

2. **Qué hacer ahora**:
  - Lee [IMPLEMENTACION_VENDORS_SQL.md](IMPLEMENTACION_VENDORS_SQL.md)
  - Obtén los **vendor entries** reales (Horde/Alliance) en `creature_template`
  - Obtén los **ExtendedCost IDs** reales en `item_extended_cost` / vendors existentes
  - Reemplaza los placeholders en cada template con valores reales
  - Guarda una copia como `.sql` y ejecútala (manual o como update)

3. **Estimado de tiempo**: ~57 minutos total

---

**Última actualización**: 2025-01-09  
**Versión**: 1.0  
**Compatibilidad**: AzerothCore 3.3.5a

---

## 🙏 Créditos y Agradecimientos

Este proyecto está basado y inspirado en el repositorio original de AzerothCore:

- https://github.com/azerothcore/mod-progression-system

Gracias a AzerothCore y a los contribuidores originales por el trabajo y la base técnica sobre la que se construye este fork.

---

## ✍️ Firma

Fork/maintainer: Kambi (mod-progression-blizzlike)

Fecha: 2025-12-24

```
Creado con ❤️ para la comunidad de AzerothCore
```
