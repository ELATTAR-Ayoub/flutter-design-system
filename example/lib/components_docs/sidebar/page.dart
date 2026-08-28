/// Public component documentation for the sidebar **family**.
///
/// **Re-housed onto the kit.** This page used to hand-compose `Section`
/// panels reshaped to mirror `ui.shadcn.com/docs/components/base/sidebar`
/// section for section; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button` and `field` established.
/// Every specimen widget and every code string below is the same one the
/// hand-composed page carried; only where it lives changed, plus:
///
///  * The unheaded live shell above Installation is now its own `Preview`
///    `ShowcaseSection` with a code toggle, rather than a headless
///    `DocsCodeExample` with no source shown at all.
///  * `Composition` gained the code half it never had (a live `_PartsSpecimen`
///    with no toggle before), and a new `Offcanvas` section — split out of
///    the old `Sidebar` section, which mixed four reference tables with one
///    live specimen — gives the third `SidebarCollapsible` mode its own
///    slot, matching `icon` (Preview) and `none` (Composition).
///  * Every section that is a reference table with no live widget to
///    demonstrate (Structure, SidebarProvider, useSidebar, and every named
///    part from SidebarHeader through SidebarRail) is now a
///    `DisclosureSection`: the sealed section type built for exactly this,
///    "a text-or-table section, collapsed by default." Nothing in their
///    content changed; only the wrapper.
///  * `Controlled Sidebar`, a static code block with no table, is now a
///    `SnippetSection` — the sealed type built for exactly that shape.
///
/// **Corrected, not just moved.** This page's own Installation and
/// Dependencies sections used to say, twice, that no registry manifest
/// existed and no CLI command could be printed. That was false the whole
/// time: `registry/components/sidebar.json` exists, lists
/// `lib/src/components/sidebar.dart` and the same twelve
/// `registryDependencies` this page's [dependencies] already named, and its
/// own `documentationRoute` already points at `/components/sidebar`.
/// `elattar add sidebar` works. The one real gap the corrected text still
/// names honestly: that manifest does **not** list `user_menu.dart` — the
/// footer account block ships as its own separate registry item,
/// `user-menu` (`registry/components/user-menu.json`, which itself depends on
/// `sidebar`), with its own documentation page. See Installation and
/// Dependencies below.
///
/// **API Reference** keeps every one of its fourteen tables — the largest
/// single disclosure in the corpus — with `children:` sub-anchors and a
/// `DocsAnchor` wrapping each one, the same pattern `field`'s own API
/// Reference established for multiple tables in one disclosure.
///
/// **Two corrections stand as they were.** Every number in the collapse
/// contract is the package's own (`test/sidebar_test.dart` pins 256, 48,
/// 64, 66, 0 and 250ms against the live reference). And the Accessibility
/// section still corrects the plausible-but-wrong assumption that a
/// collapsed row fails the same way the tooltip component's own missing
/// `Semantics` would suggest: read against the source, `label ?? tooltip`
/// already names the button whether or not the tooltip overlay ever shows.
///
/// New: a Keyboard disclosure, between Accessibility and Responsive. The
/// "Keyboard interactions" fact the old Accessibility section folded in
/// (the Ctrl-B / Cmd-B shortcut) moves there, alongside the rail's
/// `tabIndex: -1` fact from the second Accessibility note — both are about
/// what answers a key press, not what a screen reader hears.
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
import '../../docs/docs_code.dart' show DocsSelectableCodeBlock;
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import '../../kit.dart' show Note, NoteTone, Panel;
import 'meta.dart';

final ComponentDocSpec sidebarDocSpec = ComponentDocSpec(
  name: 'sidebar',
  title: sidebarDoc.title,
  description: sidebarDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'App shell, collapsible: icon. Press the panel trigger, or '
          'Ctrl-B / Cmd-B with focus anywhere, because the shortcut is '
          'registered on the hardware keyboard rather than on a focus '
          'subtree. The panel travels 256 to 48 and back over 250ms.',
      specimen: _ShellSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: space(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'sidebar has a real registry manifest, `elattar add sidebar` '
          'installs lib/src/components/sidebar.dart and resolves all '
          'twelve registryDependencies automatically. That manifest does '
          'not list user_menu.dart: the footer account block ships as its '
          'own registry item, `user-menu` (`elattar add user-menu`, which '
          'itself depends on sidebar), with its own documentation page. '
          'The Manual tab below is for a project not using the CLI, or '
          'editing a local fork.',
      command: sidebarDoc.command,
      manualFiles: <DocsCodeFile>[
        const DocsCodeFile(
          path: 'lib/components/ui/sidebar.dart',
          title: '1. Copy the source (public surface excerpt)',
          description:
              'The real file is 2104 lines and holds thirty-three public '
              'names. This is the shell half of the surface: the menu '
              'parts are in the API Reference section below.',
          code: _installShellExcerpt,
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/user_menu.dart',
          title: '2. Copy user_menu.dart (public surface excerpt)',
          description:
              "The user-menu registry item's own payload. It reads "
              'SidebarScope for isMobile and composes SidebarMenu, so '
              'it only works inside a provider.',
          code: _installNavUserExcerpt,
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ (also copy)',
          title: '3. Source-level dependencies',
          description:
              'The twelve registryDependencies the CLI path resolves '
              'automatically.',
          code: sidebarDoc.dependencies.join('\n'),
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct shell: a provider owning state and the '
          'keyboard shortcut, wrapped around one collapsing panel and one '
          'main column. The one rule the compiler cannot enforce: '
          'SidebarProvider.variant and Sidebar.variant must be given '
          'the same value. On the web reference one is computed from the '
          'other through :has() and peer- selectors, which ask a parent '
          'about its descendants and a box about its sibling. Flutter can '
          'do neither, so the fact travels down twice and the call site '
          'is responsible for keeping the two in agreement.',
      code: _usageMinimalCode,
    ),
    ShowcaseSection(
      id: 'composition',
      title: 'Composition',
      description:
          'The part stage: collapsible: none, expand: true. A field, a '
          'labelled group with a badge and an action, a separator, a '
          'disclosure group with a nested list, and two skeleton rows. '
          'Nothing here collapses, which is the point: each part can be '
          'looked at on its own.',
      specimen: _PartsSpecimen(),
      code: _compositionCode,
      label: 'Composition specimen view',
      minHeight: space(160),
    ),
    DisclosureSection(
      id: 'structure',
      title: 'Structure',
      description:
          'Five moving pieces: a provider that owns state and the '
          'shortcut, a panel that reads it, a main column beside the '
          'panel, three scrolling regions inside it, and two controls '
          'that flip it open and shut.',
      child: const DocsApiTable(
        title: 'The shell, top to bottom',
        facts: _structureFacts,
      ),
    ),
    DisclosureSection(
      id: 'sidebar-provider',
      title: 'SidebarProvider',
      description:
          'One flex row: the panel and the main column. It owns the '
          'open state, the mobile sheet state, and the Ctrl-B / Cmd-B '
          'shortcut, and it is where every width in the family is '
          'ultimately measured from.',
      child: const DocsApiTable(
        title: 'The collapse contract: measured widths',
        facts: _providerFacts,
      ),
    ),
    DisclosureSection(
      id: 'sidebar',
      title: 'Sidebar',
      description:
          'Which edge the panel sits on, which frame it wears, and what '
          'collapsing does to it: three enums.',
      child: const _VariantsContent(),
    ),
    ShowcaseSection(
      id: 'offcanvas',
      title: 'Offcanvas',
      description:
          'The third collapse mode, live: collapsible: offcanvas is '
          "Sidebar's own default. The gap closes to nothing and the "
          'panel keeps its full 256 as it leaves.',
      specimen: _OffcanvasSpecimen(),
      code: _offcanvasCode,
      label: 'Offcanvas specimen view',
      minHeight: space(160),
    ),
    DisclosureSection(
      id: 'use-sidebar',
      title: 'useSidebar',
      description:
          'The reference publishes a hook; this port publishes an '
          'inherited scope with the same surface, read as '
          'SidebarScope.of(context) wherever a descendant needs it.',
      child: const DocsApiTable(
        title: 'SidebarScope, read with .of(context)',
        facts: _useSidebarFacts,
      ),
    ),
    DisclosureSection(
      id: 'sidebar-header',
      title: 'SidebarHeader',
      description:
          'A region above the scrolling content, most often holding a '
          'workspace switcher or a search field: see the live shell '
          'above for one in use.',
      child: const DocsApiTable(title: 'SidebarHeader', facts: _headerFacts),
    ),
    DisclosureSection(
      id: 'sidebar-footer',
      title: 'SidebarFooter',
      description:
          "The header's twin at the bottom of the panel, most often "
          'holding the signed-in account.',
      child: const _FooterContent(),
    ),
    DisclosureSection(
      id: 'sidebar-content',
      title: 'SidebarContent',
      description:
          'The one scrolling region in the panel, and the flex child '
          'that pushes the footer to the floor.',
      child: const DocsApiTable(
        title: 'SidebarContent and SidebarSeparator',
        facts: _contentFacts,
      ),
    ),
    DisclosureSection(
      id: 'sidebar-group',
      title: 'SidebarGroup',
      description:
          'A labelled section of the menu, optionally foldable, '
          'optionally carrying a corner action.',
      child: const _GroupContent(),
    ),
    DisclosureSection(
      id: 'sidebar-menu',
      title: 'SidebarMenu',
      description:
          'The list itself: one travelling pill shared by every row in '
          'it, rather than each row painting its own selected fill.',
      child: const DocsApiTable(
        title: 'SidebarMenu and SidebarMenuItem',
        facts: _menuFacts,
      ),
    ),
    DisclosureSection(
      id: 'sidebar-menu-button',
      title: 'SidebarMenuButton',
      description:
          'The row. isActive moves the pill to it; tooltip and label '
          'together decide what the row is called once it collapses.',
      child: const _MenuButtonContent(),
    ),
    DisclosureSection(
      id: 'sidebar-menu-action',
      title: 'SidebarMenuAction',
      description:
          "A second control on a row, beside the item's own button: a "
          '24px ghost square pinned to the right edge.',
      child: const DocsApiTable(
        title: 'SidebarMenuAction',
        facts: _menuActionFacts,
      ),
    ),
    DisclosureSection(
      id: 'sidebar-menu-sub',
      title: 'SidebarMenuSub',
      description:
          'A nested list hung off a border spine under a row, for the '
          'items one level down.',
      child: const DocsApiTable(
        title: 'SidebarMenuSub, SidebarMenuSubItem, SidebarMenuSubButton',
        facts: _menuSubFacts,
      ),
    ),
    DisclosureSection(
      id: 'sidebar-menu-badge',
      title: 'SidebarMenuBadge',
      description:
          "A count in a row's right lane, drawn over the row rather "
          'than inside its hit area.',
      child: const DocsApiTable(
        title: 'SidebarMenuBadge',
        facts: _menuBadgeFacts,
      ),
    ),
    DisclosureSection(
      id: 'sidebar-menu-skeleton',
      title: 'SidebarMenuSkeleton',
      description:
          'A shimmer row a caller renders in place of a real one while '
          'its own data loads: see it live in Composition, two rows '
          'deep.',
      child: const DocsApiTable(
        title: 'SidebarMenuSkeleton',
        facts: _menuSkeletonFacts,
      ),
    ),
    DisclosureSection(
      id: 'sidebar-trigger',
      title: 'SidebarTrigger',
      description:
          'The button that toggles the panel, meant to live in the '
          'main column so it survives whatever the panel is doing.',
      child: const DocsApiTable(title: 'SidebarTrigger', facts: _triggerFacts),
    ),
    DisclosureSection(
      id: 'sidebar-rail',
      title: 'SidebarRail',
      description:
          'A thin strip straddling the panel edge: a pointer shortcut '
          'for the same toggle, never the only way to reach it.',
      child: const DocsApiTable(title: 'SidebarRail', facts: _railFacts),
    ),
    SnippetSection(
      id: 'controlled-sidebar',
      title: 'Controlled Sidebar',
      description:
          'Pass open and onOpenChange to drive the panel from outside: '
          'the provider then never holds desktop state of its own.',
      code: _usageControlledCode,
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every public class in lib/src/components/sidebar.dart and '
          'lib/src/components/ui/user_menu.dart, with every constructor '
          'parameter and its default: fourteen tables, the largest '
          'single disclosure in the corpus.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'SidebarProvider', anchor: 'api-elsidebarprovider'),
        DocsTocEntry(title: 'Sidebar', anchor: 'api-elsidebar'),
        DocsTocEntry(
          title: 'Rail, Trigger, Inset',
          anchor: 'api-rail-trigger-inset',
        ),
        DocsTocEntry(title: 'Regions', anchor: 'api-regions'),
        DocsTocEntry(
          title: 'SidebarCollapsibleGroup',
          anchor: 'api-collapsible-group',
        ),
        DocsTocEntry(title: 'SidebarMenu', anchor: 'api-menu'),
        DocsTocEntry(title: 'SidebarMenuItem', anchor: 'api-menu-item'),
        DocsTocEntry(title: 'SidebarMenuButton', anchor: 'api-menu-button'),
        DocsTocEntry(title: 'Row content', anchor: 'api-row-content'),
        DocsTocEntry(
          title: 'Action and Badge',
          anchor: 'api-menu-action-badge',
        ),
        DocsTocEntry(title: 'SidebarMenuSkeleton', anchor: 'api-menu-skeleton'),
        DocsTocEntry(title: 'Sub-menu and field', anchor: 'api-sub-menu-field'),
        DocsTocEntry(title: 'Scopes', anchor: 'api-scopes'),
        DocsTocEntry(title: 'UserMenu', anchor: 'api-navuser'),
      ],
      child: const _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Rows that do not apply to a family with no async step and no '
          'disabled parameter are marked N/A with the reason, rather than '
          'invented.',
      child: const DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: const _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'Read off SidebarProvider (the shortcut) and SidebarRail '
          '(the deliberate exception): the "Keyboard interactions" fact '
          'this section used to fold into Accessibility lives here now, '
          'beside its own tabIndex fact.',
      child: const _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      description:
          'One media query decides everything: under 768 logical pixels '
          'the desktop panel is not built at all.',
      child: const _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      description:
          "Elattar's own technical-transparency panel: what this family "
          'needs to install and run.',
      child: const _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: const _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Source and tests',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: sidebarDoc.sourcePath,
            description: 'The authoritative package source, 2104 lines.',
          ),
          const DocsInstallFact(
            label: 'Source (family)',
            value: sidebarNavUserSourcePath,
            description:
                'The footer account block, in its own library because it '
                'composes the dropdown menu and avatar families as well.',
          ),
          const DocsInstallFact(
            label: 'GitHub',
            value:
                'github.com/ELATTAR-Ayoub/flutter-design-system/blob/'
                'main/lib/src/components/sidebar.dart',
            description:
                'Composed from the same repository path the sidebar '
                'registry manifest itself references.',
          ),
          const DocsInstallFact(
            label: 'Tests',
            value: 'test/sidebar_test.dart',
            description:
                'Six groups: collapse, variants, rows, the pill, '
                'tooltips and disclosure, plus the parts group that '
                'covers the field, the skeleton hash, the scope contract '
                'and the mobile branch. Every number quoted on this page '
                'comes from there.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/sidebar_test.dart',
            description:
                "This page's own coverage: API completeness across the "
                'family, the live 256/48 collapse, the offcanvas gap, '
                'the parts stage, the keyboard shortcut, both viewports '
                'and both themes.',
          ),
          const DocsInstallFact(
            label: 'Live demo',
            value: '/sidebar-demo',
            description:
                'The one route in the example app with no docs chrome, '
                'because a real shell needs the whole viewport to show '
                'collapsing, the rail, the mobile sheet and the shortcut '
                'at once.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/sidebar/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class SidebarDocPage extends StatelessWidget {
  const SidebarDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: sidebarDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: sidebarDoc.title,
      description: sidebarDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Sidebar'),
    ],
    sidebar: const <DocsSidebarEntry>[
      DocsSidebarEntry(title: 'Sheet', route: '/components/sheet'),
      DocsSidebarEntry(
        title: 'Sidebar',
        route: '/components/sidebar',
        selected: true,
      ),
      DocsSidebarEntry(title: 'Tabs', route: '/components/tabs'),
    ],
    toc: sidebarDocSpec.toc,
    previous: const DocsPageLink(title: 'Sheet', route: '/components/sheet'),
    next: const DocsPageLink(title: 'Tabs', route: '/components/tabs'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('sidebar-doc-article'),
      child: ComponentDocPage(spec: sidebarDocSpec, header: false),
    ),
  );
}

/* ── Sidebar (variants) ─────────────────────────────────────────────────── */

class _VariantsContent extends StatelessWidget {
  const _VariantsContent();

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsApiTable(title: 'SidebarCollapsible', facts: _collapsibleFacts),
      SizedBox(height: 20),
      DocsApiTable(title: 'SidebarVariant', facts: _sidebarVariantFacts),
      SizedBox(height: 20),
      DocsApiTable(title: 'SidebarSide', facts: _sidebarSideFacts),
      SizedBox(height: 20),
      DocsApiTable(title: 'Row ladders', facts: _rowLaddersFacts),
    ],
  );
}

/* ── SidebarFooter ───────────────────────────────────────────────────────── */

class _FooterContent extends StatelessWidget {
  const _FooterContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(
        title: 'SidebarFooter',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'children',
            type: 'List<Widget>',
            description:
                "Required. The header's twin. There is no mt-auto to port: "
                'the content region between them takes the slack. Most '
                'often holds a UserMenu, the account block below.',
          ),
        ],
      ),
      SizedBox(height: space(5)),
      const Panel(
        label: 'DART',
        note: 'FOOTER ACCOUNT BLOCK',
        child: DocsSelectableCodeBlock(code: _usageNavUserCode),
      ),
    ],
  );
}

/* ── SidebarGroup ────────────────────────────────────────────────────────── */

class _GroupContent extends StatelessWidget {
  const _GroupContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(
        title: 'SidebarGroup, SidebarGroupLabel, SidebarGroupAction',
        facts: _groupFacts,
      ),
      SizedBox(height: space(5)),
      const Panel(
        label: 'DART',
        note: 'DISCLOSURE GROUP',
        child: DocsSelectableCodeBlock(code: _usageGroupCode),
      ),
    ],
  );
}

/* ── SidebarMenuButton ───────────────────────────────────────────────────── */

class _MenuButtonContent extends StatelessWidget {
  const _MenuButtonContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(title: 'SidebarMenuButton', facts: _menuButtonFacts),
      SizedBox(height: space(5)),
      const Panel(
        label: 'DART',
        note: 'A COLLAPSING ROW',
        child: DocsSelectableCodeBlock(code: _usageRowCode),
      ),
    ],
  );
}

/* ── API Reference ───────────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elsidebarprovider',
        child: DocsApiTable(title: 'SidebarProvider', facts: _apiProviderFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elsidebar',
        child: DocsApiTable(title: 'Sidebar', facts: _apiSidebarFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-rail-trigger-inset',
        child: DocsApiTable(
          title: 'SidebarRail, SidebarTrigger, SidebarInset',
          facts: _apiRailTriggerInsetFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-regions',
        child: DocsApiTable(title: 'Regions', facts: _apiRegionsFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-collapsible-group',
        child: DocsApiTable(
          title: 'SidebarCollapsibleGroup',
          facts: _apiCollapsibleGroupFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-menu',
        child: DocsApiTable(title: 'SidebarMenu', facts: _apiMenuFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-menu-item',
        child: DocsApiTable(title: 'SidebarMenuItem', facts: _apiMenuItemFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-menu-button',
        child: DocsApiTable(
          title: 'SidebarMenuButton',
          facts: _apiMenuButtonFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-row-content',
        child: DocsApiTable(
          title: 'Row content: SidebarMenuRow, SidebarMenuLabel',
          facts: _apiRowContentFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-menu-action-badge',
        child: DocsApiTable(
          title: 'SidebarMenuAction and SidebarMenuBadge',
          facts: _apiMenuActionBadgeFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-menu-skeleton',
        child: DocsApiTable(
          title: 'SidebarMenuSkeleton',
          facts: _apiMenuSkeletonFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-sub-menu-field',
        child: DocsApiTable(
          title: 'Sub-menu and field',
          facts: _apiSubMenuFieldFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-scopes',
        child: DocsApiTable(
          title: 'Scopes: SidebarScope and SidebarChrome',
          facts: _apiScopesFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-navuser',
        child: DocsApiTable(
          title: 'UserMenu (user_menu.dart)',
          facts: _apiNavUserFacts,
        ),
      ),
    ],
  );
}

/* ── Accessibility ───────────────────────────────────────────────────────── */

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const Panel(
        label: 'What the semantics tree actually carries',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _A11yRow(
              'Semantic role',
              'Every control in the family resolves to a button node: the '
                  'trigger, the rail, each menu row, each sub-button, the '
                  'group and menu actions, and the disclosure line. The '
                  'panel itself is not a landmark and the groups are not '
                  'headings, SidebarGroupLabel is plain text, so group '
                  'structure is visual only and a screen reader hears one '
                  'flat run of buttons.',
            ),
            _A11yRow(
              'Required labels',
              'SidebarMenuButton resolves its accessible name as '
                  'label ?? tooltip and hands it to the underlying button, '
                  'which publishes it as a real name. SidebarTrigger and '
                  'SidebarRail both hard-code "Toggle Sidebar". '
                  'SidebarGroupAction and SidebarMenuAction each take a '
                  'required label, which is their only name. SidebarInput '
                  'takes an optional label and has no other name if it is '
                  'omitted.',
            ),
            _A11yRow(
              'Focus behavior',
              'The trigger sits in the main column rather than the panel, '
                  'so focus on it survives any collapse. Focus inside the '
                  'panel does not always: in icon mode sub-menus and '
                  'sub-buttons are removed from the tree entirely, so focus '
                  'resting on one is dropped. In offcanvas nothing '
                  'unmounts, which is the opposite problem: focus can '
                  'still travel into rows that have slid off screen and are '
                  'invisible. Neither case is guarded, and nothing in the '
                  'family moves focus on its own.',
            ),
            _A11yRow(
              'Touch target',
              'A collapsed row is 32px, under the 44px many guidelines '
                  'ask for; the 48px rail is the panel, not the row. Group '
                  'and menu actions are 24px squares: the reference has a '
                  'touch-target expander on them that is switched off from '
                  'the medium breakpoint up, so at every width this port '
                  'renders, 24px is the whole hit area.',
            ),
            _A11yRow(
              'Non-color signal',
              'The active row is marked by the pill, which is a filled, '
                  'shadowed shape rather than a colour change, so selection '
                  'survives without colour perception. The collapsed state '
                  "is signalled by the trigger's rolling glyph and by the "
                  'panel width itself.',
            ),
            _A11yRow(
              'Error wiring',
              'None: nothing in the family participates in validation.',
            ),
            _A11yRow(
              'Screen-reader announcements',
              'None. Collapsing, expanding, opening the mobile sheet and '
                  'moving the pill all announce nothing; there is no live '
                  'region anywhere. The mobile sheet does carry a container '
                  'label of "Sidebar" with a hint, which is the one place '
                  'the family names a region rather than a control.',
            ),
            _A11yRow(
              'Known platform differences',
              'The shortcut accepts either meta or control on every '
                  'platform, so Cmd-B works on Windows and Ctrl-B works on '
                  'macOS. Nothing else is platform-gated; the mobile branch '
                  'is chosen by width, not by operating system.',
              last: true,
            ),
          ],
        ),
      ),
      SizedBox(height: space(5)),
      Note(
        title: 'Correcting a plausible assumption about the collapsed rail',
        child: StyledText(
          'The tooltip component wires no Semantics at all, which makes '
          '"an icon-only row whose only label is a tooltip" the obvious '
          'accessibility failure to expect here. Read against the source, '
          'that is not what happens: SidebarMenuButton passes '
          'label ?? tooltip down as the button accessible name, so a row '
          'given a tooltip is properly named in the semantics tree whether '
          'or not the tooltip overlay is ever shown, and whether or not the '
          'panel is collapsed. The tooltip string is doing double duty as '
          'an accessible name, which is exactly the wiring the tooltip '
          'component itself lacks.',
          TextStyles.small,
        ),
      ),
      SizedBox(height: space(5)),
      Note(
        tone: NoteTone.error,
        title: 'Known gap: a collapsed row with neither label nor tooltip',
        child: StyledText(
          'The gap is narrower than the guess, and real. Both label and '
          'tooltip default to null, and nothing requires either. Expanded, '
          'such a row is still named, because its visible text supplies the '
          'name. Collapsed, SidebarMenuRow drops the text and renders the '
          'glyph alone, and a glyph carries no text: so the row becomes an '
          'unnamed button, announced as "button" and nothing more, at '
          'exactly the moment its label disappeared from the screen. Always '
          'give every SidebarMenuButton a tooltip, or an explicit label '
          'if the tooltip copy is wrong as a name. The same applies to '
          'SidebarInput, whose label is optional and which has no other '
          'accessible name.',
          TextStyles.small,
        ),
      ),
    ],
  );
}

/* ── Keyboard ─────────────────────────────────────────────────────────────── */

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Ctrl-B / Cmd-B toggles the panel from anywhere: '
            'SidebarProvider registers the shortcut on '
            'HardwareKeyboard.instance directly rather than on a Focus '
            'subtree, the port of a document-level listener. A page '
            'carrying several providers installs several handlers, and '
            'the shortcut toggles all of them, matching the reference.',
        'Platform parity: the shortcut accepts either meta or control on '
            'every platform, so Cmd-B works on Windows and Ctrl-B works '
            'on macOS.',
        'Every other control activates the ordinary way: the trigger, '
            'every menu row, every sub-button, the group and menu '
            'actions, and the disclosure line are all buttons '
            "underneath and answer Enter/Space once focused — inherited "
            "from Button's own key handling, not wired again here.",
        'Tab order: sidebar.dart declares no FocusTraversalPolicy of its '
            "own; Tab and Shift+Tab walk whatever order the panel's own "
            'child list declares.',
        'The rail takes no focus at all, reproducing the reference '
            'tabIndex of -1: it is a 16px pointer shortcut a keyboard '
            'user cannot reach. SidebarTrigger does the same job and '
            'is always the reachable alternative.',
        'Two known gaps, not fixed here: in icon mode, sub-menus and '
            'sub-buttons are removed from the tree entirely, so focus '
            'resting on one is dropped without warning; in offcanvas '
            'mode nothing unmounts, so focus can still travel into rows '
            'that have slid off screen and are invisible. Neither case '
            'is guarded.',
      ]);
}

/* ── Responsive ──────────────────────────────────────────────────────────── */

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(
        title: 'The breakpoint, and what it switches',
        facts: _responsiveFacts,
      ),
      SizedBox(height: space(5)),
      Note(
        title: 'Two known divergences worth planning around',
        child: StyledText(
          'The rail paints as a 16px strip straddling the panel edge but '
          'only answers a click on its inner half: Flutter hit-tests '
          'nothing outside a box, and the outer half lies over the main '
          'column, which is a later sibling and therefore tested first. CSS '
          'has a stacking index for this and Flutter has no cross-sibling '
          'equivalent. Separately, the reference writes a seven-day cookie '
          'on every toggle so a reload keeps the panel state; there is no '
          'cookie and no store here, so open state does not survive a '
          'restart. If a project needs it, drive the panel with open and '
          'onOpenChange and persist it yourself.',
          TextStyles.small,
        ),
      ),
    ],
  );
}

/* ── Dependencies ────────────────────────────────────────────────────────── */

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        facts: <DocsInstallFact>[
          const DocsInstallFact(
            label: 'Status',
            value: 'Stable and installable through `elattar add sidebar`',
            description:
                'All thirty-six public names are exported from the '
                'public barrel and covered by test/sidebar_test.dart.',
          ),
          const DocsInstallFact(
            label: 'Registry item',
            value: 'sidebar',
            description:
                'registry/components/sidebar.json exists and is '
                'installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Family size',
            value: '33 exports in sidebar.dart, 3 in user_menu.dart',
            description:
                'Provider, two inherited scopes, the panel, rail, '
                'trigger, inset, six regions, four group parts, twelve '
                'menu parts, one field, and the footer account block.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/sidebar.dart',
            description:
                'Where the sidebar manifest installs to. user_menu.dart '
                'installs to the same lib/components/ui/ target through '
                'its own registry item, user-menu, not through this one.',
          ),
          const DocsInstallFact(
            label: 'Foundation',
            value: 'source or package compatible',
            description:
                'Nothing in either file is package-mode-only; every '
                'token comes through the foundation.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: sidebarDoc.dependencies.join(', '),
            description:
                "The sidebar manifest's own registryDependencies, "
                'resolved automatically by `elattar add sidebar`. '
                "user-menu's own manifest additionally depends on avatar, "
                'dropdown-menu, menu, popover, and sidebar itself.',
          ),
          const DocsInstallFact(
            label: 'Assets',
            value: 'none',
            description:
                'No image, font, or shader asset is referenced. Glyphs '
                'come from the generated icon paths.',
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
                'test/sidebar_test.dart covers collapse, variants, rows, '
                'the pill, tooltips, disclosure and the mobile branch '
                "against the reference's own measurements; this page's "
                'own test drives the live specimens.',
          ),
        ],
      ),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Badge', route: '/components/badge'),
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Collapsible', route: '/components/collapsible'),
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Icon Swap', route: '/components/icon_swap'),
          DocsLink(label: 'Input', route: '/components/input'),
          DocsLink(label: 'Keyframes', route: '/components/keyframes'),
          DocsLink(label: 'Machine Surface', route: '/components/surface'),
          DocsLink(label: 'Sheet', route: '/components/sheet'),
          DocsLink(label: 'Skeleton', route: '/components/skeleton'),
          DocsLink(
            label: 'Source Foundation',
            route: '/components/source_foundation',
          ),
          DocsLink(label: 'Tooltip', route: '/components/tooltip'),
          DocsLink(label: 'User Menu', route: '/components/user_menu'),
        ],
      ),
    ],
  );
}

/* ── Theming ─────────────────────────────────────────────────────────────── */

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Panel(
        label: 'What actually varies with the theme',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StyledText(
              'The panel has its own colour pair, separate from the page: '
              'the sidebar fill and the sidebar foreground, which every '
              'region inherits as ambient ink. Borders inside the panel use '
              'the sidebar border colour, while the panel edge itself uses '
              'the ordinary border colour: those are two different tokens '
              'and the difference is visible in both themes. This is the '
              'port of the reference --sidebar-* custom properties: fixed '
              'foundation tokens rather than CSS variables, but the same '
              'pair in both places.',
              TextStyles.small,
            ),
            SizedBox(height: space(3)),
            StyledText(
              'The active row does not paint a fill. The pill does, from '
              'the secondary colour with the chip shadow spec, because a '
              'fill alone reads as a smudge and a fill with an edge reads '
              'as a surface. The active row changes only its ink, to the '
              'sidebar accent foreground.',
              TextStyles.small,
            ),
            SizedBox(height: space(3)),
            StyledText(
              'The group label deliberately does not dim. Stock renders it '
              'at 70% strength, which it could afford because its token was '
              'a dark grey; here the token is already the lightest step '
              'that clears AA on both the background and the muted '
              'surfaces, and 70% of it measures 2.76:1 against the 4.5:1 it '
              'owes. At full strength it measures 4.83:1.',
              TextStyles.small,
            ),
            SizedBox(height: space(3)),
            StyledText(
              'Two typed parts collide with their own utilities and lose, '
              'and both are reproduced rather than fixed: the menu badge '
              'keeps only its mono family, tabular figures and tracking, '
              'and the account avatar fallback keeps its weight but not its '
              'size.',
              TextStyles.small,
            ),
          ],
        ),
      ),
      SizedBox(height: space(5)),
      const DocsApiTable(
        title: 'Layout tokens the family exposes',
        facts: _themingFacts,
      ),
    ],
  );
}

/* ── Small shared bits ───────────────────────────────────────────────────── */

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

class _A11yRow extends StatelessWidget {
  const _A11yRow(this.label, this.body, {this.last = false});

  final String label;
  final String body;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : space(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StyledText(label, TextStyles.section, color: theme.actionText),
          SizedBox(height: space(1)),
          StyledText(body, TextStyles.small),
        ],
      ),
    );
  }
}

/* ── Live specimens ──────────────────────────────────────────────────────── */

const UserMenuAccount _account = UserMenuAccount(
  name: 'Ayoub Elattar',
  email: 'ayoub@elattar.dev',
);

const List<UserMenuItem> _accountItems = <UserMenuItem>[
  UserMenuItem(label: 'Account', icon: Lucide.badgeCheck),
  UserMenuItem(label: 'Billing', icon: Lucide.creditCard),
  UserMenuItem(label: 'Notifications', icon: Lucide.bell),
  UserMenuItem(label: 'Sign out', icon: Lucide.logOut, destructive: true),
];

const List<({String label, IconGlyph icon})> _shellRows =
    <({String label, IconGlyph icon})>[
      (label: 'Overview', icon: IconGlyph.layers),
      (label: 'Segments', icon: IconGlyph.star),
      (label: 'Revenue', icon: IconGlyph.wallet),
    ];

/// The primary specimen: a real app shell that collapses to an icon rail.
class _ShellSpecimen extends StatelessWidget {
  const _ShellSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return ClipRect(
      child: SizedBox(
        key: const ValueKey<String>('sidebar-doc-specimen-shell'),
        height: space(96),
        child: SidebarProvider(
          children: <Widget>[
            Sidebar(
              collapsible: SidebarCollapsible.icon,
              children: <Widget>[
                SidebarHeader(
                  children: <Widget>[
                    SidebarMenu(
                      children: <Widget>[
                        SidebarMenuItem(
                          button: SidebarMenuButton(
                            size: SidebarMenuButtonSize.lg,
                            tooltip: 'Elattar',
                            child: SidebarMenuRow(
                              size: SidebarMenuButtonSize.lg,
                              leading: Icon(
                                IconGlyph.sparkles,
                                sizePx: Button.iconPxFor(ButtonSize.lg),
                              ),
                              label: const SidebarMenuLabel('Elattar'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SidebarContent(
                  children: <Widget>[
                    SidebarGroup(
                      children: <Widget>[
                        const SidebarGroupLabel('Platform'),
                        SidebarGroupContent(
                          child: SidebarMenu(
                            children: <Widget>[
                              for (int i = 0; i < _shellRows.length; i++)
                                SidebarMenuItem(
                                  button: SidebarMenuButton(
                                    isActive: i == 0,
                                    tooltip: _shellRows[i].label,
                                    child: SidebarMenuRow(
                                      leading: Icon(
                                        _shellRows[i].icon,
                                        sizePx: Button.iconPxFor(ButtonSize.sm),
                                      ),
                                      label: SidebarMenuLabel(
                                        _shellRows[i].label,
                                      ),
                                    ),
                                  ),
                                  submenu: i == 0
                                      ? const SidebarMenuSub(
                                          children: <Widget>[
                                            SidebarMenuSubItem(
                                              child: SidebarMenuSubButton(
                                                label: 'Live',
                                                isActive: true,
                                              ),
                                            ),
                                            SidebarMenuSubItem(
                                              child: SidebarMenuSubButton(
                                                label: 'Archived',
                                              ),
                                            ),
                                          ],
                                        )
                                      : null,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SidebarFooter(
                  children: <Widget>[
                    UserMenu(user: _account, items: _accountItems),
                  ],
                ),
                const SidebarRail(),
              ],
            ),
            SidebarInset(
              child: Padding(
                padding: EdgeInsets.all(space(4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Horizontally scrolling, not `Expanded`: the
                    // mobile-sheet branch of this same specimen can squeeze
                    // the main column to a sliver a few pixels wide (the
                    // sheet itself pays a fixed LayoutWidths.sidebarMobile out
                    // of the same narrow stage), narrower than
                    // SidebarTrigger's own touch target — an unconstrained
                    // Row here overflowed at exactly that width. Scrolling
                    // rather than clipping keeps the trigger reachable
                    // either way.
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          const SidebarTrigger(),
                          SizedBox(width: space(2)),
                          StyledText(
                            'Overview',
                            TextStyles.h4,
                            color: theme.foreground,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: space(3)),
                    StyledText(
                      'The panel travels 256 to 48 over 250ms. The labels, '
                      'the nested list and the group heading go; the rows '
                      'stay, as 32px squares that name themselves through '
                      'their tooltips.',
                      TextStyles.small,
                      color: theme.mutedForeground,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The third collapse mode, live.
class _OffcanvasSpecimen extends StatelessWidget {
  const _OffcanvasSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return ClipRect(
      child: SizedBox(
        key: const ValueKey<String>('sidebar-doc-specimen-offcanvas'),
        height: space(64),
        child: SidebarProvider(
          children: <Widget>[
            Sidebar(
              children: <Widget>[
                SidebarContent(
                  children: <Widget>[
                    SidebarGroup(
                      children: <Widget>[
                        const SidebarGroupLabel('Workspace'),
                        SidebarGroupContent(
                          child: SidebarMenu(
                            children: <Widget>[
                              for (int i = 0; i < _shellRows.length; i++)
                                SidebarMenuItem(
                                  button: SidebarMenuButton(
                                    isActive: i == 1,
                                    tooltip: _shellRows[i].label,
                                    child: SidebarMenuRow(
                                      leading: Icon(
                                        _shellRows[i].icon,
                                        sizePx: Button.iconPxFor(ButtonSize.sm),
                                      ),
                                      label: SidebarMenuLabel(
                                        _shellRows[i].label,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SidebarRail(),
              ],
            ),
            SidebarInset(
              child: Padding(
                padding: EdgeInsets.all(space(4)),
                child: Row(
                  children: <Widget>[
                    const SidebarTrigger(),
                    SizedBox(width: space(2)),
                    Expanded(
                      child: StyledText(
                        'Offcanvas: the gap closes to nothing and the panel '
                        'keeps its 256 as it leaves.',
                        TextStyles.small,
                        color: theme.mutedForeground,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The part stage: every region and menu part on one non-collapsing panel.
class _PartsSpecimen extends StatelessWidget {
  const _PartsSpecimen();

  @override
  Widget build(BuildContext context) => SizedBox(
    key: const ValueKey<String>('sidebar-doc-specimen-parts'),
    height: space(120),
    child: SidebarProvider(
      children: <Widget>[
        Expanded(
          child: Sidebar(
            collapsible: SidebarCollapsible.none,
            expand: true,
            children: <Widget>[
              const SidebarHeader(
                children: <Widget>[
                  SidebarInput(placeholder: 'Search', label: 'Search'),
                ],
              ),
              SidebarContent(
                children: <Widget>[
                  SidebarGroup(
                    children: <Widget>[
                      const SidebarGroupLabel('Platform'),
                      SidebarGroupContent(
                        child: SidebarMenu(
                          children: <Widget>[
                            SidebarMenuItem(
                              button: SidebarMenuButton(
                                isActive: true,
                                tooltip: 'Reports',
                                child: SidebarMenuRow(
                                  leading: Icon(
                                    IconGlyph.layers,
                                    sizePx: Button.iconPxFor(ButtonSize.sm),
                                  ),
                                  label: const SidebarMenuLabel('Reports'),
                                ),
                              ),
                              badge: const SidebarMenuBadge('3'),
                            ),
                            SidebarMenuItem(
                              button: SidebarMenuButton(
                                tooltip: 'Segments',
                                child: SidebarMenuRow(
                                  leading: Icon(
                                    IconGlyph.star,
                                    sizePx: Button.iconPxFor(ButtonSize.sm),
                                  ),
                                  label: const SidebarMenuLabel('Segments'),
                                ),
                              ),
                              action: const SidebarMenuAction(
                                label: 'Add segment',
                                child: Icon(IconGlyph.plus),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SidebarSeparator(),
                  SidebarCollapsibleGroup(
                    label: 'Collection',
                    toggleLabel: 'Toggle Collection group',
                    action: const SidebarGroupAction(
                      label: 'Add to collection',
                      child: Icon(IconGlyph.plus),
                    ),
                    child: SidebarMenu(
                      children: <Widget>[
                        SidebarMenuItem(
                          button: SidebarMenuButton(
                            tooltip: 'Wallet',
                            child: SidebarMenuRow(
                              leading: Icon(
                                IconGlyph.wallet,
                                sizePx: Button.iconPxFor(ButtonSize.sm),
                              ),
                              label: const SidebarMenuLabel('Wallet'),
                            ),
                          ),
                          submenu: const SidebarMenuSub(
                            children: <Widget>[
                              SidebarMenuSubItem(
                                child: SidebarMenuSubButton(
                                  label: 'Open',
                                  isActive: true,
                                ),
                              ),
                              SidebarMenuSubItem(
                                child: SidebarMenuSubButton(label: 'Settled'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SidebarGroup(
                    children: <Widget>[
                      SidebarGroupLabel('Loading'),
                      SidebarGroupContent(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SidebarMenuSkeleton(showIcon: true, seed: 'row-1'),
                            SidebarMenuSkeleton(showIcon: true, seed: 'row-2'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/* ── Code samples ────────────────────────────────────────────────────────── */

const String _previewCode = '''SidebarProvider(
  children: [
    Sidebar(
      collapsible: SidebarCollapsible.icon,
      children: [
        SidebarHeader(
          children: [
            SidebarMenu(
              children: [
                SidebarMenuItem(
                  button: SidebarMenuButton(
                    size: SidebarMenuButtonSize.lg,
                    tooltip: 'Elattar',
                    child: SidebarMenuRow(
                      size: SidebarMenuButtonSize.lg,
                      leading: Icon(IconGlyph.sparkles,
                          sizePx: Button.iconPxFor(ButtonSize.lg)),
                      label: const SidebarMenuLabel('Elattar'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SidebarContent(
          children: [
            SidebarGroup(
              children: [
                const SidebarGroupLabel('Platform'),
                SidebarGroupContent(
                  child: SidebarMenu(
                    children: [
                      // Every row is named by its own tooltip, so the name
                      // survives once the panel collapses to a rail.
                      SidebarMenuItem(
                        button: SidebarMenuButton(
                          isActive: true,
                          tooltip: 'Overview',
                          child: SidebarMenuRow(
                            leading: Icon(IconGlyph.layers,
                                sizePx: Button.iconPxFor(ButtonSize.sm)),
                            label: const SidebarMenuLabel('Overview'),
                          ),
                        ),
                        submenu: const SidebarMenuSub(
                          children: [
                            SidebarMenuSubItem(
                              child: SidebarMenuSubButton(
                                  label: 'Live', isActive: true),
                            ),
                            SidebarMenuSubItem(
                              child: SidebarMenuSubButton(label: 'Archived'),
                            ),
                          ],
                        ),
                      ),
                      // ...more rows
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SidebarFooter(
          children: [UserMenu(user: account, items: accountItems)],
        ),
        const SidebarRail(),
      ],
    ),
    SidebarInset(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SidebarTrigger(),
              const Text('Overview'),
            ],
          ),
          // The panel travels 256 to 48 over 250ms: labels, the nested
          // list and the group heading go; the rows stay, as 32px
          // squares that name themselves through their tooltips.
        ],
      ),
    ),
  ],
)''';

const String _compositionCode = '''SidebarProvider(
  children: [
    Sidebar(
      collapsible: SidebarCollapsible.none,
      expand: true,
      children: [
        const SidebarHeader(
          children: [SidebarInput(placeholder: 'Search', label: 'Search')],
        ),
        SidebarContent(
          children: [
            SidebarGroup(
              children: [
                const SidebarGroupLabel('Platform'),
                SidebarGroupContent(
                  child: SidebarMenu(
                    children: [
                      SidebarMenuItem(
                        button: SidebarMenuButton(
                          isActive: true,
                          tooltip: 'Reports',
                          child: SidebarMenuRow(
                            leading: Icon(IconGlyph.layers,
                                sizePx: Button.iconPxFor(ButtonSize.sm)),
                            label: const SidebarMenuLabel('Reports'),
                          ),
                        ),
                        badge: const SidebarMenuBadge('3'),
                      ),
                      SidebarMenuItem(
                        button: SidebarMenuButton(
                          tooltip: 'Segments',
                          child: SidebarMenuRow(
                            leading: Icon(IconGlyph.star,
                                sizePx: Button.iconPxFor(ButtonSize.sm)),
                            label: const SidebarMenuLabel('Segments'),
                          ),
                        ),
                        action: const SidebarMenuAction(
                          label: 'Add segment',
                          child: Icon(IconGlyph.plus),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SidebarSeparator(),
            // The trigger is the disclosure line itself, not the title
            // and not the action: the action performs its verb, the
            // divider only changes disclosure state.
            SidebarCollapsibleGroup(
              label: 'Collection',
              toggleLabel: 'Toggle Collection group',
              action: const SidebarGroupAction(
                label: 'Add to collection',
                child: Icon(IconGlyph.plus),
              ),
              child: SidebarMenu(
                children: [
                  SidebarMenuItem(
                    button: SidebarMenuButton(
                      tooltip: 'Wallet',
                      child: SidebarMenuRow(
                        leading: Icon(IconGlyph.wallet,
                            sizePx: Button.iconPxFor(ButtonSize.sm)),
                        label: const SidebarMenuLabel('Wallet'),
                      ),
                    ),
                    submenu: const SidebarMenuSub(
                      children: [
                        SidebarMenuSubItem(
                          child: SidebarMenuSubButton(
                              label: 'Open', isActive: true),
                        ),
                        SidebarMenuSubItem(
                          child: SidebarMenuSubButton(label: 'Settled'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // A caller renders SidebarMenuSkeleton in place of real rows
            // while its own data loads.
            const SidebarGroup(
              children: [
                SidebarGroupLabel('Loading'),
                SidebarGroupContent(
                  child: Column(
                    children: [
                      SidebarMenuSkeleton(showIcon: true, seed: 'row-1'),
                      SidebarMenuSkeleton(showIcon: true, seed: 'row-2'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
)''';

const String _offcanvasCode = '''SidebarProvider(
  children: [
    Sidebar(
      // collapsible: SidebarCollapsible.offcanvas is Sidebar's own
      // default: the gap closes to nothing and the panel keeps its full
      // 256 as it slides off the edge. Nothing unmounts.
      children: [
        SidebarContent(
          children: [
            SidebarGroup(
              children: [
                const SidebarGroupLabel('Workspace'),
                SidebarGroupContent(
                  child: SidebarMenu(
                    children: [
                      for (final row in rows)
                        SidebarMenuItem(
                          button: SidebarMenuButton(
                            isActive: row.isActive,
                            tooltip: row.label,
                            child: SidebarMenuRow(
                              leading: Icon(row.icon),
                              label: SidebarMenuLabel(row.label),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SidebarRail(),
      ],
    ),
    SidebarInset(
      child: Row(
        children: [
          const SidebarTrigger(),
          const Expanded(
            child: Text(
              'Offcanvas: the gap closes to nothing and the panel keeps '
              'its 256 as it leaves.',
            ),
          ),
        ],
      ),
    ),
  ],
)''';

const String _usageMinimalCode =
    '''import 'package:elattar_design_system/elattar_design_system.dart';

// The provider owns the state and the Ctrl-B / Cmd-B shortcut; the panel
// and the main column are its two flex children.
SidebarProvider(
  children: <Widget>[
    Sidebar(
      collapsible: SidebarCollapsible.icon,
      children: <Widget>[
        SidebarContent(
          children: <Widget>[
            SidebarGroup(
              children: <Widget>[
                const SidebarGroupLabel('Platform'),
                SidebarGroupContent(
                  child: SidebarMenu(
                    children: <Widget>[
                      SidebarMenuItem(
                        button: SidebarMenuButton(
                          isActive: true,
                          tooltip: 'Overview',
                          onPressed: () {},
                          child: SidebarMenuRow(
                            leading: Icon(
                              IconGlyph.layers,
                              sizePx: Button.iconPxFor(ButtonSize.sm),
                            ),
                            label: const SidebarMenuLabel('Overview'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SidebarRail(),
      ],
    ),
    const SidebarInset(child: SidebarTrigger()),
  ],
)''';

const String _usageRowCode =
    '''// A row that survives the collapse with its name intact.
//
// tooltip does two jobs: it is the label shown beside the collapsed glyph,
// AND the accessible name handed to the button underneath. A row given
// neither tooltip nor label becomes an unnamed button once collapsed,
// because the visible text that was naming it is gone.
SidebarMenuItem(
  button: SidebarMenuButton(
    isActive: selected == 'revenue',
    tooltip: 'Revenue',
    onPressed: () => select('revenue'),
    child: SidebarMenuRow(
      leading: Icon(
        IconGlyph.wallet,
        sizePx: Button.iconPxFor(ButtonSize.sm),
      ),
      label: const SidebarMenuLabel('Revenue'),
    ),
  ),
  // Both hide themselves in icon mode, and both widen the row's right
  // padding while they are visible.
  badge: const SidebarMenuBadge('3'),
)''';

const String _usageGroupCode =
    '''// The disclosure line is the trigger, not the title and not the action:
// clicking the action performs its verb, and the divider only changes
// disclosure state.
SidebarCollapsibleGroup(
  label: 'Collection',
  toggleLabel: 'Toggle Collection group',
  action: SidebarGroupAction(
    label: 'Add to collection',
    onPressed: () {},
    child: const Icon(IconGlyph.plus),
  ),
  child: SidebarMenu(
    children: [
      SidebarMenuItem(
        button: const SidebarMenuButton(
          tooltip: 'Wallet',
          child: SidebarMenuLabel('Wallet'),
        ),
        submenu: SidebarMenuSub(
          children: [
            SidebarMenuSubItem(
              child: SidebarMenuSubButton(
                label: 'Open',
                isActive: true,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    ],
  ),
)''';

const String _usageControlledCode =
    '''// Controlled: pass open AND onOpenChange. When onOpenChange is non-null it
// fully replaces the provider's own setState, so a provider that ignores it
// never moves. This is also the only way to persist panel state: the
// reference writes a seven-day cookie and this port has no store.
SidebarProvider(
  open: _open,
  onOpenChange: (bool next) => setState(() => _open = next),
  variant: SidebarVariant.inset,
  minHeight: MediaQuery.sizeOf(context).height,
  children: [
    Sidebar(
      // Must match the provider, Flutter has no :has() or peer- selector,
      // so the fact travels down twice.
      variant: SidebarVariant.inset,
      collapsible: SidebarCollapsible.icon,
      children: [/* regions */],
    ),
    SidebarInset(child: page),
  ],
)''';

const String _usageNavUserCode =
    '''// user_menu.dart: the account block a sidebar footer is incomplete
// without. It reads SidebarScope for isMobile, so it only works inside a
// provider, and it composes SidebarMenu itself: put it straight into the
// footer, not inside another menu.
SidebarFooter(
  children: [
    UserMenu(
      user: const UserMenuAccount(
        name: 'Ayoub Elattar',
        email: 'ayoub@elattar.dev',
      ),
      items: [
        UserMenuItem(label: 'Account', icon: Lucide.badgeCheck),
        UserMenuItem(label: 'Billing', icon: Lucide.creditCard),
        // Destructive items are gathered below a separator, wherever they
        // sit in the list.
        UserMenuItem(
          label: 'Sign out',
          icon: Lucide.logOut,
          destructive: true,
          onSelect: signOut,
        ),
      ],
    ),
  ],
)''';

const String _installShellExcerpt = '''enum SidebarSide { left, right }

enum SidebarVariant { sidebar, floating, inset }

enum SidebarCollapsible { offcanvas, icon, none }

class SidebarProvider extends StatefulWidget {
  const SidebarProvider({
    super.key,
    required this.children,
    this.defaultOpen = true,
    this.open,
    this.onOpenChange,
    this.variant = SidebarVariant.sidebar,
    this.minHeight,
  });

  static const LogicalKeyboardKey shortcut = LogicalKeyboardKey.keyB;
  static bool isMobileWidth(double width) => width < Breakpoints.md;
}

class Sidebar extends StatelessWidget {
  const Sidebar({
    super.key,
    required this.children,
    this.side = SidebarSide.left,
    this.variant = SidebarVariant.sidebar,
    this.collapsible = SidebarCollapsible.offcanvas,
    this.expand = false,
  });
}

// Plus: SidebarScope, SidebarChrome, SidebarRail, SidebarTrigger,
// SidebarInset, and the region, group and menu parts: see the API
// Reference section on this page for every one of them.''';

const String _installNavUserExcerpt = '''class UserMenuAccount {
  const UserMenuAccount({
    required this.name,
    required this.email,
    this.avatar,
  });

  String get initials;
}

class UserMenuItem {
  const UserMenuItem({
    required this.label,
    this.icon,
    this.onSelect,
    this.destructive = false,
  });
}

class UserMenu extends StatelessWidget {
  const UserMenu({super.key, required this.user, required this.items});

  static double get menuMinWidth => space(56);
}''';

/* ── Facts ────────────────────────────────────────────────────────────────── */

const List<DocsApiFact> _structureFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'SidebarProvider',
    type: 'the state',
    description:
        'Owns open, openMobile and the Ctrl-B / Cmd-B shortcut. Wraps '
        'one Sidebar and one SidebarInset as its two flex children.',
  ),
  DocsApiFact(
    name: 'Sidebar',
    type: 'the panel',
    description:
        'Reads the provider through SidebarScope and lays out its '
        'own regions: header, content, footer, and a rail on its edge.',
  ),
  DocsApiFact(
    name: 'SidebarInset',
    type: 'the main column',
    description:
        "Beside the panel, wrapped in an Expanded that is free to be "
        "narrower than its content: the port's spelling of min-w-0.",
  ),
  DocsApiFact(
    name: 'SidebarTrigger and SidebarRail',
    type: 'the controls',
    description:
        'Two ways to flip the panel: a button in the main column, and '
        "a thin strip on the panel's own edge.",
  ),
];

const List<DocsApiFact> _providerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'expanded (any mode)',
    type: 'gap 256 / panel 256',
    description:
        'LayoutWidths.sidebar. The gap is a real box in the row; the panel '
        'is an overflowing child of the gap, which is what a position: '
        'fixed container trapped by a transformed ancestor renders as.',
  ),
  DocsApiFact(
    name: 'icon, variant: sidebar',
    type: 'gap 48 / panel 48',
    description:
        'LayoutWidths.sidebarCollapsed. Both legs animate to the same 48, so the '
        'panel and the space it occupies stay identical.',
  ),
  DocsApiFact(
    name: 'icon, variant: floating or inset',
    type: 'gap 64 / panel 66',
    description:
        'Sidebar.insetIconGap is 48 + space(4) = 64, because those two '
        'variants pay their own 8px frame on both edges; '
        'Sidebar.insetIconWidth adds the two hairlines and is 66.',
  ),
  DocsApiFact(
    name: 'offcanvas',
    type: 'gap 0 / panel 256, slid -256',
    description:
        'The gap closes to nothing and the panel keeps its full width, '
        'travelling left by exactly its own width. Nothing unmounts: '
        'see Accessibility for what that costs.',
  ),
  DocsApiFact(
    name: 'none',
    type: 'always 256',
    description:
        'No gap, no container, no rail: a plain flex column that the '
        'trigger and the keyboard shortcut cannot move. Pass '
        'expand: true to let it fill its parent instead.',
  ),
  DocsApiFact(
    name: 'duration and curve',
    type: '250ms, linear',
    description:
        'MotionDurations.normal on MotionCurves.linear for all '
        'three legs: gap width, panel width, and the offcanvas slide. '
        'Measured as genuinely linear on the reference: even steps, no '
        'front-loading, no overshoot. Everything routes through '
        'effectiveMotionDuration, so reduced motion makes the whole '
        'collapse instant.',
  ),
  DocsApiFact(
    name: 'the row, mid-collapse',
    type: 'snaps, does not tween',
    description:
        'SidebarMenuButton.iconSize (32) lands whole on the first '
        'frame while the panel is still wide. The panel slides; its '
        'contents cut.',
  ),
];

const List<DocsApiFact> _collapsibleFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'offcanvas',
    type: 'the default',
    description:
        'The panel slides off the edge and the gap closes to nothing. '
        'Nothing unmounts.',
  ),
  DocsApiFact(
    name: 'icon',
    type: 'SidebarCollapsible',
    description:
        'The panel narrows to the icon rail and keeps its glyphs. '
        'Labels, badges, actions and sub-menus go; rows and tooltips '
        'stay.',
  ),
  DocsApiFact(
    name: 'none',
    type: 'SidebarCollapsible',
    description:
        'It does not collapse. No gap, no container, no rail, and the '
        'trigger and keyboard shortcut still flip the provider flag: '
        'they just have nothing to move.',
  ),
];

const List<DocsApiFact> _sidebarVariantFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'sidebar',
    type: 'the default',
    description:
        'Flush against the edge, with a hairline border on the inset '
        'side. The only variant that pays a border out of its own 256.',
  ),
  DocsApiFact(
    name: 'floating',
    type: 'SidebarVariant',
    description:
        'Inset by 8 on both edges, the panel itself a rounded card with '
        'a ring and a small shadow. No border, so it costs no layout.',
  ),
  DocsApiFact(
    name: 'inset',
    type: 'SidebarVariant',
    description:
        'Also inset by 8, but it is the main column that becomes the '
        'card: the provider paints the sidebar colour behind everything '
        'and the inset gains a rounded, shadowed panel of its own.',
  ),
];

const List<DocsApiFact> _sidebarSideFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'left',
    type: 'the default',
    description:
        'Border on the right, rail on the right edge, offcanvas travel '
        'to the left.',
  ),
  DocsApiFact(
    name: 'right',
    type: 'SidebarSide',
    description:
        'All four mirrored. The gap stays the first item in the row; it '
        'is the panel inside it that moves.',
  ),
];

const List<DocsApiFact> _rowLaddersFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'SidebarMenuButtonSize.sm / md / lg',
    type: 'button xs / sm / lg',
    description:
        'md is the default and measures 37.5px; lg measures 50 with a '
        '32px avatar in it, which is what the footer account row uses. '
        'Each maps onto the button ladder rather than inventing '
        'heights.',
  ),
  DocsApiFact(
    name: 'SidebarMenuSubButtonSize.sm / md',
    type: 'button xs / sm',
    description: 'md is the default: a 32px nested link.',
  ),
];

const List<DocsApiFact> _useSidebarFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'open / collapsed',
    type: 'bool / bool (get)',
    description:
        "The desktop panel's flag, and its negation. This is the whole "
        'of what the reference publishes as useSidebar().',
  ),
  DocsApiFact(
    name: 'openMobile / isMobile',
    type: 'bool / bool',
    description:
        "The mobile sheet's own flag, separate from open, and whether "
        'the viewport is under 768.',
  ),
  DocsApiFact(
    name: 'setOpen / setOpenMobile / toggleSidebar',
    type: 'ValueChanged<bool>, ValueChanged<bool>, VoidCallback',
    description:
        'toggleSidebar routes to whichever of the two flags the '
        'current width says is live.',
  ),
  DocsApiFact(
    name: 'of / maybeOf',
    type: 'static',
    description:
        'of asserts inside a provider, as useSidebar() throws; maybeOf '
        'is the non-throwing read the port uses where the reference '
        'would have had no consumer.',
  ),
];

const List<DocsApiFact> _headerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. A column with space(2) between children, inside the '
        'region padding: space(3) expanded, space(2) in icon mode.',
  ),
  DocsApiFact(
    name: 'gap',
    type: 'static double (get)',
    description: 'space(2) = 8. Shared by the footer.',
  ),
];

const List<DocsApiFact> _contentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'SidebarContent.children',
    type: 'List<Widget>',
    description:
        'Default const []. The one scrolling region in the panel, and '
        'the flex child that puts the footer on the floor. In icon '
        'mode it stops scrolling and clips instead.',
  ),
  DocsApiFact(
    name: 'SidebarSeparator()',
    type: 'const, key only',
    description:
        'A hairline in the sidebar border colour, inset space(3), space(2) '
        'in icon mode.',
  ),
];

const List<DocsApiFact> _groupFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'SidebarGroup.children',
    type: 'List<Widget>',
    description: 'Required. A padded column, same region padding.',
  ),
  DocsApiFact(
    name: 'SidebarGroupLabel(label)',
    type: 'String, positional',
    description:
        'Required. 32px tall, typed TextStyles.navSm at full strength: '
        'dimming it to 70% would measure 2.76:1 against the 4.5:1 it '
        'owes.',
  ),
  DocsApiFact(
    name: 'SidebarGroupAction',
    type: 'child, label, onPressed?',
    description:
        'child and label required. A 24px ghost square for the '
        "group's top-right corner, positioned by "
        'SidebarCollapsibleGroup: nothing else holds one.',
  ),
  DocsApiFact(
    name: 'SidebarCollapsibleGroup',
    type: 'label, toggleLabel, child',
    description:
        'label, toggleLabel and child required. The trigger is the '
        'disclosure line, not the title and not the action, so the '
        'two visible controls stay honest.',
  ),
];

const List<DocsApiFact> _menuFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'SidebarMenu.children',
    type: 'List<Widget>',
    description:
        'Required. The menu owns one travelling pill; the rows never '
        'paint their own selected fill. The pill is keyed on isActive '
        'rather than on disclosure state, so a row that is also a '
        'collapsible trigger does not drag the pill around when it '
        'opens.',
  ),
  DocsApiFact(
    name: 'SidebarMenu.gap',
    type: 'static double (get)',
    description: 'space(1) = 4, between rows.',
  ),
  DocsApiFact(
    name: 'SidebarMenuItem.button / action / badge / submenu',
    type: 'Widget, Widget?, Widget?, Widget?',
    description:
        'button required. The other three are optional row furniture: '
        'action and badge sit in the right lane, hidden in icon mode; '
        'submenu hangs a nested list under the row.',
  ),
];

const List<DocsApiFact> _menuButtonFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'isActive',
    type: 'bool',
    description:
        'Default false. Where the menu puts its pill. The row itself '
        'changes only its ink, so nothing reflows when selection '
        'moves.',
  ),
  DocsApiFact(
    name: 'tooltip / label',
    type: 'String?, String?',
    description:
        'Both default null. The accessible name resolves as '
        'label ?? tooltip; tooltip is also what shows beside the '
        'collapsed glyph. A row given neither becomes an unnamed '
        'button once collapsed: see Accessibility.',
  ),
  DocsApiFact(
    name: 'variant / size',
    type: 'ButtonVariant, SidebarMenuButtonSize',
    description:
        'Default ghost and md (37.5px tall). ghost rather than the '
        'button default, because a column of rows each painting '
        'bg-primary would be a wall of blue with no hierarchy left to '
        'spend.',
  ),
];

const List<DocsApiFact> _menuActionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child / label / onPressed',
    type: 'Widget, String, VoidCallback?',
    description:
        'child and label required. A 24px ghost square centred in its '
        'row. label is its only accessible name. Hidden in icon mode.',
  ),
];

const List<DocsApiFact> _menuSubFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'SidebarMenuSub.children',
    type: 'List<Widget>',
    description:
        'Required. The nested list, hung off a border spine. Renders '
        'nothing at all in icon mode.',
  ),
  DocsApiFact(
    name: 'SidebarMenuSubButton.label',
    type: 'String',
    description:
        'Required, and a String rather than a Widget: this part is '
        'always a link upstream, so it takes text.',
  ),
  DocsApiFact(
    name: 'SidebarMenuSubButton.isActive',
    type: 'bool',
    description:
        'Default false. A colour and nothing else: a sub-button never '
        'claims the pill, even when it is the only active thing on '
        'screen.',
  ),
];

const List<DocsApiFact> _menuBadgeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'SidebarMenuBadge(count)',
    type: 'String, positional',
    description:
        'Required. The count in the right lane, pointer-events-none '
        'so a click on it reaches the row underneath. Hidden in icon '
        'mode.',
  ),
  DocsApiFact(
    name: 'variant',
    type: 'BadgeVariant',
    description:
        "Default BadgeVariant.secondary: the sidebar's own default, "
        "not the badge's.",
  ),
];

const List<DocsApiFact> _menuSkeletonFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'showIcon',
    type: 'bool',
    description: 'Default false. Adds a 16px shimmer tile before the bar.',
  ),
  DocsApiFact(
    name: 'seed',
    type: 'String',
    description:
        "Default ''. Hashed to a width between 50% and 90%, so a "
        'column of skeletons reads as text rather than as identical '
        'bars.',
  ),
  DocsApiFact(
    name: 'height',
    type: 'static double (get)',
    description: 'space(8) = 32, the same as a collapsed row.',
  ),
];

const List<DocsApiFact> _triggerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'onPressed',
    type: 'VoidCallback?',
    description:
        'Default null. Called before the toggle, in that order. The '
        'trigger toggles regardless.',
  ),
  DocsApiFact(
    name: 'accessible name',
    type: 'hard-coded',
    description:
        'Both SidebarTrigger and SidebarRail publish "Toggle '
        'Sidebar" as their name.',
  ),
];

const List<DocsApiFact> _railFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'SidebarRail()',
    type: 'const, key only',
    description:
        'A marker. It renders SizedBox.shrink in the flow; Sidebar '
        'sees it in children and paints the strip in the slot it '
        'computed, because only the panel knows where its edge is.',
  ),
  DocsApiFact(
    name: 'hairline',
    type: 'static double (get)',
    description:
        'space(0.5) = 2. The hover rule down the middle of the strip. The '
        'rail takes no focus, reproducing the reference tabIndex of '
        '-1: it is a pointer shortcut, and SidebarTrigger is always '
        'the reachable alternative.',
  ),
];

const List<DocsApiFact> _apiProviderFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        "Required. The wrapper row's flex children: normally one "
        'Sidebar and one SidebarInset.',
  ),
  DocsApiFact(
    name: 'defaultOpen',
    type: 'bool',
    description:
        'Default true. The uncontrolled initial state. Ignored once '
        'open is passed.',
  ),
  DocsApiFact(
    name: 'open',
    type: 'bool?',
    description:
        'Default null. Pass it with onOpenChange to drive the panel '
        'from outside; the provider then never holds desktop state of '
        'its own.',
  ),
  DocsApiFact(
    name: 'onOpenChange',
    type: 'ValueChanged<bool>?',
    description:
        'Default null. When non-null it fully replaces the internal '
        'setState, so a controlled provider that ignores this callback '
        'will simply never open or close.',
  ),
  DocsApiFact(
    name: 'variant',
    type: 'SidebarVariant',
    description:
        'Default SidebarVariant.sidebar. Must match the variant '
        'given to Sidebar. Only inset changes what the provider '
        'itself paints: it fills the whole row with the sidebar '
        'colour.',
  ),
  DocsApiFact(
    name: 'minHeight',
    type: 'double?',
    description:
        'Default null. min-h-svh. Null because every specimen cancels '
        'it; a real application shell passes the viewport height.',
  ),
  DocsApiFact(
    name: 'shortcut',
    type: 'static LogicalKeyboardKey',
    description:
        'LogicalKeyboardKey.keyB. With meta or control held, it '
        'toggles. Registered on HardwareKeyboard.instance, not on a '
        'Focus node.',
  ),
  DocsApiFact(
    name: 'isMobileWidth',
    type: 'static bool Function(double)',
    description:
        'width < Breakpoints.md, i.e. under 768. The port of '
        'useIsMobile().',
  ),
];

const List<DocsApiFact> _apiSidebarFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        "Required. The panel's regions, top to bottom. A "
        'SidebarRail among them is what puts a rail on the edge; '
        'the widget itself contributes nothing to the column.',
  ),
  DocsApiFact(
    name: 'side',
    type: 'SidebarSide',
    description: 'Default SidebarSide.left.',
  ),
  DocsApiFact(
    name: 'variant',
    type: 'SidebarVariant',
    description:
        'Default SidebarVariant.sidebar. Must match '
        'SidebarProvider.variant.',
  ),
  DocsApiFact(
    name: 'collapsible',
    type: 'SidebarCollapsible',
    description:
        'Default SidebarCollapsible.offcanvas: note that this is not '
        'the icon rail most shells want.',
  ),
  DocsApiFact(
    name: 'expand',
    type: 'bool',
    description:
        'Default false. collapsible: none only: drops the fixed 256 so '
        'the panel fills its parent. A stage override upstream, a real '
        'parameter here.',
  ),
  DocsApiFact(
    name: 'insetIconGap',
    type: 'static double (get)',
    description:
        '64, LayoutWidths.sidebarCollapsed + space(4). The collapsed gap under '
        'floating and inset.',
  ),
  DocsApiFact(
    name: 'insetIconWidth',
    type: 'static double (get)',
    description: '66: insetIconGap plus the two hairlines.',
  ),
  DocsApiFact(
    name: 'framePadding',
    type: 'static double (get)',
    description: 'space(2) = 8. The p-2 floating and inset pay.',
  ),
  DocsApiFact(
    name: 'railWidth',
    type: 'static double (get)',
    description: 'space(4) = 16. The strip straddling the panel edge.',
  ),
];

const List<DocsApiFact> _apiRailTriggerInsetFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'SidebarRail()',
    type: 'const, key only',
    description:
        'A marker. It renders SizedBox.shrink in the flow; Sidebar '
        'sees it in children and paints the strip in the slot it '
        'computed, because only the panel knows where its edge is.',
  ),
  DocsApiFact(
    name: 'SidebarRail.hairline',
    type: 'static double (get)',
    description: 'space(0.5) = 2. The hover rule down the middle of the strip.',
  ),
  DocsApiFact(
    name: 'SidebarTrigger.onPressed',
    type: 'VoidCallback?',
    description:
        'Default null. Called before the toggle, in that order. The '
        'trigger toggles regardless.',
  ),
  DocsApiFact(
    name: 'SidebarInset.child',
    type: 'Widget',
    description:
        'Required. The main column beside the panel, wrapped in an '
        'Expanded that is free to be narrower than its content: the '
        "port's spelling of min-w-0.",
  ),
  DocsApiFact(
    name: 'SidebarInset.margin',
    type: 'static double (get)',
    description:
        'space(2) = 8. The inset variant only: 8px on three sides while '
        'open, all four once collapsed.',
  ),
];

const List<DocsApiFact> _apiRegionsFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'SidebarHeader.children',
    type: 'List<Widget>',
    description:
        'Required. A column with space(2) between children, inside the '
        'region padding: space(3) expanded, space(2) in icon mode.',
  ),
  DocsApiFact(
    name: 'SidebarHeader.gap',
    type: 'static double (get)',
    description: 'space(2) = 8. Shared by the footer.',
  ),
  DocsApiFact(
    name: 'SidebarFooter.children',
    type: 'List<Widget>',
    description:
        "Required. The header's twin. There is no mt-auto to port: "
        'the content region between them takes the slack.',
  ),
  DocsApiFact(
    name: 'SidebarContent.children',
    type: 'List<Widget>',
    description:
        'Default const []. The one scrolling region in the panel, and '
        'the flex child that puts the footer on the floor. In icon '
        'mode it stops scrolling and clips instead.',
  ),
  DocsApiFact(
    name: 'SidebarSeparator()',
    type: 'const, key only',
    description:
        'A hairline in the sidebar border colour, inset space(3), space(2) '
        'in icon mode. Painted here rather than composed from the '
        'separator primitive, because both the colour and the inset '
        'are overridden.',
  ),
  DocsApiFact(
    name: 'SidebarGroup.children',
    type: 'List<Widget>',
    description: 'Required. A padded column, same region padding.',
  ),
  DocsApiFact(
    name: 'SidebarGroupContent.child',
    type: 'Widget',
    description:
        'Required. Renders its child verbatim: it has no type of its '
        'own and exists so a call site reads like the reference.',
  ),
  DocsApiFact(
    name: 'SidebarGroupLabel(label)',
    type: 'String, positional',
    description:
        'Required. 32px tall, typed TextStyles.navSm at full strength: '
        'dimming it to 70% would measure 2.76:1 against the 4.5:1 it '
        'owes.',
  ),
  DocsApiFact(
    name: 'SidebarGroupLabel.padding',
    type: 'EdgeInsetsGeometry?',
    description:
        'Default null, which resolves to left space(3) / right space(10). '
        'SidebarCollapsibleGroup passes EdgeInsets.zero, so on a '
        'real page the declared padding never renders.',
  ),
  DocsApiFact(
    name: 'SidebarGroupLabel.height',
    type: 'static double (get)',
    description:
        'space(8) = 32. In icon mode the box animates to zero height and '
        'zero opacity, so the collapsed group loses the whole row.',
  ),
  DocsApiFact(
    name: 'SidebarGroupAction',
    type: 'child, label, onPressed?',
    description:
        'child and label required. A 24px ghost square for the '
        "group's top-right corner, positioned by "
        'SidebarCollapsibleGroup: nothing else holds one. label is '
        'its only accessible name.',
  ),
];

const List<DocsApiFact> _apiCollapsibleGroupFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'label',
    type: 'String',
    description: 'Required. The group title, in the header row.',
  ),
  DocsApiFact(
    name: 'toggleLabel',
    type: 'String',
    description:
        "Required. The trigger's accessible name. The trigger is the "
        'disclosure line, not the title and not the action, so that '
        'the two visible controls stay honest: the action performs its '
        'verb, the divider only changes disclosure.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The folding content.',
  ),
  DocsApiFact(
    name: 'action',
    type: 'Widget?',
    description:
        'Default null. A SidebarGroupAction, anchored in the '
        "group's top-right corner. Its presence also widens the "
        "trigger's right margin.",
  ),
  DocsApiFact(
    name: 'defaultOpen',
    type: 'bool',
    description:
        'Default true. Uncontrolled only: there is no open or '
        'onOpenChange on this part.',
  ),
  DocsApiFact(
    name: 'triggerHeight',
    type: 'static double (get)',
    description: 'space(6) = 24.',
  ),
  DocsApiFact(
    name: 'lineOpen / lineClosed',
    type: 'static double (get)',
    description:
        '1 and space(1) = 4. The disclosure line thickens from a '
        'hairline to 4px while closed, over 250ms.',
  ),
];

const List<DocsApiFact> _apiMenuFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. The menu owns one travelling pill; the rows never '
        'paint their own selected fill. The pill is keyed on isActive '
        'rather than on disclosure state, so a row that is also a '
        'collapsible trigger does not drag the pill around when it '
        'opens.',
  ),
  DocsApiFact(
    name: 'gap',
    type: 'static double (get)',
    description: 'space(1) = 4, between rows.',
  ),
];

const List<DocsApiFact> _apiMenuItemFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'button',
    type: 'Widget',
    description:
        'Required. The row: a SidebarMenuButton, or a dropdown '
        'trigger wrapping one.',
  ),
  DocsApiFact(
    name: 'action',
    type: 'Widget?',
    description:
        'Default null. A SidebarMenuAction, centred on the row and '
        'pinned space(1) from its right edge. Hidden in icon mode.',
  ),
  DocsApiFact(
    name: 'badge',
    type: 'Widget?',
    description:
        'Default null. A SidebarMenuBadge, pinned space(2) from the '
        'right edge. Hidden in icon mode.',
  ),
  DocsApiFact(
    name: 'submenu',
    type: 'Widget?',
    description:
        'Default null. A SidebarMenuSub, in flow under the row, '
        'which makes the item taller than its own button. This is the '
        'one relational question Flutter can answer, because the item '
        'is handed its children as a list.',
  ),
];

const List<DocsApiFact> _apiMenuButtonFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. Normally a SidebarMenuRow.',
  ),
  DocsApiFact(
    name: 'isActive',
    type: 'bool',
    description:
        'Default false. Where the menu puts its pill. The row itself '
        'changes only its ink, so nothing reflows when selection '
        'moves.',
  ),
  DocsApiFact(
    name: 'variant',
    type: 'ButtonVariant',
    description:
        'Default ButtonVariant.ghost: not the button default. A '
        'column of rows each painting bg-primary would be a wall of '
        'blue with no hierarchy left to spend.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'SidebarMenuButtonSize',
    description:
        'Default SidebarMenuButtonSize.md, which is 37.5px tall at '
        'h-auto with space(2) padding.',
  ),
  DocsApiFact(
    name: 'tooltip',
    type: 'String?',
    description:
        'Default null. Shown only once the panel has collapsed to a '
        'rail and never on mobile. It also becomes the accessible '
        'name when label is null: see Accessibility.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        'Default null. The accessible name, resolved as '
        'label ?? tooltip and handed to the underlying button.',
  ),
  DocsApiFact(
    name: 'onPressed',
    type: 'VoidCallback?',
    description:
        'Default null, and null becomes an empty callback rather than '
        'a disabled row: this family has no disabled state.',
  ),
  DocsApiFact(
    name: 'expanded',
    type: 'bool',
    description:
        'Default false. aria-expanded, for a row that is also a '
        'dropdown trigger.',
  ),
  DocsApiFact(
    name: 'suppressPressScale',
    type: 'bool',
    description:
        'Default false. Cancels the press scale, which a row that '
        'opens a menu wants so the trigger does not shrink under the '
        'menu it just opened.',
  ),
  DocsApiFact(
    name: 'padding / actionLane / badgeLane',
    type: 'static double (get)',
    description:
        'space(2) = 8, space(10) = 40, space(16) = 64. The right padding a row '
        'reserves when its item carries an action or a badge.',
  ),
  DocsApiFact(
    name: 'iconSize',
    type: 'static double (get)',
    description:
        'space(8) = 32. The collapsed row is a hard square and gets '
        'there in one frame.',
  ),
];

const List<DocsApiFact> _apiRowContentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'SidebarMenuRow.label',
    type: 'Widget',
    description: 'Required. The label span, expanded to fill the line.',
  ),
  DocsApiFact(
    name: 'SidebarMenuRow.leading',
    type: 'Widget?',
    description:
        'Default null. The glyph, already sized by the caller from '
        "Button.iconPxFor. In icon mode the row renders this and "
        'nothing else: and if it is null, the text label survives the '
        'collapse instead, clipped to 32px.',
  ),
  DocsApiFact(
    name: 'SidebarMenuRow.trailing',
    type: 'Widget?',
    description: 'Default null. Anything after the label.',
  ),
  DocsApiFact(
    name: 'SidebarMenuRow.size',
    type: 'SidebarMenuButtonSize',
    description:
        'Default md. Only picks the gap between glyph and label; pass '
        'the same value the button has.',
  ),
  DocsApiFact(
    name: 'SidebarMenuLabel(text)',
    type: 'String, positional',
    description:
        'Required. One truncating line, laid out in a CSS line box so '
        'a 13px label measures 19.5 rather than the 20 the engine '
        'would round to. Its style is read from the ambient default '
        'rather than passed, because the row ladder has already '
        'resolved it.',
  ),
];

const List<DocsApiFact> _apiMenuActionBadgeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'SidebarMenuAction.child / label / onPressed',
    type: 'Widget, String, VoidCallback?',
    description:
        'child and label required. A 24px ghost square for the row\'s '
        "right lane. label is its only accessible name.",
  ),
  DocsApiFact(
    name: 'SidebarMenuBadge(count)',
    type: 'String, positional',
    description:
        'Required. The count in the right lane, pointer-events-none '
        'so a click on it reaches the row underneath.',
  ),
  DocsApiFact(
    name: 'SidebarMenuBadge.variant',
    type: 'BadgeVariant',
    description:
        "Default BadgeVariant.secondary: the sidebar's own default, "
        "not the badge's.",
  ),
  DocsApiFact(
    name: 'SidebarMenuBadge.paddingX / minWidth',
    type: 'static double (get)',
    description: 'space(1.5) = 6 and space(5) = 20.',
  ),
];

const List<DocsApiFact> _apiMenuSkeletonFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'showIcon',
    type: 'bool',
    description: 'Default false. Adds a 16px shimmer tile before the bar.',
  ),
  DocsApiFact(
    name: 'seed',
    type: 'String',
    description:
        "Default ''. Hashed to a width between 50% and 90%, so a "
        'column of skeletons reads as text rather than as identical '
        'bars. The reference hashes useId() so server and client '
        'agree; there is no hydration here, so the seed is the '
        "caller's.",
  ),
  DocsApiFact(
    name: 'widthFraction',
    type: 'static double Function(String)',
    description:
        'The hash itself, exposed so the width is testable without '
        'mounting anything.',
  ),
  DocsApiFact(
    name: 'height',
    type: 'static double (get)',
    description: 'space(8) = 32, the same as a collapsed row.',
  ),
];

const List<DocsApiFact> _apiSubMenuFieldFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'SidebarMenuSub.children',
    type: 'List<Widget>',
    description:
        'Required. The nested list, hung off a border spine. Renders '
        'nothing at all in icon mode.',
  ),
  DocsApiFact(
    name: 'SidebarMenuSubItem.child',
    type: 'Widget',
    description: 'Required. Renders its child verbatim.',
  ),
  DocsApiFact(
    name: 'SidebarMenuSubButton.label',
    type: 'String',
    description:
        'Required, and a String rather than a Widget: this part is '
        'always a link upstream, so it takes text.',
  ),
  DocsApiFact(
    name: 'SidebarMenuSubButton.isActive',
    type: 'bool',
    description:
        'Default false. A colour and nothing else: a sub-button never '
        'claims the pill, even when it is the only active thing on '
        'screen.',
  ),
  DocsApiFact(
    name: 'SidebarMenuSubButton.variant / size / onPressed',
    type: 'ButtonVariant, SidebarMenuSubButtonSize, VoidCallback?',
    description: 'Defaults ghost, md, and null.',
  ),
  DocsApiFact(
    name: 'SidebarInput.placeholder / label / controller / padding',
    type: 'String?, String?, TextEditingController?, EdgeInsetsGeometry?',
    description:
        'All default null. A 32px flat field filled with the '
        'background colour rather than the input colour, so it reads '
        'as a well cut into the panel. label is its accessible name.',
  ),
  DocsApiFact(
    name: 'SidebarInput.height',
    type: 'static double (get)',
    description: 'space(8) = 32.',
  ),
];

const List<DocsApiFact> _apiScopesFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'SidebarScope.open / collapsed',
    type: 'bool / bool (get)',
    description:
        "The desktop panel's flag, and its negation. This is the whole "
        'of what the reference publishes as useSidebar().',
  ),
  DocsApiFact(
    name: 'SidebarScope.openMobile',
    type: 'bool',
    description:
        "The mobile sheet's own flag: a separate boolean, as it is "
        'upstream. Collapsing on desktop does not open the sheet, and '
        'closing the sheet does not collapse the panel.',
  ),
  DocsApiFact(
    name: 'SidebarScope.isMobile',
    type: 'bool',
    description: 'The viewport is under 768.',
  ),
  DocsApiFact(
    name: 'SidebarScope.setOpen / setOpenMobile / toggleSidebar',
    type: 'ValueChanged<bool>, ValueChanged<bool>, VoidCallback',
    description:
        'toggleSidebar routes to whichever of the two flags the '
        'current width says is live.',
  ),
  DocsApiFact(
    name: 'SidebarScope.of / maybeOf',
    type: 'static',
    description:
        'of asserts inside a provider, as useSidebar() throws; maybeOf '
        'is the non-throwing read the port uses where the reference '
        'would have had no consumer.',
  ),
  DocsApiFact(
    name: 'SidebarChrome.side / variant / collapsible',
    type: 'SidebarSide, SidebarVariant, SidebarCollapsible?',
    description:
        'What the panel publishes to the regions inside it. '
        'collapsible is the collapse mode while collapsed and null '
        'while expanded, which is the reference conditional exactly.',
  ),
  DocsApiFact(
    name: 'SidebarChrome.iconMode / iconModeOf',
    type: 'bool (get) / static bool Function(BuildContext)',
    description:
        'The one predicate fifteen layout rules read. False outside a '
        'panel, which is what an element carrying no collapse '
        'attribute resolves to.',
  ),
];

const List<DocsApiFact> _apiNavUserFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'UserMenu.user',
    type: 'UserMenuAccount',
    description:
        'Required. Composes one lg row holding an avatar, a two-line '
        'identity block and a chevron, opening a menu that repeats the '
        'identity at its head.',
  ),
  DocsApiFact(
    name: 'UserMenu.items',
    type: 'List<UserMenuItem>',
    description:
        'Required, with no default on purpose: a default list would '
        'put invented product actions into a chassis meant to travel '
        'into the next project.',
  ),
  DocsApiFact(
    name: 'UserMenu.menuMinWidth',
    type: 'static double (get)',
    description: 'space(56) = 224, the floor under the trigger width.',
  ),
  DocsApiFact(
    name: 'UserMenuAccount.name / email / avatar',
    type: 'String, String, ImageProvider?',
    description:
        'name and email required. initials is derived: the first '
        'letter of each of the first two words, uppercased.',
  ),
  DocsApiFact(
    name: 'UserMenuItem.label / icon / onSelect / destructive',
    type: 'String, LucideGlyph?, VoidCallback?, bool',
    description:
        'label required; destructive defaults false. Destructive '
        'items are gathered below a separator and rendered in the '
        'destructive tone, regardless of where they sit in the list.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'Expanded: a 256px panel of ghost rows on the sidebar colour. '
        'Collapsed: a 48px rail of 32px glyph squares.',
    userSignal: 'The pill marks the active row; nothing else is painted.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        "A row springs to the secondary colour over 250ms on the "
        "button's own colour spring. In icon mode that fill is "
        'cancelled outright: the tooltip carries the feedback instead, '
        'because a painted ghost surface turns a quiet glyph into a '
        'detached 32px boxed control. The rail shows a 2px rule down '
        'its middle, or a full fill when the mode is offcanvas.',
    userSignal:
        'Colour on the row; a rule or fill on the rail; a label beside '
        'a collapsed glyph.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        "Every control except the rail is a button and carries the "
        "button's own focus ring: the trigger, every menu row, every "
        'sub-button, group and menu actions, and the disclosure line. '
        'The rail deliberately takes no focus.',
    userSignal:
        'A ring on the control. Nothing appears on the rail, by design.',
  ),
  DocsStateFact(
    state: 'Pressed',
    treatment:
        'The button press scale, unless suppressPressScale is set, '
        'which the account row does, because it opens a menu over '
        'itself.',
    userSignal: 'The row dips under the pointer.',
  ),
  DocsStateFact(
    state: 'Selected',
    treatment:
        'isActive moves the menu indicator: 250ms of spring travel, a 150ms '
        'fade, and a 600ms jelly squash on arrival. The row itself '
        'changes only its ink to the sidebar accent colour: no weight '
        'change, so nothing reflows. When two rows claim it, the '
        'topmost wins, and a sub-button never claims it at all.',
    userSignal: 'One filled, shadowed pill travels to the newly active row.',
  ),
  DocsStateFact(
    state: 'Loading',
    treatment:
        'N/A: nothing in the family is asynchronous. '
        'SidebarMenuSkeleton is a shimmer row a caller renders '
        'instead of real rows while its own data loads; the menu has '
        'no loading state of its own to enter.',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Empty',
    treatment:
        'Partly applicable. SidebarContent.children defaults to an '
        'empty list and renders an empty scrolling column: there is no '
        'empty-state affordance, and none is invented here. A panel '
        'with nothing in it is a blank panel.',
    userSignal: 'Nothing. The caller supplies any empty copy.',
  ),
  DocsStateFact(
    state: 'Error',
    treatment:
        'N/A: no validation anywhere. SidebarInput delegates to the '
        'input primitive but exposes no invalid flag, so a sidebar '
        'field cannot be put into an error state through this API.',
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
        'N/A: there is no enabled or disabled parameter anywhere in '
        'the family. SidebarMenuButton and SidebarMenuSubButton '
        'substitute an empty callback when onPressed is null, so a row '
        'without a handler is an inert row rather than a disabled one, '
        'and it still reports itself as an enabled button.',
    userSignal:
        'N/A: and worth knowing: a null handler looks identical to a '
        'working one.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Every animation in the family runs through '
        'effectiveMotionDuration: the three collapse legs, the group label '
        'fold, the disclosure line, the rail hover, the pill travel '
        'and its fade, and the jelly squash. Under reduced motion the '
        'collapse is instant and the pill teleports.',
    userSignal: 'The same end states, reached without travel.',
  ),
];

const List<DocsApiFact> _responsiveFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'the threshold',
    type: 'width < 768',
    description:
        'SidebarProvider.isMobileWidth compares the media query '
        'width against Breakpoints.md. 767 is mobile, 768 is not. '
        'This is the port of a max-width media query, read from '
        'MediaQuery rather than from the platform, so a resized '
        'desktop window crosses it exactly as a phone does.',
  ),
  DocsApiFact(
    name: 'below 768',
    type: 'a sheet, 288 wide',
    description:
        'The gap-and-container pair is not built at all. The panel '
        'becomes a sheet on the same side at LayoutWidths.sidebarMobile '
        '(288: deliberately wider than the 256 desktop panel, because '
        'a sheet has no main column beside it competing for the eye), '
        'with its close button hidden and a container label of '
        '"Sidebar".',
  ),
  DocsApiFact(
    name: 'the second flag',
    type: 'openMobile',
    description:
        'The sheet is driven by its own boolean, separate from open. '
        'Until something sets it the sheet renders nothing at all, so '
        'a narrow viewport shows no panel and no rail, only whatever '
        'the main column holds. The trigger and the keyboard shortcut '
        'both route to whichever flag the current width says is live.',
  ),
  DocsApiFact(
    name: 'collapsible: none',
    type: 'ignores the breakpoint',
    description:
        'The none branch is chosen before the width is consulted, so '
        'a non-collapsing panel renders as a plain column at every '
        'width. That is why part specimens stay visible on a phone '
        'while a real shell does not.',
  ),
  DocsApiFact(
    name: 'collapsed tooltips',
    type: 'suppressed on mobile',
    description:
        'A row tooltip is hidden unless the panel is collapsed and '
        'the viewport is not mobile, so the sheet never shows one.',
  ),
  DocsApiFact(
    name: 'the account menu',
    type: 'drops below on mobile',
    description:
        'UserMenu opens its menu to the right on desktop and below '
        'on mobile, because there is no room beside.',
  ),
];

const List<DocsApiFact> _themingFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'LayoutWidths.sidebar',
    type: '256',
    description: 'The expanded panel and the offcanvas travel.',
  ),
  DocsApiFact(
    name: 'LayoutWidths.sidebarCollapsed',
    type: '48',
    description: 'The collapsed rail, and the hit-target floor.',
  ),
  DocsApiFact(
    name: 'LayoutWidths.sidebarMobile',
    type: '288',
    description: 'The sheet on a narrow viewport.',
  ),
  DocsApiFact(
    name: 'Breakpoints.md',
    type: '768',
    description: 'The one threshold the family reads.',
  ),
  DocsApiFact(
    name: 'MotionDurations.normal',
    type: '250ms',
    description:
        'The collapse, the group fold, the disclosure line and the '
        'rail all run on it.',
  ),
  DocsApiFact(
    name: 'Radii.lg',
    type: 'the row corner',
    description:
        'Rows are rounded rather than pilled: a 240px pill is a '
        'lozenge, and at that width the radius stops describing the '
        'object and starts fighting the stack. The sub-menu links and '
        'the pill use the same corner; menu actions use the medium '
        'one.',
  ),
];
