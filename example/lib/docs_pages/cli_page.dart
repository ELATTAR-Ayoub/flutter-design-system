/// Public documentation page for `/docs/cli`.
///
/// Content contract: `docs/superpowers/plans/2026-08-21-public-website-ui-
/// information-architecture.md` section 7.9. The command reference below is
/// read directly from `packages/elattar_cli/lib/src/commands/app.dart`
/// (`ElattarCli.run`, `_printUsage`, and the `try`/`catch` exit-code ladder in
/// `run`) and confirmed by executing every command listed against this
/// checkout: `--version`, `help`, `init`, `add`, `list`, `search`, `info`,
/// and `doctor` all ran; `list` and `info` were checked against the real 20
/// item registry at `registry/generated/latest/`. `--foundation package` is
/// documented as refused because it was run and refused with exit 64.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../docs/docs_code.dart';
import '../docs/docs_facts.dart';
import '../docs/docs_layout.dart';
import '../kit.dart';
import 'catalog.dart';

class CliDocsPage extends StatelessWidget {
  const CliDocsPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: docsCliRoute,
    intro: const DocsPageIntro(
      eyebrow: 'DOCS',
      title: 'CLI',
      description:
          'The real elattar command surface: six commands, their flags, '
          'and the exit code each failure path returns.',
    ),
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Docs'),
      DsBreadcrumbEntry.page('CLI'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Synopsis', anchor: 'synopsis'),
      DocsTocEntry(title: 'Running it', anchor: 'running'),
      DocsTocEntry(title: 'Global options', anchor: 'global-options'),
      DocsTocEntry(title: 'Commands', anchor: 'commands'),
      DocsTocEntry(title: 'Common workflows', anchor: 'workflows'),
      DocsTocEntry(title: 'Exit codes', anchor: 'exit-codes'),
      DocsTocEntry(title: 'Output format', anchor: 'output'),
      DocsTocEntry(title: 'Offline and CI usage', anchor: 'offline'),
      DocsTocEntry(title: 'Conflicts and recovery', anchor: 'conflicts'),
    ],
    previous: const DocsPageLink(title: 'Theming', route: docsThemingRoute),
    next: const DocsPageLink(title: 'Typeset', route: docsTypesetRoute),
    onNavigate: onNavigate,
    child: const _CliArticle(),
  );
}

class _CliArticle extends StatelessWidget {
  const _CliArticle();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      key: const ValueKey<String>('cli-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _synopsis(),
        _running(theme),
        _globalOptions(theme),
        _commands(theme),
        _workflows(),
        _exitCodes(),
        _output(theme),
        _offline(theme),
        _conflicts(theme),
      ],
    );
  }

  Widget _prose(String text, DsThemeData theme, {DsTypeSpec? spec}) =>
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: DsWidths.prose),
        child: DsText(text, spec ?? DsType.body),
      );

  Widget _synopsis() => DsSection(
    id: 'synopsis',
    title: 'Synopsis',
    child: DsPanel(
      label: 'CONSOLE',
      note: 'USAGE',
      child: DocsSelectableCodeBlock(
        code:
            'elattar --version\n'
            'elattar init [--foundation source] [--yes] [--dry-run] [--registry PATH]\n'
            'elattar add <items...> [--overwrite] [--dry-run] [--registry PATH]\n'
            'elattar list [--registry PATH]\n'
            'elattar search <query> [--registry PATH]\n'
            'elattar info <name> [--registry PATH]\n'
            'elattar doctor [--registry PATH]\n'
            'elattar help',
      ),
    ),
  );

  Widget _running(DsThemeData theme) => DsSection(
    id: 'running',
    title: 'Running it',
    child: _prose(
      'The CLI is not published, see Installation for the full context. '
      'Every command on this page is written as `elattar <command>` for '
      'readability; from a checkout it is actually invoked as `dart run '
      'packages/elattar_cli/bin/elattar.dart <command>`, or as the bare '
      '`elattar` form once activated locally.',
      theme,
    ),
  );

  Widget _globalOptions(DsThemeData theme) => DsSection(
    id: 'global-options',
    title: 'Global options',
    child: const DocsApiTable(
      title: 'Options accepted before any subcommand',
      facts: <DocsApiFact>[
        DocsApiFact(
          name: '--version',
          type: 'flag',
          description:
              'Prints the CLI version (0.0.1) and exits 0. Consumed before '
              'any subcommand is parsed.',
        ),
        DocsApiFact(
          name: 'help / --help / -h',
          type: 'flag',
          description: 'Prints the synopsis above and exits 0.',
        ),
        DocsApiFact(
          name: '--registry PATH',
          type: 'per-command option',
          description:
              'Every command below accepts this. Without it, the CLI walks '
              'up from the current directory looking for '
              'registry/generated/latest.',
        ),
      ],
    ),
  );

  Widget _commands(DsThemeData theme) => DsSection(
    id: 'commands',
    title: 'Commands',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'Every subcommand',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'init',
              type:
                  '[--foundation source] [--yes] [--dry-run] [--registry PATH]',
              description:
                  'Writes elattar.yaml, the source-foundation files, fonts, '
                  'and an empty lib/components/ui/ui.dart barrel. '
                  '--foundation package is refused with exit 64, see '
                  'Introduction and Installation. --yes is accepted and has '
                  'no effect: init never prompts.',
            ),
            DocsApiFact(
              name: 'add <items...>',
              type: '[--overwrite] [--dry-run] [--registry PATH]',
              description:
                  'Resolves each item\'s transitive registryDependencies and '
                  'writes the resulting files, assets, and font '
                  'registrations. Requires elattar.yaml and '
                  '.elattar/manifest.json to already exist (run init first).',
            ),
            DocsApiFact(
              name: 'list',
              type: '[--registry PATH]',
              description:
                  'Prints one tab-separated line per registry item: '
                  'name, type, version.',
            ),
            DocsApiFact(
              name: 'search <query>',
              type: '[--registry PATH]',
              description:
                  'Prints one tab-separated line per match: name, type, '
                  'description.',
            ),
            DocsApiFact(
              name: 'info <name>',
              type: '[--registry PATH]',
              description:
                  'Prints one item\'s full manifest as indented JSON: the '
                  'only command that emits JSON. See Output format.',
            ),
            DocsApiFact(
              name: 'doctor',
              type: '[--registry PATH]',
              description:
                  'Checks the Flutter project, elattar.yaml, declared '
                  'dependency resolution, the manifest, and the registry. '
                  'Prints one ok/err line per check.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _workflows() => DsSection(
    id: 'workflows',
    title: 'Common workflows',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPanel(
          label: 'CONSOLE',
          note: 'NEW PROJECT',
          child: DocsSelectableCodeBlock(
            code:
                'elattar init --foundation source --registry registry/generated/latest\n'
                'elattar add button --registry registry/generated/latest',
          ),
        ),
        SizedBox(height: ds(4)),
        DsPanel(
          label: 'CONSOLE',
          note: 'DISCOVER BEFORE INSTALLING',
          child: DocsSelectableCodeBlock(
            code:
                'elattar list --registry registry/generated/latest\n'
                'elattar search dialog --registry registry/generated/latest\n'
                'elattar info button --registry registry/generated/latest',
          ),
        ),
      ],
    ),
  );

  Widget _exitCodes() => DsSection(
    id: 'exit-codes',
    title: 'Exit codes',
    description: 'Every code `ElattarCli.run` can return, and what causes it.',
    child: const DocsApiTable(
      title: 'Exit codes',
      facts: <DocsApiFact>[
        DocsApiFact(
          name: '0',
          type: 'success',
          description: 'Command completed, including --version and help.',
        ),
        DocsApiFact(
          name: '1',
          type: 'StateError / doctor issues',
          description:
              'An unclassified StateError, or doctor exits 1 when any check '
              'reported err.',
        ),
        DocsApiFact(
          name: '64',
          type: 'FormatException',
          description:
              'Bad or unknown arguments, an unknown command, or the '
              '--foundation package refusal.',
        ),
        DocsApiFact(
          name: '65',
          type: 'RegistryDependencyCycleException / RegistryIntegrityException',
          description:
              'A dependency cycle, or a file whose sha256 does not match.',
        ),
        DocsApiFact(
          name: '66',
          type: 'RegistryItemNotFoundException',
          description:
              'add or info named an item the registry does not contain.',
        ),
        DocsApiFact(
          name: '72',
          type: 'FlutterProjectNotFound',
          description:
              'No pubspec.yaml with a flutter dependency found above the current directory.',
        ),
        DocsApiFact(
          name: '73',
          type: 'install conflicts',
          description:
              'add would overwrite existing files and --overwrite was not passed.',
        ),
        DocsApiFact(
          name: '78',
          type: 'ElattarConfigException / ElattarManifestException',
          description:
              'Missing or invalid elattar.yaml or .elattar/manifest.json.',
        ),
      ],
    ),
  );

  Widget _output(DsThemeData theme) => DsSection(
    id: 'output',
    title: 'Output format',
    child: _prose(
      'There is no --json flag on any command. info always prints indented '
      'JSON; list and search always print tab-separated plain text, one '
      'result per line; init, add, and doctor print one prefixed line per '
      'step or check (init/add write a summary of every file written; '
      'doctor prints "ok" or "err" per check). A caller scripting against '
      'this CLI should parse info\'s JSON and split the others on tabs, not '
      'expect a shared machine format across commands.',
      theme,
    ),
  );

  Widget _offline(DsThemeData theme) => DsSection(
    id: 'offline',
    title: 'Offline and CI usage',
    child: _prose(
      'The registry the CLI reads is a local, generated directory '
      '(registry/generated/latest/): every command above resolves it by '
      'filesystem path, and none of the six commands make a network '
      'request. --registry PATH also rejects a URL outright, with a '
      '"Remote registries are not supported yet" error, rather than '
      'attempting to fetch one. That makes every command above safe and '
      'deterministic to run in CI, provided the registry directory is '
      'present in the checkout the job runs against.',
      theme,
    ),
  );

  Widget _conflicts(DsThemeData theme) => DsSection(
    id: 'conflicts',
    title: 'Conflicts and recovery',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'add plans every write before touching disk. If any destination '
          'already exists and differs from what would be written, it lists '
          'every conflicting path and writes nothing, exit 73. Pass '
          '--overwrite to proceed once you have reviewed them, or '
          '--dry-run first to preview a plan without writing anything.',
          theme,
        ),
        SizedBox(height: ds(3)),
        _prose(
          'doctor is the recovery entry point: it separately checks the '
          'Flutter project, elattar.yaml, whether pubspec.yaml\'s declared '
          'dependencies actually resolved (.dart_tool/package_config.json '
          'exists and lists them), the install manifest, and the registry, '
          'and exits 1 the moment any one of those is wrong, rather than '
          'reporting a project healthy because its own four files parsed.',
          theme,
        ),
      ],
    ),
  );
}
