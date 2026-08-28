/// Documentation metadata for `context_menu`.
///
/// Install with `elattar add context-menu`; the shipped manifest lives at
/// `registry/components/context-menu.json`.
/// [dependencies] mirrors that manifest's `registryDependencies`; the page
/// still explains that this component builds on [Popover] and shares its
/// row model ([MenuChild]) with `menubar`.
///
/// Split out of the former merged `navigation_menu` page (Phase F/J): that
/// page covered `navigation_menu`, `menubar`, `context_menu`, and
/// `hover_card` in one file. This entry lists only what `ContextMenu`
/// actually exports.
library;

import '../catalog.dart';

const ComponentDocEntry contextMenuDoc = ComponentDocEntry(
  name: 'context-menu',
  title: 'Context Menu',
  description:
      'A menu that opens on right-click, anchored to the pointer, built on '
      'Popover: for secondary actions on an element.',
  dependencies: <String>['menu', 'popover', 'source-foundation'],
  exports: <String>['ContextMenu'],
  sourcePath: 'lib/src/components/context_menu.dart',
);
