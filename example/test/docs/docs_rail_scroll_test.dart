/// A wheel scroll over a rail scrolls that rail, not the page underneath it.
///
/// `docs_layout.dart` used to place its rails past a `Stack`'s own hit-tested
/// box, which broke wheel scrolling over the escaped band and needed an
/// `Overlay`-hosted catcher to patch around it (`_RailHitCatchers`,
/// `_RailWheelCatcher`). The rails are inside their own box now — a plain
/// three-column `Row` — so the whole premise is gone, and with it that
/// machinery. What is still worth guarding is the behaviour it existed for:
/// a mouse wheel over the sidebar or the "ON THIS PAGE" rail moves that
/// rail's own `ScrollController`, and leaves the page's own scroll position
/// alone.
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
  testWidgets('a wheel scroll over a rail scrolls the rail, not the page', (
    WidgetTester tester,
  ) async {
    // Clears both breakpoints (Breakpoints.lg and Breakpoints.xl), so both
    // rails are on screen.
    const double viewportWidth = 1600;
    const double viewportHeight = 900;
    tester.view.physicalSize = const Size(viewportWidth, viewportHeight);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ThemeController controller = ThemeController(mode: ColorMode.dark);
    addTearDown(controller.dispose);

    final ScrollController page = ScrollController();
    addTearDown(page.dispose);

    await tester.pumpWidget(
      ThemeScope(
        controller: controller,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SingleChildScrollView(
            controller: page,
            child: const ButtonDocPage(),
          ),
        ),
      ),
    );
    await tester.pump();

    final Finder sidebarKey = find.byKey(
      const ValueKey<String>('docs-layout-sidebar'),
    );
    final Finder tocKey = find.byKey(const ValueKey<String>('docs-layout-toc'));
    expect(sidebarKey, findsOneWidget);
    expect(tocKey, findsOneWidget);

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

    final Offset sidebarPoint = tester.getCenter(sidebarKey);
    final Offset tocPoint = tester.getCenter(tocKey);
    final double pageResting = page.offset;

    // A notch glides (`_SmoothRailScroll`) rather than jumping, so the rail
    // has not moved on the frame the event lands — it has started an
    // animation. Both halves matter: that it is animated, and that it still
    // arrives.
    final double sidebarResting = sidebarController.offset;
    final TestPointer sidebarPointer = TestPointer(1, PointerDeviceKind.mouse);
    sidebarPointer.hover(sidebarPoint);
    await tester.sendEventToBinding(
      sidebarPointer.scroll(const Offset(0.0, 300.0)),
    );
    await tester.pump();
    expect(sidebarController.offset, equals(sidebarResting));
    await tester.pump(MotionDurations.fast * 2);
    expect(
      sidebarController.offset,
      greaterThan(sidebarResting),
      reason:
          'a wheel event over the sidebar rail did not move its own '
          'ScrollController',
    );
    expect(
      page.offset,
      equals(pageResting),
      reason: 'a wheel event over the sidebar rail must not scroll the page',
    );

    final double tocResting = tocController.offset;
    expect(tocResting, equals(0.0));
    final TestPointer tocPointer = TestPointer(2, PointerDeviceKind.mouse);
    tocPointer.hover(tocPoint);
    await tester.sendEventToBinding(
      tocPointer.scroll(const Offset(0.0, 300.0)),
    );
    await tester.pump();
    expect(tocController.offset, equals(tocResting));
    await tester.pump(MotionDurations.fast * 2);
    expect(
      tocController.offset,
      greaterThan(tocResting),
      reason:
          'a wheel event over the toc rail did not move its own '
          'ScrollController',
    );
    expect(
      page.offset,
      equals(pageResting),
      reason: 'a wheel event over the toc rail must not scroll the page',
    );
  });
}
