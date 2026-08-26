import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/machine_surface/meta.dart';
import 'package:example/components_docs/machine_surface/page.dart';
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

/// Every named constructor parameter `ElMachineSurface`'s own class
/// declares (`lib/src/effects/machine_surface.dart`), excluding `key`.
const List<String> _machineSurfaceConstructorParams = <String>[
  'spec',
  'radius',
  'fill',
  'border',
  'child',
];

void main() {
  group('machine-surface docs page', () {
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
            child: MachineSurfaceDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // One frame is enough — no pumpAndSettle: this page's own pages
        // family includes foil-value, whose foil shimmer never settles,
        // and the rule is enforced across every documentation page.
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('machine-surface-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        for (final String param in _machineSurfaceConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        // Every example specimen this page's own source keys carries its
        // key on the page.
        for (final String key in <String>[
          'machine-surface-example:flat',
          'machine-surface-example:preview',
          'machine-surface-example:outer-only',
          'machine-surface-example:inset',
          'machine-surface-example:rest',
          'machine-surface-example:pressed',
          'machine-surface-example:no-border',
          'machine-surface-example:with-border',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsWidgets,
            reason: 'missing example specimen $key',
          );
        }

        // A live ElMachineSurface specimen mounts for every facet section:
        // preview, inset-shadow (x2), pressed (x2), border (x1 — the
        // no-border specimen still goes through ElMachineSurface with
        // border: null) — six of this page's own. Not an exact count: the
        // docs shell itself (ElToggleGroup, badges, disclosure triggers)
        // composes ElMachineSurface too, so more than six mount in total.
        expect(
          find.byType(ElMachineSurface),
          findsAtLeastNWidgets(6),
          reason: 'at least one live ElMachineSurface per facet specimen',
        );

        expect(machineSurfaceDoc.name, 'machine_surface');
        expect(machineSurfaceDoc.exports, containsAll(<String>['ElMachineSurface']));
        expect(machineSurfaceDoc.command, 'elattar add machine-surface');
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
            child: const MachineSurfaceDocPage(),
          ),
        );
        await tester.pump();

        // Five specimen stages: Preview, Inset Shadow, Pressed, Border —
        // wait, that is four EffectSections, each rendered as one
        // DocsShowcase.
        expect(find.byType(DocsShowcase), findsNWidgets(4));
        expect(find.byType(DocsInstall), findsOneWidget);
        // Eight collapsed sections: API Reference, States, Accessibility,
        // Keyboard, Responsive, Dependencies, Theming, Source.
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        machineSurfaceDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Inset Shadow',
          'Pressed',
          'Border',
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
    });

    testWidgets(
      'sections render in declaration order',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const MachineSurfaceDocPage()),
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
          'Inset Shadow',
          'Pressed',
          'Border',
          'API Reference',
          'States',
          'Accessibility',
          'Keyboard',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ]);
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
            child: const MachineSurfaceDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('machine-surface-doc-article')),
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
      'renders in both themes without throwing',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        for (final ElThemeMode mode in ElThemeMode.values) {
          await tester.pumpWidget(
            _harness(
              controller: ElThemeController(mode: mode),
              child: const MachineSurfaceDocPage(),
            ),
          );
          await tester.pump();

          expect(
            find.byKey(const ValueKey<String>('machine-surface-doc-article')),
            findsOneWidget,
            reason: '$mode',
          );
          expect(tester.takeException(), isNull, reason: '$mode');
        }
      },
    );
  });
}
