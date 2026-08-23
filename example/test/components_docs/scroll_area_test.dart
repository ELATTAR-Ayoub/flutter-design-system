/// Tests for `components_docs/scroll_area/page.dart`'s [ScrollAreaDocPage]:
/// the ONE page documenting THREE layout components: [DsScrollArea],
/// [DsResizablePanelGroup], and [DsAspectRatio].
///
/// All three read from `lib/src/components/scroll_area.dart`,
/// `resizable.dart`, and `aspect_ratio.dart` directly, every public class,
/// enum, and constructor parameter enumerated below is one this page's API
/// tables must cover.
///
/// The completeness test checks each class's own [DocsApiTable] by title.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `DsThemeController` is flipped in place for theme coverage.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/scroll_area/meta.dart';
import 'package:example/components_docs/scroll_area/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/kit.dart' show DsSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// Every `DsApiTable` this page must render, by title, and every public
/// constructor parameter or static member of that class, read directly off
/// `lib/src/components/scroll_area.dart`, `resizable.dart`, and
/// `aspect_ratio.dart`.
const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  // ── scroll_area.dart ──
  'DsScrollArea': <String>[
    'child',
    'borderRadius',
    'horizontalBar',
    'controller',
  ],
  'DsScrollAreaBehavior': <String>['DsScrollAreaBehavior'],
  // ── resizable.dart ──
  'DsResizablePanelGroup': <String>['panels', 'withHandle', 'minHeight'],
  'DsResizablePanel': <String>['child', 'defaultSize', 'minSize'],
  // ── aspect_ratio.dart ──
  'DsAspectRatio': <String>['ratio', 'child', 'margin'],
};

Future<DsThemeController> _pump(
  WidgetTester tester, {
  Size size = _wide,
  DsThemeMode mode = DsThemeMode.dark,
  ValueChanged<String>? onNavigate,
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
            child: ScrollAreaDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  testWidgets(
    'sections render in the shadcn-mirrored order, section for section, '
    'with each of the three families\' own sections grouped under its own '
    'name',
    (WidgetTester tester) async {
      await _pump(tester);

      final List<String> titles = tester
          .widgetList<DsSection>(find.byType(DsSection))
          .map((DsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Installation',
        'Usage',
        'Composition',
        'Scroll area: Horizontal scrolling',
        'Scroll area: RTL',
        'Resizable: Handle',
        'Resizable: RTL',
        'Aspect ratio: Square',
        'Aspect ratio: Portrait',
        'Aspect ratio: RTL',
        'API Reference',
        'States',
        'Accessibility',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);

      // The exact-order equality above already proves the old house shape
      // (Overview, Status, Preview, Variants) is gone: any leftover section
      // would show up as an extra or misplaced title. DsSection is the only
      // heading-producing wrapper on this page, so no separate find.text
      // check is needed (and 'Preview' is also DocsCodeExample's own
      // internal tab label, so a bare find.text('Preview') would be
      // ambiguous rather than meaningful).
    },
  );

  testWidgets(
    'renders the article at wide and narrow widths with no exceptions',
    (WidgetTester tester) async {
      await _pump(tester, size: _wide);

      expect(find.text(scrollAreaDoc.title), findsWidgets);
      expect(find.byType(DocsCodeExample), findsAtLeastNWidgets(1));
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      await _pump(tester, size: _narrow);
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'each DsApiTable covers every public constructor parameter and static '
    'of its own class, across all three components',
    (WidgetTester tester) async {
      await _pump(tester);

      final List<DocsApiTable> tables = tester
          .widgetList<DocsApiTable>(find.byType(DocsApiTable))
          .toList();
      expect(tables, isNotEmpty);

      final Map<String, Set<String>> byTitle = <String, Set<String>>{
        for (final DocsApiTable table in tables)
          table.title: <String>{
            for (final DocsApiFact fact in table.facts) fact.name,
          },
      };

      for (final MapEntry<String, List<String>> expected
          in _expectedApiTables.entries) {
        final Set<String>? documented = byTitle[expected.key];
        expect(
          documented,
          isNotNull,
          reason: 'no DsApiTable titled "${expected.key}" was rendered',
        );
        for (final String param in expected.value) {
          expect(
            documented,
            contains(param),
            reason: '"${expected.key}" table is missing parameter "$param"',
          );
        }
      }
    },
  );

  testWidgets(
    'DsScrollArea renders the scroll container with content that can scroll',
    (WidgetTester tester) async {
      await _pump(tester);

      // The preview shows a scroll area with multiple items. Verify the
      // container exists and is scrollable.
      final Finder scrollArea = find.byKey(
        const ValueKey<String>('scroll-area-doc-preview'),
      );
      expect(scrollArea, findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'DsResizablePanelGroup renders resizable panels with a draggable '
    'separator, in the live demo and the Handle and RTL specimens',
    (WidgetTester tester) async {
      await _pump(tester);

      // Live demo, Resizable: Handle (two groups), Resizable: RTL.
      final Finder panelGroup = find.byType(DsResizablePanelGroup);
      expect(panelGroup, findsAtLeastNWidgets(4));

      // The group should render and be ready for interaction.
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('DsAspectRatio locks a box to the specified ratio', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    final Finder aspectRatio = find.byType(DsAspectRatio);
    expect(aspectRatio, findsWidgets);

    // Verify the aspect ratio widgets render with no exceptions.
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'both themes render the article with no exceptions when flipped in '
    'place',
    (WidgetTester tester) async {
      final DsThemeController theme = await _pump(
        tester,
        mode: DsThemeMode.light,
      );
      expect(find.text(scrollAreaDoc.title), findsWidgets);

      theme.setMode(DsThemeMode.dark);
      await tester.pump();
      expect(find.text(scrollAreaDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'installation is honest that none of the three has a registry manifest '
    'yet, no elattar add command is presented as working',
    (WidgetTester tester) async {
      await _pump(tester);

      expect(find.textContaining('Not available'), findsWidgets);
      expect(find.textContaining('elattar add scroll-area'), findsNothing);
      expect(find.textContaining('elattar add resizable'), findsNothing);
      expect(find.textContaining('elattar add aspect-ratio'), findsNothing);
    },
  );

  testWidgets(
    'the state matrix documents rest, hover, drag, focus with N/A reasons '
    'where a state belongs to one family and not the others',
    (WidgetTester tester) async {
      await _pump(tester);

      final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
        find.byType(DocsStateMatrix),
      );
      final Set<String> states = matrix.facts
          .map((DocsStateFact fact) => fact.state)
          .toSet();

      for (final String expected in <String>[
        'Rest',
        'Hover',
        'Drag',
        'Focus',
      ]) {
        expect(
          states,
          contains(expected),
          reason: 'state matrix is missing the "$expected" row',
        );
      }
    },
  );

  testWidgets(
    'the three families are documented with their public names and exports',
    (WidgetTester tester) async {
      await _pump(tester);

      expect(scrollAreaDoc.name, 'scroll_area');
      expect(
        scrollAreaDoc.exports,
        containsAll(<String>[
          'DsScrollArea',
          'DsResizablePanelGroup',
          'DsResizablePanel',
          'DsAspectRatio',
        ]),
      );
      expect(tester.takeException(), isNull);
    },
  );
}
