# Map — `/design-system/colors` (Colors foundation page)

**Route file:** `D:\DESIGN\Design-System-2026-8\design-system\app\design-system\colors\page.tsx` (server component, no local components).
**Imports that render:** `Code, DsPageHeader, DsSection, Note, PageFootNav, Panel` from `D:\DESIGN\Design-System-2026-8\design-system\components\ds\kit.tsx`; `TokenSwatchList` from `D:\DESIGN\Design-System-2026-8\design-system\components\ds\token-swatch.tsx` (client); `findCategory` from `D:\DESIGN\Design-System-2026-8\design-system\lib\ds\nav.ts`; `Icon` from `D:\DESIGN\Design-System-2026-8\design-system\components\ui\icon.tsx` (via kit's `PageFootNav`). Token values: `D:\DESIGN\Design-System-2026-8\design-system\app\globals.css`. Shell: `app\design-system\layout.tsx`, `app\layout.tsx`.

---

## 0. Shell the page sits in (shared chrome, affects rendering)

- `app/layout.tsx`: `<html class="${GeistMono.variable} h-full antialiased" suppressHydrationWarning>`; `next-themes` `ThemeProvider attribute="class" defaultTheme="dark" enableSystem disableTransitionOnChange`. **Default theme is dark.**
- `app/design-system/layout.tsx`: sticky header `h-(--height-site-header)` = **4rem/64px**, `z-40 border-b border-border bg-background/85 backdrop-blur-xl px-6`, containing mobile-nav trigger (`lg:hidden`, sheet `w-72`), Logo link with `press`, pill `type-micro rounded-pill border border-border px-2.5 py-1` reading verbatim **"Design System v0.1"** (`hidden sm:block`), right-aligned `type-micro` verbatim **"Desktop-first · 1440 frame · Light & dark"** (`hidden md:block`), and the ThemeToggle (3-way radiogroup Light/System/Dark, sliding pill indicator `bg-card shadow-e1`, options `size-7` icons `size-3.5`, `press` on each).
- Content frame: `mx-auto flex w-full max-w-(--width-shell)` = **1680px**; `DsSidebar` = `aside sticky top-16 hidden lg:block h-[calc(100dvh-4rem)] w-60 border-r border-border px-6 pt-10 overflow-y-auto` (nav items `type-nav`, group labels `type-label`, left-border active markers); `main min-w-0 flex-1 px-6 py-12 lg:px-12` → inner `mx-auto max-w-(--width-content)` = **1080px**.
- Body backdrop (both themes): `radial-gradient(120% 90% at 62% 34%, var(--page-glow) 0%, transparent 64%)`, `background-attachment: fixed`, over `bg-background`. `--page-glow`: light `hsl(240 30% 98%)`, dark `hsl(240 8% 10%)`.
- Global: `:focus-visible { outline: 2px solid var(--ring); outline-offset: 2px }` (`--ring` = `--color-action` light, `--color-action-bright` dark). `::selection` = `color-mix(in oklab, var(--color-action) 35%, transparent)` with `color: var(--foreground)`. `html { scroll-behavior: smooth; scroll-padding-block-start: var(--scroll-offset) }` where `--scroll-offset = calc(4rem + var(--spacing)*8)` = **96px** — anchored sections land 96px below viewport top, animated smooth (disabled under `prefers-reduced-motion`).

---

## 1. Live-measurement machinery (`components/ds/token-swatch.tsx`) — how contrast is "measured live"

This is the page's engine; port it faithfully or precompute per theme.

1. **Value readout** (`useTokenValue` → `TokenValue`): `getComputedStyle(document.documentElement).getPropertyValue(token).trim()` — i.e. the **raw authored CSS text after `var()` substitution** (`"hsl(217 91% 53%)"`, `"#a3e635"`), not normalized rgb. Renders in `span.type-num-sm.text-muted-foreground`; shows `"—"` when null (SSR/pre-hydration snapshot is `null`).
2. **Colour resolution** (`resolve`): appends a hidden probe `div` with `style.color = value` to `document.body`, reads `getComputedStyle(probe).color`, regex `rgba?\(([^)]+)\)`, splits on `[\s,/]+` → `{r,g,b,a}` (a defaults 1). Handles hex/hsl/color-mix because the browser rasterises.
3. **Alpha**: translucent fg is composited over the bg (`fg.c*a + bg.c*(1-a)`) before luminance.
4. **Luminance**: WCAG 2.x with the **0.03928** linearisation threshold; contrast `(hi+0.05)/(lo+0.05)`.
5. **`ContrastBadge`** (default `against="--background"`): renders `Contrast {ratio.toFixed(1)}:1 · {verdict}` in `span.type-micro.text-muted-foreground`; verdict span tones: ratio ≥7 → **"AAA"**, ≥4.5 → **"AA"**, ≥3 → **"AA large / UI only"** (all three in `text-value-ink` lime), else **"Fails"** in `text-destructive-ink`. Verdict uses the raw ratio, the printed number is rounded (so `3.98` prints `4.0:1 · AA large / UI only`). SSR renders bare `"—"`.
6. **Theme reactivity**: one module-level `MutationObserver` on `document.documentElement`, `attributeFilter: ["class","style"]`; on any mutation both memo caches (`valueCache`, `ratioCache`) clear and all `useSyncExternalStore` subscribers re-read. next-themes flips theme by rewriting `class` on `<html>`, so **printed hexes and ratios re-measure on every theme flip and on inline `:root` style overrides**. Observer starts with first subscriber, disconnects with last.

**`TokenSwatch` row layout:** `grid items-center gap-4 p-4 sm:grid-cols-[5.5rem_minmax(0,13rem)_1fr] sm:gap-6` (mobile: stacked single column).
- Col 1: swatch `div h-16 sm:h-14 rounded-lg border border-input` (64px→56px tall, 88px wide at `sm+`, radius 12px), `style={{background: var(token)}}`.
- Col 2: name `p.type-h4.text-foreground` (17px/1.4/600); `TokenValue` `mt-1 block`; token name `p.type-num-sm.mt-1.text-action-ink` (mono 12px/1.2/600, tracking −0.01em).
- Col 3: use copy `p.type-small.text-muted-foreground` (13px/1.5/400); `ContrastBadge mt-2 block` only when `measure !== false`.

**`TokenSwatchList` container:** `divide-y divide-border overflow-hidden rounded-xl border border-border bg-card` (radius 16px, 1px hairline rows).

**No interactions**: swatches have no hover state, no click handler, **no copy-to-clipboard anywhere on this page**. The only interactive elements are the theme toggle (chrome) and the foot-nav/logo links.

---

## 2. Page header (`DsPageHeader`)

`header.mb-14.border-b.border-border.pb-10`:
- Eyebrow `p.type-label.text-action-ink` (11px/1/600, uppercase, tracking 0.16em): verbatim **"Foundations"** (from `findCategory("foundations","colors").group.title`).
- `h1.type-h1.mt-4.text-foreground` (`clamp(2rem, 2.8vw, 2.5rem)`/1.1/700, tracking −0.02em): verbatim **"Colors"**.
- Blurb `p.type-lead.mt-4.max-w-2xl` (17px/1.65/400, muted-foreground), verbatim: **"Zinc for everything structural, blue for action, lime for worth, four state colours, and nothing else. Two roles, two themes, and every value on this page measured rather than claimed."**
- Contents chips `ul.mt-7.flex.flex-wrap.gap-2`, each `li.type-chip.rounded-pill.border.border-border.bg-card.px-3.py-1.5.text-muted-foreground` (11.5px/1.2/500, radius 999px). **Static `<li>`, not links — they do not scroll.** Verbatim, in order: **"Monochrome" · "Action ramp" · "Value ramp" · "State" · "What is not a token"**.

## 3. Lead Note (before any section)

`Note tone="action" className="mb-12"` → `div.rounded-lg.border.p-5` with `border-action/30 bg-action/[0.08] text-action-ink` (8% action wash, 30% action border; radius 12px). Title `p.type-label.mb-2`, verbatim: **"Measured, not asserted"**. Body `div.type-small.text-muted-foreground`, verbatim (with `Code`-styled `app/globals.css` and `RULES.md`):

> "Every value below is read from the live stylesheet and every contrast ratio is computed from it at runtime. Nothing on this page is typed by hand, so it cannot disagree with `app/globals.css` — and it re-measures when you flip the theme, so the ratios you are reading are the ratios for the mode you are actually in. The rules that govern all of it live in `RULES.md`."

⚠ **Rendering fact for 1:1 port:** the `Note` title looks like it should take the tone ink, but `.type-label` declares `color: var(--muted-foreground)` on the element itself, which beats inheritance of the wrapper's `text-action-ink`. **Note titles render muted-foreground in every tone**; the tone shows only in the border + background wash. `Code` inline = `code.type-code.rounded-sm.border.border-border.bg-card.px-1.5.py-0.5.text-muted-foreground` (mono 12.5px/1.4, radius 6px).

## 4. Section anatomy (`DsSection`, all five)

`section#<id>.mb-20` (80px stack gap); heading block `mb-6`: `h2.type-h3.text-foreground` (21px/1.3/600, tracking −0.01em — note it is **type-h3**, not h2 class) + description `p.type-small.mt-2.max-w-2xl` (muted). No `scroll-mt` (global scroll-padding handles the 96px offset).

---

## 5. Section `#monochrome` — verbatim h2 **"Monochrome — zinc"**

Description, verbatim: **"Six steps on shadcn's own token names, read downward on light and upward on dark. There is no second naming system."**

`TokenSwatchList` — 6 rows, in order (label shown = `name`; token line = the token string in action-ink mono; value line = live readout):

| # | Token queried & painted | Label | Use copy (verbatim) | Measured? |
|---|---|---|---|---|
| 1 | `--background` | Background | "The page. White on light, zinc 950 on dark. Utility: bg-background." | no |
| 2 | `--card` | Card | "Containers. Aliased by --popover and --sidebar. Utilities: bg-card, bg-popover." | no |
| 3 | `--muted` | Muted | "Fills and hairlines. Aliased by --secondary and --border. Utilities: bg-muted, border-border." | no |
| 4 | `--accent` | Accent | "Hover surfaces and stronger borders. Aliased by --input. Utilities: bg-accent, border-input." | no |
| 5 | `--foreground` | Foreground | "All primary text. Utility: text-foreground." | vs `--background` |
| 6 | `--muted-foreground` | Muted foreground | "Secondary text, metadata, helper copy. The one step that is not a mirror between themes — see the note below. Utility: text-muted-foreground." | vs `--background` |

Printed values (raw CSS text after substitution) and expected badges (computed offline with the page's exact math; browser rgb-rounding may shift the last decimal ±0.1):

| Token | Dark value shown | Dark badge | Light value shown | Light badge |
|---|---|---|---|---|
| `--background` | `hsl(240 10% 3.9%)` (zinc 950) | — | `hsl(0 0% 100%)` | — |
| `--card` | `hsl(240 5.9% 10%)` (zinc 900) | — | `hsl(0 0% 100%)` (white-on-white swatch; only the `border-input` hairline separates it) | — |
| `--muted` | `hsl(240 3.7% 15.9%)` (zinc 800) | — | `hsl(240 4.8% 95.9%)` (zinc 100) | — |
| `--accent` | `hsl(240 5.3% 26.1%)` (zinc 700) | — | `hsl(240 4.8% 95.9%)` (identical paint to `--muted` in light) | — |
| `--foreground` | `hsl(0 0% 98%)` | Contrast 19.0:1 · AAA | `hsl(240 10% 3.9%)` | Contrast 19.9:1 · AAA |
| `--muted-foreground` | `hsl(240 4.9% 83.9%)` (zinc 300) | Contrast 13.5:1 · AAA | `hsl(240 4% 40%)` | Contrast 6.0:1 · AA |

Then `Note tone="value" className="mt-4"` (lime wash: `border-value/30 bg-value/[0.08]`), title verbatim **"The one step that is not a mirror"**, body verbatim:

> "Every other neutral inverts cleanly between the two themes. Muted foreground does not. On dark it is zinc 300, which measures about 13:1; the mirror image would be zinc 400 on white, which measures 3.1:1 and fails AA outright. Nor is it zinc 500, which this system shipped for a long time: that clears AA on `--background` and misses it on `--muted` by a tenth of a point — and muted text on a muted fill is the most repeated pair in the whole system. Light sits one step deeper than zinc 500 so both pairs clear. Flip the theme and watch the ratio above: it stays legal in both, and it gets there by different means."

---

## 6. Section `#action` — verbatim h2 **"Action — the thing that acts"**

Description verbatim: **"Buttons, links, focus, selection, the agent. It answers one question: can I act on this, or is this the thing I picked? It is a blue today; it has been purple and wine before, and no component knew."**

4 rows, all measured vs `--background`:

| # | Token | Label | Use copy (verbatim) |
|---|---|---|---|
| 1 | `--color-action-ink` | Action ink | "The text-safe end, resolved for whichever theme you are in. The ONLY action colour allowed on text, icons and links. Utility: text-action-ink." |
| 2 | `--color-action-bright` | Action bright | "The lifted end. Ink on dark, and the focus ring there. Illegible as text on light — never name it directly." |
| 3 | `--color-action` | Action | "The fill. Drives --primary: buttons, selection, active nav. Never carries a glyph — put text-primary-foreground on top." |
| 4 | `--color-action-dark` | Action dark | "The deep end. Ink on light, plus gradient floors and the foil ramp's base." |

Values/badges (`--color-action-ink` = `var(--action-ink)` → `--color-action-bright` on dark, `--color-action-dark` on light):

| Token | Dark shown | Dark badge | Light shown | Light badge |
|---|---|---|---|---|
| `--color-action-ink` | `hsl(213 94% 78%)` | 10.7:1 · AAA | `hsl(224 76% 33%)` | 10.6:1 · AAA |
| `--color-action-bright` | `hsl(213 94% 78%)` (≈`#92C2FC`, rgb(146,194,252)) | 10.7:1 · AAA | same | 1.9:1 · Fails |
| `--color-action` | `hsl(217 91% 53%)` (≈`#1A6EF4`, rgb(26,110,244)) | 4.3:1 · AA large / UI only | same | 4.6:1 · AA |
| `--color-action-dark` | `hsl(224 76% 33%)` (≈`#143694`, rgb(20,54,148)) | 1.9:1 · Fails | same | 10.6:1 · AAA |

`Note tone="action" className="mt-4"`, title verbatim **"One text-safe shade per theme — and it is not the same shade"**, body verbatim:

> "The ratios above are measured live, so flip the theme and watch them trade places. On dark, `--color-action-bright` clears AA and the deep end fails. On light it is exactly reversed. A component cannot know which surface it is sitting on, so it never names either end — it writes `text-action-ink`, and the theme block answers. The mid shade is a fill in both themes and can never carry a glyph; put `text-primary-foreground` on top of it."

---

## 7. Section `#value` — verbatim h2 **"Value — the thing that is worth something"**

Description verbatim: **"Balances, rankings, rewards, premium actions. Nothing else. It is lime today, and it follows the same ink rule the action ramp does."** No Note in this section.

4 rows, all measured. **Row order differs from the action ramp: ink, mid, bright, dark.**

| # | Token | Label | Use copy (verbatim) |
|---|---|---|---|
| 1 | `--color-value-ink` | Value ink | "The text-safe end, resolved per theme. Every figure, label and glyph that means worth." |
| 2 | `--color-value` | Value | "Balances, rankings, premium actions, reward surfaces." |
| 3 | `--color-value-bright` | Value bright | "Reward moments and the foil gradient's top stop." |
| 4 | `--color-value-dark` | Value dark | "Foil gradient floor, and ink on light." |

| Token | Dark shown | Dark badge | Light shown | Light badge |
|---|---|---|---|---|
| `--color-value-ink` | `#d9f99d` | 17.0:1 · AAA | `#4d7c0f` | 5.0:1 · AA |
| `--color-value` | `#a3e635` | 13.2:1 · AAA | same | 1.5:1 · Fails |
| `--color-value-bright` | `#d9f99d` | 17.0:1 · AAA | same | 1.2:1 · Fails |
| `--color-value-dark` | `#4d7c0f` | 4.0:1 · AA large / UI only (raw 3.98) | same | 5.0:1 · AA |

---

## 8. Section `#state` — verbatim h2 **"State"**

Description verbatim: **"Four meanings, fixed. Two of them moved when the brand did, and both moves were forced rather than aesthetic."**

4 rows, all measured:

| # | Token | Label | Use copy (verbatim) |
|---|---|---|---|
| 1 | `--color-success` | Success | "Completed, cleared, live, gained. Emerald rather than a plain green, to open a gap against lime." |
| 2 | `--color-warning` | Warning | "Pending, needs attention, purchase limit approaching." |
| 3 | `--color-info` | Information | "Neutral notices and explainers. Cyan rather than blue, so a notice cannot be mistaken for the brand." |
| 4 | `--destructive` | Destructive | "shadcn's own. Deletes, failed payments, validation errors." |

| Token | Value shown (both themes except destructive theme-invariant too) | Dark badge | Light badge |
|---|---|---|---|
| `--color-success` | `#10b981` (emerald 500) | 7.8:1 · AAA | 2.5:1 · Fails |
| `--color-warning` | `#fbbf24` (amber 400) | 11.9:1 · AAA | 1.7:1 · Fails |
| `--color-info` | `#22d3ee` (cyan 400) | 11.0:1 · AAA | 1.8:1 · Fails |
| `--destructive` | `hsl(0 72.2% 50.6%)` (≈rgb(220,38,38)) | 4.1:1 · AA large / UI only | 4.8:1 · AA |

**Behavioral note:** in light theme this section displays three red "Fails" badges — the list measures the raw fills, not the `-deep`/`-ink` counterparts (`--color-success-deep #047857`, `--color-warning-deep #b45309`, `--color-info-deep #0e7490`, `--color-destructive-deep hsl(0 72.2% 46%)` exist in `globals.css` but are not swatched on this page).

`Note tone="value" className="mt-4"`, title verbatim **"Why info is cyan and success is emerald"**, body verbatim (including the doubled-word typo — JSX collapses the line break so it renders "…in the same same row"):

> "A state colour has one job: to be unmistakable for anything else on the screen. Information used to be blue 400, which stopped working the moment action became blue — a neutral notice read as a promotion. Success used to be green 400, a few degrees from lime, which is too close when a completed sale and a valuable one appear in the same same row. Warning did not move and gained separation for free: it is amber, and lime sits forty degrees away from it, where the old value hue sat almost on top of it. That collision is the one this rebrand fixed by accident."

---

## 9. Section `#beyond` — verbatim h2 **"What is deliberately not a colour token"**

Description verbatim: **"Two things this system refuses to express as a colour, because a colour is the wrong tool for both."**

Layout: `div.grid.gap-4.sm:grid-cols-2` with two `Panel`s. Panel anatomy: `div.overflow-hidden.rounded-xl.border.border-border.bg-card`; header strip `flex items-baseline justify-between gap-4 border-b border-border bg-muted px-5 py-3` with `span.type-label.text-muted-foreground`; body `div.bg-background.p-6` (not flush).

**Panel 1 — label "Texture"**, body `p.type-small` verbatim (with `<em>texture</em>` italic and `Code` chips `globals.css`, `foil-value`, `bloom-cosmic`, `sheen-action`):

> "A surface that has to feel rare, precious or alive is a *texture*, not a hue — a moving gradient, a foil ramp, an iridescent bloom. Those live in `globals.css` as utilities (`foil-value`, `bloom-cosmic`, `sheen-action`) and are built from the two ramps above, so they follow a rebrand without carrying colour tokens of their own."

**Panel 2 — label "Meaning"**, body verbatim:

> "Nothing may be communicated by colour alone. A state ships its glyph and its label as well as its hue; a status ships its sentence. The four state colours above are a second signal on top of a first one, never the only one — which is also what keeps this system legible when both themes and every form of colour-blindness are accounted for."

**There are no ramp/gradient demos rendered on this page** — no foil, bloom, or sheen specimen; texture utilities are only named in copy.

---

## 10. `PageFootNav groupId="foundations" slug="colors"`

Colors is index 0 of foundations → `prev = null`, `next = { title: "Typography", href: "/design-system/typography" }`.
`nav.mt-8.flex.items-stretch.gap-4.border-t.border-border.pt-8`: left slot is an empty `span.flex-1` spacer; right slot is a Link: `press flex min-w-0 flex-1 items-center justify-end gap-3 rounded-lg border border-border bg-card px-5 py-4 text-right hover:border-input`, containing `span.type-micro.block.text-muted-foreground` verbatim **"Next"**, `span.type-small.mt-1.block.truncate.text-foreground` verbatim **"Typography"**, then `Icon icon={ArrowRight} size="md" tone="muted"` → 16×16px Lucide ArrowRight, `strokeWidth 2.4` (computed: `48/16=3 > 2.6 → 2.4`), `text-muted-foreground`, `shrink-0`, `aria-hidden`.

---

## 11. Animations & interaction parameters (complete list for this page)

- `press` (logo link, foot-nav link, theme-toggle buttons): `transition: transform var(--duration-base) var(--ease-spring)` = **250ms cubic-bezier(0.34, 1.56, 0.64, 1)**; `:active { transform: scale(0.94); transition-duration: 40ms }` — 40ms squash in, 250ms spring-back with overshoot.
- Foot-nav hover `border-border → border-input`: **instant** (the element's `press` transition covers `transform` only; no transition utility for border-color, so no 250ms default applies).
- Smooth anchor scrolling: `html { scroll-behavior: smooth }`, rest point 96px below top; `prefers-reduced-motion: reduce` forces `scroll-behavior: auto !important` globally.
- Theme flip: `disableTransitionOnChange` — next-themes injects a one-frame kill-all-transitions stylesheet, so the palette swap is a hard cut; swatches repaint via `var()`, printed values/ratios re-measure via the MutationObserver.
- ThemeToggle indicator: sliding pill (`useSlidingIndicator` watching `data-state`), `bg-card shadow-e1`, hidden (`opacity: 0`) until first measurement, no fly-in on first paint.
- Nothing else animates: swatch rows are static; no entrance/reveal animations on this page.

Default transition tokens (context): `--duration-tick 80ms / fast 150ms / base 250ms / slow 400ms`; `--ease-out cubic-bezier(0.22,1,0.36,1)`, `--ease-spring cubic-bezier(0.34,1.56,0.64,1)`.

---

## 12. Internal drift (both sides, explicitly)

1. **Nav registry vs page chips.** `lib/ds/nav.ts` colors category `contents` = `["Surfaces","Action ramp","Value ramp","Text","Borders","Semantic","What is not a token","70 / 20 / 10 balance"]` and blurb "Surfaces, the action and value ramps, text, hairlines, semantic states, and every contrast ratio measured live in both themes." — these render on the Foundations index card and drive the sidebar. The **page itself** renders chips `["Monochrome","Action ramp","Value ramp","State","What is not a token"]` and a different blurb (§2). Section headings on the page are Monochrome/Action/Value/State/beyond; there is no "70 / 20 / 10 balance" section (the 70/20/10 target lives only in `globals.css` comments).
2. **"Aliased by --input" on the Accent swatch** is true in dark only (dark `--accent` = `--input` = `hsl(240 5.3% 26.1%)`); in light `--accent` = `hsl(240 4.8% 95.9%)` while `--input` = `hsl(240 5.9% 90%)` (= `--border`). Copy claims the alias unconditionally.
3. **"Aliased by --secondary and --border" on the Muted swatch**: `--secondary` matches in both themes; `--border` matches in dark (15.9%) but in light `--border` = 90% ≠ `--muted` 95.9%.
4. **Copy vs measurement, muted-foreground**: note says "about 13:1" on dark; live badge computes 13.5:1.
5. **Destructive**: `globals.css` comment claims "on near-black it measures about 3.1:1"; the live badge against `--background` computes ≈4.1:1 (≈3.7:1 vs `--card`). The page shows the measured figure; the comment is stale.
6. **Note title colour**: tone map (`text-action-ink`/`text-value-ink`) implies tinted titles, but `.type-label`'s own `color: var(--muted-foreground)` wins on the title element — titles are grey in all three tones (§3 caveat). Port the rendered result, not the apparent intent.
7. **Typo shipped verbatim**: "in the same same row" (state note).
8. **Fonts**: `globals.css` prose says "Space Grotesk owns words" and nav.ts's typography blurb says the same, but tokens define `--font-sans: "Inter Local"` and `--font-mono: var(--font-geist-mono)` (Geist Mono). Per project decision, tokens win: this page renders Inter Local for words, Geist Mono for `type-num-sm`/`type-code`.
9. **Action-bright light-mode failure**: colors-page badge computes 1.9:1; a `globals.css` chart comment cites 1.81:1 for the same pair — same verdict, different decimal.

## 13. Key token/class values needed to reproduce (quick reference)

Radii: `rounded-sm 6px · rounded-lg 12px · rounded-xl 16px · rounded-pill 999px`. Type classes used here: `type-h1 clamp(32→40px)/1.1/700/−0.02em · type-h3 21px/1.3/600/−0.01em · type-h4 17px/1.4/600 · type-lead 17px/1.65/400 muted · type-small 13px/1.5/400 muted · type-label 11px/1/600 upper 0.16em muted · type-chip 11.5px/1.2/500 · type-micro 10.5px/1/600 upper 0.18em muted · type-num-sm mono 12px/1.2/600 −0.01em tabular · type-code mono 12.5px/1.4`. Wash opacities: Note action/value/error = `bg-<tone>/[0.08]`, `border-<tone>/30`. Spacing rhythm: header `mb-14 pb-10`; lead note `mb-12`; sections `mb-20`, heading block `mb-6`; in-section notes `mt-4`; swatch rows `p-4`; panel body `p-6`; foot nav `mt-8 pt-8`.

---

## 14. CORRECTION 2026-08-14 — the printed `TokenValue` strings above are wrong

Everything above this line is left as first written. This section supersedes the **"value shown"** columns in §5, §6, §7 and §8, and the claim in §1.1 that `getComputedStyle(document.documentElement).getPropertyValue(token).trim()` yields *"the raw authored CSS text after `var()` substitution"*.

### What was wrong

§1.1 reasoned from `globals.css` source: since the stylesheet writes `--background: hsl(240 10% 3.9%)`, the readout was recorded as `hsl(240 10% 3.9%)`. It is not. The page prints `#09090b`. **Eleven of the eighteen rows were affected** — every row whose token `globals.css` authors as `hsl()`. The seven rows authored as hex (`#d9f99d`, `#a3e635`, `#4d7c0f`, `#10b981`, `#fbbf24`, `#22d3ee`, and `--color-value-bright`'s repeat) were right by accident.

### Why

The mechanism in §1.1 is correct — `getPropertyValue` really does hand back declaration text rather than a normalised `rgb()`. The error was assuming the browser is served `globals.css`. It is not: Tailwind v4 compiles the sheet through **Lightning CSS**, whose colour minifier rewrites every colour to its shortest equivalent form before the dev server responds. So the declaration the browser parses is already `#09090b`, and that is the text it reads back.

Two consequences worth recording:

- The output is **lowercase hex**, six digits, collapsed to three where every byte's nibbles match — so `hsl(0 0% 100%)` prints **`#fff`**, the table's one shape variation.
- This is *not* the typed-`@theme`-registration story it first looks like. Checked directly on the live page: the compiled sheet contains 100 `@property` rules, and **not one of them registers a colour token** — the eight non-`--tw-*` registrations are `--scroll-fade-*`, `--shimmer-*`. Nothing about CSSOM colour serialisation is involved; CSSOM would emit `rgb(9, 9, 11)` and never `#fff`.

### The measured table

Read from the DOM (`textContent` of the `.type-num-sm` value line in each swatch row) at 1440×900, theme forced pre-load via `localStorage.setItem('theme', …)`, after `document.fonts.ready`:

| # | § | Token | Dark | Light | Was recorded as (dark / light) |
|---|---|---|---|---|---|
| 1 | 5 | `--background` | `#09090b` | `#fff` | ✗ `hsl(240 10% 3.9%)` / `hsl(0 0% 100%)` |
| 2 | 5 | `--card` | `#18181b` | `#fff` | ✗ `hsl(240 5.9% 10%)` / `hsl(0 0% 100%)` |
| 3 | 5 | `--muted` | `#27272a` | `#f4f4f5` | ✗ `hsl(240 3.7% 15.9%)` / `hsl(240 4.8% 95.9%)` |
| 4 | 5 | `--accent` | `#3f3f46` | `#f4f4f5` | ✗ `hsl(240 5.3% 26.1%)` / `hsl(240 4.8% 95.9%)` |
| 5 | 5 | `--foreground` | `#fafafa` | `#09090b` | ✗ `hsl(0 0% 98%)` / `hsl(240 10% 3.9%)` |
| 6 | 5 | `--muted-foreground` | `#d4d4d8` | `#62626a` | ✗ `hsl(240 4.9% 83.9%)` / `hsl(240 4% 40%)` |
| 7 | 6 | `--color-action-ink` | `#92c2fc` | `#143694` | ✗ `hsl(213 94% 78%)` / `hsl(224 76% 33%)` |
| 8 | 6 | `--color-action-bright` | `#92c2fc` | `#92c2fc` | ✗ `hsl(213 94% 78%)` |
| 9 | 6 | `--color-action` | `#1a6ef4` | `#1a6ef4` | ✗ `hsl(217 91% 53%)` |
| 10 | 6 | `--color-action-dark` | `#143694` | `#143694` | ✗ `hsl(224 76% 33%)` |
| 11 | 7 | `--color-value-ink` | `#d9f99d` | `#4d7c0f` | ✓ |
| 12 | 7 | `--color-value` | `#a3e635` | `#a3e635` | ✓ |
| 13 | 7 | `--color-value-bright` | `#d9f99d` | `#d9f99d` | ✓ |
| 14 | 7 | `--color-value-dark` | `#4d7c0f` | `#4d7c0f` | ✓ |
| 15 | 8 | `--color-success` | `#10b981` | `#10b981` | ✓ |
| 16 | 8 | `--color-warning` | `#fbbf24` | `#fbbf24` | ✓ |
| 17 | 8 | `--color-info` | `#22d3ee` | `#22d3ee` | ✓ |
| 18 | 8 | `--destructive` | `#dc2626` | `#dc2626` | ✗ `hsl(0 72.2% 50.6%)` |

The **badge** columns in §5–8 are unaffected and were re-confirmed against the same run, with one already-known exception: §5 badges dark `--foreground` at `19.0:1` and the page renders `19.1:1` (pinned in `example/test/contrast_test.dart`).

### What the port does with it

`DsTokenRegistry.printedValue` no longer carries a per-token string table. Shortest-hex is a pure function of the resolved colour, so the readout is **derived** from the same `DsThemeData` field the swatch paints (`dsCssColorText` in `example/lib/token_swatch.dart`) — nothing is hardcoded, and a rebrand moves the swatch and its caption together. Verified against all 43 custom properties the compiled sheet actually emits, both themes, exact string match.

Also observed while sweeping the full registry, and *not* acted on: `--color-success-ink`, `--color-warning-ink`, `--color-info-ink` and `--color-destructive-ink` return **empty** on the live page — Tailwind tree-shakes `@theme` variables no generated utility references. None is swatched on this page. The port keeps them registered, since their absence is a property of what the reference site happens to use rather than of the design system.