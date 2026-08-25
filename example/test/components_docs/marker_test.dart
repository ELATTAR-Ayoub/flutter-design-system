/// Tests for `components_docs/marker/page.dart`'s [MarkerDocPage].
///
/// Re-housed onto the kit alongside the page: the section-order test now
/// reads `DocsSection.id`/`.title`, and the API-table reads open the
/// `DocsDisclosure` first — closed by default, unlike the old page's
/// always-visible `ElSection`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/marker/meta.dart';
import 'package:example/components_docs/marker/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The page's own section order.
const List<String> _sectionIds = <String>[
  'preview',
  'install',
  'usage',
  'not-a-mark',
  'variants',
  'in-a-list',
  'icon',
  'rules',
  'api',
  'states',
  'accessibility',
  'keyboard',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

/// The same list by title.
const List<String> _sectionTitles = <String>[
  'Preview',
  'Installation',
  'Usage',
  'What the name gets wrong',
  'Choosing a variant',
  'Marking a row in a list',
  'Adding an icon',
  'How the separator splits the row',
  'API Reference',
  'States',
  'Accessibility',
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

/// Every named constructor parameter `ElMarker` declares
/// (`lib/src/components/marker.dart`), excluding `key`.
const List<String> _markerParams = <String>['label', 'variant', 'icon'];

/// Every static measurement `ElMarker` exposes, as the API table names them.
const List<String> _markerStatics = <String>[
  'ElMarker.gap',
  'ElMarker.minHeight',
  'ElMarker.ruleGap',
  'ElMarker.borderPadding',
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

/// The single `DocsDisclosure` whose title is [title].
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

void main() {
  group('meta', () {
    test('markerDoc names the real public API surface', () {
      expect(markerDoc.name, 'marker');
      expect(markerDoc.title, 'Marker');
      expect(markerDoc.route, '/components/marker');
      expect(markerDoc.sourcePath, 'lib/src/components/marker.dart');
      expect(markerDoc.exports, <String>['ElMarker', 'ElMarkerVariant']);
      expect(markerDoc.command, 'elattar add marker');
      // Nothing from the two families this page was split away from.
      expect(markerDoc.exports, isNot(contains('ElCarousel')));
      expect(markerDoc.exports, isNot(contains('ElNavUser')));
    });

    test('the static measurements the API table quotes are the real ones', () {
      expect(ElMarker.gap, el(2));
      expect(ElMarker.minHeight, el(4));
      expect(ElMarker.ruleGap, el(1));
      expect(ElMarker.borderPadding, el(2));
    });
  });

  group('marker docs page', () {
    testWidgets(
      'renders the article, all three API tables, and the live specimens '
      'at desktop size',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: MarkerDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('marker-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        for (final String param in _markerParams) {
          expect(
            find.text(param),
            findsWidgets,
            reason: 'missing param $param',
          );
        }

        // The four statics the pre-split table omitted entirely.
        for (final String member in _markerStatics) {
          expect(
            find.text(member),
            findsWidgets,
            reason: 'missing static $member',
          );
        }

        // Every ElMarkerVariant value is named in the ElMarkerVariant table.
        for (final ElMarkerVariant variant in ElMarkerVariant.values) {
          expect(
            find.text(variant.name),
            findsWidgets,
            reason: 'ElMarkerVariant.${variant.name} missing from API table',
          );
        }

        for (final String key in <String>[
          'marker-preview',
          'marker-example:variants',
          'marker-example:in-a-list',
          'marker-example:icon',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing specimen $key',
          );
        }

        expect(destination, isNull);
      },
    );

    testWidgets('a live specimen of every ElMarkerVariant value mounts', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ElThemeController(mode: ElThemeMode.dark),
          child: const MarkerDocPage(),
        ),
      );
      await tester.pump();

      final List<ElMarker> markers = tester
          .widgetList<ElMarker>(find.byType(ElMarker))
          .toList();
      expect(markers.length, greaterThanOrEqualTo(3));

      final Set<ElMarkerVariant> variants = markers
          .map((ElMarker marker) => marker.variant)
          .toSet();
      expect(variants, containsAll(ElMarkerVariant.values));

      // The Adding an icon section really passes an icon, rather than only
      // describing one.
      final Iterable<ElMarker> withIcon = tester
          .widgetList<ElMarker>(
            find.descendant(
              of: find.byKey(const ValueKey<String>('marker-example:icon')),
              matching: find.byType(ElMarker),
            ),
          )
          .toList();
      expect(withIcon, isNotEmpty);
      expect(
        withIcon.every((ElMarker marker) => marker.icon != null),
        isTrue,
        reason: 'the icon specimen carries no icon',
      );
    });

    test('the table of contents matches the declared sections', () {
      expect(
        markerDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        _sectionTitles,
      );
    });

    testWidgets(
      'sections render in the documented order, section for section',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const MarkerDocPage(),
          ),
        );
        await tester.pump();

        final List<DocsSection> sections = tester
            .widgetList<DocsSection>(find.byType(DocsSection))
            .toList();
        final List<String> ids = sections
            .map((DocsSection section) => section.id)
            .toList();
        final List<String> titles = sections
            .map((DocsSection section) => section.title)
            .toList();

        expect(ids, _sectionIds);
        expect(titles, _sectionTitles);

        // Eight collapsed sections: API Reference, States, Accessibility,
        // Keyboard, Responsive, Dependencies, Theming, Source.
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
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
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const MarkerDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('marker-doc-article')),
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
          _harness(controller: controller, child: const MarkerDocPage()),
        );
        await tester.pump();

        final ElThemeData darkTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('marker-doc-article')),
          ),
        );

        // Flip the SAME controller in place. A single pump(), never
        // pumpAndSettle().
        controller.setMode(ElThemeMode.light);
        await tester.pump();

        final ElThemeData lightTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('marker-doc-article')),
          ),
        );
        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in <String>[
          'marker-preview',
          'marker-example:variants',
          'marker-example:in-a-list',
          'marker-example:icon',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }

        final Set<ElMarkerVariant> variants = tester
            .widgetList<ElMarker>(find.byType(ElMarker))
            .map((ElMarker marker) => marker.variant)
            .toSet();
        expect(variants, containsAll(ElMarkerVariant.values));
      },
    );
  });
}
