import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/showcase/showcase_profile.dart';
import 'package:example/showcase/showcase_reels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder _button(String label) => find.byWidgetPredicate(
  (Widget widget) => widget is ElButton && widget.label == label,
);

Future<void> _pumpPage(WidgetTester tester, {required Widget child}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(ElBreakpoints.sm, ElWidths.page);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  final ElThemeController theme = ElThemeController();
  addTearDown(theme.dispose);
  await tester.pumpWidget(
    ElTheme(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(ElBreakpoints.sm, ElWidths.page),
            disableAnimations: true,
          ),
          child: SizedBox(
            width: ElBreakpoints.sm,
            height: ElWidths.page,
            child: child,
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('profile provides identity, editor, empty, and recovery states', (
    WidgetTester tester,
  ) async {
    final ElToastController toasts = ElToastController();
    addTearDown(toasts.dispose);
    await _pumpPage(tester, child: SignalStudioProfilePage(toasts: toasts));

    expect(find.text('Ari Rocha'), findsOneWidget);
    expect(find.text('Studio pulse'), findsOneWidget);

    await tester.tap(find.text('Edit profile'));
    await tester.pump();
    expect(find.byType(ElDialogContent), findsOneWidget);
    expect(toasts.length, 0);

    await tester.ensureVisible(find.byKey(const Key('profile-cancel')));
    await tester.tap(find.byKey(const Key('profile-cancel')));
    await tester.pump();
    expect(find.byType(ElDialogContent), findsNothing);

    await tester.ensureVisible(find.text('Drafts'));
    await tester.tap(find.text('Drafts'));
    await tester.pump();
    expect(find.text('No drafts are waiting.'), findsOneWidget);

    await tester.ensureVisible(find.text('Saved'));
    await tester.tap(find.text('Saved'));
    await tester.pump();
    expect(find.text('Collections could not load.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets(
    'reels provide vertical content and stateful actions without refresh chrome',
    (WidgetTester tester) async {
      final ElToastController toasts = ElToastController();
      addTearDown(toasts.dispose);
      await _pumpPage(tester, child: SignalStudioReelsPage(toasts: toasts));

      expect(find.text('Ari Rocha'), findsNothing);
      expect(find.text('A quiet system for louder work.'), findsOneWidget);
      expect(_button('Refresh reels'), findsNothing);
      expect(find.byType(ElSkeleton), findsNothing);
      expect(find.byType(ElMediaScrim), findsOneWidget);
      await tester.tap(_button('Show reel details'));
      await tester.pump();
      expect(find.byType(ElMediaScrim), findsNWidgets(2));
      expect(find.text('Ari Rocha'), findsOneWidget);
      expect(
        find.text(
          'The sharpest creative routines make room for the unexpected.',
        ),
        findsOneWidget,
      );
      await tester.tap(find.bySemanticsLabel('Like reel'));
      await tester.pump();
      expect(find.bySemanticsLabel('Remove like'), findsOneWidget);
      expect(toasts.length, 0);
    },
  );
}
