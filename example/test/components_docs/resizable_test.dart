/// Tests for `components_docs/resizable/page.dart`'s [ResizableDocPage]:
/// [ElResizablePanelGroup] and [ElResizablePanel]. New route, split off
/// from the former shared `scroll_area` route; see `resizable/meta.dart`'s
/// library note.
///
/// Reads `lib/src/components/resizable.dart` directly; every public class
/// and constructor parameter enumerated below is one this page's API
/// tables must cover.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ElThemeController` is flipped in place for theme coverage.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/resizable/meta.dart';
import 'package:example/components_docs/resizable/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  'ElResizablePanelGroup': <String>['panels', 'withHandle', 'minHeight'],
  'ElResizablePanel': <String>['child', 'defaultSize', 'minSize'],
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
            child: ResizableDocPage(onNavigate: onNavigate),
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
    'with no Vertical section (the honest skip)',
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
        'Handle',
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

      expect(find.text(resizableDoc.title), findsWidgets);
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

  testWidgets('each ElApiTable covers every public constructor parameter of '
      'ElResizablePanelGroup and ElResizablePanel', (
    WidgetTester tester,
  ) async {
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
  });

  testWidgets('ElResizablePanelGroup renders resizable panels with a draggable '
      'separator, in the live demo and the Handle and RTL specimens', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    // Live demo, Handle (two groups), RTL.
    final Finder panelGroup = find.byType(ElResizablePanelGroup);
    expect(panelGroup, findsAtLeastNWidgets(4));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'both themes render the article with no exceptions when flipped in '
    'place',
    (WidgetTester tester) async {
      final ElThemeController theme = await _pump(
        tester,
        mode: ElThemeMode.light,
      );
      expect(find.text(resizableDoc.title), findsWidgets);

      theme.setMode(ElThemeMode.dark);
      await tester.pump();
      expect(find.text(resizableDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation presents the working resizable CLI command', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(find.textContaining('elattar add resizable'), findsWidgets);
  });

  testWidgets('the state matrix documents rest, hover, drag, and focus', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
      find.byType(DocsStateMatrix),
    );
    final Set<String> states = matrix.facts
        .map((DocsStateFact fact) => fact.state)
        .toSet();

    for (final String expected in <String>['Rest', 'Hover', 'Drag', 'Focus']) {
      expect(
        states,
        contains(expected),
        reason: 'state matrix is missing the "$expected" row',
      );
    }
  });

  testWidgets(
    'the pager navigates through DocsLayout.onNavigate, back to Aspect '
    'ratio and forward to Scroll area',
    (WidgetTester tester) async {
      String? destination;
      await _pump(tester, onNavigate: (String route) => destination = route);

      final Finder scrollAreaLink = find.text('Scroll area').first;
      await tester.ensureVisible(scrollAreaLink);
      await tester.pump();
      await tester.tap(scrollAreaLink);
      expect(destination, '/components/scroll_area');
    },
  );

  testWidgets('the component is documented with its public name and exports', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(resizableDoc.name, 'resizable');
    expect(
      resizableDoc.exports,
      containsAll(<String>['ElResizablePanelGroup', 'ElResizablePanel']),
    );
    expect(tester.takeException(), isNull);
  });
}
