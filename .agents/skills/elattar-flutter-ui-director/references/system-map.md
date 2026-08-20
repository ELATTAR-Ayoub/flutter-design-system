# System map and discovery

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

Product pages, data adapters, and composed flows belong in the app or `example/` layer. Add `lib/src/components/` code only when it has a reusable contract, public export, specimen, and focused tests.

The legacy web project is design lineage only. This Flutter package’s barrel, sources, tests, specimens, and foundations are authoritative for implementation.
