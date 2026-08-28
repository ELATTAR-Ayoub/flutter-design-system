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
/// choose between, it is the engine [DropdownMenu] (and, elsewhere, a
/// context menu and a menubar) mount identically. `sourcePath` names
/// `dropdown_menu.dart`, the one root this worker was assigned; `menu.dart`'s
/// own path is [menuSourcePath], a second top-level constant, for the same
/// reason [ComponentDocEntry] has only one `sourcePath` field.
library;

import '../catalog.dart';

/// `lib/src/components/menu.dart`: the shared row model, geometry, surface
/// and keyboard behaviour [DropdownMenu] is built from. Read directly
/// wherever the page cites the second source file [ComponentDocEntry] has no
/// room for.
const String menuSourcePath = 'lib/src/components/menu.dart';

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
  dependencies: <String>['button', 'menu', 'popover', 'source-foundation'],
  exports: <String>[
    // dropdown_menu.dart's own public surface.
    'DropdownMenu',
    'MenuTriggerScope',
    // menu.dart's row model.
    'MenuChild',
    'MenuItemVariant',
    'MenuItem',
    'MenuCheckboxItem',
    'MenuRadioItem',
    'MenuRadioGroup',
    'MenuLabel',
    'MenuSeparator',
    'MenuGroup',
    'MenuSub',
    // menu.dart's geometry and surface.
    'MenuIndicatorSide',
    'Menu',
    'MenuSurfaceVariant',
    'MenuSurface',
    // menu.dart's open content and shared motion/gesture primitives.
    'MenuContent',
    'MenuPointerDown',
    'MenuMotion',
  ],
  sourcePath: 'lib/src/components/dropdown_menu.dart',
);
