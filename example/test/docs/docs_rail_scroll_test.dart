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
/// given down to `LayoutWidths.page`, centred, and every ancestor between that
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
import 'package:flutter/widgets.dart'
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
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'the sidebar and table-of-contents rails scroll from their escaped band',
    (WidgetTester tester) async {
      // The rail only renders at Breakpoints.lg and wider, and the toc
      // rail only at Breakpoints.xl and wider (1280) — 1600 clears both,
      // and is the width the diagnosis's own inset arithmetic uses.
      const double viewportWidth = 1600;
      const double viewportHeight = 900;
      tester.view.physicalSize = const Size(viewportWidth, viewportHeight);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      addTearDown(controller.dispose);

      // `_SiteBody` (site_shell.dart) is what actually narrows the box
      // `docs_layout.dart`'s own `LayoutBuilder` is given, down from the raw
      // viewport to `LayoutWidths.page` (1200), centred — the exact shape that
      // makes `inset` positive and the escaped band exist. The bare
      // `SingleChildScrollView(child: ButtonDocPage())` harness
      // `docs_rail_height_test.dart` uses does NOT reproduce this: nothing
      // above `DocsLayout` narrows its box there, so `inset` is 0 and the
      // rails never leave the Stack's own bounds. This harness adds back
      // the one piece of `_SiteBody`'s shape the defect actually depends on.
      await tester.pumpWidget(
        ThemeScope(
          controller: controller,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: LayoutWidths.page,
                  ),
                  child: const ButtonDocPage(),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // **There is no escaped band any more, and that is the point.**
      //
      // This test was written when the rails were `Positioned` past their
      // Stack's edge so they could reach the screen's edge. That escape is
      // gone: it put them outside every ancestor box that gates a hit test,
      // so their rows were painted and unclickable — a 24px reachable sliver
      // at 1909, which is what "the sidebar only works if my mouse is here"
      // turned out to mean. `docs_rail_bounds_test.dart` now pins the
      // rails inside the boxes that hit-test them, at six widths.
      //
      // What this test guards is unchanged and still worth guarding: a wheel
      // over a rail scrolls THAT rail, not the article underneath it. The
      // points below are simply taken on the rails where they now are,
      // rather than in a band that no longer exists.
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

      // Inside each rail, near its inner edge — the half that was reachable
      // before the fix is now the whole rail, so either side would do.
      final Offset sidebarEscapedPoint = Offset(
        sidebarRect.right - 20,
        sidebarRect.top + 20,
      );
      final Offset tocEscapedPoint = Offset(
        tocRect.left + 20,
        tocRect.top + 20,
      );

      expect(sidebarRect.contains(sidebarEscapedPoint), isTrue);
      expect(tocRect.contains(tocEscapedPoint), isTrue);

      final SingleChildScrollView sidebarView = tester
          .widget<SingleChildScrollView>(
            find.descendant(
              of: sidebarKey,
              matching: find.byType(SingleChildScrollView),
            ),
          );
      final SingleChildScrollView tocView = tester
          .widget<SingleChildScrollView>(
            find.descendant(
              of: tocKey,
              matching: find.byType(SingleChildScrollView),
            ),
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

      final RenderObject sidebarCatcherBox = tester.renderObject(
        sidebarCatcher,
      );
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
      // A notch now GLIDES rather than jumps (`_SmoothRailScroll` in
      // docs_layout.dart), so the rail has not moved on the frame the event
      // lands — it has started an animation. Both halves are asserted: that
      // the movement is animated (nothing on the event frame, something part
      // way through), and that it still arrives, which is the original
      // "the rail is present but inert" check unchanged.
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
        equals(0.0),
        reason:
            'a wheel notch must start a glide, not teleport the rail on the '
            'frame the event arrives.',
      );
      await tester.pump(MotionDurations.fast ~/ 2);
      final double sidebarMidway = sidebarController.offset;
      expect(
        sidebarMidway,
        greaterThan(0.0),
        reason: 'the glide never started.',
      );
      await tester.pump(MotionDurations.fast);
      expect(
        sidebarController.offset,
        greaterThan(sidebarMidway),
        reason:
            'a wheel event over the sidebar rail did not move its '
            'ScrollController — the rail is present but inert.',
      );

      expect(tocController.offset, equals(0.0));
      final TestPointer tocPointer = TestPointer(2, PointerDeviceKind.mouse);
      tocPointer.hover(tocEscapedPoint);
      await tester.sendEventToBinding(
        tocPointer.scroll(const Offset(0.0, 300.0)),
      );
      await tester.pump();
      expect(tocController.offset, equals(0.0));
      await tester.pump(MotionDurations.fast ~/ 2);
      final double tocMidway = tocController.offset;
      expect(tocMidway, greaterThan(0.0));
      await tester.pump(MotionDurations.fast);
      expect(
        tocController.offset,
        greaterThan(tocMidway),
        reason:
            'a wheel event over the toc rail did not move its '
            'ScrollController — the rail is present but inert.',
      );

      // And the same glide over a rail's own body, not just the escaped
      // band. That is the half a reader meets first: a `Listener` mounted
      // INSIDE each `SingleChildScrollView` — so it out-registers that
      // view's own `Scrollable` on the `PointerSignalResolver` — is what
      // keeps the two halves of one rail from behaving differently.
      //
      // The SIDEBAR, not the toc rail: the toc outline is short enough that
      // the 300px notch above already carried it to its `maxScrollExtent`,
      // so a second notch there would be a no-op no matter what handled it.
      // The sidebar's "Components" list is 55 rows and has room left.
      await tester.pump(MotionDurations.fast);
      final double sidebarBefore = sidebarController.offset;
      expect(
        sidebarBefore,
        lessThan(sidebarController.position.maxScrollExtent),
        reason: 'the sidebar must have room left for this to prove anything',
      );
      // A second point on the rail, further down and nearer its outer edge.
      // Before the fix this half of the rail was outside every gating box;
      // now the ordinary hit-test path reaches all of it.
      final Offset sidebarBodyPoint = Offset(
        sidebarRect.left + 20,
        sidebarRect.top + 40,
      );
      expect(sidebarRect.contains(sidebarBodyPoint), isTrue);
      final TestPointer sidebarBodyPointer = TestPointer(
        3,
        PointerDeviceKind.mouse,
      );
      sidebarBodyPointer.hover(sidebarBodyPoint);
      await tester.sendEventToBinding(
        sidebarBodyPointer.scroll(const Offset(0.0, 200.0)),
      );
      await tester.pump();
      expect(
        sidebarController.offset,
        equals(sidebarBefore),
        reason: 'the rail body must glide too, not jump.',
      );
      await tester.pump(MotionDurations.fast * 2);
      expect(sidebarController.offset, greaterThan(sidebarBefore));
    },
  );
}
