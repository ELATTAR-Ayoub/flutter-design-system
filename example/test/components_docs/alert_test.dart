/// Tests for the alert component documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never a synthetic `MediaQuery`. Theme
/// coverage flips a single live [DsThemeController] in place rather than
/// rebuilding with a second controller instance.
///
/// **No `pumpAndSettle` anywhere in this file.** Every specimen on the page
/// carries a live `DsBloomCosmic`, whose drift and starfield are forever
/// loops (see `test/effects_test.dart`'s own note) -- `pumpAndSettle` would
/// hang waiting for an animation that never finishes. `tester.pump()` is
/// enough to render one frame and assert against it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/alert/meta.dart';
import 'package:example/components_docs/alert/page.dart';
import 'package:example/kit.dart' show DsSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child, {required DsThemeController controller}) =>
    DsTheme(
      controller: controller,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SingleChildScrollView(child: child),
      ),
    );

void main() {
  test('alertDoc exposes accurate, non-registry metadata', () {
    expect(alertDoc.name, 'alert');
    expect(alertDoc.title, 'Alert');
    expect(alertDoc.sourcePath, 'lib/src/components/alert.dart');
    expect(
      alertDoc.exports,
      containsAll(<String>['DsAlert', 'DsAlertVariant']),
    );
    // No registry manifest exists for alert yet — see registry/components/.
    // A worker must not invent registry dependency names for it.
    expect(alertDoc.dependencies, isEmpty);
  });

  testWidgets(
    'alert docs page renders the article and documents every constructor parameter',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.dark,
      );
      addTearDown(controller.dispose);
      String? destination;

      await tester.pumpWidget(
        _harness(
          AlertDocPage(onNavigate: (String route) => destination = route),
          controller: controller,
        ),
      );
      await tester.pump();

      // The page renders and mounts a live specimen of the real widget — one
      // per DsAlertVariant value.
      expect(find.text('Alert'), findsWidgets);
      expect(find.byType(DsAlert), findsAtLeastNWidgets(5));
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );

      // The API table lists every public constructor parameter found on
      // DsAlert in lib/src/components/alert.dart.
      final Finder apiSection = find.byKey(DsSection.anchorKey('api'));
      expect(apiSection, findsOneWidget);
      for (final String parameter in <String>[
        'title',
        'description',
        'icon',
        'action',
        'variant',
      ]) {
        expect(
          find.descendant(of: apiSection, matching: find.text(parameter)),
          findsOneWidget,
          reason: 'constructor parameter "$parameter" should be documented',
        );
      }

      // Every DsAlertVariant value is documented.
      final Finder variantsSection = find.byKey(
        DsSection.anchorKey('variants'),
      );
      expect(variantsSection, findsOneWidget);
      for (final String variant in <String>[
        'normal',
        'destructive',
        'success',
        'warning',
        'info',
      ]) {
        expect(
          find.descendant(of: variantsSection, matching: find.text(variant)),
          findsOneWidget,
          reason: 'DsAlertVariant.$variant should be documented',
        );
      }

      // The install section states honestly that alert has no CLI item yet.
      final Finder installSection = find.byKey(DsSection.anchorKey('install'));
      expect(installSection, findsOneWidget);
      expect(
        find.descendant(
          of: installSection,
          matching: find.textContaining('not yet'),
        ),
        findsWidgets,
      );

      // The purpose section names its neighbours instead of restating the
      // component's own name (IA 9.2's decision-guidance contract).
      final Finder purposeSection = find.byKey(DsSection.anchorKey('purpose'));
      expect(purposeSection, findsOneWidget);
      expect(
        find.descendant(
          of: purposeSection,
          matching: find.textContaining('alert dialog'),
        ),
        findsWidgets,
      );

      // No prose link fires the router — onNavigate stays untouched.
      expect(destination, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'alert docs page adapts across breakpoints and themes without exceptions',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.light,
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(const AlertDocPage(), controller: controller),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsNothing,
      );
      expect(find.byType(DsAlert), findsAtLeastNWidgets(5));
      expect(tester.takeException(), isNull);

      // The controller is flipped in place: no new app, no new element tree.
      controller.setMode(DsThemeMode.dark);
      await tester.pump();
      expect(tester.takeException(), isNull);

      tester.view.physicalSize = const Size(1440, 900);
      await tester.pump();
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(find.byType(DsAlert), findsAtLeastNWidgets(5));
      expect(tester.takeException(), isNull);
    },
  );
}
