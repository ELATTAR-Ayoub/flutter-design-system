import 'package:example/components_docs/catalog.dart';
import 'package:example/main.dart';
import 'package:example/site/pages/public_pages.dart';
import 'package:example/site/site_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Proves every entry in [componentDocs] is actually reachable.
///
/// A page can exist on disk, compile, and pass its own widget test while
/// still being unreachable from the site — nothing routes to it. This is the
/// test that closes that gap: for every catalog entry it checks the route
/// resolves, the route dispatches to a real page rather than the home-page
/// fallback `publicPageFor` returns for an unknown route, the route is
/// indexed for search exactly once, and the catalog itself carries no
/// duplicate name or route. A future page added to [componentDocs] without
/// being wired into `site_routes.dart` or `main.dart` fails here rather than
/// staying silently dead.
void main() {
  group('catalog wiring', () {
    test('every catalog entry resolves through siteRouteFor', () {
      for (final ComponentDocEntry entry in componentDocs) {
        expect(
          siteRouteFor(entry.route),
          isNotNull,
          reason: '${entry.route} does not resolve through siteRouteFor.',
        );
      }
    });

    test(
      'every catalog entry dispatches to its own page, not the fallback',
      () {
        for (final ComponentDocEntry entry in componentDocs) {
          final Widget page = publicPageFor(entry.route, onNavigate: (_) {});
          expect(
            page,
            isNotNull,
            reason: '${entry.route} did not return a widget.',
          );
          // `publicPageFor` falls back to `PublicHomePage` for any route it
          // cannot dispatch. An entry that resolves to it is a catalog entry
          // with no page wired behind its route.
          expect(
            page,
            isNot(isA<PublicHomePage>()),
            reason:
                '${entry.route} fell through to the not-found fallback '
                '(PublicHomePage) instead of resolving to its own page.',
          );
        }
      },
    );

    test('every catalog entry is indexed for search exactly once', () {
      for (final ComponentDocEntry entry in componentDocs) {
        final int hits = searchableRoutes
            .where((SearchRoute route) => route.path == entry.route)
            .length;
        expect(
          hits,
          1,
          reason:
              '${entry.route} appears $hits times in searchableRoutes; '
              'expected exactly 1.',
        );
      }
    });

    test('no two catalog entries share a name or a route', () {
      final List<String> names = componentDocs
          .map((ComponentDocEntry entry) => entry.name)
          .toList();
      final List<String> routes = componentDocs
          .map((ComponentDocEntry entry) => entry.route)
          .toList();

      expect(
        names.toSet(),
        hasLength(names.length),
        reason: 'componentDocs has a duplicate name.',
      );
      expect(
        routes.toSet(),
        hasLength(routes.length),
        reason: 'componentDocs has a duplicate route.',
      );
    });
  });
}
