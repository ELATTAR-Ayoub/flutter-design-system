import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/separator/meta.dart';
import 'package:example/components_docs/separator/page.dart';
import 'package:example/kit.dart' show DsSection;
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

        // Flip the SAME controller in place, not a fresh widget tree: the
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

    testWidgets(
      'renders the shadcn-shaped section list, in order: shared frame '
      'sections, then each component\'s own promoted sections, then API '
      'Reference, then the six extra sections',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: DsThemeController(mode: DsThemeMode.dark),
            child: const SeparatorDocPage(),
          ),
        );

        final List<String> sectionIds = tester
            .widgetList<DsSection>(find.byType(DsSection))
            .map((DsSection section) => section.id)
            .toList();

        expect(sectionIds, <String>[
          'install',
          'usage',
          'composition',
          'separator-vertical',
          'separator-list',
          'separator-menu',
          'empty-input-group',
          'kbd-group',
          'kbd-button',
          'kbd-input-group',
          'api',
          'states',
          'accessibility',
          'responsive',
          'dependencies',
          'theming',
          'source',
        ]);

        // No leftover "Overview" or "Variants" headings: their content
        // moved into hero prose (no heading) and into API Reference.
        expect(find.text('Overview'), findsNothing);
        expect(find.text('Variants and sizes'), findsNothing);

        // Every promoted section names the component it belongs to. Scoped
        // to the article: at this width (1440, >= DsBreakpoints.xl) the "ON
        // THIS PAGE" rail is showing too, and it lists every one of these
        // same titles again as a TOC entry (docs_layout.dart's
        // _TableOfContents renders DsText(entry.title, ...) verbatim for
        // each DocsTocEntry). That is by design, on both the old Row rail
        // and today's Positioned one alike, so a plain find.text here would
        // legitimately find two matches, not a rendering defect. Scoping to
        // the article is what makes the assertion mean what its own comment
        // says: the section *heading*, not any incidental mention.
        final Finder article = find.byKey(
          const ValueKey<String>('separator-doc-article'),
        );
        for (final String title in <String>[
          'Separator: Vertical',
          'Separator: List',
          'Separator: Menu',
          'Empty: Input group',
          'Kbd: Group',
          'Kbd: Button',
          'Kbd: Input group',
        ]) {
          expect(
            find.descendant(of: article, matching: find.text(title)),
            findsOneWidget,
            reason: 'missing $title',
          );
        }

        expect(
          find.descendant(of: article, matching: find.text('API Reference')),
          findsOneWidget,
        );
      },
    );
  });
}
