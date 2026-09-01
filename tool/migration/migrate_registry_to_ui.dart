import 'dart:convert';
import 'dart:io';

// This migration runs from the repository root beside the nested registry
// builder package; a package import cannot address that sibling package.
// ignore: avoid_relative_lib_imports
import '../registry_builder/lib/generator.dart' show sha256Hex;

const Map<String, String> itemNames = <String, String>{
  'feedback-surface': 'feedback-surface',
  'premium-surface': 'premium-surface',
  'glass': 'glass',
  'surface': 'surface',
  'media-scrim': 'media-scrim',
  'background-effect': 'background-effect',
  'action-feedback': 'action-feedback',
  'starfield': 'ambient-pattern',
  'voice-indicator': 'voice-indicator',
  'keyframes': 'keyframes',
  'lift': 'hover-builder',
  'press': 'press',
  'active-indicator': 'active-indicator',
  'content-change': 'content-change',
  'user-menu': 'user-menu',
  'rule': 'validation-rule',
};

final JsonEncoder encoder = JsonEncoder.withIndent('  ');

void main() {
  final componentDir = Directory('registry/components');
  final sourceDirs = <Directory>[
    Directory('registry/effects'),
    Directory('registry/motion'),
  ];

  final moved = <String, Map<String, Object?>>{};
  for (final directory in sourceDirs) {
    if (!directory.existsSync()) continue;
    for (final file in directory.listSync().whereType<File>()) {
      final json = _read(file);
      final oldName = json['name']! as String;
      final newName = itemNames[oldName];
      if (newName == null) throw StateError('No UI item mapping for $oldName');
      json['name'] = newName;
      json['type'] = 'component';
      json['documentationRoute'] = '/components/$newName';
      final files = (json['files']! as List<Object?>)
          .cast<Map<String, Object?>>();
      for (final entry in files) {
        final source = entry['source']! as String;
        if (source.endsWith('.dart')) {
          entry['target'] =
              '@ui/${source.replaceAll('\\', '/').split('/').last}';
        }
      }
      json['exports'] = _publicDeclarations(files.first['source']! as String);
      moved[newName] = json;
    }
  }

  final allManifestFiles = <File>[
    ...componentDir.listSync().whereType<File>(),
    ...Directory('registry/blocks').listSync().whereType<File>(),
    File('registry/foundations/source.json'),
  ];
  final manifests = <Map<String, Object?>>[
    for (final file in allManifestFiles) _read(file),
    ...moved.values,
  ];
  for (final json in manifests) {
    for (final key in <String>[
      'registryDependencies',
      'semanticDependencies',
    ]) {
      final values = json[key];
      if (values is List<Object?>) {
        json[key] = <String>[
          for (final value in values.cast<String>()) itemNames[value] ?? value,
        ];
      }
    }
    final manifestFiles = (json['files']! as List<Object?>)
        .cast<Map<String, Object?>>();
    if (json['exports'] is! List<Object?> ||
        (json['exports']! as List<Object?>).isEmpty) {
      final exports = <String>{};
      for (final entry in manifestFiles) {
        final source = entry['source']! as String;
        if (source.endsWith('.dart')) {
          exports.addAll(_publicDeclarations(source));
        }
      }
      json['exports'] = exports.toList()..sort();
    }
    _refreshHashes(json);
  }

  for (final json in manifests) {
    final name = json['name']! as String;
    final destination = name == 'source-foundation'
        ? File('registry/foundations/source.json')
        : json['type'] == 'block'
        ? File('registry/blocks/$name.json')
        : File('registry/components/$name.json');
    destination.writeAsStringSync('${encoder.convert(json)}\n');
  }

  for (final directory in sourceDirs) {
    if (!directory.existsSync()) continue;
    for (final file in directory.listSync().whereType<File>()) {
      file.deleteSync();
    }
    directory.deleteSync();
  }

  _updateInventory(moved);
  stdout.writeln('Migrated ${moved.length} effect/motion items to UI.');
}

Map<String, Object?> _read(File file) =>
    (jsonDecode(file.readAsStringSync()) as Map).cast<String, Object?>();

List<String> _publicDeclarations(String sourcePath) {
  final source = File(sourcePath).readAsStringSync();
  final names = <String>{};
  final declaration = RegExp(
    r'^(?:abstract\s+|base\s+|final\s+|sealed\s+)?(?:class|enum|mixin|typedef|extension(?:\s+type)?)\s+([A-Z][A-Za-z0-9_]*)',
    multiLine: true,
  );
  for (final match in declaration.allMatches(source)) {
    final name = match.group(1)!;
    if (!name.startsWith('_')) names.add(name);
  }
  return names.toList()..sort();
}

void _refreshHashes(Map<String, Object?> json) {
  for (final key in <String>[
    'files',
    'assets',
    'fonts',
    'shaders',
    'licenses',
  ]) {
    final entries = json[key];
    if (entries is! List<Object?>) continue;
    for (final entry in entries.cast<Map<String, Object?>>()) {
      final file = File(entry['source']! as String);
      if (file.existsSync()) {
        entry['sha256'] = sha256Hex(file.readAsBytesSync());
      }
    }
  }
}

void _updateInventory(Map<String, Map<String, Object?>> moved) {
  final file = File('registry/component_inventory.json');
  final inventory = _read(file);
  final components = (inventory['components']! as List<Object?>)
      .cast<Map<String, Object?>>();
  final seen = <String>{for (final row in components) row['source']! as String};
  final owners = (inventory['installableOwners']! as List<Object?>)
      .cast<String>();
  for (final entry in moved.entries) {
    final source =
        ((entry.value['files']! as List<Object?>).first
                as Map<String, Object?>)['source']!
            as String;
    if (seen.add(source)) {
      components.add(<String, Object?>{
        'source': source,
        'owner': entry.key,
        'classification': 'installable',
      });
    }
    if (!owners.contains(entry.key)) owners.add(entry.key);
  }
  components.sort(
    (a, b) => (a['source']! as String).compareTo(b['source']! as String),
  );
  owners.sort();
  inventory['components'] = components;
  inventory['installableOwners'] = owners;
  file.writeAsStringSync('${encoder.convert(inventory)}\n');
}
