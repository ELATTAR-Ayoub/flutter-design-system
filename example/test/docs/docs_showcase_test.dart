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
  child: ElTheme(
    controller: ElThemeController(mode: ElThemeMode.dark),
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
      tester.widget<ElToggleGroup>(find.byType(ElToggleGroup)).selectedIndex,
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
