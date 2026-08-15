/// `/design-system/components/base/selection` — the page, against the numbers
/// the reference actually renders.
///
/// Two harnesses, and the split is load-bearing:
///
///  * [pumpSelectionInShell] mounts the real `DocsShell` at the 1440 × 900
///    reference frame and hands back the reading column's `RenderBox`. Every
///    oracle number below is measured from that origin, **pristine** — nothing
///    clicked, nothing dragged — which is the state the reference was measured
///    in.
///  * [pumpSelectionPage] mounts the page alone in a tall frame so every
///    specimen is laid out and hit-testable at once. Seventeen of the twenty
///    respond to a pointer, and this file's job is to prove it.
///
/// The oracle was read off `http://localhost:3000` at 1440 × 900 on 2026-08-15
/// with `getBoundingClientRect()`, in document coordinates; the reading column
/// starts 112px down (`main` at 64 plus its own `py-12`), so every number here
/// is the measured top less 112.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/selection.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/* ── The frame and the oracle ────────────────────────────────────────────── */

/// The behaviour frame: tall enough to lay the whole page out at once, so
/// nothing needs scrolling into view before it can be tapped.
const Size _desktop = Size(1440, 6000);

/// The frame the reference is measured at, and the only width these numbers
/// mean anything at.
const Size _referenceFrame = Size(1440, 900);

const String _route = '$dsRoot/components/base/selection';

/// `--width-content` — the reading column every wrap on the page follows.
const double _columnWidth = 1080;

/// Where the reading column starts in the reference's document coordinates:
/// `main` at 64, plus its own 48px of top padding.
const double _columnTop = 112;

/// Each `section[id]`, as `(document top, border-box height)`.
///
/// Measured pristine. The heights are the CSS border box, so `mb-20` — which
/// this port pays as padding inside the section's own box — comes back off
/// before comparing.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'checkbox': (top: 527.84, height: 922.03),
  'radio': (top: 1529.88, height: 632.19),
  'switch': (top: 2242.06, height: 534.30),
  'slider': (top: 2856.36, height: 541.19),
  'api': (top: 3477.55, height: 274.80),
  'rules': (top: 3832.34, height: 350.80),
};

/// The four filter-list checkboxes (`id="f-…"`, 20px each) and the three
/// withdrawal radios (`id="w-…"`, 20px), in document coordinates.
const List<double> _filterTops = <double>[852.9, 892.9, 932.9, 972.9];
const List<double> _withdrawalTops = <double>[1848.7, 1942, 2035.3];

/// The four preference switches (`id="sw-…"`), which are `h-6` — 24px.
const List<double> _switchTops = <double>[2548.5, 2605.9, 2663.3, 2720.7];

/// One bulk row: `px-4 py-3` around a 20px box — 12 + 20 + 12.
const double _bulkRowHeight = 44;

/// `section.mb-20` — 80px, paid as padding inside the section's own box
/// because Flutter has no margins.
final double _sectionGap = ds(20);

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

  /// The page alone, laid out tall, under reduced motion.
  ///
  /// `MediaQuery(disableAnimations: true)` sits **below** `MaterialApp` so the
  /// framework's own does not win, and the body `DefaultTextStyle` the shell
  /// installs is brought along — without it every colour-inheriting string
  /// renders the framework's debug ink.
  Future<void> pumpSelectionPage({DsThemeMode mode = DsThemeMode.light}) async {
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
                  child: const SingleChildScrollView(child: SelectionPage()),
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
/// `main.dart` is the supervisor's at integration (ruling L13 keeps the route
/// on a placeholder until the family lands), so the page is handed to the shell
/// directly rather than looked up through `pageFor`.
Future<RenderBox> pumpSelectionInShell(
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

  const Widget page = SelectionPage();
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
  // No settle: geometry is settled on the first laid-out frame, and PRISTINE
  // is the state the oracle was measured in — nothing toggled, nothing
  // dragged, no slider touched.
  await tester.pump();

  return tester.renderObject<RenderBox>(find.byWidget(page));
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

Finder _inPanel(String label, Finder matching) =>
    find.descendant(of: _panel(label), matching: matching);

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
  return (top: box.top, height: box.height - _sectionGap);
}

List<({double top, double height})> _boxesOf(
  WidgetTester tester,
  RenderBox origin,
  Finder finder,
) =>
    tester
        .renderObjectList<RenderBox>(finder)
        .map((RenderBox box) => (
              top: box.localToGlobal(Offset.zero, ancestor: origin).dy,
              height: box.size.height,
            ))
        .toList();

/// The row background [_BulkRow] paints — the `ColoredBox` inside it, which is
/// the whole of drift 3's evidence.
Finder _bulkRows() => find.descendant(
      of: _panel('Bulk selection header'),
      matching: find.byType(ColoredBox),
    );

/// The row fills only — the `DsPanel` paints a `ColoredBox` of its own, and a
/// row is the one that measures 44 tall.
List<Color> _bulkFills(WidgetTester tester) {
  final List<Color> fills = <Color>[];
  final Finder rows = _bulkRows();
  for (int i = 0; i < rows.evaluate().length; i++) {
    final RenderBox box = tester.renderObject<RenderBox>(rows.at(i));
    if ((box.size.height - _bulkRowHeight).abs() > _fineTolerance) continue;
    fills.add(tester.widget<ColoredBox>(rows.at(i)).color);
  }
  return fills;
}

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
      final RenderBox column = await pumpSelectionInShell(tester);
      expect(column.size.width, _columnWidth);
    });

    testWidgets('every section starts and ends where the reference does',
        (WidgetTester tester) async {
      final RenderBox column = await pumpSelectionInShell(tester);

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

    testWidgets('the filter list stacks on the reference\'s rows',
        (WidgetTester tester) async {
      final RenderBox column = await pumpSelectionInShell(tester);
      final List<({double top, double height})> rows = _boxesOf(
        tester,
        column,
        _inPanel('In a filter list', find.byType(DsCheckbox)),
      );

      expect(rows, hasLength(4));
      for (int i = 0; i < rows.length; i++) {
        expect(rows[i].top, closeTo(_filterTops[i] - _columnTop, _fineTolerance),
            reason: 'filter row $i');
        expect(rows[i].height, DsCheckbox.size,
            reason: '`size-5` — 20px, whatever the row around it does');
      }
    });

    testWidgets('the withdrawal radios stack on the reference\'s rows',
        (WidgetTester tester) async {
      final RenderBox column = await pumpSelectionInShell(tester);
      final List<({double top, double height})> rows = _boxesOf(
        tester,
        column,
        _inPanel('Withdrawal method', find.byType(DsRadioGroupItem<String>)),
      );

      expect(rows, hasLength(3));
      for (int i = 0; i < rows.length; i++) {
        expect(rows[i].top,
            closeTo(_withdrawalTops[i] - _columnTop, _fineTolerance),
            reason: 'withdrawal card $i');
        expect(rows[i].height, DsRadioGroupItem.size);
      }
    });

    testWidgets('the preference switches stack on the reference\'s rows',
        (WidgetTester tester) async {
      final RenderBox column = await pumpSelectionInShell(tester);
      final List<({double top, double height})> rows = _boxesOf(
        tester,
        column,
        _inPanel('Notification preferences', find.byType(DsSwitch)),
      );

      expect(rows, hasLength(4));
      for (int i = 0; i < rows.length; i++) {
        expect(rows[i].top, closeTo(_switchTops[i] - _columnTop, _fineTolerance),
            reason: 'preference row $i');
        expect(rows[i].height, DsSwitchSize.md.trackHeight,
            reason: '`h-6` — 24px');
      }
    });

    testWidgets('the bulk header is 512 x 271 — six 44px rows and five seams',
        (WidgetTester tester) async {
      final RenderBox column = await pumpSelectionInShell(tester);
      // 6 x 44 + 5 x 1 + 2 x 1 border = 271, and the seams are the parent
      // showing through rather than a fill of their own.
      final List<Color> fills = _bulkFills(tester);
      expect(fills, hasLength(6), reason: 'six rows, each supplying its fill');

      final List<({double top, double height})> rows = _boxesOf(
        tester,
        column,
        _bulkRows(),
      ).where((({double top, double height}) r) =>
              (r.height - _bulkRowHeight).abs() <= _fineTolerance)
          .toList();
      expect(rows, hasLength(6), reason: '`px-4 py-3` around a 20px box');
      // Consecutive rows are exactly one hairline apart.
      for (int i = 1; i < rows.length; i++) {
        expect(rows[i].top - (rows[i - 1].top + rows[i - 1].height),
            closeTo(DsWidths.hairline, 0.01),
            reason: '`space-y-px` is a 1px MARGIN, not a gap');
      }
    });
  });

  /* ── The page is live ──────────────────────────────────────────────────── */

  group('seventeen of twenty answer a pointer', () {
    testWidgets('a filter checkbox toggles from either the box or its label',
        (WidgetTester tester) async {
      await tester.pumpSelectionPage();
      final Finder boxes =
          _inPanel('In a filter list', find.byType(DsCheckbox));

      // "Coming soon" starts unchecked.
      expect(tester.widget<DsCheckbox>(boxes.at(2)).state,
          DsCheckboxState.unchecked);
      await tester.tap(boxes.at(2));
      await tester.pump();
      expect(tester.widget<DsCheckbox>(boxes.at(2)).state,
          DsCheckboxState.checked);

      // And the words are a target too — that is the whole of what `htmlFor`
      // buys, and the only part Flutter can reproduce.
      await tester.tap(find.text('Sold out'));
      await tester.pump();
      expect(tester.widget<DsCheckbox>(boxes.at(3)).state,
          DsCheckboxState.checked);
    });

    testWidgets('a preference switch flips', (WidgetTester tester) async {
      await tester.pumpSelectionPage();
      final Finder switches =
          _inPanel('Notification preferences', find.byType(DsSwitch));

      expect(tester.widget<DsSwitch>(switches.at(2)).value, isFalse);
      await tester.tap(switches.at(2));
      await tester.pump();
      expect(tester.widget<DsSwitch>(switches.at(2)).value, isTrue);
    });

    testWidgets('the whole withdrawal card is the target',
        (WidgetTester tester) async {
      await tester.pumpSelectionPage();
      final Finder cards =
          _inPanel('Withdrawal method', find.byType(DsRadioGroupItem<String>));

      // Tapping the card's TEXT — not its 20px circle — selects it.
      await tester.tap(find.text('Bank transfer'));
      await tester.pump();
      final DsRadioGroup<String> group = tester.widget<DsRadioGroup<String>>(
        _inPanel('Withdrawal method', find.byType(DsRadioGroup<String>)).first,
      );
      expect(group.value, 'bank',
          reason: 'the reference wraps each item in a Label, so the card is '
              'the target and not just the circle');
      expect(cards, findsNWidgets(3));
    });

    testWidgets('dragging the price slider moves the readout',
        (WidgetTester tester) async {
      await tester.pumpSelectionPage();
      expect(find.text(r'$10 – $240'), findsOneWidget,
          reason: 'U+2013, spaced — the initial useState([10, 240])');

      final Finder slider =
          _inPanel('Price range filter', find.byType(DsSlider));
      final Rect box = tester.getRect(slider);
      // Grab the low knob and walk it right.
      final TestGesture gesture = await tester.startGesture(
        Offset(box.left + DsSlider.thumbSize / 2, box.center.dy),
      );
      await tester.pump();
      await gesture.moveBy(const Offset(60, 0));
      await tester.pump();
      await gesture.up();
      await tester.pump();

      expect(find.text(r'$10 – $240'), findsNothing,
          reason: 'the readout has to follow the handle');
      final DsSlider moved = tester.widget<DsSlider>(slider);
      expect(moved.values.first, greaterThan(10));
      expect(moved.values.last, 240, reason: 'the far knob did not move');
      expect(moved.values.first % 5, 0, reason: 'step={5}');
    });

    testWidgets('the single-value slider moves too', (WidgetTester tester) async {
      await tester.pumpSelectionPage();
      expect(find.text('25%'), findsOneWidget);

      final Finder slider = _inPanel('Single value', find.byType(DsSlider));
      final Rect box = tester.getRect(slider);
      await tester.tapAt(Offset(box.left + box.width * 0.75, box.center.dy));
      await tester.pump();

      expect(find.text('25%'), findsNothing);
      expect(tester.widget<DsSlider>(slider).values.single, 75,
          reason: 'the pointer maps against the ROOT width');
    });

    testWidgets('both matrix sliders are draggable and the third is not',
        (WidgetTester tester) async {
      await tester.pumpSelectionPage();
      final Finder sliders = _in('slider', find.byType(DsSlider));
      // Two panels plus three matrix cells.
      expect(sliders, findsNWidgets(5));

      final DsSlider disabled = tester.widget<DsSlider>(sliders.at(4));
      expect(disabled.enabled, isFalse);
      expect(tester.widget<DsSlider>(sliders.at(2)).onChanged, isNotNull);
      expect(tester.widget<DsSlider>(sliders.at(3)).values, <double>[20, 70],
          reason: 'the Range cell is `defaultValue={[20, 70]}`');
    });

    testWidgets('the checkbox matrix cells 1, 2 and 4 are live',
        (WidgetTester tester) async {
      await tester.pumpSelectionPage();
      final Finder cells = _in('checkbox', find.byType(DsCheckbox));

      await tester.tap(cells.at(0));
      await tester.pump();
      expect(tester.widget<DsCheckbox>(cells.at(0)).state,
          DsCheckboxState.checked);

      // Cell 4 paints a permanent ring AND still toggles — the class list
      // fakes the focus, it does not disable the box.
      expect(tester.widget<DsCheckbox>(cells.at(3)).forceFocusRing, isTrue);
      await tester.tap(cells.at(3));
      await tester.pump();
      expect(tester.widget<DsCheckbox>(cells.at(3)).state,
          DsCheckboxState.checked);
    });
  });

  /* ── The drifts, reproduced ────────────────────────────────────────────── */

  group('drift register', () {
    testWidgets('DRIFT 7: the Indeterminate cell is inert and undimmed',
        (WidgetTester tester) async {
      await tester.pumpSelectionPage();
      final Finder cells = _in('checkbox', find.byType(DsCheckbox));
      final DsCheckbox cell = tester.widget<DsCheckbox>(cells.at(2));

      expect(cell.inert, isTrue);
      expect(cell.state, DsCheckboxState.indeterminate);
      expect(cell.enabled, isTrue,
          reason: 'it carries no `disabled`, so it must not dim');

      await tester.tap(cells.at(2), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<DsCheckbox>(cells.at(2)).state,
          DsCheckboxState.indeterminate,
          reason: 'controlled with no handler — a click does nothing at all');
    });

    testWidgets('DRIFT 3: the bulk tints are frozen and do not follow the boxes',
        (WidgetTester tester) async {
      await tester.pumpSelectionPage();

      final List<Color> before = _bulkFills(tester);
      final Finder boxes =
          _inPanel('Bulk selection header', find.byType(DsCheckbox));
      expect(boxes, findsNWidgets(6));

      // Row 2 is tinted and its checkbox starts checked. Uncheck it.
      expect(tester.widget<DsCheckbox>(boxes.at(1)).state,
          DsCheckboxState.checked);
      await tester.tap(boxes.at(1));
      await tester.pump();
      expect(tester.widget<DsCheckbox>(boxes.at(1)).state,
          DsCheckboxState.unchecked);

      // Row 5 is plain and starts unchecked. Check it.
      await tester.tap(boxes.at(4));
      await tester.pump();
      expect(tester.widget<DsCheckbox>(boxes.at(4)).state,
          DsCheckboxState.checked);

      expect(_bulkFills(tester), before,
          reason: 'the row backgrounds are literal classes on the reference, '
              'so an unchecked row stays blue and a checked one stays plain '
              '— which is exactly what §6\'s fourth don\'t forbids');
    });

    testWidgets('DRIFT 6: two Focus cells paint a ring and neither is focused',
        (WidgetTester tester) async {
      await tester.pumpSelectionPage();

      final DsCheckbox checkbox = tester.widget<DsCheckbox>(
        _in('checkbox', find.byType(DsCheckbox)).at(3),
      );
      final DsRadioGroupItem<String> radio =
          tester.widget<DsRadioGroupItem<String>>(
        _in('radio', find.byType(DsRadioGroupItem<String>)).at(2),
      );

      expect(checkbox.forceFocusRing, isTrue);
      expect(radio.forceFocusRing, isTrue);

      // And the ring is genuinely painted, with nothing focused: the socket's
      // first shadow layer is the `ring-3` slot `DsButton.withFocusRing`
      // prepends, and it carries `--ring` at half alpha on both cells.
      final DsThemeData theme =
          DsTheme.of(tester.element(find.byType(SelectionPage)));
      for (final Finder cell in <Finder>[
        _in('checkbox', find.byType(DsCheckbox)).at(3),
        _in('radio', find.byType(DsRadioGroupItem<String>)).at(2),
      ]) {
        final DsMachineSurface socket = tester.widget<DsMachineSurface>(
          find.descendant(of: cell, matching: find.byType(DsMachineSurface))
              .first,
        );
        expect(socket.spec.layers.first.color(theme).a, closeTo(0.5, 0.01),
            reason: 'the ring is a permanent box-shadow, not a focus state');
      }
    });

    testWidgets('DRIFT 1: five chips, six sections, and they do not correspond',
        (WidgetTester tester) async {
      await tester.pumpSelectionPage();
      final DsCategoryHit here = findCategory('base', 'selection');

      expect(here.category.contents, <String>[
        'Checkbox',
        'Radio Group',
        'Switch',
        'Slider',
        'Range Slider',
      ]);
      for (final String chip in here.category.contents!) {
        expect(find.text(chip), findsWidgets, reason: 'chip "$chip"');
      }
      // "Range Slider" names no section, and two sections get no chip.
      expect(_sectionOracle.keys, hasLength(6));
      expect(here.category.contents, hasLength(5));
    });

    testWidgets('DRIFT 12: DoDont gets unequal columns for the first time',
        (WidgetTester tester) async {
      await tester.pumpSelectionPage();
      final DsDoDont rules = tester.widget<DsDoDont>(find.byType(DsDoDont));
      expect(rules.dos, hasLength(5));
      expect(rules.donts, hasLength(4));
    });
  });

  /* ── Copy ──────────────────────────────────────────────────────────────── */

  group('copy, verbatim', () {
    testWidgets('the header, the opening Note and every section title',
        (WidgetTester tester) async {
      await tester.pumpSelectionPage();

      // `.type-label` is `text-transform: uppercase`, and `DsText` performs
      // the transform, so this is the string that renders.
      expect(find.text('BASE COMPONENTS · BASE'), findsOneWidget,
          reason: 'the eyebrow says "Base" twice, on all fourteen base pages');
      expect(find.text('Selection Controls'), findsWidgets);
      // `DsNote`'s title is `.type-label` — uppercased on render, like the
      // eyebrow above it.
      expect(find.text('WHICH CONTROL FOR WHICH JOB'), findsOneWidget);

      for (final String title in <String>[
        'Checkbox',
        'Radio Group',
        'Switch',
        'Slider',
        'API',
        'Rules',
      ]) {
        expect(find.text(title), findsWidgets, reason: 'section "$title"');
      }
    });

    testWidgets('the panels are labelled as the reference labels them',
        (WidgetTester tester) async {
      await tester.pumpSelectionPage();
      for (final String label in <String>[
        'In a filter list',
        'Bulk selection header',
        'Withdrawal method',
        'Notification preferences',
        'Price range filter',
        'Single value',
      ]) {
        expect(_panel(label), findsOneWidget, reason: 'panel "$label"');
      }
    });

    testWidgets('the card names, the fees and the en dashes',
        (WidgetTester tester) async {
      await tester.pumpSelectionPage();

      for (final String name in <String>[
        'Voidwing Ascendant',
        'Emberlash Prime',
        'Tidecaller',
        'Stonewarden',
        'Glasswing Drift',
      ]) {
        expect(find.text(name), findsOneWidget, reason: name);
      }
      expect(find.text(r'$2,481.00'), findsOneWidget);
      expect(find.text('3 of 12 cards selected'), findsOneWidget);

      // U+2013, unspaced, in both withdrawal descriptions.
      expect(find.text('1–3 business days.'), findsOneWidget);
      expect(find.text('Back to the original card. 5–10 days.'), findsOneWidget);
      expect(find.text('No fee'), findsOneWidget);
      expect(find.text(r'$0.00'), findsNWidgets(2));
    });

    testWidgets('the slider readouts and their bounds',
        (WidgetTester tester) async {
      await tester.pumpSelectionPage();
      // Both readout labels are `.type-label` — uppercased on render.
      expect(find.text('PRICE RANGE'), findsOneWidget);
      expect(find.text('AUTO-SELL BELOW RARITY'), findsOneWidget);
      expect(find.text(r'$0'), findsOneWidget);
      expect(find.text(r'$500'), findsOneWidget);
    });
  });

  /* ── Both themes ───────────────────────────────────────────────────────── */

  testWidgets('it paints in both themes without error',
      (WidgetTester tester) async {
    for (final DsThemeMode mode in <DsThemeMode>[
      DsThemeMode.light,
      DsThemeMode.dark,
    ]) {
      await tester.pumpSelectionPage(mode: mode);
      expect(tester.takeException(), isNull, reason: '$mode');
    }
  });

  testWidgets('the column is the same height in both themes',
      (WidgetTester tester) async {
    // Measured identical on the reference — 4252.14 in both — because nothing
    // on this page changes size with the theme.
    final RenderBox light =
        await pumpSelectionInShell(tester, mode: DsThemeMode.light);
    final double lightHeight = light.size.height;
    final RenderBox dark =
        await pumpSelectionInShell(tester, mode: DsThemeMode.dark);
    expect(dark.size.height, closeTo(lightHeight, _fineTolerance));
  });
}
