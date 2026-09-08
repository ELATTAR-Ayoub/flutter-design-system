// example/test/pages/charts_page_render_test.dart
/// Characterization test for `example/lib/pages/charts.dart`'s [ChartsPage].
///
/// Runs before any specimen extraction and records what the page renders
/// today: how many [Panel] specimens it carries and which section headings
/// are present. Later tasks move seventy chart specimens out of this file
/// into their own docs pages; this test is the control that proves that
/// refactor changes nothing visible.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/pages/charts.dart';
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

Future<void> _pumpChartsPage(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1600, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ThemeScope(
      controller: ThemeController(mode: ColorMode.light),
      child: const Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData(size: Size(1600, 2400)),
          child: SingleChildScrollView(child: ChartsPage()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the reference page still carries every specimen panel', (
    WidgetTester tester,
  ) async {
    await _pumpChartsPage(tester);
    expect(tester.takeException(), isNull);

    // Seventy family specimens plus unit activity and conversion funnel.
    expect(find.byType(Panel), findsNWidgets(72));
  });

  testWidgets('every section heading is still present', (
    WidgetTester tester,
  ) async {
    await _pumpChartsPage(tester);

    for (final String title in <String>[
      'Area',
      'Bar',
      'Line',
      'Pie',
      'Radar',
      'Radial',
    ]) {
      expect(find.text(title), findsWidgets, reason: title);
    }
    expect(tester.takeException(), isNull);
  });
}
