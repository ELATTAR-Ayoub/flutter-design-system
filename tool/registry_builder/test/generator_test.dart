import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

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
