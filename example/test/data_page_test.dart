/// `/design-system/components/base/data` — the page, against the numbers the
/// reference actually renders.
///
/// Two harnesses, and the split is the one `menus_page_test.dart` established:
///
///  * [pumpDataInShell] mounts the real `DocsShell` at the 1440 × 900 reference
///    frame and hands back the reading column's `RenderBox`. Every oracle
///    number below is measured from that origin, **pristine** — nothing sorted,
///    nothing filtered, nothing hovered, which is the state the reference was
///    measured in.
///  * [pumpDataPage] mounts the page alone in a tall frame so every specimen is
///    laid out and hit-testable at once. The data table sorts, filters, ticks
///    and pages there.
///
/// The oracle was read off `http://localhost:3000` at 1440 × 900 on 2026-08-16
/// with `node tool/verify/section-oracle.js
/// /design-system/components/base/data`, and the specimen boxes with a
/// `getBoundingClientRect` sweep in the same session. Coordinates are the
/// reference's document coordinates; the reading column starts 112px down
/// (`main` at 64 plus its own `py-12`), so every oracle number here is the
/// measured top less 112.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/data_table_demo.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/data.dart';
import 'package:example/shell.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/* ── The frame and the oracle ────────────────────────────────────────────── */

/// Tall enough to lay the whole page out at once, so nothing needs scrolling
/// into view before it can be tapped.
const Size _desktop = Size(1440, 9000);

/// The frame the reference is measured at.
const Size _referenceFrame = Size(1440, 900);

const String _route = '$dsRoot/components/base/data';

/// Where the reading column starts in the reference's document coordinates.
const double _columnTop = 112;

/// The reading column's own height — `main`'s 8490.8 less its `py-12` on both
/// edges.
///
/// This is the number `vertical_parity_probe_test.dart`'s `_referenceHeight`
/// takes for this route at integration.
const double _columnHeight = 8394.8;

/// Each `section[id]`, as `(document top, border-box height)`.
///
/// The heights are the CSS border box, so `mb-20` — which this port pays as
/// padding inside the section's own box — comes back off before comparing.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'table': (top: 547.34, height: 530.86),
  'data-table': (top: 1158.2, height: 1419.3),
  'badge': (top: 2657.5, height: 385.3),
  'avatar': (top: 3122.8, height: 405.8),
  'card': (top: 3608.59, height: 375.48),
  'stat': (top: 4064.08, height: 1877.59),
  'item': (top: 6021.67, height: 326.92),
  'marker': (top: 6428.59, height: 569.05),
  'separator': (top: 7077.64, height: 293.8),
  'api': (top: 7451.44, height: 462.08),
  'rules': (top: 7993.52, height: 332.3),
};

/// `mb-20` — the 80px every section pays below itself.
const double _sectionMargin = 80;

/// The panels, in document coordinates, in DOM order.
const List<({double top, double height})> _panelOracle =
    <({double top, double height})>[
  (top: 645.64, height: 297.06), // §table — the transaction table, flush
  (top: 1276, height: 379.5), // §data-table — live
  (top: 1679.5, height: 363.5), // §data-table — loading
  (top: 2755.8, height: 106), // §badge — variants
  (top: 2877.8, height: 165), // §badge — with glyphs
  (top: 3221.09, height: 173.5), // §avatar — sizes and states
  (top: 3410.59, height: 118), // §avatar — group
  (top: 3706.89, height: 277.19), // §card — with action
  (top: 3706.89, height: 277.19), // §card — with figures
  (top: 4181.88, height: 224.89), // §stat — anatomy
  (top: 4422.77, height: 430.28), // §stat — colour blindness
  (top: 4869.05, height: 275.28), // §stat — the delta on its own
  (top: 5340.89, height: 312.39), // §stat — loading, live
  (top: 5669.28, height: 272.39), // §stat — when a stat navigates
  (top: 6100.47, height: 248.13), // §item — payment methods
  (top: 6526.89, height: 198.69), // §marker — three variants
  (top: 6741.58, height: 140.06), // §marker — in use
  (top: 7156.44, height: 215), // §separator — horizontal and vertical
];

/// The specimens whose own box the reference reports.
const Map<String, ({double top, double height, double width})>
    _specimenOracle = <String, ({double top, double height, double width})>{
  // The transaction `<table>`: 40 + 4×37 + 36.5 + 16 + an 18.56 caption.
  'transaction-table': (top: 682.64, height: 259.06, width: 1078),
  // The one-row delta table: a 40px head over a 47.28px row.
  'delta-table': (top: 4930.05, height: 87.28, width: 1030),
  // The first card, footer and all.
  'card-action': (top: 3767.89, height: 187.19, width: 482),
  // The second: no footer, so `py-(--card-spacing)` stays on both edges.
  'card-figures': (top: 3767.89, height: 191.19, width: 482),
  // The state grid's five tiles.
  'state-grid': (top: 5160.33, height: 164.56, width: 1080),
  // The navigating stat's card.
  'navigating-card': (top: 5730.28, height: 107.89, width: 332.66),
  // The `max-w-md` measure in §separator.
  'separator-measure': (top: 7217.44, height: 129, width: 448),
};

/// Every `[data-slot=avatar]` in §avatar's first panel, as `(x, y, size)`.
const List<({double x, double y, double size})> _avatarOracle =
    <({double x, double y, double size})>[
  (x: 325, y: 3294.09, size: 24),
  (x: 365, y: 3290.09, size: 32),
  (x: 413, y: 3286.09, size: 40),
  (x: 469, y: 3282.09, size: 48),
  (x: 533, y: 3286.09, size: 40),
  (x: 589, y: 3286.09, size: 40),
];

/// The avatar group's four circles and its count, at a 24px pitch.
const List<double> _avatarGroupX = <double>[325, 349, 373, 397, 421];
const double _avatarGroupY = 3471.59;

/// Two logical pixels — the band the aggregates hold.
const double _tolerance = 2;

/// Half a pixel — the band every anchor holds.
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
  Future<void> pumpDataPage({DsThemeMode mode = DsThemeMode.light}) async {
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
                  child: const SingleChildScrollView(
                    child: SizedBox(
                      width: DsWidths.content,
                      child: DataPage(),
                    ),
                  ),
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
Future<RenderBox> pumpDataInShell(
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

  const Widget page = DataPage();
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

/// A pointer that can hover, with a fresh id each time.
int _pointer = 400;

Future<TestGesture> _hover(WidgetTester tester, Offset location) async {
  final TestGesture gesture = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
    pointer: _pointer++,
  );
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await gesture.moveTo(location);
  await tester.pump();
  return gesture;
}

void main() {
  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
    await _loadFont('Redaction35', 'Redaction35-Italic.ttf');
  });

  group('geometry — the reference\'s own numbers', () {
    testWidgets('the reading column stacks to the reference\'s height',
        (WidgetTester tester) async {
      final RenderBox column = await pumpDataInShell(tester);
      expect(column.size.height, closeTo(_columnHeight, _fineTolerance));
      expect(column.size.width, DsWidths.content);
    });

    testWidgets('every section starts and ends where the reference does',
        (WidgetTester tester) async {
      final RenderBox column = await pumpDataInShell(tester);

      for (final MapEntry<String, ({double height, double top})> entry
          in _sectionOracle.entries) {
        final ({double height, double top}) measured =
            _boxIn(tester, column, _section(entry.key));
        expect(
          measured.top,
          closeTo(entry.value.top - _columnTop, _fineTolerance),
          reason: '${entry.key} does not start where the reference does',
        );
        expect(
          measured.height - _sectionMargin,
          closeTo(entry.value.height, _fineTolerance),
          reason: '${entry.key} is not the reference\'s height',
        );
      }
    });

    testWidgets('every panel lands on its measured box',
        (WidgetTester tester) async {
      final RenderBox column = await pumpDataInShell(tester);
      final List<RenderBox> panels = tester
          .renderObjectList<RenderBox>(find.byType(DsPanel))
          .toList(growable: false);

      expect(panels.length, _panelOracle.length);
      for (int i = 0; i < panels.length; i++) {
        final double top =
            panels[i].localToGlobal(Offset.zero, ancestor: column).dy;
        expect(
          top,
          closeTo(_panelOracle[i].top - _columnTop, _fineTolerance),
          reason: 'panel $i does not start where the reference does',
        );
        expect(
          panels[i].size.height,
          closeTo(_panelOracle[i].height, _fineTolerance),
          reason: 'panel $i is not the reference\'s height',
        );
      }
    });

    testWidgets('the four tables land on their measured boxes',
        (WidgetTester tester) async {
      final RenderBox column = await pumpDataInShell(tester);

      final RenderBox transaction =
          tester.renderObject<RenderBox>(_in('table', find.byType(DsTable)));
      expect(
        transaction.localToGlobal(Offset.zero, ancestor: column).dy,
        closeTo(
          _specimenOracle['transaction-table']!.top - _columnTop,
          _tolerance,
        ),
      );
      expect(
        transaction.size.height,
        closeTo(_specimenOracle['transaction-table']!.height, _tolerance),
      );
      expect(
        transaction.size.width,
        closeTo(_specimenOracle['transaction-table']!.width, _fineTolerance),
      );

      final RenderBox delta =
          tester.renderObject<RenderBox>(_in('stat', find.byType(DsTable)));
      expect(
        delta.size.height,
        closeTo(_specimenOracle['delta-table']!.height, _tolerance),
      );
      expect(
        delta.size.width,
        closeTo(_specimenOracle['delta-table']!.width, _fineTolerance),
      );
    });

    testWidgets('the two cards keep their measured heights',
        (WidgetTester tester) async {
      final RenderBox column = await pumpDataInShell(tester);
      final List<RenderBox> cards = tester
          .renderObjectList<RenderBox>(_in('card', find.byType(DsCard)))
          .toList(growable: false);

      expect(cards.length, 2);
      expect(
        cards[0].size.height,
        closeTo(_specimenOracle['card-action']!.height, _tolerance),
        reason: 'the card with a footer pays pb-0',
      );
      expect(
        cards[1].size.height,
        closeTo(_specimenOracle['card-figures']!.height, _tolerance),
        reason: 'the card without one keeps both edges',
      );
      expect(
        cards[0].size.width,
        closeTo(_specimenOracle['card-action']!.width, _tolerance),
      );
      expect(
        cards[0].localToGlobal(Offset.zero, ancestor: column).dy,
        closeTo(_specimenOracle['card-action']!.top - _columnTop, _tolerance),
      );
    });

    testWidgets('every avatar is where and what the reference measured',
        (WidgetTester tester) async {
      final RenderBox column = await pumpDataInShell(tester);
      final List<RenderBox> avatars = tester
          .renderObjectList<RenderBox>(
            find.descendant(
              of: _panel('Sizes and states'),
              matching: find.byType(DsAvatar),
            ),
          )
          .toList(growable: false);

      expect(avatars.length, _avatarOracle.length);
      for (int i = 0; i < avatars.length; i++) {
        final Offset at = avatars[i].localToGlobal(Offset.zero,
            ancestor: column);
        expect(avatars[i].size.width, _avatarOracle[i].size);
        expect(avatars[i].size.height, _avatarOracle[i].size);
        expect(
          at.dx,
          closeTo(_avatarOracle[i].x - 300, _tolerance),
          reason: 'avatar $i sits at the wrong x',
        );
        expect(
          at.dy,
          closeTo(_avatarOracle[i].y - _columnTop, _tolerance),
          reason: 'avatar $i sits at the wrong y',
        );
      }
    });

    testWidgets('the group overlaps at a 24px pitch',
        (WidgetTester tester) async {
      final RenderBox column = await pumpDataInShell(tester);
      final List<RenderBox> circles = tester
          .renderObjectList<RenderBox>(
            find.descendant(
              of: find.byType(DsAvatarGroup),
              matching: find.byWidgetPredicate((Widget w) =>
                  w is DsAvatar || w is DsAvatarGroupCount),
            ),
          )
          .toList(growable: false);

      expect(circles.length, _avatarGroupX.length);
      for (int i = 0; i < circles.length; i++) {
        final Offset at =
            circles[i].localToGlobal(Offset.zero, ancestor: column);
        expect(
          at.dx,
          closeTo(_avatarGroupX[i] - 300, _fineTolerance),
          reason: 'group member $i is not 8px into its neighbour',
        );
        expect(at.dy, closeTo(_avatarGroupY - _columnTop, _tolerance));
      }
    });

    testWidgets('the state grid and the navigating card hold their boxes',
        (WidgetTester tester) async {
      final RenderBox column = await pumpDataInShell(tester);

      final ({double height, double top}) grid =
          _boxIn(tester, column, find.byType(DsStateGrid));
      expect(
        grid.top,
        closeTo(_specimenOracle['state-grid']!.top - _columnTop, _tolerance),
      );
      expect(
        grid.height,
        closeTo(_specimenOracle['state-grid']!.height, _tolerance),
      );

      final RenderBox card = tester.renderObject<RenderBox>(
        find.descendant(
          of: _panel('When a stat navigates'),
          matching: find.byType(DsCard),
        ),
      );
      expect(
        card.size.height,
        closeTo(_specimenOracle['navigating-card']!.height, _tolerance),
      );
      expect(
        card.size.width,
        closeTo(_specimenOracle['navigating-card']!.width, _tolerance),
      );
    });

    testWidgets('every Stat has the same footprint in every state',
        (WidgetTester tester) async {
      await tester.pumpDataPage();
      final Iterable<RenderBox> stats = tester
          .renderObjectList<RenderBox>(find.byType(DsStat));

      // 75.89 — label 11 + 8 + figure 29.39 + 8 + delta row 19.5. Every stat
      // on the page carries a delta line except none: all of them do.
      for (final RenderBox stat in stats) {
        expect(stat.size.height, closeTo(75.89, _fineTolerance));
      }
    });
  });

  group('behaviour — the page is live', () {
    testWidgets('a transaction row lights on hover and goes out again',
        (WidgetTester tester) async {
      await tester.pumpDataPage();

      final Finder table = _in('table', find.byType(DsTable));
      final Finder detail = find.descendant(
        of: table,
        matching: find.text('Voidwing Ascendant'),
      );
      expect(detail, findsOneWidget);

      Color? fillOf(Finder cell) {
        final RenderBox box = tester.renderObject<RenderBox>(cell);
        final Container container = tester.widget<Container>(
          find
              .ancestor(of: cell, matching: find.byType(Container))
              .first,
        );
        expect(box.size.height, greaterThan(0));
        return (container.decoration! as BoxDecoration).color;
      }

      expect(fillOf(detail)?.a ?? 0, 0, reason: 'a resting row has no fill');

      final TestGesture gesture =
          await _hover(tester, tester.getCenter(detail));
      await tester.pump(DsDurations.transitionDefault);
      final Color? hovered = fillOf(detail);
      expect(hovered, isNotNull);
      // `hover:bg-muted/50`.
      expect(hovered!.a, closeTo(0.5, 0.02));

      await gesture.moveTo(const Offset(4, 4));
      await tester.pump();
      await tester.pump(DsDurations.transitionDefault);
      expect(fillOf(detail)?.a ?? 0, closeTo(0, 0.02));
    });

    testWidgets('the data table sorts, and Price sorts descending first',
        (WidgetTester tester) async {
      await tester.pumpDataPage();

      List<String> cards() => tester
          .widgetList<Text>(
            find.descendant(
              of: find.byType(DataTableDemo).first,
              matching: find.byType(Text),
            ),
          )
          .map((Text t) => t.data ?? '')
          .where((String s) => s.startsWith(r'$'))
          .toList();

      expect(cards(), <String>[r'$4,820', r'$1,240', r'$320', r'$7,600']);

      await tester.tap(find.descendant(
        of: find.byType(DataTableDemo).first,
        matching: find.text('Price'),
      ));
      await tester.pump();
      expect(
        cards(),
        <String>[r'$21,000', r'$7,600', r'$4,820', r'$1,240'],
        reason: 'a numeric column sorts descending first',
      );

      await tester.tap(find.descendant(
        of: find.byType(DataTableDemo).first,
        matching: find.text('Price'),
      ));
      await tester.pump();
      expect(cards(), <String>[r'$95', r'$180', r'$320', r'$640']);

      await tester.tap(find.descendant(
        of: find.byType(DataTableDemo).first,
        matching: find.text('Price'),
      ));
      await tester.pump();
      expect(
        cards(),
        <String>[r'$4,820', r'$1,240', r'$320', r'$7,600'],
        reason: 'the third click removes the sort',
      );
    });

    testWidgets('Grade sorts as plain text — PSA 10 before PSA 9',
        (WidgetTester tester) async {
      await tester.pumpDataPage();

      await tester.tap(find.descendant(
        of: find.byType(DataTableDemo).first,
        matching: find.text('Grade'),
      ));
      await tester.pump();

      final List<String> grades = tester
          .widgetList<DsBadge>(find.descendant(
            of: find.byType(DataTableDemo).first,
            matching: find.byType(DsBadge),
          ))
          .map((DsBadge b) => b.label)
          .toList();
      expect(grades, <String>['PSA 10', 'PSA 10', 'PSA 10', 'PSA 9']);
    });

    testWidgets('filtering to nothing shows the Empty, and it clears again',
        (WidgetTester tester) async {
      await tester.pumpDataPage();

      final Finder field = find
          .descendant(
            of: find.byType(DataTableDemo).first,
            matching: find.byType(DsInput),
          )
          .first;
      await tester.enterText(field, 'zzz');
      await tester.pump();

      expect(find.text('No cards match “zzz”'), findsOneWidget);
      expect(find.text('Page 1 of 1 · 0 of 8 cards'), findsOneWidget);

      await tester.tap(find.text('Clear filter'));
      await tester.pump();
      expect(find.text('No cards match “zzz”'), findsNothing);
      expect(find.text('Page 1 of 2 · 8 of 8 cards'), findsOneWidget);
    });

    testWidgets('a row ticks, the counter appears, and the header goes '
        'indeterminate', (WidgetTester tester) async {
      await tester.pumpDataPage();

      final Finder boxes = find.descendant(
        of: find.byType(DataTableDemo).first,
        matching: find.byType(DsCheckbox),
      );
      expect(tester.widgetList<DsCheckbox>(boxes).length, 5);

      await tester.tap(boxes.at(1));
      await tester.pump();

      expect(find.text('1 selected'), findsOneWidget);
      expect(
        tester.widget<DsCheckbox>(boxes.first).state,
        DsCheckboxState.indeterminate,
      );

      await tester.tap(boxes.first);
      await tester.pump();
      expect(find.text('4 selected'), findsOneWidget);
      expect(
        tester.widget<DsCheckbox>(boxes.first).state,
        DsCheckboxState.checked,
      );
    });

    testWidgets('Next pages through, and the buttons disable at the ends',
        (WidgetTester tester) async {
      await tester.pumpDataPage();

      final Finder demo = find.byType(DataTableDemo).first;
      final Finder next =
          find.descendant(of: demo, matching: find.text('Next'));
      final Finder previous =
          find.descendant(of: demo, matching: find.text('Previous'));

      DsButton buttonOf(Finder label) => tester.widget<DsButton>(
            find.ancestor(of: label, matching: find.byType(DsButton)).first,
          );

      expect(buttonOf(previous).onPressed, isNull);
      expect(buttonOf(next).onPressed, isNotNull);

      await tester.tap(next);
      await tester.pump();

      expect(find.text('Page 2 of 2 · 8 of 8 cards'), findsOneWidget);
      expect(buttonOf(next).onPressed, isNull);
      expect(buttonOf(previous).onPressed, isNotNull);
    });

    testWidgets('the loading panel draws four skeleton rows and no data',
        (WidgetTester tester) async {
      await tester.pumpDataPage();

      final Finder loading = find.byType(DataTableDemo).last;
      expect(
        find.descendant(of: loading, matching: find.byType(DsSkeleton)),
        findsNWidgets(20),
        reason: 'four rows of five cells',
      );
      expect(
        find.descendant(of: loading, matching: find.text('Loading…')),
        findsOneWidget,
      );
    });

    testWidgets('Reload Figures takes the four live stats to loading and back',
        (WidgetTester tester) async {
      await tester.pumpDataPage();

      List<DsStatState> live() => tester
          .widgetList<DsStat>(find.descendant(
            of: _panel('Loading, live'),
            matching: find.byType(DsStat),
          ))
          .map((DsStat s) => s.state)
          .toList();

      expect(live(), List<DsStatState>.filled(4, DsStatState.ready));

      await tester.tap(find.text('Reload Figures'));
      await tester.pump();
      expect(live(), List<DsStatState>.filled(4, DsStatState.loading));

      // RELOAD_MS.
      await tester.pump(const Duration(milliseconds: 1100));
      await tester.pump();
      expect(live(), List<DsStatState>.filled(4, DsStatState.ready));
    });

    testWidgets('the navigating card takes the accent fill on hover and the '
        'ring snaps with it', (WidgetTester tester) async {
      await tester.pumpDataPage();

      final Finder card = find.descendant(
        of: _panel('When a stat navigates'),
        matching: find.byType(DsCard),
      );
      final DsThemeData theme =
          DsTheme.of(tester.element(find.byType(DataPage)));

      expect(tester.widget<DsCard>(card).fill, theme.card);

      await _hover(tester, tester.getCenter(card));
      await tester.pump(DsDurations.transitionDefault);

      expect(tester.widget<DsCard>(card).fill, theme.accent);
      // DRIFT 4: the ring is not in `transition-colors`, so it is already at
      // its hover value on the frame the pointer arrives.
      expect(
        tester.widget<DsCard>(card).ringColor!.a,
        closeTo(0.45, 0.001),
      );
    });
  });

  group('the dark theme renders', () {
    testWidgets('the column stacks to the same height in dark',
        (WidgetTester tester) async {
      final RenderBox column =
          await pumpDataInShell(tester, mode: DsThemeMode.dark);
      expect(column.size.height, closeTo(_columnHeight, _fineTolerance));
    });
  });
}
