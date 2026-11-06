# Copy this lean-ui folder so SKILL.md is a direct child of each destination.
# Never produce lean-ui\lean-ui. This file is the Windows installer.
$ErrorActionPreference = 'Stop'

$Source = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
if (-not (Test-Path -LiteralPath (Join-Path $Source 'SKILL.md'))) {
  throw "SKILL.md not found in $Source"
}

function Show-Usage {
  @'
Usage: powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install.ps1 [--host HOST] [--scope SCOPE]

Copy the lean-ui folder that contains this script. SKILL.md is placed
directly inside the destination skill folder, never lean-ui\lean-ui.

--host   grok | grok-bot | cursor | openai | antigravity | claude | all
         (default: all)
--scope  user | project
         (default: user)

User paths use $env:USERPROFILE. Project paths use the current directory.
grok-bot is only $env:USERPROFILE\.grok\skills\lean-ui on the bot computer.
--host grok-bot --scope project is an error.
--host all --scope project does not write that bot path.

If a destination already exists, nothing is copied and the script exits 1.
'@
}

$HostName = 'all'
$ScopeName = 'user'
$index = 0
while ($index -lt $args.Count) {
  $arg = [string]$args[$index]
  if ($arg -eq '--help' -or $arg -eq '-h') {
    Show-Usage
    exit 0
  } elseif ($arg -eq '--host') {
    if ($index + 1 -ge $args.Count) { throw '--host needs a value' }
    $index++
    $HostName = [string]$args[$index]
  } elseif ($arg.StartsWith('--host=')) {
    $HostName = $arg.Substring(7)
    if ([string]::IsNullOrWhiteSpace($HostName)) { throw '--host needs a value' }
  } elseif ($arg -eq '--scope') {
    if ($index + 1 -ge $args.Count) { throw '--scope needs a value' }
    $index++
    $ScopeName = [string]$args[$index]
  } elseif ($arg.StartsWith('--scope=')) {
    $ScopeName = $arg.Substring(8)
    if ([string]::IsNullOrWhiteSpace($ScopeName)) { throw '--scope needs a value' }
  } else {
    throw "unknown argument: $arg"
  }
  $index++
}

$allowedHosts = @('grok', 'grok-bot', 'cursor', 'openai', 'antigravity', 'claude', 'all')
$allowedScopes = @('user', 'project')
if ($allowedHosts -notcontains $HostName) { throw "unknown --host: $HostName" }
if ($allowedScopes -notcontains $ScopeName) { throw "unknown --scope: $ScopeName" }

if ($HostName -eq 'grok-bot' -and $ScopeName -eq 'project') {
  throw 'grok-bot installs only to $env:USERPROFILE\.grok\skills\lean-ui on the bot computer; re-run with --scope user'
}

$ProjectRoot = (Get-Location).Path
$UserRoot = $env:USERPROFILE
$needsUser = ($ScopeName -eq 'user') -or ($HostName -eq 'grok-bot')
if ($needsUser -and [string]::IsNullOrWhiteSpace($UserRoot)) {
  throw 'USERPROFILE is not set'
}

$script:Destinations = @()
function Add-Dest([string]$Destination) {
  if ($script:Destinations -contains $Destination) { return }
  $script:Destinations += $Destination
}

function Join-Under([string]$Root, [string]$Relative) {
  $path = $Root
  foreach ($part in $Relative.Split('/')) {
    if ($part) { $path = Join-Path $path $part }
  }
  return $path
}

function Add-Scoped([string]$Relative) {
  if ($ScopeName -eq 'user') {
    Add-Dest (Join-Under $UserRoot $Relative)
  } else {
    Add-Dest (Join-Under $ProjectRoot $Relative)
  }
}

if ($HostName -eq 'all' -or $HostName -eq 'grok') {
  Add-Scoped '.grok/skills/lean-ui'
}
if ($HostName -eq 'grok-bot' -or ($HostName -eq 'all' -and $ScopeName -eq 'user')) {
  Add-Dest (Join-Under $UserRoot '.grok/skills/lean-ui')
}
if ($HostName -eq 'all' -or $HostName -eq 'cursor') {
  Add-Scoped '.cursor/skills/lean-ui'
}
if ($HostName -eq 'all' -or $HostName -eq 'openai') {
  Add-Scoped '.agents/skills/lean-ui'
}
if ($HostName -eq 'all' -or $HostName -eq 'antigravity') {
  if ($ScopeName -eq 'user') {
    Add-Dest (Join-Under $UserRoot '.gemini/config/skills/lean-ui')
    Add-Dest (Join-Under $UserRoot '.gemini/antigravity-cli/skills/lean-ui')
  } else {
    Add-Dest (Join-Under $ProjectRoot '.agents/skills/lean-ui')
  }
}
if ($HostName -eq 'all' -or $HostName -eq 'claude') {
  Add-Scoped '.claude/skills/lean-ui'
}

if ($script:Destinations.Count -eq 0) { throw 'no destinations selected' }

function Assert-Safe([string]$Destination) {
  if ([string]::IsNullOrWhiteSpace($Destination)) { throw 'refusing unsafe destination' }
  $full = [System.IO.Path]::GetFullPath($Destination)
  $trimmed = $full.TrimEnd('\', '/')
  foreach ($root in @($UserRoot, $ProjectRoot, $Source)) {
    if ([string]::IsNullOrWhiteSpace($root)) { continue }
    $fullRoot = [System.IO.Path]::GetFullPath($root).TrimEnd('\', '/')
    if ([string]::Equals($trimmed, $fullRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
      throw "refusing unsafe destination: $Destination"
    }
  }
  if ($trimmed -eq '' -or $trimmed -eq '\' -or $full -eq '/') {
    throw "refusing unsafe destination: $Destination"
  }
}

$blocked = $false
foreach ($dest in $script:Destinations) {
  Assert-Safe $dest
  if (Test-Path -LiteralPath $dest) {
    [Console]::Error.WriteLine("lean-ui already exists at $dest; review it first")
    $blocked = $true
  }
}
if ($blocked) { exit 1 }

function Remove-Rel([string]$Root, [string]$Relative) {
  $path = Join-Under $Root $Relative
  if (Test-Path -LiteralPath $path) {
    Remove-Item -LiteralPath $path -Recurse -Force
  }
}

function Install-One([string]$Destination) {
  $parent = Split-Path -Parent $Destination
  if ([string]::IsNullOrWhiteSpace($parent)) { throw "refusing unsafe destination: $Destination" }
  New-Item -ItemType Directory -Force -Path $parent | Out-Null
  $stageParent = Join-Path ([System.IO.Path]::GetTempPath()) ('lean-ui-' + [guid]::NewGuid().ToString('n'))
  New-Item -ItemType Directory -Path $stageParent | Out-Null
  $stage = Join-Path $stageParent 'lean-ui'
  try {
    Copy-Item -LiteralPath $Source -Destination $stage -Recurse -Force
    foreach ($relative in @(
      'node_modules', 'examples/node_modules', 'dist', 'examples/dist',
      'coverage', 'examples/coverage', '.git', '.verification', 'evals/runs',
      '.env', 'examples/.env'
    )) {
      Remove-Rel $stage $relative
    }
    Get-ChildItem -LiteralPath $stage -Filter '*.tsbuildinfo' -File -ErrorAction SilentlyContinue |
      Remove-Item -Force
    $exampleDir = Join-Path $stage 'examples'
    if (Test-Path -LiteralPath $exampleDir) {
      Get-ChildItem -LiteralPath $exampleDir -Filter '*.tsbuildinfo' -File -ErrorAction SilentlyContinue |
        Remove-Item -Force
    }
    $stagedSkill = Join-Path $stage 'SKILL.md'
    $stagedNested = Join-Path $stage (Join-Path 'lean-ui' 'SKILL.md')
    if (-not (Test-Path -LiteralPath $stagedSkill) -or (Test-Path -LiteralPath $stagedNested)) {
      throw 'staged copy is not a single skill folder with SKILL.md directly inside'
    }
    # Move the staged folder onto the destination path. Do not copy into an
    # existing directory; that would nest lean-ui\lean-ui.
    if (Test-Path -LiteralPath $Destination) {
      throw "lean-ui already exists at $Destination; review it first"
    }
    Move-Item -LiteralPath $stage -Destination $Destination
  } finally {
    if (Test-Path -LiteralPath $stageParent) {
      Remove-Item -LiteralPath $stageParent -Recurse -Force -ErrorAction SilentlyContinue
    }
  }
  $skillFile = Join-Path $Destination 'SKILL.md'
  $nested = Join-Path $Destination (Join-Path 'lean-ui' 'SKILL.md')
  if (-not (Test-Path -LiteralPath $skillFile) -or (Test-Path -LiteralPath $nested)) {
    throw "install failed: expected $skillFile without a nested lean-ui folder"
  }
  Write-Output "installed $Destination"
}

foreach ($dest in $script:Destinations) {
  Install-One $dest
}
