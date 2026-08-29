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

/// The union of every named constructor parameter `PieChart`,
/// `RadarChart` and `RadialBarChart` declare
/// (`lib/src/components/ui/chart_polar.dart`), excluding `key`.
const List<String> _polarConstructorParams = <String>[
  'pies',
  'legend',
  'tooltip',
  'centerLabel',
  'labelColor',
  'data',
  'series',
  'grid',
  'angleAxis',
  'radiusAxis',
  'margin',
  'innerRadius',
  'outerRadius',
  'startAngle',
  'endAngle',
];

const List<String> _exampleKeys = <String>[
  'chart-polar-preview:pie',
  'chart-polar-preview:radar',
  'chart-polar-preview:radial',
  'chart-polar-example:pie-simple',
  'chart-polar-example:pie-donut',
  'chart-polar-example:pie-active',
  'chart-polar-example:pie-outside-label',
  'chart-polar-example:radar-filled',
  'chart-polar-example:radar-two-series',
  'chart-polar-example:radial-simple',
  'chart-polar-example:radial-label',
  'chart-polar-example:pie-legend',
  'chart-polar-example:pie-tooltip-pinned',
];

const List<String> _sectionTitles = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Pie',
  'Active & Labels',
  'Radar',
  'Radial Bar',
  'Legend & Tooltip',
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
  group('chart-polar docs page', () {
    testWidgets('renders the article and the full API table for every exported '
        'class, enum and constructor parameter this page claims to document', (
      WidgetTester tester,
    ) async {
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

      for (final String export in chartPolarDoc.exports) {
        expect(find.text(export), findsWidgets, reason: 'missing $export');
      }

      for (final String param in _polarConstructorParams) {
        expect(
          find.text(param),
          findsWidgets,
          reason:
              '$param is a constructor parameter and must be '
              'documented',
        );
      }

      for (final String key in _exampleKeys) {
        expect(
          find.byKey(ValueKey<String>(key)),
          findsOneWidget,
          reason: 'missing example specimen $key',
        );
      }

      expect(chartPolarDoc.name, 'chart_polar');
      expect(chartPolarDoc.command, 'elattar add chart-polar');
      expect(destination, isNull);
    });

    testWidgets('the page is declared, and every section is a kit component', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 6000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const ChartPolarDocPage(),
        ),
      );
      await tester.pump();

      // Six specimen stages: Preview, Pie, Active & Labels, Radar,
      // Radial Bar, Legend & Tooltip.
      expect(find.byType(DocsShowcase), findsNWidgets(6));
      expect(find.byType(DocsInstall), findsOneWidget);
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
      tester.view.physicalSize = const Size(1440, 6000);
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
      'losing any example specimen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 4000);
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

        for (final String key in <String>[
          'chart-polar-preview:pie',
          'chart-polar-example:pie-simple',
          'chart-polar-example:radar-filled',
          'chart-polar-example:radial-simple',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
      },
    );
  });
}
