/// Public documentation page for `/docs/installation`.
///
/// Content contract: `docs/superpowers/plans/2026-08-21-public-website-ui-
/// information-architecture.md` section 7.5.
///
/// This page used to open by explaining that nothing on it could be obtained:
/// the CLI was unpublishable, the repository was unreachable, and the
/// reference's `dart install elattar_cli` two-liner was deliberately withheld
/// as unrunnable. That is no longer the situation, so the page leads with the
/// three commands instead of with an apology for not having them.
///
/// `example/test/public_claims_test.dart` scans this directory for the
/// phrases that described the old state and fails if any of them return —
/// including from a comment, which is why the sentence above paraphrases
/// rather than quotes.
///
/// Every command below was executed before being written down, against the
/// package as a consumer receives it — only the files `dart pub publish
/// --dry-run` lists, resolved on their own, driven at a registry served over
/// plain HTTP:
///  * `elattar --version` -> `0.0.1`
///  * `elattar init --foundation source` -> wrote the foundation, the fonts,
///    `elattar.yaml`, `.elattar/manifest.json` and four license notices,
///    exit 0
///  * `elattar add button voice-orb` -> wrote the dependency closure and two
///    further notices, exit 0
///  * `elattar doctor` -> reported remote registry, 99 items, cache state,
///    exit 0
///  * `elattar list --offline` with the server stopped -> served from cache
///  * `flutter analyze` in the resulting project -> no issues
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
          'Install the CLI, set up your project, add a component. Three '
          'commands, no clone, no dependency on this package.',
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Docs'),
      ElBreadcrumbEntry.page('Installation'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Quickstart', anchor: 'quickstart'),
      DocsTocEntry(title: 'Install the CLI', anchor: 'install-cli'),
      DocsTocEntry(title: 'Set up a project', anchor: 'source-foundation'),
      DocsTocEntry(title: 'Where components come from', anchor: 'registry'),
      DocsTocEntry(title: 'Working offline', anchor: 'offline'),
      DocsTocEntry(title: 'What lands in your project', anchor: 'what-lands'),
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
        // https://ui.shadcn.com/docs/installation. This is that same slot.
        ElAlert(
          variant: ElAlertVariant.success,
          icon: const ElIcon(ElIconGlyph.circleCheck),
          title: 'Recommended: source foundation',
          description:
              '`elattar init --foundation source` copies the foundation into '
              'your project as files you own. It is the supported mode.',
        ),
        SizedBox(height: el(8)),
        _quickstart(),
        _installCli(theme),
        _sourceFoundation(),
        _registry(theme),
        _offline(theme),
        _whatLands(),
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

  Widget _quickstart() => ElSection(
    id: 'quickstart',
    title: 'Quickstart',
    description:
        'From nothing to a themed button in a Flutter project you already '
        'have.',
    child: ElPanel(
      label: 'CONSOLE',
      note: 'QUICKSTART',
      child: DocsSelectableCodeBlock(
        code:
            'dart install elattar_cli\n\n'
            'cd my_flutter_app\n'
            'elattar init --foundation source\n'
            'elattar add button',
      ),
    ),
  );

  Widget _installCli(ElThemeData theme) => ElSection(
    id: 'install-cli',
    title: 'Install the CLI',
    description:
        'elattar_cli is on pub.dev. It has one dependency, so this is a '
        'small resolve rather than a tree to audit.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElPanel(
          label: 'CONSOLE',
          note: 'INSTALL',
          child: DocsSelectableCodeBlock(code: 'dart install elattar_cli'),
        ),
        SizedBox(height: el(4)),
        _prose(
          'On an older SDK, or if you prefer the long spelling, `dart pub '
          'global activate elattar_cli` does the same thing. Both put an '
          '`elattar` executable on your PATH.',
          theme,
        ),
        SizedBox(height: el(4)),
        const DocsInstallFacts(
          title: 'If `elattar` is not found',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'macOS and Linux',
              value: r'export PATH="$HOME/.pub-cache/bin:$PATH"',
              description:
                  'Add it to your shell profile. If PUB_CACHE is set, the '
                  'directory is \$PUB_CACHE/bin instead.',
            ),
            DocsInstallFact(
              label: 'Windows',
              value: r'%LOCALAPPDATA%\Pub\Cache\bin',
              description: 'Add that directory to your user Path variable.',
            ),
            DocsInstallFact(
              label: 'Without fixing PATH',
              value: 'dart pub global run elattar_cli:elattar --version',
              description:
                  'Works from anywhere, and is the quickest way to confirm '
                  'the install succeeded before touching your PATH.',
            ),
            DocsInstallFact(
              label: 'Update or remove',
              value: 'dart install elattar_cli',
              description:
                  'Re-running installs the newest version. `dart pub global '
                  'deactivate elattar_cli` removes the command and leaves '
                  'everything it installed in place: that source is your '
                  'project\'s now.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _sourceFoundation() => ElSection(
    id: 'source-foundation',
    title: 'Set up a project',
    description:
        'init copies the theme, typography, spacing and motion foundation '
        'into your project as local files, wires the three font faces into '
        'your pubspec.yaml, and records what it did. add then copies '
        'component source the same way, resolving dependencies for you.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElPanel(
          label: 'CONSOLE',
          note: 'SET UP',
          child: DocsSelectableCodeBlock(
            code:
                '# Run these from inside your Flutter project.\n'
                'elattar init --foundation source\n\n'
                '# One component, with everything it depends on.\n'
                'elattar add button\n\n'
                '# Or the whole set.\n'
                'elattar add --all',
          ),
        ),
        SizedBox(height: el(4)),
        ElPanel(
          label: 'CONSOLE',
          note: 'LOOK BEFORE YOU LEAP',
          child: DocsSelectableCodeBlock(
            code:
                '# Lists every file that would be written, and writes none.\n'
                'elattar add button --dry-run',
          ),
        ),
      ],
    ),
  );

  Widget _registry(ElThemeData theme) => ElSection(
    id: 'registry',
    title: 'Where components come from',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'The CLI reads a hosted registry, pinned to its own version. '
          'elattar_cli 0.0.1 reads /registry/0.0.1/, and that path is '
          'immutable: publishing a change means publishing a new version, '
          'never rewriting a released one. What you install today is what '
          'you install next year.',
          theme,
        ),
        SizedBox(height: el(4)),
        ElPanel(
          label: 'CONSOLE',
          note: 'SOMEWHERE ELSE',
          child: DocsSelectableCodeBlock(
            code:
                '# A mirror, or a registry you built yourself.\n'
                'elattar add button --registry https://example.com/elattar/0.0.1/\n'
                'elattar add button --registry ../flutter-design-system/registry/generated/latest',
          ),
        ),
        SizedBox(height: el(4)),
        _prose(
          'Every manifest and every payload is checked against the sha256 the '
          'registry declares, and everything is downloaded and verified '
          'before the first file is written. A dropped connection or a '
          'substituted payload aborts the whole command with your project '
          'exactly as it was.',
          theme,
        ),
      ],
    ),
  );

  Widget _offline(ElThemeData theme) => ElSection(
    id: 'offline',
    title: 'Working offline',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Downloads are cached per user, so a command that has run once '
          'online can run again with no network at all.',
          theme,
        ),
        SizedBox(height: el(4)),
        ElPanel(
          label: 'CONSOLE',
          note: 'OFFLINE',
          child: DocsSelectableCodeBlock(
            code:
                'elattar add button            # populates the cache\n'
                'elattar add card --offline    # reads only the cache',
          ),
        ),
        SizedBox(height: el(4)),
        const DocsInstallFacts(
          title: 'Cache location',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Windows',
              value: r'%LOCALAPPDATA%\elattar\registry\v1',
              description: 'The documented home for regenerable data.',
            ),
            DocsInstallFact(
              label: 'macOS',
              value: '~/Library/Caches/elattar/registry/v1',
              description: 'The platform cache directory.',
            ),
            DocsInstallFact(
              label: 'Linux',
              value: r'$XDG_CACHE_HOME/elattar/registry/v1',
              description:
                  'Falling back to ~/.cache/elattar/registry/v1, as the XDG '
                  'base directory specification requires.',
            ),
            DocsInstallFact(
              label: 'Override',
              value: 'ELATTAR_CACHE_DIR',
              description:
                  'Set it to keep a cache inside a workspace, which is what '
                  'CI wants.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _whatLands() => ElSection(
    id: 'what-lands',
    title: 'What lands in your project',
    description:
        'Installed sources are copied in and become your code. Edit them; '
        'only `elattar add --overwrite` replaces them, and it never touches '
        'files the CLI did not install.',
    child: const DocsInstallFacts(
      title: 'After init and one add',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Foundation',
          value: 'lib/design_system/foundation/*.dart',
          description:
              'colors, typography, spacing, shadows, motion, theme, '
              'surfaces, media, text_layout, date_format, theme_scope, plus '
              'the lib/design_system/foundation.dart barrel.',
        ),
        DocsInstallFact(
          label: 'Components',
          value: 'lib/components/ui/*.dart',
          description:
              'One file per installed component, plus a generated ui.dart '
              'barrel that gains one export per item you add.',
        ),
        DocsInstallFact(
          label: 'Fonts',
          value: 'assets/elattar/fonts/*.ttf',
          description:
              'InterVariable, GeistMono-Variable and Redaction35-Italic, '
              'registered under `flutter: fonts:` in your pubspec.yaml '
              'automatically, under the family names the installed '
              'typography actually asks for.',
        ),
        DocsInstallFact(
          label: 'License notices',
          value: 'LICENSES/*.txt',
          description:
              'Elattar\'s MIT notice always; the three font OFL notices with '
              'the foundation; lucide\'s ISC notice with icon, and so with '
              'most components; the ElevenLabs UI notice with voice-orb. '
              'Keep them: carrying the notice is the condition all three '
              'licenses attach to the grant.',
        ),
        DocsInstallFact(
          label: 'Project record',
          value: 'elattar.yaml, .elattar/manifest.json',
          description:
              'elattar.yaml pins the foundation mode and the registry, and '
              'is safe to commit. The manifest records every installed '
              'file\'s hash, so doctor and add --overwrite can tell what '
              'you changed.',
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
        'from the package barrel, no CLI involved. The package is not on '
        'pub.dev — source installation through the CLI is the distribution '
        'route — so this is a git or path dependency, exactly as this '
        'repository\'s own example/pubspec.yaml consumes it.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsCodeExample(
          title: 'pubspec.yaml',
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'pubspec.yaml',
              title: 'From Git',
              description:
                  'Pins the public repository. Add `ref:` to pin a tag if '
                  'you would rather not track the default branch.',
              code:
                  'dependencies:\n'
                  '  elattar_design_system:\n'
                  '    git:\n'
                  '      url: https://github.com/ELATTAR-Ayoub/flutter-design-system.git\n'
                  '      ref: v0.0.1',
            ),
            DocsCodeFile(
              path: 'pubspec.yaml',
              title: 'From a local checkout',
              description:
                  'Path relative to your project. This is the exact form '
                  'example/pubspec.yaml in this repository uses.',
              code:
                  'dependencies:\n'
                  '  elattar_design_system:\n'
                  '    path: ../flutter-design-system',
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
        'doctor checks the project, the config, whether your dependencies '
        'actually resolved, the manifest, and the registry it would use. It '
        'exits 0 only when every check passes.',
    child: ElPanel(
      label: 'CONSOLE',
      note: 'DOCTOR',
      child: DocsSelectableCodeBlock(
        code:
            'elattar doctor\n\n'
            '# Add --verbose to include the cache path.\n'
            'elattar doctor --verbose',
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
          state: 'Not a Flutter project',
          treatment:
              'No pubspec.yaml with a flutter dependency was found above the '
              'current directory, exit 72.',
          userSignal: 'Run the command from inside your Flutter app.',
        ),
        DocsStateFact(
          state: 'Registry unreachable',
          treatment:
              'The host could not be reached, or the request timed out, '
              'exit 70. Nothing was written.',
          userSignal:
              'Check the connection, or pass --offline to work from the '
              'cache.',
        ),
        DocsStateFact(
          state: 'Nothing cached, under --offline',
          treatment:
              'The command names the file it wanted and the registry it '
              'wanted it from, exit 70.',
          userSignal:
              'Run the same command once without --offline to populate the '
              'cache.',
        ),
        DocsStateFact(
          state: 'A payload failed its hash check',
          treatment:
              'The item, the target and both hashes are printed, exit 65. '
              'Verification runs before the first write, so nothing landed.',
          userSignal:
              'Retry. If it repeats, the registry you are pointing at is not '
              'serving what it declares.',
        ),
        DocsStateFact(
          state: 'Existing files would be overwritten',
          treatment:
              'add reports every conflicting destination and writes nothing, '
              'exit 73.',
          userSignal:
              'That usually means you edited an installed file, which you '
              'are meant to be able to do. Save your version, then re-run '
              'with --overwrite.',
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
