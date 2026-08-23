/// The deterministic-preview gate for Shots (Phase G, ruling 5).
///
/// Not goldens — this repository has no golden infrastructure and standing one
/// up is a phase of its own. What a preview has to be is *reproducible*: the
/// same composition, at the same measure, in the same theme, painting the same
/// frame however long you wait. That is four properties, and each is pinned
/// with the rig the docs app already uses:
///
/// * **Real test-view sizing.** `tester.view.physicalSize`, not a synthetic
///   [MediaQuery] — a Phase F review correction. A Shot reads
///   `MediaQuery.sizeOf(context).width` to pick its column count, and a fake
///   size that the render view disagrees with would prove nothing about what
///   a reader sees at 390.
/// * **A live [DsThemeController], flipped in place.** The controller is the
///   cascade; changing its mode has to re-resolve the page without the app
///   being rebuilt, because that is what the theme toggle does.
/// * **`MediaQueryData.disableAnimations` as the motion freeze**, applied
///   below the app exactly as `main.dart` applies it.
/// * **Nothing repainting once a frame has landed** — [_expectStill],
///   borrowed from `boot_params_test.dart`, which is the property the capture
///   rig actually needs.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/shots/dashboard_overview/dashboard_overview_shot.dart';
import 'package:example/shots/settings_profile/settings_profile_shot.dart';
import 'package:example/shots/sign_in_flow/sign_in_flow_shot.dart';
import 'package:example/shots_docs/catalog.dart';
import 'package:example/shots_docs/shot_preview_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter_test/flutter_test.dart';

/// The phone frame the mobile pass shoots at.
const Size _phone = Size(390, 844);

/// The frame the design bar is set at (design spec §7).
const Size _desktop = Size(1440, 900);

/// Every painter on screen, in tree order.
///
/// [ScrollbarPainter] is left out for `boot_params_test`'s reason: the
/// scrollbar's fade is Flutter's own chrome, it is not routed through
/// `dsAnimationDuration`, and no preview photographs it.
List<CustomPainter> _painters(WidgetTester tester) => <CustomPainter>[
  for (final CustomPaint paint in tester.widgetList<CustomPaint>(
    find.byType(CustomPaint),
  ))
    ...<CustomPainter?>[paint.painter, paint.foregroundPainter]
        .whereType<CustomPainter>()
        .where((CustomPainter p) => p is! ScrollbarPainter),
];

/// Asserts that not one painter on screen wants to repaint across [over].
Future<void> _expectStill(
  WidgetTester tester,
  Duration over, {
  required String reason,
}) async {
  final List<CustomPainter> before = _painters(tester);
  await tester.pump(over);
  final List<CustomPainter> after = _painters(tester);

  expect(after, hasLength(before.length), reason: 'the tree changed shape');
  for (int i = 0; i < after.length; i++) {
    expect(
      after[i].shouldRepaint(before[i]),
      isFalse,
      reason: '${after[i].runtimeType} repainted — $reason',
    );
  }
}

/// The preview route as `main.dart` will mount it: a live controller over a
/// bare app, with the motion freeze below it.
///
/// The freeze sits under [MaterialApp] rather than over it because that is
/// where the docs app puts it, and because an overlay raised by a Shot is a
/// child of the page in the **element** tree — [DsDialog] is an
/// [OverlayPortal], not a route — so it inherits this too.
class _PreviewHarness extends StatelessWidget {
  const _PreviewHarness({required this.controller, required this.name});

  final DsThemeController controller;
  final String name;

  @override
  Widget build(BuildContext context) => DsTheme(
    controller: controller,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (BuildContext context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: ShotPreviewHost(name: name),
        ),
      ),
    ),
  );
}

extension on WidgetTester {
  /// Sizes the render view in logical pixels, so the breakpoint a Shot reads
  /// is the number a reader's viewport reports.
  void useViewport(Size size) {
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    addTearDown(view.reset);
  }

  Future<void> pumpPreview(
    String name, {
    required Size size,
    required DsThemeController controller,
  }) async {
    useViewport(size);
    await pumpWidget(_PreviewHarness(controller: controller, name: name));
    await pump();
    // Past every transition the resting tree can be running.
    await pump(DsDurations.jelly);
  }
}

/// The background the host paints, which is the one pixel that has to move
/// when the theme does.
Color _background(WidgetTester tester) => tester
    .widget<ColoredBox>(
      find
          .descendant(
            of: find.byType(ShotPreviewHost),
            matching: find.byType(ColoredBox),
          )
          .first,
    )
    .color;

/// The tops of the four stat tiles, which is how "four abreast" is measured
/// without asking the widget what it decided.
List<double> _tileTops(WidgetTester tester) => <double>[
  for (final Element element
      in find
          .descendant(
            of: find.byKey(const ValueKey<String>('dashboard-tiles')),
            matching: find.byType(DsCard),
          )
          .evaluate())
    tester.getRect(find.byElementPredicate((Element e) => e == element)).top,
];

void main() {
  group('every Shot renders at both frames, in both themes', () {
    for (final ShotDocEntry entry in shotDocs) {
      for (final (String label, Size size) in <(String, Size)>[
        ('narrow', _phone),
        ('wide', _desktop),
      ]) {
        testWidgets('${entry.name} · $label · dark then light', (
          WidgetTester tester,
        ) async {
          final DsThemeController controller = DsThemeController();
          addTearDown(controller.dispose);

          await tester.pumpPreview(
            entry.name,
            size: size,
            controller: controller,
          );

          expect(find.byType(ShotPreviewHost), findsOneWidget);
          expect(find.byKey(ShotPreviewHost.viewportKey), findsOneWidget);
          expect(find.byType(DsCard), findsAtLeastNWidgets(1));
          expect(tester.takeException(), isNull);

          final BuildContext page = tester.element(
            find.byType(ShotPreviewHost),
          );
          expect(MediaQuery.maybeDisableAnimationsOf(page), isTrue);
          expect(dsAnimationDuration(page, DsDurations.jelly), Duration.zero);

          expect(_background(tester), DsThemeData.dark.background);

          // The controller is flipped in place: no new app, no new element
          // tree — the cascade re-resolves exactly as the theme toggle makes
          // it re-resolve.
          controller.setMode(DsThemeMode.light);
          await tester.pump();

          expect(_background(tester), DsThemeData.light.background);
          expect(find.byType(DsCard), findsAtLeastNWidgets(1));
          expect(tester.takeException(), isNull);

          await _expectStill(
            tester,
            DsDurations.jelly,
            reason: 'the ${entry.name} preview is not deterministic',
          );
        });
      }
    }
  });

  group('the composition each slug mounts', () {
    testWidgets('settings-profile carries its fields, selects and actions', (
      WidgetTester tester,
    ) async {
      final DsThemeController controller = DsThemeController();
      addTearDown(controller.dispose);
      await tester.pumpPreview(
        'settings-profile',
        size: _desktop,
        controller: controller,
      );

      expect(find.byType(SettingsProfileShot), findsOneWidget);
      expect(find.byType(DsInput), findsNWidgets(2));
      expect(find.byType(DsSelect<String>), findsNWidgets(2));
      expect(find.byType(DsFieldLabel), findsNWidgets(4));
      expect(find.byType(DsFieldDescription), findsNWidgets(4));
      expect(find.text('Save changes'), findsOneWidget);
      // Pristine: neither action is live.
      expect(
        tester
            .widget<DsButton>(
              find.byKey(const ValueKey<String>('settings-profile-save')),
            )
            .onPressed,
        isNull,
      );
    });

    testWidgets('sign-in-flow carries both fields, the reveal and the rule', (
      WidgetTester tester,
    ) async {
      final DsThemeController controller = DsThemeController();
      addTearDown(controller.dispose);
      await tester.pumpPreview(
        'sign-in-flow',
        size: _phone,
        controller: controller,
      );

      expect(find.byType(SignInFlowShot), findsOneWidget);
      expect(find.byType(DsInput), findsNWidgets(2));
      expect(find.byType(DsFieldVisibility), findsAtLeastNWidgets(1));
      expect(
        find.byKey(const ValueKey<String>('sign-in-reveal')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('sign-in-forgot')),
        findsOneWidget,
      );
      expect(find.text('Continue with SSO'), findsOneWidget);
      // Empty: the reset dialog is not mounted until it is opened.
      expect(
        find.byKey(const ValueKey<String>('sign-in-reset-dialog')),
        findsNothing,
      );
    });

    testWidgets('dashboard-overview carries a tooltip on every tile', (
      WidgetTester tester,
    ) async {
      final DsThemeController controller = DsThemeController();
      addTearDown(controller.dispose);
      await tester.pumpPreview(
        'dashboard-overview',
        size: _desktop,
        controller: controller,
      );

      expect(find.byType(DashboardOverviewShot), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
      expect(find.byType(DsSelect<String>), findsNWidgets(1));
      expect(
        find.byType(DsTooltip),
        findsNWidgets(DashboardOverviewShot.defaultStats.length),
      );
      expect(
        find.byType(DsDialog),
        findsNWidgets(DashboardOverviewShot.defaultActivity.length),
      );
    });
  });

  group('the responsive rule is the viewport, not a guess', () {
    testWidgets('four stat tiles sit abreast at 1440 and stack at 390', (
      WidgetTester tester,
    ) async {
      final DsThemeController controller = DsThemeController();
      addTearDown(controller.dispose);

      await tester.pumpPreview(
        'dashboard-overview',
        size: _desktop,
        controller: controller,
      );
      expect(DashboardOverviewShot.columnsFor(_desktop.width), 4);
      final List<double> wide = _tileTops(tester);
      expect(wide, hasLength(4));
      expect(wide.toSet(), hasLength(1), reason: 'the tiles are not abreast');

      await tester.pumpPreview(
        'dashboard-overview',
        size: _phone,
        controller: controller,
      );
      expect(DashboardOverviewShot.columnsFor(_phone.width), 1);
      final List<double> narrow = _tileTops(tester);
      expect(narrow, hasLength(4));
      expect(narrow.toSet(), hasLength(4), reason: 'the tiles did not stack');
    });

    testWidgets('the settings pair splits at md and stacks below it', (
      WidgetTester tester,
    ) async {
      final DsThemeController controller = DsThemeController();
      addTearDown(controller.dispose);

      await tester.pumpPreview(
        'settings-profile',
        size: _desktop,
        controller: controller,
      );
      final Rect wideName = tester.getRect(
        find.byKey(const ValueKey<String>('settings-profile-name')),
      );
      final Rect wideEmail = tester.getRect(
        find.byKey(const ValueKey<String>('settings-profile-email')),
      );
      expect(wideName.top, wideEmail.top);
      expect(wideName.left, lessThan(wideEmail.left));

      await tester.pumpPreview(
        'settings-profile',
        size: _phone,
        controller: controller,
      );
      final Rect narrowName = tester.getRect(
        find.byKey(const ValueKey<String>('settings-profile-name')),
      );
      final Rect narrowEmail = tester.getRect(
        find.byKey(const ValueKey<String>('settings-profile-email')),
      );
      expect(narrowName.left, narrowEmail.left);
      expect(narrowName.top, lessThan(narrowEmail.top));
    });
  });

  group('state, driven from the composition itself', () {
    testWidgets('an invalid email is reported only once Save is pressed', (
      WidgetTester tester,
    ) async {
      final DsThemeController controller = DsThemeController();
      addTearDown(controller.dispose);
      await tester.pumpPreview(
        'settings-profile',
        size: _desktop,
        controller: controller,
      );

      // Zod 4's predicate — which `DsRule.email` is verbatim — needs a dotted
      // domain and a two-letter TLD, so this fails where a browser's own
      // type="email" would accept it.
      await tester.enterText(
        find.byKey(const ValueKey<String>('settings-profile-email')),
        'alex@example',
      );
      await tester.pump();

      // Dirty: both actions came alive, and nothing is being said yet.
      expect(find.text('You have unsaved changes.'), findsOneWidget);
      expect(find.text('That is not an email address.'), findsNothing);

      await tester.tap(
        find.byKey(const ValueKey<String>('settings-profile-save')),
      );
      await tester.pump();

      expect(find.byType(DsFieldError), findsOneWidget);
      expect(find.text('That is not an email address.'), findsOneWidget);
    });

    testWidgets('the password reveal unmasks the field it is beside', (
      WidgetTester tester,
    ) async {
      final DsThemeController controller = DsThemeController();
      addTearDown(controller.dispose);
      await tester.pumpPreview(
        'sign-in-flow',
        size: _desktop,
        controller: controller,
      );

      DsInput password() => tester.widget<DsInput>(
        find.byKey(const ValueKey<String>('sign-in-password')),
      );

      expect(password().obscureText, isTrue);
      await tester.tap(find.byKey(const ValueKey<String>('sign-in-reveal')));
      await tester.pump();
      expect(password().obscureText, isFalse);
    });
  });

  group('the host itself', () {
    testWidgets('mounts no site chrome — it is a background and one Shot', (
      WidgetTester tester,
    ) async {
      final DsThemeController controller = DsThemeController();
      addTearDown(controller.dispose);
      await tester.pumpPreview(
        'sign-in-flow',
        size: _desktop,
        controller: controller,
      );

      // The site shell's own furniture, none of which a preview may inherit.
      expect(find.byType(AppBar), findsNothing);
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byType(BottomNavigationBar), findsNothing);
      expect(find.text('Search'), findsNothing);
    });

    // Catches: deleting the `DefaultTextStyle` from `ShotPreviewHost.build`.
    //
    // `/shots/<slug>/preview` is a top-level surface with no `Material` above
    // it, so without that wrapper every string in the mounted composition
    // inherits `WidgetsApp`'s error style: the flagship settings Shot rendered
    // "Profile", both field labels and both placeholders in error red under a
    // double yellow underline, and the dashboard rendered all four headline
    // metrics the same way. The whole suite passed through it because no test
    // resolved a style out of the tree — this one does, against a `.type-*`
    // class that declares no colour and therefore inherits the ancestor's.
    testWidgets('a preview does not inherit the SDK fallback text style', (
      WidgetTester tester,
    ) async {
      final DsThemeController controller = DsThemeController();
      addTearDown(controller.dispose);
      tester.useViewport(_desktop);
      await tester.pumpWidget(
        DsTheme(
          controller: controller,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ShotPreviewHost(
              name: 'probe',
              shot: DsText('Inherited probe paragraph', DsType.body),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final TextStyle probe = tester
          .firstRenderObject<RenderParagraph>(
            find.descendant(
              of: find.text('Inherited probe paragraph'),
              matching: find.byType(RichText),
            ),
          )
          .text
          .style!;
      // `WidgetsApp`'s `_errorTextStyle`, restated because it is private to
      // the framework.
      expect(probe.color, isNot(const Color(0xD0FF0000)));
      expect(probe.color, DsThemeData.dark.foreground);
      expect(probe.decoration ?? TextDecoration.none, TextDecoration.none);
      expect(probe.decorationColor, isNot(const Color(0xFFFFFF00)));
      expect(probe.decorationStyle, isNot(TextDecorationStyle.double));
    });

    testWidgets('every catalog slug resolves, and nothing else does', (
      WidgetTester tester,
    ) async {
      for (final ShotDocEntry entry in shotDocs) {
        expect(shotPreviewFor(entry.name), isNotNull, reason: entry.name);
        expect(
          shotPreviewHostForRoute(entry.previewRoute),
          isA<ShotPreviewHost>(),
          reason: entry.previewRoute,
        );
        expect(shotPreviewHostForRoute(entry.route), isNull);
      }
      expect(shotPreviewFor('not-a-shot'), isNull);
      expect(shotPreviewHostForRoute('/shots'), isNull);
    });

    testWidgets('an unknown slug says so rather than rendering nothing', (
      WidgetTester tester,
    ) async {
      final DsThemeController controller = DsThemeController();
      addTearDown(controller.dispose);
      await tester.pumpPreview(
        'not-a-shot',
        size: _desktop,
        controller: controller,
      );

      expect(find.byKey(ShotPreviewHost.viewportKey), findsNothing);
      expect(
        find.text('No Shot is registered under "not-a-shot".'),
        findsOneWidget,
      );
    });
  });
}
