library;

import 'dart:convert';
import 'dart:io';

import '../config.dart';
import '../identity.dart';
import '../install/installer.dart';
import '../install/models.dart';
import '../install/target_mapper.dart';
import '../manifest.dart';
import '../project.dart';
import '../registry/client.dart';
import '../registry/models.dart';

const LogicalTargetMapper _targetMapper = LogicalTargetMapper();

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
    final FoundationMode mode = switch (foundation) {
      'source' => FoundationMode.source,
      'package' => FoundationMode.package,
      _ => throw const FormatException(
        'init --foundation must be source or package.',
      ),
    };
    final FlutterProject project = discoverFlutterProject();
    final Directory registryDirectory = _discoverRegistryDirectory(
      registryPath,
    );
    final _RegistryContext registry = _RegistryContext.fromLatestDirectory(
      registryDirectory,
    );
    final ElattarConfig config = _configFor(
      mode: mode,
      registryDirectory: registryDirectory,
    );
    final List<RegistryItem> resolved = mode == FoundationMode.source
        ? await registry.client.resolve(<String>['source-foundation'])
        : <RegistryItem>[];

    final _MutationResult mutation = _planMutation(
      project: project,
      registry: registry,
      config: config,
      resolvedItems: resolved,
      overwrite: false,
      dryRun: dryRun,
      replaceFoundationWithPackageImports: false,
      addCorePackageDependency: mode == FoundationMode.package,
    );
    _printMutationSummary(action: 'init', result: mutation, dryRun: dryRun);
    return mutation.exitCode;
  }

  Future<int> _runAdd(_ArgCursor cursor) async {
    bool overwrite = false;
    bool dryRun = false;
    String? registryPath;
    final List<String> names = <String>[];
    while (cursor.hasNext) {
      final String value = cursor.take()!;
      if (value == '--overwrite') {
        overwrite = true;
      } else if (value == '--dry-run') {
        dryRun = true;
      } else if (value == '--registry') {
        registryPath = cursor.requireValue('--registry');
      } else {
        if (value.startsWith('--')) {
          throw FormatException('Unknown add option: $value');
        }
        names.add(value);
      }
    }
    if (names.isEmpty) {
      throw const FormatException('add requires at least one item name.');
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
    final Directory registryDirectory = registryPath == null
        ? _discoverRegistryDirectory(config.registry)
        : _discoverRegistryDirectory(registryPath);
    final _RegistryContext registry = _RegistryContext.fromLatestDirectory(
      registryDirectory,
    );
    final File manifestFile = _manifestFile(project.root);
    if (!manifestFile.existsSync()) {
      throw const ElattarManifestException(
        'Missing .elattar/manifest.json. Run `elattar init` first.',
      );
    }
    final ElattarManifest manifest = ElattarManifest.load(manifestFile);
    config.validateAgainst(manifest);

    final List<RegistryItem> resolved = await registry.client.resolve(names);
    final bool packageMode = config.foundation == FoundationMode.package;
    final _MutationResult mutation = _planMutation(
      project: project,
      registry: registry,
      config: config,
      resolvedItems: resolved,
      overwrite: overwrite,
      dryRun: dryRun,
      replaceFoundationWithPackageImports: packageMode,
      addCorePackageDependency: packageMode,
      filterForPackageMode: packageMode,
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
          _stdout('ok  config: foundation=${config.foundation.name}');
        } on Object catch (error) {
          _stderr('err config: $error');
          issues++;
        }
      } else {
        _stderr('err config: missing elattar.yaml');
        issues++;
      }

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

  _MutationResult _planMutation({
    required FlutterProject project,
    required _RegistryContext registry,
    required ElattarConfig config,
    required List<RegistryItem> resolvedItems,
    required bool overwrite,
    required bool dryRun,
    required bool replaceFoundationWithPackageImports,
    required bool addCorePackageDependency,
    bool filterForPackageMode = false,
  }) {
    final Installer installer = Installer();
    final List<RegistryItem> installableItems = filterForPackageMode
        ? resolvedItems.where(_copyInPackageMode).toList(growable: false)
        : resolvedItems;
    final List<InstallItem> installItems = <InstallItem>[
      for (final RegistryItem item in installableItems) _toInstallItem(item),
    ];
    final InstallPlan installPlan = installer.plan(
      projectRoot: project.root,
      repositoryRoot: registry.repositoryRoot,
      items: installItems,
      overwrite: overwrite,
    );
    final List<_WritePlan> writes = <_WritePlan>[
      for (final InstallOperation operation in installPlan.operations)
        _WritePlan(
          path: operation.destination,
          content: _rewritePackageImportsIfNeeded(
            operation.destination,
            operation.content,
            replaceFoundationWithPackageImports,
          ),
        ),
    ];

    final String configPath = _join(project.root.path, 'elattar.yaml');
    writes.add(_WritePlan(path: configPath, content: config.toYaml()));

    if (addCorePackageDependency) {
      final File pubspecFile = File(_join(project.root.path, 'pubspec.yaml'));
      final String current = pubspecFile.readAsStringSync();
      final String updated = installPlan.pubspec.isEmpty
          ? current
          : installPlan.pubspec;
      final String withCoreDependency = _ensureCoreDependency(updated);
      final int existingPubspec = writes.indexWhere(
        (_WritePlan write) => write.path == pubspecFile.path,
      );
      if (existingPubspec >= 0) {
        writes[existingPubspec] = _WritePlan(
          path: pubspecFile.path,
          content: withCoreDependency,
        );
      } else if (withCoreDependency != current) {
        writes.add(
          _WritePlan(path: pubspecFile.path, content: withCoreDependency),
        );
      }
    }

    final ElattarManifest currentManifest = _loadExistingManifest(
      project.root,
      config,
    );
    final List<InstalledItem> updatedItems = _mergedManifestItems(
      currentManifest.items,
      resolvedItems,
      writes,
      project.root.path,
      filterForPackageMode: filterForPackageMode,
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
    String projectRoot, {
    required bool filterForPackageMode,
  }) {
    final Map<String, InstalledItem> merged = <String, InstalledItem>{
      for (final InstalledItem item in existing) item.name: item,
    };
    final Map<String, _WritePlan> writeByPath = <String, _WritePlan>{
      for (final _WritePlan write in writes) write.path: write,
    };
    for (final RegistryItem item in resolvedItems) {
      if (filterForPackageMode && !_copyInPackageMode(item)) {
        continue;
      }
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

  Object _rewritePackageImportsIfNeeded(
    String destination,
    Object content,
    bool enabled,
  ) {
    if (!enabled || content is! String || !destination.endsWith('.dart')) {
      return content;
    }
    return content
        .replaceAllMapped(
          RegExp(r'''(['"])\.\./\.\./design_system/foundation/([^'"]+)\1'''),
          (Match match) =>
              "${match.group(1)}package:elattar_core/design_system/foundation/${match.group(2)}${match.group(1)}",
        )
        .replaceAllMapped(
          RegExp(r'''(['"])\.\./\.\./design_system/effects/([^'"]+)\1'''),
          (Match match) =>
              "${match.group(1)}package:elattar_core/design_system/effects/${match.group(2)}${match.group(1)}",
        )
        .replaceAllMapped(
          RegExp(r'''(['"])\.\./\.\./design_system/motion/([^'"]+)\1'''),
          (Match match) =>
              "${match.group(1)}package:elattar_core/design_system/motion/${match.group(2)}${match.group(1)}",
        );
  }

  String _ensureCoreDependency(String pubspec) {
    if (RegExp(r'^  elattar_core:', multiLine: true).hasMatch(pubspec)) {
      return pubspec;
    }
    final int dependenciesAt = pubspec.indexOf(
      RegExp(r'^dependencies:\s*$', multiLine: true),
    );
    if (dependenciesAt < 0) {
      return '$pubspec\ndependencies:\n  elattar_core: ^0.0.1\n';
    }
    final Match? nextTopLevel = RegExp(
      r'^\S[^\n]*:',
      multiLine: true,
    ).firstMatch(pubspec.substring(dependenciesAt + 13));
    final int insertAt = nextTopLevel == null
        ? pubspec.length
        : dependenciesAt + 13 + nextTopLevel.start;
    return '${pubspec.substring(0, insertAt)}  elattar_core: ^0.0.1\n${pubspec.substring(insertAt)}';
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
    required FoundationMode mode,
    required Directory registryDirectory,
  }) {
    return ElattarConfig(
      registry: registryDirectory.path,
      foundation: mode,
      packageName: mode == FoundationMode.package ? 'elattar_core' : null,
      packageVersion: mode == FoundationMode.package ? '^0.0.1' : null,
    );
  }

  int _printUsage() {
    _stdout('elattar ${CliIdentity.version}');
    _stdout('usage:');
    _stdout('  elattar --version');
    _stdout(
      '  elattar init [--foundation source|package] [--yes] [--dry-run] [--registry PATH]',
    );
    _stdout(
      '  elattar add <items...> [--overwrite] [--dry-run] [--registry PATH]',
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

bool _copyInPackageMode(RegistryItem item) {
  return switch (item.type) {
    RegistryItemType.component ||
    RegistryItemType.block ||
    RegistryItemType.asset => true,
    RegistryItemType.foundation ||
    RegistryItemType.effect ||
    RegistryItemType.motion ||
    RegistryItemType.preset => false,
  };
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
    fonts: <InstallResource>[
      for (final RegistryResource resource in item.fonts)
        InstallResource(
          source: resource.source,
          target: resource.target,
          sha256: resource.sha256,
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
    dependencies: item.registryDependencies,
    pubDependencies: item.pubDependencies,
  );
}

Directory _discoverRegistryDirectory(String? explicitPath) {
  if (explicitPath != null && explicitPath.trim().isNotEmpty) {
    final Directory directory = Directory(explicitPath).absolute;
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
