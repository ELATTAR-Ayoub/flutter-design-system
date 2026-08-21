/// Schema and cross-item validation for registry v1.
library;

import 'registry_schema.dart';

const Set<String> logicalTargetPrefixes = <String>{
  '@ui/',
  '@foundation/',
  '@effects/',
  '@motion/',
};

final RegExp _sha256 = RegExp(r'^[0-9a-fA-F]{64}$');
final RegExp _name = RegExp(r'^[a-z][a-z0-9]*(?:-[a-z0-9]+)*$');
final RegExp _version = RegExp(r'^\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?$');

class RegistryValidationResult {
  const RegistryValidationResult(this.errors);

  final List<String> errors;
  bool get isValid => errors.isEmpty;
}

RegistryValidationResult validateRegistry(RegistryDocument document) {
  final List<String> errors = <String>[];
  if (document.schemaVersion != 1) {
    errors.add(
      r'$.schemaVersion must be 1; received ' +
          document.schemaVersion.toString() +
          '.',
    );
  }
  if (!_version.hasMatch(document.registryVersion)) {
    errors.add(
      r'$.registryVersion is not a semantic version: ' +
          document.registryVersion +
          '.',
    );
  }

  final Map<String, RegistryItem> byName = <String, RegistryItem>{};
  final Map<String, String> targetOwners = <String, String>{};
  for (int i = 0; i < document.items.length; i++) {
    final RegistryItem item = document.items[i];
    final String path = r'$.items[' + i.toString() + ']';
    if (!_name.hasMatch(item.name)) {
      errors.add('$path.name is not a kebab-case registry name: ${item.name}.');
    }
    if (!_version.hasMatch(item.version)) {
      errors.add('$path.version is not a semantic version: ${item.version}.');
    }
    if (byName.containsKey(item.name)) {
      errors.add('$path.name duplicates ${item.name}.');
    } else {
      byName[item.name] = item;
    }
    _validateItem(item, path, errors, targetOwners);
  }

  for (final RegistryItem item in document.items) {
    for (final String dependency in item.registryDependencies) {
      if (!byName.containsKey(dependency)) {
        errors.add(
          '${item.name}.registryDependencies references missing item $dependency.',
        );
      }
      if (dependency == item.name) {
        errors.add('${item.name} cannot depend on itself.');
      }
    }
    for (final String dependency in item.semanticDependencies) {
      if (!item.registryDependencies.contains(dependency)) {
        errors.add(
          '${item.name}.semanticDependencies must be declared in registryDependencies: $dependency.',
        );
      }
    }
    if (item.deprecated && item.replacement == null) {
      errors.add('${item.name} is deprecated but has no replacement.');
    }
  }

  _validateCycles(byName, errors);
  return RegistryValidationResult(List<String>.unmodifiable(errors));
}

void _validateItem(
  RegistryItem item,
  String path,
  List<String> errors,
  Map<String, String> targetOwners,
) {
  if (item.files.isEmpty &&
      item.assets.isEmpty &&
      item.fonts.isEmpty &&
      item.shaders.isEmpty) {
    errors.add(
      '$path must declare at least one distributable file or resource.',
    );
  }
  for (int i = 0; i < item.files.length; i++) {
    final RegistryFile file = item.files[i];
    _validateSource(file.source, '$path.files[$i].source', errors);
    _validateTarget(
      file.target,
      '$path.files[$i].target',
      errors,
      targetOwners,
      item.name,
    );
    _validateHash(file.sha256, '$path.files[$i].sha256', errors);
  }
  for (final MapEntry<String, List<RegistryResource>> group
      in <MapEntry<String, List<RegistryResource>>>[
        MapEntry<String, List<RegistryResource>>('assets', item.assets),
        MapEntry<String, List<RegistryResource>>('fonts', item.fonts),
        MapEntry<String, List<RegistryResource>>('shaders', item.shaders),
      ]) {
    final String label = group.key;
    final List<RegistryResource> resources = group.value;
    for (int i = 0; i < resources.length; i++) {
      final RegistryResource resource = resources[i];
      _validateSource(resource.source, '$path.$label[$i].source', errors);
      _validateTarget(
        resource.target,
        '$path.$label[$i].target',
        errors,
        targetOwners,
        item.name,
      );
      _validateHash(resource.sha256, '$path.$label[$i].sha256', errors);
    }
  }
  if (!item.documentationRoute.startsWith('/')) {
    errors.add('$path.documentationRoute must be an absolute site route.');
  }
  if (!item.sourceLink.startsWith('https://')) {
    errors.add('$path.sourceLink must be an https URL.');
  }
}

void _validateSource(String source, String path, List<String> errors) {
  if (source.startsWith('/') ||
      source.contains('..') ||
      source.contains('\\')) {
    errors.add('$path must be a safe repository-relative path.');
  }
}

void _validateTarget(
  String target,
  String path,
  List<String> errors,
  Map<String, String> targetOwners,
  String item,
) {
  if (!logicalTargetPrefixes.any(target.startsWith) ||
      target.contains('..') ||
      target.endsWith('/')) {
    errors.add(
      '$path must use a known logical target prefix and safe relative path.',
    );
  }
  final String? owner = targetOwners[target];
  if (owner != null)
    errors.add('$path duplicates target $target already owned by $owner.');
  targetOwners[target] = item;
}

void _validateHash(String hash, String path, List<String> errors) {
  if (!_sha256.hasMatch(hash))
    errors.add('$path must be a 64-character SHA-256 hex digest.');
}

void _validateCycles(Map<String, RegistryItem> items, List<String> errors) {
  final Set<String> visiting = <String>{};
  final Set<String> visited = <String>{};
  void visit(String name, List<String> chain) {
    if (visiting.contains(name)) {
      errors.add(
        'Registry dependency cycle: ${<String>[...chain, name].join(' -> ')}.',
      );
      return;
    }
    if (!visited.add(name)) return;
    visiting.add(name);
    for (final String dependency
        in items[name]?.registryDependencies ?? const <String>[]) {
      if (items.containsKey(dependency))
        visit(dependency, <String>[...chain, name]);
    }
    visiting.remove(name);
  }

  for (final String name in items.keys) visit(name, const <String>[]);
}
