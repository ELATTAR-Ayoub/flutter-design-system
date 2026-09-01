/// Public documentation page for `/docs/introduction`.
///
/// One job: a Flutter developer arrives not knowing what this is, and leaves
/// knowing the one thing that makes it different, which is that the source
/// lands in their project, with the three commands that prove it. Everything
/// else on the page is a short follow-up, or a link to the page that owns the
/// detail.
///
/// Two claims here are not verifiable by running a command, so both are read
/// from their owner rather than restated:
///
///  * The refusal of `--foundation package` is
///    `packages/elattar_cli/lib/src/commands/app.dart`'s
///    `packageModeUnavailable` constant (`elattar_core` does not exist),
///    paraphrased to its user-visible effect.
///  * Registry figures are not written down here at all. Registry reads them
///    out of the generated manifest; this page links to it.
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
import '../docs/docs_snippet.dart';
import 'catalog.dart';
import 'release_facts.dart';

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
          'A Flutter design system you install as source you own, not as a '
          'dependency you track.',
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Docs'),
      BreadcrumbEntry.page('Introduction'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'What this is', anchor: 'overview'),
      DocsTocEntry(title: 'Start here', anchor: 'start'),
      DocsTocEntry(title: 'Source-first ownership', anchor: 'ownership'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Registry and CLI', anchor: 'distribution'),
      DocsTocEntry(title: 'Defaults', anchor: 'defaults'),
      DocsTocEntry(title: 'Platform support', anchor: 'platforms'),
      DocsTocEntry(title: 'Agent skill', anchor: 'skill'),
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
        _start(theme),
        _ownership(theme),
        _composition(theme),
        _distribution(theme),
        _defaults(theme),
        _platforms(theme),
        _skill(theme),
        _modes(),
      ],
    );
  }

  Widget _prose(String text, {TextStyleToken? spec}) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: StyledText(text, spec ?? TextStyles.body),
  );

  /// A short "see X" line. One shape, so a reader learns to skip it.
  Widget _see(
    ThemeTokens theme,
    String lead,
    List<(String, String)> links,
    String tail,
  ) => Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      StyledText(lead, TextStyles.small, color: theme.mutedForeground),
      for (int i = 0; i < links.length; i++) ...<Widget>[
        if (i > 0)
          StyledText(
            i == links.length - 1 ? ' and ' : ', ',
            TextStyles.small,
            color: theme.mutedForeground,
          ),
        DocsLink(label: links[i].$1, route: links[i].$2, underline: true),
      ],
      StyledText(tail, TextStyles.small, color: theme.mutedForeground),
    ],
  );

  Widget _overview(ThemeTokens theme) => DocsSection(
    id: 'overview',
    title: 'What this is',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Elattar is a Flutter design system: semantic foundation tokens '
          'for colour, type, spacing, radii, shadows and motion, and a '
          'component set built on them. A command-line installer copies that '
          'code into your project, so a component you add is a file you own '
          'rather than an API you configure.',
        ),
        SizedBox(height: space(3)),
        _prose(
          'It is for Flutter developers building a real product interface, '
          'and for the coding agents working alongside them. If you want a '
          'dependency you upgrade rather than source you edit, that is '
          'supported too: see Install modes at the end of this page.',
          spec: TextStyles.small,
        ),
      ],
    ),
  );

  Widget _start(ThemeTokens theme) => DocsSection(
    id: 'start',
    title: 'Start here',
    description:
        'Install the command, set the project up, add a component. From '
        'inside a Flutter project you already have.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsSnippet(
          language: 'bash',
          code:
              '${releaseFacts.installCommand}\n\n'
              'elattar init --foundation source\n'
              'elattar add button',
        ),
        SizedBox(height: space(4)),
        _see(
          theme,
          'See ',
          <(String, String)>[('Installation', docsInstallationRoute)],
          ' for the same three steps, plus PATH recovery, offline use, and '
              'what to do when a command refuses.',
        ),
      ],
    ),
  );

  Widget _ownership(ThemeTokens theme) => DocsSection(
    id: 'ownership',
    title: 'Source-first ownership',
    description:
        'Installing a component writes files into your project, not a '
        'version pin into your pubspec.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'elattar add button resolves what button needs, which is the '
          'icon, the spinner and the surfaces it paints on, and writes all '
          'of them into lib/components/ui/ inside your project. From that point the files '
          'are yours: read them, change them, delete the parts you do not '
          'need. Nothing watches for drift back to upstream, and nothing '
          'rewrites them unless you run add --overwrite.',
        ),
        SizedBox(height: space(3)),
        _prose(
          'That is the opposite trade from a typical UI package. A dependency '
          'stays a black box you configure through the parameters it exposes; '
          'copied source is yours outright, at the cost of picking up fixes '
          'by hand instead of on a version bump.',
          spec: TextStyles.small,
        ),
      ],
    ),
  );

  Widget _composition(ThemeTokens theme) => DocsSection(
    id: 'composition',
    title: 'Composition',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'The public names are ordinary nouns: Button, Card, Icon, '
          'TextStyles, space. You compose screens out of them and never '
          'reach past them into implementation detail, which stays private '
          'whether the foundation is a dependency or a local copy.',
        ),
        SizedBox(height: space(4)),
        const DocsSnippet(
          language: 'dart',
          code:
              "Button(\n"
              "  onPressed: onSave,\n"
              "  child: const StyledText('Save changes', TextStyles.small),\n"
              ")",
        ),
        SizedBox(height: space(4)),
        _see(
          theme,
          'See ',
          <(String, String)>[
            ('Theming', docsThemingRoute),
            ('Typeset', docsTypesetRoute),
          ],
          ' for where colour and type come from. Neither is ever written as '
              'a literal.',
        ),
      ],
    ),
  );

  Widget _distribution(ThemeTokens theme) => DocsSection(
    id: 'distribution',
    title: 'Registry and CLI',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'The installer reads a hosted registry pinned to its own version. '
          'Every file it distributes carries a sha256, and the whole install '
          'is downloaded and verified before the first byte is written, so a '
          'failed download leaves your project untouched rather than '
          'half-installed.',
        ),
        SizedBox(height: space(4)),
        _see(
          theme,
          'See ',
          <(String, String)>[
            ('CLI', docsCliRoute),
            ('Registry', docsRegistryRoute),
          ],
          ' for the command surface, the item schema, and what the published '
              'registry currently contains.',
        ),
      ],
    ),
  );

  Widget _defaults(ThemeTokens theme) => DocsSection(
    id: 'defaults',
    title: 'Coherent defaults',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Every colour, spacing, radius, shadow and motion value a component '
          'paints with resolves from the same semantic token set rather than '
          'a literal chosen per widget. That is enforced rather than advised: '
          'a guard scans this documentation app itself and fails the build on '
          'a raw colour, text style or layout number.',
        ),
        SizedBox(height: space(4)),
        _see(theme, 'See ', <(String, String)>[
          ('Theming', docsThemingRoute),
        ], ' for how that token set resolves.'),
      ],
    ),
  );

  Widget _platforms(ThemeTokens theme) => DocsSection(
    id: 'platforms',
    title: 'Platform support',
    child: _prose(
      'Android, iOS, web, macOS, Windows and Linux. Nothing in the '
      'foundation or the base component set branches on platform. Where a '
      'component does, as a shader-backed effect might, its own page says '
      'so.',
    ),
  );

  Widget _skill(ThemeTokens theme) => DocsSection(
    id: 'skill',
    title: 'Agent skill',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'A coding-agent skill ships in the repository. It teaches an agent '
          'to inventory the real public API before inventing a widget, take '
          'every value from a token, and cover states and accessibility '
          'before calling a change done. It is mode-aware: it reads '
          'elattar.yaml when present, so it works against a project that '
          'installed components as well as against a checkout.',
        ),
        SizedBox(height: space(4)),
        _see(theme, 'See ', <(String, String)>[
          ('Skills', '/skills'),
        ], ' for the supported agent and each install route.'),
      ],
    ),
  );

  Widget _modes() => DocsSection(
    id: 'modes',
    title: 'Install modes',
    description:
        'Three ways to bring the system into a project, and what each gives '
        'you.',
    child: const DocsApiTable(
      title: 'Install modes',
      facts: <DocsApiFact>[
        DocsApiFact(
          name: 'Source foundation',
          type: 'elattar init --foundation source',
          description:
              'Copies the theme, typography, spacing and motion foundation '
              'into lib/design_system/foundation/; elattar add <name> then '
              'copies each component into lib/components/ui/. You own every '
              'file. This is the supported path.',
        ),
        DocsApiFact(
          name: 'Package dependency',
          type: 'git or path dependency',
          description:
              'Depend on elattar_design_system and import the same public '
              'names from its barrel, with no CLI involved. You own no local '
              'files, and the package itself is unpublished: see '
              'Installation.',
        ),
        DocsApiFact(
          name: 'Package foundation',
          type: 'elattar init --foundation package',
          description:
              'Would keep the foundation as a dependency while copying only '
              'component source. Not available: the package it depends on '
              'does not exist, so the command refuses before touching your '
              'project.',
        ),
      ],
    ),
  );
}
