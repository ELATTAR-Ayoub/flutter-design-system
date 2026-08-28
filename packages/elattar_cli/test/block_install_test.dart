import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../lib/src/registry/client.dart' show sha256Hex;

/// End-to-end proof for the `shot` item kind — against a synthetic registry.
///
/// **This is not the consumer-install proof, and CI must not describe it as
/// one.** No `shot` item has shipped since `9c48294` removed them from the
/// registry, so this suite builds its own throwaway design system and its own
/// registry to install from. It proves the item kind still works; it says
/// nothing about the artifact a public user receives. That claim belongs to
/// `public_consumer_test.dart`, which installs *this repository's* generated
/// registry over HTTP and then runs a widget test inside the result.
///
/// Builds a throwaway source repository containing a foundation, a component
/// and two shots, generates and validates a registry from it with the real
/// builder binaries, installs into a clean consumer project with the real CLI,
/// and finally analyses that consumer project. The point of the last step is
/// that a shot's `package:elattar_design_system` import must have been
/// rewritten onto the barrels the installer generates — otherwise the consumer
/// does not analyse, because it has no such dependency.
void main() {
  test(
    'a shot generates, validates, installs and its imports resolve in a clean consumer',
    () async {
      final Directory packageRoot = Directory.current.absolute;
      final Directory repoRoot = packageRoot.parent.parent.absolute;
      final Directory scratch = await Directory.systemTemp.createTemp(
        'elattar-shot-e2e-',
      );
      addTearDown(() => scratch.deleteSync(recursive: true));

      final Directory source = Directory('${scratch.path}/source-repo')
        ..createSync(recursive: true);
      final Directory consumer = Directory('${scratch.path}/consumer')
        ..createSync(recursive: true);

      // ── the throwaway design system + shots ──────────────────────────────
      final File tokens = _write(
        source,
        'lib/src/design_system/foundation/tokens.dart',
        '''
import 'package:flutter/widgets.dart';

const Color shotFixtureInk = Color(0xFF101010);
''',
      );
      final File panel = _write(source, 'lib/src/components/ui/panel.dart', '''
import 'package:flutter/widgets.dart';

import '../../design_system/foundation/tokens.dart';

class ShotFixturePanel extends StatelessWidget {
  const ShotFixturePanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      ColoredBox(color: shotFixtureInk, child: child);
}
''');
      // Installs two directories deep and uses BOTH barrels.
      final File consoleShot = _write(
        source,
        'lib/src/blocks/console/console.dart',
        '''
import 'package:flutter/widgets.dart';

import 'package:elattar_design_system/elattar_design_system.dart';

/// Shots are documentation-shaped code. The words below are a doc comment and
/// a string literal, not directives, and the installer must leave both alone:
/// rewriting them injects directives after a declaration has opened (which does
/// not compile) or into the middle of a string, and the `as space` form aborts the
/// install outright.
///
/// ```dart
/// import 'package:elattar_design_system/elattar_design_system.dart';
/// ```
// import 'package:elattar_design_system/elattar_design_system.dart' as space;
class ConsoleShot extends StatelessWidget {
  const ConsoleShot({super.key});

  static const String snippet =
      "import 'package:elattar_design_system/elattar_design_system.dart' as space;";

  @override
  Widget build(BuildContext context) => const ShotFixturePanel(
    child: Text('console', style: TextStyle(color: shotFixtureInk)),
  );
}
''',
      );
      // Installs one directory deep and deliberately uses ONLY the component
      // barrel, so the generated foundation import is genuinely unused. If the
      // fan-out were not suppressed, `flutter analyze` below would fail.
      final File minimalShot = _write(source, 'lib/src/blocks/minimal.dart', '''
import 'package:flutter/widgets.dart';

import 'package:elattar_design_system/elattar_design_system.dart';

class MinimalShot extends StatelessWidget {
  const MinimalShot({super.key});

  @override
  Widget build(BuildContext context) =>
      const ShotFixturePanel(child: Text('minimal'));
}
''');

      _manifest(
        source,
        'registry/foundations/source-foundation.json',
        <String, Object?>{
          'name': 'source-foundation',
          'type': 'foundation',
          'description': 'Fixture foundation.',
          'files': <Object?>[
            _fileEntry(
              tokens,
              'lib/src/design_system/foundation/tokens.dart',
              '@foundation/tokens.dart',
            ),
          ],
          'registryDependencies': <String>[],
          'documentationRoute': '/foundations/source',
        },
      );
      _manifest(source, 'registry/components/panel.json', <String, Object?>{
        'name': 'panel',
        'type': 'component',
        'description': 'Fixture component.',
        'files': <Object?>[
          _fileEntry(
            panel,
            'lib/src/components/ui/panel.dart',
            '@ui/panel.dart',
          ),
        ],
        'registryDependencies': <String>['source-foundation'],
        'documentationRoute': '/components/panel',
      });
      _manifest(source, 'registry/blocks/console-block.json', <String, Object?>{
        'name': 'console-block',
        'type': 'block',
        'description': 'Fixture application composition.',
        'files': <Object?>[
          _fileEntry(
            consoleShot,
            'lib/src/blocks/console/console.dart',
            '@block/console/console.dart',
          ),
        ],
        'registryDependencies': <String>['panel'],
        'documentationRoute': '/blocks/console',
      });
      _manifest(source, 'registry/blocks/minimal-block.json', <String, Object?>{
        'name': 'minimal-block',
        'type': 'block',
        'description': 'Fixture application composition, shallow target.',
        'files': <Object?>[
          _fileEntry(
            minimalShot,
            'lib/src/blocks/minimal.dart',
            '@block/minimal.dart',
          ),
        ],
        'registryDependencies': <String>['panel'],
        'documentationRoute': '/blocks/minimal',
      });

      // ── generate + validate with the real builder binaries ───────────────
      final ProcessResult build = await Process.run(
        Platform.resolvedExecutable,
        <String>[
          '${repoRoot.path}/tool/registry_builder/bin/build.dart',
          source.path,
        ],
        workingDirectory: repoRoot.path,
      );
      expect(
        build.exitCode,
        0,
        reason: 'stdout:\n${build.stdout}\nstderr:\n${build.stderr}',
      );
      expect(build.stdout.toString(), contains('Generated 4 item(s)'));

      final String registryPath = '${source.path}/registry/generated/latest';
      final ProcessResult validate =
          await Process.run(Platform.resolvedExecutable, <String>[
            '${repoRoot.path}/tool/registry_builder/bin/validate.dart',
            '$registryPath/registry.json',
          ], workingDirectory: repoRoot.path);
      expect(
        validate.exitCode,
        0,
        reason: 'stdout:\n${validate.stdout}\nstderr:\n${validate.stderr}',
      );

      // The block payload must land under the `block` logical folder.
      expect(
        File(
          '$registryPath/versions/console-block/0.0.1/logical/block/console/console.dart',
        ).existsSync(),
        isTrue,
      );

      // ── install into a clean consumer project ────────────────────────────
      _write(consumer, 'pubspec.yaml', '''
name: shot_consumer
description: clean consumer fixture
publish_to: none
environment:
  sdk: ^3.12.2
dependencies:
  flutter:
    sdk: flutter
dev_dependencies:
  flutter_lints: ^6.0.0
flutter:
''');
      _write(
        consumer,
        'analysis_options.yaml',
        'include: package:flutter_lints/flutter.yaml\n',
      );

      final String cli = '${packageRoot.path}/bin/elattar.dart';
      final ProcessResult init = await Process.run(
        Platform.resolvedExecutable,
        <String>[cli, 'init', '--registry', registryPath],
        workingDirectory: consumer.path,
      );
      expect(
        init.exitCode,
        0,
        reason: 'stdout:\n${init.stdout}\nstderr:\n${init.stderr}',
      );

      final ProcessResult add = await Process.run(
        Platform.resolvedExecutable,
        <String>[
          cli,
          'add',
          'console-block',
          'minimal-block',
          '--registry',
          registryPath,
        ],
        workingDirectory: consumer.path,
      );
      expect(
        add.exitCode,
        0,
        reason: 'stdout:\n${add.stdout}\nstderr:\n${add.stderr}',
      );

      // ── the installed shot's imports ─────────────────────────────────────
      final File installedConsole = File(
        '${consumer.path}/lib/blocks/console/console.dart',
      );
      final File installedMinimal = File(
        '${consumer.path}/lib/blocks/minimal.dart',
      );
      expect(installedConsole.existsSync(), isTrue);
      expect(installedMinimal.existsSync(), isTrue);

      final String consoleText = installedConsole.readAsStringSync();
      expect(consoleText, contains("import '../../components/ui/ui.dart';"));
      expect(
        consoleText,
        contains("import '../../design_system/foundation.dart';"),
      );
      // No directive still points at the package...
      expect(
        RegExp(
          r"^\s*(import|export)\s+'package:elattar_design_system",
          multiLine: true,
        ).hasMatch(consoleText),
        isFalse,
      );
      // ...the fan-out happened exactly once...
      expect(
        "import '../../components/ui/ui.dart';".allMatches(consoleText).length,
        1,
      );
      // ...and the doc comment, line comment and string literal that merely
      // mention an import survived byte for byte.
      expect(
        consoleText,
        contains(
          "/// import 'package:elattar_design_system/elattar_design_system.dart';",
        ),
      );
      expect(
        consoleText,
        contains(
          "// import 'package:elattar_design_system/elattar_design_system.dart' as space;",
        ),
      );
      expect(
        consoleText,
        contains(
          r'''"import 'package:elattar_design_system/elattar_design_system.dart' as space;";''',
        ),
      );

      final String minimalText = installedMinimal.readAsStringSync();
      expect(minimalText, isNot(contains('package:elattar_design_system')));
      expect(minimalText, contains("import '../components/ui/ui.dart';"));
      expect(
        minimalText,
        contains("import '../design_system/foundation.dart';"),
      );

      // The barrels the rewritten imports point at must exist and carry the
      // symbols the shots use.
      final String uiBarrel = File(
        '${consumer.path}/lib/components/ui/ui.dart',
      ).readAsStringSync();
      expect(uiBarrel, contains("export 'panel.dart';"));
      // A shot is application code and is never re-exported from the barrels.
      expect(uiBarrel, isNot(contains('shot')));
      final String foundationBarrel = File(
        '${consumer.path}/lib/design_system/foundation.dart',
      ).readAsStringSync();
      expect(foundationBarrel, contains("export 'foundation/tokens.dart';"));

      // Shots are tracked in the manifest under their consumer-local target.
      final Map<String, Object?> manifest =
          jsonDecode(
                File(
                  '${consumer.path}/.elattar/manifest.json',
                ).readAsStringSync(),
              )
              as Map<String, Object?>;
      final List<Object?> items = manifest['items']! as List<Object?>;
      final Map<String, Object?> shot = items
          .cast<Map<String, Object?>>()
          .firstWhere(
            (Map<String, Object?> item) => item['name'] == 'console-block',
          );
      expect(
        ((shot['files']! as List<Object?>).single
            as Map<String, Object?>)['target'],
        'lib/blocks/console/console.dart',
      );

      // ── the proof: the consumer analyses clean ───────────────────────────
      final ProcessResult analyze = await Process.run(
        Platform.isWindows ? 'flutter.bat' : 'flutter',
        <String>['analyze'],
        workingDirectory: consumer.path,
      );
      expect(
        analyze.exitCode,
        0,
        reason:
            '${analyze.stdout}\n${analyze.stderr}\n\nconsole:\n$consoleText\n\nminimal:\n$minimalText',
      );
      // Guard against a silently-skipped gate: assert the analyzer actually
      // reported on this project rather than exiting 0 for another reason.
      expect(analyze.stdout.toString(), contains('No issues found!'));
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );
}

File _write(Directory root, String relative, String content) {
  final File file = File('${root.path}/$relative')
    ..createSync(recursive: true)
    ..writeAsStringSync(content);
  return file;
}

Map<String, Object?> _fileEntry(File source, String relative, String target) {
  return <String, Object?>{
    'source': relative,
    'target': target,
    'sha256': sha256Hex(source.readAsBytesSync()),
  };
}

void _manifest(
  Directory root,
  String relative,
  Map<String, Object?> overrides,
) {
  _write(
    root,
    relative,
    const JsonEncoder.withIndent('  ').convert(<String, Object?>{
      'version': '0.0.1',
      'minDart': '3.12.2',
      'minFlutter': '3.44.8',
      'pubDependencies': <String, String>{},
      'assets': <Object?>[],
      'fonts': <Object?>[],
      'shaders': <Object?>[],
      'sourceLink': 'https://github.com/ELATTAR-Ayoub/flutter-design-system',
      ...overrides,
    }),
  );
}
