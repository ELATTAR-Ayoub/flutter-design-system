import 'dart:io';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/main.dart';
import 'package:example/shots_docs/catalog.dart';
import 'package:example/shots_docs/shot_detail_page.dart';
import 'package:example/shots_docs/shot_preview_host.dart';
import 'package:example/shots_docs/shots_index_page.dart';
import 'package:example/skills_docs/catalog.dart';
import 'package:example/skills_docs/skills_page.dart';
import 'package:example/site/pages/public_pages.dart';
import 'package:example/site/site_routes.dart' show shotsRoute, skillsRoute;
import 'package:example/site/site_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

/// The Shot the routing assertions deep-link to. Read from the catalog rather
/// than spelled out, so a renamed slug fails at the catalog and not here.
final ShotDocEntry _shot = shotDocs.first;

/// The Skill `/skills` serves. Same reasoning as [_shot].
final SkillDocEntry _skill = skillDocs.first;

/// The repository root, from the `example/` package this suite runs in — the
/// skill's real files live above it, at `skills/<slug>/…`.
String _rooted(String relative) => '../$relative';

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

  // `/skills` is no longer served from this library either — `PublicSkillsPage`
  // and its three hand-written cards were retired when `SkillsPage` took the
  // route. These tests are the old ones re-pointed at the real page, at the
  // route rather than at the widget, and they are the stricter half of the
  // guard: `skills_docs_test.dart` checks `SkillsPage` in isolation, this file
  // checks what `/skills` actually mounts, with the skill's REAL source loaded.
  group('the skills route', () {
    // `rootBundle` is a `CachingAssetBundle`: it caches the *Future*, not the
    // string, so a test that awaits a key an earlier test already loaded gets a
    // future from a scope that has ended and hangs. Same reasoning, and the
    // same fix, as `shots_catalog_parity_test.dart`.
    setUp(rootBundle.clear);

    testWidgets('resolves to the real Skills page, not the placeholder', (
      WidgetTester tester,
    ) async {
      _sizeTo(tester, const Size(1440, 900));

      // `skillsRoute`, not a literal: one spelling of `/skills` in the
      // repository, and the constant `site_routes.dart` publishes.
      await tester.pumpWidget(_harness(publicPageFor(skillsRoute)));
      await tester.pump();

      final SkillsPage page = tester.widget<SkillsPage>(
        find.byType(SkillsPage),
      );
      expect(page.entry?.slug, _skill.slug);

      // The retired page's own copy. A rewrite that quietly restored the
      // hand-written summary would fail here rather than pass by resembling
      // the real thing.
      expect(find.text('A shared way of working.'), findsNothing);
    });

    testWidgets('stays legible at a narrow viewport', (
      WidgetTester tester,
    ) async {
      _sizeTo(tester, const Size(390, 844));

      await tester.pumpWidget(_harness(publicPageFor(skillsRoute)));
      await tester.pump();

      expect(find.byType(SkillsPage), findsOneWidget);
      expect(find.textContaining(_skill.title), findsWidgets);
    });

    testWidgets('publishes no npx text and no command outside the allowlist', (
      WidgetTester tester,
    ) async {
      _sizeTo(tester, const Size(1440, 900));

      // Loaded FIRST, in this test's own scope, so the assertions below run
      // against the page as a reader sees it — every reference file's real
      // bytes rendered, not the "not loaded in this build" placeholder. A
      // narrower guard that only ever saw the placeholder would not notice an
      // invented command arriving through the skill's own Markdown.
      final Map<String, String> loaded = await skillSourceFor(_skill);
      expect(loaded, isNotEmpty);

      await tester.pumpWidget(_harness(publicPageFor(skillsRoute)));
      await tester.pump();

      // The page used to print `npx skills add ELATTAR-Ayoub/flutter-design-system`,
      // a command nothing in this repository implements, publishes or verifies.
      // Deleting it once is not enough: this is what stops it coming back.
      expect(find.textContaining('npx'), findsNothing);

      // The old page asserted `find.byType(DsAgentCodeBlock), findsNothing`.
      // That was a proxy for "prints no unverified command", available only
      // because the placeholder had no install section at all. `SkillsPage`
      // legitimately prints commands, so the proxy is replaced by the thing it
      // stood for — a strictly stronger check, since it also fails on a
      // rendered command the allowlist has never seen.
      //
      // Scoped to the `skill-command:` keys `_CommandBlock` assigns:
      // `DocsSelectableCodeBlock` also renders a reference file's *source* in
      // the file tree, and with the real bytes loaded above that is 6 KB of
      // Markdown, not a published command.
      final Iterable<DocsSelectableCodeBlock> blocks = tester
          .widgetList<DocsSelectableCodeBlock>(
            find.byType(DocsSelectableCodeBlock),
          )
          .where((DocsSelectableCodeBlock block) {
            final Key? key = block.key;
            return key is ValueKey<String> &&
                key.value.startsWith('skill-command:');
          });
      expect(
        blocks,
        isNotEmpty,
        reason:
            'The install section renders nothing; the allowlist check below '
            'would then pass vacuously.',
      );
      for (final DocsSelectableCodeBlock block in blocks) {
        expect(
          verifiedCommands,
          contains(block.code),
          reason:
              '"${block.code}" is rendered at /skills but is not in '
              "skills_docs/catalog.dart's verifiedCommands. A command reaches "
              'the public site only after a human puts it on that list.',
        );
      }
    });

    testWidgets('renders the real bytes of the skill on disk', (
      WidgetTester tester,
    ) async {
      _sizeTo(tester, const Size(1440, 900));

      // `skillSourceFor` is the production path — the same call `main.dart`
      // makes to fill `SkillsPage.fileSource`. The skill's directory sits above
      // `example/`, so it is declared as an asset by the PACKAGE pubspec at the
      // repository root and reached as `packages/elattar_design_system/skills/…`;
      // a missing declaration loads nothing and fails here, which is the only
      // warning before a release build shows readers "not loaded in this build".
      final Map<String, String> loaded = await skillSourceFor(_skill);

      expect(
        loaded.keys,
        unorderedEquals(_skill.files),
        reason:
            '${_skill.slug} did not load every file it declares. Check the '
            'skills/ asset lines in the repository-root pubspec.yaml.',
      );

      // There is exactly one copy of the skill — Decision 005 — so this is not
      // a parity check between two trees. It is the assertion that the page
      // shows THAT copy, byte for byte, and therefore cannot go stale when the
      // skill is edited.
      for (int index = 0; index < _skill.files.length; index++) {
        expect(
          loaded[_skill.files[index]],
          File(_rooted(_skill.sourcePaths[index])).readAsStringSync(),
          reason:
              '${_skill.files[index]} in the bundle differs from the file on '
              'disk. The page must show the source an agent actually loads.',
        );
      }

      // …and that the mounted route hands exactly that map to the page.
      await tester.pumpWidget(_harness(publicPageFor(skillsRoute)));
      await tester.pump();

      final SkillsPage page = tester.widget<SkillsPage>(
        find.byType(SkillsPage),
      );
      expect(page.fileSource, loaded);

      // …and that the file tree renders it. The tree shows the selected file,
      // which is the first one, as a single Text — so this compares the pixels
      // a reader gets against `File.readAsStringSync`, with nothing in between.
      expect(
        find.text(
          File(_rooted(_skill.sourcePaths.first)).readAsStringSync(),
        ),
        findsOneWidget,
        reason:
            '${_skill.files.first} is not rendered verbatim. The page must '
            'show the file, not a description of it.',
      );
      expect(find.textContaining('is not loaded in this build'), findsNothing);
    });
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
