import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test(
    'init then add button against the generated registry installs files and metadata',
    () async {
      final Directory packageRoot = Directory.current.absolute;
      final Directory repoRoot = packageRoot.parent.parent.absolute;
      final Directory fixture = await Directory.systemTemp.createTemp(
        'elattar-cli-fixture-',
      );
      addTearDown(() => fixture.deleteSync(recursive: true));

      final File pubspec = File('${fixture.path}/pubspec.yaml');
      await pubspec.writeAsString('''
name: cli_fixture
description: test fixture
environment:
  sdk: ^3.12.2
dependencies:
  flutter:
    sdk: flutter
flutter:
''');

      final String registryPath =
          '${repoRoot.path}${Platform.pathSeparator}registry${Platform.pathSeparator}generated${Platform.pathSeparator}latest';
      final String scriptPath =
          '${packageRoot.path}${Platform.pathSeparator}bin${Platform.pathSeparator}elattar.dart';

      final ProcessResult init = await Process.run(
        Platform.resolvedExecutable,
        <String>[scriptPath, 'init', '--registry', registryPath],
        workingDirectory: fixture.path,
      );
      expect(
        init.exitCode,
        0,
        reason: 'stdout:\n${init.stdout}\n\nstderr:\n${init.stderr}',
      );

      final String pubspecAfterInit = await pubspec.readAsString();
      expect(
        () => loadYaml(pubspecAfterInit),
        returnsNormally,
        reason: 'pubspec after init was invalid:\n$pubspecAfterInit',
      );

      final File initConfigFile = File('${fixture.path}/elattar.yaml');
      final String initConfigText = await initConfigFile.readAsString();
      expect(
        () => loadYaml(initConfigText),
        returnsNormally,
        reason: 'elattar.yaml after init was invalid:\n$initConfigText',
      );

      final File configFile = File('${fixture.path}/elattar.yaml');
      final ProcessResult add = await Process.run(
        Platform.resolvedExecutable,
        <String>[scriptPath, 'add', 'button', '--registry', registryPath],
        workingDirectory: fixture.path,
      );
      expect(
        add.exitCode,
        0,
        reason:
            'stdout:\n${add.stdout}\n\nstderr:\n${add.stderr}\n\npubspec:\n${await pubspec.readAsString()}\n\nelattar.yaml:\n${await configFile.readAsString()}',
      );

      expect(configFile.existsSync(), isTrue);
      final String configText = await configFile.readAsString();
      expect(configText, contains('foundation: source'));
      // elattar.yaml is committed, so it never records a machine-local
      // absolute path, and it publishes no key that nothing reads.
      expect(configText, isNot(contains(repoRoot.path)));
      expect(configText, isNot(contains('paths:')));
      expect(configText, isNot(contains('barrels:')));

      final File buttonFile = File(
        '${fixture.path}/lib/components/ui/button.dart',
      );
      final File iconFile = File('${fixture.path}/lib/components/ui/icon.dart');
      final File spinnerFile = File(
        '${fixture.path}/lib/components/ui/spinner.dart',
      );
      final File motionFile = File(
        '${fixture.path}/lib/design_system/motion/press.dart',
      );
      final File effectFile = File(
        '${fixture.path}/lib/design_system/effects/machine_surface.dart',
      );
      final File foundationFile = File(
        '${fixture.path}/lib/design_system/foundation/colors.dart',
      );
      final File fontFile = File(
        '${fixture.path}/assets/elattar/fonts/InterVariable.ttf',
      );
      final File uiBarrel = File('${fixture.path}/lib/components/ui/ui.dart');
      final File foundationBarrel = File(
        '${fixture.path}/lib/design_system/foundation.dart',
      );
      final File manifestFile = File('${fixture.path}/.elattar/manifest.json');
      expect(buttonFile.existsSync(), isTrue);
      expect(iconFile.existsSync(), isTrue);
      expect(spinnerFile.existsSync(), isTrue);
      expect(motionFile.existsSync(), isTrue);
      expect(effectFile.existsSync(), isTrue);
      expect(foundationFile.existsSync(), isTrue);
      expect(fontFile.existsSync(), isTrue);
      expect(uiBarrel.existsSync(), isTrue);
      expect(foundationBarrel.existsSync(), isTrue);
      expect(manifestFile.existsSync(), isTrue);

      final String buttonText = await buttonFile.readAsString();
      expect(
        buttonText,
        contains("import '../../design_system/foundation/colors.dart'"),
      );
      expect(
        buttonText,
        contains("import '../../design_system/effects/machine_surface.dart'"),
      );

      final String uiBarrelText = await uiBarrel.readAsString();
      expect(uiBarrelText, contains("export 'button.dart';"));
      expect(uiBarrelText, contains("export 'icon.dart';"));

      final YamlMap pubspecYaml =
          loadYaml(await pubspec.readAsString()) as YamlMap;
      final YamlMap flutter = pubspecYaml['flutter'] as YamlMap;
      final YamlList? assets = flutter['assets'] as YamlList?;
      final YamlList fonts = flutter['fonts'] as YamlList;
      expect(assets, isNull);
      expect(fonts.length, greaterThanOrEqualTo(1));

      final Map<String, Object?> manifest =
          jsonDecode(await manifestFile.readAsString()) as Map<String, Object?>;
      expect(manifest['foundation'], 'source');
      final List<Object?> items = manifest['items']! as List<Object?>;
      for (final Map<String, Object?> item
          in items.cast<Map<String, Object?>>()) {
        final List<Object?> files = item['files']! as List<Object?>;
        for (final Map<String, Object?> file
            in files.cast<Map<String, Object?>>()) {
          final String? installedHash = file['installedHash'] as String?;
          expect(
            installedHash,
            isNotEmpty,
            reason:
                'installedHash missing for ${item['name']} -> ${file['target']}',
          );
        }
      }
      final List<String> names =
          items
              .cast<Map<String, Object?>>()
              .map((Map<String, Object?> item) => item['name']! as String)
              .toList()
            ..sort();
      expect(
        names,
        containsAll(<String>[
          'button',
          'icon',
          'spinner',
          'source-foundation',
          'press-motion',
          'machine-surface',
          'foil-value',
          'sheen-action',
        ]),
      );

      final ProcessResult analyze = await Process.run(
        Platform.isWindows ? 'flutter.bat' : 'flutter',
        <String>['analyze'],
        workingDirectory: fixture.path,
      );
      expect(
        analyze.exitCode,
        0,
        reason: '${analyze.stdout}\n${analyze.stderr}',
      );
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
