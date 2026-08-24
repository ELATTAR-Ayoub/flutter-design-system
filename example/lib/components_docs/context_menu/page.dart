/// Public documentation page for the `context_menu` component.
///
/// **Shape.** Mirrors `button/page.dart`'s reference shape: an unheaded live
/// demo above the first heading, then Installation, Usage, and this
/// component's own sections named plainly, API Reference last of the
/// shadcn-mirrored sections, then States, Accessibility, Responsive,
/// Dependencies, Theming, Source.
///
/// **shadcn parity.** Fetched fresh from
/// `https://ui.shadcn.com/docs/components/base/context-menu`: Context Menu,
/// Installation, Usage, Composition, Basic, Submenu, Shortcuts, Groups,
/// Icons, Checkboxes, Radio, Destructive, Sides, RTL, API Reference. Sides
/// is skipped and named here instead: it configures `side`/`align` on
/// `ContextMenuContent`, and ElContextMenu hardcodes `side:
/// ElPopoverSide.right, align: ElPopoverAlign.start` without exposing
/// either, so there is nothing to demonstrate. Every other section
/// survives as a top-level `ElSection`.
///
/// **Split history.** This component used to be documented on the
/// `navigation_menu` page alongside `navigation_menu`, `menubar`, and
/// `hover_card`, its sections prefixed `Context Menu: ...`. Phase F/J split
/// each component onto its own page; that prefix is dropped here since the
/// page is now about exactly one component.
///
/// **Known bug, carried across correctly.** `_ContextMenuSpecimen` takes a
/// `specimenKey` field because this page mounts it twice: once as the
/// unheaded live demo, once in Destructive. A `ValueKey` baked into
/// `build()` would collide across both mounts.
///
/// **API table, verified.** Built from `lib/src/components/context_menu.dart`'s
/// real constructor: `child`, `children`, `width`, `enabled`. Matches the
/// merged page's old table, which was already correct for this component.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class ContextMenuDocPage extends StatelessWidget {
  const ContextMenuDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: contextMenuDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: contextMenuDoc.title,
      description: contextMenuDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Context Menu'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Basic', anchor: 'basic'),
      DocsTocEntry(title: 'Submenu', anchor: 'submenu'),
      DocsTocEntry(title: 'Shortcuts', anchor: 'shortcuts'),
      DocsTocEntry(title: 'Groups', anchor: 'groups'),
      DocsTocEntry(title: 'Icons', anchor: 'icons'),
      DocsTocEntry(title: 'Checkboxes', anchor: 'checkboxes'),
      DocsTocEntry(title: 'Radio', anchor: 'radio'),
      DocsTocEntry(title: 'Destructive', anchor: 'destructive'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(
        title: 'API Reference',
        anchor: 'api',
        children: <DocsTocEntry>[
          DocsTocEntry(title: 'ElContextMenu', anchor: 'api-elcontextmenu'),
          DocsTocEntry(
            title: 'ElContextMenu static helpers',
            anchor: 'api-elcontextmenu-static',
          ),
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
    child: const _ContextMenuArticle(),
  );
}

class _ContextMenuArticle extends StatelessWidget {
  const _ContextMenuArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('context-menu-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _preview(),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        SizedBox(height: el(6)),
        _composition(),
        _basic(),
        _submenu(),
        _shortcuts(),
        _groups(),
        _icons(),
        _checkboxes(),
        _radio(),
        _destructive(),
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
    title: 'Context Menu',
    description: 'Right-click the card to open the menu at the pointer.',
    preview: Center(
      child: _ContextMenuSpecimen(specimenKey: 'context-menu-specimen'),
    ),
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        '`elattar add context-menu` installs the component and its declared '
        'dependency closure.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsCodeExample(
          title: 'Manual installation',
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/context_menu.dart',
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                  '// Copy context_menu.dart source from the package when needed.',
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
                  'ElContextMenu is exported from the public barrel but '
                  'ships in the registry and cannot be installed '
                  'through the CLI yet.',
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
        'Right-click the child to open the menu, anchored to the pointer\'s '
        'client coordinates. Opens on right-click only: no keyboard route, '
        'no touch route.',
    child: ElPanel(
      label: 'DART',
      note: 'MINIMAL',
      child: DocsSelectableCodeBlock(code: _contextMenuCode),
    ),
  );

  Widget _composition() => ElSection(
    id: 'composition',
    title: 'Composition',
    description:
        'What the constructor assembles internally. ElContextMenu does not '
        'take a caller-assembled tree of sub-widgets the way shadcn\'s '
        'ContextMenuSub markup does: it takes a flat `children` list of '
        'ElMenuChild rows.',
    child: ElPanel(
      label: 'Context Menu',
      child: DocsSelectableCodeBlock(code: _contextMenuCompositionCode),
    ),
  );

  Widget _basic() => ElSection(
    id: 'basic',
    title: 'Basic',
    description:
        'The simplest right-click menu: two plain ElMenuItem rows, no '
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
  );

  Widget _submenu() => ElSection(
    id: 'submenu',
    title: 'Submenu',
    description:
        'A ElMenuSub row opens a second content anchored to its own right '
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
  );

  Widget _shortcuts() => ElSection(
    id: 'shortcuts',
    title: 'Shortcuts',
    description:
        'ElMenuItem.shortcut right-aligns a key hint. It is display only: '
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
  );

  Widget _groups() => ElSection(
    id: 'groups',
    title: 'Groups',
    description:
        'ElMenuGroup paints nothing: its rows sit flush with their '
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
  );

  Widget _icons() => ElSection(
    id: 'icons',
    title: 'Icons',
    description:
        'The same ElMenuItem.icon slot Menubar uses: a leading glyph for '
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
  );

  Widget _checkboxes() => ElSection(
    id: 'checkboxes',
    title: 'Checkboxes',
    description:
        'ElMenuCheckboxItem for a toggleable option, right-click style. '
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
  );

  Widget _radio() => ElSection(
    id: 'radio',
    title: 'Radio',
    description:
        'ElMenuRadioGroup for a mutually exclusive choice, right-click '
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
  );

  Widget _destructive() => ElSection(
    id: 'destructive',
    title: 'Destructive',
    description:
        'ElMenuItemVariant.destructive tints a row\'s ink and, once '
        'highlighted, its fill: 10% of theme.destructive in light, 20% in '
        'dark. The same specimen shown at the top of this page, mounted '
        'again under its own key.',
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
  );

  Widget _rtl() => ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'The right-click position itself does not mirror: ElContextMenu '
        'anchors to the pointer\'s literal client coordinates, which have '
        'no reading direction. Only the menu content reads '
        'right-to-left.',
    child: const DocsCodeExample(
      title: 'Right-to-left context menu',
      preview: _ContextMenuRtl(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'context_menu_rtl.dart', code: _contextMenuRtlCode),
      ],
    ),
  );

  Widget _api() => ElSection(
    id: 'api',
    title: 'API Reference',
    description:
        'Every constructor parameter ElContextMenu declares, plus the one '
        'static layout constant the source names.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elcontextmenu'),
          child: const DocsApiTable(
            title: 'ElContextMenu',
            facts: _contextMenuApiFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elcontextmenu-static'),
          child: const DocsApiTable(
            title: 'ElContextMenu static helpers',
            facts: _contextMenuStaticFacts,
          ),
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description: 'Read straight off _DsContextMenuState, not inferred.',
    child: const DocsStateMatrix(facts: _stateFacts),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _bullets(theme, <String>[
          'Right-click only: no left-click path, no long-press, no '
              'keyboard shortcut. Do not make it the only path to an '
              'action.',
          'Menu navigation: Up/Down step rows, Home/End jump, typeahead '
              'searches by letter. Rows do not wrap.',
          'Escape behavior: closes the menu if focus is inside it.',
        ]),
        SizedBox(height: el(3)),
        ElNote(
          tone: ElNoteTone.error,
          title: 'No touch path',
          child: ElText(
            'The reference has long-press on touch, but it is not ported. '
            'Do not use a context menu as the only way to reach an action '
            'on a phone.',
            ElType.small,
          ),
        ),
      ],
    ),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'Right-click only, on every platform. A trackpad two-finger click '
          'is a right-button pointer event and opens the menu the same '
          'way.',
      'No touch path in this port: onSecondaryTapDown-equivalent input '
          'only, via a raw Listener watching for kSecondaryButton.',
      'The menu relies on ElPopover\'s collision algorithm near a '
          'viewport edge and snaps without transition when it flips.',
      'No breakpoint branching, and no dart:io Platform branch, anywhere '
          'in context_menu.dart.',
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
              'ElContextMenu is in the package but has no manifest and '
              'cannot be installed through the CLI yet.',
        ),
        const DocsInstallFact(
          label: 'Primary dependency',
          value: 'ElPopover',
          description:
              'Mounts the menu through ElPopover, anchored to a virtual '
              'point (anchorPoint) rather than a widget\'s box.',
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
          value: 'example/test/components_docs/context_menu_test.dart',
          description:
              'This page\'s own two live specimens, section order, and '
              'API table coverage: 390x844 and 1440x900, both themes.',
        ),
      ],
    ),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'Menu content: theme.popover / theme.popoverForeground, via '
          'ElMenuContent\'s own ElPopoverSurface.',
      'Destructive rows: a tint of theme.destructive (10% at rest, 20% '
          'once highlighted), not a solid fill.',
      'Documented drift (menus drift 4): a submenu\'s content is the one '
          'overlay in the family that paints a real 1px border instead of '
          'the ring-foreground/10 rim its siblings use, costing its box '
          '2px.',
      'Animation: menu content animates in through ElDurations.overlay.',
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
          value: contextMenuDoc.sourcePath,
          description:
              'Authoritative implementation: the truth this page '
              'was written from.',
        ),
        const DocsInstallFact(
          label: 'Row model source',
          value: 'lib/src/components/menu.dart',
          description:
              'ElMenuChild and its variants: not documented on this page.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/context_menu_test.dart',
          description:
              'Covers this page: the article mounts, both live '
              'specimens, the full API table, and both themes at two '
              'viewport widths.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/context_menu/page.dart',
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

/// This page mounts a context menu twice: the unheaded live demo and
/// Destructive. `specimenKey` gives each mount its own [ValueKey] — a key
/// baked into `build()` would collide across both, since the page renders
/// as one continuous scroll.
class _ContextMenuSpecimen extends StatelessWidget {
  const _ContextMenuSpecimen({this.specimenKey = 'context-menu-specimen'});

  final String specimenKey;

  @override
  Widget build(BuildContext context) {
    return ElContextMenu(
      key: ValueKey<String>(specimenKey),
      children: <ElMenuChild>[
        ElMenuItem(label: 'Copy'),
        ElMenuItem(label: 'Paste'),
        ElMenuItem(label: 'Delete', variant: ElMenuItemVariant.destructive),
      ],
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: ElTheme.of(context).border),
          borderRadius: BorderRadius.circular(el(2)),
        ),
        child: Center(
          child: ElText(
            'Right-click here',
            ElType.small,
            color: ElTheme.of(context).mutedForeground,
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
    border: Border.all(color: ElTheme.of(context).border),
    borderRadius: BorderRadius.circular(el(2)),
  ),
  child: Center(
    child: ElText(
      label,
      ElType.small,
      color: ElTheme.of(context).mutedForeground,
    ),
  ),
);

class _ContextMenuBasic extends StatelessWidget {
  const _ContextMenuBasic();

  @override
  Widget build(BuildContext context) {
    return ElContextMenu(
      children: <ElMenuChild>[
        ElMenuItem(label: 'Copy'),
        ElMenuItem(label: 'Paste'),
      ],
      child: _contextMenuTarget(context, 'Right-click here'),
    );
  }
}

class _ContextMenuSubmenu extends StatelessWidget {
  const _ContextMenuSubmenu();

  @override
  Widget build(BuildContext context) {
    return ElContextMenu(
      children: <ElMenuChild>[
        ElMenuItem(label: 'Back'),
        ElMenuSub(
          label: 'More Tools',
          children: <ElMenuChild>[
            ElMenuItem(label: 'Save Page As...'),
            ElMenuItem(label: 'Create Shortcut...'),
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
    return ElContextMenu(
      children: <ElMenuChild>[
        ElMenuItem(label: 'Back', shortcut: '⌘['),
        ElMenuItem(label: 'Forward', shortcut: '⌘]'),
        ElMenuItem(label: 'Reload', shortcut: '⌘R'),
      ],
      child: _contextMenuTarget(context, 'Right-click here'),
    );
  }
}

class _ContextMenuGroups extends StatelessWidget {
  const _ContextMenuGroups();

  @override
  Widget build(BuildContext context) {
    return ElContextMenu(
      children: <ElMenuChild>[
        ElMenuGroup(
          children: <ElMenuChild>[
            ElMenuItem(label: 'Copy'),
            ElMenuItem(label: 'Paste'),
          ],
        ),
        ElMenuSeparator(),
        ElMenuGroup(children: <ElMenuChild>[ElMenuItem(label: 'Select All')]),
      ],
      child: _contextMenuTarget(context, 'Right-click here'),
    );
  }
}

class _ContextMenuIcons extends StatelessWidget {
  const _ContextMenuIcons();

  @override
  Widget build(BuildContext context) {
    return ElContextMenu(
      children: <ElMenuChild>[
        ElMenuItem(label: 'Copy', icon: ElIconGlyph.copy),
        ElMenuItem(label: 'Share', icon: ElIconGlyph.share2),
        ElMenuItem(label: 'Download', icon: ElIconGlyph.download),
      ],
      child: _contextMenuTarget(context, 'Right-click here'),
    );
  }
}

class _ContextMenuCheckboxes extends StatelessWidget {
  const _ContextMenuCheckboxes();

  @override
  Widget build(BuildContext context) {
    return ElContextMenu(
      children: <ElMenuChild>[
        ElMenuCheckboxItem(label: 'Show Bookmarks', checked: true),
        ElMenuCheckboxItem(label: 'Show Full URLs', checked: false),
      ],
      child: _contextMenuTarget(context, 'Right-click here'),
    );
  }
}

class _ContextMenuRadio extends StatelessWidget {
  const _ContextMenuRadio();

  @override
  Widget build(BuildContext context) {
    return ElContextMenu(
      children: <ElMenuChild>[
        ElMenuRadioGroup(
          value: 'medium',
          children: <ElMenuRadioItem>[
            ElMenuRadioItem(value: 'small', label: 'Small'),
            ElMenuRadioItem(value: 'medium', label: 'Medium'),
            ElMenuRadioItem(value: 'large', label: 'Large'),
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
      child: ElContextMenu(
        children: <ElMenuChild>[
          ElMenuItem(label: 'نسخ'),
          ElMenuItem(label: 'لصق'),
          ElMenuItem(label: 'حذف', variant: ElMenuItemVariant.destructive),
        ],
        child: _contextMenuTarget(context, 'انقر بزر الفأرة الأيمن هنا'),
      ),
    );
  }
}

const String _contextMenuCode = '''return ElContextMenu(
  child: const Text('Right-click here'),
  children: <ElMenuChild>[
    ElMenuItem(label: 'Copy'),
    ElMenuItem(label: 'Paste'),
    ElMenuItemSeparator(),
    ElMenuItem(
      label: 'Delete',
      variant: ElMenuItemVariant.destructive,
    ),
  ],
);''';

const String _contextMenuCompositionCode = '''ElContextMenu(
  child: ...,             // right-click this to open the menu at the pointer
  children: <ElMenuChild>[
    ElMenuItem(...),
    ElMenuCheckboxItem(...),
    ElMenuRadioGroup(children: <ElMenuRadioItem>[...]),
    ElMenuSub(children: <ElMenuChild>[...]),
    ElMenuGroup(children: <ElMenuChild>[...]),
    ElMenuSeparator(),
  ],
)''';

const String _contextMenuBasicCode = '''return ElContextMenu(
  child: const Text('Right-click here'),
  children: <ElMenuChild>[
    ElMenuItem(label: 'Copy'),
    ElMenuItem(label: 'Paste'),
  ],
);''';

const String _contextMenuSubmenuCode = '''return ElContextMenu(
  child: const Text('Right-click here'),
  children: <ElMenuChild>[
    ElMenuItem(label: 'Back'),
    ElMenuSub(
      label: 'More Tools',
      children: <ElMenuChild>[
        ElMenuItem(label: 'Save Page As...'),
        ElMenuItem(label: 'Create Shortcut...'),
      ],
    ),
  ],
);''';

const String _contextMenuShortcutsCode = '''return ElContextMenu(
  child: const Text('Right-click here'),
  children: <ElMenuChild>[
    ElMenuItem(label: 'Back', shortcut: '⌘['),
    ElMenuItem(label: 'Forward', shortcut: '⌘]'),
    ElMenuItem(label: 'Reload', shortcut: '⌘R'),
  ],
);''';

const String _contextMenuGroupsCode = '''return ElContextMenu(
  child: const Text('Right-click here'),
  children: <ElMenuChild>[
    ElMenuGroup(
      children: <ElMenuChild>[
        ElMenuItem(label: 'Copy'),
        ElMenuItem(label: 'Paste'),
      ],
    ),
    ElMenuSeparator(),
    ElMenuGroup(
      children: <ElMenuChild>[ElMenuItem(label: 'Select All')],
    ),
  ],
);''';

const String _contextMenuIconsCode = '''return ElContextMenu(
  child: const Text('Right-click here'),
  children: <ElMenuChild>[
    ElMenuItem(label: 'Copy', icon: ElIconGlyph.copy),
    ElMenuItem(label: 'Share', icon: ElIconGlyph.share2),
    ElMenuItem(label: 'Download', icon: ElIconGlyph.download),
  ],
);''';

const String _contextMenuCheckboxesCode = '''return ElContextMenu(
  child: const Text('Right-click here'),
  children: <ElMenuChild>[
    ElMenuCheckboxItem(label: 'Show Bookmarks', checked: true),
    ElMenuCheckboxItem(label: 'Show Full URLs', checked: false),
  ],
);''';

const String _contextMenuRadioCode = '''return ElContextMenu(
  child: const Text('Right-click here'),
  children: <ElMenuChild>[
    ElMenuRadioGroup(
      value: 'medium',
      children: <ElMenuRadioItem>[
        ElMenuRadioItem(value: 'small', label: 'Small'),
        ElMenuRadioItem(value: 'medium', label: 'Medium'),
        ElMenuRadioItem(value: 'large', label: 'Large'),
      ],
    ),
  ],
);''';

const String _contextMenuRtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ElContextMenu(
    child: const Text('انقر بزر الفأرة الأيمن هنا'),
    children: <ElMenuChild>[
      ElMenuItem(label: 'نسخ'),
      ElMenuItem(label: 'لصق'),
      ElMenuItem(label: 'حذف', variant: ElMenuItemVariant.destructive),
    ],
  ),
)''';

const List<DocsApiFact> _contextMenuApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required. The trigger: right-click it to open the menu at the '
        'pointer.',
  ),
  DocsApiFact(
    name: 'children',
    type: 'List<ElMenuChild>',
    description:
        'Required. The menu rows: items, checkboxes, radios, submenus, '
        'labels, separators, groups. Managed by ElMenu.',
  ),
  DocsApiFact(
    name: 'width',
    type: 'double?',
    description: 'Optional. Defaults to null: no width constraint on the menu.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Optional. Defaults to true. false ignores a right-click and the '
        'menu never opens.',
  ),
];

const List<DocsApiFact> _contextMenuStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElContextMenu.sideOffset',
    type: 'static double',
    description:
        'The gap between the pointer and the menu\'s top-left corner: '
        '2px. Radix\'s own context-menu default, not a spacing-ladder '
        'value.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment: 'The child is visible; no menu is mounted.',
    userSignal: 'The trigger looks like ordinary content.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment: 'Not applicable: this menu opens by right-click only.',
    userSignal: 'No hover affordance.',
  ),
  DocsStateFact(
    state: 'Open',
    treatment:
        'A right-click (or a trackpad two-finger click) opens the menu at '
        'the pointer\'s client coordinates, 2px to the right and slightly '
        'up (side: right, align: start). The content animates in with '
        'ElMenuMotion\'s slide-plus-zoom-plus-fade, over '
        'ElDurations.overlay.',
    userSignal: 'The menu appears at the cursor, not at a fixed anchor.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'Once open, focus goes to the menu\'s rows. Up/Down step, Home/'
        'End jump, typeahead searches. Escape closes the menu if focus is '
        'inside it.',
    userSignal: 'Keyboard navigation works once the menu is already open.',
  ),
  DocsStateFact(
    state: 'Pressed',
    treatment:
        'The child shows whatever press state it defines on its own; '
        'ElContextMenu does not style the trigger.',
    userSignal: 'Depends entirely on the wrapped child.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment: 'enabled: false: right-click is ignored and nothing opens.',
    userSignal: 'Right-clicking does nothing.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The open animation routes through elAnimationDuration, which is '
        'Duration.zero under reduced motion.',
    userSignal: 'The menu appears instantly instead of animating in.',
  ),
  DocsStateFact(
    state: 'Touch',
    treatment:
        'No touch path in this port: the reference\'s long-press opener '
        'is not reproduced.',
    userSignal: 'Invisible on a touch-only device.',
  ),
];
