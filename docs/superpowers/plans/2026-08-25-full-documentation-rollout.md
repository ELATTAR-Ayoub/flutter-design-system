# Full documentation rollout Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Put every one of the 99 registry items and all seven non-component documentation pages on the documentation kit, so the site has one page shape and no route that resolves to nothing.

**Architecture:** The kit already exists and the Button page is built on it (`db6f879`). A page is a `ComponentDocSpec` — a name, a title, a description, and an ordered list of four sealed section kinds — that `ComponentDocPage` renders, deriving the table of contents from the same list. This plan closes four kit gaps, re-houses the 55 pages that exist, writes the 44 that do not, and rebuilds the seven non-component pages on the same shape. No task writes layout.

**Tech Stack:** Flutter 3.44.8, Dart 3.12.2, `package:elattar_design_system` public barrel only.

**Reference implementation:** `example/lib/components_docs/button/page.dart` and its report at `docs/superpowers/reports/docs-kit/button-page-review.md`. Read both before Task 1.

## Global Constraints

Every task's requirements implicitly include this section.

- **Repository mode.** `lib/elattar_design_system.dart` exists, no `elattar.yaml`. All paths are repository-mode names.
- **Import the system through the public barrel only:** `package:elattar_design_system/elattar_design_system.dart`. Never reach into `lib/src/`.
- **Nothing under `lib/src/` may be modified**, and no foundation token may be added or edited. Every gap is closed in `example/lib/docs/`.
- **No visual literals in `example/lib/`.** Geometry from `el(...)`, `Widths`, `Containers`, `Breakpoints`; colour from `Theme.of(context)`; type from `Text`/`Type`; timing from `Durations`/`Curves`. A bare `0` or `0.0` is legal. `test/token_guard_test.dart` enforces this from the repository root.
- **No uppercase type roles** anywhere under `example/lib/docs/` or `example/lib/components_docs/`: `Type.label`, `Type.micro`, `Type.tag`, `Type.badge`, `Type.serial`, `Type.inputSerial`, `Type.buttonLabelCaps`. Never call `String.toUpperCase()`. `example/test/docs/docs_no_uppercase_test.dart` enforces it.
- **`Type.textSm` does not exist.** `textSm` belongs to `ComponentType` (`lib/src/design_system/foundation/typography.dart:750`); `class Type` starts at line 980 and has no such member. The de-uppercased eyebrow role is **`Type.section`** — 13px/1.4/600/muted, documented at `typography.dart:1121` as "the label's quiet twin: a group heading in sentence case".
- **`pumpAndSettle` is forbidden** in any test that pumps a documentation page. Several components (`Alert` via `BloomCosmic`, the premium button's foil shimmer, the starfield) run controllers that `repeat(reverse: true)` forever, so settling times out rather than failing. Use `tester.pump()`.
- **Test view sizing** uses `tester.view.physicalSize` + `tester.view.devicePixelRatio` with `addTearDown(tester.view.reset)`, never a synthetic `MediaQuery` for sizing.
- **A width assertion under a bare `SizedBox(width: N)` reports the root constraint**, not N, because `pumpWidget`'s RenderView hands down tight constraints. Wrap the subject in a `Center` inside the test host. Five tasks in the previous plan hit this independently.
- **Any test that taps a `DocsCopyButton` must drain its confirmation timer** (`await tester.pump(DocsCopyButton.confirmation)`) or Flutter's teardown fails on a pending timer.
- **Every new page's install command must name a real registry item.** `example/test/docs/docs_install_test.dart` iterates `componentDocs` and checks each `ComponentDocEntry.command` against `registry/generated/latest/registry.json`. It also asserts `componentDocs.length >= 55`; raise that floor as pages land.
- **Commit after every task.** Never combine two tasks in one commit. Never create a `codex/`-prefixed branch. Never push, tag, deploy Pages, create a release, or run `dart pub publish` without `--dry-run`.

## How to run tests

Windows-side `flutter test` is blocked by Smart App Control, which refuses the unsigned `flutter_tester.exe`. **Do not run `flutter test` on Windows and never change that security setting.** A native Linux Flutter 3.44.8 is installed at `/opt/flutter` in WSL2 Ubuntu-24.04, with a helper at `/usr/local/bin/ft`:

```bash
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=<yourname> ft example test test/docs/foo_test.dart"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=<yourname> ft example test test/components_docs"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=<yourname> ft root test test/token_guard_test.dart"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=<yourname> ft example analyze lib test"
```

`ft <root|example> <flutter args...>` rsyncs the Windows working tree into a private ext4 mirror at `/root/fds-$FT_ID` and runs Flutter there; DrvFs is far too slow. **Give every concurrent agent its own `FT_ID`** or they contend. **Every edit stays on the Windows side** at `D:\DESIGN\Design-System-2026-8\flutter-design-system\...` — the mirror is disposable and refreshed on each invocation.

Run these in the **foreground** with a `timeout` of 1800000. Never background them or wrap them in a Monitor.

- Never run bare `flutter analyze` from `example/`: stale `example/build/web/registry/**` artifacts produce ~4,788 pre-existing errors. Always scope to `lib test`.
- `test/components_docs` is ~538 tests and takes about 17 minutes. Run it once per batch, at the end — never in a loop.

## The kit API, verbatim

From `example/lib/docs/component_doc_page.dart`. A page declares these and nothing else.

```dart
sealed class DocsPageSection {
  const DocsPageSection({required this.id, required this.title, this.description});
  final String id;
  final String title;
  final String? description;
}

class ShowcaseSection extends DocsPageSection {
  const ShowcaseSection({
    required super.id, required super.title, super.description,
    required this.specimen, required this.code,
    this.alignment = Alignment.center, this.label,
  });
  final Widget specimen;
  final String code;
  final Alignment alignment;
  final String? label;   // the toggle's accessible name; pass the section title
}

class SnippetSection extends DocsPageSection {
  const SnippetSection({
    required super.id, required super.title, super.description, required this.code,
  });
  final String code;
}

class InstallSection extends DocsPageSection {
  const InstallSection({
    required super.id, required super.title, super.description,
    required this.command, required this.manualFiles,
  });
  final String command;
  final List<DocsCodeFile> manualFiles;
}

class DisclosureSection extends DocsPageSection {
  const DisclosureSection({
    required super.id, required super.title, super.description, required this.child,
  });
  final Widget child;
}

class ComponentDocSpec {
  const ComponentDocSpec({
    required this.name, required this.title,
    required this.description, required this.sections,
  });
  final String name;
  final String title;
  final String description;
  final List<DocsPageSection> sections;
  List<DocsTocEntry> get toc;   // derived — never write a second list
}

class ComponentDocPage extends StatelessWidget {
  const ComponentDocPage({super.key, required this.spec, this.header = true});
}
```

Supporting components, all in `example/lib/docs/`: `DocsShowcase`, `DocsShowcaseFrame`, `DocsSnippet`, `DocsSnippetOverflow`, `DocsCopyButton`, `DocsDisclosure`, `DocsTable`, `DocsTableColumn`, `DocsApiTable`, `DocsInstall`, `DocsSection`, `DocsAnchor`, `docsTokenise`.

## The page shape every page follows

Button's order, which is the house shape:

Preview, Installation, Usage, then one `ShowcaseSection` per variant or state the component has, then the disclosures: API Reference, States, Accessibility, Keyboard, Responsive, Dependencies, Theming, Source.

- **Preview** is a `ShowcaseSection` whose specimen shows the component's variants side by side.
- **Installation** is the one `InstallSection`. Its `command` comes from the catalog entry's `command` getter, never a literal.
- **Usage** is a `SnippetSection` — the smallest correct import and construction.
- The eight trailing disclosures are always present and always in that order. A component with nothing to say under one still gets the section, with an honest sentence rather than filler.
- `ComponentDocPage` is always given `header: false` when hosted in `DocsLayout`, because `DocsLayout` already renders the eyebrow, title and description from its `intro`.

## Current state, measured

| Fact | Value |
| --- | --- |
| Registry items | 99 — 84 component, 9 effect, 5 motion, 1 foundation |
| Component doc pages that exist | 55 |
| `componentDocs` catalog entries | 55 |
| Registry items with **no** page | **44** |
| Non-component documentation pages | 7 (introduction, installation, theming, cli, registry, changelog, typeset) |
| Pages already on the kit | 1 (button) |

The 44 with no page:

`agent-attach-menu`, `agent-attachments`, `agent-avatar`, `agent-composer`, `agent-console`, `agent-core`, `agent-face`, `agent-history`, `agent-launcher`, `agent-markdown`, `agent-slash-palette`, `agent-transcript`, `attachment`, `feedback-surface`, `bubble`, `card`, `chart`, `chart-cartesian`, `chart-geometry`, `chart-polar`, `dialog`, `premium-surface`, `glass`, `icon-swap`, `input`, `keyframes`, `lift`, `surface`, `media-scrim`, `menu`, `message`, `message-scroller`, `background-effect`, `press`, `questionnaire`, `safe-area`, `select`, `action-feedback`, `active-indicator`, `source-foundation`, `starfield`, `content-change`, `voice`, `voice-indicator`.

## File structure

**Modify — the kit (Phase A only):**

| File | Change |
| --- | --- |
| `example/lib/docs/component_doc_page.dart` | nested TOC children; `EffectSection`; `minHeight` passthrough |
| `example/lib/docs/docs_showcase.dart` | per-instance `minHeight` |

**Create — one directory per new item**, mirroring the existing convention:

```
example/lib/components_docs/<snake_name>/meta.dart   # ComponentDocEntry
example/lib/components_docs/<snake_name>/page.dart   # the ComponentDocSpec
example/test/components_docs/<snake_name>_test.dart  # the page's own test
```

**Modify — one line per new page:**

| File | Change |
| --- | --- |
| `example/lib/components_docs/catalog.dart` | import + one list entry per new page |
| `example/test/docs/docs_install_test.dart` | raise the `componentDocs.length` floor |

**Modify — Phase D:**

`example/lib/docs_pages/{introduction,installation,theming,cli,registry,changelog,typeset}_page.dart`

---

## Phase A — close the kit's four gaps

The Button page exposed these. Every later phase depends on them, so they land first and nothing else starts until Phase A is reviewed.

### Task 1: Per-showcase minimum height

The stage is a fixed `el(160)` = 640 minimum. On the Button page that is a single pill floating in a 640-tall box, sixteen times, and a page 17,925px tall. The owner has seen it and it reads as empty space. A tall specimen still wants 640; a lone button does not.

**Files:**
- Modify: `example/lib/docs/docs_showcase.dart`
- Modify: `example/lib/docs/component_doc_page.dart`
- Test: `example/test/docs/docs_showcase_test.dart`

**Interfaces:**
- Consumes: nothing.
- Produces: `DocsShowcase({..., double? minHeight})` and `ShowcaseSection({..., double? minHeight})`. Null keeps today's breakpoint-derived behaviour, so every existing call site is unaffected. Phases B, C and D pass it.

- [ ] **Step 1: Write the failing test**

Add to `example/test/docs/docs_showcase_test.dart`:

```dart
  testWidgets('an explicit minHeight overrides the breakpoint default', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        DocsShowcase(
          specimen: const SizedBox(height: 40, width: 120),
          code: 'const SizedBox(height: 40, width: 120)',
          minHeight: el(64),
        ),
      ),
    );
    await tester.pump();

    expect(tester.getSize(find.byType(DocsShowcaseFrame)).height, el(64));
  });

  testWidgets('a null minHeight keeps the breakpoint default', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        const DocsShowcase(
          specimen: SizedBox(height: 40, width: 120),
          code: 'x',
        ),
      ),
    );
    await tester.pump();

    expect(
      tester.getSize(find.byType(DocsShowcaseFrame)).height,
      greaterThanOrEqualTo(el(160)),
    );
  });
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=a1 ft example test test/docs/docs_showcase_test.dart"`
Expected: FAIL — `No named parameter with the name 'minHeight'`.

- [ ] **Step 3: Add the parameter**

In `example/lib/docs/docs_showcase.dart`, add `this.minHeight` to `DocsShowcase`'s constructor and `final double? minHeight;` to its fields, then in `_DocsShowcaseState.build` replace the height computation with:

```dart
    final double minHeight =
        widget.minHeight ??
        DocsShowcase.minHeightFor(MediaQuery.sizeOf(context).width);
```

In `example/lib/docs/component_doc_page.dart`, add `this.minHeight` to `ShowcaseSection`'s constructor, `final double? minHeight;` to its fields, and thread it through `ComponentDocPage._body`'s `ShowcaseSection` case into `DocsShowcase(minHeight: minHeight)`.

- [ ] **Step 4: Run the tests and make sure they pass**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=a1 ft example test test/docs 2>&1 | tail -20"`
Expected: PASS, whole `test/docs` directory green.

- [ ] **Step 5: Run the token guard**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=a1 ft root test test/token_guard_test.dart"`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add example/lib/docs/docs_showcase.dart example/lib/docs/component_doc_page.dart example/test/docs/docs_showcase_test.dart
git commit -m "feat(docs): let a section choose its own stage height"
```

### Task 2: Nested table-of-contents children

`ComponentDocSpec.toc` is flat. The Button page lost six sub-anchors under API Reference because of it (`api-elbutton`, `api-elbutton-size`, and four more), and a route test had to be retargeted. Components with several API tables — the agent family, the chart family, `select`, `menu` — all need them.

**Files:**
- Modify: `example/lib/docs/component_doc_page.dart`
- Test: `example/test/docs/component_doc_page_test.dart`

**Interfaces:**
- Consumes: Task 1.
- Produces: `DisclosureSection({..., List<DocsTocEntry> children = const <DocsTocEntry>[]})`, and `ComponentDocSpec.toc` emitting them as `DocsTocEntry.children`. `DocsTocEntry` already has a `children` field (`example/lib/docs/docs_layout.dart:105`) — this only populates it.

- [ ] **Step 1: Write the failing test**

Add to `example/test/docs/component_doc_page_test.dart`:

```dart
  test('a disclosure section contributes its children to the toc', () {
    const ComponentDocSpec spec = ComponentDocSpec(
      name: 'x',
      title: 'X',
      description: 'd',
      sections: <DocsPageSection>[
        DisclosureSection(
          id: 'api',
          title: 'API Reference',
          child: Text('tables'),
          children: <DocsTocEntry>[
            DocsTocEntry(title: 'X', anchor: 'api-elx'),
            DocsTocEntry(title: 'XSize', anchor: 'api-elx-size'),
          ],
        ),
      ],
    );

    expect(spec.toc.single.anchor, 'api');
    expect(
      spec.toc.single.children.map((DocsTocEntry e) => e.anchor).toList(),
      <String>['api-elx', 'api-elx-size'],
    );
  });
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=a2 ft example test test/docs/component_doc_page_test.dart"`
Expected: FAIL — `No named parameter with the name 'children'`.

- [ ] **Step 3: Add children to the model**

In `example/lib/docs/component_doc_page.dart`, add to `DisclosureSection`:

```dart
    this.children = const <DocsTocEntry>[],
```

with `final List<DocsTocEntry> children;`, and change `ComponentDocSpec.toc` to:

```dart
  List<DocsTocEntry> get toc => <DocsTocEntry>[
    for (final DocsPageSection section in sections)
      DocsTocEntry(
        title: section.title,
        anchor: section.id,
        children: section is DisclosureSection
            ? section.children
            : const <DocsTocEntry>[],
      ),
  ];
```

A nested child's anchor must be registered by a `DocsAnchor` inside the disclosure's `child`, or the rail link scrolls nowhere. Wrap each sub-table in `DocsAnchor(id: 'api-elx', child: DocsApiTable(...))`.

- [ ] **Step 4: Run the tests and make sure they pass**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=a2 ft example test test/docs 2>&1 | tail -20"`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add example/lib/docs/component_doc_page.dart example/test/docs/component_doc_page_test.dart
git commit -m "feat(docs): let a disclosure carry its own toc children"
```

### Task 3: An EffectSection for the fourteen non-component items

Nine effects, five motion items and one foundation item are in the registry and need pages, but they are not components: `starfield`, `background-effect`, `press`, `keyframes`, `safe-area`, `source-foundation` have no variants, often no visible widget of their own, and are applied to something else. Forcing them into `ShowcaseSection` produces an empty stage and a lie.

The sealed model has four cases and no escape hatch by design. This is the fifth case, added deliberately and reviewed as one — not a generic `WidgetSection` or a `builder` callback.

**Files:**
- Modify: `example/lib/docs/component_doc_page.dart`
- Test: `example/test/docs/component_doc_page_test.dart`

**Interfaces:**
- Consumes: Tasks 1 and 2.
- Produces: `EffectSection({required String id, required String title, String? description, required Widget host, required String code, String? label})`. Renders a `DocsShowcase` whose specimen is `host` — the thing the effect is applied to — with the stage sized to the host rather than to a 640 default. Phase C uses it for all 14.

- [ ] **Step 1: Write the failing test**

Add to `example/test/docs/component_doc_page_test.dart`:

```dart
  testWidgets('an effect section renders its host in a stage', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        const ComponentDocPage(
          spec: ComponentDocSpec(
            name: 'glass',
            title: 'Glass',
            description: 'A surface treatment.',
            sections: <DocsPageSection>[
              EffectSection(
                id: 'applied',
                title: 'Applied',
                host: SizedBox(height: 120, width: 200),
                code: 'Glass(child: ...)',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(DocsShowcase), findsOneWidget);
    expect(find.text('Applied'), findsOneWidget);
  });
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=a3 ft example test test/docs/component_doc_page_test.dart"`
Expected: FAIL — `Undefined name 'EffectSection'`.

- [ ] **Step 3: Add the fifth case**

In `example/lib/docs/component_doc_page.dart`:

```dart
/// An effect, motion primitive or foundation token applied to a host.
///
/// The fifth case, and the last: these fourteen registry items have no
/// variants and often no widget of their own, so a [ShowcaseSection] would
/// stage an empty box. What a reader needs to see is the thing the effect is
/// applied *to*, at the host's own size.
class EffectSection extends DocsPageSection {
  const EffectSection({
    required super.id,
    required super.title,
    super.description,
    required this.host,
    required this.code,
    this.label,
  });

  /// The widget the effect is applied to.
  final Widget host;
  final String code;
  final String? label;
}
```

Add the case to `ComponentDocPage._body`'s switch — Dart's exhaustiveness check will demand it, which is the point of the sealed class:

```dart
    EffectSection(:final Widget host, :final String code, :final String? label,
        :final String title) =>
      DocsShowcase(
        specimen: host,
        code: code,
        label: label ?? title,
        minHeight: DocsShowcase.shortMinHeight,
      ),
```

- [ ] **Step 4: Run the tests and make sure they pass**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=a3 ft example test test/docs 2>&1 | tail -20"`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add example/lib/docs/component_doc_page.dart example/test/docs/component_doc_page_test.dart
git commit -m "feat(docs): add the effect section the registry's fourteen need"
```

### Task 4: A page-shape guard

55 pages are about to be written by many agents. Without a mechanical check they will drift — a missing Accessibility section, a hand-written TOC, an install command typed as a literal. This guard is what makes the rollout reviewable at all.

**Files:**
- Test: `example/test/docs/docs_page_shape_test.dart`

**Interfaces:**
- Consumes: Tasks 1-3.
- Produces: nothing. Every later task must keep it green.

- [ ] **Step 1: Write the guard**

```dart
// example/test/docs/docs_page_shape_test.dart
/// Every component page is the same page.
///
/// A rollout written by many hands drifts unless the shape is checked
/// mechanically. This is that check.
library;

import 'package:example/components_docs/catalog.dart';
import 'package:example/docs/component_doc_page.dart';
import 'package:flutter_test/flutter_test.dart';

/// The eight disclosures every component page carries, in order.
const List<String> _requiredDisclosures = <String>[
  'API Reference',
  'States',
  'Accessibility',
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

void main() {
  test('every registered page declares the house shape', () {
    for (final ComponentDocEntry entry in componentDocs) {
      final ComponentDocSpec? spec = entry.spec;
      if (spec == null) continue; // not yet migrated

      final List<String> titles =
          spec.sections.map((DocsPageSection s) => s.title).toList();

      expect(titles.first, 'Preview', reason: '${entry.name}: first section');
      expect(titles[1], 'Installation', reason: '${entry.name}: second section');
      expect(titles[2], 'Usage', reason: '${entry.name}: third section');
      expect(
        titles.sublist(titles.length - _requiredDisclosures.length),
        _requiredDisclosures,
        reason: '${entry.name}: the trailing disclosures, in order',
      );

      expect(
        spec.sections.whereType<InstallSection>().length,
        1,
        reason: '${entry.name}: exactly one install section',
      );
      expect(
        spec.sections.whereType<InstallSection>().single.command,
        entry.command,
        reason: '${entry.name}: the command must come from the catalog entry',
      );

      final Set<String> ids = <String>{};
      for (final DocsPageSection section in spec.sections) {
        expect(
          ids.add(section.id),
          isTrue,
          reason: '${entry.name}: duplicate section id "${section.id}"',
        );
      }
    }
  });
}
```

- [ ] **Step 2: Add `spec` to the catalog entry**

In `example/lib/components_docs/catalog.dart`, add to `ComponentDocEntry`:

```dart
    this.spec,
```

with:

```dart
  /// The page's declaration, once it has been migrated to the kit. Null while
  /// a page is still hand-composed — the shape guard skips those.
  final ComponentDocSpec? spec;
```

Then set `spec: buttonDocSpec` on the button entry in `example/lib/components_docs/button/meta.dart`.

- [ ] **Step 3: Run it**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=a4 ft example test test/docs/docs_page_shape_test.dart"`
Expected: PASS with one migrated page (button) checked. If it fails, the Button page does not match its own house shape and that is worth knowing before 98 more copy it.

- [ ] **Step 4: Run the analyzer**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=a4 ft example analyze lib test"`
Expected: 0 issues.

- [ ] **Step 5: Commit**

```bash
git add example/test/docs/docs_page_shape_test.dart example/lib/components_docs/catalog.dart example/lib/components_docs/button/meta.dart
git commit -m "test(docs): hold every page to the button page's shape"
```

### Task 5: Phase A gate

- [ ] **Step 1: Run the full ladder**

```bash
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=a5 ft root test test/token_guard_test.dart"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=a5 ft example analyze lib test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=a5 ft example test test/docs"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=a5 ft example test test/components_docs"
```

Expected: all clean. `test/components_docs` is ~538 tests, ~17 minutes.

- [ ] **Step 2: Stop and report**

Report the kit's new surface to the owner before any page work begins. Phase A changes the shape every remaining task copies 98 times; a defect here is 98 defects.

---

## Phase B — re-house the 54 remaining existing pages

Each page keeps its content and moves onto the kit. **This is a re-housing, not a rewrite: every existing specimen widget and every existing code string moves across unchanged.** The one addition per page is a Keyboard disclosure if the page lacks one.

**Batching.** Fourteen tasks, four pages each (the last has two). One subagent per task, **Sonnet**. Pages within a batch share a family so the agent holds one mental model.

**Per-page recipe — follow this exactly.** For page `<name>`:

1. Read `example/lib/components_docs/<name>/page.dart` end to end.
2. Read `example/lib/components_docs/button/page.dart` as the reference shape.
3. Rewrite `page.dart` as `final ComponentDocSpec <name>DocSpec` plus a thin page widget:

```dart
class <Name>DocPage extends StatelessWidget {
  const <Name>DocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
        route: <name>Doc.route,
        intro: DocsPageIntro(
          eyebrow: '<the page's existing eyebrow>',
          title: <name>Doc.title,
          description: <name>Doc.description,
        ),
        breadcrumbs: const <BreadcrumbEntry>[
          BreadcrumbEntry.link('Components'),
          BreadcrumbEntry.page('<Name>'),
        ],
        toc: <name>DocSpec.toc,
        onNavigate: onNavigate,
        child: const ComponentDocPage(spec: <name>DocSpec, header: false),
      );
}
```

4. Each specimen becomes its own small widget class so the section list stays `const` where possible and a stateful specimen keeps its state.
5. `InstallSection.command` is `<name>Doc.command` — never a literal.
6. Set `spec: <name>DocSpec` on the entry in `<name>/meta.dart`.
7. Give every `ShowcaseSection` a `label` (its own title) and a `minHeight` sized to its specimen — a lone control does not need 640.
8. Keep the existing test file's assertions; update only how they locate things. **Never weaken an API-coverage assertion** — those prove the reference documents the whole widget.

**Per-task steps** (identical for every batch; `<batch>` is the task number):

- [ ] **Step 1:** For each of the four pages, apply the recipe above.
- [ ] **Step 2:** Run each page's own test:
      `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=b<batch> ft example test test/components_docs/<name>_test.dart"`
      Fix failures in the page, not the test, unless the test asserted the old layout's private geometry.
- [ ] **Step 3:** Run the shape guard:
      `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=b<batch> ft example test test/docs/docs_page_shape_test.dart"`
- [ ] **Step 4:** Run the token guard and the uppercase guard:
      `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=b<batch> ft root test test/token_guard_test.dart"`
      `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=b<batch> ft example test test/docs/docs_no_uppercase_test.dart"`
- [ ] **Step 5:** Run the analyzer:
      `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=b<batch> ft example analyze lib test"`
- [ ] **Step 6:** Commit, one commit for the batch:
      `git add example/lib/components_docs/<the four>/ example/test/components_docs/<the four>_test.dart`
      `git commit -m "refactor(docs): re-house <family> on the documentation kit"`

**The batches.** These are the 54 directories that exist under `example/lib/components_docs/` today, minus `button`, which is already migrated. The list was taken from the tree, not from memory — but re-run `ls example/lib/components_docs/` before Task 6 and correct this table in the plan if it has drifted.

| Task | Family | Pages |
| --- | --- | --- |
| 6 | Controls | `badge`, `button_group`, `toggle`, `toggle_group` |
| 7 | Text inputs | `input_group`, `input_otp`, `textarea`, `native_select` |
| 8 | Forms | `field`, `form`, `checkbox`, `radio` |
| 9 | Selection | `switch`, `selection_control`, `slider`, `combobox` |
| 10 | Overlays | `alert_dialog`, `popover`, `sheet`, `drawer` |
| 11 | Menus | `dropdown_menu`, `context_menu`, `menubar`, `command` |
| 12 | Navigation | `breadcrumb`, `tabs`, `pagination`, `navigation_menu` |
| 13 | Structure | `accordion`, `collapsible`, `separator`, `resizable` |
| 14 | Feedback | `alert`, `toaster`, `spinner`, `progress` |
| 15 | Empty states | `skeleton`, `empty`, `rule`, `marker` |
| 16 | Data display | `table`, `stat`, `calendar`, `carousel` |
| 17 | Media | `avatar`, `aspect_ratio`, `scroll_area`, `sidebar` |
| 18 | Chrome | `hover_card`, `kbd`, `item`, `icon` |
| 19 | Remainder | `user_menu`, `tooltip` |

Two naming traps in this list:

- **`switch` is a Dart reserved word.** The directory is `switch/`, but the spec variable cannot be `switchDocSpec`-adjacent to a keyword position — name it `switchDocSpec` (legal as an identifier) and check that the existing `meta.dart` already works around it. Read that file before writing.
- **`radio` and `selection_control` overlap conceptually.** Read both before touching either; they may document the same widget family from different angles, and the re-housing must not merge them.

### Task 20: Phase B gate

- [ ] **Step 1:** Run the full ladder as in Task 5.
- [ ] **Step 2:** Confirm the shape guard now checks 55 specs, not 1.
- [ ] **Step 3:** Capture three re-housed pages from different families at 1440 dark and 390 dark, following `docs/superpowers/reports/docs-kit/button-page-review.md`'s capture recipe. Report to the owner before Phase C.

---

## Phase C — write the 44 missing pages

These have no page at all. Each needs a `meta.dart`, a `page.dart`, a test, a catalog entry and a route.

**Research before writing.** For each item, the source of truth is the component's own source and tests under `lib/src/`, plus any specimen in `example/lib/`. Read the constructor, every named parameter, the class docstring and the focused tests before declaring a single section. **Do not invent behaviour.** If a component has no `Keyboard` story, the disclosure says so in one honest sentence.

**The API Reference must document every named constructor parameter the class declares.** Button's test asserts exactly this and it is the most valuable test on the page — write the same assertion for each new page, listing the parameters from the actual constructor.

**Batching:** eleven tasks, four items each, one subagent per task, **Sonnet**.

| Task | Family | Items | Section kind |
| --- | --- | --- | --- |
| 21 | Agent core | `agent-core`, `agent-console`, `agent-transcript`, `agent-composer` | Showcase |
| 22 | Agent surfaces | `agent-avatar`, `agent-face`, `agent-launcher`, `agent-history` | Showcase |
| 23 | Agent extras | `agent-attach-menu`, `agent-attachments`, `agent-markdown`, `agent-slash-palette` | Showcase |
| 24 | Charts | `chart`, `chart-cartesian`, `chart-polar`, `chart-geometry` | Showcase |
| 25 | Core controls | `input`, `select`, `menu`, `dialog` | Showcase |
| 26 | Containers | `card`, `bubble`, `message`, `message-scroller` | Showcase |
| 27 | Misc components | `attachment`, `questionnaire`, `voice`, `voice-indicator` | Showcase |
| 28 | Interaction | `icon-swap`, `active-indicator`, `content-change`, `lift` | Effect |
| 29 | Surfaces | `glass`, `surface`, `media-scrim`, `premium-surface` | Effect |
| 30 | Atmosphere | `starfield`, `background-effect`, `feedback-surface`, `action-feedback` | Effect |
| 31 | Motion + foundation | `press`, `keyframes`, `safe-area`, `source-foundation` | Effect |

**Per-task steps:**

- [ ] **Step 1:** For each item, read its source under `lib/src/`, its tests under `test/`, and any existing specimen.
- [ ] **Step 2:** Create `example/lib/components_docs/<snake_name>/meta.dart` declaring a `ComponentDocEntry` with `name`, `title`, `description`, `route`, and `spec`. Copy the shape from `example/lib/components_docs/button/meta.dart`. **`name` must match the registry item's name** with hyphens as underscores, so `command` derives correctly.
- [ ] **Step 3:** Create `page.dart` as a `ComponentDocSpec` following the house shape, using `EffectSection` for Tasks 28-31 and `ShowcaseSection` elsewhere.
- [ ] **Step 4:** Create `example/test/components_docs/<snake_name>_test.dart` asserting: the page renders, every declared section appears, the API table covers every constructor parameter, and both themes render without exception. Model it on `example/test/components_docs/button_test.dart`.
- [ ] **Step 5:** Register the page — add the import and list entry to `example/lib/components_docs/catalog.dart`, and the route wherever the site resolves `documentationRoute`.
- [ ] **Step 6:** Raise the floor in `example/test/docs/docs_install_test.dart` to the new `componentDocs.length`.
- [ ] **Step 7:** Run the page tests, the shape guard, the install guard, the token guard, the uppercase guard and the analyzer, exactly as Phase B's steps 2-5.
- [ ] **Step 8:** Commit the batch.

### Task 32: Phase C gate

- [ ] **Step 1:** Run the full ladder.
- [ ] **Step 2:** Assert the gap is closed. Add to `example/test/docs/docs_install_test.dart`:

```dart
  test('every registry item has a documentation page', () {
    final Map<String, Object?> registry =
        jsonDecode(File('../registry/generated/latest/registry.json')
            .readAsStringSync()) as Map<String, Object?>;
    final Set<String> documented = <String>{
      for (final ComponentDocEntry entry in componentDocs)
        entry.name.replaceAll('_', '-'),
    };
    final List<String> undocumented = <String>[
      for (final Object? raw in registry['items']! as List<Object?>)
        if (!documented.contains((raw! as Map<String, Object?>)['name']))
          (raw as Map<String, Object?>)['name']! as String,
    ];
    expect(undocumented, isEmpty);
  });
```

Expected: PASS with all 99 documented. This test is the whole point of Phase C.

- [ ] **Step 3:** Commit and report to the owner.

---

## Phase D — the seven non-component pages

`introduction`, `installation`, `theming`, `cli`, `registry`, `changelog`, `typeset`. These are prose pages, not component references, so the house shape does not fit: they have no Installation-by-CLI, no variants, no API table.

**They share the kit's *components*, not its spec.** Each keeps its own structure and moves onto `DocsSection`, `DocsSnippet`, `DocsDisclosure` and `DocsTable`, so the typography, code rendering, disclosure behaviour and tables match every component page. **Do not force a `ComponentDocSpec` onto them.**

**Batching:** two tasks, **Sonnet**.

### Task 33: Reference pages — `cli`, `registry`, `typeset`

- [ ] **Step 1:** For each, replace every hand-rolled code block with `DocsSnippet`, every hand-rolled table with `DocsTable`, and every collapsible with `DocsDisclosure`.
- [ ] **Step 2:** `cli` documents commands — every command shown must be one the CLI actually accepts. Verify each against `packages/elattar_cli/` and report any that are not.
- [ ] **Step 3:** `typeset` renders type specimens — it may legitimately reference uppercase roles as *subject matter*. The uppercase guard skips comment lines only, so if a specimen must name `Type.label`, keep it in a string or a comment and say so in the report; do not weaken the guard.
- [ ] **Step 4:** Run `test/docs`, the guards, the analyzer, and each page's own test.
- [ ] **Step 5:** Commit.

### Task 34: Narrative pages — `introduction`, `installation`, `theming`, `changelog`

- [ ] **Step 1:** Same substitution as Task 33.
- [ ] **Step 2:** `installation` and `theming` carry long code blocks — use `DocsSnippet` with a `maxHeight` so a page is not one endless listing, and confirm the expansion control works.
- [ ] **Step 3:** `changelog` is generated from `changelog_document.dart` — change the rendering, never the document.
- [ ] **Step 4:** Run the same checks as Task 33.
- [ ] **Step 5:** Commit.

### Task 35: Final gate

- [ ] **Step 1:** Run the complete ladder from the repository root and from `example/`:

```bash
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=final ft root analyze"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=final ft root test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=final ft example analyze lib test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=final ft example test"
```

- [ ] **Step 2:** Build and capture:

```bash
cd example && MSYS_NO_PATHCONV=1 flutter build web --release --base-href /flutter-design-system/
rm -rf /c/elx/a && mkdir -p /c/elx/a
cp -r build/web /c/elx/a/flutter-design-system
cd /c/elx/a && python -m http.server 8331
```

Capture a sample of ten pages across the families at 1440 dark, 1440 light and 390 dark, using `tool/verify/capture.js` and `tool/verify/shot.js`. `capture.js` needs `--nav domcontentloaded` for any page rendering `Alert`.

- [ ] **Step 3:** Write `docs/superpowers/reports/docs-kit/full-rollout-review.md` recording the commit, the commands actually run with exit codes, the measured page count, the captures, and every limitation. Commit it with `git add -f` — a bare `reports/` pattern in `.gitignore` over-matches that directory, and 20 sibling reports are already tracked there.

---

## Execution notes

- **Model:** Sonnet for every implementation and review subagent. The work is mechanical against a worked reference; it does not need a larger model.
- **Concurrency:** at most two implementation subagents at once, on disjoint directories, each with its own `FT_ID`. More than two and the review queue becomes the bottleneck.
- **Between tasks:** review each batch against the brief and the shape guard before dispatching the next. Do not batch reviews.
- **Do not run the 17-minute `test/components_docs` suite per page.** Once per batch, at the end.

## Out of scope

- Any change under `lib/src/`, and any foundation token.
- `example/lib/pages/` — the gallery every `/design-system/...` route already falls back away from.
- Changing the registry, the CLI, or what either ships.
- Publishing: no tag, no release, no Pages deploy, no `dart pub publish` without `--dry-run`.

## Open decision for the owner, before Phase B

The Button page stands 17,925px tall because every stage is 640 minimum. Task 1 makes the height per-section, but **someone must decide the default.** Options: keep 640 and set a smaller `minHeight` per section by hand (54 pages of judgement calls); or change `DocsShowcase.tallMinHeight` to something like `el(96)` = 384 and let tall specimens opt up. The second is one line and makes the other 98 pages cheaper. It is a design change to an approved decision, so it is the owner's call, and it should be made before Phase B rather than retrofitted across 54 pages.
