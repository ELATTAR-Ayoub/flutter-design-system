/// Tests for `components_docs/tabs/page.dart`'s [TabsDocPage]: the tabs
/// component documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ThemeController` is flipped in place for theme coverage rather than
/// re-pumped under a new controller.
///
/// Re-housed onto the kit alongside the page: sections are now
/// `DocsSection`s rather than `Section`s, and the eight disclosures (API
/// Reference, States, Accessibility, Keyboard, Responsive, Dependencies,
/// Theming, Source) are collapsed `DocsDisclosure`s that mount no content
/// until opened — see `_openDisclosure`, the same helper `button_test.dart`
/// uses.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/tabs/meta.dart';
import 'package:example/components_docs/tabs/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/docs/docs_layout.dart';
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

/// The house shape's own section order: Preview, Installation, Usage, one
/// section per variant/state, then the eight fixed disclosures.
const List<String> _expectedSectionIds = <String>[
  'preview',
  'install',
  'usage',
  'panels',
  'composition',
  'account-settings',
  'line',
  'section-switcher',
  'empty-tab',
  'rtl',
  'api',
  'states',
  'accessibility',
  'keyboard',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

/// Every public constructor parameter of `Tabs`, enumerated by reading
/// `lib/src/components/tabs.dart` directly. The API table must cover all of
/// these by name.
const List<String> _tabsParams = <String>[
  'items',
  'selectedIndex',
  'onChanged',
  'variant',
];

/// Every public constructor parameter of the `TabItem` model.
const List<String> _tabItemParams = <String>[
  'TabItem.label',
  'TabItem.content',
];

/// The rest of the public surface: the `TabsVariant` enum and the static
/// geometry getters on `Tabs`.
const List<String> _tabsStatics = <String>[
  'TabsVariant.standard',
  'TabsVariant.line',
  'Tabs.trackHeight',
  'Tabs.triggerHeight',
  'Tabs.triggerPaddingX',
  'Tabs.ruleHeight',
  'Tabs.rootGap',
  'Tabs.trackPadding',
  'Tabs.gapFor',
];

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
            child: TabsDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

/// The single `DocsDisclosure` whose title is [title], opened. A closed
/// `DocsDisclosure` mounts no content, so a test reading anything inside one
/// must open it first — the same helper `button_test.dart` uses.
Future<void> _openDisclosure(WidgetTester tester, String title) async {
  final Finder trigger = find.descendant(
    of: find.byWidgetPredicate(
      (Widget widget) => widget is DocsDisclosure && widget.title == title,
    ),
    matching: find.byKey(DocsDisclosure.triggerKey),
  );
  await tester.ensureVisible(trigger);
  await tester.pump();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(MotionDurations.open);
}

void main() {
  testWidgets(
    'renders the article at wide and narrow widths with no exceptions',
    (WidgetTester tester) async {
      await _pump(tester, size: _wide);

      expect(find.text(tabsDoc.title), findsWidgets);
      expect(find.byType(DocsShowcase), findsAtLeastNWidgets(1));
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
    'renders the house-shape section list, in order, and the sidebar TOC '
    'matches it heading for heading',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 6000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await _pump(tester, size: const Size(1440, 6000));

      final List<String> renderedIds = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.id)
          .toList();
      expect(renderedIds, _expectedSectionIds);

      final DocsLayout layout = tester.widget<DocsLayout>(
        find.byType(DocsLayout),
      );
      final List<String> tocAnchors = layout.toc
          .map((DocsTocEntry entry) => entry.anchor)
          .toList();
      expect(tocAnchors, _expectedSectionIds);

      final Map<String, String> titleById = <String, String>{
        for (final DocsSection section in tester.widgetList<DocsSection>(
          find.byType(DocsSection),
        ))
          section.id: section.title,
      };
      for (final DocsTocEntry entry in layout.toc) {
        expect(
          titleById[entry.anchor],
          entry.title,
          reason:
              'TOC entry for "${entry.anchor}" must read the same title as '
              'the DocsSection it points to',
        );
      }
    },
  );

  testWidgets(
    'the API table covers every Tabs and TabItem constructor parameter '
    'and every TabsVariant/static member',
    (WidgetTester tester) async {
      await _pump(tester);
      await _openDisclosure(tester, 'API Reference');

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

      // Scoped to this one specimen: its Info panel's text also appears
      // verbatim in the live Panels specimen further down the page, now
      // that both are mounted at once.
      Finder within(String text) =>
          find.descendant(of: find.byKey(key), matching: find.text(text));

      expect(tester.widget<Tabs>(find.byKey(key)).selectedIndex, 0);
      expect(within('Update your account details here.'), findsOneWidget);
      expect(
        within('See who else has access to this workspace.'),
        findsNothing,
      );

      await tester.tap(within('Team'), warnIfMissed: false);
      await tester.pump();

      expect(tester.widget<Tabs>(find.byKey(key)).selectedIndex, 1);
      expect(within('Update your account details here.'), findsNothing);
      expect(
        within('See who else has access to this workspace.'),
        findsOneWidget,
      );

      // A TabItem with content: null, a real state the source itself
      // documents (see tabs.dart's TabItem.content doc comment), renders
      // no panel at all when selected, and toggling to it must not throw.
      await tester.tap(within('More'), warnIfMissed: false);
      await tester.pump();
      expect(
        within('See who else has access to this workspace.'),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the Panels specimen mounts panel content and switches between them',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key key = ValueKey<String>('tabs-panels-specimen');
      expect(find.byKey(key), findsOneWidget);
      await tester.ensureVisible(find.byKey(key));

      // Scoped to this one specimen: its Account panel's text is identical
      // to the live Preview specimen's Info panel, both mounted at once.
      Finder within(String text) =>
          find.descendant(of: find.byKey(key), matching: find.text(text));

      expect(within('Update your account details here.'), findsOneWidget);
      await tester.tap(within('Password'), warnIfMissed: false);
      await tester.pump();
      expect(within('Change your password here.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('the Account settings specimen mounts a contentless Team trigger '
      'without throwing', (WidgetTester tester) async {
    await _pump(tester);

    const Key key = ValueKey<String>('tabs-account-settings-specimen');
    expect(find.byKey(key), findsOneWidget);
    await tester.ensureVisible(find.byKey(key));

    await tester.tap(find.text('Team').last, warnIfMissed: false);
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'the standalone Line specimen renders the line variant and switches '
    'panels',
    (WidgetTester tester) async {
      await _pump(tester);

      const Key key = ValueKey<String>('tabs-line-variant-specimen');
      expect(find.byKey(key), findsOneWidget);
      await tester.ensureVisible(find.byKey(key));

      expect(tester.widget<Tabs>(find.byKey(key)).variant, TabsVariant.line);

      // Scoped: 'Stats' is also this specimen's own choice of label for
      // Preview's Line cell above, both mounted at once.
      Finder within(String text) =>
          find.descendant(of: find.byKey(key), matching: find.text(text));

      await tester.tap(within('Stats'), warnIfMissed: false);
      await tester.pump();
      expect(
        within('Traffic and conversion, broken down by channel.'),
        findsWidgets,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Tabs and its trigger wire no Focus widget of their own: there is no '
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
            'if this starts failing, Tabs has grown real keyboard focus '
            'and the Accessibility/Keyboard sections of the docs page must '
            'be updated to stop saying otherwise',
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

    final ThemeController theme = ThemeController(mode: ColorMode.dark);
    addTearDown(theme.dispose);

    await tester.pumpWidget(
      ThemeScope(
        controller: theme,
        child: MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Tabs(
                items: const <TabItem>[
                  TabItem(label: 'Overview'),
                  TabItem(label: 'Analytics dashboard'),
                  TabItem(label: 'Notification preferences'),
                  TabItem(label: 'Billing and subscriptions'),
                  TabItem(label: 'Security settings'),
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

    // Tabs' track is an un-clipped, unscrolled Row (ActiveIndicator):
    // it neither scrolls nor wraps when its triggers do not fit, so a
    // RenderFlex overflow is the real, current behaviour, recorded here
    // rather than asserted away, so the docs page's Responsive section
    // stays honest if that ever changes.
    final dynamic exception = tester.takeException();
    expect(exception, isNotNull);
    expect(exception.toString(), contains('overflowed'));
  });

  testWidgets('the RTL specimen mirrors trigger order under a right-to-left '
      'Directionality and switching tabs still works', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    const Key key = ValueKey<String>('tabs-rtl-specimen');
    final Finder specimen = find.byKey(key);
    expect(specimen, findsOneWidget);
    await tester.ensureVisible(specimen);

    // Directionality.rtl is real here (not a synthetic MediaQuery), so
    // Flutter's own Row lays the first item (الحساب) out at the leading
    // edge for RTL, which is the *right*: the opposite of what the same
    // list order would render under LTR. This is the RTL section's own
    // mirroring claim, checked directly rather than assumed.
    final Offset firstTop = tester.getTopLeft(find.text('الحساب'));
    final Offset secondTop = tester.getTopLeft(find.text('الفريق'));
    expect(
      firstTop.dx,
      greaterThan(secondTop.dx),
      reason:
          'under RTL the first TabItem should paint to the right of '
          'the second, the same mirroring Flutter\'s own Row gives every '
          'other RTL layout: if this fails, the RTL section\'s claim '
          'that Tabs needs no direction-specific code is wrong',
    );

    expect(tester.widget<Tabs>(specimen).selectedIndex, 0);
    expect(find.text('تحديث بيانات حسابك هنا.'), findsOneWidget);

    await tester.tap(find.text('الفريق'), warnIfMissed: false);
    await tester.pump();

    expect(tester.widget<Tabs>(specimen).selectedIndex, 1);
    expect(
      find.text('من يملك صلاحية الوصول إلى مساحة العمل هذه.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'both themes render the article with no exceptions when flipped in '
    'place',
    (WidgetTester tester) async {
      final ThemeController theme = await _pump(tester, mode: ColorMode.light);
      expect(find.text(tabsDoc.title), findsWidgets);

      theme.setMode(ColorMode.dark);
      await tester.pump();
      expect(find.text(tabsDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation states that the component is installable', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(find.textContaining('not yet a registry item'), findsNothing);
    expect(find.textContaining('elattar add tabs'), findsWidgets);
  });

  testWidgets(
    'the state matrix documents selected, empty, focus-visible and reduced '
    'motion, and the page states the missing keyboard support plainly',
    (WidgetTester tester) async {
      await _pump(tester);
      await _openDisclosure(tester, 'States');

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

      await _openDisclosure(tester, 'Keyboard');
      expect(find.textContaining('no keyboard'), findsWidgets);
    },
  );
}
