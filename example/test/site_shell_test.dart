import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/shell.dart';
import 'package:example/site/site_routes.dart';
import 'package:example/site/site_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({required AppRouter router, required Widget child}) {
  final DsThemeController theme = DsThemeController(mode: DsThemeMode.dark);
  return DsTheme(
    controller: theme,
    child: AppRouterScope(
      router: router,
      child: MaterialApp(debugShowCheckedModeBanner: false, home: child),
    ),
  );
}

extension on WidgetTester {
  void useViewport(Size size) {
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    addTearDown(view.reset);
  }
}

void main() {
  testWidgets('desktop shell renders top destinations and GitHub action', (
    WidgetTester tester,
  ) async {
    tester.useViewport(const Size(1440, 900));
    final AppRouter router = AppRouter(route: homeRoute);
    int githubTaps = 0;

    await tester.pumpWidget(
      _harness(
        router: router,
        child: SiteShell(
          route: router.route,
          onOpenGitHub: () => githubTaps++,
          child: const SizedBox(height: 200, child: Text('Body')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Documentation'), findsWidgets);
    expect(find.text('Components'), findsWidgets);
    expect(find.text('Shots'), findsWidgets);
    expect(find.text('Skills'), findsWidgets);

    await tester.tap(find.bySemanticsLabel('Open GitHub repository').first);
    await tester.pump();
    expect(githubTaps, 1);
  });

  testWidgets('search opens, navigates, and exposes an empty state', (
    WidgetTester tester,
  ) async {
    tester.useViewport(const Size(1440, 900));
    final AppRouter router = AppRouter(route: homeRoute);

    await tester.pumpWidget(
      _harness(
        router: router,
        child: SiteShell(
          route: router.route,
          child: const SizedBox(height: 200, child: Text('Body')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Search documentation'));
    await tester.pumpAndSettle();

    expect(find.text('Search the public site'), findsOneWidget);
    expect(find.text('Quick open'), findsOneWidget);
    expect(find.text('Documentation'), findsWidgets);

    await tester.enterText(find.byType(EditableText).first, 'buttons');
    await tester.pumpAndSettle();
    expect(find.text('Components'), findsWidgets);

    await tester.tap(find.text('Buttons').first);
    await tester.pumpAndSettle();
    expect(router.route, '/design-system/components/base/buttons');

    await tester.tap(find.bySemanticsLabel('Search documentation'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).first, 'not-a-real-route');
    await tester.pumpAndSettle();
    expect(find.text('Nothing matched that search'), findsOneWidget);

    await tester.tap(find.text('Open documentation'));
    await tester.pumpAndSettle();
    expect(router.route, docsRoute);
  });

  testWidgets('mobile shell opens navigation sheet and routes from it', (
    WidgetTester tester,
  ) async {
    tester.useViewport(const Size(390, 844));
    final AppRouter router = AppRouter(route: homeRoute);
    int githubTaps = 0;

    await tester.pumpWidget(
      _harness(
        router: router,
        child: SiteShell(
          route: router.route,
          onOpenGitHub: () => githubTaps++,
          child: const SizedBox(height: 200, child: Text('Body')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Open site navigation'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Open site navigation'));
    await tester.pumpAndSettle();

    expect(find.byType(DsSheetPanel), findsOneWidget);
    expect(find.text('DESIGN SYSTEM'), findsWidgets);

    await tester.tap(find.text('GitHub').first);
    await tester.pumpAndSettle();
    expect(githubTaps, 1);

    await tester.tap(find.bySemanticsLabel('Open site navigation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skills').last);
    await tester.pumpAndSettle();
    expect(router.route, skillsRoute);
    expect(find.byType(DsSheetPanel), findsNothing);
  });
}
