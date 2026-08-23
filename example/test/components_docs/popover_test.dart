/// Tests for `components_docs/popover/meta.dart` and
/// `components_docs/popover/page.dart`: the public Popover component
/// documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`: the
/// discipline `tooltip_test.dart` already carries. Theme coverage uses a live
/// `DsThemeController` flipped in place rather than two independent pumps.
///
/// `DsPopover` mounts its content through an `OverlayPortal`, so the live
/// specimen needs a real `Overlay`: the harness wraps the page in a
/// `MaterialApp`, the same fix a sibling worker needed for `DsSelect` and
/// this page's own neighbour, `DsTooltip`. A bare `Directionality`/`Material`
/// host would let the page render but the popover would never actually open.
///
/// `DsPopover`'s open/close transition is a single forward-then-reverse run
/// with a fixed `DsDurations.overlay` duration: not a loop, so
/// `pumpAndSettle` is safe where used below; the open/close assertions still
/// use explicit `pump(duration)` steps to keep the exact frame under test.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/popover/meta.dart';
import 'package:example/components_docs/popover/page.dart';
import 'package:example/kit.dart' show DsSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The page was reshaped to mirror
/// https://ui.shadcn.com/docs/components/base/popover section for section:
/// an unheaded live demo above the first heading, then Installation, Usage,
/// Composition, then Align (the reference's own live Start/Center/End
/// example, ported as a data table since every variant section on this
/// docs site already uses that format), then our Variants addition for the
/// side/origin/barrier enums the reference does not surface, then API
/// Reference, then States / Accessibility / Responsive / Dependencies /
/// Theming / Source. The ordering test below asserts that literal
/// sequence.
const List<String> _sectionOrder = <String>[
  'install',
  'usage',
  'composition',
  'align',
  'variants',
  'api',
  'states',
  'accessibility',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

Future<DsThemeController> _pumpPopoverDoc(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  DsThemeMode mode = DsThemeMode.dark,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final DsThemeController theme = DsThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    DsTheme(
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
          'DsPopover',
          'DsPopoverSide',
          'DsPopoverAlign',
          'DsPopoverOriginModel',
          'DsPopoverBarrier',
          'DsPopoverPlacement',
          'DsPopoverAnchorMetrics',
          'DsPopoverContentBuilder',
          'DsPopoverSurface',
          'dsPopoverPlacement',
        ]),
      );
      // Matches registry/components/popover.json's registryDependencies
      // verbatim: popover already has a real manifest, so a worker that
      // invented a dependency name here would be the exact failure mode the
      // Phase J supervisor notes warn about.
      expect(popoverDoc.dependencies, <String>['source-foundation']);
      // Short description: one sentence, no trailing ellipsis.
      expect(popoverDoc.description, isNot(contains('..')));
      expect(popoverDoc.description.trim(), popoverDoc.description);
      // The expanded, decision-guidance description is a distinct constant
      // that names all three overlay neighbours, not a restatement of the
      // short one.
      expect(popoverExpandedDescription, isNot(equals(popoverDoc.description)));
      expect(popoverExpandedDescription.trim(), popoverExpandedDescription);
      expect(popoverExpandedDescription, contains('Tooltip'));
      expect(popoverExpandedDescription, contains('Dropdown Menu'));
      expect(popoverExpandedDescription, contains('Hover Card'));
    });
  });

  group('rendered page', () {
    testWidgets('renders every shadcn-parity section, in order', (
      WidgetTester tester,
    ) async {
      await _pumpPopoverDoc(tester);

      // Every section anchor exists, and each one sits below the section
      // before it -- the "in order" half of the shadcn-parity contract.
      double previousTop = -1;
      for (final String anchor in _sectionOrder) {
        final Finder section = find.byKey(DsSection.anchorKey(anchor));
        expect(section, findsOneWidget, reason: 'section "$anchor" missing');
        final double top = tester.getTopLeft(section).dy;
        expect(
          top,
          greaterThan(previousTop),
          reason:
              'section "$anchor" should render after the previous section',
        );
        previousTop = top;
      }
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
        await _pumpPopoverDoc(tester);

        // DsPopover's own constructor.
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

        // DsPopoverSurface's constructor.
        expect(find.text('radius'), findsOneWidget);
        expect(find.text('shadow'), findsOneWidget);
        expect(find.text('ring'), findsOneWidget);
        expect(find.text('border'), findsOneWidget);

        // DsPopoverPlacement / DsPopoverAnchorMetrics fields.
        expect(find.text('offset'), findsOneWidget);
        expect(find.text('rect'), findsOneWidget);
        expect(find.text('viewport'), findsWidgets);
        expect(find.text('availableWidth'), findsOneWidget);
        expect(find.text('availableHeight'), findsOneWidget);
        expect(find.text('anchorWidth'), findsOneWidget);

        // The enum value names, in the Variants section.
        expect(find.text('top'), findsOneWidget);
        expect(find.text('bottom'), findsOneWidget);
        expect(find.text('left'), findsOneWidget);
        expect(find.text('right'), findsOneWidget);
        expect(find.text('start'), findsOneWidget);
        expect(find.text('center'), findsOneWidget);
        expect(find.text('end'), findsOneWidget);
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

    testWidgets('accessibility plainly documents the caller-owned focus gap', (
      WidgetTester tester,
    ) async {
      await _pumpPopoverDoc(tester);

      expect(find.textContaining('Focus is the content'), findsWidgets);
      expect(find.textContaining('Escape'), findsWidgets);
    });

    testWidgets(
      'responsive section documents the flip-then-shift collision handling',
      (WidgetTester tester) async {
        await _pumpPopoverDoc(tester);

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
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('popover-doc-specimen-content')),
        findsNothing,
      );

      await tester.tap(trigger);
      await tester.pump();
      await tester.pump(DsDurations.overlay);
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
      await tester.pumpAndSettle();

      await tester.tap(trigger);
      await tester.pump();
      await tester.pump(DsDurations.overlay);
      await tester.pump();
      expect(
        find.byKey(const ValueKey<String>('popover-doc-specimen-content')),
        findsOneWidget,
      );

      // Far from both the trigger and the open popup: lands on the modal
      // barrier `DsPopover` lays under its content by default.
      await tester.tapAt(const Offset(4, 4));
      await tester.pump();
      await tester.pump(DsDurations.overlay);
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
      await _pumpPopoverDoc(tester, mode: DsThemeMode.light);
      expect(
        find.byKey(const ValueKey<String>('popover-doc-specimen-trigger')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpPopoverDoc(tester, mode: DsThemeMode.dark);
      expect(
        find.byKey(const ValueKey<String>('popover-doc-specimen-trigger')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final DsThemeController theme = await _pumpPopoverDoc(
        tester,
        mode: DsThemeMode.dark,
      );
      expect(
        find.byKey(const ValueKey<String>('popover-doc-specimen-trigger')),
        findsOneWidget,
      );

      theme.setMode(DsThemeMode.light);
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('popover-doc-specimen-trigger')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
