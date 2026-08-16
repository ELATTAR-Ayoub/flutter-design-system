/// `/design-system/components/base/dialogs` — the page, against the numbers the
/// reference actually renders.
///
/// Two harnesses, and the split is load-bearing:
///
///  * [pumpDialogsInShell] mounts the real `DocsShell` at the 1440 x 900
///    reference frame and hands back the reading column's `RenderBox`. Every
///    oracle number below is measured from that origin, **pristine** — nothing
///    opened, nothing hovered — which is the state the reference was measured
///    in. Every overlay on this page is `position: fixed`, so none of them can
///    move the document even when open.
///  * [pumpDialogsPage] mounts the page alone in a tall frame so every trigger
///    is laid out and hit-testable at once. Nine overlays open, and this file's
///    job is to prove it.
///
/// The oracle was read off `http://localhost:3000` at 1440 x 900 on 2026-08-16
/// with `getBoundingClientRect()`, in document coordinates; the reading column
/// starts 112px down (`main` at 64 plus its own `py-12`), so every number here
/// is the measured top less 112.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/dialogs.dart';
import 'package:example/shell.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader, LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

/* ── The frame and the oracle ────────────────────────────────────────────── */

/// The behaviour frame: tall enough to lay the whole page out at once, so
/// nothing needs scrolling into view before it can be pressed.
const Size _desktop = Size(1440, 7000);

/// The frame the reference is measured at, and the only width these numbers
/// mean anything at.
const Size _referenceFrame = Size(1440, 900);

const String _route = '$dsRoot/components/base/dialogs';

/// `--width-content`.
const double _columnWidth = 1080;

/// `main` at 64, plus its own 48px of top padding.
const double _columnTop = 112;

/// The page's own height inside the shell — `main`'s measured 6160.125 less
/// its 96px of `py-12`. Identical in both themes: nothing on this page changes
/// size with the theme.
const double _referenceHeight = 6064.13;

/// Each `section[id]`, as `(document top, border-box height)`.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'dialog': (top: 555.9, height: 283.3),
  'media-dialog': (top: 919.2, height: 283.3),
  'alert-dialog': (top: 1282.5, height: 491.8),
  'danger-zone': (top: 1854.3, height: 1463.8),
  'sheet': (top: 3398, height: 224.3),
  'drawer': (top: 3702.3, height: 224.3),
  'popover': (top: 4006.6, height: 216.3),
  'hover-card': (top: 4302.9, height: 263.8),
  'tooltip': (top: 4646.7, height: 263.8),
  'api': (top: 4990.5, height: 358.3),
  'rules': (top: 5428.8, height: 566.3),
};

/// `section.mb-20` — 80px, paid as padding inside the section's own box.
final double _sectionGap = ds(20);

const double _tolerance = 2;
const double _fineTolerance = 0.5;

/* ── Harness ─────────────────────────────────────────────────────────────── */

/// The reference's own font binaries. Load-bearing: every number above is a
/// line box.
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
  /// `MediaQuery(disableAnimations: true)` sits **below** `MaterialApp`, and
  /// every overlay here is an `OverlayPortal` rooted in this subtree — so the
  /// override reaches them, which a pushed route would not have done.
  Future<void> pumpDialogsPage({DsThemeMode mode = DsThemeMode.light}) async {
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
                  child: const SingleChildScrollView(child: DialogsPage()),
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

  /// Presses the button whose label is [label] and lets the overlay mount.
  Future<void> openBy(String label) async {
    await tap(find.widgetWithText(DsButton, label).first);
    await pump();
    await pump(DsDurations.jelly);
  }
}

/// The page inside the real [DocsShell] at the reference frame.
///
/// `main.dart` is the supervisor's at integration, so the page is handed to the
/// shell directly rather than looked up through `pageFor`.
Future<RenderBox> pumpDialogsInShell(
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

  const Widget page = DialogsPage();
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
  // No settle: geometry is settled on the first laid-out frame, and PRISTINE is
  // the state the oracle was measured in.
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

/// The section with [id], with `mb-20` taken back off its height.
({double top, double height}) _sectionBox(
  WidgetTester tester,
  RenderBox origin,
  String id,
) {
  final ({double top, double height}) box = _boxIn(tester, origin, _section(id));
  return (top: box.top, height: box.height - _sectionGap);
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
      final RenderBox column = await pumpDialogsInShell(tester);
      expect(column.size.width, _columnWidth);
    });

    testWidgets('the page stacks to the reference height',
        (WidgetTester tester) async {
      final RenderBox column = await pumpDialogsInShell(tester);
      expect(column.size.height, closeTo(_referenceHeight, _fineTolerance));
    });

    testWidgets('every section starts and ends where the reference does',
        (WidgetTester tester) async {
      final RenderBox column = await pumpDialogsInShell(tester);

      // Collected rather than asserted one at a time: a vertical drift is
      // cumulative, so the FIRST mismatch hides every section under it.
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

    testWidgets('the settings column is max-w-2xl and centred',
        (WidgetTester tester) async {
      await pumpDialogsInShell(tester);
      final Finder capped = find.descendant(
        of: _panel('Settings · Account'),
        matching: find.byWidgetPredicate(
          (Widget widget) =>
              widget is ConstrainedBox &&
              widget.constraints.maxWidth == DsContainers.xl2,
        ),
      );
      expect(capped, findsOneWidget);
      expect(tester.getSize(capped).width, DsContainers.xl2);
      // `mx-auto` — measured 504 against a panel content edge at 325, i.e.
      // (1030 - 672) / 2 = 179 of slack on each side.
      final double panelLeft = tester.getTopLeft(_panel('Settings · Account')).dx;
      expect(
        tester.getTopLeft(capped).dx - panelLeft,
        closeTo(ds(6) + DsWidths.hairline + (1030 - DsContainers.xl2) / 2, 1),
      );
    });
  });

  /* ── The overlays open ─────────────────────────────────────────────────── */

  group('nine overlays, and every one of them opens', () {
    testWidgets('the purchase dialog opens, prices up and closes',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();
      expect(find.byType(DsDialogContent), findsNothing);

      await tester.openBy('Open Pack');
      expect(find.byType(DsDialogContent), findsOneWidget);
      expect(find.text('Confirm your purchase'), findsOneWidget);
      // The receipt, including the U+2212 minus and the U+00D7 multiplication
      // sign the reference writes.
      expect(find.text('3 × Eclipse Vault'), findsOneWidget);
      expect(find.text(r'−$20.00'), findsOneWidget);
      expect(find.text(r'$124.00'), findsOneWidget);
      // `.type-label` is uppercased on render.
      expect(find.text('TOTAL'), findsOneWidget);

      // `sm:max-w-sm` — 384, and the panel is exactly that wide.
      expect(tester.getSize(find.byType(DsDialogContent)).width, 384);

      await tester.tap(find.widgetWithText(DsButton, 'Cancel'));
      await tester.pump();
      await tester.pump(DsDurations.base);
      expect(find.byType(DsDialogContent), findsNothing);
    });

    testWidgets('the three zones are the measured bands',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();
      await tester.openBy('Open Pack');

      final Rect content = tester.getRect(find.byType(DsDialogContent));
      final Rect header = tester.getRect(find.byType(DsDialogHeader));
      final Rect footer = tester.getRect(find.byType(DsDialogFooter));

      // `-mx-4 -mt-4` and `-mx-4 -mb-4`: the bands bleed to the panel's edges
      // and cancel its padding on their own side, exactly.
      expect(header.top, closeTo(content.top, _fineTolerance));
      expect(header.width, closeTo(content.width, _fineTolerance));
      expect(footer.bottom, closeTo(content.bottom, _fineTolerance));
      expect(footer.width, closeTo(content.width, _fineTolerance));
      // Measured 93.13 and 73.
      expect(header.height, closeTo(93.13, _tolerance));
      expect(footer.height, closeTo(73, _tolerance));
      // Measured 352.13 tall.
      expect(content.height, closeTo(352.13, _tolerance));
    });

    testWidgets('the media dialog is 448 wide, has no X, and both buttons close',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();
      await tester.openBy('Show announcement');

      expect(find.byType(DsDialogContent), findsOneWidget);
      expect(tester.getSize(find.byType(DsDialogContent)).width,
          DsContainers.md);
      expect(find.byType(DsDialogMedia), findsOneWidget);
      // `aspect-video` at 448 — 252 to the pixel.
      expect(tester.getSize(find.byType(DsDialogMedia)).height,
          closeTo(252, _fineTolerance));
      expect(find.text('NEW RELEASE'), findsNothing,
          reason: 'the chip is `text-xs`, not `.type-badge` — no uppercasing');
      expect(find.text('New release'), findsOneWidget);
      // DRIFT 5 — `showCloseButton={false}`, so no X anywhere.
      expect(
        find.descendant(
          of: find.byType(DsDialogContent),
          matching: find.widgetWithText(DsButton, 'Close'),
        ),
        findsNothing,
      );

      await tester.tap(find.widgetWithText(DsButton, 'See what’s new'));
      await tester.pump();
      await tester.pump(DsDurations.base);
      expect(find.byType(DsDialogContent), findsNothing);
    });

    testWidgets('the alert dialog refuses an overlay tap and yields to Escape',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();
      await tester.openBy('Sell All Cards');
      expect(find.byType(DsAlertDialogContent), findsOneWidget);
      expect(find.text(r'Sell all 12 cards for $2,481.00?'), findsOneWidget);

      // DRIFT 2, first half — a tap on the scrim leaves it mounted.
      await tester.tapAt(const Offset(20, 20));
      await tester.pump();
      await tester.pump(DsDurations.base);
      expect(find.byType(DsAlertDialogContent), findsOneWidget,
          reason: '*"cannot be dismissed by clicking outside"* — measured');

      // DRIFT 2, second half — Escape does close it, whatever the copy says.
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump(DsDurations.base);
      expect(find.byType(DsAlertDialogContent), findsNothing,
          reason: 'Radix blocks onPointerDownOutside only');
    });

    testWidgets('the alert dialog is two zones: no header band, a banded footer',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();
      await tester.openBy('Sell All Cards');

      final Rect content = tester.getRect(find.byType(DsAlertDialogContent));
      final Rect header = tester.getRect(find.byType(DsAlertDialogHeader));
      final Rect footer = tester.getRect(find.byType(DsAlertDialogFooter));

      // The header sits INSIDE the padding — 16 in on both axes — which is the
      // whole of the departure from `DialogHeader`.
      expect(header.left - content.left, closeTo(ds(4), _fineTolerance));
      expect(header.top - content.top, closeTo(ds(4), _fineTolerance));
      expect(header.width, closeTo(content.width - ds(8), _fineTolerance));
      // The footer still bleeds.
      expect(footer.width, closeTo(content.width, _fineTolerance));
      expect(footer.bottom, closeTo(content.bottom, _fineTolerance));
      // Measured 189.19 tall, 84.19 of header and 73 of footer.
      expect(content.height, closeTo(189.19, _tolerance));
      expect(header.height, closeTo(84.19, _tolerance));
      expect(footer.height, closeTo(73, _tolerance));
    });

    testWidgets('both sheets slide in from their own edge at 384 wide',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();

      await tester.openBy('Filters (left)');
      expect(find.byType(DsSheetContent), findsOneWidget);
      final Rect left = tester.getRect(find.byType(DsSheetContent));
      expect(left.width, DsContainers.sm);
      expect(left.left, 0);
      expect(find.text('Filter packs'), findsOneWidget);
      expect(find.text('184 packs match your current filters.'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump(DsDurations.overlay);

      await tester.openBy('Filters (right)');
      final Rect right = tester.getRect(find.byType(DsSheetContent));
      expect(right.width, DsContainers.sm);
      expect(right.right, closeTo(_desktop.width, _fineTolerance));
    });

    testWidgets('the sheet is live: the slider drags and a rarity ticks',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();
      await tester.openBy('Filters (right)');

      final Finder slider = find.byType(DsSlider);
      expect(slider, findsOneWidget);
      expect(tester.widget<DsSlider>(slider).values, <double>[10, 240]);
      final Rect box = tester.getRect(slider);
      final TestGesture gesture = await tester.startGesture(
        Offset(box.left + DsSlider.thumbSize / 2, box.center.dy),
      );
      await tester.pump();
      await gesture.moveBy(const Offset(40, 0));
      await tester.pump();
      await gesture.up();
      await tester.pump();
      final DsSlider moved = tester.widget<DsSlider>(slider);
      expect(moved.values.first, greaterThan(10));
      expect(moved.values.first % 5, 0, reason: 'step={5}');

      // The words are a target, because the reference wraps each row in a raw
      // `label`.
      await tester.tap(find.text('Legendary'));
      await tester.pump();
      final Finder boxes =
          find.descendant(of: slider, matching: find.byType(DsCheckbox));
      expect(boxes, findsNothing);
      expect(
        tester
            .widgetList<DsCheckbox>(find.byType(DsCheckbox))
            .where((DsCheckbox c) => c.state == DsCheckboxState.checked),
        hasLength(1),
      );
    });

    testWidgets('the drawer opens full-bleed and drags away',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();
      await tester.openBy('Card actions');

      expect(find.byType(DsDrawerContent), findsOneWidget);
      final Rect panel = tester.getRect(find.byType(DsDrawerContent));
      // DRIFT 8 — `inset-x-0` with no `sm:` cap: the "mobile" bottom sheet is
      // 1440 wide on a desktop.
      expect(panel.width, _desktop.width);
      expect(panel.bottom, closeTo(_desktop.height, _fineTolerance));
      expect(
        find.descendant(
          of: find.byType(DsDrawerContent),
          matching: find.text('Voidwing Ascendant'),
        ),
        findsOneWidget,
        reason: 'the hover card section names the same card',
      );
      // `h-1 w-24` — the grip itself; the handle widget is the full-width
      // lane `mx-auto` centres it in.
      final Size grip = tester.getSize(
        find.descendant(
          of: find.byType(DsDrawerHandle),
          matching: find.byType(SizedBox),
        ),
      );
      expect(grip.width, DsDrawerHandle.width);
      expect(grip.height, DsDrawerHandle.height);

      // Past vaul's 0.25 threshold and it goes.
      final TestGesture drag =
          await tester.startGesture(panel.topCenter + const Offset(0, 8));
      await tester.pump();
      await drag.moveBy(Offset(0, panel.height * 0.6));
      await tester.pump();
      await drag.up();
      await tester.pump();
      await tester.pump(DsDurations.drawer);
      expect(find.byType(DsDrawerContent), findsNothing);
    });

    testWidgets('both popovers open, size themselves and dismiss outside',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();

      await tester.tap(find.widgetWithText(DsButton, 'How odds work'));
      await tester.pump();
      await tester.pump(DsDurations.overlay);
      expect(find.text('Per-card odds'), findsOneWidget);
      expect(find.text('68.00%'), findsOneWidget);
      expect(find.text('0.42%'), findsOneWidget);
      // `w-80` beats `PopoverContent`'s own `w-72`.
      expect(
        tester.getSize(find.ancestor(
          of: find.text('Per-card odds'),
          matching: find.byType(DsPopoverSurface),
        )).width,
        ds(80),
      );

      await tester.tapAt(const Offset(20, 20));
      await tester.pump();
      await tester.pump(DsDurations.overlay);
      expect(find.text('Per-card odds'), findsNothing);

      await tester.tap(find.widgetWithText(DsButton, 'Quick sort'));
      await tester.pump();
      await tester.pump(DsDurations.overlay);
      expect(find.text('Price: low to high'), findsOneWidget);
      expect(
        tester.getSize(find.ancestor(
          of: find.text('Price: low to high'),
          matching: find.byType(DsPopoverSurface),
        )).width,
        ds(56),
      );
    });

    testWidgets('the tooltip waits 200ms and then labels the button',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();
      final TestGesture pointer =
          await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(pointer.removePointer);
      await pointer.addPointer(location: Offset.zero);

      await pointer
          .moveTo(tester.getCenter(find.byType(DsTooltip).first));
      await tester.pump();
      // Nothing yet: `delayDuration={200}` is a dwell, not an animation, so
      // reduced motion does not shorten it.
      expect(find.byType(DsTooltipContent), findsNothing);

      await tester.pump(DsDurations.tooltipDelay);
      await tester.pump();
      expect(find.byType(DsTooltipContent), findsOneWidget);
      expect(find.text('Open this pack'), findsOneWidget);

      await pointer.moveTo(const Offset(5, 5));
      await tester.pump();
      await tester.pump(DsDurations.overlay);
      expect(find.byType(DsTooltipContent), findsNothing);
    });

    testWidgets('the hover card waits 700ms and previews the card',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();
      final TestGesture pointer =
          await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(pointer.removePointer);
      await pointer.addPointer(location: Offset.zero);

      await pointer.moveTo(tester.getCenter(find.byType(DsHoverCard)));
      await tester.pump();
      expect(find.byType(DsHoverCardContent), findsNothing);

      await tester.pump(DsDurations.hoverCardOpenDelay);
      await tester.pump();
      expect(find.byType(DsHoverCardContent), findsOneWidget);
      // `w-72` — 288.
      expect(tester.getSize(find.byType(DsHoverCardContent)).width,
          DsHoverCard.defaultWidth);
      expect(find.text(r'$1,240.00'), findsOneWidget);
      expect(find.text('LEGENDARY'), findsOneWidget,
          reason: '`.type-label` uppercases on render');
    });
  });

  /* ── The danger zone is live ───────────────────────────────────────────── */

  group('danger zone', () {
    testWidgets('four zones, and only three of them offer the button',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();
      // One in the settings panel plus four bad-day cells.
      expect(find.text('DANGER ZONE'), findsNWidgets(5));
      // The loading cell replaces its content with skeletons.
      expect(find.byType(DsSkeleton), findsNWidgets(3));
      expect(find.text(r'Settle your $412.00 balance first.'), findsOneWidget);
    });

    testWidgets('the happy path deletes, toasts and leaves a trace on the page',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();

      // The first zone is the settings one.
      await tester.tap(find.widgetWithText(DsButton, 'Delete account').first);
      await tester.pump();
      await tester.pump(DsDurations.jelly);
      expect(find.text('Delete your account?'), findsOneWidget);

      await tester.tap(
        find.widgetWithText(DsButton, 'Delete my account and all files'),
      );
      await tester.pump();
      await tester.pump(DsDurations.base);
      // `DEFAULT_DELETE` resolves after 1400ms.
      await tester.pump(const Duration(milliseconds: 1500));

      expect(find.text('Account deleted'), findsWidgets,
          reason: 'a toast is gone in four seconds and the page must still '
              'show what happened');
      expect(find.text('Deleted a moment ago. You will be signed out of every '
          'device shortly.'), findsOneWidget);
    });

    testWidgets('the failing zone reaches the inline alert for real',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();

      // The second "Delete account" button is the rejecting cell's.
      await tester.tap(find.widgetWithText(DsButton, 'Delete account').at(1));
      await tester.pump();
      await tester.pump(DsDurations.jelly);
      await tester.tap(
        find.widgetWithText(DsButton, 'Delete my account and all files'),
      );
      await tester.pump();
      await tester.pump(DsDurations.base);
      await tester.pump();

      expect(find.text('Account not deleted'), findsOneWidget);
      expect(
        find.textContaining('The billing service is offline.'),
        findsWidgets,
      );
    });
  });

  /* ── Copy ──────────────────────────────────────────────────────────────── */

  group('copy, verbatim', () {
    testWidgets('the header, the opening Note and every section title',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();

      expect(find.text('BASE COMPONENTS · BASE'), findsOneWidget);
      expect(find.text('Dialogs & Overlays'), findsWidgets);
      expect(find.text('PICKING THE RIGHT OVERLAY'), findsOneWidget);

      for (final String title in <String>[
        'Dialog',
        'Media dialog',
        'Alert Dialog',
        'Danger Zone',
        'Sheet',
        'Drawer',
        'Popover',
        'Hover Card',
        'Tooltip',
        'API',
        'Rules',
      ]) {
        expect(find.text(title), findsWidgets, reason: 'section "$title"');
      }
    });

    testWidgets('the panels are labelled as the reference labels them',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();
      for (final String label in <String>[
        'Purchase confirmation',
        'Announcement with image header',
        'Destructive confirmations',
        'Settings · Account',
        'The states that only exist on a bad day',
        'Filter sheet',
        'Bottom drawer',
        'Odds explainer',
        'Card preview',
        'Icon-button labels',
      ]) {
        expect(_panel(label), findsOneWidget, reason: 'panel "$label"');
      }
    });

    testWidgets('DRIFT 1: nine chips, eleven sections',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();
      final DsCategoryHit here = findCategory('base', 'dialogs');

      expect(here.category.contents, <String>[
        'Dialog',
        'Media Dialog',
        'Alert Dialog',
        'Danger Zone',
        'Sheet',
        'Drawer',
        'Popover',
        'Hover Card',
        'Tooltip',
      ]);
      expect(_sectionOracle.keys, hasLength(11));
      expect(here.category.contents, hasLength(9));
    });

    testWidgets('DoDont gets nine dos against eight donts',
        (WidgetTester tester) async {
      await tester.pumpDialogsPage();
      final DsDoDont rules = tester.widget<DsDoDont>(find.byType(DsDoDont));
      expect(rules.dos, hasLength(9));
      expect(rules.donts, hasLength(8));
    });

    testWidgets('DRIFT 3: the alert-dialog buttons carry their own label as a '
        'tooltip', (WidgetTester tester) async {
      await tester.pumpDialogsPage();
      await tester.openBy('Sell All Cards');

      final DsAlertDialogAction action =
          tester.widget<DsAlertDialogAction>(find.byType(DsAlertDialogAction));
      final DsAlertDialogCancel cancel =
          tester.widget<DsAlertDialogCancel>(find.byType(DsAlertDialogCancel));
      expect(action.tooltip, isNull);
      expect(cancel.tooltip, isNull);
      // Null does not mean "no tooltip": the label becomes one, and both
      // buttons get one. `OverlayPortal` keeps the overlay a child of the
      // section in the ELEMENT tree, so a descendant finder reaches them.
      expect(_in('alert-dialog', find.byType(DsTooltip)), findsNWidgets(2));
      final Iterable<DsTooltip> tips =
          tester.widgetList<DsTooltip>(_in('alert-dialog', find.byType(DsTooltip)));
      expect(
        tips.map((DsTooltip t) => t.label),
        containsAll(<String>['Keep my cards', r'Sell all for $2,481.00']),
      );
    });
  });

  /* ── Both themes ───────────────────────────────────────────────────────── */

  testWidgets('it paints in both themes without error',
      (WidgetTester tester) async {
    for (final DsThemeMode mode in <DsThemeMode>[
      DsThemeMode.light,
      DsThemeMode.dark,
    ]) {
      await tester.pumpDialogsPage(mode: mode);
      expect(tester.takeException(), isNull, reason: '$mode');
    }
  });

  testWidgets('the column is the same height in both themes',
      (WidgetTester tester) async {
    final RenderBox light =
        await pumpDialogsInShell(tester, mode: DsThemeMode.light);
    final double lightHeight = light.size.height;
    final RenderBox dark =
        await pumpDialogsInShell(tester, mode: DsThemeMode.dark);
    expect(dark.size.height, closeTo(lightHeight, _fineTolerance));
  });
}
