import 'dart:io';

import '../lib/generator.dart';

void main(List<String> arguments) {
  final Directory root = Directory(
    arguments.isEmpty ? Directory.current.path : arguments.first,
  );
  try {
    final GenerationSummary summary = RegistryGenerator(
      repositoryRoot: root,
    ).build();
    stdout.writeln(
      'Generated ${summary.document.items.length} item(s) at ${summary.outputRoot.path}.',
    );
  } on Object catch (error) {
    stderr.writeln('error: $error');
    exitCode = 1;
  }
}
