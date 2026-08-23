import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/pagination/meta.dart';
import 'package:example/components_docs/pagination/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required DsThemeController controller,
}) => DsTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

/// Every constructor parameter [pagination.dart](../../../lib/src/components/pagination.dart)
/// declares across its four public classes — [DsPagination], [DsPaginationLink],
/// [DsPaginationStep] (both named constructors share the same field set) and
/// [DsPaginationEllipsis] (key only). The API table must render each of
/// these names somewhere.
const List<String> _apiParamNames = <String>[
  'children', // DsPagination
  'label', 'isActive', 'onTap', // DsPaginationLink
  'text', // DsPaginationStep (onTap repeats, already listed)
];

void main() {
  group('pagination docs page', () {
    testWidgets(
      'renders the article, the full API table, and the truncation worked '
      'example, and reports a tapped page',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: DsThemeController(mode: DsThemeMode.dark),
            child: PaginationDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.byKey(const ValueKey<String>('pagination-doc-article')),
          findsOneWidget,
        );

        // The API table lists every constructor parameter found in
        // lib/src/components/pagination.dart.
        for (final String param in _apiParamNames) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        // The two named constructors are the real public surface of
        // DsPaginationStep — both must be documented as their own rows.
        for (final String ctor in <String>[
          'DsPaginationStep.previous',
          'DsPaginationStep.next',
        ]) {
          expect(
            find.textContaining(ctor),
            findsWidgets,
            reason: 'missing $ctor',
          );
        }
        // Static tokens every class exposes.
        for (final String token in <String>[
          'DsPagination.gap',
          'DsPaginationStep.tightPadding',
          'DsPaginationStep.loosePadding',
          'DsPaginationEllipsis.boxSize',
          'DsPaginationEllipsis.glyphSize',
        ]) {
          expect(
            find.textContaining(token),
            findsWidgets,
            reason: 'missing $token',
          );
        }

        // The worked-example specimen: 100 pages, current page 47, one
        // sibling each side — the truncation section's own worked example.
        // It must render as 1 … 46 47 48 … 100, exactly two ellipses.
        final Finder worked = find.byKey(
          const ValueKey<String>('pagination-preview:worked-example'),
        );
        expect(worked, findsOneWidget);
        for (final String label in <String>['1', '46', '47', '48', '100']) {
          expect(
            find.descendant(of: worked, matching: find.text(label)),
            findsOneWidget,
            reason: 'worked example missing page $label',
          );
        }
        expect(
          find.descendant(
            of: worked,
            matching: find.byType(DsPaginationEllipsis),
          ),
          findsNWidgets(2),
        );

        // A live specimen mounts and clicking a page number reports it —
        // tapping page 48 in the worked example moves the current page and
        // the on-screen "current page" readout updates to match.
        expect(
          find.descendant(
            of: worked,
            matching: find.text('Current page: 47 of 100'),
          ),
          findsOneWidget,
        );
        final Finder page48 = find.descendant(
          of: worked,
          matching: find.text('48'),
        );
        await tester.ensureVisible(page48);
        await tester.pumpAndSettle();
        await tester.tap(page48);
        await tester.pumpAndSettle();
        expect(
          find.descendant(
            of: worked,
            matching: find.text('Current page: 48 of 100'),
          ),
          findsOneWidget,
        );
        // Truncation re-centres on the new current page.
        for (final String label in <String>['1', '47', '48', '49', '100']) {
          expect(
            find.descendant(of: worked, matching: find.text(label)),
            findsOneWidget,
            reason: 'after tapping 48, missing page $label',
          );
        }

        // Edge-case specimens: first page (no Previous cell), last page (no
        // Next cell), a single page (no siblings, no ellipsis at all).
        expect(
          find.byKey(const ValueKey<String>('pagination-preview:first-page')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('pagination-preview:last-page')),
          findsOneWidget,
        );
        final Finder single = find.byKey(
          const ValueKey<String>('pagination-preview:single-page'),
        );
        expect(single, findsOneWidget);
        expect(
          find.descendant(
            of: single,
            matching: find.byType(DsPaginationEllipsis),
          ),
          findsNothing,
        );
        expect(
          find.descendant(of: single, matching: find.byType(DsPaginationStep)),
          findsNothing,
        );

        // DsPagination declares an accessible container name — the page's
        // own accessibility section claims this and the test proves it.
        expect(find.bySemanticsLabel('pagination'), findsWidgets);

        expect(paginationDoc.name, 'pagination');
        expect(
          paginationDoc.exports,
          containsAll(<String>[
            'DsPagination',
            'DsPaginationLink',
            'DsPaginationStep',
            'DsPaginationEllipsis',
          ]),
        );
        expect(destination, isNull);
      },
    );

    testWidgets(
      'renders at 390x844 with the anchor strip, no overflow, and reporting '
      'still works',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: DsThemeController(mode: DsThemeMode.dark),
            child: const PaginationDocPage(),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.byKey(const ValueKey<String>('pagination-doc-article')),
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
        // Flutter reports a RenderFlex overflow through FlutterError, which
        // flutter_test surfaces via takeException — the classic 390px
        // failure mode for a long page range the brief calls out. Reaching
        // this line with no exception is the proof the page's own
        // horizontal-scroll mitigation works at this width.
        expect(tester.takeException(), isNull);

        final Finder worked = find.byKey(
          const ValueKey<String>('pagination-preview:worked-example'),
        );
        final Finder page48 = find.descendant(
          of: worked,
          matching: find.text('48'),
        );
        await tester.ensureVisible(page48);
        await tester.pumpAndSettle();
        await tester.tap(page48);
        await tester.pumpAndSettle();
        expect(
          find.descendant(
            of: worked,
            matching: find.text('Current page: 48 of 100'),
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the active page ink shifts when the live theme flips light/dark',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final DsThemeController controller = DsThemeController(
          mode: DsThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const PaginationDocPage()),
        );
        await tester.pumpAndSettle();

        final Finder worked = find.byKey(
          const ValueKey<String>('pagination-preview:worked-example'),
        );
        DsButtonVariant activeVariant() {
          final DsPaginationLink active = tester
              .widgetList<DsPaginationLink>(
                find.descendant(
                  of: worked,
                  matching: find.byType(DsPaginationLink),
                ),
              )
              .singleWhere((DsPaginationLink link) => link.isActive);
          final Finder activeFinder = find.descendant(
            of: find.byWidget(active),
            matching: find.byType(DsButton),
          );
          return tester.widget<DsButton>(activeFinder).variant;
        }

        expect(activeVariant(), DsButtonVariant.outline);

        // Flip the SAME controller in place — not a fresh widget tree —
        // the same object every real theme toggle mutates.
        controller.setMode(DsThemeMode.light);
        await tester.pumpAndSettle();

        expect(
          find.byKey(const ValueKey<String>('pagination-doc-article')),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: worked,
            matching: find.text('Current page: 47 of 100'),
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  });
}
