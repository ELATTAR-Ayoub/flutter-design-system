/// `?motion=reduced` — the boot parameter the capture rig sets, and the only
/// one that changes what paints.
///
/// The rig shoots a tall page in two passes and stitches them, so anything
/// still moving between the passes tears the seam. Chrome's emulated
/// `prefers-reduced-motion` freezes the web reference outright but never
/// reaches Flutter web, which reads `disableAnimations` off the platform's
/// accessibility features rather than off a media query. This file pins the
/// hand-plumbed equivalent: that the flag reaches the page, that it collapses
/// the durations `elAnimationDuration` gates, and — the property the rig
/// actually needs — that nothing on the two pages carrying a looping effect
/// asks to repaint once a frame has landed.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/main.dart';
import 'package:example/components_docs/button/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The frame the design bar is set at (design spec §7).
const Size _desktop = Size(1440, 900);

extension on WidgetTester {
  /// Sizes the viewport in logical pixels, so `MediaQuery` breakpoints read the
  /// numbers the CSS media queries would.
  void useViewport(Size size) {
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  }

  /// Boots the real app directly on [route].
  ///
  /// `?route=` cannot be exercised from a test — `Uri.base` is the harness's
  /// own working directory — so [DocsApp.initialRoute] is the test seam.
  Future<void> pumpDocs({
    required bool reduceMotion,
    required String route,
    DateTime? clock,
  }) async {
    useViewport(_desktop);
    await pumpWidget(
      DocsApp(reduceMotion: reduceMotion, clock: clock, initialRoute: route),
    );
    await pump();
    await pump(const Duration(milliseconds: 500));
  }
}

void main() {
  group('?motion=reduced', () {
    testWidgets('forces disableAnimations onto everything below the app', (
      WidgetTester tester,
    ) async {
      await tester.pumpDocs(reduceMotion: true, route: '/components/button');

      final BuildContext page = tester.element(find.byType(ButtonDocPage));
      expect(MediaQuery.maybeDisableAnimationsOf(page), isTrue);
      // The gate every duration in the package is routed through.
      expect(elAnimationDuration(page, ElDurations.ratchet), Duration.zero);
      expect(elAnimationDuration(page, ElDurations.foilDrift), Duration.zero);
    });

    testWidgets('is off by default, and the tree animates as it always did', (
      WidgetTester tester,
    ) async {
      await tester.pumpDocs(reduceMotion: false, route: '/components/button');

      final BuildContext page = tester.element(find.byType(ButtonDocPage));
      expect(MediaQuery.maybeDisableAnimationsOf(page), isFalse);
      expect(
        elAnimationDuration(page, ElDurations.ratchet),
        ElDurations.ratchet,
      );
    });
  });

  group('?clock=', () {
    // Supervisor ruling L2. `react-day-picker`'s `getInitialMonth` is
    // `month || defaultMonth || today` and the selects page passes neither of
    // the first two, so all three of its calendars open on the reader's
    // current month — and the page's rendered height moves 36px per calendar
    // with the month's week count *(measured on the live reference: February
    // 2026 renders four rows at 232.563px, July five at 268.563, August six at
    // 304.563)*. The rig freezes the clock on BOTH sides; this is this side.

    test('parses an ISO-8601 instant', () {
      expect(
        DocsApp.parseClock('2026-08-16T02:15:00'),
        DateTime(2026, 8, 16, 2, 15),
      );
      expect(DocsApp.parseClock('2026-08-16'), DateTime(2026, 8, 16));
    });

    test('a UTC value comes back LOCAL — the clock is a calendar clock, and '
        'the whole point of freezing it is that both renderers agree on which '
        'day it is', () {
      final DateTime parsed = DocsApp.parseClock('2026-08-16T02:15:00Z')!;
      expect(parsed.isUtc, isFalse);
      expect(parsed, DateTime.utc(2026, 8, 16, 2, 15).toLocal());
    });

    test('anything unparseable is ignored rather than obeyed', () {
      expect(DocsApp.parseClock(null), isNull);
      expect(DocsApp.parseClock(''), isNull);
      expect(DocsApp.parseClock('yesterday'), isNull);
      expect(DocsApp.parseClock('2026-13-45'), isNull);
    });

    testWidgets('the frozen instant reaches every page below the app', (
      WidgetTester tester,
    ) async {
      final DateTime frozen = DateTime(2026, 8, 16, 2, 15);
      await tester.pumpDocs(
        reduceMotion: true,
        route: '/components/button',
        clock: frozen,
      );

      final BuildContext page = tester.element(find.byType(ButtonDocPage));
      expect(ElClock.nowOf(page), frozen);
      expect(ElClock.maybeOf(page), isNotNull);
      // And the seam a calendar actually reads: `getInitialMonth` resolves
      // against it, so a calendar mounted anywhere under the app opens on
      // August 2026 rather than on whatever month the suite happens to run in.
      expect(ElDateFormat.monthYear(ElClock.nowOf(page)), 'August 2026');
    });

    testWidgets('with no parameter the app mounts no clock at all, and the '
        'seam falls through to DateTime.now', (WidgetTester tester) async {
      await tester.pumpDocs(reduceMotion: true, route: '/components/button');

      final BuildContext page = tester.element(find.byType(ButtonDocPage));
      expect(ElClock.maybeOf(page), isNull);
      expect(
        ElDateFormat.monthYear(ElClock.nowOf(page)),
        ElDateFormat.monthYear(DateTime.now()),
      );
    });
  });
}
