# Phase-3 verification: buttons/inputs/forms x 2 themes x 2 apps.
# Prereqs: route arms wired in example main.dart (integration R), bundle
# rebuilt, servers on 3000 (web dev) and 8321 (example/build/web).
# Forms is captured PRISTINE (ruling F3): nothing typed, nothing submitted,
# menus closed - the oracle was measured in exactly that state.
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$pages = @(
  @{ name = 'buttons'; route = '/design-system/components/base/buttons' },
  @{ name = 'inputs';  route = '/design-system/components/base/inputs' },
  @{ name = 'forms';   route = '/design-system/components/base/forms' }
)
New-Item -ItemType Directory -Force shots3 | Out-Null
Remove-Item shots3\results.jsonl -ErrorAction SilentlyContinue

foreach ($theme in @('dark', 'light')) {
  foreach ($p in $pages) {
    $n = "$($p.name)-$theme"
    Write-Output "== capture $n web =="
    node capture.js "http://localhost:3000$($p.route)" "shots3/$n-web.png" --theme $theme --settle 1800 --reduced
    Write-Output "== capture $n flutter =="
    node capture.js "http://localhost:8321/?route=$($p.route)&theme=$theme&motion=reduced" "shots3/$n-flutter.png" --settle 5000 --reduced
    Write-Output "== diff $n =="
    node diff.js "shots3/$n-web.png" "shots3/$n-flutter.png" "shots3/$n-diff.png" | Tee-Object -Append shots3\results.jsonl
  }
}
Write-Output '== ALL DONE =='
Get-Content shots3\results.jsonl
