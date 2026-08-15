# Behaviour audit — measured web runtime vs shipped port

**The premise this document exists to correct.** Every animation in the port was
built from CSS transcription plus widget maths. Nothing was ever driven and
sampled on the live reference. Transcription tells you what a stylesheet
*declares*; it does not tell you what the browser *runs*. The two differ
wherever a property is not in the transition list, wherever a value pair is not
interpolable, wherever an animation is replaced rather than restarted, and
wherever an observer fires that the source does not obviously call.

Everything below was measured by driving real input (`page.mouse.move/down/up`,
`page.keyboard.press`) against `http://localhost:3000` in headless Chrome at
1440×900, and sampling with a `requestAnimationFrame` loop at ~16.6ms for the
full length of each animation. Every timestamp is on the sampler's own clock;
`t=0` in the keypoint tables is the measured state flip (the `MutationObserver`
record of the attribute/inline-style write), not the script's intent.

Probe scripts (kept, re-runnable):

| file | what it drives |
|---|---|
| `…\scratchpad\ba-lib.js` | shared harness — rAF sampler, `MutationObserver` recorder, `__css` / `__pseudo` readouts, real-input timestamps |
| `…\scratchpad\ba-inventory.js` | DOM inventory of the buttons page |
| `…\scratchpad\ba-toggle.js` | toggle-group pill: three travels + keyboard |
| `…\scratchpad\ba-toggle2.js` | first mount, interruption, standalone `Toggle` |
| `…\scratchpad\ba-swap.js` | icon swap: both demos, forward and back |
| `…\scratchpad\ba-button.js` | button press/hover with pseudo-element sampling |
| `…\scratchpad\ba-active.js` | matched-rule + `:active` state diff |
| `…\scratchpad\ba-button2.js` | shadow interpolation, hover colour, sheen phase |
| `…\scratchpad\ba-scale.js` | the decisive `scale`-property trace |
| `…\scratchpad\ba-focus.js` | focus-ring spread trace + disabled-opacity trace |
| `…\scratchpad\ba-press.js` | control group — the `press` utility's `transform` trace |
| `…\scratchpad\ba-foil.js` | foil drift + glint sweep, and the hover retiming jump |
| `…\scratchpad\ba-deselect.js` | toggle-group deselection |
| `…\scratchpad\ba-swapmount.js` | icon-swap behaviour on first paint |
| `…\scratchpad\ba-swapint.js` | icon-swap mid-roll reversal (interruption semantics) |

Scratchpad root:
`C:\Users\Airen\AppData\Local\Temp\claude\D--DESIGN-Design-System-2026-8-flutter-design-system\f77ee631-b8c7-4eb7-b048-c5221c352b0a\scratchpad\`

---

## Divergence index

Every row below is measured. IDs are referenced throughout and in the fix list.

| id | component | what diverges | severity |
|---|---|---|---|
| **B1** | Button | press scale: web **snaps** instantly both ways; port runs an 80ms eased squish + 250ms spring return with overshoot | **P0** |
| **B6** | Button | short taps compound B1: web always shows a full 0.95; port reaches 0.9756 / 0.9592 / 0.9497 for a 10 / 20 / 30ms hold, then plays the spring backwards over a shortened run | **P0** |
| **T6** | Toggle group | first mount: web pops the pill in (`transition: none`); port fades it over 150ms | P1 |
| **T7** | Toggle group | first mount: web squashes once; port suppresses it | P1 |
| **T8** | Toggle group | deselect: web fades in place; port also slides the pill to the group origin | P1 |
| **T8b** | Toggle group | deselect: web does not squash; port replays the 600ms squash | P1 |
| **B12** | Button | focus ring: web springs the shadow spread 0 → 3.29px → 3px over 250ms; port hard-cuts | P2.5 |
| **B7** | Button / sheen | hover-in: web starts a fresh beat at frame 0; port resumes from the stopped phase | P2 |
| **B8** | Button / sheen | press: web re-divides elapsed time (usually **no** thump); port always plays a fresh 620ms thump | P2 (design call) |
| **B10b** | Button / foil | hover: web re-divides elapsed time and the glint **jumps phase**; port preserves phase and continues smoothly | P2 (design call) |
| **B11** | Button | disabled/loading opacity: web springs 1 → 0.3969 → 0.45 over 250ms; port snaps | P3 |

Of 36 behaviours measured across the four components, **25 match** — including
the entire icon-swap module. Several of the matches look like bugs and are not;
they are listed under "Explicitly protect" at the end, and changing them would
move the port *away* from the reference.

**Scope.** This revision covers the three components named in the critique plus
the standalone `Toggle`. Selection controls, inputs, the shell pill and `kbd`
were probed in a second pass whose numbers are not folded in — §5 records
exactly what exists and what must not be assumed about it.

---

## 0 · Reading the traces — the two curve shapes, measured

Both easings were measured on three independent properties, and both behave
exactly as their bezier predicts. Quoting them once here means every keypoint
table below can be read without re-deriving the shape.

**`--ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1)`** — overshoots the target
by **+9.7% of the delta**, peaking at **≈60% of the duration**, then settles back
onto the target at 100%.

| measurement | delta | peak | overshoot | peak at |
|---|---|---|---|---|
| pill travel right | 74.89px | 82.12px | +9.65% | 67% of 250ms |
| pill travel left | 134.78px | −13.03px past 0 | +9.67% | 67% of 250ms |
| icon-swap strip | 25.60px | 28.10px | +9.77% | 61% of 400ms |
| `secondary` hover bg | 24 sRGB units | +26 units | +8.3% (integer rounding) | 59% of 250ms |

The plateau near the peak is broad, which is why the measured peak *time* spreads
between 59% and 67% — the true bezier peak is ≈57%, and the curve is within
0.3% of its maximum across that whole band.

**`--ease-out: cubic-bezier(0.22, 1, 0.36, 1)`** — no overshoot, extremely
front-loaded: ~90% of the delta lands in the first 30% of the duration, then it
creeps. On a small colour delta it visually saturates in about a third of its
stated duration.

**`yuki-jelly` at 600ms** — the six stops, with `--ease-out` applied
**per segment** (this is what makes each stop plateau before the next move):

| stop | 0% | 30% | 45% | 60% | 78% | 100% |
|---|---|---|---|---|---|---|
| clock | 0ms | 180ms | 270ms | 360ms | 468ms | 600ms |
| scaleX | 1.00 | **1.18** | **0.88** | **1.06** | **0.98** | 1.00 |
| scaleY | 1.00 | 0.82 | 1.12 | 0.94 | 1.02 | 1.00 |
| measured plateau at | — | Δ134–185 | Δ268–285 | Δ334–368 | Δ418–501 | Δ518+ |

Measured stops land on the declared clock to within one frame. **The port's
`DsJelly` / `DsKeyframePlayer` reproduces this exactly** — linear clock, curve on
each gap. That is right, and a naive port would have eased twice. Do not touch it.

---

## 1 · Toggle group — the travelling pill

Source: `components/ui/sliding-indicator.tsx`, `@utility slide-pill`
(`app/globals.css` L2256–2262), `@keyframes yuki-jelly` (L2431–2438).

### 1.1 Measured static CSS

| element | property | value |
|---|---|---|
| `.slide-pill` | `transition-property` | `transform, width, height, opacity` |
| | `transition-duration` | `0.25s, 0.25s, 0.25s, **0.15s**` |
| | `transition-delay` | `0s, 0s, 0s, 0s` — **no lag anywhere** |
| | `transition-timing-function` | `spring, spring, spring, **ease-out**` |
| `.slide-pill > span` (jelly) | `animation` | `yuki-jelly 0.6s 0s cubic-bezier(0.22,1,0.36,1) both` |
| `[data-slot=toggle-group-item]` | `transition` | `all 0.25s cubic-bezier(0.22,1,0.36,1)` (ease-out) |

Group geometry as measured: `Newest` x=325 w=66.89 · `Price` x=399.89 w=51.89 ·
`Popular` x=459.78 w=67.66; gap **8px**; height 32.

### 1.2 What the framework flips vs what CSS transitions

The `MutationObserver` shows the entire state change landing in **one task at
Δ0** — Radix writes `data-state`/`aria-checked` on both items, the hook writes
the pill's inline `width`/`height`/`transform`/`opacity`, and the jelly class is
removed-reflowed-re-added, all in the same 0.1ms window. There is **no
sequencing in JS**. Everything visible after that is pure CSS.

### 1.3 Keypoint table — click `Price` (travel right 0→74.89px, width 66.89→51.89)

State flip at t=137.7. Δ is relative to that.

| Δ (ms) | pill translateX | pill width | jelly scaleX |
|---|---|---|---|
| 0 | 0.00 | 66.89 | 1.000 |
| 18 | 0.00 | 66.89 | 1.000 |
| 36 | 21.12 | 62.66 | 1.070 |
| 52 | 38.63 | 59.14 | 1.120 |
| 68 | 52.66 | 56.34 | 1.140 |
| 85 | 63.72 | 54.13 | 1.160 |
| 102 | 71.67 | 52.53 | 1.170 |
| 119 | 77.15 | 51.44 | 1.180 |
| 152 | 82.00 | 50.45 | 1.180 |
| **168** | **82.12** ← peak | **50.44** ← peak | 1.180 |
| 202 | 79.76 | 50.91 | 1.130 |
| 219 | 78.06 | 51.25 | 0.960 |
| 252 | 75.32 | 51.80 | 0.890 |
| **269** | **74.89** ← settled | **51.89** ← settled | 0.880 |
| 352 | — | — | 1.060 |
| 468 | — | — | 0.980 |
| 518 | — | — | 1.000 ← squash ends |

**Position and width move in lock-step.** Both start on the same frame, both
overshoot by the same 9.7%, both settle on the same frame. There is no width
lag. Total travel 250ms + one frame of latency; the squash runs 600ms
**concurrently**, outliving the travel by 350ms.

Travel left (134.78→0, across two items) is the same shape: peak −13.03px at
Δ168, settled at Δ269.

### 1.4 Label colours

Both labels crossfade **concurrently with the travel**, `all 250ms ease-out`,
no delay. On this dark theme the delta is tiny (`rgb(250,250,250)` ↔
`rgb(255,255,255)`) so it saturates by Δ118; the mechanism is a transition, not
a swap, and on a light theme the same 250ms carries a full contrast reversal.

### 1.5 First mount — **the pill squashes on load**

Recorded from before hydration:

| t | state |
|---|---|
| 352.7 | pill in DOM, `opacity 0`, `width 0`, no inline style |
| **2536.7** | `move()` #1 — inline style written **with `transition: none`**: opacity 0→1, width 0→66.89, transform set. **All instant, in one frame.** |
| 2653.7 | transition restored **and `anim-jelly` is now present and running** |
| 2663.7 | jelly scaleX 1.176 — the squash is playing |

The source's `isFirstMove` guard returns *before* the jelly replay, so the first
`move()` is silent — but the hook also attaches a `ResizeObserver`, whose
mandatory initial callback fires a second `move()` ~117ms later with identical
geometry. That second call takes the jelly branch. **Net observable behaviour:
the pill appears with no travel and no fade, then squashes once.**

### 1.6 Deselection — measured

Clicking the already-selected item deselects the group (all three items go to
`data-state="off"`). The `MutationObserver` records **exactly one style write**:

```
width: 51.8906px; height: 32px; transform: translate(74.8906px, 0px); opacity: 0;
```

Width, height and transform are **unchanged** — only `opacity` moves. Trace,
flip at t=135:

| Δ (ms) | pill translateX | pill width | pill opacity | jelly scaleX |
|---|---|---|---|---|
| 0 | 74.89 | 51.89 | 1 | 1.000 |
| 29 | 74.89 | 51.89 | 0.562 | 1.000 |
| 42 | 74.89 | 51.89 | 0.282 | 1.000 |
| 58 | 74.89 | 51.89 | 0.125 | 1.000 |
| 89 | 74.89 | 51.89 | 0.024 | 1.000 |
| 159 | 74.89 | 51.89 | ~0 | 1.000 |
| 174 | 74.89 | 51.89 | 0 | 1.000 |

**The pill fades out in place over 150ms `--ease-out` and stays parked at the
last selection's rect. The squash does not replay** — `move()` returns in the
`!active` branch before reaching the jelly.

### 1.7 Keyboard — arrows move focus, not the pill

`ArrowRight` on a focused item was traced for 430ms: the pill's transform,
width, opacity and the jelly are **completely unchanged**, and the only
mutations are `tabindex` flips. Radix's `RovingFocusGroup` moves focus with the
arrows; the selection (and therefore the pill) only moves on Space/Enter.

Relevant here only as a guard rail: the port's already-documented decision not
to port roving focus does **not** cost it any pill motion, and a fix wave should
not wire arrow keys to selection on the theory that it would restore something.

### 1.8 Divergence table — toggle group

| # | aspect | measured web | shipped port | verdict |
|---|---|---|---|---|
| T1 | travel duration / curve | 250ms `--ease-spring`, +9.7% overshoot | `AnimatedPositioned` 250ms `DsCurves.spring` | **match** |
| T2 | position vs size timing | identical clock, identical curve, no lag | fused on one `AnimatedPositioned` controller | **match** (values agree; fusion is a latent risk only if the CSS ever splits them) |
| T3 | squash timing | 600ms, starts on the **same frame** as the travel | `_jelly.forward(from:0)` in `didUpdateWidget`, concurrent | **match** |
| T4 | squash keyframes + per-segment easing | 6 stops, per-segment `ease-out`, plateaus verified to ±1 frame | `DsJelly` via `DsKeyframePlayer`, linear clock + per-gap curve | **match — protect this** |
| T5 | label colour | transitioned, 250ms `ease-out` | `_TransitionAllColors`, 250ms `DsCurves.out` | **match** |
| T6 | **first mount — pill appearance** | **instant** (`transition: none` for one frame): opacity 0→1 and width 0→W in a single frame | `AnimatedOpacity` is **ungated** by `_placed` → fades in over 150ms `ease-out` | **DIVERGE** — port fades in where the web pops in |
| T7 | **first mount — squash** | **plays once** (ResizeObserver's initial callback re-enters `move()`) | `_replayJelly()` returns early while `!_placed` → **no squash on load** | **DIVERGE** — port is silent where the web squashes |
| T8 | **deselection — geometry** | **measured:** one style write, `opacity: 0` only; width/height/transform untouched; pill fades in place over 150ms `ease-out` | `left/top/width/height` re-target to `0/0/0/0` over 250ms spring under the fade | **DIVERGE** — port slides the pill to the group origin while fading |
| T8b | **deselection — squash** | **measured:** jelly stays at 1.000 throughout; `move()` returns before the replay | `didUpdateWidget` sees `activeIndex` change to −1 and calls `_replayJelly()` | **DIVERGE** — port squashes a pill that is fading out |
| T9 | replay trigger | `MutationObserver` on `data-state` **plus** a `ResizeObserver` on the container — and the RO path is *not* gated by `isFirstMove`, so **the web also replays the squash on any resize** | `_measure()` replays on any item-rect change; `_measure` is scheduled from every build but only fires `setState`/replay when a rect actually moved | **match** — the group is `w-fit`, so an item resizing resizes the container; the two triggers coincide in practice |
| T10 | interruption | CSS re-targets from the current computed value and runs the **full** 250ms. Measured on the identical mechanism in §2.4/S8 (same inline-style-change-on-a-transitioned-property path); not separately traced here because puppeteer's ~300ms mouse round-trip cannot land inside a 250ms window. | `AnimatedPositioned` re-targets with `forward(from: 0)` — full duration from the current value | **match** |

---

## 2 · Icon swap — the vertical carousel

Source: `components/ui/icon-swap.tsx`, `@utility swap-roll`
(`app/globals.css` L2265–2271).

### 2.1 Measured static CSS and geometry

| element | property | value |
|---|---|---|
| `.swap-roll` | `transition-property` | `transform, opacity` |
| | `transition-duration` | `0.4s, 0.4s` (`--duration-slow`) |
| | `transition-timing-function` | `spring, **spring**` — the opacity leg is on the spring too |
| | `transform` | `translateY(calc(var(--swap-offset) * 160%))` |
| `.swap-roll > span` | `animation` | `yuki-jelly 0.6s **delay 0.15s** ease-out both` |

| demo | clip window | cell (glyph) | step = 160% of cell |
|---|---|---|---|
| ViewSwitch (`size-5`, md glyphs) | 20 × 20 | 16 × 16 | **25.60px** |
| PlayPause (`size-6`, lg glyphs) | 24 × 24 | 20 × 20 | **32.00px** |

The percentage resolves against the **cell**, not the window — confirmed by
direct measurement of the resting inactive cell's offset. The port's call sites
pass `window: ds(5)/ds(6)` and `cell: DsButton.iconPxFor(size)`, which produce
the same 20/16 and 24/20 pairs. **Geometry matches.**

### 2.2 What React flips

`MutationObserver` at Δ0 (one task): both cells' inner `<span>` is **replaced**
(`-SPAN +SPAN`, the `key` change), `aria-hidden` flips, the `opacity-100` /
`opacity-0` classes swap, and `--swap-offset` is rewritten (`0 → -1`,
`1 → 0`). The arriving glyph's jelly is therefore a **brand-new element** whose
600ms animation starts from frame 0 after its 150ms delay.

### 2.3 Keypoint table — ViewSwitch forward (grid→list)

State flip at t=112.2. A = leaving glyph (grid), B = arriving glyph (list).

| Δ (ms) | A translateY | A opacity | B translateY | B opacity | B jelly scaleX |
|---|---|---|---|---|---|
| 13 | 0.00 | 1.00 | 25.60 | 0.00 | 1.00 |
| 30 | −4.68 | 0.82 | 20.92 | 0.18 | 1.00 |
| 46 | −8.77 | 0.66 | 16.83 | 0.34 | 1.00 |
| 63 | −12.49 | 0.51 | 13.11 | 0.49 | 1.00 |
| 96 | −18.51 | 0.28 | 7.09 | 0.72 | 1.00 |
| 129 | −22.87 | 0.11 | 2.73 | 0.89 | 1.00 |
| **163** | −25.76 | **0.00** | −0.16 | **1.00** | 1.00 ← **crossfade complete** |
| **180** | −26.72 | 0.00 | −1.12 | 1.00 | **1.07** ← squash begins |
| **246** | **−28.10** ← peak | 0.00 | **−2.50** ← peak | 1.00 | 1.17 |
| 330 | −26.76 | 0.00 | −1.16 | 1.00 | 1.18 |
| **413** | **−25.60** ← settled | 0.00 | **0.00** ← settled | 1.00 | 0.88 |
| 496 | — | — | — | — | 1.06 |
| 579 | — | — | — | — | 0.98 |
| ~712 | — | — | — | — | 1.00 ← squash ends |

**The crossfade finishes in 163ms of a 400ms transition.** That is not a
separate duration — it is the spring on `opacity`: the bezier first reaches
y=1 at ≈40% of the duration (0.40 × 400 = 160ms), then overshoots past 1 and
the browser clamps. So opacity is visually done at Δ163 and pinned for the
remaining 237ms while the strip is still travelling.

**Direction.** Advancing sends the leaver to **−step** (up, out the top) and
brings the arriver from **+step**. Reversing is the exact arithmetic inverse,
measured: A goes −25.60 → 0 overshooting to **+2.46**, B goes 0 → +25.60
overshooting to **+28.06**.

**Sequence:** `0` roll + crossfade start → `163` crossfade done → `150` squash
starts (overlapping the roll by 250ms) → `413` roll lands → `750` squash ends.
Total visible motion **750ms**.

### 2.4 Divergence table — icon swap

| # | aspect | measured web | shipped port | verdict |
|---|---|---|---|---|
| S1 | travel distance | 160% of the **cell** — 25.6px / 32px | `cell × DsTransforms.swapRollTravel (1.6)`; call sites pass the same 16/20 | **match** |
| S2 | travel duration / curve | 400ms `--ease-spring`, +9.77% overshoot past centre | `_roll` 400ms `DsCurves.spring`, transform left unclamped | **match** |
| S3 | opacity leg | same 400ms spring clock, **clamped** by the browser → visually done at 163ms | same clock, `clampDouble(…, 0, 1)` | **match** |
| S4 | direction sign | advance = up; reverse = exact inverse | `offset = i − strip(t)`, no special-casing | **match** |
| S5 | squash delay | **150ms** after the flip, then 600ms | `_squashStart = 150/750`, one 750ms clock | **match** |
| S6 | strip membership | all glyphs present simultaneously, inactive at ±step, opacity 0 | one `Stack` with every icon built | **match** |
| S7 | first build | **measured from before hydration:** the roll transform never leaves `matrix(1,0,0,1,0,0)` — no roll on mount — while the active glyph's `yuki-jelly` (delay 0.15s, `both`) runs its **full 600ms once**, holding scale 1 through the delay then 1.18 → 0.88 → 1.06 → 0.98 → 1 | `_roll.value = upperBound` in `initState`; `_squash.forward(from:0)` once on first `didChangeDependencies` | **match** |
| S8 | interruption | **measured** (reversal 264ms into a 400ms roll, i.e. mid-overshoot): re-targets from the **current computed transform** — −28.10, not the −25.60 target — and runs the **full 400ms**, with the spring recomputed on the new 28.10 delta (peak +2.74 = **9.75%**). Opacity re-targets with it. | `_from = _strip(_rollT)`, `_fromOpacity = _currentOpacities()`, `_roll.forward(from: 0)`, full 400ms | **match** |

**The icon swap is the healthiest of the three.** Every measured leg matches,
including the two that were previously only inferred (S7 first paint, S8
interruption) and are now traced.

The demo wiring was checked too, since an inverted index would flip the roll
direction and read as "wrong" without any timing being wrong. All four demos
map identically:

| demo | reference `icons` order → active index | port `icons` order → `activeIndex` |
|---|---|---|
| ViewSwitch | `{grid, list}`, list ⇒ 1 | `[layoutGrid, rows3]`, `_list ? 1 : 0` |
| PlayPause | `{play, pause}`, playing ⇒ 1 | `[play, pause]`, `_playing ? 1 : 0` |
| Favourite | `{off, on}`, on ⇒ 1 | `[heart subtle, heart filled]`, `_on ? 1 : 0` |
| Mute | `{on, muted}`, muted ⇒ 1 | `[volume2, volumeX]`, `_muted ? 1 : 0` |

So if the swap *feels* wrong in the port, the cause is not in `icon_swap.dart`
and not in its call sites. Look at the button it sits inside (§3), whose press
behaviour is measurably wrong in a way that colours every interaction with the
control — including this one.

---

## 3 · Buttons — the headline defect

Source: `components/ui/button.tsx`, `@utility btn-spring`
(`app/globals.css` L1886–1898), `@utility sheen-action` (L2089–2160),
`@keyframes action-beat` (L2059–2088).

### 3.1 The transition list, measured

```
transition-property: transform, background-color, border-color, color, box-shadow, opacity
transition-duration: 0.25s ×6        (→ 0.08s ×6 while :active)
transition-timing-function: cubic-bezier(0.34, 1.56, 0.64, 1) ×6
```

Tailwind v4 compiles `scale-95` to the **standalone `scale` property**, not to
`transform: scale()`. `scale` is **not in that list**. `transform` is — and
`transform` stays `none` for the entire press.

### 3.2 Keypoint table — press and release (`Open Pack`, primary)

`pointerdown` at t=184.7, `pointerup` at t=453.9. Rows collapse where nothing
changed; every intermediate frame was sampled and is identical to its neighbour.

| t | `:active` | `scale` | width | height | `transition-duration` | shadow |
|---|---|---|---|---|---|---|
| 10 … 174.7 | no | `none` | 101.375 | 40 | `0.25s ×6` | `btn-primary` (8 layers) |
| **194.2** | **yes** | **`0.95`** | **96.306** | **38** | `0.08s` | **`btn-down`** (6 layers) |
| 210.8 … 224.9 | yes | `0.95` | 96.306 | 38 | `0.08s` | `btn-down` |
| **464.4** | no | **`none`** | **101.375** | **40** | `0.25s ×6` | **`btn-primary`** |
| 475 … 709.5 | no | `none` | 101.375 | 40 | `0.25s ×6` | `btn-primary` |

**The press squish is an instant, un-eased, un-sprung snap in both directions.**
9.5ms after `pointerdown` (the very next frame) the button is already fully at
0.95 with no intermediate value; 10.5ms after `pointerup` it is fully back at
1.0 with **no overshoot**. There is no 80ms down-stroke and no 250ms spring
return on the scale. The only thing `--duration-tick` actually shortens is the
*colour* legs, and only while the button is held.

**`box-shadow` also snaps — but only for this pair.** It is in the transition
list, and the mechanism is worth stating exactly, because the same property
behaves both ways on the same element:

- `--shadow-btn-primary` is **8 layers**, `inset` at index 5.
  `--shadow-btn-down` is **6 layers**, non-inset at index 5. Mismatched layer
  counts *and* mismatched `inset` flags are not interpolable, so no transition
  runs and the value changes immediately — measured in the same single frame as
  the scale, far earlier than a discrete-at-50% flip of an 80ms (40ms) or 250ms
  (125ms) transition would land.
- Premium hover is the same story: `--shadow-btn-value` (8 layers, insets) →
  `--shadow-glow-value` (6 layers, no insets) flips **1.2ms** after
  `pointerover`, and back on hover-out. **Snap.**
- **The focus ring is the opposite** — see §3.4. The shadow tokens carry **four
  leading fully-transparent placeholder layers** precisely so a ring or glow can
  be dropped into one of those slots with the layer count and inset flags
  unchanged. When that holds, `box-shadow` interpolates normally.

So "shadows snap" is not a rule about this design system. It is a property of
each specific token pair, and it has to be decided per transition.

The port's own specs mirror the same structure, which is why its hard cut is
structurally right rather than lucky — `DsShadows.btnPrimary` is 4 layers
(2 inset, 2 not) and `DsShadows.btnDown` is 2 layers (1 inset, 1 not), the same
count-and-inset mismatch the browser refuses to interpolate. (The browser's
computed value reads 8 and 6 because Tailwind pads every shadow with four
transparent placeholder slots; the *real* layers correspond one-to-one.) A
well-meaning "add a tween here" change would therefore produce motion the
reference never shows.

### 3.3 What *does* transition on a button

| variant | property | measured |
|---|---|---|
| `secondary` hover | `background-color` | `rgb(39,39,42)` → **peak `rgb(65,65,73)`** at Δ148 → settles `rgb(63,63,70)` at Δ251. **250ms spring, with visible colour overshoot.** |
| `ghost` hover | `background-color` | transparent → **peak `rgb(43,43,46)`** at Δ150 → `rgb(39,39,42)` at Δ251 |
| `ghost` hover | `color` | `rgb(212,212,216)` → **peak `rgb(254,254,253)`** → `rgb(250,250,250)` |
| `outline` hover | `background-color` | `rgb(24,24,27)` → `rgb(39,39,42)`, same 250ms spring |
| all | while `:active` | the same colour legs run at **80ms** instead of 250ms |

So the button's real feel is: **colours spring and overshoot; geometry and
shadow hard-cut.** The port has this precisely inverted.

### 3.4 Focus ring — **this one animates**

Measured by Shift-Tabbing onto the primary button (`focusin` at t=240.4). The
ring is a `box-shadow` layer (the computed `outline` is `none`), dropped into
placeholder slot index 3, so the list stays 8 layers with identical inset flags
and **interpolates**:

| Δ (ms) | ring spread | ring alpha | border-color |
|---|---|---|---|
| 0 | 0px | 0 | `rgba(0,0,0,0)` |
| 7 | 0.846 | 0.141 | `rgba(146,194,252,0.282)` |
| 17 | 1.551 | 0.258 | `rgba(146,194,252,0.518)` |
| 34 | 2.109 | 0.352 | `rgba(146,194,252,0.700)` |
| 68 | 2.888 | 0.481 | `rgba(146,194,252,0.965)` |
| 102 | 3.224 | 0.537 | `rgb(157,208,255)` |
| **134** | **3.290** ← peak | **0.548** | **`rgb(160,213,255)`** ← peak |
| 168 | 3.196 | 0.533 | `rgb(156,207,255)` |
| 215 | 3.018 | 0.503 | `rgb(147,195,253)` |
| **241** | **3.000** ← settled | **0.500** | **`rgb(146,194,252)`** |

Spread overshoots 3px to **3.29px** (+9.66%) at 54% of the duration and settles
at 241ms — the `--ease-spring` signature again, on both the spread and the
border colour. The ring does not just appear; it **springs open and settles
back**.

### 3.5 Disabled / loading opacity — also animates

Adding `disabled` live: opacity 1 → **undershoots to 0.3969** at Δ~180 → settles
**0.45** at Δ~280. Overshoot (0.45 − 0.3969) / (1 − 0.45) = **+9.65%** — the
spring, on `opacity`, exactly as `btn-spring` declares.

### 3.6 Sheen (`sheen-action::before`) — one animation, never restarted

| event | measured |
|---|---|
| rest | `animation-name: none`; base style `scale(0.55)`, `opacity 0` |
| hover-in | `action-beat 2.6s ease-out infinite` appears **1.3ms** after `pointerover`, **starting at frame 0** (`scale 0.55`, `opacity 0`) |
| press | rule swaps to `action-beat 620ms ease-out 1`. **Same `animation-name` ⇒ the animation is not recreated.** Its elapsed time is preserved and re-divided by the new duration. |
| release | back to `2.6s infinite`, **still the same animation**, elapsed still preserved |
| hover-out | `animation-name: none` within **1.4ms**; ::before snaps to base style mid-thump |

The press behaviour verified to four significant figures: pressed **137.4ms**
into the hover cycle ⇒ 137.4 / 620 = **22.2%** of the new timeline ⇒ the 24%
keyframe ⇒ predicted `scale 1.32 / opacity ~0`; **measured `scale 1.3197,
opacity 0.000623`** in the frame after `pointerdown`, jumping from `scale 0.958
/ opacity 0.5625`. Release at 865ms elapsed ⇒ 865 / 2600 = 33.3% ⇒ predicted
`scale ≈0.985`; **measured 0.985494**.

Two consequences that matter more than the arithmetic:

1. **Pressing does not reliably produce a thump.** If the pointer has been
   hovering longer than 620ms — the normal case — the re-divided clock is
   already past the animation's active duration, so the beat is *finished* and
   the ::before sits at its invisible base style for the whole press. Measured
   directly: a press 2.5s into a hover cycle showed `opacity 0.000, scale 0.550`
   held for the entire 278ms hold. The "single hard thump" only plays when the
   press lands inside the first 620ms of a hover.
2. **Hover-in always restarts from frame 0**, because hover-out deletes the
   animation outright.

### 3.7 Foil (`foil-value`, premium)

Both layers run **always**, at rest, unhovered.

**`::after` — the drift.** `value-foil-drift 11s linear infinite`, `opacity
0.95`. Layer-1 `background-position` measured travelling 74.03% → 116.67% over
3349ms = **0.012731 %/ms**, perfectly even (linear confirmed). Extrapolated over
the full 11s that is **140% of travel**, which is exactly the port's
`0 → 1.40`. Hover does **not** change it — still `11s` throughout.

**`::before` — the glint.** `value-glint 5.5s cubic-bezier(0.65,0,0.35,1)
infinite`, `background-size 260% 100%`. Measured shape: it **idles pinned at
`135% 50%` with `opacity 0`** for the first 54% of the cycle, then one bright
band sweeps **right to left, 135% → −55%**, with opacity ramping 0→1 over the
first ~6% of the sweep. Measured sweep (hover cycle, 2.4s):

| Δ into sweep | opacity | background-position |
|---|---|---|
| 0 | 0.0007 | 134.998% |
| 67 | 0.4788 | 134.331% |
| 132 | 0.9983 | 132.276% |
| 265 | 1.0000 | 122.147% |
| 399 | 1.0000 | 98.137% |
| 533 | 1.0000 | 47.094% |
| 665 | 1.0000 | −9.797% |

**Hover retiming — and it visibly jumps.** `pointerover` at t=1214.8 switches
`animation-duration` 5.5s → 2.4s. The animation is *not* restarted: the browser
keeps its elapsed `currentTime` and re-divides it by the new duration. Measured
consequence in the very next frame:

| t | hover | duration | opacity | background-position |
|---|---|---|---|---|
| 1194.7 | no | 5.5s | 0.0000 | `135% 50%` (idling) |
| **1215.5** | **yes** | **2.4s** | **1.0000** | **−49.86% 50%** |
| 1247.1 | yes | 2.4s | 1.0000 | −51.71% |
| 1426.9 | yes | 2.4s | 0.0000 | `135% 50%` (next idle band) |

The glint **teleports** from "idle, invisible, parked at the right" to "fully
bright, almost off the left edge", finishes that sweep in ~210ms, then idles
1268ms (= 54% of 2400ms ✓) before the next sweep. That pop is real reference
behaviour, not an artifact.

The port's `_loop` sets `c.duration = period; c.repeat();`, and
`AnimationController.repeat()` resumes from the controller's current **phase**
(its normalised `value`). Preserving phase is *not* the same as preserving
elapsed time: the port continues smoothly where the browser jumps.

### 3.8 Divergence table — buttons

| # | aspect | measured web | shipped port | verdict |
|---|---|---|---|---|
| **B1** | **press scale** | **instant snap 1 → 0.95, and instant 0.95 → 1 on release. No transition, no curve, no overshoot.** `scale` is not in `transition-property`. | `DsPress(scale: 0.95, downDuration: 80ms, upDuration: 250ms)` with `DsCurves.spring` + flipped reverse — an 80ms eased squish and a 250ms spring return that **overshoots to ≈1.005** | **DIVERGE — the primary defect.** The port animates what the web cuts. |
| **B2** | **shadow on press** | `btn-primary → btn-down` **snaps** (non-interpolable layer lists) | hard cut | **match** — accidentally right, and it must stay right |
| **B3** | **shadow on premium hover** | `btn-value → glow-value` **snaps** (1.2ms) | hard cut | **match** |
| **B4** | hover colours | 250ms `--ease-spring` **with overshoot past the target colour** | `_SpringColors`, 250ms `DsCurves.spring` | **match** |
| **B5** | colour legs while held | shorten to **80ms** | `_pressed ? tick(80ms) : base(250ms)` | **match** |
| **B6** | short taps | scale is instant, so **any** tap — 10ms or 500ms — shows the **full** 0.95 for exactly as long as the button is held | port depth depends on hold length: 10ms → 0.9756, 20ms → 0.9592, 30ms → 0.9497. On top of that, `CurvedAnimation._curveDirection` latches to `forward` and only clears at an endpoint, so a release before the 80ms down-stroke completes replays the **forward** curve backwards; and `reverse()` scales its run by the remaining fraction, so the return is also short | **DIVERGE (compound)** — wrong depth, wrong curve *and* wrong duration on every quick tap |
| **B7** | sheen on hover-in | fresh animation from **frame 0** every time | `_beat.repeat()` resumes from the controller's current value | **DIVERGE** |
| **B8** | sheen on press | elapsed clock **preserved and re-scaled**; usually already finished ⇒ **no thump** | `_beat.forward(from: 0)` — always a fresh 620ms thump | **DIVERGE (documented in-code, but the port is the more energetic of the two)** |
| **B9** | sheen on hover-out | animation deleted, snaps to invisible base style within 1.4ms | `_beat.stop()`, painter fed `beat: 0` | **match** |
| **B10** | foil at rest | both loops run always; drift `11s linear`, 140% travel, unaffected by hover; glint idles 54% then sweeps 135% → −55% | both loops run always; drift `11s` plain lerp `0 → 1.40`; glint `ConstantTween(1.35)` w54 then `1.35 → −0.55` | **match** |
| **B10b** | foil glint on hover | duration 5.5s → 2.4s **keeping elapsed time**, which re-divides the clock and makes the glint **jump phase** — measured teleporting from idle/invisible to full-brightness at −49.9% in one frame | `repeat()` resumes from the controller's current **phase**, so it continues smoothly with no jump | **DIVERGE (documented in-code)** |
| **B11** | disabled / loading opacity | **measured:** 1 → 0.45 over 250ms spring, undershooting to **0.3969** (+9.65%) | plain `Opacity(0.45)`, instant | **DIVERGE** |
| **B12** | **focus ring** | **measured:** `box-shadow` spread **0 → 3.29px (peak, +9.66%) → 3px** over 250ms spring, border colour springing with it. It interpolates because the ring lands in a transparent placeholder slot and the layer count / inset flags are unchanged. | ring spec handed straight to `_surface` — **hard cut** | **DIVERGE** |
| B13 | loading spinner entry | button width jumps when the spinner is inserted; `width` is not in the transition list ⇒ instant in both | instant (+24px on `md`) | **match** |

---

### 3.9 Control group — the `press` utility **does** animate, and the port nails it

This is the measurement that scopes the P0 fix. `@utility press`
(`app/globals.css` L2277–2284) declares `transition: transform …` and animates
`transform`, which **is** in its own transition list. Measured on a `.press` nav
row (identical on two different pages):

```
transition-property: transform    duration: 0.25s → 0.04s while :active
transition-timing-function: cubic-bezier(0.34, 1.56, 0.64, 1)
```

| Δ from pointerdown | transform scale |
|---|---|
| 12.6 | 1.0000 |
| 28.7 | 0.9373 ← overshoots past 0.94 |
| 44.4 | 0.9381 |
| 62.3 | 0.9400 ← settled (40ms down-stroke) |

| Δ from pointerup | transform scale |
|---|---|
| 34.6 | 0.9400 |
| 55.1 | 0.9569 |
| 100.8 | 0.9909 |
| 132.5 | 1.00183 |
| 166.0 | 1.00570 |
| **180.9** | **1.00580** ← peak |
| 216.3 | 1.00392 |
| 264.5 | 1.00036 |
| 283.6 | 1.00000 ← settled |

Release overshoot **+0.0058 on a 0.06 delta = +9.67%** — the spring signature,
on the release leg, exactly as `DsPress` computes it (0.94 + 0.06 × 1.0967 =
1.0058). **`DsPress` is correct and must be kept.** The defect is not the
utility; it is that `DsButton` routes its `scale-95` through it, when
`scale-95` is a different property that the button does not transition at all.

---

## 4 · Standalone `Toggle`

| property | measured |
|---|---|
| `transition` | `all 0.25s cubic-bezier(0.22, 1, 0.36, 1)` — **`--ease-out`, not the spring** |
| `scale` / `transform` | `none` in every state, including `:active` — **no press squish at all** |
| hover | `background-color` transparent → `rgb(39,39,42)` **monotonically** over 250ms, no overshoot |

| # | aspect | web | port | verdict |
|---|---|---|---|---|
| G1 | colour curve | 250ms `ease-out`, no overshoot | `_TransitionAllColors` 250ms `DsCurves.out` | **match** |
| G2 | press scale | none | none (no `DsPress` on `DsToggle`) | **match** |
| G3 | arrival squash | `animation-name: none` in every state — a standalone `Toggle` never squashes | no `DsJelly` / `DsJellyReplay` anywhere in `toggle.dart` | **match** |

---

## 5 · Selection controls, inputs, shell pill, kbd — **not yet folded in**

A second measurement pass covering checkbox / radio / switch / slider, input and
textarea focus, the shell's theme-toggle sliding pill, and `kbd` /
`button-group` was run against the same live reference and left **17 probe
scripts and 4 captured traces** in the scratchpad, but its numbers did not land
in time for this revision. Nothing from it is summarised here, because an
inferred table is exactly the failure mode this audit exists to correct.

Artifacts, ready to re-run or read:

| file | covers |
|---|---|
| `…\scratchpad\ba2-lib.js` | that pass's own harness |
| `…\scratchpad\ba2-selection.js` → `out-selection.json` | checkbox, radio, switch, slider |
| `…\scratchpad\ba2-tristate.js` | checkbox checked → indeterminate |
| `…\scratchpad\ba2-jelly.js`, `ba2-anims.js`, `ba2-seek.js` | keyframe seeking / named animations |
| `…\scratchpad\ba2-inputs.js` → `out-inputs.json` | input, textarea, input-group focus |
| `…\scratchpad\ba2-shell.js`, `ba2-pill.js` → `out-shell.json` | shell nav + theme-toggle pill |
| `…\scratchpad\ba2-kbd.js` → `out-kbd.json` | kbd, button-group |
| `…\scratchpad\ba2-shadow.js`, `ba2-disc.js`, `ba2-rules.js`, `ba2-rules2.js`, `ba2-suppress.js` | shadow interpolability, discrete transitions, matched rules |

**Two findings from §1–§4 should be carried into that pass when it is
completed**, because both overturned a conclusion here and both generalise:

1. Tailwind v4 emits `scale` / `translate` / `rotate` as **standalone
   properties**, which are frequently absent from the element's
   `transition-property` list. Read `getComputedStyle(el).scale`, never just
   `.transform`, and always print the transition list. This is what made the
   button's press look un-animated in an early trace and then turn out to be
   un-animated *for real* — §3.2.
2. A `box-shadow` transition only interpolates when both token values have the
   same layer count and the same per-layer `inset` flags. The selection
   controls' socket swap (`pressed ↔ btnPrimary`) and the input's focus ring are
   both prime candidates for the same snap-vs-spring split found in §3.2/§3.4 —
   and the port currently hard-cuts *both*, which will be right for one and
   wrong for the other.

---

## 6 · Prioritised fix list

Ordered by how much of the user's "does not behave like the web" this buys.

### P0 — the press feel is inverted (B1, B6)

`DsButton` must **not** animate its scale. The web snaps to 0.95 on pointer-down
and snaps back on pointer-up, with no easing in either direction. The port ships
an 80ms eased squish plus a 250ms springy return that overshoots to ~1.005 —
a bounce the reference does not have, on every single button press in the system.

This is the single most-felt divergence: it is on every button, it fires on
every interaction, and the port's version is *longer and bouncier* than the
reference, which is exactly what "looks right, feels wrong" describes.

**Fix, precisely scoped.** Stop `DsButton` from routing its squish through
`DsPress`; drive the scale directly off the pressed flag with no interpolation
(a plain `Transform.scale`, no controller). Keep the **colour** legs on their
existing 80ms-down / 250ms-up spring — those are measured correct (B4, B5).

**Do not touch `DsPress` itself.** §3.9 measures a `.press` surface on the live
reference and it matches the port's implementation to four decimal places,
release overshoot included. `press` animates `transform`, which *is* in its
transition list; `Button`'s `scale-95` is a different property that is *not*.
One utility, two properties, opposite behaviour — that is the whole bug.

Separately, B6's `CurvedAnimation` reverse-curve latch (a release before
`forward()` completes replays the forward curve backwards, and the run is
shortened by the remaining fraction) is a real defect in `DsPress` that survives
the button fix. It is worth fixing on its own merits for every remaining
`DsPress` surface, but it is not what makes buttons feel wrong.

### P1 — toggle-group mount and deselect (T6, T7, T8, T8b)

Three separable, small fixes to `sliding_pill.dart`:

- **T6** gate `AnimatedOpacity` behind the same `_placed` flag that gates the
  travel, so the first placement pops in rather than fading over 150ms.
- **T7** play the arrival squash once on first placement. The reference's
  `ResizeObserver` initial callback makes the load-time squash real; the port
  suppresses it. Measured onset ~117ms after placement, then the standard 600ms.
- **T8 / T8b** on deselect, hold the pill's rect and fade only — the reference
  writes `opacity: 0` and nothing else. The port collapses
  `left/top/width/height` to `0/0/0/0`, sliding the pill to the group origin
  under the fade, **and** replays the 600ms squash on a pill that is
  disappearing. Both are wrong; both are suppressed by treating `activeIndex < 0`
  as "fade only, keep the last rect, no replay".

### P2 — sheen and foil phase semantics (B7, B8, B10b)

`_beat.repeat()` on hover-in must restart from 0, not resume. That one is a
plain bug (one-line: `repeat()` from `lowerBound`).

B8 and B10b are the same underlying issue and are a design call, not a bug.
CSS keeps an animation's **elapsed time** across a duration change and
re-divides it; a Flutter `AnimationController` keeps its **phase**. That single
difference produces both the sheen's usually-invisible press thump and the
foil glint's visible teleport on hover.

Modelling the browser is mechanical: hold one wall-clock start time per effect,
and on every duration change recompute `progress = (now − start) mod duration /
duration` rather than calling `repeat()`. Whether the reference's behaviour is
*desirable* here is a separate question — the port's version is calmer and
arguably better — but 1:1 is the stated bar, and right now the difference is
undocumented in one direction (B10b) and documented in the other (B8). Pick one
and record it either way.

### P2.5 — the focus ring springs open (B12)

`DsButton`'s focus ring is a hard cut; the reference animates its **spread**
from 0 to 3px over 250ms on `--ease-spring`, overshooting to 3.29px, with the
border colour springing alongside. This is a per-frame geometry animation, not
a colour fade, so the existing colour-tween plumbing will not produce it — the
ring's spread has to be driven.

Note the general rule this exposes, because it governs any future shadow work:
a `box-shadow` transition in this system interpolates **iff** the two token
values have the same layer count and the same `inset` flags per layer. The
tokens carry four leading transparent placeholder layers to make ring and glow
swaps satisfy that. `btn-primary ↔ btn-down` and `btn-value ↔ glow-value` do
not satisfy it and therefore snap (B2, B3). Decide per pair; do not generalise
either way.

### P3 — minor, cheap

- **B11** transition the disabled/loading opacity over 250ms spring; measured
  1 → 0.3969 → 0.45.

### Verification recipe

Each fix has a cheap, non-visual test that fails today. Widget tests can pump
the port's clock the same way the rAF sampler samples the browser's.

| item | assertion that must hold after the fix |
|---|---|
| **B1** | pump 1 frame after pointer-down → scale is exactly 0.95, not an intermediate. Pump 1 frame after pointer-up → exactly 1.0. No frame anywhere in the press shows a value strictly between 0.95 and 1.0, and none shows > 1.0. |
| **B6** | hold for 10ms, 20ms, 30ms → scale is 0.95 in all three, and returns to exactly 1.0 one frame after release in all three. |
| **T6** | first frame after the group's first layout → pill opacity is already 1, not a value in (0, 1). |
| **T7** | after first placement, the jelly controller is running; at +180ms scaleX ≈ 1.18. |
| **T8** | set `activeIndex` to −1 → pill `left`/`width` never change from their last values on any frame; only opacity moves, reaching 0 by +150ms. |
| **T8b** | same transition → jelly scaleX stays 1.0 on every frame. |
| **B12** | on focus, the ring's spread is sampled per frame: 0 → peak ≈3.29 at ≈135ms → 3.0 at ≈250ms. Today it is 3.0 on frame 1. |
| **B7** | hover, un-hover mid-beat, re-hover → the beat's first frame after the second hover is frame 0 (scale 0.55, opacity 0), not wherever it stopped. |
| **B11** | toggle `enabled` → opacity is sampled per frame, undershooting to ≈0.397 before settling at 0.45. |

**Tests that encode the current behaviour** and must be revisited with the fix,
not merely kept green:

- `test/components_test.dart:280` — *"squishes to 0.95 — the button scale, not
  press's 0.94"*. It pumps `DsDurations.tick` (80ms) before asserting 0.95, so
  it will still pass after B1 — but its structure and comment assert an 80ms
  eased down-stroke that the reference does not have. Rewrite it to pump a
  **single frame** and assert 0.95 exactly, which is both stricter and true.
- `test/components_test.dart:882` — asserts a `DsToggle` has **no** `DsPress`.
  Correct (G2), measured; keep it.
- `test/components_test.dart:~1366` (`scalesUnderSwap`) — asserts the icon
  swap's squash fires. Correct (S5, S7); keep it.

Regression guards for the protected list are equally cheap and worth adding at
the same time — particularly **B2 / B3** (assert the shadow spec changes in a
single frame, so a well-meaning later change cannot introduce a tween) and
**S1–S8**, which currently have no behavioural test at all despite being the
one module measured fully correct.

### Explicitly protect — do not "fix" these

`DsJelly`'s per-segment easing (T4), the pill's fused position/size timing
(T1, T2), the label colour curve (T5), the resize-replay trigger (T9 — the
reference's `ResizeObserver` path replays the squash too, so this is correct as
shipped), the entire icon-swap module (S1–S8), the
hard-cut shadows on button press and premium hover (B2, B3), the 80ms
held-colour legs (B5), the spring-with-overshoot hover colours (B4), the instant
spinner-entry width jump (B13), and `DsToggle`'s ease-out colours with no press
scale (G1, G2). All measured, all correct. The hard-cut shadows especially look
like bugs and are not: CSS genuinely refuses to interpolate those two token
pairs. Note that this does **not** extend to the focus ring, which does
interpolate — see P2.5.
