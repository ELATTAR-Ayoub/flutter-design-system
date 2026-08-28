# Map — `/design-system` overview page (app/design-system/page.tsx)

Source files read in full: `app/design-system/page.tsx`, `app/design-system/layout.tsx`, `components/el/kit.tsx`, `components/el/el-nav.tsx`, `components/el/theme-toggle.tsx`, `components/el/logo.tsx`, `components/ui/icon.tsx`, `components/ui/sliding-indicator.tsx`, `lib/el/nav.ts`, `app/globals.css` (tokens, type classes, motion utilities).

---

## 0. Shell the page renders inside (`app/design-system/layout.tsx`)

Wrapper: `div.flex.min-h-dvh.flex-col`.

**Header** — `sticky top-0 z-40 flex h-(--height-site-header) shrink-0 items-center gap-4 border-b border-border bg-background/85 px-6 backdrop-blur-xl`. `--height-site-header: 4rem` (64px). Children left→right:
1. `MobileNav` — visible `<lg` only: `Button variant="outline" size="icon"` (`size-10`, `border-input bg-card shadow-btn hover:bg-muted active:shadow-btn-down`, rounded per Button) containing `Icon icon={Menu}` (16px, stroke 2.4) + `sr-only` "Open design system navigation". Opens shadcn `Sheet side="left"` `w-72 overflow-y-auto px-6` with `SheetHeader px-0` → `SheetTitle` → Logo link → same `NavTree` as sidebar.
2. `Link href="/design-system"` class `press` wrapping `Logo`.
3. Version indicator: `<span class="type-micro hidden rounded-pill border border-border px-2.5 py-1 sm:block" aria-label="Design system version">` — text verbatim: **"Design System v0.1"**.
4. `<span class="ml-auto type-micro hidden md:block">` — verbatim: **"Desktop-first · 1440 frame · Light & dark"** (`&amp;` → "&").
5. `ThemeToggle className="ml-auto md:ml-4"`.

**Body row**: `div.mx-auto flex w-full max-w-(--width-shell) flex-1 items-start` — `--width-shell: 1680px`.
- `Sidebar`: `aside.sticky top-(--height-site-header) hidden h-[calc(100dvh-var(--height-site-header))] w-60 shrink-0 overflow-y-auto border-r border-border px-6 pt-10 scrollbar-thin lg:block` (240px wide; thin scrollbar: `scrollbar-width: thin; scrollbar-color: var(--border) transparent`, WebKit 8px, thumb `--border` radius 999px, hover `--muted-foreground`).
- `main.min-w-0 flex-1 px-6 py-12 lg:px-12` → inner `div.mx-auto max-w-(--width-content)` — `--width-content: 1080px`. Page children render here.

**NavTree** (sidebar + sheet): `nav[aria-label="Design system"].pb-16`; per group `div.mb-8`: group link `type-label mb-3 block transition-colors duration-fast hover:text-muted-foreground`, `text-action-ink` when `pathname === group.href` else `text-muted-foreground` — on this route the **Foundations** group link is active (its href IS `/design-system`). Category list `ul.space-y-px.border-l.border-border`; item link `type-nav -ml-px block border-l py-2 pl-4 transition-colors duration-fast`; active: `border-action bg-action/12 text-foreground` + `aria-current="page"`; inactive: `border-transparent text-muted-foreground hover:border-input hover:text-foreground`. Group order: Foundations (6), Base Components (14), Agent (6), Site Pages (6).

**ThemeToggle** — three-way `role="radiogroup"` `aria-label="Colour theme"`: `relative inline-flex items-center gap-px rounded-pill border border-border bg-muted p-0.5`. First child `SlidingIndicator`: absolutely positioned travelling pill (`pointer-events-none absolute top-0 left-0 w-0 opacity-0 slide-pill`; inner span `block size-full rounded-pill bg-card shadow-e1`). `slide-pill` = transition `transform/width/height 250ms var(--ease-spring)`, `opacity 150ms var(--ease-out)`. Pill measures the checked option via MutationObserver on `data-state` + ResizeObserver; first move renders with `transition: none` (appears in place); each subsequent landing replays `anim-jelly` = `yuki-jelly 0.6s var(--ease-out) both` (keyframes: 0% scale3d(1,1,1) → 30% (1.18,0.82,1) → 45% (0.88,1.12,1) → 60% (1.06,0.94,1) → 78% (0.98,1.02,1) → 100% (1,1,1)). Options (order): Light/SunIcon, System/MonitorIcon, Dark/MoonIcon — each `button role="radio"` `press relative z-10 grid size-7 place-items-center rounded-pill transition-colors duration-fast ease-out`, active `text-foreground` else `text-muted-foreground hover:text-foreground`, icon `size-3.5` (14px). Pre-hydration nothing is checked → pill `opacity: 0` (uses `useSyncExternalStore`, server snapshot false).

**Logo** — `span.flex.items-center.gap-2.5`: `LogoMark` = `span aria-hidden` `relative grid size-7 shrink-0 place-items-center rounded-md bg-action` containing `svg viewBox="0 0 24 24" class="size-4" fill="none"` with two paths: chevron `d="M6 15.5 12 6l6 9.5"` stroke `var(--primary-foreground)` width 2.4 linecap square; baseline `d="M6 19h12"` stroke `var(--color-value-bright)` width 2.4. Wordmark: `span.type-wordmark.text-foreground` → `ELATTAR` + nested `span.text-value-ink` → `ELATTAR`.

Page atmosphere (from `@layer base`): `body` carries `background-image: radial-gradient(120% 90% at 62% 34%, var(--background-effect) 0%, transparent 64%); background-attachment: fixed; background-repeat: no-repeat` over `bg-background`. `--background-effect`: dark `hsl(240 8% 10%)`, light `hsl(240 30% 98%)`. `html`: `scroll-behavior: smooth`, `scroll-padding-block-start: var(--scroll-offset)` where `--scroll-offset = calc(4rem + var(--spacing)*8)` = 96px (no `scroll-mt-*` anywhere — `Section` deliberately has none). `:focus-visible` = `outline: 2px solid var(--ring); outline-offset: 2px`. `::selection` = `color-mix(in oklab, var(--color-action) 35%, transparent)` behind `var(--foreground)`. Default transition: 250ms `var(--ease-out)`.

---

## 1. Page header — `PageHeader`

`header.mb-14.border-b.border-border.pb-10`:
- Eyebrow `p.type-label.text-action-ink` — verbatim: **"Elattar's Design System"**
- `h1.type-h1.mt-4.text-foreground` — verbatim: **"Design System"**
- `p.type-lead.mt-4.max-w-2xl` — verbatim: **"The operating manual. Two brand roles named for what they mean rather than what they look like, two complete themes, and every value measured out of the live stylesheet rather than claimed. Everything here is a live component, not a picture of one."**
- The optional `contents` chip row is NOT rendered on this page (prop omitted).

---

## 2. Section `#foundations` — "Foundations"

`Section` markup: `section#foundations.mb-20` → `div.mb-6` → `h2.type-h3.text-foreground` **"Foundations"** + `p.type-small.mt-2.max-w-2xl` **"The decisions everything else inherits. Change something here and it propagates through every base component and the entire agent console."** (Note: section titles are `h2` styled with `.type-h3`.)

Body: `IndexGrid` = `div.grid.gap-4.sm:grid-cols-2.xl:grid-cols-3` (1 col → 2 ≥640px → 3 ≥1280px, 16px gap) with **6 `IndexCard`s**, order and verbatim data from `lib/el/nav.ts`:

| # | Title (h3) | href | Blurb (verbatim) | Chips (verbatim, in order) |
|---|---|---|---|---|
| 1 | Colors | `/design-system/colors` | "Surfaces, the action and value ramps, text, hairlines, semantic states, and every contrast ratio measured live in both themes." | Surfaces · Action ramp · Value ramp · Text · Borders · Semantic · What is not a token · 70 / 20 / 10 balance |
| 2 | Typography | `/design-system/typography` | "Two faces only: Space Grotesk for every word, Geist Mono for every number. Full specimen of each type class, plus the prose block that reaches the same scale without one." | Display · Headings · Body · Labels · Numerics · Prose · Rules |
| 3 | Spacing & Layout | `/design-system/spacing` | "The 8-point spacing scale, radius ladder, elevation set, 12-column grid and responsive breakpoints." | Spacing scale · Radius · Elevation · Grid · Breakpoints · Content width |
| 4 | Shadows | `/design-system/shadows` | "Two families: ambient depth, and machine surfaces that look like they can be physically pressed. Ported from Yukirhythm." | Ambient e1–e4 · Machine keys · Sunken sockets · Control depth · Rationed glow · Glass |
| 5 | Motion | `/design-system/motion` | "Durations, easing curves and the named animations — each one running live so timing can be judged, not guessed." | Durations · Easing · Interaction utilities · Named animations · Reveal choreography · Reduced motion |
| 6 | Icons | `/design-system/icons` | "The Icon component wrapping Lucide: fixed sizes, stroke rules, and the curated icon set, grouped by domain." | Icon component · Sizes · Tones · Navigation set · Action set · Domain set |

**IndexCard anatomy** (`components/el/kit.tsx`): `Link` class `lift group flex flex-col rounded-xl border border-border bg-card p-5 hover:border-action/45` (radius 16px, padding 20px).
- Top row: `div.flex.items-start.justify-between.gap-3` → `h3.type-h4.text-foreground` (title) + `Icon icon={ArrowRight} size="md" tone="muted"` className `mt-0.5 transition-[transform,color] duration-fast group-hover:translate-x-0.5 group-hover:text-action-ink` (16×16px, strokeWidth attr 2.4, `text-muted-foreground` at rest).
- Blurb: `p.type-small.mt-2.grow`.
- Chips: `ul.mt-4.flex.flex-wrap.gap-1.5.border-t.border-border.pt-4`; each `li.type-caption.rounded-sm.bg-muted.px-2.py-1.text-muted-foreground` (radius 6px).
- Hover behavior (composed): `lift` → `translateY(-3px)` + `box-shadow: var(--shadow-e3)` over `transform/box-shadow 250ms var(--ease-out)` and `border-color 250ms var(--ease-standard)`; border goes `--border` → `action/45`; arrow translates `translate-x-0.5` (+2px) and recolors to `text-action-ink` over `duration-fast` 150ms. No press/active state, no entrance animation.

---

## 3. Section `#components` — "Components"

`Section id="components"`, `h2.type-h3` **"Components"**, description (verbatim): **"Three families, deliberately separated. Base is the generic chassis any product could use. Agent is a complete AI console, written from scratch and pointed at a transport you supply. Site pages own no visual values of their own — only the composition rules that assemble the other two into a page."**

Body: `div.grid.gap-4.md:grid-cols-2` (1 col → 2 ≥768px; the third card wraps to row 2 left cell). **3 group cards**, inline in page.tsx (not IndexCard — larger padding, different label row):

Card markup: `Link` class `lift group flex flex-col rounded-xl border border-border bg-card p-7 hover:border-action/45` (28px padding).
- Head row `div.flex.items-start.justify-between.gap-4`: left `div` → `p.type-label.text-action-ink` = `{n} sets` → `h3.type-h3.mt-3.text-foreground` = group title. Right: `Icon icon={ArrowRight}` className `mt-1 size-5 shrink-0 text-muted-foreground transition-[transform,color] duration-fast group-hover:translate-x-0.5 group-hover:text-action-ink` + `aria-hidden` (note: `size` prop not passed → width/height attrs 16 & strokeWidth 2.4 computed for 16px, but `size-5` class forces 20×20px render; the extra `aria-hidden` prop is not in `IconProps` — Icon sets `aria-hidden=true` itself when no label).
- `p.type-small.mt-3.grow` = group blurb.
- `ul.mt-5.flex.flex-wrap.gap-1.5.border-t.border-border.pt-5`; each `li.type-caption.rounded-sm.bg-muted.px-2.py-1.text-muted-foreground` = category titles.
- Same `lift` hover as IndexCard.

Verbatim card data (order = EL_GROUPS order minus foundations):

**1. Base Components** — label **"14 sets"** — href `/design-system/components/base` — blurb: **"The shadcn chassis, restyled onto this system's tokens. Generic, reusable, product-agnostic."** — chips: Buttons · Inputs · Forms · Selects & Pickers · Selection Controls · Dialogs & Overlays · Menus · Navigation · Feedback · Chat · Data Display · Charts · Layout Primitives · Sidebar.

**2. Agent** — label **"6 sets"** — href `/design-system/components/agent` — blurb: **"A complete AI console — transcript, composer, avatar and voice — pointed at a transport you supply. Written from scratch, and product-agnostic by construction."** — chips: Console · Avatar · Composer · Transcript · History · Voice.

**3. Site Pages** — label **"6 sets"** — href `/design-system/components/site` — blurb: **"Composition rather than controls: the containers, bands and reading columns that assemble an FAQ, a policy or a help article out of base components without inventing a single new visual value."** — chips: Page Structure · Page Introductions · Landing Hero · Reading Navigation · Content Sections · Site Chrome.

---

## 4. Section `#rules` — "The rules that outrank taste"

`Section id="rules"`, `h2.type-h3` **"The rules that outrank taste"**, description: **"Six non-negotiables. If a screen breaks one of these, the screen is wrong — not the rule."**

Body: `ol.divide-y.divide-border.overflow-hidden.rounded-xl.border.border-border.bg-card` (one card, 16px radius, 1px row dividers). Each `li.flex.gap-5.px-6.py-5`:
- Number: `span.type-num-sm.shrink-0.text-action-ink`, zero-padded `01`–`06` (Geist Mono, 12px, 600, tabular).
- Copy: `p.type-small.text-muted-foreground` with `strong.font-semibold.text-foreground` for the bold lead, then a literal space, then detail.

Verbatim rules:
1. **"Two complete themes."** "Dark is the default, and light is equally supported. Roughly 70% of any screen is neutral surface from the five-step ladder, 20% blue, 10% lime."
2. **"Blue acts, lime values."** "Blue is interaction: primary buttons, selection, active nav, focus. Lime is worth: balances, rewards, rankings, premium actions. Never swap them."
3. **"Glow is rationed."** "Only selected packs, rare cards, primary CTAs, opening moments and reward moments may glow. Ordinary surfaces stay flat and readable."
4. **"Two faces only."** "Space Grotesk for words. Geist Mono, tabular, for numerical values, serials and code through the named typography foundations."
5. **"Rarity is never color alone."** "Every rarity indicator carries its label and tier pips as well as its hue, so it survives grayscale and color blindness."
6. **"Nothing unskippable."** "The pack-opening sequence may be long, but skip and turbo are always reachable, and reduced-motion preferences are honoured."

---

## 5. Closing `Note` (tone="value")

`div.rounded-lg.border.p-5` + tone classes `border-value/30 bg-value/[0.08] text-value-ink` (12px radius). Title `p.type-label.mb-2` (inherits value-ink): **"Scope of this phase"**. Body `div.type-small.text-muted-foreground`, verbatim: **"This is the design system and component library. The ten product screens are built on top of it and are tracked separately — nothing in here implements a real wallet, payment, blockchain or shipping integration. All figures, packs, cards and users are placeholder data."** Not inside a Section — no `mb-20`; it is the last child of the page.

---

## 6. Exact token values referenced by this page

**Type classes** (globals.css `@layer components`; sans = `--font-sans` unless noted):
- `.type-h1`: `clamp(2rem, 2.8vw, 2.5rem)` (32→40px) / lh 1.1 / 700 / tracking −0.02em
- `.type-h3`: 1.3125rem (21px) / 1.3 / 600 / −0.01em
- `.type-h4`: 1.0625rem (17px) / 1.4 / 600
- `.type-lead`: 1.0625rem / 1.65 / 400 / color `--muted-foreground`
- `.type-small`: 0.8125rem (13px) / 1.5 / 400 / color `--muted-foreground`
- `.type-label`: 0.6875rem (11px) / 1 / 600 / uppercase / tracking 0.16em / color `--muted-foreground`
- `.type-caption`: 0.65625rem (10.5px) / 1.35 / 500
- `.type-micro`: 0.65625rem / 1 / 600 / uppercase / tracking 0.18em / color `--muted-foreground`
- `.type-chip`: 0.71875rem (11.5px) / 1.2 / 500 (used by PageHeader chips — not rendered here)
- `.type-nav`: 0.84375rem (13.5px) / 1.2 / 500 (sidebar)
- `.type-num-sm`: `--font-mono` (Geist Mono) / 0.75rem (12px) / 1.2 / 600 / tabular-nums / tracking −0.01em
- `.type-wordmark`: 0.9375rem (15px) / 1 / 700 / tracking −0.01em

**Fonts**: `--font-sans: "Inter Local", ui-sans-serif, system-ui, sans-serif` (variable woff2 `/fonts/inter-variable.woff2`, weights 100–900); `--font-mono: var(--font-geist-mono), ui-monospace, monospace`; `--font-heading: "Inter Local", …`. (See drift §8.)

**Colors** (dark / light):
- `--background`: `hsl(240 10% 3.9%)` zinc-950 / `hsl(0 0% 100%)`
- `--foreground`: `hsl(0 0% 98%)` / `hsl(240 10% 3.9%)`
- `--card`: `hsl(240 5.9% 10%)` zinc-900 / `hsl(0 0% 100%)`
- `--muted`: `hsl(240 3.7% 15.9%)` zinc-800 / `hsl(240 4.8% 95.9%)` zinc-100
- `--muted-foreground`: `hsl(240 4.9% 83.9%)` zinc-300 / `hsl(240 4% 40%)`
- `--border`: `hsl(240 3.7% 15.9%)` / `hsl(240 5.9% 90%)`; `--input`: `hsl(240 5.3% 26.1%)` / `hsl(240 5.9% 90%)`
- Action ramp (theme-independent): `--color-action-bright hsl(213 94% 78%)` ≈ #92C2FC; `--color-action hsl(217 91% 53%)` ≈ #1A6EF4; `--color-action-dark hsl(224 76% 33%)` ≈ #143694. `--action-ink` = bright on dark, dark on light. `bg-action/12` and `hover:border-action/45` derive from `--color-action`.
- Value ramp: `--color-value-bright #d9f99d`; `--color-value #a3e635`; `--color-value-dark #4d7c0f`. `--value-ink` = bright on dark, dark on light. Note tint: `bg-value/[0.08]`, `border-value/30` from `--color-value`.
- `--primary-foreground`: pure white `hsl(0 0% 100%)` both themes. `--ring`: `--color-action-bright` dark / `--color-action` light.
- Shadow inks — dark: `--ink-1..4` = rgb(0 0 0 / 0.35 / 0.5 / 0.6 / 0.75); light: `hsl(240 20% 20% / 0.04 / 0.07 / 0.11 / 0.16)`.

**Radii**: `rounded-sm` 6px, `rounded-md` 10px, `rounded-lg` 12px, `rounded-xl` 16px, `rounded-pill` 999px.

**Shadows used here**: `--shadow-e1: 0 1px 1px var(--ink-2), 0 1px 3px var(--ink-1)` (theme-toggle pill); `--shadow-e3: 0 2px 4px var(--ink-2), 0 14px 28px -8px var(--ink-3)` (lift hover); `--shadow-btn` on the outline button (mobile trigger): `inset 0 1px 0 var(--rim), inset 0 -2px 4px var(--ink-2), 0 1px 2px var(--ink-2), 0 3px 8px -2px var(--ink-2)`; `--rim`: dark `rgb(255 255 255 / 0.14)`, light `hsl(0 0% 100% / 0.85)`.

**Motion tokens**: `--duration-tick 80ms`, `--duration-fast 150ms`, `--duration-base 250ms`; `--ease-out cubic-bezier(0.22, 1, 0.36, 1)`, `--ease-spring cubic-bezier(0.34, 1.56, 0.64, 1)`, `--ease-standard cubic-bezier(0.4, 0, 0.2, 1)`. Default transition = 250ms ease-out.

---

## 7. Interaction inventory (everything that moves on this route)

1. **Card hover (`lift`)** — both IndexCards and group cards: rest→hover `translateY(-3px)`, shadow none→`e3`, border `--border`→`action/45`; transform/box-shadow 250ms `ease-out`, border-color 250ms `ease-standard`. Simultaneous child (`group-hover:`): arrow icon `translateX(2px)` + color `muted-foreground`→`action-ink`, both 150ms.
2. **`press`** (logo link, theme-toggle options): `:active` `scale(0.94)` in 40ms, release springs back 250ms `ease-spring`.
3. **Theme toggle pill travel**: transform/width/height 250ms `ease-spring`, opacity 150ms `ease-out`; arrival replays `yuki-jelly` 0.6s `ease-out` (squash-stretch keyframes in §0); suppressed on first paint.
4. **Sidebar links**: color/border-color transitions 150ms (`transition-colors duration-fast`); active = 1px `border-action` rule + `bg-action/12`.
5. **Anchor scrolling**: `scroll-behavior: smooth`, headings rest 96px below viewport top; disabled under `prefers-reduced-motion` (global `scroll-behavior: auto !important` block).
6. **No entrance/stagger animations** on this page — content renders statically (server component; only nav/theme-toggle are client components).

Links on the page: 6 IndexCard hrefs (§2 table), 3 group hrefs (§3), sidebar: 4 group index links + 32 category links (foundations 6 use `/design-system/{slug}`; others `/design-system/components/{base|agent|site}/{slug}`), logo → `/design-system`.

---

## 8. Internal drift (both sides, explicitly)

1. **Typeface copy vs tokens.** Page rule 4 says "Space Grotesk for words. Geist Mono … for numerical values"; nav.ts Typography blurb says "Space Grotesk for every word" (its comment even claims `--font-sans` IS Space Grotesk); globals.css §Typography comment says "Space Grotesk owns words". But the tokens actually load **"Inter Local"** for `--font-sans` and `--font-heading` (`@font-face` → `/fonts/inter-variable.woff2`). Mono is genuinely Geist Mono. Per the project decision "fonts follow tokens not prose": render **Inter**, keep the Space Grotesk copy verbatim.
2. **Action-ramp hexes**: comments state the rasterised values (#92C2FC/#1A6EF4/#143694) and explicitly note the old annotations #93C5FD/#2563EB/#1D4ED8 were wrong; the `hsl()` values are authoritative.
3. **Components-section arrow Icon**: SVG attrs computed for 16px (`strokeWidth 2.4`) but CSS `size-5` renders it at 20px — visual stroke ≈ 2px; the sibling IndexCard arrow is a true 16px with the same 2.4 attr. Also an `aria-hidden` prop is passed that `IconProps` doesn't declare (harmless — Icon already sets `aria-hidden` when unlabelled).
4. **Section headings** are `h2` elements wearing `.type-h3` (21px), while card titles are `h3` wearing `.type-h4`/`.type-h3` — heading level and type class deliberately decoupled.
5. `.type-label`/`.type-micro` own their `--muted-foreground` color, yet call sites still stack explicit color overrides (`text-action-ink` on eyebrow/"n sets", `text-muted-foreground` on Panel labels) — override wins.


---

## CORRECTION - 2026-08-15 - the arrow, the nav links and the theme toggle do not run at 150ms

*(Corpus-wide sweep prompted by `selection-map.md` §7.1; mechanism and probe
record in `forms-map.md`'s 2026-08-15 correction block.)*

**Tailwind v4 has no `--duration-*` theme namespace**, so a `duration-fast` in a
`className` emits no CSS and the element falls through to
`--default-transition-duration: 250ms` (`globals.css:395`). Four claims in this
map read the class name rather than the cascade:

| where | map says | **actually renders** *(probed 2026-08-15, 1440 x 900)* |
|---|---|---|
| IndexCard arrow, `transition-[transform,color] duration-fast` | "arrow translates `translate-x-0.5` (+2px) and recolors to `text-action-ink` over `duration-fast` **150ms**" | **250ms** |
| Motion summary, "Card hover (`lift`)" | "arrow icon `translateX(2px)` + color ..., **both 150ms**" | **250ms** |
| NavTree group link and category link, `transition-colors duration-fast` | *(no number stated - but the class implies 150)* | **250ms** each |
| ThemeToggle option button, `press ... transition-colors duration-fast ease-out` | *(no number stated)* | **250ms** |

Unaffected in the same paragraphs, because they read `var(--duration-*)`
directly: the `lift` utility's 250ms transform / box-shadow / border-color legs,
the `slide-pill` travel (250ms transform/width/height, **150ms** opacity -
genuinely 150), and `anim-jelly`'s 600ms arrival replay.

**Also worth recording** *(observed during the same probe; out of scope, not
fixed)*: on the theme-toggle button the layered `transition-colors` utility
**replaces** `press`'s `transition: transform ...` shorthand. The probed
`transitionProperty` is the colour list only, with no `transform`, so `press`'s
`:active { scale(0.94) }` snaps in and out with no tween on that control. Same
shape on `/design-system/components/base/navigation`'s `type-nav press` rows.

**Port impact.** `example\lib\kit.dart`'s `_CardArrow`,
`example\lib\shell.dart`'s `_ColorFade` (shared by both nav levels) and
`example\lib\theme_toggle.dart` moved from `Durations.fast` to
`Durations.transitionDefault`.
