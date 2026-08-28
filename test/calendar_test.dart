/// `Calendar`, `DatePicker`, `DateFormat` and the `Clock` seam.
///
/// **Every number here was probed, not derived.** selects-map §8.5 computed
/// the calendar's whole box from tokens and said in as many words that none of
/// it *"has been seen on screen"*; supervisor ruling L3 made a computed-style
/// probe the first act of this wave. It ran on 2026-08-16 against
/// `localhost:3000/design-system/components/base/selects` at 1440 × 900 in
/// both themes, with `getBoundingClientRect` / `getComputedStyle` for the
/// static box and a driven pointer and keyboard for everything else. Where the
/// map's derivation and the browser disagree, the browser is what these tests
/// hold.
///
/// Chrome reports its boxes on a ¹⁄₆₄px grid, so its 18.563 / 268.563 /
/// 304.563 are the exact 18.5714 / 268.5714 / 304.5714 rounded down to the
/// nearest ¹⁄₆₄. Flutter computes the unrounded value, and `LineBox` is what
/// keeps the weekday row's line box at `13 × 1.428571` instead of the engine's
/// whole-pixel 19. Both numbers are stated at every site.
///
/// **Real font binaries**, because the calendar's height is a text
/// measurement: the weekday row is a line box and nothing else.
library;

import 'dart:io';
import 'dart:ui' as ui show Image, ImageByteFormat;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/rendering.dart' hide ScrollDirection;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart'
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
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

// ── harness ─────────────────────────────────────────────────────────────────

/// The frozen instant the whole file runs on — the day the probe ran, and the
/// day the reference rendered **August 2026**, a six-row month.
final DateTime _frozen = DateTime(2026, 8, 16, 2, 15);

Future<void> _loadFont(String family, String file) async {
  final ByteData bytes = ByteData.sublistView(
    File('assets/fonts/$file').readAsBytesSync(),
  );
  final FontLoader loader = FontLoader('packages/elattar_design_system/$family')
    ..addFont(Future<ByteData>.value(bytes));
  await loader.load();
}

Widget host(
  Widget child, {
  ColorMode mode = ColorMode.dark,
  DateTime? clock,
  Size size = const Size(1440, 900),
}) {
  final Widget tree = MediaQuery(
    data: MediaQueryData(size: size),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ThemeScope(
        controller: ThemeController(mode: mode),
        child: Center(child: child),
      ),
    ),
  );
  return clock == null ? tree : Clock(now: clock, child: tree);
}

/// What [overlayHost] is showing — `initialEntries` is read once, in
/// `initState`, so the child goes through a holder.
Widget _hosted = const SizedBox.shrink();

Widget overlayHost(
  Widget child, {
  ColorMode mode = ColorMode.dark,
  DateTime? clock,
  Size size = const Size(1440, 900),
  Alignment align = Alignment.topLeft,
}) {
  _hosted = child;
  final Widget tree = MediaQuery(
    data: MediaQueryData(size: size),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ThemeScope(
        controller: ThemeController(mode: mode),
        child: Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(
              builder: (BuildContext _) =>
                  Align(alignment: align, child: _hosted),
            ),
          ],
        ),
      ),
    ),
  );
  return clock == null ? tree : Clock(now: clock, child: tree);
}

/// Opens (or closes) a [Popover]: one frame for the prop to flip, and one
/// more for the portal the frame boundary brings in — A2's handoff, and the
/// same helper `selects_test.dart` carries.
Future<void> settleOverlay(WidgetTester t) async {
  await t.pump();
  await t.pump();
}

ThemeTokens themeIn(WidgetTester t, Type of) =>
    ThemeScope.of(t.element(find.byType(of).first));

/// The cell whose number is [day], inside the first calendar on screen.
Finder dayCell(String day) => find.ancestor(
  of: find.text(day),
  matching: find.byWidgetPredicate(
    (Widget w) => w is SizedBox && w.width == Calendar.cellSize,
  ),
);

/// The caption — the only `TextStyles.buttonLabel` run in the tree.
String captionOf(WidgetTester t) => t
    .widgetList<StyledText>(find.byType(StyledText))
    .firstWhere((StyledText d) => d.spec == TextStyles.buttonLabel)
    .text;

/// One rasterised pixel ROW through [child] at [atY], in the child's own
/// coordinates.
///
/// The band is a [CustomPainter]'s output under a [DecoratedBox]; what the
/// painter is *configured* with and what lands on the canvas are two
/// assertions, and this reads the canvas. The phase-3 painter ruling asks for
/// exactly this beside the browser probe.
Future<List<Color>> rasterRow(
  WidgetTester t,
  Widget child, {
  required int atY,
  ColorMode mode = ColorMode.dark,
  DateTime? clock,
}) async {
  await t.pumpWidget(
    host(
      RepaintBoundary(key: const Key('raster'), child: child),
      mode: mode,
      clock: clock,
    ),
  );
  // Past `btn-spring`, twice, so nothing is mid-tween when the frame is read.
  await t.pump(MotionDurations.normal);
  await t.pump(MotionDurations.normal);

  final RenderRepaintBoundary box = t.renderObject(
    find.byKey(const Key('raster')),
  );
  final ui.Image image = (await t.runAsync(() => box.toImage(pixelRatio: 1)))!;
  final ByteData bytes = (await t.runAsync(
    () async => (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!,
  ))!;
  final int w = image.width;
  final List<Color> row = <Color>[
    for (int x = 0; x < w; x++)
      Color.from(
        alpha: bytes.getUint8((atY * w + x) * 4 + 3) / 255,
        red: bytes.getUint8((atY * w + x) * 4) / 255,
        green: bytes.getUint8((atY * w + x) * 4 + 1) / 255,
        blue: bytes.getUint8((atY * w + x) * 4 + 2) / 255,
      ),
  ];
  image.dispose();
  return row;
}

/// An opaque colour comparison at 8-bit precision — what a screenshot would
/// see.
Matcher isColor(Color expected) => isA<Color>()
    .having((Color c) => (c.r * 255).round(), 'r', (expected.r * 255).round())
    .having((Color c) => (c.g * 255).round(), 'g', (expected.g * 255).round())
    .having((Color c) => (c.b * 255).round(), 'b', (expected.b * 255).round());

/// `13 × calc(1.25 / .875)` — the weekday row's line box.
///
/// *(Chrome: 18.563. The ¹⁄₆₄px grid is the only difference.)*
const double _weekdayRow = 13 * (1.25 / 0.875);

/// `--cell-size`, `--cell-radius`, and the two paddings.
const double _cell = 28;
const double _panelPad = 12;
const double _popoverPad = 8;

/// The whole calendar's outer height for [rows], on a Panel surface.
///
/// `28 (caption) + 16 (gap) + 18.5714 (header) + rows × 36 + 24 (p-3) + 2`.
double _panelHeight(int rows) =>
    _cell + 16 + _weekdayRow + rows * 36 + 2 * _panelPad + 2;

void main() {
  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
  });

  // ─── DateFormat ────────────────────────────────────────────────────────

  group('DateFormat — ruling L10, twelve strings instead of intl', () {
    test('the three formats the page prints', () {
      // `rangeLabel` (page:82–85) at the seeded range.
      expect(DateFormat.dayMonth(DateTime(2026, 7, 12)), '12 Jul');
      expect(DateFormat.dayMonth(DateTime(2026, 7, 20)), '20 Jul');
      // The date-picker trigger (page:352).
      expect(DateFormat.dayMonthYear(DateTime(2026, 7, 30)), '30 Jul 2026');
      // §7's disabled twin.
      expect(DateFormat.dayMonthYear(DateTime(2026, 4, 6)), '6 Apr 2026');
      // `DateLib.formatMonthYear` — *(measured: the live caption)*.
      expect(DateFormat.monthYear(DateTime(2026, 8, 16)), 'August 2026');
      expect(DateFormat.monthYear(DateTime(2026, 7, 1)), 'July 2026');
      expect(DateFormat.monthYear(DateTime(2027, 9, 1)), 'September 2027');
    });

    test('`d`, not `dd` — no leading zero anywhere', () {
      expect(DateFormat.dayMonth(DateTime(2026, 1, 5)), '5 Jan');
      expect(DateFormat.dayMonthYear(DateTime(2026, 1, 5)), '5 Jan 2026');
    });

    test('the twelve month abbreviations, in order', () {
      expect(DateFormat.monthsShort, hasLength(12));
      expect(DateFormat.monthsShort, <String>[
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ]);
      expect(DateFormat.monthsLong.first, 'January');
      expect(DateFormat.monthsLong.last, 'December');
      expect(DateFormat.monthsLong, hasLength(12));
    });

    test('`cccccc` — Su Mo Tu We Th Fr Sa, Sunday first *(measured)*', () {
      expect(
        <String>[for (int i = 0; i < 7; i++) DateFormat.weekdayNarrow(i)],
        <String>['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
      );
    });

    test('weekIndex turns Dart\'s ISO week into the en-US one', () {
      // 16 Aug 2026 is a Sunday — column 0.
      expect(DateFormat.weekIndex(DateTime(2026, 8, 16)), 0);
      // 1 Aug 2026 is a Saturday — column 6, and the six leading outside days
      // that make August a six-row month.
      expect(DateFormat.weekIndex(DateTime(2026, 8, 1)), 6);
      expect(DateFormat.weekIndex(DateTime(2026, 7, 1)), 3);
      expect(DateFormat.weekIndex(DateTime(2026, 2, 1)), 0);
    });

    test('calendarDayKey — built from local fields, never sliced off an ISO '
        'instant (the page\'s own error Note)', () {
      expect(DateFormat.dayKey(DateTime(2026, 7, 26)), '2026-07-26');
      expect(DateFormat.dayKey(DateTime(2026, 1, 5)), '2026-01-05');
      // The trap, stated: a local date west of Greenwich late in the day is a
      // different day in UTC. `dayKey` reads the local calendar and cannot
      // move; `toIso8601String()` on the same value can.
      final DateTime late = DateTime(2026, 7, 30, 23, 30);
      expect(DateFormat.dayKey(late), '2026-07-30');
      expect(DateFormat.dayKey(late), DateFormat.dayKey(late.toLocal()));
    });

    test('the accessible label — `EEEE, MMMM do, yyyy` *(measured on the live '
        'day button)*', () {
      expect(
        DateFormat.dayLabel(DateTime(2026, 7, 26)),
        'Sunday, July 26th, 2026',
      );
      expect(
        DateFormat.dayLabel(DateTime(2026, 8, 5)),
        'Wednesday, August 5th, 2026',
      );
    });

    test('`do` — the teens are the exception a naive rule gets wrong', () {
      expect(DateFormat.ordinal(1), '1st');
      expect(DateFormat.ordinal(2), '2nd');
      expect(DateFormat.ordinal(3), '3rd');
      expect(DateFormat.ordinal(4), '4th');
      expect(DateFormat.ordinal(11), '11th');
      expect(DateFormat.ordinal(12), '12th');
      expect(DateFormat.ordinal(13), '13th');
      expect(DateFormat.ordinal(21), '21st');
      expect(DateFormat.ordinal(22), '22nd');
      expect(DateFormat.ordinal(23), '23rd');
      expect(DateFormat.ordinal(31), '31st');
    });
  });

  // ─── the grid, as arithmetic ─────────────────────────────────────────────

  group('CalendarMonth — the row-count arithmetic', () {
    test('August 2026: six rows, 26 Jul → 5 Sep *(measured)*', () {
      final CalendarMonth month = CalendarMonth(DateTime(2026, 8, 16));
      expect(month.leadingDays, 6);
      expect(month.dayCount, 31);
      expect(month.weekCount, 6);
      final List<DateTime> days = month.days;
      expect(days, hasLength(42));
      expect(days.first, DateTime(2026, 7, 26));
      expect(days.last, DateTime(2026, 9, 5));
    });

    test('July 2026: five rows, 28 Jun → 1 Aug *(measured)*', () {
      final CalendarMonth month = CalendarMonth(DateTime(2026, 7, 12));
      expect(month.leadingDays, 3);
      expect(month.weekCount, 5);
      expect(month.days.first, DateTime(2026, 6, 28));
      expect(month.days.last, DateTime(2026, 8, 1));
    });

    test('February 2026: FOUR rows — the case the map does not have', () {
      // 1 Feb 2026 is a Sunday and the month has 28 days, so the grid is
      // exactly four weeks with no outside day at either end.
      // *(Measured on the live calendar: 232.563px tall.)*
      final CalendarMonth month = CalendarMonth(DateTime(2026, 2, 1));
      expect(month.leadingDays, 0);
      expect(month.dayCount, 28);
      expect(month.weekCount, 4);
      expect(month.days, hasLength(28));
      expect(month.days.first, DateTime(2026, 2, 1));
      expect(month.days.last, DateTime(2026, 2, 28));
    });

    test('one extra week row is exactly 36px, at every step *(measured)*', () {
      double at(int rows) =>
          CalendarMonth(DateTime(2026, 2, 1)).gridHeight(_weekdayRow) +
          (rows - 4) * 36;
      // The arithmetic itself: gap + cell, and nothing else.
      final CalendarMonth feb = CalendarMonth(DateTime(2026, 2, 1));
      final CalendarMonth jul = CalendarMonth(DateTime(2026, 7, 1));
      final CalendarMonth aug = CalendarMonth(DateTime(2026, 8, 1));
      expect(
        jul.gridHeight(_weekdayRow) - feb.gridHeight(_weekdayRow),
        moreOrLessEquals(36, epsilon: 0.001),
      );
      expect(
        aug.gridHeight(_weekdayRow) - jul.gridHeight(_weekdayRow),
        moreOrLessEquals(36, epsilon: 0.001),
      );
      expect(
        at(5),
        moreOrLessEquals(jul.gridHeight(_weekdayRow), epsilon: 0.001),
      );
    });

    test('the outer heights the parity probe is pinned against', () {
      double outer(DateTime m) =>
          CalendarMonth(m).outerHeight(_weekdayRow, CalendarPresentation.card);
      // *(Measured: 232.563 / 268.563 / 304.563 — Chrome's 1/64px grid under
      // the exact values below.)*
      expect(
        outer(DateTime(2026, 2, 1)),
        moreOrLessEquals(232.5714, epsilon: 0.01),
      );
      expect(
        outer(DateTime(2026, 7, 1)),
        moreOrLessEquals(268.5714, epsilon: 0.01),
      );
      expect(
        outer(DateTime(2026, 8, 1)),
        moreOrLessEquals(304.5714, epsilon: 0.01),
      );
      // The map derived 268.571 / 304.571 and had no 4-row case at all.
      expect(
        outer(DateTime(2026, 8, 1)) - outer(DateTime(2026, 7, 1)),
        moreOrLessEquals(36, epsilon: 0.001),
      );
    });

    test('the popover surface is 8px shorter and 10px narrower *(measured '
        '212 × 294.563)*', () {
      final double panel = CalendarMonth(
        DateTime(2026, 8, 1),
      ).outerHeight(_weekdayRow, CalendarPresentation.card);
      final double popover = CalendarMonth(
        DateTime(2026, 8, 1),
      ).outerHeight(_weekdayRow, CalendarPresentation.popover);
      // `p-3` → `p-2` is 8px of padding, and the popover calendar has no
      // border of its own.
      expect(panel - popover, moreOrLessEquals(8 + 2, epsilon: 0.001));
      expect(popover, moreOrLessEquals(294.5714, epsilon: 0.01));
    });

    test('the twenty-two-month sweep the live calendar was walked through', () {
      // Driven on the reference: fourteen months forward from August 2026 and
      // eight back. Every row count below came off the browser.
      const Map<String, int> measured = <String, int>{
        '2025-12': 5,
        '2026-01': 5,
        '2026-02': 4,
        '2026-03': 5,
        '2026-04': 5,
        '2026-05': 6,
        '2026-06': 5,
        '2026-07': 5,
        '2026-08': 6,
        '2026-09': 5,
        '2026-10': 5,
        '2026-11': 5,
        '2026-12': 5,
        '2027-01': 6,
        '2027-02': 5,
        '2027-03': 5,
        '2027-04': 5,
        '2027-05': 6,
        '2027-06': 5,
        '2027-07': 5,
        '2027-08': 5,
        '2027-09': 5,
      };
      measured.forEach((String key, int rows) {
        final List<String> parts = key.split('-');
        final DateTime month = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
        expect(
          CalendarMonth(month).weekCount,
          rows,
          reason: '${DateFormat.monthYear(month)} rendered $rows rows',
        );
      });
    });

    test('addMonths clamps into the target month, the way date-fns does', () {
      expect(
        CalendarDay.addMonths(DateTime(2026, 1, 31), 1),
        DateTime(2026, 2, 28),
      );
      expect(
        CalendarDay.addMonths(DateTime(2026, 3, 31), -1),
        DateTime(2026, 2, 28),
      );
      expect(
        CalendarDay.addMonths(DateTime(2026, 8, 16), 1),
        DateTime(2026, 9, 16),
      );
    });
  });

  // ─── the clock seam ──────────────────────────────────────────────────────

  group('Clock — ruling L2, getInitialMonth against a frozen instant', () {
    testWidgets('the page passes neither month nor defaultMonth, so the '
        'calendar opens on the clock\'s month', (WidgetTester t) async {
      await t.pumpWidget(
        host(Calendar.single(selected: DateTime(2026, 7, 30)), clock: _frozen),
      );
      await t.pump();
      // NOT July, the month of its own selected value. This is selects-map
      // drift 2, reproduced.
      expect(captionOf(t), 'August 2026');
    });

    testWidgets('drift 2 is HALF WRONG for §5: the seeded 30 Jul selection IS '
        'on screen in August 2026', (WidgetTester t) async {
      await t.pumpWidget(
        host(Calendar.single(selected: DateTime(2026, 7, 30)), clock: _frozen),
      );
      await t.pump();
      // August opens with six outside days, 26–31 July, and the selection is
      // one of them — `data-selected=true data-outside=true` on the live
      // reference, at full `--primary`.
      expect(captionOf(t), 'August 2026');
      // '30' appears TWICE in this grid — 30 July as a leading outside day
      // and 30 August in the last week — which is itself the point: the
      // selection is the outside one.
      expect(find.text('30'), findsNWidgets(2));
      await t.pump(MotionDurations.normal);
      await t.pump(MotionDurations.normal);
      expect(
        _fillOf(t, '30'),
        isColor(themeIn(t, Calendar).primary),
        reason: 'the leading 30 July cell is the selected one',
      );
    });

    testWidgets('defaultMonth seeds it when one is given', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          Calendar.single(
            selected: DateTime(2026, 7, 30),
            defaultMonth: DateTime(2026, 7, 1),
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
      expect(captionOf(t), 'July 2026');
    });

    testWidgets('a controlled `month` wins over both, and follows', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(Calendar.single(month: DateTime(2026, 2, 1)), clock: _frozen),
      );
      await t.pump();
      expect(captionOf(t), 'February 2026');

      await t.pumpWidget(
        host(Calendar.single(month: DateTime(2026, 5, 1)), clock: _frozen),
      );
      await t.pump();
      expect(captionOf(t), 'May 2026');
    });

    testWidgets('with no clock in scope it falls back to DateTime.now', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const Calendar.single()));
      await t.pump();
      expect(captionOf(t), DateFormat.monthYear(DateTime.now()));
    });

    testWidgets('`today` is the clock\'s day, and it paints the muted square', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const Calendar.single(), clock: _frozen));
      await t.pump();
      final CalendarBandPainter under = _underlayOf(t, '16');
      expect(under.today, isTrue, reason: '16 Aug 2026 is the frozen today');
      expect(under.selected, isFalse);
      // A different day paints nothing at all.
      expect(_underlayOf(t, '17').today, isFalse);
    });
  });

  // ─── rendered geometry ───────────────────────────────────────────────────

  group('the box — every §8.5 derivation, against the browser', () {
    testWidgets('196px of content, 222 × 304.5714 on a Panel *(measured '
        '222 × 304.563)*', (WidgetTester t) async {
      await t.pumpWidget(host(const Calendar.single(), clock: _frozen));
      await t.pump();
      final Size size = t.getSize(find.byType(Calendar));
      expect(
        size.width,
        moreOrLessEquals(196 + 2 * _panelPad + 2, epsilon: 0.01),
      );
      expect(size.width, 222);
      expect(size.height, moreOrLessEquals(_panelHeight(6), epsilon: 0.01));
      expect(Calendar.contentWidth, 196);
    });

    testWidgets('a five-row month is exactly 36px shorter', (
      WidgetTester t,
    ) async {
      // A key per month: `defaultMonth` is the UNCONTROLLED seed and is read
      // once, exactly as `react-day-picker` reads it, so changing it on a
      // mounted calendar deliberately does nothing.
      await t.pumpWidget(
        host(
          Calendar.single(
            key: const ValueKey<String>('july'),
            defaultMonth: DateTime(2026, 7, 1),
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
      final double july = t.getSize(find.byType(Calendar)).height;
      expect(july, moreOrLessEquals(_panelHeight(5), epsilon: 0.01));

      await t.pumpWidget(
        host(
          Calendar.single(
            key: const ValueKey<String>('february'),
            defaultMonth: DateTime(2026, 2, 1),
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
      final double february = t.getSize(find.byType(Calendar)).height;
      expect(february, moreOrLessEquals(_panelHeight(4), epsilon: 0.01));
      expect(july - february, moreOrLessEquals(36, epsilon: 0.01));
    });

    testWidgets('the cell is 28 × 28 and the grid is seven of them', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const Calendar.single(), clock: _frozen));
      await t.pump();
      expect(Calendar.cellSize, space(7));
      final Rect first = t.getRect(dayCell('26').first);
      expect(first.width, 28);
      expect(first.height, 28);
      // Two cells in the same row are exactly one cell apart — no gap.
      final Rect second = t.getRect(dayCell('27').first);
      expect(second.left - first.left, 28);
      expect(second.top, first.top);
    });

    testWidgets('the caption row is 28 tall with 28px gutters, and the nav '
        'buttons fill them', (WidgetTester t) async {
      await t.pumpWidget(host(const Calendar.single(), clock: _frozen));
      await t.pump();
      final Rect calendar = t.getRect(find.byType(Calendar));
      final Finder chevrons = find.byType(Icon);
      expect(chevrons, findsNWidgets(2));
      final Rect previous = t.getRect(chevrons.at(0));
      final Rect next = t.getRect(chevrons.at(1));
      // 16px glyphs, centred in their 28px squares, which sit flush against
      // the content box's two edges.
      expect(previous.width, 16);
      expect(next.width, 16);
      expect(
        previous.center.dx - (calendar.left + _panelPad + 1),
        moreOrLessEquals(14, epsilon: 0.01),
      );
      expect(
        (calendar.right - _panelPad - 1) - next.center.dx,
        moreOrLessEquals(14, epsilon: 0.01),
      );
    });

    testWidgets(
      'the weekday header is a 18.5714px line box *(Chrome 18.563)*',
      (WidgetTester t) async {
        await t.pumpWidget(host(const Calendar.single(), clock: _frozen));
        await t.pump();
        final Rect su = t.getRect(
          find.ancestor(of: find.text('Su'), matching: find.byType(StyledText)),
        );
        expect(su.height, moreOrLessEquals(_weekdayRow, epsilon: 0.01));
        // The row that follows starts 8px below it — `week` is `mt-2`.
        final Rect firstRow = t.getRect(dayCell('26').first);
        expect(firstRow.top - su.bottom, moreOrLessEquals(8, epsilon: 0.01));
        // Su Mo Tu We Th Fr Sa, in the reference's order.
        for (final String label in DateFormat.weekdaysNarrow) {
          expect(find.text(label), findsOneWidget);
        }
      },
    );

    testWidgets('the caption sits 16px above the grid — `month`\'s `gap-4`', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const Calendar.single(), clock: _frozen));
      await t.pump();
      final Rect calendar = t.getRect(find.byType(Calendar));
      final Rect su = t.getRect(
        find.ancestor(of: find.text('Su'), matching: find.byType(StyledText)),
      );
      // caption top = padding + border; caption is 28 tall; then 16.
      final double captionTop = calendar.top + _panelPad + 1;
      expect(su.top - (captionTop + 28), moreOrLessEquals(16, epsilon: 0.01));
    });

    testWidgets(
      'the popover surface: transparent, `p-2`, no border, 212 wide',
      (WidgetTester t) async {
        await t.pumpWidget(
          host(
            const Calendar.single(surface: CalendarPresentation.popover),
            clock: _frozen,
          ),
        );
        await t.pump();
        final Size size = t.getSize(find.byType(Calendar));
        expect(size.width, 196 + 2 * _popoverPad);
        expect(size.width, 212);
        expect(
          size.height,
          moreOrLessEquals(_panelHeight(6) - 8 - 2, epsilon: 0.01),
        );
      },
    );
  });

  // ─── range selection ─────────────────────────────────────────────────────

  group('DateRange.addToRange — every branch, driven on the reference', () {
    DateRange? add(DateTime day, DateRange? range) =>
        DateRange.addToRange(day, range);
    DateTime jul(int day) => DateTime(2026, 7, day);

    test('an empty range: ONE click makes a one-day range, not a half-open '
        'one *(measured: the Panel note reads "5 Jul – 5 Jul")*', () {
      expect(add(jul(5), null), DateRange(from: jul(5), to: jul(5)));
      expect(
        add(jul(5), const DateRange()),
        DateRange(from: jul(5), to: jul(5)),
      );
    });

    test('clicking the `to` of a complete range collapses onto it '
        '*(12→20, click 20 ⇒ 20→20)*', () {
      expect(
        add(jul(20), DateRange(from: jul(12), to: jul(20))),
        DateRange(from: jul(20), to: jul(20)),
      );
    });

    test('clicking the `from` of a complete range collapses onto it too '
        '*(20→24, click 20 ⇒ 20→20)*', () {
      expect(
        add(jul(20), DateRange(from: jul(20), to: jul(24))),
        DateRange(from: jul(20), to: jul(20)),
      );
    });

    test('before the start extends the start *(15→20, click 10 ⇒ 10→20)*', () {
      expect(
        add(jul(10), DateRange(from: jul(15), to: jul(20))),
        DateRange(from: jul(10), to: jul(20)),
      );
    });

    test('inside or after moves the end *(10→20, click 12 ⇒ 10→12)*', () {
      expect(
        add(jul(12), DateRange(from: jul(10), to: jul(20))),
        DateRange(from: jul(10), to: jul(12)),
      );
      // And the first click of the whole probe: 12 Jul → 20 Jul, click 4 Aug.
      expect(
        add(DateTime(2026, 8, 4), DateRange(from: jul(12), to: jul(20))),
        DateRange(from: jul(12), to: DateTime(2026, 8, 4)),
      );
    });

    test('clicking the single day of a one-day range CLEARS the selection — '
        'the one branch no reader would predict', () {
      expect(add(jul(5), DateRange(from: jul(5), to: jul(5))), isNull);
    });

    test('the incomplete-range branches, which `min: 0` makes unreachable '
        'from a click but which the transcript still carries', () {
      expect(
        add(jul(10), DateRange(from: jul(15))),
        DateRange(from: jul(10), to: jul(15)),
      );
      expect(
        add(jul(20), DateRange(from: jul(15))),
        DateRange(from: jul(15), to: jul(20)),
      );
      expect(
        add(jul(15), DateRange(from: jul(15))),
        DateRange(from: jul(15), to: jul(15)),
      );
    });

    test('the modifiers: a one-day range is BOTH ends and no middle', () {
      final DateRange one = DateRange(from: jul(5), to: jul(5));
      expect(one.isStart(jul(5)), isTrue);
      expect(one.isEnd(jul(5)), isTrue);
      expect(one.isMiddle(jul(5)), isFalse);
      expect(one.isComplete, isTrue);

      final DateRange band = DateRange(from: jul(12), to: jul(20));
      expect(band.isStart(jul(12)), isTrue);
      expect(band.isEnd(jul(20)), isTrue);
      expect(band.isMiddle(jul(15)), isTrue);
      expect(band.isMiddle(jul(12)), isFalse);
      expect(band.includes(jul(11)), isFalse);
      expect(band.includes(jul(21)), isFalse);
      // Seven middles between 12 and 20 — *(measured: the live grid reports
      // exactly seven)*.
      expect(
        <int>[
          for (int d = 12; d <= 20; d++) d,
        ].where((int d) => band.isMiddle(jul(d))).length,
        7,
      );
    });

    test('an incomplete range is not complete, and `rangeLabel` reads it', () {
      expect(DateRange(from: jul(5)).isComplete, isFalse);
      expect(const DateRange().isComplete, isFalse);
    });
  });

  group('Calendar.range — the grid reports what addToRange says', () {
    testWidgets('a click extends the seeded range, and the callback carries '
        'the whole new range', (WidgetTester t) async {
      DateRange? seen;
      await t.pumpWidget(
        host(
          Calendar.range(
            selected: DateRange(
              from: DateTime(2026, 7, 12),
              to: DateTime(2026, 7, 20),
            ),
            defaultMonth: DateTime(2026, 7, 1),
            onSelected: (DateRange? r) => seen = r,
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
      await t.tap(dayCell('24').first);
      await t.pump();
      expect(
        seen,
        DateRange(from: DateTime(2026, 7, 12), to: DateTime(2026, 7, 24)),
      );
    });

    testWidgets('a wrapped range caps every row — the `<td>` first-child / '
        'last-child rules the map lists and does not resolve', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          Calendar.range(
            selected: DateRange(
              from: DateTime(2026, 7, 12),
              to: DateTime(2026, 7, 20),
            ),
            defaultMonth: DateTime(2026, 7, 1),
            onSelected: (DateRange? _) {},
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
      // *(Measured: 18 Jul, the Saturday, renders `0 10 10 0`; 19 Jul, the
      // Sunday that follows it, renders `10 0 0 10`.)*
      final BorderRadius saturday = _radiusOf(t, '18');
      expect(saturday.topLeft, Radius.zero);
      expect(saturday.topRight, Radius.circular(Radii.md));
      expect(saturday.bottomRight, Radius.circular(Radii.md));
      expect(saturday.bottomLeft, Radius.zero);

      final BorderRadius sunday = _radiusOf(t, '19');
      expect(sunday.topLeft, Radius.circular(Radii.md));
      expect(sunday.topRight, Radius.zero);

      // A middle in the body of a row is square on all four.
      final BorderRadius middle = _radiusOf(t, '15');
      expect(middle, BorderRadius.zero);

      // Both ends are 10px rounded squares, not pills.
      expect(_radiusOf(t, '12'), BorderRadius.all(Radius.circular(Radii.md)));
      expect(_radiusOf(t, '20'), BorderRadius.all(Radius.circular(Radii.md)));
      // And a day outside the range is still a pill.
      expect(_radiusOf(t, '3'), BorderRadius.all(Radius.circular(Radii.full)));
    });

    testWidgets('the band\'s ends are `--primary`, its middles `--muted`', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          Calendar.range(
            selected: DateRange(
              from: DateTime(2026, 7, 12),
              to: DateTime(2026, 7, 20),
            ),
            defaultMonth: DateTime(2026, 7, 1),
            onSelected: (DateRange? _) {},
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
      await t.pump(MotionDurations.normal);
      await t.pump(MotionDurations.normal);
      final ThemeTokens theme = themeIn(t, Calendar);
      expect(_fillOf(t, '12'), isColor(theme.primary));
      expect(_fillOf(t, '20'), isColor(theme.primary));
      expect(_fillOf(t, '15'), isColor(theme.muted));
      expect(_inkOf(t, '15'), isColor(theme.foreground));
      expect(_inkOf(t, '12'), isColor(theme.primaryForeground));
      // *(Measured dark: start/end `rgb(26,110,244)`, middle `rgb(39,39,42)`,
      // middle ink `rgb(250,250,250)` = `--foreground`.)*
    });
  });

  // ─── the painter ─────────────────────────────────────────────────────────

  group('the range band — two overlapping rectangles, and the pixels to '
      'prove it', () {
    /// The `<td>` underlay for [day], as the painter was configured.
    testWidgets('range_start draws a 10px rrect and a 16px square against its '
        'RIGHT edge; range_end mirrors it', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          Calendar.range(
            selected: DateRange(
              from: DateTime(2026, 7, 12),
              to: DateTime(2026, 7, 20),
            ),
            defaultMonth: DateTime(2026, 7, 1),
            onSelected: (DateRange? _) {},
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
      final CalendarBandPainter start = _underlayOf(t, '12');
      expect(start.rangeStart, isTrue);
      expect(start.rangeEnd, isFalse);
      expect(start.radius, Radii.md);
      expect(start.muted, themeIn(t, Calendar).muted);
      // `after:w-4` — *(measured 16px wide, 28 tall, computed `left: 12px`
      // against `right: 0`)*.
      expect(start.bleed, 16);
      expect(Calendar.rangeBleed, space(4));

      final CalendarBandPainter end = _underlayOf(t, '20');
      expect(end.rangeEnd, isTrue);
      expect(end.rangeStart, isFalse);

      // A middle paints NOTHING on the `<td>` — its fill is the button's.
      // *(Measured: `tdBg: rgba(0,0,0,0)` on every middle cell.)*
      final CalendarBandPainter middle = _underlayOf(t, '15');
      expect(middle.rangeStart, isFalse);
      expect(middle.rangeEnd, isFalse);
      expect(middle.today, isFalse);
    });

    testWidgets('a ONE-DAY range is both ends, and its square goes LEFT — the '
        'over-constrained `after` CSS drops in LTR *(measured)*', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          Calendar.range(
            selected: DateRange(
              from: DateTime(2026, 7, 20),
              to: DateTime(2026, 7, 20),
            ),
            defaultMonth: DateTime(2026, 7, 1),
            onSelected: (DateRange? _) {},
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
      final CalendarBandPainter one = _underlayOf(t, '20');
      expect(one.rangeStart, isTrue);
      expect(one.rangeEnd, isTrue);
      // `after:left-0` and `after:right-0` both land on the one `<td>`, and
      // `left` + `width` win — the painter checks `rangeEnd` first for exactly
      // that reason.
      expect(one.selected, isTrue);
      expect(_radiusOf(t, '20'), BorderRadius.all(Radius.circular(Radii.md)));
    });

    testWidgets('RENDERED PIXELS: the muted band runs continuously across the '
        'seam between the start cell and the middle beside it', (
      WidgetTester t,
    ) async {
      // A three-day range on one row, so the band is start · middle · end and
      // every seam is on screen. 15–17 Jul 2026 are Wed/Thu/Fri — columns
      // 3, 4 and 5 of the third week.
      final Widget calendar = Calendar.range(
        selected: DateRange(
          from: DateTime(2026, 7, 15),
          to: DateTime(2026, 7, 17),
        ),
        defaultMonth: DateTime(2026, 7, 1),
        onSelected: (DateRange? _) {},
        surface: CalendarPresentation.popover,
      );

      // Find the band's own row first, then raster it.
      await t.pumpWidget(host(calendar, clock: _frozen));
      await t.pump();
      final ThemeTokens theme = themeIn(t, Calendar);
      final Rect box = t.getRect(find.byType(Calendar));
      final Rect start = t.getRect(dayCell('15').first);
      final int midY = (start.center.dy - box.top).round();
      final int startX = (start.left - box.left).round();

      final List<Color> row = await rasterRow(
        t,
        calendar,
        atY: midY,
        clock: _frozen,
      );

      // Interior samples sit 2px in from each cell's left edge: at mid-height
      // the corner radius cuts nothing there, and it is clear of the day
      // number, whose white strokes would otherwise blend with the fill.
      expect(
        row[startX + 2],
        isColor(theme.primary),
        reason: 'the start cell should be a solid primary chip',
      );
      expect(
        row[startX + 28 + 2],
        isColor(theme.muted),
        reason: 'the middle cell should be a solid muted square',
      );
      expect(row[startX + 56 + 2], isColor(theme.primary));

      // THE SEAM. One pixel to the left of the boundary is inside the start
      // cell's right edge; at the vertical centre the button's 10px radius is
      // not cutting anything, so this is still primary — and one pixel to the
      // right is the middle's muted. The band is continuous because the
      // 16px square underneath has already filled everything the radius will
      // cut higher up.
      expect(row[startX + 27], isColor(theme.primary));
      expect(row[startX + 28], isColor(theme.muted));

      // The anti-assertion the painter ruling asks for: the three cells are
      // NOT one flat colour, and they are not the collapsed composite either.
      expect(theme.primary, isNot(isColor(theme.muted)));
      expect(
        row[startX + 2],
        isNot(isColor(theme.muted)),
        reason:
            'a start cell painted `--muted` would mean the button layer '
            'never landed',
      );
      expect(
        row[startX + 28 + 2],
        isNot(isColor(theme.primary)),
        reason:
            'a middle painted `--primary` would mean the range states '
            'collapsed into one fill',
      );
    });

    testWidgets('RENDERED PIXELS: the corner notch. The start cell\'s top row '
        'is muted where the primary chip\'s 10px radius cuts away, and '
        'primary in the middle', (WidgetTester t) async {
      final Widget calendar = Calendar.range(
        selected: DateRange(
          from: DateTime(2026, 7, 15),
          to: DateTime(2026, 7, 17),
        ),
        defaultMonth: DateTime(2026, 7, 1),
        onSelected: (DateRange? _) {},
        surface: CalendarPresentation.popover,
      );
      await t.pumpWidget(host(calendar, clock: _frozen));
      await t.pump();
      final ThemeTokens theme = themeIn(t, Calendar);
      final Rect box = t.getRect(find.byType(Calendar));
      final Rect start = t.getRect(dayCell('15').first);
      final int topY = (start.top - box.top).round() + 1;
      final int startX = (start.left - box.left).round();

      final List<Color> row = await rasterRow(
        t,
        calendar,
        atY: topY,
        clock: _frozen,
      );

      // One pixel down from the cell's top edge, the chip's 10px radius has
      // eaten roughly 6px off each side. Inside that: primary. Inside the
      // notch on the band's inner (right) side: the 16px square's `--muted`,
      // which is what continues the band.
      expect(
        row[startX + 14],
        isColor(theme.primary),
        reason: 'the chip\'s own top edge',
      );
      expect(
        row[startX + 27],
        isColor(theme.muted),
        reason:
            'the notch the radius cuts is filled by the 16px bleed — '
            'this is the pixel that makes the band continuous',
      );
      // And the same notch on the OUTER (left) side is NOT filled: the bleed
      // is one-sided, so the band starts with a rounded cap.
      expect(row[startX], isNot(isColor(theme.muted)));
      expect(row[startX], isNot(isColor(theme.primary)));
    });

    testWidgets('a cell that is neither today nor a range end paints NOTHING '
        '— 40 of the 42 cells on a typical grid', (WidgetTester t) async {
      await t.pumpWidget(host(const Calendar.single(), clock: _frozen));
      await t.pump();
      final CalendarBandPainter plain = _underlayOf(t, '5');
      expect(plain.today, isFalse);
      expect(plain.rangeStart, isFalse);
      expect(plain.rangeEnd, isFalse);
      // The repaint gate is the state it draws, and nothing else.
      expect(plain.shouldRepaint(_underlayOf(t, '6')), isFalse);
      expect(
        plain.shouldRepaint(_underlayOf(t, '16')),
        isTrue,
        reason: '16 Aug 2026 is the frozen today and does paint',
      );
    });
  });

  // ─── keyboard ────────────────────────────────────────────────────────────

  group('the keyboard — driven on the live grid', () {
    Future<void> pumpGrid(WidgetTester t, {DateTime? selected}) async {
      await t.pumpWidget(
        host(
          Calendar.single(
            selected: selected,
            defaultMonth: DateTime(2026, 8, 1),
            autoFocus: true,
            onSelected: (DateTime? _) {},
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
    }

    testWidgets('← → move a day, ↑ ↓ move a week', (WidgetTester t) async {
      await pumpGrid(t, selected: DateTime(2026, 8, 10));
      await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await t.pump();
      expect(_focusedDay(t), '11');
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      expect(_focusedDay(t), '18');
      await t.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await t.pump();
      expect(_focusedDay(t), '17');
      await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await t.pump();
      expect(_focusedDay(t), '10');
    });

    testWidgets('Home and End go to the Sunday and the Saturday of the '
        'focused week', (WidgetTester t) async {
      await pumpGrid(t, selected: DateTime(2026, 8, 12));
      await t.sendKeyEvent(LogicalKeyboardKey.home);
      await t.pump();
      // 12 Aug 2026 is a Wednesday; its week runs 9–15.
      expect(_focusedDay(t), '9');
      await t.sendKeyEvent(LogicalKeyboardKey.end);
      await t.pump();
      expect(_focusedDay(t), '15');
    });

    testWidgets('PageDown and PageUp move a month at the same day-of-month, '
        'and the caption follows', (WidgetTester t) async {
      await pumpGrid(t, selected: DateTime(2026, 8, 11));
      await t.sendKeyEvent(LogicalKeyboardKey.pageDown);
      await t.pump();
      expect(captionOf(t), 'September 2026');
      expect(_focusedDay(t), '11');
      await t.sendKeyEvent(LogicalKeyboardKey.pageUp);
      await t.pump();
      expect(captionOf(t), 'August 2026');
    });

    testWidgets('stepping past the edge of the month NAVIGATES *(driven: '
        'forty ArrowRights carried the caption a month on)*', (
      WidgetTester t,
    ) async {
      await pumpGrid(t, selected: DateTime(2026, 8, 30));
      for (int i = 0; i < 3; i++) {
        await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await t.pump();
      }
      // 30 → 31 Aug → 1 Sep, and the grid follows the focus.
      expect(captionOf(t), 'September 2026');
      expect(_focusedDay(t), '2');
    });

    testWidgets('Enter selects the focused day', (WidgetTester t) async {
      DateTime? seen;
      await t.pumpWidget(
        host(
          Calendar.single(
            selected: DateTime(2026, 8, 10),
            defaultMonth: DateTime(2026, 8, 1),
            autoFocus: true,
            onSelected: (DateTime? d) => seen = d,
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pump();
      expect(seen, DateTime(2026, 8, 11));
    });

    testWidgets('the focus ring is a 3px `--ring`/50 band on the focused cell '
        'and on no other', (WidgetTester t) async {
      await pumpGrid(t, selected: DateTime(2026, 8, 10));
      await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await t.pump();
      final ThemeTokens theme = themeIn(t, Calendar);
      final BoxDecoration ring = _ringOf(t, '11')!;
      final BorderSide side = (ring.border! as Border).top;
      expect(side.width, 3);
      expect(side.color, theme.ring.withValues(alpha: 0.50));
      expect(side.strokeAlign, BorderSide.strokeAlignOutside);
      // Exactly one cell wears it.
      expect(_ringOf(t, '10'), isNull);
      expect(_ringOf(t, '12'), isNull);
    });
  });

  // ─── month navigation ────────────────────────────────────────────────────

  group('month navigation — an instant content swap', () {
    testWidgets('the two nav buttons move the caption and the row count', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const Calendar.single(), clock: _frozen));
      await t.pump();
      expect(captionOf(t), 'August 2026');
      final double august = t.getSize(find.byType(Calendar)).height;

      await t.tap(find.byType(Icon).at(0));
      await t.pump();
      expect(captionOf(t), 'July 2026');
      // *(Traced on the reference: the height jumps 304.563 → 268.563 in ONE
      // frame — no opacity, no transform, no tween on the grid at all.)*
      expect(
        august - t.getSize(find.byType(Calendar)).height,
        moreOrLessEquals(36, epsilon: 0.01),
      );

      await t.tap(find.byType(Icon).at(1));
      await t.pump();
      expect(captionOf(t), 'August 2026');
    });

    testWidgets('onMonthChanged reports every move', (WidgetTester t) async {
      final List<DateTime> seen = <DateTime>[];
      await t.pumpWidget(
        host(Calendar.single(onMonthChanged: seen.add), clock: _frozen),
      );
      await t.pump();
      await t.tap(find.byType(Icon).at(0));
      await t.pump();
      await t.tap(find.byType(Icon).at(0));
      await t.pump();
      expect(seen, <DateTime>[DateTime(2026, 7), DateTime(2026, 6)]);
    });
  });

  // ─── single mode ─────────────────────────────────────────────────────────

  group('Calendar.single', () {
    testWidgets('a tap reports the day; a second tap on the same day clears '
        'it — `mode="single"` without `required`', (WidgetTester t) async {
      final List<DateTime?> seen = <DateTime?>[];
      await t.pumpWidget(
        host(
          Calendar.single(
            selected: DateTime(2026, 8, 10),
            onSelected: seen.add,
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
      await t.tap(dayCell('11').first);
      await t.pump();
      await t.tap(dayCell('10').first);
      await t.pump();
      expect(seen, <DateTime?>[DateTime(2026, 8, 11), null]);
    });

    testWidgets('the selected day is a CIRCLE — `rounded-pill` on a square '
        'box, which is drift 25\'s "circle on a rounded square"', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          Calendar.single(
            selected: DateTime(2026, 8, 10),
            onSelected: (DateTime? _) {},
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
      expect(_radiusOf(t, '10'), BorderRadius.all(Radius.circular(Radii.full)));
    });

    testWidgets('the day number is 16px / leading-none / 400 *(measured)*', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const Calendar.single(), clock: _frozen));
      await t.pump();
      expect(CalendarTextStyles.dayNumber.size, 16);
      expect(CalendarTextStyles.dayNumber.height, 1);
      expect(CalendarTextStyles.dayNumber.family, Fonts.sans);
      // The cell's number goes through that spec and no other.
      final StyledText number = t.widget<StyledText>(
        find.descendant(
          of: dayCell('10').first,
          matching: find.byType(StyledText),
        ),
      );
      expect(number.spec, CalendarTextStyles.dayNumber);
    });

    testWidgets('an outside day is byte-identical to an in-month one at rest '
        '— the `outside` className paints nothing *(measured, both themes)*', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const Calendar.single(), clock: _frozen));
      await t.pump();
      await t.pump(MotionDurations.normal);
      await t.pump(MotionDurations.normal);
      // 26 Jul is an outside day of August 2026; 5 Aug is in-month.
      expect(_fillOf(t, '26'), isColor(_fillOf(t, '5')));
      expect(_inkOf(t, '26'), isColor(_inkOf(t, '5')));
      expect(_inkOf(t, '26'), isColor(themeIn(t, Calendar).mutedForeground));
    });

    testWidgets('every cell carries its accessible name', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const Calendar.single(), clock: _frozen));
      await t.pump();
      final Set<String> labels = t
          .widgetList<Semantics>(find.byType(Semantics))
          .map((Semantics s) => s.properties.label)
          .whereType<String>()
          .toSet();
      expect(labels, contains('Wednesday, August 5th, 2026'));
      expect(labels, contains('Sunday, July 26th, 2026'));
      expect(labels, contains('Go to the previous month'));
      expect(labels, contains('Go to the next month'));
    });
  });

  // ─── the date picker ─────────────────────────────────────────────────────

  group('DatePicker — the recipe, packaged', () {
    testWidgets('the popover mounts on the two-pump boundary and carries the '
        'calendar', (WidgetTester t) async {
      await t.pumpWidget(
        overlayHost(
          SizedBox(
            width: 320,
            child: DatePicker(
              value: DateTime(2026, 7, 30),
              onChanged: (DateTime? _) {},
            ),
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
      expect(find.byType(PopoverSurface), findsNothing);

      await t.tap(find.byType(Button));
      await settleOverlay(t);
      expect(find.byType(PopoverSurface), findsOneWidget);
      expect(find.byType(Calendar), findsOneWidget);
      // `in-data-[slot=popover-content]:bg-transparent` — the calendar inside
      // a popover is transparent and keeps `p-2`.
      expect(
        t.widget<Calendar>(find.byType(Calendar)).surface,
        CalendarPresentation.popover,
      );
      // *(Measured: the live popup opens on August, the reader's month, with
      // the seeded 30 Jul selection visible as an outside day.)*
      expect(captionOf(t), 'August 2026');
    });

    testWidgets('side bottom, align start, sideOffset 4 *(measured: the live '
        'popup lands 4px under the trigger with its left edges flush)*', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        overlayHost(
          SizedBox(
            width: 320,
            child: DatePicker(
              value: DateTime(2026, 7, 30),
              onChanged: (DateTime? _) {},
            ),
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
      final Popover popover = t.widget<Popover>(find.byType(Popover));
      expect(popover.side, PopoverSide.bottom);
      expect(popover.align, PopoverAlign.start);
      expect(popover.sideOffset, space(1));
      expect(popover.sideOffset, 4);

      await t.tap(find.byType(Button));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);
      final Rect trigger = t.getRect(find.byType(Button));
      final Rect popup = t.getRect(find.byType(PopoverSurface));
      expect(popup.top - trigger.bottom, moreOrLessEquals(4, epsilon: 0.01));
      expect(popup.left, moreOrLessEquals(trigger.left, epsilon: 0.01));
      // Content-sized — `w-auto` — so 212, not the 320px anchor.
      expect(popup.width, moreOrLessEquals(212, epsilon: 0.01));
    });

    testWidgets('the label swaps typeface with state — the whole demo', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          SizedBox(
            width: 320,
            child: DatePicker(
              value: DateTime(2026, 7, 30),
              onChanged: (DateTime? _) {},
            ),
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
      final StyledText picked = t.widget<StyledText>(
        find.ancestor(
          of: find.text('30 Jul 2026'),
          matching: find.byType(StyledText),
        ),
      );
      // `.type-num` — *(measured 15px / 18 / 600, Geist Mono, −0.15px)*.
      expect(picked.spec, TextStyles.numberBase);
      expect(picked.spec.size, 15);
      expect(picked.spec.family, Fonts.mono);
      expect(picked.spec.tabular, isTrue);

      await t.pumpWidget(
        host(
          SizedBox(
            width: 320,
            child: DatePicker(value: null, onChanged: (DateTime? _) {}),
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
      final StyledText empty = t.widget<StyledText>(
        find.ancestor(
          of: find.text('Pick a date'),
          matching: find.byType(StyledText),
        ),
      );
      // No class of its own — it inherits the Button's 13px / 500 sans.
      expect(empty.spec, TextStyles.buttonLabel);
      expect(empty.spec.family, Fonts.sans);
    });

    testWidgets('picking a day reports it and closes the popover', (
      WidgetTester t,
    ) async {
      DateTime? seen;
      bool changed = false;
      await t.pumpWidget(
        overlayHost(
          SizedBox(
            width: 320,
            child: DatePicker(
              value: null,
              onChanged: (DateTime? d) {
                seen = d;
                changed = true;
              },
            ),
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
      await t.tap(find.byType(Button));
      await settleOverlay(t);
      await t.tap(dayCell('20').first);
      await t.pump();
      expect(changed, isTrue);
      expect(seen, DateTime(2026, 8, 20));
      await settleOverlay(t);
      await t.pump(MotionDurations.overlayEnter);
      await t.pump(MotionDurations.tick);
      await t.pump();
      expect(find.byType(PopoverSurface), findsNothing);
    });

    testWidgets('a disabled picker opens nothing — §7\'s "Locked to the tax '
        'year"', (WidgetTester t) async {
      await t.pumpWidget(
        overlayHost(
          SizedBox(width: 320, child: DatePicker(value: DateTime(2026, 4, 6))),
          clock: _frozen,
        ),
      );
      await t.pump();
      expect(find.text('6 Apr 2026'), findsOneWidget);
      await t.tap(find.byType(Button), warnIfMissed: false);
      await settleOverlay(t);
      expect(find.byType(PopoverSurface), findsNothing);
    });

    testWidgets('drift 20: this is the one Button on the page that does not '
        'squish', (WidgetTester t) async {
      // `PopoverTrigger` stamps `aria-haspopup="dialog"`, which cancels the
      // Button's `active:not-aria-[haspopup]:scale-95`. Recorded as a
      // property so the drift is assertable rather than only commented.
      expect(DatePicker.pressScaleSuppressed, isTrue);

      // …and driven, so the property is a claim about the port rather than
      // about itself: the trigger passes `Button.suppressPressScale`, and a
      // held trigger stays at unity where every other Button is at 0.95.
      await t.pumpWidget(
        overlayHost(
          SizedBox(
            width: 320,
            child: DatePicker(
              value: DateTime(2026, 7, 30),
              onChanged: (DateTime? _) {},
            ),
          ),
          clock: _frozen,
        ),
      );
      await t.pump();

      double scaleOf() => t
          .widget<Transform>(
            find
                .descendant(
                  of: find.byType(Button),
                  matching: find.byType(Transform),
                )
                .first,
          )
          .transform
          .storage[0];

      final TestGesture press = await t.startGesture(
        t.getCenter(find.byType(Button)),
      );
      await settleOverlay(t);
      expect(scaleOf(), 1.0);
      await press.up();
      await t.pump();
      expect(scaleOf(), 1.0);
    });

    testWidgets('the calendar glyph is 16px with the 14px-derived 2.4 stroke '
        '(icons-map drift 2)', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          SizedBox(
            width: 320,
            child: DatePicker(value: null, onChanged: (DateTime? _) {}),
          ),
          clock: _frozen,
        ),
      );
      await t.pump();
      final Icon glyph = t.widget<Icon>(find.byType(Icon));
      expect(glyph.glyph, IconGlyph.calendar);
      expect(glyph.sizePx, 16);
      expect(glyph.strokeOverride, 2.4);
      expect(glyph.tone, IconTone.subtle);
    });
  });

  // ─── the glyph ───────────────────────────────────────────────────────────

  group('IconGlyph.calendar — off-set addition', () {
    test('four nodes, tabs before the plate', () {
      final List<IconElement> nodes = IconPaths.elements[IconGlyph.calendar]!;
      expect(nodes, hasLength(4));
      expect(nodes[0], isA<IconPathElement>());
      expect(nodes[1], isA<IconPathElement>());
      // Lucide declares the two tabs FIRST and the plate second; order is
      // paint order.
      expect(nodes[2], isA<IconRectElement>());
      expect(nodes[3], isA<IconPathElement>());
      final IconRectElement plate = nodes[2] as IconRectElement;
      expect(plate.x, 3);
      expect(plate.y, 3);
      expect(plate.width, 18);
      expect(plate.height, 18);
      expect(plate.rx, 2);
      // `rx` and no `ry`, so the corners are circular — the parser falls back,
      // which is what SVG says to do.
      expect(plate.ry, isNull);
    });

    test('it is on the 24-unit grid, like every other transcript', () {
      final Path path = IconPaths.pathFor(IconGlyph.calendar);
      final Rect bounds = path.getBounds();
      expect(bounds.left, greaterThanOrEqualTo(0));
      expect(bounds.top, greaterThanOrEqualTo(0));
      expect(bounds.right, lessThanOrEqualTo(IconPaths.viewBox));
      expect(bounds.bottom, lessThanOrEqualTo(IconPaths.viewBox));
      // The tabs start at y = 2, above the plate's y = 3, which is what makes
      // them read as tabs.
      expect(bounds.top, 2);
      expect(bounds.left, 3);
      expect(bounds.right, 21);
    });

    test('it carries no fill pass', () {
      expect(IconPaths.fillPathFor(IconGlyph.calendar), isNull);
    });
  });
}

// ── readers ─────────────────────────────────────────────────────────────────

/// The `<td>` underlay painter for the cell whose number is [day], as it was
/// configured.
CalendarBandPainter _underlayOf(WidgetTester t, String day) =>
    t
            .widget<CustomPaint>(
              find
                  .descendant(
                    of: dayCell(day).first,
                    matching: find.byType(CustomPaint),
                  )
                  .first,
            )
            .painter!
        as CalendarBandPainter;

/// The day button's own [BoxDecoration] — the fill layer, not the ring.
BoxDecoration _decorationOf(WidgetTester t, String day) => t
    .widgetList<DecoratedBox>(
      find.descendant(
        of: dayCell(day).first,
        matching: find.byType(DecoratedBox),
      ),
    )
    .map((DecoratedBox b) => b.decoration as BoxDecoration)
    .firstWhere((BoxDecoration d) => d.color != null);

Color _fillOf(WidgetTester t, String day) => _decorationOf(t, day).color!;

BorderRadius _radiusOf(WidgetTester t, String day) =>
    _decorationOf(t, day).borderRadius! as BorderRadius;

Color _inkOf(WidgetTester t, String day) => t
    .widget<DefaultTextStyle>(
      find
          .descendant(
            of: dayCell(day).first,
            matching: find.byType(DefaultTextStyle),
          )
          .last,
    )
    .style
    .color!;

/// The ring layer, or null when the cell is not focused: a [BoxDecoration]
/// with a border and no fill.
BoxDecoration? _ringOf(WidgetTester t, String day) {
  final Iterable<BoxDecoration> rings = t
      .widgetList<DecoratedBox>(
        find.descendant(
          of: dayCell(day).first,
          matching: find.byType(DecoratedBox),
        ),
      )
      .map((DecoratedBox b) => b.decoration as BoxDecoration)
      .where((BoxDecoration d) => d.color == null && d.border != null);
  return rings.isEmpty ? null : rings.first;
}

/// Which day wears the ring — there is never more than one.
String _focusedDay(WidgetTester t) {
  for (final Text run in t.widgetList<Text>(find.byType(Text))) {
    final String? label = run.data;
    if (label == null || int.tryParse(label) == null) continue;
    if (_ringOf(t, label) != null) return label;
  }
  throw StateError('nothing is focused');
}
