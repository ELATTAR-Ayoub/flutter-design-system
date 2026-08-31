/// Public documentation page for `/docs/cli`.
///
/// One job: a reader knows which command to type next. `init` and `add` are
/// the two that matter and they come first; the reference table, the exit
/// codes, the output shapes and the recovery paths follow in that order,
/// because that is the order a developer needs them in.
///
/// **The command surface is not written here.** It comes from
/// `cli_catalog.dart`, which `example/test/cli_docs_test.dart` checks against
/// `packages/elattar_cli/lib/src/commands/app.dart`'s own `_printUsage`,
/// option by option. The exit-code ladder below is read from the same file's
/// `try`/`catch` chain in `ElattarCli.run`.
///
/// Nothing on this page documents a command Elattar does not implement.
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
import 'cli_catalog.dart';

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
          'One command with six subcommands. The two you will type are '
          'init and add.',
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Docs'),
      BreadcrumbEntry.page('CLI'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'The two you need', anchor: 'synopsis'),
      DocsTocEntry(title: 'Running it', anchor: 'running'),
      DocsTocEntry(title: 'Shared options', anchor: 'global-options'),
      DocsTocEntry(title: 'Every command', anchor: 'commands'),
      DocsTocEntry(title: 'Common workflows', anchor: 'workflows'),
      DocsTocEntry(title: 'Exit codes', anchor: 'exit-codes'),
      DocsTocEntry(title: 'Output format', anchor: 'output'),
      DocsTocEntry(title: 'Offline and CI', anchor: 'offline'),
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
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      key: const ValueKey<String>('cli-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _synopsis(),
        _running(theme),
        _globalOptions(),
        _commands(),
        _workflows(),
        _exitCodes(),
        _output(theme),
        _offline(theme),
        _conflicts(theme),
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

  Widget _synopsis() => DocsSection(
    id: 'synopsis',
    title: 'The two you need',
    description:
        'init prepares the project. add copies a component and everything it '
        'depends on. Everything else on this page reads the registry or '
        'reports on what already happened.',
    child: const DocsSnippet(
      language: 'bash',
      code:
          '# Once per project.\n'
          'elattar init --foundation source\n\n'
          '# Whenever you want a component.\n'
          'elattar add button',
    ),
  );

  Widget _running(ThemeTokens theme) => DocsSection(
    id: 'running',
    title: 'Running it',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Every command below assumes an `elattar` executable on your PATH. '
          'Run it with no arguments, or with help, to print the same usage '
          'this page is built from.',
        ),
        SizedBox(height: space(4)),
        _see(
          theme,
          'See ',
          <(String, String)>[('Installation', docsInstallationRoute)],
          ' for how to get the command, and what to do when your shell '
              'cannot find it.',
        ),
      ],
    ),
  );

  Widget _globalOptions() => DocsSection(
    id: 'global-options',
    title: 'Shared options',
    description:
        'Every subcommand takes these two. The rest belong to one command '
        'each and are listed with it.',
    child: const DocsApiTable(
      title: 'Accepted by every subcommand',
      facts: <DocsApiFact>[
        DocsApiFact(
          name: '--registry',
          type: 'PATH_OR_URL',
          description:
              'A local directory or an http(s) URL; anything else is refused '
              'before it reaches the filesystem. Without it the CLI walks up '
              'from the working directory looking for a local registry, and '
              'only then falls back to the versioned public one over HTTP, '
              'so a plain run outside a checkout does make a network '
              'request. When a local registry is discovered rather than '
              'named, the CLI says so.',
        ),
        DocsApiFact(
          name: '--offline',
          type: 'flag',
          description:
              'Restricts the command to what is already cached and never '
              'opens a connection. A cache miss and a network failure are '
              'reported differently, because they have different fixes.',
        ),
      ],
    ),
  );

  Widget _commands() => DocsSection(
    id: 'commands',
    title: 'Every command',
    description:
        'The usage column is the CLI\'s own, checked against it by test. '
        'Options every command shares are above and not repeated here.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsApiTable(
          title: 'Subcommands',
          facts: <DocsApiFact>[
            for (final CliCommand command in cliCommands)
              DocsApiFact(
                name: command.name,
                type: command.usage.isEmpty ? 'flag' : command.usage,
                description: command.summary,
              ),
          ],
        ),
        SizedBox(height: space(5)),
        DocsSnippet(
          language: 'bash',
          code: <String>[
            for (final CliCommand command in cliCommands) command.example,
          ].join('\n'),
        ),
      ],
    ),
  );

  Widget _workflows() => DocsSection(
    id: 'workflows',
    title: 'Common workflows',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsSnippet(
          language: 'bash',
          code:
              '# Find something, read what it brings with it, install it.\n'
              'elattar search dialog\n'
              'elattar info dialog\n'
              'elattar add dialog --dry-run\n'
              'elattar add dialog',
        ),
        SizedBox(height: space(4)),
        const DocsSnippet(
          language: 'bash',
          code:
              '# Against a registry you built, with no network at all.\n'
              'elattar add button --registry ../flutter-design-system/registry/generated/latest',
        ),
      ],
    ),
  );

  Widget _exitCodes() => DocsSection(
    id: 'exit-codes',
    title: 'Exit codes',
    description:
        'Every code the CLI returns, and the one thing that causes it. Useful '
        'when a script has to tell "you typed it wrong" from "the network '
        'was down".',
    child: const DocsApiTable(
      title: 'Exit codes',
      facts: <DocsApiFact>[
        DocsApiFact(
          name: '0',
          type: 'success',
          description: 'The command completed, --version and help included.',
        ),
        DocsApiFact(
          name: '1',
          type: 'doctor found problems',
          description:
              'Or an unclassified internal error. doctor is the usual cause.',
        ),
        DocsApiFact(
          name: '64',
          type: 'usage',
          description:
              'An unknown flag or command, an unusable --registry value, or '
              'the --foundation package refusal.',
        ),
        DocsApiFact(
          name: '65',
          type: 'integrity',
          description:
              'A file whose sha256 did not match, or a dependency cycle. '
              'Nothing was written either way.',
        ),
        DocsApiFact(
          name: '66',
          type: 'no such item',
          description:
              'add or info named something the registry does not '
              'contain.',
        ),
        DocsApiFact(
          name: '70',
          type: 'registry unreachable',
          description:
              'The command was well formed; a remote registry could not be '
              'read, or --offline found nothing cached.',
        ),
        DocsApiFact(
          name: '72',
          type: 'no Flutter project',
          description:
              'No pubspec.yaml declaring Flutter above the current '
              'directory.',
        ),
        DocsApiFact(
          name: '73',
          type: 'conflicts',
          description:
              'add would overwrite files that differ, and --overwrite was '
              'not passed. See Conflicts and recovery.',
        ),
        DocsApiFact(
          name: '78',
          type: 'project record',
          description:
              'elattar.yaml or .elattar/manifest.json is missing or '
              'unusable. Run init first.',
        ),
      ],
    ),
  );

  Widget _output(ThemeTokens theme) => DocsSection(
    id: 'output',
    title: 'Output format',
    child: _prose(
      'There is no --json flag. info always prints indented JSON; list and '
      'search always print tab-separated plain text, one result per line; '
      'init, add and doctor print one prefixed line per step or check. A '
      'script should parse info\'s JSON and split the others on tabs, rather '
      'than expect one machine format across all six.',
    ),
  );

  Widget _offline(ThemeTokens theme) => DocsSection(
    id: 'offline',
    title: 'Offline and CI',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _prose(
          'Two ways to make a run deterministic: --offline, which reads only '
          'the cache, and --registry pointed at a checked-in directory, which '
          'never resolves to the remote registry at all. Downloads are cached '
          'per user, and writes are atomic, so an interrupted download never '
          'becomes a readable cache entry.',
        ),
        SizedBox(height: space(4)),
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
                  'Set it to keep the cache inside a workspace, which is '
                  'what CI wants.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _conflicts(ThemeTokens theme) => DocsSection(
    id: 'conflicts',
    title: 'Conflicts and recovery',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'add plans every write before touching disk. If a destination '
          'already exists and differs from what would be written, it lists '
          'every conflicting path, writes nothing, and exits 73. That '
          'usually means you edited an installed file, which you are meant '
          'to be able to do.',
        ),
        SizedBox(height: space(4)),
        const DocsSnippet(
          language: 'bash',
          code:
              '# See the plan without writing any of it.\n'
              'elattar add button --dry-run\n\n'
              '# Take the registry\'s copy, once you have saved yours.\n'
              'elattar add button --overwrite',
        ),
        SizedBox(height: space(4)),
        _prose(
          'doctor is the entry point when something is wrong but no command '
          'has failed: it checks the project, the config, whether the '
          'declared dependencies actually resolved, the manifest and the '
          'registry separately, so it cannot report a project healthy '
          'because its own four files parsed.',
          spec: TextStyles.small,
        ),
      ],
    ),
  );
}
