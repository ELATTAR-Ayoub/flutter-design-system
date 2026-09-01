// Records the exact bytes a released registry version published.
//
// A released version is immutable (see `tool/README.md`). `stage.dart` enforces
// that at the moment of publication, by refusing to overwrite a published
// version with different bytes — but it can only refuse once someone runs a
// deploy. This tool writes the same fact down where a test can read it, so a
// regeneration that would change a released payload fails in the test suite
// instead of at the release gate.
//
//   dart run tool/registry_builder/bin/snapshot_released.dart 0.0.1
//
// Writes `registry/released/<version>.lock.json`: every payload path under
// `versions/<item>/<version>/` that the generated tree currently holds, with
// its sha256. Run it ONCE per release, from a tree whose generated registry is
// verified identical to that release's tag. Re-running it against a changed
// tree would launder exactly the change the lock exists to catch, so it refuses
// to overwrite an existing lock unless `--force` is passed.

import 'dart:convert';
import 'dart:io';

import '../lib/generator.dart' show sha256Hex;

void main(List<String> args) {
  final List<String> positional = args
      .where((String a) => !a.startsWith('-'))
      .toList();
  if (positional.length != 1) {
    stderr.writeln('Usage: snapshot_released.dart <version> [--force]');
    exit(64);
  }
  final String version = positional.single;
  final bool force = args.contains('--force');

  final Directory versions = Directory('registry/generated/latest/versions');
  if (!versions.existsSync()) {
    stderr.writeln('No generated registry at ${versions.path}.');
    exit(1);
  }

  final File lock = File('registry/released/$version.lock.json');
  if (lock.existsSync() && !force) {
    stderr.writeln(
      'A lock for $version already exists at ${lock.path}.\n'
      'A released version is recorded once. Re-recording it from a changed '
      'tree would launder the change this file exists to catch.\n'
      'Pass --force only when you are correcting the record itself.',
    );
    exit(1);
  }

  final Map<String, String> payloads = <String, String>{};
  for (final Directory item in versions.listSync().whereType<Directory>()) {
    final Directory tree = Directory('${item.path}/$version');
    if (!tree.existsSync()) continue;
    for (final File file in tree.listSync(recursive: true).whereType<File>()) {
      final String key = file.path
          .replaceAll(r'\', '/')
          .split('registry/generated/latest/')
          .last;
      payloads[key] = sha256Hex(file.readAsBytesSync());
    }
  }

  if (payloads.isEmpty) {
    stderr.writeln('No payloads found for version $version.');
    exit(1);
  }

  final List<String> keys = payloads.keys.toList()..sort();
  lock.parent.createSync(recursive: true);
  lock.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{
      'version': version,
      'payloadCount': keys.length,
      'payloads': <String, String>{for (final String key in keys) key: payloads[key]!},
    })}\n',
  );
  stdout.writeln(
    'Recorded ${keys.length} payloads for $version at ${lock.path}.',
  );
}
