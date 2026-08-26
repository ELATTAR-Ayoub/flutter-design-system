/// Theming page rendering tests.
///
/// This page's only `DocsSnippet` (the `ElThemeData.light` excerpt under
/// "Source-mode customization") carries a `maxHeight`, so it is the one
/// place on the page that needs its own proof the expansion control
/// actually works, rather than trusting the parameter was set correctly.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_snippet.dart';
import 'package:example/docs_pages/theming_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => ElTheme(
  controller: ElThemeController(mode: ElThemeMode.dark),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SingleChildScrollView(child: child),
  ),
);

void _sizeTo(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('the page mounts its article with no exception', (
    WidgetTester tester,
  ) async {
    _sizeTo(tester, const Size(1440, 4000));

    await tester.pumpWidget(_host(const ThemingDocsPage()));
    await tester.pump();

    expect(
      find.byKey(const ValueKey<String>('theming-doc-article')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'the ElThemeData.light excerpt is capped, and its expansion control '
    'actually expands and collapses it',
    (WidgetTester tester) async {
      _sizeTo(tester, const Size(1440, 4000));

      await tester.pumpWidget(_host(const ThemingDocsPage()));
      await tester.pump();

      // This page has exactly one capped snippet, so finding a
      // `DocsSnippetOverflow` at all is proof the cap reached the widget.
      final Finder overflow = find.byType(DocsSnippetOverflow);
      expect(overflow, findsOneWidget);
      expect(find.text('Show more'), findsOneWidget);
      expect(find.text('Show less'), findsNothing);

      final double collapsedHeight = tester.getSize(overflow).height;

      await tester.ensureVisible(find.text('Show more'));
      await tester.pump();
      await tester.tap(find.text('Show more'));
      await tester.pump();
      await tester.pump(ElDurations.jelly);

      expect(find.text('Show less'), findsOneWidget);
      expect(find.text('Show more'), findsNothing);
      final double expandedHeight = tester.getSize(overflow).height;
      expect(expandedHeight, greaterThan(collapsedHeight));

      await tester.ensureVisible(find.text('Show less'));
      await tester.pump();
      await tester.tap(find.text('Show less'));
      await tester.pump();
      await tester.pump(ElDurations.jelly);

      expect(find.text('Show more'), findsOneWidget);
      expect(tester.getSize(overflow).height, collapsedHeight);

      expect(tester.takeException(), isNull);
    },
  );
}
