import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({required Widget child, required Size size}) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: DsTheme(
      controller: DsThemeController(mode: DsThemeMode.dark),
      child: MaterialApp(home: SingleChildScrollView(child: child)),
    ),
  );
}

DocsLayout _layout({required Widget child}) => DocsLayout(
  route: '/docs',
  intro: const DocsPageIntro(
    eyebrow: 'DOCUMENTATION',
    title: 'Build from the foundation',
    description:
        'A long description that should remain readable at every supported width.',
  ),
  breadcrumbs: const <DsBreadcrumbEntry>[
    DsBreadcrumbEntry.link('Docs'),
    DsBreadcrumbEntry.page('Foundations'),
  ],
  sidebar: const <DocsSidebarEntry>[
    DocsSidebarEntry(title: 'Introduction', route: '/docs', selected: true),
    DocsSidebarEntry(title: 'Installation', route: '/docs/install'),
  ],
  toc: const <DocsTocEntry>[
    DocsTocEntry(title: 'Overview', anchor: '#overview'),
    DocsTocEntry(title: 'Usage', anchor: '#usage'),
  ],
  previous: const DocsPageLink(title: 'Introduction', route: '/docs'),
  next: const DocsPageLink(title: 'Installation', route: '/docs/install'),
  child: child,
);

void main() {
  testWidgets('wide layout exposes sidebar, article, and table of contents', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        size: const Size(1440, 900),
        child: _layout(child: DsText('Article body', DsType.body)),
      ),
    );

    expect(
      find.byKey(const ValueKey<String>('docs-layout-sidebar')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('docs-layout-article')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('docs-layout-toc')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey<String>('docs-layout-prev-next')),
      findsOneWidget,
    );
  });

  testWidgets('narrow layout prioritizes article and exposes anchor strip', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        size: const Size(390, 844),
        child: _layout(child: DsText('Article body', DsType.body)),
      ),
    );

    expect(
      find.byKey(const ValueKey<String>('docs-layout-sidebar')),
      findsNothing,
    );
    expect(find.byKey(const ValueKey<String>('docs-layout-toc')), findsNothing);
    expect(
      find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
      findsOneWidget,
    );
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Usage'), findsOneWidget);
  });

  testWidgets('large text scale keeps the article mounted without overflow', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(390, 844),
          textScaler: TextScaler.linear(2),
        ),
        child: DsTheme(
          controller: DsThemeController(mode: DsThemeMode.light),
          child: MaterialApp(
            home: SingleChildScrollView(
              child: _layout(
                child: DsText(
                  'Article body with enough text to exercise wrapping.',
                  DsType.body,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      find.byKey(const ValueKey<String>('docs-layout-article')),
      findsOneWidget,
    );
    expect(find.text('Build from the foundation'), findsOneWidget);
  });

  testWidgets(
    'navigation callbacks are wired for sidebar, anchors, and pager',
    (WidgetTester tester) async {
      final List<String> routes = <String>[];
      await tester.pumpWidget(
        _harness(
          size: const Size(1440, 900),
          child: DocsLayout(
            route: '/docs',
            intro: const DocsPageIntro(
              eyebrow: 'DOCS',
              title: 'Page',
              description: 'Description',
            ),
            sidebar: const <DocsSidebarEntry>[
              DocsSidebarEntry(title: 'Install', route: '/install'),
            ],
            toc: const <DocsTocEntry>[
              DocsTocEntry(title: 'Usage', anchor: '#usage'),
            ],
            next: const DocsPageLink(title: 'Next', route: '/next'),
            onNavigate: routes.add,
            child: DsText('Body', DsType.body),
          ),
        ),
      );

      await tester.tap(find.text('Install'));
      await tester.tap(find.text('Usage'));
      await tester.ensureVisible(find.text('Next'));
      await tester.tap(find.text('Next'));
      expect(routes, <String>['/install', '#usage', '/next']);
    },
  );
}
