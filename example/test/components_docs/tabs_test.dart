/// Tests for `components_docs/tabs/page.dart`'s [TabsDocPage] — the tabs
/// component documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`, per the
/// Phase J brief. The live `DsThemeController` is flipped in place for theme
/// coverage rather than re-pumped under a new controller.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/tabs/meta.dart';
import 'package:example/components_docs/tabs/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// Every public constructor parameter of `DsTabs`, enumerated by reading
/// `lib/src/components/tabs.dart` directly (Step 1 of the task cycle). The
/// API table must cover all of these by name.
const List<String> _tabsParams = <String>[
  'items',
  'selectedIndex',
  'onChanged',
  'variant',
];

/// Every public constructor parameter of the `DsTabItem` model.
const List<String> _tabItemParams = <String>[
  'DsTabItem.label',
  'DsTabItem.content',
];

/// The rest of the public surface: the `DsTabsVariant` enum and the static
/// geometry getters on `DsTabs`.
const List<String> _tabsStatics = <String>[
  'DsTabsVariant.standard',
  'DsTabsVariant.line',
  'DsTabs.trackHeight',
  'DsTabs.triggerHeight',
  'DsTabs.triggerPaddingX',
  'DsTabs.ruleHeight',
  'DsTabs.rootGap',
  'DsTabs.trackPadding',
  'DsTabs.gapFor',
];

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
            child: TabsDocPage(onNavigate: onNavigate),
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
    'renders the article at wide and narrow widths with no exceptions',
    (WidgetTester tester) async {
      await _pump(tester, size: _wide);

      expect(find.text(tabsDoc.title), findsWidgets);
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
    'the API table covers every DsTabs and DsTabItem constructor parameter '
    'and every DsTabsVariant/static member',
    (WidgetTester tester) async {
      await _pump(tester);

      final List<DocsApiTable> tables = tester
          .widgetList<DocsApiTable>(find.byType(DocsApiTable))
          .toList();
      expect(tables, isNotEmpty);

      final Set<String> documented = <String>{
        for (final DocsApiTable table in tables)
          for (final DocsApiFact fact in table.facts) fact.name,
      };

      for (final String param in <String>[
        ..._tabsParams,
        ..._tabItemParams,
        ..._tabsStatics,
      ]) {
        expect(
          documented,
          contains(param),
          reason: 'tabs API member "$param" is undocumented',
        );
      }
    },
  );

  testWidgets(
    'a live tabs specimen mounts and switching tabs changes the visible '
    'panel',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key key = ValueKey<String>('tabs-live-specimen');
      expect(find.byKey(key), findsOneWidget);
      await tester.ensureVisible(find.byKey(key));

      expect(tester.widget<DsTabs>(find.byKey(key)).selectedIndex, 0);
      expect(find.text('Update your account details here.'), findsOneWidget);
      expect(
        find.text('See who else has access to this workspace.'),
        findsNothing,
      );

      await tester.tap(find.text('Team'), warnIfMissed: false);
      await tester.pump();

      expect(tester.widget<DsTabs>(find.byKey(key)).selectedIndex, 1);
      expect(find.text('Update your account details here.'), findsNothing);
      expect(
        find.text('See who else has access to this workspace.'),
        findsOneWidget,
      );

      // A DsTabItem with content: null — a real state the source itself
      // documents (see tabs.dart's DsTabItem.content doc comment) — renders
      // no panel at all when selected, and toggling to it must not throw.
      await tester.tap(find.text('More'), warnIfMissed: false);
      await tester.pump();
      expect(
        find.text('See who else has access to this workspace.'),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'DsTabs and its trigger wire no Focus widget of their own — there is no '
    'keyboard tab stop and no arrow-key traversal',
    (WidgetTester tester) async {
      await _pump(tester);

      expect(
        find.descendant(
          of: find.byKey(const ValueKey<String>('tabs-live-specimen')),
          matching: find.byType(Focus),
        ),
        findsNothing,
        reason:
            'if this starts failing, DsTabs has grown real keyboard focus '
            'and the Accessibility section of the docs page must be updated '
            'to stop saying otherwise',
      );
    },
  );

  testWidgets('tabs exceeding the available track width overflow rather than '
      'scrolling or wrapping, verified at a 390px-class width', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = _narrow;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final DsThemeController theme = DsThemeController(mode: DsThemeMode.dark);
    addTearDown(theme.dispose);

    await tester.pumpWidget(
      DsTheme(
        controller: theme,
        child: MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: DsTabs(
                items: const <DsTabItem>[
                  DsTabItem(label: 'Overview'),
                  DsTabItem(label: 'Analytics dashboard'),
                  DsTabItem(label: 'Notification preferences'),
                  DsTabItem(label: 'Billing and subscriptions'),
                  DsTabItem(label: 'Security settings'),
                ],
                selectedIndex: 0,
                onChanged: (int _) {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    // DsTabs' track is an un-clipped, unscrolled Row (DsSlidingPillGroup):
    // it neither scrolls nor wraps when its triggers do not fit, so a
    // RenderFlex overflow is the real, current behaviour — recorded here
    // rather than asserted away, so the docs page's Responsive section
    // stays honest if that ever changes.
    final dynamic exception = tester.takeException();
    expect(exception, isNotNull);
    expect(exception.toString(), contains('overflowed'));
  });

  testWidgets(
    'both themes render the article with no exceptions when flipped in '
    'place',
    (WidgetTester tester) async {
      final DsThemeController theme = await _pump(
        tester,
        mode: DsThemeMode.light,
      );
      expect(find.text(tabsDoc.title), findsWidgets);

      theme.setMode(DsThemeMode.dark);
      await tester.pump();
      expect(find.text(tabsDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation is honestly disclosed as not yet CLI-installable', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    // The honest disclosure is intentionally repeated (Status and
    // Installation each state it in their own words), so this asserts
    // presence, not a specific count.
    expect(find.textContaining('not yet a registry item'), findsWidgets);
  });

  testWidgets(
    'the state matrix documents selected, empty, focus-visible and reduced '
    'motion, and the page states the missing keyboard support plainly',
    (WidgetTester tester) async {
      await _pump(tester);

      final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
        find.byType(DocsStateMatrix),
      );
      final Set<String> states = matrix.facts
          .map((DocsStateFact fact) => fact.state)
          .toSet();

      for (final String expected in <String>[
        'Rest (unselected)',
        'Hover (unselected)',
        'Selected',
        'Focus-visible',
        'Empty',
        'Reduced motion',
      ]) {
        expect(
          states,
          contains(expected),
          reason: 'state matrix is missing the "$expected" row',
        );
      }

      expect(find.textContaining('no keyboard'), findsWidgets);
    },
  );
}
