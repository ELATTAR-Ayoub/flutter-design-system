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

typedef PublicNavigate = void Function(String route);

const String publicHomeRoute = '/';
const String publicDocsRoute = '/docs';
const String publicComponentsRoute = '/components';
const String publicShotsRoute = '/shots';
const String publicSkillsRoute = '/skills';

final List<DsCategory> _featuredCategories = <DsCategory>[
  findCategory('foundations', 'colors').category,
  findCategory('foundations', 'typography').category,
  findCategory('base', 'buttons').category,
  findCategory('base', 'dialogs').category,
];

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
          _Hero(onNavigate: onNavigate),
          SizedBox(height: ds(16)),
          _SectionHeading(
            eyebrow: 'FOUNDATION FIRST',
            title: 'A system that arrives ready to use.',
            description:
                'Start with the visual foundation, then copy only the components your product needs. Every layer stays local, inspectable and yours.',
          ),
          SizedBox(height: ds(6)),
          DsGrid(
            sm: 3,
            children: const <Widget>[
              _FeatureCard(
                index: '01',
                title: 'Copy the foundation',
                body:
                    'Theme, typography, color and motion are the default starting point.',
              ),
              _FeatureCard(
                index: '02',
                title: 'Add by intent',
                body:
                    'Install a component into components/ui when you actually need it.',
              ),
              _FeatureCard(
                index: '03',
                title: 'Own the result',
                body:
                    'Generated files are readable Flutter code, made for your repository.',
              ),
            ],
          ),
          SizedBox(height: ds(16)),
          DsPanel(
            label: 'QUICKSTART',
            note: '0.0.1',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DsText(
                  'One command to begin.',
                  DsType.h3,
                  color: theme.foreground,
                ),
                SizedBox(height: ds(2)),
                DsText(
                  'Initialize the system in a Flutter project, then add components as your interface grows.',
                  DsType.body,
                ),
                SizedBox(height: ds(5)),
                const _CodeSnippet(
                  code: 'dart run elattar_cli init --foundation source',
                ),
                SizedBox(height: ds(5)),
                Wrap(
                  spacing: ds(3),
                  runSpacing: ds(3),
                  children: <Widget>[
                    DsButton(
                      onPressed: onNavigate == null
                          ? null
                          : () => onNavigate!(publicDocsRoute),
                      child: const Text('Read the docs'),
                    ),
                    DsButton(
                      variant: DsButtonVariant.outline,
                      onPressed: onNavigate == null
                          ? null
                          : () => onNavigate!(publicComponentsRoute),
                      child: const Text('Browse components'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: ds(16)),
          _SectionHeading(
            eyebrow: 'SELECTED STARTING POINTS',
            title: 'See the decisions before the details.',
            description:
                'A small set of live references to help you choose the right next step.',
          ),
          SizedBox(height: ds(6)),
          DsGrid(
            sm: 2,
            children: <Widget>[
              for (final DsCategory category in _featuredCategories)
                _PublicLinkCard(
                  title: category.title,
                  body: category.blurb,
                  label: category.contents.take(3).join(' · '),
                  onPressed: onNavigate == null
                      ? null
                      : () => onNavigate!(
                          category.slug == 'colors'
                              ? '/design-system/colors'
                              : category.slug == 'typography'
                              ? '/design-system/typography'
                              : '/design-system/components/base/${category.slug}',
                        ),
                ),
            ],
          ),
        ],
      ),
    );
  }
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

class PublicShotsPage extends StatelessWidget {
  const PublicShotsPage({super.key, this.onNavigate});

  final PublicNavigate? onNavigate;

  @override
  Widget build(BuildContext context) => _PublicPage(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DsPageHeader(
          eyebrow: 'COMPOSED EXAMPLES',
          title: 'Shots',
          blurb:
              'Small, complete screens that show how the primitives work together in a real surface.',
        ),
        DsGrid(
          sm: 2,
          children: <Widget>[
            _ShotCard(
              title: 'Signal Studio',
              body:
                  'A focused agent workspace built from the system’s chat and navigation primitives.',
              route: showcaseRoute,
              onNavigate: onNavigate,
            ),
            _ShotCard(
              title: 'Design system overview',
              body:
                  'Foundations and component families arranged as a readable reference surface.',
              route: dsRoot,
              onNavigate: onNavigate,
            ),
            _ShotCard(
              title: 'Form flow',
              body:
                  'Fields, feedback and confirmation states composed into one useful task.',
              route: '$dsRoot/components/base/forms',
              onNavigate: onNavigate,
            ),
            _ShotCard(
              title: 'Conversation surface',
              body:
                  'Messages, attachments and composer states with room for product copy.',
              route: '$dsRoot/components/base/chat',
              onNavigate: onNavigate,
            ),
          ],
        ),
      ],
    ),
  );
}

class PublicSkillsPage extends StatelessWidget {
  const PublicSkillsPage({super.key, this.onNavigate});

  final PublicNavigate? onNavigate;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return _PublicPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DsPageHeader(
            eyebrow: 'AGENT WORKFLOW',
            title: 'Skills',
            blurb:
                'Installable guidance for agents and teams that need to build with the same design-system contract.',
          ),
          DsPanel(
            label: 'ELATTAR FLUTTER UI DIRECTOR',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DsText(
                  'A shared way of working.',
                  DsType.h3,
                  color: theme.foreground,
                ),
                SizedBox(height: ds(3)),
                DsText(
                  'The skill teaches API inventory, token usage, responsive composition, accessibility states and the verification ladder. It keeps product UI in the example layer and the package as the source of truth.',
                  DsType.body,
                ),
                SizedBox(height: ds(5)),
                const _CodeSnippet(
                  code: 'npx skills add ELATTAR-Ayoub/flutter-design-system',
                ),
                SizedBox(height: ds(5)),
                DsButton(
                  variant: DsButtonVariant.outline,
                  onPressed: onNavigate == null
                      ? null
                      : () => onNavigate!(publicDocsRoute),
                  child: const Text('Read the workflow'),
                ),
              ],
            ),
          ),
          SizedBox(height: ds(8)),
          DsGrid(
            sm: 3,
            children: const <Widget>[
              _FeatureCard(
                index: '01',
                title: 'Discover',
                body:
                    'Inspect the public barrel and existing specimens before adding a primitive.',
              ),
              _FeatureCard(
                index: '02',
                title: 'Compose',
                body:
                    'Use semantic Ds* APIs and foundation tokens for product surfaces.',
              ),
              _FeatureCard(
                index: '03',
                title: 'Verify',
                body:
                    'Run analysis, tests, responsive checks and the token guard before handoff.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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

class _Hero extends StatelessWidget {
  const _Hero({this.onNavigate});

  final PublicNavigate? onNavigate;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsPanel(
      bodyPadding: EdgeInsets.all(ds(8)),
      bodyFill: theme.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsBadge(
            label: 'FLUTTER · OPEN SOURCE',
            variant: DsBadgeVariant.action,
          ),
          SizedBox(height: ds(5)),
          DsText(
            'Build the interface\nyou mean.',
            DsType.h1,
            fontSize: DsFluid.h1(context),
            color: theme.foreground,
          ),
          SizedBox(height: ds(4)),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: DsContainers.md),
            child: DsText(
              'A copy-first design system for Flutter. Start with the foundation, add the pieces you need, and keep every decision visible in your own codebase.',
              DsType.lead,
            ),
          ),
          SizedBox(height: ds(6)),
          Wrap(
            spacing: ds(3),
            runSpacing: ds(3),
            children: <Widget>[
              DsButton(
                size: DsButtonSize.lg,
                onPressed: onNavigate == null
                    ? null
                    : () => onNavigate!(publicDocsRoute),
                child: const Text('Start building'),
              ),
              DsButton(
                size: DsButtonSize.lg,
                variant: DsButtonVariant.outline,
                onPressed: onNavigate == null
                    ? null
                    : () => onNavigate!(publicComponentsRoute),
                child: const Text('Explore the library'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  final String eyebrow;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText(eyebrow, DsType.label, color: theme.actionInk),
        SizedBox(height: ds(2)),
        DsText(title, DsType.h2, color: theme.foreground),
        SizedBox(height: ds(2)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DsContainers.md),
          child: DsText(description, DsType.body),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.index,
    required this.title,
    required this.body,
  });

  final String index;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsCard(
      children: <Widget>[
        DsCardHeader(
          title: DsText(title, DsType.h4, color: theme.foreground),
          description: DsText(index, DsType.numSm, color: theme.actionInk),
        ),
        DsCardContent(child: DsText(body, DsType.small)),
      ],
    );
  }
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
    final DsThemeData theme = DsTheme.of(context);
    return DsCard(
      children: <Widget>[
        DsCardHeader(
          title: DsText(title, DsType.h4, color: theme.foreground),
          description: DsText(label, DsType.label, color: theme.actionInk),
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

class _ShotCard extends StatelessWidget {
  const _ShotCard({
    required this.title,
    required this.body,
    required this.route,
    this.onNavigate,
  });

  final String title;
  final String body;
  final String route;
  final PublicNavigate? onNavigate;

  @override
  Widget build(BuildContext context) => _PublicLinkCard(
    title: title,
    body: body,
    label: 'LIVE COMPOSITION',
    onPressed: onNavigate == null ? null : () => onNavigate!(route),
  );
}

class _CodeSnippet extends StatelessWidget {
  const _CodeSnippet({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) =>
      DsAgentCodeBlock(code: code, language: 'bash');
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
          body: 'Install the workflow that keeps implementation consistent.',
          route: publicSkillsRoute,
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
