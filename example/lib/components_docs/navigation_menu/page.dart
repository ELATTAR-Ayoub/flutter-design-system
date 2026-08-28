/// Public documentation page for the `navigation_menu` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose [Section]
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button` established. Every specimen
/// widget and every code string below is the same one the hand-composed
/// page carried; the Preview section gains real matching code (it had a
/// live specimen but no code before). New: a Keyboard disclosure, between
/// Accessibility and Responsive — navigation_menu.dart wires none, and
/// nothing in Press (motion/press.dart), which every trigger and link
/// row is built on, wires one either: no Focus widget anywhere in either
/// file, so this is the same "genuinely nothing to report" story
/// `breadcrumb` and `tabs` already carry, confirmed by grep, not assumed.
///
/// **Registry status, corrected.** The hand-composed page's Dependencies
/// section called this "unregistered," and `meta.dart`'s own doc comment
/// still says the same — both stale.
/// `registry/components/navigation-menu.json` exists on disk today, with
/// the exact `registryDependencies` `meta.dart` already lists (icon,
/// popover, press, source-foundation), so `elattar add
/// navigation-menu` genuinely resolves. Installation and Dependencies below
/// both say so; `meta.dart` is left as found, out of this rollout's scope.
///
/// **shadcn parity.** Fetched fresh from
/// `https://ui.shadcn.com/docs/components/base/navigation-menu`: Navigation
/// Menu, Installation, Usage, Composition, Link Component, RTL, API
/// Reference. `Link Component` is skipped and named here instead: it
/// composes a Next.js `Link` render prop; `NavigationMenuItem.link()`
/// takes a plain `onTap` callback, so there is nothing analogous to show.
///
/// **Split history.** This directory used to document `navigation_menu`,
/// `menubar`, `context_menu`, and `hover_card` together as one page (they
/// all build on [Popover]). Phase F/J split each into its own
/// `<name>/page.dart`; this file keeps only the navigation menu.
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

final ComponentDocSpec navigationMenuDocSpec = ComponentDocSpec(
  name: navigationMenuDoc.name,
  title: navigationMenuDoc.title,
  description: navigationMenuDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Hover or tap a trigger to open its panel; the second trigger '
          'shares the same viewport as the first.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'navigation-menu is a registry item: elattar add navigation-menu '
          'installs lib/src/components/navigation_menu.dart and resolves '
          'icon, popover, press and source-foundation '
          'automatically. The Manual tab is for a project not using the '
          'CLI.',
      command: navigationMenuDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/navigation_menu.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/navigation_menu.dart's generated "
              '@ui/navigation_menu.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated navigation_menu source here when '
              'using manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so NavigationMenu and the rest of '
              'the family are reachable the same way the CLI path '
              'already makes them.',
          code: "export 'navigation_menu.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'Each item is either a trigger with a panel, or a plain link. '
          'The menu owns its own open state: hover to open on a delay, '
          'or tap to toggle.',
      code: _navMenuCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'What the constructor assembles internally. NavigationMenu '
          'does not take a caller-assembled tree of sub-widgets the way '
          "shadcn's NavigationMenuList markup does: it takes a flat "
          'items list and builds the tree below from it — a structure '
          'diagram, not code a caller would write, so it stays a '
          'snippet rather than a stage with nothing live to show.',
      code: _navMenuCompositionCode,
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'The same trigger-and-panel composition read right-to-left '
          'under a Directionality. Nothing in NavigationMenu mirrors '
          'by hand: the chevron rotation and the panel anchoring both '
          'follow direction automatically.',
      specimen: _RtlSpecimen(),
      code: _navMenuRtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter NavigationMenu, '
          'NavigationMenuItem, NavigationMenuLink, and '
          'NavigationMenuIndicator declare, plus the static layout '
          'helpers a caller composing around the trigger reaches for.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'NavigationMenu', anchor: 'api-elnavigationmenu'),
        DocsTocEntry(
          title: 'NavigationMenu static helpers',
          anchor: 'api-elnavigationmenu-static',
        ),
        DocsTocEntry(
          title: 'NavigationMenuItem',
          anchor: 'api-elnavigationmenuitem',
        ),
        DocsTocEntry(
          title: 'NavigationMenuLink',
          anchor: 'api-elnavigationmenulink',
        ),
        DocsTocEntry(
          title: 'NavigationMenuIndicator',
          anchor: 'api-elnavigationmenuindicator',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read straight off _DsNavigationMenuState and the trigger/link '
          'widgets, not inferred: every timing cited is the real '
          'constant the source names.',
      child: const DocsStateMatrix(facts: _stateFacts),
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
          'navigation_menu.dart wires no key handling of its own — every '
          'fact here is about what does NOT happen, read off it and its '
          'one trigger/link primitive, Press (motion/press.dart), '
          'directly.',
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
            value: navigationMenuDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/navigation_menu_test.dart',
            description:
                'Covers this page: the article mounts, the live '
                'specimen opens and closes, the full API table, and '
                'both themes at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/navigation_menu/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

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
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Navigation Menu'),
    ],
    toc: navigationMenuDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Popover',
      route: '/components/popover',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('navigation-menu-doc-article'),
      child: ComponentDocPage(spec: navigationMenuDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// Mounted exactly once on this page (the Preview section). The key below
/// is baked into `build`, which is only safe while that stays true: a
/// second mount would give both instances the same key and any finder for
/// it would match two widgets.
class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: NavigationMenu(
        key: const ValueKey<String>('nav-menu-specimen'),
        viewport: true,
        indicator: false,
        items: <NavigationMenuItem>[
          NavigationMenuItem.trigger(
            label: 'Products',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                NavigationMenuLink(
                  child: StyledText('Item 1', TextStyles.small),
                ),
                NavigationMenuLink(
                  child: StyledText('Item 2', TextStyles.small),
                ),
              ],
            ),
          ),
          NavigationMenuItem.trigger(
            label: 'Company',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                NavigationMenuLink(
                  child: StyledText('About', TextStyles.small),
                ),
                NavigationMenuLink(
                  child: StyledText('Careers', TextStyles.small),
                ),
              ],
            ),
          ),
          NavigationMenuItem.link(label: 'Contact'),
        ],
      ),
    );
  }
}

class _RtlSpecimen extends StatelessWidget {
  const _RtlSpecimen();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: NavigationMenu(
          viewport: true,
          items: <NavigationMenuItem>[
            NavigationMenuItem.trigger(
              label: 'المنتجات',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  NavigationMenuLink(
                    child: StyledText('العنصر 1', TextStyles.small),
                  ),
                  NavigationMenuLink(
                    child: StyledText('العنصر 2', TextStyles.small),
                  ),
                ],
              ),
            ),
            NavigationMenuItem.link(label: 'اتصل بنا'),
          ],
        ),
      ),
    );
  }
}

/* ── Source strings ─────────────────────────────────────────────────────── */

const String _previewCode = '''NavigationMenu(
  viewport: true,
  indicator: false,
  items: <NavigationMenuItem>[
    NavigationMenuItem.trigger(
      label: 'Products',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          NavigationMenuLink(child: StyledText('Item 1', TextStyles.small)),
          NavigationMenuLink(child: StyledText('Item 2', TextStyles.small)),
        ],
      ),
    ),
    NavigationMenuItem.trigger(
      label: 'Company',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          NavigationMenuLink(child: StyledText('About', TextStyles.small)),
          NavigationMenuLink(child: StyledText('Careers', TextStyles.small)),
        ],
      ),
    ),
    NavigationMenuItem.link(label: 'Contact'),
  ],
)''';

const String _navMenuCode =
    '''final List<NavigationMenuItem> items = <NavigationMenuItem>[
  NavigationMenuItem.trigger(
    label: 'Products',
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        NavigationMenuLink(child: const StyledText('Item 1', TextStyles.small)),
        NavigationMenuLink(child: const StyledText('Item 2', TextStyles.small)),
      ],
    ),
  ),
  NavigationMenuItem.link(label: 'Contact', onTap: () {}),
];

return NavigationMenu(
  viewport: true,
  indicator: false,
  items: items,
);''';

const String _navMenuCompositionCode = '''NavigationMenu(
  items: <NavigationMenuItem>[
    NavigationMenuItem.trigger(       // opens a shared or per-item panel
      label: '...',
      content: Column(
        children: <Widget>[
          NavigationMenuLink(child: ...),  // one row per destination
        ],
      ),
    ),
    NavigationMenuItem.link(label: '...'), // a plain destination, no panel
  ],
  indicator: false,  // when true, mounts a NavigationMenuIndicator
)''';

const String _navMenuRtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: NavigationMenu(
    viewport: true,
    items: <NavigationMenuItem>[
      NavigationMenuItem.trigger(
        label: 'المنتجات',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            NavigationMenuLink(child: const StyledText('العنصر 1', TextStyles.small)),
            NavigationMenuLink(child: const StyledText('العنصر 2', TextStyles.small)),
          ],
        ),
      ),
      NavigationMenuItem.link(label: 'اتصل بنا'),
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
        id: 'api-elnavigationmenu',
        child: DocsApiTable(
          title: 'NavigationMenu',
          facts: _navigationMenuApiFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elnavigationmenu-static',
        child: DocsApiTable(
          title: 'NavigationMenu static helpers',
          facts: _navigationMenuStaticFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elnavigationmenuitem',
        child: DocsApiTable(
          title: 'NavigationMenuItem',
          facts: _navigationMenuItemApiFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elnavigationmenulink',
        child: DocsApiTable(
          title: 'NavigationMenuLink',
          facts: _navigationMenuLinkApiFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elnavigationmenuindicator',
        child: DocsApiTable(
          title: 'NavigationMenuIndicator',
          facts: _navigationMenuIndicatorApiFacts,
        ),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role: Semantics(button: true, expanded: ...) on a '
            'trigger (expanded only when the trigger has a chevron); '
            'Semantics(link: true, selected: active) on a panel row '
            '(NavigationMenuLink).',
        'Keyboard interactions: none. See Keyboard below for the full '
            'account, read directly off the source.',
        'Escape behavior: closes the panel if focus is inside it. Focus '
            "is the panel content's own business: the component does not "
            'move it there.',
        'Focus trap: none. Focus may leave the panel while it is open.',
        'Touch: tap opens a trigger\'s panel; tap the same trigger again '
            'closes it (the skip window still applies to a third tap).',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No Focus or FocusNode anywhere in navigation_menu.dart, '
            'confirmed by grep, not assumed: every trigger and panel row '
            'wraps a MouseRegion and Press, never a Focus widget.',
        'Press itself (motion/press.dart), the trigger and link\'s own '
            'tap/hover primitive, wires no Focus either: only '
            'PointerDownEvent/PointerUpEvent listeners for the press '
            'squash. Neither file this page depends on gives a trigger a '
            'keyboard tab stop.',
        'Tab order: a trigger or link row never enters keyboard '
            'traversal. There is no FocusNode to request focus on.',
        'Activation: opening a panel is pointer-only — a hover after the '
            '200ms delay, or a tap. There is no KeyEvent handling '
            'anywhere in either file, so Enter and Space do nothing to a '
            'trigger: there is nothing focused for them to act on.',
        'No custom FocusTraversalPolicy and no arrow-key roving-'
            'tabindex: moot, since nothing here ever enters the focus '
            'tree to traverse.',
        'Known gap: a keyboard-only visitor cannot open or navigate a '
            'panel today. See Accessibility above for the same gap named '
            'against the semantics tree.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching in navigation_menu.dart: BuildContext '
            'width is never read for a layout decision.',
        'Every measurement (listGap, triggerHeight, triggerPaddingX, '
            'triggerGap, panelOffset, panelPadding, indicatorHeight, '
            'caretSize) is a fixed space() value.',
        'viewport controls anchoring, not screen size: true anchors one '
            "shared panel to the bar's own leading edge; false anchors "
            'each item\'s panel to that item instead.',
        "The panel relies on Popover's collision algorithm to flip "
            'sides and shift along the cross axis near a viewport edge, '
            'and snaps without transition when it does.',
        'Platform parity: Android, iOS, Web, macOS, Windows, and Linux '
            'all render the same widget tree; no dart:io Platform branch '
            'anywhere in the file.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'Registry item: registry/components/navigation-menu.json exists '
            'and lists exactly the dependencies below: elattar add '
            'navigation-menu is a real, working install path.',
        'Primary dependency: Popover. Mounts the shared or per-item '
            'panel through Popover for placement, animation, and '
            'barrier behavior (PopoverBarrier.none: hover would '
            'otherwise fight a dismiss barrier).',
        'Also imports: Icon (chevron, from icon.dart) and Press '
            '(trigger tap/hover, from motion/press.dart).',
        'Platforms: Android, iOS, Web, macOS, Windows, Linux — pure '
            'widget composition; nothing platform-gated.',
      ]),
      SizedBox(height: space(2)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Popover', route: '/components/popover'),
          DocsLink(label: 'Press Motion', route: '/components/press'),
          DocsLink(
            label: 'Source Foundation',
            route: '/components/source_foundation',
          ),
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
        'Trigger, rest: theme.mutedForeground text, transparent fill. '
            'Trigger, hover or open: theme.secondary fill, '
            'theme.foreground text: neither transitions (drift: only '
            'transform is declared as transitioning, so colour '
            'hard-cuts).',
        'Panel: theme.popover fill, theme.popoverForeground text, via '
            'PopoverSurface, which also applies the ring and shadow.',
        'Panel row (NavigationMenuLink), rest: theme.mutedForeground '
            'text, transparent fill. Hover or active: theme.accent fill, '
            'theme.accentForeground text.',
        'Indicator caret: theme.popover fill, theme.foreground at 10% '
            "alpha for its ring (matching PopoverSurface's own rim).",
        'Animation: panel zoom-in-95/fade-in-0 (no slide) runs through '
            'MotionDurations.overlayEnter; the chevron rotates over '
            'MotionDurations.normal on MotionCurves.emphasized. Both '
            'collapse to zero under reduced motion via '
            'effectiveMotionDuration.',
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

/* ── Facts ───────────────────────────────────────────────────────────────── */

const List<DocsApiFact> _navigationMenuApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'items',
    type: 'List<NavigationMenuItem>',
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
        'Optional. Defaults to false. Mounts a NavigationMenuIndicator '
        'caret sized to the open trigger. Documented drift: it does not '
        'point at the open trigger past the first item (see '
        'NavigationMenuIndicator below).',
  ),
];

const List<DocsApiFact> _navigationMenuStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'NavigationMenu.listGap',
    type: 'static double',
    description: 'Gap between triggers in the bar: 4px.',
  ),
  DocsApiFact(
    name: 'NavigationMenu.triggerHeight',
    type: 'static double',
    description: 'A trigger\'s fixed height: 40px.',
  ),
  DocsApiFact(
    name: 'NavigationMenu.triggerPaddingX',
    type: 'static double',
    description: 'A trigger\'s horizontal padding: 16px.',
  ),
  DocsApiFact(
    name: 'NavigationMenu.triggerGap',
    type: 'static double',
    description: 'Gap between a trigger\'s label and its chevron: 6px.',
  ),
  DocsApiFact(
    name: 'NavigationMenu.chevronPx',
    type: 'static double',
    description: 'The trigger chevron\'s rendered size: 14px (IconSize.sm).',
  ),
  DocsApiFact(
    name: 'NavigationMenu.panelOffset',
    type: 'static double',
    description: 'Gap between the bar and the panel: 8px.',
  ),
  DocsApiFact(
    name: 'NavigationMenu.panelPadding',
    type: 'static double',
    description: 'Padding inside the panel: 8px.',
  ),
  DocsApiFact(
    name: 'NavigationMenu.indicatorHeight',
    type: 'static double',
    description:
        'The indicator\'s clipping band: 8px, exactly panelOffset, so an '
        'indicator and a panel never fight for the same pixels.',
  ),
  DocsApiFact(
    name: 'NavigationMenu.caretSize',
    type: 'static double',
    description:
        'The square that becomes the indicator\'s caret once rotated: 8px.',
  ),
];

const List<DocsApiFact> _navigationMenuItemApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'NavigationMenuItem.trigger()',
    type: 'constructor',
    description:
        'A trigger that opens a panel of content: requires label and '
        'content.',
  ),
  DocsApiFact(
    name: 'NavigationMenuItem.link()',
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
        'NavigationMenuLink widgets. Always null for a link item.',
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
        'integer, matching how Radix reads offsetWidth). NavigationMenu '
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
        'The panel mounts through Popover and animates in with '
        'zoom-in-95 and fade-in-0 only — no slide, unlike every menu in '
        'the Menu family. The trigger fill and text colour change land '
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
        'do not step between triggers. See Keyboard for the full account.',
    userSignal: 'Keyboard users cannot open a panel without a pointer.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'NavigationMenu and NavigationMenuItem carry no disabled/'
        'enabled parameter; the caller is responsible for omitting or '
        'graying an item itself.',
    userSignal: 'N/A: nothing in the API models a disabled item.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The panel\'s open/close animation and the chevron\'s rotation '
        'both route through effectiveMotionDuration, which is Duration.zero '
        'under MediaQuery.disableAnimations.',
    userSignal: 'The panel and chevron snap instead of animating.',
  ),
];
