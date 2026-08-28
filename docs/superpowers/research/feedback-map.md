# Map — `/design-system/components/base/feedback` (Base Components · Feedback)

**Route directory name, verified:** `design-system\app\design-system\components\base\**feedback**\page.tsx`. The
directory is `feedback` (singular, no suffix); the page component is `FeedbackPage`; `findCategory("base","feedback")`
resolves it. Confirmed against the live server at `http://localhost:3000/design-system/components/base/feedback`
(`location.href` and `<h1>` = **"Feedback"**).

**Files that produce the render** (all under `D:\DESIGN\Design-System-2026-8\design-system\`):
- `app\design-system\components\base\feedback\page.tsx` — the page. **`"use client"`** (`:1`). 520 lines, **no
  page-local components at all** — one module-level const (`PROGRESS_TONES`, `:55–60`) and one default export. The
  simplest page structure in the base group; the complexity is entirely in the effects.
- `components\el\kit.tsx` — `PageHeader`, `Section`, `Panel` (`:100–113` strip + body), **`Row` (`:116–141`)**,
  `Meta` (`:202`), `Code` (`:229`), `DoDont` (`:238`), `Note` (`:272–297`), `PageFootNav`. `StateGrid`/`StateCell` are
  **not** used here.
- `components\ui\alert.tsx` — 131 lines. `Alert` (`:61`), `AlertTitle` (`:91`), `AlertDescription` (`:104`),
  **`AlertAction` (`:120–128`)**. Carries `feedback-surface` and the `.starfield` span (`:85`).
- `components\ui\sonner.tsx` — 63 lines. `TOAST_ICONS` (`:18–24`), `ToastType` (`:26`), `Toaster` (`:28–60`).
  Mounted once at `app\layout.tsx:39` as `<Toaster position="bottom-right" />`.
- `components\el\toast-preview.tsx` — 55 lines. `ToastPreview` (`:18–49`) renders **sonner's own markup minus
  `data-sonner-toast`**; `ToastPreviewStack` (`:52–54`) = `<ul class="flex list-none flex-col gap-4">`.
- `components\ui\progress.tsx` — 102 lines. `progressIndicatorVariants` (`:43–64`, **5 tones**), `Progress`
  (`:66–99`). Radix `Progress.Root`/`.Indicator`.
- `components\ui\empty.tsx` — 105 lines. `Empty`, `EmptyHeader`, `EmptyMedia` (+`emptyMediaVariants` `:28–41`),
  `EmptyTitle`, `EmptyDescription`, `EmptyContent`.
- `components\ui\skeleton.tsx` — 32 lines. One component, one prop (`as: "div" | "span"`).
- `components\ui\spinner.tsx` — 12 lines. `<Icon icon={Loader2Icon} className="size-4 anim-spin"/>`.
- `components\ui\icon.tsx` — `ICON_SIZES` (`:15–23`), `ICON_TONES` (`:27–50`), the **strokeWidth ladder** (`:82`).
- `components\ui\button.tsx` — `loading` prop; `variant="outline"` ×5, `variant="secondary" size="sm"` ×2,
  `variant="default"` ×2, `variant="premium"` ×1.
- `node_modules\sonner\dist\styles.css` — **725 lines, the enter/exit choreography.** Transcribed in §6.3. It is
  injected into `<head>` at runtime, **unlayered**, which is why `.cn-toast` needs three classes (§6.2).
- `node_modules\sonner\dist\index.mjs` — the runtime constants (`:411–425`) and the timer lifecycle (`:505–625`).
- `lib\el\nav.ts:237–251` — `findCategory("base","feedback")`; `siblings()` → prev **Navigation**, next **Chat**.
- `app\globals.css` — `@utility feedback-surface` (`:1663–1847`), `@keyframes cosmic-drift-deep/near` (`:1864–1877`),
  `.cn-toast` block (`:2584–2812`), theme blend split (`:3235–3287`), `.starfield` (`:3364–3488`),
  `anim-shimmer` (`:2344–2353`), `anim-spin` (`:2407–2409`), durations (`:395–433`), light bloom vars (`:699–715`),
  dark bloom vars (`:885–898`), reduced motion (`:2534–2542`).
- Deps: `sonner ^2.0.7`, `radix-ui ^1.6.7` (Progress), `lucide-react ^1.28.0`, `next-themes`, `cva`.

Read with `shared-map.md` (shell, kit anatomy, type-class table, Icon sizes/tones), `shadows-map.md`
(`--shadow-e3`, `shadow-pressed`, `shadow-btn*`, §13 CSS→Flutter conversion), `motion-map.md` (`anim-spin`,
`anim-shimmer`, reduced motion), `forms-map.md` (§7.1 Alert anatomy, §7.2 bloom summary, §11 toast summary — this
map supersedes all three with the full transcription) and `buttons-map.md` (`loading`, Spinner).

**Measurement note.** Everything marked *(measured)* was read out of the **live page at 1440×900 in the dark
theme** via `getComputedStyle` / `getBoundingClientRect` on `http://localhost:3000`, not deduced from the class
lists. Where a value comes from the built stylesheet or a package file it is cited by `file:line`. Every pin below
is a rendered pixel: no blurred difference-paths (`drawDRRect`) anywhere in the porting notes.

---

## 0 · Shell / layout metrics — delta from foundations

Identical shell (`shared-map.md` §1). What is new or different on this page:

| thing | value |
|---|---|
| Route | `/design-system/components/base/feedback` |
| Specimen column | **1080px** at the 1440 frame, as everywhere |
| Panel body | `bg-background p-6` → 1080 − 2 (panel border) − 48 (padding) = **1030px** *(measured)* |
| Panel label strip | `flex items-baseline justify-between gap-4 border-b border-border bg-muted px-5 py-3` → **36px** tall, 12/20 padding, `--muted` fill, 1px bottom border *(measured)* |
| Two-up grid | `grid gap-4 lg:grid-cols-2` → **532 / 532** with 16px gap; panel body inside = **482px** *(measured)* |
| Section rhythm | `mb-20` (80px) on all seven sections; `type-h3` heading; description `type-small mt-2 max-w-2xl` = **672px** *(measured)* |
| **Page-level Note** | `Note tone="action" className="mb-12"` sits **between the header and the first section**, at the full **1080px**, `margin-bottom: 48px` *(measured)*. No other base page has a callout outside a section. |
| Header | `mb-14 border-b border-border pb-10` → **239.89px** tall, 56px below, 40px pad, 1px rule *(measured)* |
| **Document height** | **`document.documentElement.scrollHeight = 6106px`** at 1440×900, dark, pristine *(measured)* — the `_referenceHeight` candidate for the vertical parity probe. See §17 Q6. |

Per-section rendered heights *(measured)*: `alert` 747.42 · `toast` 959.80 · `skeleton` 912.30 · `progress`
1188.53 · `empty` 460.11 · `api` 319.30 · `rules` 253.80.

---

## 1 · Page header (`PageHeader`)

1. Eyebrow `type-label text-action-ink` → **"Base Components · Base"** *(measured)* — the same double-"Base" as
   every base page (`forms-map.md` drift 1). Separator **U+00B7**. Render it as written.
2. `type-h1 mt-4` → **"Feedback"**.
3. `type-lead mt-4 max-w-2xl` → **"Telling the user what happened or what is happening: alerts, toasts, skeletons,
   progress and empty states."** (`nav.ts:240–241`; no em dash, one colon).
4. Chips `ul.mt-7 flex flex-wrap gap-2`, each `type-chip rounded-pill border border-border bg-card px-3 py-1.5
   text-muted-foreground`, from `category.contents` (`nav.ts:242–250`). Verbatim, in order *(measured)*:
   **Alert · Toast · Skeleton · Progress · Progress tones · Spinner · Empty**
   Seven chips, `<li>`, not links.

**The chips do not match the sections.** There are seven chips and five content sections (`alert`, `toast`,
`skeleton`, `progress`, `empty`) plus `api` and `rules`. "Progress tones" and "Spinner" are **Panel labels inside
the `progress` section**, not sections; "Progress" is the section titled **"Progress & Spinner"**. See §16 drift 1.

The Flutter nav registry already carries all seven byte-for-byte (`example\lib\nav.dart:305–319`).

---

## 2 · Section inventory (verbatim)

Seven `Section`s, `PageFootNav` last. Shell: `<section id class="mb-20">`; `<h2 class="type-h3">`; description
`type-small mt-2 max-w-2xl`.

| # | `id` | title | description (verbatim) |
|---|---|---|---|
| 1 | `alert` | **Alert** | Five variants. Stock shadcn only ships default and destructive, so success, warning and information were added to cover the states the brief requires. |
| 2 | `toast` | **Toast** | Transient confirmation, bottom-right. Never used for errors that require a decision — those get an Alert or a Dialog, because a toast disappears. |
| 3 | `skeleton` | **Skeleton** | A skeleton must match the footprint of what it replaces. A generic grey rectangle where a pack card will appear causes a layout jump, which is worse than a spinner. |
| 4 | `progress` | **Progress & Spinner** | Progress when the total is known — pack supply, XP toward the next rank, a reveal sequence. Spinner when it is not. |
| 5 | `empty` | **Empty states** | An empty state must explain why it is empty and give one clear way out. A blank panel with 'No results' is an unfinished screen. |
| 6 | `api` | **API** | *(none)* |
| 7 | `rules` | **Rules** | *(none)* |

§5's description contains **straight** single quotes around `'No results'` (`page.tsx:420`); §2's dash is **U+2014**;
§4's is **U+2014**. §1 uses no dash.

Per-section children, in DOM order:

| § | children |
|---|---|
| — | **`Note tone="action" title="Which one to reach for" className="mb-12"`** — page level, before §1 |
| 1 | `Panel label="All five variants"` → `div.space-y-4` (5 `Alert`s) · `Note tone="action" title="One surface, five meanings" className="mt-6"` — **both inside the Panel** |
| 2 | `Panel label="All five, side by side"` → `ToastPreviewStack` (5 `ToastPreview`) · `p.type-small.mt-6` · `p.type-small.mt-3` — · `Panel label="Click to fire a real one" className="mt-4"` → `Row` (5 Buttons) · `p.type-small.mt-5` |
| 3 | `div.grid.gap-4.lg:grid-cols-2` → `Panel "Pack card skeleton"` + `Panel "Live pull row skeleton"` · `Panel "Inline placeholders" mt-4` → `Row` (one `p.type-body`) + **`Meta` with no margin** · `Note tone="error" title="The common mistake" mt-4` |
| 4 | `Panel "Progress"` → `div.max-w-md.space-y-8` (3 rows) + `p.type-small.mt-6` + `Note mt-4` · `Panel "Tone — the shape of the reading, not its direction" mt-4` → `div.max-w-md.space-y-8` (4 rows) + `p.type-small.mt-6` + `Note tone="error" mt-4` · `Panel "Spinner" mt-4` → `Row` (3 spinners + 2 loading Buttons) + `p.type-small.mt-5` |
| 5 | `div.grid.gap-4.lg:grid-cols-2` → 2 Panels · `p.type-small.mt-4` |
| 6 | `Meta` (6 items) |
| 7 | `DoDont` (5 dos, 5 don'ts) |

**§1 is the only section whose `Note` lives inside the Panel** (`page.tsx:143–151`); every other Note on the page is
a sibling of its Panel. §4's Panel-2 Note is also inside the Panel. This changes the Note's width: **1030px** inside
a Panel, **1080px** outside *(measured — the §3 error Note is 1080, the §1 Note is 1030)*.

Panel label punctuation: §4's second label uses **U+2014** `—`.

---

## 3 · Alert — anatomy, and the four things the port left out

### 3.1 · The class list, verbatim (`alert.tsx:24`)

```
group/alert relative grid w-full gap-1 overflow-hidden rounded-lg border border-border bg-card
px-4 py-3.5 text-left text-sm text-card-foreground feedback-surface
has-data-[slot=alert-action]:pr-20
has-[>svg]:grid-cols-[auto_1fr] has-[>svg]:gap-x-3
*:[svg]:row-span-2 *:[svg]:translate-y-0.5 *:[svg:not([class*='size-'])]:size-4
```

Note `relative` in the base — the utility deliberately does **not** set `position` (`globals.css:1709–1714`), the
component does, because `AlertAction` needs a containing block.

| property | class | rendered *(measured)* |
|---|---|---|
| width | `w-full` | **1030px** |
| grid | `has-[>svg]:grid-cols-[auto_1fr]` | **`16px 968px`** without an action; **`16px 904px`** with |
| gaps | `gap-1` / `has-[>svg]:gap-x-3` | **4px** rows, **12px** columns |
| padding | `px-4 py-3.5` (+ `pr-20` with an action) | **`14px 16px`**; **`14px 80px 14px 16px`** with |
| radius / border / fill | `rounded-lg border border-border bg-card` | **12px**, 1px `#27272a`, `#18181b` |
| text | `text-sm text-card-foreground text-left` | **13px / 18.5714px (1.428571) / `#fafafa`** |
| icon | `*:[svg]:row-span-2` + `translate-y-0.5` + `size-4` | col 1 spanning both rows, `translate: 0px 2px` (**not** `transform`), **16×16**, `strokeWidth` **2.4** |
| `AlertTitle` | `font-medium group-has-[>svg]/alert:col-start-2` | **13 / 500 / 18.5714 / `#fafafa`** |
| `AlertDescription` | `text-sm text-balance text-muted-foreground md:text-pretty` | **13 / 18.5714 / `#d4d4d8`**, `text-wrap: **pretty**` at 1440 |
| `AlertAction` | `absolute top-2 right-2` | **8px / 8px**, holds a `Button variant="secondary" size="sm"` = **32px** tall |
| rendered height | — | **71.13px** for every one of the five (single-line title + single-line description) |
| stack gap | `div.space-y-4` | **16px** between alerts |
| role | `role="alert"` on the root | no `aria-live`, no `aria-atomic` |

The five variants change **exactly three declarations** each (`alert.tsx:32–52`) — the glyph colour and the two
bloom hues:

| variant | glyph class | rendered glyph *(measured)* | `--bloom-1` | `--bloom-2` | resolved *(measured)* |
|---|---|---|---|---|---|
| `default` | `text-muted-foreground` | `#d4d4d8` | `--color-action-bright` | `--color-action` | `#92c2fc` / `#1a6ef4` |
| `destructive` | `text-destructive-ink` | `#f87171` | `--destructive` | `--color-action` | `#dc2626` / `#1a6ef4` |
| `success` | `text-success-ink` | `#10b981` | `--color-success` | `--color-value` | `#10b981` / `#a3e635` |
| `warning` | `text-warning-ink` | `#fbbf24` | `--color-warning` | `--color-action` | `#fbbf24` / `#1a6ef4` |
| `info` | `text-info-ink` | `#22d3ee` | `--color-info` | `--color-action` | `#22d3ee` / `#1a6ef4` |

The `warning` pair carries the longest comment in the file (`alert.tsx:39–49`): it used to be
`--color-value-bright`/`--color-value-dark` and "worked only by accident", glowing purple once the value ramp moved
to amethyst. **The Alert was fixed; the toast was not.** See §16 drift 2 (the pinned drift).

### 3.2 · The five specimens, verbatim (`page.tsx:89–141`)

| # | variant | lucide icon | title | description | `AlertAction` |
|---|---|---|---|---|---|
| 1 | *(default)* | `Info` | **Provably fair** | Every pack roll is seeded and verifiable. The seed for this pack is published after opening. | — |
| 2 | `success` | `CheckCircle2` | **Deposit cleared** | $250.00 was added to your available balance. | — |
| 3 | `warning` | `Hourglass` | **Withdrawal under review** | Withdrawals over $1,000 are reviewed manually and usually clear within one business day. | `Button variant="secondary" size="sm"` → **Details** |
| 4 | `destructive` | `XCircle` | **Payment failed** | Your card was declined. No packs were opened and nothing was charged. | `Button variant="secondary" size="sm"` → **Retry** |
| 5 | `info` | `AlertTriangle` | **Purchase limit approaching** | You have used $840 of your $1,000 weekly limit. Limits are set in Preferences and exist to help you stay in control. | — |

All five: `<Icon size="md" tone="inherit"/>` → 16px, strokeWidth 2.4, `aria-hidden="true"`, colour inherited from
`*:[svg]:text-*-ink`. **DOM order is default · success · warning · destructive · info** — not the cva order.

**Specimen 5 pairs the `info` variant with the `AlertTriangle` glyph** and warning copy. See §16 drift 3.

### 3.3 · What phase 3 shipped, and the four in-file deferrals

`lib\src\components\ui\alert.dart` (217 lines) ships `AlertVariant` (`:48`, five members, `normal` for `default`
because `default` is a Dart keyword), `inkOf` (`:81–87`), `Alert` (`:92`) with `title` / `description` / `icon` /
`variant`, radius `Radii.lg` (`:120`), row gap `el(1)` (`:129`), icon nudge `el(0.5)` (`:146`), icon gap `el(3)`
(`:153`), padding `16/14` (`:161`), hairline border (`:197`), border-box correction (`:203`), per-variant bloom
dispatch (`:165–191`), and `Semantics(container: true, liveRegion: true)` (`:208–213`).

The deferral record, **verbatim** (`alert.dart:27–36`):

> Scope, per supervisor ruling F1: the fidelity the forms page renders. The bloom is mounted **static** — see
> `BloomCosmic`, which records why the two infinite drifts and the starfield wait for the `feedback` page.
>
> Not ported, and recorded rather than guessed:
>  * `AlertAction` (`absolute top-2 right-2`, with `has-data-[slot=alert-action]:pr-20`) — no call site on this page;
>  * `text-balance` → `md:text-pretty` on the description. Flutter's line breaker has neither mode, so the
>    description wraps greedily. The reference's balanced last line is unreachable, not skipped.

And the warning-variant pointer (`alert.dart:66–70`), verbatim:

> The pair carries the longest comment in `alert.tsx`: it used to be the value ramp's two ends and *"worked only by
> accident"*, glowing purple under an amber glyph once the value ramp moved. The toast never got the fix — see
> `BloomCosmic.toastWarning`.

**Build scope for this page, from that record:**

| # | deferred | this page needs it because |
|---|---|---|
| A1 | `AlertAction` + `pr-20` | specimens 3 and 4 render it — 8/8 offset, 32px `secondary sm` Button, and the **80px** right padding that reserves its lane *(measured)* |
| A2 | `text-balance` / `md:text-pretty` | five descriptions, all `text-wrap: pretty` at 1440. See §17 Q3 |
| A3 | the starfield | §5 |
| A4 | the bloom's drifts + hover | §4.5 |

---

## 4 · `feedback-surface` — the full spec

`@utility feedback-surface` (`globals.css:1663–1847`). Two pseudo-element layers, painted on the **padding box**, both
`pointer-events: none`, `z-index: 0`, under `& > * { z-index: 1 }`.

### 4.1 · Structural declarations

```
overflow: hidden;          /* globals.css:1701 — the utility supplies the clip */
isolation: isolate;        /* :1707 — the screen blend must not reach the page under the card */
& > * { z-index: 1 }       /* :1712 — grid/flex items honour z-index unpositioned */
```

**`position` is deliberately NOT set** (`:1709–1711`): setting it would drop sonner's absolutely-positioned live
toast out of the stack it lays out. The Alert sets `relative` itself; the preview toast gets it from
`.cn-toast:not([data-sonner-toast])` (`globals.css:2658–2660`).

### 4.2 · Layer geometry — CSS, and what it resolves to

Held in four variables so the `.cn-toast` reclaim can restate them without repeating numbers
(`globals.css:1670–1673`):

```
--bloom-deep-inset: -95% -4.5rem -95% auto;   --bloom-deep-width: min(95%, 26rem);
--bloom-near-inset: -80% -3.5rem -80% auto;   --bloom-near-width: min(86%, 21rem);
```

| | `::before` (deep) | `::after` (near) |
|---|---|---|
| inset | `-95% -72px -95% auto` | `-80% -56px -80% auto` |
| width | `min(95%, 416px)` | `min(86%, 336px)` |
| height | **`auto`** — load-bearing, `:1732–1738` | **`auto`** — `:1769–1773` |
| blur | `blur(calc(--spacing * 4))` = **16px** | `blur(calc(--spacing * 2.5))` = **10px** |
| transform-origin | **88% 82%** | **90% 86%** |
| blend | `screen` (dark) / `multiply` (light) | same |
| opacity | **0.75** dark / **0.34** light | same |
| mask | — | `radial-gradient(78% 108% at 96% 78%, black 0%, black 28%, transparent 84%)` |
| drift | `cosmic-drift-deep 18s --ease-in-out infinite alternate` | `cosmic-drift-near 11s --ease-in-out infinite alternate` |

The explicit `height: auto` exists **only** to beat sonner, which pins a fixed `height` on both pseudos under
`[data-swiping]` and `[data-expanded]` (`sonner/dist/styles.css:279–286`, `:341–343`). Our selector outranks its
only for properties we declare.

**Derived, on this page** *(measured)*:

| host | padding box | deep width | near width | which cap bites |
|---|---|---|---|---|
| Alert | **1028 × 69.125** | `min(976.6, 416)` = **416** | `min(884.1, 336)` = **336** | **both caps** |
| Toast | **354 × 51.5…94.5** | `min(336.3, 416)` = **336.3** | `min(304.4, 336)` = **304.44** *(measured on the live toast)* | **neither** |

That is the entire point of the caps (`globals.css:1724–1729`): the corner light is roughly the same physical size
on a 356px toast and a 742px alert. **A port that uses a bare 95%/86% will flood the Alert.**

Measured layer boxes on the default Alert *(measured)*:
`::before` inset `-65.66px / -72px / -65.66px / left:684px`, `416 × 200.44`, origin `366.08px 164.36px`
(= 88% × 416, 82% × 200.44).
`::after` inset `-55.30px / -56px / -55.30px / left:748px`, `336 × 179.72`, origin `302.4px 154.56px`
(= 90% × 336, 86% × 179.72).

### 4.3 · The colour derivation

```
--bloom-core: oklch(from var(--bloom-2) calc(l * var(--bloom-l)) calc(c * var(--bloom-c)) h)
--bloom-glow: oklch(from var(--bloom-1) calc(l * var(--bloom-l)) calc(c * var(--bloom-c)) h)
--bloom-hot:  oklch(from var(--bloom-core) calc(l + (1 - l) * var(--bloom-lift)) calc(c * var(--bloom-hot-c)) h)
```

Declared **inside the utility**, not at `:root` (`globals.css:1678–1683`) — custom properties substitute on the
element the declaration sits on, and `--bloom-1/-2` only exist on the host.

| var | light (`globals.css:699–715`) | dark (`:885–898`) |
|---|---|---|
| `--bloom-void` | `white` | `black` |
| `--bloom-l` | **0.6** | **1** |
| `--bloom-c` | **1.55** | **1** |
| `--bloom-lift` | **0** | **0.85** |
| `--bloom-hot-c` | **1** | **0.5** |
| blend | `multiply` (`:3239`) | `screen` (`:3285`) |
| opacity | **0.34** (`:3281`) | **0.75** (`:3286`) |
| `--star-glow` | `color-mix(in oklab, var(--bloom-2) 85%, transparent)` | `rgb(255 255 255 / 0.5)` |
| `--star-glow-size` | **3px** | **2px** |

**The ramps end on `--bloom-void`, never on `transparent`** — white is `multiply`'s identity and black is
`screen`'s, so the light fades to the colour its blend cannot see. Already transcribed correctly in the port
(`feedback_surface.dart:27–33`).

### 4.4 · The gradient stacks

`::before`, two radials (`globals.css:1747–1758`), CSS paints the first-listed on top:

```
1. radial-gradient(48% 58% at 74% 86%, --bloom-core 0%,
                   color-mix(in oklab, --bloom-core 45%, --bloom-void) 54%, --bloom-void 84%)
2. radial-gradient(44% 54% at 94% 40%,
                   color-mix(in oklab, --bloom-glow 60%, --bloom-core) 0%, --bloom-void 78%)
```

`::after`, three radials (`:1781–1807`):

```
1. radial-gradient(42% 56% at 92% 84%, color-mix(--bloom-glow 35%, --bloom-hot) 0%, --bloom-glow 28%,
                   color-mix(--bloom-glow 45%, --bloom-void) 56%, --bloom-void 82%)   ← the hot core
2. radial-gradient(44% 52% at 64% 12%, color-mix(--bloom-core 60%, --bloom-hot) 0%, --bloom-core 34%,
                   --bloom-void 82%)                                                   ← the companion
3. radial-gradient(46% 58% at 84% 46%, color-mix(--bloom-glow 50%, --bloom-core) 0%,
                   color-mix(--bloom-core 50%, --bloom-void) 52%, --bloom-void 82%)    ← the bridge
```

All `color-mix` are `in oklab`. The port already paints all five ramps with the right stops
(`feedback_surface.dart:393–430`, `:434–514`) inside a nested `saveLayer` for the mask.

### 4.5 · The four infinite drifts + hover — DEFERRED, and this page's real scope

`@keyframes` verbatim (`globals.css:1864–1877`):

```
cosmic-drift-deep {   0% translate3d(0,0,0)      rotate(0deg)  scale(1)
                     50% translate3d(-11%, 8%,0) rotate(7deg)  scale(1.2)
                    100% translate3d(6%, -9%,0)  rotate(-5deg) scale(1.08) }

cosmic-drift-near {   0% translate3d(0,0,0)      rotate(0deg)  scale(1.04)
                     35% translate3d(-3%,-2%,0)  rotate(-9deg) scale(1.18)
                     70% translate3d(3%, 2%,0)   rotate(6deg)  scale(1)
                    100% translate3d(-2%, 1%,0)  rotate(-4deg) scale(1.14) }
```

Both `--ease-in-out` `cubic-bezier(.65,0,.35,1)`, `infinite alternate`. **18s and 11s are coprime-ish on purpose**
(`:1859–1860`): the pair takes minutes to return to the same arrangement.

Hover (`globals.css:1836–1846`):

```
&::before, &::after { scale: 1; transition: scale var(--duration-bloom) var(--ease-out) }
&:hover::before { scale: 2.2 }
&:hover::after  { scale: 2.5 }
```

**The standalone `scale` property, never `transform`** (`:1826–1830`): both layers are running a `transform`
animation and an animation beats a plain declaration, so `transform: scale()` would be ignored outright. In Flutter
this is a composition problem, not a cascade one — the drift and the swell must multiply into one matrix
(§17 Q1). Confirmed at rest *(measured)*: `scale: 1`, `transition: scale 1s cubic-bezier(0.22,1,0.36,1)`.

The port's deferral, **verbatim** (`feedback_surface.dart:45–58`):

> **Static.** The reference runs `cosmic-drift-deep 18s` and `cosmic-drift-near 11s`, both `infinite alternate`,
> plus a hover `scale` over `--duration-bloom`. Neither is ported here: RULES §4 rations perpetual motion, an Alert
> on a form is not the live indicator, and the four animations are properly the `feedback` page's subject. What
> renders is the element's own resting style — the frame a `prefers-reduced-motion` browser settles on, since both
> animations declare no `animation-fill-mode` and so revert rather than hold.
>
> FOLLOW-UP, recorded rather than fixed:
>  * the drift animations and the hover scale, with the `feedback` page;
>  * `.starfield` — thirteen hand-placed sparkles and two more infinite sways, carried by an `alert-stars` span in
>    the reference and by `[data-content]` on a toast. Same argument, same page.

"the four animations" = deep 18s + near 11s + the two starfield sways; the hover scale is a fifth item.

And the theme-variable follow-up (`feedback_surface.dart:71–78`), verbatim:

> `--bloom-void` / `--bloom-l` / `--bloom-c` / `--bloom-lift` / `--bloom-hot-c` are declared in the two theme blocks
> (globals.css L680–715 light, L885–898 dark) beside every other token — but `ThemeData` does not carry them yet
> and `foundation/theme.dart` is not this task's file. They live here, next to the only effect that reads them,
> until that file is next opened.
>
> FOLLOW-UP: move these five onto `ThemeData` and delete `_BloomInk.of`.

**Because the resting frame is `0%` of both keyframes** (`translate3d(0,0,0) rotate(0) scale(1)` /
`scale(1.04)`), the static bloom already shipped is exactly the `t=0` frame of the deep layer and the `t=0` frame of
the near layer. Animating is additive: no repaint of the ramps is needed, only a `Matrix4` around each layer.

---

## 5 · The starfield — 13 hand-placed sparkles, two sways

`globals.css:3364–3488`. Two corner-anchored clusters, **anchored not tiled** (`:3371–3377`) so a 70px toast and a
742px alert render the same thing.

### 5.1 · Where it hangs

| host | box | why |
|---|---|---|
| Alert | `<span data-slot="alert-stars" class="starfield" aria-hidden/>` (`alert.tsx:85`) | the bloom owns both of the root's pseudos; `position: absolute` keeps the span out of grid flow so `grid-cols-[auto_1fr]` never counts it (`alert.tsx:74–84`) |
| Toast (live **and** preview) | `.feedback-surface [data-content]::before/::after` — **descendant, not child** (`:3403–3406`) | sonner owns the live markup and may wrap `[data-content]`; a `>` combinator would work on the preview and silently do nothing live |

**Measured catch:** `[data-content]` is **not positioned**, so the pseudos' `inset: 0` resolves against
`.cn-toast` — the sparkle box is the **whole toast padding box**, not the text column. Confirmed: `transform-origin`
on the default preview's `[data-content]::before` = **`354px 51.5px`** = the toast's full padding box, while
`[data-content]` itself is only 122.08px wide. The port must anchor the starfield to the **toast**, not to its
text column.

### 5.2 · Shared declarations (`:3408–3430`)

```
content:""; position:absolute; inset:0; pointer-events:none; background-repeat:no-repeat;
filter: drop-shadow(0 0 var(--star-glow-size) var(--star-glow))
        drop-shadow(0 0 calc(var(--star-glow-size)*3) var(--star-glow));
transition: translate var(--duration-bloom) var(--ease-out),
            scale     var(--duration-bloom) var(--ease-out);
```

`drop-shadow`, **not** `box-shadow` (`:3418–3423`): the sparkles are alpha in a background image, so a box shadow
would trace the rectangle. Two passes — tight = the star's own light, wide = that light reaching the surface.
Rendered dark *(measured)*: `drop-shadow(rgba(255,255,255,0.5) 0 0 2px) drop-shadow(rgba(255,255,255,0.5) 0 0 6px)`.

| | `::before` (dense bottom-right) | `::after` (thin top-right) |
|---|---|---|
| background-position | `right bottom` | `right top` |
| background-size | **260px 96px** | **200px 64px** |
| transform-origin | `100% 100%` → **1028px 69.125px** on the Alert *(measured)* | `100% 0%` → **1028px 0px** *(measured)* |
| animation | `star-sway 44s --ease-in-out infinite alternate` | `star-sway-alt 33s --ease-in-out infinite alternate` |
| hover | `translate: -5px 3px; scale: 1.06` | `translate: -3px -2px; scale: 1.04` |

```
@keyframes star-sway     { from { rotate: -6deg } to { rotate:  6deg } }
@keyframes star-sway-alt { from { rotate:  5deg } to { rotate: -5deg } }
```

**The sway animates the `rotate` longhand; the hover animates `translate` and `scale`** (`:3387–3391`) — three
independent properties in modern CSS, so an element can be mid-rotation and mid-nudge at once. Written as one
`transform` they would overwrite each other and the hover would kill the sway. Same composition problem as §4.5.

Origin is the anchored corner, and ±6° is an oscillation not a revolution (`:3393–3395`) — a full turn would swing
the cluster out of the box for half its cycle.

**One starfield, both themes** (`:3466–3471`): the fill is a literal `#ffffff` in both. What changes is
`--star-glow` / `--star-glow-size`.

### 5.3 · The 13 sparkles, transcribed

The glyph is one 24×24 four-point star, repeated with a `transform`:

```
M12 0C12 6.6 17.4 12 24 12C17.4 12 12 17.4 12 24C12 17.4 6.6 12 0 12C6.6 12 12 6.6 12 0Z
```

Four cubic segments, closed; control points at 6.6/17.4 give the concave waist. Each instance is
`transform="translate(x,y) scale(s)"`, so it occupies a **`24s × 24s`** box with its top-left at `(x, y)` in tile
coordinates, and `fill="#ffffff"` with a per-instance `opacity`.

**Cluster A — `::before`, `viewBox="0 0 260 96"`, 8 sparkles** (`globals.css:3474`):

| # | opacity | translate | scale | box (px) | top-left |
|---|---|---|---|---|---|
| 1 | **0.95** | 214, 54 | 0.46 | 11.04 | (214, 54) |
| 2 | 0.78 | 240, 24 | 0.26 | 6.24 | (240, 24) |
| 3 | 0.85 | 180, 76 | 0.32 | 7.68 | (180, 76) |
| 4 | 0.66 | 248, 72 | 0.20 | 4.80 | (248, 72) |
| 5 | 0.55 | 196, 16 | 0.18 | 4.32 | (196, 16) |
| 6 | 0.58 | 146, 40 | 0.22 | 5.28 | (146, 40) |
| 7 | 0.50 | 232, 92 | 0.16 | 3.84 | (232, 92) |
| 8 | 0.42 | 112, 66 | 0.15 | 3.60 | (112, 66) |

**Cluster B — `::after`, `viewBox="0 0 200 64"`, 5 sparkles** (`globals.css:3478`):

| # | opacity | translate | scale | box (px) | top-left |
|---|---|---|---|---|---|
| 1 | 0.78 | 168, 18 | 0.24 | 5.76 | (168, 18) |
| 2 | 0.55 | 132, 42 | 0.17 | 4.08 | (132, 42) |
| 3 | 0.60 | 190, 46 | 0.18 | 4.32 | (190, 46) |
| 4 | 0.42 | 96, 14 | 0.13 | 3.12 | (96, 14) |
| 5 | 0.38 | 150, 60 | 0.12 | 2.88 | (150, 60) |

**8 + 5 = 13.** Sizes run 2.88px to 11.04px; opacities 0.38 to 0.95.

**Tile placement, derived.** `background-position: right bottom` puts the 260×96 tile's right edge on the box's
right edge and its bottom on the box's bottom, `no-repeat`. On the 1028×69.125 Alert padding box the tile origin
is therefore `(768, −26.875)` — **the top 26.875px of cluster A is clipped**, which removes sparkle 5 entirely
(tile-y 16–20.32) and leaves only 3.37px of sparkle 2 (24–30.24). On the 354-wide toast the origin is `(94, h−96)`;
at h = 51.5 that is `(94, −44.5)`, clipping the top 44.5px — sparkles 2 and 5 go entirely, sparkle 6 keeps 0.78px,
and 1 · 3 · 4 · 7 · 8 all survive. Cluster B's tile origin is `(right−200, 0)`, never clipped vertically.
Horizontally nothing is ever clipped: cluster A's sparkles span tile-x 112–252 inside a 260px tile, and both hosts
are wider than 260.

*(This clipping is the reason the "anchored, not tiled" note exists. The port must clip, not rescale — rescaling
would change which sparkles are visible.)*

---

## 6 · Toast

### 6.1 · The two mounts

| | live | preview |
|---|---|---|
| markup | sonner builds it | `toast-preview.tsx:32–47` builds the identical tree **minus `data-sonner-toast`** |
| element | `<li>` inside `[data-sonner-toaster]` | `<li>` inside `ul.flex.list-none.flex-col.gap-4` |
| classes | `cn-toast feedback-surface` (`sonner.tsx:55`) | `cn-toast feedback-surface` (`toast-preview.tsx:32`) |
| `data-type` | set by sonner | set by the preview |
| positioning | sonner's `position:absolute` + transforms | `.cn-toast:not([data-sonner-toast]) { position: relative }` |

The page claims (`page.tsx:184–191`) they differ only by that attribute. **Measured, they do not.** See §16 drift 4.

### 6.2 · `.cn-toast` — the block, verbatim geometry

`globals.css:2584–2604`, selector written **three times** (`.cn-toast.cn-toast.cn-toast`, specificity 0,3,0) because
sonner's `[data-sonner-toast][data-styled='true']` is 0,2,0 and, crucially, **sonner's stylesheet is injected
unlayered at runtime while `@utility` output lands in Tailwind's `utilities` layer — unlayered beats layered
whatever the specificity** (`:2629–2635`).

| declaration | value *(measured)* |
|---|---|
| `display: flex; align-items: flex-start` | ✓ |
| `gap: calc(--spacing * 3)` | **12px** |
| `width: var(--width, 22.25rem)` | **356px** |
| `padding: calc(--spacing * 4)` | **16px** |
| `border: 1px solid var(--border)` | `#27272a` |
| `border-radius: var(--radius-lg)` | **12px** |
| `background-color: var(--popover)` | `#18181b` — **`background-color`, not the shorthand** (`:2592–2595`) |
| `box-shadow: var(--shadow-e3)` | `0 2px 4px #00000080, 0 14px 28px -8px #0009` |
| `color: var(--popover-foreground)` | `#fafafa` |
| `font-size: var(--text-small)` / `line-height: 1.5` | **13px / 19.5px** |
| `overflow: hidden` | the bloom's clip |

Children (`:2721–2812`):

| slot | declarations | rendered *(measured)* |
|---|---|---|
| `[data-icon]` | `display:flex; flex-shrink:0; margin-top: calc(--spacing*0.5); color: --muted-foreground` | **2px** nudge; glyph 16×16, lucide default **strokeWidth 2** |
| `[data-content]` | `flex column; gap: calc(--spacing*1); min-width:0` | **4px** |
| `[data-title]` | `font-size:--text-small; font-weight:500; color:--foreground` | **13 / 500 / `#fafafa` / lh 19.5** |
| `[data-description]` | `font-size:--text-small; color:--muted-foreground` | **13 / `#d4d4d8`** — **no `line-height` declared**, see §16 drift 4 |
| `[data-button]` | `flex-shrink:0; margin-left:auto; height: calc(--spacing*8); padding-inline: calc(--spacing*3.5); border:1px solid transparent; border-radius:--radius-pill; background:--secondary; box-shadow:none; color:--secondary-foreground; font-size:--text-small; font-weight:500; transition: background-color --duration-base --ease-out` | **32px tall, 14px inline, 999px, `#27272a` → hover `#3f3f46` (`--accent`), `#fafafa`, 13/500, 250ms `ease-out`** |

`[data-button]` mirrors `variant="secondary" size="sm"` by hand because sonner renders the button itself
(`:2790–2795`) — **secondary, not outline**, because a bordered transparent control over moving light reads as a
hole.

**Per-type hues** (`:2665–2684`) and **per-type glyph ink** (`:2756–2770`):

| `data-type` | glyph (`sonner.tsx:18–24`) | ink | `--bloom-1` | `--bloom-2` | resolved *(measured)* |
|---|---|---|---|---|---|
| *(default)* | none | `--muted-foreground` `#d4d4d8` | `--color-action-bright` | `--color-action` | `#92c2fc` / `#1a6ef4` |
| `success` | `CircleCheckIcon` | `--success-ink` `#10b981` | `--color-success` | `--color-value` | `#10b981` / `#a3e635` |
| `warning` | `TriangleAlertIcon` | `--warning-ink` `#fbbf24` | **`--color-value-bright`** | **`--color-value-dark`** | **`#d9f99d` / `#4d7c0f`** |
| `error` | `OctagonXIcon` | `--destructive-ink` `#f87171` | `--destructive` | `--color-action` | `#dc2626` / `#1a6ef4` |
| `info` | `InfoIcon` | `--info-ink` `#22d3ee` | `--color-info` | `--color-action` | `#22d3ee` / `#1a6ef4` |
| `loading` | `Loader2Icon` + `anim-spin` | `--action-ink` `#92c2fc` | `--color-action-bright` | `--color-value` | `#92c2fc` / `#a3e635` |

**The pinned drift, confirmed in the browser:** a **warning toast** blooms `#d9f99d`/`#4d7c0f` — pale lime over dark
olive — under a `#fbbf24` amber glyph, while a **warning Alert** blooms `#fbbf24`/`#1a6ef4`. The toast still carries
the pair the Alert was moved off. **Both ship as written.** The port already records it at
`feedback_surface.dart:274–277` and dispatches `BloomCosmic.toastWarning`.

The bloom reclaim (`globals.css:2642–2651`) restates only inset/width/height on both pseudos, from the same four
variables — verified working: on a live `data-expanded="true"` toast the near layer measured **304.438px wide** with
inset `-73.5px -56px -73.5px 105.562px`, i.e. our rule, not sonner's 15px strip *(measured)*.

### 6.3 · Sonner's enter/exit choreography — transcribed

**Source: `node_modules\sonner\dist\styles.css`. It is not in `globals.css` and is not in any prior map.**
Runtime constants from `node_modules\sonner\dist\index.mjs:411–425`.

#### 6.3.1 · Constants

| constant | value | `index.mjs` |
|---|---|---|
| `VISIBLE_TOASTS_AMOUNT` | **3** | `:411` |
| `VIEWPORT_OFFSET` | **`'24px'`** | `:413` |
| `MOBILE_VIEWPORT_OFFSET` | `'16px'` | `:415` |
| `TOAST_LIFETIME` | **4000** | `:417` |
| `TOAST_WIDTH` | **356** | `:419` |
| `GAP` | **14** | `:421` |
| `SWIPE_THRESHOLD` | **45** | `:423` |
| `TIME_BEFORE_UNMOUNT` | **200** | `:425` |

Container *(measured on the live toaster)*: `position: fixed; right: 24px; bottom: 24px; width: 356px;
z-index: 999999999; transition: transform 400ms ease; list-style: none; padding: 0; margin: 0`. Data attributes
`data-sonner-theme="dark"`, `data-x-position="right"`, `data-y-position="bottom"`.

#### 6.3.2 · Per-toast custom properties (written by JS, `index.mjs:669–673`)

```
--index            = index                      (0 = newest = front)
--toasts-before    = index
--z-index          = toasts.length - index
--offset           = heightIndex * gap + sum(heights of toasts before)   px
--initial-height   = measured height             px
--lift             = -1 (bottom) | +1 (top)
--lift-amount      = calc(--lift * --gap)
--front-toast-height = heights[0].height         (on the container, :1103)
```

*(measured, three stacked)*: front `--offset: 0px`, `--initial-height: 53.5px`, `--z-index: 3`; second
`--offset: 67.5px` (= 1×14 + 53.5), `--z-index: 2`; third `--offset: 175.375px` (= 2×14 + 53.5 + 93.875),
`--z-index: 1`.

#### 6.3.3 · The state machine (`styles.css`)

| state | `--y` | opacity | height | transition |
|---|---|---|---|---|
| base `[data-sonner-toast]` (`:81–93`) | `translateY(100%)` | **0** | — | `transform 400ms, opacity 400ms, height 400ms, box-shadow 200ms` — **no easing named → CSS `ease`** = `cubic-bezier(.25,.1,.25,1)` |
| bottom (`:120–125`) | `translateY(100%)`, `--lift: -1` | | | |
| **enter** `[data-mounted=true]` (`:288–291`) | **`translateY(0)`** | **1** | — | ↑ |
| stacked, collapsed `[data-expanded=false][data-front=false]` (`:293–297`) | `translateY(--lift-amount × n) scale(1 − 0.05n)` | — | `--front-toast-height` | ↑ |
| …its children (`:311–313`) | — | **0** (`> * { transition: opacity 400ms }`, `:299`) | — | |
| **expanded** `[data-mounted][data-expanded=true]` (`:320–323`) | `translateY(--lift × --offset)` | 1 | `--initial-height` | ↑ |
| **exit, front** `[data-removed][data-front=true][data-swipe-out=false]` (`:325–328`) | `translateY(--lift × -100%)` → **`translateY(100%)`** at bottom | **0** | — | ↑ |
| exit, back, expanded (`:330–333`) | `translateY(--lift×--offset + --lift×-100%)` | 0 | — | ↑ |
| exit, back, collapsed (`:335–339`) | **`translateY(40%)`** | 0 | — | **`transform 500ms, opacity 200ms`** |
| `[data-visible=false]` (`:315–318`) | — | 0 | — | `pointer-events: none` |
| swiping (`:345–348`) | `--y translateY(--swipe-amount-y) translateX(--swipe-amount-x)` | — | — | **`none`** |
| swipe-out (`:354–375`) | `swipe-out-{left,right,up,down}` | → 0 | — | **`200ms ease-out forwards`** |

**The scale trick.** `--scale: var(--toasts-before) * 0.05 + 1` then `scale(calc(-1 * var(--scale)))` — custom
property substitution is **textual**, so it expands to `calc(-1 * n * 0.05 + 1)` = **`1 − 0.05n`**, not a negative
scale. Verified *(measured)*: the second toast's computed `--y` is
`translateY(calc(calc(-1 * 14px) * 1)) scale(calc(-1 * 1 * 0.05 + 1))` → 0.95; the third → 0.90.

Swipe-out keyframes (`:377–423`), all `from { transform: var(--y) translateX/Y(--swipe-amount-*); opacity: 1 }`,
`to { … ±100%; opacity: 0 }`.

`@media (prefers-reduced-motion)` (`:703–710`): `[data-sonner-toast], [data-sonner-toast] > *, .sonner-loading-bar
{ transition: none !important; animation: none !important }`.

#### 6.3.4 · The lifecycle (`index.mjs`)

1. `useEffect(() => setMounted(true), [])` (`:506–509`) — one frame after mount, `data-mounted="true"` flips and the
   400ms `translateY(100%) → 0` + `opacity 0 → 1` runs. **There is no `@keyframes` entrance**; the comment says
   *"Trigger enter animation without using CSS animation"*.
2. Height measured with `getBoundingClientRect()` and pushed to `heights` (`:510–529`); the row is removed on
   unmount.
3. Timer (`:580–617`): `startTimer` sets a `setTimeout(remainingTime)`; **`pauseTimer` subtracts elapsed and stores
   the remainder** whenever `expanded || interacting || isDocumentHidden`. Hover-pause is therefore
   *resume-from-remainder*, not restart.
4. `deleteToast` (`:567–580`): `setRemoved(true)`, save `offsetBeforeRemove`, drop from `heights`, then
   `setTimeout(removeToast, 200)`.
5. `expanded` is container-level state: `onMouseEnter`/`onMouseMove` → `setExpanded(true)` (`:1128–1129`),
   `onMouseLeave`/`onDragEnd` → `false` (`:1133–1136`). `expand` prop defaults **false**, so the resting stack is
   collapsed.
6. Swipe: `onPointerDown` (`:682`), released at `|swipeAmount| >= 45 || velocity > 0.11` (`:705`).
7. `toast.promise` swaps `loading → success | error` in place; `[data-promise=true] [data-icon] > svg` gets
   `sonner-fade-in 300ms ease forwards` from `opacity:0 scale(.8)` (`styles.css:159–164`).

#### 6.3.5 · The port's deferral, verbatim

`lib\src\components\ui\toaster.dart:41–50`:

> Not ported, and recorded rather than guessed:
>  * sonner's own enter/exit choreography lives in its package stylesheet, not in `globals.css`, and is not
>    transcribed anywhere in the maps. A toast therefore arrives without motion and leaves over the 200ms unmount
>    window, which is the part of the contract this port can state honestly. The rest belongs with the `feedback`
>    page.
>  * swipe-to-dismiss (`SWIPE_THRESHOLD` 45) and hover-to-pause. A tap dismisses.
>  * `[data-button]` — the action pill. No call site on the forms page.
>  * the starfield on `[data-content]`. See `BloomCosmic`.

**§6.3 above is that transcription.** It is the single largest new fact this map contributes.

`toaster.dart:52–57` — the KNOWN GAP note:

> **KNOWN GAP — two glyphs.** `TOAST_ICONS` maps success to lucide's `CircleCheck` and error to `OctagonX`, and
> `IconGlyph` carries neither; `icon_paths.dart` is another task's file this wave. `ToastType.glyph` therefore
> answers `null` for those two and `Toast.glyph` overrides it, so a call site can supply the geometry the moment
> it lands. Everything else — the ink, the bloom, the anatomy — is complete.

**This note is now stale.** `IconGlyph.circleCheck` exists (`icon_paths.dart:186`, geometry `:1032–1035`) and
`IconGlyph.octagonX` exists (`:190`, geometry `:1041`). `ToastType.glyph` (`toaster.dart:138–143`) still returns
`null` for both and `test\selection_feedback_test.dart:866–887` still asserts `isNull`. Closing it is a two-line
edit plus a test flip.

---

## 7 · Skeleton

`skeleton.tsx` is 32 lines: `anim-shimmer rounded-md` + `inline-block` when `as="span"`.

`@utility anim-shimmer` (`globals.css:2344–2353`):

```
background: linear-gradient(90deg, var(--popover) 0%, var(--accent) 50%, var(--popover) 100%);
background-size: 200% 100%;
animation: pulls-shimmer 1.4s var(--ease-in-out) infinite;
@keyframes pulls-shimmer { from { background-position: 200% 0 } to { background-position: -200% 0 } }
```

*(measured)*: `linear-gradient(90deg, rgb(24,24,27) 0%, rgb(63,63,70) 50%, rgb(24,24,27) 100%)`, `200% 100%`,
`1.4s cubic-bezier(0.65,0,0.35,1) infinite`, `border-radius: 10px` (`rounded-md`).

**Every skeleton on the page** *(measured, in DOM order)*:

| panel | class | rendered |
|---|---|---|
| Pack card | `mb-4 h-32 w-full rounded-md` | 448 × 128, r10, 16 below |
| | `h-3 w-24` | 96 × 12, r10 |
| | `mt-2.5 h-4 w-40` | 160 × 16, r10, 10 above |
| | `h-5 w-20 rounded-pill` | 80 × 20, r999 |
| | `h-5 w-16 rounded-pill` | 64 × 20, r999 |
| | `mt-4 h-6 w-20` | 80 × 24, r10, 16 above |
| | `mt-4 h-10 w-full rounded-md` | 448 × 40, r10, 16 above |
| Pull row ×4 | `size-8 rounded-pill` | 32 × 32, r999 |
| | `h-3 w-20` | 80 × 12, r10 |
| | `mt-2 h-3.5 w-36` | 144 × 14, r10, 8 above |
| | `h-4 w-16` | 64 × 16, r10 |
| Inline | `as="span" h-3.5 w-28 align-middle` | 112 × 14, **`display: inline-block`**, `vertical-align: middle` |

**24 skeletons on the page** *(measured)* — all animating simultaneously.

Containers *(measured)*: card wrapper `rounded-lg border border-border bg-card p-4` → **482 × 348**, r12, 16px pad;
pull-row wrapper `space-y-px overflow-hidden rounded-lg border border-border` → **482 × 237**, r12, rows
`flex items-center gap-3 bg-card px-4 py-3` = **58px** tall, 12/16 padding, 12px gap, **1px** between rows (the
`space-y-px` gap showing `--background` through).

Inline-placeholder Panel: `Row` holds `p.type-body max-w-prose` → **15px / 24px lh / max-width 614.136px**
*(measured)*, and the `Meta` **sits flush against it — `margin-top: 0`, gap 0** *(measured)*. See §16 drift 5.

`Meta` rows (`page.tsx:313–318`): `Default` → "div — use for block placeholders"; `as="span"` → "inline-block, for
text placeholders". The key contains **escaped straight double quotes** (`as=\"span\"` in the JSX).

---

## 8 · Progress & Spinner

### 8.1 · `Progress`

Root (`progress.tsx:87`): `relative flex h-2.5 w-full items-center overflow-hidden rounded-pill border border-input
bg-muted shadow-pressed`.
Indicator (`:44`): `size-full flex-1 transition-transform duration-base ease-out` + tone, driven by
`style={{ transform: 'translateX(-' + (100 - value) + '%)' }}` (`:95`).

*(measured)*: **448 × 10**, radius **999**, border **1px `#3f3f46`** (`--input`), fill `#27272a` (`--muted`),
`shadow-pressed` = `inset 0 2px 5px rgba(0,0,0,.6), inset 0 1px 2px rgba(0,0,0,.75)`; indicator **446px** wide
(448 − 2 border), transition `transform 250ms cubic-bezier(0.22,1,0.36,1)`. Same 10px channel as the Slider track
(`progress.tsx:9–17`); stock shadcn ships `h-1`.

| tone | fill class | rendered *(measured)* | shadow |
|---|---|---|---|
| `default` | `bg-action-ink shadow-btn-primary` | `#92c2fc` | `btn-primary` (carries the `oklab(0.572642 −0.0367 −0.2124 / 0.55)` action glow) |
| `value` | `bg-value-ink shadow-btn-value` | `#d9f99d` | `btn-value` (`oklab(0.849313 −0.130016 0.161481 / 0.45)`) |
| `success` | `bg-success-ink shadow-btn` | `#10b981` | `btn` |
| `warning` | `bg-warning-ink shadow-btn` | `#fbbf24` | `btn` |
| `destructive` | `bg-destructive-ink shadow-btn` | `#f87171` | `btn` |

**Every fill is an `-ink` token**, never the raw hue — a 10px bar carries no foreground, so contrast with `--muted`
is all it has (`progress.tsx:19–41`, quoting 1.63:1 vs 6.97:1 on this page).

**Seven bars on the page** *(measured, `role="progressbar"`, `aria-valuenow` present on all)*:

| § | label row | readout | value | tone | `aria-label` |
|---|---|---|---|---|---|
| Panel 1 | Pack supply remaining | `412 / 2,000` | **20.6** | default | *(none)* |
| Panel 1 | XP to Rank 25 | `3,480 / 5,000` (`text-value-ink`) | **69.6** | **value** | "XP to Rank 25" |
| Panel 1 | Revealing cards | `4 of 6` | **66.7** | default | "Revealing cards" |
| Panel 2 | Steps today | `72%` | **72** | default | "Steps today" |
| Panel 2 | Hydration goal met | `100%` | **100** | success | "Hydration goal met" |
| Panel 2 | Storage used | `86%` | **86** | warning | "Storage used" |
| Panel 2 | Sleep against an 8h need | `67%` | **67** | destructive | "Sleep against an 8h need" |

Row anatomy: `div.max-w-md.space-y-8` → **448px, 32px between rows** *(measured)*; label row
`mb-2.5 flex items-baseline justify-between` → **10px below, baseline-aligned, space-between**, `type-label` left /
`type-num-sm` right. **The first bar is the only one with no `aria-label`** — see §16 drift 6.

`PROGRESS_TONES` (`page.tsx:55–60`) is `as const` with a preceding comment (`:52–54`) saying `default` and `value`
are shown above "so this row is the four that say something about the reading itself" — but the array's first entry
is `tone: "default"`. See §16 drift 7.

### 8.2 · Spinner

`Spinner` = `<Icon icon={Loader2Icon} data-slot="spinner" role="status" aria-label="Loading" className="size-4
anim-spin"/>` (`spinner.tsx:7`). `@utility anim-spin` = `animation: pulls-spin 0.9s linear infinite`
(`globals.css:2407–2409`); `@keyframes pulls-spin { to { transform: rotate(360deg) } }`. **Linear on purpose**
(`:2403–2406`).

**Six spinning glyphs on the page** *(measured)*:

| # | where | size | strokeWidth | colour | `aria-hidden` | `role` |
|---|---|---|---|---|---|---|
| 1 | loading `ToastPreview` icon | 16 | **2** (raw lucide) | `#92c2fc` | true | — |
| 2 | `<Spinner className="size-4"/>` | 16 | 2.4 | `#fafafa` | **true** | **null** |
| 3 | `<Spinner className="size-5"/>` | **20** | 2.4 | `#fafafa` | true | null |
| 4 | `<Spinner className="size-6 text-action-ink"/>` | **24** | 2.4 | `#92c2fc` | true | null |
| 5 | `<Button loading>Opening pack</Button>` | 16 | 2.4 | `#ffffff` | true | null |
| 6 | `<Button variant="premium" loading>Processing deposit</Button>` | 16 | 2.4 | `#121216` | true | null |

`size-5`/`size-6` **override `Icon`'s width/height attributes** but not its computed `strokeWidth`, which stays at
the `size="md"` value of 2.4 (`icon.tsx:82` computes from the *prop*, not the rendered box). So a 24px spinner is
drawn with a 16px-calibrated stroke. `role="status"`/`aria-label="Loading"` are **silently dropped** — `Icon`
destructures only `icon/size/tone/label/className` and spreads nothing (`icon.tsx:68–74`), so every spinner is
`aria-hidden="true"` *(measured, all six)*. Already recorded as `forms-map.md` drift 3 / ruling B9; the port carries
it at `spinner.dart:33–48`.

The two loading Buttons render at **40 × 144.41** and **40 × 178.45** *(measured)*, in a `Row` with 16px gap.

---

## 9 · Empty states

`Empty` (`empty.tsx:5–16`): `flex w-full min-w-0 flex-1 flex-col items-center justify-center gap-4 rounded-xl
border-dashed p-6 text-center text-balance`.

*(measured)*: **482 × 220.81**, padding **24**, gap **16**, radius **16px** (`rounded-xl`), `text-align: center`,
`text-wrap: balance`, `border-style: dashed`, **`border-width: 0px`**. `border-dashed` sets only the style;
**no width class is present, so the dashed border never paints.** See §16 drift 8.

| part | classes | rendered *(measured)* |
|---|---|---|
| `EmptyHeader` | `flex max-w-sm flex-col items-center gap-2` | **384px** wide, 8px gap |
| `EmptyMedia variant="icon"` | `mb-2 flex shrink-0 items-center justify-center` + `size-8 rounded-lg bg-muted text-foreground [&_svg:not([class*='size-'])]:size-4` | **32 × 32**, r**12**, `#27272a`, 8px below |
| ↳ glyph | `<Icon size="xl" tone="action"/>` / `tone="subtle"` | **`width`/`height` attributes are 24 but the CSS box is 16 × 16**, strokeWidth **2**, `#92c2fc` / `#d4d4d8` — see §16 drift 9 |
| `EmptyTitle` | `font-heading text-sm font-medium tracking-tight` | **13 / 500 / lh 18.5714 / letter-spacing −0.26px / "Inter Local"** |
| `EmptyDescription` | `text-sm/relaxed text-muted-foreground` | **13 / lh 21.125 (1.625) / `#d4d4d8`** |
| `EmptyContent` | `flex w-full max-w-sm min-w-0 flex-col items-center gap-2.5 text-sm text-balance` | **384px**, 10px gap, `text-wrap: balance` |

Header children in DOM order *(measured)*: `empty-icon` → `empty-title` → `empty-description`; header→content gap
**16px**.

Two specimens (`page.tsx:423–457`):

| panel label | glyph / tone | title | description | action |
|---|---|---|---|---|
| **Empty Stash — first-time user** | `PackageOpen` / `action` | **Your Stash is empty** | Cards land here the moment a pack finishes opening. Open your first pack to start a collection. | `<Button>` **Browse Packs** |
| **No search results — filters too narrow** | `Search` / `subtle` | **No packs match those filters** | Nothing between $0 and $10 has a legendary floor. Widening the price range will help. | `<Button variant="outline">` **Reset filters** |

Both em dashes in the Panel labels are **U+2014**.

---

## 10 · Live vs static ledger — the fidelity bar

| # | § | specimen | live? | what you can trigger |
|---|---|---|---|---|
| 1 | alert | 5 Alerts | **animating** | 2 bloom drifts + 2 starfield sways **per Alert** = **20 infinite animations**; hover swells the bloom and leans the sparkles. Two carry a clickable `AlertAction` Button (no handler) |
| 2 | toast | 5 `ToastPreview` | **animating** | same 4 per toast = **20 more**; the `loading` glyph spins; the `error` preview's action pill hovers to `--accent` |
| 3 | toast | 5 trigger Buttons | **LIVE** | fires real toasts: neutral · success (+description) · error (+description +action) · warning · **promise (1800ms loading → success)** |
| 4 | skeleton | 24 `Skeleton` | **animating** | 24 simultaneous 1.4s shimmers |
| 5 | progress | 7 `Progress` | static values | no interaction; the fill transition (250ms) never fires |
| 6 | progress | 3 `Spinner` + 2 loading Buttons | **animating** | 5 permanent 0.9s spins; both buttons permanently disabled at 45% opacity |
| 7 | empty | 2 `Empty` | static | 2 clickable Buttons, no handlers |
| 8 | api / rules | `Meta` + `DoDont` | prose | — |

**Standing animation count at rest: 20 (alerts) + 20 (toast previews) + 24 (shimmer) + 5 (spinners) = 69 infinite
animations on one page**, before a single toast is fired. That is the single biggest performance question in the
port (§17 Q2), and it is why RULES §4's rationing argument was used to defer them in phase 3.

Minimum interactive surface the Flutter page must support: five toast triggers including a promise that resolves
after 1800ms, a toast host with a 3-visible queue, hover on Alerts and toast previews, and a hoverable action pill.

---

## 11 · Copy — verbatim, with markup resolved

`{" "}` → one literal space; `&rsquo;` = U+2019; `&quot;` = `"`; `&lt;`/`&gt;` = `<`/`>`.

### 11.1 · The page-level Note — "Which one to reach for"

`<strong className="text-foreground">` on each component name; the rest is `type-small text-muted-foreground`.

> **Alert** stays on the page and explains a condition. **Toast** is transient confirmation of something the user
> just did. **Skeleton** holds the shape of content that is arriving. **Progress** shows how far through something
> is. **Empty** is for when there is genuinely nothing, and it always offers a way forward.

Five bold runs, in order: `Alert` · `Toast` · `Skeleton` · `Progress` · `Empty`. The `{" "}` after "just did." is a
literal space (`page.tsx:75`).

### 11.2 · §1 Note — "One surface, five meanings" *(inside the Panel, 1030px)*

> Every variant shares the same background, border and text colour. Only the **icon** and the **bloom** behind it
> change — three declarations. Stock shadcn tints the whole card and recolours the copy; five tinted cards on one
> page read as a traffic light rather than as one component, and body text is the least legible place to spend a
> hue.

Bold runs: `icon`, `bloom`. Dash is U+2014.

### 11.3 · §2 paragraphs

`p.type-small mt-6` (`page.tsx:184–191`), `Code` chips in backticks:

> These are not mock-ups. They render the same markup sonner produces and are styled by the same `.cn-toast` block
> in `globals.css` — the only difference is the missing `data-sonner-toast` attribute that would make them fixed to
> the corner of the viewport. Change a value there and both these and the live toast move together.

*(This claim is measurably false — §16 drift 4.)*

`p.type-small mt-3` (`:192–201`):

> The bloom is `feedback-surface`, shared with Alert. Two layers drift at different speeds and rotate against each
> other — a deep field over 18s and a brighter near field over 11s — so they never line up and the surface reads as
> two distances rather than one flat wash. Each type sets two hues and nothing else. It is CSS rather than a
> `ShaderSurface` because sonner builds the live toast and offers nowhere to mount a canvas, and because a 160×72
> zone renders at 80×36 — far too few pixels for a noise field. Same call as the premium button.

`p.type-small mt-5` (`:257–261`):

> Position and theme are configured once on the `<Toaster />` in the root layout, so no screen can move them.

### 11.4 · §3 Note (tone `error`) — "The common mistake"

> Do not build one `SkeletonCard` and use it everywhere. Each component that loads gets a skeleton shaped like
> *itself*. The shimmer animation is shared; the geometry is not.

`<em>itself</em>` is italic.

### 11.5 · §4 paragraphs and Notes

`p.type-small mt-6` (`:356–359`):
> The XP bar is the one place a progress track leaves the action ramp — progression toward a reward is a value
> signal.

`Note mt-4` (default `action` tone, **no title**) (`:360–366`):
> Same 10px sunken channel as the Slider’s track, because it is the same object — a filled channel. The only
> difference is the missing thumb, because you cannot grab this one. Stock shadcn ships a 4px hair, which reads as
> a different component entirely next to a price filter.

`p.type-small mt-6` (`:383–391`):
> Every fill names the `-ink` end of its ramp rather than the raw token, for the reason a glyph does: a filled
> channel carries no foreground, so the only thing that makes it visible is its contrast with the track. Measured
> on this page, `--primary` is 1.63:1 against `--muted` and `--action-ink` is 6.97:1; on light, raw
> `--color-success` is 1.73:1 and `--success-ink` is 4.93:1.

`Note tone="error" mt-4` (**no title**) (`:392–396`):
> `destructive` is for a reading *outside its safe band*, never for one that merely fell. A figure moving the wrong
> way is news, not a fault — RULES §1.4 — and it stays on the default tone.

`p.type-small mt-5` (`:409–413`):
> Inside a button, use the `loading` prop rather than placing a spinner by hand — it also sets `aria-busy` and
> disables the control.

### 11.6 · §5 paragraph

`p.type-small mt-4` (`:459–464`), width **1080** (outside the Panels):
> Note the difference: the first is empty because the user is new, the second because their filters are too narrow.
> Same component, completely different copy and action. Brand-specific empty states belong to the product that
> needs them, not to the chassis.

### 11.7 · §6 `Meta` (6 rows)

| k | v |
|---|---|
| `Alert variant` | default · destructive · success · warning · info. The last three were added for this product. |
| `AlertAction` | Absolutely positioned top-right slot for a single small action. |
| `toast()` | toast, toast.success, toast.error, toast.warning, toast.promise. Options: description, action. |
| `Skeleton` | Size it with Tailwind classes to match the real content's geometry. |
| `Progress value` | 0–100. Always pair with a readout showing the underlying figures. |
| `Empty` | Empty + EmptyHeader + EmptyMedia + EmptyTitle + EmptyDescription + EmptyContent. |

Separator in row 1 is **U+00B7**; the range in row 5 is **U+2013**. Apostrophes in rows 4 and 6 are straight.

### 11.8 · §7 `DoDont` — 5 and 5 *(measured, verbatim)*

**Do** (`border-value/25 bg-value/[0.06] p-5`, heading `type-label mb-3 text-value-ink` = "Do", items
`flex gap-2.5` = `Icon Check size="sm" tone="value" mt-0.5` + `type-small text-muted-foreground`):
1. Shape every skeleton like the component it stands in for.
2. Pair a progress bar with the real numbers — '412 / 2,000', not just a bar.
3. Give every empty state a reason and exactly one primary way forward.
4. Use an Alert, not a toast, for anything the user must act on.
5. Use the button's loading prop instead of hand-placing a spinner.

**Don’t** (`border-destructive/25 bg-destructive/[0.06]`, heading `text-destructive-ink` = "Don’t" with U+2019,
`Icon X size="sm" tone="error"`):
1. Don't put a decision inside a toast — it vanishes.
2. Don't reuse one generic skeleton block for every layout.
3. Don't show a spinner when you know the total; use progress.
4. Don't write 'No results' with nothing else on screen.
5. Don't stack more than one alert at the top of a page.

All apostrophes inside the items are **straight** `'`; only the panel heading uses U+2019. Quotes in do 2 and don't
4 are **straight single quotes**. Grid is `grid gap-4 sm:grid-cols-2` → **532 / 532**, 16px gap, 1080 total
*(measured)*.

---

## 12 · Foot nav

`PageFootNav groupId="base" slug="feedback"` → `<nav class="mt-8 flex items-stretch gap-4 border-t border-border
pt-8">` *(measured)*.

- **Previous** → **"Navigation"**, `/design-system/components/base/navigation`
- **Next** → **"Chat"**, `/design-system/components/base/chat`

`example\lib\nav.dart` already resolves both via `siblings('base','feedback')` (`:731–747`); `navigation` is at
`:291–304` and `chat` at `:320–332`.

---

## 13 · Token reference — what this page adds

Only what is not already tabulated in `shadows-map.md` §11 / `colors-map.md` / `forms-map.md` §13.

| token | dark *(measured)* | note |
|---|---|---|
| `--color-warning` | `#fbbf24` | the Alert warning bloom core |
| `--color-value-bright` | `#d9f99d` | the **toast** warning bloom core (drift 2) |
| `--color-value-dark` | `#4d7c0f` | the toast warning companion |
| `--color-value` | `#a3e635` | success/loading companion |
| `--color-action-bright` | `#92c2fc` | = `--action-ink` on dark |
| `--color-info` | `#22d3ee` | = `--info-ink` on dark |
| `--value-ink` | `#d9f99d` | progress `value` fill |
| `--star-glow` / `--star-glow-size` | `#ffffff80` / **2px** | light: `color-mix(in oklab, var(--bloom-2) 85%, transparent)` / **3px** |
| `--shadow-e3` | `0 2px 4px #00000080, 0 14px 28px -8px #0009` | the toast's elevation |
| `--text-small` | `.8125rem` = 13px | |
| `--radius-lg` / `--radius-pill` | 12px / 999px | |

Durations added by this page: `--duration-sway` **44s**, `--duration-sway-alt` **33s** (`globals.css:417–418`),
`--duration-bloom` **1000ms** (`:411`). Untokenised: **18s**, **11s** (the two drifts), **1.4s** (shimmer),
**0.9s** (spin), **400ms / 500ms / 200ms / 300ms** (sonner), **1800ms** (the promise demo), **4000ms** (lifetime).

Radii used: `md` 10 (Skeleton), `lg` 12 (Alert, toast, panels, Note, Meta, EmptyMedia), `xl` **16** (Empty — the
only `rounded-xl` on the page), `pill` 999 (Progress, toast action, pill skeletons).

Type classes: `type-h1`, `type-h3`, `type-lead`, `type-small`, `type-body` (**15/24**, only on the inline-skeleton
paragraph), `type-chip`, `type-label`, `type-code`, `type-num-sm`. Plus the raw `text-sm` ladder (13 @ 1.428571) on
the Alert and `EmptyTitle`, `text-sm/relaxed` (13 @ 1.625) on `EmptyDescription`, and the toast's **1.5** (19.5px)
which is `.cn-toast`'s own declaration. **Four different line-heights at 13px on this page** *(measured)*: **18.2**
(live toast description — sonner's 1.4, drift 4), **18.5714** (Alert title + description, `EmptyTitle`), **19.5**
(`type-small`, toast title, preview description), **21.125** (`EmptyDescription`).

---

## 14 · Timing inventory

Everything with a duration, in one table. `EI` = `--ease-in-out` `cubic-bezier(.65,0,.35,1)`; `EO` = `--ease-out`
`cubic-bezier(.22,1,.36,1)`.

| # | thing | duration | easing | loop | source |
|---|---|---|---|---|---|
| 1 | `cosmic-drift-deep` | **18s** | EI | infinite alternate | `globals.css:1759` |
| 2 | `cosmic-drift-near` | **11s** | EI | infinite alternate | `:1817` |
| 3 | bloom hover swell (`scale` 1→2.2 / 1→2.5) | **1000ms** | EO | — | `:1839–1846` |
| 4 | `star-sway` (rotate −6°→6°) | **44s** | EI | infinite alternate | `:3437` |
| 5 | `star-sway-alt` (rotate 5°→−5°) | **33s** | EI | infinite alternate | `:3445` |
| 6 | starfield hover (`translate`+`scale`) | **1000ms** | EO | — | `:3427–3429` |
| 7 | `pulls-shimmer` | **1.4s** | EI | infinite | `:2352` |
| 8 | `pulls-spin` (360°) | **0.9s** | **linear** | infinite | `:2408` |
| 9 | Progress indicator `transition-transform` | **250ms** | EO | — | `progress.tsx:44` |
| 10 | toast `[data-button]` hover | **250ms** | EO | — | `globals.css:2808` |
| 11 | toast enter/exit `transform`+`opacity` | **400ms** | **CSS `ease`** (unnamed) | — | `sonner styles.css:89` |
| 12 | toast `height` | **400ms** | CSS `ease` | — | ↑ |
| 13 | toast `box-shadow` | **200ms** | CSS `ease` | — | ↑ |
| 14 | back-toast collapsed exit | **500ms** transform / **200ms** opacity | CSS `ease` | — | `styles.css:338` |
| 15 | toast child fade (`> *`) | **400ms** | CSS `ease` | — | `styles.css:300` |
| 16 | swipe-out | **200ms** | `ease-out` | forwards | `styles.css:356–357` |
| 17 | toaster container `transform` | **400ms** | `ease` | — | `styles.css:51` |
| 18 | promise icon `sonner-fade-in` | **300ms** | `ease` | forwards | `styles.css:163` |
| 19 | toast lifetime | **4000ms** | — | — | `index.mjs:417` |
| 20 | unmount window | **200ms** | — | — | `index.mjs:425` |
| 21 | the promise demo's resolve | **1800ms** | — | — | `page.tsx:245` |
| 22 | Button `btn-spring` / `active:scale-95` | 250 / **80ms** | `--ease-spring` | — | `shadows-map.md` |

Reduced motion: `globals.css:2534–2542` collapses `animation-duration` / `transition-duration` to `.01ms` and
`animation-iteration-count` to `1` on `*, *::before, *::after` — that covers 1–10 without a per-component guard.
Sonner ships **its own** `@media (prefers-reduced-motion)` (`styles.css:703–710`) that sets
`transition: none !important; animation: none !important` on `[data-sonner-toast]` and its children — covering
11–18. **Two independent reduced-motion regimes**, and they disagree: ours leaves a 0.01ms transition, sonner
removes it entirely. Immaterial in a browser, but the port has one switch (`main.dart:84–85`, `?motion=reduced`),
so pick one behaviour and record it.

New `Durations` members needed: **18s** and **11s**. `sway` (44s) and `swayAlt` (33s) already exist unused
(`motion.dart:46`, `:51`); `bloom` (1000ms) exists at `:43`; `shimmer` (1400ms) at `:158`; `spin` (900ms) at `:107`.
11s collides numerically with `foilDrift` (`motion.dart:195`) and must be spelled separately, on the
`popIn`/`reward` precedent (`motion.dart:83–85`).

---

## 15 · Exists in the port / missing

Package root `D:\DESIGN\Design-System-2026-8\flutter-design-system\`.

### 15.1 · Already built — reuse

| need | where |
|---|---|
| `Alert` — 5 variants, `inkOf`, 16/14 padding, r12, 4px row gap, 12px icon gap, 2px icon nudge, hairline border + border-box correction, `liveRegion` | `lib\src\components\ui\alert.dart:48`, `:92`, `:120–213` |
| `BloomCosmic` — static, 8 named ctors, full oklch derivation, blend/void split, all 5 gradient ramps, the radial mask via `eltIn` | `lib\src\components\ui\feedback_surface.dart:204`, `:218–288`, `:333–361`, `:393–514` |
| `Toaster` + `ToastController` — 356/14/24/3-visible/4000/200, per-id timers, lifetime-starts-on-visibility, idempotent dismiss, 4 positions | `lib\src\components\ui\toaster.dart:76–96`, `:186–247`, `:269–415` |
| `Toast` — 16px padding, 4px content gap, 12px icon gap, 2px icon nudge, `Shadows.lg`, `liveRegion`, tap-to-dismiss | `toaster.dart:436–518` |
| `ToastType` — 6 members, ink table, bloom dispatch incl. `toastWarning` | `toaster.dart:98–143`, `:527–546` |
| Toaster **already mounted app-wide** — `docsToasts` singleton | `example\lib\shell.dart:49`, `:183` |
| `Spinner` — 16px default, `Durations.spin` 900ms, linear, reduced-motion → still at 0° | `lib\src\components\ui\spinner.dart:49–136` |
| `Shimmer` — the `pulls-shimmer` motion table: 1400ms, `inOut`, `tileFactor` 2, `fromPercent` 2 → `toPercent` −2, `gradient(theme)` = popover/accent/popover with `TileMode.repeated` | `lib\src\components\ui\keyframes.dart:875–917` |
| `Durations.sway` 44s / `.swayAlt` 33s / `.bloom` 1000ms / `.shimmer` 1400ms / `.spin` 900ms | `lib\src\design_system\foundation\motion.dart:46 / 51 / 43 / 158 / 107` |
| `Curves.inOut` `(0.65,0,0.35,1)` / `.out` `(0.22,1,0.36,1)` | `motion.dart:278 / 271` |
| All 10 glyphs this page needs: `info` `:144`, `circleCheck` `:186`, `hourglass` `:139`, `circleX` `:205`, `alertTriangle` `:146`, `packageOpen` `:103`, `search` `:88`, `octagonX` `:190`, `loaderCircle` `:162` | `lib\src\components\ui\icon_paths.dart` |
| Kit: `PageHeader :54` · `Section :148` · `Panel :242` · **`Row :466`** (+`RowAlign :450`, `gap` = 16 at `:478`) · `Meta :679` · `Code :737` · `DoDont :1025` · `Note :1124` (+`NoteTone :1121`) · `Grid :1198` · `PageFootNav :1446` | `example\lib\kit.dart` |
| Nav entry for `feedback` — slug/title/blurb/7 contents, verbatim; siblings resolve to Navigation/Chat | `example\lib\nav.dart:305–319`, `:731–747` |
| `Shadows.lg / pressed / btn / btnPrimary / btnValue` | `lib\src\design_system\foundation\shadows.dart` |
| `MachineSurface` (inset painting, CSS paint order) | `lib\src\components\ui\surface.dart:26` |
| Reduced-motion boot param `?motion=reduced` | `example\lib\main.dart:84–85`, docs `:67–83` |

### 15.2 · Missing — must be built

| # | missing | notes |
|---|---|---|
| 1 | **The two bloom drifts** | 18s + 11s, `alternate`, `EI`, 3 keyframe stops each (deep) / 4 (near). Must compose `translate3d` + `rotate` + `scale` into one `Matrix4` about `transform-origin` 88%/82% and 90%/86%. §17 Q1. |
| 2 | **The bloom hover swell** | `scale` 2.2 / 2.5 over 1000ms `EO`, **multiplied onto** the drift matrix, not replacing it. Needs a `MouseRegion` on `Alert` and `Toast`. |
| 3 | **`Starfield`** | 13 sparkles, 2 clusters, the 24×24 four-point path, per-instance opacity/translate/scale, `right bottom` / `right top` anchoring **with clipping**, two `drop-shadow` passes (blur = glow-size and 3×), two sways (44s/33s, ±6°/±5°, origin = the anchored corner), and the hover nudge. On a toast it must anchor to the **toast box**, not `[data-content]`. §5. |
| 4 | **`AlertAction`** | `Stack` + `Positioned(top: 8, right: 8)`, with the base padding switching to `pr-20` (80px) when present. |
| 5 | **Sonner's choreography** | enter `translateY(100%) → 0` + fade over 400ms `ease`; collapsed stack at `translateY(−14n)` `scale(1−0.05n)` with children at opacity 0 and height pinned to the front toast's; expand-on-hover to `translateY(−offset)` at natural height; exit front `translateY(100%)` + fade 400ms; exit back-collapsed `translateY(40%)` over 500/200ms. §6.3. **The current port stacks at full size with a flat 14px gap and no entrance.** |
| 6 | **Hover-to-pause** | pause on hover **and** on app-backgrounded, resuming from the stored remainder (`index.mjs:585–603`), not restarting. |
| 7 | **Swipe-to-dismiss** | threshold 45px or velocity > 0.11; exit animation 200ms `ease-out` in the swipe direction, `forwards`. |
| 8 | **Toast action pill (`[data-button]`)** | 32 × auto, 14px inline padding, pill, `--secondary` → hover `--accent`, 13/500, 250ms `EO`, `margin-left: auto`. Needed by the `error` preview and the live error toast. |
| 9 | **`toast.promise`** | loading → success/error swap in place, 300ms icon fade-in, no auto-dismiss while loading. The page's Promise button resolves after 1800ms. |
| 10 | **`ToastController.info/warning/loading/promise`** | only `show`, `success`, `error`, `dismiss`, `clear` exist (`toaster.dart:200–247`). The page fires **neutral, success, error, warning and promise**. |
| 11 | **`ToastType.glyph` for success/error** | returns `null` despite `circleCheck`/`octagonX` existing. Two-line fix + flip `selection_feedback_test.dart:866–887`. |
| 12 | **`Progress`** | Absent repo-wide. 10px channel, r999, 1px `--input`, `--muted` fill, `shadow-pressed`, 5 tones with `-ink` fills and `btnPrimary`/`btnValue`/`btn` shadows, 250ms `EO` fill transition, `Semantics(value:)`. Closest existing thing is `Sweep` (`keyframes.dart:1028`) with `widthFactor` at `:1042–1043`. |
| 13 | **`Skeleton`** | Widget absent; the **motion table exists** (`Shimmer`, `keyframes.dart:875`). Needs a widget with a `radius` default of `md` (10) and a `span` mode (inline, `align-middle`). 24 instances on this page. |
| 14 | **`Empty` family** | Absent entirely. `Empty` (r16, 24 pad, 16 gap, centred, `text-balance`), `EmptyHeader` (384 max, 8 gap), `EmptyMedia` (32 box, r12, `--muted`, **16px glyph** — drift 9), `EmptyTitle` (13/500/−0.26/`font-heading`), `EmptyDescription` (13/1.625), `EmptyContent` (384 max, 10 gap). |
| 15 | **`example\lib\pages\feedback.dart`** + a `main.dart` arm | `main.dart:156–170` routes ten pages; `feedback` falls to `_placeholderFor` (`:174–189`). Needs an import in the alphabetical block (`:15–25`), an arm after `:167`, and the "ten real routes" doc at `:148` updated. |
| 16 | **`_referenceHeight` for `feedback`** | `example\test\vertical_parity_probe_test.dart:180–188` lists 7 routes; heights at `:56–64`. **Measured: 6106px** at 1440×900, dark, pristine. §17 Q6. |
| 17 | Wrap-parity + page tests | `example\test\wrap_parity_probe_test.dart`; page test modelled on `example\test\forms_page_test.dart`. Package tests extend `test\selection_feedback_test.dart` (Alert `:683–765`, bloom `:767–817`, toast `:819–888`, toaster `:1367–1443`). |
| 18 | **Bloom theme vars onto `ThemeData`** | The five still live at `feedback_surface.dart:82–106` with a standing FOLLOW-UP. This page opens the effect anyway. |

### 15.3 · Guard-test constraints

`test\token_guard_test.dart:40–63` forbids, outside `lib/src/foundation/` (`:18–20`), across roots `lib` and
`example/lib` (`:23–26`): `Color(0x`, `Color.from`, `fontSize:\s*\d`, `letterSpacing:\s*-?\d`, `FontWeight.w\d`,
`\bCurves.`, `Duration((milli|micro)seconds:\s*\d`, `BorderRadius.circular(\d`, `BoxShadow(`,
`\bheight:\s*[01](?!\d)`. Bare `0`/`0.0` and `elTransparent` are always legal. Escape hatch:
**`allow-hardcoded: <reason>` anywhere on the line** (plain substring test at `:96`). **Raw text scan including
comments** (`:11–15`).

Consequences here:
- **18s and 11s** need `Durations` members (11s must not reuse `foilDrift`).
- The starfield's 13 opacity/translate/scale triples, the two viewBoxes (260×96, 200×64), the sparkle path and the
  ±6°/±5° amplitudes are all literals. They are **geometry** — put the path in `icon_paths.dart` beside the other
  transcribed paths and the placement table in the starfield's own file, on the `feedback_surface.dart` precedent
  (that file already holds `_deepWidthCap = 416` etc. without escape hatches because they are `double` constants,
  not matched patterns).
- Sonner's **400 / 500 / 200 / 300 / 1800 ms** are runtime constants of a foreign library, not `--duration-*`
  tokens. Follow `toaster.dart:95`'s precedent exactly:
  `// allow-hardcoded: sonner's TIME_BEFORE_UNMOUNT, a runtime constant, not a --duration-* token`.
- Sonner's transition easing is **CSS's unnamed `ease`** = `cubic-bezier(.25,.1,.25,1)`, which is **not** in
  `Curves` (`motion.dart:261–308`). `\bCurves.` is banned, so `Curves.ease` is unavailable; a new
  `Curves.cssEase` is needed, or an escape hatch. §17 Q5.
- Doc comments quoting `blur(16px)` or `Duration(milliseconds: 400)` will trip the scanner. Write timings in prose.

---

## 16 · Drift register (record, do not fix)

1. **Seven chips, five sections.** `category.contents` promises `Alert · Toast · Skeleton · Progress · Progress
   tones · Spinner · Empty`. Two of those ("Progress tones", "Spinner") are **Panel labels inside the `progress`
   section**, and the section itself is titled "Progress & Spinner", not "Progress". `nav.dart:333–342` states in
   the port's own file that "adding a string here is a commitment, not a label" — this is the closest thing to a
   violation of that rule still standing. Render the seven chips as written.
2. **PINNED — the warning toast blooms lime under an amber glyph.** *(measured)* `Alert variant="warning"` →
   `--bloom-1: #fbbf24` (amber) / `--bloom-2: #1a6ef4`. `.cn-toast[data-type="warning"]` → `--bloom-1: #d9f99d`
   (pale lime) / `--bloom-2: #4d7c0f` (dark olive), under a `#fbbf24` glyph. `alert.tsx:39–49` documents fixing
   exactly this bug on the Alert and the toast never got the change. **Both ship as written.** Port already
   dispatches `BloomCosmic.toastWarning` and records it at `feedback_surface.dart:274–277`.
3. **Specimen 5 is `variant="info"` wearing an `AlertTriangle`** and warning copy ("Purchase limit approaching…
   Limits are set in Preferences"). It renders a cyan `#22d3ee` triangle over a cyan bloom. Every other specimen's
   glyph matches its variant. Render as written.
4. **The toast preview is not the live toast.** *(measured, error type, both on screen at once)* The page states
   "the only difference is the missing `data-sonner-toast` attribute that would make them fixed to the corner of
   the viewport" (`page.tsx:186–190`). Measured differences:

   | property | LIVE | PREVIEW | cause |
   |---|---|---|---|
   | icon left offset from the toast edge | **14px** | **17px** | sonner `[data-icon] { margin-left: -3px }` |
   | icon→content distance | **16px** (12 gap + 4 margin) | **12px** | sonner `margin-right: 4px` |
   | content left | 46px | 45px | ↑ |
   | `[data-description]` line-height | **18.2px (1.4)** | **19.5px (1.5)** | sonner declares 1.4; `.cn-toast` sets font-size and colour on `[data-description]` but **never line-height**, so nothing overrides it |
   | 2-line description height | 36.38 | 39 | ↑ |
   | **total toast height** | **93.88** | **96.5** | ↑ |
   | `overflow-wrap` | `anywhere` | `normal` | sonner base rule |
   | `[data-icon]` box | fixed 16×16, `justify-content: flex-start`, `align-items: center` | auto, `normal`/`normal` | sonner |

   Everything else (356 width, 16 padding, 12 gap, flex-start, r12, `--popover`, `--shadow-e3`, title 13/500/1.5,
   action pill 32/14/pill/`--secondary`) **is** identical, because `.cn-toast`'s three-class specificity wins those.
   **The port should pin the LIVE numbers** — the preview is documentation of the live object, not vice versa.
5. **The `Meta` in §3's "Inline placeholders" Panel has no margin.** *(measured — `margin-top: 0`, 0px gap from the
   `Row` above it.)* `page.tsx:313` writes `<Meta items={…}/>` with no `className`; every other `Meta` in the
   corpus carries `mt-6`. The `dl` butts straight into the paragraph.
6. **The first Progress bar has no `aria-label`.** *(measured — `aria-label: null`.)* The other six all carry one,
   including the two that sit beside an identical `type-label`. `page.tsx:339` is `<Progress value={20.6} />`.
   Its readout "412 / 2,000" is a sibling `<span>`, unassociated.
7. **`PROGRESS_TONES`' comment contradicts its contents.** `page.tsx:52–54` says "`default` and `value` are shown
   above in their own context, so this row is the four that say something about the reading itself" — and the
   array's first entry is `{ tone: "default", label: "Steps today", value: 72 }`. Four entries, one of which is
   `default`; `value` is indeed absent. Counting both Panels, the page's seven bars are **three `default`**, one
   `value`, one `success`, one `warning` and one `destructive`.
8. **`Empty`'s dashed border never paints.** *(measured — `border-style: dashed`, `border-width: 0px`.)*
   `empty.tsx:10` writes `rounded-xl border-dashed` with no `border` or `border-1` class, and Tailwind's
   `border-dashed` sets only `border-style`. Both empty states render as borderless centred blocks.
9. **`EmptyMedia` defeats `Icon size="xl"`.** *(measured — `width`/`height` attributes are 24, computed box is
   16 × 16, `stroke-width` is 2.)* `emptyMediaVariants.icon` carries
   `[&_svg:not([class*='size-'])]:size-4`, and `Icon` sets the size as **presentation attributes** plus a
   `shrink-0 text-*` class list containing no `size-` token — so the CSS wins the box and the attribute loses.
   The glyph is drawn at 16px with the **stroke computed for 24px** (`icon.tsx:82`: `48/24 = 2`, not the 2.4 a
   16px glyph normally gets), i.e. visibly thinner than every other 16px glyph on the page.
10. **`Spinner`'s `role="status"` and `aria-label="Loading"` are dropped.** *(measured — all six spinners are
    `aria-hidden="true"` with `role: null`.)* `Icon` spreads nothing (`icon.tsx:68–74`). Already recorded as
    `forms-map.md` drift 3 / `buttons-map.md` drift 4; the port carries it at `spinner.dart:33–48`.
11. **`size-5`/`size-6` spinners keep the 16px stroke.** *(measured — 20px and 24px glyphs at strokeWidth 2.4.)*
    `Icon` computes `strokeWidth` from the `size` **prop**, and the className overrides only the box. A 24px
    spinner should be 2 by the ladder's own rule; it is 2.4.
12. **`Alert` has `role="alert"` and no `aria-live`.** *(measured.)* Five permanently-mounted `role="alert"`
    regions on one page is exactly what `forms-map.md`'s §3 Note calls an anti-pattern for `FieldError`. The port's
    `Alert` already sets `liveRegion: true` (`alert.dart:208–213`), which is the same shape.
13. **The live toast carries `role: null`, `aria-live: null`, `tabindex="0"`.** *(measured.)* Sonner announces
    through a separate visually-hidden region, not through the toast element; the port's `Toast` uses
    `Semantics(liveRegion: true, label: title)` on the toast itself (`toaster.dart:511–514`) — a deliberate,
    already-shipped divergence.
14. **Two reduced-motion regimes.** `globals.css:2534–2542` collapses durations to 0.01ms; `sonner/styles.css:703`
    sets `transition/animation: none !important`. On a live toast both apply, sonner's wins on `[data-sonner-toast]`
    and ours on the bloom pseudos.
15. **The bloom's `mix-blend-mode: screen` at `opacity: 0.75` reaches the border.** `overflow: hidden` clips to the
    **padding box**, so the 1px `--border` stroke sits outside the light. The port already models this
    (`alert.dart:193–194`, `:203`).
16. **`.cn-toast`'s selector is written three times.** Not a drift so much as a permanent structural fact: the port
    has no cascade, so this whole 30-line comment block (`globals.css:2560–2583`, `:2606–2641`) collapses to
    "these are the values". Record it once so the next reader does not go looking for a layering system.
17. **`--front-toast-height` is measured, not declared.** Sonner reads `heights[0].height` off the DOM
    (`index.mjs:1103`) and every collapsed back toast is pinned to it. In Flutter this means the stack cannot be
    laid out without first measuring the front toast — a `LayoutBuilder`/`RenderBox` round trip, not a constant.
18. **The section is titled "Progress & Spinner" but its `id` is `progress`.** Anchor and title disagree; the chip
    list splits them into two entries. Consistent with drift 1.

---

## 17 · Open questions for the supervisor

1. **How do the drift and the hover swell compose?** *(the central build question.)* CSS gets this for free —
   `transform` (animated) and `scale` (transitioned) are separate properties that multiply. Flutter has one
   `Matrix4`. **Recommendation:** one `AnimatedBuilder` per layer producing
   `Matrix4.identity() ..translate(originX, originY) ..scale(hoverScale) ..multiply(driftMatrix) ..translate(-originX, -originY)`,
   with `hoverScale` from a separate 1000ms `AnimationController` and `driftMatrix` from the keyframe player. The
   origins differ per layer (88%/82% deep, 90%/86% near) and the starfield's differ again (100%/100%, 100%/0%).
   Confirm this is the shape you want before I plan, because it decides whether `BloomCosmic` stays a
   `StatelessWidget` + `CustomPaint` or becomes a `StatefulWidget`.
2. **69 infinite animations at rest.** §10 counts 20 bloom/starfield animations on the Alerts, 20 on the toast
   previews, 24 shimmers and 5 spinners, before a toast is fired. Phase 3 deferred these citing RULES §4's
   rationing — and this page is where the ration is spent. **Recommendation:** build them fully (this page is their
   subject and a still would fail the bar outright), but drive **all four bloom/starfield layers of one host from a
   single `AnimationController`** per host, and gate the whole page on `?motion=reduced`. If the frame budget still
   fails at 1440×900, the fallback I would propose is pausing the previews' animations when scrolled out of view —
   which the reference does not do, so it needs your ruling.
3. **`text-balance` / `text-pretty` (deferral A2).** Five Alert descriptions, `Empty`'s root and `EmptyContent` all
   carry `text-balance`; the Alert's flips to `text-pretty` at ≥768. Flutter has neither. **Recommendation:** keep
   the existing record ("unreachable, not skipped") and greedy-wrap, but the vertical-parity probe must then be
   measured against a **greedy** reference height, not the browser's balanced one — flag any line-count difference
   in the wrap-parity probe rather than silently absorbing it.
4. **How faithful should the toast stack be?** Sonner's collapsed stack pins every back toast to the **front
   toast's measured height** and scales it `1 − 0.05n` while zeroing its children's opacity — so toasts 2 and 3 are
   blank slivers until you hover. The port currently renders all three at full size, 14px apart, fully legible.
   **Recommendation:** port the real behaviour, including expand-on-hover; it is the single most visible thing
   about a sonner stack and the page's whole §2 is about toasts. But it means a measure-then-lay-out pass (drift
   17) and it changes a shipped, tested contract (`selection_feedback_test.dart:1376–1442`). Needs your call.
5. **Sonner's unnamed `ease`.** All the toast choreography runs on CSS's default `ease` =
   `cubic-bezier(.25,.1,.25,1)`, which is in neither `--ease-*` nor `Curves`. **Recommendation:** add
   `Curves.cssEase` with a doc comment saying it is a foreign library's default and deliberately not on the
   system's motion scale — same reasoning as `_unmount` at `toaster.dart:90–95`. The alternative (snapping it to
   `Curves.standard` `(0.4,0,0.2,1)`) would be a silent retiming of every toast.
6. **`_referenceHeight` for `feedback` = 6106px?** *(measured at 1440×900, dark, pristine — nothing hovered, no
   toast fired.)* Two risks: the page's height is stable (no stateful content), but **firing a toast does not
   change document height** (the toaster is `position: fixed`), so pristine is safe here — unlike `forms`.
   **Recommendation:** add `'feedback': '$elRoot/components/base/feedback'` to
   `vertical_parity_probe_test.dart:180–188` with 6106.0 at the existing 0.5px tolerance. Confirm you want the
   probe extended rather than skipped, and note that `shadows`/`motion`/`icons` are still absent from that map.
7. **Where does `Starfield` live?** It is used by `Alert` (its own span) and `Toast` (hung off the content
   slot but anchored to the toast box). **Recommendation:** `lib\src\components\ui\ambient_pattern.dart` beside
   `feedback_surface.dart`, exported from the barrel, with the 24×24 sparkle path in `icon_paths.dart` as an off-set
   addition like `rotateCcw` — it is transcribed geometry and that file already holds transcribed geometry, and it
   must stay out of the icons-page registry.
8. **Does the port build `toast.promise`?** It needs a loading→settled swap in place, a 300ms icon cross-fade, and
   suppression of the 4000ms clock while loading (`index.mjs:581`: `if (toast.promise && toastType === 'loading' ||
   toast.duration === Infinity || toast.type === 'loading') return`). **Recommendation:** yes — the page ships a
   Promise button and it is the only demo of the loading type outside the static preview. It also forces
   `ToastController` to grow `info`/`warning`/`loading`, which the page needs anyway.
9. **Close the two stale records while the files are open?** (a) `ToastType.glyph` returns `null` for
   success/error although `circleCheck`/`octagonX` now exist, and a test asserts the `null`; (b) the five bloom
   theme vars still live in `feedback_surface.dart` with a standing FOLLOW-UP to move them to `ThemeData`.
   **Recommendation:** do both — (a) is two lines and a test flip, (b) is this page's own effect file. Confirm,
   since (b) touches `foundation\theme.dart`.
10. **`AlertAction` and the reserved lane.** `has-data-[slot=alert-action]:pr-20` widens the right padding to 80px
    **whether or not the action would have collided** — on specimen 3 it shortens the description column from 968
    to 904px. **Recommendation:** reproduce exactly (it is a measured layout fact, and it is what makes the two
    action Alerts wrap differently from the other three), rather than sizing the lane to the button.

---

## Dated correction — 2026-08-16, B2 build-time probes (supervisor-appended)

- **§6.2 glyph column error:** sonner's loading glyph does NOT spin —
  `sonner.tsx` adds no `anim-spin`. The port matches (no spin).
- **Back-expanded exit is unreachable on the live page:** `expanded` pauses
  every toast clock, so a toast cannot expire while expanded, and a swipe
  takes the swipe-out branch. Transcribed from the stylesheet; reachable and
  pinned in the port.
- **Enter curve measured** as CSS `ease` `cubic-bezier(.25,.1,.25,1)`
  (opacity 0.314@20.3%/0.645@38.3%/0.9445@69.6%); swipe-out release is CSS
  `ease-out` `(0,0,.58,1)` — both named in Curves (cssEase/cssEaseOut).
- **Reduced motion:** `transition: none`, toast appears at identity/opacity 1,
  and STILL expires on its 4000ms clock — timers are not motion.
- **Blanked back toasts:** `li` opacity 1 with content/icon at 0; both bloom
  pseudos keep drifting at 0.75; the starfield hangs off `[data-content]` so
  it goes dark with the children (port: `starfield: false`, measured-correct;
  the reference fades it over the 400ms content fade — the port cuts, bounded
  by the bloom/starfield architecture; recorded).
