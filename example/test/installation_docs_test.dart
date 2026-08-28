/// Installation page rendering tests.
///
/// The mechanical part of moving this page onto `DocsSnippet` is covered by
/// `docs/docs_snippet_test.dart` for the primitive itself and by
/// `docs_pages_routing_test.dart` for the route wiring. What neither of those
/// proves is the one behaviour specific to this page: that the "Set up a
/// project" listing, the longest command block on the page, actually renders
/// with its expansion control collapsed, and that the control opens and
/// closes it — not just that `maxHeight` was set and assumed to work.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_snippet.dart';
import 'package:example/docs_pages/installation_page.dart';
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

Widget _host(Widget child) => ThemeScope(
  controller: ThemeController(mode: ColorMode.dark),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SingleChildScrollView(child: child),
  ),
);

void _sizeTo(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('the page mounts its article with no exception', (
    WidgetTester tester,
  ) async {
    _sizeTo(tester, const Size(1440, 3200));

    await tester.pumpWidget(_host(const InstallationDocsPage()));
    await tester.pump();

    expect(
      find.byKey(const ValueKey<String>('installation-doc-article')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'the "Set up a project" listing is capped, and its expansion control '
    'actually expands and collapses it',
    (WidgetTester tester) async {
      _sizeTo(tester, const Size(1440, 3200));

      await tester.pumpWidget(_host(const InstallationDocsPage()));
      await tester.pump();

      // Exactly one snippet on this page is capped — `DocsSnippet` only
      // wraps itself in a `DocsSnippetOverflow` when `maxHeight` is given —
      // so finding it at all is itself proof the cap reached the widget.
      final Finder overflow = find.byType(DocsSnippetOverflow);
      expect(overflow, findsOneWidget);
      expect(find.text('Show more'), findsOneWidget);
      expect(find.text('Show less'), findsNothing);

      final double collapsedHeight = tester.getSize(overflow).height;

      await tester.ensureVisible(find.text('Show more'));
      await tester.pump();
      await tester.tap(find.text('Show more'));
      await tester.pump();
      await tester.pump(MotionDurations.open);

      expect(find.text('Show less'), findsOneWidget);
      expect(find.text('Show more'), findsNothing);
      final double expandedHeight = tester.getSize(overflow).height;
      expect(expandedHeight, greaterThan(collapsedHeight));

      await tester.ensureVisible(find.text('Show less'));
      await tester.pump();
      await tester.tap(find.text('Show less'));
      await tester.pump();
      await tester.pump(MotionDurations.open);

      expect(find.text('Show more'), findsOneWidget);
      expect(tester.getSize(overflow).height, collapsedHeight);

      expect(tester.takeException(), isNull);
    },
  );
}
