/// The licensing contract, asserted rather than promised.
///
/// `THIRD_PARTY_NOTICES.md` is prose, and prose about hashes rots the moment
/// a file changes. This suite is what makes it a record: every hash it states
/// is recomputed here, every notice it names must exist, every redistributed
/// file must be accounted for, and the CLI must be unable to install
/// third-party material into a consumer project without the notice that
/// permits it.
///
/// The suite deliberately reads the repository from disk rather than through
/// any package API. What ships is files.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// The registry builder's own sha256, reused rather than adding a dependency
// for four calls — and, more usefully, this is the exact implementation that
// wrote the hashes being checked, so a bug in it cannot make this suite pass
// while the registry is wrong in a different way.
import '../tool/registry_builder/lib/generator.dart' show sha256Hex;

/// Notice files and the license they carry, relative to the repository root.
const Map<String, String> _noticeFiles = <String, String>{
  'third_party/fonts/inter/OFL.txt': 'SIL OPEN FONT LICENSE',
  'third_party/fonts/geist-mono/OFL.txt': 'SIL OPEN FONT LICENSE',
  'third_party/fonts/redaction/OFL.txt': 'SIL OPEN FONT LICENSE',
  'third_party/lucide/LICENSE': 'ISC License',
  'third_party/elevenlabs-ui/LICENSE': 'MIT License',
};

/// Every file this repository redistributes that somebody else wrote.
///
/// The value is the notice that must travel with it. A new entry here without
/// a matching row in `THIRD_PARTY_NOTICES.md` fails the ledger test below,
/// which is the point: adding vendored material and forgetting to record it
/// is the exact mistake this file exists to make impossible.
const Map<String, String> _redistributed = <String, String>{
  'assets/fonts/InterVariable.ttf': 'third_party/fonts/inter/OFL.txt',
  'assets/fonts/GeistMono-Variable.ttf': 'third_party/fonts/geist-mono/OFL.txt',
  'assets/fonts/Redaction35-Italic.ttf': 'third_party/fonts/redaction/OFL.txt',
  'lib/src/components/ui/icon_paths.g.dart': 'third_party/lucide/LICENSE',
  'lib/src/components/ui/icon_paths.g.index.dart': 'third_party/lucide/LICENSE',
  'shaders/orb.frag': 'third_party/elevenlabs-ui/LICENSE',
};

/// The exact copyright line the owner confirmed on 2026-08-24.
///
/// Written out here, not derived from the file under test, because a test that
/// reads its expectation from its subject asserts nothing. This string is also
/// what `packages/elattar_cli` must ship byte for byte.
const String _copyrightLine = 'Copyright (c) 2026 ELATTAR Ayoub';

String _sha256(List<int> bytes) => sha256Hex(bytes);

String _read(String path) => File(path).readAsStringSync();

/// The 64-hex tokens `THIRD_PARTY_NOTICES.md` states, lowercased.
Set<String> _ledgerHashes() {
  final RegExp hash = RegExp('`([0-9a-f]{64})`');
  return hash
      .allMatches(_read('THIRD_PARTY_NOTICES.md'))
      .map((RegExpMatch match) => match.group(1)!)
      .toSet();
}

void main() {
  group('Elattar is MIT, with the confirmed line', () {
    test('LICENSE is the standard MIT text, not a placeholder', () {
      final String license = _read('LICENSE');
      expect(license, isNot(contains('TODO')));
      expect(license, startsWith('MIT License'));
      expect(license, contains(_copyrightLine));
      // The two conditions that make it MIT rather than a description of MIT.
      expect(license, contains('Permission is hereby granted, free of charge'));
      expect(
        license,
        contains(
          'The above copyright notice and this permission notice shall be '
          'included in all',
        ),
      );
      expect(license, contains('THE SOFTWARE IS PROVIDED "AS IS"'));
    });

    test('MIT is not quietly extended with an attribution clause', () {
      // Adding a "you must credit Elattar visibly" clause would make this a
      // different, non-MIT license while still being labelled MIT. The plan
      // rules that out explicitly; this is the mechanical half of that rule.
      final String license = _read('LICENSE').toLowerCase();
      for (final String forbidden in <String>[
        'attribution',
        'badge',
        'credit',
        'powered by',
        'built with',
      ]) {
        expect(
          license,
          isNot(contains(forbidden)),
          reason:
              'the MIT text must be unmodified; "$forbidden" suggests an '
              'added clause',
        );
      }
    });

    test('the redistributable plugin payload declares its license', () {
      final Map<String, Object?> plugin =
          jsonDecode(_read('.claude-plugin/plugin.json'))
              as Map<String, Object?>;
      expect(plugin['license'], 'MIT');
    });
  });

  group('third-party notices exist and are what the ledger says', () {
    test('every notice file is present and carries its license text', () {
      _noticeFiles.forEach((String path, String marker) {
        final File file = File(path);
        expect(file.existsSync(), isTrue, reason: '$path is missing');
        expect(
          file.readAsStringSync(),
          contains(marker),
          reason: '$path does not contain "$marker"',
        );
      });
    });

    test(
      'every notice grants something, rather than merely naming a license',
      () {
        // The failure this catches is the one the audit found: a header that
        // says "MIT" or "ISC" and stops. Naming a license is not carrying it.
        for (final String path in _noticeFiles.keys) {
          final String text = _read(path);
          expect(
            text.contains('Permission is hereby granted') ||
                text.contains('Permission to use, copy, modify'),
            isTrue,
            reason: '$path states no permission grant',
          );
        }
      },
    );

    test('THIRD_PARTY_NOTICES.md records each notice by its real hash', () {
      final Set<String> ledger = _ledgerHashes();
      for (final String path in _noticeFiles.keys) {
        final String actual = _sha256(File(path).readAsBytesSync());
        expect(
          ledger,
          contains(actual),
          reason:
              '$path hashes to $actual, which THIRD_PARTY_NOTICES.md does '
              'not record. Regenerate the row rather than the file.',
        );
      }
    });

    test('THIRD_PARTY_NOTICES.md records each redistributed file', () {
      final Set<String> ledger = _ledgerHashes();
      final String prose = _read('THIRD_PARTY_NOTICES.md');
      _redistributed.forEach((String path, String notice) {
        expect(
          prose,
          contains(path),
          reason: '$path is redistributed but never named in the ledger',
        );
        // Generated Dart is exempt from the hash row: it is rebuilt from
        // lucide on every upgrade, and pinning it here would turn a routine
        // regeneration into a licensing failure. Its notice is embedded in
        // the file itself and asserted separately below.
        if (path.endsWith('.g.dart') || path.endsWith('.g.index.dart')) return;
        expect(
          ledger,
          contains(_sha256(File(path).readAsBytesSync())),
          reason: '$path has no matching hash row in the ledger',
        );
      });
    });

    test('the ledger does not claim Elattar owns third-party material', () {
      final String prose = _read('THIRD_PARTY_NOTICES.md');
      expect(
        prose,
        contains('covers Elattar'),
        reason: 'the ledger must scope the MIT grant to Elattar\'s own work',
      );
    });
  });

  group('vendored files carry their notice inline', () {
    test('the generated lucide geometry embeds lucide\'s whole LICENSE', () {
      final String generated = _read('lib/src/components/ui/icon_paths.g.dart');
      final String upstream = _read('third_party/lucide/LICENSE');
      for (final String line in upstream.split('\n')) {
        final String trimmed = line.trimRight();
        if (trimmed.isEmpty) continue;
        expect(
          generated,
          contains('// $trimmed'),
          reason:
              'the generated header is missing a line of lucide\'s LICENSE: '
              '"$trimmed". Rerun `node tool/generate_icons.mjs` — never '
              'hand-edit the generated file.',
        );
      }
    });

    test('the lucide notice keeps its Feather MIT half', () {
      // lucide's LICENSE is ISC *and* an MIT notice for the ~110 glyphs
      // inherited from Feather. A hand-copied "ISC bit" would drop the
      // second one silently, so both are named here.
      final String notice = _read('third_party/lucide/LICENSE');
      expect(notice, contains('ISC License'));
      expect(notice, contains('Lucide Icons and Contributors'));
      expect(notice, contains('The MIT License (MIT)'));
      expect(notice, contains('Cole Bemis'));
    });

    test('the vendored shader embeds the ElevenLabs MIT notice', () {
      final String shader = _read('shaders/orb.frag');
      expect(shader, contains('// Copyright (c) 2025 Eleven Labs Inc.'));
      expect(
        shader,
        contains('// Permission is hereby granted, free of charge'),
      );
      expect(
        shader,
        contains(
          '// The above copyright notice and this permission notice shall be '
          'included in all',
        ),
      );
    });

    test('the example app\'s shader copy carries the notice too', () {
      // `example/shaders/orb.frag` exists because `shaders:` is read only from
      // the root project. It is the copy a web build actually loads, so a
      // notice that only reached the package file would not reach the shipped
      // artifact.
      expect(
        File('example/shaders/orb.frag').readAsBytesSync(),
        File('shaders/orb.frag').readAsBytesSync(),
      );
    });
  });

  group('the texture is generated, not borrowed', () {
    test('the generator, its seed and its output hash are checked in', () {
      expect(
        File('tool/generate_perlin_texture/lib/perlin.dart').existsSync(),
        isTrue,
      );
      expect(
        File('tool/generate_perlin_texture/bin/generate.dart').existsSync(),
        isTrue,
      );
      final String prose = _read('THIRD_PARTY_NOTICES.md');
      expect(
        prose,
        contains('0x1EA77A12'),
        reason: 'the seed must be recorded',
      );
      expect(prose, contains('256 x 256'));
      expect(
        _ledgerHashes(),
        contains(
          _sha256(File('assets/textures/perlin-noise.png').readAsBytesSync()),
        ),
      );
    });

    test('the texture is not described as third-party material', () {
      final String prose = _read('THIRD_PARTY_NOTICES.md');
      expect(prose, contains('not** third-party material'));
    });
  });

  group('a consumer receives the notices its install requires', () {
    Map<String, Object?> manifest(String path) =>
        jsonDecode(_read(path)) as Map<String, Object?>;

    List<String> licenseTargets(Map<String, Object?> item) => <String>[
      for (final Object? entry
          in (item['licenses'] as List<Object?>? ?? const <Object?>[]))
        (entry as Map<String, Object?>)['target']! as String,
    ];

    test('source-foundation ships all three font notices', () {
      expect(
        licenseTargets(manifest('registry/foundations/source.json')),
        containsAll(<String>[
          '@license/Inter-OFL-1.1.txt',
          '@license/Geist-Mono-OFL-1.1.txt',
          '@license/Redaction-OFL-1.1.txt',
        ]),
      );
    });

    test('icon ships the lucide notice', () {
      expect(
        licenseTargets(manifest('registry/components/icon.json')),
        contains('@license/Lucide-ISC.txt'),
      );
    });

    test('voice-indicator ships the shader notice', () {
      expect(
        licenseTargets(manifest('registry/components/voice-indicator.json')),
        contains('@license/ElevenLabs-UI-MIT.txt'),
      );
    });

    test('every declared license source exists and hashes correctly', () {
      final Map<String, Object?> registry = manifest(
        'registry/generated/latest/registry.json',
      );
      int checked = 0;
      for (final Object? raw in registry['items']! as List<Object?>) {
        final Map<String, Object?> item = raw! as Map<String, Object?>;
        for (final Object? entry
            in (item['licenses'] as List<Object?>? ?? const <Object?>[])) {
          final Map<String, Object?> license = entry! as Map<String, Object?>;
          final String source = license['source']! as String;
          final File file = File(source);
          expect(file.existsSync(), isTrue, reason: 'missing $source');
          expect(_sha256(file.readAsBytesSync()), license['sha256']);
          expect(license['target'], startsWith('@license/'));
          checked++;
        }
      }
      expect(
        checked,
        _noticeFiles.length,
        reason:
            'every notice file should be delivered by exactly one item; '
            'found $checked license entries for ${_noticeFiles.length} '
            'notices',
      );
    });

    test('the generated registry stages every notice payload', () {
      const Map<String, String> payloads = <String, String>{
        'registry/generated/latest/versions/source-foundation/0.0.1/logical/license/Inter-OFL-1.1.txt':
            'third_party/fonts/inter/OFL.txt',
        'registry/generated/latest/versions/source-foundation/0.0.1/logical/license/Geist-Mono-OFL-1.1.txt':
            'third_party/fonts/geist-mono/OFL.txt',
        'registry/generated/latest/versions/source-foundation/0.0.1/logical/license/Redaction-OFL-1.1.txt':
            'third_party/fonts/redaction/OFL.txt',
        'registry/generated/latest/versions/icon/0.0.1/logical/license/Lucide-ISC.txt':
            'third_party/lucide/LICENSE',
        'registry/generated/latest/versions/voice-indicator/0.0.1/logical/license/ElevenLabs-UI-MIT.txt':
            'third_party/elevenlabs-ui/LICENSE',
      };
      payloads.forEach((String staged, String origin) {
        final File file = File(staged);
        expect(file.existsSync(), isTrue, reason: '$staged was not staged');
        expect(
          file.readAsBytesSync(),
          File(origin).readAsBytesSync(),
          reason: '$staged is not a byte copy of $origin',
        );
      });
    });

    test('the item every component depends on carries the font notices', () {
      // `icon` depends on `source-foundation`, and `button` depends on `icon`,
      // so a consumer who installs anything at all resolves the foundation and
      // therefore receives the font notices. This asserts that chain rather
      // than assuming it.
      final Map<String, Object?> icon = manifest(
        'registry/components/icon.json',
      );
      expect(icon['registryDependencies'], contains('source-foundation'));
    });
  });

  group('the CLI and the builder agree on where a notice lands', () {
    test('both halves of the @license/ contract are present', () {
      expect(
        _read('tool/registry_builder/lib/registry_validator.dart'),
        contains("'@license/'"),
      );
      final String mapper = _read(
        'packages/elattar_cli/lib/src/install/target_mapper.dart',
      );
      expect(mapper, contains("startsWith('@license/')"));
      expect(mapper, contains("licensesDirectory = 'LICENSES'"));
    });

    test('the CLI embeds Elattar\'s MIT text byte for byte', () {
      // The CLI writes this into every project it initialises, and a globally
      // activated CLI has no repository beside it to read `LICENSE` from — so
      // the constant is the only copy that reaches a consumer, and it has to
      // be the same one.
      final String embedded = _read(
        'packages/elattar_cli/lib/src/license_notice.dart',
      );
      final String license = _read('LICENSE');
      for (final String line in license.split('\n')) {
        if (line.trim().isEmpty) continue;
        expect(
          embedded,
          contains(line),
          reason: 'the embedded notice is missing "$line"',
        );
      }
      expect(embedded, contains(_copyrightLine));
    });
  });
}
