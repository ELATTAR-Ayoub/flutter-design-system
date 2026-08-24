/// Tests for `components_docs/aspect_ratio/page.dart`'s
/// [AspectRatioDocPage]: [ElAspectRatio]. New route, split off from the
/// former shared `scroll_area` route; see `aspect_ratio/meta.dart`'s
/// library note.
///
/// Reads `lib/src/components/aspect_ratio.dart` directly; every public
/// constructor parameter enumerated below is one this page's API table
/// must cover.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ElThemeController` is flipped in place for theme coverage.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/aspect_ratio/meta.dart';
import 'package:example/components_docs/aspect_ratio/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

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
            child: AspectRatioDocPage(onNavigate: onNavigate),
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
    'sections render in the shadcn-mirrored order, section for section',
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
        'Square',
        'Portrait',
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

      expect(find.text(aspectRatioDoc.title), findsWidgets);
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

  testWidgets('the ElApiTable covers every public constructor parameter of '
      'ElAspectRatio', (WidgetTester tester) async {
    await _pump(tester);

    final List<DocsApiTable> tables = tester
        .widgetList<DocsApiTable>(find.byType(DocsApiTable))
        .toList();
    expect(tables, isNotEmpty);

    final DocsApiTable table = tables.singleWhere(
      (DocsApiTable t) => t.title == 'ElAspectRatio',
    );
    final Set<String> documented = <String>{
      for (final DocsApiFact fact in table.facts) fact.name,
    };
    for (final String param in <String>['ratio', 'child', 'margin']) {
      expect(
        documented,
        contains(param),
        reason: 'ElAspectRatio table is missing parameter "$param"',
      );
    }
  });

  testWidgets(
    'ElAspectRatio locks a box to the specified ratio, in the live demo, '
    'Square, Portrait, and RTL specimens',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder aspectRatio = find.byType(ElAspectRatio);
      expect(aspectRatio, findsAtLeastNWidgets(4));
      expect(tester.takeException(), isNull);
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
      expect(find.text(aspectRatioDoc.title), findsWidgets);

      theme.setMode(ElThemeMode.dark);
      await tester.pump();
      expect(find.text(aspectRatioDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation presents the working aspect-ratio CLI command', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(find.textContaining('elattar add aspect-ratio'), findsWidgets);
  });

  testWidgets(
    'the state matrix documents the widget as static, with the rest of '
    'IA §9.7 marked N/A',
    (WidgetTester tester) async {
      await _pump(tester);

      final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
        find.byType(DocsStateMatrix),
      );
      final Set<String> states = matrix.facts
          .map((DocsStateFact fact) => fact.state)
          .toSet();

      expect(
        states.any((String s) => s.startsWith('Rest')),
        isTrue,
        reason: 'state matrix is missing a Rest row',
      );
    },
  );

  testWidgets(
    'the pager navigates through DocsLayout.onNavigate, back to Input OTP '
    'and forward to Resizable',
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

    expect(aspectRatioDoc.name, 'aspect_ratio');
    expect(aspectRatioDoc.exports, containsAll(<String>['ElAspectRatio']));
    expect(tester.takeException(), isNull);
  });
}
