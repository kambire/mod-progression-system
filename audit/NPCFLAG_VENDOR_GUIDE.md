# NPC Vendor Flag Audit/Fix (npcflag 128)

This guide covers the vendor visibility flags controlled by this module.
It targets MySQL 8.6 and assumes AzerothCore WotLK schema.

## 1) Audit current state

- Open `audit/NPCFLAG_VENDOR_AUDIT.sql`.
- Set the bracket you want to verify:
  - `SET @target_bracket := 'Bracket_0';`
- Run the script against your `world` database.
- Review the `MISMATCH` rows.

## 2) Apply fixes

- Open `audit/NPCFLAG_VENDOR_FIX.sql`.
- Run ONLY the section that matches your active bracket.
- Re-run the audit to confirm.

## 3) Module disabled (restore defaults)

- If you disabled the module and want to revert vendor visibility to defaults,
  run the **Restore defaults** section at the bottom of
  `audit/NPCFLAG_VENDOR_FIX.sql`.

## Notes

- These scripts only toggle `creature_template.npcflag` bit 128.
- They do NOT rollback `npc_vendor` item lists. Use DB backups for full rollback.
