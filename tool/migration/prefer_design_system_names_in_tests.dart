import 'dart:io';

const List<String> widgetCollisions = <String>[
  'AspectRatio',
  'Form',
  'FormField',
  'Icon',
  'OverlayPortal',
  'RadioGroup',
  'RichText',
  'SafeArea',
  'ScrollPosition',
  'Table',
  'TableColumnWidth',
];

const List<String> materialCollisions = <String>[
  ...widgetCollisions,
  'ActionChip',
  'AlertDialog',
  'Badge',
  'Card',
  'CarouselController',
  'Checkbox',
  'Dialog',
  'DropdownMenu',
  'Drawer',
  'DrawerHeader',
  'Slider',
  'Switch',
  'TextFormField',
  'Tooltip',
];

void main() {
  var changed = 0;
  for (final String relative in <String>[
    'test',
    'example/lib',
    'example/test',
  ]) {
    for (final FileSystemEntity entity in Directory(
      relative,
    ).listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final String source = entity.readAsStringSync();
      String updated = source.replaceAllMapped(
        RegExp(
          r"import 'package:flutter/(widgets|material)\.dart'"
          r"(?:\s+hide\s+[A-Za-z0-9_,\s]+)?;",
        ),
        (Match match) {
          final String library = match.group(1)!;
          final List<String> hidden = library == 'material'
              ? materialCollisions
              : widgetCollisions;
          return "import 'package:flutter/$library.dart' "
              'hide ${hidden.join(', ')};';
        },
      );
      updated = updated.replaceAllMapped(
        RegExp(
          r"import 'package:flutter/rendering\.dart'"
          r"(?:\s+hide\s+[A-Za-z0-9_,\s]+)?;",
        ),
        (_) => "import 'package:flutter/rendering.dart' hide ScrollDirection;",
      );
      if (updated == source) continue;
      entity.writeAsStringSync(updated);
      changed++;
    }
  }
  stdout.writeln('preferred design-system names in $changed test files');
}
