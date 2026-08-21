import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/site/pages/public_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) => DsTheme(
  controller: DsThemeController(mode: DsThemeMode.dark),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SingleChildScrollView(child: child),
  ),
);

void main() {
  testWidgets('home exposes the foundation-first quickstart', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_harness(const PublicHomePage()));

    expect(find.text('Build the interface\nyou mean.'), findsOneWidget);
    expect(find.text('One command to begin.'), findsOneWidget);
    expect(
      find.text('dart run elattar_cli init --foundation source'),
      findsOneWidget,
    );
    expect(find.text('Start building'), findsOneWidget);
  });

  testWidgets('public page actions report their route without owning routing', (
    WidgetTester tester,
  ) async {
    final List<String> routes = <String>[];
    await tester.pumpWidget(_harness(PublicHomePage(onNavigate: routes.add)));

    final Finder docsAction = find.text('Read the docs');
    await tester.ensureVisible(docsAction);
    await tester.tap(docsAction);
    await tester.pump();
    expect(routes, <String>[publicDocsRoute]);
  });

  testWidgets('components page renders installable docs and legacy groups', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_harness(const PublicComponentsPage()));

    expect(find.text('Base Components'), findsOneWidget);
    expect(find.text('Agent'), findsOneWidget);
    expect(find.text('Buttons'), findsOneWidget);
    expect(find.text('Console'), findsOneWidget);
    expect(find.text('Ready to install'), findsOneWidget);
    expect(find.text('Button'), findsOneWidget);
    expect(find.text('elattar add button'), findsOneWidget);
  });

  testWidgets('shots and skills remain useful at a narrow viewport', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_harness(const PublicShotsPage()));
    expect(find.text('Shots'), findsOneWidget);
    expect(find.text('Signal Studio'), findsOneWidget);

    await tester.pumpWidget(_harness(const PublicSkillsPage()));
    expect(find.text('Skills'), findsOneWidget);
    expect(find.text('A shared way of working.'), findsOneWidget);
  });
}
