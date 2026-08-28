import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/premium_surface/meta.dart';
import 'package:example/components_docs/premium_surface/page.dart';
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

/// Every named constructor parameter `PremiumSurface`'s own class declares
/// (`lib/src/components/ui/premium_surface.dart`), excluding `key`.
const List<String> _foilValueConstructorParams = <String>[
  'spec',
  'radius',
  'border',
  'hovered',
  'child',
];

void main() {
  group('premium-surface docs page', () {
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
          child: PremiumSurfaceDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      // One frame only — never pumpAndSettle: the foil drift and the
      // glint sweep both run on a Ticker that repeats forever.
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('premium-surface-doc-article')),
        findsOneWidget,
      );

      final Finder apiTrigger = _disclosureTrigger('API Reference');
      await tester.ensureVisible(apiTrigger);
      await tester.pump();
      await tester.tap(apiTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      for (final String param in _foilValueConstructorParams) {
        expect(find.text(param), findsWidgets, reason: 'missing $param');
      }

      for (final String key in <String>[
        'premium-surface-example:flat',
        'premium-surface-example:preview',
        'premium-surface-example:rest',
        'premium-surface-example:hovered',
        'premium-surface-example:motion',
        'premium-surface-example:reduced-motion',
      ]) {
        expect(
          find.byKey(ValueKey<String>(key)),
          findsOneWidget,
          reason: 'missing example specimen $key',
        );
      }

      // A live PremiumSurface specimen mounts for preview, hovered (x2)
      // and reduced motion (x2) — five in total.
      expect(find.byType(PremiumSurface), findsNWidgets(5));

      // The Hovered example specimens actually carry the hovered value
      // their key claims.
      final PremiumSurface rest = tester.widget<PremiumSurface>(
        find.descendant(
          of: find.byKey(
            const ValueKey<String>('premium-surface-example:rest'),
          ),
          matching: find.byType(PremiumSurface),
        ),
      );
      expect(rest.hovered, isFalse);
      final PremiumSurface hovered = tester.widget<PremiumSurface>(
        find.descendant(
          of: find.byKey(
            const ValueKey<String>('premium-surface-example:hovered'),
          ),
          matching: find.byType(PremiumSurface),
        ),
      );
      expect(hovered.hovered, isTrue);

      expect(premiumSurfaceDoc.name, 'premium_surface');
      expect(
        premiumSurfaceDoc.exports,
        containsAll(<String>['PremiumSurface']),
      );
      expect(premiumSurfaceDoc.command, 'elattar add premium-surface');
      expect(destination, isNull);
    });

    testWidgets(
      'advances the foil and glint clocks by a frame without throwing',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const PremiumSurfaceDocPage(),
          ),
        );
        await tester.pump();
        // Advance the shared Ticker by a bounded duration — never
        // pumpAndSettle, which would hang on a perpetual animation.
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(seconds: 2));

        expect(tester.takeException(), isNull);
        expect(find.byType(PremiumSurface), findsNWidgets(5));
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
          child: const PremiumSurfaceDocPage(),
        ),
      );
      await tester.pump();

      // Three specimen stages: Preview, Hovered, Reduced Motion.
      expect(find.byType(DocsShowcase), findsNWidgets(3));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        foilValueDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Hovered',
          'Reduced Motion',
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

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(controller: controller, child: const PremiumSurfaceDocPage()),
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
        'Hovered',
        'Reduced Motion',
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
            child: const PremiumSurfaceDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('premium-surface-doc-article')),
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
            child: const PremiumSurfaceDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('premium-surface-doc-article')),
          findsOneWidget,
          reason: '$mode',
        );
        expect(tester.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
