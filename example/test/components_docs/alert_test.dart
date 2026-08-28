/// Tests for the alert component documentation page.
///
/// Re-housed onto the kit alongside the page: the section-order test now
/// reads `DocsSection.id` (the kit's own section widget), and the
/// API-table / state-matrix / accessibility / keyboard / dependencies
/// assertions each open the relevant `DocsDisclosure` first — closed by
/// default in the new kit, unlike the old page's always-visible `Section`.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never a synthetic `MediaQuery`. Theme
/// coverage flips a single live [ThemeController] in place rather than
/// rebuilding with a second controller instance.
///
/// **No `pumpAndSettle` anywhere in this file.** Every specimen on the page
/// carries a live `FeedbackSurface`, whose drift and starfield are forever
/// loops (see `test/effects_test.dart`'s own note) -- `pumpAndSettle` would
/// hang waiting for an animation that never finishes. `tester.pump()` is
/// enough to render one frame and assert against it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/alert/meta.dart';
import 'package:example/components_docs/alert/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
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

/// The full section list, in the order the re-housed page must render them.
const List<String> _sectionOrder = <String>[
  'preview',
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
  'accessibility',
  'keyboard',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

Widget _harness(Widget child, {required ThemeController controller}) =>
    ThemeScope(
      controller: controller,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SingleChildScrollView(child: child),
      ),
    );

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s
/// own trigger key ([DocsDisclosure.triggerKey]) is one constant shared by
/// every instance on the page, so a bare `find.byKey` would match all
/// eight -- this narrows to the one panel by its title first, matching
/// `button_test.dart`'s own convention.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

Future<void> _open(WidgetTester tester, String title) async {
  final Finder trigger = _disclosureTrigger(title);
  await tester.ensureVisible(trigger);
  await tester.pump();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(MotionDurations.open);
}

void main() {
  test('alertDoc exposes accurate registry metadata', () {
    expect(alertDoc.name, 'alert');
    expect(alertDoc.title, 'Alert');
    expect(alertDoc.sourcePath, 'lib/src/components/alert.dart');
    expect(alertDoc.exports, containsAll(<String>['Alert', 'AlertVariant']));
    expect(alertDoc.dependencies, <String>[
      'feedback-surface',
      'source-foundation',
    ]);
    expect(alertDoc.command, 'elattar add alert');
  });

  testWidgets('alert docs page renders every section, in order', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ThemeController controller = ThemeController(mode: ColorMode.dark);
    addTearDown(controller.dispose);
    String? destination;

    await tester.pumpWidget(
      _harness(
        AlertDocPage(onNavigate: (String route) => destination = route),
        controller: controller,
      ),
    );
    await tester.pump();

    final List<String> ids = tester
        .widgetList<DocsSection>(find.byType(DocsSection))
        .map((DocsSection section) => section.id)
        .toList();
    expect(ids, _sectionOrder);

    // No prose link fires the router: onNavigate stays untouched.
    expect(destination, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'alert docs page mounts live specimens across every variant section',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(const AlertDocPage(), controller: controller),
      );
      await tester.pump();

      // The Preview grid alone already mounts one Alert per variant; the
      // per-variant sections below each mount at least one more, and RTL
      // and Stacked alerts each mount two.
      expect(find.byType(Alert), findsAtLeastNWidgets(12));

      // Basic carries AlertVariant.normal's own specimen.
      final Finder basic = find.byKey(
        const ValueKey<String>('alert-example:basic'),
      );
      expect(
        find.descendant(of: basic, matching: find.text('Heads up')),
        findsOneWidget,
      );

      // Destructive has no action slot; Action reuses the same variant
      // with one, so the two specimens must read differently.
      final Finder destructive = find.byKey(
        const ValueKey<String>('alert-example:destructive'),
      );
      expect(
        find.descendant(of: destructive, matching: find.text('Retry')),
        findsNothing,
      );
      final Finder action = find.byKey(
        const ValueKey<String>('alert-example:action'),
      );
      expect(
        find.descendant(of: action, matching: find.text('Retry')),
        findsOneWidget,
      );

      // Success, Warning, and Info each carry their own live specimen.
      for (final (String key, String title) in <(String, String)>[
        ('alert-example:success', 'Changes saved'),
        ('alert-example:warning', 'Withdrawal under review'),
        ('alert-example:info', 'New feature available'),
      ]) {
        final Finder specimen = find.byKey(ValueKey<String>(key));
        expect(specimen, findsOneWidget);
        expect(
          find.descendant(of: specimen, matching: find.text(title)),
          findsOneWidget,
          reason: '"$key" should carry its own live specimen',
        );
      }

      // Stacked alerts is now live, not code-only: two alerts in one column.
      final Finder stacked = find.byKey(
        const ValueKey<String>('alert-example:stacked'),
      );
      expect(
        find.descendant(of: stacked, matching: find.byType(Alert)),
        findsNWidgets(2),
      );

      // RTL mounts two alerts inside a right-to-left Directionality.
      final Finder rtl = find.byKey(
        const ValueKey<String>('alert-example:rtl'),
      );
      expect(
        find.descendant(of: rtl, matching: find.byType(Alert)),
        findsNWidgets(2),
      );
      // `rtl`'s own key sits on the Directionality wrapper itself.
      expect(
        tester.widget<Directionality>(rtl).textDirection,
        TextDirection.rtl,
      );

      // Composition documents the anatomy as Dart, not a live render.
      final Finder compositionSection = find.byWidgetPredicate(
        (Widget widget) => widget is DocsSection && widget.id == 'composition',
      );
      expect(
        find.descendant(
          of: compositionSection,
          matching: find.textContaining('AlertAction'),
        ),
        findsWidgets,
      );

      // The install section names the command that installs it, visible
      // without opening anything (InstallSection defaults to its CLI tab).
      final Finder installSection = find.byWidgetPredicate(
        (Widget widget) => widget is DocsSection && widget.id == 'install',
      );
      expect(
        find.descendant(
          of: installSection,
          matching: find.textContaining('elattar add alert'),
        ),
        findsWidgets,
      );

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('the API Reference disclosure documents every public member', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ThemeController controller = ThemeController(mode: ColorMode.dark);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _harness(const AlertDocPage(), controller: controller),
    );
    await tester.pump();
    await _open(tester, 'API Reference');

    final Finder apiSection = find.byWidgetPredicate(
      (Widget widget) => widget is DocsSection && widget.id == 'api',
    );
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
        reason: 'AlertVariant.$variant should be documented',
      );
    }
    // Custom Colors has no Alert equivalent -- recorded as skipped rather
    // than faked with another variant swatch.
    expect(
      find.descendant(of: apiSection, matching: find.textContaining('SKIPPED')),
      findsWidgets,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'the Dependencies disclosure links its two documented neighbours',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _harness(const AlertDocPage(), controller: controller),
      );
      await tester.pump();
      await _open(tester, 'Dependencies');

      final Finder dependenciesSection = find.byWidgetPredicate(
        (Widget widget) => widget is DocsSection && widget.id == 'dependencies',
      );
      expect(
        find.descendant(
          of: dependenciesSection,
          matching: find.textContaining('alert dialog'),
        ),
        findsWidgets,
      );
      expect(
        find.descendant(
          of: dependenciesSection,
          matching: find.text('Alert Dialog'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: dependenciesSection,
          matching: find.text('Toaster'),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('the Keyboard disclosure states the alert body has none', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ThemeController controller = ThemeController(mode: ColorMode.dark);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _harness(const AlertDocPage(), controller: controller),
    );
    await tester.pump();
    await _open(tester, 'Keyboard');

    final Finder keyboardSection = find.byWidgetPredicate(
      (Widget widget) => widget is DocsSection && widget.id == 'keyboard',
    );
    expect(keyboardSection, findsOneWidget);
    expect(
      find.descendant(
        of: keyboardSection,
        matching: find.textContaining('No key handling'),
      ),
      findsWidgets,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'alert docs page adapts across breakpoints and themes without exceptions',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.light);
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
      expect(find.byType(Alert), findsAtLeastNWidgets(12));
      expect(tester.takeException(), isNull);

      // The controller is flipped in place: no new app, no new element tree.
      controller.setMode(ColorMode.dark);
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

    final ThemeController controller = ThemeController(mode: ColorMode.dark);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _harness(const AlertDocPage(), controller: controller),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey<String>('docs-layout-sidebar')),
      findsOneWidget,
    );
    expect(find.byType(Alert), findsAtLeastNWidgets(12));
    expect(tester.takeException(), isNull);
  });
}
