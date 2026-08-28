/// Tests for `components_docs/resizable/page.dart`'s [ResizableDocPage]:
/// [ResizablePanelGroup] and [ResizablePanel].
///
/// Re-housed onto the kit alongside the page: the section-order test now
/// reads `DocsSection.id`, and the API-table / state-matrix reads open the
/// relevant `DocsDisclosure` first — closed by default, unlike the old
/// page's always-visible `Section`.
///
/// Reads `lib/src/components/resizable.dart` directly; every public class
/// and constructor parameter enumerated below is one this page's API
/// tables must cover.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ThemeController` is flipped in place for theme coverage.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/resizable/meta.dart';
import 'package:example/components_docs/resizable/page.dart'
    show ResizableDocPage, resizableDocSpec;
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_facts.dart';
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

const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  'ResizablePanelGroup': <String>['panels', 'withHandle', 'minHeight'],
  'ResizablePanel': <String>['child', 'defaultSize', 'minSize'],
};

/// The single `DocsDisclosure` whose title is [title].
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

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
            child: ResizableDocPage(onNavigate: onNavigate),
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
    'sections render in the house order, section for section, with no '
    'Vertical section (the honest skip)',
    (WidgetTester tester) async {
      await _pump(tester, size: const Size(1440, 4000));

      final List<String> ids = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.id)
          .toList();

      expect(ids, <String>[
        'preview',
        'install',
        'usage',
        'composition',
        'handle',
        'rtl',
        'api',
        'states',
        'accessibility',
        'keyboard',
        'responsive',
        'dependencies',
        'theming',
        'source',
      ]);
    },
  );

  testWidgets(
    'renders the article at wide and narrow widths with no exceptions',
    (WidgetTester tester) async {
      await _pump(tester, size: _wide);

      expect(find.text(resizableDoc.title), findsWidgets);
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      await _pump(tester, size: _narrow);
      await tester.pump();

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

  testWidgets('each ApiTable covers every public constructor parameter of '
      'ResizablePanelGroup and ResizablePanel', (WidgetTester tester) async {
    await _pump(tester);

    final Finder apiTrigger = _disclosureTrigger('API Reference');
    await tester.ensureVisible(apiTrigger);
    await tester.tap(apiTrigger);
    await tester.pump();
    await tester.pump(MotionDurations.open);

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
  });

  testWidgets('ResizablePanelGroup renders resizable panels with a draggable '
      'separator, in the Preview demo and the Handle and RTL specimens', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    // Preview, Handle (two groups), RTL.
    final Finder panelGroup = find.byType(ResizablePanelGroup);
    expect(panelGroup, findsAtLeastNWidgets(4));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'both themes render the article with no exceptions when flipped in '
    'place',
    (WidgetTester tester) async {
      final ThemeController theme = await _pump(tester, mode: ColorMode.light);
      expect(find.text(resizableDoc.title), findsWidgets);

      theme.setMode(ColorMode.dark);
      await tester.pump();
      expect(find.text(resizableDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation presents the working resizable CLI command', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(find.textContaining('elattar add resizable'), findsWidgets);
  });

  testWidgets('the state matrix documents rest, hover, drag, and focus', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    final Finder statesTrigger = _disclosureTrigger('States');
    await tester.ensureVisible(statesTrigger);
    await tester.tap(statesTrigger);
    await tester.pump();
    await tester.pump(MotionDurations.open);

    final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
      find.byType(DocsStateMatrix),
    );
    final Set<String> states = matrix.facts
        .map((DocsStateFact fact) => fact.state)
        .toSet();

    for (final String expected in <String>['Rest', 'Hover', 'Drag', 'Focus']) {
      expect(
        states,
        contains(expected),
        reason: 'state matrix is missing the "$expected" row',
      );
    }
  });

  testWidgets('the keyboard disclosure documents the arrow/Home/End keys', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    final Finder keyboardTrigger = _disclosureTrigger('Keyboard');
    await tester.ensureVisible(keyboardTrigger);
    await tester.tap(keyboardTrigger);
    await tester.pump();
    await tester.pump(MotionDurations.open);

    expect(find.textContaining('ArrowLeft'), findsOneWidget);
    expect(find.textContaining('ArrowRight'), findsOneWidget);
    expect(find.textContaining('Home:'), findsOneWidget);
    expect(find.textContaining('End:'), findsOneWidget);
  });

  testWidgets(
    'the pager navigates through DocsLayout.onNavigate, back to Aspect '
    'ratio and forward to Scroll area',
    (WidgetTester tester) async {
      String? destination;
      await _pump(tester, onNavigate: (String route) => destination = route);

      final Finder scrollAreaLink = find.text('Scroll area').first;
      await tester.ensureVisible(scrollAreaLink);
      await tester.pump();
      await tester.tap(scrollAreaLink);
      expect(destination, '/components/scroll_area');
    },
  );

  testWidgets('the component is documented with its public name and exports', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(resizableDoc.name, 'resizable');
    expect(
      resizableDoc.exports,
      containsAll(<String>['ResizablePanelGroup', 'ResizablePanel']),
    );
    expect(resizableDoc.command, 'elattar add resizable');
    expect(tester.takeException(), isNull);
  });

  test('the table of contents matches the declared sections', () {
    expect(
      resizableDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
      <String>[
        'Preview',
        'Installation',
        'Usage',
        'Composition',
        'Handle',
        'RTL',
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
}
