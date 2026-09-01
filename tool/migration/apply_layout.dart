import 'dart:convert';
import 'dart:io';

/// Hash-checked, one-shot repository layout migration.
///
/// Run `dart run tool/migration/apply_layout.dart --prepare`, review the
/// generated layout.json, then run again with `--apply`.
void main(List<String> arguments) {
  if (arguments.length != 1 ||
      !const <String>{
        '--prepare',
        '--apply',
        '--rewrite',
        '--restore-and-rewrite',
      }.contains(arguments.single)) {
    stderr.writeln(
      'usage: dart run tool/migration/apply_layout.dart '
      '--prepare|--apply|--rewrite|--restore-and-rewrite',
    );
    exitCode = 64;
    return;
  }

  final Directory root = _repositoryRoot();
  final File rulesFile = File(
    _join(root.path, 'tool/migration/layout_rules.json'),
  );
  final File manifestFile = File(
    _join(root.path, 'tool/migration/layout.json'),
  );
  final Map<String, Object?> rules =
      jsonDecode(rulesFile.readAsStringSync()) as Map<String, Object?>;

  if (arguments.single == '--prepare') {
    final List<_Move> moves = _expandRules(root, rules);
    final Map<String, String> hashes = _gitHeadHashes(
      root,
      moves.map((m) => m.from),
    );
    final Map<String, Object?> manifest = <String, Object?>{
      'schemaVersion': 1,
      'baseline': _git(root, const <String>[
        'rev-parse',
        '--short',
        'HEAD',
      ]).trim(),
      'moves': <Map<String, Object?>>[
        for (final _Move move in moves)
          <String, Object?>{
            'from': move.from,
            'to': move.to,
            'gitBlob': hashes[move.from],
          },
      ],
    };
    manifestFile.parent.createSync(recursive: true);
    manifestFile.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(manifest)}\n',
    );
    stdout.writeln('prepared ${moves.length} explicit moves');
    return;
  }

  final Map<String, Object?> manifest =
      jsonDecode(manifestFile.readAsStringSync()) as Map<String, Object?>;
  final List<_Move> moves = <_Move>[
    for (final Object? value in manifest['moves']! as List<Object?>)
      _Move.fromJson(value! as Map<String, Object?>),
  ];
  if (arguments.single == '--rewrite' ||
      arguments.single == '--restore-and-rewrite') {
    final List<_Move> baselineMoves = _expandRules(root, rules);
    if (arguments.single == '--restore-and-rewrite') {
      _restoreMovedSources(root, baselineMoves);
    }
    _rewriteDartImports(root, baselineMoves);
    _rewriteAuthoritativePathStrings(root, baselineMoves);
    stdout.writeln('rewrote imports and authoritative path strings');
    return;
  }
  _validate(root, moves);
  _move(root, moves);
  _rewriteDartImports(root, moves);
  _rewriteAuthoritativePathStrings(root, moves);
  stdout.writeln('applied ${moves.length} moves and rewrote imports');
}

void _restoreMovedSources(Directory root, List<_Move> moves) {
  for (final _Move move in moves) {
    final ProcessResult result = Process.runSync(
      'git',
      <String>['show', 'HEAD:${move.from}'],
      workingDirectory: root.path,
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );
    if (result.exitCode != 0) {
      throw StateError('Cannot restore ${move.from}: ${result.stderr}');
    }
    final File target = File(_join(root.path, move.to));
    target.parent.createSync(recursive: true);
    target.writeAsStringSync('${result.stdout}');
  }
}

Directory _repositoryRoot() {
  Directory current = Directory.current.absolute;
  while (!File(_join(current.path, 'pubspec.yaml')).existsSync()) {
    final Directory parent = current.parent;
    if (parent.path == current.path) {
      throw StateError('Run from the repository checkout.');
    }
    current = parent;
  }
  return current;
}

List<_Move> _expandRules(Directory root, Map<String, Object?> rules) {
  final Map<String, String> explicit = <String, String>{
    for (final MapEntry<String, Object?> entry
        in (rules['files']! as Map<String, Object?>).entries)
      _posix(entry.key): _posix(entry.value! as String),
  };
  final Map<String, String> destinations = <String, String>{};
  for (final Object? value in rules['rules']! as List<Object?>) {
    final Map<String, Object?> rule = value! as Map<String, Object?>;
    final String fromRoot = _posix(rule['from']! as String);
    final String toRoot = _posix(rule['to']! as String);
    final Directory directory = Directory(_join(root.path, fromRoot));
    final List<String> currentSources = directory.existsSync()
        ? <String>[
            for (final File file
                in directory
                    .listSync(recursive: false, followLinks: false)
                    .whereType<File>())
              _relative(root.path, file.path),
          ]
        : const <String>[];
    final List<String> sources = currentSources.isNotEmpty
        ? currentSources
        : _git(root, <String>[
                'ls-tree',
                '-r',
                '--name-only',
                'HEAD',
                '--',
                fromRoot,
              ])
              .split(RegExp(r'\r?\n'))
              .where((path) => path.isNotEmpty && _parent(path) == fromRoot)
              .toList();
    for (final String from in sources) {
      destinations[from] = '$toRoot/${from.split('/').last}';
    }
  }
  destinations.addAll(explicit);
  final List<_Move> moves = <_Move>[
    for (final MapEntry<String, String> entry in destinations.entries)
      _Move(entry.key, entry.value),
  ]..sort((a, b) => a.from.compareTo(b.from));
  final Set<String> targets = <String>{};
  for (final _Move move in moves) {
    if (!targets.add(move.to)) {
      throw StateError('Duplicate destination: ${move.to}');
    }
  }
  return moves;
}

Map<String, String> _gitHashes(Directory root, Iterable<String> paths) {
  final ProcessResult result = Process.runSync('git', <String>[
    'hash-object',
    ...paths,
  ], workingDirectory: root.path);
  if (result.exitCode != 0) throw StateError('${result.stderr}');
  final List<String> values = '${result.stdout}'
      .split(RegExp(r'\r?\n'))
      .where((value) => value.isNotEmpty)
      .toList();
  final List<String> keys = paths.toList();
  if (values.length != keys.length) throw StateError('git hash count mismatch');
  return <String, String>{
    for (var i = 0; i < keys.length; i++) keys[i]: values[i],
  };
}

Map<String, String> _gitHeadHashes(Directory root, Iterable<String> paths) {
  final Set<String> wanted = paths.toSet();
  final String output = _git(root, const <String>[
    'ls-tree',
    '-r',
    'HEAD',
    '--',
    'lib/src',
  ]);
  final Map<String, String> hashes = <String, String>{};
  final RegExp row = RegExp(r'^[0-9]+\s+blob\s+([0-9a-f]+)\t(.+)$');
  for (final String line in output.split(RegExp(r'\r?\n'))) {
    final RegExpMatch? match = row.firstMatch(line);
    if (match != null && wanted.contains(match.group(2))) {
      hashes[match.group(2)!] = match.group(1)!;
    }
  }
  final Set<String> missing = wanted.difference(hashes.keys.toSet());
  if (missing.isNotEmpty) throw StateError('Missing HEAD blobs: $missing');
  return hashes;
}

void _validate(Directory root, List<_Move> moves) {
  final Map<String, String> hashes = _gitHashes(root, moves.map((m) => m.from));
  for (final _Move move in moves) {
    final File source = File(_join(root.path, move.from));
    final File target = File(_join(root.path, move.to));
    if (!source.existsSync()) throw StateError('Missing source: ${move.from}');
    if (target.existsSync() && target.path != source.path) {
      throw StateError('Destination exists: ${move.to}');
    }
    if (move.gitBlob != null && hashes[move.from] != move.gitBlob) {
      throw StateError('Source changed after inventory: ${move.from}');
    }
  }
}

void _move(Directory root, List<_Move> moves) {
  for (final _Move move in moves) {
    final File source = File(_join(root.path, move.from));
    final File target = File(_join(root.path, move.to));
    target.parent.createSync(recursive: true);
    source.renameSync(target.path);
  }
}

void _rewriteDartImports(Directory root, List<_Move> moves) {
  final Map<String, String> forward = <String, String>{
    for (final _Move move in moves) move.from: move.to,
  };
  final Map<String, String> reverse = <String, String>{
    for (final _Move move in moves) move.to: move.from,
  };
  final RegExp directive = RegExp(
    r'''\b(import|export|part)\s+(['"])([^'"]+)\2''',
  );
  for (final File file
      in root
          .listSync(recursive: true, followLinks: false)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .where((file) => !_ignored(root, file))) {
    final String current = _relative(root.path, file.path);
    final String oldImporter = reverse[current] ?? current;
    final String source = file.readAsStringSync();
    final String updated = source.replaceAllMapped(directive, (match) {
      final String uri = match.group(3)!;
      final String? replacement = _mappedUri(
        uri,
        oldImporter,
        current,
        forward,
      );
      if (replacement == null) return match.group(0)!;
      return '${match.group(1)} ${match.group(2)}$replacement${match.group(2)}';
    });
    if (updated != source) file.writeAsStringSync(updated);
  }
}

String? _mappedUri(
  String uri,
  String oldImporter,
  String newImporter,
  Map<String, String> forward,
) {
  const String packagePrefix = 'package:elattar_design_system/';
  if (uri.startsWith(packagePrefix)) {
    final String oldTarget = 'lib/${uri.substring(packagePrefix.length)}';
    final String? newTarget = forward[oldTarget];
    return newTarget == null ? null : '$packagePrefix${newTarget.substring(4)}';
  }
  if (uri.startsWith('dart:') || uri.contains(':')) return null;
  final String oldTarget = _normalise('${_parent(oldImporter)}/$uri');
  final String newTarget = forward[oldTarget] ?? oldTarget;
  if (newTarget == oldTarget && newImporter == oldImporter) return null;
  return _relativeUri(_parent(newImporter), newTarget);
}

void _rewriteAuthoritativePathStrings(Directory root, List<_Move> moves) {
  final List<File> files = root
      .listSync(recursive: true, followLinks: false)
      .whereType<File>()
      .where((file) => !_ignored(root, file))
      .where(
        (file) => const <String>{'.json', '.md', '.yaml', '.yml'}.contains(
          file.uri.pathSegments.last.contains('.')
              ? '.${file.uri.pathSegments.last.split('.').last}'
              : '',
        ),
      )
      .toList();
  for (final File file in files) {
    String source = file.readAsStringSync();
    String updated = source;
    for (final _Move move in moves) {
      updated = updated.replaceAll(move.from, move.to);
      updated = updated.replaceAll(
        move.from.replaceAll('/', r'\'),
        move.to.replaceAll('/', r'\'),
      );
    }
    if (updated != source) file.writeAsStringSync(updated);
  }
}

bool _ignored(Directory root, File file) {
  final String path = _relative(root.path, file.path);
  return path.startsWith('.git/') ||
      path.startsWith('.dart_tool/') ||
      path.startsWith('build/') ||
      path.startsWith('registry/generated/') ||
      path.startsWith('tool/migration/') ||
      path.startsWith('tool/verify/out/');
}

String _git(Directory root, List<String> arguments) {
  final ProcessResult result = Process.runSync(
    'git',
    arguments,
    workingDirectory: root.path,
  );
  if (result.exitCode != 0) throw StateError('${result.stderr}');
  return '${result.stdout}';
}

String _relativeUri(String fromDirectory, String target) {
  final List<String> from = _normalise(
    fromDirectory,
  ).split('/').where((v) => v.isNotEmpty).toList();
  final List<String> to = _normalise(
    target,
  ).split('/').where((v) => v.isNotEmpty).toList();
  while (from.isNotEmpty && to.isNotEmpty && from.first == to.first) {
    from.removeAt(0);
    to.removeAt(0);
  }
  final String value = <String>[
    ...List<String>.filled(from.length, '..'),
    ...to,
  ].join('/');
  return value.startsWith('.') ? value : './$value';
}

String _parent(String path) {
  final int slash = path.lastIndexOf('/');
  return slash < 0 ? '' : path.substring(0, slash);
}

String _normalise(String value) {
  final List<String> out = <String>[];
  for (final String part in _posix(value).split('/')) {
    if (part.isEmpty || part == '.') continue;
    if (part == '..') {
      if (out.isNotEmpty) out.removeLast();
    } else {
      out.add(part);
    }
  }
  return out.join('/');
}

String _relative(String root, String path) => _posix(
  path,
).replaceFirst('${_posix(root).replaceAll(RegExp(r'/+$'), '')}/', '');
String _posix(String value) => value.replaceAll(r'\', '/');
String _join(String root, String child) =>
    '${root.replaceAll(RegExp(r'[\\/]+$'), '')}${Platform.pathSeparator}${child.replaceAll('/', Platform.pathSeparator)}';

class _Move {
  const _Move(this.from, this.to, [this.gitBlob]);
  factory _Move.fromJson(Map<String, Object?> json) => _Move(
    json['from']! as String,
    json['to']! as String,
    json['gitBlob'] as String?,
  );
  final String from;
  final String to;
  final String? gitBlob;
}
