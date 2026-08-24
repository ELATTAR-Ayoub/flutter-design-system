import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/stat/meta.dart';
import 'package:example/components_docs/stat/page.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required ElThemeController controller,
}) => ElTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

void main() {
  group('stat docs page', () {
    testWidgets(
      'renders the article, the full API tables, and live specimens of ElStat',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: StatDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('stat-doc-article')),
          findsOneWidget,
        );

        expect(find.byType(ElStat), findsWidgets);
        // item/empty/kbd are their own pages now: no live specimens here.
        expect(find.byType(ElItem), findsNothing);
        expect(find.byType(ElEmpty), findsNothing);
        expect(find.byType(ElKbd), findsNothing);

        final List<String> sectionTitles = tester
            .widgetList<ElSection>(find.byType(ElSection))
            .map((ElSection section) => section.title)
            .toList();
        expect(sectionTitles, contains('API Reference'));
        expect(sectionTitles, contains('Accessibility'));

        expect(statDoc.name, 'stat');
        expect(
          statDoc.exports,
          containsAll(<String>[
            'ElStat',
            'ElStatDirection',
            'ElStatState',
            'ElStatDeltaMark',
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
            controller: ElThemeController(mode: ElThemeMode.dark),
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

      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.light,
      );
      await tester.pumpWidget(
        _harness(controller: controller, child: const StatDocPage()),
      );

      final ElStat stat = tester.widget<ElStat>(find.byType(ElStat).first);
      expect(stat.delta, isNotNull, reason: 'expected a specimen with delta');

      expect(
        find.byType(ElStatDeltaMark),
        findsWidgets,
        reason: 'delta mark is rendered',
      );
    });

    testWidgets('stat renders correctly in every ElStatState', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ElThemeController(mode: ElThemeMode.dark),
          child: const StatDocPage(),
        ),
      );

      for (final ElStatState state in ElStatState.values) {
        expect(
          find.byWidgetPredicate((Widget w) => w is ElStat && w.state == state),
          findsWidgets,
          reason: 'missing a $state specimen',
        );
      }
    });

    testWidgets(
      'components render correctly in both themes at both breakpoints',
      (WidgetTester tester) async {
        for (final Size size in <Size>[
          const Size(390, 844),
          const Size(1440, 900),
        ]) {
          for (final ElThemeMode mode in <ElThemeMode>[
            ElThemeMode.light,
            ElThemeMode.dark,
          ]) {
            tester.view.physicalSize = size;
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.reset);

            final ElThemeController controller = ElThemeController(mode: mode);
            await tester.pumpWidget(
              _harness(controller: controller, child: const StatDocPage()),
            );

            expect(
              find.byKey(const ValueKey<String>('stat-doc-article')),
              findsOneWidget,
              reason: 'at $size in $mode',
            );

            expect(find.byType(ElStat), findsWidgets);
          }
        }
      },
    );

    testWidgets(
      'renders the ours-only section list, in order: Installation, Usage, '
      'then stat\'s own sections, then API Reference, then the six extra '
      'sections',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const StatDocPage(),
          ),
        );

        final List<ElSection> sections = tester
            .widgetList<ElSection>(find.byType(ElSection))
            .toList();
        final List<String> sectionIds = sections
            .map((ElSection section) => section.id)
            .toList();
        final List<String> sectionTitles = sections
            .map((ElSection section) => section.title)
            .toList();

        expect(sectionIds, <String>[
          'install',
          'usage',
          'composition',
          'delta',
          'states-demo',
          'rtl',
          'api',
          'states',
          'accessibility',
          'responsive',
          'dependencies',
          'theming',
          'source',
        ]);

        expect(sectionTitles, isNot(contains('Item: Variant')));
        expect(sectionTitles, isNot(contains('Empty: Input group')));
        expect(sectionTitles, isNot(contains('Kbd: Group')));

        expect(
          sectionTitles,
          containsAll(<String>[
            'Composition',
            'Delta and direction',
            'Loading, error, and empty',
            'RTL',
            'API Reference',
            'States',
            'Accessibility',
            'Responsive',
            'Dependencies',
            'Theming',
            'Source',
          ]),
        );
      },
    );
  });
}
