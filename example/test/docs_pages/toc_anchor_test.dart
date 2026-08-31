/// Every table-of-contents row on a public documentation page must land on a
/// section that exists.
///
/// A TOC row that resolves to nothing is worse than a missing row: it looks
/// like a working link, and a reader who clicks it concludes the page is
/// broken rather than that the row is. `DocsLayout` deliberately does not
/// assert on an unmarked anchor, because one is legitimate for a page that
/// has none, so the check has to live here, per page, against the anchors
/// each page actually declares.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_layout.dart';
import 'package:example/docs_pages/catalog.dart';
import 'package:example/main.dart';
import 'package:example/site/site_routes.dart';
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

Widget _harness(Widget child) => ThemeScope(
  controller: ThemeController(mode: ColorMode.dark),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SingleChildScrollView(child: child),
  ),
);

/// Every anchor the page's own [DocsLayout] declares, nested rows included.
List<String> _anchors(WidgetTester tester) {
  final DocsLayout layout = tester.widget<DocsLayout>(
    find.byType(DocsLayout).first,
  );
  final List<String> anchors = <String>[];
  void walk(List<DocsTocEntry> entries) {
    for (final DocsTocEntry entry in entries) {
      anchors.add(entry.anchor);
      walk(entry.children);
    }
  }

  walk(layout.toc);
  return anchors;
}

void main() {
  final List<String> routes = <String>[
    for (final DocsPageEntry entry in docsPageEntries) entry.route,
    skillsRoute,
  ];

  for (final String route in routes) {
    testWidgets('$route: every TOC anchor marks a section on the page', (
      WidgetTester tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1440, 900);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_harness(publicPageFor(route)));
      await tester.pump();

      final List<String> anchors = _anchors(tester);
      expect(
        anchors.isNotEmpty,
        route != docsChangelogRoute,
        reason:
            'Changelog builds its sections from CHANGELOG.md and declares no '
            'fixed table of contents; every other page declares one. A page '
            'that silently lost its TOC would otherwise pass this test '
            'vacuously.',
      );

      for (final String anchor in anchors) {
        // `DocsSection` marks its target with this key; the Skills article
        // marks its panels with `docsAnchorKey` directly. Both resolve here.
        expect(
          find.byKey(docsAnchorKey(anchor)),
          findsOneWidget,
          reason:
              '$route: the "$anchor" row has no section to scroll to, so it '
              'is a link that does nothing',
        );
      }
      expect(tester.takeException(), isNull);
    });
  }
}
