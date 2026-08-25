/// Public documentation page for the `context_menu` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `ElSection`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button`, `field` and `dropdown_menu`
/// established. Every specimen widget and every code string below is the
/// same one the hand-composed page carried; the Preview specimen (previously
/// a bare `DocsCodeExample` with no quoted source) gains a `code:` string
/// here — it reuses `_contextMenuCode` verbatim, since the Preview and
/// Destructive specimens are the identical composition under two keys. A new
/// Keyboard disclosure is split out of the "Menu navigation" and
/// "Right-click only" bullets the old Accessibility section folded
/// together.
///
/// **shadcn parity.** Fetched fresh from
/// `https://ui.shadcn.com/docs/components/base/context-menu`: Context Menu,
/// Installation, Usage, Composition, Basic, Submenu, Shortcuts, Groups,
/// Icons, Checkboxes, Radio, Destructive, Sides, RTL, API Reference. Sides
/// is skipped and named here instead: it configures `side`/`align` on
/// `ContextMenuContent`, and ElContextMenu hardcodes `side:
/// ElPopoverSide.right, align: ElPopoverAlign.start` without exposing
/// either, so there is nothing to demonstrate.
///
/// **Split history.** This component used to be documented on the
/// `navigation_menu` page alongside `navigation_menu`, `menubar`, and
/// `hover_card`, its sections prefixed `Context Menu: ...`. Phase F/J split
/// each component onto its own page; that prefix is dropped here since the
/// page is now about exactly one component.
///
/// **Known bug, carried across correctly.** `_ContextMenuSpecimen` takes a
/// `specimenKey` field because this page mounts it twice: once as Preview,
/// once in Destructive. A `ValueKey` baked into `build()` would collide
/// across both mounts.
///
/// **API table, verified.** Built from
/// `lib/src/components/context_menu.dart`'s real constructor: `child`,
/// `children`, `width`, `enabled`. Matches the merged page's old table,
/// which was already correct for this component.
///
/// **Installation, corrected.** The old page's own Status fact claimed
/// "ships in the registry but cannot be installed through the CLI yet" —
/// stale: `registry/components/context-menu.json` exists and resolves
/// `menu`, `popover`, `source-foundation` today.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec contextMenuDocSpec = ComponentDocSpec(
  name: 'context-menu',
  title: contextMenuDoc.title,
  description: contextMenuDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description: 'Right-click the card to open the menu at the pointer.',
      specimen: _ContextMenuSpecimen(specimenKey: 'context-menu-specimen'),
      code: _contextMenuCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'registry/components/context-menu.json ships and resolves '
          'menu, popover and source-foundation automatically: elattar '
          'add context-menu installs lib/src/components/context_menu.dart. '
          'The Manual tab is for a project not using the CLI.',
      command: contextMenuDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/context_menu.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/context_menu.dart's generated "
              '@ui/context_menu.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated context_menu source here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElContextMenu is reachable the '
              'same way the CLI path already makes it.',
          code: "export 'context_menu.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          "Right-click the child to open the menu, anchored to the "
          "pointer's client coordinates. Opens on right-click only: no "
          'keyboard route, no touch route.',
      code: _contextMenuCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          "What the constructor assembles internally. ElContextMenu does "
          "not take a caller-assembled tree of sub-widgets the way "
          "shadcn's ContextMenuSub markup does: it takes a flat children "
          'list of ElMenuChild rows.',
      code: _contextMenuCompositionCode,
    ),
    ShowcaseSection(
      id: 'basic',
      title: 'Basic',
      description:
          'The simplest right-click menu: two plain ElMenuItem rows, no '
          'checkboxes, radios, or submenus.',
      specimen: _ContextMenuBasic(),
      code: _contextMenuBasicCode,
      label: 'Basic specimen view',
    ),
    ShowcaseSection(
      id: 'submenu',
      title: 'Submenu',
      description:
          "A ElMenuSub row opens a second content anchored to its own "
          'right edge, roughly 100ms after the pointer rests on it.',
      specimen: _ContextMenuSubmenu(),
      code: _contextMenuSubmenuCode,
      label: 'Submenu specimen view',
    ),
    ShowcaseSection(
      id: 'shortcuts',
      title: 'Shortcuts',
      description:
          'ElMenuItem.shortcut right-aligns a key hint. It is display '
          'only: the source does not wire the shortcut to a real key '
          'handler.',
      specimen: _ContextMenuShortcuts(),
      code: _contextMenuShortcutsCode,
      label: 'Shortcuts specimen view',
    ),
    ShowcaseSection(
      id: 'groups',
      title: 'Groups',
      description:
          'ElMenuGroup paints nothing: its rows sit flush with their '
          'neighbours. It exists to mark related actions and to give a '
          'future accessible label something to hang off.',
      specimen: _ContextMenuGroups(),
      code: _contextMenuGroupsCode,
      label: 'Groups specimen view',
    ),
    ShowcaseSection(
      id: 'icons',
      title: 'Icons',
      description:
          "The same ElMenuItem.icon slot Menubar uses: a leading glyph "
          'for faster visual scanning.',
      specimen: _ContextMenuIcons(),
      code: _contextMenuIconsCode,
      label: 'Icons specimen view',
    ),
    ShowcaseSection(
      id: 'checkboxes',
      title: 'Checkboxes',
      description:
          'ElMenuCheckboxItem for a toggleable option, right-click '
          "style. Same indicator side as a dropdown menu: the right "
          "edge, not Menubar's left.",
      specimen: _ContextMenuCheckboxes(),
      code: _contextMenuCheckboxesCode,
      label: 'Checkboxes specimen view',
    ),
    ShowcaseSection(
      id: 'radio',
      title: 'Radio',
      description:
          'ElMenuRadioGroup for a mutually exclusive choice, right-click '
          'style.',
      specimen: _ContextMenuRadio(),
      code: _contextMenuRadioCode,
      label: 'Radio specimen view',
    ),
    ShowcaseSection(
      id: 'destructive',
      title: 'Destructive',
      description:
          "ElMenuItemVariant.destructive tints a row's ink and, once "
          'highlighted, its fill: 10% of theme.destructive in light, '
          '20% in dark. The same specimen shown at the top of this '
          'page, mounted again under its own key.',
      specimen: _ContextMenuSpecimen(
        specimenKey: 'context-menu-destructive-specimen',
      ),
      code: _contextMenuCode,
      label: 'Destructive specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          "The right-click position itself does not mirror: "
          "ElContextMenu anchors to the pointer's literal client "
          'coordinates, which have no reading direction. Only the menu '
          'content reads right-to-left.',
      specimen: _ContextMenuRtl(),
      code: _contextMenuRtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter ElContextMenu declares, plus the '
          'one static layout constant the source names.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElContextMenu', anchor: 'api-elcontextmenu'),
        DocsTocEntry(
          title: 'ElContextMenu static helpers',
          anchor: 'api-elcontextmenu-static',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description: 'Read straight off _ElContextMenuState, not inferred.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description:
          'Keyboard interactions have their own section below.',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'Read straight off context_menu.dart\'s own Listener and the '
          'shared menu.dart engine it mounts, not inferred.',
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
            value: contextMenuDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Row model source',
            value: 'lib/src/components/menu.dart',
            description:
                'ElMenuChild and its variants: not documented on this '
                'page. See the Dropdown Menu page for the full row-model '
                'API tables.',
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
    ),
  ],
);

class ContextMenuDocPage extends StatelessWidget {
  const ContextMenuDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: contextMenuDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: contextMenuDocSpec.title,
      description: contextMenuDocSpec.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Context Menu'),
    ],
    toc: contextMenuDocSpec.toc,
    previous: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('context-menu-doc-article'),
      child: ComponentDocPage(spec: contextMenuDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// This page mounts a context menu twice: Preview and Destructive.
/// `specimenKey` gives each mount its own [ValueKey] — a key baked into
/// `build()` would collide across both, since the page renders as one
/// continuous scroll.
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

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elcontextmenu',
        child: DocsApiTable(
          title: 'ElContextMenu',
          facts: _contextMenuApiFacts,
        ),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elcontextmenu-static',
        child: DocsApiTable(
          title: 'ElContextMenu static helpers',
          facts: _contextMenuStaticFacts,
        ),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'Right-click only: no left-click path, no long-press, no '
            'keyboard shortcut. Do not make it the only path to an '
            'action — the reference has a long-press-on-touch opener, '
            'this port does not reproduce it.',
        'Escape behavior: closes the menu if focus is inside it.',
      ]),
      SizedBox(height: el(3)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText(
          'GAP: No touch path. The reference has long-press on touch; '
          'it is not ported here. Do not use a context menu as the '
          'only way to reach an action on a phone.',
          ElType.small,
          color: ElTheme.of(context).destructiveInk,
        ),
      ),
    ],
  );
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'GAP: no keyboard route to open the menu at all. Opening '
            'requires a real secondary-button PointerDownEvent — a '
            "mouse right-click or a trackpad two-finger press — on "
            "widget.child. There is no Enter/Space equivalent: the "
            "source docstring itself says a left-click on the trigger "
            'opens nothing.',
        'Once the menu is open, it hands off to the same engine every '
            'menu root shares: ArrowUp / ArrowDown move the highlight '
            'one row (no wrap), Home / End jump to the first / last, '
            'ArrowRight opens a highlighted sub-trigger\'s submenu and '
            'focuses its first row, ArrowLeft closes one submenu level. '
            'Enter, NumpadEnter and Space commit the highlighted row. '
            'Escape closes one submenu level, or the whole menu at the '
            'top level, if focus is inside it. Tab closes the menu '
            'outright rather than moving focus onward. Typeahead by a '
            'printable character jumps to the next matching row.',
        'Tab order: the trigger (widget.child) never becomes a focus '
            'stop of its own — SelectionContainer.disabled wraps it, '
            'not a Focus node — so a keyboard-only user tabbing through '
            'the page skips straight past it.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Right-click only, on every platform. A trackpad two-finger '
            'click is a right-button pointer event and opens the menu '
            'the same way.',
        'No touch path in this port: onSecondaryTapDown-equivalent '
            'input only, via a raw Listener watching for '
            'kSecondaryButton.',
        'The menu relies on ElPopover\'s collision algorithm near a '
            'viewport edge and snaps without transition when it flips.',
        'No breakpoint branching, and no dart:io Platform branch, '
            'anywhere in context_menu.dart.',
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
            value: 'registry/components/context-menu.json',
            description:
                'Ships and resolves registryDependencies menu, popover, '
                'source-foundation automatically.',
          ),
          const DocsInstallFact(
            label: 'Primary dependency',
            value: 'ElPopover',
            description:
                'Mounts the menu through ElPopover, anchored to a '
                'virtual point (anchorPoint) rather than a widget\'s '
                'box.',
          ),
          const DocsInstallFact(
            label: 'Row model',
            value: 'ElMenu, ElMenuChild (menu.dart)',
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
            value: 'example/test/components_docs/context_menu_test.dart',
            description:
                'This page\'s own two live specimens, section order, and '
                'API table coverage: 390x844 and 1440x900, both themes.',
          ),
        ],
      ),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[DocsLink(label: 'Popover', route: '/components/popover')],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        "Menu content: theme.popover / theme.popoverForeground, via "
            "ElMenuContent's own ElPopoverSurface.",
        'Destructive rows: a tint of theme.destructive (10% at rest, '
            '20% once highlighted), not a solid fill.',
        'Documented drift (menus drift 4): a submenu\'s content is the '
            'one overlay in the family that paints a real 1px border '
            'instead of the ring-foreground/10 rim its siblings use, '
            'costing its box 2px.',
        'Animation: menu content animates in through ElDurations.'
            'overlay.',
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
