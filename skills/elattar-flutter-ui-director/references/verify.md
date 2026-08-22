# Verification ladder

Resolve the mode from [system-map.md](system-map.md) Step 0 first, then run that
mode's ladder. Run focused checks while implementing and the applicable full
ladder before handoff.

## Consumer mode

The design system lives inside the consumer's own package, so one project root
runs everything. There is no `example/` directory and no capture rig.

```powershell
flutter analyze
flutter test
```

Add the release build for the target you actually ship:

```powershell
flutter build web --release
flutter build apk --release
```

If the `elattar` CLI is available, confirm the install is coherent before
blaming your own code:

```powershell
elattar doctor
```

`elattar add --dry-run <item>` shows what an install would write without
touching the tree — use it to check whether a needed component is already
installed rather than hand-writing a primitive.

Inspect intended routes at device size in light/dark and narrow/wide variants
with `flutter run`. Record what you inspected; there is no capture rig here.

## Repository mode

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

Read `tool/verify/README.md` for the capture rig. Inspect intended routes at
device size in light/dark and narrow/wide variants.

`test/token_guard_test.dart` enforces the no-literal rule mechanically; run it
directly while iterating on visual code.

## Handoff — both modes

Before handoff confirm: relevant public APIs were inventoried; all visual choices
resolve from the system; relevant feedback/recovery states and accessibility are
covered; product work stayed out of system-owned directories; reusable additions
have export/specimen/tests where the mode supports them; and the actual
analysis/test/build/capture results are recorded with limitations.

State the mode you worked in and the commands you actually ran. Do not report a
command from the other mode's ladder.
