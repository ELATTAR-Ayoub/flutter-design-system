/// Tests for `components_docs/item/meta.dart` and
/// `components_docs/item/page.dart`: the public documentation page for
/// Item, re-housed onto the kit (`ComponentDocSpec` + `ComponentDocPage`),
/// the same shape `button_test.dart` covers.
///
/// API Reference, Accessibility, and Keyboard are all `DisclosureSection`s,
/// closed by default and mounting no content while closed (see
/// `docs_disclosure_test.dart`), so tests that read their content open the
/// relevant `DocsDisclosure` first — the same fix `button_test.dart` needed
/// for its own API table.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/item/meta.dart';
import 'package:example/components_docs/item/page.dart';
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
      child: MaterialApp(
        home: Builder(
          // The ambient ink every route inherits, as the docs shell sets it
          // for the real app. Without it this subtree sits under WidgetsApp's
          // red fallback style, which StyledText asserts on rather than
          // quietly painting over.
          builder: (BuildContext context) => DefaultTextStyle(
            style: StyledText.styleOf(
              context,
              TextStyles.body,
              color: ThemeScope.of(context).foreground,
            ),
            child: SingleChildScrollView(child: child),
          ),
        ),
      ),
    );

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

Future<void> _open(WidgetTester tester, String title) async {
  final Finder trigger = _disclosureTrigger(title);
  await tester.ensureVisible(trigger);
  await tester.pump();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(MotionDurations.open);
}

void main() {
  group('item docs page', () {
    testWidgets(
      'renders the article, the API tables, and live specimens of every part',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: ItemDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('item-doc-article')),
          findsOneWidget,
        );

        await _open(tester, 'API Reference');

        for (final String param in <String>[
          'media',
          'content',
          'actions',
          'variant',
          'alignStart',
        ]) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        expect(find.byType(ItemGroup), findsWidgets);
        expect(find.byType(Item), findsWidgets);
        expect(find.byType(ItemMedia), findsWidgets);
        expect(find.byType(ItemContent), findsWidgets);
        expect(find.byType(ItemTitle), findsWidgets);
        expect(find.byType(ItemDescription), findsWidgets);
        expect(find.byType(ItemActions), findsWidgets);
        expect(find.byType(Avatar), findsWidgets);

        // Every ItemVariant gets a live specimen.
        for (final ItemVariant variant in ItemVariant.values) {
          expect(
            find.byWidgetPredicate(
              (Widget w) => w is Item && w.variant == variant,
            ),
            findsWidgets,
            reason: 'missing a $variant specimen',
          );
        }

        expect(itemDoc.name, 'item');
        expect(
          itemDoc.exports,
          containsAll(<String>[
            'ItemGroup',
            'Item',
            'ItemVariant',
            'ItemMedia',
            'ItemContent',
            'ItemTitle',
            'ItemDescription',
            'ItemActions',
          ]),
        );
        expect(itemDoc.command, 'elattar add item');
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
          child: const ItemDocPage(),
        ),
      );
      await tester.pump();

      // Six specimen stages: Preview, Variant, Icon, Avatar, Group, RTL.
      expect(find.byType(DocsShowcase), findsNWidgets(6));
      expect(find.byType(DocsInstall), findsOneWidget);
      // Eight collapsed sections: API Reference, States, Accessibility,
      // Keyboard, Responsive, Dependencies, Theming, Source.
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const ItemDocPage(),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('item-doc-article')),
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
      'renders the shadcn-shaped section list, in order, with Size/Image/'
      'Header/Link/Dropdown honestly skipped',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const ItemDocPage(),
          ),
        );

        final List<DocsSection> sections = tester
            .widgetList<DocsSection>(find.byType(DocsSection))
            .toList();
        final List<String> sectionIds = sections
            .map((DocsSection section) => section.id)
            .toList();
        final List<String> sectionTitles = sections
            .map((DocsSection section) => section.title)
            .toList();

        expect(sectionIds, <String>[
          'preview',
          'install',
          'usage',
          'composition',
          'item-vs-field',
          'variant',
          'icon',
          'avatar',
          'group',
          'rtl',
          'api',
          'states',
          'accessibility',
          'keyboard',
          'responsive',
          'dependencies',
          'theming',
          'source',
        ]);

        expect(sectionTitles, isNot(contains('Size')));
        expect(sectionTitles, isNot(contains('Image')));
        expect(sectionTitles, isNot(contains('Header')));
        expect(sectionTitles, isNot(contains('Link')));
        expect(sectionTitles, isNot(contains('Dropdown')));
      },
    );

    testWidgets('keyboard section documents actions-only focus', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const ItemDocPage(),
        ),
      );

      await _open(tester, 'Keyboard');

      expect(
        find.textContaining('No keyboard behaviour of its own'),
        findsWidgets,
      );
    });

    testWidgets(
      'components render correctly in both themes at both breakpoints',
      (WidgetTester tester) async {
        for (final Size size in <Size>[
          const Size(390, 844),
          const Size(1440, 900),
        ]) {
          for (final ColorMode mode in <ColorMode>[
            ColorMode.light,
            ColorMode.dark,
          ]) {
            tester.view.physicalSize = size;
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.reset);

            final ThemeController controller = ThemeController(mode: mode);
            await tester.pumpWidget(
              _harness(controller: controller, child: const ItemDocPage()),
            );

            expect(
              find.byKey(const ValueKey<String>('item-doc-article')),
              findsOneWidget,
              reason: 'at $size in $mode',
            );
            expect(find.byType(Item), findsWidgets);
          }
        }
      },
    );
  });
}
