import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/showcase/showcase_dashboard.dart';
import 'package:example/showcase/showcase_feedback.dart';
import 'package:example/showcase/showcase_reels.dart';
import 'package:example/showcase/showcase_shell_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder _button(String label) => find.byWidgetPredicate(
  (Widget widget) => widget is ElButton && widget.label == label,
);

Finder _semanticsLabel(String label) => find.byWidgetPredicate(
  (Widget widget) => widget is Semantics && widget.properties.label == label,
);

Future<ElToastController> _pumpProduct(
  WidgetTester tester, {
  required Widget Function(ElToastController toasts) child,
  required Size size,
  bool disableAnimations = true,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
  final ElThemeController theme = ElThemeController();
  final ElToastController toasts = ElToastController();
  addTearDown(theme.dispose);
  addTearDown(toasts.dispose);
  await tester.pumpWidget(
    ElTheme(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MediaQuery(
          data: MediaQueryData(
            size: size,
            disableAnimations: disableAnimations,
          ),
          child: ShowcaseFeedback(controller: toasts, child: child(toasts)),
        ),
      ),
    ),
  );
  await tester.pump();
  return toasts;
}

void main() {
  testWidgets('dashboard range and queue actions update useful inline state', (
    WidgetTester tester,
  ) async {
    await _pumpProduct(
      tester,
      size: Size(ElBreakpoints.sm, ElWidths.page),
      child: (_) => const ShowcaseDashboard(),
    );
    await tester.pump(ElDurations.fast);
    await tester.pump();

    expect(find.text('82.4K'), findsOneWidget);
    await tester.tap(find.byType(ElSelect<String>));
    await tester.pump();
    await tester.tap(find.text('Last 30 days'));
    await tester.pump();
    expect(find.text('318.6K'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Content queue'),
      el(24),
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(find.text('Content queue'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElButton, 'Schedule').first);
    await tester.pump();
    expect(find.text('SCHEDULED'), findsOneWidget);
    expect(find.widgetWithText(ElButton, 'Undo'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('collapsed reels keep only the title and details control', (
    WidgetTester tester,
  ) async {
    await _pumpProduct(
      tester,
      size: const Size(ElBreakpoints.sm, ElWidths.page),
      child: (ElToastController toasts) =>
          SignalStudioReelsPage(toasts: toasts),
    );

    expect(find.text('A quiet system for louder work.'), findsOneWidget);
    expect(_button('Show reel details'), findsOneWidget);
    expect(_button('Refresh reels'), findsNothing);
    expect(find.byType(ElMediaScrim), findsOneWidget);
    expect(find.byType(ElGlassPanel), findsNothing);
    expect(find.byType(ElGlassPanelDeep), findsNothing);
    expect(
      tester
          .widget<ElIconSwap>(find.byKey(const Key('reel-menu-icon-swap-0')))
          .activeIndex,
      0,
    );
    expect(find.text('Ari Rocha'), findsNothing);
    expect(find.text('84.2K views'), findsNothing);
    expect(find.text('0:24'), findsNothing);
    expect(find.text('Like'), findsNothing);
    expect(find.text('Share'), findsNothing);
    expect(find.text('Comments'), findsNothing);
    expect(find.text('Bookmark'), findsNothing);
    expect(find.bySemanticsLabel('Like reel'), findsNothing);
  });

  testWidgets('390x844 reel stage is centered 9:16 above the fixed dock', (
    WidgetTester tester,
  ) async {
    const Size viewport = Size(390, 844);
    await _pumpProduct(
      tester,
      size: viewport,
      child: (ElToastController toasts) => ShowcaseShellScope(
        compact: true,
        child: SignalStudioReelsPage(toasts: toasts),
      ),
    );

    final Rect stage = tester.getRect(find.byKey(const Key('reel-stage-0')));
    expect(stage.width / stage.height, closeTo(ElMediaRatios.portrait, 0.001));
    expect(stage.center.dx, closeTo(viewport.width / 2, 0.001));
    expect(
      stage.bottom,
      lessThanOrEqualTo(
        viewport.height - el(4) - ShowcaseShellScope.compactDockClearance,
      ),
    );
    expect(
      _semanticsLabel('Reel: A quiet system for louder work.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('expanded reels preserve the ordered menu and live actions', (
    WidgetTester tester,
  ) async {
    final ElToastController toasts = await _pumpProduct(
      tester,
      size: const Size(ElBreakpoints.sm, ElWidths.page),
      child: (ElToastController toasts) =>
          SignalStudioReelsPage(toasts: toasts),
    );

    await tester.tap(_button('Show reel details'));
    await tester.pump();
    expect(find.byType(ElMediaScrim), findsNWidgets(2));
    expect(find.text('A quiet system for louder work.'), findsOneWidget);
    expect(
      tester
          .widget<ElIconSwap>(find.byKey(const Key('reel-menu-icon-swap-0')))
          .activeIndex,
      1,
    );
    final Finder description = find.text(
      'The sharpest creative routines make room for the unexpected.',
    );
    expect(description, findsOneWidget);
    expect(find.text('84.2K views'), findsOneWidget);
    expect(find.text('0:24'), findsOneWidget);
    expect(find.text('Ari Rocha'), findsOneWidget);
    expect(find.widgetWithText(ElButton, 'Follow'), findsOneWidget);
    expect(find.text('Like'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
    expect(find.text('Comments'), findsOneWidget);
    expect(find.text('Bookmark'), findsOneWidget);

    expect(
      tester.getTopLeft(description).dy,
      lessThan(tester.getTopLeft(find.text('84.2K views')).dy),
    );
    expect(
      tester.getTopLeft(find.text('84.2K views')).dy,
      lessThan(tester.getTopLeft(find.text('Ari Rocha')).dy),
    );
    expect(
      tester.getTopLeft(find.text('Ari Rocha')).dy,
      lessThan(tester.getTopLeft(find.text('Like')).dy),
    );
    final List<Finder> actionLabels = <Finder>[
      find.text('Like'),
      find.text('Share'),
      find.text('Comments'),
      find.text('Bookmark'),
    ];
    for (int index = 1; index < actionLabels.length; index++) {
      expect(
        tester.getTopLeft(actionLabels[index - 1]).dx,
        lessThan(tester.getTopLeft(actionLabels[index]).dx),
      );
    }

    await tester.tap(find.bySemanticsLabel('Like reel'));
    await tester.pump();
    expect(find.bySemanticsLabel('Remove like'), findsOneWidget);
    expect(
      tester
          .widget<ElIconSwap>(
            find.descendant(
              of: find.bySemanticsLabel('Remove like'),
              matching: find.byType(ElIconSwap),
            ),
          )
          .activeIndex,
      1,
    );
    expect(toasts.length, 0);

    await tester.tap(find.bySemanticsLabel('Save reel'));
    await tester.pump();
    expect(
      tester
          .widget<ElIconSwap>(
            find.descendant(
              of: find.bySemanticsLabel('Remove saved reel'),
              matching: find.byType(ElIconSwap),
            ),
          )
          .activeIndex,
      1,
    );
    expect(toasts.length, 0);

    await tester.tap(find.widgetWithText(ElButton, 'Follow'));
    await tester.pump();
    expect(find.widgetWithText(ElButton, 'Following'), findsOneWidget);

    await tester.tap(_button('Open comments'));
    await tester.pump();
    expect(find.text('Studio conversation'), findsOneWidget);
    expect(find.text('Mina Chen'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElButton, 'Close'));
    await tester.pump();

    await tester.tap(_button('Share reel'));
    await tester.pump();
    expect(find.text('Share this reel'), findsOneWidget);
    expect(find.text('Threads'), findsOneWidget);
    expect(_button('Prepare for X'), findsOneWidget);
    await tester.tap(find.byKey(const Key('share-copy-link')));
    await tester.pumpAndSettle();
    expect(toasts.length, 1);
    expect(toasts.messageOf(0)?.title, 'Share link copied');
    await tester.tap(find.byKey(const Key('share-threads')));
    await tester.pump();
    expect(toasts.length, 2);
    expect(toasts.messageOf(1)?.title, 'Ready for Threads');
    await tester.tap(find.byKey(const Key('share-x')));
    await tester.pump();
    expect(toasts.length, 3);
    expect(toasts.messageOf(2)?.title, 'Ready for X');
    await tester.tap(find.byKey(const Key('share-done')));
    await tester.pump();
    expect(find.byType(ElDialogContent), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reel actions keep state while variant and icon wheel change', (
    WidgetTester tester,
  ) async {
    await _pumpProduct(
      tester,
      size: const Size(ElBreakpoints.sm, ElWidths.page),
      disableAnimations: false,
      child: (ElToastController toasts) =>
          SignalStudioReelsPage(toasts: toasts),
    );

    await tester.tap(_button('Show reel details'));
    await tester.pump();
    await tester.pump(ElDurations.jelly);
    await tester.pump();
    Future<void> expectWheelChange({
      required Key swapKey,
      required String inactiveLabel,
      required String activeLabel,
      required ElIconTone activeTone,
    }) async {
      final Finder swap = find.byKey(swapKey);
      expect(tester.widget<ElIconSwap>(swap).activeIndex, 0);

      double iconY(int index) => tester
          .getRect(
            find.descendant(of: swap, matching: find.byType(ElIcon)).at(index),
          )
          .center
          .dy;
      final double firstStart = iconY(0);
      final double secondStart = iconY(1);
      final dynamic stateBefore = tester.state(swap);
      final Finder button = find.ancestor(
        of: swap,
        matching: find.byType(ElButton),
      );
      expect(tester.widget<ElButton>(button).variant, ElButtonVariant.ghost);

      await tester.tap(find.bySemanticsLabel(inactiveLabel));
      await tester.pump();

      expect(find.bySemanticsLabel(activeLabel), findsOneWidget);
      expect(tester.widget<ElIconSwap>(swap).activeIndex, 1);
      expect(identical(tester.state(swap), stateBefore), isTrue);
      expect(
        tester.widget<ElButton>(button).variant,
        ElButtonVariant.secondary,
      );

      await tester.pump(ElDurations.fast);
      expect(iconY(0), lessThan(firstStart));
      expect(iconY(1), lessThan(secondStart));
      expect(iconY(0), lessThan(tester.getRect(swap).center.dy));
      final List<ElIcon> icons = tester
          .widgetList<ElIcon>(
            find.descendant(of: swap, matching: find.byType(ElIcon)),
          )
          .toList();
      expect(icons.last.tone, activeTone);
      await tester.pumpAndSettle();
    }

    await expectWheelChange(
      swapKey: const Key('reel-like-icon-swap-0'),
      inactiveLabel: 'Like reel',
      activeLabel: 'Remove like',
      activeTone: ElIconTone.action,
    );
    await expectWheelChange(
      swapKey: const Key('reel-bookmark-icon-swap-0'),
      inactiveLabel: 'Save reel',
      activeLabel: 'Remove saved reel',
      activeTone: ElIconTone.value,
    );
  });

  testWidgets(
    'retry replaces only the unavailable title and recovers in place',
    (WidgetTester tester) async {
      final ElToastController toasts = await _pumpProduct(
        tester,
        size: const Size(390, 844),
        child: (ElToastController toasts) =>
            SignalStudioReelsPage(toasts: toasts),
      );

      for (int index = 0; index < 2; index++) {
        await tester.drag(find.byType(PageView), const Offset(0, -700));
        await tester.pumpAndSettle();
      }

      expect(find.text('Reel unavailable.'), findsOneWidget);
      expect(_button('Retry reel'), findsOneWidget);
      expect(find.byType(ElSkeleton), findsNothing);
      expect(_semanticsLabel('Unavailable reel'), findsOneWidget);

      await tester.tap(_button('Retry reel'));
      await tester.pump();
      expect(find.byType(ElSkeleton), findsOneWidget);
      expect(
        find.byKey(const Key('reel-retry-title-skeleton')),
        findsOneWidget,
      );
      expect(find.text('Reel unavailable.'), findsNothing);
      expect(_button('Retry reel'), findsNothing);

      await tester.pump(ElDurations.slow);
      await tester.pump();
      expect(find.text('Blue-hour studies, back in frame.'), findsOneWidget);
      expect(find.byType(ElSkeleton), findsNothing);
      expect(toasts.length, 1);
      expect(toasts.messageOf(0)?.title, 'Reel restored');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('reel state is per item and wide composition stays safe', (
    WidgetTester tester,
  ) async {
    await _pumpProduct(
      tester,
      size: Size(ElBreakpoints.lg, ElWidths.page),
      child: (ElToastController toasts) =>
          SignalStudioReelsPage(toasts: toasts),
    );

    await tester.tap(_button('Show reel details'));
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Like reel'));
    await tester.pump();
    await tester.drag(find.byType(PageView), Offset(0, -ElWidths.page));
    await tester.pumpAndSettle();

    expect(find.text('Ari Rocha'), findsNothing);
    expect(find.text('Field notes from the night desk.'), findsOneWidget);
    expect(
      find.text('A small collection of materials, light, and late ideas.'),
      findsNothing,
    );
    await tester.tap(_button('Show reel details'));
    await tester.pump();
    expect(find.text('Field notes from the night desk.'), findsOneWidget);
    expect(
      find.text('A small collection of materials, light, and late ideas.'),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('Like reel'), findsOneWidget);
    expect(find.text('Like'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
