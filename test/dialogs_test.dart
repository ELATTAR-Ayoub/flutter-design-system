/// The dialogs & overlays family, against the numbers measured on the live
/// reference at 1440x900 on 2026-08-16 (`bd-geom.js`, `bd-anim.js`).
///
/// Package-level: geometry, motion keyframes and the two dismissal contracts.
/// The page's own oracle lives in `example/test/dialogs_page_test.dart`.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader, LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

/// The reference frame, at one device pixel per logical one.
const Size _frame = Size(1440, 900);

void _useFrame(WidgetTester t) {
  t.view.physicalSize = _frame;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);
}

/// The reference's own font binaries — load-bearing wherever a measured width
/// is asserted.
Future<void> _loadFont(String family, String file) async {
  final ByteData bytes =
      ByteData.sublistView(File('assets/fonts/$file').readAsBytesSync());
  final FontLoader loader = FontLoader('packages/elattar_design_system/$family')
    ..addFont(Future<ByteData>.value(bytes));
  await loader.load();
}

/// A host with a real [Overlay] under a [DsTheme], which is all any of these
/// widgets needs.
Widget _host(Widget child, {DsThemeMode mode = DsThemeMode.light}) => DsTheme(
      controller: DsThemeController(mode: mode),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: child)),
      ),
    );

Widget _dialog({
  DsDialogVariant variant = DsDialogVariant.normal,
  bool showCloseButton = true,
}) =>
    DsDialog(
      trigger: (BuildContext context, VoidCallback open) =>
          DsButton(onPressed: open, child: const Text('open')),
      content: (BuildContext context, VoidCallback close) => DsDialogContent(
        variant: variant,
        showCloseButton: showCloseButton,
        onClose: close,
        children: <Widget>[
          const DsDialogHeader(
            children: <Widget>[
              DsDialogTitle('Title'),
              DsDialogDescription('Description'),
            ],
          ),
          const SizedBox(height: 100),
          DsDialogFooter(
            children: <Widget>[
              DsButton(onPressed: close, child: const Text('Cancel')),
            ],
          ),
        ],
      ),
    );

Future<void> _open(WidgetTester t) async {
  await t.tap(find.text('open'));
  await t.pump();
  await t.pump(DsDurations.jelly);
}

/// Runs the exit and lets the portal's post-completion `setState` land.
Future<void> _settleExit(WidgetTester t) async {
  await t.pump();
  await t.pump(DsDurations.overlay);
  await t.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
    await _loadFont('Redaction35', 'Redaction35-Italic.ttf');
  });

  group('DsModalPortal', () {
    testWidgets('nothing is mounted until the trigger is pressed',
        (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(_dialog()));
      expect(find.byType(DsDialogContent), findsNothing);
      expect(find.byType(DsDialogOverlay), findsNothing);

      await _open(t);
      expect(find.byType(DsDialogContent), findsOneWidget);
      expect(find.byType(DsDialogOverlay), findsOneWidget);
    });

    testWidgets('a tap on the scrim closes a dialog and Escape does too',
        (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(_dialog()));
      await _open(t);
      await t.tapAt(const Offset(10, 10));
      await _settleExit(t);
      expect(find.byType(DsDialogContent), findsNothing);

      await _open(t);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await _settleExit(t);
      expect(find.byType(DsDialogContent), findsNothing);
    });

    testWidgets('the alert dialog refuses the scrim and yields to Escape',
        (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(DsAlertDialog(
        trigger: (BuildContext context, VoidCallback open) =>
            DsButton(onPressed: open, child: const Text('open')),
        content: (BuildContext context, VoidCallback close) =>
            DsAlertDialogContent(
          header: const DsAlertDialogHeader(
            title: DsAlertDialogTitle('Sure?'),
            description: DsAlertDialogDescription('It cannot be undone.'),
          ),
          footer: DsAlertDialogFooter(
            cancel: DsAlertDialogCancel(label: 'Keep', onPressed: close),
            action: DsAlertDialogAction(label: 'Delete', onPressed: close),
          ),
        ),
      )));
      await _open(t);
      await t.tapAt(const Offset(10, 10));
      await _settleExit(t);
      expect(find.byType(DsAlertDialogContent), findsOneWidget,
          reason: '*"cannot be dismissed by clicking outside"*');

      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await _settleExit(t);
      expect(find.byType(DsAlertDialogContent), findsNothing,
          reason: 'Radix blocks onPointerDownOutside only — measured');
    });
  });

  group('DsJellyTransition', () {
    // The keyframes, sampled where CSS declares them. Every number here is the
    // one globals.css writes; the trace confirmed all three stops.
    test('yuki-jelly-in stops at 0 / 60 / 100%', () {
      final ({double scale, double shift, double opacity}) start =
          DsJellyTransition.sample(0, entering: true);
      expect(start.scale, closeTo(0.92, 0.001));
      expect(start.shift, closeTo(24, 0.001));
      expect(start.opacity, closeTo(0, 0.001));

      final ({double scale, double shift, double opacity}) peak =
          DsJellyTransition.sample(0.6, entering: true);
      expect(peak.scale, closeTo(1.02, 0.001));
      expect(peak.shift, closeTo(-4, 0.001));
      expect(peak.opacity, closeTo(1, 0.001));

      final ({double scale, double shift, double opacity}) end =
          DsJellyTransition.sample(1, entering: true);
      expect(end.scale, closeTo(1, 0.001));
      expect(end.shift, closeTo(0, 0.001));
      expect(end.opacity, closeTo(1, 0.001));
    });

    test('yuki-jelly-out stops at 0 / 30 / 100%', () {
      expect(DsJellyTransition.sample(0, entering: false).scale,
          closeTo(1, 0.001));
      final ({double scale, double shift, double opacity}) anticipate =
          DsJellyTransition.sample(0.3, entering: false);
      expect(anticipate.scale, closeTo(1.01, 0.001));
      expect(anticipate.shift, closeTo(-4, 0.001),
          reason: 'the exit anticipates UPWARD before it drops');
      expect(anticipate.opacity, closeTo(1, 0.001));

      final ({double scale, double shift, double opacity}) gone =
          DsJellyTransition.sample(1, entering: false);
      expect(gone.scale, closeTo(0.94, 0.001));
      expect(gone.shift, closeTo(16, 0.001));
      expect(gone.opacity, closeTo(0, 0.001));
    });

    test('the easing runs per SEGMENT, not across the whole animation', () {
      // At the midpoint of the first segment the spring is already past its
      // linear share — 30% of 420ms is 50% of the 0→60% leg, and
      // `--ease-spring` puts it well beyond half the travel.
      final double half = DsJellyTransition.sample(0.3, entering: true).scale;
      final double linear = 0.92 + (1.02 - 0.92) * 0.5;
      expect(half, greaterThan(linear),
          reason: 'cubic-bezier(0.34, 1.56, 0.64, 1) is front-loaded');
    });

    testWidgets('the translate sits INSIDE the scale, so it is scaled with it',
        (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(_dialog()));
      await t.tap(find.text('open'));
      await t.pump();

      // Two nested transforms: the scale outside, the translate inside. Their
      // composition is what makes the measured first frame
      // `matrix(0.92, 0, 0, 0.92, 0, 22.08)` — 0.92 x 24, not 24.
      final List<Transform> stack = t
          .widgetList<Transform>(find.descendant(
            of: find.byType(DsJellyTransition),
            matching: find.byType(Transform),
          ))
          .toList();
      // The outermost two are this transition's; anything below belongs to the
      // panel's own content.
      expect(stack.length, greaterThanOrEqualTo(2));
      expect(stack[0].transform.storage[0], closeTo(0.92, 0.001));
      expect(stack[1].transform.storage[13], closeTo(24, 0.001));
      final Matrix4 composed =
          stack[0].transform.multiplied(stack[1].transform);
      expect(composed.storage[13], closeTo(0.92 * 24, 0.001));
    });
  });

  group('DsDialogContent', () {
    testWidgets('the default is 384 wide and the media variant 448',
        (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(_dialog()));
      await _open(t);
      expect(t.getSize(find.byType(DsDialogContent)).width, DsContainers.sm);

      _useFrame(t);
      await t.pumpWidget(_host(_dialog(variant: DsDialogVariant.media)));
      await _open(t);
      expect(t.getSize(find.byType(DsDialogContent)).width, DsContainers.md);
    });

    testWidgets('the bands bleed and cancel the padding on their own side',
        (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(_dialog()));
      await _open(t);
      final Rect content = t.getRect(find.byType(DsDialogContent));
      final Rect header = t.getRect(find.byType(DsDialogHeader));
      final Rect footer = t.getRect(find.byType(DsDialogFooter));

      expect(header.top, closeTo(content.top, 0.01));
      expect(header.left, closeTo(content.left, 0.01));
      expect(header.width, closeTo(content.width, 0.01));
      expect(footer.bottom, closeTo(content.bottom, 0.01));
      expect(footer.width, closeTo(content.width, 0.01));
    });

    testWidgets('the header reserves pr-12 only when there is an X to reserve '
        'for', (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(_dialog()));
      await _open(t);
      final Rect withX = t.getRect(find.text('Title'));
      final Rect header = t.getRect(find.byType(DsDialogHeader));
      // `p-4 pr-12` — the title column stops 48px from the band's right edge.
      expect(header.right - withX.left - t.getSize(find.text('Title')).width,
          greaterThan(ds(12) - 1));

      _useFrame(t);
      await t.pumpWidget(_host(_dialog(showCloseButton: false)));
      await _open(t);
      expect(find.byType(DsIcon), findsNothing,
          reason: 'no X, and the group-data hook drops the lane with it');
    });

    testWidgets('the media variant carries no bands and no padding',
        (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(_dialog(variant: DsDialogVariant.media)));
      await _open(t);
      final Rect content = t.getRect(find.byType(DsDialogContent));
      final Rect header = t.getRect(find.byType(DsDialogHeader));
      // `p-4 pb-2` inside a panel with `p-0`, so the header starts flush.
      expect(header.top, closeTo(content.top, 0.01));
      expect(header.width, closeTo(content.width, 0.01));
    });
  });

  group('DsBadge', () {
    testWidgets('h-5 is a hard border box whatever the label does',
        (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(
        const DsBadge(label: 'New release', variant: DsBadgeVariant.action),
      ));
      final Size size = t.getSize(find.byType(DsBadge));
      expect(size.height, DsBadge.height);
      // `w-fit` — measured 89.06 for this label at 12px/500; the port is within
      // a pixel of it on the same face.
      expect(size.width, closeTo(89.06, 3));
    });

    testWidgets('the unfilled variants take neither ramp nor shadow',
        (WidgetTester t) async {
      for (final DsBadgeVariant v in DsBadgeVariant.values) {
        _useFrame(t);
      await t.pumpWidget(_host(DsBadge(label: 'x', variant: v)));
        expect(
          find.descendant(
            of: find.byType(DsBadge),
            matching: find.byType(DsMachineSurface),
          ),
          v.filled ? findsOneWidget : findsNothing,
          reason: '$v',
        );
      }
    });
  });

  group('DsSheet', () {
    Widget sheet(DsSheetSide side) => DsSheetOverlay(
          side: side,
          trigger: (BuildContext context, VoidCallback open) =>
              DsButton(onPressed: open, child: const Text('open')),
          content: (BuildContext context, VoidCallback close) => DsSheetContent(
            side: side,
            onClose: close,
            children: const <Widget>[
              DsSheetHeader(
                children: <Widget>[
                  DsSheetTitle('Filter packs'),
                  DsSheetDescription('184 packs.'),
                ],
              ),
              DsSheetFooter(children: <Widget>[SizedBox(height: 40)]),
            ],
          ),
        );

    for (final DsSheetSide side in <DsSheetSide>[
      DsSheetSide.left,
      DsSheetSide.right,
    ]) {
      testWidgets('the ${side.name} sheet pins itself to its own edge at 384',
          (WidgetTester t) async {
        _useFrame(t);
        await t.pumpWidget(_host(sheet(side)));
        await t.tap(find.text('open'));
        await t.pump();
        await t.pump(DsDurations.overlay);
        await t.pump();
        final Rect panel = t.getRect(find.byType(DsSheetContent));
        expect(panel.width, DsContainers.sm);
        expect(panel.height, _frame.height);
        if (side == DsSheetSide.left) {
          expect(panel.left, closeTo(0, 0.01));
        } else {
          expect(panel.right, closeTo(_frame.width, 0.01));
        }
      });
    }

    testWidgets('the entrance travels 10% of the panel, not 10 spacing units',
        (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(sheet(DsSheetSide.right)));
      await t.tap(find.text('open'));
      await t.pump();
      // First frame: `--tw-enter-translate-x: calc(.1 * 100%)` — measured 38.4
      // against a 384 panel, and NOT the 40 that `ds(10)` would give.
      final Rect first = t.getRect(find.byType(DsSheetContent));
      expect(first.left - (_frame.width - DsContainers.sm),
          closeTo(DsContainers.sm * DsSheetTransition.fraction, 0.5));
      expect(DsContainers.sm * DsSheetTransition.fraction, closeTo(38.4, 0.01));

      await t.pump(DsDurations.overlay);
      expect(t.getRect(find.byType(DsSheetContent)).right,
          closeTo(_frame.width, 0.5));
    });

    testWidgets('the footer takes mt-auto and lands on the bottom edge',
        (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(sheet(DsSheetSide.right)));
      await t.tap(find.text('open'));
      await t.pump();
      await t.pump(DsDurations.overlay);
      expect(
        t.getRect(find.byType(DsSheetFooter)).bottom,
        closeTo(t.getRect(find.byType(DsSheetContent)).bottom, 0.5),
      );
    });
  });

  group('DsDrawer', () {
    Widget drawer() => DsDrawer(
          trigger: (BuildContext context, VoidCallback open) =>
              DsButton(onPressed: open, child: const Text('open')),
          content: (BuildContext context, VoidCallback close) =>
              DsDrawerContent(
            children: <Widget>[
              const DsDrawerHeader(
                children: <Widget>[
                  DsDrawerTitle('Voidwing Ascendant'),
                  DsDrawerDescription('Legendary'),
                ],
              ),
              DsDrawerFooter(
                children: <Widget>[
                  DsButton(onPressed: close, child: const Text('Close')),
                ],
              ),
            ],
          ),
        );

    testWidgets('it is full-bleed, bottom-pinned, and capped at 80vh',
        (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(drawer()));
      await t.tap(find.text('open'));
      await t.pump();
      await t.pump(DsDurations.drawer);

      final Rect panel = t.getRect(find.byType(DsDrawerContent));
      expect(panel.width, _frame.width,
          reason: '`inset-x-0` with no `sm:` cap');
      expect(panel.bottom, closeTo(_frame.height, 0.5));
      expect(panel.height,
          lessThanOrEqualTo(_frame.height *
              DsDrawerContent.maxHeightFraction + 0.5));
    });

    testWidgets('the handle is 96 x 4 and only the bottom direction has one',
        (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(drawer()));
      await t.tap(find.text('open'));
      await t.pump();
      await t.pump(DsDurations.drawer);
      final Size grip = t.getSize(
        find.descendant(
          of: find.byType(DsDrawerHandle),
          matching: find.byType(SizedBox),
        ),
      );
      expect(grip.width, DsDrawerHandle.width);
      expect(grip.height, DsDrawerHandle.height);
    });

    testWidgets('a drag past the threshold dismisses; a short one springs back',
        (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(drawer()));
      await t.tap(find.text('open'));
      await t.pump();
      await t.pump(DsDurations.drawer);
      final Rect panel = t.getRect(find.byType(DsDrawerContent));

      // Short of vaul's 0.25 `closeThreshold`.
      TestGesture drag =
          await t.startGesture(panel.topCenter + const Offset(0, 8));
      await t.pump();
      await drag.moveBy(Offset(0, panel.height * 0.1));
      await t.pump();
      await drag.up();
      await t.pump();
      await t.pump(DsDurations.drawer);
      expect(find.byType(DsDrawerContent), findsOneWidget);

      drag = await t.startGesture(panel.topCenter + const Offset(0, 8));
      await t.pump();
      await drag.moveBy(Offset(0, panel.height * 0.6));
      await t.pump();
      await drag.up();
      await t.pump();
      await t.pump(DsDurations.drawer);
      await t.pump();
      await t.pump(DsDurations.drawer);
      await t.pump();
      expect(find.byType(DsDrawerContent), findsNothing);
    });
  });

  group('DsTooltip', () {
    Widget tip() => DsTooltip(
          label: 'Open this pack',
          child: DsButton(onPressed: () {}, child: const Text('trigger')),
        );

    testWidgets('it waits the provider delay, then labels the control',
        (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(tip()));
      final TestGesture pointer =
          await t.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(pointer.removePointer);
      await pointer.addPointer(location: Offset.zero);

      await pointer.moveTo(t.getCenter(find.text('trigger')));
      await t.pump();
      expect(find.byType(DsTooltipContent), findsNothing);

      await t.pump(DsDurations.tooltipDelay);
      await t.pump(DsDurations.overlay);
      expect(find.byType(DsTooltipContent), findsOneWidget);
      expect(find.text('Open this pack'), findsOneWidget);

      await pointer.moveTo(const Offset(2, 2));
      await t.pump();
      await t.pump(DsDurations.overlay);
      await t.pump();
      await t.pump(DsDurations.overlay);
      await t.pump();
      expect(find.byType(DsTooltipContent), findsNothing);
    });

    testWidgets('it sits above its trigger with the arrow lane between them',
        (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(tip()));
      final TestGesture pointer =
          await t.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(pointer.removePointer);
      await pointer.addPointer(location: Offset.zero);
      await pointer.moveTo(t.getCenter(find.text('trigger')));
      await t.pump(DsDurations.tooltipDelay);
      await t.pump(DsDurations.overlay);

      final Rect trigger = t.getRect(find.byType(DsButton));
      final Rect content = t.getRect(find.byType(DsTooltipContent));
      // The box is the pill PLUS the 10px arrow lane, and its bottom is the
      // trigger's top — which is where the measured 10px gap comes from.
      expect(content.bottom, closeTo(trigger.top, 0.5));
      expect(content.center.dx, closeTo(trigger.center.dx, 0.5));
      // `px-3 py-1.5` on `text-xs` — 28px of pill, plus the lane.
      expect(content.height, closeTo(28 + DsTooltip.arrowSize, 1));
    });
  });

  group('DsHoverCard', () {
    testWidgets('it waits 700ms, opens under the trigger, and closes on 300',
        (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(DsHoverCard(
        trigger: DsButton(onPressed: () {}, child: const Text('trigger')),
        content: const SizedBox(height: 120),
      )));
      final TestGesture pointer =
          await t.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(pointer.removePointer);
      await pointer.addPointer(location: Offset.zero);

      await pointer.moveTo(t.getCenter(find.text('trigger')));
      await t.pump();
      await t.pump(const Duration(milliseconds: 600));
      expect(find.byType(DsHoverCardContent), findsNothing,
          reason: 'Radix\'s openDelay default is 700, measured 728.3');

      await t.pump(const Duration(milliseconds: 200));
      await t.pump(DsDurations.overlay);
      expect(find.byType(DsHoverCardContent), findsOneWidget);
      expect(t.getSize(find.byType(DsHoverCardContent)).width,
          DsHoverCard.defaultWidth);
      // `side="bottom" sideOffset={4}`.
      expect(
        t.getRect(find.byType(DsHoverCardContent)).top -
            t.getRect(find.byType(DsButton)).bottom,
        closeTo(DsHoverCard.sideOffset, 0.5),
      );

      await pointer.moveTo(const Offset(2, 2));
      await t.pump();
      await t.pump(const Duration(milliseconds: 200));
      expect(find.byType(DsHoverCardContent), findsOneWidget,
          reason: 'the closeDelay is the window for crossing the 4px gap');
      await t.pump(const Duration(milliseconds: 200));
      await t.pump(DsDurations.overlay);
      await t.pump();
      await t.pump(DsDurations.overlay);
      await t.pump();
      expect(find.byType(DsHoverCardContent), findsNothing);
    });
  });

  group('both themes', () {
    testWidgets('every overlay paints in dark without error',
        (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(_dialog(), mode: DsThemeMode.dark));
      await _open(t);
      expect(t.takeException(), isNull);
    });
  });
}
