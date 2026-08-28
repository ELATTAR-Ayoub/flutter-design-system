# Fonts & Static Assets Map — `D:/DESIGN/Design-System-2026-8/design-system`

Scope: font wiring for the whole app; icon + image inventory for the docs shell (`app/layout.tsx` + `app/design-system/layout.tsx`) and the four pages `/design-system` (overview), `/design-system/colors`, `/design-system/typography`, `/design-system/spacing`; full recursive `public/` listing; Flutter copy list.

---

## 1. Font inventory (family → file → weights/axes)

| CSS family name | File (absolute) | Size | Format | Axes / weights (measured with fontTools) | Style | Internal font name |
|---|---|---|---|---|---|---|
| `"Inter Local"` | `D:/DESIGN/Design-System-2026-8/design-system/public/fonts/inter-variable.woff2` | 352,240 B | woff2 variable | `opsz` 14–32 (default 14), `wght` 100–900 (default 400) | normal only — **no italic file; italics would be synthesized** | family `Inter Variable`, PS `InterVariable` |
| `"Redaction 35"` | `D:/DESIGN/Design-System-2026-8/design-system/public/fonts/redaction-35-italic.woff2` | 50,260 B | woff2 static | single instance, weight 400, **no fvar** | italic | family `Redaction 35`, subfamily `Italic`, PS `Redaction35-Italic` |
| `--font-geist-mono` (Geist Mono) | `D:/DESIGN/Design-System-2026-8/design-system/node_modules/geist/dist/fonts/geist-mono/GeistMono-Variable.woff2` | 71,368 B | woff2 variable | `wght` 100–900 (default 400) | normal only (package also ships 9 static weights + italics; only Variable is loaded) | family `Geist Mono`, PS `GeistMono-Regular` |

A TTF twin exists for Flutter (which cannot load woff2): `node_modules/geist/dist/fonts/geist-mono/GeistMono-Variable.ttf` (171,200 B). Inter/Redaction have no TTF in the repo — the two woff2 files must be converted (`fonttools ttLib.woff2 decompress`) for the Flutter port.

### Wiring — exactly how each font loads

**Geist Mono** — `app/layout.tsx` line 2: `import { GeistMono } from "geist/font/mono"` (geist@1.7.2 installed; `^1.7.2` in package.json; next 16.2.12). The package module is `next/font/local` with:
- `src: "./fonts/geist-mono/GeistMono-Variable.woff2"`, `variable: "--font-geist-mono"`, `weight: "100 900"`, `adjustFontFallback: false`
- fallback: `["ui-monospace","SFMono-Regular","Roboto Mono","Menlo","Monaco","Liberation Mono","DejaVu Sans Mono","Courier New","monospace"]`
- Applied as `className={`${GeistMono.variable} h-full antialiased`}` on `<html>` — **variable-only**; nothing sets Geist as a default body family.

**Inter Local + Redaction 35** — plain `@font-face` in `app/globals.css` lines 7–21 (not next/font):
```css
@font-face { font-family: "Inter Local"; src: url("/fonts/inter-variable.woff2") format("woff2"); font-style: normal; font-weight: 100 900; font-display: swap; }
@font-face { font-family: "Redaction 35"; src: url("/fonts/redaction-35-italic.woff2") format("woff2"); font-style: italic; font-weight: 400; font-display: swap; }
```

**Font tokens** — `app/globals.css` lines 169–172:
```css
--font-sans: "Inter Local", ui-sans-serif, system-ui, sans-serif;
--font-mono: var(--font-geist-mono), ui-monospace, monospace;
--font-heading: "Inter Local", ui-sans-serif, system-ui, sans-serif;   /* identical to sans */
--font-accent: "Redaction 35", ui-serif, Georgia, serif;
```
Weight tokens: `--font-weight-normal: 400; --font-weight-medium: 500; --font-weight-semibold: 600`. Note `.type-wordmark` (globals.css 1201–1206, used by the logo) uses `font-weight: 700` — outside the three weight tokens, covered by Inter's wght axis. `.type-accent` (1046–1052): `font-family: var(--font-accent); font-size: 1.055em; font-style: italic; font-weight: 400; letter-spacing: var(--tracking-display)`.

### DRIFT — copy says Space Grotesk, tokens say Inter (report both sides, render per tokens)
- globals.css line 168 comment: "Space Grotesk owns words. Geist Mono owns numerical values, serials and code." — but `--font-sans`/`--font-heading` resolve to **"Inter Local"**.
- Overview page rule 04 (verbatim): "**Two faces only.** Space Grotesk for words. Geist Mono, tabular, for numerical values, serials and code through the named typography foundations."
- Typography page: panel label "Space Grotesk — words", section description "Words stay in Space Grotesk…", DoDont "Don't add a third typeface for display; heavy Space Grotesk at tight tracking already carries the hero."
- Space Grotesk exists **nowhere** in the repo (no file, no import). What renders is Inter Variable.
- Second drift: globals.css comment above `.type-accent` (lines 1043–1045) claims "The italic is synthesised — Geist Mono ships a weight axis and no italic" — but `.type-accent` actually uses `--font-accent` = Redaction 35, which is a true italic file. Nothing is synthesized there. (The genuinely synthesizable case is italic Inter, which has no italic face.)

---

## 2. Icon system

- Source set: **lucide-react 1.28.0** (installed; `^1.28.0` declared). No custom icon font, no sprite sheet. One custom inline SVG: the logo mark.
- Single entry point: `components/ui/icon.tsx` `<Icon icon={Glyph} size tone label>`:
  - `ICON_SIZES`: xs 12, sm 14, md 16 (default), lg 20, xl 24, 2xl 32, 3xl 40 (px, set as width/height attrs).
  - `strokeWidth` formula: `(2*24)/px > 2.6 ? 2.4 : (2*24)/px < 1.5 ? 1.6 : 2` → computed: xs/sm/md → **2.4**, lg/xl/2xl → **2**, 3xl → **1.6**.
  - Tones map to token classes: default `text-foreground`, muted/subtle `text-muted-foreground`, action `text-action-ink`, value `text-value-ink`, success/warning/info/error → `text-*-ink`, inherit `text-current` (default tone is **inherit**).
  - a11y: `aria-hidden` unless `label` given (then `role="img"` + `aria-label`); `focusable="false"`, `shrink-0`.
- Exception: `theme-toggle.tsx` renders lucide components **directly** (not through `Icon`) at `className="size-3.5"` (14px) with lucide default strokeWidth 2.

## 3. Icon inventory per page (verbatim lucide names)

**Shell — root layout (`app/layout.tsx`) + docs layout (`app/design-system/layout.tsx`):**
| Icon | Where | Rendered spec |
|---|---|---|
| `Menu` | `components/el/el-nav.tsx` `MobileNav` trigger (Button variant outline size icon, `lg:hidden`) | via `Icon`, md 16px, stroke 2.4, tone inherit |
| `XIcon` | `components/ui/sheet.tsx` close button inside the mobile nav SheetContent (absolute top-3 right-3, `size="icon-sm"`, sr-only "Close") | via `Icon`, md 16px, stroke 2.4 |
| `SunIcon`, `MonitorIcon`, `MoonIcon` | `components/el/theme-toggle.tsx` (Light · System · Dark radiogroup, order: light/system/dark) | direct render, `size-3.5` = 14px, stroke 2 |
| *(custom, not lucide)* logo chevron | `components/el/logo.tsx` `LogoMark` | inline SVG `viewBox="0 0 24 24"`, `size-4` (16px) in a `size-7` (28px) `rounded-md bg-action` tile; path 1 `M6 15.5 12 6l6 9.5` stroke `var(--primary-foreground)` width 2.4 linecap square; path 2 `M6 19h12` stroke `var(--color-value-bright)` width 2.4. Wordmark text: `ELATTAR` + `ELATTAR` in `text-value-ink`, `.type-wordmark` |
| `CircleCheckIcon`, `InfoIcon`, `TriangleAlertIcon`, `OctagonXIcon`, `Loader2Icon` | `components/ui/sonner.tsx` Toaster (mounted globally in root layout, bottom-right) | only visible when a toast fires — none fire on these four pages |

**Overview `/design-system` (`app/design-system/page.tsx`):**
- `ArrowRight` — (a) imported in the page, on each of the two component-group cards: `<Icon icon={ArrowRight} className="mt-1 size-5 …">` — width/height attrs 16 (md) but the `size-5` class wins → renders **20px with the md stroke 2.4** (an Icon `size="lg"` would give 20px/stroke 2 — as-built quirk, keep it); hover `translate-x-0.5` + color → `text-action-ink`. (b) in every `IndexCard` (kit.tsx) for the 5 Foundations cards: `size="md" tone="muted"`, hover same.
- No `PageFootNav`, no `DoDont` on this page. Total distinct: **ArrowRight** only.

**Colors `/design-system/colors`:**
- No lucide import in the page file. Via kit only: `ArrowLeft`, `ArrowRight` in `PageFootNav` (md 16, tone muted). `TokenSwatchList`/`Note`/`Panel`/`Meta` render no icons. Total: **ArrowLeft, ArrowRight**.

**Typography `/design-system/typography`:**
- `Check` (DoDont "Do" list, `size="sm"`=14px stroke 2.4, `tone="value"`), `X` (DoDont "Don't", sm, `tone="error"`), `ArrowLeft` + `ArrowRight` (PageFootNav). Total: **Check, X, ArrowLeft, ArrowRight**.

**Spacing `/design-system/spacing`:**
- Identical set: **Check, X, ArrowLeft, ArrowRight** (DoDont + PageFootNav).

**Images/videos on these five surfaces: NONE.** No `next/image`, `<img>`, or `<video>` anywhere in the shell or the four pages. The only raster the shell references is `app/favicon.ico` (25,931 B, browser tab). Everything visual is CSS/tokens/inline SVG. (The starfield/`feedback-surface` textures in globals.css lines 3472–3479 are inline SVG **data URIs** — two layers of white 4-point star paths with exact opacities/transforms, `star-sway` ±6°/`star-sway-alt` ∓5° keyframes — used by toasts/reward surfaces, not by these pages at rest.)

---

## 4. `public/` recursive listing (file → bytes)

```
public/3d/.gitkeep                          0      (empty dir)
public/fonts/inter-variable.woff2           352,240
public/fonts/redaction-35-italic.woff2      50,260
public/imgs/sample-card.png                 631,231   (used by /design-system/components/base/chat)
public/imgs/sample-pack.jpg                 453,916   (used by /design-system/components/base/dialogs)
public/interfere/dylan.webp                 27,001    ┐
public/interfere/jakub.avif                 7,016     │ interfere site-clone family only
public/interfere/luke.avif                  3,488     │ (components/interfere/*)
public/interfere/paul.avif                  3,737     │
public/interfere/phillip.avif               15,882    │
public/interfere/profound.webp              1,898     ┘
public/interfere/original/{detect,overview,resolve,understand}.png   120,778 / 285,874 / 178,361 / 144,708
public/interfere/original-svg/              251 svg files (document-0..129 = 130; section-{0..8}-* = 121), 378–34,082 B each
public/interfere-clone.html                 453,546   (reference capture, excluded from Tailwind @source)
public/interfere-clone-dark.html            453,551   (same)
public/svgs/.gitkeep                        0      (empty dir)
public/textures/perlin-noise.png            45,385    (agent voice orb: components/agent/voice/orb-vendor.tsx, THREE RepeatWrapping)
public/vids/.gitkeep                        0      (empty dir)
```
Also relevant outside `public/`: `app/favicon.ico` 25,931 B. `downloaded_assets/` (css/js/manifest.json) and `reference/` are clone research artifacts — never served, never imported.

---

## 5. Asset copy list for the Flutter port

**Copy + convert (required for shell + foundation pages):**
1. `public/fonts/inter-variable.woff2` → convert to TTF (Flutter has no woff2 loader). Register family "Inter Local"; variable axes opsz 14 (leave at default) + wght 100–900; weights actually used: 400/500/600/700. No italic file — do not fake one.
2. `public/fonts/redaction-35-italic.woff2` → TTF. Family "Redaction 35", italic 400 only (used only by `.type-accent` on site/landing surfaces, not the four foundation pages — still part of the token set).
3. `node_modules/geist/dist/fonts/geist-mono/GeistMono-Variable.ttf` (171,200 B) — already TTF, copy directly; wght 100–900; used at 400/500/600 tabular.
4. `app/favicon.ico` — only for the web/desktop window icon of the docs-app port.

**Do NOT copy for this scope** (needed only by later families): `imgs/sample-card.png`, `imgs/sample-pack.jpg` (base components pages), `textures/perlin-noise.png` (agent voice orb), all of `interfere/` incl. `original-svg/` 251 files (interfere site family), `interfere-clone*.html`, `downloaded_assets/`, `reference/`. `3d/`, `svgs/`, `vids/` are empty placeholders.

**Re-create in Flutter code (no source file exists):** the `LogoMark` chevron SVG (two strokes, exact paths above → CustomPainter), and the two starfield data-URI SVGs (exact per-star `translate/scale/opacity` values in globals.css 3472–3479) when the toast/reward surfaces are ported.

**Icon dependency:** lucide-react 1.28.0 → use a Flutter Lucide package pinned to matching glyph geometry; port the `Icon` wrapper's size ladder (12/14/16/20/24/32/40) and the computed stroke widths (2.4 / 2.4 / 2.4 / 2 / 2 / 2 / 1.6) rather than lucide's flat default 2; theme-toggle glyphs are the one direct-render exception (14px, stroke 2).