import 'dart:io';

void main() {
  final Directory root = Directory.current;
  var changed = 0;
  for (final String relative in <String>[
    'test',
    'example/lib',
    'example/test',
  ]) {
    for (final FileSystemEntity entity in Directory(
      '${root.path}${Platform.pathSeparator}$relative',
    ).listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final String source = entity.readAsStringSync();
      final String updated = source
          .replaceAllMapped(
            RegExp(
              r"import\s+('package:elattar_design_system/[^']+')\s+as\s+UI([^;]*);",
            ),
            (Match match) => 'import ${match.group(1)}${match.group(2)};',
          )
          .replaceAll(RegExp(r'\bUI\s*\.'), '');
      if (updated == source) continue;
      entity.writeAsStringSync(updated);
      changed++;
    }
  }
  stdout.writeln('normalized direct imports in $changed internal test files');
}
