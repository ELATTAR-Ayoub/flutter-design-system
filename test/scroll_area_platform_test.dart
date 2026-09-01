/// TARGET SIZING — the explicit platform decision on [ScrollArea]'s thumb,
/// held as a contract: see the doc comment on [ScrollArea] and on `_Rail`'s
/// `build` in `lib/src/components/ui/scroll_area.dart`.
///
/// The thumb is pointer-only. It never mounts without a hovering mouse — a
/// touch device never sees it — so it earns no [TouchTargets.minimum] of its
/// own; instead the scrollable underneath it stays fully operable by drag and
/// by the platform's native keyboard scrolling, with or without the thumb in
/// the tree, and the thumb (when a mouse does reveal it) carries no semantics
/// node a screen reader could offer as a control.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart' show MaterialApp, Material;
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

/// Copied from `test/interaction_kernel_test.dart`'s `host()` — a real app
/// root, so keyboard shortcuts and focus traversal are in scope.
Widget host(Widget child, {ColorMode mode = ColorMode.dark}) => ThemeScope(
  controller: ThemeController(mode: mode),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Builder(
      builder: (BuildContext context) => DefaultTextStyle(
        style: StyledText.styleOf(
          context,
          TextStyles.body,
          color: ThemeScope.of(context).foreground,
        ),
        child: Material(child: Center(child: child)),
      ),
    ),
  ),
);

/// A [ScrollArea] tall enough to overflow a 200px frame, wired to
/// [controller] so a test can read the offset directly.
Widget frame(ScrollController controller) => SizedBox(
  height: 200,
  width: 200,
  child: ScrollArea(
    controller: controller,
    child: const SizedBox(height: 2000, width: 200),
  ),
);

void main() {
  group('ScrollArea — the thumb is pointer-only', () {
    testWidgets('the thumb is not in the tree at rest', (WidgetTester t) async {
      final ScrollController controller = ScrollController();
      addTearDown(controller.dispose);
      await t.pumpWidget(host(frame(controller)));
      await t.pump();

      // `_Rail` is the only widget wrapped in `thumbSemanticsKey` — desktop
      // `ScrollBehavior`s auto-wrap every `Scrollable` in their own
      // `Scrollbar`, which carries an unrelated `ExcludeSemantics` of its
      // own, so a bare `find.byType(ExcludeSemantics)` is not specific
      // enough here.
      expect(find.byKey(thumbSemanticsKey), findsNothing);
    });

    testWidgets(
      'a mouse hovering the frame reveals the thumb, and it carries no '
      'semantics of its own',
      (WidgetTester t) async {
        final ScrollController controller = ScrollController();
        addTearDown(controller.dispose);
        await t.pumpWidget(host(frame(controller)));
        await t.pump();

        final TestGesture mouse = await t.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        addTearDown(mouse.removePointer);
        await mouse.addPointer(location: t.getCenter(find.byType(ScrollArea)));
        await t.pump();

        expect(find.byKey(thumbSemanticsKey), findsOneWidget);
      },
    );

    testWidgets('the content scrolls by drag with the thumb never shown', (
      WidgetTester t,
    ) async {
      final ScrollController controller = ScrollController();
      addTearDown(controller.dispose);
      await t.pumpWidget(host(frame(controller)));
      await t.pump();

      // No mouse ever entered, so the thumb was never in the tree — this
      // drag lands on the content itself.
      expect(find.byKey(thumbSemanticsKey), findsNothing);
      expect(controller.position.pixels, 0);

      await t.drag(find.byType(ScrollArea), const Offset(0, -150));
      await t.pump();

      expect(controller.position.pixels, greaterThan(0));
    });

    testWidgets(
      'the scrollable answers a keyboard scroll intent independently of '
      'the thumb',
      (WidgetTester t) async {
        final ScrollController controller = ScrollController();
        addTearDown(controller.dispose);
        await t.pumpWidget(host(frame(controller)));
        await t.pump();

        // Never hovered — the thumb is not mounted for this case either.
        expect(find.byKey(thumbSemanticsKey), findsNothing);
        expect(controller.position.pixels, 0);

        // `ScrollIntent` is exactly what a physical arrow-key / Page Down
        // press resolves to once a `Scrollable` holds focus — invoking it
        // is the deterministic way to assert "keyboard-operable" without
        // depending on this test harness's focus-traversal timing, and it
        // never touches the thumb. `Actions.invoke` walks *upward* from the
        // given context, so the context has to be a descendant of the
        // `Scrollable`'s own `Actions` scope — its content, not the
        // `Scrollable` element itself, which sits above that scope.
        final BuildContext content = t.element(
          find.byWidgetPredicate(
            (Widget w) => w is SizedBox && w.height == 2000,
          ),
        );
        Actions.invoke(
          content,
          const ScrollIntent(direction: AxisDirection.down),
        );
        await t.pumpAndSettle();

        expect(controller.position.pixels, greaterThan(0));
      },
    );
  });
}
