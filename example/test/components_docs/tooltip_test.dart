/// Tests for `components_docs/tooltip/meta.dart` and
/// `components_docs/tooltip/page.dart`: the public Tooltip component
/// documentation page.
///
/// **Re-housed onto `ComponentDocSpec`/`ComponentDocPage`**, the same shape
/// `button_test.dart` and `popover_test.dart` assert against: sections read
/// through `DocsSection.title`, and the API table (now inside a
/// `DocsDisclosure`, closed by default) is opened before its rows are read.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`: the
/// discipline `breadcrumb_test.dart` already carries. Theme coverage uses a
/// live `ThemeController` flipped in place rather than two independent
/// pumps.
///
/// **No `pumpAndSettle` anywhere on this page.** A tooltip opens on a delay
/// timer, so a test that opens one uses explicit `pump()` /
/// `pump(duration)` steps instead — `pumpAndSettle` would either time out
/// waiting on that timer or race the `DocsDisclosure` chevron's own bounded
/// animation.
///
/// `Tooltip` mounts its content through an `OverlayPortal`, so the live
/// specimens need a real `Overlay`: the harness wraps the page in a
/// `MaterialApp`, the same fix a sibling worker needed for `Select` earlier
/// in this program. A bare `Directionality`/`Material` host would let the
/// page render but the tooltip would never actually open.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/tooltip/meta.dart';
import 'package:example/components_docs/tooltip/page.dart';
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

const Size _wide = Size(1440, 900);
const Size _tall = Size(1440, 5000);
const Size _narrow = Size(390, 844);

const List<String> _sectionOrder = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Composition',
  'Side',
  'In a toolbar',
  'Disabled button',
  'Hidden trigger',
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

Future<ThemeController> _pumpTooltipDoc(
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
            child: TooltipDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

/// Opens the named disclosure, scrolling its trigger into view first: the
/// trigger sits well past the fold on a page this long. A bounded
/// `pump(MotionDurations.open)` settles the chevron's own animation without
/// `pumpAndSettle`.
Future<void> _openDisclosure(WidgetTester tester, String title) async {
  final Finder trigger = _disclosureTrigger(title);
  await tester.ensureVisible(trigger);
  await tester.pump();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(MotionDurations.open);
}

void main() {
  group('meta', () {
    test('tooltipDoc names the real public API surface', () {
      expect(tooltipDoc.name, 'tooltip');
      expect(tooltipDoc.title, 'Tooltip');
      expect(tooltipDoc.route, '/components/tooltip');
      expect(tooltipDoc.command, 'elattar add tooltip');
      expect(tooltipDoc.sourcePath, 'lib/src/components/ui/tooltip.dart');
      expect(
        tooltipDoc.exports,
        containsAll(<String>['Tooltip', 'TooltipSide', 'TooltipContent']),
      );
      // Matches registry/components/tooltip.json's registryDependencies
      // verbatim: tooltip is one of the rare Wave 1 components that already
      // has a real manifest.
      expect(tooltipDoc.dependencies, <String>['source-foundation']);
      // Short description: one sentence, no trailing ellipsis.
      expect(tooltipDoc.description, isNot(contains('..')));
      expect(tooltipDoc.description.trim(), tooltipDoc.description);
    });

    test('the table of contents matches the declared sections', () {
      expect(
        tooltipDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        _sectionOrder,
      );
    });
  });

  group('rendered page', () {
    testWidgets('renders the article and both live specimen triggers', (
      WidgetTester tester,
    ) async {
      await _pumpTooltipDoc(tester);

      expect(
        find.byKey(const ValueKey<String>('tooltip-doc-article')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('tooltip-doc-specimen-top')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('tooltip-doc-specimen-right')),
        findsOneWidget,
      );
      // Neither specimen shows its overlay before anything opens it.
      expect(find.byType(TooltipContent), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'sections render in the shadcn-tooltip-mirrored order, with Preview '
      'promoted and the eight house disclosures trailing API Reference',
      (WidgetTester tester) async {
        await _pumpTooltipDoc(tester, size: _tall);

        final List<String> titles = tester
            .widgetList<DocsSection>(find.byType(DocsSection))
            .map((DocsSection section) => section.title)
            .toList();

        expect(titles, _sectionOrder);
      },
    );

    testWidgets('the page is declared, and every section is a kit component', (
      WidgetTester tester,
    ) async {
      await _pumpTooltipDoc(tester, size: _tall);

      // Five specimen stages: Preview, Side, In a toolbar, Disabled
      // button, Hidden trigger.
      expect(find.byType(DocsShowcase), findsNWidgets(5));
      expect(find.byType(DocsInstall), findsOneWidget);
      // Eight collapsed sections: API Reference, States, Accessibility,
      // Keyboard, Responsive, Dependencies, Theming, Source.
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    testWidgets(
      'the API tables document every constructor parameter found in the source',
      (WidgetTester tester) async {
        await _pumpTooltipDoc(tester, size: _tall);
        await _openDisclosure(tester, 'API Reference');

        // Tooltip's own constructor.
        expect(find.text('label'), findsWidgets);
        expect(find.text('child'), findsOneWidget);
        expect(find.text('delay'), findsOneWidget);
        expect(find.text('side'), findsWidgets);
        expect(find.text('hidden'), findsOneWidget);
        expect(
          find.textContaining('MotionDurations.tooltipShowDelay'),
          findsWidgets,
        );
        // TooltipContent's constructor (label, side already covered above
        // as duplicated cells).
        expect(find.textContaining('TooltipContent'), findsWidgets);
        // TooltipSide's two values, now a table inside API Reference
        // rather than inline in the Side section.
        expect(find.text('top'), findsOneWidget);
        expect(find.text('right'), findsOneWidget);
      },
    );

    testWidgets('installation shows the real, registry-backed CLI command', (
      WidgetTester tester,
    ) async {
      await _pumpTooltipDoc(tester);

      expect(find.text('elattar add tooltip'), findsWidgets);
      expect(find.textContaining('source-foundation'), findsWidgets);
    });

    testWidgets(
      'accessibility plainly documents the missing semantics wiring',
      (WidgetTester tester) async {
        await _pumpTooltipDoc(tester, size: _tall);
        await _openDisclosure(tester, 'Accessibility');

        expect(find.textContaining('no Semantics'), findsWidgets);
        expect(find.textContaining('only name'), findsWidgets);
      },
    );

    testWidgets(
      'keyboard plainly documents the total absence of Focus wiring',
      (WidgetTester tester) async {
        await _pumpTooltipDoc(tester, size: _tall);
        await _openDisclosure(tester, 'Keyboard');

        expect(find.textContaining('no Focus or FocusNode'), findsWidgets);
        expect(find.textContaining('Escape-to-close'), findsWidgets);
      },
    );

    testWidgets(
      'responsive behavior documents a tap, correcting a long-press assumption',
      (WidgetTester tester) async {
        await _pumpTooltipDoc(tester, size: _tall);
        await _openDisclosure(tester, 'Responsive');

        expect(find.textContaining('not a long press'), findsOneWidget);
        expect(find.textContaining('touchDwell'), findsWidgets);
      },
    );

    testWidgets(
      'navigating previous fires onNavigate with the wave-1 neighbour',
      (WidgetTester tester) async {
        String? destination;
        await _pumpTooltipDoc(
          tester,
          onNavigate: (String route) => destination = route,
        );

        await tester.ensureVisible(find.text('Toggle').first);
        await tester.tap(find.text('Toggle').first);
        expect(destination, '/components/toggle');
      },
    );
  });

  group('live specimen: pointer and touch', () {
    testWidgets(
      'a pointer hovering the top specimen opens the label after the delay',
      (WidgetTester tester) async {
        await _pumpTooltipDoc(tester);

        final Finder trigger = find.byKey(
          const ValueKey<String>('tooltip-doc-specimen-top'),
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
        expect(find.byType(TooltipContent), findsNothing);

        await tester.pump(MotionDurations.tooltipShowDelay);
        await tester.pump(MotionDurations.overlayEnter);
        expect(find.byType(TooltipContent), findsOneWidget);
        expect(find.text('Add to favourites'), findsOneWidget);

        await pointer.moveTo(const Offset(1, 1));
        await tester.pump();
        await tester.pump(MotionDurations.overlayEnter);
        await tester.pump();
        await tester.pump(MotionDurations.overlayEnter);
        await tester.pump();
        expect(find.byType(TooltipContent), findsNothing);
      },
    );

    testWidgets(
      'a tap on the right-side specimen opens it immediately, no dwell',
      (WidgetTester tester) async {
        await _pumpTooltipDoc(tester);

        final Finder trigger = find.byKey(
          const ValueKey<String>('tooltip-doc-specimen-right'),
        );
        await tester.ensureVisible(trigger);
        await tester.pump();

        await tester.tap(trigger);
        await tester.pump();
        // No dwell: the label is up before the hover delay would even have
        // elapsed.
        expect(find.byType(TooltipContent), findsOneWidget);
        await tester.pump(MotionDurations.overlayEnter);
        expect(find.text('Dashboard'), findsOneWidget);

        // A second tap on the same trigger closes it.
        await tester.tap(trigger);
        await tester.pump();
        await tester.pump(MotionDurations.overlayEnter);
        await tester.pump();
        await tester.pump(MotionDurations.overlayEnter);
        await tester.pump();
        expect(find.byType(TooltipContent), findsNothing);
      },
    );

    testWidgets(
      'the Hidden trigger specimen actually flips hidden live, and Side '
      'mounts a real right-side trigger',
      (WidgetTester tester) async {
        await _pumpTooltipDoc(tester, size: _tall);

        final Finder sideTrigger = find.byKey(
          const ValueKey<String>('tooltip-doc-side-right'),
        );
        await tester.ensureVisible(sideTrigger);
        await tester.pump();
        expect(tester.widget<Tooltip>(sideTrigger).side, TooltipSide.right);

        final Finder toggle = find.byKey(
          const ValueKey<String>('tooltip-doc-specimen-hidden-toggle'),
        );
        await tester.ensureVisible(toggle);
        await tester.pump();

        final Finder hiddenTooltip = find.byKey(
          const ValueKey<String>('tooltip-doc-specimen-hidden'),
        );
        expect(tester.widget<Tooltip>(hiddenTooltip).hidden, isTrue);

        await tester.tap(toggle);
        await tester.pump();

        expect(tester.widget<Tooltip>(hiddenTooltip).hidden, isFalse);
      },
    );
  });

  group('viewport widths', () {
    testWidgets('a wide viewport exposes the sidebar and table of contents', (
      WidgetTester tester,
    ) async {
      await _pumpTooltipDoc(tester, size: _wide);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('tooltip-doc-article')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'a narrow viewport drops to the anchor strip and stays reachable',
      (WidgetTester tester) async {
        await _pumpTooltipDoc(tester, size: _narrow);

        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('tooltip-doc-article')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('both themes', () {
    testWidgets('renders on light', (WidgetTester tester) async {
      await _pumpTooltipDoc(tester, mode: ColorMode.light);
      expect(find.byType(Tooltip), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpTooltipDoc(tester, mode: ColorMode.dark);
      expect(find.byType(Tooltip), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final ThemeController theme = await _pumpTooltipDoc(
        tester,
        mode: ColorMode.dark,
      );
      expect(find.byType(Tooltip), findsWidgets);

      theme.setMode(ColorMode.light);
      await tester.pump();

      expect(find.byType(Tooltip), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });
}
