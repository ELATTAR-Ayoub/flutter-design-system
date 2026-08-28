/// Public documentation page for the `menubar` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `Section`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button`, `field`, `dropdown_menu` and
/// `context_menu` established. Every specimen widget and every code string
/// below is the same one the hand-composed page carried; the Preview
/// specimen (previously a bare `DocsCodeExample` with no quoted source)
/// gains a `code:` string here — it reuses `_menubarCode` verbatim, the same
/// composition `_MenubarSpecimen` builds by hand. A new Keyboard disclosure
/// is split out of the "Keyboard" and "Menu navigation" bullets the old
/// Accessibility section folded together.
///
/// **shadcn parity.** Fetched fresh from
/// `https://ui.shadcn.com/docs/components/base/menubar`: Menubar,
/// Installation, Usage, Composition, Checkbox, Radio, Submenu, With Icons,
/// RTL, API Reference.
///
/// **Split history.** This component used to be documented on the
/// `navigation_menu` page alongside `navigation_menu`, `context_menu`, and
/// `hover_card`, its sections prefixed `Menubar: ...`. Phase F/J split each
/// component onto its own page; that prefix is dropped here since the page
/// is now about exactly one component.
///
/// **API tables, verified.** Built from `lib/src/components/menubar.dart`'s
/// real constructors and static getters: Menubar takes exactly one
/// parameter, `menus`; MenubarMenu takes `label` and `children`.
///
/// **Installation and Dependencies, corrected.** The old page's own facts
/// claimed "None: unregistered" / "has no manifest" — stale:
/// `registry/components/menubar.json` exists and resolves `menu`, `popover`,
/// `source-foundation` today.
///
/// **Keyboard, verified against source.** `_step` in `menubar.dart` wraps
/// with `(open + delta + count) % count`: ArrowLeft/ArrowRight between
/// triggers DOES wrap, unlike row navigation inside an open menu (which does
/// not, per the shared `menu.dart` engine).
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

final ComponentDocSpec menubarDocSpec = ComponentDocSpec(
  name: 'menubar',
  title: menubarDoc.title,
  description: menubarDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description: 'Click or hover a trigger to cycle between menus.',
      specimen: _MenubarSpecimen(),
      code: _menubarCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'registry/components/menubar.json ships and resolves menu, '
          'popover and source-foundation automatically: elattar add '
          'menubar installs lib/src/components/menubar.dart. The Manual '
          'tab is for a project not using the CLI.',
      command: menubarDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/menubar.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/menubar.dart's generated @ui/"
              'menubar.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated menubar source here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Menubar and MenubarMenu are '
              'reachable the same way the CLI path already makes them.',
          code: "export 'menubar.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'A strip of menus, each a label and a list of rows. The bar '
          'owns which menu is open; only one at a time.',
      code: _menubarCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          "What the constructor assembles internally. Menubar does "
          "not take a caller-assembled tree of sub-widgets the way "
          "shadcn's MenubarMenu markup does: it takes a flat menus list, "
          'and each menu a flat children list of MenuChild rows.',
      code: _menubarCompositionCode,
    ),
    ShowcaseSection(
      id: 'checkbox',
      title: 'Checkbox',
      description:
          'MenuCheckboxItem inside a MenubarMenu, for a toggleable '
          'option. checked is controlled: the caller owns the state and '
          'the row reports back through onSelect.',
      specimen: _MenubarCheckbox(),
      code: _menubarCheckboxCode,
      label: 'Checkbox specimen view',
    ),
    ShowcaseSection(
      id: 'radio',
      title: 'Radio',
      description:
          'MenuRadioGroup and MenuRadioItem for a single-select '
          'group of rows. The group paints nothing: it exists so '
          'exactly one child row wears the tick.',
      specimen: _MenubarRadio(),
      code: _menubarRadioCode,
      label: 'Radio specimen view',
    ),
    ShowcaseSection(
      id: 'submenu',
      title: 'Submenu',
      description:
          'MenuSub nests one level of rows behind a trigger row. '
          'Allowed one level deep by editorial convention, not by a '
          'depth check the source enforces.',
      specimen: _MenubarSubmenu(),
      code: _menubarSubmenuCode,
      label: 'Submenu specimen view',
    ),
    ShowcaseSection(
      id: 'with-icons',
      title: 'With Icons',
      description:
          'MenuItem.icon puts a 16px leading glyph on a row, forced '
          'to that size regardless of what IconSize the call site '
          'names.',
      specimen: _MenubarIcons(),
      code: _menubarIconsCode,
      label: 'With Icons specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'The same strip read right-to-left. The one thing that does '
          "not mirror: the menubar's check-row indicator sits on the "
          "row's start edge in both directions, because it is a drift "
          "in the reference's own class list (drift 5), not a property "
          'of direction.',
      specimen: _MenubarRtl(),
      code: _menubarRtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter Menubar and MenubarMenu '
          'declare, plus the static layout helpers the strip is built '
          'from.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Menubar', anchor: 'api-elmenubar'),
        DocsTocEntry(
          title: 'Menubar static helpers',
          anchor: 'api-elmenubar-static',
        ),
        DocsTocEntry(title: 'MenubarMenu', anchor: 'api-elmenubarmenu'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read straight off _DsMenubarState and _MenubarTriggerState, '
          'not inferred.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description: 'Keyboard interactions have their own section below.',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          "Read straight off menubar.dart's own Focus.onKeyEvent (the "
          "_step method) and the shared menu.dart engine each open "
          'menu mounts, not inferred.',
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
            value: menubarDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Row model source',
            value: 'lib/src/components/menu.dart',
            description:
                'MenuChild and its variants (MenuItem, '
                'MenuCheckboxItem, MenuRadioGroup/Item, MenuSub, '
                'MenuLabel, MenuSeparator, MenuGroup): not '
                'documented on this page. See the Dropdown Menu page '
                'for the full row-model API tables.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/menubar_test.dart',
            description:
                'Covers this page: the article mounts, the live '
                'specimen opens, the full API table, and both themes '
                'at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/menubar/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class MenubarDocPage extends StatelessWidget {
  const MenubarDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: menubarDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: menubarDocSpec.title,
      description: menubarDocSpec.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Menubar'),
    ],
    toc: menubarDocSpec.toc,
    previous: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('menubar-doc-article'),
      child: ComponentDocPage(spec: menubarDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// Mounted exactly once on this page (Preview). The key below is baked into
/// `build`, which is only safe while that stays true.
class _MenubarSpecimen extends StatelessWidget {
  const _MenubarSpecimen();

  @override
  Widget build(BuildContext context) {
    return Menubar(
      key: const ValueKey<String>('menubar-specimen'),
      menus: <MenubarMenu>[
        MenubarMenu(
          label: 'File',
          children: <MenuChild>[
            MenuItem(label: 'New'),
            MenuItem(label: 'Open'),
          ],
        ),
        MenubarMenu(
          label: 'Edit',
          children: <MenuChild>[
            MenuItem(label: 'Undo'),
            MenuItem(label: 'Redo'),
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
    return Menubar(
      menus: <MenubarMenu>[
        MenubarMenu(
          label: 'View',
          children: <MenuChild>[
            MenuCheckboxItem(label: 'Always Show Bookmarks Bar', checked: true),
            MenuCheckboxItem(label: 'Always Show Full URLs', checked: false),
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
    return Menubar(
      menus: <MenubarMenu>[
        MenubarMenu(
          label: 'Profiles',
          children: <MenuChild>[
            MenuRadioGroup(
              value: 'benoit',
              children: <MenuRadioItem>[
                MenuRadioItem(value: 'andy', label: 'Andy'),
                MenuRadioItem(value: 'benoit', label: 'Benoit'),
                MenuRadioItem(value: 'luis', label: 'Luis'),
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
    return Menubar(
      menus: <MenubarMenu>[
        MenubarMenu(
          label: 'File',
          children: <MenuChild>[
            MenuItem(label: 'New Tab'),
            MenuSub(
              label: 'Share',
              children: <MenuChild>[
                MenuItem(label: 'Email link'),
                MenuItem(label: 'Messages'),
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
    return Menubar(
      menus: <MenubarMenu>[
        MenubarMenu(
          label: 'File',
          children: <MenuChild>[
            MenuItem(label: 'New File', icon: IconGlyph.plus),
            MenuItem(label: 'Open', icon: IconGlyph.packageOpen),
            MenuItem(label: 'Download', icon: IconGlyph.download),
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
      child: Menubar(
        menus: <MenubarMenu>[
          MenubarMenu(
            label: 'ملف',
            children: <MenuChild>[
              MenuItem(label: 'جديد'),
              MenuItem(label: 'فتح'),
            ],
          ),
          MenubarMenu(
            label: 'تحرير',
            children: <MenuChild>[
              MenuItem(label: 'تراجع'),
              MenuItem(label: 'إعادة'),
            ],
          ),
        ],
      ),
    );
  }
}

const String _menubarCode = '''return Menubar(
  menus: <MenubarMenu>[
    MenubarMenu(
      label: 'File',
      children: <MenuChild>[
        MenuItem(label: 'New'),
        MenuItem(label: 'Open'),
        MenuItemSeparator(),
        MenuItem(label: 'Exit'),
      ],
    ),
    MenubarMenu(
      label: 'Edit',
      children: <MenuChild>[
        MenuItem(label: 'Undo'),
        MenuItem(label: 'Redo'),
      ],
    ),
  ],
);''';

const String _menubarCompositionCode = '''Menubar(
  menus: <MenubarMenu>[
    MenubarMenu(
      label: '...',          // the trigger text
      children: <MenuChild>[
        MenuItem(...),          // a plain row
        MenuCheckboxItem(...),  // a toggleable row
        MenuRadioGroup(children: <MenuRadioItem>[...]),
        MenuSub(children: <MenuChild>[...]), // one nested level
        MenuLabel(...),
        MenuSeparator(),
        MenuGroup(children: <MenuChild>[...]),
      ],
    ),
  ],
)''';

const String _menubarCheckboxCode = '''return Menubar(
  menus: <MenubarMenu>[
    MenubarMenu(
      label: 'View',
      children: <MenuChild>[
        MenuCheckboxItem(
          label: 'Always Show Bookmarks Bar',
          checked: true,
        ),
        MenuCheckboxItem(
          label: 'Always Show Full URLs',
          checked: false,
        ),
      ],
    ),
  ],
);''';

const String _menubarRadioCode = '''return Menubar(
  menus: <MenubarMenu>[
    MenubarMenu(
      label: 'Profiles',
      children: <MenuChild>[
        MenuRadioGroup(
          value: 'benoit',
          children: <MenuRadioItem>[
            MenuRadioItem(value: 'andy', label: 'Andy'),
            MenuRadioItem(value: 'benoit', label: 'Benoit'),
            MenuRadioItem(value: 'luis', label: 'Luis'),
          ],
        ),
      ],
    ),
  ],
);''';

const String _menubarSubmenuCode = '''return Menubar(
  menus: <MenubarMenu>[
    MenubarMenu(
      label: 'File',
      children: <MenuChild>[
        MenuItem(label: 'New Tab'),
        MenuSub(
          label: 'Share',
          children: <MenuChild>[
            MenuItem(label: 'Email link'),
            MenuItem(label: 'Messages'),
          ],
        ),
      ],
    ),
  ],
);''';

const String _menubarIconsCode = '''return Menubar(
  menus: <MenubarMenu>[
    MenubarMenu(
      label: 'File',
      children: <MenuChild>[
        MenuItem(label: 'New File', icon: IconGlyph.plus),
        MenuItem(label: 'Open', icon: IconGlyph.packageOpen),
        MenuItem(label: 'Download', icon: IconGlyph.download),
      ],
    ),
  ],
);''';

const String _menubarRtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: Menubar(
    menus: <MenubarMenu>[
      MenubarMenu(
        label: 'ملف',
        children: <MenuChild>[
          MenuItem(label: 'جديد'),
          MenuItem(label: 'فتح'),
        ],
      ),
      MenubarMenu(
        label: 'تحرير',
        children: <MenuChild>[
          MenuItem(label: 'تراجع'),
          MenuItem(label: 'إعادة'),
        ],
      ),
    ],
  ),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elmenubar',
        child: DocsApiTable(title: 'Menubar', facts: _menubarApiFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elmenubar-static',
        child: DocsApiTable(
          title: 'Menubar static helpers',
          facts: _menubarStaticFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elmenubarmenu',
        child: DocsApiTable(title: 'MenubarMenu', facts: _menubarMenuApiFacts),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'The bar itself takes no tab stop (canRequestFocus: false): a '
            'keyboard-only user tabs straight past the strip. Opening a '
            'menu is a click/tap action; there is no keyboard route to '
            'open one directly, see Keyboard below.',
        'Hover on keyboard: moving to a sibling menu with arrow keys '
            'while a menu is open swaps instantly, with no hover delay.',
        'Escape closes the open menu.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'GAP: no keyboard route to open a menu. canRequestFocus: false '
            'means the strip never becomes a focus stop, and _step only '
            'fires when _open is already non-null: opening the first '
            'menu requires a pointer-down on a trigger.',
        'Once a menu is open, ArrowLeft / ArrowRight step between '
            'triggers and DO wrap: _step computes (open + delta + '
            'count) % count, unlike row navigation inside the open '
            'menu itself, which does not wrap.',
        'Inside the open menu: the same shared menu.dart engine every '
            'menu root uses — ArrowUp/Down step rows, Home/End jump to '
            'the ends, typeahead searches by first letter, Enter/Space '
            'commit the highlighted row.',
        'Escape closes the open menu. Tab is not intercepted by the '
            'bar\'s own Focus (skipTraversal: true), so it falls through '
            'to whatever the open menu content\'s own key handling does.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Click opens a menu on every platform. Hover swaps between '
            'menus on desktop once one is already open; on touch, tap '
            'toggles a menu with no multi-trigger hover handoff.',
        'Documented drift (menus drift 1): the 32px triggers overflow '
            "the 32px-tall root's own 24px content box (p-1 leaves 4px "
            'on each edge). Reproduced rather than clipped: the '
            'reference writes no overflow-hidden either.',
        'Documented drift (menus drift 2): MenubarContent has no exit '
            'animation. Switching menus by hover, the outgoing content '
            'is gone the instant state flips; only the incoming '
            'content animates in.',
        "The open menu relies on Popover's collision algorithm near "
            'a viewport edge and snaps without transition when it '
            'flips.',
        'Platform parity: no dart:io Platform branch anywhere in the '
            'file.',
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
            value: 'registry/components/menubar.json',
            description:
                'Ships and resolves registryDependencies menu, popover, '
                'source-foundation automatically.',
          ),
          const DocsInstallFact(
            label: 'Primary dependency',
            value: 'Popover',
            description:
                "Mounts each menu's content through Popover, "
                'non-modal (PopoverBarrier.nonModal), which is what '
                'lets a sibling trigger be hovered while a menu is '
                'open.',
          ),
          const DocsInstallFact(
            label: 'Row model',
            value: 'Menu, MenuChild (menu.dart)',
            description:
                'The shared row model Menubar, Context Menu, and '
                'Dropdown Menu all use for their content.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description: 'Pure widget composition; nothing platform-gated.',
          ),
          const DocsInstallFact(
            label: 'Verified',
            value: 'example/test/components_docs/menubar_test.dart',
            description:
                "This page's own live specimen, section order, and API "
                'table coverage: 390x844 and 1440x900, both themes.',
          ),
        ],
      ),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Menu', route: '/components/menu'),
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
      _bullets(ThemeScope.of(context), <String>[
        'Trigger, rest: theme.foreground text, no fill. Trigger, hover '
            'or open: theme.muted fill — one fill for both states, and '
            'it does not transition (measured: transition-duration 0s '
            'on the reference).',
        'Root: a theme.border, 1px border around the whole strip.',
        'Menu content: theme.popover / theme.popoverForeground, via '
            "MenuContent's own PopoverSurface, the same surface "
            'Context Menu and Dropdown Menu use.',
        'Menu content animates in through MotionDurations.overlayEnter; there '
            'is no matching exit animation to time (drift 2, above).',
      ]);
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

const List<DocsApiFact> _menubarApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'menus',
    type: 'List<MenubarMenu>',
    description:
        'Required. The triggers and their menu rows, in strip order: a '
        'strip of menu openers.',
  ),
];

const List<DocsApiFact> _menubarStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'Menubar.height',
    type: 'static double',
    description:
        'The root\'s (and every trigger\'s) fixed height: 32px. Documented '
        'drift 1: the root\'s own p-1 leaves a 24px content box, so the '
        '32px triggers overflow it top and bottom.',
  ),
  DocsApiFact(
    name: 'Menubar.padding',
    type: 'static double',
    description: 'Inset around the strip: 4px.',
  ),
  DocsApiFact(
    name: 'Menubar.gap',
    type: 'static double',
    description: 'Gap between triggers: 2px.',
  ),
  DocsApiFact(
    name: 'Menubar.triggerPaddingX',
    type: 'static double',
    description: 'A trigger\'s horizontal padding: 12px.',
  ),
  DocsApiFact(
    name: 'Menubar.sideOffset',
    type: 'static double',
    description: 'Gap between a trigger and its open menu: 8px.',
  ),
  DocsApiFact(
    name: 'Menubar.alignOffset',
    type: 'static double',
    description:
        'How far a menu starts left of its trigger: -4px, so its inner '
        'padding lines up with the trigger\'s text rather than its box.',
  ),
];

const List<DocsApiFact> _menubarMenuApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'label',
    type: 'String',
    description: 'Required. The trigger text.',
  ),
  DocsApiFact(
    name: 'children',
    type: 'List<MenuChild>',
    description:
        'Required. The menu\'s rows: items, checkboxes, radios, '
        'submenus, labels, separators, groups. Managed by Menu.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment: 'Trigger shows theme.foreground text, no fill.',
    userSignal: 'A row of plain trigger labels.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        'A sibling trigger hovered while a menu is already open swaps to '
        'it at once — no intent delay. Hovering the strip with no menu '
        'open does nothing; opening one requires a click.',
    userSignal: 'Menus swap instantly as the pointer crosses the strip.',
  ),
  DocsStateFact(
    state: 'Open',
    treatment:
        'Pointer-down toggles a menu open. Its content animates in with '
        'zoom-in-95 and fade-in-0, over MotionDurations.overlayEnter. Documented '
        'drift 2: there is no matching exit animation; the outgoing '
        'content disappears the instant state flips.',
    userSignal: 'A menu zooms and fades in; switching menus has no exit.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'The bar itself takes no tab stop. While a menu is open, Left/'
        'Right steps between menus (and wraps), Up/Down steps rows '
        'inside the open one, Home/End jump, and typeahead searches by '
        'letter.',
    userSignal: 'Arrow-key navigation once a menu is open by click.',
  ),
  DocsStateFact(
    state: 'Pressed',
    treatment: 'Pointer-down on a trigger toggles its menu; no transition.',
    userSignal: 'Snap: the menu opens or closes on the down event.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'Menubar and MenubarMenu carry no disabled parameter; '
        'disabling is per-row through MenuChild.',
    userSignal: 'N/A at the trigger level.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The menu\'s open animation routes through effectiveMotionDuration, '
        'which is Duration.zero under reduced motion.',
    userSignal: 'The menu appears instantly instead of animating in.',
  ),
  DocsStateFact(
    state: 'Touch',
    treatment:
        'Tap toggles a menu. There is no hover-to-handoff on touch: '
        'opening a second menu requires tapping it directly.',
    userSignal: 'Tap opens; tapping a sibling closes the first and opens it.',
  ),
];
