---
name: elattar-flutter-ui-director
description: Direct production Flutter UI with Elattar's design system, in the design-system repository itself or in a consumer app that installed it with the elattar CLI. Use when designing, implementing, reviewing, or documenting Flutter screens, flows, dashboards, mobile navigation, component specimens, loading/empty/error/success feedback, responsive behavior, visual verification, or agent-console experiences that must use the local El* APIs and token source of truth.
---

# Elattar Flutter Ui Director

## Workflow

Build a coherent, useful interface from the existing Flutter design system. Treat it as implementation material, not inspiration: inspect public `El*` APIs, foundations, themes, effects, motion, and specimens before proposing a primitive.

1. Resolve the project mode with Step 0 of [system-map.md](references/system-map.md) before reading or writing anything. **Consumer mode** (`elattar.yaml` / `.elattar/manifest.json`) and **repository mode** (`lib/elattar_design_system.dart`) put the system in different directories, and every path named below is the repository-mode name. Translate through that reference. If neither probe matches, say so and stop.
2. Classify the work: product screen, package component, web-parity port, agent console, or review/fix. Name its primary action, critical states, and supported form factors.
3. Inventory the relevant public APIs with the discovery commands for your mode in [system-map.md](references/system-map.md) — barrel, source, tests, and specimens. Do not guess a widget exists.
4. Read [visual-direction.md](references/visual-direction.md), then state the dominant visual idea, hierarchy, and restrained supporting effect. Inspect any reference first; extract principles, never a branded copy.
5. Read [state-accessibility.md](references/state-accessibility.md) and define normal, loading, empty, error, success, disabled, focus, and recovery states before writing widgets.
6. Build product UI outside the system-owned component directory; reserve system components for reusable system behavior. Compose `El*` widgets and use Flutter layout only as a token-fed composition layer.
7. Use [platform-contracts.md](references/platform-contracts.md) for adaptive layout, safe areas, themes, input, and motion. Use [agent-console.md](references/agent-console.md) for agent-facing work.
8. Add or update a specimen/documentation route where the mode has one, plus focused widget tests. Run [verify.md](references/verify.md); render both themes and relevant widths. Report the mode, commands, captures, and limitations.

## Non-negotiable contract

Paths in this section are repository-mode names. In consumer mode substitute
`lib/design_system/foundation/` for `lib/src/design_system/foundation/` and
`lib/components/ui/` for `lib/src/components/ui/`, and import through the generated
barrels instead of the package — see [system-map.md](references/system-map.md).

- Import the design system through the entry point your mode provides: `package:elattar_design_system/elattar_design_system.dart` in repository mode, the generated `lib/components/ui/ui.dart` and `lib/design_system/foundation.dart` barrels in consumer mode. Do not reach past either into private internals.
- Make geometry from `space(...)`, `LayoutWidths`, `Containers`, `Breakpoints`, component APIs, or derived constraints. Make color from `ThemeScope.of(context)` / semantic variants; type from `StyledText` and `TextStyles`; timing/curves from `MotionDurations`, `MotionCurves`, and motion widgets.
- Never add raw colors, font sizes/weights/tracking/leading, radii, shadows, stock Flutter curves, or `Duration` literals outside the foundation directory. Do not hide a visual literal behind a local constant; a guard escape hatch needs a proven external-integration reason. Repository mode enforces this with `test/token_guard_test.dart`; consumer mode has no guard, so apply the rule by review.
- Prefer a semantic, stateful component over a styled `Container`, `Text`, `ElevatedButton`, or ad-hoc snackbar. Keep domain-specific composition outside the system component tree.
- Use status variants only for their meaning. Keep one clear primary action. Do not change foundation tokens to solve a single screen or use `Theme.of(context)` as a parallel visual system.

## Decisions and handoff

Choose the existing system contract before creating one.

- Reuse an existing primitive after inspecting its constructor, source test, and example.
- In consumer mode, check whether the primitive you need is merely *not installed yet* before writing one: `elattar add --dry-run <item>` reports what an install would add. Installing beats hand-rolling.
- Add a system primitive only when it has a reusable contract, public export, variants/states, specimen, and focused tests. Keep one-off patterns in product code.
- Installed sources in a consumer project are that project's own code and may be edited, but `elattar add --overwrite` replaces them. Record any customisation you make to an installed file.
- Give asynchronous actions deliberate feedback using the exported toaster, alerts, skeletons, empty states, spinner, progress, dialogs, and disabled controls.
- Hand off changed files, API inventory, covered states, token/motion compliance, automated and visual verification, and limitations. Apply the quality gate in [verify.md](references/verify.md).

## References

- [system-map.md](references/system-map.md) — mode discrimination, repository topology, and discovery.
- [visual-direction.md](references/visual-direction.md) — hierarchy, restraint, and references.
- [state-accessibility.md](references/state-accessibility.md) — feedback, semantics, state coverage.
- [platform-contracts.md](references/platform-contracts.md) — adaptive layout, safe areas, input, themes, motion.
- [agent-console.md](references/agent-console.md) — agent interaction requirements.
- [traps.md](references/traps.md) — common failure modes.
- [verify.md](references/verify.md) — test, guard, build, and visual review.
