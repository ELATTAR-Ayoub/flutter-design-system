import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../packages/elattar_cli/lib/src/config.dart';
import '../packages/elattar_cli/lib/src/identity.dart';
import '../packages/elattar_cli/lib/src/manifest.dart';
import '../packages/elattar_cli/lib/src/project.dart';

void main() {
  test('identity is centralised, and the registry URL derives from it', () {
    expect(cliName, 'elattar');
    expect(cliVersion, '0.0.2');
    expect(CliIdentity.name, cliName);
    expect(CliIdentity.version, cliVersion);
    // The version is stated once and the endpoint is built from it, so a CLI
    // can never read a registry version other than its own.
    expect(defaultRegistryUrl, endsWith('/registry/$cliVersion/'));
  });

  test('discovers the nearest Flutter project from a nested directory', () {
    final Directory root = Directory.systemTemp.createTempSync(
      'elattar-project-',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    File('${root.path}/pubspec.yaml').writeAsStringSync(
      'name: demo\ndependencies:\n  flutter:\n    sdk: flutter\n',
    );
    final Directory nested = Directory('${root.path}/lib/components/ui')
      ..createSync(recursive: true);
    final FlutterProject project = discoverFlutterProject(start: nested);
    expect(project.root.path, root.absolute.path);
    expect(project.isFlutterProject, isTrue);
  });

  test('rejects a non-Flutter pubspec', () {
    final Directory root = Directory.systemTemp.createTempSync(
      'elattar-nonflutter-',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    File(
      '${root.path}/pubspec.yaml',
    ).writeAsStringSync('name: dart_only\ndependencies: {}\n');
    expect(
      () => discoverFlutterProject(start: root),
      throwsA(isA<FlutterProjectNotFound>()),
    );
  });

  test('parses source config by default and writes deterministic YAML', () {
    final ElattarConfig config = ElattarConfig.fromYaml(
      'schema: $configSchemaUri\nregistry: local\n',
    );
    expect(config.foundation, FoundationMode.source);
    expect(config.componentsPath, 'lib/components/ui');
    expect(config.foundationPath, 'lib/design_system/foundation');
    expect(config.toYaml(), contains('foundation: source'));
  });

  test(
    'package config requires package identity and supports alternative mode',
    () {
      expect(
        () => ElattarConfig.fromYaml(
          'schema: $configSchemaUri\nfoundation: package\n',
        ),
        throwsA(isA<ElattarConfigException>()),
      );
      final ElattarConfig config = ElattarConfig.fromYaml(
        'schema: $configSchemaUri\nfoundation: package\npackage:\n  name: elattar_core\n  version: ^0.0.1\n',
      );
      expect(config.foundation, FoundationMode.package);
      expect(config.packageName, 'elattar_core');
    },
  );

  test('manifest round trips and protects mode/schema mismatches', () {
    final ElattarManifest manifest = ElattarManifest(
      foundation: FoundationMode.source,
      registry: 'local',
      items: const <InstalledItem>[],
    );
    final Directory root = Directory.systemTemp.createTempSync(
      'elattar-manifest-',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    final File file = File('${root.path}/.elattar/manifest.json');
    manifest.write(file);
    final ElattarManifest loaded = ElattarManifest.load(file);
    expect(loaded.foundation, FoundationMode.source);
    expect(loaded.schemaVersion, 1);
    expect(
      () => ElattarConfig(
        foundation: FoundationMode.package,
      ).validateAgainst(loaded),
      throwsA(isA<ElattarConfigException>()),
    );
    expect(
      () => ElattarManifest.fromJsonString('{"schemaVersion":2}'),
      throwsA(isA<ElattarManifestException>()),
    );
  });
}
