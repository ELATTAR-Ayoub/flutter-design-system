/// The release candidate a stranger actually gets, rehearsed end to end.
///
/// `dart run tool/release_audit/bin/isolated_consumer.dart [options]`
///
/// Everything CI checks runs against the monorepo: `packages/elattar_cli` with
/// the checkout beside it, and `registry/generated/latest` on the same disk.
/// A published release has neither. Two failures live only in that gap — a CLI
/// that needs a file the publish archive leaves behind, and a registry the CLI
/// can only find because it was standing in the repository — and both of them
/// look like success from inside the repository.
///
/// So this rig assembles the CLI from the publish archive's contents alone,
/// resolves it on its own, serves the registry over HTTP, and drives a clean
/// Flutter consumer through the whole published quickstart. Every step's exit
/// code is printed, and the ones that must fail are asserted to fail.
///
/// Options:
///   --repo <dir>       repository root (default: the working directory)
///   --registry <dir>   registry to serve (default: registry/generated/latest)
///   --keep             leave the scratch tree behind for inspection
///   --skip-build       skip the consumer release web build (the slow step)
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../registry_builder/lib/generator.dart' show sha256Hex;

/// Top-level entries `packages/elattar_cli/.pubignore` keeps out of the
/// archive. Stated here so the rig can assert the copy it built is the archive
/// rather than assuming it; `dart pub publish --dry-run`, run inside the copy,
/// is the independent second opinion.
const List<String> _excludedEntries = <String>[
  'test',
  '.dart_tool',
  'pubspec.lock',
  'analysis_options.yaml',
  '.pubignore',
];

const String _consumerName = 'elattar_isolated_consumer';

const String _consumerPubspec =
    '''
name: $_consumerName
description: A clean consumer of the published Elattar registry.
publish_to: none
version: 0.0.1

environment:
  sdk: ^3.12.2

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  # `flutter create` writes an analysis_options.yaml that includes
  # `package:flutter_lints/flutter.yaml`. Keeping the dependency rather than
  # deleting that file is the harder test: the installed sources are then
  # analysed under the same lint set the repository holds itself to, in a
  # project that is not the repository.
  flutter_lints: ^6.0.0

flutter:
''';

const String _consumerMain =
    '''
import 'package:flutter/widgets.dart';

import 'package:$_consumerName/components/ui/ui.dart';
import 'package:$_consumerName/design_system/foundation.dart';

void main() => runApp(
  ElTheme(
    controller: ElThemeController(mode: ElThemeMode.dark),
    child: WidgetsApp(
      color: const Color(0xFF000000),
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
          PageRouteBuilder<T>(
            settings: settings,
            pageBuilder:
                (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondary,
                ) => builder(context),
          ),
      home: Center(
        child: ElButton(onPressed: () {}, child: const Text('Install me')),
      ),
    ),
  ),
);
''';

const String _consumerTest =
    '''
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:$_consumerName/components/ui/ui.dart';
import 'package:$_consumerName/design_system/foundation.dart';

void main() {
  testWidgets('every installed component resolves and a button paints', (
    WidgetTester tester,
  ) async {
    int presses = 0;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(1440, 900)),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: ElTheme(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: Center(
              child: ElButton(
                onPressed: () => presses++,
                child: const Text('Install me'),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Install me'), findsOneWidget);
    expect(tester.getSize(find.byType(ElButton)).height, el(10));

    await tester.tap(find.byType(ElButton));
    await tester.pump();
    expect(presses, 1);
  });
}
''';

/// One executed step and what it produced.
class _Step {
  _Step(this.name, this.exitCode, this.seconds, {this.note = ''});

  final String name;
  final int exitCode;
  final double seconds;
  final String note;
}

final List<_Step> _transcript = <_Step>[];
final Stopwatch _clock = Stopwatch()..start();
bool _failed = false;

void _record(
  String name,
  int code, {
  String note = '',
  bool expectFailure = false,
}) {
  final bool ok = expectFailure ? code != 0 : code == 0;
  _transcript.add(
    _Step(name, code, _clock.elapsedMilliseconds / 1000, note: note),
  );
  final String verdict = ok ? 'ok  ' : 'FAIL';
  stdout.writeln(
    '$verdict $name  (exit $code${expectFailure ? ', a failure was required' : ''})'
    '${note.isEmpty ? '' : '\n       $note'}',
  );
  if (!ok) _failed = true;
}

void _assert(String name, bool condition, {String note = ''}) =>
    _record(name, condition ? 0 : 1, note: note);

// ─────────────────────────────────────────────────────────────────────────────

Future<void> main(List<String> arguments) async {
  String repo = Directory.current.path;
  String? registryArgument;
  bool keep = false;
  bool skipBuild = false;

  for (int i = 0; i < arguments.length; i++) {
    switch (arguments[i]) {
      case '--repo':
        repo = arguments[++i];
      case '--registry':
        registryArgument = arguments[++i];
      case '--keep':
        keep = true;
      case '--skip-build':
        skipBuild = true;
      default:
        stderr.writeln('unknown option: ${arguments[i]}');
        exit(64);
    }
  }

  final Directory registry = Directory(
    registryArgument ?? _join(repo, 'registry/generated/latest'),
  );
  if (!File(_join(registry.path, 'registry.json')).existsSync()) {
    stderr.writeln('no registry.json under ${registry.path}');
    exit(66);
  }

  final Directory scratch = Directory.systemTemp.createTempSync(
    'elattar-isolated-',
  );
  stdout.writeln('repository : $repo');
  stdout.writeln('registry   : ${registry.path}');
  stdout.writeln('scratch    : ${scratch.path}');
  stdout.writeln(
    'platform   : ${Platform.operatingSystem} '
    '${Platform.operatingSystemVersion}',
  );
  stdout.writeln('');

  final Directory cli = Directory(_join(scratch.path, 'cli'))
    ..createSync(recursive: true);
  final Directory consumer = Directory(_join(scratch.path, 'consumer'))
    ..createSync(recursive: true);
  final Directory cache = Directory(_join(scratch.path, 'cache'))
    ..createSync(recursive: true);

  // ── 1. the CLI, assembled from the publish archive alone ─────────────────
  final Directory source = Directory(_join(repo, 'packages/elattar_cli'));
  int copied = 0;
  for (final FileSystemEntity entry in source.listSync()) {
    final String name = _basename(entry.path);
    if (_excludedEntries.contains(name)) continue;
    copied += _copyInto(entry, cli.path);
  }
  _assert(
    'the isolated CLI carries $copied files and none of the excluded ones',
    copied > 0 &&
        !Directory(_join(cli.path, 'test')).existsSync() &&
        !File(_join(cli.path, 'pubspec.lock')).existsSync() &&
        !File(_join(cli.path, 'analysis_options.yaml')).existsSync(),
  );
  for (final String required in const <String>[
    'pubspec.yaml',
    'README.md',
    'CHANGELOG.md',
    'LICENSE',
    'bin/elattar.dart',
  ]) {
    _assert(
      'the archive contains $required',
      File(_join(cli.path, required)).existsSync(),
    );
  }

  // pub's own opinion of the copy, independent of the exclusion list above.
  final ProcessResult dryRun = await _run('dart', <String>[
    'pub',
    'publish',
    '--dry-run',
  ], cli.path);
  final String dryRunOutput = '${dryRun.stdout}${dryRun.stderr}';
  _record(
    'the isolated copy still validates as a publishable package',
    dryRun.exitCode,
    note: dryRunOutput
        .split('\n')
        .where((String line) => line.contains('warning'))
        .join(' | '),
  );

  _record(
    'the isolated CLI resolves its dependencies alone',
    (await _run('dart', <String>['pub', 'get'], cli.path)).exitCode,
  );

  // ── 2. the registry, over HTTP, exactly as Pages will serve it ───────────
  final _Server server = await _Server.start(registry);
  final String registryUrl = server.baseUri.toString();
  stdout.writeln('serving    : $registryUrl\n');

  final String elattarScript = _join(cli.path, 'bin/elattar.dart');
  final Map<String, String> env = <String, String>{
    'ELATTAR_CACHE_DIR': cache.path,
  };

  Future<ProcessResult> elattar(List<String> args, {bool offline = false}) =>
      _run(
        Platform.resolvedExecutable,
        <String>[
          elattarScript,
          ...args,
          if (!offline) ...<String>['--registry', registryUrl],
          if (offline) ...<String>['--registry', registryUrl, '--offline'],
        ],
        consumer.path,
        environment: env,
      );

  Future<ProcessResult> flutter(List<String> args) =>
      _run(Platform.isWindows ? 'flutter.bat' : 'flutter', args, consumer.path);

  // A real consumer starts from `flutter create`, not from a hand-written
  // pubspec — and without it the project has no `web/` directory, so the
  // release web build at the end has nothing to build into.
  final ProcessResult create = await flutter(<String>[
    'create',
    '--platforms',
    'web',
    '--project-name',
    _consumerName,
    '.',
  ]);
  _record(
    'flutter create --platforms web',
    create.exitCode,
    note: create.exitCode == 0 ? '' : '${create.stdout}\n${create.stderr}',
  );

  // Its scaffolding is then replaced by ours: our pubspec, our entrypoint, and
  // none of the generated counter-app test, which tests a widget we deleted.
  File(
    _join(consumer.path, 'pubspec.yaml'),
  ).writeAsStringSync(_consumerPubspec);
  final File generatedTest = File(
    _join(consumer.path, 'test/widget_test.dart'),
  );
  if (generatedTest.existsSync()) generatedTest.deleteSync();

  // ── 3. the quickstart, in order, with the dry runs proved inert ──────────
  final String beforeInit = _fingerprint(consumer);
  _record(
    'init --dry-run',
    (await elattar(<String>['init', '--dry-run'])).exitCode,
  );
  _assert(
    'init --dry-run mutated nothing',
    _fingerprint(consumer) == beforeInit,
  );

  _record('init', (await elattar(<String>['init'])).exitCode);

  final String beforeAdd = _fingerprint(consumer);
  _record(
    'add --all --dry-run',
    (await elattar(<String>['add', '--all', '--dry-run'])).exitCode,
  );
  _assert(
    'add --all --dry-run mutated nothing',
    _fingerprint(consumer) == beforeAdd,
  );

  final ProcessResult addAll = await elattar(<String>['add', '--all']);
  _record(
    'add --all',
    addAll.exitCode,
    note: addAll.exitCode == 0 ? '' : '${addAll.stdout}\n${addAll.stderr}',
  );

  _assert(
    'the payload came over the wire',
    server.requests.any((String p) => p.endsWith('/index.json')) &&
        server.requests.where((String p) => p.contains('/versions/')).length >
            1,
    note: '${server.requests.length} requests served',
  );

  final ProcessResult resolve = await flutter(<String>['pub', 'get']);
  _record(
    'flutter pub get',
    resolve.exitCode,
    note: resolve.exitCode == 0 ? '' : '${resolve.stdout}\n${resolve.stderr}',
  );

  final ProcessResult doctor = await elattar(<String>['doctor']);
  _record(
    'doctor',
    doctor.exitCode,
    note: doctor.exitCode == 0 ? '' : '${doctor.stdout}\n${doctor.stderr}',
  );

  // ── 4. offline is a cache, not a flag ────────────────────────────────────
  final ProcessResult offlineHit = await elattar(<String>[
    'list',
  ], offline: true);
  _record(
    'list --offline, from the populated cache',
    offlineHit.exitCode,
    note: offlineHit.exitCode == 0
        ? ''
        : '${offlineHit.stdout}\n${offlineHit.stderr}',
  );

  cache.deleteSync(recursive: true);
  final ProcessResult offlineMiss = await elattar(<String>[
    'list',
  ], offline: true);
  _record(
    'list --offline after the cache is removed must fail',
    offlineMiss.exitCode,
    expectFailure: true,
    note: '${offlineMiss.stderr}'.trim().split('\n').first,
  );

  // ── 5. the consumer is a real Flutter project ────────────────────────────
  File(_join(consumer.path, 'lib/main.dart'))
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(_consumerMain);
  File(_join(consumer.path, 'test/installed_test.dart'))
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(_consumerTest);

  final ProcessResult analyze = await flutter(<String>['analyze']);
  _record(
    'consumer flutter analyze',
    analyze.exitCode,
    note: analyze.exitCode == 0
        ? '${analyze.stdout}'.trim().split('\n').last
        : '${analyze.stdout}\n${analyze.stderr}',
  );

  final ProcessResult widgetTest = await flutter(<String>['test']);
  _record(
    'consumer flutter test',
    widgetTest.exitCode,
    note: '${widgetTest.stdout}${widgetTest.stderr}'
        .trim()
        .split('\n')
        .lastWhere((String line) => line.trim().isNotEmpty, orElse: () => ''),
  );

  if (!skipBuild) {
    final ProcessResult build = await flutter(<String>[
      'build',
      'web',
      '--release',
    ]);
    _record(
      'consumer flutter build web --release',
      build.exitCode,
      note: build.exitCode == 0 ? '' : '${build.stdout}\n${build.stderr}',
    );
  }

  await server.stop();

  // ── the transcript ───────────────────────────────────────────────────────
  stdout.writeln('\n--- transcript ---');
  for (final _Step step in _transcript) {
    stdout.writeln(
      '${step.seconds.toStringAsFixed(1).padLeft(7)}s  '
      'exit ${step.exitCode}  ${step.name}',
    );
  }
  stdout.writeln(
    '\n${_transcript.length} steps in '
    '${(_clock.elapsedMilliseconds / 1000).toStringAsFixed(1)}s on '
    '${Platform.operatingSystem}.',
  );

  if (keep) {
    stdout.writeln('scratch kept at ${scratch.path}');
  } else {
    try {
      scratch.deleteSync(recursive: true);
    } on FileSystemException {
      stdout.writeln('scratch could not be removed: ${scratch.path}');
    }
  }

  exit(_failed ? 1 : 0);
}

// ─────────────────────────────────────────────────────────────────────────────

/// A content fingerprint of every file in [root], so a `--dry-run` that
/// promises to change nothing can be held to it.
String _fingerprint(Directory root) {
  final List<String> lines = <String>[];
  for (final FileSystemEntity entry in root.listSync(recursive: true)) {
    if (entry is! File) continue;
    final String relative = entry.path
        .substring(root.path.length)
        .replaceAll('\\', '/');
    lines.add('$relative ${sha256Hex(entry.readAsBytesSync())}');
  }
  lines.sort();
  return sha256Hex(utf8.encode(lines.join('\n')));
}

int _copyInto(FileSystemEntity entry, String destination) {
  if (entry is File) {
    final File target = File(_join(destination, _basename(entry.path)))
      ..parent.createSync(recursive: true);
    target.writeAsBytesSync(entry.readAsBytesSync());
    return 1;
  }
  if (entry is Directory) {
    final String child = _join(destination, _basename(entry.path));
    Directory(child).createSync(recursive: true);
    int count = 0;
    for (final FileSystemEntity inner in entry.listSync()) {
      count += _copyInto(inner, child);
    }
    return count;
  }
  return 0;
}

String _join(String a, String b) =>
    '$a${Platform.pathSeparator}${b.replaceAll('/', Platform.pathSeparator)}';

String _basename(String path) =>
    path.split(Platform.pathSeparator).last.split('/').last;

Future<ProcessResult> _run(
  String executable,
  List<String> arguments,
  String workingDirectory, {
  Map<String, String>? environment,
}) => Process.run(
  executable,
  arguments,
  workingDirectory: workingDirectory,
  environment: environment,
  runInShell: Platform.isWindows && !executable.endsWith('.exe'),
);

/// Serves a directory under `/registry/`, the shape Pages will publish.
class _Server {
  _Server._(this._server, this._root, this.baseUri);

  static Future<_Server> start(Directory root) async {
    final HttpServer server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    final _Server instance = _Server._(
      server,
      root,
      Uri.parse('http://${server.address.address}:${server.port}/registry/'),
    );
    unawaited(instance._serve());
    return instance;
  }

  final HttpServer _server;
  final Directory _root;
  final Uri baseUri;
  final List<String> requests = <String>[];

  Future<void> _serve() async {
    await for (final HttpRequest request in _server) {
      final String path = request.uri.path;
      requests.add(path);
      const String prefix = '/registry/';
      if (!path.startsWith(prefix)) {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
        continue;
      }
      final File file = File(_join(_root.path, path.substring(prefix.length)));
      if (!file.existsSync()) {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
        continue;
      }
      request.response
        ..statusCode = HttpStatus.ok
        ..add(file.readAsBytesSync());
      await request.response.close();
    }
  }

  Future<void> stop() => _server.close(force: true);
}
