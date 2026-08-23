/// Public documentation page for the `calendar` component.
///
/// The reference's selects page has three calendars — `DsCalendar.single` in a
/// Panel, `DsCalendar.range` in another Panel, and a `DsDatePicker` inside a
/// Popover. This page mounts exactly those three as interactive specimens with
/// live readouts of what the reader picked.
///
/// Two things make calendar peculiar:
///
/// 1. **The clock must be frozen.** `DsCalendar` opens on `month ?? defaultMonth
///    ?? today`, and the page's three specimens pass neither month nor
///    defaultMonth intentionally — that is what the reference does. A test that
///    lets the wall clock through would pass in August 2026 and fail in
///    September. The test harness pins a [DsClock] to a fixed date and time,
///    the same instant the capture rig freezes, so rendered months are
///    reproducible. The two seeded specimens below read that same clock through
///    [DsClock.nowOf] rather than `DateTime.now()`, so the seed and the opening
///    month can never disagree.
/// 2. **The date picker needs a real Overlay.** `DsDatePicker` mounts its
///    calendar through a `DsPopover`, which uses an `OverlayPortal`, which
///    needs a real Material `Overlay` to work. The test wraps the page in a
///    `MaterialApp` for that reason.
///
/// `calendar` has no registry manifest yet — the Installation section discloses
/// this honestly rather than inventing a CLI command.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class CalendarDocPage extends StatelessWidget {
  const CalendarDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: calendarDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: calendarDoc.title,
      description: calendarExpandedDescription,
    ),
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Components'),
      DsBreadcrumbEntry.page('Calendar'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Overview', anchor: 'overview'),
      DocsTocEntry(title: 'Preview', anchor: 'preview'),
      DocsTocEntry(title: 'Install', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'API', anchor: 'api'),
      DocsTocEntry(title: 'Variants', anchor: 'variants'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: const DocsPageLink(title: 'Select', route: '/components/select'),
    onNavigate: onNavigate,
    child: const _CalendarArticle(),
  );
}

const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Button', route: '/components/button'),
  DocsSidebarEntry(title: 'Card', route: '/components/card'),
  DocsSidebarEntry(title: 'Input', route: '/components/input'),
  DocsSidebarEntry(title: 'Dialog', route: '/components/dialog'),
  DocsSidebarEntry(title: 'Select', route: '/components/select'),
  DocsSidebarEntry(
    title: 'Calendar',
    route: '/components/calendar',
    selected: true,
  ),
];

class _CalendarArticle extends StatelessWidget {
  const _CalendarArticle();

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('calendar-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _overview(),
      _preview(),
      _install(),
      _usage(),
      _api(),
      _variants(),
      _states(),
      _accessibility(),
      _responsive(),
      _dependencies(),
      _composition(),
      _theming(),
      _source(),
    ],
  );

  Widget _overview() => DsSection(
    id: 'overview',
    title: 'Overview',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DsWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(
            'DsCalendar renders a month grid: a fixed-size day picker for '
            'selecting a single date or a date range. Two modes — single and '
            'range — shape what it holds and what it reports, and three '
            'surface treatments let it render on card, background, or inside '
            'a popover. DsDatePicker wraps the calendar inside a popover '
            'behind a button, and is the shape most forms reach for.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'The calendar reads local calendar dates, never instants: a July '
            'date stays July everywhere on earth. The opening month is the '
            'reader\'s current month by default, chosen on first render and '
            'never moved by a later tick of the clock — a calendar opened on '
            'the 31st and left open past midnight still shows the month it '
            'opened on.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'Status: stable primitive, not yet registered in the CLI. '
            'Platforms: Android, iOS, Web, macOS, Windows, Linux.',
            DsType.small,
          ),
        ],
      ),
    ),
  );

  Widget _preview() => DsSection(
    id: 'preview',
    title: 'Preview',
    description:
        'Single date selection, range selection, and a date picker — all '
        'three live, each with a readout of exactly what it reports back.',
    child: DocsCodeExample(
      title: 'Three calendar arrangements',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/calendar.dart',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy lib/src/components/calendar.dart from the package\n'
              '// source directly. There is no generated CLI payload yet.',
        ),
      ],
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText('Single date selection', DsType.label),
          SizedBox(height: ds(2)),
          const _SingleCalendarSpecimen(),
          SizedBox(height: ds(6)),
          DsText('Range selection', DsType.label),
          SizedBox(height: ds(2)),
          const _RangeCalendarSpecimen(),
          SizedBox(height: ds(6)),
          DsText('Date picker', DsType.label),
          SizedBox(height: ds(2)),
          const _DatePickerSpecimen(),
          SizedBox(height: ds(3)),
          const _DatePickerDisabledSpecimen(),
        ],
      ),
    ),
  );

  Widget _install() => DsSection(
    id: 'install',
    title: 'Installation',
    description:
        'calendar has no registry manifest yet, so the CLI cannot install '
        'this component — copy the source file by hand instead.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'CLI install',
          value: 'Not available yet',
          description:
              'Running `elattar add calendar` fails today: no '
              'registry/components/calendar.json exists, so the registry '
              'client has nothing to resolve.',
        ),
        const DocsInstallFact(
          label: 'Registry item',
          value: 'Not available yet',
          description:
              'A source-only component. The widget is exported from the '
              'package barrel and usable through the published package right '
              'now; only the registry payload is missing.',
        ),
        const DocsInstallFact(
          label: 'Destination',
          value: 'lib/components/ui/calendar.dart',
          description: 'Where a manual copy of the source belongs.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value: 'source-foundation, button, icon, popover',
          description:
              'What a future manifest would have to name, read off the real '
              'imports at the top of calendar.dart. None of it resolves '
              'automatically today.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description: 'No images, icon fonts, or binary assets.',
        ),
        const DocsInstallFact(
          label: 'Shaders',
          value: 'none',
          description:
              'The range band is a CustomPainter, not a fragment shader.',
        ),
        const DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description: 'No platform-conditional code in calendar.dart.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimens plus the package suite',
          description:
              'This page\'s three live specimens and '
              'example/test/components_docs/calendar_test.dart, alongside '
              'the package\'s own test/calendar_test.dart.',
        ),
      ],
    ),
  );

  Widget _usage() => DsSection(
    id: 'usage',
    title: 'Usage',
    description: 'The three arrangements in the preview.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPanel(
          label: 'DART',
          note: 'SINGLE',
          child: DocsSelectableCodeBlock(code: _usageSingleCode),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'DART',
          note: 'RANGE',
          child: DocsSelectableCodeBlock(code: _usageRangeCode),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'DART',
          note: 'DATE PICKER',
          child: DocsSelectableCodeBlock(code: _usageDatePickerCode),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'DART',
          note: 'STORING WHAT IT REPORTS',
          child: DocsSelectableCodeBlock(code: _usageDayKeyCode),
        ),
      ],
    ),
  );

  Widget _api() => DsSection(
    id: 'api',
    title: 'API',
    description:
        'Every public class, enum, static, and constructor parameter the '
        'source declares — plus the half of source-foundation this component '
        'cannot be understood without.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsCalendar.single / DsCalendar.range — parameters',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'selected',
              type: 'DateTime? / DsDateRange?',
              description:
                  'The picked value. DateTime? on the single constructor, '
                  'DsDateRange? on the range constructor.',
            ),
            DocsApiFact(
              name: 'onSelected',
              type: 'ValueChanged<DateTime?>? / ValueChanged<DsDateRange?>?',
              description:
                  'Called on every pick. Null makes the grid read-only — '
                  'there is no separate enabled flag.',
            ),
            DocsApiFact(
              name: 'month',
              type: 'DateTime?',
              description:
                  'The controlled displayed month. Non-null pins the grid: '
                  'the caller owns navigation and must respond to '
                  'onMonthChanged for the chevrons to do anything.',
            ),
            DocsApiFact(
              name: 'defaultMonth',
              type: 'DateTime?',
              description:
                  'The uncontrolled seed, read once on first build. Null '
                  'falls through to the clock\'s own month.',
            ),
            DocsApiFact(
              name: 'onMonthChanged',
              type: 'ValueChanged<DateTime>?',
              description:
                  'Called with the first of the new month whenever the '
                  'chevrons move the grid.',
            ),
            DocsApiFact(
              name: 'surface',
              type: 'DsCalendarSurface',
              description:
                  'Defaults to card. Selects fill, border, and padding — see '
                  'Variants.',
            ),
            DocsApiFact(
              name: 'autoFocus',
              type: 'bool',
              description:
                  'Defaults to false. True is what DsDatePicker passes so '
                  'the popover calendar takes focus and Escape has somewhere '
                  'to travel up from.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsCalendar — the fields the two constructors resolve onto',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'mode',
              type: 'DsCalendarMode',
              description:
                  'single or range, fixed by which constructor was used. Not '
                  'a parameter — it cannot be passed or changed.',
            ),
            DocsApiFact(
              name: 'selectedDay',
              type: 'DateTime?',
              description:
                  'The single constructor\'s selected. Always null in range '
                  'mode.',
            ),
            DocsApiFact(
              name: 'onDaySelected',
              type: 'ValueChanged<DateTime?>?',
              description:
                  'The single constructor\'s onSelected. Always null in '
                  'range mode.',
            ),
            DocsApiFact(
              name: 'selectedRange',
              type: 'DsDateRange?',
              description:
                  'The range constructor\'s selected. Always null in single '
                  'mode.',
            ),
            DocsApiFact(
              name: 'onRangeSelected',
              type: 'ValueChanged<DsDateRange?>?',
              description:
                  'The range constructor\'s onSelected. Always null in '
                  'single mode.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsCalendar — statics',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'cellSize',
              type: 'static double',
              description: 'One day square — 28 logical pixels.',
            ),
            DocsApiFact(
              name: 'contentWidth',
              type: 'static double',
              description:
                  'The seven-column grid before surface padding — 196 '
                  'logical pixels.',
            ),
            DocsApiFact(
              name: 'rangeBleed',
              type: 'static double',
              description:
                  'How far a range cap\'s square bleeds past its own cell so '
                  'the band reads as continuous across the gap.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsDateRange',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'from',
              type: 'DateTime?',
              description: 'First day, inclusive.',
            ),
            DocsApiFact(
              name: 'to',
              type: 'DateTime?',
              description:
                  'Last day, inclusive. Null while a range is half-picked.',
            ),
            DocsApiFact(
              name: 'isComplete',
              type: 'bool (get)',
              description: 'Both ends set.',
            ),
            DocsApiFact(
              name: 'includes',
              type: 'bool',
              description: 'The day falls inside the band, ends included.',
            ),
            DocsApiFact(
              name: 'isStart',
              type: 'bool',
              description: 'The day is the from cap.',
            ),
            DocsApiFact(
              name: 'isEnd',
              type: 'bool',
              description: 'The day is the to cap.',
            ),
            DocsApiFact(
              name: 'isMiddle',
              type: 'bool',
              description: 'Inside the band and neither cap.',
            ),
            DocsApiFact(
              name: 'addToRange',
              type: 'static DsDateRange?',
              description:
                  'The whole selection rule, in one function: it decides '
                  'whether a tap opens a new range, closes the open one, or '
                  're-homes a complete one.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsCalendarDay — date arithmetic on local fields',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'of',
              type: 'static DateTime',
              description:
                  'Strips the time, keeping year/month/day. Every comparison '
                  'in this component runs on the result.',
            ),
            DocsApiFact(
              name: 'startOfMonth',
              type: 'static DateTime',
              description: 'The first of the day\'s own month.',
            ),
            DocsApiFact(
              name: 'isSameDay',
              type: 'static bool',
              description: 'Same year, month, and day — not the same instant.',
            ),
            DocsApiFact(
              name: 'isSameMonth',
              type: 'static bool',
              description: 'Same year and month.',
            ),
            DocsApiFact(
              name: 'addDays',
              type: 'static DateTime',
              description: 'Move by whole days.',
            ),
            DocsApiFact(
              name: 'addMonths',
              type: 'static DateTime',
              description:
                  'Move by whole months, clamping the day into the target '
                  'month — 31 January plus one month is 28 February.',
            ),
            DocsApiFact(
              name: 'daysInMonth',
              type: 'static int',
              description: '28, 29, 30, or 31.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsCalendarMonth — the grid geometry',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'leadingDays',
              type: 'int (get)',
              description:
                  'How many days of the previous month open the first row.',
            ),
            DocsApiFact(
              name: 'dayCount',
              type: 'int (get)',
              description: 'Days in this month.',
            ),
            DocsApiFact(
              name: 'weekCount',
              type: 'int (get)',
              description:
                  'Four, five, or six rows. August 2026 opens on a Saturday '
                  'and therefore needs six.',
            ),
            DocsApiFact(
              name: 'days',
              type: 'List<DateTime> (get)',
              description:
                  'Every cell in reading order, leading and trailing days '
                  'included.',
            ),
            DocsApiFact(
              name: 'gridHeight',
              type: 'double',
              description: 'Caption plus weekday header plus all week rows.',
            ),
            DocsApiFact(
              name: 'outerHeight',
              type: 'double',
              description: 'gridHeight plus the surface padding and border.',
            ),
            DocsApiFact(
              name: 'paddingFor',
              type: 'static double',
              description: 'The padding a given DsCalendarSurface adds.',
            ),
            DocsApiFact(
              name: 'borderWidthFor',
              type: 'static double',
              description: 'The border a given DsCalendarSurface draws.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsCalendarBandPainter — the range band and today marker',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'muted',
              type: 'Color',
              description:
                  'The one colour it paints with, for the band and the today '
                  'marker alike.',
            ),
            DocsApiFact(
              name: 'today',
              type: 'bool',
              description:
                  'This cell is the clock\'s own day, and takes the grounded '
                  'rounded rectangle.',
            ),
            DocsApiFact(
              name: 'selected',
              type: 'bool',
              description:
                  'This cell also carries the selected fill — which squares '
                  'off the today marker underneath it.',
            ),
            DocsApiFact(
              name: 'rangeStart',
              type: 'bool',
              description: 'This cell is the from cap.',
            ),
            DocsApiFact(
              name: 'rangeEnd',
              type: 'bool',
              description: 'This cell is the to cap.',
            ),
            DocsApiFact(
              name: 'radius',
              type: 'double',
              description: 'The cell radius the band rounds to.',
            ),
            DocsApiFact(
              name: 'bleed',
              type: 'double',
              description:
                  'DsCalendar.rangeBleed — the square drawn past the cap so '
                  'the band meets its neighbour.',
            ),
            DocsApiFact(
              name: 'shouldRepaint',
              type: 'bool',
              description:
                  'Repaints only when one of the seven fields above actually '
                  'changed.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsDatePicker',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'value',
              type: 'DateTime?',
              description:
                  'Required. The picked date, or null for the empty state.',
            ),
            DocsApiFact(
              name: 'onChanged',
              type: 'ValueChanged<DateTime?>?',
              description:
                  'Null disables the trigger outright — the popover never '
                  'opens. This is the only per-instance disabling the family '
                  'offers.',
            ),
            DocsApiFact(
              name: 'placeholder',
              type: 'String',
              description: 'The empty label. Defaults to "Pick a date".',
            ),
            DocsApiFact(
              name: 'focusNode',
              type: 'FocusNode?',
              description: 'An optional node for the trigger button.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String?',
              description:
                  'The accessible name, for when the visible label is a '
                  'value rather than a description.',
            ),
            DocsApiFact(
              name: 'pressScaleSuppressed',
              type: 'static bool (get)',
              description:
                  'Always true, and exported so the drift is assertable: the '
                  'trigger passes DsButton.suppressPressScale because the '
                  'reference\'s own aria-haspopup trigger does not squish.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsDateFormat — source-foundation, hardcoded en-US',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'monthsShort',
              type: 'static const List<String>',
              description: 'Jan…Dec.',
            ),
            DocsApiFact(
              name: 'monthsLong',
              type: 'static const List<String>',
              description: 'January…December — what the caption prints.',
            ),
            DocsApiFact(
              name: 'weekdaysNarrow',
              type: 'static const List<String>',
              description: 'Su Mo Tu We Th Fr Sa — the header row, in order.',
            ),
            DocsApiFact(
              name: 'weekdaysLong',
              type: 'static const List<String>',
              description: 'Sunday…Saturday — used by dayLabel.',
            ),
            DocsApiFact(
              name: 'weekIndex',
              type: 'static int',
              description:
                  'date.weekday % 7 — the column a date lands in, Sunday '
                  'being column zero.',
            ),
            DocsApiFact(
              name: 'dayMonth',
              type: 'static String',
              description: '"16 Aug" — the range readout\'s own format.',
            ),
            DocsApiFact(
              name: 'dayMonthYear',
              type: 'static String',
              description: '"16 Aug 2026" — the date picker\'s trigger label.',
            ),
            DocsApiFact(
              name: 'monthYear',
              type: 'static String',
              description: '"August 2026" — the caption.',
            ),
            DocsApiFact(
              name: 'weekdayNarrow',
              type: 'static String',
              description: 'One header cell, by column index.',
            ),
            DocsApiFact(
              name: 'dayKey',
              type: 'static String',
              description:
                  '"2026-08-16", built from the local year/month/day fields. '
                  'The string to store — see Accessibility for why this is '
                  'not toIso8601String().',
            ),
            DocsApiFact(
              name: 'dayLabel',
              type: 'static String',
              description:
                  '"Sunday, August 16th, 2026" — every day cell\'s '
                  'accessible name.',
            ),
            DocsApiFact(
              name: 'ordinal',
              type: 'static String',
              description: '1st, 2nd, 3rd, 4th… as dayLabel needs them.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsClock and DsCalendarType — source-foundation',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'now',
              type: 'DateTime',
              description:
                  'The instant this scope calls the present. An InheritedWidget '
                  'field, not a global — which is what makes the month a test '
                  'can pin.',
            ),
            DocsApiFact(
              name: 'nowOf',
              type: 'static DateTime',
              description:
                  'The nearest DsClock\'s now, or DateTime.now() when no '
                  'clock is mounted. What the grid and both seeded specimens '
                  'read.',
            ),
            DocsApiFact(
              name: 'maybeOf',
              type: 'static DsClock?',
              description:
                  'The scope itself, or null — for callers that need to know '
                  'whether a clock was pinned at all.',
            ),
            DocsApiFact(
              name: 'dayNumber',
              type: 'static DsTypeSpec',
              description:
                  'DsCalendarType\'s type spec for the digits in a day cell.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _variants() => DsSection(
    id: 'variants',
    title: 'Variants',
    description:
        'Two enums. The mode is fixed by the constructor and cannot change '
        'over an instance\'s life; the surface is an ordinary parameter.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsCalendarMode',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'single',
              type: 'DsCalendarMode',
              description:
                  'One date. Re-picking the selected day clears it — there '
                  'is no required flag to prevent that.',
            ),
            DocsApiFact(
              name: 'range',
              type: 'DsCalendarMode',
              description:
                  'A from/to pair. One month is rendered, matching the '
                  'reference\'s numberOfMonths of 1.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsCalendarSurface',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'card',
              type: 'DsCalendarSurface',
              description:
                  'The default. Fills with theme.card, adds a border and the '
                  'surface padding.',
            ),
            DocsApiFact(
              name: 'background',
              type: 'DsCalendarSurface',
              description: 'Fills with theme.background; no border.',
            ),
            DocsApiFact(
              name: 'popover',
              type: 'DsCalendarSurface',
              description:
                  'Transparent — the DsPopoverSurface around it already '
                  'paints the fill, ring, and shadow. What DsDatePicker '
                  'passes.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _states() => DsSection(
    id: 'states',
    title: 'States and feedback',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Rest',
          treatment: 'A ghost day cell — no fill, no border.',
          userSignal: 'Every in-month day reads as selectable.',
        ),
        DocsStateFact(
          state: 'Selected',
          treatment: 'The primary fill, with primaryForeground ink.',
          userSignal: 'One cell is unmistakably the picked one.',
        ),
        DocsStateFact(
          state: 'Range',
          treatment:
              'Both caps take the primary fill; the days between take the '
              'muted band, bled past each cap so the run reads continuous '
              'across the column gaps.',
          userSignal: 'The band\'s length is the answer.',
        ),
        DocsStateFact(
          state: 'Today',
          treatment:
              'A muted rounded rectangle under the digits, squared off when '
              'the same cell is also selected.',
          userSignal: 'Today is grounded without being claimed as chosen.',
        ),
        DocsStateFact(
          state: 'Outside days',
          treatment:
              'Leading and trailing days render in mutedForeground and stay '
              'fully selectable.',
          userSignal: 'Cross-month picking works without navigating first.',
        ),
        DocsStateFact(
          state: 'Focus-visible',
          treatment:
              'One roving focus ring on the grid\'s single FocusNode, drawn '
              'on the focused cell.',
          userSignal: 'Keyboard position is always visible.',
        ),
        DocsStateFact(
          state: 'Disabled',
          treatment:
              'Pass a null onSelected (or, for the picker, a null onChanged). '
              'There is no per-day disabling — see Accessibility.',
          userSignal: 'The whole grid goes read-only, or the trigger does.',
        ),
        DocsStateFact(
          state: 'Loading / Empty / Error / Success',
          treatment:
              'N/A — the grid is computed synchronously from a month and has '
              'no async, empty, or validation state of its own.',
          userSignal: 'N/A',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'Month changes swap the grid without animated travel; the '
              'picker\'s popover transition collapses through '
              'dsAnimationDuration.',
          userSignal: 'Navigation is instant.',
        ),
      ],
    ),
  );

  Widget _accessibility() => DsSection(
    id: 'accessibility',
    title: 'Accessibility and keyboard behavior',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPanel(
          label: 'The ruling this page exists to teach',
          note: 'DAY KEYS, NOT INSTANTS',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'A calendar date is not an instant, and the two must not be '
                'stored the same way. DsDateFormat.dayKey builds "2026-08-16" '
                'out of the local year, month, and day fields. It never calls '
                'toIso8601String() and never converts to UTC, because both of '
                'those turn a day into a moment and a moment reads back as a '
                'different day depending on where the reader is standing.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'The bug this prevents, concretely: a reader in New York picks '
                '16 August and the app stores '
                'date.toUtc().toIso8601String(), which is '
                '2026-08-16T04:00:00Z. Read back in London that is still the '
                '16th, so the bug hides. Now the New York reader picks a date '
                'and the app stores it at local midnight — '
                '2026-08-16T00:00:00-04:00, i.e. 2026-08-16T04:00:00Z — while '
                'a reader in Los Angeles storing the same calendar day writes '
                '2026-08-16T07:00:00Z, and a reader in Tokyo writes '
                '2026-08-15T15:00:00Z. Slice the date half off any of those '
                'ISO strings after a UTC conversion and one of the three reads '
                'back as the 15th. The day the reader tapped is gone, and it '
                'is gone only for some readers, which is why this class of bug '
                'survives review.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'So: report and store DsDateFormat.dayKey(date). Compare with '
                'DsCalendarDay.isSameDay, never with DateTime equality. The '
                'single specimen above prints both halves — the human label '
                'and the key — so the difference is visible rather than '
                'asserted.',
                DsType.small,
              ),
            ],
          ),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'Keyboard',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const _KeyRow(
                'ArrowLeft / ArrowRight',
                'Move one day back or forward, crossing week and month '
                    'boundaries.',
              ),
              const _KeyRow(
                'ArrowUp / ArrowDown',
                'Move one week back or forward.',
              ),
              const _KeyRow(
                'PageUp',
                'Move to the same day of the previous month.',
              ),
              const _KeyRow(
                'PageDown',
                'Move to the same day of the next month.',
              ),
              const _KeyRow('Home', 'Jump to the first day of the week row.'),
              const _KeyRow('End', 'Jump to the last day of the week row.'),
              const _KeyRow(
                'Enter',
                'Select the focused day — the same path a tap takes.',
              ),
              const _KeyRow(
                'Space',
                'Select the focused day; identical to Enter.',
                last: true,
              ),
            ],
          ),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'What the semantics tree carries',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'Every day cell is a button whose accessible name is the '
                'whole date — "Sunday, August 16th, 2026", from '
                'DsDateFormat.dayLabel — not the bare number, so a screen '
                'reader user never has to infer the month from context. The '
                'two chevrons are named "Go to the previous month" and "Go to '
                'the next month". The grid carries one FocusNode for all '
                'forty-two cells rather than forty-two nodes, so tabbing '
                'moves past the calendar in one press.',
                DsType.small,
              ),
            ],
          ),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'Known gaps',
          note: 'REPORTED, NOT IDEALISED',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'No grid role. The cells are buttons in a Column of Rows, not '
                'a semantic grid, so assistive tech announces forty-two '
                'buttons and never announces a row or column position.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'No disabled date support. There is no per-day predicate and '
                'no disabled date list of any kind: a rule such as "no dates '
                'in the past" or "weekdays only" has to be enforced by the '
                'caller after the pick, or by disabling the whole control.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'No bounds. There is no minimum and no maximum date '
                'parameter, so every day of every reachable month is '
                'selectable. Combined with one-month-per-click navigation and '
                'no year jump, a date far from today is genuinely faster to '
                'type into a text field.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'Touch target. A day cell is 28 by 28 logical pixels — under '
                'the 44 and 48 pixel minimum that iOS and Android '
                'respectively ask for. This is a faithful port of the '
                'reference\'s own cell size, and it is a real accessibility '
                'cost on touch: it is listed here rather than quietly fixed, '
                'because changing it would put this grid out of step with the '
                'design it reproduces.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'No non-visual selected or today signal. Selection and today '
                'are communicated by fill and by the band alone; neither adds '
                'a semantic selected flag or a spoken hint, so a screen '
                'reader user hears the same name for a picked day as for any '
                'other.',
                DsType.small,
              ),
            ],
          ),
        ),
        SizedBox(height: ds(5)),
        DsPanel(
          label: 'Locale and the first day of the week',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'Every string this component prints is hardcoded en-US, in '
                'DsDateFormat: the month names, the weekday names, the '
                '"16 Aug 2026" ordering, and the 1st/2nd/3rd ordinals. There '
                'is no locale parameter and no intl dependency — this package '
                'does not depend on intl at all, and adding it is the real '
                'work behind localising this grid, not a switch to flip.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'The week always starts on Sunday. weekIndex is '
                'date.weekday % 7 and the header row is a fixed list, so '
                'there is no weekStartsOn parameter to move it to Monday — '
                'which is what most of Europe, and the ISO week itself, '
                'expects. A caller needing a Monday-first grid or non-English '
                'month names cannot get either from this component today.',
                DsType.small,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _responsive() => DsSection(
    id: 'responsive',
    title: 'Responsive and platform behavior',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText(
          'No responsive branching: the grid reads no breakpoint and renders '
          'identically at 390 and 1440 logical pixels. Its width is intrinsic '
          '— seven 28px columns, 196px of content, about 222px once the card '
          'surface adds its padding and border — which is why it fits a phone '
          'viewport without any special case.',
          DsType.small,
        ),
        SizedBox(height: ds(3)),
        DsText(
          'Height is the only thing that moves, by one 28px row between a '
          'five-week and a six-week month. A caller reserving space for a '
          'calendar should reserve the six-row height, or accept the reflow '
          'when navigation crosses into a longer month.',
          DsType.small,
        ),
        SizedBox(height: ds(3)),
        DsText(
          'Inside the date picker, the popover positions itself against the '
          'trigger and is clamped to the viewport by dsPopoverPlacement — the '
          'calendar itself does not shrink, so on a very narrow screen the '
          'popup shifts rather than reflows.',
          DsType.small,
        ),
        SizedBox(height: ds(3)),
        DsText(
          'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
          'render the same widget tree; nothing in calendar.dart branches on '
          'platform.',
          DsType.small,
        ),
      ],
    ),
  );

  Widget _dependencies() => DsSection(
    id: 'dependencies',
    title: 'Dependencies, files, and assets',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText(
          'File: lib/src/components/calendar.dart — one file, carrying '
          'DsCalendar, DsDatePicker, and the four helper types.',
          DsType.small,
        ),
        SizedBox(height: ds(3)),
        DsText(
          'Foundation imports: colors, date_format (DsDateFormat, DsClock, '
          'DsCalendarType), motion, spacing, theme, and typography.',
          DsType.small,
        ),
        SizedBox(height: ds(3)),
        DsText(
          'Component imports: button (the picker\'s outline trigger), icon '
          '(the two chevrons and the trigger glyph), and popover (the '
          'picker\'s popup).',
          DsType.small,
        ),
        SizedBox(height: ds(3)),
        DsText(
          'Assets: none. Shaders: none — the range band is a CustomPainter.',
          DsType.small,
        ),
      ],
    ),
  );

  Widget _composition() => DsSection(
    id: 'composition',
    title: 'Composition example',
    description:
        'DsDatePicker is itself the composition: a DsButton trigger, a '
        'DsPopover, and a popover-surfaced DsCalendar that autofocuses so '
        'Escape has a path back out.',
    child: DsPanel(
      label: 'DART',
      note: 'DATE PICKER INTERNALS',
      child: DocsSelectableCodeBlock(code: _compositionCode),
    ),
  );

  Widget _theming() => DsSection(
    id: 'theming',
    title: 'Theming notes',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText(
          'Every colour comes from the live theme: primary and '
          'primaryForeground for a selected cell, muted for the today marker '
          'and the range band, mutedForeground for outside days and the '
          'weekday header, card or background for the surface. Flipping '
          'DsThemeController re-resolves all of them; nothing is cached and '
          'no colour is hardcoded.',
          DsType.small,
        ),
        SizedBox(height: ds(3)),
        DsText(
          'The band painter takes its one colour as a parameter rather than '
          'reading the theme itself, so the same painter draws correctly in '
          'both themes and can be reused against any surface.',
          DsType.small,
        ),
        SizedBox(height: ds(3)),
        DsText(
          'Type comes from DsCalendarType — dayNumber for the digits, and the '
          'caption and weekday specs beside it — so a type-scale change moves '
          'the calendar with the rest of the system.',
          DsType.small,
        ),
      ],
    ),
  );

  Widget _source() => DsSection(
    id: 'source',
    title: 'Source, tests, and docs',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: calendarDoc.sourcePath,
          description: 'Authoritative implementation.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'test/calendar_test.dart',
          description:
              'The package\'s own suite, run against the same frozen instant '
              'this page\'s tests use.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/calendar_test.dart',
          description:
              'Covers this page: the API tables, all three live specimens, '
              'the frozen-clock ruling, and both viewport widths in both '
              'themes.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/calendar/page.dart',
          description: 'This file.',
        ),
      ],
    ),
  );
}

/// One keyboard row: the key on its own line, then what it does.
///
/// The key name is deliberately **not** [DsType.label] — that spec is
/// `uppercase`, and `DsText` performs the transform on the string itself
/// (`theme_scope.dart`), so `PageUp` would reach the tree as `PAGEUP`. Key
/// names are case-carrying identifiers, not decorative eyebrows: they are
/// rendered at small size in the action ink instead, which keeps the same
/// visual hierarchy without rewriting the word.
class _KeyRow extends StatelessWidget {
  const _KeyRow(this.keys, this.body, {this.last = false});

  final String keys;
  final String body;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : ds(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(keys, DsType.small, color: theme.actionInk),
          SizedBox(height: ds(1)),
          DsText(body, DsType.small),
        ],
      ),
    );
  }
}

const String _usageSingleCode = '''
DsCalendar.single(
  selected: selectedDate,
  onSelected: (DateTime? day) => setState(() => selectedDate = day),
)
''';

const String _usageRangeCode = '''
DsCalendar.range(
  selected: selectedRange,
  onSelected: (DsDateRange? range) => setState(() => selectedRange = range),
)
''';

const String _usageDatePickerCode = '''
DsDatePicker(
  value: pickedDate,
  onChanged: (DateTime? day) => setState(() => pickedDate = day),
)
''';

const String _usageDayKeyCode = '''
// Store the day the reader tapped, not the moment your process was in.
final String key = DsDateFormat.dayKey(picked);   // '2026-08-16'

// NOT this — a UTC conversion moves the day for half the planet:
// final String wrong = picked.toUtc().toIso8601String().substring(0, 10);

// Compare on fields, never on DateTime equality:
if (DsCalendarDay.isSameDay(picked, other)) { /* ... */ }
''';

const String _compositionCode = '''
DsPopover(
  open: _open,
  side: DsPopoverSide.bottom,
  align: DsPopoverAlign.start,
  sideOffset: ds(1),
  onDismiss: () => setState(() => _open = false),
  anchor: DsButton(/* trigger */),
  content: (BuildContext context, DsPopoverAnchorMetrics metrics) =>
      DsPopoverSurface(
        child: DsCalendar.single(
          selected: value,
          autoFocus: true,
          surface: DsCalendarSurface.popover,
          onSelected: (DateTime? day) {
            onChanged?.call(day);
            setState(() => _open = false);
          },
        ),
      ),
)
''';

/// Single-selection specimen, seeded from the ambient [DsClock] so the picked
/// day is on the month the grid opens on rather than in some other month.
///
/// The readout prints the two halves of the timezone ruling as two separate
/// lines — the human label and the day key — because they are two different
/// strings serving two different jobs, and running them together in one
/// sentence would hide exactly the distinction this page is about.
class _SingleCalendarSpecimen extends StatefulWidget {
  const _SingleCalendarSpecimen();

  @override
  State<_SingleCalendarSpecimen> createState() =>
      _SingleCalendarSpecimenState();
}

class _SingleCalendarSpecimenState extends State<_SingleCalendarSpecimen> {
  DateTime? _selected;
  bool _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    _seeded = true;
    _selected = DsCalendarDay.of(DsClock.nowOf(context));
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final DateTime? selected = _selected;
    return KeyedSubtree(
      key: const ValueKey<String>('calendar-doc-single-specimen'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsCalendar.single(
            selected: selected,
            onSelected: (DateTime? day) => setState(() => _selected = day),
          ),
          SizedBox(height: ds(3)),
          if (selected == null)
            DsText(
              'Nothing selected',
              DsType.small,
              color: theme.mutedForeground,
            )
          else ...<Widget>[
            DsText(DsDateFormat.dayMonthYear(selected), DsType.small),
            SizedBox(height: ds(1)),
            DsText(
              DsDateFormat.dayKey(selected),
              DsType.small,
              color: theme.mutedForeground,
            ),
          ],
        ],
      ),
    );
  }
}

/// Range specimen, seeded today through today + 8 so the band crosses a week
/// boundary and both caps are on the opening month.
class _RangeCalendarSpecimen extends StatefulWidget {
  const _RangeCalendarSpecimen();

  @override
  State<_RangeCalendarSpecimen> createState() => _RangeCalendarSpecimenState();
}

class _RangeCalendarSpecimenState extends State<_RangeCalendarSpecimen> {
  DsDateRange? _selected;
  bool _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    _seeded = true;
    final DateTime today = DsCalendarDay.of(DsClock.nowOf(context));
    _selected = DsDateRange(from: today, to: DsCalendarDay.addDays(today, 8));
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final DsDateRange? range = _selected;
    final DateTime? from = range?.from;
    final DateTime? to = range?.to;
    final String label;
    if (from == null) {
      label = 'Nothing selected';
    } else if (to == null) {
      label = '${DsDateFormat.dayMonth(from)} – …';
    } else {
      label = '${DsDateFormat.dayMonth(from)} – ${DsDateFormat.dayMonth(to)}';
    }
    return KeyedSubtree(
      key: const ValueKey<String>('calendar-doc-range-specimen'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsCalendar.range(
            selected: range,
            onSelected: (DsDateRange? next) => setState(() => _selected = next),
          ),
          SizedBox(height: ds(3)),
          DsText(label, DsType.small),
          if (from != null && to != null) ...<Widget>[
            SizedBox(height: ds(1)),
            DsText(
              '${DsDateFormat.dayKey(from)} … ${DsDateFormat.dayKey(to)}',
              DsType.small,
              color: theme.mutedForeground,
            ),
          ],
        ],
      ),
    );
  }
}

class _DatePickerSpecimen extends StatefulWidget {
  const _DatePickerSpecimen();

  @override
  State<_DatePickerSpecimen> createState() => _DatePickerSpecimenState();
}

class _DatePickerSpecimenState extends State<_DatePickerSpecimen> {
  DateTime? _value;

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('calendar-doc-picker'),
    child: Align(
      alignment: Alignment.centerLeft,
      child: DsDatePicker(
        value: _value,
        onChanged: (DateTime? day) => setState(() => _value = day),
      ),
    ),
  );
}

/// The disabled twin — a null [DsDatePicker.onChanged], which is the only
/// per-instance disabling this family offers.
///
/// The placeholder is deliberately short: the trigger sizes to its label, and
/// a long one overflows the 390px viewport the docs test renders at.
class _DatePickerDisabledSpecimen extends StatelessWidget {
  const _DatePickerDisabledSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('calendar-doc-picker-disabled'),
    child: const Align(
      alignment: Alignment.centerLeft,
      child: DsDatePicker(
        value: null,
        onChanged: null,
        placeholder: 'Locked',
      ),
    ),
  );
}
