/// Public documentation page for the `menu` component.
///
/// **Not a control a reader places directly.** `lib/src/components/ui/
/// menu.dart`'s own library doc opens with it: *"The shared body of
/// `dropdown-menu.tsx`, `context-menu.tsx` and `menubar.tsx` — three files,
/// one Radix `Menu`, one set of rows."* Every `*Content`, `*Item`, `*Label`,
/// `*Separator`, `*Shortcut`, `*CheckboxItem`, `*RadioItem`, `*Sub*` across
/// the three reference files is the same element with the same class list
/// under a different `data-slot`; `menu.dart` is that shared half — the row
/// model, the geometry, the surface, the keyboard — and `dropdown_menu.dart`,
/// `context_menu.dart` and `menubar.dart` are the three roots that place it.
/// Each of those three already has its own documentation page; this page is
/// the engine underneath all three, and its Dependencies disclosure links
/// out to each of them rather than repeating their content.
///
/// **Section order**, matching the house shape: Preview (the shared surface
/// configured exactly as each of the three consumers configures it, side by
/// side), Installation, Usage (the smallest correct `MenuContent`), Row
/// kinds (one of every `MenuChild` case), Surface kinds (the three
/// elevation recipes `MenuSurfaceVariant` declares), Indicator side (the
/// documented drift between a check row's tick on the end and on the
/// start), then the eight disclosures. Keyboard sits between Accessibility
/// and Responsive, read directly off `_MenuContentState._onKey`.
///
/// **Do not invent behaviour.** Every fact below is read off
/// `lib/src/components/ui/menu.dart` itself — including the two DOCUMENTED
/// DRIFTs the source already names (menus drift 4: the three elevation
/// recipes; menus drift 5: the indicator side) and the submenu-kind gap
/// (`_buildRow`'s `MenuSub` case maps every `content`-kind parent to
/// `subBordered`, regardless of which of the three consumers is asking, so
/// `menu.dart`'s own DRIFT-4 comment table promising `subRinged` for a
/// dropdown's or a menubar's own submenu is not what the code does for any
/// of the three).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec menuDocSpec = ComponentDocSpec(
  name: 'menu',
  title: menuDoc.title,
  description: menuDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The same MenuContent, configured exactly as each of the '
          'three consumers configures it: a dropdown menu (minWidth 160, '
          'indicatorSide.end), a context menu (minWidth 144, a submenu '
          'row), and a menubar (minWidth 144, indicatorSide.start — the '
          'drift). None of these are portals: this is the engine mounted '
          'directly, not opened from a trigger.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: space(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'menu has a real registry manifest: elattar add menu installs '
          'lib/src/components/ui/menu.dart and resolves icon, popover, and '
          'source-foundation automatically. A reader almost never installs '
          'menu directly: elattar add dropdown-menu, elattar add '
          'context-menu, and elattar add menubar each resolve it as a '
          'registryDependency on their own. The Manual tab is for a '
          'project not using the CLI.',
      command: menuDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/menu.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/menu.dart's generated "
              '@ui/menu.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated menu source here when using manual '
              'mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so MenuContent and the rest of the '
              'row model are reachable the same way the CLI path already '
              'makes them.',
          code: "export 'menu.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'MenuContent is never placed on its own: a trigger root — a '
          'popover anchored to a button, a pointer position, or a menubar '
          'strip — decides where it opens and hands it onClose. This is '
          'the smallest correct content list; dropdown_menu, context_menu '
          'and menubar each show the trigger half.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'row-kinds',
      title: 'Row kinds',
      description:
          'Every case MenuChild is sealed over, in one content: a '
          'label, a group of plain items (one with an icon and a '
          'shortcut), a checkbox item, a radio group, a separator, a '
          'submenu (hover it, or focus and press ArrowRight), and a '
          'destructive item last.',
      specimen: _RowKindsSpecimen(),
      code: _rowKindsCode,
      label: 'Row kinds specimen view',
      minHeight: space(160),
    ),
    ShowcaseSection(
      id: 'surface-kinds',
      title: 'Surface kinds',
      description:
          'DOCUMENTED DRIFT (menus drift 4): the three elevation recipes '
          'MenuSurfaceVariant declares are not one recipe reused three '
          'ways. content is shadow-md; subRinged and subBordered are '
          'both shadow-lg, but only subBordered adds a real 1px border '
          'and drops the ring — 2px taller than either of the other two '
          'for the same content, because a border adds to the box and a '
          'ring does not.',
      specimen: _SurfaceKindsSpecimen(),
      code: _surfaceKindsCode,
      label: 'Surface kinds specimen view',
    ),
    ShowcaseSection(
      id: 'indicator-side',
      title: 'Indicator side',
      description:
          'DOCUMENTED DRIFT (menus drift 5): a checked row\'s tick sits '
          'on the right in a dropdown and a context menu '
          '(MenuIndicatorSide.end, the MenuContent default) and on '
          'the left in a menubar alone (MenuIndicatorSide.start) — one '
          'role, two mirror images, three files.',
      specimen: _IndicatorSideSpecimen(),
      code: _indicatorSideCode,
      label: 'Indicator side specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter every one of menu\'s seventeen '
          'exports declares: the row model first, then the geometry and '
          'surface, then the open content and the two shared primitives '
          'every trigger root reaches for.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'MenuItem', anchor: 'api-elmenuitem'),
        DocsTocEntry(title: 'MenuItemVariant', anchor: 'api-elmenuitemvariant'),
        DocsTocEntry(
          title: 'MenuCheckboxItem',
          anchor: 'api-elmenucheckboxitem',
        ),
        DocsTocEntry(title: 'MenuRadioItem', anchor: 'api-elmenuradioitem'),
        DocsTocEntry(title: 'MenuRadioGroup', anchor: 'api-elmenuradiogroup'),
        DocsTocEntry(title: 'MenuLabel', anchor: 'api-elmenulabel'),
        DocsTocEntry(title: 'MenuSeparator', anchor: 'api-elmenuseparator'),
        DocsTocEntry(title: 'MenuGroup', anchor: 'api-elmenugroup'),
        DocsTocEntry(title: 'MenuSub', anchor: 'api-elmenusub'),
        DocsTocEntry(
          title: 'MenuIndicatorSide',
          anchor: 'api-elmenuindicatorside',
        ),
        DocsTocEntry(
          title: 'MenuSurfaceVariant',
          anchor: 'api-elmenusurfacekind',
        ),
        DocsTocEntry(title: 'Menu', anchor: 'api-elmenu'),
        DocsTocEntry(title: 'MenuSurface', anchor: 'api-elmenusurface'),
        DocsTocEntry(title: 'MenuContent', anchor: 'api-elmenucontent'),
        DocsTocEntry(title: 'MenuPointerDown', anchor: 'api-elmenupointerdown'),
        DocsTocEntry(title: 'MenuMotion', anchor: 'api-elmenumotion'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off _MenuRow.build and _MenuContentState, not '
          'inferred: a row does not transition at all, it snaps.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'Read directly off _MenuContentState._onKey: every key it '
          'switches on, and what falls through to the default (default '
          'left ignored, so a menubar strip and a submenu\'s own parent '
          'can claim it instead).',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
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
            label: 'Source',
            value: menuDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/menu_test.dart',
            description: 'MenuContent and the row model are covered there.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/menu_test.dart',
            description:
                'Covers this page: the article mounts, every export\'s '
                'constructor parameters this page claims to document, and '
                'both themes at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/menu/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class MenuDocPage extends StatelessWidget {
  const MenuDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: menuDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / OVERLAYS',
      title: menuDoc.title,
      description: menuDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Menu'),
    ],
    toc: menuDocSpec.toc,
    previous: const DocsPageLink(title: 'Marker', route: '/components/marker'),
    next: const DocsPageLink(title: 'Menubar', route: '/components/menubar'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('menu-doc-article'),
      child: ComponentDocPage(spec: menuDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  String _lastAction = 'Nothing yet';
  bool _dropdownChecked = true;
  bool _menubarChecked = false;
  String _menubarRadio = 'grid';

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _labelled(
                theme,
                'As a dropdown menu',
                KeyedSubtree(
                  key: const ValueKey<String>('menu-preview:dropdown'),
                  child: MenuContent(
                    minWidth: Menu.minWidthDropdown,
                    children: <MenuChild>[
                      const MenuLabel('My Account'),
                      const MenuSeparator(),
                      MenuGroup(
                        children: <MenuChild>[
                          MenuItem(
                            label: 'Profile',
                            icon: IconGlyph.user,
                            shortcut: '⇧⌘P',
                            onSelect: () =>
                                setState(() => _lastAction = 'Profile'),
                          ),
                          MenuItem(
                            label: 'Settings',
                            icon: IconGlyph.settings,
                            onSelect: () =>
                                setState(() => _lastAction = 'Settings'),
                          ),
                        ],
                      ),
                      const MenuSeparator(),
                      MenuCheckboxItem(
                        label: 'Show sidebar',
                        checked: _dropdownChecked,
                        onSelect: (bool next) =>
                            setState(() => _dropdownChecked = next),
                      ),
                      const MenuSeparator(),
                      MenuItem(
                        label: 'Log out',
                        variant: MenuItemVariant.destructive,
                        onSelect: () => setState(() => _lastAction = 'Log out'),
                      ),
                    ],
                    onClose: () {},
                  ),
                ),
              ),
              SizedBox(width: space(5)),
              _labelled(
                theme,
                'As a context menu',
                KeyedSubtree(
                  key: const ValueKey<String>('menu-preview:context'),
                  child: MenuContent(
                    minWidth: Menu.minWidthMenu,
                    children: <MenuChild>[
                      MenuItem(
                        label: 'Back',
                        shortcut: '⌘[',
                        onSelect: () => setState(() => _lastAction = 'Back'),
                      ),
                      const MenuItem(label: 'Forward', enabled: false),
                      const MenuSeparator(),
                      MenuSub(
                        label: 'Share',
                        icon: IconGlyph.share2,
                        children: <MenuChild>[
                          MenuItem(
                            label: 'Copy link',
                            onSelect: () =>
                                setState(() => _lastAction = 'Copy link'),
                          ),
                          MenuItem(
                            label: 'Email',
                            onSelect: () =>
                                setState(() => _lastAction = 'Email'),
                          ),
                        ],
                      ),
                    ],
                    onClose: () {},
                  ),
                ),
              ),
              SizedBox(width: space(5)),
              _labelled(
                theme,
                'As a menubar (indicatorSide.start)',
                KeyedSubtree(
                  key: const ValueKey<String>('menu-preview:menubar'),
                  child: MenuContent(
                    minWidth: Menu.minWidthMenu,
                    indicatorSide: MenuIndicatorSide.start,
                    children: <MenuChild>[
                      MenuCheckboxItem(
                        label: 'Always show bookmarks',
                        checked: _menubarChecked,
                        onSelect: (bool next) =>
                            setState(() => _menubarChecked = next),
                      ),
                      const MenuSeparator(),
                      MenuRadioGroup(
                        value: _menubarRadio,
                        onChanged: (String next) =>
                            setState(() => _menubarRadio = next),
                        children: const <MenuRadioItem>[
                          MenuRadioItem(value: 'grid', label: 'Grid view'),
                          MenuRadioItem(value: 'list', label: 'List view'),
                        ],
                      ),
                    ],
                    onClose: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: space(4)),
        StyledText(
          'Last action: $_lastAction',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }

  Widget _labelled(ThemeTokens theme, String caption, Widget child) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      StyledText(caption, TextStyles.section, color: theme.mutedForeground),
      SizedBox(height: space(2)),
      child,
    ],
  );
}

const String _previewCode =
    '''// As a dropdown: minWidth 160, the MenuContent default indicatorSide.end.
MenuContent(
  minWidth: Menu.minWidthDropdown,
  children: [
    MenuLabel('My Account'),
    MenuSeparator(),
    MenuGroup(children: [
      MenuItem(label: 'Profile', icon: IconGlyph.user, shortcut: '⇧⌘P'),
      MenuItem(label: 'Settings', icon: IconGlyph.settings),
    ]),
    MenuSeparator(),
    MenuCheckboxItem(label: 'Show sidebar', checked: showSidebar,
        onSelect: (next) => setState(() => showSidebar = next)),
    MenuSeparator(),
    MenuItem(label: 'Log out', variant: MenuItemVariant.destructive),
  ],
  onClose: close,
)

// As a menubar: minWidth 144, indicatorSide.start — the drift.
MenuContent(
  minWidth: Menu.minWidthMenu,
  indicatorSide: MenuIndicatorSide.start,
  children: [
    MenuCheckboxItem(label: 'Always show bookmarks', checked: shown,
        onSelect: (next) => setState(() => shown = next)),
    MenuSeparator(),
    MenuRadioGroup(value: view, onChanged: onViewChanged, children: [
      MenuRadioItem(value: 'grid', label: 'Grid view'),
      MenuRadioItem(value: 'list', label: 'List view'),
    ]),
  ],
  onClose: close,
)''';

const String _usageCode = '''MenuContent(
  children: const <MenuChild>[
    MenuItem(label: 'Settings', shortcut: '⌘,'),
    MenuSeparator(),
    MenuItem(label: 'Log out', variant: MenuItemVariant.destructive),
  ],
  onClose: close,
)''';

class _RowKindsSpecimen extends StatefulWidget {
  const _RowKindsSpecimen();

  @override
  State<_RowKindsSpecimen> createState() => _RowKindsSpecimenState();
}

class _RowKindsSpecimenState extends State<_RowKindsSpecimen> {
  bool _checked = true;
  String _radio = 'a';

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('menu-example:row-kinds'),
    child: MenuContent(
      children: <MenuChild>[
        const MenuLabel('Row kinds'),
        const MenuSeparator(),
        MenuGroup(
          children: <MenuChild>[
            const MenuItem(label: 'A plain item'),
            MenuItem(
              label: 'With icon and shortcut',
              icon: IconGlyph.star,
              shortcut: '⌘K',
            ),
          ],
        ),
        MenuCheckboxItem(
          label: 'A checkbox item',
          checked: _checked,
          onSelect: (bool next) => setState(() => _checked = next),
        ),
        MenuRadioGroup(
          value: _radio,
          onChanged: (String next) => setState(() => _radio = next),
          children: const <MenuRadioItem>[
            MenuRadioItem(value: 'a', label: 'Radio A'),
            MenuRadioItem(value: 'b', label: 'Radio B'),
          ],
        ),
        const MenuSeparator(),
        const MenuSub(
          label: 'A submenu',
          children: <MenuChild>[
            MenuItem(label: 'One level deep'),
            MenuItem(label: 'Anything deeper belongs in a dialog'),
          ],
        ),
        const MenuSeparator(),
        const MenuItem(
          label: 'A destructive item',
          variant: MenuItemVariant.destructive,
        ),
      ],
      onClose: () {},
    ),
  );
}

const String _rowKindsCode = '''MenuContent(
  children: const <MenuChild>[
    MenuLabel('Row kinds'),
    MenuSeparator(),
    MenuGroup(children: [
      MenuItem(label: 'A plain item'),
      MenuItem(label: 'With icon and shortcut', icon: IconGlyph.star, shortcut: '⌘K'),
    ]),
    MenuCheckboxItem(label: 'A checkbox item', checked: checked, onSelect: onCheck),
    MenuRadioGroup(value: radio, onChanged: onRadio, children: [
      MenuRadioItem(value: 'a', label: 'Radio A'),
      MenuRadioItem(value: 'b', label: 'Radio B'),
    ]),
    MenuSeparator(),
    MenuSub(label: 'A submenu', children: [
      MenuItem(label: 'One level deep'),
    ]),
    MenuSeparator(),
    MenuItem(label: 'A destructive item', variant: MenuItemVariant.destructive),
  ],
  onClose: close,
)''';

class _SurfaceKindsSpecimen extends StatelessWidget {
  const _SurfaceKindsSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    Widget sample(String caption, MenuSurfaceVariant kind) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText(caption, TextStyles.section, color: theme.mutedForeground),
        SizedBox(height: space(2)),
        MenuSurface(
          kind: kind,
          child: Padding(
            padding: EdgeInsets.all(space(4)),
            child: StyledText('Sample content', TextStyles.bodyCompact),
          ),
        ),
      ],
    );
    return Wrap(
      spacing: space(5),
      runSpacing: space(5),
      children: <Widget>[
        sample('content — shadow-md, ring', MenuSurfaceVariant.content),
        sample('subRinged — shadow-lg, ring', MenuSurfaceVariant.subRinged),
        sample(
          'subBordered — shadow-lg, border',
          MenuSurfaceVariant.subBordered,
        ),
      ],
    );
  }
}

const String _surfaceKindsCode =
    '''MenuSurface(kind: MenuSurfaceVariant.content, child: content)
MenuSurface(kind: MenuSurfaceVariant.subRinged, child: content)
MenuSurface(kind: MenuSurfaceVariant.subBordered, child: content)''';

class _IndicatorSideSpecimen extends StatefulWidget {
  const _IndicatorSideSpecimen();

  @override
  State<_IndicatorSideSpecimen> createState() => _IndicatorSideSpecimenState();
}

class _IndicatorSideSpecimenState extends State<_IndicatorSideSpecimen> {
  bool _endChecked = true;
  bool _startChecked = true;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Wrap(
      spacing: space(5),
      runSpacing: space(5),
      crossAxisAlignment: WrapCrossAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StyledText(
              'end — dropdown & context menu',
              TextStyles.section,
              color: theme.mutedForeground,
            ),
            SizedBox(height: space(2)),
            MenuContent(
              minWidth: Menu.minWidthMenu,
              children: <MenuChild>[
                MenuCheckboxItem(
                  label: 'Word wrap',
                  checked: _endChecked,
                  onSelect: (bool next) => setState(() => _endChecked = next),
                ),
              ],
              onClose: () {},
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StyledText(
              'start — menubar, alone',
              TextStyles.section,
              color: theme.mutedForeground,
            ),
            SizedBox(height: space(2)),
            MenuContent(
              minWidth: Menu.minWidthMenu,
              indicatorSide: MenuIndicatorSide.start,
              children: <MenuChild>[
                MenuCheckboxItem(
                  label: 'Word wrap',
                  checked: _startChecked,
                  onSelect: (bool next) => setState(() => _startChecked = next),
                ),
              ],
              onClose: () {},
            ),
          ],
        ),
      ],
    );
  }
}

const String _indicatorSideCode = '''MenuContent(
  children: [MenuCheckboxItem(label: 'Word wrap', checked: wrap, onSelect: onWrap)],
  onClose: close,
) // indicatorSide.end, the MenuContent default — tick on the right.

MenuContent(
  indicatorSide: MenuIndicatorSide.start, // the menubar's own drift.
  children: [MenuCheckboxItem(label: 'Word wrap', checked: wrap, onSelect: onWrap)],
  onClose: close,
) // tick on the left.''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elmenuitem',
        child: DocsApiTable(title: 'MenuItem', facts: _menuItemFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elmenuitemvariant',
        child: DocsApiTable(
          title: 'MenuItemVariant',
          facts: _menuItemVariantFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elmenucheckboxitem',
        child: DocsApiTable(
          title: 'MenuCheckboxItem',
          facts: _menuCheckboxItemFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elmenuradioitem',
        child: DocsApiTable(title: 'MenuRadioItem', facts: _menuRadioItemFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elmenuradiogroup',
        child: DocsApiTable(
          title: 'MenuRadioGroup',
          facts: _menuRadioGroupFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elmenulabel',
        child: DocsApiTable(title: 'MenuLabel', facts: _menuLabelFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elmenuseparator',
        child: DocsApiTable(title: 'MenuSeparator', facts: _menuSeparatorFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elmenugroup',
        child: DocsApiTable(title: 'MenuGroup', facts: _menuGroupFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elmenusub',
        child: DocsApiTable(title: 'MenuSub', facts: _menuSubFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elmenuindicatorside',
        child: DocsApiTable(
          title: 'MenuIndicatorSide',
          facts: _menuIndicatorSideFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elmenusurfacekind',
        child: DocsApiTable(
          title: 'MenuSurfaceVariant',
          facts: _menuSurfaceKindFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elmenu',
        child: DocsApiTable(title: 'Menu: static geometry', facts: _menuFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elmenusurface',
        child: DocsApiTable(title: 'MenuSurface', facts: _menuSurfaceFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elmenucontent',
        child: DocsApiTable(title: 'MenuContent', facts: _menuContentFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elmenupointerdown',
        child: DocsApiTable(
          title: 'MenuPointerDown',
          facts: _menuPointerDownFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elmenumotion',
        child: DocsApiTable(title: 'MenuMotion', facts: _menuMotionFacts),
      ),
    ],
  );
}

const List<DocsApiFact> _menuItemFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'label',
    type: 'String',
    description: "Required. The row's text.",
  ),
  DocsApiFact(
    name: 'icon',
    type: 'IconGlyph?',
    description:
        'Optional. The leading glyph, forced into Menu.iconSize '
        '(16px) regardless of the icon\'s own default size.',
  ),
  DocsApiFact(
    name: 'lucideIcon',
    type: 'LucideGlyph?',
    description:
        'Optional. The same leading slot over the generated lucide '
        'registry, for a glyph icon.dart does not carry. Ignored when '
        'icon is also given.',
  ),
  DocsApiFact(
    name: 'subtitle',
    type: 'String?',
    description:
        'Optional. A second line under label, gap-1 flex-col '
        'items-start: makes the row Menu.twoLineItemHeight tall '
        'instead of Menu.itemHeight.',
  ),
  DocsApiFact(
    name: 'shortcut',
    type: 'String?',
    description:
        "Optional. The row's own right-aligned, muted-at-rest hint "
        'text: a real value as often as a key combination.',
  ),
  DocsApiFact(
    name: 'variant',
    type: 'MenuItemVariant',
    description: 'Optional. Defaults to MenuItemVariant.normal.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Optional. Defaults to true. false dims the row to 50% '
        'opacity and removes it from the roving-focus and typeahead '
        'set entirely.',
  ),
  DocsApiFact(
    name: 'inset',
    type: 'bool',
    description:
        'Optional. Defaults to false. A 36px leading gutter so an '
        'icon-less row can line up under rows that carry one.',
  ),
  DocsApiFact(
    name: 'onSelect',
    type: 'VoidCallback?',
    description:
        'Optional. Called on commit (tap, or Enter/Space while '
        'highlighted); the whole menu closes immediately after.',
  ),
];

const List<DocsApiFact> _menuItemVariantFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'normal',
    type: 'enum value',
    description:
        'The default. accent fill on highlight, popoverForeground ink.',
  ),
  DocsApiFact(
    name: 'destructive',
    type: 'enum value',
    description:
        'destructiveText on the label, icon and shortcut in every '
        'state; a highlighted row tints with destructive at 10% '
        '(light) / 20% (dark) instead of accent.',
  ),
];

const List<DocsApiFact> _menuCheckboxItemFacts = <DocsApiFact>[
  DocsApiFact(name: 'label', type: 'String', description: 'Required.'),
  DocsApiFact(
    name: 'checked',
    type: 'bool',
    description:
        "Required. The tick's own indicator mounts only while this "
        'is true: an unchecked row holds no indicator element at all.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description: 'Optional. Defaults to true.',
  ),
  DocsApiFact(
    name: 'inset',
    type: 'bool',
    description: 'Optional. Defaults to false.',
  ),
  DocsApiFact(
    name: 'onSelect',
    type: 'ValueChanged<bool>?',
    description:
        'Optional. Called on commit with what the row would become '
        '(!checked); the menu still closes after, even with onSelect '
        'left null — a controlled row with no handler.',
  ),
];

const List<DocsApiFact> _menuRadioItemFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'value',
    type: 'String',
    description:
        "Required. What the enclosing group's onChanged is called with.",
  ),
  DocsApiFact(name: 'label', type: 'String', description: 'Required.'),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description: 'Optional. Defaults to true.',
  ),
];

const List<DocsApiFact> _menuRadioGroupFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'value',
    type: 'String?',
    description:
        'Required. Which child\'s value wears the tick; null shows none checked.',
  ),
  DocsApiFact(
    name: 'children',
    type: 'List<MenuRadioItem>',
    description: 'Required. The rows this group holds.',
  ),
  DocsApiFact(
    name: 'onChanged',
    type: 'ValueChanged<String>?',
    description:
        'Optional. Called on commit with the tapped row\'s value: the '
        'same controlled-no-handler shape as MenuCheckboxItem.onSelect '
        'when left null.',
  ),
];

const List<DocsApiFact> _menuLabelFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String',
    description: 'Required, positional. Ignored when child is given.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget?',
    description:
        "Optional. The label's own children, for a multi-line block: "
        "still sits inside the label's own px-3 py-2.",
  ),
  DocsApiFact(
    name: 'inset',
    type: 'bool',
    description: 'Optional. Defaults to false.',
  ),
];

const List<DocsApiFact> _menuSeparatorFacts = <DocsApiFact>[
  DocsApiFact(
    name: '(no parameters)',
    type: '—',
    description:
        'const MenuSeparator() is the whole of it: a 1px rule at '
        'Menu.separatorHeight (17), running the full content width by '
        "cancelling the content's own 8px padding with a negative margin.",
  ),
];

const List<DocsApiFact> _menuGroupFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<MenuChild>',
    description:
        'Required. A role="group" wrapper that paints nothing: its rows '
        'sit flush with the rows outside it, with no gap of its own.',
  ),
];

const List<DocsApiFact> _menuSubFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'label',
    type: 'String',
    description: "Required. The sub-trigger row's text.",
  ),
  DocsApiFact(
    name: 'children',
    type: 'List<MenuChild>',
    description: "Required. The submenu's own rows.",
  ),
  DocsApiFact(
    name: 'icon',
    type: 'IconGlyph?',
    description: "Optional. The sub-trigger's own leading glyph.",
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description: 'Optional. Defaults to true.',
  ),
  DocsApiFact(
    name: 'inset',
    type: 'bool',
    description: 'Optional. Defaults to false.',
  ),
];

const List<DocsApiFact> _menuIndicatorSideFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'end',
    type: 'enum value',
    description:
        'py-2 pr-9 pl-3, tick at right-3. MenuContent\'s own default; '
        'what a dropdown and a context menu both render.',
  ),
  DocsApiFact(
    name: 'start',
    type: 'enum value',
    description:
        "py-2 pr-3 pl-9, tick at left-1.5: the menubar's own mirror "
        'image, alone — menus drift 5.',
  ),
];

const List<DocsApiFact> _menuSurfaceKindFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'content',
    type: 'enum value',
    description:
        'shadow-md ring-1 ring-foreground/10: every top-level '
        'MenuContent across all three consumers.',
  ),
  DocsApiFact(
    name: 'subRinged',
    type: 'enum value',
    description:
        'shadow-lg ring-1 ring-foreground/10. Declared and reachable if '
        'a caller builds MenuContent directly and passes it, but '
        'nothing in dropdown_menu.dart, context_menu.dart or menubar.dart '
        'ever does — see the submenu gap under subBordered.',
  ),
  DocsApiFact(
    name: 'subBordered',
    type: 'enum value',
    description:
        'shadow-lg border, no ring — 2px taller than subRinged for the '
        'same content, a border adding to the box where a ring does not. '
        'GAP: what every submenu across all three consumers actually '
        'renders with, because _buildRow\'s MenuSub case maps any '
        'content-kind parent to subBordered regardless of caller — '
        'menu.dart\'s own DRIFT-4 comment table promising subRinged for '
        "a dropdown's or a menubar's own submenu is not what the code "
        'does for any of the three.',
  ),
];

const List<DocsApiFact> _menuFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'itemHeight',
    type: 'static double (get)',
    description: 'py-2 around one text-sm line box, 34.5714.',
  ),
  DocsApiFact(
    name: 'twoLineItemHeight',
    type: 'static double (get)',
    description:
        'A row carrying subtitle: itemHeight + a gap-1 + a caption line box, 52.7464.',
  ),
  DocsApiFact(
    name: 'labelHeight',
    type: 'static double (get)',
    description: "MenuLabel's own row, 32.",
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
    description: "min-w-36, 144 — a context menu's and a menubar's floor.",
  ),
  DocsApiFact(
    name: 'minWidthSub',
    type: 'static double (get)',
    description:
        "min-w-40, 160 — a context menu's and a menubar's own submenu floor.",
  ),
  DocsApiFact(
    name: 'minWidthSubDropdown',
    type: 'static double (get)',
    description:
        "min-w-24, 96 — a dropdown's own submenu floor, the only one of the three that is not 144 or 160.",
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
        'The stroke width the asked-for size="sm" icon derives, kept while iconSize overrules the box itself.',
  ),
];

const List<DocsApiFact> _menuSurfaceFacts = <DocsApiFact>[
  DocsApiFact(name: 'child', type: 'Widget', description: 'Required.'),
  DocsApiFact(
    name: 'kind',
    type: 'MenuSurfaceVariant',
    description: 'Optional. Defaults to MenuSurfaceVariant.content.',
  ),
];

const List<DocsApiFact> _menuContentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<MenuChild>',
    description: "Required. The content's own rows, in order.",
  ),
  DocsApiFact(
    name: 'onClose',
    type: 'VoidCallback',
    description:
        'Required. Dismisses the whole menu: a committed row, Tab, Escape at the top level, or a pointer outside.',
  ),
  DocsApiFact(
    name: 'width',
    type: 'double?',
    description: 'Optional. An explicit w-* on this content.',
  ),
  DocsApiFact(
    name: 'minWidth',
    type: 'double?',
    description:
        'Optional. Null takes Menu.minWidthMenu (144); each consumer passes its own floor explicitly.',
  ),
  DocsApiFact(
    name: 'kind',
    type: 'MenuSurfaceVariant',
    description: 'Optional. Defaults to MenuSurfaceVariant.content.',
  ),
  DocsApiFact(
    name: 'indicatorSide',
    type: 'MenuIndicatorSide',
    description:
        'Optional. Defaults to MenuIndicatorSide.end; only menubar.dart overrides it to start.',
  ),
  DocsApiFact(
    name: 'autofocus',
    type: 'bool',
    description:
        "Optional. Defaults to true. false for a submenu opened by hover: the keyboard stays on the parent's trigger until ArrowRight or Enter promotes it.",
  ),
  DocsApiFact(
    name: 'initialHighlight',
    type: 'int',
    description:
        'Optional. Defaults to -1, Radix\'s own "nothing focused yet". 0 is what a keyboard-opened trigger asks for.',
  ),
  DocsApiFact(
    name: 'onEscape',
    type: 'VoidCallback?',
    description:
        'Optional. Escape while this content has focus. Null routes to onClose; a submenu passes its own so Escape closes exactly one level.',
  ),
];

const List<DocsApiFact> _menuPointerDownFacts = <DocsApiFact>[
  DocsApiFact(name: 'child', type: 'Widget', description: 'Required.'),
  DocsApiFact(
    name: 'onPointerDown',
    type: 'VoidCallback',
    description:
        'Required. Fired on a raw PointerDownEvent, never on a tap, a click, or a keyboard activation.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description: 'Optional. Defaults to true. false renders child untouched.',
  ),
];

const List<DocsApiFact> _menuMotionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'duration',
    type: 'static Duration (get)',
    description: 'MotionDurations.overlayEnter, 320ms.',
  ),
  DocsApiFact(
    name: 'slideSides',
    type: 'static Set<PopoverSide> (get)',
    description:
        'All four PopoverSide values: the overlay slides in from whichever side it actually lands on, on every one of the family.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'popoverForeground ink (destructiveText on a destructive row); no fill.',
    userSignal: "A row that reads as part of the menu's own surface.",
  ),
  DocsStateFact(
    state: 'Highlighted',
    treatment:
        'accent fill and accentForeground ink (destructive tint at 10%/20% '
        'alpha on a destructive row) — a SNAP, not a transition: every row '
        'computes transition-duration: 0s, so the whole row recolours in '
        'one frame, both directions.',
    userSignal: 'The row under the pointer or the roving keyboard focus.',
  ),
  DocsStateFact(
    state: 'Checked',
    treatment:
        "A checkbox or radio row's indicator mounts only while checked "
        'is true — an unchecked row holds no indicator element at all, '
        'not merely a hidden one.',
    userSignal: 'A tick beside the row, on the side indicatorSide names.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'Opacity drops to 50%; the row leaves the roving-focus and typeahead set entirely.',
    userSignal: 'Faded and unreachable by keyboard or pointer alike.',
  ),
  DocsStateFact(
    state: 'Submenu open',
    treatment:
        'A hover opens after a 100ms Radix-timer delay; ArrowRight or '
        'Enter on a highlighted sub-trigger opens it immediately and '
        'focuses its first row. The trigger stays highlighted while its '
        'own content is open, whether or not the pointer is still on it.',
    userSignal: 'A second panel opens beside the row that led to it.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'menu.dart itself paints no animation of its own — every row is '
        'a snap. The 320ms overlay entrance/exit belongs to whichever '
        'Popover each consumer opens the content inside, not to this '
        'file.',
    userSignal: 'Rows never animate either way; only the overlay itself might.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'The open content itself carries no Semantics container, role '
            'or label of its own: no equivalent of role="menu" and no '
            'aria-activedescendant relationship. Only individual rows '
            'carry real semantics.',
        'Every row is Semantics(button: true, selected: checked, '
            'enabled: enabled, label: ...): a checkbox or radio row '
            'reports its checked state through selected, and a '
            'two-line row\'s label is both lines concatenated.',
        'A trigger\'s accessible name is entirely the caller\'s own '
            'responsibility: menu.dart supplies nothing automatically, '
            'because it never renders a trigger.',
        'Focus behavior: MenuContent takes focus itself the frame '
            'after it mounts (autofocus: true by default — false only '
            'for a submenu opened by hover, until ArrowRight or Enter '
            'promotes it). Nothing in this file returns focus to a '
            'trigger when the menu closes.',
        'Touch target: Menu.itemHeight is roughly 34.57px, below the '
            '44 / 48px baseline most touch-target guidance names, and '
            'is not configurable per row or per instance.',
        'Non-colour signal: a checked row pairs its tick with the '
            'row\'s own label text, never colour alone. A destructive '
            'row pairs its tint with destructiveText text and the '
            'word itself, not a colour shift alone.',
        'Error wiring: none. No row participates in form validation or '
            'an error state.',
        'Known gap: opening or closing the menu announces nothing as '
            'an event — there is no scoped route or live-region '
            'behaviour once the content mounts or unmounts.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'ArrowDown / ArrowUp move the roving highlight by one row. NO '
            'WRAP: past the last row ArrowDown stays there, and past the '
            'first ArrowUp stays there too — Radix\'s RovingFocusGroup is '
            'mounted with loop at its false default, the opposite of '
            "Select's own menu.",
        'Home / End jump straight to the first / last focusable row.',
        'ArrowRight opens a highlighted submenu and focuses its first '
            'row. On any other row it is not handled here at all: it '
            'falls through unhandled so a menubar strip can claim it to '
            'move to the next menu.',
        'ArrowLeft closes exactly one level, when this content is a '
            'submenu (onEscape is non-null) — otherwise it is left '
            'unhandled for the same reason ArrowRight is: a top-level '
            'menu has no ArrowLeft behaviour of its own, a menubar\'s '
            'strip does.',
        'Enter, NumpadEnter and Space commit the highlighted row. On a '
            'sub-trigger this opens its submenu instead of committing — '
            'the same action ArrowRight takes.',
        'Escape calls onEscape when set (a submenu, closing one level '
            'and returning focus to its own trigger) or onClose '
            'otherwise (closing everything).',
        'Tab closes the whole menu outright — not the usual traversal '
            'behaviour, a real keypress this file intercepts and reroutes '
            'to onClose.',
        'Typing any single printable character runs typeahead: rows '
            'are matched by their own text starting with the accumulated '
            'buffer, starting the search just after the current row so '
            'repeated presses of one letter cycle through every match. '
            'The buffer resets after 1000ms idle.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching anywhere in menu.dart: it reads no '
            'MediaQuery and renders the same widget tree at 390px and '
            '1440px.',
        'The popup\'s own width is max-content with a floor: as wide as '
            'its widest row unless minWidth or an explicit width says '
            'otherwise, never as wide as the viewport.',
        'Every row height (itemHeight, twoLineItemHeight, labelHeight, '
            'separatorHeight) is a fixed value read off the type specs, '
            'never scaled by density or text-scale settings.',
        'Placement — how close to a viewport edge the content can open '
            'before it has to flip or shift — belongs entirely to '
            'whichever Popover the consumer opens it inside; menu.dart '
            'repeats none of that logic itself.',
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
            value: 'registry/components/menu.json',
            description: 'Installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/menu.dart',
            description:
                'The same lib/components/ui/ target every component '
                'installs to.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: menuDoc.dependencies.join(', '),
            description:
                "The manifest's own registryDependencies, resolved "
                'automatically: icon.dart (plus the generated icon_paths '
                'files) for every row glyph, and popover.dart for '
                'PopoverSurface, which MenuSurface paints through.',
          ),
          const DocsInstallFact(
            label: 'Consumers',
            value: 'dropdown-menu, context-menu, menubar',
            description:
                'Each names menu as its own registryDependency and '
                'resolves it automatically: elattar add dropdown-menu, '
                'elattar add context-menu, or elattar add menubar all '
                'install this file too.',
          ),
        ],
      ),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Dropdown Menu', route: '/components/dropdown-menu'),
          DocsLink(label: 'Context Menu', route: '/components/context-menu'),
          DocsLink(label: 'Menubar', route: '/components/menubar'),
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Popover', route: '/components/popover'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) => DocsInstallFacts(
    title: 'What actually varies with the theme',
    facts: const <DocsInstallFact>[
      DocsInstallFact(
        label: 'theme.popover / theme.popoverForeground',
        value: 'Content fill and rest ink',
        description: 'Painted through PopoverSurface, which MenuSurface wraps.',
      ),
      DocsInstallFact(
        label: 'theme.accent / theme.accentForeground',
        value: 'Highlighted row fill and ink',
        description: 'Snaps in and out with no transition — see States.',
      ),
      DocsInstallFact(
        label: 'theme.destructive / theme.destructiveText',
        value: 'Destructive row tint and ink',
        description:
            'Tint alpha is 10% in light, 20% in dark; the ink itself does not change with the theme.',
      ),
      DocsInstallFact(
        label: 'theme.mutedForeground',
        value: 'Rest-state leading icon and shortcut ink',
        description:
            'Recolours to accentForeground / destructiveText once the row is highlighted.',
      ),
      DocsInstallFact(
        label: 'theme.foreground',
        value: 'Content ring, 10% alpha',
        description:
            "The elevation MenuSurfaceVariant.content and .subRinged both carry; .subBordered swaps it for a real theme.border line instead.",
      ),
    ],
  );
}

Widget _bullets(ThemeTokens theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: StyledText(
          '•  $line',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ),
      SizedBox(height: space(2)),
    ],
  ],
);
