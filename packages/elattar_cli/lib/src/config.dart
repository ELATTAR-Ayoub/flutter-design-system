library;

import 'package:yaml/yaml.dart';

import 'identity.dart';
import 'install/target_mapper.dart';
import 'manifest.dart';

class ElattarConfigException implements Exception {
  const ElattarConfigException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// `elattar.yaml` — a file teams commit.
///
/// Two properties follow from that:
///
///  * It carries no machine-local absolute paths. [registry] is written only
///    when the registry lives inside the project; otherwise the key is omitted
///    and `--registry` supplies it, which is honest rather than portable-
///    looking and broken on the next machine.
///  * It publishes no key that nothing reads. `paths:` and `barrels:` used to
///    be parsed, serialised, and then ignored by every install path; setting
///    `paths.components` changed nothing and produced no diagnostic. Both keys
///    are gone, install locations are the constants in `target_mapper.dart`,
///    and a file that still carries either key is rejected with a message
///    saying so.
class ElattarConfig {
  const ElattarConfig({
    this.schema = configSchemaUri,
    this.registry,
    this.foundation = FoundationMode.source,
    this.style = 'default',
    this.packageName,
    this.packageVersion,
  });

  final String schema;

  /// Where to read the registry from, or null when the project does not pin
  /// one and every command must be given `--registry` (or run somewhere a
  /// `registry/generated/latest` directory is discoverable above the working
  /// directory).
  ///
  /// Only ever a project-relative directory path. A URI is rejected: there is
  /// no HTTP fetcher, so a remote value can only fail, and it must fail with a
  /// sentence rather than a stack trace.
  final String? registry;

  final FoundationMode foundation;
  final String style;
  final String? packageName;
  final String? packageVersion;

  /// Install locations, fixed and reported for diagnostics only. They are the
  /// mapper's own constants, so they cannot drift from where files actually
  /// land.
  String get foundationPath => foundationDirectory;
  String get componentsPath => uiDirectory;
  String get effectsPath => effectsDirectory;
  String get motionPath => motionDirectory;
  String get fontsPath => fontsDirectory;

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
    for (final String removed in const <String>['paths', 'barrels']) {
      if (value.containsKey(removed)) {
        throw ElattarConfigException(
          'elattar.yaml no longer supports the `$removed:` key. Install '
          'locations are fixed (components land in $uiDirectory), and '
          '.elattar/manifest.json records what was installed where. Delete '
          'the `$removed:` block.',
        );
      }
    }
    final String mode = _string(value['foundation'], 'source');
    final FoundationMode foundation = switch (mode) {
      'source' => FoundationMode.source,
      'package' => FoundationMode.package,
      _ => throw ElattarConfigException(
        'foundation must be source or package.',
      ),
    };
    final YamlMap package = value['package'] is YamlMap
        ? value['package'] as YamlMap
        : YamlMap();
    final ElattarConfig config = ElattarConfig(
      schema: schema,
      registry: _optionalString(value['registry']),
      foundation: foundation,
      style: _string(value['style'], 'default'),
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
    final StringBuffer out = StringBuffer()..writeln('schema: $schema');
    if (registry case final String value) {
      out.writeln('registry: $value');
    }
    out
      ..writeln('foundation: ${foundation.name}')
      ..writeln('style: $style');
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

/// The value `elattar.yaml` records for `registry:`, or null when it must
/// record nothing.
///
/// `elattar.yaml` is committed. An absolute path — what `init` used to write —
/// resolves on exactly one machine and exits 64 everywhere else, so the only
/// value worth recording is one relative to the project itself. Anything else
/// (the usual case: a checkout of the design system elsewhere on the machine)
/// is omitted, and `--registry` must be supplied. That fails with an
/// instruction rather than pretending to be portable.
///
/// Both paths are compared POSIX-normalised so a Windows `\` separator and a
/// trailing separator do not change the answer.
String? projectRelativeRegistry(String projectRoot, String registryPath) {
  final String root = _posix(projectRoot);
  final String value = _posix(registryPath);
  if (value == root) return '.';
  if (!value.startsWith('$root/')) return null;
  return value.substring(root.length + 1);
}

String _posix(String value) =>
    value.replaceAll('\\', '/').replaceAll(RegExp(r'/+$'), '');

String _string(Object? value, String fallback) =>
    value is String && value.trim().isNotEmpty ? value : fallback;

String? _optionalString(Object? value) =>
    value is String && value.trim().isNotEmpty ? value.trim() : null;
