param(
  [string]$OutPath = "audit/BRACKET_RUNTIME_REPORT.md",
  [int]$MaxHeaderLines = 60
)

$ErrorActionPreference = 'Stop'

function Fail($Message) {
  Write-Error $Message
  exit 1
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

if (-not (Test-Path (Join-Path $repoRoot "src"))) { Fail "Run from repo root (missing src/)" }
if (-not (Test-Path (Join-Path $repoRoot "conf/mod-progression-blizzlike.conf.dist"))) { Fail "Missing conf/mod-progression-blizzlike.conf.dist" }
if (-not (Test-Path (Join-Path $repoRoot "src/ProgressionSystem.h"))) { Fail "Missing src/ProgressionSystem.h" }

function Get-BracketOrder([string]$HeaderPath) {
  $raw = Get-Content -Raw -Path $HeaderPath
  $m = [regex]::Match($raw, 'ProgressionBracketsNames\s*=\s*\{([\s\S]*?)\};', [System.Text.RegularExpressions.RegexOptions]::Multiline)
  if (-not $m.Success) { Fail "Could not parse ProgressionBracketsNames from $HeaderPath" }

  $values = @()
  foreach ($match in [regex]::Matches($m.Groups[1].Value, '"([^"]+)"')) {
    $values += $match.Groups[1].Value
  }

  return $values
}

function Get-BracketDescriptionsFromConfig([string]$ConfigPath) {
  $map = @{}

  $current = $null
  $buffer = New-Object System.Collections.Generic.List[string]

  foreach ($line in Get-Content -Path $ConfigPath) {
    $m = [regex]::Match($line, '^\s*ProgressionSystem\.Bracket_([A-Za-z0-9_]+)\s*=')
    if ($m.Success) {
      if ($current) {
        $map[$current] = @($buffer)
      }
      $current = $m.Groups[1].Value
      $buffer.Clear()
      continue
    }

    if (-not $current) { continue }

    $trim = $line.Trim()
    if ($trim -eq '') {
      if ($buffer.Count -gt 0 -and $buffer[$buffer.Count - 1] -ne '') {
        $buffer.Add('')
      }
      continue
    }

    if ($trim.StartsWith('#')) {
      $text = $trim.TrimStart('#').Trim()
      $buffer.Add($text)
    }
  }

  if ($current) {
    $map[$current] = @($buffer)
  }

  return $map
}

function Get-SqlHeaderBlock([string]$SqlPath, [int]$MaxLines) {
  $lines = @(Get-Content -Path $SqlPath)
  $out = New-Object System.Collections.Generic.List[string]

  $i = 0
  while ($i -lt $lines.Count -and $lines[$i].Trim() -eq '') { $i++ }
  if ($i -ge $lines.Count) { return @() }

  $first = $lines[$i].TrimStart()
  $inBlock = $false

  if ($first.StartsWith('--')) {
    for (; $i -lt $lines.Count; $i++) {
      $t = $lines[$i].TrimStart()
      if ($t -eq '') {
        if ($out.Count -gt 0 -and $out[$out.Count - 1] -ne '') {
          $out.Add('')
        }
        continue
      }
      if (-not $t.StartsWith('--')) { break }
      $out.Add($t.Substring(2).TrimStart())
      if ($out.Count -ge $MaxLines) { break }
    }
    return @($out)
  }

  if ($first.StartsWith('/*')) {
    $inBlock = $true
    for (; $i -lt $lines.Count; $i++) {
      $t = $lines[$i].Trim()
      if ($t -eq '') {
        if ($out.Count -gt 0 -and $out[$out.Count - 1] -ne '') {
          $out.Add('')
        }
        continue
      }

      if ($t.StartsWith('/*')) {
        $rest = $t.Substring(2).Trim()
        if ($rest) { $out.Add($rest) }
        continue
      }

      if ($t.EndsWith('*/')) {
        $body = $t.Substring(0, $t.Length - 2).Trim()
        if ($body.StartsWith('*')) { $body = $body.Substring(1).TrimStart() }
        if ($body) { $out.Add($body) }
        break
      }

      if ($t.StartsWith('*')) {
        $t = $t.Substring(1).TrimStart()
      }
      $out.Add($t)
      if ($out.Count -ge $MaxLines) { break }
    }
    return @($out)
  }

  return @()
}

function Get-TouchedTables([string]$SqlPath) {
  $raw = Get-Content -Raw -Path $SqlPath
  $tables = New-Object System.Collections.Generic.HashSet[string]([StringComparer]::OrdinalIgnoreCase)

  $pattern = '(?im)\b(?:INSERT(?:\s+IGNORE)?\s+INTO|REPLACE\s+INTO|UPDATE|DELETE\s+FROM|CREATE\s+TABLE(?:\s+IF\s+NOT\s+EXISTS)?|ALTER\s+TABLE|DROP\s+TABLE(?:\s+IF\s+EXISTS)?)\s+`?(?:[a-z0-9_]+`?\.)?`?([a-z0-9_]+)`?'
  foreach ($m in [regex]::Matches($raw, $pattern)) {
    [void]$tables.Add($m.Groups[1].Value)
  }

  return @($tables | Sort-Object)
}

Push-Location $repoRoot
try {
  $bracketOrder = Get-BracketOrder (Join-Path $repoRoot "src/ProgressionSystem.h")
  $configDesc = Get-BracketDescriptionsFromConfig (Join-Path $repoRoot "conf/mod-progression-blizzlike.conf.dist")

  $outLines = New-Object System.Collections.Generic.List[string]
  $outLines.Add("# Bracket Runtime Report (Autoload SQL + Scripts)")
  $outLines.Add("")
  $outLines.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
  $outLines.Add('Generator: `scripts/generate_bracket_report.ps1`')
  $outLines.Add("")
  $outLines.Add("This document focuses on what each bracket enables **in this module**:")
  $outLines.Add('- If `ProgressionSystem.LoadDatabase = 1`: SQL updates are applied via AzerothCore `DBUpdater` from `src/Bracket_*/sql/{world,characters,auth}`.')
  $outLines.Add('- If `ProgressionSystem.LoadScripts = 1`: optional C++ scripts are loaded per bracket from `src/Bracket_*/scripts` (registered by each `Bracket_*_loader.cpp`).')
  $outLines.Add("- Brackets are applied in this order (important when multiple brackets are enabled at the same time):")
  $outLines.Add("")
  $outLines.Add('```')
  $outLines.Add(($bracketOrder | ForEach-Object { "Bracket_$_" }) -join ", ")
  $outLines.Add('```')
  $outLines.Add("")
  $outLines.Add("Notes:")
  $outLines.Add('- A bracket is **effectively enabled** if `ProgressionSystem.Bracket_<name> = 1` OR it is included in an enabled `ProgressionSystem.Bracket.ArenaSeasonN` mapping.')
  $outLines.Add('- The SQL file header comments below are extracted from each autoload `.sql` file; open the file for full details.')

  foreach ($name in $bracketOrder) {
    $folderName = if ($name -eq "Custom") { "Custom" } else { $name }
    $bracketDir = Join-Path $repoRoot ("src/Bracket_" + $folderName)
    if (-not (Test-Path $bracketDir)) {
      $outLines.Add("")
      $outLines.Add("## Bracket_$folderName")
      $outLines.Add("")
      $outLines.Add('> WARNING: bracket folder not found: `src/Bracket_' + $folderName + '`')
      continue
    }

    $outLines.Add("")
    $outLines.Add("## Bracket_$folderName")
    $outLines.Add("")
    $outLines.Add('- Config key: `ProgressionSystem.Bracket_' + $folderName + '`')

    if ($configDesc.ContainsKey($folderName) -and $configDesc[$folderName].Count -gt 0) {
      $outLines.Add("- Config template notes:")
      foreach ($l in $configDesc[$folderName]) {
        if ($l -eq '') { continue }
        $outLines.Add("  - $l")
      }
    }

    $loader = Get-ChildItem -Path $bracketDir -File -Filter "Bracket_*_loader.cpp" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($loader) {
      $rel = $loader.FullName.Substring($repoRoot.Length + 1).Replace('\', '/')
      $outLines.Add('- Loader: `' + $rel + '`')
    }

    $scriptsDir = Join-Path $bracketDir "scripts"
    $scriptFiles = @()
    if (Test-Path $scriptsDir) {
      $scriptFiles = Get-ChildItem -Path $scriptsDir -Recurse -File -Include *.cpp | Sort-Object FullName
    }

    if ($scriptFiles.Count -gt 0) {
      $outLines.Add("- C++ scripts:")
      foreach ($sf in $scriptFiles) {
        $rel = $sf.FullName.Substring($repoRoot.Length + 1).Replace('\', '/')
        $outLines.Add('  - `' + $rel + '`')
      }
    } else {
      $outLines.Add("- C++ scripts: (none)")
    }

    $outLines.Add("")
    $outLines.Add("### Autoload SQL")

    foreach ($db in @("auth", "characters", "world")) {
      $sqlDir = Join-Path $bracketDir ("sql/" + $db)
      if (-not (Test-Path $sqlDir)) {
        $outLines.Add("")
        $outLines.Add("#### $db (0 files)")
        $outLines.Add("- (directory missing)")
        continue
      }

      $sqlFiles = Get-ChildItem -Path $sqlDir -File -Filter *.sql | Sort-Object Name
      $outLines.Add("")
      $outLines.Add("#### $db ($($sqlFiles.Count) files)")

      if ($sqlFiles.Count -eq 0) {
        $outLines.Add("- (none)")
        continue
      }

      foreach ($sql in $sqlFiles) {
        $tables = Get-TouchedTables $sql.FullName
        $tablesStr = if ($tables.Count -gt 0) { ($tables | ForEach-Object { '`' + $_ + '`' }) -join ", " } else { "(unknown)" }

        $outLines.Add('- `' + $sql.Name + '` (tables: ' + $tablesStr + ')')

        $header = Get-SqlHeaderBlock -SqlPath $sql.FullName -MaxLines $MaxHeaderLines
        if ($header.Count -gt 0) {
          foreach ($h in $header) {
            if ($h -eq '') {
              continue
            }
            $outLines.Add("  - " + $h)
          }
        } else {
          $outLines.Add("  - (no header comment; open the file for details)")
        }
      }
    }
  }

  $outAbs = Join-Path $repoRoot $OutPath
  $outDir = Split-Path -Parent $outAbs
  if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Force -Path $outDir | Out-Null
  }

  ($outLines -join "`n") | Set-Content -Path $outAbs -Encoding UTF8
  Write-Host "OK: wrote $OutPath"
} finally {
  Pop-Location
}
