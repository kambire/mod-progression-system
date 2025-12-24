# Pasar a producción (Windows / AzerothCore)

Este módulo está pensado para producción con estas reglas:

- Los SQL que **se auto-cargan** (vía DBUpdater) están en `src/Bracket_*/sql/{world,characters,auth}` y **no deben tener placeholders**.
- Los SQL que requieren IDs reales de tu DB (vendors/arena) viven en `src/Bracket_*/sql/templates/*.sql.template` y se aplican **manual** (o como updates reales ya “materializados”).

## 0) Pre-flight (antes de tocar prod)

1) Backup DB (mínimo `world`):
- Backup completo recomendado.
- Si vas a tocar vendors arena: backup de `npc_vendor`, `creature_template`, `item_extended_cost`.

2) Backup configs:
- Guardar tu `etc/modules/*.conf`.

3) Elegir el bracket objetivo:
- Definí cuál `ProgressionSystem.Bracket_*` vas a activar en producción.

## 1) Validar y generar release (en tu PC)

Ejecuta el empaquetado/validación desde la raíz del repo:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\production_package.ps1
```

Esto:
- Falla si detecta placeholders peligrosos en SQL autoload.
- Crea un zip en `dist/` listo para copiar al server.

## 2) Instalar en el servidor (AzerothCore)

1) Copiar el módulo al core (ruta exacta requerida por el código):
- Debe quedar como: `azerothcore-wotlk/modules/mod-progression-blizzlike/`

2) Config:
- Copia `conf/progression_system.conf.dist` a tu carpeta de configs de módulos:
  - Ejemplo típico: `azerothcore-wotlk/etc/modules/progression_system.conf`
- Edita y activa **solo** los brackets deseados:
  - `ProgressionSystem.LoadDatabase = 1`
  - `ProgressionSystem.LoadScripts = 1`
  - `ProgressionSystem.ReapplyUpdates = 0` (recomendado en prod)
  - `ProgressionSystem.Bracket_<...> = 1`

3) Build:
- Recompila el core con el módulo.

4) Primer arranque:
- Al arrancar, DBUpdater aplicará los SQL de los brackets activos.

## 3) Aplicar vendors arena (manual, blizzlike)

Los templates de arena NO se auto-ejecutan por diseño (evita que `ExtendedCost=0` o placeholders rompan prod).

Pasos recomendados:

1) Completa el template de la season correspondiente (con tus entries reales y ExtendedCost IDs reales):
- Ej: `src/Bracket_80_1_2/sql/templates/arena_s5_vendors_cleanup.sql.template`

2) Guarda una copia “materializada” como `.sql` (fuera de autoload, por ejemplo en una carpeta tuya de deploy).

3) Ejecuta contra `world`.

4) Verifica que **no haya gold pricing**:
- Si hay filas con `ExtendedCost=0`, ese vendor está vendiendo por oro.

## 4) Verificación post-deploy

- Ejecuta `SQL_VERIFICATION.sql` contra tu DB `world`.
- En especial, la parte:
  - `Arena Vendors - GOLD PRICED (ExtendedCost=0)` debe dar **0**.

## Rollback

- Restaurar backup de `world`.
- Desactivar brackets (poner en 0) y reiniciar.
