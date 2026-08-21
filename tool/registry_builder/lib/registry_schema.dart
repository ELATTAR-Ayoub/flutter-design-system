/// Version-one registry schema models and JSON parser.
library;

import 'dart:convert';

enum RegistryItemType {
  foundation,
  component,
  effect,
  motion,
  asset,
  block,
  preset,
}

RegistryItemType _itemType(String value) {
  for (final RegistryItemType type in RegistryItemType.values) {
    if (type.name == value) return type;
  }
  throw FormatException('Unknown registry item type "$value".');
}

class RegistryFile {
  const RegistryFile({
    required this.source,
    required this.target,
    required this.sha256,
  });

  final String source;
  final String target;
  final String sha256;

  factory RegistryFile.fromJson(Object? value, String path) {
    final Map<String, Object?> json = _map(value, path);
    return RegistryFile(
      source: _string(json, 'source', path),
      target: _string(json, 'target', path),
      sha256: _string(json, 'sha256', path),
    );
  }
}

class RegistryResource {
  const RegistryResource({
    required this.source,
    required this.target,
    required this.sha256,
  });

  final String source;
  final String target;
  final String sha256;

  factory RegistryResource.fromJson(Object? value, String path) {
    final Map<String, Object?> json = _map(value, path);
    return RegistryResource(
      source: _string(json, 'source', path),
      target: _string(json, 'target', path),
      sha256: _string(json, 'sha256', path),
    );
  }
}

class RegistryItem {
  const RegistryItem({
    required this.name,
    required this.type,
    required this.version,
    required this.description,
    required this.minDart,
    required this.minFlutter,
    required this.files,
    required this.registryDependencies,
    required this.semanticDependencies,
    required this.pubDependencies,
    required this.assets,
    required this.fonts,
    required this.shaders,
    required this.documentationRoute,
    required this.sourceLink,
    this.deprecated = false,
    this.replacement,
  });

  final String name;
  final RegistryItemType type;
  final String version;
  final String description;
  final String minDart;
  final String minFlutter;
  final List<RegistryFile> files;
  final List<String> registryDependencies;
  final List<String> semanticDependencies;
  final Map<String, String> pubDependencies;
  final List<RegistryResource> assets;
  final List<RegistryResource> fonts;
  final List<RegistryResource> shaders;
  final String documentationRoute;
  final String sourceLink;
  final bool deprecated;
  final String? replacement;

  factory RegistryItem.fromJson(Object? value, String path) {
    final Map<String, Object?> json = _map(value, path);
    final List<String> registryDependencies = _strings(
      json,
      'registryDependencies',
      path,
    );
    final List<String> semanticDependencies =
        json.containsKey('semanticDependencies')
        ? _strings(json, 'semanticDependencies', path)
        : registryDependencies;
    return RegistryItem(
      name: _string(json, 'name', path),
      type: _itemType(_string(json, 'type', path)),
      version: _string(json, 'version', path),
      description: _string(json, 'description', path),
      minDart: _string(json, 'minDart', path),
      minFlutter: _string(json, 'minFlutter', path),
      files: _resources(json, 'files', path, RegistryFile.fromJson),
      registryDependencies: registryDependencies,
      semanticDependencies: semanticDependencies,
      pubDependencies: _stringMap(json, 'pubDependencies', path),
      assets: _resources(json, 'assets', path, RegistryResource.fromJson),
      fonts: _resources(json, 'fonts', path, RegistryResource.fromJson),
      shaders: _resources(json, 'shaders', path, RegistryResource.fromJson),
      documentationRoute: _string(json, 'documentationRoute', path),
      sourceLink: _string(json, 'sourceLink', path),
      deprecated: json['deprecated'] as bool? ?? false,
      replacement: json['replacement'] as String?,
    );
  }
}

class RegistryDocument {
  const RegistryDocument({
    required this.schemaVersion,
    required this.registryVersion,
    required this.items,
  });

  final int schemaVersion;
  final String registryVersion;
  final List<RegistryItem> items;

  factory RegistryDocument.fromJson(Object? value) {
    final Map<String, Object?> json = _map(value, r'$');
    final Object? schema = json['schemaVersion'];
    if (schema is! int) {
      throw const FormatException(r'$.schemaVersion must be an integer.');
    }
    final Object? rawItems = json['items'];
    if (rawItems is! List<Object?>) {
      throw const FormatException(r'$.items must be an array.');
    }
    return RegistryDocument(
      schemaVersion: schema,
      registryVersion: _string(json, 'registryVersion', r'$'),
      items: <RegistryItem>[
        for (int i = 0; i < rawItems.length; i++)
          RegistryItem.fromJson(rawItems[i], r'$.items[' + i.toString() + ']'),
      ],
    );
  }

  factory RegistryDocument.fromJsonString(String source) {
    try {
      return RegistryDocument.fromJson(jsonDecode(source));
    } on FormatException {
      rethrow;
    } on Object catch (error) {
      throw FormatException('Registry JSON is invalid: $error');
    }
  }
}

typedef _ResourceParser<T> = T Function(Object? value, String path);

Map<String, Object?> _map(Object? value, String path) {
  if (value is Map<String, Object?>) return value;
  throw FormatException('$path must be an object.');
}

String _string(Map<String, Object?> json, String key, String path) {
  final Object? value = json[key];
  if (value is String && value.trim().isNotEmpty) return value;
  throw FormatException('$path.$key must be a non-empty string.');
}

List<String> _strings(Map<String, Object?> json, String key, String path) {
  final Object? value = json[key];
  if (value is! List<Object?>) {
    throw FormatException('$path.$key must be an array of strings.');
  }
  return <String>[
    for (int i = 0; i < value.length; i++)
      _string(<String, Object?>{'value': value[i]}, 'value', '$path.$key[$i]'),
  ];
}

Map<String, String> _stringMap(
  Map<String, Object?> json,
  String key,
  String path,
) {
  final Object? value = json[key];
  if (value is! Map<String, Object?>) {
    throw FormatException('$path.$key must be an object of string values.');
  }
  return <String, String>{
    for (final MapEntry<String, Object?> entry in value.entries)
      entry.key: _string(
        <String, Object?>{'value': entry.value},
        'value',
        '$path.$key.${entry.key}',
      ),
  };
}

List<T> _resources<T>(
  Map<String, Object?> json,
  String key,
  String path,
  _ResourceParser<T> parser,
) {
  final Object? value = json[key];
  if (value is! List<Object?>) {
    throw FormatException('$path.$key must be an array.');
  }
  return <T>[
    for (int i = 0; i < value.length; i++) parser(value[i], '$path.$key[$i]'),
  ];
}
