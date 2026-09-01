import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../lib/generator.dart';

void main() {
  test('sha256 implementation matches the standard empty digest', () {
    expect(
      sha256Hex(const <int>[]),
      'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
    );
  });

  test('plans logical imports and package font transformations', () {
    final ImportTransformationPlan plan = planImportTransformations(
      "import '@foundation/colors.dart';\nconst family = 'InterLocal';",
      fromTarget: '@ui/button.dart',
      foundationMode: 'package',
    );
    expect(
      plan.transformations[0].replacement,
      "'package:elattar_core/design_system/foundation/colors.dart'",
    );
    expect(
      plan.transformations[1].replacement,
      'packages/elattar_core/InterLocal',
    );
  });

  test('builds deterministic payloads and aggregate index twice', () {
    final Directory root = Directory.systemTemp.createTempSync(
      'elattar-registry-',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    final File source = File('${root.path}/lib/src/components/button.dart')
      ..createSync(recursive: true)
      ..writeAsStringSync('const button = true;\n');
    final String hash = sha256Hex(source.readAsBytesSync());
    final Directory manifestDirectory = Directory(
      '${root.path}/registry/components',
    )..createSync(recursive: true);
    File('${manifestDirectory.path}/button.json').writeAsStringSync(
      const JsonEncoder.withIndent('  ')
          .convert(<String, Object?>{
            'name': 'button',
            'type': 'component',
            'version': '0.0.1',
            'description': 'Button fixture.',
            'minDart': '3.12.2',
            'minFlutter': '3.44.8',
            'files': <Object?>[
              <String, Object?>{
                'source': 'lib/src/components/button.dart',
                'target': '@ui/button.dart',
                'sha256': '__HASH__',
              },
            ],
            'registryDependencies': <String>[],
            'pubDependencies': <String, String>{},
            'assets': <Object?>[],
            'fonts': <Object?>[],
            'shaders': <Object?>[],
            'documentationRoute': '/components/button',
            'sourceLink':
                'https://github.com/ELATTAR-Ayoub/flutter-design-system',
          })
          .replaceAll('__HASH__', hash),
    );

    final RegistryGenerator generator = RegistryGenerator(repositoryRoot: root);
    generator.build();
    final Map<String, List<int>> first = _snapshot(
      Directory('${root.path}/registry/generated/latest'),
    );
    generator.build();
    final Map<String, List<int>> second = _snapshot(
      Directory('${root.path}/registry/generated/latest'),
    );
    expect(second, first);
    expect(
      File('${root.path}/registry/generated/latest/registry.json').existsSync(),
      isTrue,
    );
    expect(
      File('${root.path}/registry/generated/latest/index.json').existsSync(),
      isTrue,
    );
    expect(
      File(
        '${root.path}/registry/generated/latest/versions/button/0.0.1/logical/ui/button.dart',
      ).existsSync(),
      isTrue,
    );
  });

  test('rebuild never deletes payloads it does not own', () {
    final Directory root = Directory.systemTemp.createTempSync(
      'elattar-registry-stale-',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    final File source = File('${root.path}/lib/src/components/button.dart')
      ..createSync(recursive: true)
      ..writeAsStringSync('const button = true;\n');
    final String hash = sha256Hex(source.readAsBytesSync());
    final Directory manifestDirectory = Directory(
      '${root.path}/registry/components',
    )..createSync(recursive: true);
    File('${manifestDirectory.path}/button.json').writeAsStringSync(
      const JsonEncoder.withIndent('  ')
          .convert(<String, Object?>{
            'name': 'button',
            'type': 'component',
            'version': '0.0.1',
            'description': 'Button fixture.',
            'minDart': '3.12.2',
            'minFlutter': '3.44.8',
            'files': <Object?>[
              <String, Object?>{
                'source': 'lib/src/components/button.dart',
                'target': '@ui/button.dart',
                'sha256': '__HASH__',
              },
            ],
            'registryDependencies': <String>[],
            'pubDependencies': <String, String>{},
            'assets': <Object?>[],
            'fonts': <Object?>[],
            'shaders': <Object?>[],
            'documentationRoute': '/components/button',
            'sourceLink':
                'https://github.com/ELATTAR-Ayoub/flutter-design-system',
          })
          .replaceAll('__HASH__', hash),
    );

    final RegistryGenerator generator = RegistryGenerator(repositoryRoot: root);
    generator.build();

    // An item this registry has never heard of. Generation leaves it alone:
    // it cannot tell an abandoned draft from a version some earlier release
    // published and a pinned consumer still installs, and only one of those
    // guesses is recoverable.
    final File other = File(
      '${root.path}/registry/generated/latest/versions/other/0.0.1/logical/ui/other.dart',
    )..createSync(recursive: true);
    other.writeAsStringSync('other');

    generator.build();

    expect(
      other.existsSync(),
      isTrue,
      reason: 'generation is not a deletion tool',
    );
    expect(other.readAsStringSync(), 'other');
  });

  test('rebuild removes a stale payload from the version being written', () {
    final _Fixture fixture = _Fixture.button();
    addTearDown(fixture.dispose);
    fixture.generator.build();

    // A file inside the very version about to be rewritten: it belongs to a
    // generation that no longer declares it, so it must not survive.
    final File stale = File(
      '${fixture.root.path}/registry/generated/latest/versions/button/0.0.1/'
      'logical/ui/dropped.dart',
    )..createSync(recursive: true);
    stale.writeAsStringSync('dropped');

    fixture.generator.build();

    expect(stale.existsSync(), isFalse);
  });

  test('rebuild leaves another version of the same item alone', () {
    // The immutability rule, at the level that enforces it: a released version
    // is served out of its own directory, and regenerating a newer one may not
    // touch it. Before this, `_writePayloads` wiped the whole output and took
    // every earlier release with it.
    final _Fixture fixture = _Fixture.button();
    addTearDown(fixture.dispose);
    fixture.generator.build();

    final File released = File(
      '${fixture.root.path}/registry/generated/latest/versions/button/0.0.0/'
      'logical/ui/button.dart',
    )..createSync(recursive: true);
    released.writeAsStringSync('the bytes 0.0.0 published\n');
    final String before = released.readAsStringSync();

    fixture.generator.build();

    expect(
      released.existsSync(),
      isTrue,
      reason: 'a released payload was deleted',
    );
    expect(released.readAsStringSync(), before, reason: 'its bytes changed');
  });

  test('removing an item from the registry keeps its published versions', () {
    // Retiring an item takes it out of the *index*. It does not unpublish the
    // versions that already shipped: an earlier release's dependency graph may
    // still name it, and a consumer pinned there still fetches its payload.
    final _Fixture fixture = _Fixture.button();
    addTearDown(fixture.dispose);
    fixture.generator.build();

    final String root = '${fixture.root.path}/registry/generated/latest';
    final File retired001 =
        File('$root/versions/retired/0.0.1/logical/ui/retired.dart')
          ..createSync(recursive: true)
          ..writeAsStringSync('retired at 0.0.1\n');
    final File retired002 =
        File('$root/versions/retired/0.0.2/logical/ui/retired.dart')
          ..createSync(recursive: true)
          ..writeAsStringSync('retired at 0.0.2\n');

    fixture.generator.build();

    expect(retired001.existsSync(), isTrue);
    expect(retired001.readAsStringSync(), 'retired at 0.0.1\n');
    expect(retired002.existsSync(), isTrue);
    expect(retired002.readAsStringSync(), 'retired at 0.0.2\n');
    expect(
      File('$root/index.json').readAsStringSync(),
      isNot(contains('retired')),
      reason: 'it is out of the index, which is what retiring means',
    );
  });

  test('writing a version replaces that exact item/version and no other', () {
    final _Fixture fixture = _Fixture.button();
    addTearDown(fixture.dispose);
    fixture.generator.build();

    final String root = '${fixture.root.path}/registry/generated/latest';

    // Three neighbours of the directory about to be rewritten: the same item at
    // another version, another item at the same version, and a stale file
    // inside the target itself.
    final File sameItemOtherVersion =
        File('$root/versions/button/0.0.9/logical/ui/button.dart')
          ..createSync(recursive: true)
          ..writeAsStringSync('nine\n');
    final File otherItemSameVersion =
        File('$root/versions/badge/0.0.1/logical/ui/badge.dart')
          ..createSync(recursive: true)
          ..writeAsStringSync('badge\n');
    final File staleInsideTarget =
        File('$root/versions/button/0.0.1/logical/ui/dropped.dart')
          ..createSync(recursive: true)
          ..writeAsStringSync('dropped\n');

    fixture.generator.build();

    expect(
      staleInsideTarget.existsSync(),
      isFalse,
      reason:
          'the target version is rewritten whole, so a dropped payload goes',
    );
    expect(sameItemOtherVersion.existsSync(), isTrue);
    expect(sameItemOtherVersion.readAsStringSync(), 'nine\n');
    expect(otherItemSameVersion.existsSync(), isTrue);
    expect(otherItemSameVersion.readAsStringSync(), 'badge\n');
    expect(
      File('$root/versions/button/0.0.1/logical/ui/button.dart').existsSync(),
      isTrue,
    );
  });

  test(
    'obsolete output goes only through the explicit prune, never a build',
    () {
      final _Fixture fixture = _Fixture.button();
      addTearDown(fixture.dispose);
      final GenerationSummary summary = fixture.generator.build();

      final String root = '${fixture.root.path}/registry/generated/latest';
      final File released =
          File('$root/versions/button/0.0.0/logical/ui/button.dart')
            ..createSync(recursive: true)
            ..writeAsStringSync('released\n');
      final File abandoned =
          File('$root/versions/button/0.9.9/logical/ui/button.dart')
            ..createSync(recursive: true)
            ..writeAsStringSync('abandoned draft\n');

      // A build touches neither.
      fixture.generator.build();
      expect(released.existsSync(), isTrue);
      expect(abandoned.existsSync(), isTrue);

      // The prune reports what it would remove, and removes nothing until asked.
      final List<String> planned = fixture.generator.pruneUnreleasedPayloads(
        document: summary.document,
        releasedVersions: const <String>{'0.0.0'},
      );
      expect(planned, <String>['versions/button/0.9.9']);
      expect(abandoned.existsSync(), isTrue, reason: 'dry run by default');

      final List<String> removed = fixture.generator.pruneUnreleasedPayloads(
        document: summary.document,
        releasedVersions: const <String>{'0.0.0'},
        dryRun: false,
      );
      expect(removed, <String>['versions/button/0.9.9']);
      expect(abandoned.existsSync(), isFalse);
      expect(
        released.existsSync(),
        isTrue,
        reason: 'a released version is safe',
      );
      expect(
        File('$root/versions/button/0.0.1/manifest.json').existsSync(),
        isTrue,
        reason: 'the current version is safe',
      );
    },
  );

  test('regenerating 0.0.2 alters no locked 0.0.1 payload', () {
    final _Fixture fixture = _Fixture.button();
    addTearDown(fixture.dispose);
    fixture.generator.build();

    // The lock: exactly what 0.0.1 published.
    final Map<String, String> locked = fixture.payloadDigests();
    expect(locked.keys.every((String k) => k.contains('/0.0.1/')), isTrue);
    expect(locked, isNotEmpty);

    fixture.republish(version: '0.0.2', source: 'const button = 2;\n');
    fixture.generator.build();

    final Map<String, String> after = fixture.payloadDigests();
    for (final MapEntry<String, String> entry in locked.entries) {
      expect(
        after,
        contains(entry.key),
        reason: '${entry.key} was removed by a later generation',
      );
      expect(
        after[entry.key],
        entry.value,
        reason: '${entry.key} was rewritten by a later generation',
      );
    }
    // …and the new version is there beside it, not instead of it.
    expect(after.keys.where((String k) => k.contains('/0.0.2/')), isNotEmpty);
  });

  test('fails before writing when a source hash drifts', () {
    final Directory root = Directory.systemTemp.createTempSync(
      'elattar-registry-drift-',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    File('${root.path}/lib/source.dart')
      ..createSync(recursive: true)
      ..writeAsStringSync('changed');
    final Directory manifestDirectory = Directory(
      '${root.path}/registry/components',
    )..createSync(recursive: true);
    File('${manifestDirectory.path}/drift.json').writeAsStringSync(
      jsonEncode(<String, Object?>{
        'schemaVersion': 1,
        'name': 'drift',
        'type': 'component',
        'version': '0.0.1',
        'description': 'Drift fixture.',
        'minDart': '3.12.2',
        'minFlutter': '3.44.8',
        'files': <Object?>[
          <String, Object?>{
            'source': 'lib/source.dart',
            'target': '@ui/drift.dart',
            'sha256':
                'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
          },
        ],
        'registryDependencies': <String>[],
        'pubDependencies': <String, String>{},
        'assets': <Object?>[],
        'fonts': <Object?>[],
        'shaders': <Object?>[],
        'documentationRoute': '/components/drift',
        'sourceLink': 'https://github.com/ELATTAR-Ayoub/flutter-design-system',
      }),
    );
    expect(
      () => RegistryGenerator(repositoryRoot: root).build(),
      throwsA(isA<RegistryGenerationException>()),
    );
  });
}

Map<String, List<int>> _snapshot(Directory directory) {
  final Map<String, List<int>> snapshot = <String, List<int>>{};
  for (final File file
      in directory.listSync(recursive: true).whereType<File>()) {
    snapshot[file.path.substring(directory.path.length)] = file
        .readAsBytesSync();
  }
  return snapshot;
}

/// A throwaway repository holding one manifest, for the rebuild tests.
class _Fixture {
  _Fixture(this.root, this.generator);

  factory _Fixture.button() {
    final Directory root = Directory.systemTemp.createTempSync(
      'elattar-registry-rebuild-',
    );
    final File source = File('${root.path}/lib/src/components/button.dart')
      ..createSync(recursive: true)
      ..writeAsStringSync('const button = true;\n');
    final String hash = sha256Hex(source.readAsBytesSync());
    Directory('${root.path}/registry/components').createSync(recursive: true);
    File('${root.path}/registry/components/button.json').writeAsStringSync(
      const JsonEncoder.withIndent('  ')
          .convert(<String, Object?>{
            'name': 'button',
            'type': 'component',
            'version': '0.0.1',
            'description': 'Button fixture.',
            'minDart': '3.12.2',
            'minFlutter': '3.44.8',
            'files': <Object?>[
              <String, Object?>{
                'source': 'lib/src/components/button.dart',
                'target': '@ui/button.dart',
                'sha256': '__HASH__',
              },
            ],
            'registryDependencies': <String>[],
            'pubDependencies': <String, String>{},
            'assets': <Object?>[],
            'fonts': <Object?>[],
            'shaders': <Object?>[],
            'documentationRoute': '/components/button',
            'sourceLink':
                'https://github.com/ELATTAR-Ayoub/flutter-design-system',
          })
          .replaceAll('__HASH__', hash),
    );
    return _Fixture(root, RegistryGenerator(repositoryRoot: root));
  }

  final Directory root;
  final RegistryGenerator generator;

  String get generated => '${root.path}/registry/generated/latest';

  /// Rewrites the source, reseals the manifest against it, and moves the item
  /// to [version] — what `reseal.dart` and `bump_version.dart` do together.
  void republish({required String version, required String source}) {
    final File file = File('${root.path}/lib/src/components/button.dart')
      ..writeAsStringSync(source);
    final File manifest = File('${root.path}/registry/components/button.json');
    final Map<String, Object?> json =
        jsonDecode(manifest.readAsStringSync()) as Map<String, Object?>;
    json['version'] = version;
    (((json['files']! as List<Object?>).single)
        as Map<String, Object?>)['sha256'] = sha256Hex(
      file.readAsBytesSync(),
    );
    manifest.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(json),
    );
  }

  /// Every payload under `versions/`, by path, with its digest.
  Map<String, String> payloadDigests() {
    final Directory versions = Directory('$generated/versions');
    return <String, String>{
      for (final File file
          in versions.listSync(recursive: true).whereType<File>())
        file.path
            .replaceAll(r'\', '/')
            .split('$generated/'.replaceAll(r'\', '/'))
            .last: sha256Hex(
          file.readAsBytesSync(),
        ),
    };
  }

  void dispose() => root.deleteSync(recursive: true);
}
