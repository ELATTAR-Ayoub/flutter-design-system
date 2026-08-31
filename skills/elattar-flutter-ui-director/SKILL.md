---
name: elattar-flutter-ui-director
description: "Direct production Flutter UI with Elattar's design system, in the design-system repository itself or in a consumer app that installed it with the elattar CLI. Use when designing, implementing, reviewing, or documenting Flutter screens, pages, sections, flows, dashboards, forms, mobile navigation, or component specimens that must be complete: loading skeletons, empty and no-results states, human error copy with a next step, success and undo feedback, keyboard and screen-reader access, responsive structure, and both themes, all built from the local design-system APIs and token source of truth."
---

# Elattar Flutter UI Director

Build interfaces that are finished. Finished means every surface handles its
states, every trigger answers the user, every failure is written in human words
with one next step, and every control works by keyboard, at every width, in both
themes.

Treat the design system as implementation material, not inspiration. Inspect the
public APIs the barrel exports before proposing a primitive.

Public names carry no prefix. They are ordinary nouns: `Button`, `Card`, `Icon`,
`TextStyles`, `space`. Never search for or compose an `El*` API; a name starting
with `El` is a retired spelling, not a widget.

## Workflow

1. **Resolve the mode.** Step 0 of [system-map.md](references/system-map.md),
   before reading or writing anything. Consumer mode and repository mode put the
   system in different directories, and every path named in this skill is the
   repository-mode name. If neither probe matches, say so and stop.
2. **Classify the work.** Product screen, package component, web-parity port,
   agent console, or review and fix.
3. **Write the UI contract.** [ui-contract.md](references/ui-contract.md). No
   widgets before it exists. It is the input to the gate.
4. **Inventory the real APIs.** Use the discovery commands for your mode in
   [system-map.md](references/system-map.md): barrel, source, tests, specimens.
   Do not guess that a widget exists.
5. **Set the visual direction.** [visual-direction.md](references/visual-direction.md).
   One dominant idea, a clear hierarchy, at most one supporting effect.
6. **Design the states before the widgets.**
   [states.md](references/states.md), [errors.md](references/errors.md),
   [feedback.md](references/feedback.md). Every region, not just the page.
7. **Build.** Compose exported widgets. Follow
   [page-blueprint.md](references/page-blueprint.md) for pages and sections, and
   [component-spec.md](references/component-spec.md) for anything reusable.
   Product UI stays outside the system-owned component directory.
8. **Cover platform, access, theme, and copy.**
   [responsive.md](references/responsive.md),
   [accessibility.md](references/accessibility.md),
   [theming.md](references/theming.md), [copy.md](references/copy.md). For
   agent-facing work, [agent-console.md](references/agent-console.md).
9. **Verify and hand off.** Run the ladder, the scanner, and the completeness
   gate in [verify.md](references/verify.md). Report the mode, the commands you
   actually ran, what you inspected, and the limitations.

## Non-negotiable contract

Paths here are repository-mode names. In consumer mode substitute
`lib/design_system/foundation/` for `lib/src/design_system/foundation/`,
`lib/components/ui/` for `lib/src/components/ui/`, and `lib/blocks/` for
`lib/src/blocks/`, and import through the generated barrels. See
[system-map.md](references/system-map.md).

Effect and motion widgets are components: they live in
`lib/src/components/ui/` alongside every other control. Motion values live in
`lib/src/design_system/foundation/motion.dart`. Complete application
compositions are blocks, under `lib/src/blocks/`.

**Source of truth.** Import through the entry point your mode provides. Never
reach past it into private internals. Geometry from `space(...)`,
`LayoutWidths`, `Containers`, `Breakpoints`, `Radii`, or component APIs. Color
from `ThemeScope.of(context)` by semantic role. Type from `StyledText` and
`TextStyles`. Timing from `MotionDurations`, `MotionCurves`, and the motion
widgets. No raw colors, sizes, weights, tracking, leading, radii, shadows,
stock curves, or `Duration` literals outside the foundation, and no literal
hidden behind a local constant.

**Completeness.** Every surface that reads data handles loading, refreshing,
ready, empty, no results, and failure. Every write handles submitting, success,
and failure, and cannot be submitted twice. Every trigger produces exactly one
kind of feedback and leads to a next step. Every terminal state says what
happened and what to do now.

**Errors are for people.** No status code, stack trace, exception name, or
backend string in user copy. Failures are mapped to an `AppError` at the data
boundary and rendered with a title, a body, and one next step. Diagnostics live
behind a disclosure and in the log.

**Access.** Every icon-only control has a label. Every input has a visible
label. Focus is visible, ordered, trapped in overlays, and restored on close.
Async results are announced. Nothing is communicated by color alone. Text scales
to 200 percent without clipping.

**Composition.** Prefer a semantic system component over a styled `Container`,
`Text`, `ElevatedButton`, or an ad-hoc snackbar. Use status variants only for
their meaning, and keep one clear primary action. Never change a foundation
token to solve a single screen, and never use `Theme.of(context)` as a parallel
visual system.

## Decisions and handoff

Choose the existing system contract before creating one.

- Reuse a primitive after inspecting its constructor, its test, and its example.
- In consumer mode, check whether the primitive is merely not installed yet:
  `elattar add --dry-run <item>`. Installing beats hand-rolling.
- Add a system primitive only when it meets every requirement in
  [component-spec.md](references/component-spec.md). One-off patterns stay in
  product code.
- Installed sources in a consumer project are that project's own code and may be
  edited, but `elattar add --overwrite` replaces them. Record any customisation.
- Hand off: the contract, changed files, API inventory, states covered, token
  and motion compliance, scanner output, automated and visual verification, and
  limitations. Apply the gate in [verify.md](references/verify.md).

## References

- [system-map.md](references/system-map.md) mode discrimination, topology, discovery.
- [ui-contract.md](references/ui-contract.md) the artifact to write before any widget.
- [states.md](references/states.md) the state model and what renders each state.
- [errors.md](references/errors.md) taxonomy, copy, and where failures appear.
- [feedback.md](references/feedback.md) one channel per trigger, timing, next step.
- [page-blueprint.md](references/page-blueprint.md) pages, regions, lists, forms, flows.
- [component-spec.md](references/component-spec.md) when a component is done.
- [accessibility.md](references/accessibility.md) labels, focus, keyboard, announcements.
- [responsive.md](references/responsive.md) breakpoints, insets, input, content stress.
- [theming.md](references/theming.md) tokens, both themes, effects.
- [copy.md](references/copy.md) microcopy rules.
- [visual-direction.md](references/visual-direction.md) hierarchy, restraint, references.
- [agent-console.md](references/agent-console.md) agent interaction requirements.
- [traps.md](references/traps.md) common failure modes.
- [verify.md](references/verify.md) the ladder, the scanner, and the gate.

## Templates

- [ui-state.md](templates/ui-state.md) the sealed state model.
- [app-error.md](templates/app-error.md) error taxonomy, mapper, and copy table.
- [async-section.md](templates/async-section.md) one region, every state.
- [page-scaffold.md](templates/page-scaffold.md) a page whose regions fail independently.
- [component-doc.md](templates/component-doc.md) the component documentation block.
