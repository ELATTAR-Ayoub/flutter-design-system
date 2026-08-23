# shadcn Parity for Component Documentation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Every component documentation page mirrors its own shadcn counterpart page, section for section, so a reader who knows shadcn finds the same answers in the same order.

**Architecture:** One worker per component. Each worker fetches its own counterpart URL, reads that page's real section list, and reshapes our page to match it. There is no shared section template: breadcrumb's sections exist because breadcrumb has those problems, and button's are different. The only thing constant across pages is the frame: demo, Installation, Usage, then that component's own sections, then API Reference, then our extra disclosure sections.

**Tech Stack:** Flutter, Dart, the Phase C docs primitives (`DocsLayout`, `DocsCodeExample`, `DocsApiTable`, `DocsInstallFacts`, `DocsFileTree`), WebFetch for reading the reference.

## Global Constraints

- Every worker reads its OWN counterpart page. Never derive a section list from a different component.
- Counterpart URL: `https://ui.shadcn.com/docs/components/base/<slug>`. If that 404s, try `https://ui.shadcn.com/docs/components/<slug>`. If both fail, report it and use judgement from the component's own source.
- No `Examples` wrapper heading. Example sections are top level, siblings of Installation and Usage.
- API Reference is the last shadcn section, one prop table per class in the family.
- Our extra sections go AFTER API Reference, in this order: States, Accessibility, Responsive, Dependencies, Theming, Source. They are not in shadcn and they are not to be dropped.
- Where their page has a section our component genuinely cannot do, SKIP it and say which. Never fake a capability.
- Where our component has something theirs does not, add a section in their style, named for what it does rather than for the enum value.
- Section names describe a reader's problem, not an enum. Theirs read `Custom separator`, `Collapsed`, `Link component`, `RTL`. Never `Default`, `Secondary`, `Destructive` as three separate sections.
- Never use a spaced em dash in any string, comment or doc comment. Use a colon, a comma, or two sentences.
- Tokens only: no `Colors.`, no `Color(`, no `TextStyle(`, no bare `Text(` for prose, no hardcoded numeric layout, no raw `Duration(`. `Text()` as a `DsButton` child is the established convention and is fine.
- `DsType.label` uppercases its text. A `find.text` on a case-carrying identifier rendered in a label will fail. Use `DsType.small` or `DsType.code` for identifiers.
- Never `pumpAndSettle()` on a looping animation. It hangs forever.
- Workers do NOT run the full test suites. They run only their own component's test file. The supervisor runs both suites once per batch.

---

## File Structure

Per component `<name>`, the worker owns exactly three files that already exist:

```
example/lib/components_docs/<name>/meta.dart
example/lib/components_docs/<name>/page.dart
example/test/components_docs/<name>_test.dart
```

Everything else is forbidden. The catalog, routes, `main.dart` and `docs_layout.dart` are supervisor-owned and already wired: adding or renaming a section inside a page needs no change to any of them.

---

## The reference frame

Read from `https://ui.shadcn.com/docs/components/base/breadcrumb` on 2026-08-23. Its actual order:

```
[live demo, before any heading]
Installation          Command and Manual tabs
Usage                 imports plus basic construction
Composition           a tree of the widget hierarchy
Basic                 <- from here down, this component's own sections
Custom separator
Dropdown
Collapsed
Link component
RTL
API Reference         one prop table per class
```

Note what is NOT there: no `Examples` parent, no `Variants` section listing enum values, no `Status`. The middle block is entirely specific to breadcrumb.

---

## Component to counterpart mapping

Thirty-seven directories exist. Their counterparts:

| Ours | Counterpart slug | Note |
|---|---|---|
| accordion | accordion | |
| alert | alert | |
| alert_dialog | alert-dialog | |
| avatar | avatar | |
| badge | badge | |
| breadcrumb | breadcrumb | the frame reference |
| button | button | already partly reshaped |
| calendar | calendar | |
| carousel | carousel | our page also covers nav_user and marker |
| checkbox | checkbox | |
| collapsible | collapsible | |
| command | command | our page also covers combobox |
| dropdown_menu | dropdown-menu | our page also covers menu |
| field | field | |
| icon | none | our page covers icon, spinner, ds_rule. Spinner has a counterpart, use it for that part |
| input_group | input-group | our page also covers button-group and input-otp, all three have counterparts |
| native_select | native-select | our page also covers selection_control and form |
| navigation_menu | navigation-menu | our page also covers menubar, context-menu, hover-card |
| pagination | pagination | |
| popover | popover | |
| progress | progress | our page also covers skeleton |
| radio | radio-group | slug differs from ours |
| scroll_area | scroll-area | our page also covers resizable and aspect-ratio |
| separator | separator | our page also covers empty and kbd |
| sheet | sheet | our page also covers drawer |
| sidebar | sidebar | largest family |
| slider | slider | |
| stat | none | our page covers stat, item, empty, kbd. Item, Empty and Kbd have counterparts |
| switch | switch | |
| table | table | |
| tabs | tabs | |
| textarea | textarea | |
| toaster | toast | slug differs from ours |
| toggle | toggle | our page also covers toggle-group |
| tooltip | tooltip | |
| ds_rule, spinner | metadata only | no page of their own, skip |

Where our page covers several components, read EVERY counterpart it covers and merge their sections, keeping each component's sections grouped under its own name.

---

## Per-component task template

Every worker runs this identical cycle. The component name is the only variable.

### Task: reshape `<name>`

**Files:**
- Modify: `example/lib/components_docs/<name>/page.dart`
- Modify: `example/lib/components_docs/<name>/meta.dart` if the description needs to change
- Modify: `example/test/components_docs/<name>_test.dart`
- Read, never modify: `lib/src/components/<name>.dart`

**Interfaces:**
- Consumes: `DocsLayout`, `DocsTocEntry`, `DocsCodeExample`, `DocsApiTable`, `DocsInstallFacts` from `example/lib/docs/`. `const ComponentDocEntry <name>Doc` from the sibling `meta.dart`.
- Produces: nothing new. The class name and constructor stay exactly as they are, because `main.dart` dispatches on them.

- [ ] **Step 1: read the counterpart.** WebFetch `https://ui.shadcn.com/docs/components/base/<slug>` and ask for the literal section list in order, what appears under each, and how examples are presented. Write the list down before touching code.

- [ ] **Step 2: read our source.** Open `lib/src/components/<name>.dart`. For each of their sections, decide: do we have this capability, do we not have it, or do we have something they lack.

- [ ] **Step 3: write the mapping.** Three columns, in the report: their section, our section, and the verdict, one of `mirror`, `skip because our component has no such capability`, or `ours only`.

- [ ] **Step 4: update the test first.** Assert the new section list renders, in order. This will fail against the current page.

- [ ] **Step 5: run the test, confirm it fails** for the right reason: sections not found.

```
cd example && flutter test test/components_docs/<name>_test.dart
```

- [ ] **Step 6: reshape the page.** Rename and regroup sections to the mapping. Keep every existing specimen's widget code. Delete any `Examples` wrapper. Add a `Composition` section if theirs has one. Move `API Reference` to be the last shadcn section, with our six extra sections after it.

- [ ] **Step 7: run the test until green.**

- [ ] **Step 8: verify only your own files.**

```
cd example
dart format lib/components_docs/<name> test/components_docs/<name>_test.dart
dart format --output=none --set-exit-if-changed lib/components_docs/<name> test/components_docs/<name>_test.dart
flutter analyze lib/components_docs/<name> test/components_docs/<name>_test.dart
flutter test test/components_docs/<name>_test.dart
```

The format check must print `(0 changed)`. Note `--output=none` means do not write, so `(N changed)` is a failure, not a pass. Do NOT run the full suite: the supervisor does that once per batch.

- [ ] **Step 9: report.** Their section list, our final section list, the three-column mapping, anything skipped and why, and the verbatim final line of each verify command.

---

## Batching

Nine workers at a time, roughly four batches. Order by how much a reader is likely to hit the page:

**Batch 1:** button, badge, alert, avatar, checkbox, switch, tabs, tooltip, separator
**Batch 2:** accordion, breadcrumb, card via button_card_pages, collapsible, field, input_group, radio, slider, textarea
**Batch 3:** alert_dialog, sheet, popover, dropdown_menu, navigation_menu, command, toaster, pagination, table
**Batch 4:** calendar, carousel, native_select, progress, scroll_area, sidebar, stat, toggle, icon

After each batch the supervisor:
1. Runs `cd example && flutter analyze` and `flutter test`
2. Runs `flutter test` at the repo root, which includes the token guard over `example/lib`
3. Commits the batch, then starts the next

## Known traps, so nobody rediscovers them

- Overlay components need `MaterialApp` in the test harness for a real `Overlay`, otherwise they silently never open.
- A specimen below the fold needs `tester.ensureVisible(finder)` before `tap`, otherwise the tap misses.
- A string that also appears in an install-facts panel makes `find.text` ambiguous. Scope with `find.descendant`, do not loosen the matcher.
- `flutter analyze` on this project can take five to ten minutes. Scope it to your own paths.
- About 77 files under `example/` are already format dirty from a Dart formatter version change. That is pre existing. Do not reformat the tree, only your own files.

## Out of scope

This plan reshapes pages that already exist. It does not create pages for the 48 components still undocumented, and it does not add registry manifests. Both are separate work.
