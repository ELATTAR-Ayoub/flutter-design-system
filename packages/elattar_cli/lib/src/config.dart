library;

import 'package:yaml/yaml.dart';

import 'identity.dart';
import 'manifest.dart';

class ElattarConfigException implements Exception {
  const ElattarConfigException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ElattarConfig {
  const ElattarConfig({
    this.schema = configSchemaUri,
    this.registry = 'https://elattar.dev/registry',
    this.foundation = FoundationMode.source,
    this.style = 'default',
    this.foundationPath = 'lib/design_system/foundation',
    this.themePath = 'lib/design_system',
    this.componentsPath = 'lib/components/ui',
    this.effectsPath = 'lib/design_system/effects',
    this.motionPath = 'lib/design_system/motion',
    this.designSystemBarrel = 'lib/design_system/design_system.dart',
    this.componentsBarrel = 'lib/components/ui/ui.dart',
    this.packageName,
    this.packageVersion,
  });

  final String schema;
  final String registry;
  final FoundationMode foundation;
  final String style;
  final String foundationPath;
  final String themePath;
  final String componentsPath;
  final String effectsPath;
  final String motionPath;
  final String designSystemBarrel;
  final String componentsBarrel;
  final String? packageName;
  final String? packageVersion;

  factory ElattarConfig.fromYaml(String source) {
    final Object value = loadYaml(source);
    if (value is! YamlMap) {
      throw const ElattarConfigException(
        'elattar.yaml must contain a YAML object.',
      );
    }
    final String schema = _string(value['schema'], configSchemaUri);
    if (schema != configSchemaUri) {
      throw ElattarConfigException('Unsupported config schema: $schema');
    }
    final String mode = _string(value['foundation'], 'source');
    final FoundationMode foundation = switch (mode) {
      'source' => FoundationMode.source,
      'package' => FoundationMode.package,
      _ => throw ElattarConfigException(
        'foundation must be source or package.',
      ),
    };
    final YamlMap paths = value['paths'] is YamlMap
        ? value['paths'] as YamlMap
        : YamlMap();
    final YamlMap barrels = value['barrels'] is YamlMap
        ? value['barrels'] as YamlMap
        : YamlMap();
    final YamlMap package = value['package'] is YamlMap
        ? value['package'] as YamlMap
        : YamlMap();
    final ElattarConfig config = ElattarConfig(
      schema: schema,
      registry: _string(value['registry'], 'https://elattar.dev/registry'),
      foundation: foundation,
      style: _string(value['style'], 'default'),
      foundationPath: _string(
        paths['foundation'],
        'lib/design_system/foundation',
      ),
      themePath: _string(paths['theme'], 'lib/design_system'),
      componentsPath: _string(paths['components'], 'lib/components/ui'),
      effectsPath: _string(paths['effects'], 'lib/design_system/effects'),
      motionPath: _string(paths['motion'], 'lib/design_system/motion'),
      designSystemBarrel: _string(
        barrels['design_system'],
        'lib/design_system/design_system.dart',
      ),
      componentsBarrel: _string(
        barrels['components'],
        'lib/components/ui/ui.dart',
      ),
      packageName: package['name'] as String?,
      packageVersion: package['version'] as String?,
    );
    config.validate();
    return config;
  }

  void validate() {
    if (foundation == FoundationMode.package &&
        (packageName == null || packageVersion == null)) {
      throw const ElattarConfigException(
        'Package foundation mode requires package.name and package.version.',
      );
    }
  }

  void validateAgainst(ElattarManifest manifest) {
    if (manifest.schemaVersion != supportedConfigSchemaVersion) {
      throw ElattarConfigException(
        'Unsupported manifest schema version: ${manifest.schemaVersion}',
      );
    }
    if (manifest.foundation != foundation) {
      throw ElattarConfigException(
        'Configured foundation mode ${foundation.name} does not match installed mode ${manifest.foundation.name}. Run foundation migration first.',
      );
    }
  }

  String toYaml() {
    final StringBuffer out = StringBuffer()
      ..writeln('schema: $schema')
      ..writeln('registry: $registry')
      ..writeln('foundation: ${foundation.name}')
      ..writeln('style: $style')
      ..writeln()
      ..writeln('paths:')
      ..writeln('  foundation: $foundationPath')
      ..writeln('  theme: $themePath')
      ..writeln('  components: $componentsPath')
      ..writeln('  effects: $effectsPath')
      ..writeln('  motion: $motionPath')
      ..writeln()
      ..writeln('barrels:')
      ..writeln('  design_system: $designSystemBarrel')
      ..writeln('  components: $componentsBarrel');
    if (foundation == FoundationMode.package) {
      out
        ..writeln()
        ..writeln('package:')
        ..writeln('  name: $packageName')
        ..writeln('  version: $packageVersion');
    }
    return '$out';
  }
}

String _string(Object? value, String fallback) =>
    value is String && value.trim().isNotEmpty ? value : fallback;
