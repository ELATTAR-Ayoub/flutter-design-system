import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/stat/meta.dart';
import 'package:example/components_docs/stat/page.dart';
import 'package:example/kit.dart' show DsSection;
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

        // The page has section headers. Read the mounted DsSection titles
        // rather than free text: the wide-viewport table of contents rail
        // renders every section title a second time, so a bare find.text
        // is not a reliable "this section exists" check.
        final List<String> sectionTitles = tester
            .widgetList<DsSection>(find.byType(DsSection))
            .map((DsSection section) => section.title)
            .toList();
        expect(sectionTitles, contains('API Reference'));
        expect(sectionTitles, contains('Accessibility'));

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

    testWidgets(
      'renders the shadcn-shaped section list, in order: the shared frame '
      'sections, then each component\'s own promoted sections grouped under '
      'its own name, then API Reference, then the six extra sections',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: DsThemeController(mode: DsThemeMode.dark),
            child: const StatDocPage(),
          ),
        );

        // Read the mounted DsSection widgets in tree order rather than
        // text-finding each heading: the wide-viewport table of contents
        // rail renders every section title a second time, and this page
        // (four components on one page) also carries nested sub-headings
        // that can repeat a top-level title's own text, so a find.text
        // based structural check is not reliable here.
        final List<DsSection> sections = tester
            .widgetList<DsSection>(find.byType(DsSection))
            .toList();
        final List<String> sectionIds = sections
            .map((DsSection section) => section.id)
            .toList();
        final List<String> sectionTitles = sections
            .map((DsSection section) => section.title)
            .toList();

        expect(sectionIds, <String>[
          'install',
          'usage',
          'composition',
          'stat-delta',
          'stat-states',
          'item-vs-field',
          'item-variant',
          'item-icon',
          'item-avatar',
          'item-group',
          'empty-input-group',
          'kbd-group',
          'kbd-button',
          'kbd-input-group',
          'rtl',
          'api',
          'states',
          'accessibility',
          'responsive',
          'dependencies',
          'theming',
          'source',
        ]);

        // No leftover "Overview", "Preview" as second heading, or "Variants"
        // headings: Overview's prose moved into Preview (which stands in for
        // shadcn's unheaded live demo), and the enum tables that used to sit
        // under a standalone "Variants" heading moved into API Reference.
        expect(sectionTitles, isNot(contains('Overview')));
        expect(sectionTitles, isNot(contains('Variants and sizes')));
        expect(sectionTitles, isNot(contains('Status')));

        // Every promoted section names the component it belongs to.
        expect(
          sectionTitles,
          containsAll(<String>[
            'Stat: Delta and direction',
            'Stat: Loading, error, and empty',
            'Item: Item vs Field',
            'Item: Variant',
            'Item: Icon',
            'Item: Avatar',
            'Item: Group',
            'Empty: Input group',
            'Kbd: Group',
            'Kbd: Button',
            'Kbd: Input group',
          ]),
        );

        // The six trailing sections carry exactly their required names.
        expect(
          sectionTitles,
          containsAll(<String>[
            'States',
            'Accessibility',
            'Responsive',
            'Dependencies',
            'Theming',
            'Source',
          ]),
        );

        expect(sectionTitles, contains('API Reference'));
        expect(sectionTitles, contains('RTL'));
        expect(sectionTitles, contains('Composition'));
      },
    );
  });
}
