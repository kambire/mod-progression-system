
-- Detectar columna de entrada (id1 vs id) para compatibilidad
SELECT COUNT(*) INTO @HAS_ID1
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'creature'
    AND COLUMN_NAME = 'id1';

SET @ENTRY_COL := IF(@HAS_ID1 = 1, 'id1', 'id');

-- Mostrar/ocultar vía fase (sin tocar npcflag)
SET @SQL := CONCAT(
    'UPDATE `creature` SET `phaseMask` = 4 WHERE `', @ENTRY_COL, '` IN (',
    '33964,35578,35577,31582,',  -- T7
    '35494,35574,',              -- T8
    '35579,35580,',              -- T9
    '31579,35573,31580,37942',   -- T10
    ')' );
PREPARE stmt FROM @SQL; EXECUTE stmt; DEALLOCATE PREPARE stmt;
