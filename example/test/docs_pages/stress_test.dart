/// Every public documentation route, at the two widths and the text scale
/// that break layouts, in both themes.
///
/// The per-page suites each prove what is specific to their page. This one
/// proves the property they share and none of them owns: that no route
/// overflows when a reader is on a phone, or has asked their platform for
/// text at 200%, or both. A long command line, a nine-column table and a
/// specimen sheet all fail this differently, and all of them ship on these
/// eight routes.
///
/// `pump()`, never `pumpAndSettle()`: several of these pages render an
/// `Alert`, whose surface animation repeats forever, so settling never
/// returns. Two extra frames give the async pages (Registry, Changelog) time
/// to resolve their loaders past the skeleton.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
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

/// Tall enough that a whole article lays out in one pass, so an overflow
/// anywhere down the page is reported rather than never built.
const Size _narrow = Size(390, 8000);
const Size _wide = Size(1440, 8000);

/// The eight routes this task owns.  is the ninth row of the
/// Sections rail and belongs to `components_docs/`.
final List<String> _routes = <String>[
  for (final DocsPageEntry entry in docsPageEntries) entry.route,
  skillsRoute,
];

Future<void> _pumpRoute(
  WidgetTester tester,
  String route, {
  required Size size,
  required ColorMode mode,
  required double textScale,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);

  final ThemeController controller = ThemeController(mode: mode);
  addTearDown(controller.dispose);

  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(
        size: size,
        textScaler: TextScaler.linear(textScale),
      ),
      child: ThemeScope(
        controller: controller,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SingleChildScrollView(child: publicPageFor(route)),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 32));
  await tester.pump(const Duration(milliseconds: 32));
}

void main() {
  test('the stress matrix covers every documentation route', () {
    // Eight, and counted: a route added to the catalog would otherwise be
    // stressed by nothing and nobody would know. `/components` is the ninth
    // row of the Sections rail and is not one of these: it is owned by
    // `components_docs/`, which has its own suites.
    expect(_routes.length, docsPageEntries.length + 1);
    expect(_routes.length, 8);
    expect(_routes, contains(docsTypesetRoute));
    expect(_routes, contains(skillsRoute));
  });

  for (final String route in _routes) {
    testWidgets('$route: 390px at 200% text, dark', (
      WidgetTester tester,
    ) async {
      await _pumpRoute(
        tester,
        route,
        size: _narrow,
        mode: ColorMode.dark,
        textScale: 2,
      );
      expect(
        tester.takeException(),
        isNull,
        reason: '$route overflows on a phone at 200% text',
      );
    });

    testWidgets('$route: 1440px at 200% text, light', (
      WidgetTester tester,
    ) async {
      await _pumpRoute(
        tester,
        route,
        size: _wide,
        mode: ColorMode.light,
        textScale: 2,
      );
      expect(
        tester.takeException(),
        isNull,
        reason: '$route overflows at desktop width and 200% text',
      );
    });
  }
}
