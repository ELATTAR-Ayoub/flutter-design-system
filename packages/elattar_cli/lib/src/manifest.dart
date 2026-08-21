library;

import 'dart:convert';
import 'dart:io';

import 'identity.dart';

class ElattarManifestException implements Exception {
  const ElattarManifestException(this.message);

  final String message;

  @override
  String toString() => message;
}

class InstalledFile {
  const InstalledFile({
    required this.target,
    required this.sourceHash,
    required this.installedHash,
  });

  final String target;
  final String sourceHash;
  final String installedHash;

  Map<String, String> toJson() => <String, String>{
    'target': target,
    'sourceHash': sourceHash,
    'installedHash': installedHash,
  };

  factory InstalledFile.fromJson(Map<String, Object?> json) => InstalledFile(
    target: _requiredString(json, 'target'),
    sourceHash: _requiredString(json, 'sourceHash'),
    installedHash: _requiredString(json, 'installedHash'),
  );
}

class InstalledItem {
  const InstalledItem({
    required this.name,
    required this.version,
    required this.files,
  });

  final String name;
  final String version;
  final List<InstalledFile> files;

  Map<String, Object?> toJson() => <String, Object?>{
    'name': name,
    'version': version,
    'files': <Object?>[for (final InstalledFile file in files) file.toJson()],
  };

  factory InstalledItem.fromJson(Map<String, Object?> json) => InstalledItem(
    name: _requiredString(json, 'name'),
    version: _requiredString(json, 'version'),
    files: <InstalledFile>[
      for (final Object? value in _list(json, 'files'))
        InstalledFile.fromJson(_map(value, 'files entry')),
    ],
  );
}

class ElattarManifest {
  const ElattarManifest({
    this.schemaVersion = supportedConfigSchemaVersion,
    required this.foundation,
    required this.registry,
    required this.items,
  });

  final int schemaVersion;
  final FoundationMode foundation;
  final String registry;
  final List<InstalledItem> items;

  factory ElattarManifest.fromJsonString(String source) {
    final Object? decoded = jsonDecode(source);
    final Map<String, Object?> json = _map(decoded, 'manifest');
    final Object? schema = json['schemaVersion'];
    if (schema is! int || schema != supportedConfigSchemaVersion) {
      throw ElattarManifestException(
        'Unsupported manifest schema version: $schema',
      );
    }
    final String mode = _requiredString(json, 'foundation');
    final FoundationMode foundation = switch (mode) {
      'source' => FoundationMode.source,
      'package' => FoundationMode.package,
      _ => throw ElattarManifestException('Unknown foundation mode: $mode'),
    };
    return ElattarManifest(
      schemaVersion: schema,
      foundation: foundation,
      registry: _requiredString(json, 'registry'),
      items: <InstalledItem>[
        for (final Object? value in _list(json, 'items'))
          InstalledItem.fromJson(_map(value, 'items entry')),
      ],
    );
  }

  String toJsonString() =>
      '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{
        'schemaVersion': schemaVersion,
        'foundation': foundation.name,
        'registry': registry,
        'items': <Object?>[for (final InstalledItem item in items) item.toJson()],
      })}\n';

  static ElattarManifest load(File file) =>
      ElattarManifest.fromJsonString(file.readAsStringSync());

  void write(File file) {
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(toJsonString());
  }
}

String _requiredString(Map<String, Object?> json, String key) {
  final Object? value = json[key];
  if (value is String && value.trim().isNotEmpty) return value;
  throw ElattarManifestException(
    'Manifest field $key must be a non-empty string.',
  );
}

List<Object?> _list(Map<String, Object?> json, String key) {
  final Object? value = json[key];
  if (value is List<Object?>) return value;
  throw ElattarManifestException('Manifest field $key must be an array.');
}

Map<String, Object?> _map(Object? value, String path) {
  if (value is Map<String, Object?>) return value;
  throw ElattarManifestException('$path must be an object.');
}
