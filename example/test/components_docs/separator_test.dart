import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/separator/meta.dart';
import 'package:example/components_docs/separator/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required DsThemeController controller,
}) => DsTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

void main() {
  group('separator docs page (separator, empty, kbd)', () {
    testWidgets(
      'renders the article, the API tables for all three primitives, and a '
      'live specimen of each',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: DsThemeController(mode: DsThemeMode.dark),
            child: SeparatorDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('separator-doc-article')),
          findsOneWidget,
        );

        // The API tables list every constructor parameter found in
        // separator.dart, empty.dart, and kbd.dart.
        for (final String param in <String>[
          // DsSeparator
          'orientation',
          // DsEmpty family
          'children',
          'glyph',
          'tone',
          'text',
          // DsKbd family already covered by 'text' and 'children' above.
        ]) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        // Live specimens of every real widget mount.
        expect(
          find.byWidgetPredicate(
            (Widget w) =>
                w is DsSeparator &&
                w.orientation == DsSeparatorOrientation.horizontal,
          ),
          findsWidgets,
        );
        expect(
          find.byWidgetPredicate(
            (Widget w) =>
                w is DsSeparator &&
                w.orientation == DsSeparatorOrientation.vertical,
          ),
          findsWidgets,
        );
        expect(find.byType(DsEmpty), findsWidgets);
        expect(find.byType(DsEmptyHeader), findsWidgets);
        expect(find.byType(DsEmptyMedia), findsWidgets);
        expect(find.byType(DsEmptyTitle), findsWidgets);
        expect(find.byType(DsEmptyDescription), findsWidgets);
        expect(find.byType(DsEmptyContent), findsWidgets);
        expect(find.byType(DsKbd), findsWidgets);
        expect(find.byType(DsKbdGroup), findsWidgets);

        expect(separatorDoc.name, 'separator');
        expect(
          separatorDoc.exports,
          containsAll(<String>[
            'DsSeparator',
            'DsSeparatorOrientation',
            'DsEmpty',
            'DsEmptyHeader',
            'DsEmptyMedia',
            'DsEmptyTitle',
            'DsEmptyDescription',
            'DsEmptyContent',
            'DsKbd',
            'DsKbdGroup',
          ]),
        );
        expect(destination, isNull);
      },
    );

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: DsThemeController(mode: DsThemeMode.dark),
            child: const SeparatorDocPage(),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('separator-doc-article')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'the separator specimen reads the live theme and repaints when it '
      'flips, in place',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final DsThemeController controller = DsThemeController(
          mode: DsThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const SeparatorDocPage()),
        );

        final Finder horizontalKey = find.byKey(
          const ValueKey<String>('separator-preview:horizontal'),
        );
        expect(horizontalKey, findsOneWidget);
        final ColoredBox darkBox = tester.widget<ColoredBox>(
          find
              .descendant(of: horizontalKey, matching: find.byType(ColoredBox))
              .first,
        );
        final Color darkColor = darkBox.color;

        // Flip the SAME controller in place — not a fresh widget tree — the
        // same object every real theme toggle mutates.
        controller.setMode(DsThemeMode.light);
        await tester.pump();

        final ColoredBox lightBox = tester.widget<ColoredBox>(
          find
              .descendant(of: horizontalKey, matching: find.byType(ColoredBox))
              .first,
        );
        final Color lightColor = lightBox.color;

        expect(
          lightColor,
          isNot(darkColor),
          reason:
              'the separator hairline is theme.border and must actually '
              'move when the live theme flips, not just render once',
        );
      },
    );
  });
}
