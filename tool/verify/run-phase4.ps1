# Phase-4 verification: selection/feedback/selects x 2 themes x 2 apps.
# Selects is date-dependent: BOTH sides are frozen to one instant
# (web --clock Date shim; flutter ?clock= boot param). The oracle for
# selects was measured under this same instant.
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$CLOCK = '2026-08-16T12:00:00'
$pages = @(
  @{ name = 'selection'; route = '/design-system/components/base/selection'; clocked = $false },
  @{ name = 'feedback';  route = '/design-system/components/base/feedback';  clocked = $false },
  @{ name = 'selects';   route = '/design-system/components/base/selects';   clocked = $true }
)
New-Item -ItemType Directory -Force shots4 | Out-Null
Remove-Item shots4\results.jsonl -ErrorAction SilentlyContinue

foreach ($theme in @('dark', 'light')) {
  foreach ($p in $pages) {
    $n = "$($p.name)-$theme"
    $webArgs = @("http://localhost:3000$($p.route)", "shots4/$n-web.png", '--theme', $theme, '--settle', '1800', '--reduced')
    $fUrl = "http://localhost:8321/?route=$($p.route)&theme=$theme&motion=reduced"
    if ($p.clocked) { $webArgs += @('--clock', $CLOCK); $fUrl += "&clock=$CLOCK" }
    Write-Output "== capture $n web =="
    node capture.js @webArgs
    Write-Output "== capture $n flutter =="
    node capture.js $fUrl "shots4/$n-flutter.png" --settle 5000 --reduced
    Write-Output "== diff $n =="
    node diff.js "shots4/$n-web.png" "shots4/$n-flutter.png" "shots4/$n-diff.png" | Tee-Object -Append shots4\results.jsonl
  }
}
Write-Output '== ALL DONE =='
Get-Content shots4\results.jsonl
