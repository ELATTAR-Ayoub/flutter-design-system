/// Theming page rendering tests.
///
/// The page's claim is that nothing on it is written down: every swatch is
/// the colour the page is painted with, and the role groups are read out of
/// `ThemeTokens` live. So the tests here drive the theme and check the
/// swatches followed, rather than checking that a heading exists.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs_pages/theming_page.dart';
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

Widget _host(
  Widget child, {
  ColorMode mode = ColorMode.dark,
  double textScale = 1,
  Size size = const Size(1440, 4000),
}) => MediaQuery(
  data: MediaQueryData(size: size, textScaler: TextScaler.linear(textScale)),
  child: ThemeScope(
    controller: ThemeController(mode: mode),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SingleChildScrollView(child: child),
    ),
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
    _sizeTo(tester, const Size(1440, 4000));

    await tester.pumpWidget(_host(const ThemingDocsPage()));
    await tester.pump();

    expect(
      find.byKey(const ValueKey<String>('theming-doc-article')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('the role groups cover every named group', (
    WidgetTester tester,
  ) async {
    _sizeTo(tester, const Size(1440, 4000));

    await tester.pumpWidget(_host(const ThemingDocsPage()));
    await tester.pump();

    expect(
      find.byKey(const ValueKey<String>('theming-role-groups')),
      findsOneWidget,
    );
    for (final String group in <String>[
      'Surface',
      'Action',
      'Status',
      'Navigation',
      'Data',
    ]) {
      expect(
        find.byKey(ValueKey<String>('theming-role-group:$group')),
        findsOneWidget,
        reason: group,
      );
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('a swatch is painted with the role it names, in both themes', (
    WidgetTester tester,
  ) async {
    // The whole point of the page: if a swatch were written down rather than
    // read, flipping the theme would leave it behind.
    Future<Color> cardFillAt(ColorMode mode) async {
      await tester.pumpWidget(_host(const ThemingDocsPage(), mode: mode));
      await tester.pump();
      final Finder row = find
          .ancestor(
            of: find.text('card / cardForeground').first,
            matching: find.byType(Container),
          )
          .first;
      final Container container = tester.widget<Container>(row);
      return ((container.decoration! as BoxDecoration).color)!;
    }

    _sizeTo(tester, const Size(1440, 4000));

    final Color dark = await cardFillAt(ColorMode.dark);
    final Color light = await cardFillAt(ColorMode.light);

    expect(dark, ThemeTokens.dark.card);
    expect(light, ThemeTokens.light.card);
    expect(dark, isNot(light));
    expect(tester.takeException(), isNull);
  });

  testWidgets('the mode demo drives its own controller', (
    WidgetTester tester,
  ) async {
    _sizeTo(tester, const Size(1440, 4000));

    await tester.pumpWidget(_host(const ThemingDocsPage()));
    await tester.pump();

    for (final ColorMode mode in ColorMode.values) {
      expect(
        find.byKey(ValueKey<String>('theming-doc-mode:${mode.name}')),
        findsOneWidget,
        reason: mode.name,
      );
    }

    final Finder lightButton = find.byKey(
      const ValueKey<String>('theming-doc-mode:light'),
    );
    await tester.ensureVisible(lightButton);
    await tester.pump();
    await tester.tap(lightButton);
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('narrow and 200% text leave the page intact', (
    WidgetTester tester,
  ) async {
    _sizeTo(tester, const Size(390, 6000));

    await tester.pumpWidget(
      _host(const ThemingDocsPage(), textScale: 2, size: const Size(390, 6000)),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey<String>('theming-doc-article')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
