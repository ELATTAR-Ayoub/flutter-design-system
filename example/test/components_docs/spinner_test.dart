/// Tests for the spinner component documentation page.
///
/// Re-housed onto the kit alongside the page: the section-order test now
/// reads `DocsSection.id` (the kit's own section widget), and the
/// API-table / accessibility / keyboard / dependencies assertions each open
/// the relevant `DocsDisclosure` first — closed by default in the new kit,
/// unlike the old page's always-visible `Section`.
///
/// **No `pumpAndSettle` anywhere in this file.** `Spinner`'s
/// `AnimationController.repeat()` never settles, so `pumpAndSettle()` would
/// hang forever; every wait below is a bounded `tester.pump()` /
/// `tester.pump(Duration(...))`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/spinner/meta.dart';
import 'package:example/components_docs/spinner/page.dart';
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

/// This page's own section order: see
/// `example/lib/components_docs/spinner/page.dart`'s own library doc. Only
/// Customization is skipped from the reference's own section list:
/// [Spinner] exposes no `icon`/`glyph` constructor parameter, so there is
/// nothing to swap. Button, Badge, Input Group, Empty and RTL are all real
/// compositions with [Button], [Badge], [InputGroup], [Empty] and a
/// [Directionality] wrapper. API Reference is first among the disclosures,
/// ahead of the corpus's fixed closing seven.
const List<String> _spinnerSectionOrder = <String>[
  'preview',
  'install',
  'usage',
  'size',
  'button',
  'badge',
  'input-group',
  'empty',
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

Widget _harness({required Widget child, required ThemeController controller}) =>
    ThemeScope(
      controller: controller,
      child: MaterialApp(home: SingleChildScrollView(child: child)),
    );

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s
/// own trigger key ([DocsDisclosure.triggerKey]) is one constant shared by
/// every instance on the page, so a bare `find.byKey` would match every
/// disclosure on the page -- this narrows to the one panel by its title
/// first, matching `button_test.dart`'s own convention.
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
  group('spinner docs page', () {
    testWidgets('renders the article, never settling on the spinner', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      String? destination;
      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: SpinnerDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      // One bounded pump only: Spinner's AnimationController.repeat()
      // never settles, so pumpAndSettle() would hang forever.
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('spinner-doc-article')),
        findsOneWidget,
      );

      // At least one spinner mounts per composed example (preview, size x2,
      // button x2, badge x2, input group, empty, rtl).
      expect(find.byType(Spinner), findsWidgets);
      final int spinnerCount = tester
          .widgetList<Spinner>(find.byType(Spinner))
          .length;
      expect(spinnerCount, greaterThanOrEqualTo(9));

      // Metadata reads correctly.
      expect(spinnerDoc.name, 'spinner');
      expect(spinnerDoc.dependencies, <String>['icon', 'source-foundation']);
      expect(spinnerDoc.exports, <String>['Spinner']);
      expect(spinnerDoc.command, 'elattar add spinner');

      expect(destination, isNull);

      // Every section renders, in exactly the order the page declares.
      final List<String> ids = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.id)
          .toList();
      expect(ids, _spinnerSectionOrder);

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();
      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Size',
        'Button',
        'Badge',
        'Input Group',
        'Empty',
        'RTL',
        'API Reference',
        'States',
        'Accessibility',
        'Keyboard',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);

      // No "Customization" heading: the honestly-skipped section.
      expect(find.text('Customization'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const SpinnerDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('spinner-doc-article')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
      },
    );

    testWidgets('the API Reference disclosure documents every public member', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const SpinnerDocPage(),
        ),
      );
      await tester.pump();
      await _open(tester, 'API Reference');

      final Finder apiSection = find.byWidgetPredicate(
        (Widget widget) => widget is DocsSection && widget.id == 'api',
      );
      expect(apiSection, findsOneWidget);
      for (final String member in <String>[
        'size',
        'strokeOverride',
        'Spinner.px',
      ]) {
        expect(
          find.descendant(of: apiSection, matching: find.text(member)),
          findsOneWidget,
          reason: 'API member "$member" should be documented',
        );
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'the Keyboard disclosure states the spinner is never in the tab order',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const SpinnerDocPage(),
          ),
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
            matching: find.textContaining('never in the tab order'),
          ),
          findsWidgets,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the Dependencies disclosure links its two documented consumers',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const SpinnerDocPage(),
          ),
        );
        await tester.pump();
        await _open(tester, 'Dependencies');

        final Finder dependenciesSection = find.byWidgetPredicate(
          (Widget widget) =>
              widget is DocsSection && widget.id == 'dependencies',
        );
        expect(
          find.descendant(
            of: dependenciesSection,
            matching: find.text('Button'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: dependenciesSection,
            matching: find.text('Badge'),
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'spinner rotates under normal motion, holds under reduced motion',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ThemeController controller = ThemeController(
          mode: ColorMode.dark,
        );

        // Normal motion: rotation progresses across two bounded pumps.
        await tester.pumpWidget(
          _harness(controller: controller, child: const SpinnerDocPage()),
        );
        await tester.pump();

        final Finder rotationFinder = find.byType(RotationTransition);
        expect(rotationFinder, findsWidgets);

        final RotationTransition rotation1 = tester.widget<RotationTransition>(
          rotationFinder.first,
        );
        final double value1 = rotation1.turns.value;

        await tester.pump(const Duration(milliseconds: 100));

        final RotationTransition rotation2 = tester.widget<RotationTransition>(
          rotationFinder.first,
        );
        final double value2 = rotation2.turns.value;

        expect(
          value2,
          greaterThan(value1),
          reason: 'spinner did not rotate under normal motion',
        );
      },
    );

    testWidgets('spinner holds still under reduced motion', (
      WidgetTester tester,
    ) async {
      // `MediaQuery(disableAnimations: true)` sits BELOW `MaterialApp`, the
      // same discipline `collapsible_test.dart` and `buttons_page_test.dart`
      // use, so it reaches every descendant `Spinner` through the real
      // `effectiveMotionDuration` reduced-motion path.
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ThemeScope(
          controller: ThemeController(mode: ColorMode.dark),
          child: MaterialApp(
            home: Builder(
              builder: (BuildContext context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                child: const SingleChildScrollView(child: SpinnerDocPage()),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final Finder rotationFinder = find.byType(RotationTransition);
      expect(rotationFinder, findsWidgets);

      final RotationTransition rotation1 = tester.widget<RotationTransition>(
        rotationFinder.first,
      );
      final double value1 = rotation1.turns.value;

      await tester.pump(const Duration(milliseconds: 500));

      final RotationTransition rotation2 = tester.widget<RotationTransition>(
        rotationFinder.first,
      );
      final double value2 = rotation2.turns.value;

      expect(
        value2,
        value1,
        reason: 'spinner rotated even though disableAnimations was set',
      );
    });
  });
}
