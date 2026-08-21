/// Public documentation metadata for stable, installable registry components.
library;

class ComponentDocEntry {
  const ComponentDocEntry({
    required this.name,
    required this.title,
    required this.description,
    required this.dependencies,
    required this.exports,
    required this.sourcePath,
  });

  final String name;
  final String title;
  final String description;
  final List<String> dependencies;
  final List<String> exports;
  final String sourcePath;

  String get route => '/components/$name';
  String get command => 'elattar add $name';
}

const List<ComponentDocEntry> componentDocs = <ComponentDocEntry>[
  ComponentDocEntry(
    name: 'button',
    title: 'Button',
    description:
        'Semantic actions with variants, sizes, loading, focus, and disabled behavior.',
    dependencies: <String>[
      'source-foundation',
      'press-motion',
      'icon',
      'spinner',
      'foil-value',
      'machine-surface',
      'sheen-action',
    ],
    exports: <String>[
      'DsButton',
      'DsButtonVariant',
      'DsButtonSize',
      'DsButtonEmphasis',
      'DsButtonSurface',
    ],
    sourcePath: 'lib/src/components/button.dart',
  ),
  ComponentDocEntry(
    name: 'input',
    title: 'Input',
    description:
        'Accessible text entry with focus, invalid, disabled, read-only, and grouped states.',
    dependencies: <String>[
      'source-foundation',
      'button',
      'field',
      'ds-rule',
      'machine-surface',
    ],
    exports: <String>['DsInput'],
    sourcePath: 'lib/src/components/input.dart',
  ),
  ComponentDocEntry(
    name: 'card',
    title: 'Card',
    description:
        'A structured surface with header, action, content, and footer regions.',
    dependencies: <String>['source-foundation'],
    exports: <String>[
      'DsCard',
      'DsCardHeader',
      'DsCardTitle',
      'DsCardDescription',
      'DsCardContent',
      'DsCardFooter',
    ],
    sourcePath: 'lib/src/components/card.dart',
  ),
  ComponentDocEntry(
    name: 'dialog',
    title: 'Dialog',
    description:
        'An accessible modal portal with normal and media compositions.',
    dependencies: <String>[
      'source-foundation',
      'button',
      'icon',
      'machine-surface',
    ],
    exports: <String>[
      'DsDialog',
      'DsDialogVariant',
      'DsDialogContent',
      'DsDialogHeader',
      'DsDialogFooter',
      'DsDialogTitle',
      'DsDialogDescription',
      'DsDialogMedia',
    ],
    sourcePath: 'lib/src/components/dialog.dart',
  ),
  ComponentDocEntry(
    name: 'select',
    title: 'Select',
    description:
        'Typed selection with sizes, groups, separators, disabled options, and keyboard navigation.',
    dependencies: <String>[
      'source-foundation',
      'button',
      'field',
      'icon',
      'popover',
      'machine-surface',
    ],
    exports: <String>[
      'DsSelect',
      'DsSelectSize',
      'DsSelectOption',
      'DsSelectGroup',
      'DsSelectSeparator',
    ],
    sourcePath: 'lib/src/components/select.dart',
  ),
];

ComponentDocEntry? componentDocForRoute(String route) {
  for (final ComponentDocEntry entry in componentDocs) {
    if (entry.route == route) return entry;
  }
  return null;
}

ComponentDocEntry componentDoc(String name) =>
    componentDocs.singleWhere((ComponentDocEntry entry) => entry.name == name);
