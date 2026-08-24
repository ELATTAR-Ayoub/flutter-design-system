/// Public documentation page for `/docs/installation`.
///
/// Content contract: `docs/superpowers/plans/2026-08-21-public-website-ui-
/// information-architecture.md` section 7.5, overridden on one point by the
/// public-release brief for this page: the reference's `dart install
/// elattar_cli` / `elattar init` two-liner is not printed here, because it is
/// not runnable. The CLI is not published anywhere a reader can `dart pub
/// global activate` it from. `README.md`'s own "Install Today" and "CLI And
/// Registry (In This Repository, Not Published)" sections already state this;
/// this page transcribes the same facts into the docs shell rather than
/// inventing a second story.
///
/// Every command on this page was run against this checkout before being
/// written down:
///  * `dart run packages/elattar_cli/bin/elattar.dart --version` -> `0.0.1`
///  * `dart run packages/elattar_cli/bin/elattar.dart init --foundation
///    source --yes --registry REGISTRY_PATH` -> wrote the foundation files,
///    exit 0
///  * `dart run packages/elattar_cli/bin/elattar.dart add button --registry
///    REGISTRY_PATH` -> wrote the component dependency closure, updated
///    lib/components/ui/ui.dart and
///    pubspec.yaml's `flutter: fonts:` block, exit 0
///  * `dart run packages/elattar_cli/bin/elattar.dart doctor` outside a
///    Flutter project -> two `err` lines, exit 1
///  * `dart pub get -C packages/elattar_cli` -> resolves cleanly
/// Nothing below states a command that was not exercised this way.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../docs/docs_code.dart';
import '../docs/docs_facts.dart';
import '../docs/docs_layout.dart';
import '../kit.dart';
import 'catalog.dart';

class InstallationDocsPage extends StatelessWidget {
  const InstallationDocsPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: docsInstallationRoute,
    intro: const DocsPageIntro(
      eyebrow: 'DOCS',
      title: 'Installation',
      description:
          'Real, working steps only. The CLI and the full package are not '
          'published outside this repository yet. This page says so '
          'plainly and shows what a checkout can actually run today.',
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Docs'),
      ElBreadcrumbEntry.page('Installation'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'What is available today', anchor: 'overview'),
      DocsTocEntry(title: 'Clone the repository', anchor: 'clone'),
      DocsTocEntry(
        title: 'Source foundation (recommended)',
        anchor: 'source-foundation',
      ),
      DocsTocEntry(title: 'Package foundation', anchor: 'package-foundation'),
      DocsTocEntry(title: 'Full maintained package', anchor: 'full-package'),
      DocsTocEntry(title: 'Verification', anchor: 'verification'),
      DocsTocEntry(title: 'Troubleshooting', anchor: 'troubleshooting'),
    ],
    previous: const DocsPageLink(title: 'Components', route: '/components'),
    next: const DocsPageLink(title: 'Theming', route: docsThemingRoute),
    onNavigate: onNavigate,
    child: const _InstallationArticle(),
  );
}

class _InstallationArticle extends StatelessWidget {
  const _InstallationArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('installation-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // The reference's own "Recommended for new projects" callout sits
        // directly under the intro paragraph, before its first heading. See
        // https://ui.shadcn.com/docs/installation. This is that same slot:
        // the one setup path the CLI actually accepts today, stated up front
        // rather than left for the reader to discover three sections down at
        // Source foundation.
        ElAlert(
          variant: ElAlertVariant.success,
          icon: const ElIcon(ElIconGlyph.circleCheck),
          title: 'Recommended: source foundation',
          description:
              '`elattar init --foundation source` is the only foundation '
              'mode the CLI currently accepts. See Source foundation below.',
        ),
        SizedBox(height: el(8)),
        _overview(theme),
        _clone(),
        _sourceFoundation(),
        _packageFoundation(theme),
        _fullPackage(),
        _verification(),
        _troubleshooting(theme),
      ],
    );
  }

  Widget _prose(String text, ElThemeData theme, {ElTypeSpec? spec}) =>
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText(text, spec ?? ElType.body),
      );

  Widget _overview(ElThemeData theme) => ElSection(
    id: 'overview',
    title: 'What is available today',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Neither packages/elattar_cli nor the elattar_design_system '
          'package is published: the CLI\'s pubspec sets `publish_to: '
          'none`, the package pubspec sets `publish_to: \'none\'`, and there '
          'is no pub.dev listing for either. There is currently no `dart '
          'pub global activate elattar_cli` or `dart pub add '
          'elattar_design_system` a reader outside this repository can run, '
          'so this page does not print one.',
          theme,
        ),
        SizedBox(height: el(3)),
        _prose(
          'What does work, verified against this checkout, is running '
          'everything from source: clone the repository, then either copy '
          'the foundation and components with the CLI, or depend on the '
          'package directly with a git or path dependency. Both are covered '
          'below.',
          theme,
        ),
      ],
    ),
  );

  Widget _clone() => ElSection(
    id: 'clone',
    title: 'Clone the repository',
    description: 'The one prerequisite every path below shares.',
    child: ElPanel(
      label: 'CONSOLE',
      note: 'CLONE',
      child: DocsSelectableCodeBlock(
        code:
            'git clone https://github.com/ELATTAR-Ayoub/flutter-design-system.git\n'
            'cd flutter-design-system',
      ),
    ),
  );

  Widget _sourceFoundation() => ElSection(
    id: 'source-foundation',
    title: 'Source foundation (recommended)',
    description:
        'elattar init --foundation source copies the theme, typography, '
        'spacing, and motion foundation into your project as local files; '
        'elattar add <name> then copies component source the same way. '
        'This is the only foundation mode the CLI currently accepts.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElPanel(
          label: 'CONSOLE',
          note: 'FROM A CHECKOUT',
          child: DocsSelectableCodeBlock(
            code:
                '# Get the CLI\'s own dependencies once.\n'
                'dart pub get -C packages/elattar_cli\n\n'
                '# Run it against your Flutter project. Pass --registry the\n'
                '# path to this checkout\'s registry/generated/latest.\n'
                'dart run packages/elattar_cli/bin/elattar.dart init \\\n'
                '  --foundation source \\\n'
                '  --registry registry/generated/latest\n\n'
                'dart run packages/elattar_cli/bin/elattar.dart add button \\\n'
                '  --registry registry/generated/latest',
          ),
        ),
        SizedBox(height: el(4)),
        ElPanel(
          label: 'CONSOLE',
          note: 'ACTIVATED LOCALLY',
          child: DocsSelectableCodeBlock(
            code:
                '# Activates the executable so the bare `elattar` form works,\n'
                '# the same way packages/elattar_cli/test exercises it.\n'
                'dart pub global activate --source path packages/elattar_cli\n\n'
                'elattar init --foundation source\n'
                'elattar add button',
          ),
        ),
        SizedBox(height: el(4)),
        const DocsInstallFacts(
          title: 'What init writes',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Foundation files',
              value: 'lib/design_system/foundation/*.dart',
              description:
                  'colors, typography, spacing, shadows, motion, theme, '
                  'surfaces, media, text_layout, date_format, theme_scope, '
                  'plus the lib/design_system/foundation.dart barrel.',
            ),
            DocsInstallFact(
              label: 'Fonts',
              value: 'assets/elattar/fonts/*.ttf',
              description:
                  'InterVariable, GeistMono-Variable, Redaction35-Italic, '
                  'and elattar add registers them under `flutter: fonts:` in '
                  'your pubspec.yaml automatically.',
            ),
            DocsInstallFact(
              label: 'Component barrel',
              value: 'lib/components/ui/ui.dart',
              description:
                  'Starts empty; elattar add appends one export per '
                  'installed component, in the order items are added.',
            ),
            DocsInstallFact(
              label: 'Project record',
              value: 'elattar.yaml, .elattar/manifest.json',
              description:
                  'elattar.yaml pins the chosen foundation mode; the '
                  'manifest records every installed file\'s hash so a later '
                  'elattar doctor or add --overwrite can tell what changed.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _packageFoundation(ElThemeData theme) => ElSection(
    id: 'package-foundation',
    title: 'Package foundation',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ElAlert(
          variant: ElAlertVariant.destructive,
          icon: const ElIcon(ElIconGlyph.circleX),
          title: 'Not available',
          description:
              '`elattar init --foundation package` is refused before it '
              'touches the project, with exit code 64.',
        ),
        SizedBox(height: el(4)),
        _prose(
          'This is the exact message packages/elattar_cli/lib/src/commands/'
          'app.dart returns:',
          theme,
        ),
        SizedBox(height: el(3)),
        ElPanel(
          label: 'CONSOLE',
          note: 'EXIT 64',
          child: DocsSelectableCodeBlock(
            code:
                '\$ elattar init --foundation package\n'
                'The `package` foundation mode is not available in elattar '
                '0.0.1: it depends on a package named `elattar_core` that '
                'does not exist yet, so `flutter pub get` cannot resolve the '
                'project it produces. Use `--foundation source`, which '
                'copies the foundation into your project.',
          ),
        ),
        SizedBox(height: el(3)),
        _prose(
          'An earlier build of this CLI did write that broken project; it '
          'was reverted for this reason and this mode is refused up front '
          'now rather than left undocumented.',
          theme,
          spec: ElType.small,
        ),
      ],
    ),
  );

  Widget _fullPackage() => ElSection(
    id: 'full-package',
    title: 'Full maintained package',
    description:
        'Depend on elattar_design_system directly and import El* widgets '
        'from the package barrel, no CLI involved. Also not on pub.dev '
        'yet, so this is a git or path dependency, exactly as this '
        'repository\'s own example/pubspec.yaml consumes it.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsCodeExample(
          title: 'pubspec.yaml',
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'pubspec.yaml',
              title: 'From a local checkout',
              description:
                  'Works today, path relative to your project. This is the '
                  'exact form example/pubspec.yaml in this repository uses.',
              code:
                  'dependencies:\n'
                  '  elattar_design_system:\n'
                  '    path: ../flutter-design-system',
            ),
            DocsCodeFile(
              path: 'pubspec.yaml',
              title: 'From Git',
              description:
                  'Requires the repository to be reachable at that URL, see '
                  'the overview above for the current publication state.',
              code:
                  'dependencies:\n'
                  '  elattar_design_system:\n'
                  '    git:\n'
                  '      url: https://github.com/ELATTAR-Ayoub/flutter-design-system.git',
            ),
          ],
        ),
        SizedBox(height: el(4)),
        ElPanel(
          label: 'CONSOLE',
          note: 'RESOLVE',
          child: DocsSelectableCodeBlock(code: 'flutter pub get'),
        ),
      ],
    ),
  );

  Widget _verification() => ElSection(
    id: 'verification',
    title: 'Verification',
    description:
        'elattar doctor checks the project, the config, the manifest, and '
        'the registry it can see, and exits 0 only when every check passes.',
    child: ElPanel(
      label: 'CONSOLE',
      note: 'DOCTOR',
      child: DocsSelectableCodeBlock(
        code:
            'dart run packages/elattar_cli/bin/elattar.dart doctor \\\n'
            '  --registry registry/generated/latest',
      ),
    ),
  );

  Widget _troubleshooting(ElThemeData theme) => ElSection(
    id: 'troubleshooting',
    title: 'Troubleshooting',
    child: const DocsStateMatrix(
      title: 'Common failures',
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Missing elattar.yaml',
          treatment:
              'add and doctor both refuse with "Missing elattar.yaml. Run '
              '`elattar init` first.", exit 78.',
          userSignal: 'Run init before add in a new project.',
        ),
        DocsStateFact(
          state: 'Missing registry',
          treatment:
              'Every command that reads the registry throws "Could not find '
              'registry/generated/latest. Pass --registry PATH." when it '
              'cannot find one by walking up from the current directory, '
              'exit 64.',
          userSignal:
              'Pass --registry pointing at this checkout\'s '
              'registry/generated/latest.',
        ),
        DocsStateFact(
          state: 'Not a Flutter project',
          treatment:
              'discoverFlutterProject() throws when no pubspec.yaml with a '
              'flutter dependency is found above the current directory, '
              'exit 72.',
          userSignal: 'Run the command from inside your Flutter app.',
        ),
        DocsStateFact(
          state: 'Existing files would be overwritten',
          treatment:
              'add reports every conflicting destination and writes '
              'nothing, exit 73.',
          userSignal: 'Re-run with --overwrite once you have reviewed them.',
        ),
        DocsStateFact(
          state: 'foundation: package in elattar.yaml',
          treatment:
              'add refuses with the same packageModeUnavailable message as '
              'init, exit 78.',
          userSignal:
              'Edit elattar.yaml to `foundation: source` and re-run init.',
        ),
      ],
    ),
  );
}
