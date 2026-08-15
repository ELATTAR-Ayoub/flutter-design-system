# Map — `/design-system/components/base/forms` (Base Components · Forms)

**Files that produce the render** (all under `D:\DESIGN\Design-System-2026-8\design-system\`):
- `app\design-system\components\base\forms\page.tsx` — the page. **`"use client"`** (the first ported page that is). 655 lines; five page-local components (`AccountForm`, `PasswordForm`, `ServerErrorForm`, `ComposedForm`, `SubmitStates`) and four module-level Zod schemas.
- `components\ds\kit.tsx` — `DsPageHeader`, `DsSection`, `Panel`, `StateGrid` (:145), `StateCell` (:173), `Meta` (:202), `Code`, `DoDont`, `Note`, `PageFootNav`. **`StateGrid`/`StateCell`/`Meta` are used here and are not on any foundations page.**
- `components\ui\form.tsx` — the wiring layer. **No presentation at all.** §3.
- `components\ui\field.tsx` — the presentation layer: `FieldSet`, `FieldLegend`, `FieldGroup`, `Field`, `FieldLabel`, `FieldDescription`, `FieldError` (+ `FieldContent`, `FieldTitle`, `FieldSeparator`, unused here).
- `components\ui\label.tsx` — `Label` (radix `Label.Root`), which `FieldLabel` extends.
- `components\ui\input.tsx` · `textarea.tsx` · `select.tsx` · `checkbox.tsx` · `radio-group.tsx` · `switch.tsx` — six controls, all live.
- `components\ui\button.tsx` — **`loading` prop lives here** (`:104`, `:115`, `:124`, `:134–136`). `components\ui\spinner.tsx` — the spinner.
- `components\ui\alert.tsx` — the server-error surface; carries `bloom-cosmic` + `starfield`.
- `components\ui\sonner.tsx` + `app\layout.tsx:39` (`<Toaster position="bottom-right" />`) — six toasts fire from this page.
- `components\ui\icon.tsx` — `XCircle` (Alert), `ChevronDown`/`Check`/`ChevronUp` (Select), `Loader2` (Spinner), `Check`/`X` (DoDont), `ArrowLeft`/`ArrowRight` (foot nav).
- `lib\ds\nav.ts:165–177` — `findCategory("base","forms")`; `siblings()` → prev **Inputs**, next **Selects & Pickers**.
- `app\globals.css` — every token/utility below.
- Deps: `react-hook-form ^7.84.0`, `@hookform/resolvers ^5.7.1`, `zod ^4.4.3`, `sonner ^2.0.7`, `radix-ui ^1.6.7`, `lucide-react ^1.28.0`.

Read with `shared-map.md` (shell, kit anatomy, type-class table, Icon sizes/tones) and `shadows-map.md` (§5.1 Button base, §5.5 Input, §11 tokens, §13 CSS→Flutter conversion). Nothing there is repeated except where this page consumes it differently.

**Measurement note.** Everything marked *(measured)* was read out of the built stylesheet at `.next\static\chunks\2xoei7gie4yqt.css` by byte offset — Tailwind v4 sorts by variant, not by class-attribute order, so cascade winners on this page are facts, not deductions.

---

## 0 · Shell / layout metrics — delta from foundations

Identical shell (`shared-map.md` §1). What is new on this page:

| thing | value |
|---|---|
| Route | `/design-system/components/base/forms` (base group → `${DS_ROOT}/components/base/forms`) |
| Specimen column | **1080px** at the 1440 frame, as everywhere |
| **Form column** | `<form className="max-w-md">` = **448px** (28rem; Tailwind container scale not overridden) — every one of the four forms |
| Panel body | `bg-background p-6` → 24px, so the 448px form sits left-aligned in a 1030px body |
| Section rhythm | `mb-20` (80px); heading block `mb-6`; every Note/Meta/DoDont at `mt-6` (24px) |

---

## 1 · Page header (`DsPageHeader`)

`<header class="mb-14 border-b border-border pb-10">`.

1. Eyebrow `type-label text-action-ink` → **"Base Components · Base"** — from `` eyebrow={`${group.title} · Base`} `` (`page.tsx:447`) with `group.title = "Base Components"` (`nav.ts:561`). The word "Base" appears twice. All fourteen base pages do this (`chat`, `dialogs`, `menus`, `sidebar`, `data`, `inputs`, `charts`, `layout`, `forms`, `selects`, `feedback`, `navigation`, `selection`, `buttons`). Separator is **U+00B7**. See §15 drift 1.
2. `type-h1 mt-4` → **"Forms"**.
3. `type-lead mt-4 max-w-2xl` → **"Assembling inputs into something that validates, submits, fails and says so — with the accessible wiring guaranteed rather than remembered."** (em dash U+2014).
4. Chips `ul.mt-7 flex flex-wrap gap-2`, each `type-chip rounded-pill border border-border bg-card px-3 py-1.5 text-muted-foreground`, from `category.contents`. Verbatim, in order:
   **Form · Validation · Field errors · Submit states · Server errors · Composed fields**
   Six chips, and they are exactly the six `DsSection` titles. They are `<li>`, **not links** — no anchor wiring.

The Flutter nav registry already carries all of this byte-for-byte (`example\lib\nav.dart:225–238`).

---

## 2 · Section inventory (verbatim)

Six sections, `PageFootNav` last. `DsSection` shell: `<section id class="mb-20">`; `<h2 class="type-h3">`; description `type-small mt-2 max-w-2xl`.

| # | `id` | title | description (verbatim) |
|---|---|---|---|
| 1 | `form` | **Form** | React Hook Form for state, Zod for the schema, and the Field family for everything you can see. form.tsx contributes no presentation at all — only ids and aria attributes. |
| 2 | `validation` | **Validation** | The schema is the source of truth. Zod owns what valid means; React Hook Form owns when the question gets asked. |
| 3 | `field-errors` | **Field errors** | One rule fails, you get a sentence. Several fail, you get a list — the same component, deciding on its own. |
| 4 | `submit-states` | **Submit states** | Every action needs two signals: the control confirms it heard you, the outcome confirms it worked. |
| 5 | `server-errors` | **Server errors** | The field is valid and the submit still failed. This is the state most forms never draw, and the only one your users will actually hit. |
| 6 | `composed-fields` | **Composed fields** | Select, RadioGroup, Textarea, Switch and Checkbox — none of them an \<input\>, all of them wired the same way. |

*(§6's description contains the literal characters `<input>` — it is a JSX string attribute, so the angle brackets are text.)*

Per-section children, in DOM order:

| § | children |
|---|---|
| 1 | `Panel label="A whole form, live"` → `<AccountForm/>` · `Note mt-6 title="Why there is no FormItem"` · `Meta mt-6` (5 items) |
| 2 | `Panel label="mode: onSubmit · reValidateMode: onChange"` → `<AccountForm/>` (second instance) · `Note mt-6 title="Validate late, re-validate early"` · `Meta mt-6` (4 items) |
| 3 | `Panel label="criteriaMode: all — type a weak password"` → `<PasswordForm/>` · `Note mt-6 title="What the wiring actually guarantees"` · `<div class="mt-6">` → `DoDont` (3 dos, 3 don'ts) |
| 4 | `<SubmitStates/>` = `StateGrid cols={4}` **with no Panel around it** · `Note mt-6 title="Both signals, or neither counts"` |
| 5 | `Panel label="Submit “taken” to fail, anything else to succeed"` → `<ServerErrorForm/>` · `Note mt-6 title="Two places, because they answer two questions"` · `Meta mt-6` (3 items) |
| 6 | `Panel label="Five control shapes, one binding"` → `<ComposedForm/>` · `Note mt-6 title="Why FormControl is a Slot"` |

§4 is the only section with no `Panel`. §3 is the only section with a `DoDont`. §1/§2/§5 are the only sections with a `Meta`. All six carry a `Note` (default `action` tone — `border-action/30 bg-action/[0.08] text-action-ink`, `rounded-lg border p-5`).

Panel label punctuation, exactly: §2 uses **U+00B7** `·`; §3 uses **U+2014** `—`; §5 uses **U+201C/U+201D** curly quotes around `taken`.

---

## 3 · The form wiring contract

### 3.1 · `form.tsx` — what it actually does (`form.tsx:53–224`)

Five exports plus a hook. **Zero styling.**

| part | is | contributes |
|---|---|---|
| `Form` | `FormProvider` verbatim (`:53`) | nothing |
| `FormField` | `Controller` + a `React.useId()` hoisted out of stock's `FormItemContext` (`:70–86`) | one id **per field INSTANCE**, so the two `AccountForm`s on this page cannot collide |
| `FormControl` | radix `Slot.Root` (`:123–137`) | `id={formItemId}` · `aria-invalid={!!error}` · `aria-describedby` |
| `FormLabel` | `FieldLabel` (`:140–154`) | `htmlFor={formItemId}` |
| `FormDescription` | `FieldDescription` (`:157–171`) | `id={formDescriptionId}` |
| `FormError` | `FieldError` (`:187–214`) | `id={formMessageId}` + flattens `error.types` |
| `useFormField()` | hook (`:94–114`) | ids + `fieldState`; **throws** outside a `FormField`; every hook runs *before* the guard so the hook count is stable on the throwing render |

Ids, from one `useId()` value `id`:

```
formItemId        = `${id}-form-item`
formDescriptionId = `${id}-form-item-description`
formMessageId     = `${id}-form-item-message`
```

`aria-describedby` (`form.tsx:130–132`) — **this is the whole contract**:

| field state | `aria-describedby` | `aria-invalid` |
|---|---|---|
| valid | `"{id}-form-item-description"` | `"false"` |
| invalid | `"{id}-form-item-description {id}-form-item-message"` | `"true"` |

`FormError` (`:193–203`) reads `Object.values(error.types ?? {}).flat()`, filters to non-empty strings, and falls back to `[{ message: error.message }]`. Without the `types` spread, `FieldError`'s multi-error `<ul>` branch would be unreachable through this layer — which is the entire point of §3 of the page.

`Slot` merge order matters: the child's own props win, so `<FormControl><RadioGroup/></FormControl>` keeps `data-slot="radio-group"` (not `"form-control"`), which is what makes `FieldSet`'s `has-[>[data-slot=radio-group]]:gap-3` fire *(measured — the rule is emitted at byte 157338 and its selector is `:has(>[data-slot=radio-group])`)*. `id`, `aria-invalid` and `aria-describedby` survive because no control declares them.

### 3.2 · `field.tsx` — geometry and type

| part | classes (verbatim, resolved) | px / spec |
|---|---|---|
| `FieldGroup` | `group/field-group @container/field-group flex w-full flex-col gap-5 …` | column, **gap 20px**, full width. Nested groups → `gap-4` (16px). |
| `Field` (vertical, default) | `group/field flex w-full gap-2 data-[invalid=true]:text-destructive-ink` + `flex-col *:w-full [&>.sr-only]:w-auto` | column, **gap 8px**, and **`width:100%` forced on every direct child** |
| `Field` (horizontal) | `… flex-row items-center *:data-[slot=field-label]:flex-auto has-[>[data-slot=field-content]]:items-start` | row, gap 8px, centred; the label takes `flex: auto` |
| `FieldSet` | `flex flex-col gap-4 has-[>[data-slot=radio-group]]:gap-3` | column; **12px** here (a RadioGroup is a direct child), 16px otherwise |
| `FieldLegend variant="label"` | `mb-1.5 font-medium data-[variant=label]:text-sm` | 13px / **500** / **6px** below |
| `FieldLabel` → `Label` | Label base `flex items-center gap-2 text-sm leading-none font-medium select-none`, then FieldLabel's `flex w-fit gap-2 leading-snug` wins on `leading` | **13px / 1.375 (17.875px) / 500**, `width: fit-content`, 8px gap, `user-select:none` |
| `FieldDescription` | `text-left text-sm leading-normal font-normal text-muted-foreground` + `last:mt-0 nth-last-2:-mt-1` | **13px / 1.5 (19.5px) / 400 / `--muted-foreground`** |
| `FieldError` | `role="alert"` + `text-sm font-normal text-destructive-ink` | **13px / 1.428571 (18.571px) / 400 / `--destructive-ink`** |
| `FieldError` multi | `<ul class="ml-4 flex list-disc flex-col gap-1">` | 16px indent, disc markers, **4px** between items |

**Three different line-heights on three consecutive lines** (17.875 / 19.5 / 18.571). The field family uses Tailwind's `text-sm` ladder (`--text-sm--line-height` = `calc(1.25/0.875)` = 1.428571, never overridden), *not* `.type-small`'s 1.5. Porting these as `DsType.small` would be wrong on two of the three.

**`nth-last-2:-mt-1`** *(measured — emitted at byte 192937 as `margin-top: calc(var(--spacing) * -1)`)*. `FieldError` returns `null` when valid, so the description's position in the child list changes with validity:

| field state | description is | margin-top | input→description gap |
|---|---|---|---|
| valid | last child → `last:mt-0` | 0 | 8px |
| invalid | 2nd-from-last → `nth-last-2:-mt-1` | **−4px** | **4px** |

i.e. **the description tucks 4px closer to the control the moment an error appears.**

**`data-[invalid=true]:text-destructive-ink` on `Field`** *(measured, byte 165985 — `color: var(--destructive-ink)`)*. It sets `color` on the whole subtree. Who actually changes:

| descendant | changes? | why |
|---|---|---|
| `FieldLabel` | **yes → `--destructive-ink`** | Label declares no colour |
| the typed text inside `Input`/`Textarea` | **yes → `--destructive-ink`** | Preflight's `input,textarea { color: inherit }` |
| `FieldDescription` | no | explicit `text-muted-foreground` |
| `FieldError` | no (already) | explicit `text-destructive-ink` |
| placeholder | no | explicit `placeholder:text-muted-foreground` |

`data-invalid` is written by the page as `data-invalid={fieldState.invalid}`, so React emits the literal string `"false"` when valid and the `[data-invalid=true]` selector simply misses.

### 3.3 · `aria-invalid` beats `focus-visible` *(measured)*

Emitted byte offsets in the built stylesheet, equal specificity (0,2,0) throughout — later wins:

| rule | byte |
|---|---|
| `.focus-visible\:border-primary\/50:focus-visible` | 142274 / 142397 |
| `.focus-visible\:ring-3:focus-visible` | 143570 |
| `.focus-visible\:ring-ring\/35:focus-visible` | 144414 / 144532 |
| `.focus-visible\:ring-ring\/50:focus-visible` | 144643 / 144761 |
| `.aria-invalid\:border-destructive[aria-invalid=true]` | **159569** |
| `.aria-invalid\:ring-3[aria-invalid=true]` | **159948** |
| `.aria-invalid\:ring-destructive\/20[aria-invalid=true]` | **160242** (+ `@supports color-mix` at 160332) |

**Consequence:** a focused invalid Input/Textarea/Select/Checkbox/Radio/Switch is pixel-identical to an unfocused invalid one. Focusing an errored field produces **no visible change**. See §15 drift 6.

### 3.4 · Focus-on-error — what React Hook Form actually does

`handleSubmit` runs with RHF's default `shouldFocusError: true`. On a failed submit RHF walks the registered fields **in registration order** and calls `.focus()` on the first one whose stored ref exposes it. A `Controller` only gets a real DOM ref if the call site spreads `{...field}` onto a focusable element.

| form | field | ref attached? | focused on failed submit |
|---|---|---|---|
| Account | `handle` | ✅ `<Input {...field}/>` | ✅ first error wins |
| Account | `email` | ✅ | ✅ |
| Password | `password` | ✅ | ✅ |
| Server | `handle` | ✅ | ✅ (schema errors only) |
| Composed | `plan` | ❌ Select wired by hand (`onValueChange`/`value`) | ❌ silently skipped |
| Composed | `payout` | ❌ RadioGroup wired by hand | ❌ |
| Composed | `bio` | ✅ `<Textarea {...field}/>` | ✅ — but never errors at defaults |
| Composed | `alerts` | ❌ Switch wired by hand | n/a (cannot fail) |
| Composed | `terms` | ❌ Checkbox wired by hand | ❌ |

**So: focus-on-error works in the three `<Input>`/`<Textarea>` forms and is a complete no-op in the composed form**, where all three failing fields are hand-wired. Not stated anywhere in the copy. See §15 drift 7.

`ServerErrorForm`'s manual `form.setError("handle", …)` does **not** focus — `{ shouldFocus: true }` is not passed.

### 3.5 · Translation to Flutter

| web | Flutter |
|---|---|
| `useId()` per `FormField` instance | not needed — Flutter has no id graph. The *reason* it exists (two forms on one page) is satisfied by two independent controller objects. |
| `htmlFor` ↔ `id` | `MergeSemantics` around label + control, or pass the label string into the control's `Semantics(label:)`. `DsInput.label` (`input.dart:92`) already does the latter and renders nothing visible — a visible `DsFieldLabel` must therefore feed it, not duplicate it. |
| `aria-describedby` → description | `Semantics(hint: <description>)` on the control. There is no describedby graph; hint is the only channel that reads after the label. |
| `aria-describedby` → description **+ error** | append the error text to `hint` while invalid (concatenate, description first — that is the DOM order the id list encodes). |
| `aria-invalid` | **`Semantics(validationResult: SemanticsValidationResult.invalid)`** — verified present in the pinned SDK (Flutter 3.44.8; `SemanticsValidationResult { none, valid, invalid }`). Use `.valid` never — the web emits `aria-invalid="false"`, which maps to `.none` in practice, and `.valid` would announce a state the reference does not. |
| `role="alert"` on `FieldError` | **`Semantics(liveRegion: true)`** on the error widget. Same "announce on appearance" contract. |
| `FieldError` renders `null` when valid | **build nothing** — do not build a zero-height `SizedBox` with semantics. The Note in §3 of the page names the empty-live-region anti-pattern explicitly, and `donts[1]` forbids it. |
| `shouldFocusError` | a form-level `List<FocusNode>` in field-declaration order; on failed validate, `.requestFocus()` the first node whose field has an error. Reproduce the reference's *gap* only if the fidelity bar demands it (§16 Q4). |
| `Slot` merging props onto five DOM shapes | a `DsField` that takes a `child` and threads `(invalid, describedBy, focusNode)` down via `InheritedWidget` — the Flutter analogue of a Slot is context, not prop-merging. |

---

## 4 · The four forms — schemas and configuration

`AccountForm` is instantiated **twice** (§1 and §2 Panels) as two independent forms.

| # | component | `page.tsx` | resolver schema | `mode` | `reValidateMode` | `criteriaMode` | defaults |
|---|---|---|---|---|---|---|---|
| 1 | `AccountForm` | :97–159 | `accountSchema` | `"onSubmit"` (explicit) | `"onChange"` (explicit) | default (`firstError`) | `{ handle: "", email: "" }` |
| 2 | `PasswordForm` | :163–206 | `passwordSchema` | **`"onChange"`** | default | **`"all"`** | `{ password: "" }` |
| 3 | `ServerErrorForm` | :210–276 | `serverSchema` | default (`onSubmit`) | default (`onChange`) | default | `{ handle: "taken" }` |
| 4 | `ComposedForm` | :280–408 | `composedSchema` | default | default | default | `{ plan: "", payout: undefined, bio: "", alerts: true, terms: false }` |

Both of `AccountForm`'s explicit modes are the RHF defaults — written out because the §2 Panel label prints them.

### 4.1 · Field inventory, verbatim

| form | name | control | label | placeholder | `autoComplete` | description |
|---|---|---|---|---|---|---|
| Account | `handle` | `Input` | **Handle** | `ayoub` | `username` | This is how you appear on leaderboards. |
| Account | `email` | `Input type="email"` | **Email** | `you@example.com` | `email` | Receipts and nothing else. |
| Password | `password` | `Input type="password"` | **New password** | — | `new-password` | Type a weak one — every unmet rule is listed at once. |
| Server | `handle` | `Input` | **Claim a handle** | — | — | “taken” fails on the server. Anything else succeeds. |
| Composed | `plan` | `Select` | **Plan** | `Choose a plan` (SelectValue) | — | — |
| Composed | `payout` | `RadioGroup` in a `FieldSet` | legend **Payout rhythm** | — | — | — |
| Composed | `bio` | `Textarea rows={3}` | **Bio** | — | — | 160 characters at most. |
| Composed | `alerts` | `Switch` (horizontal Field) | **Price alerts** | — | — | — |
| Composed | `terms` | `Checkbox` (nested horizontal Field) | **I accept the terms** | — | — | — |

`plan`, `payout`, `alerts` carry **no** `FormDescription`. `alerts` carries **no `<FormError/>`** either (its `z.boolean()` cannot fail) — the only field on the page without one.

Select options: `free` → **Free**, `pro` → **Pro**, `vault` → **Vault**.
Radio options: `daily` (`id="payout-daily"`) → **Daily**, `weekly` (`id="payout-weekly"`) → **Weekly**. The RadioGroup is passed `className="gap-3"`, which tw-merges over its own `gap-2` → **12px** row gap.

The `payout` field is the page's one `FieldSet` + `FieldLegend variant="label"`, with a source comment (`page.tsx:322–325`) explaining why: `<label for>` may only point at a labelable element and a RadioGroup container is a `div`, so `FormLabel`'s `htmlFor` would announce nothing.

---

## 5 · Every validation scenario — trigger and message

### 5.1 · Schemas verbatim (`page.tsx:58–93`)

```
accountSchema.handle   .min(3, "At least 3 characters.")
                       .max(20, "No more than 20 characters.")
                       .regex(/^[a-z0-9_]+$/, "Lowercase letters, numbers and underscores only.")
accountSchema.email    z.email("That is not an email address.")

passwordSchema.password.min(10, "At least 10 characters.")
                       .regex(/[A-Z]/, "One capital letter.")
                       .regex(/[0-9]/, "One number.")
                       .regex(/[^A-Za-z0-9]/, "One symbol.")

composedSchema.plan    z.string().min(1, "Pick a plan.")
composedSchema.payout  z.enum(["daily","weekly"], { message: "Pick a payout rhythm." })
composedSchema.bio     z.string().max(160, "160 characters is the ceiling.")
composedSchema.alerts  z.boolean()                                   // no message; cannot fail
composedSchema.terms   z.boolean().refine(v => v, { message: "You have to accept the terms." })

serverSchema.handle    z.string().min(3, "At least 3 characters.")
```

`terms` uses `.refine`, not `z.literal(true)`, and the source says why (`page.tsx:81–85`): a literal types the field as `true`, so the `false` default cannot assign and the schema ends up unable to describe the only state the checkbox starts in.

**Zod 4's `z.email()` regex** (`zod/v4/core/regexes.js:31`) — the port needs this exact predicate for message parity:

```
/^(?!\.)(?!.*\.\.)([A-Za-z0-9_'+\-\.]*)[A-Za-z0-9_+-]@([A-Za-z0-9][A-Za-z0-9\-]*\.)+[A-Za-z]{2,}$/
```

Stricter than HTML5: no leading dot, no `..`, TLD ≥ 2 letters, and `a@b` fails.

### 5.2 · When the question gets asked

| form | first ask | thereafter |
|---|---|---|
| Account (both instances) | **submit** | **every keystroke**, from the first failed submit onward |
| Password | **first keystroke** (`mode: "onChange"`) | every keystroke |
| Server | **submit** | every keystroke after the first failed submit |
| Composed | **submit** | every change after the first failed submit |

Nothing on this page validates on **blur**. There is no `mode: "onBlur"` or `"onTouched"` anywhere.

### 5.3 · Account form — every reachable message

`criteriaMode` is `firstError`, so Zod's issue list is truncated to its **first** entry per path. Zod 4 runs all string checks in declaration order without aborting, so `min` precedes `max` precedes `regex`.

| input | Zod issues raised | rendered message |
|---|---|---|
| `""` | too_small, invalid_format | **At least 3 characters.** |
| `"ab"` | too_small, (regex passes) | **At least 3 characters.** |
| `"AB"` | too_small, invalid_format | **At least 3 characters.** |
| `"Ayoub"` | invalid_format | **Lowercase letters, numbers and underscores only.** |
| `"ayoub!"` | invalid_format | **Lowercase letters, numbers and underscores only.** |
| 21+ chars, lowercase | too_big | **No more than 20 characters.** |
| `"ayoub_9"` | — | valid |
| email `""` / `"a@b"` / `"a b@c.dd"` | invalid_format | **That is not an email address.** |
| email `"you@example.com"` | — | valid |

### 5.4 · Password form — the multi-error list (`criteriaMode: "all"`)

zodResolver calls RHF's `appendErrors` per issue, so `error.types` collects **all four codes**: `too_small` (one message) and `invalid_format` (an array of up to three). `FormError` flattens `Object.values(types).flat()`; `FieldError` dedupes by message and renders a bare string for one, a `<ul>` for two or more.

| typed value | messages, in order |
|---|---|
| `"a"` | At least 10 characters. · One capital letter. · One number. · One symbol. |
| `"abcdefghij"` | One capital letter. · One number. · One symbol. |
| `"Abcdefghij"` | One number. · One symbol. |
| `"Abcdefghi1"` | One symbol. |
| `"Abcdefghi1!"` | *(valid — no error node at all)* |
| `""` after typing then clearing | all four |

The four strings render as `<li>` inside `ml-4 flex list-disc flex-col gap-1`. **This is the only place in the corpus where `FieldError`'s list branch fires.**

### 5.5 · Composed form — submit at defaults

Pressing **Save Preferences** untouched fails three fields at once:

| field | default | result |
|---|---|---|
| `plan` | `""` | **Pick a plan.** |
| `payout` | `undefined` | **Pick a payout rhythm.** (Zod 4 applies `message` to the invalid-type case too) |
| `bio` | `""` | valid (0 ≤ 160) |
| `alerts` | `true` | valid always |
| `terms` | `false` | **You have to accept the terms.** |

`bio` only fails above 160 characters → **160 characters is the ceiling.**

---

## 6 · Submit-state choreography

### 6.1 · `Button`'s `loading` (`button.tsx:98–143`) — the mechanism

```
loading = false      // prop, JSDoc at :111–114
content  = <>{loading && <Spinner />}{children}</>          // :120–127
data-loading = loading || undefined                          // :134
aria-busy    = loading || undefined                          // :135
disabled     = asChild ? undefined : disabled || loading     // :136
```

So `loading` does four things: prepends a spinner, sets `data-loading`, sets `aria-busy`, and **disables** the button — which pulls in the base `disabled:pointer-events-none disabled:opacity-45`.

`Spinner` (`spinner.tsx:5–9`) = `<Icon icon={Loader2Icon} className="size-4 anim-spin" …/>`.
`anim-spin` (`globals.css:2407–2409`) = `animation: pulls-spin 0.9s linear infinite`; `@keyframes pulls-spin { to { transform: rotate(360deg) } }` (`:2451–2453`). Linear on purpose — "a spinner that eases is a spinner that looks like it is struggling."
Rendered glyph: **16×16**, `strokeWidth` computed to **2.4** (`icon.tsx:82`), colour `text-current` (tone `inherit`).

### 6.2 · Per-form choreography

| form | button | rest label | loading label | submit body |
|---|---|---|---|---|
| Account | `variant="default"`, `loading={isSubmitting}` | **Save Account** | **Saving** | `await sleep(900)` → `toast.success(\`Saved as @${handle}\`)` → `form.reset(values)` |
| Password | `variant="outline"`, **no `loading`** | **Set Password** | — | `toast.success("Password accepted")`, synchronous |
| Server | `variant="default"`, `loading={isSubmitting}` | **Claim Handle** | **Claiming** | §7 |
| Composed | `variant="default"`, **no `loading`** | **Save Preferences** | — | `toast.success("Preferences saved")`, synchronous |

**Fields are never disabled during submit.** Only the button is, and only because `loading` implies `disabled`. Nothing on this page sets `disabled` on an Input, Textarea, Select, Switch or Checkbox. The two `Note`s that discuss submit say nothing about locking the form, and the `900ms`/`800ms` waits are the only windows in which it would matter.

`form.reset(values)` after a successful Account save makes the just-saved values the new pristine baseline — `isDirty` returns false, errors clear, and a second submit with unchanged values still runs (there is no dirty guard).

**Button width.** In `FieldGroup` (a `flex flex-col` with no `items-*`, so `align-items` resolves to `stretch`) the Button has `width: auto` and therefore **stretches to the full 448px form width**. The label swap `Save Account → Saving` consequently does not resize it *here* — which makes the JSDoc's "the label stays in place so the button does not change width mid-action" accidentally true in the forms and false in §4's grid, where `StateCell` centres with `items-center` and the buttons are intrinsically sized. Verify the stretch in the browser before building; it is load-bearing for the whole page's look.

### 6.3 · §4 `SubmitStates` — `StateGrid`/`StateCell` anatomy

`StateGrid cols={4}` (`kit.tsx:145`):
`grid gap-px overflow-hidden rounded-lg border border-border bg-border` + `grid-cols-2 sm:grid-cols-4`.
The **1px gaps are the `bg-border` showing through** between opaque cells — there are no cell borders. Radius 12px, clipped.

`StateCell` (`kit.tsx:173`): `bg-background p-5` (20px); stage `mb-4 flex min-h-14 items-center justify-center` (**56px** min, 16px below); label `type-micro text-center text-muted-foreground` (10.5/1/600/upper/0.18em); note `type-caption mt-1.5 text-center text-muted-foreground` (10.5/1.35/500, 6px above).

| cell | label | note | specimen | live? |
|---|---|---|---|---|
| 1 | **Idle** | Nothing pending | `<Button>Save Account</Button>` | static (clickable, no handler) |
| 2 | **Pending** | isSubmitting | `<Button loading>Saving</Button>` | **static, permanently spinning + disabled at 45% opacity** |
| 3 | **Success** | Outcome confirmed | `<Button variant={saved?"secondary":"default"} onClick=…>{saved?"Saved":"Click to save"}</Button>` | **LIVE** — `useState`, one-way |
| 4 | **Disabled** | Nothing has changed | `<Button disabled>Save Account</Button>` | static |

Cell 3's click sets `saved=true` **and** fires `toast.success("Account saved")`. There is no reset — once clicked it reads **Saved** in `secondary` for the rest of the session. That is the only `useState` on the page outside the four `useForm`s.

---

## 7 · Server-error surfaces

`ServerErrorForm.onSubmit` (`page.tsx:224–238`), in order:

1. `form.clearErrors("root.serverError")` — **first, unconditionally.** The Meta says why: "or the last failure outlives the attempt that caused it."
2. `await new Promise(r => setTimeout(r, 800))` — button is in `loading` for exactly 800ms.
3. If `values.handle === "taken"`:
   - `form.setError("root.serverError", { message: "That handle belongs to someone else." })`
   - `form.setError("handle", { message: "Already registered." })`
   - `toast.error("Could not claim that handle")`
   - `return`
4. Else `toast.success(\`Claimed @${values.handle}\`)`.

**The default value is `"taken"`**, so the demo fails on the very first press with no typing.

Two surfaces, deliberately (`page.tsx:601–610`):

| surface | holds | lifetime |
|---|---|---|
| `Alert variant="destructive"` bound to `formState.errors.root?.serverError` | what went wrong with the **submission** | survives keystrokes; cleared only by step 1 of the next submit |
| `FieldError` on `handle` (set manually) | what is wrong with the **field** | **disappears on the next keystroke** — `reValidateMode: "onChange"` re-runs the resolver, `"taken"` passes `min(3)`, and the resolver's clean result replaces the manual error |

That asymmetry is real and unstated: the Alert persists, the field error evaporates. `root` is not part of the schema type, so no resolver run can touch it.

The Alert is the first child of `FieldGroup`, so it is followed by 20px of gap. Its markup:

```
<Alert variant="destructive">
  <Icon icon={XCircle} size="md" tone="inherit" />
  <AlertTitle>Could not save</AlertTitle>
  <AlertDescription>{rootError.message}</AlertDescription>
</Alert>
```

`tone="inherit"` → `text-current`, so the glyph takes the variant's `*:[svg]:text-destructive-ink`. `size="md"` → 16px, strokeWidth 2.4. `aria-hidden="true"` (no `label` passed).

### 7.1 · Alert anatomy (`alert.tsx:24`)

| property | class | value |
|---|---|---|
| layout | `grid` `w-full`, `has-[>svg]:grid-cols-[auto_1fr]` | 2 columns here |
| gaps | `gap-1` / `has-[>svg]:gap-x-3` | **4px** rows, **12px** columns |
| padding | `px-4 py-3.5` | **16 / 14px** (stock shadcn is 10/8 — deliberate, `alert.tsx:20–21`) |
| radius / border / fill | `rounded-lg border border-border bg-card` | 12px, 1px `--border`, `--card` |
| text | `text-sm text-card-foreground text-left` | 13px |
| icon | `*:[svg]:row-span-2`, `translate-y-0.5`, `size-4` | col 1 spanning both rows, **+2px** nudge, 16px |
| `AlertTitle` | `font-medium group-has-[>svg]/alert:col-start-2` | 500, col 2 |
| `AlertDescription` | `text-sm text-balance text-muted-foreground md:text-pretty` | 13px muted, `text-wrap: balance` → `pretty` at ≥768 |
| role | `role="alert"` on the root | no `aria-live`, no `aria-atomic` |

**Every variant shares the same background, border and text colour** (`alert.tsx:9–18`). `destructive` changes exactly three things: `*:[svg]:text-destructive-ink`, `--bloom-1: var(--destructive)`, `--bloom-2: var(--color-action)`.

### 7.2 · The bloom (dependency, not this page's subject)

`bloom-cosmic` (`globals.css:1663–1847`) + a `starfield` span (`alert.tsx:85`, `globals.css:3397–3488`) are on every Alert. Deep dive belongs to a future `feedback-map`; the load-bearing facts for a forms port:

- `overflow: hidden; isolation: isolate; & > * { z-index: 1 }`. No `position` — set one and `AlertAction`'s `absolute` breaks.
- `::before` (deep): `inset:-95% -4.5rem -95% auto; width:min(95%,26rem)`, `mix-blend-mode: screen`, `blur(16px)`, `opacity .75`, `transform-origin: 88% 82%`, `cosmic-drift-deep 18s --ease-in-out infinite alternate`.
- `::after` (near): `inset:-80% -3.5rem -80% auto; width:min(86%,21rem)`, `screen`, `blur(10px)`, `transform-origin: 90% 86%`, `mask-image: radial-gradient(78% 108% at 96% 78%, black 0, black 28%, transparent 84%)`, `cosmic-drift-near 11s --ease-in-out infinite alternate`.
- Hover: `scale: 2.2` / `2.5` over `--duration-bloom` **1000ms** `--ease-out`. Light theme flips `screen` → `multiply`.
- Hue derivation is `oklch(from …)` through `--bloom-l/-c/-lift/-hot-c`: light `.6 / 1.55 / 0 / 1` on `--bloom-void: white`; dark `1 / 1 / .85 / .5` on `black`.

**Two infinite animations per Alert, plus two more on the starfield.** They run whenever the server-error demo has failed.

---

## 8 · Composed fields — five control shapes

All five are wired identically (`FormControl` Slot stamps `id` / `aria-invalid` / `aria-describedby`) and differ only in whether the value arrives through spread or by hand.

| control | value binding | `data-slot` | shadow at rest | shadow when checked/on |
|---|---|---|---|---|
| `Select` | `onValueChange={field.onChange} value={field.value}` on the **Select**, `FormControl` around the **SelectTrigger** | `select-trigger` | `shadow-pressed` | — |
| `RadioGroup` | `onValueChange` / `value` | `radio-group` | `shadow-pressed` | `shadow-btn-primary` |
| `Textarea` | `{...field}` spread | `textarea` | `shadow-pressed` | — |
| `Switch` | `checked` / `onCheckedChange` | `switch` | track `shadow-pressed`, thumb `shadow-btn` | track `shadow-btn-primary` |
| `Checkbox` | `checked` / `onCheckedChange` | `checkbox` | `shadow-pressed` | `shadow-btn-primary` |

### 8.1 · Geometry

| control | size | radius | border | padding | type |
|---|---|---|---|---|---|
| `Input` | h **40** | `pill` 999 | 1px `--input` | `px-4 py-1` (16/4) | 13px |
| `SelectTrigger` (`data-size="default"`) | h **40** | `pill` | 1px `--input` | `pl-4 pr-3.5` (16/14), gap 8 | 13px |
| `Textarea` | `min-h-20` = **80**, `field-sizing: content` | `lg` **12** | 1px `--input` | `px-3.5 py-2.5` (14/10) | 13px / **`leading-relaxed` 1.625** = 21.125px |
| `Checkbox` | **20 × 20** | `sm` **6** | 1px `--input` | — | glyph 14×14 |
| `RadioGroupItem` | **20 × 20** | `full` | 1px `--input` | — | dot **8 × 8**, `shadow-e1` |
| `Switch` (`default`) | track **44 × 24**, thumb **20 × 20** | `pill` / `full` | 1px `--input` | `p-0.5` = 2 | travel **20px** |

`Checkbox`, `RadioGroupItem` and `Switch` each carry `after:absolute after:-inset-x-3 after:-inset-y-2` — an invisible hit-area expander: **44×36** for the two 20px boxes, **68×40** for the switch. RULES §7's 44px floor is met by the pseudo-element, not the paint.

`SelectContent`: `min-w-36` (144), `rounded-lg` (12), `bg-popover`, `shadow-md` (**Tailwind stock**, not a system token) **+** `ring-1 ring-foreground/10`, viewport `p-2` (8). Items: `py-2 pr-9 pl-3` (8 / 36 / 12), `rounded-md` (10), gap 8, 13px; the check indicator is a `size-4` box `right-3` (12px) holding lucide `CheckIcon` at 16px/2.4.

### 8.2 · States, per control

| control | focus-visible | checked/on | disabled | `aria-invalid` |
|---|---|---|---|---|
| `Input` | `border-primary/50` + `ring-3 ring-ring/35` | — | `opacity-45`, `cursor-not-allowed` | `border-destructive` + `ring-3 ring-destructive/20` |
| `Textarea` | `border-primary/50` + `ring-3 ring-ring/35` | — | **`opacity-45`** | same |
| `SelectTrigger` | `border-ring` + `ring-3 ring-ring/50` | `data-placeholder:text-muted-foreground` | `opacity-50` | same (+ dark-only `/50` border, `/40` ring) |
| `Checkbox` | `border-ring` + `ring-3 ring-ring/50` | `border-primary bg-primary text-primary-foreground shadow-btn-primary` (checked **and** indeterminate) | `opacity-50` + `group-has-disabled/field:opacity-50` | same |
| `RadioGroupItem` | `border-ring` + `ring-3 ring-ring/50` | `border-primary bg-primary shadow-btn-primary`; dot is `bg-primary-foreground` | `opacity-50` | same |
| `Switch` | `border-ring` + `ring-3 ring-ring/50` | track `border-primary bg-primary shadow-btn-primary`; unchecked track `bg-muted shadow-pressed` | `data-disabled:opacity-50` | same |

**No control on this page authors a hover state**, except `SelectTrigger`'s `dark:hover:bg-input/50` — dark theme only. The light theme has no hover feedback anywhere in the form.

### 8.3 · Motion

| element | transition / animation | duration | easing |
|---|---|---|---|
| `Input`, `Textarea`, `Switch` track | `transition-[box-shadow,border-color,background-color]` | **250ms** (`--duration-base`) | `--ease-out` cubic-bezier(.22,1,.36,1) |
| `Checkbox`, `RadioGroupItem` | `transition-[background-color,border-color,box-shadow]` | **150ms** (`--duration-fast`) | `--ease-out` |
| `Switch` thumb | `transition-transform` | **250ms** | **`--ease-spring`** cubic-bezier(.34,1.56,.64,1) — the thumb overshoots, the track does not |
| `SelectTrigger` | `transition-colors` (no duration class) | **250ms** via `--default-transition-duration` | `--ease-out` via `--default-transition-timing-function` |
| checkbox tick | `anim-check-draw`: `stroke-dasharray:22; check-draw 280ms both` | 280ms | `--ease-out` |
| checkbox dash | `anim-dash-draw`: `stroke-dasharray:12; dash-draw 200ms both` | 200ms | `--ease-out` |
| radio dot | `anim-dot-pop`: `dot-pop 320ms both` — `scale 0→1.35@55%→1` | 320ms | **`--ease-spring`** |
| Checkbox / Radio / Switch, whole control | **`anim-jelly`** — `yuki-jelly 0.6s both`, replayed by JS on every `data-state` change (`use-replay-on-state-change.ts:18–43`, MutationObserver → remove class → `void offsetWidth` → re-add). **Never fires on mount.** | 600ms | `--ease-out` |
| Button (all) | `btn-spring` + `active:scale-95` | 250ms out / **80ms** in | `--ease-spring` |
| Spinner | `pulls-spin 0.9s linear infinite` | 900ms | **linear** |
| Alert bloom | `cosmic-drift-deep 18s` + `cosmic-drift-near 11s`, both `infinite alternate`; hover `scale` over 1000ms | — | `--ease-in-out` / `--ease-out` |
| Alert starfield | `star-sway 44s` + `star-sway-alt 33s`, `infinite alternate` | — | `--ease-in-out` |
| `SelectContent` | **`animate-none`** — see below | — | — |

`yuki-jelly` keyframes: `0% scale3d(1,1,1) · 30% (1.18,.82,1) · 45% (.88,1.12,1) · 60% (1.06,.94,1) · 78% (.98,1.02,1) · 100% (1,1,1)`.
`dot-pop`: `0% scale(0) opacity 0 · 55% scale(1.35) opacity 1 · 100% scale(1) opacity 1`.

**The Select popover does not animate.** `SelectContent` ships a full `animate-in/fade-in-0/zoom-in-95/slide-in-from-*` set, but also `data-[align-trigger=true]:animate-none`, and `data-align-trigger={position === "item-aligned"}` with `position` defaulting to `"item-aligned"` (`select.tsx:64, 72, 73`). The page passes no `position`. **Port the default: no popover animation.** The `translate-*` nudges (±4px) are also `data-[position=popper]`-only and therefore inert too.

Reduced motion: `globals.css:2534–2542` collapses `animation-duration`/`transition-duration` to `.01ms` and `animation-iteration-count` to `1` on `*, *::before, *::after`. That covers the spinner, the jelly, the bloom and the starfield without any per-component guard.

---

## 9 · Live vs static ledger — the fidelity bar

**This page is almost entirely live.** Only three of its specimens are stills.

| # | § | specimen | live? | what you can trigger |
|---|---|---|---|---|
| 1 | form | `AccountForm` #1 | **LIVE** | type · submit · 900ms spinner · 2 field errors · success toast · reset |
| 2 | validation | `AccountForm` #2 | **LIVE** | identical, independent state and ids |
| 3 | field-errors | `PasswordForm` | **LIVE** | per-keystroke 1–4-item error list · submit toast |
| 4 | submit-states | cell 1 Idle | static | (clickable, no handler) |
| 5 | submit-states | cell 2 Pending | **static, but animating** | spinner never stops; button permanently disabled |
| 6 | submit-states | cell 3 Success | **LIVE** | one-way `useState` → variant + label swap + toast |
| 7 | submit-states | cell 4 Disabled | static | — |
| 8 | server-errors | `ServerErrorForm` | **LIVE** | submit default `"taken"` → 800ms → Alert + field error + error toast; edit the value → success toast |
| 9 | composed-fields | `ComposedForm` | **LIVE** | Select menu · 2 radios · autogrowing textarea · switch · checkbox · 3 errors at once |

Everything else (six `Note`s, three `Meta`s, one `DoDont`) is prose. **There is no static component gallery on this page at all** — unlike every foundations page, where the specimens are stills. A port that renders these as pictures fails the bar outright: the `1:1` contract means the Flutter page must let a reader type a weak password and watch four bullets appear.

Minimum interactive surface the Flutter page must therefore support: text entry (3 single-line + 1 multiline), a popover menu with keyboard nav, radio selection, a switch, a checkbox, four independent form states, async submit with a 900/800ms wait, and a toast host.

---

## 10 · Copy — verbatim, with markup resolved

`{" "}` → one literal space; `&rsquo;` = U+2019; `&ldquo;`/`&rdquo;` = U+201C/U+201D; `&quot;` = `"`; `&lt;`/`&gt;` = `<`/`>`.

### 10.1 · Notes

**§1 — "Why there is no FormItem"** (`Code` chips in backticks, `<em>` italicised):
> Stock shadcn ships a second generation of these primitives — `FormItem`, `FormLabel`, `FormDescription`, `FormMessage` — each carrying its own presentation. This system already has that presentation in `field.tsx`, whose `FieldError` takes React Hook Form’s error shape verbatim. So `FormLabel` here *renders* `FieldLabel` and adds one attribute: `htmlFor`. Two vocabularies for one idea is what RULES §1.1 forbids; a binding layer over one vocabulary is not that.

Inline runs, in order: text · `FormItem` · ", " · `FormLabel` · ", " · `FormDescription` · ", " · `FormMessage` · text · `field.tsx` · ", whose " · `FieldError` · text · `FormLabel` · " here " · *renders* · " " · `FieldLabel` · " and adds one attribute: " · `htmlFor` · text.

**§2 — "Validate late, re-validate early"** (no chips, no emphasis):
> The account form above asks nothing until you submit, then re-checks on every keystroke. Validating on the first keystroke tells someone their email is invalid while they are still typing the third character, which is true and useless. Once they have submitted, they have asked to be told — so from that point the feedback is immediate.

**§3 — "What the wiring actually guarantees"**:
> Every field above ships the three things RULES §7 demands, and none of them were typed at the call site. The control carries `aria-invalid` and an `aria-describedby` that points at the description while valid and at description + error once it is not. The error itself is a `FieldError` with `role="alert"`, and it renders nothing at all when the field is valid rather than leaving an empty live region behind.

**§4 — "Both signals, or neither counts"**:
> `loading` on the Button is the first signal — it swaps in a spinner, sets `aria-busy` and disables the control, so a slow save cannot be double-submitted. The toast is the second. A form with only the spinner leaves you wondering whether it worked; one with only the toast leaves the click feeling dead for as long as the request took.

**§5 — "Two places, because they answer two questions"**:
> `setError("root.serverError")` holds what went wrong with the *submission* and renders as an Alert — a persistent condition worth explaining, which is exactly what RULES §5 reserves Alert for. `setError("handle")` holds what is wrong with the *field*, so the error sits next to the thing you have to change. A form that only does the first makes you hunt; one that only does the second cannot explain a failure that belongs to no field.

**§6 — "Why FormControl is a Slot"**:
> A Slot merges its props onto its child rather than rendering a wrapper, which is what lets one component carry the wiring for five controls that share no DOM shape. Note where it sits on the Select: around the `SelectTrigger`, not the `Select` — the trigger is the focusable thing, so it is the thing that needs the id. Controls that are not `<input>` take `onValueChange` or `onCheckedChange`, so they are wired by hand from `field` rather than spread.

### 10.2 · Meta blocks

`Meta` anatomy (`kit.tsx:202–227`): `<dl class="divide-y divide-border overflow-hidden rounded-lg border border-border bg-card">`; each row `grid gap-1 px-4 py-3 sm:grid-cols-[minmax(0,13rem)_1fr] sm:gap-4` (16/12px padding, key column ≤ **208px**, 16px column gap at ≥640); `<dt class="type-num-sm text-action-ink">` (mono 12/1.2/600/tabular/−0.01em); `<dd class="type-small text-muted-foreground">` (13/1.5/400).

**§1 (5 rows)**

| k | v |
|---|---|
| `Form` | FormProvider. Spread the useForm return into it. |
| `FormField` | Controller, plus a useId() so two forms on one page cannot collide on ids. |
| `FormControl` | A Slot. Stamps id, aria-invalid and aria-describedby onto whatever control it wraps — input, trigger, switch or checkbox alike. |
| `FormLabel / FormDescription / FormError` | FieldLabel / FieldDescription / FieldError, bound to this field. Zero added styling. |
| `useFormField()` | The ids and fieldState, for anything the three above do not cover. Throws outside a FormField. |

**§2 (4 rows)**

| k | v |
|---|---|
| `mode` | `"onSubmit"` — the default, and the right one. |
| `reValidateMode` | `"onChange"` — after the first failed submit only. |
| `resolver` | zodResolver(schema). The schema also types the form: z.infer<typeof schema>. |
| `criteriaMode` | `"all"` collects every failing rule into error.types instead of only the first. |

*(the double quotes inside rows 1, 2 and 4 are straight `"` in the source)*

**§5 (3 rows)**

| k | v |
|---|---|
| `setError("root.serverError")` | Form-level. Never sent to the server, cleared on the next submit. |
| `clearErrors` | Called first on every submit, or the last failure outlives the attempt that caused it. |
| `formState.errors.root` | Where root errors land. Not part of your schema type. |

### 10.3 · DoDont (§3 only)

`grid gap-4 sm:grid-cols-2`. Do panel `border-value/25 bg-value/[0.06] p-5`, heading `type-label mb-3 text-value-ink` "Do", items `flex gap-2.5` = `Icon Check size="sm" tone="value" mt-0.5` + `type-small text-muted-foreground`. Don't panel `border-destructive/25 bg-destructive/[0.06]`, heading `text-destructive-ink` "Don’t" (U+2019), `Icon X size="sm" tone="error"`.

**Dos (3)**
1. Let FormControl stamp the aria wiring — it works on a Select trigger and a Switch, not only an input.
2. Write what to do next: “At least 10 characters.” not “Invalid.”
3. Keep FormDescription present while the field is valid; it is the only guidance there.

**Don'ts (3)**
1. Hand-type id / htmlFor / aria-describedby. It satisfies the rule exactly as often as someone remembers.
2. Render an error container that is always mounted and merely empty — a screen reader announces the region.
3. Paint error text with text-destructive. Only -ink carries text, and it is a different red per theme.

Don't 3 carries a five-line `// allow-hardcoded:` block above it (`page.tsx:564–568`) explaining that the line *names* the anti-pattern in order to forbid it, and that `state-colour-as-text` cannot tell a page teaching a rule from a page breaking it. Curly quotes only in do 2; apostrophes elsewhere are straight.

---

## 11 · Toasts

Six calls fire from this page (seven sites — `AccountForm` renders twice). Root layout mounts `<Toaster position="bottom-right" />` (`app\layout.tsx:39`).

| # | site | type | text |
|---|---|---|---|
| 1 | `AccountForm.onSubmit` ×2 | success | `` `Saved as @${values.handle}` `` |
| 2 | `PasswordForm` submit | success | Password accepted |
| 3 | `ServerErrorForm` failure | error | Could not claim that handle |
| 4 | `ServerErrorForm` success | success | `` `Claimed @${values.handle}` `` |
| 5 | `ComposedForm` submit | success | Preferences saved |
| 6 | `SubmitStates` cell 3 | success | Account saved |

All are title-only (no description, no action). `.cn-toast` (`globals.css:2584–2604`): `flex items-start`, gap **12px**, width **22.25rem = 356px**, padding **16px**, 1px `--border`, `rounded-lg` **12px**, `bg-popover`, `box-shadow: --shadow-e3`, `--text-small` 13px / 1.5, `overflow: hidden`. Icon slot `margin-top: 2px`, 16px glyph. Title 13px/500/`--foreground`. Description 13px/`--muted-foreground`. `bloom-cosmic` carried by `classNames.toast` (`sonner.tsx:55`).

Glyph colour is the only colour a toast carries, and it is always an `-ink` token (`globals.css:2756–2770`): success → `--success-ink`, error → `--destructive-ink`, warning → `--warning-ink`, info → `--info-ink`, loading → `--action-ink`.
Icons (`sonner.tsx:18–24`): success `CircleCheckIcon`, info `InfoIcon`, warning `TriangleAlertIcon`, error `OctagonXIcon`, loading `Loader2Icon` — all at `size-4`.

A full toast port belongs to `feedback-map`; this page needs **success** and **error** only.

---

## 12 · Foot nav

`PageFootNav groupId="base" slug="forms"` → `<nav class="mt-8 flex items-stretch gap-4 border-t border-border pt-8">`.

- **Previous** → **"Inputs"**, `/design-system/components/base/inputs`
- **Next** → **"Selects & Pickers"**, `/design-system/components/base/selects`

Link anatomy and `press` are unchanged from `shadows-map.md` §9. `siblings('base','forms')` in `example\lib\nav.dart:747` already resolves both.

---

## 13 · Token reference — what this page adds

Only the tokens not already tabulated in `shadows-map.md` §11 / `colors-map.md`.

| token | dark | light |
|---|---|---|
| `--destructive` | `hsl(0 72.2% 50.6%)` = `#DC2626` | same |
| `--destructive-ink` | `#F87171` (`--color-destructive-lifted`) | `hsl(0 72.2% 46%)` = `#CA2121` (`--color-destructive-deep`) |
| `--success-ink` | `#10B981` | `#047857` |
| `--warning-ink` | `#FBBF24` | `#B45309` |
| `--info-ink` | `#22D3EE` | `#0E7490` |
| `--popover` | `hsl(240 5.9% 10%)` = `#18181B` | `#FFFFFF` |
| `--popover-foreground` | `#FAFAFA` | `hsl(240 10% 3.9%)` = `#09090B` |
| `--card-foreground` | `#FAFAFA` | `#09090B` |
| `--accent-foreground` | `#FAFAFA` | `#18181B` |

Durations/easings: `--duration-tick` 80 · `--duration-fast` **150** · `--duration-base` 250 · `--duration-slow` 400 · `--duration-bloom` **1000**; `--ease-out` cubic-bezier(.22,1,.36,1) · `--ease-spring` cubic-bezier(.34,1.56,.64,1) · `--ease-in-out` cubic-bezier(.65,0,.35,1). `--default-transition-duration` **250ms** and `--default-transition-timing-function` `--ease-out` (`globals.css:395–396`) — a bare `transition-colors` on the Select trigger inherits both.

Radii used: `sm` 6 (Checkbox), `md` 10 (SelectItem), `lg` 12 (Textarea, Alert, StateGrid, Meta, SelectContent, Note), `pill` 999 (Input, SelectTrigger, Switch, Button), `full` (Radio, thumb).

Type classes: `type-h1`, `type-h3`, `type-lead`, `type-small`, `type-chip`, `type-label`, `type-code`, `type-num-sm`, **`type-micro`** (10.5/1/600/upper/0.18em — StateCell label), **`type-caption`** (10.5/1.35/500 — StateCell note). Plus the raw `text-sm` ladder used by the field family (§3.2) — 13px at lh **1.428571**, which no `type-*` class expresses.

---

## 14 · Exists in the port / missing

Package root `D:\DESIGN\Design-System-2026-8\flutter-design-system\`.

### 14.1 · Already built — reuse

| need | where |
|---|---|
| `DsButton` — 7 variants (`primary premium secondary outline ghost destructive link`), 4 sizes (`sm md icon iconSm`), keyboard, disabled@0.45 + `IgnorePointer` | `lib\src\components\button.dart:38`, `:90`, `:170`, `:562` |
| `DsButton.md` = **40px**, level with `DsInput.height` | `button.dart:201`, `input.dart:95` |
| **Focus-ring helper** `DsButton.withFocusRing(DsShadowSpec, Color)` | `button.dart:241` |
| `DsInput` — pill, `--input` border, `--card` fill, permanent `DsShadows.pressed`, focus border `primary@50%` + ring `ring@35%`, 250ms `DsCurves.out`, own/inherited controller + focus node | `lib\src\components\input.dart:62–272` |
| `DsShadows.pressed / btn / btnPrimary / e1 / e3` | `lib\src\foundation\shadows.dart:197 / 204 / 214 / 159 / 171` |
| `DsMachineSurface` (inset painting, CSS paint order) | `lib\src\effects\machine_surface.dart:26` |
| `DsThemeData` — `input`, `ring`, `destructive`, `destructiveInk`, `popover`, `muted`, `accent` … (~102 fields) | `lib\src\foundation\theme.dart:30` |
| `DsDurations` / `DsCurves` / `DsTransforms` | `lib\src\foundation\motion.dart:14 / 206 / 173` |
| `DsRadii` (`sm md lg pill` + `xl4`), `DsWidths.hairline`, `ds()` | `lib\src\foundation\spacing.dart:78 / 20` |
| `DsType.*` 28 specs incl. `label`, `small`, `caption`, `micro`, `numSm`, `chip`, `code` | `lib\src\foundation\typography.dart:277–544` |
| `DsComponentType.buttonLabel` / `.sheetBody` (13/400, what `DsInput` types with) | `typography.dart:239 / 247` |
| Kit: `DsPageHeader :54` · `DsSection :148` · `DsPanel :242` · `DsCode :448` · `DsDoDont :735` · `DsNote :834` (+`DsNoteTone`) · `DsMeta :390` · `DsGrid :908` · `DsPageFootNav :1156` | `example\lib\kit.dart` |
| Nav entry for `forms` — slug/title/blurb/6 contents, verbatim; siblings resolve | `example\lib\nav.dart:225–238`, `:747` |
| `DsIconGlyph`: `check`, `x`, `chevronDown`, `chevronUp`, `arrowLeft`, `arrowRight`, `eye`, `eyeOff`, `info`, `alertTriangle` | `lib\src\components\icon_paths.dart:67–151` |
| `Semantics(validationResult:)` + `liveRegion:` | Flutter **3.44.8** — verified in the pinned SDK |

### 14.2 · Missing — must be built

| # | missing | notes |
|---|---|---|
| 1 | **`DsButton.loading`** | **Confirmed absent.** No `loading` / `busy` / `pending` anywhere in `lib\`. The plan's Task A scoped variants only, so this is a genuine gap, and it is load-bearing: two of four forms and one of four state cells depend on it. Needs: prepend spinner, force-disable, and `Semantics` busy. |
| 2 | **A spinner** | Nothing in the package. Nearest are `DsShimmer` (`lib\src\motion\keyframes.dart:868`) and `DsPulseLive` (`:940`) — neither rotates. Needs `pulls-spin`: 360° over **900ms**, **linear**, infinite, 16px, stroke 2.4. |
| 3 | **`loaderCircle` / `xCircle` glyphs** | `DsIconGlyph` has neither. `xCircle` is required by the server-error Alert; `loaderCircle` (lucide `Loader2`) by the spinner. Both are off-set additions like `rotateCcw` (`icon_paths.dart:148–150`) and must stay out of the icons page registry. |
| 4 | **`DsInput.invalid`** | `DsInput` has **no** invalid state, no destructive border, no destructive ring, no validation semantics. Add `invalid` → border `theme.destructive`, ring `destructive@20%`, `SemanticsValidationResult.invalid`, and make it **outrank focus** (§3.3). |
| 5 | **A field / form layer** | Nothing. Needs `DsFieldGroup` (column, 20px), `DsField` (vertical 8px / horizontal), `DsFieldSet` + `DsFieldLegend`, `DsFieldLabel`, `DsFieldDescription` (with the `nth-last-2` −4px rule), **`DsFieldError`** (`liveRegion`, null when empty, string vs bulleted list), and the `data-invalid` colour cascade onto label + typed text. |
| 6 | **A form controller** | No `Form`/`FormField`/validation anywhere in `lib\`. Needs value store, per-field error map, `mode`/`reValidateMode`/`criteriaMode` equivalents, a `root.serverError` slot outside the schema, `clearErrors`, `setError`, `reset(values)`, `isSubmitting`, and focus-on-error over an ordered `FocusNode` list. |
| 7 | **A schema/validator layer** | Zod has no Flutter analogue. Needs an ordered rule list per field that returns **all** issues (so `criteriaMode: "all"` is expressible) plus a first-issue mode, and the Zod-4 email regex from §5.1 verbatim. |
| 8 | **`DsTextarea`** | Nothing multiline. `DsInput` hard-pins `SizedBox(height: DsInput.height)` (`input.dart:249`) and `EditableText` defaults to one line. Needs `min-h-20` 80px floor, autogrow (`field-sizing: content`), `rounded-lg`, `px-3.5 py-2.5`, **lh 1.625**. |
| 9 | **`DsCheckbox`** | 20px, `rounded-sm`, `shadow-pressed` → `shadow-btn-primary`, hand-authored tick path `M5 12.5 10 17.5 19 7` at 14px stroke 3.2 (not lucide), indeterminate `M6 12h12`, `check-draw`/`dash-draw`/`jelly`, 44×36 hit area. |
| 10 | **`DsRadioGroup` / `DsRadioGroupItem`** | 20px circle, 8px dot at `shadow-e1`, `dot-pop` 320ms spring, `jelly`, 44×36 hit area, group gap. |
| 11 | **`DsSwitch`** | 44×24 track / 20px thumb / 20px travel; track `shadow-pressed` ↔ `shadow-btn-primary`, thumb always `shadow-btn`; thumb on **spring**, track on **out**; `jelly`; 68×40 hit area. |
| 12 | **`DsSelect`** | Trigger (40px pill, `shadow-pressed`, chevron 16/2.4) + portal content (`min-w-36`, `rounded-lg`, `shadow-md` **stock Tailwind, no token**, `ring-1 foreground/10`, `p-2`) + items + check indicator + keyboard nav. **No open/close animation** (§8.3). |
| 13 | **`DsAlert`** | 5 variants, 2-col grid, 16/14 padding, 12px radius, `role="alert"`. Plus `bloom-cosmic` (4 infinite animations, `screen`/`multiply` theme split, `oklch(from …)` relative colour) and `starfield`. **The single biggest new effect on this page.** |
| 14 | **A toast host** | `DsToaster` bottom-right, 356px, `--shadow-e3`, `-ink` glyph, `bloom-cosmic`. Only `success` and `error` needed here. |
| 15 | **`StateGrid` / `StateCell`** | Absent repo-wide. Closest is the private `_SpecimenCell` (`example\lib\pages\shadows.dart:802`). Lift into `kit.dart` as `DsStateGrid(cols:)` / `DsStateCell(label:, note:)` — `gap-px` over a `--border` fill, `min-h-14` stage, `micro` label + `caption` note. |
| 16 | **`example\lib\pages\forms.dart`** + a `switch` arm | `main.dart:100–108` routes only 4 pages; `forms` falls to `PlaceholderPage`. **Note `shadows.dart`, `motion.dart`, `icons.dart` are also unrouted** — `main.dart` is unmodified in git. |
| 17 | **`_referenceHeight` for the forms route** | `example\test\vertical_parity_probe_test.dart:45–50` has only overview/colors/typography/spacing. Must be measured off the live dev server at 1440×900. **Complicated here:** the page's height changes with form state (errors add rows), so the reference must be captured in a defined state — see §16 Q3. |
| 18 | Wrap-parity + page tests | `example\test\wrap_parity_probe_test.dart`; page test modelled on `example\test\spacing_page_test.dart`. |

### 14.3 · Guard-test constraints

`test\token_guard_test.dart:40–53` forbids, outside `lib\src\foundation\`: `Color(0x`, `Color.from`, `fontSize:<digit>`, `letterSpacing:<digit>`, `FontWeight.w<digit>`, `\bCurves.`, `Duration((milli|micro)seconds:<digit>`, `BorderRadius.circular(<digit>`, `BoxShadow(`. Bare `0`/`0.0` is legal for the marked rules; escape hatch is `allow-hardcoded: <reason>` **anywhere on the line** (plain substring test at `:86`). Roots scanned: `lib`, `example/lib`. It is a **raw text scan including comments**.

Consequences here:
- The seven new animation timings (**150, 200, 280, 320, 600, 900, 1000 ms**) have no `--duration-*` token except 150 (`fast`), 250 (`base`) and 1000 (`bloom`). 200/280/320/600/900 need either new `DsDurations` members or escape hatches — same question as `shadows-map.md` Q3, now five entries larger.
- Checkbox `strokeWidth 3.2`, the tick path `M5 12.5 10 17.5 19 7`, `stroke-dasharray 22`/`12`, the jelly scale triples and `dot-pop`'s 1.35 are all literals. Put the glyph in `icon_paths.dart` (it is geometry, and that file already holds transcribed paths) and the scalars in `foundation\motion.dart` beside `DsTransforms`.
- The Zod email regex is a string literal — no rule matches it, but it belongs beside the validator, not in a page.
- Doc comments quoting `Duration(milliseconds: 900)` will trip the scanner. Write timings in prose.

---

## 15 · Drift register (record, do not fix)

1. **The eyebrow says "Base" twice.** `` `${group.title} · Base` `` with `group.title = "Base Components"` → **"Base Components · Base"**. All fourteen base pages. Foundations pages print a single clean word ("Foundations"). Render it as written.
2. **`Button`'s `loading` JSDoc contradicts every call site.** "*The label stays in place so the button does not change width mid-action*" (`button.tsx:112–114`) — yet `AccountForm` swaps **Save Account → Saving** and `ServerErrorForm` swaps **Claim Handle → Claiming**. In the forms the width happens to be pinned by flex `stretch` anyway; in §4's `StateCell` the buttons are intrinsically sized and Idle vs Pending are visibly different widths.
3. **`Spinner`'s accessibility attributes are silently dropped.** `spinner.tsx:7` passes `role="status"` and `aria-label="Loading"` into `<Icon>`, but `Icon` (`icon.tsx:68–74`) destructures only `icon/size/tone/label/className` and **spreads nothing**. With no `label`, `Icon` emits `aria-hidden="true"`. So the spinner is hidden from assistive tech and the only announcement a loading button makes is `aria-busy`. `data-slot="spinner"` never reaches the DOM either.
4. **§2's Note argues against `mode: "onChange"`; §3's form uses it.** "*Validating on the first keystroke tells someone their email is invalid while they are still typing the third character, which is true and useless*" — and `PasswordForm` two sections later is `mode: "onChange"`. Defensible (a rule checklist is not a verdict) but unremarked.
5. **The §2 Panel label advertises `reValidateMode: onChange`, which is also the default.** Both of `AccountForm`'s modes are RHF defaults written out longhand. The §2 Meta calls `mode: "onSubmit"` "the default, and the right one" while the label presents both as configuration.
6. **`aria-invalid` erases focus.** *(measured, §3.3)* On an invalid Input/Textarea/Select/Checkbox/Radio/Switch, focusing produces **no visible change** — the destructive border and ring already own both properties. RULES §7 opens with "Focus always visible, never removed." This is the one place the system contradicts it.
7. **Focus-on-error is a no-op in the composed form.** *(§3.4)* All three fields that can fail at defaults (`plan`, `payout`, `terms`) are hand-wired, so `shouldFocusError` finds no ref with a `focus` method and nothing is focused. The Notes claim the wiring is a guarantee; this part of it is not.
8. **`ServerErrorForm`'s two error surfaces have different lifetimes and the copy does not say so.** The Alert survives keystrokes until the next submit; the field error is wiped by the first keystroke, because the resolver revalidates and `"taken"` passes `min(3)`.
9. **`<Textarea rows={3}/>` is inert.** `field-sizing: content` replaces `rows`-based default sizing; the visible floor is `min-h-20` = **80px**, which is roughly 3 lines by coincidence (20px padding + 3 × 21.125px = 83.4px).
10. **`SelectContent` ships a dead animation set.** Six animation utilities plus four `translate-*` nudges are cancelled by `data-[align-trigger=true]:animate-none` because `position` defaults to `"item-aligned"`. Port the *rendered* behaviour: no animation.
11. **`SelectTrigger`'s `w-fit` never applies.** *(measured — `.w-fit` at byte 39230, `*:w-full > *` at byte 106378)* The vertical `Field`'s `*:w-full` is emitted later at equal specificity and wins, so the trigger renders at the full **448px** field width, not fit-content.
12. **Three line-heights on three consecutive lines.** Label 1.375, description 1.5, error 1.428571 (§3.2). None of them is `.type-small`'s 1.5-at-13px used everywhere else in the docs kit.
13. **Textarea deviates from its siblings on three axes.** `border-primary/50` (not `border-ring`), `ring-ring/35` (not `/50`), `opacity-45` (not `-50`) — it follows `Input`, while the other four follow the shadcn default.
14. **`Switch` disables on `data-disabled:`; `Checkbox`/`Radio`/`Select` on `disabled:`.** Same intent, two selector families.
15. **`Checkbox` carries `group-has-disabled/field:opacity-50`; `RadioGroupItem` does not.** A disabled `Field` dims the checkbox and not the radio.
16. **`SelectContent` uses Tailwind's stock `shadow-md`.** The only elevation on this page not drawn from the `--shadow-*` token set — `0 4px 6px -1px rgb(0 0 0/.1), 0 2px 4px -2px rgb(0 0 0/.1)`, fixed black, no theme response.
17. **`Select` is the only control with `dark:` variants** — four of them on the trigger (`dark:bg-input/30`, `dark:hover:bg-input/50`, `dark:aria-invalid:border-destructive/50`, `dark:aria-invalid:ring-destructive/40`). Its dark rest fill is therefore `--input @ 30%`, not `--card`, unlike every other field on the page.
18. **No hover state anywhere on a light theme.** The five form controls author no hover at all; the Select's only hover is dark-only.
19. **`AccountForm` appears twice with identical Panel content.** §1 and §2 render the same component; the sections differ only in prose and Panel label.
20. **`alerts` is the one field with no `FormError`** and `plan`/`payout`/`alerts` are the three with no `FormDescription`. The §3 do — "Keep FormDescription present while the field is valid; it is the only guidance there" — is not followed by three of the page's own nine fields.

---

## 16 · Open questions for the supervisor

1. **Scope of the greenfield build.** This page needs a form controller, a validator, a field layer, and **six** new components (Textarea, Checkbox, Radio, Switch, Select, Alert) plus a spinner and a toast host. That is more new surface than the last three foundations pages combined, and Select/Alert/Toast are each properly the subject of a later page (`selects`, `feedback`). **Recommendation:** build the form/field/validator layer and `DsButton.loading` + spinner **fully**, since they are this page's actual subject; build Textarea/Checkbox/Radio/Switch to full parity (they are simple and `inputs`/`selection` will need them anyway); and build `DsSelect` and `DsAlert` to the fidelity this page renders — a working menu and a static-bloom Alert — leaving the bloom's four infinite animations and the full Select variant matrix to `feedback` and `selects`. Confirm before I plan.
2. **`DsButton.loading` — build now?** It is missing, Task A did not mandate it, and two forms plus a state cell are unbuildable without it. **Recommendation: yes, now**, with the spinner, since it is a Button API change and doing it later means touching `button.dart` twice.
3. **`_referenceHeight` for a stateful page.** The vertical parity probe asserts a single height, but this page's height changes as errors appear (a 4-item password list adds ~90px). **Recommendation:** measure the **pristine** state (nothing typed, nothing submitted) and have the Flutter page test pump the same pristine state. Flag if you would rather the probe skip this route entirely.
4. **Reproduce the focus-on-error gap?** The reference silently fails to focus the composed form's failing fields (§3.4, drift 7). The fidelity bar says drift included — but this drift is an accessibility regression, not a visual one, and it is invisible in a screenshot. **Recommendation:** implement focus-on-error correctly for *all* fields in Flutter and record the divergence here, rather than porting a bug that nothing can see. Needs your call.
5. **`aria-invalid` beating focus (drift 6).** Same shape: a measured, deliberate-looking cascade outcome that removes the focus ring from errored fields. **Recommendation:** reproduce exactly — it *is* visible, it is what the page renders, and RULES violations are the reference's to own.
6. **Where do the new timings live?** 200 / 280 / 320 / 600 / 900 ms have no CSS token. **Recommendation:** add `DsDurations.dashDraw / checkDraw / dotPop / jelly / spin` in `foundation\motion.dart`, consistent with whatever was decided for `shadows-map` Q3 — one policy, not two.
7. **The validator's shape.** Zod is a schema library; Flutter has none in-repo and the port takes no dependencies. **Recommendation:** a tiny `DsRule<T>` list per field (`(value) => String?`) with an "all issues" and a "first issue" collection mode — enough to express both `criteriaMode`s and nothing more. The Zod-4 email regex ships verbatim as one rule.
8. **Toast host placement.** The web mounts `<Toaster/>` once in the root layout. In Flutter this is an `Overlay` entry owned by the example app's shell, not by `lib\`. **Recommendation:** put `DsToaster`'s widget in `lib\` and its mounting in `example\lib\shell.dart`, mirroring the split.
9. **Two `AccountForm`s (drift 19).** Confirm both instances are built as separate live forms rather than the second being a still — the §2 Note's whole argument ("asks nothing until you submit, then re-checks on every keystroke") is only demonstrable if it is live.


---

## CORRECTION - 2026-08-15 - §8.3 durations

*(Raised by `selection-map.md` §7.1, verified by a full-corpus sweep plus a
computed-style probe against `localhost:3000` at 1440 x 900 on 2026-08-15.)*

**Tailwind v4 has no `--duration-*` theme namespace.** The tokens are declared in
`globals.css` and are read correctly by hand-written `@utility` blocks
(`btn-spring`, `lift`, `press`, `click-spring`, `slide-pill`, `swap-roll`), by
the `anim-*` keyframe rules, by the `[class*="animate-in"]` bridge and by plain
component rules such as `:where(.prose) a` - but they generate **no `duration-*`
utility class**. The only `.duration-*` selectors in the built stylesheet are
`.duration-200` and `.duration-400`, and nothing in the reference uses either.

So a `duration-fast` or `duration-base` in a `className` **emits no CSS**.
`--tw-duration` is never set, and every `transition-*` utility falls through
`var(--tw-duration, var(--default-transition-duration))` to
**`--default-transition-duration: 250ms`** (`globals.css:395`).

§8.3's table is therefore wrong in one row, and right for the wrong reason in
three more:

| §8.3 row | table says | **actually renders** *(probed)* |
|---|---|---|
| `Checkbox`, `RadioGroupItem` | **150ms** (`--duration-fast`) | **250ms** - `--default-transition-duration` |
| `Input`, `Textarea`, `Switch` track | 250ms (`--duration-base`) | 250ms - but from the **default**, not the token |
| `Switch` thumb | 250ms | 250ms - same, from the default |
| `SelectTrigger` | 250ms via `--default-transition-duration` | correct as written - the one row that reasoned about the cascade rather than the class list |

Everything below the transition rows in §8.3 (`anim-check-draw` 280,
`anim-dash-draw` 200, `anim-dot-pop` 320, `anim-jelly` 600) is **unaffected**:
those are `@utility` blocks with their own durations, never utility classes.

Probe record, `getComputedStyle(el).transitionDuration`, dark theme, 1440 x 900,
2026-08-15: `[data-slot=checkbox]` 0.25s, `[data-slot=radio-group-item]` 0.25s,
`[data-slot=switch]` 0.25s, `[data-slot=switch-thumb]` 0.25s,
`[data-slot=slider-thumb]` 0.25s, `[data-slot=input]` 0.25s,
`[data-slot=textarea]` 0.25s, `[data-slot=input-group]` 0.25s. Control group,
same session, same pages: `:where(.prose) a` **0.15s** and `slide-pill`'s opacity
leg **0.15s** - both read `var(--duration-fast)` directly, which is what makes
the mechanism (rather than the number) the finding.

**Port impact, landed 2026-08-15.** `lib\src\components\checkbox.dart` and
`lib\src\components\radio.dart` ran their socket transition at
`DsDurations.fast` (150ms) where the browser runs 250ms. Both now use
`DsDurations.transitionDefault`, a new member of
`lib\src\foundation\motion.dart` that spells `--default-transition-duration`
separately from `--duration-base` so a retune of the token cannot silently move
the utilities. The three `pump(DsDurations.fast)` calls in
`test\selection_feedback_test.dart` were retuned with it.

**Also note §14's summary line** ("The seven new animation timings ... 150
(`fast`)"): 150ms is a real token, but no *transition* on the forms page runs at
it.
