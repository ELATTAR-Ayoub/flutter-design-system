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

/// An article deep enough to scroll, with `usage` marked the way the component
/// and Skill articles mark their sections.
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
  testWidgets(
    'wide layout pins the sidebar left, the toc right, and centers the '
    'reading column between them',
    (WidgetTester tester) async {
      // Reproduces the reference shape at https://ui.shadcn.com/docs/components:
      // the rails sit at the edges of the box the layout is given, and only
      // the reading column is held to a fixed measure and centered in what is
      // left over. This harness gives DocsLayout the full 1920 as its own box
      // (the same shape the existing tests above already use), the way it is
      // handed a full box today once nothing above it narrows that box first.
      //
      // The `MediaQuery` override alone only changes what `MediaQuery.of()`
      // reports: it does not resize the real test surface, so the actual
      // incoming constraints stayed the harness default (800x600) while this
      // test asked for absolute pixel positions against 1920. Setting the
      // view itself, the way `button_test.dart`'s desktop cases already do,
      // is what makes the two agree.
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _harness(
          size: const Size(1920, 1080),
          child: _layout(child: _tallArticle()),
        ),
      );
      await tester.pumpAndSettle();

      final Rect sidebar = tester.getRect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
      );
      final Rect article = tester.getRect(
        find.byKey(const ValueKey<String>('docs-layout-article')),
      );
      final Rect toc = tester.getRect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
      );

      const double tolerance = 1;
      expect(sidebar.left, closeTo(0, tolerance));
      expect(toc.right, closeTo(1920, tolerance));

      final double between = toc.left - sidebar.right;
      expect(
        article.width,
        lessThan(between),
        reason:
            'the reading column must not fill every pixel left between '
            'the rails',
      );

      final double leftGap = article.left - sidebar.right;
      final double rightGap = toc.left - article.right;
      expect(
        leftGap,
        closeTo(rightGap, tolerance),
        reason:
            'the reading column is centered in the space between the '
            'rails, not pinned to one side of it',
      );
    },
  );

  testWidgets(
    'a sidebar entry and a toc entry both wear a pointer cursor on hover',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _harness(
          size: const Size(1920, 1080),
          child: _layout(child: _tallArticle()),
        ),
      );
      await tester.pumpAndSettle();

      bool wearsClickCursor(Key key) {
        final Iterable<MouseRegion> regions = tester.widgetList<MouseRegion>(
          find.ancestor(
            of: find.byKey(key),
            matching: find.byType(MouseRegion),
          ),
        );
        return regions.any(
          (MouseRegion region) => region.cursor == SystemMouseCursors.click,
        );
      }

      expect(
        wearsClickCursor(const ValueKey<String>('docs-sidebar:/docs')),
        isTrue,
        reason: 'a sidebar row is a tap target and must read as one',
      );
      expect(
        wearsClickCursor(
          const ValueKey<String>('docs-layout-toc-entry:overview'),
        ),
        isTrue,
        reason: 'a toc row is a tap target and must read as one',
      );
    },
  );

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
    // Matches the real test surface to the `MediaQuery` size below: without
    // it the rails still position themselves against 1440, landing outside
    // the harness default 800x600 surface, and `tester.tap` misses them.
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
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
        // Matches the real test surface to the `MediaQuery` size below: see
        // the note on 'navigation callbacks are wired for sidebar and pager'.
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
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
      // Matches the real test surface to the `MediaQuery` size below: see
      // the note on 'navigation callbacks are wired for sidebar and pager'.
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
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
      // Matches the real test surface to the `MediaQuery` size below: see
      // the note on 'navigation callbacks are wired for sidebar and pager'.
      // Without it the tap below misses the rail entirely (a hit-test
      // warning, not a failure) and this test would pass for the wrong
      // reason: a miss also leaves `routes` empty and `page.offset` at 0.
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
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
