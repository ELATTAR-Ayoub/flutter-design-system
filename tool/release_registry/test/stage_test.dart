/// What staging a release must guarantee.
///
/// The important one is immutability. A CLI pins `/registry/<version>/` and
/// promises a user that what it installs today it installs next year; that
/// promise is only as good as the refusal to republish different bytes under
/// the same path. Most of this file is about that refusal and the ways it
/// could be got around by accident.
library;

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../bin/stage.dart' show validateStagedRegistry;
import '../lib/stage.dart';

/// A minimal but structurally real registry: two items, one depending on the
/// other, with payloads whose hashes match.
class _Fixture {
  _Fixture(this.root) {
    source = Directory('${root.path}/generated')..createSync(recursive: true);
    _writePayload(
      'versions/base/0.0.1/logical/foundation/colors.dart',
      'class Colors {}\n',
    );
    _writePayload(
      'versions/leaf/0.0.1/logical/ui/leaf.dart',
      'class Leaf {}\n',
    );
    _writeManifest('base', <String>[], <String, String>{
      '@foundation/colors.dart':
          'versions/base/0.0.1/logical/foundation/colors.dart',
    });
    _writeManifest(
      'leaf',
      <String>['base'],
      <String, String>{
        '@ui/leaf.dart': 'versions/leaf/0.0.1/logical/ui/leaf.dart',
      },
    );
    _writeCatalog();
  }

  final Directory root;
  late final Directory source;
  final Map<String, String> _payloads = <String, String>{};

  void _writePayload(String relative, String content) {
    _payloads[relative] = content;
    File('${source.path}/$relative')
      ..parent.createSync(recursive: true)
      ..writeAsStringSync(content);
  }

  Map<String, Object?> _item(
    String name,
    List<String> dependencies,
    Map<String, String> targets,
  ) => <String, Object?>{
    'name': name,
    'type': name == 'base' ? 'foundation' : 'component',
    'version': '0.0.1',
    'description': 'A fixture item used by the release staging tests.',
    'minDart': '>=3.12.2 <4.0.0',
    'minFlutter': '>=3.44.8',
    'files': <Object?>[
      for (final MapEntry<String, String> entry in targets.entries)
        <String, Object?>{
          'source': 'lib/src/${entry.key}',
          'target': entry.key,
          'sha256': sha256Hex(utf8.encode(_payloads[entry.value]!)),
        },
    ],
    'registryDependencies': dependencies,
    'semanticDependencies': dependencies,
    'pubDependencies': <String, Object?>{},
    'assets': <Object?>[],
    'fonts': <Object?>[],
    'shaders': <Object?>[],
    'licenses': <Object?>[],
    'documentationRoute': '/components/$name',
    'sourceLink': 'https://example.invalid/$name.dart',
    'deprecated': false,
  };

  void _writeManifest(
    String name,
    List<String> dependencies,
    Map<String, String> targets,
  ) {
    File('${source.path}/versions/$name/0.0.1/manifest.json')
      ..parent.createSync(recursive: true)
      ..writeAsStringSync(jsonEncode(_item(name, dependencies, targets)));
  }

  void _writeCatalog() {
    final List<Object?> items = <Object?>[
      _item('base', <String>[], <String, String>{
        '@foundation/colors.dart':
            'versions/base/0.0.1/logical/foundation/colors.dart',
      }),
      _item(
        'leaf',
        <String>['base'],
        <String, String>{
          '@ui/leaf.dart': 'versions/leaf/0.0.1/logical/ui/leaf.dart',
        },
      ),
    ];
    File('${source.path}/registry.json').writeAsStringSync(
      jsonEncode(<String, Object?>{
        'schemaVersion': 1,
        'registryVersion': '0.0.1',
        'items': items,
      }),
    );
    File('${source.path}/index.json').writeAsStringSync(
      jsonEncode(<String, Object?>{
        'schemaVersion': 1,
        'registryVersion': '0.0.1',
        'items': <Object?>[
          for (final Object? item in items)
            <String, Object?>{
              'name': (item! as Map<String, Object?>)['name'],
              'type': (item as Map<String, Object?>)['type'],
              'version': item['version'],
              'documentationRoute': item['documentationRoute'],
            },
        ],
      }),
    );
  }
}

void main() {
  late Directory root;
  late _Fixture fixture;

  setUp(() {
    root = Directory.systemTemp.createTempSync('elattar-stage-');
    fixture = _Fixture(root);
  });
  tearDown(() => root.deleteSync(recursive: true));

  Directory web([String name = 'web']) =>
      Directory('${root.path}/$name')..createSync(recursive: true);

  group('staging', () {
    test('writes the registry under a versioned path', () {
      final Directory webRoot = web();
      final StageResult result = stageRegistry(
        source: fixture.source,
        webRoot: webRoot,
        version: '0.0.1',
      );

      expect(result.version, '0.0.1');
      expect(
        result.destination.replaceAll(r'\', '/'),
        endsWith('registry/0.0.1'),
      );
      expect(
        File('${webRoot.path}/registry/0.0.1/index.json').existsSync(),
        isTrue,
      );
      expect(
        File(
          '${webRoot.path}/registry/0.0.1/versions/leaf/0.0.1/logical/ui/leaf.dart',
        ).readAsStringSync(),
        'class Leaf {}\n',
      );
    });

    test('the staged tree is byte-identical to the source', () {
      final Directory webRoot = web();
      stageRegistry(source: fixture.source, webRoot: webRoot, version: '0.0.1');
      for (final FileSystemEntity entity in fixture.source.listSync(
        recursive: true,
      )) {
        if (entity is! File) continue;
        final String relative = entity.path
            .substring(fixture.source.path.length + 1)
            .replaceAll(r'\', '/');
        expect(
          File('${webRoot.path}/registry/0.0.1/$relative').readAsBytesSync(),
          entity.readAsBytesSync(),
          reason: '$relative differs from the source',
        );
      }
    });

    test('writes a release manifest describing what was staged', () {
      final Directory webRoot = web();
      final StageResult result = stageRegistry(
        source: fixture.source,
        webRoot: webRoot,
        version: '0.0.1',
        generationCommit: 'abc123',
      );
      final Map<String, Object?> release =
          jsonDecode(
                File(
                  '${webRoot.path}/registry/0.0.1/release.json',
                ).readAsStringSync(),
              )
              as Map<String, Object?>;
      expect(release['version'], '0.0.1');
      expect(release['schemaVersion'], 1);
      expect(release['itemCount'], 2);
      expect(release['fileCount'], result.fileCount);
      expect(release['treeHash'], result.treeHash);
      expect(release['generationCommit'], 'abc123');
    });

    test('the release manifest is not part of its own tree hash', () {
      // Otherwise the hash would depend on a file that contains the hash,
      // and no second run could ever reproduce it.
      final Directory a = web('a');
      final Directory b = web('b');
      final StageResult first = stageRegistry(
        source: fixture.source,
        webRoot: a,
        version: '0.0.1',
        generationCommit: 'commit-one',
      );
      final StageResult second = stageRegistry(
        source: fixture.source,
        webRoot: b,
        version: '0.0.1',
        generationCommit: 'commit-two',
      );
      expect(second.treeHash, first.treeHash);
    });

    test('the tree hash changes when any file changes', () {
      final StageResult before = stageRegistry(
        source: fixture.source,
        webRoot: web('a'),
        version: '0.0.1',
      );
      File(
        '${fixture.source.path}/versions/leaf/0.0.1/logical/ui/leaf.dart',
      ).writeAsStringSync('class Leaf { int x = 1; }\n');
      final StageResult after = stageRegistry(
        source: fixture.source,
        webRoot: web('b'),
        version: '0.0.1',
      );
      expect(after.treeHash, isNot(before.treeHash));
    });
  });

  group('a published version is immutable', () {
    test('re-staging identical bytes is a no-op, not an error', () {
      final Directory webRoot = web();
      final StageResult first = stageRegistry(
        source: fixture.source,
        webRoot: webRoot,
        version: '0.0.1',
      );
      final StageResult second = stageRegistry(
        source: fixture.source,
        webRoot: webRoot,
        version: '0.0.1',
      );
      expect(first.filesWritten, greaterThan(0));
      expect(second.filesWritten, 0);
      expect(second.filesUnchanged, first.filesWritten);
      expect(second.treeHash, first.treeHash);
    });

    test('changed content is refused', () {
      final Directory webRoot = web();
      stageRegistry(source: fixture.source, webRoot: webRoot, version: '0.0.1');
      File(
        '${fixture.source.path}/versions/leaf/0.0.1/logical/ui/leaf.dart',
      ).writeAsStringSync('class Leaf { int x = 1; }\n');

      expect(
        () => stageRegistry(
          source: fixture.source,
          webRoot: webRoot,
          version: '0.0.1',
        ),
        throwsA(
          isA<StageException>().having(
            (StageException error) => error.message,
            'message',
            allOf(
              contains('Refusing to overwrite'),
              contains('leaf.dart would change'),
            ),
          ),
        ),
      );
    });

    test('an added file is refused', () {
      final Directory webRoot = web();
      stageRegistry(source: fixture.source, webRoot: webRoot, version: '0.0.1');
      File(
        '${fixture.source.path}/versions/leaf/0.0.1/logical/ui/extra.dart',
      ).writeAsStringSync('class Extra {}\n');

      expect(
        () => stageRegistry(
          source: fixture.source,
          webRoot: webRoot,
          version: '0.0.1',
        ),
        throwsA(
          isA<StageException>().having(
            (StageException error) => error.message,
            'message',
            contains('extra.dart would be added'),
          ),
        ),
      );
    });

    test('a removed file is refused', () {
      final Directory webRoot = web();
      stageRegistry(source: fixture.source, webRoot: webRoot, version: '0.0.1');
      File(
        '${fixture.source.path}/versions/leaf/0.0.1/logical/ui/leaf.dart',
      ).deleteSync();

      expect(
        () => stageRegistry(
          source: fixture.source,
          webRoot: webRoot,
          version: '0.0.1',
        ),
        throwsA(
          isA<StageException>().having(
            (StageException error) => error.message,
            'message',
            contains('leaf.dart would be removed'),
          ),
        ),
      );
    });

    test('nothing is written when the refusal fires', () {
      // The check runs before the first byte, so a refused re-stage cannot
      // leave the published version half-replaced.
      final Directory webRoot = web();
      stageRegistry(source: fixture.source, webRoot: webRoot, version: '0.0.1');
      final String published = File(
        '${webRoot.path}/registry/0.0.1/versions/leaf/0.0.1/logical/ui/leaf.dart',
      ).readAsStringSync();

      File(
        '${fixture.source.path}/versions/leaf/0.0.1/logical/ui/leaf.dart',
      ).writeAsStringSync('class Leaf { int x = 1; }\n');
      File(
        '${fixture.source.path}/versions/base/0.0.1/logical/foundation/colors.dart',
      ).writeAsStringSync('class Colors { int y = 2; }\n');

      try {
        stageRegistry(
          source: fixture.source,
          webRoot: webRoot,
          version: '0.0.1',
        );
        fail('expected the refusal');
      } on StageException {
        // Expected.
      }

      expect(
        File(
          '${webRoot.path}/registry/0.0.1/versions/leaf/0.0.1/logical/ui/leaf.dart',
        ).readAsStringSync(),
        published,
      );
      expect(
        File(
          '${webRoot.path}/registry/0.0.1/versions/base/0.0.1/logical/foundation/colors.dart',
        ).readAsStringSync(),
        'class Colors {}\n',
      );
    });

    test('a different version is a different path, and allowed', () {
      final Directory webRoot = web();
      stageRegistry(source: fixture.source, webRoot: webRoot, version: '0.0.1');
      File(
        '${fixture.source.path}/versions/leaf/0.0.1/logical/ui/leaf.dart',
      ).writeAsStringSync('class Leaf { int x = 1; }\n');

      stageRegistry(source: fixture.source, webRoot: webRoot, version: '0.0.2');
      expect(
        File('${webRoot.path}/registry/0.0.1/index.json').existsSync(),
        isTrue,
      );
      expect(
        File('${webRoot.path}/registry/0.0.2/index.json').existsSync(),
        isTrue,
      );
    });
  });

  group('the alias', () {
    test('is not written unless asked for', () {
      final Directory webRoot = web();
      final StageResult result = stageRegistry(
        source: fixture.source,
        webRoot: webRoot,
        version: '0.0.1',
      );
      expect(result.aliasDestination, isNull);
      expect(
        Directory('${webRoot.path}/registry/latest').existsSync(),
        isFalse,
      );
    });

    test('is mutable, unlike the versioned path', () {
      // The whole point of the alias: it may be replaced. A released CLI must
      // never default to it, which is asserted in the CLI's own suite.
      final Directory webRoot = web();
      stageRegistry(
        source: fixture.source,
        webRoot: webRoot,
        version: '0.0.1',
        alias: true,
      );
      File(
        '${fixture.source.path}/versions/leaf/0.0.1/logical/ui/leaf.dart',
      ).writeAsStringSync('class Leaf { int x = 1; }\n');

      stageRegistry(
        source: fixture.source,
        webRoot: webRoot,
        version: '0.0.2',
        alias: true,
      );
      expect(
        File(
          '${webRoot.path}/registry/latest/versions/leaf/0.0.1/logical/ui/leaf.dart',
        ).readAsStringSync(),
        'class Leaf { int x = 1; }\n',
      );
    });
  });

  group('validation gates the release', () {
    test('a reported problem aborts', () {
      expect(
        () => stageRegistry(
          source: fixture.source,
          webRoot: web(),
          version: '0.0.1',
          validate: (Directory staged) => <String>['leaf: payload missing'],
        ),
        throwsA(
          isA<StageException>().having(
            (StageException error) => error.message,
            'message',
            contains('leaf: payload missing'),
          ),
        ),
      );
    });

    test('validation runs against the staged copy, not the source', () {
      late Directory seen;
      stageRegistry(
        source: fixture.source,
        webRoot: web(),
        version: '0.0.1',
        validate: (Directory staged) {
          seen = staged;
          return const <String>[];
        },
      );
      expect(seen.path.replaceAll(r'\', '/'), endsWith('registry/0.0.1'));
      expect(seen.path, isNot(fixture.source.path));
    });
  });

  group('inputs are checked before anything happens', () {
    test('a missing source is refused', () {
      expect(
        () => stageRegistry(
          source: Directory('${root.path}/nope'),
          webRoot: web(),
          version: '0.0.1',
        ),
        throwsA(isA<StageException>()),
      );
    });

    test('a version that is not a release version is refused', () {
      for (final String bad in <String>['latest', '0.0', 'v0.0.1', '../evil']) {
        expect(
          () => stageRegistry(
            source: fixture.source,
            webRoot: web(bad.hashCode.toString()),
            version: bad,
          ),
          throwsA(isA<StageException>()),
          reason: '"$bad" should not be accepted as a version',
        );
      }
    });

    test('a registry with no catalog is refused', () {
      File('${fixture.source.path}/registry.json').deleteSync();
      expect(
        () => stageRegistry(
          source: fixture.source,
          webRoot: web(),
          version: '0.0.1',
        ),
        throwsA(
          isA<StageException>().having(
            (StageException error) => error.message,
            'message',
            contains('registry.json'),
          ),
        ),
      );
    });
  });

  group('the real validator, against a staged tree', () {
    // `validateStagedRegistry` is the one the release actually runs. The
    // group above proves staging honours whatever a validator reports; this
    // proves the real validator reports the right things.
    Directory stageFixture() {
      final Directory webRoot = web('validated');
      stageRegistry(source: fixture.source, webRoot: webRoot, version: '0.0.1');
      return Directory('${webRoot.path}/registry/0.0.1');
    }

    test('a well-formed release has no problems', () {
      expect(validateStagedRegistry(stageFixture()), isEmpty);
    });

    test('a payload whose bytes changed is caught', () {
      final Directory staged = stageFixture();
      File(
        '${staged.path}/versions/leaf/0.0.1/logical/ui/leaf.dart',
      ).writeAsStringSync('class Leaf { int tampered = 1; }');
      expect(
        validateStagedRegistry(staged),
        contains(allOf(contains('leaf'), contains('hashes to'))),
      );
    });

    test('a payload that did not make it into the release is caught', () {
      final Directory staged = stageFixture();
      File(
        '${staged.path}/versions/leaf/0.0.1/logical/ui/leaf.dart',
      ).deleteSync();
      expect(
        validateStagedRegistry(staged),
        contains(contains('payload for @ui/leaf.dart is missing')),
      );
    });

    test('a missing manifest is caught', () {
      final Directory staged = stageFixture();
      File('${staged.path}/versions/leaf/0.0.1/manifest.json').deleteSync();
      expect(
        validateStagedRegistry(staged),
        contains(contains('manifest.json is missing')),
      );
    });

    test('a dependency edge pointing at nothing is caught', () {
      // The failure this prevents: `elattar add leaf` resolving `base`,
      // 404ing on it, and leaving the consumer with a partial install.
      final Directory staged = stageFixture();
      final File catalog = File('${staged.path}/registry.json');
      final Map<String, Object?> document =
          jsonDecode(catalog.readAsStringSync()) as Map<String, Object?>;
      (document['items']! as List<Object?>).removeWhere(
        (Object? item) => (item! as Map<String, Object?>)['name'] == 'base',
      );
      catalog.writeAsStringSync(jsonEncode(document));
      expect(
        validateStagedRegistry(staged),
        contains(contains('leaf depends on "base", which is absent')),
      );
    });

    test('a catalog and index that disagree are caught', () {
      final Directory staged = stageFixture();
      final File index = File('${staged.path}/index.json');
      final Map<String, Object?> document =
          jsonDecode(index.readAsStringSync()) as Map<String, Object?>;
      document['registryVersion'] = '9.9.9';
      index.writeAsStringSync(jsonEncode(document));
      expect(
        validateStagedRegistry(staged),
        contains(contains('index.json declares version 9.9.9')),
      );
    });
  });

  group('paths', () {
    test('a web root containing spaces works', () {
      // GitHub runners are tame, but a maintainer staging from
      // `C:\Users\Some One\Documents\...` is not an exotic case, and shell
      // copy steps are exactly where it breaks.
      final Directory spaced = Directory('${root.path}/site build output')
        ..createSync(recursive: true);
      final StageResult result = stageRegistry(
        source: fixture.source,
        webRoot: spaced,
        version: '0.0.1',
      );
      expect(result.destination, contains('site build output'));
      expect(
        File('${spaced.path}/registry/0.0.1/index.json').existsSync(),
        isTrue,
      );
    });

    test('a source containing spaces works', () {
      final Directory spaced = Directory('${root.path}/generated copy')
        ..createSync(recursive: true);
      for (final FileSystemEntity entity in fixture.source.listSync(
        recursive: true,
      )) {
        if (entity is! File) continue;
        final String relative = entity.path.substring(
          fixture.source.path.length + 1,
        );
        File('${spaced.path}/$relative')
          ..parent.createSync(recursive: true)
          ..writeAsBytesSync(entity.readAsBytesSync());
      }
      final StageResult result = stageRegistry(
        source: spaced,
        webRoot: web(),
        version: '0.0.1',
      );
      expect(result.fileCount, greaterThan(0));
    });

    test('a web root given with a trailing separator works', () {
      final Directory webRoot = web();
      final StageResult result = stageRegistry(
        source: fixture.source,
        webRoot: Directory('${webRoot.path}${Platform.pathSeparator}'),
        version: '0.0.1',
      );
      expect(
        result.destination.replaceAll(r'\', '/'),
        endsWith('registry/0.0.1'),
      );
      expect(result.destination, isNot(contains('//')));
    });

    test('the tree compares by POSIX paths, so platforms agree', () {
      // The immutability check compares path keys. If those were native
      // paths, the first release run from the other operating system would
      // report every single file as added and removed at once.
      final Directory webRoot = web();
      final StageResult first = stageRegistry(
        source: fixture.source,
        webRoot: webRoot,
        version: '0.0.1',
      );
      final StageResult second = stageRegistry(
        source: fixture.source,
        webRoot: webRoot,
        version: '0.0.1',
      );
      expect(second.filesUnchanged, first.filesWritten);
      expect(second.treeHash, first.treeHash);
    });
  });
}
