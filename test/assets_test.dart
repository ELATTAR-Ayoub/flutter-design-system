import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

/// The three reference faces, converted from the web repo's own binaries, and
/// the family names the tokens use (`--font-sans`, `--font-mono`,
/// `--font-accent` — NOT the "Space Grotesk" prose drift).
const Map<String, String> _families = <String, String>{
  'InterLocal': 'assets/fonts/InterVariable.ttf',
  'GeistMono': 'assets/fonts/GeistMono-Variable.ttf',
  'Redaction35': 'assets/fonts/Redaction35-Italic.ttf',
};

Directory get _packageRoot => Directory.current;

void main() {
  group('reference font assets', () {
    for (final MapEntry<String, String> entry in _families.entries) {
      test('${entry.key}: ${entry.value} exists and is non-empty', () {
        final File file = File('${_packageRoot.path}/${entry.value}');
        expect(
          file.existsSync(),
          isTrue,
          reason: 'missing font binary ${entry.value}',
        );
        expect(
          file.lengthSync(),
          greaterThan(1024),
          reason: '${entry.value} looks truncated',
        );
        // TTF/OTF magic: 0x00010000 (TrueType) or 'OTTO'. Never a woff2 header.
        final List<int> head = file.readAsBytesSync().sublist(0, 4);
        final bool trueType =
            head[0] == 0x00 &&
            head[1] == 0x01 &&
            head[2] == 0x00 &&
            head[3] == 0x00;
        final bool otto = String.fromCharCodes(head) == 'OTTO';
        expect(
          trueType || otto,
          isTrue,
          reason:
              '${entry.value} is not an uncompressed TTF/OTF '
              '(header: $head) — woff2 must be converted',
        );
      });
    }
  });

  group('pubspec font registration', () {
    late YamlMap pubspec;

    setUpAll(() {
      pubspec =
          loadYaml(File('${_packageRoot.path}/pubspec.yaml').readAsStringSync())
              as YamlMap;
    });

    test('package name is elattar_design_system', () {
      expect(pubspec['name'], 'elattar_design_system');
    });

    test('every family is registered under flutter: fonts:', () {
      final YamlList fonts =
          (pubspec['flutter'] as YamlMap)['fonts'] as YamlList;
      final Map<String, YamlMap> byFamily = <String, YamlMap>{
        for (final dynamic entry in fonts)
          (entry as YamlMap)['family'] as String: entry,
      };
      expect(byFamily.keys, containsAll(_families.keys));

      for (final MapEntry<String, String> entry in _families.entries) {
        final YamlList assets = byFamily[entry.key]!['fonts'] as YamlList;
        final List<String> paths = <String>[
          for (final dynamic asset in assets)
            (asset as YamlMap)['asset'] as String,
        ];
        expect(
          paths,
          contains(entry.value),
          reason: '${entry.key} must point at ${entry.value}',
        );
      }
    });

    test(
      'Redaction35 is registered as italic (the file is an italic face)',
      () {
        final YamlList fonts =
            (pubspec['flutter'] as YamlMap)['fonts'] as YamlList;
        final YamlMap redaction =
            fonts.firstWhere(
                  (dynamic e) => (e as YamlMap)['family'] == 'Redaction35',
                )
                as YamlMap;
        final YamlMap asset = (redaction['fonts'] as YamlList).first as YamlMap;
        expect(asset['style'], 'italic');
      },
    );
  });
}
