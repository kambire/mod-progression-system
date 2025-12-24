param(
  [string]$OutDir = "dist",
  [string]$Name = "mod-progression-blizzlike",
  [string]$Version = "",
  [switch]$SkipGitCleanCheck
)

$ErrorActionPreference = 'Stop'

function Fail($Message) {
  Write-Host "ERROR: $Message" -ForegroundColor Red
  exit 1
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

if (-not (Test-Path (Join-Path $repoRoot "src"))) { Fail "Run this script from the repo (missing src/)" }

# Optional: ensure clean working tree (helps avoid deploying untracked changes)
if (-not $SkipGitCleanCheck) {
  if (Get-Command git -ErrorAction SilentlyContinue) {
    Push-Location $repoRoot
    try {
      $porcelain = git status --porcelain
      if ($porcelain) {
        Fail "Working tree is not clean. Commit/stash changes or rerun with -SkipGitCleanCheck.\n$porcelain"
      }
    } finally {
      Pop-Location
    }
  }
}

# 1) Safety checks: no placeholders in autoload SQL
$autoloadSqlRoots = @(
  Join-Path $repoRoot "src"
)

$autoloadSql = Get-ChildItem -Path $autoloadSqlRoots -Recurse -File -Include *.sql | Where-Object {
  $_.FullName -match "\\src\\Bracket_.*\\sql\\(world|characters|auth)\\" 
}

$placeholderPatterns = @(
  "\[VENDOR_ID\]",
  "\[EXTENDED_COST_ID\]",
  "\[S[0-9]_VENDOR_ENTRIES\]",
  "\[S[0-9]_ITEM_IDS\]",
  "_WITH_EXTENDEDCOST_"
)

foreach ($pattern in $placeholderPatterns) {
  $hits = $autoloadSql | Select-String -Pattern $pattern -SimpleMatch -ErrorAction SilentlyContinue
  if ($hits) {
    $first = $hits | Select-Object -First 8 | ForEach-Object { $_.Path + ":" + $_.LineNumber }
    Fail "Found placeholder '$pattern' inside autoload SQL. This is not production-safe. Examples:\n$($first -join "\n")"
  }
}

# 2) Safety checks: templates should not live in autoload folders
$badTemplates = Get-ChildItem -Path (Join-Path $repoRoot "src") -Recurse -File -Include *.sql.template | Where-Object {
  $_.FullName -match "\\src\\Bracket_.*\\sql\\(world|characters|auth)\\"
}
if ($badTemplates) {
  $first = $badTemplates | Select-Object -First 20 | ForEach-Object { $_.FullName }
  Fail "Found *.sql.template inside autoload sql folders (world/characters/auth). Move them to sql/templates.\n$($first -join "\n")"
}

# 3) Informational check: module path baked into C++
$cppPath = Join-Path $repoRoot "src\ProgressionSystem.cpp"
if (Test-Path $cppPath) {
  $expected = "/modules/$Name/src/Bracket_"
  $cpp = Get-Content -Raw -Path $cppPath
  if ($cpp -notmatch [Regex]::Escape($expected)) {
    Write-Host "WARN: ProgressionSystem.cpp does not contain expected base path: $expected" -ForegroundColor Yellow
    Write-Host "      Production requires folder name to match the baked path." -ForegroundColor Yellow
  }
}

# Build version label
if (-not $Version) {
  $Version = (Get-Date -Format "yyyyMMdd-HHmmss")
}

$distRoot = Join-Path $repoRoot $OutDir
$releaseDirName = "$Name-$Version"
$releaseDir = Join-Path $distRoot $releaseDirName

New-Item -ItemType Directory -Force -Path $distRoot | Out-Null
if (Test-Path $releaseDir) { Remove-Item -Recurse -Force $releaseDir }
New-Item -ItemType Directory -Force -Path $releaseDir | Out-Null

# Copy module contents (exclude git + dist)
$excludeDirs = @(
  (Join-Path $repoRoot ".git"),
  (Join-Path $repoRoot ".github"),
  (Join-Path $repoRoot "dist")
)

$items = Get-ChildItem -Path $repoRoot -Force | Where-Object {
  $full = $_.FullName
  -not ($excludeDirs | Where-Object { $full -eq $_ })
}

foreach ($it in $items) {
  Copy-Item -Recurse -Force -Path $it.FullName -Destination (Join-Path $releaseDir $it.Name)
}

# Create zip
$zipPath = Join-Path $distRoot "$releaseDirName.zip"
if (Test-Path $zipPath) { Remove-Item -Force $zipPath }
Compress-Archive -Path (Join-Path $releaseDir "*") -DestinationPath $zipPath

Write-Host "OK: Production package created" -ForegroundColor Green
Write-Host " - Folder: $releaseDir"
Write-Host " - Zip:    $zipPath"
Write-Host "Next: follow PRODUCTION.md on the server."
