import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/source_foundation/meta.dart';
import 'package:example/components_docs/source_foundation/page.dart';
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

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// The classes the API Reference documents, by row name — matching
/// `_apiFacts` in `page.dart`.
const List<String> _apiRowNames = <String>[
  'space',
  'LayoutWidths / Radii / Containers / Breakpoints / Blurs',
  'ThemeScope / ThemeTokens / ThemeController / ColorMode',
  'Palette / OklabColor',
  'TextStyles / ComponentTextStyles / TextStyleToken / StyledText',
  'MotionDurations / MotionCurves / MotionTransforms / effectiveMotionDuration',
  'Shadows / ShadowStyle / ShadowLayer',
  'SurfaceOpacity',
  'DateFormat',
];

const List<String> _exampleKeys = <String>[
  'source-foundation-example:preview',
  'source-foundation-example:color-background',
  'source-foundation-example:color-card',
  'source-foundation-example:color-primary',
  'source-foundation-example:color-secondary',
  'source-foundation-example:color-muted',
  'source-foundation-example:color-accent',
  'source-foundation-example:color-destructive',
  'source-foundation-example:type',
  'source-foundation-example:spacing',
  'source-foundation-example:motion-tick',
  'source-foundation-example:motion-base',
  'source-foundation-example:motion-slow',
  'source-foundation-example:shadow-e1',
  'source-foundation-example:shadow-e2',
  'source-foundation-example:shadow-e3',
  'source-foundation-example:shadow-e4',
];

void main() {
  group('source-foundation docs page', () {
    testWidgets('renders the article and the full API table', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      String? destination;
      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: SourceFoundationDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('source-foundation-doc-article')),
        findsOneWidget,
      );

      final Finder apiTrigger = _disclosureTrigger('API Reference');
      await tester.ensureVisible(apiTrigger);
      await tester.pump();
      await tester.tap(apiTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      for (final String name in _apiRowNames) {
        expect(find.text(name), findsWidgets, reason: 'missing $name');
      }

      for (final String key in _exampleKeys) {
        expect(
          find.byKey(ValueKey<String>(key)),
          findsOneWidget,
          reason: 'missing example specimen $key',
        );
      }

      expect(sourceFoundationDoc.name, 'source_foundation');
      expect(
        sourceFoundationDoc.exports,
        containsAll(<String>['ThemeScope', 'TextStyles', 'Shadows', 'space']),
      );
      expect(sourceFoundationDoc.command, 'elattar add source-foundation');
      expect(sourceFoundationDoc.dependencies, isEmpty);
      expect(destination, isNull);
    });

    testWidgets('a Motion chip animates on tap, without pumpAndSettle', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const SourceFoundationDocPage(),
        ),
      );
      await tester.pump();

      final Finder chip = find.byKey(
        const ValueKey<String>('source-foundation-example:motion-base'),
      );
      await tester.ensureVisible(chip);
      await tester.pump();

      await tester.tap(chip);
      await tester.pump();
      await tester.pump(MotionDurations.normal);

      expect(tester.takeException(), isNull);
      expect(chip, findsOneWidget);
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
          child: const SourceFoundationDocPage(),
        ),
      );
      await tester.pump();

      // Six EffectSection stages: Preview, Semantic Color, Type Ramp,
      // Spacing Rhythm, Motion, Shadow Elevation.
      expect(find.byType(DocsShowcase), findsNWidgets(6));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        sourceFoundationDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Semantic Color',
          'Type Ramp',
          'Spacing Rhythm',
          'Motion',
          'Shadow Elevation',
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

    testWidgets('sections render in declaration order', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const SourceFoundationDocPage(),
        ),
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
        'Semantic Color',
        'Type Ramp',
        'Spacing Rhythm',
        'Motion',
        'Shadow Elevation',
        'API Reference',
        'States',
        'Accessibility',
        'Keyboard',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);
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
            child: const SourceFoundationDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('source-foundation-doc-article')),
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

    testWidgets('renders in both themes without throwing', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      for (final ColorMode mode in <ColorMode>[
        ColorMode.dark,
        ColorMode.light,
      ]) {
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: mode),
            child: const SourceFoundationDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('source-foundation-doc-article')),
          findsOneWidget,
          reason: '$mode',
        );
        expect(tester.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
