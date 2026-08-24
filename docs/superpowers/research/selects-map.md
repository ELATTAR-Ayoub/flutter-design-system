# Map — `/design-system/components/base/selects` (Base Components · Selects & Pickers)

**This is a delta map.** Phase 3 shipped `ElSelect` at *forms-page* fidelity — a working
overlay menu, measured-confirmed 34.571px rows, the `expand` cascade switch — and
explicitly deferred everything this page is actually about. §3 states line by line what
exists and what is new; §4–§10 spec the new surface; §15 is the build ledger. Read §3
before anything else.

**Files that produce the render** (all under `D:\DESIGN\Design-System-2026-8\design-system\`):
- `app\design-system\components\base\selects\page.tsx` — the page. **`"use client"`**. 485 lines, no page-local components, three `useState` dates and one derived label. Nine `ElSection`s.
- `components\el\kit.tsx` — `ElPageHeader` (:11), `ElSection` (:45), `Panel` (:77, **`note` prop at :79**), `StateGrid` (:145), `StateCell` (:173), `Meta` (:202), `Code` (:229), `DoDont` (:238), `Note` (:274), `PageFootNav` (:348).
- `components\ui\select.tsx` — **all ten exports live on this page** (the forms page used five). `SelectGroup` :16, `SelectLabel` :94, `SelectSeparator` :131, `SelectScrollUpButton` :144, `SelectScrollDownButton` :163 are new here.
- `components\ui\native-select.tsx` — `NativeSelect` (:11), `NativeSelectOption` (:36). A real `<select>`. `NativeSelectOptGroup` (:49) exists and is unused.
- `components\ui\combobox.tsx` — 16 exports; the page uses 5 (`Combobox`, `ComboboxInput`, `ComboboxContent`, `ComboboxEmpty`, `ComboboxList`) + `ComboboxItem`. **Built on `@base-ui/react`, not Radix** — the only component in the corpus that is. §16 drift 21.
- `components\ui\command.tsx` — `Command` (:21), `CommandInput` (:69), `CommandList` (:92), `CommandEmpty` (:108), `CommandGroup` (:121), `CommandSeparator` (:137), `CommandItem` (:150), `CommandShortcut` (:170). Built on `cmdk`.
- `components\ui\calendar.tsx` — `Calendar` (:22) + `CalendarDayButton` (:190). Wraps `react-day-picker`'s `DayPicker` with 25 `classNames` overrides and 4 `components` overrides.
- `components\ui\popover.tsx` — `Popover`/`PopoverTrigger`/`PopoverContent` (:20). Radix.
- `components\ui\input-group.tsx` — `InputGroup` (:11), `InputGroupAddon` (:46), `InputGroupButton` (:86), `InputGroupInput` (:117). The chassis under **both** the combobox input and the command input.
- `components\ui\field.tsx` — `Field` (:75), `FieldGroup` (:41), `FieldLabel` (:104), `FieldDescription` (:134). No `FieldError` on this page: nothing validates.
- `components\ui\button.tsx` — `outline` (:42) and `ghost` (:45); sizes `default` (:61), `sm` (:60), `icon` (:67). No `loading` on this page.
- `components\ui\icon.tsx` — `ChevronDown` ×4 sites, `ChevronUp`, `ChevronLeft`, `ChevronRight`, `Check` ×3 sites, `Search` ×3 sites, **`Calendar` ×2 sites**, `X` (DoDont), `ArrowLeft`/`ArrowRight` (foot nav).
- `lib\el\nav.ts:178–193` — the `selects` category. `siblings("base","selects")` → prev **Forms**, next **Selection Controls**.
- `app\globals.css` — every token below.
- Deps: `radix-ui ^1.6.7` (Select, Popover), **`@base-ui/react ^1.6.0`** (Combobox), **`cmdk ^1.1.1`** (Command), **`react-day-picker ^10.0.1`** + **`date-fns ^4.4.0`** (Calendar), `tailwind-merge ^3.6.0`, `lucide-react ^1.28.0`.

Read with `shared-map.md` (shell, kit anatomy, type-class table, Icon ladder), `forms-map.md`
(§3.2 the field family, §8.1 control geometry, §8.3 motion, §13 tokens, drifts 6/11/16/17),
`icons-map.md` (drift 2 — the `size-4` container override), and `inputs-map.md` (the
`InputGroup` chassis). Nothing there is repeated except where this page consumes it
differently.

**Measurement note.** Values marked *(measured)* were read out of the production stylesheet
`.next\static\chunks\2xoei7gie4yqt.css` by byte offset. Values marked *(derived)* are computed
from tokens read out of that same file and **have not been seen on screen** — every one of
them is a probe item in §17. Values marked *(source)* are read straight out of a dependency's
shipped JS.

---

## 0 · Shell / layout metrics — delta from foundations

Identical shell (`shared-map.md` §1). Specimen column **1080px** at the 1440 frame.

| thing | value | source |
|---|---|---|
| Route | `/design-system/components/base/selects` | `nav.ts:179` + `categoryHref` |
| Panel body inner width | **1030px** (1080 − 2 border − 48 `p-6`) | `kit.tsx:96,108` |
| `max-w-sm` — §1, §2 `FieldGroup`; §3 `div` | **384px** (`--container-sm: 24rem`) *(measured, byte 2903 / 40226)* | page:111, 201, 225 |
| `max-w-xs` — §7 `FieldGroup` | **320px** (`--container-xs: 20rem`) *(measured, byte 2882 / 40306)* | page:337 |
| `w-40` — the three state-cell triggers | **160px** (`calc(--spacing * 40)`, `--spacing: .25rem`) *(measured, byte 38752 / 2843)* | page:166, 176, 186 |
| §6 / §7 `grid gap-4 lg:grid-cols-2` | 2 × **532px** at 1080 (`(1080 − 16)/2`); `lg` = 1024 is met *(derived)* | page:305, 335 |
| §1 `StateGrid cols={3}` cell | **358.667px** (`(1080 − 2 border − 2×1px gap)/3`) *(derived)* | `kit.tsx:157,161` |
| Section rhythm | `mb-20` (80px); heading block `mb-6`; top `Note` `mb-12`; `StateGrid` `mt-4`; §3 caption `mt-5`; §7 right column `space-y-4` | — |

`el()` in the port is `n * 4.0` (`spacing.dart:14`) and `--spacing` is never redeclared, so
every `*-N` above ports as `el(N)` with no conversion.

---

## 1 · Page header (`ElPageHeader`)

`<header class="mb-14 border-b border-border pb-10">` (`kit.tsx:23`).

1. Eyebrow `type-label text-action-ink` → **"Base Components · Base"** — `` eyebrow={`${group.title} · Base`} `` (page:90) with `group.title = "Base Components"` (`nav.ts:561`). Separator U+00B7. Same on all fourteen base pages; §16 drift 1.
2. `type-h1 mt-4` → **"Selects & Pickers"** (a literal `&` in the source string, `nav.ts:180`).
3. `type-lead mt-4 max-w-2xl` → **"Choosing from a known set — menus, comboboxes, command palette and dates."** (em dash U+2014).
4. Chips `ul.mt-7 flex flex-wrap gap-2`, each `type-chip rounded-pill border border-border bg-card px-3 py-1.5 text-muted-foreground`. Verbatim, in order:
   **Select · Native Select · Combobox · Command Palette · Calendar · Date Range · Date Picker**
   Seven chips. **They do not match the section titles**: the chips say "Command Palette" and the section is titled "Command palette"; the chips say "Native Select" and the section title agrees. Six of seven line up; §4's differs in case only.

`example\lib\nav.dart:239–255` already carries all of this byte-for-byte, including the
source comment about ordering the two raw calendar modes before the recipe. `siblings()`
resolves (`nav.dart:731–747`).

---

## 2 · Section inventory (verbatim)

One top-level `Note` **before** the first section, then nine `ElSection`s, then `PageFootNav`.
`ElSection` shell: `<section id class="mb-20">`; `<h2 class="type-h3">`; description
`type-small mt-2 max-w-2xl`.

**Pre-section `Note`** — `tone="action"`, `className="mb-12"`, title **"Choosing the right one"** (page:96–103). Copy in §12.1.

| # | `id` | title | description (verbatim) |
|---|---|---|---|
| 1 | `select` | **Select** | A fixed set of options with one selected. The trigger shows the current value, never a placeholder pretending to be a label. |
| 2 | `native` | **Native Select** | Renders the operating system's own picker. Correct for country, region, timezone and other long, uninteresting lists — especially on mobile. |
| 3 | `combobox` | **Combobox** | A select the user can type into. Used for card sets, pack names and any list long enough that scrolling is worse than typing. |
| 4 | `command` | **Command palette** | Keyboard-first navigation across the whole product. Opened with Ctrl+K from anywhere, and the fastest route for a returning collector. |
| 5 | `calendar` | **Calendar** | Used for filtering the Stash by date acquired, and transaction history in the Wallet. Never for anything the user has to type. |
| 6 | `date-range` | **Date Range** | The same Calendar in range mode: a start, an end, and every day between them marked. Used for the Wallet's statement period and any “between these dates” filter. |
| 7 | `date-picker` | **Date Picker** | A Calendar inside a Popover, behind a trigger that shows the current value. The most common date control there is, and the one shadcn documents as a recipe rather than a file. |
| 8 | `api` | **API** | *(none)* |
| 9 | `rules` | **Rules** | *(none)* |

Apostrophes in §2 and §6 descriptions are **straight** `'`; the quotes around "between these
dates" in §6 are **curly** U+201C/U+201D; the dashes in §2 and §6 are U+2014.

Per-section children, in DOM order:

| § | children |
|---|---|
| 1 | `Panel label="Sort and filter selects"` → `FieldGroup.max-w-sm` (2 Fields) · `StateGrid cols={3} mt-4` (3 cells) |
| 2 | `Panel label="Native select"` → `FieldGroup.max-w-sm` (1 Field) |
| 3 | `Panel label="Filter by card set"` → `div.max-w-sm` → Combobox · `<p class="type-small mt-5">` |
| 4 | `Panel label="Command palette" note="Ctrl + K"` → `Command` |
| 5 | `Panel label="Single"` → `Calendar mode="single"` |
| 6 | `div.grid.gap-4.lg:grid-cols-2` → [`Panel label="Range" note={rangeLabel}` → `Calendar mode="range"`] + [`Note tone="action"`] |
| 7 | `div.grid.gap-4.lg:grid-cols-2` → [`Panel label="Every state"` → `FieldGroup.max-w-xs`] + [`div.space-y-4` → `Note tone="error"` + `Meta` (4)] |
| 8 | `Meta` (5 items), no Panel |
| 9 | `DoDont` (5 dos, 4 don'ts), no Panel |

**§1 is the only section with a `StateGrid`. §6 and §7 are the only two-column sections.
§8 and §9 have no description and no Panel. There is no `DoDont` anywhere but §9.** Panel
`note` is used twice on this page and never on the forms page — the port's `ElPanel` already
takes it (`kit.dart:246`).

`rangeLabel` (page:82–85) is derived, not literal:
```
range?.from && range?.to
  ? `${format(range.from, "d MMM")} – ${format(range.to, "d MMM")}`
  : "Pick two dates"
```
With the seeded range → **"12 Jul – 20 Jul"**. The separator is U+2013 EN DASH, not a hyphen.

---

## 3 · What phase 3 already shipped — the `ElSelect` delta

`lib\src\components\select.dart` is scoped by its own library doc (`:5–8`) to *"the fidelity
the forms page renders"* and names this page as the owner of the rest. That promise is now
due.

### 3.1 · Shipped and unchanged — reuse as-is

| shipped | where | verified by |
|---|---|---|
| Trigger 40 / 32px (`data-size` default / sm), pill, `--input` border, `--card` fill | `select.dart:99–112`, `:408–421` | `test\selection_feedback_test.dart:529` |
| Permanent `shadow-pressed` socket via `ElMachineSurface` | `select.dart:408–415` | `selection_feedback_test.dart:537–539` |
| `pl-4 pr-3.5`, `gap-2`, 13px `sheetBody`, chevron 16px muted | `select.dart:418`, `:426–444` | — |
| `transition-colors` on fill / border / ring at **250ms** `ElCurves.out` | `select.dart:378`, `:393–425` | — |
| Focus ring `ring/50`; invalid border + ring incl. the two `dark:` alphas; **invalid beats focus** | `select.dart:70–78`, `:353–373` | `selection_feedback_test.dart:640–654` |
| `disabled:opacity-50` + `IgnorePointer` | `select.dart:81`, `:473–476` | — |
| `data-placeholder:text-muted-foreground` | `select.dart:434` | `selection_feedback_test.dart:543` |
| Dark-only hover fill `--input` 30 % → 50 % (drift 17/18) | `select.dart:346–351` | `selection_feedback_test.dart:658–678` |
| `expand` — the `w-fit` ↔ `*:w-full` switch (drift 11) | `select.dart:167–172`, `:428`, `:450` | `example\test\forms_page_test.dart:984–991` |
| Overlay menu, `position="item-aligned"` placement | `select.dart:497–534` | `forms_page_test.dart:1086–1093` |
| Content `min-w-36`, `rounded-lg`, `ElShadows.tailwindMd` + 1px `foreground/10` ring, viewport `p-2` | `select.dart:88–96`, `:598–614` | `selection_feedback_test.dart:627` |
| Item `py-2 pl-3 pr-9`, `rounded-md`, `accent` highlight, right-3 16px tick, **34.571px** | `select.dart:658–708` | `selection_feedback_test.dart:579–599` |
| `ElSelect.itemHeight` derived from the type spec, not measured | `select.dart:194–197` | `selection_feedback_test.dart:581` |
| Keyboard: ↑ ↓ Home End Enter Space Escape Tab, wrapping over disabled rows | `select.dart:289–340` | `selection_feedback_test.dart:601`, `:616` |
| Outside-tap dismiss + focus restore | `select.dart:274–280`, `:543–548` | — |
| **No open/close animation** (drift 10) | `select.dart:25–31` | `selection_feedback_test.dart:569` |
| `ElFieldScope` integration + label-for activation | `select.dart:218–227`, `:382` | `forms_page_test.dart:1043–1051` |

The row-height derivation is exact and already load-bearing:
`13 × (1.25/0.875) + el(2)×2 = 18.5714 + 16 = **34.5714px**`, matching
`--text-sm: var(--text-small)` = 13px *(measured, byte 3169: `--text-sm--line-height: calc(1.25 / .875)`)*.

### 3.2 · Deferred by phase 3 — what this page now demands

| # | need | reference | why it is not a small edit |
|---|---|---|---|
| 1 | **`SelectGroup` + `SelectLabel`** | page:119–130; `select.tsx:16`, `:94` | Label is `px-3 py-2 text-xs text-muted-foreground` → **32px** *(derived: 12 × 1.3333 + 16)*. Group carries `scroll-my-2` (8px scroll margin, no paint). |
| 2 | **`SelectSeparator`** | page:125; `select.tsx:131` | `-mx-2 my-2 h-px bg-border` → 1px rule that **bleeds through the viewport's 8px padding to the full content width**, plus 8px above and below = **17px** of vertical space. |
| 3 | **Scroll up / down buttons** | `select.tsx:144`, `:163` | `flex items-center justify-center bg-popover py-2` + a 16px chevron → **32px** each. They mount inside `SelectContent`, outside the `Viewport`, and only paint when the viewport overflows. |
| 4 | **A trigger width that is neither `w-fit` nor `w-full`** | page:166, 176, 186 (`className="w-40"`) | `ElSelect.expand` is a `bool`. `w-40` = 160px is a third case; twMerge kills `w-fit` before CSS sees it. |
| 5 | **Item-aligned placement over a heterogeneous list** | page:118–131 | `_placement()` (`select.dart:508–510`) computes the chosen row's centre as `el(2) + (index + 0.5) × itemHeight`. With a 32px label, three rows, a 17px separator, a second 32px label and two rows, that arithmetic is wrong. It must become a running offset over a typed child list. **This is the sharpest technical delta on the page.** |
| 6 | **Content scrolling with the two buttons** | `select.tsx:73`, `:78`, `:88` | Today: a bare `SingleChildScrollView` (`select.dart:617`). The reference caps at `max-h-(--radix-select-content-available-height)` and paints buttons instead of a rail. |
| 7 | **An empty `SelectContent`** | page:189 (`<SelectContent />`) | `_openMenu` early-returns on `options.isEmpty` (`select.dart:263`), so nothing opens — which happens to match, because that cell is also `disabled`. Confirm intent (§17 Q5). |
| 8 | **`aria-label` on a trigger with no visible label** | page:166, 176, 186 | `ElSelect.label` already exists (`select.dart:181`). No work — but the page is the first consumer. |
| 9 | **The disabled trigger as a rendered specimen** | page:184–191 | Implemented; needs a state cell to render it. |

Everything else in §4–§10 is **new components**, not deltas.

---

## 4 · §1 Select — the full surface

### 4.1 · `SelectTrigger` (`select.tsx:35–59`) — verbatim class list

```
flex w-fit items-center justify-between gap-2 rounded-pill border border-input bg-card
py-2 pr-3.5 pl-4 text-sm shadow-pressed whitespace-nowrap transition-colors outline-none
select-none focus-visible:border-ring focus-visible:ring-3 focus-visible:ring-ring/50
disabled:cursor-not-allowed disabled:opacity-50 aria-invalid:border-destructive
aria-invalid:ring-3 aria-invalid:ring-destructive/20 data-placeholder:text-muted-foreground
data-[size=default]:h-10 data-[size=sm]:h-8 *:data-[slot=select-value]:line-clamp-1
*:data-[slot=select-value]:flex *:data-[slot=select-value]:items-center
*:data-[slot=select-value]:gap-2 dark:bg-input/30 dark:hover:bg-input/50
dark:aria-invalid:border-destructive/50 dark:aria-invalid:ring-destructive/40
[&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4
```

Fully ported already (§3.1). `w-fit` is **dead on this page in both directions**: inside the
Panel's vertical `Field` the field's `*:w-full` wins *(measured — `.w-fit` byte 39230, `*:w-full > *` byte 106378)*; in the state cells `w-40` wins through twMerge. §16 drift 10.

### 4.2 · The two Panel fields (page:111–160)

| field | label | value | placeholder | description | trigger width |
|---|---|---|---|---|---|
| `s-sort` | **Sort by** | `defaultValue="popular"` → shows **Most popular** | *(none — `<SelectValue />`)* | Grouped with labels so long option lists stay scannable. | **384px** |
| `s-rarity` | **Minimum rarity** | *(uncontrolled, empty)* | **Any rarity** | *(none)* | **384px** |

`FieldGroup` is `flex flex-col gap-5` → **20px** between the two fields. `Field` is
`flex-col gap-2` → **8px** between label, control and description.

**`s-sort` menu content, in DOM order** (page:118–131):

| row | kind | text | height *(derived)* |
|---|---|---|---|
| — | viewport `p-2` | — | 8 |
| 1 | `SelectLabel` | **Activity** | 32 |
| 2 | `SelectItem value="popular"` | **Most popular** | 34.571 |
| 3 | `SelectItem value="newest"` | **Newest** | 34.571 |
| 4 | `SelectItem value="volatility"` | **Volatility** | 34.571 |
| 5 | `SelectSeparator` | — | 17 |
| 6 | `SelectLabel` | **Price** | 32 |
| 7 | `SelectItem value="low"` | **Price: low to high** | 34.571 |
| 8 | `SelectItem value="high"` | **Price: high to low** | 34.571 |
| — | viewport `p-2` | — | 8 |
| | | **total** | **269.857** |

**`s-rarity` menu**: six flat items (`Common Uncommon Rare Epic Legendary Mythic`, values
lowercased by `r.toLowerCase()`), no groups → `8 + 6 × 34.571 + 8 = **223.429px** ` *(derived)*.

Item-aligned placement puts the **chosen** row over the trigger; with nothing chosen
(`s-rarity`) the **first** row takes that place (`select.dart:33–35`). For `s-sort` the chosen
row is index 0 of group 1, which sits **at offset 8 + 32 = 40px** into the content — not
`8 + 0.5 × 34.571`. That is delta #5 in §3.2, stated numerically.

### 4.3 · `SelectLabel` / `SelectSeparator` / scroll buttons — computed

| part | classes (verbatim) | computed |
|---|---|---|
| `SelectLabel` (`select.tsx:101`) | `px-3 py-2 text-xs text-muted-foreground` | 12px sans, **weight 400** (no `font-*`), line box **16px** *(derived: 12 × `calc(1/.75)`, measured byte 3104)*, box **32px**, 12px h-padding, `--muted-foreground` |
| `SelectGroup` (`select.tsx:23`) | `scroll-my-2` | `scroll-margin-block: 8px` *(measured, byte 53550)* — affects `scrollIntoView` only, paints nothing |
| `SelectSeparator` (`select.tsx:138`) | `pointer-events-none -mx-2 my-2 h-px bg-border` | 1px `--border`; `-mx-2` cancels the viewport's `p-2` so the rule runs the **full content width**; 8px above + 8px below |
| `SelectScrollUpButton` (`select.tsx:152`) | `z-10 flex cursor-default items-center justify-center bg-popover py-2 [&_svg:not([class*='size-'])]:size-4` | **32px** tall, opaque `--popover`, `ChevronUp` at 16px / stroke 2.4, tone `inherit` → `--popover-foreground` |
| `SelectScrollDownButton` (`select.tsx:171`) | identical + `ChevronDown` | **32px** |

Both buttons are siblings of the `Viewport`, **inside** `SelectContent` — so they sit above and
below the padded scroll area and cover it, which is why they carry `bg-popover`.

### 4.4 · §1 `StateGrid cols={3}` (page:163–192)

`grid gap-px overflow-hidden rounded-lg border border-border bg-border` + `grid-cols-2 sm:grid-cols-3`.
The 1px gaps are the `bg-border` showing through between opaque `bg-background p-5` cells;
there are no cell borders. `StateCell` stage is `mb-4 flex min-h-14 items-center justify-center`
(**56px** min, 16px below); label `type-micro text-center text-muted-foreground`.

| cell | label | trigger | `aria-label` | shows | content |
|---|---|---|---|---|---|
| 1 | **Default** | `w-40`, no value | `Default` | placeholder **Any rarity**, muted | 1 item, `Common` |
| 2 | **Selected** | `w-40`, `defaultValue="a"` | `Selected` | **Legendary**, foreground | 1 item, `Legendary` |
| 3 | **Disabled** | `w-40`, `<Select disabled>` | `Disabled` | placeholder **Unavailable**, whole trigger at `opacity-50`, `cursor-not-allowed` | **`<SelectContent />` — empty** |

No `note` on any of the three cells. Nothing here is a still: cells 1 and 2 open a real
one-row menu.

---

## 5 · §2 NativeSelect

### 5.1 · Verbatim classes (`native-select.tsx:19`, `:28`, `:31`, `:43`)

Wrapper (`div[data-slot=native-select-wrapper]`):
```
group/native-select relative w-fit has-[select:disabled]:opacity-50
```
The `<select>`:
```
h-8 w-full min-w-0 appearance-none rounded-lg border border-input bg-transparent py-1 pr-8
pl-2.5 text-sm transition-colors outline-none select-none selection:bg-primary
selection:text-primary-foreground placeholder:text-muted-foreground focus-visible:border-ring
focus-visible:ring-3 focus-visible:ring-ring/50 disabled:pointer-events-none
disabled:cursor-not-allowed aria-invalid:border-destructive aria-invalid:ring-3
aria-invalid:ring-destructive/20 data-[size=sm]:h-7
data-[size=sm]:rounded-[min(var(--radius-md),10px)] data-[size=sm]:py-0.5 dark:bg-input/30
dark:hover:bg-input/50 dark:aria-invalid:border-destructive/50
dark:aria-invalid:ring-destructive/40
```
Chevron: `pointer-events-none absolute top-1/2 right-2.5 size-4 -translate-y-1/2 text-muted-foreground select-none`, `aria-hidden="true"`.
`<option>`: `bg-[Canvas] text-[CanvasText]` — CSS system colours; the OS paints the list.

### 5.2 · Computed geometry

| property | value | note |
|---|---|---|
| height | **32px** (`h-8`) | The Select beside it is 40. §16 drift 8. |
| radius | **12px** (`rounded-lg`) | Not a pill. The only non-pill control in the family. |
| fill | **transparent** (light) / `--input` @ 30 % (dark), hover 50 % (dark) | No `--card`, **no `shadow-pressed`** — the only control in the family with no socket. |
| border | 1px `--input` | |
| padding | `py-1 pr-8 pl-2.5` → 4 / 32 / 10 | The 32px right gutter is the chevron's room (10px inset + 16px glyph + 6px). |
| type | 13px `text-sm` | |
| chevron | 16px `--muted-foreground`, 10px from the right edge, vertically centred | |
| disabled | wrapper `opacity-50`; control `pointer-events-none cursor-not-allowed` | The dim is on the **wrapper**, not the control. |
| width | `w-fit` on the wrapper, but it is a direct child of a vertical `Field` → `*:w-full` wins → **384px** | Same cascade as drift 11. |

### 5.3 · The field (page:202–214)

Label **Country** (`htmlFor="ns"`), `defaultValue="us"`, description **"Used in shipping and
account settings."** Five options, verbatim, in order:
`us` → **United States** · `gb` → **United Kingdom** · `ca` → **Canada** · `de` → **Germany** · `jp` → **Japan**.

**This is the one specimen on the page whose whole point is that the platform draws it.** The
port question is §17 Q6.

---

## 6 · §3 Combobox

### 6.1 · The primitive

`@base-ui/react` v1.6.0, not Radix. Relevant defaults *(source, `combobox/root/AriaCombobox.d.ts`)*:

| prop | default | consequence here |
|---|---|---|
| `mode` | `'list'` | items are filtered by the query; the input value never changes from the highlight |
| `openOnInputClick` | `true` | clicking the input opens the popup |
| `autoHighlight` | `false` | **nothing is highlighted until the user presses an arrow key** |
| `alwaysSubmitOnEnter` / `grid` / `modal` / `virtualized` | `false` | — |
| `loop` | `true` | arrow keys wrap through the input, per APG |
| `highlightItemOnHover` | `true` | hover sets `data-highlighted` |
| `limit` | `-1` | no cap |

**The default filter** *(source, `internals/filter.js:10–35`)*:
```
new Intl.Collator(locale, { usage: 'search', sensitivity: 'base', ignorePunctuation: true })
contains(item, query): slides a window of query.length over the item label and returns true
                       on the first collator.compare(...) === 0; an empty query matches all
```
`sensitivity: 'base'` means **case-insensitive and accent-insensitive**; `ignorePunctuation: true`
means punctuation is skipped on both sides. The query is `String(inputValue).trim()`
(`AriaCombobox.js:195`). There is one bypass: in single-selection mode, before the query has
changed since opening, the list is *not* narrowed to the already-selected label
(`AriaCombobox.js:198`).

`SETS` (page:65–72), verbatim, in order:
**Eclipse Vault · Golden Rift · Mystic Surge · Shadow Core · Celestial Strike · Origin Pulse**

### 6.2 · `ComboboxInput` → `InputGroup` chassis

`ComboboxInput` (`combobox.tsx:53–88`) renders `<InputGroup className="w-auto">` holding the
base-ui input, plus an `InputGroupAddon align="inline-end"` holding an
`InputGroupButton size="icon-xs" variant="ghost"` wrapping `ComboboxTrigger`.
`showTrigger` defaults **true**, `showClear` defaults **false** — so the clear "×" the
component ships is **not on this page**.

| part | classes | computed |
|---|---|---|
| `InputGroup` (`input-group.tsx:17`) | `relative flex h-10 w-full min-w-0 items-center rounded-pill border border-input bg-card shadow-pressed transition-[box-shadow,border-color] duration-base ease-out outline-none` | **40px**, pill, `--input` border, `--card`, `shadow-pressed`, **250ms `--ease-out`** on shadow + border only |
| | `w-full` → `w-auto` via twMerge | block-level flex → still fills the 384px column *(derived)* |
| focus | `has-[[data-slot=input-group-control]:focus-visible]:border-ring` + `:ring-3` + `:ring-ring/50` | the ring is on the **group**, not the input |
| invalid | `has-[[data-slot][aria-invalid=true]]:border-destructive` + `ring-3 ring-destructive/20`, dark `/40` | unreachable on this page |
| `InputGroupInput` (`:125`) | `flex-1 rounded-none border-0 bg-transparent shadow-none ring-0 focus-visible:border-transparent focus-visible:ring-0` | an `Input` with its own chrome switched off; keeps `Input`'s `px-4` |
| group → input padding | `has-[>[data-align=inline-end]]:[&>input]:pr-2` | the input's right padding drops to **8px** |
| `InputGroupAddon align="inline-end"` (`:33`) | `order-last pr-4 has-[>button]:-mr-0.5` | 16px right padding, pulled back **2px** because it holds a button |
| `InputGroupButton size="icon-xs"` (`:76`) | `size-6 rounded-[calc(var(--radius)-3px)] p-0 has-[>svg]:p-0` | **24 × 24**, radius **7px** (`--radius: 10px`, *measured byte 242912*) — the port already has this as **`ElRadii.addonButton`** (`spacing.dart:125`) |
| chevron | `pointer-events-none size-4 text-muted-foreground` | 16px, muted |
| placeholder | **"Search card sets"** | |

The button also carries `group-has-data-[slot=combobox-clear]/input-group:hidden` (no clear
here, so it stays) and `data-pressed:bg-transparent`.

### 6.3 · `ComboboxContent` / `List` / `Item` / `Empty`

| part | classes (verbatim, abridged to what paints) | computed |
|---|---|---|
| Positioner (`:105–111`) | `side="bottom" sideOffset={6} align="start"` + `isolate z-50` | **6px** below the input, left-aligned |
| Popup (`:116`) | `max-h-(--available-height) w-(--anchor-width) max-w-(--available-width) min-w-[calc(var(--anchor-width)+--spacing(7))] origin-(--transform-origin) overflow-hidden rounded-lg bg-popover text-popover-foreground shadow-md ring-1 ring-foreground/10` | **min-width wins over width**: anchor + 28px = **412px** for a 384px input *(derived)*. 12px radius, `--popover`, Tailwind-stock `shadow-md`, 1px `foreground/10` ring |
| Popup motion | `data-open:animate-in data-open:fade-in-0 data-open:zoom-in-95 data-closed:animate-out data-closed:fade-out-0 data-closed:zoom-out-95 data-[side=bottom]:slide-in-from-top-2` | **320ms `--ease-out`** — *not* cancelled. §16 drift 9 |
| `ComboboxList` (`:129`) | `no-scrollbar max-h-[min(calc(--spacing(72)---spacing(9)),calc(var(--available-height)---spacing(9)))] scroll-py-1 overflow-y-auto overscroll-contain p-1 data-empty:p-0` | cap **252px** (288 − 36); 4px padding; **scrollbar hidden** (`no-scrollbar` comes from `shadcn/dist/tailwind.css:88`, not `globals.css` — `-ms-overflow-style: none; scrollbar-width: none;` + a `::-webkit-scrollbar { display: none }`) |
| `ComboboxItem` (`:146`) | `relative flex w-full cursor-default items-center gap-2 rounded-md py-1 pr-8 pl-1.5 text-sm data-highlighted:bg-accent data-highlighted:text-accent-foreground data-disabled:pointer-events-none data-disabled:opacity-50` | **26.571px** (`4 + 18.571 + 4`) *(derived)*, `pr-8` = 32, `pl-1.5` = 6, radius 10 |
| indicator (`:154`) | `pointer-events-none absolute right-2 flex size-4 items-center justify-center` + `CheckIcon` | 16px tick, **8px** from the right (the Select's is 12px) |
| `ComboboxEmpty` (`:197`) | `hidden w-full justify-center py-2 text-center text-sm text-muted-foreground group-data-empty/combobox-content:flex` | **34.571px**, centred, muted; mounts only when the popup is `data-empty` |

Popup height with all six items: `4 + 6 × 26.571 + 4 = **167.43px** ` *(derived)*, well under the
252px cap — so **the combobox never scrolls on this page** and its hidden scrollbar never
matters. Empty state: list collapses to `p-0`, the Empty row shows **"No matching set."**

Caption under the Panel (page:240–243), `type-small mt-5`:
> Typing narrows the list. The empty state says what happened rather than showing a blank panel.

---

## 7 · §4 Command palette

### 7.1 · The primitive

`cmdk` v1.1.1. `shouldFilter` defaults **true**, which per its own d.ts (`dist/index.d.ts:29–31`)
means *"automatic filtering **and sorting**"*. The scorer is `commandScore` — a fuzzy
subsequence matcher with weighted penalties *(source, `dist/command-score.js`)*:

```
1      exact / continuation        0.9   case mismatch
0.8    word-boundary start         0.17  skipped character
0.1    ...                         0.999 / 0.9999 / 0.99  length-decay factors
word separators: /[\\\/_+.#"@\[\(\{&]/    space separators: /[\s-]/
```

Items on this page carry **no `value` prop**, so cmdk derives each item's value from its
rendered text content. The palette is **inline, always open, never in a dialog** — `Command`
is rendered directly, not `CommandDialog`.

**cmdk auto-selects the first item on mount**, so **"Eclipse Vault" carries `data-selected` at
rest** → `bg-muted text-foreground`, and its `CommandShortcut` flips to `text-foreground`. That
is a *static, visible* state the port must render on first paint.

### 7.2 · Anatomy and computed geometry

| part | classes (verbatim, abridged) | computed |
|---|---|---|
| `Command` (`command.tsx:29`) + page override | base `flex size-full flex-col overflow-hidden rounded-xl! bg-popover p-2 text-popover-foreground`; page adds `rounded-lg border border-border bg-card` | twMerge resolves **before** CSS: `rounded-xl!` → **`rounded-lg` 12px**, `bg-popover` → **`bg-card`**. The `!` never reaches the stylesheet. §16 drift 12, **probe item §17 Q7** |
| `CommandInput` wrapper (`:74`) | `p-2 pb-0` | 8px sides and top, 0 bottom |
| its `InputGroup` (`:75`) | `h-8! rounded-lg! border-input/30 bg-input/30 shadow-none! *:data-[slot=input-group-addon]:pl-2!` | **32px**, radius **12px**, **no socket at all**, `--input` @ 30 % fill and border, addon left padding **8px**. `shadow-pressed` and `rounded-pill` both lose through twMerge — the exact bug `lib\utils.ts` was extended to fix |
| addon | default `align="inline-start"` → `order-first` | the Search glyph renders **left of** the input despite being written after it |
| search glyph (`:85`) | `size-4 shrink-0 opacity-50`, `Icon` default tone `inherit` | 16px, **`--foreground` at 50 %**, not `--muted-foreground` |
| `CommandPrimitive.Input` (`:79`) | `w-full text-sm outline-hidden` | raw `<input>`, no `Input` component → no `px-4`. Placeholder **"Search packs, cards and actions…"** (U+2026) |
| `CommandList` (`:100`) | `no-scrollbar max-h-72 scroll-py-1 overflow-x-hidden overflow-y-auto outline-none` | cap **288px** *(measured, byte 36339)*, scrollbar hidden |
| `CommandEmpty` (`:115`) | `py-6 text-center text-sm` | **66.571px** (`24 + 18.571 + 24`) *(derived)*, **"Nothing matches that."** |
| `CommandGroup` (`:129`) | `overflow-hidden p-2 text-foreground` + heading `px-3 py-2 text-xs font-medium text-muted-foreground` | 8px group padding; heading **32px**, 12px h-padding, 12px type, **weight 500** |
| `CommandSeparator` (`:144`) | `-mx-2 h-px bg-border` | 1px, full-bleed, **no vertical margin** — unlike `SelectSeparator`'s `my-2`. §16 drift 7 |
| `CommandItem` (`:159`) | `relative flex cursor-default items-center gap-2 rounded-md px-3 py-2 text-sm data-selected:bg-muted data-selected:text-foreground data-[disabled=true]:opacity-50 data-selected:*:[svg]:text-foreground` | **34.571px**, radius 10, 12px h-padding, highlight is **`--muted`** — a third highlight token on one page. §16 drift 5 |
| trailing check (`:165`) | `ml-auto opacity-0 group-has-data-[slot=command-shortcut]/command-item:hidden group-data-[checked=true]/command-item:opacity-100` | **`display:none` on all four items** — every one carries a shortcut. §16 drift 13 |
| `CommandShortcut` (`:178`) | `ml-auto text-xs tracking-widest text-muted-foreground group-data-selected/command-item:text-foreground` | 12px **sans**, letter-spacing **0.1em** *(measured, byte 3532: `--tracking-widest: .1em`)* |

### 7.3 · Content, verbatim (page:253–281)

| group | item | leading icon | shortcut |
|---|---|---|---|
| **Packs** | Eclipse Vault | `Icon Search size="sm" tone="subtle"` | `$48.00` |
| | Golden Rift | `Icon Search size="sm" tone="subtle"` | `$120.00` |
| *(separator)* | | | |
| **Actions** | Open Wallet | *(none)* | `⌘W` (U+2318 + W) |
| | Go to Stash | *(none)* | `⌘S` (U+2318 + S) |

The two `Search` glyphs are `size="sm"` (14px attribute) but the item's
`[&_svg:not([class*='size-'])]:size-4` forces **16px** while `strokeWidth` stays at the 14px-derived
**2.4** — already recorded as `icons-map` drift 2; it fires four more times on this page.
`tone="subtle"` → `--muted-foreground`.

Palette height, all four rows visible *(derived)*:
`8 (p-2) + 8 + 32 (input) + [8 + 32 + 2×34.571 + 8] + 1 (sep) + [8 + 32 + 2×34.571 + 8] + 8 + 2 (border) = **293.29px** `.

`Panel note="Ctrl + K"` renders `type-num-sm text-muted-foreground` at the right of the header
strip. **Nothing binds it** — §16 drift 3.

---

## 8 · §5–§7 Calendar

`react-day-picker` v10 + `date-fns` v4. This is the largest new surface on the page and it has
no analogue anywhere in the port.

### 8.1 · The initial-month rule — read this first

*(source, `react-day-picker/dist/cjs/helpers/getInitialMonth.js`)*:
```
initialMonth = month || defaultMonth || today          // then clamped by navStart/navEnd
return startOfMonth(initialMonth)
```
**The page passes neither `month` nor `defaultMonth` to any of its three calendars.** So all
three open on **the reader's current month**, regardless of what `selected` holds:

| § | `selected` | month rendered on 2026-08-15 | selection visible? |
|---|---|---|---|
| 5 Calendar | `new Date(2026, 6, 30)` = 30 Jul 2026 | **August 2026** | **no** |
| 6 Date Range | 12 Jul → 20 Jul 2026 | **August 2026** | **no** (Panel note still prints "12 Jul – 20 Jul") |
| 7 Date Picker | `new Date(2026, 6, 30)` | **August 2026** | **no** (trigger still prints "30 Jul 2026") |

The dates were seeded in July 2026 and the page has silently drifted out from under them.
**The page's rendered height is therefore date-dependent**: July 2026 needs 5 week rows,
August 2026 needs 6 (1 Aug 2026 is a Saturday; with `showOutsideDays` and a Sunday week start
the grid runs 26 Jul → 5 Sep). One extra row is `8 (mt-2) + 28 (cell) = **36px** ` per calendar,
×3 calendars — except the third is in a popover and does not affect document height.
§16 drift 2, §17 Q2 — **this decides whether the vertical-parity probe can pin this route at all.**

### 8.2 · Root and the two CSS variables

`Calendar` root classes (`calendar.tsx:41`):
```
group/calendar bg-background p-2 [--cell-radius:var(--radius-md)] [--cell-size:--spacing(7)]
in-data-[slot=card-content]:bg-transparent in-data-[slot=popover-content]:bg-transparent
```
- `--cell-size` = `el(7)` = **28px**; `--cell-radius` = `--radius-md` = **10px** *(measured, byte 3674)*.
- §5 / §6 add `rounded-lg border border-border bg-card p-3` → twMerge: `bg-background`→`bg-card`, `p-2`→**`p-3` (12px)**.
- §7 passes **no** className, so it keeps `p-2` (8px) and `in-data-[slot=popover-content]:bg-transparent` makes it **transparent** over the popover's `--popover`.

### 8.3 · The `classNames` map (`calendar.tsx:53–142`), computed

| slot | classes (verbatim) | computed |
|---|---|---|
| `root` | `w-fit` | shrink-to-fit |
| `months` | `relative flex flex-col gap-4 md:flex-row` | 16px |
| `month` | `flex w-full flex-col gap-4` | **16px** between caption and grid |
| `nav` | `absolute inset-x-0 top-0 flex w-full items-center justify-between gap-1` | overlays the caption row |
| `button_previous` / `button_next` | `buttonVariants({variant:"ghost"})` + `size-(--cell-size) p-0 select-none aria-disabled:opacity-50` | **28 × 28** ghost pill, chevron 16px |
| `month_caption` | `flex h-(--cell-size) w-full items-center justify-center px-(--cell-size)` | **28px** tall, **28px** horizontal padding (the nav buttons' room) |
| `caption_label` | `font-medium select-none text-sm` (`captionLayout="label"`) | 13px / 500. Text = `DateLib.formatMonthYear` → **"August 2026"** *(source, `DateLib.js:521`; en-US falls to the non-year-first branch)* |
| `month_grid` | `w-full border-collapse` | |
| `weekdays` / `weekday` | `flex` / `flex-1 rounded-(--cell-radius) text-sm font-normal text-muted-foreground select-none` | header row **18.571px**; text = `format(d, "cccccc")` → **Su Mo Tu We Th Fr Sa** *(source, `formatters/formatWeekdayName.js`; default locale `enUS`, `DateLib.js:461`)* |
| `week` | `mt-2 flex w-full` | **8px** between rows |
| `day` (`<td>`) | `group/day relative aspect-square h-full w-full rounded-(--cell-radius) p-0 text-center select-none` + `[&:first-child[data-selected=true]_button]:rounded-l-(--cell-radius)` / `[&:last-child…]:rounded-r-…` | square, min 28px |
| `range_start` | `relative isolate z-0 rounded-l-(--cell-radius) bg-muted after:absolute after:inset-y-0 after:right-0 after:w-4 after:bg-muted` | 10px left radius, `--muted`, plus a **16px muted bleed to the right** so the band is continuous across the cell gap |
| `range_middle` | `rounded-none` | |
| `range_end` | mirrored — `rounded-r-…`, `after:left-0 after:w-4` | 16px bleed left |
| `today` | `rounded-(--cell-radius) bg-muted text-foreground data-[selected=true]:rounded-none` | a 10px muted square **behind** a pill button. §16 drift 25 |
| `outside` | `text-muted-foreground aria-selected:text-muted-foreground` | |
| `disabled` | `text-muted-foreground opacity-50` | |
| `hidden` | `invisible` | |

### 8.4 · `CalendarDayButton` (`calendar.tsx:190–226`)

`<Button variant="ghost" size="icon">` — and `size="icon"`'s `size-10` is **immediately
overridden** by `size-auto` in the same className (§16 drift 26). What survives:

```
relative isolate z-10 flex aspect-square size-auto w-full min-w-(--cell-size) flex-col gap-1
border-0 leading-none font-normal
group-data-[focused=true]/day:border-ring group-data-[focused=true]/day:ring-3
  group-data-[focused=true]/day:ring-ring/50
data-[selected-single=true]:bg-primary data-[selected-single=true]:text-primary-foreground
data-[range-start=true]:rounded-(--cell-radius) data-[range-start=true]:rounded-l-(--cell-radius)
  data-[range-start=true]:bg-primary data-[range-start=true]:text-primary-foreground
data-[range-end=true]:…same, rounded-r-…
data-[range-middle=true]:rounded-none data-[range-middle=true]:bg-muted
  data-[range-middle=true]:text-foreground
dark:hover:text-foreground  [&>span]:text-xs  [&>span]:opacity-70
```
The `rounded-*` overrides are all **variant-scoped**, so twMerge does not touch the Button's base
`rounded-pill`. Consequence:

| state | shape | fill |
|---|---|---|
| rest | **pill** (999px on a square = circle) | ghost |
| selected, single mode | **circle** | `--primary` / `--primary-foreground` |
| range start / end | **10px rounded square** | `--primary` / `--primary-foreground` |
| range middle | **square, no radius** | `--muted` / `--foreground` |
| focused | ring 3 `ring/50` + `--ring` border, `z-10` | |

`modifiers.focused` drives a `useEffect` that calls `ref.current?.focus()` (`:199–201`).
`data-day` carries a local `YYYY-MM-DD` key built by hand (`calendarDayKey`, `:15–20`) — the
page's own `Note` explains why (§12.3).

The `Chevron` component override (`:154–170`) maps `orientation` left/right/down to
`ChevronLeft`/`ChevronRight`/`ChevronDown`, each at an explicit `size-4` → 16px, stroke 2.0
(`Icon` default `size="md"`).

### 8.5 · Derived calendar box *(all §17 Q3 probe items)*

Intrinsic content width = `max(7 × 28, 28 + captionWidth + 28)` = **196px** for any caption
narrower than 140px ("August 2026" at 13/500 is ≈ 76px).

| context | padding | border | total width | total height |
|---|---|---|---|---|
| §5 / §6 Panel | `p-3` = 12 | 1px | **222px** | 5-row **268.571px** · 6-row **304.571px** |
| §7 Popover | `p-2` = 8 | 0 (popover `p-0`) | **212px** | as above − 8 |

Height derivation (5-row): `28 (caption) + 16 (gap) + 18.571 (weekday row) + 5 × (8 + 28) + 2 × 12 (p-3) + 2 (border) = 268.571`.

---

## 9 · §6 Date Range

`Calendar mode="range" numberOfMonths={1}` with `selected={range}` / `onSelect={setRange}`
(page:307–313). Same geometry as §5; the only new paint is `range_start` / `range_middle` /
`range_end` (§8.3) and the day-button range states (§8.4).

The Panel's `note` is the live `rangeLabel` — so clicking two days in the calendar **rewrites
the Panel header**. That is the only place on the page where a specimen writes into its own
chrome, and it is a fidelity requirement, not decoration.

Right column: a `Note tone="action"` titled **"This section existed only as a promise"** — copy in
§12.3. It is a postmortem of the nav registry rendered inside the page, and
`example\lib\nav.dart:333–342` already carries the same warning verbatim on the port side.

---

## 10 · §7 Date Picker

### 10.1 · The trigger

`PopoverTrigger asChild` → `<Button id="picker-empty" variant="outline" className="justify-start">`.

| property | value |
|---|---|
| geometry | `h-10 gap-2 px-4` pill, `border-input bg-card shadow-btn`, `hover:bg-muted`, `active:shadow-btn-down`, **`aria-expanded:bg-muted`** |
| alignment | base `justify-center` → **`justify-start`** via twMerge |
| width | inside a vertical `Field` → `*:w-full` → **320px** |
| press scale | **none.** Button base is `active:not-aria-[haspopup]:scale-95` and `PopoverTrigger` stamps `aria-haspopup="dialog"`. §16 drift 20 |
| leading glyph | `Icon Calendar size="sm" tone="subtle"` → forced to **16px** by the Button's `size-4` rule, stroke **2.4**, `--muted-foreground` |
| label span | `className={picked ? "type-num" : undefined}` |

**The label swaps typeface and size with state**, which is the whole demo:

| state | class | resolved |
|---|---|---|
| picked | `.type-num` | **Geist Mono, 15px, lh 1.2, weight 600, tracking −0.01em, tabular** *(measured, globals.css:1255–1278)* → **"30 Jul 2026"** |
| empty | *(none)* — inherits the Button | **Inter, 13px (`text-sm`), weight 500** → **"Pick a date"** |

The port has both: `ElType.numBase` (mono/15/1.2/600/−0.01/tabular, `typography.dart:794`) and
`ElComponentType.buttonLabel` (`:310`).

### 10.2 · The popover

`PopoverContent className="w-auto p-0" align="start"`, `sideOffset={4}` (`popover.tsx:20–40`).
Base classes, with the two twMerge casualties struck:

```
z-50 flex w-72̶ →w-auto origin-(--radix-popover-content-transform-origin) flex-col gap-2.5
rounded-lg bg-popover p-2.5̶ →p-0 text-sm text-popover-foreground shadow-md ring-1
ring-foreground/10 outline-hidden data-[side=bottom]:slide-in-from-top-2
data-open:animate-in data-open:fade-in-0 data-open:zoom-in-95
data-closed:animate-out data-closed:fade-out-0 data-closed:zoom-out-95
```
→ **content-sized, 4px below the trigger, left-aligned, 12px radius, `--popover`, Tailwind-stock
`shadow-md` + 1px `foreground/10` ring, and it animates at 320ms `--ease-out`.**

The Calendar inside carries `autoFocus` (page:358) — the Meta says why: *"so the keyboard lands
on the grid rather than behind it."*

### 10.3 · The three `Field`s (page:337–398)

| # | label | control | description | notes |
|---|---|---|---|---|
| 1 | **Acquired after** (`htmlFor="picker-empty"`) | the popover trigger above | picked → *"Selected. Dates use the shared numerical mono foundation."* · empty → *"Empty. The placeholder sits in the sans face — it is a word, not a value."* | live |
| — | *(no Field)* | `{picked && <Button variant="ghost" size="sm" className="self-start">Clear date</Button>}` | — | a **direct child of `FieldGroup`**, so 20px above and below; `self-start` beats the group's `stretch`; `h-8 px-3.5 text-small` |
| 2 | **Locked to the tax year** (`htmlFor="picker-disabled"`) | `<Button variant="outline" className="justify-start" disabled>` + `Icon Calendar` + `<span className="type-num">6 Apr 2026</span>` | *"Disabled. The control is exempt from contrast, the description beside it is not."* | wrapped in `<Field data-disabled>` |

`<Field data-disabled>` renders `data-disabled="true"`, which fires `FieldLabel`'s
`group-data-[disabled=true]/field:opacity-50` (`field.tsx:112`). The Button's own disabled state
is `disabled:opacity-45` (`button.tsx:28`). **Two dim levels inside one field**, and the
description is dimmed by neither — which is exactly what its own copy claims. §16 drift 16.

### 10.4 · §7 right column

`div.space-y-4` → `Note tone="error"` (copy §12.4) + `Meta` (4 rows, §12.6).

---

## 11 · Live vs static ledger — the fidelity bar

**Every specimen on this page is live.** There is not one still.

| # | § | specimen | what a reader can do |
|---|---|---|---|
| 1 | select | `s-sort` | open a **grouped** menu with two labels and a separator, arrow through it, commit |
| 2 | select | `s-rarity` | open a flat six-row menu from a placeholder state |
| 3 | select | state cells 1 & 2 | open a one-row menu at a 160px trigger |
| 4 | select | state cell 3 | *(disabled — cannot open; the content is empty anyway)* |
| 5 | native | `ns` | open the **operating system's** picker |
| 6 | combobox | `Combobox` | type, watch the list narrow by collator match, hit the empty state, pick |
| 7 | command | `Command` | type, watch cmdk filter **and re-sort**, arrow, hit the empty state |
| 8 | calendar | `mode="single"` | navigate months, pick a day, watch the selection move |
| 9 | date-range | `mode="range"` | pick two days and watch the **Panel header** rewrite itself |
| 10 | date-picker | Popover | open a popover, pick a date, watch the trigger switch to mono, clear it, watch the Clear button unmount |

Minimum interactive surface the Flutter page must support: three distinct overlay
positioners (item-aligned, popper-below-anchor, popper-below-anchor-with-offset), two text
filters with different matching rules, a full month grid with keyboard navigation and range
selection, an OS-picker escape hatch, and a control whose state rewrites its own Panel chrome.

A port that renders any of these as a picture fails the bar outright.

---

## 12 · Copy — verbatim, with markup resolved

`{" "}` → one literal space; `&ldquo;`/`&rdquo;` = U+201C/U+201D; `&rsquo;` = U+2019; `&quot;` = `"`.
`Code` renders `type-code rounded-sm border border-border bg-card px-1.5 py-0.5 text-muted-foreground` (`kit.tsx:231`).

### 12.1 · Pre-section Note — "Choosing the right one" (`tone="action"`, `mb-12`)

> Under about eight fixed options, use `Select`. Over that, or when the user knows what they are looking for, use `Combobox` so they can type. For cross-product navigation and actions, use the `Command` palette. `NativeSelect` exists for long, boring lists like country — the OS picker beats anything custom on mobile.

Inline runs, in order: text · `Select` · text · `Combobox` · " so they can type. For cross-product navigation and actions, use the " · `Command` · " palette. " · `NativeSelect` · " exists for long, boring lists like country — the OS picker beats anything custom on mobile."
Two `{" "}` literals: after "use" before `Combobox`, and after `NativeSelect`.

### 12.2 · §3 caption (`type-small mt-5`, not a Note)

> Typing narrows the list. The empty state says what happened rather than showing a blank panel.

### 12.3 · §6 Note — "This section existed only as a promise" (`tone="action"`)

> `nav.ts` has listed “Date Range” since the tree was written, and the section above it was titled “Calendar and date range” — but no calendar anywhere in the repo was ever rendered in `mode="range"`. Nothing catches that: `check:refs` reads CSS references, not the nav, and a `contents` entry with no section is invisible to every guard here. The same bug removed “Chart” from Data Display. Adding a string to `contents` is a commitment, not a label.

Chips: `nav.ts` · `mode="range"` · `check:refs` · `contents` · `contents`. Dash is U+2014.

### 12.4 · §7 Note — "Never format a date with toISOString()" (`tone="error"`)

> `toISOString()` converts to UTC first. Pick the 30th anywhere west of Greenwich and `date.toISOString().slice(0, 10)` renders the 29th — the calendar shows one day selected and the trigger shows another. It is invisible in London, wrong in New York, and this page shipped it until now. Use `date-fns`’ `format`, which reads the local calendar date.

Chips: `toISOString()` · `date.toISOString().slice(0, 10)` · `date-fns` · `format`. The apostrophe after `date-fns` is U+2019 and sits **outside** the chip.

### 12.5 · §8 Meta — API (5 rows)

| k | v |
|---|---|
| `Select` | Select + SelectTrigger + SelectValue + SelectContent + SelectItem. Group with SelectGroup and SelectLabel. |
| `NativeSelect` | A real \<select\>. Use NativeSelectOption for options; the OS renders the picker. |
| `Combobox` | Pass items, then render each with a function child inside ComboboxList. ComboboxEmpty covers no-results. |
| `Command` | Command + CommandInput + CommandList + CommandGroup + CommandItem. CommandShortcut right-aligns metadata. |
| `Calendar` | mode="single" \| "range" \| "multiple". Pair with Popover for a date picker. |

Row 2 contains the literal characters `<select>`; row 5's quotes are **straight** `"` (escaped `\"` in the JSX string).

### 12.6 · §7 Meta (4 rows)

| k | v |
|---|---|
| `format(d, "d MMM yyyy")` | Local date, no timezone conversion. date-fns is already a dependency — react-day-picker brings it. |
| `autoFocus` | On the Calendar inside the popover, so the keyboard lands on the grid rather than behind it. |
| `The trigger is a Button` | Not an Input. There is nothing to type, so nothing should look typeable. |
| `Clearing` | A date picker with no way back to empty is a trap. Offer it whenever the field is optional. |

Row 1's key contains straight double quotes. `Meta` renders keys `type-num-sm text-action-ink`
and values `type-small text-muted-foreground` in a `sm:grid-cols-[minmax(0,13rem)_1fr]` (`kit.tsx:219–222`).

### 12.7 · §9 DoDont

`grid gap-4 sm:grid-cols-2`. Do panel `border-value/25 bg-value/[0.06] p-5`, heading `type-label mb-3 text-value-ink` **"Do"**; Don't panel `border-destructive/25 bg-destructive/[0.06]`, heading `text-destructive-ink` **"Don’t"** (U+2019). Items `flex gap-2.5` = `Icon Check|X size="sm" tone="value"|"error" mt-0.5` + `type-small text-muted-foreground`. `space-y-2.5` between items.

**Dos (5)**
1. Use Select under about eight options, Combobox above it.
2. Group long option lists with labels so they stay scannable.
3. Use NativeSelect for country, region and timezone.
4. Show a real empty state when a search returns nothing.
5. Render dates and prices with the named numerical typography foundation.

**Don'ts (4)**
1. Don't use a placeholder in place of a field label.
2. Don't build a custom dropdown for a 200-item list; let the user type.
3. Don't hide the command palette without surfacing its shortcut somewhere.
4. Don't put a date picker where a plain text input would be faster.

All four don'ts use a **straight** apostrophe in "Don't"; only the panel heading is curly.

### 12.8 · Foot nav

`PageFootNav groupId="base" slug="selects"` → `<nav class="mt-8 flex items-stretch gap-4 border-t border-border pt-8">`.
- **Previous** → **"Forms"**, `/design-system/components/base/forms`
- **Next** → **"Selection Controls"**, `/design-system/components/base/selection`

`siblings('base','selects')` in `example\lib\nav.dart:731–747` already resolves both.

---

## 13 · Timing inventory

| element | property | duration | easing | source |
|---|---|---|---|---|
| `SelectTrigger` | `transition-colors` (no duration class) | **250ms** via `--default-transition-duration` | `--ease-out` via `--default-transition-timing-function` | `select.tsx:48`; `globals.css:395–396` |
| **`SelectContent`** | **none** | — | — | `data-[align-trigger=true]:animate-none`; `position` defaults `"item-aligned"` (`select.tsx:64,72,73`) |
| `NativeSelect` | `transition-colors` | **250ms** | `--ease-out` | `native-select.tsx:28` |
| `InputGroup` (combobox input, command input) | `transition-[box-shadow,border-color]` **`duration-base`** `ease-out` | **250ms — via the default, not the token.** `duration-base` is a **no-op utility** (see below) | `--ease-out` (the class **is** real) | `input-group.tsx:17` |
| the `Input` inside both of the above | `transition-[box-shadow,border-color,background-color]` **`duration-base`** `ease-out` | **250ms — same no-op** | `--ease-out` | `input.tsx:29`; `InputGroupInput` (`input-group.tsx:125`) does not cancel it |
| `ComboboxContent` open | `animate-in fade-in-0 zoom-in-95 slide-in-from-top-2` | **320ms** (`--duration-overlay`) | `--ease-out` | `combobox.tsx:116` + the unlayered bridge `globals.css:2181–2185` |
| `ComboboxContent` close | `animate-out fade-out-0 zoom-out-95` | **320ms** | `--ease-out` | same |
| `PopoverContent` open / close | identical set | **320ms** | `--ease-out` | `popover.tsx:33` |
| Buttons (date-picker trigger, Clear, calendar nav, every day cell) | `btn-spring` | **250ms** out / **80ms** in (`--duration-tick`) | `--ease-spring` | `globals.css:1888–1896` |
| Button `active:scale-95` | transform | as above | `--ease-spring` | `button.tsx:28` — **suppressed on the `PopoverTrigger`** by `not-aria-[haspopup]` |
| `IndexCard`-style `lift` / `press` | — | not on this page | | |

### 13.1 · `duration-<word>` emits nothing — never transcribe it as its token

**Tailwind v4 has no `--duration-*` theme namespace.** A `duration-<word>` class therefore
matches no utility and emits no CSS at all. In the production stylesheet the *only* duration
utilities present are:

```
104169: .duration-200{--tw-duration:.2s;transition-duration:.2s}
104225: .duration-400{--tw-duration:.4s;transition-duration:.4s}
```
*(measured — `.duration-base`, `.duration-fast`, `.duration-tick`, `.duration-slow` are absent.)*

So every `duration-<word>` site falls through to
`--default-transition-duration: .25s` *(measured, byte 3982)*. On this page there is exactly
one such class, and it appears at two nested sites — `InputGroup` (`input-group.tsx:17`) and the
`Input` inside it (`input.tsx:29`), both reading `duration-base`, both consumed by the combobox
input **and** the command input.

**The rendered number is 250ms either way**, because `--duration-base` also happens to be 250ms
— which is precisely why nobody has noticed. Port it as *the default*, not as
`ElDurations.base`, and treat any future `duration-fast` / `duration-tick` / `duration-slow`
class as **250ms**, not 150 / 80 / 400.

The easing half is **not** affected: Tailwind v4 *does* carry an `--ease-*` namespace, and
globals.css's redefinitions feed it —
```
104509: .ease-out{--tw-ease:var(--ease-out);transition-timing-function:var(--ease-out)}
104682: .ease-spring{…var(--ease-spring)}   104588: .ease-out-flex{…}
104281: .ease-in{…}   104357: .ease-in-out{…}   104445: .ease-linear{linear}
```
*(measured.)* `ease-out` on the InputGroup is real, and `--default-transition-timing-function`
is `var(--ease-out)` anyway *(measured, byte 4017)* — so that one agrees twice over.

Rules that consume `var(--duration-*)` **inside globals.css itself** (`.cn-toast`, `btn-spring`,
`slide-pill`, every `@utility anim-*`, the keyframe blocks) are ordinary CSS and **are** real —
this finding is only about the className utilities. §16 drift 27, §17 Q12.

The three animation utilities decompose as: `fade-in-0` = opacity 0→1; `zoom-in-95` = scale
0.95→1; `slide-in-from-top-2` = translateY(−8px)→0. Transform origin comes from the
positioner (`--radix-popover-content-transform-origin` / base-ui's `--transform-origin`), so a
port must anchor the scale at the corner nearest the trigger, not at the centre.

`--duration-overlay` (320ms) already exists in the port as **`ElDurations.overlay`**
(`motion.dart:33`) and is currently unused — `ElSelect` deliberately does not animate.
Reduced motion collapses everything to `.01ms` (`globals.css:2534–2542`); the port routes this
through `elAnimationDuration`.

---

## 14 · Token, type and radius reference — what this page adds

Only what is not already tabulated in `forms-map.md` §13 / `shadows-map.md` §11 / `colors-map.md`.

**Type steps newly load-bearing.** *(all measured)*

| step | token | px | line-height | used by |
|---|---|---|---|---|
| `text-xs` | `--text-xs: var(--text-num-sm)` = `.75rem` | **12** | `--text-xs--line-height: calc(1 / .75)` = **1.3333** → 16px box | `SelectLabel`, `ComboboxLabel`, `CommandGroup` heading, `CommandShortcut`, day-cell `<span>` |
| `text-sm` | `--text-sm: var(--text-small)` = `.8125rem` | **13** | `calc(1.25 / .875)` = **1.428571** → 18.5714px box | every row, every label, both inputs |
| `.type-num` | `--text-body` | **15** | 1.2, weight 600, `--tracking-num: -0.01em`, mono, tabular | the date-picker trigger label |
| `.type-num-sm` | `--text-num-sm` | **12** | 1.2, weight 600, mono, tabular | the two Panel `note`s |
| `--tracking-widest` | — | — | **0.1em** | `CommandShortcut` |

There is **no `ElType` at 12px** in the port outside `ElType.numSm` (mono) and three
`ElComponentType` roles (`buttonLabelXs`, `buttonLabelCaps`, `kbdKey`) — §17 Q8.

**Radii used:** `pill` 999 (Select trigger, combobox input, all Buttons, day cells at rest) ·
`lg` 12 (all three overlays, NativeSelect, Panel/Note/Meta/StateGrid, Command root, command
input group) · `md` 10 (every menu row, `--cell-radius`) · `sm` 6 (`Code`) ·
**7** = `calc(--radius − 3px)` (the combobox's `icon-xs` addon button) → already
`ElRadii.addonButton` (`spacing.dart:125`).

**Widths:** `--container-xs` 320 · `--container-sm` 384 · `--spacing` 4 · `w-40` 160 ·
`min-w-36` 144 · `max-h-72` 288 · combobox list cap 252 (`el(72) − el(9)`) ·
combobox popup min-width = anchor + `el(7)` = +28.

**Shadows:** `shadow-pressed` (Select trigger, combobox input) · `shadow-btn` /
`shadow-btn-down` (date-picker triggers, calendar buttons) · **`shadow-md`** — Tailwind stock,
on **all three** overlays. The port already carries it as `ElShadows.tailwindMd`
(`shadows.dart:168`), documented there as `SelectContent`'s elevation and as forms-map drift 16.
It now has three consumers.

**Colours:** `--popover` / `--popover-foreground` (all three overlays) · `--accent` /
`--accent-foreground` (Select and Combobox highlight) · **`--muted` / `--foreground`** (Command
highlight, calendar `today` and `range_middle`) · `--input` at **30 %** (command input fill and
border; Select and NativeSelect dark fill) · `--foreground` at **10 %** (every overlay ring) ·
`Canvas` / `CanvasText` (native `<option>` — CSS system colours, no token). Every one of these
exists on `ElThemeData` already.

---

## 15 · Exists in the port / missing

Package root `D:\DESIGN\Design-System-2026-8\flutter-design-system\`. HEAD `d3bb024`, tree clean.

### 15.1 · Already built — reuse, no work

| need | where |
|---|---|
| **`ElSelect<T>`** — trigger, socket, states, keyboard, overlay menu, item-aligned placement, `expand`, field-scope wiring, 34.571px rows | `lib\src\components\select.dart:133` |
| `ElShadows.tailwindMd` (+ `tailwindLg`) | `lib\src\foundation\shadows.dart:168`, `:153` |
| `ElMachineSurface` (inset painting, CSS paint order, **`drawDRRect`**) | `lib\src\effects\machine_surface.dart:26`, `:205` |
| `ElInputGroup` + `ElInputGroupInput` / `Addon` / `Button` / `Align` | `lib\src\components\input_group.dart:124, 314, 387, 474, 534` |
| `ElInput`, `ElFieldSurface` | `lib\src\components\input.dart:83`, `:427` |
| Full field layer — `ElFieldScope`, `ElFieldGroup`, `ElField`, `ElFieldLabel`, `ElFieldDescription`, `ElFieldActivator` | `lib\src\components\field.dart:95, 156, 291, 503, 604, 85` |
| `ElButton` (7 variants incl. `outline`/`ghost`, sizes `sm`/`icon`), `btn-spring`, focus ring helper | `lib\src\components\button.dart:222` |
| `ElKbd` / `ElKbdGroup` | `lib\src\components\kbd.dart:54`, `:132` |
| `ElIcon` + glyphs `chevronDown/Up/Left/Right`, `check`, `x`, `search` | `icon.dart:135`; `icon_paths.dart:94–97, 77, 71, 88` |
| `ElRadii.addonButton` = 7 | `lib\src\foundation\spacing.dart:125` |
| `ElDurations.overlay` = 320ms, `ElCurves.out` / `.spring` | `lib\src\foundation\motion.dart:33`, `:266`, `:271` |
| `ElType.numBase` (mono 15/1.2/600), `ElType.numSm`, `ElComponentType.sheetBody` / `buttonLabel` | `typography.dart:794, 783, 451, 310` |
| Theme fields `popover`, `popoverForeground`, `accent`, `accentForeground`, `muted`, `mutedForeground`, `input`, `ring`, `border` | `lib\src\foundation\theme.dart:109, 113, 138, 142, 125, 134, 150, 175, 146` |
| Kit: `ElPanel(note:)`, `ElStateGrid`, `ElStateCell`, `ElNote`, `ElMeta`, `ElDoDont`, `ElCode`, `ElPageHeader`, `ElSection`, `ElPageFootNav` | `example\lib\kit.dart:242, 503, 587, 1124, 679, 1025, 737, 54, 148, 1446` |
| Nav entry for `selects` + `siblings()` | `example\lib\nav.dart:239–255`, `:731–747` |

### 15.2 · Missing — must be built

| # | missing | scope | notes |
|---|---|---|---|
| 1 | **`ElIconGlyph.calendar`** | 1 path | The page's only glyph gap; blocks §5–§7. Case-insensitive grep for `calendar` across `lib\` returns zero. Must be classified as curated-63 vs off-set before it lands, because `test\icon_paths_test.dart` polices the icons-page registry. |
| 2 | **`ElSelect` groups / labels / separators** | §3.2 #1, #2 | New row kinds in the menu's child list. |
| 3 | **`ElSelect` scroll buttons + capped content** | §3.2 #3, #6 | 32px `bg-popover` caps above and below the padded viewport; the rail is replaced, not styled. |
| 4 | **`ElSelect` item-aligned over a heterogeneous list** | §3.2 #5 | `_placement()`'s uniform-row arithmetic must become a running offset. **The one real algorithmic change to shipped code.** |
| 5 | **`ElSelect` explicit trigger width** | §3.2 #4 | `expand: bool` → a width mode (`fit` / `fill` / `fixed(w)`), or a `width` param beside `expand`. API decision — §17 Q4. |
| 6 | **`ElPopover`** | new | Nothing in `lib\` generalizes an anchored overlay: `ElSelect`'s is private (`_SelectContent` `select.dart:579`), `ElSheet` uses a `PopupRoute` (`sheet.dart:141`). Needs side/align/sideOffset, collision handling, a corner transform-origin, and the 320ms enter/exit. **Both the Combobox and the Date Picker depend on it.** |
| 7 | **`ElNativeSelect`** | new | 32px, 12px radius, transparent, no socket. The *platform picker* part is §17 Q6. |
| 8 | **`ElCombobox`** | new | `ElInputGroup` chassis + `ElPopover` + a collator-equivalent filter + `data-highlighted` rows + an empty row. |
| 9 | **`ElCommand`** | new | `ElInputGroup` chassis (socket **off**, `--input` @30 % fill) + group headings + a no-margin separator + `--muted` highlight + shortcut column + first-item-selected-at-rest + the cmdk fuzzy score. §17 Q9. |
| 10 | **`ElCalendar`** | new, largest | Month grid, outside days, Sunday week start, `cccccc` weekday labels, month/year caption, nav buttons, single + range modes with the 16px `after:` bleeds, `today`, focus ring, keyboard. |
| 11 | **A date formatter** | new | `format(d, "d MMM")` and `"d MMM yyyy"` with en-US month abbreviations, plus `formatMonthYear`. No `intl` dependency is in the port today — §17 Q10. |
| 12 | **`example\lib\pages\selects.dart`** | new | Absent. |
| 13 | **`main.dart` route arm** | 1 line | `'$elRoot/components/base/selects' => const SelectsPage(),` immediately after the `forms` arm at `main.dart:167` — the switch deliberately follows nav order (`main.dart:153–155`). Today the route falls to `PlaceholderPage`. |
| 14 | **`example\test\selects_page_test.dart`** | new | Absent. Model on `forms_page_test.dart`. |
| 15 | **`_referenceHeight` for the selects route** | probe | `example\test\vertical_parity_probe_test.dart`. **Blocked on §17 Q2** — the reference's height moves with the calendar month. |
| 16 | Wrap-parity entry | probe | `example\test\wrap_parity_probe_test.dart`. |

### 15.3 · Guard-test constraints

`test\token_guard_test.dart:40–63` forbids, outside `lib\src\foundation\`: `Color(0x`,
`Color.from`, `fontSize:\s*\d`, `letterSpacing:\s*-?\d`, `FontWeight.w\d`, `\bCurves.`,
`Duration((milli|micro)seconds:\s*\d`, `BorderRadius.circular(\d`, `BoxShadow(`, and
`\bheight:\s*[01](?!\d)`. Bare `0`/`0.0` and `elTransparent` are always legal; the escape hatch
is the substring `allow-hardcoded:` **anywhere on the line** (`:96`). It is a raw text scan
**including comments** (`:13–15`).

Consequences for this page:
- Every geometry number is already expressible: cell size `el(7)`, cell radius `ElRadii.md`,
  range bleed `el(4)`, combobox cap `el(72) − el(9)`, popup min-width `anchor + el(7)`,
  addon radius `ElRadii.addonButton`, overlay duration `ElDurations.overlay`. **No new
  `ElDurations` member is needed** — 320ms already exists as `overlay`.
- Plain `double` constants (the cmdk score weights 1 / 0.9 / 0.8 / 0.17 / 0.1 / 0.999 / 0.9999 /
  0.99) match **no** rule and are legal — but they belong in one file beside the matcher, not
  in a page.
- A doc comment that spells out `320` beside the word `Duration(milliseconds:` will trip the
  scanner. Write timings in prose, as `select.dart` already does.

### 15.4 · Painter policy — the phase-3 ruling, in force

`CanvasKit diverges from the VM raster on Path.combine(difference) under a MaskFilter.blur`
(`flutter-port-decisions`, phase-3 close). Inset rings paint as
`canvas.drawDRRect(outer, hole, paint)` — `machine_surface.dart:205`, guarded at
`test\effects_test.dart:495–509` (*a panel mounts one `BackdropFilter` and a control mounts none*).

For this page:
- The three overlays reuse the **existing** recipe — `ElMachineSurface` with a prepended 1px
  ring layer over `ElShadows.tailwindMd` (`select.dart:598–614`). **No new painter.**
- The Command input asks for `shadow-none`, i.e. `ElShadows.none` — the socket is *removed*, not
  restyled. No painter.
- **The calendar's range band is the one new paint.** `range_start` / `range_end` are a 10px-rounded
  `--muted` rect with a **16px square bleed on one side**, under a `--primary` pill. That is two
  overlapping rectangles, not a difference path and not a blur. **Do not reach for
  `Path.combine`, `MaskFilter`, or a blurred ring here** — a `Stack` of two `DecoratedBox`es, or
  one `CustomPainter` issuing two `drawRRect`/`drawRect` calls, is the whole shape.
- Anything painted ships with **rendered-pixel pins** (interior == token colour, edge band
  darker, an anti-assertion naming the collapsed composite computed from live tokens) **and a
  browser probe** (`scratchpad probe-renderer.js` pattern: sample fixed coordinates across
  headful / headless / rig-flag Chrome) before it is called done. Widget tests that assert
  recipe parameters prove nothing about the web raster — 852 of them passed over the socket bug.

---

## 16 · Drift register (record, do not fix)

1. **The eyebrow says "Base" twice.** `` `${group.title} · Base` `` with `group.title = "Base Components"` → **"Base Components · Base"**. All fourteen base pages; foundations pages print one clean word. Shared with `forms-map` drift 1.
2. **All three calendars open on the reader's current month, not on the month of their own selected value.** `getInitialMonth = month || defaultMonth || today` and the page passes neither. The seeded July 2026 dates are invisible on any other month, while the Panel note still prints "12 Jul – 20 Jul" and the trigger still prints "30 Jul 2026". **The page's document height also changes with the month's week count** (5 rows in July 2026, 6 in August 2026 = 36px per calendar). §8.1, §17 Q2.
3. **`Ctrl + K` is decorative.** The §4 Panel `note` advertises it and the description says the palette is *"Opened with Ctrl+K from anywhere"* — but no keydown listener exists on the page, in `Command`, or in `cmdk`'s inline mode. The page's own Don't 3 forbids hiding the palette without surfacing its shortcut; the shortcut is surfaced and bound to nothing.
4. **The palette's prices are not in the numerical foundation.** `$48.00` and `$120.00` ride `CommandShortcut`'s `text-xs tracking-widest` — 12px **sans**, 0.1em. Do 5 on the same page: *"Render dates and prices with the named numerical typography foundation."* The date picker obeys it (`.type-num`); the palette, four sections earlier, does not.
5. **Three highlight tokens for one idea.** `SelectItem` → `focus:bg-accent`; `ComboboxItem` → `data-highlighted:bg-accent`; `CommandItem` → **`data-selected:bg-muted`**. Two libraries' state vocabularies plus a third fill.
6. **Three group-label treatments.** `SelectLabel` `px-3 py-2 text-xs` (weight 400) · `ComboboxLabel` `px-2 py-1.5 text-xs` (400) · `CommandGroup` heading `px-3 py-2 text-xs **font-medium**` (500). Same role, three sets of numbers.
7. **Three separator rhythms.** `SelectSeparator` `-mx-2 my-2` = 17px of space · `CommandSeparator` `-mx-2` = **1px, no margin** · `ComboboxSeparator` `-mx-1 my-1` = 9px (unused here).
8. **`NativeSelect` is the only control in the family that is not a pill over a socket.** `h-8 rounded-lg bg-transparent`, no `shadow-pressed` — 32px and 12px-cornered beside a 40px pill, two sections apart, in a page whose whole subject is that they are the same kind of control.
9. **The Select popover is the only overlay on the page that does not animate.** `SelectContent` ships the full `animate-in / fade-in-0 / zoom-in-95 / slide-in-from-*` set and cancels all of it with `data-[align-trigger=true]:animate-none`; the combobox popup and the popover both run it at 320ms. Same design system, same overlay job, opposite answers. (`forms-map` drift 10, now with a counterexample on the same page.)
10. **`SelectTrigger`'s `w-fit` is dead in both directions on this page.** In the Panel it loses to the vertical `Field`'s `*:w-full` *(measured — byte 39230 vs 106378)*; in the state cells it loses to `w-40` through twMerge. It never once applies.
11. **`shadow-md` is Tailwind's stock elevation and it is now on three overlays** — Select content, Combobox popup, Popover content. `0 4px 6px -1px rgb(0 0 0/.1), 0 2px 4px -2px rgb(0 0 0/.1)`, fixed black, no theme response, under three surfaces whose fill flips with the theme. (`forms-map` drift 16, ×3.)
12. **`Command`'s `rounded-xl!` and `bg-popover` are both discarded by the call site.** twMerge strips the important modifier when grouping, so `rounded-lg` and `bg-card` win before CSS is consulted and the `!` never reaches the stylesheet. The palette renders at `--radius-lg` on `--card`. **Derived from tailwind-merge semantics — §17 Q7.**
13. **The check indicator is `display:none` on every `CommandItem` on this page.** `group-has-data-[slot=command-shortcut]/command-item:hidden`, and all four items carry a shortcut. The component ships a selection affordance the page can never show.
14. **`⌘W` / `⌘S` beside "Ctrl + K".** Two platform idioms, one specimen, four inches apart.
15. **`Icon size="sm"` renders at 16px, not 14.** `[&_svg:not([class*='size-'])]:size-4` on `Button`, `CommandItem` and `SelectItem` beats the SVG's `width`/`height` presentational attributes, while `strokeWidth` stays at the 14px-derived 2.4. Four new sites here (Search ×2, Calendar ×2). Already `icons-map` drift 2 — recorded again because the port's `ElIcon` takes an explicit `sizePx`.
16. **Two dim levels inside one disabled field.** `<Field data-disabled>` dims `FieldLabel` to **0.50**; the `disabled` Button dims itself to **0.45**; the `FieldDescription` is dimmed by neither. The last part is deliberate and the copy says so — the first two are not reconciled anywhere.
17. **`aria-invalid` beats focus-visible** on `SelectTrigger` and `NativeSelect` (`forms-map` drift 6). Unreachable on this page: nothing validates.
18. **The "Disabled" state cell ships an empty `<SelectContent />`.** A menu with no rows, behind a trigger that cannot open it.
19. **`Select` is no longer the only control with `dark:` variants.** `NativeSelect` carries the same four (`dark:bg-input/30`, `dark:hover:bg-input/50`, and the two `dark:aria-invalid:` overrides). `forms-map` drift 17 said "the only control"; on this page there are two.
20. **The date-picker trigger is the one Button on the page that does not scale on press.** Base is `active:not-aria-[haspopup]:scale-95` and `PopoverTrigger` stamps `aria-haspopup="dialog"`. The disabled twin beside it — same variant, same classes, no popover — would scale if it were not disabled.
21. **`Combobox` is the corpus's only `@base-ui/react` component.** Everything else is Radix or a bespoke primitive. It brings a second state vocabulary (`data-highlighted` vs `focus`), a second positioner variable set (`--anchor-width` / `--available-height` vs `--radix-*`), and a second filter philosophy.
22. **The combobox popup is always 28px wider than its own input.** `w-(--anchor-width)` asks for exactly the anchor; `min-w-[calc(var(--anchor-width)+--spacing(7))]` overrules it. A 384px input gets a 412px popup that overhangs 28px to the right.
23. **`ComboboxInput`'s `showClear` defaults to `false`**, so the combobox on this page has no way back to an empty query — while the Meta three sections later says *"A date picker with no way back to empty is a trap."*
24. **`nav.ts`'s own source comment (`:269–278`) documents this page's §6 as a shipped bug**, found the same way as the missing Chart section and fixed the other way round. The port's `nav.dart:333–342` already carries it verbatim.
25. **The calendar disagrees with itself about cell shape.** `today` paints a **10px rounded** `--muted` square on the `<td>`; the `DayButton` inside it is a **pill**; a selected single day is therefore a circle on a rounded square, and a range end is a 10px square on a 10px square.
26. **`CalendarDayButton` passes `size="icon"` and immediately throws it away.** `size-10` loses to `size-auto` in the same className. The variant is dead code that still costs a class-string.
27. **`duration-base` is a class that does nothing.** Tailwind v4 has no `--duration-*` theme namespace, so `duration-<word>` compiles to no rule at all — only `.duration-200` and `.duration-400` exist in the built stylesheet *(measured)*. Both `InputGroup` (`input-group.tsx:17`) and `Input` (`input.tsx:29`) name it, and both fall through to `--default-transition-duration` = 250ms. It is invisible here only because `--duration-base` is *also* 250ms; `input.tsx:12`'s own doc comment states the intent — *"Focus fades in over `duration-base` on `ease-out`"* — and is accidentally describing the default. The paired `ease-out` **is** real (Tailwind v4 does carry `--ease-*`). §13.1.

---

## 17 · Open questions for the supervisor

1. **Scope.** This page needs four brand-new components (`ElNativeSelect`, `ElCombobox`, `ElCommand`, `ElCalendar`), one new primitive (`ElPopover`), one new glyph, a date formatter, and six changes to shipped `ElSelect` code — one of them algorithmic. That is comparable to the whole of phase 3, and `ElCalendar` alone is bigger than any single component in the port. **Recommendation:** build `ElSelect`'s deferred surface + `ElPopover` + `ElNativeSelect` + `ElCombobox` first (they share the overlay and the input-group chassis and finish four of seven chips), then `ElCommand`, then `ElCalendar` last as its own wave, since §5/§6/§7 all collapse if the calendar is not right. Confirm the split before I plan.
2. **The calendar's initial month (drift 2) — reproduce or pin?** The reference renders *today's* month with its seeded selection off-screen, and its document height swings 36px with the month's week count. Reproducing it makes the vertical-parity probe non-deterministic; pinning `defaultMonth` to July 2026 makes the port render something the reference does not. **Recommendation:** reproduce the behaviour in the app (it is what the page does), and have the rig **freeze the clock** for capture on both sides — the capture harness can inject a fixed `Date` in Chrome and the Flutter page can take an injectable `DateTime.now`. That keeps the drift honest and the probe stable. This one blocks §15.2 #15; I need your call before any height is pinned.
3. **Calendar geometry — all derived, none seen.** Every number in §8.5 (196px intrinsic width, 222/212px boxes, 268.571/304.571px heights) is computed from tokens and has never been on screen. **Recommendation:** a browser probe of §5's calendar (root, month, month_grid, one `<td>`, one DayButton, the weekday row) at 1440 in both themes, before a single widget is written. Same for the 293.29px palette and the 412px combobox popup.
4. **`ElSelect.expand` → a width mode?** The page needs three widths (`w-fit`, `*:w-full`, `w-40`) and `expand` is a `bool`. **Recommendation:** keep `expand` (it names a documented cascade, and `forms_page_test.dart:984` asserts it) and add an optional `width` that wins over both, rather than replacing a documented switch with an enum. Your call — this is public API on a shipped component.
5. **The empty `SelectContent` (drift 18).** `_openMenu` early-returns on `options.isEmpty`, so the port already renders nothing. Confirm that "nothing opens" is the intended parity for a disabled trigger over an empty list, rather than an empty popover.
6. **`ElNativeSelect` — what is "native" in Flutter?** The whole point of §2 is that the OS draws the list; the section title, the description, the Note and Do 3 all say so. Flutter has no OS `<select>`. Options: (a) render the port's own menu and record the divergence, (b) call the platform picker on the platforms that have one (`showCupertinoModalPopup` / a `PlatformMenu`) and fall back elsewhere, (c) render a visually faithful 32px trigger whose list is `ElSelect`'s menu, and say so in the doc comment. **Recommendation: (c)** — the *specimen* on this page is the closed 32px control, which is fully reproducible; the OS list is off-canvas in every screenshot the rig takes. Needs your ruling because it is the first place the port cannot be 1:1 by construction.
7. **`Command`'s `rounded-xl!` / `bg-popover` (drift 12).** I have derived that tailwind-merge strips the important modifier and the call site wins, giving a 12px `--card` palette. That is a load-bearing 4px and a whole surface colour. **Recommendation:** probe the live reference's computed `border-radius` and `background-color` on `[data-slot=command]` before building. I have not guessed a value into the map — both readings are stated.
8. **A 12px sans type step.** `SelectLabel`, `ComboboxLabel`, the `CommandGroup` heading and `CommandShortcut` are all 12px sans, and the port has no `ElType` for it — only `ElType.numSm` (mono) and three component roles. **Recommendation:** add `ElComponentType.menuLabel` (12 / `_leadingXs` / 400) and `ElComponentType.menuShortcut` (12 / `_leadingXs` / 400 / tracking 0.1) rather than a new `ElType` rung, consistent with how `sheetBody` and `kbdKey` were handled. The heading's weight-500 variant is a fourth spec or a `wght` override — say which.
9. **`ElCommand`'s matcher.** cmdk filters **and re-sorts** by a fuzzy `commandScore` with eight weighted constants. Porting it verbatim is ~60 lines of scoring; not porting it means the palette's row order diverges the moment anyone types. **Recommendation:** port `commandScore` verbatim into `lib\src\components\command_score.dart` with the weights as named constants and the two separator regexes transcribed — it is a pure function, it is testable against the JS, and "the list re-sorts as you type" is visible behaviour the fidelity bar covers. Confirm; the alternative is a documented divergence.
10. **Date formatting without a dependency.** The page needs `d MMM`, `d MMM yyyy` and a month-year caption, plus `cccccc` weekday abbreviations, all en-US. The port takes no dependencies. **Recommendation:** a small `ElDateFormat` in `lib\src\foundation\` with the twelve month abbreviations and seven weekday abbreviations as const lists — it is locale data, it belongs with the tokens, and `intl` would drag ICU in for twelve strings. Flag if you would rather add `intl`.
11. **`ElPopover`'s scope.** §7 needs exactly one arrangement (`side=bottom`, `align=start`, `sideOffset=4`) and §3 needs one more (`sideOffset=6`). The full Radix/base-ui matrix — six sides, three aligns, collision flipping, arrow — is `menus`/`dialogs` territory. **Recommendation:** build `ElPopover` with side/align/offset parameters and *real* collision flipping (a popover that runs off-screen is a bug, not a drift), but no arrow and no nested-portal support until a later page needs them. Same shape as the ruling that scoped `ElSelect` in phase 3.
12. **Every `duration-<word>` on this page is a no-op (drift 27, §13.1).** Both sites resolve to the 250ms default rather than to `--duration-base`, and the two numbers coincide, so nothing here changes on screen. **Recommendation:** port them as the default and write the mechanism into the doc comment, so the next reader does not "fix" it back to `ElDurations.base`. Two things I am *not* deciding here: (a) whether the shipped `ElInput` / `ElInputGroup` doc comments need the same correction — a corrective sweep is running in parallel and owns that; (b) whether any `duration-<word>` elsewhere in the corpus names a **non**-250ms token, where the drift would be visible rather than latent. Flag if you want me to add the computed `transitionDuration` on `[data-slot=input-group]` to the §17 Q3 probe list — I have written it as measured-from-the-stylesheet, not measured-from-the-page.
13. **Seven chips, seven promised sections.** `nav.dart:333–342` records that a `contents` entry with no section is the bug this very page's §6 is a postmortem of. The port's nav already promises all seven. **Recommendation:** if the wave splits (Q1), the `selects` route stays on `PlaceholderPage` until **all seven** sections exist, rather than shipping a page that advertises Calendar and renders nothing — repeating the exact bug the page exists to document.

---

## Dated correction — 2026-08-16, B1 build-time probes (supervisor-appended)

- **Drift 12 / §Command radius half-corrected:** measured `[data-slot=command]`
  `border-radius` is **16px** in both themes — twMerge keeps `rounded-xl!` in
  its own group key (important modifier) and `!important` wins the cascade
  over the later `rounded-lg`. Background half stands (`--card`; `bg-popover`
  stripped). Port ships `ElRadii.xl`.
- **New drift — cmdk group re-sort is dead code:** `sort()` looks groups up by
  `[cmdk-group=""][data-value="<React useId>"]` but the element's
  `data-value` holds its heading, so the selector never matches. Item sort is
  real (typing `t` lifts "Go to Stash" over "Open Wallet"); group order never
  changes (typing `o` leaves Packs above Actions). Shipped faithfully.
- **New drift — the command input has no focus affordance:** the group's
  `has-[[data-slot=input-group-control]:focus-visible]` selector misses
  (cmdk's Input stamps no such slot) and `shadow-none!` kills the ring.
  Resting and focused are byte-identical.
- **New drift — separator unmounts on the first keystroke** (cmdk renders it
  only when `!state.search`); returns on clear. 1px height swing.
- **Shortcuts are searchable** (`data-value` concatenates label + shortcut;
  typing `48` finds the first pack).
- Palette height measured **293.25** (derivation said 293.29 — Chrome 1/64px
  grid). Empty state 124.56. Search glyph `--muted-foreground` @ .5.
- `menuHeading` confirmed 12px / 16px box / weight 500 → spec added (L8).
