/// Tests for `components_docs/empty/page.dart`'s [EmptyDocPage].
///
/// Re-housed onto the kit alongside the page: the section-order test now
/// reads `DocsSection.id`/`.title`, and the API-table reads open the
/// `DocsDisclosure` first — closed by default, unlike the old page's
/// always-visible `ElSection`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/empty/meta.dart';
import 'package:example/components_docs/empty/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required ElThemeController controller,
}) => ElTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

/// The single `DocsDisclosure` whose title is [title].
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

const List<String> _sectionIds = <String>[
  'preview',
  'install',
  'usage',
  'composition',
  'input-group',
  'rtl',
  'api',
  'states',
  'accessibility',
  'keyboard',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

const List<String> _sectionTitles = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Composition',
  'Input group',
  'RTL',
  'API Reference',
  'States',
  'Accessibility',
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

void main() {
  group('empty docs page', () {
    testWidgets(
      'renders the article, the API tables, and live specimens of every part',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: EmptyDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('empty-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        for (final String param in <String>[
          'children',
          'glyph',
          'tone',
          'text',
        ]) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        expect(find.byType(ElEmpty), findsWidgets);
        expect(find.byType(ElEmptyHeader), findsWidgets);
        expect(find.byType(ElEmptyMedia), findsWidgets);
        expect(find.byType(ElEmptyTitle), findsWidgets);
        expect(find.byType(ElEmptyDescription), findsWidgets);
        expect(find.byType(ElEmptyContent), findsWidgets);

        expect(emptyDoc.name, 'empty');
        expect(
          emptyDoc.exports,
          containsAll(<String>[
            'ElEmpty',
            'ElEmptyHeader',
            'ElEmptyMedia',
            'ElEmptyTitle',
            'ElEmptyDescription',
            'ElEmptyContent',
          ]),
        );
        expect(emptyDoc.command, 'elattar add empty');
        expect(destination, isNull);
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        emptyDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        _sectionTitles,
      );
    });

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const EmptyDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('empty-doc-article')),
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
      'renders the shadcn-shaped section list, in order, with Outline/'
      'Background/Avatar/Avatar Group honestly skipped',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const EmptyDocPage(),
          ),
        );
        await tester.pump();

        final List<DocsSection> sections = tester
            .widgetList<DocsSection>(find.byType(DocsSection))
            .toList();
        final List<String> sectionIds = sections
            .map((DocsSection section) => section.id)
            .toList();
        final List<String> sectionTitles = sections
            .map((DocsSection section) => section.title)
            .toList();

        expect(sectionIds, _sectionIds);
        expect(sectionTitles, _sectionTitles);

        expect(sectionTitles, isNot(contains('Outline')));
        expect(sectionTitles, isNot(contains('Background')));
        expect(sectionTitles, isNot(contains('Avatar')));
        expect(sectionTitles, isNot(contains('Avatar Group')));

        // Eight collapsed sections: API Reference, States, Accessibility,
        // Keyboard, Responsive, Dependencies, Theming, Source.
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    testWidgets(
      'components render correctly in both themes at both breakpoints',
      (WidgetTester tester) async {
        for (final Size size in <Size>[
          const Size(390, 844),
          const Size(1440, 900),
        ]) {
          for (final ElThemeMode mode in <ElThemeMode>[
            ElThemeMode.light,
            ElThemeMode.dark,
          ]) {
            tester.view.physicalSize = size;
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.reset);

            final ElThemeController controller = ElThemeController(mode: mode);
            await tester.pumpWidget(
              _harness(controller: controller, child: const EmptyDocPage()),
            );
            await tester.pump();

            expect(
              find.byKey(const ValueKey<String>('empty-doc-article')),
              findsOneWidget,
              reason: 'at $size in $mode',
            );
            expect(find.byType(ElEmpty), findsWidgets);
          }
        }
      },
    );
  });
}
