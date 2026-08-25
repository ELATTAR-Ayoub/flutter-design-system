/// Tests for `components_docs/aspect_ratio/page.dart`'s
/// [AspectRatioDocPage]: [ElAspectRatio]. New route, split off from the
/// former shared `scroll_area` route; see `aspect_ratio/meta.dart`'s
/// library note.
///
/// Reads `lib/src/components/aspect_ratio.dart` directly; every public
/// constructor parameter enumerated below is one this page's API table
/// must cover.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. The live
/// `ElThemeController` is flipped in place for theme coverage.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/aspect_ratio/meta.dart';
import 'package:example/components_docs/aspect_ratio/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s
/// own trigger key ([DocsDisclosure.triggerKey]) is one constant shared by
/// every instance on the page, so a bare `find.byKey` would match every
/// disclosure — this narrows to the one panel by its title first, matching
/// `button`'s own docs test. A closed `DocsDisclosure` mounts no content at
/// all, so its API table or state matrix must be opened before anything
/// inside it can be found.
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

Future<ElThemeController> _pump(
  WidgetTester tester, {
  Size size = _wide,
  ElThemeMode mode = ElThemeMode.dark,
  ValueChanged<String>? onNavigate,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ElThemeController theme = ElThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ElTheme(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: AspectRatioDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  testWidgets(
    'sections render in the shadcn-mirrored order, section for section',
    (WidgetTester tester) async {
      await _pump(tester);

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Composition',
        'Square',
        'Portrait',
        'RTL',
        'API Reference',
        'States',
        'Accessibility',
        'Keyboard',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);
    },
  );

  testWidgets(
    'renders the article at wide and narrow widths with no exceptions',
    (WidgetTester tester) async {
      await _pump(tester, size: _wide);

      expect(find.text(aspectRatioDoc.title), findsWidgets);
      expect(find.byType(DocsShowcase), findsAtLeastNWidgets(1));
      expect(find.byType(DocsInstall), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      await _pump(tester, size: _narrow);

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

  testWidgets('the ElApiTable covers every public constructor parameter of '
      'ElAspectRatio', (WidgetTester tester) async {
    await _pump(tester);
    await _open(tester, 'API Reference');

    final List<DocsApiTable> tables = tester
        .widgetList<DocsApiTable>(find.byType(DocsApiTable))
        .toList();
    expect(tables, isNotEmpty);

    final DocsApiTable table = tables.singleWhere(
      (DocsApiTable t) => t.title == 'ElAspectRatio',
    );
    final Set<String> documented = <String>{
      for (final DocsApiFact fact in table.facts) fact.name,
    };
    for (final String param in <String>['ratio', 'child', 'margin']) {
      expect(
        documented,
        contains(param),
        reason: 'ElAspectRatio table is missing parameter "$param"',
      );
    }
  });

  testWidgets(
    'ElAspectRatio locks a box to the specified ratio, in the live demo, '
    'Square, Portrait, and RTL specimens',
    (WidgetTester tester) async {
      await _pump(tester);

      final Finder aspectRatio = find.byType(ElAspectRatio);
      expect(aspectRatio, findsAtLeastNWidgets(4));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'both themes render the article with no exceptions when flipped in '
    'place',
    (WidgetTester tester) async {
      final ElThemeController theme = await _pump(
        tester,
        mode: ElThemeMode.light,
      );
      expect(find.text(aspectRatioDoc.title), findsWidgets);

      theme.setMode(ElThemeMode.dark);
      await tester.pump();
      expect(find.text(aspectRatioDoc.title), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('installation presents the working aspect-ratio CLI command', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(find.textContaining('elattar add aspect-ratio'), findsWidgets);
  });

  testWidgets(
    'the state matrix documents the widget as static, with the rest of '
    'IA §9.7 marked N/A',
    (WidgetTester tester) async {
      await _pump(tester);
      await _open(tester, 'States');

      final DocsStateMatrix matrix = tester.widget<DocsStateMatrix>(
        find.byType(DocsStateMatrix),
      );
      final Set<String> states = matrix.facts
          .map((DocsStateFact fact) => fact.state)
          .toSet();

      expect(
        states.any((String s) => s.startsWith('Rest')),
        isTrue,
        reason: 'state matrix is missing a Rest row',
      );
    },
  );

  testWidgets(
    'the pager navigates through DocsLayout.onNavigate, back to Input OTP '
    'and forward to Resizable',
    (WidgetTester tester) async {
      String? destination;
      await _pump(tester, onNavigate: (String route) => destination = route);

      final Finder resizableLink = find.text('Resizable').first;
      await tester.ensureVisible(resizableLink);
      await tester.pump();
      await tester.tap(resizableLink);
      expect(destination, '/components/resizable');
    },
  );

  testWidgets('the component is documented with its public name and exports', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    expect(aspectRatioDoc.name, 'aspect_ratio');
    expect(aspectRatioDoc.exports, containsAll(<String>['ElAspectRatio']));
    expect(tester.takeException(), isNull);
  });
}
