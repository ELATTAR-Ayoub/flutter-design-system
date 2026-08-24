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
///    reader looking up `ElSidebarMenuSubButton` has no other page to find
///    it on.
///
///  * **It ships through the registry.** `elattar add sidebar` installs the
///    family and its dependency closure.
///
/// [dependencies] is therefore **source-level imports**, not a verified
/// `registryDependencies` list: the component files those two libraries
/// actually import from `lib/src/components/`. Inventing registry names here
/// is the exact failure mode the Phase J plan warns about, so none are
/// invented.
library;

import '../catalog.dart';

const ComponentDocEntry sidebarDoc = ComponentDocEntry(
  name: 'sidebar',
  title: 'Sidebar',
  description:
      'An app-shell navigation panel that collapses to an icon rail, slides '
      'off canvas, or becomes a sheet on mobile.',
  // Registry dependencies resolved by `elattar add sidebar`.
  dependencies: <String>[
    'badge',
    'button',
    'collapsible',
    'icon',
    'icon-swap',
    'input',
    'keyframes',
    'machine-surface',
    'sheet',
    'skeleton',
    'source-foundation',
    'tooltip',
  ],
  exports: <String>[
    // Enums.
    'ElSidebarSide',
    'ElSidebarVariant',
    'ElSidebarCollapsible',
    'ElSidebarMenuButtonSize',
    'ElSidebarMenuSubButtonSize',
    // Scopes.
    'ElSidebarScope',
    'ElSidebarChrome',
    // Shell.
    'ElSidebarProvider',
    'ElSidebar',
    'ElSidebarRail',
    'ElSidebarTrigger',
    'ElSidebarInset',
    // Regions.
    'ElSidebarHeader',
    'ElSidebarFooter',
    'ElSidebarContent',
    'ElSidebarSeparator',
    'ElSidebarGroup',
    'ElSidebarGroupContent',
    'ElSidebarGroupLabel',
    'ElSidebarGroupAction',
    'ElSidebarCollapsibleGroup',
    // Menu.
    'ElSidebarMenu',
    'ElSidebarMenuItem',
    'ElSidebarMenuButton',
    'ElSidebarMenuRow',
    'ElSidebarMenuLabel',
    'ElSidebarMenuAction',
    'ElSidebarMenuBadge',
    'ElSidebarMenuSkeleton',
    'ElSidebarMenuSub',
    'ElSidebarMenuSubItem',
    'ElSidebarMenuSubButton',
    'ElSidebarInput',
    // nav_user.dart: the same family, a second file.
    'ElNavUser',
    'ElNavUserAccount',
    'ElNavUserItem',
  ],
  sourcePath: 'lib/src/components/sidebar.dart',
);

/// The family's second source file. [ComponentDocEntry] carries one
/// [ComponentDocEntry.sourcePath], and the account block in a sidebar footer
/// lives in its own library.
const String sidebarNavUserSourcePath = 'lib/src/components/nav_user.dart';
