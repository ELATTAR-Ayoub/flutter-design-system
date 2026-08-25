// example/test/docs/docs_install_test.dart
/// The install block, and the command it prints.
library;

import 'dart:convert';
import 'dart:io';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/catalog.dart';
import 'package:example/docs/docs_code.dart' show DocsCodeFile;
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_snippet.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ElTheme(
      controller: ElThemeController(mode: ElThemeMode.dark),
      child: child,
    ),
  ),
);

void main() {
  testWidgets('the CLI pane prints the command verbatim', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsInstall(
            command: 'elattar add button',
            manualFiles: <DocsCodeFile>[],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      tester.widget<DocsSnippet>(find.byType(DocsSnippet)).code,
      'elattar add button',
    );
  });

  testWidgets('the manual pane lists the installed paths', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsInstall(
            command: 'elattar add button',
            manualFiles: <DocsCodeFile>[
              DocsCodeFile(
                path: 'lib/components/ui/button.dart',
                code: 'class ElButton {}',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Manual'));
    await tester.pump();

    expect(find.text('lib/components/ui/button.dart'), findsOneWidget);
  });

  testWidgets('a titled file renders its title, description, and path', (
    WidgetTester tester,
  ) async {
    // The page InstallSection replaced rendered file.title (or file.path)
    // as a heading with file.description beneath it — the numbered steps
    // that told a reader what to do with each manual file. DocsInstall
    // must not drop that prose just because it now owns the manual pane.
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsInstall(
            command: 'elattar add button',
            manualFiles: <DocsCodeFile>[
              DocsCodeFile(
                path: 'lib/components/ui/button.dart',
                title: '1. Copy the source',
                description: "Copy the generated source into components/ui.",
                code: 'class ElButton {}',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Manual'));
    await tester.pump();

    expect(find.text('1. Copy the source'), findsOneWidget);
    expect(
      find.text('Copy the generated source into components/ui.'),
      findsOneWidget,
    );
    expect(find.text('lib/components/ui/button.dart'), findsOneWidget);
  });

  test('every documented command names a real registry item', () {
    // A reader copies these. A command for an item that is not in the
    // registry fails at the shell, and the page is what told them to run it.
    final Map<String, Object?> registry =
        jsonDecode(
              File(
                '../registry/generated/latest/registry.json',
              ).readAsStringSync(),
            )
            as Map<String, Object?>;
    final Set<String> names = <String>{
      for (final Object? raw in registry['items']! as List<Object?>)
        (raw! as Map<String, Object?>)['name']! as String,
    };

    expect(
      componentDocs.length,
      greaterThanOrEqualTo(55),
      reason: 'the command-truth guard must not pass vacuously over an empty catalog',
    );

    for (final ComponentDocEntry entry in componentDocs) {
      expect(
        entry.command,
        startsWith('elattar add '),
        reason: '${entry.name} publishes a command in another shape',
      );
      expect(
        names,
        contains(entry.command.substring('elattar add '.length)),
        reason:
            '${entry.name} publishes "${entry.command}", and no registry '
            'item answers to that name',
      );
    }
  });
}
