/// Tests for `components_docs/agent_attach_menu/page.dart`'s
/// [AgentAttachMenuDocPage]: the agent-attach-menu component documentation
/// page.
///
/// `agent_attach_menu.dart` declares one widget, [AgentAttachMenu], read
/// directly from `lib/src/components/agent_attach_menu.dart`. The
/// API-completeness test checks its two `DocsApiTable`s (constructor
/// parameters, then public statics) by title.
///
/// The menu opens on a pointer-DOWN, not a tap-up (`MenuPointerDown`), and
/// its content is a real `Popover` overlay — `tester.tap` still opens it,
/// since a synthesized tap delivers a pointer-down before its pointer-up,
/// but reading the popup afterwards needs a frame or two for the overlay's
/// own enter animation, mirrored from `dropdown_menu_test.dart`'s own
/// `_openSpecimenMenu`/`_runOverlay` helpers. No `pumpAndSettle` anywhere:
/// the popover's enter/exit tween is real but finite, so this file only
/// ever calls `tester.pump()` / `tester.pump(duration)`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/agent_attach_menu/meta.dart';
import 'package:example/components_docs/agent_attach_menu/page.dart';
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
  'skills-only',
  'disabled',
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
  'AgentAttachMenu': <String>[
    'onPickFiles',
    'commands',
    'onRunCommand',
    'disabled',
  ],
  'AgentAttachMenu static values': <String>[
    'triggerSize',
    'width',
    'maxHeight',
    'rowInsets',
    'rowGap',
    'rowRadius',
    'rowLinesHaveNoGap',
    'glyphSize',
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
            child: AgentAttachMenuDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

/// Opens the menu at [key] and lets its enter animation run, without ever
/// calling `pumpAndSettle`.
Future<void> _open(WidgetTester tester, String key) async {
  final Finder trigger = find.byKey(ValueKey<String>(key));
  await tester.ensureVisible(trigger);
  await tester.pump();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump();
  await tester.pump(MotionDurations.overlayEnter);
}

void main() {
  group('agent-attach-menu docs page', () {
    testWidgets(
      'renders the article at wide and narrow widths with no exceptions',
      (WidgetTester tester) async {
        await _pump(tester, size: _wide);

        expect(
          find.byKey(const ValueKey<String>('agent-attach-menu-doc-article')),
          findsOneWidget,
        );
        expect(find.text(agentAttachMenuDoc.title), findsWidgets);
        expect(find.byType(DocsShowcase), findsNWidgets(3));
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
        agentAttachMenuDocSpec.toc
            .map((DocsTocEntry entry) => entry.anchor)
            .toList(),
        _expectedSectionOrder,
      );
    });

    testWidgets(
      'each DocsApiTable covers every constructor parameter or public '
      'static found on the real class',
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
      'the Preview specimen opens on tap, shows the Photos & files row and '
      'both skills, and running a skill updates the status line',
      (WidgetTester tester) async {
        await _pump(tester);
        await _open(tester, 'agent-attach-menu-preview:trigger');

        expect(find.text('Photos & files'), findsOneWidget);
        expect(find.text('Find comps'), findsOneWidget);
        expect(find.text('Summarize'), findsOneWidget);
        // The command-group entry never reaches this menu: only group ==
        // skill renders.
        expect(find.text('Clear'), findsNothing);

        final Finder status = find.byKey(
          const ValueKey<String>('agent-attach-menu-preview:status'),
        );
        expect(tester.widget<StyledText>(status).text, 'Nothing run yet.');

        await tester.tap(find.text('Find comps'), warnIfMissed: false);
        await tester.pump();

        expect(tester.widget<StyledText>(status).text, 'Ran: Find comps');
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('the Skills only specimen shows no Photos & files row and no '
        'separator', (WidgetTester tester) async {
      await _pump(tester);
      await _open(tester, 'agent-attach-menu-example:skills-only');

      expect(find.text('Photos & files'), findsNothing);
      expect(find.text('Find comps'), findsOneWidget);
      expect(find.text('Summarize'), findsOneWidget);
    });

    testWidgets(
      'the Disabled specimen renders its trigger with a null onPressed and '
      'never opens on tap',
      (WidgetTester tester) async {
        await _pump(tester);

        final Finder trigger = find.byKey(
          const ValueKey<String>('agent-attach-menu-example:disabled'),
        );
        await tester.ensureVisible(trigger);

        final Finder disabledButton = find.descendant(
          of: trigger,
          matching: find.byType(Button),
        );
        expect(tester.widget<Button>(disabledButton).onPressed, isNull);

        await tester.tap(trigger, warnIfMissed: false);
        await tester.pump();
        await tester.pump();
        await tester.pump(MotionDurations.overlayEnter);

        expect(find.text('Find comps'), findsNothing);
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
        expect(find.text(agentAttachMenuDoc.title), findsWidgets);

        theme.setMode(ColorMode.dark);
        await tester.pump();
        expect(find.text(agentAttachMenuDoc.title), findsWidgets);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'installation shows the real elattar add agent-attach-menu command',
      (WidgetTester tester) async {
        await _pump(tester);

        expect(
          find.textContaining('elattar add agent-attach-menu'),
          findsWidgets,
        );
        expect(agentAttachMenuDoc.command, 'elattar add agent-attach-menu');
        expect(agentAttachMenuDoc.route, '/components/agent_attach_menu');
      },
    );

    test('meta carries the manifest dependencies verbatim', () {
      expect(agentAttachMenuDoc.name, 'agent_attach_menu');
      expect(agentAttachMenuDoc.dependencies, <String>[
        'agent-slash-palette',
        'button',
        'dropdown-menu',
        'icon',
        'menu',
        'popover',
        'source-foundation',
      ]);
      expect(agentAttachMenuDoc.exports, <String>['AgentAttachMenu']);
    });
  });
}
