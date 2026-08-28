/// Public website routes and searchable route metadata.
///
/// This registry intentionally sits beside, rather than inside, [nav.dart].
/// The existing design-system tree is a compatibility contract for the docs
/// shell; public destinations are a separate layer over that tree.
library;

import '../nav.dart';
import '../components_docs/catalog.dart';
import '../docs_pages/catalog.dart'
    show
        docsChangelogRoute,
        docsCliRoute,
        docsInstallationRoute,
        docsIntroductionRoute,
        docsRegistryRoute,
        docsThemingRoute,
        docsTypesetRoute;
import '../skills_docs/catalog.dart';

/// The top-level destinations exposed by the public website.
enum SiteSection { home, docs, components, skills }

/// A public website destination.
class SiteRoute {
  const SiteRoute({
    required this.path,
    required this.section,
    required this.title,
    required this.description,
    this.keywords = const <String>[],
    this.showInSidebar = true,
  });

  final String path;
  final SiteSection section;
  final String title;
  final String description;
  final List<String> keywords;

  /// Whether the documentation shell's "Sections" rail
  /// (`docs/docs_layout.dart`'s `_defaultSidebarGroups`) lists this
  /// destination. Defaults to `true`; only [docsRoute] sets it to `false`, so
  /// `/docs` stays a resolvable route, including for quick search, without
  /// also appearing as a sidebar entry above the six sub-pages it groups.
  final bool showInSidebar;
}

/// A searchable destination, including the existing design-system routes.
///
/// [groupId] and [slug] are populated only for entries sourced from
/// [elGroups]. They let search results link back to the existing docs pages
/// without duplicating or changing that registry.
class SearchRoute {
  const SearchRoute({
    required this.path,
    required this.title,
    required this.description,
    required this.section,
    this.keywords = const <String>[],
    this.groupId,
    this.slug,
  });

  final String path;
  final String title;
  final String description;
  final SiteSection section;
  final List<String> keywords;
  final String? groupId;
  final String? slug;

  bool get isDesignSystemRoute => groupId != null;
}

const String homeRoute = '/';
const String docsRoute = '/docs';
const String componentsRoute = '/components';
const String skillsRoute = '/skills';

/// Public website destinations, in header/navigation order.
///
/// All seven `docs_pages/` articles are wired in here:
/// [docsIntroductionRoute], [docsInstallationRoute], [docsThemingRoute],
/// [docsCliRoute], [docsTypesetRoute], [docsRegistryRoute] and
/// [docsChangelogRoute]. They reach
/// both the header/footer navigation (`site_navigation.dart`'s
/// `primarySiteNavigation`) and the documentation shell's "Sections" rail
/// (`docs/docs_layout.dart`'s `_defaultSidebarGroups`, which reads this list
/// directly and is not modified here). Their position below is deliberate:
/// interleaved with the existing [docsRoute], [componentsRoute] and
/// [skillsRoute] entries so that, read in order and skipping [docsRoute]
/// (see [SiteRoute.showInSidebar]), they reproduce the reference "Sections"
/// order exactly: Introduction, Components, Installation, Theming, CLI,
/// Typeset, Registry, Changelog, Skills. [docsRoute] ("Documentation") is left in [siteRoutes] rather than
/// removed or renamed: dropping it would silently break
/// `site_navigation.dart`'s eagerly evaluated `siteQuickSearchRoutes`
/// (`searchRouteByPath(docsRoute)` throws for an unresolvable path) and
/// `site_shell_test.dart`'s quick-open assertion, neither of which this
/// change is meant to touch. It is excluded from the sidebar's "Sections"
/// group alone, via [SiteRoute.showInSidebar]: `false` for this one entry,
/// `true` (the default) for every other entry below.
const List<SiteRoute> siteRoutes = <SiteRoute>[
  SiteRoute(
    path: homeRoute,
    section: SiteSection.home,
    title: 'Home',
    description: 'Elattar Design System for Flutter.',
    keywords: <String>['elattar', 'flutter', 'design system'],
  ),
  SiteRoute(
    path: docsRoute,
    section: SiteSection.docs,
    title: 'Documentation',
    description: 'Learn the foundations, components, and installation flow.',
    keywords: <String>['docs', 'documentation', 'guide', 'install'],
    showInSidebar: false,
  ),
  SiteRoute(
    path: docsIntroductionRoute,
    section: SiteSection.docs,
    title: 'Introduction',
    description:
        'What Elattar is, who it is for, and how owning generated source '
        'differs from depending on a package.',
    keywords: <String>['introduction', 'overview', 'getting started'],
  ),
  SiteRoute(
    path: componentsRoute,
    section: SiteSection.components,
    title: 'Components',
    description: 'Browse every component and copy it into your Flutter app.',
    keywords: <String>['widgets', 'ui', 'components', 'copy'],
  ),
  SiteRoute(
    path: docsInstallationRoute,
    section: SiteSection.docs,
    title: 'Installation',
    description:
        'The real, working steps to get the foundation and components into '
        'a Flutter project today.',
    keywords: <String>['install', 'installation', 'setup', 'foundation'],
  ),
  SiteRoute(
    path: docsThemingRoute,
    section: SiteSection.docs,
    title: 'Theming',
    description:
        'Semantic tokens, ThemeController, light and dark resolution, and '
        'how a consumer overrides them.',
    keywords: <String>['theming', 'theme', 'tokens', 'dark mode', 'colors'],
  ),
  SiteRoute(
    path: docsCliRoute,
    section: SiteSection.docs,
    title: 'CLI',
    description:
        'The elattar command surface: init, add, list, search, info, and '
        'doctor, with exit codes and workflows.',
    keywords: <String>['cli', 'command line', 'elattar', 'commands'],
  ),
  SiteRoute(
    path: docsTypesetRoute,
    section: SiteSection.docs,
    title: 'Typeset',
    description:
        'The TextStyles scale, TextStyleToken anatomy, the fluid clamps, and the '
        'three font families.',
    keywords: <String>[
      'typeset',
      'typography',
      'type',
      'font',
      'fonts',
      'text',
      'scale',
    ],
  ),
  SiteRoute(
    path: docsRegistryRoute,
    section: SiteSection.docs,
    title: 'Registry',
    description:
        'Schema v1, what a registry item is, how dependencies resolve, and '
        'what the published registry contains.',
    keywords: <String>[
      'registry',
      'schema',
      'items',
      'dependencies',
      'hashes',
      'offline',
      'cache',
    ],
  ),
  SiteRoute(
    path: docsChangelogRoute,
    section: SiteSection.docs,
    title: 'Changelog',
    description:
        'Every release, newest first, rendered from the CHANGELOG.md at the '
        'root of this repository.',
    keywords: <String>['changelog', 'releases', 'history', 'versions'],
  ),
  SiteRoute(
    path: skillsRoute,
    section: SiteSection.skills,
    title: 'Skills',
    description: 'Installable skills for building with Elattar.',
    keywords: <String>['skills', 'agents', 'workflow'],
  ),
];

/// Finds a public route by its exact path. Matching is deliberately
/// case-sensitive so malformed deep links do not silently resolve elsewhere.
///
/// Component guides are **synthesized** rather than listed in [siteRoutes]:
/// the header contract is exactly four destinations, and a guide is a page
/// beneath one of them, not a fifth tab.
SiteRoute? siteRouteFor(String path) {
  for (final SiteRoute route in siteRoutes) {
    if (route.path == path) return route;
  }
  final ComponentDocEntry? component = componentDocForRoute(path);
  if (component != null) {
    return SiteRoute(
      path: component.route,
      section: SiteSection.components,
      title: component.title,
      description: component.description,
      keywords: <String>[component.name, 'component', 'registry', 'cli'],
    );
  }
  return null;
}

/// Finds a public route or throws a descriptive argument error.
SiteRoute requireSiteRoute(String path) {
  final SiteRoute? route = siteRouteFor(path);
  if (route == null) {
    throw ArgumentError.value(path, 'path', 'Unknown public site route');
  }
  return route;
}

/// Builds a relative link that works when the Flutter app is hosted beneath a
/// GitHub Pages project path. The route is encoded as a query value because
/// Flutter Web can recover it from [Uri.base] without server-side rewrites.
String githubPagesHref(String route, {String basePath = ''}) {
  if (route.isEmpty || !route.startsWith('/')) {
    throw ArgumentError.value(route, 'route', 'Expected an absolute route');
  }

  String base = basePath.trim();
  if (base == '/') base = '';
  if (base.isNotEmpty && !base.startsWith('/')) base = '/$base';
  if (base.isNotEmpty && !base.endsWith('/')) base = '$base/';

  return '$base?route=${Uri.encodeQueryComponent(route)}';
}

/// Search keywords for a top-level destination, including anything the catalog
/// that owns the destination's content contributes.
///
/// A component guide owns a route of its own (`/components/<name>`), so it is
/// indexed below as its own [SearchRoute]. A Skill does not: [SkillDocEntry.route]
/// is the literal
/// `/skills` — there is one skill, and no index/detail split to model — so
/// indexing it separately would put two rows with the same path in the results
/// and make the search box answer "skills" twice.
///
/// Its topics are folded into the `/skills` destination instead, which is what
/// the IA plan's "Skill topics" requirement actually asks for: the reference
/// titles are the topics a reader would search by ("system map", "traps",
/// "verify", "state & accessibility"), alongside the skill's own name, the
/// agents it is verified against, and the ids of its install routes.
List<String> _searchKeywordsFor(SiteRoute route) {
  if (route.section != SiteSection.skills) return route.keywords;
  return List<String>.unmodifiable(<String>[
    ...route.keywords,
    for (final SkillDocEntry skill in skillDocs) ...<String>[
      skill.slug,
      skill.title.toLowerCase(),
      for (final String agent in skill.supportedAgents) agent.toLowerCase(),
      for (final SkillReferenceFile file in skill.referenceFiles)
        file.title.toLowerCase(),
      for (final SkillInstallRoute install in skill.installRoutes) install.id,
    ],
  ]);
}

/// Immutable search index containing public destinations followed by all
/// existing design-system groups and categories.
final List<SearchRoute> searchableRoutes = List<SearchRoute>.unmodifiable(
  <SearchRoute>[
    for (final SiteRoute route in siteRoutes)
      SearchRoute(
        path: route.path,
        title: route.title,
        description: route.description,
        section: route.section,
        keywords: _searchKeywordsFor(route),
      ),
    for (final ComponentDocEntry component in componentDocs)
      SearchRoute(
        path: component.route,
        title: component.title,
        description: component.description,
        section: SiteSection.components,
        keywords: List<String>.unmodifiable(<String>[
          component.name,
          'component',
          'registry',
          'cli',
          ...component.exports,
        ]),
      ),
    for (final Group group in elGroups)
      SearchRoute(
        path: group.href,
        title: group.title,
        description: group.blurb,
        section: SiteSection.docs,
        keywords: List<String>.unmodifiable(<String>[
          group.id,
          'design system',
        ]),
        groupId: group.id,
      ),
    for (final Group group in elGroups)
      for (final Category category in group.categories)
        SearchRoute(
          path: categoryHref(group, category),
          title: category.title,
          description: category.blurb,
          section: SiteSection.docs,
          keywords: List<String>.unmodifiable(<String>[
            group.id,
            ...category.contents,
          ]),
          groupId: group.id,
          slug: category.slug,
        ),
  ],
);

/// Case-insensitive substring search over titles, descriptions, paths, and
/// keywords. Results retain registry order for stable navigation and tests.
List<SearchRoute> searchSiteRoutes(String query) {
  final String needle = query.trim().toLowerCase();
  if (needle.isEmpty) return searchableRoutes;

  return List<SearchRoute>.unmodifiable(
    searchableRoutes.where((SearchRoute route) {
      final Iterable<String> fields = <String>[
        route.path,
        route.title,
        route.description,
        ...route.keywords,
      ];
      return fields.any((String field) => field.toLowerCase().contains(needle));
    }),
  );
}
