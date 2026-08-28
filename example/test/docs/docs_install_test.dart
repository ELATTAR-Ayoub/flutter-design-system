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
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ThemeScope(
      controller: ThemeController(mode: ColorMode.dark),
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
                code: 'class Button {}',
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
                code: 'class Button {}',
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
      greaterThanOrEqualTo(99),
      reason:
          'the command-truth guard must not pass vacuously over an empty catalog',
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

  test('every registry item has a documentation page', () {
    // The whole point of the rollout. The registry ships 99 items; before
    // this, 44 of them resolved to nothing — a reader following a
    // dependency list, a search result or a bare URL landed on the
    // homepage's "not found" fallback, which is indistinguishable from the
    // item not existing.
    //
    // Asserted in the direction that matters. The command-truth test above
    // proves no page invents an item; this proves no item is left without a
    // page, and it is the one that can only be satisfied by writing all 99.
    final Map<String, Object?> registry =
        jsonDecode(
              File(
                '../registry/generated/latest/registry.json',
              ).readAsStringSync(),
            )
            as Map<String, Object?>;

    // `ComponentDocEntry.name` is spelled with hyphens for some entries and
    // underscores for others, and both are load bearing — `route` is
    // `/components/$name`. Normalise on the way in rather than pick a side.
    final Set<String> documented = <String>{
      for (final ComponentDocEntry entry in componentDocs)
        entry.name.replaceAll('_', '-'),
    };

    final List<String> undocumented = <String>[
      for (final Object? raw in registry['items']! as List<Object?>)
        if (!documented.contains((raw! as Map<String, Object?>)['name']))
          (raw as Map<String, Object?>)['name']! as String,
    ];

    expect(
      undocumented,
      isEmpty,
      reason:
          '${undocumented.length} registry items resolve to no page: '
          '${undocumented.join(', ')}',
    );
  });
}
