# Base phase 2 — Selection, Feedback, Selects — Implementation Plan

> **For agentic workers:** you receive exactly one task. Inputs: this plan +
> the research map(s) named in your task. File ownership is the law. The
> phase-3 plan's global constraints carry verbatim (guard patterns, verbatim
> copy with drift registers, no third-party deps, no `pumpAndSettle` over
> loopers, geometry tests load real font binaries). Two standing rules from
> phase 3's close: **any painter work ships rendered-pixel pins + a browser
> probe** (CanvasKit collapses blurred difference-paths — inset rings are
> `drawDRRect`; never blur a combined path), and **duration-`<word>`
> utilities are no-ops** — class-list transitions run
> `ElDurations.transitionDefault` (250ms) unless globals.css reads the var
> directly (the sweep already corrected every shipped site).

**Goal:** the `selection`, `feedback`, and `selects` pages at the measured
bar, building the families they need. **Maps:** `selection-map.md` (637
lines) · `feedback-map.md` (1,294) · `selects-map.md` (993).

## Supervisor rulings (binding)

### Selection (map §15)
| # | Ruling |
|---|---|
| S1 | 150→250ms socket fix — CLOSED, landed by the sweep (7cb4c25). |
| S2 | `ElSlider` horizontal-only to full parity; the `data-vertical:*` branch is dormant — recorded, not built (the asChild precedent). |
| S3 | `bg-action/12` derives from `ElPalette.action` directly (raw-palette access is the port's pattern); no new `ElThemeData` field; doc-comment that `--primary`≡`--color-action` today but the aliases can diverge. |
| S4 | The three unpinnable matrix states become documented package props: `ElCheckbox(inert:)` (controlled-no-handler — full opacity, no pointer), `ElSelectionControl(forceFocusRing:)` (gallery still — real focus is exclusive; the B8/Q1 precedent), `ElFieldLabel(spec:)` override (the `font-normal` site). `selects`/`feedback` reuse the same three. |
| S5 | Bulk header / option card stay page-local — kit promotion requires a second consuming page (B10 precedent). |
| S6 | Drift 3 (bulk tints frozen literals, page breaks its own don't 4) — reproduce exactly. |
| S7 | Drift 11 (slider thumb `disabled:` classes never match) — reproduce; root dims once. |

### Feedback (map §16)
| # | Ruling |
|---|---|
| F1 | Bloom drift+hover composition: builder's design freedom within the measured triples; `ElBloomCosmic` may become stateful; painter rule applies in full. |
| F2 | All 69 rest-state loopers build fully; `?motion=reduced` is the only gate. NO out-of-view optimization — the reference has none; fidelity beats perf here, recorded. |
| F3 | `text-balance`/`text-pretty` stay unreachable-recorded; parity height measured greedy. |
| F4 | The collapsed toast stack ports faithfully (back toasts blanked, scaled, height pinned to the front toast's measured height; expand-on-hover; the three exit paths; hover-pause resumes from the stored remainder). The shipped queue contract retunes — its pins update with the behaviour, bite-proven. |
| F5 | Sonner's unnamed `ease` = CSS standard `ease` `(.25,.1,.25,1)` → `ElCurves.cssEase`, doc-commented to sonner's stylesheet. New `ElDurations.sway`/`swayAlt` members only if not already staged (map says staged — verify). 18s/11s land under their names. |
| F6 | `_referenceHeight['feedback'] = 6106` accepted (toaster is fixed-position; pristine safe). |
| F7 | `ElStarfield` lives in `lib/src/effects/`; the sparkle path joins `icon_paths.dart` as an off-set addition (single-writer rule: the feedback builder owns icon files this phase). |
| F8 | `toast.promise` builds (it is on the page). |
| F9 | Close both stale in-file records (ElToastType.glyph KNOWN GAP; bloom theme-var note) — rider on the feedback builder. |
| F10 | `pr-20`'s unconditional 80px action lane reproduces. |

### Selects (map §18)
| # | Ruling |
|---|---|
| L1 | Wave split adopted (below). |
| L2 | Calendars reproduce `getInitialMonth` (current month). The rig freezes the clock BOTH sides: web via `evaluateOnNewDocument` Date shim; Flutter via a `?clock=` boot param (a D-style seam task, same pattern as `?motion=`). Parity heights pinned under the frozen clock. |
| L3 | Calendar geometry (196px intrinsic, 268.571/304.571 heights, 293.29 palette, 412 combobox popup) is derived-never-seen — the wave-C builder's FIRST act is a computed-style probe; build to the probe, not the derivation. |
| L4 | `ElSelect.expand` stays; optional `width` added, wins when set. |
| L5 | Disabled cell's empty `SelectContent`: nothing-opens is the parity — reproduce. |
| L6 | `ElNativeSelect` = option (c): faithful 32px no-socket closed control, the port's own menu, divergence recorded prominently. **First by-construction divergence in the port — flagged for the user in the phase report.** |
| L7 | `rounded-xl!`/`bg-popover` on Command: probe `[data-slot=command]` before building; the tailwind-merge derivation is stated, not trusted. |
| L8 | `ElComponentType.menuLabel` + `menuShortcut` (+ `menuHeading` at weight 500 if the probe confirms); no new `ElType` rung. |
| L9 | `commandScore` ports verbatim (filter AND re-sort — row order is visible fidelity). |
| L10 | `ElDateFormat` in `foundation/` — twelve strings, no `intl`. |
| L11 | `ElPopover`: side/align/offset + collision flip; no arrow; no nested portals. |
| L12 | duration-word — CLOSED by the sweep. |
| L13 | The selects route stays on `PlaceholderPage` until all seven promised sections exist (the page's own §6 lesson). Selection/feedback routes wire at their own integration. |
| X1 | Sweep's out-of-scope find: `transition-colors` REPLACES the `press` shorthand on `theme-toggle.tsx:99` — the squish snaps there. `theme_toggle.dart` corrects to snap (no transform tween on that control only); rider on wave A3's owner… assigned A1 (example-side file). Navigation-page sites wait for their family. |

## Waves

**Wave A (3 parallel Opus builders).**
- **A1 — selection.** `lib/src/components/slider.dart` (new, S2), the three
  S4 props (owns `checkbox.dart`, `selection_control.dart`, `field.dart`
  narrowly for them), X1 in `example/lib/theme_toggle.dart`,
  `example/lib/pages/selection.dart` + test (oracle: supervisor measures
  before page work; `_referenceHeight` 4252.14 already measured), drift
  register 15. Kit: `ElStateGrid` maps cols 6/3 already — no kit grant.
- **A2 — selects core.** Six `ElSelect` deltas (incl. the `_placement()`
  fix for grouped lists), `popover.dart`, `native_select.dart`,
  `combobox.dart` (+ `ElIconGlyph.calendar` NO — calendar glyph waits for
  wave C; A2 touches no icon files), `menuLabel`/`menuShortcut` specs in
  `typography.dart` (sole writer), L4 width param. Package tests. No page.
- **A3 — feedback effects.** `ElStarfield` (+ sparkle path in
  `icon_paths.dart` — A3 is this phase's icon writer), bloom drift+hover
  (F1), `AlertAction` + F10 lane, `ElProgress`, `ElSkeleton`, the
  `ElEmpty` family (with the never-paints dashed border and the defeated
  icon size reproduced), F9 record closures. Package tests; painter rule
  in full force.

**Wave B (after A, parallel).**
- **B1 — command palette** (`command.dart`, verbatim `commandScore`, L7
  probe first).
- **B2 — sonner choreography** (toaster v2 per F4/F5 — owns
  `toaster.dart`; retunes the queue-contract pins bite-proven).
- **B3 — pages: feedback + oracle** (page + test + route arm at its own
  integration; `_referenceHeight` 6106).

**Wave C.** `calendar.dart` + `ElDateFormat` + `?clock=` seam (+ L3 probe
first, L2 rig support) → selects page (all seven sections, L13) →
integration (routes, parity entries, suites) → full rig pass (selection /
feedback / selects × 2 themes + frozen-clock handling) → phase report
(sign-off: L6 native-select divergence; F4 stack behaviour change).
