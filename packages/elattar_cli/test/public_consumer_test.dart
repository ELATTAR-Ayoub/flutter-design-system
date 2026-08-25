/// What a public user actually does, end to end, against the real artifact.
///
/// The other suites each prove one segment: `remote_registry_test.dart` proves
/// the commands work against a URL, `cli_integration_test.dart` proves a local
/// registry install analyses, `shot_install_test.dart` proves the `shot` item
/// kind survives generate → validate → install → analyse against a *synthetic*
/// registry it builds for itself.
///
/// None of them was the thing CI advertised it had: a consumer that receives
/// this repository's own generated registry over HTTP, the way a released CLI
/// receives it from Pages, and then **runs**. Analysis is not running. A
/// project can analyse clean and still fail to build a single widget, because
/// a font family is a string, an asset path is a string, and a barrel export
/// that resolves is not the same as a widget that paints.
///
/// So this test ends with `flutter test` inside the installed consumer, on a
/// widget composed from the installed barrels. That is the last claim the
/// release makes to a stranger, and it is now the one CI checks.
library;

import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

/// The consumer package name. A Dart identifier, because the widget test
/// imports the installed barrels through `package:` URIs — which is what a
/// real consumer's own test would do.
const String _consumerName = 'elattar_public_consumer';

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

flutter:
''';

/// A widget test written the way a consumer would write one: through the
/// generated barrels, with no `package:elattar_design_system` anywhere.
const String _consumerWidgetTest =
    '''
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:$_consumerName/components/ui/ui.dart';
import 'package:$_consumerName/design_system/foundation.dart';

void main() {
  testWidgets('an installed ElButton builds, paints and reports its press', (
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

/// Serves a directory under `/registry/`, the shape the CLI expects a hosted
/// registry to have.
class _StaticRegistryServer {
  _StaticRegistryServer._(this._server, this._root, this.baseUri);

  static Future<_StaticRegistryServer> start(Directory root) async {
    final HttpServer server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    final _StaticRegistryServer instance = _StaticRegistryServer._(
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

  /// Every path requested, in order. Asserted on, so that a passing run
  /// cannot be one that quietly fell back to a local directory.
  final List<String> requests = <String>[];

  Future<void> _serve() async {
    await for (final HttpRequest request in _server) {
      requests.add(request.uri.path);
      const String prefix = '/registry/';
      final String path = request.uri.path;
      if (!path.startsWith(prefix)) {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
        continue;
      }
      final File file = File(
        '${_root.path}${Platform.pathSeparator}'
        '${path.substring(prefix.length).replaceAll('/', Platform.pathSeparator)}',
      );
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

void main() {
  test('a clean consumer installs this repository\'s registry over HTTP, then '
      'analyses and runs', () async {
    final Directory packageRoot = Directory.current.absolute;
    final Directory repoRoot = packageRoot.parent.parent.absolute;
    final Directory registry = Directory(
      <String>[
        repoRoot.path,
        'registry',
        'generated',
        'latest',
      ].join(Platform.pathSeparator),
    );
    expect(
      registry.existsSync(),
      isTrue,
      reason:
          'run `dart run tool/registry_builder/bin/build.dart .` from the '
          'repository root first',
    );

    final _StaticRegistryServer server = await _StaticRegistryServer.start(
      registry,
    );
    addTearDown(server.stop);

    final Directory consumer = await Directory.systemTemp.createTemp(
      'elattar-public-consumer-',
    );
    addTearDown(() {
      try {
        consumer.deleteSync(recursive: true);
      } on FileSystemException {
        // A Windows runner sometimes still holds the analysis server's
        // handle on the temp tree. Losing a temp directory is not a
        // reason to fail a release gate.
      }
    });

    final File pubspec = File('${consumer.path}/pubspec.yaml');
    await pubspec.writeAsString(_consumerPubspec);

    final String script = <String>[
      packageRoot.path,
      'bin',
      'elattar.dart',
    ].join(Platform.pathSeparator);

    Future<ProcessResult> elattar(List<String> arguments) => Process.run(
      Platform.resolvedExecutable,
      <String>[script, ...arguments, '--registry', '${server.baseUri}'],
      workingDirectory: consumer.path,
    );

    Future<ProcessResult> flutter(List<String> arguments) => Process.run(
      Platform.isWindows ? 'flutter.bat' : 'flutter',
      arguments,
      workingDirectory: consumer.path,
    );

    // ── install, exactly as the quickstart tells a stranger to ───────────
    final ProcessResult init = await elattar(<String>['init']);
    expect(
      init.exitCode,
      0,
      reason: 'init\nstdout:\n${init.stdout}\nstderr:\n${init.stderr}',
    );

    final ProcessResult add = await elattar(<String>['add', 'button']);
    expect(
      add.exitCode,
      0,
      reason: 'add button\nstdout:\n${add.stdout}\nstderr:\n${add.stderr}',
    );

    // `doctor` checks that the declared dependencies have actually resolved,
    // so it belongs after the resolve — which is the order the quickstart puts
    // them in, and the order a person follows.
    final ProcessResult resolve = await flutter(<String>['pub', 'get']);
    expect(
      resolve.exitCode,
      0,
      reason: 'pub get\n${resolve.stdout}\n${resolve.stderr}',
    );

    final ProcessResult doctor = await elattar(<String>['doctor']);
    expect(
      doctor.exitCode,
      0,
      reason: 'doctor\nstdout:\n${doctor.stdout}\nstderr:\n${doctor.stderr}',
    );

    // The payload really came over the wire. Without this, a regression
    // that silently discovered a local registry would still pass every
    // assertion below.
    expect(
      server.requests,
      contains('/registry/index.json'),
      reason: 'the CLI never fetched the served index',
    );
    expect(
      server.requests.where(
        (String path) => path.contains('/versions/button/'),
      ),
      isNotEmpty,
      reason: 'button\'s payload was not fetched from the server',
    );

    // The config a consumer commits records the URL, never a path on the
    // machine that ran the install.
    final String config = await File(
      '${consumer.path}/elattar.yaml',
    ).readAsString();
    expect(() => loadYaml(config), returnsNormally);
    expect(config, contains('${server.baseUri}'));
    expect(config, isNot(contains(repoRoot.path)));

    for (final String installed in <String>[
      'lib/components/ui/ui.dart',
      'lib/components/ui/button.dart',
      'lib/design_system/foundation.dart',
      'assets/elattar/fonts/InterVariable.ttf',
      'LICENSES/ELATTAR-MIT.txt',
      'LICENSES/Lucide-ISC.txt',
      '.elattar/manifest.json',
    ]) {
      expect(
        File('${consumer.path}/$installed').existsSync(),
        isTrue,
        reason: '$installed was not installed',
      );
    }

    // ── the two gates that are not the same gate ─────────────────────────
    await (File(
      '${consumer.path}/test/installed_button_test.dart',
    )..parent.createSync(recursive: true)).writeAsString(_consumerWidgetTest);

    final ProcessResult analyze = await flutter(<String>['analyze']);
    expect(
      analyze.exitCode,
      0,
      reason: 'analyze\n${analyze.stdout}\n${analyze.stderr}',
    );
    // Guard against a silently-skipped gate: prove the analyzer reported on
    // this project rather than exiting 0 for some other reason.
    expect(analyze.stdout.toString(), contains('No issues found!'));

    final ProcessResult widgetTest = await flutter(<String>['test']);
    expect(
      widgetTest.exitCode,
      0,
      reason: 'flutter test\n${widgetTest.stdout}\n${widgetTest.stderr}',
    );
    expect(
      '${widgetTest.stdout}${widgetTest.stderr}',
      contains('All tests passed'),
      reason:
          'flutter test exited 0 without reporting a passing suite, which '
          'is what a silently-empty test directory looks like',
    );
  }, timeout: const Timeout(Duration(minutes: 10)));
}
