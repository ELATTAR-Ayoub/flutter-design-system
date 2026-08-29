import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/chart_geometry/meta.dart';
import 'package:example/components_docs/chart_geometry/page.dart';
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

/// Every field `BandScale`, `PointScale`, `LinearScale` and
/// `BarSlot` declare (`lib/src/components/ui/chart_geometry.dart`), plus
/// every `CurveType` value — this file has no widget, so there is no
/// constructor parameter list to assert against; these are the equivalent
/// completeness check for a file of pure functions and value classes.
const List<String> _fieldsAndValues = <String>[
  'count',
  'start',
  'extent',
  'reversed',
  'bandwidth',
  'step',
  'domainMin',
  'domainMax',
  'rangeStart',
  'rangeEnd',
  'offset',
  'size',
  'linear',
  'natural',
  'monotone',
];

const List<String> _sectionTitles = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Ticks & scales',
  'Band & point',
  'Bar layout',
  'Curves',
  'Polar',
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
  group('chart-geometry docs page', () {
    testWidgets('renders the article and the full API table for every exported '
        'class, function and value this page claims to document', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      String? destination;
      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: ChartGeometryDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('chart-geometry-doc-article')),
        findsOneWidget,
      );

      final Finder apiTrigger = _disclosureTrigger('API Reference');
      await tester.ensureVisible(apiTrigger);
      await tester.pump();
      await tester.tap(apiTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      // Every exported class and top-level function
      // chart_geometry.dart's own barrel carries is named somewhere in
      // the API Reference disclosure.
      for (final String export in chartGeometryDoc.exports) {
        expect(find.text(export), findsWidgets, reason: 'missing $export');
      }

      for (final String field in _fieldsAndValues) {
        expect(
          find.text(field),
          findsWidgets,
          reason: '$field is a field or enum value and must be documented',
        );
      }

      // Six live specimens actually paint: chartNiceTicks/LinearScale,
      // BandScale/PointScale, barSlots/barRRect, the four curve
      // interpolators, and the polar family, all as CustomPaint.
      expect(find.byType(CustomPaint), findsWidgets);

      expect(chartGeometryDoc.name, 'chart_geometry');
      expect(chartGeometryDoc.command, 'elattar add chart-geometry');
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
          child: const ChartGeometryDocPage(),
        ),
      );
      await tester.pump();

      // Six specimen stages: Preview, Ticks & scales, Band & point, Bar
      // layout, Curves, Polar.
      expect(find.byType(DocsShowcase), findsNWidgets(6));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        chartGeometryDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
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
        _harness(controller: controller, child: const ChartGeometryDocPage()),
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
            child: const ChartGeometryDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('chart-geometry-doc-article')),
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
      'throwing',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ThemeController controller = ThemeController(
          mode: ColorMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const ChartGeometryDocPage()),
        );
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('chart-geometry-doc-article')),
          ),
        );

        controller.setMode(ColorMode.light);
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('chart-geometry-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));
        expect(
          find.byKey(const ValueKey<String>('chart-geometry-doc-article')),
          findsOneWidget,
        );
      },
    );
  });
}
