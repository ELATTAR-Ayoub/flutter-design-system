/// Wiring tests for the four `docs_pages/` articles (`IntroductionDocsPage`,
/// `InstallationDocsPage`, `ThemingDocsPage`, `CliDocsPage`): that
/// `main.dart`'s `publicPageFor` actually dispatches their route to their
/// widget, and that the documentation shell's "Sections" rail
/// (`docs/docs_layout.dart`'s `_defaultSidebarGroups`, read from
/// `site/site_routes.dart`'s `siteRoutes`, neither file touched here) lists
/// them in the required reading order.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs_pages/catalog.dart';
import 'package:example/main.dart';
import 'package:example/site/site_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) => ElTheme(
  controller: ElThemeController(mode: ElThemeMode.dark),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SingleChildScrollView(child: child),
  ),
);

void _sizeTo(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
}

/// The `docs-sidebar:<route>` keys rendered under the "Sections" group, top
/// to bottom, exactly as `DocsSidebar` laid them out.
List<String> _sectionsOrder(WidgetTester tester) {
  final Finder group = find.byKey(
    const ValueKey<String>('docs-sidebar-group:Sections'),
  );
  expect(group, findsOneWidget);

  final Iterable<Element> rows = find
      .descendant(
        of: group,
        matching: find.byWidgetPredicate((Widget widget) {
          final Key? key = widget.key;
          return key is ValueKey<String> &&
              key.value.startsWith('docs-sidebar:');
        }),
      )
      .evaluate();

  return <String>[
    for (final Element element in rows)
      (element.widget.key! as ValueKey<String>).value.substring(
        'docs-sidebar:'.length,
      ),
  ];
}

void main() {
  group('the four docs_pages routes resolve through publicPageFor', () {
    const Map<String, Key> pages = <String, Key>{
      docsIntroductionRoute: ValueKey<String>('introduction-doc-article'),
      docsInstallationRoute: ValueKey<String>('installation-doc-article'),
      docsThemingRoute: ValueKey<String>('theming-doc-article'),
      docsCliRoute: ValueKey<String>('cli-doc-article'),
    };

    for (final MapEntry<String, Key> page in pages.entries) {
      testWidgets('${page.key} mounts its article and its own Sections '
          'entry, marked selected', (WidgetTester tester) async {
        _sizeTo(tester, const Size(1440, 900));
        await tester.pumpWidget(_harness(publicPageFor(page.key)));

        // The page's article root mounted: this is the actual widget the
        // route dispatches to, not a fallback like `PublicHomePage`.
        expect(find.byKey(page.value), findsOneWidget);

        final Finder ownEntry = find.byKey(
          ValueKey<String>('docs-sidebar:${page.key}'),
        );
        expect(ownEntry, findsOneWidget);
        final Semantics semantics = tester.widget<Semantics>(
          find.ancestor(of: ownEntry, matching: find.byType(Semantics)).first,
        );
        expect(semantics.properties.selected, isTrue);

        expect(tester.takeException(), isNull);
      });
    }
  });

  testWidgets(
    'the Sections group lists Introduction, Components, Installation, '
    'Theming, CLI and Skills in that order; Documentation, Typeset, '
    'Registry and Changelog have no entry there',
    (WidgetTester tester) async {
      _sizeTo(tester, const Size(1440, 900));
      await tester.pumpWidget(_harness(publicPageFor(docsIntroductionRoute)));

      final List<String> order = _sectionsOrder(tester);
      // `docsRoute` ("Documentation") still resolves through `main.dart`'s
      // `publicPageFor` and still appears in quick search, see the note on
      // `siteRoutes` in `site/site_routes.dart`; it is just excluded from
      // this rail via `SiteRoute.showInSidebar`.
      expect(order, <String>[
        docsIntroductionRoute,
        componentsRoute,
        docsInstallationRoute,
        docsThemingRoute,
        docsCliRoute,
        skillsRoute,
      ]);
      expect(order, isNot(contains(docsRoute)));
      expect(order, isNot(contains(docsTypesetRoute)));
      expect(order, isNot(contains(docsRegistryRoute)));
      expect(order, isNot(contains(docsChangelogRoute)));

      expect(tester.takeException(), isNull);
    },
  );
}
