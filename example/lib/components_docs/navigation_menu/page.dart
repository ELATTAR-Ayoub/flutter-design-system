/// Public documentation page for the `navigation_menu` component.
///
/// **Shape.** Mirrors `button/page.dart`'s reference shape: an unheaded live
/// demo above the first heading, then Installation, Usage, and this
/// component's own sections named plainly (no longer prefixed
/// `Navigation Menu: ...`, since the page is now about exactly one
/// component), API Reference last of the shadcn-mirrored sections, then
/// States, Accessibility, Responsive, Dependencies, Theming, Source.
///
/// **shadcn parity.** Fetched fresh from
/// `https://ui.shadcn.com/docs/components/base/navigation-menu`: Navigation
/// Menu, Installation, Usage, Composition, Link Component, RTL, API
/// Reference. `Link Component` is skipped and named here instead: it
/// composes a Next.js `Link` render prop; `ElNavigationMenuItem.link()`
/// takes a plain `onTap` callback, so there is nothing analogous to show.
/// Every other shadcn section survives as a top-level `ElSection`, matching
/// shadcn's own flat shape (no "Examples" wrapper).
///
/// **Split history.** This directory used to document `navigation_menu`,
/// `menubar`, `context_menu`, and `hover_card` together as one page (they
/// all build on [ElPopover]). Phase F/J split each into its own
/// `<name>/page.dart`; this file keeps only the navigation menu. The three
/// sibling components moved to `../menubar/page.dart`,
/// `../context_menu/page.dart`, and `../hover_card/page.dart`.
///
/// **API tables, fixed.** The merged page's API Reference was missing a
/// table for [ElNavigationMenuIndicator] entirely, despite it being a real,
/// exported class ([navigationMenuDoc.exports] already listed it). Every
/// table below was rebuilt from `lib/src/components/navigation_menu.dart`'s
/// real constructors and static getters, not copied from the old page.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class NavigationMenuDocPage extends StatelessWidget {
  const NavigationMenuDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: navigationMenuDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: navigationMenuDoc.title,
      description: navigationMenuDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Navigation Menu'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(
        title: 'API Reference',
        anchor: 'api',
        children: <DocsTocEntry>[
          DocsTocEntry(
            title: 'ElNavigationMenu',
            anchor: 'api-elnavigationmenu',
          ),
          DocsTocEntry(
            title: 'ElNavigationMenu static helpers',
            anchor: 'api-elnavigationmenu-static',
          ),
          DocsTocEntry(
            title: 'ElNavigationMenuItem',
            anchor: 'api-elnavigationmenuitem',
          ),
          DocsTocEntry(
            title: 'ElNavigationMenuLink',
            anchor: 'api-elnavigationmenulink',
          ),
          DocsTocEntry(
            title: 'ElNavigationMenuIndicator',
            anchor: 'api-elnavigationmenuindicator',
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
    previous: const DocsPageLink(
      title: 'Popover',
      route: '/components/popover',
    ),
    onNavigate: onNavigate,
    child: const _NavigationMenuArticle(),
  );
}

class _NavigationMenuArticle extends StatelessWidget {
  const _NavigationMenuArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('navigation-menu-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _preview(),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        SizedBox(height: el(6)),
        _composition(),
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
    title: 'Navigation Menu',
    description:
        'Hover or tap a trigger to open its panel; the second trigger '
        'shares the same viewport as the first.',
    preview: Center(child: _NavigationMenuSpecimen()),
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        '`elattar add navigation-menu` installs the component and its '
        'declared dependency closure.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsCodeExample(
          title: 'Manual installation',
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/navigation_menu.dart',
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                  '// Copy navigation_menu.dart source from the package when needed.',
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
                  'ElNavigationMenu, ElNavigationMenuItem, ElNavigationMenuLink, '
                  'and ElNavigationMenuIndicator are all exported from the '
                  'public barrel and ship in the registry, so you can '
                  'installed through the CLI yet.',
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
        'Each item is either a trigger with a panel, or a plain link. The '
        'menu owns its own open state: hover to open on a delay, or tap to '
        'toggle.',
    child: ElPanel(
      label: 'DART',
      note: 'MINIMAL',
      child: DocsSelectableCodeBlock(code: _navMenuCode),
    ),
  );

  Widget _composition() => ElSection(
    id: 'composition',
    title: 'Composition',
    description:
        'What the constructor assembles internally. ElNavigationMenu does '
        'not take a caller-assembled tree of sub-widgets the way shadcn\'s '
        'NavigationMenuList markup does: it takes a flat `items` list and '
        'builds the tree below from it.',
    child: ElPanel(
      label: 'Navigation Menu',
      child: DocsSelectableCodeBlock(code: _navMenuCompositionCode),
    ),
  );

  Widget _rtl() => ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'The same trigger-and-panel composition read right-to-left under a '
        'Directionality. Nothing in ElNavigationMenu mirrors by hand: the '
        'chevron rotation and the panel anchoring both follow direction '
        'automatically.',
    child: const DocsCodeExample(
      title: 'Right-to-left navigation menu',
      preview: _NavMenuRtl(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'nav_menu_rtl.dart', code: _navMenuRtlCode),
      ],
    ),
  );

  Widget _api() => ElSection(
    id: 'api',
    title: 'API Reference',
    description:
        'Every constructor parameter ElNavigationMenu, ElNavigationMenuItem, '
        'ElNavigationMenuLink, and ElNavigationMenuIndicator declare, plus '
        'the static layout helpers a caller composing around the trigger '
        'reaches for.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elnavigationmenu'),
          child: const DocsApiTable(
            title: 'ElNavigationMenu',
            facts: _navigationMenuApiFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elnavigationmenu-static'),
          child: const DocsApiTable(
            title: 'ElNavigationMenu static helpers',
            facts: _navigationMenuStaticFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elnavigationmenuitem'),
          child: const DocsApiTable(
            title: 'ElNavigationMenuItem',
            facts: _navigationMenuItemApiFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elnavigationmenulink'),
          child: const DocsApiTable(
            title: 'ElNavigationMenuLink',
            facts: _navigationMenuLinkApiFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elnavigationmenuindicator'),
          child: const DocsApiTable(
            title: 'ElNavigationMenuIndicator',
            facts: _navigationMenuIndicatorApiFacts,
          ),
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'Read straight off _DsNavigationMenuState and the trigger/link '
        'widgets, not inferred: every timing cited is the real constant '
        'the source names.',
    child: const DocsStateMatrix(facts: _stateFacts),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: _bullets(theme, <String>[
      'No keyboard opener: only click or hover open a trigger\'s panel. '
          'Arrow keys do not step between triggers.',
      'Semantic role: Semantics(button: true, expanded: ...) on a trigger '
          '(expanded only when the trigger has a chevron); '
          'Semantics(link: true, selected: active) on a panel row '
          '(ElNavigationMenuLink).',
      'Escape behavior: closes the panel if focus is inside it. Focus is '
          'the panel content\'s own business: the component does not move '
          'it there.',
      'Focus trap: none. Focus may leave the panel while it is open.',
      'Touch: tap opens a trigger\'s panel; tap the same trigger again '
          'closes it (the skip window still applies to a third tap).',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'No breakpoint branching in navigation_menu.dart: BuildContext width '
          'is never read for a layout decision.',
      'Every measurement (listGap, triggerHeight, triggerPaddingX, '
          'triggerGap, panelOffset, panelPadding, indicatorHeight, '
          'caretSize) is a fixed el() value.',
      'viewport controls anchoring, not screen size: true anchors one '
          'shared panel to the bar\'s own leading edge; false anchors each '
          'item\'s panel to that item instead.',
      'The panel relies on ElPopover\'s collision algorithm to flip sides '
          'and shift along the cross axis near a viewport edge, and snaps '
          'without transition when it does.',
      'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
          'render the same widget tree; no dart:io Platform branch '
          'anywhere in the file.',
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
              'ElNavigationMenu is in the package but has no manifest and '
              'cannot be installed through the CLI yet.',
        ),
        const DocsInstallFact(
          label: 'Primary dependency',
          value: 'ElPopover',
          description:
              'Mounts the shared or per-item panel through ElPopover for '
              'placement, animation, and barrier behavior '
              '(ElPopoverBarrier.none: hover would otherwise fight a '
              'dismiss barrier).',
        ),
        const DocsInstallFact(
          label: 'Also imports',
          value: 'ElIcon (chevron), ElPress (trigger tap/hover)',
          description: 'From icon.dart and motion/press.dart.',
        ),
        const DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description: 'Pure widget composition; nothing platform-gated.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'example/test/components_docs/navigation_menu_test.dart',
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
      'Trigger, rest: theme.mutedForeground text, transparent fill. '
          'Trigger, hover or open: theme.secondary fill, theme.foreground '
          'text: neither transitions (drift 3: only `transform` is '
          'declared as transitioning, so colour hard-cuts).',
      'Panel: theme.popover fill, theme.popoverForeground text, via '
          'ElPopoverSurface, which also applies the ring and shadow.',
      'Panel row (ElNavigationMenuLink), rest: theme.mutedForeground text, '
          'transparent fill. Hover or active: theme.accent fill, '
          'theme.accentForeground text.',
      'Indicator caret: theme.popover fill, theme.foreground at 10% alpha '
          'for its ring (matching ElPopoverSurface\'s own rim).',
      'Animation: panel zoom-in-95/fade-in-0 (no slide) runs through '
          'ElDurations.overlay; the chevron rotates over '
          'ElDurations.transitionDefault on ElCurves.spring. Both collapse '
          'to zero under reduced motion via elAnimationDuration.',
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
          value: navigationMenuDoc.sourcePath,
          description:
              'Authoritative implementation: the truth this page '
              'was written from.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/navigation_menu_test.dart',
          description:
              'Covers this page: the article mounts, the live '
              'specimen opens and closes, the full API table, and both '
              'themes at two viewport widths.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/navigation_menu/page.dart',
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
/// is baked into `build`, which is only safe while that stays true: a second
/// mount would give both instances the same key and any finder for it would
/// match two widgets. If you add one, give this a `specimenKey` field the
/// way `_ContextMenuSpecimen` and `_HoverCardSpecimen` on the context_menu
/// and hover_card pages already do, and pass a distinct key at the new site.
class _NavigationMenuSpecimen extends StatelessWidget {
  const _NavigationMenuSpecimen();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ElNavigationMenu(
        key: const ValueKey<String>('nav-menu-specimen'),
        viewport: true,
        indicator: false,
        items: <ElNavigationMenuItem>[
          ElNavigationMenuItem.trigger(
            label: 'Products',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElNavigationMenuLink(child: ElText('Item 1', ElType.small)),
                ElNavigationMenuLink(child: ElText('Item 2', ElType.small)),
              ],
            ),
          ),
          ElNavigationMenuItem.trigger(
            label: 'Company',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElNavigationMenuLink(child: ElText('About', ElType.small)),
                ElNavigationMenuLink(child: ElText('Careers', ElType.small)),
              ],
            ),
          ),
          ElNavigationMenuItem.link(label: 'Contact'),
        ],
      ),
    );
  }
}

class _NavMenuRtl extends StatelessWidget {
  const _NavMenuRtl();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ElNavigationMenu(
          viewport: true,
          items: <ElNavigationMenuItem>[
            ElNavigationMenuItem.trigger(
              label: 'المنتجات',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElNavigationMenuLink(child: ElText('العنصر 1', ElType.small)),
                  ElNavigationMenuLink(child: ElText('العنصر 2', ElType.small)),
                ],
              ),
            ),
            ElNavigationMenuItem.link(label: 'اتصل بنا'),
          ],
        ),
      ),
    );
  }
}

const String _navMenuCode =
    '''final List<ElNavigationMenuItem> items = <ElNavigationMenuItem>[
  ElNavigationMenuItem.trigger(
    label: 'Products',
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElNavigationMenuLink(child: const ElText('Item 1', ElType.small)),
        ElNavigationMenuLink(child: const ElText('Item 2', ElType.small)),
      ],
    ),
  ),
  ElNavigationMenuItem.link(label: 'Contact', onTap: () {}),
];

return ElNavigationMenu(
  viewport: true,
  indicator: false,
  items: items,
);''';

const String _navMenuCompositionCode = '''ElNavigationMenu(
  items: <ElNavigationMenuItem>[
    ElNavigationMenuItem.trigger(       // opens a shared or per-item panel
      label: '...',
      content: Column(
        children: <Widget>[
          ElNavigationMenuLink(child: ...),  // one row per destination
        ],
      ),
    ),
    ElNavigationMenuItem.link(label: '...'), // a plain destination, no panel
  ],
  indicator: false,  // when true, mounts a ElNavigationMenuIndicator
)''';

const String _navMenuRtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ElNavigationMenu(
    viewport: true,
    items: <ElNavigationMenuItem>[
      ElNavigationMenuItem.trigger(
        label: 'المنتجات',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElNavigationMenuLink(child: const ElText('العنصر 1', ElType.small)),
            ElNavigationMenuLink(child: const ElText('العنصر 2', ElType.small)),
          ],
        ),
      ),
      ElNavigationMenuItem.link(label: 'اتصل بنا'),
    ],
  ),
)''';

const List<DocsApiFact> _navigationMenuApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'items',
    type: 'List<ElNavigationMenuItem>',
    description:
        'Required. Trigger items with panels, and link items without '
        'panels, in bar order.',
  ),
  DocsApiFact(
    name: 'viewport',
    type: 'bool',
    description:
        'Optional. Defaults to true. true: one shared panel, anchored to '
        'the bar\'s own leading edge, that resizes between triggers. '
        'false: each trigger owns its own panel, anchored to itself.',
  ),
  DocsApiFact(
    name: 'indicator',
    type: 'bool',
    description:
        'Optional. Defaults to false. Mounts a ElNavigationMenuIndicator '
        'caret sized to the open trigger. Documented drift: it does not '
        'point at the open trigger past the first item (see '
        'ElNavigationMenuIndicator below).',
  ),
];

const List<DocsApiFact> _navigationMenuStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElNavigationMenu.listGap',
    type: 'static double',
    description: 'Gap between triggers in the bar: 4px.',
  ),
  DocsApiFact(
    name: 'ElNavigationMenu.triggerHeight',
    type: 'static double',
    description: 'A trigger\'s fixed height: 40px.',
  ),
  DocsApiFact(
    name: 'ElNavigationMenu.triggerPaddingX',
    type: 'static double',
    description: 'A trigger\'s horizontal padding: 16px.',
  ),
  DocsApiFact(
    name: 'ElNavigationMenu.triggerGap',
    type: 'static double',
    description: 'Gap between a trigger\'s label and its chevron: 6px.',
  ),
  DocsApiFact(
    name: 'ElNavigationMenu.chevronPx',
    type: 'static double',
    description: 'The trigger chevron\'s rendered size: 14px (ElIconSize.sm).',
  ),
  DocsApiFact(
    name: 'ElNavigationMenu.panelOffset',
    type: 'static double',
    description: 'Gap between the bar and the panel: 8px.',
  ),
  DocsApiFact(
    name: 'ElNavigationMenu.panelPadding',
    type: 'static double',
    description: 'Padding inside the panel: 8px.',
  ),
  DocsApiFact(
    name: 'ElNavigationMenu.indicatorHeight',
    type: 'static double',
    description:
        'The indicator\'s clipping band: 8px, exactly panelOffset, so an '
        'indicator and a panel never fight for the same pixels.',
  ),
  DocsApiFact(
    name: 'ElNavigationMenu.caretSize',
    type: 'static double',
    description:
        'The square that becomes the indicator\'s caret once rotated: 8px.',
  ),
];

const List<DocsApiFact> _navigationMenuItemApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElNavigationMenuItem.trigger()',
    type: 'constructor',
    description:
        'A trigger that opens a panel of content: requires label and '
        'content.',
  ),
  DocsApiFact(
    name: 'ElNavigationMenuItem.link()',
    type: 'constructor',
    description:
        'A plain destination link, no panel: requires label, optional '
        'onTap.',
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
        'The panel body for a trigger item: the caller\'s row of '
        'ElNavigationMenuLink widgets. Always null for a link item.',
  ),
  DocsApiFact(
    name: 'onTap',
    type: 'VoidCallback?',
    description:
        'Optional, link items only. Called when a link item is tapped. '
        'Always null for a trigger item.',
  ),
];

const List<DocsApiFact> _navigationMenuLinkApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required. The row content: an icon-and-label row or a '
        'title-and-blurb column.',
  ),
  DocsApiFact(
    name: 'active',
    type: 'bool',
    description:
        'Optional. Defaults to false. Marks the current destination: sets '
        'the fill to theme.accent and the text to theme.accentForeground, '
        'the same paint hover uses.',
  ),
  DocsApiFact(
    name: 'onTap',
    type: 'VoidCallback?',
    description: 'Optional. Defaults to null. Called when the row is tapped.',
  ),
];

const List<DocsApiFact> _navigationMenuIndicatorApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'width',
    type: 'double',
    description:
        'Required. The open trigger\'s measured width (rounded to an '
        'integer, matching how Radix reads offsetWidth). ElNavigationMenu '
        'mounts this itself when indicator is true; a caller does not '
        'construct it directly in practice.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'Trigger shows theme.mutedForeground text on a transparent fill; '
        'no panel is mounted.',
    userSignal: 'A row of plain-text triggers.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        'The pointer resting on a trigger opens its panel after a 200ms '
        'delay (Radix\'s own delayDuration) — unless a panel is already '
        'open or the 300ms skip window (below) is running, in which case '
        'it opens at once.',
    userSignal:
        'A brief pause before the first panel opens; switching between '
        'triggers afterward feels instant.',
  ),
  DocsStateFact(
    state: 'Open',
    treatment:
        'The panel mounts through ElPopover and animates in with '
        'zoom-in-95 and fade-in-0 only — no slide, unlike every menu in '
        'the ElMenu family. The trigger fill and text colour change land '
        'in the same frame the panel starts opening (drift: only '
        '`transform` is declared as transitioning, so colour hard-cuts).',
    userSignal: 'The panel zooms and fades in; the trigger snaps lit.',
  ),
  DocsStateFact(
    state: 'Closing',
    treatment:
        'The pointer leaving the trigger and the panel both starts a '
        '150ms close timer. Once it closes, the next trigger opens with no '
        'delay for 300ms (Radix\'s skipDelayDuration) before the normal '
        '200ms open delay returns.',
    userSignal:
        'Moving between triggers along the bar feels immediate; returning '
        'after a pause re-triggers the opening delay.',
  ),
  DocsStateFact(
    state: 'Pressed / touch',
    treatment:
        'Tapping a trigger toggles its panel directly (no hover delay '
        'applies): tap opens, tap the same trigger again closes.',
    userSignal: 'A tap opens or closes the panel with no pause.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'No keyboard opener: only click or hover open a panel. Arrow keys '
        'do not step between triggers.',
    userSignal: 'Keyboard users cannot open a panel without a pointer.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'ElNavigationMenu and ElNavigationMenuItem carry no disabled/'
        'enabled parameter; the caller is responsible for omitting or '
        'graying an item itself.',
    userSignal: 'N/A: nothing in the API models a disabled item.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The panel\'s open/close animation and the chevron\'s rotation '
        'both route through elAnimationDuration, which is Duration.zero '
        'under MediaQuery.disableAnimations.',
    userSignal: 'The panel and chevron snap instead of animating.',
  ),
];
