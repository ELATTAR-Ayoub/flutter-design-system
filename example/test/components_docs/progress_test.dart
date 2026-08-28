/// Tests for the `progress` documentation page.
///
/// Re-housed onto the kit alongside the page: the section-order test now
/// reads `DocsSection.id` (the kit's own section widget), and the
/// API-table / accessibility / keyboard / dependencies assertions each open
/// the relevant `DocsDisclosure` first — closed by default in the new kit,
/// unlike the old page's always-visible `Section`. `Skeleton` was split
/// off into its own route (`example/lib/components_docs/skeleton/`) long
/// before this pass; see `progress/meta.dart`'s library note for that split.
///
/// `Progress`'s fill carries a real, finite tween, so this file still
/// never calls `tester.pumpAndSettle()` against it out of caution: every
/// wait below is a bounded `tester.pump()`/`tester.pump(Duration(...))`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/progress/meta.dart';
import 'package:example/components_docs/progress/page.dart';
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

const List<String> _expectedSectionOrder = <String>[
  'preview',
  'install',
  'usage',
  'label-value',
  'controlled',
  'rtl',
  'download-list',
  'api',
  'states',
  'accessibility',
  'keyboard',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

Widget _harness({
  required Widget child,
  required Size size,
  required ThemeController controller,
  bool disableAnimations = false,
}) => MediaQuery(
  data: MediaQueryData(size: size, disableAnimations: disableAnimations),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ThemeScope(
      controller: controller,
      child: MaterialApp(home: SingleChildScrollView(child: child)),
    ),
  ),
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
  group('progress docs page', () {
    test('progressDoc exposes accurate registry metadata', () {
      expect(progressDoc.name, 'progress');
      expect(progressDoc.title, 'Progress');
      expect(progressDoc.sourcePath, 'lib/src/components/progress.dart');
      expect(
        progressDoc.exports,
        containsAll(<String>['Progress', 'ProgressTone']),
      );
      expect(progressDoc.dependencies, <String>[
        'surface',
        'source-foundation',
      ]);
      expect(progressDoc.command, 'elattar add progress');
    });

    testWidgets('sections render in the house order, with no leftover Skeleton '
        'section from the pre-split page', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          size: const Size(1440, 900),
          controller: ThemeController(mode: ColorMode.dark),
          child: const ProgressDocPage(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final List<String> ids = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.id)
          .toList();
      expect(ids, _expectedSectionOrder);

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();
      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Label and value',
        'Controlled',
        'RTL',
        'Download list',
        'API Reference',
        'States',
        'Accessibility',
        'Keyboard',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);
    });

    testWidgets('renders the article, live specimens at several values, and no '
        'leftover Skeleton widget', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      String? destination;
      await tester.pumpWidget(
        _harness(
          size: const Size(1440, 900),
          controller: ThemeController(mode: ColorMode.dark),
          child: ProgressDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.byKey(const ValueKey<String>('progress-doc-article')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );

      // Live Progress specimens mount at several distinct values.
      final List<Progress> progresses = tester
          .widgetList<Progress>(find.byType(Progress))
          .toList();
      expect(progresses.length, greaterThanOrEqualTo(6));
      expect(
        progresses.map((Progress p) => p.value).toSet().length,
        greaterThanOrEqualTo(6),
        reason: 'progress specimens should cover several distinct values',
      );
      // All five tones appear on at least one specimen.
      expect(
        progresses.map((Progress p) => p.tone).toSet(),
        containsAll(ProgressTone.values),
      );

      // No leftover Skeleton widget from the pre-split page.
      expect(find.byType(Skeleton), findsNothing);

      expect(destination, isNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the API Reference disclosure documents every public member', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          size: const Size(1440, 900),
          controller: ThemeController(mode: ColorMode.dark),
          child: const ProgressDocPage(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await _open(tester, 'API Reference');

      final Finder apiSection = find.byWidgetPredicate(
        (Widget widget) => widget is DocsSection && widget.id == 'api',
      );
      expect(apiSection, findsOneWidget);

      for (final String param in <String>['value', 'tone', 'label']) {
        expect(
          find.descendant(of: apiSection, matching: find.text(param)),
          findsWidgets,
          reason: 'missing Progress API row: $param',
        );
      }
      for (final String tone in <String>[
        'normal',
        // 'value' names both the ProgressTone.value row and the
        // Progress.value property row above: a real collision between
        // the two tables in this same disclosure, not a test bug, so
        // it is asserted present rather than asserted unique.
        'value',
        'success',
        'warning',
        'destructive',
      ]) {
        expect(
          find.descendant(of: apiSection, matching: find.text(tone)),
          findsWidgets,
          reason: 'missing ProgressTone row: $tone',
        );
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'the Keyboard disclosure states progress is never in the tab order',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            size: const Size(1440, 900),
            controller: ThemeController(mode: ColorMode.dark),
            child: const ProgressDocPage(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
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
      'the Dependencies disclosure links its two documented neighbours',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            size: const Size(1440, 900),
            controller: ThemeController(mode: ColorMode.dark),
            child: const ProgressDocPage(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await _open(tester, 'Dependencies');

        final Finder dependenciesSection = find.byWidgetPredicate(
          (Widget widget) =>
              widget is DocsSection && widget.id == 'dependencies',
        );
        expect(
          find.descendant(
            of: dependenciesSection,
            matching: find.text('Spinner'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: dependenciesSection,
            matching: find.text('Skeleton'),
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the interactive progress specimen actually advances on tap, and the '
      'pager navigates through DocsLayout.onNavigate',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            size: const Size(1440, 900),
            controller: ThemeController(mode: ColorMode.dark),
            child: ProgressDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        final Finder specimen = find.byKey(
          const ValueKey<String>('progress-doc-live-specimen'),
        );
        expect(specimen, findsOneWidget);
        await tester.ensureVisible(specimen);
        await tester.pump();

        final double before = tester.widget<Progress>(specimen).value;

        final Finder advanceButton = find.byKey(
          const ValueKey<String>('progress-doc-simulate-button'),
        );
        expect(advanceButton, findsOneWidget);
        await tester.ensureVisible(advanceButton);
        await tester.pump();
        await tester.tap(advanceButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        final double after = tester.widget<Progress>(specimen).value;
        expect(after, greaterThan(before));

        // The Previous/Next pager (DocsLayout) navigates through the same
        // route callback as every other docs page. Progress's own next
        // link points at the Skeleton route.
        final Finder skeletonLink = find.text('Skeleton').first;
        await tester.ensureVisible(skeletonLink);
        await tester.pump();
        await tester.tap(skeletonLink);
        expect(destination, '/components/skeleton');
      },
    );

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            size: const Size(390, 844),
            controller: ThemeController(mode: ColorMode.dark),
            child: const ProgressDocPage(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          find.byKey(const ValueKey<String>('progress-doc-article')),
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

    testWidgets(
      'renders at narrow width in light mode too: the 390×844/1440×900 × '
      'light/dark matrix the brief requires',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            size: const Size(390, 844),
            controller: ThemeController(mode: ColorMode.light),
            child: const ProgressDocPage(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          find.byKey(const ValueKey<String>('progress-doc-article')),
          findsOneWidget,
        );
        expect(find.byType(Progress), findsWidgets);
      },
    );

    testWidgets('the live theme controller flips the specimens in place', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(
          size: const Size(1440, 900),
          controller: controller,
          child: const ProgressDocPage(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.byKey(const ValueKey<String>('progress-doc-article')),
        findsOneWidget,
      );

      // Flip the SAME controller in place: not a fresh widget tree.
      controller.setMode(ColorMode.light);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.byKey(const ValueKey<String>('progress-doc-article')),
        findsOneWidget,
      );
      expect(find.byType(Progress), findsWidgets);
    });

    testWidgets(
      'reduced motion lands the progress fill on its final translation in '
      'one pump',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            size: const Size(1440, 900),
            controller: ThemeController(mode: ColorMode.dark),
            disableAnimations: true,
            child: const ProgressDocPage(),
          ),
        );
        // Under MediaQueryData.disableAnimations, effectiveMotionDuration
        // collapses the tween to Duration.zero (theme_scope.dart), so a
        // couple of bounded pumps are enough to reach the settled frame.
        await tester.pump();
        await tester.pump();

        final Finder specimen = find.byKey(
          const ValueKey<String>('progress-doc-live-specimen'),
        );
        final Finder fill = find.descendant(
          of: specimen,
          matching: find.byType(FractionalTranslation),
        );
        expect(fill, findsOneWidget);

        final double before = tester
            .widget<FractionalTranslation>(fill)
            .translation
            .dx;

        final Finder advanceButton = find.byKey(
          const ValueKey<String>('progress-doc-simulate-button'),
        );
        await tester.ensureVisible(advanceButton);
        await tester.pump();
        await tester.tap(advanceButton);
        // A SINGLE pump: no arbitrary settle duration, is enough because
        // the transition's own duration is now Duration.zero.
        await tester.pump();

        final double after = tester
            .widget<FractionalTranslation>(fill)
            .translation
            .dx;
        final Progress progress = tester.widget<Progress>(specimen);
        expect(after, closeTo(progress.translation, 1e-9));
        expect(
          after,
          isNot(closeTo(before, 1e-9)),
          reason: 'the tap should have changed the value',
        );
      },
    );
  });
}
