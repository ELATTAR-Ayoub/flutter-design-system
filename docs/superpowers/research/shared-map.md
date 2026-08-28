# Shared docs components — design-system pages (home, colors, typography, spacing)

Audited pages: `app/design-system/page.tsx` (home), `app/design-system/colors/page.tsx`, `app/design-system/typography/page.tsx`, `app/design-system/spacing/page.tsx`, plus the section shell `app/design-system/layout.tsx` and root `app/layout.tsx`.

---

## 1. Shell / chrome

### Root layout — `app/layout.tsx`
- `<html lang="en" suppressHydrationWarning class="${GeistMono.variable} h-full antialiased">`; `<body class="min-h-full flex flex-col bg-background text-foreground">`.
- Wraps everything in `ThemeProvider` → `TooltipProvider delayDuration={200}` → children → `Toaster position="bottom-right"`.
- Metadata title: `Elattar's Design System`.

### `ThemeProvider` — `components/el/theme-provider.tsx`
- next-themes: `attribute="class"`, `defaultTheme="dark"`, `enableSystem`, `disableTransitionOnChange` (kills all transitions for one frame on toggle — without it ~200 surfaces smear over 250ms). Used by every page.

### Docs shell — `app/design-system/layout.tsx` (all 4 pages)
- **Header**: `sticky top-0 z-40 flex h-(--height-site-header) shrink-0 items-center gap-4 border-b border-border bg-background/85 px-6 backdrop-blur-xl`. `--height-site-header: 4rem` (64px).
  - Children in order: `MobileNav` → `Link href="/design-system" class="press"` wrapping `Logo` → version pill `<span class="type-micro hidden rounded-pill border border-border px-2.5 py-1 sm:block">Design System v0.1</span>` → `<span class="ml-auto type-micro hidden md:block">Desktop-first · 1440 frame · Light & dark</span>` → `ThemeToggle class="ml-auto md:ml-4"`.
- **Body row**: `mx-auto flex w-full max-w-(--width-shell) flex-1 items-start` (`--width-shell: 1680px`) → `Sidebar` + `<main class="min-w-0 flex-1 px-6 py-12 lg:px-12">` → inner `<div class="mx-auto max-w-(--width-content)">` (`--width-content: 1080px`).
- Anchor offset: no `scroll-mt-*` anywhere; `html` carries `scroll-padding-block-start: var(--scroll-offset)` where `--scroll-offset: calc(var(--height-site-header) + var(--spacing) * 8)` = 64 + 32 = **96px**.

### `Sidebar` / `MobileNav` / `NavTree` — `components/el/el-nav.tsx` (all 4 pages; client component)
- **Sidebar** (no props): `<aside class="sticky top-(--height-site-header) hidden h-[calc(100dvh-var(--height-site-header))] w-60 shrink-0 overflow-y-auto border-r border-border px-6 pt-10 scrollbar-thin lg:block">` — 240px wide, desktop-only (`lg:`), thin scrollbar.
- **NavTree** (`onNavigate?: () => void`): `<nav aria-label="Design system" class="pb-16">`. Per group (`div.mb-8`):
  - Group link: `type-label mb-3 block transition-colors duration-fast hover:text-muted-foreground`; active (pathname === group.href) → `text-action-ink`, else `text-muted-foreground`.
  - Category list: `<ul class="space-y-px border-l border-border">`; each link: `type-nav -ml-px block border-l py-2 pl-4 transition-colors duration-fast` + `aria-current="page"` when active. Active: `border-action bg-action/12 text-foreground` (1px blue rule replacing the hairline — deliberately no glow, no extra `font-medium`; `.type-nav` already carries 500). Inactive: `border-transparent text-muted-foreground hover:border-input hover:text-foreground`.
- **MobileNav** (no props): `Sheet` (Radix Dialog) with trigger `Button variant="outline" size="icon" class="lg:hidden"` containing `Icon icon={Menu}` + `sr-only` "Open design system navigation". `SheetContent side="left" class="w-72 overflow-y-auto px-6"` (288px, overrides default `w-3/4 sm:max-w-sm`); `SheetHeader class="px-0"` with `SheetTitle asChild` → `Link` → `Logo`; then `NavTree`.

### `Logo` / `LogoMark` — `components/el/logo.tsx`
- `LogoMark({className})`: `<span aria-hidden class="relative grid size-7 shrink-0 place-items-center rounded-md bg-action">` containing a `size-4` SVG (viewBox 0 0 24 24, fill none): chevron `d="M6 15.5 12 6l6 9.5"` stroke `var(--primary-foreground)` width 2.4 `strokeLinecap="square"`, plus underline `d="M6 19h12"` stroke `var(--color-value-bright)` width 2.4.
- `Logo({className, showMark=true})`: `<span class="flex items-center gap-2.5">` → mark + `<span class="type-wordmark text-foreground">ELATTAR</span>`. The `ELATTAR` suffix is the wordmark's entire 10% value allowance.
- `.type-wordmark`: 0.9375rem / line-height 1 / weight 700 / tracking `--tracking-num` (−0.01em).

### `ThemeToggle` — `components/el/theme-toggle.tsx` (all 4 pages; client)
- Props: `{className?}`. Three-way segmented control Light · System · Dark (`SunIcon`/`MonitorIcon`/`MoonIcon`), `role="radiogroup" aria-label="Colour theme"`.
- Container: `relative inline-flex items-center gap-px rounded-pill border border-border bg-muted p-0.5`.
- One travelling `SlidingIndicator` indicator: `block size-full rounded-pill bg-card shadow-e1` — options paint **no** background of their own (RULES §4: selection travels, never blinks).
- Options: `<button role="radio" data-state="on"|"off" aria-checked title label>`; classes `press relative z-10 grid size-7 place-items-center rounded-pill transition-colors duration-fast ease-out`; active `text-foreground`, inactive `text-muted-foreground hover:text-foreground`; icon `size-3.5` (14px).
- Hydration: `useSyncExternalStore` (server=false/client=true); before mount nothing is checked → pill `opacity: 0`, then appears in place (no fly-in) because the hook suppresses transition on first move.

### `SlidingIndicator` / `useSlidingIndicator` — `components/ui/sliding-indicator.tsx`
- Hook args (defaults): `activeSelector = '[data-state="on"],[data-state="active"]'`, `arrivalAnimation = "anim-jelly"`, `attributeName = "data-state"`. Returns `{containerRef, indicatorRef, jellyRef}`.
- Measures via `getBoundingClientRect()` deltas (not offsetLeft/Top), subtracts container border, adds `scrollLeft/Top`; sets pill `width/height/transform/opacity` inline. Nothing selected → `opacity: 0`. First move: `transition: none` for one frame. Every arrival: removes the arrival class, forces reflow (`void offsetWidth`), re-adds it → replays jelly. MutationObserver on `attributeName` (subtree) + ResizeObserver on container.
- Outer span: `pointer-events-none absolute top-0 left-0 w-0 opacity-0 slide-pill`; inner (jelly host) default `block size-full rounded-pill bg-primary shadow-chip` unless `className` given; optional `children` painted inside.
- Motion tokens: `slide-pill` = `transform/width/height 250ms cubic-bezier(0.34,1.56,0.64,1)` (`--duration-base`/`--ease-spring`), `opacity 150ms cubic-bezier(0.22,1,0.36,1)` (`--duration-fast`/`--ease-out`). `anim-jelly` = `yuki-jelly 0.6s var(--ease-out) both`; keyframes: 0% scale3d(1,1,1) → 30% (1.18,0.82,1) → 45% (0.88,1.12,1) → 60% (1.06,0.94,1) → 78% (0.98,1.02,1) → 100% (1,1,1).

---

## 2. Kit — `components/el/kit.tsx` (the docs component library)

### `PageHeader({eyebrow, title, blurb, contents?})` — all 4 pages
- `<header class="mb-14 border-b border-border pb-10">`
- Eyebrow: `type-label text-action-ink`. Title: `<h1 class="type-h1 mt-4 text-foreground">`. Blurb: `type-lead mt-4 max-w-2xl`.
- Contents chips (optional): `<ul class="mt-7 flex flex-wrap gap-2">`; each `<li class="type-chip rounded-pill border border-border bg-card px-3 py-1.5 text-muted-foreground">`.

### `Section({id, title, description?, children, className?})` — all 4 pages
- `<section id class="mb-20">`; heading block `mb-6`; **`<h2 class="type-h3 text-foreground">`** (h2 element, h3 class — intentional); description `type-small mt-2 max-w-2xl`. No scroll-margin (see `--scroll-offset` above).

### `Panel({label?, note?, children, className?, bodyClassName?, flush=false})` — colors, typography, spacing
- Frame: `overflow-hidden rounded-xl border border-border bg-card`.
- Header strip (only if label or note): `flex items-baseline justify-between gap-4 border-b border-border bg-muted px-5 py-3`; label `type-label text-muted-foreground`; note `type-num-sm text-muted-foreground` (right-aligned).
- Body: `bg-background` + `p-6` (dropped when `flush`), overridable via `bodyClassName` (typography's prose panel uses `p-6 sm:p-10`).

### `Row({children, className?, align="center"|"start"|"end"|"baseline"})`
- `flex flex-wrap gap-4` + `items-{align}`. **Not used on the 4 audited pages** (used by component-family pages).

### `StateGrid({children, cols=4∈{2..6}, className?})` / `StateCell({label, note?, children, className?})`
- Grid: `grid gap-px overflow-hidden rounded-lg border border-border bg-border` (1px gaps painted by the border colour); cols map: 2→`grid-cols-1 sm:grid-cols-2`, 3→`grid-cols-2 sm:grid-cols-3`, 4→`grid-cols-2 sm:grid-cols-4`, 5→`grid-cols-2 sm:grid-cols-3 lg:grid-cols-5`, 6→`grid-cols-2 sm:grid-cols-3 lg:grid-cols-6`.
- Cell: `bg-background p-5`; specimen wrapper `mb-4 flex min-h-14 items-center justify-center`; label `type-micro text-center text-muted-foreground`; note `type-caption mt-1.5 text-center`. **Not used on the 4 audited pages.**

### `Meta({items: {k,v}[], className?})` — typography, spacing
- `<dl class="divide-y divide-border overflow-hidden rounded-lg border border-border bg-card">`; each row `grid gap-1 px-4 py-3 sm:grid-cols-[minmax(0,13rem)_1fr] sm:gap-4`; `<dt class="type-num-sm text-action-ink">` / `<dd class="type-small text-muted-foreground">`.

### `Code({children})` — colors, typography, spacing
- `<code class="type-code rounded-sm border border-border bg-card px-1.5 py-0.5 text-muted-foreground">`.

### `DoDont({dos: string[], donts: string[]})` — typography, spacing
- `grid gap-4 sm:grid-cols-2`.
- Do panel: `rounded-lg border border-value/25 bg-value/[0.06] p-5`; heading `type-label mb-3 text-value-ink` "Do"; `<ul class="space-y-2.5">`; items `flex gap-2.5` with `Icon icon={Check} size="sm" tone="value" class="mt-0.5"` + `type-small text-muted-foreground`.
- Don't panel: `border-destructive/25 bg-destructive/[0.06]`; heading `text-destructive-ink` "Don't" (`Don&rsquo;t`); `Icon icon={X} size="sm" tone="error"`.

### `Note({tone="action"|"value"|"error", title?, children, className?})` — all 4 pages
- `rounded-lg border p-5` + tone: action `border-action/30 bg-action/[0.08] text-action-ink`; value `border-value/30 bg-value/[0.08] text-value-ink`; error `border-destructive/30 bg-destructive/[0.08] text-destructive-ink`.
- Title `type-label mb-2` (inherits tone colour); body `type-small text-muted-foreground`.

### `IndexGrid({children})` / `IndexCard({href, title, blurb, contents})` — home only
- Grid: `grid gap-4 sm:grid-cols-2 xl:grid-cols-3`.
- Card (`Link`): `lift group flex flex-col rounded-xl border border-border bg-card p-5 hover:border-action/45`.
  - Top row `flex items-start justify-between gap-3`: `<h3 class="type-h4 text-foreground">` + `Icon icon={ArrowRight} size="md" tone="muted" class="mt-0.5 transition-[transform,color] duration-fast group-hover:translate-x-0.5 group-hover:text-action-ink"`.
  - Blurb `type-small mt-2 grow`; chips `<ul class="mt-4 flex flex-wrap gap-1.5 border-t border-border pt-4">`; `<li class="type-caption rounded-sm bg-muted px-2 py-1 text-muted-foreground">`.

### `PageFootNav({groupId, slug})` — colors, typography, spacing (not home)
- Uses `siblings()` from `lib/el/nav.ts`; returns null if neither neighbour.
- `<nav class="mt-8 flex items-stretch gap-4 border-t border-border pt-8">`.
- Prev link: `press flex min-w-0 flex-1 items-center gap-3 rounded-lg border border-border bg-card px-5 py-4 hover:border-input`; `Icon icon={ArrowLeft} size="md" tone="muted"`; caption `type-micro block text-muted-foreground` "Previous"; title `type-small mt-1 block truncate text-foreground`. Next mirrors (`justify-end`, `text-right`, arrow after). Missing side → `<span class="flex-1"/>` placeholder.

---

## 3. `TokenSwatch` family — `components/el/token-swatch.tsx` (colors page only; client)

Reads tokens from the **live stylesheet** — nothing hand-typed. `useSyncExternalStore` + one shared `MutationObserver` on `document.documentElement` watching `attributes: ["class", "style"]`; on any change both caches (`valueCache`, `ratioCache`) clear and all subscribers re-read. (Flutter equivalent: recompute printed values + ratios on theme change.)

- `useTokenValue(token)` → `getComputedStyle(documentElement).getPropertyValue(token).trim()` (server snapshot null).
- `useContrast(token, against="--background")` → WCAG ratio: resolve any CSS colour by painting a hidden probe div and reading computed `rgb()`; alpha-composite translucent fg onto bg; relative luminance with the 0.03928/12.92 + ((s+0.055)/1.055)^2.4 formula; ratio `(hi+0.05)/(lo+0.05)`.
- `TokenValue({token, className?})`: `<span class="type-num-sm text-muted-foreground">`, renders resolved value or `—`.
- `ContrastBadge({token, against?, className?})`: `type-micro text-muted-foreground`, text `Contrast {ratio.toFixed(1)}:1 · {verdict}`; verdict: ≥7 "AAA", ≥4.5 "AA", ≥3 "AA large / UI only" (all `text-value-ink`), else "Fails" (`text-destructive-ink`).
- `TokenSwatch({token, name, use, measure=true})`: row `grid items-center gap-4 p-4 sm:grid-cols-[5.5rem_minmax(0,13rem)_1fr] sm:gap-6`.
  - Swatch: `h-16 rounded-lg border border-input sm:h-14` with inline `background: var(token)`.
  - Middle: name `type-h4 text-foreground`; `TokenValue` `mt-1 block`; token literal `type-num-sm mt-1 text-action-ink`.
  - Right: use `type-small text-muted-foreground`; `ContrastBadge mt-2 block` when `measure` (off for pure fills: `--background`, `--card`, `--muted`, `--accent`).
- `TokenSwatchList({tokens})`: `divide-y divide-border overflow-hidden rounded-xl border border-border bg-card`.

---

## 4. Nav data source — `lib/el/nav.ts`

- Types: `Category {slug, title, blurb, contents[]}`, `Group {id: "foundations"|"base"|"agent"|"site", title, href, blurb, categories}`. `EL_ROOT = "/design-system"`.
- Foundations categories in order: **colors, typography, spacing, shadows, motion, icons** (drives sidebar order, home index cards, and PageFootNav prev/next: colors → typography → spacing → shadows…).
- Group hrefs: foundations → `/design-system`; base → `/design-system/components/base`; agent → `…/agent`; site → `…/site`. `categoryHref`: foundations pages live at `/design-system/{slug}`, others at `{group.href}/{slug}`.
- Helpers: `findCategory(groupId, slug)` (throws on unknown), `siblings(groupId, slug)` → `{prev, next}` as `{title, href}`.
- Category blurbs/contents used by pages: typography and spacing headers read `category.blurb` + `category.contents` from here; **colors page overrides** with its own inline `contents` (see drift #3).

---

## 5. `components/ui` primitives appearing on these pages

### `Icon` — `components/ui/icon.tsx` (the only sanctioned icon entry point)
- Props: `{icon: LucideIcon, size?: IconSize="md", tone?: IconTone="inherit", label?, className?}`.
- `ICON_SIZES`: xs 12, sm 14, md 16, lg 20, xl 24, 2xl 32, 3xl 40 (px, set as width/height attrs).
- Stroke width formula `48/px` clamped: >2.6→2.4, <1.5→1.6, else raw. Effective: xs/sm/md 2.4, lg 2.4, xl 2.0, 2xl 1.5, 3xl 1.6.
- `ICON_TONES`: default `text-foreground`, muted/subtle `text-muted-foreground`, action `text-action-ink`, value `text-value-ink`, success `text-success-ink`, warning `text-warning-ink`, info `text-info-ink`, error `text-destructive-ink`, inherit `text-current`.
- A11y: `label` → `role="img" aria-label`; no label → `aria-hidden="true"`. Always `shrink-0 focusable="false"`.

### `Button` — `components/ui/button.tsx` (docs chrome: mobile-nav trigger, sheet close)
- Base (cva): `group/button relative isolate inline-flex min-w-0 max-w-full shrink-0 items-center justify-center overflow-hidden rounded-pill border border-transparent bg-clip-padding font-medium whitespace-nowrap outline-none select-none btn-spring active:not-aria-[haspopup]:scale-95 focus-visible:border-ring focus-visible:ring-3 focus-visible:ring-ring/50 disabled:pointer-events-none disabled:opacity-45 aria-invalid:border-destructive aria-invalid:ring-3 aria-invalid:ring-destructive/20 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4`.
- Variants: **default** `action-feedback bg-primary text-primary-foreground shadow-btn-primary active:shadow-btn-down`; **premium** `premium-surface font-semibold text-value-foreground shadow-btn-value hover:shadow-glow-value active:shadow-btn-down`; **secondary** `bg-secondary text-secondary-foreground hover:bg-accent aria-expanded:bg-accent`; **outline** `border-input bg-card text-foreground shadow-btn hover:bg-muted active:shadow-btn-down aria-expanded:bg-muted`; **ghost** `text-muted-foreground hover:bg-secondary hover:text-foreground active:bg-muted aria-expanded:bg-secondary aria-expanded:text-foreground`; **destructive** (tint, not solid) `border-destructive/25 bg-destructive/10 text-destructive-ink hover:border-destructive/40 hover:bg-destructive/20 focus-visible:border-destructive/50 focus-visible:ring-destructive/25`; **link** `text-action-ink underline-offset-4 hover:underline`.
- Sizes: xs `h-6 gap-1 px-2.5 text-xs` (svg size-3); sm `h-8 gap-1.5 px-3.5 text-small` (svg 3.5); default `h-10 gap-2 px-4 text-sm`; lg `h-12 gap-2.5 px-6 text-body`; xl `h-14 gap-2.5 px-8 text-base` (svg size-5); icon-xs `size-6`; icon-sm `size-8`; icon `size-10`; icon-lg `size-12`.
- Emphasis: none | caps `text-num-sm font-semibold tracking-cta uppercase` (`--tracking-cta: 0.09em`).
- `loading` swaps in `Spinner` (Loader2Icon + `anim-spin`, linear) and disables; `asChild` via Radix Slot; data attrs `data-slot/variant/size/loading`, `aria-busy`.
- Feel: `btn-spring` = transitions of transform/bg/border/color/box-shadow/opacity at `--duration-base` 250ms `--ease-spring` cubic-bezier(0.34,1.56,0.64,1); `:active` transition-duration `--duration-tick` 80ms. Plus `active:scale-95` (suppressed when `aria-haspopup`).

### `Sheet` — `components/ui/sheet.tsx` (mobile nav only)
- Overlay: `fixed inset-0 z-50 bg-background/15 supports-backdrop-filter:backdrop-blur-xs` + fade in/out.
- Content: `fixed z-50 flex flex-col gap-4 bg-popover bg-clip-padding text-sm text-popover-foreground shadow-lg transition ease-in-out`; side=left → `inset-y-0 left-0 h-full w-3/4 border-r sm:max-w-sm`, `data-open:animate-in fade-in-0 slide-in-from-left-10`, closed mirrors out. Docs override to `w-72 overflow-y-auto px-6`.
- Close button (default on): `Button variant="ghost" size="icon-sm"` at `absolute top-3 right-3` with XIcon + sr-only "Close".
- SheetHeader: `flex flex-col gap-0.5 border-b bg-muted/50 p-4` (+ `pr-12` when close button); SheetTitle `font-heading text-base font-medium text-foreground`.

---

## 6. Page-local helper

### `Spec({cls, use, children})` — defined inside `typography/page.tsx` only
- Row: `grid gap-4 border-b border-border px-6 py-7 last:border-b-0 lg:grid-cols-[15rem_1fr] lg:gap-8`.
- Left: class name `type-code text-action-ink` rendered as `.{cls}`; use `type-small mt-2 text-muted-foreground`. Right: `min-w-0 self-center` live sample. Rows are stacked inside `overflow-hidden rounded-xl border border-border bg-card`.

---

## 7. Token/utility values these components depend on (from `app/globals.css`)

**Type classes** (all in `@layer components`; word classes default `--font-sans`):
| class | size | lh | weight | tracking | colour |
|---|---|---|---|---|---|
| type-display | clamp(2.75rem,4.4vw,4rem), font `--font-heading` | 1 | 500 | −0.03em | — |
| type-h1 | clamp(2rem,2.8vw,2.5rem) | 1.1 | 700 | −0.02em | — |
| type-h2 | 1.75rem | 1.2 | 650 | −0.015em | — |
| type-h3 | 1.3125rem | 1.3 | 600 | −0.01em | — |
| type-h4 | 1.0625rem | 1.4 | 600 | — | — |
| type-lead | 1.0625rem | 1.65 | 400 | — | muted-foreground |
| type-body | 0.9375rem (15px) | 1.6 | 400 | — | — |
| type-small | 0.8125rem (13px) | 1.5 | 400 | — | muted-foreground |
| type-nav | 0.84375rem (13.5px) | 1.2 | 500 | — | — |
| type-chip | 0.71875rem (11.5px) | 1.2 | 500 | — | — |
| type-caption | 0.65625rem (10.5px) | 1.35 | 500 | — | — |
| type-code | mono 0.78125rem (12.5px) | 1.4 | — | — | — |
| type-label | 0.6875rem (11px) | 1 | 600 | 0.16em, uppercase | muted-foreground |
| type-micro | 0.65625rem (10.5px) | 1 | 600 | 0.18em, uppercase | muted-foreground |
| type-section | 0.8125rem | 1.4 | 600 | — | muted-foreground |
| type-wordmark | 0.9375rem | 1 | 700 | −0.01em | — |
| type-num-* (all) | mono, tabular-nums | — | 600 | −0.01em | — |
| type-num-sm | 0.75rem (12px) | 1.2 | | | |
| type-num | 0.9375rem | 1.2 | | | |
| type-num-md | 1.25rem | 1.15 | | | |
| type-num-lg | 1.75rem | 1.05 | | | |
| type-num-xl | 2.5rem | 1, −0.025em | | | |

**Motion**: `--duration-tick` 80ms, `-fast` 150ms, `-base` 250ms, `-slow` 400ms, `-overlay` 320ms, `-jelly` 420ms, `-reward` 550ms. `--ease-spring` cubic-bezier(0.34,1.56,0.64,1); `--ease-out` (0.22,1,0.36,1); `--ease-standard` (0.4,0,0.2,1); `--ease-settle` (0.16,1,0.3,1); `--ease-in-out` (0.65,0,0.35,1). Default transition = 250ms/ease-out.
- `lift`: transitions transform + box-shadow (base/ease-out) and border-color (base/ease-standard); `:hover` → `translateY(-3px)` + `--shadow-e3`.
- `press`: transform base/ease-spring; `:active` scale(0.94) at 40ms (instant in, 250ms spring back).

**Shadows** (geometry fixed, ink themed): `--shadow-e1: 0 1px 1px var(--ink-2), 0 1px 3px var(--ink-1)`; `e2: 0 1px 2px ink-2, 0 4px 10px -2px ink-2`; `e3: 0 2px 4px ink-2, 0 14px 28px -8px ink-3`; `e4: 0 4px 8px ink-3, 0 28px 56px -14px ink-4`. Light ink: `hsl(240 20% 20% / .04/.07/.11/.16)`; dark ink: `rgb(0 0 0 / .35/.5/.6/.75)`. `--shadow-chip: inset 0 1px 0 var(--rim), inset 0 -1px 2px ink-2, 0 1px 2px ink-2`. Glows: `--shadow-glow-action: 0 0 0 1px color-mix(in oklab, var(--color-action-bright) 45%, transparent), 0 10px 34px -8px color-mix(in oklab, var(--color-action) 60%, transparent)`; `glow-value` same shape at 45%/42% of `--color-value`.

**Radii**: xs 2, sm 6, md 10, lg 12, xl 16, 2xl 20, 3xl 24, 4xl 32, pill 999 (px). **Widths**: shell 1680, content 1080, page **1200**, prose 720, rail 15rem. **scrollbar-thin**: `scrollbar-width: thin; scrollbar-color: var(--border) transparent`; webkit 8px, thumb `var(--border)` radius 999, hover `var(--muted-foreground)`.

**Fonts**: `--font-sans` / `--font-heading` = `"Inter Local"` (`/fonts/inter-variable.woff2`, wght 100–900, swap); `--font-mono` = Geist Mono (next/font variable).

---

## 8. Usage matrix

| Component | home | colors | typography | spacing |
|---|---|---|---|---|
| PageHeader | ✓ (no contents) | ✓ (inline contents) | ✓ (nav contents) | ✓ (nav contents) |
| Section | ✓ ×3 | ✓ ×5 | ✓ ×6 | ✓ ×6 |
| Panel | — | ✓ ×2 | ✓ ×5 | ✓ ×4 |
| Note | ✓ (value) | ✓ ×4 (action×2, value×2) | ✓ ×2 (action, error) | ✓ ×3 (error×1, default action ×2) |
| Meta | — | — | ✓ ×1 (6 items) | ✓ ×2 (8+5 items) |
| Code | — | ✓ | ✓ | ✓ |
| DoDont | — | — | ✓ | ✓ |
| IndexGrid/IndexCard | ✓ | — | — | — |
| PageFootNav | — | ✓ | ✓ | ✓ |
| TokenSwatchList family | — | ✓ ×4 | — | — |
| Row / StateGrid / StateCell | — | — | — | — |
| Icon | ✓ (ArrowRight) | via kit | via kit | via kit |
| Button / Sheet / ThemeToggle / Logo / SlidingIndicator | via layout chrome on all four |

Section order + verbatim ids/titles: **home** `#foundations` "Foundations" → `#components` "Components" (page-local group cards: `lift group … rounded-xl … p-7 hover:border-action/45`, "N sets" in `type-label text-action-ink`, `type-h3` title, ArrowRight at `size-5`, chips `mt-5 … pt-5`) → `#rules` "The rules that outrank taste" (page-local `<ol class="divide-y divide-border overflow-hidden rounded-xl border border-border bg-card">`, rows `flex gap-5 px-6 py-5`, numbers `01`–`06` in `type-num-sm text-action-ink`, six verbatim rules: "Two complete themes." / "Blue acts, lime values." / "Glow is rationed." / "Two faces only." / "Rarity is never color alone." / "Nothing unskippable.") → Note (value) "Scope of this phase". **colors** Note "Measured, not asserted" → `#monochrome` "Monochrome — zinc" → `#action` "Action — the thing that acts" → `#value` "Value — the thing that is worth something" → `#state` "State" → `#beyond` "What is deliberately not a colour token" → foot nav (prev none, next Typography). **typography** `#rule` "Two foundation faces" → `#words` "Word scale" (10 Spec rows) → `#numbers` "Numeric scale" (5 Spec rows + "Why tabular matters" panel, note `font-variant-numeric: tabular-nums`) → `#pairing` "Pairing the foundations" → `#prose` "Prose" (panel note `max-w-(--width-prose) · 720px`) → `#rules` "Rules" → foot nav (Colors ↔ Spacing & Layout). **spacing** `#scale` "Spacing scale" (10 rows, bar width = px value, `h-3 rounded-sm bg-action`) → `#radius` "Radius ladder" (7 steps) → `#elevation` "Elevation" (e1–e4 + rationed glow, note "Selected · rare · premium only") → `#grid` "Grid and content width" → `#breakpoints` "Breakpoints" → `#rules` "Rules" → foot nav (Typography ↔ Shadows).

---

## 9. Internal drift (both sides, verbatim)

1. **`--width-page`**: `globals.css:244` says `1200px`; spacing page Meta says "`--width-page` — 1320px. The cap for customer-facing pages". The CSS comment itself acknowledges the page "has documented this number as prose … ('Product pages cap at 1320px')" — token wins per project decision, but the rendered docs page prints 1320.
2. **Fonts**: every piece of copy (home rule 4, typography page, nav.ts blurb "Space Grotesk for every word") names **Space Grotesk**; the tokens load `"Inter Local"` → `/fonts/inter-variable.woff2` for both `--font-sans` and `--font-heading`. The nav.ts comment "『--font-sans` is Space Grotesk and has been for some time" is itself stale. Mono side matches (Geist Mono). (Matches the existing port decision: fonts follow tokens, not prose.)
3. **Colors header chips**: page passes inline `["Monochrome","Action ramp","Value ramp","State","What is not a token"]`, while `nav.ts` colors.contents (shown on the home IndexCard) is `["Surfaces","Action ramp","Value ramp","Text","Borders","Semantic","What is not a token","70 / 20 / 10 balance"]` — the two chip lists differ on the same category.
4. **Radius ladder page vs tokens**: page shows 7 steps (sm 6 → 3xl 24 + pill); tokens also define `--radius-xs: 2px` and `--radius-4xl: 32px`, undocumented there.
5. **type-display weight**: typography DoDont says "heavy Space Grotesk at tight tracking already carries the hero" while `.type-display` is weight **500** (medium) at −0.03em.
6. **Spacing Meta "Page margin px-6 md:px-8 lg:px-12"** describes customer pages; the docs shell itself uses `px-6 … lg:px-12` with no `md:px-8` step.

Key files: `D:\DESIGN\Design-System-2026-8\design-system\components\el\kit.tsx`, `…\components\el\token-swatch.tsx`, `…\components\el\el-nav.tsx`, `…\components\el\theme-toggle.tsx`, `…\components\el\logo.tsx`, `…\components\el\theme-provider.tsx`, `…\components\ui\icon.tsx`, `…\components\ui\button.tsx`, `…\components\ui\sheet.tsx`, `…\components\ui\sliding-indicator.tsx`, `…\components\ui\spinner.tsx`, `…\lib\el\nav.ts`, `…\app\design-system\layout.tsx`, `…\app\layout.tsx`, `…\app\globals.css`.