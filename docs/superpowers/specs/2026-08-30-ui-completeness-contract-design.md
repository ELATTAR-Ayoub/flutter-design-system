# UI completeness contract for `elattar-flutter-ui-director`

Date: 2026-08-30
Status: approved, ready to implement

## Problem

The skill teaches discovery and token discipline well. It does not define what a
finished screen contains. A team that is weak at frontend work can follow every
rule in the current skill and still ship a page with no empty state, a button
that does nothing visible, and an error that reads `Exception: null`.

The product goal is the opposite: a team buys this skill, hands it to people who
are not frontend specialists, and gets complete UI quickly. Complete means every
surface handles its states, every trigger answers the user, every failure is
written in human words with a next step, and every control is reachable by
keyboard in both themes at every width.

## Gaps found in the current skill

1. No gate. All guidance is prose. Only the token rule has a test.
2. Five states named. Real surfaces need first load, refresh, pagination,
   empty, no results for a filter, forbidden, not found, offline, validating,
   submitting, optimistic rollback, timeout, unsaved changes, destructive
   confirmation.
3. No error translation. Nothing forbids surfacing backend text.
4. No feedback rule per trigger. Silent actions pass review.
5. Pages and sections are unaddressed. Region level state is not covered.
6. The next step requirement exists only inside the empty state row.
7. Accessibility is one paragraph and is not checkable.
8. No definition of done for a component.
9. No microcopy rules.
10. No templates to copy.
11. Structure is inverted: 62 dense lines always loaded, four references of 5 to
    14 lines loaded on demand.
12. No prescribed async state model, so every screen invents one.

## Decisions

| Decision | Choice |
| --- | --- |
| Enforcement | A required contract artifact, a completeness gate, and a script that catches mechanical violations. |
| State model | One prescribed sealed model, with a documented mapping for teams already on Bloc or Riverpod. |
| Errors | A fixed taxonomy mapped to title, body, next step, channel, retryable, hidden diagnostics, plus filled copy templates. |
| Scope | Full restructure in one pass. |

## Design

### The UI contract

Before writing widgets the agent emits a short block per surface. It is the
input to the gate, and it is deliberately small enough that nobody skips it.

Fields: surface and kind, the job in one sentence, the primary action, each
async data source, state coverage per region, one feedback channel per trigger,
responsive structure per breakpoint, accessibility notes, theming notes.

### The state model

`UiState<T>` with `idle`, `loading`, `refreshing`, `ready`, `empty`,
`noResults`, `error`. `SubmitState` with `idle`, `submitting`, `succeeded`,
`failed`. Shipped as a copyable template in product code, not as a package
export, so a consumer app can adopt it without a package release. A mapping note
covers Bloc and Riverpod projects.

A fixed table binds each state to the real component that renders it: `Skeleton`
for first load with layout preserved, in place `Spinner` or `Progress` for
refresh with no layout shift, `Empty` with a primary action for empty,
a distinct `noResults` presentation whose action clears the filter, `Alert` for
a region level failure, `Toast` for transient outcomes, `AlertDialog` only for
blocking decisions.

### Error taxonomy

Eleven categories: `offline`, `timeout`, `unauthenticated`, `forbidden`,
`notFound`, `conflict`, `validation`, `rateLimited`, `server`, `cancelled`,
`unknown`. Each maps to a presentation of title, body, one next step, channel,
retryable flag, and diagnostics that never reach user copy. Raw backend text is
allowed only behind a details disclosure and in logs.

### Feedback contract

Every trigger declares exactly one channel: inline state, toast, dialog,
navigation, optimistic update, or field validation. Press acknowledgement is
immediate, a busy state appears past roughly 400 ms, explanatory copy past
roughly 2 s, destructive work names its consequence before it runs, hard to
reverse work offers undo, and asynchronous state changes are announced to
assistive technology.

### Page and section blueprint

Page anatomy, and the rule that each region owns its state independently. A page
level error is reserved for a page that cannot render at all. Every terminal
state states what happened and what to do next.

### Component definition of done

Usage, variants, the full interaction state set, keyboard map, semantics,
responsive behavior, both themes, a specimen route where the mode has one, one
test per state, and a documentation block.

### The gate

`verify.md` gains a completeness checklist filled with evidence, plus
`scripts/check_ui_completeness.dart`, a dependency free scanner run with
`dart run`. It flags raw exception text reaching the UI, awaited work with no
loading branch, list rendering with no empty branch, dead `onPressed` bodies,
and icon only controls with no label. It reports findings and exits non zero so
it can gate a commit. `custom_lint` is deliberately avoided because it breaks in
this pub workspace.

## File layout

```
SKILL.md                      router, non negotiables, the gate
references/
  system-map.md               unchanged
  ui-contract.md              new
  states.md                   new, replaces state-accessibility.md
  errors.md                   new
  feedback.md                 new
  page-blueprint.md           new
  component-spec.md           new
  accessibility.md            new, split from state-accessibility.md
  responsive.md               new, replaces platform-contracts.md
  theming.md                  new
  copy.md                     new
  visual-direction.md         unchanged
  agent-console.md            unchanged
  traps.md                    extended
  verify.md                   extended with the gate
templates/
  ui-state.md                 the sealed state model
  app-error.md                taxonomy, mapper, copy table
  page-scaffold.md            page with regions
  async-section.md            one region, every state
  component-doc.md            the documentation block
scripts/
  check_ui_completeness.dart  the scanner
```

Templates are Markdown holding Dart code fences rather than `.dart` files,
because `flutter analyze` walks the package root and would fail on template
files whose relative imports do not resolve. The scanner is real Dart with no
imports beyond `dart:io`, so it analyzes clean.

## Success criteria

- An agent following the skill cannot claim a screen is done without a filled
  contract and a passing gate.
- The scanner catches a raw backend error string, a missing loading branch, a
  missing empty branch, a dead press, and an unlabelled icon button in a
  deliberately broken fixture.
- Every state, error category, and feedback channel names a component that is
  actually exported by this package.
- SKILL.md stays a router: no reference detail is duplicated in it.
