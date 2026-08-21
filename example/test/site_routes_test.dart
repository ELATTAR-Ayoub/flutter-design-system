import 'package:example/nav.dart';
import 'package:example/components_docs/catalog.dart';
import 'package:example/site/site_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('public routes', () {
    test('exposes the five public destinations in navigation order', () {
      expect(
        siteRoutes.map((SiteRoute route) => route.path),
        <String>['/', '/docs', '/components', '/shots', '/skills'],
      );
      expect(siteRoutes.map((SiteRoute route) => route.title), <String>[
        'Home',
        'Documentation',
        'Components',
        'Shots',
        'Skills',
      ]);
    });

    test('lookup is exact and unknown paths return null', () {
      expect(siteRouteFor('/docs')?.section, SiteSection.docs);
      expect(
        siteRouteFor('/components/button')?.section,
        SiteSection.components,
      );
      expect(siteRouteFor('/Docs'), isNull);
      expect(siteRouteFor('/docs/'), isNull);
      expect(() => requireSiteRoute('/missing'), throwsArgumentError);
    });

    test('metadata is non-empty and route paths are unique', () {
      expect(siteRoutes.every((SiteRoute route) {
        return route.title.isNotEmpty &&
            route.description.isNotEmpty &&
            route.keywords.isNotEmpty;
      }), isTrue);
      final List<String> paths =
          siteRoutes.map((SiteRoute route) => route.path).toList();
      expect(paths.toSet(), hasLength(paths.length));
    });
  });

  group('GitHub Pages links', () {
    test('encodes route as a query component', () {
      expect(
        githubPagesHref('/docs'),
        '?route=%2Fdocs',
      );
      expect(
        githubPagesHref('/design-system/components/base/buttons'),
        '?route=%2Fdesign-system%2Fcomponents%2Fbase%2Fbuttons',
      );
    });

    test('normalizes a project base path', () {
      expect(githubPagesHref('/shots', basePath: '/elattar-ui'),
          '/elattar-ui/?route=%2Fshots');
      expect(githubPagesHref('/shots', basePath: 'elattar-ui/'),
          '/elattar-ui/?route=%2Fshots');
      expect(githubPagesHref('/shots', basePath: '/'),
          '?route=%2Fshots');
    });

    test('rejects empty and relative routes', () {
      expect(() => githubPagesHref('docs'), throwsArgumentError);
      expect(() => githubPagesHref(''), throwsArgumentError);
    });
  });

  group('search index', () {
    test('includes public routes and existing design-system routes', () {
      expect(searchableRoutes.first.path, homeRoute);
      expect(searchableRoutes.any((SearchRoute route) {
        return route.path == '/components/dialog' &&
            route.section == SiteSection.components;
      }), isTrue);
      expect(searchableRoutes.any((SearchRoute route) {
        return route.path == '$dsRoot/colors' && route.isDesignSystemRoute;
      }), isTrue);
      expect(searchableRoutes.any((SearchRoute route) {
        return route.path == '$dsRoot/components/base/buttons' &&
            route.groupId == 'base' &&
            route.slug == 'buttons';
      }), isTrue);
    });

    test('contains every installable component documentation route', () {
      final Set<String> indexed = searchableRoutes
          .where((SearchRoute route) => route.section == SiteSection.components)
          .map((SearchRoute route) => route.path)
          .toSet();
      expect(indexed, containsAll(componentDocs.map((entry) => entry.route)));
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
      expect(searchSiteRoutes('  BUTTONS  ').map((SearchRoute r) => r.path),
          contains('$dsRoot/components/base/buttons'));
      expect(searchSiteRoutes('FLUTTER').first.path, homeRoute);
      expect(searchSiteRoutes('not-a-real-route'), isEmpty);
      expect(searchSiteRoutes(''), same(searchableRoutes));
    });

    test('search index and keyword lists cannot be mutated', () {
      expect(() => searchableRoutes.add(searchableRoutes.first), throwsA(anything));
      expect(() => searchableRoutes.first.keywords.add('x'), throwsA(anything));
    });
  });
}
