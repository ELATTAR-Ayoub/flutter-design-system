/// The `elattar` command surface, as the website is allowed to describe it.
///
/// **This is a restatement, and it is guarded as one.** The CLI's own
/// `_printUsage` in `packages/elattar_cli/lib/src/commands/app.dart` is the
/// source of truth for which commands exist and which options each takes;
/// `example/test/cli_docs_test.dart` reads that method and fails if this list
/// names a command the CLI does not print, omits one it does, or disagrees
/// with it about a single option. The website therefore cannot grow a command
/// surface of its own, which is exactly how a page ends up documenting a
/// `view` or a `diff` that nothing implements.
///
/// What this file owns, and the CLI does not: the one sentence saying what a
/// command is *for*, and the one example worth copying. Neither is derivable
/// from a usage string, and neither can go stale in a way a reader mistakes
/// for a working command.
///
/// Dependency-free on purpose, the same discipline `catalog.dart` keeps: no
/// Flutter import, so the guard test can read it without a widget binding.
library;

/// One line of `elattar` usage, plus what it is for.
class CliCommand {
  const CliCommand({
    required this.name,
    required this.usage,
    required this.summary,
    required this.example,
  });

  /// The first token after `elattar`: `init`, `add`, or the bare `--version`.
  final String name;

  /// The remainder of the printed usage line, options included. Compared
  /// token for token against `_printUsage`.
  final String usage;

  /// One sentence. What a reader is choosing this command for.
  final String summary;

  /// One copyable line, in the shortest form that does something useful.
  final String example;

  /// Every long option this command's usage line declares.
  List<String> get options => <String>[
    for (final RegExpMatch match in RegExp(r'--[a-z-]+').allMatches(usage))
      match.group(0)!,
  ];
}

/// Every command `elattar` prints in its own usage, in that order.
const List<CliCommand> cliCommands = <CliCommand>[
  CliCommand(
    name: '--version',
    usage: '',
    summary:
        'Prints the version and exits. Consumed before any subcommand, so it '
        'works outside a project.',
    example: 'elattar --version',
  ),
  CliCommand(
    name: 'init',
    usage:
        '[--foundation source] [--yes] [--dry-run] [--registry PATH_OR_URL] '
        '[--offline]',
    summary:
        'Sets a Flutter project up: the foundation as local source, the three '
        'font faces wired into your pubspec.yaml, elattar.yaml, the install '
        'manifest and the license notices. Run it once.',
    example: 'elattar init --foundation source',
  ),
  CliCommand(
    name: 'add',
    usage:
        '<items...> [--all] [--overwrite] [--dry-run] '
        '[--registry PATH_OR_URL] [--offline]',
    summary:
        'Copies items and everything they depend on into your project. '
        '--all installs the whole registry; --overwrite replaces files you '
        'have edited; --dry-run lists every write and performs none.',
    example: 'elattar add button',
  ),
  CliCommand(
    name: 'list',
    usage: '[--registry PATH_OR_URL] [--offline]',
    summary:
        'Every item in the registry, one tab-separated line each: name, type, '
        'version.',
    example: 'elattar list',
  ),
  CliCommand(
    name: 'search',
    usage: '<query> [--registry PATH_OR_URL] [--offline]',
    summary:
        'Ranked matches over names, descriptions and routes, one '
        'tab-separated line each.',
    example: 'elattar search dialog',
  ),
  CliCommand(
    name: 'info',
    usage: '<name> [--registry PATH_OR_URL] [--offline]',
    summary:
        'One item\'s full manifest as indented JSON: files, targets, '
        'dependencies, licenses. The only command that emits JSON.',
    example: 'elattar info button',
  ),
  CliCommand(
    name: 'doctor',
    usage: '[--registry PATH_OR_URL] [--offline] [--verbose]',
    summary:
        'Checks the project, the config, whether your dependencies resolved, '
        'the manifest and the registry, one ok/err line each. Exits non-zero '
        'the moment any check fails.',
    example: 'elattar doctor',
  ),
];

/// The options every command accepts, described once instead of seven times.
///
/// Derived from [cliCommands]: an option is shared when every command that
/// takes any option takes it.
const List<String> sharedOptions = <String>['--registry', '--offline'];
