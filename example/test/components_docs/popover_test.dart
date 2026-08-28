/// Tests for `components_docs/popover/meta.dart` and
/// `components_docs/popover/page.dart`: the public Popover component
/// documentation page.
///
/// Re-housed onto `ComponentDocSpec`/`ComponentDocPage`, the same shape
/// `button_test.dart` and `alert_dialog_test.dart` assert against: sections
/// read through `DocsSection.title`, and the API table (now inside a
/// `DocsDisclosure`, closed by default) is opened before its rows are read.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. Theme
/// coverage uses a live `ThemeController` flipped in place rather than two
/// independent pumps.
///
/// `Popover` mounts its content through an `OverlayPortal`, so the live
/// specimen needs a real `Overlay`: the harness wraps the page in a
/// `MaterialApp`. No `pumpAndSettle` is used anywhere on this page: the
/// `DocsDisclosure` chevron and the popover's own open/close transition are
/// both bounded, but `pumpAndSettle` is avoided uniformly across this
/// rollout in favour of explicit `pump()`/`pump(duration)` steps.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/popover/meta.dart';
import 'package:example/components_docs/popover/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
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

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

const List<String> _sectionOrder = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Composition',
  'Align',
  'Variants',
  'API Reference',
  'States',
  'Accessibility',
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

Future<ThemeController> _pumpPopoverDoc(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  ColorMode mode = ColorMode.dark,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ThemeController theme = ThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ThemeScope(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: PopoverDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  group('meta', () {
    test('popoverDoc names the real public API surface', () {
      expect(popoverDoc.name, 'popover');
      expect(popoverDoc.title, 'Popover');
      expect(popoverDoc.route, '/components/popover');
      expect(popoverDoc.command, 'elattar add popover');
      expect(popoverDoc.sourcePath, 'lib/src/components/popover.dart');
      expect(
        popoverDoc.exports,
        containsAll(<String>[
          'Popover',
          'PopoverSide',
          'PopoverAlign',
          'PopoverAnchorMode',
          'PopoverBarrier',
          'PopoverPlacement',
          'PopoverAnchorMetrics',
          'PopoverContentBuilder',
          'PopoverSurface',
          'popoverPlacement',
        ]),
      );
      // Matches registry/components/popover.json's registryDependencies
      // verbatim: popover already has a real manifest, so a worker that
      // invented a dependency name here would be the exact failure mode the
      // Phase J supervisor notes warn about.
      expect(popoverDoc.dependencies, <String>['surface', 'source-foundation']);
      // Short description: one sentence, no trailing ellipsis.
      expect(popoverDoc.description, isNot(contains('..')));
      expect(popoverDoc.description.trim(), popoverDoc.description);
    });
  });

  group('rendered page', () {
    testWidgets('sections render top to bottom in the declared house order', (
      WidgetTester tester,
    ) async {
      await _pumpPopoverDoc(tester, size: const Size(1440, 4000));

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, _sectionOrder);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders the article and the live specimen trigger', (
      WidgetTester tester,
    ) async {
      await _pumpPopoverDoc(tester);

      expect(
        find.byKey(const ValueKey<String>('popover-doc-article')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('popover-doc-specimen-trigger')),
        findsOneWidget,
      );
      // The popup is not mounted before anything opens it.
      expect(
        find.byKey(const ValueKey<String>('popover-doc-specimen-content')),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'the API tables document every constructor parameter found in the source',
      (WidgetTester tester) async {
        await _pumpPopoverDoc(tester, size: const Size(1440, 4000));

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        // Popover's own constructor.
        expect(find.text('open'), findsWidgets);
        expect(find.text('anchor'), findsWidgets);
        expect(find.text('content'), findsWidgets);
        expect(find.text('side'), findsWidgets);
        expect(find.text('align'), findsWidgets);
        expect(find.text('sideOffset'), findsWidgets);
        expect(find.text('collisionPadding'), findsWidgets);
        expect(find.text('animate'), findsOneWidget);
        expect(find.text('animateOut'), findsOneWidget);
        expect(find.text('origin'), findsWidgets);
        expect(find.text('slideSides'), findsOneWidget);
        expect(find.text('anchorPoint'), findsOneWidget);
        expect(find.text('barrier'), findsWidgets);
        expect(find.text('onDismiss'), findsOneWidget);

        // PopoverSurface's constructor.
        expect(find.text('radius'), findsOneWidget);
        expect(find.text('shadow'), findsOneWidget);
        expect(find.text('ring'), findsOneWidget);
        expect(find.text('border'), findsOneWidget);

        // PopoverPlacement / PopoverAnchorMetrics fields.
        expect(find.text('offset'), findsOneWidget);
        expect(find.text('rect'), findsOneWidget);
        expect(find.text('viewport'), findsWidgets);
        expect(find.text('availableWidth'), findsOneWidget);
        expect(find.text('availableHeight'), findsOneWidget);
        expect(find.text('anchorWidth'), findsOneWidget);

        // The enum value names, documented in API Reference. Side and
        // Align each also render as a live trigger label in their own
        // ShowcaseSection now (Variants and Align), so these are no
        // longer exclusive to the table: findsWidgets confirms the fact
        // is documented without asserting a page-wide uniqueness the
        // live specimens now legitimately break.
        expect(find.text('top'), findsWidgets);
        expect(find.text('bottom'), findsWidgets);
        expect(find.text('left'), findsWidgets);
        expect(find.text('right'), findsWidgets);
        expect(find.text('start'), findsWidgets);
        expect(find.text('center'), findsWidgets);
        expect(find.text('end'), findsWidgets);
        expect(find.text('modal'), findsOneWidget);
        expect(find.text('nonModal'), findsOneWidget);
        // 'none' also names the Assets and Shaders install-facts values, so
        // more than one widget renders that exact text.
        expect(find.text('none'), findsWidgets);
      },
    );

    testWidgets('installation shows the real, registry-backed CLI command', (
      WidgetTester tester,
    ) async {
      await _pumpPopoverDoc(tester);

      expect(find.text('elattar add popover'), findsWidgets);
      expect(find.textContaining('source-foundation'), findsWidgets);
    });

    testWidgets('keyboard plainly documents the caller-owned focus gap', (
      WidgetTester tester,
    ) async {
      await _pumpPopoverDoc(tester, size: const Size(1440, 4000));

      final Finder keyboardTrigger = _disclosureTrigger('Keyboard');
      await tester.ensureVisible(keyboardTrigger);
      await tester.pump();
      await tester.tap(keyboardTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      expect(find.textContaining('Escape'), findsWidgets);
      expect(find.textContaining('canRequestFocus'), findsWidgets);
    });

    testWidgets(
      'responsive section documents the flip-then-shift collision handling',
      (WidgetTester tester) async {
        await _pumpPopoverDoc(tester, size: const Size(1440, 4000));

        final Finder responsiveTrigger = _disclosureTrigger('Responsive');
        await tester.ensureVisible(responsiveTrigger);
        await tester.pump();
        await tester.tap(responsiveTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        expect(find.textContaining('flip'), findsWidgets);
        expect(find.textContaining('collision'), findsWidgets);
      },
    );

    testWidgets(
      'navigating previous fires onNavigate with the already-routed neighbour',
      (WidgetTester tester) async {
        String? destination;
        await _pumpPopoverDoc(
          tester,
          onNavigate: (String route) => destination = route,
        );

        await tester.ensureVisible(find.text('Select').first);
        await tester.tap(find.text('Select').first);
        expect(destination, '/components/select');
      },
    );
  });

  group('live specimen: open and dismiss', () {
    testWidgets('tapping the trigger opens the popover content', (
      WidgetTester tester,
    ) async {
      await _pumpPopoverDoc(tester);

      final Finder trigger = find.byKey(
        const ValueKey<String>('popover-doc-specimen-trigger'),
      );
      await tester.ensureVisible(trigger);
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('popover-doc-specimen-content')),
        findsNothing,
      );

      await tester.tap(trigger);
      await tester.pump();
      await tester.pump(MotionDurations.overlayEnter);
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('popover-doc-specimen-content')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('a tap outside the open popover dismisses it', (
      WidgetTester tester,
    ) async {
      await _pumpPopoverDoc(tester);

      final Finder trigger = find.byKey(
        const ValueKey<String>('popover-doc-specimen-trigger'),
      );
      await tester.ensureVisible(trigger);
      await tester.pump();

      await tester.tap(trigger);
      await tester.pump();
      await tester.pump(MotionDurations.overlayEnter);
      await tester.pump();
      expect(
        find.byKey(const ValueKey<String>('popover-doc-specimen-content')),
        findsOneWidget,
      );

      // Far from both the trigger and the open popup: lands on the modal
      // barrier `Popover` lays under its content by default.
      await tester.tapAt(const Offset(4, 4));
      await tester.pump();
      await tester.pump(MotionDurations.overlayEnter);
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('popover-doc-specimen-content')),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('viewport widths', () {
    testWidgets('a wide viewport exposes the sidebar and table of contents', (
      WidgetTester tester,
    ) async {
      await _pumpPopoverDoc(tester, size: _wide);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('popover-doc-article')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'a narrow viewport drops to the anchor strip and stays reachable',
      (WidgetTester tester) async {
        await _pumpPopoverDoc(tester, size: _narrow);

        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('popover-doc-article')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('both themes', () {
    testWidgets('renders on light', (WidgetTester tester) async {
      await _pumpPopoverDoc(tester, mode: ColorMode.light);
      expect(
        find.byKey(const ValueKey<String>('popover-doc-specimen-trigger')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpPopoverDoc(tester, mode: ColorMode.dark);
      expect(
        find.byKey(const ValueKey<String>('popover-doc-specimen-trigger')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final ThemeController theme = await _pumpPopoverDoc(
        tester,
        mode: ColorMode.dark,
      );
      expect(
        find.byKey(const ValueKey<String>('popover-doc-specimen-trigger')),
        findsOneWidget,
      );

      theme.setMode(ColorMode.light);
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('popover-doc-specimen-trigger')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
