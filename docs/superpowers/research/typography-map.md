# Typography page map — `/design-system/typography`

**Files that render this page:** `D:\DESIGN\Design-System-2026-8\design-system\app\design-system\typography\page.tsx` (only file in the dir) · kit components `D:\DESIGN\Design-System-2026-8\design-system\components\ds\kit.tsx` · nav data `D:\DESIGN\Design-System-2026-8\design-system\lib\ds\nav.ts` · icon wrapper `D:\DESIGN\Design-System-2026-8\design-system\components\ui\icon.tsx` · all type CSS in `D:\DESIGN\Design-System-2026-8\design-system\app\globals.css` · shell `app\design-system\layout.tsx` · fonts in `public\fonts\`.

---

## 0. FONT FOUNDATIONS — with a critical drift

**⚠ DRIFT (page copy vs tokens vs font files).** Every piece of visible copy on this page says the word face is **Space Grotesk** (panel label "Space Grotesk — words", the rule Note, nav blurb "Space Grotesk for every word", and a comment in `nav.ts` insisting "`--font-sans` is Space Grotesk"). The tokens say otherwise:

- `--font-sans: "Inter Local", ui-sans-serif, system-ui, sans-serif;` (globals.css:169)
- `--font-heading: "Inter Local", ui-sans-serif, system-ui, sans-serif;` (line 171)
- `--font-mono: var(--font-geist-mono), ui-monospace, monospace;` — Geist Mono loaded via `next/font` (`GeistMono.variable` on `<html>` in `app/layout.tsx`)
- `--font-accent: "Redaction 35", ui-serif, Georgia, serif;` (italic serif, NOT used on this page)

`@font-face "Inter Local"` → `/fonts/inter-variable.woff2`, weight range 100–900, `font-display: swap`. I inspected the woff2 name table: it is genuinely **Inter Variable**. There is **no Space Grotesk file anywhere** in `public/fonts/` (only `inter-variable.woff2` and `redaction-35-italic.woff2`). So the page **renders words in Inter Variable** while its copy claims Space Grotesk. Per the project's recorded decision ("fonts follow tokens not prose"), the Flutter port should ship Inter (variable) + Geist Mono, but keep the copy verbatim ("Space Grotesk") since it's part of the reference. The comment above the tokens (line 168) also still says "Space Grotesk owns words."

**Weight tokens:** `--font-weight-normal:400; -medium:500; -semibold:600`. Note `.type-h2` uses **weight 650** — only renderable because Inter is variable.

**Tracking tokens:** `--tracking-display:-0.03em; -tight:-0.02em; -num:-0.01em; -cta:0.09em; -tag:0.12em; -badge:0.14em; -label:0.16em; -micro:0.18em`.

**Size tokens (rem → px):** `--text-tag:0.625rem/10; --text-micro:0.65625rem/10.5; --text-label:0.6875rem/11; --text-chip:0.71875rem/11.5; --text-num-sm:0.75rem/12; --text-code:0.78125rem/12.5; --text-small:0.8125rem/13; --text-nav:0.84375rem/13.5; --text-body:0.9375rem/15; --text-h4:1.0625rem/17`. Tailwind's own steps are aliased onto these: `--text-xs→12, --text-sm→13, --text-base→15, --text-lg→17`.

**Complete `.type-*` class definitions** (all `@layer components`; family inherits `--font-sans` unless stated; `--spacing` is Tailwind v4's default 0.25rem = 4px, never overridden):

| Class | font | size | line-height | weight | tracking | transform | color |
|---|---|---|---|---|---|---|---|
| `.type-display` | `--font-heading` | `clamp(2.75rem, 4.4vw, 4rem)` (44→64px) | 1 | 500 | −0.03em | — | — |
| `.type-h1` (+`:where(.prose) h1`) | inherit | `clamp(2rem, 2.8vw, 2.5rem)` (32→40px) | 1.1 | 700 | −0.02em | — | — |
| `.type-h2` (+prose h2) | inherit | 1.75rem/28 | 1.2 | **650** | −0.015em | — | — |
| `.type-h3` (+prose h3) | inherit | 1.3125rem/21 | 1.3 | 600 | −0.01em | — | — |
| `.type-h4` (+prose h4,h5,h6) | inherit | 1.0625rem/17 | 1.4 | 600 | — | — | — |
| `.type-lead` | inherit | 1.0625rem/17 | 1.65 | 400 | — | — | `--muted-foreground` |
| `.type-body` (+prose p,li,td,blockquote) | inherit | 15 | 1.6 | 400 | — | — | — |
| `.type-small` (+prose figcaption) | inherit | 13 | 1.5 | 400 | — | — | `--muted-foreground` |
| `.type-nav` | inherit | 13.5 | 1.2 | 500 | — | — | — |
| `.type-nav-sm` | inherit | 11.5 | 1.2 | 500 | — | — | — |
| `.type-chip` | inherit | 11.5 | 1.2 | 500 | — | — | — |
| `.type-caption` | inherit | 10.5 | 1.35 | 500 | — | — | — |
| `.type-code` (+prose code,pre) | `--font-mono` | 12.5 | 1.4 | — | — | — | — (color set at call site) |
| `.type-label` (+prose th) | inherit | 11 | 1 | 600 | +0.16em | **uppercase** | `--muted-foreground` |
| `.type-section` | inherit | 13 | 1.4 | 600 | — | — | `--muted-foreground` |
| `.type-wordmark` | inherit | 15 | 1 | 700 | −0.01em | — | — |
| `.type-serial` | `--font-mono` | 15 | 1.4 | — | −0.01em | uppercase | — |
| `.type-micro` | inherit | 10.5 | 1 | 600 | +0.18em | **uppercase** | `--muted-foreground` |
| `.type-tag` | inherit | 10 | 1 | 600 | +0.12em | uppercase | — |
| `.type-badge` | inherit | 11 | 1 | 600 | +0.14em | uppercase | — |
| `.type-accent` | `--font-accent` | **1.055em** | — | 400 | −0.03em | italic | — |

**Numeric family** — shared block: `font-family: var(--font-mono); font-variant-numeric: tabular-nums; font-weight: 600; letter-spacing: var(--tracking-num)` (−0.01em), then per size: `.type-num-xs` 11px/1.2 · `.type-num-sm` 12px/1.2 · `.type-num` 15px/1.2 · `.type-num-md` 1.25rem(20px)/1.15 · `.type-num-lg` 1.75rem(28px)/1.05 · `.type-num-xl` 2.5rem(40px)/1 with tracking override **−0.025em**.

**Uppercase/small-caps handling:** no small-caps anywhere; uppercase is done via `text-transform: uppercase` baked into `.type-label`, `.type-micro`, `.type-tag`, `.type-badge`, `.type-serial` with wide positive tracking (0.12–0.18em). There is also a standalone `.tabular { font-variant-numeric: tabular-nums }` base class.

**Colors this page uses** (light `:root` / `.dark`; default theme is **dark** via next-themes `defaultTheme="dark"`, `enableSystem`, class-attribute):
- `--foreground` hsl(240 10% 3.9%) / hsl(0 0% 98%)
- `--muted-foreground` hsl(240 4% 40%) / hsl(240 4.9% 83.9%)
- `--background` white / hsl(240 10% 3.9%); `--card` white / hsl(240 5.9% 10%); `--muted` hsl(240 4.8% 95.9%) / hsl(240 3.7% 15.9%); `--border` hsl(240 5.9% 90%) / hsl(240 3.7% 15.9%); `--input` hsl(240 5.9% 90%) / hsl(240 5.3% 26.1%)
- `--action-ink` → light: `--color-action-dark` hsl(224 76% 33%) (#143694); dark: `--color-action-bright` hsl(213 94% 78%) (#92C2FC)
- `--value-ink` → light: `--color-value-dark` #4d7c0f; dark: `--color-value-bright` #d9f99d
- `--destructive-ink` → light: hsl(0 72.2% 46%); dark: #f87171. Fills: `--color-action` hsl(217 91% 53%), `--color-value` #a3e635, `--destructive` hsl(0 72.2% 50.6%)
- Body background carries a fixed radial glow: `radial-gradient(120% 90% at 62% 34%, var(--page-glow) 0%, transparent 64%)`, `--page-glow` hsl(240 30% 98%) light / hsl(240 8% 10%) dark. `::selection` = `color-mix(in oklab, var(--color-action) 35%, transparent)` behind `--foreground`.

**Shell context** (`app/design-system/layout.tsx`): sticky header `h-(--height-site-header)`=4rem, `border-b bg-background/85 backdrop-blur-xl px-6`, contains logo (class `press`), pill "Design System v0.1" (`type-micro rounded-pill border px-2.5 py-1`, ≥sm), right label "Desktop-first · 1440 frame · Light & dark" (`type-micro`, ≥md), ThemeToggle. Content: `max-w-(--width-shell)`=1680px row → DsSidebar + `<main class="min-w-0 flex-1 px-6 py-12 lg:px-12">` → inner `mx-auto max-w-(--width-content)`=1080px. `html` has `scroll-behavior: smooth` and `scroll-padding-block-start: var(--scroll-offset)` = 4rem + 32px = **96px**; sections set no scroll-margin.

---

## 1. PAGE HEADER (`DsPageHeader`)

`<header class="mb-14 border-b border-border pb-10">`
- Eyebrow `type-label text-action-ink`: **"Foundations"**
- `<h1 class="type-h1 mt-4 text-foreground">`: **"Typography"**
- Blurb `type-lead mt-4 max-w-2xl`, verbatim: **"Two faces only: Space Grotesk for every word, Geist Mono for every number. Full specimen of each type class, plus the prose block that reaches the same scale without one."** (⚠ names Space Grotesk — see drift above)
- Chips `ul.mt-7 flex flex-wrap gap-2`; each `li.type-chip rounded-pill border border-border bg-card px-3 py-1.5 text-muted-foreground` (`--radius-pill`=999px). In order: **Display · Headings · Body · Labels · Numerics · Prose · Rules**

---

## 2. SECTION `id="rule"` — "Two foundation faces"

`DsSection`: `<section class="mb-20">`, heading block `mb-6` with `<h2 class="type-h3 text-foreground">` (section titles use **type-h3**, 21px/600) and description `type-small mt-2 max-w-2xl`.
Title: **"Two foundation faces"**. Description: **"The whole type system is a single rule with no exceptions, which is what keeps it consistent across every screen and component."**

Body: `grid gap-4 sm:grid-cols-2` of two `Panel`s.

**Panel anatomy** (used everywhere below): outer `overflow-hidden rounded-xl` (16px) `border border-border bg-card`; header strip (only when label/note present) `flex items-baseline justify-between gap-4 border-b border-border bg-muted px-5 py-3` — label in `type-label text-muted-foreground`, right-side note in `type-num-sm text-muted-foreground`; body `bg-background p-6` (or custom `bodyClassName`).

- **Panel label "Space Grotesk — words"**: `<p class="type-display text-foreground">Aa</p>`; then `type-small mt-5`: "Headings, body, buttons, labels, navigation, card names, pack names. A geometric grotesk: technical enough to feel engineered, open enough to stay readable at 11px."; then `type-code mt-4 text-muted-foreground`: `--font-sans`
- **Panel label "Geist Mono — numerical values"**: `<p class="type-num-xl text-value-ink">0123</p>`; `type-small mt-5`: "Prices, balances, dates, quantities, statistics, serials and code. Numerical variants are tabular so aligned values do not jitter."; `type-code mt-4 text-muted-foreground`: `--font-mono`

**Note (tone="action", title="The rule", mt-4)** — Note anatomy: `rounded-lg border p-5` + tone `border-action/30 bg-action/[0.08] text-action-ink`; title `type-label mb-2`; body `type-small text-muted-foreground`. Copy: "Words use Space Grotesk through `.type-*`. Numerical values use Geist Mono through `.type-num-*`. Each named foundation owns its complete font, size, line-height, weight and tracking." (`Code` inline component: `type-code rounded-sm border border-border bg-card px-1.5 py-0.5 text-muted-foreground`, radius-sm 6px.)

---

## 3. SECTION `id="words"` — "Word scale"

Description: **"Nine classes cover every piece of text in the product. Display is reserved for the landing hero and pack-opening moments — nothing else earns it."** (It shows ten rows; "nine" + display reads as 9 non-display or is minor copy slack — render verbatim.)

Container: `overflow-hidden rounded-xl border border-border bg-card` holding stacked `Spec` rows.

**Spec row anatomy** (local component in page.tsx): `grid gap-4 border-b border-border px-6 py-7 last:border-b-0 lg:grid-cols-[15rem_1fr] lg:gap-8`. Left cell: class name rendered **with leading dot** in `type-code text-action-ink` (e.g. `.type-display`), usage line under it in `type-small mt-2 text-muted-foreground`. Right cell `min-w-0 self-center` holds the live sample.

Rows in order (use-copy and sample text verbatim):
1. `.type-display` — use: "Landing hero. Pack-opening reveal. Once per page, at most." — sample `type-display text-foreground`: **"Pull something legendary"**
2. `.type-h1` — "The page heading. Exactly one per screen." — `type-h1 text-foreground`: **"Pack Marketplace"**
3. `.type-h2` — "Major page sections — Featured Packs, Live Pulls, Top Grails." — **"Featured Packs"**
4. `.type-h3` — "Card titles, module headings, modal titles." — **"Eclipse Vault — Series I"**
5. `.type-h4` — "Pack names on cards, collectible card names, row titles." — **"Voidwing Ascendant"**
6. `.type-lead` — "The sentence under a page heading. One per screen." — sample (no extra color class; class's own muted color): **"Every pack lists its odds, its remaining supply and its top possible hit before you spend anything."**
7. `.type-body` — "Standard interface copy, descriptions, dialog content." — `type-body text-muted-foreground`: **"Cards land in your Stash the moment a pack finishes opening. From there you can keep them, sell them back at the listed value, or add them to a shipment."**
8. `.type-small` — "Helper text, secondary detail, table cells, filter labels." — **"Sell-back values are quoted at the time of sale and may move with the market."**
9. `.type-label` — "Section eyebrows, panel labels, field labels, rarity names." — **"Remaining supply"** (renders uppercase)
10. `.type-micro` — "The floor. Badge text, pip captions, chart axes. Never smaller." — **"Limited edition"** (renders uppercase)

⚠ Internal drift: copy calls `.type-micro` (10.5px) "The floor. … Never smaller," and the Rules section repeats "absolute floor at 10.5px" — yet CSS defines `.type-tag` at **10px** (`--text-tag`, "The smallest step. Compact rarity badges and tier tags only."). Both statements exist in the reference.

---

## 4. SECTION `id="numbers"` — "Numeric scale"

Description: **"Five sizes, all tabular, all semibold. Numbers carry the product's meaning — what things cost and what they are worth — so they are given more weight than the words around them."** (Five shown; a sixth, `.type-num-xs`, exists in CSS but is not specimened here.)

Same bordered container of `Spec` rows:
1. `.type-num-xl` — "Wallet available balance. Total inventory value. Hero figures." — `type-num-xl text-foreground`: **"$12,480.65"**
2. `.type-num-lg` — "Card value in the inspection modal. Reward amounts. Stat tiles." — `text-value-ink`: **"$1,240.00"**
3. `.type-num-md` — "Pack price. Card value on a tile. Leaderboard points." — `text-value-ink`: **"$48.00"**
4. `.type-num` — "Table figures, transaction amounts, quantities, odds." — `text-foreground`: **"1,284"**
5. `.type-num-sm` — "Timestamps, supply counters, token names, metadata figures." — `text-muted-foreground`: **"412 / 2,000"**

**Panel "Why tabular matters"** (mt-4) with header-note (right side, `type-num-sm`): **"font-variant-numeric: tabular-nums"**. Body `grid gap-6 sm:grid-cols-2`:
- Left column: heading `type-label mb-3 text-value-ink` **"Tabular — the product"**; `ul.space-y-1.5` of four rows from array `["$1,240.00", "$48.00", "$7.15", "$11,908.40"]`, each `li.type-num flex justify-between border-b border-border pb-1.5 text-foreground` containing `<span class="type-small text-muted-foreground">Row</span>` + the value. Caption `type-small mt-3`: "Decimal points align. Digits keep their column as values update live, so a ticking balance does not shuffle sideways."
- Right column: heading `type-label mb-3 text-destructive-ink` **"Proportional — rejected"**; same four values but each `li.type-section flex justify-between border-b border-border pb-1.5` with inline `style={{ fontVariantNumeric: "proportional-nums" }}`. ⚠ Rendering detail: the rejected column is **not mono at all** — `.type-section` is the sans face at 13px/600/muted, so it differs from the left in family, size, weight, color AND numeric spacing. Caption `type-small mt-3`: "Proportional figures do not align, and every live update nudges the layout."

---

## 5. SECTION `id="pairing"` — "Pairing the foundations"

Description: **"Words stay in Space Grotesk while numerical values use Geist Mono. The named classes carry each treatment without page-level typography values."** (⚠ Space Grotesk again.)

**Panel "Canonical pairings"**, body `grid gap-5 sm:grid-cols-2 lg:grid-cols-3`, three cards each `rounded-lg border border-border bg-card p-5` (radius-lg 12px):
1. `type-label` "Pack price" · `type-num-md mt-2 text-value-ink` **"$48.00"** · `type-small mt-1` "6 cards per pack"
2. `type-label` "Available balance" · `type-num-lg mt-2 text-foreground` **"$1,204.80"** · `type-small mt-1` with `<span class="text-value-ink">+$120.00</span> today`
3. `type-label` "Legendary odds" · `type-num-md mt-2 text-foreground` **"1 in 240"** · `type-small mt-1` "0.42% per card"

---

## 6. SECTION `id="prose"` — "Prose"

Description: **"The same scale, reached a second way. A policy, a help article or the output of a markdown renderer has no call site to put a class on, so .prose styles the elements instead — and it does it by adding a selector to the type roles above rather than by owning a second set of sizes."**

**Panel "Long-form content"**, header note: **"max-w-(--width-prose) · 720px"**, `bodyClassName="p-6 sm:p-10"`. Inside: `<div class="prose max-w-(--width-prose)">` (`--width-prose: 720px`) containing unclassed markup:

- `<h2>` **"Refunds and cancellations"** (renders as type-h2 28/1.2/650/−0.015em via `:where(.prose) h2`)
- `<p>` "Every element here is unstyled markup inside a single `prose` wrapper. The heading above is the same declaration block as `.type-h2` — not a copy of its size, the block itself — so retuning the scale moves both and neither can drift from the other."
- `<p>` "Links take `--color-action-ink`, which is the only shade of the action ramp that reads in both themes, and they are underlined at rest because [a link identified by hue alone](#prose) is one signal where the accessibility contract asks for two." (link href `#prose`)
- `<h3>` **"What a reader is entitled to"**
- `<ul>`: "A refund within fourteen days of purchase." / "A written reason when a request is refused, including" with nested `<ul>`: "the clause it was refused under, and" · "the address an appeal goes to." / "A reply inside one working week." (Note: source has "including" immediately followed by the nested list — no space before it in JSX.)
- `<blockquote>` "Nested lists take the interior step rather than the block step, so a sub-clause reads as part of its parent rather than as a new paragraph."
- `<h3>` **"Ordered steps"**; `<ol>`: "Open the order from your account." / "Choose the items you are returning." / "Print the label and post it within seven days."
- `<h4 class="type-label">` **"An explicit class still wins inside prose"** — the override demo: renders as 11px uppercase label, not h4.
- `<p>` "That heading is an `h4` carrying `.type-label`. The prose selector is wrapped in `:where()`, so it weighs one element and any real class beats it — `.prose` is a default, not a cage."
- `<hr />`
- `<table>`: thead th **Request | Window | Refunded to**; rows: **Unopened item | 14 days | Original payment method** and **Faulty item | 30 days | Original payment method**.

**Prose CSS the sample exercises** (`@layer components`, globals.css 1322–1507): `.prose { color: var(--foreground) }`. Rhythm: p/ul/ol/blockquote/figure/pre/table `margin-block: 16px`; h1,h2 `margin-block: 40px 16px`; h3 `32px 12px`; h4–h6 `24px 8px`; hr `margin-block: 40px; border:0; border-top: 1px solid var(--border)`; `.prose > :first-child { margin-block-start: 0 }`, `> :last-child { margin-block-end: 0 }`. Headings colored `--foreground`. Lists: ul disc / ol decimal, `padding-inline-start: 24px`; `li::marker` muted-foreground; `li + li` margin-top 8px; nested `li > ul/ol` margin-block 8px. Links: `color: var(--color-action-ink); underline, thickness 1px, underline-offset 2px; transition: text-decoration-color 150ms cubic-bezier(0.22,1,0.36,1)`; on hover `text-decoration-color: transparent` (underline fades out — the page's one prose animation). strong 600 foreground; em italic. Inline `:not(pre) > code`: bg `--card`, 1px `--border`, radius 6px, padding 2px 6px, color muted-foreground (matches kit `Code`). `pre`: bg card, border, radius 12px, padding 16px, overflow-x auto; `pre code` reset. blockquote: `border-inline-start: 2px solid var(--input)` (the stronger hairline), padding-left 16px, muted-foreground, italic. Table: `display:block; width:max-content; max-width:100%; overflow-x:auto; border-collapse:collapse`; th/td `border-bottom 1px solid var(--border); padding 12px 16px; text-align:start; vertical-align:top`; `th { background: var(--muted) }` plus type-label treatment (11px uppercase 0.16em muted) via `:where(.prose) th`. img/video/iframe max-width 100%, radius 12px; figcaption = type-small + margin-top 8px.

**Meta block** (mt-4) — anatomy: `dl.divide-y divide-border overflow-hidden rounded-lg border border-border bg-card`; each row `grid gap-1 px-4 py-3 sm:grid-cols-[minmax(0,13rem)_1fr] sm:gap-4`; `dt.type-num-sm text-action-ink`, `dd.type-small text-muted-foreground`. Six items verbatim (k → v):
1. **"What it owns"** → "Vertical rhythm on the 8-point scale, list markers and indents, link treatment, quote rule, and code and table chrome."
2. **"Anchors"** → "Nothing. html carries scroll-padding-block-start: var(--scroll-offset), derived from --height-site-header. A scroll-margin here as well would add to it — measured at 192px below a 64px header before it was removed."
3. **"Wide tables scroll"** → "A table is display:block with width:max-content capped at 100%, so it is its own scroll port on the system's thin rail. It takes content width rather than filling the measure — the trade for never being clipped, which is what happened at 375px before the rule existed."
4. **"What it does not own"** → "Sizes. Every one lives in the .type-* role it shares a declaration block with. It also sets no max-width — the measure belongs to the page container, and two owners for one number is how --width-page spent months as prose on the Spacing page."
5. **"--width-prose"** → "720px. Narrower than --width-content (1080px) because that column carries specimens and panels beside the copy, while this one carries nothing but sentences."
6. **"Headings start at h2"** → "The page heading is the page's own h1. .prose styles h1 anyway, because an unstyled browser default is worse than a heading level used wrongly — but a document that opens with h2 is the convention."

**Note (tone="error", title="Two mechanisms that do not work", mt-4)** — `border-destructive/30 bg-destructive/[0.08] text-destructive-ink`: "`@apply type-h2` inside a `.prose h2` rule fails the build outright — *Cannot apply unknown utility class* — because `@apply` reaches Tailwind utilities and `@utility` registrations, and the type scale lives in `@layer components`. The call-site spelling `[&_h2]:type-h2` is the same wall from the other side and fails *silently*, which is the worse of the two: no error, no class, every guard green, and the size quietly falling back to inherited." (italics via `<em>`, inline chips via `Code`.)

---

## 7. SECTION `id="rules"` — "Rules" (no description)

`DoDont` — `grid gap-4 sm:grid-cols-2`. Do panel: `rounded-lg border border-value/25 bg-value/[0.06] p-5`, heading `type-label mb-3 text-value-ink` "Do"; list `space-y-2.5`, items `flex gap-2.5` with Lucide **Check** via `Icon size="sm"` (14px, computed strokeWidth ≈ 2.4… actually `(2*24)/14≈3.43 → clamped to 2.4`) `tone="value"` `mt-0.5`, text `type-small text-muted-foreground`. Don't panel mirrors with `border-destructive/25 bg-destructive/[0.06]`, heading `text-destructive-ink` "Don't" (curly apostrophe `Don&rsquo;t`), **X** icon `tone="error"`.

Dos verbatim:
1. "Always apply a .type-* or .type-num-* class — never a raw pixel size in a utility."
2. "Put numerical values in the Geist Mono type-num foundation so comparable figures stay tabular."
3. "Keep .type-micro as the absolute floor at 10.5px, and only for uppercase labels."
4. "Use .type-display once per screen at most, and only for hero or reveal moments."

Don'ts verbatim:
1. "Don't apply font families or numeric weights at the call site; choose a named foundation class."
2. "Don't add a third typeface for display; heavy Space Grotesk at tight tracking already carries the hero." (⚠ Space Grotesk again; also ⚠ `.type-accent`/`--font-accent` "Redaction 35" IS a third face in the CSS, used for one display word elsewhere — both sides reported.)
3. "Don't put important text below 12px, or inside decorative pack artwork."
4. "Don't use proportional figures anywhere money, odds or counts appear."

---

## 8. PAGE FOOT NAV (`PageFootNav groupId="foundations" slug="typography"`)

Siblings from nav order (colors → **typography** → spacing): **Previous = "Colors"** → `/design-system/colors`; **Next = "Spacing & Layout"** → `/design-system/spacing`. `nav.mt-8 flex items-stretch gap-4 border-t border-border pt-8`; each link `press flex min-w-0 flex-1 items-center gap-3 rounded-lg border border-border bg-card px-5 py-4 hover:border-input` (next variant adds `justify-end text-right`); ArrowLeft/ArrowRight `Icon size="md"` (16px, strokeWidth 2… `(2*24)/16=3 → 2.4`) `tone="muted"`; label "Previous"/"Next" `type-micro block text-muted-foreground`; title `type-small mt-1 block truncate text-foreground`.

---

## 9. ANIMATIONS & INTERACTION INVENTORY (entire page)

No sliders, toggles, or scripted demos on this page — it is fully static except:
- **`press`** on foot-nav links (and shell logo): `transition: transform 250ms cubic-bezier(0.34,1.56,0.64,1)` (`--duration-base`/`--ease-spring`); `:active { transform: scale(0.94); transition-duration: 40ms }` — 40ms squish in, 250ms overshoot-spring out.
- **Prose link hover**: underline fades via `transition: text-decoration-color 150ms cubic-bezier(0.22,1,0.36,1)` to transparent.
- **`hover:border-input`** on foot-nav cards — border-color hairline swap over the default transition (250ms `--ease-out`, set globally via `--default-transition-duration: 250ms` / `--default-transition-timing-function: var(--ease-out)`).
- Global: smooth anchor scrolling with 96px scroll offset; `:focus-visible { outline: 2px solid var(--ring); outline-offset: 2px }` (ring = action fill in light, action-bright in dark); action-tinted `::selection`; theme toggle kills all transitions for one frame on switch (`disableTransitionOnChange`).
- `.type-display`/`.type-h1` sizes are viewport-fluid (clamp with 4.4vw / 2.8vw middles) — the only responsive type.

## 10. DRIFT SUMMARY (both sides, for the port)

1. **Face naming**: all rendered copy + nav blurb say **Space Grotesk**; tokens/`@font-face`/woff2 say **Inter Variable** ("Inter Local"). No Space Grotesk asset exists. Port decision on record: follow tokens, keep copy verbatim.
2. **"Never smaller" floor**: copy claims 10.5px `.type-micro` is the floor; CSS ships 10px `.type-tag`.
3. **"Nine classes"** in the words-scale description vs ten `Spec` rows shown (display + 9).
4. **"Five sizes"** numeric scale vs six `.type-num-*` classes in CSS (`.type-num-xs` unspecimened).
5. **"Don't add a third typeface"** vs `--font-accent: "Redaction 35"` + `.type-accent` existing in CSS (used for one display word on the landing hero, not on this page).
6. `.type-code` sets no color of its own; every call site pairs it (`text-action-ink` in Spec, `text-muted-foreground` in `Code`/font-token lines).