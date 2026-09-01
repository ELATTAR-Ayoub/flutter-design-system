import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/press/meta.dart';
import 'package:example/components_docs/press/page.dart';
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
          // The ambient ink every route inherits, as the docs shell sets it
          // for the real app. Without it this subtree sits under WidgetsApp's
          // red fallback style, which StyledText asserts on rather than
          // quietly painting over.
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

/// The scale a widget is currently drawn at, read off the first [Transform]
/// under [of] — the same idiom `test/motion_test.dart` uses for `Press`.
double _scaleOf(WidgetTester tester, Finder of) {
  final Transform transform = tester.widget<Transform>(
    find.descendant(of: of, matching: find.byType(Transform)).first,
  );
  return transform.transform.storage[0];
}

/// Every named constructor parameter `Press`'s own class declares
/// (`lib/src/components/ui/press.dart`), excluding `key`.
const List<String> _pressConstructorParams = <String>[
  'scale',
  'child',
  'onTap',
  'behavior',
  'downDuration',
  'upDuration',
];

const List<String> _exampleKeys = <String>[
  'press-example:wrapped',
  'press-example:bare',
  'press-example:press-scale',
  'press-example:button-scale',
  'press-example:click-spring-scale',
];

void main() {
  group('press docs page', () {
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
          child: PressDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('press-doc-article')),
        findsOneWidget,
      );

      final Finder apiTrigger = _disclosureTrigger('API Reference');
      await tester.ensureVisible(apiTrigger);
      await tester.pump();
      await tester.tap(apiTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      for (final String param in _pressConstructorParams) {
        expect(find.text(param), findsWidgets, reason: 'missing $param');
      }

      for (final String key in _exampleKeys) {
        expect(
          find.byKey(ValueKey<String>(key)),
          findsOneWidget,
          reason: 'missing example specimen $key',
        );
      }

      // One live Press on Preview's wrapped chip, three more on the
      // Custom Scale specimens, and one on the page's own breadcrumb link —
      // `Breadcrumb` goes through `Press` now, which is how its links became
      // keyboard-operable. Five in total. The right-hand Preview chip and
      // none of the Custom Scale captions mount one.
      expect(find.byType(Press), findsNWidgets(5));

      expect(pressDoc.name, 'press');
      expect(pressDoc.exports, containsAll(<String>['Press']));
      expect(pressDoc.command, 'elattar add press');
      expect(destination, isNull);
    });

    testWidgets(
      'a live pointer down/up on the Preview specimen actually squishes '
      'and springs back',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const PressDocPage(),
          ),
        );
        await tester.pump();

        final Finder wrapped = find.byKey(
          const ValueKey<String>('press-example:wrapped'),
        );
        await tester.ensureVisible(wrapped);
        await tester.pump();

        final Finder press = find.descendant(
          of: wrapped,
          matching: find.byType(Press),
        );
        expect(_scaleOf(tester, press), 1.0, reason: 'at rest');

        final TestGesture gesture = await tester.startGesture(
          tester.getCenter(press),
        );
        // Never pumpAndSettle: a bounded pump proves the controller ticked.
        await tester.pump();
        await tester.pump(MotionDurations.pressIn);
        expect(_scaleOf(tester, press), closeTo(MotionTransforms.press, 1e-6));

        await gesture.up();
        await tester.pump();
        await tester.pump(MotionDurations.normal);
        expect(_scaleOf(tester, press), closeTo(1.0, 1e-6));
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
          child: const PressDocPage(),
        ),
      );
      await tester.pump();

      // Two EffectSection stages: Preview, Custom Scale.
      expect(find.byType(DocsShowcase), findsNWidgets(2));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        pressMotionDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Custom Scale',
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
          child: const PressDocPage(),
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
        'Custom Scale',
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
            child: const PressDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('press-doc-article')),
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
            child: const PressDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('press-doc-article')),
          findsOneWidget,
          reason: '$mode',
        );
        expect(tester.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
