/// The rails receive the pointer where they actually paint.
///
/// `docs_layout.dart` builds its wide-viewport layout as a `Stack` with
/// `clipBehavior: Clip.none`, sized from its one non-`Positioned` child (the
/// centred reading column). The two rails are `Positioned` children pinned
/// `-inset` past that box's own edge, which is what lets them reach the
/// screen edge on a wide monitor instead of stopping at the reading column's
/// margin.
///
/// `Clip.none` lets a child PAINT outside its parent's box. It does not make
/// that area hit-testable: `RenderBox.hitTest` gates every call behind
/// `if (_size!.contains(position))` before it ever tries a child, so a
/// pointer or wheel event over the escaped band of a rail never reaches that
/// rail's `Scrollable` at all. The rail looks present and is inert across
/// most of its width — which is exactly "I can't scroll on left and right
/// sidebars."
///
/// That gate is not only the `Stack`'s own. Verified against the real
/// `SiteShell` tree (a diagnostic that walked the mounted ancestor chain
/// from the sidebar rail up to the `RenderView`, not just this file's own
/// harness): `_SiteBody` (site_shell.dart) narrows the box `DocsLayout` is
/// given down to `ElWidths.page`, centred, and every ancestor between that
/// narrowing and the `Stack` — `DocsLayout`'s own outer `Column` and
/// `Semantics`, `_SiteBody`'s own `ConstrainedBox`, and the render objects
/// `SelectionArea` introduces — applies the identical gate against the
/// identical box. Widening only the `Stack`'s own `hitTest` (tried first)
/// left the escaped band exactly as unreachable as before, because
/// `_SiteBody`'s ancestors reject the position before that widened `Stack`
/// is ever reached — and `_SiteBody` is out of this fix's stated scope.
///
/// So the shipped fix does not widen any of those gates. It adds an
/// `Overlay` entry per rail (`_RailHitCatchers` / `_RailWheelCatcher` in
/// `docs_layout.dart`) — the two fixes `Transform.transformHitTests`'s own
/// doc comment names for exactly this situation ("Using an `OverlayEntry` or
/// `OverlayPortal` to place the widget in an `Overlay`"). An `Overlay` entry
/// is not a descendant of any narrow ancestor, so nothing upstream can
/// reject it; it tracks each rail's real on-screen box via a
/// `CompositedTransformTarget`/`Follower` pair and forwards a
/// `PointerScrollEvent` straight to the SAME `ScrollController` the rail's
/// own `SingleChildScrollView` already uses. This test therefore checks two
/// different things for each rail: that the escaped point's hit-test path
/// reaches that catcher (not the rail's own, still out-of-reach
/// `Scrollable`), and — the event a real reader actually sends — that a
/// mouse wheel there moves the SAME `ScrollController` the visible rail
/// scrolls with.
///
/// This test pins the fix at the event layer, not the geometry layer:
/// `docs_rail_height_test.dart` already measures each rail's height and
/// stayed green throughout this defect because it never asks whether a
/// pointer can reach the rail.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/button/page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show MaterialApp;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'the sidebar and table-of-contents rails scroll from their escaped band',
    (WidgetTester tester) async {
      // The rail only renders at ElBreakpoints.lg and wider, and the toc
      // rail only at ElBreakpoints.xl and wider (1280) — 1600 clears both,
      // and is the width the diagnosis's own inset arithmetic uses.
      const double viewportWidth = 1600;
      const double viewportHeight = 900;
      tester.view.physicalSize = const Size(viewportWidth, viewportHeight);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.dark,
      );
      addTearDown(controller.dispose);

      // `_SiteBody` (site_shell.dart) is what actually narrows the box
      // `docs_layout.dart`'s own `LayoutBuilder` is given, down from the raw
      // viewport to `ElWidths.page` (1200), centred — the exact shape that
      // makes `inset` positive and the escaped band exist. The bare
      // `SingleChildScrollView(child: ButtonDocPage())` harness
      // `docs_rail_height_test.dart` uses does NOT reproduce this: nothing
      // above `DocsLayout` narrows its box there, so `inset` is 0 and the
      // rails never leave the Stack's own bounds. This harness adds back
      // the one piece of `_SiteBody`'s shape the defect actually depends on.
      await tester.pumpWidget(
        ElTheme(
          controller: controller,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: ElWidths.page),
                  child: const ButtonDocPage(),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // inset = max(0, (viewport - ElWidths.page) / 2) — docs_layout.dart's
      // own formula, ~line 385. At this viewport it is 200: the Stack's own
      // box (the centred ElWidths.page-wide reading column) spans global x
      // in [200, 1400]. Each rail is ElWidths.rail + el(6) = 264 wide and
      // pinned `inset` past the Stack's edge, so 200 of its 264 painted
      // pixels sit outside that box — the escaped band this test targets.
      const double inset =
          (viewportWidth - ElWidths.page) / 2; // 200
      const double stackLeft = inset; // 200
      const double stackRight = viewportWidth - inset; // 1400

      final Finder sidebarKey = find.byKey(
        const ValueKey<String>('docs-layout-sidebar'),
      );
      final Finder tocKey = find.byKey(
        const ValueKey<String>('docs-layout-toc'),
      );
      expect(sidebarKey, findsOneWidget);
      expect(tocKey, findsOneWidget);

      final Rect sidebarRect = tester.getRect(sidebarKey);
      final Rect tocRect = tester.getRect(tocKey);

      // Sanity-check the diagnosis's own geometry before trusting points
      // derived from it: each rail really does start outside the Stack's
      // box on this side, and really does reach inside it — otherwise these
      // events would not be exercising the escaped band at all.
      expect(sidebarRect.left, lessThan(stackLeft));
      expect(sidebarRect.right, greaterThan(stackLeft));
      expect(tocRect.right, greaterThan(stackRight));
      expect(tocRect.left, lessThan(stackRight));

      // Clearly left of the Stack's own left edge (200), and clearly inside
      // the painted sidebar rail (which starts at global x 0).
      final Offset sidebarEscapedPoint = Offset(50, sidebarRect.top + 20);
      // Clearly right of the Stack's own right edge (1400), and clearly
      // inside the painted toc rail (which reaches global x 1600).
      final Offset tocEscapedPoint = Offset(1550, tocRect.top + 20);

      expect(sidebarRect.contains(sidebarEscapedPoint), isTrue);
      expect(tocRect.contains(tocEscapedPoint), isTrue);

      final SingleChildScrollView sidebarView = tester
          .widget<SingleChildScrollView>(
            find.descendant(
              of: sidebarKey,
              matching: find.byType(SingleChildScrollView),
            ),
          );
      final SingleChildScrollView tocView = tester.widget<SingleChildScrollView>(
        find.descendant(of: tocKey, matching: find.byType(SingleChildScrollView)),
      );
      final ScrollController sidebarController = sidebarView.controller!;
      final ScrollController tocController = tocView.controller!;

      // Hit-test path first. The rail's OWN `Scrollable` is not what answers
      // an escaped point — it still sits behind every narrow ancestor listed
      // above, unchanged — so this looks for the `Overlay`-hosted catcher
      // `docs_layout.dart` adds instead (`_RailWheelCatcher`, keyed so a
      // test can find it precisely rather than guessing among however many
      // other `Listener`s are mounted).
      final Finder sidebarCatcher = find.descendant(
        of: find.byKey(
          const ValueKey<String>('docs-layout-sidebar-wheel-catcher'),
        ),
        matching: find.byType(Listener),
      );
      final Finder tocCatcher = find.descendant(
        of: find.byKey(const ValueKey<String>('docs-layout-toc-wheel-catcher')),
        matching: find.byType(Listener),
      );
      expect(sidebarCatcher, findsOneWidget);
      expect(tocCatcher, findsOneWidget);

      final RenderObject sidebarCatcherBox = tester.renderObject(sidebarCatcher);
      final RenderObject tocCatcherBox = tester.renderObject(tocCatcher);

      final HitTestResult sidebarHit = tester.hitTestOnBinding(
        sidebarEscapedPoint,
      );
      expect(
        sidebarHit.path.map((HitTestEntry e) => e.target),
        contains(sidebarCatcherBox),
        reason:
            'the sidebar rail\'s overlay wheel-catcher never appeared in '
            'the hit-test path for a point inside its escaped band — the '
            'pointer cannot reach it there.',
      );

      final HitTestResult tocHit = tester.hitTestOnBinding(tocEscapedPoint);
      expect(
        tocHit.path.map((HitTestEntry e) => e.target),
        contains(tocCatcherBox),
        reason:
            'the toc rail\'s overlay wheel-catcher never appeared in the '
            'hit-test path for a point inside its escaped band — the '
            'pointer cannot reach it there.',
      );

      // Then the event a real reader sends: a mouse wheel over that same
      // escaped band must actually move the rail's own scroll position —
      // "I can't scroll on left and right sidebars," reproduced as closely
      // as a widget test can.
      expect(sidebarController.offset, equals(0.0));
      final TestPointer sidebarPointer = TestPointer(
        1,
        PointerDeviceKind.mouse,
      );
      sidebarPointer.hover(sidebarEscapedPoint);
      await tester.sendEventToBinding(
        sidebarPointer.scroll(const Offset(0.0, 300.0)),
      );
      await tester.pump();
      expect(
        sidebarController.offset,
        greaterThan(0.0),
        reason:
            'a wheel event over the sidebar rail\'s escaped band did not '
            'move its ScrollController — the rail is present but inert.',
      );

      expect(tocController.offset, equals(0.0));
      final TestPointer tocPointer = TestPointer(2, PointerDeviceKind.mouse);
      tocPointer.hover(tocEscapedPoint);
      await tester.sendEventToBinding(
        tocPointer.scroll(const Offset(0.0, 300.0)),
      );
      await tester.pump();
      expect(
        tocController.offset,
        greaterThan(0.0),
        reason:
            'a wheel event over the toc rail\'s escaped band did not move '
            'its ScrollController — the rail is present but inert.',
      );
    },
  );
}
