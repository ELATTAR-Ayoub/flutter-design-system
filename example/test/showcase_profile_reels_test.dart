import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/showcase/showcase_profile.dart';
import 'package:example/showcase/showcase_reels.dart';
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
import 'package:flutter_test/flutter_test.dart';

Finder _button(String label) => find.byWidgetPredicate(
  (Widget widget) => widget is Button && widget.label == label,
);

Future<void> _pumpPage(WidgetTester tester, {required Widget child}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(Breakpoints.sm, LayoutWidths.page);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  final ThemeController theme = ThemeController();
  addTearDown(theme.dispose);
  await tester.pumpWidget(
    ThemeScope(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(Breakpoints.sm, LayoutWidths.page),
            disableAnimations: true,
          ),
          child: SizedBox(
            width: Breakpoints.sm,
            height: LayoutWidths.page,
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
    final ToastController toasts = ToastController();
    addTearDown(toasts.dispose);
    await _pumpPage(tester, child: SignalStudioProfilePage(toasts: toasts));

    expect(find.text('Ari Rocha'), findsOneWidget);
    expect(find.text('Studio pulse'), findsOneWidget);

    await tester.tap(find.text('Edit profile'));
    await tester.pump();
    expect(find.byType(DialogContent), findsOneWidget);
    expect(toasts.length, 0);

    await tester.ensureVisible(find.byKey(const Key('profile-cancel')));
    await tester.tap(find.byKey(const Key('profile-cancel')));
    await tester.pump();
    expect(find.byType(DialogContent), findsNothing);

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
      final ToastController toasts = ToastController();
      addTearDown(toasts.dispose);
      await _pumpPage(tester, child: SignalStudioReelsPage(toasts: toasts));

      expect(find.text('Ari Rocha'), findsNothing);
      expect(find.text('A quiet system for louder work.'), findsOneWidget);
      expect(_button('Refresh reels'), findsNothing);
      expect(find.byType(Skeleton), findsNothing);
      expect(find.byType(MediaScrim), findsOneWidget);
      await tester.tap(_button('Show reel details'));
      await tester.pump();
      expect(find.byType(MediaScrim), findsNWidgets(2));
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
