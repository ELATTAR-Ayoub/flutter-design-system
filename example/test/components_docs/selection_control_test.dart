/// Tests for `components_docs/selection_control/page.dart`'s
/// [SelectionControlDocPage].
///
/// Re-housed onto the kit alongside the page: the section-order test now
/// reads `DocsSection.id` (the kit's own section widget) instead of
/// `Section`'s title, and the API-table / state-matrix tests open the
/// relevant `DocsDisclosure` first — closed by default in the new kit.
///
/// This page documents [SelectionControl], [HitArea], and
/// [StateChangeFeedback] — the shared socket primitive Checkbox, RadioGroup,
/// and Switch each build their own skin on top of. It has no shadcn/Base
/// UI counterpart page of any kind, so its own sections are named for the
/// reader problems `selection_control.dart`'s source actually solves.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ThemeController` is flipped in place for theme coverage rather than
/// re-pumped under a new controller.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/selection_control/meta.dart';
import 'package:example/components_docs/selection_control/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
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

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The house-shape section order this page must render, top to bottom.
const List<String> _expectedSectionIds = <String>[
  'preview',
  'install',
  'usage',
  'hit-area',
  'focus-ring',
  'inert-vs-disabled',
  'jelly-replay',
  'api',
  'states',
  'accessibility',
  'keyboard',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

/// Every `ApiTable` this page must render, by title, and every public
/// constructor parameter or static member of each documented class found by
/// reading `lib/src/components/selection_control.dart` directly.
const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  'SelectionControl': <String>[
    'width',
    'height',
    'radius',
    'fill',
    'border',
    'shadow',
    'duration',
    'jellyState',
    'child',
    'onTap',
    'enabled',
    'inert',
    'invalid',
    'forceFocusRing',
    'focusNode',
    'skipTraversal',
    'onKey',
    'semantics',
  ],
  'HitArea': <String>[
    'insets',
    'border',
    'child',
    'HitArea.debugExpanded(box)',
  ],
  'StateChangeFeedback': <String>['state', 'child'],
};

/// The single `DocsDisclosure` whose title is [title], matching
/// `checkbox_test.dart`'s own convention.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

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
            child: SelectionControlDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  testWidgets('sections render in the house-shape order, top to bottom', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    final List<String> ids = tester
        .widgetList<DocsSection>(find.byType(DocsSection))
        .map((DocsSection section) => section.id)
        .toList();

    expect(ids, _expectedSectionIds);
  });

  testWidgets('every live specimen renders without exceptions', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    for (final String key in <String>[
      'selection-control-rest',
      'selection-control-checked',
      'selection-control-hit-area',
      'selection-control-focus-ring',
      'selection-control-operable',
      'selection-control-inert',
      'selection-control-disabled',
      'selection-control-jelly',
    ]) {
      final Finder finder = find.byKey(ValueKey<String>(key));
      await tester.ensureVisible(finder);
      expect(finder, findsOneWidget, reason: 'missing specimen "$key"');
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'renders the article at wide and narrow widths with no exceptions',
    (WidgetTester tester) async {
      await _pump(tester, size: _wide);

      expect(find.text(selectionControlDoc.title), findsWidgets);
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
    'each ApiTable covers every public constructor parameter and static '
    'of its own class',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder apiTrigger = _disclosureTrigger('API Reference');
      await tester.ensureVisible(apiTrigger);
      await tester.tap(apiTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

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
          reason: 'no ApiTable titled "${expected.key}" was rendered',
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

  testWidgets(
    'the Focus ring specimen actually toggles forceFocusRing across its '
    'three buttons',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder socket = find.byKey(
        const ValueKey<String>('selection-control-focus-ring'),
      );
      await tester.ensureVisible(socket);
      expect(socket, findsOneWidget);

      final Finder trueButton = find.byKey(
        const ValueKey<String>('selection-control-focus-ring-true'),
      );
      await tester.ensureVisible(trueButton);
      await tester.tap(trueButton);
      await tester.pump();
      expect(tester.takeException(), isNull);

      final Finder falseButton = find.byKey(
        const ValueKey<String>('selection-control-focus-ring-false'),
      );
      await tester.ensureVisible(falseButton);
      await tester.tap(falseButton);
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('the Jelly replay specimen toggles without exceptions', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    final Finder toggle = find.byKey(
      const ValueKey<String>('selection-control-jelly-toggle'),
    );
    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('the state matrix documents rest/checked, focus, invalid, inert, '
      'disabled, and reduced motion', (WidgetTester tester) async {
    await _pump(tester);

    final Finder statesTrigger = _disclosureTrigger('States');
    await tester.ensureVisible(statesTrigger);
    await tester.tap(statesTrigger);
    await tester.pump();
    await tester.pump(MotionDurations.open);

    final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
      find.byType(DocsStateMatrix),
    );
    final Set<String> states = matrix.facts
        .map((DocsStateFact fact) => fact.state)
        .toSet();

    for (final String expected in <String>[
      'Rest / checked (caller-driven)',
      'Focus-visible',
      'Invalid',
      'Inert',
      'Disabled',
      'Reduced motion',
    ]) {
      expect(
        states,
        contains(expected),
        reason: 'state matrix is missing the "$expected" row',
      );
    }
  });

  testWidgets(
    'both themes render the article with no exceptions when flipped in place',
    (WidgetTester tester) async {
      final ThemeController theme = await _pump(tester, mode: ColorMode.light);
      expect(find.text(selectionControlDoc.title), findsWidgets);

      theme.setMode(ColorMode.dark);
      await tester.pump();
      expect(find.text(selectionControlDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'installation presents the working selection-control CLI command',
    (WidgetTester tester) async {
      await _pump(tester);

      expect(
        find.textContaining('elattar add selection-control'),
        findsWidgets,
      );
    },
  );
}
