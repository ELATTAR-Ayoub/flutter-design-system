// example/test/docs/component_doc_page_test.dart
/// The page, as a component.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/component_doc_page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart';
import 'package:example/docs/docs_showcase.dart';
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
      code: 'Button(onPressed: () {}, child: const Text("Go"))',
    ),
    ShowcaseSection(
      id: 'ghost',
      title: 'Ghost',
      specimen: SizedBox(height: 40, width: 100),
      code: 'Button(variant: ButtonVariant.ghost)',
    ),
    DisclosureSection(id: 'theming', title: 'Theming', child: Text('Tokens.')),
  ],
);

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: ThemeScope(
    controller: ThemeController(mode: ColorMode.dark),
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

    for (final StyledText text in tester.widgetList<StyledText>(
      find.byType(StyledText),
    )) {
      expect(text.spec.uppercase, isFalse, reason: text.text);
    }
  });

  testWidgets('an effect section renders its host in a stage', (
    WidgetTester tester,
  ) async {
    // The fifth case. An effect has no variants and often no widget of its
    // own, so what a reader must see is the thing it is applied TO — staged
    // at the host's own measure, not at the page default.
    tester.view.physicalSize = const Size(1440, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        const ComponentDocPage(
          spec: ComponentDocSpec(
            name: 'glass',
            title: 'Glass',
            description: 'A surface treatment.',
            sections: <DocsPageSection>[
              EffectSection(
                id: 'applied',
                title: 'Applied',
                host: SizedBox(height: 120, width: 200),
                code: 'Glass(child: ...)',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(DocsShowcase), findsOneWidget);
    expect(find.text('Applied'), findsOneWidget);
    expect(
      tester.getSize(find.byType(DocsShowcaseFrame)).height,
      DocsShowcase.shortMinHeight,
    );
  });

  testWidgets('an effect section can ask for more room', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        ComponentDocPage(
          spec: ComponentDocSpec(
            name: 'demo_effect',
            title: 'Demo Effect',
            description: 'A field of stars.',
            sections: <DocsPageSection>[
              EffectSection(
                id: 'applied',
                title: 'Applied',
                host: const SizedBox(height: 120, width: 200),
                code: 'AmbientPattern()',
                minHeight: space(160),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.getSize(find.byType(DocsShowcaseFrame)).height, space(160));
  });

  testWidgets('a showcase section can shorten its own stage', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        ComponentDocPage(
          spec: ComponentDocSpec(
            name: 'button',
            title: 'Button',
            description: 'A control.',
            sections: <DocsPageSection>[
              ShowcaseSection(
                id: 'ghost',
                title: 'Ghost',
                specimen: const SizedBox(height: 40, width: 100),
                code: 'x',
                minHeight: space(48),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.getSize(find.byType(DocsShowcaseFrame)).height, space(48));
  });

  testWidgets('a disclosure prints its title once, not twice', (
    WidgetTester tester,
  ) async {
    // `DocsDisclosure`'s trigger row IS the heading — a title with the
    // chevron that opens it beside the title. `DocsSection` printed its own
    // `.type-h3` above that, so every one of the eight trailing disclosures
    // on every one of the ninety-nine pages showed its name twice, stacked.
    // Caught in a capture of the rendered page, not by any test, which is
    // why this one exists.
    tester.view.physicalSize = const Size(1440, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        const ComponentDocPage(
          spec: ComponentDocSpec(
            name: 'x',
            title: 'X',
            description: 'd',
            sections: <DocsPageSection>[
              DisclosureSection(
                id: 'theming',
                title: 'Theming',
                description: 'What it reads.',
                child: Text('tokens'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Theming'), findsOneWidget);
    // The description still renders — only the duplicated heading is gone,
    // so a reader still learns what the disclosure holds before opening it.
    expect(find.text('What it reads.'), findsOneWidget);
    // And the anchor is still registered, so the rail still scrolls here.
    expect(DocsAnchor.keyFor('theming').currentContext, isNotNull);
  });

  testWidgets('a non-disclosure section still prints its heading', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        const ComponentDocPage(
          spec: ComponentDocSpec(
            name: 'x',
            title: 'X',
            description: 'd',
            sections: <DocsPageSection>[
              SnippetSection(id: 'usage', title: 'Usage', code: 'x'),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Usage'), findsOneWidget);
  });
}
