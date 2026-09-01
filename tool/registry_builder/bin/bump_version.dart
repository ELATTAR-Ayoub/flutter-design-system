// Moves the registry, and the items that need to move, to a new version.
//
// A released version is immutable (`tool/README.md` §Immutability). So a source
// change is not published by rewriting what a released item installs — it is
// published by giving that item a new version, under a new registry version,
// while the released payloads stay exactly where a pinned consumer left them.
//
//   dart run tool/registry_builder/bin/bump_version.dart --from 0.0.1 --to 0.0.2 --dry-run
//   dart run tool/registry_builder/bin/bump_version.dart --from 0.0.1 --to 0.0.2 --apply
//
// **Which items move.** Two reasons, and the second is the one that is easy to
// forget:
//
//   1. the item's own payload bytes changed against the released lock;
//   2. something it depends on, transitively, moved.
//
// (2) matters because an item's version is a promise about what installing it
// *does*. `form@0.0.1` installs `validation-rule` too; if `validation-rule`
// changed and `form` stayed at 0.0.1, a consumer re-installing `form@0.0.1`
// would get different sources than they got before, which is the exact failure
// the immutability rule exists to prevent — just one edge further out.
//
// Items that are neither changed nor downstream of a change keep their released
// version, and the generator re-emits their released payloads byte for byte.
// `test/registry_released_immutability_test.dart` is what proves it did.
//
// The tool rewrites only `version` and `sourceLink` in the authored manifests.
// Hashes are `reseal.dart`'s job and must already be current: this tool refuses
// to run if any authored hash disagrees with its source, because a stale hash
// would make the changed-set wrong.

import 'dart:convert';
import 'dart:io';

import '../lib/generator.dart' show sha256Hex;
import '../lib/registry_validator.dart' show logicalTargetPrefixes;

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

/// The generator's own target → payload-path rule, so this tool and the
/// generated tree address the same file.
String _payloadPath(String target) {
  for (final String prefix in logicalTargetPrefixes) {
    if (target.startsWith(prefix)) return 'logical/${target.substring(1)}';
  }
  return 'logical/$target';
}

class _Manifest {
  _Manifest(this.file, this.json);

  final File file;
  final Map<String, dynamic> json;

  String get name => '${json['name']}';
  String get version => '${json['version']}';
  List<String> get dependencies => <String>[
    for (final Object? d
        in (json['registryDependencies'] as List<Object?>?) ??
            const <Object?>[])
      '$d',
  ];

  /// Every payload this item declares: target → (source path, declared sha256).
  Map<String, ({String source, String sha256})> get payloads {
    final Map<String, ({String source, String sha256})> out =
        <String, ({String source, String sha256})>{};
    for (final String key in _hashedLists) {
      final Object? list = json[key];
      if (list is! List) continue;
      for (final Object? entry in list) {
        if (entry is! Map) continue;
        final Object? target = entry['target'];
        final Object? source = entry['source'];
        final Object? sha = entry['sha256'];
        if (target is String && source is String && sha is String) {
          out[target] = (source: source, sha256: sha);
        }
      }
    }
    return out;
  }
}

List<_Manifest> _readManifests() {
  final List<_Manifest> out = <_Manifest>[];
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
    for (final File file in files) {
      out.add(
        _Manifest(
          file,
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
        ),
      );
    }
  }
  return out;
}

String? _arg(List<String> args, String name) {
  final int i = args.indexOf(name);
  return i >= 0 && i + 1 < args.length ? args[i + 1] : null;
}

void main(List<String> args) {
  final String? from = _arg(args, '--from');
  final String? to = _arg(args, '--to');
  final bool apply = args.contains('--apply');
  if (from == null || to == null || (!apply && !args.contains('--dry-run'))) {
    stderr.writeln(
      'Usage: bump_version.dart --from <version> --to <version> '
      '(--dry-run | --apply)',
    );
    exit(64);
  }

  final File lockFile = File('registry/released/$from.lock.json');
  if (!lockFile.existsSync()) {
    stderr.writeln(
      'No released lock at ${lockFile.path}. Record it first with '
      'snapshot_released.dart, from a tree verified against the release tag.',
    );
    exit(1);
  }
  final Map<String, String> locked =
      ((jsonDecode(lockFile.readAsStringSync())
                  as Map<String, Object?>)['payloads']!
              as Map<String, Object?>)
          .map((String k, Object? v) => MapEntry<String, String>(k, '$v'));

  final List<_Manifest> manifests = _readManifests();

  // A stale hash would make the changed-set wrong, so refuse rather than guess.
  final List<String> stale = <String>[];
  for (final _Manifest m in manifests) {
    m.payloads.forEach((String target, ({String source, String sha256}) p) {
      final File file = File(p.source);
      if (!file.existsSync()) {
        stale.add('${m.name}: missing source ${p.source}');
      } else if (sha256Hex(file.readAsBytesSync()) != p.sha256) {
        stale.add('${m.name}: ${p.source} does not match its declared sha256');
      }
    });
  }
  if (stale.isNotEmpty) {
    stderr.writeln(
      'Authored hashes are out of date. Run reseal.dart first — the '
      'changed-set below would be wrong otherwise:\n  ${stale.join('\n  ')}',
    );
    exit(1);
  }

  // 1. Items whose own bytes moved against the released lock.
  final Set<String> changed = <String>{};
  for (final _Manifest m in manifests) {
    if (m.version != from) continue;
    bool moved = false;
    final Map<String, ({String source, String sha256})> payloads = m.payloads;
    payloads.forEach((String target, ({String source, String sha256}) p) {
      final String key = 'versions/${m.name}/$from/${_payloadPath(target)}';
      final String? released = locked[key];
      if (released == null || released != p.sha256) moved = true;
    });
    // A payload that the release had and this manifest no longer declares is
    // also a change — the item now installs fewer files.
    final String prefix = 'versions/${m.name}/$from/';
    final Set<String> releasedPaths = locked.keys
        .where((String k) => k.startsWith(prefix))
        .map((String k) => k.substring(prefix.length))
        .where((String k) => k != 'manifest.json')
        .toSet();
    final Set<String> declaredPaths = payloads.keys.map(_payloadPath).toSet();
    if (!releasedPaths.difference(declaredPaths).isEmpty) moved = true;
    if (moved) changed.add(m.name);
  }

  // 2. Everything downstream of a change.
  final Map<String, Set<String>> dependents = <String, Set<String>>{};
  for (final _Manifest m in manifests) {
    for (final String d in m.dependencies) {
      dependents.putIfAbsent(d, () => <String>{}).add(m.name);
    }
  }
  final Set<String> closure = <String>{...changed};
  final List<String> queue = <String>[...changed];
  while (queue.isNotEmpty) {
    for (final String dependent
        in dependents[queue.removeLast()] ?? const <String>{}) {
      if (closure.add(dependent)) queue.add(dependent);
    }
  }

  final List<String> moving = closure.toList()..sort();
  final List<String> staying =
      manifests
          .map((_Manifest m) => m.name)
          .where((String n) => !closure.contains(n))
          .toList()
        ..sort();

  stdout
    ..writeln('changed by their own bytes : ${changed.length}')
    ..writeln('moving to $to (with dependents) : ${moving.length}')
    ..writeln('staying at $from : ${staying.length}  ${staying.join(', ')}')
    ..writeln();

  int rewritten = 0;
  for (final _Manifest m in manifests) {
    if (!closure.contains(m.name)) continue;
    final Object? link = m.json['sourceLink'];
    m.json['version'] = to;
    if (link is String) {
      m.json['sourceLink'] = link.replaceAll('/blob/v$from/', '/blob/v$to/');
    }
    stdout.writeln(
      '${apply ? 'bumped' : 'would bump'} ${m.name}  $from -> $to',
    );
    if (apply) {
      m.file.writeAsStringSync(
        '${const JsonEncoder.withIndent('  ').convert(m.json)}\n',
      );
    }
    rewritten++;
  }
  stdout.writeln('\n$rewritten manifests');
}
