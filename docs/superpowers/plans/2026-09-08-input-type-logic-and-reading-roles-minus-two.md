# Input Type Logic Everywhere and Reading Roles Minus Two

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking. Workers run on **Sonnet** only.

**Goal:** Every field, menu and picker component reads like `Input` does (primary text at `body`, secondary furniture at `small`), and the six reading roles are 2px smaller at every breakpoint.

**Architecture:** The rule is a two-role contract: `TextStyles.body` for the text a reader acts on (field text, row labels, trigger labels, option labels), `TextStyles.small` for what explains it (labels, descriptions, hints, errors, group headings, subtitles, shortcuts, placeholders that are not the field text). `Input.textSpecDefault` (= `TextStyles.body`) is the shared token every primary site reads so nothing can drift. The role sizes live only in `lib/src/design_system/foundation/typography.dart`.

**Tech Stack:** Flutter, `flutter_test`, existing `TextStyles` roles, `StyledText.stepOf` for token-relative tests.

## Global Constraints

- No numeric visual literals in `lib/` outside `lib/src/design_system/foundation/` (`test/token_guard_test.dart`). Use `TextStyles.*`, `space()`, `Radii`, `TouchTargets`.
- Tests derive expectations from tokens (`StyledText.stepOf(context, role)`, `role.stepFor(width)`, `space(n)`), never pasted pixel values. Never delete or loosen a test.
- Primary text = `Input.textSpecDefault` (read it, do not restate `TextStyles.body` at the site). Secondary = `TextStyles.small`. `TextStyles.nav` is for buttons and top navigation only; it must not appear in the components this plan lists.
- Row heights that derive from a role derive from the role the row renders (`Menu.itemHeightOf`, `Command.itemHeightOf`, `Combobox.itemHeightOf`, `Select.labelHeightOf` pattern).
- `flutter analyze` clean. `dart run tool/registry_builder/bin/reseal.dart --apply`, `build.dart .`, `validate.dart` after lib changes (manifest hashes).
- Commit trailer: `Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>`.

## New role table (size/leading)

| Role | phone | tablet | desktop |
|---|---|---|---|
| body | 14/20 | 15/22 | 16/24 |
| small | 12/16 | 13/18 | 14/20 |
| nav | 12/16 | 13/18 | 14/18 |
| badge | 10/14 | 11/14 | 12/16 |
| code | 12/18 | 13/18 | 14/20 |
| identifier | 13/18 | 14/20 | 15/22 |

Unchanged: display, h1–h4, lead, numberSm, numberBase, numberMd, numberLg, numberXl.

## Component role map (what each site must use)

| Component | body (primary) | small (secondary) |
|---|---|---|
| Input, Textarea, InputOtp | field text, placeholder | hint/description via Field |
| InputGroup | field text, addon text (`InputGroupText`), addon button label | addon captions |
| Field / Form | control text (inherited) | FieldLabel, FieldDescription, FieldError, FieldSet legend |
| Select, NativeSelect | trigger value/placeholder, option label | group label, option description |
| Combobox | field text, item label | item description, empty text |
| Command | search input, item label | group heading, item hint, shortcut, empty text |
| Menu (Dropdown, Context, Menubar rows) | item label, sub-trigger label | group label, subtitle, shortcut |
| Menubar top triggers | trigger label | — |
| NavigationMenu | trigger label, link title | link description |
| SelectionControl (Checkbox, Radio, Switch) | control label text | description |

---

### Task 1: Tokens minus two

**Files:**
- Modify: `lib/src/design_system/foundation/typography.dart` (roles body, small, nav, badge, code, identifier)
- Modify: `test/foundation_type_motion_test.dart` (the `_Role` table rows for the six roles)
- Modify: `example/lib/docs_pages/typeset_page.dart` (the role table copy) and `example/test/typeset_docs_test.dart` if it pins sizes

- [ ] **Step 1: Update the test table first.** In `test/foundation_type_motion_test.dart` set the six `_Role` rows to `m/t/d` = body (14,20)/(15,22)/(16,24); small (12,16)/(13,18)/(14,20); nav (12,16)/(13,18)/(14,18); badge (10,14)/(11,14)/(12,16); code (12,18)/(13,18)/(14,20); identifier (13,18)/(14,20)/(15,22).
- [ ] **Step 2: Run** `flutter test test/foundation_type_motion_test.dart` → the six "every role, field by field" cases fail.
- [ ] **Step 3: Edit typography.dart** so each role's `mobile`/`tablet`/`desktop` `TypeStep` matches the table. Keep weights and tracking.
- [ ] **Step 4: Run** the same test → green. Update the typeset docs table copy to the new numbers; run `flutter test test/typeset_docs_test.dart` from `example/`.
- [ ] **Step 5:** `flutter test test/token_guard_test.dart`, `flutter analyze`. Do not commit; the controller commits after Task 6.

### Task 2: Menu family reads like Input

**Files:**
- Modify: `lib/src/components/ui/menu.dart` (row label at `TextStyles.nav` → `Input.textSpecDefault`; row-height getters `itemHeight`/`itemHeightOf` derive from `Input.textSpecDefault`; keep subtitle, group label, shortcut at `small`)
- Modify: `lib/src/components/ui/menubar.dart` (top trigger `TextStyles.nav` → `Input.textSpecDefault`)
- Verify only: `lib/src/components/ui/dropdown_menu.dart`, `lib/src/components/ui/context_menu.dart` (they compose menu rows; no local roles)
- Test: `test/menus_test.dart`, `test/overlay_menu_family_test.dart`, `test/disabled_state_test.dart`, `example/test/components_docs/{menu,dropdown_menu,context_menu,menubar}_test.dart`

- [ ] **Step 1:** In `test/menus_test.dart` add a test "a menu row reads at the field role": pump a `DropdownMenu` with one `MenuItem`, open it, find the row's `StyledText` and `expect(identical(text.spec, Input.textSpecDefault), isTrue)`; and one for a `Menubar` trigger.
- [ ] **Step 2:** Run → fails (spec is `nav`).
- [ ] **Step 3:** Replace `TextStyles.nav` with `Input.textSpecDefault` at the row label and in `itemHeight`/`itemHeightOf` (`menu.dart` ~398, ~415, ~1379) and at the Menubar trigger; add `import './input.dart';` where missing. Grep both files for `TextStyles.nav` afterwards: zero hits.
- [ ] **Step 4:** Run the listed tests; make any height expectation token-relative through `Menu.itemHeightOf(context)` / `Input.textSpecDefault.stepFor(width)`.
- [ ] **Step 5:** `flutter analyze`.

### Task 3: Pickers and palettes

**Files:**
- Modify/verify: `lib/src/components/ui/select.dart`, `native_select.dart`, `combobox.dart`, `command.dart`
- Test: `test/selects_test.dart`, `test/select_combobox_keyboard_test.dart`, `example/test/components_docs/{select,native_select,combobox,command}_test.dart`

- [ ] **Step 1:** Add to `test/selects_test.dart` a group "pickers read like Input": for Select (trigger value and an option), NativeSelect (trigger), Combobox (field and an item), Command (input and an item) assert the primary `StyledText.spec` is `Input.textSpecDefault` and the secondary (Select group label, Command heading/shortcut, Combobox empty text) is `TextStyles.small`.
- [ ] **Step 2:** Run → note which fail.
- [ ] **Step 3:** Fix every primary site that restates `TextStyles.body` to read `Input.textSpecDefault` (Select trigger and option, NativeSelect trigger, Combobox field/rows, Command input/rows); every secondary at `TextStyles.small`. Any `TextStyles.nav` in these files → `Input.textSpecDefault`.
- [ ] **Step 4:** Run the listed tests; token-relative fixes only. `flutter analyze`.

### Task 4: Fields, inputs, groups, selection controls, navigation menu

**Files:**
- Modify/verify: `lib/src/components/ui/input.dart`, `textarea.dart`, `input_otp.dart`, `input_group.dart` (addon `TextStyles.nav` → `Input.textSpecDefault`), `field.dart` (label/description/error/legend stay `small`), `form.dart` (verify), `selection_control.dart`, `checkbox.dart`, `radio.dart`, `switch.dart` (their label text at `Input.textSpecDefault`, description at `small`), `navigation_menu.dart` (trigger and link title `nav` → `Input.textSpecDefault`, description `small`)
- Test: `test/inputs_test.dart`, `test/selection_feedback_test.dart`, `test/navigation_test.dart`, `example/test/components_docs/{input,textarea,input_otp,input_group,field,form,checkbox,radio,switch,navigation_menu}_test.dart`

- [ ] **Step 1:** Add to `test/inputs_test.dart` a group "fields read like Input": InputGroup addon text spec is `Input.textSpecDefault`; Field label spec is `TextStyles.small`; Checkbox/Radio/Switch label spec is `Input.textSpecDefault`; NavigationMenu trigger spec is `Input.textSpecDefault` and link description `TextStyles.small` (put the NavigationMenu case in `test/navigation_test.dart`).
- [ ] **Step 2:** Run → note failures.
- [ ] **Step 3:** Fix the sites. Grep the listed files for `TextStyles.nav`: zero hits afterwards.
- [ ] **Step 4:** Run the listed tests; token-relative fixes only. `flutter analyze`.

### Task 5: Full-suite sweep

**Files:** any test file failing only because a reading role changed size.

- [ ] **Step 1:** `flutter test` (root) and `flutter test` (example/). List failures.
- [ ] **Step 2:** For each: if the expectation was text-derived, rewrite it through `StyledText.stepOf` / `stepFor` / `space`; if a phone-width specimen overflows, make it wrap or scroll; if a fixed box clips text, size it from the role.
- [ ] **Step 3:** Both suites green (the `performance_budget_test` long-list case may flake under load; rerun it alone). `flutter analyze` clean.

### Task 6: Registry and commit (controller)

- [ ] `dart run tool/registry_builder/bin/reseal.dart --apply`; `build.dart .`; `validate.dart registry/generated/latest/registry.json`; `flutter test test/registry_builder_test.dart test/registry_released_immutability_test.dart`.
- [ ] Commit everything with the trailer; restart the preview.

## Self-review

- Coverage: token change (Task 1); menu family incl. dropdown/context/menubar (Task 2); command, combobox, select, native select (Task 3); inputs, OTP, group, fields/forms, selection control, navigation menu, textarea (Task 4); sweep (5); registry (6).
- No placeholders: every step names files, the exact roles and the test to write.
- Names: `Input.textSpecDefault` (exists), `Menu.itemHeightOf`, `Command.itemHeightOf`, `Combobox.itemHeightOf`, `Select.labelHeightOf` (exist).
