import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/progress/meta.dart';
import 'package:example/components_docs/progress/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// The `progress` documentation page: renders the eighteen-section template
/// for BOTH `DsProgress` and `DsSkeleton` on one page (one entry, one route —
/// see `meta.dart`'s own note on why two components share this slot).
///
/// Both components carry a real animation — `DsProgress`'s fill tweens on
/// every value change, `DsSkeleton`'s shimmer loops forever — so this file
/// never calls `tester.pumpAndSettle()`: a looping `AnimationController.repeat()`
/// under `DsSkeleton` means settle would poll forever. Every wait below is a
/// bounded `tester.pump()`/`tester.pump(Duration(...))` instead, exactly as
/// the task brief requires.
Widget _harness({
  required Widget child,
  required Size size,
  required DsThemeController controller,
  bool disableAnimations = false,
}) => MediaQuery(
  data: MediaQueryData(size: size, disableAnimations: disableAnimations),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: DsTheme(
      controller: controller,
      child: MaterialApp(home: SingleChildScrollView(child: child)),
    ),
  ),
);

void main() {
  group('progress & skeleton docs page', () {
    testWidgets(
      'renders the article, both API tables, and live specimens of both '
      'components at several values',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            size: const Size(1440, 900),
            controller: DsThemeController(mode: DsThemeMode.dark),
            child: ProgressDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // One bounded pump for the first frame's layout — never
        // pumpAndSettle, which would poll forever against DsSkeleton's
        // repeating shimmer controller.
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

        // The API table lists every DsProgress constructor parameter found
        // in lib/src/components/progress.dart.
        for (final String param in <String>['value', 'tone', 'label']) {
          expect(
            find.text(param),
            findsWidgets,
            reason: 'missing DsProgress API row: $param',
          );
        }
        // ...and every DsSkeleton constructor parameter found in
        // lib/src/components/skeleton.dart.
        for (final String param in <String>['width', 'height', 'radius']) {
          expect(
            find.text(param),
            findsWidgets,
            reason: 'missing DsSkeleton API row: $param',
          );
        }

        // Every DsProgressTone rung is documented.
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
            reason: 'missing DsProgressTone row: $tone',
          );
        }

        // Live DsProgress specimens mount at several distinct values.
        final List<DsProgress> progresses = tester
            .widgetList<DsProgress>(find.byType(DsProgress))
            .toList();
        expect(progresses.length, greaterThanOrEqualTo(6));
        expect(
          progresses.map((DsProgress p) => p.value).toSet().length,
          greaterThanOrEqualTo(6),
          reason: 'progress specimens should cover several distinct values',
        );
        // All five tones appear on at least one specimen.
        expect(
          progresses.map((DsProgress p) => p.tone).toSet(),
          containsAll(DsProgressTone.values),
        );

        // Live DsSkeleton specimens mount in several shapes.
        expect(find.byType(DsSkeleton), findsAtLeastNWidgets(4));

        expect(progressDoc.name, 'progress');
        expect(
          progressDoc.exports,
          containsAll(<String>['DsProgress', 'DsProgressTone', 'DsSkeleton']),
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
            controller: DsThemeController(mode: DsThemeMode.dark),
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

        final double before = tester.widget<DsProgress>(specimen).value;

        final Finder advanceButton = find.byKey(
          const ValueKey<String>('progress-doc-simulate-button'),
        );
        expect(advanceButton, findsOneWidget);
        await tester.ensureVisible(advanceButton);
        await tester.pump();
        await tester.tap(advanceButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        final double after = tester.widget<DsProgress>(specimen).value;
        expect(after, greaterThan(before));

        // The Previous/Next pager (DocsLayout) navigates through the same
        // route callback as every other docs page.
        final Finder separatorLink = find.text('Separator').first;
        await tester.ensureVisible(separatorLink);
        await tester.pump();
        await tester.tap(separatorLink);
        expect(destination, '/components/separator');
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
            controller: DsThemeController(mode: DsThemeMode.dark),
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
      'renders at narrow width in light mode too — the 390×844/1440×900 × '
      'light/dark matrix the brief requires',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            size: const Size(390, 844),
            controller: DsThemeController(mode: DsThemeMode.light),
            child: const ProgressDocPage(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          find.byKey(const ValueKey<String>('progress-doc-article')),
          findsOneWidget,
        );
        expect(find.byType(DsProgress), findsWidgets);
        expect(find.byType(DsSkeleton), findsWidgets);
      },
    );

    testWidgets('the live theme controller flips both specimens in place', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.dark,
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

      // Flip the SAME controller in place — not a fresh widget tree.
      controller.setMode(DsThemeMode.light);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.byKey(const ValueKey<String>('progress-doc-article')),
        findsOneWidget,
      );
      expect(find.byType(DsProgress), findsWidgets);
      expect(find.byType(DsSkeleton), findsWidgets);
    });

    testWidgets(
      'reduced motion lands the progress fill on its final translation in '
      'one pump, and freezes the skeleton shimmer to a single still frame',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            size: const Size(1440, 900),
            controller: DsThemeController(mode: DsThemeMode.dark),
            disableAnimations: true,
            child: const ProgressDocPage(),
          ),
        );
        // Under MediaQueryData.disableAnimations, dsAnimationDuration
        // collapses every tween AND every DsKeyframePlayer repeat to
        // Duration.zero (theme_scope.dart), so a couple of bounded pumps are
        // enough to reach the settled frame — never pumpAndSettle.
        await tester.pump();
        await tester.pump();

        // ── DsProgress: the fill lands on its target translation in a
        // single pump after a value change, no tween to wait out. ──
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
        // A SINGLE pump — no arbitrary settle duration — is enough because
        // the transition's own duration is now Duration.zero.
        await tester.pump();

        final double after = tester
            .widget<FractionalTranslation>(fill)
            .translation
            .dx;
        final DsProgress progress = tester.widget<DsProgress>(specimen);
        expect(after, closeTo(progress.translation, 1e-9));
        expect(
          after,
          isNot(closeTo(before, 1e-9)),
          reason: 'the tap should have changed the value',
        );

        // ── DsSkeleton: the shimmer paints a single still frame under
        // reduced motion. DsKeyframePlayer(repeat: true) wraps its own
        // painted output in a RepaintBoundary (keyframes.dart), which this
        // rasterises directly — the same technique
        // test/feedback_effects_test.dart's rasterise()/readRaster() use at
        // package level, applied here to this page's own avatar specimen so
        // the docs test does not merely take the package test's word for
        // it. Two captures 470ms apart (a third of the shimmer's 1.4s
        // cycle) must be pixel-identical; a running shimmer would not be.
        final Finder skeletonBoundary = find.descendant(
          of: find.byKey(const ValueKey<String>('skeleton-preview:avatar')),
          matching: find.byType(RepaintBoundary),
        );
        expect(skeletonBoundary, findsOneWidget);

        final Uint8List frameA = await _captureBytes(tester, skeletonBoundary);
        // Bounded, not pumpAndSettle: DsKeyframePlayer stops its controller
        // outright under reduced motion, so this must not hang.
        await tester.pump(const Duration(milliseconds: 470));
        final Uint8List frameB = await _captureBytes(tester, skeletonBoundary);

        expect(
          frameA,
          orderedEquals(frameB),
          reason:
              'the skeleton shimmer kept moving under '
              'MediaQuery.disableAnimations: true — reduced motion did not '
              'settle it',
        );
      },
    );
  });
}

/// Rasterises the [RepaintBoundary] at [finder] to raw RGBA bytes.
///
/// Mirrors `test/feedback_effects_test.dart`'s own `readRaster` helper —
/// `toImage`/`toByteData` both need `tester.runAsync` because they touch the
/// raster thread, not merely the widget tree `pump()` already advanced.
Future<Uint8List> _captureBytes(WidgetTester tester, Finder finder) async {
  final RenderRepaintBoundary boundary = tester.renderObject(finder);
  final ui.Image image = (await tester.runAsync(
    () => boundary.toImage(pixelRatio: 1),
  ))!;
  final ByteData bytes = (await tester.runAsync(
    () async => (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!,
  ))!;
  final Uint8List out = bytes.buffer.asUint8List();
  image.dispose();
  return out;
}
