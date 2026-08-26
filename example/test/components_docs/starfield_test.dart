/// Tests for the starfield effect documentation page.
///
/// **No `pumpAndSettle` anywhere in this file.** Both of ElStarfield's sway
/// `AnimationController`s call `repeat(reverse: true)` forever, so
/// `pumpAndSettle()` would hang rather than fail; every wait below is a
/// bounded `tester.pump()` / `tester.pump(Duration(...))`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/starfield/meta.dart';
import 'package:example/components_docs/starfield/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required ElThemeController controller,
}) => ElTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// `ElStarfield`'s own constructor parameters, and every field of the two
/// data records it is built from (`lib/src/effects/starfield.dart`).
const List<String> _starfieldConstructorParams = <String>['bloom2', 'hovered'];
const List<String> _clusterFields = <String>[
  'tile',
  'corner',
  'sway',
  'fromDegrees',
  'toDegrees',
  'hoverTranslate',
  'hoverScale',
  'sparkles',
];
const List<String> _sparkleFields = <String>['opacity', 'x', 'y', 'scale'];

void main() {
  group('starfield docs page', () {
    testWidgets(
      'renders the article, all three API tables, and every specimen this '
      'page claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: StarfieldDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('starfield-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        for (final String param in _starfieldConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        for (final String field in _clusterFields) {
          expect(find.text(field), findsWidgets, reason: 'missing $field');
        }
        for (final String field in _sparkleFields) {
          expect(find.text(field), findsWidgets, reason: 'missing $field');
        }

        // Preview (1, non-hoverable), Host Height (2, non-hoverable) and
        // Hover (1, hoverable) each mount their own ElStarfield.
        expect(find.byType(ElStarfield), findsNWidgets(4));

        for (final String key in <String>[
          'starfield-preview:with',
          'starfield-preview:without',
          'starfield-host-height:short',
          'starfield-host-height:tall',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        expect(starfieldDoc.name, 'starfield');
        expect(
          starfieldDoc.exports,
          containsAll(<String>['ElStarfield', 'ElStarfieldCluster', 'ElSparkle']),
        );
        expect(starfieldDoc.command, 'elattar add starfield');
        expect(destination, isNull);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'a live mouse hover over the Hover specimen actually flips '
      'ElStarfield.hovered',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const StarfieldDocPage(),
          ),
        );
        await tester.pump();

        final Finder hoverSection = find.byWidgetPredicate(
          (Widget widget) => widget is DocsSection && widget.id == 'hover',
        );
        final Finder hoverStarfield = find.descendant(
          of: hoverSection,
          matching: find.byType(ElStarfield),
        );
        await tester.ensureVisible(hoverStarfield);
        await tester.pump();

        expect(tester.widget<ElStarfield>(hoverStarfield).hovered, isFalse);

        final TestGesture gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        addTearDown(() => gesture.removePointer());
        await gesture.addPointer(location: Offset.zero);
        await tester.pump();

        await gesture.moveTo(tester.getCenter(hoverStarfield));
        await tester.pump();

        expect(tester.widget<ElStarfield>(hoverStarfield).hovered, isTrue);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'holds still under reduced motion across a bounded pump, without '
      'throwing',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          ElTheme(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: MaterialApp(
              home: Builder(
                builder: (BuildContext context) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(disableAnimations: true),
                  child: const SingleChildScrollView(child: StarfieldDocPage()),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(seconds: 6));

        expect(find.byType(ElStarfield), findsWidgets);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the page is declared, and every section is a kit component',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const StarfieldDocPage(),
          ),
        );
        await tester.pump();

        // Three EffectSection stages: Preview, Host Height, Hover.
        expect(find.byType(DocsShowcase), findsNWidgets(3));
        expect(find.byType(DocsInstall), findsOneWidget);
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        starfieldDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Host Height',
          'Hover',
          'API Reference',
          'States',
          'Accessibility',
          'Keyboard',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ],
      );
      final DocsTocEntry api = starfieldDocSpec.toc.firstWhere(
        (DocsTocEntry e) => e.anchor == 'api',
      );
      expect(
        api.children.map((DocsTocEntry e) => e.anchor).toList(),
        <String>['api-elstarfield', 'api-elstarfieldcluster', 'api-elsparkle'],
      );
    });

    testWidgets('sections render in declaration order', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.dark,
      );
      await tester.pumpWidget(
        _harness(controller: controller, child: const StarfieldDocPage()),
      );
      await tester.pump();

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Host Height',
        'Hover',
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

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const StarfieldDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('starfield-doc-article')),
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

    testWidgets('renders in both themes without throwing', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      for (final ElThemeMode mode in <ElThemeMode>[
        ElThemeMode.dark,
        ElThemeMode.light,
      ]) {
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: mode),
            child: const StarfieldDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('starfield-doc-article')),
          findsOneWidget,
          reason: '$mode',
        );
        expect(tester.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
