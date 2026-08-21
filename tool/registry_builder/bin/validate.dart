import 'dart:io';

import '../lib/registry_schema.dart';
import '../lib/registry_validator.dart';

void main(List<String> arguments) {
  final String path = arguments.isEmpty
      ? 'registry/registry.json'
      : arguments.single;
  try {
    final RegistryDocument document = RegistryDocument.fromJsonString(
      File(path).readAsStringSync(),
    );
    final RegistryValidationResult result = validateRegistry(document);
    if (result.isValid) {
      stdout.writeln(
        'Registry valid: ${document.items.length} item(s), schema v${document.schemaVersion}.',
      );
      return;
    }
    for (final String error in result.errors) stderr.writeln('error: $error');
    exitCode = 1;
  } on Object catch (error) {
    stderr.writeln('error: $error');
    exitCode = 1;
  }
}
