/// Metadata for the seven public documentation pages this directory owns.
///
/// Mirrors `../components_docs/catalog.dart`: one small, dependency-free
/// entry per route, read by `../site/site_routes.dart`
/// (`siteRouteFor`, `searchableRoutes`) and by `../main.dart`
/// (`publicPageFor`'s builder map) so the route table has exactly one source
/// of truth.
///
/// `Components` (`/components`) and `Skills` (`/skills`) are the other two
/// entries of the reference "Sections" group (see
/// `docs/superpowers/plans/2026-08-21-public-website-ui-information-architecture.md`
/// section 7.3). They already resolve through `../components_docs/catalog.dart`
/// and `../skills_docs/catalog.dart` respectively and are deliberately absent
/// from this list. This file owns only the seven routes that did not exist
/// before it.
library;

/// One documentation page's route metadata.
class DocsPageEntry {
  const DocsPageEntry({
    required this.slug,
    required this.title,
    required this.description,
    required this.route,
  });

  /// The bare identifier, e.g. `introduction`. Matches the trailing route
  /// segment (`route == '/docs/$slug'`), asserted by
  /// `example/test/site_routes_test.dart`.
  final String slug;

  final String title;

  /// One sentence, used as the search result description and the
  /// [SiteRoute] description `siteRouteFor` synthesizes for this route.
  final String description;

  final String route;
}

const String docsIntroductionRoute = '/docs/introduction';
const String docsInstallationRoute = '/docs/installation';
const String docsThemingRoute = '/docs/theming';
const String docsCliRoute = '/docs/cli';
const String docsTypesetRoute = '/docs/typeset';
const String docsRegistryRoute = '/docs/registry';
const String docsChangelogRoute = '/docs/changelog';

/// In reading order, the same order as the reference "Sections" group,
/// minus Components and Skills (see the library note). Each page's
/// `previous`/`next` pager follows this order, interleaving the two routes
/// this file does not own by their literal path.
const List<DocsPageEntry> docsPageEntries = <DocsPageEntry>[
  DocsPageEntry(
    slug: 'introduction',
    title: 'Introduction',
    description:
        'What Elattar is, who it is for, and how owning generated source '
        'differs from depending on a package.',
    route: docsIntroductionRoute,
  ),
  DocsPageEntry(
    slug: 'installation',
    title: 'Installation',
    description:
        'The real, working steps to get the foundation and components into '
        'a Flutter project today.',
    route: docsInstallationRoute,
  ),
  DocsPageEntry(
    slug: 'theming',
    title: 'Theming',
    description:
        'Semantic tokens, ElThemeController, light and dark resolution, and '
        'how a consumer overrides them.',
    route: docsThemingRoute,
  ),
  DocsPageEntry(
    slug: 'cli',
    title: 'CLI',
    description:
        'The elattar command surface: init, add, list, search, info, and '
        'doctor, with exit codes and workflows.',
    route: docsCliRoute,
  ),
  DocsPageEntry(
    slug: 'typeset',
    title: 'Typeset',
    description:
        'The ElType scale, ElTypeSpec anatomy, the fluid clamps, and the '
        'three font families.',
    route: docsTypesetRoute,
  ),
  DocsPageEntry(
    slug: 'registry',
    title: 'Registry',
    description:
        'Schema v1, what a registry item is, how dependencies resolve, and '
        'the 99 items generated today.',
    route: docsRegistryRoute,
  ),
  DocsPageEntry(
    slug: 'changelog',
    title: 'Changelog',
    description:
        'Where the real, authoritative CHANGELOG.md lives and how this '
        'repository versions its parts.',
    route: docsChangelogRoute,
  ),
];

/// Finds an entry by its exact route, or null. Mirrors
/// `componentDocForRoute`'s linear-scan shape. The list is seven items long,
/// so an index is not worth the second data structure.
DocsPageEntry? docsPageEntryForRoute(String route) {
  for (final DocsPageEntry entry in docsPageEntries) {
    if (entry.route == route) return entry;
  }
  return null;
}
