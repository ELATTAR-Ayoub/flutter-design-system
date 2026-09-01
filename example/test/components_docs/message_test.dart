/// The `message` docs page's own test, on the house shape kit.
///
/// `message` had no page before this pass, so there is no retired test to
/// carry facts across from — this is the page's whole coverage: the article
/// mounts, the API Reference disclosure documents every constructor
/// parameter of every exported class, a live specimen of every part
/// mounts, and the page renders at a wide and a narrow viewport, in both
/// themes, without throwing.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/message/meta.dart';
import 'package:example/components_docs/message/page.dart';
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

/// Every named constructor parameter each of `message.dart`'s seven
/// exported classes declares (excluding `key`) — the same set the page's
/// seven `DocsApiTable`s claim to cover. Names shared by more than one
/// class (`align`, `ghost`, `child`, `children`, `text`) appear once.
const List<String> _messageApiParams = <String>[
  // MessageGroup / MessageContent
  'children',
  // Message
  'content', 'avatar', 'align', 'ghost',
  // MessageScope / MessageAvatar
  'child', 'size', 'lifted',
  // MessageContent
  'header', 'footer',
  // MessageHeader / MessageFooter
  'text',
];

const List<String> _exampleKeys = <String>[
  'message-example:preview',
  'message-example:avatar',
  'message-example:header-footer',
  'message-example:align',
  'message-example:ghost',
  'message-example:group',
];

void main() {
  group('message docs page', () {
    testWidgets(
      'renders the article, the full API table across all seven classes, '
      'and a live specimen of every part',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: MessageDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('message-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in _messageApiParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        for (final String key in _exampleKeys) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        // At least one Message on the page actually carries align: end
        // (Align, Group) and at least one carries the default start
        // (Preview, Avatar, Header and Footer) — both real, not just
        // labelled.
        final List<Message> messages = tester
            .widgetList<Message>(find.byType(Message))
            .toList();
        expect(
          messages.any((Message m) => m.align == BubbleAlign.end),
          isTrue,
          reason: 'no Message on the page carries align: end',
        );
        expect(
          messages.any((Message m) => m.align == BubbleAlign.start),
          isTrue,
          reason: 'no Message on the page carries the default align',
        );

        // The Ghost example actually carries ghost: true.
        final Message ghostMessage = tester.widget<Message>(
          find.descendant(
            of: find.byKey(const ValueKey<String>('message-example:ghost')),
            matching: find.byType(Message),
          ),
        );
        expect(ghostMessage.ghost, isTrue);

        // The Group example mounts an MessageGroup with more than one
        // Message inside it.
        final MessageGroup group = tester.widget<MessageGroup>(
          find.descendant(
            of: find.byKey(const ValueKey<String>('message-example:group')),
            matching: find.byType(MessageGroup),
          ),
        );
        expect(group.children.length, greaterThan(1));

        expect(messageDoc.name, 'message');
        expect(
          messageDoc.exports,
          containsAll(<String>[
            'MessageGroup',
            'Message',
            'MessageScope',
            'MessageAvatar',
            'MessageContent',
            'MessageHeader',
            'MessageFooter',
          ]),
        );
        expect(messageDoc.command, 'elattar add message');
        expect(messageDoc.dependencies, <String>[
          'bubble',
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
          child: const MessageDocPage(),
        ),
      );
      await tester.pump();

      // Six specimen stages: Preview, Avatar, Header and Footer, Align,
      // Ghost, Group.
      expect(find.byType(DocsShowcase), findsNWidgets(6));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    test('the table of contents matches the declared sections', () {
      expect(
        messageDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Avatar',
          'Header and Footer',
          'Align',
          'Ghost',
          'Group',
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
      final DocsTocEntry api = messageDocSpec.toc.firstWhere(
        (DocsTocEntry e) => e.anchor == 'api',
      );
      expect(api.children.map((DocsTocEntry e) => e.anchor).toList(), <String>[
        'api-elmessagegroup',
        'api-elmessage',
        'api-elmessagescope',
        'api-elmessageavatar',
        'api-elmessagecontent',
        'api-elmessageheader',
        'api-elmessagefooter',
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
          child: const MessageDocPage(),
        ),
      );
      await tester.pump();

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, messageDocSpec.toc.map((e) => e.title).toList());
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
          child: const MessageDocPage(),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);

      expect(
        find.byKey(const ValueKey<String>('message-doc-article')),
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
        _harness(controller: controller, child: const MessageDocPage()),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);

      controller.setMode(ColorMode.light);
      await tester.pump();
      expect(tester.takeException(), isNull);

      expect(
        find.byKey(const ValueKey<String>('message-doc-article')),
        findsOneWidget,
      );
    });
  });
}
