import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/safe_area/meta.dart';
import 'package:example/components_docs/safe_area/page.dart';
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

/// Every named constructor parameter `SafeArea`'s own class declares
/// (`lib/src/components/safe_area.dart`), excluding `key`.
const List<String> _safeAreaConstructorParams = <String>[
  'left',
  'top',
  'right',
  'bottom',
  'child',
];

/// `SafeArea`'s three static helpers.
const List<String> _safeAreaStaticMembers = <String>[
  'insetsOf',
  'topBarHeightOf',
  'scrollPaddingOf',
];

const List<String> _exampleKeys = <String>[
  'safe-area-example:without',
  'safe-area-example:with',
  'safe-area-example:scroll-zero',
  'safe-area-example:scroll-padded',
  'safe-area-example:desktop',
];

void main() {
  group('safe-area docs page', () {
    testWidgets('renders the article and both API tables', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      String? destination;
      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: SafeAreaDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('safe-area-doc-article')),
        findsOneWidget,
      );

      final Finder apiTrigger = _disclosureTrigger('API Reference');
      await tester.ensureVisible(apiTrigger);
      await tester.pump();
      await tester.tap(apiTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      for (final String param in _safeAreaConstructorParams) {
        expect(find.text(param), findsWidgets, reason: 'missing $param');
      }
      for (final String member in _safeAreaStaticMembers) {
        expect(find.text(member), findsWidgets, reason: 'missing $member');
      }

      for (final String key in _exampleKeys) {
        expect(
          find.byKey(ValueKey<String>(key)),
          findsOneWidget,
          reason: 'missing example specimen $key',
        );
      }

      expect(safeAreaDoc.name, 'safe_area');
      expect(safeAreaDoc.exports, containsAll(<String>['SafeArea']));
      expect(safeAreaDoc.command, 'elattar add safe-area');
      expect(destination, isNull);
    });

    testWidgets('under a simulated inset, the wrapped row sits lower than the '
        'unwrapped one', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const SafeAreaDocPage(),
        ),
      );
      await tester.pump();

      final Finder without = find.byKey(
        const ValueKey<String>('safe-area-example:without'),
      );
      final Finder withSafeArea = find.byKey(
        const ValueKey<String>('safe-area-example:with'),
      );
      await tester.ensureVisible(without);
      await tester.pump();

      // Both phone frames sit on the same row, so the frames themselves
      // start at the same y — the real proof is the icon row inside each
      // one, checked below.
      expect(
        tester.getTopLeft(withSafeArea).dy,
        closeTo(tester.getTopLeft(without).dy, 0.5),
      );

      final Finder withoutIcon = find
          .descendant(of: without, matching: find.byType(Icon))
          .first;
      final Finder withIcon = find
          .descendant(of: withSafeArea, matching: find.byType(Icon))
          .first;
      expect(
        tester.getTopLeft(withIcon).dy,
        greaterThan(tester.getTopLeft(withoutIcon).dy),
        reason:
            'the SafeArea-wrapped controls must sit lower than the '
            'unwrapped ones under the same simulated inset',
      );
    });

    testWidgets('the page is declared, and every section is a kit component', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 5000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const SafeAreaDocPage(),
        ),
      );
      await tester.pump();

      // Three EffectSection stages: Preview, Scroll Content, Desktop.
      expect(find.byType(DocsShowcase), findsNWidgets(3));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        safeAreaDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Scroll Content',
          'Desktop (Zero Insets)',
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

    test('the API Reference disclosure carries two sub-anchors', () {
      final DocsTocEntry api = safeAreaDocSpec.toc.singleWhere(
        (DocsTocEntry entry) => entry.anchor == 'api',
      );
      expect(api.children.map((DocsTocEntry e) => e.anchor).toList(), <String>[
        'api-elsafearea',
        'api-elsafearea-static',
      ]);
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
          child: const SafeAreaDocPage(),
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
        'Scroll Content',
        'Desktop (Zero Insets)',
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
            child: const SafeAreaDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('safe-area-doc-article')),
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
            child: const SafeAreaDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('safe-area-doc-article')),
          findsOneWidget,
          reason: '$mode',
        );
        expect(tester.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
