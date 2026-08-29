import 'package:example/components_docs/catalog.dart';
import 'package:example/main.dart';
import 'package:example/site/pages/public_pages.dart';
import 'package:example/site/site_routes.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

/// Proves every entry in [componentDocs] is actually reachable.
///
/// A page can exist on disk, compile, and pass its own widget test while
/// still being unreachable from the site: nothing routes to it. This is the
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

    test('every entry lands in exactly one family, and the union is the '
        'whole catalog', () {
      final Map<ComponentDocFamily, List<String>> byFamily =
          <ComponentDocFamily, List<String>>{
            for (final ComponentDocFamily family in ComponentDocFamily.values)
              family: componentDocsIn(
                family,
              ).map((ComponentDocEntry entry) => entry.name).toList(),
          };

      final List<String> union = <String>[
        for (final List<String> names in byFamily.values) ...names,
      ];

      expect(
        union.toSet(),
        hasLength(union.length),
        reason: 'a component appears in more than one family.',
      );
      expect(
        union.toSet(),
        componentDocs.map((ComponentDocEntry entry) => entry.name).toSet(),
        reason:
            'the four families do not add up to componentDocs — a component '
            'is either listed twice or reachable from no group.',
      );
    });

    test('each configured family name is a real catalog entry', () {
      final Set<String> known = componentDocs
          .map((ComponentDocEntry entry) => entry.name.replaceAll('-', '_'))
          .toSet();
      for (final MapEntry<String, Set<String>> configured
          in <String, Set<String>>{
            'effectsDocNames': effectsDocNames,
            'agentDocNames': agentDocNames,
            'chartsDocNames': chartsDocNames,
          }.entries) {
        expect(
          configured.value.difference(known),
          isEmpty,
          reason:
              '${configured.key} names a component that is not in '
              'componentDocs; the taxonomy would silently drop it.',
        );
      }

      // The three sets together account for every non-default member, and
      // nothing else claims to be one.
      final int configuredCount = componentDocs
          .where(
            (ComponentDocEntry entry) => isConfiguredFamilyName(entry.name),
          )
          .length;
      expect(
        configuredCount,
        effectsDocNames.length + agentDocNames.length + chartsDocNames.length,
      );
    });

    test('every family is alphabetical by title', () {
      for (final ComponentDocFamily family in ComponentDocFamily.values) {
        final List<String> titles = componentDocsIn(
          family,
        ).map((ComponentDocEntry entry) => entry.title).toList();
        final List<String> sorted = <String>[...titles]..sort();
        expect(titles, sorted, reason: '${family.label} is out of order.');
      }
    });

    test('the four families own the components the site promises', () {
      ComponentDocFamily familyOf(String name) =>
          componentDocFamily(componentDoc(name));

      // The four named in the required outcome, one per family, plus the
      // three boundary cases the taxonomy exists to settle: an ordinary
      // state component is not an effect, a generic conversation primitive
      // is not agent-only, and the voice indicator is.
      expect(familyOf('button'), ComponentDocFamily.components);
      expect(familyOf('premium_surface'), ComponentDocFamily.effects);
      expect(familyOf('agent-composer'), ComponentDocFamily.agent);
      expect(familyOf('chart'), ComponentDocFamily.charts);
      expect(familyOf('skeleton'), ComponentDocFamily.components);
      expect(familyOf('message'), ComponentDocFamily.components);
      expect(familyOf('voice_indicator'), ComponentDocFamily.agent);
    });
  });
}
