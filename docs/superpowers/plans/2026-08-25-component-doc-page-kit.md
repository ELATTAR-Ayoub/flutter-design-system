# Component documentation page kit — implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build eleven documentation components in `example/lib/docs/`, then rebuild `/components/button` entirely from them, so the remaining component pages become declarations rather than layout.

**Architecture:** Every repeated piece of a documentation page becomes a named component. A page file declares a `ComponentDocSpec` — an ordered list of four section kinds — and `ComponentDocPage` renders it. Presentation lives in the kit; pages carry only content. Nothing under `lib/src/` changes.

**Tech Stack:** Flutter 3.44.8, Dart 3.12.2, `package:elattar_design_system` public barrel only.

**Spec:** [`2026-08-25-component-doc-page-kit-design.md`](../specs/2026-08-25-component-doc-page-kit-design.md)

## Global Constraints

Every task's requirements implicitly include this section.

- **Repository mode.** `lib/elattar_design_system.dart` exists, no `elattar.yaml`. All paths below are repository-mode names.
- **Import the system through the public barrel only:** `package:elattar_design_system/elattar_design_system.dart`. Never reach into `lib/src/`.
- **No visual literals in `example/lib/`.** Geometry from `el(...)`, `Widths`, `Containers`, `Breakpoints`; colour from `Theme.of(context)`; type from `Text`/`Type`; timing from `Durations`/`Curves`. `test/token_guard_test.dart` fails the build otherwise. A bare `0` or `0.0` is legal.
- **No uppercase type roles** anywhere under `example/lib/docs/` or `example/lib/components_docs/`. The forbidden roles are `Type.label`, `Type.micro`, `Type.tag`, `Type.badge`, `Type.serial`, `Type.inputSerial`, `Type.buttonLabelCaps`. Use `Type.caption`, `Type.small`, `Type.textSm` instead. Never call `String.toUpperCase()`.
- **Product code only.** Everything created here lives in `example/lib/docs/`. Nothing is added to `lib/src/components/`.
- **`pumpAndSettle` is forbidden** in any test that pumps a widget tree containing `Alert`, `BloomCosmic`, or a documentation page. Those controllers `repeat(reverse: true)` forever. Use `tester.pump()`.
- **Test view sizing** uses `tester.view.physicalSize` + `tester.view.devicePixelRatio` with `addTearDown(tester.view.reset)`, never a synthetic `MediaQuery`. This matches `example/test/components_docs/alert_test.dart`.
- **Run from `example/`** for every command in this plan unless the command says otherwise.
- **Commit after every task.** Never combine two tasks in one commit.

---

## File structure

**Create — the kit** (all under `example/lib/docs/`):

| File | Responsibility |
| --- | --- |
| `docs_copy_button.dart` | `DocsCopyButton` — secondary icon button, idle/pending/copied |
| `docs_snippet.dart` | `DocsSnippet`, `DocsSnippetOverflow` — the one code renderer |
| `docs_section.dart` | `DocsAnchor`, `DocsSection` — anchor machinery and section presentation |
| `docs_showcase.dart` | `DocsShowcaseFrame`, `DocsShowcase` — 640 specimen frame, Preview↔Code |
| `docs_disclosure.dart` | `DocsDisclosure` — collapsed-by-default text/table section |
| `docs_table.dart` | `DocsTable`, `DocsApiTable` — `Table`-backed, full width |
| `docs_install.dart` | `DocsInstall` — CLI↔Manual toggle |
| `component_doc_page.dart` | `DocsSection*` spec model, `DocsPageHeader`, `ComponentDocPage` |

**Modify:**

| File | Change |
| --- | --- |
| `example/lib/kit.dart:142-227` | `Section` becomes `DocsAnchor` + `DocsSection` composed |
| `example/lib/docs/docs_layout.dart:315` | rail max height stops running past the fold |
| `example/lib/docs/docs_facts.dart` | `DocsApiTable` removed; re-exported from `docs_table.dart` |
| `example/lib/docs/docs_code.dart` | `DocsSelectableCodeBlock` and its tokenizer removed |
| `example/lib/components_docs/button/page.dart` | rebuilt as a `ComponentDocSpec` |

**Create — tests** (all under `example/test/docs/` except where noted):

`docs_copy_button_test.dart`, `docs_snippet_test.dart`, `docs_section_test.dart`, `docs_showcase_test.dart`, `docs_disclosure_test.dart`, `docs_table_test.dart`, `docs_install_test.dart`, `component_doc_page_test.dart`, `docs_no_uppercase_test.dart`, `docs_rail_height_test.dart`.

---

### Task 1: DocsCopyButton

**Files:**
- Create: `example/lib/docs/docs_copy_button.dart`
- Test: `example/test/docs/docs_copy_button_test.dart`

**Interfaces:**
- Consumes: nothing from earlier tasks.
- Produces: `class DocsCopyButton extends StatefulWidget` with
  `const DocsCopyButton({super.key, required String text, Future<void> Function(String)? writer, String copyLabel = 'Copy code', String copiedLabel = 'Copied'})`.
  Tasks 2 and 7 embed it.

- [ ] **Step 1: Write the failing test**

```dart
// example/test/docs/docs_copy_button_test.dart
/// The copy control, which is the only affordance on a snippet.
///
/// No `pumpAndSettle`: the confirmation is a timed state and settling would
/// wait for it rather than observe it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_copy_button.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: Theme(
      controller: ThemeController(mode: ThemeMode.dark),
      child: Center(child: child),
    ),
  ),
);

void main() {
  testWidgets('it is a secondary icon button showing the copy glyph', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_host(const DocsCopyButton(text: 'const a = 1;')));
    await tester.pump();

    final Button button = tester.widget<Button>(find.byType(Button));
    expect(button.variant, ButtonVariant.secondary);
    expect(button.size, ButtonSize.iconSm);
    expect(button.label, 'Copy code');
    expect(
      tester.widget<Icon>(find.byType(Icon)).lucide,
      Lucide.copy,
    );
  });

  testWidgets('pressing it writes the exact text and confirms', (
    WidgetTester tester,
  ) async {
    final List<String> written = <String>[];
    await tester.pumpWidget(
      _host(
        DocsCopyButton(
          text: 'const a = 1;',
          writer: (String value) async => written.add(value),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(Button));
    await tester.pump();
    await tester.pump();

    expect(written, <String>['const a = 1;']);
    expect(
      tester.widget<Icon>(find.byType(Icon)).lucide,
      Lucide.check,
      reason: 'the glyph must confirm, or a copy is indistinguishable '
          'from a mis-tap',
    );
    expect(tester.widget<Button>(find.byType(Button)).label, 'Copied');
  });

  testWidgets('the confirmation reverts', (WidgetTester tester) async {
    await tester.pumpWidget(
      _host(
        DocsCopyButton(
          text: 'x',
          writer: (String value) async {},
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byType(Button));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    expect(tester.widget<Icon>(find.byType(Icon)).lucide, Lucide.copy);
  });
}
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `flutter test test/docs/docs_copy_button_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:example/docs/docs_copy_button.dart'`.

- [ ] **Step 3: Implement the minimal component**

```dart
// example/lib/docs/docs_copy_button.dart
/// The copy control every documentation snippet and command carries.
///
/// Secondary rather than ghost: on a code surface a ghost control is nearly
/// invisible against the block it sits on, and this is the only affordance
/// the block has.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Writes [text] to the clipboard.
typedef DocsClipboardWriter = Future<void> Function(String text);

Future<void> _systemWrite(String text) =>
    Clipboard.setData(ClipboardData(text: text));

class DocsCopyButton extends StatefulWidget {
  const DocsCopyButton({
    super.key,
    required this.text,
    this.writer,
    this.copyLabel = 'Copy code',
    this.copiedLabel = 'Copied',
  });

  /// The exact characters the clipboard receives. Never a re-rendering of the
  /// displayed code: what a reader copies must be what a compiler accepts.
  final String text;

  /// Injected so a test can observe the write without a platform channel.
  final DocsClipboardWriter? writer;

  /// The accessible name at rest. Nothing but the glyph distinguishes a copy
  /// from a mis-tap, so the name carries the state.
  final String copyLabel;

  /// The accessible name while confirming.
  final String copiedLabel;

  /// How long the confirmation holds before reverting.
  static const Duration confirmation = Duration(seconds: 2);

  @override
  State<DocsCopyButton> createState() => _DocsCopyButtonState();
}

class _DocsCopyButtonState extends State<DocsCopyButton> {
  bool _pending = false;
  bool _copied = false;

  Future<void> _copy() async {
    if (_pending) return;
    setState(() => _pending = true);
    await (widget.writer ?? _systemWrite)(widget.text);
    if (!mounted) return;
    setState(() {
      _pending = false;
      _copied = true;
    });
    await Future<void>.delayed(DocsCopyButton.confirmation);
    if (!mounted) return;
    setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final LucideGlyph glyph = switch ((_pending, _copied)) {
      (true, _) => Lucide.loaderCircle,
      (_, true) => Lucide.check,
      _ => Lucide.copy,
    };
    return Button(
      variant: ButtonVariant.secondary,
      size: ButtonSize.iconSm,
      label: _copied ? widget.copiedLabel : widget.copyLabel,
      onPressed: _pending ? null : _copy,
      child: Icon.lucide(glyph, size: IconSize.sm),
    );
  }
}
```

- [ ] **Step 4: Run the tests and make sure they pass**

Run: `flutter test test/docs/docs_copy_button_test.dart`
Expected: PASS, 3 tests.

- [ ] **Step 5: Commit**

```bash
git add example/lib/docs/docs_copy_button.dart example/test/docs/docs_copy_button_test.dart
git commit -m "feat(docs): add the secondary copy control the kit shares"
```

---

### Task 2: DocsSnippet and DocsSnippetOverflow

The docs carry their own tokenizer (`_DsCodeTokenKind` in `docs_code.dart`), a second and weaker syntax theme. The agent family already ships the real one — `AgentCodeBlock` over `PrismPalette`, VS Code Dark Plus as `react-syntax-highlighter` writes it. This task makes that the only code renderer.

**Files:**
- Create: `example/lib/docs/docs_snippet.dart`
- Test: `example/test/docs/docs_snippet_test.dart`

**Interfaces:**
- Consumes: `DocsCopyButton` from Task 1.
- Produces:
  - `class DocsSnippet extends StatelessWidget` with `const DocsSnippet({super.key, required String code, String language = 'dart', double? maxHeight})`.
  - `class DocsSnippetOverflow extends StatefulWidget` with `const DocsSnippetOverflow({super.key, required double maxHeight, required Widget child, String showMoreLabel = 'Show more', String showLessLabel = 'Show less'})`.

  Tasks 4, 7 and 8 embed `DocsSnippet`.

- [ ] **Step 1: Write the failing test**

```dart
// example/test/docs/docs_snippet_test.dart
/// The one code renderer.
///
/// The assertion that matters is the *identity* of the renderer: the docs are
/// not allowed a second syntax theme, so this pins `AgentCodeBlock` rather
/// than pinning colours.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_copy_button.dart';
import 'package:example/docs/docs_snippet.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: Theme(
      controller: ThemeController(mode: ThemeMode.dark),
      child: Center(child: child),
    ),
  ),
);

const String _long =
    'void main() {\n'
    '  final int a = 1;\n'
    '  final int b = 2;\n'
    '  final int c = 3;\n'
    '  final int d = 4;\n'
    '  final int e = 5;\n'
    '  final int f = 6;\n'
    '  final int g = 7;\n'
    '  final int h = 8;\n'
    '}';

void main() {
  testWidgets('it renders through the agent code block, not a second theme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(const SizedBox(width: 640, child: DocsSnippet(code: 'final a = 1;'))),
    );
    await tester.pump();

    final AgentCodeBlock block = tester.widget<AgentCodeBlock>(
      find.byType(AgentCodeBlock),
    );
    expect(block.code, 'final a = 1;');
    expect(block.language, 'dart');
  });

  testWidgets('it carries exactly one copy control, holding the source', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(const SizedBox(width: 640, child: DocsSnippet(code: 'final a = 1;'))),
    );
    await tester.pump();

    expect(find.byType(DocsCopyButton), findsOneWidget);
    expect(
      tester.widget<DocsCopyButton>(find.byType(DocsCopyButton)).text,
      'final a = 1;',
    );
  });

  testWidgets('an uncapped snippet has no expansion control', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(const SizedBox(width: 640, child: DocsSnippet(code: _long))),
    );
    await tester.pump();

    expect(find.byType(DocsSnippetOverflow), findsNothing);
  });

  testWidgets('a capped snippet expands and collapses', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 640,
          child: DocsSnippet(code: _long, maxHeight: el(20)),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Show more'), findsOneWidget);
    final double collapsed = tester.getSize(find.byType(DocsSnippet)).height;

    await tester.tap(find.text('Show more'));
    await tester.pump();
    await tester.pump(Durations.jelly);

    expect(find.text('Show less'), findsOneWidget);
    expect(
      tester.getSize(find.byType(DocsSnippet)).height,
      greaterThan(collapsed),
    );
  });
}
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `flutter test test/docs/docs_snippet_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:example/docs/docs_snippet.dart'`.

- [ ] **Step 3: Implement the minimal component**

```dart
// example/lib/docs/docs_snippet.dart
/// The only code renderer in the documentation.
///
/// The docs used to carry their own tokenizer. The agent family already
/// shipped the real VS Code Dark Plus palette — `AgentCodeBlock` over
/// `PrismPalette` — so there is one syntax theme on the site and it is that
/// one. A second one is a second thing to keep true.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import 'docs_copy_button.dart';

class DocsSnippet extends StatelessWidget {
  const DocsSnippet({
    super.key,
    required this.code,
    this.language = 'dart',
    this.maxHeight,
  });

  /// The source, verbatim. What is displayed and what is copied are the same
  /// string, read from the same field.
  final String code;

  /// A language `AgentCodeBlock.normalise` recognises. An unrecognised one
  /// renders un-highlighted rather than failing.
  final String language;

  /// When set, the body is clipped to this height with an expansion control.
  /// Null leaves the block at its natural height.
  final double? maxHeight;

  /// The copy control's inset from the block's top-right corner.
  static double get controlInset => el(2);

  @override
  Widget build(BuildContext context) {
    final Widget block = AgentCodeBlock(code: code, language: language);
    final double? cap = maxHeight;

    return Stack(
      children: <Widget>[
        if (cap == null)
          block
        else
          DocsSnippetOverflow(maxHeight: cap, child: block),
        Positioned(
          top: controlInset,
          right: controlInset,
          child: DocsCopyButton(text: code),
        ),
      ],
    );
  }
}

/// Clips [child] to [maxHeight] and offers to unfold it.
///
/// Separate from [DocsSnippet] because the showcase caps its code pane at the
/// same 640 the preview uses, while a Usage snippet is never capped — the same
/// clipping behaviour, two different callers.
class DocsSnippetOverflow extends StatefulWidget {
  const DocsSnippetOverflow({
    super.key,
    required this.maxHeight,
    required this.child,
    this.showMoreLabel = 'Show more',
    this.showLessLabel = 'Show less',
  });

  final double maxHeight;
  final Widget child;
  final String showMoreLabel;
  final String showLessLabel;

  @override
  State<DocsSnippetOverflow> createState() => _DocsSnippetOverflowState();
}

class _DocsSnippetOverflowState extends State<DocsSnippetOverflow> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (_open)
          widget.child
        else
          ClipRect(
            child: SizedBox(
              height: widget.maxHeight,
              child: OverflowBox(
                alignment: Alignment.topLeft,
                maxHeight: double.infinity,
                child: widget.child,
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: el(2)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Button(
              variant: ButtonVariant.ghost,
              size: ButtonSize.sm,
              onPressed: () => setState(() => _open = !_open),
              child: Text(
                _open ? widget.showLessLabel : widget.showMoreLabel,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run the tests and make sure they pass**

Run: `flutter test test/docs/docs_snippet_test.dart`
Expected: PASS, 4 tests.

- [ ] **Step 5: Run the token guard**

Run (from the repository root): `flutter test test/token_guard_test.dart`
Expected: PASS. If it fails, a raw number reached `example/lib/` — replace it with `el(...)`.

- [ ] **Step 6: Commit**

```bash
git add example/lib/docs/docs_snippet.dart example/test/docs/docs_snippet_test.dart
git commit -m "feat(docs): render every snippet through the agent's VS Code palette"
```

---

### Task 3: DocsAnchor and DocsSection

`Section` currently does two unrelated jobs — it owns the anchor registry the table of contents scrolls to, and it renders a section's heading. 92 files call it. Splitting the two lets the presentation be rebuilt without touching 92 call sites: `Section` becomes the two composed.

The presentation change: the description stops being capped at a private `_measure2xl` measure, so a section fills its column with no trailing gap.

**Files:**
- Create: `example/lib/docs/docs_section.dart`
- Modify: `example/lib/kit.dart:142-227`
- Test: `example/test/docs/docs_section_test.dart`

**Interfaces:**
- Consumes: nothing from earlier tasks.
- Produces:
  - `class DocsAnchor extends StatelessWidget` with `const DocsAnchor({super.key, required String id, required Widget child})`, plus `static GlobalKey<State<StatefulWidget>> keyFor(String id)` and `static Future<void> scrollTo(String id)`.
  - `class DocsSection extends StatelessWidget` with `const DocsSection({super.key, required String id, required String title, String? description, required Widget child})`.

  Task 8 composes `DocsSection`. `Section.anchorKey` and `Section.scrollTo` keep working by forwarding, because `docs_layout.dart` calls both.

- [ ] **Step 1: Write the failing test**

```dart
// example/test/docs/docs_section_test.dart
/// The section heading, and the anchor the table of contents scrolls to.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_section.dart';
import 'package:example/kit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: Theme(
      controller: ThemeController(mode: ThemeMode.dark),
      child: child,
    ),
  ),
);

void main() {
  testWidgets('the description fills the column rather than a private cap', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsSection(
            id: 'variants',
            title: 'Variants',
            description: 'Seven of them.',
            child: SizedBox(height: 10, width: double.infinity),
          ),
        ),
      ),
    );
    await tester.pump();

    // The section is as wide as the column it was given. A capped description
    // used to leave a gap on the right of every section on the page.
    expect(tester.getSize(find.byType(DocsSection)).width, 640);
  });

  testWidgets('it uses no uppercase type role', (WidgetTester tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsSection(
            id: 'a',
            title: 'Title',
            description: 'Description.',
            child: SizedBox.shrink(),
          ),
        ),
      ),
    );
    await tester.pump();

    for (final Text text in tester.widgetList<Text>(find.byType(Text))) {
      expect(
        text.spec.uppercase,
        isFalse,
        reason: '"${text.text}" renders through an uppercase role',
      );
    }
  });

  testWidgets('the anchor registry is shared with Section', (
    WidgetTester tester,
  ) async {
    // `docs_layout.dart` scrolls by `Section.anchorKey`. If the split gave
    // the two classes separate registries, every table-of-contents link on
    // the site would silently stop working.
    expect(DocsAnchor.keyFor('shared'), same(Section.anchorKey('shared')));
  });
}
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `flutter test test/docs/docs_section_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:example/docs/docs_section.dart'`.

- [ ] **Step 3: Write `docs_section.dart`**

```dart
// example/lib/docs/docs_section.dart
/// A documentation section, and the anchor a table of contents scrolls to.
///
/// These were one class. They are two because 92 files call the old one and
/// only its presentation is being rebuilt: keeping the anchor registry
/// separate means the rebuild touches no call site.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

/// Registers [child] under [id] so [scrollTo] can find it later.
class DocsAnchor extends StatelessWidget {
  const DocsAnchor({super.key, required this.id, required this.child});

  final String id;
  final Widget child;

  /// One key per id, kept so a later lookup finds the same object.
  ///
  /// Not a `GlobalObjectKey`: its equality is identity on the value, and two
  /// interpolated strings with the same characters are not the same object —
  /// the lookup would silently miss.
  static final Map<String, GlobalKey<State<StatefulWidget>>> _keys =
      <String, GlobalKey<State<StatefulWidget>>>{};

  static GlobalKey<State<StatefulWidget>> keyFor(String id) =>
      _keys.putIfAbsent(id, () => GlobalKey<State<StatefulWidget>>());

  /// Scrolls to the section registered under [id], resting
  /// `Widths.scrollOffset` below the viewport top.
  static Future<void> scrollTo(String id) async {
    final BuildContext? target = keyFor(id).currentContext;
    if (target == null) return;
    final ScrollableState? scrollable = Scrollable.maybeOf(target);
    if (scrollable == null) return;

    final RenderObject? box = target.findRenderObject();
    final RenderObject? viewport = scrollable.context.findRenderObject();
    if (box is! RenderBox || viewport is! RenderBox) return;

    final double delta =
        box.localToGlobal(Offset.zero, ancestor: viewport).dy -
        Widths.scrollOffset;
    final ScrollPosition position = scrollable.position;
    await position.animateTo(
      (position.pixels + delta).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      ),
      duration: elAnimationDuration(target, Durations.slow),
      curve: Curves.inOut,
    );
  }

  @override
  Widget build(BuildContext context) =>
      KeyedSubtree(key: keyFor(id), child: child);
}

/// A titled section of a documentation page.
class DocsSection extends StatelessWidget {
  const DocsSection({
    super.key,
    required this.id,
    required this.title,
    this.description,
    required this.child,
  });

  final String id;
  final String title;
  final String? description;
  final Widget child;

  /// The gap under the whole section.
  static double get spacing => el(20);

  /// The gap between the heading block and the section's body.
  static double get headingGap => el(6);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DocsAnchor(
      id: id,
      child: Padding(
        padding: EdgeInsets.only(bottom: spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: headingGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // An `h2` wearing `.type-h3`, intentionally.
                  Text(title, Type.h3, color: theme.foreground),
                  if (description != null) ...<Widget>[
                    SizedBox(height: el(2)),
                    // Full width. The old private measure cap left a gap on
                    // the right of every section.
                    Text(description!, Type.small),
                  ],
                ],
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Make `Section` the two composed**

Replace the whole `Section` class body in `example/lib/kit.dart` (lines 142-227) with:

```dart
/// The documentation section heading.
///
/// Kept as a name because 92 files call it. Its two jobs now live in
/// `docs/docs_section.dart`: [DocsAnchor] owns the anchor registry the table
/// of contents scrolls to, [DocsSection] owns the presentation.
class Section extends StatelessWidget {
  const Section({
    super.key,
    required this.id,
    required this.title,
    this.description,
    required this.child,
  });

  final String id;
  final String title;
  final String? description;
  final Widget child;

  /// Forwarded so `docs_layout.dart` keeps one anchor registry.
  static GlobalKey<State<StatefulWidget>> anchorKey(String id) =>
      DocsAnchor.keyFor(id);

  static Future<void> scrollTo(String id) => DocsAnchor.scrollTo(id);

  @override
  Widget build(BuildContext context) => DocsSection(
    id: id,
    title: title,
    description: description,
    child: child,
  );
}
```

Add `import 'docs/docs_section.dart';` to the imports at the top of `kit.dart`, and delete the now-unused `_measure2xl` constant if nothing else references it (`rg -n "_measure2xl" example/lib`).

- [ ] **Step 5: Run the tests and make sure they pass**

Run: `flutter test test/docs/docs_section_test.dart`
Expected: PASS, 3 tests.

- [ ] **Step 6: Run the pages that depend on the old behaviour**

Run: `flutter test test/components_docs`
Expected: PASS. A failure here means a page asserted the capped description width. Fix the assertion, not the component — the cap was the defect.

- [ ] **Step 7: Commit**

```bash
git add example/lib/docs/docs_section.dart example/lib/kit.dart example/test/docs/docs_section_test.dart
git commit -m "refactor(docs): split Section into its anchor and its presentation"
```

---

### Task 4: DocsShowcaseFrame and DocsShowcase

**Files:**
- Create: `example/lib/docs/docs_showcase.dart`
- Test: `example/test/docs/docs_showcase_test.dart`

**Interfaces:**
- Consumes: `DocsSnippet` from Task 2.
- Produces:
  - `class DocsShowcaseFrame extends StatelessWidget` with `const DocsShowcaseFrame({super.key, required Widget child, Alignment alignment = Alignment.center})`.
  - `class DocsShowcase extends StatefulWidget` with `const DocsShowcase({super.key, required Widget specimen, required String code, Alignment alignment = Alignment.center})`, plus `static double minHeightFor(double viewportWidth)`.

  Task 8 embeds `DocsShowcase`.

- [ ] **Step 1: Write the failing test**

```dart
// example/test/docs/docs_showcase_test.dart
/// The specimen frame — the component a reader sees most.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_showcase.dart';
import 'package:example/docs/docs_snippet.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: Theme(
    controller: ThemeController(mode: ThemeMode.dark),
    child: child,
  ),
);

Widget _showcase() => const DocsShowcase(
  specimen: SizedBox(height: 40, width: 120),
  code: 'const SizedBox(height: 40, width: 120)',
);

void main() {
  testWidgets('it stands 640 tall at a wide viewport', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(_showcase()));
    await tester.pump();

    expect(
      tester.getSize(find.byType(DocsShowcaseFrame)).height,
      greaterThanOrEqualTo(el(160)),
    );
  });

  testWidgets('it relaxes to 384 below the sm breakpoint', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(_showcase()));
    await tester.pump();

    final double height = tester.getSize(find.byType(DocsShowcaseFrame)).height;
    expect(height, greaterThanOrEqualTo(el(96)));
    expect(
      height,
      lessThan(el(160)),
      reason: '640 is taller than a phone viewport minus header and toggle',
    );
  });

  testWidgets('it opens on the preview and shows no code', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(_showcase()));
    await tester.pump();

    expect(find.byType(DocsSnippet), findsNothing);
    expect(
      tester.widget<ToggleGroup>(find.byType(ToggleGroup)).selectedIndex,
      0,
    );
  });

  testWidgets('the toggle swaps the preview for the code', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(_showcase()));
    await tester.pump();

    await tester.tap(find.text('Code'));
    await tester.pump();

    expect(find.byType(DocsSnippet), findsOneWidget);
    expect(
      tester.widget<DocsSnippet>(find.byType(DocsSnippet)).code,
      'const SizedBox(height: 40, width: 120)',
    );
  });

  testWidgets('two showcases keep separate selections', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        Column(
          children: <Widget>[
            _showcase(),
            _showcase(),
          ],
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Code').first);
    await tester.pump();

    // One switched; the other did not.
    expect(find.byType(DocsSnippet), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `flutter test test/docs/docs_showcase_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:example/docs/docs_showcase.dart'`.

- [ ] **Step 3: Implement the minimal component**

```dart
// example/lib/docs/docs_showcase.dart
/// The specimen frame, and the Preview↔Code toggle over it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import 'docs_snippet.dart';

/// The neutral stage a specimen is judged on.
///
/// Separate from [DocsShowcase] so a specimen that needs its own alignment —
/// a full-width bar, a stacked group — can use the stage without the toggle.
class DocsShowcaseFrame extends StatelessWidget {
  const DocsShowcaseFrame({
    super.key,
    required this.child,
    this.alignment = Alignment.center,
    required this.minHeight,
  });

  final Widget child;
  final Alignment alignment;
  final double minHeight;

  /// The stage's inner padding, so a specimen never touches the border.
  static double get padding => el(6);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: theme.background,
        border: Border.all(color: theme.border, width: Widths.hairline),
        borderRadius: BorderRadius.circular(Radii.lg),
      ),
      child: Align(alignment: alignment, child: child),
    );
  }
}

/// A specimen and its source, one visible at a time.
class DocsShowcase extends StatefulWidget {
  const DocsShowcase({
    super.key,
    required this.specimen,
    required this.code,
    this.alignment = Alignment.center,
  });

  /// The live component, rendered in the Preview pane.
  final Widget specimen;

  /// The source that produces [specimen], rendered in the Code pane.
  final String code;

  final Alignment alignment;

  /// The stage height. 640 is the reading column's own measure, and a
  /// specimen judged in a shorter box reads as cramped.
  static double get tallMinHeight => el(160);

  /// Below `Breakpoints.sm` a 640 stage is taller than the whole viewport
  /// minus header and toggle, which would push the control off screen.
  static double get shortMinHeight => el(96);

  static double minHeightFor(double viewportWidth) =>
      viewportWidth < Breakpoints.sm ? shortMinHeight : tallMinHeight;

  @override
  State<DocsShowcase> createState() => _DocsShowcaseState();
}

class _DocsShowcaseState extends State<DocsShowcase> {
  /// Per instance, not per page: a reader who opens the code for one variant
  /// has said nothing about the next one.
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final double minHeight = DocsShowcase.minHeightFor(
      MediaQuery.sizeOf(context).width,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: ToggleGroup(
            label: 'Specimen view',
            items: const <ToggleGroupItem>[
              ToggleGroupItem(label: 'Preview'),
              ToggleGroupItem(label: 'Code'),
            ],
            selectedIndex: _selected,
            // Null means the tapped option was already selected. A view
            // toggle has no deselected state, so that is a no-op here.
            onChanged: (int? index) =>
                setState(() => _selected = index ?? _selected),
          ),
        ),
        SizedBox(height: el(3)),
        if (_selected == 0)
          DocsShowcaseFrame(
            alignment: widget.alignment,
            minHeight: minHeight,
            child: widget.specimen,
          )
        else
          DocsSnippet(code: widget.code, maxHeight: minHeight),
      ],
    );
  }
}
```

- [ ] **Step 4: Run the tests and make sure they pass**

Run: `flutter test test/docs/docs_showcase_test.dart`
Expected: PASS, 5 tests.

- [ ] **Step 5: Run the token guard**

Run (from the repository root): `flutter test test/token_guard_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add example/lib/docs/docs_showcase.dart example/test/docs/docs_showcase_test.dart
git commit -m "feat(docs): add the 640 specimen stage and its preview/code toggle"
```

---

### Task 5: DocsDisclosure

**Files:**
- Create: `example/lib/docs/docs_disclosure.dart`
- Test: `example/test/docs/docs_disclosure_test.dart`

**Interfaces:**
- Consumes: nothing from earlier tasks.
- Produces: `class DocsDisclosure extends StatefulWidget` with `const DocsDisclosure({super.key, required String title, required Widget child, bool initiallyOpen = false})`.

  Task 8 embeds it.

- [ ] **Step 1: Write the failing test**

```dart
// example/test/docs/docs_disclosure_test.dart
/// The collapsible every text-or-table section uses.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: Theme(
      controller: ThemeController(mode: ThemeMode.dark),
      child: child,
    ),
  ),
);

void main() {
  testWidgets('it is closed, and its content is not in the tree', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsDisclosure(
            title: 'API reference',
            child: Text('the table'),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('API reference'), findsOneWidget);
    expect(
      find.text('the table'),
      findsNothing,
      reason: 'a closed disclosure must not render its content',
    );
  });

  testWidgets('the whole title row is the control and it fills the width', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsDisclosure(title: 'Theming', child: Text('body')),
        ),
      ),
    );
    await tester.pump();

    expect(
      tester.getSize(find.byKey(DocsDisclosure.triggerKey)).width,
      640,
      reason: 'the trigger is the full column, not a text-width hit target',
    );

    await tester.tap(find.byKey(DocsDisclosure.triggerKey));
    await tester.pump();
    await tester.pump(Durations.jelly);
    expect(find.text('body'), findsOneWidget);
  });

  testWidgets('the chevron sits hard right and rotates on open', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsDisclosure(title: 'Source', child: Text('body')),
        ),
      ),
    );
    await tester.pump();

    expect(
      tester.widget<Icon>(find.byType(Icon)).lucide,
      Lucide.chevronDown,
    );
    final double closed = tester
        .widget<RotationTransition>(find.byType(RotationTransition))
        .turns
        .value;

    await tester.tap(find.byKey(DocsDisclosure.triggerKey));
    await tester.pump();
    await tester.pump(Durations.jelly);

    expect(
      tester
          .widget<RotationTransition>(find.byType(RotationTransition))
          .turns
          .value,
      isNot(closed),
    );
  });

  testWidgets('it uses no uppercase type role', (WidgetTester tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsDisclosure(title: 'Dependencies', child: Text('body')),
        ),
      ),
    );
    await tester.pump();

    for (final Text text in tester.widgetList<Text>(find.byType(Text))) {
      expect(text.spec.uppercase, isFalse, reason: text.text);
    }
  });
}
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `flutter test test/docs/docs_disclosure_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:example/docs/docs_disclosure.dart'`.

- [ ] **Step 3: Implement the minimal component**

```dart
// example/lib/docs/docs_disclosure.dart
/// The collapsible every text-or-table section of a documentation page uses.
///
/// Closed by default, including the API reference. A component page is read
/// for its specimens; the reference is what you open when you have a
/// question, and eight open reference tables between you and the next
/// specimen is not a page anybody scrolls.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

class DocsDisclosure extends StatefulWidget {
  const DocsDisclosure({
    super.key,
    required this.title,
    required this.child,
    this.initiallyOpen = false,
  });

  final String title;
  final Widget child;
  final bool initiallyOpen;

  /// The trigger row, so a test can measure and activate the real control
  /// rather than the text inside it.
  static const ValueKey<String> triggerKey = ValueKey<String>(
    'docs-disclosure-trigger',
  );

  /// The trigger row's height.
  static double get triggerHeight => el(12);

  /// A half turn: chevron down closed, chevron up open.
  static const double openTurns = 0.5;

  @override
  State<DocsDisclosure> createState() => _DocsDisclosureState();
}

class _DocsDisclosureState extends State<DocsDisclosure>
    with SingleTickerProviderStateMixin {
  late bool _open = widget.initiallyOpen;

  late final AnimationController _chevron = AnimationController(
    vsync: this,
    duration: Durations.base,
    value: _open ? 1 : 0,
  );

  late final Animation<double> _turns = Tween<double>(
    begin: 0,
    end: DocsDisclosure.openTurns,
  ).animate(CurvedAnimation(parent: _chevron, curve: Curves.inOut));

  @override
  void dispose() {
    _chevron.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    if (_open) {
      _chevron.forward();
    } else {
      _chevron.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Collapsible(
      open: _open,
      trigger: Semantics(
        button: true,
        expanded: _open,
        label: widget.title,
        child: GestureDetector(
          key: DocsDisclosure.triggerKey,
          behavior: HitTestBehavior.opaque,
          onTap: _toggle,
          child: SizedBox(
            width: double.infinity,
            height: DocsDisclosure.triggerHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(widget.title, Type.h4, color: theme.foreground),
                RotationTransition(
                  turns: _turns,
                  child: Icon.lucide(
                    Lucide.chevronDown,
                    size: IconSize.md,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      content: Padding(
        padding: EdgeInsets.only(top: el(4)),
        child: widget.child,
      ),
    );
  }
}
```

- [ ] **Step 4: Run the tests and make sure they pass**

Run: `flutter test test/docs/docs_disclosure_test.dart`
Expected: PASS, 4 tests.

If the first test fails because `Collapsible` keeps its content mounted while closed, wrap `content` in `Offstage(offstage: !_open, child: ...)` — a closed section's table must not cost layout on every page.

- [ ] **Step 5: Commit**

```bash
git add example/lib/docs/docs_disclosure.dart example/test/docs/docs_disclosure_test.dart
git commit -m "feat(docs): add the collapsed-by-default disclosure section"
```

---

### Task 6: DocsTable and DocsApiTable

**Files:**
- Create: `example/lib/docs/docs_table.dart`
- Modify: `example/lib/docs/docs_facts.dart` — delete `DocsApiTable`, `_TableHeader`, `_FactRow`, `_FactScroll`; re-export the new one
- Test: `example/test/docs/docs_table_test.dart`

**Interfaces:**
- Consumes: nothing from earlier tasks.
- Produces:
  - `class DocsTableColumn` with `const DocsTableColumn({required String header, required double flex})`.
  - `class DocsTable extends StatelessWidget` with `const DocsTable({super.key, required List<DocsTableColumn> columns, required List<List<String>> rows})`.
  - `class DocsApiTable extends StatelessWidget` with `const DocsApiTable({super.key, required List<DocsApiFact> facts})`.

  Task 8 embeds both. `DocsApiFact` is the existing model in `docs_facts.dart` and is unchanged.

- [ ] **Step 1: Write the failing test**

```dart
// example/test/docs/docs_table_test.dart
/// The tables the reference sections are made of.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_facts.dart' show DocsApiFact;
import 'package:example/docs/docs_table.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: Theme(
      controller: ThemeController(mode: ThemeMode.dark),
      child: child,
    ),
  ),
);

void main() {
  testWidgets('it is the package table, not a hand-rolled one', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsTable(
            columns: <DocsTableColumn>[
              DocsTableColumn(header: 'Property', flex: 0.3),
              DocsTableColumn(header: 'Type', flex: 0.3),
              DocsTableColumn(header: 'Purpose', flex: 0.4),
            ],
            rows: <List<String>>[
              <String>['variant', 'ButtonVariant', 'Which of the seven.'],
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(Table), findsOneWidget);
  });

  testWidgets('it fills its column with no trailing gap', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsTable(
            columns: <DocsTableColumn>[
              DocsTableColumn(header: 'A', flex: 0.5),
              DocsTableColumn(header: 'B', flex: 0.5),
            ],
            rows: <List<String>>[
              <String>['one', 'two'],
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.getSize(find.byType(Table)).width, 640);
  });

  testWidgets('the API table renders one row per fact', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsApiTable(
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'variant',
                type: 'ButtonVariant',
                description: 'Which of the seven.',
              ),
              DocsApiFact(
                name: 'size',
                type: 'ButtonSize',
                description: 'Which of the nine.',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('variant'), findsOneWidget);
    expect(find.text('size'), findsOneWidget);
  });

  testWidgets('headers use no uppercase type role', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsApiTable(
            facts: <DocsApiFact>[
              DocsApiFact(name: 'a', type: 'b', description: 'c'),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    for (final Text text in tester.widgetList<Text>(find.byType(Text))) {
      expect(text.spec.uppercase, isFalse, reason: text.text);
    }
  });
}
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `flutter test test/docs/docs_table_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:example/docs/docs_table.dart'`.

- [ ] **Step 3: Implement the minimal component**

```dart
// example/lib/docs/docs_table.dart
/// The documentation tables, on the package's own table.
///
/// These were hand-rolled rows with their own header strip. They are
/// `Table` now, so a reference table hovers, aligns and rules exactly like
/// every other table in the system — and so a fix to the table is a fix here.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import 'docs_facts.dart' show DocsApiFact;

/// One column, and the fraction of the table's width it takes.
///
/// Fractions rather than intrinsic widths: the table must fill its column
/// exactly, and an intrinsic measure leaves whatever it does not need.
class DocsTableColumn {
  const DocsTableColumn({required this.header, required this.flex});

  final String header;
  final double flex;
}

class DocsTable extends StatelessWidget {
  const DocsTable({super.key, required this.columns, required this.rows});

  final List<DocsTableColumn> columns;

  /// One list of cell strings per row, in [columns] order.
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // `Table` sizes every column to its widest cell and exposes no width
    // hook, so the table would end at its content and leave a gap. Giving
    // each cell an exact width makes "widest cell" the width we chose, and
    // the columns then sum to the container. The padding `Table` adds
    // inside each cell is subtracted first, or the sum overshoots.
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double gutters = columns.length * Table.cellPadding * 2;
        final double content = (constraints.maxWidth - gutters).clamp(
          0,
          constraints.maxWidth,
        );

        Widget sized(int column, Widget child) =>
            SizedBox(width: content * columns[column].flex, child: child);

        return Table(
          header: <TableCellSpec>[
            for (int i = 0; i < columns.length; i++)
              TableCellSpec(
                child: sized(
                  i,
                  Text(
                    columns[i].header,
                    Type.textSm,
                    color: theme.mutedForeground,
                  ),
                ),
              ),
          ],
          rows: <TableRowSpec>[
            for (final List<String> row in rows)
              TableRowSpec(
                cells: <TableCellSpec>[
                  for (int i = 0; i < row.length; i++)
                    TableCellSpec(
                      child: sized(i, Text(row[i], Type.small)),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}

/// [DocsTable] configured for an API reference. Not a second table.
class DocsApiTable extends StatelessWidget {
  const DocsApiTable({super.key, required this.facts});

  final List<DocsApiFact> facts;

  @override
  Widget build(BuildContext context) => DocsTable(
    columns: const <DocsTableColumn>[
      DocsTableColumn(header: 'Property', flex: 0.25),
      DocsTableColumn(header: 'Type', flex: 0.3),
      DocsTableColumn(header: 'Purpose', flex: 0.45),
    ],
    rows: <List<String>>[
      for (final DocsApiFact fact in facts)
        <String>[fact.name, fact.type, fact.description],
    ],
  );
}
```

The column fractions must sum to 1. `Table` has no `columnWidths`
parameter — it hardcodes `defaultColumnWidth: const TableColumnWidth()`,
which measures the widest cell. Do not add a parameter to the package
component; this is product code and sizes its own cells.

- [ ] **Step 4: Run the tests and make sure they pass**

Run: `flutter test test/docs/docs_table_test.dart`
Expected: PASS, 4 tests.

- [ ] **Step 5: Remove the hand-rolled table**

In `example/lib/docs/docs_facts.dart`, delete `DocsApiTable`, `_TableHeader`, `_FactRow`, and `_FactScroll` if nothing else uses them (`rg -n "_FactScroll|_TableHeader|_FactRow" example/lib`). Keep `DocsApiFact`, `DocsStateFact`, `DocsInstallFact`, `DocsStateMatrix`, `DocsInstallFacts`.

- [ ] **Step 6: Run the pages that used the old table**

Run: `flutter test test/components_docs`
Expected: PASS. Update any import of `DocsApiTable` to `package:example/docs/docs_table.dart`.

- [ ] **Step 7: Commit**

```bash
git add example/lib/docs/docs_table.dart example/lib/docs/docs_facts.dart example/test/docs/docs_table_test.dart
git commit -m "feat(docs): put the reference tables on Table at full width"
```

---

### Task 7: DocsInstall and the command-truth guard

**Files:**
- Create: `example/lib/docs/docs_install.dart`
- Test: `example/test/docs/docs_install_test.dart`

**Interfaces:**
- Consumes: `DocsSnippet` from Task 2.
- Produces: `class DocsInstall extends StatefulWidget` with `const DocsInstall({super.key, required String command, required List<DocsCodeFile> manualFiles})`. `DocsCodeFile` is the existing model in `example/lib/docs/docs_code.dart` and is unchanged.

  Task 8 embeds it.

- [ ] **Step 1: Write the failing test**

```dart
// example/test/docs/docs_install_test.dart
/// The install block, and the command it prints.
library;

import 'dart:convert';
import 'dart:io';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/catalog.dart';
import 'package:example/docs/docs_code.dart' show DocsCodeFile;
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_snippet.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: Theme(
      controller: ThemeController(mode: ThemeMode.dark),
      child: child,
    ),
  ),
);

void main() {
  testWidgets('the CLI pane prints the command verbatim', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsInstall(
            command: 'elattar add button',
            manualFiles: <DocsCodeFile>[],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      tester.widget<DocsSnippet>(find.byType(DocsSnippet)).code,
      'elattar add button',
    );
  });

  testWidgets('the manual pane lists the installed paths', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsInstall(
            command: 'elattar add button',
            manualFiles: <DocsCodeFile>[
              DocsCodeFile(
                path: 'lib/components/ui/button.dart',
                code: 'class Button {}',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Manual'));
    await tester.pump();

    expect(find.text('lib/components/ui/button.dart'), findsOneWidget);
  });

  test('every documented command names a real registry item', () {
    // A reader copies these. A command for an item that is not in the
    // registry fails at the shell, and the page is what told them to run it.
    final Map<String, Object?> registry =
        jsonDecode(
              File(
                '../registry/generated/latest/registry.json',
              ).readAsStringSync(),
            )
            as Map<String, Object?>;
    final Set<String> names = <String>{
      for (final Object? raw in registry['items']! as List<Object?>)
        (raw! as Map<String, Object?>)['name']! as String,
    };

    for (final ComponentDocEntry entry in componentDocs) {
      expect(
        entry.command,
        startsWith('elattar add '),
        reason: '${entry.name} publishes a command in another shape',
      );
      expect(
        names,
        contains(entry.command.substring('elattar add '.length)),
        reason:
            '${entry.name} publishes "${entry.command}", and no registry '
            'item answers to that name',
      );
    }
  });
}
```

Before writing this test, confirm the exported list name with
`rg -n "componentDocs|List<ComponentDocEntry>" example/lib/components_docs/catalog.dart` and use the real one.

- [ ] **Step 2: Run it to make sure it fails**

Run: `flutter test test/docs/docs_install_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:example/docs/docs_install.dart'`.

- [ ] **Step 3: Implement the minimal component**

```dart
// example/lib/docs/docs_install.dart
/// The install block: the command, or the files it would have written.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import 'docs_code.dart' show DocsCodeFile;
import 'docs_snippet.dart';

class DocsInstall extends StatefulWidget {
  const DocsInstall({
    super.key,
    required this.command,
    required this.manualFiles,
  });

  /// The exact shell line. Derived from the registry item's own name by
  /// `ComponentDocEntry.command`, never retyped on the page.
  final String command;

  /// What an install would write, for a project not using the CLI.
  final List<DocsCodeFile> manualFiles;

  @override
  State<DocsInstall> createState() => _DocsInstallState();
}

class _DocsInstallState extends State<DocsInstall> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          // The same toggle the showcase uses. One toggle pattern per page.
          child: ToggleGroup(
            label: 'Installation method',
            items: const <ToggleGroupItem>[
              ToggleGroupItem(label: 'CLI'),
              ToggleGroupItem(label: 'Manual'),
            ],
            selectedIndex: _selected,
            onChanged: (int? index) =>
                setState(() => _selected = index ?? _selected),
          ),
        ),
        SizedBox(height: el(3)),
        if (_selected == 0)
          DocsSnippet(code: widget.command, language: 'bash')
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (final DocsCodeFile file in widget.manualFiles) ...<Widget>[
                Text(file.path, Type.small, color: theme.mutedForeground),
                SizedBox(height: el(2)),
                DocsSnippet(code: file.code),
                SizedBox(height: el(4)),
              ],
            ],
          ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run the tests and make sure they pass**

Run: `flutter test test/docs/docs_install_test.dart`
Expected: PASS, 3 tests.

If the command-truth test fails, it has found a real defect: a documented
command names an item the registry does not ship. Report it rather than
weakening the test.

- [ ] **Step 5: Commit**

```bash
git add example/lib/docs/docs_install.dart example/test/docs/docs_install_test.dart
git commit -m "feat(docs): add the install block and prove its command is real"
```

---

### Task 8: The page spec model and ComponentDocPage

**Files:**
- Create: `example/lib/docs/component_doc_page.dart`
- Test: `example/test/docs/component_doc_page_test.dart`

**Interfaces:**
- Consumes: `DocsSection` (Task 3), `DocsShowcase` (Task 4), `DocsDisclosure` (Task 5), `DocsApiTable` (Task 6), `DocsInstall` (Task 7), `DocsSnippet` (Task 2).
- Produces:
  - `sealed class DocsPageSection { const DocsPageSection({required String id, required String title, String? description}); }`
  - `class ShowcaseSection extends DocsPageSection` — adds `Widget specimen`, `String code`, `Alignment alignment`.
  - `class SnippetSection extends DocsPageSection` — adds `String code`.
  - `class InstallSection extends DocsPageSection` — adds `String command`, `List<DocsCodeFile> manualFiles`.
  - `class DisclosureSection extends DocsPageSection` — adds `Widget child`.
  - `class ComponentDocSpec` with `const ComponentDocSpec({required String name, required String title, required String description, required List<DocsPageSection> sections})`, plus `List<DocsTocEntry> get toc`.
  - `class DocsPageHeader extends StatelessWidget` with `const DocsPageHeader({super.key, required String title, required String description})`.
  - `class ComponentDocPage extends StatelessWidget` with `const ComponentDocPage({super.key, required ComponentDocSpec spec})`.

  Task 11 declares a `ComponentDocSpec` for Button.

- [ ] **Step 1: Write the failing test**

```dart
// example/test/docs/component_doc_page_test.dart
/// The page, as a component.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/component_doc_page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_showcase.dart';
import 'package:example/docs/docs_snippet.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const ComponentDocSpec _spec = ComponentDocSpec(
  name: 'button',
  title: 'Button',
  description: 'A pill-shaped control.',
  sections: <DocsPageSection>[
    InstallSection(
      id: 'install',
      title: 'Installation',
      command: 'elattar add button',
      manualFiles: <DocsCodeFile>[],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      code: 'Button(onPressed: () {}, child: const Text("Go"))',
    ),
    ShowcaseSection(
      id: 'ghost',
      title: 'Ghost',
      specimen: SizedBox(height: 40, width: 100),
      code: 'Button(variant: ButtonVariant.ghost)',
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: Text('Tokens.'),
    ),
  ],
);

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: Theme(
    controller: ThemeController(mode: ThemeMode.dark),
    child: SingleChildScrollView(child: child),
  ),
);

void main() {
  testWidgets('every declared section renders as its own kind', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(const ComponentDocPage(spec: _spec)));
    await tester.pump();

    expect(find.byType(DocsInstall), findsOneWidget);
    expect(find.byType(DocsShowcase), findsOneWidget);
    expect(find.byType(DocsDisclosure), findsOneWidget);
    // Usage renders a snippet; the showcase opens on Preview, so this is the
    // Usage one and only the Usage one.
    expect(find.byType(DocsSnippet), findsOneWidget);
  });

  test('the table of contents is derived from the same list', () {
    // A section that exists without a TOC entry is a section nobody can
    // reach from the rail, and a TOC entry without a section is a dead link.
    expect(
      _spec.toc.map((DocsTocEntry entry) => entry.anchor).toList(),
      <String>['install', 'usage', 'ghost', 'theming'],
    );
    expect(
      _spec.toc.map((DocsTocEntry entry) => entry.title).toList(),
      <String>['Installation', 'Usage', 'Ghost', 'Theming'],
    );
  });

  testWidgets('the header carries the title and description', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(const ComponentDocPage(spec: _spec)));
    await tester.pump();

    expect(find.text('Button'), findsOneWidget);
    expect(find.text('A pill-shaped control.'), findsOneWidget);
  });

  testWidgets('nothing on the page uses an uppercase type role', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(const ComponentDocPage(spec: _spec)));
    await tester.pump();

    for (final Text text in tester.widgetList<Text>(find.byType(Text))) {
      expect(text.spec.uppercase, isFalse, reason: text.text);
    }
  });
}
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `flutter test test/docs/component_doc_page_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:example/docs/component_doc_page.dart'`.

- [ ] **Step 3: Implement the minimal component**

```dart
// example/lib/docs/component_doc_page.dart
/// A component documentation page, as a component.
///
/// A page file declares its content and nothing else. Presentation lives in
/// the kit, so every component page is the same page — and so the forty-nine
/// registry items with no page today cost a declaration.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import 'docs_code.dart' show DocsCodeFile;
import 'docs_disclosure.dart';
import 'docs_install.dart';
import 'docs_layout.dart' show DocsTocEntry;
import 'docs_section.dart';
import 'docs_showcase.dart';
import 'docs_snippet.dart';

/// One section of a page. Four kinds, and no escape hatch: a fifth need is a
/// fifth case, reviewed as one.
sealed class DocsPageSection {
  const DocsPageSection({
    required this.id,
    required this.title,
    this.description,
  });

  /// The anchor the table of contents scrolls to.
  final String id;
  final String title;
  final String? description;
}

/// A live specimen with its source behind a toggle.
class ShowcaseSection extends DocsPageSection {
  const ShowcaseSection({
    required super.id,
    required super.title,
    super.description,
    required this.specimen,
    required this.code,
    this.alignment = Alignment.center,
  });

  final Widget specimen;
  final String code;
  final Alignment alignment;
}

/// Prose plus one uncapped code block. Usage is the only one Button needs.
class SnippetSection extends DocsPageSection {
  const SnippetSection({
    required super.id,
    required super.title,
    super.description,
    required this.code,
  });

  final String code;
}

/// The install command and its manual equivalent.
class InstallSection extends DocsPageSection {
  const InstallSection({
    required super.id,
    required super.title,
    super.description,
    required this.command,
    required this.manualFiles,
  });

  final String command;
  final List<DocsCodeFile> manualFiles;
}

/// A text-or-table section, collapsed by default.
class DisclosureSection extends DocsPageSection {
  const DisclosureSection({
    required super.id,
    required super.title,
    super.description,
    required this.child,
  });

  final Widget child;
}

/// Everything a component page is.
class ComponentDocSpec {
  const ComponentDocSpec({
    required this.name,
    required this.title,
    required this.description,
    required this.sections,
  });

  /// The registry item name, e.g. `button`.
  final String name;
  final String title;
  final String description;
  final List<DocsPageSection> sections;

  /// Derived, never written twice: a section cannot exist without a rail
  /// entry, and a rail entry cannot point at nothing.
  List<DocsTocEntry> get toc => <DocsTocEntry>[
    for (final DocsPageSection section in sections)
      DocsTocEntry(title: section.title, anchor: section.id),
  ];
}

/// The page's title block.
class DocsPageHeader extends StatelessWidget {
  const DocsPageHeader({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: el(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, Type.h1, color: theme.foreground),
          SizedBox(height: el(3)),
          Text(description, Type.lead),
        ],
      ),
    );
  }
}

class ComponentDocPage extends StatelessWidget {
  const ComponentDocPage({super.key, required this.spec});

  final ComponentDocSpec spec;

  Widget _body(DocsPageSection section) => switch (section) {
    ShowcaseSection(:final Widget specimen, :final String code,
        :final Alignment alignment) =>
      DocsShowcase(specimen: specimen, code: code, alignment: alignment),
    SnippetSection(:final String code) => DocsSnippet(code: code),
    InstallSection(:final String command, :final List<DocsCodeFile> manualFiles) =>
      DocsInstall(command: command, manualFiles: manualFiles),
    DisclosureSection(:final Widget child, :final String title) =>
      DocsDisclosure(title: title, child: child),
  };

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsPageHeader(title: spec.title, description: spec.description),
      for (final DocsPageSection section in spec.sections)
        DocsSection(
          id: section.id,
          title: section.title,
          description: section.description,
          child: _body(section),
        ),
    ],
  );
}
```

The breadcrumb is not rendered here: `DocsLayout` already renders one above
the article, and a second would be a duplicate. Confirm with
`rg -n "Breadcrumb" example/lib/docs/docs_layout.dart` before adding one.

- [ ] **Step 4: Run the tests and make sure they pass**

Run: `flutter test test/docs/component_doc_page_test.dart`
Expected: PASS, 4 tests.

- [ ] **Step 5: Commit**

```bash
git add example/lib/docs/component_doc_page.dart example/test/docs/component_doc_page_test.dart
git commit -m "feat(docs): make a component page a declaration"
```

---

### Task 9: The rail height fix

Both rails already scroll. The defect is that `railMaxHeight` is the **full** viewport height while each rail starts below the 64px sticky header, so its last rows sit past the fold and cannot be reached.

**Files:**
- Modify: `example/lib/docs/docs_layout.dart:315`
- Test: `example/test/docs/docs_rail_height_test.dart`

**Interfaces:**
- Consumes: nothing.
- Produces: nothing other tasks depend on.

- [ ] **Step 1: Write the failing test**

```dart
// example/test/docs/docs_rail_height_test.dart
/// The rails scroll, and their last row is reachable.
///
/// The bug this pins: a rail capped at the full viewport height, but
/// positioned below a 64px sticky header, runs 64px past the fold.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/button/page.dart';
import 'package:flutter/material.dart' show MaterialApp;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('a rail is never taller than the space below the header', (
    WidgetTester tester,
  ) async {
    const double viewportHeight = 900;
    tester.view.physicalSize = const Size(1600, viewportHeight);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ThemeController controller = ThemeController(
      mode: ThemeMode.dark,
    );
    addTearDown(controller.dispose);

    // The same harness every component-doc test uses.
    await tester.pumpWidget(
      Theme(
        controller: controller,
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SingleChildScrollView(child: ButtonDocPage()),
        ),
      ),
    );
    await tester.pump();

    final Finder rail = find.byKey(
      const ValueKey<String>('docs-layout-sidebar'),
    );
    expect(rail, findsOneWidget);
    expect(
      tester.getSize(rail).height,
      lessThanOrEqualTo(viewportHeight - Widths.siteHeader),
    );
  });
}
```

Both rail keys already exist: `docs-layout-sidebar` at
`example/lib/docs/docs_layout.dart:449` and `docs-layout-toc` at `:483`. The
imports this test needs are `package:flutter/material.dart` (for `MaterialApp`)
and `package:example/components_docs/button/page.dart`. The rail only renders
at `Breakpoints.lg` and wider, which is why the view is 1600 wide.

- [ ] **Step 2: Run it to make sure it fails**

Run: `flutter test test/docs/docs_rail_height_test.dart`
Expected: FAIL — the rail measures 900, not 836.

- [ ] **Step 3: Fix the height**

In `example/lib/docs/docs_layout.dart`, replace line 315:

```dart
    final double railMaxHeight = MediaQuery.sizeOf(context).height;
```

with:

```dart
    // Each rail begins BELOW the sticky header, so a rail capped at the full
    // viewport height runs past the fold and its last rows cannot be
    // reached. The gutter keeps the final row off the bottom edge.
    final double railMaxHeight =
        MediaQuery.sizeOf(context).height - Widths.siteHeader - el(4);
```

- [ ] **Step 4: Run the tests and make sure they pass**

Run: `flutter test test/docs/docs_rail_height_test.dart`
Expected: PASS.

- [ ] **Step 5: Run every page that uses the layout**

Run: `flutter test test/components_docs test/docs_pages_routing_test.dart`
Expected: PASS. The change only extends reachability downward; no page loses content.

- [ ] **Step 6: Commit**

```bash
git add example/lib/docs/docs_layout.dart example/test/docs/docs_rail_height_test.dart
git commit -m "fix(docs): stop both rails running past the fold"
```

---

### Task 10: The no-uppercase guard

**Files:**
- Test: `example/test/docs/docs_no_uppercase_test.dart`

**Interfaces:**
- Consumes: nothing.
- Produces: nothing.

- [ ] **Step 1: Write the failing test**

```dart
// example/test/docs/docs_no_uppercase_test.dart
/// No documentation page renders text in an uppercase type role.
///
/// Uppercase is a foundation flag on seven roles, not a page-level choice.
/// The foundation is deliberately not changed — badges and controls elsewhere
/// keep it — so the rule is enforced at the point of use instead.
library;

import 'dart:io';

import 'package:test/test.dart';

/// The roles whose spec carries `uppercase: true`.
const List<String> _uppercaseRoles = <String>[
  'Type.label',
  'Type.micro',
  'Type.tag',
  'Type.badge',
  'Type.serial',
  'Type.inputSerial',
  'Type.buttonLabelCaps',
];

/// Directories the rule covers.
const List<String> _roots = <String>[
  'lib/docs',
  'lib/components_docs',
];

void main() {
  test('no uppercase role, and no manual upper-casing', () {
    final List<String> offences = <String>[];

    for (final String root in _roots) {
      final Directory directory = Directory(root);
      if (!directory.existsSync()) continue;
      for (final FileSystemEntity entity
          in directory.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final List<String> lines = entity.readAsLinesSync();
        for (int i = 0; i < lines.length; i++) {
          final String line = lines[i];
          // Comments explain the rule; they do not break it.
          if (line.trimLeft().startsWith('//')) continue;
          for (final String role in _uppercaseRoles) {
            if (line.contains(role)) {
              offences.add('${entity.path}:${i + 1}  $role');
            }
          }
          if (line.contains('.toUpperCase()')) {
            offences.add('${entity.path}:${i + 1}  .toUpperCase()');
          }
        }
      }
    }

    expect(
      offences,
      isEmpty,
      reason:
          'documentation pages must not render uppercase text. Use '
          'Type.caption, Type.small or Type.textSm instead:\n'
          '${offences.join('\n')}',
    );
  });
}
```

- [ ] **Step 2: Run it to see what it catches**

Run: `flutter test test/docs/docs_no_uppercase_test.dart`
Expected: FAIL, listing every existing use. This is the work list.

- [ ] **Step 3: Replace every offending role**

For each line the test named, substitute by intent:

| Was | Use |
| --- | --- |
| `Type.label` on a section eyebrow or table header | `Type.textSm` with `color: theme.mutedForeground` |
| `Type.micro` or `Type.tag` on a small annotation | `Type.caption` |
| `Type.badge` inside a docs page | `Type.small` |
| `Type.serial` on a path or identifier | `Type.code` |

Do not touch `lib/pages/`, `lib/site/`, or anything under `lib/src/`. The rule covers documentation pages only, by decision.

- [ ] **Step 4: Run the tests and make sure they pass**

Run: `flutter test test/docs/docs_no_uppercase_test.dart`
Expected: PASS.

- [ ] **Step 5: Run the pages you just edited**

Run: `flutter test test/components_docs`
Expected: PASS. A failure means a page asserted the uppercase rendering; update the expectation.

- [ ] **Step 6: Commit**

```bash
git add example/test/docs/docs_no_uppercase_test.dart example/lib/docs example/lib/components_docs
git commit -m "refactor(docs): take uppercase out of the documentation pages"
```

---

### Task 11: Rebuild the Button page on the kit

**Files:**
- Modify: `example/lib/components_docs/button/page.dart` (currently 1,638 lines)
- Test: `example/test/components_docs/button_test.dart`

**Interfaces:**
- Consumes: everything from Tasks 1-10.
- Produces: the reviewable artifact.

- [ ] **Step 1: Read what is there now**

Run: `rg -n "DocsTocEntry\(" example/lib/components_docs/button/page.dart`

The existing order is the target order and must not change: Installation,
Usage, Size, Default, Premium, Outline, Secondary, Ghost, Destructive, Link,
Icon, With Icon, Rounded, Spinner, Disabled, Emphasis, Button Group, API
Reference, States, Accessibility, Responsive, Dependencies, Theming, Source.

Add one section the current page lacks and the design calls for: **Keyboard**,
a `DisclosureSection` between Accessibility and Responsive.

- [ ] **Step 2: Write the failing test**

Add to `example/test/components_docs/button_test.dart`:

```dart
  testWidgets('the page is declared, and every section is a kit component', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(const ButtonDocPage()));
    await tester.pump();

    // Sixteen specimen stages: Size, seven variants, Icon, With Icon,
    // Rounded, Spinner, Disabled, Emphasis, Button Group, and the hero.
    expect(find.byType(DocsShowcase), findsNWidgets(16));
    expect(find.byType(DocsInstall), findsOneWidget);
    // Eight collapsed sections: API Reference, States, Accessibility,
    // Keyboard, Responsive, Dependencies, Theming, Source.
    expect(find.byType(DocsDisclosure), findsNWidgets(8));
  });

  test('the table of contents matches the declared sections', () {
    expect(
      buttonDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
      <String>[
        'Preview',
        'Installation',
        'Usage',
        'Size',
        'Default',
        'Premium',
        'Outline',
        'Secondary',
        'Ghost',
        'Destructive',
        'Link',
        'Icon',
        'With Icon',
        'Rounded',
        'Spinner',
        'Disabled',
        'Emphasis',
        'Button Group',
        'API Reference',
        'States',
        'Accessibility',
        'Keyboard',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ],
    );
  });
```

Add the imports the new assertions need, and confirm the existing host
helper's name with `rg -n "Widget _host" example/test/components_docs/button_test.dart`.

- [ ] **Step 3: Run it to make sure it fails**

Run: `flutter test test/components_docs/button_test.dart`
Expected: FAIL — `buttonDocSpec` is undefined.

- [ ] **Step 4: Rewrite the page as a declaration**

Replace the body of `example/lib/components_docs/button/page.dart` with a
`ComponentDocSpec` named `buttonDocSpec` and a thin `ButtonDocPage` that
renders it. Every existing specimen widget and every existing code string in
the file moves across unchanged — this is a re-housing, not a rewrite. One
section looks like this:

```dart
const ShowcaseSection(
  id: 'destructive',
  title: 'Destructive',
  description:
      'For an action that removes something. One per surface, and never '
      'the default focus target.',
  specimen: _DestructiveSpecimen(),
  code:
      "Button(\n"
      "  variant: ButtonVariant.destructive,\n"
      "  onPressed: () {},\n"
      "  child: const Text('Delete'),\n"
      ")",
),
```

with, elsewhere in the file:

```dart
class _DestructiveSpecimen extends StatelessWidget {
  const _DestructiveSpecimen();

  @override
  Widget build(BuildContext context) => Button(
    variant: ButtonVariant.destructive,
    onPressed: () {},
    child: const Text('Delete'),
  );
}
```

A specimen is its own widget so the section list stays `const` and the
specimen keeps its own state where it needs one.

The page then reads:

```dart
class ButtonDocPage extends StatelessWidget {
  const ButtonDocPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ComponentDocPage(spec: buttonDocSpec);
}
```

The install section takes its command from the catalog entry, never a literal:

```dart
InstallSection(
  id: 'install',
  title: 'Installation',
  description: '...',
  command: buttonDoc.command,
  manualFiles: <DocsCodeFile>[ /* the existing files, unchanged */ ],
),
```

Wire the page into `DocsLayout` with `toc: buttonDocSpec.toc` so the rail and
the sections cannot drift.

- [ ] **Step 5: Run the tests and make sure they pass**

Run: `flutter test test/components_docs/button_test.dart`
Expected: PASS.

- [ ] **Step 6: Run the token guard and the analyzer**

Run (from the repository root): `flutter test test/token_guard_test.dart`
Run (from `example/`): `flutter analyze`
Expected: both clean.

- [ ] **Step 7: Commit**

```bash
git add example/lib/components_docs/button/page.dart example/test/components_docs/button_test.dart
git commit -m "feat(docs): rebuild the button page on the documentation kit"
```

---

### Task 12: Verify and review

**Files:**
- Create: `docs/superpowers/reports/docs-kit/button-page-review.md`

**Interfaces:**
- Consumes: everything.
- Produces: the review the user reads before rollout.

- [ ] **Step 1: Run the full repository ladder**

From the repository root:

```bash
flutter analyze
flutter test
```

From `example/`:

```bash
flutter analyze
flutter test
```

Expected: all clean. The example suite takes roughly 16 minutes; do not run it
in a loop.

- [ ] **Step 2: Build the site**

From `example/`:

```bash
flutter build web --release --base-href /flutter-design-system/
```

On Git Bash for Windows, prefix with `MSYS_NO_PATHCONV=1` or the `--base-href`
value is rewritten into a Windows path and the build fails.

- [ ] **Step 3: Serve it from a short path**

A capture root nested under a long temp path pushes the deepest bundled assets
past Windows MAX_PATH (260) and the server 404s them.

```bash
rm -rf /c/elx/a && mkdir -p /c/elx/a
cp -r example/build/web /c/elx/a/flutter-design-system
cd /c/elx/a && python -m http.server 8331
```

- [ ] **Step 4: Capture the page**

From `tool/verify/`:

```bash
node capture.js "http://localhost:8331/flutter-design-system/?route=/components/button&theme=dark" out/button-dark-1440.png --settle 2500
node capture.js "http://localhost:8331/flutter-design-system/?route=/components/button&theme=light" out/button-light-1440.png --settle 2500
node shot.js "http://localhost:8331/flutter-design-system/?route=/components/button&theme=dark" out/button-dark-390.png 390 844 9000
node shot.js "http://localhost:8331/flutter-design-system/?route=/components/button&theme=light" out/button-light-390.png 390 844 9000
```

Then open one showcase's Code pane and one disclosure and capture those two
states with `shot.js`, since neither is visible at rest.

- [ ] **Step 5: Write the review**

`docs/superpowers/reports/docs-kit/button-page-review.md` records: the commit,
the commands actually run and their exit codes, the measured section counts,
the captures with their dimensions/theme/route, and every limitation. Do not
claim parity against a reference page — there is none for this shape.

- [ ] **Step 6: Commit**

```bash
git add docs/superpowers/reports/docs-kit/button-page-review.md
git commit -m "docs(review): record the button page rebuilt on the kit"
```

- [ ] **Step 7: Stop**

Do not roll the kit out to a second page. The Button page is the review gate.

---

## Out of scope

- The other 56 component documentation pages.
- The 49 registry items whose `documentationRoute` the site cannot resolve. This work makes those pages cheap; it does not write them.
- `lib/pages/` — the gallery every `/design-system/...` route already falls back away from.
- Any change under `lib/src/`, and any foundation token.
