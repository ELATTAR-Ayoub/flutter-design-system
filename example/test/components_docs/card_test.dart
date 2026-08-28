/// The `card` docs page's own test, on the house shape kit.
///
/// Models `button_test.dart`'s coverage: the article mounts, the API
/// Reference disclosure documents every constructor parameter of every
/// exported class, the page renders at a wide and a narrow viewport, and the
/// declared shape (six showcases, one install, eight disclosures) is real.
///
/// Also carries the `card` assertions moved out of the retired
/// `example/test/component_docs_button_card_test.dart` (see that file's
/// removal in this same change), retargeted at the new structure: the old
/// page had exactly one specimen per region, so `findsOneWidget` held; this
/// page shows a region several times over (Preview alone mounts two cards),
/// so each count below is the real number of live specimens on the page
/// rather than a re-assertion of the old "exactly one" fact.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/card/meta.dart';
import 'package:example/components_docs/card/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
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

Widget _harness({required Widget child, required ThemeController controller}) =>
    ThemeScope(
      controller: controller,
      child: MaterialApp(home: SingleChildScrollView(child: child)),
    );

/// The single `DocsDisclosure` whose title is [title] — see
/// `button_test.dart`'s own copy of this helper for why a bare
/// `find.byKey(DocsDisclosure.triggerKey)` is not enough.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every named constructor parameter each of `card.dart`'s six exported
/// classes declares, excluding `key`: the same set the page's six
/// `DocsApiTable`s claim to cover. `text` and `child` each cover two classes
/// (`CardTitle`/`CardDescription`, `CardContent`/`CardFooter`); a
/// duplicate entry would only double-count, so each name appears once.
const List<String> _cardConstructorParams = <String>[
  // Card
  'children', 'fill', 'ringColor',
  // CardHeader
  'title', 'description', 'action',
  // CardTitle / CardDescription
  'text',
  // CardContent / CardFooter
  'child',
];

void main() {
  group('card docs page', () {
    testWidgets(
      'renders the article, the full API table across all six classes, and '
      'a live specimen of every region',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: CardDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        // One frame: the Custom Fill and Ring specimen animates its own
        // TweenAnimationBuilder on hover only, nothing loops on this page,
        // but no docs page test settles regardless.
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('card-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in _cardConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        // Every example specimen this page's own source keys carries its key
        // on the page.
        for (final String key in <String>[
          'card-preview:action',
          'card-preview:footer',
          'card-example:header',
          'card-example:header-action',
          'card-example:content',
          'card-example:footer',
          'card-example:fill-ring',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        // The old page's own "Account" specimen survives unchanged, as the
        // Footer section's specimen.
        expect(
          find.descendant(
            of: find.byKey(const ValueKey<String>('card-example:footer')),
            matching: find.text('Account'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const ValueKey<String>('card-example:footer')),
            matching: find.text('Save changes'),
          ),
          findsOneWidget,
        );

        expect(cardDoc.name, 'card');
        expect(
          cardDoc.exports,
          containsAll(<String>[
            'Card',
            'CardHeader',
            'CardTitle',
            'CardDescription',
            'CardContent',
            'CardFooter',
          ]),
        );
        expect(cardDoc.command, 'elattar add card');
        // The real registry manifest's own registryDependencies, verbatim —
        // the fact the retired test asserted as literal copy
        // ("foundation dependency") now asserted as data.
        expect(cardDoc.dependencies, <String>['source-foundation']);
        // The same fact, visible on the always-open Installation section
        // (never behind a collapsed disclosure), so no trigger has to be
        // opened first to see it.
        expect(find.textContaining('source-foundation'), findsWidgets);
        expect(destination, isNull);
      },
    );

    testWidgets('the page is declared, and every section is a kit component', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const CardDocPage(),
        ),
      );
      await tester.pump();

      // Six specimen stages: Preview, Header, Header with Action, Content,
      // Footer, Custom Fill and Ring.
      expect(find.byType(DocsShowcase), findsNWidgets(6));
      expect(find.byType(DocsInstall), findsOneWidget);
      // Eight collapsed sections: API Reference, States, Accessibility,
      // Keyboard, Responsive, Dependencies, Theming, Source.
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        cardDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Header',
          'Header with Action',
          'Content',
          'Footer',
          'Custom Fill and Ring',
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
      // API Reference's six sub-anchors survive the derivation.
      final DocsTocEntry api = cardDocSpec.toc.firstWhere(
        (DocsTocEntry e) => e.anchor == 'api',
      );
      expect(api.children.map((DocsTocEntry e) => e.anchor).toList(), <String>[
        'api-elcard',
        'api-elcardheader',
        'api-elcardtitle',
        'api-elcarddescription',
        'api-elcardcontent',
        'api-elcardfooter',
      ]);
    });

    testWidgets('sections render in declaration order, section for section', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const CardDocPage(),
        ),
      );
      await tester.pump();

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Header',
        'Header with Action',
        'Content',
        'Footer',
        'Custom Fill and Ring',
        'API Reference',
        'States',
        'Accessibility',
        'Keyboard',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);
    });

    testWidgets(
      'renders at narrow width with the anchor strip, every live region '
      'mounted, and the retired page\'s facts still true',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const CardDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('card-doc-article')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );

        // Retargeted from the retired test's `findsOneWidget` for each: this
        // page composes every region several times over rather than once.
        // Preview mounts two Cards (action + footer style); Header,
        // Header with Action, Content and Footer each mount one more; Custom
        // Fill and Ring mounts a sixth via its own TweenAnimationBuilder.
        expect(find.byType(Card), findsNWidgets(7));
        // CardHeader: Preview's two cards, Header, Header with Action,
        // Footer — Content and Custom Fill and Ring carry none.
        expect(find.byType(CardHeader), findsNWidgets(6));
        // CardContent: Preview's two cards, Header, Content, Footer,
        // Custom Fill and Ring's own child — Header with Action carries
        // none.
        expect(find.byType(CardContent), findsNWidgets(6));
        // CardFooter: Preview's footer-style card, and the Footer
        // section's own specimen.
        expect(find.byType(CardFooter), findsNWidgets(2));
      },
    );

    testWidgets('renders in both themes without throwing', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(controller: controller, child: const CardDocPage()),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);

      controller.setMode(ColorMode.light);
      await tester.pump();
      expect(tester.takeException(), isNull);

      expect(
        find.byKey(const ValueKey<String>('card-doc-article')),
        findsOneWidget,
      );
    });
  });
}
