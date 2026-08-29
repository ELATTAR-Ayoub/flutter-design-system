/// Tests for `components_docs/agent_attachments/page.dart`'s
/// [AgentAttachmentsDocPage]: the agent-attachments component documentation
/// page.
///
/// `agent_attachments.dart` declares three widgets ([AgentAttachmentCard],
/// [AgentAttachmentList], [AgentDeliveryBadge]) and two top-level
/// functions ([agentAttachmentGlyph], [agentAttachmentIsVideo]) — read
/// directly from `lib/src/components/ui/agent_attachments.dart`. The
/// API-completeness test checks each `DocsApiTable` by its own title.
///
/// No `pumpAndSettle` anywhere: only `tester.pump()` / `tester.pump(duration)`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/agent_attachments/meta.dart';
import 'package:example/components_docs/agent_attachments/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_facts.dart';
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

const List<String> _expectedSectionOrder = <String>[
  'preview',
  'install',
  'usage',
  'delivery-badge',
  'image',
  'remove',
  'api',
  'states',
  'accessibility',
  'keyboard',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  'AgentAttachmentCard': <String>[
    'attachment',
    'onRemove',
    'onDownload',
    'imageBuilder',
    'descriptionGap',
  ],
  'AgentAttachmentList': <String>[
    'attachments',
    'onRemove',
    'compact',
    'imageBuilder',
    'onDownload',
    'gap',
  ],
  'AgentDeliveryBadge': <String>['attachment', 'gap', 'tooltipMaxWidth'],
  'Top-level functions': <String>[
    'agentAttachmentGlyph(kind)',
    'agentAttachmentIsVideo(attachment)',
  ],
};

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

Future<ThemeController> _pump(
  WidgetTester tester, {
  Size size = _wide,
  ColorMode mode = ColorMode.dark,
  ValueChanged<String>? onNavigate,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ThemeController theme = ThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ThemeScope(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: AgentAttachmentsDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  group('agent-attachments docs page', () {
    testWidgets(
      'renders the article at wide and narrow widths with no exceptions',
      (WidgetTester tester) async {
        await _pump(tester, size: _wide);

        expect(
          find.byKey(const ValueKey<String>('agent-attachments-doc-article')),
          findsOneWidget,
        );
        expect(find.text(agentAttachmentsDoc.title), findsWidgets);
        expect(find.byType(DocsShowcase), findsNWidgets(4));
        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);

        await _pump(tester, size: _narrow);
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('renders the house-shape section order, section for section', (
      WidgetTester tester,
    ) async {
      await _pump(tester);

      final List<String> ids = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.id)
          .toList();

      expect(ids, _expectedSectionOrder);
    });

    test('the table of contents matches the declared sections', () {
      expect(
        agentAttachmentsDocSpec.toc
            .map((DocsTocEntry entry) => entry.anchor)
            .toList(),
        _expectedSectionOrder,
      );
    });

    testWidgets(
      'each DocsApiTable covers every constructor parameter or public '
      'static found on the real class, and both top-level functions',
      (WidgetTester tester) async {
        await _pump(tester);

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        final List<DocsApiTable> tables = tester
            .widgetList<DocsApiTable>(find.byType(DocsApiTable))
            .toList();
        expect(tables, hasLength(_expectedApiTables.length));

        final Map<String, Set<String>> byTitle = <String, Set<String>>{
          for (final DocsApiTable table in tables)
            table.title: <String>{
              for (final DocsApiFact fact in table.facts) fact.name,
            },
        };

        for (final MapEntry<String, List<String>> expected
            in _expectedApiTables.entries) {
          final Set<String>? documented = byTitle[expected.key];
          expect(
            documented,
            isNotNull,
            reason: 'no DocsApiTable titled "${expected.key}" was rendered',
          );
          for (final String member in expected.value) {
            expect(
              documented,
              contains(member),
              reason: '"${expected.key}" table is missing "$member"',
            );
          }
        }
      },
    );

    testWidgets(
      'the Preview specimen shows all three delivery outcomes: Read, Name '
      'only, and no badge at all for the produced file',
      (WidgetTester tester) async {
        await _pump(tester);

        final Finder list = find.byKey(
          const ValueKey<String>('agent-attachments-preview:list'),
        );
        await tester.ensureVisible(list);

        expect(
          find.descendant(of: list, matching: find.text('Read')),
          findsOneWidget,
        );
        expect(
          find.descendant(of: list, matching: find.text('Name only')),
          findsOneWidget,
        );
        expect(
          find.descendant(of: list, matching: find.byType(AgentAttachmentCard)),
          findsNWidgets(3),
        );
      },
    );

    testWidgets(
      'the Delivery badge specimen renders exactly two visible badges: '
      'the produced one draws nothing',
      (WidgetTester tester) async {
        await _pump(tester);

        final Finder content = find.byKey(
          const ValueKey<String>('agent-attachments-example:delivery-content'),
        );
        final Finder reference = find.byKey(
          const ValueKey<String>(
            'agent-attachments-example:delivery-reference',
          ),
        );
        final Finder produced = find.byKey(
          const ValueKey<String>('agent-attachments-example:delivery-produced'),
        );
        await tester.ensureVisible(content);

        expect(
          find.descendant(of: content, matching: find.text('Read')),
          findsOneWidget,
        );
        expect(
          find.descendant(of: reference, matching: find.text('Name only')),
          findsOneWidget,
        );
        expect(
          tester.getSize(produced),
          Size.zero,
          reason: 'a produced attachment renders SizedBox.shrink()',
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the Image attachment specimen mounts the placeholder picture and '
      'opens a full-size preview on tap',
      (WidgetTester tester) async {
        await _pump(tester);

        final Finder specimen = find.byKey(
          const ValueKey<String>('agent-attachments-example:image'),
        );
        await tester.ensureVisible(specimen);
        expect(
          find.descendant(of: specimen, matching: find.byType(ColoredBox)),
          findsWidgets,
        );

        final Finder opener = find.descendant(
          of: specimen,
          matching: find.byWidgetPredicate(
            (Widget w) =>
                w is AttachmentTrigger &&
                w.label == 'Open shelf-photo.png full size',
          ),
        );
        expect(opener, findsOneWidget);
        // Invoked directly rather than through `tester.tap`: the trigger's
        // own hit area is the picture well's computed height, which depends
        // on constraint propagation through attachment.dart's FittedBox —
        // not this page's concern. Calling the real onPressed callback the
        // mounted widget carries exercises the same open path OverlayPortal
        // wires, without depending on that geometry.
        tester.widget<AttachmentTrigger>(opener).onPressed();
        await tester.pump();
        await tester.pump();
        await tester.pump(MotionDurations.open);

        // The close control's visible child is a bare icon; "Close" is its
        // accessible label, never rendered as a Text widget, so this looks
        // for the Button by that label instead of by find.text.
        final Finder closeButton = find.byWidgetPredicate(
          (Widget w) => w is Button && w.label == 'Close',
        );
        expect(closeButton, findsOneWidget);
        tester.widget<Button>(closeButton).onPressed!();
        await tester.pump();
        await tester.pump(MotionDurations.normal);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the Remove specimen removes an attachment from the list on tap and '
      'announces once every attachment is gone',
      (WidgetTester tester) async {
        await _pump(tester);

        final Finder list = find.byKey(
          const ValueKey<String>('agent-attachments-example:remove-list'),
        );
        await tester.ensureVisible(list);
        expect(
          find.descendant(of: list, matching: find.byType(AgentAttachmentCard)),
          findsNWidgets(2),
        );

        final Finder statusText = find.byKey(
          const ValueKey<String>('agent-attachments-example:remove-status'),
        );
        expect(
          tester.widget<StyledText>(statusText).text,
          isNot('All attachments removed.'),
        );

        for (int i = 0; i < 2; i++) {
          final Finder removeButtons = find.descendant(
            of: list,
            matching: find.byWidgetPredicate(
              (Widget w) =>
                  w is Button && (w.label ?? '').startsWith('Remove '),
            ),
          );
          expect(removeButtons, findsWidgets);
          await tester.tap(removeButtons.first, warnIfMissed: false);
          await tester.pump();
        }

        expect(
          find.descendant(of: list, matching: find.byType(AgentAttachmentCard)),
          findsNothing,
        );
        expect(
          tester.widget<StyledText>(statusText).text,
          'All attachments removed.',
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'both themes render the article with no exceptions when flipped in '
      'place',
      (WidgetTester tester) async {
        final ThemeController theme = await _pump(
          tester,
          mode: ColorMode.light,
        );
        expect(find.text(agentAttachmentsDoc.title), findsWidgets);

        theme.setMode(ColorMode.dark);
        await tester.pump();
        expect(find.text(agentAttachmentsDoc.title), findsWidgets);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'installation shows the real elattar add agent-attachments command',
      (WidgetTester tester) async {
        await _pump(tester);

        expect(
          find.textContaining('elattar add agent-attachments'),
          findsWidgets,
        );
        expect(agentAttachmentsDoc.command, 'elattar add agent-attachments');
        expect(agentAttachmentsDoc.route, '/components/agent_attachments');
      },
    );

    test('meta carries the manifest dependencies verbatim', () {
      expect(agentAttachmentsDoc.name, 'agent_attachments');
      expect(agentAttachmentsDoc.dependencies, <String>[
        'agent-core',
        'attachment',
        'button',
        'dialog',
        'icon',
        'source-foundation',
        'tooltip',
      ]);
      expect(
        agentAttachmentsDoc.exports,
        containsAll(<String>[
          'AgentAttachmentCard',
          'AgentAttachmentList',
          'AgentDeliveryBadge',
          'agentAttachmentGlyph',
          'agentAttachmentIsVideo',
        ]),
      );
    });
  });
}
