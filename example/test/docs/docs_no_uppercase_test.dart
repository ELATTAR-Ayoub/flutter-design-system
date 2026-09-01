// example/test/docs/docs_no_uppercase_test.dart
/// Authored source may not reach for a retired type role.
///
/// The catalog was consolidated into seventeen roles, and the retired members
/// were deleted rather than aliased. A reintroduction would not compile — but
/// the *names* also survive in prose, snippets and code samples, and a
/// documentation page that tells a reader to use `TextStyles.eyebrow` is wrong
/// in a way the compiler cannot see. This guard covers both.
///
/// Uppercasing is no longer a foundation flag: no role transforms its text. A
/// component or a page that wants a caps treatment performs it itself and
/// keeps the authored string as the accessible name — `CapsLabel` in the docs
/// kit, `Button`'s `caps` emphasis in the package. So `.toUpperCase()` is not
/// an offence here; a retired role name is.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every member the retired catalog published that no longer exists.
const List<String> _retired = <String>[
  'accent',
  'accentSize',
  'attachmentDescription',
  'attachmentTitle',
  'attachmentTitleSmall',
  'avatarFallback',
  'avatarInitials',
  'badgeLabel',
  'bodyCompact',
  'bodySmall',
  'bubbleContent',
  'bubbleReactions',
  'buttonGroupNum',
  'buttonGroupText',
  'buttonLabel',
  'buttonLabelCaps',
  'buttonLabelLg',
  'buttonLabelSm',
  'buttonLabelXl',
  'buttonLabelXs',
  'caption',
  'cardTitle',
  'chip',
  'dialogTitle',
  'displaySize',
  'eyebrow',
  'eyebrowSmall',
  'fieldLabel',
  'h1Size',
  'inputNumber',
  'inputSerial',
  'itemDescription',
  'itemTitle',
  'kbdKey',
  'menuHeading',
  'menuLabel',
  'menuShortcut',
  'messageMetadata',
  'navMenuTrigger',
  'navSm',
  'numberXs',
  'overlayTitle',
  'popoverTitle',
  'section',
  'sheetBody',
  'sidebarMenuBadge',
  'tableHead',
  'tag',
  'textareaBody',
  'toggleLabel',
  'tooltipLabel',
  'wordmark',
];

/// Directories the rule covers.
const List<String> _roots = <String>['lib/docs', 'lib/components_docs'];

void main() {
  test('no documentation page names a retired type role', () {
    final List<String> offences = <String>[];

    for (final String root in _roots) {
      final Directory directory = Directory(root);
      if (!directory.existsSync()) continue;
      for (final FileSystemEntity entity in directory.listSync(
        recursive: true,
      )) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final List<String> lines = entity.readAsLinesSync();
        for (int i = 0; i < lines.length; i++) {
          final String line = lines[i];
          for (final String role in _retired) {
            if (RegExp(
              'TextStyles\\.${RegExp.escape(role)}(?![A-Za-z0-9_])',
            ).hasMatch(line)) {
              offences.add('${entity.path}:${i + 1}  TextStyles.$role');
            }
          }
        }
      }
    }

    expect(
      offences,
      isEmpty,
      reason:
          'the retired catalog was consolidated into the seventeen roles in '
          'TextStyles.all. Use the role closest to what the text means, and '
          'derive a weight on it if the anatomy needs one:\n'
          '${offences.join('\n')}',
    );
  });

  test('the guard would actually catch a reintroduction', () {
    // A guard nobody has seen fail is a guard nobody knows works.
    const String sample = 'StyledText(label, TextStyles.eyebrow)';
    expect(
      RegExp('TextStyles\\.eyebrow(?![A-Za-z0-9_])').hasMatch(sample),
      isTrue,
    );
    expect(
      RegExp('TextStyles\\.small(?![A-Za-z0-9_])').hasMatch(sample),
      isFalse,
    );
  });
}
