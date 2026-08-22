# System map and discovery

## Step 0 — determine the mode before reading anything else

This skill runs in two kinds of project. The layouts share no paths, so resolve
the mode first and use only that column. Check in this order from the project
root:

| Probe | Mode |
| --- | --- |
| `elattar.yaml` or `.elattar/manifest.json` exists | **Consumer mode** — an app that ran `elattar init` / `elattar add`. |
| `lib/elattar_design_system.dart` exists | **Repository mode** — a checkout of the design-system repository itself. |
| Neither | Not an Elattar project yet. Say so and stop; do not invent a layout. |

```powershell
Test-Path elattar.yaml, .elattar/manifest.json, lib/elattar_design_system.dart
```

The probes are mutually exclusive in practice: the design-system repository ships
no `elattar.yaml`, and a consumer project never contains the package barrel.
If both are somehow present, consumer mode wins — it means the checkout is being
used as an application.

## Consumer mode

Installed sources are copied into the consumer's own `lib/`. There is no
`package:elattar_design_system/` import to reach for; the installer rewrites
directives onto relative imports of the generated barrels.

**`.elattar/manifest.json` is authoritative for what is installed and where.**
Each `items[].files[].target` is the real project-relative path the installer
wrote, alongside the hashes it wrote it from. Read it before assuming anything.

Do **not** read locations out of `elattar.yaml`. The CLI writes `paths:` and
`barrels:` keys into it, but as of CLI `0.0.1` nothing reads them back — install
destinations are fixed in the installer's target mapper, and the table below is
what that mapper actually produces. (`elattar.yaml` even defaults its
`barrels.design_system` to a `design_system.dart` file the installer never
creates.) Read `elattar.yaml` for `foundation:` and `registry:` only. Where the
file and the tree disagree, the tree wins.

| Concern | Default location | Use |
| --- | --- | --- |
| Install ledger | `.elattar/manifest.json` | Authoritative: which items are installed, at which version, and every file path they wrote. |
| Configuration | `elattar.yaml` | Foundation mode (`source`/`package`) and registry. Its path/barrel keys are inert — see above. |
| Components barrel | `lib/components/ui/ui.dart` | Generated; the entry point for installed components. |
| Components | `lib/components/ui/` | Installed `Ds*` component sources. Owned by the consumer, editable. |
| Foundation barrel | `lib/design_system/foundation.dart` | Generated; the entry point for tokens and theme. |
| Tokens | `lib/design_system/foundation/` | `ds`, measures, breakpoints, radii, type, themes, shadows, colors, motion. |
| Effects | `lib/design_system/effects/` | Installed effect sources. |
| Motion | `lib/design_system/motion/` | Installed motion sources. |
| Shots | `lib/shots/` | Installed application compositions. |
| Fonts | `assets/elattar/fonts/` | Installed font assets, wired through `pubspec.yaml`. |

Discovery:

```powershell
Get-Content .elattar/manifest.json
Get-Content elattar.yaml
Get-Content lib/components/ui/ui.dart
Get-Content lib/design_system/foundation.dart
rg -n "class Ds|enum Ds" lib/components/ui lib/design_system
```

Import installed code through the generated barrels with relative imports, the
form the installer emits. A single `package:elattar_design_system/elattar_design_system.dart`
import has no consumer counterpart: the installer fans it out across both
barrels, so write the two imports directly instead.

When `elattar.yaml` sets `foundation: package`, foundation sources are not
copied. The project depends on `elattar_core` and imports
`package:elattar_core/design_system/foundation/...` instead. Check the
`foundation:` key before assuming either shape.

Product UI belongs anywhere in the consumer's `lib/` except `lib/components/ui/`
and `lib/design_system/`. Those two directories hold installed system sources:
edit them to customise the system, not to build a screen. Installed files are
the consumer's own code, so local edits are legitimate — but an `elattar add
--overwrite` will replace them, so record any customisation you make.

## Repository mode

Use the public barrel first:

```powershell
Get-Content lib/elattar_design_system.dart
rg -n "class Ds|enum Ds" lib/src/components lib/src/effects lib/src/motion
rg -n "Ds<ComponentName>" example/lib test
```

| Concern | Source of truth | Use |
| --- | --- | --- |
| Public API | `lib/elattar_design_system.dart` | Verify a type is exported before consuming it. |
| Tokens | `lib/src/foundation/` | `ds`, measures, breakpoints, radii, type, themes, shadows, colors, motion. |
| Context | `lib/src/theme_scope.dart` | `DsTheme`, `DsText`, typography resolution. |
| Components | `lib/src/components/` | Controls, navigation, feedback, data display, overlays, agent family. |
| Effects/motion | `lib/src/effects/`, `lib/src/motion/` | System-owned visuals and mechanics. |
| Specimens | `example/lib/` | Composition, routing, responsive conventions. |
| Contracts | `test/`, `example/test/`, `test/token_guard_test.dart` | API behavior and no-literal guard. |
| Visual rig | `tool/verify/README.md` | Capture/comparison workflow. |
| Distribution | `registry/`, `packages/elattar_cli/` | What consumers actually receive. |

Import `package:elattar_design_system/elattar_design_system.dart` unless editing
the package itself.

Product pages, data adapters, and composed flows belong in the app or `example/`
layer. Add `lib/src/components/` code only when it has a reusable contract,
public export, specimen, and focused tests.

The legacy web project is design lineage only. This Flutter package's barrel,
sources, tests, specimens, and foundations are authoritative for implementation.

## Mode translation table

Every other reference in this skill names the repository-mode path. Translate:

| Repository mode | Consumer mode |
| --- | --- |
| `package:elattar_design_system/elattar_design_system.dart` | relative imports of `lib/components/ui/ui.dart` and `lib/design_system/foundation.dart` |
| `lib/src/foundation/` | `lib/design_system/foundation/` |
| `lib/src/components/` | `lib/components/ui/` |
| `lib/src/effects/`, `lib/src/motion/` | `lib/design_system/effects/`, `lib/design_system/motion/` |
| `example/lib/` (specimens) | `lib/shots/` (installed compositions), then the consumer's own `lib/` |
| `test/token_guard_test.dart` | no equivalent; apply the token rules by review |
| `tool/verify/README.md` | no equivalent; see the consumer ladder in [verify.md](verify.md) |
