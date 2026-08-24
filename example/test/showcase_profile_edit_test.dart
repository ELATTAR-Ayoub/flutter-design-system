import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/showcase/showcase_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<ElToastController> _pumpProfile(
  WidgetTester tester, {
  required Size size,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

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
          data: MediaQueryData(size: size, disableAnimations: true),
          child: SignalStudioProfilePage(toasts: toasts),
        ),
      ),
    ),
  );
  await tester.pump();
  return toasts;
}

Future<void> _openEditor(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('profile-edit')));
  await tester.pump();
  expect(find.byType(ElDialogContent), findsOneWidget);
}

Future<void> _tapDialogAction(WidgetTester tester, Key key) async {
  final Finder action = find.byKey(key);
  await tester.ensureVisible(action);
  await tester.tap(action);
}

void main() {
  testWidgets('editor exposes complete profile fields and media actions', (
    WidgetTester tester,
  ) async {
    final ElToastController toasts = await _pumpProfile(
      tester,
      size: const Size(ElBreakpoints.md, ElWidths.page),
    );

    await _openEditor(tester);

    expect(find.byKey(const Key('profile-display-name')), findsOneWidget);
    expect(find.byKey(const Key('profile-handle')), findsOneWidget);
    expect(find.byKey(const Key('profile-location')), findsOneWidget);
    expect(find.byKey(const Key('profile-bio')), findsOneWidget);
    expect(find.byKey(const Key('profile-category')), findsOneWidget);
    expect(find.byKey(const Key('profile-visibility')), findsOneWidget);
    expect(find.byKey(const Key('profile-status')), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('profile-change-avatar')));
    await tester.tap(find.byKey(const Key('profile-change-avatar')));
    await tester.pump();
    expect(find.text('Media selection ready'), findsOneWidget);
    expect(
      find.text('A new avatar is selected and ready to save.'),
      findsOneWidget,
    );
    expect(toasts.length, 0);
  });

  testWidgets('invalid save shows inline errors and focuses first field', (
    WidgetTester tester,
  ) async {
    final ElToastController toasts = await _pumpProfile(
      tester,
      size: const Size(ElContainers.sm, ElBreakpoints.sm),
    );
    await _openEditor(tester);

    await tester.enterText(find.byKey(const Key('profile-display-name')), '');
    await tester.enterText(find.byKey(const Key('profile-handle')), 'bad');
    await tester.enterText(find.byKey(const Key('profile-location')), '');
    await tester.enterText(find.byKey(const Key('profile-bio')), 'Too short');
    await _tapDialogAction(tester, const Key('profile-save'));
    await tester.pump();

    expect(
      find.text('Enter a display name with at least 2 characters.'),
      findsOneWidget,
    );
    expect(
      find.text('Use @ followed by 3–24 letters, numbers, or underscores.'),
      findsOneWidget,
    );
    expect(find.text('Add the city you create from.'), findsOneWidget);
    expect(
      find.text('Tell your audience a little more in at least 24 characters.'),
      findsOneWidget,
    );
    final ElInput displayName = tester.widget<ElInput>(
      find.byKey(const Key('profile-display-name')),
    );
    expect(displayName.focusNode?.hasFocus, isTrue);
    expect(toasts.length, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('cancel discards edits without feedback', (
    WidgetTester tester,
  ) async {
    final ElToastController toasts = await _pumpProfile(
      tester,
      size: const Size(ElContainers.sm, ElWidths.page),
    );
    await _openEditor(tester);

    await tester.enterText(
      find.byKey(const Key('profile-display-name')),
      'Uncommitted name',
    );
    await _tapDialogAction(tester, const Key('profile-cancel'));
    await tester.pump();

    expect(find.byType(ElDialogContent), findsNothing);
    expect(find.text('Ari Rocha'), findsOneWidget);
    expect(find.text('Uncommitted name'), findsNothing);
    expect(toasts.length, 0);
  });

  testWidgets('save disables form, commits details, and emits one toast', (
    WidgetTester tester,
  ) async {
    final ElToastController toasts = await _pumpProfile(
      tester,
      size: const Size(ElBreakpoints.md, ElWidths.page),
    );
    await _openEditor(tester);

    await tester.enterText(
      find.byKey(const Key('profile-display-name')),
      'Ari Moreno',
    );
    await tester.enterText(
      find.byKey(const Key('profile-location')),
      'Kaohsiung',
    );
    await tester.enterText(
      find.byKey(const Key('profile-bio')),
      'I build thoughtful visual systems for independent studios and cultural teams.',
    );
    await _tapDialogAction(tester, const Key('profile-save'));
    await tester.pump();

    final ElButton save = tester.widget<ElButton>(
      find.byKey(const Key('profile-save')),
    );
    final ElInput name = tester.widget<ElInput>(
      find.byKey(const Key('profile-display-name')),
    );
    expect(save.loading, isTrue);
    expect(save.onPressed, isNull);
    expect(name.enabled, isFalse);
    expect(toasts.length, 0);

    await tester.pump(ElDurations.base);
    await tester.pump();

    expect(find.byType(ElDialogContent), findsNothing);
    expect(find.text('Ari Moreno'), findsOneWidget);
    expect(find.text('@arirocha · Kaohsiung'), findsOneWidget);
    expect(
      find.text(
        'I build thoughtful visual systems for independent studios and cultural teams.',
      ),
      findsOneWidget,
    );
    expect(toasts.length, 1);
    expect(toasts.messageOf(0)?.title, 'Profile updated');
  });

  testWidgets('share profile opens the complete share dialog', (
    WidgetTester tester,
  ) async {
    final ElToastController toasts = await _pumpProfile(
      tester,
      size: const Size(ElContainers.sm, ElWidths.page),
    );

    await tester.tap(find.byKey(const Key('profile-share')));
    await tester.pump();

    expect(find.byType(ElDialogContent), findsOneWidget);
    expect(find.text('Share profile'), findsWidgets);
    expect(find.text('https://signal.studio/arirocha'), findsOneWidget);
    expect(find.text('Copy link'), findsOneWidget);
    expect(find.text('Threads'), findsOneWidget);
    expect(find.text('X'), findsOneWidget);

    await _tapDialogAction(tester, const Key('share-copy-link'));
    await tester.pump();
    expect(toasts.length, 1);
    expect(toasts.messageOf(0)?.title, 'Share link copied');

    await _tapDialogAction(tester, const Key('share-threads'));
    await tester.pump();
    expect(toasts.length, 2);

    await _tapDialogAction(tester, const Key('share-x'));
    await tester.pump();
    expect(toasts.length, 3);

    await _tapDialogAction(tester, const Key('share-done'));
    await tester.pump();
    expect(find.byType(ElDialogContent), findsNothing);
  });

  testWidgets('profile and editor reflow at narrow and wide sizes', (
    WidgetTester tester,
  ) async {
    await _pumpProfile(
      tester,
      size: const Size(ElContainers.sm, ElBreakpoints.sm),
    );
    expect(find.text('About the creator'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _openEditor(tester);
    expect(find.byType(SingleChildScrollView), findsWidgets);
    expect(tester.takeException(), isNull);

    await _tapDialogAction(tester, const Key('profile-cancel'));
    await tester.pump();
    tester.view.physicalSize = const Size(ElBreakpoints.lg, ElWidths.page);
    await tester.pump();
    expect(find.text('About the creator'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
