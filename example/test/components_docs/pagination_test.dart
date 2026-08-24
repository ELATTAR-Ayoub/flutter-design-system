/// Tests for `components_docs/pagination/meta.dart` and
/// `components_docs/pagination/page.dart`: the public Pagination component
/// documentation page.
///
/// The page mirrors `https://ui.shadcn.com/docs/components/base/pagination`
/// section for section: a live demo ahead of any heading, then
/// Installation, Usage, Composition, Truncation, Simple, Icons only, RTL,
/// API Reference, then this package's own six (States, Accessibility,
/// Responsive, Dependencies, Theming, Source). The first test below asserts
/// that exact order renders; it is the test the brief calls out as the one
/// that must fail against the pre-reshape page.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/pagination/meta.dart';
import 'package:example/components_docs/pagination/page.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required ElThemeController controller,
}) => ElTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

/// Every constructor parameter [pagination.dart](../../../lib/src/components/pagination.dart)
/// declares across its four public classes: [ElPagination], [ElPaginationLink],
/// [ElPaginationStep] (both named constructors share the same field set) and
/// [ElPaginationEllipsis] (key only). The API table must render each of
/// these names somewhere.
const List<String> _apiParamNames = <String>[
  'children', // ElPagination
  'label', 'isActive', 'onTap', // ElPaginationLink
  'text', // ElPaginationStep (onTap repeats, already listed)
];

void main() {
  group('pagination docs page', () {
    testWidgets(
      'sections render in the shadcn-mirrored order, section for section',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const PaginationDocPage(),
          ),
        );
        await tester.pumpAndSettle();

        final List<String> titles = tester
            .widgetList<ElSection>(find.byType(ElSection))
            .map((ElSection section) => section.title)
            .toList();

        expect(titles, <String>[
          'Installation',
          'Usage',
          'Composition',
          'Truncation',
          'Simple',
          'Icons only',
          'RTL',
          'API Reference',
          'States',
          'Accessibility',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ]);
      },
    );

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
            controller: ElThemeController(mode: ElThemeMode.dark),
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
        // ElPaginationStep: both must be documented as their own rows.
        for (final String ctor in <String>[
          'ElPaginationStep.previous',
          'ElPaginationStep.next',
        ]) {
          expect(
            find.textContaining(ctor),
            findsWidgets,
            reason: 'missing $ctor',
          );
        }
        // Static tokens every class exposes.
        for (final String token in <String>[
          'ElPagination.gap',
          'ElPaginationStep.tightPadding',
          'ElPaginationStep.loosePadding',
          'ElPaginationEllipsis.boxSize',
          'ElPaginationEllipsis.glyphSize',
        ]) {
          expect(
            find.textContaining(token),
            findsWidgets,
            reason: 'missing $token',
          );
        }

        // The live-demo worked example, ahead of any heading: 100 pages,
        // current page 47, one sibling each side. It must render as
        // 1 … 46 47 48 … 100, exactly two ellipses.
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
            matching: find.byType(ElPaginationEllipsis),
          ),
          findsNWidgets(2),
        );

        // A live specimen mounts and clicking a page number reports it:
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

        // Boundary specimens now live in the Truncation section: first
        // page (no Previous cell), last page (no Next cell), a single page
        // (no siblings, no ellipsis at all).
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
            matching: find.byType(ElPaginationEllipsis),
          ),
          findsNothing,
        );
        expect(
          find.descendant(of: single, matching: find.byType(ElPaginationStep)),
          findsNothing,
        );

        // ElPagination declares an accessible container name: the page's
        // own Accessibility section claims this and the test proves it.
        expect(find.bySemanticsLabel('pagination'), findsWidgets);

        expect(paginationDoc.name, 'pagination');
        expect(
          paginationDoc.exports,
          containsAll(<String>[
            'ElPagination',
            'ElPaginationLink',
            'ElPaginationStep',
            'ElPaginationEllipsis',
          ]),
        );
        expect(destination, isNull);
      },
    );

    testWidgets(
      'Simple, Icons only, and RTL each mount a real, distinct specimen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const PaginationDocPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Simple: page links only, no Previous/Next, no ellipsis.
        final Finder simple = find.byKey(
          const ValueKey<String>('pagination-simple'),
        );
        expect(simple, findsOneWidget);
        expect(
          find.descendant(of: simple, matching: find.byType(ElPaginationStep)),
          findsNothing,
        );
        expect(
          find.descendant(
            of: simple,
            matching: find.byType(ElPaginationEllipsis),
          ),
          findsNothing,
        );
        expect(
          find.descendant(of: simple, matching: find.byType(ElPaginationLink)),
          findsNWidgets(5),
        );

        // Icons only: Previous/Next only, no page-number links.
        final Finder iconsOnly = find.byKey(
          const ValueKey<String>('pagination-icons-only'),
        );
        expect(iconsOnly, findsOneWidget);
        expect(
          find.descendant(
            of: iconsOnly,
            matching: find.byType(ElPaginationLink),
          ),
          findsNothing,
        );
        expect(
          find.descendant(
            of: iconsOnly,
            matching: find.byType(ElPaginationStep),
          ),
          findsNWidgets(2),
        );

        // RTL: composed under a real Directionality.rtl ancestor.
        final Finder rtl = find.byKey(const ValueKey<String>('pagination-rtl'));
        expect(rtl, findsOneWidget);
        expect(
          find.ancestor(
            of: rtl,
            matching: find.byWidgetPredicate(
              (Widget widget) =>
                  widget is Directionality &&
                  widget.textDirection == TextDirection.rtl,
            ),
          ),
          findsWidgets,
        );
        expect(
          find.descendant(of: rtl, matching: find.text('السابق')),
          findsOneWidget,
        );
        expect(
          find.descendant(of: rtl, matching: find.text('التالي')),
          findsOneWidget,
        );
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
            controller: ElThemeController(mode: ElThemeMode.dark),
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
        // flutter_test surfaces via takeException: the classic 390px
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

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const PaginationDocPage()),
        );
        await tester.pumpAndSettle();

        final Finder worked = find.byKey(
          const ValueKey<String>('pagination-preview:worked-example'),
        );
        ElButtonVariant activeVariant() {
          final ElPaginationLink active = tester
              .widgetList<ElPaginationLink>(
                find.descendant(
                  of: worked,
                  matching: find.byType(ElPaginationLink),
                ),
              )
              .singleWhere((ElPaginationLink link) => link.isActive);
          final Finder activeFinder = find.descendant(
            of: find.byWidget(active),
            matching: find.byType(ElButton),
          );
          return tester.widget<ElButton>(activeFinder).variant;
        }

        expect(activeVariant(), ElButtonVariant.outline);

        // Flip the SAME controller in place, not a fresh widget tree: the
        // same object every real theme toggle mutates.
        controller.setMode(ElThemeMode.light);
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
