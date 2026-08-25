// example/test/docs/component_doc_page_test.dart
/// The page, as a component.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/component_doc_page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_showcase.dart';
import 'package:example/docs/docs_snippet.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const ComponentDocSpec _spec = ComponentDocSpec(
  name: 'button',
  title: 'Button',
  description: 'A pill-shaped control.',
  sections: <DocsPageSection>[
    InstallSection(
      id: 'install',
      title: 'Installation',
      command: 'elattar add button',
      manualFiles: <DocsCodeFile>[],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      code: 'ElButton(onPressed: () {}, child: const Text("Go"))',
    ),
    ShowcaseSection(
      id: 'ghost',
      title: 'Ghost',
      specimen: SizedBox(height: 40, width: 100),
      code: 'ElButton(variant: ElButtonVariant.ghost)',
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: Text('Tokens.'),
    ),
  ],
);

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: ElTheme(
    controller: ElThemeController(mode: ElThemeMode.dark),
    child: SingleChildScrollView(child: child),
  ),
);

void main() {
  testWidgets('every declared section renders as its own kind', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(const ComponentDocPage(spec: _spec)));
    await tester.pump();

    expect(find.byType(DocsInstall), findsOneWidget);
    expect(find.byType(DocsShowcase), findsOneWidget);
    expect(find.byType(DocsDisclosure), findsOneWidget);
    // Two DocsSnippets: DocsInstall opens on its CLI pane, which renders its
    // own DocsSnippet for the shell command, and the Usage section renders
    // one directly for its code. The showcase opens on Preview, not Code, so
    // it contributes none.
    expect(find.byType(DocsSnippet), findsNWidgets(2));
  });

  test('the table of contents is derived from the same list', () {
    // A section that exists without a TOC entry is a section nobody can
    // reach from the rail, and a TOC entry without a section is a dead link.
    expect(
      _spec.toc.map((DocsTocEntry entry) => entry.anchor).toList(),
      <String>['install', 'usage', 'ghost', 'theming'],
    );
    expect(
      _spec.toc.map((DocsTocEntry entry) => entry.title).toList(),
      <String>['Installation', 'Usage', 'Ghost', 'Theming'],
    );
  });

  testWidgets('the header carries the title and description', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(const ComponentDocPage(spec: _spec)));
    await tester.pump();

    expect(find.text('Button'), findsOneWidget);
    expect(find.text('A pill-shaped control.'), findsOneWidget);
  });

  testWidgets('nothing on the page uses an uppercase type role', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(const ComponentDocPage(spec: _spec)));
    await tester.pump();

    for (final ElText text in tester.widgetList<ElText>(find.byType(ElText))) {
      expect(text.spec.uppercase, isFalse, reason: text.text);
    }
  });
}
