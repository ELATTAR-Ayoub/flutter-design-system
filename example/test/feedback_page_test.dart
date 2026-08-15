/// `/design-system/components/base/feedback` — the page, against the numbers
/// the reference actually renders.
///
/// Two harnesses, and the split is load-bearing:
///
///  * [pumpFeedbackInShell] mounts the real `DocsShell` at the 1440 × 900
///    reference frame and hands back the reading column's `RenderBox`. Every
///    oracle number below is measured from that origin, **pristine** — nothing
///    hovered, no toast fired — which is the state the reference was measured
///    in. Firing one would not move it either (the toaster is fixed), but
///    pristine is the contract every other page in this suite holds.
///  * [pumpFeedbackPage] mounts the page alone in a tall frame, with the toast
///    host beside it the way `shell.dart` mounts it, so every specimen is laid
///    out and hit-testable at once.
///
/// **Neither settles.** Sixty-nine infinite animations stand on this page at
/// rest — 20 bloom/starfield layers on the five Alerts, 20 more on the five
/// toast previews, 24 shimmers and 5 spins — so a tree holding it never comes
/// to rest and `pumpAndSettle` would hang rather than fail. Both harnesses run
/// under `MediaQuery(disableAnimations: true)`, which is the port's
/// `prefers-reduced-motion`: every looper lands on its resting frame, which is
/// the frame the reference was measured in.
///
/// The oracle was read off `http://localhost:3000` at 1440 × 900 with
/// `getBoundingClientRect()`, in document coordinates; the reading column
/// starts 112px down (`main` at 64 plus its own `py-12`), so every number here
/// is the measured top less 112.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/feedback.dart';
import 'package:example/shell.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/* ── The frame and the oracle ────────────────────────────────────────────── */

/// The behaviour frame: tall enough to lay the whole page out at once, so
/// nothing needs scrolling into view before it can be tapped or hovered.
const Size _desktop = Size(1440, 6400);

/// The frame the reference is measured at, and the only width these numbers
/// mean anything at.
const Size _referenceFrame = Size(1440, 900);

const String _route = '$dsRoot/components/base/feedback';

/// `--width-content` — the reading column every wrap on the page follows.
const double _columnWidth = 1080;

/// Where the reading column starts in the reference's document coordinates:
/// `main` at 64, plus its own 48px of top padding.
const double _columnTop = 112;

/// `document.documentElement.scrollHeight` — supervisor ruling F6, and the
/// `_referenceHeight` entry the parity probe takes at integration.
const double _documentHeight = 6106;

/// The reading column's own height, derived from [_documentHeight] rather than
/// measured separately: the column starts [_columnTop] down the document and
/// ends `main`'s own 48px of bottom padding above its end.
///
/// Stated as arithmetic so the one measured figure on this line is the one the
/// supervisor signed off — 5946, against a rendered 5946.34.
const double _referenceColumn = _documentHeight - _columnTop - 48;

/// Each `section[id]`, as `(document top, border-box height)`.
///
/// Measured pristine. The heights are the CSS border box, so `mb-20` — which
/// this port pays as padding inside the section's own box — comes back off
/// before comparing.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'alert': (top: 555.9, height: 747.4),
  'toast': (top: 1383.3, height: 959.8),
  'skeleton': (top: 2423.1, height: 912.3),
  'progress': (top: 3415.4, height: 1188.5),
  'empty': (top: 4683.9, height: 460.1),
  'api': (top: 5224, height: 319.3),
  'rules': (top: 5623.3, height: 253.8),
};

/// The five previews' border-box heights, in DOM order.
///
/// **These are the preview's numbers, not the live toast's** — drift 4. The
/// stack is `16 + title + (4 + description) + 16` inside a 1px border, at
/// `.cn-toast`'s own `line-height: 1.5`: a title alone is 53.5, a title over a
/// one-line description is 77, and the error specimen's two-line description
/// makes it 96.5. The live toast of the same message measures 93.88, because
/// sonner's stylesheet gives its description a 1.4 leading that `.cn-toast`
/// never overrides.
const List<double> _previewHeights = <double>[53.5, 77, 96.5, 53.5, 77];

/// `ul.gap-4`.
const double _previewGap = 16;

/// `div.rounded-lg.border.border-border.bg-card.p-4` — the pack card.
const Size _packCard = Size(482, 348);

/// `div.space-y-px…` — four 58px rows, three seams, two border pixels.
const Size _pullRows = Size(482, 237);

/// `Empty` inside a two-up panel: both specimens wrap to two description lines,
/// so both measure the same.
const Size _emptyState = Size(482, 220.81);

/// `div.max-w-md` — every bar on the page.
const double _barWidth = 448;

/// The counts §10's live/static ledger turns on: 24 shimmers, 5 spins, and 10
/// bloom hosts each running two drifts and two starfield sways.
const int _skeletons = 24;
const int _spinners = 5;
const int _bloomHosts = 10;

/// `section.mb-20` — 80px, paid as padding inside the section's own box because
/// Flutter has no margins.
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

  /// The page under reduced motion, with the toast host beside it.
  ///
  /// Three things this harness brings that the page does not:
  ///
  ///  * the **body `DefaultTextStyle`** `DocsShell` installs — without it every
  ///    colour-inheriting string renders the framework's debug ink;
  ///  * `MediaQuery(disableAnimations: true)`, **below** `MaterialApp` so the
  ///    framework's own does not win;
  ///  * the toaster, mounted the way `shell.dart` mounts it — a full-size slot
  ///    in a `Stack`, never an `Overlay` entry, because an overlay entry would
  ///    not inherit the reduced-motion override above.
  Future<void> pumpFeedbackPage({DsThemeMode mode = DsThemeMode.light}) async {
    useViewport(_desktop);
    final DsThemeController theme = DsThemeController(mode: mode);
    final AppRouter router = AppRouter(route: _route);
    addTearDown(theme.dispose);
    addTearDown(router.dispose);
    addTearDown(docsToasts.clear);

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
                  child: Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        // The reading column, at the width the shell gives it.
                        //
                        // Not decoration: `--width-content` is a max-width the
                        // real page never exceeds, and the two-up grids cap
                        // their own copy at `max-w-sm`. Handed the whole 1440
                        // instead, `IntrinsicHeight` asks a description for its
                        // height at 662px, gets one line, and then lays it out
                        // at 384 where it takes two — an overflow the reference
                        // cannot reach and the shell harness does not see.
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[
                            SizedBox(
                              width: _columnWidth,
                              child: FeedbackPage(),
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: DsToaster(controller: docsToasts),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // One frame to build, one to let every zero-duration transition land. No
    // settle: nothing on this page ever comes to rest.
    await pump();
    await pump(DsDurations.slow);
  }

  /// Unmounts the tree so the toast host cancels its lifetime clocks, and the
  /// page cancels the Promise button's.
  Future<void> teardownTree() => pumpWidget(const SizedBox.shrink());
}

/// The page inside the real [DocsShell] at the reference frame, and the reading
/// column's own [RenderBox] — the origin every oracle number is measured from.
///
/// `main.dart` is the supervisor's at integration (ruling L13 keeps the
/// selection/feedback routes for their own integration step), so the page is
/// handed to the shell directly rather than looked up through `pageFor`.
Future<RenderBox> pumpFeedbackInShell(
  WidgetTester tester, {
  DsThemeMode mode = DsThemeMode.light,
}) async {
  tester.view.physicalSize = _referenceFrame;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  addTearDown(docsToasts.clear);

  final DsThemeController theme = DsThemeController(mode: mode);
  final AppRouter router = AppRouter(route: _route);
  addTearDown(theme.dispose);
  addTearDown(router.dispose);

  const Widget page = FeedbackPage();
  await tester.pumpWidget(
    DsTheme(
      controller: theme,
      child: AppRouterScope(
        router: router,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Builder(
            builder: (BuildContext context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: const DocsShell(route: _route, child: page),
            ),
          ),
        ),
      ),
    ),
  );
  // No settle, and PRISTINE: geometry is settled on the first laid-out frame,
  // and nothing has been hovered or fired.
  await tester.pump();

  return tester.renderObject<RenderBox>(find.byWidget(page));
}

/* ── Finders ─────────────────────────────────────────────────────────────── */

Finder _section(String id) => find.byWidgetPredicate(
      (Widget widget) => widget is DsSection && widget.id == id,
    );

Finder _panel(String label) => find.byWidgetPredicate(
      (Widget widget) => widget is DsPanel && widget.label == label,
    );

Finder _inPanel(String label, Finder matching) =>
    find.descendant(of: _panel(label), matching: matching);

/// The five previews' own boxes.
///
/// `.cn-toast` is the only thing on the page that states [DsToaster.width], and
/// the preview is a `<li>` that is exactly that wide — so the width *is* the
/// selector, the same way `[data-sonner-toast]` is on the reference.
Finder _previews() => _inPanel(
      'All five, side by side',
      find.byWidgetPredicate(
        (Widget widget) => widget is SizedBox && widget.width == DsToaster.width,
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

List<Size> _sizesOf(WidgetTester tester, Finder finder) => tester
    .renderObjectList<RenderBox>(finder)
    .map((RenderBox box) => box.size)
    .toList();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
    await _loadFont('Redaction35', 'Redaction35-Italic.ttf');
  });

  setUp(docsToasts.clear);

  /* ── Geometry ──────────────────────────────────────────────────────────── */

  group('vertical parity', () {
    testWidgets('the reading column is --width-content at the 1440 frame',
        (WidgetTester tester) async {
      final RenderBox column = await pumpFeedbackInShell(tester);
      expect(column.size.width, _columnWidth);
    });

    testWidgets('the column stands at the reference\'s own height',
        (WidgetTester tester) async {
      // Ruling F6: 6106 is safe pristine *and* after a toast, because the
      // toaster is fixed-position and takes no space in the flow. This is the
      // number `vertical_parity_probe_test` takes at integration.
      final RenderBox column = await pumpFeedbackInShell(tester);
      expect(column.size.height, closeTo(_referenceColumn, _fineTolerance));
    });

    testWidgets('every section starts and ends where the reference does',
        (WidgetTester tester) async {
      final RenderBox column = await pumpFeedbackInShell(tester);

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

    testWidgets('the preview stack is 356 wide and stacks on its own numbers',
        (WidgetTester tester) async {
      final RenderBox column = await pumpFeedbackInShell(tester);
      final List<({double top, double height})> boxes =
          _boxesOf(tester, column, _previews());

      expect(boxes, hasLength(5));
      for (int i = 0; i < boxes.length; i++) {
        expect(boxes[i].height, closeTo(_previewHeights[i], _fineTolerance),
            reason: 'preview $i — DRIFT 4, the preview\'s leading is 1.5');
        if (i == 0) continue;
        expect(boxes[i].top - (boxes[i - 1].top + boxes[i - 1].height),
            closeTo(_previewGap, _fineTolerance),
            reason: '`ul.gap-4` between previews');
      }
      for (final Size size in _sizesOf(tester, _previews())) {
        expect(size.width, DsToaster.width);
      }
    });

    testWidgets('the two skeleton containers measure what they replace',
        (WidgetTester tester) async {
      await pumpFeedbackInShell(tester);

      // The innermost `DecoratedBox` in each panel: the panel paints its own
      // frame and its own strip, and the specimen's container is the last one
      // a depth-first walk reaches.
      final Size card = _sizesOf(
        tester,
        _inPanel('Pack card skeleton', find.byType(DecoratedBox)),
      ).last;
      expect(card.width, closeTo(_packCard.width, _tolerance));
      expect(card.height, closeTo(_packCard.height, _tolerance),
          reason: 'the pack card is 482 x 348 — seven placeholders and their '
              'margins, inside `p-4` and a border');

      final Size rows = _sizesOf(
        tester,
        _inPanel('Live pull row skeleton', find.byType(DecoratedBox)),
      ).last;
      expect(rows.width, closeTo(_pullRows.width, _tolerance));
      expect(rows.height, closeTo(_pullRows.height, _tolerance),
          reason: '4 x 58 + 3 seams + the container\'s own two border pixels');
    });

    testWidgets('twenty-four skeletons, five spinners, ten bloom hosts',
        (WidgetTester tester) async {
      await tester.pumpFeedbackPage();
      // §10's ledger, and the arithmetic behind ruling F2's sixty-nine:
      // 10 hosts x (2 drifts + 2 sways) + 24 shimmers + 5 spins.
      expect(find.byType(DsSkeleton), findsNWidgets(_skeletons));
      expect(find.byType(DsSpinner), findsNWidgets(_spinners));
      expect(find.byType(DsBloomCosmic), findsNWidgets(_bloomHosts));
      expect(_bloomHosts * 4 + _skeletons + _spinners, 69);
      await tester.teardownTree();
    });

    testWidgets('seven bars, all 448 x 10', (WidgetTester tester) async {
      await pumpFeedbackInShell(tester);
      final List<Size> bars = _sizesOf(tester, find.byType(DsProgress));
      expect(bars, hasLength(7));
      for (final Size bar in bars) {
        expect(bar.width, closeTo(_barWidth, _fineTolerance),
            reason: '`div.max-w-md`');
        expect(bar.height, DsProgress.height, reason: '`h-2.5` — the channel');
      }
    });

    testWidgets('both empty states are the same 482 x 220.81 block',
        (WidgetTester tester) async {
      await pumpFeedbackInShell(tester);
      final List<Size> empties = _sizesOf(tester, find.byType(DsEmpty));
      expect(empties, hasLength(2));
      for (final Size empty in empties) {
        expect(empty.width, closeTo(_emptyState.width, _tolerance));
        expect(empty.height, closeTo(_emptyState.height, _tolerance));
      }
    });
  });

  /* ── The page is live ──────────────────────────────────────────────────── */

  group('five buttons fire five real toasts', () {
    /// The contract, not the choreography: wave B2 owns the enter/exit
    /// animation, the collapsed stack and hover-to-pause, and pinning frames
    /// here would churn the moment it lands.
    testWidgets('each trigger queues a toast of its own type',
        (WidgetTester tester) async {
      await tester.pumpFeedbackPage();
      expect(find.byType(DsToast), findsNothing,
          reason: 'nothing is queued until something is clicked');

      for (final (String label, DsToastType type) in <(String, DsToastType)>[
        ('Neutral', DsToastType.normal),
        ('Success', DsToastType.success),
        ('Error', DsToastType.error),
        ('Warning', DsToastType.warning),
      ]) {
        docsToasts.clear();
        await tester.pump();
        await tester.tap(_inPanel('Click to fire a real one', find.text(label)));
        await tester.pump();

        expect(docsToasts.length, 1, reason: label);
        expect(find.byType(DsToast), findsOneWidget, reason: label);
        expect(
          tester.widget<DsToast>(find.byType(DsToast)).message.type,
          type,
          reason: '`toast.${type.label}(…)`',
        );
      }
      await tester.teardownTree();
    });

    testWidgets('the queue holds sonner\'s own constants',
        (WidgetTester tester) async {
      await tester.pumpFeedbackPage();
      final Finder buttons =
          _inPanel('Click to fire a real one', find.byType(DsButton));
      expect(buttons, findsNWidgets(5));

      for (int i = 0; i < 4; i++) {
        await tester.tap(buttons.at(0));
        await tester.pump();
      }
      expect(docsToasts.length, 4);
      expect(docsToasts.visibleCount, DsToaster.visibleLimit,
          reason: 'VISIBLE_TOASTS_AMOUNT is 3; the fourth waits its turn');
      expect(find.byType(DsToast), findsNWidgets(3));

      // TOAST_LIFETIME 4000ms, then TIME_BEFORE_UNMOUNT 200ms.
      await tester.pump(DsToaster.lifetime);
      await tester.pump(DsToaster.unmountDelay);
      await tester.pump();
      expect(docsToasts.length, lessThan(4), reason: 'the first has retired');

      await tester.teardownTree();
    });

    testWidgets('a fired toast can be dismissed again',
        (WidgetTester tester) async {
      // The third leg of the contract, through the queue the page fires into.
      // **Not** through a gesture: sonner dismisses on swipe, and which
      // gestures reach a live toast is wave B2's surface — pinning one here
      // would churn every time that retunes.
      await tester.pumpFeedbackPage();
      await tester
          .tap(_inPanel('Click to fire a real one', find.text('Neutral')));
      await tester.pump();
      expect(find.byType(DsToast), findsOneWidget);

      docsToasts.clear();
      await tester.pump();
      await tester.pump(DsToaster.unmountDelay);
      await tester.pump();
      expect(docsToasts.length, 0);
      expect(find.byType(DsToast), findsNothing);

      await tester.teardownTree();
    });

    testWidgets('the Promise button loads, then settles 1800ms later',
        (WidgetTester tester) async {
      await tester.pumpFeedbackPage();
      await tester
          .tap(_inPanel('Click to fire a real one', find.text('Promise')));
      await tester.pump();

      DsToastMessage live() =>
          tester.widget<DsToast>(find.byType(DsToast)).message;

      expect(live().type, DsToastType.loading,
          reason: 'the loading leg goes up immediately');
      expect(live().title, 'Requesting withdrawal…');
      expect(docsToasts.length, 1);

      // `new Promise((res) => setTimeout(res, 1800))`.
      await tester.pump(const Duration(milliseconds: 1800));
      await tester.pump();

      expect(live().type, DsToastType.success);
      expect(live().title, 'Withdrawal requested');
      expect(docsToasts.length, 1,
          reason: 'settled into the SAME toast — same id, same box, no exit '
              'and no second entrance');

      await tester.teardownTree();
    });

    testWidgets('the pending promise is cancelled with the page',
        (WidgetTester tester) async {
      // A page that left the clock running would fire into whatever mounts
      // next, and `flutter_test` would fail the next test with a pending timer.
      await tester.pumpFeedbackPage();
      await tester
          .tap(_inPanel('Click to fire a real one', find.text('Promise')));
      await tester.pump();
      await tester.teardownTree();
      await tester.pump(const Duration(seconds: 3));
      expect(tester.takeException(), isNull);
    });

    testWidgets('the action pill answers a pointer',
        (WidgetTester tester) async {
      await tester.pumpFeedbackPage();
      final Finder pill = _inPanel('All five, side by side', find.text('Retry'));
      expect(pill, findsOneWidget,
          reason: 'the error preview is the only one with `[data-button]`');

      final DsThemeData theme =
          DsTheme.of(tester.element(find.byType(FeedbackPage)));
      Color fillOf() => tester
          .widgetList<DecoratedBox>(
            find.ancestor(of: pill, matching: find.byType(DecoratedBox)),
          )
          .map((DecoratedBox box) => (box.decoration as BoxDecoration).color)
          .whereType<Color>()
          .first;

      expect(fillOf(), theme.secondary,
          reason: 'secondary, not outline — a bordered transparent control '
              'over moving light reads as a hole');

      final TestGesture pointer =
          await tester.createGesture(kind: PointerDeviceKind.mouse);
      await pointer.addPointer();
      addTearDown(pointer.removePointer);
      await pointer.moveTo(tester.getCenter(pill));
      await tester.pump();
      await tester.pump(DsDurations.base);

      expect(fillOf(), theme.accent, reason: 'hover goes to `--accent`');
      await tester.teardownTree();
    });
  });

  /* ── The drifts, reproduced ────────────────────────────────────────────── */

  group('drift register', () {
    testWidgets('DRIFT 1: seven chips, five content sections',
        (WidgetTester tester) async {
      await tester.pumpFeedbackPage();
      final DsCategoryHit here = findCategory('base', 'feedback');

      expect(here.category.contents, <String>[
        'Alert',
        'Toast',
        'Skeleton',
        'Progress',
        'Progress tones',
        'Spinner',
        'Empty',
      ]);
      for (final String chip in here.category.contents) {
        expect(find.text(chip), findsWidgets, reason: 'chip "$chip"');
      }
      // "Progress tones" and "Spinner" are Panel labels inside `#progress`,
      // which is itself titled "Progress & Spinner".
      expect(_panel('Spinner'), findsOneWidget);
      expect(
        tester.widget<DsSection>(_section('progress')).title,
        'Progress & Spinner',
        reason: 'DRIFT 18 — the anchor and the title disagree',
      );
      await tester.teardownTree();
    });

    testWidgets('DRIFT 3: specimen 5 is `info` wearing an AlertTriangle',
        (WidgetTester tester) async {
      await tester.pumpFeedbackPage();
      final List<DsAlert> alerts =
          tester.widgetList<DsAlert>(find.byType(DsAlert)).toList();
      expect(alerts, hasLength(5));

      // DOM order is default · success · warning · destructive · info — not
      // the cva's own order.
      expect(
        alerts.map((DsAlert a) => a.variant).toList(),
        <DsAlertVariant>[
          DsAlertVariant.normal,
          DsAlertVariant.success,
          DsAlertVariant.warning,
          DsAlertVariant.destructive,
          DsAlertVariant.info,
        ],
      );
      expect((alerts.last.icon! as DsIcon).glyph, DsIconGlyph.alertTriangle,
          reason: 'a cyan triangle over a cyan bloom, with warning copy');
      expect(alerts.last.title, 'Purchase limit approaching');
      await tester.teardownTree();
    });

    testWidgets('F10: the action lane is reserved on two of the five',
        (WidgetTester tester) async {
      await tester.pumpFeedbackPage();
      final List<DsAlert> alerts =
          tester.widgetList<DsAlert>(find.byType(DsAlert)).toList();
      expect(
        alerts.map((DsAlert a) => a.action != null).toList(),
        <bool>[false, false, true, true, false],
        reason: 'Details and Retry, on specimens 3 and 4',
      );
      // `pr-20` is unconditional: the lane is 80px whether or not the button
      // would have collided.
      expect(DsAlert.actionLane, ds(20));
      await tester.teardownTree();
    });

    testWidgets('DRIFT 6: the first bar has no accessible name, the other six '
        'do', (WidgetTester tester) async {
      await tester.pumpFeedbackPage();
      final List<DsProgress> bars =
          tester.widgetList<DsProgress>(find.byType(DsProgress)).toList();
      expect(bars, hasLength(7));

      expect(bars.first.label, isNull,
          reason: '`<Progress value={20.6} />` — no aria-label at all, and its '
              'readout is an unassociated sibling span');
      for (final DsProgress bar in bars.skip(1)) {
        expect(bar.label, isNotNull, reason: 'every other bar carries one');
      }
      await tester.teardownTree();
    });

    testWidgets('DRIFT 7: PROGRESS_TONES contradicts its own comment',
        (WidgetTester tester) async {
      await tester.pumpFeedbackPage();
      final List<DsProgressTone> tones = tester
          .widgetList<DsProgress>(find.byType(DsProgress))
          .map((DsProgress bar) => bar.tone)
          .toList();

      // The comment says the second panel is "the four that say something
      // about the reading itself" — and its first entry is `default`.
      expect(tones.sublist(3).first, DsProgressTone.normal);
      expect(
        tones,
        <DsProgressTone>[
          DsProgressTone.normal,
          DsProgressTone.value,
          DsProgressTone.normal,
          DsProgressTone.normal,
          DsProgressTone.success,
          DsProgressTone.warning,
          DsProgressTone.destructive,
        ],
        reason: 'seven bars: three default, one value, one each of the rest',
      );
      await tester.teardownTree();
    });

    testWidgets('DRIFT 5: the inline Meta sits flush against the paragraph',
        (WidgetTester tester) async {
      final RenderBox column = await pumpFeedbackInShell(tester);
      final ({double top, double height}) row =
          _boxIn(tester, column, _inPanel('Inline placeholders',
              find.byType(DsRow)));
      final ({double top, double height}) meta = _boxIn(tester, column,
          _inPanel('Inline placeholders', find.byType(DsMeta)));

      expect(meta.top - (row.top + row.height), closeTo(0, _fineTolerance),
          reason: 'no `mt-6`, and every other Meta in the corpus has one');
    });

    testWidgets('DRIFT 2: the warning toast blooms the pair the Alert left',
        (WidgetTester tester) async {
      await tester.pumpFeedbackPage();
      final DsThemeData theme =
          DsTheme.of(tester.element(find.byType(FeedbackPage)));

      // The warning Alert's bloom, and the warning preview's, resolve to
      // different `--bloom-1`s: amber on the Alert, pale lime on the toast.
      final DsBloomCosmic alertBloom = tester.widget<DsBloomCosmic>(
        find
            .descendant(
              of: find.byWidgetPredicate((Widget w) =>
                  w is DsAlert && w.variant == DsAlertVariant.warning),
              matching: find.byType(DsBloomCosmic),
            )
            .first,
      );
      final DsBloomCosmic toastBloom = tester.widget<DsBloomCosmic>(
        find
            .descendant(of: _previews().at(3), matching: find.byType(DsBloomCosmic))
            .first,
      );

      expect(alertBloom.bloom1(theme), isNot(toastBloom.bloom1(theme)),
          reason: 'the toast never got the fix `alert.tsx` records');
      expect(toastBloom.bloom1(theme), DsPalette.valueBright,
          reason: '`--color-value-bright`, under a `--warning-ink` glyph');
      await tester.teardownTree();
    });
  });

  /* ── Copy ──────────────────────────────────────────────────────────────── */

  group('copy, verbatim', () {
    testWidgets('the header, the page-level Note and every section title',
        (WidgetTester tester) async {
      await tester.pumpFeedbackPage();

      // `.type-label` is `text-transform: uppercase`, and `DsText` performs
      // the transform, so this is the string that renders.
      expect(find.text('BASE COMPONENTS · BASE'), findsOneWidget,
          reason: 'the eyebrow says "Base" twice, on all fourteen base pages');
      expect(find.text('Feedback'), findsWidgets);
      expect(find.text('WHICH ONE TO REACH FOR'), findsOneWidget);

      for (final String title in <String>[
        'Alert',
        'Toast',
        'Skeleton',
        'Progress & Spinner',
        'Empty states',
        'API',
        'Rules',
      ]) {
        expect(find.text(title), findsWidgets, reason: 'section "$title"');
      }
      await tester.teardownTree();
    });

    testWidgets('the panels are labelled as the reference labels them',
        (WidgetTester tester) async {
      await tester.pumpFeedbackPage();
      for (final String label in <String>[
        'All five variants',
        'All five, side by side',
        'Click to fire a real one',
        'Pack card skeleton',
        'Live pull row skeleton',
        'Inline placeholders',
        'Progress',
        'Tone — the shape of the reading, not its direction',
        'Spinner',
        'Empty Stash — first-time user',
        'No search results — filters too narrow',
      ]) {
        expect(_panel(label), findsOneWidget, reason: 'panel "$label"');
      }
      await tester.teardownTree();
    });

    testWidgets('the five alerts, the five previews and the readouts',
        (WidgetTester tester) async {
      await tester.pumpFeedbackPage();

      for (final String title in <String>[
        'Provably fair',
        'Deposit cleared',
        'Withdrawal under review',
        'Payment failed',
        'Purchase limit approaching',
      ]) {
        expect(find.text(title), findsOneWidget, reason: title);
      }
      expect(find.text('Details'), findsOneWidget);

      // The preview and the live-toast button share four strings, so these are
      // scoped to the stack.
      for (final String title in <String>[
        'Added to favourites',
        r'Sold 3 cards for $2,481.00',
        'Could not reach the vault',
        'Only 12 packs left in this print run',
        'Requesting withdrawal…',
      ]) {
        expect(_inPanel('All five, side by side', find.text(title)),
            findsOneWidget,
            reason: title);
      }
      expect(_inPanel('All five, side by side', find.text('Retry')),
          findsOneWidget);

      // The bars' labels are `.type-label`, uppercased on render; the readouts
      // are `.type-num-sm` and are not.
      for (final String label in <String>[
        'PACK SUPPLY REMAINING',
        'XP TO RANK 25',
        'REVEALING CARDS',
        'STEPS TODAY',
        'HYDRATION GOAL MET',
        'STORAGE USED',
        'SLEEP AGAINST AN 8H NEED',
      ]) {
        expect(find.text(label), findsOneWidget, reason: label);
      }
      for (final String readout in <String>[
        '412 / 2,000',
        '3,480 / 5,000',
        '4 of 6',
        '72%',
        '100%',
        '86%',
        '67%',
      ]) {
        expect(find.text(readout), findsOneWidget, reason: readout);
      }
      await tester.teardownTree();
    });

    testWidgets('the empty states and the rules', (WidgetTester tester) async {
      await tester.pumpFeedbackPage();

      expect(find.text('Your Stash is empty'), findsOneWidget);
      expect(find.text('No packs match those filters'), findsOneWidget);
      expect(find.text('Browse Packs'), findsOneWidget);
      expect(find.text('Reset filters'), findsOneWidget);

      final DsDoDont rules = tester.widget<DsDoDont>(find.byType(DsDoDont));
      expect(rules.dos, hasLength(5));
      expect(rules.donts, hasLength(5));
      expect(rules.dos[1],
          "Pair a progress bar with the real numbers — '412 / 2,000', not just "
          'a bar.',
          reason: 'straight single quotes inside the item; only the panel '
              'heading carries U+2019');
      await tester.teardownTree();
    });
  });

  /* ── Both themes ───────────────────────────────────────────────────────── */

  testWidgets('it paints in both themes without error',
      (WidgetTester tester) async {
    for (final DsThemeMode mode in <DsThemeMode>[
      DsThemeMode.light,
      DsThemeMode.dark,
    ]) {
      await tester.pumpFeedbackPage(mode: mode);
      expect(tester.takeException(), isNull, reason: '$mode');
    }
    await tester.teardownTree();
  });

  testWidgets('the column is the same height in both themes',
      (WidgetTester tester) async {
    // Nothing on this page changes size with the theme: the bloom swaps its
    // blend and its void, the starfield swaps its glow, and neither is laid
    // out.
    final RenderBox light =
        await pumpFeedbackInShell(tester, mode: DsThemeMode.light);
    final double lightHeight = light.size.height;
    final RenderBox dark =
        await pumpFeedbackInShell(tester, mode: DsThemeMode.dark);
    expect(dark.size.height, closeTo(lightHeight, _fineTolerance));
  });
}
