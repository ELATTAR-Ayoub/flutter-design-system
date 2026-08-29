import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/skeleton/meta.dart';
import 'package:example/components_docs/skeleton/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
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
import 'package:flutter/rendering.dart' hide ScrollDirection;
import 'package:flutter_test/flutter_test.dart';

/// The `skeleton` documentation page: re-housed onto the kit alongside the
/// page. The section-order test now reads `DocsSection.id`/`.title`, and
/// the API-table read opens the `DocsDisclosure` first — closed by default,
/// unlike the old page's always-visible `Section`.
///
/// `Skeleton`'s shimmer loops forever, so this file never calls
/// `tester.pumpAndSettle()`: a looping `AnimationController.repeat()` under
/// `Skeleton` means settle would poll forever. Every wait below is a
/// bounded `tester.pump()`/`tester.pump(Duration(...))` instead.
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

/// The single `DocsDisclosure` whose title is [title].
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

const List<String> _sectionIds = <String>[
  'preview',
  'install',
  'usage',
  'avatar',
  'card',
  'text',
  'form',
  'table',
  'rtl',
  'layout-shift',
  'api',
  'states',
  'accessibility',
  'keyboard',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

const List<String> _sectionTitles = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Avatar',
  'Card',
  'Text',
  'Form',
  'Table',
  'RTL',
  'Avoiding layout shift',
  'API Reference',
  'States',
  'Accessibility',
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

void main() {
  group('skeleton docs page', () {
    testWidgets(
      'sections render in the shadcn-mirrored order, section for section',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            size: const Size(1440, 900),
            controller: ThemeController(mode: ColorMode.dark),
            child: const SkeletonDocPage(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        final List<String> titles = tester
            .widgetList<DocsSection>(find.byType(DocsSection))
            .map((DocsSection section) => section.title)
            .toList();

        expect(titles, _sectionTitles);
      },
    );

    testWidgets(
      'renders the article, the API table, and live specimens in several '
      'shapes',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            size: const Size(1440, 900),
            controller: ThemeController(mode: ColorMode.dark),
            child: SkeletonDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          find.byKey(const ValueKey<String>('skeleton-doc-article')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsOneWidget,
        );

        // The API table lives inside the API Reference disclosure, closed
        // by default, so open it before reading any of its rows.
        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // The API table lists every Skeleton constructor parameter found
        // in lib/src/components/ui/skeleton.dart.
        for (final String param in <String>['width', 'height', 'radius']) {
          expect(
            find.text(param),
            findsWidgets,
            reason: 'missing Skeleton API row: $param',
          );
        }

        expect(find.byType(Skeleton), findsAtLeastNWidgets(4));

        expect(skeletonDoc.name, 'skeleton');
        expect(skeletonDoc.exports, containsAll(<String>['Skeleton']));
        expect(skeletonDoc.command, 'elattar add skeleton');
        expect(destination, isNull);
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        skeletonDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        _sectionTitles,
      );
    });

    testWidgets('the page is declared, and every section is a kit component', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          size: const Size(1440, 4000),
          controller: ThemeController(mode: ColorMode.dark),
          child: const SkeletonDocPage(),
        ),
      );
      await tester.pump();

      final List<String> sectionIds = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.id)
          .toList();
      expect(sectionIds, _sectionIds);

      // Eight collapsed sections: API Reference, States, Accessibility,
      // Keyboard, Responsive, Dependencies, Theming, Source.
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    testWidgets(
      'the pager navigates through DocsLayout.onNavigate, back to Progress '
      'and forward to Separator',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            size: const Size(1440, 900),
            controller: ThemeController(mode: ColorMode.dark),
            child: SkeletonDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        final Finder separatorLink = find.text('Separator').first;
        await tester.ensureVisible(separatorLink);
        await tester.pump();
        await tester.tap(separatorLink);
        expect(destination, '/components/separator');
      },
    );

    testWidgets(
      'the layout-shift specimen swaps skeleton for real content without '
      'resizing, on tap',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            size: const Size(1440, 900),
            controller: ThemeController(mode: ColorMode.dark),
            child: const SkeletonDocPage(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        final Finder toggle = find.byKey(
          const ValueKey<String>('skeleton-doc-toggle-loaded'),
        );
        expect(toggle, findsOneWidget);
        await tester.ensureVisible(toggle);
        await tester.pump();

        // The name renders through TextStyles.section, unmodified, as
        // "Amara Chen" once the loaded state swaps the skeleton row for
        // the real content.
        expect(find.text('Amara Chen'), findsNothing);
        await tester.tap(toggle);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.text('Amara Chen'), findsOneWidget);
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
            child: const SkeletonDocPage(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          find.byKey(const ValueKey<String>('skeleton-doc-article')),
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
        // The Table specimen's own narrow-viewport mitigation: each row is
        // wrapped in a horizontal SingleChildScrollView, never an unwrapped
        // fixed-width Row that would overflow the 298px a docs panel leaves
        // at 390px.
        expect(tester.takeException(), isNull);
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
            child: const SkeletonDocPage(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          find.byKey(const ValueKey<String>('skeleton-doc-article')),
          findsOneWidget,
        );
        expect(find.byType(Skeleton), findsWidgets);
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
          child: const SkeletonDocPage(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.byKey(const ValueKey<String>('skeleton-doc-article')),
        findsOneWidget,
      );

      // Flip the SAME controller in place: not a fresh widget tree.
      controller.setMode(ColorMode.light);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.byKey(const ValueKey<String>('skeleton-doc-article')),
        findsOneWidget,
      );
      expect(find.byType(Skeleton), findsWidgets);
    });

    testWidgets(
      'reduced motion freezes the skeleton shimmer to a single still frame',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            size: const Size(1440, 900),
            controller: ThemeController(mode: ColorMode.dark),
            disableAnimations: true,
            child: const SkeletonDocPage(),
          ),
        );
        // Under MediaQueryData.disableAnimations, effectiveMotionDuration
        // collapses every KeyframePlayer repeat to Duration.zero
        // (theme_scope.dart), so a couple of bounded pumps are enough to
        // reach the settled frame: never pumpAndSettle.
        await tester.pump();
        await tester.pump();

        // KeyframePlayer(repeat: true) wraps its own painted output in a
        // RepaintBoundary (keyframes.dart), which this rasterises directly:
        // the same technique test/feedback_effects_test.dart's
        // rasterise()/readRaster() use at package level, applied here to
        // this page's own avatar specimen so the docs test does not merely
        // take the package test's word for it. Two captures 470ms apart (a
        // third of the shimmer's 1.4s cycle) must be pixel-identical; a
        // running shimmer would not be.
        final Finder skeletonBoundary = find.descendant(
          of: find.byKey(const ValueKey<String>('skeleton-preview:avatar')),
          matching: find.byType(RepaintBoundary),
        );
        expect(skeletonBoundary, findsOneWidget);

        final Uint8List frameA = await _captureBytes(tester, skeletonBoundary);
        // Bounded, not pumpAndSettle: KeyframePlayer stops its controller
        // outright under reduced motion, so this must not hang.
        await tester.pump(const Duration(milliseconds: 470));
        final Uint8List frameB = await _captureBytes(tester, skeletonBoundary);

        expect(
          frameA,
          orderedEquals(frameB),
          reason:
              'the skeleton shimmer kept moving under '
              'MediaQuery.disableAnimations: true, reduced motion did not '
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
