/// Public documentation metadata for installable Shots.
///
/// A Shot is a product-neutral application composition assembled from stable
/// registry components. This catalog is the single source of truth for slugs,
/// routes, CLI commands, registry dependencies, and installed file lists — the
/// Shots analogue of `components_docs/catalog.dart`.
///
/// Shot *compositions* live in `example/lib/shots/<dir>/`; they are registry
/// payload and are copied into consumer projects. The pages that document them
/// live in `example/lib/shots_docs/` and are never shipped.
library;

/// Surface a Shot is composed for. Drives the catalog filters.
enum ShotPlatform { responsive, desktop, mobile }

/// Grouping used by the catalog filters.
enum ShotFamily { account, authentication, dashboard }

/// Release readiness of a Shot.
enum ShotStatus { stable, preview }

class ShotDocEntry {
  const ShotDocEntry({
    required this.name,
    required this.directory,
    required this.title,
    required this.description,
    required this.platform,
    required this.family,
    required this.status,
    required this.dependencies,
    required this.files,
  });

  /// Kebab-case registry slug, e.g. `settings-profile`.
  final String name;

  /// Snake-case directory under `example/lib/shots/`.
  final String directory;

  final String title;
  final String description;
  final ShotPlatform platform;
  final ShotFamily family;
  final ShotStatus status;

  /// Registry items this Shot declares. Must match the `registryDependencies`
  /// of `registry/shots/<name>.json` — a Wave 2 test asserts the two agree.
  final List<String> dependencies;

  /// File names inside the Shot's directory, in file-tree order.
  final List<String> files;

  String get route => '/shots/$name';
  String get previewRoute => '$route/preview';
  String get command => 'elattar add $name';

  /// Repository-relative source paths, derived so the catalog and the registry
  /// manifests cannot drift on layout.
  List<String> get sourcePaths => <String>[
    for (final String file in files) 'example/lib/shots/$directory/$file',
  ];

  /// Logical install targets. `@app/` keeps application screens out of the
  /// design-system component directory.
  List<String> get logicalTargets => <String>[
    for (final String file in files) '@app/shots/$directory/$file',
  ];
}

const List<ShotDocEntry> shotDocs = <ShotDocEntry>[
  ShotDocEntry(
    name: 'settings-profile',
    directory: 'settings_profile',
    title: 'Settings profile',
    description:
        'An account settings panel with validation, typed selection, and a discard-confirmation flow.',
    platform: ShotPlatform.responsive,
    family: ShotFamily.account,
    status: ShotStatus.stable,
    dependencies: <String>[
      'source-foundation',
      'card',
      'field',
      'input',
      'select',
      'button',
      'alert-dialog',
      'dialog',
      'icon',
      'ds-rule',
    ],
    files: <String>['settings_profile_shot.dart'],
  ),
  ShotDocEntry(
    name: 'sign-in-flow',
    directory: 'sign_in_flow',
    title: 'Sign-in flow',
    description:
        'A centered authentication card with password reveal, submitting state, and a reset-password dialog.',
    platform: ShotPlatform.responsive,
    family: ShotFamily.authentication,
    status: ShotStatus.stable,
    dependencies: <String>[
      'source-foundation',
      'card',
      'field',
      'input',
      'button',
      'dialog',
      'icon',
      'spinner',
      'ds-rule',
    ],
    files: <String>['sign_in_flow_shot.dart'],
  ),
  ShotDocEntry(
    name: 'dashboard-overview',
    directory: 'dashboard_overview',
    title: 'Dashboard overview',
    description:
        'A metrics overview with a range picker, responsive stat tiles, and a row-detail drill-in.',
    platform: ShotPlatform.responsive,
    family: ShotFamily.dashboard,
    status: ShotStatus.stable,
    dependencies: <String>[
      'source-foundation',
      'card',
      'button',
      'select',
      'icon',
      'tooltip',
      'dialog',
    ],
    files: <String>['dashboard_overview_shot.dart'],
  ),
];

ShotDocEntry? shotDocForRoute(String route) {
  for (final ShotDocEntry entry in shotDocs) {
    if (entry.route == route) return entry;
  }
  return null;
}

ShotDocEntry? shotDocForPreviewRoute(String route) {
  for (final ShotDocEntry entry in shotDocs) {
    if (entry.previewRoute == route) return entry;
  }
  return null;
}

ShotDocEntry shotDoc(String name) =>
    shotDocs.singleWhere((ShotDocEntry entry) => entry.name == name);
