# Phase-2 verification: shadows/motion/icons x 2 themes x 2 apps.
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$pages = @(
  @{ name = 'shadows'; route = '/design-system/shadows' },
  @{ name = 'motion';  route = '/design-system/motion' },
  @{ name = 'icons';   route = '/design-system/icons' }
)
New-Item -ItemType Directory -Force shots2 | Out-Null
Remove-Item shots2\results.jsonl -ErrorAction SilentlyContinue

foreach ($theme in @('dark', 'light')) {
  foreach ($p in $pages) {
    $n = "$($p.name)-$theme"
    Write-Output "== capture $n web =="
    node capture.js "http://localhost:3000$($p.route)" "shots2/$n-web.png" --theme $theme --settle 1800 --reduced
    Write-Output "== capture $n flutter =="
    node capture.js "http://localhost:8321/?route=$($p.route)&theme=$theme&motion=reduced" "shots2/$n-flutter.png" --settle 5000 --reduced
    Write-Output "== diff $n =="
    node diff.js "shots2/$n-web.png" "shots2/$n-flutter.png" "shots2/$n-diff.png" | Tee-Object -Append shots2\results.jsonl
  }
}
Write-Output '== ALL DONE =='
Get-Content shots2\results.jsonl

