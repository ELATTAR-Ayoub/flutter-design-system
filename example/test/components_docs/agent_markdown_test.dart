/// Tests for `components_docs/agent_markdown/page.dart`'s
/// [AgentMarkdownDocPage]: the agent-markdown component documentation page.
///
/// `agent_markdown.dart` declares three widgets ([AgentMarkdown],
/// [AgentCodeBlock], [PreformattedCode]) and two supporting classes
/// ([PrismPalette], [CodeToken]) this page documents — read directly
/// from `lib/src/components/agent_markdown.dart`. The parser's own block
/// model and top-level parse/render/tokenise functions are deliberately out
/// of scope for the API table, per the page's own library doc; this file
/// does not assert tables for them either.
///
/// No `pumpAndSettle` anywhere: only `tester.pump()`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/agent_markdown/meta.dart';
import 'package:example/components_docs/agent_markdown/page.dart';
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
import 'package:flutter/widgets.dart' as flutter show RichText, Table;
import 'package:flutter_test/flutter_test.dart';

const List<String> _expectedSectionOrder = <String>[
  'preview',
  'install',
  'usage',
  'lists',
  'table',
  'code-block',
  'links',
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
  'AgentMarkdown': <String>[
    'text',
    'textAlign',
    'blockGap',
    'listInset',
    'itemGap',
    'quoteInset',
    'quoteRule',
    'quoteRuleAlpha',
    'cellPadX',
    'cellPadY',
    'headingTop',
  ],
  'AgentCodeBlock': <String>[
    'code',
    'language',
    'plainPadding',
    'stripPadX',
    'stripPadY',
    'normalise(language)',
  ],
  'PreformattedCode': <String>['code', 'color'],
  'PrismPalette': <String>[
    'ground',
    'plain',
    'keyword',
    'string',
    'number',
    'function',
    'comment',
    'type',
    'padding',
    'margin',
    'lineHeight',
  ],
  'CodeToken': <String>['text', 'color'],
  'Top-level functions': <String>['safeHref(raw)', 'languageAliases'],
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
            child: AgentMarkdownDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  group('agent-markdown docs page', () {
    testWidgets(
      'renders the article at wide and narrow widths with no exceptions',
      (WidgetTester tester) async {
        await _pump(tester, size: _wide);

        expect(
          find.byKey(const ValueKey<String>('agent-markdown-doc-article')),
          findsOneWidget,
        );
        expect(find.text(agentMarkdownDoc.title), findsWidgets);
        expect(find.byType(DocsShowcase), findsNWidgets(5));
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
        agentMarkdownDocSpec.toc
            .map((DocsTocEntry entry) => entry.anchor)
            .toList(),
        _expectedSectionOrder,
      );
    });

    testWidgets(
      'each DocsApiTable covers every constructor parameter, public static '
      'or field found on the real class',
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
      'the Preview specimen renders the heading, the bold/italic run, both '
      'lists, the blockquote and the link label',
      (WidgetTester tester) async {
        await _pump(tester);

        final Finder body = find.byKey(
          const ValueKey<String>('agent-markdown-preview:body'),
        );
        await tester.ensureVisible(body);

        expect(
          find.descendant(of: body, matching: find.text('Findings')),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: body,
            matching: find.textContaining('Comparable #1 sold for \$420'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: body,
            matching: find.textContaining('Confirm condition grade'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: body,
            matching: find.textContaining('Sourced from three closed'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(of: body, matching: find.text('View the comps')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the Lists specimen carries the authored numbers 1 2 3 4 across the '
      'blank-line split, not a reset to 1 2 1 2',
      (WidgetTester tester) async {
        await _pump(tester);

        final Finder body = find.byKey(
          const ValueKey<String>('agent-markdown-example:lists'),
        );
        await tester.ensureVisible(body);

        for (final String marker in <String>['1.', '2.', '3.', '4.']) {
          expect(
            find.descendant(of: body, matching: find.text(marker)),
            findsOneWidget,
            reason: 'marker "$marker" missing or duplicated',
          );
        }
        expect(
          find.descendant(of: body, matching: find.text('First pull')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'the Table specimen renders a real Table with the header and body '
      'cells the source declares',
      (WidgetTester tester) async {
        await _pump(tester);

        final Finder body = find.byKey(
          const ValueKey<String>('agent-markdown-example:table'),
        );
        await tester.ensureVisible(body);

        expect(
          find.descendant(of: body, matching: find.byType(flutter.Table)),
          findsOneWidget,
        );
        for (final String cell in <String>[
          'Card',
          'Grade',
          'Price',
          'Charizard',
          'PSA 9',
          'Blastoise',
        ]) {
          expect(
            find.descendant(of: body, matching: find.text(cell)),
            findsOneWidget,
            reason: 'cell "$cell" missing',
          );
        }
      },
    );

    testWidgets(
      'the Code block specimen highlights the recognised ts fence and '
      'falls back to a plain block for the unrecognised swift one',
      (WidgetTester tester) async {
        await _pump(tester);

        final Finder body = find.byKey(
          const ValueKey<String>('agent-markdown-example:code-block'),
        );
        await tester.ensureVisible(body);

        expect(
          find.descendant(of: body, matching: find.byType(AgentCodeBlock)),
          findsNWidgets(2),
        );
        // Only the recognised fence prints a normalised language label —
        // TextStyles.eyebrowSmall renders it visually uppercase (text-transform is
        // applied to the string StyledText paints, not to the source), so the
        // label reads "TYPESCRIPT" rather than "typescript".
        expect(
          find.descendant(of: body, matching: find.text('TYPESCRIPT')),
          findsOneWidget,
        );
        expect(
          find.descendant(of: body, matching: find.text('SWIFT')),
          findsNothing,
        );
        expect(
          find.descendant(
            of: body,
            matching: find.textContaining('function total'),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('the Links specimen renders every label as text, including the '
        'refused javascript: one, and none of them expose a tap recognizer', (
      WidgetTester tester,
    ) async {
      await _pump(tester);

      final Finder body = find.byKey(
        const ValueKey<String>('agent-markdown-example:links'),
      );
      await tester.ensureVisible(body);

      expect(
        find.descendant(of: body, matching: find.text('View the comps')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: body,
          matching: find.text('https://example.com/bare-url'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(of: body, matching: find.text('Click me')),
        findsOneWidget,
      );
      // The refused markdown syntax itself never leaks as literal text:
      // it was parsed as a link, just an unsafe one.
      expect(
        find.descendant(of: body, matching: find.textContaining('[Click me]')),
        findsNothing,
      );

      // No inline span anywhere on this page carries a tap recognizer —
      // this renderer draws links, it does not wire them.
      final Iterable<flutter.RichText> richTexts = tester
          .widgetList<flutter.RichText>(
            find.descendant(of: body, matching: find.byType(flutter.RichText)),
          );
      bool hasRecognizer(InlineSpan span) {
        bool found = false;
        span.visitChildren((InlineSpan child) {
          if (child is TextSpan && child.recognizer != null) found = true;
          if (found) return false;
          return true;
        });
        return found;
      }

      for (final flutter.RichText rich in richTexts) {
        expect(hasRecognizer(rich.text), isFalse);
      }
    });

    testWidgets(
      'both themes render the article with no exceptions when flipped in '
      'place',
      (WidgetTester tester) async {
        final ThemeController theme = await _pump(
          tester,
          mode: ColorMode.light,
        );
        expect(find.text(agentMarkdownDoc.title), findsWidgets);

        theme.setMode(ColorMode.dark);
        await tester.pump();
        expect(find.text(agentMarkdownDoc.title), findsWidgets);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'installation shows the real elattar add agent-markdown command',
      (WidgetTester tester) async {
        await _pump(tester);

        expect(find.textContaining('elattar add agent-markdown'), findsWidgets);
        expect(agentMarkdownDoc.command, 'elattar add agent-markdown');
        expect(agentMarkdownDoc.route, '/components/agent_markdown');
      },
    );

    test('meta carries the manifest dependencies verbatim', () {
      expect(agentMarkdownDoc.name, 'agent_markdown');
      expect(agentMarkdownDoc.dependencies, <String>['source-foundation']);
      expect(
        agentMarkdownDoc.exports,
        containsAll(<String>[
          'AgentMarkdown',
          'AgentCodeBlock',
          'PreformattedCode',
          'PrismPalette',
          'CodeToken',
          'safeHref',
          'languageAliases',
        ]),
      );
    });
  });
}
