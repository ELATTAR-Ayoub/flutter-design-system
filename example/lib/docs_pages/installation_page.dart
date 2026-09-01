/// Public documentation page for `/docs/installation`.
///
/// One job: a reader with a Flutter project ends up with a themed component
/// in it. Everything on the page serves that, and anything that explains the
/// machinery rather than the action links to the page that owns it.
///
/// **Which command this page leads with is not decided here.** It comes from
/// `release_facts.dart`, whose `cliOnPubDev` says whether `elattar_cli`
/// resolves on pub.dev for a reader of this build, and whose guard fails if
/// the pages and that answer disagree. The 0.0.2 release publishes the CLI
/// before it deploys the site, so the published spelling leads and the
/// from-source spelling stays documented beneath it.
///
/// Both routes were driven end to end against the hosted registry, with
/// nothing local in the picture, before being written down:
///
///  * install the CLI -> `Installed elattar_cli 0.0.2`
///  * `elattar --version` -> `0.0.2`
///  * `elattar init --foundation source` -> foundation, fonts, `elattar.yaml`,
///    `.elattar/manifest.json` and four license notices, exit 0
///  * `elattar add button` -> seven items and a fifth notice, exit 0
///  * `elattar doctor` -> remote registry, 99 items, schema v1, cache warm
///
/// `example/test/public_claims_test.dart` scans this directory for phrases
/// that describe a state the product has left, which is why the note above
/// paraphrases rather than quotes them.
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

import '../docs/docs_code.dart';
import '../docs/docs_disclosure.dart';
import '../docs/docs_facts.dart';
import '../docs/docs_layout.dart';
import '../docs/docs_section.dart';
import '../docs/docs_snippet.dart';
import 'catalog.dart';
import 'release_facts.dart';

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
          'Install the command, set your project up, add a component. Three '
          'steps, no clone, no dependency on this package.',
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Docs'),
      BreadcrumbEntry.page('Installation'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Quickstart', anchor: 'quickstart'),
      DocsTocEntry(title: 'Install the CLI', anchor: 'install-cli'),
      DocsTocEntry(title: 'Set up a project', anchor: 'source-foundation'),
      DocsTocEntry(title: 'Where components come from', anchor: 'registry'),
      DocsTocEntry(title: 'Working offline', anchor: 'offline'),
      DocsTocEntry(title: 'What lands in your project', anchor: 'what-lands'),
      DocsTocEntry(title: 'Verify it worked', anchor: 'verification'),
      DocsTocEntry(title: 'When a command refuses', anchor: 'troubleshooting'),
      DocsTocEntry(title: 'Package foundation', anchor: 'package-foundation'),
      DocsTocEntry(title: 'Full maintained package', anchor: 'full-package'),
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
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      key: const ValueKey<String>('installation-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Alert(
          variant: AlertVariant.success,
          icon: Icon(IconGlyph.circleCheck),
          title: 'Recommended: source foundation',
          description:
              '`elattar init --foundation source` copies the foundation into '
              'your project as files you own. It is the supported mode.',
        ),
        SizedBox(height: space(8)),
        _quickstart(),
        _installCli(theme),
        _sourceFoundation(),
        _registry(theme),
        _offline(theme),
        _whatLands(),
        _verification(theme),
        _troubleshooting(),
        _packageFoundation(theme),
        _fullPackage(),
      ],
    );
  }

  Widget _prose(String text, {TextStyleToken? spec}) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: StyledText(text, spec ?? TextStyles.body),
  );

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

  Widget _quickstart() => DocsSection(
    id: 'quickstart',
    title: 'Quickstart',
    description:
        'From nothing to a themed button, in a Flutter project you already '
        'have. Run the last two from inside it.',
    child: DocsSnippet(
      language: 'bash',
      code:
          '${releaseFacts.installCommand}\n\n'
          'elattar init --foundation source\n'
          'elattar add button',
    ),
  );

  Widget _installCli(ThemeTokens theme) => DocsSection(
    id: 'install-cli',
    title: 'Install the CLI',
    description:
        'This installs the `elattar` executable. If Dart says its install '
        'directory is not on PATH, add the directory it prints.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsSnippet(language: 'bash', code: releaseFacts.installCommand),
        SizedBox(height: space(4)),
        _prose(
          'On an older SDK, or if you prefer the long spelling, '
          '`dart pub global activate elattar_cli` does the same thing.',
          spec: TextStyles.small,
        ),
        SizedBox(height: space(4)),
        DocsDisclosure(
          title: 'Install from source instead',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _prose(
                'Compiles the CLI from the public repository, with no clone '
                'and no checkout. This is what a contributor uses, and what '
                'to reach for when you want the default branch rather than '
                'the released version.',
                spec: TextStyles.small,
              ),
              SizedBox(height: space(4)),
              const DocsSnippet(language: 'bash', code: gitInstallCommand),
            ],
          ),
        ),
        SizedBox(height: space(4)),
        const DocsInstallFacts(
          title: 'If `elattar` is not found',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Recommended install',
              value: r'$DART_DATA_HOME/install/bin',
              description:
                  'Add the directory printed by dart install to PATH. This '
                  'is separate from pub\'s legacy global cache.',
            ),
            DocsInstallFact(
              label: 'Windows',
              value: r'%LOCALAPPDATA%\Dart\install\bin',
              description:
                  'Add it to your user Path, then open a new terminal. An '
                  'already-open terminal keeps its old environment.',
            ),
            DocsInstallFact(
              label: 'Verify directly on Windows',
              value:
                  r'& "$env:LOCALAPPDATA\Dart\install\bin\elattar.bat" --version',
              description:
                  'Runs the launcher before PATH is fixed. It should print '
                  '0.0.2.',
            ),
            DocsInstallFact(
              label: 'Legacy activation',
              value: r'$PUB_CACHE/bin',
              description:
                  'Only dart pub global activate uses this directory; its '
                  r'Windows default is %LOCALAPPDATA%\Pub\Cache\bin.',
            ),
            DocsInstallFact(
              label: 'Remove',
              value: 'dart uninstall elattar_cli',
              description:
                  'Re-running the install command takes the newest version; '
                  'uninstalling removes the command and leaves everything it '
                  'installed in place. That source is your project\'s now.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _sourceFoundation() => DocsSection(
    id: 'source-foundation',
    title: 'Set up a project',
    description:
        'init copies the foundation into your project as local files and '
        'wires the two font faces into your pubspec.yaml. add then copies '
        'component source the same way, resolving dependencies for you.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsSnippet(
          language: 'bash',
          code:
              '# Run these from inside your Flutter project.\n'
              'elattar init --foundation source\n\n'
              '# One component, with everything it depends on.\n'
              'elattar add button\n\n'
              '# Or the whole set.\n'
              'elattar add --all\n\n'
              '# Lists every file that would be written, and writes none.\n'
              'elattar add button --dry-run',
          // Eleven lines is enough to be worth collapsing on a page this
          // long — see the expansion-control test in
          // installation_docs_test.dart.
          maxHeight: space(28),
        ),
      ],
    ),
  );

  Widget _registry(ThemeTokens theme) => DocsSection(
    id: 'registry',
    title: 'Where components come from',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'A hosted registry, pinned to the CLI\'s own version, with a '
          'sha256 on every distributed file. Nothing is written until the '
          'whole install has arrived and verified, so a dropped connection '
          'leaves your project exactly as it was. Use --registry to point '
          'somewhere else: a mirror, or a registry you built yourself.',
        ),
        SizedBox(height: space(4)),
        const DocsSnippet(
          language: 'bash',
          code:
              'elattar add button --registry https://example.com/elattar/0.0.2/',
        ),
        SizedBox(height: space(4)),
        _see(
          theme,
          'See ',
          <(String, String)>[('Registry', docsRegistryRoute)],
          ' for what an item declares, how the closure resolves, and what '
              'the published registry contains.',
        ),
      ],
    ),
  );

  Widget _offline(ThemeTokens theme) => DocsSection(
    id: 'offline',
    title: 'Working offline',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Downloads are cached per user, so a command that has run once '
          'online runs again with no network. Set ELATTAR_CACHE_DIR to keep '
          'the cache inside a workspace, which is what CI wants.',
        ),
        SizedBox(height: space(4)),
        const DocsSnippet(
          language: 'bash',
          code:
              'elattar add button            # populates the cache\n'
              'elattar add card --offline    # reads only the cache',
        ),
        SizedBox(height: space(4)),
        _see(theme, 'See ', <(String, String)>[
          ('CLI', docsCliRoute),
        ], ' for where the cache lives on each platform.'),
      ],
    ),
  );

  Widget _whatLands() => DocsSection(
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
              'Colours, typography, spacing, shadows, motion, theme and the '
              'surfaces, plus the lib/design_system/foundation.dart barrel.',
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
              'Registered under `flutter: fonts:` in your pubspec.yaml '
              'automatically, under the family names the installed '
              'typography actually asks for.',
        ),
        DocsInstallFact(
          label: 'License notices',
          value: 'LICENSES/*.txt',
          description:
              'Elattar\'s MIT notice always, and each third-party notice '
              'alongside the source it covers. Keep them: carrying the '
              'notice is the condition each license attaches to the grant.',
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

  Widget _verification(ThemeTokens theme) => DocsSection(
    id: 'verification',
    title: 'Verify it worked',
    description:
        'One command. doctor checks the project, the config, whether your '
        'dependencies actually resolved, the manifest, and the registry it '
        'would use, and exits 0 only when every check passes.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsSnippet(language: 'bash', code: 'elattar doctor'),
        SizedBox(height: space(4)),
        _prose(
          'A failing line names the one thing to fix. The most common is '
          'dependencies: run flutter pub get after init, because init adds '
          'the font registrations your project has not resolved yet.',
          spec: TextStyles.small,
        ),
      ],
    ),
  );

  Widget _troubleshooting() => DocsSection(
    id: 'troubleshooting',
    title: 'When a command refuses',
    description:
        'Every refusal below leaves your project untouched. Fix the one '
        'thing it names and run the same command again.',
    child: const DocsStateMatrix(
      title: 'Common failures',
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Run add before init',
          treatment: 'add stops: there is no elattar.yaml to read.',
          userSignal: 'Run `elattar init --foundation source` first.',
        ),
        DocsStateFact(
          state: 'Not inside a Flutter project',
          treatment:
              'No pubspec.yaml declaring Flutter was found above the current '
              'directory.',
          userSignal: 'Change into your app and run the command again.',
        ),
        DocsStateFact(
          state: 'The registry could not be reached',
          treatment:
              'The host did not answer, or the request timed out. Nothing '
              'was written.',
          userSignal:
              'Check the connection, or add --offline to work from the '
              'cache you already have.',
        ),
        DocsStateFact(
          state: 'Nothing cached, under --offline',
          treatment:
              'The command names the file it wanted and the registry it '
              'wanted it from.',
          userSignal:
              'Run the same command once without --offline to fill the '
              'cache.',
        ),
        DocsStateFact(
          state: 'A file failed its hash check',
          treatment:
              'Verification runs before the first write, so nothing landed.',
          userSignal:
              'Retry. If it repeats, the registry you pointed at is not '
              'serving what it declares.',
        ),
        DocsStateFact(
          state: 'Your files would be overwritten',
          treatment:
              'add lists every conflicting destination and writes nothing.',
          userSignal:
              'That usually means you edited an installed file, which you '
              'are meant to be able to do. Save your version, then re-run '
              'with --overwrite.',
        ),
      ],
    ),
  );

  Widget _packageFoundation(ThemeTokens theme) => DocsSection(
    id: 'package-foundation',
    title: 'Package foundation',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Alert(
          variant: AlertVariant.destructive,
          icon: Icon(IconGlyph.circleX),
          title: 'Not available',
          description:
              '`elattar init --foundation package` is refused before it '
              'touches your project. It would depend on a package that does '
              'not exist, producing an app that cannot resolve.',
        ),
        SizedBox(height: space(4)),
        _prose(
          'It stays refused until such a package is really published. Use '
          '--foundation source, which is what the rest of this page shows.',
          spec: TextStyles.small,
        ),
      ],
    ),
  );

  Widget _fullPackage() => DocsSection(
    id: 'full-package',
    title: 'Full maintained package',
    description:
        'If you would rather depend on the package than own the source: '
        'depend on elattar_design_system and import the same public names '
        'from its barrel, no CLI involved. The package itself is not '
        'published, because source installation is the distribution route, '
        'so this is a git or path dependency, exactly as this repository\'s '
        'own example app consumes it.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsCodeExample(
          title: 'pubspec.yaml',
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'pubspec.yaml',
              title: 'From Git',
              description:
                  'The `ref:` pins the release tag, which is cut at the same '
                  'commit the registry and this site were built from. Drop '
                  'it to track the default branch instead.',
              code:
                  'dependencies:\n'
                  '  elattar_design_system:\n'
                  '    git:\n'
                  '      url: https://github.com/ELATTAR-Ayoub/flutter-design-system.git\n'
                  '      ref: ${releaseFacts.tag}',
            ),
            const DocsCodeFile(
              path: 'pubspec.yaml',
              title: 'From a local checkout',
              description:
                  'Path relative to your project. Adjust the `../` segments '
                  'to wherever you cloned the repository.',
              code:
                  'dependencies:\n'
                  '  elattar_design_system:\n'
                  '    path: ../flutter-design-system',
            ),
          ],
        ),
        SizedBox(height: space(4)),
        const DocsSnippet(language: 'bash', code: 'flutter pub get'),
      ],
    ),
  );
}
