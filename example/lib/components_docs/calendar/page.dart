/// Public documentation page for the `calendar` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `ElSection`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button`, `field`, `table` and `stat`
/// established. Every specimen widget and every code string below is the
/// one the hand-composed page carried; only where it lives changed, plus
/// two additions: the single-selection live demo is now this page's own
/// `Preview` section (it used to render ahead of any heading with no rail
/// entry of its own), and Keyboard is split out of Accessibility into its
/// own required disclosure, carrying the same eight key rows the old
/// Accessibility panel held.
///
/// Section shape otherwise mirrors
/// `https://ui.shadcn.com/docs/components/base/calendar` section for
/// section: Preview, then Installation, Usage, Composition, About, Date
/// picker, Selected date (with timezone), Range calendar, Presets, and the
/// eight required disclosures. Persian / Hijri / Jalali Calendar, Month and
/// Year Selector, Date and Time Picker, and Booked dates have no
/// counterpart here: ElCalendar has no locale parameter, no month/year
/// dropdown or year jump, no time-of-day input, and no per-day disabled
/// predicate (the last two are named again in Accessibility's known gaps).
/// Presets, unlike those four, is buildable: ElCalendar's controlled
/// `month` / `selected` pair is exactly the seam the reference's own preset
/// buttons drive, so this page builds a specimen for it rather than
/// skipping it. Basic folds into the Preview specimen rather than
/// repeating it, because this port has only one single-date calendar shape
/// to show, not a richer dropdown-driven default plus a plain fallback.
///
/// The reference's selects page has three calendars, `ElCalendar.single` in
/// a Panel, `ElCalendar.range` in another Panel, and a `ElDatePicker`
/// inside a Popover. This page mounts those three as interactive specimens
/// with live readouts of what the reader picked, plus a fourth, the Presets
/// specimen, built new for this reshape because the reference has no
/// counterpart demo to carry forward.
///
/// Two things make calendar peculiar:
///
/// 1. **The clock must be frozen.** `ElCalendar` opens on `month ?? defaultMonth
///    ?? today`. The single and range specimens pass neither month nor
///    defaultMonth intentionally: that is what the reference does. The
///    presets specimen is the one exception, its whole point is a
///    controlled `month`, seeded from the same clock rather than left null.
///    A test that let the wall clock through would pass in August 2026 and
///    fail in September. The test harness pins a [ElClock] to a fixed date
///    and time, the same instant the capture rig freezes, so rendered
///    months are reproducible. The three seeded specimens below read that
///    same clock through [ElClock.nowOf] rather than `DateTime.now()`, so
///    the seed and the opening month can never disagree.
/// 2. **The date picker needs a real Overlay.** `ElDatePicker` mounts its
///    calendar through a `ElPopover`, which uses an `OverlayPortal`, which
///    needs a real Material `Overlay` to work. The test wraps the page in a
///    `MaterialApp` for that reason.
///
/// `calendar` ships in the registry: the Installation section discloses
/// this honestly rather than inventing a CLI command.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec calendarDocSpec = ComponentDocSpec(
  name: 'calendar',
  title: calendarDoc.title,
  description: calendarDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'ElCalendar.single, live: pick a day and the readout below '
          'prints both the human label and the day key. Range selection '
          'and the date picker each get their own section further down. '
          'Basic folds into this same demo rather than repeating it '
          'further down: this port has only one single-date calendar '
          'shape, not a richer dropdown-driven default plus a separate '
          'plain fallback.',
      specimen: const _SingleCalendarSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'calendar ships in the registry: `elattar add calendar` '
          'installs lib/src/components/calendar.dart and resolves button, '
          'icon, popover, and source-foundation automatically. The Manual '
          'tab is for a project not using the CLI.',
      command: calendarDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/calendar.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/calendar.dart's generated "
              '@ui/calendar.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated calendar source here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElCalendar, ElDatePicker, and the '
              'rest of the family are reachable the same way the CLI '
              'path already makes them.',
          code: "export 'calendar.dart';",
        ),
      ],
    ),
    const SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The three arrangements documented on this page: single '
          'selection, range selection, and the date picker; then how to '
          'store what any of them reports.',
      code: _usageCode,
    ),
    const SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          "ElDatePicker is itself the composition: a ElButton trigger, a "
          'ElPopover, and a popover-surfaced ElCalendar that autofocuses '
          'so Escape has a path back out. Illustrative — `_open`, `value` '
          'and `onChanged` are the state ElDatePicker\'s own State class '
          'owns, not defined here; see Date picker below for the live '
          'version.',
      code: _compositionCode,
    ),
    const SnippetSection(
      id: 'about',
      title: 'About',
      description:
          'ElCalendar and ElDatePicker are native Flutter widgets built '
          'directly on this system\'s own foundation tokens: neither '
          'wraps a third-party date-picking package. The reference is '
          'different: it is built on top of React DayPicker, and its own '
          'About section says so. Nothing live to stage here beyond that '
          'one sentence, so this section stays prose rather than a '
          'manufactured specimen.',
      code: _aboutCode,
    ),
    ShowcaseSection(
      id: 'date-picker',
      title: 'Date picker',
      description:
          'The reference splits this into its own page: a Calendar '
          'wrapped in a Popover behind a Button. This port keeps both '
          'symbols in the one source file, lib/src/components/'
          'calendar.dart, so the specimen lives here rather than behind '
          'a second page. Enabled opens on tap; Disabled passes a null '
          'onChanged, the only per-instance disabling the family offers.',
      specimen: const _DatePickerSpecimen(),
      code: _datePickerCode,
      label: 'Date picker specimen view',
      minHeight: el(160),
    ),
    const SnippetSection(
      id: 'selected-date-timezone',
      title: 'Selected date (with timezone)',
      description:
          'The reference demonstrates hydration-safe timezone handling '
          'for a controlled Calendar. Flutter has no hydration step, but '
          'the same underlying trap is real here too: a calendar date is '
          'not an instant. ElDateFormat.dayKey builds "2026-08-16" out of '
          'the local year, month, and day fields. It never calls '
          'toIso8601String() and never converts to UTC, because both of '
          'those turn a day into a moment and a moment reads back as a '
          'different day depending on where the reader is standing. The '
          'bug this prevents, concretely: a reader in New York picks 16 '
          'August and the app stores date.toUtc().toIso8601String(), '
          'which is 2026-08-16T04:00:00Z. Read back in London that is '
          'still the 16th, so the bug hides. Now the New York reader '
          'picks a date and the app stores it at local midnight, '
          '2026-08-16T00:00:00-04:00, i.e. 2026-08-16T04:00:00Z: while a '
          'reader in Los Angeles storing the same calendar day writes '
          '2026-08-16T07:00:00Z, and a reader in Tokyo writes '
          '2026-08-15T15:00:00Z. Slice the date half off any of those '
          'ISO strings after a UTC conversion and one of the three reads '
          'back as the 15th. The day the reader tapped is gone, and it '
          'is gone only for some readers, which is why this class of bug '
          'survives review. So: report and store '
          'ElDateFormat.dayKey(date). Compare with '
          'ElCalendarDay.isSameDay, never with DateTime equality. The '
          'Preview specimen at the top of this page prints both halves: '
          'the human label and the key: so the difference is visible '
          'rather than asserted, which is why this section stays '
          'code-only rather than repeating that same live grid a third '
          'time.',
      code: _dayKeyCode,
    ),
    ShowcaseSection(
      id: 'range-calendar',
      title: 'Range calendar',
      description:
          'ElCalendar.range: two taps set a from/to pair, and a third '
          're-homes it. One month renders at a time; the reference\'s own '
          'Range Calendar demo spans two months side by side, which this '
          'port does not do, there is no numberOfMonths parameter.',
      specimen: const _RangeCalendarSpecimen(),
      code: _rangeCode,
      label: 'Range calendar specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'presets',
      title: 'Presets',
      description:
          'The reference pairs its calendar with quick-pick buttons that '
          'set the selected day without the reader touching the grid at '
          'all. ElCalendar has no built-in preset row, but the same '
          'controlled month/selected API the date picker composition '
          'already uses covers it: this specimen owns the state, and '
          'each button just calls onSelected with a computed day.',
      specimen: const _PresetsSpecimen(),
      code: _presetsCode,
      label: 'Presets specimen view',
      minHeight: el(160),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every public class, enum, static, and constructor parameter '
          'the source declares: plus the half of source-foundation this '
          'component cannot be understood without. The reference has no '
          'formal props table on this page and defers to the React '
          'DayPicker docs instead; ElCalendar owns every one of its props '
          'outright, so this table stays in full, including the two '
          'enums, mode and surface, that an earlier draft gave their own '
          'Variants heading.',
      children: const <DocsTocEntry>[
        DocsTocEntry(
          title: 'ElCalendar.single / .range: parameters',
          anchor: 'api-elcalendar-ctor',
        ),
        DocsTocEntry(title: 'ElCalendar: resolved fields', anchor: 'api-elcalendar'),
        DocsTocEntry(title: 'ElCalendar: statics', anchor: 'api-elcalendar-static'),
        DocsTocEntry(title: 'ElDateRange', anchor: 'api-eldaterange'),
        DocsTocEntry(title: 'ElCalendarDay', anchor: 'api-elcalendarday'),
        DocsTocEntry(title: 'ElCalendarMonth', anchor: 'api-elcalendarmonth'),
        DocsTocEntry(
          title: 'ElCalendarBandPainter',
          anchor: 'api-elcalendarbandpainter',
        ),
        DocsTocEntry(title: 'ElDatePicker', anchor: 'api-eldatepicker'),
        DocsTocEntry(title: 'ElDateFormat', anchor: 'api-eldateformat'),
        DocsTocEntry(
          title: 'ElClock and ElCalendarType',
          anchor: 'api-elclock',
        ),
        DocsTocEntry(title: 'ElCalendarMode', anchor: 'api-elcalendarmode'),
        DocsTocEntry(
          title: 'ElCalendarSurface',
          anchor: 'api-elcalendarsurface',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description:
          'The day-key-versus-instant ruling has its own section, '
          'Selected date (with timezone): this covers semantics and the '
          'gaps that remain. Keyboard has its own required disclosure, '
          'directly below.',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          "Every key the grid's single FocusNode answers, driven on the "
          'live reference and reproduced in `_ElCalendarState._onKey`.',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
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
                "The package's own suite, run against the same frozen "
                "instant this page's tests use.",
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/calendar_test.dart',
            description:
                'Covers this page: the API tables, all four live '
                'specimens, the frozen-clock ruling, and both viewport '
                'widths in both themes.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/calendar/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class CalendarDocPage extends StatelessWidget {
  const CalendarDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: calendarDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: calendarDoc.title,
      description: calendarDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Calendar'),
    ],
    toc: calendarDocSpec.toc,
    previous: const DocsPageLink(title: 'Select', route: '/components/select'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('calendar-doc-article'),
      child: ComponentDocPage(spec: calendarDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

const String _previewCode = '''ElCalendar.single(
  selected: selectedDate,
  onSelected: (DateTime? day) => setState(() => selectedDate = day),
)''';

const String _usageCode = '''
ElCalendar.single(
  selected: selectedDate,
  onSelected: (DateTime? day) => setState(() => selectedDate = day),
)

ElCalendar.range(
  selected: selectedRange,
  onSelected: (ElDateRange? range) => setState(() => selectedRange = range),
)

ElDatePicker(
  value: pickedDate,
  onChanged: (DateTime? day) => setState(() => pickedDate = day),
)

// Store the day the reader tapped, not the moment your process was in.
final String key = ElDateFormat.dayKey(picked);   // '2026-08-16'

// NOT this: a UTC conversion moves the day for half the planet:
// final String wrong = picked.toUtc().toIso8601String().substring(0, 10);

// Compare on fields, never on DateTime equality:
if (ElCalendarDay.isSameDay(picked, other)) { /* ... */ }
''';

const String _compositionCode = '''
ElPopover(
  open: _open,
  side: ElPopoverSide.bottom,
  align: ElPopoverAlign.start,
  sideOffset: el(1),
  onDismiss: () => setState(() => _open = false),
  anchor: ElButton(/* trigger */),
  content: (BuildContext context, ElPopoverAnchorMetrics metrics) =>
      ElPopoverSurface(
        child: ElCalendar.single(
          selected: value,
          autoFocus: true,
          surface: ElCalendarSurface.popover,
          onSelected: (DateTime? day) {
            onChanged?.call(day);
            setState(() => _open = false);
          },
        ),
      ),
)
''';

const String _aboutCode = '''
// ElCalendar and ElDatePicker are native Flutter widgets built directly on
// this system's own foundation tokens: neither wraps a third-party
// date-picking package.
//
// The reference is different: it is built on top of React DayPicker, and
// its own About section says so.
''';

/// Single-selection specimen, seeded from the ambient [ElClock] so the picked
/// day is on the month the grid opens on rather than in some other month.
///
/// The readout prints the two halves of the timezone ruling as two separate
/// lines: the human label and the day key: because they are two different
/// strings serving two different jobs, and running them together in one
/// sentence would hide exactly the distinction Selected date (with timezone)
/// is about.
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
    _selected = ElCalendarDay.of(ElClock.nowOf(context));
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final DateTime? selected = _selected;
    return KeyedSubtree(
      key: const ValueKey<String>('calendar-doc-single-specimen'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElCalendar.single(
            selected: selected,
            onSelected: (DateTime? day) => setState(() => _selected = day),
          ),
          SizedBox(height: el(3)),
          if (selected == null)
            ElText(
              'Nothing selected',
              ElType.small,
              color: theme.mutedForeground,
            )
          else ...<Widget>[
            ElText(ElDateFormat.dayMonthYear(selected), ElType.small),
            SizedBox(height: el(1)),
            ElText(
              ElDateFormat.dayKey(selected),
              ElType.small,
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
  ElDateRange? _selected;
  bool _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    _seeded = true;
    final DateTime today = ElCalendarDay.of(ElClock.nowOf(context));
    _selected = ElDateRange(from: today, to: ElCalendarDay.addDays(today, 8));
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final ElDateRange? range = _selected;
    final DateTime? from = range?.from;
    final DateTime? to = range?.to;
    final String label;
    if (from == null) {
      label = 'Nothing selected';
    } else if (to == null) {
      label = '${ElDateFormat.dayMonth(from)} – …';
    } else {
      label = '${ElDateFormat.dayMonth(from)} – ${ElDateFormat.dayMonth(to)}';
    }
    return KeyedSubtree(
      key: const ValueKey<String>('calendar-doc-range-specimen'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElCalendar.range(
            selected: range,
            onSelected: (ElDateRange? next) => setState(() => _selected = next),
          ),
          SizedBox(height: el(3)),
          ElText(label, ElType.small),
          if (from != null && to != null) ...<Widget>[
            SizedBox(height: el(1)),
            ElText(
              '${ElDateFormat.dayKey(from)} … ${ElDateFormat.dayKey(to)}',
              ElType.small,
              color: theme.mutedForeground,
            ),
          ],
        ],
      ),
    );
  }
}

const String _rangeCode = '''ElCalendar.range(
  selected: selectedRange,
  onSelected: (ElDateRange? range) => setState(() => selectedRange = range),
)''';

/// Preset specimen: five buttons each set the selected day directly,
/// exercising the controlled `month` / `selected` pair rather than the
/// grid's own navigation. A preset landing outside the currently displayed
/// month moves `_month` along with `_selected`, so the picked day is always
/// visible the moment a button is pressed, the same way the reference's own
/// preset buttons drive its controlled Calendar.
class _PresetsSpecimen extends StatefulWidget {
  const _PresetsSpecimen();

  @override
  State<_PresetsSpecimen> createState() => _PresetsSpecimenState();
}

class _PresetsSpecimenState extends State<_PresetsSpecimen> {
  DateTime? _selected;
  DateTime? _month;
  bool _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    _seeded = true;
    _selected = ElCalendarDay.of(ElClock.nowOf(context));
    _month = ElCalendarDay.startOfMonth(_selected!);
  }

  void _pick(int daysAhead) {
    final DateTime today = ElCalendarDay.of(ElClock.nowOf(context));
    final DateTime day = ElCalendarDay.addDays(today, daysAhead);
    setState(() {
      _selected = day;
      _month = ElCalendarDay.startOfMonth(day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final DateTime? selected = _selected;
    return KeyedSubtree(
      key: const ValueKey<String>('calendar-doc-presets-specimen'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElCalendar.single(
            selected: selected,
            month: _month,
            onSelected: (DateTime? day) => setState(() {
              _selected = day;
              if (day != null) _month = ElCalendarDay.startOfMonth(day);
            }),
            onMonthChanged: (DateTime next) => setState(() => _month = next),
          ),
          SizedBox(height: el(3)),
          Wrap(
            spacing: el(2),
            runSpacing: el(2),
            children: <Widget>[
              ElButton(
                variant: ElButtonVariant.outline,
                size: ElButtonSize.sm,
                onPressed: () => _pick(0),
                child: const Text('Today'),
              ),
              ElButton(
                variant: ElButtonVariant.outline,
                size: ElButtonSize.sm,
                onPressed: () => _pick(1),
                child: const Text('Tomorrow'),
              ),
              ElButton(
                variant: ElButtonVariant.outline,
                size: ElButtonSize.sm,
                onPressed: () => _pick(3),
                child: const Text('In 3 days'),
              ),
              ElButton(
                variant: ElButtonVariant.outline,
                size: ElButtonSize.sm,
                onPressed: () => _pick(7),
                child: const Text('In a week'),
              ),
              ElButton(
                variant: ElButtonVariant.outline,
                size: ElButtonSize.sm,
                onPressed: () => _pick(14),
                child: const Text('In 2 weeks'),
              ),
            ],
          ),
          SizedBox(height: el(3)),
          if (selected == null)
            ElText(
              'Nothing selected',
              ElType.small,
              color: theme.mutedForeground,
            )
          else
            ElText(ElDateFormat.dayMonthYear(selected), ElType.small),
        ],
      ),
    );
  }
}

const String _presetsCode = '''ElCalendar.single(
  selected: selected,
  month: month,
  onSelected: (DateTime? day) => setState(() {
    selected = day;
    if (day != null) month = ElCalendarDay.startOfMonth(day);
  }),
  onMonthChanged: (DateTime next) => setState(() => month = next),
)

ElButton(
  variant: ElButtonVariant.outline,
  size: ElButtonSize.sm,
  onPressed: () {
    final DateTime today = ElCalendarDay.of(ElClock.nowOf(context));
    final DateTime day = ElCalendarDay.addDays(today, 7); // 'In a week'
    setState(() {
      selected = day;
      month = ElCalendarDay.startOfMonth(day);
    });
  },
  child: const Text('In a week'),
)''';

/// Combined Enabled/Disabled date-picker specimen: one `ShowcaseSection` in
/// the kit holds one specimen, so both live under one heading, each
/// sub-labelled, matching how Delta and direction and Loading/error/empty
/// stack several states under one section on the `stat` page.
class _DatePickerSpecimen extends StatefulWidget {
  const _DatePickerSpecimen();

  @override
  State<_DatePickerSpecimen> createState() => _DatePickerSpecimenState();
}

class _DatePickerSpecimenState extends State<_DatePickerSpecimen> {
  DateTime? _value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ElText('Enabled', ElType.section),
      SizedBox(height: el(2)),
      KeyedSubtree(
        key: const ValueKey<String>('calendar-doc-picker'),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ElDatePicker(
            value: _value,
            onChanged: (DateTime? day) => setState(() => _value = day),
          ),
        ),
      ),
      SizedBox(height: el(5)),
      ElText('Disabled', ElType.section),
      SizedBox(height: el(2)),
      const KeyedSubtree(
        key: ValueKey<String>('calendar-doc-picker-disabled'),
        child: Align(
          alignment: Alignment.centerLeft,
          // The placeholder is deliberately short: the trigger sizes to its
          // label, and a long one overflows the 390px viewport the docs
          // test renders at.
          child: ElDatePicker(
            value: null,
            onChanged: null,
            placeholder: 'Locked',
          ),
        ),
      ),
    ],
  );
}

const String _datePickerCode = '''ElDatePicker(
  value: pickedDate,
  onChanged: (DateTime? day) => setState(() => pickedDate = day),
)

// Disabled: the only per-instance disabling the family offers.
const ElDatePicker(
  value: null,
  onChanged: null,
  placeholder: 'Locked',
)''';

const String _dayKeyCode = '''// Store the day the reader tapped, not the moment your process was in.
final String key = ElDateFormat.dayKey(picked);   // '2026-08-16'

// NOT this: a UTC conversion moves the day for half the planet:
// final String wrong = picked.toUtc().toIso8601String().substring(0, 10);

// Compare on fields, never on DateTime equality:
if (ElCalendarDay.isSameDay(picked, other)) { /* ... */ }''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elcalendar-ctor',
        child: DocsApiTable(
          title: 'ElCalendar.single / ElCalendar.range: parameters',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'selected',
              type: 'DateTime? / ElDateRange?',
              description:
                  'The picked value. DateTime? on the single constructor, '
                  'ElDateRange? on the range constructor.',
            ),
            DocsApiFact(
              name: 'onSelected',
              type:
                  'ValueChanged<DateTime?>? / ValueChanged<ElDateRange?>?',
              description:
                  'Called on every pick. Null makes the grid read-only, '
                  'there is no separate enabled flag.',
            ),
            DocsApiFact(
              name: 'month',
              type: 'DateTime?',
              description:
                  'The controlled displayed month. Non-null pins the '
                  'grid: the caller owns navigation and must respond to '
                  'onMonthChanged for the chevrons to do anything.',
            ),
            DocsApiFact(
              name: 'defaultMonth',
              type: 'DateTime?',
              description:
                  'The uncontrolled seed, read once on first build. Null '
                  "falls through to the clock's own month.",
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
              type: 'ElCalendarSurface',
              description:
                  'Defaults to card. Selects fill, border, and padding: '
                  'see the ElCalendarSurface table below.',
            ),
            DocsApiFact(
              name: 'autoFocus',
              type: 'bool',
              description:
                  'Defaults to false. True is what ElDatePicker passes '
                  'so the popover calendar takes focus and Escape has '
                  'somewhere to travel up from.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elcalendar',
        child: DocsApiTable(
          title: 'ElCalendar: the fields the two constructors resolve onto',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'mode',
              type: 'ElCalendarMode',
              description:
                  'single or range, fixed by which constructor was used. '
                  'Not a parameter: it cannot be passed or changed.',
            ),
            DocsApiFact(
              name: 'selectedDay',
              type: 'DateTime?',
              description:
                  "The single constructor's selected. Always null in "
                  'range mode.',
            ),
            DocsApiFact(
              name: 'onDaySelected',
              type: 'ValueChanged<DateTime?>?',
              description:
                  "The single constructor's onSelected. Always null in "
                  'range mode.',
            ),
            DocsApiFact(
              name: 'selectedRange',
              type: 'ElDateRange?',
              description:
                  "The range constructor's selected. Always null in "
                  'single mode.',
            ),
            DocsApiFact(
              name: 'onRangeSelected',
              type: 'ValueChanged<ElDateRange?>?',
              description:
                  "The range constructor's onSelected. Always null in "
                  'single mode.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elcalendar-static',
        child: DocsApiTable(
          title: 'ElCalendar: statics',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'cellSize',
              type: 'static double',
              description: 'One day square, 28 logical pixels.',
            ),
            DocsApiFact(
              name: 'contentWidth',
              type: 'static double',
              description:
                  "The seven-column grid before surface padding, 196 "
                  'logical pixels.',
            ),
            DocsApiFact(
              name: 'rangeBleed',
              type: 'static double',
              description:
                  "How far a range cap's square bleeds past its own cell "
                  'so the band reads as continuous across the gap.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-eldaterange',
        child: DocsApiTable(
          title: 'ElDateRange',
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
              type: 'static ElDateRange?',
              description:
                  'The whole selection rule, in one function: it decides '
                  'whether a tap opens a new range, closes the open one, '
                  'or re-homes a complete one.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elcalendarday',
        child: DocsApiTable(
          title: 'ElCalendarDay: date arithmetic on local fields',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'of',
              type: 'static DateTime',
              description:
                  'Strips the time, keeping year/month/day. Every '
                  'comparison in this component runs on the result.',
            ),
            DocsApiFact(
              name: 'startOfMonth',
              type: 'static DateTime',
              description: "The first of the day's own month.",
            ),
            DocsApiFact(
              name: 'isSameDay',
              type: 'static bool',
              description: 'Same year, month, and day: not the same instant.',
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
                  'Move by whole months, clamping the day into the '
                  'target month, 31 January plus one month is 28 '
                  'February.',
            ),
            DocsApiFact(
              name: 'daysInMonth',
              type: 'static int',
              description: '28, 29, 30, or 31.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elcalendarmonth',
        child: DocsApiTable(
          title: 'ElCalendarMonth: the grid geometry',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'leadingDays',
              type: 'int (get)',
              description:
                  'How many days of the previous month open the first '
                  'row.',
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
                  'Four, five, or six rows. August 2026 opens on a '
                  'Saturday and therefore needs six.',
            ),
            DocsApiFact(
              name: 'days',
              type: 'List<DateTime> (get)',
              description:
                  'Every cell in reading order, leading and trailing '
                  'days included.',
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
              description: 'The padding a given ElCalendarSurface adds.',
            ),
            DocsApiFact(
              name: 'borderWidthFor',
              type: 'static double',
              description: 'The border a given ElCalendarSurface draws.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elcalendarbandpainter',
        child: DocsApiTable(
          title: 'ElCalendarBandPainter: the range band and today marker',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'muted',
              type: 'Color',
              description:
                  'The one colour it paints with, for the band and the '
                  'today marker alike.',
            ),
            DocsApiFact(
              name: 'today',
              type: 'bool',
              description:
                  "This cell is the clock's own day, and takes the "
                  'grounded rounded rectangle.',
            ),
            DocsApiFact(
              name: 'selected',
              type: 'bool',
              description:
                  'This cell also carries the selected fill: which '
                  'squares off the today marker underneath it.',
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
                  'ElCalendar.rangeBleed: the square drawn past the cap '
                  'so the band meets its neighbour.',
            ),
            DocsApiFact(
              name: 'shouldRepaint',
              type: 'bool',
              description:
                  'Repaints only when one of the seven fields above '
                  'actually changed.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-eldatepicker',
        child: DocsApiTable(
          title: 'ElDatePicker',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'value',
              type: 'DateTime?',
              description:
                  'Required. The picked date, or null for the empty '
                  'state.',
            ),
            DocsApiFact(
              name: 'onChanged',
              type: 'ValueChanged<DateTime?>?',
              description:
                  'Null disables the trigger outright: the popover never '
                  'opens. This is the only per-instance disabling the '
                  'family offers.',
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
                  'Always true, and exported so the drift is assertable: '
                  "the trigger passes ElButton.suppressPressScale because "
                  "the reference's own aria-haspopup trigger does not "
                  'squish.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-eldateformat',
        child: DocsApiTable(
          title: 'ElDateFormat: source-foundation, hardcoded en-US',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'monthsShort',
              type: 'static const List<String>',
              description: 'Jan…Dec.',
            ),
            DocsApiFact(
              name: 'monthsLong',
              type: 'static const List<String>',
              description: 'January…December: what the caption prints.',
            ),
            DocsApiFact(
              name: 'weekdaysNarrow',
              type: 'static const List<String>',
              description: 'Su Mo Tu We Th Fr Sa: the header row, in order.',
            ),
            DocsApiFact(
              name: 'weekdaysLong',
              type: 'static const List<String>',
              description: 'Sunday…Saturday: used by dayLabel.',
            ),
            DocsApiFact(
              name: 'weekIndex',
              type: 'static int',
              description:
                  'date.weekday % 7: the column a date lands in, Sunday '
                  'being column zero.',
            ),
            DocsApiFact(
              name: 'dayMonth',
              type: 'static String',
              description: '"16 Aug": the range readout\'s own format.',
            ),
            DocsApiFact(
              name: 'dayMonthYear',
              type: 'static String',
              description: '"16 Aug 2026": the date picker\'s trigger label.',
            ),
            DocsApiFact(
              name: 'monthYear',
              type: 'static String',
              description: '"August 2026": the caption.',
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
                  '"2026-08-16", built from the local year/month/day '
                  'fields. The string to store: see Selected date (with '
                  'timezone) for why this is not toIso8601String().',
            ),
            DocsApiFact(
              name: 'dayLabel',
              type: 'static String',
              description:
                  '"Sunday, August 16th, 2026": every day cell\'s '
                  'accessible name.',
            ),
            DocsApiFact(
              name: 'ordinal',
              type: 'static String',
              description: '1st, 2nd, 3rd, 4th… as dayLabel needs them.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elclock',
        child: DocsApiTable(
          title: 'ElClock and ElCalendarType: source-foundation',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'now',
              type: 'DateTime',
              description:
                  'The instant this scope calls the present. An '
                  'InheritedWidget field, not a global: which is what '
                  'makes the month a test can pin.',
            ),
            DocsApiFact(
              name: 'nowOf',
              type: 'static DateTime',
              description:
                  "The nearest ElClock's now, or DateTime.now() when no "
                  'clock is mounted. What the grid and both seeded '
                  'specimens read.',
            ),
            DocsApiFact(
              name: 'maybeOf',
              type: 'static ElClock?',
              description:
                  'The scope itself, or null: for callers that need to '
                  'know whether a clock was pinned at all.',
            ),
            DocsApiFact(
              name: 'dayNumber',
              type: 'static ElTypeSpec',
              description:
                  "ElCalendarType's type spec for the digits in a day "
                  'cell.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elcalendarmode',
        child: DocsApiTable(
          title:
              'ElCalendarMode: fixed by the constructor, cannot change '
              "over an instance's life",
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'single',
              type: 'ElCalendarMode',
              description:
                  'One date. Re-picking the selected day clears it: '
                  'there is no required flag to prevent that.',
            ),
            DocsApiFact(
              name: 'range',
              type: 'ElCalendarMode',
              description:
                  'A from/to pair. One month is rendered, matching the '
                  "reference's numberOfMonths of 1.",
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elcalendarsurface',
        child: DocsApiTable(
          title:
              'ElCalendarSurface: an ordinary parameter, the surface field',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'card',
              type: 'ElCalendarSurface',
              description:
                  'The default. Fills with theme.card, adds a border and '
                  'the surface padding.',
            ),
            DocsApiFact(
              name: 'background',
              type: 'ElCalendarSurface',
              description: 'Fills with theme.background; no border.',
            ),
            DocsApiFact(
              name: 'popover',
              type: 'ElCalendarSurface',
              description:
                  'Transparent: the ElPopoverSurface around it already '
                  'paints the fill, ring, and shadow. What ElDatePicker '
                  'passes.',
            ),
          ],
        ),
      ),
    ],
  );
}

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment: 'A ghost day cell: no fill, no border.',
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
    userSignal: "The band's length is the answer.",
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
        "One roving focus ring on the grid's single FocusNode, drawn on "
        'the focused cell.',
    userSignal: 'Keyboard position is always visible.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'Pass a null onSelected (or, for the picker, a null onChanged). '
        'There is no per-day disabling: see Accessibility.',
    userSignal: 'The whole grid goes read-only, or the trigger does.',
  ),
  DocsStateFact(
    state: 'Loading / Empty / Error / Success',
    treatment:
        'N/A: the grid is computed synchronously from a month and has '
        'no async, empty, or validation state of its own.',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Month changes swap the grid without animated travel; the '
        "picker's popover transition collapses through "
        'elAnimationDuration.',
    userSignal: 'Navigation is instant.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      ElText('What the semantics tree carries', ElType.section),
      SizedBox(height: el(2)),
      ElText(
        'Every day cell is a button whose accessible name is the whole '
        'date, "Sunday, August 16th, 2026", from ElDateFormat.dayLabel: '
        'not the bare number, so a screen reader user never has to '
        'infer the month from context. The two chevrons are named "Go '
        'to the previous month" and "Go to the next month". The grid '
        'carries one FocusNode for all forty-two cells rather than '
        'forty-two nodes, so tabbing moves past the calendar in one '
        'press.',
        ElType.small,
      ),
      SizedBox(height: el(5)),
      ElText('Known gaps', ElType.section),
      SizedBox(height: el(2)),
      ElText(
        'No grid role. The cells are buttons in a Column of Rows, not a '
        'semantic grid, so assistive tech announces forty-two buttons '
        'and never announces a row or column position.',
        ElType.small,
      ),
      SizedBox(height: el(3)),
      ElText(
        'No disabled date support. There is no per-day predicate and no '
        'disabled date list of any kind: a rule such as "no dates in '
        'the past" or "weekdays only" has to be enforced by the caller '
        'after the pick, or by disabling the whole control.',
        ElType.small,
      ),
      SizedBox(height: el(3)),
      ElText(
        'No bounds. There is no minimum and no maximum date parameter, '
        'so every day of every reachable month is selectable. Combined '
        'with one-month-per-click navigation and no year jump, a date '
        'far from today is genuinely faster to type into a text field.',
        ElType.small,
      ),
      SizedBox(height: el(3)),
      ElText(
        'Touch target. A day cell is 28 by 28 logical pixels: under the '
        '44 and 48 pixel minimum that iOS and Android respectively ask '
        'for. This is a faithful port of the reference\'s own cell size, '
        'and it is a real accessibility cost on touch: it is listed '
        'here rather than quietly fixed, because changing it would put '
        'this grid out of step with the design it reproduces.',
        ElType.small,
      ),
      SizedBox(height: el(3)),
      ElText(
        'No non-visual selected or today signal. Selection and today '
        'are communicated by fill and by the band alone; neither adds a '
        'semantic selected flag or a spoken hint, so a screen reader '
        'user hears the same name for a picked day as for any other.',
        ElType.small,
      ),
      SizedBox(height: el(5)),
      ElText('Locale and the first day of the week', ElType.section),
      SizedBox(height: el(2)),
      ElText(
        'Every string this component prints is hardcoded en-US, in '
        'ElDateFormat: the month names, the weekday names, the "16 Aug '
        '2026" ordering, and the 1st/2nd/3rd ordinals. There is no '
        'locale parameter and no intl dependency: this package does not '
        'depend on intl at all, and adding it is the real work behind '
        'localising this grid, not a switch to flip.',
        ElType.small,
      ),
      SizedBox(height: el(3)),
      ElText(
        'The week always starts on Sunday. weekIndex is date.weekday % '
        '7 and the header row is a fixed list, so there is no '
        'weekStartsOn parameter to move it to Monday, which is what '
        'most of Europe, and the ISO week itself, expects. A caller '
        'needing a Monday-first grid or non-English month names cannot '
        'get either from this component today.',
        ElType.small,
      ),
    ],
  );
}

/// Read directly off `_ElCalendarState._onKey` (`lib/src/components/
/// calendar.dart`): every branch that function actually takes, driven on
/// the live reference before being ported.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const <_KeyRow>[
      _KeyRow(
        'ArrowLeft / ArrowRight',
        'Move one day back or forward, crossing week and month '
            'boundaries.',
      ),
      _KeyRow('ArrowUp / ArrowDown', 'Move one week back or forward.'),
      _KeyRow('PageUp', 'Move to the same day of the previous month.'),
      _KeyRow('PageDown', 'Move to the same day of the next month.'),
      _KeyRow('Home', 'Jump to the first day of the week row.'),
      _KeyRow('End', 'Jump to the last day of the week row.'),
      _KeyRow(
        'Enter',
        'Select the focused day: the same path a tap takes.',
      ),
      _KeyRow('Space', 'Select the focused day; identical to Enter.', last: true),
    ],
  );
}

/// One keyboard row: the key on its own line, then what it does.
///
/// The key name is deliberately **not** [ElType.label]: that spec is
/// `uppercase`, and `ElText` performs the transform on the string itself
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
    final ElThemeData theme = ElTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : el(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElText(keys, ElType.small, color: theme.actionInk),
          SizedBox(height: el(1)),
          ElText(body, ElType.small),
        ],
      ),
    );
  }
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      ElText(
        'No responsive branching: the grid reads no breakpoint and '
        'renders identically at 390 and 1440 logical pixels. Its width '
        'is intrinsic: seven 28px columns, 196px of content, about '
        '222px once the card surface adds its padding and border: which '
        'is why it fits a phone viewport without any special case.',
        ElType.small,
      ),
      SizedBox(height: el(3)),
      ElText(
        'Height is the only thing that moves, by one 28px row between a '
        'five-week and a six-week month. A caller reserving space for a '
        'calendar should reserve the six-row height, or accept the '
        'reflow when navigation crosses into a longer month.',
        ElType.small,
      ),
      SizedBox(height: el(3)),
      ElText(
        'Inside the date picker, the popover positions itself against '
        'the trigger and is clamped to the viewport by '
        'elPopoverPlacement: the calendar itself does not shrink, so on '
        'a very narrow screen the popup shifts rather than reflows.',
        ElType.small,
      ),
      SizedBox(height: el(3)),
      ElText(
        'Platform parity: Android, iOS, Web, macOS, Windows, and Linux '
        'all render the same widget tree; nothing in calendar.dart '
        'branches on platform.',
        ElType.small,
      ),
    ],
  );
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        facts: <DocsInstallFact>[
          const DocsInstallFact(
            label: 'Registry item',
            value: 'calendar',
            description:
                'registry/components/calendar.json exists and is '
                'installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/calendar.dart',
            description: 'Where a manual copy of the source belongs.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: calendarDoc.dependencies.join(', '),
            description:
                "What the shipped manifest names, read off the real "
                'imports at the top of calendar.dart: button (the date '
                "picker's outline trigger), icon (the two chevrons and "
                'the trigger glyph), popover (the date picker\'s popup), '
                'and source-foundation (colours, date_format, motion, '
                'spacing, theme, typography).',
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
                'The range band is a CustomPainter, not a fragment '
                'shader.',
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
                "This page's four live specimens and "
                'example/test/components_docs/calendar_test.dart, '
                "alongside the package's own test/calendar_test.dart.",
          ),
        ],
      ),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Popover', route: '/components/popover'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      ElText(
        'Every colour comes from the live theme: primary and '
        'primaryForeground for a selected cell, muted for the today '
        'marker and the range band, mutedForeground for outside days '
        'and the weekday header, card or background for the surface. '
        'Flipping ElThemeController re-resolves all of them; nothing is '
        'cached and no colour is hardcoded.',
        ElType.small,
      ),
      SizedBox(height: el(3)),
      ElText(
        'The band painter takes its one colour as a parameter rather '
        'than reading the theme itself, so the same painter draws '
        'correctly in both themes and can be reused against any '
        'surface.',
        ElType.small,
      ),
      SizedBox(height: el(3)),
      ElText(
        'Type comes from ElCalendarType: dayNumber for the digits, and '
        'the caption and weekday specs beside it: so a type-scale '
        'change moves the calendar with the rest of the system.',
        ElType.small,
      ),
    ],
  );
}
