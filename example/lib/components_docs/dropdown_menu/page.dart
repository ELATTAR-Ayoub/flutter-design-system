/// Public documentation page for `ElDropdownMenu`
/// (`lib/src/components/dropdown_menu.dart`) **and** the shared menu engine
/// it is built from (`lib/src/components/menu.dart`): one page, because
/// `menu.dart`'s own library doc names itself as "the shared body of
/// `dropdown-menu.tsx`, `context-menu.tsx` and `menubar.tsx`": it is not a
/// second component to choose between, it is the row model, geometry,
/// surface and keyboard behaviour [ElDropdownMenu] mounts. See
/// `meta.dart`'s own library doc for the full reasoning.
///
/// **Re-housed onto the kit.** This page used to hand-compose `ElSection`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button` and `field` established.
/// Every specimen widget and every code string below is the same one the
/// hand-composed page carried; the Preview specimen (previously a bare
/// `DocsCodeExample` with no quoted source) and the Complex/row-actions
/// specimen (previously code-less too) both gain a `code:` string here, so
/// every `ShowcaseSection` is a specimen AND its source. A new Keyboard
/// disclosure is split out of the two "Keyboard interactions" rows the old
/// Accessibility section folded together; every other row stays under
/// Accessibility.
///
/// `dropdownMenuDoc` (from `meta.dart`) is the data source, not
/// `componentDoc('dropdown-menu')`; this page keeps its typed metadata
/// import, and `dropdownMenuDoc` is the same entry `catalog.dart`'s own
/// `componentDocs` list now carries.
///
/// Two corrections against the task brief, both resolved in favour of the
/// real source, which is the documented source of truth here:
///
///  * **Enter/Space on a focused trigger does not open the menu.**
///    [ElMenuPointerDown] opens exclusively on a raw `PointerDownEvent`; a
///    button's own keyboard activation (`ElButton._onKey`) calls the
///    trigger's own `onPressed` directly, bypassing the `Listener` entirely.
///    Every real call site: this page's own specimen included: leaves that
///    `onPressed` a no-op, because the actual open mechanism lives one level
///    up. The Keyboard section documents this plainly, pinned by a live
///    test that focuses the trigger's real `FocusNode` and presses Enter.
///  * **A dropdown's own submenu renders `ElMenuSurfaceKind.subBordered`,
///    not `subRinged`.** `menu.dart`'s own DRIFT-4 comment table says a
///    `DropdownMenuSubContent` should carry `subRinged` (`shadow-lg ring-1`)
///    and only `ContextMenuSubContent` should carry `subBordered`
///    (`shadow-lg border`). But `_buildRow`'s `ElMenuSub` case maps **any**
///    `content`-kind parent to `subBordered`, and neither `ElDropdownMenu`
///    nor `context_menu.dart` nor `menubar.dart` ever passes a `kind`
///    override away from `ElMenuContent`'s own `content` default: so the
///    distinction the comment describes is not what the code does. The
///    API Reference section documents this inline on the `ElMenuSurfaceKind`
///    table, pinned by a live test that opens a submenu and reads the
///    mounted `ElMenuSurface.kind` back.
///
/// **Shadcn-parity reshape** (against
/// `https://ui.shadcn.com/docs/components/base/dropdown-menu`; `.../base/
/// menu` and `.../menu` both 404, so `menu.dart` stays folded into this
/// page's own sections rather than grouped under a second counterpart
/// name): Preview, Installation, Usage, Composition, one section per shadcn
/// row shape (Basic, Submenu, Shortcuts, Icons, Checkboxes, Radio group,
/// Destructive, Complex), then the eight disclosures. Two shadcn variants
/// are skipped rather than faked: "Checkboxes Icons" and "Radio Icons",
/// because neither [ElMenuCheckboxItem] nor `ElMenuRadioItem` declares an
/// icon parameter — both Checkboxes and Radio group sections say so. RTL is
/// skipped too: nothing in either file overrides `Directionality`, so a
/// mirrored layout is architecturally plausible but unverified by any live
/// test in this pass, and this page only asserts what a test pins.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec dropdownMenuDocSpec = ComponentDocSpec(
  name: 'dropdown-menu',
  title: dropdownMenuDoc.title,
  description: dropdownMenuDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'A real ElDropdownMenu, not a static mock: every row shape '
          'menu.dart declares — a label, a group, a submenu, a checkbox '
          'row with live state, a radio group with live state, and a '
          'destructive item. Open it, pick a row, watch "Last action" '
          'update underneath. Tap the trigger, or focus it and press '
          'Enter: only one of those two opens it; the Keyboard section '
          'says which and why.',
      specimen: _DropdownMenuPreview(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'registry/components/dropdown-menu.json ships and resolves '
          'menu, button, popover and source-foundation automatically: '
          '`elattar add dropdown-menu` installs both '
          'dropdown_menu.dart and menu.dart together. The Manual tab is '
          'for a project not using the CLI.',
      command: dropdownMenuDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/menu.dart',
          title: '1. Copy the shared engine',
          description:
              "Copy lib/src/components/menu.dart's generated @ui/"
              'menu.dart payload into components/ui: the row model, '
              'geometry, surface and keyboard behaviour dropdown_menu.dart '
              'is built from.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated menu source here when using manual '
              'mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/dropdown_menu.dart',
          title: '2. Copy the trigger root',
          description:
              "Copy lib/src/components/dropdown_menu.dart's generated "
              '@ui/dropdown_menu.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated dropdown_menu source here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '3. Export both from your barrel',
          description:
              'Add both export lines so ElDropdownMenu and the whole '
              'menu.dart row model are reachable the same way the CLI '
              'path already makes them.',
          code: "export 'menu.dart';\nexport 'dropdown_menu.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'Import the package, then hand a trigger and a row list to '
          'ElDropdownMenu. The sections below only change what those rows '
          'are.',
      code: _usageBasicCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'The row shapes menu.dart declares, nested the way '
          'ElDropdownMenu actually mounts them: one trigger, one row '
          'list. Every leaf below is a ElMenuChild.',
      code: _compositionTreeCode,
    ),
    ShowcaseSection(
      id: 'example-basic',
      title: 'Basic',
      description: 'Grouped commands, a label, and a destructive row.',
      specimen: _DropdownMenuExampleBasic(),
      code: _usageGroupedCode,
      label: 'Basic specimen view',
    ),
    ShowcaseSection(
      id: 'example-submenu',
      title: 'Submenu',
      description: 'A ElMenuSub row opens a nested ElMenuContent.',
      specimen: _DropdownMenuExampleSubmenu(),
      code: _exampleSubmenuCode,
      label: 'Submenu specimen view',
    ),
    ShowcaseSection(
      id: 'example-shortcuts',
      title: 'Shortcuts',
      description: 'ElMenuItem.shortcut renders a right-aligned key hint.',
      specimen: _DropdownMenuExampleShortcuts(),
      code: _exampleShortcutsCode,
      label: 'Shortcuts specimen view',
    ),
    ShowcaseSection(
      id: 'example-icons',
      title: 'Icons',
      description: 'ElMenuItem.icon adds a leading glyph to a row.',
      specimen: _DropdownMenuExampleIcons(),
      code: _exampleIconsCode,
      label: 'Icons specimen view',
    ),
    ShowcaseSection(
      id: 'example-checkboxes',
      title: 'Checkboxes',
      description:
          'ElMenuCheckboxItem is a controlled boolean row. GAP: it has '
          'no icon parameter, so a leading-icon checkbox row (shadcn\'s '
          'own "Checkboxes Icons" variant) is not reachable from this '
          'component; not built here rather than faked.',
      specimen: _DropdownMenuExampleCheckboxes(),
      code: _exampleCheckboxesCode,
      label: 'Checkboxes specimen view',
    ),
    ShowcaseSection(
      id: 'example-radio-group',
      title: 'Radio group',
      description:
          'ElMenuRadioGroup and ElMenuRadioItem: exactly one row wears '
          'the tick. GAP: ElMenuRadioItem also has no icon parameter, '
          'so shadcn\'s "Radio Icons" variant is not reachable either.',
      specimen: _DropdownMenuExampleRadioGroup(),
      code: _exampleRadioGroupCode,
      label: 'Radio group specimen view',
    ),
    ShowcaseSection(
      id: 'example-destructive',
      title: 'Destructive',
      description:
          'ElMenuItemVariant.destructive recolours a row for an '
          'irreversible action.',
      specimen: _DropdownMenuExampleDestructive(),
      code: _exampleDestructiveCode,
      label: 'Destructive specimen view',
    ),
    ShowcaseSection(
      id: 'example-complex',
      title: 'Complex',
      description:
          'A realistic composition: an ellipsis trigger at the end of a '
          'data-table row, aligned to the row\'s own trailing edge, mixing '
          'icons, a separator, and a destructive item. Our stand-in for '
          'shadcn\'s own account-switcher example: this package has no '
          'Avatar-driven trigger of that shape to reuse yet.',
      specimen: _DropdownMenuComposition(),
      code: _complexCode,
      label: 'Complex specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every public class, enum, and constructor parameter declared '
          'in dropdown_menu.dart and menu.dart: one table per exported '
          'class or enum.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElMenuTriggerScope', anchor: 'api-triggerscope'),
        DocsTocEntry(title: 'ElDropdownMenu', anchor: 'api-dropdownmenu'),
        DocsTocEntry(title: 'ElMenuItem', anchor: 'api-menuitem'),
        DocsTocEntry(
          title: 'ElMenuCheckboxItem',
          anchor: 'api-menucheckboxitem',
        ),
        DocsTocEntry(title: 'ElMenuRadioItem', anchor: 'api-menuradioitem'),
        DocsTocEntry(title: 'ElMenuRadioGroup', anchor: 'api-menuradiogroup'),
        DocsTocEntry(title: 'ElMenuLabel', anchor: 'api-menulabel'),
        DocsTocEntry(title: 'ElMenuSeparator', anchor: 'api-menuseparator'),
        DocsTocEntry(title: 'ElMenuGroup', anchor: 'api-menugroup'),
        DocsTocEntry(title: 'ElMenuSub', anchor: 'api-menusub'),
        DocsTocEntry(title: 'ElMenuContent', anchor: 'api-menucontent'),
        DocsTocEntry(title: 'ElMenuSurface', anchor: 'api-menusurface'),
        DocsTocEntry(
          title: 'ElMenuPointerDown',
          anchor: 'api-menupointerdown',
        ),
        DocsTocEntry(title: 'ElMenuMotion', anchor: 'api-menumotion'),
        DocsTocEntry(title: 'ElMenu: static geometry', anchor: 'api-menu'),
        DocsTocEntry(
          title: 'ElMenuItemVariant',
          anchor: 'api-menuitemvariant',
        ),
        DocsTocEntry(
          title: 'ElMenuIndicatorSide',
          anchor: 'api-menuindicatorside',
        ),
        DocsTocEntry(
          title: 'ElMenuSurfaceKind',
          anchor: 'api-menusurfacekind',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Rows that do not apply to this synchronous, pointer/keyboard '
          'driven primitive are marked N/A with the reason, rather than '
          'invented.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description:
          'What the semantics tree actually carries. Keyboard '
          'interactions have their own section below.',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'Read straight off menu.dart\'s _MenuContentState and '
          'dropdown_menu.dart\'s ElMenuPointerDown, not inferred.',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      description:
          'Opening is routed by pointer-down regardless of device kind; '
          'once open, every row interaction — tap, arrow keys, typeahead '
          '— works identically on touch, mouse, and keyboard, with the '
          'single exception the Keyboard section names.',
      child: _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      description:
          "Elattar's own technical-transparency panel: what these two "
          'files need to install and run.',
      child: _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source: the trigger root',
            value: dropdownMenuDoc.sourcePath,
            description: 'ElDropdownMenu and ElMenuTriggerScope.',
          ),
          const DocsInstallFact(
            label: 'Source: the shared engine',
            value: menuSourcePath,
            description:
                'The row model, geometry, surface and keyboard behaviour '
                'every menu root — dropdown, context menu, menubar — '
                'mounts identically.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/menus_test.dart',
            description:
                'Package-level behavioral coverage: ElMenu geometry, and '
                'the full ElDropdownMenu group — opening, placement, '
                'highlighting, typeahead, Escape, checkbox and radio '
                'commit, submenu timing and barrier behaviour.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/dropdown_menu_test.dart',
            description:
                "This page's own responsive, theme, API-completeness, and "
                'live open / activate / dismiss / keyboard-gap / '
                'submenu-surface coverage.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/dropdown_menu/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class DropdownMenuDocPage extends StatelessWidget {
  const DropdownMenuDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: dropdownMenuDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: dropdownMenuDocSpec.title,
      description: dropdownMenuDocSpec.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Dropdown Menu'),
    ],
    toc: dropdownMenuDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Drawer',
      route: '/components/drawer',
    ),
    next: const DocsPageLink(
      title: 'Hover Card',
      route: '/components/hover-card',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('dropdown-menu-doc-article'),
      child: ComponentDocPage(spec: dropdownMenuDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

const String _previewCode = '''ElDropdownMenu(
  width: el(60),
  trigger: Builder(
    builder: (context) => ElButton(
      variant: ElButtonVariant.outline,
      label: 'Account menu',
      suppressPressScale: true,
      expanded: ElMenuTriggerScope.openOf(context),
      onPressed: () {},
      child: const Text('Account menu'), // + a leading and trailing icon
    ),
  ),
  children: <ElMenuChild>[
    const ElMenuLabel('Account'),
    const ElMenuSeparator(),
    ElMenuGroup(
      children: <ElMenuChild>[
        ElMenuItem(label: 'Profile', icon: ElIconGlyph.user, shortcut: '⇧⌘P', onSelect: () {}),
        ElMenuItem(label: 'Billing', icon: ElIconGlyph.creditCard, shortcut: '⌘B', onSelect: () {}),
        ElMenuItem(label: 'Settings', icon: ElIconGlyph.settings, onSelect: () {}),
      ],
    ),
    const ElMenuSeparator(),
    ElMenuSub(
      label: 'Invite users',
      icon: ElIconGlyph.plus,
      children: <ElMenuChild>[
        ElMenuItem(label: 'Email', onSelect: () {}),
        ElMenuItem(label: 'Message', onSelect: () {}),
      ],
    ),
    const ElMenuSeparator(),
    ElMenuCheckboxItem(
      label: 'Show status bar',
      checked: statusBar,
      onSelect: (bool next) => setState(() => statusBar = next),
    ),
    const ElMenuSeparator(),
    ElMenuRadioGroup(
      value: panel,
      onChanged: (String next) => setState(() => panel = next),
      children: const <ElMenuRadioItem>[
        ElMenuRadioItem(value: 'left', label: 'Panel on left'),
        ElMenuRadioItem(value: 'right', label: 'Panel on right'),
      ],
    ),
    const ElMenuSeparator(),
    ElMenuItem(
      label: 'Log out',
      icon: ElIconGlyph.logOut,
      variant: ElMenuItemVariant.destructive,
      onSelect: () {},
    ),
  ],
)''';

const String _usageBasicCode = '''ElDropdownMenu(
  trigger: ElButton(
    variant: ElButtonVariant.outline,
    label: 'Open menu',
    suppressPressScale: true,
    onPressed: () {},
    child: const ElText('Open menu', ElComponentType.buttonLabel),
  ),
  children: <ElMenuChild>[
    ElMenuItem(label: 'Edit', onSelect: () {}),
    ElMenuItem(label: 'Duplicate', onSelect: () {}),
    const ElMenuSeparator(),
    ElMenuItem(
      label: 'Delete',
      variant: ElMenuItemVariant.destructive,
      onSelect: () {},
    ),
  ],
)''';

const String _usageGroupedCode = '''ElDropdownMenu(
  width: el(60),
  trigger: accountTrigger, // the caller's own control, rendered as-is
  children: <ElMenuChild>[
    const ElMenuLabel('My Account'),
    const ElMenuSeparator(),
    ElMenuGroup(children: <ElMenuChild>[
      ElMenuItem(
        label: 'Profile',
        icon: ElIconGlyph.user,
        shortcut: '⇧⌘P',
        onSelect: openProfile,
      ),
      ElMenuItem(
        label: 'Billing',
        icon: ElIconGlyph.creditCard,
        shortcut: '⌘B',
        onSelect: openBilling,
      ),
    ]),
    const ElMenuSeparator(),
    ElMenuItem(
      label: 'Log out',
      icon: ElIconGlyph.logOut,
      variant: ElMenuItemVariant.destructive,
      onSelect: signOut,
    ),
  ],
)''';

const String _compositionTreeCode = '''ElDropdownMenu(
  trigger: yourOwnWidget,      // wrapped in ElMenuPointerDown + ElMenuTriggerScope
  children: <ElMenuChild>[     // -> mounted inside ElMenuContent
    ElMenuLabel('...'),
    const ElMenuSeparator(),
    ElMenuGroup(
      children: <ElMenuChild>[
        ElMenuItem(...),        // icon, lucideIcon, subtitle, shortcut, variant
      ],
    ),
    const ElMenuSeparator(),
    ElMenuSub(
      label: '...',
      children: <ElMenuChild>[  // -> a nested ElMenuContent, its own ElMenuSurface
        ElMenuItem(...),
      ],
    ),
    const ElMenuSeparator(),
    ElMenuCheckboxItem(...),
    ElMenuRadioGroup(
      children: <ElMenuRadioItem>[
        ElMenuRadioItem(...),
      ],
    ),
  ],
)''';

const String _exampleSubmenuCode = '''ElDropdownMenu(
  trigger: triggerButton,
  children: <ElMenuChild>[
    ElMenuItem(label: 'Edit', onSelect: () {}),
    ElMenuSub(
      label: 'Invite users',
      icon: ElIconGlyph.plus,
      children: <ElMenuChild>[
        ElMenuItem(label: 'Email', onSelect: inviteByEmail),
        ElMenuItem(label: 'Message', onSelect: inviteByMessage),
      ],
    ),
  ],
)''';

const String _exampleShortcutsCode = '''ElDropdownMenu(
  trigger: accountTrigger,
  children: <ElMenuChild>[
    ElMenuItem(label: 'Profile', shortcut: '⇧⌘P', onSelect: openProfile),
    ElMenuItem(label: 'Billing', shortcut: '⌘B', onSelect: openBilling),
  ],
)''';

const String _exampleIconsCode = '''ElDropdownMenu(
  trigger: accountTrigger,
  children: <ElMenuChild>[
    ElMenuItem(
      label: 'Profile',
      icon: ElIconGlyph.user,
      onSelect: openProfile,
    ),
    ElMenuItem(
      label: 'Billing',
      icon: ElIconGlyph.creditCard,
      onSelect: openBilling,
    ),
  ],
)''';

const String _exampleCheckboxesCode = '''ElDropdownMenu(
  trigger: viewOptionsTrigger,
  children: <ElMenuChild>[
    ElMenuCheckboxItem(
      label: 'Show status bar',
      checked: showStatusBar,
      onSelect: (bool next) => setState(() => showStatusBar = next),
    ),
  ],
)''';

const String _exampleRadioGroupCode = '''ElDropdownMenu(
  trigger: viewOptionsTrigger,
  children: <ElMenuChild>[
    ElMenuRadioGroup(
      value: panelPosition,
      onChanged: (String next) => setState(() => panelPosition = next),
      children: const <ElMenuRadioItem>[
        ElMenuRadioItem(value: 'left', label: 'Panel on left'),
        ElMenuRadioItem(value: 'right', label: 'Panel on right'),
      ],
    ),
  ],
)''';

const String _exampleDestructiveCode = '''ElDropdownMenu(
  trigger: triggerButton,
  children: <ElMenuChild>[
    ElMenuItem(label: 'Edit', onSelect: () {}),
    ElMenuItem(label: 'Duplicate', onSelect: () {}),
    const ElMenuSeparator(),
    ElMenuItem(
      label: 'Delete',
      variant: ElMenuItemVariant.destructive,
      onSelect: () {},
    ),
  ],
)''';

const String _complexCode = '''Row(
  children: [
    Expanded(child: Text('INV-2049 · Autumn Collection')),
    ElDropdownMenu(
      align: ElPopoverAlign.end,
      trigger: ElButton(
        variant: ElButtonVariant.ghost,
        size: ElButtonSize.icon,
        label: 'Row actions',
        suppressPressScale: true,
        onPressed: () {},
        child: const ElIcon(ElIconGlyph.ellipsis, size: ElIconSize.md),
      ),
      children: <ElMenuChild>[
        ElMenuItem(label: 'View invoice', icon: ElIconGlyph.eye, onSelect: () {}),
        ElMenuItem(label: 'Duplicate', icon: ElIconGlyph.copy, onSelect: () {}),
        const ElMenuSeparator(),
        ElMenuItem(
          label: 'Delete',
          icon: ElIconGlyph.trash2,
          variant: ElMenuItemVariant.destructive,
          onSelect: () {},
        ),
      ],
    ),
  ],
)''';

class _A11yRow extends StatelessWidget {
  const _A11yRow(this.label, this.body, {this.last = false});

  final String label;
  final String body;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : el(3)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElText(label, ElType.section, color: theme.actionInk),
            SizedBox(height: el(1)),
            ElText(body, ElType.small),
          ],
        ),
      ),
    );
  }
}

/// The live specimen: every real row shape menu.dart declares, wired to
/// genuine state so a checkbox and a radio group truly toggle rather than
/// standing in for the reference's own controlled-with-no-handler rows.
class _DropdownMenuPreview extends StatefulWidget {
  const _DropdownMenuPreview();

  @override
  State<_DropdownMenuPreview> createState() => _DropdownMenuPreviewState();
}

class _DropdownMenuPreviewState extends State<_DropdownMenuPreview> {
  String _lastAction = 'none yet';
  bool _statusBar = false;
  String _panel = 'left';

  void _act(String action) => setState(() => _lastAction = action);

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElDropdownMenu(
          width: el(60),
          trigger: Builder(
            builder: (BuildContext triggerContext) => ElButton(
              key: const ValueKey<String>('dropdown-menu-doc-specimen-trigger'),
              variant: ElButtonVariant.outline,
              label: 'Account menu',
              suppressPressScale: true,
              expanded: ElMenuTriggerScope.openOf(triggerContext),
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ElIcon(ElIconGlyph.user, size: ElIconSize.sm),
                  SizedBox(width: el(2)),
                  ElText('Account menu', ElComponentType.buttonLabel),
                  SizedBox(width: el(2)),
                  const ElIcon(ElIconGlyph.chevronDown, size: ElIconSize.sm),
                ],
              ),
            ),
          ),
          children: <ElMenuChild>[
            const ElMenuLabel('Account'),
            const ElMenuSeparator(),
            ElMenuGroup(
              children: <ElMenuChild>[
                ElMenuItem(
                  label: 'Profile',
                  icon: ElIconGlyph.user,
                  shortcut: '⇧⌘P',
                  onSelect: () => _act('Profile'),
                ),
                ElMenuItem(
                  label: 'Billing',
                  icon: ElIconGlyph.creditCard,
                  shortcut: '⌘B',
                  onSelect: () => _act('Billing'),
                ),
                ElMenuItem(
                  label: 'Settings',
                  icon: ElIconGlyph.settings,
                  onSelect: () => _act('Settings'),
                ),
              ],
            ),
            const ElMenuSeparator(),
            ElMenuSub(
              label: 'Invite users',
              icon: ElIconGlyph.plus,
              children: <ElMenuChild>[
                ElMenuItem(
                  label: 'Email',
                  onSelect: () => _act('Invite by email'),
                ),
                ElMenuItem(
                  label: 'Message',
                  onSelect: () => _act('Invite by message'),
                ),
              ],
            ),
            const ElMenuSeparator(),
            ElMenuCheckboxItem(
              label: 'Show status bar',
              checked: _statusBar,
              onSelect: (bool next) => setState(() => _statusBar = next),
            ),
            const ElMenuSeparator(),
            ElMenuRadioGroup(
              value: _panel,
              onChanged: (String next) => setState(() => _panel = next),
              children: const <ElMenuRadioItem>[
                ElMenuRadioItem(value: 'left', label: 'Panel on left'),
                ElMenuRadioItem(value: 'right', label: 'Panel on right'),
              ],
            ),
            const ElMenuSeparator(),
            ElMenuItem(
              label: 'Log out',
              icon: ElIconGlyph.logOut,
              variant: ElMenuItemVariant.destructive,
              onSelect: () => _act('Log out'),
            ),
          ],
        ),
        SizedBox(height: el(4)),
        ElText(
          'Last action: $_lastAction',
          ElType.small,
          key: const ValueKey<String>('dropdown-menu-doc-last-action'),
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// A realistic row-actions menu: an ellipsis trigger at the end of a
/// data-table row, aligned to the row's own trailing edge.
class _DropdownMenuComposition extends StatelessWidget {
  const _DropdownMenuComposition();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ElText(
            'INV-2049 · Autumn Collection',
            ElType.body,
            color: theme.foreground,
          ),
        ),
        SizedBox(width: el(3)),
        ElDropdownMenu(
          align: ElPopoverAlign.end,
          trigger: ElButton(
            variant: ElButtonVariant.ghost,
            size: ElButtonSize.icon,
            label: 'Row actions',
            suppressPressScale: true,
            onPressed: () {},
            child: const ElIcon(ElIconGlyph.ellipsis, size: ElIconSize.md),
          ),
          children: <ElMenuChild>[
            ElMenuItem(
              label: 'View invoice',
              icon: ElIconGlyph.eye,
              onSelect: () {},
            ),
            ElMenuItem(
              label: 'Duplicate',
              icon: ElIconGlyph.copy,
              onSelect: () {},
            ),
            const ElMenuSeparator(),
            ElMenuItem(
              label: 'Delete',
              icon: ElIconGlyph.trash2,
              variant: ElMenuItemVariant.destructive,
              onSelect: () {},
            ),
          ],
        ),
      ],
    );
  }
}

/// Labelled commands, a group, and a destructive row: mirrors shadcn's own
/// "Basic" composition, a simple dropdown with labels and separators.
class _DropdownMenuExampleBasic extends StatelessWidget {
  const _DropdownMenuExampleBasic();

  @override
  Widget build(BuildContext context) => ElDropdownMenu(
    width: el(56),
    trigger: ElButton(
      key: const ValueKey<String>('dropdown-menu-example-basic-trigger'),
      variant: ElButtonVariant.outline,
      label: 'Account',
      suppressPressScale: true,
      onPressed: () {},
      child: ElText('Account', ElComponentType.buttonLabel),
    ),
    children: <ElMenuChild>[
      const ElMenuLabel('My Account'),
      const ElMenuSeparator(),
      ElMenuGroup(
        children: <ElMenuChild>[
          ElMenuItem(label: 'Profile', onSelect: () {}),
          ElMenuItem(label: 'Billing', onSelect: () {}),
        ],
      ),
      const ElMenuSeparator(),
      ElMenuItem(
        label: 'Log out',
        variant: ElMenuItemVariant.destructive,
        onSelect: () {},
      ),
    ],
  );
}

/// A ElMenuSub row opening a nested submenu: the same "Invite users" shape
/// the rich Preview specimen above already carries.
class _DropdownMenuExampleSubmenu extends StatelessWidget {
  const _DropdownMenuExampleSubmenu();

  @override
  Widget build(BuildContext context) => ElDropdownMenu(
    trigger: ElButton(
      key: const ValueKey<String>('dropdown-menu-example-submenu-trigger'),
      variant: ElButtonVariant.outline,
      label: 'Actions',
      suppressPressScale: true,
      onPressed: () {},
      child: ElText('Actions', ElComponentType.buttonLabel),
    ),
    children: <ElMenuChild>[
      ElMenuItem(label: 'Edit', onSelect: () {}),
      ElMenuSub(
        label: 'Invite users',
        icon: ElIconGlyph.plus,
        children: <ElMenuChild>[
          ElMenuItem(label: 'Email', onSelect: () {}),
          ElMenuItem(label: 'Message', onSelect: () {}),
        ],
      ),
    ],
  );
}

/// ElMenuItem.shortcut: a key hint, right-aligned and muted at rest.
class _DropdownMenuExampleShortcuts extends StatelessWidget {
  const _DropdownMenuExampleShortcuts();

  @override
  Widget build(BuildContext context) => ElDropdownMenu(
    trigger: ElButton(
      key: const ValueKey<String>('dropdown-menu-example-shortcuts-trigger'),
      variant: ElButtonVariant.outline,
      label: 'Account',
      suppressPressScale: true,
      onPressed: () {},
      child: ElText('Account', ElComponentType.buttonLabel),
    ),
    children: <ElMenuChild>[
      ElMenuItem(label: 'Profile', shortcut: '⇧⌘P', onSelect: () {}),
      ElMenuItem(label: 'Billing', shortcut: '⌘B', onSelect: () {}),
    ],
  );
}

/// ElMenuItem.icon: a leading glyph forced into ElMenu.iconSize (16px).
class _DropdownMenuExampleIcons extends StatelessWidget {
  const _DropdownMenuExampleIcons();

  @override
  Widget build(BuildContext context) => ElDropdownMenu(
    trigger: ElButton(
      key: const ValueKey<String>('dropdown-menu-example-icons-trigger'),
      variant: ElButtonVariant.outline,
      label: 'Account',
      suppressPressScale: true,
      onPressed: () {},
      child: ElText('Account', ElComponentType.buttonLabel),
    ),
    children: <ElMenuChild>[
      ElMenuItem(label: 'Profile', icon: ElIconGlyph.user, onSelect: () {}),
      ElMenuItem(
        label: 'Billing',
        icon: ElIconGlyph.creditCard,
        onSelect: () {},
      ),
    ],
  );
}

/// ElMenuCheckboxItem, wired to real state so the tick genuinely toggles,
/// plus a disabled row for contrast. GAP: neither row can carry a leading
/// icon, ElMenuCheckboxItem declares no icon parameter, see the section
/// description above.
class _DropdownMenuExampleCheckboxes extends StatefulWidget {
  const _DropdownMenuExampleCheckboxes();

  @override
  State<_DropdownMenuExampleCheckboxes> createState() =>
      _DropdownMenuExampleCheckboxesState();
}

class _DropdownMenuExampleCheckboxesState
    extends State<_DropdownMenuExampleCheckboxes> {
  bool _statusBar = true;

  @override
  Widget build(BuildContext context) => ElDropdownMenu(
    trigger: ElButton(
      key: const ValueKey<String>('dropdown-menu-example-checkboxes-trigger'),
      variant: ElButtonVariant.outline,
      label: 'View',
      suppressPressScale: true,
      onPressed: () {},
      child: ElText('View', ElComponentType.buttonLabel),
    ),
    children: <ElMenuChild>[
      ElMenuCheckboxItem(
        label: 'Show status bar',
        checked: _statusBar,
        onSelect: (bool next) => setState(() => _statusBar = next),
      ),
      const ElMenuCheckboxItem(
        label: 'Show activity bar',
        checked: false,
        enabled: false,
      ),
    ],
  );
}

/// ElMenuRadioGroup and ElMenuRadioItem: exactly one row wears the tick.
/// GAP: ElMenuRadioItem also declares no icon parameter, see the section
/// description above.
class _DropdownMenuExampleRadioGroup extends StatefulWidget {
  const _DropdownMenuExampleRadioGroup();

  @override
  State<_DropdownMenuExampleRadioGroup> createState() =>
      _DropdownMenuExampleRadioGroupState();
}

class _DropdownMenuExampleRadioGroupState
    extends State<_DropdownMenuExampleRadioGroup> {
  String _panel = 'left';

  @override
  Widget build(BuildContext context) => ElDropdownMenu(
    trigger: ElButton(
      key: const ValueKey<String>('dropdown-menu-example-radio-group-trigger'),
      variant: ElButtonVariant.outline,
      label: 'Panel position',
      suppressPressScale: true,
      onPressed: () {},
      child: ElText('Panel position', ElComponentType.buttonLabel),
    ),
    children: <ElMenuChild>[
      ElMenuRadioGroup(
        value: _panel,
        onChanged: (String next) => setState(() => _panel = next),
        children: const <ElMenuRadioItem>[
          ElMenuRadioItem(value: 'left', label: 'Panel on left'),
          ElMenuRadioItem(value: 'right', label: 'Panel on right'),
        ],
      ),
    ],
  );
}

/// ElMenuItemVariant.destructive: destructiveInk label/icon/shortcut in
/// every state, tinted with destructive rather than accent while
/// highlighted.
class _DropdownMenuExampleDestructive extends StatelessWidget {
  const _DropdownMenuExampleDestructive();

  @override
  Widget build(BuildContext context) => ElDropdownMenu(
    trigger: ElButton(
      key: const ValueKey<String>('dropdown-menu-example-destructive-trigger'),
      variant: ElButtonVariant.outline,
      label: 'Item',
      suppressPressScale: true,
      onPressed: () {},
      child: ElText('Item', ElComponentType.buttonLabel),
    ),
    children: <ElMenuChild>[
      ElMenuItem(label: 'Edit', onSelect: () {}),
      ElMenuItem(label: 'Duplicate', onSelect: () {}),
      const ElMenuSeparator(),
      ElMenuItem(
        label: 'Delete',
        variant: ElMenuItemVariant.destructive,
        onSelect: () {},
      ),
    ],
  );
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-triggerscope',
        child: DocsApiTable(
          title: 'ElMenuTriggerScope',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'open',
              type: 'bool',
              description:
                  "Required. aria-expanded: whether the menu under this "
                  'trigger is open. Published by ElDropdownMenu and read '
                  'back with the static openOf(context), which '
                  'ElButton.expanded resolves against so an open trigger '
                  'holds its hover fill after the pointer leaves it.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-dropdownmenu',
        child: DocsApiTable(
          title: 'ElDropdownMenu',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'trigger',
              type: 'Widget',
              description:
                  "Required. The caller's own control, rendered verbatim "
                  '(DropdownMenuTrigger asChild) and wrapped in '
                  'ElMenuPointerDown and ElMenuTriggerScope.',
            ),
            DocsApiFact(
              name: 'children',
              type: 'List<ElMenuChild>',
              description: "Required. DropdownMenuContent's own rows.",
            ),
            DocsApiFact(
              name: 'width',
              type: 'double?',
              description:
                  'Default null. An explicit w-* on the content. Null '
                  "falls back to minWidth's floor (ElMenu."
                  "minWidthDropdown, 160, when minWidth is also null).",
            ),
            DocsApiFact(
              name: 'align',
              type: 'ElPopoverAlign',
              description:
                  'Default ElPopoverAlign.start: the file\'s own default, '
                  'not ElPopover\'s own (ElPopoverAlign.center).',
            ),
            DocsApiFact(
              name: 'side',
              type: 'ElPopoverSide',
              description:
                  'Default ElPopoverSide.bottom. The sidebar\'s own '
                  'account trigger passes ElPopoverSide.right when there '
                  'is no room under a 256px panel.',
            ),
            DocsApiFact(
              name: 'enabled',
              type: 'bool',
              description:
                  'Default true. False keeps the popover permanently '
                  "closed and stops ElMenuPointerDown from forwarding the "
                  "trigger's own pointer-down at all.",
            ),
            DocsApiFact(
              name: 'sideOffset',
              type: 'static double (get)',
              description:
                  'el(1), 4px: one spacing unit under the trigger, edges '
                  'flush with align: start.',
            ),
            DocsApiFact(
              name: 'pressScaleSuppressed',
              type: 'static bool (get)',
              description:
                  'Always true. Every ElDropdownMenu trigger suppresses '
                  'the press-scale a plain button takes, matching '
                  'aria-haspopup\'s active:not-aria-[haspopup]:scale-95.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-menuitem',
        child: DocsApiTable(
          title: 'ElMenuItem',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'label',
              type: 'String',
              description: "Required. The row's text.",
            ),
            DocsApiFact(
              name: 'icon',
              type: 'ElIconGlyph?',
              description:
                  "The leading glyph, forced to ElMenu.iconSize (16px) "
                  'regardless of the icon\'s own default size.',
            ),
            DocsApiFact(
              name: 'lucideIcon',
              type: 'ElLucideGlyph?',
              description:
                  'The same leading slot over the generated lucide '
                  'registry, for a glyph icon does not carry. Ignored '
                  'when icon is also given.',
            ),
            DocsApiFact(
              name: 'subtitle',
              type: 'String?',
              description:
                  "A second line under label: gap-1, flex-col "
                  'items-start. Makes the row ElMenu.twoLineItemHeight '
                  'tall instead of ElMenu.itemHeight.',
            ),
            DocsApiFact(
              name: 'shortcut',
              type: 'String?',
              description:
                  'MenuShortcut\'s content: a key hint or a real value, '
                  'right-aligned, muted at rest.',
            ),
            DocsApiFact(
              name: 'variant',
              type: 'ElMenuItemVariant',
              description:
                  'Default ElMenuItemVariant.normal. destructive '
                  'recolours the label, icon and shortcut to '
                  'destructiveInk and tints the highlight instead of '
                  'using accent.',
            ),
            DocsApiFact(
              name: 'enabled',
              type: 'bool',
              description:
                  'Default true. False dims the row to ElMenu\'s '
                  'disabled opacity (0.50) and removes it from the '
                  'roving-focus and typeahead set entirely.',
            ),
            DocsApiFact(
              name: 'inset',
              type: 'bool',
              description:
                  'Default false. data-inset:pl-9: a 36px leading gutter '
                  'so an icon-less row can line up under rows that carry '
                  'one.',
            ),
            DocsApiFact(
              name: 'onSelect',
              type: 'VoidCallback?',
              description:
                  'Called on commit (tap, or Enter/Space while '
                  'highlighted); the menu closes immediately after.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-menucheckboxitem',
        child: DocsApiTable(
          title: 'ElMenuCheckboxItem',
          facts: <DocsApiFact>[
            DocsApiFact(name: 'label', type: 'String', description: 'Required.'),
            DocsApiFact(
              name: 'checked',
              type: 'bool',
              description:
                  "Required. The tick's ItemIndicator mounts only while "
                  'this is true: an unchecked row holds no indicator '
                  'element at all, not merely a hidden one.',
            ),
            DocsApiFact(
              name: 'enabled',
              type: 'bool',
              description: 'Default true. Same effect as ElMenuItem.enabled.',
            ),
            DocsApiFact(
              name: 'inset',
              type: 'bool',
              description: 'Default false.',
            ),
            DocsApiFact(
              name: 'onSelect',
              type: 'ValueChanged<bool>?',
              description:
                  'Called on commit with what the row would become '
                  '(!checked). The menu still closes after, even with '
                  'onSelect left null: a controlled row with no handler, '
                  'the same pattern ElSelect\'s own S4 precedent names.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-menuradioitem',
        child: DocsApiTable(
          title: 'ElMenuRadioItem',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'value',
              type: 'String',
              description: 'Required. What onChanged is called with.',
            ),
            DocsApiFact(name: 'label', type: 'String', description: 'Required.'),
            DocsApiFact(
              name: 'enabled',
              type: 'bool',
              description: 'Default true.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-menuradiogroup',
        child: DocsApiTable(
          title: 'ElMenuRadioGroup',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'value',
              type: 'String?',
              description:
                  'Which child\'s value wears the tick. Null shows no '
                  'row as checked.',
            ),
            DocsApiFact(
              name: 'children',
              type: 'List<ElMenuRadioItem>',
              description: 'Required.',
            ),
            DocsApiFact(
              name: 'onChanged',
              type: 'ValueChanged<String>?',
              description:
                  'Called on commit with the tapped row\'s value. Null is '
                  'the same controlled-no-handler shape as '
                  'ElMenuCheckboxItem.onSelect.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-menulabel',
        child: DocsApiTable(
          title: 'ElMenuLabel',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'text',
              type: 'String',
              description: 'Required, positional. Ignored when child is given.',
            ),
            DocsApiFact(
              name: 'child',
              type: 'Widget?',
              description:
                  "The label's own children for a multi-line block (a "
                  'name over a caption). Still sits inside the label\'s '
                  'own px-3 py-2.',
            ),
            DocsApiFact(
              name: 'inset',
              type: 'bool',
              description: 'Default false.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-menuseparator',
        child: DocsApiTable(
          title: 'ElMenuSeparator',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: '(none)',
              type: '—',
              description:
                  'Takes no constructor parameters at all — const '
                  'ElMenuSeparator() is the whole of it. Paints a single '
                  '1px rule at ElMenu.separatorHeight (17), running the '
                  'full content width by cancelling the content\'s own '
                  'p-2 with a negative margin.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-menugroup',
        child: DocsApiTable(
          title: 'ElMenuGroup',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'children',
              type: 'List<ElMenuChild>',
              description:
                  "Required. A role=\"group\" wrapper that paints "
                  'nothing: its rows sit flush with the rows outside it, '
                  'with no gap of its own.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-menusub',
        child: DocsApiTable(
          title: 'ElMenuSub',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'label',
              type: 'String',
              description: "Required. The sub-trigger row's text.",
            ),
            DocsApiFact(
              name: 'children',
              type: 'List<ElMenuChild>',
              description: "Required. The submenu's own rows.",
            ),
            DocsApiFact(
              name: 'icon',
              type: 'ElIconGlyph?',
              description: "The sub-trigger's own leading glyph.",
            ),
            DocsApiFact(
              name: 'enabled',
              type: 'bool',
              description: 'Default true.',
            ),
            DocsApiFact(
              name: 'inset',
              type: 'bool',
              description: 'Default false.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-menucontent',
        child: DocsApiTable(
          title: 'ElMenuContent',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'children',
              type: 'List<ElMenuChild>',
              description: 'Required.',
            ),
            DocsApiFact(
              name: 'onClose',
              type: 'VoidCallback',
              description:
                  'Required. Dismisses the whole menu: a committed row, '
                  'Escape at the top level, or a pointer outside.',
            ),
            DocsApiFact(
              name: 'width',
              type: 'double?',
              description: 'An explicit w-* on this content.',
            ),
            DocsApiFact(
              name: 'minWidth',
              type: 'double?',
              description:
                  'Null takes ElMenu.minWidthMenu (144). ElDropdownMenu '
                  'itself always passes ElMenu.minWidthDropdown (160) '
                  'here.',
            ),
            DocsApiFact(
              name: 'kind',
              type: 'ElMenuSurfaceKind',
              description:
                  'Default ElMenuSurfaceKind.content: see the '
                  'ElMenuSurfaceKind table below for what a submenu '
                  'actually resolves to.',
            ),
            DocsApiFact(
              name: 'indicatorSide',
              type: 'ElMenuIndicatorSide',
              description:
                  'Default ElMenuIndicatorSide.end. ElDropdownMenu never '
                  'overrides this: start is reachable only from a '
                  'menubar, documented here because it is declared in '
                  'this same file.',
            ),
            DocsApiFact(
              name: 'autofocus',
              type: 'bool',
              description:
                  'Default true. False for a submenu opened by hover: '
                  'the keyboard stays on the parent\'s trigger until '
                  'ArrowRight or Enter promotes it.',
            ),
            DocsApiFact(
              name: 'initialHighlight',
              type: 'int',
              description:
                  'Default -1, Radix\'s own "nothing focused yet". '
                  'ElDropdownMenu never overrides this either.',
            ),
            DocsApiFact(
              name: 'onEscape',
              type: 'VoidCallback?',
              description:
                  'Escape while this content has focus. Null routes to '
                  'onClose; a submenu passes its own so Escape closes '
                  'exactly one level.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-menusurface',
        child: DocsApiTable(
          title: 'ElMenuSurface',
          facts: <DocsApiFact>[
            DocsApiFact(name: 'child', type: 'Widget', description: 'Required.'),
            DocsApiFact(
              name: 'kind',
              type: 'ElMenuSurfaceKind',
              description: 'Default ElMenuSurfaceKind.content.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-menupointerdown',
        child: DocsApiTable(
          title: 'ElMenuPointerDown',
          facts: <DocsApiFact>[
            DocsApiFact(name: 'child', type: 'Widget', description: 'Required.'),
            DocsApiFact(
              name: 'onPointerDown',
              type: 'VoidCallback',
              description:
                  'Required. Fired on a raw PointerDownEvent, never on a '
                  'tap, a click, or a keyboard activation.',
            ),
            DocsApiFact(
              name: 'enabled',
              type: 'bool',
              description: 'Default true. False renders child untouched.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-menumotion',
        child: DocsApiTable(
          title: 'ElMenuMotion',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'duration',
              type: 'static Duration (get)',
              description: 'ElDurations.overlay, 320ms.',
            ),
            DocsApiFact(
              name: 'slideSides',
              type: 'static Set<ElPopoverSide> (get)',
              description:
                  'All four ElPopoverSide values: the overlay slides in '
                  'from whichever side it actually lands on.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-menu',
        child: DocsApiTable(
          title: 'ElMenu: static geometry',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'itemHeight',
              type: 'static double (get)',
              description: 'py-2 around one text-sm line box, 34.5714.',
            ),
            DocsApiFact(
              name: 'twoLineItemHeight',
              type: 'static double (get)',
              description:
                  'A row carrying subtitle, 52.7464 (itemHeight + gap-1 '
                  '+ a caption line box).',
            ),
            DocsApiFact(
              name: 'labelHeight',
              type: 'static double (get)',
              description: 'ElMenuLabel\'s own row, 32.',
            ),
            DocsApiFact(
              name: 'separatorHeight',
              type: 'static double (get)',
              description: 'my-2 h-px, 17.',
            ),
            DocsApiFact(
              name: 'contentPadding',
              type: 'static double (get)',
              description: 'p-2 on the content box, 8.',
            ),
            DocsApiFact(
              name: 'minWidthDropdown',
              type: 'static double (get)',
              description: 'min-w-40, 160.',
            ),
            DocsApiFact(
              name: 'minWidthMenu',
              type: 'static double (get)',
              description: 'min-w-36, 144.',
            ),
            DocsApiFact(
              name: 'minWidthSub',
              type: 'static double (get)',
              description: 'min-w-40, 160, unreachable from this page.',
            ),
            DocsApiFact(
              name: 'minWidthSubDropdown',
              type: 'static double (get)',
              description:
                  'min-w-24, 96, the one dropdown-specific sub-content '
                  'floor. Unreachable from this page\'s own specimen (no '
                  'dropdown submenu passes it).',
            ),
            DocsApiFact(
              name: 'insetPadding',
              type: 'static double (get)',
              description: 'data-inset:pl-9, 36.',
            ),
            DocsApiFact(
              name: 'iconSize',
              type: 'static double (get)',
              description: 'Every row icon is forced into this box, 16.',
            ),
            DocsApiFact(
              name: 'iconStroke',
              type: 'static double (get)',
              description:
                  'The stroke width a size="sm" icon derives, kept while '
                  'iconSize overrules the box itself.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-menuitemvariant',
        child: DocsApiTable(
          title: 'ElMenuItemVariant',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'normal',
              type: 'ElMenuItemVariant',
              description:
                  'The default. accent fill, popoverForeground ink.',
            ),
            DocsApiFact(
              name: 'destructive',
              type: 'ElMenuItemVariant',
              description:
                  'destructiveInk label/icon/shortcut in every state; a '
                  'highlighted row tints with destructive at 10% (light) '
                  '/ 20% (dark) instead of accent.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-menuindicatorside',
        child: DocsApiTable(
          title: 'ElMenuIndicatorSide',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'end',
              type: 'ElMenuIndicatorSide',
              description:
                  'py-2 pr-9 pl-3, tick at right-3. What every row this '
                  'page\'s specimen renders uses, ElDropdownMenu never '
                  'changes ElMenuContent\'s own end default.',
            ),
            DocsApiFact(
              name: 'start',
              type: 'ElMenuIndicatorSide',
              description:
                  'py-2 pr-3 pl-9, tick at left-1.5: the menubar\'s own '
                  'mirror image, alone. Declared here because it lives '
                  'in menu.dart; not reachable from ElDropdownMenu '
                  'itself.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-menusurfacekind',
        child: DocsApiTable(
          title: 'ElMenuSurfaceKind',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'content',
              type: 'ElMenuSurfaceKind',
              description:
                  'shadow-md ring-1 ring-foreground/10: what every '
                  'top-level ElMenuContent renders with, ElDropdownMenu\'s '
                  'own content included.',
            ),
            DocsApiFact(
              name: 'subRinged',
              type: 'ElMenuSurfaceKind',
              description:
                  'shadow-lg ring-1 ring-foreground/10. Declared, and '
                  'reachable if a caller builds ElMenuContent directly '
                  'and passes it: but nothing in this file ever does.',
            ),
            DocsApiFact(
              name: 'subBordered',
              type: 'ElMenuSurfaceKind',
              description:
                  'shadow-lg border, no ring. What a ElDropdownMenu '
                  'submenu actually renders with — GAP: menu.dart\'s own '
                  'DRIFT-4 comment table names DropdownMenuSubContent as '
                  'subRinged, but _buildRow\'s ElMenuSub case maps ANY '
                  'content-kind parent to subBordered, and '
                  'ElDropdownMenu never passes a kind override away from '
                  'that content default. A live test on this page opens '
                  'the Preview specimen\'s "Invite users" submenu and '
                  'reads the mounted ElMenuSurface.kind back as '
                  'subBordered, pinning this as observed behaviour '
                  'rather than a reading of the comment.',
            ),
          ],
        ),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const _A11yRow(
        'Semantic role',
        'The open menu itself carries no Semantics container, role, or '
            'label of its own: no equivalent of role="menu", and no '
            'aria-activedescendant relationship. Only individual rows '
            'carry real semantics: Semantics(button: true, selected: '
            'checked, enabled: enabled, label: ...) from _MenuRow in '
            'menu.dart.',
      ),
      const _A11yRow(
        'Required labels',
        'A row\'s accessible name is its own label text (and subtitle, '
            'concatenated, on a two-line row). The trigger\'s accessible '
            'name is whatever ElButton.label the caller supplies: '
            'nothing here supplies one automatically.',
      ),
      const _A11yRow(
        'Focus behavior',
        'ElMenuContent takes focus itself the frame after it mounts '
            '(autofocus: true by default: false only for a submenu '
            'opened by hover, until ArrowRight or Enter promotes it). '
            'Nothing in either file returns focus to the trigger when '
            'the menu closes: the only two requestFocus calls in '
            'menu.dart are that initial autofocus, and moving focus '
            'back to a parent submenu\'s own content when one level '
            'closes: neither reaches back out to the original trigger '
            'widget.',
      ),
      const _A11yRow(
        'Touch target',
        'ElMenu.itemHeight is ≈34.57px: below the 44 / 48px baseline '
            'most touch-target guidance names: and is not configurable '
            'per row or per instance.',
      ),
      const _A11yRow(
        'Non-color signal',
        'A checked row pairs its tick with the row\'s own label text, '
            'never color alone. A destructive row pairs its tint with '
            'destructiveInk text and the word itself ("Log out", '
            '"Delete"), not a colour shift on its own.',
      ),
      const _A11yRow(
        'Error wiring',
        'None: no row in either file participates in form validation or '
            'an error state.',
      ),
      const _A11yRow(
        'Screen-reader announcements',
        'Opening or closing the menu announces nothing as an event: '
            'there is no scoped route/live-region behaviour. Individual '
            'rows are real Semantics nodes and are swipe-discoverable '
            'once the menu is open, but the keyboard-open gap the '
            'Keyboard section names means a keyboard-only screen-reader '
            'user may never reach that point in the first place.',
      ),
      _A11yRow(
        'Known platform differences',
        'None observed in the paint or gesture logic: the open '
            'mechanism is routed by raw pointer events, not by platform, '
            'and behaves identically on a touch tap and a mouse click.',
        last: true,
      ),
    ],
  );
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const _A11yRow(
        'Once the menu is open',
        'ArrowDown / ArrowUp move the highlight one row; Home / End '
            'jump to the first / last: none of them wrap, unlike '
            'ElSelect\'s own menu. ArrowRight opens a highlighted '
            'sub-trigger\'s submenu and focuses its first row; ArrowLeft '
            'closes one submenu level and returns focus to its trigger. '
            'Enter, NumpadEnter and Space commit the highlighted row. '
            'Escape closes one submenu level, or the whole menu at the '
            'top level. Tab closes the whole menu outright, rather than '
            'moving focus onward the way Tab ordinarily does. Any '
            'single printable character drives real typeahead: it jumps '
            'to the next row whose text starts with what was typed, '
            'repeated presses of one letter cycle through every match, '
            'and the buffer resets after 1 second idle.',
      ),
      _A11yRow(
        'Opening the menu',
        'GAP: Enter or Space on a focused trigger does not open the '
            'menu: only a real pointer down does. ElMenuPointerDown is a '
            'bare Listener that reacts exclusively to PointerDownEvent; '
            'a ElButton\'s own keyboard activation (ElButton._onKey, on '
            'Enter/Space) calls the trigger\'s own onPressed directly '
            'and never touches that Listener. Every real call site — '
            'this page\'s own specimen included — leaves that onPressed '
            'a no-op, because the actual open mechanism lives one '
            'widget above it. By the same mechanism, an assistive '
            'activation that also routes through Semantics\' tap action '
            'rather than a literal pointer contact — VoiceOver or '
            'TalkBack\'s double-tap-to-activate, external switch '
            'control — would call the same no-op and not open the menu '
            'either; that inference follows from the same source read '
            'rather than from testing against a real screen reader in '
            'this environment. Pinned by a live test that requests '
            'focus on the trigger\'s real FocusNode and sends Enter '
            'directly.',
        last: true,
      ),
    ],
  );
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'A submenu\'s hover-open path (100ms after the pointer enters '
            'its trigger) has no touch equivalent: there is no hover on '
            'a touch screen: but every ElMenuSub row also carries a '
            'real onTap that opens it directly, so a tap reaches the '
            'same submenu a mouse hover does, just without the dwell.',
        'Row height (ElMenu.itemHeight, ≈34.57px), the content\'s '
            'min-width floor (ElMenu.minWidthDropdown, 160), and every '
            'other geometry constant are fixed values — none scale with '
            'platform, density, or text-scale settings.',
        'ElPopover\'s own collision handling (not part of this file) is '
            'what keeps the popup on-screen when the trigger sits near '
            'a viewport edge: nothing in dropdown_menu.dart or menu.dart '
            'repeats that logic.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        facts: <DocsInstallFact>[
          const DocsInstallFact(
            label: 'Registry item',
            value: 'registry/components/dropdown-menu.json',
            description:
                'Ships and resolves registryDependencies button, menu, '
                'popover, source-foundation automatically: elattar add '
                'dropdown-menu installs both files together.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value:
                'lib/components/ui/dropdown_menu.dart, '
                'lib/components/ui/menu.dart',
            description:
                'The same lib/components/ui/ target every component '
                'installs to, in both foundation modes.',
          ),
          const DocsInstallFact(
            label: 'Foundation',
            value: 'source or package compatible',
            description:
                'Nothing observed in either file is package-mode-only.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: dropdownMenuDoc.dependencies.join(', '),
            description:
                "The manifest's own registryDependencies, resolved "
                'automatically by the registry client — button.dart and '
                'popover.dart from dropdown_menu.dart, and icon.dart '
                '(plus the generated icon_paths files) and popover.dart '
                'from menu.dart.',
          ),
          const DocsInstallFact(
            label: 'Assets',
            value: 'none',
            description: 'No image, font, or shader asset is referenced.',
          ),
          const DocsInstallFact(
            label: 'Shaders',
            value: 'none',
            description: 'Not applicable.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description: 'Pure widget composition; nothing platform-gated.',
          ),
          const DocsInstallFact(
            label: 'Verified',
            value: 'package tests + this docs specimen',
            description:
                'test/menus_test.dart\'s ElMenu geometry and '
                'ElDropdownMenu groups, plus this page\'s own live open '
                '/ activate / dismiss / keyboard-gap / submenu-surface '
                'specimens.',
          ),
        ],
      ),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Popover', route: '/components/popover'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElMenuSurface wraps ElPopoverSurface, so the content\'s fill '
            'and ink are theme.popover / theme.popoverForeground: the '
            'same pairing every popover-family surface uses, not a '
            'menu-specific pair.',
        'A highlighted normal row fills with theme.accent and inks '
            'with theme.accentForeground. A highlighted destructive row '
            'instead fills with theme.destructive at 10% alpha on '
            'light / 20% on dark, and keeps theme.destructiveInk for '
            'its label, icon and shortcut in every state, not only '
            'while highlighted.',
        'theme.border draws every separator; theme.mutedForeground '
            'draws a label\'s text, a row\'s subtitle, and a shortcut '
            'at rest. Nothing here reads a value or surface variant, '
            'ElMenuItem carries no such parameter.',
        'The elevation recipe (ElMenuSurfaceKind) is the one part of '
            'the surface that is not purely color — see the '
            'ElMenuSurfaceKind table in API Reference for what a '
            'ElDropdownMenu submenu actually renders with.',
      ]);
}

Widget _bullets(ElThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText('•  $line', ElType.small, color: theme.mutedForeground),
      ),
      SizedBox(height: el(2)),
    ],
  ],
);

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment: 'ElMenuContent is not mounted; only the trigger renders.',
    userSignal: 'Nothing besides the trigger is on screen.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        'A pointer resting on a row snaps: transition-duration: 0s in '
        'the source: to theme.accent fill and theme.accentForeground '
        'ink, recolouring the icon and shortcut too. Resting on a '
        'sub-trigger additionally schedules its submenu to open 100ms '
        'later.',
    userSignal: 'The row highlights instantly, no fade.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'There is no per-row FocusNode and no separate focus ring: one '
        'Focus wraps the whole content, and a roving _highlighted index '
        '(ArrowUp/Down/Home/End, no wrap) paints the identical accent '
        'fill hover uses. A keyboard-highlighted row and a '
        'pointer-hovered row are visually identical.',
    userSignal: 'Same highlight as Hover, moved by the keyboard.',
  ),
  DocsStateFact(
    state: 'Pressed',
    treatment:
        'A row commits on a normal GestureDetector tap (release, not '
        'pointer-down): unlike the trigger itself, which opens on '
        'pointer-down. No row carries a separate pressed visual beyond '
        'the highlight it already has.',
    userSignal: 'onSelect fires and the menu closes, no extra dip.',
  ),
  DocsStateFact(
    state: 'Selected',
    treatment:
        'A checked ElMenuCheckboxItem or the active ElMenuRadioItem '
        'mounts a real check glyph inside its own Stack; an unchecked '
        'row holds no indicator element at all, not merely a hidden '
        'one.',
    userSignal: 'A 16px tick appears in the row\'s gutter.',
  ),
  DocsStateFact(
    state: 'Loading',
    treatment:
        'N/A: onSelect / onChanged are synchronous callbacks; the API '
        'has no async or loading affordance anywhere in either file.',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Empty',
    treatment:
        'Not a designed state rather than a guarded one, children: '
        '<ElMenuChild>[] renders a popup that is only its own p-2 '
        'twice (16px), with no placeholder.',
    userSignal: 'A near-empty 16px popup, with no explanation.',
  ),
  DocsStateFact(
    state: 'Error',
    treatment: 'N/A: no validation or error concept exists in either file.',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Success',
    treatment: 'N/A: no async outcome to confirm.',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'ElDropdownMenu.enabled: false keeps _isOpen permanently false '
        'and stops ElMenuPointerDown forwarding the trigger\'s '
        'pointer-down at all. Per-row enabled: false instead dims just '
        'that row to 0.50 opacity and drops it from the roving-focus '
        'and typeahead set.',
    userSignal:
        'A disabled root never opens; a disabled row is dim and inert '
        'but its siblings still work.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'ElPopover resolves its 320ms enter/exit through '
        'elAnimationDuration(context, ElDurations.overlay), so reduced '
        'motion collapses it. The per-row highlight was already an '
        'instant snap (0s) with nothing to reduce.',
    userSignal:
        'The menu still opens and closes, just without animated travel.',
  ),
];
