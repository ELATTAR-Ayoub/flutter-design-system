import 'dart:convert';
import 'dart:io';

import '../tool/registry_builder/lib/generator.dart';
import '../tool/registry_builder/lib/registry_schema.dart';
import '../tool/registry_builder/lib/registry_validator.dart';
import 'package:flutter_test/flutter_test.dart';

const String _hash =
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

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
  if (semanticDependencies != null)
    'semanticDependencies': semanticDependencies,
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

void main() {
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
          'sourceLink': 'https://github.com/ELATTAR-Ayoub/flutter-design-system',
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
