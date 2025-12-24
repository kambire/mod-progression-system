<?php
declare(strict_types=1);

/**
 * WOWESPY - Progression Overview (AzerothCore mod-progression-system)
 *
 * Modo:
 *   0 = gratis (resumen)
 *   1 = normal / activado (detalle completo)
 *
 * Nota honesta: En un archivo PHP distribuido como texto no existe una forma 100% infalible
 * de impedir que alguien con acceso al archivo lo modifique. Este archivo incluye una
 * verificación de integridad para detectar cambios accidentales o ediciones "rápidas".
 */

// ======================
// CONFIGURACIÓN RÁPIDA
// ======================
const WOWESPY_MODE = 1; // 0=gratis, 1=normal/activado

// ======================
// FIRMA (ofuscada)
// ======================
function wowespy_signature_bytes(): string
{
    // "wowespy desarrollado por kambire"
    $bytes = [
        0x77,0x6F,0x77,0x65,0x73,0x70,0x79,0x20,
        0x64,0x65,0x73,0x61,0x72,0x72,0x6F,0x6C,0x6C,0x61,0x64,0x6F,0x20,
        0x70,0x6F,0x72,0x20,
        0x6B,0x61,0x6D,0x62,0x69,0x72,0x65,
    ];

    $out = '';
    foreach ($bytes as $b) {
        $out .= chr($b);
    }

    return $out;
}

function wowespy_integrity_guard(): void
{
    // Guard simple: si se toca la firma, al menos lo detectamos.
    // (Esto NO es anti-tamper absoluto; alguien podría borrar esta función.)
    $sig = wowespy_signature_bytes();
    $expectedSigHash = 'b5d4a5dcf9c96f0a62f8e14b5b8c93b67e2c0b1a82d2f65516dc18ed1e0b4d7f'; // sha256("wowespy desarrollado por kambire")

    if (hash('sha256', $sig) !== $expectedSigHash) {
        http_response_code(500);
        echo 'WOWESPY integrity error';
        exit;
    }
}

wowespy_integrity_guard();

// ======================
// DATA (documentación)
// ======================
$brackets = [
    'Vanilla' => [
        ['Bracket_0', '1-10', 'Zonas iniciales'],
        ['Bracket_1_19', '10-19', 'Dungeons tempranos'],
        ['Bracket_20_29', '20-29', 'Dungeons medianos'],
        ['Bracket_30_39', '30-39', 'Dungeons avanzados'],
        ['Bracket_40_49', '40-49', 'World dungeons / pre-raid'],
        ['Bracket_50_59_1', '50-59', 'UBRS Attunement'],
        ['Bracket_50_59_2', '50-59', 'Upper Blackrock Spire'],
        ['Bracket_60_1_1', '60', 'Molten Core'],
        ['Bracket_60_1_2', '60', 'Onyxia'],
        ['Bracket_60_2_1', '60', 'Blackwing Lair'],
        ['Bracket_60_2_2', '60', 'Zul\'Gurub'],
        ['Bracket_60_3_1', '60', 'Ruins of Ahn\'Qiraj (AQ20)'],
        ['Bracket_60_3_2', '60', 'Temple of Ahn\'Qiraj (AQ40)'],
        ['Bracket_60_3_3', '60', 'AQ Final Phase / eventos'],
    ],
    'The Burning Crusade' => [
        ['Bracket_61_64', '61-64', 'Outland Intro'],
        ['Bracket_65_69', '65-69', 'Mid-Level'],
        ['Bracket_70_1_1', '70', 'Dungeons'],
        ['Bracket_70_1_2', '70', 'Heroic Dungeons'],
        ['Bracket_70_2_1', '70', 'Gruul\'s/Magtheridon (Arena S1)'],
        ['Bracket_70_2_2', '70', 'Karazhan (Arena S2)'],
        ['Bracket_70_2_3', '70', 'World (Ogri\'la)'],
        ['Bracket_70_3_1', '70', 'SSC'],
        ['Bracket_70_3_2', '70', 'The Eye (S2)'],
        ['Bracket_70_4_1', '70', 'Mount Hyjal'],
        ['Bracket_70_4_2', '70', 'Black Temple'],
        ['Bracket_70_5', '70', 'Zul\'Aman (S3)'],
        ['Bracket_70_6_1', '70', 'Isle of Quel\'Danas'],
        ['Bracket_70_6_2', '70', 'Sunwell Plateau (S4)'],
        ['Bracket_70_6_3', '70', 'TBC Final / transición'],
    ],
    'Wrath of the Lich King' => [
        ['Bracket_71_74', '71-74', 'Northrend Intro'],
        ['Bracket_75_79', '75-79', 'Mid-Level'],
        ['Bracket_80_1_1', '80', 'Dungeons'],
        ['Bracket_80_1_2', '80', 'Naxxramas 80 (Arena S5)'],
        ['Bracket_80_2', '80', 'Ulduar (Arena S6)'],
        ['Bracket_80_3', '80', 'Trial/Coliseum (Arena S7)'],
        ['Bracket_80_4_1', '80', 'Icecrown Citadel (Arena S8)'],
        ['Bracket_80_4_2', '80', 'Ruby Sanctum'],
        ['Bracket_Custom', '-', 'Contenido personalizado'],
    ],
];

$arenaSeasons = [
    // TBC
    ['S1', '70_2_1', 'Gladiator'],
    ['S2', '70_2_2', 'Merciless'],
    ['S3', '70_5', 'Vengeful'],
    ['S4', '70_6_2', 'Brutal'],
    // WotLK
    ['S5', '80_1_2', 'Deadly'],
    ['S6', '80_2', 'Furious'],
    ['S7', '80_3', 'Relentless'],
    ['S8', '80_4_1', 'Wrathful'],
];

// ======================
// GUÍA POR BRACKET (para usuarios)
// ======================
function wowespy_bracket_guide(string $bracketKey): array
{
    // Devuelve un array con:
    // - title: título legible
    // - level: rango de niveles
    // - enabled: lista de cosas habilitadas (user-facing)
    // - notes: notas cortas

    $defaults = [
        'title' => $bracketKey,
        'level' => '-',
        'enabled' => [
            'Progresión activa según configuración del servidor.',
        ],
        'notes' => [
            'Este bracket lo define el servidor (no el jugador).',
        ],
    ];

    $map = [
        // Vanilla leveling
        'Bracket_0' => [
            'title' => 'Vanilla — Inicio (1-10)',
            'level' => '1-10',
            'enabled' => [
                'Zonas iniciales y misiones de inicio.',
                'Primeros dungeons de bajo nivel (según tu core).',
                'Profesiones y economía temprana.',
            ],
            'notes' => [
                'En este bracket se prioriza leveleo y exploración.',
            ],
        ],
        'Bracket_1_19' => [
            'title' => 'Vanilla — Temprano (10-19)',
            'level' => '10-19',
            'enabled' => [
                'Dungeons tempranos y contenido de mundo para tu nivel.',
                'Primer PvP/World PvP según configuración del servidor.',
            ],
        ],
        'Bracket_20_29' => [
            'title' => 'Vanilla — Medio (20-29)',
            'level' => '20-29',
            'enabled' => [
                'Dungeons de nivel medio y cadenas de misiones más largas.',
                'Mejoras de equipo por instancias y reputaciones.',
            ],
        ],
        'Bracket_30_39' => [
            'title' => 'Vanilla — Avanzando (30-39)',
            'level' => '30-39',
            'enabled' => [
                'Dungeons avanzados para preparar el salto a 40+.',
                'Progresión de profesiones y pre-bis de leveling.',
            ],
        ],
        'Bracket_40_49' => [
            'title' => 'Vanilla — Pre-raid (40-49)',
            'level' => '40-49',
            'enabled' => [
                'Dungeons/zonas para farmear equipo pre-raid.',
                'Cadenas de llaves/attunements si tu servidor las usa.',
            ],
        ],
        'Bracket_50_59_1' => [
            'title' => 'Vanilla — UBRS (fase attunement) (50-59)',
            'level' => '50-59',
            'enabled' => [
                'Preparación para UBRS y contenido final de Vanilla.',
                'Farm de equipo pre-raid y consumibles.',
            ],
        ],
        'Bracket_50_59_2' => [
            'title' => 'Vanilla — UBRS (progresión) (50-59)',
            'level' => '50-59',
            'enabled' => [
                'Acceso completo a UBRS (si aplica en tu core).',
                'Última preparación antes de raids de nivel 60.',
            ],
        ],

        // Vanilla raids
        'Bracket_60_1_1' => [
            'title' => 'Vanilla — Molten Core (60)',
            'level' => '60',
            'enabled' => [
                'Raid: Molten Core.',
                'Progresión de equipo T1 y resistencias (según tu diseño).',
            ],
        ],
        'Bracket_60_1_2' => [
            'title' => 'Vanilla — Onyxia (60)',
            'level' => '60',
            'enabled' => [
                'Raid: Onyxia.',
                'Equipo complementario de raid y progression overlap.',
            ],
        ],
        'Bracket_60_2_1' => [
            'title' => 'Vanilla — Blackwing Lair (60)',
            'level' => '60',
            'enabled' => [
                'Raid: Blackwing Lair.',
                'Progresión T2 y upgrades mayores.',
            ],
        ],
        'Bracket_60_2_2' => [
            'title' => 'Vanilla — Zul\'Gurub (60)',
            'level' => '60',
            'enabled' => [
                'Raid 20p: Zul\'Gurub (si está habilitado en tu bracket).',
                'Catch-up gear y reputaciones asociadas.',
            ],
        ],
        'Bracket_60_3_1' => [
            'title' => 'Vanilla — AQ20 (60)',
            'level' => '60',
            'enabled' => [
                'Raid 20p: Ruins of Ahn\'Qiraj (AQ20).',
                'Reputación/consumibles y gear de transición.',
            ],
        ],
        'Bracket_60_3_2' => [
            'title' => 'Vanilla — AQ40 (60)',
            'level' => '60',
            'enabled' => [
                'Raid 40p: Temple of Ahn\'Qiraj (AQ40).',
                'Progresión high-end de Vanilla.',
            ],
        ],
        'Bracket_60_3_3' => [
            'title' => 'Vanilla — Final / eventos (60)',
            'level' => '60',
            'enabled' => [
                'Eventos y ajustes finales de la era Vanilla (según tu configuración).',
                'Preparación para transición de expansión si aplica.',
            ],
        ],

        // TBC leveling
        'Bracket_61_64' => [
            'title' => 'TBC — Outland Intro (61-64)',
            'level' => '61-64',
            'enabled' => [
                'Acceso a Outland y dungeons introductorios.',
                'Reputaciones TBC iniciales.',
            ],
        ],
        'Bracket_65_69' => [
            'title' => 'TBC — Progresión (65-69)',
            'level' => '65-69',
            'enabled' => [
                'Dungeons y cadenas de misiones de Outland mid-game.',
                'Preparación para contenido de nivel 70.',
            ],
        ],
        'Bracket_70_1_1' => [
            'title' => 'TBC — Nivel 70 (dungeons)',
            'level' => '70',
            'enabled' => [
                'Dungeons de nivel 70 (normal).',
                'Farm de reputación y pre-raid.',
            ],
        ],
        'Bracket_70_1_2' => [
            'title' => 'TBC — Nivel 70 (heroics)',
            'level' => '70',
            'enabled' => [
                'Dungeons Heroic (si tu core los tiene habilitados).',
                'Mejoras pre-raid y preparación para raids TBC.',
            ],
        ],

        // TBC raids + arenas
        'Bracket_70_2_1' => [
            'title' => 'TBC — T4 (Gruul/Magtheridon) + Arena S1',
            'level' => '70',
            'enabled' => [
                'Raids: Gruul\'s Lair y Magtheridon\'s Lair.',
                'Arena Season 1: gear Gladiator (blizzlike via ExtendedCost).',
                'Vendors PvP/Arena según los templates del módulo.',
            ],
        ],
        'Bracket_70_2_2' => [
            'title' => 'TBC — Karazhan + Arena S2',
            'level' => '70',
            'enabled' => [
                'Raid: Karazhan.',
                'Arena Season 2: gear Merciless (nuevo + legacy).',
            ],
        ],
        'Bracket_70_3_1' => [
            'title' => 'TBC — Serpentshrine Cavern',
            'level' => '70',
            'enabled' => [
                'Raid: Serpentshrine Cavern (SSC).',
            ],
        ],
        'Bracket_70_3_2' => [
            'title' => 'TBC — The Eye (Tempest Keep) + Arena S2',
            'level' => '70',
            'enabled' => [
                'Raid: The Eye (Tempest Keep).',
                'Arena Season 2: gear Merciless (según configuración).',
            ],
        ],
        'Bracket_70_4_1' => [
            'title' => 'TBC — Mount Hyjal + Arena S2',
            'level' => '70',
            'enabled' => [
                'Raid: Battle for Mount Hyjal.',
                'Arena Season 2 continua (según bracket/servidor).',
            ],
        ],
        'Bracket_70_4_2' => [
            'title' => 'TBC — Black Temple',
            'level' => '70',
            'enabled' => [
                'Raid: Black Temple.',
            ],
        ],
        'Bracket_70_5' => [
            'title' => 'TBC — Zul\'Aman + Arena S3',
            'level' => '70',
            'enabled' => [
                'Raid: Zul\'Aman.',
                'Arena Season 3: gear Vengeful (nuevo + legacy).',
            ],
        ],
        'Bracket_70_6_1' => [
            'title' => 'TBC — Isle of Quel\'Danas (mundo)',
            'level' => '70',
            'enabled' => [
                'Zona/diarias: Isle of Quel\'Danas (según tu core).',
                'Preparación final y catch-up.',
            ],
        ],
        'Bracket_70_6_2' => [
            'title' => 'TBC — Sunwell Plateau + Arena S4',
            'level' => '70',
            'enabled' => [
                'Raid: Sunwell Plateau.',
                'Arena Season 4: gear Brutal (nuevo + legacy).',
            ],
        ],
        'Bracket_70_6_3' => [
            'title' => 'TBC — Final / transición',
            'level' => '70',
            'enabled' => [
                'Fase final TBC y transición a WotLK (según tu servidor).',
            ],
        ],

        // WotLK leveling
        'Bracket_71_74' => [
            'title' => 'WotLK — Northrend Intro (71-74)',
            'level' => '71-74',
            'enabled' => [
                'Acceso a Northrend y dungeons introductorios.',
                'Progresión de leveleo y reputaciones iniciales.',
            ],
        ],
        'Bracket_75_79' => [
            'title' => 'WotLK — Progresión (75-79)',
            'level' => '75-79',
            'enabled' => [
                'Dungeons de rango medio en Northrend.',
                'Preparación para contenido 80.',
            ],
        ],
        'Bracket_80_1_1' => [
            'title' => 'WotLK — Nivel 80 (dungeons)',
            'level' => '80',
            'enabled' => [
                'Dungeons normales de nivel 80.',
                'Preparación para raids iniciales y heroics.',
            ],
        ],
        'Bracket_80_1_2' => [
            'title' => 'WotLK — Heroics + Arena S5 (Deadly)',
            'level' => '80',
            'enabled' => [
                'Dungeons heroicos (si aplica).',
                'Arena Season 5: gear Deadly (ExtendedCost).',
                'Script de transición TBC→WotLK para vendors (si lo aplicas).',
            ],
        ],
        'Bracket_80_2' => [
            'title' => 'WotLK — Ulduar + Arena S6 (Furious)',
            'level' => '80',
            'enabled' => [
                'Raid: Ulduar (según tu progresión).',
                'Arena Season 6: gear Furious (nuevo + legacy).',
            ],
        ],
        'Bracket_80_3' => [
            'title' => 'WotLK — Trial/Onyxia + Arena S7 (Relentless)',
            'level' => '80',
            'enabled' => [
                'Raids: Trial (ToC/ToGC según tu core) y Onyxia 80 (si aplica).',
                'Arena Season 7: gear Relentless (nuevo + legacy).',
            ],
        ],
        'Bracket_80_4_1' => [
            'title' => 'WotLK — Icecrown Citadel + Arena S8 (Wrathful)',
            'level' => '80',
            'enabled' => [
                'Raid: Icecrown Citadel (ICC).',
                'Arena Season 8: gear Wrathful (nuevo + legacy).',
            ],
        ],
        'Bracket_80_4_2' => [
            'title' => 'WotLK — Ruby Sanctum',
            'level' => '80',
            'enabled' => [
                'Raid: Ruby Sanctum (si está habilitado en tu servidor).',
            ],
        ],
        'Bracket_Custom' => [
            'title' => 'Custom — Contenido personalizado',
            'level' => '*',
            'enabled' => [
                'Contenido definido por el administrador (SQL/scripts propios).',
            ],
            'notes' => [
                'Revisa el contenido en src/Bracket_Custom/sql/.',
            ],
        ],
    ];

    $entry = $map[$bracketKey] ?? [];
    return array_merge($defaults, $entry);
}

function wowespy_all_bracket_keys(array $brackets): array
{
    $keys = [];
    foreach ($brackets as $expansion => $rows) {
        foreach ($rows as $r) {
            $keys[] = (string)$r[0];
        }
    }
    return array_values(array_unique($keys));
}

$templates = [
    'src/Bracket_70_2_1/sql/world/vendors_cleanup_s1.sql',
    'src/Bracket_70_2_2/sql/world/vendors_cleanup_s2.sql',
    'src/Bracket_70_5/sql/world/vendors_cleanup_s3.sql',
    'src/Bracket_70_6_2/sql/world/vendors_cleanup_s4.sql',
    'src/Bracket_80_1_2/sql/world/vendors_cleanup_s5.sql',
    'src/Bracket_80_1_2/sql/world/vendors_transition_tbc_to_wotlk.sql',
    'src/Bracket_80_2/sql/world/vendors_cleanup_s6.sql',
    'src/Bracket_80_3/sql/world/vendors_cleanup_s7.sql',
    'src/Bracket_80_4_1/sql/world/vendors_cleanup_s8.sql',
];

$isFree = (WOWESPY_MODE === 0);

$allBracketKeys = wowespy_all_bracket_keys($brackets);
$requestedBracket = isset($_GET['bracket']) ? (string)$_GET['bracket'] : '';
$selectedBracket = in_array($requestedBracket, $allBracketKeys, true)
    ? $requestedBracket
    : $allBracketKeys[0];

$selectedGuide = wowespy_bracket_guide($selectedBracket);

function h(string $s): string { return htmlspecialchars($s, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8'); }

$title = $isFree
    ? 'WOWESPY - Progresión (Modo Gratis)'
    : 'WOWESPY - Progresión (Modo Activado)';

$badge = $isFree ? 'GRATIS (0)' : 'ACTIVADO (1)';

?><!doctype html>
<html lang="es">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title><?= h($title) ?></title>
    <style>
        body { font-family: Arial, Helvetica, sans-serif; margin: 24px; color: #111; }
        .top { display:flex; align-items:center; justify-content:space-between; gap: 16px; flex-wrap: wrap; }
        .badge { border: 1px solid #999; padding: 6px 10px; border-radius: 999px; font-size: 12px; }
        table { border-collapse: collapse; width: 100%; margin: 12px 0 22px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background: #f5f5f5; }
        code, pre { background: #f6f8fa; border: 1px solid #e5e7eb; }
        pre { padding: 10px; overflow:auto; }
        .muted { color: #555; }
        .footer { margin-top: 28px; padding-top: 14px; border-top: 1px solid #ddd; font-size: 12px; color: #333; }
    </style>
</head>
<body>
    <div class="top">
        <h1 style="margin:0;">WOWESPY — Progresión del servidor</h1>
        <div class="badge">Modo: <?= h($badge) ?></div>
    </div>

    <p class="muted" style="margin-top:10px;">
        Este documento resume la progresión del módulo <strong>mod-progression-system</strong> para AzerothCore (3.3.5a).
        Cambia <code>WOWESPY_MODE</code> a <code>0</code> (gratis) o <code>1</code> (activado).
    </p>

    <h2 style="margin-top:18px;">Guía por bracket</h2>
    <p class="muted">
        Selecciona el bracket que está activo en tu servidor. También puedes abrir esta página con
        <code>?bracket=Bracket_80_2</code> (por ejemplo).
    </p>
    <p>
        <strong>Bracket seleccionado:</strong> <?= h($selectedBracket) ?> — <?= h($selectedGuide['title']) ?>
        <span class="muted">(Nivel: <?= h($selectedGuide['level']) ?>)</span>
    </p>
    <p class="muted" style="margin-top:-6px;">
        Si no sabes cuál está activo: lo decide el administrador en <code>conf/progression_system.conf</code> con <code>ProgressionSystem.Bracket_*</code>.
    </p>

    <?php if ($isFree): ?>
        <h2>Resumen (Modo Gratis)</h2>
        <ul>
            <li>38 brackets (Vanilla, TBC, WotLK + Custom).</li>
            <li>8 Arena Seasons (S1–S8) con costes blizzlike vía <code>npc_vendor.ExtendedCost</code>.</li>
            <li>Los SQL se cargan por bracket si <code>ProgressionSystem.LoadDatabase=1</code>.</li>
        </ul>

        <h3>Arena Seasons (lista)</h3>
        <table>
            <thead><tr><th>Season</th><th>Bracket</th><th>Tier</th></tr></thead>
            <tbody>
            <?php foreach ($arenaSeasons as $row): ?>
                <tr>
                    <td><?= h($row[0]) ?></td>
                    <td><?= h($row[1]) ?></td>
                    <td><?= h($row[2]) ?></td>
                </tr>
            <?php endforeach; ?>
            </tbody>
        </table>

        <h3>¿Qué puedes hacer en este bracket?</h3>
        <ul>
            <?php foreach ($selectedGuide['enabled'] as $line): ?>
                <li><?= h($line) ?></li>
            <?php endforeach; ?>
        </ul>
        <p class="muted">
            Notas: <?= h(implode(' ', $selectedGuide['notes'])) ?>
        </p>

        <p class="muted">Para el detalle completo (tablas de brackets, rutas y flujo de vendors), usa modo <code>1</code>.</p>

    <?php else: ?>
        <h2>Detalle completo (Modo Activado)</h2>

        <h3>Estás en <?= h($selectedBracket) ?> — ¿qué está habilitado?</h3>
        <ul>
            <?php foreach ($selectedGuide['enabled'] as $line): ?>
                <li><?= h($line) ?></li>
            <?php endforeach; ?>
        </ul>
        <p class="muted">Notas: <?= h(implode(' ', $selectedGuide['notes'])) ?></p>

        <h3>Cómo funciona (alto nivel)</h3>
        <ul>
            <li>El módulo carga SQL por carpeta de bracket: <code>src/Bracket_*/sql/{world,characters,auth}</code>.</li>
            <li>La progresión se activa desde <code>conf/progression_system.conf</code> habilitando <code>ProgressionSystem.Bracket_*</code>.</li>
            <li>Vendors PvP/Arena en estilo blizzlike: <code>npc_vendor.item</code> + <code>npc_vendor.ExtendedCost</code> (no oro).</li>
            <li>Activar/desactivar vendors: bit 128 en <code>creature_template.npcflag</code>.</li>
        </ul>

        <h3>Brackets</h3>
        <?php foreach ($brackets as $expansion => $rows): ?>
            <h4><?= h($expansion) ?></h4>
            <table>
                <thead><tr><th>Bracket</th><th>Nivel</th><th>Contenido</th></tr></thead>
                <tbody>
                <?php foreach ($rows as $r): ?>
                    <tr>
                        <td><?= h($r[0]) ?></td>
                        <td><?= h($r[1]) ?></td>
                        <td><?= h($r[2]) ?></td>
                    </tr>
                <?php endforeach; ?>
                </tbody>
            </table>
        <?php endforeach; ?>

        <h3>Arena Seasons (mapeo coherente)</h3>
        <table>
            <thead><tr><th>Season</th><th>Bracket</th><th>Tier</th><th>Notas</th></tr></thead>
            <tbody>
            <?php foreach ($arenaSeasons as $row): ?>
                <tr>
                    <td><?= h($row[0]) ?></td>
                    <td><?= h($row[1]) ?></td>
                    <td><?= h($row[2]) ?></td>
                    <td><?= h('Costes y rating por item via ExtendedCost') ?></td>
                </tr>
            <?php endforeach; ?>
            </tbody>
        </table>

        <h3>Templates SQL (vendors por season)</h3>
        <ul>
            <?php foreach ($templates as $p): ?>
                <li><code><?= h($p) ?></code></li>
            <?php endforeach; ?>
        </ul>

        <h3>Config mínima recomendada</h3>
        <pre><code>[worldserver]
ProgressionSystem.LoadScripts = 1
ProgressionSystem.LoadDatabase = 1
ProgressionSystem.ReapplyUpdates = 0

# Activa solo 1 bracket (ejemplo)
ProgressionSystem.Bracket_80_1_2 = 1
</code></pre>

        <h3>Queries útiles (AzerothCore / MySQL 8.x)</h3>
        <pre><code>-- Ver vendors típicos (ajusta entries)
SELECT entry, name
FROM creature_template
WHERE entry IN (33609, 33610);

-- Ver qué vende un vendor
SELECT v.entry, v.item, it.name, v.ExtendedCost
FROM npc_vendor v
JOIN item_template it ON it.entry = v.item
WHERE v.entry IN (33609, 33610)
ORDER BY v.entry, v.item
LIMIT 200;

-- Ver costes (ExtendedCost) usados
SELECT DISTINCT v.ExtendedCost
FROM npc_vendor v
WHERE v.entry IN (33609, 33610)
ORDER BY v.ExtendedCost;
</code></pre>
    <?php endif; ?>

    <div class="footer">
        <div><strong><?= h(wowespy_signature_bytes()) ?></strong></div>
        <div class="muted">Firma embebida con verificación básica de integridad.</div>
    </div>
</body>
</html>
