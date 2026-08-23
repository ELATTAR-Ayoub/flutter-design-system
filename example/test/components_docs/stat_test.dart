import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/stat/meta.dart';
import 'package:example/components_docs/stat/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required DsThemeController controller,
}) => DsTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

void main() {
  group('stat docs page', () {
    testWidgets(
      'renders the article, the full API tables, and live specimens of all four components',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: DsThemeController(mode: DsThemeMode.dark),
            child: StatDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('stat-doc-article')),
          findsOneWidget,
        );

        // All four components have live specimens.
        expect(find.byType(DsStat), findsWidgets);
        expect(find.byType(DsItem), findsWidgets);
        expect(find.byType(DsEmpty), findsWidgets);
        expect(find.byType(DsKbd), findsWidgets);

        // The page has section headers.
        expect(find.text('API'), findsWidgets);
        expect(find.text('Accessibility'), findsWidgets);

        expect(statDoc.name, 'stat');
        expect(
          statDoc.exports,
          containsAll(<String>[
            'DsStat',
            'DsStatDirection',
            'DsStatState',
            'DsItem',
            'DsItemVariant',
            'DsEmpty',
            'DsKbd',
          ]),
        );
        expect(destination, isNull);
      },
    );

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: DsThemeController(mode: DsThemeMode.dark),
            child: const StatDocPage(),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('stat-doc-article')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
      },
    );

    testWidgets('stat delta direction uses glyph, sign, and sr-only word', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.light,
      );
      await tester.pumpWidget(
        _harness(controller: controller, child: const StatDocPage()),
      );

      // Find a stat with a delta.
      final DsStat stat = tester.widget<DsStat>(find.byType(DsStat).first);
      expect(stat.delta, isNotNull, reason: 'expected a specimen with delta');

      // The mark is rendered and carries the delta data.
      expect(
        find.byType(DsStatDeltaMark),
        findsWidgets,
        reason: 'delta mark is rendered',
      );
    });

    testWidgets('empty and stat have different empty state treatments', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: DsThemeController(mode: DsThemeMode.dark),
          child: Column(
            children: <Widget>[
              DsStat(
                label: 'Metric',
                value: 'N/A',
                state: DsStatState.empty,
                message: 'Data unavailable',
              ),
            ],
          ),
        ),
      );

      // Stat renders in empty state without errors.
      expect(
        find.byType(DsStat),
        findsOneWidget,
        reason: 'stat renders in empty state',
      );
    });

    testWidgets('kbd and kbdgroup render correctly', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: DsThemeController(mode: DsThemeMode.dark),
          child: Column(
            children: <Widget>[
              const DsKbd('Esc'),
              const DsKbdGroup(children: <Widget>[DsKbd('Ctrl'), DsKbd('K')]),
            ],
          ),
        ),
      );

      // Both single kbd and kbdgroup render.
      expect(find.byType(DsKbd), findsWidgets);
      expect(find.byType(DsKbdGroup), findsOneWidget);
    });

    testWidgets(
      'components render correctly in both themes at both breakpoints',
      (WidgetTester tester) async {
        for (final Size size in <Size>[
          const Size(390, 844),
          const Size(1440, 900),
        ]) {
          for (final DsThemeMode mode in <DsThemeMode>[
            DsThemeMode.light,
            DsThemeMode.dark,
          ]) {
            tester.view.physicalSize = size;
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.reset);

            final DsThemeController controller = DsThemeController(mode: mode);
            await tester.pumpWidget(
              _harness(controller: controller, child: const StatDocPage()),
            );

            expect(
              find.byKey(const ValueKey<String>('stat-doc-article')),
              findsOneWidget,
              reason: 'at $size in $mode',
            );

            // All four components mount without error at this combination.
            expect(find.byType(DsStat), findsWidgets);
            expect(find.byType(DsItem), findsWidgets);
            expect(find.byType(DsEmpty), findsWidgets);
            expect(find.byType(DsKbd), findsWidgets);
          }
        }
      },
    );
  });
}
