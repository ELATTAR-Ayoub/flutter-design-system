import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/glass/meta.dart';
import 'package:example/components_docs/glass/page.dart';
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

/// The shared three-field constructor every glass widget declares
/// (`lib/src/effects/glass.dart`), excluding `key`.
const List<String> _glassConstructorParams = <String>['radius', 'padding', 'child'];

void main() {
  group('glass docs page', () {
    testWidgets(
      'renders the article and the full API table for all four classes',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: GlassDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('glass-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        // Every class name appears (one table heading each) and every
        // shared constructor parameter appears at least four times, once
        // per table.
        for (final String className in <String>[
          'ElGlassPanel',
          'ElGlassPanelClear',
          'ElGlassPanelDeep',
          'ElGlassControl',
        ]) {
          expect(find.text(className), findsWidgets, reason: 'missing $className');
        }
        for (final String param in _glassConstructorParams) {
          expect(find.text(param), findsNWidgets(4), reason: 'missing $param');
        }

        for (final String key in <String>[
          'glass-example:opaque',
          'glass-example:preview',
          'glass-example:control-flat',
          'glass-example:control',
          'glass-example:deep-e2',
          'glass-example:deep-e4',
          'glass-example:clear-panel',
          'glass-example:clear',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        // A live specimen of every exported class mounts somewhere.
        expect(find.byType(ElGlassPanel), findsNWidgets(3));
        expect(find.byType(ElGlassPanelClear), findsOneWidget);
        expect(find.byType(ElGlassPanelDeep), findsOneWidget);
        expect(find.byType(ElGlassControl), findsOneWidget);

        expect(glassDoc.name, 'glass');
        expect(
          glassDoc.exports,
          containsAll(<String>[
            'ElGlassPanel',
            'ElGlassPanelClear',
            'ElGlassPanelDeep',
            'ElGlassControl',
          ]),
        );
        expect(glassDoc.command, 'elattar add glass');
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
            child: const GlassDocPage(),
          ),
        );
        await tester.pump();

        // Four specimen stages: Preview, Control, Deep, Clear.
        expect(find.byType(DocsShowcase), findsNWidgets(4));
        expect(find.byType(DocsInstall), findsOneWidget);
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        glassDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Control',
          'Deep',
          'Clear',
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
      // The API Reference disclosure contributes four sub-anchors, one per
      // class table.
      final DocsTocEntry api = glassDocSpec.toc.firstWhere(
        (DocsTocEntry e) => e.anchor == 'api',
      );
      expect(
        api.children.map((DocsTocEntry e) => e.anchor).toList(),
        <String>[
          'api-elglasspanel',
          'api-elglasspanelclear',
          'api-elglasspaneldeep',
          'api-elglasscontrol',
        ],
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
        _harness(controller: controller, child: const GlassDocPage()),
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
        'Control',
        'Deep',
        'Clear',
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
            child: const GlassDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('glass-doc-article')),
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
            child: const GlassDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('glass-doc-article')),
          findsOneWidget,
          reason: '$mode',
        );
        expect(tester.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
