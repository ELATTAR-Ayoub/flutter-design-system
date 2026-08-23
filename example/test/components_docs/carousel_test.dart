import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/carousel/meta.dart';
import 'package:example/components_docs/carousel/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required DsThemeController controller,
}) => DsTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

void main() {
  group('carousel docs page', () {
    testWidgets(
      'renders the article, API tables, and live specimens at desktop size',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: DsThemeController(mode: DsThemeMode.dark),
            child: CarouselDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('carousel-doc-article')),
          findsOneWidget,
        );

        // Verify carousel API table parameters.
        for (final String param in <String>[
          'basis',
          'items',
          'padding',
          'previousLabel',
          'nextLabel',
        ]) {
          expect(
            find.text(param),
            findsWidgets,
            reason: 'missing carousel param $param',
          );
        }

        // Verify nav_user API table.
        for (final String param in <String>['user', 'items', 'name', 'email']) {
          expect(
            find.text(param),
            findsWidgets,
            reason: 'missing nav_user param $param',
          );
        }

        // Verify marker API table.
        for (final String param in <String>['label', 'variant', 'icon']) {
          expect(
            find.text(param),
            findsWidgets,
            reason: 'missing marker param $param',
          );
        }

        // Live carousel specimen mounts.
        expect(
          find.byType(DsCarousel),
          findsWidgets,
          reason: 'carousel specimen not mounted',
        );

        // Live nav_user specimen mounts.
        expect(
          find.byType(DsNavUser),
          findsWidgets,
          reason: 'nav_user specimen not mounted',
        );

        // Live marker specimens mount (normal, separator, border variants).
        expect(
          find.byType(DsMarker),
          findsWidgets,
          reason: 'marker specimens not mounted',
        );

        // Verify metadata.
        expect(carouselDoc.name, 'carousel');
        expect(
          carouselDoc.exports,
          containsAll(<String>[
            'DsCarousel',
            'DsCarouselController',
            'DsNavUser',
            'DsNavUserAccount',
            'DsNavUserItem',
            'DsMarker',
            'DsMarkerVariant',
          ]),
        );
        expect(destination, isNull);
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
            controller: DsThemeController(mode: DsThemeMode.dark),
            child: const CarouselDocPage(),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('carousel-doc-article')),
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
      'carousel, nav_user, and marker render correctly in light and dark themes',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final DsThemeController controller = DsThemeController(
          mode: DsThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const CarouselDocPage()),
        );

        // Verify all live components render in dark theme.
        expect(find.byType(DsCarousel), findsWidgets);
        expect(find.byType(DsNavUser), findsWidgets);
        expect(find.byType(DsMarker), findsWidgets);

        // Flip the SAME controller in place.
        controller.setMode(DsThemeMode.light);
        await tester.pump();

        // Verify components still render in light theme.
        expect(find.byType(DsCarousel), findsWidgets);
        expect(find.byType(DsNavUser), findsWidgets);
        expect(find.byType(DsMarker), findsWidgets);
      },
    );

    testWidgets('carousel navigation buttons are real focusable buttons', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: DsThemeController(mode: DsThemeMode.dark),
          child: const CarouselDocPage(),
        ),
      );

      // Find carousel buttons in the preview.
      final List<DsButton> buttons = tester
          .widgetList<DsButton>(find.byType(DsButton))
          .toList();

      // Carousel preview should have at least previous and next buttons.
      expect(buttons.length, greaterThanOrEqualTo(2));

      // Verify buttons have semantic labels for accessibility.
      bool hasPreviousLabel = false;
      bool hasNextLabel = false;

      for (final DsButton button in buttons) {
        if (button.label == 'Previous slide') {
          hasPreviousLabel = true;
        }
        if (button.label == 'Next slide') {
          hasNextLabel = true;
        }
      }

      expect(hasPreviousLabel, true, reason: 'Previous button missing label');
      expect(hasNextLabel, true, reason: 'Next button missing label');
    });

    testWidgets('marker variants render as distinct types', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: DsThemeController(mode: DsThemeMode.dark),
          child: const CarouselDocPage(),
        ),
      );

      // Verify all three marker variants are rendered.
      final List<DsMarker> markers = tester
          .widgetList<DsMarker>(find.byType(DsMarker))
          .toList();

      expect(markers.length, greaterThanOrEqualTo(3));

      final Set<DsMarkerVariant> variants = markers
          .map((DsMarker m) => m.variant)
          .toSet();

      expect(
        variants,
        containsAll(<DsMarkerVariant>[
          DsMarkerVariant.normal,
          DsMarkerVariant.separator,
          DsMarkerVariant.border,
        ]),
      );
    });

    testWidgets('nav_user account row renders with name and email', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: DsThemeController(mode: DsThemeMode.dark),
          child: const CarouselDocPage(),
        ),
      );

      // Verify the account row text appears.
      expect(find.text('Alex Johnson'), findsWidgets);
      expect(find.text('alex@example.com'), findsWidgets);

      // Verify nav_user is rendered.
      expect(find.byType(DsNavUser), findsWidgets);
    });
  });
}
