# Map — `/design-system/components/base/inputs` (Base Components · Inputs)

**Files that produce the render** (all under `D:\DESIGN\Design-System-2026-8\design-system\`):
- `app\design-system\components\base\inputs\page.tsx` — the page. **`"use client"`** (first base page that is), one page-local component (`PasswordField`, L54–77) and one page-level `useState` (`otp`, L82).
- `components\ds\kit.tsx` — `Code`, `DoDont`, `DsPageHeader`, `DsSection`, `Meta`, `Note`, `PageFootNav`, `Panel`, **`StateCell`, `StateGrid`** (all 10 used; this is the first page in the corpus to use `StateGrid`).
- `components\ui\input.tsx` (43 L) · `textarea.tsx` (23 L) · `input-group.tsx` (157 L) · `input-otp.tsx` (89 L) · `field.tsx` (245 L) · `label.tsx` (25 L) · `button.tsx` · `icon.tsx`
- `node_modules\input-otp` v1.x — `OTPInput` supplies the whole OTP mechanism; the shadcn file is markup only.
- `lib\ds\nav.ts` — `findCategory("base","inputs")`, `siblings("base","inputs")`
- `app\design-system\layout.tsx` · `app\globals.css` · `app\layout.tsx`

Read with **`shared-map.md`** (shell, kit anatomy, Icon ladder), **`shadows-map.md`** (§5.1–5.2 Button base + variants, §5.5 the bare Input, §11 tokens, §13 CSS→Flutter), **`typography-map.md`** (type classes). Nothing there is restated except where this page consumes it differently.

Icons used: `AtSign`, `Eye`, `EyeOff`, `Lock`, `Percent`, `Search`, `Ticket` (page) + `Minus` (OTP separator) + `Check`/`X` (DoDont) + `ArrowLeft`/`ArrowRight` (foot nav).

---

## 0 · Shell / layout metrics

Identical to every docs page — `shared-map.md` §1. Load-bearing here:

- Content column **1080px** at the 1440 frame. `--spacing` 4px. Breakpoints stock (sm 640 · lg 1024).
- `--radius` = **10px** in *both* themes (`globals.css:605`, `:814`). It is **not** the base of the `--radius-*` ladder (`--radius-lg` is a literal 12px). Only two call sites read it, both in `input-group.tsx`: `calc(var(--radius)-3px)` = **7px**, `calc(var(--radius)-5px)` = **5px**.
- Tailwind size steps are repointed (`globals.css:212–215`): **`text-xs` 12 · `text-sm` 13 · `text-base` 15 · `text-lg` 17**. Every input primitive uses `text-sm` → **13px**.
- `max-w-lg` = `--container-lg` 32rem = **512px** (container scale, not spacing). `max-w-40` = **160px**. `min-h-20` = **80px**.
- **`:focus-visible { outline: 2px solid var(--ring); outline-offset: 2px }`** (`globals.css:996–999`) applies to everything. Every input primitive clears it with `outline-none`; the OTP's hidden input clears it with an **inline** `outline: 0 solid transparent` (see §6.1). Nothing on this page shows the global outline.
- `::selection` = `--color-action` @ **35%** with `color: var(--foreground)` (`globals.css:1007–1010`).

---

## 1 · Page header (`DsPageHeader`)

Anatomy per `shared-map.md` §2. Content, verbatim (`nav.ts`, all ASCII — no curly quotes, no dashes):

| slot | value |
|---|---|
| eyebrow | **Base Components · Base** — the template is `` `${group.title} · Base` ``, so the word "Base" appears **twice**. See drift 1. |
| title | **Inputs** |
| blurb | **Text entry in every shape the product needs, with the full validation and state matrix.** |
| chips (10, in order) | Text Input · Email Input · Password Input · Search Input · Number Input · Phone Number Input · Textarea · Verification Code · Input Group · Field & Label |

`&` in the last chip is a plain ASCII U+0026.

---

## 2 · Opening `Note` — before any section

`<Note tone="action" title="Restyled from stock" className="mb-12">` — same page-level position and `mb-12` (48px) as the shadows page.

Title renders **`--muted-foreground`**, not the tone ink: `.type-label` hard-declares `color: var(--muted-foreground)` (`globals.css:1182`) and a direct declaration beats the container's inherited tone colour. *(Corrects `shadows-map.md` §2 and §7.3, which describe the title as inheriting the tone ink. The port already renders it correctly — `example\lib\kit.dart:877–880`.)*

Body copy, verbatim (`{" "}` → one literal space, two `Code` chips):

> Inputs ship from shadcn at 32px tall with a 12px radius. Both were changed: 40px and 10px, so a field sits level with a default `Button` in the same row. Fields are also filled with `bg-muted` rather than transparent, so they read as editable against a card without a heavy border.

**Every specific claim in this Note is false against the component it describes** — see drifts 2 and 3. Ships verbatim.

---

## 3 · Section `#states` — "States"

Heading: **"States"**
Description: **"The full matrix. Every input in the product must be able to show all eight — a form that cannot express an error is not finished."** (U+2014 em dash)

`<StateGrid cols={4}>` — `grid gap-px overflow-hidden rounded-lg border border-border bg-border`, cols map `grid-cols-2 sm:grid-cols-4` (**no `lg:` step — 4 columns forever above 640**). The hairlines *are* the container's `bg-border` showing through 1px gaps; cells paint `bg-background` over it. 8 cells → 2 full rows ≥640, 4 rows below. No orphan cell.

`StateCell`: `bg-background p-5` · specimen box `mb-4 flex min-h-14 items-center justify-center` (56px min) · label `type-micro text-center text-muted-foreground` (10.5/1/600/upper/0.18em) · note `type-caption mt-1.5 text-center text-muted-foreground` (10.5/1.35/**500**/not uppercase). Order is **specimen → label → note**. Label and note are the same size and differ only by weight, casing, tracking and leading — easy to lose in a port.

**Cell geometry at 1440:** 1080 − 2 (borders) − 3 (gaps) = 1075 ÷ 4 = **268.75px** per cell; minus 2×20 padding → each `Input` renders **228.75 × 40**.

### 3.1 · The eight specimens

Every one is a bare `<Input>` with an `aria-label` equal to its label. `defaultValue`/`placeholder` verbatim.

| # | label | note | props / class override | value shown | border | ring | ink | opacity |
|---|---|---|---|---|---|---|---|---|
| 1 | Default | — | — | ph `Search packs` | `--input` | — | placeholder muted | 1 |
| 2 | Hover | Border strengthens | `className="border-input"` | ph `Search packs` | `--input` | — | placeholder muted | 1 |
| 3 | Focus | Blue ring | `className="border-ring ring-3 ring-ring/50"` | ph `Search packs` | `--ring` | 3px `--ring`@50% | placeholder muted | 1 |
| 4 | Filled | — | — | `Eclipse Vault` | `--input` | — | `--foreground` | 1 |
| 5 | Error | aria-invalid | `aria-invalid` | `not-an-email` | `--destructive` | 3px `--destructive`@20% | `--foreground` | 1 |
| 6 | Success | — | `className="border-value/50"` | `collector@pulls.xyz` | `rgba(163,230,53,0.50)` | — | `--foreground` | 1 |
| 7 | Disabled | 45% opacity | `disabled` | ph `Unavailable` | `--input` | — | placeholder muted | **0.45** |
| 8 | Read only | Value, not editable | `readOnly` + `className="text-muted-foreground"` | `0xA71c…4F2b` (U+2026) | `--input` | — | `--muted-foreground` | 1 |

All eight also carry `shadow-pressed` permanently and `bg-card`.

Notes that matter for parity:
- **Cell 2 is pixel-identical to cell 1.** `border-input` is already in the Input's base class list; the component declares **no** `hover:` rule at all. The note "Border strengthens" describes nothing. Drift 4.
- **Cell 3 does not show the real focus appearance.** Real `focus-visible` is `border-primary/50` + `ring-ring/35`; the specimen paints `border-ring` + `ring-ring/50` (the *Button*'s focus recipe). Drift 5.
- **Cell 8's only visible difference is the ink.** `input.tsx` has no `read-only:` variant; `readOnly` alone changes nothing visually.
- Input text colour is never set — Preflight gives inputs `color: inherit`, so it resolves up to `body`'s `text-foreground`.

---

## 4 · Section `#types` — "Input types"

Heading: **"Input types"**
Description: **"Every text-entry shape the product needs. The type attribute is not cosmetic — it drives the mobile keyboard, autofill and validation."**

`<Panel label="Types">` → body `bg-background p-6`, `<FieldGroup className="max-w-lg">` = 512px, `flex flex-col gap-5` (**20px between fields**). Nine `<Field>`s, each `flex flex-col gap-2` (**8px** label→control→description) with `*:w-full`.

### 4.1 · The nine fields, in DOM order

| # | label (`FieldLabel`) | `htmlFor` | control | addons (start → end) | input class | value / placeholder | description |
|---|---|---|---|---|---|---|---|
| 1 | Username | `i-text` | bare `Input` | — | — | ph `voidwing` | Shown on live pulls and the leaderboard. |
| 2 | Email | `i-email` | `InputGroup` | `Icon AtSign` sm/subtle | — | ph `collector@pulls.xyz`, `type=email`, `autoComplete=email` | — |
| 3 | Password | **none** | `PasswordField` | `Icon Lock` sm/subtle → `InputGroupButton` w/ `Icon Eye`\|`EyeOff` | — | val `correct-horse-battery`, `type` toggles `password`↔`text`, `aria-label="Password"` | Visibility toggle is a real control with an aria-pressed state, not a decorative icon. |
| 4 | Search | `i-search` | `InputGroup` | `Icon Search` sm/subtle | — | ph `Search packs, cards and sets`, `type=search` | — |
| 5 | Quantity | `i-num` | `InputGroup className="max-w-40"` (160px) | — → `InputGroupText` `packs` | `type-num` | val `3`, `type=number`, `min=1 max=10` | Numerical values use the shared mono foundation, even inside inputs. |
| 6 | Phone number | `i-phone` | `InputGroup` | `InputGroupText className="type-num-sm"` `+1` | `type-num` | ph `555 0134 908`, `type=tel`, `autoComplete=tel` | Country code is a separate addon so it never gets validated as part of the number. |
| 7 | Deposit amount | `i-amount` | `InputGroup` | `InputGroupText type-num` `$` → `InputGroupText` `USD` | `type-num` | ph `0.00`, `type=text`, `inputMode=decimal` | — |
| 8 | Invite code | `i-invite` | `InputGroup` | `Icon Ticket` sm/subtle → `InputGroupButton variant="ghost"` `Apply` | `type-serial` | ph `ECLIPSE-2K4A` | — |
| 9 | Referral percentage | `i-referral` | `InputGroup className="max-w-40"` | — → `Icon Percent` sm/subtle | `type-num` | val `5`, `type=number` | — |

`PasswordField` (`page.tsx:54–77`) is the page's only stateful child: `visible` toggles the input `type`, the glyph (`EyeOff` when visible, `Eye` when hidden), `aria-pressed={visible}` and `aria-label` (`"Hide password"` ↔ `"Show password"`).

### 4.2 · `InputGroup` — the addon clearance rule

`InputGroup` (`input-group.tsx:11–23`) is the socket; the control inside is stripped bare.

| element | classes that survive |
|---|---|
| `InputGroup` | `relative flex h-10 w-full min-w-0 items-center rounded-pill border border-input bg-card shadow-pressed outline-none transition-[box-shadow,border-color] duration-base ease-out` |
| `InputGroupInput` | Input base **minus** `rounded-none border-0 bg-transparent shadow-none ring-0 focus-visible:border-transparent focus-visible:ring-0 aria-invalid:ring-0` + `flex-1` |
| `InputGroupAddon` (`inline-start`) | `order-first pl-4` + `flex h-auto cursor-text items-center justify-center gap-2 py-1.5 text-sm font-medium text-muted-foreground select-none` + `has-[>button]:-ml-0.5` |
| `InputGroupAddon` (`inline-end`) | same + `order-last pr-4` + `has-[>button]:-mr-0.5` |
| `InputGroupText` | `flex items-center gap-2 text-sm text-muted-foreground` |
| `InputGroupButton` | `Button variant="ghost"` at **Button's default size** (`size` is `Omit`ted from the Button props) + `flex items-center gap-2 text-sm shadow-none` + size `xs` → `h-6 gap-1 rounded-[calc(var(--radius)-3px)] px-1.5` |

**The clearance rule** (`input-group.tsx:17`, four `has-*` selectors):

| condition | effect on the direct-child `<input>` | from |
|---|---|---|
| a child has `data-align="inline-start"` | `padding-left: 8px` | 16px |
| a child has `data-align="inline-end"` | `padding-right: 8px` | 16px |
| a child has `data-align="block-start"` | `padding-bottom: 12px` | 4px |
| a child has `data-align="block-end"` | `padding-top: 12px` | 4px |

The Input's own `px-4` is 16px because *a pill's corner eats ~20px on a 40px control* (`input.tsx` JSDoc). When an addon sits on that side it supplies the clearance itself (`pl-4`/`pr-4` on the addon), so the input's own padding drops to **8px** — the gap between addon content and value, not between value and curve. Only that side changes.

Specificity is decisive and needs no `twMerge` reasoning: the group's selector is `.has-…:has(> [data-align=inline-end]) > input` = (0,2,1) against the input's own `px-4` at (0,1,0). The group wins.

`has-[>button]:-mr-0.5` / `-ml-0.5` pulls a **−2px** margin when the addon holds a button, so an addon-with-button clears at **14px**, not 16.

Applied to the nine fields (padding-left / padding-right of the value):

| field | pl | pr |
|---|---|---|
| 1 Username (bare Input) | 16 | 16 |
| 2 Email, 4 Search | 8 | 16 |
| 3 Password, 8 Invite | 8 | 8 |
| 5 Quantity, 9 Referral | 16 | 8 |
| 6 Phone | 8 | 16 |
| 7 Deposit amount | 8 | 8 |

### 4.3 · `type-num` / `type-serial` on an input — the size does **not** survive

`.type-*` live in `@layer components`; Tailwind's `text-sm` is a `@layer utilities` rule on the same element. **Utilities win.** So every `className="type-num"` input renders at **13px, not 15**, and `type-num-sm` addon text renders at **13px, not 12**.

| declaration | source layer | outcome on `<input class="… text-sm type-num">` |
|---|---|---|
| `font-family: var(--font-mono)` | components | **applies** — no utility competitor |
| `font-variant-numeric: tabular-nums` | components | **applies** |
| `font-weight: 600` | components | **applies** |
| `letter-spacing: -0.01em` | components | **applies** (Preflight sets `letter-spacing: inherit` on inputs; the class then sets it directly) |
| `font-size: var(--text-body)` 15px | components | **overridden** → `text-sm` **13px** |
| `line-height: 1.2` | components | contested — see below |
| `text-transform: uppercase` (`type-serial` only) | components | **applies** (affects rendering, never the value) |

`--text-sm` is declared as `var(--text-small)` with **no `--text-sm--line-height` companion** (`globals.css:213`), so whether `text-sm` emits a `line-height` at all — and therefore whether it beats `.type-num`'s 1.2 or leaves it standing — is a Tailwind-internal question. **Measure it.** It is inert for the single-line `<input>`s (a UA-rendered single-line text control centres its text in the content box regardless) and matters only for `InputGroupText` spans and the textarea, which pins its own `leading-relaxed`.

Net reading for the port: *"the shared mono foundation" survives as family + weight + figures + tracking, and not as size.* The Quantity field's own description ("Numerical values use the shared mono foundation, even inside inputs") is therefore true-ish; drift 8 records the gap.

### 4.4 · Addon icons render at 16px, stroked as 14px

`InputGroupAddon` carries `[&>svg:not([class*='size-'])]:size-4`. `Icon` sets `width`/`height` as **presentational attributes** and never emits a `size-` class, so the `:not()` matches and the CSS class (16px) beats the attributes (14px). `strokeWidth` is computed in JS from the requested 14 → `(2×24)/14 = 3.43 > 2.6` → **2.4**.

So every `size="sm" tone="subtle"` addon icon on this page paints **16 × 16 at strokeWidth 2.4** — the geometry of an `md` icon with an `sm` icon's stroke. Same for `InputGroupText`'s `[&_svg…]:size-4`. Drift 9.

`InputGroupButton` is the one ambiguous case: its `size="xs"` adds `[&>svg:not(…)]:size-3.5` (14px) while the Button base carries `[&_svg:not(…)]:size-4` (16px). Both are (0,2,1) on the same element, both survive `twMerge` (different variant prefixes), so **source order in the emitted CSS decides**. Measure `getComputedStyle(svg).width` inside the password toggle before porting.

### 4.5 · The Button inside an addon

`InputGroupButton` never passes `size` to `Button` (the prop is `Omit`ted), so `Button` builds at `size="default"` (h-10 px-4) and the group's own `xs` classes then override height, gap, padding and radius via `twMerge`. Resolved: **24px tall, 6px horizontal padding, 4px gap, 7px radius, 13px text, `variant="ghost"`, `shadow-none`**, and the base `btn-spring` + `active:scale-95` + `focus-visible:ring-3 ring-ring/50` survive.

A 7px radius on a control inside a 999px pill is the only non-pill, non-ladder radius in the system.

---

## 5 · Section `#textarea` — "Textarea"

Heading: **"Textarea"**
Description: **"Auto-grows with content via field-sizing. Used for shipping notes and support messages."**

`<Panel label="Textarea">`, `<FieldGroup className="max-w-lg">`, two `<Field>`s:

| # | label | `htmlFor` | props | body | description / error |
|---|---|---|---|---|---|
| 1 | Shipping note | `ta` | — | ph `Anything the packing team should know` | `FieldDescription`: Grows as you type. Minimum height is 80px. |
| 2 | With an error | `ta-err` | `aria-invalid` | val `Too short` | `FieldError`: Please provide at least 20 characters. |

Field 2's `FieldError` has **no `id`** and the textarea has **no `aria-describedby`** — the pairing is visual only. Drift 12.

### 5.1 · Every class (`textarea.tsx:10–14`)

| class | value | vs `Input` |
|---|---|---|
| `flex` | — | — |
| `field-sizing-content` | `field-sizing: content` (stock Tailwind v4 utility; globals.css authors nothing) | — |
| `min-h-20` | **80px** | Input is a fixed `h-10` 40 |
| `w-full` | — | same |
| **`rounded-lg`** | **12px** | **Input is `rounded-pill` 999** |
| `border border-input` | 1px | same |
| `bg-card` | — | same |
| `px-3.5 py-2.5` | **14 / 10** | Input is 16 / 4 |
| `text-sm` | 13px | same |
| `leading-relaxed` | **1.625** → 21.125px line box | Input pins none |
| `shadow-pressed` | permanent inset socket | same |
| `outline-none` | — | same |
| `transition-[box-shadow,border-color,background-color] duration-base ease-out` | 250ms, `cubic-bezier(0.22,1,0.36,1)` | same |
| `placeholder:text-muted-foreground` | — | same |
| `focus-visible:border-primary/50` + `ring-3 ring-ring/35` | — | same |
| `disabled:cursor-not-allowed disabled:opacity-45` | **no `pointer-events-none`** | Input adds it |
| `aria-invalid:border-destructive ring-3 ring-destructive/20` | no `dark:` variant | same |

**The lg-radius exception.** Everything else in the input family is `rounded-pill`: `Input` 999, `InputGroup` 999, `InputGroupButton` 7 (a shrunken `--radius`). The textarea is the family's only member on the **radius ladder** (`--radius-lg` = 12px, `globals.css:327`), and the OTP group borrows the same 12px for its two outer corners. The reason is geometric, not stylistic: a pill's radius is half its height, and half of 80px is a 40px sweep that would swallow the first and last lines of a multi-line field. Port it as a hard exception, not as a parameter default.

Also stock and unmodified: Preflight `textarea { resize: vertical }` (preflight.css:307–309). `field-sizing: content` grows the box with the value; `min-h-20` is the floor and there is **no max**.

---

## 6 · Section `#otp` — "Verification code"

Heading: **"Verification code"**
Description: **"Email verification and two-factor authentication. Six digits, grouped three and three, using the numerical mono foundation."**

`<Panel label="Verification code">` → `<div className="space-y-8">` (**32px** between the two demos). Each demo: `<p className="type-label mb-4">` (11/1/600/upper/0.16em, `--muted-foreground`, **16px below**) then an `InputOTP`.

| demo | label (renders uppercase) | props | slots filled |
|---|---|---|---|
| 1 | **EMPTY** | `maxLength={6}` — uncontrolled | none |
| 2 | **PARTIALLY FILLED** | `maxLength={6} value={otp} onChange={setOtp}`, seeded `"4082"` | 0–3 = `4 0 8 2`; 4–5 empty |

Structure is identical in both: `InputOTPGroup` × 3 slots · `InputOTPSeparator` · `InputOTPGroup` × 3 slots.

The page's own comment (`page.tsx:80–81`) explains why demo 2 is controlled: *"InputOTP manages `value` itself, so passing defaultValue as well makes React warn about a component switching between controlled and uncontrolled."*

### 6.1 · What `input-otp` actually renders

`OTPInput` produces a **relative container** carrying `containerClassName`, the slot markup, and then a sibling `<div style="position:absolute; inset:0; pointer-events:none">` holding **one real `<input>`** stretched over the whole strip.

| element | source | key properties |
|---|---|---|
| container `<div data-input-otp-container>` | inline style | `position: relative; cursor: text; user-select: none; pointer-events: none` |
| … its class | `input-otp.tsx:21` | `cn-input-otp flex items-center has-disabled:opacity-50` |
| real `<input data-input-otp>` | inline style | `position:absolute; inset:0; width:100%; height:100%; display:flex; opacity:1; color:transparent; caret-color:transparent; background:transparent; border:0 solid transparent; outline:0 solid transparent; box-shadow:none; line-height:1; letter-spacing:-.5em; font-size:var(--root-height); font-family:monospace; font-variant-numeric:tabular-nums; pointer-events:all` |
| … its attributes | package | `autoComplete="one-time-code"`, `inputMode="numeric"`, `maxLength=6`, `spellCheck={false}` (from `input-otp.tsx:24`) |
| injected `#input-otp-style` | package | `[data-input-otp]::selection {transparent}`, autofill neutralisation, an iOS `letter-spacing:-.6em` hack, `[data-input-otp] + * { pointer-events: all !important }` |

Three consequences the port must reproduce:
1. The visible boxes are **pure paint** — they receive no events. All input goes to one invisible field, and `pointer-events: all` on it plus `pointer-events: none` on the container is what makes the whole strip one hit target.
2. `caret-color: transparent` means the real caret is never drawn; the visible caret is the fake `<div>` in §6.3.
3. The inline `outline: 0 solid transparent` beats the global `:focus-visible` outline (inline style outranks any non-`!important` rule), so a focused OTP shows **only** the active slot's 3px ring.

**`.cn-input-otp` matches no rule.** Searched `globals.css`, the whole repo, and `node_modules/shadcn/dist/tailwind.css`: it is an inert class name. Port it as a no-op or drop it; the only real container styling is `flex items-center has-disabled:opacity-50`.

### 6.2 · The slot

`InputOTPGroup` — `flex items-center rounded-lg has-aria-invalid:border-destructive has-aria-invalid:ring-3 has-aria-invalid:ring-destructive/20 dark:has-aria-invalid:ring-destructive/40`. It has **no border-width**, so its `has-aria-invalid:border-destructive` is inert; only the ring would show.

`InputOTPSlot` (`input-otp.tsx:59`) — `relative flex size-8 items-center justify-center border-y border-r border-input text-sm transition-all outline-none first:rounded-l-lg first:border-l last:rounded-r-lg`, plus `data-active` and `aria-invalid` variants and **`dark:bg-input/30`**.

| property | value |
|---|---|
| box | **32 × 32**, `box-sizing: border-box` |
| borders | top + bottom + right on every slot; **left only on `:first-child`** → shared 1px hairlines between adjacent slots |
| radius | `first:rounded-l-lg` **12px** on TL+BL, `last:rounded-r-lg` 12px on TR+BR, all inner corners 0 |
| fill | **dark: `--input` @ 30% = `rgba(63,63,70,0.30)`; light: none (transparent)** |
| type | `text-sm` → **13px, sans, weight 400, `--foreground`** — *not* mono |
| transition | `transition-all` at the framework default → **250ms `--ease-out`** (`globals.css:395–396`) |

**States:**

| state | border | ring | z |
|---|---|---|---|
| rest | `--input` | — | auto |
| `data-active=true` | `--ring` | 3px `--ring` @ 50% | **10** |
| `aria-invalid` | `--destructive` | (group) 3px `--destructive` @ 20% light / **40% dark** | auto |
| active + invalid | `--destructive` | 3px `--destructive` @ 20% | 10 |

`z-10` on the active slot exists so its 3px ring paints over the neighbours' borders instead of under them.

Group width: 3 × 32 = **96px** (borders are inside the box). Separator 16px. **Strip total = 96 + 16 + 96 = 208px.**

### 6.3 · Caret behaviour

Derived from the package's slot reducer:

```
isActive     = isFocused && selStart !== null && selEnd !== null
               && ((selStart === selEnd && i === selStart) || (i >= selStart && i < selEnd))
char         = value[i] ?? null
hasFakeCaret = isActive && char === null
```

and from its `onFocus`: `setSelectionRange(min(value.length, maxLength - 1), value.length)`.

| situation | selection | active slot | caret |
|---|---|---|---|
| **both demos at rest (unfocused)** | — | **none** | **none** |
| Empty demo focused | `[0,0]` | 0 | **yes** (slot 0 is empty) |
| Partially-filled demo focused | `[4,4]` | 4 | **yes** |
| a full 6-digit value focused | `[5,6]` | 5 | no — the slot has a char, so only the ring shows |
| caret moved into the middle | collapsed → expanded to a 1-char range by the package's `selectionchange` handler | that slot | only if empty |

**Neither specimen animates on this page as rendered** — the caret and the active ring are focus-only, and nothing on the page autofocuses.

The caret itself (`input-otp.tsx:65–69`):
```html
<div class="pointer-events-none absolute inset-0 flex items-center justify-center">
  <div class="h-4 w-px anim-caret bg-foreground"></div>
</div>
```
**16px tall, 1px wide, `--foreground`**, centred in the 32px slot.

`@utility anim-caret` (`globals.css:2412–2414`) → `animation: pulls-caret 1s steps(1, end) infinite`
`@keyframes pulls-caret` (`globals.css:2454–2457`):

| % | opacity |
|---|---|
| 0, 50 | 1 |
| 50.01, 100 | 0 |

A **1000ms square wave — 500ms on, 500ms off, hard cut, no fade.** `steps(1, end)` makes every gap a hold, and the 50 / 50.01 pair makes the cut unambiguous even without it. The utility's comment records why it exists: *"Was tw-animate-css's `animate-caret-blink` paired with a stock `duration-1000`, so neither its rhythm nor its timing followed the system."*

**No fill mode is declared**, so under `prefers-reduced-motion: reduce` (the blanket rule at `globals.css:2534–2542` collapses duration to 0.01ms and iterations to 1) the caret reverts to the element's own resting style — **opacity 1, steady, visible**. In port terms: `DsKeyframeFill.none`.

`anim-caret` is the **only `anim-*` utility the motion page does not demonstrate**, which is exactly why `lib\src\motion\keyframes.dart` transcribes eleven tables and not twelve. See §16.2.

---

## 7 · Section `#validation` — "Validation messages"

Heading: **"Validation messages"**
Description: **"An error must say what is wrong and what to do about it. Errors appear below the field, never as a tooltip, and never only as a red border."**

`<Panel label="Field anatomy">` — this is the page's Field & Label chapter; there is no section by that name.

| # | label | `htmlFor` / `id` | control | linkage | message |
|---|---|---|---|---|---|
| 1 | Email | `v1` | `Input` val `collector@pulls`, `aria-invalid` | `aria-describedby="v1-err"` → `FieldError id="v1-err"` | That address is missing a domain. Try collector@pulls.xyz. |
| 2 | Withdrawal amount | `v2` | `InputGroup` [`$` `type-num`] + `InputGroupInput` val `2,400.00` `type-num` `aria-invalid` | `aria-describedby="v2-err"` → `FieldError id="v2-err"` | Exceeds your available balance of $1,204.80. Bonus balance cannot be withdrawn. |
| 3 | Username | `v3` | `Input` val `voidwing`, `className="border-value/50"` | `aria-describedby="v3-ok"` → `FieldDescription id="v3-ok" className="text-value-ink"` | Available. |

Then `<Note tone="error" title="Never colour alone" className="mt-4">` (16px above), body verbatim (two `Code` chips):

> A red border on its own is invisible to a colour-blind user. Errors always ship three signals: `aria-invalid`, the destructive border, and a written message linked by `aria-describedby`.

`tone="error"` box: border `--destructive` @ 30%, fill @ 8%, radius 12px, padding 20px. Title and body both render `--muted-foreground` (§2) — a red-tinted box with entirely grey text.

### 7.1 · `Field` / `FieldLabel` / `FieldDescription` / `FieldError` anatomy

| component | element | classes that render | resolved |
|---|---|---|---|
| `FieldGroup` | `div` | `flex w-full flex-col gap-5` + `@container/field-group` | **20px** between fields |
| `Field` | `div role="group"` | `group/field flex w-full gap-2 flex-col *:w-full` + `data-[invalid=true]:text-destructive-ink` | **8px** stack; children stretch |
| `FieldLabel` → `Label` | `label` (Radix) | `flex items-center gap-2 text-sm font-medium select-none` + `flex w-fit gap-2 leading-snug` | **13 / 1.375 / 500**, colour inherited = `--foreground`, `width: fit-content` |
| `FieldDescription` | `p` | `text-left text-sm leading-normal font-normal text-muted-foreground` + `last:mt-0 nth-last-2:-mt-1` | **13 / 1.5 / 400 / `--muted-foreground`** |
| `FieldError` | `div role="alert"` | `text-sm font-normal text-destructive-ink` | **13 / 400 / `--destructive-ink`**, line-height **inherited** (no leading class, and `html`/`body` set none → `normal`) |

`leading-snug` (1.375) on the label overrides `Label`'s own `leading-none`; `w-fit` narrows the label to its text so a click target is not the full 512px.

`fieldVariants` carries `data-[invalid=true]:text-destructive-ink` for the whole group and **the page never sets `data-invalid` on any `Field`** — it puts `aria-invalid` on the control instead. So no label ever turns red, despite the API entry claiming Field "Handles the invalid colouring for the whole group". Drift 11.

### 7.2 · The accessibility contract, and its Flutter translation

| web | where | Flutter |
|---|---|---|
| `<label for=id>` | `FieldLabel htmlFor` (7 of 9 in §4, both in §5, all 3 here) | no equivalent. Make the label a tap target that calls `focusNode.requestFocus()`, and merge its text into the field's `Semantics(label:)`. |
| `aria-label` on an unlabelled field | the 8 state cells + the password input | `Semantics(label:)` — `DsInput.label` already does this (`input.dart:270–271`) |
| `aria-invalid` | Input / Textarea / InputGroupInput | **`Semantics(validationResult: SemanticsValidationResult.invalid)`** — present in Flutter 3.44.8 (`sky_engine/lib/ui/semantics.dart:1666`, `SemanticsProperties.validationResult`), and it is what emits `aria-invalid` on web. |
| `aria-describedby` | `v1`→`v1-err`, `v2`→`v2-err`, `v3`→`v3-ok` | no equivalent. Fold the description/error string into the field's `Semantics(hint:)`. |
| `role="alert"` on `FieldError` | field.tsx:222 | `Semantics(liveRegion: true)` |
| `role="group"` | `Field`, `InputGroup`, `InputGroupAddon` | `Semantics(container: true, explicitChildNodes: true)` |
| `role="separator"` | `InputOTPSeparator` | none — wrap in `ExcludeSemantics` |
| `aria-pressed` | the password toggle | `Semantics(button: true, toggled: visible)` |
| `type` / `inputMode` | 6 distinct values on this page | `TextInputType.{text,emailAddress,visiblePassword,text,number,phone}` + `keyboardType`; `inputMode="decimal"` → `TextInputType.numberWithOptions(decimal: true)` |
| `autoComplete="email"` / `"tel"` / `"one-time-code"` | fields 2, 6, OTP | `autofillHints: [AutofillHints.email / telephoneNumber / oneTimeCode]` |
| `type="password"` toggling | `PasswordField` | `obscureText: !visible` |
| `spellCheck={false}` | OTP | `enableSuggestions: false, autocorrect: false` |

Recommended composite: one `DsField` that owns label + control + description/error and publishes a single merged semantics node — `textField: true`, `label` = the visible label, `hint` = description or error, `validationResult` = invalid when the control is, and `liveRegion` on the error subtree only. That reproduces what a screen reader announces from the web page without inventing an id graph Flutter cannot express.

---

## 8 · Section `#form` — "A complete form"

Heading: **"A complete form"**
Description: **"Everything assembled: labels above fields, 20px between fields, description under the field it describes, and the primary action separated by a rule."**

`<Panel label="Deposit funds">` → `<form className="max-w-lg" onSubmit={e => e.preventDefault()}>` (512px; the `FieldGroup` inside carries **no** `max-w`).

| # | label | `htmlFor` | control | description |
|---|---|---|---|---|
| 1 | Amount | `f-amount` | `InputGroup` [`$` `type-num`] + input `inputMode=decimal` ph `0.00` `type-num` + [`USD`] | Minimum $10.00. Deposits clear instantly. |
| 2 | Promo code | `f-promo` | bare `Input` ph `Optional` | — |

Footer: `<div className="mt-8 flex gap-3 border-t border-border pt-6">` — **32px above, 1px `--border` rule, 24px below it, 12px gap**.

| button | variant | type | label |
|---|---|---|---|
| 1 | `premium` | `submit` | **Deposit Funds** |
| 2 | `ghost` | `button` | **Cancel** |

Both at `size="default"` / `emphasis="none"` — full anatomy in `shadows-map.md` §5.1–5.2. The premium button brings `foil-value`'s two infinite animations onto this page (§13).

---

## 9 · Section `#api` — "API" (no description)

`<Meta items={…}>` — `dl` `divide-y divide-border overflow-hidden rounded-lg border border-border bg-card`; rows `px-4 py-3`, `sm:grid-cols-[minmax(0,13rem)_1fr] sm:gap-4`; `dt` `type-num-sm text-action-ink` (12px mono 600 tabular), `dd` `type-small text-muted-foreground` (13/1.5/400). Six rows, verbatim:

| k | v |
|---|---|
| `Input` | Native input props. 40px tall, 10px radius, bg-muted fill. Set type for the right keyboard and autofill. |
| `Textarea` | Auto-grows via field-sizing-content. Minimum 80px. |
| `InputGroup` | Wraps a control with addons. Use InputGroupAddon align="inline-start" \| "inline-end". |
| `Field` | Field + FieldLabel + FieldDescription + FieldError. Handles the invalid colouring for the whole group. |
| `InputOTP` | maxLength sets the digit count. Group in threes with InputOTPSeparator between. |
| `aria-invalid` | The single switch for the error appearance. Pair it with a FieldError and aria-describedby. |

The `InputGroup` value contains **escaped straight double quotes** around `inline-start` and `inline-end` (`\"` in the source), and a literal `|` with spaces.

---

## 10 · Section `#rules` — "Rules" (no description)

`DoDont` anatomy per `shared-map.md` §2. Five each — the first page in the corpus with five rather than four.

Dos (verbatim):
1. Label every field visibly; placeholders disappear the moment typing starts.
2. Use the numerical mono foundation for money and quantities, and type-serial for serial codes.
3. Set the right type — email, tel, number, search — so mobile keyboards and autofill work.
4. Say what is wrong and how to fix it, and link the message with aria-describedby.
5. Mark optional fields as optional rather than marking every required one.

Don'ts (verbatim, straight `'` apostrophes in the array; only the panel heading uses `&rsquo;`):
1. Don't use a placeholder as the label.
2. Don't signal an error with a red border alone.
3. Don't show validation errors while the user is still typing their first attempt.
4. Don't put a currency symbol inside the value; it belongs in an addon.
5. Don't disable a submit button without saying what is missing.

Do #3's dashes are **U+2014 em dashes**. Do #1 is contradicted by the password field, which has a visible label that is not associated with its control (drift 10); Do #2 is contradicted by §4.3.

---

## 11 · Foot nav (`PageFootNav groupId="base" slug="inputs"`)

Both siblings exist (`base` order: buttons → **inputs** → forms → selects → …):

- **Previous** → **"Buttons"**, `/design-system/components/base/buttons`
- **Next** → **"Forms"**, `/design-system/components/base/forms`

Anatomy per `shared-map.md` §2 / `shadows-map.md` §9. Neither target page is ported, and neither is the reference route for them — the foot nav is the first thing on this page that links out of the built set.

---

## 12 · The real state matrix (what the port must implement)

The §3 grid shows eight *appearances*; these are the *rules*. `hover` is absent from every row on purpose: **no member of this family declares a hover rule.**

### 12.1 · `Input` (bare)

| state | border | box-shadow | fill | ink | other |
|---|---|---|---|---|---|
| rest | `--input` | `--shadow-pressed` | `--card` | inherit `--foreground`; ph `--muted-foreground` | — |
| hover | *(no rule)* | | | | identical to rest |
| focus-visible | `--primary` @ **50%** | pressed **+** `0 0 0 3px` `--ring` @ **35%** | `--card` | — | 250ms `--ease-out` |
| disabled | `--input` | pressed | `--card` | — | `opacity: .45`, `pointer-events: none`, `cursor: not-allowed` |
| aria-invalid | `--destructive` | pressed **+** 3px `--destructive` @ **20%** | `--card` | — | no `dark:` variant |
| read-only | *(no rule)* | | | | value only |
| with value | *(no rule)* | | | | the placeholder simply stops painting |

### 12.2 · `InputGroup` (the socket) — deliberately **not** the same recipe

| state | border | ring | opacity |
|---|---|---|---|
| rest | `--input` | — | 1 |
| a control inside is `:focus-visible` | **`--ring`** (not `--primary/50`) | 3px `--ring` @ **50%** (not 35) | 1 |
| any `[data-slot][aria-invalid=true]` inside | `--destructive` | 3px `--destructive` @ 20% light / **40% dark** | 1 |
| any descendant `:disabled` | `--input` | — | **0.50** (not 0.45) |

The `InputGroupInput` itself is neutered — `border-0 shadow-none ring-0 focus-visible:ring-0 aria-invalid:ring-0` — so **all** of it is painted by the wrapper. Two consequences: a bare invalid `Input` rings at 20% in both themes while an invalid `InputGroup` rings at 40% on dark (drift 6), and a disabled group fades to 50% while a disabled input fades to 45% (drift 7).

### 12.3 · `Textarea`

Identical to §12.1 except: radius **12px**, `min-height: 80px` with `field-sizing: content`, `px-3.5 py-2.5`, `leading-relaxed` 1.625, and `disabled` omits `pointer-events-none`.

### 12.4 · `InputOTPSlot` — §6.2. `InputOTPGroup` — invalid ring only, border-width 0.

### 12.5 · `InputGroupButton` — ghost `Button` at 24 × auto, 7px radius; states per `shadows-map.md` §5.2 variant 5.

---

## 13 · Motion inventory for this page

| # | where | trigger | spec |
|---|---|---|---|
| 1 | `Input`, `Textarea` | focus / blur / invalid | `transition-[box-shadow,border-color,background-color]` **250ms `--ease-out`** |
| 2 | `InputGroup` | focus-within / invalid | `transition-[box-shadow,border-color]` 250ms `--ease-out` (**no** `background-color`) |
| 3 | `InputOTPSlot` | active / invalid | **`transition-all`** at the framework default → 250ms `--ease-out` (`globals.css:395–396`) |
| 4 | OTP fake caret | always, while a slot is active and empty | **`pulls-caret` 1s `steps(1, end)` infinite** — 500 on / 500 off |
| 5 | `InputGroupButton` (2 of them) | any state change | `btn-spring` — 250ms `--ease-spring`, 80ms while `:active` |
| 6 | `InputGroupButton` | active | `scale(0.95)` |
| 7 | premium "Deposit Funds" | always | `value-foil-drift 11s linear infinite` + `value-glint 5.5s --ease-in-out infinite` |
| 8 | premium button | hover | foil opacity 0.95→1, glint duration → 2.4s, shadow → `--shadow-glow-value` |
| 9 | ghost "Cancel" | hover / active | fill only, via `btn-spring` |
| 10 | foot-nav links | active / hover | `press` — `scale(0.94)`, 40ms in / 250ms spring out |
| 11 | anchors | click | smooth scroll, 96px `scroll-padding-block-start` |

Nothing enters, nothing scroll-triggers. Under reduced motion the blanket rule collapses everything; the caret and both foil loops declare no fill mode and therefore **revert to stop 0** — a steady visible caret, a static foil.

---

## 14 · Token reference — only what is new against the corpus

Colours, radii, durations and easings are in `shadows-map.md` §11 and `globals-map.md`. New or newly load-bearing here:

| token / value | resolved |
|---|---|
| `--radius` | **10px, both themes** (`:605`, `:814`) — the only consumer is `input-group.tsx` |
| `calc(var(--radius) - 3px)` | **7px** — `InputGroupButton` size `xs` |
| `calc(var(--radius) - 5px)` | **5px** — `[&>kbd]` inside an addon; unused on this page |
| `--text-sm` | `var(--text-small)` = **13px**, **no `--line-height` companion** (`:213`) |
| `--radius-lg` | **12px** — textarea + OTP outer corners |
| `dark:bg-input/30` | `rgba(63,63,70,0.30)` — the OTP slot fill; **light has none** |
| `ring-destructive/20` | `rgba(220,38,38,0.20)` |
| `dark:ring-destructive/40` | `rgba(220,38,38,0.40)` |
| `border-value/50` | `rgba(163,230,53,0.50)` |
| `ring-ring/35` | dark `rgba(146,194,252,0.35)` · light `rgba(26,110,244,0.35)` |
| `ring-ring/50` | dark `rgba(146,194,252,0.50)` · light `rgba(26,110,244,0.50)` |
| `.type-num` | mono / **15px** / 1.2 / 600 / −0.01em / tabular (`:1275`) |
| `.type-serial` | mono / **15px** / 1.4 / weight inherited / −0.01em / **uppercase** (`:1211`) |
| `.type-num-sm` | mono / 12px / 1.2 / 600 / −0.01em / tabular (`:1271`) |
| `.type-caption` | 10.5 / 1.35 / **500**, not uppercase (`:1151`) — `StateCell`'s note |
| shared numeric base | `:1256–1266` — family, tabular, 600, −0.01em; each size class adds only size + leading |

Preflight facts that matter and are **not** overridden anywhere: inputs get `font: inherit; letter-spacing: inherit; color: inherit; border-radius: 0; background-color: transparent` (preflight.css:243–252); `::placeholder { opacity: 1 }` and, absent an override, `color: color-mix(in oklab, currentcolor 50%, transparent)` (:287–301) — every field on this page **does** override it with `placeholder:text-muted-foreground`; `textarea { resize: vertical }` (:307); number spinners are **not** hidden, only height-normalised (:387).

---

## 15 · CSS → Flutter conversion notes

Blur/sigma, paint order, border-box and the ring composition are settled in `shadows-map.md` §13; the ring-in-front-of-shadow order is confirmed again here (Tailwind's fixed `box-shadow: inset-shadow, inset-ring, ring-offset, ring, shadow`, so `--tw-ring-shadow` paints in front of `shadow-pressed`). New for this page:

### 15.1 · `field-sizing: content`
`EditableText(maxLines: null)` inside `ConstrainedBox(minHeight: 80)`. There is no maximum, and `resize: vertical` is UA chrome with no Flutter counterpart — drop it.

### 15.2 · Per-side borders and partial radii on the OTP slot
`DsMachineSurface` already accepts a `BoxBorder` and a full `BorderRadius` (`machine_surface.dart:27–34`), and its box-sizing inset uses `border!.dimensions`, which is per-side. So `Border(top:…, right:…, bottom:…, left: BorderSide.none)` with `BorderRadius.only(topLeft:…, bottomLeft:…)` needs no change. The active slot's `z-10` is a paint-order concern: build the strip as a `Stack`, or reorder so the active slot paints last.

### 15.3 · The OTP input model
Mirror the package: one focusable `EditableText` with `showCursor: false` and a transparent cursor, sized to the strip and hit-testing over it, driving painted slot boxes from `controller.value.text` and `selection`. Do **not** build six focusable fields — the selection semantics (`onFocus` → `setSelectionRange(min(len, max-1), len)`, and the middle-caret expansion to a 1-char range) are what make the ring land on the right box.

### 15.4 · `pulls-caret`
`DsKeyframePlayer(duration: 1000ms, repeat: true, fill: DsKeyframeFill.none)` over a two-stop opacity table evaluated through the existing `DsSteps(1)` curve — the same machinery `DsSignOn` uses. Because `steps(1, end)` means "hold, then snap", model it as a discrete lookup (`t < 0.5 → 1`, else `0`) rather than a tween, exactly as `DsSignOn.frameAt` does.

### 15.5 · Semantics
See §7.2. `Semantics(validationResult:)` and `liveRegion:` exist in 3.44.8 and are the only two aria features on this page with real Flutter counterparts; `aria-describedby` and `for=` have none and must be collapsed into one merged node per field.

### 15.6 · Text metrics
`text-sm` beats `.type-num`'s size, so an input's mono value is **13px/600/tabular/−0.01em**, i.e. `DsType.numSm`'s treatment at `DsType.small`'s size. Neither existing spec is it. Either add an `inputNum` spec in `typography.dart` or derive one by `copyWith`-ing `numBase` down to 13 — but do it in the foundation layer, because the token guard forbids a bare `fontSize:` anywhere else.

---

## 16 · Exists in the port / missing

Package root `D:\DESIGN\Design-System-2026-8\flutter-design-system\`.

### 16.1 · Already built — reuse, do not re-derive

| need | where |
|---|---|
| Pill field: 40px, `--input` border, `--card` fill, permanent `pressed` socket, focus ring @35% + border `--primary`@50%, 250ms `--ease-out`, real caret, placeholder, `disabled` @45%, `label` semantics | `lib\src\components\input.dart` — `DsInput` (:62), `DsInput.height` (:95) |
| Inset painting, per-side border, partial radius, box-sizing inset | `lib\src\effects\machine_surface.dart:27–94` |
| Focus-ring composition (3px, in front of the element's shadow) | `DsButton.withFocusRing` (`button.dart:241`) |
| All 7 button variants incl. `premium` + `ghost`, with foil and sheen | `button.dart:38–84`, `effects\foil_value.dart`, `effects\sheen_action.dart` |
| `--shadow-pressed` and every other shadow token | `foundation\shadows.dart:197` |
| `input`, `card`, `border`, `ring`, `primary`, `destructive`, `destructiveInk`, `valueInk`, `mutedForeground`, `radius`(=10) … — **nothing missing** | `foundation\theme.dart:94–268` |
| `DsRadii.lg` 12, `.pill` 999, `.sm` 6; `DsWidths.hairline`; `ds(n)` | `foundation\spacing.dart:14, 66, 85–106` |
| `DsDurations.base` 250, `DsCurves.out` | `foundation\motion.dart:27, 216` |
| `DsType.numBase` / `numSm` / `serial` / `label` / `small` / `caption`; tabular figures wired | `foundation\typography.dart:501, 490, 420, 387, 336` |
| `DsSteps(1, jump-end)`, `DsKeyframePlayer`, `DsKeyframeFill.none` | `motion\keyframes.dart:71, 260, 125` |
| Glyphs `eye`, `eyeOff`, `search`, `lock`, `percent`, `minus`, `check`, `x`, `arrowLeft`, `arrowRight` | `components\icon_paths.dart:105–140` |
| `DsIconSize.sm` (14) / `md` (16), `DsIconTone.subtle` | `components\icon.dart:30, 33, 76` |
| Kit: `DsPageHeader`, `DsSection`, `DsPanel`, `DsMeta`, `DsCode`, `DsDoDont`, `DsNote`, `DsGrid`, `DsPageFootNav` | `example\lib\kit.dart:54, 148, 242, 390, 448, 735, 834, 908, 1156` |
| Nav entry for `inputs` — slug, title, blurb, all 10 chips; siblings resolve to Buttons / Forms | `example\lib\nav.dart:207–224`, `siblings` :731 |
| Closest structural template | `example\lib\pages\shadows.dart` (its `#in-use` panel is the only existing `DsInput` call site, :429) |

### 16.2 · Missing — must be built

| # | missing | notes |
|---|---|---|
| 1 | `example\lib\pages\inputs.dart` + a `switch` arm at `example\lib\main.dart:108–119` | currently falls through to `PlaceholderPage("Base Components" / "Inputs")` at :133 |
| 2 | **`DsTextarea`** | 12px radius, `min-h 80`, `px-3.5 py-2.5`, `leading-relaxed` 1.625, auto-grow, same socket + focus/invalid recipe as `DsInput` |
| 3 | **`DsInputGroup` + `DsInputGroupAddon` / `Text` / `Button` / `Input`** | the whole §4.2 machine, including the 16→8 clearance rule and the −2px button pull |
| 4 | **`DsInputOtp`** (`Group`, `Slot`, `Separator`) | §6 whole; one hidden field driving painted 32px boxes |
| 5 | **`pulls-caret` keyframe table** | `keyframes.dart` has eleven and not this one — it is the only `anim-*` utility the motion page never demonstrates |
| 6 | **`DsField` / `DsFieldLabel` / `DsFieldDescription` / `DsFieldError` / `DsFieldGroup`** | §7.1 + the merged-semantics contract of §7.2 |
| 7 | **`DsStateGrid` / `DsStateCell`** in `example\lib\kit.dart` | nothing in the repo; the `gap-px` + `bg-border` hairline trick has no existing analogue |
| 8 | **`DsInput` API surface** — no addon slots, no `invalid`, no `readOnly`, no `radius`, no `size`, no `keyboardType`/`autofillHints`, no `obscureText`, no multiline, no `controller`-less value seeding beyond a controller | `input.dart:63–72`. Every §3 and §4 specimen needs at least one of these. |
| 9 | **`DsButtonSize.xs`** (24px, 6px padding, 4px gap) **and a `radius` override on `DsButton`** | `button.dart` hardcodes `BorderRadius.circular(DsRadii.pill)` at :471; `heightFor`/`gapFor`/`paddingXFor` (:201–226) are exhaustive switches |
| 10 | **A 7px radius token** | `calc(var(--radius) - 3px)`; `DsRadii` has 6 and 10, not 7 |
| 11 | **An `inputNum` / `inputSerial` text spec** (13px + mono/600/tabular, and 13px + mono/uppercase/1.4) | §15.6; must live in `foundation\typography.dart` |
| 12 | **Glyphs `atSign` and `ticket`** | not among the curated 63, so they are off-set additions alongside `rotateCcw` (`icon_paths.dart:150`) and **must not** enter the icons page registry. lucide-react v1.28.0 nodes: `at-sign` = `circle(12,12,4)` + `path "M16 8v5a3 3 0 0 0 6 0v-1a10 10 0 1 0-4 8"`; `ticket` = `path "M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z"` + `path "M13 5v2"` + `path "M13 17v2"` + `path "M13 11v2"` |
| 13 | **A `DsDurations` entry for the caret's 1000ms** | `bloom` is also 1000ms but means `--duration-bloom`; see open question 4 |
| 14 | `_referenceHeight['inputs']` in `example\test\vertical_parity_probe_test.dart:45–50` and a `_referenceBreaks['inputs']` block in `wrap_parity_probe_test.dart:183–367` | both must be measured off the live dev server at 1440×900 first; the wrap probe asserts its table is fully spent |
| 15 | `example\test\inputs_page_test.dart` | model on `shadows_page_test.dart` |

**Port bug found in passing:** `DsInput` paints its selection at `theme.primary` @ **0.30** (`input.dart:55`, :180) while `globals.css:1008` and the example app's own `DefaultSelectionStyle` both say **0.35** (`example\lib\main.dart:27`). The field also ignores `::selection`'s `color: var(--foreground)`. One field in the system selects differently from every other.

### 16.3 · Guard-test constraints

`test\token_guard_test.dart` rules and the `// allow-hardcoded: <reason>` escape are unchanged (see `shadows-map.md` §14.3). Consequences specific to this page:
- `rounded-lg` → `DsRadii.lg`; the 7px addon-button radius needs a **new** `DsRadii` member, not a literal.
- The two new glyph path strings are guard-clean by construction (coordinates in a `d` string trip nothing).
- `pulls-caret`'s two stops and the 1000ms period need either a `DsDurations` member or an escape-hatch comment.
- The scan is raw text **including comments**, so a doc comment that spells out `BoxShadow(` or `fontSize: 13` trips the same rule.

---

## 17 · Drift register (record, do not fix)

1. **The eyebrow says "Base" twice.** `DsPageHeader eyebrow={`${group.title} · Base`}` with `group.title` = "Base Components" → **"Base Components · Base"**. Every other page passes a plain group title.
2. **The opening Note's radius claim.** *"Both were changed: 40px and 10px"* — `input.tsx` is `rounded-pill` (**999px**), not 10. 10px is `--radius`, which only `input-group.tsx` reads and only via `calc()`.
3. **The opening Note's fill claim.** *"Fields are also filled with `bg-muted`"* — every field in the family is **`bg-card`**. On light both are white-ish but different (`#FFFFFF` vs `#F4F4F5`); on dark they are `#18181B` vs `#27272A`, plainly distinct. Repeated by the API entry ("bg-muted fill"), so it is stated twice on one page.
4. **The Hover specimen changes nothing.** `className="border-input"` is already in the base class list, and no `hover:` rule exists on any input primitive. The note "Border strengthens" describes an appearance the system does not have.
5. **The Focus specimen shows the wrong focus.** It paints `border-ring ring-3 ring-ring/50` — the *Button*'s recipe. The real one is `border-primary/50` + `ring-ring/35`. A reader copying the specimen gets the wrong ring by 15 percentage points and the wrong border token.
6. **Invalid ring alpha differs by wrapper.** Bare `Input` and `Textarea`: `ring-destructive/20`, no `dark:` variant. `InputGroup` and `InputOTPGroup`: 20% light / **40% dark**. The same error state is two different reds depending on whether an addon happens to be present — visible on this very page, §7 fields 1 and 2 side by side.
7. **Disabled opacity differs by wrapper.** `Input`/`Textarea` `disabled:opacity-45`; `InputGroup`/`InputOTP` `has-disabled:opacity-50`.
8. **"the numerical mono foundation" is 13px, not 15.** `.type-num` sits in `@layer components` and `text-sm` in `@layer utilities`, so the class contributes family, weight, tracking and tabular figures — and loses its size. Three places assert the foundation is in use (§4 field 5's description, §6's section description, Do #2).
9. **Addon icons are requested at 14 and painted at 16.** `size="sm"` sets width/height attributes; `[&>svg:not([class*='size-'])]:size-4` on the addon overrides them with a CSS class, while `strokeWidth` stays computed from 14 (= 2.4). Seven icons on this page.
10. **The password field has a visible label bound to nothing.** `<FieldLabel>Password</FieldLabel>` carries no `htmlFor`, and the control is identified by `aria-label="Password"` instead. Clicking the label does nothing. Do #1 on the same page says *"Label every field visibly"*.
11. **`Field`'s invalid colouring never fires.** `fieldVariants` keys off `data-[invalid=true]`, which the page never sets; it sets `aria-invalid` on the control. The API entry claims Field "Handles the invalid colouring for the whole group".
12. **The textarea error is not linked.** §5 field 2 has `aria-invalid` and a `FieldError`, but no `id` on the error and no `aria-describedby` on the control — the exact three-signal contract the §7 Note insists on, missing its third signal, two sections earlier.
13. **The OTP digits are not mono.** `InputOTPSlot` is `text-sm` (Inter 13/400) with no `type-num*` class; the section description says *"using the numerical mono foundation"*. The only mono in the OTP is the invisible overlay input's `font-family: monospace`, which paints nothing.
14. **`.cn-input-otp` matches no rule** anywhere in the project or its dependencies.
15. **`InputOTPGroup`'s `has-aria-invalid:border-destructive` is inert** — the group has no border-width. Only its ring would show.
16. **Both OTP demos are static as rendered.** The active ring and the caret both require focus; nothing autofocuses. The "Partially filled" label describes the value, not a caret position.
17. **The `Note` tone ink is unreachable.** `tone="error"` tints only the border and wash — `.type-label` and the body's explicit `text-muted-foreground` mean nothing inside a Note ever renders in the tone colour. *(General to the kit; recorded here because this is the first page to use `tone="error"`. It also corrects `shadows-map.md` §2/§7.3.)*

---

## 18 · Open questions for the supervisor

1. **Scope of the component build.** This page needs five net-new components (`DsTextarea`, `DsInputGroup` family, `DsInputOtp`, `DsField` family, `DsStateGrid`) plus a substantial widening of `DsInput`. **Recommendation:** build them as real, reusable package components in `lib\src\components\`, not page-local specimens — `forms`, `selects` and `selection` are the next three siblings and every one of them consumes `DsField` and `DsInputGroup`. Budget accordingly rather than discovering it on the Forms page.
2. **`DsInput`'s API shape.** The page demands prefix/suffix slots, `invalid`, `readOnly`, `keyboardType`, `autofillHints`, `obscureText`, a value seed and a radius override. **Recommendation:** keep `DsInput` as the bare pill and put the addon machinery in `DsInputGroup` — that is exactly how the reference splits it (`InputGroupInput` *strips* the Input rather than extending it), and it keeps the shadows page's existing call site untouched.
3. **The Hover and Focus specimens (drifts 4 and 5).** Per the fidelity bar these ship as the reference renders them — cell 2 identical to cell 1, cell 3 painting a ring the component never produces. Confirm, because a Flutter `DsInput` with no way to force a fake focus appearance would need one added purely to reproduce a mistake.
4. **The caret's 1000ms.** `DsDurations.bloom` is already 1000ms but means `--duration-bloom`. Add `DsDurations.caret = 1000ms` (a token the CSS does not name either — it is an inline `1s`), reuse `bloom`, or hold it in the OTP file with an escape hatch? **Recommendation:** a named `caret` member, consistent with how `beatHover`/`glint`/`foilDrift` were handled for the shadows page.
5. **The 7px radius.** `calc(var(--radius) - 3px)` is derived, not a token. Add `DsRadii.addonButton = 7`, or expose `theme.radius` arithmetic at the call site? **Recommendation:** a derived getter next to `DsRadii` so the relationship to `--radius` = 10 survives a change to `--radius`, since that is what the CSS expresses.
6. **`atSign` and `ticket`.** Both are off the curated 63. Confirm they join `rotateCcw` as off-set glyphs and that `icons_page_test.dart`'s registry assertion must continue to exclude them.
7. **The `type-num` size collapse (drift 8).** Ship the measured 13px, or the 15px the class nominally declares? **Recommendation:** ship 13px — it is what the browser paints, and the fidelity bar is measured parity, not stated intent. Flag it in the page's doc comment so the next reader does not "fix" it.
8. **Two measurements are blocking.** `_referenceHeight['inputs']` and the wrap table both need the live page at 1440×900. Same question as shadows open-question 1: is that measurement mine to take, or supplied?
9. **The `text-sm` line-height question (§4.3).** Whether Tailwind emits a `line-height` for `text-sm` given `--text-sm` has no companion token decides whether `.type-num`'s 1.2 survives on the `InputGroupText` spans and inside the textarea. One `getComputedStyle` call settles it; it should be taken in the same browser session as question 8, along with the `InputGroupButton` icon size in §4.4.
10. **The selection-alpha bug (§16.2).** `DsInput` uses 0.30 where the reference and the rest of the port use 0.35. Fix it in this task, or spin it out? **Recommendation:** fix in place — it is one constant and the shadows page's own test does not assert it.
