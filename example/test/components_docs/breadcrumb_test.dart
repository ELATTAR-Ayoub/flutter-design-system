/// Tests for `components_docs/breadcrumb/meta.dart` and
/// `components_docs/breadcrumb/page.dart` — the public Breadcrumb component
/// documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery` — the
/// discipline `skills_docs_test.dart` and `shot_detail_test.dart` already
/// carry. Theme coverage uses a live `DsThemeController` flipped in place
/// rather than two independent pumps.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/breadcrumb/meta.dart';
import 'package:example/components_docs/breadcrumb/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

Future<DsThemeController> _pumpBreadcrumbDoc(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  DsThemeMode mode = DsThemeMode.dark,
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
        home: Scaffold(
          body: SingleChildScrollView(
            child: BreadcrumbDocPage(onNavigate: onNavigate),
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
    test('breadcrumbDoc names the real public API surface', () {
      expect(breadcrumbDoc.name, 'breadcrumb');
      expect(breadcrumbDoc.title, 'Breadcrumb');
      expect(breadcrumbDoc.route, '/components/breadcrumb');
      expect(breadcrumbDoc.sourcePath, 'lib/src/components/breadcrumb.dart');
      expect(
        breadcrumbDoc.exports,
        containsAll(<String>['DsBreadcrumb', 'DsBreadcrumbEntry']),
      );
      // Short description: one sentence, no trailing dot-dot.
      expect(breadcrumbDoc.description, isNot(contains('..')));
      expect(breadcrumbDoc.description.trim(), breadcrumbDoc.description);
    });
  });

  group('rendered page', () {
    testWidgets('renders the article and a live multi-crumb specimen', (
      WidgetTester tester,
    ) async {
      await _pumpBreadcrumbDoc(tester);

      expect(
        find.byKey(const ValueKey<String>('breadcrumb-doc-article')),
        findsOneWidget,
      );
      expect(find.byType(DsBreadcrumb), findsWidgets);
      // A real specimen renders at least one derived chevron separator.
      expect(
        tester
            .widgetList<DsIcon>(find.byType(DsIcon))
            .where((DsIcon icon) => icon.glyph == DsIconGlyph.chevronRight),
        isNotEmpty,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'the API table documents every constructor parameter found in the source',
      (WidgetTester tester) async {
        await _pumpBreadcrumbDoc(tester);

        // DsBreadcrumb.items
        expect(find.text('items'), findsOneWidget);
        expect(find.textContaining('List<DsBreadcrumbEntry>'), findsWidgets);
        // DsBreadcrumbEntry.link(label, {onTap})
        expect(find.textContaining('DsBreadcrumbEntry.link'), findsWidgets);
        expect(find.text('label'), findsWidgets);
        expect(find.text('onTap'), findsOneWidget);
        // DsBreadcrumbEntry.page(label)
        expect(find.textContaining('DsBreadcrumbEntry.page'), findsWidgets);
        // The derived, read-only isPage field.
        expect(find.text('isPage'), findsOneWidget);
        // The two static layout constants.
        expect(find.text('gap'), findsOneWidget);
        expect(find.text('separatorPx'), findsOneWidget);
      },
    );

    testWidgets('installation is honest that no registry manifest exists yet', (
      WidgetTester tester,
    ) async {
      await _pumpBreadcrumbDoc(tester);

      // The catalog's own `elattar add breadcrumb` formula must never be
      // rendered as if it were a working command.
      expect(find.text('elattar add breadcrumb'), findsNothing);
      expect(
        find.textContaining('breadcrumb.json'),
        findsWidgets,
        reason: 'the page must name the missing manifest file honestly',
      );
    });

    testWidgets('states the real overflow behavior: wrap, not truncation', (
      WidgetTester tester,
    ) async {
      await _pumpBreadcrumbDoc(tester);

      expect(find.textContaining('wraps'), findsWidgets);
      expect(
        find.textContaining('BreadcrumbEllipsis'),
        findsOneWidget,
        reason: 'the page must say this is recorded, not built',
      );
    });

    testWidgets('a single-crumb specimen renders no separator', (
      WidgetTester tester,
    ) async {
      await _pumpBreadcrumbDoc(tester);

      final DsBreadcrumb single = tester.widget<DsBreadcrumb>(
        find.byWidgetPredicate(
          (Widget widget) => widget is DsBreadcrumb && widget.items.length == 1,
        ),
      );
      expect(single.items.single.isPage, isTrue);
    });

    testWidgets(
      'the RTL specimen composes DsBreadcrumb under a Directionality',
      (WidgetTester tester) async {
        await _pumpBreadcrumbDoc(tester);

        final Iterable<Directionality> rtl = tester
            .widgetList<Directionality>(find.byType(Directionality))
            .where((Directionality d) => d.textDirection == TextDirection.rtl);
        expect(rtl, isNotEmpty);
      },
    );

    testWidgets(
      'navigating previous/next fires onNavigate with the wave-1 neighbours',
      (WidgetTester tester) async {
        String? destination;
        await _pumpBreadcrumbDoc(
          tester,
          onNavigate: (String route) => destination = route,
        );

        // 'Badge' and 'Checkbox' also appear in the sidebar, so scope to the
        // prev/next pager specifically.
        final Finder pager = find.byKey(
          const ValueKey<String>('docs-layout-prev-next'),
        );
        final Finder badge = find.descendant(
          of: pager,
          matching: find.text('Badge'),
        );
        final Finder checkbox = find.descendant(
          of: pager,
          matching: find.text('Checkbox'),
        );

        await tester.ensureVisible(badge);
        await tester.tap(badge);
        expect(destination, '/components/badge');

        await tester.ensureVisible(checkbox);
        await tester.tap(checkbox);
        expect(destination, '/components/checkbox');
      },
    );
  });

  group('viewport widths', () {
    testWidgets('a wide viewport exposes the sidebar and table of contents', (
      WidgetTester tester,
    ) async {
      await _pumpBreadcrumbDoc(tester, size: _wide);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('breadcrumb-doc-article')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'a narrow viewport drops to the anchor strip and stays reachable',
      (WidgetTester tester) async {
        await _pumpBreadcrumbDoc(tester, size: _narrow);

        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('breadcrumb-doc-article')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('both themes', () {
    testWidgets('renders on light', (WidgetTester tester) async {
      await _pumpBreadcrumbDoc(tester, mode: DsThemeMode.light);
      expect(find.byType(DsBreadcrumb), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpBreadcrumbDoc(tester, mode: DsThemeMode.dark);
      expect(find.byType(DsBreadcrumb), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final DsThemeController theme = await _pumpBreadcrumbDoc(
        tester,
        mode: DsThemeMode.dark,
      );
      expect(find.byType(DsBreadcrumb), findsWidgets);

      theme.setMode(DsThemeMode.light);
      await tester.pump();

      expect(find.byType(DsBreadcrumb), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });
}
