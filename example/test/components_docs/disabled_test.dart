import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/disabled/meta.dart';
import 'package:example/components_docs/disabled/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
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

/// Every named constructor parameter `Disabled`'s own class declares
/// (`lib/src/components/ui/disabled.dart`), excluding `key`.
const List<String> _disabledConstructorParams = <String>[
  'disabled',
  'child',
  'reason',
  'onDisabledTap',
  'blockPointer',
  'duration',
];

const List<String> _exampleKeys = <String>[
  'disabled-example:disabled-button',
  'disabled-example:enabled-button',
  'disabled-example:reason-tooltip-input',
  'disabled-example:tap-while-disabled',
];

void main() {
  group('disabled docs page', () {
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
          child: DisabledDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('disabled-doc-article')),
        findsOneWidget,
      );

      final Finder apiTrigger = _disclosureTrigger('API Reference');
      await tester.ensureVisible(apiTrigger);
      await tester.pump();
      await tester.tap(apiTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      for (final String param in _disabledConstructorParams) {
        expect(find.text(param), findsWidgets, reason: 'missing $param');
      }

      for (final String key in _exampleKeys) {
        expect(
          find.byKey(ValueKey<String>(key)),
          findsOneWidget,
          reason: 'missing example specimen $key',
        );
      }

      expect(disabledDoc.name, 'disabled');
      expect(disabledDoc.exports, containsAll(<String>['Disabled']));
      expect(disabledDoc.command, 'elattar add disabled');
      expect(destination, isNull);
    });

    testWidgets('tapping the "Tap while disabled" specimen fires the hook', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const DisabledDocPage(),
        ),
      );
      await tester.pump();

      final Finder specimen = find.byKey(
        const ValueKey<String>('disabled-example:tap-while-disabled'),
      );
      await tester.ensureVisible(specimen);
      await tester.pump();

      expect(find.text('Disabled taps: 0'), findsOneWidget);

      await tester.tap(specimen);
      await tester.pump();
      expect(find.text('Disabled taps: 1'), findsOneWidget);

      await tester.tap(specimen);
      await tester.pump();
      expect(find.text('Disabled taps: 2'), findsOneWidget);
    });

    testWidgets(
      'hovering the disabled Preview button opens the reason tooltip',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const DisabledDocPage(),
          ),
        );
        await tester.pump();

        final Finder trigger = find.byKey(
          const ValueKey<String>('disabled-example:disabled-button'),
        );
        await tester.ensureVisible(trigger);
        await tester.pump();

        final TestGesture pointer = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        addTearDown(pointer.removePointer);
        await pointer.addPointer(location: Offset.zero);

        await pointer.moveTo(tester.getCenter(trigger));
        await tester.pump();
        expect(find.text('Connect a wallet to continue'), findsNothing);

        await tester.pump(MotionDurations.tooltipShowDelay);
        await tester.pump(MotionDurations.overlayEnter);
        expect(find.text('Connect a wallet to continue'), findsOneWidget);

        await pointer.moveTo(const Offset(1, 1));
        await tester.pump();
        await tester.pump(MotionDurations.overlayEnter);
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
          child: const DisabledDocPage(),
        ),
      );
      await tester.pump();

      // Three ShowcaseSection stages: Preview, Reason tooltip, Tap while
      // disabled.
      expect(find.byType(DocsShowcase), findsNWidgets(3));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(9));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        disabledDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Reason tooltip',
          'Tap while disabled',
          'Pointer block',
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
          child: const DisabledDocPage(),
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
        'Reason tooltip',
        'Tap while disabled',
        'Pointer block',
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
            child: const DisabledDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('disabled-doc-article')),
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
            child: const DisabledDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('disabled-doc-article')),
          findsOneWidget,
          reason: '$mode',
        );
        expect(tester.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
