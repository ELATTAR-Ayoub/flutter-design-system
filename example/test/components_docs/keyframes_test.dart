import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/keyframes/meta.dart';
import 'package:example/components_docs/keyframes/page.dart';
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

/// The fourteen keyframe tables `lib/src/components/ui/keyframes.dart` exports,
/// by the class name the API Reference documents them under.
const List<String> _keyframeNames = <String>[
  'EntranceMotion',
  'StateChangeMotion',
  'SpringEntranceMotion',
  'OpenMotion',
  'DiscreteProgressMotion',
  'TextRevealMotion',
  'RevealMotion',
  'LoadingShimmerMotion',
  'LivePulseMotion',
  'SweepMotion',
  'TravelMotion',
  'CheckmarkDrawMotion',
  'DashDrawMotion',
  'DotSelectionMotion',
];

const List<String> _exampleKeys = <String>[
  'keyframes-example:static',
  'keyframes-example:pop-in',
  'keyframes-example:jelly',
  'keyframes-example:spring-up',
  'keyframes-example:jelly-in',
  'keyframes-example:sign-on',
  'keyframes-example:reveal',
  'keyframes-example:ratchet',
  'keyframes-example:shimmer',
  'keyframes-example:pulse-live',
  'keyframes-example:sweep',
  'keyframes-example:travel',
  'keyframes-example:check-draw',
  'keyframes-example:dash-draw',
  'keyframes-example:dot-pop',
  'keyframes-example:swap-roll',
];

void main() {
  group('keyframes docs page', () {
    testWidgets('renders the article and the full fourteen-row API table', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      String? destination;
      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: KeyframesDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('keyframes-doc-article')),
        findsOneWidget,
      );

      final Finder apiTrigger = _disclosureTrigger('API Reference');
      await tester.ensureVisible(apiTrigger);
      await tester.pump();
      await tester.tap(apiTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      for (final String name in _keyframeNames) {
        expect(find.text(name), findsWidgets, reason: 'missing $name');
      }
      // ContentSwapMotion is named in the API Reference's own paragraph, not as
      // a table row: it is the fifteenth entry, and explicitly not one
      // of the fourteen.
      expect(find.textContaining('ContentSwapMotion'), findsWidgets);

      for (final String key in _exampleKeys) {
        expect(
          find.byKey(ValueKey<String>(key)),
          findsOneWidget,
          reason: 'missing example specimen $key',
        );
      }

      expect(keyframesDoc.name, 'keyframes');
      expect(keyframesDoc.exports, containsAll(_keyframeNames));
      expect(keyframesDoc.command, 'elattar add keyframes');
      expect(destination, isNull);
    });

    testWidgets(
      'the Preview replay button re-mounts the EntranceMotion specimen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const KeyframesDocPage(),
          ),
        );
        await tester.pump();

        final Finder replay = find.byKey(
          const ValueKey<String>('keyframes-example:preview-replay'),
        );
        await tester.ensureVisible(replay);
        await tester.pump();

        // Never pumpAndSettle: a bounded pump advances the one-shot player
        // partway, then the replay tap remounts it under a fresh key.
        await tester.pump();
        await tester.pump(MotionDurations.popIn);
        await tester.tap(replay);
        await tester.pump();
        expect(tester.takeException(), isNull);

        expect(
          find.byKey(const ValueKey<String>('keyframes-example:pop-in')),
          findsOneWidget,
        );
      },
    );

    testWidgets('the three loopers advance a bounded frame without throwing', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const KeyframesDocPage(),
        ),
      );
      await tester.pump();

      final Finder looping = find.byKey(
        const ValueKey<String>('keyframes-example:ratchet'),
      );
      await tester.ensureVisible(looping);
      await tester.pump();

      // DiscreteProgressMotion, LoadingShimmerMotion and LivePulseMotion all repeat() forever: two
      // bounded pumps, never pumpAndSettle.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 2));

      expect(tester.takeException(), isNull);
      for (final String key in <String>[
        'keyframes-example:ratchet',
        'keyframes-example:shimmer',
        'keyframes-example:pulse-live',
      ]) {
        expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
      }
    });

    testWidgets('the Transition specimen rolls on tap', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const KeyframesDocPage(),
        ),
      );
      await tester.pump();

      final Finder swapRoll = find.byKey(
        const ValueKey<String>('keyframes-example:swap-roll'),
      );
      await tester.ensureVisible(swapRoll);
      await tester.pump();

      await tester.tap(swapRoll);
      await tester.pump();
      await tester.pump(MotionDurations.slow);

      expect(tester.takeException(), isNull);
      expect(swapRoll, findsOneWidget);
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
          child: const KeyframesDocPage(),
        ),
      );
      await tester.pump();

      // Six EffectSection stages: Preview, Entrance & Exit, Looping,
      // Progress, Selection Draw, Transition.
      expect(find.byType(DocsShowcase), findsNWidgets(6));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        keyframesDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Entrance & Exit',
          'Looping',
          'Progress',
          'Selection Draw',
          'Transition',
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
          child: const KeyframesDocPage(),
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
        'Entrance & Exit',
        'Looping',
        'Progress',
        'Selection Draw',
        'Transition',
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
            child: const KeyframesDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('keyframes-doc-article')),
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
            child: const KeyframesDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('keyframes-doc-article')),
          findsOneWidget,
          reason: '$mode',
        );
        expect(tester.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
