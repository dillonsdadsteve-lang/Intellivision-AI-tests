# Usage: .\scripts\build.ps1 src\game.bas [-Run]
param([Parameter(Mandatory=$true)][string]$Src, [switch]$Run)
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$Name = [IO.Path]::GetFileNameWithoutExtension($Src)
$IB = Join-Path $Root 'tools\intybasic'
$JZ = Join-Path $Root 'tools\jzintv'
$Out = Join-Path $Root 'build'
New-Item -ItemType Directory -Force $Out | Out-Null
$Exe = Join-Path $IB 'intybasic.exe'
if (-not (Test-Path $Exe)) { throw "Build IntyBASIC first: see tools\README.md" }
& $Exe $Src "$Out\$Name.asm" $IB
if ($LASTEXITCODE) { exit $LASTEXITCODE }
& "$JZ\bin\as1600.exe" -o "$Out\$Name.bin" -l "$Out\$Name.lst" "$Out\$Name.asm"
if ($LASTEXITCODE) { exit $LASTEXITCODE }
Write-Host "Built build\$Name.bin"
if ($Run) { & "$JZ\bin\jzintv.exe" -p "$JZ\rom" "$Out\$Name.bin" }
