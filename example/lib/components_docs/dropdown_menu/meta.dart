/// Public documentation metadata for the dropdown-menu component and the
/// shared menu engine it is built from.
///
/// [ComponentDocEntry] itself is defined in `catalog.dart`, which this file
/// only imports: the catalog's aggregate `componentDocs` list is
/// supervisor-owned and does not carry this entry yet, so `page.dart` reads
/// [dropdownMenuDoc] directly rather than looking it up through
/// `componentDoc('dropdown-menu')`.
///
/// One [ComponentDocEntry], not two, for the reason `toggle/meta.dart`
/// already established for its own paired file: `lib/src/components/
/// menu.dart`'s own library doc states that its "row model, the surface, the
/// geometry, the keyboard" is the shared body of `dropdown-menu.tsx`,
/// `context-menu.tsx` and `menubar.tsx`: it is not a component of its own to
/// choose between, it is the engine [DsDropdownMenu] (and, elsewhere, a
/// context menu and a menubar) mount identically. `sourcePath` names
/// `dropdown_menu.dart`, the one root this worker was assigned; `menu.dart`'s
/// own path is [menuSourcePath], a second top-level constant, for the same
/// reason [ComponentDocEntry] has only one `sourcePath` field.
library;

import '../catalog.dart';

/// `lib/src/components/menu.dart`: the shared row model, geometry, surface
/// and keyboard behaviour [DsDropdownMenu] is built from. Read directly
/// wherever the page cites the second source file [ComponentDocEntry] has no
/// room for.
const String menuSourcePath = 'lib/src/components/menu.dart';

/// IA §9.2's *expanded* description: not what a dropdown menu is, but when to
/// reach for one instead of its three closest neighbours, [DsSelect],
/// context menu, and [DsPopover]: plus what `menu.dart` actually is (an
/// engine, not a second choice).
const String dropdownMenuExpandedDescription =
    'Reach for a dropdown menu when a trigger button opens a list of '
    'COMMANDS to run, Profile, Billing, Log out: and choosing one fires '
    'an action immediately; the menu closes and nothing on screen becomes '
    'a stored value. Reach for Select instead when the same-looking '
    'trigger is really opening a list to choose a VALUE that then '
    "replaces the trigger's own label and travels with a form. Reach for "
    'Context Menu instead when the identical row list should open at the '
    'pointer on a right-click (or long-press) rather than beneath a '
    'button: a different opener over the same DsMenuContent row engine, '
    'not a different menu. Reach for Popover instead when what needs to '
    'open is not a list of committable rows at all but arbitrary '
    'interactive content: a form, a rich preview, a custom widget tree, '
    'because DsPopover is what DsDropdownMenu, and every submenu in this '
    'family, is already built out of underneath; content that does not '
    'fit a DsMenuChild row belongs directly in a DsPopover rather than '
    'forced into one. menu.dart itself is not a second component to pick '
    'between DsDropdownMenu and: it is the shared row model, geometry, '
    'surface and keyboard behaviour that a dropdown menu, a context menu '
    'and a menubar all mount identically, and this page documents that '
    'shared engine in full alongside the one root, DsDropdownMenu: this '
    'wave assigns it to.';

const ComponentDocEntry dropdownMenuDoc = ComponentDocEntry(
  name: 'dropdown-menu',
  title: 'Dropdown Menu',
  description:
      'A trigger button that opens a list of commands, built from the same '
      'row engine a context menu and a menubar also mount.',
  // What lib/src/components/dropdown_menu.dart and lib/src/components/
  // menu.dart themselves import from lib/src/components/: real
  // source-level dependencies, not a verified registry dependency list.
  // Neither file has a registry manifest yet (see DocsInstallFacts on the
  // page), so these are documented as internal dependencies rather than
  // claimed as CLI-resolvable ones. `source-foundation` (spacing, theme,
  // motion, typography, shadows) is the implicit foundation dependency
  // every component in this list also carries and is named explicitly on
  // the page's own Installation section rather than repeated here.
  dependencies: <String>['button', 'popover', 'icon'],
  exports: <String>[
    // dropdown_menu.dart's own public surface.
    'DsDropdownMenu',
    'DsMenuTriggerScope',
    // menu.dart's row model.
    'DsMenuChild',
    'DsMenuItemVariant',
    'DsMenuItem',
    'DsMenuCheckboxItem',
    'DsMenuRadioItem',
    'DsMenuRadioGroup',
    'DsMenuLabel',
    'DsMenuSeparator',
    'DsMenuGroup',
    'DsMenuSub',
    // menu.dart's geometry and surface.
    'DsMenuIndicatorSide',
    'DsMenu',
    'DsMenuSurfaceKind',
    'DsMenuSurface',
    // menu.dart's open content and shared motion/gesture primitives.
    'DsMenuContent',
    'DsMenuPointerDown',
    'DsMenuMotion',
  ],
  sourcePath: 'lib/src/components/dropdown_menu.dart',
);
