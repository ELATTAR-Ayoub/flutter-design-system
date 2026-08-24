import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/carousel/meta.dart';
import 'package:example/components_docs/carousel/page.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Trimmed on 2026-08-24: `ElNavUser` and `ElMarker` moved to
/// `nav_user_test.dart` and `marker_test.dart` along with their pages, so
/// nothing about either is asserted here any more.
///
/// The page's own section order, live demo excluded (it has no heading).
const List<String> _sectionOrder = <String>[
  'install',
  'usage',
  'motion',
  'composition',
  'sizes',
  'rtl',
  'not-ported',
  'api',
  'states',
  'accessibility',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

/// The same list by title, for the order assertion. `find.text` would match
/// each of these twice at desktop width (heading plus right-rail TOC entry),
/// so the order is read off the mounted `ElSection` widgets instead.
const List<String> _sectionTitles = <String>[
  'Installation',
  'Usage',
  'How the motion works',
  'Composition',
  'Sizes',
  'RTL',
  'What this port leaves out',
  'API Reference',
  'States',
  'Accessibility',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

/// Every named constructor parameter `ElCarousel` declares
/// (`lib/src/components/carousel.dart`), excluding `key`: the same set the
/// page's `ElCarousel` API table claims to cover.
const List<String> _carouselConstructorParams = <String>[
  'basis',
  'items',
  'padding',
  'previousLabel',
  'nextLabel',
];

Widget _harness({
  required Widget child,
  required ElThemeController controller,
}) => ElTheme(
  controller: controller,
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  ),
);

void main() {
  group('meta', () {
    test('carouselDoc names ElCarousel only, after the split', () {
      expect(carouselDoc.name, 'carousel');
      expect(carouselDoc.title, 'Carousel');
      expect(carouselDoc.route, '/components/carousel');
      expect(carouselDoc.sourcePath, 'lib/src/components/carousel.dart');
      expect(carouselDoc.exports, <String>[
        'ElCarousel',
        'ElCarouselController',
      ]);
      // The two families that moved out are gone from this entry.
      expect(carouselDoc.exports, isNot(contains('ElNavUser')));
      expect(carouselDoc.exports, isNot(contains('ElMarker')));
    });
  });

  group('carousel docs page', () {
    testWidgets(
      'renders the article, both API tables, and the live specimens at '
      'desktop size',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: CarouselDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // A single frame, never pumpAndSettle: the engine is an integrator
        // with no end time, so a settle on a moving carousel would never
        // return.
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('carousel-doc-article')),
          findsOneWidget,
        );

        for (final String param in _carouselConstructorParams) {
          expect(
            find.text(param),
            findsWidgets,
            reason: 'missing ElCarousel param $param',
          );
        }

        // The ElCarouselController table names its own constructor
        // parameter and its public members, which the pre-split table did
        // not.
        for (final String member in <String>[
          'ElCarouselController({vsync})',
          'instant',
          'location',
          'selectedIndex',
          'canScrollPrev',
          'canScrollNext',
          'snaps',
          'setMetrics({viewSize, slideSizes})',
          'scrollTo(int index)',
          'scrollPrev()',
          'scrollNext()',
          'dragStart(double pointerX)',
          'dragUpdate(double pointerX)',
          'dragEnd()',
          'dispose()',
        ]) {
          expect(
            find.text(member),
            findsWidgets,
            reason: 'missing ElCarouselController member $member',
          );
        }

        // Every live specimen this page's own source keys is mounted.
        for (final String key in <String>[
          'carousel-preview',
          'carousel-example:in-panel',
          'carousel-example:basis-half',
          'carousel-example:basis-third',
          'carousel-example:rtl',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing specimen $key',
          );
        }

        // Both basis values the Sizes section claims to show are real.
        final Set<double> mountedBases = tester
            .widgetList<ElCarousel>(find.byType(ElCarousel))
            .map((ElCarousel carousel) => carousel.basis)
            .toSet();
        expect(mountedBases, containsAll(<double>[0.5, 0.333]));

        expect(destination, isNull);
      },
    );

    testWidgets(
      'sections render in the documented order, section for section',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const CarouselDocPage(),
          ),
        );
        await tester.pump();

        final List<String> titles = tester
            .widgetList<ElSection>(find.byType(ElSection))
            .map((ElSection section) => section.title)
            .toList();
        expect(titles, _sectionTitles);

        double? previousTop;
        for (final String id in _sectionOrder) {
          final Finder finder = find.byKey(ElSection.anchorKey(id));
          expect(finder, findsOneWidget, reason: 'missing section "$id"');
          final double top = tester.getTopLeft(finder).dy;
          if (previousTop != null) {
            expect(
              top,
              greaterThan(previousTop),
              reason: '"$id" is out of order',
            );
          }
          previousTop = top;
        }
      },
    );

    testWidgets(
      'the six skipped reference sections and the missing-controller root '
      'cause are both still on the page',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const CarouselDocPage(),
          ),
        );
        await tester.pump();

        for (final String skipped in <String>[
          'Spacing',
          'Orientation',
          'Options',
          'API state-tracking',
          'Events',
          'Plugins',
        ]) {
          expect(
            find.text(skipped),
            findsWidgets,
            reason: 'skipped section "$skipped" is no longer disclosed',
          );
        }

        // The honest skip's own causal framing, verbatim: ElCarousel really
        // does declare no `controller` parameter, so the page must not
        // start implying that the exported controller is attachable.
        expect(
          find.text(
            'ElCarousel builds this controller internally: the '
            'constructor above has no controller parameter. Nothing '
            'outside ElCarousel can read selectedIndex, canScrollPrev, '
            'or canScrollNext, or add its own listener, today.',
          ),
          findsOneWidget,
          reason: 'the ElCarouselController caveat panel text changed',
        );
      },
    );

    testWidgets('carousel arrows are real focusable buttons with labels', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ElThemeController(mode: ElThemeMode.dark),
          child: const CarouselDocPage(),
        ),
      );
      await tester.pump();

      final List<ElButton> buttons = tester
          .widgetList<ElButton>(find.byType(ElButton))
          .toList();
      expect(buttons.length, greaterThanOrEqualTo(2));

      final Set<String?> labels = buttons
          .map((ElButton button) => button.label)
          .toSet();
      expect(labels, contains('Previous slide'));
      expect(labels, contains('Next slide'));

      // The previous arrow starts disabled: canScrollPrev is false at index
      // 0, which the page's own States and Accessibility sections claim.
      final Iterable<ElButton> previous = buttons.where(
        (ElButton button) => button.label == 'Previous slide',
      );
      expect(previous, isNotEmpty);
      expect(
        previous.every((ElButton button) => button.onPressed == null),
        isTrue,
      );
    });

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const CarouselDocPage(),
          ),
        );
        await tester.pump();

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
      'survives a live theme flip in place without losing a specimen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const CarouselDocPage()),
        );
        await tester.pump();

        final ElThemeData darkTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('carousel-doc-article')),
          ),
        );

        // Flip the SAME controller in place. A single pump(), never
        // pumpAndSettle().
        controller.setMode(ElThemeMode.light);
        await tester.pump();

        final ElThemeData lightTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('carousel-doc-article')),
          ),
        );
        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in <String>[
          'carousel-preview',
          'carousel-example:in-panel',
          'carousel-example:basis-half',
          'carousel-example:basis-third',
          'carousel-example:rtl',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
      },
    );
  });
}
