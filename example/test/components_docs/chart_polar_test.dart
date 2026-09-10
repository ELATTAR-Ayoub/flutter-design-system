/// Covers `/components/chart` — one of four routes that now render the
/// same consolidated chart-family page
/// (`example/lib/components_docs/chart/consolidated.dart`). See that
/// file's doc comment, and `example/test/docs/docs_install_test.dart`'s
/// "several registry names may legitimately share one documentation page"
/// test, for why four routes converging on one body is deliberate rather
/// than a drift to catch.
///
/// What this test dropped from the pre-consolidation `chart_test.dart`,
/// and why: the per-export API assertion used to loop over every name in
/// `chartDoc.exports` (thirteen, including `ChartScope`, `ChartMotion`,
/// `ChartText` — internals a consumer never constructs directly) and
/// require each to appear as a table title. The consolidated page
/// documents the condensed surface a caller actually touches instead (see
/// `_condensedApiNames` below); the full export list stays true as
/// `chartDoc.exports` and stays enforced there, it just is not what this
/// page enumerates row by row any more.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/chart_polar/meta.dart';
import 'package:example/components_docs/chart_polar/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/material.dart'
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
        TableColumnWidth,
        ActionChip,
        AlertDialog,
        Badge,
        Card,
        CarouselController,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        DrawerHeader,
        Slider,
        Switch,
        TextFormField,
        Tooltip;
import 'package:flutter_test/flutter_test.dart';

Widget _harness({required Widget child, required ThemeController controller}) =>
    ThemeScope(
      controller: controller,
      child: MaterialApp(
        home: Builder(
          builder: (BuildContext context) => DefaultTextStyle(
            style: StyledText.styleOf(
              context,
              TextStyles.body,
              color: ThemeScope.of(context).foreground,
            ),
            child: SingleChildScrollView(child: child),
          ),
        ),
      ),
    );

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// The condensed API surface the consolidated page documents — the types a
/// consumer actually touches building or theming a chart, not one row per
/// export. See `consolidated.dart`'s `_ApiReferenceContent`.
const List<String> _condensedApiNames = <String>[
  'ChartConfig',
  'ChartContainer',
  'ChartTooltipContent',
  'ChartLegendContent',
  'CartesianChart',
  'ChartSeriesSpec',
  'Axes & Grid',
  'PieChart',
  'RadarChart',
  'RadialBarChart',
  'chartNumber',
];

const List<String> _sectionTitles = <String>[
  'Preview',
  'Installation',
  'Usage',
  'API Reference',
  'States',
  'Accessibility',
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

void main() {
  group('chart-polar docs page (consolidated chart family)', () {
    testWidgets(
      'renders the article and the condensed API surface, with its own '
      'install command',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: ChartPolarDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('chart-polar-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String name in _condensedApiNames) {
          expect(find.text(name), findsWidgets, reason: 'missing $name');
        }

        expect(
          find.byKey(const ValueKey<String>('chart-family-preview:area')),
          findsOneWidget,
        );

        expect(chartPolarDoc.name, 'chart_polar');
        expect(chartPolarDoc.command, 'elattar add chart-polar');
        expect(destination, isNull);
      },
    );

    testWidgets(
      'the CLI pane on /components/chart-polar prints this item\'s own command',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const ChartPolarDocPage(),
          ),
        );
        await tester.pump();

        expect(
          tester.widget<DocsInstall>(find.byType(DocsInstall)).command,
          'elattar add chart-polar',
        );
      },
    );

    testWidgets('the page is declared, and every section is a kit component', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const ChartPolarDocPage(),
        ),
      );
      await tester.pump();

      // One specimen stage: Preview.
      expect(find.byType(DocsShowcase), findsNWidgets(1));
      expect(find.byType(DocsInstall), findsOneWidget);
      // Eight collapsed sections: API Reference, States, Accessibility,
      // Keyboard, Responsive, Dependencies, Theming, Source.
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        chartPolarDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        _sectionTitles,
      );
    });

    testWidgets('sections render in declaration order', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(controller: controller, child: const ChartPolarDocPage()),
      );
      await tester.pump();

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, _sectionTitles);
    });

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const ChartPolarDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('chart-polar-doc-article')),
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
      'losing the preview specimen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ThemeController controller = ThemeController(
          mode: ColorMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const ChartPolarDocPage()),
        );
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('chart-polar-doc-article')),
          ),
        );

        controller.setMode(ColorMode.light);
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('chart-polar-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        expect(
          find.byKey(const ValueKey<String>('chart-family-preview:area')),
          findsOneWidget,
        );
      },
    );
  });
}
