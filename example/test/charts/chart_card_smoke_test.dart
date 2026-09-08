import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/charts/chart_card.dart';
import 'package:example/charts/chart_ink.dart';
import 'package:example/charts/specimens_area.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ChartSpecimenCard builds one specimen without throwing', (
    WidgetTester tester,
  ) async {
    final ThemeController controller = ThemeController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ThemeScope(
          controller: controller,
          child: Builder(
            builder: (BuildContext context) => ChartSpecimenCard(
              specimen: areaSpecimens.first,
              ink: ChartInk(ThemeScope.of(context)),
              writer: (String text) async {},
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(ChartSpecimenCard), findsOneWidget);
  });

  testWidgets(
    'ChartSpecimenCard footer does not overflow in a narrow card',
    (WidgetTester tester) async {
      final ThemeController controller = ThemeController();
      addTearDown(controller.dispose);

      // areaSpecimens.first has a real footer (trend + range) — 14 of the
      // 70 specimens have neither and render no footer, so they cannot
      // exercise this. 280 is narrow enough that the footer's trend row,
      // a full sentence like "Trending up by 5.2% this month" beside a
      // fixed-size icon, cannot lay out without wrapping.
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: ThemeScope(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) => Center(
                child: SizedBox(
                  width: 280,
                  child: ChartSpecimenCard(
                    specimen: areaSpecimens.first,
                    ink: ChartInk(ThemeScope.of(context)),
                    writer: (String text) async {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    },
  );
}
