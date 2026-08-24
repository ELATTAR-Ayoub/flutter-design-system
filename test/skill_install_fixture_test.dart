/// Test 6 of the Phase H skill-verification suite: the manual-copy install
/// route, exercised as a byte-for-byte round trip against a fixture shaped
/// like `~/.claude/skills/`.
///
/// As of this writing (see
/// `docs/superpowers/reports/public-release/decisions/005-public-skill-location.md`)
/// no external install *command* is published: the root `LICENSE` is still a
/// placeholder, and a copy-paste instruction with no grant attached is a
/// redistribution invitation the owner has not authorized yet. "The
/// mechanism is complete. Publication is not." That decision record is the
/// authority for that claim, not this file.
///
/// This test therefore verifies the mechanism the eventual manual-copy
/// instruction can only ever describe correctly: recursively copying
/// `skills/elattar-flutter-ui-director/` — the single source of truth Test 1
/// in `skill_package_test.dart` finds — into `<target>/.claude/skills/` under
/// its own name, and recursively removing it again. If a published
/// instruction ever does something other than a plain recursive copy/delete
/// of that exact directory, this test's assumption needs re-pointing at the
/// published prose.
///
/// Modelled on the drift-check pattern in `test/agent_voice_test.dart`
/// ("the example app copy has not drifted"): read both sides, compare them
/// directly, fail with the actual divergence rather than a generic message.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

/// Pure-Dart SHA-256 (FIPS 180-4).
///
/// No `package:crypto` dependency: that would mean editing the root
/// `pubspec.yaml`, a file this worker does not own while a sibling is mid-flight
/// on it, for a single test file. Verified against the NIST test vectors in
/// the self-check group below, cross-checked independently against
/// `hashlib.sha256`, `openssl dgst -sha256`, and Node's `crypto` module.
String sha256Hex(List<int> message) {
  const List<int> k = <int>[
    0x428a2f98,
    0x71374491,
    0xb5c0fbcf,
    0xe9b5dba5,
    0x3956c25b,
    0x59f111f1,
    0x923f82a4,
    0xab1c5ed5,
    0xd807aa98,
    0x12835b01,
    0x243185be,
    0x550c7dc3,
    0x72be5d74,
    0x80deb1fe,
    0x9bdc06a7,
    0xc19bf174,
    0xe49b69c1,
    0xefbe4786,
    0x0fc19dc6,
    0x240ca1cc,
    0x2de92c6f,
    0x4a7484aa,
    0x5cb0a9dc,
    0x76f988da,
    0x983e5152,
    0xa831c66d,
    0xb00327c8,
    0xbf597fc7,
    0xc6e00bf3,
    0xd5a79147,
    0x06ca6351,
    0x14292967,
    0x27b70a85,
    0x2e1b2138,
    0x4d2c6dfc,
    0x53380d13,
    0x650a7354,
    0x766a0abb,
    0x81c2c92e,
    0x92722c85,
    0xa2bfe8a1,
    0xa81a664b,
    0xc24b8b70,
    0xc76c51a3,
    0xd192e819,
    0xd6990624,
    0xf40e3585,
    0x106aa070,
    0x19a4c116,
    0x1e376c08,
    0x2748774c,
    0x34b0bcb5,
    0x391c0cb3,
    0x4ed8aa4a,
    0x5b9cca4f,
    0x682e6ff3,
    0x748f82ee,
    0x78a5636f,
    0x84c87814,
    0x8cc70208,
    0x90befffa,
    0xa4506ceb,
    0xbef9a3f7,
    0xc67178f2,
  ];

  final List<int> h = <int>[
    0x6a09e667,
    0xbb67ae85,
    0x3c6ef372,
    0xa54ff53a,
    0x510e527f,
    0x9b05688c,
    0x1f83d9ab,
    0x5be0cd19,
  ];

  int mask32(int x) => x & 0xFFFFFFFF;
  int rotr(int x, int n) => mask32((x >> n) | mask32(x << (32 - n)));

  final int bitLength = message.length * 8;
  final List<int> padded = List<int>.from(message)..add(0x80);
  while (padded.length % 64 != 56) {
    padded.add(0);
  }
  final ByteData lengthBytes = ByteData(8)..setUint64(0, bitLength, Endian.big);
  padded.addAll(lengthBytes.buffer.asUint8List());

  for (int chunkStart = 0; chunkStart < padded.length; chunkStart += 64) {
    final List<int> w = List<int>.filled(64, 0);
    for (int i = 0; i < 16; i++) {
      final int o = chunkStart + i * 4;
      w[i] =
          (padded[o] << 24) |
          (padded[o + 1] << 16) |
          (padded[o + 2] << 8) |
          padded[o + 3];
    }
    for (int i = 16; i < 64; i++) {
      final int s0 =
          rotr(w[i - 15], 7) ^ rotr(w[i - 15], 18) ^ (w[i - 15] >> 3);
      final int s1 = rotr(w[i - 2], 17) ^ rotr(w[i - 2], 19) ^ (w[i - 2] >> 10);
      w[i] = mask32(w[i - 16] + s0 + w[i - 7] + s1);
    }

    int a = h[0], b = h[1], c = h[2], d = h[3];
    int e = h[4], f = h[5], g = h[6], hh = h[7];

    for (int i = 0; i < 64; i++) {
      final int s1 = rotr(e, 6) ^ rotr(e, 11) ^ rotr(e, 25);
      final int ch = (e & f) ^ ((~e & 0xFFFFFFFF) & g);
      final int temp1 = mask32(hh + s1 + ch + k[i] + w[i]);
      final int s0 = rotr(a, 2) ^ rotr(a, 13) ^ rotr(a, 22);
      final int maj = (a & b) ^ (a & c) ^ (b & c);
      final int temp2 = mask32(s0 + maj);

      hh = g;
      g = f;
      f = e;
      e = mask32(d + temp1);
      d = c;
      c = b;
      b = a;
      a = mask32(temp1 + temp2);
    }

    h[0] = mask32(h[0] + a);
    h[1] = mask32(h[1] + b);
    h[2] = mask32(h[2] + c);
    h[3] = mask32(h[3] + d);
    h[4] = mask32(h[4] + e);
    h[5] = mask32(h[5] + f);
    h[6] = mask32(h[6] + g);
    h[7] = mask32(h[7] + hh);
  }

  final StringBuffer buffer = StringBuffer();
  for (final int word in h) {
    buffer.write(word.toRadixString(16).padLeft(8, '0'));
  }
  return buffer.toString();
}

/// The skill directory this fixture round-trips. Kept as one literal so a
/// rename shows up as one edit, matching `_skillName` in
/// `skill_package_test.dart`.
const String _skillName = 'elattar-flutter-ui-director';

/// Repository root — `flutter test` always runs from the package root.
Directory get _repoRoot => Directory.current;

/// Relative (posix-separated) paths of every regular file under [root].
List<String> _relativeFilePaths(Directory root) {
  final String rootPosix = root.path.replaceAll(r'\', '/');
  final List<String> paths = <String>[
    for (final FileSystemEntity entity in root.listSync(recursive: true))
      if (entity is File)
        entity.path.replaceAll(r'\', '/').replaceFirst('$rootPosix/', ''),
  ];
  paths.sort();
  return paths;
}

/// Recursively copies every regular file under [source] to the same
/// relative path under [destination], creating directories as needed. This
/// is the effect a `cp -r`, `Copy-Item -Recurse`, or `robocopy /E` manual
/// install instruction must produce, regardless of which of those a
/// published command eventually uses.
void _copyTree(Directory source, Directory destination) {
  destination.createSync(recursive: true);
  for (final String relative in _relativeFilePaths(source)) {
    final File destinationFile = File('${destination.path}/$relative');
    destinationFile.parent.createSync(recursive: true);
    destinationFile.writeAsBytesSync(
      File('${source.path}/$relative').readAsBytesSync(),
    );
  }
}

void main() {
  group('sha256Hex self-check', () {
    test('matches independently-verified NIST test vectors', () {
      // Cross-checked against `hashlib.sha256`, `openssl dgst -sha256`, and
      // Node's `crypto` module — all four agree. If this group ever fails,
      // the round-trip test below cannot be trusted regardless of its own
      // result.
      expect(
        sha256Hex(utf8.encode('')),
        'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      );
      expect(
        sha256Hex(utf8.encode('abc')),
        'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
      );
      expect(
        sha256Hex(
          utf8.encode(
            'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq',
          ),
        ),
        '248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1',
      );
    });
  });

  final Directory sourceDir = Directory('${_repoRoot.path}/skills/$_skillName');
  final bool sourceMissing = !sourceDir.existsSync();
  final Object skipReason = sourceMissing
      ? 'skills/$_skillName does not exist yet — the directory move onto '
            'skills/ has not landed'
      : false;

  group('manual-copy install/remove round trip against ~/.claude/skills/', () {
    test('install produces a byte-identical tree with exactly the published '
        'file list, and removal leaves nothing orphaned', () {
      final List<String> publishedFiles = _relativeFilePaths(sourceDir);
      expect(
        publishedFiles,
        isNotEmpty,
        reason: 'skills/$_skillName has no files — nothing to install',
      );

      // A fixture shaped like a real home directory's skill store, with a
      // sibling skill already present. The sibling exists purely to prove
      // install/remove of *this* skill never touches anything else under
      // ~/.claude/skills/.
      final Directory fixtureRoot = Directory.systemTemp.createTempSync(
        'elattar-skill-install-',
      );
      addTearDown(() => fixtureRoot.deleteSync(recursive: true));

      final Directory claudeSkillsDir = Directory(
        '${fixtureRoot.path}/.claude/skills',
      )..createSync(recursive: true);

      final Directory siblingSkillDir = Directory(
        '${claudeSkillsDir.path}/some-other-skill',
      )..createSync(recursive: true);
      final File siblingFile = File('${siblingSkillDir.path}/SKILL.md');
      const String siblingContent =
          '---\nname: some-other-skill\n---\n# Other\n';
      siblingFile.writeAsStringSync(siblingContent);

      final Directory installedDir = Directory(
        '${claudeSkillsDir.path}/$_skillName',
      );

      // ---- install: the effect of the documented copy command ----
      _copyTree(sourceDir, installedDir);

      // Exactly the published file list, nothing missing, nothing extra.
      final List<String> installedFiles = _relativeFilePaths(installedDir);
      expect(
        installedFiles,
        equals(publishedFiles),
        reason:
            'the installed tree\'s file list diverges from '
            'skills/$_skillName — either the copy dropped/added files, '
            'or a file was added to the published skill without the '
            'install step picking it up.\n'
            'published: $publishedFiles\n'
            'installed: $installedFiles',
      );

      // Byte-identical per file, proven by sha256, matching how Test 1's
      // published tree and the install target are meant to be one and the
      // same content.
      for (final String relative in publishedFiles) {
        final String sourceHash = sha256Hex(
          File('${sourceDir.path}/$relative').readAsBytesSync(),
        );
        final String installedHash = sha256Hex(
          File('${installedDir.path}/$relative').readAsBytesSync(),
        );
        expect(
          installedHash,
          equals(sourceHash),
          reason:
              '$relative differs (sha256 mismatch) between '
              'skills/$_skillName and the installed copy',
        );
      }

      // Install must not have disturbed the sibling skill.
      expect(
        siblingFile.readAsStringSync(),
        siblingContent,
        reason:
            'installing $_skillName altered an unrelated, '
            'already-installed skill',
      );

      // ---- remove: the effect of the documented removal ----
      installedDir.deleteSync(recursive: true);

      expect(
        installedDir.existsSync(),
        isFalse,
        reason: 'removal did not delete the installed skill directory',
      );
      expect(
        claudeSkillsDir.existsSync(),
        isTrue,
        reason:
            'removal deleted ~/.claude/skills/ itself, not just '
            'the one skill inside it',
      );

      // Nothing orphaned: the skills directory now contains exactly the
      // sibling it had before install, no leftover files or directories.
      final List<String> remainingEntries =
          claudeSkillsDir
              .listSync()
              .map(
                (FileSystemEntity e) =>
                    e.uri.pathSegments.where((String s) => s.isNotEmpty).last,
              )
              .toList()
            ..sort();
      expect(
        remainingEntries,
        equals(<String>['some-other-skill']),
        reason:
            'removal left orphaned entries under '
            '~/.claude/skills/: $remainingEntries',
      );
      expect(
        siblingFile.existsSync(),
        isTrue,
        reason: 'removal deleted an unrelated, already-installed skill',
      );
      expect(
        siblingFile.readAsStringSync(),
        siblingContent,
        reason: 'removal altered an unrelated, already-installed skill',
      );
    }, skip: skipReason);
  });
}
