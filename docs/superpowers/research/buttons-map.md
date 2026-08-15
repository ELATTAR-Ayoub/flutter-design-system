# Map — `/design-system/components/base/buttons` (Base Components · Buttons)

**Files that produce the render** (all under `D:\DESIGN\Design-System-2026-8\design-system\`):

| file | role |
|---|---|
| `app\design-system\components\base\buttons\page.tsx` | the page — 399 lines, server component, **no page-local components, no module-level data**; one inline array literal at `:125–131` |
| `components\ds\kit.tsx` | `Code`, `DoDont`, `DsPageHeader`, `DsSection`, `Meta`, `Note`, `PageFootNav`, `Panel`, `Row`, `StateCell`, `StateGrid` — **11 of the kit's 13 exports**, the widest use on any page |
| `components\ui\button.tsx` | 146 lines — the whole point of the page |
| `components\ui\button-group.tsx` | 84 lines — `ButtonGroup`, `ButtonGroupText`, `ButtonGroupSeparator` |
| `components\ui\separator.tsx` | 29 lines — what `ButtonGroupSeparator` wraps |
| `components\ui\toggle.tsx` | 48 lines — client; Radix `Toggle` |
| `components\ui\toggle-group.tsx` | 105 lines — client; Radix `ToggleGroup` + the travelling pill |
| `components\ui\sliding-indicator.tsx` | 186 lines — client; `useSlidingIndicator` + `SlidingIndicator` |
| `components\ui\kbd.tsx` | 27 lines — `Kbd`, `KbdGroup` |
| `components\ui\spinner.tsx` | 12 lines — `loading`'s spinner |
| `components\ui\icon-swap.tsx` | client; the two-state icon wheel |
| `components\ds\icon-swap-demo.tsx` | client; `ViewSwitchDemo`, `PlayPauseDemo`, `FavouriteDemo`, `MuteDemo` |
| `components\ui\icon.tsx` | every glyph on the page |
| `lib\ds\nav.ts` `:131–145` (`buttons`), `:560–566` (group `base`) | eyebrow/title/blurb/chips + foot-nav siblings |
| `app\design-system\layout.tsx`, `app\globals.css`, `app\layout.tsx` | shell, tokens, fonts |

Read with **`shared-map.md`** (§1 shell + `SlidingIndicator`; §2 kit anatomy incl. `Row`/`StateGrid`/`StateCell`/`Meta`; §5 `Icon` + the full `Button` cva) and **`globals-map.md`** (§3b type tokens, §3d radii, §3f motion, §5 type classes, §7 utilities, §8 keyframes). **`icons-map.md`** owns the glyph ledger and the stroke ladder; **`shadows-map.md`** §4/§5.1–5.4 owns every `--shadow-*`, `sheen-action` and `foil-value`; **`motion-map.md`** §5/§6 owns `btn-spring`, `press`, `anim-jelly`. Nothing there is repeated here except where this page consumes it differently.

---

## 0 · What is different about this page

First **non-foundations** page in the port. Shell, sidebar, 1680/240/1080 frame, `--scroll-offset` 96px, fonts: all identical to `shared-map.md` §1. Three deltas only:

| # | delta |
|---|---|
| 1 | **Route nests two levels deeper** — `/design-system/components/base/buttons` (`categoryHref` sends non-foundations categories to `{group.href}/{slug}`, `nav.ts:586–590`). |
| 2 | **Eyebrow is composed, not literal** — `eyebrow={`${group.title} · Base`}` (`page:49`). Foundations pages pass a bare string. Result: **"Base Components · Base"** (drift 1). |
| 3 | **`Row`, `StateGrid`, `StateCell` render for the first time in the port's corpus.** `shared-map.md` §2 records them as "not used on the 4 audited pages". This page uses all three. |

Nine sections, in DOM order: `#variants` · `#sizes` · `#states` · `#icons` · `#groups` · `#toggle` · `#kbd` · `#api` · `#rules`. Every one is a bare `DsSection` (`mb-20`, heading block `mb-6`); **the page never passes `className` to `DsSection`**, and `#api` / `#rules` pass no `description`.

---

## 1 · Page header (`DsPageHeader`, `page:48–53`)

| slot | source | verbatim |
|---|---|---|
| eyebrow | `${group.title} · Base` | **Base Components · Base** |
| h1 | `category.title` | **Buttons** |
| blurb | `category.blurb` | **Every variant, size and state, including the lime premium action reserved for money and reward moments.** |
| chips (6) | `category.contents` | **Button · Button Group · Icon Button · Toggle · Toggle Group · Kbd** |

`·` in the eyebrow and between chips is U+00B7. Chip anatomy = `shared-map.md` §2. **The chip list is a contract**: `nav.dart:38–42` in the port states that `contents` renders as the chip row, so shipping these six commits the port to six real subjects — five of which do not exist yet (§15).

---

## 2 · Section `#variants` — "Variants" (`page:55–94`)

Description (verbatim):
> Seven variants, ordered by emphasis. Only one primary or premium button should be visible in any single decision area — if two compete, the user cannot tell what the screen wants.

`StateGrid cols={4}` → `grid gap-px overflow-hidden rounded-lg border border-border bg-border grid-cols-2 sm:grid-cols-4`. **12px radius, 1px `--border` frame, and every divider is a 1px gutter of `--border` showing between the opaque `bg-background` cells** — no per-cell borders exist. At ≥640px: 4×2. Below: 2×4.

`StateCell` = `bg-background p-5`; demo well `mb-4 flex min-h-14 items-center justify-center` (**56px minimum — exactly the `xl` button height**); label `type-micro text-center text-muted-foreground` (10.5px/1/600/upper/0.18em); note `type-caption mt-1.5 text-center` (10.5px/1.35/500, **same size as the label, separated only by case, weight, tracking and leading**).

Eight cells, DOM order:

| # | `label` | `note` | button | rendered label |
|---|---|---|---|---|
| 1 | `default` | Primary action. Blue. | `<Button>` | **Open Pack** |
| 2 | `premium` | Money & reward. Lime. | `variant="premium"` | **Deposit Funds** |
| 3 | `secondary` | Neutral, beside a primary. | `variant="secondary"` | **View Hits** |
| 4 | `outline` | Must not compete. | `variant="outline"` | **Filters** |
| 5 | `ghost` | Toolbars, dismissals. | `variant="ghost"` | **Skip** |
| 6 | `destructive` | Sell back, delete. | `variant="destructive"` | **Sell All** |
| 7 | `link` | Inline text action. | `variant="link"` | **Forgot password?** |
| 8 | `premium + caps` | Hero CTA treatment. | `variant="premium" emphasis="caps"` | **Claim Reward** |

All at `size="default"` (40px). Variants 1–5 are already resolved state-for-state in `shadows-map.md` §5.2 — do not re-derive. The two this page adds:

**6 · `destructive`** (`button.tsx:52–53`) — `border-destructive/25 bg-destructive/10 text-destructive-ink hover:border-destructive/40 hover:bg-destructive/20 focus-visible:border-destructive/50 focus-visible:ring-destructive/25`. A **tint, not a fill** (the JSDoc at `:47–51` gives the reason: white on the solid red measures 3:1). **No `box-shadow` of any kind** — it joins `secondary`, `ghost` and `link` as the four flat variants. `--destructive` is `hsl(0 72.2% 50.6%)` = `#DC2626` in **both** themes (`globals.css:596`/`:805`).

| state | fill | border | text | ring |
|---|---|---|---|---|
| rest | `--destructive` @10% = `rgba(220,38,38,0.10)` | `rgba(220,38,38,0.25)` | `--destructive-ink` (dark `#F87171` / light `#CA2121`) | — |
| hover | `rgba(220,38,38,0.20)` | `rgba(220,38,38,0.40)` | same | — |
| active | hover fill | hover border | same | `scale(0.95)`, 80ms |
| focus-visible | rest fill | **`rgba(220,38,38,0.50)`** | same | `0 0 0 3px rgba(220,38,38,0.25)` — **not the blue ring** |

**7 · `link`** (`button.tsx:55`) — `text-action-ink underline-offset-4 hover:underline`. No fill, no border colour, no shadow. Rest = `--action-ink` (dark `#92C2FC` / light `#143694`), no underline; hover adds `text-decoration: underline` at `text-underline-offset: 4px`. It still carries the whole base class, so it is **still a 40px-tall pill that scales to 0.95 on press and takes the blue focus ring** — a "text button" with a 16px horizontal padding box.

**8 · `premium + caps`** — `emphasis="caps"` = `text-num-sm font-semibold tracking-cta uppercase` (`button.tsx:73`). cva emits variant → size → emphasis, so tailwind-merge keeps the later class in each group:

| property | from size `default` | overridden by `caps` | final |
|---|---|---|---|
| font-size | `text-sm` 13px | `text-num-sm` | **12px** |
| weight | `font-medium` 500 → premium's `font-semibold` 600 | `font-semibold` | **600** |
| tracking | — | `tracking-cta` | **0.09em** |
| case | — | `uppercase` | **CLAIM REWARD** |

`Note tone="value" title="The lime button is rationed" className="mt-4"` (`page:89–93`). Body, verbatim, JSX whitespace collapsed, one `Code` chip:

> `premium` is the only variant permitted to glow, and only on hover. Use it for depositing, claiming, purchasing and confirming a withdrawal. A lime Cancel button would be a bug.

Tone `value` = `border-value/30 bg-value/[0.08] text-value-ink`. **Only the title takes the lime ink** — the body `<div>` re-declares `text-muted-foreground` (`kit.tsx:293`).

---

## 3 · Section `#sizes` — "Sizes" (`page:96–138`)

Description (verbatim, straight apostrophe in "product's"):
> 32 / 40 / 48 / 56, plus a 24px step for dense internals. This ladder is intentionally taller than stock shadcn — a premium product's primary action cannot be 32px.

`Panel label="The ladder"`, body `bg-background p-6`.

**Block A — `<Row align="end">`** = `flex flex-wrap gap-4 items-end` (16px both axes). Five children, each `<div className="text-center">` holding a Button plus `<p className="type-micro mt-3">`. Because the caption block is identical height across all five (12px + one 10.5px/1 line), aligning the **bottoms of the columns also aligns the bottoms of the buttons** — the ladder gets a shared baseline for free.

| # | `size` | button label | caption (verbatim) |
|---|---|---|---|
| 1 | `xs` | Extra small | xs · 24px |
| 2 | `sm` | Small | sm · 32px |
| 3 | *(default)* | Medium | default · 40px |
| 4 | `lg` | Large | lg · 48px |
| 5 | `xl` | Hero | xl · 56px |

**Block B** — `<div className="mt-6 space-y-2 border-t border-border pt-5">` (24px above, 1px rule, 20px inside, 8px between rows). Five `<p className="type-small">`, each `<span class="type-num-sm text-muted-foreground">{k}</span> — {v}` (the separator is a literal space + U+2014 + space):

| k | v (verbatim) |
|---|---|
| xs · 24px | Chips inside a combobox. Internal use only. |
| sm · 32px | Table row actions, card footers, filter chips. |
| default · 40px | The standard. Forms, dialogs, most actions. |
| lg · 48px | Primary action on a card or detail page. |
| xl · 56px | Landing hero and headline moments. Once per screen. |

### 3.1 · The nine-rung cva ladder, fully resolved (`button.tsx:57–69`)

Every value below is the resolved pixel, not the class. `--spacing` is 0.25rem.

| size | line | height | gap | px | `text-*` → token | px type | **line-height** | svg override | rendered on this page |
|---|---|---|---|---|---|---|---|---|---|
| `xs` | 59 | 24 | 4 | 10 | `text-xs` → `--text-num-sm` | **12** | **16.0** | `size-3` 12 | ✅ ladder |
| `sm` | 60 | 32 | 6 | 14 | `text-small` | **13** | *inherited* | `size-3.5` 14 | ✅ ladder |
| `default` | 61 | 40 | 8 | 16 | `text-sm` → `--text-small` | **13** | **18.571** | *(base `size-4` 16)* | ✅ ladder, variants, states, icons, groups |
| `lg` | 62 | 48 | 10 | 24 | `text-body` | **15** | *inherited* | *(base 16)* | ✅ ladder |
| `xl` | 64 | 56 | 10 | 32 | `text-base` → `--text-body` | **15** | **22.5** | `size-5` 20 | ✅ ladder |
| *(emphasis `caps`)* | 73 | — | — | — | `text-num-sm` | **12** | *inherited* | — | ✅ variants cell 8 |
| `icon-xs` | 65 | 24×24 | 0 | 0 | *(none — inherits)* | inherit | *inherited* | `size-3` 12 | ❌ **never rendered** |
| `icon-sm` | 66 | 32×32 | 0 | 0 | *(none)* | inherit | *inherited* | `size-3.5` 14 | ✅ `#icons` |
| `icon` | 67 | 40×40 | 0 | 0 | *(none)* | inherit | *inherited* | *(base 16)* | ✅ `#icons`, ×3 in `#groups` |
| `icon-lg` | 68 | 48×48 | 0 | 0 | *(none)* | inherit | *inherited* | `size-5` 20 | ✅ `#icons` |

**Page renders 8 of the 9.** The four `icon-*` rungs declare **no `gap-*`, no `px-*` and no `text-*`** — they are pure squares that inherit font-size from the page.

**Five text rungs, three distinct type sizes** (`globals.css:212–215` aliases Tailwind's scale onto this one): `sm` and `default` are both 13px; `lg` and `xl` are both 15px. Only `xs` is unique at the bottom. Drift 15.

**And only three of the six text classes carry a line-height at all.** globals.css repoints `--text-xs/sm/base/lg` but **does not** override the companion `--text-*--line-height` keys, so Tailwind's default *ratios* survive and get applied to the new sizes; the bespoke steps (`--text-small`, `--text-body`, `--text-num-sm`) have no companion key and emit `font-size` only. Verified against the compiled stylesheet, not inferred:

```
.text-xs   { font-size: var(--text-xs);   line-height: var(--tw-leading, var(--text-xs--line-height)) }   → calc(1/0.75)     × 12 = 16.0
.text-sm   { font-size: var(--text-sm);   line-height: var(--tw-leading, var(--text-sm--line-height)) }   → calc(1.25/0.875) × 13 = 18.571
.text-base { font-size: var(--text-base); line-height: var(--tw-leading, var(--text-base--line-height)) } → calc(1.5/1)      × 15 = 22.5
.text-small / .text-body / .text-num-sm   { font-size only — line-height inherits `normal` from the page }
```

**Practically inert on this page, deliberately recorded anyway.** Every button label is `whitespace-nowrap` inside an `items-center` flex box, so the line box is centred and half-leading is symmetric — the glyphs land in the same place either way. It matters if a port ever gives the label a container that sizes to the line box, and it is why `sm` and `default` (same 13px) are not actually the same text style. Drift 15.

### 3.2 · The size-ladder gap against the port

`lib\src\components\button.dart:90` — `enum DsButtonSize` has **four** members, and its own doc at `:86–89` says so.

| reference | port | verdict |
|---|---|---|
| `xs` | — | **missing** |
| `sm` | `DsButtonSize.sm` `:92` | exists |
| `default` | `DsButtonSize.md` `:95` | exists (**renamed** — `default` is a Dart keyword) |
| `lg` | — | **missing** |
| `xl` | — | **missing** |
| `icon-xs` | — | **missing** (not needed by this page) |
| `icon-sm` | `DsButtonSize.iconSm` `:101` | exists |
| `icon` | `DsButtonSize.icon` `:98` | exists |
| `icon-lg` | — | **missing** |

Existing resolvers, all `switch`-exhaustive so a new enum value breaks the build loudly: `heightFor` `:201–204`, `gapFor` `:211–215` (**exposed, not applied** — `DsButton` takes one `child`, so an icon+label caller builds its own `Row` and asks for the gap), `paddingXFor` `:218–222`, `isSquare` `:225–226`.

**The blocking gap is not the enum — it is type.** `button.dart:489–493` resolves **one** text style for every size: `DsText.styleOf(context, DsComponentType.buttonLabel, …)`. `xs` (12), `lg`/`xl` (15) and the `caps` emphasis (12 + 0.09em + uppercase) all need a per-size text dimension that does not exist. See open question 2.

---

## 4 · Section `#states` — "States" (`page:140–180`)

Description (verbatim):
> Hover, focus and active are live below — interact with them directly. Disabled and loading are shown as rendered.

`StateGrid cols={5}` → `grid-cols-2 sm:grid-cols-3 lg:grid-cols-5` — one clean row only at ≥1024px; 3+2 between 640–1023; 2+2+1 below.

| # | `label` | `note` | button | what actually renders |
|---|---|---|---|---|
| 1 | Default | *(none)* | `<Button>` | resting `default` |
| 2 | Hover | Hover it | `className="bg-action"` | **pixel-identical to cell 1** — `--primary: var(--color-action)` (`globals.css:582`/`:772`), so `bg-action` repaints the same `#1A6EF4`. Drift 13 |
| 3 | Focus | Tab to it | `className="border-ring ring-3 ring-ring/50"` | border → `--ring`, plus a `0 0 0 3px` ring at `--ring` @50% — a faithful **still** of focus-visible |
| 4 | Loading | Disabled, width held | `<Button loading>` | `Spinner` **prepended** to the label, `disabled`, `aria-busy` |
| 5 | Disabled | 45% opacity | `<Button disabled>` | `opacity-45` + `pointer-events-none` |

`Panel label="Live — press and hold, or tab through" className="mt-4"`; `<Row>` (16px, wrapping, centred) with six real buttons in order **Primary · Premium · Secondary · Outline · Ghost · Destructive** (variants `default, premium, secondary, outline, ghost, destructive` — `link` is absent). Caption `<p className="type-small mt-5">`, verbatim:

> Press scales to 97% over 150ms. Focus draws a blue ring that is never removed. Both behaviours are built into the variant base class, so no component has to remember them.

Three numbers, all contradicted by the code: **95%**, **80ms in / 250ms out** (drift 2).

### 4.1 · `loading` — full anatomy

`button.tsx:104, 120–127, 134–136`:

```
loading  → <Spinner /> is PREPENDED to children
         → disabled = disabled || loading
         → data-loading="" and aria-busy="true"
```

`spinner.tsx:5–9`:
```tsx
<Icon icon={Loader2Icon} data-slot="spinner" role="status" aria-label="Loading"
      className={cn("size-4 anim-spin", className)} {...props} />
```

| fact | value |
|---|---|
| glyph | lucide `Loader2Icon` |
| size | `size-4` — **explicit**, so it escapes the button's `[&_svg:not([class*='size-'])]` override; 16px in every button size |
| declared `Icon size` | `md` default → strokeWidth 2.4 |
| animation | `anim-spin` = `pulls-spin 0.9s linear infinite` (`globals.css:2407–2409`); `@keyframes pulls-spin { to { transform: rotate(360deg) } }` (`:2451–2453`). **`linear` on purpose** — the utility's comment says a spinner that eases looks like it is struggling |
| gap to label | the size's own `gap-2` = 8px |
| **width delta** | +16 (spinner) +8 (gap) = **+24px**. The button *does* jump. Drift 3 |
| a11y | `Icon` (`icon.tsx:68–74`) destructures only `{icon,size,tone,label,className}` and **drops `data-slot`, `role` and `aria-label`**; with no `label` it emits `aria-hidden="true"`. The spinner is silent to screen readers; `aria-busy` on the button is the only signal. Drift 4 |

---

## 5 · Section `#icons` — "Icons and icon-only buttons" (`page:182–228`)

Description (verbatim, straight apostrophe):
> An icon inside a button inherits the button's colour. An icon-only button must carry an accessible name, or it is unusable with a screen reader.

**`Panel label="With a label"`** — `<Row>`, four buttons, each `<Icon …/>` then a text node (order matters: icon leads):

| # | variant | glyph | `Icon size` | declared px | **rendered px** | label |
|---|---|---|---|---|---|---|
| 1 | `default` | `PackageOpen` | sm | 14 | **16** | Open Pack |
| 2 | `premium` | `Wallet` | sm | 14 | **16** | Deposit Funds |
| 3 | `secondary` | `Share2` | sm | 14 | **16** | Share Pull |
| 4 | `destructive` | `Trash2` | sm | 14 | **16** | Sell Selected |

All `tone="inherit"` → `text-current`. The 14→16 override is `[&_svg:not([class*='size-'])]:size-4` on the button base (`button.tsx:28`): `Icon` sets `width`/`height` as **attributes** and never emits a `size-*` class, so the CSS wins. `strokeWidth` is still computed from the *declared* 14 — invisible here only because `strokeFor(14) == strokeFor(16) == 2.4` (`icons-map.md` §2.3 + drift 2).

**`Panel label="Icon only" note="aria-label required" className="mt-4"`** — the page's **only** use of `Panel`'s `note` prop (renders right-aligned `type-num-sm text-muted-foreground` in the header strip).

| # | `size` | variant | box | `aria-label` | glyph | `Icon size`/tone | declared | rendered |
|---|---|---|---|---|---|---|---|---|
| 1 | `icon-sm` | ghost | 32×32 | Search packs | `Search` | sm / inherit | 14 | **14** ✓ |
| 2 | `icon` | outline | 40×40 | Add to favourites | `Heart` | md / inherit | 16 | **16** ✓ |
| 3 | `icon-lg` | *default* | 48×48 | Open pack | `PackageOpen` | lg / inherit | 20 | **20** ✓ |
| 4 | `icon` | ghost | 40×40 | Favourite this card | `Heart` | md / **value** | 16 | **16** ✓ |

Cell 4's glyph is `--value-ink` (dark `#D9F99D` / light `#4D7C0F`) — the one icon on the page that does not inherit its button's ink.

`aria-label` lands on the `<button>` element (spread through `{...props}`, `button.tsx:138`), **not** on the `Icon` — the `Icon` stays `aria-hidden`.

Caption `<p className="type-small mt-5">`, verbatim (`lime&rsquo;s` = U+2019):
> The last button uses the lime tone deliberately — a favourited card is a value signal, and that is one of lime’s permitted jobs.

---

## 6 · Section `#groups` — "Button Group" (`page:230–264`)

Description (verbatim):
> Joins related actions into one control. Used for view switching, quantity steppers and split actions.

`Panel label="Segmented actions"`; body `<div className="space-y-6">` (24px between the three groups).

### 6.1 · `ButtonGroup` anatomy (`button-group.tsx`)

**Root** (`:7–22, 24–38`) — `<div role="group" data-slot="button-group" data-orientation>`:

| class | line | effect |
|---|---|---|
| `group/button-group flex w-fit items-stretch` | 8 | shrink-to-fit row; **children stretch to the tallest** (this is what gives the height-less `ButtonGroupText` its 40px) |
| `*:focus-visible:relative *:focus-visible:z-10` | 8 | a focused member's ring paints over its neighbours |
| `has-[>[data-slot=button-group]]:gap-2` | 8 | 8px only when a group nests a group — **not triggered on this page, so gap is 0 and members are flush** |
| `[&>*:not(:first-child)]:rounded-l-none` | 13 | interior left corners squared |
| `[&>*:not(:first-child)]:border-l-0` | 13 | one hairline between neighbours instead of two |
| `[&>*:not(:last-child)]:rounded-r-none` | 13 | interior right corners squared |
| `[&>[data-slot]:not(:has(~[data-slot]))]:rounded-r-lg!` | 13 | **the last `data-slot` child is forced to `--radius-lg` 12px, `!important`** |

Net shape: **left end keeps the child's own radius (a `rounded-pill` Button ⇒ a 20px stadium on a 40px control); right end is always 12px.** Asymmetric by construction — drift 7.

**`ButtonGroupText`** (`:40–58`) — `flex items-center gap-2 rounded-lg border bg-muted px-2.5 text-sm font-medium [&_svg:not([class*='size-'])]:size-4`. No height (stretches), 12px radius, 10px horizontal padding, `--muted` fill, 13px/500. `border` has **no colour class** → `@layer base`'s `* { @apply border-border }` (`globals.css:945–947`) supplies `--border`. **It sets no `data-slot`** (drift 8), so the `rounded-r-lg!` rule reaches past it.

**`ButtonGroupSeparator`** (`:60–76`) — `Separator` with `orientation="vertical"` defaulted, `data-slot="button-group-separator"` (spread last, so it overrides `Separator`'s own `data-slot="separator"`). Resolved: `w-px` (**1px**) + `self-stretch` + `my-px` (1px inset top and bottom) + `bg-input` (dark `#3F3F46` / light `#E4E4E7`, beating `Separator`'s `bg-border`).

### 6.2 · The three groups as rendered

| group | members, in order | end radii |
|---|---|---|
| **A** `page:237–241` | `Button outline` **Newest** · `Button outline` **Price** · `Button outline` **Popularity** | left pill (20px stadium) / right 12px |
| **B** `page:243–253` | `ButtonGroupText` **Quantity** · `Separator` · `Button outline size=icon` `aria-label="Decrease quantity"` (`Minus` sm) · `ButtonGroupText className="type-num"` **3** · `Button outline size=icon` `aria-label="Increase quantity"` (`Plus` sm) | left 12px / right 12px |
| **C** `page:255–261` | `Button` (default variant) **Open Pack** · `Separator` · `Button size=icon` `aria-label="More open options"` (`ChevronDown` sm) | left pill / right 12px |

All three groups are 40px tall (`size="default"` and `size="icon"` are both `h-10`/`size-10`).

**`className="type-num"` on the "3" resolves to something other than `type-num`.** `.type-num` lives in `@layer components` (`globals.css:1018–1292`); `text-sm` and `font-medium` are utilities, and Tailwind v4 orders `theme → base → components → utilities`. tailwind-merge does not strip `type-num` (it is not a recognised Tailwind class), so both apply and the utilities win the two properties they share:

| property | `.type-num` | utility | wins |
|---|---|---|---|
| font-size | `--text-body` 15px | `text-sm` 13px | **13px** |
| font-weight | 600 | `font-medium` 500 | **500** |
| font-family | `--font-mono` | — | **Geist Mono** ✓ |
| `font-variant-numeric` | tabular-nums | — | **tabular** ✓ |
| letter-spacing | `--tracking-num` −0.01em | — | **−0.01em** ✓ |

Rendered: Geist Mono 13px/500/tabular/−0.01em. Drift 16.

The three icon buttons all pass `<Icon size="sm">` (14) into a `size="icon"` button whose base forces `size-4` — **rendered 16px**, same override as §5.

---

## 7 · Section `#toggle` — "Toggle & Toggle Group" (`page:266–322`)

Description (verbatim):
> For state that persists rather than actions that fire. View mode, favourite, and filter chips that stay on.

Title contains a literal `&` (`Toggle & Toggle Group`). Three panels.

### 7.1 · `Panel label="Toggle"` (`page:271–287`)

`<Row>` with three Radix `Toggle`s, each holding `<Icon icon={Heart} size="sm" tone="inherit" />`:

| # | props | `aria-label` |
|---|---|---|
| 1 | — | Favourite |
| 2 | `defaultPressed` | Favourite, on |
| 3 | `disabled` | Favourite, unavailable |

**`Toggle` anatomy** (`toggle.tsx:9–29`) — base at `:10`, resolved:

| class | value |
|---|---|
| `group/toggle inline-flex items-center justify-center gap-1` | 4px gap |
| `rounded-lg` | **12px** — *not* a pill |
| `text-sm font-medium whitespace-nowrap` | 13px / 500 |
| `transition-all` | **all properties, 250ms, `--ease-out`** (`--default-transition-duration`/`-timing-function`, `globals.css:395–396`). **Not `btn-spring`, and no `active:scale-*` — a Toggle has no press feedback.** Drift 11 |
| `outline-none` | kills the global `:focus-visible { outline: 2px solid var(--ring) }` (`globals.css:997–1000`) |
| `hover:bg-muted hover:text-foreground` | fill `--muted`; **the text half is inert** — the base sets no resting colour, so it already inherits `--foreground` via Preflight's `button { color: inherit }`. Drift 10 |
| `focus-visible:border-ring` | **inert on `variant="default"`** (`bg-transparent`, no border-width). Drift 10 |
| `focus-visible:ring-3 focus-visible:ring-ring/50` | `0 0 0 3px` at `--ring` @50% — the only focus affordance |
| `aria-pressed:bg-muted` + `data-[state=on]:bg-muted` | pressed fill = **`--muted`** (dark `#27272A` / light `#F4F4F5`) — **grey**. Drift 5 |
| `disabled:pointer-events-none disabled:opacity-50` | **50%**, not the Button's 45%. Drift 12 |
| `[&_svg:not([class*='size-'])]:size-4` | the `Heart` renders at **16px**, not the declared 14 |

Size `default` (`:18–19`): `h-8 min-w-8 px-2.5` → **32px tall, 32px minimum width, 10px horizontal padding** → 16 + 20 = **36×32** with a lone icon. (`sm` = `h-7 min-w-7 rounded-[min(--radius-md,12px)]` = 28px/10px radius; `lg` = `h-9` 36px. Neither is rendered.) `variant="outline"` (`:15`, `border border-input bg-transparent`) is not rendered either.

Caption `<p className="type-small mt-5">`, verbatim:
> Off · On · Disabled. The pressed state fills with the blue tint — selection is always blue.

### 7.2 · `Panel label="Toggle Group — three or more options" className="mt-4"` (`page:289–300`)

```tsx
<ToggleGroup type="single" defaultValue="newest">
  <ToggleGroupItem value="newest">Newest</ToggleGroupItem>
  <ToggleGroupItem value="price">Price</ToggleGroupItem>
  <ToggleGroupItem value="popular">Popular</ToggleGroupItem>
</ToggleGroup>
```

No `variant`, `size` or `spacing` passed → context defaults `spacing = 2`, and both `variant` and `size` are **`undefined`** on the root (so `data-variant`/`data-size` are omitted and `data-[size=sm]:rounded-…` never fires). Items fall back to `"default"`/`"default"` via `context.variant || variant` (`toggle-group.tsx:82–83, 88–89`).

**Root** (`:53–56`): `group/toggle-group relative flex w-fit flex-row items-center gap-[--spacing(var(--gap))] rounded-lg` with inline `style={{ "--gap": 2 }}` → **gap 8px**. `rounded-lg` is inert (no fill, no border, no `overflow-hidden`). `position: relative` is the pill's containing block.

**Item** (`:85–96`): the `spacing=0` segmented branch is entirely dormant here (`data-spacing="2"`), so what remains is `relative z-10 shrink-0 focus:z-10 focus-visible:z-10` + all of `toggleVariants(default/default)` + a **deliberately-last** `data-[state=on]:bg-transparent data-[state=on]:text-primary-foreground` (comment at `:91–93`: the pill is the background now, so the item gives up its own).

| item state | box | fill | ink |
|---|---|---|---|
| rest, unselected | 32px tall, `rounded-lg` 12px, `px-2.5` 10px, 13px/500 | none | `--foreground` (inherited) |
| hover, unselected | same | `--muted` | `--foreground` |
| **selected** | same | **transparent** (pill paints it) | `--primary-foreground` `#FFFFFF` |
| focus-visible | same | — | `0 0 0 3px` `--ring` @50%, `z-10` |

`relative z-10` on every item puts the whole row **above** the pill, which is rendered as the group's first child.

### 7.3 · The travelling pill on this ToggleGroup

`toggle-group.tsx:40–42` — the one call site on this page:

```tsx
const { containerRef, indicatorRef, jellyRef } = useSlidingIndicator(
  '[data-slot="toggle-group-item"][data-state="on"]',
)
```

| parameter | value here | source |
|---|---|---|
| `activeSelector` | **`'[data-slot="toggle-group-item"][data-state="on"]'`** — passed explicitly, narrower than the hook default | `toggle-group.tsx:41` |
| `arrivalAnimation` | **`"anim-jelly"`** (default) | `sliding-indicator.tsx:37` |
| `attributeName` | **`"data-state"`** (default) — **this is the watched attribute**; Radix writes `on`/`off` here | `sliding-indicator.tsx:52` |

Mechanism (`sliding-indicator.tsx:66–147`), condensed — full detail in `shared-map.md` §1:
1. `MutationObserver({attributes, subtree, attributeFilter:["data-state"]})` on the group + `ResizeObserver` on the group.
2. `getBoundingClientRect()` deltas (never `offsetLeft/Top`), minus container border, plus `scrollLeft/Top`; writes `width`, `height`, `transform: translate(x,y)`, `opacity` **inline**.
3. **Nothing selected → `opacity: 0`.** Radix `type="single"` permits deselecting by clicking the active item, so this fires on this page.
4. **First move: `transition: none` for one frame**, then restored — the pill appears in place, never flies in from the left.
5. **Every later arrival:** remove the arrival class → `void jelly.offsetWidth` (forced reflow) → re-add. That is the replay.

Pill DOM (`sliding-indicator.tsx:169–184`):
```
span[aria-hidden] .pointer-events-none .absolute .top-0 .left-0 .w-0 .opacity-0 .slide-pill   ← travels
└─ span .block .size-full .rounded-pill .bg-primary .shadow-chip                              ← jelly host
```

| layer | spec |
|---|---|
| travel | `slide-pill` (`globals.css:2256–2262`) — `transform`, `width`, `height` at **250ms `--ease-spring` cubic-bezier(0.34,1.56,0.64,1)**; `opacity` at **150ms `--ease-out`** |
| arrival | `anim-jelly` (`:2365–2367`) — `yuki-jelly 0.6s var(--ease-out) both`; stops `0 (1,1) · 30 (1.18,0.82) · 45 (0.88,1.12) · 60 (1.06,0.94) · 78 (0.98,1.02) · 100 (1,1)` (`:2431–2438`). **Runs concurrently with the travel, not after it.** |
| paint | fill `--primary` `#1A6EF4`, radius **999px → a 16px stadium on a 32px item**, `--shadow-chip` (`shadows-map.md` §4) |

**The pill is a stadium; the item it covers is a 12px rounded rect** — so hover-on-unselected and selected are two different shapes in the same slot. Drift 9.

Caption `<p className="type-small mt-5">`, verbatim:
> A toggle group is for three or more mutually exclusive options. With exactly two, use IconSwap below — a segmented control for a binary choice wastes space and reads as weaker than it is.

### 7.4 · `Panel label="IconSwap — the two-state control" className="mt-4"` (`page:302–321`)

Intro `<p className="type-small mb-6">`, verbatim:
> Every control that alternates between two icons swaps them through a vertical strip. Click each one: the icons are a physical wheel, so the old icon exits through the top and the next rises from below, landing with a jelly squash. No crossfades, no instant swaps — a control that changed meaning should show you that it changed.

Demo row `<div className="flex flex-wrap items-start gap-10">` — **40px** gaps, wrapping, top-aligned. Each demo is `<div className="flex flex-col items-center gap-3">` (12px between control and caption). All four start at strip index 0, so the first click always rolls **up**.

| # | demo | Button | box | glyph 0 → glyph 1 | `Icon size` | clip window | `aria-label` (off / on) | `aria-pressed` | caption (`type-micro`, uppercased by the class) |
|---|---|---|---|---|---|---|---|---|---|
| 1 | `ViewSwitchDemo` | `outline` `icon` | 40×40 | `LayoutGrid` → `Rows3` | md 16 | `size-5` 20px | Switch to list view / Switch to grid view | `view === "list"` | **View · grid** / **View · list** |
| 2 | `PlayPauseDemo` | *default* `icon-lg` | 48×48 | `Play` → `Pause` | lg 20 | `size-6` 24px | Play / Pause | **not used** | **Paused** / **Playing** |
| 3 | `FavouriteDemo` | `secondary` `icon` | 40×40 | `Heart` tone=subtle → `Heart` tone=value + `fill-value-ink` | md 16 | `size-5` 20px | Add to favourites / Remove from favourites | `on` | **Not favourited** / **Favourited** |
| 4 | `MuteDemo` | `ghost` `icon` | 40×40 | `Volume2` → `VolumeX` | md 16 | `size-5` 20px | Mute / Unmute | `muted` | **Sound on** / **Muted** |

**`IconSwap` API** (`components\ui\icon-swap.tsx`) — three props, no defaults: `active: string`, `icons: Record<string, ReactNode>`, `className?`. Strip order is the object's insertion order; `activeIdx = Math.max(0, keys.indexOf(active))` clamps an unknown key to 0.

Emitted DOM:
```
span .relative .inline-grid .place-items-center .overflow-hidden {className}    ← fixed clip window
└─ span[aria-hidden=!active] .col-start-1 .row-start-1 .inline-flex .items-center
        .justify-center .swap-roll {opacity-100|opacity-0}
        style="--swap-offset: {i - activeIdx}"                                   ← travels
   └─ span[key = active ? `landed-${idx}` : "waiting"] .inline-flex {anim-jelly if active}
           style={active ? {animationDelay: "var(--duration-fast)"} : undefined} ← squashes
      └─ {icons[key]}
```

Every icon shares **one grid cell** (`col-start-1 row-start-1`) and is `place-items-center`, so each strip cell's height is the **glyph's** height (16 or 20), not the window's.

**The motion is pure CSS.** No Framer Motion, no rAF; the only JS is a `useState` boolean per demo and React's key-remount trick.

`@utility swap-roll` (`globals.css:2265–2271`):
```css
--swap-offset: 0;
transform: translateY(calc(var(--swap-offset) * 160%));
transition:
  transform var(--duration-slow) var(--ease-spring),
  opacity   var(--duration-slow) var(--ease-spring);
```

| fact | value |
|---|---|
| travel per step | **160% of the strip cell's own height** → 16 × 1.6 = **25.6px** (demos 1/3/4), 20 × 1.6 = **32px** (demo 2) |
| duration | `--duration-slow` **400ms** |
| curve | `--ease-spring` cubic-bezier(0.34, 1.56, 0.64, 1) — peak ≈ **1.098** at ≈57% (≈229ms), i.e. the arriving glyph sails ~2.5px (md) / ~3.1px (lg) past centre before settling |
| direction | offset = `i - activeIdx`, negative **above**. Advance 0→1: leaver `0 → −160%` exits **through the top**, arriver `+160% → 0` **rises from below**. Reverse 1→0 is the genuine inverse — the strip rolls back down, not a replayed forward pass. |
| opacity | rides the **same** 400ms spring; because the curve exceeds 1 it clamps, reaching full at ≈147ms. So there *is* a ~150ms crossfade inside the roll. Drift 20 |
| squash | inner span only, active only, `anim-jelly` (600ms `--ease-out`) at **`animation-delay: var(--duration-fast)` = 150ms**. Replayed by flipping the React `key` (unmount/remount restarts the CSS animation). **It also fires on first mount** — every demo squashes once on page load. |

Timeline per swap: `t=0` roll starts → `t=150` squash starts → `t=400` roll settles → `t=750` squash ends.

Trailing `<p className="type-small mt-6">`, verbatim, three `Code` chips:
> Put `IconSwap` inside a Button as its child, and give the button an `aria-label` that describes what pressing it will do — plus `aria-pressed` when it is a toggle.

---

## 8 · Section `#kbd` — "Kbd" (`page:324–348`)

Description (verbatim):
> Keyboard hints. The product is fully keyboard navigable, so shortcuts are surfaced rather than hidden.

`Panel label="Shortcut hints"`; body `<div className="space-y-4">` (16px). Three `<Row>`s (16px gap, centred):

| # | keys | trailing `<span className="type-small">` |
|---|---|---|
| 1 | `KbdGroup`[ **Ctrl**, **K** ] | Open search |
| 2 | **Space** | Reveal next card |
| 3 | **Esc** | Skip the opening sequence |

**`Kbd`** (`kbd.tsx:3–14`) — a real `<kbd data-slot="kbd">`:

| class | resolved |
|---|---|
| `pointer-events-none … select-none` | inert to mouse and selection |
| `inline-flex h-5 w-fit min-w-5 items-center justify-center gap-1` | **20px tall, 20px minimum wide**, 4px inner gap |
| `rounded-sm` | **6px** (`--radius-sm`) |
| `bg-muted` | dark `#27272A` / light `#F4F4F5` |
| `px-1` | 4px |
| `font-sans text-xs font-medium` | Inter Local, **12px** (`--text-xs` → `--text-num-sm`), 500 |
| `text-muted-foreground` | dark `#D4D4D8` / light `#62626A` |
| `[&_svg:not([class*='size-'])]:size-3` | 12px glyphs — **no icon is used on this page** |
| `in-data-[slot=tooltip-content]:*` | tooltip-context recolour — not exercised |

**No border. No shadow.** Despite `--shadow-key` / `--shadow-key-down` / `press-key` existing for exactly this object (`shadows-map.md` §4) — drift 18.

**`KbdGroup`** (`:16–24`) — `inline-flex items-center gap-1` (4px), and it renders a **`<kbd>`** element while its prop type says `React.ComponentProps<"div">`, so a `<kbd>` nests two `<kbd>`s. Drift 19.

---

## 9 · Section `#api` — "API" (`page:350–375`, no description)

`Meta` (`kit.tsx:202–227`) — `<dl class="divide-y divide-border overflow-hidden rounded-lg border border-border bg-card">`; rows `grid gap-1 px-4 py-3 sm:grid-cols-[minmax(0,13rem)_1fr] sm:gap-4`; `<dt class="type-num-sm text-action-ink">` (Geist Mono 12/1.2/600/−0.01em) / `<dd class="type-small text-muted-foreground">` (13/1.5/400). Stacked below 640px, two-column above with a **208px** key track.

| `k` | `v` (verbatim) |
|---|---|
| `variant` | default · premium · secondary · outline · ghost · destructive · link. Default: default. |
| `size` | xs · sm · default · lg · xl · icon-xs · icon-sm · icon · icon-lg. Default: default. |
| `emphasis` | none · caps. Caps applies uppercase with 0.09em tracking, for headline and money CTAs. |
| `loading` | Adds a spinner, sets aria-busy and disables the button. The label stays so width does not jump. |
| `asChild` | Renders the child instead of a button — use for links that should look like buttons. |

All separators are U+00B7. The `size` row is the authority for the nine-rung ladder (§3.1) — and it lists `icon-xs`, which the page never renders.

---

## 10 · Section `#rules` — "Rules" (`page:377–394`, no description)

`DoDont` — anatomy in `shared-map.md` §2 (`grid gap-4 sm:grid-cols-2`; value-tinted Do panel with `Check` sm, destructive-tinted Don't panel with `X` sm). Takes `string[]`, so nothing inside is a `Code` chip. Apostrophes in the donts are **straight** `'`; the panel heading's `Don&rsquo;t` (U+2019) comes from the kit.

**Dos** (5, verbatim):
1. Keep one primary or premium button per decision area.
2. Use premium lime only for money and reward actions — deposit, claim, buy, withdraw.
3. Give every icon-only button an aria-label.
4. Use loading rather than swapping the label to 'Please wait' — the width stays stable.
5. Write labels as actions: Open Pack, Sell Selected, Request Withdrawal.

**Don'ts** (5, verbatim):
1. Don't put two blue buttons side by side; make the lesser one secondary or outline.
2. Don't use lime for Cancel, Back or Close.
3. Don't use the destructive variant for anything reversible.
4. Don't remove the focus ring, even when it looks heavy against lime.
5. Don't write vague labels like Proceed, Continue Process or Submit Action.

Do 4 restates the width claim that §4.1 disproves (drift 3).

---

## 11 · Foot nav (`PageFootNav groupId="base" slug="buttons"`, `page:396`)

`buttons` is **index 0** of the `base` category list (`nav.ts:131–145`), so `siblings()` (`:606–615`) returns `prev: null`.

| side | renders |
|---|---|
| Previous | **`<span className="flex-1" />`** — an empty flex spacer. This is the first page in the corpus with a one-sided foot nav. |
| Next | **"Inputs"** → `/design-system/components/base/inputs` |

Nav frame and link anatomy unchanged (`shared-map.md` §2).

---

## 12 · Motion inventory for this page

No entrance or scroll-triggered animation. Everything that moves:

| # | where | trigger | spec |
|---|---|---|---|
| 1 | every `Button` | any state change | `btn-spring` — 250ms `--ease-spring`; `:active` 80ms (`globals.css:1886–1898`) |
| 2 | every `Button` | active | `scale(0.95)` (no `aria-haspopup` anywhere on this page, so nothing is exempt) |
| 3 | `sheen-action::before` (7 `default` buttons) | hover / active | `action-beat` 2.6s ∞ / 620ms ×1 — `shadows-map.md` §5.3 |
| 4 | `foil-value::after` / `::before` (4 `premium` buttons) | always | `value-foil-drift` 11s linear ∞ + `value-glint` 5.5s ∞ (→2.4s on hover) — `shadows-map.md` §5.4 |
| 5 | `Spinner` (1) | always | `pulls-spin` 0.9s **linear** ∞ |
| 6 | `Toggle` ×3, `ToggleGroupItem` ×3 | any state change | `transition-all` 250ms `--ease-out` — **no press scale** |
| 7 | ToggleGroup pill — travel | selection change | `slide-pill` — transform/width/height 250ms `--ease-spring`; opacity 150ms `--ease-out` |
| 8 | ToggleGroup pill — arrival | selection change (not first paint) | `anim-jelly` — `yuki-jelly` 600ms `--ease-out`, **concurrent** with the travel |
| 9 | IconSwap strip ×4 | click | `swap-roll` — `translateY(offset × 160%)` + opacity, 400ms `--ease-spring` |
| 10 | IconSwap glyph ×4 | click **and first mount** | `anim-jelly` 600ms `--ease-out`, `animation-delay` 150ms |
| 11 | foot-nav link | active / hover | `press` (`scale(0.94)`, 40ms in) / `border-color` 250ms `--ease-out` |
| 12 | anchors | click | smooth scroll, 96px scroll-padding |

**The 8 Variants cells, the 5 Sizes cells, the 5 States cells, the 3 ButtonGroups and all 3 Kbds are static** apart from #1–#4. The "Hover" and "Focus" state cells are stills that also happen to be live (§4).

**Reduced motion** — `globals.css:2533–2548` collapses `animation-duration` and `transition-duration` to `0.01ms !important` for `*, *::before, *::after`. Neither `swap-roll` nor `anim-jelly` nor the foil is named in the escape list, so under `prefers-reduced-motion: reduce` the swap is instant, the pill teleports, and the foil freezes. The **150ms `animation-delay` is not collapsed** (only duration is), but with a 0.01ms squash it is invisible.

---

## 13 · Token reference for this page

Colours: every token this page paints is already tabulated in `shadows-map.md` §11.2 (`--background`, `--foreground`, `--card`, `--muted`, `--muted-foreground`, `--border`, `--input`, `--secondary`, `--accent`, `--primary`, `--primary-foreground`, `--ring`, `--action-ink`, `--value-ink`, `--destructive`, `--destructive-ink`, `--color-value-foreground`). Only two additions:

| token | dark | light | used by |
|---|---|---|---|
| `--color-action` | `#1A6EF4` | `#1A6EF4` | the `bg-action` "Hover" cell — **identical to `--primary`** (`globals.css:582`/`:772`) |
| `--color-value-bright` / `--color-value-dark` | `#D9F99D` / `#4D7C0F` | same | `fill-value-ink` on the favourited heart (via `--value-ink`, which flips) |

Type sizes (`globals.css:194–215`) — the aliasing that flattens the size ladder, and the line-height asymmetry it leaves behind:

| Tailwind class | token chain | px | emits `line-height`? | computed |
|---|---|---|---|---|
| `text-xs` | `--text-xs` → `--text-num-sm` | 12 | **yes** — Tailwind's `calc(1 / 0.75)` | 16.0 |
| `text-num-sm` | `--text-num-sm` | 12 | no | inherits `normal` |
| `text-small` | `--text-small` | 13 | no | inherits `normal` |
| `text-sm` | `--text-sm` → `--text-small` | 13 | **yes** — `calc(1.25 / 0.875)` | 18.571 |
| `text-body` | `--text-body` | 15 | no | inherits `normal` |
| `text-base` | `--text-base` → `--text-body` | 15 | **yes** — `calc(1.5 / 1)` | 22.5 |

Only the four *aliased* Tailwind steps keep a `--text-*--line-height` companion (globals.css overrides the sizes at `:212–215` and leaves the ratios alone); the six bespoke steps at `:194–203` have none.

Type classes used: `type-h1`, `type-h3`, `type-lead`, `type-chip`, `type-small`, `type-label`, `type-code`, `type-num-sm`, `type-micro` (all in `shadows-map.md` §11.3), plus two the corpus has not needed before:

| class | line | size | lh | weight | tracking | case |
|---|---|---|---|---|---|---|
| `type-caption` | 1151–1155 | `--text-micro` 10.5px | 1.35 | 500 | — | sentence |
| `type-num` | 1275–1278 (+1255 shared) | `--text-body` 15px | 1.2 | 600 | −0.01em | mono, tabular |

Radii: `--radius-sm` 6 (Kbd) · `--radius-lg` 12 (StateGrid, Meta, Toggle, ToggleGroupItem, ButtonGroupText, ButtonGroup right end) · `--radius-xl` 16 (Panel) · `--radius-pill` 999 (Button, sliding pill).

Motion tokens: `--duration-tick` 80 (`:398`) · `--duration-fast` 150 (`:399`) · `--duration-base` 250 (`:400`) · `--duration-slow` 400 (`:401`) · `--ease-spring` cubic-bezier(0.34,1.56,0.64,1) (`:420`) · `--ease-out` cubic-bezier(0.22,1,0.36,1) (`:421`) · `--tracking-cta` 0.09em (`:184`) · framework defaults repointed to 250ms/`--ease-out` (`:395–396`).

---

## 14 · Drift register (record, do not fix)

| # | drift |
|---|---|
| 1 | **The eyebrow says "Base" twice.** `eyebrow={`${group.title} · Base`}` (`page:49`) with `group.title = "Base Components"` (`nav.ts:561`) → **"Base Components · Base"**. Foundations pages pass one literal word. |
| 2 | **"Press scales to 97% over 150ms"** (`page:175`) vs `active:…scale-95` (95%) and `btn-spring`'s 80ms-in / 250ms-out. Three numbers, none correct. |
| 3 | **"the width stays stable" / "width does not jump" / "Disabled, width held"** (`page:158`, `:366`, `:383`; `button.tsx:112–113`) vs the prepended `Spinner`: **+16px glyph +8px `gap-2` = +24px**. Stated four times, false every time. |
| 4 | **The spinner is silent.** `Spinner` hands `data-slot`, `role="status"` and `aria-label="Loading"` to `Icon`, which destructures only `{icon,size,tone,label,className}` (`icon.tsx:68–74`) and drops the rest; with no `label` the glyph renders `aria-hidden="true"`. Only `aria-busy` survives. |
| 5 | **"The pressed state fills with the blue tint — selection is always blue"** (`page:284–286`) vs `data-[state=on]:bg-muted` (`toggle.tsx:10`) — the fill is `--muted`, **grey**. Blue selection is real one panel further down, and only there (the ToggleGroup pill's `bg-primary`). |
| 6 | **Icon size inside buttons** (carried from `icons-map.md` drift 2). `Icon size="sm"` (14px attribute) is forced to **16px** by `[&_svg:not([class*='size-'])]:size-4` in four `#icons` buttons and three `#groups` steppers, while `strokeWidth` keeps the 14px value. Invisible only because `strokeFor(14) == strokeFor(16) == 2.4`. |
| 7 | **ButtonGroup end radii are asymmetric.** `[&>[data-slot]:not(:has(~[data-slot]))]:rounded-r-lg!` (`button-group.tsx:13`) forces the trailing member to 12px while the leading member keeps its own radius — a `rounded-pill` Button leaves a 20px stadium on the left and a 12px box on the right (groups A and C). Group B is symmetric only because its first member is a `rounded-lg` `ButtonGroupText`. |
| 8 | **`ButtonGroupText` sets no `data-slot`** (`button-group.tsx:40–58`) while `Button` and `ButtonGroupSeparator` both do, so it can never satisfy the `rounded-r-lg!` selector and the rule reaches past it to the last Button. |
| 9 | **The ToggleGroup pill is `rounded-pill`; the item under it is `rounded-lg`.** Hover-on-unselected paints a 12px rounded rect; selection paints a 16px stadium. Two shapes, one slot. |
| 10 | **Three inert declarations on `Toggle variant="default"`**: `focus-visible:border-ring` and `aria-invalid:border-destructive` have no border-width to colour, and `hover:text-foreground` restates the colour the element already inherits (Preflight's `button { color: inherit }` — the base sets no resting ink). |
| 11 | **Two press feels on one page.** Button = `btn-spring` + `scale(0.95)` (asymmetric 80/250). Toggle and ToggleGroupItem = `transition-all` at the framework default 250ms `--ease-out`, **no scale at all**. |
| 12 | **Disabled opacity differs by component** — Button `disabled:opacity-45`, Toggle `disabled:opacity-50`. The States cell note says "45% opacity", which is true only of the Button three sections above the disabled Toggle. |
| 13 | **The "Hover" state cell does not show hover.** `className="bg-action"` repaints `#1A6EF4`, and `--primary` *is* `var(--color-action)` — pixel-identical to the "Default" cell. The real hover difference is `sheen-action::before` running `action-beat`, which fires only on true `:hover`. Its note ("Hover it") admits it is live, not a still. |
| 14 | **The "Focus" state cell reproduces the ring but not the transition.** `border-ring ring-3 ring-ring/50` is a correct still; a real `focus-visible` also runs `btn-spring`'s 250ms border transition. |
| 15 | **Five size rungs, three type sizes — and only three of six classes carry a line-height.** `sm`(13) == `default`(13) and `lg`(15) == `xl`(15) after `globals.css:212–215` aliases Tailwind's scale onto this one; only `xs`(12) is distinct. The alias repoints `--text-xs/sm/base/lg` but leaves the companion `--text-*--line-height` keys at Tailwind's ratios, while the bespoke steps (`--text-small`, `--text-body`, `--text-num-sm`) have no companion key at all — so `xs` gets 16.0, `default` 18.571, `xl` 22.5, and `sm`/`lg`/`caps` inherit `normal`. The ladder is a *height* ladder that changes type twice and leading three times, on different rungs. |
| 16 | **`ButtonGroupText className="type-num"` does not render as `type-num`.** `.type-num` is `@layer components`; `text-sm` and `font-medium` are utilities and win the cascade, so the "3" is Geist Mono at **13px/500**, not 15px/600. The mono family, tabular figures and −0.01em do survive. |
| 17 | **`icon-xs` is documented but never rendered.** Declared in the cva (`button.tsx:65`) and listed in the API `Meta` (`page:359`); the page shows 8 of the 9 sizes. |
| 18 | **`Kbd` is flat** — no border, no shadow, 6px radius, `bg-muted` — while `--shadow-key`, `--shadow-key-down` and the `press-key` utility exist for exactly this object and are documented one foundations page away. |
| 19 | **`KbdGroup` renders a `<kbd>`** while typed as `React.ComponentProps<"div">` (`kbd.tsx:16–18`), producing `<kbd><kbd>Ctrl</kbd><kbd>K</kbd></kbd>`. |
| 20 | **"No crossfades, no instant swaps"** (`page:306–307`) vs `swap-roll`'s `transition: … opacity var(--duration-slow) var(--ease-spring)` — there *is* an opacity ramp; the spring curve just clamps it to full at ≈147ms of the 400ms roll. |
| 21 | **`swap-roll`'s comment is not a comment.** `globals.css:2264` opens with `\*` (backslash) instead of `/*`; same at `:2372` and `:2379`. The malformed rule is discarded by the parser, so the utilities below still work — but three "comments" in the file are live garbage rules. |
| 22 | **`emphasis="caps"` shrinks the type.** `text-num-sm` drops a `default`-size button from 13px to **12px** — and cell 8 sits in the same 4-up grid as seven 13px buttons. |
| 23 | **`PlayPauseDemo` omits `aria-pressed`** while the panel's own closing copy (`page:319`) says to add it "when it is a toggle" — and the demo's caption reads "Playing"/"Paused", which is state. Framed as an action; reads as a toggle. |
| 24 | **`--shadow-btn`'s use copy names "Secondary, outline and destructive buttons"** (`shadows-map.md` drift 1). This page is where it is most visible: in one 8-cell grid, `outline` is a machine surface and `secondary`, `destructive`, `ghost` and `link` are flat. |

---

## 15 · Exists in the port / missing

Package root `D:\DESIGN\Design-System-2026-8\flutter-design-system\`.

### 15.1 · Exists — reuse, do not re-derive

| need | where |
|---|---|
| **All seven variants** | `DsButtonVariant` (`lib\src\components\button.dart:38`) — `primary` :45 (renamed from `default`), `premium` :50, `secondary` :57, `outline` :63, `ghost` :68, `destructive` :77, `link` :83. Guarded by `test\components_test.dart:503` ("all seven cva variants, in source order"). |
| Variant paint + state table | `_ButtonSkin` :133, `_skin` :294–390, `_surface` :425–463 (`DsSheenAction` primary, `DsFoilValue` premium, `DsMachineSurface` for the other five), `_SpringColors` :579–617 |
| Press scale | `DsPress(scale: DsTransforms.buttonScale = 0.95)` :531–537, `tick` down / `base` up; tested `components_test.dart:274` |
| Focus ring, Tailwind slot order | `DsButton.withFocusRing(spec, ring)` :241–245, `_focusBorder` :394–397; spread 3 (:109), alpha 0.50 (:112), destructive overrides 0.50/0.25 (:124–125). **`DsInput` already consumes it** (`input.dart:214–217`) |
| Real `:focus-visible` + keyboard activation | `Focus` :554–560, `_onKey` :276–284 (Enter / NumpadEnter / Space) |
| Icon-only + accessible name | `size: icon|iconSm` + `label:` → `Semantics(button:, label:)` :567–568; square layout :470, :516–529 |
| Disabled | `_enabled` :256 → `Opacity(0.45)` + `IgnorePointer` :562–565 |
| Semibold on premium only | `_applySemibold` :405–416, `_semiboldWght` :129 |
| **Travelling pill substrate** | `DsSlidingPillGroup` (`lib\src\motion\sliding_pill.dart:33`) — `activeIndex` (**−1 or out-of-range hides the pill**, :44–45, :161–167, :196), `pill`, `children`, `padding`, `gap`. `AnimatedPositioned` :183–192 (250ms `DsCurves.spring`, `Duration.zero` before `_placed`), `AnimatedOpacity` :194–198 (150ms `DsCurves.out`), jelly controller :81–84 + `_replayJelly` :121–124 (**skipped on first placement**) + `Transform.scale` :199–208. Measures post-frame (`_measure` :132–151) in place of the web's Mutation/Resize observers. Library doc :1–21 cites `sliding-indicator.tsx`, `slide-pill` (`globals.css:2256`) and `yuki-jelly` (`:2431–2438`). |
| `yuki-jelly` keyframes, transcribed | `DsJelly` (`lib\src\motion\keyframes.dart:435–450`), `duration = DsDurations.animJelly` 600ms |
| Durations / curves / transforms | `lib\src\foundation\motion.dart` — `tick` 80 :18, `fast` 150 :21, `base` 250 :27, `slow` **400** :30, `animJelly` 600 :71, `buttonScale` 0.95 :192; `DsCurves.spring` :211, `.out` :216 |
| Reduced-motion gate | `dsAnimationDuration(context, d)` (`lib\src\theme_scope.dart:332`) — already threaded through `sliding_pill.dart:175, 184` |
| Docs kit — prose/reference primitives | `example\lib\kit.dart` — `DsPageHeader` :54, `DsSection` :148, `DsPanel` :242, `DsMeta` :390 (+ `DsMetaItem` :383), `DsCode` :448 / `DsCode.span` :514 / `DsCodeBlock` :663, `DsDoDont` :735, `DsNote` :834 (+ `DsNoteTone` :831), `DsGrid` :908, `DsPageFootNav` :1156 |
| Nav entry, character-for-character | `example\lib\nav.dart:193–206` — slug `buttons`, title, blurb and all six `contents` chips already match `nav.ts:133–145`. Group `base` at :648–655; all 14 base categories present. **No nav work needed.** |
| Shadows the page needs | `DsShadows.btn / btnPrimary / btnValue / btnDown / chip` (`lib\src\foundation\shadows.dart`) |

### 15.2 · Missing — must be built

| # | missing | notes |
|---|---|---|
| 1 | **5 of 9 button sizes** — `xs`, `lg`, `xl`, `icon-xs`, `icon-lg` | Enum `:90`; add to `heightFor` :201, `gapFor` :211, `paddingXFor` :218, `isSquare` :225. All four are exhaustive switches, so the compiler lists the work. |
| 2 | **Per-size button type** | `button.dart:489–493` resolves one `DsComponentType.buttonLabel` for every size. Needs 12 / 13 / 15 by rung, plus the `caps` treatment (12px + 600 + 0.09em + uppercase). |
| 3 | **`emphasis`** | No third axis on `DsButton` at all. `--tracking-cta` 0.09em has no port token. |
| 4 | **`loading` + a spinner** | No `loading` param, and **no spinner widget anywhere in the repo**. Needs `pulls-spin` 0.9s **linear** ∞ on a 16px `Loader2` glyph, prepended before the child, forcing disabled + `Semantics(… busy?)`. `Loader2` is very likely among the 59 glyphs `icons-map.md` §12.3 lists as missing from `icon_paths.dart` — check before building. |
| 5 | **`asChild`** | No child-render delegation, no link affordance. `DsButtonVariant.link` (:83) is paint-only and still requires `onPressed`. Only needed if the API section must be truthful. |
| 6 | **`ButtonGroup` / `ButtonGroupText` / `ButtonGroupSeparator`** | Nothing exists. Needs: flush row, stretch-to-tallest, per-position corner squaring **with the asymmetric `rounded-r-lg` end** (drift 7), single-hairline joins (`border-l-0`), 1px `--input` separator inset 1px vertically, and a `--muted` text cell. |
| 7 | **`Toggle`** | Nothing exists. 32×32 min, 12px radius, `--muted` pressed fill, 250ms `--ease-out` on everything, **no press scale**, 50% disabled, 3px focus ring. |
| 8 | **`ToggleGroup` / `ToggleGroupItem`** | Nothing exists. `DsSlidingPillGroup` is the substrate but is **not** a toggle group — no selection semantics, no roving focus, no roles, no per-item styling. Its only consumer today is `example\lib\theme_toggle.dart:52/:70`. Needs: 8px gap, item ink flip to `--primary-foreground` when selected, pill = `--primary` + `DsRadii.pill` + `DsShadows.chip`, and **deselect → `activeIndex: -1`** (already supported). |
| 9 | **`Kbd` / `KbdGroup`** | Nothing exists. 20px tall, 20px min, 6px radius, `--muted`, 12px/500 Inter, muted ink, no border, no shadow. |
| 10 | **`IconSwap`** | Nothing exists (`swap-roll` has no port equivalent either). Needs a fixed clip box, a stacked strip translated by `offset × 160%` of the **glyph's** height on 400ms `DsCurves.spring`, opacity on the same curve, and `DsJelly` on the arriving glyph at a **150ms delay** — replayed on every change *and on first mount*. |
| 11 | **Docs `Row`** | `example\lib\kit.dart` has none; pages inline `Wrap(spacing: ds(3), runSpacing: ds(3))` by hand (`icons.dart:745–747`, `shadows.dart:~408`). This page needs `align: end` for the size ladder. Promote to the kit. |
| 12 | **Docs `StateGrid` / `StateCell`** | Missing. Private prototypes exist and should be **promoted, not re-forked**: `_HairlineGrid` (`example\lib\pages\icons.dart:921`) is already the `gap-px` lattice; `_EntryCell` (`icons.dart:956`) is close to a cell. Needs the `cols: 4` and `cols: 5` responsive maps, the 56px `min-h-14` demo well, and `type-caption` for the note. |
| 13 | **`type-caption` and `type-num` in `DsType`** | Confirm both exist in `lib\src\foundation\typography.dart`; the corpus has not needed either before. |
| 14 | **`example\lib\pages\buttons.dart` + a `main.dart` arm** | `pageFor` (`example\lib\main.dart:100–106`) has arms only for overview / colors / typography / spacing. **`shadows`, `motion` and `icons` pages exist on disk and are also unrouted** — same debt, three pages deep. `shell_test.dart:228–230` only asserts `pageFor(...)` is `isNotNull`, which a `PlaceholderPage` satisfies, so nothing fails today. |
| 15 | **`_referenceHeight['buttons']`** | `example\test\vertical_parity_probe_test.dart:45–50` has exactly four keys (`overview` 2402.66, `colors` 3781.83, `typography` 6039.94, `spacing` 4159.36). Must be measured off the live dev server at 1440×900 / DPR 1. |
| 16 | **`_referenceBreaks['buttons']`** | `example\test\wrap_parity_probe_test.dart:183–367`, same four keys. It is a **closed inventory**: an absent paragraph is asserted to be single-line (:443–451) and every table key must be seen (:465–471). This page has ~20 paragraphs plus 13 StateCell notes — expect a large table. |
| 17 | Page test | Model on `example\test\spacing_page_test.dart`. |

### 15.3 · Guard constraints

`test\token_guard_test.dart` rules at `:40–53` — forbidden outside `lib\src\foundation\`: `Color(0x`, `Color.from`, `fontSize:<digit>`, `letterSpacing:<digit>`, `FontWeight.w<digit>`, `Curves.`, `Duration((milli|micro)seconds:<digit>`, `BorderRadius.circular(<digit>`, `BoxShadow(`. Escape hatch `// allow-hardcoded: <reason>` on the line (:86).

Consequences specific to this page:
- **The guard is a raw text scan including comments and string literals** (:13–15). The API `Meta` values and any `DsCodeBlock` sample are plain strings, so they are safe — but a code sample containing `Duration(milliseconds: 250)` or `BorderRadius.circular(12)` would trip it.
- `160%` (swap-roll travel), `0.09em` (caps tracking), `0.9s` (spinner) and the `--text-*` rungs 12/13/15 must all reach the widget through `lib\src\foundation\` constants, not literals.
- The ToggleGroup pill's radius must be `DsRadii.pill`, the item's `DsRadii.lg`, the Kbd's `DsRadii.sm`.

---

## 16 · Open questions (with recommendations)

1. **Section scope vs the chip contract.** The six chips promise Button, Button Group, Icon Button, Toggle, Toggle Group, Kbd; the page also renders an **IconSwap** panel that no chip mentions. Build all nine sections including IconSwap (it is a third of §7 and carries load-bearing copy), or stage it? **Recommend: all nine.** The chips are a subset of the page in the reference too, and dropping IconSwap would orphan two paragraphs of copy that reference it by name.
2. **Size ladder + per-size type.** Missing sizes are cheap (four exhaustive switches); **per-size type is the real work** and touches `typography.dart`. Add `DsComponentType.buttonLabelXs/Sm/Md/Lg/Xl` + a `caps` variant, or give `DsButton` a resolved `TextStyle` per size inside `button.dart` with the sizes declared in `foundation`? **Recommend: extend `DsComponentType`** — the guard forbids `fontSize:` outside `foundation` anyway, so the sizes have to live there regardless; putting the whole style there keeps one owner.
3. **Build `icon-xs`?** Never rendered, but the API `Meta` lists it verbatim and the reference cva declares it. **Recommend: build it.** Nine-of-nine costs one enum value and four switch arms, and it makes the printed API row true.
4. **`asChild`.** No Flutter analogue and no router in the example app. **Recommend: do not build.** Keep the `Meta` row verbatim (the fidelity bar says translate the reference's own copy, drift included) and record the divergence rather than inventing a link API for a docs page.
5. **The `loading` spinner glyph.** `Loader2` is not in the port's curated 63 (`icons-map.md` §12.3 lists 59 glyphs still to add). Is `Loader2` among the missing, and should it be pulled forward as part of this page or waited for? **Recommend: pull it forward** — one glyph, and the States section cannot render without it.
6. **`Toggle`/`ToggleGroup`: real interaction or specimens?** The section description says the states "persist"; the page's toggles are genuinely clickable. **Recommend: real.** Both are small, and a dead ToggleGroup would make the sliding pill — the one piece already built — untestable on the page it belongs to.
7. **ToggleGroup deselection.** Radix `type="single"` lets a click on the active item clear the selection, and `DsSlidingPillGroup` already handles that via `activeIndex: -1`. Mirror the deselect, or lock the group to one-always-selected? **Recommend: mirror.** The port's substrate documents the −1 case explicitly (`sliding_pill.dart:44–45`), so mirroring costs nothing and exercises a path that is otherwise dead.
8. **The two static state cells.** "Hover" is pixel-identical to "Default" (drift 13) and "Focus" is a hand-drawn ring. Reproduce the classes exactly — including the no-op — or make them show what they name? **Recommend: reproduce exactly.** The fidelity bar is the reference's own UI translated, drift included; the drift register is where the observation lives.
9. **The spinner's a11y hole (drift 4).** Flutter has no equivalent of "props silently dropped by a destructure" — the port must *choose* whether the spinner is announced. **Recommend: mirror the web** (spinner excluded from semantics; only the button's busy state exposed) and record it, consistent with drift 3's treatment.
10. **Promote `_HairlineGrid` / `_EntryCell` from `icons.dart`?** Doing so edits a page that is finished but unrouted and unreviewed. **Recommend: promote** — `StateGrid`/`StateCell` are kit primitives in the reference (`kit.tsx:145–197`), and a second private fork would be the third copy of the `gap-px` lattice.
11. **`main.dart` routing debt.** `shadows`, `motion` and `icons` are built and unrouted; `buttons` would be the fourth. Add all four arms as part of this build, or only `buttons`? **Recommend: all four**, plus tighten `shell_test.dart:228–230` so `isNotNull` no longer passes on a `PlaceholderPage` — otherwise the same debt silently accrues again.
12. **Parity measurement.** `_referenceHeight['buttons']` and a `_referenceBreaks['buttons']` table must both be measured off `localhost:3000` at the 1440 frame. Is that measurement mine to take (dev server + the existing `PARITY_DUMP=1` / `WRAP_DUMP=1` rigs), or supplied? Same question stands open for the three unrouted pages.
13. **Reduced motion.** The reference's blanket rule collapses `swap-roll`, `anim-jelly`, the pill travel and the foil to 0.01ms. The port routes everything through `dsAnimationDuration`. Confirm the intended equivalence: reduced motion should make the swap and the pill **instant** (not disabled), and should freeze the foil at its first frame.


---

## CHECKED - 2026-08-15 - duration utilities (no correction needed)

*(Corpus-wide sweep prompted by `selection-map.md` §7.1: Tailwind v4 emits no
`duration-*` utility for the `--duration-*` theme namespace, so those class names
are inert and the element falls back to `--default-transition-duration: 250ms`.
Mechanism and probe record in `forms-map.md`'s 2026-08-15 correction block.)*

**This map's timing inventory is clean.** Every duration it asserts comes from a
rule that reads `var(--duration-*)` **directly**, not from a utility class:

- `slide-pill` (`globals.css:2256`) - transform/width/height 250ms, opacity
  **150ms**. Probed: `transition-duration: 0.25s, 0.25s, 0.25s, 0.15s`. Real.
- `swap-roll` (`:2265`) - 400ms on both properties. Real.
- `IconSwap`'s inner squash - `style={{ animationDelay: "var(--duration-fast)" }}`
  is an **inline style reading the custom property**, not a utility. Real 150ms.
- `btn-spring` (`:1886`) - 250ms, dropping to 80ms on `:active`. Probed on the
  live `[data-slot=button]`: six legs, all `0.25s`. Real.
- `Toggle` / `ToggleGroupItem` `transition-all` "at the framework default 250ms"
  (the variant-base row and drift 11) - **already correct**; those components
  carry no duration class at all.

No entry in this map transcribed a no-op utility as a real value. The port's
`button.dart`, `press.dart`, `sliding_pill.dart` and `keyframes.dart` keep
`DsDurations.tick` / `.base` / `.fast` / `.slow` unchanged for the same reason.
