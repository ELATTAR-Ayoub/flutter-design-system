/// The hosted-registry path, end to end, without touching the internet.
///
/// Everything here runs against a local [HttpServer] serving this
/// repository's own generated registry. That is deliberate on two counts: CI
/// must not depend on a live host, and the bytes under test are the exact
/// bytes the release will publish, so a passing suite says something about
/// the real artifact rather than about a fixture.
///
/// The gate this suite exists to prove: a CLI with no checkout beside it can
/// run `init`, `list`, `search`, `info`, `add`, `add --all` and `doctor`
/// against a URL.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../lib/src/commands/app.dart';
import '../lib/src/registry/http_fetcher.dart';
import '../lib/src/registry/source.dart';

/// Serves a directory over HTTP, and lets a test bend the responses.
class _RegistryServer {
  _RegistryServer._(this._server, this.root, this.baseUri);

  static Future<_RegistryServer> start(Directory root) async {
    final HttpServer server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    final _RegistryServer instance = _RegistryServer._(
      server,
      root,
      Uri.parse('http://${server.address.address}:${server.port}/registry/'),
    );
    unawaited(instance._serve());
    return instance;
  }

  final HttpServer _server;
  final Directory root;
  final Uri baseUri;

  /// Requested paths, in order. Lets a test prove the cache prevented a
  /// second fetch rather than merely returning the right bytes.
  final List<String> requests = <String>[];

  /// Path suffix -> replacement body. Used to serve a corrupted payload.
  final Map<String, List<int>> tamper = <String, List<int>>{};

  /// Path suffix -> status code to return instead of the file.
  final Map<String, int> statusOverrides = <String, int>{};

  /// Path suffix -> Location header, for redirect tests.
  final Map<String, String> redirects = <String, String>{};

  /// When set, every response stalls this long before its first byte.
  Duration? stall;

  Future<void> _serve() async {
    await for (final HttpRequest request in _server) {
      final String path = request.uri.path;
      requests.add(path);
      final Duration? delay = stall;
      if (delay != null) await Future<void>.delayed(delay);

      final String? redirect = _matching(redirects, path);
      if (redirect != null) {
        request.response
          ..statusCode = HttpStatus.movedPermanently
          ..headers.set(HttpHeaders.locationHeader, redirect);
        await request.response.close();
        continue;
      }

      final int? status = _matchingInt(statusOverrides, path);
      if (status != null) {
        request.response.statusCode = status;
        await request.response.close();
        continue;
      }

      final List<int>? forged = _matchingBytes(tamper, path);
      if (forged != null) {
        request.response
          ..statusCode = HttpStatus.ok
          ..add(forged);
        await request.response.close();
        continue;
      }

      // `/registry/<relative>` maps onto the served directory.
      const String prefix = '/registry/';
      if (!path.startsWith(prefix)) {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
        continue;
      }
      final File file = File(
        '${root.path}${Platform.pathSeparator}'
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

  String? _matching(Map<String, String> map, String path) {
    for (final MapEntry<String, String> entry in map.entries) {
      if (path.endsWith(entry.key)) return entry.value;
    }
    return null;
  }

  int? _matchingInt(Map<String, int> map, String path) {
    for (final MapEntry<String, int> entry in map.entries) {
      if (path.endsWith(entry.key)) return entry.value;
    }
    return null;
  }

  List<int>? _matchingBytes(Map<String, List<int>> map, String path) {
    for (final MapEntry<String, List<int>> entry in map.entries) {
      if (path.endsWith(entry.key)) return entry.value;
    }
    return null;
  }

  Future<void> close() => _server.close(force: true);
}

class _Run {
  _Run(this.exitCode, this.stdout, this.stderr);

  final int exitCode;
  final String stdout;
  final String stderr;

  String get all => '$stdout$stderr';
}

void main() {
  late Directory generated;
  late _RegistryServer server;
  late Directory workspace;
  late Directory project;
  late Directory cache;

  setUpAll(() {
    // `dart test` runs with the package as the working directory. Resolved to
    // an absolute path immediately: `run` below changes `Directory.current` to
    // the temporary consumer project, and a relative root would then point
    // somewhere that does not exist.
    generated = Directory('../../registry/generated/latest').absolute;
    expect(
      generated.existsSync(),
      isTrue,
      reason:
          'the generated registry must exist; run '
          '`dart run tool/registry_builder/bin/build.dart .` first',
    );
  });

  setUp(() async {
    server = await _RegistryServer.start(generated);
    workspace = Directory.systemTemp.createTempSync('elattar-remote-');
    project = Directory('${workspace.path}/app')..createSync(recursive: true);
    cache = Directory('${workspace.path}/cache');
    File('${project.path}/pubspec.yaml').writeAsStringSync(
      'name: demo_app\n'
      'environment:\n'
      '  sdk: ^3.12.2\n'
      'dependencies:\n'
      '  flutter:\n'
      '    sdk: flutter\n',
    );
    Directory('${project.path}/lib').createSync();
  });

  tearDown(() async {
    await server.close();
    workspace.deleteSync(recursive: true);
  });

  /// Runs the CLI inside [project], against the test server.
  Future<_Run> run(
    List<String> arguments, {
    Uri? base,
    Directory? cacheDirectory,
    bool useRealFetcher = false,
  }) async {
    final StringBuffer out = StringBuffer();
    final StringBuffer err = StringBuffer();
    // `workingDirectory` rather than assigning `Directory.current`.
    // `Directory.current` is process-wide, and `dart test` runs test files in
    // separate isolates of one process — setting it here reached into every
    // other suite running concurrently and broke one of them.
    final ElattarCli cli = ElattarCli(
      stdoutSink: out.writeln,
      stderrSink: err.writeln,
      fetcher: useRealFetcher ? null : httpRegistryFetcher(),
      cacheDirectory: cacheDirectory ?? cache,
      workingDirectory: project,
    );
    final int code = await cli.run(<String>[
      ...arguments,
      '--registry',
      (base ?? server.baseUri).toString(),
    ]);
    return _Run(code, '$out', '$err');
  }

  group('read-only commands work against a URL', () {
    test('list returns the whole catalog', () async {
      final _Run result = await run(<String>['list']);
      expect(result.exitCode, 0, reason: result.all);
      expect(result.stdout, contains('button'));
      expect(result.stdout, contains('source-foundation'));
    });

    test('search finds an item', () async {
      final _Run result = await run(<String>['search', 'accordion']);
      expect(result.exitCode, 0, reason: result.all);
      expect(result.stdout, contains('accordion'));
    });

    test('info reports one item', () async {
      final _Run result = await run(<String>['info', 'button']);
      expect(result.exitCode, 0, reason: result.all);
      expect(result.stdout, contains('button'));
    });

    test('an unknown item is a clean not-found, not a crash', () async {
      final _Run result = await run(<String>['info', 'no-such-item']);
      expect(result.exitCode, 66, reason: result.all);
      expect(result.all, isNot(contains('#0')));
    });
  });

  group('install works against a URL', () {
    test(
      'init installs the foundation and pins the URL in elattar.yaml',
      () async {
        final _Run result = await run(<String>[
          'init',
          '--foundation',
          'source',
        ]);
        expect(result.exitCode, 0, reason: result.all);

        expect(
          File(
            '${project.path}/lib/design_system/foundation/colors.dart',
          ).existsSync(),
          isTrue,
        );
        // The config a team commits records the URL, because a URL is portable.
        final String config = File(
          '${project.path}/elattar.yaml',
        ).readAsStringSync();
        expect(config, contains('registry: ${server.baseUri}'));
        expect(config, contains('foundation: source'));
      },
    );

    test('init delivers the notices a foundation install requires', () async {
      await run(<String>['init', '--foundation', 'source']);
      for (final String notice in <String>[
        'ELATTAR-MIT.txt',
        'Inter-OFL-1.1.txt',
        'Geist-Mono-OFL-1.1.txt',
        'Redaction-OFL-1.1.txt',
      ]) {
        expect(
          File('${project.path}/LICENSES/$notice').existsSync(),
          isTrue,
          reason: '$notice was not installed',
        );
      }
    });

    test('add installs a component and its dependencies', () async {
      await run(<String>['init', '--foundation', 'source']);
      final _Run result = await run(<String>['add', 'button']);
      expect(result.exitCode, 0, reason: result.all);
      expect(
        File('${project.path}/lib/components/ui/button.dart').existsSync(),
        isTrue,
      );
      // `button` depends on `icon`, which redistributes lucide geometry.
      expect(
        File('${project.path}/LICENSES/Lucide-ISC.txt').existsSync(),
        isTrue,
      );
    });

    test('installed source carries no package import', () async {
      await run(<String>['init', '--foundation', 'source']);
      await run(<String>['add', 'button']);
      final String source = File(
        '${project.path}/lib/components/ui/button.dart',
      ).readAsStringSync();
      expect(source, isNot(contains('package:elattar_design_system')));
    });

    test('add --all installs the whole registry', () async {
      await run(<String>['init', '--foundation', 'source']);
      final _Run result = await run(<String>['add', '--all']);
      expect(result.exitCode, 0, reason: result.stderr);
      final int installed = Directory('${project.path}/lib/components/ui')
          .listSync()
          .whereType<File>()
          .where((File file) => file.path.endsWith('.dart'))
          .length;
      // 84 components plus the generated barrel; asserted as a floor so the
      // test does not have to be edited every time an item is added.
      expect(installed, greaterThan(80));
    });

    test('dry-run mutates nothing', () async {
      final _Run result = await run(<String>[
        'init',
        '--foundation',
        'source',
        '--dry-run',
      ]);
      expect(result.exitCode, 0, reason: result.all);
      expect(File('${project.path}/elattar.yaml').existsSync(), isFalse);
      expect(Directory('${project.path}/LICENSES').existsSync(), isFalse);
      expect(
        Directory('${project.path}/lib/design_system').existsSync(),
        isFalse,
      );
    });
  });

  group('integrity is enforced on every fetched byte', () {
    test('a tampered payload aborts the install', () async {
      await run(<String>['init', '--foundation', 'source']);
      server.tamper['/logical/ui/button.dart'] = utf8.encode(
        '// not the file you verified\n',
      );

      final _Run result = await run(<String>['add', 'button']);
      expect(result.exitCode, 65, reason: result.all);
      expect(result.stderr, contains('RegistryIntegrityException'));
    });

    test('a tampered payload leaves the project untouched', () async {
      await run(<String>['init', '--foundation', 'source']);
      server.tamper['/logical/ui/button.dart'] = utf8.encode('// forged\n');
      await run(<String>['add', 'button']);

      // Verification happens before the first write, so nothing lands — not
      // even the item's siblings that verified fine.
      expect(
        File('${project.path}/lib/components/ui/button.dart').existsSync(),
        isFalse,
      );
      expect(
        File('${project.path}/lib/components/ui/icon.dart').existsSync(),
        isFalse,
      );
    });

    test('a 404 on a payload is a sentence, not a stack trace', () async {
      await run(<String>['init', '--foundation', 'source']);
      server.statusOverrides['/logical/ui/button.dart'] = 404;
      final _Run result = await run(<String>['add', 'button']);
      expect(result.exitCode, isNot(0));
      expect(result.stderr, isNot(contains('#0')));
    });
  });

  group('the cache makes offline real', () {
    test('a warm cache serves a second command with no requests', () async {
      await run(<String>['list']);
      final int warmed = server.requests.length;
      expect(warmed, greaterThan(0));

      server.requests.clear();
      final _Run offline = await run(<String>['list', '--offline']);
      expect(offline.exitCode, 0, reason: offline.all);
      expect(offline.stdout, contains('button'));
      expect(
        server.requests,
        isEmpty,
        reason: 'offline mode must not touch the network at all',
      );
    });

    test('the cache survives the process', () async {
      await run(<String>['list']);
      // A fresh `ElattarCli` with the same cache directory stands in for a
      // second invocation of the binary, which is the case the in-memory
      // cache could never serve.
      final _Run second = await run(<String>['list', '--offline']);
      expect(second.exitCode, 0, reason: second.all);
    });

    test('an install warms the cache for later read commands too', () async {
      // `init`/`add` walk `index.json` and per-item manifests; `list` reads
      // `registry.json`. Without warming, a project that had just installed
      // the whole registry could not `list --offline` — a correct answer to
      // the wrong question, and the exact thing found by running the isolated
      // package by hand rather than only its unit tests.
      await run(<String>['init', '--foundation', 'source']);
      await server.close();

      final _Run offline = await run(<String>['list', '--offline']);
      expect(offline.exitCode, 0, reason: offline.all);
      expect(offline.stdout, contains('button'));
    });

    test('a cold cache reports a miss, not a network error', () async {
      final _Run result = await run(<String>[
        'list',
        '--offline',
      ], cacheDirectory: Directory('${workspace.path}/empty-cache'));
      expect(result.exitCode, isNot(0));
      expect(result.stderr.toLowerCase(), contains('cache'));
      expect(
        result.stderr.toLowerCase(),
        isNot(contains('cannot reach')),
        reason: 'a cache miss must not be reported as a connection failure',
      );
    });

    test('an unreachable host is reported as a connection failure', () async {
      await server.close();
      final _Run result = await run(<String>[
        'list',
      ], cacheDirectory: Directory('${workspace.path}/empty-cache-2'));
      expect(result.exitCode, isNot(0));
      expect(result.stderr, contains('--offline'));
    });
  });

  group('the fetcher bounds what it will accept', () {
    test('it follows a redirect', () async {
      server.redirects['/moved/index.json'] = '/registry/index.json';
      final RegistryFetchResponse response = await httpRegistryFetcher()(
        server.baseUri.replace(path: '/moved/index.json'),
      );
      expect(response.statusCode, 200);
      expect(response.body, contains('registryVersion'));
    });

    test('it refuses a redirect loop by name', () async {
      server.redirects['/loop-a'] = '/loop-b';
      server.redirects['/loop-b'] = '/loop-a';
      await expectLater(
        httpRegistryFetcher()(server.baseUri.replace(path: '/loop-a')),
        throwsA(
          isA<RegistrySourceException>().having(
            (RegistrySourceException error) => error.message,
            'message',
            contains('redirect loop'),
          ),
        ),
      );
    });

    test('it stops at the redirect limit', () async {
      // Every hop points at a fresh path, so this is a long chain rather than
      // a loop — the other bound.
      for (int i = 0; i < 12; i++) {
        server.redirects['/hop$i'] = '/hop${i + 1}';
      }
      await expectLater(
        httpRegistryFetcher(maxRedirects: 3)(
          server.baseUri.replace(path: '/hop0'),
        ),
        throwsA(
          isA<RegistrySourceException>().having(
            (RegistrySourceException error) => error.message,
            'message',
            contains('exceeded 3 redirects'),
          ),
        ),
      );
    });

    test('it refuses a response over the size limit', () async {
      await expectLater(
        httpRegistryFetcher(maxResponseBytes: 64)(
          server.baseUri.resolve('registry.json'),
        ),
        throwsA(
          isA<RegistrySourceException>().having(
            (RegistrySourceException error) => error.message,
            'message',
            contains('byte limit'),
          ),
        ),
      );
    });

    test('it times out rather than hanging', () async {
      server.stall = const Duration(seconds: 5);
      await expectLater(
        httpRegistryFetcher(timeout: const Duration(milliseconds: 200))(
          server.baseUri.resolve('index.json'),
        ),
        throwsA(
          isA<RegistrySourceException>().having(
            (RegistrySourceException error) => error.message,
            'message',
            contains('timed out'),
          ),
        ),
      );
    });

    test('a non-200 comes back as its status, not as an exception', () async {
      server.statusOverrides['/registry/index.json'] = 503;
      final RegistryFetchResponse response = await httpRegistryFetcher()(
        server.baseUri.resolve('index.json'),
      );
      expect(response.statusCode, 503);
    });
  });

  group('doctor reports the registry it would use', () {
    test('it names the kind, the version and the item count', () async {
      await run(<String>['init', '--foundation', 'source']);
      final _Run result = await run(<String>['doctor']);
      expect(result.stdout, contains('registry source: remote'));
      expect(result.stdout, contains(server.baseUri.toString()));
      expect(result.stdout, contains('registry: v0.0.1'));
      expect(result.stdout, contains('items'));
    });

    test('it reports the cache without printing its path', () async {
      await run(<String>['list']);
      final _Run result = await run(<String>['doctor']);
      expect(result.stdout, contains('registry cache:'));
      expect(
        result.stdout,
        isNot(contains(cache.path)),
        reason:
            'doctor output gets pasted into bug reports; a cache path carries '
            'a username on every platform',
      );
    });

    test('--verbose opts into the path', () async {
      await run(<String>['list']);
      final _Run result = await run(<String>['doctor', '--verbose']);
      expect(result.stdout, contains(cache.path));
    });
  });

  group('the base URL is normalised', () {
    test('a URL with no trailing slash still resolves its files', () async {
      final Uri withoutSlash = Uri.parse(
        server.baseUri.toString().replaceAll(RegExp(r'/$'), ''),
      );
      final _Run result = await run(<String>['list'], base: withoutSlash);
      expect(result.exitCode, 0, reason: result.all);
      expect(
        server.requests,
        contains('/registry/registry.json'),
        reason:
            'without a trailing slash Uri.resolve drops the last segment, so '
            'this would have fetched /registry.json, one directory up',
      );
    });
  });
}
