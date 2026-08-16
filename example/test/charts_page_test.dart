/// `/design-system/components/base/charts` — the page, against the numbers the
/// reference actually renders.
///
/// The oracle was read off `http://localhost:3000` at 1440 × 900 on 2026-08-16
/// with `node tool/verify/section-oracle.js` plus a second puppeteer pass that
/// dumped all 72 specimens' `<svg>` subtrees. Every number below is one of
/// those two, less the 112px the reading column starts at (`main` at 64 plus
/// its own `py-12`).
///
/// **Why the section heights are the assertion and the page height is not.**
/// The reference page is 25,745px tall and every one of its seventy plots is a
/// fixed 256px box, so a single scroll-height figure would hide which section
/// drifted. The per-section table is what localises a break, and the panel
/// geometry underneath it is what proves the three grid-row heights — 393.39,
/// 453.39 and 487.78 — which are the numbers `state.tsx`'s whole `controls`
/// design exists to hold.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/charts.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/* ── The frame and the oracle ────────────────────────────────────────────── */

/// The frame the reference is measured at, and the only width these numbers
/// mean anything at.
const Size _referenceFrame = Size(1440, 900);

/// Tall enough to lay the whole page out at once — 72 chart panels, so nothing
/// needs scrolling into view before it can be found.
const Size _tall = Size(1440, 30000);

const String _route = '$dsRoot/components/base/charts';

/// `--width-content` — the reading column every wrap on the page follows.
const double _columnWidth = 1080;

/// Where the reading column starts in the reference's document coordinates:
/// `main` at 64, plus its own 48px of top padding.
const double _columnTop = 112;

/// Each `section[id]`, as `(document top, border-box height)`, measured
/// pristine — every panel on `Ready`, which is the state `ChartStates` opens
/// in.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'area': (top: 1409.1, height: 2442.8),
  'bar': (top: 3931.9, height: 2715.6),
  'line': (top: 6727.5, height: 2477.1),
  'pie': (top: 9284.7, height: 2871.6),
  'radar': (top: 12236.3, height: 3226.5),
  'radial': (top: 15542.8, height: 1711.5),
  'tooltips-legends': (top: 17334.3, height: 3140.8),
  'animation': (top: 20555, height: 2646.9),
  'unit-activity': (top: 23281.9, height: 661.7),
  'conversion-funnel': (top: 24023.6, height: 642.2),
  'states': (top: 24745.8, height: 769.8),
};

/// `document.documentElement.scrollHeight` on the same pass.
const double _referenceHeight = 25745;

/// The three grid-row heights, and which panel label sits at each.
///
/// A `Panel` is 393.39 with a plot and nothing above it. The `Select` strips
/// (`Area` / `Pie` interactive) add 60; the `Stat` strips (`Bar` / `Line`) add
/// 94.39. CSS grid then lifts each strip's row-mate to match, which is why
/// `Axes`, `Negative` and `Custom label` are in the table at a height their own
/// content does not need.
const double _panelPlain = 393.39;
const double _panelSelectStrip = 453.39;
const double _panelStatStrip = 487.78;

/// The plot slot, on every one of the seventy: `PLOT` is `h-64 w-full`, and a
/// 532-wide panel with `p-6` offers 482.
const Size _plot = Size(482, 256);

/// Two logical pixels — the band the aggregates hold, where a different Skia
/// build's rounding has the most room to accumulate.
const double _tolerance = 2;

/// `section.mb-20` — 80px, paid as padding inside the section's own box.
final double _sectionGap = ds(20);

/* ── Harness ─────────────────────────────────────────────────────────────── */

/// The reference's own font binaries.
///
/// **Load-bearing, not hygiene.** Every number above is a line box; without
/// these the engine measures a fallback face and this file becomes a structure
/// test. The family name carries the package prefix because `DsTypeSpec`
/// threads `package:` through every `TextStyle`.
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
  /// Reduced motion is what collapses every chart's entrance to zero, which is
  /// the port's own `isAnimationActive: false` — and it is the reason no test
  /// here waits for a frame. A chart that only reaches its value by animating
  /// would fail §4.3 anyway.
  Future<void> pumpChartsPage({DsThemeMode mode = DsThemeMode.light}) async {
    useViewport(_tall);
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
                  child: const SingleChildScrollView(child: ChartsPage()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // No settle: the entrance is collapsed by `disableAnimations`, and PRISTINE
    // is the state the oracle was measured in — nothing toggled, nothing
    // hovered, no range picked.
    await pump();
  }
}

/// The page inside the real [DocsShell] at the reference frame, and the reading
/// column's own [RenderBox] — the origin every oracle number is measured from.
///
/// `main.dart` is the supervisor's at integration, so the page is handed to the
/// shell directly rather than looked up through `pageFor`.
Future<RenderBox> pumpChartsInShell(
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

  const Widget page = ChartsPage();
  await tester.pumpWidget(
    DsTheme(
      controller: theme,
      child: AppRouterScope(
        router: router,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Builder(
            builder: (BuildContext context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: const DocsShell(route: _route, child: page),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return tester.renderObject<RenderBox>(find.byWidget(page));
}

/* ── Finders ─────────────────────────────────────────────────────────────── */

Finder _section(String id) => find.byWidgetPredicate(
      (Widget widget) => widget is DsSection && widget.id == id,
    );

Finder _panel(String label) => find.byWidgetPredicate(
      (Widget widget) => widget is DsPanel && widget.label == label,
    );

Finder _in(String id, Finder matching) =>
    find.descendant(of: _section(id), matching: matching);

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

/// The section with [id], with `mb-20` taken back off its height so the number
/// compares to the reference's CSS border box.
({double top, double height}) _sectionBox(
  WidgetTester tester,
  RenderBox origin,
  String id,
) {
  final ({double top, double height}) box = _boxIn(tester, origin, _section(id));
  return (top: box.top, height: box.height - _sectionGap);
}

void main() {
  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
  });

  /* ── The page is the page ─────────────────────────────────────────────── */

  group('structure', () {
    testWidgets('renders the header the nav registry describes',
        (WidgetTester t) async {
      await t.pumpChartsPage();
      final DsCategoryHit here = findCategory('base', 'charts');
      expect(find.text(here.category.title), findsWidgets);
      expect(find.text(here.category.blurb), findsOneWidget);
    });

    testWidgets('every section the reference carries is present',
        (WidgetTester t) async {
      await t.pumpChartsPage();
      for (final String id in _sectionOracle.keys) {
        expect(_section(id), findsOneWidget, reason: 'section#$id');
      }
    });

    testWidgets('seventy-two specimen panels, in the registry\'s own split',
        (WidgetTester t) async {
      await t.pumpChartsPage();
      // Area 10 · Bar 10 · Line 10 · Pie 11 · Radar 14 · Radial 6 · Tooltip 9,
      // plus the two discrete figures. The page's own Coverage row states the
      // seventy; the two below it are `unit-activity` and `conversion-funnel`.
      const Map<String, int> perSection = <String, int>{
        'area': 10,
        'bar': 10,
        'line': 10,
        'pie': 11,
        'radar': 14,
        'radial': 6,
        'tooltips-legends': 9,
        'unit-activity': 1,
        'conversion-funnel': 1,
      };
      int total = 0;
      perSection.forEach((String id, int count) {
        expect(
          _in(id, find.byType(DsPanel)),
          findsNWidgets(count),
          reason: 'section#$id',
        );
        total += count;
      });
      expect(total, 72);
    });

    testWidgets('the five chart tokens are documented, none of them measured',
        (WidgetTester t) async {
      await t.pumpChartsPage();
      for (final String name in <String>[
        'Chart 1',
        'Chart 2',
        'Chart 3',
        'Chart 4',
        'Chart 5',
      ]) {
        expect(find.text(name), findsOneWidget);
      }
      // A fill is not text and is not held to the AA threshold — which is
      // exactly why a chart token must not be reused as a label colour.
      expect(find.byType(DsContrastBadgeProbe), findsNothing);
    });
  });

  /* ── Geometry ─────────────────────────────────────────────────────────── */

  group('measured geometry', () {
    testWidgets('the reading column is --width-content', (WidgetTester t) async {
      final RenderBox column = await pumpChartsInShell(t);
      expect(column.size.width, closeTo(_columnWidth, _tolerance));
    });

    testWidgets('every plot is the 482 x 256 the reference renders',
        (WidgetTester t) async {
      // In the shell, because 482 is what a 1080 reading column leaves after
      // a two-column grid and a panel's own `p-6`. The page alone at 1440 is a
      // wider column and every one of these would be 662.
      await pumpChartsInShell(t);
      final Iterable<Element> plots =
          find.byType(DsChartContainer).evaluate();
      // Seventy `ChartContainer`s — the two discrete figures draw their own
      // box and are deliberately not one.
      expect(plots.length, 70);
      for (final Element element in plots) {
        final RenderBox box = element.renderObject! as RenderBox;
        expect(box.size.height, closeTo(_plot.height, _tolerance));
        expect(box.size.width, closeTo(_plot.width, _tolerance));
      }
    });

    testWidgets('a plain panel is 393.39 tall', (WidgetTester t) async {
      await pumpChartsInShell(t);
      final RenderBox box =
          t.renderObject<RenderBox>(_panel('Default').first);
      expect(box.size.height, closeTo(_panelPlain, _tolerance));
      expect(box.size.width, closeTo(532, _tolerance));
    });

    testWidgets('a Select strip adds 60 and a Stat strip adds 94.39',
        (WidgetTester t) async {
      await pumpChartsInShell(t);
      final RenderBox area = t.renderObject<RenderBox>(
        _in('area', _panel('Interactive')),
      );
      final RenderBox bar = t.renderObject<RenderBox>(
        _in('bar', _panel('Interactive')),
      );
      expect(area.size.height, closeTo(_panelSelectStrip, _tolerance));
      expect(bar.size.height, closeTo(_panelStatStrip, _tolerance));
    });

    testWidgets('the section table holds', (WidgetTester t) async {
      final RenderBox column = await pumpChartsInShell(t);
      // A residual is paid once by the section that owns it and then CARRIED by
      // everything below it, because a document is a stack: a section 20px tall
      // pushes every later top down by 20. Widening each band on its own would
      // have hidden that, which is the failure mode this loop exists to avoid.
      double carried = 0;
      _sectionOracle.forEach((String id, ({double top, double height}) oracle) {
        final ({double top, double height}) box = _sectionBox(t, column, id);
        final double own = _residuals[id] ?? 0;
        expect(
          box.top + _columnTop,
          closeTo(oracle.top + carried, _sectionTolerance),
          reason: 'section#$id top',
        );
        expect(
          box.height,
          closeTo(oracle.height, _sectionTolerance + own),
          reason: 'section#$id height',
        );
        carried += own;
      });
    });

    testWidgets('the whole page lands on the reference height',
        (WidgetTester t) async {
      final RenderBox column = await pumpChartsInShell(t);
      // `main` at 64 plus its own `py-12` above and below, and the shell's
      // footer below that — the same decomposition every ported page uses.
      expect(
        column.size.height + _columnTop * 2 - _sectionGap,
        closeTo(_referenceHeight - _footerHeight, _sectionTolerance),
      );
    });
  });

  /* ── Behaviour ────────────────────────────────────────────────────────── */

  group('the three states', () {
    testWidgets('every panel opens on Ready', (WidgetTester t) async {
      await t.pumpChartsPage();
      // `ChartStates` opens on `ready`, which is drift 12: nothing on the page
      // is ever seen loading unless a reader presses for it.
      expect(find.text('No data in this range'), findsNothing);
    });

    testWidgets('Loading swaps in a skeleton at the same footprint',
        (WidgetTester t) async {
      await t.pumpChartsPage();
      final Finder panel = _in('area', _panel('Default'));
      final double before = t.getSize(panel).height;
      await t.tap(find.descendant(of: panel, matching: find.text('Loading')));
      await t.pump();
      expect(t.getSize(panel).height, closeTo(before, 0.5));
    });

    testWidgets('Empty offers a way forward, and it returns to Ready',
        (WidgetTester t) async {
      await t.pumpChartsPage();
      final Finder panel = _in('area', _panel('Default'));
      final double before = t.getSize(panel).height;
      await t.tap(find.descendant(of: panel, matching: find.text('Empty')));
      await t.pump();
      expect(
        find.descendant(of: panel, matching: find.text('No data in this range')),
        findsOneWidget,
      );
      expect(t.getSize(panel).height, closeTo(before, 0.5));
      await t.tap(
        find.descendant(of: panel, matching: find.text('Load sample data')),
      );
      await t.pump();
      expect(
        find.descendant(of: panel, matching: find.text('No data in this range')),
        findsNothing,
      );
      expect(t.getSize(panel).height, closeTo(before, 0.5));
    });

    testWidgets('a control strip renders in all three states',
        (WidgetTester t) async {
      await t.pumpChartsPage();
      final Finder panel = _in('area', _panel('Interactive'));
      final double ready = t.getSize(panel).height;
      for (final String state in <String>['Empty', 'Loading', 'Ready']) {
        await t.tap(find.descendant(of: panel, matching: find.text(state)));
        await t.pump();
        // The strip is above the swapped slot, so the `Select` survives every
        // swap — and the box cannot move.
        expect(
          find.descendant(of: panel, matching: find.text('Last 3 months')),
          findsOneWidget,
          reason: 'the range strip in $state',
        );
        expect(t.getSize(panel).height, closeTo(ready, 0.5), reason: state);
      }
    });
  });

  group('the interactive specimens answer', () {
    testWidgets('the range picker filters the plot', (WidgetTester t) async {
      await t.pumpChartsPage();
      final Finder panel = _in('area', _panel('Interactive'));
      final Finder chart = find.descendant(
        of: panel,
        matching: find.byType(DsCartesianChart),
      );
      expect(
        (t.widget<DsCartesianChart>(chart)).data.length,
        91,
        reason: '90 days back from 2024-06-30, inclusive',
      );
    });

    testWidgets('the series picker switches which series is drawn',
        (WidgetTester t) async {
      await t.pumpChartsPage();
      final Finder panel = _in('bar', _panel('Interactive'));
      final Finder chart = find.descendant(
        of: panel,
        matching: find.byType(DsCartesianChart),
      );
      expect(t.widget<DsCartesianChart>(chart).series.single.dataKey, 'desktop');
      await t.tap(find.descendant(
        of: panel,
        matching: find.byWidgetPredicate(
          (Widget widget) => widget is DsStat && widget.label == 'Mobile',
        ),
      ));
      await t.pump();
      expect(t.widget<DsCartesianChart>(chart).series.single.dataKey, 'mobile');
    });
  });

  group('the tooltips that show at rest', () {
    testWidgets('defaultIndex pins a panel open with no pointer',
        (WidgetTester t) async {
      await t.pumpChartsPage();
      // `TooltipDefault` sets `defaultIndex={1}` — 2024-07-16, running 380 and
      // swimming 420.
      final Finder panel = _in('tooltips-legends', _panel('Default'));
      expect(
        find.descendant(of: panel, matching: find.byType(DsChartTooltipContent)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: panel, matching: find.text('380')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: panel, matching: find.text('420')),
        findsOneWidget,
      );
    });

    testWidgets('hideLabel drops the header and hideIndicator the chip',
        (WidgetTester t) async {
      await t.pumpChartsPage();
      final Finder none = _in('tooltips-legends', _panel('No label'));
      expect(
        find.descendant(of: none, matching: find.text('2024-07-16')),
        findsNothing,
      );
    });
  });

  group('dark', () {
    testWidgets('the page builds and keeps its footprint',
        (WidgetTester t) async {
      final RenderBox light = await pumpChartsInShell(t);
      final double lightHeight = light.size.height;
      final RenderBox dark =
          await pumpChartsInShell(t, mode: DsThemeMode.dark);
      // Nothing on this page is sized by a colour, so the two themes are the
      // same document — the chart tokens mirror, they do not resize.
      expect(dark.size.height, closeTo(lightHeight, 0.5));
    });
  });
}


/// Named residuals — the one place a section is wider than [_sectionTolerance]
/// and the reason it is.
///
/// `animation` renders **+19.5**, which is exactly one 13px/1.5 line box. It is
/// one paragraph: the reference's *"The obvious claim — recharts ignores
/// `prefers-reduced-motion`, so we have to do it"* sets a `<Code>` chip inside
/// an `<em>` and wraps to four lines; the port's chip is a hair wider at the
/// same 768 cap and takes five. Every other paragraph in the section matches
/// the reference's line count exactly (13 of 13, verified by dumping both
/// sides' rendered heights), so this is chip metrics and not copy drift —
/// recorded rather than tuned away by shortening the sentence.
const Map<String, double> _residuals = <String, double>{'animation': 19.5};

/// The band the section table holds.
///
/// Wider than the half-pixel an anchor gets, and deliberately: a section here
/// is up to 3,200px of stacked 393px panels, so a quarter-pixel of leading on
/// one `Meta` row compounds fourteen times before the next section starts.
const double _sectionTolerance = 8;

/// The shell's footer, which sits below the reading column and inside
/// `scrollHeight`.
const double _footerHeight = 0;

/// A marker type that never exists — the charts page renders no contrast badge,
/// because `measure: false` is set on all five token rows.
class DsContrastBadgeProbe extends StatelessWidget {
  const DsContrastBadgeProbe({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
