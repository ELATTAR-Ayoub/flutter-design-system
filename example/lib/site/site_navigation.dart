/// Public-site navigation groupings and search presentation helpers.
library;

import 'package:elattar_design_system/elattar_design_system.dart';

import '../nav.dart';
import 'site_routes.dart';

/// One navigation entry surfaced by the public site shell.
class SiteNavEntry {
  const SiteNavEntry({
    required this.title,
    required this.path,
    required this.description,
    this.keywords = const <String>[],
    this.section,
  });

  final String title;
  final String path;
  final String description;
  final List<String> keywords;
  final SiteSection? section;
}

/// One labelled group of navigation entries.
class SiteNavGroup {
  const SiteNavGroup({required this.title, required this.entries});

  final String title;
  final List<SiteNavEntry> entries;
}

/// The top-level public destinations, in header order.
///
/// Exactly two: `Documentation` and `Components`. Everything else a reader can
/// reach lives in the left rail of the documentation shell, never in the
/// header. Introduction, Installation, Theming, CLI and Skills are all
/// documentation pages, so putting them beside `Documentation` in the header
/// listed a section and its own children as peers.
///
/// This filters [siteRoutes] rather than restating it, so a route added there
/// cannot silently reappear in the header: only the two section landings do.
final List<SiteNavEntry> primarySiteNavigation =
    List<SiteNavEntry>.unmodifiable(<SiteNavEntry>[
      for (final SiteRoute route in siteRoutes)
        if (route.path == docsRoute || route.path == componentsRoute)
          SiteNavEntry(
            title: route.title,
            path: route.path,
            description: route.description,
            keywords: route.keywords,
            section: route.section,
          ),
    ]);

/// Footer groupings for the public shell.
final List<SiteNavGroup> footerSiteNavigation = List<SiteNavGroup>.unmodifiable(
  <SiteNavGroup>[
    SiteNavGroup(title: 'Explore', entries: primarySiteNavigation),
    SiteNavGroup(
      title: 'Design system',
      entries: <SiteNavEntry>[
        const SiteNavEntry(
          title: 'Overview',
          path: elRoot,
          description: 'The operating manual for the whole design system.',
          keywords: <String>['overview', 'foundations'],
          section: SiteSection.docs,
        ),
        for (final ElGroup group in elGroups.skip(1))
          SiteNavEntry(
            title: group.title,
            path: group.href,
            description: group.blurb,
            keywords: <String>[group.id, 'design system'],
            section: SiteSection.docs,
          ),
      ],
    ),
  ],
);

/// The curated quick-open list shown when search first opens.
final List<SearchRoute> siteQuickSearchRoutes = List<SearchRoute>.unmodifiable(
  <SearchRoute>[
    for (final String path in <String>[
      homeRoute,
      docsRoute,
      componentsRoute,
      skillsRoute,
      elRoot,
      '$elRoot/colors',
      '$elRoot/typography',
      '$elRoot/motion',
      '$elRoot/components/base/buttons',
      '$elRoot/components/base/sidebar',
      '$elRoot/components/agent/console',
    ])
      searchRouteByPath(path),
  ],
);

/// Finds a searchable route by its exact path.
SearchRoute searchRouteByPath(String path) {
  for (final SearchRoute route in searchableRoutes) {
    if (route.path == path) return route;
  }
  throw ArgumentError.value(path, 'path', 'Unknown searchable route');
}

/// One labelled group of search results.
class SiteSearchGroup {
  const SiteSearchGroup({required this.title, required this.routes});

  final String title;
  final List<SearchRoute> routes;
}

String _sectionLabel(SiteSection section) => switch (section) {
  SiteSection.home => 'Home',
  SiteSection.docs => 'Documentation',
  SiteSection.components => 'Components',
  SiteSection.skills => 'Skills',
};

double _searchScore(SearchRoute route, String query) => elCommandScore(
  route.title,
  query,
  <String>[route.path, route.description, ...route.keywords],
);

/// Returns grouped search results for [query].
///
/// Empty queries surface a curated quick-open set. Non-empty queries search the
/// full registry, then group by public section so the command palette can stay
/// scannable.
List<SiteSearchGroup> siteSearchGroups(String query) {
  final String needle = query.trim();
  if (needle.isEmpty) {
    return <SiteSearchGroup>[
      SiteSearchGroup(title: 'Quick open', routes: siteQuickSearchRoutes),
    ];
  }

  final List<SearchRoute> filtered = searchSiteRoutes(needle);
  if (filtered.isEmpty) return const <SiteSearchGroup>[];

  final Map<SiteSection, List<({SearchRoute route, double score})>> bySection =
      <SiteSection, List<({SearchRoute route, double score})>>{};

  for (final SearchRoute route in filtered) {
    final double score = _searchScore(route, needle);
    if (score <= 0) continue;
    bySection
        .putIfAbsent(
          route.section,
          () => <({SearchRoute route, double score})>[],
        )
        .add((route: route, score: score));
  }

  final List<SiteSearchGroup> groups = <SiteSearchGroup>[];
  for (final SiteSection section in SiteSection.values) {
    final List<({SearchRoute route, double score})>? scored =
        bySection[section];
    if (scored == null || scored.isEmpty) continue;
    scored.sort((a, b) => b.score.compareTo(a.score));
    groups.add(
      SiteSearchGroup(
        title: _sectionLabel(section),
        routes: <SearchRoute>[
          for (final ({SearchRoute route, double score}) row in scored)
            row.route,
        ],
      ),
    );
  }
  return List<SiteSearchGroup>.unmodifiable(groups);
}
