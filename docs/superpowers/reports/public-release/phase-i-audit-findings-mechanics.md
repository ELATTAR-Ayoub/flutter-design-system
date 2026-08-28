# Phase I — independent audit findings (I1: behaviour and verification)

> **Historical snapshot.** This report records what was true on the date and
> at the commit named in it. It is kept for the reasoning, not as a statement
> of the current release — several findings below were closed afterwards. For
> what is true now, read
> [`v0.0.1-public-release-baseline.md`](v0.0.1-public-release-baseline.md),
> which classifies every finding here against the commit that fixed it, and
> the root [`CHANGELOG.md`](../../../../CHANGELOG.md).

Audited from a clean tree. Auditor wrote none of the code and edited nothing.

## All twelve Part-1 gates are genuinely green

Root analyze clean, root 1482 tests, example analyze clean, example 968 tests,
CLI analyze and format clean, CLI 26 tests, registry 20 items generate and
validate, release web build succeeds. Counts independently measured, not
inherited. Registry reproducibility is real: three consecutive builds left
`git status --porcelain registry/generated` empty across 57 tracked files.

## The verdict that matters

**A real shot installs into a clean project, its imports resolve, and it
compiles to JS.** Verified by hand for all three shipped shots: `flutter create`
→ `init` → `add button card settings-profile sign-in-flow dashboard-overview` →
`flutter analyze` clean → no `package:elattar_design_system` left anywhere →
both barrels correct → a widget test mounts two shots without exception →
consumer `flutter build web --release` succeeds.

**But the app that compiles renders in Roboto.** Three blockers sit one layer
below "compiles".

## BLOCKER F1 — installed fonts are registered under names nothing asks for

`packages/elattar_cli/lib/src/install/installer.dart:94` derives the family from
the filename, so `init` declares `InterVariable`, `GeistMono-Variable`,
`Redaction35-Italic`. The installed
`lib/design_system/foundation/typography.dart:25,28,36` asks for `InterLocal`,
`GeistMono`, `Redaction35`. The registry font entries carry no family metadata
at all — only source, target, sha256.

1.4 MB of fonts copied into every consumer project, not one reachable.
`flutter analyze` is structurally incapable of catching this: a font family is a
string.

## BLOCKER F2 — the package prefix survives installation

Installed `typography.dart:47` keeps `Fonts.package = 'elattar_design_system'`
and `:185` threads it into every TextStyle. The import transformer rewrites
import and export URIs only, never this string.

Proven at runtime by a widget test inside the clean consumer:

    resolved fontFamily = packages/elattar_design_system/InterLocal

An independent second cause of F1. Both must be fixed or the consumer still sees
the wrong glyphs.

## BLOCKER F3 — package foundation mode is a one-way door into an unbuildable project

`app.dart:591,600` write `elattar_core: ^0.0.1`. In a clean app, `pub get` fails:
`elattar_core` does not exist on pub.dev or anywhere in this repo. Attempted
recovery via `init --foundation source` exits 0 and rewrites config, but leaves
`elattar_core: ^0.0.1` in pubspec and `package:elattar_core/...` imports in three
installed components. `pub get` still fails. **`elattar doctor` then prints four
ok lines and exits 0.**

The mode is advertised in the CLI's own usage text. Fix it or remove the flag.

## IMPORTANT F5 — elattar.yaml cannot survive being committed

`app.dart:622` writes an absolute local path as the registry. Committed and run
elsewhere: exit 64. Restoring the documented default
(`config.dart:20,78` → `https://elattar.dev/registry`) produces an unhandled
FileSystemException and a raw Dart stack trace — the URL is passed to
`Directory(...)`. There is no HTTP fetcher: `RegistryFetcher` is a bare typedef
with no implementation.

## IMPORTANT F4 — the config publishes a surface that does not exist

Setting `paths.components` and `barrels.components` then running `add tooltip`
writes to the default location and never creates the configured one. No
diagnostic. `designSystemBarrels` is a hardcoded const;
`ElattarConfig.designSystemBarrel` is serialised and parsed but consumed by
nothing, and `lib/design_system/design_system.dart` is never generated.

## Gates that are theatre

- **F8** `tool/registry_builder/test/generator_test.dart` cannot run, does not
  compile, and tests a function whose own doc comment says ADVISORY ONLY — no
  production caller. The package declares no dependencies yet the test imports
  `flutter_test`. Excluded from analyze, outside the `flutter test` walk, absent
  from CI. 20 analyzer errors.
- **F9** `test/skill_install_fixture_test.dart` exercises no product code — the
  install under test is a helper defined in the same file. It proves
  `File.copySync` works. Worse, line 290 is `skip: skipReason`, set whenever the
  skill directory is missing: **delete `skills/` entirely and this test reports
  skipped, not failed.** The only skip in the corpus.
- **F10** The end-to-end shot proof runs against a synthetic 4-item fixture.
  Nothing in CI installs a real shot from the real registry.

## Three mutations that survive all 2476 tests

1. `installer.dart:94` family → `'zzz'`. No test asserts the consumer-side
   family. This is the mutation that would have caught F1.
2. `app.dart:625` packageName → anything. The only test naming `elattar_core`
   hand-writes it into a YAML fixture and asserts the parser echoes it back — it
   tests `loadYaml`, not the CLI.
3. CLI pubspec version 0.0.1 → 0.0.2. `project_config_test` asserts the version
   as a bare literal and never compares it to the pubspec, so `--version` would
   keep printing 0.0.1 for a 0.0.2 package.

All three sit on the consumer-facing seam, which is where the suite is thinnest.

## CI gaps

- **F6** CI regenerates the registry then validates it, with no
  `git diff --exit-code`. A PR that changes a source without rebuilding passes
  clean, and the committed registry goes stale with hashes that no longer match.
  The generator is deterministic; the gate is simply absent.
- **F7** `on: pull_request, workflow_dispatch` — CI never runs on push, so `main`
  is ungated. The commit you tag has never been through the pipeline.
- **F12** Format is checked on 20 CLI files; the root has 118 unformatted files
  and the example app is unchecked.
- **F13** Linux-only CI for a CLI built around Windows path handling.

## Confirmed clean

`publish_to: none` on all pubspecs. The package declares everything it ships and
nothing it does not — 3 font families, the texture, the two skills asset lines,
the shader, all present. Duplicate install is genuinely conflict-safe: re-adding
an edited file refuses with exit 73 and writes nothing (all-or-nothing, guarded
on `conflicts.isEmpty`); `--overwrite` restores correctly.

## Release readiness

Not shippable on the mechanics alone, but the distance is short and
well-localised. The package is in genuinely good shape and the auditor could not
dent it. Everything failing is downstream of the package boundary — the CLI, the
consumer install, and the gates that were supposed to cover them.

The pattern: verification is concentrated inside the package, where it is
excellent, and thins sharply across the consumer boundary, where the product
actually lives. All three blockers and all three surviving mutations sit on that
seam.
