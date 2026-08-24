# Elattar v0.0.1 CLI consumer verification

> **Historical snapshot.** This report records what was true on the date and
> at the commit named in it. It is kept for the reasoning, not as a statement
> of the current release — several findings below were closed afterwards. For
> what is true now, read
> [`v0.0.1-public-release-baseline.md`](v0.0.1-public-release-baseline.md),
> which classifies every finding here against the commit that fixed it, and
> the root [`CHANGELOG.md`](../../../../CHANGELOG.md).

**Date:** 2026-08-24
**Branch:** `public-release-v0.0.1`
**Registry:** `registry/generated/latest`
**Result:** passed

This verification used fresh Flutter applications outside the repository and
the shipped generated registry. It was not a synthetic registry fixture.

## Full component installation

Temporary app:

```text
C:\Users\Airen\AppData\Local\Temp\elattar-consumer-smoke-20260824\consumer_app
```

Commands:

In the commands below, `<repo>` was exactly
`D:\DESIGN\Design-System-2026-8\flutter-design-system`.

```powershell
flutter create consumer_app
dart run <repo>\packages\elattar_cli\bin\elattar.dart init --foundation source --yes --registry <repo>\registry\generated\latest
dart run <repo>\packages\elattar_cli\bin\elattar.dart add --all --dry-run --registry <repo>\registry\generated\latest
dart run <repo>\packages\elattar_cli\bin\elattar.dart add --all --registry <repo>\registry\generated\latest
dart run <repo>\packages\elattar_cli\bin\elattar.dart doctor --registry <repo>\registry\generated\latest
flutter analyze
flutter test
```

Results:

- `init` wrote 19 foundation/configuration files.
- `add --all --dry-run` planned 103 writes and did not mutate the app.
- The dry run left `button.dart`, `icon_paths.g.index.dart`, and
  `voice_orb.dart` absent and kept the UI directory at one file.
- `add --all` wrote 103 files.
- `doctor` reported `foundation=source`, 95 installed items, and a 99-item
  version `0.0.1` registry.
- `flutter analyze`: no issues found.
- `flutter test`: one test passed; all tests passed.

## Representative selective installation

Temporary app:

```text
C:\Users\Airen\AppData\Local\Temp\elattar-consumer-smoke-20260824\subset_app
```

Command:

```powershell
dart run <repo>\packages\elattar_cli\bin\elattar.dart add button dialog form chart agent-console voice-orb --registry <repo>\registry\generated\latest
```

This selection covers a control, overlay, form, multi-file chart family,
agent composition, asset-backed effect, and shader-backed effect.

Results:

- The selective install wrote 51 files.
- `doctor` reported `foundation=source`, 43 installed items, and the same
  99-item version `0.0.1` registry.
- `flutter analyze`: no issues found.

## Notes

- The planned and installed icon payload includes
  `icon_paths.g.index.dart`; the generated registry owns the optional lookup
  library correctly.
- A registry path outside the consumer project is intentionally not pinned in
  `elattar.yaml`; subsequent commands must continue to pass `--registry`.
- Dependency resolution reported newer incompatible package versions were
  available, but both consumer analyses remained clean.
- No consumer verification failures occurred.
