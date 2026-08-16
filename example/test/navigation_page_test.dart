/// `/design-system/components/base/navigation` — the page, against the numbers
/// the reference actually renders.
///
/// Two harnesses, the split `selects_page_test.dart` established:
///
///  * [pumpNavigationInShell] mounts the real `DocsShell` at the 1440 × 900
///    reference frame and hands back the reading column's `RenderBox`. Every
///    oracle number below is measured from that origin, **pristine** — no menu
///    hovered, no tab switched, no disclosure toggled.
///  * [pumpNavigationPage] mounts the page alone in a tall frame so every
///    specimen is laid out and hit-testable at once.
///
/// Coordinates are the reference's document coordinates; the reading column
/// starts 112px down (`main` at 64 plus its own `py-12`), so every oracle
/// number is the measured top less 112.
///
/// The oracle was read off `http://localhost:3000` at 1440 × 900 on 2026-08-16
/// with `tool/verify/section-oracle.js`. Nothing on this page depends on the
/// wall clock, so — unlike `selects` — there is no `?clock=` freeze here.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/navigation.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/* ── The frame and the oracle ────────────────────────────────────────────── */

/// The behaviour frame: tall enough to lay the whole page out at once.
const Size _desktop = Size(1440, 6200);

/// The frame the reference is measured at.
const Size _referenceFrame = Size(1440, 900);

const String _route = '$dsRoot/components/base/navigation';

/// `--width-content`.
const double _columnWidth = 1080;

/// Where the reading column starts in document coordinates: `main` at 64 plus
/// its own 48px of top padding.
const double _columnTop = 112;

/// The reading column's own height — `main`'s 5539.1 less its `py-12` on both
/// edges. The number `vertical_parity_probe_test.dart`'s `_referenceHeight`
/// takes for this route at integration.
const double _columnHeight = 5443.1;

/// Each `section[id]`, as `(document top, border-box height)`.
///
/// The heights are the CSS border box, so `mb-20` — which this port pays as
/// padding inside the section's own box — comes back off before comparing.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'topnav': (top: 527.8, height: 318.3),
  'direction': (top: 926.1, height: 206.3),
  'tabs': (top: 1212.4, height: 702.3),
  'breadcrumb': (top: 1994.7, height: 222.9),
  'pagination': (top: 2297.5, height: 432.2),
  'navigation-menu': (top: 2809.7, height: 1223.7),
  'disclosure': (top: 4113.4, height: 355.1),
  'api': (top: 4548.5, height: 472.3),
  'rules': (top: 5100.8, height: 273.3),
};

/// Each control the oracle names, as `(document top, border-box height)`.
const Map<String, ({double top, double height})> _controlOracle =
    <String, ({double top, double height})>{
  // §3's three tracks: 40px each, on a 4px inset.
  'tabs-live': (top: 1371.7, height: 40),
  'tabs-account': (top: 1565.2, height: 40),
  'tabs-line': (top: 1758.7, height: 40),
  // §4's list — one line box of `text-sm`.
  'breadcrumb-list': (top: 2134.5, height: 18.56),
  // §5's row of cells.
  'pagination-row': (top: 2456.8, height: 40),
  // §6's three bars.
  'menu-viewport': (top: 2984.5, height: 40),
  'menu-no-viewport': (top: 3297.9, height: 40),
  'menu-indicator': (top: 3575.9, height: 40),
  // §7's two disclosures.
  'accordion': (top: 4272.7, height: 170.81),
  'collapsible-trigger': (top: 4272.7, height: 40),
};

/// The three tracks' own widths — `w-fit` around triggers that size to their
/// labels, so this is the sum of three, five and four of them plus the gaps.
const Map<String, double> _trackWidth = <String, double>{
  'tabs-live': 280.38,
  'tabs-account': 531.5,
  'tabs-line': 315.31,
};

/// Two logical pixels — the band the aggregates hold.
const double _tolerance = 2;

/// Half a pixel — the band every control anchor holds, and the band
/// `vertical_parity_probe_test.dart` holds the whole column to.
const double _fineTolerance = 0.5;

/* ── Harness ─────────────────────────────────────────────────────────────── */

/// The reference's own font binaries. Load-bearing: every number above is a
/// line box.
Future<void> _loadFont(String family, String file) async {
  final ByteData bytes = ByteData.sublistView(
    File('../assets/fonts/$file').readAsBytesSync(),
  );
  final FontLoader loader = FontLoader('packages/elattar_design_system/$family')
    ..addFont(Future<ByteData>.value(bytes));
  await loader.load();
}

extension on WidgetTester {
  void useViewport(Size size) {
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  }

  /// The page alone, laid out tall, under reduced motion.
  ///
  /// `MediaQuery(disableAnimations: true)` sits **below** `MaterialApp` so the
  /// framework's own does not win, and the body `DefaultTextStyle` the shell
  /// installs is brought along — without it every colour-inheriting string
  /// renders the framework's debug ink, and the balance chip has no line box
  /// to read.
  Future<void> pumpNavigationPage({
    DsThemeMode mode = DsThemeMode.light,
  }) async {
    useViewport(_desktop);
    final DsThemeController theme = DsThemeController(mode: mode);
    final AppRouter router = AppRouter(route: _route);
    addTearDown(theme.dispose);
    addTearDown(router.dispose);

    await pumpWidget(
      DsTheme(
        controller: theme,
        child: AppRouterScope(
          router: router,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (BuildContext context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                child: DefaultTextStyle(
                  style: DsText.styleOf(
                    context,
                    DsType.body,
                    color: DsTheme.of(context).foreground,
                  ),
                  child: const SingleChildScrollView(child: NavigationPage()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await pump();
    await pump(DsDurations.slow);
  }
}

/// The page inside the real [DocsShell] at the reference frame, and the reading
/// column's own [RenderBox].
///
/// `main.dart` belongs to the supervisor at integration, so the page is handed
/// to the shell directly rather than looked up through `pageFor`.
Future<RenderBox> pumpNavigationInShell(
  WidgetTester tester, {
  DsThemeMode mode = DsThemeMode.light,
}) async {
  tester.view.physicalSize = _referenceFrame;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final DsThemeController theme = DsThemeController(mode: mode);
  final AppRouter router = AppRouter(route: _route);
  addTearDown(theme.dispose);
  addTearDown(router.dispose);

  const Widget page = NavigationPage();
  await tester.pumpWidget(
    DsTheme(
      controller: theme,
      child: AppRouterScope(
        router: router,
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: DocsShell(route: _route, child: page),
        ),
      ),
    ),
  );
  // No settle: geometry is settled on the first laid-out frame, and PRISTINE is
  // the state the oracle was measured in.
  await tester.pump();

  return tester.renderObject<RenderBox>(find.byWidget(page));
}

/* ── Finders ─────────────────────────────────────────────────────────────── */

Finder _section(String id) => find.byWidgetPredicate(
      (Widget widget) => widget is DsSection && widget.id == id,
    );

Finder _in(String id, Finder matching) =>
    find.descendant(of: _section(id), matching: matching);

Finder _panel(String label) => find.byWidgetPredicate(
      (Widget widget) => widget is DsPanel && widget.label == label,
    );

/// The ten controls the oracle names.
Finder _control(String id) => switch (id) {
      'tabs-live' => _in('tabs', find.byType(DsSlidingPillGroup)).at(0),
      'tabs-account' => _in('tabs', find.byType(DsSlidingPillGroup)).at(1),
      'tabs-line' => _in('tabs', find.byType(DsSlidingPillGroup)).at(2),
      'breadcrumb-list' => _in('breadcrumb', find.byType(DsBreadcrumb)),
      'pagination-row' => _in('pagination', find.byType(DsPagination)),
      'menu-viewport' =>
        _in('navigation-menu', find.byType(DsNavigationMenu)).at(0),
      'menu-no-viewport' =>
        _in('navigation-menu', find.byType(DsNavigationMenu)).at(1),
      'menu-indicator' =>
        _in('navigation-menu', find.byType(DsNavigationMenu)).at(2),
      'accordion' => _in('disclosure', find.byType(DsAccordion)),
      _ => _in('disclosure', find.byType(DsButton)).first,
    };

/// Opens (or closes) an overlay: one frame for the prop to flip, and one more
/// for the portal the frame boundary brings in.
Future<void> settleOverlay(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

/// Runs an overlay's exit out and lets the portal unmount behind it.
Future<void> runOverlay(WidgetTester tester) async {
  await tester.pump(DsDurations.overlay);
  await tester.pump(DsDurations.tick);
  await tester.pump();
}

({double top, double height}) _boxIn(
  WidgetTester tester,
  RenderBox origin,
  Finder finder,
) {
  final RenderBox box = tester.renderObject<RenderBox>(finder);
  return (
    top: box.localToGlobal(Offset.zero, ancestor: origin).dy,
    height: box.size.height,
  );
}

/// The section with [id], with `mb-20` taken back off its height.
({double top, double height}) _sectionBox(
  WidgetTester tester,
  RenderBox origin,
  String id,
) {
  final ({double top, double height}) box = _boxIn(tester, origin, _section(id));
  return (top: box.top, height: box.height - ds(20));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
    await _loadFont('Redaction35', 'Redaction35-Italic.ttf');
  });

  /* ── Geometry ──────────────────────────────────────────────────────────── */

  group('vertical parity', () {
    testWidgets('the reading column is --width-content at the 1440 frame',
        (WidgetTester tester) async {
      final RenderBox column = await pumpNavigationInShell(tester);
      expect(column.size.width, _columnWidth);
    });

    testWidgets('the column stacks to the reference height',
        (WidgetTester tester) async {
      final RenderBox column = await pumpNavigationInShell(tester);
      // The parity probe's own band, not the looser aggregate one: this is the
      // number `_referenceHeight['navigation']` takes at integration.
      expect(column.size.height, closeTo(_columnHeight, _fineTolerance));
    });

    testWidgets('every section starts and ends where the reference does',
        (WidgetTester tester) async {
      final RenderBox column = await pumpNavigationInShell(tester);

      // Collected rather than asserted one at a time: a vertical drift is
      // cumulative, so the FIRST mismatch hides every section under it.
      final List<String> off = <String>[];
      for (final MapEntry<String, ({double top, double height})> want
          in _sectionOracle.entries) {
        final ({double top, double height}) got =
            _sectionBox(tester, column, want.key);
        final double wantTop = want.value.top - _columnTop;
        if ((got.top - wantTop).abs() > _tolerance) {
          off.add('#${want.key} starts at ${got.top.toStringAsFixed(2)}, '
              'the reference at ${wantTop.toStringAsFixed(2)}');
        }
        if ((got.height - want.value.height).abs() > _tolerance) {
          off.add('#${want.key} is ${got.height.toStringAsFixed(2)} tall, '
              'the reference ${want.value.height}');
        }
      }
      expect(off, isEmpty, reason: off.join('\n'));
    });

    testWidgets('every control lands on the reference\'s anchors',
        (WidgetTester tester) async {
      final RenderBox column = await pumpNavigationInShell(tester);

      final List<String> off = <String>[];
      for (final MapEntry<String, ({double top, double height})> want
          in _controlOracle.entries) {
        final ({double top, double height}) got =
            _boxIn(tester, column, _control(want.key));
        final double wantTop = want.value.top - _columnTop;
        if ((got.top - wantTop).abs() > _tolerance) {
          off.add('#${want.key} starts at ${got.top.toStringAsFixed(2)}, '
              'the reference at ${wantTop.toStringAsFixed(2)}');
        }
        if ((got.height - want.value.height).abs() > _fineTolerance) {
          off.add('#${want.key} is ${got.height.toStringAsFixed(2)} tall, '
              'the reference ${want.value.height}');
        }
      }
      expect(off, isEmpty, reason: off.join('\n'));
    });

    testWidgets('the three tab tracks are `w-fit`, not full width',
        (WidgetTester tester) async {
      await pumpNavigationInShell(tester);
      for (final MapEntry<String, double> want in _trackWidth.entries) {
        expect(
          tester.getSize(_control(want.key)).width,
          closeTo(want.value, _tolerance),
          reason: '#${want.key}: a track that filled its 1030px panel is a '
              'different component',
        );
      }
      // The ladder the section's own caption states.
      expect(DsTabs.trackHeight, 40);
      expect(DsTabs.triggerHeight, 32);
      expect(DsTabs.trackPadding, 4);
      expect(DsTabs.triggerPaddingX, 16);
    });

    testWidgets('the accordion trigger is 40.571 and its open panel 47.143',
        (WidgetTester tester) async {
      final RenderBox column = await pumpNavigationInShell(tester);
      // 10 + 18.5714 + 10, plus a 1px transparent border on each edge.
      final ({double top, double height}) trigger = _boxIn(
        tester,
        column,
        _in('disclosure', find.byType(DsMachineSurface)).first,
      );
      expect(trigger.height, closeTo(40.5714, 0.01));
      // Two lines of `text-sm` plus `pb-2.5`.
      final ({double top, double height}) content = _boxIn(
        tester,
        column,
        _in('disclosure', find.byType(DsUnfold)).first,
      );
      expect(content.height, closeTo(47.143, 0.01));
    });

    testWidgets('the geometry holds in dark as well as light',
        (WidgetTester tester) async {
      final RenderBox column =
          await pumpNavigationInShell(tester, mode: DsThemeMode.dark);
      expect(column.size.width, _columnWidth);
      expect(column.size.height, closeTo(_columnHeight, _fineTolerance));
    });
  });

  /* ── Copy ──────────────────────────────────────────────────────────────── */

  group('copy — verbatim', () {
    testWidgets('the header carries the nav\'s own strings',
        (WidgetTester tester) async {
      await pumpNavigationInShell(tester);
      final DsCategoryHit here = findCategory('base', 'navigation');
      expect(here.category.title, 'Navigation');
      // `.type-label` is `text-transform: uppercase` and `DsText` performs the
      // transform, so this is the string that renders.
      expect(find.text('BASE COMPONENTS · BASE'), findsOneWidget);
      // Twice: the page's own `h1` and the shell's nav entry beside it.
      expect(find.text('Navigation'), findsWidgets);
      expect(
        find.text('Tabs, breadcrumbs, pagination, the navigation menu and '
            'disclosure patterns.'),
        findsOneWidget,
      );
      expect(here.category.contents, <String>[
        'Tabs',
        'Breadcrumb',
        'Pagination',
        'Navigation Menu',
        'Accordion',
        'Collapsible',
      ]);
    });

    testWidgets('nine sections, in order, with the reference\'s titles',
        (WidgetTester tester) async {
      await pumpNavigationInShell(tester);
      final List<String> found = tester
          .widgetList<DsSection>(find.byType(DsSection))
          .map((DsSection s) => s.id)
          .toList();
      expect(found, _sectionOracle.keys.toList());

      final Map<String, String> titles = <String, String>{
        for (final DsSection s
            in tester.widgetList<DsSection>(find.byType(DsSection)))
          s.id: s.title,
      };
      expect(titles['topnav'], 'Top navigation pattern');
      expect(titles['disclosure'], 'Accordion & Collapsible');
      expect(titles['navigation-menu'], 'Navigation Menu');
      // §8 and §9 carry no description at all.
      final Map<String, String?> descriptions = <String, String?>{
        for (final DsSection s
            in tester.widgetList<DsSection>(find.byType(DsSection)))
          s.id: s.description,
      };
      expect(descriptions['api'], isNull);
      expect(descriptions['rules'], isNull);
      expect(
        descriptions['tabs'],
        contains('The active pill slides between triggers.'),
      );
    });

    testWidgets('the fourteen Panels, and the one note on them',
        (WidgetTester tester) async {
      await pumpNavigationInShell(tester);
      final List<DsPanel> panels =
          tester.widgetList<DsPanel>(find.byType(DsPanel)).toList();
      expect(
        panels.map((DsPanel p) => p.label).toList(),
        <String>[
          'Signed in',
          'Signed out',
          'RTL context',
          'Live Pulls / Top Hits',
          'Account tabs',
          'Line variant',
          'Pack detail',
          'Pack grid pagination',
          'Load more — for feeds',
          'With a viewport — one shared panel that resizes',
          'Without a viewport — each item owns its panel',
          'Indicator — the caret that names the open trigger',
          'Accordion — FAQ',
          'Collapsible — advanced filters',
        ],
      );
      expect(
        panels.where((DsPanel p) => p.note != null).map((DsPanel p) => p.note),
        <String>['direction=rtl', 'viewport={false}'],
      );
      // Five panels reach the panel edge: the two top bars and the three
      // navigation-menu stages.
      expect(panels.where((DsPanel p) => p.flush).length, 5);
    });

    testWidgets('the three Notes, and the captions outside the Panels',
        (WidgetTester tester) async {
      await pumpNavigationInShell(tester);
      expect(
        find.text('THE ACTIVE INDICATOR IS A RULE, NOT A GLOW'),
        findsOneWidget,
      );
      expect(find.text('KEYBOARD'), findsOneWidget);
      expect(find.text('WHERE THE STATE VARIANTS COME FROM'), findsOneWidget);
      final List<DsNote> notes =
          tester.widgetList<DsNote>(find.byType(DsNote)).toList();
      expect(notes, hasLength(3));
      // Every one of them is `tone="action"`; nothing on this page is a
      // warning.
      expect(
        notes.every((DsNote n) => n.tone == DsNoteTone.action),
        isTrue,
      );
      expect(
        _in('tabs', find.text('40px track, 4px inset, 32px triggers on 16px '
            'padding — the same ladder as every other control. Stock shadcn '
            'ships 32 / 3 / 25, none of which is on the 8-point scale.')),
        findsOneWidget,
      );
      expect(
        _in('pagination', find.text('Showing 25–48 of 184 packs')),
        findsOneWidget,
      );
      expect(_in('pagination', find.text('48 of 12,480 shown')), findsOneWidget);
    });

    testWidgets('§8 prints nine rows and §9 five dos against five don\'ts',
        (WidgetTester tester) async {
      await pumpNavigationInShell(tester);
      final DsMeta meta = tester.widget<DsMeta>(find.byType(DsMeta));
      expect(meta.items, hasLength(9));
      expect(meta.items.first.k, 'Tabs');
      expect(meta.items.last.k, 'aria-current="page"');

      final DsDoDont rules = tester.widget<DsDoDont>(find.byType(DsDoDont));
      expect(rules.dos, hasLength(5));
      expect(rules.donts, hasLength(5));
      for (final String dont in rules.donts) {
        expect(dont.startsWith("Don't"), isTrue);
      }
      expect(_in('rules', find.byType(DsDoDont)), findsOneWidget);
    });
  });

  /* ── §1 · the top bar ──────────────────────────────────────────────────── */

  group('§1 top navigation', () {
    testWidgets('eight buttons, one of them current', (WidgetTester tester) async {
      await pumpNavigationInShell(tester);
      for (final String label in <String>[
        'Packs',
        'Live Pulls',
        'Stash',
        'Wallet',
        'How It Works',
        'Leaderboard',
      ]) {
        expect(_in('topnav', find.text(label)), findsWidgets,
            reason: 'the bar should print "$label"');
      }
      expect(_in('topnav', find.text(r'$1,204.80')), findsOneWidget);
      expect(_in('topnav', find.text('Open Pack')), findsOneWidget);
      expect(_in('topnav', find.text('Log In')), findsOneWidget);
      expect(_in('topnav', find.text('Create Account')), findsOneWidget);
    });

    testWidgets('DRIFT 6 — the squish snaps on both bars, and nowhere else '
        'on the page', (WidgetTester tester) async {
      await pumpNavigationInShell(tester);
      final List<DsPress> bar =
          tester.widgetList<DsPress>(_in('topnav', find.byType(DsPress)))
              .toList();
      expect(bar, hasLength(8));
      for (final DsPress press in bar) {
        expect(press.downDuration, Duration.zero);
        expect(press.upDuration, Duration.zero);
      }
      // The navigation menu's own triggers keep the asymmetry, on the same
      // page, three sections down.
      final List<DsPress> menu = tester
          .widgetList<DsPress>(_in('navigation-menu', find.byType(DsPress)))
          .toList();
      expect(menu, isNotEmpty);
      for (final DsPress press in menu) {
        expect(press.downDuration, DsDurations.pressDown);
        expect(press.upDuration, DsDurations.base);
      }
    });

    testWidgets('the active item wears a 2px rule at `--color-action`',
        (WidgetTester tester) async {
      await pumpNavigationInShell(tester);
      // Filtered by height as well as by colour: the two logo tiles are
      // `bg-action` too, and they are 28px squares rather than 2px rules.
      final Iterable<Size> rules = tester
          .renderObjectList<RenderBox>(_in('topnav', find.byType(DecoratedBox)))
          .map((RenderBox b) => b.size)
          .where((Size s) => s.height == _TopNavRuleHeight.value);
      expect(rules, hasLength(1),
          reason: 'exactly one active item, on the signed-in bar; the '
              'signed-out bar has no current page at all');
      final Iterable<Color?> tint = tester
          .widgetList<DecoratedBox>(_in('topnav', find.byType(DecoratedBox)))
          .map((DecoratedBox b) => (b.decoration as BoxDecoration).color)
          .where((Color? c) => c == DsPalette.action);
      // Three sites carry `--color-action`: the rule and the two logo tiles.
      expect(tint, hasLength(3));
    });
  });

  /* ── §2 · direction ────────────────────────────────────────────────────── */

  group('§2 direction provider', () {
    testWidgets('the trail reads right-to-left', (WidgetTester tester) async {
      await pumpNavigationInShell(tester);
      expect(_in('direction', find.text('الحزم')), findsOneWidget);
      expect(_in('direction', find.text('نبض الأصل')), findsOneWidget);
      // The first crumb sits to the RIGHT of the last one, which is the whole
      // demonstration.
      final double first =
          tester.getTopLeft(_in('direction', find.text('الحزم'))).dx;
      final double last =
          tester.getTopLeft(_in('direction', find.text('نبض الأصل'))).dx;
      expect(first > last, isTrue);
    });
  });

  /* ── §3 · tabs ─────────────────────────────────────────────────────────── */

  group('§3 tabs', () {
    testWidgets('the pill travels and the view swaps',
        (WidgetTester tester) async {
      await tester.pumpNavigationPage();
      expect(
        _in('tabs',
            find.text('A live feed of every pull across the platform, '
                'updating continuously.')),
        findsOneWidget,
      );

      await tester.tap(_in('tabs', find.text('Top Hits')));
      await tester.pump();
      await tester.pump(DsDurations.base);

      expect(
        _in('tabs',
            find.text('The highest-value cards pulled in the last 24 hours.')),
        findsOneWidget,
      );
      expect(
        _in('tabs',
            find.text('A live feed of every pull across the platform, '
                'updating continuously.')),
        findsNothing,
      );
    });

    testWidgets('five triggers share one panel on the account set',
        (WidgetTester tester) async {
      await tester.pumpNavigationPage();
      for (final String label in <String>[
        'Overview',
        'Pull History',
        'Transactions',
        'Preferences',
        'Security',
      ]) {
        expect(_panelDescendant(tester, 'Account tabs', label), findsOneWidget);
      }
      // Tapping any of the other four leaves the section with no view at all,
      // which is what Radix does with a value that has no `TabsContent`.
      await tester.tap(_in('tabs', find.text('Security')));
      await tester.pump();
      await tester.pump(DsDurations.base);
      expect(
        _in('tabs',
            find.text('The five tabs the brief specifies for the account '
                'screen.')),
        findsNothing,
      );
    });

    testWidgets('the line variant travels as a 2px rule at `--action-ink`',
        (WidgetTester tester) async {
      await pumpNavigationInShell(tester);
      final DsThemeData theme =
          DsTheme.of(tester.element(find.byType(DsTabs).first));
      final Iterable<DecoratedBox> rules = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: _panel('Line variant'),
              matching: find.byType(DecoratedBox),
            ),
          )
          .where((DecoratedBox b) =>
              (b.decoration as BoxDecoration).color == theme.actionInk);
      expect(rules, hasLength(1));
      expect(DsTabs.ruleHeight, 2);
      // …and the filled pill is the other two sets' mark, at `--primary`.
      expect(
        tester
            .widgetList<DsMachineSurface>(find.descendant(
              of: _panel('Live Pulls / Top Hits'),
              matching: find.byType(DsMachineSurface),
            ))
            .where((DsMachineSurface s) => s.fill == theme.primary),
        hasLength(1),
      );
    });
  });

  /* ── §4 · breadcrumb ───────────────────────────────────────────────────── */

  group('§4 breadcrumb', () {
    testWidgets('three crumbs, two separators, and the last is not a link',
        (WidgetTester tester) async {
      await pumpNavigationInShell(tester);
      final DsBreadcrumb trail =
          tester.widget<DsBreadcrumb>(_in('breadcrumb', find.byType(DsBreadcrumb)));
      expect(trail.items, hasLength(3));
      expect(trail.items.last.isPage, isTrue);
      expect(trail.items.last.label, 'Origin Pulse — Series I');
      expect(trail.items.first.isPage, isFalse);
      // Two chevrons at `size-3.5`.
      final Iterable<DsIcon> separators = tester
          .widgetList<DsIcon>(_in('breadcrumb', find.byType(DsIcon)))
          .where((DsIcon i) => i.glyph == DsIconGlyph.chevronRight);
      expect(separators, hasLength(2));
      expect(separators.first.sizePx, DsBreadcrumb.separatorPx);
      expect(DsBreadcrumb.separatorPx, 14);
    });
  });

  /* ── §5 · pagination ───────────────────────────────────────────────────── */

  group('§5 pagination', () {
    testWidgets('seven cells, one of them current',
        (WidgetTester tester) async {
      await pumpNavigationInShell(tester);
      final List<DsPaginationLink> links = tester
          .widgetList<DsPaginationLink>(
              _in('pagination', find.byType(DsPaginationLink)))
          .toList();
      expect(links.map((DsPaginationLink l) => l.label).toList(),
          <String>['1', '2', '3', '12']);
      expect(links.where((DsPaginationLink l) => l.isActive), hasLength(1));
      expect(links[1].isActive, isTrue);
      expect(_in('pagination', find.byType(DsPaginationEllipsis)),
          findsOneWidget);
      expect(_in('pagination', find.text('Previous')), findsOneWidget);
      expect(_in('pagination', find.text('Next')), findsOneWidget);
    });

    testWidgets('DRIFT 10 — the numbers are the page\'s type and the words '
        'are the rung\'s', (WidgetTester tester) async {
      await pumpNavigationInShell(tester);
      // `size="icon"` declares no `text-*`, so the rung answers null and the
      // button merges only the ink.
      expect(DsButton.typeFor(DsButtonSize.icon, DsButtonEmphasis.none), isNull);
      expect(DsButton.typeFor(DsButtonSize.md, DsButtonEmphasis.none),
          DsComponentType.buttonLabel);
      // Previous keeps `px-4` on one edge and takes `pl-1.5!` on the other.
      expect(DsPaginationStep.tightPadding, 6);
      expect(DsPaginationStep.loosePadding, 16);
    });
  });

  /* ── §6 · navigation menu ──────────────────────────────────────────────── */

  group('§6 navigation menu', () {
    testWidgets('a trigger opens the shared viewport and closes it again',
        (WidgetTester tester) async {
      await tester.pumpNavigationPage();
      expect(find.byType(DsPopoverSurface), findsNothing);

      await tester.tap(_in('navigation-menu', find.text('Packs')).first);
      await settleOverlay(tester);

      final Finder panel = find.byType(DsPopoverSurface);
      expect(panel, findsOneWidget);
      for (final String title in <String>[
        'Eclipse Vault',
        'Origin Pulse',
        'Nightfall',
        'Draft Bundle',
      ]) {
        expect(find.descendant(of: panel, matching: find.text(title)),
            findsOneWidget);
      }
      expect(
        find.descendant(
          of: panel,
          matching: find.text('Sealed series with a published rarity table.'),
        ),
        findsOneWidget,
      );

      await tester.tap(_in('navigation-menu', find.text('Packs')).first);
      await settleOverlay(tester);
      await runOverlay(tester);
      expect(find.byType(DsPopoverSurface), findsNothing);
    });

    testWidgets('the Marketplace panel marks its current destination',
        (WidgetTester tester) async {
      await tester.pumpNavigationPage();
      await tester.tap(_in('navigation-menu', find.text('Marketplace')).first);
      await settleOverlay(tester);

      final List<DsNavigationMenuLink> links = tester
          .widgetList<DsNavigationMenuLink>(
              find.byType(DsNavigationMenuLink))
          .toList();
      expect(links.where((DsNavigationMenuLink l) => l.active), hasLength(1));
      expect(find.text('Ending soon'), findsOneWidget);
    });

    testWidgets('DRIFT 1 — the indicator sizes to the open trigger and never '
        'moves off the list\'s leading edge', (WidgetTester tester) async {
      await tester.pumpNavigationPage();
      final Finder menu = _in('navigation-menu', find.byType(DsNavigationMenu))
          .at(2);
      final Finder triggers = find.descendant(
        of: menu,
        matching: find.byType(DsPress),
      );
      final double listLeft = tester.getTopLeft(menu).dx;

      Future<Rect> openAndMeasure(int index) async {
        await tester.tap(triggers.at(index));
        await settleOverlay(tester);
        return tester.getRect(find.byType(DsNavigationMenuIndicator));
      }

      final Rect first = await openAndMeasure(0);
      final double firstTriggerWidth = tester.getSize(triggers.at(0)).width;
      expect(first.left, closeTo(listLeft, _fineTolerance));
      expect(first.width, closeTo(firstTriggerWidth.roundToDouble(), 1));

      final Rect second = await openAndMeasure(1);
      final double secondTriggerLeft = tester.getTopLeft(triggers.at(1)).dx;
      // The width follows…
      expect(second.width, greaterThan(first.width));
      // …and the position does not. This is the drift, asserted rather than
      // apologised for.
      expect(second.left, closeTo(listLeft, _fineTolerance));
      expect(second.left, lessThan(secondTriggerLeft));
    });

    testWidgets('the plain link sits level with the pills beside it',
        (WidgetTester tester) async {
      await pumpNavigationInShell(tester);
      final Finder leaderboard =
          _in('navigation-menu', find.text('Leaderboard'));
      expect(leaderboard, findsOneWidget);
      expect(
        tester.getSize(find.ancestor(
          of: leaderboard,
          matching: find.byType(SizedBox),
        ).first).height,
        DsNavigationMenu.triggerHeight,
      );
      expect(DsNavigationMenu.triggerHeight, 40);
    });
  });

  /* ── §7 · disclosure ───────────────────────────────────────────────────── */

  group('§7 accordion & collapsible', () {
    testWidgets('the FAQ opens on its first question and only ever shows one',
        (WidgetTester tester) async {
      await tester.pumpNavigationPage();
      const String odds = 'Every card in a pack is rolled independently '
          'against the published rarity table. The table is shown on each '
          'pack’s detail page before you buy.';
      const String sell = 'Yes. Sell-back is offered at the card’s current '
          'listed value, and the amount is credited to your available balance '
          'immediately.';

      expect(_in('disclosure', find.text(odds)), findsOneWidget);

      await tester.tap(_in('disclosure', find.text('Can I sell a card back?')));
      await tester.pump();
      await tester.pump(DsDurations.jelly);
      expect(_in('disclosure', find.text(sell)), findsOneWidget);
      expect(_in('disclosure', find.text(odds)), findsNothing);

      // `collapsible` — the open item closes itself.
      await tester.tap(_in('disclosure', find.text('Can I sell a card back?')));
      await tester.pump();
      await tester.pump(DsDurations.jelly);
      expect(_in('disclosure', find.text(sell)), findsNothing);
    });

    testWidgets('the collapsible pushes its filter block open',
        (WidgetTester tester) async {
      await tester.pumpNavigationPage();
      expect(_in('disclosure', find.text('Volatility')), findsNothing);

      await tester.tap(_in('disclosure', find.text('Advanced filters')));
      await tester.pump();
      await tester.pump(DsDurations.jelly);

      for (final String row in <String>[
        'Volatility',
        'Print run size',
        'Pack type',
        'Card set',
      ]) {
        expect(_in('disclosure', find.text(row)), findsOneWidget);
      }
    });

    testWidgets('the trigger chevron is a swap, not a rotation',
        (WidgetTester tester) async {
      await tester.pumpNavigationPage();
      Iterable<DsIconGlyph?> chevrons() => tester
          .widgetList<DsIcon>(_in('disclosure', find.byType(DsIcon)))
          .map((DsIcon i) => i.glyph);
      // One up (the open item) and two down.
      expect(chevrons().where((DsIconGlyph? g) => g == DsIconGlyph.chevronUp),
          hasLength(1));
      expect(chevrons().where((DsIconGlyph? g) => g == DsIconGlyph.chevronDown),
          hasLength(2));

      await tester.tap(_in('disclosure', find.text('How are the odds '
          'decided?')));
      await tester.pump();
      await tester.pump(DsDurations.jelly);
      // Nothing open: three downs.
      expect(chevrons().where((DsIconGlyph? g) => g == DsIconGlyph.chevronUp),
          isEmpty);
    });
  });
}

/// `h-0.5` — the active top-nav rule, the one 2px box in that section.
class _TopNavRuleHeight {
  const _TopNavRuleHeight._();

  static double get value => ds(0.5);
}

/// One string inside the Panel labelled [label].
Finder _panelDescendant(WidgetTester tester, String label, String text) =>
    find.descendant(of: _panel(label), matching: find.text(text));
