import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/progress/meta.dart';
import 'package:example/components_docs/progress/page.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The `progress` documentation page: renders the shadcn-mirrored section
/// template for [ElProgress] only. `ElSkeleton` was split off into its own
/// route (`example/lib/components_docs/skeleton/`) and its own test
/// (`skeleton_test.dart`); see `progress/meta.dart`'s library note for the
/// split.
///
/// `ElProgress`'s fill carries a real, finite tween, so this file still
/// never calls `tester.pumpAndSettle()` against it out of caution: every
/// wait below is a bounded `tester.pump()`/`tester.pump(Duration(...))`.
Widget _harness({
  required Widget child,
  required Size size,
  required ElThemeController controller,
  bool disableAnimations = false,
}) => MediaQuery(
  data: MediaQueryData(size: size, disableAnimations: disableAnimations),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ElTheme(
      controller: controller,
      child: MaterialApp(home: SingleChildScrollView(child: child)),
    ),
  ),
);

void main() {
  group('progress docs page', () {
    testWidgets(
      'sections render in the shadcn-mirrored order, section for section, '
      'with no leftover Skeleton section from the merged page',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            size: const Size(1440, 900),
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const ProgressDocPage(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        final List<String> titles = tester
            .widgetList<ElSection>(find.byType(ElSection))
            .map((ElSection section) => section.title)
            .toList();

        expect(titles, <String>[
          'Installation',
          'Usage',
          'Label and value',
          'Controlled',
          'RTL',
          'Download list',
          'API Reference',
          'States',
          'Accessibility and keyboard behavior',
          'Responsive',
          'Dependencies, files, and install facts',
          'Theming',
          'Source',
        ]);
      },
    );

    testWidgets(
      'renders the article, the API table, and live specimens at several '
      'values',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            size: const Size(1440, 900),
            controller: ElThemeController(mode: ElThemeMode.dark),
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

        // The API table lists every ElProgress constructor parameter found
        // in lib/src/components/progress.dart.
        for (final String param in <String>['value', 'tone', 'label']) {
          expect(
            find.text(param),
            findsWidgets,
            reason: 'missing ElProgress API row: $param',
          );
        }

        // Every ElProgressTone rung is documented.
        for (final String tone in <String>[
          'normal',
          'value',
          'success',
          'warning',
          'destructive',
        ]) {
          expect(
            find.text(tone),
            findsWidgets,
            reason: 'missing ElProgressTone row: $tone',
          );
        }

        // Live ElProgress specimens mount at several distinct values.
        final List<ElProgress> progresses = tester
            .widgetList<ElProgress>(find.byType(ElProgress))
            .toList();
        expect(progresses.length, greaterThanOrEqualTo(6));
        expect(
          progresses.map((ElProgress p) => p.value).toSet().length,
          greaterThanOrEqualTo(6),
          reason: 'progress specimens should cover several distinct values',
        );
        // All five tones appear on at least one specimen.
        expect(
          progresses.map((ElProgress p) => p.tone).toSet(),
          containsAll(ElProgressTone.values),
        );

        // No leftover ElSkeleton widget from the pre-split page.
        expect(find.byType(ElSkeleton), findsNothing);

        expect(progressDoc.name, 'progress');
        expect(
          progressDoc.exports,
          containsAll(<String>['ElProgress', 'ElProgressTone']),
        );
        expect(destination, isNull);
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
            controller: ElThemeController(mode: ElThemeMode.dark),
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

        final double before = tester.widget<ElProgress>(specimen).value;

        final Finder advanceButton = find.byKey(
          const ValueKey<String>('progress-doc-simulate-button'),
        );
        expect(advanceButton, findsOneWidget);
        await tester.ensureVisible(advanceButton);
        await tester.pump();
        await tester.tap(advanceButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        final double after = tester.widget<ElProgress>(specimen).value;
        expect(after, greaterThan(before));

        // The Previous/Next pager (DocsLayout) navigates through the same
        // route callback as every other docs page. Progress's own next
        // link now points at the new Skeleton route.
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
            controller: ElThemeController(mode: ElThemeMode.dark),
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
            controller: ElThemeController(mode: ElThemeMode.light),
            child: const ProgressDocPage(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          find.byKey(const ValueKey<String>('progress-doc-article')),
          findsOneWidget,
        );
        expect(find.byType(ElProgress), findsWidgets);
      },
    );

    testWidgets('the live theme controller flips the specimens in place', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.dark,
      );
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
      controller.setMode(ElThemeMode.light);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.byKey(const ValueKey<String>('progress-doc-article')),
        findsOneWidget,
      );
      expect(find.byType(ElProgress), findsWidgets);
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
            controller: ElThemeController(mode: ElThemeMode.dark),
            disableAnimations: true,
            child: const ProgressDocPage(),
          ),
        );
        // Under MediaQueryData.disableAnimations, elAnimationDuration
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
        final ElProgress progress = tester.widget<ElProgress>(specimen);
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
