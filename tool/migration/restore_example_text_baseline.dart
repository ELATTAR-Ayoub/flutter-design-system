import 'dart:convert';
import 'dart:io';

void main() {
  final Directory root = Directory.current.absolute;
  final ProcessResult listed = Process.runSync(
    'git',
    const <String>['ls-files', 'example/lib', 'example/test'],
    workingDirectory: root.path,
    stdoutEncoding: utf8,
  );
  if (listed.exitCode != 0) throw StateError('${listed.stderr}');
  var restored = 0;
  for (final String path in '${listed.stdout}'.split(RegExp(r'\r?\n'))) {
    if (path.isEmpty || !path.endsWith('.dart')) continue;
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
  stdout.writeln('restored $restored tracked example Dart files');
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
