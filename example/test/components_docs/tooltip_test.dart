/// Tests for `components_docs/tooltip/meta.dart` and
/// `components_docs/tooltip/page.dart`: the public Tooltip component
/// documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`: the
/// discipline `breadcrumb_test.dart` already carries. Theme coverage uses a
/// live `ElThemeController` flipped in place rather than two independent
/// pumps.
///
/// `ElTooltip` mounts its content through an `OverlayPortal`, so the live
/// specimens need a real `Overlay`: the harness wraps the page in a
/// `MaterialApp`, the same fix a sibling worker needed for `ElSelect` earlier
/// in this program. A bare `Directionality`/`Material` host would let the
/// page render but the tooltip would never actually open.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/tooltip/meta.dart';
import 'package:example/components_docs/tooltip/page.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

Future<ElThemeController> _pumpTooltipDoc(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  ElThemeMode mode = ElThemeMode.dark,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ElThemeController theme = ElThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ElTheme(
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

void main() {
  group('meta', () {
    test('tooltipDoc names the real public API surface', () {
      expect(tooltipDoc.name, 'tooltip');
      expect(tooltipDoc.title, 'Tooltip');
      expect(tooltipDoc.route, '/components/tooltip');
      expect(tooltipDoc.command, 'elattar add tooltip');
      expect(tooltipDoc.sourcePath, 'lib/src/components/tooltip.dart');
      expect(
        tooltipDoc.exports,
        containsAll(<String>['ElTooltip', 'ElTooltipSide', 'ElTooltipContent']),
      );
      // Matches registry/components/tooltip.json's registryDependencies
      // verbatim: tooltip is one of the rare Wave 1 components that already
      // has a real manifest.
      expect(tooltipDoc.dependencies, <String>['source-foundation']);
      // Short description: one sentence, no trailing ellipsis.
      expect(tooltipDoc.description, isNot(contains('..')));
      expect(tooltipDoc.description.trim(), tooltipDoc.description);
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
      expect(find.byType(ElTooltipContent), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'sections render in the shadcn-tooltip-mirrored order, Status gone, '
      'the six Elattar sections trailing API',
      (WidgetTester tester) async {
        await _pumpTooltipDoc(tester);

        final List<String> titles = tester
            .widgetList<ElSection>(find.byType(ElSection))
            .map((ElSection section) => section.title)
            .toList();

        expect(titles, <String>[
          'Installation',
          'Usage',
          'Composition',
          'Side',
          'In a toolbar',
          'Disabled button',
          'Hidden trigger',
          'API Reference',
          'States and feedback',
          'Accessibility and keyboard behavior',
          'Responsive and platform behavior',
          'Dependencies, files, and disclosure',
          'Theming notes',
          'Source and tests',
        ]);
      },
    );

    testWidgets(
      'the API table documents every constructor parameter found in the source',
      (WidgetTester tester) async {
        await _pumpTooltipDoc(tester);

        // ElTooltip's own constructor.
        expect(find.text('label'), findsWidgets);
        expect(find.text('child'), findsOneWidget);
        expect(find.text('delay'), findsOneWidget);
        expect(find.text('side'), findsWidgets);
        expect(find.text('hidden'), findsOneWidget);
        expect(find.textContaining('ElDurations.tooltipDelay'), findsWidgets);
        // ElTooltipContent's constructor (label, side already covered above
        // as duplicated cells).
        expect(find.textContaining('ElTooltipContent'), findsWidgets);
        // ElTooltipSide's two values, in the Side section.
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
        await _pumpTooltipDoc(tester);

        expect(find.textContaining('no Semantics'), findsWidgets);
        expect(find.textContaining('only name'), findsWidgets);
      },
    );

    testWidgets(
      'responsive behavior documents a tap, correcting a long-press assumption',
      (WidgetTester tester) async {
        await _pumpTooltipDoc(tester);

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
        await tester.pumpAndSettle();

        final TestGesture pointer = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        addTearDown(pointer.removePointer);
        await pointer.addPointer(location: Offset.zero);

        await pointer.moveTo(tester.getCenter(trigger));
        await tester.pump();
        expect(find.byType(ElTooltipContent), findsNothing);

        await tester.pump(ElDurations.tooltipDelay);
        await tester.pump(ElDurations.overlay);
        expect(find.byType(ElTooltipContent), findsOneWidget);
        expect(find.text('Add to favourites'), findsOneWidget);

        await pointer.moveTo(const Offset(1, 1));
        await tester.pump();
        await tester.pump(ElDurations.overlay);
        await tester.pump();
        await tester.pump(ElDurations.overlay);
        await tester.pump();
        expect(find.byType(ElTooltipContent), findsNothing);
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
        await tester.pumpAndSettle();

        await tester.tap(trigger);
        await tester.pump();
        // No dwell: the label is up before the hover delay would even have
        // elapsed.
        expect(find.byType(ElTooltipContent), findsOneWidget);
        await tester.pump(ElDurations.overlay);
        expect(find.text('Dashboard'), findsOneWidget);

        // A second tap on the same trigger closes it.
        await tester.tap(trigger);
        await tester.pump();
        await tester.pump(ElDurations.overlay);
        await tester.pump();
        await tester.pump(ElDurations.overlay);
        await tester.pump();
        expect(find.byType(ElTooltipContent), findsNothing);
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
      await _pumpTooltipDoc(tester, mode: ElThemeMode.light);
      expect(find.byType(ElTooltip), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpTooltipDoc(tester, mode: ElThemeMode.dark);
      expect(find.byType(ElTooltip), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final ElThemeController theme = await _pumpTooltipDoc(
        tester,
        mode: ElThemeMode.dark,
      );
      expect(find.byType(ElTooltip), findsWidgets);

      theme.setMode(ElThemeMode.light);
      await tester.pump();

      expect(find.byType(ElTooltip), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });
}
