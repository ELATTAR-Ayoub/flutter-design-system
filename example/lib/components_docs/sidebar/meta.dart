/// Public documentation metadata for the sidebar component **family**.
///
/// [ComponentDocEntry] itself is defined in `catalog.dart`, which this file
/// only imports: the catalog's aggregate `componentDocs` list is
/// supervisor-owned and does not carry this entry yet, so `page.dart` reads
/// [sidebarDoc] directly rather than looking it up through the catalog.
///
/// Two things about this entry are unlike its Wave 1 siblings:
///
///  * **It is a family, not a component.** `lib/src/components/sidebar.dart`
///    exports thirty-three public names: a provider, two inherited scopes,
///    the panel, a rail, a trigger, an inset, five regions, three group
///    parts, twelve menu parts and a field: and
///    `lib/src/components/nav_user.dart` adds three more that only ever
///    appear inside a sidebar footer. [exports] lists all of them, because a
///    reader looking up `DsSidebarMenuSubButton` has no other page to find
///    it on.
///  * **There is no registry manifest.** `registry/components/` holds twelve
///    items and `sidebar.json` is not one of them, so `elattar add sidebar`
///    does not work. [ComponentDocEntry.command] still composes that string
///    from [name]: the getter is supervisor-owned and shared by every entry
///   : so `page.dart` deliberately never renders it, and says why instead.
///
/// [dependencies] is therefore **source-level imports**, not a verified
/// `registryDependencies` list: the component files those two libraries
/// actually import from `lib/src/components/`. Inventing registry names here
/// is the exact failure mode the Phase J plan warns about, so none are
/// invented.
library;

import '../catalog.dart';

/// IA §9.2's *expanded* description: not what a sidebar is, but when to
/// reach for one instead of the two neighbours it is genuinely confused
/// with: a navigation menu and a drawer/sheet.
const String sidebarExpandedDescription =
    'Reach for a sidebar when navigation is the persistent frame of the '
    'screen rather than something the screen contains: a panel pinned to '
    'one edge for the whole session, holding the app-level destinations, '
    'and collapsing to a 48px icon rail when the work needs the room. '
    'Reach for a navigation menu instead when the links belong to a page '
    'header: a horizontal bar whose panels open on hover and close again, '
    'owning no layout of their own. Reach for a drawer or a sheet instead '
    'when the panel is summoned for one task and dismissed: a sheet has a '
    'scrim, takes focus, and is closed by Escape, while a sidebar has no '
    'scrim, never traps focus, and its collapsed state is a destination '
    'rather than a dismissal. Below 768px the sidebar stops arguing and '
    'becomes a sheet itself: which is the clearest statement of the '
    'difference between them.';

const ComponentDocEntry sidebarDoc = ComponentDocEntry(
  name: 'sidebar',
  title: 'Sidebar',
  description:
      'An app-shell navigation panel that collapses to an icon rail, slides '
      'off canvas, or becomes a sheet on mobile.',
  // What lib/src/components/sidebar.dart and lib/src/components/nav_user.dart
  // import from lib/src/components/: real source-level dependencies, not a
  // registry dependency list. Sidebar has no manifest (see the Installation
  // section on the page), so these are documented as files to copy rather
  // than as CLI-resolvable items.
  dependencies: <String>[
    'badge',
    'button',
    'collapsible',
    'icon',
    'icon_swap',
    'input',
    'sheet',
    'skeleton',
    'tooltip',
    'avatar',
    'dropdown_menu',
    'menu',
    'popover',
  ],
  exports: <String>[
    // Enums.
    'DsSidebarSide',
    'DsSidebarVariant',
    'DsSidebarCollapsible',
    'DsSidebarMenuButtonSize',
    'DsSidebarMenuSubButtonSize',
    // Scopes.
    'DsSidebarScope',
    'DsSidebarChrome',
    // Shell.
    'DsSidebarProvider',
    'DsSidebar',
    'DsSidebarRail',
    'DsSidebarTrigger',
    'DsSidebarInset',
    // Regions.
    'DsSidebarHeader',
    'DsSidebarFooter',
    'DsSidebarContent',
    'DsSidebarSeparator',
    'DsSidebarGroup',
    'DsSidebarGroupContent',
    'DsSidebarGroupLabel',
    'DsSidebarGroupAction',
    'DsSidebarCollapsibleGroup',
    // Menu.
    'DsSidebarMenu',
    'DsSidebarMenuItem',
    'DsSidebarMenuButton',
    'DsSidebarMenuRow',
    'DsSidebarMenuLabel',
    'DsSidebarMenuAction',
    'DsSidebarMenuBadge',
    'DsSidebarMenuSkeleton',
    'DsSidebarMenuSub',
    'DsSidebarMenuSubItem',
    'DsSidebarMenuSubButton',
    'DsSidebarInput',
    // nav_user.dart: the same family, a second file.
    'DsNavUser',
    'DsNavUserAccount',
    'DsNavUserItem',
  ],
  sourcePath: 'lib/src/components/sidebar.dart',
);

/// The family's second source file. [ComponentDocEntry] carries one
/// [ComponentDocEntry.sourcePath], and the account block in a sidebar footer
/// lives in its own library.
const String sidebarNavUserSourcePath = 'lib/src/components/nav_user.dart';
