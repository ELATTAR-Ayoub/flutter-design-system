# globals.css — Complete Map for Flutter Port
Source: `D:/DESIGN/Design-System-2026-8/design-system/app/globals.css` (3693 lines, read in full). Supporting: `postcss.config.mjs`, `package.json`, `tsconfig.json`, `app/layout.tsx`, `components/el/theme-provider.tsx`, `public/fonts/`.

## 0. File preamble (L1–45)
- L1 `@import "tailwindcss"` (Tailwind v4, CSS-first config — there is NO tailwind.config file; all config lives in this CSS via `@theme`).
- L2–3 `@source not "../public/interfere-clone.html"` / `"../public/interfere-clone-dark.html"`; L43 `@source not "../**/*.md"` (build-time class-scanning exclusions only; no render effect).
- L4 `@import "tw-animate-css"` — supplies the `animate-in`/`animate-out` enter/exit keyframes used by overlays (dialog/popover/select/sheet/tooltip).
- L5 `@import "shadcn/tailwind.css"`.
- L45 `@custom-variant dark (&:is(.dark *))` — Tailwind `dark:` variant = descendant of `.dark`.
- `postcss.config.mjs`: only plugin `@tailwindcss/postcss`. `tsconfig.json`: nothing style-affecting beyond `@/*` path alias. Styling-relevant deps: `tailwindcss ^4`, `@tailwindcss/postcss ^4`, `tw-animate-css ^1.4.0`, `shadcn ^4.16.0`, `@shadcn/react ^0.3.0`, `geist ^1.7.2` (Geist Mono via next/font), `next-themes ^0.4.6`, `sonner ^2.0.7` (toast markup this file restyles), `class-variance-authority`, `tailwind-merge`, `radix-ui`, `three`/`@react-three/*` (voice orb reads `--orb-from/--orb-to` via getComputedStyle).

## 1. Fonts (@font-face + variables)
- L7–13 `@font-face` **"Inter Local"** — `src: url("/fonts/inter-variable.woff2") format("woff2")`, `font-style: normal`, `font-weight: 100 900` (variable), `font-display: swap`. File exists: `public/fonts/inter-variable.woff2`.
- L15–21 `@font-face` **"Redaction 35"** — `src: url("/fonts/redaction-35-italic.woff2")`, `font-style: italic`, `font-weight: 400`, `font-display: swap`.
- Font tokens (L169–172):
  - `--font-sans: "Inter Local", ui-sans-serif, system-ui, sans-serif`
  - `--font-mono: var(--font-geist-mono), ui-monospace, monospace` — `--font-geist-mono` is injected by next/font: `layout.tsx` L2/L34 `GeistMono.variable` on `<html>` (package `geist`).
  - `--font-heading: "Inter Local", ui-sans-serif, system-ui, sans-serif`
  - `--font-accent: "Redaction 35", ui-serif, Georgia, serif`
- **DRIFT (report both sides):** comment L167–168 says *"Space Grotesk owns words. Geist Mono owns numerical values, serials and code."* — but the tokens set sans/heading to **Inter Local**, not Space Grotesk. Tokens are what renders (this matches the project's recorded decision: fonts follow tokens, not prose). The Geist-Mono half of the comment is true.
- Weights: `--font-weight-normal: 400; --font-weight-medium: 500; --font-weight-semibold: 600` (L177–179). Note `.type-h2` uses weight **650** (variable-font axis value, L1081).
- Geist Mono has no true italic; `.type-accent` italic on the mono face would be synthesized — but `.type-accent` actually uses Redaction 35 which IS an italic file (comment L1043–1045 describes the mono-italic plan; the token points at Redaction 35 — another prose-vs-token drift; the token wins).

## 2. Theme switching mechanism
- **Class-based**, via next-themes: `ThemeProvider` (`components/el/theme-provider.tsx`) → `<NextThemes attribute="class" defaultTheme="dark" enableSystem disableTransitionOnChange>`. Class is written on `<html>` pre-hydration (inline script; `suppressHydrationWarning` on `<html>`).
- Theme blocks: **`:root, .light`** = light (L546–735); **`.dark`** = dark (L741–942). Default presented theme is **dark**; `enableSystem` means OS preference honored. `.light` exists so a light island inside a dark page resolves correctly (subtree theming for side-by-side specimens).
- `html { color-scheme: light }` / `html.dark { color-scheme: dark }` (L950–968) — UA-painted controls/scrollbars/caret follow.
- Third scoped theme: **`.theme-reference`** (L3520–3553) with dark twin **`.dark .theme-reference, .theme-reference.dark`** (L3555–3576) — a page-scoped repaint in a reference site's sampled values, NOT reachable from `:root`.
- So: 2 product themes (light, dark) + 1 scoped overlay theme (`theme-reference`, itself light/dark aware).

## 3. Token inventory (exact values + line ranges)

### 3a. Brand ramps — `@theme static` (L71–433)
Stock scale deletions L77–79: `--color-blue-*: initial; --color-lime-*: initial; --color-purple-*: initial`.

| Token | Value | Line |
|---|---|---|
| `--color-action-bright` | `hsl(213 94% 78%)` /* rasterizes #92C2FC */ | 103 |
| `--color-action` | `hsl(217 91% 53%)` /* #1A6EF4 */ | 104 |
| `--color-action-dark` | `hsl(224 76% 33%)` /* #143694 */ | 105 |
| `--color-value-bright` | `#d9f99d` | 107 |
| `--color-value` | `#a3e635` | 108 |
| `--color-value-dark` | `#4d7c0f` | 109 |
| `--color-value-foreground` | `hsl(240 10% 8%)` (does NOT flip with theme) | 127 |

**DRIFT:** L99–102 records that these were long annotated `#93C5FD / #2563EB / #1D4ED8` (Tailwind blue 300/600/700) but the hsl values never rasterized to those; actual = `#92C2FC / #1A6EF4 / #143694`. hsl values are authoritative.

State (L148–165): `--color-success: #10b981` (emerald 500), `--color-warning: #fbbf24` (amber 400), `--color-info: #22d3ee` (cyan 400), `--color-success-deep: #047857`, `--color-warning-deep: #b45309`, `--color-info-deep: #0e7490`, `--color-destructive-lifted: #f87171` (red 400), `--color-destructive-deep: hsl(0 72.2% 46%)`.

### 3b. Typography tokens (L169–216)
Tracking (L181–188): `--tracking-display: -0.03em`, `-tight: -0.02em`, `-num: -0.01em`, `-cta: 0.09em`, `-tag: 0.12em`, `-badge: 0.14em`, `-label: 0.16em`, `-micro: 0.18em`.
Sizes (L194–203): `--text-tag: 0.625rem` (10), `--text-micro: 0.65625rem` (10.5), `--text-label: 0.6875rem` (11), `--text-chip: 0.71875rem` (11.5), `--text-num-sm: 0.75rem` (12), `--text-code: 0.78125rem` (12.5), `--text-small: 0.8125rem` (13), `--text-nav: 0.84375rem` (13.5), `--text-body: 0.9375rem` (15), `--text-h4: 1.0625rem` (17).
Tailwind-scale realiasing (L212–215): `--text-xs: var(--text-num-sm)` (12), `--text-sm: var(--text-small)` (13), `--text-base: var(--text-body)` (15), `--text-lg: var(--text-h4)` (17) — vendored shadcn `text-sm`/`text-xs` land on THIS scale.

### 3c. Widths / heights / layout (L228–322)
`--width-shell: 1680px` (228), `--width-content: 1080px` (229), `--width-page: 1200px` (244), `--width-prose: 720px` (245), `--width-rail: 15rem` (251), `--height-cta: 60vh` (259), `--width-showcase: 1440px` (274), `--height-showcase: 40rem` (275), `--height-showcase-lg: 50rem` (276), `--blur-showcase: 20px` (284), `--height-site-header: 4rem` (290), `--scroll-offset: calc(var(--height-site-header) + var(--spacing) * 8)` = 96px (296), `--width-console-min: 60vw` (305), `--width-console: 80rem` (306), `--width-sidebar: 16rem` (320), `--width-sidebar-mobile: 18rem` (321), `--width-sidebar-icon: 3rem` (322). Note: `--spacing` itself is Tailwind v4's default `0.25rem` (4px) — never redefined here; every gap in this file is `calc(var(--spacing) * n)`.

### 3d. Radii (L324–339)
`--radius-xs: 2px`, `-sm: 6px`, `-md: 10px`, `-lg: 12px`, `-xl: 16px`, `-2xl: 20px`, `-3xl: 24px`, `-4xl: 32px`, `-pill: 999px`. Per-theme `--radius: 10px` (L605 light, L814 dark); `.theme-reference --radius: 8px` (L3542).

### 3e. Shadows (geometry L354–387; ink per theme)
- `--shadow-e1: 0 1px 1px var(--ink-2), 0 1px 3px var(--ink-1)`
- `--shadow-e2: 0 1px 2px var(--ink-2), 0 4px 10px -2px var(--ink-2)`
- `--shadow-e3: 0 2px 4px var(--ink-2), 0 14px 28px -8px var(--ink-3)`
- `--shadow-e4: 0 4px 8px var(--ink-3), 0 28px 56px -14px var(--ink-4)`
- `--shadow-key: 0 4px 0 var(--wall), 0 7px 12px var(--ink-3)`
- `--shadow-key-down: 0 1px 0 var(--wall), inset 0 2px 5px var(--ink-3)`
- `--shadow-pressed: inset 0 2px 5px var(--ink-3), inset 0 1px 2px var(--ink-4)`
- `--shadow-btn: inset 0 1px 0 var(--rim), inset 0 -2px 4px var(--ink-2), 0 1px 2px var(--ink-2), 0 3px 8px -2px var(--ink-2)`
- `--shadow-btn-primary: inset 0 1px 0 var(--rim-strong), inset 0 -2px 5px var(--ink-2), 0 1px 2px var(--ink-2), 0 4px 10px -2px color-mix(in oklab, var(--color-action) 55%, transparent)`
- `--shadow-btn-value: inset 0 1px 0 var(--rim-strong), inset 0 -2px 5px var(--ink-1), 0 1px 2px var(--ink-2), 0 4px 10px -2px color-mix(in oklab, var(--color-value) 45%, transparent)`
- `--shadow-btn-down: inset 0 2px 4px var(--ink-3), 0 1px 1px var(--ink-1)`
- `--shadow-chip: inset 0 1px 0 var(--rim), inset 0 -1px 2px var(--ink-2), 0 1px 2px var(--ink-2)`
- `--shadow-glow-action: 0 0 0 1px color-mix(in oklab, var(--color-action-bright) 45%, transparent), 0 10px 34px -8px color-mix(in oklab, var(--color-action) 60%, transparent)`
- `--shadow-glow-value: 0 0 0 1px color-mix(in oklab, var(--color-value) 45%, transparent), 0 10px 34px -8px color-mix(in oklab, var(--color-value) 42%, transparent)`

Shadow ink — LIGHT (L610–616): `--ink-1: hsl(240 20% 20% / 0.04)`, `--ink-2: /0.07`, `--ink-3: /0.11`, `--ink-4: /0.16`, `--rim: hsl(0 0% 100% / 0.85)`, `--rim-strong: hsl(0 0% 100% / 0.4)`, `--wall: hsl(240 6% 82%)`.
DARK (L820–826): `--ink-1: rgb(0 0 0 / 0.35)`, `--ink-2: /0.5`, `--ink-3: /0.6`, `--ink-4: /0.75`, `--rim: rgb(255 255 255 / 0.14)`, `--rim-strong: rgb(255 255 255 / 0.28)`, `--wall: hsl(240 6% 8%)`.

### 3f. Motion (L395–432)
`--default-transition-duration: 250ms`; `--default-transition-timing-function: var(--ease-out)`.
Durations: `--duration-tick: 80ms`, `-fast: 150ms`, `-base: 250ms`, `-slow: 400ms`, `-overlay: 320ms`, `-jelly: 420ms`, `-reward: 550ms`, `-bloom: 1000ms`, `-sway: 44s`, `-sway-alt: 33s`.
Easings: `--ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1)`; `--ease-out: cubic-bezier(0.22, 1, 0.36, 1)`; `--ease-in: cubic-bezier(0.7, 0, 0.84, 0)` (deliberately NOT Tailwind's 0.4,0,1,1); `--ease-in-out: cubic-bezier(0.65, 0, 0.35, 1)`; `--ease-out-flex: cubic-bezier(0.05, 0.6, 0.4, 0.9)`; `--ease-settle: cubic-bezier(0.16, 1, 0.3, 1)`; `--ease-standard: cubic-bezier(0.4, 0, 0.2, 1)`.

### 3g. Semantic mapping — `@theme inline` (L440–509)
All `--color-X: var(--X)` for: background, foreground, card(+fg), popover(+fg), primary(+fg), secondary(+fg), muted(+fg), accent(+fg), destructive(+fg), border, input, ring, chart-1..5, sidebar(+fg,+primary,+primary-fg,+accent,+accent-fg,+border,+ring), agent, agent-muted, scrim, action-ink, value-ink, success-ink, warning-ink, info-ink, destructive-ink, bubble-tinted, bubble-tinted-hover.

### 3h. LIGHT theme block `:root, .light` (L546–735)
```
--background: hsl(0 0% 100%)          --foreground: hsl(240 10% 3.9%)
--card: hsl(0 0% 100%)                --card-foreground: hsl(240 10% 3.9%)
--popover: hsl(0 0% 100%)             --popover-foreground: hsl(240 10% 3.9%)
--secondary: hsl(240 4.8% 95.9%)      --secondary-foreground: hsl(240 5.9% 10%)
--muted: hsl(240 4.8% 95.9%)          --muted-foreground: hsl(240 4% 40%)   /* NOT zinc 500; deeper */
--accent: hsl(240 4.8% 95.9%)         --accent-foreground: hsl(240 5.9% 10%)
--border: hsl(240 5.9% 90%)           --input: hsl(240 5.9% 90%)
--page-glow: hsl(240 30% 98%)
--primary: var(--color-action)        --primary-foreground: hsl(0 0% 100%)
--ring: var(--color-action)
--action-ink: var(--color-action-dark)     --value-ink: var(--color-value-dark)
--success-ink: var(--color-success-deep)   --warning-ink: var(--color-warning-deep)
--info-ink: var(--color-info-deep)         --destructive-ink: var(--color-destructive-deep)
--destructive: hsl(0 72.2% 50.6%)     --destructive-foreground: hsl(0 0% 98%)
--bubble-tinted: oklch(from var(--primary) 0.93 calc(c * 0.4) h)
--bubble-tinted-hover: oklch(from var(--primary) 0.88 calc(c * 0.5) h)
--radius: 10px
--chart-1: var(--color-action)  --chart-2: var(--color-value-dark)  --chart-3: var(--color-info-deep)
--chart-4: var(--color-action-dark)  --chart-5: var(--color-success-deep)
--sidebar: var(--card)  --sidebar-foreground: var(--muted-foreground)  --sidebar-primary: var(--primary)
--sidebar-primary-foreground: var(--primary-foreground)  --sidebar-accent: var(--accent)
--sidebar-accent-foreground: var(--accent-foreground)  --sidebar-border: var(--border)  --sidebar-ring: var(--ring)
--agent: var(--color-action)          --agent-muted: hsl(213 100% 97%)
--scrim: hsl(240 10% 3.9% / 0.28)
--bloom-void: white   --bloom-l: 0.6   --bloom-c: 1.55   --bloom-lift: 0   --bloom-hot-c: 1
--star-glow: color-mix(in oklab, var(--bloom-2) 85%, transparent)   --star-glow-size: 3px
--agent-cube-top: hsl(240 20% 99%)   --agent-cube-left: hsl(240 15% 94%)   --agent-cube-right: hsl(240 14% 90%)
--agent-cube-stroke: hsl(240 10% 79%)   --agent-cube-accent: var(--color-action)
--agent-cube-error-top: hsl(0 70% 88%)  --agent-cube-error-left: hsl(0 65% 82%)
--agent-cube-error-right: hsl(0 60% 75%) --agent-cube-error-stroke: hsl(0 55% 69%)
--agent-cube-back: hsl(240 14% 86%)  --agent-cube-ghost-ink: hsl(240 5% 54%)
--agent-cube-accent-shade: hsl(217 45% 72%)
--orb-from: var(--color-action)      --orb-to: var(--color-action-dark)
```

### 3i. DARK theme block `.dark` (L741–942)
```
--background: hsl(240 10% 3.9%)  /* zinc 950 */   --foreground: hsl(0 0% 98%)
--card: hsl(240 5.9% 10%)  /* zinc 900 */         --card-foreground: hsl(0 0% 98%)
--popover: hsl(240 5.9% 10%)                      --popover-foreground: hsl(0 0% 98%)
--secondary: hsl(240 3.7% 15.9%)  /* zinc 800 */  --secondary-foreground: hsl(0 0% 98%)
--muted: hsl(240 3.7% 15.9%)                      --muted-foreground: hsl(240 4.9% 83.9%) /* zinc 300 */
--accent: hsl(240 5.3% 26.1%)  /* zinc 700 */     --accent-foreground: hsl(0 0% 98%)
--border: hsl(240 3.7% 15.9%)                     --input: hsl(240 5.3% 26.1%)
--page-glow: hsl(240 8% 10%)
--primary: var(--color-action)                    --primary-foreground: hsl(0 0% 100%) /* pure white, 4.58:1 */
--ring: var(--color-action-bright)
--action-ink: var(--color-action-bright)          --value-ink: var(--color-value-bright)
--success-ink: var(--color-success)  --warning-ink: var(--color-warning)  --info-ink: var(--color-info)
--destructive-ink: var(--color-destructive-lifted)
--destructive: hsl(0 72.2% 50.6%)                 --destructive-foreground: hsl(0 0% 98%)
--bubble-tinted: oklch(from var(--primary) 0.3 calc(c * 0.4) h)
--bubble-tinted-hover: oklch(from var(--primary) 0.35 calc(c * 0.5) h)
--radius: 10px
--chart-1: var(--color-action-bright)  --chart-2: var(--color-value)  --chart-3: var(--color-info)
--chart-4: var(--color-value-bright)   --chart-5: var(--color-success)
--sidebar*: identical 8 aliases as light (repeated verbatim on purpose, for subtree theming)
--agent: var(--color-action-bright)
--bloom-void: black   --bloom-l: 1   --bloom-c: 1   --bloom-lift: 0.85   --bloom-hot-c: 0.5
--star-glow: rgb(255 255 255 / 0.5)   --star-glow-size: 2px
--agent-muted: hsl(217 40% 13%)       --scrim: hsl(240 10% 3.9% / 0.66)
--agent-cube-top: hsl(240 5% 21%)   --agent-cube-left: hsl(240 5% 17%)   --agent-cube-right: hsl(240 5% 14%)
--agent-cube-stroke: hsl(240 5% 31%)  --agent-cube-accent: var(--color-action-bright)
--agent-cube-error-top: hsl(0 60% 46%)  --agent-cube-error-left: hsl(0 62% 39%)
--agent-cube-error-right: hsl(0 63% 33%)  --agent-cube-error-stroke: hsl(0 68% 58%)
--agent-cube-back: hsl(240 6% 10%)   --agent-cube-ghost-ink: hsl(240 5% 45%)
--agent-cube-accent-shade: hsl(217 40% 32%)
--orb-from: var(--color-action-bright)   --orb-to: var(--color-action)
```
**DRIFT (documented in-file):** dark `--value-ink` points at `-bright` while the system's own §1.3 table would say the mid; the file explicitly keeps `-bright` (L784–798). Chart ordering also intentionally diverges from "run down each ramp" (L828–846).

### 3j. `.theme-reference` scoped tokens (L3520–3576)
Light: `--background:#fff; --card:#fcfcfc; --popover:#fcfcfc; --foreground:#000000df; --card-foreground:#000000df; --popover-foreground:#000000df; --muted-foreground:#0000009b; --border:#0000000f; --input:#0000000f; --muted:#0000000f; --secondary:#0000000f; --accent:#00000017; --secondary-foreground:#000000df; --accent-foreground:#000000df; --primary:#000000df; --primary-foreground:#fff; --ring:#000000df; --radius:8px; --width-reference:1200px; --gutter-reference:calc(var(--spacing)*5.5)` (=22px); `--surface-showcase:#ebebebb3; --rim-showcase:transparent; --duration-intro:800ms; --ease-intro:cubic-bezier(0.25,0.1,0.25,1)`.
Dark: `--background: oklch(15% 0 0); --card:#111; --popover:#111; --foreground:#ffffffed; (card/popover-fg same); --muted-foreground:#ffffffaf; --border:#ffffff3b; --input:#ffffff3b; --muted:#ffffff12; --secondary:#ffffff12; --accent:#ffffff1b; --secondary/accent-foreground:#ffffffed; --primary:#ffffffed; --primary-foreground:#000; --ring:#ffffffed; --surface-showcase:#ffffff0d; --rim-showcase:#ffffff12`.

### 3k. Groups that do NOT exist
No z-index tokens (only literal `z-index: 0`/`1` inside `bloom-cosmic`). No blur scale beyond `--blur-showcase: 20px` (Tailwind defaults supply `backdrop-blur-xl` = 24px). No conic-gradient anywhere in the file.

## 4. @layer base (L944–1011)
- `* { @apply border-border outline-ring/50 }`.
- `html`: `font-sans`; `color-scheme: light`; `scroll-padding-block-start: var(--scroll-offset)`; `scroll-behavior: smooth`. `html.dark { color-scheme: dark }`.
- `body` (L984–994): `bg-background text-foreground` + **page glow**: `background-image: radial-gradient(120% 90% at 62% 34%, var(--page-glow) 0%, transparent 64%); background-attachment: fixed; background-repeat: no-repeat; -webkit-font-smoothing: antialiased`.
- `:focus-visible { outline: 2px solid var(--ring); outline-offset: 2px }`.
- `.tabular { font-variant-numeric: tabular-nums }`.
- `::selection { background: color-mix(in oklab, var(--color-action) 35%, transparent); color: var(--foreground) }`.

## 5. Typography classes (@layer components, L1018–1292)
Every class, full values (family defaults to inherited `--font-sans` unless stated):
- `.type-display`: `font-family: var(--font-heading); font-size: clamp(2.75rem, 4.4vw, 4rem); line-height:1; weight:500; letter-spacing: var(--tracking-display)`.
- `.type-accent`: `font-family: var(--font-accent); font-size:1.055em; font-style:italic; weight:400; letter-spacing: var(--tracking-display)`.
- `.type-h1, :where(.prose) h1`: `clamp(2rem, 2.8vw, 2.5rem)/1.1; 700; -0.02em`.
- `.type-h2, :where(.prose) h2`: `1.75rem/1.2; 650; -0.015em`.
- `.type-h3, :where(.prose) h3`: `1.3125rem/1.3; 600; -0.01em`.
- `.type-h4, :where(.prose) h4,h5,h6`: `1.0625rem/1.4; 600`.
- `.type-lead`: `1.0625rem/1.65; 400; color: var(--muted-foreground)`.
- `.type-body, :where(.prose) p,li,td,blockquote`: `var(--text-body)/1.6; 400`.
- `.type-small, :where(.prose) figcaption`: `var(--text-small)/1.5; 400; color: var(--muted-foreground)`.
- `.type-nav`: `var(--text-nav)/1.2; 500`. `.type-nav-sm`: `var(--text-chip)/1.2; 500`. `.type-chip`: `var(--text-chip)/1.2; 500`. `.type-caption`: `var(--text-micro)/1.35; 500`.
- `.type-code, :where(.prose) code, pre`: `font-family: var(--font-mono); var(--text-code)/1.4`.
- `.type-label, :where(.prose) th`: `var(--text-label)/1; 600; uppercase; var(--tracking-label); color: var(--muted-foreground)`.
- `.type-section`: `var(--text-small)/1.4; 600; color: var(--muted-foreground)`.
- `.type-wordmark`: `var(--text-body)/1; 700; var(--tracking-num)`.
- `.type-serial`: `mono; var(--text-body)/1.4; uppercase; var(--tracking-num)`.
- `.type-micro`: `var(--text-micro)/1; 600; uppercase; var(--tracking-micro); color: var(--muted-foreground)`.
- `.type-tag`: `var(--text-tag)/1; 600; uppercase; var(--tracking-tag)`.
- `.type-badge`: `var(--text-label)/1; 600; uppercase; var(--tracking-badge)`.
- Numerics (shared: `font-family: var(--font-mono); tabular-nums; 600; var(--tracking-num)`): `.type-num-xs` `var(--text-label)/1.2`; `.type-num-sm` `var(--text-num-sm)/1.2`; `.type-num` `var(--text-body)/1.2`; `.type-num-md` `1.25rem/1.15`; `.type-num-lg` `1.75rem/1.05`; `.type-num-xl` `2.5rem/1; letter-spacing:-0.025em`.

## 6. Prose (@layer components, L1322–1507)
`.prose { color: var(--foreground) }`. All child rules use `:where(.prose)` (specificity 0,0,1):
- Rhythm: p/ul/ol/blockquote/figure/pre/table `margin-block: 16px`; h1,h2 `margin-block: 40px 16px`; h3 `32px 12px`; h4–h6 `24px 8px`; hr `margin-block:40px; border:0; border-block-start:1px solid var(--border)`; `.prose > :first-child {margin-block-start:0}`, `> :last-child {margin-block-end:0}`.
- Headings h1–h4 `color: var(--foreground)`.
- Lists: ul disc / ol decimal, `padding-inline-start: 24px`; `li::marker color: var(--muted-foreground)`; `li + li margin-block-start: 8px`; nested `li > ul/ol margin-block: 8px`.
- Links: `color: var(--color-action-ink); underline 1px; text-underline-offset:2px; transition: text-decoration-color 150ms var(--ease-out)`; hover `text-decoration-color: transparent`. strong: 600/foreground. em: italic.
- Inline code (`:not(pre) > code`): `background: var(--card); border:1px solid var(--border); radius: var(--radius-sm); padding: 2px 6px; color: var(--muted-foreground)`. `pre`: `background: var(--card); border:1px solid var(--border); radius: var(--radius-lg); padding:16px; overflow-x:auto`; `pre code` reset.
- blockquote: `border-inline-start: 2px solid var(--input); padding-inline-start:16px; color: var(--muted-foreground); italic`.
- table: `display:block; width:max-content; max-width:100%; overflow-x:auto; border-collapse:collapse`; th/td `border-block-end:1px solid var(--border); padding:12px 16px; text-align:start; vertical-align:top`; th `background: var(--muted)`.
- img/video/iframe: `max-width:100%; height:auto; border-radius: var(--radius-lg)`; figure `margin-inline:0`; figcaption `margin-block-start:8px`.

## 7. Effect/motion utilities (all `@utility` unless noted)
- `glow-action` (L1519): `box-shadow: var(--shadow-glow-action)`. `glow-value` (L1522): `var(--shadow-glow-value)`.
- `ramp-chip` (L1531): `background-image: linear-gradient(to bottom, rgb(255 255 255/0.18) 0%, rgb(255 255 255/0.05) 48%, rgb(0 0 0/0.14) 100%)`.
- `glass-panel` (L1563): `@apply backdrop-blur-xl backdrop-saturate-150` (=blur 24px, saturate 1.5); `background-color: color-mix(in oklab, var(--card) 74%, transparent)`; `box-shadow: inset 0 1px 0 var(--rim-strong), inset 0 0 0 1px color-mix(in oklab, var(--foreground) 12%, transparent), var(--shadow-e2)`. No overflow:hidden.
- `glass-panel-deep` (L1601): identical but final layer `var(--shadow-e4)`.
- `glass-control` (L1612): no blur; `background-color: color-mix(in oklab, var(--foreground) 7%, transparent); box-shadow: inset 0 1px 0 var(--rim-strong), inset 0 0 0 1px color-mix(in oklab, var(--foreground) 16%, transparent)`.
- `bloom-action` (L1623): `radial-gradient(ellipse 70% 60% at 50% 30%, color-mix(in oklab, var(--color-action) 28%, transparent), transparent 70%)`. `bloom-value` (L1630): same geometry, `var(--color-value) 22%`.
- **`bloom-cosmic`** (L1663–1847), the flagship: defaults `--bloom-1: var(--color-action-bright); --bloom-2: var(--color-action)`. Geometry vars: `--bloom-deep-inset: -95% -4.5rem -95% auto; --bloom-deep-width: min(95%, 26rem); --bloom-near-inset: -80% -3.5rem -80% auto; --bloom-near-width: min(86%, 21rem)`. Derived hues: `--bloom-core: oklch(from var(--bloom-2) calc(l * var(--bloom-l)) calc(c * var(--bloom-c)) h)`; `--bloom-glow`: same from `--bloom-1`; `--bloom-hot: oklch(from var(--bloom-core) calc(l + (1 - l) * var(--bloom-lift)) calc(c * var(--bloom-hot-c)) h)`. Container: `overflow:hidden; isolation:isolate; & > * { z-index:1 }`.
  - `::before` (deep field): `inset: var(--bloom-deep-inset); width: var(--bloom-deep-width); height:auto; z-index:0; pointer-events:none; mix-blend-mode:screen; filter: blur(16px); opacity:0.75; transform-origin: 88% 82%`; background = two radial-gradients: `radial-gradient(48% 58% at 74% 86%, var(--bloom-core) 0%, color-mix(in oklab, var(--bloom-core) 45%, var(--bloom-void)) 54%, var(--bloom-void) 84%)`, `radial-gradient(44% 54% at 94% 40%, color-mix(in oklab, var(--bloom-glow) 60%, var(--bloom-core)) 0%, var(--bloom-void) 78%)`; `animation: cosmic-drift-deep 18s var(--ease-in-out) infinite alternate`.
  - `::after` (near field): `inset: var(--bloom-near-inset); width: var(--bloom-near-width); height:auto; z-index:0; pointer-events:none; mix-blend-mode:screen; filter: blur(10px); transform-origin: 90% 86%`; three radial-gradients: hot core `radial-gradient(42% 56% at 92% 84%, color-mix(in oklab, var(--bloom-glow) 35%, var(--bloom-hot)) 0%, var(--bloom-glow) 28%, color-mix(in oklab, var(--bloom-glow) 45%, var(--bloom-void)) 56%, var(--bloom-void) 82%)`; companion `radial-gradient(44% 52% at 64% 12%, color-mix(in oklab, var(--bloom-core) 60%, var(--bloom-hot)) 0%, var(--bloom-core) 34%, var(--bloom-void) 82%)`; bridge `radial-gradient(46% 58% at 84% 46%, color-mix(in oklab, var(--bloom-glow) 50%, var(--bloom-core)) 0%, color-mix(in oklab, var(--bloom-core) 50%, var(--bloom-void)) 52%, var(--bloom-void) 82%)`; **mask** `mask-image: radial-gradient(78% 108% at 96% 78%, black 0%, black 28%, transparent 84%)`; `animation: cosmic-drift-near 11s var(--ease-in-out) infinite alternate`.
  - Hover: both pseudos `scale: 1; transition: scale 1000ms var(--ease-out)` (standalone `scale` property composing with animated `transform`); `:hover::before { scale: 2.2 }`, `:hover::after { scale: 2.5 }`.
- `btn-spring` (L1886): `transition: transform, background-color, border-color, color, box-shadow, opacity — each 250ms var(--ease-spring)`; `:active { transition-duration: 80ms }`.
- **`foil-value`** (L1948): `position:relative`; base ramp `linear-gradient(176deg, color-mix(in oklab, var(--color-value-bright) 94%, white) 0%, var(--color-value-bright) 22%, var(--color-value) 44%, color-mix(in oklab, var(--color-value-dark) 42%, var(--color-value)) 52%, var(--color-value) 62%, var(--color-value-bright) 88%, color-mix(in oklab, var(--color-value-bright) 90%, white) 100%)`.
  - `::before` (glint): inset 0; radius inherit; `linear-gradient(104deg, transparent 38%, color-mix(in oklab, var(--color-value-bright) 45%, white) 46%, color-mix(… 15%, white) 50%, color-mix(… 45%, white) 54%, transparent 62%)`; `background-size: 260% 100%; no-repeat; background-position: 135% 50%; mix-blend-mode: screen; opacity:0; animation: value-glint 5.5s var(--ease-in-out) infinite`.
  - `::after` (foil): 3 layers: `repeating-linear-gradient(104deg, color-mix(in oklab, var(--color-value-bright) 80%, transparent) 0 1px, transparent 1px 5px)`; `linear-gradient(100deg, transparent 30%, color-mix(… 95%, white) 46%, color-mix(… 60%, transparent) 54%, transparent 70%)`; `radial-gradient(130% 170% at 22% -10%, color-mix(… 75%, white), transparent 62%)`; `background-size: 170% 100%, 210% 100%, 100% 100%; no-repeat; mix-blend-mode: soft-light; opacity: 0.95; animation: value-foil-drift 11s linear infinite`.
  - `:hover::before { animation-duration: 2.4s }`; `:hover::after { opacity: 1 }`.
- **`sheen-action`** (L2090): `position:relative`; ramp `linear-gradient(176deg, color-mix(in oklab, var(--color-action-bright) 20%, var(--color-action)) 0%, var(--color-action) 44%, color-mix(in oklab, var(--color-action-dark) 50%, var(--color-action)) 53%, var(--color-action) 76%, color-mix(in oklab, var(--color-action-bright) 10%, var(--color-action)) 100%)`.
  - `::before` (beat): `radial-gradient(ellipse 46% 130% at 50% 50%, color-mix(in oklab, var(--color-action-bright) 85%, transparent), color-mix(… 30%, transparent) 55%, transparent 72%); mix-blend-mode: screen; opacity:0; transform: scale(0.55)`. `:hover::before { animation: action-beat 2.6s var(--ease-out) infinite }`; `:active::before { animation: action-beat 620ms var(--ease-out) 1 }`.
  - `::after` (static texture): `repeating-linear-gradient(104deg, color-mix(in oklab, var(--color-action-bright) 34%, transparent) 0 1px, transparent 1px 7px)`, `linear-gradient(100deg, transparent 28%, color-mix(… 52%, transparent) 48%, transparent 68%)`, `radial-gradient(120% 150% at 24% -20%, color-mix(… 45%, transparent), transparent 60%)`; `background-size: 100% 100%, 190% 100%, 100% 100%; soft-light; opacity: 0.75`.
- tw-animate-css bridge (UNLAYERED, L2181–2185): `[class*="animate-in"], [class*="animate-out"] { --tw-duration: var(--duration-overlay); --tw-ease: var(--ease-out) }` — makes every overlay run 320ms/ease-out instead of 150ms/ease.
- `anim-check-draw` (L2243): `stroke-dasharray:22; animation: check-draw 280ms var(--ease-out) both`. `anim-dash-draw`: `stroke-dasharray:12; dash-draw 200ms ease-out both`. `anim-dot-pop`: `dot-pop 320ms var(--ease-spring) both`.
- `slide-pill` (L2256): `transition: transform/width/height 250ms var(--ease-spring), opacity 150ms var(--ease-out)`.
- `swap-roll` (L2265): `--swap-offset:0; transform: translateY(calc(var(--swap-offset) * 160%)); transition: transform/opacity 400ms var(--ease-spring)`.
- `press` (L2277): `transition: transform 250ms var(--ease-spring); :active { transform: scale(0.94); transition-duration: 40ms }`.
- `click-spring` (L2286): same, `scale(0.9)`.
- `press-spring` (L2296): `transition: transform 0.22s var(--ease-spring); :active scale(0.92), 40ms`.
- `press-key` (L2307): `box-shadow: var(--shadow-key); transition: transform/box-shadow 80ms linear; :active { transform: translateY(3px); box-shadow: var(--shadow-key-down) }`.
- `lift` (L2320): `transition: transform/box-shadow 250ms var(--ease-out), border-color 250ms var(--ease-standard); :hover { translateY(-3px); box-shadow: var(--shadow-e3) }`.
- `anim-fade-up`: `pulls-fade-up 400ms ease-out both`. `anim-reveal`: `pulls-reveal 550ms ease-out both`. `anim-shimmer`: `background: linear-gradient(90deg, var(--popover) 0%, var(--accent) 50%, var(--popover) 100%); background-size:200% 100%; pulls-shimmer 1.4s ease-in-out infinite`. `anim-pulse-live`: `pulls-pulse-live 2s ease-in-out infinite`.
- `anim-pop-in`: `yuki-pop-in 0.55s ease-out both`. `anim-jelly`: `yuki-jelly 0.6s ease-out both`. `anim-spring-up`: `yuki-spring-up 0.8s var(--ease-settle) both`. `anim-jelly-in`: `yuki-jelly-in 420ms var(--ease-spring) both`. `anim-jelly-out`: `yuki-jelly-out 250ms var(--ease-in-out) both`. `anim-unfold`: `yuki-unfold 420ms var(--ease-spring) both` (height from `--unfold-h`, needs overflow:hidden). `anim-fold`: `yuki-fold 250ms ease-in-out both`. `anim-spin`: `pulls-spin 0.9s linear infinite`. `anim-caret`: `pulls-caret 1s steps(1, end) infinite`. `anim-ratchet`: `yuki-ratchet 1.4s steps(8) infinite`. `anim-sign-on`: `yuki-sign-on 0.9s steps(1, end) both`.
- Agent set: `anim-panel-in`: `pulls-panel-in 320ms ease-out both`. `anim-fade-in`: `pulls-fade-in 320ms ease-out both`. `anim-row-in`: `pulls-row-in 250ms ease-out both; animation-delay: calc(80ms + var(--row-index, 0) * 80ms / 2)`. `anim-row-out`: `pulls-row-out 250ms ease-in-out both`. `anim-swap-in`: `pulls-swap-in 250ms var(--ease-spring) both`.
- Text entrance: `anim-split-in`: `yuki-split-in 250ms ease-spring both; delay calc(var(--split-index,0) * 20ms)`. `anim-blur-word-in`: `yuki-blur-in 400ms ease-out both; delay calc(var(--split-index,0) * 40ms)`.
- Landing intro: `anim-intro-rise`: `yuki-intro-rise 400ms ease-out both; delay calc(var(--intro-stage,0) * 80ms)`. `anim-intro-panel`: `yuki-intro-focus 400ms ease-out both; same delay`. `anim-intro-glow`: `pulls-fade-in 1000ms ease-out both; delay 200ms` (2.5 ticks).
- `aurora-brand` (L3042): `linear-gradient(90deg, color-mix(in oklab, var(--color-value) 20%, transparent) 0%, color-mix(in oklab, var(--color-action-bright) 20%, transparent) 38%, color-mix(in oklab, var(--color-action) 20%, transparent) 71%, color-mix(in oklab, var(--color-action-dark) 20%, transparent) 100%)`.
- `anim-shimmer-text` (L3056): `linear-gradient(100deg, var(--muted-foreground) 30%, var(--agent) 50%, var(--muted-foreground) 70%); background-size: 220% 100%; background-clip: text; color: transparent; pulls-shimmer 2.6s ease-in-out infinite`.
- History: `anim-confirm-in`: `pulls-confirm-in 150ms ease-out both`. `anim-confirm-out`: `pulls-confirm-out 80ms var(--ease-in) both`. `anim-blur-out`: `pulls-blur-out 150ms var(--ease-in) both`. `anim-blur-in`: `pulls-blur-in 250ms var(--ease-settle) both`.
- Scrollbars (@layer utilities, L2822–2860): `html, .scrollbar-thin, :where(.prose) table, :where(.prose) pre` → `scrollbar-width: thin; scrollbar-color: var(--border) transparent`; WebKit: 8px×8px, track transparent, thumb `var(--border)` radius 999px, thumb hover `var(--muted-foreground)`.

## 8. Every @keyframes (57 total, full frames)
- `cosmic-drift-deep` (L1864): 0% `translate3d(0,0,0) rotate(0) scale(1)`; 50% `translate3d(-11%,8%,0) rotate(7deg) scale(1.2)`; 100% `translate3d(6%,-9%,0) rotate(-5deg) scale(1.08)`.
- `cosmic-drift-near` (L1872): 0% `t3d(0,0,0) rotate(0) scale(1.04)`; 35% `t3d(-3%,-2%,0) rotate(-9deg) scale(1.18)`; 70% `t3d(3%,2%,0) rotate(6deg) scale(1)`; 100% `t3d(-2%,1%,0) rotate(-4deg) scale(1.14)`.
- `value-foil-drift` (L1915): 0% `background-position: 0% 50%, -60% 50%, 50% 50%`; 100% `140% 50%, 160% 50%, 50% 50%`.
- `value-glint` (L1930): 0%,54% `background-position:135% 50%; opacity:0`; 60% `opacity:1`; 94% `opacity:1`; 100% `background-position:-55% 50%; opacity:0`.
- `action-beat` (L2059): 0% `scale(0.55), op 0`; 10% `scale(1), op 0.62`; 24% `scale(1.32), op 0`; 30% `scale(0.7), op 0`; 40% `scale(1.06), op 0.34`; 54% `scale(1.38), op 0`; 100% `scale(1.38), op 0`.
- `el-sweep` (L2195): from `width:0` to `width:100%`. `el-travel` (L2203): from `translateX(0)` to `translateX(calc(100% - 1.5rem))`.
- `check-draw` (L2212): `stroke-dashoffset: 22 → 0`. `dash-draw` (L2220): `12 → 0`.
- `dot-pop` (L2228): 0% `scale(0), op 0`; 55% `scale(1.35), op 1`; 100% `scale(1), op 1`.
- `yuki-pop-in` (L2424): 0% `op 0, scale3d(0.25,0.25,1)`; 55% `op 1, scale3d(0.92,1.08,1)`; 80% `scale3d(1.04,0.97,1)`; 92% `scale3d(0.99,1.01,1)`; 100% `scale3d(1,1,1)`.
- `yuki-jelly` (L2431): 0% `1,1,1`; 30% `1.18,0.82,1`; 45% `0.88,1.12,1`; 60% `1.06,0.94,1`; 78% `0.98,1.02,1`; 100% `1,1,1`.
- `yuki-spring-up` (L2439): 0% `op 0, translateY(32px)`; 55% `op 1, -4px`; 76% `1.5px`; 90% `-0.5px`; 100% `0`.
- `yuki-jelly-in` (L2446): 0% `op 0, scale(0.92) translateY(24px)`; 60% `op 1, scale(1.02) translateY(-4px)`; 100% `op 1, scale(1) translateY(0)`.
- `pulls-spin` (L2451): to `rotate(360deg)`. `pulls-caret` (L2454): 0%,50% `op 1`; 50.01%,100% `op 0`.
- `yuki-unfold` (L2458): 0% `height:0; op 0`; 100% `height: var(--unfold-h); op 1`. `yuki-fold` (L2462): reverse.
- `yuki-jelly-out` (L2466): 0% `op 1, scale(1) translateY(0)`; 30% `op 1, scale(1.01) translateY(-4px)`; 100% `op 0, scale(0.94) translateY(16px)`.
- `yuki-ratchet` (L2471): to `rotate(360deg)` (played with steps(8)).
- `yuki-sign-on` (L2474): 0% `op 0.12; text-shadow:none; brightness(0.5)`; 16% `op 1; text-shadow: 0 0 8px currentColor, 0 0 22px currentColor; brightness(1.35)`; 28% `op 0.2; none; 0.6`; 44% `op 1; same shadows; 1.3`; 56% `op 0.35; 0 0 4px currentColor; 0.75`; 70%,100% `op 1; 0 0 6px + 0 0 18px currentColor; 1.15`.
- `pulls-fade-up` (L2483): `op 0, translateY(10px)` → `op 1, none`.
- `pulls-pop-in` (L2493): `op 0, scale(0.85)` → `op 1, scale(1)`.
- `pulls-reveal` (L2503): `op 0, rotateY(-38deg) scale(0.9)` → `op 1, none`.
- `pulls-shimmer` (L2513): `background-position: 200% 0` → `-200% 0`.
- `pulls-pulse-live` (L2521): 0%,100% `op 1; box-shadow: 0 0 0 0 rgba(61,220,151,0.5)`; 50% `op 0.75; 0 0 0 5px rgba(61,220,151,0)`. (Literal green — not a token.)
- `yuki-split-in` (L2929): `op 0, translateY(0.4em)` → `op 1, 0`.
- `yuki-blur-in` (L2939): `op 0, blur(8px), translateY(8px)` → `op 1, blur(0), 0`.
- `yuki-intro-rise` (L2953): `op 0, blur(10px), translateY(20%)` → resting.
- `yuki-intro-focus` (L2965): `op 0, blur(10px)` → `op 1, blur(0)`.
- `pulls-panel-in` (L3070): `translateX(-100%)` → none. `pulls-fade-in` (L3074): op 0→1.
- `pulls-row-in` (L3078): `op 0, translateX(-10px)` → resting.
- `pulls-row-out` (L3086): 0% `op 1, none, max-height:8rem`; 45% `op 0, translateX(-24px), 8rem`; 100% `op 0, -24px, max-height:0`.
- `pulls-swap-in` (L3091): `op 0, scale(0.96)` → `op 1, scale(1)`.
- Agent cubes (L3109–3182; easing always `var(--ease-in-out)` except spin3d linear; durations composed in `avatar/cube.tsx`):
  - `agent-cube-bob`: 0/100 `y 0`; 50% `y -5px`. `-rise`: 0,55,100 `0`; 20,35 `-11px`. `-appear`: 0% `op 0, y 8px`; 10% `op 1, 0`; 93% `op 1, 0`; 95–100% `op 0`. `-drop`: 0% `op 0, y -24px`; 18% `op 1, 0`; 93% `op 1`; 95–100% `op 0`. `-glide`: 0 `translate(0,0)` → 100% `translate(39px, 19.5px)`. `-blinkfade`: 0/100 `op .15`; 50 `op .95`. `-blinkslow`: 0/100 `op 1`; 50 `op .25`. `-lift`: 45,60 `y -6.5px`. `-lift2`: 45,60 `y -13px`. `-settle`: 50 `y -3px`. `-pull`: 0,60,100 `0`; 25,40 `y -20px`. `-shake`: 20 `-2.5px`, 40 `2.5px`, 60 `-2px`, 80 `2px`. `-bounce`: 35 `-16px`, 55 `0`, 70 `-6px`, 82 `0`. `-spin3d`: `rotateX/Y/Z 0 → 360deg`. `-scene-in`: op 0→1.
- `pulls-confirm-in` (L3347): `op 0, translateX(12%)` → resting. `pulls-confirm-out` (L3351): op 1→0.
- `pulls-blur-out` (L3355): `op 1, blur(0)` → `op 0, blur(6px)`. `pulls-blur-in` (L3359): `op 0, blur(8px)` → `op 1, blur(0)`.
- `star-sway` (L3481): `rotate: -6deg → 6deg` (standalone `rotate` longhand). `star-sway-alt` (L3485): `5deg → -5deg`.

## 9. Unlayered component styling
### Toast `.cn-toast.cn-toast.cn-toast` (L2584–2810; tripled class = specificity 0,3,0 to beat sonner's runtime styles)
Container: `display:flex; align-items:flex-start; gap:12px; width: var(--width, 22.25rem)` (356px); `padding:16px; border:1px solid var(--border); border-radius: var(--radius-lg); background-color: var(--popover); box-shadow: var(--shadow-e3); color: var(--popover-foreground); font-family: var(--font-sans); font-size: var(--text-small); line-height:1.5; overflow:hidden`.
Bloom reclaim (L2642–2651): `::before`/`::after` re-assert `inset/width/height:auto` from `--bloom-deep-*`/`--bloom-near-*`. `:not([data-sonner-toast]) { position: relative }` (preview only).
Per-type bloom hues (L2665–2684): success `--bloom-1: var(--color-success); --bloom-2: var(--color-value)`; warning `value-bright / value-dark`; error `var(--destructive) / var(--color-action)`; info `var(--color-info) / var(--color-action)`; loading `var(--color-action-bright) / var(--color-value)`.
`[data-icon]`: flex; shrink 0; `margin-top: 2px`; `color: var(--muted-foreground)`; per-type icon inks (L2756–2770): success→`--success-ink`, warning→`--warning-ink`, info→`--info-ink`, error→`--destructive-ink`, loading→`--action-ink`.
`[data-content]`: flex column; gap 4px; min-width 0. `[data-title]`: text-small/500/foreground. `[data-description]`: text-small/muted-foreground. `[data-button]`: shrink 0; margin-left auto; `height:32px; padding-inline:14px; border:1px solid transparent; border-radius: var(--radius-pill); background: var(--secondary); box-shadow:none; color: var(--secondary-foreground); text-small/500; transition: background-color 250ms ease-out`; hover `background: var(--accent)`.

### Sidebar pill (L2704–2719)
`.sidebar-pill::before/::after` and its `.starfield::before/::after` → `animation-play-state: paused`; resumed by `[data-slot="sidebar-menu"]:has([data-active="true"]:hover) …` → `running` (uses `:has()`).

### Blend flip per theme (L3235–3295)
`:root .bloom-cosmic::before/::after, .light …` → `mix-blend-mode: multiply; opacity: 0.34`. `.dark .bloom-cosmic::before/::after` → `screen; opacity: 0.75`. `:root/.light .sheen-action::before` → `multiply`; `.dark .sheen-action::before` → `screen`. Foil glint stays `screen` in both themes (opaque base).

### Starfield (L3397–3488)
`.starfield { position:absolute; inset:0; pointer-events:none }`. Both pseudos on `.starfield` AND `.bloom-cosmic [data-content]` (descendant): `content:""; position:absolute; inset:0; pointer-events:none; background-repeat:no-repeat; filter: drop-shadow(0 0 var(--star-glow-size) var(--star-glow)) drop-shadow(0 0 calc(var(--star-glow-size) * 3) var(--star-glow)); transition: translate 1000ms ease-out, scale 1000ms ease-out`.
`::before` (dense bottom-right): `background-position: right bottom; background-size: 260px 96px; transform-origin: 100% 100%; animation: star-sway 44s ease-in-out infinite alternate`. `::after` (thin top-right): `right top; 200px 64px; origin 100% 0%; star-sway-alt 33s … alternate`.
Hover (`.bloom-cosmic:hover`): before `translate: -5px 3px; scale: 1.06`; after `translate: -3px -2px; scale: 1.04`.
Star art: inline SVG data URIs, fill `#ffffff` in BOTH themes. Star path (4-point curved star on 24×24): `M12 0C12 6.6 17.4 12 24 12C17.4 12 12 17.4 12 24C12 17.4 6.6 12 0 12C6.6 12 12 6.6 12 0Z`. Cluster 1 (viewBox 260×96), 8 stars `(opacity, translate, scale)`: (.95, 214,54, .46), (.78, 240,24, .26), (.85, 180,76, .32), (.66, 248,72, .2), (.55, 196,16, .18), (.58, 146,40, .22), (.5, 232,92, .16), (.42, 112,66, .15). Cluster 2 (200×64), 5 stars: (.78, 168,18, .24), (.55, 132,42, .17), (.6, 190,46, .18), (.42, 96,14, .13), (.38, 150,60, .12).

### Reduced motion (L2534–2565, 3184–3214)
Global: `*, *::before, *::after { animation-duration: 0.01ms !important; animation-iteration-count: 1 !important; transition-duration: 0.01ms !important; scroll-behavior: auto !important }`. Plus `.anim-fade-up/.anim-pop-in/.anim-reveal { opacity:1 !important; transform:none !important }`; `.anim-intro-rise/-panel/-glow/.anim-blur-word-in { animation:none !important; opacity/transform/filter reset !important }` (delays aren't collapsed by the generic rule). Agent cubes: `.agent-cube-scene .agent-cube-anim { animation:none; opacity:1; transform:none !important }` under the media query, and the same via `.agent-cube-frozen` class without it.

### theme-reference overrides (L3578–3693)
Type: `.type-display` 2.25rem/1/500/-0.02em, `@media (width >= 64rem)` 3.5rem; `.type-h2` 1.75rem/2.25rem/500/-0.01em; `.type-h3` 1.5rem/2rem; `.type-h4` 1.25rem/1.75rem; `.type-lead/.type-body` 0.9375rem/1.5rem/400; `.type-small` 0.8125rem/1.25rem; `.type-accent` 1.055em/-0.03em. Container `[data-slot="page-container"]`: `max-width: calc(1200px + 24px*2); padding-inline: 24px`, ≥40rem: `calc(1200px + 22px*2)` / 22px. `.aurora-brand` override (unlayered wins over @utility): `linear-gradient(90deg, rgba(255,59,0,0.2) 0%, rgba(246,0,157,0.2) 38%, rgba(151,62,198,0.2) 71%, rgba(0,142,255,0.2) 100%)`. `.glass-panel-deep` override: `@apply backdrop-blur-showcase backdrop-saturate-100` (20px blur, saturation reset to 1); `background-color: var(--surface-showcase)`; 7-layer shadow: `0 0 0 0.5px var(--rim-showcase), 0 149px 199px 0 rgba(0,0,0,0.07), 0 62.249px 83.137px 0 rgba(0,0,0,0.05), 0 33.281px 44.449px 0 rgba(0,0,0,0.04), 0 18.657px 24.918px 0 rgba(0,0,0,0.04), 0 9.909px 13.234px 0 rgba(0,0,0,0.03), 0 4.123px 5.507px 0 rgba(0,0,0,0.02)`. Motion: `.anim-intro-rise/-panel` duration 800ms + `--ease-intro`; `.anim-intro-glow` easing only.

## 10. CSS features hard in Flutter — where each is used
1. **oklch relative color syntax** `oklch(from X calc(l*…) calc(c*…) h)`: `--bubble-tinted(-hover)` L602–603/L811–812; `bloom-cosmic` `--bloom-core/--bloom-glow/--bloom-hot` L1684–1695; `oklch(15% 0 0)` L3557. Flutter: precompute per theme, or implement OKLCH math (bloom multipliers `--bloom-l/-c/-lift/-hot-c` make dark/light diverge — must compute, not hardcode, if per-type toast hues are kept).
2. **color-mix(in oklab, …)**: pervasive — shadows L369–387, ::selection L1008, star-glow L714, glass fills/rims L1579–1616, bloom-action/value L1623–1636, all bloom-cosmic stops L1748–1807, foil L1964–2022, sheen L2093–2151, aurora L3043–3049. Flutter: OKLab interpolation needed for fidelity (chroma-reduction gamut mapping already decided in port memory).
3. **backdrop-filter (blur + saturate)**: glass-panel/glass-panel-deep (blur 24px + saturate 150%) L1577/L1602; theme-reference showcase (blur 20px, saturate 100%) L3668. Flutter: `BackdropFilter` (blur yes; saturation via ColorFilter matrix).
4. **mix-blend-mode**: `screen` (bloom layers dark, glint, sheen beat), `multiply` (bloom + sheen beat on light, opacity 0.34), `soft-light` (foil ::after, sheen ::after — no native Flutter BlendMode.softLight ≈ use `BlendMode.softLight`, which does exist in Flutter's enum, but CSS soft-light formula differs slightly). Locations L1741, 1778, 1993, 2028, 2115, 2157, 3235–3295.
5. **mask-image** radial gradient: bloom-cosmic `::after` L3811–3816 region (`radial-gradient(78% 108% at 96% 78%, black 0/28%, transparent 84%)`). Flutter: ShaderMask.
6. **isolation: isolate** L1707 — blend must not reach below the card. Flutter: blend within a saved layer.
7. **filter: blur() on painted layers**: bloom ::before 16px, ::after 10px (L1742/1777); animated blur in keyframes `yuki-blur-in`, `yuki-intro-rise/-focus`, `pulls-blur-out/in` (animating blur is expensive in Flutter — ImageFiltered per frame).
8. **filter: drop-shadow (two-pass) following image alpha**: starfield L3424–3426. Flutter: two stacked blurred copies of the star painter.
9. **Inset box-shadows** (multi-layer, mixed inset+outer): every machine shadow (e-family, key, pressed, btn, chip, glass rims). Flutter: no inset shadow primitive — the port already has `ElMachineSurface` for this (per memory).
10. **background-clip: text** shimmer: `anim-shimmer-text` L3056–3068. Flutter: ShaderMask over Text.
11. **repeating-linear-gradient** 1px striations: foil L2006, sheen L2136. Flutter: tiled gradient or custom painter.
12. **Standalone transform longhands composing** (`scale`/`rotate`/`translate` animating independently of a `transform` animation): bloom hover scale L1836–1846; starfield sway (`rotate`) + hover (`translate`/`scale`) L3427–3460. Flutter: compose in one Transform — trivially fine there.
13. **`:has()`** sidebar pill wake L2710. Flutter: explicit hover state plumbing.
14. **steps() easing**: `anim-caret` steps(1,end), `anim-ratchet` steps(8), `yuki-sign-on` steps(1,end). Flutter: custom Curve.
15. **Animating layout height from a variable** (`yuki-unfold`/`--unfold-h` ← Radix content height) with spring overshoot — Flutter SizeTransition with spring curve.
16. **Fixed-attachment viewport radial page glow** (body L986–991) — Flutter: paint behind scroll content, not scrolling with it.
17. **clamp() fluid type**: `.type-display`, `.type-h1`. Flutter: compute from viewport width.
18. **font-variant-numeric: tabular-nums** (`.tabular`, `.type-num-*`) — `FontFeature.tabularFigures()`.
19. **Variable font weight 650** (`.type-h2`) — needs variable-font axis support (`FontVariation('wght', 650)`).
20. **::selection / scrollbar styling / color-scheme / scroll-padding** — platform-level equivalents.
21. **Alpha-hex 8-digit colors** (`#000000df` etc.) in theme-reference — straightforward, just note the alpha channel.
22. **Conic gradients: none used** anywhere in this file.

## 11. Notable internal drift (both sides, verbatim)
1. **Fonts**: comment L167–168 *"Space Grotesk owns words"* vs tokens `--font-sans/--font-heading: "Inter Local"`. Tokens win.
2. **Action ramp hexes**: old annotations `#93C5FD/#2563EB/#1D4ED8` vs actual raster `#92C2FC/#1A6EF4/#143694` (L99–105). hsl values authoritative.
3. **dark `--value-ink`** = `-bright`, deliberately against the system's §1.3 mid-shade table (L784–798).
4. **dark chart ordering** deliberately not "down each ramp" (L828–846) — legibility over story.
5. `.type-accent` comment describes synthesized italic on the mono face (L1037–1045) while the token uses Redaction 35 (a genuine italic serif).
6. `--tracking-cta: 0.09em` is declared (L184) but referenced by no class in this file.
7. `pulls-pulse-live` uses literal `rgba(61,220,151,…)` — an untokenized green (L2525–2529).
8. Sidebar token block repeated verbatim in both themes on purpose (subtree theming; L630–658 / L848–869).
9. Balance target stated twice: "~70% neutral / ~20% action / ~10% value" (L65, L738–739).