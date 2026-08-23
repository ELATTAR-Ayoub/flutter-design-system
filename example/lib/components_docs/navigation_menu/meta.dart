/// Documentation metadata for navigation_menu, menubar, context_menu, and
/// hover_card.
///
/// None of these four components has a `registry/components/*.json` manifest
/// yet: they are unregistered. [dependencies] is left empty; the page states
/// in prose that all four build on [DsPopover].
library;

import '../catalog.dart';

/// Comparison text: which overlay to use for what.
const String navigationMenuExpandedDescription =
    'These four components are all anchored overlays: panels that attach to a '
    'trigger and open near it. DsPopover is their shared positioning engine, '
    'and all four reuse its placement math, animation, and barrier behavior. '
    'Reach for Navigation Menu when a section needs more than a link: a set of '
    'destinations with descriptions, or sublinks grouped under section headers. '
    'Reach for Menubar when an admin surface needs a traditional menu strip, '
    'a row of triggers that hand an open menu between them on hover. Reach for '
    'Context Menu when an action needs a right-click menu. Reach for Hover Card '
    'when a pointer needs to stop and learn more: a preview that opens on hover '
    'and closes when the pointer leaves, and is hidden entirely on touch. All '
    'four are pointer overlays; none has a touch path equivalent except the '
    'hover card, which has none at all: a hover card is a pointer affordance '
    'and invisible on a phone.';

const ComponentDocEntry navigationMenuDoc = ComponentDocEntry(
  name: 'navigation-menu',
  title: 'Navigation Menu, Menubar, Context Menu, Hover Card',
  description:
      'Four anchored overlays built on DsPopover: a navigation bar with '
      'panels, a menu strip, a right-click menu, and a hover preview.',
  dependencies: <String>[],
  exports: <String>[
    'DsNavigationMenu',
    'DsNavigationMenuItem',
    'DsNavigationMenuIndicator',
    'DsNavigationMenuLink',
    'DsMenubar',
    'DsMenubarMenu',
    'DsContextMenu',
    'DsHoverCard',
    'DsHoverCardContent',
  ],
  sourcePath: 'lib/src/components/',
);
