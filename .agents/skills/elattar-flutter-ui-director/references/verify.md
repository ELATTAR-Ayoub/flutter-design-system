# Verification ladder

Run focused checks while implementing, then the applicable full ladder:

```powershell
flutter analyze
flutter test
Push-Location example
flutter analyze
flutter test
flutter build web --release
Pop-Location
```

For an Android delivery, build the intended entrypoint explicitly:

```powershell
Push-Location example
flutter build apk --release --target lib/<entrypoint>.dart
Pop-Location
```

Read `tool/verify/README.md` for the capture rig. Inspect intended routes at device size in light/dark and narrow/wide variants.

Before handoff confirm: relevant public APIs were inventoried; all visual choices resolve from the system; relevant feedback/recovery states and accessibility are covered; product work stayed out of package ownership; reusable additions have export/specimen/tests; and the actual analysis/test/build/capture results are recorded with limitations.
