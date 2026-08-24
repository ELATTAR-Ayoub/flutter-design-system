import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Signal Studio consumes the design system instead of restyling Flutter',
    () {
      final List<File> files = <File>[
        ...Directory('lib/showcase').listSync().whereType<File>().where(
          (File file) => file.path.endsWith('.dart'),
        ),
        File('lib/showcase_main.dart'),
      ];

      expect(files, isNotEmpty, reason: 'The showcase source was not found.');

      final Map<String, RegExp> banned = <String, RegExp>{
        'parallel Flutter theme': RegExp(r'\bTheme\.of\('),
        'raw Material color': RegExp(r'\bColors\.'),
        'raw color constructor': RegExp(r'\bColor(?:\.from\w+)?\('),
        'raw text widget': RegExp(r'(^|[^A-Za-z])Text\('),
        'raw text style': RegExp(r'\bTextStyle\('),
        'raw icon widget': RegExp(r'(^|[^A-Za-z])Icon\('),
        'Material feedback': RegExp(r'\b(?:SnackBar|ScaffoldMessenger)\b'),
        'Material progress': RegExp(r'\bCircularProgressIndicator\b'),
        'Material page surface': RegExp(r'\b(?:Scaffold|Material)\('),
        'raw shadow': RegExp(r'\bBoxShadow\('),
        'raw duration': RegExp(r'\bDuration\('),
        'stock curve': RegExp(r'\bCurves\.'),
        'custom alpha': RegExp(r'\.withValues\(\s*alpha\s*:'),
        'custom gradient': RegExp(r'\b(?:Linear|Radial|Sweep)Gradient\('),
        'direct numeric layout': RegExp(
          r'\b(?:width|height|top|right|bottom|left|padding|spacing|runSpacing|'
          r'maxWidth|minWidth|maxHeight|minHeight|radius|opacity|fillOpacity|'
          r'strokeWidth|tickMargin|flex)\s*:\s*-?(?:[1-9]\d*|0\.\d+)',
        ),
      };

      final List<String> violations = <String>[];
      for (final File file in files) {
        final List<String> lines = file.readAsLinesSync();
        for (int index = 0; index < lines.length; index++) {
          final String line = lines[index];
          for (final MapEntry<String, RegExp> rule in banned.entries) {
            if (rule.value.hasMatch(line)) {
              violations.add(
                '${file.path}:${index + 1} [${rule.key}] ${line.trim()}',
              );
            }
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Signal Studio must use public El* components and tokens.\n'
            '${violations.join('\n')}',
      );
    },
  );
}
