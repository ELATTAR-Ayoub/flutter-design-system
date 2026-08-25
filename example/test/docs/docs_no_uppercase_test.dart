// example/test/docs/docs_no_uppercase_test.dart
/// No documentation page renders text in an uppercase type role.
///
/// Uppercase is a foundation flag on seven roles, not a page-level choice.
/// The foundation is deliberately not changed — badges and controls elsewhere
/// keep it — so the rule is enforced at the point of use instead.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The roles whose spec carries `uppercase: true`.
const List<String> _uppercaseRoles = <String>[
  'ElType.label',
  'ElType.micro',
  'ElType.tag',
  'ElType.badge',
  'ElType.serial',
  'ElType.inputSerial',
  'ElType.buttonLabelCaps',
];

/// Directories the rule covers.
const List<String> _roots = <String>[
  'lib/docs',
  'lib/components_docs',
];

void main() {
  test('no uppercase role, and no manual upper-casing', () {
    final List<String> offences = <String>[];

    for (final String root in _roots) {
      final Directory directory = Directory(root);
      if (!directory.existsSync()) continue;
      for (final FileSystemEntity entity
          in directory.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final List<String> lines = entity.readAsLinesSync();
        for (int i = 0; i < lines.length; i++) {
          final String line = lines[i];
          // Comments explain the rule; they do not break it.
          if (line.trimLeft().startsWith('//')) continue;
          for (final String role in _uppercaseRoles) {
            if (line.contains(role)) {
              offences.add('${entity.path}:${i + 1}  $role');
            }
          }
          if (line.contains('.toUpperCase()')) {
            offences.add('${entity.path}:${i + 1}  .toUpperCase()');
          }
        }
      }
    }

    expect(
      offences,
      isEmpty,
      reason:
          'documentation pages must not render uppercase text. Use '
          'ElType.caption, ElType.small or ElType.section instead:\n'
          '${offences.join('\n')}',
    );
  });
}
