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

/// The fourteen names the API Reference and the fourteen cards both show —
/// the twelve keyframe tables `lib/src/components/ui/keyframes.dart` exports,
/// plus `Press` and `ActiveIndicator`.
const List<String> _keyframeNames = <String>[
  'EnterMotion',
  'ExitMotion',
  'OpenMotion',
  'CloseMotion',
  'ExpandMotion',
  'ChangeMotion',
  'SpinMotion',
  'ShimmerMotion',
  'ProgressMotion',
  'PulseMotion',
  'CaretMotion',
  'SwapRollMotion',
];

/// One card container per motion, keyed `keyframes-example:<id>`, in the
/// order the page declares them.
const List<String> _cardIds = <String>[
  'enter',
  'exit',
  'open',
  'close',
  'expand',
  'change',
  'spin',
  'shimmer',
  'progress',
  'pulse',
  'caret',
  'press',
  'toggle-slide',
  'swap-roll',
];

void main() {
  group('keyframes docs page', () {
    testWidgets('renders the article and the full twelve-row API table', (
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
      // SwapRollMotion is the twelfth table row AND gets its own paragraph
      // underneath, flagging it as the odd one out — a transition, not a
      // keyframe.
      expect(find.textContaining('SwapRollMotion'), findsWidgets);

      for (final String id in _cardIds) {
        expect(
          find.byKey(ValueKey<String>('keyframes-example:$id')),
          findsOneWidget,
          reason: 'missing card $id',
        );
      }
      expect(
        find.byKey(const ValueKey<String>('keyframes-example:replay-all')),
        findsOneWidget,
      );

      expect(keyframesDoc.name, 'keyframes');
      expect(keyframesDoc.exports, containsAll(_keyframeNames));
      expect(keyframesDoc.command, 'elattar add keyframes');
      expect(destination, isNull);
    });

    testWidgets(
      "the enter card's Replay button re-mounts its stage without throwing",
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
          const ValueKey<String>('keyframes-example:enter-replay'),
        );
        await tester.ensureVisible(replay);
        await tester.pump();

        // Never pumpAndSettle: a bounded pump advances the stagger partway,
        // then the replay tap remounts it under a fresh key.
        await tester.pump();
        await tester.pump(EnterMotion.duration);
        await tester.tap(replay);
        await tester.pump();
        expect(tester.takeException(), isNull);

        expect(
          find.byKey(const ValueKey<String>('keyframes-example:enter')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'the loopers (spin, shimmer, progress, pulse, caret) advance a '
      'bounded frame without throwing',
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

        final Finder spin = find.byKey(
          const ValueKey<String>('keyframes-example:spin'),
        );
        await tester.ensureVisible(spin);
        await tester.pump();

        // Every looper repeat()s forever: two bounded pumps, never
        // pumpAndSettle.
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(seconds: 2));

        expect(tester.takeException(), isNull);
        for (final String id in <String>[
          'spin',
          'shimmer',
          'progress',
          'pulse',
          'caret',
        ]) {
          expect(
            find.byKey(ValueKey<String>('keyframes-example:$id')),
            findsOneWidget,
          );
        }
      },
    );

    testWidgets(
      "the swap-roll card's Replay flips its transition without throwing",
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

        final Finder swapRoll = find.byKey(
          const ValueKey<String>('keyframes-example:swap-roll-replay'),
        );
        await tester.ensureVisible(swapRoll);
        await tester.pump();

        await tester.tap(swapRoll);
        await tester.pump();
        await tester.pump(MotionDurations.slow);
        // The beat reverts on its own after MotionDurations.hoverCardShowDelay.
        await tester.pump(MotionDurations.hoverCardShowDelay);

        expect(tester.takeException(), isNull);
        expect(
          find.byKey(const ValueKey<String>('keyframes-example:swap-roll')),
          findsOneWidget,
        );
      },
    );

    testWidgets('Replay all bumps every card without throwing', (
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

      final Finder replayAll = find.byKey(
        const ValueKey<String>('keyframes-example:replay-all'),
      );
      await tester.ensureVisible(replayAll);
      await tester.pump();

      await tester.tap(replayAll);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(MotionDurations.hoverCardShowDelay);

      expect(tester.takeException(), isNull);
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

      // One EffectSection stage: The fourteen.
      expect(find.byType(DocsShowcase), findsNWidgets(1));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        keyframesDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'The fourteen',
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
        'The fourteen',
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
