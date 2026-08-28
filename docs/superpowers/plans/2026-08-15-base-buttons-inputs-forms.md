# Base phase 1 — Buttons, Inputs, Forms — Implementation Plan

> **For agentic workers:** you receive exactly one task. Inputs: this plan +
> the research map(s) named in your task. File ownership is the law — it is
> what makes the waves parallel-safe. The phase-2 plan's Global constraints
> carry over verbatim (guard patterns, verbatim copy with drift registers,
> no third-party deps, no `pumpAndSettle` over infinite animations, geometry
> tests load the real font binaries or they are structure tests only).

**Goal:** Port the first three base-component pages — `/components/base/buttons`,
`/inputs`, `/forms` — at the measured bar the seven delivered pages hold,
building the component families they need as real, reusable package
components.

**Maps:** `buttons-map.md` (728 lines) · `inputs-map.md` · `forms-map.md`.
**Oracles:** measured by the supervisor before the page wave; delivered in
each page task's brief (per-section document geometry + the two
computed-style answers inputs-map §18.9 needs).

## Supervisor rulings (binding)

| # | Ruling |
|---|---|
| B1 | All nine sections including IconSwap — the chips are a subset in the reference too. |
| B2 | Per-size button type lives in `ComponentType` (foundation owns sizes; one owner). |
| B3 | Build `icon-xs`: nine of nine cva sizes; the printed API row stays true. |
| B4 | No `asChild` port. Meta row verbatim; divergence recorded. |
| B5 | The loading spinner glyph (lucide `loader-circle`) joins the off-curated set like `rotateCcw`; `Spinner` + `Button.loading` ship now (also F2). |
| B6/B7 | Toggle/ToggleGroup genuinely interactive; single-type deselection mirrored (`activeIndex: -1` path). |
| B8 | The Hover-identical-to-Default and hand-drawn Focus cells reproduce exactly; drift register carries the observation. |
| B9 | Spinner a11y mirrors the web (excluded from semantics; button exposes busy); recorded. |
| B10 | `_HairlineGrid`/`_EntryCell` promote to kit as `StateGrid`/`StateCell` (kit is the buttons-page builder's single-writer file this wave; the icons page migrates to them in the same edit). |
| B11 | Route arms + `shell_test` tightening (`isNotNull` must not pass on `PlaceholderPage`) happen at integration, supervisor-assigned. NOTE: the map's "three unrouted pages" claim is stale — shadows/motion/icons are wired and verified. |
| B12/I8/F3 | Oracles are supervisor-measured BEFORE page tasks; forms is measured pristine (nothing typed, nothing submitted) and its page test pumps the same pristine state. |
| B13 | Reduced motion = instant (durations to zero via `elAnimationDuration`), never disabled; foil/loopers freeze at frame 0. Confirmed equivalence. |
| I1 | All five net-new input components are real package components — `forms`, `selects`, `selection` consume them next. |
| I2 | `Input` stays the bare pill; addon machinery lives in `InputGroup` (the reference strips, not extends). Existing call sites untouched. |
| I3 | Drifted Hover/Focus input cells ship exactly; the fake focus ring is page-local painting, not a component API. |
| I4/F6 | Off-scale timings become named `Durations` members (`caret` 1000, plus forms' 200/280/320/600/900 under their utility names) — one policy, the phase-2 precedent. |
| I5 | `Radii.addonButton` as a derived getter (`radius − 3`), preserving the CSS relationship. |
| I6 | `atSign`/`ticket` join the off-curated glyphs; the registry tests keep excluding them. |
| I7 | Ship the measured 13px where `text-sm` beats `.type-num` (utilities beat components); doc-comment the collapse. |
| I10 | Fix the `Input` selection-alpha bug (0.30 → 0.35) in the P2 task. |
| F1 | Scope: form/field/validator layer + `Button.loading` fully; Textarea/Checkbox/Radio/Switch to full parity; `Select` and `Alert` to the fidelity this page renders (working menu; static-bloom alert), full matrices deferred to `selects`/`feedback`. |
| F4 | **Deliberate behavioural fix, flagged for user sign-off in the phase report:** focus-on-error is implemented correctly for ALL fields; the reference's silent failure on the composed form is recorded as divergence. An invisible a11y regression is the one drift class we do not ship. |
| F5 | `aria-invalid` erasing the focus ring reproduces exactly — visible, measured, the reference's own cascade. |
| F7 | Validator = dependency-free `Rule<T>` lists with first-issue / all-issues collection; the Zod-4 email regex ships verbatim as one rule. |
| F8 | `Toaster` widget in `lib/`; its mounting in `example/lib/shell.dart` (narrow grant to the forms-page builder), mirroring the root-layout split. |
| F9 | Both AccountForms live. |
| D-carry | `PressKey` promotion from the motion page happens only if the buttons page needs it (map says no) — otherwise it stays page-local. |

## Wave P — package components (3 parallel Opus builders)

**P1 — controls.** Owns: `lib/src/components/ui/button.dart`, new
`spinner.dart`, `toggle.dart`, `toggle_group.dart`, `kbd.dart`,
`button_group.dart`, `icon_swap.dart`; `lib/src/design_system/foundation/typography.dart`
(`ComponentType` per-size button styles + caps) and
`lib/src/design_system/foundation/motion.dart` (all new duration tokens for the whole
phase, incl. `caret` and forms' five); `lib/src/components/ui/keyframes.dart`
(check-draw / dash-draw / dot-pop / swap-roll additions); the loader glyph in
`icon_paths.dart` + its transcript test (coordinate: P1 is this phase's
single writer on icon files); package tests for all of it.
Spec: buttons-map §component anatomies + forms-map §submit states.

**P2 — text entry & field layer.** Owns: `lib/src/components/ui/input.dart`
(alpha fix + minimal widening per I2), new `textarea.dart`,
`input_group.dart`, `input_otp.dart`, `field.dart` (Field/Label/Error/
Description), `form.dart` + `validation_rule.dart` (controller + validator per F7);
package tests. Spec: inputs-map §anatomies + forms-map §wiring contract
(ids → describedby/invalid → `Semantics(validationResult:, liveRegion:)`).

**P3 — selection & feedback minimal.** Owns: new `checkbox.dart`,
`radio.dart`, `switch.dart`, `select.dart` (F1 fidelity), `alert.dart`
(static bloom), `toaster.dart` (widget only); package tests. Consumes P1's
keyframes (drawn tick, dash, dot-pop) — coordinate via the plan, not via
shared file edits. Spec: forms-map §components + the reference sources it
cites.

Wave-P exit: `flutter analyze` clean, package suite green with every new
component's state matrix pinned, barrel exports updated by each owner for
its own files.

## Wave Q — pages (3 parallel, after P; oracles in briefs)

**Q1 — buttons page.** Owns `example/lib/pages/buttons.dart`, its test, and
`example/lib/kit.dart` (single writer: `StateGrid`/`StateCell`
promotion + icons-page migration to them). Nine sections, oracle-pinned
geometry group, drift register (24 entries).

**Q2 — inputs page.** Owns `example/lib/pages/inputs.dart` + test. Oracle
group, 17-entry drift register, the measured 13px collapse doc-commented.

**Q3 — forms page.** Owns `example/lib/pages/forms.dart` + test, plus the
narrow `shell.dart` grant for the toaster mount. All nine demos live
(pristine-state geometry per F3), validation trigger/message tables from the
map, focus-on-error per F4, 20-entry drift register.

## Integration R (supervisor + one wiring builder)

Route arms ×3, `shell_test` tightening (B11), full suites, web rebuild,
rig pass (reduced-motion captures via `?motion=reduced`), phase report with
the two sign-off items (F4 here; I-Q1 already shipped in phase 2).

**Guard gap (from the text-entry builder):** token_guard_test has no rule
for `height:` — line-height literals outside the foundation pass silently.
Add the pattern at integration, not mid-wave (it would trip legitimately
in-flight work), and sweep for undeclared line-height literals when it
first runs.

**Carried caveat (from the boot-param builder):** the `disableAnimations`
override sits *below* `MaterialApp`, so pushed routes and Navigator-overlay
entries (dialogs, sheets, an overlay-hosted select menu) do not inherit it.
Nothing this phase's rig captures lives in one — forms is captured pristine
(F3), menus closed. If a later phase captures an overlay surface reduced,
move the override above `MaterialApp` (`MediaQueryData.fromView` inherits
`disableAnimations` from an ancestor `MediaQuery`).
