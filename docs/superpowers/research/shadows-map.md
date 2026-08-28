# Map — `/design-system/shadows` (Foundations · Shadows)

**Files that produce the render** (all under `D:\DESIGN\Design-System-2026-8\design-system\`):
- `app\design-system\shadows\page.tsx` — the page (server component, no client code, no page-local components; two module-level arrays: `ambient` (4) and `machine` (8))
- `components\el\kit.tsx` — `PageHeader`, `Section`, `Panel`, `Code`, `DoDont`, `Note`, `PageFootNav` (all used). **`Meta` is NOT used on this page** (unlike spacing/typography).
- `components\ui\button.tsx` — five real Button variants render live
- `components\ui\input.tsx` — one real Input renders live
- `components\ui\icon.tsx` — `Icon` inside `DoDont` and `PageFootNav`
- `lib\el\nav.ts` L86–98 — `findCategory("foundations","shadows")` supplies eyebrow/title/blurb/contents; `siblings()` supplies foot-nav
- `app\design-system\layout.tsx` — shell around the page
- `app\globals.css` — every token/class/utility referenced below
- `app\layout.tsx` — loads `GeistMono` (`--font-geist-mono`) on `<html>`

Read this together with `shared-map.md` (shell, kit anatomy, type-class table, Icon sizes/tones). Nothing in shared-map is repeated here except where this page consumes it differently.

---

## 0 · Shell / layout metrics

Identical to every foundations page — see `shared-map.md` §1 and `spacing-map.md` §0. The load-bearing numbers for this page:

- Frame `max-w-(--width-shell)` **1680px**; sidebar 240px; main `min-w-0 flex-1 px-6 py-12 lg:px-12`; inner column `max-w-(--width-content)` **1080px**.
- At the 1440 reference frame the specimen column is exactly **1080px** wide (the parity probe's standing assertion).
- Spacing unit `--spacing: 0.25rem` (4px). Breakpoints stock: sm 640 · md 768 · lg 1024 · xl 1280 · 2xl 1536 (`globals.css` declares **no** `--breakpoint-*` override).
- Tailwind container scale not overridden either: `max-w-2xl` = 42rem = **672px**, `max-w-sm` = 24rem = **384px**.
- Anchor scroll: `scroll-padding-block-start: var(--scroll-offset)` = **96px**; sections carry no `scroll-mt-*`.
- `body` carries the fixed background-effect radial; the Panel bodies on this page are opaque `bg-background`, so **nothing on this page ever samples the background-effect** — including the glass specimens (see §7.4).

**Fonts:** `--font-sans`/`--font-heading` = `"Inter Local"` (one `@font-face`, `font-style: normal`, wght 100–900 — `globals.css:7–13`). `--font-mono` = Geist Mono. There is **no italic face for Inter**, so every `<em>` on this page (three of them) renders a *synthesised oblique*, not a designed italic. Same for `<strong>`: outside `.prose`, globals.css styles neither element (`strong`/`em` rules exist only at `:1421`/`:1425` under `:where(.prose)`), so Preflight's `b, strong { font-weight: bolder }` applies — inherited 400 → computed **700**.

---

## 1 · Page header (`PageHeader`)

`<header class="mb-14 border-b border-border pb-10">` — 56px below, 40px inner bottom, 1px hairline.

1. Eyebrow `type-label text-action-ink` → **"Foundations"** — 11px/1, 600, uppercase, tracking 0.16em; colour `--action-ink` (dark `#92C2FC`, light `#143694`).
2. `<h1 class="type-h1 mt-4 text-foreground">` → **"Shadows"** — `clamp(2rem, 2.8vw, 2.5rem)`, lh 1.1, 700, tracking −0.02em (`globals.css:1070–1076`). At the 1440 frame `2.8vw` = 40.32px → clamps to **40px**.
3. Blurb `type-lead mt-4 max-w-2xl` (672px) → **"Two families: ambient depth, and machine surfaces that look like they can be physically pressed. Ported from Yukirhythm."** — 17px/1.65/400, `--muted-foreground` (`globals.css:1099–1104`).
4. Chips `ul.mt-7 flex flex-wrap gap-2`; each `type-chip rounded-pill border border-border bg-card px-3 py-1.5 text-muted-foreground` (11.5px/1.2/500; radius 999px; 12px/6px padding). Verbatim, in order:
   **Ambient e1–e4 · Machine keys · Sunken sockets · Control depth · Rationed glow · Glass**
   (Note chip 1 contains an **en dash** `–` (U+2013), not a hyphen — `nav.ts:91`.)

---

## 2 · Opening `Note` — before any section

`<Note tone="action" title="Two families, one idea" className="mb-12">` — this sits between the header and the first `Section`, at page level. **No other foundations page opens with a page-level Note carrying `mb-12`** (colors opens with one but at the kit default).

Anatomy: `rounded-lg (12px) border p-5 (20px)` + action tone `border-action/30 bg-action/[0.08] text-action-ink`, plus `mb-12` (48px).
- Border: `--color-action` @ 30% = `rgba(26, 110, 244, 0.30)`
- Fill: `--color-action` @ 8% = `rgba(26, 110, 244, 0.08)`
- Title `type-label mb-2` inheriting the tone ink (`--action-ink`) → **"Two families, one idea"**
- Body `<div class="type-small text-muted-foreground">` — 13px/1.5/400

Body copy, verbatim, with markup and JSX whitespace resolved (`{" "}` → one literal space):

> Ambient shadows describe how far a surface floats. **Machine** shadows describe whether it can be *pressed*. That second family is what gives the interface its tactility: controls you operate stand proud with an inner highlight, and fields you type into are recessed. Get the two the wrong way round and everything feels like flat cardboard.

Inline runs, in order (for wrap-parity):
1. text `"Ambient shadows describe how far a surface floats. "`
2. `<strong>` `"Machine"` — weight 700, same size/colour
3. text `" shadows describe whether it can be "`
4. `<em>` `"pressed"` — synthesised oblique
5. text `". That second family is what gives the interface its tactility: controls you operate stand proud with an inner highlight, and fields you type into are recessed. Get the two the wrong way round and everything feels like flat cardboard."`

---

## 3 · Section `#ambient` — "Ambient depth"

`Section` shell (every section): `<section id class="mb-20">` (80px); heading block `mb-6`; `<h2 class="type-h3 text-foreground">` — 21px (1.3125rem)/1.3/600/−0.01em; description `type-small mt-2 max-w-2xl` — 13px/1.5/400/muted.

Heading: **"Ambient depth"**
Description (verbatim): **"Four steps. On a near-black page a shadow reads as a soft darkening, so depth mostly comes from the surface ladder — these only confirm it."**

`Panel label="e1 → e4"` (note: an actual **U+2192 arrow**, not `->`), no `note`. Panel anatomy: frame `overflow-hidden rounded-xl (16px) border border-border bg-card`; header strip `flex items-baseline justify-between gap-4 border-b border-border bg-muted px-5 py-3` with label `type-label text-muted-foreground`; body `bg-background p-6` (24px).

Body: `<div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">` — 1 col < 640, 2 col ≥ 640, 4 col ≥ 1024; 24px gutters. Four cells, each:
- Demo box: `grid h-24 place-items-center rounded-lg border border-border bg-card ${cls}` — 96px tall, 12px radius, 1px `--border`, fill `--card`, plus the ambient shadow class. Centred `<span class="type-num-sm text-muted-foreground">` printing the **class** name (`shadow-e1` … `shadow-e4`) — Geist Mono 12px/1.2/600/tabular/−0.01em.
- `<p class="type-num-sm mt-3 text-action-ink">` printing the **token** name (`--shadow-e1` …) — 12px above.
- `<p class="type-small mt-1 leading-snug">` use copy — 4px above, 13px/**1.375** (`leading-snug` overrides `.type-small`'s 1.5), muted.

| # | token | class | use copy (verbatim) |
|---|---|---|---|
| 1 | `--shadow-e1` | `shadow-e1` | Resting rows, chips, table headers. Barely there. |
| 2 | `--shadow-e2` | `shadow-e2` | Cards and pack cards at rest. |
| 3 | `--shadow-e3` | `shadow-e3` | Hovered cards, popovers, dropdowns, sticky bars. |
| 4 | `--shadow-e4` | `shadow-e4` | Dialogs, drawers, the pack-opening stage. |

*Cross-page note:* these four `use` strings are **character-identical** to the spacing page's Elevation panel (`spacing-map.md` §4). The section *description* differs: spacing says "Four neutral depth steps, plus two glows that are strictly rationed. On a near-black background a shadow reads as a soft darkening…"; shadows says "Four steps. On a near-black page a shadow reads…". Keep both as written.

Geometry (`globals.css:354–357`, inside `@theme static`) — theme-independent shapes, themed ink:

| token | layers (`dx dy blur spread colour`) |
|---|---|
| `--shadow-e1` | `0 1px 1px --ink-2` , `0 1px 3px --ink-1` |
| `--shadow-e2` | `0 1px 2px --ink-2` , `0 4px 10px -2px --ink-2` |
| `--shadow-e3` | `0 2px 4px --ink-2` , `0 14px 28px -8px --ink-3` |
| `--shadow-e4` | `0 4px 8px --ink-3` , `0 28px 56px -14px --ink-4` |

---

## 4 · Section `#machine` — "Machine surfaces"

Heading: **"Machine surfaces"**
Description (verbatim): **"Depth that implies a mechanism. These carry inset highlights and shades, so a control looks like it has a top face and a side wall."**

`Panel label="The machine set"`. Body: `<div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">` — 1 / 2 / **3** columns; 24px gutters. Eight cells → at ≥1024 the last row holds two.

Cell anatomy differs from §3 in two ways that matter:
- Demo box: `grid h-24 place-items-center rounded-pill bg-card ${cls}` — **no border**, and `rounded-pill` (999px, clamped by the shape to a 48px stadium end on a 96px-tall box). Fill `--card`.
- Everything else identical: centred `type-num-sm text-muted-foreground` class name; `type-num-sm mt-3 text-action-ink` token name; `type-small mt-1 leading-snug` use copy.

| # | token | class | use copy (verbatim) |
|---|---|---|---|
| 1 | `--shadow-btn` | `shadow-btn` | Secondary, outline and destructive buttons. An inner top highlight and inner bottom shade make the surface read as a physical key. |
| 2 | `--shadow-btn-primary` | `shadow-btn-primary` | The primary button. Same depth plus a blue cast beneath it. |
| 3 | `--shadow-btn-value` | `shadow-btn-value` | The premium button. Lime cast, for money and reward actions. |
| 4 | `--shadow-btn-down` | `shadow-btn-down` | Any button while pressed. The surface sinks into its socket instead of merely dimming. |
| 5 | `--shadow-key` | `shadow-key` | A raised key with a visible side wall. Used by the press-key utility. |
| 6 | `--shadow-key-down` | `shadow-key-down` | The same key, travelled 3px down into its socket. |
| 7 | `--shadow-pressed` | `shadow-pressed` | A sunken socket. Every input, textarea and input group sits in one. |
| 8 | `--shadow-chip` | `shadow-chip` | Badge and chip depth. Lighter than a button, but not flat. |

Geometry (`globals.css:360–379`):

| token | layers |
|---|---|
| `--shadow-key` | `0 4px 0 --wall` , `0 7px 12px --ink-3` |
| `--shadow-key-down` | `0 1px 0 --wall` , **inset** `0 2px 5px --ink-3` |
| `--shadow-pressed` | **inset** `0 2px 5px --ink-3` , **inset** `0 1px 2px --ink-4` |
| `--shadow-btn` | **inset** `0 1px 0 --rim` , **inset** `0 -2px 4px --ink-2` , `0 1px 2px --ink-2` , `0 3px 8px -2px --ink-2` |
| `--shadow-btn-primary` | **inset** `0 1px 0 --rim-strong` , **inset** `0 -2px 5px --ink-2` , `0 1px 2px --ink-2` , `0 4px 10px -2px color-mix(in oklab, --color-action 55%, transparent)` |
| `--shadow-btn-value` | **inset** `0 1px 0 --rim-strong` , **inset** `0 -2px 5px --ink-1` , `0 1px 2px --ink-2` , `0 4px 10px -2px color-mix(in oklab, --color-value 45%, transparent)` |
| `--shadow-btn-down` | **inset** `0 2px 4px --ink-3` , `0 1px 1px --ink-1` |
| `--shadow-chip` | **inset** `0 1px 0 --rim` , **inset** `0 -1px 2px --ink-2` , `0 1px 2px --ink-2` |

**`color-mix(in oklab, C N%, transparent)` resolves to `C` at alpha N.** Premultiplied interpolation zeroes `transparent`'s contribution, so the un-premultiplied result is exactly `C`. Concretely: `--color-action 55%` = `rgba(26,110,244,0.55)`; `--color-value 45%` = `rgba(163,230,53,0.45)`. (`shadows.dart:123–129` already records and implements this.)

*Note for §5:* the `--shadow-btn` use copy claims **"Secondary, outline and destructive buttons"** — `button.tsx` gives `shadow-btn` to **`outline` only**. `secondary` and `destructive` carry no shadow class at all. See §12 drift 1.

---

## 5 · Section `#in-use` — "Raised against recessed"

Heading: **"Raised against recessed"**
Description (verbatim): **"The rule in one panel. Press the buttons and focus the field — the button sinks, the field is already sunken and only its ring changes."**

`Panel label="Press and focus these"`. Body (`bg-background p-6`) holds three blocks:

1. `<div class="flex flex-wrap items-center gap-4">` — five real Buttons, 16px gaps, wrapping, cross-axis centred.
2. `<div class="mt-6 max-w-sm">` — one real Input (24px above, capped at **384px**; the Input itself is `w-full`).
3. `<p class="type-small mt-6">` — the caption, 24px above.

Caption copy, verbatim (four `Code` chips; `{" "}` → literal space):

> Buttons carry `shadow-btn` or `shadow-btn-primary` and drop to `shadow-btn-down` on `:active`. The input carries `shadow-pressed` permanently — it is a socket, and it never rises.

`Code` anatomy: `<code class="type-code rounded-sm border border-border bg-card px-1.5 py-0.5 text-muted-foreground">` — Geist Mono 12.5px/1.4, 6px/2px padding, 6px radius, 1px `--border`, fill `--card` (`globals.css:1157–1163`).

### 5.1 · Button base — every class on the element

`button.tsx:28` base (cva), resolved:

| class | value |
|---|---|
| `group/button relative isolate` | positioning context + **its own stacking context** (required: the `::before`/`::after` blend modes must composite against the button's own fill, not the page) |
| `inline-flex min-w-0 max-w-full shrink-0 items-center justify-center` | centred row |
| `overflow-hidden` | clips foil/sheen pseudo-layers to the pill |
| `rounded-pill` | 999px → stadium (20px ends on a 40px control) |
| `border border-transparent` + `bg-clip-padding` | a **1px transparent border** on all four sides; the fill is clipped to the padding box, so the outer 1px shows whatever is behind (here: the Panel body's `--background`). Box-shadows are still drawn from the border box. |
| `font-medium` | 500 (`--font-weight-medium`, `globals.css:178`) |
| `whitespace-nowrap select-none outline-none` | — |
| `btn-spring` | `globals.css:1886–1898` — transition `transform, background-color, border-color, color, box-shadow, opacity` at **250ms `--ease-spring` cubic-bezier(0.34,1.56,0.64,1)**; `&:active { transition-duration: 80ms }` (`--duration-tick`). Instant in, springy out. |
| `active:not-aria-[haspopup]:scale-95` | `transform: scale(0.95)` while pressed (no `aria-haspopup` on any of the five here, so all five scale) |
| `focus-visible:border-ring` | border colour transparent → `--ring` (dark `#92C2FC`, light `#1A6EF4`) |
| `focus-visible:ring-3 focus-visible:ring-ring/50` | a `0 0 0 3px` non-inset ring at `--ring` @ 50%, composited **in front of** `--tw-shadow` (Tailwind v4 order: `inset-shadow, inset-ring, ring-offset, ring, shadow`) |
| `disabled:pointer-events-none disabled:opacity-45` | not exercised on this page |
| `aria-invalid:*` | not exercised on this page |
| `[&_svg]:…` | no icons in these five |

Size = `default`: `h-10 gap-2 px-4 text-sm` → **40px tall, 8px gap, 16px horizontal padding, 13px type** (`--text-sm` → `--text-small` = 0.8125rem, `globals.css:213`). Emphasis = `none`.

### 5.2 · The five variants and every visual state

All five render at `size="default"`, `emphasis="none"`. `active` outranks `hover` (Tailwind's variant order puts `active` later). Labels in DOM order:

| # | variant | label |
|---|---|---|
| 1 | `default` | **Open Pack** |
| 2 | `premium` | **Deposit Funds** |
| 3 | `secondary` | **View Hits** |
| 4 | `outline` | **Filters** |
| 5 | `ghost` | **Skip** |

**1 · `default` — `action-feedback bg-primary text-primary-foreground shadow-btn-primary active:shadow-btn-down`**

| state | fill | text | border | box-shadow | transform | pseudo-layers |
|---|---|---|---|---|---|---|
| rest | `action-feedback` ramp over `--primary` `#1A6EF4` | `#FFFFFF` | transparent | `--shadow-btn-primary` | — | `::after` texture static @ 0.75 soft-light; `::before` beat opacity 0, scale 0.55 |
| hover | same | same | same | same | — | `::before` runs `action-beat 2.6s --ease-out infinite` |
| active | same | same | same | **`--shadow-btn-down`** | `scale(0.95)`, 80ms in | `::before` runs `action-beat 620ms --ease-out 1` |
| focus-visible | same | same | **`--ring`** | `--shadow-btn-primary` + ring `0 0 0 3px rgba(ring,0.5)` | — | unchanged |

**2 · `premium` — `premium-surface font-semibold text-value-foreground shadow-btn-value hover:shadow-glow-value active:shadow-btn-down`**

Weight is **600** (`font-semibold` beats the base `font-medium`). Text is `--color-value-foreground` = `hsl(240 10% 8%)` = `#121216` — the one foreground in the system that **does not flip with the theme** (`globals.css:111–127`).

| state | box-shadow | foil `::after` | glint `::before` | transform |
|---|---|---|---|---|
| rest | `--shadow-btn-value` | `value-foil-drift 11s linear infinite`, opacity **0.95**, soft-light | `value-glint 5.5s --ease-in-out infinite`, screen | — |
| hover | **`--shadow-glow-value`** (replaces the token wholesale — the inset rim and inner shade **disappear**) | opacity **1** | animation-duration **2.4s** | — |
| active | **`--shadow-btn-down`** (wins over hover) | opacity 1 (still hovered) | 2.4s | `scale(0.95)`, 80ms |
| focus-visible | `--shadow-btn-value` + ring `0 0 0 3px rgba(ring,0.5)`, border → `--ring` | 0.95 | 5.5s | — |

**3 · `secondary` — `bg-secondary text-secondary-foreground hover:bg-accent aria-expanded:bg-accent`**

| state | fill | text | box-shadow |
|---|---|---|---|
| rest | `--secondary` (dark `#27272A`, light `#F4F4F5`) | `--secondary-foreground` (dark `#FAFAFA`, light `#18181B`) | **none** |
| hover | `--accent` (dark `#3F3F46`, light `#F4F4F5`) | same | none |
| active | `--accent` | same | none — only `scale(0.95)` |
| focus-visible | `--secondary` | same | ring only |

**4 · `outline` — `border-input bg-card text-foreground shadow-btn hover:bg-muted active:shadow-btn-down aria-expanded:bg-muted`**

The border is no longer transparent: `--input` (dark `#3F3F46`, light `#E4E4E7`).

| state | fill | border | box-shadow |
|---|---|---|---|
| rest | `--card` (dark `#18181B`, light `#FFFFFF`) | `--input` | `--shadow-btn` |
| hover | `--muted` (dark `#27272A`, light `#F4F4F5`) | `--input` | `--shadow-btn` |
| active | `--muted` | `--input` | **`--shadow-btn-down`**, `scale(0.95)` |
| focus-visible | `--card` | **`--ring`** | `--shadow-btn` + ring |

**5 · `ghost` — `text-muted-foreground hover:bg-secondary hover:text-foreground active:bg-muted aria-expanded:bg-secondary aria-expanded:text-foreground`**

| state | fill | text | box-shadow |
|---|---|---|---|
| rest | none (transparent) | `--muted-foreground` (dark `#D4D4D8`, light `#62626A`) | none |
| hover | `--secondary` | `--foreground` (dark `#FAFAFA`, light `#09090B`) | none |
| active | `--muted` | `--foreground` | none, `scale(0.95)` |
| focus-visible | transparent | `--muted-foreground` | ring only |

**State count for this panel: 5 variants × 4 states = 20 button states, + 2 Input states (§5.5) = 22.**

### 5.3 · `action-feedback` anatomy (`globals.css:2059–2160`, blend split at `:3289–3295`)

Three parts, only one of which moves at rest.

**a. The ramp** — the element's own `background-image`, static, `linear-gradient(176deg, …)`, five stops. Resolved (oklab mixes computed):

| stop | expression | resolved |
|---|---|---|
| 0% | `color-mix(in oklab, --color-action-bright 20%, --color-action)` | `#3680F6` rgb(54,128,246) |
| 44% | `--color-action` | `#1A6EF4` rgb(26,110,244) |
| 53% | `color-mix(in oklab, --color-action-dark 50%, --color-action)` | `#1851C3` rgb(24,81,195) |
| 76% | `--color-action` | `#1A6EF4` |
| 100% | `color-mix(in oklab, --color-action-bright 10%, --color-action)` | `#2977F5` rgb(41,119,245) |

`176deg` = 4° off straight-down (CSS gradient angles: 0deg = to top, 180deg = to bottom), i.e. top-to-bottom tilted 4° counter-clockwise.

**b. The texture — `::after`, static.** `inset: 0`, `border-radius: inherit`, `pointer-events: none`, `mix-blend-mode: soft-light`, `opacity: 0.75`. Three background layers, `background-repeat: no-repeat`, `background-size: 100% 100%, 190% 100%, 100% 100%`:
1. `repeating-linear-gradient(104deg, rgba(146,194,252,0.34) 0 1px, transparent 1px 7px)` — 1px striations on a 7px pitch
2. `linear-gradient(100deg, transparent 28%, rgba(146,194,252,0.52) 48%, transparent 68%)` — one broad diagonal sheen
3. `radial-gradient(120% 150% at 24% -20%, rgba(146,194,252,0.45), transparent 60%)` — a corner light

**c. The beat — `::before`.** `inset: 0`, `border-radius: inherit`, `pointer-events: none`, at rest `opacity: 0; transform: scale(0.55)`.
`background: radial-gradient(ellipse 46% 130% at 50% 50%, rgba(146,194,252,0.85), rgba(146,194,252,0.30) 55%, transparent 72%)`.
`mix-blend-mode` is **theme-dependent** (`globals.css:3289–3295`): light/`:root` → **`multiply`**; dark → **`screen`**.

`@keyframes action-beat` (`:2059–2088`) — a double thump then rest:

| % | transform | opacity | @2.6s (hover) | @620ms (active) |
|---|---|---|---|---|
| 0 | scale(0.55) | 0 | 0ms | 0ms |
| 10 | scale(1) | 0.62 | 260ms | 62ms |
| 24 | scale(1.32) | 0 | 624ms | 148.8ms |
| 30 | scale(0.7) | 0 | 780ms | 186ms |
| 40 | scale(1.06) | 0.34 | 1040ms | 248ms |
| 54 | scale(1.38) | 0 | 1404ms | 334.8ms |
| 100 | scale(1.38) | 0 | 2600ms | 620ms |

Easing `--ease-out` cubic-bezier(0.22,1,0.36,1), applied **per segment**. Hover = `infinite` (1196ms of the 2600ms cycle is dead rest); active = **one** 620ms pass.

### 5.4 · `premium-surface` anatomy (`globals.css:1915–2040`)

Three layers, two of them permanently animating.

**a. The metal ramp** — element `background-image`, `linear-gradient(176deg, …)`, seven stops:

| stop | expression | resolved |
|---|---|---|
| 0% | `color-mix(in oklab, --color-value-bright 94%, white)` | `#DBF9A3` rgb(219,249,163) |
| 22% | `--color-value-bright` | `#D9F99D` rgb(217,249,157) |
| 44% | `--color-value` | `#A3E635` rgb(163,230,53) |
| 52% | `color-mix(in oklab, --color-value-dark 42%, --color-value)` | `#7EB825` rgb(126,184,37) ← the **edge of the metal** |
| 62% | `--color-value` | `#A3E635` |
| 88% | `--color-value-bright` | `#D9F99D` |
| 100% | `color-mix(in oklab, --color-value-bright 90%, white)` | `#DDFAA8` rgb(221,250,168) |

The 52% band is a per-brand contrast-critical number (`globals.css:1951–1963`): it is the worst-case stop under the foil's ink, measured at 42% for lime. **Do not adjust it.**

**b. The foil — `::after`.** `mix-blend-mode: soft-light`, `opacity: 0.95` (hover → **1**), `animation: value-foil-drift 11s linear infinite`. `background-repeat: no-repeat`, `background-size: 170% 100%, 210% 100%, 100% 100%`. Layers:
1. `repeating-linear-gradient(104deg, rgba(217,249,157,0.80) 0 1px, transparent 1px 5px)` — striations on a 5px pitch
2. `linear-gradient(100deg, transparent 30%, #DBF9A2 46%, rgba(217,249,157,0.60) 54%, transparent 70%)`
3. `radial-gradient(130% 170% at 22% -10%, #E2FBB7, transparent 62%)`

`@keyframes value-foil-drift` (`:1915–1928`) — linear, 11s:
- 0% → `background-position: 0% 50%, -60% 50%, 50% 50%`
- 100% → `background-position: 140% 50%, 160% 50%, 50% 50%`
- Layer 3 (the radial) is stationary; layers 1 and 2 travel 140% and 220% of their own sizing box respectively.

**c. The glint — `::before`.** `mix-blend-mode: screen` in **both** themes (`globals.css:3297–3300` states this explicitly — the foil is its own opaque base, so it never needs the multiply/screen split the sheen needs). `background-size: 260% 100%`, `no-repeat`, at rest `background-position: 135% 50%; opacity: 0`. `animation: value-glint 5.5s var(--ease-in-out) infinite` (hover → **2.4s**).
Gradient: `linear-gradient(104deg, transparent 38%, #EEFDD5 46%, #F9FEF1 50%, #EEFDD5 54%, transparent 62%)`.

`@keyframes value-glint` (`:1930–1946`):

| % | background-position | opacity | @5.5s | @2.4s (hover) |
|---|---|---|---|---|
| 0 | 135% 50% | 0 | 0ms | 0ms |
| 54 | 135% 50% | 0 | 2970ms | 1296ms |
| 60 | (interpolating) | 1 | 3300ms | 1440ms |
| 94 | (interpolating) | 1 | 5170ms | 2256ms |
| 100 | −55% 50% | 0 | 5500ms | 2400ms |

Position is declared only at 0/54/100, so it holds at 135% for the first 54% of the cycle and then sweeps 135% → −55% across the remaining 46% on `--ease-in-out` cubic-bezier(0.65,0,0.35,1). Opacity ramps 0→1 over 54→60% and 1→0 over 94→100%. Net reading: **it idles for just over half the cycle, then one bright band crosses right-to-left.**

### 5.5 · The Input (`components\ui\input.tsx`)

Container: `<div class="mt-6 max-w-sm">`; the input is `w-full`.

Every class resolved:

| class | value |
|---|---|
| `h-10` | 40px (level with a default Button — the JSDoc says so explicitly) |
| `w-full min-w-0` | — |
| `rounded-pill` | 999px → 20px stadium ends |
| `border border-input` | 1px, dark `#3F3F46` / light `#E4E4E7` |
| `bg-card` | dark `#18181B` / light `#FFFFFF` |
| `px-4 py-1` | 16px / 4px (the JSDoc explains 16 not 12–14: a pill's corner eats ~20px on a 40px control) |
| `text-sm` | 13px (`--text-sm` → `--text-small`) |
| `shadow-pressed` | **permanent** — `inset 0 2px 5px --ink-3, inset 0 1px 2px --ink-4` |
| `outline-none` | — |
| `transition-[box-shadow,border-color,background-color] duration-base ease-out` | 250ms, cubic-bezier(0.22,1,0.36,1) |
| `placeholder:text-muted-foreground` | dark `#D4D4D8` / light `#62626A` |
| `focus-visible:border-primary/50` | border → `rgba(26,110,244,0.50)` |
| `focus-visible:ring-3 focus-visible:ring-ring/35` | `0 0 0 3px` at `--ring` @ 35% — **added to**, not replacing, `shadow-pressed` (ring lives in `--tw-ring-shadow`, the socket in `--tw-shadow`) |
| `file:*` / `disabled:*` / `aria-invalid:*` | not exercised on this page |

Placeholder text, verbatim: **"Search packs, cards and sets"**

| state | border | box-shadow |
|---|---|---|
| rest | `--input` | `--shadow-pressed` |
| focus-visible | `rgba(26,110,244,0.50)` | `--shadow-pressed` **+** `0 0 0 3px` `--ring` @ 35% |

There is **no hover state**. The section description's promise — "the field is already sunken and only its ring changes" — is exactly true.

---

## 6 · Section `#glow` — "Rationed glow"

Heading: **"Rationed glow"**
Description (verbatim): **"Two glows, and they are the scarcest thing in the system. Both derive from the accent tokens, so they follow the palette automatically."**

`Panel label="Selected and celebrated"`. Body: `<div class="grid gap-6 sm:grid-cols-2">` — 1 / 2 columns.

**Cell 1** — box `glow-action grid h-24 place-items-center rounded-lg border border-primary/40 bg-card`
- 96px tall, 12px radius, 1px border at `--primary` @ 40% = `rgba(26,110,244,0.40)`, fill `--card`
- centred `<span class="type-num-sm text-action-ink">glow-action</span>`
- caption `<p class="type-small mt-3">` (12px above, lh **1.5** — no `leading-snug` here): **"Selected pack, focused primary CTA, active opening stage. Says *this is the thing you chose*."** (final clause an `<em>`, synthesised oblique; the trailing `.` is outside the `<em>`)

**Cell 2** — box `glow-value grid h-24 place-items-center rounded-lg border border-value/40 bg-card`
- border `--color-value` @ 40% = `rgba(163,230,53,0.40)`
- centred `<span class="type-num-sm text-value-ink">glow-value</span>` — `--value-ink` dark `#D9F99D`, light `#4D7C0F`
- caption: **"Celebrated tiers, reward unlocks, premium actions. Says *this is worth something*."**

Utilities (`globals.css:1519–1524`) and tokens (`:382–387`):
- `.glow-action { box-shadow: var(--shadow-glow-action) }` = `0 0 0 1px rgba(146,194,252,0.45)` , `0 10px 34px -8px rgba(26,110,244,0.60)`
- `.glow-value { box-shadow: var(--shadow-glow-value) }` = `0 0 0 1px rgba(163,230,53,0.45)` , `0 10px 34px -8px rgba(163,230,53,0.42)`

Both are non-inset in full. The first layer is a 1px hard ring (zero blur, 1px spread) that sits **outside** the element's own 1px border — so each cell shows two concentric 1px rings at rest.

*Cross-page drift:* the spacing page's glow panel uses `border-action/40` and the verb "Signals", with different captions ("Legendary or mythic reveal, reward unlock, premium action"). This page uses `border-primary/40` and "Says". `--primary` is `var(--color-action)` in both themes so the pixels are identical, but the class and the copy are not. Record, don't reconcile.

---

## 7 · Section `#glass` — "Glass"

Heading: **"Glass"**
Description (verbatim): **"A surface in front of the page rather than cut out of it. Two utilities, one material — the split is scale, not taste."**

`Panel label="glass-panel and glass-control"`. Body: `<div class="grid gap-6 sm:grid-cols-2">`, then a `Note` at `mt-6`.

### 7.1 · Cell 1 — `glass-panel`

Box: `glass-panel grid h-24 place-items-center rounded-4xl` — 96px tall, **32px radius** (`--radius-4xl`, `globals.css:338`), **no `bg-*` class and no border class** (the utility supplies both).
Centred `<span class="type-num-sm text-foreground">glass-panel</span>` — note `text-foreground`, not `text-muted-foreground`.

Caption `<p class="type-small mt-3">`, verbatim (three `Code` chips; `&rsquo;` = U+2019):
> Card scale. Translucent `--card`, a backdrop blur, a hairline rim of the ink colour and `--shadow-e2` beneath. The page’s own light shows through it, which is the whole reason to reach for this over `bg-card`.

`@utility glass-panel` (`globals.css:1563–1584`):
```
@apply backdrop-blur-xl backdrop-saturate-150;
background-color: color-mix(in oklab, var(--card) 74%, transparent);
box-shadow:
  inset 0 1px 0 var(--rim-strong),
  inset 0 0 0 1px color-mix(in oklab, var(--foreground) 12%, transparent),
  var(--shadow-e2);
```
- `backdrop-blur-xl` → `backdrop-filter: blur(24px)` (Tailwind `--blur-xl`; globals.css declares **no** `--blur-*` override except `--blur-showcase: 20px` at `:284`)
- `backdrop-saturate-150` → `saturate(1.5)`
- Fill: `--card` @ **74%** — dark `rgba(24,24,27,0.74)`, light `rgba(255,255,255,0.74)`
- Rim: `--foreground` @ **12%** — dark `rgba(250,250,250,0.12)`, light `rgba(9,9,11,0.12)`, painted as a 1px **inner** ring
- Top highlight: `--rim-strong` — dark `rgba(255,255,255,0.28)`, light `rgba(255,255,255,0.40)`
- Ambient: `--shadow-e2` (two outer layers), chosen **inside the utility** rather than at the call site

`overflow: hidden` is deliberately **not** set (`globals.css:1560–1562`).

### 7.2 · Cell 2 — `glass-control`

Outer box: `grid h-24 place-items-center rounded-4xl bg-card` — 96px, 32px radius, opaque `--card`.
Inner: `<span class="glass-control inline-flex h-12 items-center rounded-pill px-4">` — **48px tall**, pill, 16px horizontal padding, containing `<span class="type-num-sm text-foreground">glass-control</span>`.

Caption, verbatim (one `Code` chip):
> Control scale. No blur and no ambient shadow: at 44px there is nothing behind it worth blurring, and `e2` under something that small reads as grime rather than as depth.

`@utility glass-control` (`globals.css:1612–1617`):
```
background-color: color-mix(in oklab, var(--foreground) 7%, transparent);
box-shadow:
  inset 0 1px 0 var(--rim-strong),
  inset 0 0 0 1px color-mix(in oklab, var(--foreground) 16%, transparent);
```
- Fill: `--foreground` @ **7%** — dark `rgba(250,250,250,0.07)`, light `rgba(9,9,11,0.07)`
- Rim: `--foreground` @ **16%** — dark `rgba(250,250,250,0.16)`, light `rgba(9,9,11,0.16)`
- **No blur, no saturate, no outer shadow.** Two inset layers only.

### 7.3 · The `Note` — `<Note className="mt-6" title="Neither needs a dark: variant">`

Default tone (`action`), so `border-action/30 bg-action/[0.08] text-action-ink`, `rounded-lg border p-5`, 24px above. Title verbatim: **"Neither needs a dark: variant"** (a bare `dark:` with the colon — that is the class-variant prefix, not a typo).

Body, verbatim (three `Code` chips):
> Both mix from `--card` and `--foreground`, so a light edge on dark and a dark edge on light fall out of the same expression. The top highlight is `--rim-strong` — the same token every raised control carries, which is what keeps a glass card in the same world as a button.

### 7.4 · What these specimens actually render (verification targets)

Both glass boxes sit on the Panel body, which is opaque `bg-background`. **The backdrop is a flat colour**, so the 24px blur is a no-op and `saturate(1.5)` on a near-neutral is nearly one. The composited fills:

| specimen | theme | backdrop | after saturate(1.5) | after fill | ≈ |
|---|---|---|---|---|---|
| `glass-panel` | dark | `#09090B` | rgb(8.93, 8.93, 11.93) | `rgba(24,24,27,0.74)` over it | **rgb(20,20,23)** `#141417` |
| `glass-panel` | light | `#FFFFFF` | `#FFFFFF` (neutral is fixed) | `rgba(255,255,255,0.74)` | **`#FFFFFF`** — the fill is invisible; only the rim and `e2` describe the shape |
| `glass-control` | dark | `--card` `#18181B` | n/a (no filter) | `rgba(250,250,250,0.07)` | **rgb(40,40,43)** `#28282B` |
| `glass-control` | light | `--card` `#FFFFFF` | n/a | `rgba(9,9,11,0.07)` | **rgb(238,238,238)** `#EEEEEE` |

### 7.5 · Why `glass-panel-deep` exists (and why it is not on this page)

`globals.css:1586–1609` defines a **third** utility the page never mentions. Recorded here because the section copy says "Two utilities, one material" and that is only true of what is *shown*:

- `glass-panel-deep` is byte-identical to `glass-panel` except its ambient layer is `var(--shadow-e4)` instead of `--shadow-e2`.
- It exists because **`glass-panel shadow-e4` does not work**: both own `box-shadow`, both are Tailwind utilities, and whichever Tailwind emits later wins outright — so the glass rim and the top highlight vanish and you are left with a translucent rectangle and a drop shadow. Measured, not reasoned: `getComputedStyle(panel).boxShadow` came back with no `inset` layer at all. Stacking any `shadow-*` on either glass utility fails the same way, which is why the elevation is chosen inside the utility rather than at the call site.
- `e4` rather than `e2` because elevation reads as a ratio of object to shadow: the ambient depth that floats a 400px dialog leaves a 1440px panel looking welded down.

**Port implication:** if the Flutter glass helper takes a `ShadowSpec` parameter, the CSS failure mode does not reproduce — but the *two named variants* should still exist so `glass-panel-deep` has a home, and the section copy should still say "Two utilities" verbatim.

---

## 8 · Section `#rules` — "Rules" (no description)

`DoDont`: `grid gap-4 sm:grid-cols-2`.
- **Do panel**: `rounded-lg border border-value/25 bg-value/[0.06] p-5` — border `rgba(163,230,53,0.25)`, fill `rgba(163,230,53,0.06)`; heading `type-label mb-3 text-value-ink` → "Do"; `<ul class="space-y-2.5">` (10px); items `flex gap-2.5` = `Icon icon={Check} size="sm" tone="value" className="mt-0.5"` (14px, strokeWidth 2.4, `--value-ink`, 2px down) + `<span class="type-small text-muted-foreground">`.
- **Don't panel**: `border-destructive/25 bg-destructive/[0.06]` — `rgba(220,38,38,0.25)` / `rgba(220,38,38,0.06)`; heading `text-destructive-ink` → "Don't" (rendered `Don&rsquo;t`, U+2019); `Icon icon={X} size="sm" tone="error"`.

Dos (verbatim, 4):
1. "Use the surface ladder plus a hairline for depth first; add a shadow only to confirm it."
2. "Give anything pressable a machine shadow, and sink it to shadow-btn-down on active."
3. "Keep every field in a sunken shadow-pressed socket."
4. "Reserve the two glows for selection and reward."

Don'ts (verbatim, 4):
1. "Don't put an ambient shadow on a control — it will read as floating rather than pressable."
2. "Don't raise an input; recessed is what makes it read as editable."
3. "Don't glow a resting surface, and never glow navigation."
4. "Don't invent a shadow inline — every value is a token."

Note: the apostrophes inside the four don'ts are **straight quotes `'`** in the source array (only the panel heading uses `&rsquo;`). `shadow-btn-down` and `shadow-pressed` in dos 2 and 3 are **plain text**, not `Code` chips — `DoDont` takes `string[]`.

---

## 9 · Foot nav (`PageFootNav groupId="foundations" slug="shadows"`)

`<nav class="mt-8 flex items-stretch gap-4 border-t border-border pt-8">`. Both siblings exist (`nav.ts` foundations order: colors → typography → spacing → **shadows** → motion → icons):

- **Previous** → title **"Spacing & Layout"**, href `/design-system/spacing`. Link: `press flex min-w-0 flex-1 items-center gap-3 rounded-lg border border-border bg-card px-5 py-4 hover:border-input`; `Icon icon={ArrowLeft} size="md" tone="muted"` (16px, stroke 2.4); caption `type-micro block text-muted-foreground` "Previous" (10.5px/1/600/uppercase/0.18em); title `type-small mt-1 block truncate text-foreground`.
- **Next** → title **"Motion"**, href `/design-system/motion`. Mirrored: `justify-end … text-right`, ArrowRight after the text.

`press` = `transition: transform 250ms --ease-spring`; `:active { transform: scale(0.94); transition-duration: 40ms }`.

---

## 10 · Motion inventory for this page

No entrance or scroll-triggered animation anywhere. Everything that moves:

| # | where | trigger | spec |
|---|---|---|---|
| 1 | `action-feedback::before` (default Button) | hover | `action-beat 2.6s --ease-out infinite` |
| 2 | `action-feedback::before` | active | `action-beat 620ms --ease-out 1` |
| 3 | `premium-surface::after` (premium Button) | always | `value-foil-drift 11s linear infinite` |
| 4 | `premium-surface::after` | hover | `opacity 0.95 → 1` (via `btn-spring`, 250ms) |
| 5 | `premium-surface::before` | always | `value-glint 5.5s --ease-in-out infinite` |
| 6 | `premium-surface::before` | hover | `animation-duration → 2.4s` |
| 7 | all five Buttons | any state change | `btn-spring` — 250ms `--ease-spring`, 80ms while `:active` |
| 8 | all five Buttons | active | `scale(0.95)` |
| 9 | Input | focus | `transition-[box-shadow,border-color,background-color] 250ms --ease-out` |
| 10 | foot-nav links | active | `press` — `scale(0.94)`, 40ms in / 250ms spring out |
| 11 | foot-nav links | hover | `border-color` → `--input` at the framework default, repointed to 250ms `--ease-out` (`globals.css:395–396`) |
| 12 | anchors | click | smooth scroll, 96px `scroll-padding-block-start`; forced to `auto !important` under `prefers-reduced-motion: reduce` |

**The 14 shadow specimens in §3 and §4, the two glow cells and the two glass cells are entirely static** — no hover, no press, no animation. `--shadow-key` / `--shadow-key-down` are shown as *stills*; the `press-key` utility that animates between them (`globals.css:2307–2317`: `transform + box-shadow` at 80ms **linear**, `:active { translateY(3px) }`) is named in the copy but **not demonstrated**.

Reduced motion: nothing on this page has a `prefers-reduced-motion` guard of its own. The two infinite foil animations keep running. Flag as an open question (§14).

---

## 11 · Token reference

### 11.1 · Ink, rim, wall (the only theme-dependent part of every shadow)

| token | dark (`globals.css:820–826`) | light (`globals.css:610–616`) |
|---|---|---|
| `--ink-1` | `rgb(0 0 0 / 0.35)` | `hsl(240 20% 20% / 0.04)` = `rgba(41,41,61,0.04)` |
| `--ink-2` | `rgb(0 0 0 / 0.5)` | `rgba(41,41,61,0.07)` |
| `--ink-3` | `rgb(0 0 0 / 0.6)` | `rgba(41,41,61,0.11)` |
| `--ink-4` | `rgb(0 0 0 / 0.75)` | `rgba(41,41,61,0.16)` |
| `--rim` | `rgb(255 255 255 / 0.14)` | `rgba(255,255,255,0.85)` |
| `--rim-strong` | `rgb(255 255 255 / 0.28)` | `rgba(255,255,255,0.40)` |
| `--wall` | `hsl(240 6% 8%)` = `#131316` | `hsl(240 6% 82%)` = `#CECED4` |

### 11.2 · Every other colour this page renders

| token | dark | light |
|---|---|---|
| `--background` | `#09090B` | `#FFFFFF` |
| `--foreground` | `#FAFAFA` | `#09090B` |
| `--card` | `#18181B` | `#FFFFFF` |
| `--muted` | `#27272A` | `#F4F4F5` |
| `--muted-foreground` | `#D4D4D8` | `#62626A` |
| `--border` | `#27272A` | `#E4E4E7` |
| `--input` | `#3F3F46` | `#E4E4E7` |
| `--secondary` | `#27272A` | `#F4F4F5` |
| `--secondary-foreground` | `#FAFAFA` | `#18181B` |
| `--accent` | `#3F3F46` | `#F4F4F5` |
| `--primary` | `#1A6EF4` | `#1A6EF4` |
| `--primary-foreground` | `#FFFFFF` | `#FFFFFF` |
| `--ring` | `#92C2FC` (`--color-action-bright`) | `#1A6EF4` (`--color-action`) |
| `--action-ink` | `#92C2FC` | `#143694` |
| `--value-ink` | `#D9F99D` | `#4D7C0F` |
| `--destructive` | `#DC2626` | `#DC2626` |
| `--destructive-ink` | `#F87171` | `#CA2121` (`hsl(0 72.2% 46%)`) |
| `--color-action-bright` / `--color-action` / `--color-action-dark` | `#92C2FC` / `#1A6EF4` / `#143694` | same |
| `--color-value-bright` / `--color-value` / `--color-value-dark` | `#D9F99D` / `#A3E635` / `#4D7C0F` | same |
| `--color-value-foreground` | `#121216` | **same — deliberately does not flip** |

### 11.3 · Type classes used (all from `globals.css` `@layer components`)

| class | line | size | lh | weight | tracking | colour |
|---|---|---|---|---|---|---|
| `type-h1` | 1070 | clamp(2rem,2.8vw,2.5rem) | 1.1 | 700 | −0.02em | — |
| `type-h3` | 1084 | 1.3125rem (21) | 1.3 | 600 | −0.01em | — |
| `type-lead` | 1099 | 1.0625rem (17) | 1.65 | 400 | — | muted |
| `type-small` | 1120 | 0.8125rem (13) | 1.5 | 400 | — | muted |
| `type-chip` | 1145 | 0.71875rem (11.5) | 1.2 | 500 | — | — |
| `type-code` | 1157 | mono 0.78125rem (12.5) | 1.4 | — | — | — |
| `type-label` | 1164 | 0.6875rem (11) | 1 | 600 | 0.16em, upper | muted |
| `type-micro` | 1218 | 0.65625rem (10.5) | 1 | 600 | 0.18em, upper | muted |
| `type-num-sm` | 1271 (+1257 shared) | mono 0.75rem (12) | 1.2 | 600 | −0.01em, tabular | — |

`leading-snug` (Tailwind default `--leading-snug: 1.375`, not overridden) is applied to the 12 `type-small` use-copy paragraphs in §3 and §4 only.

---

## 12 · Drift register (record, do not fix)

1. **`--shadow-btn`'s use copy vs `button.tsx`.** The specimen says *"Secondary, outline and destructive buttons."* Only `outline` carries `shadow-btn`. `secondary` (`bg-secondary text-secondary-foreground hover:bg-accent`) and `destructive` (`border-destructive/25 bg-destructive/10 …`) declare **no** shadow class at all. Visible on this very page: "View Hits" is flat, "Filters" is a machine surface.
2. **The `#in-use` caption vs its own specimens.** *"Buttons carry `shadow-btn` or `shadow-btn-primary` and drop to `shadow-btn-down` on `:active`."* The premium button carries `shadow-btn-value` (and swaps to `shadow-glow-value` on hover), and two of the five carry nothing.
3. **`glass-control` copy says 44px; the specimen is `h-12` = 48px.** The CSS comment (`globals.css:1544`) also says "a 44px disc". Three places, one number, and the render is 48.
4. **"Two utilities, one material"** — there are three (`glass-panel`, `glass-panel-deep`, `glass-control`). The panel label narrows honestly to `"glass-panel and glass-control"`; the section description does not.
5. **Glow cell border class differs from the spacing page.** Here `border-primary/40` (cell 1) and `border-value/40` (cell 2); spacing uses `border-action/40` and `border-value/40`. Identical pixels (`--primary` = `var(--color-action)`), different source.
6. **Glow captions differ across pages.** Shadows: "Says …", "Celebrated tiers, reward unlocks, premium actions". Spacing: "Signals …", "Legendary or mythic reveal, reward unlock, premium action". Same two glows, two copies.
7. **The Input JSDoc claims "a placeholder at 60% muted"**; the class is `placeholder:text-muted-foreground` at full opacity. The prose describes an intent the class never carried.
8. **`--shadow-key` / `--shadow-key-down` copy names the `press-key` utility**, which exists (`globals.css:2307`) but is never demonstrated — the two tokens render as unrelated stills side by side rather than as one key in two positions.
9. **`--radius-4xl` is used here (32px) but the spacing page's radius ladder claims "Seven steps" and stops at `3xl` 24px** — carried over from `spacing-map.md` drift 2; this page is where the undocumented step actually renders.
10. **Fonts:** globals prose and `nav.ts` blurbs say Space Grotesk; `--font-sans`/`--font-heading` are `"Inter Local"`. Per project decision, fonts follow tokens.

---

## 13 · CSS → Flutter conversion notes

### 13.1 · Blur is 2×sigma for `box-shadow`, 1×sigma for `filter`

- **`box-shadow`**: CSS spec — the shadow approximates a Gaussian with `sigma = blur-radius / 2`. `ShadowLayer` stores the **raw CSS blur** and inverts Flutter's `Shadow.convertRadiusToSigma(r) = r * 0.57735 + 0.5` in `blurRadius` (`lib\src\design_system\foundation\shadows.dart:72–77`). Nothing on this page should recompute it.
- **`backdrop-filter: blur(24px)`**: CSS Filter Effects — the parameter **is** the standard deviation. So `ImageFilter.blur(sigmaX: 24, sigmaY: 24)` — **no halving**. `Blurs.xl = 24` (`spacing.dart:124`) is already correct and already used this way in `shell.dart:174`.
- **Known limit that bites on this page:** Flutter's `+0.5` makes sigmas below 0.5 unreachable, so `blurRadius` floors to 0. Two layers on this page are affected — `--shadow-e1`'s `0 1px 1px --ink-2` (σ 0.5) and `--shadow-btn-down`'s `0 1px 1px --ink-1` (σ 0.5). Both render as hard 1px edges rather than a half-pixel smear. Documented at `shadows.dart:69–71`; accept it, don't work around it.

Sigma table for every layer on this page:

| CSS blur | 1 | 2 | 3 | 4 | 5 | 8 | 10 | 12 | 28 | 34 | 56 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| σ | 0.5 | 1 | 1.5 | 2 | 2.5 | 4 | 5 | 6 | 14 | 17 | 28 |

### 13.2 · Paint order

CSS paints the **first-listed** shadow on top. `ShadowSpec.outerShadows` reverses the list for `BoxDecoration.boxShadow` (`shadows.dart:100–103`). `MachineSurface` paints fill → inset shadows → border → content, which is CSS's order and is what keeps `inset 0 1px 0 var(--rim)` **under** the border rather than over it (`surface.dart:22–25`).

### 13.3 · Border-box

`border border-transparent` + `bg-clip-padding` on the Button means the visible fill is inset 1px on every side while the shadow is drawn from the border box. `MachineSurface` already applies `border!.dimensions` as padding (`surface.dart:64–74`), matching the `border-box` fix already landed in the port.

### 13.4 · Blend modes and stacking

`isolate` on the Button creates a stacking context, so `mix-blend-mode` on `::before`/`::after` composites **against the button's own background only**. In Flutter: paint the ramp, then each texture layer inside a `saveLayer` scoped to the button's clipped pill, with `BlendMode.softLight` / `BlendMode.screen` / `BlendMode.multiply`. The theme split is one line: sheen `::before` is `multiply` on light and `screen` on dark; everything else keeps one mode in both themes.

### 13.5 · `backdrop-saturate-150`

No Flutter equivalent ships with `BackdropFilter`. Compose `ColorFilter.matrix` with the SVG `feColorMatrix type="saturate"` coefficients (0.213 / 0.715 / 0.072) at s = 1.5:

```
 1.3935  -0.3575  -0.0360  0  0
-0.1065   1.1425  -0.0360  0  0
-0.1065  -0.3575   1.4640  0  0
 0        0        0       1  0
```

On this page it is visually inert (see §7.4) — the backdrop is a flat neutral — but it belongs in the utility so the utility is reusable.

---

## 14 · Exists in the port / missing

Package root `D:\DESIGN\Design-System-2026-8\flutter-design-system\`.

### 14.1 · Already built — reuse, do not re-derive

| need | where |
|---|---|
| All 14 `--shadow-*` tokens, layer-for-layer | `lib\src\design_system\foundation\shadows.dart` — `Shadows.sm..e4` (:159–177), `key` (:184), `keyDown` (:190), `pressed` (:197), `btn` (:204), `btnPrimary` (:214), `btnValue` (:224), `btnDown` (:232), `chip` (:239), `glowAction` (:249), `glowValue` (:257) |
| CSS→Skia blur inversion + CSS paint order | `ShadowLayer.blurRadius` (:72), `ShadowSpec.outerShadows` (:100) |
| Inset-shadow painting | `lib\src\components\ui\surface.dart` — `MachineSurface` (:26), `debugInsetRing` (:56) |
| Ink / rim / wall per theme | `ThemeData.ink1..ink4` (:243–255), `rim` (:260), `rimStrong` (:264), `wall` (:268) in `lib\src\design_system\foundation\theme.dart` |
| oklab mixing | `Oklab.mix` (`lib\src\design_system\foundation\colors.dart:116`) |
| Ramp colours incl. `valueForeground` | `Palette` (`colors.dart:304–357`) |
| Radii incl. `xl4` = 32 and `pill` = 999 | `Radii` (`lib\src\design_system\foundation\spacing.dart:78–106`) |
| `Blurs.xl = 24` | `spacing.dart:124` |
| Durations / curves / transforms | `Durations`, `Curves`, `Transforms` (`lib\src\design_system\foundation\motion.dart`) — incl. `keyDownY = 3` (:106), `buttonScale = 0.95` (:99) |
| Every type class used here | `Type.h1/h3/lead/small/chip/code/label/micro/numSm` (`lib\src\design_system\foundation\typography.dart`) |
| Docs kit | `example\lib\kit.dart` — `PageHeader` (:48), `Section` (:142), `Panel` (:236), `Code` (:442, with hyphen-aware `span` at :508), `DoDont` (:641), `Note` (:740), `Grid` (:814), `PageFootNav` (:1062) |
| Nav entry for `shadows` — slug, title, blurb, all six chips | `example\lib\nav.dart:146–159`, already guarded by `example\test\nav_test.dart:169` |
| Siblings (prev Spacing & Layout, next Motion) | `siblings()` at `nav.dart:731` — already resolves |
| Shell, routing, page glow, thin scrollbar | `example\lib\shell.dart`, `lib\src\components\ui\background_effect.dart` |
| Closest structural template | `example\lib\pages\spacing.dart` `_ElevationSection` (:377), `_ElevationCell` (:420), `_GlowCell` (:493) — but these paint **outer-only** via `BoxDecoration`; every machine specimen must go through `MachineSurface` instead |

### 14.2 · Missing — must be built

| # | missing | notes |
|---|---|---|
| 1 | `example\lib\pages\shadows.dart` + a `switch` arm at `example\lib\main.dart:104` | route currently falls through to `PlaceholderPage` ("Not ported yet") |
| 2 | **`glass-panel` / `glass-panel-deep` / `glass-control`** | nothing in `lib\` implements them; only `Blurs.xl`'s doc comment names the utility |
| 3 | **`backdrop-saturate`** | port has `BackdropFilter` blur only (`shell.dart:174`, `sheet.dart:248`); needs the §13.5 matrix |
| 4 | **`action-feedback`** | ramp + static texture + `action-beat`; theme-split blend mode |
| 5 | **`premium-surface`** | metal ramp + drifting foil + sweeping glint; two infinite animations |
| 6 | **Button variants `default`, `premium`, `secondary`** | `lib\src\components\ui\button.dart:28` ships **only** `outline` and `ghost`. `destructive` and `link` are not needed by this page. Enum is already shaped to take them without a rename (`button.dart:5–8`). |
| 7 | **An Input / text-field widget** | nothing in the package. `Shadows.inset` exists with **no consumer**. Needs: 40px pill, `--input` border, `--card` fill, `shadow-pressed` inset socket, placeholder, focus ring `0 0 0 3px --ring @35%` + border `--primary @50%`, 250ms `--ease-out`. |
| 8 | **A focus-ring helper** | `focus-visible:ring-3` composited in front of the element's own shadow — needed by both Button and Input |
| 9 | **`press-key` widget** | `Shadows.keyRaised`/`keyDown` and `Transforms.keyDownY` exist, nothing wires them. Only needed if §4's stills are ever made interactive — the reference does **not** animate them. |
| 10 | **`_referenceHeight` entry for `/design-system/shadows`** | `example\test\vertical_parity_probe_test.dart:45` — must be measured off the live web dev server at the 1440 frame before the page can pass parity |
| 11 | **Wrap-parity expectations** | `example\test\wrap_parity_probe_test.dart` — this page has long `leading-snug` use strings in a 3-column and a 4-column grid; expect a dense break table |
| 12 | Page test | model on `example\test\spacing_page_test.dart` |

### 14.3 · Guard-test constraints the new page must satisfy

`test\token_guard_test.dart` (rules at :40–53) forbids, outside `lib\src\foundation\`: `Color(0x`, `Color.from`, `fontSize:<digit>`, `letterSpacing:<digit>`, `FontWeight.w<digit>`, `Curves.`, `Duration(milliseconds:<digit>`, `BorderRadius.circular(<digit>`, and **`BoxShadow(`**. Escape hatch is `// allow-hardcoded: <reason>` on the line.

Consequences for this page:
- Every specimen must reach its shadow through a `Shadows.*` spec — no literal `BoxShadow(`.
- `rounded-4xl` must be `Radii.xl4`, `rounded-pill` must be `Radii.full`.
- The foil/sheen gradient stops are literal colours → they belong in `lib\src\foundation\` (a `Palette`-adjacent effects-colour block) or in `lib\src\effects\` with an explicit escape-hatch comment. **Prefer: derive them at runtime with `Oklab.mix` from `Palette` so a rebrand carries** — that is what the CSS does, and `colors.dart:116` already provides it. The resolved hexes in §5.3/§5.4 are then verification targets, not source.
- `action-beat` / `value-glint` / `value-foil-drift` timings must come from named constants; `--duration-*` covers 80/250 but **2.6s, 620ms, 11s, 5.5s and 2.4s have no token** — see open question 3.

---

## 15 · Open questions for the supervisor

1. **`--referenceHeight` for the shadows route.** The vertical parity probe needs a measured number from the live web page at 1440×900 with the real fonts. Should I take that measurement (dev server + `scratchpad/measure-vertical.js`) as part of this build, or is it supplied?
2. **Infinite animations vs the parity probe.** `premium-surface` runs two forever-loops. The probe pumps widgets and measures geometry, so it should be unaffected, but a widget test with an unbounded `AnimationController` will hang `pumpAndSettle`. Confirm the page tests should use `pump(Duration)` rather than `pumpAndSettle`, and whether the foil should be frozen under a test flag.
3. **Where do the effect timings live?** 2.6s, 620ms, 11s, 5.5s, 2.4s are written inline in globals.css and are not on the `--duration-*` scale. Add them as `Durations.beatHover` / `beatPress` / `foilDrift` / `glint` / `glintHover` in `lib\src\design_system\foundation\motion.dart` (a token the CSS does not have), or hold them in the effects file with escape-hatch comments? The former is cleaner but invents tokens the reference lacks.
4. **Reduced motion.** The reference has no `prefers-reduced-motion` guard on the foil or the beat. `elAnimationDuration` (`theme_scope.dart:332`) exists in the port. Do we mirror the reference exactly (foil keeps drifting under reduced motion), or apply the port's gate and accept the divergence?
5. **Button variant scope.** This page needs `default`, `premium` and `secondary` added to `ButtonVariant`. Build all three plus `destructive` and `link` now (completing the enum for the future buttons page), or exactly the three this page renders?
6. **The Input.** No text-entry widget exists. Build a real focusable `Input` (editable, keyboard focus, caret) so "focus the field" in the section description is literally true, and so `--shadow-pressed` finally has a consumer? Or a non-editable specimen that only demonstrates the two shadow states?
7. **`glass-panel-deep`.** Not rendered on this page. Build it now alongside its sibling (the CSS pairs them and §7.5 explains why), or defer until a page shows it?
8. **Drift 3 (44px vs `h-12` 48px).** Confirmed: render the specimen at 48px and print the copy saying 44px, per the fidelity bar. Flagging because it is the one drift where copy and pixels contradict on the same line.
