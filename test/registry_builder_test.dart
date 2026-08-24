import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import '../tool/registry_builder/lib/generator.dart';
import '../tool/registry_builder/lib/registry_schema.dart';
import '../tool/registry_builder/lib/registry_validator.dart';

const String _hash =
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
const Set<String> _inventoryClassifications = <String>{
  'installable',
  'dependency',
  'bundled',
};

Map<String, Object?> _file({String target = '@ui/button.dart'}) =>
    <String, Object?>{
      'source': 'lib/src/components/button.dart',
      'target': target,
      'sha256': _hash,
    };

Map<String, Object?> _item({
  required String name,
  List<String> dependencies = const <String>[],
  List<String>? semanticDependencies,
  String target = '@ui/button.dart',
}) => <String, Object?>{
  'name': name,
  'type': 'component',
  'version': '0.0.1',
  'description': 'A test registry item.',
  'minDart': '3.12.2',
  'minFlutter': '3.44.8',
  'files': <Object?>[_file(target: target)],
  'registryDependencies': dependencies,
  if (semanticDependencies case final List<String> deps)
    'semanticDependencies': deps,
  'pubDependencies': <String, String>{},
  'assets': <Object?>[],
  'fonts': <Object?>[],
  'shaders': <Object?>[],
  'documentationRoute': '/docs/components/$name',
  'sourceLink': 'https://github.com/ELATTAR-Ayoub/flutter-design-system',
};

RegistryDocument _document(List<Map<String, Object?>> items) =>
    RegistryDocument.fromJson(<String, Object?>{
      'schemaVersion': 1,
      'registryVersion': '0.0.1',
      'items': items,
    });

Map<String, Object?> _jsonFile(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;

Set<String> _exportedSources(String folder) {
  final File barrel = File('lib/elattar_design_system.dart');
  final RegExp pattern = RegExp(
    "^export 'src/$folder/(.+)';"
    r'$',
  );
  return <String>{
    for (final String line in barrel.readAsLinesSync())
      if (pattern.hasMatch(line))
        'lib/src/$folder/${pattern.firstMatch(line)!.group(1)!}',
  };
}

Map<String, Set<String>> _manifestSourcesByOwner(String folder) {
  final Map<String, Set<String>> result = <String, Set<String>>{};
  for (final File file in Directory(
    'registry/$folder',
  ).listSync().whereType<File>()) {
    final Map<String, Object?> json = _jsonFile(file.path);
    result[json['name']! as String] = <String>{
      for (final Map<String, Object?> entry
          in (json['files']! as List<Object?>).cast<Map<String, Object?>>())
        entry['source']! as String,
    };
  }
  return result;
}

Map<String, String> _primaryManifestSourceByOwner(String folder) {
  final Map<String, String> result = <String, String>{};
  for (final File file in Directory(
    'registry/$folder',
  ).listSync().whereType<File>()) {
    final Map<String, Object?> json = _jsonFile(file.path);
    final List<Object?> files = json['files']! as List<Object?>;
    result[json['name']! as String] =
        (files.first as Map<String, Object?>)['source']! as String;
  }
  return result;
}

List<String> _componentInventoryProblems(Map<String, Object?> inventory) {
  final List<String> problems = <String>[];
  if (inventory['schemaVersion'] != 1) {
    problems.add('schemaVersion must be 1.');
  }
  if (inventory['publicBarrel'] != 'lib/elattar_design_system.dart') {
    problems.add('publicBarrel must point at lib/elattar_design_system.dart.');
  }
  final Object? rawOwners = inventory['installableOwners'];
  if (rawOwners is! List<Object?>) {
    problems.add('installableOwners must be an array.');
    return problems;
  }
  final Object? rawComponents = inventory['components'];
  if (rawComponents is! List<Object?>) {
    problems.add('components must be an array.');
    return problems;
  }
  final Set<String> exportedSources = _exportedSources('components');
  final Map<String, Set<String>> manifestSources = _manifestSourcesByOwner(
    'components',
  );
  final Map<String, String> primarySources = _primaryManifestSourceByOwner(
    'components',
  );
  final Set<String> installableOwners = <String>{};
  final Set<String> seenSources = <String>{};
  for (int i = 0; i < rawComponents.length; i++) {
    final Object? value = rawComponents[i];
    if (value is! Map<String, Object?>) {
      problems.add('components[$i] must be an object.');
      continue;
    }
    final String? source = value['source'] as String?;
    final String? owner = value['owner'] as String?;
    final String? classification = value['classification'] as String?;
    if (source == null || source.isEmpty) {
      problems.add('components[$i].source must be a non-empty string.');
      continue;
    }
    if (!seenSources.add(source)) {
      problems.add('duplicate inventory source: $source');
    }
    if (!exportedSources.contains(source)) {
      problems.add('inventory source is not publicly exported: $source');
    }
    if (owner == null || owner.isEmpty) {
      problems.add('components[$i].owner must be a non-empty string.');
      continue;
    }
    final Set<String>? ownerSources = manifestSources[owner];
    if (ownerSources == null) {
      problems.add('inventory owner has no component manifest: $owner');
      continue;
    }
    if (!ownerSources.contains(source)) {
      problems.add('inventory source $source is not owned by manifest $owner');
    }
    if (classification == null ||
        !_inventoryClassifications.contains(classification)) {
      problems.add('components[$i].classification is invalid for $source');
      continue;
    }
    if (classification == 'bundled') {
      if (primarySources[owner] == source) {
        problems.add('bundled source cannot be the primary file: $source');
      }
    } else {
      if (primarySources[owner] != source) {
        problems.add(
          '$classification source must be the primary file for $owner: $source',
        );
      }
      if (classification == 'installable') {
        installableOwners.add(owner);
      }
    }
  }
  final Set<String> inventorySources = <String>{
    for (final Object? value in rawComponents)
      if (value is Map<String, Object?> && value['source'] is String)
        value['source']! as String,
  };
  final Set<String> missing = exportedSources.difference(inventorySources);
  if (missing.isNotEmpty) {
    problems.add(
      'inventory is missing exported component sources: ${missing.toList()..sort()}',
    );
  }
  final List<String> ownerList = <String>[
    for (final Object? value in rawOwners)
      if (value is String && value.trim().isNotEmpty)
        value
      else
        throw const FormatException(
          'installableOwners must contain non-empty strings.',
        ),
  ];
  if (ownerList.toSet().length != ownerList.length) {
    problems.add('installableOwners contains duplicates.');
  }
  final List<String> sortedOwners = ownerList.toList()..sort();
  if (!_listsEqual(sortedOwners, installableOwners.toList()..sort())) {
    problems.add(
      'installableOwners must match the installable component owners exactly.',
    );
  }
  return problems;
}

bool _listsEqual(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

void main() {
  test('public barrel exports are fully covered by registry manifests', () {
    final Set<String> exportedSources = <String>{
      ..._exportedSources('components'),
      ..._exportedSources('effects'),
      ..._exportedSources('motion'),
    };
    final Set<String> manifestSources = <String>{};
    for (final String folder in <String>[
      'registry/components',
      'registry/effects',
      'registry/motion',
    ]) {
      for (final File file in Directory(folder).listSync().whereType<File>()) {
        final Map<String, Object?> json =
            jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
        for (final Map<String, Object?> entry
            in (json['files']! as List<Object?>).cast<Map<String, Object?>>()) {
          manifestSources.add(entry['source']! as String);
        }
      }
    }
    expect(
      manifestSources.contains('lib/src/components/rule.dart'),
      isTrue,
      reason: 'rule.dart must be distributed under the new rule item.',
    );
    expect(
      Directory('registry/components')
          .listSync()
          .whereType<File>()
          .map((File file) => file.uri.pathSegments.last)
          .where((String name) => name.endsWith('rule.json'))
          .toList(),
      <String>['rule.json'],
      reason: 'only the new rule manifest should remain.',
    );
    expect(exportedSources.difference(manifestSources), isEmpty);
  });

  test('component inventory classifies every exported component once', () {
    final List<String> problems = _componentInventoryProblems(
      _jsonFile('registry/component_inventory.json'),
    );
    expect(problems, isEmpty, reason: problems.join('\n'));
  });

  test('component inventory flags duplicate ownership and missing coverage', () {
    final Map<String, Object?> inventory = _jsonFile(
      'registry/component_inventory.json',
    );
    final List<Object?> components = List<Object?>.from(
      inventory['components']! as List<Object?>,
    );
    final Map<String, Object?> first = Map<String, Object?>.from(
      components.first as Map<String, Object?>,
    );
    final Map<String, Object?> second = Map<String, Object?>.from(
      components[1] as Map<String, Object?>,
    );
    final List<String> problems = _componentInventoryProblems(<String, Object?>{
      ...inventory,
      'installableOwners': <Object?>['accordion'],
      'components':
          <Object?>[
            first,
            ...components.skip(2),
            first,
            <String, Object?>{...first, 'owner': 'button'},
          ]..removeWhere(
            (Object? value) =>
                value is Map<String, Object?> &&
                value['source'] == second['source'],
          ),
    });
    expect(
      problems,
      contains(contains('inventory is missing exported component sources')),
    );
    expect(problems, contains(contains('duplicate inventory source')));
    expect(
      problems,
      contains(
        contains(
          'installableOwners must match the installable component owners exactly.',
        ),
      ),
    );
  });

  test('parses schema v1 JSON into typed models', () {
    final RegistryDocument document = RegistryDocument.fromJsonString(
      jsonEncode(<String, Object?>{
        'schemaVersion': 1,
        'registryVersion': '0.0.1',
        'items': <Object?>[_item(name: 'button')],
      }),
    );
    expect(document.schemaVersion, 1);
    expect(document.items.single.name, 'button');
    expect(document.items.single.files.single.target, '@ui/button.dart');
  });

  test('rejects missing required fields and malformed JSON values', () {
    expect(
      () => RegistryDocument.fromJson(<String, Object?>{
        'schemaVersion': 1,
        'registryVersion': '0.0.1',
        'items': <Object?>[
          <String, Object?>{'name': 'button'},
        ],
      }),
      throwsFormatException,
    );
    expect(() => RegistryDocument.fromJsonString('{'), throwsFormatException);
  });

  test('validates a complete item', () {
    expect(
      validateRegistry(
        _document(<Map<String, Object?>>[_item(name: 'button')]),
      ).isValid,
      isTrue,
    );
  });

  test(
    'rejects duplicate names, targets, invalid target, and invalid hash',
    () {
      final Map<String, Object?> invalid = _item(
        name: 'button',
        target: '../button.dart',
      );
      (invalid['files']! as List<Object?>)[0] = <String, Object?>{
        ..._file(target: '../button.dart'),
        'sha256': 'bad',
      };
      final RegistryValidationResult result = validateRegistry(
        _document(<Map<String, Object?>>[_item(name: 'button'), invalid]),
      );
      expect(result.errors, contains(contains('duplicates')));
      expect(result.errors, contains(contains('SHA-256')));
      expect(result.errors, contains(contains('logical target')));
    },
  );

  test('rejects missing and cyclic dependencies', () {
    final RegistryValidationResult missing = validateRegistry(
      _document(<Map<String, Object?>>[
        _item(name: 'button', dependencies: <String>['icon']),
      ]),
    );
    expect(missing.errors, contains(contains('missing item icon')));

    final RegistryValidationResult cycle = validateRegistry(
      _document(<Map<String, Object?>>[
        _item(
          name: 'button',
          dependencies: <String>['icon'],
          target: '@ui/button.dart',
        ),
        _item(
          name: 'icon',
          dependencies: <String>['button'],
          target: '@ui/icon.dart',
        ),
      ]),
    );
    expect(cycle.errors, contains(contains('dependency cycle')));
  });

  test('semantic dependencies must be declared registry dependencies', () {
    final RegistryValidationResult result = validateRegistry(
      _document(<Map<String, Object?>>[
        _item(name: 'button', semanticDependencies: <String>['icon']),
      ]),
    );
    expect(result.errors, contains(contains('semanticDependencies')));
  });

  test('shot is a parsable item kind installing under @app/', () {
    final Map<String, Object?> shot = _item(
      name: 'console-shot',
      target: '@app/shots/console/console_shot.dart',
    )..['type'] = 'shot';
    final RegistryDocument document = RegistryDocument.fromJsonString(
      jsonEncode(<String, Object?>{
        'schemaVersion': 1,
        'registryVersion': '0.0.1',
        'items': <Object?>[shot],
      }),
    );
    expect(document.items.single.type, RegistryItemType.shot);
    expect(validateRegistry(document).isValid, isTrue);
  });

  test('unknown item kinds and unknown target prefixes are still rejected', () {
    expect(
      () => RegistryDocument.fromJson(<String, Object?>{
        'schemaVersion': 1,
        'registryVersion': '0.0.1',
        'items': <Object?>[_item(name: 'nope')..['type'] = 'screen'],
      }),
      throwsFormatException,
    );
    final RegistryValidationResult result = validateRegistry(
      _document(<Map<String, Object?>>[
        _item(name: 'nope', target: '@screens/x.dart'),
      ]),
    );
    expect(result.errors, contains(contains('logical target')));
  });

  test('the generator picks up manifests under registry/shots/', () {
    final Directory root = Directory.systemTemp.createTempSync(
      'elattar-shots-scan-',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    final File source = File('${root.path}/lib/shots/console/console_shot.dart')
      ..createSync(recursive: true)
      ..writeAsStringSync('const consoleShot = true;\n');
    File('${root.path}/registry/shots/console-shot.json')
      ..createSync(recursive: true)
      ..writeAsStringSync(
        jsonEncode(<String, Object?>{
          'name': 'console-shot',
          'type': 'shot',
          'version': '0.0.1',
          'description': 'Console shot fixture.',
          'minDart': '3.12.2',
          'minFlutter': '3.44.8',
          'files': <Object?>[
            <String, Object?>{
              'source': 'lib/shots/console/console_shot.dart',
              'target': '@app/shots/console/console_shot.dart',
              'sha256': sha256Hex(source.readAsBytesSync()),
            },
          ],
          'registryDependencies': <String>[],
          'pubDependencies': <String, String>{},
          'assets': <Object?>[],
          'fonts': <Object?>[],
          'shaders': <Object?>[],
          'documentationRoute': '/shots/console',
          'sourceLink':
              'https://github.com/ELATTAR-Ayoub/flutter-design-system',
        }),
      );

    final GenerationSummary summary = RegistryGenerator(
      repositoryRoot: root,
    ).build();
    expect(summary.document.items.single.name, 'console-shot');
    expect(summary.document.items.single.type, RegistryItemType.shot);
    expect(
      File(
        '${root.path}/registry/generated/latest/versions/console-shot/0.0.1/'
        'logical/app/shots/console/console_shot.dart',
      ).existsSync(),
      isTrue,
    );
  });
}
