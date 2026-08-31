/// The website may not invent a command, and may not miss one.
///
/// `docs_pages/cli_catalog.dart` is a restatement of the CLI's own usage, and
/// a restatement is only safe while something checks it. This suite reads
/// `packages/elattar_cli/lib/src/commands/app.dart`'s `_printUsage`, the
/// method that produces what a user sees when they type `elattar`, and holds
/// the catalog to it in both directions: no command the CLI does not print,
/// none it does that the catalog omits, and the same option set on each.
///
/// It also guards the negative case the plan names directly: a `view`, a
/// `diff`, a preset builder or a framework scaffold are things other tools
/// have and this one does not, and a documentation page is exactly where they
/// would appear first.
///
/// Runs with cwd = `example/`, so the CLI source is read as `../packages/...`.
library;

import 'dart:io';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs_pages/cli_catalog.dart';
import 'package:example/docs_pages/cli_page.dart';
import 'package:flutter/material.dart'
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
        TableColumnWidth,
        ActionChip,
        AlertDialog,
        Badge,
        Card,
        CarouselController,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        DrawerHeader,
        Slider,
        Switch,
        TextFormField,
        Tooltip;
import 'package:flutter_test/flutter_test.dart';

const String _cliSource = '../packages/elattar_cli/lib/src/commands/app.dart';

/// `_printUsage`'s printed lines, reassembled.
///
/// The method splits its longer lines across adjacent Dart string literals to
/// fit the line length, so the quotes are stripped and the whitespace
/// collapsed before parsing, which rejoins `'… [--dry-run] '` and
/// `'[--registry PATH_OR_URL] …'` into the one line the user actually sees.
/// Parsing is deliberately crude: a guard that needs a Dart parser to run is
/// a guard nobody keeps working.
List<String> _printedUsageLines() {
  final String source = File(_cliSource).readAsStringSync();
  final int start = source.indexOf('int _printUsage()');
  expect(
    start,
    greaterThanOrEqualTo(0),
    reason: 'no _printUsage in $_cliSource',
  );
  final int end = source.indexOf('return 0;', start);
  expect(end, greaterThan(start));

  final String body = source
      .substring(start, end)
      // The trailing prose block ("--registry takes a local directory…") is
      // not a usage line; it is the footer under them.
      .split('_stdout(\'\')')
      .first
      .replaceAll("'", '')
      .replaceAll(RegExp(r'\s+'), ' ')
      // The banner line above `usage:` is `elattar <version>`, which is not a
      // command. Everything the method prints after `usage:` is.
      .split('usage:')
      .last;

  return <String>[
    for (final String chunk in body.split('elattar ').skip(1))
      // Everything up to the `,);` or `);` that closes the _stdout call.
      chunk.split(RegExp(r'[,)]')).first.trim(),
  ];
}

Widget _host(Widget child) => ThemeScope(
  controller: ThemeController(mode: ColorMode.dark),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SingleChildScrollView(child: child),
  ),
);

void main() {
  group('the catalog is the CLI\'s own usage', () {
    late List<String> printed;

    setUpAll(() {
      printed = _printedUsageLines();
      // The parse has to actually find something, or every check below
      // passes vacuously, which is how a guard quietly stops guarding.
      expect(printed.length, greaterThan(1));
    });

    test('the parse recovers whole usage lines, options included', () {
      expect(
        printed.any((String line) => line.contains('--registry PATH_OR_URL')),
        isTrue,
        reason:
            'the literal-rejoining step is broken: no reassembled line '
            'carries the option that only appears in a continuation string. '
            'Recovered: $printed',
      );
    });

    test('the catalog names every command the CLI prints, and no other', () {
      final List<String> printedNames = <String>[
        for (final String line in printed) line.split(' ').first,
      ];
      final List<String> catalogued = <String>[
        for (final CliCommand command in cliCommands) command.name,
      ];
      expect(
        catalogued,
        printedNames,
        reason:
            'cli_catalog.dart and the CLI disagree about which commands '
            'exist, or about their order.',
      );
    });

    test('each command declares exactly the options the CLI prints', () {
      for (final CliCommand command in cliCommands) {
        final String line = printed.firstWhere(
          (String candidate) => candidate.split(' ').first == command.name,
          orElse: () => '',
        );
        expect(line, isNotEmpty, reason: command.name);

        final Set<String> printedOptions = <String>{
          for (final RegExpMatch match in RegExp(
            r'--[a-z-]+',
          ).allMatches(line.substring(command.name.length)))
            match.group(0)!,
        };
        expect(
          command.options.toSet(),
          printedOptions,
          reason:
              '${command.name} documents a different option set than the CLI '
              'prints for it',
        );
      }
    });

    test('every shared option really is taken by every subcommand', () {
      for (final String option in sharedOptions) {
        for (final CliCommand command in cliCommands) {
          // `--version` takes no options at all and is the one exception; it
          // is a flag consumed before any subcommand is parsed.
          if (command.usage.isEmpty) continue;
          expect(
            command.options,
            contains(option),
            reason:
                '$option is presented as shared but ${command.name} does not '
                'take it',
          );
        }
      }
    });

    test('every command carries a sentence and a copyable example', () {
      for (final CliCommand command in cliCommands) {
        expect(command.summary.trim(), isNotEmpty, reason: command.name);
        expect(
          command.example,
          startsWith('elattar '),
          reason: '${command.name} example is not a command line',
        );
        expect(
          command.example.contains('\n'),
          isFalse,
          reason: '${command.name} example should be one line',
        );
      }
    });
  });

  group('the page documents nothing the CLI does not implement', () {
    testWidgets('no unimplemented command appears on the page', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_host(const CliDocsPage()));
      await tester.pump();

      // Each of these is real in a comparable tool and absent here. A reader
      // who copies one gets exit 64 and concludes their install is broken.
      for (final String invented in <String>[
        'elattar view',
        'elattar diff',
        'elattar preset',
        'elattar build',
        'elattar create',
      ]) {
        expect(
          find.textContaining(invented),
          findsNothing,
          reason: '$invented is not a command this CLI implements',
        );
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('every catalogued example is rendered as copyable text', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_host(const CliDocsPage()));
      await tester.pump();

      for (final CliCommand command in cliCommands) {
        expect(
          find.textContaining(command.example),
          findsWidgets,
          reason: '${command.name}: ${command.example} is not on the page',
        );
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('the article mounts at narrow width and 200% text', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 3200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(390, 3200),
            textScaler: TextScaler.linear(2),
          ),
          child: _host(const CliDocsPage()),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('cli-doc-article')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
