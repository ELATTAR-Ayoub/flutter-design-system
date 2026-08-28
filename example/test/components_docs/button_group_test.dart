/// Tests for `components_docs/button_group/page.dart`'s [ButtonGroupDocPage].
///
/// **Re-housed onto the documentation kit.** This suite used to read the old
/// page's `Section`s directly; it now reads `DocsSection` (the kit's own
/// section widget) and opens each `DocsDisclosure` before reading what is
/// inside it, closed by default, mounts no content at all — matching
/// `button_test.dart`'s own pattern, the worked reference for this rollout.
///
/// Reads from `lib/src/components/button_group.dart` directly (Step 1 of
/// the task cycle): every public class and constructor parameter enumerated
/// below is one this page's API tables must cover.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ThemeController` is flipped in place for theme coverage.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/button_group/meta.dart';
import 'package:example/components_docs/button_group/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart' show DocsShowcase;
import 'package:flutter/material.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth,
        ActionChip,
        AlertDialog,
        Badge,
        Card,
        CarouselController,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        DrawerHeader,
        Slider,
        Switch,
        TextFormField,
        Tooltip;
import 'package:flutter_test/flutter_test.dart';

const List<String> _expectedSectionOrder = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Composition',
  'Composing other members',
  'Separator',
  'Split',
  'Nested',
  'Sizes',
  'Vs. selection control',
  'RTL',
  'API Reference',
  'States',
  'Accessibility',
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// Every `DocsApiTable` this page must render, by title, and every public
/// constructor parameter or static member of that class, read directly off
/// `lib/src/components/button_group.dart`.
const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  'ButtonGroup': <String>[
    'children',
    'ButtonGroup.radiiOf',
    'ButtonGroup.hasLeftBorder',
  ],
  'ButtonGroupText': <String>[
    'text',
    'numeric',
    'ButtonGroupText.paddingX',
    'ButtonGroupText.gap',
  ],
  'ButtonGroupSeparator': <String>[],
};

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s
/// own trigger key is one constant shared by every instance on the page, so
/// a bare `find.byKey` would match all eight — this narrows to the one panel
/// by its title first.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

Future<void> _open(WidgetTester tester, String title) async {
  final Finder trigger = _disclosureTrigger(title);
  await tester.ensureVisible(trigger);
  await tester.pump();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(MotionDurations.normal);
}

Future<ThemeController> _pump(
  WidgetTester tester, {
  Size size = _wide,
  ColorMode mode = ColorMode.dark,
  ValueChanged<String>? onNavigate,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ThemeController theme = ThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ThemeScope(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ButtonGroupDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  testWidgets(
    'renders the article at wide and narrow widths with no exceptions',
    (WidgetTester tester) async {
      await _pump(tester, size: _wide);

      expect(find.text(buttonGroupDoc.title), findsWidgets);
      expect(find.byType(DocsShowcase), findsAtLeastNWidgets(1));
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      await _pump(tester, size: _narrow);
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'each DocsApiTable covers every public constructor parameter and static '
    'of its own class',
    (WidgetTester tester) async {
      await _pump(tester);
      await _open(tester, 'API Reference');

      final List<DocsApiTable> tables = tester
          .widgetList<DocsApiTable>(find.byType(DocsApiTable))
          .toList();
      expect(tables, isNotEmpty);

      final Map<String, Set<String>> byTitle = <String, Set<String>>{
        for (final DocsApiTable table in tables)
          table.title: <String>{
            for (final DocsApiFact fact in table.facts) fact.name,
          },
      };

      for (final MapEntry<String, List<String>> expected
          in _expectedApiTables.entries) {
        final Set<String>? documented = byTitle[expected.key];
        expect(
          documented,
          isNotNull,
          reason: 'no DocsApiTable titled "${expected.key}" was rendered',
        );
        for (final String param in expected.value) {
          expect(
            documented,
            contains(param),
            reason: '"${expected.key}" table is missing parameter "$param"',
          );
        }
      }
    },
  );

  testWidgets('renders the sections in order, exactly once each', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    final List<String> rendered = tester
        .widgetList<DocsSection>(find.byType(DocsSection))
        .map((DocsSection section) => section.title)
        .toList();

    expect(rendered, _expectedSectionOrder);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the live specimen: a quantity stepper where the app, not '
      'ButtonGroup, owns the count: proving the group coordinates no state '
      'of its own', (WidgetTester tester) async {
    await _pump(tester);

    const Key decreaseKey = ValueKey<String>('button-group-doc-decrease');
    const Key increaseKey = ValueKey<String>('button-group-doc-increase');
    const Key countKey = ValueKey<String>('button-group-doc-count');

    await tester.ensureVisible(find.byKey(countKey));
    expect(tester.widget<ButtonGroupText>(find.byKey(countKey)).text, '3');

    await tester.tap(find.byKey(increaseKey));
    await tester.pump();
    expect(tester.widget<ButtonGroupText>(find.byKey(countKey)).text, '4');

    await tester.tap(find.byKey(decreaseKey));
    await tester.tap(find.byKey(decreaseKey));
    await tester.pump();
    expect(tester.widget<ButtonGroupText>(find.byKey(countKey)).text, '2');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'ButtonGroup.radiiOf and hasLeftBorder document the asymmetric join: '
    'only the first member keeps a left border, only the last keeps its own '
    'right radius (forced to Radii.lg), every interior corner is squared',
    (WidgetTester tester) async {
      final List<Widget> members = <Widget>[
        Button(
          variant: ButtonVariant.outline,
          onPressed: () {},
          child: const Text('A'),
        ),
        Button(
          variant: ButtonVariant.outline,
          onPressed: () {},
          child: const Text('B'),
        ),
        Button(
          variant: ButtonVariant.outline,
          onPressed: () {},
          child: const Text('C'),
        ),
      ];

      final BorderRadius first = ButtonGroup.radiiOf(members, 0);
      final BorderRadius middle = ButtonGroup.radiiOf(members, 1);
      final BorderRadius last = ButtonGroup.radiiOf(members, 2);

      expect(first.topLeft, const Radius.circular(Radii.full));
      expect(first.bottomLeft, const Radius.circular(Radii.full));
      expect(first.topRight, Radius.zero);
      expect(middle.topLeft, Radius.zero);
      expect(middle.topRight, Radius.zero);
      expect(last.topRight, const Radius.circular(Radii.lg));
      expect(last.bottomRight, const Radius.circular(Radii.lg));
      expect(last.topLeft, Radius.zero);

      expect(ButtonGroup.hasLeftBorder(members, 0), isTrue);
      expect(ButtonGroup.hasLeftBorder(members, 1), isFalse);
      expect(ButtonGroup.hasLeftBorder(members, 2), isFalse);
    },
  );

  testWidgets(
    'both themes render the article with no exceptions when flipped in '
    'place',
    (WidgetTester tester) async {
      final ThemeController theme = await _pump(tester, mode: ColorMode.light);
      expect(find.text(buttonGroupDoc.title), findsWidgets);

      theme.setMode(ColorMode.dark);
      await tester.pump();
      expect(find.text(buttonGroupDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation presents the working button-group CLI command', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(find.textContaining('elattar add button-group'), findsWidgets);
  });
}
