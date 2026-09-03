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
import '../registry/file_cache.dart';
import '../registry/http_fetcher.dart';
import '../registry/location.dart';
import '../registry/models.dart';
import '../registry/source.dart';

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

/// Dispatches Elattar CLI commands against a Flutter project and registry.
///
/// The optional sinks, fetcher, cache, and working directory keep the command
/// embeddable and deterministic in tools and tests. Omitted values use the
/// current process environment.
class ElattarCli {
  /// Creates a command dispatcher.
  ElattarCli({
    void Function(String line)? stdoutSink,
    void Function(String line)? stderrSink,
    RegistryFetcher? fetcher,
    Directory? cacheDirectory,
    Directory? workingDirectory,
  }) : _stdout = stdoutSink ?? _defaultStdout,
       _stderr = stderrSink ?? _defaultStderr,
       _fetcher = fetcher,
       _cacheDirectory = cacheDirectory,
       _workingDirectory = workingDirectory;

  final void Function(String line) _stdout;
  final void Function(String line) _stderr;

  /// Substituted by tests for a local `HttpServer`, so the remote code path
  /// is exercised without the suite depending on the live internet.
  final RegistryFetcher? _fetcher;

  /// Substituted by tests for a temporary directory, so a test run never
  /// reads or writes the developer's real cache.
  final Directory? _cacheDirectory;

  /// The directory commands act from. Defaults to the process's.
  ///
  /// A seam rather than `Directory.current`, because `Directory.current` is
  /// **process**-wide while `dart test` runs test files in separate isolates
  /// of one process: a suite that set it to a temporary project silently
  /// changed the working directory of every other suite running at the same
  /// time. Passing it in keeps each run's notion of "here" to itself.
  final Directory? _workingDirectory;

  Directory get _here => _workingDirectory ?? Directory.current;

  /// Resolves the registry for one command.
  ///
  /// The resolution order lives in [resolveRegistryLocation]; this adds the
  /// one thing the CLI owes a user on top of it — saying so out loud when a
  /// local registry was *discovered* rather than named. Silently preferring a
  /// directory found by walking up from the working directory is how a
  /// released CLI would install something other than what it advertises.
  _RegistryContext _registryFor({
    String? explicit,
    String? configured,
    bool offline = false,
    bool quiet = false,
  }) {
    final RegistryLocation location = resolveRegistryLocation(
      explicit: explicit,
      configured: configured,
      workingDirectory: _here,
    );
    if (!quiet && location is LocalRegistryLocation && location.discovered) {
      _stdout(
        'note: using the local registry found at ${location.display}. '
        'Pass --registry $defaultRegistryUrl to use the published one.',
      );
    }
    return _RegistryContext.forLocation(
      location,
      offline: offline,
      fetcher: _fetcher,
      cacheDirectory: _cacheDirectory,
    );
  }

  /// Runs one command and returns a documented process exit code.
  ///
  /// Passing no arguments prints the usage summary. Command failures are
  /// translated to concise messages on the configured error sink.
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
    } on RegistryLocationException catch (error) {
      // A registry the CLI cannot use is a usage error, not a crash: same
      // exit code as an unknown flag, and one sentence rather than a stack.
      _stderr(error.message);
      return 64;
    } on RegistrySourceException catch (error) {
      // Network and cache failures. 70 (EX_SOFTWARE) rather than 64: the
      // command was well formed, the world did not cooperate.
      _stderr(error.message);
      return 70;
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
    bool offline = false;
    String? registryPath;
    while (cursor.hasNext) {
      final String value = cursor.take()!;
      if (value == '--foundation') {
        foundation = cursor.requireValue('--foundation');
      } else if (value == '--dry-run') {
        dryRun = true;
      } else if (value == '--offline') {
        offline = true;
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
    final FlutterProject project = discoverFlutterProject(start: _here);
    final _RegistryContext registry = _registryFor(
      explicit: registryPath,
      offline: offline,
    );
    final ElattarConfig config = _configFor(
      project: project,
      location: registry.location,
    );
    final List<RegistryItem> resolved = await registry.client.resolve(<String>[
      'source-foundation',
    ]);

    final _MutationResult mutation = await _planMutation(
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
        '`registry:` value. Pass --registry ${registry.location.display} to '
        '`elattar add`.',
      );
    }
    return mutation.exitCode;
  }

  Future<int> _runAdd(_ArgCursor cursor) async {
    bool overwrite = false;
    bool dryRun = false;
    bool addAll = false;
    bool offline = false;
    String? registryPath;
    final List<String> names = <String>[];
    while (cursor.hasNext) {
      final String value = cursor.take()!;
      if (value == '--overwrite') {
        overwrite = true;
      } else if (value == '--dry-run') {
        dryRun = true;
      } else if (value == '--offline') {
        offline = true;
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
    final FlutterProject project = discoverFlutterProject(start: _here);
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
    final _RegistryContext registry = _registryFor(
      explicit: registryPath,
      configured: config.registry,
      offline: offline,
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
    final _MutationResult mutation = await _planMutation(
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
    bool offline = false;
    while (cursor.hasNext) {
      final String value = cursor.take()!;
      if (value == '--registry') {
        registryPath = cursor.requireValue('--registry');
      } else if (value == '--offline') {
        offline = true;
      } else {
        throw FormatException('Unknown list option: $value');
      }
    }
    final RegistryClient client = _registryFor(
      explicit: registryPath,
      offline: offline,
    ).client;
    final List<RegistryItem> items = await client.list();
    for (final RegistryItem item in items) {
      _stdout('${item.name}\t${item.type.name}\t${item.version}');
    }
    return 0;
  }

  Future<int> _runSearch(_ArgCursor cursor) async {
    String? registryPath;
    bool offline = false;
    final List<String> query = <String>[];
    while (cursor.hasNext) {
      final String value = cursor.take()!;
      if (value == '--registry') {
        registryPath = cursor.requireValue('--registry');
      } else if (value == '--offline') {
        offline = true;
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
    final RegistryClient client = _registryFor(
      explicit: registryPath,
      offline: offline,
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
    bool offline = false;
    String? name;
    while (cursor.hasNext) {
      final String value = cursor.take()!;
      if (value == '--registry') {
        registryPath = cursor.requireValue('--registry');
      } else if (value == '--offline') {
        offline = true;
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
    final RegistryClient client = _registryFor(
      explicit: registryPath,
      offline: offline,
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
    bool offline = false;
    bool verbose = false;
    while (cursor.hasNext) {
      final String value = cursor.take()!;
      if (value == '--registry') {
        registryPath = cursor.requireValue('--registry');
      } else if (value == '--offline') {
        offline = true;
      } else if (value == '--verbose' || value == '-v') {
        verbose = true;
      } else {
        throw FormatException('Unknown doctor option: $value');
      }
    }
    String? configured;
    int issues = 0;
    FlutterProject? project;
    try {
      project = discoverFlutterProject(start: _here);
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
          configured = config.registry;
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

    issues += await _checkRegistry(
      explicit: registryPath,
      configured: configured,
      offline: offline,
      verbose: verbose,
    );
    return issues == 0 ? 0 : 1;
  }

  /// Reports what registry a command would use, and whether it answers.
  ///
  /// `doctor` used to print a directory and an item count, which said nothing
  /// about the case that now matters most: a released CLI reading a hosted
  /// registry it may not be able to reach. So this reports the kind, the
  /// version, the item count, the cache state, and reachability — the five
  /// things that distinguish "your registry is fine" from each way it is not.
  ///
  /// It deliberately does not print the cache path unless [verbose]. That path
  /// contains a username on every platform, and `doctor` output is the first
  /// thing anyone pastes into a bug report.
  Future<int> _checkRegistry({
    String? explicit,
    String? configured,
    required bool offline,
    required bool verbose,
  }) async {
    final _RegistryContext registry;
    try {
      registry = _registryFor(
        explicit: explicit,
        configured: configured,
        offline: offline,
        // The discovery note belongs to commands that act. `doctor` reports
        // the same fact in its own line below, with more detail.
        quiet: true,
      );
    } on RegistryLocationException catch (error) {
      _stderr('err registry: ${error.message}');
      return 1;
    }

    final RegistryLocation location = registry.location;
    final String discovered =
        location is LocalRegistryLocation && location.discovered
        ? ', discovered'
        : '';
    _stdout(
      'ok  registry source: ${location.kind}$discovered — ${location.display}',
    );

    final FileRegistryCache? cache = registry.cache;
    if (cache == null) {
      _stdout('ok  registry cache: not used (local registry)');
    } else if (!cache.isPersistent) {
      // Worth an `err`, not a note: `--offline` cannot work at all in this
      // state, and the user would otherwise only find out mid-flight.
      _stderr(
        'err registry cache: not persistent — this run cannot populate an '
        'offline cache. Set ELATTAR_CACHE_DIR to a writable directory.',
      );
      return 1;
    } else {
      final String where = verbose ? ' at ${cache.directory?.path}' : '';
      _stdout(
        'ok  registry cache: ${cache.entryCount} entries$where'
        '${offline ? ' (offline: reading cache only)' : ''}',
      );
    }

    try {
      final RegistryIndexDocument index = await registry.client.loadIndex();
      _stdout(
        'ok  registry: v${index.registryVersion}, ${index.items.length} items, '
        'schema v${index.schemaVersion}',
      );
      if (index.schemaVersion != CliIdentity.registrySchemaVersion) {
        _stderr(
          'err registry: schema v${index.schemaVersion} but this CLI speaks '
          'v${CliIdentity.registrySchemaVersion}.',
        );
        return 1;
      }
      return 0;
    } on RegistrySourceException catch (error) {
      // The distinction the plan asks for, and the one a user actually needs:
      // an empty cache and an unreachable network are different problems with
      // different fixes, and `--offline` is what tells them apart.
      _stderr(
        offline
            ? 'err registry: nothing cached for ${location.display}. Run once '
                  'without --offline to populate the cache.'
            : 'err registry: ${error.message}',
      );
      return 1;
    } on Object catch (error) {
      _stderr('err registry: $error');
      return 1;
    }
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

  Future<_MutationResult> _planMutation({
    required FlutterProject project,
    required _RegistryContext registry,
    required ElattarConfig config,
    required List<RegistryItem> resolvedItems,
    required bool overwrite,
    required bool dryRun,
  }) async {
    final Installer installer = Installer();
    final List<InstallItem> installItems = <InstallItem>[
      for (final RegistryItem item in resolvedItems) _toInstallItem(item),
    ];
    // Everything is downloaded and hash-checked before anything is written.
    // A network failure or a corrupted payload therefore aborts with the
    // consumer's tree untouched, rather than half-installed behind a barrel
    // that references files that never arrived.
    final InstallPayloads payloads = await _fetchPayloads(
      registry,
      resolvedItems,
    );
    final InstallPlan installPlan = installer.plan(
      projectRoot: project.root,
      repositoryRoot: registry.repositoryRoot,
      items: installItems,
      payloads: payloads,
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
    if (!dryRun && conflicts.isEmpty) {
      // The install succeeded, so the network is known to be reachable. Warm
      // the other catalog file too, so `list`/`search --offline` work
      // afterwards rather than missing on a file no install ever fetched.
      await registry.client.warmCatalog();
    }
    return _MutationResult(writes: writes, conflicts: conflicts);
  }

  /// Downloads and verifies every byte an install will write.
  ///
  /// Runs for a local registry too. The generated payloads are byte-identical
  /// to the repository sources, so nothing changes for a contributor — but it
  /// means one code path installs from one kind of artifact, and the bytes
  /// that land in a consumer are always the ones whose sha256 was just
  /// checked, rather than whatever the working tree happens to hold.
  Future<InstallPayloads> _fetchPayloads(
    _RegistryContext registry,
    List<RegistryItem> items,
  ) async {
    final Map<String, List<int>> bytes = <String, List<int>>{};
    for (final RegistryItem item in items) {
      for (final RegistryResource resource in item.resources) {
        bytes[InstallPayloads.keyFor(
          item.name,
          item.version,
          resource.target,
        )] = await registry.client.payloadBytes(
          item,
          resource,
        );
      }
    }
    return InstallPayloads(bytes);
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
    required RegistryLocation location,
  }) {
    // The location decides what is portable enough to commit: a URL always,
    // a directory only when it sits inside the project. An absolute local
    // path in a committed `elattar.yaml` works on exactly one machine.
    return ElattarConfig(
      registry: location.configValueFor(project.root.absolute.path),
    );
  }

  int _printUsage() {
    _stdout('elattar ${CliIdentity.version}');
    _stdout('usage:');
    _stdout('  elattar --version');
    _stdout(
      '  elattar init [--foundation source] [--yes] [--dry-run] '
      '[--registry PATH_OR_URL] [--offline]',
    );
    _stdout(
      '  elattar add <items...> [--all] [--overwrite] [--dry-run] '
      '[--registry PATH_OR_URL] [--offline]',
    );
    _stdout('  elattar list [--registry PATH_OR_URL] [--offline]');
    _stdout('  elattar search <query> [--registry PATH_OR_URL] [--offline]');
    _stdout('  elattar info <name> [--registry PATH_OR_URL] [--offline]');
    _stdout(
      '  elattar doctor [--registry PATH_OR_URL] [--offline] [--verbose]',
    );
    _stdout('');
    _stdout('  --registry takes a local directory or an http(s) URL.');
    _stdout('  Default: $defaultRegistryUrl');
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
    required this.location,
    required this.repositoryRoot,
    required this.client,
    this.cache,
  });

  /// Where the registry lives, local or remote.
  final RegistryLocation location;

  /// The repository the local flow reads sources from.
  ///
  /// Meaningless for a remote registry — there is no checkout — so it points
  /// at the working directory there and nothing reads it: a remote install
  /// runs entirely on staged payloads.
  final Directory repositoryRoot;
  final RegistryClient client;

  /// The persistent cache, when this registry has one. Local registries do
  /// not: the files are already on disk.
  final FileRegistryCache? cache;

  /// Builds the context for a resolved [location].
  ///
  /// [fetcher] and [cacheDirectory] exist so tests can point the remote path
  /// at a local `HttpServer` and a temporary directory. Nothing in the suite
  /// touches the internet.
  factory _RegistryContext.forLocation(
    RegistryLocation location, {
    bool offline = false,
    RegistryFetcher? fetcher,
    Directory? cacheDirectory,
  }) {
    switch (location) {
      case LocalRegistryLocation(:final Directory directory):
        return _RegistryContext(
          location: location,
          repositoryRoot: directory.parent.parent.parent,
          client: RegistryClient.localGenerated(directory),
        );
      case RemoteRegistryLocation(:final Uri baseUri):
        final FileRegistryCache cache = FileRegistryCache.open(
          directory: cacheDirectory,
        );
        return _RegistryContext(
          location: location,
          // Nothing reads this for a remote registry; a remote install runs
          // entirely on payloads that were fetched and hash-verified first.
          repositoryRoot: Directory.current,
          cache: cache,
          client: RegistryClient.remote(
            baseUri: baseUri,
            fetcher: fetcher ?? httpRegistryFetcher(),
            cache: cache,
            offline: offline,
          ),
        );
    }
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
