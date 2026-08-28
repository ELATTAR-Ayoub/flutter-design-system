import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/surface/meta.dart';
import 'package:example/components_docs/surface/page.dart';
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

/// Every named constructor parameter `Surface`'s own class
/// declares (`lib/src/components/ui/surface.dart`), excluding `key`.
const List<String> _machineSurfaceConstructorParams = <String>[
  'spec',
  'radius',
  'fill',
  'border',
  'child',
];

void main() {
  group('surface docs page', () {
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
          child: SurfaceDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      // One frame is enough — no pumpAndSettle: this page's own pages
      // family includes premium-surface, whose foil shimmer never settles,
      // and the rule is enforced across every documentation page.
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('surface-doc-article')),
        findsOneWidget,
      );

      final Finder apiTrigger = _disclosureTrigger('API Reference');
      await tester.ensureVisible(apiTrigger);
      await tester.pump();
      await tester.tap(apiTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      for (final String param in _machineSurfaceConstructorParams) {
        expect(find.text(param), findsWidgets, reason: 'missing $param');
      }

      // Every example specimen this page's own source keys carries its
      // key on the page.
      for (final String key in <String>[
        'surface-example:flat',
        'surface-example:preview',
        'surface-example:outer-only',
        'surface-example:inset',
        'surface-example:rest',
        'surface-example:pressed',
        'surface-example:no-border',
        'surface-example:with-border',
      ]) {
        expect(
          find.byKey(ValueKey<String>(key)),
          findsWidgets,
          reason: 'missing example specimen $key',
        );
      }

      // A live Surface specimen mounts for every facet section:
      // preview, inset-shadow (x2), pressed (x2), border (x1 — the
      // no-border specimen still goes through Surface with
      // border: null) — six of this page's own. Not an exact count: the
      // docs shell itself (ToggleGroup, badges, disclosure triggers)
      // composes Surface too, so more than six mount in total.
      expect(
        find.byType(Surface),
        findsAtLeastNWidgets(6),
        reason: 'at least one live Surface per facet specimen',
      );

      expect(surfaceDoc.name, 'surface');
      expect(surfaceDoc.exports, containsAll(<String>['Surface']));
      expect(surfaceDoc.command, 'elattar add surface');
      expect(destination, isNull);
    });

    testWidgets('the page is declared, and every section is a kit component', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const SurfaceDocPage(),
        ),
      );
      await tester.pump();

      // Five specimen stages: Preview, Inset Shadow, Pressed, Border —
      // wait, that is four EffectSections, each rendered as one
      // DocsShowcase.
      expect(find.byType(DocsShowcase), findsNWidgets(4));
      expect(find.byType(DocsInstall), findsOneWidget);
      // Eight collapsed sections: API Reference, States, Accessibility,
      // Keyboard, Responsive, Dependencies, Theming, Source.
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        machineSurfaceDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Inset Shadow',
          'Pressed',
          'Border',
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
        _harness(controller: controller, child: const SurfaceDocPage()),
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
        'Inset Shadow',
        'Pressed',
        'Border',
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
            child: const SurfaceDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('surface-doc-article')),
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

      for (final ColorMode mode in ColorMode.values) {
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: mode),
            child: const SurfaceDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('surface-doc-article')),
          findsOneWidget,
          reason: '$mode',
        );
        expect(tester.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
