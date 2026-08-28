/// Public-facing landing pages for the release site.
///
/// These pages are deliberately composed in the example app. They explain the
/// package, registry, CLI and skill without pretending that the later registry
/// and generated documentation phases are complete.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart'
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
        TableColumnWidth,
        ActionChip,
        AlertDialog,
        Badge,
        Card,
        CarouselController,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        DrawerHeader,
        Slider,
        Switch,
        TextFormField,
        Tooltip;

import '../../kit.dart';
import '../../nav.dart';
import '../../components_docs/catalog.dart';
// `/docs` and `/components` are documentation pages, so they render in the
// same [DocsLayout] shell every other documentation page uses, which is where
// the shared left rail and the in-page right rail come from.
import '../../docs/docs_layout.dart';
import '../../docs_pages/catalog.dart'
    show
        docsChangelogRoute,
        docsCliRoute,
        docsInstallationRoute,
        docsIntroductionRoute,
        docsRegistryRoute,
        docsThemingRoute,
        docsTypesetRoute;
import '../site_routes.dart' show componentsRoute, docsRoute, skillsRoute;
import 'home_showcase.dart';

typedef PublicNavigate = void Function(String route);

const String publicHomeRoute = '/';
const String publicDocsRoute = '/docs';
const String publicComponentsRoute = '/components';

/// `/skills` has no constant here, on purpose. There is exactly one spelling
/// of it, `skillsRoute` in `site/site_routes.dart`, which the header nav, the
/// search index and the router all read. `publicSkillsRoute` was a second copy
/// of it and went with `PublicSkillsPage` in Phase H, when
/// `skills_docs/skills_page.dart` took the route. This library imports
/// `skillsRoute` for its one remaining caller: the docs link card below.
///
/// The remaining `public*Route` constants are pre-Phase-G aliases of the same
/// paths and are left as they are: each still has a caller in this library.

class PublicHomePage extends StatelessWidget {
  const PublicHomePage({super.key, this.onNavigate});

  final PublicNavigate? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return _PublicPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: space(4)),
          Center(child: _HeroPill(onNavigate: onNavigate)),
          SizedBox(height: space(6)),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Containers.xl2),
              child: StyledText(
                'Build the interface\nyou mean.',
                TextStyles.display,
                fontSize: Fluid.display(context),
                align: TextAlign.center,
                color: theme.foreground,
              ),
            ),
          ),
          SizedBox(height: space(5)),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Containers.md),
              child: StyledText(
                'A copy-first design system for Flutter. Start with the '
                'foundation, add only the pieces you need, and keep every '
                'decision visible in your own codebase.',
                TextStyles.lead,
                align: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: space(7)),
          Center(
            child: Button(
              size: ButtonSize.lg,
              onPressed: onNavigate == null
                  ? null
                  : () => onNavigate!(publicDocsRoute),
              child: const Text('Start building'),
            ),
          ),
          SizedBox(height: space(16)),
          HomeMasonryGrid(sm: 2, lg: 3, children: homeShowcaseCards()),
        ],
      ),
    );
  }
}

/// The pill at the top of the hero: a small, tappable, pill-shaped link, the
/// way https://ui.shadcn.com/ leads with "Introducing…" above its own
/// headline. [Button] is already pill-radius by default (see
/// `Button.build`'s `widget.radius ?? BorderRadius.circular(Radii.full)`),
/// so this is a plain outline button sized down, not a bespoke shape.
class _HeroPill extends StatelessWidget {
  const _HeroPill({this.onNavigate});

  final PublicNavigate? onNavigate;

  @override
  Widget build(BuildContext context) => Button(
    size: ButtonSize.sm,
    variant: ButtonVariant.outline,
    onPressed: onNavigate == null
        ? null
        : () => onNavigate!(publicComponentsRoute),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Browse components'),
        SizedBox(width: space(1.5)),
        const Icon(
          IconGlyph.arrowRight,
          size: IconSize.xs,
          tone: IconTone.muted,
        ),
      ],
    ),
  );
}

class PublicDocsPage extends StatelessWidget {
  const PublicDocsPage({super.key, this.onNavigate});

  final PublicNavigate? onNavigate;

  /// Rendered in [DocsLayout], the same shell every documentation page uses.
  /// `/docs` is a documentation page, so it carries the identical left rail
  /// for cross-page navigation and the identical right rail for in-page
  /// navigation. Only the centre column differs from its siblings.
  @override
  Widget build(BuildContext context) => DocsLayout(
    route: docsRoute,
    intro: const DocsPageIntro(
      eyebrow: 'ELATTAR DESIGN SYSTEM',
      title: 'Documentation',
      description:
          'A practical path from the first install to a complete, local '
          'component system.',
    ),
    toc: const <DocsTocEntry>[DocsTocEntry(title: 'Guides', anchor: 'guides')],
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: docsAnchorKey('guides'),
      child: _DocsList(onNavigate: onNavigate),
    ),
  );
}

/// `/components`, reshaped to match the reference's own presentation
/// (https://ui.shadcn.com/docs/components): a dense, grouped list of plain
/// text links, not a stack of bordered cards. The reference itself carries no
/// description, icon, or button per entry, and no blurb under a group
/// heading: one line under the page title is the only prose on the page.
/// That is reproduced here rather than improved on, per the parity brief.
///
/// Two link sections mirror the two catalogs this site actually has:
/// [componentDocs] (34 individually documented components, alphabetical, one
/// route each, the direct counterpart of the reference's "All Components")
/// under "Ready to install", then one section per non-Foundations [Group]
/// listing its categories, since those are the site's only other
/// individually routable pages. Foundations is excluded, as it was before
/// this page was reshaped: it is not a component family.
class PublicComponentsPage extends StatelessWidget {
  const PublicComponentsPage({super.key, this.onNavigate});

  final PublicNavigate? onNavigate;

  /// Lists only the documented components, each of which has its own page
  /// under `/components/<name>`.
  ///
  /// The `elGroups` categories that used to follow are gone: every one of them
  /// linked into the legacy `/space/...` tree, which no longer exists. A page a
  /// reader cannot open does not belong in an index.
  @override
  Widget build(BuildContext context) {
    return DocsLayout(
      route: componentsRoute,
      intro: const DocsPageIntro(
        eyebrow: 'COMPONENT LIBRARY',
        title: 'Components',
        description: 'Every component available in the library, in one place.',
      ),
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Ready to install', anchor: 'ready'),
      ],
      onNavigate: onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          KeyedSubtree(
            key: docsAnchorKey('ready'),
            child: _ComponentLinkSection(
              title: 'Ready to install',
              entries: <_ComponentLinkEntry>[
                for (final ComponentDocEntry component in componentDocs)
                  _ComponentLinkEntry(
                    title: component.title,
                    route: component.route,
                  ),
              ],
              onNavigate: onNavigate,
            ),
          ),
        ],
      ),
    );
  }
}

/// One "Ready to install" or group heading plus its dense link grid: the
/// reference's `## New Components` / `## All Components` shape, generalised
/// to however many sections this site actually has.
class _ComponentLinkSection extends StatelessWidget {
  const _ComponentLinkSection({
    required this.title,
    required this.entries,
    required this.onNavigate,
  });

  final String title;
  final List<_ComponentLinkEntry> entries;
  final PublicNavigate? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StyledText(title, TextStyles.h3, color: theme.foreground),
        SizedBox(height: space(4)),
        Grid(
          sm: 2,
          lg: 3,
          gap: space(2),
          children: <Widget>[
            for (final _ComponentLinkEntry entry in entries)
              _ComponentLinkRow(
                entry: entry,
                onPressed: onNavigate == null
                    ? null
                    : () => onNavigate!(entry.route),
              ),
          ],
        ),
      ],
    );
  }
}

class _ComponentLinkEntry {
  const _ComponentLinkEntry({required this.title, required this.route});

  final String title;
  final String route;
}

/// One plain-text entry in the dense grid: no card, no description, no
/// button, matching the reference's own `<Link>Accordion</Link>` shape. The
/// hover cross-fade follows the same `TweenAnimationBuilder<Color?>` idiom
/// `docs_sidebar.dart`'s `_SidebarRow` and `breadcrumb.dart` already use for a
/// plain navigational link in this codebase.
class _ComponentLinkRow extends StatefulWidget {
  const _ComponentLinkRow({required this.entry, required this.onPressed});

  final _ComponentLinkEntry entry;
  final VoidCallback? onPressed;

  @override
  State<_ComponentLinkRow> createState() => _ComponentLinkRowState();
}

class _ComponentLinkRowState extends State<_ComponentLinkRow> {
  bool _hovered = false;

  void _hover(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Duration duration = effectiveMotionDuration(
      context,
      MotionDurations.normal,
    );
    return Semantics(
      link: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _hover(true),
        onExit: (_) => _hover(false),
        child: GestureDetector(
          onTap: widget.onPressed,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: space(1.5)),
            child: TweenAnimationBuilder<Color?>(
              tween: ColorTween(
                end: _hovered ? theme.actionText : theme.mutedForeground,
              ),
              duration: duration,
              curve: MotionCurves.enter,
              builder: (BuildContext context, Color? ink, Widget? _) =>
                  StyledText(widget.entry.title, TextStyles.small, color: ink),
            ),
          ),
        ),
      ),
    );
  }
}

/// `/skills` is no longer served from this library. `PublicSkillsPage`: a
/// hand-written summary of the skill, with three cards restating its workflow —
/// was retired when `skills_docs/skills_page.dart`'s `SkillsPage` took the
/// route in Phase H. The real page reads the skill's own catalog entry, so the
/// version, the supported agents, the reference file tree and the install
/// routes cannot drift from the skill itself.
///
/// The guard that page carried is not lost, and is not weakened: it published
/// `npx skills add ELATTAR-Ayoub/flutter-design-system`, a command nothing in
/// this repository implements, and the assertion that no code block could
/// reappear was a proxy for "prints no unverified command". `SkillsPage` now
/// prints commands legitimately, so the proxy is replaced by the thing it stood
/// for: every command rendered at `/skills` must appear in
/// `skills_docs/catalog.dart`'s `verifiedCommands` allowlist, and no `npx` text
/// may be reachable there at all. Both are asserted in `public_pages_test.dart`
/// against the mounted route, and again in `skills_docs_test.dart` against the
/// widget.

class _PublicPage extends StatelessWidget {
  const _PublicPage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    bottom: true,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: space(4), vertical: space(8)),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Breakpoints.xl),
          child: child,
        ),
      ),
    ),
  );
}

class _PublicLinkCard extends StatelessWidget {
  const _PublicLinkCard({
    required this.title,
    required this.body,
    required this.label,
    this.onPressed,
  });

  final String title;
  final String body;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Card(
      children: <Widget>[
        CardHeader(
          title: StyledText(title, TextStyles.h4, color: theme.foreground),
          description: StyledText(
            label,
            TextStyles.eyebrow,
            color: theme.actionText,
          ),
        ),
        CardContent(child: StyledText(body, TextStyles.small)),
        CardFooter(
          child: Button(
            variant: ButtonVariant.ghost,
            onPressed: onPressed,
            child: const Text('Open reference'),
          ),
        ),
      ],
    );
  }
}

class _DocsList extends StatelessWidget {
  const _DocsList({this.onNavigate});

  final PublicNavigate? onNavigate;

  /// The guide cards, in the sidebar's own reading order.
  ///
  /// **Every one of these goes somewhere.** Five of the seven used to route
  /// to `publicHomeRoute` — a card that advertises Installation and returns
  /// you to the front page reads as a broken site, and it was the most
  /// visible thing on `/docs`. Two of them ("Flutter & Dart", "Repository")
  /// described pages that do not exist and never did; they are replaced by
  /// the three that do.
  ///
  /// Routes are the `docs_pages/catalog.dart` constants rather than literals,
  /// so a route that is renamed cannot leave a card pointing at nothing.
  static const List<({String title, String body, String route})> _entries =
      <({String title, String body, String route})>[
        (
          title: 'Introduction',
          body: 'The mental model, principles and package boundaries.',
          route: docsIntroductionRoute,
        ),
        (
          title: 'Installation',
          body: 'Install the CLI, set up a project, add your first component.',
          route: docsInstallationRoute,
        ),
        (
          title: 'Theming',
          body: 'Understand themes, semantic colors and typography tokens.',
          route: docsThemingRoute,
        ),
        (
          title: 'CLI',
          body: 'Initialize, add, inspect and update copied components.',
          route: docsCliRoute,
        ),
        (
          title: 'Typeset',
          body: 'The 27 named type roles, and how to choose between them.',
          route: docsTypesetRoute,
        ),
        (
          title: 'Registry',
          body: 'What an item declares, and how a name becomes files.',
          route: docsRegistryRoute,
        ),
        (
          title: 'Changelog',
          body: 'Every release, rendered from the repository CHANGELOG.',
          route: docsChangelogRoute,
        ),
        (
          title: 'Skills',
          // Not "install": the skill's routes are documented but not yet
          // verified end to end, and the Skills page says so itself, route by
          // route. `skillsRoute`, not a literal: one spelling of `/skills`.
          body: 'The workflow that keeps implementation consistent.',
          route: skillsRoute,
        ),
      ];

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      for (final ({String title, String body, String route}) entry in _entries)
        Padding(
          padding: EdgeInsets.only(bottom: space(3)),
          child: _PublicLinkCard(
            title: entry.title,
            body: entry.body,
            label: 'DOCS',
            onPressed: onNavigate == null
                ? null
                : () => onNavigate!(entry.route),
          ),
        ),
    ],
  );
}
