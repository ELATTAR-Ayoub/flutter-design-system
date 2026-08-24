/// Stages the generated registry into the site artifact for release.
///
///     dart run tool/release_registry/bin/stage.dart \
///         --version 0.0.1 --web-root example/build/web
///
/// Run after the Flutter web build, so the staged registry ends up inside the
/// same artifact GitHub Pages uploads. What comes out is served by any static
/// HTTP server with no rewriting, because that is exactly what Pages is.
library;

import 'dart:convert';
import 'dart:io';

import '../../registry_builder/lib/registry_schema.dart';
import '../../registry_builder/lib/registry_validator.dart';
import '../lib/stage.dart';

Future<int> main(List<String> arguments) async {
  String version = '';
  String webRoot = 'example/build/web';
  String source = 'registry/generated/latest';
  String? commit;
  bool alias = false;

  for (int i = 0; i < arguments.length; i++) {
    final String argument = arguments[i];
    String next(String flag) {
      if (i + 1 >= arguments.length) {
        throw StageException('$flag requires a value.');
      }
      return arguments[++i];
    }

    switch (argument) {
      case '--version':
        version = next('--version');
      case '--web-root':
        webRoot = next('--web-root');
      case '--source':
        source = next('--source');
      case '--commit':
        commit = next('--commit');
      case '--alias':
        alias = true;
      case '--help' || '-h':
        _usage();
        return 0;
      default:
        stderr.writeln('Unknown option: $argument');
        _usage();
        return 64;
    }
  }

  if (version.isEmpty) {
    stderr.writeln('--version is required.');
    _usage();
    return 64;
  }

  try {
    final StageResult result = stageRegistry(
      source: Directory(source),
      webRoot: Directory(webRoot),
      version: version,
      generationCommit: commit ?? await _headCommit(),
      alias: alias,
      validate: validateStagedRegistry,
    );
    stdout
      ..writeln('Staged registry $version')
      ..writeln('  destination  ${result.destination}')
      ..writeln('  files        ${result.fileCount}')
      ..writeln(
        '  status       ${result.filesWritten > 0 ? 'written' : 'already published, byte-identical'}',
      )
      ..writeln('  tree hash    ${result.treeHash}');
    if (result.aliasDestination case final String path) {
      stdout.writeln('  alias        $path');
    }
    return 0;
  } on StageException catch (error) {
    stderr.writeln(error.message);
    return 65;
  }
}

/// Checks the registry *as staged*, not as generated.
///
/// The generator already validates what it writes. This runs against the copy
/// that will actually be served, so it catches the failures that live between
/// the two: a file lost in transit, a manifest that no longer matches its
/// catalog entry, a payload whose bytes changed, a dependency pointing at an
/// item that did not make it into the release.
List<String> validateStagedRegistry(Directory staged) {
  final List<String> problems = <String>[];

  final File catalogFile = File(_join(staged, 'registry.json'));
  final File indexFile = File(_join(staged, 'index.json'));
  if (!catalogFile.existsSync()) return <String>['registry.json is missing'];
  if (!indexFile.existsSync()) return <String>['index.json is missing'];

  final RegistryDocument catalog;
  try {
    catalog = RegistryDocument.fromJsonString(catalogFile.readAsStringSync());
  } on Object catch (error) {
    return <String>['registry.json does not parse: $error'];
  }

  // The schema and cross-item rules, from the builder's own validator rather
  // than a second implementation that could disagree with it.
  problems.addAll(validateRegistry(catalog).errors);

  final Map<String, Object?> index =
      jsonDecode(indexFile.readAsStringSync()) as Map<String, Object?>;
  final List<Object?> indexItems = index['items']! as List<Object?>;
  if (indexItems.length != catalog.items.length) {
    problems.add(
      'index.json lists ${indexItems.length} items, registry.json has '
      '${catalog.items.length}',
    );
  }
  if (index['registryVersion'] != catalog.registryVersion) {
    problems.add(
      'index.json declares version ${index['registryVersion']}, '
      'registry.json declares ${catalog.registryVersion}',
    );
  }

  final Set<String> names = <String>{
    for (final RegistryItem item in catalog.items) item.name,
  };

  for (final RegistryItem item in catalog.items) {
    // Every dependency edge has to land on something that shipped. A missing
    // edge is how `add button` fails at the third file rather than the first.
    for (final String dependency in item.registryDependencies) {
      if (!names.contains(dependency)) {
        problems.add('${item.name} depends on "$dependency", which is absent');
      }
    }

    final File manifest = File(
      _join(staged, 'versions/${item.name}/${item.version}/manifest.json'),
    );
    if (!manifest.existsSync()) {
      problems.add('${item.name}: manifest.json is missing from the release');
      continue;
    }
    final RegistryItem staged_;
    try {
      staged_ = RegistryItem.fromJson(
        jsonDecode(manifest.readAsStringSync()),
        r'$',
      );
    } on Object catch (error) {
      problems.add('${item.name}: manifest.json does not parse: $error');
      continue;
    }
    if (staged_.version != item.version) {
      problems.add(
        '${item.name}: catalog says ${item.version}, manifest says '
        '${staged_.version}',
      );
    }

    // Every distributable the manifest declares, in one list. The builder's
    // model keeps files, assets, fonts, shaders and licenses apart because
    // they install differently; for release verification they are all just
    // bytes that must be present and must hash correctly.
    final List<({String target, String sha256})> declared =
        <({String target, String sha256})>[
          for (final RegistryFile file in staged_.files)
            (target: file.target, sha256: file.sha256),
          for (final RegistryResource resource in <RegistryResource>[
            ...staged_.assets,
            ...staged_.fonts,
            ...staged_.shaders,
            ...staged_.licenses,
          ])
            (target: resource.target, sha256: resource.sha256),
        ];

    for (final ({String target, String sha256}) resource in declared) {
      final File payload = File(
        _join(
          staged,
          'versions/${item.name}/${item.version}/'
          '${_payloadPath(resource.target)}',
        ),
      );
      if (!payload.existsSync()) {
        problems.add('${item.name}: payload for ${resource.target} is missing');
        continue;
      }
      final String actual = sha256Hex(payload.readAsBytesSync());
      if (actual != resource.sha256.toLowerCase()) {
        problems.add(
          '${item.name}: ${resource.target} hashes to $actual, manifest '
          'declares ${resource.sha256}',
        );
      }
    }
  }
  return problems;
}

String _payloadPath(String target) {
  for (final String prefix in logicalTargetPrefixes) {
    if (target.startsWith(prefix)) return 'logical/${target.substring(1)}';
  }
  return 'logical/$target';
}

String _join(Directory root, String relative) =>
    '${root.path.replaceAll(RegExp(r'[\\/]+$'), '')}'
    '${Platform.pathSeparator}'
    '${relative.replaceAll('/', Platform.pathSeparator)}';

/// The commit the staged registry was generated from, recorded in
/// `release.json` so a published endpoint can be traced back to a tree.
Future<String?> _headCommit() async {
  try {
    final ProcessResult result = await Process.run('git', <String>[
      'rev-parse',
      'HEAD',
    ]);
    if (result.exitCode != 0) return null;
    final String out = '${result.stdout}'.trim();
    return out.isEmpty ? null : out;
  } on ProcessException {
    // Staging must work outside a checkout too — from a downloaded artifact,
    // for instance. No commit is a missing field, not a failure.
    return null;
  }
}

void _usage() {
  stdout
    ..writeln('Stages a generated registry into the site artifact.')
    ..writeln()
    ..writeln('  --version X.Y.Z   the release version (required)')
    ..writeln('  --web-root DIR    default example/build/web')
    ..writeln('  --source DIR      default registry/generated/latest')
    ..writeln('  --commit SHA      recorded in release.json; defaults to HEAD')
    ..writeln('  --alias           also write the mutable /registry/latest/');
}
