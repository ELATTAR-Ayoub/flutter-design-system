/// Documentation metadata for the calendar component.
///
/// A worker-owned file: the supervisor folds [calendarDoc] into
/// `catalog.dart`'s `componentDocs` list in a later, serialized pass. This
/// file only ever imports `catalog.dart` for the [ComponentDocEntry] shape —
/// it never edits it.
///
/// `calendar` ships `registry/components/calendar.json`, so
/// `elattar add calendar` resolves today. [dependencies] mirrors that
/// manifest's `registryDependencies`, which also match the real imports at
/// the top of `lib/src/components/calendar.dart`:
///
///  * `source-foundation`, `colors`, `date_format`, `motion`, `spacing`,
///    `theme` and `typography`. `date_format.dart` is inside the foundation
///    item (`registry/foundations/source.json` lists it), which is what puts
///    `ElDateFormat`, `ElClock` and `ElCalendarType` there rather than here.
///  * `button`: the date picker's outline trigger.
///  * `icon`: the two chevrons and the trigger's calendar glyph. That item
///    already ships `icon_paths.dart` and `icon_paths.g.dart`, so the
///    calendar's `icon_paths.dart` import needs no separate entry.
///  * `popover`: the date picker's popup.
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the one-sentence form for nav, search, and the page's own hero line.
library;

import '../catalog.dart';

const ComponentDocEntry calendarDoc = ComponentDocEntry(
  name: 'calendar',
  title: 'Calendar',
  description:
      'A month grid for picking one date or a range, either inline or inside '
      'a popover, built on local calendar dates rather than instants.',
  dependencies: <String>['button', 'icon', 'popover', 'source-foundation'],
  exports: <String>[
    'ElCalendar',
    'ElCalendarMode',
    'ElCalendarSurface',
    'ElDateRange',
    'ElCalendarDay',
    'ElCalendarMonth',
    'ElCalendarBandPainter',
    'ElDatePicker',
  ],
  sourcePath: 'lib/src/components/calendar.dart',
);
