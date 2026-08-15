/// `/design-system/components/base/selects` — the page, against the numbers
/// the reference actually renders.
///
/// Two harnesses, and the split is load-bearing:
///
///  * [pumpSelectsInShell] mounts the real `DocsShell` at the 1440 × 900
///    reference frame and hands back the reading column's `RenderBox`. Every
///    oracle number below is measured from that origin, **pristine** — no menu
///    opened, nothing typed, no day picked — which is the state the reference
///    was measured in.
///  * [pumpSelectsPage] mounts the page alone in a tall frame so every
///    specimen is laid out and hit-testable at once. All ten of them answer a
///    pointer (selects-map §11), and this file's job is to prove it.
///
/// ## The clock is part of the harness (ruling L2)
///
/// None of the three calendars is passed `month` or `defaultMonth`, so all
/// three open on **the reader's current month** — which makes this page's
/// document height a function of the wall clock: one 36px week row per
/// on-page calendar, ×2. The oracle below was read off `http://localhost:3000`
/// at 1440 × 900 on 2026-08-16 under a `Date` shim frozen to
/// **2026-08-16T12:00**, with the calendar confirmed rendering **August 2026**
/// — a six-row month, 304.571 tall. Both harnesses pump under a [DsClock] at
/// exactly that instant, and **no number here means anything under any other
/// one**.
///
/// Coordinates are the reference's document coordinates; the reading column
/// starts 112px down (`main` at 64 plus its own `py-12`), so every oracle
/// number is the measured top less 112.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/selects.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader, LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

/* ── The frame, the clock and the oracle ─────────────────────────────────── */

/// The behaviour frame: tall enough to lay the whole page out at once, so
/// nothing needs scrolling into view before it can be tapped.
const Size _desktop = Size(1440, 6000);

/// The frame the reference is measured at, and the only width these numbers
/// mean anything at.
const Size _referenceFrame = Size(1440, 900);

/// The instant BOTH renderers were frozen on. August 2026 is a six-row month;
/// July 2026 is a five-row one, and the page is 72px shorter under it.
final DateTime _frozen = DateTime(2026, 8, 16, 12);

const String _route = '$dsRoot/components/base/selects';

/// `--width-content` — the reading column every wrap on the page follows.
const double _columnWidth = 1080;

/// Where the reading column starts in the reference's document coordinates:
/// `main` at 64, plus its own 48px of top padding.
const double _columnTop = 112;

/// The reading column's own height — `main`'s 4929.8 less its `py-12` on both
/// edges.
///
/// This is the number `vertical_parity_probe_test.dart`'s `_referenceHeight`
/// takes for this route at integration, and it is only valid under [_frozen].
const double _columnHeight = 4833.8;

/// Each `section[id]`, as `(document top, border-box height)`.
///
/// Measured pristine. The heights are the CSS border box, so `mb-20` — which
/// this port pays as padding inside the section's own box — comes back off
/// before comparing.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'select': (top: 527.8, height: 504),
  'native': (top: 1111.9, height: 269.7),
  'combobox': (top: 1461.6, height: 263.8),
  'command': (top: 1805.4, height: 480.9),
  'calendar': (top: 2366.3, height: 488.9),
  'date-range': (top: 2935.2, height: 492.3),
  'date-picker': (top: 3507.4, height: 568.8),
  'api': (top: 4156.2, height: 274.8),
  'rules': (top: 4511, height: 253.8),
};

/// The six controls whose own box the reference reports, in document
/// coordinates. Two 40px pills, a 32px native control, a 40px input group and
/// two 40px popover triggers.
const Map<String, ({double top, double height})> _controlOracle =
    <String, ({double top, double height})>{
  's-sort': (top: 713, height: 40),
  's-rarity': (top: 826.4, height: 40),
  'ns': (top: 1297.1, height: 32),
  'combobox-input': (top: 1620.9, height: 40),
  'picker-empty': (top: 3692.6, height: 40),
  'picker-disabled': (top: 3877.5, height: 40),
};

/// The palette's two `CommandGroup` boxes, in document coordinates. Their
/// distance is what pins every row between them.
const double _paletteFirstGroup = 2025;
const double _paletteSecondGroup = 2143.2;

/// The calendar box in a Panel: 196 of content, `p-3` twice, a border twice.
const double _calendarWidth = 222;

/// Six week rows — August 2026, under [_frozen].
const double _calendarHeightSixRows = 304.5714;

/// Two logical pixels — the band the aggregates hold, where a different Skia
/// build's rounding has the most room to accumulate.
const double _tolerance = 2;

/// Half a pixel — the band every *anchor* holds. Tighter on purpose: each is
/// one line box away from its neighbour, so this is what catches a leading
/// quantised up half a pixel per row.
const double _fineTolerance = 0.5;

/* ── Harness ─────────────────────────────────────────────────────────────── */

/// The reference's own font binaries.
///
/// **Load-bearing, not hygiene.** Every number above is a line box; without
/// these the engine measures a fallback face and this file becomes a structure
/// test.
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

  /// The page alone, laid out tall, under reduced motion and the frozen clock.
  ///
  /// `MediaQuery(disableAnimations: true)` sits **below** `MaterialApp` so the
  /// framework's own does not win, and the body `DefaultTextStyle` the shell
  /// installs is brought along — without it every colour-inheriting string
  /// renders the framework's debug ink.
  Future<void> pumpSelectsPage({DsThemeMode mode = DsThemeMode.light}) async {
    useViewport(_desktop);
    final DsThemeController theme = DsThemeController(mode: mode);
    final AppRouter router = AppRouter(route: _route);
    addTearDown(theme.dispose);
    addTearDown(router.dispose);

    await pumpWidget(
      DsClock(
        now: _frozen,
        child: DsTheme(
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
                    child: const SingleChildScrollView(child: SelectsPage()),
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
/// column's own [RenderBox] — the origin every oracle number is measured from.
///
/// `main.dart` is the supervisor's at integration (ruling L13 kept the route on
/// a placeholder until all seven sections existed), so the page is handed to
/// the shell directly rather than looked up through `pageFor`.
Future<RenderBox> pumpSelectsInShell(
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

  const Widget page = SelectsPage();
  await tester.pumpWidget(
    DsClock(
      now: _frozen,
      child: DsTheme(
        controller: theme,
        child: AppRouterScope(
          router: router,
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: DocsShell(route: _route, child: page),
          ),
        ),
      ),
    ),
  );
  // No settle: geometry is settled on the first laid-out frame, and PRISTINE
  // is the state the oracle was measured in.
  await tester.pump();

  return tester.renderObject<RenderBox>(find.byWidget(page));
}

/// Opens (or closes) an overlay: one frame for the prop to flip, and one more
/// for the portal the frame boundary brings in — the package tests' own
/// helper, carried here.
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

/* ── Finders ─────────────────────────────────────────────────────────────── */

Finder _section(String id) => find.byWidgetPredicate(
      (Widget widget) => widget is DsSection && widget.id == id,
    );

Finder _in(String id, Finder matching) =>
    find.descendant(of: _section(id), matching: matching);

Finder _panel(String label) => find.byWidgetPredicate(
      (Widget widget) => widget is DsPanel && widget.label == label,
    );

/// The six controls the oracle names, by the reference's own `id`.
Finder _control(String id) => switch (id) {
      's-sort' => _in('select', find.byType(DsSelect<String>)).at(0),
      's-rarity' => _in('select', find.byType(DsSelect<String>)).at(1),
      'ns' => _in('native', find.byType(DsNativeSelect<String>)),
      'combobox-input' => _in('combobox', find.byType(DsCombobox<String>)),
      'picker-empty' => _in('date-picker', find.byType(DsDatePicker)).at(0),
      _ => _in('date-picker', find.byType(DsDatePicker)).at(1),
    };

/// One day cell inside [within] — the 28px square the reference calls `<td>`.
Finder _dayCell(Finder within, String day) => find.descendant(
      of: within,
      matching: find.ancestor(
        of: find.text(day),
        matching: find.byWidgetPredicate(
          (Widget w) => w is SizedBox && w.width == DsCalendar.cellSize,
        ),
      ),
    );

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
  return (top: box.top, height: box.height - ds(20));
}

/// The day button's own fill, for the cell numbered [day] inside [within].
Color _fillOf(WidgetTester tester, Finder within, String day) => tester
    .widgetList<DecoratedBox>(
      find.descendant(
        of: _dayCell(within, day).first,
        matching: find.byType(DecoratedBox),
      ),
    )
    .map((DecoratedBox b) => b.decoration as BoxDecoration)
    .firstWhere((BoxDecoration d) => d.color != null)
    .color!;

/// The `note` currently printed on the Panel labelled [label].
String? _panelNote(WidgetTester tester, String label) =>
    tester.widget<DsPanel>(_panel(label)).note;

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
      final RenderBox column = await pumpSelectsInShell(tester);
      expect(column.size.width, _columnWidth);
    });

    testWidgets('the column stacks to the reference height under the frozen '
        'clock', (WidgetTester tester) async {
      final RenderBox column = await pumpSelectsInShell(tester);
      // The number `_referenceHeight['selects']` takes at integration. It is
      // a clock-dependent number and the probe has to freeze the same instant.
      expect(column.size.height, closeTo(_columnHeight, _tolerance));
    });

    testWidgets('every section starts and ends where the reference does',
        (WidgetTester tester) async {
      final RenderBox column = await pumpSelectsInShell(tester);

      // Collected rather than asserted one at a time: a vertical drift is
      // cumulative, so the FIRST mismatch hides every section under it and the
      // useful diagnosis is the whole column at once.
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

    testWidgets('the six controls land on the reference\'s anchors',
        (WidgetTester tester) async {
      final RenderBox column = await pumpSelectsInShell(tester);

      final List<String> off = <String>[];
      for (final MapEntry<String, ({double top, double height})> want
          in _controlOracle.entries) {
        final ({double top, double height}) got =
            _boxIn(tester, column, _control(want.key));
        final double wantTop = want.value.top - _columnTop;
        if ((got.top - wantTop).abs() > _fineTolerance) {
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

    testWidgets('the two triggers in the Panel are 384 and the state cells 160',
        (WidgetTester tester) async {
      await pumpSelectsInShell(tester);
      // DRIFT 10 in both directions: `*:w-full` in the field, `w-40` in the
      // cells, and `w-fit` nowhere.
      expect(tester.getSize(_control('s-sort')).width, 384);
      expect(tester.getSize(_control('s-rarity')).width, 384);
      for (int i = 2; i < 5; i++) {
        expect(
          tester.getSize(_in('select', find.byType(DsSelect<String>)).at(i))
              .width,
          ds(40),
          reason: 'state cell ${i - 1} is `w-40`',
        );
      }
    });

    testWidgets('both Panel calendars are 222 × 304.571 and shrink-wrap',
        (WidgetTester tester) async {
      await pumpSelectsInShell(tester);
      for (final String id in <String>['calendar', 'date-range']) {
        final Size box = tester.getSize(_in(id, find.byType(DsCalendar)));
        expect(box.width, closeTo(_calendarWidth, _fineTolerance),
            reason: '#$id: `w-fit` is real here — 196 of content, `p-3` twice, '
                'a border twice. A calendar that fills its 1030px panel body '
                'is a different component.');
        expect(box.height, closeTo(_calendarHeightSixRows, _fineTolerance),
            reason: '#$id: six week rows, because the frozen clock says '
                'August 2026');
      }
    });

    testWidgets('the palette\'s groups, headings and rows stack on the '
        'reference', (WidgetTester tester) async {
      final RenderBox column = await pumpSelectsInShell(tester);

      double topOf(String text) =>
          _boxIn(tester, column, _in('command', find.text(text))).top;

      // Both groups are laid out identically inside themselves, so the
      // distance between two headings IS the distance between two groups.
      expect(
        topOf('Actions') - topOf('Packs'),
        closeTo(_paletteSecondGroup - _paletteFirstGroup, _fineTolerance),
      );
      // A heading row is 32 tall and an item row 34.571; the first item's text
      // therefore sits exactly one heading row under the heading's text,
      // because both are centred in boxes whose line boxes differ by the same
      // amount at each end.
      expect(topOf('Eclipse Vault') - topOf('Packs'),
          closeTo(DsCommand.headingHeight, _fineTolerance));
      expect(topOf('Golden Rift') - topOf('Eclipse Vault'),
          closeTo(DsCommand.itemHeight, _fineTolerance));
      expect(DsCommand.headingHeight, 32);
      expect(DsCommand.itemHeight, closeTo(34.571, 0.001));
    });

    testWidgets('the geometry holds in dark as well as light',
        (WidgetTester tester) async {
      final RenderBox column =
          await pumpSelectsInShell(tester, mode: DsThemeMode.dark);
      expect(column.size.width, _columnWidth);
      expect(column.size.height, closeTo(_columnHeight, _tolerance));
    });
  });

  /* ── The clock, and drift 2 ────────────────────────────────────────────── */

  group('the frozen clock — drift 2', () {
    testWidgets('both Panel calendars open on the CLOCK\'s month, not on the '
        'month of their own selected value', (WidgetTester tester) async {
      await pumpSelectsInShell(tester);
      // The seeds are July 2026; the clock says August 2026; the reference
      // passes neither `month` nor `defaultMonth`, so August is what renders.
      expect(_in('calendar', find.text('August 2026')), findsOneWidget);
      expect(_in('date-range', find.text('August 2026')), findsOneWidget);
      expect(find.text('July 2026'), findsNothing);
    });

    testWidgets('§5\'s seeded 30 Jul IS on screen — as a leading outside day '
        'at full --primary', (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      final Finder calendar = _in('calendar', find.byType(DsCalendar));
      // August 2026 opens with six outside days, 26–31 July, and the selection
      // is one of them. '30' therefore appears TWICE in this grid — 30 July
      // leading and 30 August in the last week — which is itself the point.
      expect(_dayCell(calendar, '30'), findsNWidgets(2));
      final DsThemeData theme =
          DsTheme.of(tester.element(find.byType(DsCalendar).first));
      expect(_fillOf(tester, calendar, '30'), theme.primary,
          reason: 'the map said this selection was invisible in August. It is '
              'not: it is the leading outside day, at full primary.');
    });

    testWidgets('§6\'s 12–20 Jul band is entirely off-screen while the Panel '
        'note still prints it', (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      final Finder calendar = _in('date-range', find.byType(DsCalendar));
      final DsThemeData theme =
          DsTheme.of(tester.element(find.byType(DsCalendar).first));
      // 12 and 20 August are ordinary days: the band belongs to July, and July
      // is not on screen.
      expect(_fillOf(tester, calendar, '12'), isNot(theme.primary));
      expect(_fillOf(tester, calendar, '20'), isNot(theme.primary));
      expect(_fillOf(tester, calendar, '15'), isNot(theme.muted));
      // …and the header above it still says what the selection is.
      expect(_panelNote(tester, 'Range'), '12 Jul – 20 Jul');
    });

    testWidgets('the range label uses an EN DASH, not a hyphen',
        (WidgetTester tester) async {
      await pumpSelectsInShell(tester);
      expect(_panelNote(tester, 'Range')!.contains('–'), isTrue);
      expect(_panelNote(tester, 'Range')!.contains('-'), isFalse);
    });
  });

  /* ── Copy ──────────────────────────────────────────────────────────────── */

  group('copy — verbatim', () {
    testWidgets('the header carries the nav\'s own strings, drift 1 included',
        (WidgetTester tester) async {
      await pumpSelectsInShell(tester);
      final DsCategoryHit here = findCategory('base', 'selects');
      expect(here.category.title, 'Selects & Pickers');
      // DRIFT 1: "Base Components · Base". `.type-label` is
      // `text-transform: uppercase` and `DsText` performs the transform, so
      // this is the string that renders.
      expect(find.text('BASE COMPONENTS · BASE'), findsOneWidget);
      // Twice: the page's own `h1` and the shell's nav entry beside it.
      expect(find.text('Selects & Pickers'), findsWidgets);
      expect(
        find.text('Choosing from a known set — menus, comboboxes, command '
            'palette and dates.'),
        findsOneWidget,
      );
      // Seven chips, and they do not all match the section titles: the chip
      // says "Command Palette", the section "Command palette".
      expect(here.category.contents, <String>[
        'Select',
        'Native Select',
        'Combobox',
        'Command Palette',
        'Calendar',
        'Date Range',
        'Date Picker',
      ]);
    });

    testWidgets('nine sections, in order, with the reference\'s titles',
        (WidgetTester tester) async {
      await pumpSelectsInShell(tester);
      const List<String> ids = <String>[
        'select',
        'native',
        'combobox',
        'command',
        'calendar',
        'date-range',
        'date-picker',
        'api',
        'rules',
      ];
      final List<String> found = tester
          .widgetList<DsSection>(find.byType(DsSection))
          .map((DsSection s) => s.id)
          .toList();
      expect(found, ids);

      final Map<String, String> titles = <String, String>{
        for (final DsSection s
            in tester.widgetList<DsSection>(find.byType(DsSection)))
          s.id: s.title,
      };
      expect(titles['native'], 'Native Select');
      // Case differs from the chip's "Command Palette".
      expect(titles['command'], 'Command palette');
      expect(titles['date-range'], 'Date Range');
      // §8 and §9 carry no description at all.
      final Map<String, String?> descriptions = <String, String?>{
        for (final DsSection s
            in tester.widgetList<DsSection>(find.byType(DsSection)))
          s.id: s.description,
      };
      expect(descriptions['api'], isNull);
      expect(descriptions['rules'], isNull);
      expect(
        descriptions['date-range'],
        contains('“between these dates”'),
        reason: 'curly quotes, straight apostrophe — as authored',
      );
      expect(descriptions['date-range'], contains("Wallet's"));
    });

    testWidgets('the seven Panels, and the two notes on them',
        (WidgetTester tester) async {
      await pumpSelectsInShell(tester);
      final List<DsPanel> panels =
          tester.widgetList<DsPanel>(find.byType(DsPanel)).toList();
      expect(
        panels.map((DsPanel p) => p.label).toList(),
        <String>[
          'Sort and filter selects',
          'Native select',
          'Filter by card set',
          'Command palette',
          'Single',
          'Range',
          'Every state',
        ],
      );
      // DRIFT 3: the palette's note advertises a binding nothing holds.
      expect(_panelNote(tester, 'Command palette'), 'Ctrl + K');
      expect(_panelNote(tester, 'Range'), '12 Jul – 20 Jul');
      // The other five carry none.
      expect(
        panels.where((DsPanel p) => p.note != null).length,
        2,
        reason: 'Panel `note` is used exactly twice on this page',
      );
    });

    testWidgets('the three Notes, the caption and the two Metas',
        (WidgetTester tester) async {
      await pumpSelectsInShell(tester);
      // `DsNote`'s title is `.type-label` — uppercased on render, like the
      // eyebrow.
      expect(find.text('CHOOSING THE RIGHT ONE'), findsOneWidget);
      expect(
        find.text('THIS SECTION EXISTED ONLY AS A PROMISE'),
        findsOneWidget,
      );
      expect(
        find.text('NEVER FORMAT A DATE WITH TOISOSTRING()'),
        findsOneWidget,
      );
      // Only §7's Note is `tone="error"`.
      final List<DsNote> notes =
          tester.widgetList<DsNote>(find.byType(DsNote)).toList();
      expect(notes, hasLength(3));
      expect(notes.map((DsNote n) => n.tone).toList(), <DsNoteTone>[
        DsNoteTone.action,
        DsNoteTone.action,
        DsNoteTone.error,
      ]);
      // §3's caption is a bare paragraph, not a Note.
      expect(
        _in('combobox',
            find.textContaining('Typing narrows the list.', findRichText: true)),
        findsOneWidget,
      );
      // Two Metas: §7's four rows and §8's five.
      final List<DsMeta> metas =
          tester.widgetList<DsMeta>(find.byType(DsMeta)).toList();
      expect(metas, hasLength(2));
      expect(metas[0].items, hasLength(4));
      expect(metas[1].items, hasLength(5));
      expect(metas[0].items.first.k, 'format(d, "d MMM yyyy")');
      expect(metas[1].items[1].k, 'NativeSelect');
      expect(metas[1].items[1].v.toPlainText(), contains('<select>'));
    });

    testWidgets('§9 is five dos against four don\'ts',
        (WidgetTester tester) async {
      await pumpSelectsInShell(tester);
      final DsDoDont rules = tester.widget<DsDoDont>(find.byType(DsDoDont));
      expect(rules.dos, hasLength(5));
      expect(rules.donts, hasLength(4));
      expect(rules.dos.last,
          'Render dates and prices with the named numerical typography '
          'foundation.');
      // Straight apostrophes in all four; only the panel heading is curly.
      for (final String dont in rules.donts) {
        expect(dont.startsWith("Don't"), isTrue);
      }
      // There is no DoDont anywhere but §9.
      expect(find.byType(DsDoDont), findsOneWidget);
      expect(_in('rules', find.byType(DsDoDont)), findsOneWidget);
    });

    testWidgets('the palette prints its four rows and four shortcuts',
        (WidgetTester tester) async {
      await pumpSelectsInShell(tester);
      for (final String text in <String>[
        'Packs',
        'Eclipse Vault',
        r'$48.00',
        'Golden Rift',
        r'$120.00',
        'Actions',
        'Open Wallet',
        '⌘W',
        'Go to Stash',
        '⌘S',
      ]) {
        expect(_in('command', find.text(text)), findsOneWidget,
            reason: 'the palette should print "$text"');
      }
    });
  });

  /* ── Behaviour — every specimen is live ────────────────────────────────── */

  group('§1 select', () {
    testWidgets('s-sort opens a GROUPED menu — two labels and a separator '
        'between them', (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      await tester.tap(_control('s-sort'));
      await settleOverlay(tester);

      final Finder menu = find.byType(DsSelectMenu<String>);
      expect(menu, findsOneWidget);
      expect(find.descendant(of: menu, matching: find.text('Activity')),
          findsOneWidget);
      expect(find.descendant(of: menu, matching: find.text('Price')),
          findsOneWidget);
      expect(find.descendant(of: menu, matching: find.text('Volatility')),
          findsOneWidget);
      // The separator: a 1px rule that occupies 17px (drift 7).
      expect(DsSelect.separatorHeight, 17);
      expect(DsSelect.labelHeight, 32);
    });

    testWidgets('committing a row moves the trigger', (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      expect(_in('select', find.text('Most popular')), findsOneWidget);

      await tester.tap(_control('s-sort'));
      await settleOverlay(tester);
      await tester.tap(find.descendant(
        of: find.byType(DsSelectMenu<String>),
        matching: find.text('Price: high to low'),
      ));
      await settleOverlay(tester);
      await runOverlay(tester);

      expect(find.byType(DsSelectMenu<String>), findsNothing);
      expect(_in('select', find.text('Price: high to low')), findsOneWidget);
      expect(_in('select', find.text('Most popular')), findsNothing);
    });

    testWidgets('s-rarity shows its placeholder and opens six flat rows',
        (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      expect(_in('select', find.text('Any rarity')), findsNWidgets(2),
          reason: 'the field placeholder and the Default cell\'s');

      await tester.tap(_control('s-rarity'));
      await settleOverlay(tester);
      final Finder menu = find.byType(DsSelectMenu<String>);
      for (final String row in <String>[
        'Common',
        'Uncommon',
        'Rare',
        'Epic',
        'Legendary',
        'Mythic',
      ]) {
        expect(find.descendant(of: menu, matching: find.text(row)),
            findsOneWidget);
      }
      // No group labels anywhere in this one.
      expect(find.descendant(of: menu, matching: find.text('Activity')),
          findsNothing);
    });

    testWidgets('the state cells: two open a one-row menu, the third opens '
        'nothing — drift 18', (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      final Finder cells = _in('select', find.byType(DsSelect<String>));

      await tester.tap(cells.at(2));
      await settleOverlay(tester);
      expect(
        find.descendant(
          of: find.byType(DsSelectMenu<String>),
          matching: find.text('Common'),
        ),
        findsOneWidget,
      );
      // Close it again before the next cell.
      await tester.tapAt(const Offset(20, 20));
      await settleOverlay(tester);
      await runOverlay(tester);

      // The Disabled cell: `<Select disabled>` over `<SelectContent />`.
      await tester.tap(cells.at(4), warnIfMissed: false);
      await settleOverlay(tester);
      expect(find.byType(DsSelectMenu<String>), findsNothing,
          reason: 'a disabled trigger over an empty content opens nothing — '
              'and would have nothing to show if it did (ruling L5)');
      expect(_in('select', find.text('Unavailable')), findsOneWidget);
    });
  });

  group('§2 native select', () {
    testWidgets('the closed control is 32px and 12px-cornered — drift 8',
        (WidgetTester tester) async {
      await pumpSelectsInShell(tester);
      expect(tester.getSize(_control('ns')).height, ds(8));
      // Beside a 40px pill two sections up.
      expect(tester.getSize(_control('s-sort')).height, ds(10));
      expect(DsNativeSelectSize.md.radius, DsRadii.lg);
      expect(_in('native', find.text('United States')), findsOneWidget);
    });

    testWidgets('it opens the port\'s own menu and commits — the recorded '
        'divergence (ruling L6)', (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      await tester.tap(_control('ns'));
      await settleOverlay(tester);
      final Finder menu = find.byType(DsSelectMenu<String>);
      expect(menu, findsOneWidget);
      expect(find.descendant(of: menu, matching: find.text('Japan')),
          findsOneWidget);

      await tester.tap(
        find.descendant(of: menu, matching: find.text('Canada')),
      );
      await settleOverlay(tester);
      await runOverlay(tester);
      expect(_in('native', find.text('Canada')), findsOneWidget);
      expect(_in('native', find.text('United States')), findsNothing);
    });
  });

  group('§3 combobox', () {
    Finder input() => _in('combobox', find.byType(EditableText));

    testWidgets('typing narrows the list by the collator\'s rules',
        (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      await tester.tap(_control('combobox-input'));
      await settleOverlay(tester);
      final Finder popup = find.byType(DsPopoverSurface);
      expect(popup, findsOneWidget);
      // `limit: -1`, no cap: all six.
      for (final String set in <String>[
        'Eclipse Vault',
        'Golden Rift',
        'Mystic Surge',
        'Shadow Core',
        'Celestial Strike',
        'Origin Pulse',
      ]) {
        expect(find.descendant(of: popup, matching: find.text(set)),
            findsOneWidget);
      }

      // `sensitivity: 'base'` — case-insensitive.
      await tester.enterText(input(), 'gold');
      await settleOverlay(tester);
      expect(
        find.descendant(
          of: find.byType(DsPopoverSurface),
          matching: find.text('Golden Rift'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(DsPopoverSurface),
          matching: find.text('Eclipse Vault'),
        ),
        findsNothing,
      );
    });

    testWidgets('the empty state says what happened', (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      await tester.tap(_control('combobox-input'));
      await settleOverlay(tester);
      await tester.enterText(input(), 'zzz');
      await settleOverlay(tester);
      expect(
        find.descendant(
          of: find.byType(DsPopoverSurface),
          matching: find.text('No matching set.'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('picking a row commits it into the input',
        (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      await tester.tap(_control('combobox-input'));
      await settleOverlay(tester);
      await tester.tap(find.descendant(
        of: find.byType(DsPopoverSurface),
        matching: find.text('Mystic Surge'),
      ));
      await settleOverlay(tester);
      await runOverlay(tester);
      expect(tester.widget<EditableText>(input()).controller.text,
          'Mystic Surge');
    });

    testWidgets('the popup is 28px wider than its own input — drift 22',
        (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      await tester.tap(_control('combobox-input'));
      await settleOverlay(tester);
      final double popup = tester.getSize(find.byType(DsPopoverSurface)).width;
      // The positioner anchors to the bare input, not to the pill: 344 + 28.
      expect(popup, closeTo(372, _fineTolerance));
      expect(DsCombobox.popupOvershoot, ds(7));
    });
  });

  group('§4 command palette', () {
    Finder input() => _in('command', find.byType(EditableText));

    Finder separator() => _in(
          'command',
          find.byWidgetPredicate(
            (Widget w) => w is SizedBox && w.height == DsWidths.hairline,
          ),
        );

    testWidgets('the first row is selected at rest, before anything is typed',
        (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      final DsThemeData theme =
          DsTheme.of(tester.element(find.byType(DsCommand)));
      // cmdk auto-selects the first item on mount: a static, visible state the
      // port must render on first paint. `--muted`, drift 5's third token.
      final Iterable<Color> fills = tester
          .widgetList<DecoratedBox>(_in('command', find.byType(DecoratedBox)))
          .map((DecoratedBox b) => b.decoration as BoxDecoration)
          .map((BoxDecoration d) => d.color)
          .whereType<Color>();
      expect(fills, contains(theme.muted));
    });

    testWidgets('typing filters AND re-sorts — ruling L9',
        (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      final RenderBox page =
          tester.renderObject<RenderBox>(find.byType(SelectsPage));
      double topOf(String text) => tester
          .renderObject<RenderBox>(_in('command', find.text(text)))
          .localToGlobal(Offset.zero, ancestor: page)
          .dy;

      expect(topOf('Open Wallet') < topOf('Go to Stash'), isTrue);
      await tester.enterText(input(), 't');
      await tester.pump();
      // *(Measured on the live palette: typing `t` lifts "Go to Stash" over
      // "Open Wallet".)* The row order is visible fidelity.
      expect(topOf('Go to Stash') < topOf('Open Wallet'), isTrue);
      // …while the GROUPS never move: cmdk's group sort is dead code (drift
      // 28).
      expect(topOf('Packs') < topOf('Actions'), isTrue);
      expect(DsCommand.sortsGroups, isFalse);
    });

    testWidgets('the separator unmounts on the first keystroke — drift 30',
        (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      expect(separator(), findsOneWidget);
      await tester.enterText(input(), 'o');
      await tester.pump();
      expect(separator(), findsNothing);
      // …and comes back when the query is cleared.
      await tester.enterText(input(), '');
      await tester.pump();
      expect(separator(), findsOneWidget);
    });

    testWidgets('the shortcuts are searchable — typing 48 finds the first pack',
        (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      await tester.enterText(input(), '48');
      await tester.pump();
      expect(_in('command', find.text('Eclipse Vault')), findsOneWidget);
      expect(_in('command', find.text('Golden Rift')), findsNothing);
    });

    testWidgets('a query that matches nothing shows the empty row',
        (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      await tester.enterText(input(), 'zzzzz');
      await tester.pump();
      expect(_in('command', find.text('Nothing matches that.')), findsOneWidget);
      expect(_in('command', find.text('Eclipse Vault')), findsNothing);
    });

    testWidgets('Ctrl + K is bound to nothing — drift 3',
        (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      final Finder palette = find.byType(DsCommand);
      final Rect before = tester.getRect(palette);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();
      // Nothing opens, because it is already open and nothing listens: the
      // note is decoration.
      expect(tester.getRect(palette), before);
      expect(find.byType(DsCommand), findsOneWidget);
    });
  });

  group('§5–§6 calendars', () {
    testWidgets('picking a day in §5 moves the selection',
        (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      final Finder calendar = _in('calendar', find.byType(DsCalendar));
      final DsThemeData theme =
          DsTheme.of(tester.element(find.byType(DsCalendar).first));

      await tester.tap(_dayCell(calendar, '12').first);
      await tester.pump();
      await tester.pump(DsDurations.base);
      expect(_fillOf(tester, calendar, '12'), theme.primary);
      // The leading 30 July has let go.
      expect(_fillOf(tester, calendar, '30'), isNot(theme.primary));
    });

    testWidgets('navigating a month redraws the caption',
        (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      final Finder calendar = _in('calendar', find.byType(DsCalendar));
      // The two 28px ghost squares in the caption's own gutters.
      await tester.tap(find.descendant(
        of: calendar,
        matching: find.byWidgetPredicate(
          (Widget w) => w is DsIcon && w.glyph == DsIconGlyph.chevronLeft,
        ),
      ));
      await tester.pump();
      expect(_in('calendar', find.text('July 2026')), findsOneWidget);
      // The clock has not moved; only this instance's displayed month has.
      expect(_in('date-range', find.text('August 2026')), findsOneWidget);
    });

    testWidgets('picking two days in §6 rewrites the Panel\'s own header',
        (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      final Finder calendar = _in('date-range', find.byType(DsCalendar));
      expect(_panelNote(tester, 'Range'), '12 Jul – 20 Jul');

      // `addToRange` extends a complete range rather than starting a new one:
      // a day after `to` moves `to`. The header rewrites itself on the first
      // click, which is the whole demo.
      await tester.tap(_dayCell(calendar, '4').first);
      await tester.pump();
      expect(_panelNote(tester, 'Range'), '12 Jul – 4 Aug');

      // Clicking the end again collapses the range onto it…
      await tester.tap(_dayCell(calendar, '4').first);
      await tester.pump();
      expect(_panelNote(tester, 'Range'), '4 Aug – 4 Aug');

      // …and a third click on the same day clears the selection outright,
      // which is the one route on this page to the placeholder copy.
      await tester.tap(_dayCell(calendar, '4').first);
      await tester.pump();
      expect(_panelNote(tester, 'Range'), 'Pick two dates');

      await tester.tap(_dayCell(calendar, '11').first);
      await tester.pump();
      await tester.tap(_dayCell(calendar, '18').first);
      await tester.pump();
      expect(_panelNote(tester, 'Range'), '11 Aug – 18 Aug');
      // The only place on the page where a specimen writes into its own
      // chrome, and a fidelity requirement rather than decoration.
    });

    testWidgets('the band paints between the two ends',
        (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      final Finder calendar = _in('date-range', find.byType(DsCalendar));
      final DsThemeData theme =
          DsTheme.of(tester.element(find.byType(DsCalendar).first));

      // Collapse the July seed onto 4 August, then extend to the 11th: a band
      // with two ends and six middles, all inside the rendered month.
      await tester.tap(_dayCell(calendar, '4').first);
      await tester.pump();
      await tester.tap(_dayCell(calendar, '4').first);
      await tester.pump();
      await tester.tap(_dayCell(calendar, '11').first);
      await tester.pump();
      await tester.pump(DsDurations.base);

      expect(_fillOf(tester, calendar, '4'), theme.primary);
      expect(_fillOf(tester, calendar, '11'), theme.primary);
      expect(_fillOf(tester, calendar, '7'), theme.muted);
    });
  });

  group('§7 date picker', () {
    testWidgets('the trigger wears the mono face when picked and the sans face '
        'when empty', (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      expect(_in('date-picker', find.text('30 Jul 2026')), findsOneWidget);
      final DsText picked = tester.widget<DsText>(find.ancestor(
        of: _in('date-picker', find.text('30 Jul 2026')),
        matching: find.byType(DsText),
      ));
      expect(picked.spec, DsType.numBase);

      await tester.tap(_in('date-picker', find.text('Clear date')));
      await tester.pump();
      expect(_in('date-picker', find.text('Pick a date')), findsOneWidget);
      final DsText empty = tester.widget<DsText>(find.ancestor(
        of: _in('date-picker', find.text('Pick a date')),
        matching: find.byType(DsText),
      ));
      expect(empty.spec, DsComponentType.buttonLabel);
    });

    testWidgets('the description follows the state', (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      expect(
        _in('date-picker',
            find.text('Selected. Dates use the shared numerical mono '
                'foundation.')),
        findsOneWidget,
      );
      await tester.tap(_in('date-picker', find.text('Clear date')));
      await tester.pump();
      expect(
        _in('date-picker',
            find.text('Empty. The placeholder sits in the sans face — it is a '
                'word, not a value.')),
        findsOneWidget,
      );
    });

    testWidgets('Clear unmounts with the value, including when the calendar '
        'toggles the day back off', (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      expect(_in('date-picker', find.text('Clear date')), findsOneWidget);

      await tester.tap(_control('picker-empty'));
      await settleOverlay(tester);
      final Finder popover = find.byType(DsPopoverSurface);
      expect(popover, findsOneWidget);
      // The popover's calendar opens on the clock's month too, with the seeded
      // 30 July as a leading outside day — so re-picking it is a toggle, and
      // the toggle reports null.
      await tester.tap(_dayCell(popover, '30').first);
      await tester.pump();
      await settleOverlay(tester);
      await runOverlay(tester);

      expect(_in('date-picker', find.text('Pick a date')), findsOneWidget);
      expect(_in('date-picker', find.text('Clear date')), findsNothing,
          reason: 'the Clear button is mounted on `{picked && …}` and the '
              'toggle emptied the field');
    });

    testWidgets('the disabled twin prints its date and opens nothing',
        (WidgetTester tester) async {
      await tester.pumpSelectsPage();
      expect(_in('date-picker', find.text('6 Apr 2026')), findsOneWidget);
      await tester.tap(_control('picker-disabled'), warnIfMissed: false);
      await settleOverlay(tester);
      expect(find.byType(DsPopoverSurface), findsNothing);
      // DRIFT 16: the field dims the label and the Button dims itself, at two
      // different alphas, and the description is dimmed by neither.
      final DsField disabled = tester
          .widgetList<DsField>(_in('date-picker', find.byType(DsField)))
          .last;
      expect(disabled.enabled, isFalse);
    });

    testWidgets('DRIFT 20 — the one Button on the page that does not squish',
        (WidgetTester tester) async {
      await pumpSelectsInShell(tester);
      expect(DsDatePicker.pressScaleSuppressed, isTrue);
    });
  });
}
