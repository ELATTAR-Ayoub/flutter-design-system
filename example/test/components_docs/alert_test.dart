/// Tests for the alert component documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never a synthetic `MediaQuery`. Theme
/// coverage flips a single live [ElThemeController] in place rather than
/// rebuilding with a second controller instance.
///
/// **No `pumpAndSettle` anywhere in this file.** Every specimen on the page
/// carries a live `ElBloomCosmic`, whose drift and starfield are forever
/// loops (see `test/effects_test.dart`'s own note) -- `pumpAndSettle` would
/// hang waiting for an animation that never finishes. `tester.pump()` is
/// enough to render one frame and assert against it.
///
/// The page was reshaped to mirror
/// https://ui.shadcn.com/docs/components/base/alert section for section:
/// Preview, Installation, Usage, Composition, then the reference's own
/// Basic / Destructive / Action / RTL examples (Custom Colors has no
/// counterpart -- ElAlert has no style-override hook, only variant), then
/// our Success / Warning / Info / Stacked alerts additions, then API
/// Reference, then States / Accessibility / Responsive / Dependencies /
/// Theming / Source. The ordering test below asserts that literal sequence.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/alert/meta.dart';
import 'package:example/components_docs/alert/page.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The full section list, in the order the reshaped page must render them.
const List<String> _sectionOrder = <String>[
  'install',
  'usage',
  'composition',
  'basic',
  'destructive',
  'action',
  'success',
  'warning',
  'info',
  'stacked-alerts',
  'rtl',
  'api',
  'states',
  'a11y',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

Widget _harness(Widget child, {required ElThemeController controller}) =>
    ElTheme(
      controller: controller,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SingleChildScrollView(child: child),
      ),
    );

void main() {
  test('alertDoc exposes accurate registry metadata', () {
    expect(alertDoc.name, 'alert');
    expect(alertDoc.title, 'Alert');
    expect(alertDoc.sourcePath, 'lib/src/components/alert.dart');
    expect(
      alertDoc.exports,
      containsAll(<String>['ElAlert', 'ElAlertVariant']),
    );
    expect(alertDoc.dependencies, <String>[
      'bloom-cosmic',
      'source-foundation',
    ]);
  });

  testWidgets('alert docs page renders every shadcn-parity section, in order', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ElThemeController controller = ElThemeController(
      mode: ElThemeMode.dark,
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

    // Every section anchor exists, and each one sits below the section
    // before it -- the "in order" half of the shadcn-parity contract.
    double previousTop = -1;
    for (final String anchor in _sectionOrder) {
      final Finder section = find.byKey(ElSection.anchorKey(anchor));
      expect(section, findsOneWidget, reason: 'section "$anchor" missing');
      final double top = tester.getTopLeft(section).dy;
      expect(
        top,
        greaterThan(previousTop),
        reason: 'section "$anchor" should render after the previous section',
      );
      previousTop = top;
    }

    // No prose link fires the router: onNavigate stays untouched.
    expect(destination, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'alert docs page mounts live specimens across the example sections',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.dark,
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(const AlertDocPage(), controller: controller),
      );
      await tester.pump();

      // The Preview grid alone already mounts one ElAlert per variant; the
      // per-variant sections below each mount at least one more, and RTL
      // mounts two.
      expect(find.text('Alert'), findsWidgets);
      expect(find.byType(ElAlert), findsAtLeastNWidgets(10));

      // Basic carries ElAlertVariant.normal's own specimen.
      final Finder basicSection = find.byKey(ElSection.anchorKey('basic'));
      expect(
        find.descendant(of: basicSection, matching: find.text('Heads up')),
        findsWidgets,
      );

      // Destructive has no action slot; Action reuses the same variant with
      // one, so the two sections must read differently. (Every
      // DocsCodeExample carries its own "Copy" ElButton regardless, so the
      // signal is the "Retry" action label, not ElButton presence.)
      final Finder destructiveSection = find.byKey(
        ElSection.anchorKey('destructive'),
      );
      expect(
        find.descendant(of: destructiveSection, matching: find.text('Retry')),
        findsNothing,
      );
      final Finder actionSection = find.byKey(ElSection.anchorKey('action'));
      expect(
        find.descendant(of: actionSection, matching: find.text('Retry')),
        findsWidgets,
      );

      // Success, Warning, and Info each carry their own live specimen.
      for (final (String anchor, String title) in <(String, String)>[
        ('success', 'Changes saved'),
        ('warning', 'Withdrawal under review'),
        ('info', 'New feature available'),
      ]) {
        final Finder section = find.byKey(ElSection.anchorKey(anchor));
        expect(
          find.descendant(of: section, matching: find.text(title)),
          findsWidgets,
          reason: '"$anchor" section should carry its own live specimen',
        );
      }

      // RTL mounts two alerts inside a right-to-left Directionality.
      final Finder rtlSection = find.byKey(ElSection.anchorKey('rtl'));
      expect(
        find.descendant(of: rtlSection, matching: find.byType(ElAlert)),
        findsNWidgets(2),
      );
      expect(
        find.descendant(
          of: rtlSection,
          matching: find.byWidgetPredicate(
            (Widget widget) =>
                widget is Directionality &&
                widget.textDirection == TextDirection.rtl,
          ),
        ),
        findsOneWidget,
      );

      // Composition documents the anatomy as Dart, not a live render.
      final Finder compositionSection = find.byKey(
        ElSection.anchorKey('composition'),
      );
      expect(
        find.descendant(
          of: compositionSection,
          matching: find.textContaining('AlertAction'),
        ),
        findsWidgets,
      );

      // The API table lists every public constructor parameter found on
      // ElAlert, and every ElAlertVariant value, in the same section.
      final Finder apiSection = find.byKey(ElSection.anchorKey('api'));
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
      for (final String variant in <String>[
        'normal',
        'destructive',
        'success',
        'warning',
        'info',
      ]) {
        expect(
          find.descendant(of: apiSection, matching: find.text(variant)),
          findsOneWidget,
          reason: 'ElAlertVariant.$variant should be documented',
        );
      }
      // Custom Colors has no ElAlert equivalent -- recorded as skipped
      // rather than faked with another variant swatch.
      expect(
        find.descendant(
          of: apiSection,
          matching: find.textContaining('SKIPPED'),
        ),
        findsWidgets,
      );

      // The install section names the command that installs it. It asserted
      // the opposite until the registry covered the whole component surface.
      final Finder installSection = find.byKey(ElSection.anchorKey('install'));
      expect(
        find.descendant(
          of: installSection,
          matching: find.textContaining('elattar add alert'),
        ),
        findsWidgets,
      );

      // The decision-guidance prose names its neighbours instead of restating
      // the component's own name (IA 9.2's decision-guidance contract). It
      // used to live in a `purpose` section; the shadcn frame puts nothing
      // above `Installation` but the live demo, so the prose now sits
      // unheaded in the article and is asserted against the article itself.
      expect(
        find.descendant(
          of: find.byKey(const ValueKey<String>('alert-doc-article')),
          matching: find.textContaining('alert dialog'),
        ),
        findsWidgets,
      );

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'alert docs page adapts across breakpoints and themes without exceptions',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.light,
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
      expect(find.byType(ElAlert), findsAtLeastNWidgets(10));
      expect(tester.takeException(), isNull);

      // The controller is flipped in place: no new app, no new element tree.
      controller.setMode(ElThemeMode.dark);
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('alert docs page shows the wide-viewport sidebar layout', (
    WidgetTester tester,
  ) async {
    // A fresh mount at the wide breakpoint, rather than resizing the
    // narrow tree above in place: docs_layout.dart's full-bleed
    // OverflowBox needs a full layout pass at its final constraints, and
    // resizing a live SingleChildScrollView tree mid-test can catch it on
    // a transient unbounded-height frame on a page this size.
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ElThemeController controller = ElThemeController(
      mode: ElThemeMode.dark,
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _harness(const AlertDocPage(), controller: controller),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey<String>('docs-layout-sidebar')),
      findsOneWidget,
    );
    expect(find.byType(ElAlert), findsAtLeastNWidgets(10));
    expect(tester.takeException(), isNull);
  });
}
