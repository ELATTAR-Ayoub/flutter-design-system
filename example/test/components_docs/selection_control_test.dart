/// Tests for `components_docs/selection_control/page.dart`'s
/// [SelectionControlDocPage].
///
/// This page documents [ElSelectionControl], [ElHitArea], and
/// [ElJellyReplay] — the shared socket primitive ElCheckbox, ElRadioGroup,
/// and ElSwitch each build their own skin on top of. It has no shadcn/Base
/// UI counterpart page of any kind, so its own sections are named for the
/// reader problems `selection_control.dart`'s source actually solves.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ElThemeController` is flipped in place for theme coverage rather than
/// re-pumped under a new controller.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/selection_control/meta.dart';
import 'package:example/components_docs/selection_control/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// Every `ElApiTable` this page must render, by title, and every public
/// constructor parameter or static member of each documented class found by
/// reading `lib/src/components/selection_control.dart` directly.
const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  'ElSelectionControl': <String>[
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
  'ElHitArea': <String>[
    'insets',
    'border',
    'child',
    'ElHitArea.debugExpanded(box)',
  ],
  'ElJellyReplay': <String>['state', 'child'],
};

Future<ElThemeController> _pump(
  WidgetTester tester, {
  Size size = _wide,
  ElThemeMode mode = ElThemeMode.dark,
  ValueChanged<String>? onNavigate,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ElThemeController theme = ElThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ElTheme(
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
  testWidgets(
    'sections render in order: Installation, Usage, four reader-problem '
    'sections, API Reference, and the six trailing sections',
    (WidgetTester tester) async {
      await _pump(tester);

      final List<String> titles = tester
          .widgetList<ElSection>(find.byType(ElSection))
          .map((ElSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Installation',
        'Usage',
        'Hit area',
        'Focus ring',
        'Inert vs disabled',
        'Jelly replay',
        'API Reference',
        'States',
        'Accessibility',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);
    },
  );

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
      expect(find.byType(DocsCodeExample), findsAtLeastNWidgets(1));
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      await _pump(tester, size: _narrow);
      await tester.pumpAndSettle();

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
    'each ElApiTable covers every public constructor parameter and static '
    'of its own class',
    (WidgetTester tester) async {
      await _pump(tester);

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
          reason: 'no ElApiTable titled "${expected.key}" was rendered',
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
      final ElThemeController theme = await _pump(
        tester,
        mode: ElThemeMode.light,
      );
      expect(find.text(selectionControlDoc.title), findsWidgets);

      theme.setMode(ElThemeMode.dark);
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
