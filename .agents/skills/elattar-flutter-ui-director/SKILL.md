---
name: elattar-flutter-ui-director
description: Direct production Flutter UI in this repository with Elattar's design system. Use when designing, implementing, reviewing, or documenting Flutter screens, flows, dashboards, mobile navigation, component specimens, loading/empty/error/success feedback, responsive behavior, visual verification, or agent-console experiences that must use the local Ds* APIs and token source of truth.
---

# Elattar Flutter Ui Director

## Workflow

Build a coherent, useful interface from the existing Flutter design system. Treat it as implementation material, not inspiration: inspect public `Ds*` APIs, foundations, themes, effects, motion, and specimens before proposing a primitive.

1. Classify the work: product screen, package component, web-parity port, agent console, or review/fix. Name its primary action, critical states, and supported form factors.
2. Read [system-map.md](references/system-map.md) and inventory relevant public APIs with `rg` in the barrel, source, tests, and `example/lib`. Do not guess a widget exists.
3. Read [visual-direction.md](references/visual-direction.md), then state the dominant visual idea, hierarchy, and restrained supporting effect. Inspect any reference first; extract principles, never a branded copy.
4. Read [state-accessibility.md](references/state-accessibility.md) and define normal, loading, empty, error, success, disabled, focus, and recovery states before writing widgets.
5. Build product UI outside `lib/src/components/`; reserve package components for reusable system behavior. Compose `Ds*` widgets and use Flutter layout only as a token-fed composition layer.
6. Use [platform-contracts.md](references/platform-contracts.md) for adaptive layout, safe areas, themes, input, and motion. Use [agent-console.md](references/agent-console.md) for agent-facing work.
7. Add/update a specimen/documentation route and focused widget tests. Run [verify.md](references/verify.md); render both themes and relevant widths. Report commands, captures, and limitations.

## Non-negotiable contract

- Import `package:elattar_design_system/elattar_design_system.dart` unless editing the package itself.
- Make geometry from `ds(...)`, `DsWidths`, `DsContainers`, `DsBreakpoints`, component APIs, or derived constraints. Make color from `DsTheme.of(context)` / semantic variants; type from `DsText` and `DsType`; timing/curves from `DsDurations`, `DsCurves`, and motion widgets.
- Never add raw colors, font sizes/weights/tracking/leading, radii, shadows, stock Flutter curves, or `Duration` literals outside `lib/src/foundation/`. Do not hide a visual literal behind a local constant; a guard escape hatch needs a proven external-integration reason.
- Prefer a semantic, stateful component over a styled `Container`, `Text`, `ElevatedButton`, or ad-hoc snackbar. Keep domain-specific composition outside the package component tree.
- Use status variants only for their meaning. Keep one clear primary action. Do not change foundation tokens to solve a single screen or use `Theme.of(context)` as a parallel visual system.

## Decisions and handoff

Choose the existing system contract before creating one.

- Reuse an existing primitive after inspecting its constructor, source test, and example.
- Add a package primitive only when it has a reusable contract, public export, variants/states, specimen, and focused tests. Keep one-off patterns in product/example code.
- Give asynchronous actions deliberate feedback using the exported toaster, alerts, skeletons, empty states, spinner, progress, dialogs, and disabled controls.
- Hand off changed files, API inventory, covered states, token/motion compliance, automated and visual verification, and limitations. Apply the quality gate in [verify.md](references/verify.md).


## References

- [system-map.md](references/system-map.md) — repository topology and discovery.
- [visual-direction.md](references/visual-direction.md) — hierarchy, restraint, and references.
- [state-accessibility.md](references/state-accessibility.md) — feedback, semantics, state coverage.
- [platform-contracts.md](references/platform-contracts.md) — adaptive layout, safe areas, input, themes, motion.
- [agent-console.md](references/agent-console.md) — agent interaction requirements.
- [traps.md](references/traps.md) — common failure modes.
- [verify.md](references/verify.md) — test, guard, build, and visual review.
