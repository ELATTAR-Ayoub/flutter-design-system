import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Iterable<File> _dartFiles(String root) => Directory(root)
    .listSync(recursive: true)
    .whereType<File>()
    .where((File file) => file.path.endsWith('.dart'));

void main() {
  test(
    'the shipped package is native Flutter with no browser runtime seam',
    () {
      final String packageSource = _dartFiles(
        'lib',
      ).map((File file) => file.readAsStringSync()).join('\n');

      expect(packageSource, isNot(contains("import 'dart:html'")));
      expect(packageSource, isNot(contains("import 'dart:js")));
      expect(packageSource, isNot(contains("import 'package:js/")));
    },
  );

  test(
    'current code does not delegate authority to the retired web system',
    () {
      final Iterable<File> files = <String>[
        'lib',
        'example/lib',
      ].expand(_dartFiles);

      const List<String> retiredClaims = <String>[
        'Source of truth: `app/globals.css`',
        'Source of truth: `design-system/app/globals.css`',
        'A 1:1 port of the web design system',
        'transcript of globals.css',
      ];
      const List<String> retiredApi = <String>[
        'MotionCurves.cssEase',
        'MotionCurves.cssEaseOut',
        'MotionCurves.cssEaseInOut',
        'Shadows.tailwindSm',
        'Shadows.tailwindMd',
        'Shadows.tailwindLg',
        'Shadows.tailwindXl',
      ];

      final List<String> violations = <String>[];
      for (final File file in files) {
        final String source = file.readAsStringSync();
        for (final String phrase in <String>[...retiredClaims, ...retiredApi]) {
          if (source.contains(phrase)) {
            violations.add('${file.path}: $phrase');
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Historical web material may be cited as provenance, but it cannot '
            'be the current authority or public API.',
      );
    },
  );

  test('the public barrel declares the Flutter foundation authoritative', () {
    final String barrel = File(
      'lib/elattar_design_system.dart',
    ).readAsStringSync();

    expect(barrel, contains('native Flutter design system'));
    expect(barrel, contains('Flutter foundation is authoritative'));
  });
}
