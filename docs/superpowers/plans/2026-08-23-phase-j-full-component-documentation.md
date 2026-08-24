# Phase J — Full Component Documentation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:subagent-driven-development. One worker per component. Steps use checkbox (`- [ ]`) syntax.

**Goal:** Every component in `lib/src/components/` gets its own documentation page following the shadcn-equivalent template already specified in IA §9, plus a registry manifest so `elattar add <name>` works.

**Architecture:** Massive parallel fan-out — one worker per component, each writing only files it exclusively owns. The catalog and route table stay supervisor-owned and are assembled once per wave, because 80 workers editing one catalog file corrupts the tree. Per-component metadata lives beside the page in a file only that worker writes; the supervisor aggregates.

**Tech Stack:** Flutter/Dart, the Phase C docs primitives (`DocsLayout`, `DocsCodeExample`, `DocsApiTable`, `DocsStateMatrix`, `DocsInstallFacts`, `DocsFileTree`), registry schema v1.

## Global Constraints

- Page template is IA §9.1's eighteen sections, in that order. Omit a section only when genuinely inapplicable, and say why on the page.
- Two descriptions per component (IA §9.2): a one-sentence short description for nav and search, and an expanded description that answers *when to use this instead of a neighbour* — not a restatement of the name.
- Usage examples must be real Dart against the real API. IA §9.5: "Do not manufacture shadcn examples that the Dart API does not support."
- State matrix rows (IA §9.7) are omitted or marked N/A **with a reason**. Never invent asynchronous behaviour for a synchronous primitive.
- Every page carries the installation facts panel of IA §9.9.
- Tokens only: no `Colors.`, no `Color(`, no `TextStyle(`, no bare `Text(` for prose, no hardcoded numeric layout. `el()`, `ElText`/`ElType`, `ElTheme.of(context)`.
- Real test-view sizing (`tester.view.physicalSize` + `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. Live `ElThemeController` flipped in place for theme coverage.
- A registry manifest's `registryDependencies` may only name items that exist. Adding a component to the registry means adding its real transitive support items too.
- `dart format` clean on every file touched.

---

## File Structure

Per component `<name>`, exactly three files, owned by exactly one worker:

```
example/lib/components_docs/<name>/meta.dart     # ComponentDocEntry for this component
example/lib/components_docs/<name>/page.dart     # the documentation page
example/test/components_docs/<name>_test.dart    # its tests
registry/components/<name>.json                  # registry manifest (if not present)
```

Supervisor-owned, serialized, never assigned to a worker:

```
example/lib/components_docs/catalog.dart         # aggregates every meta.dart
example/lib/site/site_routes.dart                # routes + search index
example/lib/main.dart                            # route arms
registry/generated/**                            # regenerated once per wave
```

This is the decomposition that makes the fan-out safe. A worker never opens a file another worker writes.

---

## Component inventory

Already documented (Phase F, do not redo): `button` `input` `card` `dialog` `select`

**Wave 1 — base primitives, no registry item yet**
`accordion` `alert` `avatar` `badge` `breadcrumb` `checkbox` `collapsible` `empty` `kbd` `progress` `separator` `skeleton` `switch` `toggle` `tooltip`

**Wave 2 — form and input family**
`button_group` `combobox` `field` `form` `input_group` `input_otp` `native_select` `radio` `selection_control` `slider` `textarea`

**Wave 3 — overlay and navigation**
`alert_dialog` `command` `context_menu` `drawer` `dropdown_menu` `hover_card` `menu` `menubar` `navigation_menu` `pagination` `popover` `sheet` `sidebar` `tabs` `toaster`

**Wave 4 — layout and data**
`aspect_ratio` `calendar` `carousel` `item` `resizable` `scroll_area` `stat` `table`

**Wave 5 — charts**
`chart` `chart_cartesian` `chart_geometry` `chart_polar`

**Wave 6 — agent family**
`agent_attach_menu` `agent_attachments` `agent_avatar` `agent_composer` `agent_console` `agent_face` `agent_history` `agent_launcher` `agent_markdown` `agent_slash_palette` `agent_transcript` `attachment` `bubble` `message` `message_scroller` `questionnaire` `voice`

**Excluded — not user-facing components:** `agent_core` `icon_paths` `icon_paths.g` `icon_paths.g.index` `el_safe_area` `icon_swap` `marker`
(`icon`, `spinner`, `rule` already have registry items; they get pages in Wave 1 if time allows.)

---

## Per-component task template

Every worker runs this identical cycle. The component name is the only variable.

### Task: document `<name>`

**Files:**
- Create: `example/lib/components_docs/<name>/meta.dart`
- Create: `example/lib/components_docs/<name>/page.dart`
- Create: `example/test/components_docs/<name>_test.dart`
- Create (only if absent): `registry/components/<name>.json`
- Read, never modify: `lib/src/components/<name>.dart`, the docs primitives, `example/lib/components_docs/button_card_pages.dart` as the reference implementation

**Interfaces:**
- Produces: `const ComponentDocEntry <name>Doc` in `meta.dart`, and a page widget `class <Name>DocPage extends StatelessWidget` taking `{super.key, ValueChanged<String>? onNavigate}`. The supervisor imports both by exactly those names.

- [ ] **Step 1: read the real API.** Open `lib/src/components/<name>.dart`. List every public class, enum, and constructor parameter with its type and default. The API table is generated from what is actually there, not from what shadcn has.

- [ ] **Step 2: write the failing test first.** Assert the page renders, that the API table lists every public constructor parameter you found in Step 1, and that a live specimen of the real widget mounts.

- [ ] **Step 3: run it, confirm it fails** for the right reason (page does not exist yet).

- [ ] **Step 4: write `meta.dart`** — short description, expanded description, registry dependencies, public exports, source path.

- [ ] **Step 5: write `page.dart`** — the eighteen sections of IA §9.1, composed from the Phase C primitives.

- [ ] **Step 6: run the test until green.**

- [ ] **Step 7: add responsive and theme coverage** — 390x844 and 1440x900, light and dark.

- [ ] **Step 8: registry manifest** if the component has none. Verify every `registryDependencies` entry exists; add real transitive support items rather than inventing names.

- [ ] **Step 9: verify.**
```
cd example
dart format --output=none --set-exit-if-changed lib/components_docs/<name> test/components_docs/<name>_test.dart
flutter analyze
flutter test test/components_docs/<name>_test.dart
```

- [ ] **Step 10: report.** Status, files created, the public API you documented, verification output verbatim, and anything about the component that the template did not fit.

---

## Supervisor duties between waves

1. Aggregate every new `meta.dart` into `example/lib/components_docs/catalog.dart`.
2. Add routes and search entries in `site_routes.dart`; add route arms in `main.dart`.
3. Regenerate `registry/generated/**` exactly once.
4. Run the full gates: root analyze + test, example analyze + test, CLI analyze + test, registry build + validate, release web build.
5. Only then start the next wave.

## Docs sidebar

IA §7.3 defines the group structure. Components group is `Foundations / Base components / Agent / Site`. Wave assignments above map onto it: Waves 1-5 are Base components, Wave 6 is Agent.

## Known risk

The registry currently holds 20 items. Most Wave 1-6 components have no manifest, and adding one means adding its real transitive dependencies. A worker that invents a dependency name fails validation loudly — that is the intended behaviour, not a problem to work around.
