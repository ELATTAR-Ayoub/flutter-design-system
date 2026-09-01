/// A released item/version is present, unchanged, and complete.
///
/// `tool/README.md` §Immutability states the rule and `stage.dart` enforces it
/// at publication: staging over a published version with different bytes is
/// refused. That refusal only fires when someone runs a deploy, though, and by
/// then the wrong bytes have been in the repository for however long it took.
/// This suite moves the same check earlier, into `flutter test`.
///
/// It reads `registry/released/0.0.1.lock.json`, recorded once from a generated
/// tree verified byte-identical to tag `v0.0.1`
/// (`tool/registry_builder/bin/snapshot_released.dart`).
///
/// **Three findings, reported apart, because they mean different things.**
///
///   * *Missing* — a released payload is gone. A consumer pinned to that
///     version gets a 404 part-way through an install and is left with a
///     half-written project, which is worse than wrong bytes. Deleting a
///     released payload is never correct, so absence is a failure in its own
///     right and not a reason to skip the byte check.
///   * *Changed* — the path is there and the bytes are not the ones published.
///     A pinned consumer silently installs different sources.
///   * *Unexpected* — a file inside a released version directory that the
///     release never published. A version is a closed set; adding to it after
///     the fact makes its manifest and its payload tree disagree.
///
/// Republishing an item does not remove its old directory: `/registry/0.0.2/`
/// still serves `versions/form/0.0.1/`, because `form` is still at `0.0.1`
/// there. Removing an item from the *current* registry removes it from the
/// index, never from history.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// The registry builder's own hasher, reused rather than adding a dependency
// to a published package's manifest for something only tests need — the same
// import `license_distribution_test.dart` makes, and the same function the
// generator hashes payloads with, so the test and the tool cannot disagree.
// The generator lives in its own package under `tool/`, which this package
// does not depend on: the guard has to hash payloads the same way the
// generator hashed them, and a second implementation of sha256 here would be
// a second thing to keep in step. Imported by path for that reason, and only
// for that one function.
// ignore: avoid_relative_lib_imports
import '../tool/registry_builder/lib/generator.dart' show sha256Hex;

const String _generated = 'registry/generated/latest';
const String _lockPath = 'registry/released/0.0.1.lock.json';

String _sha256(List<int> bytes) => sha256Hex(bytes);

Map<String, String> _lockedPayloads(Map<String, Object?> lock) =>
    (lock['payloads']! as Map<String, Object?>).map(
      (String k, Object? v) => MapEntry<String, String>(k, '$v'),
    );

/// The item name out of `versions/<item>/<version>/…`.
String _itemOf(String payloadPath) => payloadPath.split('/')[1];

/// What comparing a generated tree against a release lock found.
class ReleasedPayloadAudit {
  const ReleasedPayloadAudit({
    required this.missing,
    required this.changed,
    required this.unexpected,
  });

  /// Locked paths that are not in the tree at all.
  final List<String> missing;

  /// Locked paths whose bytes differ, as `path`, expected, actual.
  final List<String> changed;

  /// Files inside a released version directory that the lock does not know.
  final List<String> unexpected;

  bool get isClean => missing.isEmpty && changed.isEmpty && unexpected.isEmpty;
}

/// Audits [generatedRoot] against [locked] for one released [version].
///
/// Takes its roots as arguments and returns findings rather than asserting, so
/// the seeded-failure group below can run the real logic against a fixture. A
/// guard nobody has watched fail is a guard nobody knows works.
ReleasedPayloadAudit auditReleasedPayloads({
  required String generatedRoot,
  required Map<String, String> locked,
  required String version,
}) {
  final List<String> missing = <String>[];
  final List<String> changed = <String>[];

  for (final MapEntry<String, String> entry in locked.entries) {
    final File file = File('$generatedRoot/${entry.key}');
    if (!file.existsSync()) {
      missing.add(entry.key);
      continue;
    }
    final String actual = _sha256(file.readAsBytesSync());
    if (actual != entry.value) {
      changed.add('${entry.key}\n    ${entry.value}\n -> $actual');
    }
  }

  final List<String> unexpected = <String>[];
  // Both sides are normalised to forward slashes before they are compared.
  // `Directory.systemTemp` hands back a Windows path, and relativising a
  // slash-normalised file path against a backslashed root matches nothing —
  // which would make every file in the fixture look unexpected.
  final String root = generatedRoot.replaceAll(r'\', '/');
  final Directory versions = Directory('$root/versions');
  if (versions.existsSync()) {
    for (final Directory item in versions.listSync().whereType<Directory>()) {
      final Directory tree = Directory('${item.path}/$version');
      if (!tree.existsSync()) continue;
      for (final File file
          in tree.listSync(recursive: true).whereType<File>()) {
        final String key = file.path.replaceAll(r'\', '/').split('$root/').last;
        if (!locked.containsKey(key)) unexpected.add(key);
      }
    }
  }

  return ReleasedPayloadAudit(
    missing: missing..sort(),
    changed: changed..sort(),
    unexpected: unexpected..sort(),
  );
}

void main() {
  final File lockFile = File(_lockPath);
  final Map<String, Object?> lock =
      jsonDecode(lockFile.readAsStringSync()) as Map<String, Object?>;
  final String version = '${lock['version']}';
  final Map<String, String> locked = _lockedPayloads(lock);

  ReleasedPayloadAudit auditRealTree() => auditReleasedPayloads(
    generatedRoot: _generated,
    locked: locked,
    version: version,
  );

  group('the released $version registry is immutable', () {
    test('the lock itself is intact', () {
      expect(lockFile.existsSync(), isTrue, reason: '$_lockPath is missing');
      expect(locked, hasLength(lock['payloadCount']));
      expect(locked, isNotEmpty);
      for (final String path in locked.keys) {
        expect(
          path,
          startsWith('versions/'),
          reason: 'a lock entry is a payload path under versions/',
        );
        expect(path, contains('/$version/'));
      }
    });

    test('every released payload is still present', () {
      expect(
        auditRealTree().missing,
        isEmpty,
        reason:
            'These paths are published at /registry/$version/ and something '
            'deleted them. A pinned consumer would get a 404 part-way through '
            'an install and be left with a half-written project. A released '
            'payload is never removed: republishing an item gives it a new '
            'version directory and leaves the old one addressable.',
      );
    });

    test('every released payload still has its released bytes', () {
      expect(
        auditRealTree().changed,
        isEmpty,
        reason:
            'These paths are published at /registry/$version/. Regenerating '
            'them with different bytes would make a pinned consumer install '
            'different sources than it installed yesterday. Publish the change '
            'as a new item version instead.',
      );
    });

    test('nothing new appears inside a released version directory', () {
      expect(
        auditRealTree().unexpected,
        isEmpty,
        reason:
            'A file that was not part of the released $version payload cannot '
            'be added to it after the fact: the manifest that version '
            'published does not mention it.',
      );
    });

    test('the three findings are reported apart, not as one verdict', () {
      final ReleasedPayloadAudit audit = auditRealTree();
      expect(audit.missing, isEmpty);
      expect(audit.changed, isEmpty);
      expect(audit.unexpected, isEmpty);
      expect(audit.isClean, isTrue);
    });

    test('a released item that is gone has been republished, not dropped', () {
      final Map<String, Object?> index =
          jsonDecode(File('$_generated/index.json').readAsStringSync())
              as Map<String, Object?>;
      final Map<String, String> current = <String, String>{
        for (final Object? raw in index['items']! as List<Object?>)
          '${(raw! as Map<String, Object?>)['name']}':
              '${(raw as Map<String, Object?>)['version']}',
      };

      final Set<String> releasedItems = locked.keys.map(_itemOf).toSet();
      final List<String> findings = <String>[];
      for (final String item in releasedItems) {
        final bool payloadPresent = Directory(
          '$_generated/versions/$item/$version',
        ).existsSync();
        if (payloadPresent) continue;
        final String? now = current[item];
        if (now == null) {
          findings.add('$item: released at $version, absent from the index');
        } else if (now == version) {
          findings.add(
            '$item: the index still says $version, but its payload is gone',
          );
        }
      }
      expect(
        findings,
        isEmpty,
        reason:
            'An item released at $version may only lose its payload here by '
            'moving to a higher version, which is what republishing means:\n'
            '${findings.join('\n')}',
      );
    });
  });

  group('the guard catches each failure, seeded', () {
    /// A fixture holding one released item's payloads, and their lock.
    ({Directory root, Map<String, String> locked, File payload}) seed() {
      final Directory root = Directory.systemTemp.createTempSync(
        'elattar-released-',
      );
      addTearDown(() => root.deleteSync(recursive: true));
      final File payload =
          File('${root.path}/versions/button/0.0.1/logical/ui/button.dart')
            ..createSync(recursive: true)
            ..writeAsStringSync('const button = true;\n');
      final File manifest =
          File('${root.path}/versions/button/0.0.1/manifest.json')
            ..createSync(recursive: true)
            ..writeAsStringSync('{}\n');
      return (
        root: root,
        locked: <String, String>{
          'versions/button/0.0.1/logical/ui/button.dart': _sha256(
            payload.readAsBytesSync(),
          ),
          'versions/button/0.0.1/manifest.json': _sha256(
            manifest.readAsBytesSync(),
          ),
        },
        payload: payload,
      );
    }

    test('a clean tree reports nothing', () {
      final ({Directory root, Map<String, String> locked, File payload}) f =
          seed();
      expect(
        auditReleasedPayloads(
          generatedRoot: f.root.path,
          locked: f.locked,
          version: '0.0.1',
        ).isClean,
        isTrue,
      );
    });

    test('a deleted released payload is reported missing, not skipped', () {
      final ({Directory root, Map<String, String> locked, File payload}) f =
          seed();
      f.payload.deleteSync();

      final ReleasedPayloadAudit audit = auditReleasedPayloads(
        generatedRoot: f.root.path,
        locked: f.locked,
        version: '0.0.1',
      );
      expect(audit.missing, <String>[
        'versions/button/0.0.1/logical/ui/button.dart',
      ]);
      expect(audit.changed, isEmpty, reason: 'absence is not drift');
      expect(audit.unexpected, isEmpty);
      expect(audit.isClean, isFalse);
    });

    test('a changed released payload is reported changed', () {
      final ({Directory root, Map<String, String> locked, File payload}) f =
          seed();
      f.payload.writeAsStringSync('const button = false;\n');

      final ReleasedPayloadAudit audit = auditReleasedPayloads(
        generatedRoot: f.root.path,
        locked: f.locked,
        version: '0.0.1',
      );
      expect(audit.changed, hasLength(1));
      expect(audit.changed.single, contains('button.dart'));
      expect(audit.missing, isEmpty);
      expect(audit.isClean, isFalse);
    });

    test('a file added to a released version is reported unexpected', () {
      final ({Directory root, Map<String, String> locked, File payload}) f =
          seed();
      File('${f.root.path}/versions/button/0.0.1/logical/ui/extra.dart')
        ..createSync(recursive: true)
        ..writeAsStringSync('const extra = true;\n');

      final ReleasedPayloadAudit audit = auditReleasedPayloads(
        generatedRoot: f.root.path,
        locked: f.locked,
        version: '0.0.1',
      );
      expect(audit.unexpected, <String>[
        'versions/button/0.0.1/logical/ui/extra.dart',
      ]);
      expect(audit.missing, isEmpty);
      expect(audit.changed, isEmpty);
      expect(audit.isClean, isFalse);
    });

    test('a payload at another version is not this version s business', () {
      final ({Directory root, Map<String, String> locked, File payload}) f =
          seed();
      File('${f.root.path}/versions/button/0.0.2/logical/ui/button.dart')
        ..createSync(recursive: true)
        ..writeAsStringSync('const button = 2;\n');

      expect(
        auditReleasedPayloads(
          generatedRoot: f.root.path,
          locked: f.locked,
          version: '0.0.1',
        ).isClean,
        isTrue,
      );
    });
  });

  group('the guard would notice drift', () {
    test('a changed byte changes the digest it is compared against', () {
      expect(_sha256(utf8.encode('a')), isNot(_sha256(utf8.encode('b'))));
    });

    test('the lock covers every released item', () {
      // 99 items shipped in 0.0.1; each contributes at least its manifest.
      expect(locked.keys.map(_itemOf).toSet(), hasLength(99));
    });
  });
}
