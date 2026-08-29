/// Documentation metadata for `hover_card`.
///
/// `registry/components/hover-card.json` is a real manifest — `files`,
/// `registryDependencies: [popover, source-foundation]`, a
/// `documentationRoute` — and `elattar add hover-card` installs from it
/// today. [dependencies] is that manifest's own `registryDependencies`
/// list, verbatim. The page's own Composition section states in prose that
/// this component composes [popoverPlacement] and [PopoverSurface],
/// not [Popover] itself (a hover-opened surface cannot use Popover's
/// full-screen dismiss barrier).
///
/// Split out of the former merged `navigation_menu` page (Phase F/J): that
/// page covered `navigation_menu`, `menubar`, `context_menu`, and
/// `hover_card` in one file. This entry lists only what `HoverCard` and
/// `HoverCardContent` actually export.
library;

import '../catalog.dart';

const ComponentDocEntry hoverCardDoc = ComponentDocEntry(
  name: 'hover-card',
  title: 'Hover Card',
  description:
      'A richer preview that opens on pointer entry and closes on exit, for '
      'pointer users only: not available on touch.',
  dependencies: <String>['popover', 'source-foundation'],
  exports: <String>['HoverCard', 'HoverCardContent'],
  sourcePath: 'lib/src/components/ui/hover_card.dart',
);
