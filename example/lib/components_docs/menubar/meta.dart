/// Documentation metadata for `menubar`.
///
/// **Corrected.** This file used to claim no `registry/components/
/// menubar.json` manifest existed and that [dependencies] was left empty.
/// Both are stale: `registry/components/menubar.json` is a real, shipped
/// manifest today, `registry/generated/latest/registry.json` carries
/// `menubar`, and `elattar add menubar` is a genuine, working command.
/// [dependencies] below already matches the manifest's own
/// `registryDependencies` list, verbatim: `menu`, `popover`, and
/// `source-foundation` — the shared row model ([ElMenuChild]) `menubar`
/// builds on, and the [ElPopover] positioner it shares with
/// `context_menu`.
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
