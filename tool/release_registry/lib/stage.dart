/// Copies a generated registry into the published site artifact, under an
/// immutable versioned path.
///
/// The CLI pins `/registry/<version>/` and refuses to follow a moving target,
/// which is only a real guarantee if the published bytes at that path cannot
/// change. This file is where that guarantee is enforced: staging over an
/// existing version with *different* bytes is refused outright, and the
/// staged tree is validated before it is declared good rather than after
/// somebody downloads it.
///
/// Written in Dart rather than as shell copy steps in a workflow file, so the
/// behaviour a maintainer runs locally and the behaviour CI runs are the same
/// code — including the path handling, which is the part a shell script gets
/// wrong first on Windows.
library;

import 'dart:convert';
import 'dart:io';

/// What a staging run did, or refused to do.
class StageResult {
  const StageResult({
    required this.version,
    required this.destination,
    required this.filesWritten,
    required this.filesUnchanged,
    required this.treeHash,
    required this.aliasDestination,
  });

  final String version;
  final String destination;

  /// Files this run created. Zero on a re-run over identical content.
  final int filesWritten;

  /// Files already present with identical bytes.
  final int filesUnchanged;

  /// A hash over every staged relative path and its content hash.
  ///
  /// One value that changes if any file's name or content changes, so a
  /// release record can state "this is the registry" in a single line.
  final String treeHash;

  /// Where the mutable browsing alias was written, if one was.
  final String? aliasDestination;

  int get fileCount => filesWritten + filesUnchanged;
}

/// Raised for anything that must stop the release.
class StageException implements Exception {
  const StageException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Stages [source] at `<webRoot>/registry/<version>/`.
///
/// [validate] receives the staged directory and returns a list of problems;
/// a non-empty list aborts. Injected rather than imported so this package
/// does not depend on the registry builder, and so a test can prove the
/// staging refuses invalid content without having to construct content that
/// is invalid in the builder's specific terms.
StageResult stageRegistry({
  required Directory source,
  required Directory webRoot,
  required String version,
  List<String> Function(Directory staged)? validate,
  String? generationCommit,
  bool alias = false,
}) {
  if (!source.existsSync()) {
    throw StageException('No generated registry at ${source.path}');
  }
  if (!_versionPattern.hasMatch(version)) {
    throw StageException(
      'Version "$version" is not a release version (expected 1.2.3).',
    );
  }

  final Map<String, List<int>> files = _readTree(source);
  if (files.isEmpty) {
    throw StageException('The registry at ${source.path} is empty.');
  }
  for (final String required in const <String>['index.json', 'registry.json']) {
    if (!files.containsKey(required)) {
      throw StageException('The registry at ${source.path} has no $required.');
    }
  }

  final Directory destination = Directory(
    _join(<String>[webRoot.path, 'registry', version]),
  );

  // Immutability, checked before a single byte is written. A partial
  // overwrite that then aborts would be worse than either outcome.
  int unchanged = 0;
  if (destination.existsSync()) {
    final Map<String, List<int>> existing = _readTree(destination);
    final List<String> differences = _differences(existing, files);
    if (differences.isNotEmpty) {
      throw StageException(
        'Refusing to overwrite the published registry $version with '
        'different bytes.\n'
        'A released version is immutable: a CLI pinned to /registry/$version/ '
        'would silently start installing different sources.\n'
        'Publish a new version instead.\n\n'
        '${differences.take(10).map((String line) => '  - $line').join('\n')}'
        '${differences.length > 10 ? '\n  … and ${differences.length - 10} more' : ''}',
      );
    }
    unchanged = existing.length;
  }

  final int written = unchanged == 0 ? files.length : 0;
  if (unchanged == 0) {
    destination.createSync(recursive: true);
    files.forEach((String relative, List<int> bytes) {
      final File target = File(_join(<String>[destination.path, relative]))
        ..parent.createSync(recursive: true);
      target.writeAsBytesSync(bytes);
    });
  }

  final List<String> problems = validate?.call(destination) ?? const <String>[];
  if (problems.isNotEmpty) {
    throw StageException(
      'The staged registry at ${destination.path} is not valid:\n'
      '${problems.map((String line) => '  - $line').join('\n')}',
    );
  }

  String? aliasPath;
  if (alias) {
    // A convenience for browsing, never a CLI default: a released CLI that
    // followed a mutable path would change behaviour under a user who
    // upgraded nothing.
    final Directory aliasDirectory = Directory(
      _join(<String>[webRoot.path, 'registry', 'latest']),
    );
    if (aliasDirectory.existsSync()) {
      aliasDirectory.deleteSync(recursive: true);
    }
    aliasDirectory.createSync(recursive: true);
    files.forEach((String relative, List<int> bytes) {
      final File target = File(_join(<String>[aliasDirectory.path, relative]))
        ..parent.createSync(recursive: true);
      target.writeAsBytesSync(bytes);
    });
    aliasPath = aliasDirectory.path;
  }

  final String treeHash = _treeHash(files);
  _writeReleaseManifest(
    destination: destination,
    version: version,
    files: files,
    treeHash: treeHash,
    generationCommit: generationCommit,
  );

  return StageResult(
    version: version,
    destination: destination.path,
    filesWritten: written,
    filesUnchanged: unchanged,
    treeHash: treeHash,
    aliasDestination: aliasPath,
  );
}

/// A small record beside the staged registry, for humans and for release
/// verification.
///
/// Deliberately written *after* validation and *outside* the hashed tree: it
/// describes the registry, so including it in its own tree hash would make
/// the hash unstable by construction.
void _writeReleaseManifest({
  required Directory destination,
  required String version,
  required Map<String, List<int>> files,
  required String treeHash,
  String? generationCommit,
}) {
  final Map<String, Object?> index =
      jsonDecode(utf8.decode(files['index.json']!)) as Map<String, Object?>;
  final Map<String, Object?> record = <String, Object?>{
    'version': version,
    'schemaVersion': index['schemaVersion'],
    'registryVersion': index['registryVersion'],
    'itemCount': (index['items']! as List<Object?>).length,
    'fileCount': files.length,
    'treeHash': treeHash,
    if (generationCommit != null) 'generationCommit': generationCommit,
  };
  File(_join(<String>[destination.path, 'release.json'])).writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(record)}\n',
  );
}

final RegExp _versionPattern = RegExp(r'^\d+\.\d+\.\d+$');

/// Every file under [root], keyed by POSIX-separated relative path.
///
/// POSIX keys on every platform, so a tree staged on Windows and a tree
/// staged on Linux compare equal and hash the same. Comparing native paths
/// would make the immutability check report every file as different the first
/// time a release ran from the other operating system.
Map<String, List<int>> _readTree(Directory root) {
  final Map<String, List<int>> files = <String, List<int>>{};
  if (!root.existsSync()) return files;
  final String prefix = root.absolute.path.replaceAll(RegExp(r'[\\/]+$'), '');
  for (final FileSystemEntity entity in root.listSync(recursive: true)) {
    if (entity is! File) continue;
    final String absolute = entity.absolute.path;
    final String relative = absolute
        .substring(prefix.length)
        .replaceAll(r'\', '/')
        .replaceAll(RegExp('^/+'), '');
    // `release.json` describes the staged tree, so it is never part of it.
    if (relative == 'release.json') continue;
    files[relative] = entity.readAsBytesSync();
  }
  return files;
}

List<String> _differences(
  Map<String, List<int>> existing,
  Map<String, List<int>> incoming,
) {
  final List<String> problems = <String>[];
  for (final String relative in <String>{
    ...existing.keys,
    ...incoming.keys,
  }.toList()..sort()) {
    final List<int>? was = existing[relative];
    final List<int>? now = incoming[relative];
    if (was == null) {
      problems.add('$relative would be added');
    } else if (now == null) {
      problems.add('$relative would be removed');
    } else if (!_bytesEqual(was, now)) {
      problems.add('$relative would change');
    }
  }
  return problems;
}

bool _bytesEqual(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// A hash over the whole tree: every path and its content hash, sorted.
String _treeHash(Map<String, List<int>> files) {
  final List<String> lines = files.keys.toList()..sort();
  final StringBuffer buffer = StringBuffer();
  for (final String relative in lines) {
    buffer.writeln('$relative ${sha256Hex(files[relative]!)}');
  }
  return sha256Hex(utf8.encode('$buffer'));
}

String _join(List<String> parts) => parts
    .map((String part) => part.replaceAll(RegExp(r'[\\/]+$'), ''))
    .join(Platform.pathSeparator)
    .replaceAll('/', Platform.pathSeparator);

/// sha256, carried locally so this tool depends on nothing.
String sha256Hex(List<int> input) {
  const List<int> k = <int>[
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, //
    0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
    0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
    0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
    0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
    0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
  ];
  final List<int> h = <int>[
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, //
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
  ];
  int rotr(int x, int n) => (x >>> n) | ((x << (32 - n)) & 0xffffffff);

  final List<int> padded = <int>[...input, 0x80];
  while ((padded.length % 64) != 56) {
    padded.add(0);
  }
  final int bitLength = input.length * 8;
  for (int shift = 56; shift >= 0; shift -= 8) {
    padded.add((bitLength >> shift) & 0xff);
  }
  for (int chunk = 0; chunk < padded.length; chunk += 64) {
    final List<int> w = List<int>.filled(64, 0);
    for (int i = 0; i < 16; i++) {
      final int p = chunk + i * 4;
      w[i] =
          (padded[p] << 24) |
          (padded[p + 1] << 16) |
          (padded[p + 2] << 8) |
          padded[p + 3];
    }
    for (int i = 16; i < 64; i++) {
      final int s0 =
          rotr(w[i - 15], 7) ^ rotr(w[i - 15], 18) ^ (w[i - 15] >> 3);
      final int s1 = rotr(w[i - 2], 17) ^ rotr(w[i - 2], 19) ^ (w[i - 2] >> 10);
      w[i] = (w[i - 16] + s0 + w[i - 7] + s1) & 0xffffffff;
    }
    int a = h[0],
        b = h[1],
        c = h[2],
        d = h[3],
        e = h[4],
        f = h[5],
        g = h[6],
        x = h[7];
    for (int i = 0; i < 64; i++) {
      final int s1 = rotr(e, 6) ^ rotr(e, 11) ^ rotr(e, 25);
      final int ch = (e & f) ^ ((~e) & g);
      final int temp1 = (x + s1 + ch + k[i] + w[i]) & 0xffffffff;
      final int s0 = rotr(a, 2) ^ rotr(a, 13) ^ rotr(a, 22);
      final int maj = (a & b) ^ (a & c) ^ (b & c);
      final int temp2 = (s0 + maj) & 0xffffffff;
      x = g;
      g = f;
      f = e;
      e = (d + temp1) & 0xffffffff;
      d = c;
      c = b;
      b = a;
      a = (temp1 + temp2) & 0xffffffff;
    }
    h[0] = (h[0] + a) & 0xffffffff;
    h[1] = (h[1] + b) & 0xffffffff;
    h[2] = (h[2] + c) & 0xffffffff;
    h[3] = (h[3] + d) & 0xffffffff;
    h[4] = (h[4] + e) & 0xffffffff;
    h[5] = (h[5] + f) & 0xffffffff;
    h[6] = (h[6] + g) & 0xffffffff;
    h[7] = (h[7] + x) & 0xffffffff;
  }
  return h.map((int value) => value.toRadixString(16).padLeft(8, '0')).join();
}
