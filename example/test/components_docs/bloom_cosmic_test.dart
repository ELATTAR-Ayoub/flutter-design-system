/// Tests for the bloom-cosmic effect documentation page.
///
/// **No `pumpAndSettle` anywhere in this file.** Both of ElBloomCosmic's
/// drift `AnimationController`s (_deep, _near) call `repeat(reverse: true)`
/// forever, so `pumpAndSettle()` would hang rather than fail; every wait
/// below is a bounded `tester.pump()` / `tester.pump(Duration(...))`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/bloom_cosmic/meta.dart';
import 'package:example/components_docs/bloom_cosmic/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
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

/// `ElBloomCosmic`'s own general-constructor parameters (`lib/src/effects/
/// bloom_cosmic.dart`), excluding `key`.
const List<String> _bloomCosmicConstructorParams = <String>[
  'bloom1',
  'bloom2',
  'radius',
  'fill',
  'child',
  'starfield',
];

/// Every named-constructor identifier documented in the second API table.
const List<String> _namedConstructors = <String>[
  '.action',
  '.destructive',
  '.success',
  '.warning',
  '.info',
  '.toastWarning',
  '.loading',
];

void main() {
  group('bloom-cosmic docs page', () {
    testWidgets(
      'renders the article, both API tables, and every specimen this page '
      'claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: BloomCosmicDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('bloom-cosmic-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        for (final String param in _bloomCosmicConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        for (final String ctor in _namedConstructors) {
          expect(find.text(ctor), findsWidgets, reason: 'missing $ctor');
        }

        // Preview's "with" panel (1), all five Variants chips (5) and both
        // Starfield toggle boxes (2) each mount one ElBloomCosmic: eight.
        expect(find.byType(ElBloomCosmic), findsNWidgets(8));

        for (final String key in <String>[
          'bloom-cosmic-preview:with',
          'bloom-cosmic-preview:without',
          'bloom-cosmic-variant:action',
          'bloom-cosmic-variant:destructive',
          'bloom-cosmic-variant:success',
          'bloom-cosmic-variant:warning',
          'bloom-cosmic-variant:info',
          'bloom-cosmic-starfield:on',
          'bloom-cosmic-starfield:off',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        expect(bloomCosmicDoc.name, 'bloom_cosmic');
        expect(
          bloomCosmicDoc.exports,
          containsAll(<String>[
            'ElBloomCosmic',
            'ElBloomDrift',
            'ElBloomDriftStop',
            'ElBloomInk',
          ]),
        );
        expect(bloomCosmicDoc.command, 'elattar add bloom-cosmic');
        expect(destination, isNull);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the starfield toggle actually mounts and omits ElStarfield',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const BloomCosmicDocPage(),
          ),
        );
        await tester.pump();

        final Finder onBox = find.byKey(
          const ValueKey<String>('bloom-cosmic-starfield:on'),
        );
        final Finder offBox = find.byKey(
          const ValueKey<String>('bloom-cosmic-starfield:off'),
        );
        await tester.ensureVisible(onBox);
        await tester.pump();

        expect(
          find.descendant(of: onBox, matching: find.byType(ElStarfield)),
          findsOneWidget,
        );
        expect(
          find.descendant(of: offBox, matching: find.byType(ElStarfield)),
          findsNothing,
        );
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
                  child: const SingleChildScrollView(
                    child: BloomCosmicDocPage(),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(seconds: 3));

        expect(find.byType(ElBloomCosmic), findsWidgets);
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
            child: const BloomCosmicDocPage(),
          ),
        );
        await tester.pump();

        // Three EffectSection stages: Preview, Variants, Starfield.
        expect(find.byType(DocsShowcase), findsNWidgets(3));
        expect(find.byType(DocsInstall), findsOneWidget);
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        bloomCosmicDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Variants',
          'Starfield',
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
      final DocsTocEntry api = bloomCosmicDocSpec.toc.firstWhere(
        (DocsTocEntry e) => e.anchor == 'api',
      );
      expect(
        api.children.map((DocsTocEntry e) => e.anchor).toList(),
        <String>['api-elbloomcosmic', 'api-named-constructors'],
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
        _harness(controller: controller, child: const BloomCosmicDocPage()),
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
        'Variants',
        'Starfield',
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
            child: const BloomCosmicDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('bloom-cosmic-doc-article')),
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
            child: const BloomCosmicDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('bloom-cosmic-doc-article')),
          findsOneWidget,
          reason: '$mode',
        );
        expect(tester.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
