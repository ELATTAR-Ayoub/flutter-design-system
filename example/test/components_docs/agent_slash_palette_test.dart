/// Tests for `components_docs/agent_slash_palette/page.dart`'s
/// [AgentSlashPaletteDocPage]: the agent-slash-palette component
/// documentation page.
///
/// `agent_slash_palette.dart` declares one widget ([AgentSlashPalette]),
/// one data class ([AgentCommand]), one enum ([AgentCommandGroup]), and
/// two top-level functions ([slashQuery], [filterCommands]) — read
/// directly from `lib/src/components/agent_slash_palette.dart`. The
/// API-completeness test below checks each `DocsApiTable` by its own title,
/// not a flat merged set, so a table missing one field cannot hide behind
/// another table that happens to share a name.
///
/// No `pumpAndSettle` anywhere: the Preview specimen's entrance is a real
/// `TweenAnimationBuilder`, not a looping animation, but this file follows
/// the house rule regardless and only ever calls `tester.pump()` /
/// `tester.pump(duration)`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/agent_slash_palette/meta.dart';
import 'package:example/components_docs/agent_slash_palette/page.dart';
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
  'groups',
  'active-row',
  'filtering',
  'api',
  'states',
  'accessibility',
  'keyboard',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

/// Every `DocsApiTable` this page must render, by title, and every named
/// constructor parameter / public field / public static / enum value found
/// by reading `lib/src/components/agent_slash_palette.dart` directly.
const Map<String, List<String>> _expectedApiTables = <String, List<String>>{
  'AgentSlashPalette': <String>[
    'commands',
    'activeIndex',
    'onSelect',
    'onHover',
  ],
  'AgentSlashPalette static values': <String>[
    'maxHeight',
    'bottomGap',
    'entrance',
    'rise',
    'headingInsets',
    'rowInsets',
    'rowGap',
    'lineGap',
    'glyphTopInset',
    'glyphSize',
    'lucideStroke',
    'scrollsGroupsNotRows',
  ],
  'AgentCommand': <String>[
    'id',
    'label',
    'hint',
    'group',
    'icon',
    'run',
    'directive',
  ],
  'AgentCommandGroup': <String>['skill', 'command'],
  'Top-level functions': <String>[
    'slashQuery(value, caret)',
    'filterCommands(commands, query)',
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
            child: AgentSlashPaletteDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  group('agent-slash-palette docs page', () {
    testWidgets(
      'renders the article at wide and narrow widths with no exceptions',
      (WidgetTester tester) async {
        await _pump(tester, size: _wide);

        expect(
          find.byKey(const ValueKey<String>('agent-slash-palette-doc-article')),
          findsOneWidget,
        );
        expect(find.text(agentSlashPaletteDoc.title), findsWidgets);
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
        agentSlashPaletteDocSpec.toc
            .map((DocsTocEntry entry) => entry.anchor)
            .toList(),
        _expectedSectionOrder,
      );
    });

    testWidgets(
      'each DocsApiTable covers every constructor parameter, static, field '
      'or enum value found on the real class',
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
      'the Preview specimen hovers to move the highlight and selecting a '
      'row updates the status line',
      (WidgetTester tester) async {
        await _pump(tester);

        final Finder palette = find.byKey(
          const ValueKey<String>('agent-slash-palette-preview:palette'),
        );
        await tester.ensureVisible(palette);
        expect(palette, findsOneWidget);
        expect(tester.widget<AgentSlashPalette>(palette).activeIndex, 0);

        final Finder status = find.byKey(
          const ValueKey<String>('agent-slash-palette-preview:status'),
        );
        expect(tester.widget<StyledText>(status).text, 'Hover or tap a row.');

        // Select the first row (find-comps) directly, since the row itself
        // is a Listener bound to onPointerDown, not a plain tap target. The
        // row's id line is rendered as one RichText spanning '/' +
        // command.id, so its plain text is '/find-comps', not 'find-comps'.
        // Scoped to this specimen's own palette: the same sample command
        // list is reused by the Groups and Active row specimens further
        // down the page, so an unscoped find.text would match more than
        // one row.
        await tester.tap(
          find.descendant(of: palette, matching: find.text('/find-comps')),
          warnIfMissed: false,
        );
        await tester.pump();

        expect(tester.widget<StyledText>(status).text, 'Selected: /find-comps');
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the Groups specimen shows a lone Skills heading and a lone Commands '
      'heading, never both on the same palette',
      (WidgetTester tester) async {
        await _pump(tester);

        final Finder skillsOnly = find.byKey(
          const ValueKey<String>('agent-slash-palette-example:skills-only'),
        );
        final Finder commandsOnly = find.byKey(
          const ValueKey<String>('agent-slash-palette-example:commands-only'),
        );
        await tester.ensureVisible(skillsOnly);

        expect(
          find.descendant(of: skillsOnly, matching: find.text('Skills')),
          findsOneWidget,
        );
        expect(
          find.descendant(of: skillsOnly, matching: find.text('Commands')),
          findsNothing,
        );
        expect(
          find.descendant(of: commandsOnly, matching: find.text('Commands')),
          findsOneWidget,
        );
        expect(
          find.descendant(of: commandsOnly, matching: find.text('Skills')),
          findsNothing,
        );
      },
    );

    testWidgets('the Active row specimen carries a fixed activeIndex of 2', (
      WidgetTester tester,
    ) async {
      await _pump(tester);

      final Finder specimen = find.byKey(
        const ValueKey<String>('agent-slash-palette-example:active-row'),
      );
      await tester.ensureVisible(specimen);

      expect(tester.widget<AgentSlashPalette>(specimen).activeIndex, 2);
    });

    testWidgets(
      'the Filtering specimen narrows the palette to matching commands as '
      'the field changes, through the real slashQuery/filterCommands',
      (WidgetTester tester) async {
        await _pump(tester);

        final Finder input = find.byKey(
          const ValueKey<String>('agent-slash-palette-example:filter-input'),
        );
        final Finder filtered = find.byKey(
          const ValueKey<String>('agent-slash-palette-example:filtered'),
        );
        await tester.ensureVisible(input);

        // Unfiltered: all four sample commands are candidates.
        expect(
          tester.widget<AgentSlashPalette>(filtered).commands,
          hasLength(4),
        );

        await tester.enterText(input, '/clear');
        await tester.pump();

        expect(
          tester
              .widget<AgentSlashPalette>(filtered)
              .commands
              .map((AgentCommand c) => c.id),
          <String>['clear'],
        );

        // A slash query that is not a slash at all closes the candidate
        // list down to nothing, per slashQuery's own contract.
        await tester.enterText(input, 'clear');
        await tester.pump();

        expect(tester.widget<AgentSlashPalette>(filtered).commands, isEmpty);

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
        expect(find.text(agentSlashPaletteDoc.title), findsWidgets);

        theme.setMode(ColorMode.dark);
        await tester.pump();
        expect(find.text(agentSlashPaletteDoc.title), findsWidgets);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'installation shows the real elattar add agent-slash-palette command',
      (WidgetTester tester) async {
        await _pump(tester);

        expect(
          find.textContaining('elattar add agent-slash-palette'),
          findsWidgets,
        );
        expect(agentSlashPaletteDoc.command, 'elattar add agent-slash-palette');
        expect(agentSlashPaletteDoc.route, '/components/agent_slash_palette');
      },
    );

    test('meta carries the manifest dependencies verbatim', () {
      expect(agentSlashPaletteDoc.name, 'agent_slash_palette');
      expect(agentSlashPaletteDoc.dependencies, <String>[
        'icon',
        'source-foundation',
      ]);
      expect(
        agentSlashPaletteDoc.exports,
        containsAll(<String>[
          'AgentSlashPalette',
          'AgentCommand',
          'AgentCommandGroup',
          'slashQuery',
          'filterCommands',
        ]),
      );
    });
  });
}
