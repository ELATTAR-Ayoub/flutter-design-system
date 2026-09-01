// Recomputes the sha256 every authored registry manifest pins for its sources.
//
// The pins exist so a generation cannot silently distribute bytes nobody
// reviewed: `build.dart` refuses to run when a hash and a file disagree. That
// makes them deliberately annoying after an intentional edit, which is what
// this tool is for — and why it does nothing without `--apply`, prints every
// pin it moves, and never touches `registry/generated/`.
//
//   dart run tool/registry_builder/bin/reseal.dart --dry-run
//   dart run tool/registry_builder/bin/reseal.dart --apply
//
// Run it only when the source change was intended. Reading the printed list is
// the review step; a file in it that you did not mean to change is the finding.

import 'dart:convert';
import 'dart:io';

import '../lib/generator.dart' show sha256Hex;

/// The manifest directories, and the keyed lists inside each manifest whose
/// entries carry a `source` and a `sha256`.
const List<String> _manifestDirs = <String>[
  'registry/components',
  'registry/blocks',
  'registry/foundations',
];

const List<String> _hashedLists = <String>[
  'files',
  'assets',
  'fonts',
  'shaders',
  'licenses',
];

void main(List<String> args) {
  final bool apply = args.contains('--apply');
  if (!apply && !args.contains('--dry-run')) {
    stderr.writeln('Pass --dry-run or --apply.');
    exit(64);
  }

  int manifests = 0;
  int moved = 0;
  int missing = 0;

  for (final String dir in _manifestDirs) {
    final Directory directory = Directory(dir);
    if (!directory.existsSync()) continue;
    final List<File> files =
        directory
            .listSync()
            .whereType<File>()
            .where((File f) => f.path.endsWith('.json'))
            .toList()
          ..sort((File a, File b) => a.path.compareTo(b.path));

    for (final File manifest in files) {
      final String before = manifest.readAsStringSync();
      final Map<String, dynamic> json =
          jsonDecode(before) as Map<String, dynamic>;
      bool changed = false;

      for (final String key in _hashedLists) {
        final Object? list = json[key];
        if (list is! List) continue;
        for (final Object? entry in list) {
          if (entry is! Map) continue;
          final Object? source = entry['source'];
          final Object? pinned = entry['sha256'];
          if (source is! String || pinned is! String) continue;

          final File file = File(source);
          if (!file.existsSync()) {
            stdout.writeln('MISSING ${manifest.path}: $source');
            missing++;
            continue;
          }
          final String actual = sha256Hex(file.readAsBytesSync());
          if (actual == pinned) continue;
          stdout.writeln(
            '${apply ? 'resealed' : 'would reseal'} $source\n'
            '    ${manifest.path}\n'
            '    $pinned -> $actual',
          );
          entry['sha256'] = actual;
          changed = true;
          moved++;
        }
      }

      if (!changed) continue;
      manifests++;
      if (apply) {
        // Two-space indent and a trailing newline: the shape every manifest in
        // the tree already has, so a reseal is a hash diff and nothing else.
        manifest.writeAsStringSync(
          '${const JsonEncoder.withIndent('  ').convert(json)}\n',
        );
      }
    }
  }

  stdout.writeln('\n$moved pins in $manifests manifests');
  if (missing > 0) {
    stdout.writeln('$missing declared sources are missing — fix those by hand');
    exit(1);
  }
}
