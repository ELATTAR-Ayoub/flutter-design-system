/// Tests for `components_docs/scroll_area/page.dart`'s [ScrollAreaDocPage]:
/// [ScrollArea] only. `ResizablePanelGroup` and `AspectRatio` were
/// split off into their own routes and their own test files
/// (`resizable_test.dart`, `aspect_ratio_test.dart`); see
/// `scroll_area/meta.dart`'s library note for the split.
///
/// Reads `lib/src/components/scroll_area.dart` directly; every public
/// class, enum, and constructor parameter enumerated below is one this
/// page's API tables must cover.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ThemeController` is flipped in place for theme coverage.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/scroll_area/meta.dart';
import 'package:example/components_docs/scroll_area/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_facts.dart';
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

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s
/// own trigger key ([DocsDisclosure.triggerKey]) is one constant shared by
/// every instance on the page, so a bare `find.byKey` would match every
/// disclosure — this narrows to the one panel by its title first, matching
/// `button`'s own docs test. A closed `DocsDisclosure` mounts no content at
/// all, so its API table or state matrix must be opened before anything
/// inside it can be found.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

Future<void> _open(WidgetTester tester, String title) async {
  final Finder trigger = _disclosureTrigger(title);
  await tester.ensureVisible(trigger);
  await tester.pump();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(MotionDurations.open);
}

/// Every `ApiTable` this page must render, by title, and every public
/// constructor parameter or static member of that class, read directly off
/// `lib/src/components/scroll_area.dart`.
const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  'ScrollArea': <String>[
    'child',
    'borderRadius',
    'horizontalBar',
    'controller',
  ],
  'ScrollAreaBehavior': <String>['ScrollAreaBehavior'],
};

Future<ThemeController> _pump(
  WidgetTester tester, {
  Size size = _wide,
  ColorMode mode = ColorMode.dark,
  ValueChanged<String>? onNavigate,
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
    'with no leftover Resizable/Aspect ratio section from the merged page',
    (WidgetTester tester) async {
      await _pump(tester);

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Composition',
        'Horizontal scrolling',
        'RTL',
        'API Reference',
        'States',
        'Accessibility',
        'Keyboard',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);
    },
  );

  testWidgets(
    'renders the article at wide and narrow widths with no exceptions',
    (WidgetTester tester) async {
      await _pump(tester, size: _wide);

      expect(find.text(scrollAreaDoc.title), findsWidgets);
      expect(find.byType(DocsShowcase), findsAtLeastNWidgets(1));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      await _pump(tester, size: _narrow);

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
    'each ApiTable covers every public constructor parameter and static '
    'of ScrollArea',
    (WidgetTester tester) async {
      await _pump(tester);
      await _open(tester, 'API Reference');

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
          reason: 'no ApiTable titled "${expected.key}" was rendered',
        );
        for (final String param in expected.value) {
          expect(
            documented,
            contains(param),
            reason: '"${expected.key}" table is missing parameter "$param"',
          );
        }
      }

      // No leftover ResizablePanelGroup/AspectRatio tables from the
      // pre-split page.
      expect(byTitle.containsKey('ResizablePanelGroup'), isFalse);
      expect(byTitle.containsKey('ResizablePanel'), isFalse);
      expect(byTitle.containsKey('AspectRatio'), isFalse);
    },
  );

  testWidgets(
    'ScrollArea renders the scroll container with content that can scroll',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder scrollArea = find.byKey(
        const ValueKey<String>('scroll-area-doc-preview'),
      );
      expect(scrollArea, findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(find.byType(ResizablePanelGroup), findsNothing);
      expect(find.byType(AspectRatio), findsNothing);
    },
  );

  testWidgets(
    'both themes render the article with no exceptions when flipped in '
    'place',
    (WidgetTester tester) async {
      final ThemeController theme = await _pump(tester, mode: ColorMode.light);
      expect(find.text(scrollAreaDoc.title), findsWidgets);

      theme.setMode(ColorMode.dark);
      await tester.pump();
      expect(find.text(scrollAreaDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation presents the working scroll-area CLI command', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(find.textContaining('elattar add scroll-area'), findsWidgets);
  });

  testWidgets('the state matrix documents rest, hover, and drag', (
    WidgetTester tester,
  ) async {
    await _pump(tester);
    await _open(tester, 'States');

    final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
      find.byType(DocsStateMatrix),
    );
    final Set<String> states = matrix.facts
        .map((DocsStateFact fact) => fact.state)
        .toSet();

    for (final String expected in <String>['Rest', 'Hover', 'Drag']) {
      expect(
        states,
        contains(expected),
        reason: 'state matrix is missing the "$expected" row',
      );
    }
  });

  testWidgets(
    'the pager navigates through DocsLayout.onNavigate, back to Resizable '
    'and forward to Layout',
    (WidgetTester tester) async {
      String? destination;
      await _pump(tester, onNavigate: (String route) => destination = route);

      final Finder resizableLink = find.text('Resizable').first;
      await tester.ensureVisible(resizableLink);
      await tester.pump();
      await tester.tap(resizableLink);
      expect(destination, '/components/resizable');
    },
  );

  testWidgets('the component is documented with its public name and exports', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(scrollAreaDoc.name, 'scroll_area');
    expect(
      scrollAreaDoc.exports,
      containsAll(<String>['ScrollArea', 'ScrollAreaBehavior']),
    );
    expect(tester.takeException(), isNull);
  });
}
