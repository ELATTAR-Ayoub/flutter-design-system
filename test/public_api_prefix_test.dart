import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('public surfaces reject the legacy prefix and keep el() public', () {
    final String legacyPrefix = String.fromCharCodes(<int>[68, 115]);
    final String legacyCallPrefix = legacyPrefix.toLowerCase();
    final RegExp legacyType = RegExp('\\b$legacyPrefix[A-Z]\\w*');
    final RegExp legacyCall = RegExp('\\b$legacyCallPrefix\\(');
    final RegExp legacySlug = RegExp('\\b$legacyCallPrefix[-_][a-z0-9_-]*');
    final List<String> publicFiles = <String>[
      'lib/elattar_design_system.dart',
      'lib/src/foundation/spacing.dart',
      'registry/component_inventory.json',
      'registry/generated/latest/registry.json',
    ];
    for (final String path in publicFiles) {
      final String text = File(path).readAsStringSync();
      expect(text, isNot(contains(legacyType)));
      expect(text, isNot(contains(legacyCall)));
      expect(text, isNot(contains(legacySlug)));
    }
    final String spacing = File(
      'lib/src/foundation/spacing.dart',
    ).readAsStringSync();
    expect(spacing, contains('double el(num n) =>'));
  });
}
