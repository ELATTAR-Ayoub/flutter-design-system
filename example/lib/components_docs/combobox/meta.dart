/// Public documentation metadata for the `combobox` component.
///
/// **Split from a combined page.** `ElCombobox<T>` used to be documented on
/// `../command/page.dart`, sharing one [ComponentDocEntry] with `ElCommand`
/// because both are "filter as you type" surfaces. They are separate public
/// components with separate source files and separate barrel exports, so
/// they now get one page each: this file documents
/// `lib/src/components/combobox.dart` alone, and `../command/meta.dart`
/// documents `lib/src/components/command.dart` alone.
///
/// `combobox` ships `registry/components/combobox.json`, and
/// [dependencies] below mirrors that manifest's `registryDependencies`.
/// Those entries still line up with the real modules `combobox.dart`
/// imports from `lib/src/components/`: `field.dart`, `icon.dart`,
/// `icon_paths.dart`, `input_group.dart`, `popover.dart`, and `select.dart`,
/// plus the shared `source-foundation` item. `select` is load-bearing rather
/// than incidental: [ElComboboxItem] is a typedef for `ElSelectOption`.
/// `input` was on the old combined list only because **command** imports
/// `input.dart` for its search field; this file does not, reaching for
/// `ElInputGroupInput` instead, so it is gone from here. `page.dart`'s
/// Installation section now documents both the published package path and
/// `elattar add combobox`.
library;

import '../catalog.dart';

const ComponentDocEntry comboboxDoc = ComponentDocEntry(
  name: 'combobox',
  title: 'Combobox',
  description:
      'A form control the reader can type into: an anchored popup of '
      'options narrowed by a plain accent- and case-insensitive substring '
      'match, holding one committed value.',
  // What lib/src/components/combobox.dart actually imports from
  // lib/src/components/: real source-level dependencies, not a registry
  // dependency list. See the library note above for why.
  dependencies: <String>[
    'field',
    'icon',
    'input-group',
    'popover',
    'select',
    'source-foundation',
  ],
  exports: <String>['ElCombobox', 'ElComboboxItem', 'elCollatorContains'],
  sourcePath: 'lib/src/components/combobox.dart',
);
