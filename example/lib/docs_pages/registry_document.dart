/// The registry, as facts read from the shipped registry.
///
/// Every number the Registry page shows comes from here, and everything here
/// comes from `registry/generated/latest/`. Nothing is transcribed. The page
/// this feeds is the one place a reader looks to find out how big the
/// registry is, and a hand-written "99 items" would be wrong the first time
/// somebody adds a component — quietly, and on the page that exists to be
/// authoritative.
///
/// The two generated files are read *and cross-checked*. `index.json` and
/// `registry.json` are two views of one catalog, and a release that shipped
/// them disagreeing would be a real defect: the CLI resolves through the
/// index and installs through the catalog, so a reader told "99 items" by one
/// and served 98 by the other has been misled by exactly the file that was
/// supposed to prevent it. A mismatch is surfaced as an error the page can
/// render, not swallowed.
library;

import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, ByteData, rootBundle;

/// The two generated files, reached through the package that owns them.
///
/// `registry/generated/latest/` sits above `example/`, and an asset path may
/// not climb above its own project root, so the docs app cannot declare these.
/// The package can: they are inside `elattar_design_system`'s root, and a
/// package's assets are bundled into every dependent app under
/// `packages/<name>/<path>` — the same mechanism the skill sources and the
/// orb's perlin field already use.
const String registryCatalogAsset =
    'packages/elattar_design_system/registry/generated/latest/registry.json';

/// The lighter of the two: name, type, version and route per item.
const String registryIndexAsset =
    'packages/elattar_design_system/registry/generated/latest/index.json';

/// Raised when the bundled registry cannot be read as one.
///
/// Carries a sentence a reader can act on rather than a decoder's own
/// message, because this one reaches the screen.
class RegistryDocumentException implements Exception {
  const RegistryDocumentException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// How many items of each kind the registry ships.
class RegistryKindCount {
  const RegistryKindCount(this.kind, this.count);

  /// `component`, `effect`, `motion`, `foundation`.
  final String kind;
  final int count;
}

/// Where a kind of file installs in a consumer project.
class RegistryTargetCount {
  const RegistryTargetCount(this.prefix, this.count, this.destination);

  /// The logical prefix a manifest writes, e.g. `@ui/`.
  final String prefix;
  final int count;

  /// Where the installer puts it, project-relative.
  final String destination;
}

/// Everything the page states, measured.
class RegistrySnapshot {
  const RegistrySnapshot({
    required this.schemaVersion,
    required this.registryVersion,
    required this.itemCount,
    required this.kinds,
    required this.targets,
    required this.dependencyEdges,
    required this.semanticEdges,
    required this.distributedFiles,
    required this.itemsWithLicenses,
    required this.deprecatedCount,
  });

  final int schemaVersion;
  final String registryVersion;
  final int itemCount;

  /// Item counts by kind, largest first.
  final List<RegistryKindCount> kinds;

  /// Install-target counts by logical prefix, largest first.
  final List<RegistryTargetCount> targets;

  /// Every `registryDependencies` entry across every item — the edges the CLI
  /// walks when it resolves one name into an install set.
  final int dependencyEdges;

  /// Every `semanticDependencies` entry. A subset of the above: the ones a
  /// component genuinely uses, as opposed to the ones it merely needs
  /// installed.
  final int semanticEdges;

  /// Files, assets, fonts, shaders and notices the registry distributes.
  final int distributedFiles;

  /// How many items carry a third-party notice that installs with them.
  final int itemsWithLicenses;

  final int deprecatedCount;
}

/// Reads a snapshot. Injected so widget tests never touch a bundle.
typedef RegistrySnapshotLoader = Future<RegistrySnapshot> Function();

/// The default loader: the bundled generated registry.
Future<RegistrySnapshot> loadBundledRegistrySnapshot({
  AssetBundle? bundle,
}) async {
  final AssetBundle source = bundle ?? rootBundle;
  final String catalog;
  final String index;
  try {
    // `load` plus an explicit decode rather than `loadString`.
    // `AssetBundle.loadString` hands anything over 50 KB to `compute`, and
    // the isolate that spawns never completes under `flutter_test`'s
    // binding — `registry.json` is ~105 KB, so the page's own loader was
    // untestable and hung for ten minutes instead of failing. Decoding here
    // also drops an isolate hop from a read that happens once per page.
    catalog = await _loadUtf8(source, registryCatalogAsset);
    index = await _loadUtf8(source, registryIndexAsset);
  } catch (error) {
    throw const RegistryDocumentException(
      'The generated registry is not in this build. It is declared as a '
      'package asset in the root pubspec.yaml; a build that omits it cannot '
      'show these figures.',
    );
  }
  return parseRegistrySnapshot(catalogJson: catalog, indexJson: index);
}

Future<String> _loadUtf8(AssetBundle bundle, String key) async {
  final ByteData data = await bundle.load(key);
  return utf8.decode(
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
  );
}

/// Parses and cross-checks the two generated files.
RegistrySnapshot parseRegistrySnapshot({
  required String catalogJson,
  required String indexJson,
}) {
  final Map<String, Object?> catalog = _object(catalogJson, 'registry.json');
  final Map<String, Object?> index = _object(indexJson, 'index.json');

  final int schemaVersion = _int(catalog['schemaVersion'], 'schemaVersion');
  final String registryVersion = _string(
    catalog['registryVersion'],
    'registryVersion',
  );
  final List<Object?> items = _list(catalog['items'], 'registry.json items');
  final List<Object?> indexItems = _list(index['items'], 'index.json items');

  // The cross-check. Cheap, and it is the difference between a page that
  // reports the registry and a page that reports one file's opinion of it.
  if (items.length != indexItems.length) {
    throw RegistryDocumentException(
      'The generated registry disagrees with itself: registry.json lists '
      '${items.length} items and index.json lists ${indexItems.length}. '
      'Rebuild it with tool/registry_builder.',
    );
  }
  if (index['registryVersion'] != registryVersion) {
    throw RegistryDocumentException(
      'The generated registry disagrees with itself: registry.json is '
      'version $registryVersion and index.json is '
      '${index['registryVersion']}. Rebuild it with tool/registry_builder.',
    );
  }

  final Map<String, int> kinds = <String, int>{};
  final Map<String, int> targets = <String, int>{};
  int dependencyEdges = 0;
  int semanticEdges = 0;
  int distributedFiles = 0;
  int itemsWithLicenses = 0;
  int deprecated = 0;

  for (final Object? raw in items) {
    final Map<String, Object?> item = _map(raw, 'an item');
    kinds.update(
      _string(item['type'], 'item type'),
      (int value) => value + 1,
      ifAbsent: () => 1,
    );
    dependencyEdges += _list(
      item['registryDependencies'],
      'registryDependencies',
    ).length;
    semanticEdges += _list(
      item['semanticDependencies'],
      'semanticDependencies',
    ).length;
    if (item['deprecated'] == true) deprecated++;

    final List<Object?> licenses = _optionalList(item['licenses']);
    if (licenses.isNotEmpty) itemsWithLicenses++;

    for (final String group in const <String>[
      'files',
      'assets',
      'fonts',
      'shaders',
      'licenses',
    ]) {
      final List<Object?> entries = group == 'licenses'
          ? licenses
          : _list(item[group], group);
      distributedFiles += entries.length;
      for (final Object? entry in entries) {
        final String target = _string(
          _map(entry, '$group entry')['target'],
          'target',
        );
        final int slash = target.indexOf('/');
        if (slash <= 0) continue;
        targets.update(
          target.substring(0, slash + 1),
          (int value) => value + 1,
          ifAbsent: () => 1,
        );
      }
    }
  }

  return RegistrySnapshot(
    schemaVersion: schemaVersion,
    registryVersion: registryVersion,
    itemCount: items.length,
    kinds: _sortedKinds(kinds),
    targets: _sortedTargets(targets),
    dependencyEdges: dependencyEdges,
    semanticEdges: semanticEdges,
    distributedFiles: distributedFiles,
    itemsWithLicenses: itemsWithLicenses,
    deprecatedCount: deprecated,
  );
}

/// Where each logical prefix lands. Kept beside the counts so the page can
/// answer "and where does that go" without a second lookup table.
///
/// These mirror `packages/elattar_cli/lib/src/install/target_mapper.dart`. A
/// prefix the registry uses and this map does not know is shown by its
/// prefix alone rather than guessed at.
const Map<String, String> registryTargetDestinations = <String, String>{
  '@ui/': 'lib/components/ui/',
  '@foundation/': 'lib/design_system/foundation/',
  '@effects/': 'lib/design_system/effects/',
  '@motion/': 'lib/design_system/motion/',
  '@assets/': 'assets/',
  '@shaders/': 'shaders/',
  '@app/': 'lib/',
  '@license/': 'LICENSES/',
};

List<RegistryKindCount> _sortedKinds(Map<String, int> counts) {
  final List<MapEntry<String, int>> entries = counts.entries.toList()
    ..sort((MapEntry<String, int> a, MapEntry<String, int> b) {
      final int byCount = b.value.compareTo(a.value);
      return byCount != 0 ? byCount : a.key.compareTo(b.key);
    });
  return <RegistryKindCount>[
    for (final MapEntry<String, int> entry in entries)
      RegistryKindCount(entry.key, entry.value),
  ];
}

List<RegistryTargetCount> _sortedTargets(Map<String, int> counts) {
  final List<MapEntry<String, int>> entries = counts.entries.toList()
    ..sort((MapEntry<String, int> a, MapEntry<String, int> b) {
      final int byCount = b.value.compareTo(a.value);
      return byCount != 0 ? byCount : a.key.compareTo(b.key);
    });
  return <RegistryTargetCount>[
    for (final MapEntry<String, int> entry in entries)
      RegistryTargetCount(
        entry.key,
        entry.value,
        registryTargetDestinations[entry.key] ?? '',
      ),
  ];
}

Map<String, Object?> _object(String source, String what) {
  final Object? decoded;
  try {
    decoded = jsonDecode(source);
  } on FormatException catch (error) {
    throw RegistryDocumentException(
      'The bundled $what is not valid JSON: ${error.message}',
    );
  }
  return _map(decoded, what);
}

Map<String, Object?> _map(Object? value, String what) {
  if (value is Map<String, Object?>) return value;
  throw RegistryDocumentException('The bundled $what is not an object.');
}

List<Object?> _list(Object? value, String what) {
  if (value is List<Object?>) return value;
  throw RegistryDocumentException('The bundled registry has no $what.');
}

/// `licenses` is optional in schema v1: most items redistribute nothing.
List<Object?> _optionalList(Object? value) =>
    value is List<Object?> ? value : const <Object?>[];

int _int(Object? value, String what) {
  if (value is int) return value;
  throw RegistryDocumentException('The bundled registry has no $what.');
}

String _string(Object? value, String what) {
  if (value is String && value.isNotEmpty) return value;
  throw RegistryDocumentException('The bundled registry has no $what.');
}
