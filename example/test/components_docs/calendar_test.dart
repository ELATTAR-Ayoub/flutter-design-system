/// Tests for `components_docs/calendar/meta.dart` and
/// `components_docs/calendar/page.dart`: the public Calendar component
/// documentation page.
///
/// **The clock is frozen, and it has to be.** `DsCalendar` opens on
/// `month ?? defaultMonth ?? today`, and the page's three specimens pass
/// neither of the first two on purpose: that is the reference's own
/// `getInitialMonth`, and reproducing it is the point. A test that let the
/// wall clock through would pass in August 2026 and fail in September, so
/// every widget test below mounts the page under a [DsClock] pinned to
/// **16 August 2026**, a Sunday, in a six-row month. That is the same seam
/// `example/lib/main.dart` exposes as `?clock=<ISO-8601>` and the same
/// instant `test/calendar_test.dart` runs the package's own suite on.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never a synthetic `MediaQuery`: the
/// discipline `popover_test.dart` already carries. Theme coverage flips one
/// live `DsThemeController` in place rather than pumping two trees.
///
/// `DsDatePicker` mounts its calendar through a `DsPopover`, which needs a
/// real `Overlay`, so the harness wraps the page in a `MaterialApp`: the
/// same fix the `popover` and `select` pages needed.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/calendar/meta.dart';
import 'package:example/components_docs/calendar/page.dart';
import 'package:example/kit.dart' show DsSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The frozen instant every widget test in this file runs on.
///
/// 16 August 2026 is a Sunday; August 2026 opens on a Saturday and therefore
/// renders **six** week rows with 26–31 July leading it, which is why the day
/// numbers 26–31 and 1–5 each appear twice in one grid and 6–25 appear once.
/// Every day this file taps is drawn from the unique half.
final DateTime _frozen = DateTime(2026, 8, 16, 2, 15);

Future<DsThemeController> _pumpCalendarDoc(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  DsThemeMode mode = DsThemeMode.dark,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final DsThemeController theme = DsThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    // Above `MaterialApp`, exactly where `main.dart` puts it: a popover's
    // content is a sibling of `home` rather than a descendant, and the
    // calendar inside the date picker must resolve the same "now" as the two
    // on the page.
    DsClock(
      now: _frozen,
      child: DsTheme(
        controller: theme,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: SingleChildScrollView(
              child: CalendarDocPage(onNavigate: onNavigate),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

/// One 28px day cell: the `SizedBox` `_DayCell` wraps itself in, which is the
/// only `DsCalendar.cellSize` square that ever contains a digit (the weekday
/// header squares hold `Su`…`Sa` and the nav squares hold a glyph).
Finder _dayCell(Finder within, String day) => find.descendant(
  of: within,
  matching: find.ancestor(
    of: find.text(day),
    matching: find.byWidgetPredicate(
      (Widget widget) =>
          widget is SizedBox && widget.width == DsCalendar.cellSize,
    ),
  ),
);

Finder _specimen(String key) => find.byKey(ValueKey<String>(key));

Future<void> _tapDay(WidgetTester tester, Finder cell) async {
  await tester.ensureVisible(cell.first);
  await tester.pump();
  await tester.tap(cell.first);
  await tester.pump();
}

void main() {
  group('meta', () {
    test('calendarDoc names the real public API surface', () {
      expect(calendarDoc.name, 'calendar');
      expect(calendarDoc.title, 'Calendar');
      expect(calendarDoc.route, '/components/calendar');
      expect(calendarDoc.command, 'elattar add calendar');
      expect(calendarDoc.sourcePath, 'lib/src/components/calendar.dart');
      expect(
        calendarDoc.exports,
        containsAll(<String>[
          'DsCalendar',
          'DsCalendarMode',
          'DsCalendarSurface',
          'DsDateRange',
          'DsCalendarDay',
          'DsCalendarMonth',
          'DsCalendarBandPainter',
          'DsDatePicker',
        ]),
      );
      // The real imports of lib/src/components/calendar.dart, mapped onto
      // registry item names that exist today: foundation (which carries
      // date_format.dart, and therefore DsDateFormat, DsClock and
      // DsCalendarType), button, icon (which ships icon_paths.dart too), and
      // popover. Nothing invented: `calendar` has no manifest of its own and
      // this list is what one would have to name.
      expect(calendarDoc.dependencies, <String>[
        'source-foundation',
        'button',
        'icon',
        'popover',
      ]);
      expect(calendarDoc.description.trim(), calendarDoc.description);
      expect(calendarDoc.description, isNotEmpty);
      // The expanded description answers "instead of which neighbour", and is
      // a distinct constant rather than a restatement of the short one.
      expect(
        calendarExpandedDescription,
        isNot(equals(calendarDoc.description)),
      );
      expect(calendarExpandedDescription.trim(), calendarExpandedDescription);
      expect(calendarExpandedDescription, contains('date picker'));
      expect(calendarExpandedDescription, contains('text field'));
    });
  });

  group('rendered page', () {
    testWidgets(
      'sections render in the shadcn-mirrored order, section for section',
      (WidgetTester tester) async {
        await _pumpCalendarDoc(tester);

        final List<String> titles = tester
            .widgetList<DsSection>(find.byType(DsSection))
            .map((DsSection section) => section.title)
            .toList();

        expect(titles, <String>[
          'Installation',
          'Usage',
          'Composition',
          'About',
          'Date picker',
          'Selected date (with timezone)',
          'Range calendar',
          'Presets',
          'API Reference',
          'States',
          'Accessibility',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ]);
      },
    );

    testWidgets('renders the article and all four live specimens', (
      WidgetTester tester,
    ) async {
      await _pumpCalendarDoc(tester);

      expect(_specimen('calendar-doc-article'), findsOneWidget);
      expect(_specimen('calendar-doc-single-specimen'), findsOneWidget);
      expect(_specimen('calendar-doc-range-specimen'), findsOneWidget);
      expect(_specimen('calendar-doc-presets-specimen'), findsOneWidget);
      expect(_specimen('calendar-doc-picker'), findsOneWidget);
      // single, range and presets render a grid up front; the date picker's
      // own calendar stays unmounted until its popover opens.
      expect(find.byType(DsCalendar), findsNWidgets(3));
      expect(find.byType(DsDatePicker), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });

    testWidgets('the frozen clock decides the opening month, not the seeded '
        'selection', (WidgetTester tester) async {
      await _pumpCalendarDoc(tester);

      // The single and range specimens pass neither `month` nor
      // `defaultMonth`; the presets specimen seeds its controlled `month`
      // from the same clock. All three open on the clock's month: three
      // captions, one per calendar.
      expect(find.text('August 2026'), findsNWidgets(3));
      expect(find.text('July 2026'), findsNothing);
      // Su Mo Tu We Th Fr Sa: Sunday first, hardcoded.
      for (final String weekday in DsDateFormat.weekdaysNarrow) {
        expect(find.text(weekday), findsNWidgets(3));
      }
    });

    testWidgets('the API tables document every public member found in the '
        'source', (WidgetTester tester) async {
      await _pumpCalendarDoc(tester);

      const List<String> members = <String>[
        // DsCalendar.single / DsCalendar.range constructor parameters.
        'selected',
        'onSelected',
        'month',
        'defaultMonth',
        'onMonthChanged',
        'surface',
        'autoFocus',
        // The fields the two constructors resolve onto.
        'mode',
        'selectedDay',
        'onDaySelected',
        'selectedRange',
        'onRangeSelected',
        // DsCalendar's statics.
        'cellSize',
        'contentWidth',
        'rangeBleed',
        // DsDateRange.
        'from',
        'to',
        'isComplete',
        'includes',
        'isStart',
        'isEnd',
        'isMiddle',
        'addToRange',
        // DsCalendarDay.
        'of',
        'startOfMonth',
        'isSameDay',
        'isSameMonth',
        'addDays',
        'addMonths',
        'daysInMonth',
        // DsCalendarMonth.
        'leadingDays',
        'dayCount',
        'weekCount',
        'days',
        'gridHeight',
        'outerHeight',
        'paddingFor',
        'borderWidthFor',
        // DsCalendarBandPainter.
        'muted',
        'today',
        'rangeStart',
        'rangeEnd',
        'radius',
        'bleed',
        'shouldRepaint',
        // DsDatePicker.
        'value',
        'onChanged',
        'placeholder',
        'focusNode',
        'label',
        'pressScaleSuppressed',
        // DsDateFormat, DsClock and DsCalendarType: source-foundation, and
        // the half of it this component cannot be understood without.
        'monthsShort',
        'monthsLong',
        'weekdaysNarrow',
        'weekdaysLong',
        'weekIndex',
        'dayMonth',
        'dayMonthYear',
        'monthYear',
        'weekdayNarrow',
        'dayKey',
        'dayLabel',
        'ordinal',
        'now',
        'nowOf',
        'maybeOf',
        'dayNumber',
      ];

      for (final String member in members) {
        expect(
          find.text(member),
          findsWidgets,
          reason: '$member is missing from the API tables',
        );
      }

      // The two enums, value by value.
      for (final String value in <String>[
        'single',
        'range',
        'background',
        'card',
        'popover',
      ]) {
        expect(
          find.text(value),
          findsWidgets,
          reason: 'enum value $value is missing from the Variants section',
        );
      }
    });

    testWidgets('installation states plainly that the CLI cannot install this '
        'component yet', (WidgetTester tester) async {
      await _pumpCalendarDoc(tester);

      expect(find.text('Not available yet'), findsWidgets);
      expect(find.textContaining('elattar add calendar'), findsWidgets);
      expect(find.textContaining('registry'), findsWidgets);
    });
  });

  group('the timezone ruling: the thing this page exists to teach', () {
    testWidgets('the page explains why a day key is built from local fields '
        'and never sliced off an ISO instant', (WidgetTester tester) async {
      await _pumpCalendarDoc(tester);

      expect(find.textContaining('toIso8601String'), findsWidgets);
      expect(find.textContaining('dayKey'), findsWidgets);
      expect(find.textContaining('UTC'), findsWidgets);
      // The bug is stated where it bites and where it hides, by name.
      expect(find.textContaining('New York'), findsWidgets);
      expect(find.textContaining('London'), findsWidgets);
    });

    testWidgets('the live readout prints the day key the ruling produces', (
      WidgetTester tester,
    ) async {
      await _pumpCalendarDoc(tester);

      // Seeded from the clock, so it is on screen rather than in some other
      // month: 16 Aug 2026, printed both ways.
      expect(
        find.descendant(
          of: _specimen('calendar-doc-single-specimen'),
          matching: find.text('16 Aug 2026'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: _specimen('calendar-doc-single-specimen'),
          matching: find.text('2026-08-16'),
        ),
        findsOneWidget,
      );
    });
  });

  group('locale and first day of week', () {
    testWidgets('the page reports the hardcoded en-US strings as a real '
        'limit', (WidgetTester tester) async {
      await _pumpCalendarDoc(tester);

      expect(find.textContaining('en-US'), findsWidgets);
      expect(find.textContaining('Sunday'), findsWidgets);
      expect(find.textContaining('intl'), findsWidgets);
      expect(find.textContaining('weekStartsOn'), findsWidgets);
    });
  });

  group('keyboard, bounds and accessibility findings', () {
    testWidgets('the keyboard table names every key the grid actually '
        'handles', (WidgetTester tester) async {
      await _pumpCalendarDoc(tester);

      for (final String key in <String>[
        'PageUp',
        'PageDown',
        'Home',
        'End',
        'Enter',
        'Space',
      ]) {
        expect(
          find.textContaining(key),
          findsWidgets,
          reason: '$key is missing from the keyboard documentation',
        );
      }
    });

    testWidgets('the gaps are reported plainly rather than idealised', (
      WidgetTester tester,
    ) async {
      await _pumpCalendarDoc(tester);

      // No grid/table role, no non-visual selected or today signal, no
      // min/max bounds, no per-day disabling, and a 28px touch target.
      expect(find.textContaining('grid role'), findsWidgets);
      expect(find.textContaining('disabled date'), findsWidgets);
      expect(find.textContaining('minimum'), findsWidgets);
      expect(find.textContaining('28'), findsWidgets);
    });

    testWidgets('the accessible day label really is the whole date, not the '
        'number', (WidgetTester tester) async {
      await _pumpCalendarDoc(tester);

      final Set<String> labels = tester
          .widgetList<Semantics>(find.byType(Semantics))
          .map((Semantics node) => node.properties.label)
          .whereType<String>()
          .toSet();
      // 16 Aug 2026 is the frozen today, and both calendars render it.
      expect(labels, contains('Sunday, August 16th, 2026'));
      expect(labels, contains('Go to the previous month'));
      expect(labels, contains('Go to the next month'));
    });
  });

  group('live specimen: single selection', () {
    testWidgets('tapping a day reports it, and the readout follows', (
      WidgetTester tester,
    ) async {
      await _pumpCalendarDoc(tester);

      final Finder specimen = _specimen('calendar-doc-single-specimen');
      await _tapDay(tester, _dayCell(specimen, '18'));

      expect(
        find.descendant(of: specimen, matching: find.text('18 Aug 2026')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: specimen, matching: find.text('2026-08-18')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('re-picking the selected day clears it: mode="single" '
        'without required', (WidgetTester tester) async {
      await _pumpCalendarDoc(tester);

      final Finder specimen = _specimen('calendar-doc-single-specimen');
      await _tapDay(tester, _dayCell(specimen, '18'));
      expect(
        find.descendant(of: specimen, matching: find.text('18 Aug 2026')),
        findsOneWidget,
      );

      await _tapDay(tester, _dayCell(specimen, '18'));
      expect(
        find.descendant(of: specimen, matching: find.text('18 Aug 2026')),
        findsNothing,
      );
      expect(
        find.descendant(of: specimen, matching: find.text('Nothing selected')),
        findsOneWidget,
      );
    });

    testWidgets('the previous-month button moves the caption and the grid', (
      WidgetTester tester,
    ) async {
      await _pumpCalendarDoc(tester);

      final Finder specimen = _specimen('calendar-doc-single-specimen');
      final Finder previous = find
          .descendant(of: specimen, matching: find.byType(DsIcon))
          .first;
      await tester.ensureVisible(previous);
      await tester.pump();
      await tester.tap(previous);
      await tester.pump();

      expect(
        find.descendant(of: specimen, matching: find.text('July 2026')),
        findsOneWidget,
      );
    });
  });

  group('live specimen: range selection', () {
    testWidgets('the seeded range prints its own label, and a click moves the '
        'end', (WidgetTester tester) async {
      await _pumpCalendarDoc(tester);

      final Finder specimen = _specimen('calendar-doc-range-specimen');
      // Seeded from the clock: today through today + 8, so the band wraps a
      // week boundary and both caps are on screen.
      expect(
        find.descendant(of: specimen, matching: find.text('16 Aug – 24 Aug')),
        findsOneWidget,
      );

      // 19 Aug is inside the range and is neither end, so `addToRange` moves
      // the `to` onto it.
      await _tapDay(tester, _dayCell(specimen, '19'));
      expect(
        find.descendant(of: specimen, matching: find.text('16 Aug – 19 Aug')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('live specimen: presets', () {
    testWidgets('a preset button sets the selected day and follows it to a '
        'new month when needed', (WidgetTester tester) async {
      await _pumpCalendarDoc(tester);

      final Finder specimen = _specimen('calendar-doc-presets-specimen');
      // Seeded from the clock: 16 Aug 2026.
      expect(
        find.descendant(of: specimen, matching: find.text('16 Aug 2026')),
        findsOneWidget,
      );

      final Finder inThreeDays = find.descendant(
        of: specimen,
        matching: find.text('In 3 days'),
      );
      await tester.ensureVisible(inThreeDays);
      await tester.pump();
      await tester.tap(inThreeDays);
      await tester.pump();

      // 16 Aug + 3 days = 19 Aug, still the displayed month, so the caption
      // does not move.
      expect(
        find.descendant(of: specimen, matching: find.text('19 Aug 2026')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: specimen, matching: find.text('August 2026')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('tapping a day in the grid updates the readout the same as a '
        'preset does', (WidgetTester tester) async {
      await _pumpCalendarDoc(tester);

      final Finder specimen = _specimen('calendar-doc-presets-specimen');
      await _tapDay(tester, _dayCell(specimen, '21'));

      expect(
        find.descendant(of: specimen, matching: find.text('21 Aug 2026')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('live specimen: the date picker', () {
    testWidgets('the trigger opens a popover carrying a real calendar, and '
        'picking a day closes it', (WidgetTester tester) async {
      await _pumpCalendarDoc(tester);

      final Finder trigger = find
          .descendant(
            of: _specimen('calendar-doc-picker'),
            matching: find.byType(DsButton),
          )
          .first;
      await tester.ensureVisible(trigger);
      await tester.pump();
      expect(find.byType(DsPopoverSurface), findsNothing);

      await tester.tap(trigger);
      await tester.pump();
      await tester.pump();
      await tester.pump(DsDurations.overlay);
      await tester.pump();

      expect(find.byType(DsPopoverSurface), findsOneWidget);
      final Finder popup = find.descendant(
        of: find.byType(DsPopoverSurface),
        matching: find.byType(DsCalendar),
      );
      expect(popup, findsOneWidget);
      expect(
        tester.widget<DsCalendar>(popup).surface,
        DsCalendarSurface.popover,
      );

      await tester.tap(_dayCell(find.byType(DsPopoverSurface), '21').first);
      await tester.pump();
      await tester.pump();
      await tester.pump(DsDurations.overlay);
      await tester.pump(DsDurations.tick);
      await tester.pump();

      expect(find.byType(DsPopoverSurface), findsNothing);
      expect(find.text('21 Aug 2026'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the disabled twin opens nothing', (WidgetTester tester) async {
      await _pumpCalendarDoc(tester);

      final Finder disabled = find
          .descendant(
            of: _specimen('calendar-doc-picker-disabled'),
            matching: find.byType(DsButton),
          )
          .first;
      await tester.ensureVisible(disabled);
      await tester.pump();
      await tester.tap(disabled, warnIfMissed: false);
      await tester.pump();
      await tester.pump();
      await tester.pump(DsDurations.overlay);

      expect(find.byType(DsPopoverSurface), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('navigation', () {
    testWidgets('the previous link fires onNavigate with an already-routed '
        'neighbour', (WidgetTester tester) async {
      String? destination;
      await _pumpCalendarDoc(
        tester,
        onNavigate: (String route) => destination = route,
      );

      await tester.ensureVisible(find.text('Select').first);
      await tester.pump();
      await tester.tap(find.text('Select').first);
      expect(destination, '/components/select');
    });
  });

  group('viewport widths', () {
    testWidgets('1440x900 exposes the sidebar and the table of contents', (
      WidgetTester tester,
    ) async {
      await _pumpCalendarDoc(tester, size: _wide);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
        findsOneWidget,
      );
      expect(_specimen('calendar-doc-article'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('390x844 drops to the anchor strip and still renders a live '
        'grid', (WidgetTester tester) async {
      await _pumpCalendarDoc(tester, size: _narrow);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsOneWidget,
      );
      expect(_specimen('calendar-doc-article'), findsOneWidget);
      // 222px of calendar fits inside a 390px viewport without overflow.
      expect(find.byType(DsCalendar), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });
  });

  group('both themes', () {
    testWidgets('renders on light', (WidgetTester tester) async {
      await _pumpCalendarDoc(tester, mode: DsThemeMode.light);
      expect(_specimen('calendar-doc-single-specimen'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpCalendarDoc(tester, mode: DsThemeMode.dark);
      expect(_specimen('calendar-doc-single-specimen'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page and the grid '
        'intact', (WidgetTester tester) async {
      final DsThemeController theme = await _pumpCalendarDoc(
        tester,
        mode: DsThemeMode.dark,
      );
      expect(find.byType(DsCalendar), findsNWidgets(3));

      theme.setMode(DsThemeMode.light);
      await tester.pump();

      expect(find.byType(DsCalendar), findsNWidgets(3));
      expect(find.text('August 2026'), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });

    testWidgets('a narrow light viewport is covered too', (
      WidgetTester tester,
    ) async {
      await _pumpCalendarDoc(tester, size: _narrow, mode: DsThemeMode.light);
      expect(_specimen('calendar-doc-article'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
