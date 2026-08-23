/// Public component documentation for navigation_menu, menubar, context_menu,
/// and hover_card.
///
/// These four anchored overlays are documented together because they all build
/// on [DsPopover] for their placement, animation, and barrier logic. The page
/// explains which overlay to reach for, when, documents the real public API of
/// all four, and covers their individual keyboard, touch, and state behaviors.
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
        DocsTocEntry(title: 'Status', anchor: 'status'),
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
        DocsTocEntry(title: 'Install', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'API', anchor: 'api'),
        DocsTocEntry(title: 'Variants', anchor: 'variants'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
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
      DsSection(
        id: 'status',
        title: 'Status',
        child: const DocsInstallFacts(
          title: 'Status',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Status',
              value: 'Unregistered — source only',
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
                  'Pure widget composition — nothing is platform-gated.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'preview',
        title: 'Preview',
        description:
            'The four components side by side: Navigation Menu with a shared '
            'viewport and indicator, Menubar as a strip, Context Menu opened by '
            'right-click, and Hover Card showing on pointer entry. All four are '
            'anchored overlays built on DsPopover.',
        child: DocsCodeExample(
          title: 'All four specimens',
          description:
              'Navigation Menu: hover or tap to open panels. Menubar: click or '
              'hover to cycle menus. Context Menu: right-click the card. Hover '
              'Card: move your pointer over the text (not on touch).',
          preview: const _AllFourPreview(),
        ),
      ),
      DsSection(
        id: 'install',
        title: 'Installation',
        description:
            'All four components are in the main package but have no registry '
            'manifest yet — `elattar add navigation-menu` does not work. Import '
            'from the barrel and copy the source files manually.',
        child: DocsCodeExample(
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
              note: 'NAVIGATION MENU — with a shared viewport',
              child: DocsSelectableCodeBlock(code: _navMenuCode),
            ),
            SizedBox(height: ds(5)),
            DsPanel(
              label: 'DART',
              note: 'MENUBAR — a strip that hands the menu between triggers',
              child: DocsSelectableCodeBlock(code: _menubarCode),
            ),
            SizedBox(height: ds(5)),
            DsPanel(
              label: 'DART',
              note: 'CONTEXT MENU — right-click to open at the pointer',
              child: DocsSelectableCodeBlock(code: _contextMenuCode),
            ),
            SizedBox(height: ds(5)),
            DsPanel(
              label: 'DART',
              note: 'HOVER CARD — opens on pointer entry, closes on exit',
              child: DocsSelectableCodeBlock(code: _hoverCardCode),
            ),
          ],
        ),
      ),
      DsSection(
        id: 'api',
        title: 'API',
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
                      'A trigger that opens a panel of content — requires '
                      'label and content.',
                ),
                DocsApiFact(
                  name: 'DsNavigationMenuItem.link()',
                  type: 'constructor',
                  description:
                      'A plain destination link, no panel — requires label, '
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
                      'The panel body for a trigger — the ul of rows. Null for '
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
                      'Required. The row content — icon-and-label or '
                      'title-and-blurb.',
                ),
                DocsApiFact(
                  name: 'active',
                  type: 'bool',
                  description:
                      'Default false. Marks the current destination — '
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
                      'Required. The triggers and their menu rows — a strip of '
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
                      'The menu rows — items, labels, separators, submenus. '
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
                      'Required. The trigger — right-click it to open the menu '
                      'at the pointer.',
                ),
                DocsApiFact(
                  name: 'children',
                  type: 'List<DsMenuChild>',
                  description:
                      'The menu rows — items, labels, separators, submenus. '
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
                      'Required. The target — pointer entry opens the card.',
                ),
                DocsApiFact(
                  name: 'content',
                  type: 'Widget',
                  description:
                      'Required. The preview content — laid out inside '
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
                      'pointer leaves — the gap-crossing window.',
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
                      'Required. The preview content — laid out inside '
                      'p-2.5 padding.',
                ),
              ],
            ),
          ],
        ),
      ),
      DsSection(
        id: 'variants',
        title: 'Which overlay to reach for',
        description:
            'All four are anchored overlays. The choice is about the trigger '
            'gesture, the content type, and the platform reach.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'Decision tree',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DsText(
                    'Navigation Menu: Click or hover to open a rich panel of '
                    'destinations. Includes a caret indicator (with a known bug) '
                    'and supports both shared and per-item viewports. Works on '
                    'click and hover.',
                    DsType.small,
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    'Menubar: A traditional menu strip for admin surfaces. '
                    'Triggers hand the open menu between them on hover. Arrow '
                    'keys step through menus. Supports nested submenus. No touch '
                    'path — menubar is a desktop pattern.',
                    DsType.small,
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    'Context Menu: Right-click only. Opens at the pointer with '
                    'no trigger box. Has no touch path — long-press is a Radix '
                    'feature not ported. Do not make it the only way to an '
                    'action.',
                    DsType.small,
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    'Hover Card: Pointer-only preview that opens on entry, '
                    'closes on exit. Not available on touch — the component '
                    'itself is invisible on a phone. Use it for optional detail '
                    'that does not block the main flow.',
                    DsType.small,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      DsSection(
        id: 'states',
        title: 'States and feedback',
        description:
            'All four are state machines: open or closed. The row model '
            '(DsMenuChild and its variants) carries item states inside them.',
        child: const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Rest',
              treatment:
                  'Closed — the trigger is visible, the panel or menu is not '
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
                  'Card: cannot receive focus — hover only.',
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
              userSignal: 'Snap — no transition. The fill appears instantly.',
            ),
            DocsStateFact(
              state: 'Disabled',
              treatment:
                  'All four: the caller is responsible for disabling. '
                  'Navigation Menu / Menubar do not carry enabled/disabled '
                  'parameters. Context Menu has enabled (default true). Hover '
                  'Card has no disable path.',
              userSignal:
                  'N/A — disabling is per-item in the menu family, and '
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
        title: 'Accessibility and keyboard behavior',
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
                    'No keyboard opener — only click or hover. Arrow keys do '
                        'not step triggers.',
                  ),
                  _A11yRow(
                    'Escape behavior',
                    'Escape closes the panel if focus is inside it. Focus is '
                        'the content\'s business — the component does not move '
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
                        'open swaps instantly — no hover delay.',
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
                    'Same as Menubar — Up/Down, Home/End, typeahead, no wrap.',
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
                    'The card does not trap focus — it is announcement-only. '
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
        title: 'Responsive and platform behavior',
        description:
            'All four rely on [DsPopover]\'s collision algorithm — they flip '
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
                    'hidden on touch — not just disabled, but unmounted.',
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
        title: 'Dependencies, files, and disclosure',
        description:
            'All four build on [DsPopover]. None has a registry manifest yet.',
        child: DocsInstallFacts(
          facts: <DocsInstallFact>[
            const DocsInstallFact(
              label: 'Registry item',
              value: 'None — unregistered',
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
                  'test/components_docs/navigation_menu_test.dart — the four '
                  'live specimens on this page',
              description:
                  'Real test-view sizing at 390x844 and 1440x900, both themes '
                  'via live DsThemeController.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'composition',
        title: 'Real examples',
        description:
            'Each component is shown live on this page. Study the preview '
            'section above for working code you can copy.',
        child: DsPanel(
          label: 'Live specimens',
          child: DsText(
            'All four components are rendered live in the Preview section at '
            'the top of this page. Scroll up to interact with them: click the '
            'Navigation Menu triggers, hover the Menubar, right-click the '
            'Context Menu card, and hover over the Hover Card text to see all '
            'four behaviors.',
            DsType.small,
          ),
        ),
      ),
      DsSection(
        id: 'theming',
        title: 'Theming notes',
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
        title: 'Source and tests',
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
                  'coverage — all four specimens live.',
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

class _MenubarSpecimen extends StatelessWidget {
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

class _ContextMenuSpecimen extends StatelessWidget {
  const _ContextMenuSpecimen();

  @override
  Widget build(BuildContext context) {
    return DsContextMenu(
      key: const ValueKey<String>('context-menu-specimen'),
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

class _HoverCardSpecimen extends StatelessWidget {
  const _HoverCardSpecimen();

  @override
  Widget build(BuildContext context) {
    return DsHoverCard(
      key: const ValueKey<String>('hover-card-specimen'),
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
            'This is a hover card — it opens on pointer entry and closes when '
            'the pointer leaves. Not available on touch.',
            DsType.small,
            color: DsTheme.of(context).mutedForeground,
          ),
        ],
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

const String _hoverCardCode = '''return DsHoverCard(
  trigger: const DsText('Hover to preview'),
  content: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      DsText('Card Title', DsType.label),
      SizedBox(height: ds(1)),
      DsText(
        'A preview that opens on hover. Pointer-only — not on touch.',
        DsType.small,
      ),
    ],
  ),
);''';
