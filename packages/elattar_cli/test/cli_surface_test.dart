/// The commands' contract with a project that is not in a good state.
///
/// Every case here was a way the CLI could report success, or crash with a raw
/// Dart stack trace, on a project a consumer could not build.
///
/// Commands that discover a project are run as real subprocesses with a
/// working directory rather than by moving `Directory.current`: `dart test`
/// shares one process across test-file isolates, so mutating the process
/// working directory corrupts every other test file running beside this one.
library;

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import '../lib/src/commands/app.dart';
import '../lib/src/config.dart';
import '../lib/src/identity.dart';
import '../lib/src/manifest.dart';

final String _packageRoot = Directory.current.absolute.path;
final String _repoRoot = Directory.current.parent.parent.absolute.path;
final String _registryPath = <String>[
  _repoRoot,
  'registry',
  'generated',
  'latest',
].join(Platform.pathSeparator);
final String _script = <String>[
  _packageRoot,
  'bin',
  'elattar.dart',
].join(Platform.pathSeparator);

const String _defaultPubspec = '''
name: surface_fixture
description: fixture
environment:
  sdk: ^3.12.2
dependencies:
  flutter:
    sdk: flutter
flutter:
''';

Directory _flutterProject({String pubspec = _defaultPubspec}) {
  final Directory root = Directory.systemTemp.createTempSync('elattar-cli-');
  File('${root.path}/pubspec.yaml').writeAsStringSync(pubspec);
  return root;
}

/// Writes the `.dart_tool/package_config.json` a successful `pub get` leaves,
/// naming exactly [resolved].
void _writePackageConfig(Directory root, List<String> resolved) {
  File('${root.path}/.dart_tool/package_config.json')
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(
      jsonEncode(<String, Object?>{
        'configVersion': 2,
        'packages': <Object?>[
          for (final String name in resolved)
            <String, Object?>{'name': name, 'rootUri': 'file:///$name'},
        ],
      }),
    );
}

void _writeSourceProject(Directory root) {
  File(
    '${root.path}/elattar.yaml',
  ).writeAsStringSync(const ElattarConfig().toYaml());
  ElattarManifest(
    foundation: FoundationMode.source,
    registry: null,
    items: const <InstalledItem>[],
  ).write(File('${root.path}/.elattar/manifest.json'));
}

Future<ProcessResult> _run(Directory project, List<String> arguments) {
  return Process.run(Platform.resolvedExecutable, <String>[
    _script,
    ...arguments,
  ], workingDirectory: project.path);
}

/// Captures a command that does not need a project on disk.
class _Capture {
  final List<String> out = <String>[];
  final List<String> err = <String>[];

  ElattarCli get cli => ElattarCli(stdoutSink: out.add, stderrSink: err.add);

  String get stdout => out.join('\n');
  String get stderr => err.join('\n');
}

void main() {
  setUpAll(() => expect(Directory(_registryPath).existsSync(), isTrue));

  group('package foundation mode is refused, not half-applied', () {
    test('init --foundation package changes nothing on disk', () async {
      final Directory root = _flutterProject();
      addTearDown(() => root.deleteSync(recursive: true));

      final ProcessResult result = await _run(root, <String>[
        'init',
        '--foundation',
        'package',
        '--registry',
        _registryPath,
      ]);

      expect(result.exitCode, 64, reason: '${result.stdout}${result.stderr}');
      expect('${result.stderr}', contains('elattar_core'));
      expect('${result.stderr}', contains('--foundation source'));
      // Nothing written: no config, no manifest, no pubspec edit, no sources.
      expect(File('${root.path}/elattar.yaml').existsSync(), isFalse);
      expect(File('${root.path}/.elattar/manifest.json').existsSync(), isFalse);
      expect(
        File('${root.path}/pubspec.yaml').readAsStringSync(),
        _defaultPubspec,
      );
      expect(Directory('${root.path}/lib').existsSync(), isFalse);
    });

    test('add refuses in a project whose config still says package', () async {
      final Directory root = _flutterProject();
      addTearDown(() => root.deleteSync(recursive: true));
      File('${root.path}/elattar.yaml').writeAsStringSync(
        const ElattarConfig(
          foundation: FoundationMode.package,
          packageName: 'elattar_core',
          packageVersion: '^0.0.1',
        ).toYaml(),
      );
      ElattarManifest(
        foundation: FoundationMode.package,
        registry: null,
        items: const <InstalledItem>[],
      ).write(File('${root.path}/.elattar/manifest.json'));

      final ProcessResult result = await _run(root, <String>[
        'add',
        'button',
        '--registry',
        _registryPath,
      ]);

      expect(result.exitCode, 78, reason: '${result.stdout}${result.stderr}');
      expect('${result.stderr}', contains('elattar_core'));
      expect(
        File('${root.path}/lib/components/ui/button.dart').existsSync(),
        isFalse,
      );
    });

    test('usage no longer offers the mode', () async {
      final _Capture capture = _Capture();
      await capture.cli.run(<String>['help']);
      expect(capture.stdout, contains('--foundation source]'));
      expect(capture.stdout, isNot(contains('source|package')));
    });
  });

  group('doctor', () {
    test('reports err when a declared dependency has not resolved', () async {
      final Directory root = _flutterProject(
        pubspec: '''
name: unresolved_fixture
description: fixture
environment:
  sdk: ^3.12.2
dependencies:
  flutter:
    sdk: flutter
  elattar_core: ^0.0.1
flutter:
''',
      );
      addTearDown(() => root.deleteSync(recursive: true));
      // What a failed `pub get` leaves behind: a package_config.json that does
      // not name the dependency pub could not resolve.
      _writePackageConfig(root, <String>['flutter']);
      _writeSourceProject(root);

      final ProcessResult result = await _run(root, <String>[
        'doctor',
        '--registry',
        _registryPath,
      ]);

      expect(result.exitCode, 1, reason: '${result.stdout}');
      expect('${result.stderr}', contains('err dependencies'));
      expect('${result.stderr}', contains('elattar_core'));
    });

    test('reports err when pub has never run', () async {
      final Directory root = _flutterProject();
      addTearDown(() => root.deleteSync(recursive: true));
      _writeSourceProject(root);

      final ProcessResult result = await _run(root, <String>[
        'doctor',
        '--registry',
        _registryPath,
      ]);

      expect(result.exitCode, 1, reason: '${result.stdout}');
      expect('${result.stderr}', contains('package_config.json'));
      expect('${result.stderr}', contains('flutter pub get'));
    });

    test('reports ok when every declared dependency resolved', () async {
      final Directory root = _flutterProject();
      addTearDown(() => root.deleteSync(recursive: true));
      _writePackageConfig(root, <String>['flutter']);
      _writeSourceProject(root);

      final ProcessResult result = await _run(root, <String>[
        'doctor',
        '--registry',
        _registryPath,
      ]);

      expect(result.exitCode, 0, reason: '${result.stderr}');
      expect('${result.stdout}', contains('ok  dependencies'));
    });

    test(
      'reports err for a project still configured for package mode',
      () async {
        final Directory root = _flutterProject();
        addTearDown(() => root.deleteSync(recursive: true));
        _writePackageConfig(root, <String>['flutter']);
        File('${root.path}/elattar.yaml').writeAsStringSync(
          const ElattarConfig(
            foundation: FoundationMode.package,
            packageName: 'elattar_core',
            packageVersion: '^0.0.1',
          ).toYaml(),
        );
        ElattarManifest(
          foundation: FoundationMode.package,
          registry: null,
          items: const <InstalledItem>[],
        ).write(File('${root.path}/.elattar/manifest.json'));

        final ProcessResult result = await _run(root, <String>[
          'doctor',
          '--registry',
          _registryPath,
        ]);

        expect(result.exitCode, 1, reason: '${result.stdout}');
        expect('${result.stderr}', contains('err config: foundation=package'));
      },
    );
  });

  group('registry values', () {
    test('add --all expands to the generated component inventory', () async {
      final Directory root = _flutterProject();
      addTearDown(() => root.deleteSync(recursive: true));
      _writePackageConfig(root, <String>['flutter']);

      final ProcessResult init = await _run(root, <String>[
        'init',
        '--registry',
        _registryPath,
      ]);
      expect(init.exitCode, 0, reason: '${init.stdout}${init.stderr}');

      final ProcessResult add = await _run(root, <String>[
        'add',
        '--all',
        '--dry-run',
        '--registry',
        _registryPath,
      ]);

      expect(add.exitCode, 0, reason: '${add.stdout}${add.stderr}');
      expect('${add.stdout}', contains('dry-run wrote'));
      expect('${add.stdout}', contains('lib/components/ui/accordion.dart'));
      expect('${add.stdout}', contains('lib/components/ui/rule.dart'));
      expect('${add.stdout}', contains('lib/components/ui/safe_area.dart'));
    });

    test('a registry scheme that is not http(s) is refused by name', () async {
      // The rule changed in 0.0.1: http and https are now real registry
      // sources. Everything else still has to fail as one sentence naming the
      // scheme, rather than reaching `Directory(...)` and surfacing as a raw
      // FileSystemException with a Dart stack attached.
      final _Capture capture = _Capture();
      final int code = await capture.cli.run(<String>[
        'list',
        '--registry',
        'ftp://example.invalid/registry',
      ]);

      expect(code, 64);
      expect(capture.stderr, contains('Unsupported registry scheme "ftp"'));
      expect(capture.stderr, contains('http/https'));
      expect(capture.stderr, isNot(contains('#0')));
      expect(capture.stderr, isNot(contains('FileSystemException')));
    });

    test('an unreachable https registry fails with a sentence too', () async {
      // The remote path is exercised properly against a local HttpServer in
      // `remote_registry_test.dart`. What matters here is the shape of the
      // failure a user sees when the host simply is not there.
      final _Capture capture = _Capture();
      final int code = await capture.cli.run(<String>[
        'list',
        '--registry',
        'https://registry.invalid/elattar/',
      ]);

      expect(code, 70, reason: capture.stderr);
      expect(capture.stderr, contains('registry.invalid'));
      expect(capture.stderr, contains('--offline'));
      expect(capture.stderr, isNot(contains('#0')));
      expect(capture.stderr, isNot(contains('SocketException')));
    });

    test('a Windows drive path is a path, not a URI scheme', () async {
      final _Capture capture = _Capture();
      final int code = await capture.cli.run(<String>[
        'list',
        '--registry',
        r'C:\definitely\not\here',
      ]);

      expect(code, 64);
      expect(capture.stderr, contains('Registry path does not exist'));
      expect(capture.stderr, isNot(contains('Unsupported registry scheme')));
    });

    test(
      'init writes no absolute path into the files a team commits',
      () async {
        final Directory root = _flutterProject();
        addTearDown(() => root.deleteSync(recursive: true));

        final ProcessResult result = await _run(root, <String>[
          'init',
          '--registry',
          _registryPath,
        ]);

        expect(result.exitCode, 0, reason: '${result.stderr}');
        final String config = File(
          '${root.path}/elattar.yaml',
        ).readAsStringSync();
        expect(config, isNot(contains(_repoRoot)));
        expect(config, isNot(contains('registry:')));
        expect('${result.stdout}', contains('note: the registry is outside'));
        final String manifest = File(
          '${root.path}/.elattar/manifest.json',
        ).readAsStringSync();
        expect(manifest, isNot(contains(_repoRoot)));
        expect(
          (jsonDecode(manifest) as Map<String, Object?>).containsKey(
            'registry',
          ),
          isFalse,
        );
      },
    );

    test('a registry under the project is recorded relative to it', () {
      expect(
        projectRelativeRegistry(
          r'C:\work\app',
          r'C:\work\app\vendor\registry\generated\latest',
        ),
        'vendor/registry/generated/latest',
      );
      expect(projectRelativeRegistry('/work/app', '/work/app/reg'), 'reg');
      expect(projectRelativeRegistry('/work/app/', '/work/app'), '.');
    });

    test('a registry outside the project is not recorded at all', () {
      expect(projectRelativeRegistry('/work/app', '/work/design-system'), null);
      expect(projectRelativeRegistry(r'C:\work\app', r'D:\el\registry'), null);
      // A sibling whose name merely starts with the project path is not inside
      // it.
      expect(projectRelativeRegistry('/work/app', '/work/app-2/reg'), null);
    });
  });

  group('config surface', () {
    test('paths: and barrels: are rejected instead of ignored', () {
      for (final String block in const <String>[
        'paths:\n  components: lib/vendor/elattar\n',
        'barrels:\n  components: lib/vendor/ui.dart\n',
      ]) {
        expect(
          () => ElattarConfig.fromYaml('schema: $configSchemaUri\n$block'),
          throwsA(
            isA<ElattarConfigException>().having(
              (ElattarConfigException error) => error.message,
              'message',
              allOf(
                contains('no longer supports'),
                contains('.elattar/manifest.json'),
              ),
            ),
          ),
        );
      }
    });

    test('a written config round trips and publishes only real keys', () {
      final String yaml = const ElattarConfig(
        registry: 'vendor/registry/generated/latest',
      ).toYaml();
      final YamlMap parsed = loadYaml(yaml) as YamlMap;
      expect(parsed.keys.toSet(), <String>{
        'schema',
        'registry',
        'foundation',
        'style',
      });
      final ElattarConfig reparsed = ElattarConfig.fromYaml(yaml);
      expect(reparsed.registry, 'vendor/registry/generated/latest');
      expect(reparsed.foundation, FoundationMode.source);
      // The fixed install locations are the mapper's, not the file's.
      expect(reparsed.componentsPath, 'lib/components/ui');
      expect(reparsed.foundationPath, 'lib/design_system/foundation');
    });
  });
}
