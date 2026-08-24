/// Documentation metadata for `hover_card`.
///
/// No `registry/components/hover-card.json` manifest yet: unregistered.
/// [dependencies] is left empty; the page states in prose that this
/// component composes [elPopoverPlacement] and [ElPopoverSurface], not
/// [ElPopover] itself (a hover-opened surface cannot use ElPopover's
/// full-screen dismiss barrier).
///
/// Split out of the former merged `navigation_menu` page (Phase F/J): that
/// page covered `navigation_menu`, `menubar`, `context_menu`, and
/// `hover_card` in one file. This entry lists only what `ElHoverCard` and
/// `ElHoverCardContent` actually export.
library;

import '../catalog.dart';

const ComponentDocEntry hoverCardDoc = ComponentDocEntry(
  name: 'hover-card',
  title: 'Hover Card',
  description:
      'A richer preview that opens on pointer entry and closes on exit, for '
      'pointer users only: not available on touch.',
  dependencies: <String>['popover', 'source-foundation'],
  exports: <String>['ElHoverCard', 'ElHoverCardContent'],
  sourcePath: 'lib/src/components/hover_card.dart',
);
