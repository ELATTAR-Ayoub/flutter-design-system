/// The rails stay on screen, at every width.
///
/// `docs_layout.dart` paints each rail past its own box on purpose — that is
/// what puts them at the screen edges instead of at the reading column's
/// margin. The escape is a `Positioned(left: -inset)` inside a
/// `Clip.none` `Stack`, where
/// `inset = max(0, (viewport - constraints.maxWidth) / 2)`.
///
/// That arithmetic assumes the box `DocsLayout` is handed is **centred in the
/// viewport**. When it is, the two terms cancel and the rail lands exactly on
/// the screen edge. When it is not — when something above adds asymmetric
/// chrome, or caps the box at a different measure than the one this
/// calculation assumes — they stop cancelling, and the error grows with the
/// viewport: the wider the window, the further off screen the rails go.
///
/// Found at 1909 on the deployed site, where both rails had walked past the
/// edges and showed only the tail of each label. Reproduced locally at the
/// same width and clean at 1440, which is why every capture taken during the
/// rollout missed it.
library;

import 'dart:math' as math;

import 'package:flutter/gestures.dart' show HitTestEntry, HitTestResult;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/button/page.dart';
import 'package:flutter/material.dart' show MaterialApp, SelectionArea;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Replicates `_SiteBody` (site_shell.dart) EXACTLY, because an
/// approximation of it does not reproduce the defect.
///
/// The first version of this test used a bare `Center` +
/// `ConstrainedBox(maxWidth: ElWidths.page)` — the shape
/// `docs_rail_scroll_test.dart` uses — and passed at every width while the
/// real site was visibly broken at 1909. The shell's own
/// `Padding(horizontal: el(12))` before the `Align` is the piece that
/// matters, so it is reproduced here rather than summarised.
Widget _host({required Widget child, required bool desktop}) => ElTheme(
  controller: ElThemeController(mode: ElThemeMode.dark),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Center(
      // `SiteShell`'s own hard cap. THIS is the piece that reproduces the
      // defect: below 1680 it is wider than the viewport and nothing clips,
      // which is why 1440 and 1600 looked clean. Above it, the rails escape
      // past a boundary that does clip, and lose the difference.
      child: SizedBox(
        width: ElWidths.shell,
        child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: desktop ? el(12) : el(6),
          vertical: el(12),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ElWidths.page),
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[child],
              ),
            ),
          ),
        ),
      ),
        ),
      ),
    ),
  ),
);

void main() {
  // 1440 was the rollout's capture width and is known good; 1600 was also
  // captured. The wide end is where the defect lives, so it is sampled
  // densely rather than at one point.
  for (final double width in <double>[1280, 1440, 1600, 1728, 1909, 2560]) {
    testWidgets('both rails stay within the viewport at ${width.toInt()}', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final List<String> routed = <String>[];
      await tester.pumpWidget(
        _host(
          child: ButtonDocPage(onNavigate: routed.add),
          desktop: true,
        ),
      );
      await tester.pump();

      final Finder sidebar = find.byKey(
        const ValueKey<String>('docs-layout-sidebar'),
      );
      final Finder toc = find.byKey(const ValueKey<String>('docs-layout-toc'));

      expect(sidebar, findsOneWidget, reason: 'no sidebar rail at $width');

      // The paintable region, which is the SHELL, not the viewport.
      // `SiteShell` centres everything in a hard `SizedBox(width:
      // ElWidths.shell)`; a rail positioned outside that box still has a full
      // width in the widget tree — a `SizedBox` does not clip — and is cut at
      // paint time. So this measures escape past the shell, which layout can
      // see, rather than the clipped width, which only the browser's
      // semantics rects report.
      final double shellLeft = math.max(0, (width - ElWidths.shell) / 2);
      final double shellRight = width - shellLeft;

      final Rect sidebarRect = tester.getRect(sidebar);
      expect(
        sidebarRect.left,
        greaterThanOrEqualTo(shellLeft),
        reason:
            'the sidebar rail starts at x=${sidebarRect.left}, left of the '
            'shell edge at $shellLeft — everything before that edge is '
            'clipped away, so the labels lose their first characters and the '
            'rows there cannot be clicked',
      );

      // Painted is not the same as reachable. Hit-testing is gated by EVERY
      // ancestor's box, so a rail positioned outside its Stack's box is
      // rejected before the row is ever reached — it looks present and does
      // nothing. That is the defect this half exists for, and it is not
      // visible in a screenshot.
      final Finder row = find.byKey(
        const ValueKey<String>('docs-sidebar:/docs/installation'),
      );
      expect(row, findsOneWidget, reason: 'no rail row to tap at $width');
      await tester.tap(row, warnIfMissed: false);
      await tester.pump();
      expect(
        routed,
        contains('/docs/installation'),
        reason:
            'tapping a rail row at $width routed nowhere — the row is '
            'painted outside every ancestor box that gates the hit test',
      );

      if (toc.evaluate().isNotEmpty) {
        final Rect tocRect = tester.getRect(toc);
        // The right rail fails the same way, mirrored: it escapes rightward,
        // so only its LEFT sliver falls inside the gating box. Asserted by
        // hit test rather than by tapping, because a toc row scrolls the
        // article rather than routing — reachability is the thing at issue.
        final Finder tocRow = find.byKey(
          const ValueKey<String>('docs-layout-toc-entry:install'),
        );
        expect(tocRow, findsOneWidget, reason: 'no toc row at $width');
        final RenderObject tocRowBox = tester.renderObject(tocRow);
        final HitTestResult hit = tester.hitTestOnBinding(
          tester.getCenter(tocRow),
        );
        expect(
          hit.path.map((HitTestEntry e) => e.target),
          contains(tocRowBox),
          reason:
              'a pointer over the toc row at $width never reaches it — the '
              'rail is painted outside a box that gates the hit test',
        );

        expect(
          tocRect.right,
          lessThanOrEqualTo(shellRight),
          reason:
              'the toc rail ends at x=${tocRect.right}, right of the shell '
              'edge at $shellRight — the overhang is clipped, so its labels '
              'are cut off and the rows there cannot be clicked',
        );
      }
    });
  }
}
