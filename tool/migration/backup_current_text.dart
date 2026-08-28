import 'dart:io';

/// Creates a recoverable workspace-local backup before replaying a mechanical
/// migration. The backup lives under `.dart_tool/` and is never committed.
void main() {
  final Directory root = Directory.current.absolute;
  final Directory backup = Directory(
    '${root.path}${Platform.pathSeparator}.dart_tool${Platform.pathSeparator}migration_backup_before_lexical_replay',
  );
  if (backup.existsSync()) {
    throw StateError('Backup already exists: ${backup.path}');
  }
  var copied = 0;
  for (final File source
      in root.listSync(recursive: true, followLinks: false).whereType<File>()) {
    final String relative = source.path
        .replaceAll('\\', '/')
        .replaceFirst('${root.path.replaceAll('\\', '/')}/', '');
    if (relative.startsWith('.git/') ||
        relative.startsWith('.dart_tool/') ||
        relative.startsWith('build/') ||
        relative.startsWith('tool/verify/out/')) {
      continue;
    }
    if (!const <String>{
      '.dart',
      '.json',
      '.md',
      '.yaml',
      '.yml',
    }.any(relative.endsWith)) {
      continue;
    }
    final File target = File(
      '${backup.path}${Platform.pathSeparator}${relative.replaceAll('/', Platform.pathSeparator)}',
    );
    target.parent.createSync(recursive: true);
    source.copySync(target.path);
    copied++;
  }
  stdout.writeln('backed up $copied text files to ${backup.path}');
}
