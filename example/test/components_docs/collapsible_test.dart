/// Tests for `components_docs/collapsible/page.dart`'s [CollapsibleDocPage]
/// — the public documentation page for `DsCollapsible` (and the [DsUnfold]
/// animation it shares with `DsAccordion`).
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery` for
/// layout — the discipline `buttons_page_test.dart` established and
/// `docs_file_tree_test.dart` / `skills_docs_test.dart` carry forward. Motion
/// is frozen through `MediaQuery(disableAnimations: true)`, mounted below
/// `MaterialApp` so it reaches every descendant `DsUnfold`, rather than
/// pumping `DsDurations.jelly` / `DsDurations.base` by hand.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/collapsible/meta.dart';
import 'package:example/components_docs/collapsible/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

Future<DsThemeController> _pumpCollapsible(
  WidgetTester tester, {
  Size size = _wide,
  DsThemeMode mode = DsThemeMode.dark,
  ValueChanged<String>? onNavigate,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final DsThemeController theme = DsThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    DsTheme(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (BuildContext context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: Scaffold(
              body: SingleChildScrollView(
                child: CollapsibleDocPage(onNavigate: onNavigate),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  group('meta', () {
    test('collapsibleDoc names the real public API', () {
      expect(collapsibleDoc.name, 'collapsible');
      expect(collapsibleDoc.route, '/components/collapsible');
      expect(collapsibleDoc.sourcePath, 'lib/src/components/collapsible.dart');
      expect(
        collapsibleDoc.exports,
        containsAll(<String>['DsCollapsible', 'DsUnfold']),
      );
    });
  });

  group('page', () {
    testWidgets(
      'renders the article at 1440x900 and flips a live theme controller in place',
      (WidgetTester tester) async {
        final DsThemeController theme = await _pumpCollapsible(
          tester,
          size: _wide,
        );

        expect(
          find.byKey(const ValueKey<String>('collapsible-doc-article')),
          findsOneWidget,
        );
        expect(find.text('Collapsible'), findsWidgets);
        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsOneWidget,
        );
        expect(find.byType(DsCollapsible), findsWidgets);
        expect(tester.takeException(), isNull);

        // Same controller, flipped in place rather than rebuilt — dark then
        // light must both render the same tree without throwing.
        theme.setMode(DsThemeMode.light);
        await tester.pump();
        expect(
          find.byKey(const ValueKey<String>('collapsible-doc-article')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('exposes narrow anchors and no sidebar at 390x844', (
      WidgetTester tester,
    ) async {
      await _pumpCollapsible(tester, size: _narrow);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey<String>('collapsible-doc-article')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('the API tables document every DsCollapsible and DsUnfold '
        'constructor parameter', (WidgetTester tester) async {
      await _pumpCollapsible(tester);

      // `open` is shared by both DsCollapsible and DsUnfold.
      expect(find.text('open'), findsNWidgets(2));
      // DsCollapsible-only.
      expect(find.text('trigger'), findsOneWidget);
      expect(find.text('content'), findsOneWidget);
      // DsUnfold-only.
      expect(find.text('child'), findsOneWidget);
    });

    testWidgets(
      'the honest install section presents no copyable CLI command for '
      'collapsible',
      (WidgetTester tester) async {
        await _pumpCollapsible(tester);

        // The phrase may appear in explanatory prose (it does — the install
        // section explains why the command does not exist yet), but it must
        // never be rendered as a standalone, copyable command block.
        expect(
          find.text('elattar add collapsible'),
          findsNothing,
          reason:
              'a bare command-shaped text widget would read as copyable/'
              'runnable, which the component cannot back yet',
        );
        expect(find.textContaining('Not available yet'), findsWidgets);
      },
    );

    testWidgets(
      'the live specimen mounts closed, then expands and collapses on tap '
      'with motion frozen',
      (WidgetTester tester) async {
        await _pumpCollapsible(tester, size: const Size(900, 1400));

        // Closed by default: DsUnfold renders nothing for its content.
        expect(find.text('Volatility'), findsNothing);
        expect(find.text('Advanced filters'), findsOneWidget);

        await tester.ensureVisible(find.text('Advanced filters'));
        await tester.tap(find.text('Advanced filters'));
        await tester.pumpAndSettle();

        expect(find.text('Volatility'), findsOneWidget);

        await tester.tap(find.text('Advanced filters'));
        await tester.pumpAndSettle();

        expect(find.text('Volatility'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'two independent collapsibles in the composition example do not '
      'affect each other — the whole point versus an accordion',
      (WidgetTester tester) async {
        await _pumpCollapsible(tester, size: const Size(900, 1600));

        final Finder triggers = find.byKey(
          const ValueKey<String>('collapsible-doc-composition'),
        );
        expect(triggers, findsOneWidget);

        final Finder firstTrigger = find.descendant(
          of: triggers,
          matching: find.byKey(
            const ValueKey<String>('collapsible-doc-composition-a-trigger'),
          ),
        );
        await tester.ensureVisible(firstTrigger);
        await tester.tap(firstTrigger);
        await tester.pumpAndSettle();

        expect(
          find.byKey(
            const ValueKey<String>('collapsible-doc-composition-a-panel'),
          ),
          findsOneWidget,
        );
        expect(
          find.byKey(
            const ValueKey<String>('collapsible-doc-composition-b-panel'),
          ),
          findsNothing,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('CLI tab is absent from the live preview specimen', (
      WidgetTester tester,
    ) async {
      await _pumpCollapsible(tester);

      final DocsCodeExample example = tester.widget<DocsCodeExample>(
        find.byType(DocsCodeExample).first,
      );
      expect(example.hasCommand, isFalse);
      expect(example.hasManual, isTrue);
    });
  });
}
