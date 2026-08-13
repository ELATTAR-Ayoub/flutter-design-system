/// `/design-system` — what the overview page has to say, and where it gets it.
///
/// The page authors four strings' worth of copy and reads everything else out
/// of the nav registry, so these tests check both halves: the verbatim copy
/// (header, section headings, the six rules, the closing note) and the fact
/// that every card title, blurb, chip and count came from `nav.dart` rather
/// than from a second list typed into the page.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/overview.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A surface wide enough for `xl:grid-cols-3` (1280px) — the docs frame is
/// 1440, which is what the reference is designed against.
const Size _frame = Size(1440, 4000);

Widget _harness(Widget child, {AppRouter? router}) {
  return DsTheme(
    controller: DsThemeController(mode: DsThemeMode.dark),
    child: AppRouterScope(
      router: router ?? AppRouter(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SingleChildScrollView(child: child),
      ),
    ),
  );
}

Future<void> _pumpOverview(WidgetTester tester, {AppRouter? router}) async {
  tester.view.physicalSize = _frame;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_harness(const OverviewPage(), router: router));
}

TextStyle _styleOf(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text)).style!;

/// The `Text.rich` paragraph whose plain text contains [needle].
RichText _richContaining(WidgetTester tester, String needle) =>
    tester.widget<RichText>(
      find.textContaining(needle, findRichText: true).first,
    );

void main() {
  group('header', () {
    testWidgets('eyebrow, title and lead — and no chip row',
        (WidgetTester tester) async {
      await _pumpOverview(tester);

      // `.type-label` uppercases at paint; the source string keeps its case.
      expect(
        _styleOf(tester, "ELATTAR'S DESIGN SYSTEM").color,
        DsThemeData.dark.actionInk,
      );
      expect(_styleOf(tester, 'Design System').fontSize, DsType.h1Size(1440));
      expect(
        find.text(
          'The operating manual. Two brand roles named for what they mean '
          'rather than what they look like, two complete themes, and every '
          'value measured out of the live stylesheet rather than claimed. '
          'Everything here is a live component, not a picture of one.',
        ),
        findsOneWidget,
      );

      // The one header in the tree that passes no `contents`: nothing on the
      // page wears `.type-chip`.
      expect(
        tester
            .widgetList<Text>(find.byType(Text))
            .where((Text t) => t.style?.fontSize == DsType.chip.size),
        isEmpty,
      );
    });
  });

  group('#foundations', () {
    testWidgets('the six cards are the registry, in its order',
        (WidgetTester tester) async {
      await _pumpOverview(tester);

      expect(find.text('Foundations'), findsOneWidget);
      expect(
        find.text(
          'The decisions everything else inherits. Change something here and '
          'it propagates through every base component and the entire agent '
          'console.',
        ),
        findsOneWidget,
      );

      const List<String> titles = <String>[
        'Colors',
        'Typography',
        'Spacing & Layout',
        'Shadows',
        'Motion',
        'Icons',
      ];
      expect(
        dsGroupById('foundations')
            .categories
            .map((DsCategory c) => c.title)
            .toList(),
        titles,
      );

      for (final String title in titles) {
        expect(find.text(title), findsOneWidget, reason: '$title card');
      }

      // Blurbs and chips come from the registry, never retyped here.
      final DsCategory colors = dsGroupById('foundations').categories.first;
      expect(find.text(colors.blurb), findsOneWidget);
      expect(find.text('70 / 20 / 10 balance'), findsOneWidget);
    });

    testWidgets('xl:grid-cols-3 — the first three cards share a row',
        (WidgetTester tester) async {
      await _pumpOverview(tester);

      final double row = tester.getTopLeft(find.text('Colors')).dy;
      expect(tester.getTopLeft(find.text('Typography')).dy, row);
      expect(tester.getTopLeft(find.text('Spacing & Layout')).dy, row);
      // …and the fourth wraps below them.
      expect(tester.getTopLeft(find.text('Shadows')).dy, greaterThan(row));
    });

    testWidgets('a card navigates to its category', (WidgetTester tester) async {
      final AppRouter router = AppRouter();
      await _pumpOverview(tester, router: router);

      await tester.tap(find.text('Colors'));
      await tester.pumpAndSettle();
      expect(router.route, '$dsRoot/colors');
    });
  });

  group('#components', () {
    testWidgets('three families, counted rather than typed',
        (WidgetTester tester) async {
      await _pumpOverview(tester);

      expect(find.text('Components'), findsOneWidget);
      expect(
        find.text(
          'Three families, deliberately separated. Base is the generic '
          'chassis any product could use. Agent is a complete AI console, '
          'written from scratch and pointed at a transport you supply. Site '
          'pages own no visual values of their own — only the composition '
          'rules that assemble the other two into a page.',
        ),
        findsOneWidget,
      );

      expect(find.text('14 SETS'), findsOneWidget);
      expect(_styleOf(tester, '14 SETS').color, DsThemeData.dark.actionInk);
      expect(find.text('6 SETS'), findsNWidgets(2));

      for (final String title in <String>[
        'Base Components',
        'Agent',
        'Site Pages',
      ]) {
        expect(find.text(title), findsOneWidget);
        expect(_styleOf(tester, title).fontSize, DsType.h3.size);
      }

      // The label is `{categories.length} sets`, so the count and the chip
      // list cannot disagree.
      expect(dsGroupById('base').categories.length, 14);
      expect(find.text('Sidebar'), findsOneWidget);
      expect(find.text(dsGroupById('agent').blurb), findsOneWidget);
    });

    testWidgets('a group card navigates to its index',
        (WidgetTester tester) async {
      final AppRouter router = AppRouter();
      await _pumpOverview(tester, router: router);

      await tester.tap(find.text('Agent'));
      await tester.pumpAndSettle();
      expect(router.route, '$dsRoot/components/agent');
    });
  });

  group('#rules', () {
    testWidgets('six zero-padded rows in action ink',
        (WidgetTester tester) async {
      await _pumpOverview(tester);

      expect(find.text('The rules that outrank taste'), findsOneWidget);
      expect(
        find.text(
          'Six non-negotiables. If a screen breaks one of these, the screen '
          'is wrong — not the rule.',
        ),
        findsOneWidget,
      );

      for (final String n in <String>['01', '02', '03', '04', '05', '06']) {
        expect(find.text(n), findsOneWidget);
        final TextStyle serial = _styleOf(tester, n);
        expect(serial.fontSize, DsType.numSm.size);
        expect(serial.color, DsThemeData.dark.actionInk);
      }
    });

    testWidgets('rule 4 names Space Grotesk, drift and all',
        (WidgetTester tester) async {
      await _pumpOverview(tester);

      expect(
        find.textContaining('Two faces only.', findRichText: true),
        findsOneWidget,
      );

      final RichText paragraph = _richContaining(tester, 'Two faces only.');
      expect(
        paragraph.text.toPlainText(),
        'Two faces only. Space Grotesk for words. Geist Mono, tabular, for '
        'numerical values, serials and code through the named typography '
        'foundations.',
      );

      // The lead sentence is the semibold, foreground half of a muted
      // `.type-small` paragraph.
      final List<TextSpan> spans = <TextSpan>[];
      paragraph.text.visitChildren((InlineSpan span) {
        if (span is TextSpan) spans.add(span);
        return true;
      });
      final TextSpan lead = spans.firstWhere(
        (TextSpan span) => span.text == 'Two faces only.',
      );
      expect(lead.style!.color, DsThemeData.dark.foreground);
      expect(lead.style!.fontWeight, DsType.section.weight);
      expect(lead.style!.fontSize, DsType.small.size);

      final TextStyle paragraphStyle = (paragraph.text as TextSpan).style!;
      expect(paragraphStyle.color, DsThemeData.dark.mutedForeground);
      expect(paragraphStyle.fontSize, DsType.small.size);
    });
  });

  group('closing note', () {
    testWidgets('value tone, muted title, outside every section',
        (WidgetTester tester) async {
      await _pumpOverview(tester);

      // `.type-label` uppercases at paint, and stays muted in every tone.
      expect(find.text('SCOPE OF THIS PHASE'), findsOneWidget);
      expect(
        _styleOf(tester, 'SCOPE OF THIS PHASE').color,
        DsThemeData.dark.mutedForeground,
      );
      expect(
        find.text(
          'This is the design system and component library. The ten product '
          'screens are built on top of it and are tracked separately — '
          'nothing in here implements a real wallet, payment, blockchain or '
          'shipping integration. All figures, packs, cards and users are '
          'placeholder data.',
        ),
        findsOneWidget,
      );

      // The last child of the page itself — not wrapped in a `DsSection`, so
      // it carries no `mb-20`.
      final Column page = tester.widget<Column>(
        find
            .descendant(
              of: find.byType(OverviewPage),
              matching: find.byType(Column),
            )
            .first,
      );
      expect(page.children.last, isA<DsNote>());
      expect(
        find.descendant(
          of: find.byType(DsSection),
          matching: find.byType(DsNote),
        ),
        findsNothing,
      );
    });
  });
}
