// Deterministic migration from the retired granular type catalog to the final
// seventeen public roles.
//
// The retired catalog carried one token per *utility combination* — a button
// label per rung, a title per overlay, a metadata line per chat primitive — so
// a rename map is the honest way to move a repository-sized call-site
// population in one reviewable pass. Anatomy that needs a weight or a face the
// core role does not carry derives it inside its own component
// (`TextStyleToken.derive`); those files are listed in [_manual] and are left
// untouched here so the derivation is written by hand where it belongs.
//
// Modes:
//   dart run tool/migration/migrate_type_roles.dart --dry-run
//   dart run tool/migration/migrate_type_roles.dart --apply
//
// Idempotent: no destination name is also a source name, so a second apply
// rewrites nothing.

import 'dart:io';

/// Retired role → the final role that carries its meaning.
const Map<String, String> _map = <String, String>{
  // Words that were really a heading at some level.
  'cardTitle': 'h4',
  'dialogTitle': 'h4',
  'overlayTitle': 'h4',
  'popoverTitle': 'h4',
  'wordmark': 'h4',
  // Reading and supporting copy.
  'bodyCompact': 'body',
  'sheetBody': 'body',
  'textareaBody': 'body',
  'bubbleContent': 'body',
  'attachmentTitle': 'body',
  'itemTitle': 'body',
  'bodySmall': 'small',
  'caption': 'small',
  'micro': 'small',
  'label': 'small',
  'textSm': 'small',
  'section': 'small',
  'eyebrow': 'small',
  'eyebrowSmall': 'small',
  'fieldLabel': 'small',
  'itemDescription': 'small',
  'tableHead': 'small',
  'menuLabel': 'small',
  'menuHeading': 'small',
  'menuShortcut': 'small',
  'messageMetadata': 'small',
  'messageMeta': 'small',
  'bubbleReactions': 'small',
  'attachmentDescription': 'small',
  'attachmentTitleSmall': 'small',
  'attachmentTitleSm': 'small',
  'tooltipLabel': 'small',
  // Interface words that are targets.
  'navSm': 'nav',
  'navMenuTrigger': 'nav',
  'toggleLabel': 'nav',
  'buttonGroupText': 'nav',
  'avatarFallback': 'nav',
  'avatarInitials': 'nav',
  // Status words.
  'chip': 'badge',
  'tag': 'badge',
  'badgeLabel': 'badge',
  // Code and identifiers.
  'kbdKey': 'code',
  'serial': 'identifier',
  'inputSerial': 'identifier',
  // Numerics.
  'numberXs': 'numberSm',
  'numXs': 'numberSm',
  'numSm': 'numberSm',
  'numBase': 'numberBase',
  'numMd': 'numberMd',
  'numLg': 'numberLg',
  'numXl': 'numberXl',
  'inputNumber': 'numberBase',
  'inputNum': 'numberBase',
  'buttonGroupNum': 'numberBase',
  'sidebarMenuBadge': 'numberSm',
  // Button label rungs. The retired catalog had one token per rung; the two
  // reading sizes carry them, and Button derives its medium weight itself.
  'buttonLabelXs': 'small',
  'buttonLabelSm': 'small',
  'buttonLabelLg': 'body',
  'buttonLabelXl': 'body',
  'buttonLabelCaps': 'nav',
  'buttonLabel': 'nav',
};

/// Files whose type is anatomy rather than a role rename: they derive from a
/// core role by hand and must not be swept.
const Set<String> _manual = <String>{
  'lib/src/components/ui/button.dart',
  'lib/src/design_system/foundation/typography.dart',
  'tool/migration/migrate_type_roles.dart',
};

const List<String> _roots = <String>[
  'lib',
  'example/lib',
  'example/test',
  'test',
  'tool',
  'skills',
];

const List<String> _extensions = <String>['.dart', '.md'];

void main(List<String> args) {
  final bool apply = args.contains('--apply');
  if (!apply && !args.contains('--dry-run')) {
    stderr.writeln('Pass --dry-run or --apply.');
    exit(64);
  }

  final RegExp pattern = RegExp(
    r'TextStyles\.(' + _map.keys.join('|') + r')\b',
  );

  int files = 0;
  int hits = 0;
  final Map<String, int> perRole = <String, int>{};

  for (final String root in _roots) {
    final Directory dir = Directory(root);
    if (!dir.existsSync()) continue;
    for (final FileSystemEntity entity in dir.listSync(recursive: true)) {
      if (entity is! File) continue;
      final String path = entity.path.replaceAll(r'\', '/');
      if (!_extensions.any(path.endsWith)) continue;
      if (_manual.contains(path)) continue;
      if (path.contains('.g.dart')) continue;

      final String before = entity.readAsStringSync();
      if (!pattern.hasMatch(before)) continue;
      final String after = before.replaceAllMapped(pattern, (Match m) {
        final String old = m.group(1)!;
        perRole[old] = (perRole[old] ?? 0) + 1;
        hits++;
        return 'TextStyles.${_map[old]}';
      });
      files++;
      stdout.writeln('${apply ? 'rewrote' : 'would rewrite'} $path');
      if (apply) entity.writeAsStringSync(after);
    }
  }

  stdout.writeln('\n$hits call sites in $files files');
  final List<String> roles = perRole.keys.toList()..sort();
  for (final String role in roles) {
    stdout.writeln('  $role -> ${_map[role]}  (${perRole[role]})');
  }
}
