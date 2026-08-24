/// Documentation metadata for `menubar`.
///
/// No `registry/components/menubar.json` manifest yet: unregistered.
/// [dependencies] is left empty; the page states in prose that this
/// component builds on [ElPopover] and shares its row model
/// ([ElMenuChild]) with `context_menu`.
///
/// Split out of the former merged `navigation_menu` page (Phase F/J): that
/// page covered `navigation_menu`, `menubar`, `context_menu`, and
/// `hover_card` in one file. This entry lists only what `ElMenubar` and
/// `ElMenubarMenu` actually export.
library;

import '../catalog.dart';

const ComponentDocEntry menubarDoc = ComponentDocEntry(
  name: 'menubar',
  title: 'Menubar',
  description:
      'A strip of triggers that hand one open menu between them, built on '
      'ElPopover: File/Edit/View style application chrome.',
  dependencies: <String>['menu', 'popover', 'source-foundation'],
  exports: <String>['ElMenubar', 'ElMenubarMenu'],
  sourcePath: 'lib/src/components/menubar.dart',
);
