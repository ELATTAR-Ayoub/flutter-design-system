import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/button/meta.dart';
import 'package:example/components_docs/button/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required ElThemeController controller,
}) => ElTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s
/// own trigger key ([DocsDisclosure.triggerKey]) is one constant shared by
/// every instance on the page, so a bare `find.byKey` would match all eight
/// — this narrows to the one panel by its title first, matching the kit's
/// own convention (see `docs_disclosure_test.dart`).
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every named constructor parameter `ElButton`'s own class declares
/// (`lib/src/components/button.dart`), excluding `key`: the same set the
/// page's `ElButton` [DocsApiTable] claims to cover.
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
      'every ElButtonVariant and ElButtonSize this page claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: ButtonDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // One frame is enough: nothing on this page loops except the
        // premium button's foil shimmer, which must never be settled on.
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('button-doc-article')),
          findsOneWidget,
        );

        // The API table lives inside the API Reference disclosure, closed
        // by default (a closed `DocsDisclosure` mounts no content at all,
        // see `docs_disclosure_test.dart`), so open it before reading any
        // of its rows. The trigger sits well past the 900px viewport on a
        // page this long, so it must be scrolled into view before `tap()`
        // can hit test it.
        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        // Every ElButton constructor parameter is named in the ElButton
        // API table.
        for (final String param in _buttonConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        // Every ElButtonVariant enum value is named in the ElButtonVariant
        // table, and every ElButtonSize value in the ElButtonSize table.
        for (final ElButtonVariant variant in ElButtonVariant.values) {
          expect(
            find.text(variant.name),
            findsWidgets,
            reason: 'ElButtonVariant.${variant.name} missing from API table',
          );
        }
        for (final ElButtonSize size in ElButtonSize.values) {
          expect(
            find.text(size.name),
            findsWidgets,
            reason: 'ElButtonSize.${size.name} missing from API table',
          );
        }

        // A live ElButton specimen of every variant mounts somewhere on
        // the page, this page's own promise, not just the API table's
        // prose.
        final Set<ElButtonVariant> mountedVariants = tester
            .widgetList<ElButton>(find.byType(ElButton))
            .map((ElButton button) => button.variant)
            .toSet();
        expect(mountedVariants, containsAll(ElButtonVariant.values));

        // A live specimen of every ElButtonSize rung mounts too. The
        // Icon example covers the four squares, the Size example covers
        // the five text rungs.
        final Set<ElButtonSize> mountedSizes = tester
            .widgetList<ElButton>(find.byType(ElButton))
            .map((ElButton button) => button.size)
            .toSet();
        expect(mountedSizes, containsAll(ElButtonSize.values));

        // Every example specimen this page's own source keys carries its
        // key on the page.
        for (final String key in <String>[
          'button-preview:primary',
          'button-preview:premium',
          'button-preview:secondary',
          'button-preview:outline',
          'button-preview:ghost',
          'button-preview:destructive',
          'button-preview:link',
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
          'button-example:rounded-pill',
          'button-example:rounded-lg',
          'button-example:rounded-md',
          'button-example:loading',
          'button-example:disabled',
          'button-example:sizes-xs',
          'button-example:sizes-sm',
          'button-example:sizes-md',
          'button-example:sizes-lg',
          'button-example:sizes-xl',
          'button-example:emphasis',
          'button-example:button-group-grid',
          'button-example:button-group-list',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        // The Loading example specimen actually carries loading: true, and
        // the Disabled example actually carries a null onPressed: the two
        // states are not just labelled, they are real.
        final ElButton loadingButton = tester.widget<ElButton>(
          find.descendant(
            of: find.byKey(const ValueKey<String>('button-example:loading')),
            matching: find.byType(ElButton),
          ),
        );
        expect(loadingButton.loading, isTrue);

        final ElButton disabledButton = tester.widget<ElButton>(
          find.descendant(
            of: find.byKey(const ValueKey<String>('button-example:disabled')),
            matching: find.byType(ElButton),
          ),
        );
        expect(disabledButton.onPressed, isNull);

        // The Emphasis example actually carries ElButtonEmphasis.caps.
        final ElButton capsButton = tester.widget<ElButton>(
          find.descendant(
            of: find.byKey(const ValueKey<String>('button-example:emphasis')),
            matching: find.byType(ElButton),
          ),
        );
        expect(capsButton.emphasis, ElButtonEmphasis.caps);

        expect(buttonDoc.name, 'button');
        expect(
          buttonDoc.exports,
          containsAll(<String>[
            'ElButton',
            'ElButtonVariant',
            'ElButtonSize',
            'ElButtonEmphasis',
            'ElButtonSurface',
          ]),
        );
        expect(buttonDoc.command, 'elattar add button');
        expect(destination, isNull);
      },
    );

    testWidgets(
      'the page is declared, and every section is a kit component',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const ButtonDocPage(),
          ),
        );
        await tester.pump();

        // Sixteen specimen stages: the Preview hero, Size, the seven
        // variants, Icon, With Icon, Rounded, Spinner, Disabled, Emphasis,
        // and Button Group.
        expect(find.byType(DocsShowcase), findsNWidgets(16));
        expect(find.byType(DocsInstall), findsOneWidget);
        // Eight collapsed sections: API Reference, States, Accessibility,
        // Keyboard, Responsive, Dependencies, Theming, Source.
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        buttonDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Size',
          'Default',
          'Premium',
          'Outline',
          'Secondary',
          'Ghost',
          'Destructive',
          'Link',
          'Icon',
          'With Icon',
          'Rounded',
          'Spinner',
          'Disabled',
          'Emphasis',
          'Button Group',
          'API Reference',
          'States',
          'Accessibility',
          'Keyboard',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ],
      );
    });

    testWidgets(
      'sections render in the shadcn-mirrored order, section for section',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const ButtonDocPage()),
        );
        await tester.pump();

        // Immune to the duplicate-string hazard `find.text` carries here: a
        // section heading and its own TOC link render the same string, so
        // `find.text('States')` finds two widgets, not one. Reading each
        // mounted `DocsSection`'s own `title` field sidesteps that
        // entirely — the same fix the old `ElSection` version of this test
        // made, updated for the kit's own section widget.
        final List<String> titles = tester
            .widgetList<DocsSection>(find.byType(DocsSection))
            .map((DocsSection section) => section.title)
            .toList();

        expect(titles, <String>[
          'Preview',
          'Installation',
          'Usage',
          'Size',
          'Default',
          'Premium',
          'Outline',
          'Secondary',
          'Ghost',
          'Destructive',
          'Link',
          'Icon',
          'With Icon',
          'Rounded',
          'Spinner',
          'Disabled',
          'Emphasis',
          'Button Group',
          'API Reference',
          'States',
          'Accessibility',
          'Keyboard',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ]);
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
            controller: ElThemeController(mode: ElThemeMode.dark),
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

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const ButtonDocPage()),
        );
        await tester.pump();

        final ElThemeData darkTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('button-doc-article')),
          ),
        );

        // Flip the SAME controller in place, not a fresh widget tree:
        // the same object every real theme toggle mutates. A single
        // `pump()`, never `pumpAndSettle()`: the premium example's foil
        // shimmer is a genuinely looping animation and would hang it.
        controller.setMode(ElThemeMode.light);
        await tester.pump();

        final ElThemeData lightTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('button-doc-article')),
          ),
        );

        // The flip actually reached the page's own subtree. `primary` is
        // deliberately the same token in both themes (theme.dart: "Same in
        // both"). `background` and `foreground` are the pair that
        // actually inverts.
        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        // Nothing was lost across the flip: every specimen key is still
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

        final Set<ElButtonVariant> mountedVariants = tester
            .widgetList<ElButton>(find.byType(ElButton))
            .map((ElButton button) => button.variant)
            .toSet();
        expect(mountedVariants, containsAll(ElButtonVariant.values));
      },
    );
  });
}
