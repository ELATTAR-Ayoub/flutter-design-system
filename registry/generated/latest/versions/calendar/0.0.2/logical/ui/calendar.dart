/// `components/ui/calendar.tsx` — the month grid, in three arrangements.
///
/// The reference wraps `react-day-picker` v10's `DayPicker` with 25
/// `classNames` overrides and 4 `components` overrides, and the selects page
/// mounts it three times: `mode="single"` in a Panel, `mode="range"` in a
/// Panel, and `mode="single"` inside a `Popover` behind an outline Button —
/// the last of those being *"the one shadcn documents as a recipe rather than
/// a file"*. All three are here: [Calendar] and [DatePicker].
///
/// ## Probed, not derived (ruling L3)
///
/// selects-map §8.5 computed this component's whole box from tokens and said
/// so: *"has not been seen on screen"*. Ruling L3 made a computed-style probe
/// the wave's first act. It ran on 2026-08-16 against
/// `localhost:3000/design-system/components/base/selects` at 1440×900, both
/// themes, driving real pointer and keyboard gestures. Every number below is
/// what the browser reported.
///
/// | thing | derivation | **measured** |
/// |---|---|---|
/// | intrinsic content width | 196 | **196** |
/// | cell | `--cell-size` = `space(7)` = 28 | **28 × 28** |
/// | cell radius | `--cell-radius` = `--radius-md` = 10 | **10** |
/// | weekday header row | 18.571 | **18.563** (Chrome's ¹⁄₆₄px grid) |
/// | caption row | 28 tall, 28 padding each side | **28 / 28** |
/// | Panel calendar, 5 rows | 268.571 | **268.563** |
/// | Panel calendar, 6 rows | 304.571 | **304.563** |
/// | one extra week row | 36 | **36**, exactly |
/// | Popover calendar | 212 wide, height − 8 | **212 × 294.563** |
/// | range bleed | `after:w-4` = 16 | **16 × 28**, inset **12px** from the far edge |
///
/// Three things the map did not have, and one it had wrong:
///
///  * **A month can render FOUR rows.** February 2026 begins on a Sunday and
///    has 28 days, so its grid is exactly four weeks: **232.563**. The map's
///    5-vs-6 pair is two of three cases.
///  * **The day number is 16px.** `CalendarDayButton` declares `leading-none
///    font-normal` and no `text-*` class at all, so it renders at the root
///    `1rem`. See [CalendarTextStyles.dayNumber].
///  * **A wrapped range has rounded caps at every row edge.** The `<td>`'s
///    `[&:first-child[data-selected=true]_button]:rounded-l-(--cell-radius)`
///    pair fires on range middles as well as on the ends, so a range that
///    crosses a week boundary is a rounded bar per row, not one square ribbon.
///    §8.3 lists the classes and does not say what they do.
///  * **selects-map drift 2 is half wrong for §5.** The map says the seeded
///    30 Jul 2026 selection is invisible in August. It is **not**: August 2026
///    opens with six outside days, 26–31 July, and the selection is one of
///    them — rendered at full `--primary` with `data-selected=true
///    data-outside=true`. It is invisible in most months and visible in this
///    one, which is worse than either.
///
/// ## The initial month (ruling L2)
///
/// `getInitialMonth` is `month || defaultMonth || today`, and the page passes
/// neither of the first two. [Calendar] reproduces that, resolving `today`
/// through [Clock] so the capture rig can freeze both renderers on one
/// instant. See that class for why the alternative — pinning `defaultMonth` —
/// would have the port render a month the reference does not.
///
/// ## The range band (the phase-3 painter ruling)
///
/// **Two overlapping rectangles, and never a combined path.** The band's ends
/// are a `--muted` rounded rect with a **16px square bleed** on the inner side,
/// under a `--primary` day button that fills the whole cell at a 10px radius.
/// What makes the band continuous is that the bleed squares off the two corner
/// notches the button's radius leaves — so the muted fill runs edge to edge
/// into the neighbouring middle cell while the primary end still reads as a
/// rounded chip. It is [CalendarBandPainter], and it issues at most two draw
/// calls: one `drawRRect`, one `drawRect`. No `Path.combine`, no
/// `MaskFilter` — CanvasKit and the VM raster disagree about those, which is
/// what phase 3 closed on.
library;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import '../../design_system/foundation/colors.dart';
import '../../design_system/foundation/date_format.dart';
import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';
import './button.dart';
import './icon.dart';
import './icon_paths.dart';
import './popover.dart';

// ── geometry ────────────────────────────────────────────────────────────────

/// `[--cell-size:--spacing(7)]` — **28px**, and the module this whole file is
/// measured in: the cells, the nav buttons, the caption's height and the
/// caption's horizontal padding are all one of these.
double get _cellSize => space(7);

/// `week` is `mt-2 flex w-full` — **8px** above every week row.
double get _weekGap => space(2);

/// `month` is `flex w-full flex-col gap-4` — **16px** between the caption row
/// and the grid.
double get _monthGap => space(4);

/// `after:w-4` — the range band's bleed. **16px**, half a cell.
double get _rangeBleed => space(4);

/// Seven columns of [_cellSize] — the grid's width, and the calendar's
/// intrinsic content width.
///
/// The reference computes `max(7 × cell, cell + caption + cell)`, so a caption
/// wider than 140px would win. *(Measured: it never does. "September 2026" is
/// the longest `en-US` caption at ≈103px, and a fourteen-month sweep of the
/// live calendar reported a 222px box — 196 of content — for every one of
/// them.)* The max is recorded, not built.
double get _contentWidth => _cellSize * 7;

// ── values ──────────────────────────────────────────────────────────────────

/// `mode` — the two arrangements the page renders.
///
/// `mode="multiple"` is the third the API `Meta` prints
/// (*"single | range | multiple"*) and no page mounts it; recorded, not built,
/// on the `asChild` precedent.
enum CalendarMode {
  /// `mode="single"` — §5 and §7.
  single,

  /// `mode="range"` — §6.
  range,
}

/// The surface the calendar paints itself on.
///
/// The reference has one component and three class strings; twMerge resolves
/// them to exactly these three, and each is a real site on the page.
enum CalendarPresentation {
  /// The component's own classes — `bg-background p-2`. No page mounts this
  /// bare, and it is what the other two are deltas from.
  background,

  /// §5 / §6 — `rounded-lg border border-border bg-card p-3`. twMerge takes
  /// `bg-background` → `bg-card` and `p-2` → **`p-3`**.
  card,

  /// §7 — the calendar inside a `PopoverContent`, where
  /// `in-data-[slot=popover-content]:bg-transparent` fires and `p-2` stands.
  /// No border and no radius of its own: the popover carries both.
  popover,
}

/// A `DateRange` — `react-day-picker`'s `{ from, to }`.
///
/// Both ends are calendar dates, never instants: see [CalendarDay.of].
@immutable
class DateRange {
  const DateRange({this.from, this.to});

  /// The first day, inclusive.
  final DateTime? from;

  /// The last day, inclusive. A range whose [from] is set and whose [to] is
  /// not is *incomplete* — the reference's `rangeLabel` prints
  /// **"Pick two dates"** for it.
  final DateTime? to;

  /// `range?.from && range?.to` — what the Panel note tests before it prints.
  bool get isComplete => from != null && to != null;

  /// Whether [day] falls inside the range, ends included.
  bool includes(DateTime day) {
    final DateTime? start = from;
    if (start == null) return false;
    final DateTime d = CalendarDay.of(day);
    final DateTime a = CalendarDay.of(start);
    final DateTime b = to == null ? a : CalendarDay.of(to!);
    return !d.isBefore(a) && !d.isAfter(b);
  }

  /// `modifiers.range_start`.
  bool isStart(DateTime day) =>
      from != null && CalendarDay.isSameDay(day, from!);

  /// `modifiers.range_end`.
  bool isEnd(DateTime day) => to != null && CalendarDay.isSameDay(day, to!);

  /// `modifiers.range_middle` — inside, and neither end.
  ///
  /// A one-day range is **both** ends and no middle, which is exactly what the
  /// live calendar reports for it.
  bool isMiddle(DateTime day) => includes(day) && !isStart(day) && !isEnd(day);

  /// `addToRange` — `react-day-picker/dist/cjs/utils/addToRange.js`,
  /// transcribed at the page's own arguments (`min: 0`, `max: 0`,
  /// `required: false`).
  ///
  /// It is transcribed rather than reasoned about because the branch order is
  /// not what anyone guesses, and every reachable branch was **driven on the
  /// live calendar** and matched:
  ///
  /// | from → to | click | result |
  /// |---|---|---|
  /// | *(empty)* | any | `{d, d}` — one click makes a **one-day range**, not a half-open one |
  /// | 12 Jul → 20 Jul | **20 Jul** (the `to`) | `{20, 20}` |
  /// | 20 Jul → 24 Jul | **20 Jul** (the `from`) | `{20, 20}` |
  /// | 15 Jul → 20 Jul | 10 Jul (before) | `{10, 20}` |
  /// | 10 Jul → 20 Jul | 12 Jul (inside) | `{10, 12}` |
  /// | 12 Jul → 20 Jul | 4 Aug (after) | `{12, 4 Aug}` |
  /// | d → d | **d** | `null` — the range clears |
  ///
  /// The last row is the one thing a reader would never predict from the UI:
  /// clicking the single day of a one-day range empties the selection.
  ///
  /// The source's own final `else { throw new Error("Invalid range") }` is
  /// unreachable — `isAfter(date, from)` catches everything the earlier
  /// branches do not — and is dropped rather than ported as a throw.
  static DateRange? addToRange(DateTime date, DateRange? initial) {
    final DateTime d = CalendarDay.of(date);
    final DateTime? from = initial?.from;
    final DateTime? to = initial?.to;

    if (from == null && to == null) {
      // `range = { from: date, to: min > 0 ? undefined : date }`, and min is 0.
      return DateRange(from: d, to: d);
    }
    if (from != null && to == null) {
      if (CalendarDay.isSameDay(from, d)) {
        return DateRange(from: from, to: d);
      }
      if (d.isBefore(CalendarDay.of(from))) {
        return DateRange(from: d, to: CalendarDay.of(from));
      }
      return DateRange(from: from, to: d);
    }
    // from != null && to != null
    final DateTime a = CalendarDay.of(from!);
    final DateTime b = CalendarDay.of(to!);
    if (CalendarDay.isSameDay(a, d) && CalendarDay.isSameDay(b, d)) {
      // `required` is false on this page, so the whole selection clears.
      return null;
    }
    if (CalendarDay.isSameDay(a, d)) return DateRange(from: a, to: d);
    if (CalendarDay.isSameDay(b, d)) return DateRange(from: d, to: d);
    if (d.isBefore(a)) return DateRange(from: d, to: b);
    return DateRange(from: a, to: d);
  }

  @override
  bool operator ==(Object other) =>
      other is DateRange && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(from, to);

  @override
  String toString() => 'DateRange($from → $to)';
}

/// Calendar-date arithmetic — the half of `date-fns` this component uses.
///
/// Every function here reads a [DateTime]'s **local** `year`/`month`/`day` and
/// never its instant, which is the whole subject of the page's error-toned
/// `Note`: *"`toISOString()` converts to UTC first … invisible in London,
/// wrong in New York."*
class CalendarDay {
  const CalendarDay._();

  /// `startOfDay` — the date, with the time discarded.
  static DateTime of(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// `startOfMonth`.
  static DateTime startOfMonth(DateTime date) =>
      DateTime(date.year, date.month);

  /// `isSameDay`.
  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// `isSameMonth` — what decides whether a cell is an *outside* day.
  static bool isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  /// `addDays`.
  static DateTime addDays(DateTime date, int days) =>
      DateTime(date.year, date.month, date.day + days);

  /// `addMonths`, clamping the day into the target month the way `date-fns`
  /// does — 31 Jan plus one month is 28 Feb, not 3 March.
  static DateTime addMonths(DateTime date, int months) {
    final DateTime shifted = DateTime(date.year, date.month + months);
    final int last = daysInMonth(shifted);
    return DateTime(
      shifted.year,
      shifted.month,
      date.day < last ? date.day : last,
    );
  }

  /// How many days [month] holds — day 0 of the following month.
  static int daysInMonth(DateTime month) =>
      DateTime(month.year, month.month + 1, 0).day;
}

/// One month's grid, as arithmetic — the part of this component that has an
/// answer before anything is painted.
@immutable
class CalendarMonth {
  CalendarMonth(DateTime month) : month = CalendarDay.startOfMonth(month);

  /// The first of the month.
  final DateTime month;

  /// How many days of the **previous** month lead the grid.
  ///
  /// `weekStartsOn` is Sunday for the default `enUS` locale, so this is the
  /// first-of-month's Sunday-first column index: 0 for a month that begins on
  /// a Sunday, 6 for one that begins on a Saturday.
  int get leadingDays => DateFormat.weekIndex(month);

  /// How many days the month itself holds.
  int get dayCount => CalendarDay.daysInMonth(month);

  /// How many week rows the grid needs.
  ///
  /// `showOutsideDays` is on and `fixedWeeks` is off, so the grid is exactly
  /// as tall as the month needs — **four, five or six rows**, and the whole
  /// calendar's height moves 36px with each. *(Measured across a
  /// twenty-two-month sweep of the live calendar: Feb 2026 → 4, Jul 2026 → 5,
  /// Aug 2026 → 6.)*
  int get weekCount => ((leadingDays + dayCount) / 7).ceil();

  /// Every cell, in reading order: `weekCount × 7` days, leading and trailing
  /// outside days included.
  List<DateTime> get days {
    final DateTime first = CalendarDay.addDays(month, -leadingDays);
    return <DateTime>[
      for (int i = 0; i < weekCount * 7; i++) CalendarDay.addDays(first, i),
    ];
  }

  /// The grid's own height: the weekday header, then a row and its 8px gap
  /// per week.
  ///
  /// [weekdayRowHeight] is the header's line box, which only a laid-out
  /// paragraph knows — [TextStyles.small] at 13px over 1.428571, or
  /// **18.5714**. *(Chrome renders 18.563 on its ¹⁄₆₄px grid.)*
  double gridHeight(double weekdayRowHeight) =>
      weekdayRowHeight + weekCount * (_weekGap + _cellSize);

  /// The whole calendar's outer height, padding and border included — the
  /// number the vertical-parity probe is pinned against.
  ///
  /// `caption (28) + gap (16) + header + rows × 36 + 2 × padding + 2 × border`.
  double outerHeight(double weekdayRowHeight, CalendarPresentation surface) =>
      _cellSize +
      _monthGap +
      gridHeight(weekdayRowHeight) +
      2 * paddingFor(surface) +
      2 * borderWidthFor(surface);

  /// `p-3` on a Panel calendar, `p-2` everywhere else.
  static double paddingFor(CalendarPresentation surface) =>
      surface == CalendarPresentation.card ? space(3) : space(2);

  /// Only the Panel calendar draws one.
  static double borderWidthFor(CalendarPresentation surface) =>
      surface == CalendarPresentation.card ? BorderWidths.hairline : 0;

  @override
  bool operator ==(Object other) =>
      other is CalendarMonth && other.month == month;

  @override
  int get hashCode => month.hashCode;
}

// ── the calendar ────────────────────────────────────────────────────────────

/// A month grid.
///
/// Use [Calendar.single] or [Calendar.range]; the two differ only in what
/// they hold and what they report.
class Calendar extends StatefulWidget {
  /// `mode="single"` — §5's Panel specimen and §7's popover.
  const Calendar.single({
    super.key,
    DateTime? selected,
    ValueChanged<DateTime?>? onSelected,
    this.month,
    this.defaultMonth,
    this.onMonthChanged,
    this.surface = CalendarPresentation.card,
    this.autoFocus = false,
  }) : mode = CalendarMode.single,
       selectedDay = selected,
       onDaySelected = onSelected,
       selectedRange = null,
       onRangeSelected = null;

  /// `mode="range" numberOfMonths={1}` — §6's Panel specimen.
  ///
  /// `numberOfMonths` is 1 here and 1 in the reference; the `months` container
  /// is `md:flex-row`, so a second month would sit beside the first. Nothing
  /// on the page asks for one.
  const Calendar.range({
    super.key,
    DateRange? selected,
    ValueChanged<DateRange?>? onSelected,
    this.month,
    this.defaultMonth,
    this.onMonthChanged,
    this.surface = CalendarPresentation.card,
    this.autoFocus = false,
  }) : mode = CalendarMode.range,
       selectedRange = selected,
       onRangeSelected = onSelected,
       selectedDay = null,
       onDaySelected = null;

  final CalendarMode mode;

  /// `selected` in single mode.
  final DateTime? selectedDay;

  /// `onSelect` in single mode. Null leaves the grid read-only.
  final ValueChanged<DateTime?>? onDaySelected;

  /// `selected` in range mode.
  final DateRange? selectedRange;

  /// `onSelect` in range mode, already run through [DateRange.addToRange].
  final ValueChanged<DateRange?>? onRangeSelected;

  /// `month` — a controlled displayed month. **The page passes none.**
  final DateTime? month;

  /// `defaultMonth` — the uncontrolled seed. **The page passes none**, which
  /// is what makes [Clock] load-bearing (ruling L2).
  final DateTime? defaultMonth;

  /// `onMonthChange`.
  final ValueChanged<DateTime>? onMonthChanged;

  /// Which of the three class strings this instance wears.
  final CalendarPresentation surface;

  /// `autoFocus` — §7's calendar carries it, *"so the keyboard lands on the
  /// grid rather than behind it"*.
  final bool autoFocus;

  /// `--cell-size`, for a caller that has to line something up with the grid.
  static double get cellSize => _cellSize;

  /// The grid's width, and the calendar's intrinsic content width: **196**.
  static double get contentWidth => _contentWidth;

  /// `after:w-4` — the range band's bleed, **16**.
  static double get rangeBleed => _rangeBleed;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  /// The displayed month. Null until [didChangeDependencies] resolves
  /// `getInitialMonth`, which needs the [Clock] and therefore an inherited
  /// lookup that `initState` may not make.
  DateTime? _month;

  /// `modifiers.focused` — the day the arrow keys move, and the only cell that
  /// wears the ring.
  ///
  /// One [FocusNode] for the whole grid rather than 42 of them. The reference
  /// gives each button real DOM focus through a roving `tabIndex`; what a
  /// reader sees is a ring that moves, and this produces the identical ring at
  /// a fraction of the tree.
  DateTime? _focusedDay;

  late final FocusNode _focus = FocusNode(debugLabel: 'Calendar');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // `getInitialMonth`: `month || defaultMonth || today`, then
    // `startOfMonth`. Read once — a later tick of the clock does not drag a
    // reader off the month they navigated to, exactly as `defaultMonth` does
    // not.
    _month ??= CalendarDay.startOfMonth(
      widget.month ?? widget.defaultMonth ?? Clock.nowOf(context),
    );
  }

  @override
  void didUpdateWidget(Calendar old) {
    super.didUpdateWidget(old);
    final DateTime? controlled = widget.month;
    if (controlled != null && controlled != old.month) {
      _month = CalendarDay.startOfMonth(controlled);
    }
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  DateTime get _displayed => _month ?? CalendarDay.startOfMonth(DateTime.now());

  void _goToMonth(DateTime month) {
    final DateTime next = CalendarDay.startOfMonth(month);
    if (next == _displayed) return;
    setState(() => _month = next);
    widget.onMonthChanged?.call(next);
  }

  void _select(DateTime day) {
    final DateTime d = CalendarDay.of(day);
    setState(() => _focusedDay = d);
    // A day in an outside week belongs to a neighbouring month, and clicking
    // one does NOT navigate: the reference leaves the caption where it is and
    // paints the selection on the outside cell.
    switch (widget.mode) {
      case CalendarMode.single:
        final ValueChanged<DateTime?>? onSelected = widget.onDaySelected;
        if (onSelected == null) return;
        // `mode="single"` without `required` toggles: re-picking the selected
        // day clears it.
        final DateTime? current = widget.selectedDay;
        onSelected(
          current != null && CalendarDay.isSameDay(current, d) ? null : d,
        );
      case CalendarMode.range:
        final ValueChanged<DateRange?>? onSelected = widget.onRangeSelected;
        if (onSelected == null) return;
        onSelected(DateRange.addToRange(d, widget.selectedRange));
    }
  }

  /// The keyboard, as the live grid answered it.
  ///
  /// *(Driven on the reference: ← → move a day, ↑ ↓ move a week, Home and End
  /// go to the Sunday and the Saturday of the focused week, PageUp/PageDown
  /// move a month at the same day-of-month, and stepping past the edge of the
  /// displayed month **navigates** — forty ArrowRights carried the caption
  /// from September to October.)*
  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final DateTime anchor = _focusedDay ?? _defaultFocus();
    DateTime? next;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        next = CalendarDay.addDays(anchor, -1);
      case LogicalKeyboardKey.arrowRight:
        next = CalendarDay.addDays(anchor, 1);
      case LogicalKeyboardKey.arrowUp:
        next = CalendarDay.addDays(anchor, -7);
      case LogicalKeyboardKey.arrowDown:
        next = CalendarDay.addDays(anchor, 7);
      case LogicalKeyboardKey.home:
        next = CalendarDay.addDays(anchor, -DateFormat.weekIndex(anchor));
      case LogicalKeyboardKey.end:
        next = CalendarDay.addDays(anchor, 6 - DateFormat.weekIndex(anchor));
      case LogicalKeyboardKey.pageUp:
        next = CalendarDay.addMonths(anchor, -1);
      case LogicalKeyboardKey.pageDown:
        next = CalendarDay.addMonths(anchor, 1);
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.numpadEnter:
      case LogicalKeyboardKey.space:
        _select(anchor);
        return KeyEventResult.handled;
    }
    if (next == null) return KeyEventResult.ignored;
    setState(() => _focusedDay = next);
    if (!CalendarDay.isSameMonth(next, _displayed)) _goToMonth(next);
    return KeyEventResult.handled;
  }

  /// Where the focus lands when the grid takes it with nothing focused yet —
  /// the selection if it is on screen, otherwise the first of the month.
  DateTime _defaultFocus() {
    final DateTime? day = switch (widget.mode) {
      CalendarMode.single => widget.selectedDay,
      CalendarMode.range => widget.selectedRange?.from,
    };
    if (day != null && CalendarDay.isSameMonth(day, _displayed)) {
      return CalendarDay.of(day);
    }
    return _displayed;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final CalendarMonth grid = CalendarMonth(_displayed);
    final DateTime today = CalendarDay.of(Clock.nowOf(context));
    final List<DateTime> days = grid.days;

    final TextStyle weekdayStyle = StyledText.styleOf(
      context,
      TextStyles.small,
      color: theme.mutedForeground,
    );

    final Widget month = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _Caption(
          month: _displayed,
          onPrevious: () => _goToMonth(CalendarDay.addMonths(_displayed, -1)),
          onNext: () => _goToMonth(CalendarDay.addMonths(_displayed, 1)),
        ),
        SizedBox(height: _monthGap),
        _WeekdayRow(style: weekdayStyle),
        for (int week = 0; week < grid.weekCount; week++)
          Padding(
            // `week` is `mt-2` — the gap is above every row, header included.
            padding: EdgeInsets.only(top: _weekGap),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (int column = 0; column < 7; column++)
                  _dayCell(days[week * 7 + column], column, today),
              ],
            ),
          ),
      ],
    );

    return _CalendarSurface(
      surface: widget.surface,
      child: Focus(
        focusNode: _focus,
        autofocus: widget.autoFocus,
        onKeyEvent: _onKey,
        child: SizedBox(width: _contentWidth, child: month),
      ),
    );
  }

  Widget _dayCell(DateTime day, int column, DateTime today) {
    final DateRange? range = widget.mode == CalendarMode.range
        ? widget.selectedRange
        : null;
    final bool selectedSingle =
        widget.mode == CalendarMode.single &&
        widget.selectedDay != null &&
        CalendarDay.isSameDay(day, widget.selectedDay!);

    return _DayCell(
      day: day,
      column: column,
      outside: !CalendarDay.isSameMonth(day, _displayed),
      today: CalendarDay.isSameDay(day, today),
      selectedSingle: selectedSingle,
      rangeStart: range?.isStart(day) ?? false,
      rangeEnd: range?.isEnd(day) ?? false,
      rangeMiddle: range?.isMiddle(day) ?? false,
      focused:
          _focusedDay != null &&
          CalendarDay.isSameDay(day, _focusedDay!) &&
          _focus.hasFocus,
      onPressed: () {
        _focus.requestFocus();
        _select(day);
      },
    );
  }
}

/// `root` — `bg-* p-* [rounded-lg border border-border]`.
class _CalendarSurface extends StatelessWidget {
  const _CalendarSurface({required this.surface, required this.child});

  final CalendarPresentation surface;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Color fill = switch (surface) {
      CalendarPresentation.background => theme.background,
      CalendarPresentation.card => theme.card,
      CalendarPresentation.popover => transparent,
    };
    final bool bordered = surface == CalendarPresentation.card;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        border: bordered
            ? Border.all(color: theme.border, width: BorderWidths.hairline)
            : null,
        borderRadius: bordered
            ? BorderRadius.circular(Radii.lg)
            : BorderRadius.zero,
      ),
      child: Padding(
        // `box-sizing: border-box` — the border is inside the outer box, and a
        // [DecoratedBox] paints one without reserving room for it, so the
        // padding carries both. 196 + 2 × 12 + 2 × 1 = **222** *(measured)*.
        padding: EdgeInsets.all(
          CalendarMonth.paddingFor(surface) +
              CalendarMonth.borderWidthFor(surface),
        ),
        child: child,
      ),
    );
  }
}

/// `month_caption` with `nav` laid over it.
///
/// `nav` is `absolute inset-x-0 top-0 flex w-full items-center justify-between`
/// and `month_caption` is `flex h-(--cell-size) w-full items-center
/// justify-center px-(--cell-size)` — so the two buttons sit exactly in the
/// 28px gutters the caption's padding reserves for them, and the label is
/// centred in what is left.
class _Caption extends StatelessWidget {
  const _Caption({
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _cellSize,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _cellSize),
              child: Center(
                // `caption_label` — `font-medium select-none text-sm`,
                // *(measured 13px / 18.5714 / 500)*, which is exactly
                // [TextStyles.nav].
                child: StyledText(
                  DateFormat.monthYear(month),
                  TextStyles.nav,
                  maxLines: 1,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _NavButton(
                  glyph: IconGlyph.chevronLeft,
                  label: 'Go to the previous month',
                  onPressed: onPrevious,
                ),
                _NavButton(
                  glyph: IconGlyph.chevronRight,
                  label: 'Go to the next month',
                  onPressed: onNext,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `weekdays` / `weekday` — `flex` over seven `flex-1 … text-sm font-normal
/// text-muted-foreground` cells.
///
/// The row's height is the paragraph's own line box, **18.5714**, which is why
/// it goes through [StyledText] rather than a [SizedBox]: `LineBox` is what
/// gives a Flutter paragraph the height CSS gives it.
class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow({required this.style});

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int column = 0; column < 7; column++)
          SizedBox(
            width: _cellSize,
            child: Center(
              child: StyledText(
                DateFormat.weekdayNarrow(column),
                TextStyles.small,
                color: style.color,
              ),
            ),
          ),
      ],
    );
  }
}

/// `button_previous` / `button_next` — a ghost Button at
/// `size-(--cell-size) p-0`.
///
/// Not a [Button]: the size ladder's four squares are 24 / 32 / 40 / 48 and
/// this one is 28, which is `--cell-size` and not a rung. It wears the ghost
/// variant's own state table ([_ghostFill] / [_ghostInk]) and `btn-spring`,
/// which is what the class list asks for.
class _NavButton extends StatefulWidget {
  const _NavButton({
    required this.glyph,
    required this.label,
    required this.onPressed,
  });

  final IconGlyph glyph;
  final String label;
  final VoidCallback onPressed;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    // `size-(--cell-size) p-0` — a 28px square, which is neither of the four
    // `ButtonSize` squares (24 / 32 / 40 / 48).
    return SizedBox(
      width: _cellSize,
      height: _cellSize,
      child: _PressableCell(
        onPressed: widget.onPressed,
        onHover: (bool value) => setState(() => _hovered = value),
        onPress: (bool value) => setState(() => _pressed = value),
        onFocus: (bool value) => setState(() => _focused = value),
        pressed: _pressed,
        label: widget.label,
        child: _CellSurface(
          fill: _ghostFill(theme, hovered: _hovered, pressed: _pressed),
          ink: _ghostInk(theme, hovered: _hovered),
          radius: BorderRadius.circular(Radii.full),
          focused: _focused,
          pressed: _pressed,
          child: Center(
            child: Icon(
              widget.glyph,
              // `Chevron` is rendered at an explicit `size-4`
              // (`calendar.tsx:154–170`), so it takes `md`'s 16px and 2.0
              // stroke rather than the ladder's `sm`.
              size: IconSize.md,
              tone: IconTone.inherit,
            ),
          ),
        ),
      ),
    );
  }
}

/// `ghost`'s fill: nothing at rest, `--secondary` on hover, `--muted` while
/// active.
///
/// Tailwind orders `active` after `hover`, so a press outranks the hover it
/// implies — the same reading `Button._skin` documents.
Color _ghostFill(
  ThemeTokens theme, {
  required bool hovered,
  required bool pressed,
}) {
  if (pressed) return theme.muted;
  if (hovered) return theme.secondary;
  return transparent;
}

/// `ghost`'s ink: `text-muted-foreground`, `hover:text-foreground`.
Color _ghostInk(ThemeTokens theme, {required bool hovered}) =>
    hovered ? theme.foreground : theme.mutedForeground;

// ── the day cell ────────────────────────────────────────────────────────────

/// One `<td class="group/day …">` and the `CalendarDayButton` inside it.
///
/// The two are genuinely two layers and the range band depends on it: the
/// `<td>` paints `--muted`, the button paints `--primary` over it, and what
/// shows between them is the band. selects-map drift 25 is about the same
/// split — *"the calendar disagrees with itself about cell shape"* — because
/// `today` rounds the `<td>` to 10px while the button inside it is a pill.
class _DayCell extends StatefulWidget {
  const _DayCell({
    required this.day,
    required this.column,
    required this.outside,
    required this.today,
    required this.selectedSingle,
    required this.rangeStart,
    required this.rangeEnd,
    required this.rangeMiddle,
    required this.focused,
    required this.onPressed,
  });

  final DateTime day;

  /// 0–6, Sunday first. Only the two edges matter, and only because of the
  /// `<td>`'s first-child / last-child rules.
  final int column;

  /// `modifiers.outside` — a day from a neighbouring month.
  ///
  /// **It paints nothing.** The `outside` className is
  /// `text-muted-foreground aria-selected:text-muted-foreground` on the
  /// `<td>`, and the button inside declares its own `text-muted-foreground`,
  /// so an outside day and an in-month day are byte-identical at rest
  /// *(measured in both themes)*. Carried as a flag because it is a real
  /// modifier and a reader will look for it.
  final bool outside;

  final bool today;
  final bool selectedSingle;
  final bool rangeStart;
  final bool rangeEnd;
  final bool rangeMiddle;

  /// `modifiers.focused` — this cell wears the ring.
  final bool focused;

  final VoidCallback onPressed;

  /// `data-selected` on the `<td>` — what the first-child / last-child radius
  /// rules are gated on.
  bool get tdSelected =>
      selectedSingle || rangeStart || rangeEnd || rangeMiddle;

  @override
  State<_DayCell> createState() => _DayCellState();
}

class _DayCellState extends State<_DayCell> {
  bool _hovered = false;
  bool _pressed = false;

  /// `data-[selected-single=true]:bg-primary`,
  /// `data-[range-start=true]:bg-primary`, `data-[range-end=true]:bg-primary`,
  /// `data-[range-middle=true]:bg-muted` — and the ghost table underneath.
  ///
  /// **The data-state fills outrank hover.** Tailwind v4 sorts `data-[…]`
  /// variants after the pseudo-class ones, and the live calendar agrees:
  /// hovering a range end leaves it `--primary` rather than turning it
  /// `--secondary`.
  Color _fill(ThemeTokens theme) {
    if (widget.selectedSingle || widget.rangeStart || widget.rangeEnd) {
      return theme.primary;
    }
    if (widget.rangeMiddle) return theme.muted;
    return _ghostFill(theme, hovered: _hovered, pressed: _pressed);
  }

  Color _ink(ThemeTokens theme) {
    if (widget.selectedSingle || widget.rangeStart || widget.rangeEnd) {
      return theme.primaryForeground;
    }
    if (widget.rangeMiddle) return theme.foreground;
    return _ghostInk(theme, hovered: _hovered);
  }

  /// The button's corners.
  ///
  /// `rounded-pill` at rest; the three range states declare
  /// `rounded-(--cell-radius)` variants that twMerge keeps in their own group
  /// keys, so they replace the pill outright. On top of that the `<td>`'s
  /// `[&:first-child[data-selected=true]_button]:rounded-l-(--cell-radius)`
  /// and its `last-child` twin fire wherever a **selected** cell sits at the
  /// edge of a week — which is what caps a wrapped range's rows *(measured:
  /// 18 Jul renders `0 10 10 0` and 19 Jul renders `10 0 0 10`)*.
  BorderRadius _radius() {
    final Radius pill = Radius.circular(Radii.full);
    final Radius cell = Radius.circular(Radii.md);
    Radius topLeft;
    Radius topRight;
    Radius bottomRight;
    Radius bottomLeft;
    if (widget.rangeMiddle) {
      topLeft = topRight = bottomRight = bottomLeft = Radius.zero;
    } else if (widget.rangeStart || widget.rangeEnd) {
      topLeft = topRight = bottomRight = bottomLeft = cell;
    } else {
      topLeft = topRight = bottomRight = bottomLeft = pill;
    }
    if (widget.tdSelected && widget.column == 0) {
      topLeft = bottomLeft = cell;
    }
    if (widget.tdSelected && widget.column == 6) {
      topRight = bottomRight = cell;
    }
    return BorderRadius.only(
      topLeft: topLeft,
      topRight: topRight,
      bottomRight: bottomRight,
      bottomLeft: bottomLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return SizedBox(
      width: _cellSize,
      height: _cellSize,
      child: Stack(
        children: <Widget>[
          // The `<td>`'s own paint — `today`'s square and the range band's
          // two rectangles. Nothing at all in the common case.
          Positioned.fill(
            child: CustomPaint(
              painter: CalendarBandPainter(
                muted: theme.muted,
                today: widget.today,
                selected: widget.tdSelected,
                rangeStart: widget.rangeStart,
                rangeEnd: widget.rangeEnd,
                radius: Radii.md,
                bleed: _rangeBleed,
              ),
            ),
          ),
          Positioned.fill(
            child: _PressableCell(
              onPressed: widget.onPressed,
              onHover: (bool value) => setState(() => _hovered = value),
              onPress: (bool value) => setState(() => _pressed = value),
              pressed: _pressed,
              label: DateFormat.dayLabel(widget.day),
              child: _CellSurface(
                fill: _fill(theme),
                ink: _ink(theme),
                radius: _radius(),
                focused: widget.focused,
                pressed: widget.focused,
                child: Center(
                  child: StyledText(
                    '${widget.day.day}',
                    CalendarTextStyles.dayNumber,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The `<td>`'s background: at most one rounded rect and one square.
///
/// | state | draws |
/// |---|---|
/// | `today`, unselected | `--muted` rrect at 10px |
/// | `today`, selected | `--muted` rect — `data-[selected=true]:rounded-none` |
/// | `range_start` | `--muted` rrect at 10px, then a 16px square against the **right** edge |
/// | `range_end` | the same rrect, then the square against the **left** edge |
/// | one-day range | both classes land on one `<td>`, so `after:left-0` and `after:right-0` both apply with `w-4`; CSS drops the over-constrained `right` in LTR and the square goes **left** *(measured)* |
/// | anything else | nothing |
///
/// Two draw calls, maximum, and never a combined path — the phase-3 painter
/// ruling. The shape a reader sees is the *composite* of this and the day
/// button on top of it: the square fills the two corner notches the button's
/// 10px radius leaves on the band's inner side, which is the whole trick that
/// makes the band continuous.
///
/// Public, and the only private-by-rights part of this file that is not: the
/// painter ruling asks for rendered-pixel pins **and** a statement of what the
/// painter was configured with, and a test cannot read a private class's
/// fields. Nothing outside this file constructs one.
class CalendarBandPainter extends CustomPainter {
  const CalendarBandPainter({
    required this.muted,
    required this.today,
    required this.selected,
    required this.rangeStart,
    required this.rangeEnd,
    required this.radius,
    required this.bleed,
  });

  final Color muted;
  final bool today;
  final bool selected;
  final bool rangeStart;
  final bool rangeEnd;
  final double radius;
  final double bleed;

  bool get _paints => today || rangeStart || rangeEnd;

  @override
  void paint(Canvas canvas, Size size) {
    if (!_paints) return;
    final Rect cell = Offset.zero & size;
    final Paint paint = Paint()..color = muted;

    // `today` alone rounds to `--cell-radius` and squares off the moment the
    // cell is also selected; a range end is always rounded.
    final bool square = today && selected && !rangeStart && !rangeEnd;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        cell,
        square ? Radius.zero : Radius.circular(radius),
      ),
      paint,
    );

    if (!rangeStart && !rangeEnd) return;
    // `after:left-0` wins over `after:right-0` when a one-day range puts both
    // on the same element, so the end's square is checked first.
    final Rect square16 = rangeEnd
        ? Rect.fromLTWH(0, 0, bleed, size.height)
        : Rect.fromLTWH(size.width - bleed, 0, bleed, size.height);
    canvas.drawRect(square16, paint);
  }

  @override
  bool shouldRepaint(CalendarBandPainter old) =>
      old.muted != muted ||
      old.today != today ||
      old.selected != selected ||
      old.rangeStart != rangeStart ||
      old.rangeEnd != rangeEnd ||
      old.radius != radius ||
      old.bleed != bleed;
}

/// Pointer, keyboard and focus for one 28px cell.
class _PressableCell extends StatelessWidget {
  const _PressableCell({
    required this.onPressed,
    required this.onHover,
    required this.onPress,
    this.onFocus,
    required this.pressed,
    required this.label,
    required this.child,
  });

  final VoidCallback onPressed;
  final ValueChanged<bool> onHover;
  final ValueChanged<bool> onPress;
  final ValueChanged<bool>? onFocus;
  final bool pressed;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget content = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHover(true),
      onExit: (_) {
        onHover(false);
        onPress(false);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => onPress(true),
        onTapUp: (_) => onPress(false),
        onTapCancel: () => onPress(false),
        onTap: onPressed,
        // `active:not-aria-[haspopup]:scale-95`, and it does **not** animate —
        // the flag is the frame, exactly as `Button` records under B1.
        child: Transform.scale(
          scale: pressed ? MotionTransforms.buttonPress : 1,
          child: child,
        ),
      ),
    );
    final ValueChanged<bool>? focus = onFocus;
    if (focus != null) {
      content = Focus(
        onFocusChange: focus,
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event is! KeyDownEvent) return KeyEventResult.ignored;
          final bool activates =
              event.logicalKey == LogicalKeyboardKey.enter ||
              event.logicalKey == LogicalKeyboardKey.numpadEnter ||
              event.logicalKey == LogicalKeyboardKey.space;
          if (!activates) return KeyEventResult.ignored;
          onPressed();
          return KeyEventResult.handled;
        },
        child: content,
      );
    }
    return Semantics(button: true, label: label, child: content);
  }
}

/// The fill, the ink and the ring, on `btn-spring`'s clock.
///
/// `btn-spring` transitions `background-color` and `color` over
/// `--duration-base` on `--ease-spring`, dropping to `--duration-tick` while
/// active. The spring overshoots, and the colour overshoots with it — *(the
/// rAF trace of a day hover in light runs the fill past `--secondary` to
/// `#ffffff` at Δ193 and settles back to `#f4f4f5` by Δ327)*. A [ColorTween]
/// on [MotionCurves.emphasized] reproduces that for free, which is why this mirrors
/// `Button`'s own `_SpringColors` rather than snapping.
class _CellSurface extends StatelessWidget {
  const _CellSurface({
    required this.fill,
    required this.ink,
    required this.radius,
    required this.focused,
    required this.pressed,
    required this.child,
  });

  final Color fill;
  final Color ink;
  final BorderRadius radius;

  /// `group-data-[focused=true]/day:ring-3
  /// group-data-[focused=true]/day:ring-ring/50` — a 3px `--ring` @ 50% ring
  /// and nothing else. The companion `:border-ring` sets a colour on a border
  /// the same class list has already zeroed with `border-0`, so it never
  /// paints; recorded, not built.
  final bool focused;

  final bool pressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Duration duration = effectiveMotionDuration(
      context,
      pressed ? MotionDurations.tick : MotionDurations.normal,
    );
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: fill),
      duration: duration,
      curve: MotionCurves.emphasized,
      builder: (BuildContext context, Color? animatedFill, Widget? _) =>
          TweenAnimationBuilder<Color?>(
            tween: ColorTween(end: ink),
            duration: duration,
            curve: MotionCurves.emphasized,
            builder: (BuildContext context, Color? animatedInk, Widget? _) {
              final Widget surface = DecoratedBox(
                decoration: BoxDecoration(
                  color: animatedFill ?? fill,
                  borderRadius: radius,
                ),
                child: DefaultTextStyle.merge(
                  style: TextStyle(color: animatedInk ?? ink),
                  child: IconTheme.merge(
                    data: IconThemeData(color: animatedInk ?? ink),
                    child: child,
                  ),
                ),
              );
              if (!focused) return surface;
              return DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  border: Border.all(
                    color: theme.ring.withValues(alpha: _ringAlpha),
                    width: _ringSpread,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
                child: surface,
              );
            },
          ),
    );
  }
}

/// `ring-3` — a `0 0 0 3px` ring, drawn outside the box.
const double _ringSpread = 3;

/// `ring-ring/50`.
const double _ringAlpha = 0.50;

// ── the date picker ─────────────────────────────────────────────────────────

/// §7 — *"A Calendar inside a Popover, behind a trigger that shows the current
/// value."*
///
/// **The reference has no `DatePicker` file**, and its own section description
/// says so: it is *"the one shadcn documents as a recipe rather than a file"*,
/// and the API `Meta` says only *"Pair with Popover for a date picker"*. This
/// widget is that recipe, packaged — three parts and no invention:
///
///  * an outline [Button] trigger, `justify-start`, with a 16px calendar
///    glyph and a label that **swaps typeface with state**;
///  * a [Popover] at `side: bottom`, `align: start`, `sideOffset: space(1)`
///    *(measured: the live popup lands 4px under the trigger with its left
///    edges flush)*;
///  * a [Calendar] on [CalendarPresentation.popover], carrying `autoFocus`.
///
/// The label swap is the whole demo (§10.1): picked renders `.type-num` —
/// *(measured 15px / 18 / 600, Geist Mono, −0.15px tracking)* — and empty
/// inherits the Button's own 13px / 500 sans. A word is not a value.
///
/// selects-map drift 20 is reproduced by construction: `PopoverTrigger` stamps
/// `aria-haspopup="dialog"`, which cancels the Button's
/// `active:not-aria-[haspopup]:scale-95`, so **this is the one Button on the
/// page that does not squish**. The trigger passes
/// [Button.suppressPressScale] for it, and [Button.expanded] for the
/// `aria-expanded:bg-muted` beside it — see [_pressScaleSuppressed].
class DatePicker extends StatefulWidget {
  const DatePicker({
    super.key,
    required this.value,
    this.onChanged,
    this.placeholder = 'Pick a date',
    this.focusNode,
    this.label,
  });

  /// The picked date, or null for the empty state.
  final DateTime? value;

  /// Null disables the trigger — §7's second Field, *"Locked to the tax
  /// year"*, is exactly this.
  final ValueChanged<DateTime?>? onChanged;

  /// The empty label. **"Pick a date"** on the page.
  final String placeholder;

  final FocusNode? focusNode;

  /// The accessible name, when the visible label is a value rather than a
  /// description.
  final String? label;

  /// Drift 20, named so a reader can find it: the trigger's press scale is
  /// suppressed by `aria-haspopup`, and its disabled twin beside it — same
  /// variant, same classes, no popover — would squish if it were not disabled.
  static const bool _pressScaleSuppressed = true;

  /// Whether the press scale is suppressed on this control. Always true; it
  /// exists so the drift is assertable, and the trigger holds up its end by
  /// passing [Button.suppressPressScale].
  static bool get pressScaleSuppressed => _pressScaleSuppressed;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  bool _open = false;

  void _close() {
    if (!_open) return;
    setState(() => _open = false);
  }

  @override
  Widget build(BuildContext context) {
    final DateTime? value = widget.value;
    final bool enabled = widget.onChanged != null;

    final Widget trigger = Button(
      variant: ButtonVariant.outline,
      focusNode: widget.focusNode,
      label: widget.label,
      // Drift 20 itself: `PopoverTrigger`'s `aria-haspopup="dialog"` cancels
      // `active:not-aria-[haspopup]:scale-95`, and `aria-expanded:bg-muted`
      // holds the hover fill for as long as the calendar is open. See
      // [DatePicker._pressScaleSuppressed].
      suppressPressScale: true,
      expanded: _open && enabled,
      onPressed: enabled ? () => setState(() => _open = !_open) : null,
      // `justify-start` beats the base `justify-center` through twMerge. A
      // `Row` at `MainAxisSize.max` inside the Button's shrink-wrapping
      // `Center` takes the full padded width and starts its children at the
      // leading edge, which is what that class means.
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            IconGlyph.calendar,
            // `Icon Calendar size="sm" tone="subtle"` — and the Button's
            // `[&_svg:not([class*='size-'])]:size-4` forces the box to 16
            // while `strokeWidth` stays at the 14px-derived 2.4
            // (icons-map drift 2). `sizePx` is that override.
            sizePx: Button.iconPxFor(ButtonSize.md),
            strokeOverride: Icon.strokeFor(Icon.pxFor(IconSize.sm)),
            tone: IconTone.subtle,
          ),
          SizedBox(width: Button.gapFor(ButtonSize.md)),
          if (value == null)
            StyledText(widget.placeholder, TextStyles.nav)
          else
            StyledText(DateFormat.dayMonthYear(value), TextStyles.numberBase),
        ],
      ),
    );

    return Popover(
      open: _open && enabled,
      side: PopoverSide.bottom,
      align: PopoverAlign.start,
      // `sideOffset={4}` — one spacing unit.
      sideOffset: space(1),
      onDismiss: _close,
      anchor: trigger,
      content: (BuildContext context, PopoverAnchorMetrics metrics) =>
          // `PopoverContent className="w-auto p-0"` — content-sized, no
          // padding of its own, and the calendar inside goes transparent.
          PopoverSurface(
            child: Calendar.single(
              selected: value,
              autoFocus: true,
              surface: CalendarPresentation.popover,
              onSelected: (DateTime? day) {
                widget.onChanged?.call(day);
                _close();
              },
            ),
          ),
    );
  }
}
