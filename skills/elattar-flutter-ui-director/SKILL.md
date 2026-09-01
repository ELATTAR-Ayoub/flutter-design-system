---
name: elattar-flutter-ui-director
description: "Build and review Flutter UI with Elattar's installed components and foundation tokens. Applies in the design-system repository and consumer apps with elattar.yaml when work touches screens, flows, components, responsive behavior, theming, accessibility, feedback, or UI documentation."
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

## Choose the depth

Match the process to the risk. Do not turn a copy edit or a read-only review
into a full product-delivery exercise.

- **Quick** — explanation, audit, documentation-only change, or one contained
  correction with no new rendered behavior. Resolve the mode, inspect the
  relevant source, make the scoped change, and run focused checks. No UI
  contract, state matrix, capture set, or full suite unless the change affects
  them.
- **Standard** — a change to an existing screen, component, interaction, or
  responsive layout. Write a short contract for the affected surface, cover
  the states that apply, and run focused tests plus the relevant width, theme,
  text-scale, and accessibility checks.
- **Full** — a new screen or flow, a new system primitive, or a cross-system
  foundation change. Use the complete workflow, verification ladder, scanner,
  captures, and handoff gate.

## Workflow

1. **Resolve the mode.** Step 0 of [system-map.md](references/system-map.md),
   before reading or writing anything. Consumer mode and repository mode put the
   system in different directories, and every path named in this skill is the
   repository-mode name. If neither probe matches, say so and stop.
2. **Choose the depth.** Quick, standard, or full. State it before acting.
3. **Classify the work.** Product screen, package component, lineage-informed
   port, agent console, documentation, or review and fix.
4. **Inventory the real APIs.** Use the discovery commands for your mode in
   [system-map.md](references/system-map.md): barrel, source, tests, specimens.
   Do not guess that a widget exists.
5. **Define the outcome.** For standard work, write a short acceptance contract.
   For full work, write [ui-contract.md](references/ui-contract.md). Quick work
   needs only the requested outcome and the focused check that proves it.
6. **Set the visual direction when visuals change.**
   [visual-direction.md](references/visual-direction.md): one dominant idea, a
   clear hierarchy, at most one supporting effect.
7. **Design the states that apply before the widgets.**
   [states.md](references/states.md), [errors.md](references/errors.md),
   [feedback.md](references/feedback.md). Static documentation and read-only
   reviews do not invent asynchronous states they do not have.
8. **Build.** Compose exported widgets. Follow
   [page-blueprint.md](references/page-blueprint.md) for pages and sections, and
   [component-spec.md](references/component-spec.md) for anything reusable.
   Product UI stays outside the system-owned component directory.
9. **Cover the relevant platform, access, theme, and copy rules.**
   [responsive.md](references/responsive.md),
   [accessibility.md](references/accessibility.md),
   [theming.md](references/theming.md), [copy.md](references/copy.md). For
   agent-facing work, [agent-console.md](references/agent-console.md).
10. **Verify in proportion to the depth.** Use [verify.md](references/verify.md).
    Run focused checks for quick work, the affected surface matrix for standard
    work, and the complete ladder and gate for full work. Report only commands
    actually run and limitations that matter.

## Non-negotiable contract

Apply every clause relevant to the task. Source of truth, access, and
composition always apply. Completeness, errors, and feedback apply when the
surface reads data or accepts interaction; they are not paperwork for static
documentation.

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
- Hand off at the chosen depth. Quick work names the changed files and focused
  checks. Standard work adds the affected contract, states, and render checks.
  Full work reports the API inventory, token and motion compliance, scanner,
  automated and visual verification, and limitations from the complete gate.

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
