# Map — `/design-system/spacing` (Foundations · Spacing & Layout)

**Files that produce the render** (all under `D:\DESIGN\Design-System-2026-8\design-system\`):
- `app\design-system\spacing\page.tsx` — the page (server component, no client code, no local components; all data in three module-level arrays: `spacing`, `radii`, `elevation`)
- `components\ds\kit.tsx` — `DsPageHeader`, `DsSection`, `Panel`, `Meta`, `Code`, `DoDont`, `Note`, `PageFootNav` (all used)
- `components\ui\icon.tsx` — `Icon` (used inside `DoDont` and `PageFootNav`)
- `lib\ds\nav.ts` — `findCategory("foundations","spacing")` supplies header copy; `siblings()` supplies foot-nav
- `app\design-system\layout.tsx` — shell around the page
- `app\globals.css` — every token/class referenced below
- `app\layout.tsx` — loads `GeistMono` (`--font-geist-mono`) on `<html>`

---

## 0 · Shell / layout metrics (what frames the page)

- Root `<body>`: `bg-background text-foreground`, plus fixed page-glow: `background-image: radial-gradient(120% 90% at 62% 34%, var(--page-glow) 0%, transparent 64%)`, `background-attachment: fixed`, antialiased. `--page-glow`: dark `hsl(240 8% 10%)`, light `hsl(240 30% 98%)`.
- Sticky site header: `sticky top-0 z-40 flex h-(--height-site-header) [4rem/64px] items-center gap-4 border-b border-border bg-background/85 px-6 backdrop-blur-xl`. Contents: mobile-nav trigger (`lg:hidden`, outline icon Button in a Sheet `w-72`), Logo link (`press`), pill "Design System v0.1" (`type-micro rounded-pill border border-border px-2.5 py-1`, `hidden sm:block`), right-aligned `type-micro hidden md:block` text: **"Desktop-first · 1440 frame · Light & dark"**, ThemeToggle.
- Frame: `mx-auto flex w-full max-w-(--width-shell)` = **1680px**. Sidebar: `sticky top-16 hidden lg:block w-60` (240px) `h-[calc(100dvh-4rem)] overflow-y-auto border-r border-border px-6 pt-10`. Main: `min-w-0 flex-1 px-6 py-12 lg:px-12`; inner column `mx-auto max-w-(--width-content)` = **1080px**.
- Anchor scrolling: `html { scroll-behavior: smooth; scroll-padding-block-start: var(--scroll-offset) }` where `--scroll-offset = calc(4rem + var(--spacing)*8)` = **96px**. Sections carry no `scroll-mt-*`.
- Spacing unit: Tailwind default `--spacing: 0.25rem` (4px). Focus ring everywhere: `outline: 2px solid var(--ring); outline-offset: 2px` (ring = action-bright on dark, action on light). `::selection`: `color-mix(in oklab, var(--color-action) 35%, transparent)`.

**Fonts (drift — report both sides):** globals.css prose says "Space Grotesk owns words", and nav.ts's typography blurb says the same; the tokens say `--font-sans`/`--font-heading` = **"Inter Local"** (local variable woff2, weight 100–900). Everything worded on this page renders Inter Local. All `.type-num*` / `.type-code` render **Geist Mono** (`--font-mono: var(--font-geist-mono)`). Per project memory: fonts follow tokens, not prose.

---

## 1 · Page header (`DsPageHeader`)

`<header class="mb-14 border-b border-border pb-10">` (56px below, 40px inner bottom)
1. Eyebrow: `type-label text-action-ink` → **"Foundations"** — 11px/1, 600, uppercase, tracking 0.16em; color `--action-ink` (dark: `hsl(213 94% 78%)` ≈ #92C2FC; light: `hsl(224 76% 33%)` ≈ #143694).
2. `<h1 class="type-h1 mt-4 text-foreground">` → **"Spacing & Layout"** — `clamp(2rem, 2.8vw, 2.5rem)` (32–40px), lh 1.1, 700, tracking −0.02em.
3. Blurb `type-lead mt-4 max-w-2xl` (672px) → **"The 8-point spacing scale, radius ladder, elevation set, 12-column grid and responsive breakpoints."** — 17px, lh 1.65, 400, `--muted-foreground`.
4. Chips `ul.mt-7 flex flex-wrap gap-2`; each `type-chip rounded-pill border border-border bg-card px-3 py-1.5 text-muted-foreground` (11.5px/1.2, 500; radius 999px). Verbatim, in order: **Spacing scale · Radius · Elevation · Grid · Breakpoints · Content width**.

---

## 2 · Section `#scale` — "Spacing scale"

`DsSection` shell (all sections): `<section class="mb-20">` (80px); heading block `mb-6`; `<h2 class="type-h3 text-foreground">` — 21px (1.3125rem)/1.3, 600, −0.01em; description `type-small mt-2 max-w-2xl` — 13px/1.5, 400, muted.

Heading: **"Spacing scale"**
Description (verbatim): **"An 8-point system with a 4px half-step for tight interior spacing. Tailwind's default 0.25rem unit already matches, so the class number is simply the pixel value divided by four."**

**Token list rendering** — container `overflow-hidden rounded-xl (16px) border border-border bg-card`; 10 rows, each: `grid items-center gap-4 border-b border-border px-6 py-4 last:border-b-0 sm:grid-cols-[4rem_5rem_1fr] sm:gap-6` (24px h-pad, 16px v-pad; columns 64px / 80px / flex at ≥640px, single stacked column with 16px gap below that; 1px hairline between rows).
- Col 1: `type-num text-foreground` — Geist Mono 15px/1.2, 600, tabular-nums, −0.01em — text "4px" … "80px".
- Col 2: `type-num-sm text-action-ink` — mono 12px/1.2, 600, tabular — text `gap-1` … `gap-20`.
- Col 3: `flex items-center gap-4` containing **the bar**: `h-3 (12px) shrink-0 rounded-sm (6px) bg-action` with inline `style={{ width: s.px }}` — a solid #1A6EF4 bar exactly N px wide — then the use copy in `type-small`.

| px (bar width) | class | use copy (verbatim) |
|---|---|---|
| 4 | gap-1 | Icon-to-label inside a badge. Pip gaps. |
| 8 | gap-2 | Between related controls. Chip gaps. |
| 12 | gap-3 | Inside compact rows. Grid gutters on mobile. |
| 16 | gap-4 | Default card padding. Standard grid gutter. |
| 24 | gap-6 | Card padding on desktop. Between cards in a grid. |
| 32 | gap-8 | Between modules inside a section. |
| 40 | gap-10 | Section inner spacing. |
| 48 | gap-12 | Between page sections. |
| 64 | gap-16 | Between major page sections. |
| 80 | gap-20 | Above and below a hero. The largest step. |

**Note (tone="error"), `mt-4`** — anatomy: `rounded-lg (12px) border p-5 (20px)`, error tone = `border-destructive/30 bg-destructive/[0.08] text-destructive-ink` (`--destructive: hsl(0 72.2% 50.6%)`; ink dark #f87171, light `hsl(0 72.2% 46%)`). Title `type-label mb-2` (inherits the tone's ink color): **"The only spacing rule"**. Body `type-small text-muted-foreground`: **"If a gap is not on this scale, it is wrong. There is no 18px, no 30px and no 50px anywhere in the product."**

*Internal drift:* the kit chrome around this very page uses off-scale steps the table doesn't list — `p-5`/`gap-5` (20px), `py-1.5` (6px), `mt-7` (28px), `mb-14` (56px), `space-y-2.5`/`gap-2.5` (10px). The rule copy governs product gaps; the docs chrome does not obey the ten-step list. Port as written (exact class values), not as the rule implies.

---

## 3 · Section `#radius` — "Radius ladder"

Description (verbatim): **"Radius encodes size: the bigger the surface, the softer the corner. This overrides shadcn's computed radius scale with explicit values."**

**Panel anatomy** (used by all panels on the page): container `overflow-hidden rounded-xl border border-border bg-card`; header strip (when label/note present) `flex items-baseline justify-between gap-4 border-b border-border bg-muted px-5 py-3`; label `type-label text-muted-foreground`; note (right side) `type-num-sm text-muted-foreground`; body `bg-background p-6` (24px) — note the body is `--background`, not the card color.

Panel label: **"Seven steps"**. Body: `flex flex-wrap gap-5` (20px). Seven items, each `w-36` (144px):
- Demo box: `grid h-24 (96px) place-items-center border border-input bg-muted`, inline `style={{ borderRadius: r.px }}` (border uses `--input`: dark `hsl(240 5.3% 26.1%)`, light `hsl(240 5.9% 90%)`; fill `--muted`).
- Inside the box: `type-num-sm text-muted-foreground` showing `6px`, `10px`, `12px`, `16px`, `20px`, `24px`, and for pill literally **"999"** (no px suffix — special-cased).
- Under the box: `type-num-sm mt-3 text-action-ink` → `rounded-sm` … `rounded-pill`; then `type-small mt-1 leading-snug` use copy.

| name | px | use copy (verbatim) |
|---|---|---|
| sm | 6 | Badges, pips, small chips, inline code. |
| md | 10 | Buttons, inputs, rows, dropdown items. The default. |
| lg | 12 | Cards, pack cards, collectible tiles, panels. |
| xl | 16 | Large cards, dialogs, feature panels. |
| 2xl | 20 | Promotional panels, pack stage. |
| 3xl | 24 | The landing hero panel. Largest allowed. |
| pill | 999 | Pills, filter chips, avatars, live indicator. |

Tokens confirm all seven (`--radius-sm:6px; -md:10px; -lg:12px; -xl:16px; -2xl:20px; -3xl:24px; -pill:999px`). *Drift:* the token ladder has **nine** steps — `--radius-xs: 2px` (tips/swatches only) and `--radius-4xl: 32px` (soft-slab) exist in globals.css but are not shown on this page ("Seven steps" and "3xl … Largest allowed" are the page's claim; the tokens go further).

---

## 4 · Section `#elevation` — "Elevation"

Description (verbatim): **"Four neutral depth steps, plus two glows that are strictly rationed. On a near-black background a shadow reads as a soft darkening, so depth mostly comes from the surface ladder — shadows only confirm it."**

### Panel 1 — label "Neutral depth"
Body: `grid gap-6 sm:grid-cols-2 lg:grid-cols-4` (1-col < 640, 2-col ≥ 640, 4-col ≥ 1024). Four cells:
- Demo box: `grid h-24 place-items-center rounded-lg (12px) border border-border bg-card shadow-e{1..4}`; centered `type-num-sm text-muted-foreground` showing the class name (`shadow-e1` …).
- Below: token name `type-num-sm mt-3 text-action-ink` (`--shadow-e1` …), then `type-small mt-1 leading-snug` use copy.

| token | use copy (verbatim) |
|---|---|
| --shadow-e1 | Resting rows, chips, table headers. Barely there. |
| --shadow-e2 | Cards and pack cards at rest. |
| --shadow-e3 | Hovered cards, popovers, dropdowns, sticky bars. |
| --shadow-e4 | Dialogs, drawers, the pack-opening stage. |

Exact shadow geometry (theme-independent), ink per theme:
- `--shadow-e1: 0 1px 1px var(--ink-2), 0 1px 3px var(--ink-1)`
- `--shadow-e2: 0 1px 2px var(--ink-2), 0 4px 10px -2px var(--ink-2)`
- `--shadow-e3: 0 2px 4px var(--ink-2), 0 14px 28px -8px var(--ink-3)`
- `--shadow-e4: 0 4px 8px var(--ink-3), 0 28px 56px -14px var(--ink-4)`
- Dark ink: `--ink-1: rgb(0 0 0/.35); --ink-2: rgb(0 0 0/.5); --ink-3: rgb(0 0 0/.6); --ink-4: rgb(0 0 0/.75)`.
- Light ink: `--ink-1: hsl(240 20% 20%/.04); --ink-2: /.07; --ink-3: /.11; --ink-4: /.16`.

### Panel 2 — label "Rationed glow", note **"Selected · rare · premium only"**, `mt-4`
Body: `grid gap-6 sm:grid-cols-2`. Two cells:
1. Box `glow-action grid h-24 place-items-center rounded-lg border border-action/40 bg-card` (border = `--color-action` at 40% alpha); centered `type-num-sm text-action-ink` → "glow-action". Caption `type-small mt-3`: **"Selected pack, focused primary CTA, active opening stage. Signals *this is the thing you chose*."** (the final clause is an `<em>`, italic).
2. Box `glow-value … border-value/40`; label `type-num-sm text-value-ink` → "glow-value" (`--value-ink`: dark #d9f99d, light #4d7c0f). Caption: **"Legendary or mythic reveal, reward unlock, premium action. Signals *this is worth something*."** (em italic).

Glow values:
- `--shadow-glow-action: 0 0 0 1px color-mix(in oklab, var(--color-action-bright) 45%, transparent), 0 10px 34px -8px color-mix(in oklab, var(--color-action) 60%, transparent)`
- `--shadow-glow-value: 0 0 0 1px color-mix(in oklab, var(--color-value) 45%, transparent), 0 10px 34px -8px color-mix(in oklab, var(--color-value) 42%, transparent)`
- Ramps: action-bright `hsl(213 94% 78%)` #92C2FC · action `hsl(217 91% 53%)` #1A6EF4 · value #a3e635.

---

## 5 · Section `#grid` — "Grid and content width"

Description (verbatim): **"Desktop-first on a 1440px frame. Content is capped so that grids never stretch into unreadable rows on ultrawide displays. Every measure below is a token; this section used to state three of them as prose only, which meant a container had nothing to read and an arbitrary max-width was the only way to obey it."**

**Meta anatomy**: `<dl class="divide-y divide-border overflow-hidden rounded-lg border border-border bg-card">`; each row `grid gap-1 px-4 py-3 sm:grid-cols-[minmax(0,13rem)_1fr] sm:gap-4` (key column 208px at ≥640px); `<dt>` `type-num-sm text-action-ink`, `<dd>` `type-small text-muted-foreground`.

Rows verbatim (k → v):
1. **Design frame** → "1440px wide — the canvas everything is composed against. Not a token: it is the canvas, not a measure anything renders at."
2. **--width-shell** → "1680px. The outer frame the sidebar and main column share on the documentation site." *(token agrees: 1680px)*
3. **--width-page** → "1320px. The cap for customer-facing pages — FAQ, about, contact, help, legal." ⚠️ **DRIFT: globals.css declares `--width-page: 1200px`.** The page copy says 1320; the token says 1200. (The token's own comment block even quotes the old prose "Product pages cap at 1320px" as the reason the token was created.) Both sides reported; the token is what renders anywhere `max-w-(--width-page)` is used.
4. **--width-content** → "1080px. A documentation column: copy with specimens, panels and tables beside it." *(token agrees)*
5. **--width-prose** → "720px. A reading column carrying nothing but sentences. See Typography → Prose." *(token agrees)*
6. **--height-site-header** → "4rem. Every sticky header. --scroll-offset derives from it, so an anchored heading cannot land underneath one." *(token agrees; offset = 96px)*
7. **Page margin** → "px-6 md:px-8 lg:px-12 — 24px mobile · 32px tablet · 48px desktop. All on the scale above." *(note: the doc shell itself actually uses `px-6 … lg:px-12` with no `md:px-8` step — the stated ladder is the product rule, not this layout's classes)*
8. **Columns** → "12-column grid on desktop, 24px gutters."

**Panel — label "12 columns · 24px gutters", `mt-4`**: body `grid grid-cols-12 gap-6` (always 12 columns at every width, 24px gutters). Twelve cells: `grid h-20 (80px) place-items-center rounded-sm (6px) bg-action/12` (action at 12% alpha) each containing `type-num-sm text-action-ink` numeral **1–12**.

---

## 6 · Section `#breakpoints` — "Breakpoints"

Description (verbatim): **"Tailwind's stock scale, unmodified, and these are the real numbers rather than an intent. This section described a 1200px desktop boundary that no breakpoint has ever fired at; the values below are the ones every component in this repository is actually written against."**

Meta rows verbatim:
1. **sm — 640px** → "The first column split. Two-up state grids, side-by-side panels."
2. **md — 768px** → "The mobile boundary, and the one the old prose got right. Tables stop becoming card lists; the section spacing steps up."
3. **lg — 1024px** → "The documentation sidebar appears; page gutters reach 48px."
4. **xl — 1280px** → "The true desktop layout switch. Four-up grids, full 12 columns."
5. **2xl — 1536px** → "Rarely reached for. --width-page caps at 1320px, so most layouts have stopped growing by here." ⚠️ same 1320-vs-1200 drift repeated here in copy.

**Note (default tone="action"), `mt-4`** — `rounded-lg border p-5`, `border-action/30 bg-action/[0.08] text-action-ink`; title `type-label mb-2`: **"Why the scale was not overridden"**. Body `type-small text-muted-foreground` with three inline `Code` chips (`type-code rounded-sm border border-border bg-card px-1.5 py-0.5 text-muted-foreground` — Geist Mono 12.5px/1.4, 6px/2px padding, 6px radius): **"The obvious fix for a 1200px intent is a `--breakpoint-xl` override. It was rejected: every one of the sixty-eight base components is written against the stock scale, so moving a boundary re-flows all of them silently and nothing in the build reports it. The prose was wrong, not the scale. Use `xl:` for the desktop switch and `md:` for the mobile boundary."**

---

## 7 · Section `#rules` — "Rules" (no description)

`DoDont`: `grid gap-4 sm:grid-cols-2`.
- **Do panel**: `rounded-lg border border-value/25 bg-value/[0.06] p-5`; heading `type-label mb-3 text-value-ink` → "Do"; `ul.space-y-2.5`; items `flex gap-2.5`: `Icon icon={Check} size="sm" (14px, strokeWidth 2.4) tone="value" (text-value-ink) className="mt-0.5"` + `type-small text-muted-foreground` text.
- **Don't panel**: `border-destructive/25 bg-destructive/[0.06]`; heading `text-destructive-ink` → "Don't" (rendered with `&rsquo;`); X icon `tone="error"` (text-destructive-ink).

Dos (verbatim):
1. "Pick gaps from the scale — 4, 8, 12, 16, 24, 32, 40, 48, 64, 80."
2. "Let radius follow surface size: badges 6, buttons 10, cards 12, dialogs 16."
3. "Use the surface ladder for depth first, and add a shadow only to confirm it."
4. "Ask for a measure by token — --width-page, --width-content, --width-prose — never by number."

Don'ts (verbatim):
1. "Don't invent in-between spacing values to make something 'fit'."
2. "Don't put a glow on a resting surface — glow means selected, rare or premium."
3. "Don't let a card and its inner input share the same radius; the ladder should read."
4. "Don't write a measure as an arbitrary value; if the token is missing, add it to globals.css rather than working around it."

---

## 8 · Foot nav (`PageFootNav groupId="foundations" slug="spacing"`)

`nav.mt-8 flex items-stretch gap-4 border-t border-border pt-8`. Both siblings exist:
- **Previous** → title "Typography", href `/design-system/typography`. Link: `press flex min-w-0 flex-1 items-center gap-3 rounded-lg border border-border bg-card px-5 py-4 hover:border-input`; ArrowLeft `Icon size="md"` (16px, stroke 2.4, `text-muted-foreground`); label "Previous" `type-micro block text-muted-foreground` (10.5px/1, 600, uppercase, 0.18em); title `type-small mt-1 block truncate text-foreground`.
- **Next** → title "Shadows", href `/design-system/shadows`. Mirrored: `justify-end … text-right`, ArrowRight after text.

---

## 9 · Motion on this page

No entrance/keyframe animations anywhere on this page. Interactive motion only:
- `press` (foot-nav links + header logo): `transition: transform 250ms cubic-bezier(0.34,1.56,0.64,1)` (`--ease-spring`); `:active { transform: scale(0.94); transition-duration: 40ms }` — 40ms in, springy 250ms out.
- Foot-nav `hover:border-input` border-color change at the framework default, repointed to `250ms` / `--ease-out cubic-bezier(0.22,1,0.36,1)` (`--default-transition-duration/-timing-function`).
- Anchor travel: smooth scroll with 96px `scroll-padding-block-start`; disabled globally under `prefers-reduced-motion: reduce` (forces `scroll-behavior: auto !important`).
- Elevation/glow boxes are static (no hover states on the demos themselves).

## 10 · Color tokens used on this page (dark / light)

| token | dark | light |
|---|---|---|
| --background | hsl(240 10% 3.9%) | hsl(0 0% 100%) |
| --card | hsl(240 5.9% 10%) | hsl(0 0% 100%) |
| --muted | hsl(240 3.7% 15.9%) | hsl(240 4.8% 95.9%) |
| --border | hsl(240 3.7% 15.9%) | hsl(240 5.9% 90%) |
| --input | hsl(240 5.3% 26.1%) | hsl(240 5.9% 90%) |
| --foreground | hsl(0 0% 98%) | hsl(240 10% 3.9%) |
| --muted-foreground | hsl(240 4.9% 83.9%) | hsl(240 4% 40%) |
| --color-action (bars, grid cells, note tint) | hsl(217 91% 53%) #1A6EF4 | same |
| --action-ink | hsl(213 94% 78%) #92C2FC | hsl(224 76% 33%) #143694 |
| --color-value | #a3e635 | same |
| --value-ink | #d9f99d | #4d7c0f |
| --destructive | hsl(0 72.2% 50.6%) | same |
| --destructive-ink | #f87171 | hsl(0 72.2% 46%) |

## 11 · Drift register (copy vs tokens — both sides, for 1:1 port)

1. **`--width-page`**: page Meta copy says **1320px** (twice — grid section and 2xl breakpoint row); `globals.css:244` declares **`--width-page: 1200px`**. Render the copy verbatim; implement the token as 1200.
2. **Radius ladder**: page shows "Seven steps"; token file has nine (`--radius-xs: 2px`, `--radius-4xl: 32px` undocumented here).
3. **Fonts**: globals prose + nav.ts typography blurb say Space Grotesk; token `--font-sans` is **Inter Local** (what actually renders). Mono is Geist Mono (correct in both).
4. **Page-margin Meta row** promises `px-6 md:px-8 lg:px-12`; the documentation shell itself renders `px-6 py-12 lg:px-12` with no `md:px-8` step.
5. **"No 18px/30px/50px" rule** vs. docs-kit chrome using 6/10/20/28/56px steps (`py-1.5`, `gap-2.5`, `p-5`/`gap-5`, `mt-7`, `mb-14`) — the demos must keep those exact off-scale values to match.