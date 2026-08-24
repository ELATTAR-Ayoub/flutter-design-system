# Map — `/design-system/components/base/selection` (Base Components · Selection Controls)

**Route directory, verified:** `design-system\app\design-system\components\base\`**`selection`**`\page.tsx`. Not `selection-controls`. The *title* is "Selection Controls" (`lib\el\nav.ts:196`); the *slug* is `selection`, the component is `SelectionPage`, and the lookup is `findCategory("base", "selection")` (`page.tsx:32`). The Flutter nav registry already agrees (`example\lib\nav.dart:257`).

**Files that produce the render** (all under `D:\DESIGN\Design-System-2026-8\design-system\`):
- `app\design-system\components\base\selection\page.tsx` — the page. **`"use client"`**, 367 lines, **two** `useState`s (`price`, `odds`), no page-local components at all. Every specimen is inline JSX.
- `components\el\kit.tsx` — `ElPageHeader`, `ElSection`, `Panel`, `StateGrid` (:145), `StateCell` (:173), `Meta` (:202), `Code`, `DoDont`, `Note`, `PageFootNav`.
- `components\ui\checkbox.tsx` (77 lines) · `radio-group.tsx` (70) · `switch.tsx` (65) — the three the port already ships.
- `components\ui\slider.tsx` (84 lines) — **the fourth family, and the one the port does not have.**
- `components\ui\use-replay-on-state-change.ts` (43 lines) — the jelly hook, imported by the first three and **not** by `Slider`.
- `components\ui\field.tsx` — `FieldSet`, `FieldLegend`, `FieldGroup`, `Field`, `FieldLabel`, `FieldDescription`. No `FieldError` on this page (nothing validates).
- `components\ui\label.tsx` — `Label` used **raw**, not through `FieldLabel`, for the withdrawal option cards (`page.tsx:185`). The only page in the ported corpus that does.
- `lib\el\nav.ts:194–199` — `findCategory("base","selection")`; `siblings()` → prev **Dialogs & Overlays**? — see §10, it is **not** what alphabetical order suggests.
- `app\globals.css` — every token/utility below.

Read with `shared-map.md` (shell, kit anatomy, type-class table) and `forms-map.md` (§8.1–8.3 control geometry, §13 tokens, §14 port inventory). **`forms-map.md` §8.3 contains one error this map corrects — see §7.1.**

**Measurement note.** *(measured)* = read out of the built stylesheet at `.next\static\chunks\2xoei7gie4yqt.css` by byte offset. *(probed)* = `getComputedStyle` / `getBoundingClientRect` against the live dev server at `localhost:3000`, viewport **1440 × 900**, fonts loaded, 2026-08-15. Both appear below because the phase-3 CanvasKit lesson applies: **no painter changes on stylesheet reading alone.**

---

## 0 · Shell / layout metrics — delta from foundations

Identical shell (`shared-map.md` §1). What is new:

| thing | value |
|---|---|
| Route | `/design-system/components/base/selection` |
| Specimen column | **1080px** at the 1440 frame, as everywhere |
| **Reading-column height** *(probed)* | **4252.14px** — and it is **identical in light and dark** (verified by toggling `documentElement.classList` and re-measuring: 4252.14 both). This is `_referenceHeight['selection']`. |
| Section rhythm | `mb-20` (80px) on all six |
| **A page-level `Note` above section 1** | `tone="action"` + `className="mb-12"` → **48px** below it. 1080 × **100px** *(probed)*. No other ported page opens with a Note. |

Per-section heights *(probed, 1440 frame)* — useful for bisecting a vertical-parity failure:

| `id` | height |
|---|---|
| `checkbox` | 922.03 |
| `radio` | 632.19 |
| `switch` | 534.30 |
| `slider` | 541.19 |
| `api` | 274.80 |
| `rules` | 350.80 |

---

## 1 · Page header (`ElPageHeader`)

`<header class="mb-14 border-b border-border pb-10">`, fed from `nav.ts:194–199`.

1. Eyebrow `type-label text-action-ink` → **"Base Components · Base"** (`page.tsx:41`, `` eyebrow={`${group.title} · Base`} ``). Separator **U+00B7**. The word "Base" twice, as on all fourteen base pages — `forms-map.md` §15 drift 1.
2. `type-h1 mt-4` → **"Selection Controls"**.
3. `type-lead mt-4 max-w-2xl` → **"Binary and ranged controls: checkbox, radio, switch and slider."**
4. Chips from `category.contents`, verbatim, in order:
   **Checkbox · Radio Group · Switch · Slider · Range Slider**

**Five chips, six sections, and the fifth chip names no section.** On `forms` the chips *were* the section titles. Here `Range Slider` is a chip with no `ElSection`, and `API`/`Rules` are sections with no chip. See §14 drift 1.

`example\lib\nav.dart:256–267` already carries all five contents byte-for-byte.

---

## 2 · Section inventory (verbatim)

Six `ElSection`s, `PageFootNav` last. Shell: `<section id class="mb-20">`; `<h2 class="type-h3">`; description `type-small mt-2 max-w-2xl`.

| # | `id` | title | description (verbatim) |
|---|---|---|---|
| 1 | `checkbox` | **Checkbox** | Used for filters, bulk card selection and terms acceptance. Selection is blue, always. |
| 2 | `radio` | **Radio Group** | One choice from a set the user can see at once. If the options need explaining, the description belongs inside the option, not beneath the group. |
| 3 | `switch` | **Switch** | Only for settings that take effect the moment they are flipped. If there is a Save button on the screen, use a checkbox instead. |
| 4 | `slider` | **Slider** | Ranges. The current value is always shown as a number beside the track — a slider without a readout is guesswork. |
| 5 | `api` | **API** | *(none — `ElSection` with no `description` prop)* |
| 6 | `rules` | **Rules** | *(none)* |

§4's description carries **U+2014**.

Per-section children, in DOM order:

| § | children |
|---|---|
| — | `Note tone="action" title="Which control for which job"` `mb-12` (`page.tsx:47–54`) |
| 1 | `StateGrid cols={6}` (6 cells) · `Panel label="In a filter list" mt-4` · `Panel label="Bulk selection header" mt-4` |
| 2 | `StateGrid cols={4}` (4 cells) · `Panel label="Withdrawal method" mt-4` |
| 3 | `StateGrid cols={4}` (4 cells) · `Panel label="Notification preferences" mt-4` |
| 4 | `Panel label="Price range filter"` *(no `mt`)* · `Panel label="Single value" mt-4` · `StateGrid cols={3} mt-4` (3 cells) |
| 5 | `Meta` (5 items) |
| 6 | `DoDont` (5 dos, 4 don'ts) · `Note mt-4` |

**No `Note` inside any of §1–§4** — the only page-level guidance is the one Note above §1 and the one at the end of §6. `forms` carried six.
**No `Code` outside §6's Note.** **No `DoDont` outside §6.**

---

## 3 · `StateGrid` / `StateCell` — measured geometry

`StateGrid` (`kit.tsx:145`): `grid gap-px overflow-hidden rounded-lg border border-border bg-border`. The 1px lattice is `--border` showing between opaque cells.

| § | `cols` | column template *(probed)* | grid height *(probed)* |
|---|---|---|---|
| 1 | **6** | `178.828 178.828 178.828 178.844 178.828 178.828` | 144.67 |
| 2 | 4 | `268.75 × 4` | 124.50 |
| 3 | 4 | `268.75 × 4` | 124.50 |
| 4 | **3** | `358.656 358.672 358.656` | 124.50 |

*(The 6-col row carries one 178.844 column — Chrome's sub-pixel distribution of 1080 − 5 gaps over six tracks. `ElGrid` must round the same way or the lattice drifts.)*

`StateCell` (`kit.tsx:173`), 6-col instance *(probed)*: **178.83 × 142.67**, `bg-background` (`rgb(9,9,11)` dark), `p-5` = **20px**. Stage `mb-4 flex min-h-14 items-center justify-center` → **56px** min-height, **16px** below, 138.83 wide. Label `type-micro text-center text-muted-foreground` → **10.5px / 10.5px / 600 / letter-spacing 1.89px / uppercase** *(probed)*. Note `type-caption mt-1.5 text-center text-muted-foreground` → 10.5 / 1.35 / 500, 6px above.

**`ElStateGrid` already supports `cols: 6` and `cols: 3`** (`example\lib\kit.dart:503`, the switch maps 2/3/4/5 and falls through to 6). Nothing to add.

---

## 4 · The state matrices, cell by cell — and what they expose

### 4.1 · §1 Checkbox, `cols={6}` (`page.tsx:61–83`)

| # | label | note | props | rendered *(probed)* | live? |
|---|---|---|---|---|---|
| 1 | **Unchecked** | — | `aria-label="Unchecked"` | `data-state=unchecked`, border `--input`, `shadow-pressed`, opacity 1 | **LIVE** — uncontrolled, a click checks it |
| 2 | **Checked** | — | `defaultChecked` | `data-state=checked`, border `rgb(26,110,244)`, `shadow-btn-primary` | **LIVE** — uncontrolled |
| 3 | **Indeterminate** | Partial bulk selection | `checked="indeterminate"` | `data-state=indeterminate`, lit skin, **`disabled: false`, `opacity: 1`** | **INERT BUT NOT DISABLED** — see below |
| 4 | **Focus** | Tab to it | `className="border-ring ring-3 ring-ring/50"` | border `rgb(146,194,252)` = `--ring`; ring `oklab(… / 0.5) 0 0 0 3px` | **STATIC FAKE** — see below |
| 5 | **Disabled** | — | `disabled` | opacity **0.5** | static |
| 6 | **Disabled checked** | — | `disabled defaultChecked` | lit skin at opacity **0.5** | static |

**Cell 3 is controlled with no `onCheckedChange`.** Radix holds it at the prop value, so it never changes — but it carries no `disabled`, so it is **fully opaque and still focusable**. The port has no spelling for this: `ElCheckbox(onChanged: null)` drives `_enabled == false` in `ElSelectionControl` (`selection_control.dart:299`), which applies `Opacity(0.5)` **and** `IgnorePointer`. Rendering this cell today would dim a box the reference renders at full strength. **Gap 2 in §12.**

**Cell 4 is a lie painted with class names.** `cn()` is `extendTailwindMerge` (`lib\utils.ts`), and `border-input` / `border-ring` are one `border-color` group, so tw-merge **deletes `border-input` from the string entirely** — confirmed by probing `el.className`, which reads `… border-ring ring-3 ring-ring/50` with no `border-input`. Nothing is focused; the ring is a permanent box-shadow. Two such cells exist on the page (checkbox and radio), and **Flutter cannot have two genuinely-focused controls at once**, so the port needs a way to paint the ring without owning focus. **Gap 3 in §12.**

*(Ring composition, measured: `.shadow-pressed` @92704 sets `--tw-shadow`; `.ring-3` @94521 sets `--tw-ring-shadow`; both emit the same five-slot `box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow)`. The ring is **added to** the socket, never replacing it — exactly what `ElButton.withFocusRing` already does.)*

### 4.2 · §2 Radio Group, `cols={4}` (`page.tsx:151–176`)

Each cell wraps its item in **its own `<RadioGroup>`** — four independent groups, one item each.

| # | label | props | rendered *(probed)* | live? |
|---|---|---|---|---|
| 1 | **Unselected** | `<RadioGroup><RadioGroupItem value="a"/></RadioGroup>` | `unchecked`, border `--input` | **LIVE** — uncontrolled group, a click selects |
| 2 | **Selected** | `<RadioGroup defaultValue="a">` | `checked`, border `rgb(26,110,244)` | **LIVE** |
| 3 | **Focus** | `className="border-ring ring-3 ring-ring/50"` | border `rgb(146,194,252)` | **STATIC FAKE** |
| 4 | **Disabled** | `disabled` on the item | opacity **0.5** | static |

The `RadioGroup` root is `grid w-full gap-2`, so inside a 138.83px stage it renders **228.75 × 20** *(probed — it fills the cell's content box and the item stays 20px)*. `ElRadioGroup` already reproduces this with loose constraints (`radio.dart:239–243`).

No cell passes `aria-label` to the group; each item carries its own.

### 4.3 · §3 Switch, `cols={4}` (`page.tsx:213–226`)

| # | label | props | rendered *(probed)* |
|---|---|---|---|
| 1 | **Off** | — | `unchecked`, `bg-muted` `rgb(39,39,42)`, opacity 1 — **LIVE** |
| 2 | **On** | `defaultChecked` | `checked`, `rgb(26,110,244)` — **LIVE** |
| 3 | **Disabled off** | `disabled` | `data-disabled=""`, opacity **0.5** |
| 4 | **Disabled on** | `disabled defaultChecked` | `data-disabled=""`, lit, opacity **0.5** |

**No focus cell in the switch matrix**, and none in the slider matrix either. Only checkbox and radio fake one.

### 4.4 · §4 Slider, `cols={3}` (`page.tsx:292–311`)

| # | label | props | rendered *(probed)* |
|---|---|---|---|
| 1 | **Default** | `defaultValue={[40]} className="w-40"` | 160 × 10 root; range 63.2 × 8 at `left: 0` — **LIVE, draggable** |
| 2 | **Range** | `defaultValue={[20,70]} className="w-40"` | range 79.02 × 8 at `left: 31.5938px` — **LIVE** |
| 3 | **Disabled** | `defaultValue={[40]} disabled className="w-40"` | root `opacity: 0.5` |

`w-40` = `calc(var(--spacing) * 40)` = **160px** *(measured @38752)*.

---

## 5 · The four composition demos

### 5.1 · §1 "In a filter list" (`page.tsx:85–110`)

```
FieldSet className="max-w-sm"          → 384 × 164.56, gap 16px   (probed)
  FieldLegend variant="label"          → "Availability", 13 / 18.5714 / 500, mb 6px
  FieldGroup                           → gap 20px
    Field orientation="horizontal" ×4  → 384 × 20, flex-row, gap 8px, items-center
      Checkbox id={`f-${label}`}
      FieldLabel htmlFor className="font-normal"
      span.type-num-sm.ml-auto.text-muted-foreground
```

| label | count | `defaultChecked` |
|---|---|---|
| Available now | 184 packs | **true** |
| Limited edition | 12 packs | **true** |
| Coming soon | 6 packs | false |
| Sold out | 41 packs | false |

`FieldLabel` here is **weight 400** *(probed: `fontWeight: "400"`, colour `rgb(250,250,250)` = `--foreground`, 13px / 17.875px)* because of `className="font-normal"` overriding Label's `font-medium`. `ElFieldLabel` (`field.dart:503`) renders `ElText(text, ElComponentType.fieldLabel)` with **no weight override** — **gap 4 in §12**.

Count column: `type-num-sm` = **12px / 14.4px / 600 / GeistMono / letter-spacing −0.12px / `--muted-foreground`** *(probed)*.

**`id={`f-${label}`}` produces ids containing spaces** — `f-Available now`. Legal HTML5, unusable in an unescaped CSS selector. Drift 4.

### 5.2 · §1 "Bulk selection header" (`page.tsx:112–143`)

```
div.max-w-lg.space-y-px.overflow-hidden.rounded-lg.border.border-border
```
→ **512 × 271**, radius 12, border `--border`, **`background-color: rgba(0,0,0,0)`** *(probed)*.

**The 1px separators are not a fill — they are the parent showing through.** The container declares no background, so what shows in each `space-y-px` gap is the `Panel`'s `bg-background`. *(measured @57961: `.space-y-px>:not(:last-child){… margin-block-end: calc(1px * calc(1 - var(--tw-space-y-reverse)))}` — a bottom **margin**, not a gap.)* Height checks out: 6 × 44 + 5 × 1 + 2 × 1 border = **271** ✓.

Six rows, each `510 × 44`, `flex items-center gap-3 px-4 py-3` (12px gap, 16/12 padding) *(probed)*:

| # | background *(probed)* | contents |
|---|---|---|
| 1 | `--muted` `rgb(39,39,42)` | `Checkbox checked="indeterminate" aria-label="Select all cards"` · `span.type-small.text-foreground` **3 of 12 cards selected** · `span.type-num-sm.ml-auto.text-value-ink` **$2,481.00** |
| 2–4 | `bg-action/12` → `oklab(0.572642 −0.0367003 −0.212413 / 0.12)` | `Checkbox defaultChecked` · name in `text-foreground` |
| 5–6 | `--background` `rgb(9,9,11)` | bare `Checkbox` · name in `text-muted-foreground` |

Names: **Voidwing Ascendant · Emberlash Prime · Tidecaller** (selected) · **Stonewarden · Glasswing Drift** (not).

Trailing `<p class="type-small mt-5">` (20px above):
> The indeterminate state is what makes a bulk header honest — it says “some” rather than lying with checked or unchecked. Selected rows also take the blue tint, so selection reads without inspecting the box.

*(U+2014, then `&ldquo;`/`&rdquo;` = U+201C/U+201D.)*

**Row 1's checkbox is the second inert-controlled indeterminate on the page**, and rows 2–6 are uncontrolled and therefore live.

### 5.3 · §2 "Withdrawal method" (`page.tsx:178–205`)

```
RadioGroup defaultValue="usdc" className="max-w-lg gap-3"   → 512 wide, gap 12px
  Label htmlFor={`w-${value}`} className="
    flex cursor-pointer items-start gap-3 rounded-lg border border-border bg-card p-4
    transition-colors duration-fast
    has-[[data-state=checked]]:border-action/50
    has-[[data-state=checked]]:bg-action/12
    hover:border-input"
      RadioGroupItem value id className="mt-0.5"
      span.min-w-0.flex-1  →  span.type-h4.block.text-foreground
                              span.type-small.mt-1.block
      span.type-num-sm.shrink-0.text-muted-foreground
```

Card *(probed)*: **512 × 81.3**, padding **16**, gap **12**, radius **12**, `align-items: flex-start`, `cursor: pointer`. `mt-0.5` on the item = **2px** *(probed)*.

| state | border *(probed)* | background *(probed)* |
|---|---|---|
| checked | `oklab(… / 0.5)` = `--color-action` @ 50% *(measured @155527)* | `oklab(… / 0.12)` = `--color-action` @ 12% *(measured @155823)* |
| unchecked | `--border` `rgb(39,39,42)` | `--card` `rgb(24,24,27)` |
| hover | `--input` *(measured @138463: `.hover\:border-input:hover{border-color:var(--input)}`)* | unchanged |

| `value` | title (`type-h4`) | description (`type-small`) | fee (`type-num-sm`) |
|---|---|---|---|
| `usdc` | **USDC** | Arrives in minutes. Network fee applies. | No fee |
| `bank` | **Bank transfer** | 1–3 business days. | $0.00 |
| `card` | **Card refund** | Back to the original card. 5–10 days. | $0.00 |

*(The two ranges carry **U+2013** EN DASH, unspaced.)*

`type-h4` *(probed)*: **17px / 23.8px (1.4) / 600 / Inter Local**. *(Note: a second `.type-h4` exists at byte 262465 but it is scoped `.theme-reference .type-h4` — the Elattar page takes the one at 13723.)*

Trailing `<p class="type-small mt-5">`:
> The whole card is the target, not just the 16px circle. Selected takes a blue border plus the blue tint.

**The circle is 20px, not 16.** Drift 2.

**This is the first hover state in the family.** `ElSelectionControl`'s own doc comment states *"No control on this page authors a hover state (forms-map §8.2), so the cursor is the only thing a pointer changes"* (`selection_control.dart:404–406`). That remains true of the **controls**; the **card around one** does author hover. **Gap 6 in §12.**

### 5.4 · §3 "Notification preferences" (`page.tsx:228–245`)

```
FieldGroup className="max-w-lg"        → 512 wide, gap 20px  (probed)
  Field orientation="horizontal" ×4    → 512 × 37.38, flex-row, gap 8, items-center
    span.min-w-0.flex-1
      FieldLabel htmlFor={`sw-${title}`}
      FieldDescription
    Switch id={`sw-${title}`} defaultChecked
```

Row height **37.38** = label 17.875 + description 19.5 ✓. `items-center` applies (not `items-start`) because the child is a bare `<span>`, not a `data-slot=field-content` — `Field`'s `has-[>[data-slot=field-content]]:items-start` misses.

| title | description | on |
|---|---|---|
| Rare pull alerts | Notify me when a legendary or better is pulled from a pack I follow. | **true** |
| Weekly leaderboard | A summary of where I placed and what I earned. | **true** |
| Marketing email | New pack drops and promotions. | false |
| Reduced motion | Skip the pack-opening animation entirely. | false |

Ids again contain spaces (`sw-Rare pull alerts`).

### 5.5 · §4 The two slider panels (`page.tsx:253–290`)

Both wrapped in `div.max-w-md` → **448px** *(`--container-md` = 28rem)*.

**Panel "Price range filter"** — `useState([10, 240])`:
```
div.mb-4.flex.items-baseline.justify-between
  span.type-label            "Price range"
  span.type-num.text-foreground   "$10 – $240"      ← U+2013, SPACED
Slider value={price} onValueChange={setPrice} min={0} max={500} step={5} aria-label="Price range"
div.mt-3.flex.justify-between
  span.type-num-sm.text-muted-foreground  "$0"
  span.type-num-sm.text-muted-foreground  "$500"
```

**Panel "Single value"** — `useState([25])`:
```
span.type-label   "Auto-sell below rarity"
span.type-num.text-foreground  "25%"
Slider value={odds} onValueChange={setOdds} max={100} step={1} aria-label="Auto-sell threshold"
```
*(no `min` — the component defaults it to 0; no footer row.)*

`type-num` *(probed)*: **15px / 18px (1.2) / 600 / GeistMono / −0.15px / tabular-nums**.
`type-label` *(probed)*: **11px / 11px / 600 / letter-spacing 1.76px / uppercase / `--muted-foreground`**.

---

## 6 · `Slider` — the component the port does not have

`components\ui\slider.tsx`. Its docstring is the spec: *"the track is a **sunken channel** (`shadow-pressed`) and each thumb is a **raised knob** (`shadow-btn`), so the handle reads as sitting in the groove rather than on top of a line. The filled range carries the blue glow… 10px track and 20px thumbs rather than stock's 4 and 12."*

### 6.1 · Classes, verbatim

| part | classes | resolved |
|---|---|---|
| Root (`:44–47`) | `relative flex w-full touch-none items-center select-none data-disabled:opacity-50 data-vertical:h-full data-vertical:min-h-40 data-vertical:w-auto data-vertical:flex-col` | *(probed: `height: 10px`, `position: relative`, `align-items: center`)* — **the Root's height is the track's height; the 20px thumbs overflow it by 5px top and bottom.** |
| Track (`:52`) | `relative grow overflow-hidden rounded-pill border border-input bg-muted shadow-pressed data-horizontal:h-2.5 data-horizontal:w-full` | **10px** tall, 1px `--input`, `--muted` fill, pill, **`overflow: hidden`** |
| Range (`:61`) | `absolute bg-action-ink shadow-btn-primary select-none data-horizontal:h-full` | **8px** tall (the track's content box), `--action-ink`, `shadow-btn-primary` |
| Thumb (`:68–77`) | `relative block size-5 shrink-0 rounded-full border border-input bg-foreground shadow-btn ring-ring/50 select-none` + `transition-[transform,box-shadow] duration-fast ease-spring` + `after:absolute after:-inset-2` + `hover:scale-110 hover:ring-3` + `focus-visible:ring-3 focus-visible:outline-hidden` + `active:scale-125 active:ring-3` + `disabled:pointer-events-none disabled:opacity-50` | **20 × 20**, `--foreground` fill, `shadow-btn`, **36 × 36** hit area (`-inset-2` = 8px) |

`bg-action-ink`, **not** `bg-primary` — the source comment (`:54–58`) gives the measurement: *"`--primary` measures 1.63:1 there on this palette; `--action-ink` measures 6.88:1."* A filled channel has no foreground of its own, so contrast is against `--muted`. **`--action-ink` is theme-split** (`--color-action-dark` light, `--color-action-bright` dark), unlike `--primary`, which is `--color-action` in both.

### 6.2 · Positioning — the one genuinely new geometry *(probed)*

Two different coordinate spaces, and they deliberately disagree:

**Range** — a pure percentage of the **Track's content box** (448 − 2 × 1px border = **446**):
```
price = [10, 240], min 0, max 500
left  = 10/500 × 446 = 8.92    → probed 8.90625
width = 230/500 × 446 = 205.16 → probed 205.19   ✓
```

**Thumb** — Radix wraps each `Thumb` in a positioned `<span>`; the probe returns its inline style verbatim:
```html
<span style="transform: var(--radix-slider-thumb-transform);
             position: absolute;
             left: calc(2% + 9.6px);">
```
with computed `transform: matrix(1, 0, 0, 1, -10, 0)` = `translateX(-50%)` of a 20px thumb.

The formula, generalised — percentage against the **Root's full width** (448), plus a thumb-width inset:
```
left      = P% + (50 − P) × thumbSize / 100   px
transform = translateX(−50%)
```
Check P = 2: `0.02 × 448 = 8.96` + `48 × 20/100 = 9.6` → **18.56** *(probed 18.5469)*. At P = 0 the thumb's left edge lands exactly at 0; at P = 100 its right edge lands exactly at the end. **The thumb never overhangs the track; the range does not compensate.** A port that positions both the same way will misalign the fill against the knob at every value but 50%.

### 6.3 · What is *not* on the Slider

- **No `useReplayOnStateChange`.** The slider does not jelly. It is the only one of the four families that does not.
- **No `aria-invalid` handling**, no `data-invalid`, no `FieldScope` participation.
- **No `after:-inset-x-3 after:-inset-y-2`** — its expander is the symmetric `after:-inset-2` (8px all round → **36 × 36**), not the 12/8 split the other three share.
- **The thumb's `disabled:opacity-50` is dead** *(probed)*. Radix renders the thumb as a **`<span>`** carrying `data-disabled=""` and **no `disabled` attribute**, and `disabled:` compiles to the `:disabled` pseudo-class, which a `<span>` can never match. Measured on the disabled matrix cell: root `opacity: 0.5`, **thumb `opacity: 1`**. The knob dims once, through the root, exactly like the track. Drift 11.

**One dimming, not two** — port `data-disabled:opacity-50` on the root only.

---

## 7 · Timing inventory — **and one correction to `forms-map.md`**

### 7.1 · `duration-fast` and `duration-base` emit no CSS *(measured + probed)*

**Tailwind v4 has no `--duration-*` theme namespace.** `--duration-fast` / `--duration-base` are declared (`@theme static`, emitted into `:root,:host` at byte 7671) and are read by hand-written `@utility` blocks and component classes — but they generate **no `duration-*` utility**.

Every `.duration-*` selector in the built stylesheet, exhaustively:
```
.duration-200   .duration-400
```
That is all. `.duration-fast` and `.duration-base` **do not exist**.

The transition utilities all fall back:
```
@98708  .transition-\[background-color\,border-color\,box-shadow\]{
          transition-property: background-color,border-color,box-shadow;
          transition-timing-function: var(--tw-ease, var(--default-transition-timing-function));
          transition-duration:        var(--tw-duration, var(--default-transition-duration))}
@101663 .transition-\[transform\,box-shadow\]{…same tail…}
@103196 .transition-colors{…same tail…}
@103531 .transition-transform{…same tail…}
```
`--tw-duration` is only ever set by a `duration-*` utility, so it is **never set on any control on this page**, and `--default-transition-duration` is **`.25s`** (`globals.css:395`). `--tw-ease` *is* set, by `.ease-out` / `.ease-spring`, which do exist (the `--ease-*` namespace is real).

**Probed on the live page — `getComputedStyle(...).transitionDuration`:**

| element | class says | **renders** | easing |
|---|---|---|---|
| `[data-slot=checkbox]` | `duration-fast` | **0.25s** | `cubic-bezier(0.22, 1, 0.36, 1)` |
| `[data-slot=radio-group-item]` | `duration-fast` | **0.25s** | `cubic-bezier(0.22, 1, 0.36, 1)` |
| `[data-slot=switch]` | `duration-base` | 0.25s | `cubic-bezier(0.22, 1, 0.36, 1)` |
| `[data-slot=switch-thumb]` | `duration-base` | 0.25s | `cubic-bezier(0.34, 1.56, 0.64, 1)` |
| `[data-slot=slider-thumb]` | `duration-fast` | **0.25s** | `cubic-bezier(0.34, 1.56, 0.64, 1)` |
| withdrawal `<Label>` card | `duration-fast` | **0.25s** | *(default)* `--ease-out` |

**`forms-map.md` §8.3 records `Checkbox`, `RadioGroupItem` at "150ms (`--duration-fast`)". That is wrong** — it reads the class name rather than the cascade. The port took it at face value:

- `lib\src\components\checkbox.dart:238` — `duration: ElDurations.fast`
- `lib\src\components\radio.dart:418` — `duration: ElDurations.fast`
- `test\selection_feedback_test.dart:104, 217, 351` — `await t.pump(ElDurations.fast)`

**Both shipped painters run their colour/shadow transition at 150ms where the browser runs 250ms.** `ElSwitch` is unaffected (`ElDurations.base` == 250ms == the fallback, by coincidence). This is a phase-3 defect surfaced by this page, not a new-page requirement. **Gap 1 in §12; ruling requested in §15 Q1.**

### 7.2 · Full inventory

| element | animation / transition | duration | easing |
|---|---|---|---|
| Checkbox / Radio socket | `transition-[background-color,border-color,box-shadow]` | **250ms** *(probed)* | `--ease-out` |
| Switch track | `transition-[background-color,box-shadow,border-color]` | 250ms | `--ease-out` |
| Switch thumb | `transition-transform` | 250ms | **`--ease-spring`** |
| Slider thumb | `transition-[transform,box-shadow]` | **250ms** *(probed)* | **`--ease-spring`** |
| Option card | `transition-colors` | **250ms** *(probed)* | `--ease-out` |
| checkbox tick | `anim-check-draw` — `stroke-dasharray: 22; check-draw 280ms both` (`globals.css:2243–2246`) | 280ms | `--ease-out` |
| checkbox dash | `anim-dash-draw` — `stroke-dasharray: 12; dash-draw 200ms both` (`:2247–2250`) | 200ms | `--ease-out` |
| radio dot | `anim-dot-pop` — `dot-pop 320ms both` (`:2251–2253`) | 320ms | **`--ease-spring`** |
| Checkbox / Radio / Switch whole control | `anim-jelly` — `yuki-jelly 0.6s var(--ease-out) both` (`:2365–2367`), replayed by MutationObserver, **never on mount** | 600ms | `--ease-out` |
| **Slider** | **nothing** — no jelly, no draw, no pop | — | — |

Keyframes, verbatim (`globals.css:2212–2241`, `:2431–2438`):
```
check-draw  from { stroke-dashoffset: 22 } to { stroke-dashoffset: 0 }
dash-draw   from { stroke-dashoffset: 12 } to { stroke-dashoffset: 0 }
dot-pop     0% scale(0) opacity 0 · 55% scale(1.35) opacity 1 · 100% scale(1) opacity 1
yuki-jelly  0% (1,1,1) · 30% (1.18,.82,1) · 45% (.88,1.12,1) · 60% (1.06,.94,1) · 78% (.98,1.02,1) · 100% (1,1,1)
```
All four already live in the port as `ElCheckDraw` / `ElDashDraw` / `ElDotPop` / `ElJelly` (`foundation\motion.dart:124, 130, 138, 71`) at the right numbers. **Only the two socket transitions are wrong.**

Reduced motion: `globals.css:2534–2542` collapses everything on `*, *::before, *::after`. The port routes this through `elAnimationDuration(context, …)`, already wired in `ElSelectionControl` and `_Thumb`.

---

## 8 · Live vs static ledger — the fidelity bar

**This page is even more live than `forms`.** Seventeen of its twenty specimens respond to a pointer.

| § | specimen | live? | what you can trigger |
|---|---|---|---|
| 1 | matrix cells 1, 2 | **LIVE** | click toggles; tick draws; jelly replays |
| 1 | matrix cell 3 (Indeterminate) | **inert, undimmed** | nothing — controlled, no handler, **not disabled** |
| 1 | matrix cell 4 (Focus) | **static fake** | a painted ring; nothing is focused |
| 1 | matrix cells 5, 6 | static | disabled |
| 1 | filter list ×4 | **LIVE** | click box or label; two start checked |
| 1 | bulk header row 1 | **inert, undimmed** | controlled indeterminate |
| 1 | bulk rows 2–6 | **LIVE** | uncontrolled; **row tint does not follow** — see drift 3 |
| 2 | matrix cells 1, 2 | **LIVE** | uncontrolled groups |
| 2 | matrix cell 3 | static fake | |
| 2 | matrix cell 4 | static | disabled |
| 2 | withdrawal cards ×3 | **LIVE** | whole card is the target; border + tint follow; hover on border |
| 3 | matrix cells 1, 2 | **LIVE** | |
| 3 | matrix cells 3, 4 | static | disabled |
| 3 | preferences ×4 | **LIVE** | label and description are the target |
| 4 | price range | **LIVE** | two thumbs, `useState`, readout updates |
| 4 | single value | **LIVE** | one thumb, readout updates |
| 4 | matrix cells 1, 2 | **LIVE** | uncontrolled, draggable |
| 4 | matrix cell 3 | static | disabled |

A port that renders the four families as stills fails the bar. The minimum interactive surface: tri-state checkbox toggling, radio selection through a whole card, switch flipping, **and two draggable sliders with a live numeric readout**.

---

## 9 · Copy — verbatim, with markup resolved

`{" "}` → one literal space; `&ldquo;`/`&rdquo;` = U+201C/U+201D.

### 9.1 · The opening Note (`page.tsx:47–54`) — `tone="action"`, `title="Which control for which job"`

> **Checkbox** for independent options and multi-select. **Radio** for one choice from a visible set. **Switch** only for settings that apply immediately with no Save button. **Slider** for ranges where the exact number matters less than the feel — price filters, odds explainers.

Each bold word is `<strong className="text-foreground">` — i.e. the four names step **up** out of the Note's `text-action-ink` to `--foreground`. Inline runs, in order: `Checkbox` · " for independent options and multi-select. " · `Radio` · " for one choice from a visible set. " · `Switch` · " only for settings that apply immediately with no Save button. " · `Slider` · " for ranges where the exact number matters less than the feel — price filters, odds explainers." *(U+2014)*

### 9.2 · §5 `Meta` — 5 rows (`page.tsx:315–338`)

| k | v |
|---|---|
| `Checkbox` | checked accepts true, false or "indeterminate". Use indeterminate for partial bulk selection. |
| `RadioGroup` | RadioGroup + RadioGroupItem. Wrap each item in a Label so the whole card is clickable. |
| `Switch` | Immediate-effect settings only. Always paired with a FieldLabel and FieldDescription. |
| `Slider` | value as an array. Two entries makes it a range. Always render the value as text too. |
| `has-[[data-state=checked]]:` | The Tailwind pattern for styling a wrapper based on the control inside it — used for selected option cards. |

*(Row 1's quotes are straight `\"` in the source. Row 5's `k` is a class-name fragment, printed in `type-num-sm text-action-ink` like every other key.)*

### 9.3 · §6 `DoDont` — 5 dos, 4 don'ts (`page.tsx:342–356`)

**Dos**
1. Use indeterminate on a bulk-select header whenever some but not all rows are selected.
2. Make the whole option card clickable, not just the 16px control.
3. Show a slider's current value with the shared type-num foundation.
4. Reserve Switch for settings that apply instantly.
5. Tint selected rows blue so selection reads at a glance.

**Don'ts**
1. Don't use a Switch next to a Save button — that is a checkbox.
2. Don't use a radio group for two options that are really on and off.
3. Don't ship a slider without a numeric readout.
4. Don't rely on the tick or dot alone; selected rows should change background too.

*(All apostrophes straight `'` in the source; the panel heading itself renders "Don’t" with U+2019 from `DoDont`. Em dash in don't 1. **`dos` is 5 long and `donts` is 4** — the first ported `DoDont` with unequal columns.)*

### 9.4 · §6 trailing `Note` (`page.tsx:357–361`) — default tone, `mt-4`

> Indeterminate is set with `checked="indeterminate"`, not a separate prop. Getting this wrong is the most common bug in bulk selection headers.

`<Code>` wraps `checked=&quot;indeterminate&quot;` → renders `checked="indeterminate"` with straight quotes. No `title` prop.

---

## 10 · Foot nav

`PageFootNav groupId="base" slug="selection"` (`page.tsx:364`) → `<nav class="mt-8 flex items-stretch gap-4 border-t border-border pt-8">` *(probed)*.

- **Previous** → **"Selects & Pickers"**, `/design-system/components/base/selects`
- **Next** → **"Dialogs & Overlays"**, `/design-system/components/base/dialogs`

*(Both probed off the live foot nav; the ampersand is a literal `&` in both titles.)* Link anatomy and `press` are unchanged from `shadows-map.md` §9. `example\lib\nav.dart` carries the same ordering, so `siblings('base','selection')` resolves both without change.

---

## 11 · Token / type reference — what this page adds

Nothing beyond `forms-map.md` §13 except:

| token | value | used by |
|---|---|---|
| `--color-action` | `hsl(217 91% 53%)` = `#1A6EF4`, **same in both themes** | `bg-action/12`, `border-action/50` |
| `--action-ink` | dark `--color-action-bright` `#92C2FC` · light `--color-action-dark` `#143694` | slider Range fill |
| `--value-ink` | dark `--color-value-bright` · light `--color-value-dark` | bulk header `$2,481.00` |
| `--muted` | `rgb(39,39,42)` dark | switch track off, slider track, bulk header row |

**`--primary` is `var(--color-action)` in *both* themes** (`globals.css:582`, `:772`), so `bg-action/12` and `primary @ 12%` are numerically identical. **`--ring` is not**: light `--color-action`, dark `--color-action-bright` (`:584`, `:780`). A port that reaches for `theme.primary` where the page names `action` will be right today and wrong the moment the semantic alias moves. See §15 Q3.

Type classes consumed: `type-h1`, `type-h3`, `type-lead`, `type-small`, `type-chip`, `type-label` (11/1/600/1.76px/upper), `type-micro`, `type-caption`, `type-code`, **`type-h4`** (17/1.4/600), **`type-num`** (15/1.2/600 mono, −0.15px, tabular), **`type-num-sm`** (12/1.2/600 mono, −0.12px). Plus the `text-sm` ladder inside the field family (`forms-map.md` §3.2).

Radii: `sm` 6 (checkbox), `lg` 12 (StateGrid, cards, bulk list, Note, Meta), `pill` 999 (switch track, slider track), `full` (radio, thumbs).

**All three of `ElType.h4`, `ElType.numBase`, `ElType.numSm` already exist** (`foundation\typography.dart:604`, `:794`, `:783`). No new type specs.

---

## 12 · Exists in the port / missing

Package root `D:\DESIGN\Design-System-2026-8\flutter-design-system\`.

### 12.1 · Already built — reuse unchanged

| need | where |
|---|---|
| `ElCheckbox` incl. tri-state, drawn tick/dash, `nextAfter` | `lib\src\components\checkbox.dart:98` |
| `ElRadioGroup` / `ElRadioGroupItem` incl. roving tabindex, arrow-wrap, dot-pop | `lib\src\components\radio.dart:102`, `:288` |
| `ElSwitch` incl. two sizes, recessed track / raised knob, spring thumb | `lib\src\components\switch.dart:83` |
| `ElSelectionControl`, `ElHitArea`, `ElJellyReplay` | `lib\src\components\selection_control.dart:217`, `:76`, `:144` |
| `ElFieldScope` / `ElFieldActivator` (label-for **activation**) | `lib\src\components\field.dart:95`, `:85` |
| `ElFieldGroup` (20px) · `ElFieldSet` (16/12 + legend special-case) · `ElFieldLegend` · `ElField` horizontal · `ElFieldDescription` | `field.dart:156`, `:190`, `:247`, `:291`, `:604` |
| `ElStateGrid` — **`cols: 6` and `cols: 3` already mapped** | `example\lib\kit.dart:503` |
| `ElStateCell`, `ElPanel`, `ElNote`(+tone), `ElMeta`, `ElDoDont`, `ElCode`, `ElPageHeader`, `ElSection`, `ElPageFootNav` | `example\lib\kit.dart:587, 242, 1124, 679, 1025, 737, 54, 148, 1446` |
| `ElShadows.pressed / btn / btnPrimary / e1` | `lib\src\foundation\shadows.dart` |
| `ElCheckDraw` 280 · `ElDashDraw` 200 · `ElDotPop` 320 · `ElJelly` 600 | `lib\src\foundation\motion.dart:124, 130, 138, 71` |
| `ElType.h4 / numBase / numSm / label / micro / caption / small` | `lib\src\foundation\typography.dart:604, 794, 783, 680, 723, 663, 629` |
| `theme.muted / mutedForeground / actionInk / valueInk / input / ring / primary / card / background / border` | `lib\src\foundation\theme.dart` |
| `ElPalette.action` = `hsl(217 91% 53%)` | `lib\src\foundation\colors.dart:311` |
| Nav entry for `selection` — slug/title/blurb/5 contents, verbatim | `example\lib\nav.dart:256–267` |

**The three shipped controls need no structural work.** This is a page-build plus one new component plus four pinned-state gaps.

### 12.2 · Missing / wrong — must be built or fixed

| # | item | notes |
|---|---|---|
| 1 | **Checkbox and Radio socket duration is 150ms; the reference renders 250ms** | *(probed, §7.1)* Fix `checkbox.dart:238` and `radio.dart:418` to `ElDurations.base`, and the three `t.pump(ElDurations.fast)` calls at `test\selection_feedback_test.dart:104, 217, 351`. Also correct `forms-map.md` §8.3. **A painter-timing change → re-pin rendered pixels + keep the browser probe on record.** |
| 2 | **"Controlled, no handler, not disabled"** | Matrix cell 3 and bulk row 1. Today `ElCheckbox(onChanged: null)` → `_enabled == false` → `Opacity(0.5)` + `IgnorePointer` (`selection_control.dart:299, 411–414`). The reference paints opacity **1**. Needs a third state distinct from both "operable" and "disabled" — e.g. `ElCheckbox.onChanged: null` staying undimmed while `enabled: false` dims, which is the split `ElSwitch` already documents at `switch.dart:104–107` but `ElSelectionControl` collapses. |
| 3 | **A way to paint the focus ring without owning focus** | Two "Focus" cells on one page; Flutter has one focus. `ElSelectionControl` derives the ring from its private `_focused` (`:297`, `:324–341`) with no external override. Needs something like `focusRing: bool?` forcing `_borderTarget`/`_ringTarget`. Affects `ElCheckbox` and `ElRadioGroupItem` signatures. |
| 4 | **`ElFieldLabel` weight override** | Filter list passes `font-normal` → **400** *(probed)*. `field.dart:503` renders `ElText(text, ElComponentType.fieldLabel)` (500) with no hook. |
| 5 | **`ElSlider`** | The whole component — §6. Track 10px pill on `shadow-pressed`, Range 8px `--action-ink` on `shadow-btn-primary`, 20px thumbs on `shadow-btn`, single **and** range values, drag + keyboard, `hover:scale-110`, `active:scale-125`, `focus-visible:ring-3` at `ring/50`, 36 × 36 hit area, `data-disabled:opacity-50` on the root, **no jelly**, and the two-coordinate-space positioning formula. New painter → rendered-pixel pins + browser probe mandatory. |
| 6 | **A hover state in this family** | The withdrawal card hovers `border-input`; `ElSelectionControl` deliberately authors none. The hover belongs to the **card**, not the control, so it can live in the page or in a new card widget — but it is the first one. |
| 7 | **A selectable option card** | Whole-card target wrapping a radio, with `has-[[data-state=checked]]` border + tint. `ElFieldActivator` already carries "a tap on the label selects the item" for a radio in its own nested field (`radio.dart:394`), so the wiring exists; the **card skin** (16px pad, 12px gap, 12 radius, items-start, 250ms colour transition, hover) does not. |
| 8 | **A tinted-row gapped list** | Bulk header: `space-y-px` inside a bordered, radiused, **background-less** container, so the 1px seams show the *parent*'s fill. **`ElDividedList` (`example\lib\kit.dart:1580`) cannot be reused** — verified: it fills with `theme.card` and draws each seam as a `border-top` **on the row** (`divide-y` semantics). That paints a `--border` hairline over an opaque card; the reference paints nothing and lets `--background` show. Needs a sibling widget — transparent fill, 1px **gaps**, per-row background supplied by the caller. |
| 9 | **`example\lib\pages\selection.dart`** + a route arm | `example\lib\main.dart:157–167` routes 10 pages; `selection` falls to `PlaceholderPage` (`:177–184`). |
| 10 | **`_referenceHeight['selection'] = 4252.14`** | `example\test\vertical_parity_probe_test.dart:56–64`. Measured on `main > div.mx-auto.max-w-(--width-content)` at 1440 × 900, **identical light and dark**, page fully idle. Unlike `forms`, nothing here changes height with state *provided* the pump does not drag a slider or toggle a live control — the matrices' live cells all keep their box size, so one plain `pump` is enough. |
| 11 | Page test + wrap-parity entry | Model on `example\test\forms_page_test.dart` / `wrap_parity_probe_test.dart`. |

### 12.3 · Guard-test constraints

`test\token_guard_test.dart:40–53` (raw text scan, comments included; escape hatch `allow-hardcoded: <reason>` anywhere on the line).

- **No new durations needed.** 250 is `ElDurations.base`; 280/200/320/600 already exist. The §12.2-1 fix *removes* a literal rather than adding one.
- **`ElSlider` adds three scalars**: `hover:scale-110` → 1.10, `active:scale-125` → 1.25, and `translateX(-50%)` → 0.5. The first two belong beside `ElTransforms` in `foundation\motion.dart` (the file already holds `ElDotPop`'s 1.35); the third is arithmetic, not a token.
- Slider sizes are all `el()` multiples: track `h-2.5` = `el(2.5)`, thumb `size-5` = `el(5)`, hit `-inset-2` = `el(2)`. Radius `pill` and `full` are `ElRadii`.
- The `(50 − P) × thumbSize / 100` formula's `50` and `100` are percentage arithmetic — no rule matches them, but write them as named locals so the derivation survives review.
- Doc comments quoting `Duration(milliseconds: 250)` will trip the scanner. State timings in prose.

---

## 13 · Live-page probe record

Everything marked *(probed)* came from one session against `http://localhost:3000/design-system/components/base/selection`, viewport **1440 × 900**, dark theme (light cross-checked for height only). Reproduce with `getComputedStyle` on `[data-slot=checkbox|radio-group-item|switch|switch-thumb|slider|slider-track|slider-range|slider-thumb]`.

Two traps hit during the probe, worth recording for whoever repeats it:
1. **`resize_window` navigated the tab away.** The measurement silently came back from `/components/base/feedback`. Re-assert `location.href` and `document.querySelector('h1').textContent` **after** every resize and before trusting a number.
2. **The first `.gap-px` element on the page is the shell's theme control** (92 × 34, `rounded-pill`, 4 children), not a `StateGrid`. Filter by `borderRadius === '12px'` or scope the query to `section[id]`.

---

## 14 · Drift register (record, do not fix)

1. **Five chips, six sections, and they do not correspond.** `contents` is `["Checkbox","Radio Group","Switch","Slider","Range Slider"]`; the sections are `checkbox, radio, switch, slider, api, rules`. **"Range Slider" names no section** (range is cell 2 of §4's matrix and the first slider Panel), and `API`/`Rules` get no chip. On `forms` the two lists were identical. Render both as written.
2. **The page calls a 20px control "16px", twice.** §2's trailing paragraph: *"not just the 16px circle"*; §6 do 2: *"not just the 16px control"*. Both `Checkbox` and `RadioGroupItem` are `size-5` = **20px**, and `checkbox.tsx`'s own docstring gives *"16px is a fiddly target"* as the reason they are not 16. The copy quotes the number the component was built to escape.
3. **The bulk header's tints are hard-coded and do not follow the checkboxes.** Rows 2–4 carry `bg-action/12` as a literal class and rows 5–6 `bg-background`; the checkboxes inside them are uncontrolled. Uncheck a tinted row and it stays blue; check an untinted one and it stays plain. §6 don't 4 — *"selected rows should change background too"* — is exactly what this demo does not do once touched.
4. **Ids contain spaces.** `` id={`f-${label}`} `` → `f-Available now`, `f-Limited edition`, `f-Coming soon`, `f-Sold out`; `` id={`sw-${title}`} `` → `sw-Rare pull alerts`, etc. Valid HTML5, and `htmlFor` matches, so the labels work — but no unescaped CSS selector or `querySelector('#…')` can reach them.
5. **`duration-fast` / `duration-base` are inert everywhere in the system.** *(measured + probed, §7.1)* Tailwind v4 emits no such utilities; every control on this page transitions at the `--default-transition-duration` fallback. The class names read as configuration and are decoration. This is the reference's drift, not the port's — but the port copied the *intent* instead of the *render*.
6. **The Focus cells are painted, not focused.** `className="border-ring ring-3 ring-ring/50"` with tw-merge deleting `border-input`. Nothing has focus; tabbing to the cell adds nothing, because the focus styles it would apply are already on. The note says *"Tab to it"*.
7. **The Indeterminate cell is inert and undimmed.** Controlled with no `onCheckedChange`. It looks operable, is not, and gives no signal — the one specimen on the page that a reader can click with no result and no explanation.
8. **The slider's Range and Thumb use different coordinate spaces.** *(probed, §6.2)* Range is a straight percentage of the track's 446px content box; the thumb is inset by half its own width against the root's 448px. They coincide only at 50%. Radix's design, faithfully inherited.
9. **The slider's hit-area expander disagrees with its three siblings.** `after:-inset-2` (symmetric 8px → 36 × 36) against `after:-inset-x-3 after:-inset-y-2` (12/8 → 44 × 36). The 44px floor RULES §7 asks for is met by the other three and **missed by the slider thumb**.
10. **The slider does not jelly and does not participate in the field layer.** No `useReplayOnStateChange`, no `aria-invalid`, no `FieldScope`. It is the only one of the four that is not a "selection control" in the codebase's own sense — it shares the raised/recessed vocabulary and nothing else.
11. **The slider thumb's `disabled:opacity-50` never fires.** *(probed)* Radix renders the thumb as a `<span>` with `data-disabled=""` and no `disabled` attribute; `disabled:` compiles to `:disabled`, which no `<span>` matches. Root 0.5, thumb 1. Three more dead classes sit beside it for the same reason — `disabled:pointer-events-none` on the thumb, and `hover:`/`active:` states that a disabled root still permits because only its opacity changed.
12. **`DoDont` gets unequal columns for the first time** — 5 dos against 4 don'ts. The grid is `sm:grid-cols-2`, so the panels are unequal height and the shorter one's border stops early.
13. **`Label` is used raw for the option cards** — the only page in the corpus that imports `@/components/ui/label` directly instead of going through `FieldLabel`. The cards therefore get none of `FieldLabel`'s `leading-snug`, `w-fit` or gap; they restate layout from scratch.
14. **`Switch` disables on `data-disabled:`, the others on `disabled:`** — `forms-map.md` drift 14, visible here in the matrix probe (`data-disabled=""` on cells 3–4).
15. **The whole page has no invalid state anywhere.** Nothing validates, no `aria-invalid`, no `FieldError`, and `aria-invalid:` rules on all four components are unreachable from this page. The port's already-built invalid handling is exercised by `forms`, not here.

---

## 15 · Open questions for the supervisor

1. **The 150 → 250ms socket fix (§7.1, §12.2-1).** Two shipped painters transition at the wrong speed, and the evidence is a measured absence in the built stylesheet plus a live `getComputedStyle` on all six affected elements. **Recommendation: fix `checkbox.dart:238` and `radio.dart:418` to `ElDurations.base`, update the three test pumps, and add a one-line correction note to `forms-map.md` §8.3** so the wrong number does not get re-derived. Because this is a painter-timing change, the phase-3 rule applies: re-pin rendered pixels and keep the probe transcript. **Do you want this landed as part of the selection phase, or split into its own corrective commit ahead of it?**
2. **`ElSlider` scope.** It is a fourth control family, a genuinely new painter, and the nav lists it as two chips ("Slider", "Range Slider"). The page needs: drag, keyboard, single + range, hover/active scale, focus ring, disabled, and the two-coordinate-space geometry. It does **not** need vertical orientation (`data-vertical:*` classes are present and no call site uses them), inversion, or field integration. **Recommendation: build horizontal-only to full parity, skip the vertical branch, and record the omission here.** Confirm.
3. **`bg-action/12` — which port token?** `--primary` and `--color-action` are numerically identical in both themes, so `theme.primary.withValues(alpha: .12)` renders correctly today. But the page *names* `action`, and `--ring` proves the two aliases can diverge per theme. **Recommendation: expose `ElPalette.action` through the page (or add `theme.action`) so the port names the token the reference names.** Needs your call on whether `ElThemeData` grows a field for a raw-palette colour.
4. **The three "unpinned state" gaps (§12.2-2, -3, -4).** Undimmed-inert, forced focus ring, and a 400-weight field label are all small API additions to shipped components. They exist only because a state *matrix* renders states a real form never asks for. **Recommendation: add all three as explicit, documented props rather than letting the page fake them locally** — the next matrix page (`selects`, `feedback`) will want the same two. Confirm you want `lib\` touched for page-driven needs.
5. **Bulk header and option card — shared or page-local?** Both are compositions the reference builds inline out of `div`s and `Label`; neither is exported from `components\ui\`. `ElDividedList` is confirmed unusable for the first (§12.2-8, it is `divide-y` over an opaque card). **Recommendation: build both page-local in `example\lib\pages\selection.dart`.** The gapped-tinted list is one `Column` with `SizedBox(height: ElWidths.hairline)` seams over a transparent parent — small enough that lifting it into `kit.dart` before a second page wants it would be speculative. Confirm you would rather it stay local.
6. **Reproducing drift 3 (the frozen bulk tints).** The demo's row backgrounds are literal classes that do not follow their checkboxes, so clicking a row in the Flutter port must *also* leave the tint alone. That is faithful, it looks like a bug, and §6 don't 4 is the rule it breaks. **Recommendation: reproduce exactly and carry a source comment pointing at this entry**, consistent with ruling F5 on `aria-invalid` beating focus. Confirm.
7. **Reproducing drift 11 (the slider thumb's dead disabled classes).** *(now probed — the question is only what to build.)* The reference dims a disabled slider **once**, at the root; the thumb's `disabled:opacity-50` and `disabled:pointer-events-none` never match a `<span>`. **Recommendation: port the render — one `Opacity(0.5)` and one `IgnorePointer` at the root — and record the dead classes rather than reproducing them.** There is no visible divergence either way, so this is a code-shape call, not a fidelity one.


---

## RESOLVED - 2026-08-15 - §7.1 / §12.2-1 / §15 Q1 landed as a corrective sweep

The 150 -> 250ms socket fix asked for in §15 Q1 was **split into its own
corrective commit ahead of the selection phase**, and widened to the whole
corpus rather than the two files this page surfaced.

**Swept:** every `duration-<token>` className in `components\ui\`,
`components\el\` and `app\design-system\` - 35 occurrences, all of them
`duration-fast`, `duration-base` or `duration-tick`, with **zero**
arbitrary-value `duration-[Nms]` and **zero** numeric `duration-N` anywhere in
the source. Every one renders at `--default-transition-duration` = **0.25s**,
confirmed by computed-style probe across seven routes. Control group in the same
session: `:where(.prose) a` and `slide-pill`'s opacity leg report **0.15s**, so
the finding is the utility mechanism, not a stylesheet-wide flattening.

**Landed:**

- `lib\src\foundation\motion.dart` - new `ElDurations.transitionDefault`
  (250ms), documented with the Tailwind v4 no-op mechanism and cited to the
  probe.
- **Value fixed (150 -> 250ms):** `checkbox.dart`, `radio.dart`,
  `example\lib\kit.dart` (`_CardArrow`), `example\lib\shell.dart`
  (`_ColorFade`, shared by both nav levels), `example\lib\theme_toggle.dart`.
- **Attribution fixed, value unchanged:** `switch.dart` (track and thumb),
  `input.dart`, `input_group.dart`, `input_otp.dart`, `select.dart`,
  `toggle.dart`.
- **Untouched, because they read `var(--duration-*)` directly:** `btn-spring`
  (`button.dart` and `input_group.dart`'s press), `lift.dart`, `press.dart`,
  `sliding_pill.dart`, every `keyframes.dart` member,
  `example\lib\pages\typography.dart` (the prose-link underline - probed at
  0.15s) and the motion page's own token demos.
- **Tests:** the three `pump(ElDurations.fast)` calls plus the two `ElSwitch`
  duration assertions in `test\selection_feedback_test.dart`; a new
  `transitionDefault` pair in `test\foundation_type_motion_test.dart`.
- **Maps:** correction blocks appended to `forms-map.md` (§8.3),
  `inputs-map.md` and `overview-map.md`; "checked, clean" blocks to
  `buttons-map.md` and `motion-map.md`.

**§12.2-1 is closed, and drift 5 is confirmed corpus-wide rather than
page-local.** The remaining §12.2 items - undimmed-inert (2), forced focus ring
(3), `ElFieldLabel` weight (4), `ElSlider` (5), the hover state (6), the option
card (7), the gapped list (8), the page and its route (9-11) - are untouched and
still belong to the selection phase.
