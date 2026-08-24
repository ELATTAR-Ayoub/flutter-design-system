# Map — `/design-system/motion` (Foundations · Motion)

**Files that produce the render** (all under `D:\DESIGN\Design-System-2026-8\design-system\`):
- `app\design-system\motion\page.tsx` — the page. **`"use client"`** — the only foundation page with local state (`const [run, setRun] = useState(0)`). Module-level data: two arrays (`durations` ×6, `easings` ×4) and one local component (`CurveGraph`).
- `components\el\kit.tsx` — `ElPageHeader`, `ElSection`, `Panel`, `Meta`, `Code`, `Note`, `DoDont`, `PageFootNav` (all eight used).
- `components\ui\button.tsx` — `Button variant="outline" size="sm"` ×3 (the three replay buttons).
- `components\ui\icon.tsx` — `Icon` with lucide `RotateCcw` (×3) and `Sparkles` (×1), plus `Check`/`X`/`ArrowLeft`/`ArrowRight` inside kit.
- `lib\el\nav.ts` — `findCategory("foundations","motion")` supplies header copy; `siblings()` supplies foot nav.
- `app\design-system\layout.tsx` — shell (identical to the other foundation pages; see `shared-map.md` §1).
- `app\globals.css` — **every keyframe, utility, duration and easing token below**. Line numbers cited throughout.

**This map assumes you also hold `shared-map.md`.** Kit anatomy (Panel/Note/Meta/DoDont/PageFootNav/ElSection/ElPageHeader), the shell, the type scale and the shadow ladder are documented there and are not repeated except where this page uses them in a way the other pages do not.

---

## 0 · Measured frame (1440 viewport, the project's parity frame)

Shell → sidebar 240px + main `flex-1` 1200px − `lg:px-12` 48×2 = 1104 → inner `max-w-(--width-content)` **1080px** centred. Every width below is derived from that 1080.

Panels are `border` (1px) + body `p-6` (24px), `box-sizing: border-box` → **body content width = panel width − 50**.

| Container | class | outer px | body px |
|---|---|---|---|
| `#durations` panel | (full width) | 1080 | **1030** |
| `#easing` panels | `grid gap-4 sm:grid-cols-2` | (1080−16)/2 = **532** | **482** |
| `#interaction` press panels | `grid gap-4 sm:grid-cols-3` | (1080−32)/3 = **349.333** | **299.333** |
| `#interaction` `.lift` panel | (full width, `mt-4`) | 1080 | 1030 |
| `#named` panels | `grid gap-4 sm:grid-cols-2 lg:grid-cols-3` → 3-up at 1440 | **349.333** | **299.333** |
| `#reduced` panel | (full width) | 1080 | 1030 |
| `#rules` DoDont cells | `grid gap-4 sm:grid-cols-2` | **532** | — (`p-5`, no panel) |

Duration bar track: row grid `sm:grid-cols-[13rem_4rem_1fr]` + `gap-4` inside 1030 → 208 | 64 | **726** with two 16px gaps. Track is 726 × 32px (`h-8`).

Section rhythm: `ElSection` = `mb-20` (80px), heading block `mb-6`, `<h2 class="type-h3">`, description `type-small mt-2 max-w-2xl` (672px cap).

---

## 1 · Page header (`ElPageHeader`)

From `lib\el\nav.ts` foundations→motion (nav.ts:99–112), verbatim:
1. Eyebrow `type-label text-action-ink` → **"Foundations"**
2. `<h1 class="type-h1 mt-4 text-foreground">` → **"Motion"**
3. Blurb `type-lead mt-4 max-w-2xl` → **"Durations, easing curves and the named animations — each one running live so timing can be judged, not guessed."** (real em dash U+2014)
4. Chips `ul.mt-7 flex flex-wrap gap-2`, six, in order: **Durations · Easing · Interaction utilities · Named animations · Reveal choreography · Reduced motion**

⚠ **Chip/section drift** — three chips do not name their section, and one section has no chip:

| chip | actual section title / id |
|---|---|
| Durations | "Durations" `#durations` |
| Easing | "Easing" `#easing` |
| **Interaction utilities** | **"The click feel"** `#interaction` |
| Named animations | "Named animations" `#named` |
| **Reveal choreography** | **"Pack-opening choreography"** `#choreography` |
| Reduced motion | "Reduced motion" `#reduced` |
| *(none)* | **"Rules"** `#rules` |

Chips are labels, not links — render all six verbatim, keep all seven sections.

---

## 2 · The standing Note (between header and first section)

`<Note tone="action" title="Everything on this page is live" className="mb-12">` — `rounded-lg (12px) border p-5 (20px)`, `border-action/30 bg-action/[0.08] text-action-ink`, 48px below.

Title `<p class="type-label mb-2">`; body `<div class="type-small text-muted-foreground">`.

Body verbatim: **"Timings are judged, not read. Hover the interaction demos and use the replay buttons to re-run the entrances. If your system is set to reduce motion, every animation here collapses to near-zero — which is the correct behaviour, not a bug."**

⚠ **Note-title colour correction (applies to both Notes on this page, and corrects `spacing-map.md` §2 / `shared-map.md` §2).** The `Note` title `<p>` carries only `type-label mb-2` — no colour utility. `.type-label` **itself declares `color: var(--muted-foreground)`** (globals.css:1182, inside `@layer components`, with a 12-line comment at 1171–1181 explaining why). A `color` declared *on* the element always beats colour *inherited* from the container's `text-action-ink`. **Note titles render `--muted-foreground`, not tone ink.** `DoDont` headings *do* render tone ink because they write `text-value-ink` / `text-destructive-ink` explicitly on the `<p>` (a `@layer utilities` rule, which also outranks `@layer components`). That asymmetry is real; port it.

---

## 3 · Section `#durations` — "Durations"

Description verbatim: **"Six steps. Standard interface motion sits between 150 and 250ms, overlays get up to 350ms, and only reward moments are allowed past 400ms."**

`<Panel label="Same distance, six speeds" note={`run ${run}`}>` — the panel's right-hand note is **live**: `type-num-sm text-muted-foreground` printing `run 0`, `run 1`, … It is the visible read-out of the replay counter.

Body, in order:
1. `<div class="mb-5 flex justify-end">` → `Button variant="outline" size="sm" onClick={replay}` containing `<Icon icon={RotateCcw} size="sm" tone="inherit"/>` + text **"Replay"**.
2. `<div class="space-y-4">` → six rows, each `grid items-center gap-4 sm:grid-cols-[13rem_4rem_1fr]`:
   - col 1 `type-num-sm text-action-ink` → the token literal
   - col 2 `type-num-sm text-muted-foreground` → `{ms}ms`
   - col 3 the track: `h-8 overflow-hidden rounded-sm bg-muted` (32px tall, 6px radius, `--muted`), containing the bar `h-full rounded-sm bg-action` with **inline** `animation: el-sweep {ms}ms var(--ease-out) both` and `key={`${token}-${run}`}`.
3. `<div class="mt-6 space-y-2 border-t border-border pt-5">` → six `<p class="type-small">` each = `<span class="type-num-sm text-muted-foreground">{ms}ms</span>` + `" — "` + use copy.

The source carries an `allow-dynamic-motion:` comment justifying the inline per-row duration ("this page IS the duration scale"). Port it as data-driven, not as six hardcoded widgets.

| # | token | ms | use copy (verbatim) |
|---|---|---|---|
| 1 | `--duration-tick` | 80 | The machine beat. A press registers in this long, and nothing else uses it. |
| 2 | `--duration-fast` | 150 | Button press and release, checkbox tick, chip select. |
| 3 | `--duration-base` | 250 | The default. Spring release, card hover lift, tab underline, focus fade. |
| 4 | `--duration-slow` | 400 | Content entering: rows springing up, feed items arriving. |
| 5 | `--duration-overlay` | 320 | Dialogs, drawers, sheets, popovers opening and closing. |
| 6 | `--duration-reward` | 550 | Card reveal, rare pull, XP fill, reward unlock. The only long one. |

Rows render in **array order**, which is *not* ascending: 80, 150, 250, 400, **320**, 550. `--duration-slow` (400) sits above `--duration-overlay` (320). Keep the order.

**`el-sweep`** (globals.css:2195–2202) — animates `width`, nothing else:

| stop | width |
|---|---|
| `from` | `0` |
| `to` | `100%` |

Fill `both`, curve `--ease-out` `cubic-bezier(0.22,1,0.36,1)`. On the 726px track the bar grows 0 → 726px. Flutter: animate a `SizedBox`/`FractionallySizedBox` factor 0→1 over `ElCurves.out`; the parent clips (`overflow-hidden`), so a plain `ClipRRect(BorderRadius.circular(ElRadii.sm))` is enough. The *bar* also carries `rounded-sm`, so at small widths it is a 6px-radius pill, not a square sliver.

---

## 4 · Section `#easing` — "Easing"

Description verbatim: **"Four curves, each with a job. The rule of thumb: things you operate use ease-standard, things that arrive use ease-out, and only rewards may overshoot."**

Four `Panel`s in `grid gap-4 sm:grid-cols-2`, `label={e.token}` (so the header strip prints the token in `type-label text-muted-foreground`), no `note`. Body order: `CurveGraph` → travel track → `<p class="type-num-sm mt-4 text-muted-foreground">{curve}</p>` → `<p class="type-small mt-2">{use}</p>`. Then, outside the grid, `<div class="mt-4 flex justify-end">` with `Button variant="outline" size="sm"` + RotateCcw + **"Replay curves"**.

| token | curve string (printed verbatim) | pts | use copy (verbatim) |
|---|---|---|---|
| `--ease-spring` | `cubic-bezier(0.34, 1.56, 0.64, 1)` | 0.34, 1.56, 0.64, 1 | THE curve. Overshoots then settles. Every press release, every jelly entrance. |
| `--ease-out` | `cubic-bezier(0.22, 1, 0.36, 1)` | 0.22, 1, 0.36, 1 | Anything that arrives. Cards, rows, overlays. Fast start, long settle. |
| `--ease-in-out` | `cubic-bezier(0.65, 0, 0.35, 1)` | 0.65, 0, 0.35, 1 | Anything that loops. Live pulse, breathing glow, shimmer. |
| `--ease-out-flex` | `cubic-bezier(0.05, 0.6, 0.4, 0.9)` | 0.05, 0.6, 0.4, 0.9 | Long travel that must not overshoot — drawers, sheets, scroll rails. |

The printed string is `e.curve` — spaces after commas, exactly as tabled. Do not reformat.

### 4.1 · `CurveGraph` — SVG geometry translated to painter terms

```tsx
const d = `M 0 100 C ${x1*100} ${100 - y1*100} ${x2*100} ${100 - y2*100} 100 0`;
<svg viewBox="-8 -58 116 172" className="h-28 w-full" role="img"
     aria-label={`Easing curve ${pts.join(", ")}`}>
  <rect x=0 y=0 width=100 height=100 fill="none" stroke="var(--border)" />
  <line x1=0 y1=0 x2=100 y2=0 stroke="var(--border)" strokeDasharray="3 3" />
  <path d={d} fill="none" stroke="var(--color-action)" strokeWidth="2.5" />
</svg>
```

**Coordinate system.** Origin bottom-left of a 100×100 unit box: `(0,100)` = t 0 / output 0; `(100,0)` = t 1 / output 1. Y is flipped (`100 − y·100`), so *up = more output*.

**The four paths, in user units:**

| token | C1 | C2 | full `d` |
|---|---|---|---|
| `--ease-spring` | (34, **−56**) | (64, 0) | `M 0 100 C 34 -56 64 0 100 0` |
| `--ease-out` | (22, 0) | (36, 0) | `M 0 100 C 22 0 36 0 100 0` |
| `--ease-in-out` | (65, 100) | (35, 0) | `M 0 100 C 65 100 35 0 100 0` |
| `--ease-out-flex` | (5, 40) | (40, 10) | `M 0 100 C 5 40 40 10 100 0` |

**viewBox letterboxing — the detail most likely to be got wrong.** `viewBox="-8 -58 116 172"` with the default `preserveAspectRatio="xMidYMid meet"` and a viewport of `482 × 112` (easing panel body × `h-28` = 7rem):

- scale `s = min(482/116, 112/172) = min(4.155, 0.65116) = **0.651163**` — **height-bound**
- rendered viewBox content: **75.535 × 112 px**, horizontally centred → left edge at `(482 − 75.535)/2 = **203.23px**`
- the 100×100 box therefore renders as a **65.116px square**, not stretched to the panel. Roughly 85% of the SVG's width is empty. A Flutter painter that fills its box will be visibly wrong.
- unit → px: `x_px = 203.23 + (x_u + 8)·0.651163`, `y_px = (y_u + 58)·0.651163`

Landmarks (482-wide panel):

| feature | px |
|---|---|
| box left / right | 208.44 / 273.56 |
| box top (y=0) / bottom (y=100) | 37.77 / 102.88 |
| SVG bottom (y=114) | 112.00 |
| spring curve's actual peak (y = −9.780 u) | 31.40 (6.37px above the box top) |
| stroke widths | path 2.5 u → **1.628px**; rect & line 1 u → **0.651px** |
| dash pattern `3 3` | **1.953px on / 1.953px off** |

Spring overshoot derivation (for a parity probe): with P0=(0,100), P1=(34,−56), P2=(64,0), P3=(100,0), `y(u) = 268u³ − 168u²` where `u = 1−t`; `dy/du = 0` at `u = 336/804 = 0.417910`; `y_min = −9.7803` units. The viewBox's 58 units of headroom exist for the **control point** at −56, not the curve — which is why the graph reads small.

⚠ **The dashed line is invisible.** `<line y=0 … 0..100>` lies exactly on the `<rect>`'s own top edge, same colour, same 1-unit width. The rect's solid stroke paints over the dashes. Draw both (order: rect, then line, then path) and expect no visible dash. It is dead ink, not a missing feature.

**Painter recipe.** `Path()..moveTo(0,100)..cubicTo(x1*100, 100-y1*100, x2*100, 100-y2*100, 100, 0)`, then a canvas transform implementing `meet`: `canvas.translate(dx, 0); canvas.scale(s); canvas.translate(8, 58);`. Stroke widths must be authored in **user units and scaled by the same transform** (a `Paint.strokeWidth` set post-scale will not match). `stroke` colours: rect/line `--border`, path `--color-action`. Default SVG caps are `butt` and joins `miter` — Flutter defaults to `StrokeCap.butt`/`StrokeJoin.miter`, so no override needed (note this differs from `ElIcon`'s `_GlyphPainter`, which sets round caps for lucide).

Accessibility label verbatim: `` `Easing curve ${pts.join(", ")}` `` → e.g. **"Easing curve 0.34, 1.56, 0.64, 1"** (JS `join` prints `1`, not `1.0`).

### 4.2 · The travel chip — and its computed no-op

```tsx
<div className="mt-4 h-6 rounded-sm bg-muted">
  <div key={`${e.token}-${run}`} className="size-6 rounded-sm bg-value"
       style={{ animation: `el-travel var(--duration-bloom) ${e.curve} both` }} />
</div>
```

Track: 482 × 24px, `rounded-sm` 6px, `--muted`. Chip: 24 × 24px (`size-6`), `rounded-sm`, `--color-value` #a3e635. No `overflow-hidden` on the track.

Duration is **`--duration-bloom` = 1000ms** (globals.css:411) — the page's own comment records that this replaced "the 900ms literal that was here". Easing is the row's own `e.curve` string, i.e. each chip runs its own curve over an identical fixed time. The source comment states the intent: "the travel time is fixed on purpose so every curve is judged over the same distance".

**`el-travel`** (globals.css:2203–2210):

| stop | transform |
|---|---|
| `from` | `translateX(0)` |
| `to` | `translateX(calc(100% - 1.5rem))` |

⚠⚠ **DRIFT — the chip does not move.** In CSS, a percentage inside `translateX` resolves against **the transformed element's own border box**, never the parent. The chip is `size-6` = 1.5rem = 24px wide, so `100%` = 24px and `calc(100% − 1.5rem)` = **0px**. The animation runs for 1000ms and translates by zero. The four easing panels communicate their curve through `CurveGraph` alone; the lime square is static.

The intended reading — "travel the track, minus the chip's own width" — would require the percentage to resolve against the 482px track, which `translateX` cannot do. **Do not fix it.** Port `el-travel` as `translateX(elementWidth − 24px)`, which evaluates to 0 for this call site and stays faithful if the utility is ever reused on a wider element. Flag it in the port's own comments. (Confidence: derived from spec, not observed — see Open questions Q1 for the one-line browser check.)

---

## 5 · Section `#interaction` — "The click feel"

Description verbatim: **"Ported from Yukirhythm, and the single most important thing in the motion system. Instant squish in, springy return out — 40ms down, 250ms spring back. That asymmetry is what makes the interface feel alive rather than animated."**

Three panels in `grid gap-4 sm:grid-cols-3`; each has copy `<p class="type-small mb-5">` then a full-width `h-24` (96px) `rounded-lg` (12px) `font-semibold` (600) `grid place-items-center` `<button>` reading **"Press and hold"**. Text size is inherited (no `.type-*` on the button) → the browser default 16px at weight 600.

### Panel 1 — label `.click-spring`, note **"40ms down · scale 0.9"**
Copy: **"The global click feel. Goes on anything clickable that is not a Button — avatars, chips, badges, rows, nav items."**
Button surface: `bg-primary text-primary-foreground shadow-btn-primary` (`--primary` = `--color-action` #1A6EF4; foreground `hsl(0 0% 100%)`).

### Panel 2 — label `.press-spring`, note **"40ms down · scale 0.92"**
Copy: **"Same feel, less travel. For larger surfaces where 0.9 would look comical."**
Button surface: `border border-border bg-card shadow-btn text-foreground`.

### Panel 3 — label `.press-key`, note **"80ms linear · 3px travel"**
Copy: **"A physical key travelling into its socket. Machine motion — linear, no spring, it just lands."**
Button surface: `bg-card text-foreground` — **no border class**; the raised-key shadow comes from the utility itself.

### `.lift` panel — label **".lift — cards and packs"**, `className="mt-4"`
```tsx
<div className="lift grid h-24 max-w-sm place-items-center rounded-lg border border-border bg-card font-semibold text-foreground">Hover me</div>
<p className="type-small mt-5">Rises three pixels and gains a shadow — enough to read as interactive without the grid feeling unstable.</p>
```
`max-w-sm` = 24rem = **384px**, `h-24` = 96px.

### The governing Note (`mt-4`)
`<Note tone="action" title="Content bounces; controls click">` — body verbatim: **"Yuki's governing rule, and ours now. Springy motion for things that appear, react or reward. Machine motion for things you operate. Never mix them — a button that jellies feels broken, and a reward that clicks feels cheap."** (`Yuki&rsquo;s` → U+2019.)

### The five press/lift utilities — exact CSS

| utility | globals.css | resting transition | `:active` / `:hover` | down | up |
|---|---|---|---|---|---|
| `press` | 2277–2284 | `transform var(--duration-base) var(--ease-spring)` | `transform: scale(0.94)` | **40ms** | 250ms spring |
| `click-spring` | 2286–2293 | `transform var(--duration-base) var(--ease-spring)` | `transform: scale(0.9)` | **40ms** | 250ms spring |
| `press-spring` | 2296–2303 | `transform **0.22s** var(--ease-spring)` | `transform: scale(0.92)` | **40ms** | **220ms** spring |
| `press-key` | 2307–2317 | `transform var(--duration-tick) linear, box-shadow var(--duration-tick) linear`; resting `box-shadow: var(--shadow-key)` | `transform: translateY(3px)`; `box-shadow: var(--shadow-key-down)` | **80ms linear** | **80ms linear** |
| `lift` | 2320–2330 | `transform var(--duration-base) var(--ease-out), box-shadow var(--duration-base) var(--ease-out), border-color var(--duration-base) var(--ease-standard)` | `:hover { transform: translateY(-3px); box-shadow: var(--shadow-e3) }` | — | 250ms |
| `btn-spring` | 1886–1898 | transform / background-color / border-color / color / box-shadow / opacity, all `var(--duration-base) var(--ease-spring)` | `:active { transition-duration: var(--duration-tick) }` | **80ms** | 250ms spring |

⚠ **DRIFT — "40ms down, 250ms spring back" is true of two of the six.**

| utility | down = 40ms? | up = 250ms? |
|---|---|---|
| `press` | ✅ | ✅ |
| `click-spring` | ✅ | ✅ |
| `press-spring` | ✅ | ❌ **220ms** — a raw `0.22s` literal, not a token, and not on the duration scale at all |
| `press-key` | ❌ 80ms | ❌ 80ms (linear both ways) |
| `lift` | n/a (hover) | ✅ 250ms |
| `btn-spring` | ❌ **80ms** (`--duration-tick`); its own comment at 1885 says "250ms overshoot release, **80ms** squish on press" | ✅ |

The *section description* and `RULES.md`:461 both assert the blanket 40/250. The *panel notes* on this same page are accurate per-utility (`.press-key` correctly says "80ms linear"). Render the description verbatim; implement the six utilities at their real numbers.

Shadow values these depend on (globals.css:354–377, ink themed):
- `--shadow-key: 0 4px 0 var(--wall), 0 7px 12px var(--ink-3)`
- `--shadow-key-down: 0 1px 0 var(--wall), inset 0 2px 5px var(--ink-3)` — **has an inset layer** → `ElMachineSurface`
- `--shadow-btn: inset 0 1px 0 var(--rim), inset 0 -2px 4px var(--ink-2), 0 1px 2px var(--ink-2), 0 3px 8px -2px var(--ink-2)`
- `--shadow-btn-primary: inset 0 1px 0 var(--rim-strong), inset 0 -2px 5px var(--ink-2), 0 1px 2px var(--ink-2), 0 4px 10px -2px color-mix(in oklab, var(--color-action) 55%, transparent)`
- `--shadow-e3: 0 2px 4px var(--ink-2), 0 14px 28px -8px var(--ink-3)`
- `--wall`: dark `hsl(240 6% 8%)`, light `hsl(240 6% 82%)`; `--rim`: dark `rgb(255 255 255/.14)`, light `hsl(0 0% 100%/.85)`; `--rim-strong`: dark `rgb(255 255 255/.28)`, light `hsl(0 0% 100%/.4)`
- `--ink-1..4`: dark `rgb(0 0 0 /.35/.5/.6/.75)`, light `hsl(240 20% 20% /.04/.07/.11/.16)`

Remember the recorded port rule: **CSS blur = 2σ; Flutter derives σ = r·0.57735 + 0.5** — `ElShadowLayer.blurRadius` stores the inverted value. Never pass CSS blur numbers into `BoxShadow` directly.

**Hover has no equivalent on touch.** `.lift` is hover-only in CSS. `ElLiftCard` already models it via `MouseRegion`; on a touch platform the demo is simply static, matching the web.

---

## 6 · Section `#named` — "Named animations"

Description verbatim: **"Yukirhythm's set, plus the three this product needed. Anything that animates should reach for one of these before a new keyframe is written."**

`<div class="mb-5 flex justify-end">` → `Button variant="outline" size="sm"` + RotateCcw + **"Replay all"**. Then `grid gap-4 sm:grid-cols-2 lg:grid-cols-3` — **nine** panels, in this order. Each panel: demo block, then `<p class="type-small mt-4">` copy.

| # | Panel `label` | Panel `note` | keyed for replay? | loop |
|---|---|---|---|---|
| 1 | `.anim-pop-in` | `550ms · from 25%` | ✅ `pop-${run}` | once, `both` |
| 2 | `.anim-jelly` | `600ms · squash & stretch` | ✅ `jelly-${run}` | once, `both` |
| 3 | `.anim-spring-up` | `800ms · settle` | ✅ `springup-${run}` | once, `both` |
| 4 | `.anim-jelly-in` | `420ms · spring` | ✅ `jellyin-${run}` | once, `both` |
| 5 | `.anim-ratchet` | `1.4s · steps(8)` | ❌ **no key** | **infinite** |
| 6 | `.anim-sign-on` | `900ms · TEXT only` | ✅ `sign-${run}` | once, `both` |
| 7 | `.anim-reveal` | `550ms · our own` | ✅ `reveal-${run}` | once, `both` |
| 8 | `.anim-shimmer` | `1.4s loop · our own` | ❌ **no key** | **infinite** |
| 9 | `.anim-pulse-live` | `2s loop · our own` | ❌ **no key** | **infinite** |

The three infinite demos are deliberately unkeyed — a looping animation has nothing to replay.

### 6.1 · Demo markup and copy

**1 · `.anim-pop-in`** — `<div class="anim-pop-in grid h-24 place-items-center rounded-lg border border-border bg-card">` wrapping `<span class="type-small text-foreground">Jelly pop</span>`.
Copy: **"Pops from 25%, never from 0, so it always reads as arriving rather than materialising."**

**2 · `.anim-jelly`** — `<div class="anim-jelly grid h-24 place-items-center rounded-lg border border-value/40 bg-value/12">` wrapping `<span class="type-num-md text-value-ink">+$1,240</span>` (Geist Mono 20px/1.15, 600, tabular, −0.01em).
Copy: **"The reward. Squashes to 1.18×0.82 and wobbles back. Reserve it for wins."**

**3 · `.anim-spring-up`** — `border-border bg-card`, `<span class="type-small text-foreground">Section entering</span>`.
Copy: **"Rises 32px, overshoots by 4, then settles in three decreasing bounces."**

**4 · `.anim-jelly-in`** — `border border-primary/40 bg-card`, `<span class="type-small text-foreground">Screen entering</span>`.
Copy: **"Scale plus rise with an overshoot. The screens-level entrance."**

**5 · `.anim-ratchet`** — outer `<div class="grid h-24 place-items-center">`; the animated element is `<span class="anim-ratchet grid size-10 place-items-center rounded-sm border border-input bg-card">` (40px square, 6px radius, `--input` border) containing the needle `<span class="block h-4 w-0.5 bg-action-bright" />` (16 × 2px, `--color-action-bright` #92C2FC). The **square** rotates, needle included.
Copy: **"Stepped mechanical spin. Eight discrete positions, not a smooth rotation — it reads as a mechanism."**

**6 · `.anim-sign-on`** — outer `<div class="grid h-24 place-items-center">`; `<span class="anim-sign-on type-h3 text-value-ink">LEGENDARY</span>` (21px/1.3, 600, −0.01em, Inter; literal uppercase in the source, **no** `text-transform`).
Copy: **"Neon power-up: flickers on, drops out, catches. Drives text-shadow, so it only works on text."**

**7 · `.anim-reveal`** — `border border-primary/40 bg-card`, containing `<Icon icon={Sparkles} size="xl" tone="action" />` → 24px, strokeWidth **2**, `text-action-ink`.
Copy: **"The card turning face-up. Rotates on the Y axis. Ours, not Yuki's."** (`Yuki&rsquo;s`)

**8 · `.anim-shimmer`** — `<div class="anim-shimmer h-24 rounded-lg" />` — an empty box, 299.333 × 96px. All paint comes from the utility.
Copy: **"Skeleton loading. Must match the footprint of the content it replaces."**

**9 · `.anim-pulse-live`** — outer `<div class="grid h-24 place-items-center">` containing the pill `<span class="flex items-center gap-2.5 rounded-pill border border-success/30 bg-success/10 px-3 py-1.5">` → animated dot `<span class="anim-pulse-live size-2 rounded-full bg-success" />` (8px, `--color-success` #10b981) + `<span class="type-micro text-success-ink">Live</span>` (10.5px/1, 600, uppercase, 0.18em; `text-success-ink` is a utility so it beats `.type-micro`'s own muted colour).
Copy: **"The only animation allowed to run forever, and only on the live indicator."**

### 6.2 · Utility declarations (globals.css)

| utility | line | declaration |
|---|---|---|
| `anim-pop-in` | 2361–2363 | `animation: yuki-pop-in 0.55s var(--ease-out) both` |
| `anim-jelly` | 2365–2367 | `animation: yuki-jelly 0.6s var(--ease-out) both` |
| `anim-spring-up` | 2369–2371 | `animation: yuki-spring-up 0.8s var(--ease-settle) both` |
| `anim-jelly-in` | 2376–2378 | `animation: yuki-jelly-in var(--duration-jelly) var(--ease-spring) both` |
| `anim-ratchet` | 2416–2418 | `animation: yuki-ratchet 1.4s steps(8) infinite` |
| `anim-sign-on` | 2420–2422 | `animation: yuki-sign-on 0.9s steps(1, end) both` |
| `anim-reveal` | 2341–2343 | `animation: pulls-reveal var(--duration-reward) var(--ease-out) both` |
| `anim-shimmer` | 2344–2353 | `background: linear-gradient(90deg, var(--popover) 0%, var(--accent) 50%, var(--popover) 100%); background-size: 200% 100%; animation: pulls-shimmer 1.4s var(--ease-in-out) infinite` |
| `anim-pulse-live` | 2354–2356 | `animation: pulls-pulse-live 2s var(--ease-in-out) infinite` |

⚠ **Four of the nine use raw time literals, not tokens** — `0.55s`, `0.6s`, `0.8s`, `1.4s`, `0.9s`, `2s`. Only `anim-jelly-in` (`--duration-jelly`) and `anim-reveal` (`--duration-reward`) read a token. `0.55s` happens to equal `--duration-reward` and `0.9s` has no token at all. `RULES.md`:518 demands easing be a token but says nothing about duration literals. The Flutter port's guard-as-test forbids literals outside `lib/src/foundation/` — so **add the missing durations to `motion.dart`** rather than inlining them at the call site (see the ledger, §12).

### 6.3 · Keyframes — every stop, verbatim (globals.css:2424–2531)

CSS applies the animation's timing function **between each adjacent pair of stops**, not once across the whole run. The Flutter house pattern (`sliding_pill.dart:217–245`) is `TweenSequence` with one `TweenSequenceItem` per gap, each wrapped in its own `CurveTween(curve: ElCurves.X)`, weights = the percentage gaps. Reuse it.

**`yuki-pop-in`** (2424–2430) — `.anim-pop-in`, 550ms, `--ease-out`, `both`. Weights 55 / 25 / 12 / 8.

| stop | opacity | transform |
|---|---|---|
| 0% | 0 | `scale3d(0.25, 0.25, 1)` |
| 55% | 1 | `scale3d(0.92, 1.08, 1)` |
| 80% | *(holds 1)* | `scale3d(1.04, 0.97, 1)` |
| 92% | *(holds 1)* | `scale3d(0.99, 1.01, 1)` |
| 100% | *(holds 1)* | `scale3d(1, 1, 1)` |

Opacity is declared only at 0% and 55%; from 55% onward it stays 1.

**`yuki-jelly`** (2431–2438) — `.anim-jelly`, 600ms, `--ease-out`, `both`. Weights 30 / 15 / 15 / 18 / 22. **Already implemented** as the private `_jellyScale` in `lib\src\motion\sliding_pill.dart` — lift it into a shared player.

| stop | transform |
|---|---|
| 0% | `scale3d(1, 1, 1)` |
| 30% | `scale3d(1.18, 0.82, 1)` |
| 45% | `scale3d(0.88, 1.12, 1)` |
| 60% | `scale3d(1.06, 0.94, 1)` |
| 78% | `scale3d(0.98, 1.02, 1)` |
| 100% | `scale3d(1, 1, 1)` |

**`yuki-spring-up`** (2439–2445) — `.anim-spring-up`, 800ms, **`--ease-settle`** `cubic-bezier(0.16,1,0.3,1)`, `both`. Weights 55 / 21 / 14 / 10.

| stop | opacity | transform |
|---|---|---|
| 0% | 0 | `translateY(32px)` |
| 55% | 1 | `translateY(-4px)` |
| 76% | *(holds 1)* | `translateY(1.5px)` |
| 90% | *(holds 1)* | `translateY(-0.5px)` |
| 100% | *(holds 1)* | `translateY(0)` |

Matches its copy exactly: 32px rise, 4px overshoot, three decreasing bounces (−4, +1.5, −0.5).

**`yuki-jelly-in`** (2446–2450) — `.anim-jelly-in`, `--duration-jelly` 420ms, `--ease-spring`, `both`. Weights 60 / 40.

| stop | opacity | transform |
|---|---|---|
| 0% | 0 | `scale(0.92) translateY(24px)` |
| 60% | 1 | `scale(1.02) translateY(-4px)` |
| 100% | 1 | `scale(1) translateY(0)` |

Source comment (2372–2375): the keyframes drive `transform` only, never `translate`, so the utility composes with a dialog's centring translate. Irrelevant on this page but note it if the utility is generalised.

**`yuki-ratchet`** (2471–2473) — `.anim-ratchet`, 1.4s, `steps(8)`, **infinite**, no fill.

| stop | transform |
|---|---|
| *(implicit 0%)* | element's own — none |
| `to` | `rotate(360deg)` |

`steps(8)` defaults to `steps(8, jump-end)` → **eight held positions of 45°**, each **175ms**: 0°, 45°, 90°, 135°, 180°, 225°, 270°, 315°. `360°` is never displayed; the cycle wraps to 0°. Flutter: no stock `Curve` does this — build `class ElSteps extends Curve { transform(t) => (t * n).floorToDouble() / n; }` (the `jump-end` variant) and note that `Curve` is asked for `t ∈ [0,1]`; guard `t == 1.0` to return `(n-1)/n` only if you want the visual to match CSS on the wrap frame, which for an infinite loop is unobservable.

**`yuki-sign-on`** (2474–2481) — `.anim-sign-on`, 900ms, `steps(1, end)`, `both`. `steps(1, jump-end)` applied *between every pair* means **no interpolation at all** — each stop's value is held until the next stop's time, then snaps.

| stop | ms window | opacity | text-shadow | filter |
|---|---|---|---|---|
| 0% | 0–144 | 0.12 | `none` | `brightness(0.5)` |
| 16% | 144–252 | 1 | `0 0 8px currentColor, 0 0 22px currentColor` | `brightness(1.35)` |
| 28% | 252–396 | 0.2 | `none` | `brightness(0.6)` |
| 44% | 396–504 | 1 | `0 0 8px currentColor, 0 0 22px currentColor` | `brightness(1.3)` |
| 56% | 504–630 | 0.35 | `0 0 4px currentColor` | `brightness(0.75)` |
| 70%, 100% | 630–900, then **held by `both`** | 1 | `0 0 6px currentColor, 0 0 18px currentColor` | `brightness(1.15)` |

Six hard cuts, no tweening — implement as a stepwise timeline, not a `Tween`. `currentColor` = `text-value-ink` (dark `--color-value-bright` #d9f99d; light `--color-value-dark` #4d7c0f). Render order per the filter spec: **draw text + shadows → apply `brightness` → apply `opacity`**. `brightness(x)` is a per-channel sRGB multiply, clamped — `ColorFilter.matrix([x,0,0,0,0, 0,x,0,0,0, 0,0,x,0,0, 0,0,0,1,0])`.

Pre-computed clamped glyph colours (multiply, round, clamp to 255) — useful as a probe oracle:

| brightness | dark #d9f99d → | light #4d7c0f → |
|---|---|---|
| 0.5 | #6D7D4F | #273E08 |
| 0.6 | #82955E | #2E4A09 |
| 0.75 | #A3BB76 | #3A5D0B |
| 1.15 | **#FAFFB5** (R clamped) | #598F11 |
| 1.3 | **#FFFFCC** (R,G clamped) | #64A114 |
| 1.35 | **#FFFFD4** (R,G clamped) | #68A714 |

**The resting state is not neutral.** `both` holds the 70% frame, so after 900ms "LEGENDARY" keeps a `0 0 6px + 0 0 18px` glow at brightness 1.15 forever. Do not fade it out.

CSS `text-shadow: 0 0 Npx c` = offset 0, **blur N**, so σ = N/2. Flutter `Shadow(color:, offset: Offset.zero, blurRadius: r)` uses `convertRadiusToSigma(r) = r*0.57735+0.5` — invert as the port already does for `BoxShadow` (`flutter-port-decisions`).

**`pulls-reveal`** (2503–2512) — `.anim-reveal`, `--duration-reward` 550ms, `--ease-out`, `both`. Two stops, so a single tween.

| stop | opacity | transform |
|---|---|---|
| `from` | 0 | `rotateY(-38deg) scale(0.9)` |
| `to` | 1 | `none` |

3-D Y-axis rotation. Flutter: `Matrix4.identity()..setEntry(3, 2, p)..rotateY(rad)..scale(s)` — **the CSS element has no `perspective` set on it or on any ancestor**, so the rotation is an **orthographic** (flat) Y-squash with no foreshortening. Set `p = 0` (no `setEntry(3,2,…)`) to match; adding perspective will look better and be wrong. −38° → cos(38°) = 0.78801, so the box compresses to 78.8% width at t=0, combined with the 0.9 uniform scale.

**`pulls-shimmer`** (2513–2520) — `.anim-shimmer`, 1.4s, `--ease-in-out`, **infinite**, no fill.

| stop | background-position |
|---|---|
| `from` | `200% 0` |
| `to` | `-200% 0` |

Gradient: `linear-gradient(90deg, var(--popover) 0%, var(--accent) 50%, var(--popover) 100%)` at `background-size: 200% 100%`. On a W = 299.333px box the tile is **2W = 598.667px**. CSS percentage background-position offset = `(containerW − imageW) · pct` = `−W · pct`; so `200%` → offset **−2W**, `−200%` → offset **+2W**. The bright `--accent` band sits at the tile's midpoint, i.e. at container-x `offset + W`, travelling from `−W` to `+3W` — **left to right**, one crossing per 1.4s cycle.
Colours: dark `--popover` `hsl(240 5.9% 10%)` → `--accent` `hsl(240 5.3% 26.1%)`; light `--popover` `hsl(0 0% 100%)` → `--accent` `hsl(240 4.8% 95.9%)`.
Flutter: a `LinearGradient` with stops `[0, 0.5, 1]` painted into a rect of width 2W translated by `offset(t) = 2W·(2t − 1)`, or equivalently a `GradientTransform`. The `rounded-lg` (12px) clip is on the same element.

**`pulls-pulse-live`** (2521–2531) — `.anim-pulse-live`, 2s, `--ease-in-out`, **infinite**, no fill.

| stop | opacity | box-shadow |
|---|---|---|
| 0%, 100% | 1 | `0 0 0 0 rgba(61, 220, 151, 0.5)` |
| 50% | 0.75 | `0 0 0 5px rgba(61, 220, 151, 0)` |

Offset 0, blur 0, **spread 0 → 5px**, alpha 0.5 → 0. A hard-edged ring expanding 5px outward from the 8px dot while fading. Flutter has no `spread` on `BoxShadow` in the CSS sense for a *hard* ring — paint it as a stroked/filled circle of radius `4 + 5t` behind the dot with alpha `0.5(1−t)`, and the dot itself at `opacity` `1 → 0.75 → 1`. Interpolate both halves of the cycle with `ElCurves.inOut`.

⚠ **Colour drift.** `rgba(61, 220, 151, …)` = **#3DDC97**, a hard-coded green from an earlier palette. The dot's own fill is `bg-success` = `--color-success` **#10b981**. The ring and the dot are different greens, in both themes. Port both values as written.

### 6.4 · Named animations the page does *not* show

`globals.css` also declares `anim-fade-up` (2338), `anim-jelly-out` (2382), `anim-unfold` (2396), `anim-fold` (2399), `anim-spin` (2407), `anim-caret` (2412), `anim-check-draw` (2243), `anim-dash-draw` (2247), `anim-dot-pop` (2251), `slide-pill` (2256), `swap-roll` (2265). The page's nine are a curated subset; the section's copy ("plus the three this product needed" — reveal, shimmer, pulse-live) does not claim completeness. Do not add panels.

---

## 7 · Section `#choreography` — "Pack-opening choreography"

Description verbatim: **"The one sequence allowed to take real time. It is built from the same tokens, and every stage is skippable."**

A single `Meta` — `<dl class="divide-y divide-border overflow-hidden rounded-lg border border-border bg-card">`; rows `grid gap-1 px-4 py-3 sm:grid-cols-[minmax(0,13rem)_1fr] sm:gap-4`; `<dt class="type-num-sm text-action-ink">` / `<dd class="type-small text-muted-foreground">`. **Static — nothing on this section animates.**

| k (verbatim) | v (verbatim) |
|---|---|
| 1 · Pack selected | 150ms — border becomes blue, glow-action applies. |
| 2 · Purchase confirmed | 320ms — dialog closes, page dims to the opening stage. |
| 3 · Pack enters | 550ms ease-out — pack scales up into the centre of the stage. |
| 4 · Tear | 400ms — blue bloom expands from the pack; particles are capped and never flash. |
| 5 · Cards reveal | 550ms each, staggered 60ms. Six cards resolve in roughly 900ms. |
| 6 · Rare escalation | Legendary and mythic cards add glow-value and anim-pop-in on top of the reveal — nothing longer. |
| 7 · Summary | 250ms anim-fade-up — total value and next actions appear. |
| Skip / Turbo | Available from stage 3 onward. Turbo collapses stages 3–6 to 300ms total. |

The `·` separators are U+00B7 middle dots; the dashes are em dashes. Row 5's arithmetic (550 + 5×60 = 850, "roughly 900ms") and row 8's "300ms" (not a token) are the copy's own — reproduce, don't correct.

---

## 8 · Section `#reduced` — "Reduced motion"

Description verbatim: **"A required behaviour, not a nicety. The product must stay fully usable and every value must stay legible with motion switched off."**

`<Panel label="What prefers-reduced-motion: reduce does">` — no note. Body: `<ul class="space-y-3">`, each `<li class="type-small flex gap-2.5">` = a dot `<span class="mt-2 size-1.5 shrink-0 rounded-full bg-action" />` (6px circle, `--color-action`, 8px top margin) + text. Then `<p class="type-small mt-5 border-t border-border pt-5">` containing `<Code>app/globals.css</Code>`.

Bullets verbatim, in order:
1. **"All durations and transitions collapse to 0.01ms."**
2. **"Looping animations run exactly once, then hold."**
3. **"Entrances resolve to their final state immediately — opacity 1, no transform."**
4. **"The pack-opening sequence jumps straight to the revealed cards and the results summary."**
5. **"Nothing is hidden or removed. No information exists only inside an animation."**

Closing line verbatim: **"Implemented globally in `app/globals.css`, so a new component inherits it without opting in."** (`Code` = `type-code rounded-sm border border-border bg-card px-1.5 py-0.5 text-muted-foreground`.)

### 8.1 · The blanket rule (globals.css:2534–2565, top-level — **unlayered**, so it outranks every `@layer`)

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
  .anim-fade-up, .anim-pop-in, .anim-reveal {
    opacity: 1 !important;
    transform: none !important;
  }
  .anim-intro-rise, .anim-intro-panel, .anim-intro-glow, .anim-blur-word-in {
    animation: none !important; opacity: 1 !important;
    transform: none !important; filter: none !important;
  }
}
```

Note what it does **not** do: `animation-delay` survives, and `animation-fill-mode` survives. Both matter below. The third block's four classes appear nowhere on this page (landing intro only).

⚠ Bullet 2 ("Looping animations run exactly once, then hold") is **half true**. `animation-iteration-count: 1` does make a loop run once — but only `both`/`forwards` fill modes *hold*. All three looping demos here declare **no fill mode**, so they revert to their resting styles instead of holding. Copy verbatim, implement per-demo.

### 8.2 · Per-demo behaviour under reduced motion — the authoritative table

Flutter equivalent: `MediaQuery.maybeDisableAnimationsOf(context)`; the port routes durations through `elAnimationDuration(context, d)` (`lib\src\theme_scope.dart:327–335`), which returns `Duration.zero`. For *display* of the flag (this section describes it but does not read it), use the MediaQuery directly.

| demo | rule that applies | resulting frozen state |
|---|---|---|
| `el-sweep` ×6 (duration bars) | blanket only; fill `both` | Bar holds `to` → **full-width (726px) blue bar**, all six identical. The section's entire point is destroyed by design. |
| `el-travel` ×4 (easing chips) | blanket only; fill `both` | Holds `to` → `translateX(0)` (see §4.2) — **visually unchanged**, because the animation was already a no-op. |
| `.anim-pop-in` | blanket **+ special case** | `opacity: 1; transform: none` forced. Final frame, no 0.01ms scale flash. |
| `.anim-jelly` | blanket only; fill `both` | Holds 100% = `scale3d(1,1,1)` = identity → **no visible change**. |
| `.anim-spring-up` | blanket only; fill `both` | Holds 100% = `translateY(0)`, opacity 1 (last declared at 55%). Correct final frame. |
| `.anim-jelly-in` | blanket only; fill `both` | Holds 100% = `opacity 1; scale(1) translateY(0)`. Correct final frame. |
| `.anim-ratchet` | blanket; **no fill** | `iteration-count: 1` → runs one 0.01ms cycle then **reverts to the element's own transform (none)** → square sits at **0°**, static. |
| `.anim-sign-on` | blanket only; fill `both` | Holds the 70% frame → **opacity 1, `text-shadow: 0 0 6px, 0 0 18px currentColor`, `brightness(1.15)`**. The word stays lit and glowing. Not a neutral state. |
| `.anim-reveal` | blanket **+ special case** | `opacity: 1; transform: none` forced — no rotateY flash. |
| `.anim-shimmer` | blanket; **no fill** | Runs once in 0.01ms, then `background-position` reverts to the element default `0% 0`. The utility's own `background` + `background-size: 200% 100%` are **not** in the keyframes, so they persist → a **static left-anchored gradient**, dark at the left edge, `--accent` band at the box's right edge. |
| `.anim-pulse-live` | blanket; **no fill** | One 0.01ms cycle, then reverts → **plain 8px `--color-success` dot, no ring, opacity 1**. |
| `press` / `click-spring` / `press-spring` / `press-key` / `lift` / `btn-spring` | blanket `transition-duration: 0.01ms` | State changes still happen, instantly and without easing. The buttons **still squish** on press (scale 0.9 / 0.92, 3px key travel) and `.lift` still jumps −3px on hover — they just teleport. Do not disable them. |
| anchor scroll | `scroll-behavior: auto !important` | Jump, no smooth travel. (`ElSection.scrollTo` already routes through `elAnimationDuration`.) |
| **replay buttons** | — | Still functional. Re-keying still remounts; each demo just re-freezes to its table row above. |

---

## 9 · Section `#rules` — "Rules" (no description)

`DoDont` — `grid gap-4 sm:grid-cols-2`; Do panel `rounded-lg border border-value/25 bg-value/[0.06] p-5`, heading `type-label mb-3 text-value-ink` "Do", `ul.space-y-2.5`, items `flex gap-2.5` with `Icon icon={Check} size="sm" tone="value" class="mt-0.5"` (14px, stroke 2.4); Don't panel `border-destructive/25 bg-destructive/[0.06]`, heading `text-destructive-ink` "Don't" (`Don&rsquo;t`), `Icon icon={X} size="sm" tone="error"`.

**Dos (verbatim, in order):**
1. "Use a duration token — 100, 150, 200, 250, 320 or 550ms. Nothing in between."
2. "Reserve ease-spring for reward moments; it reads as celebration."
3. "Keep skeletons shaped like the content they stand in for."
4. "Make the pack-opening sequence skippable from the moment it starts."

**Don'ts (verbatim, in order):**
1. "Don't animate anything for longer than 550ms outside the opening sequence."
2. "Don't loop an animation except the live indicator — constant movement is fatiguing."
3. "Don't flash, strobe or rapidly alternate brightness; it is an accessibility hazard."
4. "Don't let text move while it is being read — animate the container, not the copy."

⚠ **Four drifts live inside these eight lines** — see the register (§13, D6–D9). Render verbatim.

---

## 10 · Foot nav (`PageFootNav groupId="foundations" slug="motion"`)

Foundations order: colors → typography → spacing → shadows → **motion** → icons. Both neighbours exist, so both cards render (no `flex-1` spacer).

- **Previous** → title **"Shadows"**, href `/design-system/shadows`
- **Next** → title **"Icons"**, href `/design-system/icons`

`nav.mt-8 flex items-stretch gap-4 border-t border-border pt-8`; each link `press flex min-w-0 flex-1 items-center gap-3 rounded-lg border border-border bg-card px-5 py-4 hover:border-input` (next mirrors with `justify-end text-right`, arrow last). `Icon size="md"` (16px, stroke 2.4, `tone="muted"`); caption `type-micro block text-muted-foreground` "Previous"/"Next"; title `type-small mt-1 block truncate text-foreground`. See `shared-map.md` §2.

---

## 11 · The replay mechanism (run-counter keying)

```tsx
const [run, setRun] = useState(0);
const replay = () => setRun((n) => n + 1);
```

**One counter for the whole page. Three buttons. All three call the same `replay`.** Pressing "Replay" in the durations panel also restarts the four easing chips **and** the six finite named-animation demos. There is no per-section scoping. This is load-bearing behaviour, not an implementation detail.

React remounts any element whose `key` changes, and a freshly mounted element with a CSS `animation` starts that animation from t=0. Sixteen elements are keyed on `run`:

| where | key template | count |
|---|---|---|
| `#durations` bars | `` `${d.token}-${run}` `` | 6 |
| `#easing` chips | `` `${e.token}-${run}` `` | 4 |
| `#named` | `pop-${run}`, `jelly-${run}`, `springup-${run}`, `jellyin-${run}`, `sign-${run}`, `reveal-${run}` | 6 |

Unkeyed: the three infinite demos (ratchet, shimmer, pulse-live), the three press buttons, the `.lift` card, and the `CurveGraph` SVGs (static). The Panel note `run ${run}` re-renders with the counter.

**Buttons** (identical shape ×3): `Button variant="outline" size="sm"` → `h-8` (32px), `px-3.5` (14px), `gap-1.5` (6px), `rounded-pill` (999px), `text-small` (13px) `font-medium` (500), `border-input bg-card text-foreground shadow-btn`, `hover:bg-muted`, `active:shadow-btn-down`, base `btn-spring` + `active:not-aria-[haspopup]:scale-95`. Child `<Icon icon={RotateCcw} size="sm" tone="inherit"/>` → 14px, strokeWidth 2.4, `text-current` (= `--foreground`). Labels: **"Replay"**, **"Replay curves"**, **"Replay all"**. Placement: durations → inside the panel body, `mb-5 flex justify-end`; easing → after the grid, `mt-4 flex justify-end`; named → before the grid, `mb-5 flex justify-end`.

**Flutter translation.** Hold `int _run = 0` in the page's `State`. Wrap each finite demo in `KeyedSubtree(key: ValueKey('$name-$_run'), child: …)` where the child is a small `StatefulWidget` that creates its `AnimationController` in `initState` and calls `forward()` — the remount then reproduces React's semantics exactly, including "a demo that was mid-flight restarts". The alternative (`controller.forward(from: 0)` broadcast via a `ValueNotifier`) is equivalent for these nine but diverges for `el-sweep`'s `both` fill; prefer the key. All controllers must take `elAnimationDuration(context, …)`.

---

## 12 · Motion tokens (globals.css:389–433)

```
--default-transition-duration: 250ms;              (395)
--default-transition-timing-function: var(--ease-out);  (396)
--duration-tick:    80ms    (398)      --duration-slow:    400ms   (401)
--duration-fast:   150ms    (399)      --duration-overlay: 320ms   (402)
--duration-base:   250ms    (400)      --duration-jelly:   420ms   (406)
--duration-reward: 550ms    (407)      --duration-bloom:  1000ms   (411)
--duration-sway:    44s     (417)      --duration-sway-alt: 33s    (418)

--ease-spring:   cubic-bezier(0.34, 1.56, 0.64, 1)   (420)
--ease-out:      cubic-bezier(0.22, 1, 0.36, 1)      (421)
--ease-in:       cubic-bezier(0.7, 0, 0.84, 0)       (428)
--ease-in-out:   cubic-bezier(0.65, 0, 0.35, 1)      (429)
--ease-out-flex: cubic-bezier(0.05, 0.6, 0.4, 0.9)   (430)
--ease-settle:   cubic-bezier(0.16, 1, 0.3, 1)       (431)
--ease-standard: cubic-bezier(0.4, 0, 0.2, 1)        (432)
```

The page documents **6 of 10** durations (tick, fast, base, slow, overlay, reward — not jelly, bloom, sway, sway-alt) and **4 of 7** easings (spring, out, in-out, out-flex — not in, settle, standard), while *using* `--duration-jelly` (anim-jelly-in), `--duration-bloom` (travel chips) and `--ease-settle` (anim-spring-up) in demos it does not label.

## 12.1 · Colour tokens this page touches

| token | dark | light |
|---|---|---|
| `--background` | `hsl(240 10% 3.9%)` | `hsl(0 0% 100%)` |
| `--card` | `hsl(240 5.9% 10%)` | `hsl(0 0% 100%)` |
| `--muted` | `hsl(240 3.7% 15.9%)` | `hsl(240 4.8% 95.9%)` |
| `--popover` | `hsl(240 5.9% 10%)` | `hsl(0 0% 100%)` |
| `--accent` | `hsl(240 5.3% 26.1%)` | `hsl(240 4.8% 95.9%)` |
| `--border` | `hsl(240 3.7% 15.9%)` | `hsl(240 5.9% 90%)` |
| `--input` | `hsl(240 5.3% 26.1%)` | `hsl(240 5.9% 90%)` |
| `--foreground` | `hsl(0 0% 98%)` | `hsl(240 10% 3.9%)` |
| `--muted-foreground` | `hsl(240 4.9% 83.9%)` | `hsl(240 4% 40%)` |
| `--color-action` / `--primary` | `hsl(217 91% 53%)` #1A6EF4 | same |
| `--color-action-bright` | `hsl(213 94% 78%)` #92C2FC | same |
| `--action-ink` | #92C2FC | `hsl(224 76% 33%)` #143694 |
| `--primary-foreground` | `hsl(0 0% 100%)` | same |
| `--color-value` | #a3e635 | same |
| `--value-ink` | #d9f99d | #4d7c0f |
| `--color-success` | #10b981 | same |
| `--success-ink` | #10b981 | #047857 |
| `--destructive` | `hsl(0 72.2% 50.6%)` | same |
| `--destructive-ink` | #f87171 | `hsl(0 72.2% 46%)` |
| *(hard-coded, pulse-live only)* | `rgba(61, 220, 151, α)` #3DDC97 | same |

---

## 13 · Drift register (copy vs CSS — both sides, for a 1:1 port)

| # | where | the copy says | the CSS does |
|---|---|---|---|
| D1 | `#easing` travel chips | a chip travels the track under each curve | `translateX(calc(100% - 1.5rem))` on a 24px element = **0px**. No movement. |
| D2 | `#interaction` description + `RULES.md`:461 | "40ms down, 250ms spring back" | true for `press` and `click-spring` only. `press-spring` releases in **220ms** (raw `0.22s`); `press-key` is **80ms linear** both ways; `btn-spring` presses in **80ms**. |
| D3 | `#durations` description | "overlays get up to **350ms**" | `--duration-overlay` is **320ms**. No 350ms token exists. |
| D4 | `#easing` description | "things you operate use **ease-standard**" | `--ease-standard` exists (432) but is **not one of the four panels**, and controls actually run `--ease-spring` (`btn-spring`, `press`, `click-spring`, `press-spring`). Only `lift`'s border-colour uses it. |
| D5 | `--ease-spring` use copy | "THE curve … **every press release**, every jelly entrance" | contradicted by D6 on the same page. |
| D6 | `#rules` Do #2 | "**Reserve** ease-spring for reward moments" | directly contradicts D5 and the actual utilities, where ease-spring is the *control* release curve. |
| D7 | `#rules` Do #1 | "a duration token — **100**, 150, **200**, 250, 320 or 550ms" | **100 and 200 are not tokens.** **80 (`tick`) and 400 (`slow`) are** — and both are documented three sections above in this page's own table. Also omits jelly 420 and bloom 1000, which this page itself uses. |
| D8 | `#rules` Don't #1 | "never longer than 550ms outside the opening sequence" | this page runs `anim-jelly` 600ms, `anim-spring-up` **800ms**, `anim-sign-on` 900ms, `anim-ratchet` 1.4s, `anim-shimmer` 1.4s, `anim-pulse-live` 2s, and the travel chips at **1000ms**. |
| D9 | `#rules` Don't #3 | "Don't flash, strobe or rapidly alternate brightness; it is an accessibility hazard" | `anim-sign-on` alternates opacity 0.12 → 1 → 0.2 → 1 → 0.35 → 1 with `brightness()` 0.5 → 1.35 → 0.6 → 1.3 → 0.75 → 1.15 across six hard cuts in 900ms — about **3.3 alternations/second**. Under the 3 Hz threshold, but it is the exact behaviour the rule names. |
| D10 | `#reduced` bullet 2 | "Looping animations run exactly once, **then hold**" | the three loopers declare **no `fill-mode`**, so they revert to resting styles rather than holding. |
| D11 | `#choreography` row 5 | "550ms each, staggered 60ms. Six cards resolve in roughly 900ms" | 550 + 5×60 = **850ms**. |
| D12 | `#choreography` Skip/Turbo | "collapses stages 3–6 to **300ms** total" | 300ms is not a duration token. |
| D13 | header chips (nav.ts) | "Interaction utilities", "Reveal choreography" | sections are titled "The click feel", "Pack-opening choreography"; and `#rules` has no chip. |
| D14 | `.anim-pulse-live` | one live-indicator green | ring is `rgba(61,220,151,…)` **#3DDC97**; dot fill is `--color-success` **#10b981**. |
| D15 | `CurveGraph` | a dashed reference line at output = 1 | the dashed `<line>` lies exactly on the `<rect>`'s top edge in the same colour and is **never visible**. |
| D16 | `#named` | the notes name each duration | `anim-pop-in` 0.55s, `anim-jelly` 0.6s, `anim-spring-up` 0.8s, `anim-ratchet` 1.4s, `anim-sign-on` 0.9s, `anim-shimmer` 1.4s, `anim-pulse-live` 2s are **raw literals**, not tokens — despite `RULES.md`:506 "One source of truth for motion". Only `anim-jelly-in` and `anim-reveal` read a token. |
| D17 | fonts (project-wide) | prose says Space Grotesk | `--font-sans` = "Inter Local". Port follows tokens (recorded decision). Applies to "LEGENDARY", "Press and hold", "Hover me". |

---

## 14 · Exists / missing ledger — Flutter port

Verified against `D:\DESIGN\Design-System-2026-8\flutter-design-system` at HEAD `b6ad6a3`.

**Verified: there was never a `ElAnims` / `ElAnimate` keyframe player in this repository.** `git log --all --diff-filter=D --name-only` returns empty (no file has ever been deleted); a content scan of every commit in every ref for `ElAnims|ElAnimate|ElKeyframe` under `lib/` returns zero hits. `lib/src/motion` has exactly three commits, all additive. Plan for building from scratch, not for restoring.

### 14.1 · Exists — reuse as-is

| Thing | Location | Notes |
|---|---|---|
| `ElDurations` | `lib\src\foundation\motion.dart` | `tick` 80, `fast` 150, `base` 250, `slow` 400, `overlay` 320, `jelly` 420, `reward` 550, `bloom` 1000, `sway` 44s, `swayAlt` 33s, `pressDown` 40ms, `animJelly` 600ms |
| `ElTransforms` | same | `pressScale` 0.94, `clickSpringScale` 0.9, `pressSpringScale` 0.92, `buttonScale` 0.95, `liftY` −3, `keyDownY` 3 |
| `ElCurves` | same | `spring`, `out`, `curveIn` (renamed from `--ease-in`), `inOut`, `settle`, `standard`, `outFlex`, plus `ElCurves.all` (7 items — ready-made for the easing gallery, but its order is `[spring, out, curveIn, inOut, outFlex, settle, standard]`, **not** the page's four-item order) |
| `elAnimationDuration(context, d)` | `lib\src\theme_scope.dart:327–335` | the `prefers-reduced-motion` port; returns `Duration.zero` under `MediaQuery.disableAnimations` |
| `ElPress` | `lib\src\motion\press.dart` | asymmetric: `duration: pressDown` / `reverseDuration: base`, `ElCurves.spring` + `.flipped`; unclamped `Transform.scale` so overshoot carries; both durations re-read per build through `elAnimationDuration` |
| `ElLift`, `ElLiftCard` | `lib\src\motion\lift.dart` | 250ms; `ElCurves.out` for rise+shadow, `ElCurves.standard` for border tint — matches `lift` exactly; `translateY(-3)`; shadow lerps from a transparent zero-size layer |
| `ElSlidingPillGroup` + private `_jellyScale` | `lib\src\motion\sliding_pill.dart:217–245` | **the only keyframe implementation in the tree** — `TweenSequence<Offset>` with per-segment `CurveTween(ElCurves.out)` and weights 30/15/15/18/22 = `yuki-jelly`. This is the pattern to generalise. |
| Docs kit | `example\lib\kit.dart` | `ElPageHeader`(48) · `ElSection`(142) · `ElPanel`(236) · `ElMeta`(384, `typedef ElMetaItem = ({String k, InlineSpan v})`) · `ElCode`(442, + `ElCode.span`) · `ElDoDont`(641) · `ElNote`(740, `enum ElNoteTone{action,value,error}`) · `ElDividedList`(1196) · `ElPageFootNav`(1062) |
| `ElButton` | `lib\src\components\button.dart` | `variant: ElButtonVariant.outline` ✅, `size: ElButtonSize.sm` ✅ (h 32, `paddingXFor` el(3.5), `gapFor` el(1.5)); press = `ElPress(scale: buttonScale, downDuration: tick, upDuration: base)` |
| `ElIcon` + path layer | `lib\src\components\icon.dart`, `icon_paths.dart` | sizes xs 12 … xl3 40, `strokeFor(px)` 2.4/2/1.6, tones incl. `inherit` and `action`; full SVG `d` parser (`ElIconPathElement`, arcs → cubics) |
| `ElMachineSurface` | `lib\src\effects\machine_surface.dart` | required for every inset shadow (`shadow-key-down`, `shadow-btn*`) |
| `Path.cubicTo` precedent | `icon_paths.dart:427–441, 489–491, 641` + `test\icon_paths_test.dart` | cubic drawing is already proven |
| Nav registration | `example\lib\nav.dart:160–173` | motion category **already registered** with the correct slug, title, blurb and six `contents` strings; route resolves to `/design-system/motion` |

### 14.2 · Missing — must be built

| Thing | Why / where |
|---|---|
| **A shared keyframe player** | Nothing public exists. Generalise `_jellyScale`'s pattern into e.g. `ElKeyframes` (foundation) + a `ElKeyframePlayer` widget: `TweenSequence` over `(stop%, value)` pairs, per-segment `CurveTween`, `fillMode` semantics (`both` vs none — the reduced-motion table in §8.2 hinges on it). |
| **Eight of the nine named animations** | Only `yuki-jelly` exists (and only privately). Needed: `yuki-pop-in`, `yuki-spring-up`, `yuki-jelly-in`, `yuki-ratchet`, `yuki-sign-on`, `pulls-reveal`, `pulls-shimmer`, `pulls-pulse-live` — plus the page's own `el-sweep` and `el-travel`. |
| **A `steps()` `Curve`** | For `yuki-ratchet` `steps(8)` and `yuki-sign-on` `steps(1, end)`. `docs\superpowers\research\globals-map.md:324` already flags this. Note: `steps(1,end)` between *every* keyframe pair = a stepwise timeline, which may be simpler to model as a discrete `ValueListenable<int>` than as a `Curve`. |
| **Duration tokens for the literals** | `motion.dart` has no constant for 0.55s, 0.8s, 0.9s, 1.4s, 2s, or the ratchet's 175ms step. The guard-as-test forbids literals outside `lib/src/foundation/`, so add them there (`popIn`, `springUp`, `signOn`, `ratchet`, `shimmer`, `pulseLive`) rather than annotating call sites. |
| **`RotateCcw` and `Sparkles` glyphs** | `enum ElIconGlyph` has exactly 8 members (`menu, x, sun, monitor, moon, arrowLeft, arrowRight, check`). Neither exists. Precedent for adding a glyph **without touching the package enum**: `example\lib\logo.dart:19–24, 114–166` declares a file-local `const ElIconPathElement` and strokes it in its own `CustomPainter`. |
| **Leading-icon composition on `ElButton`** | `ElButton` takes one `child`, no icon parameter. Compose `Row(children: [glyph, SizedBox(width: ElButton.gapFor(size)), Text(...)])` — the public statics `heightFor`/`paddingXFor`/`gapFor`/`isSquare` exist for exactly this. |
| **`CurveGraph` painter** | New `CustomPainter` implementing the `xMidYMid meet` letterbox of §4.1. Do not fill the box. |
| **`.click-spring` / `.press-spring` / `.press-key` demo widgets** | `ElPress` covers click-spring (0.9 / 40ms / 250ms) and press-spring (0.92 / 40ms — but **220ms** release, which `ElPress` cannot express from `ElDurations` alone; a 220ms token or an explicit `upDuration` is needed). `press-key` is **not** covered at all: linear 80ms, `translateY(+3)`, and a `shadow-key` → `shadow-key-down` swap that needs `ElMachineSurface`. |
| **`example\lib\pages\motion.dart`** | Does not exist. `/design-system/motion` currently renders `PlaceholderPage(eyebrow: 'Foundations', title: 'Motion')` with the literal string `'Not ported yet'` (`example\lib\pages\placeholder.dart`, 45 lines). |
| **Route entry** | `example\lib\main.dart:100–108` `pageFor(String route)` switch — add `'$elRoot/motion' => const MotionPage(),` + import. |

### 14.3 · Constraints the implementer must respect

- **Token guard** (`test\token_guard_test.dart`) scans `lib\` and `example\lib\` (exempting only `lib/src/foundation/`) and fails on `Color(0x`, `fontSize: <digit>`, `letterSpacing: <digit>`, `FontWeight.w<digit>`, **`\bCurves.`** (stock Flutter curves banned — use `ElCurves`), `Duration(milliseconds:/microseconds: <digit>`, `BorderRadius.circular(<digit>`, **`BoxShadow(`**. Comments are scanned too. Escape hatch: trailing `// allow-hardcoded: <reason>` — see `sliding_pill.dart:236–245` for how keyframe geometry is annotated.
- **Nav `contents` is a contract** (`nav.dart` docstring): the six strings promise six sections exist. The page ships **seven** sections (`#rules` has no chip) — matching the web. Do not add a seventh chip.
- **Zero third-party dependencies** (`pubspec.yaml`: only `flutter`, `flutter_test`, `flutter_lints`, `yaml`). No animation package, no SVG package.
- **Existing bug, fix while in there:** `lib\src\motion\sliding_pill.dart:71–74` — the `_jelly` `AnimationController`'s duration is set once at field init to `ElDurations.animJelly` and never routed through `elAnimationDuration`, so the arrival squash ignores reduced motion while the travel and fade honour it.

---

## 15 · Open questions

1. **`el-travel` = 0px (D1) — confirm in the browser before shipping the no-op.** Derived from the CSS transform spec (percentages resolve against the element's own border box), not observed. One-line check on the running reference: `getComputedStyle(document.querySelector('.size-6.bg-value')).transform` mid-animation, or `document.querySelector('.size-6.bg-value').getBoundingClientRect().left` at t=0 vs t=900ms. If it *does* move, the reference behaves differently from spec and this map's §4.2 must be rewritten.
2. **`press-spring`'s 220ms.** It is a raw `0.22s` outside the duration scale. Add a `ElDurations.pressSpringUp = 220ms` token, or express it as an explicit `upDuration` at the call site with an `allow-hardcoded:` note? The guard makes the first cleaner; the second keeps the drift visible in the demo, which the fidelity bar may prefer.
3. **`brightness()` under a theme swap.** The pre-computed colours in §6.3 are clamped per theme. Should the port apply a live `ColorFilter.matrix` (exactly reproduces CSS, including clamping) or precomputed `Color`s (cheaper, simpler probes)? Recommend the matrix, with the table as the probe oracle.
4. **`pulls-reveal` perspective.** Confirmed no `perspective` on the element or any ancestor → orthographic Y-squash. Worth one visual A/B against the reference, because an orthographic 3-D rotate is unusual enough that it may read as a bug in review.
5. **Base font size on the three press buttons.** They carry no `.type-*` class, so they inherit. `html` sets only `font-sans`; `body` sets no size. Confirm the computed value is the browser default 16px (not 15px from `.type-body`) before hardcoding — measure with the existing probe rig.
6. **`.anim-shimmer`'s frozen gradient under reduced motion** (§8.2) depends on `background-position`'s initial value being `0% 0`. Worth one screenshot in reduced-motion mode; it is the least obvious row in that table.
7. **Ratchet wrap frame.** `steps(8, jump-end)` never shows 360°. For an infinite loop this is unobservable, but if the port ever plays it finitely (reduced motion runs it once), decide whether the single 0.01ms run lands on 0° (matches CSS + no fill) or 315°.
8. **Should `ElCurves.all` be reordered?** Its docstring claims globals.css declaration order but lists `outFlex` 5th where the field order puts it 7th. Unrelated to this page (which needs only four curves, in its own order), but it will mislead whoever builds a full easing gallery later.


---

## CHECKED - 2026-08-15 - the `duration-*` utility classes are inert

*(Corpus-wide sweep prompted by `selection-map.md` §7.1. Full mechanism and probe
record in `forms-map.md`'s 2026-08-15 correction block.)*

**This map's scale and utility inventory are clean.** §4's token table is the
motion page's own rendered content; §5's `press` / `click-spring` / `press-key` /
`lift` / `btn-spring` rows and §6's `anim-*` rows all read `var(--duration-*)`
directly out of `globals.css`. Nothing here was derived from a class list.

One thing this map is the right place to record, because it governs every other
map's timing inventory:

**Tailwind v4 has no `--duration-*` theme namespace.** The ten duration customs
are emitted into `:root,:host` and are consumed correctly by `@utility` blocks,
by the `anim-*` keyframe rules, by the `[class*="animate-in"]` bridge
(`--tw-duration: var(--duration-overlay)`) and by plain rules such as
`:where(.prose) a` - but they **generate no utility class**. The only
`.duration-*` selectors in the built stylesheet are `.duration-200` and
`.duration-400`. A `duration-fast` / `duration-base` / `duration-tick` in a
`className` is decoration: `--tw-duration` stays unset and every `transition-*`
utility resolves through `var(--tw-duration, var(--default-transition-duration))`
to **250ms** (`globals.css:395`).

globals.css:392-394 points the framework default at `--duration-base` to stop a
`duration-*` class beating it - a precaution against a class that cannot be
generated. The two values agree today; they are two declarations, not one.

**Port impact.** `lib\src\foundation\motion.dart` gained
`ElDurations.transitionDefault` (250ms) for exactly this, documented and cited to
the probe. Spell `ElDurations.base` **only** where the reference reads
`var(--duration-base)` directly; every `transition-*` **utility** maps to
`transitionDefault`. Nine call sites moved on 2026-08-15 - two of them
(`checkbox.dart`, `radio.dart`) were rendering at 150ms and are now correct; the
other seven were value-identical.
