/// Public component documentation for the sidebar **family**.
///
/// `sidebar` is Wave 3 of the component-documentation plan and is the
/// largest composed component in the system: thirty-three public names in
/// `lib/src/components/sidebar.dart`, plus three more in
/// `lib/src/components/nav_user.dart`, which only ever appear inside a
/// sidebar footer and are therefore documented here rather than on a page of
/// their own.
///
/// The section list mirrors `ui.shadcn.com/docs/components/base/sidebar`
/// section for section: an unheaded live shell above Installation, then
/// Usage, Composition, Structure, and one section per named part
/// (SidebarProvider through SidebarRail) in the reference's own order,
/// Controlled Sidebar, this house's consolidated API Reference, and the six
/// sections every page in this wave carries. The reference's Styling and
/// RTL sub-sections and its Changelog are skipped: the first describes a
/// `data-*` attribute styling mechanism Flutter has no equivalent for, the
/// second documents automatic direction flipping this port does not attempt
/// (side is a plain enum the call site sets by hand), and the third is the
/// reference's own release history, not a fact about this package.
///
/// Three things this page does that its siblings do not:
///
///  * **It installs as one family.** `elattar add sidebar` installs the
///    sidebar manifest and its declared dependency closure.
///  * **Every number in the collapse contract is the package's own.** 256,
///    48, 64, 66, 0 and 250ms are what `test/sidebar_test.dart` pins against
///    the live reference, not estimates read off the class lists.
///  * **The accessibility section corrects a plausible assumption.** A
///    sibling worker documenting `tooltip` found that component wires no
///    `Semantics` at all, and flagged the collapsed sidebar rail as the
///    composition that would fail because of it. Read against the source,
///    that is only half true here, and the half that is true is narrower and
///    sharper than the guess: see the Accessibility section.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import '../catalog.dart';
import 'meta.dart';

class SidebarDocPage extends StatelessWidget {
  const SidebarDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = sidebarDoc;
    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: entry.title,
        description: entry.description,
      ),
      breadcrumbs: const <ElBreadcrumbEntry>[
        ElBreadcrumbEntry.link('Components'),
        ElBreadcrumbEntry.page('Sidebar'),
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
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Structure', anchor: 'structure'),
        DocsTocEntry(title: 'SidebarProvider', anchor: 'sidebar-provider'),
        DocsTocEntry(title: 'Sidebar', anchor: 'sidebar'),
        DocsTocEntry(title: 'useSidebar', anchor: 'use-sidebar'),
        DocsTocEntry(title: 'SidebarHeader', anchor: 'sidebar-header'),
        DocsTocEntry(title: 'SidebarFooter', anchor: 'sidebar-footer'),
        DocsTocEntry(title: 'SidebarContent', anchor: 'sidebar-content'),
        DocsTocEntry(title: 'SidebarGroup', anchor: 'sidebar-group'),
        DocsTocEntry(title: 'SidebarMenu', anchor: 'sidebar-menu'),
        DocsTocEntry(title: 'SidebarMenuButton', anchor: 'sidebar-menu-button'),
        DocsTocEntry(title: 'SidebarMenuAction', anchor: 'sidebar-menu-action'),
        DocsTocEntry(title: 'SidebarMenuSub', anchor: 'sidebar-menu-sub'),
        DocsTocEntry(title: 'SidebarMenuBadge', anchor: 'sidebar-menu-badge'),
        DocsTocEntry(
          title: 'SidebarMenuSkeleton',
          anchor: 'sidebar-menu-skeleton',
        ),
        DocsTocEntry(title: 'SidebarTrigger', anchor: 'sidebar-trigger'),
        DocsTocEntry(title: 'SidebarRail', anchor: 'sidebar-rail'),
        DocsTocEntry(title: 'Controlled Sidebar', anchor: 'controlled-sidebar'),
        DocsTocEntry(title: 'API Reference', anchor: 'api'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      previous: const DocsPageLink(title: 'Sheet', route: '/components/sheet'),
      next: const DocsPageLink(title: 'Tabs', route: '/components/tabs'),
      onNavigate: onNavigate,
      child: _SidebarArticle(entry: entry),
    );
  }
}

class _SidebarArticle extends StatelessWidget {
  const _SidebarArticle({required this.entry});

  final ComponentDocEntry entry;

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('sidebar-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsCodeExample(
        title: 'App shell: collapsible: icon',
        description:
            'Press the panel trigger, or Ctrl-B / Cmd-B with focus '
            'anywhere, because the shortcut is registered on the hardware '
            'keyboard rather than on a focus subtree. The panel travels '
            '256 to 48 and back over 250ms.',
        preview: _ShellSpecimen(),
      ),
      SizedBox(height: el(10)),
      ElSection(
        id: 'install',
        title: 'Installation',
        description:
            'Sidebar ships in the registry in this wave, so this page '
            'shows a manual copy rather than a CLI command that would fail.',
        child: _InstallSection(dependencies: entry.dependencies),
      ),
      const ElSection(
        id: 'usage',
        title: 'Usage',
        description:
            'The smallest correct shell: a provider owning state and the '
            'keyboard shortcut, wrapped around one collapsing panel and one '
            'main column.',
        child: _UsageSection(),
      ),
      const ElSection(
        id: 'composition',
        title: 'Composition',
        description:
            'Every region and menu part on one non-collapsing panel: the '
            'full tree, assembled once, so each part can be looked at on '
            'its own.',
        child: _CompositionSection(),
      ),
      const ElSection(
        id: 'structure',
        title: 'Structure',
        description:
            'Five moving pieces: a provider that owns state and the '
            'shortcut, a panel that reads it, a main column beside the '
            'panel, three scrolling regions inside it, and two controls '
            'that flip it open and shut.',
        child: _StructureSection(),
      ),
      const ElSection(
        id: 'sidebar-provider',
        title: 'SidebarProvider',
        description:
            'One flex row: the panel and the main column. It owns the '
            'open state, the mobile sheet state, and the Ctrl-B / Cmd-B '
            'shortcut, and it is where every width in the family is '
            'ultimately measured from.',
        child: _ProviderSection(),
      ),
      const ElSection(
        id: 'sidebar',
        title: 'Sidebar',
        description:
            'Which edge the panel sits on, which frame it wears, and what '
            'collapsing does to it: three enums, and the third collapse '
            'mode live.',
        child: _VariantsSection(),
      ),
      const ElSection(
        id: 'use-sidebar',
        title: 'useSidebar',
        description:
            'The reference publishes a hook; this port publishes an '
            'inherited scope with the same surface, read as '
            'ElSidebarScope.of(context) wherever a descendant needs it.',
        child: _UseSidebarSection(),
      ),
      const ElSection(
        id: 'sidebar-header',
        title: 'SidebarHeader',
        description:
            'A region above the scrolling content, most often holding a '
            'workspace switcher or a search field: see the live shell '
            'above for one in use.',
        child: _HeaderSection(),
      ),
      const ElSection(
        id: 'sidebar-footer',
        title: 'SidebarFooter',
        description:
            "The header's twin at the bottom of the panel, most often "
            'holding the signed-in account.',
        child: _FooterSection(),
      ),
      const ElSection(
        id: 'sidebar-content',
        title: 'SidebarContent',
        description:
            'The one scrolling region in the panel, and the flex child '
            'that pushes the footer to the floor.',
        child: _ContentSection(),
      ),
      const ElSection(
        id: 'sidebar-group',
        title: 'SidebarGroup',
        description:
            'A labelled section of the menu, optionally foldable, '
            'optionally carrying a corner action.',
        child: _GroupSection(),
      ),
      const ElSection(
        id: 'sidebar-menu',
        title: 'SidebarMenu',
        description:
            'The list itself: one travelling pill shared by every row in '
            'it, rather than each row painting its own selected fill.',
        child: _MenuSection(),
      ),
      const ElSection(
        id: 'sidebar-menu-button',
        title: 'SidebarMenuButton',
        description:
            'The row. isActive moves the pill to it; tooltip and label '
            'together decide what the row is called once it collapses.',
        child: _MenuButtonSection(),
      ),
      const ElSection(
        id: 'sidebar-menu-action',
        title: 'SidebarMenuAction',
        description:
            "A second control on a row, beside the item's own button: a "
            '24px ghost square pinned to the right edge.',
        child: _MenuActionSection(),
      ),
      const ElSection(
        id: 'sidebar-menu-sub',
        title: 'SidebarMenuSub',
        description:
            'A nested list hung off a border spine under a row, for the '
            'items one level down.',
        child: _MenuSubSection(),
      ),
      const ElSection(
        id: 'sidebar-menu-badge',
        title: 'SidebarMenuBadge',
        description:
            "A count in a row's right lane, drawn over the row rather "
            'than inside its hit area.',
        child: _MenuBadgeSection(),
      ),
      const ElSection(
        id: 'sidebar-menu-skeleton',
        title: 'SidebarMenuSkeleton',
        description:
            'A shimmer row a caller renders in place of a real one while '
            'its own data loads: see it live in Composition, two rows '
            'deep.',
        child: _MenuSkeletonSection(),
      ),
      const ElSection(
        id: 'sidebar-trigger',
        title: 'SidebarTrigger',
        description:
            'The button that toggles the panel, meant to live in the '
            'main column so it survives whatever the panel is doing.',
        child: _TriggerSection(),
      ),
      const ElSection(
        id: 'sidebar-rail',
        title: 'SidebarRail',
        description:
            'A thin strip straddling the panel edge: a pointer shortcut '
            'for the same toggle, never the only way to reach it.',
        child: _RailSection(),
      ),
      const ElSection(
        id: 'controlled-sidebar',
        title: 'Controlled Sidebar',
        description:
            'Pass open and onOpenChange to drive the panel from outside: '
            'the provider then never holds desktop state of its own.',
        child: _ControlledSection(),
      ),
      const ElSection(
        id: 'api',
        title: 'API Reference',
        description:
            'Every public class in lib/src/components/sidebar.dart and '
            'lib/src/components/nav_user.dart, with every constructor '
            'parameter and its default.',
        child: _ApiSection(),
      ),
      const ElSection(
        id: 'states',
        title: 'States',
        description:
            'Rows that do not apply to a family with no async step and no '
            'disabled parameter are marked N/A with the reason, rather than '
            'invented.',
        child: _StatesSection(),
      ),
      const ElSection(
        id: 'accessibility',
        title: 'Accessibility',
        child: _AccessibilitySection(),
      ),
      const ElSection(
        id: 'responsive',
        title: 'Responsive',
        description:
            'One media query decides everything: under 768 logical pixels '
            'the desktop panel is not built at all.',
        child: _ResponsiveSection(),
      ),
      ElSection(
        id: 'dependencies',
        title: 'Dependencies',
        description:
            "Elattar's own technical-transparency panel: what this family "
            'needs to install and run.',
        child: _DependenciesSection(dependencies: entry.dependencies),
      ),
      const ElSection(
        id: 'theming',
        title: 'Theming',
        child: _ThemingSection(),
      ),
      ElSection(
        id: 'source',
        title: 'Source',
        child: _SourceSection(sourcePath: entry.sourcePath),
      ),
    ],
  );
}

/* ── Installation ────────────────────────────────────────────────────────── */

class _InstallSection extends StatelessWidget {
  const _InstallSection({required this.dependencies});

  final List<String> dependencies;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElText(
          'Sidebar ships in the registry: registry/components/ holds '
          'twelve items and sidebar.json is not one of them. There is no '
          'CLI command to run, and this page will not print one that does '
          'not work. Copy the two source files below into '
          'lib/components/ui/ along with the thirteen component files they '
          'import, until a manifest ships.',
          ElType.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: el(4)),
        DocsCodeExample(
          title: 'Manual install',
          manualFiles: <DocsCodeFile>[
            const DocsCodeFile(
              path: 'lib/components/ui/sidebar.dart',
              title: 'sidebar.dart (public surface excerpt)',
              description:
                  'The real file is 2104 lines and holds thirty-three public '
                  'names. This is the shell half of the surface: the menu '
                  'parts are in the API Reference section below.',
              code: _installShellExcerpt,
            ),
            const DocsCodeFile(
              path: 'lib/components/ui/nav_user.dart',
              title: 'nav_user.dart (public surface excerpt)',
              description:
                  'The footer account block. It reads ElSidebarScope for '
                  'isMobile and composes ElSidebarMenu, so it only works '
                  'inside a provider.',
              code: _installNavUserExcerpt,
            ),
            DocsCodeFile(
              path: 'lib/components/ui/ (also copy)',
              title: 'Source-level dependencies',
              description:
                  'Not registry items: the component files the two '
                  'libraries above import directly.',
              code: dependencies.join('\n'),
            ),
          ],
        ),
      ],
    );
  }
}

/* ── Usage ───────────────────────────────────────────────────────────────── */

class _UsageSection extends StatelessWidget {
  const _UsageSection();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const ElPanel(
        label: 'DART',
        note: 'MINIMAL SHELL',
        child: DocsSelectableCodeBlock(code: _usageMinimalCode),
      ),
      SizedBox(height: el(5)),
      ElNote(
        title: 'The one rule the compiler cannot enforce',
        child: ElText(
          'ElSidebarProvider.variant and ElSidebar.variant must be given the '
          'same value. On the web reference one is computed from the other '
          'through :has() and peer- selectors, which ask a parent about its '
          'descendants and a box about its sibling. Flutter can do neither, '
          'so the fact travels down twice and the call site is responsible '
          'for keeping the two in agreement.',
          ElType.small,
        ),
      ),
    ],
  );
}

/* ── Composition ─────────────────────────────────────────────────────────── */

class _CompositionSection extends StatelessWidget {
  const _CompositionSection();

  @override
  Widget build(BuildContext context) => const DocsCodeExample(
    title: 'The part stage: collapsible: none, expand: true',
    description:
        'A field, a labelled group with a badge and an action, a '
        'separator, a disclosure group with a nested list, and two '
        'skeleton rows. Nothing here collapses, which is the point: each '
        'part can be looked at on its own.',
    preview: _PartsSpecimen(),
  );
}

/* ── Structure ───────────────────────────────────────────────────────────── */

class _StructureSection extends StatelessWidget {
  const _StructureSection();

  @override
  Widget build(BuildContext context) => const DocsApiTable(
    title: 'The shell, top to bottom',
    facts: <DocsApiFact>[
      DocsApiFact(
        name: 'ElSidebarProvider',
        type: 'the state',
        description:
            'Owns open, openMobile and the Ctrl-B / Cmd-B shortcut. Wraps '
            'one ElSidebar and one ElSidebarInset as its two flex children.',
      ),
      DocsApiFact(
        name: 'ElSidebar',
        type: 'the panel',
        description:
            'Reads the provider through ElSidebarScope and lays out its '
            'own regions: header, content, footer, and a rail on its edge.',
      ),
      DocsApiFact(
        name: 'ElSidebarInset',
        type: 'the main column',
        description:
            "Beside the panel, wrapped in an Expanded that is free to be "
            "narrower than its content: the port's spelling of min-w-0.",
      ),
      DocsApiFact(
        name: 'ElSidebarTrigger and ElSidebarRail',
        type: 'the controls',
        description:
            'Two ways to flip the panel: a button in the main column, and '
            "a thin strip on the panel's own edge.",
      ),
    ],
  );
}

/* ── SidebarProvider ─────────────────────────────────────────────────────── */

class _ProviderSection extends StatelessWidget {
  const _ProviderSection();

  @override
  Widget build(BuildContext context) => const DocsApiTable(
    title: 'The collapse contract: measured widths',
    facts: <DocsApiFact>[
      DocsApiFact(
        name: 'expanded (any mode)',
        type: 'gap 256 / panel 256',
        description:
            'ElWidths.sidebar. The gap is a real box in the row; the '
            'panel is an overflowing child of the gap, which is what a '
            'position: fixed container trapped by a transformed ancestor '
            'renders as.',
      ),
      DocsApiFact(
        name: 'icon, variant: sidebar',
        type: 'gap 48 / panel 48',
        description:
            'ElWidths.sidebarIcon. Both legs animate to the same 48, so '
            'the panel and the space it occupies stay identical.',
      ),
      DocsApiFact(
        name: 'icon, variant: floating or inset',
        type: 'gap 64 / panel 66',
        description:
            'ElSidebar.insetIconGap is 48 + el(4) = 64, because those '
            'two variants pay their own 8px frame on both edges; '
            'ElSidebar.insetIconWidth adds the two hairlines and is 66.',
      ),
      DocsApiFact(
        name: 'offcanvas',
        type: 'gap 0 / panel 256, slid -256',
        description:
            'The gap closes to nothing and the panel keeps its full '
            'width, travelling left by exactly its own width. Nothing '
            'unmounts: see Accessibility for what that costs.',
      ),
      DocsApiFact(
        name: 'none',
        type: 'always 256',
        description:
            'No gap, no container, no rail: a plain flex column that '
            'the trigger and the keyboard shortcut cannot move. Pass '
            'expand: true to let it fill its parent instead.',
      ),
      DocsApiFact(
        name: 'duration and curve',
        type: '250ms, linear',
        description:
            'ElDurations.transitionDefault on ElCurves.linear for all '
            'three legs: gap width, panel width, and the offcanvas '
            'slide. Measured as genuinely linear on the reference: even '
            'steps, no front-loading, no overshoot. Everything routes '
            'through elAnimationDuration, so reduced motion makes the '
            'whole collapse instant.',
      ),
      DocsApiFact(
        name: 'the row, mid-collapse',
        type: 'snaps, does not tween',
        description:
            'ElSidebarMenuButton.iconSize (32) lands whole on the first '
            'frame while the panel is still wide. The panel slides; its '
            'contents cut.',
      ),
    ],
  );
}

/* ── Sidebar ─────────────────────────────────────────────────────────────── */

class _VariantsSection extends StatelessWidget {
  const _VariantsSection();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(
        title: 'ElSidebarCollapsible',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'offcanvas',
            type: 'the default',
            description:
                'The panel slides off the edge and the gap closes to '
                'nothing. Nothing unmounts.',
          ),
          DocsApiFact(
            name: 'icon',
            type: 'ElSidebarCollapsible',
            description:
                'The panel narrows to the icon rail and keeps its glyphs. '
                'Labels, badges, actions and sub-menus go; rows and tooltips '
                'stay.',
          ),
          DocsApiFact(
            name: 'none',
            type: 'ElSidebarCollapsible',
            description:
                'It does not collapse. No gap, no container, no rail, and '
                'the trigger and keyboard shortcut still flip the provider '
                'flag: they just have nothing to move.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'ElSidebarVariant',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'sidebar',
            type: 'the default',
            description:
                'Flush against the edge, with a hairline border on the inset '
                'side. The only variant that pays a border out of its own '
                '256.',
          ),
          DocsApiFact(
            name: 'floating',
            type: 'ElSidebarVariant',
            description:
                'Inset by 8 on both edges, the panel itself a rounded card '
                'with a ring and a small shadow. No border, so it costs no '
                'layout.',
          ),
          DocsApiFact(
            name: 'inset',
            type: 'ElSidebarVariant',
            description:
                'Also inset by 8, but it is the main column that becomes the '
                'card: the provider paints the sidebar colour behind '
                'everything and the inset gains a rounded, shadowed panel of '
                'its own.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'ElSidebarSide',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'left',
            type: 'the default',
            description:
                'Border on the right, rail on the right edge, offcanvas '
                'travel to the left.',
          ),
          DocsApiFact(
            name: 'right',
            type: 'ElSidebarSide',
            description:
                'All four mirrored. The gap stays the first item in the row; '
                'it is the panel inside it that moves.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'Row ladders',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'ElSidebarMenuButtonSize.sm / md / lg',
            type: 'button xs / sm / lg',
            description:
                'md is the default and measures 37.5px; lg measures 50 with '
                'a 32px avatar in it, which is what the footer account row '
                'uses. Each maps onto the button ladder rather than '
                'inventing heights.',
          ),
          DocsApiFact(
            name: 'ElSidebarMenuSubButtonSize.sm / md',
            type: 'button xs / sm',
            description: 'md is the default: a 32px nested link.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const DocsCodeExample(
        title: 'collapsible: offcanvas',
        description:
            'The third mode, live. The gap goes to zero and the panel keeps '
            'its full 256 as it leaves.',
        preview: _OffcanvasSpecimen(),
      ),
    ],
  );
}

/* ── useSidebar ──────────────────────────────────────────────────────────── */

class _UseSidebarSection extends StatelessWidget {
  const _UseSidebarSection();

  @override
  Widget build(BuildContext context) => const DocsApiTable(
    title: 'ElSidebarScope, read with .of(context)',
    facts: <DocsApiFact>[
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
    ],
  );
}

/* ── SidebarHeader ───────────────────────────────────────────────────────── */

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) => const DocsApiTable(
    title: 'ElSidebarHeader',
    facts: <DocsApiFact>[
      DocsApiFact(
        name: 'children',
        type: 'List<Widget>',
        description:
            'Required. A column with el(2) between children, inside the '
            'region padding: el(3) expanded, el(2) in icon mode.',
      ),
      DocsApiFact(
        name: 'gap',
        type: 'static double (get)',
        description: 'el(2) = 8. Shared by the footer.',
      ),
    ],
  );
}

/* ── SidebarFooter ───────────────────────────────────────────────────────── */

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(
        title: 'ElSidebarFooter',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'children',
            type: 'List<Widget>',
            description:
                "Required. The header's twin. There is no mt-auto to port: "
                'the content region between them takes the slack. Most '
                'often holds a ElNavUser, the account block below.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const ElPanel(
        label: 'DART',
        note: 'FOOTER ACCOUNT BLOCK',
        child: DocsSelectableCodeBlock(code: _usageNavUserCode),
      ),
    ],
  );
}

/* ── SidebarContent ──────────────────────────────────────────────────────── */

class _ContentSection extends StatelessWidget {
  const _ContentSection();

  @override
  Widget build(BuildContext context) => const DocsApiTable(
    title: 'ElSidebarContent and ElSidebarSeparator',
    facts: <DocsApiFact>[
      DocsApiFact(
        name: 'ElSidebarContent.children',
        type: 'List<Widget>',
        description:
            'Default const []. The one scrolling region in the panel, and '
            'the flex child that puts the footer on the floor. In icon '
            'mode it stops scrolling and clips instead.',
      ),
      DocsApiFact(
        name: 'ElSidebarSeparator()',
        type: 'const, key only',
        description:
            'A hairline in the sidebar border colour, inset el(3), el(2) '
            'in icon mode.',
      ),
    ],
  );
}

/* ── SidebarGroup ────────────────────────────────────────────────────────── */

class _GroupSection extends StatelessWidget {
  const _GroupSection();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(
        title: 'ElSidebarGroup, ElSidebarGroupLabel, ElSidebarGroupAction',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'ElSidebarGroup.children',
            type: 'List<Widget>',
            description: 'Required. A padded column, same region padding.',
          ),
          DocsApiFact(
            name: 'ElSidebarGroupLabel(label)',
            type: 'String, positional',
            description:
                'Required. 32px tall, typed ElType.navSm at full strength: '
                'dimming it to 70% would measure 2.76:1 against the 4.5:1 '
                'it owes.',
          ),
          DocsApiFact(
            name: 'ElSidebarGroupAction',
            type: 'child, label, onPressed?',
            description:
                'child and label required. A 24px ghost square for the '
                "group's top-right corner, positioned by "
                'ElSidebarCollapsibleGroup: nothing else holds one.',
          ),
          DocsApiFact(
            name: 'ElSidebarCollapsibleGroup',
            type: 'label, toggleLabel, child',
            description:
                'label, toggleLabel and child required. The trigger is the '
                'disclosure line, not the title and not the action, so the '
                'two visible controls stay honest.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const ElPanel(
        label: 'DART',
        note: 'DISCLOSURE GROUP',
        child: DocsSelectableCodeBlock(code: _usageGroupCode),
      ),
    ],
  );
}

/* ── SidebarMenu ─────────────────────────────────────────────────────────── */

class _MenuSection extends StatelessWidget {
  const _MenuSection();

  @override
  Widget build(BuildContext context) => const DocsApiTable(
    title: 'ElSidebarMenu and ElSidebarMenuItem',
    facts: <DocsApiFact>[
      DocsApiFact(
        name: 'ElSidebarMenu.children',
        type: 'List<Widget>',
        description:
            'Required. The menu owns one travelling pill; the rows never '
            'paint their own selected fill. The pill is keyed on isActive '
            'rather than on disclosure state, so a row that is also a '
            'collapsible trigger does not drag the pill around when it '
            'opens.',
      ),
      DocsApiFact(
        name: 'ElSidebarMenu.gap',
        type: 'static double (get)',
        description: 'el(1) = 4, between rows.',
      ),
      DocsApiFact(
        name: 'ElSidebarMenuItem.button / action / badge / submenu',
        type: 'Widget, Widget?, Widget?, Widget?',
        description:
            'button required. The other three are optional row furniture: '
            'action and badge sit in the right lane, hidden in icon mode; '
            'submenu hangs a nested list under the row.',
      ),
    ],
  );
}

/* ── SidebarMenuButton ───────────────────────────────────────────────────── */

class _MenuButtonSection extends StatelessWidget {
  const _MenuButtonSection();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(
        title: 'ElSidebarMenuButton',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'isActive',
            type: 'bool',
            description:
                'Default false. Where the menu puts its pill. The row '
                'itself changes only its ink, so nothing reflows when '
                'selection moves.',
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
            type: 'ElButtonVariant, ElSidebarMenuButtonSize',
            description:
                'Default ghost and md (37.5px tall). ghost rather than the '
                'button default, because a column of rows each painting '
                'bg-primary would be a wall of blue with no hierarchy left '
                'to spend.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const ElPanel(
        label: 'DART',
        note: 'A COLLAPSING ROW',
        child: DocsSelectableCodeBlock(code: _usageRowCode),
      ),
    ],
  );
}

/* ── SidebarMenuAction ───────────────────────────────────────────────────── */

class _MenuActionSection extends StatelessWidget {
  const _MenuActionSection();

  @override
  Widget build(BuildContext context) => const DocsApiTable(
    title: 'ElSidebarMenuAction',
    facts: <DocsApiFact>[
      DocsApiFact(
        name: 'child / label / onPressed',
        type: 'Widget, String, VoidCallback?',
        description:
            'child and label required. A 24px ghost square centred in its '
            'row. label is its only accessible name. Hidden in icon mode.',
      ),
    ],
  );
}

/* ── SidebarMenuSub ──────────────────────────────────────────────────────── */

class _MenuSubSection extends StatelessWidget {
  const _MenuSubSection();

  @override
  Widget build(BuildContext context) => const DocsApiTable(
    title: 'ElSidebarMenuSub, ElSidebarMenuSubItem, ElSidebarMenuSubButton',
    facts: <DocsApiFact>[
      DocsApiFact(
        name: 'ElSidebarMenuSub.children',
        type: 'List<Widget>',
        description:
            'Required. The nested list, hung off a border spine. Renders '
            'nothing at all in icon mode.',
      ),
      DocsApiFact(
        name: 'ElSidebarMenuSubButton.label',
        type: 'String',
        description:
            'Required, and a String rather than a Widget: this part is '
            'always a link upstream, so it takes text.',
      ),
      DocsApiFact(
        name: 'ElSidebarMenuSubButton.isActive',
        type: 'bool',
        description:
            'Default false. A colour and nothing else: a sub-button never '
            'claims the pill, even when it is the only active thing on '
            'screen.',
      ),
    ],
  );
}

/* ── SidebarMenuBadge ────────────────────────────────────────────────────── */

class _MenuBadgeSection extends StatelessWidget {
  const _MenuBadgeSection();

  @override
  Widget build(BuildContext context) => const DocsApiTable(
    title: 'ElSidebarMenuBadge',
    facts: <DocsApiFact>[
      DocsApiFact(
        name: 'ElSidebarMenuBadge(count)',
        type: 'String, positional',
        description:
            'Required. The count in the right lane, pointer-events-none '
            'so a click on it reaches the row underneath. Hidden in icon '
            'mode.',
      ),
      DocsApiFact(
        name: 'variant',
        type: 'ElBadgeVariant',
        description:
            "Default ElBadgeVariant.secondary: the sidebar's own default, "
            "not the badge's.",
      ),
    ],
  );
}

/* ── SidebarMenuSkeleton ─────────────────────────────────────────────────── */

class _MenuSkeletonSection extends StatelessWidget {
  const _MenuSkeletonSection();

  @override
  Widget build(BuildContext context) => const DocsApiTable(
    title: 'ElSidebarMenuSkeleton',
    facts: <DocsApiFact>[
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
        description: 'el(8) = 32, the same as a collapsed row.',
      ),
    ],
  );
}

/* ── SidebarTrigger ──────────────────────────────────────────────────────── */

class _TriggerSection extends StatelessWidget {
  const _TriggerSection();

  @override
  Widget build(BuildContext context) => const DocsApiTable(
    title: 'ElSidebarTrigger',
    facts: <DocsApiFact>[
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
            'Both ElSidebarTrigger and ElSidebarRail publish "Toggle '
            'Sidebar" as their name.',
      ),
    ],
  );
}

/* ── SidebarRail ─────────────────────────────────────────────────────────── */

class _RailSection extends StatelessWidget {
  const _RailSection();

  @override
  Widget build(BuildContext context) => const DocsApiTable(
    title: 'ElSidebarRail',
    facts: <DocsApiFact>[
      DocsApiFact(
        name: 'ElSidebarRail()',
        type: 'const, key only',
        description:
            'A marker. It renders SizedBox.shrink in the flow; ElSidebar '
            'sees it in children and paints the strip in the slot it '
            'computed, because only the panel knows where its edge is.',
      ),
      DocsApiFact(
        name: 'hairline',
        type: 'static double (get)',
        description:
            'el(0.5) = 2. The hover rule down the middle of the strip. The '
            'rail takes no focus, reproducing the reference tabIndex of '
            '-1: it is a pointer shortcut, and ElSidebarTrigger is always '
            'the reachable alternative.',
      ),
    ],
  );
}

/* ── Controlled Sidebar ──────────────────────────────────────────────────── */

class _ControlledSection extends StatelessWidget {
  const _ControlledSection();

  @override
  Widget build(BuildContext context) => const ElPanel(
    label: 'DART',
    note: 'CONTROLLED',
    child: DocsSelectableCodeBlock(code: _usageControlledCode),
  );
}

/* ── API Reference ───────────────────────────────────────────────────────── */

class _ApiSection extends StatelessWidget {
  const _ApiSection();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(
        title: 'ElSidebarProvider',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'children',
            type: 'List<Widget>',
            description:
                "Required. The wrapper row's flex children: normally one "
                'ElSidebar and one ElSidebarInset.',
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
                'from outside; the provider then never holds desktop state '
                'of its own.',
          ),
          DocsApiFact(
            name: 'onOpenChange',
            type: 'ValueChanged<bool>?',
            description:
                'Default null. When non-null it fully replaces the internal '
                'setState, so a controlled provider that ignores this '
                'callback will simply never open or close.',
          ),
          DocsApiFact(
            name: 'variant',
            type: 'ElSidebarVariant',
            description:
                'Default ElSidebarVariant.sidebar. Must match the variant '
                'given to ElSidebar. Only inset changes what the provider '
                'itself paints: it fills the whole row with the sidebar '
                'colour.',
          ),
          DocsApiFact(
            name: 'minHeight',
            type: 'double?',
            description:
                'Default null. min-h-svh. Null because every specimen '
                'cancels it; a real application shell passes the viewport '
                'height.',
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
                'width < ElBreakpoints.md, i.e. under 768. The port of '
                'useIsMobile().',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'ElSidebar',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'children',
            type: 'List<Widget>',
            description:
                "Required. The panel's regions, top to bottom. A "
                'ElSidebarRail among them is what puts a rail on the edge; '
                'the widget itself contributes nothing to the column.',
          ),
          DocsApiFact(
            name: 'side',
            type: 'ElSidebarSide',
            description: 'Default ElSidebarSide.left.',
          ),
          DocsApiFact(
            name: 'variant',
            type: 'ElSidebarVariant',
            description:
                'Default ElSidebarVariant.sidebar. Must match '
                'ElSidebarProvider.variant.',
          ),
          DocsApiFact(
            name: 'collapsible',
            type: 'ElSidebarCollapsible',
            description:
                'Default ElSidebarCollapsible.offcanvas: note that this is '
                'not the icon rail most shells want.',
          ),
          DocsApiFact(
            name: 'expand',
            type: 'bool',
            description:
                'Default false. collapsible: none only: drops the fixed 256 '
                'so the panel fills its parent. A stage override upstream, a '
                'real parameter here.',
          ),
          DocsApiFact(
            name: 'insetIconGap',
            type: 'static double (get)',
            description:
                '64, ElWidths.sidebarIcon + el(4). The collapsed gap under '
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
            description: 'el(2) = 8. The p-2 floating and inset pay.',
          ),
          DocsApiFact(
            name: 'railWidth',
            type: 'static double (get)',
            description: 'el(4) = 16. The strip straddling the panel edge.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'ElSidebarRail, ElSidebarTrigger, ElSidebarInset',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'ElSidebarRail()',
            type: 'const, key only',
            description:
                'A marker. It renders SizedBox.shrink in the flow; ElSidebar '
                'sees it in children and paints the strip in the slot it '
                'computed, because only the panel knows where its edge is.',
          ),
          DocsApiFact(
            name: 'ElSidebarRail.hairline',
            type: 'static double (get)',
            description:
                'el(0.5) = 2. The hover rule down the middle of the strip.',
          ),
          DocsApiFact(
            name: 'ElSidebarTrigger.onPressed',
            type: 'VoidCallback?',
            description:
                'Default null. Called before the toggle, in that order. The '
                'trigger toggles regardless.',
          ),
          DocsApiFact(
            name: 'ElSidebarInset.child',
            type: 'Widget',
            description:
                'Required. The main column beside the panel, wrapped in an '
                'Expanded that is free to be narrower than its content: the '
                "port's spelling of min-w-0.",
          ),
          DocsApiFact(
            name: 'ElSidebarInset.margin',
            type: 'static double (get)',
            description:
                'el(2) = 8. The inset variant only: 8px on three sides while '
                'open, all four once collapsed.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'Regions',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'ElSidebarHeader.children',
            type: 'List<Widget>',
            description:
                'Required. A column with el(2) between children, inside the '
                'region padding: el(3) expanded, el(2) in icon mode.',
          ),
          DocsApiFact(
            name: 'ElSidebarHeader.gap',
            type: 'static double (get)',
            description: 'el(2) = 8. Shared by the footer.',
          ),
          DocsApiFact(
            name: 'ElSidebarFooter.children',
            type: 'List<Widget>',
            description:
                "Required. The header's twin. There is no mt-auto to port: "
                'the content region between them takes the slack.',
          ),
          DocsApiFact(
            name: 'ElSidebarContent.children',
            type: 'List<Widget>',
            description:
                'Default const []. The one scrolling region in the panel, '
                'and the flex child that puts the footer on the floor. In '
                'icon mode it stops scrolling and clips instead.',
          ),
          DocsApiFact(
            name: 'ElSidebarSeparator()',
            type: 'const, key only',
            description:
                'A hairline in the sidebar border colour, inset el(3), '
                'el(2) in icon mode. Painted here rather than composed from '
                'the separator primitive, because both the colour and the '
                'inset are overridden.',
          ),
          DocsApiFact(
            name: 'ElSidebarGroup.children',
            type: 'List<Widget>',
            description: 'Required. A padded column, same region padding.',
          ),
          DocsApiFact(
            name: 'ElSidebarGroupContent.child',
            type: 'Widget',
            description:
                'Required. Renders its child verbatim: it has no type of '
                'its own and exists so a call site reads like the reference.',
          ),
          DocsApiFact(
            name: 'ElSidebarGroupLabel(label)',
            type: 'String, positional',
            description:
                'Required. 32px tall, typed ElType.navSm at full strength: '
                'dimming it to 70% would measure 2.76:1 against the 4.5:1 it '
                'owes.',
          ),
          DocsApiFact(
            name: 'ElSidebarGroupLabel.padding',
            type: 'EdgeInsetsGeometry?',
            description:
                'Default null, which resolves to left el(3) / right el(10). '
                'ElSidebarCollapsibleGroup passes EdgeInsets.zero, so on a '
                'real page the declared padding never renders.',
          ),
          DocsApiFact(
            name: 'ElSidebarGroupLabel.height',
            type: 'static double (get)',
            description:
                'el(8) = 32. In icon mode the box animates to zero height '
                'and zero opacity, so the collapsed group loses the whole '
                'row.',
          ),
          DocsApiFact(
            name: 'ElSidebarGroupAction',
            type: 'child, label, onPressed?',
            description:
                'child and label required. A 24px ghost square for the '
                "group's top-right corner, positioned by "
                'ElSidebarCollapsibleGroup: nothing else holds one. label '
                'is its only accessible name.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'ElSidebarCollapsibleGroup',
        facts: <DocsApiFact>[
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
                'the two visible controls stay honest: the action performs '
                'its verb, the divider only changes disclosure.',
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
                'Default null. A ElSidebarGroupAction, anchored in the '
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
            description: 'el(6) = 24.',
          ),
          DocsApiFact(
            name: 'lineOpen / lineClosed',
            type: 'static double (get)',
            description:
                '1 and el(1) = 4. The disclosure line thickens from a '
                'hairline to 4px while closed, over 250ms.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'ElSidebarMenu',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'children',
            type: 'List<Widget>',
            description:
                'Required. The menu owns one travelling pill; the rows never '
                'paint their own selected fill. The pill is keyed on '
                "isActive rather than on disclosure state, so a row that is "
                'also a collapsible trigger does not drag the pill around '
                'when it opens.',
          ),
          DocsApiFact(
            name: 'gap',
            type: 'static double (get)',
            description: 'el(1) = 4, between rows.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'ElSidebarMenuItem',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'button',
            type: 'Widget',
            description:
                'Required. The row: a ElSidebarMenuButton, or a dropdown '
                'trigger wrapping one.',
          ),
          DocsApiFact(
            name: 'action',
            type: 'Widget?',
            description:
                'Default null. A ElSidebarMenuAction, centred on the row and '
                'pinned el(1) from its right edge. Hidden in icon mode.',
          ),
          DocsApiFact(
            name: 'badge',
            type: 'Widget?',
            description:
                'Default null. A ElSidebarMenuBadge, pinned el(2) from the '
                'right edge. Hidden in icon mode.',
          ),
          DocsApiFact(
            name: 'submenu',
            type: 'Widget?',
            description:
                'Default null. A ElSidebarMenuSub, in flow under the row, '
                'which makes the item taller than its own button. This is '
                'the one relational question Flutter can answer, because the '
                'item is handed its children as a list.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'ElSidebarMenuButton',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'child',
            type: 'Widget',
            description: 'Required. Normally a ElSidebarMenuRow.',
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
            type: 'ElButtonVariant',
            description:
                'Default ElButtonVariant.ghost: not the button default. A '
                'column of rows each painting bg-primary would be a wall of '
                'blue with no hierarchy left to spend.',
          ),
          DocsApiFact(
            name: 'size',
            type: 'ElSidebarMenuButtonSize',
            description:
                'Default ElSidebarMenuButtonSize.md, which is 37.5px tall at '
                'h-auto with el(2) padding.',
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
                'Default null, and null becomes an empty callback rather '
                'than a disabled row: this family has no disabled state.',
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
                'el(2) = 8, el(10) = 40, el(16) = 64. The right padding a '
                'row reserves when its item carries an action or a badge.',
          ),
          DocsApiFact(
            name: 'iconSize',
            type: 'static double (get)',
            description:
                'el(8) = 32. The collapsed row is a hard square and gets '
                'there in one frame.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'Row content: ElSidebarMenuRow, ElSidebarMenuLabel',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'ElSidebarMenuRow.label',
            type: 'Widget',
            description: 'Required. The label span, expanded to fill the line.',
          ),
          DocsApiFact(
            name: 'ElSidebarMenuRow.leading',
            type: 'Widget?',
            description:
                'Default null. The glyph, already sized by the caller from '
                "ElButton.iconPxFor. In icon mode the row renders this and "
                'nothing else: and if it is null, the text label survives '
                'the collapse instead, clipped to 32px.',
          ),
          DocsApiFact(
            name: 'ElSidebarMenuRow.trailing',
            type: 'Widget?',
            description: 'Default null. Anything after the label.',
          ),
          DocsApiFact(
            name: 'ElSidebarMenuRow.size',
            type: 'ElSidebarMenuButtonSize',
            description:
                'Default md. Only picks the gap between glyph and label; '
                'pass the same value the button has.',
          ),
          DocsApiFact(
            name: 'ElSidebarMenuLabel(text)',
            type: 'String, positional',
            description:
                'Required. One truncating line, laid out in a CSS line box '
                'so a 13px label measures 19.5 rather than the 20 the engine '
                'would round to. Its style is read from the ambient default '
                'rather than passed, because the row ladder has already '
                'resolved it.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'ElSidebarMenuAction and ElSidebarMenuBadge',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'ElSidebarMenuAction.child / label / onPressed',
            type: 'Widget, String, VoidCallback?',
            description:
                'child and label required. A 24px ghost square for the '
                "row's right lane. label is its only accessible name.",
          ),
          DocsApiFact(
            name: 'ElSidebarMenuBadge(count)',
            type: 'String, positional',
            description:
                'Required. The count in the right lane, pointer-events-none '
                'so a click on it reaches the row underneath.',
          ),
          DocsApiFact(
            name: 'ElSidebarMenuBadge.variant',
            type: 'ElBadgeVariant',
            description:
                "Default ElBadgeVariant.secondary: the sidebar's own "
                "default, not the badge's.",
          ),
          DocsApiFact(
            name: 'ElSidebarMenuBadge.paddingX / minWidth',
            type: 'static double (get)',
            description: 'el(1.5) = 6 and el(5) = 20.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'ElSidebarMenuSkeleton',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'showIcon',
            type: 'bool',
            description:
                'Default false. Adds a 16px shimmer tile before the bar.',
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
            description: 'el(8) = 32, the same as a collapsed row.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'Sub-menu and field',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'ElSidebarMenuSub.children',
            type: 'List<Widget>',
            description:
                'Required. The nested list, hung off a border spine. Renders '
                'nothing at all in icon mode.',
          ),
          DocsApiFact(
            name: 'ElSidebarMenuSubItem.child',
            type: 'Widget',
            description: 'Required. Renders its child verbatim.',
          ),
          DocsApiFact(
            name: 'ElSidebarMenuSubButton.label',
            type: 'String',
            description:
                'Required, and a String rather than a Widget: this part is '
                'always a link upstream, so it takes text.',
          ),
          DocsApiFact(
            name: 'ElSidebarMenuSubButton.isActive',
            type: 'bool',
            description:
                'Default false. A colour and nothing else: a sub-button '
                'never claims the pill, even when it is the only active '
                'thing on screen.',
          ),
          DocsApiFact(
            name: 'ElSidebarMenuSubButton.variant / size / onPressed',
            type: 'ElButtonVariant, ElSidebarMenuSubButtonSize, VoidCallback?',
            description: 'Defaults ghost, md, and null.',
          ),
          DocsApiFact(
            name: 'ElSidebarInput.placeholder / label / controller / padding',
            type:
                'String?, String?, TextEditingController?, EdgeInsetsGeometry?',
            description:
                'All default null. A 32px flat field filled with the '
                'background colour rather than the input colour, so it reads '
                'as a well cut into the panel. label is its accessible name.',
          ),
          DocsApiFact(
            name: 'ElSidebarInput.height',
            type: 'static double (get)',
            description: 'el(8) = 32.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'Scopes: ElSidebarScope and ElSidebarChrome',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'ElSidebarScope.open / collapsed',
            type: 'bool / bool (get)',
            description:
                "The desktop panel's flag, and its negation. This is the "
                'whole of what the reference publishes as useSidebar().',
          ),
          DocsApiFact(
            name: 'ElSidebarScope.openMobile',
            type: 'bool',
            description:
                "The mobile sheet's own flag: a separate boolean, as it is "
                'upstream. Collapsing on desktop does not open the sheet, and '
                'closing the sheet does not collapse the panel.',
          ),
          DocsApiFact(
            name: 'ElSidebarScope.isMobile',
            type: 'bool',
            description: 'The viewport is under 768.',
          ),
          DocsApiFact(
            name: 'ElSidebarScope.setOpen / setOpenMobile / toggleSidebar',
            type: 'ValueChanged<bool>, ValueChanged<bool>, VoidCallback',
            description:
                'toggleSidebar routes to whichever of the two flags the '
                'current width says is live.',
          ),
          DocsApiFact(
            name: 'ElSidebarScope.of / maybeOf',
            type: 'static',
            description:
                'of asserts inside a provider, as useSidebar() throws; '
                'maybeOf is the non-throwing read the port uses where the '
                'reference would have had no consumer.',
          ),
          DocsApiFact(
            name: 'ElSidebarChrome.side / variant / collapsible',
            type: 'ElSidebarSide, ElSidebarVariant, ElSidebarCollapsible?',
            description:
                'What the panel publishes to the regions inside it. '
                'collapsible is the collapse mode while collapsed and null '
                'while expanded, which is the reference conditional exactly.',
          ),
          DocsApiFact(
            name: 'ElSidebarChrome.iconMode / iconModeOf',
            type: 'bool (get) / static bool Function(BuildContext)',
            description:
                'The one predicate fifteen layout rules read. False outside '
                'a panel, which is what an element carrying no collapse '
                'attribute resolves to.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'ElNavUser (nav_user.dart)',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'ElNavUser.user',
            type: 'ElNavUserAccount',
            description:
                'Required. Composes one lg row holding an avatar, a two-line '
                'identity block and a chevron, opening a menu that repeats '
                'the identity at its head.',
          ),
          DocsApiFact(
            name: 'ElNavUser.items',
            type: 'List<ElNavUserItem>',
            description:
                'Required, with no default on purpose: a default list would '
                'put invented product actions into a chassis meant to travel '
                'into the next project.',
          ),
          DocsApiFact(
            name: 'ElNavUser.menuMinWidth',
            type: 'static double (get)',
            description: 'el(56) = 224, the floor under the trigger width.',
          ),
          DocsApiFact(
            name: 'ElNavUserAccount.name / email / avatar',
            type: 'String, String, ImageProvider?',
            description:
                'name and email required. initials is derived: the first '
                'letter of each of the first two words, uppercased.',
          ),
          DocsApiFact(
            name: 'ElNavUserItem.label / icon / onSelect / destructive',
            type: 'String, ElLucideGlyph?, VoidCallback?, bool',
            description:
                'label required; destructive defaults false. Destructive '
                'items are gathered below a separator and rendered in the '
                'destructive tone, regardless of where they sit in the list.',
          ),
        ],
      ),
    ],
  );
}

/* ── States ──────────────────────────────────────────────────────────────── */

class _StatesSection extends StatelessWidget {
  const _StatesSection();

  @override
  Widget build(BuildContext context) => const DocsStateMatrix(
    facts: <DocsStateFact>[
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
            'isActive moves the menu pill: 250ms of spring travel, a 150ms '
            'fade, and a 600ms jelly squash on arrival. The row itself '
            'changes only its ink to the sidebar accent colour: no weight '
            'change, so nothing reflows. When two rows claim it, the '
            'topmost wins, and a sub-button never claims it at all.',
        userSignal:
            'One filled, shadowed pill travels to the newly active row.',
      ),
      DocsStateFact(
        state: 'Loading',
        treatment:
            'N/A: nothing in the family is asynchronous. '
            'ElSidebarMenuSkeleton is a shimmer row a caller renders '
            'instead of real rows while its own data loads; the menu has no '
            'loading state of its own to enter.',
        userSignal: 'N/A',
      ),
      DocsStateFact(
        state: 'Empty',
        treatment:
            'Partly applicable. ElSidebarContent.children defaults to an '
            'empty list and renders an empty scrolling column: there is no '
            'empty-state affordance, and none is invented here. A panel '
            'with nothing in it is a blank panel.',
        userSignal: 'Nothing. The caller supplies any empty copy.',
      ),
      DocsStateFact(
        state: 'Error',
        treatment:
            'N/A: no validation anywhere. ElSidebarInput delegates to the '
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
            'the family. ElSidebarMenuButton and ElSidebarMenuSubButton '
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
            'elAnimationDuration: the three collapse legs, the group label '
            'fold, the disclosure line, the rail hover, the pill travel and '
            'its fade, and the jelly squash. Under reduced motion the '
            'collapse is instant and the pill teleports.',
        userSignal: 'The same end states, reached without travel.',
      ),
    ],
  );
}

/* ── Accessibility ───────────────────────────────────────────────────────── */

class _AccessibilitySection extends StatelessWidget {
  const _AccessibilitySection();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const ElPanel(
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
                  'headings, ElSidebarGroupLabel is plain text, so group '
                  'structure is visual only and a screen reader hears one '
                  'flat run of buttons.',
            ),
            _A11yRow(
              'Required labels',
              'ElSidebarMenuButton resolves its accessible name as '
                  'label ?? tooltip and hands it to the underlying button, '
                  'which publishes it as a real name. ElSidebarTrigger and '
                  'ElSidebarRail both hard-code "Toggle Sidebar". '
                  'ElSidebarGroupAction and ElSidebarMenuAction each take a '
                  'required label, which is their only name. ElSidebarInput '
                  'takes an optional label and has no other name if it is '
                  'omitted.',
            ),
            _A11yRow(
              'Keyboard interactions',
              'Ctrl-B or Cmd-B toggles the panel from anywhere, including '
                  'from nowhere: the handler is registered on '
                  'HardwareKeyboard rather than on a focus subtree, which is '
                  'the port of a document-level listener. A page carrying '
                  'several providers installs several handlers and the '
                  'shortcut toggles all of them; that is what the reference '
                  'does too. Everything else is ordinary button activation.',
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
      SizedBox(height: el(5)),
      ElNote(
        title: 'Correcting a plausible assumption about the collapsed rail',
        child: ElText(
          'The tooltip component wires no Semantics at all, which makes '
          '"an icon-only row whose only label is a tooltip" the obvious '
          'accessibility failure to expect here. Read against the source, '
          'that is not what happens: ElSidebarMenuButton passes '
          'label ?? tooltip down as the button accessible name, so a row '
          'given a tooltip is properly named in the semantics tree whether '
          'or not the tooltip overlay is ever shown, and whether or not the '
          'panel is collapsed. The tooltip string is doing double duty as '
          'an accessible name, which is exactly the wiring the tooltip '
          'component itself lacks.',
          ElType.small,
        ),
      ),
      SizedBox(height: el(5)),
      ElNote(
        tone: ElNoteTone.error,
        title: 'Known gap: a collapsed row with neither label nor tooltip',
        child: ElText(
          'The gap is narrower than the guess, and real. Both label and '
          'tooltip default to null, and nothing requires either. Expanded, '
          'such a row is still named, because its visible text supplies the '
          'name. Collapsed, ElSidebarMenuRow drops the text and renders the '
          'glyph alone, and a glyph carries no text: so the row becomes an '
          'unnamed button, announced as "button" and nothing more, at '
          'exactly the moment its label disappeared from the screen. Always '
          'give every ElSidebarMenuButton a tooltip, or an explicit label '
          'if the tooltip copy is wrong as a name. The same applies to '
          'ElSidebarInput, whose label is optional and which has no other '
          'accessible name. Separately, the rail publishes a named button '
          'node but takes no focus at all, reproducing the reference '
          'tabIndex of -1: it is a 16px control that a keyboard cannot '
          'reach. That is deliberate rather than accidental: '
          'ElSidebarTrigger does the same job and is reachable, so the rail '
          'is a pointer shortcut and never the only way to collapse.',
          ElType.small,
        ),
      ),
    ],
  );
}

/* ── Responsive ──────────────────────────────────────────────────────────── */

class _ResponsiveSection extends StatelessWidget {
  const _ResponsiveSection();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(
        title: 'The breakpoint, and what it switches',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'the threshold',
            type: 'width < 768',
            description:
                'ElSidebarProvider.isMobileWidth compares the media query '
                'width against ElBreakpoints.md. 767 is mobile, 768 is not. '
                'This is the port of a max-width media query, read from '
                'MediaQuery rather than from the platform, so a resized '
                'desktop window crosses it exactly as a phone does.',
          ),
          DocsApiFact(
            name: 'below 768',
            type: 'a sheet, 288 wide',
            description:
                'The gap-and-container pair is not built at all. The panel '
                'becomes a sheet on the same side at '
                'ElWidths.sidebarMobile (288: deliberately wider than the '
                '256 desktop panel, because a sheet has no main column '
                'beside it competing for the eye), with its close button '
                'hidden and a container label of "Sidebar".',
          ),
          DocsApiFact(
            name: 'the second flag',
            type: 'openMobile',
            description:
                'The sheet is driven by its own boolean, separate from '
                'open. Until something sets it the sheet renders nothing at '
                'all, so a narrow viewport shows no panel and no rail, '
                'only whatever the main column holds. The trigger and the '
                'keyboard shortcut both route to whichever flag the current '
                'width says is live.',
          ),
          DocsApiFact(
            name: 'collapsible: none',
            type: 'ignores the breakpoint',
            description:
                'The none branch is chosen before the width is consulted, '
                'so a non-collapsing panel renders as a plain column at '
                'every width. That is why part specimens stay visible on a '
                'phone while a real shell does not.',
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
                'ElNavUser opens its menu to the right on desktop and below '
                'on mobile, because there is no room beside.',
          ),
        ],
      ),
      SizedBox(height: el(5)),
      ElNote(
        title: 'Two known divergences worth planning around',
        child: ElText(
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
          ElType.small,
        ),
      ),
    ],
  );
}

/* ── Dependencies ────────────────────────────────────────────────────────── */

class _DependenciesSection extends StatelessWidget {
  const _DependenciesSection({required this.dependencies});

  final List<String> dependencies;

  @override
  Widget build(BuildContext context) => DocsInstallFacts(
    facts: <DocsInstallFact>[
      const DocsInstallFact(
        label: 'Status',
        value: 'Stable and installable through `elattar add sidebar`',
        description:
            'All thirty-six public names are exported from the public '
            'barrel and covered by test/sidebar_test.dart, but there is no '
            'registry manifest, so the CLI cannot install it yet.',
      ),
      const DocsInstallFact(
        label: 'Version',
        value: '0.0.1',
        description:
            "The package's own version: the manifest now ships "
            'version to quote.',
      ),
      const DocsInstallFact(
        label: 'Dart / Flutter',
        value: '>=3.12.2 <4.0.0 / >=3.44.8',
        description: "The package's own constraints.",
      ),
      const DocsInstallFact(
        label: 'Family size',
        value: '33 exports in sidebar.dart, 3 in nav_user.dart',
        description:
            'Provider, two inherited scopes, the panel, rail, trigger, '
            'inset, six regions, four group parts, twelve menu parts, one '
            'field, and the footer account block.',
      ),
      const DocsInstallFact(
        label: 'Registry item',
        value:
            'badge, button, collapsible, icon, icon-swap, input, keyframes, machine-surface, sheet, skeleton, source-foundation, tooltip',
        description:
            'registry/components/sidebar.json has not been written, so the '
            'CLI cannot resolve this component and no install command is '
            'printed anywhere on this page.',
      ),
      const DocsInstallFact(
        label: 'Destination',
        value: 'lib/components/ui/sidebar.dart + nav_user.dart',
        description:
            'Where a manifest would put them, and where a manual copy '
            'should go.',
      ),
      const DocsInstallFact(
        label: 'Foundation',
        value: 'source or package compatible',
        description:
            'Nothing in either file is package-mode-only; every token comes '
            'through the foundation.',
      ),
      DocsInstallFact(
        label: 'Dependencies',
        value: dependencies.join(', '),
        description:
            'Source-level imports from lib/src/components: not a verified '
            'registryDependencies list from the shipped manifest, which '
            'verify against. The first nine belong to sidebar.dart, the '
            'last four to nav_user.dart.',
      ),
      const DocsInstallFact(
        label: 'Assets',
        value: 'none',
        description:
            'No image, font, or shader asset is referenced. Glyphs come '
            'from the generated icon paths.',
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
            'test/sidebar_test.dart covers collapse, variants, rows, the '
            'pill, tooltips, disclosure and the mobile branch against the '
            "reference's own measurements; this page's own test drives the "
            'live specimens and the registry manifest is fixture-tested.',
      ),
    ],
  );
}

/* ── Theming ─────────────────────────────────────────────────────────────── */

class _ThemingSection extends StatelessWidget {
  const _ThemingSection();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      ElPanel(
        label: 'What actually varies with the theme',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElText(
              'The panel has its own colour pair, separate from the page: '
              'the sidebar fill and the sidebar foreground, which every '
              'region inherits as ambient ink. Borders inside the panel use '
              'the sidebar border colour, while the panel edge itself uses '
              'the ordinary border colour: those are two different tokens '
              'and the difference is visible in both themes. This is the '
              'port of the reference --sidebar-* custom properties: fixed '
              'foundation tokens rather than CSS variables, but the same '
              'pair in both places.',
              ElType.small,
            ),
            SizedBox(height: el(3)),
            ElText(
              'The active row does not paint a fill. The pill does, from '
              'the secondary colour with the chip shadow spec, because a '
              'fill alone reads as a smudge and a fill with an edge reads '
              'as a surface. The active row changes only its ink, to the '
              'sidebar accent foreground.',
              ElType.small,
            ),
            SizedBox(height: el(3)),
            ElText(
              'The group label deliberately does not dim. Stock renders it '
              'at 70% strength, which it could afford because its token was '
              'a dark grey; here the token is already the lightest step '
              'that clears AA on both the background and the muted '
              'surfaces, and 70% of it measures 2.76:1 against the 4.5:1 it '
              'owes. At full strength it measures 4.83:1.',
              ElType.small,
            ),
            SizedBox(height: el(3)),
            ElText(
              'Two typed parts collide with their own utilities and lose, '
              'and both are reproduced rather than fixed: the menu badge '
              'keeps only its mono family, tabular figures and tracking, '
              'and the account avatar fallback keeps its weight but not its '
              'size.',
              ElType.small,
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsApiTable(
        title: 'Layout tokens the family exposes',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'ElWidths.sidebar',
            type: '256',
            description: 'The expanded panel and the offcanvas travel.',
          ),
          DocsApiFact(
            name: 'ElWidths.sidebarIcon',
            type: '48',
            description: 'The collapsed rail, and the hit-target floor.',
          ),
          DocsApiFact(
            name: 'ElWidths.sidebarMobile',
            type: '288',
            description: 'The sheet on a narrow viewport.',
          ),
          DocsApiFact(
            name: 'ElBreakpoints.md',
            type: '768',
            description: 'The one threshold the family reads.',
          ),
          DocsApiFact(
            name: 'ElDurations.transitionDefault',
            type: '250ms',
            description:
                'The collapse, the group fold, the disclosure line and the '
                'rail all run on it.',
          ),
          DocsApiFact(
            name: 'ElRadii.lg',
            type: 'the row corner',
            description:
                'Rows are rounded rather than pilled: a 240px pill is a '
                'lozenge, and at that width the radius stops describing the '
                'object and starts fighting the stack. The sub-menu links '
                'and the pill use the same corner; menu actions use the '
                'medium one.',
          ),
        ],
      ),
    ],
  );
}

/* ── Source ──────────────────────────────────────────────────────────────── */

class _SourceSection extends StatelessWidget {
  const _SourceSection({required this.sourcePath});

  final String sourcePath;

  @override
  Widget build(BuildContext context) => DocsInstallFacts(
    title: 'Source and tests',
    facts: <DocsInstallFact>[
      DocsInstallFact(
        label: 'Source',
        value: sourcePath,
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
            'Composed from the same repository path referenced by the '
            'sidebar registry manifest.',
      ),
      const DocsInstallFact(
        label: 'Tests',
        value: 'test/sidebar_test.dart',
        description:
            'Six groups: collapse, variants, rows, the pill, tooltips and '
            'disclosure, plus the parts group that covers the field, the '
            'skeleton hash, the scope contract and the mobile branch. Every '
            'number quoted on this page comes from there.',
      ),
      const DocsInstallFact(
        label: 'Docs specimen',
        value: 'example/test/components_docs/sidebar_test.dart',
        description:
            "This page's own coverage: API completeness across the family, "
            'the live 256/48 collapse, the offcanvas gap, the parts stage, '
            'the keyboard shortcut, both viewports and both themes.',
      ),
      const DocsInstallFact(
        label: 'Live demo',
        value: '/sidebar-demo',
        description:
            'The one route in the example app with no docs chrome, because '
            'a real shell needs the whole viewport to show collapsing, the '
            'rail, the mobile sheet and the shortcut at once.',
      ),
    ],
  );
}

/* ── Live specimens ──────────────────────────────────────────────────────── */

const ElNavUserAccount _account = ElNavUserAccount(
  name: 'Ayoub Elattar',
  email: 'ayoub@elattar.dev',
);

const List<ElNavUserItem> _accountItems = <ElNavUserItem>[
  ElNavUserItem(label: 'Account', icon: ElLucide.badgeCheck),
  ElNavUserItem(label: 'Billing', icon: ElLucide.creditCard),
  ElNavUserItem(label: 'Notifications', icon: ElLucide.bell),
  ElNavUserItem(label: 'Sign out', icon: ElLucide.logOut, destructive: true),
];

const List<({String label, ElIconGlyph icon})> _shellRows =
    <({String label, ElIconGlyph icon})>[
      (label: 'Overview', icon: ElIconGlyph.layers),
      (label: 'Segments', icon: ElIconGlyph.star),
      (label: 'Revenue', icon: ElIconGlyph.wallet),
    ];

/// The primary specimen: a real app shell that collapses to an icon rail.
class _ShellSpecimen extends StatelessWidget {
  const _ShellSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ClipRect(
      child: SizedBox(
        key: const ValueKey<String>('sidebar-doc-specimen-shell'),
        height: el(96),
        child: ElSidebarProvider(
          children: <Widget>[
            ElSidebar(
              collapsible: ElSidebarCollapsible.icon,
              children: <Widget>[
                ElSidebarHeader(
                  children: <Widget>[
                    ElSidebarMenu(
                      children: <Widget>[
                        ElSidebarMenuItem(
                          button: ElSidebarMenuButton(
                            size: ElSidebarMenuButtonSize.lg,
                            tooltip: 'Elattar',
                            child: ElSidebarMenuRow(
                              size: ElSidebarMenuButtonSize.lg,
                              leading: ElIcon(
                                ElIconGlyph.sparkles,
                                sizePx: ElButton.iconPxFor(ElButtonSize.lg),
                              ),
                              label: const ElSidebarMenuLabel('Elattar'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElSidebarContent(
                  children: <Widget>[
                    ElSidebarGroup(
                      children: <Widget>[
                        const ElSidebarGroupLabel('Platform'),
                        ElSidebarGroupContent(
                          child: ElSidebarMenu(
                            children: <Widget>[
                              for (int i = 0; i < _shellRows.length; i++)
                                ElSidebarMenuItem(
                                  button: ElSidebarMenuButton(
                                    isActive: i == 0,
                                    tooltip: _shellRows[i].label,
                                    child: ElSidebarMenuRow(
                                      leading: ElIcon(
                                        _shellRows[i].icon,
                                        sizePx: ElButton.iconPxFor(
                                          ElButtonSize.sm,
                                        ),
                                      ),
                                      label: ElSidebarMenuLabel(
                                        _shellRows[i].label,
                                      ),
                                    ),
                                  ),
                                  submenu: i == 0
                                      ? const ElSidebarMenuSub(
                                          children: <Widget>[
                                            ElSidebarMenuSubItem(
                                              child: ElSidebarMenuSubButton(
                                                label: 'Live',
                                                isActive: true,
                                              ),
                                            ),
                                            ElSidebarMenuSubItem(
                                              child: ElSidebarMenuSubButton(
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
                const ElSidebarFooter(
                  children: <Widget>[
                    ElNavUser(user: _account, items: _accountItems),
                  ],
                ),
                const ElSidebarRail(),
              ],
            ),
            ElSidebarInset(
              child: Padding(
                padding: EdgeInsets.all(el(4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const ElSidebarTrigger(),
                        SizedBox(width: el(2)),
                        ElText('Overview', ElType.h4, color: theme.foreground),
                      ],
                    ),
                    SizedBox(height: el(3)),
                    ElText(
                      'The panel travels 256 to 48 over 250ms. The labels, '
                      'the nested list and the group heading go; the rows '
                      'stay, as 32px squares that name themselves through '
                      'their tooltips.',
                      ElType.small,
                      color: theme.mutedForeground,
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
    final ElThemeData theme = ElTheme.of(context);
    return ClipRect(
      child: SizedBox(
        key: const ValueKey<String>('sidebar-doc-specimen-offcanvas'),
        height: el(64),
        child: ElSidebarProvider(
          children: <Widget>[
            ElSidebar(
              children: <Widget>[
                ElSidebarContent(
                  children: <Widget>[
                    ElSidebarGroup(
                      children: <Widget>[
                        const ElSidebarGroupLabel('Workspace'),
                        ElSidebarGroupContent(
                          child: ElSidebarMenu(
                            children: <Widget>[
                              for (int i = 0; i < _shellRows.length; i++)
                                ElSidebarMenuItem(
                                  button: ElSidebarMenuButton(
                                    isActive: i == 1,
                                    tooltip: _shellRows[i].label,
                                    child: ElSidebarMenuRow(
                                      leading: ElIcon(
                                        _shellRows[i].icon,
                                        sizePx: ElButton.iconPxFor(
                                          ElButtonSize.sm,
                                        ),
                                      ),
                                      label: ElSidebarMenuLabel(
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
                const ElSidebarRail(),
              ],
            ),
            ElSidebarInset(
              child: Padding(
                padding: EdgeInsets.all(el(4)),
                child: Row(
                  children: <Widget>[
                    const ElSidebarTrigger(),
                    SizedBox(width: el(2)),
                    Expanded(
                      child: ElText(
                        'Offcanvas: the gap closes to nothing and the panel '
                        'keeps its 256 as it leaves.',
                        ElType.small,
                        color: theme.mutedForeground,
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
    height: el(120),
    child: ElSidebarProvider(
      children: <Widget>[
        Expanded(
          child: ElSidebar(
            collapsible: ElSidebarCollapsible.none,
            expand: true,
            children: <Widget>[
              const ElSidebarHeader(
                children: <Widget>[
                  ElSidebarInput(placeholder: 'Search', label: 'Search'),
                ],
              ),
              ElSidebarContent(
                children: <Widget>[
                  ElSidebarGroup(
                    children: <Widget>[
                      const ElSidebarGroupLabel('Platform'),
                      ElSidebarGroupContent(
                        child: ElSidebarMenu(
                          children: <Widget>[
                            ElSidebarMenuItem(
                              button: ElSidebarMenuButton(
                                isActive: true,
                                tooltip: 'Reports',
                                child: ElSidebarMenuRow(
                                  leading: ElIcon(
                                    ElIconGlyph.layers,
                                    sizePx: ElButton.iconPxFor(ElButtonSize.sm),
                                  ),
                                  label: const ElSidebarMenuLabel('Reports'),
                                ),
                              ),
                              badge: const ElSidebarMenuBadge('3'),
                            ),
                            ElSidebarMenuItem(
                              button: ElSidebarMenuButton(
                                tooltip: 'Segments',
                                child: ElSidebarMenuRow(
                                  leading: ElIcon(
                                    ElIconGlyph.star,
                                    sizePx: ElButton.iconPxFor(ElButtonSize.sm),
                                  ),
                                  label: const ElSidebarMenuLabel('Segments'),
                                ),
                              ),
                              action: const ElSidebarMenuAction(
                                label: 'Add segment',
                                child: ElIcon(ElIconGlyph.plus),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const ElSidebarSeparator(),
                  ElSidebarCollapsibleGroup(
                    label: 'Collection',
                    toggleLabel: 'Toggle Collection group',
                    action: const ElSidebarGroupAction(
                      label: 'Add to collection',
                      child: ElIcon(ElIconGlyph.plus),
                    ),
                    child: ElSidebarMenu(
                      children: <Widget>[
                        ElSidebarMenuItem(
                          button: ElSidebarMenuButton(
                            tooltip: 'Wallet',
                            child: ElSidebarMenuRow(
                              leading: ElIcon(
                                ElIconGlyph.wallet,
                                sizePx: ElButton.iconPxFor(ElButtonSize.sm),
                              ),
                              label: const ElSidebarMenuLabel('Wallet'),
                            ),
                          ),
                          submenu: const ElSidebarMenuSub(
                            children: <Widget>[
                              ElSidebarMenuSubItem(
                                child: ElSidebarMenuSubButton(
                                  label: 'Open',
                                  isActive: true,
                                ),
                              ),
                              ElSidebarMenuSubItem(
                                child: ElSidebarMenuSubButton(label: 'Settled'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const ElSidebarGroup(
                    children: <Widget>[
                      ElSidebarGroupLabel('Loading'),
                      ElSidebarGroupContent(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ElSidebarMenuSkeleton(
                              showIcon: true,
                              seed: 'row-1',
                            ),
                            ElSidebarMenuSkeleton(
                              showIcon: true,
                              seed: 'row-2',
                            ),
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

/* ── Small shared bits ───────────────────────────────────────────────────── */

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElText(label, ElType.section, color: theme.actionInk),
          SizedBox(height: el(1)),
          ElText(body, ElType.small),
        ],
      ),
    );
  }
}

/* ── Code samples ────────────────────────────────────────────────────────── */

const String _usageMinimalCode =
    '''import 'package:elattar_design_system/elattar_design_system.dart';

// The provider owns the state and the Ctrl-B / Cmd-B shortcut; the panel
// and the main column are its two flex children.
ElSidebarProvider(
  children: <Widget>[
    ElSidebar(
      collapsible: ElSidebarCollapsible.icon,
      children: <Widget>[
        ElSidebarContent(
          children: <Widget>[
            ElSidebarGroup(
              children: <Widget>[
                const ElSidebarGroupLabel('Platform'),
                ElSidebarGroupContent(
                  child: ElSidebarMenu(
                    children: <Widget>[
                      ElSidebarMenuItem(
                        button: ElSidebarMenuButton(
                          isActive: true,
                          tooltip: 'Overview',
                          onPressed: () {},
                          child: ElSidebarMenuRow(
                            leading: ElIcon(
                              ElIconGlyph.layers,
                              sizePx: ElButton.iconPxFor(ElButtonSize.sm),
                            ),
                            label: const ElSidebarMenuLabel('Overview'),
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
        const ElSidebarRail(),
      ],
    ),
    const ElSidebarInset(child: ElSidebarTrigger()),
  ],
)''';

const String _usageRowCode =
    '''// A row that survives the collapse with its name intact.
//
// tooltip does two jobs: it is the label shown beside the collapsed glyph,
// AND the accessible name handed to the button underneath. A row given
// neither tooltip nor label becomes an unnamed button once collapsed,
// because the visible text that was naming it is gone.
ElSidebarMenuItem(
  button: ElSidebarMenuButton(
    isActive: selected == 'revenue',
    tooltip: 'Revenue',
    onPressed: () => select('revenue'),
    child: ElSidebarMenuRow(
      leading: ElIcon(
        ElIconGlyph.wallet,
        sizePx: ElButton.iconPxFor(ElButtonSize.sm),
      ),
      label: const ElSidebarMenuLabel('Revenue'),
    ),
  ),
  // Both hide themselves in icon mode, and both widen the row's right
  // padding while they are visible.
  badge: const ElSidebarMenuBadge('3'),
)''';

const String _usageGroupCode =
    '''// The disclosure line is the trigger, not the title and not the action:
// clicking the action performs its verb, and the divider only changes
// disclosure state.
ElSidebarCollapsibleGroup(
  label: 'Collection',
  toggleLabel: 'Toggle Collection group',
  action: ElSidebarGroupAction(
    label: 'Add to collection',
    onPressed: () {},
    child: const ElIcon(ElIconGlyph.plus),
  ),
  child: ElSidebarMenu(
    children: <Widget>[
      ElSidebarMenuItem(
        button: const ElSidebarMenuButton(
          tooltip: 'Wallet',
          child: ElSidebarMenuLabel('Wallet'),
        ),
        submenu: ElSidebarMenuSub(
          children: <Widget>[
            ElSidebarMenuSubItem(
              child: ElSidebarMenuSubButton(
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
ElSidebarProvider(
  open: _open,
  onOpenChange: (bool next) => setState(() => _open = next),
  variant: ElSidebarVariant.inset,
  minHeight: MediaQuery.sizeOf(context).height,
  children: <Widget>[
    ElSidebar(
      // Must match the provider, Flutter has no :has() or peer- selector,
      // so the fact travels down twice.
      variant: ElSidebarVariant.inset,
      collapsible: ElSidebarCollapsible.icon,
      children: <Widget>[/* regions */],
    ),
    ElSidebarInset(child: page),
  ],
)''';

const String _usageNavUserCode =
    '''// nav_user.dart: the account block a sidebar footer is incomplete
// without. It reads ElSidebarScope for isMobile, so it only works inside a
// provider, and it composes ElSidebarMenu itself: put it straight into the
// footer, not inside another menu.
ElSidebarFooter(
  children: <Widget>[
    ElNavUser(
      user: const ElNavUserAccount(
        name: 'Ayoub Elattar',
        email: 'ayoub@elattar.dev',
      ),
      items: <ElNavUserItem>[
        ElNavUserItem(label: 'Account', icon: ElLucide.badgeCheck),
        ElNavUserItem(label: 'Billing', icon: ElLucide.creditCard),
        // Destructive items are gathered below a separator, wherever they
        // sit in the list.
        ElNavUserItem(
          label: 'Sign out',
          icon: ElLucide.logOut,
          destructive: true,
          onSelect: signOut,
        ),
      ],
    ),
  ],
)''';

const String _installShellExcerpt = '''enum ElSidebarSide { left, right }

enum ElSidebarVariant { sidebar, floating, inset }

enum ElSidebarCollapsible { offcanvas, icon, none }

class ElSidebarProvider extends StatefulWidget {
  const ElSidebarProvider({
    super.key,
    required this.children,
    this.defaultOpen = true,
    this.open,
    this.onOpenChange,
    this.variant = ElSidebarVariant.sidebar,
    this.minHeight,
  });

  static const LogicalKeyboardKey shortcut = LogicalKeyboardKey.keyB;
  static bool isMobileWidth(double width) => width < ElBreakpoints.md;
}

class ElSidebar extends StatelessWidget {
  const ElSidebar({
    super.key,
    required this.children,
    this.side = ElSidebarSide.left,
    this.variant = ElSidebarVariant.sidebar,
    this.collapsible = ElSidebarCollapsible.offcanvas,
    this.expand = false,
  });
}

// Plus: ElSidebarScope, ElSidebarChrome, ElSidebarRail, ElSidebarTrigger,
// ElSidebarInset, and the region, group and menu parts: see the API
// Reference section on this page for every one of them.''';

const String _installNavUserExcerpt = '''class ElNavUserAccount {
  const ElNavUserAccount({
    required this.name,
    required this.email,
    this.avatar,
  });

  String get initials;
}

class ElNavUserItem {
  const ElNavUserItem({
    required this.label,
    this.icon,
    this.onSelect,
    this.destructive = false,
  });
}

class ElNavUser extends StatelessWidget {
  const ElNavUser({super.key, required this.user, required this.items});

  static double get menuMinWidth => el(56);
}''';
