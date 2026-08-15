/// `?motion=reduced` — the boot parameter the capture rig sets, and the only
/// one that changes what paints.
///
/// The rig shoots a tall page in two passes and stitches them, so anything
/// still moving between the passes tears the seam. Chrome's emulated
/// `prefers-reduced-motion` freezes the web reference outright but never
/// reaches Flutter web, which reads `disableAnimations` off the platform's
/// accessibility features rather than off a media query. This file pins the
/// hand-plumbed equivalent: that the flag reaches the page, that it collapses
/// the durations `dsAnimationDuration` gates, and — the property the rig
/// actually needs — that nothing on the two pages carrying a looping effect
/// asks to repaint once a frame has landed.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/main.dart';
import 'package:example/nav.dart';
import 'package:example/pages/motion.dart';
import 'package:example/pages/shadows.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The frame the design bar is set at (design spec §7).
const Size _desktop = Size(1440, 900);

/// `h-4 w-0.5` — the ratchet's needle, and the only box on the motion page
/// with both of these measures.
final double _needleWidth = ds(0.5);
final double _needleHeight = ds(4);

final Finder _needle = find.byWidgetPredicate(
  (Widget widget) =>
      widget is SizedBox &&
      widget.width == _needleWidth &&
      widget.height == _needleHeight,
);

/// Every painter the page mounts, in tree order.
///
/// [ScrollbarPainter] is left out on purpose: the scrollbar's fade is
/// Flutter's own chrome rather than part of the page, it is not routed through
/// `dsAnimationDuration`, and the rig does not photograph it.
List<CustomPainter> _painters(WidgetTester tester) => <CustomPainter>[
      for (final CustomPaint paint
          in tester.widgetList<CustomPaint>(find.byType(CustomPaint)))
        ...<CustomPainter?>[paint.painter, paint.foregroundPainter]
            .whereType<CustomPainter>()
            .where((CustomPainter p) => p is! ScrollbarPainter),
    ];

/// Asserts that not one painter on screen wants to repaint across [over] —
/// which is what "the capture stitches clean" means in a widget test.
Future<void> _expectStill(
  WidgetTester tester,
  Duration over, {
  required String reason,
}) async {
  final List<CustomPainter> before = _painters(tester);
  await tester.pump(over);
  final List<CustomPainter> after = _painters(tester);

  expect(after, hasLength(before.length), reason: 'the tree changed shape');
  for (int i = 0; i < after.length; i++) {
    expect(
      after[i].shouldRepaint(before[i]),
      isFalse,
      reason: '${after[i].runtimeType} repainted — $reason',
    );
  }
}

extension on WidgetTester {
  /// Sizes the viewport in logical pixels, so `MediaQuery` breakpoints read the
  /// numbers the CSS media queries would.
  void useViewport(Size size) {
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  }

  /// Boots the real app and walks it to [route].
  ///
  /// `?route=` cannot be exercised from a test — `Uri.base` is the harness's
  /// own working directory — so the route is reached the way a reader reaches
  /// it, through the router the shell already exposes. Never settled: without
  /// the override this lands on a page with three live loopers.
  Future<void> pumpDocs({
    required bool reduceMotion,
    required String route,
  }) async {
    useViewport(_desktop);
    await pumpWidget(DocsApp(reduceMotion: reduceMotion));
    await pump();

    AppRouter.of(element(find.byType(DocsShell))).navigate(route);
    await pump();
    await pump(const Duration(milliseconds: 500));
  }
}

void main() {
  group('?motion=reduced', () {
    testWidgets('forces disableAnimations onto everything below the app', (
      WidgetTester tester,
    ) async {
      await tester.pumpDocs(reduceMotion: true, route: '$dsRoot/motion');

      final BuildContext page = tester.element(find.byType(MotionPage));
      expect(MediaQuery.maybeDisableAnimationsOf(page), isTrue);
      // The gate every duration in the package is routed through.
      expect(dsAnimationDuration(page, DsDurations.ratchet), Duration.zero);
      expect(dsAnimationDuration(page, DsDurations.foilDrift), Duration.zero);
    });

    testWidgets('is off by default, and the tree animates as it always did', (
      WidgetTester tester,
    ) async {
      await tester.pumpDocs(reduceMotion: false, route: '$dsRoot/motion');

      final BuildContext page = tester.element(find.byType(MotionPage));
      expect(MediaQuery.maybeDisableAnimationsOf(page), isFalse);
      expect(
        dsAnimationDuration(page, DsDurations.ratchet),
        DsDurations.ratchet,
      );
    });

    testWidgets('holds the three motion loopers on their reduced frames', (
      WidgetTester tester,
    ) async {
      await tester.pumpDocs(reduceMotion: true, route: '$dsRoot/motion');

      // The ratchet reverts to the element's own transform — 0°, not 315° and
      // not the 360° frame `steps(8, jump-end)` never displays — so its 2×16
      // needle still measures 2×16 rather than a rotated square-ish box.
      final Rect needle = tester.getRect(_needle);
      expect(needle.width, moreOrLessEquals(_needleWidth, epsilon: 0.01));
      expect(needle.height, moreOrLessEquals(_needleHeight, epsilon: 0.01));

      // Half a ratchet cycle, four of its eight steps, and two-thirds of a
      // shimmer sweep: any of the three still running would move inside it.
      await _expectStill(
        tester,
        DsDurations.ratchet ~/ 2,
        reason: 'the ratchet, the shimmer or the live dot is still running',
      );
      expect(tester.getRect(_needle), needle);
    });

    testWidgets('holds the foil still on the shadows page', (
      WidgetTester tester,
    ) async {
      await tester.pumpDocs(reduceMotion: true, route: '$dsRoot/shadows');

      expect(find.byType(ShadowsPage), findsOneWidget);
      expect(find.byType(DsFoilValue), findsWidgets);

      // `foil-value` runs two infinite animations — an 11s drift and a 5.5s
      // glint — and neither may advance while the rig is stitching.
      await _expectStill(
        tester,
        DsDurations.glintHover,
        reason: 'foil-value is still drifting or glinting',
      );
    });
  });
}
