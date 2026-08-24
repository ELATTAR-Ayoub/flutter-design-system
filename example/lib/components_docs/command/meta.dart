/// Public documentation metadata for the `command` component.
///
/// **Split from a combined page.** This directory used to document
/// `lib/src/components/command.dart` and `lib/src/components/combobox.dart`
/// together, under one [ComponentDocEntry] titled "Command & Combobox", with
/// a second `comboboxSourcePath` const beside it for the file
/// [ComponentDocEntry.sourcePath] could not name. Both components are real,
/// separately barrel-exported public API, so they now get one page each:
/// this file documents `ElCommand` alone, and `../combobox/meta.dart`
/// documents `ElCombobox<T>` alone.
///
/// `command` ships `registry/components/command.json`, and
/// [dependencies] below mirrors that manifest's `registryDependencies`.
/// Those entries still line up with the real modules `command.dart` imports
/// from `lib/src/components/`: `icon.dart`, `icon_paths.dart`,
/// `icon_paths.g.dart`, `input.dart`, and `input_group.dart`, plus the
/// shared `source-foundation` item. `field`, `popover`, and `select` were
/// on the old combined list only because **combobox** imports them, and they
/// are gone from here for that reason. `page.dart`'s Installation section
/// now documents both the published package path and `elattar add command`.
library;

import '../catalog.dart';

const ComponentDocEntry commandDoc = ComponentDocEntry(
  name: 'command',
  title: 'Command',
  description:
      'An inline, always-open action launcher: one search field over '
      'grouped rows that a ported cmdk scorer both filters and re-ranks on '
      'every keystroke.',
  // What lib/src/components/command.dart actually imports from
  // lib/src/components/: real source-level dependencies, not a registry
  // dependency list. See the library note above for why.
  dependencies: <String>['icon', 'input', 'input-group', 'source-foundation'],
  exports: <String>[
    'ElCommand',
    'ElCommandItem',
    'ElCommandGroup',
    'elCommandScore',
  ],
  sourcePath: 'lib/src/components/command.dart',
);
