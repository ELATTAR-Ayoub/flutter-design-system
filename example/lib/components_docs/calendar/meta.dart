/// Documentation metadata for the calendar component.
///
/// A worker-owned file: the supervisor folds [calendarDoc] into
/// `catalog.dart`'s `componentDocs` list in a later, serialized pass. This
/// file only ever imports `catalog.dart` for the [ComponentDocEntry] shape —
/// it never edits it.
///
/// `calendar` has **no** `registry/components/calendar.json`, so
/// `elattar add calendar` does not work today. [dependencies] is therefore
/// not a validated `registryDependencies` list; it is the set of registry
/// items a future manifest would have to name, read off the real imports at
/// the top of `lib/src/components/calendar.dart`:
///
///  * `source-foundation` — `colors`, `date_format`, `motion`, `spacing`,
///    `theme` and `typography`. `date_format.dart` is inside the foundation
///    item (`registry/foundations/source.json` lists it), which is what puts
///    `DsDateFormat`, `DsClock` and `DsCalendarType` there rather than here.
///  * `button` — the date picker's outline trigger.
///  * `icon` — the two chevrons and the trigger's calendar glyph. That item
///    already ships `icon_paths.dart` and `icon_paths.g.dart`, so the
///    calendar's `icon_paths.dart` import needs no separate entry.
///  * `popover` — the date picker's popup.
///
/// [ComponentDocEntry.description] is the one-sentence form for nav and
/// search. [calendarExpandedDescription] carries the IA §9.2 "when to use
/// this instead of a neighbour" guidance as a second top-level constant,
/// because [ComponentDocEntry] itself carries only one description field and
/// is supervisor-owned.
library;

import '../catalog.dart';

/// IA §9.2's expanded description: the three ways this system offers to put a
/// date into a form, and which one each job wants.
const String calendarExpandedDescription =
    'A month grid, always visible, that reports calendar dates rather than '
    'instants. Reach for the inline grid — DsCalendar on its own card — when '
    'the date is the main subject of the screen and the reader needs to see '
    'the shape of the month while they choose: a booking screen where '
    'weekends matter, a range whose length is the point, a schedule where '
    'the surrounding days give the answer meaning. It costs roughly 222 by '
    '305 logical pixels of permanent layout, which is the price of that '
    'context. Reach for the date picker instead — DsDatePicker, the same '
    'grid inside a popover behind a button — when the date is one field '
    'among many and the form should not be dominated by a month: the grid '
    'costs nothing until it is asked for, and the trigger doubles as the '
    'value display. Reach for neither, and use a plain DsInput with your own '
    'parsing, when the reader already knows the date and typing it is faster '
    'than hunting for it — a birth date thirty years back, an invoice date '
    'copied off paper. A text field beats a grid the moment the target is '
    'more than a couple of months from today, because this calendar moves '
    'one month per click and has no year jump. Two things the grid cannot do '
    'at all, and which decide the question outright: it has no minimum or '
    'maximum bound and no way to disable an individual day, so any rule of '
    'the form "not in the past", "weekdays only" or "inside the tax year" '
    'has to be enforced by the caller after the fact — or by disabling the '
    'whole picker, which is what DsDatePicker with a null onChanged does.';

const ComponentDocEntry calendarDoc = ComponentDocEntry(
  name: 'calendar',
  title: 'Calendar',
  description:
      'A month grid for picking one date or a range, either inline or inside '
      'a popover, built on local calendar dates rather than instants.',
  dependencies: <String>['source-foundation', 'button', 'icon', 'popover'],
  exports: <String>[
    'DsCalendar',
    'DsCalendarMode',
    'DsCalendarSurface',
    'DsDateRange',
    'DsCalendarDay',
    'DsCalendarMonth',
    'DsCalendarBandPainter',
    'DsDatePicker',
  ],
  sourcePath: 'lib/src/components/calendar.dart',
);
