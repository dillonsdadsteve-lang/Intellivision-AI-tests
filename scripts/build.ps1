# Usage: .\scripts\build.ps1 src\game.bas [-Run]
param([Parameter(Mandatory=$true)][string]$Src, [switch]$Run)
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$Src = (Resolve-Path $Src).Path
$Name = [IO.Path]::GetFileNameWithoutExtension($Src)
$IB = Join-Path $Root 'tools\intybasic'
$JZ = Join-Path $Root 'tools'
$Out = Join-Path $Root 'build'
New-Item -ItemType Directory -Force $Out | Out-Null
$Exe = Join-Path $IB 'intybasic.exe'
if (-not (Test-Path $Exe)) { throw "Build IntyBASIC first: see tools\README.md" }
# IntyBASIC resolves INCLUDEs from the current directory, so run it next to the source
Push-Location (Split-Path -Parent $Src)
& $Exe (Split-Path -Leaf $Src) "$Out\$Name.asm" $IB
$rc = $LASTEXITCODE
Pop-Location
if ($rc) { exit $rc }
& "$JZ\as1600.exe" -o "$Out\$Name.bin" -l "$Out\$Name.lst" "$Out\$Name.asm"
if ($LASTEXITCODE) { exit $LASTEXITCODE }
Write-Host "Built build\$Name.bin"
if ($Run) { & "$JZ\jzintv.exe" -p "$JZ" "$Out\$Name.bin" }
