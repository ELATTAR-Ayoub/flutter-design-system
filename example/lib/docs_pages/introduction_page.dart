/// Public documentation page for `/docs/introduction`.
///
/// Content contract: `docs/superpowers/plans/2026-08-21-public-website-ui-
/// information-architecture.md` section 7.4. Covers what Elattar is,
/// source-first ownership, composition through public `El*` APIs, registry
/// and CLI distribution, defaults, platform support, the agent skill, and a
/// comparison of the three install modes: package, source foundation, and
/// package foundation.
///
/// The package-foundation row is the one claim on this page a reader cannot
/// verify by running a command: it is refused up front by
/// `packages/elattar_cli/lib/src/commands/app.dart`'s `packageModeUnavailable`
/// constant (`elattar_core` does not exist), transcribed here rather than
/// re-derived so the two cannot drift silently.
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

import '../docs/docs_facts.dart';
import '../docs/docs_layout.dart';
import '../docs/docs_section.dart';
import 'catalog.dart';

class IntroductionDocsPage extends StatelessWidget {
  const IntroductionDocsPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: docsIntroductionRoute,
    intro: const DocsPageIntro(
      eyebrow: 'DOCS',
      title: 'Introduction',
      description:
          'A living Flutter reference manual where every design decision is '
          'visible, every component is executable, and every useful '
          'artifact can be installed or owned as source.',
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Docs'),
      BreadcrumbEntry.page('Introduction'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'What this is', anchor: 'overview'),
      DocsTocEntry(title: 'Source-first ownership', anchor: 'ownership'),
      DocsTocEntry(
        title: 'Composition through El* APIs',
        anchor: 'composition',
      ),
      DocsTocEntry(
        title: 'Registry and CLI distribution',
        anchor: 'distribution',
      ),
      DocsTocEntry(title: 'Defaults', anchor: 'defaults'),
      DocsTocEntry(title: 'Platform support', anchor: 'platforms'),
      DocsTocEntry(title: 'AI-ready skill and open code', anchor: 'skill'),
      DocsTocEntry(title: 'Install modes', anchor: 'modes'),
    ],
    next: const DocsPageLink(title: 'Components', route: '/components'),
    onNavigate: onNavigate,
    child: const _IntroductionArticle(),
  );
}

class _IntroductionArticle extends StatelessWidget {
  const _IntroductionArticle();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      key: const ValueKey<String>('introduction-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _overview(theme),
        _ownership(theme),
        _composition(theme),
        _distribution(theme),
        _defaults(theme),
        _platforms(theme),
        _skill(theme),
        _modes(theme),
      ],
    );
  }

  Widget _prose(String text, ThemeTokens theme, {TextStyleToken? spec}) =>
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: StyledText(text, spec ?? TextStyles.body),
      );

  Widget _overview(ThemeTokens theme) => DocsSection(
    id: 'overview',
    title: 'What this is',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Elattar is a Flutter design system: a package of semantic '
          'foundation tokens (color, type, spacing, radii, shadows, motion) '
          'and public El* components built on top of them, plus a '
          'source-first registry and CLI that let a Flutter project take a '
          'copy of that code instead of only depending on it.',
          theme,
        ),
        SizedBox(height: space(3)),
        _prose(
          'It targets Flutter developers evaluating the system, product '
          'teams installing components into an existing application, '
          'designers inspecting foundations and states, and coding agents '
          'reading the public API surface directly.',
          theme,
        ),
      ],
    ),
  );

  Widget _ownership(ThemeTokens theme) => DocsSection(
    id: 'ownership',
    title: 'Source-first ownership',
    description:
        'The copy-first premise: installing a component writes a file into '
        'your project, not a version pin into your pubspec.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Running `elattar add button` does not add a dependency, it '
          'copies lib/src/components/ui/button.dart, resolves its registry '
          'dependencies transitively (icon, spinner, and the three visual '
          'effects it composes), and writes every one of them into '
          'lib/components/ui/ inside your own project. From that point the '
          'file is yours: read it, change it, delete the parts you do not '
          'need. There is no framework watching for drift back to upstream.',
          theme,
        ),
        SizedBox(height: space(3)),
        _prose(
          'This is the opposite trade from a typical UI package. A package '
          'dependency stays a black box you configure through the '
          'parameters it exposes; a copied component is source you own '
          'outright, at the cost of picking up fixes manually instead of on '
          'a version bump.',
          theme,
        ),
        SizedBox(height: space(3)),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            StyledText('See ', TextStyles.small, color: theme.mutedForeground),
            const DocsLink(
              label: 'Installation',
              route: docsInstallationRoute,
              underline: true,
            ),
            StyledText(' and ', TextStyles.small, color: theme.mutedForeground),
            const DocsLink(
              label: 'Registry',
              route: docsRegistryRoute,
              underline: true,
            ),
            StyledText(
              ' for how the copy and its dependency graph are produced.',
              TextStyles.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
      ],
    ),
  );

  Widget _composition(ThemeTokens theme) => DocsSection(
    id: 'composition',
    title: 'Composition through public El* APIs',
    child: _prose(
      'Every component, effect, and motion primitive is reached through a '
      'public El-prefixed class: Button, Card, Sidebar, Toaster, '
      'and so on, exported from the package barrel '
      '(package:elattar_design_system/elattar_design_system.dart) or, once '
      'copied, from a project-local lib/components/ui/ui.dart barrel the '
      'CLI writes and maintains. Internal implementation detail lives under '
      'a private src/ that application code never imports directly, whether '
      'the foundation is a dependency or a local copy.',
      theme,
    ),
  );

  Widget _distribution(ThemeTokens theme) => DocsSection(
    id: 'distribution',
    title: 'Registry and CLI distribution',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'registry/generated/latest/ is a generated, sha256-verified '
          'manifest of every registry item, 99 today: 84 components, 9 '
          'effects, 5 motion primitives, and 1 foundation bundle. '
          'packages/elattar_cli reads that manifest, resolves an item\'s '
          'transitive registryDependencies, and writes the resulting files, '
          'assets, and font registrations into a consumer project.',
          theme,
        ),
        SizedBox(height: space(3)),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            StyledText('See ', TextStyles.small, color: theme.mutedForeground),
            const DocsLink(label: 'CLI', route: docsCliRoute, underline: true),
            StyledText(' and ', TextStyles.small, color: theme.mutedForeground),
            const DocsLink(
              label: 'Registry',
              route: docsRegistryRoute,
              underline: true,
            ),
            StyledText(
              ' for the full command surface and item schema.',
              TextStyles.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
        SizedBox(height: space(4)),
        Alert(
          variant: AlertVariant.info,
          icon: const Icon(IconGlyph.info),
          title: 'Not published to an external index yet',
          description:
              'See Installation for exactly what that means and what '
              'running them today actually requires.',
        ),
      ],
    ),
  );

  Widget _defaults(ThemeTokens theme) => DocsSection(
    id: 'defaults',
    title: 'Beautiful, coherent defaults',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Every color, spacing, radius, shadow, and motion value a '
          'component paints with resolves from the same semantic token set '
          'rather than a literal chosen per widget. That is enforced, not '
          'merely advised: a token guard scans this documentation app '
          'itself for raw Color(, TextStyle(, or hardcoded layout numbers '
          'and fails the build if it finds one (test/token_guard_test.dart '
          'at the repository root).',
          theme,
        ),
        SizedBox(height: space(3)),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            StyledText('See ', TextStyles.small, color: theme.mutedForeground),
            const DocsLink(
              label: 'Theming',
              route: docsThemingRoute,
              underline: true,
            ),
            StyledText(
              ' for how that token set resolves.',
              TextStyles.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
      ],
    ),
  );

  Widget _platforms(ThemeTokens theme) => DocsSection(
    id: 'platforms',
    title: 'Flutter platform support',
    child: _prose(
      'The package targets Android, iOS, Web, macOS, Windows, and Linux, '
      'the six platforms exercised by this documentation app and its test '
      'suite. Nothing in the foundation or the base component set branches '
      'on platform; where a component does (for example a shader-backed '
      'effect), that is called out on its own page rather than assumed '
      'here.',
      theme,
    ),
  );

  Widget _skill(ThemeTokens theme) => DocsSection(
    id: 'skill',
    title: 'AI-ready skill and open code',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'This repository carries a coding-agent skill that teaches an '
          'agent to discover the public El* surface, resolve values from '
          'tokens instead of inventing them, and cover states and '
          'accessibility before calling a change done. It ships in the '
          'repository itself, no separate install step is needed to use it '
          'against a checkout, and it is mode-aware: it reads elattar.yaml '
          'when present so it can also work against a project that '
          'installed components through the CLI.',
          theme,
        ),
        SizedBox(height: space(3)),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            StyledText('See ', TextStyles.small, color: theme.mutedForeground),
            const DocsLink(label: 'Skills', route: '/skills', underline: true),
            StyledText(
              ' for supported agents and what it reads and provides.',
              TextStyles.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
      ],
    ),
  );

  Widget _modes(ThemeTokens theme) => DocsSection(
    id: 'modes',
    title: 'Package versus CLI ownership',
    description:
        'Three ways to bring the system into a project, and what each one '
        'actually gives you.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'Install modes',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'Package',
              type: 'dependency',
              description:
                  'Add elattar_design_system as a git or path dependency '
                  'and import El* widgets directly. You own no local files; '
                  'every token and widget lives in the dependency. '
                  'Available today, see Installation.',
            ),
            DocsApiFact(
              name: 'Source foundation',
              type: 'elattar init --foundation source',
              description:
                  'Copies the theme, typography, spacing, and motion '
                  'foundation into lib/design_system/foundation/, then '
                  'elattar add <name> copies each component\'s source into '
                  'lib/components/ui/. You own every file the CLI writes. '
                  'Available today, from a repository checkout.',
            ),
            DocsApiFact(
              name: 'Package foundation',
              type: 'elattar init --foundation package',
              description:
                  'Would keep the foundation as a dependency (a package '
                  'named elattar_core) while copying only component source '
                  'locally. Not available: elattar_core does not exist, so '
                  'the CLI refuses this mode with exit code 64 before '
                  'touching the project.',
            ),
          ],
        ),
      ],
    ),
  );
}
