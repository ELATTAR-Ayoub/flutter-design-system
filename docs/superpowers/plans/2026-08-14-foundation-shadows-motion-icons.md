# Foundation phase 2 — Shadows, Motion, Icons — Implementation Plan

> **For agentic workers:** you receive exactly one task from this plan. Your
> inputs are this plan plus the research map(s) named in your task. Do not
> touch files outside your ownership list — file ownership is what makes the
> tasks parallel-safe. REQUIRED reading before any code: your map in full,
> then the constraint block below.

**Goal:** Port the three remaining foundation pages — `/design-system/shadows`,
`/design-system/motion`, `/design-system/icons` — at the same measured parity
bar as the four delivered pages, building the package layers they need
(effects, missing button variants, input, icon capabilities, 59 glyphs,
keyframes) on the way.

**Inputs (complete, self-contained):**
- `docs/superpowers/research/shadows-map.md` (705 lines)
- `docs/superpowers/research/motion-map.md` (63 KB)
- `docs/superpowers/research/icons-map.md` (655 lines)
- The delivered pages as structural templates (`example/lib/pages/spacing.dart`
  is the closest cousin for specimen grids).

**Architecture:** unchanged — literals only in `lib/src/foundation/`;
`DsMachineSurface` for anything inset; `DsOklab.mix` derivations over frozen
hexes so a rebrand carries; every animation duration routed through
`dsAnimationDuration` (reduced-motion gate); source-line doc comments in the
house style (`utility name — globals.css Lnnn`).

## Global constraints (verbatim rules every task inherits)

1. Token guard (`test/token_guard_test.dart`): outside `lib/src/foundation/`
   no `Color(0x`, `Color.from`, `fontSize:`, `letterSpacing:`,
   `FontWeight.w<d>`, `Curves.`, `Duration(milliseconds:<d>`,
   `BorderRadius.circular(<d>`, `BoxShadow(`. Escape:
   `// allow-hardcoded: <reason>`. Glyph coordinates are guard-clean by
   construction.
2. Fidelity bar: the reference's sections, order and copy verbatim — drift
   included, recorded in the page's doc comment, never fixed (17 motion
   drifts, 10 shadows drifts, the icons chip/anchor mismatch, the 44px-copy /
   48px-pixels glass line).
3. No third-party dependencies. No `pumpAndSettle` in any test that mounts an
   infinite animation — `pump(Duration)` with explicit steps, and probe tests
   run under `MediaQuery(disableAnimations: true)`.
4. Zero re-declared fonts, zero new nav entries (all three exist and are
   test-guarded), no edits to `example/lib/main.dart` (the supervisor wires
   the three route arms at integration).

## Supervisor rulings on the maps' open questions

| # | Question | Ruling |
|---|---|---|
| S1/S10 | Reference heights for parity probes | Supervisor measures with the capture rig at integration; implementers land probes with a `skip: 'measured at integration'` marker the supervisor removes. |
| S2 | Infinite foil vs tests | Constraint 3 above; every effect controller routes through `dsAnimationDuration`, so `disableAnimations` freezes them to frame 0. |
| S3 + M-ledger | Off-scale timing literals (2.6s, 620ms, 11s, 5.5s, 2.4s, 220ms, 550ms, 800ms, 900ms, 1.4s, 2s, 175ms step) | New named constants in `DsDurations` with source-line comments — the `pressDown`/`animJelly` precedent: the constraint is that literals live in the foundation layer, not that the reference happened to name them. Names: `beatHover`, `beatPress`, `foilDrift`, `glint`, `glintHover`, `pressSpringUp`, `popIn`, `springUp`, `signOn`, `ratchet`, `shimmer`, `pulseLive`. |
| S4 | Reduced motion on foil/beat | Gate them. Not a divergence: the reference's blanket `prefers-reduced-motion` rule collapses ALL animations to 0.01ms, foil included — `dsAnimationDuration` IS that blanket rule. |
| S5 | Button variant scope | All five missing variants now: `primary` (default), `premium`, `secondary`, `destructive`, `link` — the icons page needs `destructive` regardless, and the enum completes once. |
| S6 | Input | Genuinely editable (`EditableText`-backed), keyboard-focusable, real caret — "everything is a live component". |
| S7 | `glass-panel-deep` | Build with its sibling; it is an e4-for-e2 swap and the CSS pairs them. |
| S8 | 44px copy vs 48px specimen | Render 48, print 44. Fidelity bar. |
| M1 | `ds-travel` zero px | **Verified live by the supervisor** (all four chips hold `matrix(1,0,0,1,0,0)` on a 482px track after the run). Ship the no-op; doc-comment carries the mechanism and the one-line change that would mirror an upstream fix. |
| M2 | press-spring 220ms | `DsDurations.pressSpringUp` token (S3). Drift stays visible in the demo's note copy, which prints the real numbers. |
| M3 | `brightness()` | Live `ColorFilter.matrix` per theme; the map's precomputed table is the probe oracle, not the source. |
| M4 | Orthographic reveal | Ship orthographic (no perspective on the reference, verified in the map); supervisor does one visual A/B on the rig captures at integration. |
| M5 | Press-button base font | Implementer uses 16px with an `// integration-verify` marker; supervisor confirms via computed-style probe before removing the marker. |
| M7 | Ratchet under reduced motion | Lands on 0° (CSS: no fill mode, one collapsed iteration → initial state). |
| M8 | `DsCurves.all` docstring order lie | Fix the docstring in Task A (do not reorder the list — call sites may index it). |
| M-bug | `sliding_pill.dart:71–74` jelly bypasses `dsAnimationDuration` | Fix in Task A. |
| I-Q1 | Usage code block TSX vs Dart | **Dart, exactly the map's proposed text** — a code sample's job is to be executable by its reader, and the user's stated purpose is customers building Flutter apps from these docs. The one deliberate translation on the page; recorded in the page doc comment and surfaced to the user for override. |
| I-Q2 | Alias glyph names | Curated names on the enum (`filter`, `helpCircle`, `alertTriangle`); lucide module named in each transcript comment. |
| I-Q3 | 14→16px button icon override | Write `DsIconSize.md` + comment the reference's overridden `size="sm"`. |
| I-Q4 | Six chips, six sections | Keep the six real sections; record the chip/anchor drift. |
| I-Q5 | Sheen scope for icons page | Superseded: Task A ships the full sheen for the shadows page; the icons page consumes the finished effect. |
| I-Q6 | muted/subtle twin swatches | Comment in the page, mirroring `icon.dart`'s own rationale. |
| I-Q7 | Bounds assertion vs arcs | Spike `star`, `zap`, `sparkles`, `crown` first; run `flutter test test/icon_paths_test.dart` before transcribing the remaining 55. |
| I-Q8 | `<pre>` scroller | Build it (the Dart sample's 96-char line will need it even though the TSX never scrolled at 1440). |

---

### Task A — Package: effects, buttons, input, timing tokens, keyframes

**Model:** opus. **Map:** shadows-map (primary) + motion-map §keyframes/§utilities.
**Owns (exclusive):** `lib/src/foundation/motion.dart`, `lib/src/effects/sheen_action.dart` (new), `lib/src/effects/foil_value.dart` (new), `lib/src/effects/glass.dart` (new), `lib/src/components/button.dart`, `lib/src/components/input.dart` (new), `lib/src/motion/` (all, incl. new `keyframes.dart`), `test/effects_test.dart` (new), `test/components_test.dart`, `test/motion_test.dart`, barrel exports in `lib/elattar_design_system.dart`.

- [ ] `DsDurations` additions per ruling S3, each with its globals.css / page source line.
- [ ] `lib/src/motion/keyframes.dart`: the eleven keyframe tables from motion-map §keyframes as const data (stop, transform components, opacity, filter terms), a `TweenSequence`-based player builder, and a `DsSteps(n, {jumpEnd})` curve. `sign-on`'s stepwise timeline modelled per the map (stepped evaluation, not interpolation). Reduced motion: player resolves through `dsAnimationDuration`; `both`-fill anims freeze at the final stop, no-fill loopers at stop 0.
- [ ] `glass.dart`: `DsGlassPanel` / `DsGlassPanelDeep` / `DsGlassControl` per shadows-map §7 — `card@74%` over σ24 blur + the §13.5 saturate matrix, `rim-strong` top inset, `foreground@12%/16%` ring via `DsInsetShadowPainter`-equivalent (the port's machine-surface inset path), e2/e4 outer.
- [ ] `sheen_action.dart` + `foil_value.dart` per shadows-map §5 — every gradient stop derived with `DsOklab.mix` from `DsPalette` (the map's resolved hexes are test oracles, not source); blend modes per theme (`luminous` split); beat/glint/drift on the new tokens; controllers through `dsAnimationDuration`; `RepaintBoundary` around infinite layers.
- [ ] `button.dart`: five new variants with the map's exact state matrices (22 states); premium hover swaps `btnValue`→`glowValue` wholesale; active outranks hover; focus ring = 3px `ring@35%/50%` per map, composited in front of the surface shadow; shared focus-ring helper.
- [ ] `input.dart`: 40px pill, `--input` border, `--card` fill, `pressed` socket, placeholder at muted, focus border `primary@50%` + 3px ring `ring@35%`, 250ms `--ease-out`, genuinely editable (ruling S6).
- [ ] Fix `sliding_pill.dart:71–74` (route jelly duration through `dsAnimationDuration`); fix `DsCurves.all` docstring (M8).
- [ ] Tests: effect gradient stops vs the map's hex oracles; button state matrix per variant; input focus states; keyframe evaluation at the map's sampled stops; steps curve; reduced-motion freeze frames. `flutter analyze` + `flutter test` green.

### Task B — Package: icon capabilities + 59 glyphs

**Model:** opus. **Map:** icons-map §12.
**Owns (exclusive):** `lib/src/components/icon_paths.dart`, `lib/src/components/icon.dart`, `test/icon_paths_test.dart`.

- [ ] Capability pass FIRST (icons-map build-order constraint): `DsIconPolylineElement`; fill support (two-pass paint, `filled` flag on the element model — keep the stroke pass's single-`Path` contract by collecting fills separately); `rect` `ry` honoured; then the four-glyph arc spike (`star`, `zap`, `sparkles`, `crown`) and a bounds-assertion run before mass transcription.
- [ ] Transcribe the remaining 55 curated glyphs from lucide-react 1.28.0 modules (the map tables every module path; three deprecated-alias traps resolved per ruling I-Q2), plus `rotateCcw` and `sparkles` needed by the motion page's replay buttons and reveal demo.
- [ ] Per-glyph transcript assertions in the existing style; all-glyph bounds test; `flutter analyze` + `flutter test` green.

### Task C — Page: shadows (after A)

**Model:** opus. **Map:** shadows-map. **Owns:** `example/lib/pages/shadows.dart` (new), `example/test/shadows_page_test.dart` (new).
- [ ] The seven blocks in order (page Note, six sections), copy verbatim, all specimens through `DsShadows.*` specs and `DsMachineSurface`; live buttons (five variants) and the editable input; glass on the real widgets; drifts 1–10 recorded in the doc comment.
- [ ] Page test modelled on `spacing_page_test.dart` (structure, copy spot-checks, both themes) with `pump(Duration)` only.

### Task D — Page: motion (after A and B)

**Model:** opus. **Map:** motion-map. **Owns:** `example/lib/pages/motion.dart` (new), `example/test/motion_page_test.dart` (new).
- [ ] Replay counter keying 16 elements, three loopers unkeyed; `run N` note; CurveGraph painter with the letterboxed 65.1px square (never fill-the-box); the four exact path strings; zero-travel chips per ruling M1; the three press demos + lift; nine named-animation demos on the Task-A player; choreography Meta; reduced-motion panel; 17 drifts recorded.
- [ ] Page test: replay remount behaviour, reduced-motion final frames, structure/copy, both themes.

### Task E — Page: icons (after A and B)

**Model:** opus. **Map:** icons-map. **Owns:** `example/lib/pages/icons.dart` (new), `example/lib/kit.dart` (the `<pre>` code-block widget ONLY — single-writer rule), `example/test/icons_page_test.dart` (new).
- [ ] The six sections verbatim; the Dart usage block per ruling I-Q1; size/tone label tables (`default`/`2xl`/`3xl` spellings); the five button pairings on Task-A variants; all 63 curated tiles from the registry; foot-nav prev-only with spacer.
- [ ] `DsCodeBlock` in kit: `DsType.code` at 1.625 leading, muted ink, background fill, 12px radius, 20px padding, `DsThinScrollbar` horizontal.
- [ ] Page test per the house pattern.

### Task F — Integration (supervisor, inline)

- [ ] Wire three route arms + imports in `example/lib/main.dart`; `flutter analyze`; full `flutter test` (both packages).
- [ ] Measure reference heights for the three routes on the rig; pin `vertical_parity_probe_test.dart` + wrap expectations; remove skip markers.
- [ ] Rig run: 3 pages × 2 themes; heatmap review; fix drift to the four-page bar; M4 visual A/B; M5 font probe.
- [ ] Docs: CHANGELOG, memory update, drift registers cross-linked; report to user (including the I-Q1 translation for sign-off).

## Execution order

A ∥ B (file-disjoint) → C ∥ D ∥ E (C needs A; D, E need A+B) → F.
