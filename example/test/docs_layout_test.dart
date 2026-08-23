import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_layout.dart';
import 'package:example/kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required Size size,
  ScrollController? controller,
}) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: DsTheme(
      controller: DsThemeController(mode: DsThemeMode.dark),
      child: MaterialApp(
        home: SingleChildScrollView(controller: controller, child: child),
      ),
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
    DocsTocEntry(title: 'Overview', anchor: 'overview'),
    DocsTocEntry(title: 'Usage', anchor: 'usage'),
  ],
  previous: const DocsPageLink(title: 'Introduction', route: '/docs'),
  next: const DocsPageLink(title: 'Installation', route: '/docs/install'),
  child: child,
);

/// An article deep enough to scroll, with `usage` marked the way the component,
/// Shot and Skill articles mark their sections.
Widget _tallArticle({Key? usageKey}) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: <Widget>[
    const SizedBox(height: 900),
    KeyedSubtree(
      key: usageKey ?? docsAnchorKey('usage'),
      child: DsText('The usage section body', DsType.body),
    ),
    const SizedBox(height: 2400),
  ],
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

  testWidgets('navigation callbacks are wired for sidebar and pager', (
    WidgetTester tester,
  ) async {
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
            DocsTocEntry(title: 'Usage', anchor: 'usage'),
          ],
          next: const DocsPageLink(title: 'Next', route: '/next'),
          onNavigate: routes.add,
          child: DsText('Body', DsType.body),
        ),
      ),
    );

    await tester.tap(find.text('Install'));
    await tester.ensureVisible(find.text('Next'));
    await tester.tap(find.text('Next'));
    expect(routes, <String>['/install', '/next']);
  });

  group('an anchor scrolls the article; it never routes', () {
    // Catches: restoring `onNavigate(entry.anchor)` in `_TableOfContents`.
    //
    // A bare anchor id handed to the router matches no route, so `main.dart`
    // fell through to the docs-shell placeholder — eyebrow "DESIGN SYSTEM",
    // title "Not found" — and swapped the public chrome for the documentation
    // chrome. The old assertion in this file (`routes` ending up as
    // `['/install', '#usage', '/next']`) codified exactly that, which is why a
    // green suite shipped it.
    testWidgets(
      'the desktop "ON THIS PAGE" rail scrolls, and calls no router',
      (WidgetTester tester) async {
        final List<String> routes = <String>[];
        final ScrollController page = ScrollController();
        addTearDown(page.dispose);

        await tester.pumpWidget(
          _harness(
            size: const Size(1440, 900),
            controller: page,
            child: DocsLayout(
              route: '/docs',
              intro: const DocsPageIntro(
                eyebrow: 'DOCS',
                title: 'Page',
                description: 'Description',
              ),
              toc: const <DocsTocEntry>[
                DocsTocEntry(title: 'Usage', anchor: 'usage'),
              ],
              onNavigate: routes.add,
              child: _tallArticle(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(page.offset, 0);

        await tester.tap(
          find.byKey(const ValueKey<String>('docs-layout-toc-entry:usage')),
        );
        await tester.pumpAndSettle();

        expect(routes, isEmpty, reason: 'an anchor is not a route');
        expect(
          page.offset,
          greaterThan(0),
          reason: 'the rail entry was inert — it targeted nothing',
        );
      },
    );

    // Catches: restoring `onNavigate(entry.anchor)` in `_AnchorStrip`. This is
    // the arm the auditor reproduced at 768x1024: tapping "Overview" or
    // "Files" on `/skills` replaced the page with "No page yet."
    testWidgets('the mobile anchor strip scrolls, and calls no router', (
      WidgetTester tester,
    ) async {
      final List<String> routes = <String>[];
      final ScrollController page = ScrollController();
      addTearDown(page.dispose);

      await tester.pumpWidget(
        _harness(
          size: const Size(768, 1024),
          controller: page,
          child: DocsLayout(
            route: '/docs',
            intro: const DocsPageIntro(
              eyebrow: 'DOCS',
              title: 'Page',
              description: 'Description',
            ),
            toc: const <DocsTocEntry>[
              DocsTocEntry(title: 'Usage', anchor: 'usage'),
            ],
            onNavigate: routes.add,
            child: _tallArticle(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsOneWidget,
      );
      expect(page.offset, 0);

      await tester.tap(
        find.byKey(const ValueKey<String>('docs-layout-anchor-chip:usage')),
      );
      await tester.pumpAndSettle();

      expect(routes, isEmpty, reason: 'an anchor is not a route');
      expect(page.offset, greaterThan(0));
    });

    // The dialog, input and select guides mark no anchors of their own: they
    // are built out of `kit.dart`'s `DsSection`s whose ids already *are* their
    // TOC anchors. This is the arm that resolves those, and it is why
    // `kit.dart` needed no change.
    testWidgets('a kit DsSection id resolves without any extra marking', (
      WidgetTester tester,
    ) async {
      final List<String> routes = <String>[];
      final ScrollController page = ScrollController();
      addTearDown(page.dispose);

      await tester.pumpWidget(
        _harness(
          size: const Size(1440, 900),
          controller: page,
          child: DocsLayout(
            route: '/components/input',
            intro: const DocsPageIntro(
              eyebrow: 'COMPONENT',
              title: 'Input',
              description: 'Description',
            ),
            toc: const <DocsTocEntry>[
              DocsTocEntry(title: 'States', anchor: 'states'),
            ],
            onNavigate: routes.add,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 900),
                DsSection(
                  id: 'states',
                  title: 'States',
                  child: DsText('State matrix', DsType.body),
                ),
                const SizedBox(height: 2400),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey<String>('docs-layout-toc-entry:states')),
      );
      await tester.pumpAndSettle();

      expect(routes, isEmpty);
      expect(page.offset, greaterThan(0));
    });

    // An anchor with no target is inert — and inert is the *correct* failure.
    // It must not fall through to the router, which is what turned a missing
    // anchor into a "Not found" page in the wrong shell.
    testWidgets('an unmarked anchor scrolls nothing and still routes nothing', (
      WidgetTester tester,
    ) async {
      final List<String> routes = <String>[];
      final ScrollController page = ScrollController();
      addTearDown(page.dispose);

      await tester.pumpWidget(
        _harness(
          size: const Size(1440, 900),
          controller: page,
          child: DocsLayout(
            route: '/docs',
            intro: const DocsPageIntro(
              eyebrow: 'DOCS',
              title: 'Page',
              description: 'Description',
            ),
            toc: const <DocsTocEntry>[
              DocsTocEntry(title: 'Nowhere', anchor: 'nowhere'),
            ],
            onNavigate: routes.add,
            child: _tallArticle(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey<String>('docs-layout-toc-entry:nowhere')),
      );
      await tester.pumpAndSettle();

      expect(routes, isEmpty);
      expect(page.offset, 0);
    });
  });
}
