import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('new semantic tokens have production consumers', () {
    final String production = <Directory>[
      Directory('lib/src/components'),
      Directory('lib/src/blocks'),
    ].expand((Directory directory) => directory.listSync(recursive: true))
        .whereType<File>()
        .where((File file) => file.path.endsWith('.dart'))
        .map((File file) => file.readAsStringSync())
        .join('\n');

    const List<String> tokens = <String>[
      'overlayEnter',
      'overlayExit',
      'open',
      'close',
      'expand',
      'collapse',
      'drawerOpen',
      'drawerClose',
      'pressIn',
      'pressOut',
      'stateChange',
      'actionText',
      'premiumText',
      'successText',
      'warningText',
      'infoText',
      'destructiveText',
      'messageAccent',
      'messageAccentHover',
      'agentAccent',
      'agentAccentMuted',
    ];

    for (final String token in tokens) {
      expect(
        RegExp('\\.${RegExp.escape(token)}\\b').hasMatch(production),
        isTrue,
        reason: '$token must remain useful in production UI.',
      );
    }
  });
}
