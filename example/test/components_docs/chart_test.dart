import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/chart/meta.dart';
import 'package:example/components_docs/chart/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required ElThemeController controller,
}) => ElTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

/// The single `DocsDisclosure` whose title is [title], matching the kit's own
/// convention (`DocsDisclosure.triggerKey` is one constant shared by every
/// instance on the page).
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

void main() {
  group('chart docs page', () {
    testWidgets(
      'renders the article and the full API table for every exported class, '
      'enum and function this page claims to document',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: ChartDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // One frame is enough: nothing on this page loops.
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('chart-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        // Every exported class, enum, and function chart.dart's own barrel
        // carries is named somewhere in the API Reference disclosure.
        for (final String export in chartDoc.exports) {
          expect(find.text(export), findsWidgets, reason: 'missing $export');
        }

        // Every ElChartIndicator and ElChartLegendAlign enum value the
        // ElChartIndicator / ElChartLegendAlign tables claim to document.
        for (final ElChartIndicator value in ElChartIndicator.values) {
          expect(
            find.text(value.name),
            findsWidgets,
            reason: 'ElChartIndicator.${value.name} missing from API table',
          );
        }
        for (final ElChartLegendAlign value in ElChartLegendAlign.values) {
          expect(
            find.text(value.name),
            findsWidgets,
            reason: 'ElChartLegendAlign.${value.name} missing from API table',
          );
        }

        // Live specimens actually mount: ElChartTooltipContent in all three
        // ElChartIndicator styles, and both wrap: false / wrap: true legends.
        final Set<ElChartIndicator> mountedIndicators = tester
            .widgetList<ElChartTooltipContent>(
              find.byType(ElChartTooltipContent),
            )
            .map((ElChartTooltipContent w) => w.indicator)
            .toSet();
        expect(mountedIndicators, containsAll(ElChartIndicator.values));

        final Set<bool> mountedWrap = tester
            .widgetList<ElChartLegendContent>(find.byType(ElChartLegendContent))
            .map((ElChartLegendContent w) => w.wrap)
            .toSet();
        expect(mountedWrap, containsAll(<bool>[true, false]));

        // Every example specimen this page's own source keys carries its key
        // on the page.
        for (final String key in <String>[
          'chart-preview:tooltip',
          'chart-preview:legend',
          'chart-example:container-default',
          'chart-example:container-custom-height',
          'chart-example:tooltip-dot',
          'chart-example:tooltip-line',
          'chart-example:tooltip-dashed',
          'chart-example:legend-row',
          'chart-example:legend-wrap',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        expect(chartDoc.name, 'chart');
        expect(chartDoc.command, 'elattar add chart');
        expect(destination, isNull);
      },
    );

    testWidgets(
      'the page is declared, and every section is a kit component',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const ChartDocPage(),
          ),
        );
        await tester.pump();

        // Five specimen stages: Preview, Container, Tooltip, Legend, Number
        // formatting.
        expect(find.byType(DocsShowcase), findsNWidgets(5));
        expect(find.byType(DocsInstall), findsOneWidget);
        // Eight collapsed sections: API Reference, States, Accessibility,
        // Keyboard, Responsive, Dependencies, Theming, Source.
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        chartDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Container',
          'Tooltip',
          'Legend',
          'Number formatting',
          'API Reference',
          'States',
          'Accessibility',
          'Keyboard',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ],
      );
    });

    testWidgets(
      'sections render in declaration order',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const ChartDocPage()),
        );
        await tester.pump();

        final List<String> titles = tester
            .widgetList<DocsSection>(find.byType(DocsSection))
            .map((DocsSection section) => section.title)
            .toList();

        expect(titles, <String>[
          'Preview',
          'Installation',
          'Usage',
          'Container',
          'Tooltip',
          'Legend',
          'Number formatting',
          'API Reference',
          'States',
          'Accessibility',
          'Keyboard',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ]);
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
            child: const ChartDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('chart-doc-article')),
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

    testWidgets(
      'survives a live theme flip in place, at desktop width, without '
      'losing any example specimen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const ChartDocPage()),
        );
        await tester.pump();

        final ElThemeData darkTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('chart-doc-article')),
          ),
        );

        controller.setMode(ElThemeMode.light);
        await tester.pump();

        final ElThemeData lightTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('chart-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in <String>[
          'chart-preview:tooltip',
          'chart-preview:legend',
          'chart-example:container-default',
          'chart-example:tooltip-dot',
          'chart-example:legend-row',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
      },
    );
  });
}
