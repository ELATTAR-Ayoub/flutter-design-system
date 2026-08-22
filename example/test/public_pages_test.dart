import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/main.dart';
import 'package:example/shots_docs/catalog.dart';
import 'package:example/shots_docs/shot_detail_page.dart';
import 'package:example/shots_docs/shot_preview_host.dart';
import 'package:example/shots_docs/shots_index_page.dart';
import 'package:example/site/pages/public_pages.dart';
import 'package:example/site/site_routes.dart' show shotsRoute;
import 'package:example/site/site_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The Shot the routing assertions deep-link to. Read from the catalog rather
/// than spelled out, so a renamed slug fails at the catalog and not here.
final ShotDocEntry _shot = shotDocs.first;

Widget _harness(Widget child) => DsTheme(
  controller: DsThemeController(mode: DsThemeMode.dark),
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

void main() {
  testWidgets('home exposes the foundation-first quickstart', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_harness(const PublicHomePage()));

    expect(find.text('Build the interface\nyou mean.'), findsOneWidget);
    expect(find.text('One command to begin.'), findsOneWidget);
    expect(
      find.text('dart run elattar_cli init --foundation source'),
      findsOneWidget,
    );
    expect(find.text('Start building'), findsOneWidget);
  });

  testWidgets('public page actions report their route without owning routing', (
    WidgetTester tester,
  ) async {
    final List<String> routes = <String>[];
    await tester.pumpWidget(_harness(PublicHomePage(onNavigate: routes.add)));

    final Finder docsAction = find.text('Read the docs');
    await tester.ensureVisible(docsAction);
    await tester.tap(docsAction);
    await tester.pump();
    expect(routes, <String>[publicDocsRoute]);
  });

  testWidgets('components page renders installable docs and legacy groups', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_harness(const PublicComponentsPage()));

    expect(find.text('Base Components'), findsOneWidget);
    expect(find.text('Agent'), findsOneWidget);
    expect(find.text('Buttons'), findsOneWidget);
    expect(find.text('Console'), findsOneWidget);
    expect(find.text('Ready to install'), findsOneWidget);
    expect(find.text('Button'), findsOneWidget);
    expect(find.text('elattar add button'), findsOneWidget);
  });

  // `/shots` is no longer served from this library — `PublicShotsPage` and its
  // four hand-written cards were retired when `ShotsIndexPage` took the route.
  // The narrow-viewport half of the old assertion is not lost: it lives in
  // `shots_index_test.dart`, which renders the real index at 390x844 and 1440x900,
  // on both themes, against every catalog entry rather than four literals.
  testWidgets('skills stays legible at a narrow viewport and publishes no '
      'install command', (WidgetTester tester) async {
    _sizeTo(tester, const Size(390, 844));

    await tester.pumpWidget(_harness(const PublicSkillsPage()));
    expect(find.text('Skills'), findsOneWidget);
    expect(find.text('A shared way of working.'), findsOneWidget);

    // The page used to print `npx skills add ELATTAR-Ayoub/flutter-design-system`,
    // a command nothing in this repository implements, publishes or verifies.
    // Deleting it once is not enough: this is what stops it — or any other
    // unverified command — coming back. The Skills page renders no code block
    // at all until there is a real install route to describe.
    expect(find.byType(DsAgentCodeBlock), findsNothing);
    expect(find.textContaining('npx'), findsNothing);
  });

  group('public route wiring', () {
    testWidgets('the shots index route resolves to the catalog index', (
      WidgetTester tester,
    ) async {
      _sizeTo(tester, const Size(1440, 900));

      // `shotsRoute`, not a literal: one spelling of `/shots` in the repository.
      await tester.pumpWidget(_harness(publicPageFor(shotsRoute)));
      await tester.pump();

      expect(find.byType(ShotsIndexPage), findsOneWidget);
    });

    testWidgets('a shot deep link resolves to its detail page', (
      WidgetTester tester,
    ) async {
      _sizeTo(tester, const Size(1440, 900));

      await tester.pumpWidget(_harness(publicPageFor(_shot.route)));
      await tester.pump();

      final ShotDetailPage page = tester.widget<ShotDetailPage>(
        find.byType(ShotDetailPage),
      );
      expect(page.entry.name, _shot.name);
    });

    // That the detail page is handed the REAL source — the bytes on disk, not
    // a copy of them — is asserted in `shots_catalog_parity_test.dart`, which
    // owns the asset-bundle contract for every Shot rather than one of them.
    // It cannot also be asserted here: `rootBundle` caches the `Future`, not
    // the string, so a second `await` of a key an earlier test in the same file
    // already loaded receives a future from a scope that has ended and never
    // completes.

    testWidgets('the preview route mounts no site chrome', (
      WidgetTester tester,
    ) async {
      _sizeTo(tester, const Size(1440, 900));

      // The Wave 2 contract, at the layer that actually decides it: the route
      // arm in `main.dart` sits ABOVE the `siteRouteFor` guard, so a route that
      // begins with `/shots` still escapes header, footer and search.
      await tester.pumpWidget(DocsApp(initialRoute: _shot.previewRoute));
      await tester.pump();

      expect(find.byType(ShotPreviewHost), findsOneWidget);
      expect(find.byType(SiteShell), findsNothing);
    });

    testWidgets('the shot detail route keeps the site chrome', (
      WidgetTester tester,
    ) async {
      _sizeTo(tester, const Size(1440, 900));

      // The other half of the same contract: strip the `/preview` suffix and
      // the very same prefix is a site destination again.
      await tester.pumpWidget(DocsApp(initialRoute: _shot.route));
      await tester.pump();

      expect(find.byType(SiteShell), findsOneWidget);
      expect(find.byType(ShotDetailPage), findsOneWidget);
      expect(find.byType(ShotPreviewHost), findsNothing);
    });
  });
}
