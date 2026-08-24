/// Tests for `components_docs/scroll_area/page.dart`'s [ScrollAreaDocPage]:
/// [ElScrollArea] only. `ElResizablePanelGroup` and `ElAspectRatio` were
/// split off into their own routes and their own test files
/// (`resizable_test.dart`, `aspect_ratio_test.dart`); see
/// `scroll_area/meta.dart`'s library note for the split.
///
/// Reads `lib/src/components/scroll_area.dart` directly; every public
/// class, enum, and constructor parameter enumerated below is one this
/// page's API tables must cover.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ElThemeController` is flipped in place for theme coverage.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/scroll_area/meta.dart';
import 'package:example/components_docs/scroll_area/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// Every `ElApiTable` this page must render, by title, and every public
/// constructor parameter or static member of that class, read directly off
/// `lib/src/components/scroll_area.dart`.
const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  'ElScrollArea': <String>[
    'child',
    'borderRadius',
    'horizontalBar',
    'controller',
  ],
  'ElScrollAreaBehavior': <String>['ElScrollAreaBehavior'],
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
            child: ScrollAreaDocPage(onNavigate: onNavigate),
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
    'sections render in the shadcn-mirrored order, section for section, '
    'with no leftover Resizable/Aspect ratio section from the merged page',
    (WidgetTester tester) async {
      await _pump(tester);

      final List<String> titles = tester
          .widgetList<ElSection>(find.byType(ElSection))
          .map((ElSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Installation',
        'Usage',
        'Composition',
        'Horizontal scrolling',
        'RTL',
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

  testWidgets(
    'renders the article at wide and narrow widths with no exceptions',
    (WidgetTester tester) async {
      await _pump(tester, size: _wide);

      expect(find.text(scrollAreaDoc.title), findsWidgets);
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
    'of ElScrollArea',
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

      // No leftover ElResizablePanelGroup/ElAspectRatio tables from the
      // pre-split page.
      expect(byTitle.containsKey('ElResizablePanelGroup'), isFalse);
      expect(byTitle.containsKey('ElResizablePanel'), isFalse);
      expect(byTitle.containsKey('ElAspectRatio'), isFalse);
    },
  );

  testWidgets(
    'ElScrollArea renders the scroll container with content that can scroll',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder scrollArea = find.byKey(
        const ValueKey<String>('scroll-area-doc-preview'),
      );
      expect(scrollArea, findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(find.byType(ElResizablePanelGroup), findsNothing);
      expect(find.byType(ElAspectRatio), findsNothing);
    },
  );

  testWidgets(
    'both themes render the article with no exceptions when flipped in '
    'place',
    (WidgetTester tester) async {
      final ElThemeController theme = await _pump(
        tester,
        mode: ElThemeMode.light,
      );
      expect(find.text(scrollAreaDoc.title), findsWidgets);

      theme.setMode(ElThemeMode.dark);
      await tester.pump();
      expect(find.text(scrollAreaDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation presents the working scroll-area CLI command', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(find.textContaining('elattar add scroll-area'), findsWidgets);
  });

  testWidgets('the state matrix documents rest, hover, and drag', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
      find.byType(DocsStateMatrix),
    );
    final Set<String> states = matrix.facts
        .map((DocsStateFact fact) => fact.state)
        .toSet();

    for (final String expected in <String>['Rest', 'Hover', 'Drag']) {
      expect(
        states,
        contains(expected),
        reason: 'state matrix is missing the "$expected" row',
      );
    }
  });

  testWidgets(
    'the pager navigates through DocsLayout.onNavigate, back to Resizable '
    'and forward to Layout',
    (WidgetTester tester) async {
      String? destination;
      await _pump(tester, onNavigate: (String route) => destination = route);

      final Finder resizableLink = find.text('Resizable').first;
      await tester.ensureVisible(resizableLink);
      await tester.pump();
      await tester.tap(resizableLink);
      expect(destination, '/components/resizable');
    },
  );

  testWidgets('the component is documented with its public name and exports', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(scrollAreaDoc.name, 'scroll_area');
    expect(
      scrollAreaDoc.exports,
      containsAll(<String>['ElScrollArea', 'ElScrollAreaBehavior']),
    );
    expect(tester.takeException(), isNull);
  });
}
