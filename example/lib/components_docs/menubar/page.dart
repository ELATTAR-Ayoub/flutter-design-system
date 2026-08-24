/// Public documentation page for the `menubar` component.
///
/// **Shape.** Mirrors `button/page.dart`'s reference shape: an unheaded live
/// demo above the first heading, then Installation, Usage, and this
/// component's own sections named plainly, API Reference last of the
/// shadcn-mirrored sections, then States, Accessibility, Responsive,
/// Dependencies, Theming, Source.
///
/// **shadcn parity.** Fetched fresh from
/// `https://ui.shadcn.com/docs/components/base/menubar`: Menubar,
/// Installation, Usage, Composition, Checkbox, Radio, Submenu, With Icons,
/// RTL, API Reference. Every section survives as a top-level `ElSection`.
///
/// **Split history.** This component used to be documented on the
/// `navigation_menu` page alongside `navigation_menu`, `context_menu`, and
/// `hover_card`, its sections prefixed `Menubar: ...`. Phase F/J split each
/// component onto its own page; that prefix is dropped here since the page
/// is now about exactly one component.
///
/// **API tables, verified.** Built from `lib/src/components/menubar.dart`'s
/// real constructors and static getters: ElMenubar takes exactly one
/// parameter, `menus`; ElMenubarMenu takes `label` and `children`. The
/// static helpers table is new — the merged page never surfaced
/// ElMenubar's own layout constants.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class MenubarDocPage extends StatelessWidget {
  const MenubarDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: menubarDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: menubarDoc.title,
      description: menubarDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Menubar'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Checkbox', anchor: 'checkbox'),
      DocsTocEntry(title: 'Radio', anchor: 'radio'),
      DocsTocEntry(title: 'Submenu', anchor: 'submenu'),
      DocsTocEntry(title: 'With Icons', anchor: 'with-icons'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(
        title: 'API Reference',
        anchor: 'api',
        children: <DocsTocEntry>[
          DocsTocEntry(title: 'ElMenubar', anchor: 'api-elmenubar'),
          DocsTocEntry(
            title: 'ElMenubar static helpers',
            anchor: 'api-elmenubar-static',
          ),
          DocsTocEntry(title: 'ElMenubarMenu', anchor: 'api-elmenubarmenu'),
        ],
      ),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: null,
    onNavigate: onNavigate,
    child: const _MenubarArticle(),
  );
}

class _MenubarArticle extends StatelessWidget {
  const _MenubarArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('menubar-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _preview(),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        SizedBox(height: el(6)),
        _composition(),
        _checkbox(),
        _radio(),
        _submenu(),
        _withIcons(),
        _rtl(),
        _api(),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(),
      ],
    );
  }

  Widget _preview() => const DocsCodeExample(
    title: 'Menubar',
    description: 'Click or hover a trigger to cycle between menus.',
    preview: Center(child: _MenubarSpecimen()),
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        '`elattar add menubar` installs the component and its declared '
        'dependency closure.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsCodeExample(
          title: 'Manual installation',
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/menubar.dart',
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                  '// Copy menubar.dart source from the package when needed.',
            ),
          ],
        ),
        SizedBox(height: el(4)),
        const DocsInstallFacts(
          title: 'Status',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Status',
              value: 'Stable: registry manifest',
              description:
                  'ElMenubar and ElMenubarMenu are exported from the '
                  'public barrel and ship in the registry, so you can '
                  'be installed through the CLI yet.',
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
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description:
        'A strip of menus, each a label and a list of rows. The bar owns '
        'which menu is open; only one at a time.',
    child: ElPanel(
      label: 'DART',
      note: 'MINIMAL',
      child: DocsSelectableCodeBlock(code: _menubarCode),
    ),
  );

  Widget _composition() => ElSection(
    id: 'composition',
    title: 'Composition',
    description:
        'What the constructor assembles internally. ElMenubar does not '
        'take a caller-assembled tree of sub-widgets the way shadcn\'s '
        'MenubarMenu markup does: it takes a flat `menus` list, and each '
        'menu a flat `children` list of ElMenuChild rows.',
    child: ElPanel(
      label: 'Menubar',
      child: DocsSelectableCodeBlock(code: _menubarCompositionCode),
    ),
  );

  Widget _checkbox() => ElSection(
    id: 'checkbox',
    title: 'Checkbox',
    description:
        'ElMenuCheckboxItem inside a ElMenubarMenu, for a toggleable '
        'option. checked is controlled: the caller owns the state and the '
        'row reports back through onSelect.',
    child: const DocsCodeExample(
      title: 'Checkbox rows',
      preview: _MenubarCheckbox(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'menubar_checkbox.dart', code: _menubarCheckboxCode),
      ],
    ),
  );

  Widget _radio() => ElSection(
    id: 'radio',
    title: 'Radio',
    description:
        'ElMenuRadioGroup and ElMenuRadioItem for a single-select group of '
        'rows. The group paints nothing: it exists so exactly one child '
        'row wears the tick.',
    child: const DocsCodeExample(
      title: 'Radio rows',
      preview: _MenubarRadio(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'menubar_radio.dart', code: _menubarRadioCode),
      ],
    ),
  );

  Widget _submenu() => ElSection(
    id: 'submenu',
    title: 'Submenu',
    description:
        'ElMenuSub nests one level of rows behind a trigger row. Allowed '
        'one level deep by editorial convention, not by a depth check the '
        'source enforces.',
    child: const DocsCodeExample(
      title: 'Nested menu',
      preview: _MenubarSubmenu(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'menubar_submenu.dart', code: _menubarSubmenuCode),
      ],
    ),
  );

  Widget _withIcons() => ElSection(
    id: 'with-icons',
    title: 'With Icons',
    description:
        'ElMenuItem.icon puts a 16px leading glyph on a row, forced to '
        'that size regardless of what ElIconSize the call site names.',
    child: const DocsCodeExample(
      title: 'Rows with leading icons',
      preview: _MenubarIcons(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'menubar_icons.dart', code: _menubarIconsCode),
      ],
    ),
  );

  Widget _rtl() => ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'The same strip read right-to-left. The one thing that does not '
        'mirror: the menubar\'s check-row indicator sits on the row\'s '
        'start edge in both directions, because it is a drift in the '
        'reference\'s own class list (drift 5), not a property of '
        'direction.',
    child: const DocsCodeExample(
      title: 'Right-to-left menubar',
      preview: _MenubarRtl(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'menubar_rtl.dart', code: _menubarRtlCode),
      ],
    ),
  );

  Widget _api() => ElSection(
    id: 'api',
    title: 'API Reference',
    description:
        'Every constructor parameter ElMenubar and ElMenubarMenu declare, '
        'plus the static layout helpers the strip is built from.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elmenubar'),
          child: const DocsApiTable(
            title: 'ElMenubar',
            facts: _menubarApiFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elmenubar-static'),
          child: const DocsApiTable(
            title: 'ElMenubar static helpers',
            facts: _menubarStaticFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elmenubarmenu'),
          child: const DocsApiTable(
            title: 'ElMenubarMenu',
            facts: _menubarMenuApiFacts,
          ),
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'Read straight off _DsMenubarState and _MenubarTriggerState, not '
        'inferred.',
    child: const DocsStateMatrix(facts: _stateFacts),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: _bullets(theme, <String>[
      'Keyboard: Left/Right arrow keys step between open menus. The bar '
          'itself takes no tab stop (canRequestFocus: false); the keys are '
          'only live while a menu is already open.',
      'Menu navigation: inside an open menu, Up/Down step rows, Home/End '
          'jump to the ends, and typeahead searches by first letter. Rows '
          'do not wrap past the first or last.',
      'Hover on keyboard: moving to a sibling menu with arrow keys while a '
          'menu is open swaps instantly, with no hover delay.',
      'Escape closes the open menu.',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'Click opens a menu on every platform. Hover swaps between menus on '
          'desktop once one is already open; on touch, tap toggles a menu '
          'with no multi-trigger hover handoff.',
      'Documented drift (menus drift 1): the 32px triggers overflow the '
          '32px-tall root\'s own 24px content box (p-1 leaves 4px on each '
          'edge). Reproduced rather than clipped: the reference writes no '
          '`overflow-hidden` either.',
      'Documented drift (menus drift 2): MenubarContent has no exit '
          'animation. Switching menus by hover, the outgoing content is '
          'gone the instant state flips; only the incoming content '
          'animates in.',
      'The open menu relies on ElPopover\'s collision algorithm near a '
          'viewport edge and snaps without transition when it flips.',
      'Platform parity: no dart:io Platform branch anywhere in the file.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: DocsInstallFacts(
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'None: unregistered',
          description:
              'ElMenubar is in the package but has no manifest and cannot '
              'be installed through the CLI yet.',
        ),
        const DocsInstallFact(
          label: 'Primary dependency',
          value: 'ElPopover',
          description:
              'Mounts each menu\'s content through ElPopover, non-modal '
              '(ElPopoverBarrier.nonModal), which is what lets a sibling '
              'trigger be hovered while a menu is open.',
        ),
        const DocsInstallFact(
          label: 'Row model',
          value: 'ElMenu, ElMenuChild (menu.dart)',
          description:
              'The shared row model Menubar, Context Menu, and Dropdown '
              'Menu all use for their content.',
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
              'This page\'s own live specimen, section order, and API '
              'table coverage: 390x844 and 1440x900, both themes.',
        ),
      ],
    ),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'Trigger, rest: theme.foreground text, no fill. Trigger, hover or '
          'open: theme.muted fill — one fill for both states, and it does '
          'not transition (measured: transition-duration 0s on the '
          'reference).',
      'Root: a theme.border, 1px border around the whole strip.',
      'Menu content: theme.popover / theme.popoverForeground, via '
          'ElMenuContent\'s own ElPopoverSurface, the same surface Context '
          'Menu and Dropdown Menu use.',
      'Menu content animates in through ElDurations.overlay; there is no '
          'matching exit animation to time (drift 2, above).',
    ]),
  );

  Widget _source() => ElSection(
    id: 'source',
    title: 'Source',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: menubarDoc.sourcePath,
          description:
              'Authoritative implementation: the truth this page '
              'was written from.',
        ),
        const DocsInstallFact(
          label: 'Row model source',
          value: 'lib/src/components/menu.dart',
          description:
              'ElMenuChild and its variants (ElMenuItem, '
              'ElMenuCheckboxItem, ElMenuRadioGroup/Item, ElMenuSub, '
              'ElMenuLabel, ElMenuSeparator, ElMenuGroup): not documented '
              'on this page.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/menubar_test.dart',
          description:
              'Covers this page: the article mounts, the live '
              'specimen opens, the full API table, and both themes at two '
              'viewport widths.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/menubar/page.dart',
          description: 'This file.',
        ),
      ],
    ),
  );
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

/// Mounted exactly once on this page (the unheaded live demo). The key below
/// is baked into `build`, which is only safe while that stays true.
class _MenubarSpecimen extends StatelessWidget {
  const _MenubarSpecimen();

  @override
  Widget build(BuildContext context) {
    return ElMenubar(
      key: const ValueKey<String>('menubar-specimen'),
      menus: <ElMenubarMenu>[
        ElMenubarMenu(
          label: 'File',
          children: <ElMenuChild>[
            ElMenuItem(label: 'New'),
            ElMenuItem(label: 'Open'),
          ],
        ),
        ElMenubarMenu(
          label: 'Edit',
          children: <ElMenuChild>[
            ElMenuItem(label: 'Undo'),
            ElMenuItem(label: 'Redo'),
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
    return ElMenubar(
      menus: <ElMenubarMenu>[
        ElMenubarMenu(
          label: 'View',
          children: <ElMenuChild>[
            ElMenuCheckboxItem(
              label: 'Always Show Bookmarks Bar',
              checked: true,
            ),
            ElMenuCheckboxItem(label: 'Always Show Full URLs', checked: false),
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
    return ElMenubar(
      menus: <ElMenubarMenu>[
        ElMenubarMenu(
          label: 'Profiles',
          children: <ElMenuChild>[
            ElMenuRadioGroup(
              value: 'benoit',
              children: <ElMenuRadioItem>[
                ElMenuRadioItem(value: 'andy', label: 'Andy'),
                ElMenuRadioItem(value: 'benoit', label: 'Benoit'),
                ElMenuRadioItem(value: 'luis', label: 'Luis'),
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
    return ElMenubar(
      menus: <ElMenubarMenu>[
        ElMenubarMenu(
          label: 'File',
          children: <ElMenuChild>[
            ElMenuItem(label: 'New Tab'),
            ElMenuSub(
              label: 'Share',
              children: <ElMenuChild>[
                ElMenuItem(label: 'Email link'),
                ElMenuItem(label: 'Messages'),
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
    return ElMenubar(
      menus: <ElMenubarMenu>[
        ElMenubarMenu(
          label: 'File',
          children: <ElMenuChild>[
            ElMenuItem(label: 'New File', icon: ElIconGlyph.plus),
            ElMenuItem(label: 'Open', icon: ElIconGlyph.packageOpen),
            ElMenuItem(label: 'Download', icon: ElIconGlyph.download),
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
      child: ElMenubar(
        menus: <ElMenubarMenu>[
          ElMenubarMenu(
            label: 'ملف',
            children: <ElMenuChild>[
              ElMenuItem(label: 'جديد'),
              ElMenuItem(label: 'فتح'),
            ],
          ),
          ElMenubarMenu(
            label: 'تحرير',
            children: <ElMenuChild>[
              ElMenuItem(label: 'تراجع'),
              ElMenuItem(label: 'إعادة'),
            ],
          ),
        ],
      ),
    );
  }
}

const String _menubarCode = '''return ElMenubar(
  menus: <ElMenubarMenu>[
    ElMenubarMenu(
      label: 'File',
      children: <ElMenuChild>[
        ElMenuItem(label: 'New'),
        ElMenuItem(label: 'Open'),
        ElMenuItemSeparator(),
        ElMenuItem(label: 'Exit'),
      ],
    ),
    ElMenubarMenu(
      label: 'Edit',
      children: <ElMenuChild>[
        ElMenuItem(label: 'Undo'),
        ElMenuItem(label: 'Redo'),
      ],
    ),
  ],
);''';

const String _menubarCompositionCode = '''ElMenubar(
  menus: <ElMenubarMenu>[
    ElMenubarMenu(
      label: '...',          // the trigger text
      children: <ElMenuChild>[
        ElMenuItem(...),          // a plain row
        ElMenuCheckboxItem(...),  // a toggleable row
        ElMenuRadioGroup(children: <ElMenuRadioItem>[...]),
        ElMenuSub(children: <ElMenuChild>[...]), // one nested level
        ElMenuLabel(...),
        ElMenuSeparator(),
        ElMenuGroup(children: <ElMenuChild>[...]),
      ],
    ),
  ],
)''';

const String _menubarCheckboxCode = '''return ElMenubar(
  menus: <ElMenubarMenu>[
    ElMenubarMenu(
      label: 'View',
      children: <ElMenuChild>[
        ElMenuCheckboxItem(
          label: 'Always Show Bookmarks Bar',
          checked: true,
        ),
        ElMenuCheckboxItem(
          label: 'Always Show Full URLs',
          checked: false,
        ),
      ],
    ),
  ],
);''';

const String _menubarRadioCode = '''return ElMenubar(
  menus: <ElMenubarMenu>[
    ElMenubarMenu(
      label: 'Profiles',
      children: <ElMenuChild>[
        ElMenuRadioGroup(
          value: 'benoit',
          children: <ElMenuRadioItem>[
            ElMenuRadioItem(value: 'andy', label: 'Andy'),
            ElMenuRadioItem(value: 'benoit', label: 'Benoit'),
            ElMenuRadioItem(value: 'luis', label: 'Luis'),
          ],
        ),
      ],
    ),
  ],
);''';

const String _menubarSubmenuCode = '''return ElMenubar(
  menus: <ElMenubarMenu>[
    ElMenubarMenu(
      label: 'File',
      children: <ElMenuChild>[
        ElMenuItem(label: 'New Tab'),
        ElMenuSub(
          label: 'Share',
          children: <ElMenuChild>[
            ElMenuItem(label: 'Email link'),
            ElMenuItem(label: 'Messages'),
          ],
        ),
      ],
    ),
  ],
);''';

const String _menubarIconsCode = '''return ElMenubar(
  menus: <ElMenubarMenu>[
    ElMenubarMenu(
      label: 'File',
      children: <ElMenuChild>[
        ElMenuItem(label: 'New File', icon: ElIconGlyph.plus),
        ElMenuItem(label: 'Open', icon: ElIconGlyph.packageOpen),
        ElMenuItem(label: 'Download', icon: ElIconGlyph.download),
      ],
    ),
  ],
);''';

const String _menubarRtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ElMenubar(
    menus: <ElMenubarMenu>[
      ElMenubarMenu(
        label: 'ملف',
        children: <ElMenuChild>[
          ElMenuItem(label: 'جديد'),
          ElMenuItem(label: 'فتح'),
        ],
      ),
      ElMenubarMenu(
        label: 'تحرير',
        children: <ElMenuChild>[
          ElMenuItem(label: 'تراجع'),
          ElMenuItem(label: 'إعادة'),
        ],
      ),
    ],
  ),
)''';

const List<DocsApiFact> _menubarApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'menus',
    type: 'List<ElMenubarMenu>',
    description:
        'Required. The triggers and their menu rows, in strip order: a '
        'strip of menu openers.',
  ),
];

const List<DocsApiFact> _menubarStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElMenubar.height',
    type: 'static double',
    description:
        'The root\'s (and every trigger\'s) fixed height: 32px. Documented '
        'drift 1: the root\'s own p-1 leaves a 24px content box, so the '
        '32px triggers overflow it top and bottom.',
  ),
  DocsApiFact(
    name: 'ElMenubar.padding',
    type: 'static double',
    description: 'Inset around the strip: 4px.',
  ),
  DocsApiFact(
    name: 'ElMenubar.gap',
    type: 'static double',
    description: 'Gap between triggers: 2px.',
  ),
  DocsApiFact(
    name: 'ElMenubar.triggerPaddingX',
    type: 'static double',
    description: 'A trigger\'s horizontal padding: 12px.',
  ),
  DocsApiFact(
    name: 'ElMenubar.sideOffset',
    type: 'static double',
    description: 'Gap between a trigger and its open menu: 8px.',
  ),
  DocsApiFact(
    name: 'ElMenubar.alignOffset',
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
    type: 'List<ElMenuChild>',
    description:
        'Required. The menu\'s rows: items, checkboxes, radios, '
        'submenus, labels, separators, groups. Managed by ElMenu.',
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
        'zoom-in-95 and fade-in-0, over ElDurations.overlay. Documented '
        'drift 2: there is no matching exit animation; the outgoing '
        'content disappears the instant state flips.',
    userSignal: 'A menu zooms and fades in; switching menus has no exit.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'The bar itself takes no tab stop. While a menu is open, Left/'
        'Right steps between menus, Up/Down steps rows inside the open '
        'one, Home/End jump, and typeahead searches by letter.',
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
        'ElMenubar and ElMenubarMenu carry no disabled parameter; '
        'disabling is per-row through ElMenuChild.',
    userSignal: 'N/A at the trigger level.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The menu\'s open animation routes through elAnimationDuration, '
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
