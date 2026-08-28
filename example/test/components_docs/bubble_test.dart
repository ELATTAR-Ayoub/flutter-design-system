/// The `bubble` docs page's own test, on the house shape kit.
///
/// `bubble` had no page before this pass, so there is no retired test to
/// carry facts across from — this is the page's whole coverage: the article
/// mounts, the API Reference disclosure documents every constructor
/// parameter of every exported class and every value of every exported enum,
/// a live specimen of every `BubbleVariant` mounts somewhere on the page,
/// and the page renders at a wide and a narrow viewport, in both themes,
/// without throwing.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/bubble/meta.dart';
import 'package:example/components_docs/bubble/page.dart';
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

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every named constructor parameter each exported class of `bubble.dart`
/// declares (excluding `key`), plus every field `BubbleReaction` carries —
/// the same set the page's nine `DocsApiTable`s claim to cover. Names shared
/// by more than one class (`child`, `align`, `reactions`) appear once.
const List<String> _bubbleApiParams = <String>[
  // Bubble
  'child', 'variant', 'align', 'reactions',
  // BubbleContent
  'onPressed', 'semanticsLabel',
  // BubbleGroup
  'children',
  // BubbleReactions
  'side', 'showCount', 'onReact',
  // BubbleReaction
  'emoji', 'count', 'label', 'mine',
];

const List<String> _exampleKeys = <String>[
  'bubble-example:default',
  'bubble-example:secondary',
  'bubble-example:muted',
  'bubble-example:tinted',
  'bubble-example:outline',
  'bubble-example:ghost',
  'bubble-example:destructive',
  'bubble-example:alignment',
  'bubble-example:as-child',
  'bubble-example:reactions',
  'bubble-example:reactions-counts',
];

void main() {
  group('bubble docs page', () {
    testWidgets(
      'renders the article, the full API table across all nine classes and '
      'enums, and a live specimen of every BubbleVariant this page claims '
      'to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: BubbleDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('bubble-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in _bubbleApiParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        // Every BubbleVariant value is named in the BubbleVariant table,
        // and every value of the other three enums in their own tables.
        for (final BubbleVariant variant in BubbleVariant.values) {
          expect(
            find.text(variant.name),
            findsWidgets,
            reason: 'BubbleVariant.${variant.name} missing from API table',
          );
        }
        for (final BubbleAlign align in BubbleAlign.values) {
          expect(
            find.text(align.name),
            findsWidgets,
            reason: 'BubbleAlign.${align.name} missing from API table',
          );
        }
        for (final BubbleSide side in BubbleSide.values) {
          expect(
            find.text(side.name),
            findsWidgets,
            reason: 'BubbleSide.${side.name} missing from API table',
          );
        }
        for (final ShowCount count in ShowCount.values) {
          expect(
            find.text(count.name),
            findsWidgets,
            reason: 'ShowCount.${count.name} missing from API table',
          );
        }

        // A live Bubble specimen of every variant mounts somewhere on the
        // page (Preview stages all seven, and each also gets its own
        // section below it).
        final Set<BubbleVariant> mountedVariants = tester
            .widgetList<Bubble>(find.byType(Bubble))
            .map((Bubble bubble) => bubble.variant)
            .toSet();
        expect(mountedVariants, containsAll(BubbleVariant.values));

        for (final String key in _exampleKeys) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }
        for (final BubbleVariant variant in BubbleVariant.values) {
          expect(
            find.byKey(ValueKey<String>('bubble-preview:${variant.name}')),
            findsOneWidget,
            reason: 'missing preview specimen for ${variant.name}',
          );
        }

        // The As Child example actually carries a real onPressed, the port
        // of asChild — not just labelled interactive.
        final BubbleContent asChild = tester.widget<BubbleContent>(
          find.descendant(
            of: find.byKey(const ValueKey<String>('bubble-example:as-child')),
            matching: find.byType(BubbleContent),
          ),
        );
        expect(asChild.onPressed, isNotNull);

        // The Reactions with Counts example actually carries reaction data,
        // not the bare-rail form.
        final BubbleReactions counts = tester.widget<BubbleReactions>(
          find
              .descendant(
                of: find.byKey(
                  const ValueKey<String>('bubble-example:reactions-counts'),
                ),
                matching: find.byType(BubbleReactions),
              )
              .first,
        );
        expect(counts.reactions, isNotNull);
        expect(counts.reactions, isNotEmpty);

        expect(bubbleDoc.name, 'bubble');
        expect(
          bubbleDoc.exports,
          containsAll(<String>[
            'Bubble',
            'BubbleContent',
            'BubbleGroup',
            'BubbleReactions',
            'BubbleReaction',
            'BubbleVariant',
            'BubbleAlign',
            'BubbleSide',
            'ShowCount',
          ]),
        );
        expect(bubbleDoc.command, 'elattar add bubble');
        expect(bubbleDoc.dependencies, <String>['press', 'source-foundation']);
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
          child: const BubbleDocPage(),
        ),
      );
      await tester.pump();

      // Twelve specimen stages: Preview, the seven variants, Alignment,
      // As Child, Reactions, Reactions with Counts.
      expect(find.byType(DocsShowcase), findsNWidgets(12));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        bubbleDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Default',
          'Secondary',
          'Muted',
          'Tinted',
          'Outline',
          'Ghost',
          'Destructive',
          'Alignment',
          'As Child',
          'Reactions',
          'Reactions with Counts',
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
      final DocsTocEntry api = bubbleDocSpec.toc.firstWhere(
        (DocsTocEntry e) => e.anchor == 'api',
      );
      expect(api.children.map((DocsTocEntry e) => e.anchor).toList(), <String>[
        'api-elbubble',
        'api-elbubblecontent',
        'api-elbubblegroup',
        'api-elbubblereactions',
        'api-elbubblereaction',
        'api-elbubblevariant',
        'api-elbubblealign',
        'api-elbubbleside',
        'api-elshowcount',
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
          child: const BubbleDocPage(),
        ),
      );
      await tester.pump();

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, bubbleDocSpec.toc.map((e) => e.title).toList());
    });

    testWidgets('renders at narrow width with the anchor strip', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const BubbleDocPage(),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);

      expect(
        find.byKey(const ValueKey<String>('bubble-doc-article')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsOneWidget,
      );
    });

    testWidgets('renders in both themes without throwing', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(controller: controller, child: const BubbleDocPage()),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);

      controller.setMode(ColorMode.light);
      await tester.pump();
      expect(tester.takeException(), isNull);

      expect(
        find.byKey(const ValueKey<String>('bubble-doc-article')),
        findsOneWidget,
      );
    });
  });
}
