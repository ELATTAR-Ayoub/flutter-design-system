library;

import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

import '../config.dart';
import '../identity.dart';
import '../license_notice.dart';
import '../install/installer.dart';
import '../install/models.dart';
import '../install/target_mapper.dart';
import '../manifest.dart';
import '../project.dart';
import '../registry/client.dart';
import '../registry/models.dart';

const LogicalTargetMapper _targetMapper = LogicalTargetMapper();

/// Why `--foundation package` is refused rather than merely undocumented.
///
/// The mode wrote `elattar_core: ^0.0.1` into the consumer pubspec and
/// rewrote foundation imports onto `package:elattar_core/...`. No such package
/// exists on pub.dev or in this repository, so `flutter pub get` failed with
/// exit 69 and the project could not build — and re-running `init --foundation
/// source` did not undo either change, so the mode was a one-way door. It is
/// refused up front until the package exists.
const String packageModeUnavailable =
    'The `package` foundation mode is not available in elattar '
    '${CliIdentity.version}: it depends on a package named `elattar_core` '
    'that does not exist yet, so `flutter pub get` cannot resolve the project '
    'it produces. Use `--foundation source`, which copies the foundation into '
    'your project.';

/// A URI scheme, requiring at least two characters before the colon so a
/// Windows drive letter (`C:\src\registry`) is a path, not a scheme.
final RegExp _uriScheme = RegExp(r'^[A-Za-z][A-Za-z0-9+.-]+:');

class ElattarCli {
  ElattarCli({
    void Function(String line)? stdoutSink,
    void Function(String line)? stderrSink,
  }) : _stdout = stdoutSink ?? _defaultStdout,
       _stderr = stderrSink ?? _defaultStderr;

  final void Function(String line) _stdout;
  final void Function(String line) _stderr;

  Future<int> run(List<String> arguments) async {
    final _ArgCursor cursor = _ArgCursor(arguments);
    if (!cursor.hasNext) {
      _printUsage();
      return 0;
    }
    final String first = cursor.take()!;
    if (first == '--version') {
      _stdout(CliIdentity.version);
      return 0;
    }
    try {
      return switch (first) {
        'init' => await _runInit(cursor),
        'add' => await _runAdd(cursor),
        'list' => await _runList(cursor),
        'search' => await _runSearch(cursor),
        'info' => await _runInfo(cursor),
        'doctor' => await _runDoctor(cursor),
        'help' || '--help' || '-h' => _printUsage(),
        _ => _unknownCommand(first),
      };
    } on FormatException catch (error) {
      _stderr(error.message);
      return 64;
    } on ElattarConfigException catch (error) {
      _stderr(error.message);
      return 78;
    } on ElattarManifestException catch (error) {
      _stderr(error.message);
      return 78;
    } on FlutterProjectNotFound catch (error) {
      _stderr(error.message);
      return 72;
    } on RegistryItemNotFoundException catch (error) {
      _stderr(error.toString());
      return 66;
    } on RegistryDependencyCycleException catch (error) {
      _stderr(error.toString());
      return 65;
    } on RegistryIntegrityException catch (error) {
      _stderr(error.toString());
      return 65;
    } on StateError catch (error) {
      _stderr(error.toString());
      return 1;
    }
  }

  Future<int> _runInit(_ArgCursor cursor) async {
    String foundation = 'source';
    bool dryRun = false;
    String? registryPath;
    while (cursor.hasNext) {
      final String value = cursor.take()!;
      if (value == '--foundation') {
        foundation = cursor.requireValue('--foundation');
      } else if (value == '--dry-run') {
        dryRun = true;
      } else if (value == '--yes') {
        continue;
      } else if (value == '--registry') {
        registryPath = cursor.requireValue('--registry');
      } else {
        throw FormatException('Unknown init option: $value');
      }
    }
    // Refused before the project is even discovered, so a refused init leaves
    // nothing behind: no pubspec edit, no elattar.yaml, no manifest.
    if (foundation == 'package') {
      throw const FormatException(packageModeUnavailable);
    }
    if (foundation != 'source') {
      throw const FormatException('init --foundation must be source.');
    }
    final FlutterProject project = discoverFlutterProject();
    final Directory registryDirectory = _discoverRegistryDirectory(
      registryPath,
    );
    final _RegistryContext registry = _RegistryContext.fromLatestDirectory(
      registryDirectory,
    );
    final ElattarConfig config = _configFor(
      project: project,
      registryDirectory: registryDirectory,
    );
    final List<RegistryItem> resolved = await registry.client.resolve(<String>[
      'source-foundation',
    ]);

    final _MutationResult mutation = _planMutation(
      project: project,
      registry: registry,
      config: config,
      resolvedItems: resolved,
      overwrite: false,
      dryRun: dryRun,
    );
    _printMutationSummary(action: 'init', result: mutation, dryRun: dryRun);
    if (config.registry == null && mutation.conflicts.isEmpty) {
      _stdout(
        'note: the registry is outside this project, so elattar.yaml pins no '
        '`registry:` value. Pass --registry ${registryDirectory.path} to '
        '`elattar add`.',
      );
    }
    return mutation.exitCode;
  }

  Future<int> _runAdd(_ArgCursor cursor) async {
    bool overwrite = false;
    bool dryRun = false;
    bool addAll = false;
    String? registryPath;
    final List<String> names = <String>[];
    while (cursor.hasNext) {
      final String value = cursor.take()!;
      if (value == '--overwrite') {
        overwrite = true;
      } else if (value == '--dry-run') {
        dryRun = true;
      } else if (value == '--all') {
        addAll = true;
      } else if (value == '--registry') {
        registryPath = cursor.requireValue('--registry');
      } else {
        if (value.startsWith('--')) {
          throw FormatException('Unknown add option: $value');
        }
        names.add(value);
      }
    }
    final FlutterProject project = discoverFlutterProject();
    final File configFile = File(_join(project.root.path, 'elattar.yaml'));
    if (!configFile.existsSync()) {
      throw const ElattarConfigException(
        'Missing elattar.yaml. Run `elattar init` first.',
      );
    }
    final ElattarConfig config = ElattarConfig.fromYaml(
      configFile.readAsStringSync(),
    );
    if (config.foundation == FoundationMode.package) {
      throw const ElattarConfigException(
        'elattar.yaml sets `foundation: package`. $packageModeUnavailable '
        'Set `foundation: source` in elattar.yaml and run `elattar init` '
        'again.',
      );
    }
    final Directory registryDirectory = registryPath == null
        ? _discoverRegistryDirectory(config.registry)
        : _discoverRegistryDirectory(registryPath);
    final _RegistryContext registry = _RegistryContext.fromLatestDirectory(
      registryDirectory,
    );
    final List<String> requestedNames = await _resolvedAddNames(
      registry: registry,
      names: names,
      addAll: addAll,
    );
    final File manifestFile = _manifestFile(project.root);
    if (!manifestFile.existsSync()) {
      throw const ElattarManifestException(
        'Missing .elattar/manifest.json. Run `elattar init` first.',
      );
    }
    final ElattarManifest manifest = ElattarManifest.load(manifestFile);
    config.validateAgainst(manifest);

    final List<RegistryItem> resolved = await registry.client.resolve(
      requestedNames,
    );
    final _MutationResult mutation = _planMutation(
      project: project,
      registry: registry,
      config: config,
      resolvedItems: resolved,
      overwrite: overwrite,
      dryRun: dryRun,
    );
    _printMutationSummary(action: 'add', result: mutation, dryRun: dryRun);
    return mutation.exitCode;
  }

  Future<int> _runList(_ArgCursor cursor) async {
    String? registryPath;
    while (cursor.hasNext) {
      final String value = cursor.take()!;
      if (value == '--registry') {
        registryPath = cursor.requireValue('--registry');
      } else {
        throw FormatException('Unknown list option: $value');
      }
    }
    final RegistryClient client = _RegistryContext.fromLatestDirectory(
      _discoverRegistryDirectory(registryPath),
    ).client;
    final List<RegistryItem> items = await client.list();
    for (final RegistryItem item in items) {
      _stdout('${item.name}\t${item.type.name}\t${item.version}');
    }
    return 0;
  }

  Future<int> _runSearch(_ArgCursor cursor) async {
    String? registryPath;
    final List<String> query = <String>[];
    while (cursor.hasNext) {
      final String value = cursor.take()!;
      if (value == '--registry') {
        registryPath = cursor.requireValue('--registry');
      } else {
        if (value.startsWith('--')) {
          throw FormatException('Unknown search option: $value');
        }
        query.add(value);
      }
    }
    if (query.isEmpty) {
      throw const FormatException('search requires a query.');
    }
    final RegistryClient client = _RegistryContext.fromLatestDirectory(
      _discoverRegistryDirectory(registryPath),
    ).client;
    final List<RegistrySearchResult> results = await client.search(
      query.join(' '),
    );
    for (final RegistrySearchResult result in results) {
      _stdout(
        '${result.item.name}\t${result.item.type.name}\t${result.item.description}',
      );
    }
    return 0;
  }

  Future<int> _runInfo(_ArgCursor cursor) async {
    String? registryPath;
    String? name;
    while (cursor.hasNext) {
      final String value = cursor.take()!;
      if (value == '--registry') {
        registryPath = cursor.requireValue('--registry');
      } else {
        if (value.startsWith('--')) {
          throw FormatException('Unknown info option: $value');
        }
        name ??= value;
      }
    }
    if (name == null) {
      throw const FormatException('info requires an item name.');
    }
    final RegistryClient client = _RegistryContext.fromLatestDirectory(
      _discoverRegistryDirectory(registryPath),
    ).client;
    final RegistryItem item = await client.info(name);
    _stdout(
      const JsonEncoder.withIndent('  ').convert(<String, Object?>{
        'name': item.name,
        'type': item.type.name,
        'version': item.version,
        'description': item.description,
        'documentationRoute': item.documentationRoute,
        'sourceLink': item.sourceLink,
        'registryDependencies': item.registryDependencies,
        'semanticDependencies': item.semanticDependencies,
        'pubDependencies': item.pubDependencies,
        'files': <Object?>[
          for (final RegistryFile file in item.files)
            <String, String>{
              'source': file.source,
              'target': file.target,
              'sha256': file.sha256,
            },
        ],
      }),
    );
    return 0;
  }

  Future<int> _runDoctor(_ArgCursor cursor) async {
    String? registryPath;
    while (cursor.hasNext) {
      final String value = cursor.take()!;
      if (value == '--registry') {
        registryPath = cursor.requireValue('--registry');
      } else {
        throw FormatException('Unknown doctor option: $value');
      }
    }
    int issues = 0;
    FlutterProject? project;
    try {
      project = discoverFlutterProject();
      _stdout('ok  flutter project: ${project.root.path}');
    } on FlutterProjectNotFound catch (error) {
      _stderr('err flutter project: ${error.message}');
      issues++;
    }

    if (project != null) {
      final File configFile = File(_join(project.root.path, 'elattar.yaml'));
      if (configFile.existsSync()) {
        try {
          final ElattarConfig config = ElattarConfig.fromYaml(
            configFile.readAsStringSync(),
          );
          if (config.foundation == FoundationMode.package) {
            _stderr('err config: foundation=package. $packageModeUnavailable');
            issues++;
          } else {
            _stdout('ok  config: foundation=${config.foundation.name}');
          }
        } on Object catch (error) {
          _stderr('err config: $error');
          issues++;
        }
      } else {
        _stderr('err config: missing elattar.yaml');
        issues++;
      }

      issues += _checkDependencies(project);

      final File manifestFile = _manifestFile(project.root);
      if (manifestFile.existsSync()) {
        try {
          final ElattarManifest manifest = ElattarManifest.load(manifestFile);
          _stdout(
            'ok  manifest: foundation=${manifest.foundation.name}, items=${manifest.items.length}',
          );
        } on Object catch (error) {
          _stderr('err manifest: $error');
          issues++;
        }
      } else {
        _stderr('err manifest: missing .elattar/manifest.json');
        issues++;
      }
    }

    try {
      final Directory registryDirectory = _discoverRegistryDirectory(
        registryPath,
      );
      final RegistryClient client = _RegistryContext.fromLatestDirectory(
        registryDirectory,
      ).client;
      final RegistryIndexDocument index = await client.loadIndex();
      _stdout(
        'ok  registry: ${registryDirectory.path} (${index.items.length} items, v${index.registryVersion})',
      );
    } on Object catch (error) {
      _stderr('err registry: $error');
      issues++;
    }
    return issues == 0 ? 0 : 1;
  }

  /// Reports whether the project's declared dependencies have actually
  /// resolved.
  ///
  /// `doctor` used to answer only questions it asked of its own files —
  /// config, manifest, registry — and so printed four `ok` lines and exited 0
  /// for a project whose `flutter pub get` failed with exit 69. A diagnostic
  /// that certifies a project which cannot build is worse than no diagnostic.
  ///
  /// `.dart_tool/package_config.json` is what `pub get` writes on success, so
  /// a dependency named in `pubspec.yaml` and absent from it is a dependency
  /// pub could not resolve. That is a general check, not a special case for
  /// any one package name.
  int _checkDependencies(FlutterProject project) {
    final Set<String> declared = <String>{
      for (final String section in const <String>[
        'dependencies',
        'dev_dependencies',
      ])
        if (project.data[section] case final YamlMap map)
          for (final Object? key in map.keys) '$key',
    };
    if (declared.isEmpty) {
      _stdout('ok  dependencies: none declared');
      return 0;
    }
    final File packageConfig = File(
      _join(project.root.path, '.dart_tool/package_config.json'),
    );
    if (!packageConfig.existsSync()) {
      _stderr(
        'err dependencies: .dart_tool/package_config.json is missing, so the '
        '${declared.length} declared dependencies have never resolved. Run '
        '`flutter pub get`.',
      );
      return 1;
    }
    final Set<String> resolved;
    try {
      final Object? decoded = jsonDecode(packageConfig.readAsStringSync());
      final Object? packages = decoded is Map<String, Object?>
          ? decoded['packages']
          : null;
      if (packages is! List<Object?>) {
        throw const FormatException('packages must be an array');
      }
      resolved = <String>{
        for (final Object? entry in packages)
          if (entry is Map<String, Object?> && entry['name'] is String)
            entry['name']! as String,
      };
    } on Object catch (error) {
      _stderr(
        'err dependencies: .dart_tool/package_config.json is unreadable: $error',
      );
      return 1;
    }
    final List<String> missing =
        declared.where((String name) => !resolved.contains(name)).toList()
          ..sort();
    if (missing.isNotEmpty) {
      _stderr(
        'err dependencies: ${missing.join(', ')} declared in pubspec.yaml but '
        'absent from .dart_tool/package_config.json — `flutter pub get` '
        'cannot resolve this project.',
      );
      return 1;
    }
    _stdout('ok  dependencies: ${declared.length} declared, all resolved');
    return 0;
  }

  _MutationResult _planMutation({
    required FlutterProject project,
    required _RegistryContext registry,
    required ElattarConfig config,
    required List<RegistryItem> resolvedItems,
    required bool overwrite,
    required bool dryRun,
  }) {
    final Installer installer = Installer();
    final List<InstallItem> installItems = <InstallItem>[
      for (final RegistryItem item in resolvedItems) _toInstallItem(item),
    ];
    final InstallPlan installPlan = installer.plan(
      projectRoot: project.root,
      repositoryRoot: registry.repositoryRoot,
      items: installItems,
      overwrite: overwrite,
      // Passed on every mutation, not only on `init`. `init` is where it
      // first lands, but a project whose `LICENSES/ELATTAR-MIT.txt` was
      // deleted should get it back on the next `add` rather than quietly
      // continue without the one notice every installed component needs.
      // Identical content is a no-op, so this costs nothing when it is
      // already there.
      textNotices: const <String, String>{
        elattarMitNoticeTarget: elattarMitNotice,
      },
    );
    final List<_WritePlan> writes = <_WritePlan>[
      for (final InstallOperation operation in installPlan.operations)
        _WritePlan(path: operation.destination, content: operation.content),
    ];

    final String configPath = _join(project.root.path, 'elattar.yaml');
    writes.add(_WritePlan(path: configPath, content: config.toYaml()));

    final ElattarManifest currentManifest = _loadExistingManifest(
      project.root,
      config,
    );
    final List<InstalledItem> updatedItems = _mergedManifestItems(
      currentManifest.items,
      resolvedItems,
      writes,
      project.root.path,
    );
    final ElattarManifest updatedManifest = ElattarManifest(
      foundation: config.foundation,
      registry: config.registry,
      items: updatedItems,
    );
    writes.add(
      _WritePlan(
        path: _manifestFile(project.root).path,
        content: updatedManifest.toJsonString(),
      ),
    );

    final List<InstallConflict> conflicts = <InstallConflict>[
      ...installPlan.conflicts,
    ];
    if (!dryRun && conflicts.isEmpty) {
      for (final _WritePlan write in writes) {
        final File file = File(write.path);
        file.parent.createSync(recursive: true);
        if (write.content is List<int>) {
          file.writeAsBytesSync(write.content as List<int>);
        } else {
          file.writeAsStringSync(write.content.toString());
        }
      }
    }
    return _MutationResult(writes: writes, conflicts: conflicts);
  }

  List<InstalledItem> _mergedManifestItems(
    List<InstalledItem> existing,
    List<RegistryItem> resolvedItems,
    List<_WritePlan> writes,
    String projectRoot,
  ) {
    final Map<String, InstalledItem> merged = <String, InstalledItem>{
      for (final InstalledItem item in existing) item.name: item,
    };
    final Map<String, _WritePlan> writeByPath = <String, _WritePlan>{
      for (final _WritePlan write in writes) write.path: write,
    };
    for (final RegistryItem item in resolvedItems) {
      final List<InstalledFile> files = <InstalledFile>[
        ..._installedFilesFor(item.files, projectRoot, writeByPath),
        ..._installedFilesForResources(item.assets, projectRoot, writeByPath),
        ..._installedFilesForResources(item.fonts, projectRoot, writeByPath),
        ..._installedFilesForResources(item.shaders, projectRoot, writeByPath),
      ];
      merged[item.name] = InstalledItem(
        name: item.name,
        version: item.version,
        files: files,
      );
    }
    final List<InstalledItem> items = merged.values.toList()
      ..sort((InstalledItem a, InstalledItem b) => a.name.compareTo(b.name));
    return items;
  }

  List<InstalledFile> _installedFilesFor(
    List<RegistryFile> files,
    String projectRoot,
    Map<String, _WritePlan> writeByPath,
  ) {
    return <InstalledFile>[
      for (final RegistryFile file in files)
        InstalledFile(
          target: _relativeToRoot(
            projectRoot,
            _logicalDestination(projectRoot, file.target),
          ),
          sourceHash: file.sha256,
          installedHash: _hashForDestination(
            _logicalDestination(projectRoot, file.target),
            writeByPath,
          ),
        ),
    ];
  }

  List<InstalledFile> _installedFilesForResources(
    List<RegistryResource> resources,
    String projectRoot,
    Map<String, _WritePlan> writeByPath,
  ) {
    return <InstalledFile>[
      for (final RegistryResource resource in resources)
        InstalledFile(
          target: _relativeToRoot(
            projectRoot,
            _logicalDestination(projectRoot, resource.target),
          ),
          sourceHash: resource.sha256,
          installedHash: _hashForDestination(
            _logicalDestination(projectRoot, resource.target),
            writeByPath,
          ),
        ),
    ];
  }

  String _hashForDestination(
    String destination,
    Map<String, _WritePlan> writeByPath,
  ) {
    final _WritePlan? write = writeByPath[destination];
    if (write != null) {
      final Object content = write.content;
      return sha256Hex(
        content is List<int> ? content : utf8.encode(content.toString()),
      );
    }
    final File file = File(destination);
    if (!file.existsSync()) return '';
    return sha256Hex(file.readAsBytesSync());
  }

  ElattarManifest _loadExistingManifest(
    Directory projectRoot,
    ElattarConfig config,
  ) {
    final File file = _manifestFile(projectRoot);
    if (!file.existsSync()) {
      return ElattarManifest(
        foundation: config.foundation,
        registry: config.registry,
        items: const <InstalledItem>[],
      );
    }
    return ElattarManifest.load(file);
  }

  ElattarConfig _configFor({
    required FlutterProject project,
    required Directory registryDirectory,
  }) {
    return ElattarConfig(
      registry: projectRelativeRegistry(
        project.root.absolute.path,
        registryDirectory.absolute.path,
      ),
    );
  }

  int _printUsage() {
    _stdout('elattar ${CliIdentity.version}');
    _stdout('usage:');
    _stdout('  elattar --version');
    _stdout(
      '  elattar init [--foundation source] [--yes] [--dry-run] [--registry PATH]',
    );
    _stdout(
      '  elattar add <items...> [--all] [--overwrite] [--dry-run] [--registry PATH]',
    );
    _stdout('  elattar list [--registry PATH]');
    _stdout('  elattar search <query> [--registry PATH]');
    _stdout('  elattar info <name> [--registry PATH]');
    _stdout('  elattar doctor [--registry PATH]');
    return 0;
  }

  int _unknownCommand(String command) {
    _stderr('Unknown command: $command');
    _stderr('Run `elattar help` for usage.');
    return 64;
  }

  void _printMutationSummary({
    required String action,
    required _MutationResult result,
    required bool dryRun,
  }) {
    if (result.conflicts.isNotEmpty) {
      _stderr('$action found ${result.conflicts.length} conflict(s):');
      for (final InstallConflict conflict in result.conflicts) {
        _stderr(' - ${conflict.destination}: ${conflict.reason}');
      }
      return;
    }
    _stdout(
      '${dryRun ? 'dry-run' : action} wrote ${result.writes.length} file(s).',
    );
    for (final _WritePlan write in result.writes) {
      _stdout(' - ${write.path}');
    }
  }

  static void _defaultStdout(String line) => stdout.writeln(line);
  static void _defaultStderr(String line) => stderr.writeln(line);
}

Future<List<String>> _resolvedAddNames({
  required _RegistryContext registry,
  required List<String> names,
  required bool addAll,
}) async {
  if (!addAll) {
    if (names.isEmpty) {
      throw const FormatException('add requires at least one item name.');
    }
    return names;
  }
  final List<String> curated = _loadInstallableComponentOwners(
    registry.repositoryRoot,
  );
  if (curated.isNotEmpty) {
    return _dedupeNames(<String>[...curated, ...names]);
  }
  final List<RegistryItem> allComponents = await registry.client.list(
    type: RegistryItemType.component,
  );
  if (allComponents.isEmpty) {
    throw const FormatException('The registry has no component items to add.');
  }
  return _dedupeNames(<String>[
    for (final RegistryItem item in allComponents) item.name,
    ...names,
  ]);
}

List<String> _loadInstallableComponentOwners(Directory repositoryRoot) {
  final File inventoryFile = File(
    _join(repositoryRoot.path, 'registry/component_inventory.json'),
  );
  if (!inventoryFile.existsSync()) return const <String>[];
  final Object? decoded;
  try {
    decoded = jsonDecode(inventoryFile.readAsStringSync());
  } on Object catch (error) {
    throw FormatException(
      'registry/component_inventory.json is invalid: $error',
    );
  }
  if (decoded is! Map<String, Object?>) {
    throw const FormatException(
      'registry/component_inventory.json must be a JSON object.',
    );
  }
  final Object? rawOwners = decoded['installableOwners'];
  if (rawOwners is! List<Object?>) {
    throw const FormatException(
      'registry/component_inventory.json.installableOwners must be an array.',
    );
  }
  return _dedupeNames(<String>[
    for (final Object? value in rawOwners)
      if (value is String && value.trim().isNotEmpty)
        value
      else
        throw const FormatException(
          'registry/component_inventory.json.installableOwners must contain non-empty strings.',
        ),
  ]);
}

List<String> _dedupeNames(List<String> names) {
  final List<String> deduped = <String>[];
  final Set<String> seen = <String>{};
  for (final String name in names) {
    if (seen.add(name)) {
      deduped.add(name);
    }
  }
  return deduped;
}

class _RegistryContext {
  const _RegistryContext({
    required this.directory,
    required this.repositoryRoot,
    required this.client,
  });

  final Directory directory;
  final Directory repositoryRoot;
  final RegistryClient client;

  factory _RegistryContext.fromLatestDirectory(Directory latestDirectory) {
    final Directory repoRoot = latestDirectory.parent.parent.parent;
    return _RegistryContext(
      directory: latestDirectory,
      repositoryRoot: repoRoot,
      client: RegistryClient.localGenerated(latestDirectory),
    );
  }
}

class _ArgCursor {
  _ArgCursor(this._values);

  final List<String> _values;
  int _index = 0;

  bool get hasNext => _index < _values.length;

  String? take() => hasNext ? _values[_index++] : null;

  String requireValue(String flag) {
    final String? value = take();
    if (value == null || value.startsWith('--')) {
      throw FormatException('$flag requires a value.');
    }
    return value;
  }
}

class _MutationResult {
  const _MutationResult({required this.writes, required this.conflicts});

  final List<_WritePlan> writes;
  final List<InstallConflict> conflicts;

  int get exitCode => conflicts.isEmpty ? 0 : 73;
}

class _WritePlan {
  const _WritePlan({required this.path, required this.content});

  final String path;
  final Object content;
}

InstallItem _toInstallItem(RegistryItem item) {
  return InstallItem(
    name: item.name,
    version: item.version,
    files: <InstallFile>[
      for (final RegistryFile file in item.files)
        InstallFile(
          source: file.source,
          target: file.target,
          sha256: file.sha256,
        ),
    ],
    assets: <InstallResource>[
      for (final RegistryResource resource in item.assets)
        InstallResource(
          source: resource.source,
          target: resource.target,
          sha256: resource.sha256,
        ),
    ],
    fonts: <InstallFont>[
      for (final RegistryFont resource in item.fonts)
        InstallFont(
          source: resource.source,
          target: resource.target,
          sha256: resource.sha256,
          family: resource.family,
          style: resource.style,
        ),
    ],
    shaders: <InstallResource>[
      for (final RegistryResource resource in item.shaders)
        InstallResource(
          source: resource.source,
          target: resource.target,
          sha256: resource.sha256,
        ),
    ],
    licenses: <InstallResource>[
      for (final RegistryResource resource in item.licenses)
        InstallResource(
          source: resource.source,
          target: resource.target,
          sha256: resource.sha256,
        ),
    ],
    dependencies: item.registryDependencies,
    pubDependencies: item.pubDependencies,
  );
}

Directory _discoverRegistryDirectory(String? explicitPath) {
  if (explicitPath != null && explicitPath.trim().isNotEmpty) {
    final String value = explicitPath.trim();
    // A URL here used to reach `Directory(...)` and surface as an unhandled
    // FileSystemException with a raw Dart stack trace. There is no HTTP
    // fetcher, so a remote value can only fail; it fails with a sentence.
    if (_uriScheme.hasMatch(value)) {
      throw FormatException(
        'Remote registries are not supported yet: $value\n'
        'elattar ${CliIdentity.version} reads a local registry only. '
        'Point --registry (or the `registry:` key in elattar.yaml) at a '
        '`registry/generated/latest` directory.',
      );
    }
    final Directory directory = Directory(value).absolute;
    if (!directory.existsSync()) {
      throw FormatException('Registry path does not exist: ${directory.path}');
    }
    return directory;
  }
  Directory current = Directory.current.absolute;
  while (true) {
    final Directory candidate = Directory(
      _join(current.path, 'registry/generated/latest'),
    );
    if (candidate.existsSync()) return candidate;
    final Directory parent = current.parent;
    if (parent.path == current.path) break;
    current = parent;
  }
  throw const FormatException(
    'Could not find registry/generated/latest. Pass --registry PATH.',
  );
}

File _manifestFile(Directory projectRoot) {
  return File(_join(projectRoot.path, '.elattar/manifest.json'));
}

String _join(String first, String second) =>
    '${first.replaceAll(RegExp(r'[\\/]+$'), '')}${Platform.pathSeparator}$second';

String _relativeToRoot(String root, String value) {
  return value
      .replaceAll('\\', '/')
      .replaceFirst('${root.replaceAll('\\', '/')}/', '');
}

String _logicalDestination(String projectRoot, String target) {
  return _targetMapper.destination(projectRoot, target);
}
