/// Dates as a foundation — how one is written, and what "now" is.
///
/// Supervisor ruling **L10**: the selects page needs `format(d, "d MMM")`,
/// `format(d, "d MMM yyyy")`, a month-year caption and `cccccc` weekday
/// abbreviations, all `en-US`, and the port takes no dependencies. `intl`
/// would drag the whole of ICU in for **twelve strings**. So the locale data
/// lands here, beside the tokens, as three const lists and one ordinal rule.
///
/// Everything below is `date-fns` v4's `enUS` locale as
/// `react-day-picker` v10 consumes it:
///
/// | reference call | here |
/// |---|---|
/// | `format(d, "d MMM")` (page:83–84, the Panel note) | [DsDateFormat.dayMonth] |
/// | `format(d, "d MMM yyyy")` (page:352, the trigger label) | [DsDateFormat.dayMonthYear] |
/// | `DateLib.formatMonthYear` → `LLLL yyyy` (`DateLib.js:521`) | [DsDateFormat.monthYear] |
/// | `formatWeekdayName` → `format(d, "cccccc")` | [DsDateFormat.weekdayNarrow] |
/// | `calendarDayKey` → `YYYY-MM-DD` (`calendar.tsx:15–20`) | [DsDateFormat.dayKey] |
/// | `labelDayButton` → `EEEE, MMMM do, yyyy` | [DsDateFormat.dayLabel] |
///
/// The page's own §7 `Note` is about exactly this file's reason to exist:
/// *"`toISOString()` converts to UTC first … It is invisible in London, wrong
/// in New York."* Every function here reads the [DateTime]'s **local**
/// calendar fields — `.year`, `.month`, `.day` — and never its instant.
///
/// Two more things live here, and both are here rather than in a file of their
/// own because they are foundation facts the calendar cannot be built without:
///
///  * [DsClock] — the app's "now", injectable. Ruling **L2**.
///  * [DsCalendarType] — the one resolved type rung the calendar needs that
///    `typography.dart` has no declaration for.
library;

import 'package:flutter/widgets.dart';

import 'typography.dart';

/// `en-US` date strings, without `intl`.
///
/// A holder, never instantiated — the same shape [DsRadii] and [DsFonts] take.
class DsDateFormat {
  const DsDateFormat._();

  /// `MMM` — `date-fns` `enUS.localize.month(i, {width: 'abbreviated'})`.
  ///
  /// Indexed from **zero**, the way `date-fns` indexes months; [DateTime.month]
  /// is one-based, so every read below subtracts one. Twelve strings — the
  /// twelve ruling L10 weighed a dependency against.
  static const List<String> monthsShort = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// `MMMM` / `LLLL` — `{width: 'wide'}`. The caption's own strings.
  ///
  /// `MMMM` (formatting) and `LLLL` (standalone) are the same twelve words in
  /// `en-US`; the distinction only shows in languages with a genitive month
  /// form, which is why `DateLib.formatMonthYear` can use `LLLL` and read
  /// identically to `MMMM` here.
  static const List<String> monthsLong = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// `cccccc` — `enUS.localize.day(i, {width: 'short'})`, the two-letter
  /// standalone form the weekday header row prints.
  ///
  /// Indexed from **Sunday**, which is both `date-fns`'s day index and the
  /// week start `react-day-picker` uses with the default `enUS` locale.
  /// *(Probe-confirmed on the live calendar: `Su Mo Tu We Th Fr Sa`.)*
  static const List<String> weekdaysNarrow = <String>[
    'Su',
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
  ];

  /// `EEEE` — `{width: 'wide'}`, Sunday-first. Only the accessible day label
  /// reads these.
  static const List<String> weekdaysLong = <String>[
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  /// [DateTime.weekday] (Mon = 1 … Sun = 7) as a Sunday-first index 0–6.
  ///
  /// The whole grid is built on this one conversion: a `% 7` turns Dart's
  /// ISO-8601 week into the `en-US` week the reference renders, and the same
  /// expression counts the leading outside days of a month
  /// (`DsCalendarMonth.leadingDays`).
  static int weekIndex(DateTime date) => date.weekday % 7;

  /// `format(d, "d MMM")` — **"12 Jul"**. No leading zero: `d`, not `dd`.
  static String dayMonth(DateTime date) =>
      '${date.day} ${monthsShort[date.month - 1]}';

  /// `format(d, "d MMM yyyy")` — **"30 Jul 2026"**.
  static String dayMonthYear(DateTime date) =>
      '${date.day} ${monthsShort[date.month - 1]} ${date.year}';

  /// `DateLib.formatMonthYear` — **"August 2026"**.
  ///
  /// `DateLib.js:521` branches on whether the locale writes the year first;
  /// `en-US` falls to the other side, so it is month then year with one space.
  static String monthYear(DateTime date) =>
      '${monthsLong[date.month - 1]} ${date.year}';

  /// `format(d, "cccccc")` — **"Su"**, for a column index 0–6.
  static String weekdayNarrow(int columnIndex) => weekdaysNarrow[columnIndex];

  /// `calendarDayKey` (`calendar.tsx:15–20`) — **"2026-07-26"**.
  ///
  /// The reference builds this **by hand** from the local fields rather than
  /// slicing an ISO string, and the page's own error-toned `Note` is a
  /// postmortem of the version that did not. Same construction here, for the
  /// same reason.
  static String dayKey(DateTime date) =>
      '${_pad(date.year, 4)}-${_pad(date.month, 2)}-${_pad(date.day, 2)}';

  /// `labelDayButton` — **"Sunday, July 26th, 2026"**, `date-fns`'s
  /// `EEEE, MMMM do, yyyy`. *(Probe-confirmed: it is the day button's
  /// `aria-label` on the live calendar.)*
  static String dayLabel(DateTime date) =>
      '${weekdaysLong[weekIndex(date)]}, '
      '${monthsLong[date.month - 1]} ${ordinal(date.day)}, ${date.year}';

  /// `do` — the English ordinal: 1st, 2nd, 3rd, 4th … 11th, 12th, 13th … 21st,
  /// 31st.
  ///
  /// The teens are the exception the naive rule gets wrong, and a month has
  /// three of them.
  static String ordinal(int day) {
    final String suffix;
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      suffix = switch (day % 10) {
        1 => 'st',
        2 => 'nd',
        3 => 'rd',
        _ => 'th',
      };
    }
    return '$day$suffix';
  }

  static String _pad(int value, int width) =>
      value.toString().padLeft(width, '0');
}

/// The app's "now" — an injectable clock.
///
/// **Why this exists (ruling L2).** `react-day-picker`'s `getInitialMonth` is
/// `month || defaultMonth || today`, and the selects page passes neither of the
/// first two to any of its three calendars. All three therefore open on **the
/// reader's current month**, with their seeded July 2026 values wherever that
/// month happens to put them. The port reproduces that — it is what the page
/// does — which makes the rendered document height a function of the wall
/// clock: a five-week month and a six-week month differ by exactly one row
/// *(probe-measured: 36px, and 268.563 vs 304.563 for the whole calendar)*.
///
/// A vertical-parity probe cannot pin a route whose height moves with the date,
/// so the capture harness freezes the clock on **both** sides: Chrome gets a
/// `Date` shim through `evaluateOnNewDocument`, and this side gets
/// `?clock=<ISO-8601>` (`example/lib/main.dart`), which lands here. One
/// instant, two renderers, one height.
///
/// Nothing above the calendar is required to supply it: [nowOf] falls back to
/// [DateTime.now], so a widget mounted with no clock in scope behaves exactly
/// as it did before this seam existed.
class DsClock extends InheritedWidget {
  const DsClock({super.key, required this.now, required super.child});

  /// The instant every consumer below reads as "now".
  ///
  /// A **local** [DateTime]: the calendar compares calendar dates, and a UTC
  /// instant would shift the boundary of "today" by the reader's offset —
  /// which is the exact bug the page's own §7 `Note` is about.
  final DateTime now;

  /// The nearest injected clock, or [DateTime.now] when there is none.
  ///
  /// Registers a dependency, so a rig that swaps the instant rebuilds every
  /// calendar under it.
  static DateTime nowOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DsClock>()?.now ??
      DateTime.now();

  /// The injected clock itself, without the fallback — for a caller that needs
  /// to know whether one was supplied at all.
  static DsClock? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DsClock>();

  @override
  bool updateShouldNotify(DsClock old) => old.now != now;
}

/// The type the calendar needs and `typography.dart` does not declare.
///
/// **One rung.** The other two the calendar prints already exist and are used
/// as-is: the caption label is `font-medium … text-sm` →
/// [DsComponentType.buttonLabel] (13 / 18.5714 / 500) and the weekday header is
/// `text-sm font-normal` → [DsComponentType.textSm] (13 / 18.5714 / 400). Both
/// were *(probe-confirmed)* on the live calendar to the digit.
///
/// It is declared **here** rather than in `typography.dart` because that file
/// has a single writer per wave and this wave is not it. It is a token, so it
/// belongs under `lib/src/foundation/` — which is the rule the guard actually
/// enforces — and it should move up to `DsComponentType` the next time
/// `typography.dart` is opened.
class DsCalendarType {
  const DsCalendarType._();

  /// `CalendarDayButton`'s number.
  ///
  /// The class list (`calendar.tsx:207–225`) declares `leading-none
  /// font-normal` and **no `text-*` class at all** — so the size is whatever
  /// the element inherits, and every ancestor up to `<html>` leaves it alone.
  /// That is the root `1rem`, which `spacing.dart`'s own library note records
  /// as 16px. *(Probe-measured on the live day button:
  /// `font-size: 16px`, `line-height: 16px`, `font-weight: 400`,
  /// `letter-spacing: normal`, Inter.)*
  ///
  /// `leading-none` is `line-height: 1`, which is why the height is 1 and not
  /// one of the ladder's ratios: a 28px cell centres a 16px line box, and any
  /// larger box would push the number off centre.
  ///
  /// This is also the only place on the page where a number is set in the
  /// **sans** face at a size the type scale does not name — the page's own
  /// Do 5 (*"render dates and prices with the named numerical typography
  /// foundation"*) is about the trigger label, not about the grid.
  static final DsTypeSpec dayNumber = DsTypeSpec(
    family: DsFonts.sans,
    size: 16,
    height: 1,
    wght: 400,
  );
}
