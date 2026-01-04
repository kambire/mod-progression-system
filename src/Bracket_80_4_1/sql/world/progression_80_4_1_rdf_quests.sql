-- Propósito: ajustar las recompensas de RDF para T10 (80_4_1) en modo normal/heroic segun retail 3.3.
-- Resultado: quest 24788 da Escarcha x2; 24789 y 24790 dan Triunfo x2.

UPDATE `quest_template` SET `rewarditem1` = 49426, `RewardAmount1` = 2 WHERE `ID` = 24788;
UPDATE `quest_template` SET `rewarditem1` = 47241, `RewardAmount1` = 2 WHERE `ID` = 24789;
UPDATE `quest_template` SET `rewarditem1` = 47241, `RewardAmount1` = 2 WHERE `ID` = 24790;
