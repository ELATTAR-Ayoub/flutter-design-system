# Map — `/design-system/icons` (Foundations · Icons)

**Files that produce the render** (all under `D:\DESIGN\Design-System-2026-8\design-system\`):
- `app\design-system\icons\page.tsx` — the page (252 lines, server component, no client code, no local components; two module-level `Record` maps `sizeUse` and `toneUse` supply the per-row copy)
- `components\ui\icon.tsx` — `Icon`, `ICON_SIZES`, `ICON_TONES` — **the page's own subject**, and the thing every other page borrows
- `lib\el\icons.ts` — `ICON_GROUPS` (four groups, 63 entries) and `ICON_COUNT` (a `reduce`, not a literal)
- `components\el\kit.tsx` — `ElPageHeader`, `ElSection`, `Panel`, `Meta`, `Code`, `DoDont`, `Note`, `PageFootNav` (all eight used)
- `components\ui\button.tsx` — `Button` (five instances; four variants plus `ghost`+`size="icon"`)
- `lib\el\nav.ts` — `findCategory("foundations","icons")` supplies header copy; `siblings()` supplies foot-nav
- `app\design-system\layout.tsx`, `app\layout.tsx` — shell
- `app\globals.css` — every token/class referenced below
- `node_modules\lucide-react\dist\esm\icons\*.mjs` — **lucide-react 1.28.0, ISC**; the geometry itself

**Flutter target** (all under `D:\DESIGN\Design-System-2026-8\flutter-design-system\`):
- `lib\src\components\icon.dart` — `ElIcon`, `ElIconSize`, `ElIconTone` — **already complete**
- `lib\src\components\icon_paths.dart` — `ElIconGlyph` (8 members), `ElIconElement` (4 subclasses), `_SvgPathParser` — **the gap**
- `test\icon_paths_test.dart` — the transcript guard
- `example\lib\kit.dart` — `ElPageHeader`/`ElSection`/`ElPanel`/`ElMeta`/`ElCode`/`ElDoDont`/`ElNote`/`ElPageFootNav`
- `example\lib\nav.dart` — `icons` category already registered, last in `foundations`
- `example\lib\main.dart` — `pageFor()`; `/design-system/icons` currently falls to `PlaceholderPage`

---

## 0 · Shell / layout metrics (what frames the page)

Identical to every other foundations page — see `spacing-map.md §0`. Restated only where this page depends on it:

- Frame `max-w-(--width-shell)` = **1680px**; sidebar 240px; main `px-6 py-12 lg:px-12`; inner column `max-w-(--width-content)` = **1080px**. Every grid breakpoint below (`sm:` 640, `lg:` 1024) fires against the *viewport*, not the column.
- `html { scroll-behavior: smooth; scroll-padding-block-start: var(--scroll-offset) }` = **96px**. Sections carry no `scroll-mt-*`.
- Spacing unit `--spacing: 0.25rem` (4px). Focus ring `outline: 2px solid var(--ring); outline-offset: 2px`.
- **Fonts (drift — report both sides):** globals.css prose and nav.ts's typography blurb say "Space Grotesk"; the tokens say `--font-sans`/`--font-heading` = **"Inter Local"**. All `.type-num*` / `.type-code` render **Geist Mono** (`--font-mono`). Per project memory: fonts follow tokens, not prose.

---

## 1 · Page header (`ElPageHeader`)

`<header class="mb-14 border-b border-border pb-10">` — 56px below, 40px inner bottom. All four props come from `findCategory("foundations","icons")`; **the page overrides nothing** (unlike the colors page, which substitutes its own blurb and chips).

1. Eyebrow `p.type-label.text-action-ink` → **"Foundations"** — 11px/1, 600, uppercase, tracking 0.16em. (`.type-label` declares `color: var(--muted-foreground)` on itself, but `text-action-ink` is a *utility* and utilities layer after components, so the eyebrow **does** come out action-ink. This is the opposite of the `Note` title case in §2.3.)
2. `h1.type-h1.mt-4.text-foreground` → **"Icons"** — `clamp(2rem, 2.8vw, 2.5rem)` (32–40px), lh 1.1, 700, tracking −0.02em.
3. Blurb `p.type-lead.mt-4.max-w-2xl` (672px) → **"The Icon component wrapping Lucide: fixed sizes, stroke rules, and the curated icon set, grouped by domain."** — 17px, lh 1.65, 400, `--muted-foreground`.
4. Chips `ul.mt-7.flex.flex-wrap.gap-2`; each `li.type-chip.rounded-pill.border.border-border.bg-card.px-3.py-1.5.text-muted-foreground` (11.5px/1.2, 500; radius 999px; 12px/6px padding). Static `<li>`, **not links** — they do not scroll. Verbatim, in order:

> **Icon component · Sizes · Tones · Navigation set · Action set · Domain set**

⚠ **Chip/section drift.** Six chips, but the page has six *sections* with different names: `#component`, `#sizes`, `#tones`, `#in-context`, `#set`, `#rules`. The last three chips ("Navigation set", "Action set", "Domain set") name three of the four **Panels inside the single `#set` section**, and the fourth group ("Money & status") gets no chip at all. "Icons in controls" and "Rules" get no chip. Port the chips as data — they are labels, not a table of contents.

---

## 2 · Section `#component` — "The Icon component"

`ElSection` shell (all sections): `<section id="…" class="mb-20">` (80px); heading block `mb-6`; `h2.type-h3.text-foreground` (21px/1.3, 600, −0.01em); description `p.type-small.mt-2.max-w-2xl` (13px/1.5, 400, muted).

Description (verbatim): **"Lucide is the source set, but it is never imported straight into a screen. Everything goes through one component, which forces a size, a tone and an accessibility decision on every instance."**

### 2.1 `Panel label="Usage"` — the code block

**Panel anatomy** (every panel on this page): outer `div.overflow-hidden.rounded-xl.border.border-border.bg-card` — radius **16px**. Header strip renders when *either* `label` or `note` is set: `flex items-baseline justify-between gap-4 border-b border-border bg-muted px-5 py-3` (20px/12px); label `span.type-label.text-muted-foreground`; note `span.type-num-sm.text-muted-foreground` (mono 12px). Body `div.bg-background.p-6` (24px) — **the body is `--background`, not the card colour**, so the panel reads as three surfaces stacked: card frame → muted strip → background body.

The body here is a single `<pre>`:

```
type-code scrollbar-thin overflow-x-auto rounded-lg border border-border bg-background p-5 leading-relaxed text-muted-foreground
```

- Geist Mono **12.5px** (`--text-code`), colour `--muted-foreground`, weight inherited (**`.type-code` sets no `font-weight`** — this is the one mono class on the site that is *not* 600).
- ⚠ **`leading-relaxed` beats `.type-code`.** `.type-code` declares `line-height: 1.4` inside `@layer components` (globals.css:1157–1163); `leading-relaxed` is a utility → `line-height: 1.625` wins. Rendered leading is **1.625**, i.e. 20.3125px per line.
- Radius `rounded-lg` = 12px, padding `p-5` = 20px, 1px `--border` hairline, fill `--background` — the same colour as the panel body it sits in, so **only the hairline separates them**.
- `overflow-x-auto` + `scrollbar-thin`: horizontal scroller, `scrollbar-width: thin`, thumb `--border` (hover `--muted-foreground`), track transparent, 8px track, 999px thumb radius (globals.css:2822–2860). At 1080px content width minus 24px panel padding minus 40px pre padding = **1016px** of text box; the longest line is 71 chars ≈ 535px at 12.5px mono, so **it does not actually scroll at the 1440 frame**.

Contents, verbatim, nine lines (blank lines 3 and 7 are real):

```tsx
import { Icon } from "@/components/ui/icon"
import { PackageOpen } from "lucide-react"

// Decorative — adjacent text already says "Open Pack",
// so the glyph is hidden from screen readers.
<Icon icon={PackageOpen} size="md" tone="inherit" />

// Meaningful — icon-only control, so it must be named.
<Icon icon={Heart} size="lg" tone="value" label="Add to favourites" />
```

Details that are load-bearing for a verbatim port: the dashes on lines 4 and 8 are **em dashes (U+2014)**, the quotes are straight ASCII `"`, there is no trailing semicolon on either `import`, and **`Heart` is used on line 9 but never imported** — the snippet is illustrative prose inside a `<pre>`, not compiled, and ships with that hole. Keep it.

### 2.2 `Meta className="mt-4"` — the four props

**Meta anatomy**: `dl.divide-y.divide-border.overflow-hidden.rounded-lg.border.border-border.bg-card` (radius **12px**); each row `div.grid.gap-1.px-4.py-3.sm:grid-cols-[minmax(0,13rem)_1fr].sm:gap-4` (key column 208px at ≥640px, single stacked column below); `dt.type-num-sm.text-action-ink` (mono 12px/1.2, 600, tabular, −0.01em); `dd.type-small.text-muted-foreground` (13px/1.5).

| `dt` | `dd` (verbatim) |
|---|---|
| `icon` | A Lucide icon component. Required. |
| `size` | xs 12 · sm 14 · md 16 · lg 20 · xl 24 · 2xl 32 · 3xl 40. Default md. |
| `tone` | A token colour, or inherit. Default inherit, which is correct inside buttons. |
| `label` | Accessible name. Provide it when the icon carries meaning alone; omit it and the icon is aria-hidden. |

The separators in the `size` row are middle dots **·** (U+00B7), matching the sizes list in §3.

### 2.3 `Note tone="action" title="Stroke scales with the box" className="mt-4"`

Anatomy: `div.rounded-lg.border.p-5` (12px radius, 20px padding) + tone classes `border-action/30 bg-action/[0.08] text-action-ink` — a 30%-alpha `--color-action` border over an 8% wash. Title `p.type-label.mb-2`; body `div.type-small.text-muted-foreground`.

⚠ **Note titles render muted-foreground in every tone.** The tone's `text-action-ink` sits on the container and would be inherited, but `.type-label` declares `color: var(--muted-foreground)` **on the title element itself**, and an element's own declaration beats an inherited one regardless of layer. The tone shows only in the border and the wash. (Same finding as `colors-map.md §3`; restated because this page has two Notes.)

Body, verbatim (JSX line breaks collapse to single spaces):

> **"Lucide is drawn on a 24px grid for a 2px stroke. Rendered at 12px that stroke reads twice as heavy, and at 40px it reads thin. The component compensates automatically, so a 12px icon and a 40px icon carry the same optical weight."**

**The formula the copy is describing** (`components/ui/icon.tsx:82`):

```tsx
strokeWidth={(2 * 24) / px > 2.6 ? 2.4 : (2 * 24) / px < 1.5 ? 1.6 : 2}
```

It is a **three-rung snap, not a clamp** — the middle branch is a literal `2`, not the raw `48/px`. Resolved across the whole ladder:

| size | px | `48/px` | branch | `strokeWidth` | rendered CSS px (`stroke × px/24`) |
|---|---|---|---|---|---|
| xs | 12 | 4.000 | `> 2.6` | **2.4** | 1.20 |
| sm | 14 | 3.429 | `> 2.6` | **2.4** | 1.40 |
| md | 16 | 3.000 | `> 2.6` | **2.4** | 1.60 |
| lg | 20 | 2.400 | middle | **2.0** | 1.67 |
| xl | 24 | 2.000 | middle | **2.0** | 2.00 |
| 2xl | 32 | 1.500 | middle (`1.5 < 1.5` is false) | **2.0** | 2.67 |
| 3xl | 40 | 1.200 | `< 1.5` | **1.6** | 2.67 |

So the optical claim in the copy is approximate rather than exact: rendered stroke still climbs 1.20 → 2.67 across the ladder. Port the ternary, not the claim. `ElIcon.strokeFor` already transcribes it and `test/components_test.dart:92–101` already pins all seven rungs with the reasoning in a comment.

---

## 3 · Section `#sizes` — "Sizes"

Description (verbatim): **"Seven steps. Icons pair with text, so each size exists to sit beside a specific type class."**

`Panel label="The ladder"`, body in two blocks.

**Block 1 — the specimen row.** `div.flex.flex-wrap.items-end.gap-8` (32px gaps, **bottom-aligned**). Seven cells, each `div.text-center`:
- `div.grid.h-14.place-items-center` — a **56px**-tall box centring the glyph. Because the outer row is `items-end` and every cell's box is the same 56px, the *boxes* bottom-align, so the glyphs are centred at a common vertical midpoint and the 40px one overhangs the 12px one symmetrically.
- glyph: `Icon icon={PackageOpen} size={s} tone="muted"` — `--muted-foreground`, stroke per §2.3.
- `p.type-num-sm.mt-2.text-action-ink` → the **key string**: `xs`, `sm`, `md`, `lg`, `xl`, `2xl`, `3xl`.
- `p.type-micro.mt-1` → `12px` … `40px` (10.5px/1, 600, uppercase, tracking 0.18em, muted; digits+`px` are unaffected by the uppercasing).

**Block 2 — the use list.** `div.mt-6.space-y-2.border-t.border-border.pt-5` (24px above the rule, 20px below it, 8px between lines). Seven `p.type-small`, each rendering `<span class="type-num-sm text-muted-foreground">{key} · {px}px</span>` then a literal space, then `— {use}`:

| rendered line (verbatim) |
|---|
| `xs · 12px` — Pips and inline markers inside badges. |
| `sm · 14px` — Beside 13px text. Inside badges and chips. Small buttons. |
| `md · 16px` — The default. Inside standard buttons, rows, inputs. |
| `lg · 20px` — Navigation items, large buttons, stat tiles. |
| `xl · 24px` — Empty states, feature panels, section headers. |
| `2xl · 32px` — Reveal moments, rarity glyphs on cards. |
| `3xl · 40px` — Hero and error illustrations. |

Both the `·` and the `—` are literal U+00B7 / U+2014. The mono span is `--muted-foreground`, the sentence after it is `.type-small`'s own muted — same colour, different family and size, which is the whole point of the treatment.

⚠ **Key-name mapping for the Dart port.** The page prints the *object key*. `ElIconSize` spells the last two rungs `xl2`/`xl3` because Dart identifiers cannot start with a digit. The port must render **`2xl`** and **`3xl`**, not `xl2`/`xl3` — a label table, not `.name`.

---

## 4 · Section `#tones` — "Tones"

Description (verbatim): **"Icons never carry a raw hex. Every tone maps to a token, which keeps icon colour inside the 70/20/10 balance automatically."**

`Panel label="Ten tones"`, body `div.grid.gap-x-8.gap-y-5.sm:grid-cols-2.lg:grid-cols-3` — 32px column gap, 20px row gap; 1 column < 640, 2 at ≥640, **3 at ≥1024**. Ten cells → a 3×4 grid with two empty cells at the desktop frame.

Each cell `div.flex.items-center.gap-3` (12px):
- tile `span.grid.size-9.shrink-0.place-items-center.rounded-md.border.border-border.bg-card` — **36px square, radius 10px** (`--radius-md`), 1px `--border`, fill `--card`.
- glyph: `Icon icon={Search} size="lg" tone={t}` — **20px, strokeWidth 2.0**, colour per tone.
- `span.min-w-0` containing `span.type-num-sm.block.text-action-ink` (the tone key) and `span.type-small.block.leading-snug` (the use copy; `leading-snug` = 1.375, overriding `.type-small`'s 1.5, same layer logic as §2.1).

**Render order is `Object.keys(ICON_TONES)` — the `icon.tsx` order, not the page's `toneUse` literal order.** The page's `toneUse` map happens to declare `error` before `info`; that does not affect the render. The grid reads:

| # | tone key (rendered) | class | resolved colour dark / light | use copy (verbatim) |
|---|---|---|---|---|
| 1 | `default` | `text-foreground` | `hsl(0 0% 98%)` / `hsl(240 10% 3.9%)` | Primary text weight. |
| 2 | `muted` | `text-muted-foreground` | `hsl(240 4.9% 83.9%)` / `hsl(240 4% 40%)` | Beside body copy. Most common. |
| 3 | `subtle` | `text-muted-foreground` | *identical to muted* | Metadata and decorative affordances. |
| 4 | `action` | `text-action-ink` | `#92C2FC` / `#143694` | Interactive, selected, active. |
| 5 | `value` | `text-value-ink` | `#d9f99d` / `#4d7c0f` | Reward, premium, ranking — worth. |
| 6 | `success` | `text-success-ink` | `#10b981` / `#047857` | Confirmed, cleared, live, gained. |
| 7 | `warning` | `text-warning-ink` | `#fbbf24` / `#b45309` | Pending, needs attention. |
| 8 | `info` | `text-info-ink` | `#22d3ee` / `#0e7490` | Neutral notice, explainer. |
| 9 | `error` | `text-destructive-ink` | `#f87171` / `hsl(0 72.2% 46%)` | Failed, destructive. |
| 10 | `inherit` | `text-current` | inherits — here the panel body's `--foreground` | Takes the parent colour — the default inside buttons. |

Two things a 1:1 port must reproduce rather than tidy: **cells 2 and 3 are visually identical** (`subtle` is a separate *intent*, not a separate colour — `icon.tsx` keeps the name so the two can diverge later without touching call sites), and **cell 10 renders as plain foreground** because nothing on this page sets a text colour on the panel body, so `inherit` shows the `default` colour. The tone map also carries a five-line comment in `icon.tsx:38–43` recording that `success`/`warning` once resolved to the brand ramp and `info` to plain muted, which made the three semantic state colours unreachable — worth keeping in the Dart doc comment (it already is).

⚠ **Key-name mapping.** `ElIconTone.normal` must render as **`default`** (Dart reserves `default`). Same label-table requirement as §3.

---

## 5 · Section `#in-context` — "Icons in controls"

Description (verbatim): **"Inside a button an icon should inherit the button's colour, not assert its own. The one exception is a destructive action, where the error tone is the point."**

`Panel label="Correct pairings"`, body `div.flex.flex-wrap.gap-3` (12px). Five `Button`s.

**Button base** (`components/ui/button.tsx:28`, all five share it): `rounded-pill` (999px) · 1px **transparent** border · `bg-clip-padding` · `font-medium` (500) · `whitespace-nowrap` · `overflow-hidden isolate relative` · `btn-spring` transitions · `active:not-aria-[haspopup]:scale-95` · `focus-visible:border-ring focus-visible:ring-3 focus-visible:ring-ring/50` · `disabled:opacity-45` · and three SVG rules:

```
[&_svg]:pointer-events-none  [&_svg]:shrink-0  [&_svg:not([class*='size-'])]:size-4
```

⚠⚠ **The size override — the single most important rendering fact in this section.** `Icon` emits `width`/`height` **attributes**, and its `className` is `cn("shrink-0", ICON_TONES[tone], className)` — never containing the substring `size-`. So `[&_svg:not([class*='size-'])]:size-4` matches, and a CSS rule beats an SVG presentation attribute. **The four labelled buttons ask for `size="sm"` (14px) and render 16×16.** The `strokeWidth` attribute is *not* CSS, so it stays at the value computed for 14px — which is 2.4, and `strokeFor(16)` is also 2.4, so the two coincide and no stroke drift is visible. `size="icon"` sets only `size-10` and adds no SVG override, so the ghost button's `size="md"` icon renders at its own 16px. Net: **all five glyphs paint at 16px with stroke 2.4.**

(The same mechanism, in the opposite direction, is why `ElIcon.sizePx` exists — the overview page's `<Icon size="md" className="size-5">` comes out 20px carrying md's 2.4 stroke. See `icon.dart:107–119`.)

Size `default` = `h-10 gap-2 px-4 text-sm` → **40px tall, 16px horizontal padding, 8px icon-to-label gap, 13px label** (`--text-sm` is aliased to `--text-small` = 0.8125rem — **13px, not 14px**).

| # | markup | variant surface | icon |
|---|---|---|---|
| 1 | `<Button><Icon icon={PackageOpen} size="sm" tone="inherit" />Open Pack</Button>` | `sheen-action bg-primary text-primary-foreground shadow-btn-primary active:shadow-btn-down` — `--primary` = `--color-action` `hsl(217 91% 53%)` both themes, label `hsl(0 0% 100%)`, plus the `sheen-action` gradient + beat pseudo-elements | PackageOpen, 16px, stroke 2.4, `text-current` → white |
| 2 | `<Button variant="secondary">…Favourite` | `bg-secondary text-secondary-foreground hover:bg-accent aria-expanded:bg-accent` — dark `hsl(240 3.7% 15.9%)`, light `hsl(240 4.8% 95.9%)`; **no shadow** | Heart, 16px, 2.4, inherit |
| 3 | `<Button variant="outline">…Search` | `border-input bg-card text-foreground shadow-btn hover:bg-muted active:shadow-btn-down aria-expanded:bg-muted` | Search, 16px, 2.4, inherit |
| 4 | `<Button variant="destructive">…Remove` | `border-destructive/25 bg-destructive/10 text-destructive-ink hover:border-destructive/40 hover:bg-destructive/20 focus-visible:border-destructive/50 focus-visible:ring-destructive/25` — **a tint, not a fill**; `--destructive` `hsl(0 72.2% 50.6%)` in both themes, ink flips `#f87171` / `hsl(0 72.2% 46%)`; **no shadow** | Trash2, 16px, 2.4, inherit → destructive-ink |
| 5 | `<Button variant="ghost" size="icon" aria-label="Add to favourites"><Icon icon={Heart} size="md" tone="value" /></Button>` | `size-10` = **40×40 square, no padding**; `text-muted-foreground hover:bg-secondary hover:text-foreground active:bg-muted` — no fill at rest | Heart, 16px, 2.4, **`tone="value"` → `--value-ink`**, and the `Icon` carries **no `label`**, so it is `aria-hidden`; the name comes from the button's `aria-label` |

Labels verbatim, in order: **"Open Pack" · "Favourite" · "Search" · "Remove"**; button 5 has no visible label.

Button 5 is the section's own thesis stated twice: the accessible name lives on the *control*, not the glyph (matching the `label` Meta row), and `tone="value"` on a ghost button is the deliberate exception to "inherit inside buttons" — though the description names *destructive* as "the one exception", and the panel then ships a **value**-toned one instead. Record both; render as written.

**Motion** (`btn-spring`, globals.css:1886–1898): `transform, background-color, border-color, color, box-shadow, opacity` all at `--duration-base` **250ms** on `--ease-spring` `cubic-bezier(0.34,1.56,0.64,1)`; `:active` shortens to `--duration-tick` **80ms**. Plus `active:scale-95`.

---

## 6 · Section `#set` — "The curated set — 63 glyphs"

Heading is a template literal: `` `The curated set — ${ICON_COUNT} glyphs` `` where `ICON_COUNT` is `ICON_GROUPS.reduce((n,g) => n + g.icons.length, 0)` = **63** (21 + 19 + 11 + 12). Em dash.

Description (verbatim): **"Lucide ships well over a thousand icons; shipping all of them guarantees inconsistency. These are the ones the product uses, each pinned to one meaning so the same glyph never means two different things."**

Wrapper `div.space-y-4` → four `Panel`s, 16px apart. Each: `label={g.title}`, `note={`${g.icons.length} glyphs`}` (so the strip's right side reads `21 glyphs` / `19 glyphs` / `11 glyphs` / `12 glyphs` in mono 12px muted). Body:
- `p.type-small.mb-6` — the group blurb, 24px below.
- `div.grid.gap-px.overflow-hidden.rounded-lg.border.border-border.bg-border.sm:grid-cols-2.lg:grid-cols-3` — the **hairline grid**: the container is painted `--border` and the 1px `gap-px` shows through between `bg-background` cells; radius 12px; 1 col < 640, 2 at ≥640, 3 at ≥1024.
- Each cell `div.flex.items-center.gap-3.bg-background.p-4` (16px): tile `span.grid.size-9.shrink-0.place-items-center.rounded-md.border.border-border.bg-card` (36px, radius 10px) holding `Icon icon={entry.icon} size="lg" tone="muted"` (**20px, stroke 2.0, `--muted-foreground`**); then `span.min-w-0` with `span.type-num-sm.block.truncate.text-foreground` (the name — mono 12px, **`--foreground`**, and **`truncate`**: by arithmetic the longest name, `SlidersHorizontal` at 17 chars of 12px mono ≈ 118px, fits the ~208px cell text column at the 1440 frame — so the ellipsis should never fire; worth confirming against a render rather than trusting the estimate) and `span.type-small.block.leading-snug` (the use string, lh 1.375).

At the 1440 frame all four grids are 3-up, so the row counts are **7 / 7 / 4 / 4** and the last row of `navigation` and `actions` is full while `domain` (11) leaves one empty cell and `money-status` (12) is exactly full.

### 6.1 Group `navigation` — "Navigation & structure", note "21 glyphs"

Blurb (verbatim): **"Moving around the product. Directional glyphs only ever point the way they move."**

| # | name | use (verbatim) |
|---|---|---|
| 1 | Package | Packs — marketplace nav |
| 2 | Radio | Live Pulls — nav, live state |
| 3 | Layers | Stash — inventory nav |
| 4 | Gift | Rewards nav |
| 5 | Trophy | Leaderboard nav |
| 6 | Wallet | Wallet nav |
| 7 | User | Account nav, avatar fallback |
| 8 | Search | Search input and trigger |
| 9 | Bell | Notifications |
| 10 | Settings | Preferences |
| 11 | LogOut | Sign out |
| 12 | LayoutGrid | Grid view toggle |
| 13 | Rows3 | List view toggle |
| 14 | ChevronDown | Disclosure, select |
| 15 | ChevronUp | Disclosure open |
| 16 | ChevronLeft | Carousel back |
| 17 | ChevronRight | Carousel forward, breadcrumb |
| 18 | ArrowLeft | Back |
| 19 | ArrowRight | Forward, see all |
| 20 | Ellipsis | Overflow menu |
| 21 | ExternalLink | Leaves the product |

### 6.2 Group `actions` — "Actions", note "19 glyphs"

Blurb (verbatim): **"Things the user does. Destructive actions use only Trash2 and Ban."**

| # | name | use (verbatim) |
|---|---|---|
| 1 | PackageOpen | Open Pack — the primary action |
| 2 | ShoppingCart | Buy, add to cart |
| 3 | Heart | Favourite |
| 4 | Eye | Inspect card, show password |
| 5 | EyeOff | Hide password |
| 6 | Share2 | Share pull |
| 7 | Copy | Copy referral or address |
| 8 | Filter | Filter drawer trigger |
| 9 | SlidersHorizontal | Sort and advanced filters |
| 10 | Plus | Increase quantity, deposit |
| 11 | Minus | Decrease quantity |
| 12 | RefreshCw | Retry, refresh feed |
| 13 | Download | Withdraw, export |
| 14 | Upload | Deposit |
| 15 | Truck | Ship card |
| 16 | Trash2 | Delete — destructive only |
| 17 | Ban | Cancel, blocked — destructive only |
| 18 | X | Close, dismiss, clear |
| 19 | Check | Confirm, selected |

### 6.3 Group `domain` — "Collectible domain", note "11 glyphs"

Blurb (verbatim, and it is one string with an internal em dash — note the shouted `RARITY` and `NOT`): **"The product's own vocabulary. Note that RARITY is NOT here — the eight tiers use their own drawn marks (circle, diamond, star) in components/pulls/rarity-symbol.tsx, never a Lucide glyph."**

(The file path inside that sentence is plain text, **not** a `Code` chip — it renders in `.type-small`, not mono.)

| # | name | use (verbatim) |
|---|---|---|
| 1 | Sparkles | Reveal and reward moments |
| 2 | Crown | Leaderboard leader, top hit |
| 3 | Flame | Hot pack badge |
| 4 | Zap | New, turbo open |
| 5 | Star | Featured |
| 6 | Tag | Card set, category |
| 7 | Percent | Rarity odds |
| 8 | Medal | Rank badge |
| 9 | Activity | Popularity, volatility |
| 10 | TrendingUp | Rank up, value gain |
| 11 | TrendingDown | Rank down, value loss |

### 6.4 Group `money-status` — "Money & status", note "12 glyphs"

Blurb (verbatim): **"Wallet and state. Balance types are distinguished by glyph as well as by colour, so bonus never reads as real money."**

| # | name | use (verbatim) |
|---|---|---|
| 1 | CircleDollarSign | Available balance |
| 2 | CreditCard | Payment method |
| 3 | ArrowDownLeft | Money in — deposit, sale, refund |
| 4 | ArrowUpRight | Money out — purchase, withdrawal |
| 5 | Hourglass | Pending balance, pending withdrawal |
| 6 | Clock | Timestamp, time remaining |
| 7 | Lock | Locked reward, security setting |
| 8 | Shield | Security, provably fair |
| 9 | ShieldCheck | Verified account |
| 10 | Info | Information state |
| 11 | HelpCircle | Help, odds explainer |
| 12 | AlertTriangle | Warning state |

---

## 7 · Section `#rules` — "Rules" (no description)

`DoDont`: `div.grid.gap-4.sm:grid-cols-2` (16px, 2-up at ≥640).

- **Do panel**: `rounded-lg border border-value/25 bg-value/[0.06] p-5` (12px radius, 20px padding, 25%-alpha lime border over a 6% wash); heading `p.type-label.mb-3.text-value-ink` → **"Do"**; `ul.space-y-2.5` (10px); items `li.flex.gap-2.5` (10px) = `<Icon icon={Check} size="sm" tone="value" className="mt-0.5" />` (**14px, stroke 2.4, `--value-ink`, nudged down 2px**) + `span.type-small.text-muted-foreground`.
- **Don't panel**: same with `border-destructive/25 bg-destructive/[0.06]`; heading `text-destructive-ink` → **"Don't"**, written in source as `Don&rsquo;t` (curly apostrophe U+2019); icon `X`, `tone="error"` → `--destructive-ink`.

Dos (verbatim):
1. "Import Lucide glyphs through the Icon component so size, tone and labelling are enforced."
2. "Give every icon-only control a label — it becomes the accessible name."
3. "Use tone=\"inherit\" inside buttons so the icon follows the button's state." *(the escaped quotes are literal straight `"` in the rendered text: `Use tone="inherit" inside buttons…`)*
4. "Keep one meaning per glyph: Package is always a pack, Layers is always the Stash."

Don'ts (verbatim):
1. "Don't render a raw \<Icon icon={Search} /\> from lucide-react in a screen; go through Icon." — ⚠ **the copy contradicts itself**: it means the raw Lucide element (`<Search />`), but it typed `<Icon icon={Search} />`, which *is* the component it tells you to use. The `<` and `>` are literal text inside a JS string, so they render as visible angle brackets. Ship it as written; flag it in the port's doc comment.
2. "Don't mix icon sets — Lucide only, no Heroicons, no Font Awesome, no emoji as UI."
3. "Don't label a decorative icon; doubling the adjacent text makes screen readers repeat it."
4. "Don't reuse Trash2 or Ban for anything non-destructive."

(In all four Don'ts the leading apostrophe is a plain ASCII `'` inside a JS string — only the panel *heading* uses `&rsquo;`.)

**Closing `Note className="mt-4"`** — default tone, therefore `action`: `border-action/30 bg-action/[0.08] text-action-ink`, **no title**, so it is a single `div.type-small.text-muted-foreground` with an inline `Code` chip. Verbatim:

> "The set is defined in `lib/el/icons.ts`. Adding a glyph means adding it there with its single meaning — that file is the whitelist."

`Code` = `code.type-code.rounded-sm.border.border-border.bg-card.px-1.5.py-0.5.text-muted-foreground` — Geist Mono 12.5px/1.4, 6px/2px padding, **6px radius**, `--card` fill.

---

## 8 · Foot nav (`PageFootNav groupId="foundations" slug="icons"`)

**`icons` is index 5 of 6 in `foundations` — the last category.** `siblings("foundations","icons")` (nav.ts:605–615) resolves the group once and only ever indexes `group.categories[n]`, so:

```js
{ prev: { title: "Motion", href: "/design-system/motion" }, next: null }
```

**There is no fall-through to the next group.** `at(6)` reads `undefined` and the `c ? … : null` guard returns `null`.

`PageFootNav` returns `null` only when *both* sides are null, so it renders. `nav.mt-8.flex.items-stretch.gap-4.border-t.border-border.pt-8`:
- **Left — Previous**: `Link` to `/design-system/motion`, class `press flex min-w-0 flex-1 items-center gap-3 rounded-lg border border-border bg-card px-5 py-4 hover:border-input`; `Icon icon={ArrowLeft} size="md" tone="muted"` (**16px, stroke 2.4, muted**, `aria-hidden`); then `span.min-w-0` with `span.type-micro.block.text-muted-foreground` → **"Previous"** and `span.type-small.mt-1.block.truncate.text-foreground` → **"Motion"**.
- **Right — nothing**: a bare `<span className="flex-1" />`. Because it is `flex-1` and the row is `gap-4`, **the Previous card occupies exactly half the row (minus 8px) — it does not stretch.** This is the only asymmetric foot nav in the whole design system, and the only place the empty-slot branch is exercised by a real page. `example/test/nav_test.dart:121–125` already asserts the sibling result.
- `hover:border-input` is a visible hover on dark (`--input` `hsl(240 5.3% 26.1%)` vs `--border` `hsl(240 3.7% 15.9%)`) and **invisible on light**, where `--input` and `--border` are the same `hsl(240 5.9% 90%)`.

---

## 9 · Motion on this page

No entrance or keyframe animations on the page's own content. Everything that moves:

- **`press`** (foot-nav link, header logo): `transition: transform 250ms cubic-bezier(0.34,1.56,0.64,1)`; `:active { transform: scale(0.94); transition-duration: 40ms }` — 40ms in, springy 250ms out (globals.css:2277–2284).
- **`btn-spring`** on all five buttons — §5.
- **`sheen-action`** on button 1 only (globals.css:2090+): a 176° five-stop `linear-gradient` background, a `::before` radial "beat" ellipse (`mix-blend-mode` **multiply on light, screen on dark**, globals.css:3289–3295) that animates `action-beat` **2.6s `--ease-out` infinite on hover** and **620ms once on `:active`**, plus a static `::after` texture layer. **At rest, on a docs page nobody is hovering, only the linear gradient and the texture are visible.**
- **Foot-nav / button border+background hovers** ride their element's own transition (`press` covers `transform` only, so the foot-nav border change is instant; `btn-spring` covers `border-color`/`background-color`, so button hovers are 250ms).
- Anchor travel: smooth scroll, 96px `scroll-padding-block-start`; `prefers-reduced-motion: reduce` forces `scroll-behavior: auto !important`.
- The glyph tiles, the ladder and the 63-cell grids are **completely static** — no hover, no copy-to-clipboard, no click target anywhere in `#sizes`, `#tones` or `#set`.

---

## 10 · Color tokens used on this page (dark / light)

| token | dark | light |
|---|---|---|
| `--background` | `hsl(240 10% 3.9%)` | `hsl(0 0% 100%)` |
| `--card` | `hsl(240 5.9% 10%)` | `hsl(0 0% 100%)` |
| `--muted` | `hsl(240 3.7% 15.9%)` | `hsl(240 4.8% 95.9%)` |
| `--border` | `hsl(240 3.7% 15.9%)` | `hsl(240 5.9% 90%)` |
| `--input` | `hsl(240 5.3% 26.1%)` | `hsl(240 5.9% 90%)` |
| `--foreground` | `hsl(0 0% 98%)` | `hsl(240 10% 3.9%)` |
| `--muted-foreground` | `hsl(240 4.9% 83.9%)` | `hsl(240 4% 40%)` |
| `--secondary` | `hsl(240 3.7% 15.9%)` | `hsl(240 4.8% 95.9%)` |
| `--accent` | `hsl(240 5.3% 26.1%)` | `hsl(240 4.8% 95.9%)` |
| `--primary` / `--color-action` | `hsl(217 91% 53%)` #1A6EF4 | same |
| `--primary-foreground` | `hsl(0 0% 100%)` | same |
| `--action-ink` | `hsl(213 94% 78%)` #92C2FC | `hsl(224 76% 33%)` #143694 |
| `--color-value` | `#a3e635` | same |
| `--value-ink` | `#d9f99d` | `#4d7c0f` |
| `--success-ink` | `#10b981` | `#047857` |
| `--warning-ink` | `#fbbf24` | `#b45309` |
| `--info-ink` | `#22d3ee` | `#0e7490` |
| `--destructive` | `hsl(0 72.2% 50.6%)` | same |
| `--destructive-ink` | `#f87171` | `hsl(0 72.2% 46%)` |
| `--rim` / `--rim-strong` / `--ink-1..4` | shadow inks — see `spacing-map.md §4` | |

Radii used: `rounded-pill` 999 (buttons, chips) · `rounded-xl` 16 (Panels) · `rounded-lg` 12 (Meta, Note, DoDont cards, the `<pre>`, the glyph grids) · `rounded-md` **10** (the 36px glyph tiles) · `rounded-sm` 6 (`Code`).

---

## 11 · Drift register (copy vs code — both sides, for 1:1 port)

1. **Header chips vs sections.** `nav.ts` promises "Navigation set / Action set / Domain set"; the page has one `#set` section containing **four** panels (the fourth, "Money & status", is unchipped), and two chipless sections (`#in-context`, `#rules`). Chips are static `<li>`, so nothing is broken — but the Flutter `nav.dart` comment says "adding a string here is a commitment, not a label" (L342), which this reference entry does not honour.
2. **Icon size inside buttons.** `size="sm"` (14px attribute) is overridden to **16px** by `[&_svg:not([class*='size-'])]:size-4`, while `strokeWidth` stays at the 14px value. Invisible here only because `strokeFor(14) == strokeFor(16) == 2.4`.
3. **"The one exception is a destructive action"** — but the panel's actual tone override is `tone="value"` on button 5; the destructive button uses `tone="inherit"` like the rest.
4. **Don't #1 quotes the wrong thing**: `<Icon icon={Search} />` is the component the rule tells you to use. It means `<Search />`.
5. **Usage snippet imports `PackageOpen` but also uses `Heart`.** Illustrative text, ships incomplete.
6. **Note titles render muted, not tone-ink** (`.type-label`'s own `color` beats the inherited tone) — §2.3. The header *eyebrow* is the reverse case and does take action-ink, because there the colour is a utility on the element itself.
7. **`.type-code` sets no `font-weight`** — the `<pre>` and every `Code` chip render at the inherited weight (400), unlike every `.type-num*` class which is 600.
8. **`leading-relaxed` (1.625) overrides `.type-code` (1.4)** in the `<pre>` — utilities layer beats components layer.
9. **`subtle` and `muted` are the same colour**; the tones grid ships two identical swatches by design.
10. **`text-sm` is 13px, not 14px** (`--text-sm: var(--text-small)`), so the button labels are 13px.
11. **Fonts**: prose says Space Grotesk; tokens say Inter Local. Tokens win.
12. **Three curated names are deprecated lucide aliases** in 1.28.0 — see §12.3. `Filter`, `HelpCircle` and `AlertTriangle` are re-export shims; the geometry lives in `funnel.mjs`, `circle-question-mark.mjs` and `triangle-alert.mjs`.

---

## 12 · THE GLYPH LEDGER — how icons are drawn in the Flutter port, and what is missing

### 12.1 The current mechanism, precisely

There is **no icon font and no SVG asset**. Geometry is embedded as Dart data and stroked on a `Canvas`.

`lib\src\components\icon_paths.dart` (652 lines):
- `enum ElIconGlyph` — **8 members**: `menu, x, sun, monitor, moon, arrowLeft, arrowRight, check`.
- `sealed class ElIconElement` with **four** subclasses, one per lucide `__iconNode` node type:
  - `ElIconPathElement(String d)` — the `d` attribute character-for-character; parsed on every `addTo`.
  - `ElIconLineElement(x1, y1, x2, y2)` — `moveTo`/`lineTo`. (Constructor is point-then-point; lucide writes `x1, x2, y1, y2`, so the transcription reorders deliberately.)
  - `ElIconCircleElement(cx, cy, r)` — `Path.addOval`.
  - `ElIconRectElement(x, y, width, height, rx)` — `Path.addRRect`, uniform radius.
- `ElIconPaths.viewBox = 24`; `ElIconPaths.elements` is a `const Map<ElIconGlyph, List<ElIconElement>>`, in lucide's own element order (paint order **and** diff order against the `.mjs`).
- `ElIconPaths.pathFor(glyph)` returns a **fresh** `Path` per call — deliberate, because `Path` is mutable and a shared instance would let one painter corrupt every other icon.
- `_SvgPathParser` — a complete single-pass `d` reader implementing **`M m L l H h V v C c S s Q q T t A a Z z`**, with the two SVG rules that actually bite: optional separators (`1 1-9.473`, `.405-.022`) and sticky command letters with the implicit-lineto degradation (`M`→`L`, `m`→`l`). Arc flags are scanned **one character at a time** (`_flag()`), not as numbers, so packed `0 00-2.474` and `1 1-9.473` both parse. Elliptical arcs use endpoint→centre parameterisation per SVG 1.1 **F.6.5** with the out-of-range radii correction of **F.6.6**, split into ≤90° cubic segments with the `4/3·tan(θ/4)` construction, and the final segment lands on the caller's endpoint verbatim so float drift cannot open a hairline gap. Malformed data **throws** rather than recovering — the input is a const string in the repo, so a throw is a build-time transcription bug.

`lib\src\components\icon.dart`:
- `_GlyphPainter.paint` does `canvas.scale(size.width / 24, size.height / 24)` then **one** `canvas.drawPath` with a single `Paint`: `style = PaintingStyle.stroke`, `strokeCap = round`, `strokeJoin = round`, `strokeWidth` in **24-unit space** — exactly what an SVG `stroke-width` attribute is, and exactly what a browser does when it fits a `viewBox` into a smaller box.

### 12.2 Answer to the port question: **yes, the web's per-size stroke retune is fully portable — it already is ported**

This is the decisive advantage of path-drawn glyphs over a font. With an icon font the outline is baked at design time and stroke weight is not a free parameter; here it is a `Paint` field. Because the path is authored in 24 units and the canvas is scaled by `px/24`, a `strokeWidth` of 2.4 renders `2.4 × px/24` device px — bit-for-bit the browser's behaviour.

`ElIcon.strokeFor(double px)` (`icon.dart:157–162`) is a literal transcription of the ternary, including the three named constants `_heavyStroke 2.4 / _lightStroke 1.6 / _heavyAbove 2.6 / _lightBelow 1.5` and a doc comment explaining that the middle branch is a **literal 2**, not `48/px`. `test/components_test.dart:92–101` pins all seven rungs, and comments the `1.5 < 1.5 == false` edge at 2xl. `ElIcon.strokeOverride` exists for the theme toggle, which renders lucide's default stroke 2 at 14px rather than the formula's 2.4.

**Nothing in the stroke story needs work.** The gap is purely geometric.

### 12.3 What is missing: 59 of the 63 curated glyphs

**Present today: 4** — `ArrowLeft`, `ArrowRight`, `X`, `Check`. (`menu`, `sun`, `monitor`, `moon` are also embedded but are docs-chrome glyphs, not members of the curated 63.)

**Missing: 59.** All are in `design-system/node_modules/lucide-react/dist/esm/icons/`, lucide-react **1.28.0**, ISC — the same source `icon_paths.dart` and `icon_paths_test.dart` already name. The transcription recipe that produced this table:

```bash
node -e 'const s=require("fs").readFileSync("node_modules/lucide-react/dist/esm/icons/<file>.mjs","utf8");
         console.log(s.match(/const __iconNode = ([\s\S]*?\]);\n/)[1])'
```

`icon_paths.dart`'s own recorded decision — *"structure over stringification"* — means `line`/`circle`/`rect`/`polyline` nodes stay their own element types and are **not** rewritten into `d` strings. That decision is why this map names the module per glyph rather than duplicating 59 `d` strings here: a second transcription in a research file would be exactly the unverifiable copy the source file refuses to make. Transcribe from the `.mjs`, keep the lucide `key` as a trailing comment, and add the assertion to `icon_paths_test.dart`.

| status | name (`icons.ts`) | lucide module | elements | node types |
|---|---|---|---|---|
| **MISSING** | Package | `package.mjs` | 4 | 3 path, **1 polyline** |
| **MISSING** | Radio | `radio.mjs` | 5 | 4 path, 1 circle |
| **MISSING** | Layers | `layers.mjs` | 3 | 3 path |
| **MISSING** | Gift | `gift.mjs` | 4 | 3 path, 1 rect |
| **MISSING** | Trophy | `trophy.mjs` | 6 | 6 path |
| **MISSING** | Wallet | `wallet.mjs` | 2 | 2 path |
| **MISSING** | User | `user.mjs` | 2 | 1 path, 1 circle |
| **MISSING** | Search | `search.mjs` | 2 | 1 path, 1 circle |
| **MISSING** | Bell | `bell.mjs` | 2 | 2 path |
| **MISSING** | Settings | `settings.mjs` | 2 | 1 path, 1 circle |
| **MISSING** | LogOut | `log-out.mjs` | 3 | 3 path |
| **MISSING** | LayoutGrid | `layout-grid.mjs` | 4 | 4 rect |
| **MISSING** | Rows3 | `rows-3.mjs` | 3 | 1 rect, 2 path |
| **MISSING** | ChevronDown | `chevron-down.mjs` | 1 | 1 path |
| **MISSING** | ChevronUp | `chevron-up.mjs` | 1 | 1 path |
| **MISSING** | ChevronLeft | `chevron-left.mjs` | 1 | 1 path |
| **MISSING** | ChevronRight | `chevron-right.mjs` | 1 | 1 path |
| present | ArrowLeft | `arrow-left.mjs` | 2 | 2 path |
| present | ArrowRight | `arrow-right.mjs` | 2 | 2 path |
| **MISSING** | Ellipsis | `ellipsis.mjs` | 3 | 3 circle |
| **MISSING** | ExternalLink | `external-link.mjs` | 3 | 3 path |
| **MISSING** | PackageOpen | `package-open.mjs` | 4 | 4 path |
| **MISSING** | ShoppingCart | `shopping-cart.mjs` | 3 | 2 circle, 1 path |
| **MISSING** | Heart | `heart.mjs` | 1 | 1 path |
| **MISSING** | Eye | `eye.mjs` | 2 | 1 path, 1 circle |
| **MISSING** | EyeOff | `eye-off.mjs` | 4 | 4 path |
| **MISSING** | Share2 | `share-2.mjs` | 5 | 3 circle, 2 line |
| **MISSING** | Copy | `copy.mjs` | 2 | 1 rect (**with `ry`**), 1 path |
| **MISSING** | Filter | `filter.mjs` **→ `funnel.mjs`** | 1 | 1 path |
| **MISSING** | SlidersHorizontal | `sliders-horizontal.mjs` | 9 | 9 path |
| **MISSING** | Plus | `plus.mjs` | 2 | 2 path |
| **MISSING** | Minus | `minus.mjs` | 1 | 1 path |
| **MISSING** | RefreshCw | `refresh-cw.mjs` | 4 | 4 path |
| **MISSING** | Download | `download.mjs` | 3 | 3 path |
| **MISSING** | Upload | `upload.mjs` | 3 | 3 path |
| **MISSING** | Truck | `truck.mjs` | 5 | 3 path, 2 circle |
| **MISSING** | Trash2 | `trash-2.mjs` | 5 | 5 path |
| **MISSING** | Ban | `ban.mjs` | 2 | 1 circle, 1 path |
| present | X | `x.mjs` | 2 | 2 path |
| present | Check | `check.mjs` | 1 | 1 path |
| **MISSING** | Sparkles | `sparkles.mjs` | 4 | 3 path, 1 circle |
| **MISSING** | Crown | `crown.mjs` | 2 | 2 path |
| **MISSING** | Flame | `flame.mjs` | 1 | 1 path (**the only `q`/`t` in the set**) |
| **MISSING** | Zap | `zap.mjs` | 1 | 1 path (**packed arc flags `0 00-`**) |
| **MISSING** | Star | `star.mjs` | 1 | 1 path |
| **MISSING** | Tag | `tag.mjs` | 2 | 1 path, **1 circle with `fill="currentColor"`** |
| **MISSING** | Percent | `percent.mjs` | 3 | 1 line, 2 circle |
| **MISSING** | Medal | `medal.mjs` | 6 | 5 path, 1 circle |
| **MISSING** | Activity | `activity.mjs` | 1 | 1 path |
| **MISSING** | TrendingUp | `trending-up.mjs` | 2 | 2 path |
| **MISSING** | TrendingDown | `trending-down.mjs` | 2 | 2 path |
| **MISSING** | CircleDollarSign | `circle-dollar-sign.mjs` | 3 | 1 circle, 2 path |
| **MISSING** | CreditCard | `credit-card.mjs` | 2 | 1 rect, 1 line |
| **MISSING** | ArrowDownLeft | `arrow-down-left.mjs` | 2 | 2 path |
| **MISSING** | ArrowUpRight | `arrow-up-right.mjs` | 2 | 2 path |
| **MISSING** | Hourglass | `hourglass.mjs` | 4 | 4 path |
| **MISSING** | Clock | `clock.mjs` | 2 | 1 circle, 1 path |
| **MISSING** | Lock | `lock.mjs` | 2 | 1 rect (**with `ry`**), 1 path |
| **MISSING** | Shield | `shield.mjs` | 1 | 1 path |
| **MISSING** | ShieldCheck | `shield-check.mjs` | 2 | 2 path |
| **MISSING** | Info | `info.mjs` | 3 | 1 circle, 2 path |
| **MISSING** | HelpCircle | `help-circle.mjs` **→ `circle-question-mark.mjs`** | 3 | 1 circle, 2 path |
| **MISSING** | AlertTriangle | `alert-triangle.mjs` **→ `triangle-alert.mjs`** | 3 | 3 path |

**Total: 63 · present 4 · missing 59 · 162 elements to transcribe** — 123 `path`, 25 `circle`, 9 `rect`, 4 `line`, 1 `polyline`. (Counted from the package, not estimated.)

**Three deprecated aliases.** `filter.mjs`, `help-circle.mjs` and `alert-triangle.mjs` in 1.28.0 contain nothing but `export { default } from './<new-name>.mjs';`. The curated set still calls them by their old names, and `lucide-react` still exports `Filter`, `HelpCircle`, `AlertTriangle`, so the reference renders `funnel`, `circle-question-mark` and `triangle-alert` geometry under the old labels. **The Flutter enum should be named for the rendered glyph or for the curated name — but the transcript comment must cite the target module, or a future audit against `filter.mjs` will find an empty file.**

### 12.4 Four capability gaps in `icon_paths.dart` / `_GlyphPainter`

These are decisions, not transcriptions — the only places the implementer must add code rather than copy data.

1. **`polyline` is not implemented.** `Package` node 3 is `["polyline", { points: "3.29 7 12 12 20.71 7" }]`. `ElIconElement`'s own docstring already anticipates this ("lucide only ever emits `path`, `line`, `circle`, `rect`, `ellipse` and `polyline` nodes, and these four cover every glyph this package embeds. A new node type is a new subclass here, not a special case at the call site"). **Add `ElIconPolylineElement(List<Offset> points)`** → `moveTo` the first, `lineTo` the rest, **do not close** (that is `polygon`, which lucide does not emit). One glyph needs it; it is the file's own prescribed remedy.
2. **`fill` is not implemented, and one glyph needs it.** `Tag` node 2 is `["circle", { cx: "7.5", cy: "7.5", r: ".5", fill: "currentColor" }]` — a **filled** 0.5-unit dot. `_GlyphPainter` builds one `Path` and strokes it with one `Paint`. As written, Tag's dot would paint as a 1-unit-diameter ring stroked at 2 units — a blob roughly 5× its intended area, and visibly wrong at 20px. **This needs the element model to carry a fill flag and the painter to make two passes** (stroke the unfilled elements, fill the filled ones), which also means `pathFor` can no longer return a single `Path` for every glyph. This is the one genuine architectural change in the batch — scope it before starting, not after 58 transcriptions.
3. **`ry` on `rect` — the doc comment is now false.** `ElIconRectElement`'s docstring says *"lucide never sets `ry`, so SVG's '`ry` defaults to `rx`' rule applies"*. `copy.mjs` and `lock.mjs` both ship `rx: "2", ry: "2"`. Numerically harmless (`ry == rx`, so the uniform `Radius.circular(rx)` is still correct), but the comment must be corrected to *"lucide sets `ry` only where it equals `rx`"* and the transcript test should assert that equality rather than assume it.
4. **Closed subpaths arrive for the first time.** Twelve of the 59 carry `z`/`Z`: `Package, Layers, Trophy, PackageOpen, Filter, Sparkles, Crown, Zap, Star, Tag, Shield, ShieldCheck`. The parser handles `Z` correctly. But `test/icon_paths_test.dart:246–271` asserts *"`Z` closes the subpath — and nothing else does"* over a **named allowlist** of six glyphs, so it will not break — it just stops covering the new majority. More importantly, `icon_paths_test.dart:145–162` loops **every** `ElIconGlyph.values` and asserts `getBounds()` stays within `[−0.01, 24.01]`. `getBounds()` includes cubic **control** points, which bulge outside the drawn curve (moon already measures `left 2.9121` vs a sampled `2.9979`). Several arc-heavy glyphs reach the grid edge; **verify this assertion still passes before assuming it does**, and if it fails, widen it with the `_tightBounds` sampler the file already provides rather than by loosening the constant.

### 12.5 Parser coverage across the 59 (no parser work required)

Every command the curated set uses is already implemented **and** now exercised by real data:

| command | glyphs using it | note |
|---|---|---|
| `M` / `m` | 53 / 18 | universal |
| `L` / `l` | 13 / 18 | plus implicit-lineto repeats |
| `H` / `h` | 21 / 27 | |
| `V` / `v` | 16 / 26 | |
| `C` / `c` | 3 / 7 | `Bell`, `Shield`, `ShieldCheck`, `Heart`, `Copy`, `Flame`, `HelpCircle` |
| `Q` / `q`, `T` / `t` | **1** | `Flame` only — `q1 4 4 6.5t3 5.5`. The first real use of the quadratic + reflected-`T` branches, which until now had only synthetic tests |
| `A` / `a` | 37 | the bulk of the set; `Zap` packs its flags as `0 00-2.474`, which `_flag()`'s one-char scan handles |
| `Z` / `z` | 12 | §12.4.4 |
| `S` / `s` | **0** | implemented, still only synthetically tested |

---

## 13 · Exists / missing ledger for the port

### Already exists and needs no work

| thing | where |
|---|---|
| `ElIcon`, the 7-rung ladder, `pxFor`, the tone map, `colorFor`, `label`→`Semantics`/`ExcludeSemantics` | `lib\src\components\icon.dart` |
| `strokeFor` — the exact three-rung snap, pinned at all 7 rungs | `icon.dart:157`, `test\components_test.dart:92` |
| `sizePx` / `strokeOverride` escape hatches (needed for §5's 14→16 override if transcribed literally) | `icon.dart:107–128` |
| SVG `d` parser with full grammar + F.6.5/F.6.6 arcs | `icon_paths.dart:268–652` |
| All eight kit primitives: `ElPageHeader`, `ElSection`, `ElPanel` (with `label` **and** `note`), `ElMeta`, `ElCode`, `ElDoDont`, `ElNote`, `ElPageFootNav` | `example\lib\kit.dart` |
| `ElGrid(base:1, sm:2, lg:3)` — exactly the tones and set grids | `example\lib\kit.dart:814` |
| `icons` nav category, last in `foundations`, with the six chips verbatim | `example\lib\nav.dart` |
| `siblings('foundations','icons')` → `(prev: Motion, next: null)`, already asserted | `example\lib\nav.dart:731`, `example\test\nav_test.dart:121` |
| `ElPageFootNav` empty-slot branch (`SizedBox.shrink()` inside `Expanded`) | `example\lib\kit.dart:1062` |
| Theme fields for every colour in §10, incl. `primary`, `secondary`, `accent`, `destructive`, `successInk`/`warningInk`/`infoInk` | `lib\src\foundation\theme.dart` |
| `ElShadows.btn`, `.btnPrimary`, `.btnDown` | `lib\src\foundation\shadows.dart:204–237` |
| `ElPress` (250ms spring / 40ms in) and `ElThinScrollbar` | `lib\src\motion\press.dart`, `example\lib\shell.dart` |

### Missing — must be built

| # | thing | why the icons page needs it | size |
|---|---|---|---|
| 1 | **59 glyphs in `ElIconGlyph` + `ElIconPaths.elements`**, with 59 transcript assertions | §6 renders all 63; §3 needs `PackageOpen`; §4 needs `Search`; §5 needs `PackageOpen`, `Heart`, `Search`, `Trash2` | large, mechanical |
| 2 | **`ElIconPolylineElement`** | `Package` | tiny |
| 3 | **Fill support in the element model + `_GlyphPainter`** (two-pass paint) | `Tag`'s `fill="currentColor"` dot | small but architectural — see §12.4.2 |
| 4 | **`ElButtonVariant.primary` / `.secondary` / `.destructive`** | §5 buttons 1, 2, 4. `button.dart:28–36` currently has **only `outline` and `ghost`**, and its header says the other five "drop in later — they need `sheen-action` and `foil-value`" | medium |
| 5 | **`sheen-action`** — 176° 5-stop linear gradient + radial beat `::before` (multiply on light / screen on dark) + static texture `::after` | button 1 only; at rest only the gradient and texture show, the beat is hover/active | medium; can ship the gradient first and the beat later |
| 6 | **A multi-line code-block widget** (`<pre>`) | §2.1. `ElCode` is the **inline chip only** — there is no `pre` equivalent anywhere in `example\lib\kit.dart`. Needs: `ElType.code` at **1.625** leading (not `.type-code`'s 1.4), `--muted-foreground`, `--background` fill, 12px radius, 20px padding, horizontal scroll via the existing `ElThinScrollbar` | small |
| 7 | **`example\lib\pages\icons.dart`** + one `switch` arm in `main.dart` (`'$elRoot/icons' => const IconsPage()`) + the `import` | the page itself | medium |
| 8 | **Label tables** `ElIconSize → "xs".."3xl"` and `ElIconTone → "default".."inherit"` | §3 and §4 print the *key*, and Dart spells two sizes and one tone differently | tiny |
| 9 | **Test file `example\test\icons_page_test.dart`** + a route entry in `vertical_parity_probe_test.dart` and `wrap_parity_probe_test.dart` | every other ported page has one; the probes iterate a route map | medium |

**Build-order constraint:** items 2–3 change `ElIconElement`'s shape and `pathFor`'s return contract. Do them **before** item 1, or 59 transcriptions get rewritten.

**`token_guard_test.dart` applies — but read what it actually forbids.** `test\token_guard_test.dart` scans `lib` **and** `example/lib` as raw text, comments included, exempting only `lib/src/foundation/`. It is **not** a blanket numeric-literal scan: it is **nine specific patterns** — `Color(0x`, `Color.from`, `fontSize:\s*\d`, `letterSpacing:\s*-?\d`, `FontWeight.w\d`, `\bCurves.`, `Duration((milli|micro)seconds:\s*\d`, `BorderRadius.circular(\d`, `BoxShadow(`. Bare `0`/`0.0` and `elTransparent` are always legal; the escape hatch is `// allow-hardcoded: <reason>` on the line.

Consequence for this batch: **glyph coordinates are safe.** `ElIconCircleElement(12, 12, 4)` matches no rule, which is why `icon_paths.dart` carries **zero** `allow-hardcoded` markers today and why 162 new elements need none either. What *will* trip the guard in the new page is typography and chrome: use `ElType.*` rather than `fontSize:`/`letterSpacing:`/`FontWeight.w*`, `ElRadii.*` through the existing kit rather than `BorderRadius.circular(12)`, `ElShadows.*`/`ElMachineSurface` rather than `BoxShadow(`, `ElCurves.*` rather than `Curves.*`, and `ElDurations.*` rather than `Duration(milliseconds: 250)` — the last two matter for the `sheen-action` beat in item 5.

---

## 14 · Open questions (with recommendations)

**Q1 — What should the Usage code block say?** *(the brief's own question)*

The reference shows **its own API**: `import { Icon } from "@/components/ui/icon"`, `import { PackageOpen } from "lucide-react"`, `<Icon icon={PackageOpen} size="md" tone="inherit" />`.

**Recommendation: translate it to the Flutter API, and record the translation in the page's doc comment.** Reasoning, in the terms this project's fidelity bar already uses: "1:1" means the reference's own UI, copy and demos *translated* — and a code sample is the one element on the page whose entire job is to be **executable by the reader**. A Flutter developer reading `import { Icon } from "@/components/ui/icon"` learns nothing they can use; the block stops being documentation and becomes a screenshot of documentation. Every other specimen on this page is live (real glyphs, real strokes, real buttons); a TSX snippet would be the only dead one. The proposed text, preserving line count, blank lines, comment wording and the em dashes exactly:

```dart
import 'package:elattar_design_system/elattar_design_system.dart';

// Decorative — adjacent text already says "Open Pack",
// so the glyph is hidden from screen readers.
const ElIcon(ElIconGlyph.packageOpen, size: ElIconSize.md, tone: ElIconTone.inherit)

// Meaningful — icon-only control, so it must be named.
const ElIcon(ElIconGlyph.heart, size: ElIconSize.lg, tone: ElIconTone.value, label: 'Add to favourites')
```

Two consequences to accept deliberately: (a) the two-import head collapses to one (Dart has a barrel; there is no separate `lucide-react` package), so the block loses a line unless a filler is added — prefer losing the line to inventing an import; (b) `Heart` is imported implicitly, which quietly **fixes** the reference's missing-import bug (§11.5). Note the fix rather than reintroducing the bug.

The alternative — ship the TSX verbatim — is defensible only if the map's purpose is archival. Flag this for a human decision; it is the one place on this page where "verbatim" and "1:1" genuinely point in different directions.

**Q2 — Does the Flutter `ElIconGlyph` keep the curated *name* or the lucide *module* name for the three aliases?** `Filter`/`funnel`, `HelpCircle`/`circle-question-mark`, `AlertTriangle`/`triangle-alert`. **Recommendation: name the enum member for the curated name** (`filter`, `helpCircle`, `alertTriangle`) because §6 prints those strings and the whitelist is `icons.ts`; put the real module in the transcript comment so an audit finds the geometry. Same for `Rows3` → `rows3` (module `rows-3.mjs`) and `Share2`/`Trash2`.

**Q3 — Reproduce the 14px→16px button-icon override, or write 16px directly?** The reference *renders* 16px. **Recommendation: write `ElIconSize.md` (16px) and comment the reference's `size="sm"` + the CSS rule that overrode it.** `sizePx` is not needed here because the strokes coincide; reserve that hatch for the overview page's genuine 20px/2.4 mismatch.

**Q4 — Does `#set` need six anchors to satisfy the six nav chips?** The chips are static `<li>` in the reference and do not scroll (`colors-map.md §2`). The Flutter `nav.dart` comment insists `contents` is "a commitment, not a label". **Recommendation: render the chips as data, keep the six real sections (`component/sizes/tones/in-context/set/rules`), and record the mismatch in §11.1 as reference drift** — inventing three extra sections to satisfy a chip list would be a divergence, not a fidelity gain.

**Q5 — How much of `sheen-action` ships in v1?** Button 1's resting appearance is the linear gradient + static texture; the radial beat is hover/active only. **Recommendation: ship the gradient and texture, defer the `action-beat` keyframe**, and note it — this page is not the buttons page, and the shadows/motion pages will need the full effect anyway.

**Q6 — Do the two visually identical tone swatches (`muted` / `subtle`) get a comment in the port?** **Recommendation: yes** — `icon.dart` already documents why the names differ; the docs page should not look like a bug to a reader diffing screenshots.

**Q7 — Verify before trusting: does `icon_paths_test.dart`'s global `getBounds() ∈ [−0.01, 24.01]` assertion survive 59 new arc-heavy glyphs?** Not checked here (it needs a `flutter test` run against real geometry). §12.4.4 explains the failure mode. **Run it early, on a spike of three or four arc-heavy glyphs (`Star`, `Zap`, `Sparkles`, `Crown`), before transcribing the rest.**

**Q8 — Does the reference's `<pre>` ever actually scroll?** Computed above: no, not at the 1440 frame (longest line ≈ 535px in a 1016px box). **Recommendation: still build the scroller** — it is in the class list, and the Dart translation in Q1 has a 96-character line that *will* overflow.
