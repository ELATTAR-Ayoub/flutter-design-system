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
import 'package:flutter/material.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth,
        ActionChip,
        AlertDialog,
        Badge,
        Card,
        CarouselController,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        DrawerHeader,
        Slider,
        Switch,
        TextFormField,
        Tooltip;
import 'package:flutter/services.dart'
    show FontLoader, LogicalKeyboardKey, MethodCall, SystemChannels;
import 'package:flutter_test/flutter_test.dart';

/// The reference frame, at one device pixel per logical one.
const Size _frame = Size(1440, 900);

void _useFrame(WidgetTester t) {
  t.view.physicalSize = _frame;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);
}

/// The phone the two user-ordered mobile adaptations are pinned at — a frame
/// the reference was never probed in, because it is an order and not a
/// measurement.
const Size _phone = Size(375, 812);

void _usePhone(WidgetTester t) {
  t.view.physicalSize = _phone;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);
}

/// `SystemNavigator.pop` — what *"back left the app"* looks like from inside a
/// test. Returns the live list of everything the platform channel is asked to
/// do, so a test can assert the app was **not** asked to quit.
List<MethodCall> _watchPlatform(WidgetTester t) {
  final List<MethodCall> calls = <MethodCall>[];
  t.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (MethodCall call) async {
      calls.add(call);
      return null;
    },
  );
  addTearDown(
    () => t.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    ),
  );
  return calls;
}

/// One press of the Android back button, or one predictive-back gesture — both
/// arrive as `WidgetsBinding.handlePopRoute`.
Future<void> _back(WidgetTester t) => t.binding.handlePopRoute();

bool _askedToQuit(List<MethodCall> calls) =>
    calls.any((MethodCall c) => c.method == 'SystemNavigator.pop');

/// The reference's own font binaries — load-bearing wherever a measured width
/// is asserted.
Future<void> _loadFont(String family, String file) async {
  final ByteData bytes = ByteData.sublistView(
    File('assets/fonts/$file').readAsBytesSync(),
  );
  final FontLoader loader = FontLoader('packages/elattar_design_system/$family')
    ..addFont(Future<ByteData>.value(bytes));
  await loader.load();
}

/// A host with a real [Overlay] under a [ThemeScope], which is all any of these
/// widgets needs.
Widget _host(Widget child, {ColorMode mode = ColorMode.light}) => ThemeScope(
  controller: ThemeController(mode: mode),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: Center(child: child)),
  ),
);

Widget _dialog({
  DialogVariant variant = DialogVariant.normal,
  bool showCloseButton = true,
  double body = 100,
}) => Dialog(
  trigger: (BuildContext context, VoidCallback open) =>
      Button(onPressed: open, child: const Text('open')),
  content: (BuildContext context, VoidCallback close) => DialogContent(
    variant: variant,
    showCloseButton: showCloseButton,
    onClose: close,
    children: <Widget>[
      const DialogHeader(
        children: <Widget>[
          DialogTitle('Title'),
          DialogDescription('Description'),
        ],
      ),
      // 100 is the measured case; a taller one is the shipment form that
      // ran off a phone and is what the compact clamp exists for.
      SizedBox(height: body),
      DialogFooter(
        children: <Widget>[
          Button(onPressed: close, child: const Text('Cancel')),
        ],
      ),
    ],
  ),
);

/// The alert dialog, with a question long enough to outgrow a phone when the
/// caller asks for one.
Widget _alertDialog({String? description}) => AlertDialog(
  trigger: (BuildContext context, VoidCallback open) =>
      Button(onPressed: open, child: const Text('open')),
  content: (BuildContext context, VoidCallback close) => AlertDialogContent(
    header: AlertDialogHeader(
      title: const AlertDialogTitle('Sure?'),
      description: AlertDialogDescription(
        description ?? 'It cannot be undone.',
      ),
    ),
    footer: AlertDialogFooter(
      cancel: AlertDialogCancel(label: 'Keep', onPressed: close),
      action: AlertDialogAction(label: 'Delete', onPressed: close),
    ),
  ),
);

/// The four-sided sheet, at file scope so the mobile group can reach it too.
Widget _sheet(SheetSide side) => SheetOverlay(
  side: side,
  trigger: (BuildContext context, VoidCallback open) =>
      Button(onPressed: open, child: const Text('open')),
  content: (BuildContext context, VoidCallback close) => SheetContent(
    side: side,
    onClose: close,
    children: const <Widget>[
      SheetHeader(
        children: <Widget>[
          SheetTitle('Filter packs'),
          SheetDescription('184 packs.'),
        ],
      ),
      SheetFooter(children: <Widget>[SizedBox(height: 40)]),
    ],
  ),
);

/// The bottom drawer, likewise.
Widget _drawer() => Drawer(
  trigger: (BuildContext context, VoidCallback open) =>
      Button(onPressed: open, child: const Text('open')),
  content: (BuildContext context, VoidCallback close) => DrawerContent(
    children: <Widget>[
      const DrawerHeader(
        children: <Widget>[
          DrawerTitle('Voidwing Ascendant'),
          DrawerDescription('Legendary'),
        ],
      ),
      DrawerFooter(
        children: <Widget>[
          Button(onPressed: close, child: const Text('Close')),
        ],
      ),
    ],
  ),
);

Future<void> _open(WidgetTester t) async {
  await t.tap(find.text('open'));
  await t.pump();
  await t.pump(MotionDurations.open);
}

/// Runs the exit and lets the portal's post-completion `setState` land.
Future<void> _settleExit(WidgetTester t) async {
  await t.pump();
  await t.pump(MotionDurations.overlayEnter);
  await t.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
  });

  group('OverlayPortal', () {
    testWidgets('nothing is mounted until the trigger is pressed', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(_host(_dialog()));
      expect(find.byType(DialogContent), findsNothing);
      expect(find.byType(DialogOverlay), findsNothing);

      await _open(t);
      expect(find.byType(DialogContent), findsOneWidget);
      expect(find.byType(DialogOverlay), findsOneWidget);
    });

    testWidgets('a tap on the scrim closes a dialog and Escape does too', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(_host(_dialog()));
      await _open(t);
      await t.tapAt(const Offset(10, 10));
      await _settleExit(t);
      expect(find.byType(DialogContent), findsNothing);

      await _open(t);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await _settleExit(t);
      expect(find.byType(DialogContent), findsNothing);
    });

    testWidgets('the alert dialog refuses the scrim and yields to Escape', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(
        _host(
          AlertDialog(
            trigger: (BuildContext context, VoidCallback open) =>
                Button(onPressed: open, child: const Text('open')),
            content: (BuildContext context, VoidCallback close) =>
                AlertDialogContent(
                  header: const AlertDialogHeader(
                    title: AlertDialogTitle('Sure?'),
                    description: AlertDialogDescription('It cannot be undone.'),
                  ),
                  footer: AlertDialogFooter(
                    cancel: AlertDialogCancel(label: 'Keep', onPressed: close),
                    action: AlertDialogAction(
                      label: 'Delete',
                      onPressed: close,
                    ),
                  ),
                ),
          ),
        ),
      );
      await _open(t);
      await t.tapAt(const Offset(10, 10));
      await _settleExit(t);
      expect(
        find.byType(AlertDialogContent),
        findsOneWidget,
        reason: '*"cannot be dismissed by clicking outside"*',
      );

      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await _settleExit(t);
      expect(
        find.byType(AlertDialogContent),
        findsNothing,
        reason: 'Radix blocks onPointerDownOutside only — measured',
      );
    });
  });

  group('OpenTransition', () {
    // The keyframes, sampled where CSS declares them. Every number here is the
    // one globals.css writes; the trace confirmed all three stops.
    test('yuki-jelly-in stops at 0 / 60 / 100%', () {
      final ({double scale, double shift, double opacity}) start =
          OpenTransition.sample(0, entering: true);
      expect(start.scale, closeTo(0.92, 0.001));
      expect(start.shift, closeTo(24, 0.001));
      expect(start.opacity, closeTo(0, 0.001));

      final ({double scale, double shift, double opacity}) peak =
          OpenTransition.sample(0.6, entering: true);
      expect(peak.scale, closeTo(1.02, 0.001));
      expect(peak.shift, closeTo(-4, 0.001));
      expect(peak.opacity, closeTo(1, 0.001));

      final ({double scale, double shift, double opacity}) end =
          OpenTransition.sample(1, entering: true);
      expect(end.scale, closeTo(1, 0.001));
      expect(end.shift, closeTo(0, 0.001));
      expect(end.opacity, closeTo(1, 0.001));
    });

    test('yuki-jelly-out stops at 0 / 30 / 100%', () {
      expect(
        OpenTransition.sample(0, entering: false).scale,
        closeTo(1, 0.001),
      );
      final ({double scale, double shift, double opacity}) anticipate =
          OpenTransition.sample(0.3, entering: false);
      expect(anticipate.scale, closeTo(1.01, 0.001));
      expect(
        anticipate.shift,
        closeTo(-4, 0.001),
        reason: 'the exit anticipates UPWARD before it drops',
      );
      expect(anticipate.opacity, closeTo(1, 0.001));

      final ({double scale, double shift, double opacity}) gone =
          OpenTransition.sample(1, entering: false);
      expect(gone.scale, closeTo(0.94, 0.001));
      expect(gone.shift, closeTo(16, 0.001));
      expect(gone.opacity, closeTo(0, 0.001));
    });

    test('the easing runs per SEGMENT, not across the whole animation', () {
      // At the midpoint of the first segment the spring is already past its
      // linear share — 30% of 420ms is 50% of the 0→60% leg, and
      // `--ease-spring` puts it well beyond half the travel.
      final double half = OpenTransition.sample(0.3, entering: true).scale;
      final double linear = 0.92 + (1.02 - 0.92) * 0.5;
      expect(
        half,
        greaterThan(linear),
        reason: 'cubic-bezier(0.34, 1.56, 0.64, 1) is front-loaded',
      );
    });

    testWidgets('the translate sits INSIDE the scale, so it is scaled with it', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(_host(_dialog()));
      await t.tap(find.text('open'));
      await t.pump();

      // Two nested transforms: the scale outside, the translate inside. Their
      // composition is what makes the measured first frame
      // `matrix(0.92, 0, 0, 0.92, 0, 22.08)` — 0.92 x 24, not 24.
      final List<Transform> stack = t
          .widgetList<Transform>(
            find.descendant(
              of: find.byType(OpenTransition),
              matching: find.byType(Transform),
            ),
          )
          .toList();
      // The outermost two are this transition's; anything below belongs to the
      // panel's own content.
      expect(stack.length, greaterThanOrEqualTo(2));
      expect(stack[0].transform.storage[0], closeTo(0.92, 0.001));
      expect(stack[1].transform.storage[13], closeTo(24, 0.001));
      final Matrix4 composed = stack[0].transform.multiplied(
        stack[1].transform,
      );
      expect(composed.storage[13], closeTo(0.92 * 24, 0.001));
    });
  });

  group('DialogContent', () {
    testWidgets('the default is 384 wide and the media variant 448', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(_host(_dialog()));
      await _open(t);
      expect(t.getSize(find.byType(DialogContent)).width, Containers.sm);

      _useFrame(t);
      await t.pumpWidget(_host(_dialog(variant: DialogVariant.media)));
      await _open(t);
      expect(t.getSize(find.byType(DialogContent)).width, Containers.md);
    });

    testWidgets('the bands bleed and cancel the padding on their own side', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(_host(_dialog()));
      await _open(t);
      final Rect content = t.getRect(find.byType(DialogContent));
      final Rect header = t.getRect(find.byType(DialogHeader));
      final Rect footer = t.getRect(find.byType(DialogFooter));

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
      final Rect header = t.getRect(find.byType(DialogHeader));
      // `p-4 pr-12` — the title column stops 48px from the band's right edge.
      expect(
        header.right - withX.left - t.getSize(find.text('Title')).width,
        greaterThan(space(12) - 1),
      );

      _useFrame(t);
      await t.pumpWidget(_host(_dialog(showCloseButton: false)));
      await _open(t);
      expect(
        find.byType(Icon),
        findsNothing,
        reason: 'no X, and the group-data hook drops the lane with it',
      );
    });

    testWidgets('the media variant carries no bands and no padding', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(_host(_dialog(variant: DialogVariant.media)));
      await _open(t);
      final Rect content = t.getRect(find.byType(DialogContent));
      final Rect header = t.getRect(find.byType(DialogHeader));
      // `p-4 pb-2` inside a panel with `p-0`, so the header starts flush.
      expect(header.top, closeTo(content.top, 0.01));
      expect(header.width, closeTo(content.width, 0.01));
    });
  });

  group('Badge', () {
    testWidgets('h-5 is a hard border box whatever the label does', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(
        _host(const Badge(label: 'New release', variant: BadgeVariant.action)),
      );
      final Size size = t.getSize(find.byType(Badge));
      expect(size.height, greaterThanOrEqualTo(Badge.minHeight));
      // `w-fit` — the chip is as wide as its label plus its padding, and no
      // wider.
      expect(
        size.width,
        greaterThan(t.getSize(find.text('New release')).width),
      );
      expect(
        size.width,
        closeTo(
          t.getSize(find.text('New release')).width +
              Badge.horizontalPadding * 2 +
              BorderWidths.hairline * 2,
          1,
        ),
      );
    });

    testWidgets('the unfilled variants take neither ramp nor shadow', (
      WidgetTester t,
    ) async {
      for (final BadgeVariant v in BadgeVariant.values) {
        _useFrame(t);
        await t.pumpWidget(_host(Badge(label: 'x', variant: v)));
        expect(
          find.descendant(
            of: find.byType(Badge),
            matching: find.byType(Surface),
          ),
          v.filled ? findsOneWidget : findsNothing,
          reason: '$v',
        );
      }
    });
  });

  group('Sheet', () {
    Widget sheet(SheetSide side) => SheetOverlay(
      side: side,
      trigger: (BuildContext context, VoidCallback open) =>
          Button(onPressed: open, child: const Text('open')),
      content: (BuildContext context, VoidCallback close) => SheetContent(
        side: side,
        onClose: close,
        children: const <Widget>[
          SheetHeader(
            children: <Widget>[
              SheetTitle('Filter packs'),
              SheetDescription('184 packs.'),
            ],
          ),
          SheetFooter(children: <Widget>[SizedBox(height: 40)]),
        ],
      ),
    );

    for (final SheetSide side in <SheetSide>[SheetSide.left, SheetSide.right]) {
      testWidgets('the ${side.name} sheet pins itself to its own edge at 384', (
        WidgetTester t,
      ) async {
        _useFrame(t);
        await t.pumpWidget(_host(sheet(side)));
        await t.tap(find.text('open'));
        await t.pump();
        await t.pump(MotionDurations.overlayEnter);
        await t.pump();
        final Rect panel = t.getRect(find.byType(SheetContent));
        expect(panel.width, Containers.sm);
        expect(panel.height, _frame.height);
        if (side == SheetSide.left) {
          expect(panel.left, closeTo(0, 0.01));
        } else {
          expect(panel.right, closeTo(_frame.width, 0.01));
        }
      });
    }

    testWidgets('the entrance travels 10% of the panel, not 10 spacing units', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(_host(sheet(SheetSide.right)));
      await t.tap(find.text('open'));
      await t.pump();
      // First frame: `--tw-enter-translate-x: calc(.1 * 100%)` — measured 38.4
      // against a 384 panel, and NOT the 40 that `space(10)` would give.
      final Rect first = t.getRect(find.byType(SheetContent));
      expect(
        first.left - (_frame.width - Containers.sm),
        closeTo(Containers.sm * SheetTransition.fraction, 0.5),
      );
      expect(Containers.sm * SheetTransition.fraction, closeTo(38.4, 0.01));

      await t.pump(MotionDurations.overlayEnter);
      expect(
        t.getRect(find.byType(SheetContent)).right,
        closeTo(_frame.width, 0.5),
      );
    });

    testWidgets('the footer takes mt-auto and lands on the bottom edge', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(_host(sheet(SheetSide.right)));
      await t.tap(find.text('open'));
      await t.pump();
      await t.pump(MotionDurations.overlayEnter);
      expect(
        t.getRect(find.byType(SheetFooter)).bottom,
        closeTo(t.getRect(find.byType(SheetContent)).bottom, 0.5),
      );
    });

    testWidgets('full-height sheet keeps chrome between Android system bars', (
      WidgetTester t,
    ) async {
      _usePhone(t);
      const double statusBar = 47;
      const double gestureBar = 34;
      t.view.padding = const FakeViewPadding(
        top: statusBar,
        bottom: gestureBar,
      );
      t.view.viewPadding = const FakeViewPadding(
        top: statusBar,
        bottom: gestureBar,
      );
      addTearDown(t.view.resetPadding);
      addTearDown(t.view.resetViewPadding);

      await t.pumpWidget(_host(sheet(SheetSide.right)));
      await t.tap(find.text('open'));
      await t.pump();
      await t.pump(MotionDurations.overlayEnter);

      expect(t.getRect(find.byType(SheetHeader)).top, statusBar);
      expect(
        t.getRect(find.byType(SheetFooter)).bottom,
        _phone.height - gestureBar,
      );
      expect(t.getRect(find.byType(SheetContent)).height, _phone.height);
    });
  });

  group('Drawer', () {
    Widget drawer() => Drawer(
      trigger: (BuildContext context, VoidCallback open) =>
          Button(onPressed: open, child: const Text('open')),
      content: (BuildContext context, VoidCallback close) => DrawerContent(
        children: <Widget>[
          const DrawerHeader(
            children: <Widget>[
              DrawerTitle('Voidwing Ascendant'),
              DrawerDescription('Legendary'),
            ],
          ),
          DrawerFooter(
            children: <Widget>[
              Button(onPressed: close, child: const Text('Close')),
            ],
          ),
        ],
      ),
    );

    testWidgets('it is full-bleed, bottom-pinned, and capped at 80vh', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(_host(drawer()));
      await t.tap(find.text('open'));
      await t.pump();
      await t.pump(MotionDurations.drawerOpen);

      final Rect panel = t.getRect(find.byType(DrawerContent));
      expect(
        panel.width,
        _frame.width,
        reason: '`inset-x-0` with no `sm:` cap',
      );
      expect(panel.bottom, closeTo(_frame.height, 0.5));
      expect(
        panel.height,
        lessThanOrEqualTo(
          _frame.height * DrawerContent.maxHeightFraction + 0.5,
        ),
      );
    });

    testWidgets('the handle is 96 x 4 and only the bottom direction has one', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(_host(drawer()));
      await t.tap(find.text('open'));
      await t.pump();
      await t.pump(MotionDurations.drawerOpen);
      final Size grip = t.getSize(
        find.descendant(
          of: find.byType(DrawerHandle),
          matching: find.byType(SizedBox),
        ),
      );
      expect(grip.width, DrawerHandle.width);
      expect(grip.height, DrawerHandle.height);
    });

    testWidgets(
      'a drag past the threshold dismisses; a short one springs back',
      (WidgetTester t) async {
        _useFrame(t);
        await t.pumpWidget(_host(drawer()));
        await t.tap(find.text('open'));
        await t.pump();
        await t.pump(MotionDurations.drawerOpen);
        final Rect panel = t.getRect(find.byType(DrawerContent));

        // Short of vaul's 0.25 `closeThreshold`.
        TestGesture drag = await t.startGesture(
          panel.topCenter + const Offset(0, 8),
        );
        await t.pump();
        await drag.moveBy(Offset(0, panel.height * 0.1));
        await t.pump();
        await drag.up();
        await t.pump();
        await t.pump(MotionDurations.drawerOpen);
        expect(find.byType(DrawerContent), findsOneWidget);

        drag = await t.startGesture(panel.topCenter + const Offset(0, 8));
        await t.pump();
        await drag.moveBy(Offset(0, panel.height * 0.6));
        await t.pump();
        await drag.up();
        await t.pump();
        await t.pump(MotionDurations.drawerOpen);
        await t.pump();
        await t.pump(MotionDurations.drawerOpen);
        await t.pump();
        expect(find.byType(DrawerContent), findsNothing);
      },
    );
  });

  group('Tooltip', () {
    Widget tip() => Tooltip(
      label: 'Open this pack',
      child: Button(onPressed: () {}, child: const Text('trigger')),
    );

    testWidgets('it waits the provider delay, then labels the control', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(_host(tip()));
      final TestGesture pointer = await t.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(pointer.removePointer);
      await pointer.addPointer(location: Offset.zero);

      await pointer.moveTo(t.getCenter(find.text('trigger')));
      await t.pump();
      expect(find.byType(TooltipContent), findsNothing);

      await t.pump(MotionDurations.tooltipShowDelay);
      await t.pump(MotionDurations.overlayEnter);
      expect(find.byType(TooltipContent), findsOneWidget);
      expect(find.text('Open this pack'), findsOneWidget);

      await pointer.moveTo(const Offset(2, 2));
      await t.pump();
      await t.pump(MotionDurations.overlayEnter);
      await t.pump();
      await t.pump(MotionDurations.overlayEnter);
      await t.pump();
      expect(find.byType(TooltipContent), findsNothing);
    });

    testWidgets('it sits above its trigger with the arrow lane between them', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(_host(tip()));
      final TestGesture pointer = await t.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(pointer.removePointer);
      await pointer.addPointer(location: Offset.zero);
      await pointer.moveTo(t.getCenter(find.text('trigger')));
      await t.pump(MotionDurations.tooltipShowDelay);
      await t.pump(MotionDurations.overlayEnter);

      final Rect trigger = t.getRect(find.byType(Button));
      final Rect content = t.getRect(find.byType(TooltipContent));
      // The box is the pill PLUS the 10px arrow lane, and its bottom is the
      // trigger's top — which is where the measured 10px gap comes from.
      expect(content.bottom, closeTo(trigger.top, 0.5));
      expect(content.center.dx, closeTo(trigger.center.dx, 0.5));
      // One supporting line box in the pill's own padding, plus the lane.
      final double pill = TextStyles.small.step.leading + space(1.5) * 2;
      expect(content.height, closeTo(pill + Tooltip.arrowSize, 1));
    });

    // ── the shrink-wrap pins ────────────────────────────────────────────────
    // A tooltip over a CENTRED trigger hides a full-width content box behind
    // the fact that the viewport's own centre is also the trigger's, which is
    // how a viewport-wide bar pinned at x = 0 shipped. Both pins below put the
    // trigger somewhere other than the middle.

    testWidgets('the pill wraps its label, not the viewport', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      // Off-centre, but not against the edge: at x = 0 the positioner's own
      // on-screen clamp would answer for the geometry instead of the layout.
      await t.pumpWidget(
        _host(
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: space(50)),
              child: tip(),
            ),
          ),
        ),
      );
      final TestGesture pointer = await t.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(pointer.removePointer);
      await pointer.addPointer(location: Offset.zero);
      await pointer.moveTo(t.getCenter(find.text('trigger')));
      await t.pump(MotionDurations.tooltipShowDelay);
      await t.pump(MotionDurations.overlayEnter);

      final Rect trigger = t.getRect(find.byType(Button));
      final Rect content = t.getRect(find.byType(TooltipContent));
      final Rect label = t.getRect(find.text('Open this pack'));
      // `w-fit`: the label's own width plus `px-3`, and nothing else.
      expect(
        content.width,
        closeTo(label.width + Tooltip.horizontalPadding * 2, 0.5),
      );
      expect(content.width, lessThan(_frame.width / 2));
      // `align="center"` on a trigger that is NOT the viewport's centre.
      expect(content.center.dx, closeTo(trigger.center.dx, 0.5));
      expect(content.left, greaterThan(0));
    });

    testWidgets('a long label still stops at `max-w-xs`', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(
        _host(
          Tooltip(
            // The page's own longest specimen, doubled.
            label:
                '412 packs remaining of a 2,000 print run, and then no more '
                'of them will ever be printed again anywhere',
            child: Button(onPressed: () {}, child: const Text('trigger')),
          ),
        ),
      );
      final TestGesture pointer = await t.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(pointer.removePointer);
      await pointer.addPointer(location: Offset.zero);
      await pointer.moveTo(t.getCenter(find.text('trigger')));
      await t.pump(MotionDurations.tooltipShowDelay);
      await t.pump(MotionDurations.overlayEnter);

      final Rect content = t.getRect(find.byType(TooltipContent));
      expect(content.width, Containers.xs);
      // It wrapped rather than ran on: more than one 16px line box.
      expect(content.height, greaterThan(28 + Tooltip.arrowSize));
    });

    testWidgets('the right-side pill wraps its label height too', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(
        _host(
          Align(
            alignment: Alignment.topLeft,
            child: Tooltip(
              label: 'Open this pack',
              side: TooltipSide.right,
              child: Button(onPressed: () {}, child: const Text('trigger')),
            ),
          ),
        ),
      );
      final TestGesture pointer = await t.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(pointer.removePointer);
      await pointer.addPointer(location: Offset.zero);
      await pointer.moveTo(t.getCenter(find.text('trigger')));
      await t.pump(MotionDurations.tooltipShowDelay);
      await t.pump(MotionDurations.overlayEnter);

      final Rect trigger = t.getRect(find.byType(Button));
      final Rect content = t.getRect(find.byType(TooltipContent));
      // The lane is the row's leading column, not its height.
      expect(
        content.height,
        closeTo(TextStyles.small.step.leading + space(1.5) * 2, 1),
      );
      expect(content.left, closeTo(trigger.right, 0.5));
      expect(content.center.dy, closeTo(trigger.center.dy, 0.5));
    });
  });

  // ── the tap path — user-ordered, touch ────────────────────────────────────
  // Hover does not exist on a finger. See the component's library note; these
  // run at a phone's own size, and `WidgetTester.tap` is a touch pointer by
  // default, which is the whole routing question.
  group('Tooltip — the tap path', () {
    Widget scene({
      VoidCallback? onTrigger,
      VoidCallback? onElsewhere,
      bool hidden = false,
    }) => _host(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Tooltip(
            label: 'Open this pack',
            hidden: hidden,
            child: Button(
              onPressed: onTrigger ?? () {},
              child: const Text('trigger'),
            ),
          ),
          Button(
            onPressed: onElsewhere ?? () {},
            child: const Text('elsewhere'),
          ),
        ],
      ),
    );

    testWidgets('a tap opens it on the spot and a second tap closes it', (
      WidgetTester t,
    ) async {
      _usePhone(t);
      int presses = 0;
      await t.pumpWidget(scene(onTrigger: () => presses++));

      await t.tap(find.text('trigger'));
      await t.pump();
      // No dwell: `delayDuration` filters hover intent, and a tap has none to
      // filter.
      expect(find.byType(TooltipContent), findsOneWidget);
      await t.pump(MotionDurations.overlayEnter);
      expect(find.text('Open this pack'), findsOneWidget);
      // The trigger keeps its own gesture — the label is watched, not stolen.
      expect(presses, 1);

      await t.tap(find.text('trigger'));
      await _settleExit(t);
      await _settleExit(t);
      expect(find.byType(TooltipContent), findsNothing);
      expect(presses, 2);
    });

    testWidgets('a tap elsewhere closes it and still reaches what it hit', (
      WidgetTester t,
    ) async {
      _usePhone(t);
      int elsewhere = 0;
      await t.pumpWidget(scene(onElsewhere: () => elsewhere++));

      await t.tap(find.text('trigger'));
      await t.pump();
      await t.pump(MotionDurations.overlayEnter);
      expect(find.byType(TooltipContent), findsOneWidget);

      await t.tap(find.text('elsewhere'));
      await _settleExit(t);
      await _settleExit(t);
      expect(find.byType(TooltipContent), findsNothing);
      // Translucent, not modal: the dismissing tap was not swallowed.
      expect(elsewhere, 1);
    });

    testWidgets('it takes itself down after the touch dwell', (
      WidgetTester t,
    ) async {
      _usePhone(t);
      await t.pumpWidget(scene());

      await t.tap(find.text('trigger'));
      await t.pump();
      await t.pump(MotionDurations.overlayEnter);
      expect(find.byType(TooltipContent), findsOneWidget);

      await t.pump(Tooltip.touchDwell);
      await _settleExit(t);
      await _settleExit(t);
      expect(find.byType(TooltipContent), findsNothing);
    });

    testWidgets('`hidden` is still hidden to a finger', (WidgetTester t) async {
      _usePhone(t);
      await t.pumpWidget(scene(hidden: true));

      await t.tap(find.text('trigger'));
      await t.pump();
      await t.pump(MotionDurations.overlayEnter);
      expect(find.byType(TooltipContent), findsNothing);
    });

    testWidgets('a mouse on the same viewport still waits the dwell', (
      WidgetTester t,
    ) async {
      _usePhone(t);
      await t.pumpWidget(scene());
      final TestGesture pointer = await t.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(pointer.removePointer);
      await pointer.addPointer(location: Offset.zero);

      await pointer.moveTo(t.getCenter(find.text('trigger')));
      await t.pump();
      expect(find.byType(TooltipContent), findsNothing);

      // A mouse PRESS is not a tap: it buys nothing the hover was not already
      // going to give, and it must not short-circuit the dwell.
      await pointer.down(t.getCenter(find.text('trigger')));
      await t.pump();
      await pointer.up();
      await t.pump();
      expect(find.byType(TooltipContent), findsNothing);

      await t.pump(MotionDurations.tooltipShowDelay);
      await t.pump(MotionDurations.overlayEnter);
      expect(find.byType(TooltipContent), findsOneWidget);

      // And the pointer leaving still closes it — the tap path did not take
      // the exit contract away.
      await pointer.moveTo(const Offset(2, 2));
      await _settleExit(t);
      await _settleExit(t);
      expect(find.byType(TooltipContent), findsNothing);
    });
  });

  group('HoverCard', () {
    testWidgets('it waits 700ms, opens under the trigger, and closes on 300', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(
        _host(
          HoverCard(
            trigger: Button(onPressed: () {}, child: const Text('trigger')),
            content: const SizedBox(height: 120),
          ),
        ),
      );
      final TestGesture pointer = await t.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(pointer.removePointer);
      await pointer.addPointer(location: Offset.zero);

      await pointer.moveTo(t.getCenter(find.text('trigger')));
      await t.pump();
      await t.pump(const Duration(milliseconds: 600));
      expect(
        find.byType(HoverCardContent),
        findsNothing,
        reason: 'Radix\'s openDelay default is 700, measured 728.3',
      );

      await t.pump(const Duration(milliseconds: 200));
      await t.pump(MotionDurations.overlayEnter);
      expect(find.byType(HoverCardContent), findsOneWidget);
      expect(
        t.getSize(find.byType(HoverCardContent)).width,
        HoverCard.defaultWidth,
      );
      // `side="bottom" sideOffset={4}`.
      expect(
        t.getRect(find.byType(HoverCardContent)).top -
            t.getRect(find.byType(Button)).bottom,
        closeTo(HoverCard.sideOffset, 0.5),
      );

      await pointer.moveTo(const Offset(2, 2));
      await t.pump();
      await t.pump(const Duration(milliseconds: 200));
      expect(
        find.byType(HoverCardContent),
        findsOneWidget,
        reason: 'the closeDelay is the window for crossing the 4px gap',
      );
      await t.pump(const Duration(milliseconds: 200));
      await t.pump(MotionDurations.overlayEnter);
      await t.pump();
      await t.pump(MotionDurations.overlayEnter);
      await t.pump();
      expect(find.byType(HoverCardContent), findsNothing);
    });
  });

  group('both themes', () {
    testWidgets('every overlay paints in dark without error', (
      WidgetTester t,
    ) async {
      _useFrame(t);
      await t.pumpWidget(_host(_dialog(), mode: ColorMode.dark));
      await _open(t);
      expect(t.takeException(), isNull);
    });
  });

  /* ── USER-ORDERED MOBILE ADAPTATIONS ───────────────────────────────────── */
  //
  // Neither group below transcribes anything. The reference is a desktop site,
  // was probed at 1440x900, and has no back button at all — both behaviours are
  // orders, pinned here so a later reader can tell an order from a measurement.
  // See `dialog.dart`'s library doc for both, and for why back and Escape are
  // deliberately not the same contract.

  group('the compact clamp — USER-ORDERED mobile adaptation', () {
    testWidgets('a dialog that outgrows a phone is held to 90vw x 75vh and '
        'stays on screen', (WidgetTester t) async {
      _usePhone(t);
      await t.pumpWidget(_host(_dialog(body: 1200)));
      await _open(t);

      final Rect panel = t.getRect(find.byType(DialogContent));
      // 337.5 x 609 at 375 x 812.
      expect(
        panel.width,
        closeTo(_phone.width * CompactDialogLayout.maxWidthFraction, 0.01),
      );
      expect(
        panel.height,
        closeTo(_phone.height * CompactDialogLayout.maxHeightFraction, 0.01),
      );
      // The whole of the complaint: none of it is off the screen any more.
      expect(panel.top, greaterThanOrEqualTo(-0.01));
      expect(panel.bottom, lessThanOrEqualTo(_phone.height + 0.01));
      expect(panel.left, greaterThanOrEqualTo(-0.01));
      expect(panel.right, lessThanOrEqualTo(_phone.width + 0.01));
      expect(t.takeException(), isNull, reason: 'and nothing overflows');
    });

    testWidgets('the body scrolls inside the panel while the two bands hold '
        'still', (WidgetTester t) async {
      _usePhone(t);
      await t.pumpWidget(_host(_dialog(body: 1200)));
      await _open(t);

      final Finder scroller = find.descendant(
        of: find.byType(DialogContent),
        matching: find.byType(Scrollable),
      );
      final ScrollableState state = t.state<ScrollableState>(scroller);
      expect(
        state.position.maxScrollExtent,
        greaterThan(0),
        reason: 'a 1200px body inside a 609px panel has somewhere to go',
      );

      final Rect header = t.getRect(find.byType(DialogHeader));
      final Rect footer = t.getRect(find.byType(DialogFooter));
      await t.drag(scroller, const Offset(0, -200));
      await t.pump();

      expect(state.position.pixels, closeTo(200, 0.5));
      // *"three readable zones"* — on a phone only the middle one may move.
      expect(t.getRect(find.byType(DialogHeader)), header);
      expect(t.getRect(find.byType(DialogFooter)), footer);
    });

    testWidgets('the alert dialog clamps too, and scrolls its question under a '
        'pinned decision', (WidgetTester t) async {
      _usePhone(t);
      await t.pumpWidget(
        _host(_alertDialog(description: 'It cannot be undone. ' * 60)),
      );
      await _open(t);

      final Rect panel = t.getRect(find.byType(AlertDialogContent));
      expect(
        panel.height,
        closeTo(_phone.height * CompactDialogLayout.maxHeightFraction, 0.01),
      );
      expect(panel.bottom, lessThanOrEqualTo(_phone.height + 0.01));

      final ScrollableState state = t.state<ScrollableState>(
        find.descendant(
          of: find.byType(AlertDialogContent),
          matching: find.byType(Scrollable),
        ),
      );
      expect(state.position.maxScrollExtent, greaterThan(0));
      // *"the footer is the decision"* — and it is still reachable.
      expect(
        t.getRect(find.byType(AlertDialogFooter)).bottom,
        closeTo(panel.bottom, 0.01),
      );
    });

    test('above the breakpoint every clamp is the identity', () {
      // The 600 is the one compact breakpoint the port already keeps, and a
      // `max-width` query includes its own edge.
      expect(CompactDialogLayout.breakpoint, 600);
      expect(CompactDialogLayout.isCompact(600), isTrue);
      expect(CompactDialogLayout.isCompact(600.01), isFalse);

      expect(
        CompactDialogLayout.constraintsFor(_frame),
        const BoxConstraints(),
      );
      expect(
        CompactDialogLayout.clampWidth(Containers.sm, _frame),
        Containers.sm,
      );
      expect(
        CompactDialogLayout.clampSize(const Size(1123.2, 792), _frame),
        const Size(1123.2, 792),
      );

      // …and on a phone it is those two fractions and nothing else.
      expect(
        CompactDialogLayout.constraintsFor(_phone).maxWidth,
        closeTo(337.5, 0.01),
      );
      expect(
        CompactDialogLayout.constraintsFor(_phone).maxHeight,
        closeTo(609, 0.01),
      );
    });

    testWidgets('the scroller is inert wherever there is room, so the measured '
        'desktop geometry is untouched', (WidgetTester t) async {
      _useFrame(t);
      await t.pumpWidget(_host(_dialog()));
      await _open(t);

      expect(t.getSize(find.byType(DialogContent)).width, Containers.sm);
      final ScrollableState state = t.state<ScrollableState>(
        find.descendant(
          of: find.byType(DialogContent),
          matching: find.byType(Scrollable),
        ),
      );
      expect(
        state.position.maxScrollExtent,
        0,
        reason: 'a LOOSE Flexible takes only what its content needs',
      );
    });

    test(
      'the launcher dialog takes the clamp on a phone and nothing above it',
      () {
        // 1440x900 — the measured 1123.19 x 792, unchanged.
        final Size wide = AgentLauncher.dialogSize(_frame);
        expect(wide.width, closeTo(1123.2, 0.05));
        expect(wide.height, closeTo(792, 0.05));

        // 375x812 — `78vw` still wins the width (292.5 is inside 90vw), and the
        // 88vh height, which `60vw`'s floor would otherwise protect, is cut to
        // 75vh.
        final Size phone = AgentLauncher.dialogSize(_phone);
        expect(phone.width, closeTo(292.5, 0.01));
        expect(phone.height, closeTo(609, 0.01));
      },
    );

    testWidgets('a side sheet clamps its width and keeps its full height', (
      WidgetTester t,
    ) async {
      _usePhone(t);
      await t.pumpWidget(_host(_sheet(SheetSide.right)));
      await t.tap(find.text('open'));
      await t.pump();
      await t.pump(MotionDurations.overlayEnter);

      final Rect panel = t.getRect(find.byType(SheetContent));
      expect(
        panel.width,
        closeTo(_phone.width * CompactDialogLayout.maxWidthFraction, 0.01),
        reason: '`sm:max-w-sm` is 384, which does not fit a 375px phone',
      );
      expect(
        panel.height,
        _phone.height,
        reason: 'a side sheet is full-height by definition — no 75vh',
      );
      expect(panel.right, closeTo(_phone.width, 0.01));
    });

    testWidgets("the drawer stays full-bleed under vaul's own 80vh", (
      WidgetTester t,
    ) async {
      _usePhone(t);
      await t.pumpWidget(_host(_drawer()));
      await t.tap(find.text('open'));
      await t.pump();
      await t.pump(MotionDurations.drawerOpen);

      final Rect panel = t.getRect(find.byType(DrawerContent));
      expect(panel.width, _phone.width, reason: '`inset-x-0` — no 90vw');
      expect(
        panel.height,
        lessThanOrEqualTo(
          _phone.height * DrawerContent.maxHeightFraction + 0.5,
        ),
      );
      expect(panel.bottom, closeTo(_phone.height, 0.5));
    });
  });

  group('back dismisses the topmost overlay — USER-ORDERED', () {
    testWidgets('back closes the dialog and does NOT leave the app', (
      WidgetTester t,
    ) async {
      _usePhone(t);
      final List<MethodCall> platform = _watchPlatform(t);
      await t.pumpWidget(_host(_dialog()));
      await _open(t);

      await _back(t);
      await _settleExit(t);
      expect(find.byType(DialogContent), findsNothing);
      expect(
        find.text('open'),
        findsOneWidget,
        reason: 'the page underneath is still mounted — the route did not pop',
      );
      expect(
        _askedToQuit(platform),
        isFalse,
        reason:
            'an OverlayPortal is not a route, and back must not fall '
            'through it to SystemNavigator.pop',
      );

      // …and with nothing open the very same press bubbles all the way to the
      // platform, which is what leaving the app looks like. The mechanism is
      // scoped to an open overlay and nothing else.
      await _back(t);
      await t.pump();
      expect(_askedToQuit(platform), isTrue);
    });

    testWidgets('back closes the alert dialog even though the scrim cannot', (
      WidgetTester t,
    ) async {
      _usePhone(t);
      await t.pumpWidget(_host(_alertDialog()));
      await _open(t);

      // *"cannot be dismissed by clicking outside"* — still true.
      await t.tapAt(const Offset(10, 10));
      await _settleExit(t);
      expect(find.byType(AlertDialogContent), findsOneWidget);

      // Back admits no exceptions: the order is that it ALWAYS dismisses,
      // where Escape only does what the reference was measured doing.
      await _back(t);
      await _settleExit(t);
      expect(find.byType(AlertDialogContent), findsNothing);
    });

    testWidgets('stacked overlays unwind topmost-first', (
      WidgetTester t,
    ) async {
      _usePhone(t);
      expect(
        OverlayPortalState.openModals,
        isEmpty,
        reason: 'a disposed portal must not leave an entry behind',
      );

      await t.pumpWidget(
        _host(
          Dialog(
            trigger: (BuildContext context, VoidCallback open) =>
                Button(onPressed: open, child: const Text('open')),
            content: (BuildContext context, VoidCallback close) =>
                DialogContent(
                  onClose: close,
                  children: <Widget>[
                    const DialogHeader(
                      children: <Widget>[
                        DialogTitle('Outer'),
                        DialogDescription('The one underneath.'),
                      ],
                    ),
                    Dialog(
                      trigger: (BuildContext context, VoidCallback open) =>
                          Button(
                            onPressed: open,
                            child: const Text('open inner'),
                          ),
                      content: (BuildContext context, VoidCallback close) =>
                          DialogContent(
                            onClose: close,
                            children: const <Widget>[
                              DialogHeader(
                                children: <Widget>[
                                  DialogTitle('Inner'),
                                  DialogDescription(
                                    'Raised over the other one.',
                                  ),
                                ],
                              ),
                            ],
                          ),
                    ),
                  ],
                ),
          ),
        ),
      );

      await _open(t);
      expect(OverlayPortalState.openModals.length, 1);
      await t.tap(find.text('open inner'));
      await t.pump();
      await t.pump(MotionDurations.open);
      expect(find.text('Inner'), findsOneWidget);
      expect(
        OverlayPortalState.openModals.length,
        2,
        reason: 'a dialog raised from inside another is a SIBLING here',
      );

      // One press, one overlay — the inner one.
      await _back(t);
      await _settleExit(t);
      expect(find.text('Inner'), findsNothing);
      expect(find.text('Outer'), findsOneWidget);
      expect(OverlayPortalState.openModals.length, 1);

      await _back(t);
      await _settleExit(t);
      expect(find.text('Outer'), findsNothing);
      expect(OverlayPortalState.openModals, isEmpty);
    });

    testWidgets('the sheet and the drawer ride the same host', (
      WidgetTester t,
    ) async {
      _usePhone(t);
      await t.pumpWidget(_host(_sheet(SheetSide.right)));
      await t.tap(find.text('open'));
      await t.pump();
      await t.pump(MotionDurations.overlayEnter);
      expect(find.byType(SheetContent), findsOneWidget);
      await _back(t);
      // Settled rather than counted out: these two run their exits on their own
      // clocks — the sheet on `--duration-overlay`, the drawer on vaul's 500ms
      // — and the sheet's lands exactly on `_settleExit`'s last frame.
      await t.pumpAndSettle();
      expect(find.byType(SheetContent), findsNothing);

      await t.pumpWidget(_host(_drawer()));
      await t.tap(find.text('open'));
      await t.pump();
      await t.pump(MotionDurations.drawerOpen);
      expect(find.byType(DrawerContent), findsOneWidget);
      await _back(t);
      await t.pumpAndSettle();
      expect(find.byType(DrawerContent), findsNothing);
    });

    testWidgets("the agent launcher's console dialog rides it too", (
      WidgetTester t,
    ) async {
      _usePhone(t);
      await t.pumpWidget(
        _host(
          const AgentLauncher(
            label: 'Ask the assistant',
            title: 'Vault',
            description: 'Ask about packs, pulls, prices and your wallet.',
            child: Text('the console'),
          ),
        ),
      );

      expect(find.text('the console'), findsNothing);
      await t.tap(find.byType(Button));
      await t.pump();
      await t.pump(MotionDurations.open);
      expect(find.text('the console'), findsOneWidget);

      await _back(t);
      await _settleExit(t);
      expect(find.text('the console'), findsNothing);
    });
  });
}
