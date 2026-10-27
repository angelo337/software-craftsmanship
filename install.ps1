# Usage: .\install.ps1 [-Project] [-Uninstall]
param([switch]$Project, [switch]$Uninstall)
$dest = if ($Project) { Join-Path (Get-Location) ".claude\skills" } else { Join-Path $HOME ".claude\skills" }
Get-ChildItem (Join-Path $PSScriptRoot "plugins\software-craftsmanship\skills") -Directory | ForEach-Object {
  $t = Join-Path $dest $_.Name
  if (Test-Path $t) { Remove-Item $t -Recurse -Force }
  if ($Uninstall) { "removed $($_.Name)" } else { New-Item -ItemType Directory -Force $dest | Out-Null; Copy-Item $_.FullName $t -Recurse; "installed $($_.Name)" }
}
"Done -> $dest. Restart Claude Code."
