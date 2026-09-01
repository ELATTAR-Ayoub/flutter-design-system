/// `resolveRegistryLocation`'s precedence: `--registry`, then
/// `ELATTAR_REGISTRY_URL`, then `elattar.yaml`, then a discovered local
/// registry, then the compiled default.
///
/// Every case below passes `environment` explicitly — never mutates the real
/// process environment — the same seam `registry_cache_test.dart` uses for
/// `ELATTAR_CACHE_DIR` via `defaultCacheDirectory`. An explicit (possibly
/// empty) map also means a stray `ELATTAR_REGISTRY_URL` set on the machine
/// actually running this suite cannot leak in and make a test flaky.
library;

import 'dart:io';

import 'package:test/test.dart';

import '../lib/src/identity.dart';
import '../lib/src/registry/location.dart';

void main() {
  late Directory root;

  setUp(() => root = Directory.systemTemp.createTempSync('elattar-loc-'));
  tearDown(() => root.deleteSync(recursive: true));

  group('with nothing to discover', () {
    test('falls back to the compiled default', () {
      final RegistryLocation location = resolveRegistryLocation(
        workingDirectory: root,
        environment: const <String, String>{},
      );
      expect(location, isA<RemoteRegistryLocation>());
      expect((location as RemoteRegistryLocation).baseUri, defaultRegistryUri);
    });
  });

  group('a discovered local registry', () {
    test('wins over the compiled default when nothing else is set', () {
      Directory(
        '${root.path}/registry/generated/latest',
      ).createSync(recursive: true);

      final RegistryLocation location = resolveRegistryLocation(
        workingDirectory: root,
        environment: const <String, String>{},
      );
      expect(location, isA<LocalRegistryLocation>());
      final LocalRegistryLocation local = location as LocalRegistryLocation;
      expect(local.discovered, isTrue);
    });
  });

  group('ELATTAR_REGISTRY_URL', () {
    test('wins over elattar.yaml\'s configured registry', () {
      final RegistryLocation location = resolveRegistryLocation(
        configured: 'https://configured.example/registry/',
        workingDirectory: root,
        environment: const <String, String>{
          'ELATTAR_REGISTRY_URL': 'https://env.example/registry/',
        },
      );
      expect(location, isA<RemoteRegistryLocation>());
      expect(
        (location as RemoteRegistryLocation).baseUri.toString(),
        'https://env.example/registry/',
      );
    });

    test('wins over a discovered local registry', () {
      Directory(
        '${root.path}/registry/generated/latest',
      ).createSync(recursive: true);

      final RegistryLocation location = resolveRegistryLocation(
        workingDirectory: root,
        environment: const <String, String>{
          'ELATTAR_REGISTRY_URL': 'https://env.example/registry/',
        },
      );
      expect(location, isA<RemoteRegistryLocation>());
      expect(
        (location as RemoteRegistryLocation).baseUri.toString(),
        'https://env.example/registry/',
      );
    });

    test('loses to --registry', () {
      final RegistryLocation location = resolveRegistryLocation(
        explicit: 'https://explicit.example/registry/',
        configured: 'https://configured.example/registry/',
        workingDirectory: root,
        environment: const <String, String>{
          'ELATTAR_REGISTRY_URL': 'https://env.example/registry/',
        },
      );
      expect(location, isA<RemoteRegistryLocation>());
      expect(
        (location as RemoteRegistryLocation).baseUri.toString(),
        'https://explicit.example/registry/',
      );
    });

    test('an empty value is ignored, not treated as a URL', () {
      final RegistryLocation location = resolveRegistryLocation(
        workingDirectory: root,
        environment: const <String, String>{'ELATTAR_REGISTRY_URL': ''},
      );
      expect(location, isA<RemoteRegistryLocation>());
      expect((location as RemoteRegistryLocation).baseUri, defaultRegistryUri);
    });

    test('a whitespace-only value is ignored, not treated as a URL', () {
      final RegistryLocation location = resolveRegistryLocation(
        configured: 'https://configured.example/registry/',
        workingDirectory: root,
        environment: const <String, String>{'ELATTAR_REGISTRY_URL': '   '},
      );
      expect(location, isA<RemoteRegistryLocation>());
      expect(
        (location as RemoteRegistryLocation).baseUri.toString(),
        'https://configured.example/registry/',
        reason:
            'a blank env value must fall through to elattar.yaml, not be '
            'handed to Uri.parse',
      );
    });
  });
}
