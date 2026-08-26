import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/media_scrim/meta.dart';
import 'package:example/components_docs/media_scrim/page.dart';
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

/// `ElMediaScrim`'s own constructor parameter
/// (`lib/src/effects/media_scrim.dart`), excluding `key`.
const List<String> _mediaScrimConstructorParams = <String>['child'];

void main() {
  group('media-scrim docs page', () {
    testWidgets(
      'renders the article and the full API table',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: MediaScrimDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('media-scrim-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        for (final String param in _mediaScrimConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        // ElMediaScrimTokens' own fields, each its own row.
        for (final String field in <String>[
          'ink',
          'foreground',
          'stops',
          'middleAlpha',
          'bottomAlpha',
        ]) {
          expect(find.text(field), findsWidgets, reason: 'missing $field');
        }

        for (final String key in <String>[
          'media-scrim-example:no-scrim',
          'media-scrim-example:preview',
          'media-scrim-example:overlaid-copy',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        // A live ElMediaScrim specimen mounts for both facet sections.
        expect(find.byType(ElMediaScrim), findsNWidgets(2));

        expect(mediaScrimDoc.name, 'media_scrim');
        expect(mediaScrimDoc.exports, containsAll(<String>['ElMediaScrim']));
        expect(mediaScrimDoc.command, 'elattar add media-scrim');
        expect(destination, isNull);
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
            child: const MediaScrimDocPage(),
          ),
        );
        await tester.pump();

        // Two specimen stages: Preview and Overlaid Copy.
        expect(find.byType(DocsShowcase), findsNWidgets(2));
        expect(find.byType(DocsInstall), findsOneWidget);
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        mediaScrimDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Overlaid Copy',
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
      final DocsTocEntry api = mediaScrimDocSpec.toc.firstWhere(
        (DocsTocEntry e) => e.anchor == 'api',
      );
      expect(
        api.children.map((DocsTocEntry e) => e.anchor).toList(),
        <String>['api-elmediascrim', 'api-elmediascrimtokens'],
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
        _harness(controller: controller, child: const MediaScrimDocPage()),
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
        'Overlaid Copy',
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
            child: const MediaScrimDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('media-scrim-doc-article')),
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
            child: const MediaScrimDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('media-scrim-doc-article')),
          findsOneWidget,
          reason: '$mode',
        );
        expect(tester.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
