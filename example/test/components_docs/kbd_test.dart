/// Tests for `components_docs/kbd/meta.dart` and
/// `components_docs/kbd/page.dart`: the public documentation page for Kbd,
/// re-housed onto the kit (`ComponentDocSpec` + `ComponentDocPage`), the
/// same shape `button_test.dart` covers.
///
/// API Reference, Accessibility, and Keyboard are all `DisclosureSection`s,
/// closed by default and mounting no content while closed (see
/// `docs_disclosure_test.dart`), so tests that read their content open the
/// relevant `DocsDisclosure` first — the same fix `button_test.dart` needed
/// for its own API table.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/kbd/meta.dart';
import 'package:example/components_docs/kbd/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required ElThemeController controller,
}) => ElTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
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
  await tester.pump(ElDurations.jelly);
}

void main() {
  group('kbd docs page', () {
    testWidgets(
      'renders the article, the API tables, and live specimens of ElKbd '
      'and ElKbdGroup',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: KbdDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('kbd-doc-article')),
          findsOneWidget,
        );

        await _open(tester, 'API Reference');

        expect(find.text('text'), findsWidgets);
        expect(find.text('children'), findsWidgets);

        expect(find.byType(ElKbd), findsWidgets);
        expect(find.byType(ElKbdGroup), findsWidgets);

        expect(kbdDoc.name, 'kbd');
        expect(kbdDoc.exports, containsAll(<String>['ElKbd', 'ElKbdGroup']));
        expect(kbdDoc.command, 'elattar add kbd');
        expect(destination, isNull);
      },
    );

    testWidgets(
      'the page is declared, and every section is a kit component',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const KbdDocPage(),
          ),
        );
        await tester.pump();

        // Five specimen stages: Preview, Group, Button, Input group, RTL.
        expect(find.byType(DocsShowcase), findsNWidgets(5));
        expect(find.byType(DocsInstall), findsOneWidget);
        // Eight collapsed sections: API Reference, States, Accessibility,
        // Keyboard, Responsive, Dependencies, Theming, Source.
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const KbdDocPage(),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('kbd-doc-article')),
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
      'renders the shadcn-shaped section list, in order, with Tooltip '
      'honestly skipped',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const KbdDocPage(),
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
          'group',
          'button',
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
        ]);

        expect(sectionTitles, isNot(contains('Tooltip')));
      },
    );

    testWidgets('ElKbdGroup merges its children\'s semantics into one node', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ElThemeController(mode: ElThemeMode.dark),
          child: const KbdDocPage(),
        ),
      );

      expect(find.byType(MergeSemantics), findsWidgets);
    });

    testWidgets('keyboard section documents that ElKbd is never focusable', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ElThemeController(mode: ElThemeMode.dark),
          child: const KbdDocPage(),
        ),
      );

      await _open(tester, 'Keyboard');

      expect(find.textContaining('Never focusable'), findsWidgets);
    });

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
              _harness(controller: controller, child: const KbdDocPage()),
            );

            expect(
              find.byKey(const ValueKey<String>('kbd-doc-article')),
              findsOneWidget,
              reason: 'at $size in $mode',
            );
            expect(find.byType(ElKbd), findsWidgets);
          }
        }
      },
    );
  });
}
