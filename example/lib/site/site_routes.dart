/// Public website routes and searchable route metadata.
///
/// This registry intentionally sits beside, rather than inside, [nav.dart].
/// The existing design-system tree is a compatibility contract for the docs
/// shell; public destinations are a separate layer over that tree.
library;

import '../nav.dart';
import '../components_docs/catalog.dart';
import '../shots_docs/catalog.dart';
import '../skills_docs/catalog.dart';

/// The top-level destinations exposed by the public website.
enum SiteSection { home, docs, components, shots, skills }

/// A public website destination.
class SiteRoute {
  const SiteRoute({
    required this.path,
    required this.section,
    required this.title,
    required this.description,
    this.keywords = const <String>[],
  });

  final String path;
  final SiteSection section;
  final String title;
  final String description;
  final List<String> keywords;
}

/// A searchable destination, including the existing design-system routes.
///
/// [groupId] and [slug] are populated only for entries sourced from
/// [dsGroups]. They let search results link back to the existing docs pages
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
const String shotsRoute = '/shots';
const String skillsRoute = '/skills';

/// Public website destinations, in header/navigation order.
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
  ),
  SiteRoute(
    path: componentsRoute,
    section: SiteSection.components,
    title: 'Components',
    description: 'Browse every component and copy it into your Flutter app.',
    keywords: <String>['widgets', 'ui', 'components', 'copy'],
  ),
  SiteRoute(
    path: shotsRoute,
    section: SiteSection.shots,
    title: 'Shots',
    description: 'Composed screens built from the design system.',
    keywords: <String>['screens', 'examples', 'compositions'],
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
/// Component and Shot guides are **synthesized** rather than listed in
/// [siteRoutes]: the header contract is exactly five destinations, and a guide
/// is a page beneath one of them, not a sixth tab.
///
/// A Shot's chrome-free preview route (`/shots/<slug>/preview`) deliberately
/// resolves to null here. It is not a site destination — it carries no header,
/// footer or search — and `main.dart` answers it above this guard.
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
  final ShotDocEntry? shot = shotDocForRoute(path);
  if (shot != null) {
    return SiteRoute(
      path: shot.route,
      section: SiteSection.shots,
      title: shot.title,
      description: shot.description,
      keywords: <String>[shot.name, 'shot', 'screen', 'registry', 'cli'],
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
/// A component guide and a Shot guide each own a route of their own
/// (`/components/<name>`, `/shots/<slug>`), so each is indexed below as its own
/// [SearchRoute]. A Skill does not: [SkillDocEntry.route] is the literal
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
    for (final ShotDocEntry shot in shotDocs)
      SearchRoute(
        path: shot.route,
        title: shot.title,
        description: shot.description,
        section: SiteSection.shots,
        keywords: List<String>.unmodifiable(<String>[
          shot.name,
          'shot',
          'screen',
          'registry',
          'cli',
          shot.family.name,
          shot.platform.name,
          ...shot.dependencies,
        ]),
      ),
    for (final DsGroup group in dsGroups)
      SearchRoute(
        path: group.href,
        title: group.title,
        description: group.blurb,
        section: SiteSection.docs,
        keywords: List<String>.unmodifiable(<String>[group.id, 'design system']),
        groupId: group.id,
      ),
    for (final DsGroup group in dsGroups)
      for (final DsCategory category in group.categories)
        SearchRoute(
          path: categoryHref(group, category),
          title: category.title,
          description: category.blurb,
          section: SiteSection.docs,
          keywords: List<String>.unmodifiable(<String>[group.id, ...category.contents]),
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
