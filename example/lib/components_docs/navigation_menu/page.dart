/// Public component documentation for navigation_menu, menubar, context_menu,
/// and hover_card.
///
/// These four anchored overlays are documented together because they all build
/// on [DsPopover] for their placement, animation, and barrier logic. One page,
/// reshaped to mirror all four of their shadcn counterparts section for
/// section: `https://ui.shadcn.com/docs/components/navigation-menu`,
/// `/menubar`, `/context-menu`, and `/hover-card`. Installation, Usage, and
/// Composition are each a single merged section (one shared story, four
/// sub-blocks); every body section that follows belongs to exactly one of the
/// four components and is named for it (`Menubar: Checkbox`, `Context Menu:
/// Groups`, and so on) so the reader always knows which component a section
/// is about. API Reference closes out the shadcn-mirrored part of the page,
/// one table per exported class across all four. States, Accessibility,
/// Responsive, Dependencies, Theming, and Source are this package's own six
/// sections, each covering all four components once rather than four times.
///
/// **Skipped from the counterparts**, and why:
///  - Navigation Menu's `Link Component` composes a Next.js `Link`; there is
///    no Flutter render-prop equivalent, so it is not built.
///  - Context Menu's `Sides` configures `side`/`align` on `ContextMenuContent`;
///    [DsContextMenu] hardcodes `side: DsPopoverSide.right, align:
///    DsPopoverAlign.start` and passes neither through, so there is nothing to
///    demonstrate.
///  - Hover Card's `Positioning` and `Sides` configure `side`/`align` on
///    `HoverCardContent`; [DsHoverCard] has no such parameters, placement is
///    fully automatic (collision-aware, via [dsPopoverPlacement]).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import '../catalog.dart';
import 'meta.dart';

class NavigationMenuDocPage extends StatelessWidget {
  const NavigationMenuDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = navigationMenuDoc;
    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: entry.title,
        description: navigationMenuExpandedDescription,
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Navigation Menu'),
      ],
      sidebar: _sidebar(entry.route),
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Navigation Menu: RTL', anchor: 'nav-menu-rtl'),
        DocsTocEntry(title: 'Menubar: Checkbox', anchor: 'menubar-checkbox'),
        DocsTocEntry(title: 'Menubar: Radio', anchor: 'menubar-radio'),
        DocsTocEntry(title: 'Menubar: Submenu', anchor: 'menubar-submenu'),
        DocsTocEntry(title: 'Menubar: With icons', anchor: 'menubar-icons'),
        DocsTocEntry(title: 'Menubar: RTL', anchor: 'menubar-rtl'),
        DocsTocEntry(
          title: 'Context Menu: Basic',
          anchor: 'context-menu-basic',
        ),
        DocsTocEntry(
          title: 'Context Menu: Submenu',
          anchor: 'context-menu-submenu',
        ),
        DocsTocEntry(
          title: 'Context Menu: Shortcuts',
          anchor: 'context-menu-shortcuts',
        ),
        DocsTocEntry(
          title: 'Context Menu: Groups',
          anchor: 'context-menu-groups',
        ),
        DocsTocEntry(
          title: 'Context Menu: Icons',
          anchor: 'context-menu-icons',
        ),
        DocsTocEntry(
          title: 'Context Menu: Checkboxes',
          anchor: 'context-menu-checkboxes',
        ),
        DocsTocEntry(
          title: 'Context Menu: Radio',
          anchor: 'context-menu-radio',
        ),
        DocsTocEntry(
          title: 'Context Menu: Destructive',
          anchor: 'context-menu-destructive',
        ),
        DocsTocEntry(title: 'Context Menu: RTL', anchor: 'context-menu-rtl'),
        DocsTocEntry(
          title: 'Hover Card: Trigger delays',
          anchor: 'hover-card-delays',
        ),
        DocsTocEntry(title: 'Hover Card: Basic', anchor: 'hover-card-basic'),
        DocsTocEntry(title: 'Hover Card: RTL', anchor: 'hover-card-rtl'),
        DocsTocEntry(title: 'API Reference', anchor: 'api'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      previous: const DocsPageLink(
        title: 'Popover',
        route: '/components/popover',
      ),
      onNavigate: onNavigate,
      child: _Article(entry: entry),
    );
  }
}

List<DocsSidebarEntry> _sidebar(String route) => <DocsSidebarEntry>[
  const DocsSidebarEntry(title: 'Button', route: '/components/button'),
  const DocsSidebarEntry(title: 'Card', route: '/components/card'),
  const DocsSidebarEntry(title: 'Input', route: '/components/input'),
  const DocsSidebarEntry(title: 'Dialog', route: '/components/dialog'),
  const DocsSidebarEntry(title: 'Select', route: '/components/select'),
  const DocsSidebarEntry(title: 'Popover', route: '/components/popover'),
  DocsSidebarEntry(title: 'Navigation Menu', route: route, selected: true),
];

class _Article extends StatelessWidget {
  const _Article({required this.entry});

  final ComponentDocEntry entry;

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('navigation-menu-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      // Unheaded, ahead of the first heading, exactly as shadcn puts its own
      // live demo above `Installation`.
      DocsCodeExample(
        title: 'All four specimens',
        description:
            'Navigation Menu: hover or tap to open panels. Menubar: click or '
            'hover to cycle menus. Context Menu: right-click the card. Hover '
            'Card: move your pointer over the text (not on touch).',
        preview: const _AllFourPreview(),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'install',
        title: 'Installation',
        description:
            'All four components are in the main package but have no registry '
            'manifest yet, `elattar add navigation-menu` does not work. Import '
            'from the barrel and copy the source files manually.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DocsCodeExample(
              title: 'Manual installation',
              manualFiles: const <DocsCodeFile>[
                DocsCodeFile(
                  path: 'lib/components/ui/navigation_menu.dart',
                  code:
                      "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                      '// Copy navigation-menu source from the package when needed.',
                ),
                DocsCodeFile(
                  path: 'lib/components/ui/menubar.dart',
                  code:
                      "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                      '// Copy menubar source from the package when needed.',
                ),
                DocsCodeFile(
                  path: 'lib/components/ui/context_menu.dart',
                  code:
                      "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                      '// Copy context-menu source from the package when needed.',
                ),
                DocsCodeFile(
                  path: 'lib/components/ui/hover_card.dart',
                  code:
                      "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                      '// Copy hover-card source from the package when needed.',
                ),
              ],
            ),
            SizedBox(height: ds(4)),
            const DocsInstallFacts(
              title: 'Status',
              facts: <DocsInstallFact>[
                DocsInstallFact(
                  label: 'Status',
                  value: 'Unregistered: source only',
                  description:
                      'DsNavigationMenu, DsMenubar, DsContextMenu, and DsHoverCard '
                      'are all exported from the public barrel but have no registry '
                      'manifest and cannot be installed through the CLI yet.',
                ),
                DocsInstallFact(
                  label: 'Version',
                  value: '0.0.1',
                  description: 'Committed alongside Popover in the same wave.',
                ),
                DocsInstallFact(
                  label: 'Dart / Flutter',
                  value: '>=3.12.2 <4.0.0 / >=3.12.2',
                  description: 'Same constraints as the port.',
                ),
                DocsInstallFact(
                  label: 'Platforms',
                  value: 'Android, iOS, Web, macOS, Windows, Linux',
                  description:
                      'Pure widget composition: nothing is platform-gated.',
                ),
              ],
            ),
          ],
        ),
      ),
      DsSection(
        id: 'usage',
        title: 'Usage',
        description:
            'Each component owns its own open state via setState or a '
            'controller. Navigation Menu and Menubar drive open through hover '
            'and click; Context Menu opens on right-click and anchors to the '
            'pointer; Hover Card opens and closes automatically on pointer entry '
            'and exit.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'DART',
              note: 'NAVIGATION MENU: with a shared viewport',
              child: DocsSelectableCodeBlock(code: _navMenuCode),
            ),
            SizedBox(height: ds(5)),
            DsPanel(
              label: 'DART',
              note: 'MENUBAR: a strip that hands the menu between triggers',
              child: DocsSelectableCodeBlock(code: _menubarCode),
            ),
            SizedBox(height: ds(5)),
            DsPanel(
              label: 'DART',
              note: 'CONTEXT MENU: right-click to open at the pointer',
              child: DocsSelectableCodeBlock(code: _contextMenuCode),
            ),
            SizedBox(height: ds(5)),
            DsPanel(
              label: 'DART',
              note: 'HOVER CARD: opens on pointer entry, closes on exit',
              child: DocsSelectableCodeBlock(code: _hoverCardCode),
            ),
          ],
        ),
      ),
      DsSection(
        id: 'composition',
        title: 'Composition',
        description:
            'What each constructor assembles internally, one tree per '
            'component. None of the four takes a caller-assembled tree of '
            'sub-widgets the way shadcn\'s NavigationMenuList / MenubarMenu / '
            'ContextMenuSub markup does: each one takes a flat list (items, '
            'menus, or children) and builds the tree below from it.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'Navigation Menu',
              child: DocsSelectableCodeBlock(code: _navMenuCompositionCode),
            ),
            SizedBox(height: ds(5)),
            DsPanel(
              label: 'Menubar',
              child: DocsSelectableCodeBlock(code: _menubarCompositionCode),
            ),
            SizedBox(height: ds(5)),
            DsPanel(
              label: 'Context Menu',
              child: DocsSelectableCodeBlock(code: _contextMenuCompositionCode),
            ),
            SizedBox(height: ds(5)),
            DsPanel(
              label: 'Hover Card',
              child: DocsSelectableCodeBlock(code: _hoverCardCompositionCode),
            ),
          ],
        ),
      ),
      DsSection(
        id: 'nav-menu-rtl',
        title: 'Navigation Menu: RTL',
        description:
            'The same trigger-and-panel composition read right-to-left under a '
            'Directionality. Nothing in DsNavigationMenu mirrors by hand: the '
            'chevron rotation and the panel anchoring both follow direction '
            'automatically.',
        child: const DocsCodeExample(
          title: 'Right-to-left navigation menu',
          preview: _NavMenuRtl(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(path: 'nav_menu_rtl.dart', code: _navMenuRtlCode),
          ],
        ),
      ),
      DsSection(
        id: 'menubar-checkbox',
        title: 'Menubar: Checkbox',
        description:
            'DsMenuCheckboxItem inside a DsMenubarMenu, for a toggleable '
            'option. checked is controlled: the caller owns the state and the '
            'row reports back through onSelect.',
        child: const DocsCodeExample(
          title: 'Checkbox rows',
          preview: _MenubarCheckbox(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'menubar_checkbox.dart',
              code: _menubarCheckboxCode,
            ),
          ],
        ),
      ),
      DsSection(
        id: 'menubar-radio',
        title: 'Menubar: Radio',
        description:
            'DsMenuRadioGroup and DsMenuRadioItem for a single-select group of '
            'rows. The group paints nothing: it exists so exactly one child row '
            'wears the tick.',
        child: const DocsCodeExample(
          title: 'Radio rows',
          preview: _MenubarRadio(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(path: 'menubar_radio.dart', code: _menubarRadioCode),
          ],
        ),
      ),
      DsSection(
        id: 'menubar-submenu',
        title: 'Menubar: Submenu',
        description:
            'DsMenuSub nests one level of rows behind a trigger row. Allowed '
            'one level deep by editorial convention, not by a depth check the '
            'source enforces.',
        child: const DocsCodeExample(
          title: 'Nested menu',
          preview: _MenubarSubmenu(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'menubar_submenu.dart',
              code: _menubarSubmenuCode,
            ),
          ],
        ),
      ),
      DsSection(
        id: 'menubar-icons',
        title: 'Menubar: With icons',
        description:
            'DsMenuItem.icon puts a 16px leading glyph on a row, forced to that '
            'size regardless of what DsIconSize the call site names.',
        child: const DocsCodeExample(
          title: 'Rows with leading icons',
          preview: _MenubarIcons(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(path: 'menubar_icons.dart', code: _menubarIconsCode),
          ],
        ),
      ),
      DsSection(
        id: 'menubar-rtl',
        title: 'Menubar: RTL',
        description:
            'The same strip read right-to-left. The one thing that does not '
            'mirror: menu drift 5, the menubar\'s check-row indicator sits on '
            'the row\'s start edge in both directions, because it is a drift in '
            'the reference\'s own class list, not a property of direction.',
        child: const DocsCodeExample(
          title: 'Right-to-left menubar',
          preview: _MenubarRtl(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(path: 'menubar_rtl.dart', code: _menubarRtlCode),
          ],
        ),
      ),
      DsSection(
        id: 'context-menu-basic',
        title: 'Context Menu: Basic',
        description:
            'The simplest right-click menu: two plain DsMenuItem rows, no '
            'checkboxes, radios, or submenus.',
        child: const DocsCodeExample(
          title: 'Basic context menu',
          preview: _ContextMenuBasic(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'context_menu_basic.dart',
              code: _contextMenuBasicCode,
            ),
          ],
        ),
      ),
      DsSection(
        id: 'context-menu-submenu',
        title: 'Context Menu: Submenu',
        description:
            'A DsMenuSub row opens a second content anchored to its own right '
            'edge, roughly 100ms after the pointer rests on it.',
        child: const DocsCodeExample(
          title: 'Nested actions',
          preview: _ContextMenuSubmenu(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'context_menu_submenu.dart',
              code: _contextMenuSubmenuCode,
            ),
          ],
        ),
      ),
      DsSection(
        id: 'context-menu-shortcuts',
        title: 'Context Menu: Shortcuts',
        description:
            'DsMenuItem.shortcut right-aligns a key hint. It is display only: '
            'the source does not wire the shortcut to a real key handler.',
        child: const DocsCodeExample(
          title: 'Rows with shortcuts',
          preview: _ContextMenuShortcuts(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'context_menu_shortcuts.dart',
              code: _contextMenuShortcutsCode,
            ),
          ],
        ),
      ),
      DsSection(
        id: 'context-menu-groups',
        title: 'Context Menu: Groups',
        description:
            'DsMenuGroup paints nothing: its rows sit flush with their '
            'neighbours. It exists to mark related actions and to give a '
            'future accessible label something to hang off.',
        child: const DocsCodeExample(
          title: 'Grouped actions',
          preview: _ContextMenuGroups(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'context_menu_groups.dart',
              code: _contextMenuGroupsCode,
            ),
          ],
        ),
      ),
      DsSection(
        id: 'context-menu-icons',
        title: 'Context Menu: Icons',
        description:
            'The same DsMenuItem.icon slot Menubar uses: a leading glyph for '
            'faster visual scanning.',
        child: const DocsCodeExample(
          title: 'Rows with icons',
          preview: _ContextMenuIcons(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'context_menu_icons.dart',
              code: _contextMenuIconsCode,
            ),
          ],
        ),
      ),
      DsSection(
        id: 'context-menu-checkboxes',
        title: 'Context Menu: Checkboxes',
        description:
            'DsMenuCheckboxItem for a toggleable option, right-click style. '
            'Same indicator side as a dropdown menu: the right edge, not '
            'Menubar\'s left.',
        child: const DocsCodeExample(
          title: 'Checkbox rows',
          preview: _ContextMenuCheckboxes(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'context_menu_checkboxes.dart',
              code: _contextMenuCheckboxesCode,
            ),
          ],
        ),
      ),
      DsSection(
        id: 'context-menu-radio',
        title: 'Context Menu: Radio',
        description:
            'DsMenuRadioGroup for a mutually exclusive choice, right-click '
            'style.',
        child: const DocsCodeExample(
          title: 'Radio rows',
          preview: _ContextMenuRadio(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'context_menu_radio.dart',
              code: _contextMenuRadioCode,
            ),
          ],
        ),
      ),
      DsSection(
        id: 'context-menu-destructive',
        title: 'Context Menu: Destructive',
        description:
            'DsMenuItemVariant.destructive tints a row\'s ink and, once '
            'highlighted, its fill: 10% of theme.destructive in light, 20% in '
            'dark. The same specimen shown at the top of this page.',
        child: const DocsCodeExample(
          title: 'Destructive action',
          preview: _ContextMenuSpecimen(
            specimenKey: 'context-menu-destructive-specimen',
          ),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'context_menu_destructive.dart',
              code: _contextMenuCode,
            ),
          ],
        ),
      ),
      DsSection(
        id: 'context-menu-rtl',
        title: 'Context Menu: RTL',
        description:
            'The right-click position itself does not mirror: DsContextMenu '
            'anchors to the pointer\'s literal client coordinates, which have no '
            'reading direction. Only the menu content reads right-to-left.',
        child: const DocsCodeExample(
          title: 'Right-to-left context menu',
          preview: _ContextMenuRtl(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'context_menu_rtl.dart',
              code: _contextMenuRtlCode,
            ),
          ],
        ),
      ),
      DsSection(
        id: 'hover-card-delays',
        title: 'Hover Card: Trigger delays',
        description:
            'openDelay (default 700ms, Radix\'s own default) is how long the '
            'pointer must rest on the trigger before the card opens. '
            'closeDelay (default 300ms) is the window in which the pointer can '
            'cross the gap into the card itself before it closes. Both are '
            'named constructor parameters; see API Reference below for the '
            'full signature.',
        child: const DocsCodeExample(
          title: 'Default delays',
          preview: _HoverCardSpecimen(
            specimenKey: 'hover-card-delays-specimen',
          ),
        ),
      ),
      DsSection(
        id: 'hover-card-basic',
        title: 'Hover Card: Basic',
        description:
            'The same specimen shown at the top of this page: hover the '
            'trigger text to see the preview.',
        child: const DocsCodeExample(
          title: 'Basic hover card',
          preview: _HoverCardSpecimen(specimenKey: 'hover-card-basic-specimen'),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(path: 'hover_card_basic.dart', code: _hoverCardCode),
          ],
        ),
      ),
      DsSection(
        id: 'hover-card-rtl',
        title: 'Hover Card: RTL',
        description:
            'The card\'s content reads right-to-left. Placement is unaffected: '
            'DsHoverCard positions from the trigger\'s own box, which '
            'Directionality does not move.',
        child: const DocsCodeExample(
          title: 'Right-to-left hover card',
          preview: _HoverCardRtl(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(path: 'hover_card_rtl.dart', code: _hoverCardRtlCode),
          ],
        ),
      ),
      DsSection(
        id: 'api',
        title: 'API Reference',
        description:
            'Every public class, enum, and constructor parameter the source '
            'declares. All four components build on DsPopover.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DocsApiTable(
              title: 'DsNavigationMenu',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'items',
                  type: 'List<DsNavigationMenuItem>',
                  description:
                      'Required. Trigger items with panels, and link items '
                      'without panels.',
                ),
                DocsApiFact(
                  name: 'viewport',
                  type: 'bool',
                  description:
                      'Default true. One shared panel that resizes between '
                      'triggers, or each item owns its own panel.',
                ),
                DocsApiFact(
                  name: 'indicator',
                  type: 'bool',
                  description:
                      'Default false. Whether to show the caret that points to '
                      'the open trigger (note: it does not point correctly due '
                      'to a Radix offset bug).',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsNavigationMenuItem',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'DsNavigationMenuItem.trigger()',
                  type: 'constructor',
                  description:
                      'A trigger that opens a panel of content: requires '
                      'label and content.',
                ),
                DocsApiFact(
                  name: 'DsNavigationMenuItem.link()',
                  type: 'constructor',
                  description:
                      'A plain destination link, no panel: requires label, '
                      'optional onTap.',
                ),
                DocsApiFact(
                  name: 'label',
                  type: 'String',
                  description: 'The trigger or link text.',
                ),
                DocsApiFact(
                  name: 'content',
                  type: 'Widget?',
                  description:
                      'The panel body for a trigger: the ul of rows. Null for '
                      'a link.',
                ),
                DocsApiFact(
                  name: 'onTap',
                  type: 'VoidCallback?',
                  description: 'Called when a link item is tapped.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsNavigationMenuLink',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'child',
                  type: 'Widget',
                  description:
                      'Required. The row content: icon-and-label or '
                      'title-and-blurb.',
                ),
                DocsApiFact(
                  name: 'active',
                  type: 'bool',
                  description:
                      'Default false. Marks the current destination, '
                      'sets the background to accent.',
                ),
                DocsApiFact(
                  name: 'onTap',
                  type: 'VoidCallback?',
                  description: 'Called when the row is tapped.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsMenubar',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'menus',
                  type: 'List<DsMenubarMenu>',
                  description:
                      'Required. The triggers and their menu rows: a strip of '
                      'menu openers.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsMenubarMenu',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'label',
                  type: 'String',
                  description: 'The trigger text.',
                ),
                DocsApiFact(
                  name: 'children',
                  type: 'List<DsMenuChild>',
                  description:
                      'The menu rows: items, labels, separators, submenus. '
                      'Managed by DsMenu.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsContextMenu',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'child',
                  type: 'Widget',
                  description:
                      'Required. The trigger: right-click it to open the menu '
                      'at the pointer.',
                ),
                DocsApiFact(
                  name: 'children',
                  type: 'List<DsMenuChild>',
                  description:
                      'The menu rows: items, labels, separators, submenus. '
                      'Managed by DsMenu.',
                ),
                DocsApiFact(
                  name: 'width',
                  type: 'double?',
                  description:
                      'Optional width constraint for the menu. Default is no '
                      'constraint.',
                ),
                DocsApiFact(
                  name: 'enabled',
                  type: 'bool',
                  description:
                      'Default true. Whether right-click opens the menu.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsHoverCard',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'trigger',
                  type: 'Widget',
                  description:
                      'Required. The target: pointer entry opens the card.',
                ),
                DocsApiFact(
                  name: 'content',
                  type: 'Widget',
                  description:
                      'Required. The preview content: laid out inside '
                      'DsHoverCardContent.',
                ),
                DocsApiFact(
                  name: 'width',
                  type: 'double?',
                  description:
                      'Optional width. Default is 288 (w-72). Null takes the '
                      'default.',
                ),
                DocsApiFact(
                  name: 'openDelay',
                  type: 'Duration',
                  description:
                      'Default 700ms (Radix HoverCard openDelay). How long the '
                      'pointer must rest before the card opens.',
                ),
                DocsApiFact(
                  name: 'closeDelay',
                  type: 'Duration',
                  description:
                      'Default 300ms. How long the card stays open after the '
                      'pointer leaves: the gap-crossing window.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsHoverCardContent',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'child',
                  type: 'Widget',
                  description:
                      'Required. The preview content: laid out inside '
                      'p-2.5 padding.',
                ),
              ],
            ),
          ],
        ),
      ),
      DsSection(
        id: 'states',
        title: 'States',
        description:
            'All four are state machines: open or closed. The row model '
            '(DsMenuChild and its variants) carries item states inside them.',
        child: const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Rest',
              treatment:
                  'Closed: the trigger is visible, the panel or menu is not '
                  'mounted.',
              userSignal:
                  'Navigation Menu: trigger shows muted text. Menubar: trigger '
                  'shows text, no fill. Context Menu: child is visible. Hover '
                  'Card: trigger only, no card.',
            ),
            DocsStateFact(
              state: 'Hover',
              treatment:
                  'Navigation Menu: trigger lightens and the panel stays closed '
                  'until the open delay fires (200ms). Menubar: trigger fills '
                  'with muted and opens the menu at once (no delay). Context '
                  'Menu: not applicable (right-click only). Hover Card: starts '
                  'the open delay (700ms).',
              userSignal:
                  'Navigation Menu: trigger changes fill and text color. '
                  'Menubar: trigger fills, menu animates in. Hover Card: '
                  'nothing visible until the delay fires.',
            ),
            DocsStateFact(
              state: 'Open',
              treatment:
                  'Panel or menu is mounted and visible. All four animate in '
                  'from opacity 0, scale 0.95, and a slide. All four close on '
                  'Escape (where there is focus), or by leaving.',
              userSignal:
                  'Navigation Menu: panel appears with zoom and fade. Menubar: '
                  'menu animates in (no exit animation). Context Menu: menu at '
                  'the pointer. Hover Card: card fades and zooms in from top.',
            ),
            DocsStateFact(
              state: 'Focus-visible',
              treatment:
                  'Navigation Menu: focus goes to panel rows; Escape closes. '
                  'Menubar: arrow keys step through menus; Escape closes. '
                  'Context Menu: focus goes to menu rows; Escape closes. Hover '
                  'Card: cannot receive focus: hover only.',
              userSignal:
                  'Keyboard navigation works for the menu families. Context '
                  'Menu: typeahead searches the rows.',
            ),
            DocsStateFact(
              state: 'Pressed',
              treatment:
                  'Navigation Menu / Menubar: trigger stays lit while the '
                  'panel/menu is open. Nothing transitions. Context Menu: '
                  'child shows whatever press state it defines.',
              userSignal: 'Snap: no transition. The fill appears instantly.',
            ),
            DocsStateFact(
              state: 'Disabled',
              treatment:
                  'All four: the caller is responsible for disabling. '
                  'Navigation Menu / Menubar do not carry enabled/disabled '
                  'parameters. Context Menu has enabled (default true). Hover '
                  'Card has no disable path.',
              userSignal:
                  'N/A: disabling is per-item in the menu family, and '
                  'context of the trigger in Navigation Menu and Menubar.',
            ),
            DocsStateFact(
              state: 'Reduced motion',
              treatment:
                  'All four: the fade/zoom/slide transition runs through '
                  'dsAnimationDuration, so it collapses to zero under reduced '
                  'motion.',
              userSignal:
                  'The panel or menu appears and disappears instantly, '
                  'without animated travel.',
            ),
            DocsStateFact(
              state: 'Touch',
              treatment:
                  'Navigation Menu: tap to open, tap again to close (skip '
                  'window applies). Menubar: tap to toggle (no multi-trigger '
                  'handoff on touch). Context Menu: no touch path (right-click '
                  'only). Hover Card: no touch path (hover-only).',
              userSignal:
                  'Navigation Menu / Menubar: tap opens the panel/menu. '
                  'Menubar has no hover-to-handoff on touch. Context and Hover '
                  'Cards are invisible on touch.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'accessibility',
        title: 'Accessibility',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'Four distinct behaviors',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _A11yHeader('Navigation Menu'),
                  _A11yRow(
                    'Keyboard: Hover opens on delay',
                    'No keyboard opener: only click or hover. Arrow keys do '
                        'not step triggers.',
                  ),
                  _A11yRow(
                    'Escape behavior',
                    'Escape closes the panel if focus is inside it. Focus is '
                        'the content\'s business: the component does not move '
                        'it.',
                  ),
                  _A11yRow(
                    'Focus trap',
                    'No trap. Focus may leave the panel.',
                    last: true,
                  ),
                  SizedBox(height: ds(4)),
                  _A11yHeader('Menubar'),
                  _A11yRow(
                    'Keyboard: Arrow keys',
                    'Left/Right step between open menus. The bar itself takes '
                        'one tab stop (canRequestFocus: false).',
                  ),
                  _A11yRow(
                    'Menu navigation',
                    'Inside a menu: Up/Down step rows, Home/End jump, typeahead '
                        'searches. Do not wrap.',
                  ),
                  _A11yRow(
                    'Hover on keyboard',
                    'Moving to a sibling menu with arrow keys while a menu is '
                        'open swaps instantly: no hover delay.',
                    last: true,
                  ),
                  SizedBox(height: ds(4)),
                  _A11yHeader('Context Menu'),
                  _A11yRow(
                    'Right-click only',
                    'No left-click path, no long-press, no keyboard shortcut. '
                        'Do not make it the only way to an action.',
                  ),
                  _A11yRow(
                    'Menu navigation',
                    'Same as Menubar, Up/Down, Home/End, typeahead, no wrap.',
                  ),
                  _A11yRow(
                    'Escape behavior',
                    'Closes the menu if focus is inside it.',
                    last: true,
                  ),
                  SizedBox(height: ds(4)),
                  _A11yHeader('Hover Card'),
                  _A11yRow(
                    'Pointer only',
                    'Opens on pointer entry with a 700ms delay. Closes when '
                        'the pointer leaves with a 300ms delay (gap-crossing '
                        'window). Never appears on touch.',
                  ),
                  _A11yRow(
                    'No focus',
                    'The card does not trap focus: it is announcement-only. '
                        'A screen reader must read the trigger to learn about '
                        'the preview.',
                  ),
                  _A11yRow(
                    'No keyboard',
                    'Cannot be opened from the keyboard. Do not put required '
                        'info in a hover card.',
                    last: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: ds(5)),
            DsNote(
              tone: DsNoteTone.error,
              title: 'Context Menu and Hover Card have no touch path',
              child: DsText(
                'Context Menu: The reference has long-press on touch, but it '
                'is not ported. Do not use context menu as the only way to an '
                'action on a phone. Hover Card: A hover-only affordance is '
                'invisible on a phone. Use it for optional detail, not '
                'required content.',
                DsType.small,
              ),
            ),
          ],
        ),
      ),
      DsSection(
        id: 'responsive',
        title: 'Responsive',
        description:
            'All four rely on [DsPopover]\'s collision algorithm: they flip '
            'sides and shift along the cross axis to stay visible. All four '
            'snap without transition.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'Platform reach',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DsText(
                    'Navigation Menu: Click and hover on all platforms. Tap '
                    'opens, tap again closes.',
                    DsType.small,
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    'Menubar: Click on all platforms. Hover swaps menus on '
                    'desktop. On touch, tap to toggle; no multi-trigger '
                    'handoff.',
                    DsType.small,
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    'Context Menu: Right-click only. No touch path in this '
                    'port. Trackpad two-finger click is right-button.',
                    DsType.small,
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    'Hover Card: Pointer entry and exit only. Completely '
                    'hidden on touch: not just disabled, but unmounted.',
                    DsType.small,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      DsSection(
        id: 'dependencies',
        title: 'Dependencies',
        description:
            'All four build on [DsPopover]. None has a registry manifest yet.',
        child: DocsInstallFacts(
          facts: <DocsInstallFact>[
            const DocsInstallFact(
              label: 'Registry item',
              value: 'None: unregistered',
              description:
                  'All four components are in the package but have no manifest '
                  'and cannot be installed through the CLI yet.',
            ),
            const DocsInstallFact(
              label: 'Primary dependency',
              value: 'DsPopover',
              description:
                  'All four mount their panels/menus through DsPopover for '
                  'placement, animation, and barrier behavior.',
            ),
            const DocsInstallFact(
              label: 'Menu rows',
              value: 'DsMenu, DsMenuChild',
              description:
                  'Menubar, Context Menu, and the menu family (not documented '
                  'on this page) share the row model.',
            ),
            const DocsInstallFact(
              label: 'Platforms',
              value: 'Android, iOS, Web, macOS, Windows, Linux',
              description: 'Pure widget composition; nothing platform-gated.',
            ),
            const DocsInstallFact(
              label: 'Built on by',
              value: 'Dropdown Menu, agent attach menu, date picker, combobox',
              description:
                  'Other components that open menus or pickers through DsPopover '
                  'directly.',
            ),
            const DocsInstallFact(
              label: 'Verified',
              value:
                  'test/components_docs/navigation_menu_test.dart: the four '
                  'live specimens on this page',
              description:
                  'Real test-view sizing at 390x844 and 1440x900, both themes '
                  'via live DsThemeController.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'theming',
        title: 'Theming',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'What actually varies with the theme',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DsText(
                    'All four: Panel/menu background is theme.popover, text is '
                    'theme.popoverForeground. Navigation Menu and Hover Card '
                    'use DsPopoverSurface, which applies the ring and shadow.',
                    DsType.small,
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    'Navigation Menu trigger: No fill transition (snaps). Hover '
                    'and open both set theme.secondary fill and theme.foreground '
                    'text.',
                    DsType.small,
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    'Menubar trigger: No fill transition. Hover and open both '
                    'set theme.muted fill.',
                    DsType.small,
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    'All animation: open/close transition runs through '
                    'DsDurations.overlay (320ms) on DsCurves.out, so it '
                    'resolves instantly under reduced motion.',
                    DsType.small,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      DsSection(
        id: 'source',
        title: 'Source',
        child: DocsInstallFacts(
          title: 'Source and tests',
          facts: <DocsInstallFact>[
            const DocsInstallFact(
              label: 'Source files',
              value:
                  'lib/src/components/navigation_menu.dart, menubar.dart, '
                  'context_menu.dart, hover_card.dart',
              description: 'The authoritative package source.',
            ),
            const DocsInstallFact(
              label: 'GitHub',
              value:
                  'github.com/ELATTAR-Ayoub/flutter-design-system/blob/main/'
                  'lib/src/components/',
              description: 'Navigate to each file in the components directory.',
            ),
            const DocsInstallFact(
              label: 'Tests',
              value: 'example/test/components_docs/navigation_menu_test.dart',
              description:
                  'This page\'s own responsive, theme, and live open/close '
                  'coverage: all four specimens live.',
            ),
            const DocsInstallFact(
              label: 'Menu rows source',
              value: 'lib/src/components/menu.dart',
              description:
                  'The shared row model (DsMenuChild) that Menubar, Context '
                  'Menu, and Dropdown Menu all use. Not documented on this '
                  'page.',
            ),
          ],
        ),
      ),
    ],
  );
}

class _A11yHeader extends StatelessWidget {
  const _A11yHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: ds(2)),
      child: DsText(title, DsType.label, color: theme.actionInk),
    );
  }
}

class _A11yRow extends StatelessWidget {
  const _A11yRow(this.label, this.body, {this.last = false});

  final String label;
  final String body;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : ds(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(label, DsType.small, color: theme.actionInk),
          SizedBox(height: ds(0.5)),
          DsText(body, DsType.small, color: theme.mutedForeground),
        ],
      ),
    );
  }
}

/// All four specimens: Navigation Menu, Menubar, Context Menu, Hover Card.
class _AllFourPreview extends StatefulWidget {
  const _AllFourPreview();

  @override
  State<_AllFourPreview> createState() => _AllFourPreviewState();
}

class _AllFourPreviewState extends State<_AllFourPreview> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText('Navigation Menu with shared viewport', DsType.label),
        SizedBox(height: ds(3)),
        const _NavigationMenuSpecimen(),
        SizedBox(height: ds(6)),
        DsText('Menubar (menu strip)', DsType.label),
        SizedBox(height: ds(3)),
        const _MenubarSpecimen(),
        SizedBox(height: ds(6)),
        DsText('Context Menu (right-click)', DsType.label),
        SizedBox(height: ds(3)),
        const _ContextMenuSpecimen(),
        SizedBox(height: ds(6)),
        DsText('Hover Card (pointer entry/exit)', DsType.label),
        SizedBox(height: ds(3)),
        const _HoverCardSpecimen(),
      ],
    );
  }
}

class _NavigationMenuSpecimen extends StatelessWidget {
  /// Mounted exactly once on this page. The key below is baked into `build`,
  /// which is only safe while that stays true: a second mount would give both
  /// instances the same key and any finder for it would match two widgets.
  /// If you add one, give this a `specimenKey` field the way
  /// [_ContextMenuSpecimen] and [_HoverCardSpecimen] already do, and pass a
  /// distinct key at the new site.
  const _NavigationMenuSpecimen();

  @override
  Widget build(BuildContext context) {
    return DsNavigationMenu(
      key: const ValueKey<String>('nav-menu-specimen'),
      viewport: true,
      indicator: false,
      items: <DsNavigationMenuItem>[
        DsNavigationMenuItem.trigger(
          label: 'Products',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DsNavigationMenuLink(child: DsText('Item 1', DsType.small)),
              DsNavigationMenuLink(child: DsText('Item 2', DsType.small)),
            ],
          ),
        ),
        DsNavigationMenuItem.trigger(
          label: 'Company',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DsNavigationMenuLink(child: DsText('About', DsType.small)),
              DsNavigationMenuLink(child: DsText('Careers', DsType.small)),
            ],
          ),
        ),
        DsNavigationMenuItem.link(label: 'Contact'),
      ],
    );
  }
}

class _NavMenuRtl extends StatelessWidget {
  const _NavMenuRtl();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DsNavigationMenu(
        viewport: true,
        items: <DsNavigationMenuItem>[
          DsNavigationMenuItem.trigger(
            label: 'المنتجات',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DsNavigationMenuLink(child: DsText('العنصر 1', DsType.small)),
                DsNavigationMenuLink(child: DsText('العنصر 2', DsType.small)),
              ],
            ),
          ),
          DsNavigationMenuItem.link(label: 'اتصل بنا'),
        ],
      ),
    );
  }
}

class _MenubarSpecimen extends StatelessWidget {
  /// Mounted exactly once. See [_NavigationMenuSpecimen] for why the baked-in
  /// key below is safe only while that remains true, and what to do instead
  /// if a second mount is ever added.
  const _MenubarSpecimen();

  @override
  Widget build(BuildContext context) {
    return DsMenubar(
      key: const ValueKey<String>('menubar-specimen'),
      menus: <DsMenubarMenu>[
        DsMenubarMenu(
          label: 'File',
          children: <DsMenuChild>[
            DsMenuItem(label: 'New'),
            DsMenuItem(label: 'Open'),
          ],
        ),
        DsMenubarMenu(
          label: 'Edit',
          children: <DsMenuChild>[
            DsMenuItem(label: 'Undo'),
            DsMenuItem(label: 'Redo'),
          ],
        ),
      ],
    );
  }
}

class _MenubarCheckbox extends StatelessWidget {
  const _MenubarCheckbox();

  @override
  Widget build(BuildContext context) {
    return DsMenubar(
      menus: <DsMenubarMenu>[
        DsMenubarMenu(
          label: 'View',
          children: <DsMenuChild>[
            DsMenuCheckboxItem(
              label: 'Always Show Bookmarks Bar',
              checked: true,
            ),
            DsMenuCheckboxItem(label: 'Always Show Full URLs', checked: false),
          ],
        ),
      ],
    );
  }
}

class _MenubarRadio extends StatelessWidget {
  const _MenubarRadio();

  @override
  Widget build(BuildContext context) {
    return DsMenubar(
      menus: <DsMenubarMenu>[
        DsMenubarMenu(
          label: 'Profiles',
          children: <DsMenuChild>[
            DsMenuRadioGroup(
              value: 'benoit',
              children: <DsMenuRadioItem>[
                DsMenuRadioItem(value: 'andy', label: 'Andy'),
                DsMenuRadioItem(value: 'benoit', label: 'Benoit'),
                DsMenuRadioItem(value: 'luis', label: 'Luis'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _MenubarSubmenu extends StatelessWidget {
  const _MenubarSubmenu();

  @override
  Widget build(BuildContext context) {
    return DsMenubar(
      menus: <DsMenubarMenu>[
        DsMenubarMenu(
          label: 'File',
          children: <DsMenuChild>[
            DsMenuItem(label: 'New Tab'),
            DsMenuSub(
              label: 'Share',
              children: <DsMenuChild>[
                DsMenuItem(label: 'Email link'),
                DsMenuItem(label: 'Messages'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _MenubarIcons extends StatelessWidget {
  const _MenubarIcons();

  @override
  Widget build(BuildContext context) {
    return DsMenubar(
      menus: <DsMenubarMenu>[
        DsMenubarMenu(
          label: 'File',
          children: <DsMenuChild>[
            DsMenuItem(label: 'New File', icon: DsIconGlyph.plus),
            DsMenuItem(label: 'Open', icon: DsIconGlyph.packageOpen),
            DsMenuItem(label: 'Download', icon: DsIconGlyph.download),
          ],
        ),
      ],
    );
  }
}

class _MenubarRtl extends StatelessWidget {
  const _MenubarRtl();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DsMenubar(
        menus: <DsMenubarMenu>[
          DsMenubarMenu(
            label: 'ملف',
            children: <DsMenuChild>[
              DsMenuItem(label: 'جديد'),
              DsMenuItem(label: 'فتح'),
            ],
          ),
          DsMenubarMenu(
            label: 'تحرير',
            children: <DsMenuChild>[
              DsMenuItem(label: 'تراجع'),
              DsMenuItem(label: 'إعادة'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContextMenuSpecimen extends StatelessWidget {
  const _ContextMenuSpecimen({this.specimenKey = 'context-menu-specimen'});

  /// Distinguishes this mount from the other sections that reuse the same
  /// specimen for illustration: a [ValueKey] must be unique across the
  /// whole page, since it is rendered as one continuous scroll.
  final String specimenKey;

  @override
  Widget build(BuildContext context) {
    return DsContextMenu(
      key: ValueKey<String>(specimenKey),
      children: <DsMenuChild>[
        DsMenuItem(label: 'Copy'),
        DsMenuItem(label: 'Paste'),
        DsMenuItem(label: 'Delete', variant: DsMenuItemVariant.destructive),
      ],
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: DsTheme.of(context).border),
          borderRadius: BorderRadius.circular(ds(2)),
        ),
        child: Center(
          child: DsText(
            'Right-click here',
            DsType.small,
            color: DsTheme.of(context).mutedForeground,
          ),
        ),
      ),
    );
  }
}

Widget _contextMenuTarget(BuildContext context, String label) => Container(
  width: 200,
  height: 100,
  decoration: BoxDecoration(
    border: Border.all(color: DsTheme.of(context).border),
    borderRadius: BorderRadius.circular(ds(2)),
  ),
  child: Center(
    child: DsText(
      label,
      DsType.small,
      color: DsTheme.of(context).mutedForeground,
    ),
  ),
);

class _ContextMenuBasic extends StatelessWidget {
  const _ContextMenuBasic();

  @override
  Widget build(BuildContext context) {
    return DsContextMenu(
      children: <DsMenuChild>[
        DsMenuItem(label: 'Copy'),
        DsMenuItem(label: 'Paste'),
      ],
      child: _contextMenuTarget(context, 'Right-click here'),
    );
  }
}

class _ContextMenuSubmenu extends StatelessWidget {
  const _ContextMenuSubmenu();

  @override
  Widget build(BuildContext context) {
    return DsContextMenu(
      children: <DsMenuChild>[
        DsMenuItem(label: 'Back'),
        DsMenuSub(
          label: 'More Tools',
          children: <DsMenuChild>[
            DsMenuItem(label: 'Save Page As...'),
            DsMenuItem(label: 'Create Shortcut...'),
          ],
        ),
      ],
      child: _contextMenuTarget(context, 'Right-click here'),
    );
  }
}

class _ContextMenuShortcuts extends StatelessWidget {
  const _ContextMenuShortcuts();

  @override
  Widget build(BuildContext context) {
    return DsContextMenu(
      children: <DsMenuChild>[
        DsMenuItem(label: 'Back', shortcut: '⌘['),
        DsMenuItem(label: 'Forward', shortcut: '⌘]'),
        DsMenuItem(label: 'Reload', shortcut: '⌘R'),
      ],
      child: _contextMenuTarget(context, 'Right-click here'),
    );
  }
}

class _ContextMenuGroups extends StatelessWidget {
  const _ContextMenuGroups();

  @override
  Widget build(BuildContext context) {
    return DsContextMenu(
      children: <DsMenuChild>[
        DsMenuGroup(
          children: <DsMenuChild>[
            DsMenuItem(label: 'Copy'),
            DsMenuItem(label: 'Paste'),
          ],
        ),
        DsMenuSeparator(),
        DsMenuGroup(children: <DsMenuChild>[DsMenuItem(label: 'Select All')]),
      ],
      child: _contextMenuTarget(context, 'Right-click here'),
    );
  }
}

class _ContextMenuIcons extends StatelessWidget {
  const _ContextMenuIcons();

  @override
  Widget build(BuildContext context) {
    return DsContextMenu(
      children: <DsMenuChild>[
        DsMenuItem(label: 'Copy', icon: DsIconGlyph.copy),
        DsMenuItem(label: 'Share', icon: DsIconGlyph.share2),
        DsMenuItem(label: 'Download', icon: DsIconGlyph.download),
      ],
      child: _contextMenuTarget(context, 'Right-click here'),
    );
  }
}

class _ContextMenuCheckboxes extends StatelessWidget {
  const _ContextMenuCheckboxes();

  @override
  Widget build(BuildContext context) {
    return DsContextMenu(
      children: <DsMenuChild>[
        DsMenuCheckboxItem(label: 'Show Bookmarks', checked: true),
        DsMenuCheckboxItem(label: 'Show Full URLs', checked: false),
      ],
      child: _contextMenuTarget(context, 'Right-click here'),
    );
  }
}

class _ContextMenuRadio extends StatelessWidget {
  const _ContextMenuRadio();

  @override
  Widget build(BuildContext context) {
    return DsContextMenu(
      children: <DsMenuChild>[
        DsMenuRadioGroup(
          value: 'medium',
          children: <DsMenuRadioItem>[
            DsMenuRadioItem(value: 'small', label: 'Small'),
            DsMenuRadioItem(value: 'medium', label: 'Medium'),
            DsMenuRadioItem(value: 'large', label: 'Large'),
          ],
        ),
      ],
      child: _contextMenuTarget(context, 'Right-click here'),
    );
  }
}

class _ContextMenuRtl extends StatelessWidget {
  const _ContextMenuRtl();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DsContextMenu(
        children: <DsMenuChild>[
          DsMenuItem(label: 'نسخ'),
          DsMenuItem(label: 'لصق'),
          DsMenuItem(label: 'حذف', variant: DsMenuItemVariant.destructive),
        ],
        child: _contextMenuTarget(context, 'انقر بزر الفأرة الأيمن هنا'),
      ),
    );
  }
}

class _HoverCardSpecimen extends StatelessWidget {
  const _HoverCardSpecimen({this.specimenKey = 'hover-card-specimen'});

  /// Distinguishes this mount from the other sections that reuse the same
  /// specimen for illustration: a [ValueKey] must be unique across the
  /// whole page, since it is rendered as one continuous scroll.
  final String specimenKey;

  @override
  Widget build(BuildContext context) {
    return DsHoverCard(
      key: ValueKey<String>(specimenKey),
      trigger: DsText(
        'Hover here to see a preview',
        DsType.small,
        color: DsTheme.of(context).actionInk,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DsText('Preview Title', DsType.label),
          SizedBox(height: ds(1)),
          DsText(
            'This is a hover card: it opens on pointer entry and closes when '
            'the pointer leaves. Not available on touch.',
            DsType.small,
            color: DsTheme.of(context).mutedForeground,
          ),
        ],
      ),
    );
  }
}

class _HoverCardRtl extends StatelessWidget {
  const _HoverCardRtl();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DsHoverCard(
        trigger: DsText(
          'مرر فوق هذا النص للمعاينة',
          DsType.small,
          color: DsTheme.of(context).actionInk,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DsText('عنوان المعاينة', DsType.label),
            SizedBox(height: ds(1)),
            DsText(
              'هذه بطاقة معاينة تظهر عند دخول المؤشر وتختفي عند خروجه.',
              DsType.small,
              color: DsTheme.of(context).mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}

const String _navMenuCode =
    '''final List<DsNavigationMenuItem> items = <DsNavigationMenuItem>[
  DsNavigationMenuItem.trigger(
    label: 'Products',
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DsNavigationMenuLink(child: const DsText('Item 1', DsType.small)),
        DsNavigationMenuLink(child: const DsText('Item 2', DsType.small)),
      ],
    ),
  ),
  DsNavigationMenuItem.link(label: 'Contact', onTap: () {}),
];

return DsNavigationMenu(
  viewport: true,
  indicator: false,
  items: items,
);''';

const String _navMenuCompositionCode = '''DsNavigationMenu(
  items: <DsNavigationMenuItem>[
    DsNavigationMenuItem.trigger(       // opens a shared or per-item panel
      label: '...',
      content: Column(
        children: <Widget>[
          DsNavigationMenuLink(child: ...),  // one row per destination
        ],
      ),
    ),
    DsNavigationMenuItem.link(label: '...'), // a plain destination, no panel
  ],
  indicator: false,  // when true, mounts a DsNavigationMenuIndicator
)''';

const String _menubarCompositionCode = '''DsMenubar(
  menus: <DsMenubarMenu>[
    DsMenubarMenu(
      label: '...',          // the trigger text
      children: <DsMenuChild>[
        DsMenuItem(...),          // a plain row
        DsMenuCheckboxItem(...),  // a toggleable row
        DsMenuRadioGroup(children: <DsMenuRadioItem>[...]),
        DsMenuSub(children: <DsMenuChild>[...]), // one nested level
        DsMenuLabel(...),
        DsMenuSeparator(),
        DsMenuGroup(children: <DsMenuChild>[...]),
      ],
    ),
  ],
)''';

const String _contextMenuCompositionCode = '''DsContextMenu(
  child: ...,             // right-click this to open the menu at the pointer
  children: <DsMenuChild>[
    DsMenuItem(...),
    DsMenuCheckboxItem(...),
    DsMenuRadioGroup(children: <DsMenuRadioItem>[...]),
    DsMenuSub(children: <DsMenuChild>[...]),
    DsMenuGroup(children: <DsMenuChild>[...]),
    DsMenuSeparator(),
  ],
)''';

const String _hoverCardCompositionCode = '''DsHoverCard(
  trigger: ...,                        // pointer entry opens the card
  content: ...,                        // laid out inside DsHoverCardContent
)''';

const String _navMenuRtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: DsNavigationMenu(
    viewport: true,
    items: <DsNavigationMenuItem>[
      DsNavigationMenuItem.trigger(
        label: 'المنتجات',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DsNavigationMenuLink(child: const DsText('العنصر 1', DsType.small)),
            DsNavigationMenuLink(child: const DsText('العنصر 2', DsType.small)),
          ],
        ),
      ),
      DsNavigationMenuItem.link(label: 'اتصل بنا'),
    ],
  ),
)''';

const String _menubarCode = '''return DsMenubar(
  menus: <DsMenubarMenu>[
    DsMenubarMenu(
      label: 'File',
      children: <DsMenuChild>[
        DsMenuItem(label: 'New'),
        DsMenuItem(label: 'Open'),
        DsMenuItemSeparator(),
        DsMenuItem(label: 'Exit'),
      ],
    ),
    DsMenubarMenu(
      label: 'Edit',
      children: <DsMenuChild>[
        DsMenuItem(label: 'Undo'),
        DsMenuItem(label: 'Redo'),
      ],
    ),
  ],
);''';

const String _menubarCheckboxCode = '''return DsMenubar(
  menus: <DsMenubarMenu>[
    DsMenubarMenu(
      label: 'View',
      children: <DsMenuChild>[
        DsMenuCheckboxItem(
          label: 'Always Show Bookmarks Bar',
          checked: true,
        ),
        DsMenuCheckboxItem(
          label: 'Always Show Full URLs',
          checked: false,
        ),
      ],
    ),
  ],
);''';

const String _menubarRadioCode = '''return DsMenubar(
  menus: <DsMenubarMenu>[
    DsMenubarMenu(
      label: 'Profiles',
      children: <DsMenuChild>[
        DsMenuRadioGroup(
          value: 'benoit',
          children: <DsMenuRadioItem>[
            DsMenuRadioItem(value: 'andy', label: 'Andy'),
            DsMenuRadioItem(value: 'benoit', label: 'Benoit'),
            DsMenuRadioItem(value: 'luis', label: 'Luis'),
          ],
        ),
      ],
    ),
  ],
);''';

const String _menubarSubmenuCode = '''return DsMenubar(
  menus: <DsMenubarMenu>[
    DsMenubarMenu(
      label: 'File',
      children: <DsMenuChild>[
        DsMenuItem(label: 'New Tab'),
        DsMenuSub(
          label: 'Share',
          children: <DsMenuChild>[
            DsMenuItem(label: 'Email link'),
            DsMenuItem(label: 'Messages'),
          ],
        ),
      ],
    ),
  ],
);''';

const String _menubarIconsCode = '''return DsMenubar(
  menus: <DsMenubarMenu>[
    DsMenubarMenu(
      label: 'File',
      children: <DsMenuChild>[
        DsMenuItem(label: 'New File', icon: DsIconGlyph.plus),
        DsMenuItem(label: 'Open', icon: DsIconGlyph.packageOpen),
        DsMenuItem(label: 'Download', icon: DsIconGlyph.download),
      ],
    ),
  ],
);''';

const String _menubarRtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: DsMenubar(
    menus: <DsMenubarMenu>[
      DsMenubarMenu(
        label: 'ملف',
        children: <DsMenuChild>[
          DsMenuItem(label: 'جديد'),
          DsMenuItem(label: 'فتح'),
        ],
      ),
      DsMenubarMenu(
        label: 'تحرير',
        children: <DsMenuChild>[
          DsMenuItem(label: 'تراجع'),
          DsMenuItem(label: 'إعادة'),
        ],
      ),
    ],
  ),
)''';

const String _contextMenuCode = '''return DsContextMenu(
  child: const Text('Right-click here'),
  children: <DsMenuChild>[
    DsMenuItem(label: 'Copy'),
    DsMenuItem(label: 'Paste'),
    DsMenuItemSeparator(),
    DsMenuItem(
      label: 'Delete',
      variant: DsMenuItemVariant.destructive,
    ),
  ],
);''';

const String _contextMenuBasicCode = '''return DsContextMenu(
  child: const Text('Right-click here'),
  children: <DsMenuChild>[
    DsMenuItem(label: 'Copy'),
    DsMenuItem(label: 'Paste'),
  ],
);''';

const String _contextMenuSubmenuCode = '''return DsContextMenu(
  child: const Text('Right-click here'),
  children: <DsMenuChild>[
    DsMenuItem(label: 'Back'),
    DsMenuSub(
      label: 'More Tools',
      children: <DsMenuChild>[
        DsMenuItem(label: 'Save Page As...'),
        DsMenuItem(label: 'Create Shortcut...'),
      ],
    ),
  ],
);''';

const String _contextMenuShortcutsCode = '''return DsContextMenu(
  child: const Text('Right-click here'),
  children: <DsMenuChild>[
    DsMenuItem(label: 'Back', shortcut: '⌘['),
    DsMenuItem(label: 'Forward', shortcut: '⌘]'),
    DsMenuItem(label: 'Reload', shortcut: '⌘R'),
  ],
);''';

const String _contextMenuGroupsCode = '''return DsContextMenu(
  child: const Text('Right-click here'),
  children: <DsMenuChild>[
    DsMenuGroup(
      children: <DsMenuChild>[
        DsMenuItem(label: 'Copy'),
        DsMenuItem(label: 'Paste'),
      ],
    ),
    DsMenuSeparator(),
    DsMenuGroup(
      children: <DsMenuChild>[DsMenuItem(label: 'Select All')],
    ),
  ],
);''';

const String _contextMenuIconsCode = '''return DsContextMenu(
  child: const Text('Right-click here'),
  children: <DsMenuChild>[
    DsMenuItem(label: 'Copy', icon: DsIconGlyph.copy),
    DsMenuItem(label: 'Share', icon: DsIconGlyph.share2),
    DsMenuItem(label: 'Download', icon: DsIconGlyph.download),
  ],
);''';

const String _contextMenuCheckboxesCode = '''return DsContextMenu(
  child: const Text('Right-click here'),
  children: <DsMenuChild>[
    DsMenuCheckboxItem(label: 'Show Bookmarks', checked: true),
    DsMenuCheckboxItem(label: 'Show Full URLs', checked: false),
  ],
);''';

const String _contextMenuRadioCode = '''return DsContextMenu(
  child: const Text('Right-click here'),
  children: <DsMenuChild>[
    DsMenuRadioGroup(
      value: 'medium',
      children: <DsMenuRadioItem>[
        DsMenuRadioItem(value: 'small', label: 'Small'),
        DsMenuRadioItem(value: 'medium', label: 'Medium'),
        DsMenuRadioItem(value: 'large', label: 'Large'),
      ],
    ),
  ],
);''';

const String _contextMenuRtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: DsContextMenu(
    child: const Text('انقر بزر الفأرة الأيمن هنا'),
    children: <DsMenuChild>[
      DsMenuItem(label: 'نسخ'),
      DsMenuItem(label: 'لصق'),
      DsMenuItem(label: 'حذف', variant: DsMenuItemVariant.destructive),
    ],
  ),
)''';

const String _hoverCardCode = '''return DsHoverCard(
  trigger: const DsText('Hover to preview'),
  content: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      DsText('Card Title', DsType.label),
      SizedBox(height: ds(1)),
      DsText(
        'A preview that opens on hover. Pointer-only: not on touch.',
        DsType.small,
      ),
    ],
  ),
);''';

const String _hoverCardRtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: DsHoverCard(
    trigger: const DsText('مرر فوق هذا النص للمعاينة'),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DsText('عنوان المعاينة', DsType.label),
        SizedBox(height: ds(1)),
        DsText(
          'هذه بطاقة معاينة تظهر عند دخول المؤشر وتختفي عند خروجه.',
          DsType.small,
        ),
      ],
    ),
  ),
)''';
