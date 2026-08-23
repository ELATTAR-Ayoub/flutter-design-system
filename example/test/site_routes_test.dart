import 'package:example/nav.dart';
import 'package:example/components_docs/catalog.dart';
import 'package:example/docs_pages/catalog.dart';
import 'package:example/skills_docs/catalog.dart';
import 'package:example/site/site_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('public routes', () {
    test('exposes the public destinations in navigation order', () {
      expect(siteRoutes.map((SiteRoute route) => route.path), <String>[
        homeRoute,
        docsRoute,
        docsIntroductionRoute,
        componentsRoute,
        docsInstallationRoute,
        docsThemingRoute,
        docsCliRoute,
        skillsRoute,
      ]);
      expect(siteRoutes.map((SiteRoute route) => route.title), <String>[
        'Home',
        'Documentation',
        'Introduction',
        'Components',
        'Installation',
        'Theming',
        'CLI',
        'Skills',
      ]);
    });

    test('the Sections group (every sidebar-visible destination, in order) '
        'reproduces the reference reading order exactly: Introduction, '
        'Components, Installation, Theming, CLI, Skills', () {
      final List<String> sectionTitles = siteRoutes
          .where(
            (SiteRoute route) =>
                route.section != SiteSection.home && route.showInSidebar,
          )
          .map((SiteRoute route) => route.title)
          .toList();
      // "Documentation" (`/docs`) stays a resolvable route: removing it
      // would break `site_navigation.dart`'s eager `siteQuickSearchRoutes`
      // lookup and `site_shell_test.dart`'s quick-open assertion. It is
      // excluded here through `SiteRoute.showInSidebar`, not by filtering
      // its title out after the fact, so this is the true sidebar order.
      expect(sectionTitles, <String>[
        'Introduction',
        'Components',
        'Installation',
        'Theming',
        'CLI',
        'Skills',
      ]);
      expect(sectionTitles, isNot(contains('Documentation')));
      // Typeset, Registry and Changelog have no page yet
      // (`docs_pages/catalog.dart` declares the routes; nothing routes to
      // them in `main.dart`), so they must not appear in the sidebar.
      expect(sectionTitles, isNot(contains('Typeset')));
      expect(sectionTitles, isNot(contains('Registry')));
      expect(sectionTitles, isNot(contains('Changelog')));
    });

    test('lookup is exact and unknown paths return null', () {
      expect(siteRouteFor('/docs')?.section, SiteSection.docs);
      expect(siteRouteFor('/docs')?.showInSidebar, isFalse);
      expect(siteRouteFor(docsIntroductionRoute)?.section, SiteSection.docs);
      expect(siteRouteFor(docsInstallationRoute)?.section, SiteSection.docs);
      expect(siteRouteFor(docsThemingRoute)?.section, SiteSection.docs);
      expect(siteRouteFor(docsCliRoute)?.section, SiteSection.docs);
      expect(
        siteRouteFor('/components/button')?.section,
        SiteSection.components,
      );
      expect(siteRouteFor('/Docs'), isNull);
      expect(siteRouteFor('/docs/'), isNull);
      expect(() => requireSiteRoute('/missing'), throwsArgumentError);
    });

    test('metadata is non-empty and route paths are unique', () {
      expect(
        siteRoutes.every((SiteRoute route) {
          return route.title.isNotEmpty &&
              route.description.isNotEmpty &&
              route.keywords.isNotEmpty;
        }),
        isTrue,
      );
      final List<String> paths = siteRoutes
          .map((SiteRoute route) => route.path)
          .toList();
      expect(paths.toSet(), hasLength(paths.length));
    });
  });

  group('GitHub Pages links', () {
    test('encodes route as a query component', () {
      expect(githubPagesHref('/docs'), '?route=%2Fdocs');
      expect(
        githubPagesHref('/design-system/components/base/buttons'),
        '?route=%2Fdesign-system%2Fcomponents%2Fbase%2Fbuttons',
      );
    });

    test('normalizes a project base path', () {
      expect(
        githubPagesHref('/components', basePath: '/elattar-ui'),
        '/elattar-ui/?route=%2Fcomponents',
      );
      expect(
        githubPagesHref('/components', basePath: 'elattar-ui/'),
        '/elattar-ui/?route=%2Fcomponents',
      );
      expect(
        githubPagesHref('/components', basePath: '/'),
        '?route=%2Fcomponents',
      );
    });

    test('rejects empty and relative routes', () {
      expect(() => githubPagesHref('docs'), throwsArgumentError);
      expect(() => githubPagesHref(''), throwsArgumentError);
    });
  });

  group('search index', () {
    test('includes public routes and existing design-system routes', () {
      expect(searchableRoutes.first.path, homeRoute);
      expect(
        searchableRoutes.any((SearchRoute route) {
          return route.path == '/components/dialog' &&
              route.section == SiteSection.components;
        }),
        isTrue,
      );
      expect(
        searchableRoutes.any((SearchRoute route) {
          return route.path == '$dsRoot/colors' && route.isDesignSystemRoute;
        }),
        isTrue,
      );
      expect(
        searchableRoutes.any((SearchRoute route) {
          return route.path == '$dsRoot/components/base/buttons' &&
              route.groupId == 'base' &&
              route.slug == 'buttons';
        }),
        isTrue,
      );
    });

    test('contains every installable component documentation route', () {
      final Set<String> indexed = searchableRoutes
          .where((SearchRoute route) => route.section == SiteSection.components)
          .map((SearchRoute route) => route.path)
          .toSet();
      expect(indexed, containsAll(componentDocs.map((entry) => entry.route)));
    });

    test('indexes the skill under the Skills destination, not beside it', () {
      // `SkillDocEntry.route` is the literal `/skills`: one skill, no
      // index/detail split. So the skill must NOT appear as a second row with
      // the same path — a duplicate would make the search box answer "skills"
      // twice and send both rows to the same page.
      final List<SearchRoute> rows = searchableRoutes
          .where((SearchRoute route) => route.path == skillsRoute)
          .toList();
      expect(rows, hasLength(1));
      expect(rows.single.section, SiteSection.skills);

      for (final SkillDocEntry skill in skillDocs) {
        expect(skill.route, skillsRoute);
        expect(rows.single.keywords, contains(skill.slug));
      }
    });

    test('skill topics are searchable', () {
      // The IA plan requires "Skill topics" in search. The topics are the
      // skill's own reference titles, read from the catalog rather than spelled
      // out here, so a renamed or added reference is indexed automatically and
      // a stale list fails at the catalog instead of passing quietly.
      for (final SkillDocEntry skill in skillDocs) {
        for (final SkillReferenceFile file in skill.referenceFiles) {
          final List<SearchRoute> hits = searchSiteRoutes(
            file.title,
          ).where((SearchRoute route) => route.path == skill.route).toList();
          expect(
            hits,
            hasLength(1),
            reason: '"${file.title}" does not find ${skill.route}.',
          );
        }
        // The agents it is actually verified against are searchable too, and
        // only those: `agents/openai.yaml` was deleted, so nothing may make
        // Codex resolve to this page.
        for (final String agent in skill.supportedAgents) {
          expect(
            searchSiteRoutes(agent).map((SearchRoute route) => route.path),
            contains(skill.route),
          );
        }
        expect(
          searchSiteRoutes('codex').map((SearchRoute route) => route.path),
          isNot(contains(skill.route)),
        );
      }
    });

    test('contains every existing group and category without changing nav', () {
      final Set<String> expected = <String>{
        for (final DsGroup group in dsGroups) group.href,
        for (final DsGroup group in dsGroups)
          for (final DsCategory category in group.categories)
            categoryHref(group, category),
      };
      final Set<String> indexed = searchableRoutes
          .where((SearchRoute route) => route.isDesignSystemRoute)
          .map((SearchRoute route) => route.path)
          .toSet();
      expect(indexed, expected);
    });

    test('search is case-insensitive, trims input, and preserves order', () {
      expect(
        searchSiteRoutes('  BUTTONS  ').map((SearchRoute r) => r.path),
        contains('$dsRoot/components/base/buttons'),
      );
      expect(searchSiteRoutes('FLUTTER').first.path, homeRoute);
      expect(searchSiteRoutes('not-a-real-route'), isEmpty);
      expect(searchSiteRoutes(''), same(searchableRoutes));
    });

    test('search index and keyword lists cannot be mutated', () {
      expect(
        () => searchableRoutes.add(searchableRoutes.first),
        throwsA(anything),
      );
      expect(() => searchableRoutes.first.keywords.add('x'), throwsA(anything));
    });
  });
}
