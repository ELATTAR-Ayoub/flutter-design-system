/// Public-facing landing pages for the release site.
///
/// These pages are deliberately composed in the example app. They explain the
/// package, registry, CLI and skill without pretending that the later registry
/// and generated documentation phases are complete.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart';

import '../../kit.dart';
import '../../nav.dart';
import '../../components_docs/catalog.dart';
import '../site_routes.dart' show skillsRoute;
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
    final DsThemeData theme = DsTheme.of(context);
    return _PublicPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: ds(4)),
          Center(child: _HeroPill(onNavigate: onNavigate)),
          SizedBox(height: ds(6)),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: DsContainers.xl2),
              child: DsText(
                'Build the interface\nyou mean.',
                DsType.display,
                fontSize: DsFluid.display(context),
                align: TextAlign.center,
                color: theme.foreground,
              ),
            ),
          ),
          SizedBox(height: ds(5)),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: DsContainers.md),
              child: DsText(
                'A copy-first design system for Flutter. Start with the '
                'foundation, add only the pieces you need, and keep every '
                'decision visible in your own codebase.',
                DsType.lead,
                align: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: ds(7)),
          Center(
            child: DsButton(
              size: DsButtonSize.lg,
              onPressed: onNavigate == null
                  ? null
                  : () => onNavigate!(publicDocsRoute),
              child: const Text('Start building'),
            ),
          ),
          SizedBox(height: ds(16)),
          HomeMasonryGrid(sm: 2, lg: 3, children: homeShowcaseCards()),
        ],
      ),
    );
  }
}

/// The pill at the top of the hero: a small, tappable, pill-shaped link, the
/// way https://ui.shadcn.com/ leads with "Introducing…" above its own
/// headline. [DsButton] is already pill-radius by default (see
/// `DsButton.build`'s `widget.radius ?? BorderRadius.circular(DsRadii.pill)`),
/// so this is a plain outline button sized down, not a bespoke shape.
class _HeroPill extends StatelessWidget {
  const _HeroPill({this.onNavigate});

  final PublicNavigate? onNavigate;

  @override
  Widget build(BuildContext context) => DsButton(
    size: DsButtonSize.sm,
    variant: DsButtonVariant.outline,
    onPressed: onNavigate == null
        ? null
        : () => onNavigate!(publicComponentsRoute),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Browse components'),
        SizedBox(width: ds(1.5)),
        const DsIcon(
          DsIconGlyph.arrowRight,
          size: DsIconSize.xs,
          tone: DsIconTone.muted,
        ),
      ],
    ),
  );
}

class PublicDocsPage extends StatelessWidget {
  const PublicDocsPage({super.key, this.onNavigate});

  final PublicNavigate? onNavigate;

  @override
  Widget build(BuildContext context) => _PublicPage(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DsPageHeader(
          eyebrow: 'ELATTAR DESIGN SYSTEM',
          title: 'Documentation',
          blurb:
              'A practical path from the first install to a complete, local component system.',
        ),
        _DocsList(onNavigate: onNavigate),
      ],
    ),
  );
}

class PublicComponentsPage extends StatelessWidget {
  const PublicComponentsPage({super.key, this.onNavigate});

  final PublicNavigate? onNavigate;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final List<DsGroup> groups = dsGroups
        .where((DsGroup group) => group.id != 'foundations')
        .toList(growable: false);
    return _PublicPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DsPageHeader(
            eyebrow: 'COMPONENT LIBRARY',
            title: 'Components',
            blurb:
                'Browse the building blocks, understand their intent, then copy the implementation into your project.',
          ),
          DsText('Ready to install', DsType.h3, color: theme.foreground),
          SizedBox(height: ds(3)),
          DsText(
            'These pilot components have complete previews, installation paths, usage guidance, API tables, and accessibility notes.',
            DsType.body,
          ),
          SizedBox(height: ds(5)),
          DsGrid(
            sm: 2,
            xl: 3,
            children: <Widget>[
              for (final ComponentDocEntry component in componentDocs)
                _PublicLinkCard(
                  title: component.title,
                  body: component.description,
                  label: component.command,
                  labelSpec: DsType.code,
                  onPressed: onNavigate == null
                      ? null
                      : () => onNavigate!(component.route),
                ),
            ],
          ),
          SizedBox(height: ds(12)),
          for (final DsGroup group in groups) ...<Widget>[
            DsText(group.title, DsType.h3, color: theme.foreground),
            SizedBox(height: ds(3)),
            DsText(group.blurb, DsType.body),
            SizedBox(height: ds(5)),
            DsGrid(
              sm: 2,
              xl: 3,
              children: <Widget>[
                for (final DsCategory category in group.categories)
                  _PublicLinkCard(
                    title: category.title,
                    body: category.blurb,
                    label: '${category.contents.length} references',
                    onPressed: onNavigate == null
                        ? null
                        : () => onNavigate!(categoryHref(group, category)),
                  ),
              ],
            ),
            SizedBox(height: ds(12)),
          ],
        ],
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
  Widget build(BuildContext context) => DsSafeArea(
    top: false,
    bottom: true,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: ds(4), vertical: ds(8)),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DsBreakpoints.xl),
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
    this.labelSpec,
    this.onPressed,
  });

  final String title;
  final String body;
  final String label;

  /// Typography for [label]. Defaults to the uppercase eyebrow style used by
  /// the reference-count and docs-tag callers; pass [DsType.code] when the
  /// label is a literal string a reader may copy, such as a CLI command,
  /// since [DsType.label]'s `text-transform: uppercase` would otherwise
  /// mangle it.
  final DsTypeSpec? labelSpec;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsCard(
      children: <Widget>[
        DsCardHeader(
          title: DsText(title, DsType.h4, color: theme.foreground),
          description: DsText(
            label,
            labelSpec ?? DsType.label,
            color: theme.actionInk,
          ),
        ),
        DsCardContent(child: DsText(body, DsType.small)),
        DsCardFooter(
          child: DsButton(
            variant: DsButtonVariant.ghost,
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

  static const List<({String title, String body, String route})> _entries =
      <({String title, String body, String route})>[
        (
          title: 'Introduction',
          body: 'The mental model, principles and package boundaries.',
          route: publicHomeRoute,
        ),
        (
          title: 'Installation',
          body:
              'Initialize the foundation and choose the compact package mode.',
          route: publicHomeRoute,
        ),
        (
          title: 'Theming',
          body: 'Understand themes, semantic colors and typography tokens.',
          route: '/design-system/colors',
        ),
        (
          title: 'CLI',
          body: 'Initialize, add, inspect and update copied components.',
          route: publicHomeRoute,
        ),
        (
          title: 'Flutter & Dart',
          body: 'The APIs, conventions and source layout for consumers.',
          route: publicHomeRoute,
        ),
        (
          title: 'Skills',
          // Not "install": the skill's routes are documented but not yet
          // verified end to end, and the Skills page says so itself, route by
          // route. `skillsRoute`, not a literal: one spelling of `/skills`.
          body: 'The workflow that keeps implementation consistent.',
          route: skillsRoute,
        ),
        (
          title: 'Repository',
          body: 'Follow the source, registry and contribution workflow.',
          route: publicHomeRoute,
        ),
      ];

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      for (final ({String title, String body, String route}) entry in _entries)
        Padding(
          padding: EdgeInsets.only(bottom: ds(3)),
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
