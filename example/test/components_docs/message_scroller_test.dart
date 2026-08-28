/// The `message-scroller` docs page's own test, on the house shape kit.
///
/// `message-scroller` had no page before this pass, so there is no retired
/// test to carry facts across from — this is the page's whole coverage: the
/// article mounts, the API Reference disclosure documents every constructor
/// parameter of every exported class and every value of the two exported
/// enums, a live scrolling transcript mounts on every stage, and the page
/// renders at a wide and a narrow viewport, in both themes, without
/// throwing.
///
/// No test here calls `pumpAndSettle`, and none taps the Anchor specimen's
/// jump control: `MessageScrollerController.scrollToMessage` runs a real
/// `ScrollPosition.animateTo`, which is exactly the kind of controller this
/// suite is told never to settle on.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/message_scroller/meta.dart';
import 'package:example/components_docs/message_scroller/page.dart';
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

/// Every named constructor parameter each of the seven exported classes of
/// `message_scroller.dart` declares (excluding `key`) — the same set the
/// page's nine `DocsApiTable`s claim to cover. `child` is shared by
/// `MessageScrollerProvider`, `MessageScrollerViewport` and
/// `MessageScrollerItem`, and appears once.
const List<String> _apiParams = <String>[
  // MessageScrollerController
  'autoScroll', 'defaultScrollPosition', 'scrollEdgeThreshold',
  // MessageScrollerProvider
  'controller', 'child',
  // MessageScroller
  'viewport', 'button',
  // MessageScrollerViewport
  'semanticsLabel',
  // MessageScrollerContent
  'children', 'padding',
  // MessageScrollerItem
  'messageId', 'scrollAnchor',
  // MessageScrollerButton
  'direction',
];

const List<String> _exampleKeys = <String>[
  'message-scroller-example:preview',
  'message-scroller-example:scroll-position',
  'message-scroller-example:button',
  'message-scroller-example:anchor',
  'message-scroller-example:anchor-trigger',
];

void main() {
  group('message-scroller docs page', () {
    testWidgets(
      'renders the article, the full API table across all nine classes and '
      'enums, and a live scrolling transcript on every stage',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: MessageScrollerDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('message-scroller-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in _apiParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        for (final ScrollPosition p in ScrollPosition.values) {
          expect(
            find.text(p.name),
            findsWidgets,
            reason: 'ScrollPosition.${p.name} missing from API table',
          );
        }
        for (final ScrollDirection d in ScrollDirection.values) {
          expect(
            find.text(d.name),
            findsWidgets,
            reason: 'ScrollDirection.${d.name} missing from API table',
          );
        }

        for (final String key in _exampleKeys) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        // Every stage mounts a real, eleven-turn transcript, not a picture.
        expect(
          find.byType(MessageScrollerItem),
          findsNWidgets(11 * 4),
          reason:
              'Preview, Scroll Position, Button and Anchor each stage the '
              'full eleven-turn transcript',
        );

        // The Button specimen's own button carries direction: end, its
        // declared default made real.
        final MessageScrollerButton button = tester
            .widgetList<MessageScrollerButton>(
              find.descendant(
                of: find.byKey(
                  const ValueKey<String>('message-scroller-example:button'),
                ),
                matching: find.byType(MessageScrollerButton),
              ),
            )
            .single;
        expect(button.direction, ScrollDirection.end);

        // The Anchor specimen's trigger is a real, enabled control — not
        // tapped here (see the library note above).
        final Button trigger = tester.widget<Button>(
          find.byKey(
            const ValueKey<String>('message-scroller-example:anchor-trigger'),
          ),
        );
        expect(trigger.onPressed, isNotNull);

        expect(messageScrollerDoc.name, 'message-scroller');
        expect(
          messageScrollerDoc.exports,
          containsAll(<String>[
            'ScrollPosition',
            'ScrollDirection',
            'MessageScrollerController',
            'MessageScrollerProvider',
            'MessageScroller',
            'MessageScrollerViewport',
            'ScrollFade',
            'MessageScrollerContent',
            'MessageScrollerItem',
            'MessageScrollerButton',
          ]),
        );
        expect(messageScrollerDoc.command, 'elattar add message-scroller');
        expect(messageScrollerDoc.dependencies, <String>[
          'button',
          'icon',
          'source-foundation',
        ]);
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
          child: const MessageScrollerDocPage(),
        ),
      );
      await tester.pump();

      // Four specimen stages: Preview, Scroll Position, Button, Anchor.
      expect(find.byType(DocsShowcase), findsNWidgets(4));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        messageScrollerDocSpec.toc
            .map((DocsTocEntry entry) => entry.title)
            .toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Scroll Position',
          'Button',
          'Anchor',
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
      final DocsTocEntry api = messageScrollerDocSpec.toc.firstWhere(
        (DocsTocEntry e) => e.anchor == 'api',
      );
      expect(api.children.map((DocsTocEntry e) => e.anchor).toList(), <String>[
        'api-elmessagescrollercontroller',
        'api-elmessagescrollerprovider',
        'api-elmessagescroller',
        'api-elmessagescrollerviewport',
        'api-elmessagescrollercontent',
        'api-elmessagescrolleritem',
        'api-elmessagescrollerbutton',
        'api-elscrollposition',
        'api-elscrolldirection',
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
          child: const MessageScrollerDocPage(),
        ),
      );
      await tester.pump();

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, messageScrollerDocSpec.toc.map((e) => e.title).toList());
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
          child: const MessageScrollerDocPage(),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);

      expect(
        find.byKey(const ValueKey<String>('message-scroller-doc-article')),
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
        _harness(controller: controller, child: const MessageScrollerDocPage()),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);

      controller.setMode(ColorMode.light);
      await tester.pump();
      expect(tester.takeException(), isNull);

      expect(
        find.byKey(const ValueKey<String>('message-scroller-doc-article')),
        findsOneWidget,
      );
    });
  });
}
