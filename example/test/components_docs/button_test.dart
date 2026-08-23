import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/button/meta.dart';
import 'package:example/components_docs/button/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required DsThemeController controller,
}) => DsTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

/// Every named constructor parameter `DsButton`'s own class declares
/// (`lib/src/components/button.dart`), excluding `key` — the same set the
/// page's `DsButton` [DocsApiTable] claims to cover.
const List<String> _buttonConstructorParams = <String>[
  'child',
  'variant',
  'size',
  'emphasis',
  'loading',
  'onPressed',
  'label',
  'focusNode',
  'padding',
  'surface',
  'expanded',
  'suppressPressScale',
  'radius',
  'autoHeight',
  'contentAlignment',
];

void main() {
  group('button docs page', () {
    testWidgets(
      'renders the article, the full API table, and a live specimen of '
      'every DsButtonVariant and DsButtonSize the Examples section claims',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: DsThemeController(mode: DsThemeMode.dark),
            child: ButtonDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // One frame is enough — nothing on this page loops except the
        // premium button's foil shimmer, which must never be settled on.
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('button-doc-article')),
          findsOneWidget,
        );

        // Every DsButton constructor parameter is named in the DsButton
        // API table.
        for (final String param in _buttonConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        // Every DsButtonVariant enum value is named in the DsButtonVariant
        // table, and every DsButtonSize value in the DsButtonSize table.
        for (final DsButtonVariant variant in DsButtonVariant.values) {
          expect(
            find.text(variant.name),
            findsWidgets,
            reason: 'DsButtonVariant.${variant.name} missing from API table',
          );
        }
        for (final DsButtonSize size in DsButtonSize.values) {
          expect(
            find.text(size.name),
            findsWidgets,
            reason: 'DsButtonSize.${size.name} missing from API table',
          );
        }

        // A live DsButton specimen of every variant mounts somewhere on
        // the page — the Examples section's own promise, not just the API
        // table's prose.
        final Set<DsButtonVariant> mountedVariants = tester
            .widgetList<DsButton>(find.byType(DsButton))
            .map((DsButton button) => button.variant)
            .toSet();
        expect(mountedVariants, containsAll(DsButtonVariant.values));

        // A live specimen of every DsButtonSize rung mounts too — the
        // Icon example covers the four squares, the Sizes example covers
        // the five text rungs.
        final Set<DsButtonSize> mountedSizes = tester
            .widgetList<DsButton>(find.byType(DsButton))
            .map((DsButton button) => button.size)
            .toSet();
        expect(mountedSizes, containsAll(DsButtonSize.values));

        // Every example specimen this page's own source keys carries its
        // key on the page.
        for (final String key in <String>[
          'button-preview:hero',
          'button-example:default',
          'button-example:premium',
          'button-example:secondary',
          'button-example:destructive',
          'button-example:outline',
          'button-example:ghost',
          'button-example:link',
          'button-example:icon-iconXs',
          'button-example:icon-iconSm',
          'button-example:icon-icon',
          'button-example:icon-iconLg',
          'button-example:with-icon',
          'button-example:loading',
          'button-example:disabled',
          'button-example:sizes-xs',
          'button-example:sizes-sm',
          'button-example:sizes-md',
          'button-example:sizes-lg',
          'button-example:sizes-xl',
          'button-example:emphasis',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        // The Loading example specimen actually carries loading: true, and
        // the Disabled example actually carries a null onPressed — the two
        // states are not just labelled, they are real.
        final DsButton loadingButton = tester.widget<DsButton>(
          find.descendant(
            of: find.byKey(const ValueKey<String>('button-example:loading')),
            matching: find.byType(DsButton),
          ),
        );
        expect(loadingButton.loading, isTrue);

        final DsButton disabledButton = tester.widget<DsButton>(
          find.descendant(
            of: find.byKey(const ValueKey<String>('button-example:disabled')),
            matching: find.byType(DsButton),
          ),
        );
        expect(disabledButton.onPressed, isNull);

        // The Emphasis example actually carries DsButtonEmphasis.caps.
        final DsButton capsButton = tester.widget<DsButton>(
          find.descendant(
            of: find.byKey(const ValueKey<String>('button-example:emphasis')),
            matching: find.byType(DsButton),
          ),
        );
        expect(capsButton.emphasis, DsButtonEmphasis.caps);

        expect(buttonDoc.name, 'button');
        expect(
          buttonDoc.exports,
          containsAll(<String>[
            'DsButton',
            'DsButtonVariant',
            'DsButtonSize',
            'DsButtonEmphasis',
            'DsButtonSurface',
          ]),
        );
        expect(buttonDoc.command, 'elattar add button');
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
            child: const ButtonDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('button-doc-article')),
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
      'survives a live theme flip in place, at desktop width, without '
      'losing any example specimen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final DsThemeController controller = DsThemeController(
          mode: DsThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const ButtonDocPage()),
        );
        await tester.pump();

        final DsThemeData darkTheme = DsTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('button-doc-article')),
          ),
        );

        // Flip the SAME controller in place — not a fresh widget tree —
        // the same object every real theme toggle mutates. A single
        // `pump()`, never `pumpAndSettle()`: the premium example's foil
        // shimmer is a genuinely looping animation and would hang it.
        controller.setMode(DsThemeMode.light);
        await tester.pump();

        final DsThemeData lightTheme = DsTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('button-doc-article')),
          ),
        );

        // The flip actually reached the page's own subtree. `primary` is
        // deliberately the same token in both themes (theme.dart: "Same in
        // both") — `background` and `foreground` are the pair that
        // actually inverts.
        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        // Nothing was lost across the flip — every specimen key is still
        // mounted exactly once.
        for (final String key in <String>[
          'button-example:default',
          'button-example:premium',
          'button-example:secondary',
          'button-example:destructive',
          'button-example:outline',
          'button-example:ghost',
          'button-example:link',
          'button-example:with-icon',
          'button-example:loading',
          'button-example:disabled',
          'button-example:emphasis',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }

        final Set<DsButtonVariant> mountedVariants = tester
            .widgetList<DsButton>(find.byType(DsButton))
            .map((DsButton button) => button.variant)
            .toSet();
        expect(mountedVariants, containsAll(DsButtonVariant.values));
      },
    );
  });
}
