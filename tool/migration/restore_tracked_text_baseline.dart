import 'dart:convert';
import 'dart:io';

/// Restores tracked text outside `lib/src/` to HEAD so the API migration can
/// be replayed deterministically. The layout migration restores moved lib
/// sources separately. Untracked user files are never inspected or changed.
void main() {
  final Directory root = Directory.current.absolute;
  final ProcessResult listed = Process.runSync(
    'git',
    const <String>['ls-files'],
    workingDirectory: root.path,
    stdoutEncoding: utf8,
  );
  if (listed.exitCode != 0) throw StateError('${listed.stderr}');
  var restored = 0;
  for (final String path
      in '${listed.stdout}'
          .split(RegExp(r'\r?\n'))
          .where((path) => path.isNotEmpty)) {
    if (path.startsWith('lib/src/') ||
        path.startsWith('docs/superpowers/') ||
        path.startsWith('tool/migration/') ||
        path.startsWith('tool/verify/out/')) {
      continue;
    }
    if (!const <String>{
      '.dart',
      '.json',
      '.md',
      '.yaml',
      '.yml',
    }.any(path.endsWith)) {
      continue;
    }
    final ProcessResult shown = Process.runSync(
      'git',
      <String>['show', 'HEAD:$path'],
      workingDirectory: root.path,
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );
    if (shown.exitCode != 0) throw StateError('Cannot restore $path');
    final File target = File(
      '${root.path}${Platform.pathSeparator}${path.replaceAll('/', Platform.pathSeparator)}',
    );
    _writeWithRetry(target, '${shown.stdout}');
    restored++;
  }
  stdout.writeln('restored $restored tracked text files outside lib/src');
}

void _writeWithRetry(File file, String content) {
  Object? lastError;
  for (var attempt = 0; attempt < 12; attempt++) {
    try {
      file.writeAsStringSync(content);
      return;
    } on FileSystemException catch (error) {
      lastError = error;
      sleep(Duration(milliseconds: 25 * (attempt + 1)));
    }
  }
  throw StateError('Cannot write ${file.path}: $lastError');
}
