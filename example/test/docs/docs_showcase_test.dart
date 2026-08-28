// example/test/docs/docs_showcase_test.dart
/// The specimen frame — the component a reader sees most.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_showcase.dart';
import 'package:example/docs/docs_snippet.dart';
import 'package:flutter/widgets.dart'
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
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: ThemeScope(
    controller: ThemeController(mode: ColorMode.dark),
    child: child,
  ),
);

Widget _showcase() => const DocsShowcase(
  specimen: SizedBox(height: 40, width: 120),
  code: 'const SizedBox(height: 40, width: 120)',
);

void main() {
  testWidgets('it stands 384 tall at a wide viewport', (
    WidgetTester tester,
  ) async {
    // Was 640 — the reading column's own measure. Held against a real page
    // it was the wrong default by an order of magnitude: sixteen single
    // pills, each centred in its own 640 box, made the Button page
    // 17,925px tall. The default is now the short measure and a section
    // that needs the room asks for it. See DocsShowcase.tallMinHeight.
    tester.view.physicalSize = const Size(1440, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(_showcase()));
    await tester.pump();

    expect(tester.getSize(find.byType(DocsShowcaseFrame)).height, space(96));
  });

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
          minHeight: space(64),
        ),
      ),
    );
    await tester.pump();

    expect(tester.getSize(find.byType(DocsShowcaseFrame)).height, space(64));
  });

  testWidgets('a taller specimen still outgrows its minimum', (
    WidgetTester tester,
  ) async {
    // minHeight is a floor, never a ceiling — that is what makes lowering
    // the default safe: it removes empty space and crops nothing.
    tester.view.physicalSize = const Size(1440, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        DocsShowcase(
          specimen: const SizedBox(height: 900, width: 120),
          code: 'x',
          minHeight: space(64),
        ),
      ),
    );
    await tester.pump();

    expect(
      tester.getSize(find.byType(DocsShowcaseFrame)).height,
      greaterThan(900),
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
    expect(height, greaterThanOrEqualTo(space(96)));
    expect(
      height,
      lessThan(space(160)),
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
      _host(Column(children: <Widget>[_showcase(), _showcase()])),
    );
    await tester.pump();

    await tester.tap(find.text('Code').first);
    await tester.pump();

    // One switched; the other did not.
    expect(find.byType(DocsSnippet), findsOneWidget);
  });
}
