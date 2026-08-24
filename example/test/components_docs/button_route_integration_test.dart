/// Final-integration coverage for `/components/button`: proves the three
/// pieces this pass wired together actually work as one.
///
/// * `main.dart` now dispatches `/components/button` to the reference page in
///   `components_docs/button/page.dart`, not the retired `ButtonDocPage` in
///   `button_card_pages.dart`: proven via keys unique to the reference
///   page's example sections like Size and Default, which the retired page
///   has no equivalent of.
/// * A component route's left rail is now `DocsLayout`'s new default —
///   "Sections" then "Components", the latter built from every
///   `components_docs/catalog.dart` entry: rather than the page's own
///   retired five-item list.
/// * The button page's TOC has fourteen example sections as top-level entries,
///   siblings of Installation and Usage, with no "Examples" wrapper. API
///   Reference is the only entry with nested [DocsTocEntry.children], and
///   activating a nested child scrolls the article rather than navigating away.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/catalog.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Real test-view sizing only, matching every other suite in this package.
void _setViewSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Widget _harness({required Widget child, ScrollController? scrollController}) =>
    ElTheme(
      controller: ElThemeController(mode: ElThemeMode.dark),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SingleChildScrollView(controller: scrollController, child: child),
      ),
    );

const Size _desktop = Size(1440, 900);

/// Every example anchor that is a top-level TOC entry in the button page: see
/// `components_docs/button/page.dart`'s `toc:` list.
const List<String> _exampleAnchors = <String>[
  'size',
  'default',
  'premium',
  'outline',
  'secondary',
  'ghost',
  'destructive',
  'link',
  'icon',
  'with-icon',
  'rounded',
  'spinner',
  'disabled',
  'emphasis',
];

void main() {
  testWidgets(
    '/components/button dispatches to the reference page, not the retired '
    'ButtonDocPage',
    (WidgetTester tester) async {
      _setViewSize(tester, _desktop);
      await tester.pumpWidget(
        _harness(
          child: publicPageFor('/components/button', onNavigate: (_) {}),
        ),
      );
      // One frame only: the Premium example's foil shimmer loops forever
      // and would hang a `pumpAndSettle()`.
      await tester.pump();

      // Both keys belong to Examples subsections only the reference page
      // builds (a per-ElButtonSize breakdown and the "Emphasis (caps)"
      // specimen); the retired `button_card_pages.dart` ButtonDocPage has
      // neither.
      expect(
        find.byKey(const ValueKey<String>('button-example:sizes-xl')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('button-example:emphasis')),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'the sidebar on a component route lists Sections and every catalog '
    'entry, with the current route marked active',
    (WidgetTester tester) async {
      _setViewSize(tester, _desktop);
      await tester.pumpWidget(
        _harness(
          child: publicPageFor('/components/button', onNavigate: (_) {}),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('docs-sidebar-group:Sections')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-sidebar-group:Components')),
        findsOneWidget,
      );

      for (final ComponentDocEntry entry in componentDocs) {
        expect(
          find.byKey(ValueKey<String>('docs-sidebar:${entry.route}')),
          findsOneWidget,
          reason: '${entry.route} missing from the component sidebar group',
        );
      }

      final Finder active = find.byKey(
        const ValueKey<String>('docs-sidebar:/components/button'),
      );
      final Finder inactive = find.byKey(
        const ValueKey<String>('docs-sidebar:/components/card'),
      );
      final BoxDecoration activeDecoration =
          tester.widget<Container>(active).decoration! as BoxDecoration;
      final BoxDecoration inactiveDecoration =
          tester.widget<Container>(inactive).decoration! as BoxDecoration;
      expect(activeDecoration.color, isNotNull);
      expect(inactiveDecoration.color, isNull);
    },
  );

  testWidgets(
    'the example sections are top-level TOC entries, with no Examples parent',
    (WidgetTester tester) async {
      _setViewSize(tester, _desktop);
      await tester.pumpWidget(
        _harness(
          child: publicPageFor('/components/button', onNavigate: (_) {}),
        ),
      );
      await tester.pump();

      // No "Examples" entry exists in the TOC.
      final Finder noExamples = find.byKey(
        const ValueKey<String>('docs-layout-toc-entry:examples'),
      );
      expect(noExamples, findsNothing);

      // All example anchors are top-level entries, not children.
      for (final String anchor in _exampleAnchors) {
        expect(
          find.byKey(ValueKey<String>('docs-layout-toc-entry:$anchor')),
          findsOneWidget,
          reason: '$anchor is not a top-level TOC entry',
        );
      }
    },
  );

  testWidgets(
    'activating a nested API Reference child scrolls the article; it never '
    'navigates away',
    (WidgetTester tester) async {
      _setViewSize(tester, _desktop);
      final List<String> routes = <String>[];
      final ScrollController page = ScrollController();
      addTearDown(page.dispose);

      await tester.pumpWidget(
        _harness(
          scrollController: page,
          child: publicPageFor('/components/button', onNavigate: routes.add),
        ),
      );
      await tester.pump();
      expect(page.offset, 0);

      await tester.tap(
        find.byKey(
          const ValueKey<String>('docs-layout-toc-child:api-elbutton'),
        ),
      );
      // Advance past the 400ms scroll-to-anchor animation without settling —
      // the Premium example's foil shimmer loops forever and would hang
      // `pumpAndSettle()`.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(routes, isEmpty, reason: 'a nested TOC anchor is not a route');
      expect(page.offset, greaterThan(0));
    },
  );
}
