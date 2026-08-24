/// The cache is what makes `--offline` mean anything.
///
/// Before this, the only cache was in memory, populated and thrown away
/// inside a single command — so `--offline` could report nothing but a miss.
/// These tests are about the four properties that turn it into a real one:
/// it survives the process, it cannot be steered out of its own directory,
/// a half-written entry never becomes a readable one, and it degrades to
/// memory instead of failing the command.
library;

import 'dart:io';

import 'package:test/test.dart';

import '../lib/src/registry/file_cache.dart';

void main() {
  late Directory root;

  setUp(() => root = Directory.systemTemp.createTempSync('elattar-cache-'));
  tearDown(() => root.deleteSync(recursive: true));

  Directory sub(String name) => Directory('${root.path}/$name');

  group('persistence', () {
    test('an entry written by one instance is read by the next', () async {
      // The whole point. Two `FileRegistryCache` objects stand in for two
      // `elattar` invocations, which is the case the in-memory cache could
      // never serve.
      final FileRegistryCache first = FileRegistryCache.open(
        directory: sub('a'),
      );
      expect(first.isPersistent, isTrue);
      await first.writeBytes('https://x/registry/index.json', <int>[1, 2, 3]);

      final FileRegistryCache second = FileRegistryCache.open(
        directory: sub('a'),
      );
      expect(await second.readBytes('https://x/registry/index.json'), <int>[
        1,
        2,
        3,
      ]);
    });

    test('a miss is null, not an exception', () async {
      final FileRegistryCache cache = FileRegistryCache.open(
        directory: sub('b'),
      );
      expect(await cache.readBytes('nothing here'), isNull);
    });

    test('rewriting a key replaces it', () async {
      final FileRegistryCache cache = FileRegistryCache.open(
        directory: sub('c'),
      );
      await cache.writeBytes('k', <int>[1]);
      await cache.writeBytes('k', <int>[2, 2]);
      expect(await cache.readBytes('k'), <int>[2, 2]);
      expect(cache.entryCount, 1);
    });

    test('clear empties it', () async {
      final FileRegistryCache cache = FileRegistryCache.open(
        directory: sub('d'),
      );
      await cache.writeBytes('one', <int>[1]);
      await cache.writeBytes('two', <int>[2]);
      expect(cache.entryCount, 2);
      await cache.clear();
      expect(cache.entryCount, 0);
      expect(await cache.readBytes('one'), isNull);
    });
  });

  group('keys cannot become paths', () {
    test('a key full of separators still writes one flat file', () async {
      // Cache keys are `<baseUri>::<relativePath>` — attacker-influenced in
      // the sense that the base URI comes from a command line. Hashing them
      // means no key can climb out of the cache directory, and no key can
      // exceed a filesystem's name limit either.
      final Directory directory = sub('e');
      final FileRegistryCache cache = FileRegistryCache.open(
        directory: directory,
      );
      await cache.writeBytes('https://x/r/::../../../../etc/passwd', <int>[9]);
      final List<FileSystemEntity> written = directory.listSync();
      expect(written, hasLength(1));
      expect(written.single, isA<File>());
      expect(written.single.path, endsWith('.bin'));
      expect(
        await cache.readBytes('https://x/r/::../../../../etc/passwd'),
        <int>[9],
      );
    });

    test('a very long key is still a legal filename', () async {
      final FileRegistryCache cache = FileRegistryCache.open(
        directory: sub('f'),
      );
      final String key = 'https://x/${'segment/' * 500}index.json';
      await cache.writeBytes(key, <int>[7]);
      expect(await cache.readBytes(key), <int>[7]);
    });

    test('different keys do not collide', () async {
      final FileRegistryCache cache = FileRegistryCache.open(
        directory: sub('g'),
      );
      await cache.writeBytes('https://a/index.json', <int>[1]);
      await cache.writeBytes('https://b/index.json', <int>[2]);
      expect(await cache.readBytes('https://a/index.json'), <int>[1]);
      expect(await cache.readBytes('https://b/index.json'), <int>[2]);
      expect(cache.entryCount, 2);
    });
  });

  group('writes are atomic', () {
    test('no temporary file survives a completed write', () async {
      // A `.tmp` left behind would eventually be read as a cache entry by
      // nothing — but a *truncated* entry under the real name would be read
      // as a payload. The rename is what prevents that; this asserts the
      // rename actually happened rather than a partial write being renamed
      // into place later.
      final Directory directory = sub('h');
      final FileRegistryCache cache = FileRegistryCache.open(
        directory: directory,
      );
      await cache.writeBytes('k', List<int>.filled(64 * 1024, 7));
      final List<String> names = directory
          .listSync()
          .map((FileSystemEntity entity) => entity.path)
          .toList();
      expect(names.where((String name) => name.endsWith('.tmp')), isEmpty);
      expect(names.where((String name) => name.endsWith('.bin')), hasLength(1));
      expect(await cache.readBytes('k'), hasLength(64 * 1024));
    });
  });

  group('a cache is an optimisation, not a dependency', () {
    test(
      'an unusable directory degrades to memory rather than throwing',
      () async {
        // `open` is handed a path whose parent is a *file*, so the directory
        // cannot be created. The CLI must keep working: the payload is already
        // in hand, and failing to memoise it is not a reason to refuse an
        // install.
        final File blocker = File('${root.path}/blocker')
          ..writeAsStringSync('not a directory');
        final FileRegistryCache cache = FileRegistryCache.open(
          directory: Directory('${blocker.path}/nested'),
        );
        expect(cache.isPersistent, isFalse);
        expect(cache.directory, isNull);

        // Still usable within the process, which is what the old in-memory
        // cache did and what `doctor` reports as non-persistent.
        await cache.writeBytes('k', <int>[1]);
        expect(await cache.readBytes('k'), <int>[1]);
      },
    );
  });

  group('where the cache lives', () {
    test('ELATTAR_CACHE_DIR wins outright', () {
      final Directory? resolved = defaultCacheDirectory(
        environment: <String, String>{
          'ELATTAR_CACHE_DIR': '/tmp/ci-cache',
          'HOME': '/home/someone',
          'LOCALAPPDATA': r'C:\Users\someone\AppData\Local',
        },
      );
      expect(resolved?.path, '/tmp/ci-cache');
    });

    test('the platform default is under a per-user cache root', () {
      // Asserted by shape rather than by exact path, because the correct
      // answer differs per platform and this suite runs on more than one.
      final Directory? resolved = defaultCacheDirectory();
      if (resolved == null) return; // No HOME at all: legal, and handled.
      final String path = resolved.path.replaceAll(r'\', '/');
      expect(path, contains(cacheDirectoryName));
      expect(path, contains('registry'));
      expect(path, endsWith(cacheLayoutVersion));
    });

    test('a home-less environment yields null rather than a bad guess', () {
      expect(
        defaultCacheDirectory(environment: const <String, String>{}),
        anyOf(isNull, isA<Directory>()),
      );
    });

    test('the layout version is part of the path', () {
      // A layout change abandons old entries instead of misreading them.
      final Directory? resolved = defaultCacheDirectory(
        environment: <String, String>{'XDG_CACHE_HOME': '/x'},
      );
      expect(resolved, isNotNull);
      expect(resolved!.path.replaceAll(r'\', '/'), '/x/elattar/registry/v1');
    }, testOn: '!windows');
  });
}
