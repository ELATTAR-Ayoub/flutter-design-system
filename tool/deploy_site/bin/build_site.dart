/// Builds the deployable docs site and stages the versioned registry into
/// it, for every context that needs the built artifact: a local run, CI, and
/// Vercel's build command. All three run this file so none of them can drift
/// from the others.
///
///     dart run tool/deploy_site/bin/build_site.dart
///
/// Run from the repository root. Reads `ELATTAR_SITE_ORIGIN` and
/// `ELATTAR_SITE_BASE_HREF` from the real environment first, then from a
/// `.env` file at the repository root if one exists (so a local run matches
/// CI without exporting by hand — see `.env.example`), then falls back to
/// the same defaults `.env.example` documents. A missing or malformed value
/// fails loudly, before `flutter build web` ever runs, because a wrong
/// origin or base href is a white screen at runtime, not a build error.
///
/// What it does, in order:
///   1. Resolve and validate the site origin and base href.
///   2. Resolve the registry version from `packages/elattar_cli`'s
///      `identity.dart` (the CLI's own pinned version — see
///      `SiteBuildConfig` in `../lib/build_site.dart`).
///   3. `flutter build web --release --base-href <href>
///      --dart-define=ELATTAR_SITE_ORIGIN=<origin>` in `example/`.
///   4. Stage the versioned registry into the built output by running
///      `tool/release_registry/bin/stage.dart` — reused, not reimplemented,
///      because its refusal to overwrite a published version with different
///      bytes is the whole immutability guarantee the CLI depends on.
///
/// Flags:
///   --registry-version X.Y.Z   override the version read from identity.dart
///   --no-stage-registry        build only; skip staging (fast local UI work)
///   --alias-registry           also stage the mutable /registry/latest/ alias
library;

import 'dart:io';

import '../lib/build_site.dart';

Future<int> main(List<String> arguments) async {
  bool stageRegistry = true;
  bool alias = false;
  String? registryVersionOverride;

  for (int i = 0; i < arguments.length; i++) {
    final String argument = arguments[i];
    switch (argument) {
      case '--no-stage-registry':
        stageRegistry = false;
      case '--alias-registry':
        alias = true;
      case '--registry-version':
        if (i + 1 >= arguments.length) {
          stderr.writeln('--registry-version requires a value.');
          return 64;
        }
        registryVersionOverride = arguments[++i];
      case '--help' || '-h':
        _usage();
        return 0;
      default:
        stderr.writeln('Unknown option: $argument');
        _usage();
        return 64;
    }
  }

  // Run from the repository root, the same way every other tool/ script
  // (e.g. tool/release_registry/bin/stage.dart) assumes it is run.
  final Directory repoRoot = Directory.current;
  final File identityFile = File(
    _join(repoRoot, 'packages/elattar_cli/lib/src/identity.dart'),
  );
  final Directory exampleDir = Directory(_join(repoRoot, 'example'));
  if (!exampleDir.existsSync() || !identityFile.existsSync()) {
    stderr.writeln(
      'Run this from the repository root '
      '(expected ./example and ./packages/elattar_cli/lib/src/identity.dart '
      'to exist; found neither at "${repoRoot.path}").',
    );
    return 64;
  }

  try {
    final String registryVersion =
        registryVersionOverride ??
        extractCliVersion(identityFile.readAsStringSync());

    final File dotEnvFile = File(_join(repoRoot, '.env'));
    final Map<String, String> dotEnv = dotEnvFile.existsSync()
        ? parseDotEnv(dotEnvFile.readAsStringSync())
        : const <String, String>{};

    final SiteBuildConfig config = SiteBuildConfig.resolve(
      processEnv: Platform.environment,
      dotEnv: dotEnv,
      registryVersion: registryVersion,
    );

    stdout
      ..writeln('Building the docs site')
      ..writeln('  origin            ${config.origin}')
      ..writeln('  base href         ${config.baseHref}')
      ..writeln('  registry version  ${config.registryVersion}')
      ..writeln(
        '  registry staging  ${stageRegistry ? 'enabled' : 'skipped (--no-stage-registry)'}',
      );

    final int buildExit = await _run('flutter', <String>[
      'build',
      'web',
      '--release',
      '--base-href',
      config.baseHref,
      '--dart-define=ELATTAR_SITE_ORIGIN=${config.origin}',
    ], workingDirectory: exampleDir.path);
    if (buildExit != 0) {
      stderr.writeln('flutter build web failed (exit $buildExit).');
      return buildExit;
    }

    if (!stageRegistry) {
      stdout.writeln('Build complete: ${_join(exampleDir, 'build/web')}');
      return 0;
    }

    final List<String> stageArgs = <String>[
      'run',
      'tool/release_registry/bin/stage.dart',
      '--version',
      config.registryVersion,
      '--web-root',
      'example/build/web',
      if (alias) '--alias',
    ];
    final int stageExit = await _run(
      'dart',
      stageArgs,
      workingDirectory: repoRoot.path,
    );
    if (stageExit != 0) {
      stderr.writeln('Staging the registry failed (exit $stageExit).');
      return stageExit;
    }

    stdout.writeln(
      'Site built and registry staged: ${_join(exampleDir, 'build/web')}',
    );
    return 0;
  } on BuildConfigException catch (error) {
    stderr.writeln('error: $error');
    return 65;
  }
}

/// Runs a subprocess with inherited stdio, so a slow `flutter build web`
/// (roughly three minutes) streams its own progress instead of going silent.
Future<int> _run(
  String executable,
  List<String> args, {
  required String workingDirectory,
}) async {
  stdout.writeln('\$ $executable ${args.join(' ')}');
  final Process process = await Process.start(
    executable,
    args,
    workingDirectory: workingDirectory,
    mode: ProcessStartMode.inheritStdio,
    runInShell: Platform.isWindows,
  );
  return process.exitCode;
}

String _join(Directory root, String relative) =>
    '${root.path.replaceAll(RegExp(r'[\\/]+$'), '')}'
    '${Platform.pathSeparator}'
    '${relative.replaceAll('/', Platform.pathSeparator)}';

void _usage() {
  stdout
    ..writeln('Builds the docs site and stages the versioned registry.')
    ..writeln()
    ..writeln('  --registry-version X.Y.Z   override the version read from')
    ..writeln('                             packages/elattar_cli identity.dart')
    ..writeln('  --no-stage-registry        build only, skip staging')
    ..writeln(
      '  --alias-registry           also write the mutable /registry/latest/',
    );
}
