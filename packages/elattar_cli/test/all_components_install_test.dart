import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

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
name: all_components_fixture
description: fixture
environment:
  sdk: ^3.12.2
dependencies:
  flutter:
    sdk: flutter
flutter:
''';

Directory _flutterProject() {
  final Directory root = Directory.systemTemp.createTempSync(
    'elattar-cli-all-components-',
  );
  File('${root.path}/pubspec.yaml').writeAsStringSync(_defaultPubspec);
  File('${root.path}/.dart_tool/package_config.json')
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(
      jsonEncode(<String, Object?>{
        'configVersion': 2,
        'packages': <Object?>[
          <String, Object?>{'name': 'flutter', 'rootUri': 'file:///flutter'},
        ],
      }),
    );
  return root;
}

Future<ProcessResult> _run(Directory project, List<String> arguments) {
  return Process.run(Platform.resolvedExecutable, <String>[
    _script,
    ...arguments,
  ], workingDirectory: project.path);
}

List<String> _installableOwners() {
  final Map<String, Object?> inventory =
      jsonDecode(
            File(
              '$_repoRoot${Platform.pathSeparator}registry${Platform.pathSeparator}component_inventory.json',
            ).readAsStringSync(),
          )
          as Map<String, Object?>;
  final List<Object?> owners = inventory['installableOwners']! as List<Object?>;
  return <String>[for (final Object? owner in owners) owner! as String];
}

List<String> _writtenPaths(ProcessResult result) {
  return LineSplitter.split('${result.stdout}')
      .where((String line) => line.startsWith(' - '))
      .map((String line) => line.substring(3).replaceAll('\\', '/'))
      .toList()
    ..sort();
}

void main() {
  test(
    '--all matches the explicit installable inventory surface',
    () async {
      final Directory root = _flutterProject();
      addTearDown(() => root.deleteSync(recursive: true));

      final ProcessResult init = await _run(root, <String>[
        'init',
        '--registry',
        _registryPath,
      ]);
      expect(init.exitCode, 0, reason: '${init.stdout}${init.stderr}');

      final ProcessResult allResult = await _run(root, <String>[
        'add',
        '--all',
        '--dry-run',
        '--registry',
        _registryPath,
      ]);
      expect(
        allResult.exitCode,
        0,
        reason: '${allResult.stdout}${allResult.stderr}',
      );

      final ProcessResult explicitResult = await _run(root, <String>[
        'add',
        ..._installableOwners(),
        '--dry-run',
        '--registry',
        _registryPath,
      ]);
      expect(
        explicitResult.exitCode,
        0,
        reason: '${explicitResult.stdout}${explicitResult.stderr}',
      );

      expect(_writtenPaths(allResult), _writtenPaths(explicitResult));
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
