/// The colors page, held to `colors-map.md` §2–10.
///
/// What is worth testing on a page whose every number is computed elsewhere is
/// the *assembly*: that all eighteen tokens are swatched, that the four pure
/// fills carry no badge, that the ramp orders are the ones the reference ships
/// (they differ between action and value), that the copy is verbatim down to
/// the doubled word in the state note, and that the numbers really do come from
/// the live theme — flip it, and the badges follow.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/colors.dart';
import 'package:example/shell.dart';
import 'package:example/token_swatch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Desktop, above `xl` — every responsive branch on the page takes its wide
/// arm (swatch rows go 88/208/flex, the `#beyond` panels sit two-up), and the
/// column is tall enough that most of the page is laid out on screen.
const Size _viewport = Size(1440, 4000);

/// The `<code>` chip [text], read back from however many slices the line
/// breaker left it in.
///
/// A chip is one [WidgetSpan] per break opportunity CSS gives it, so a chip
/// with a hyphen renders as two [DsCode]s and `find.text` no longer sees it
/// whole. Joining the slices that name the same chip returns the chip itself
/// exactly when it is on screen once and nothing was lost in the slicing.
String _chip(WidgetTester tester, String text) => tester
    .widgetList<DsCode>(find.byType(DsCode))
    .where((DsCode code) => code.chip == text)
    .map((DsCode code) => code.text)
    .join();

Widget _harness(DsThemeController controller, AppRouter router) => DsTheme(
      controller: controller,
      child: AppRouterScope(
        router: router,
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          // The shell's own scroller, standing in for it: a page this long
          // needs somewhere to overflow to. `SingleChildScrollView` builds and
          // lays out its whole child, so every row below the fold is in the
          // tree — finders reach it, and `ensureVisible` brings it on screen
          // when a test needs to tap.
          home: SingleChildScrollView(child: ColorsPage()),
        ),
      ),
    );

Future<({DsThemeController theme, AppRouter router})> _pumpPage(
  WidgetTester tester, {
  DsThemeMode mode = DsThemeMode.dark,
}) async {
  tester.view.physicalSize = _viewport;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final DsThemeController theme = DsThemeController(mode: mode);
  final AppRouter router = AppRouter(route: '$dsRoot/colors');
  await tester.pumpWidget(_harness(theme, router));
  return (theme: theme, router: router);
}

/// Where a token's row sits on the page — its own reading order.
///
/// By widget, not by text: a token name also appears in the notes as a [DsCode]
/// chip, and `--color-action-bright` is on the page twice for that reason.
double _rowDy(WidgetTester tester, String token) => tester
    .getTopLeft(
      find.byWidgetPredicate(
        (Widget widget) => widget is DsTokenSwatch && widget.token == token,
      ),
    )
    .dy;

void main() {
  group('the swatch inventory', () {
    testWidgets('eighteen tokens, fourteen of them measured',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      // 6 monochrome + 4 action + 4 value + 4 state.
      expect(find.byType(DsTokenSwatch), findsNWidgets(18));
      // The four pure fills carry no ratio: nothing is ever written in them.
      expect(find.byType(DsContrastBadge), findsNWidgets(14));

      for (final DsTokenSwatch row
          in tester.widgetList<DsTokenSwatch>(find.byType(DsTokenSwatch))) {
        expect(
          DsTokenRegistry.has(row.token),
          isTrue,
          reason: '${row.token} is swatched but not registered',
        );
      }

      expect(
        tester
            .widgetList<DsTokenSwatch>(find.byType(DsTokenSwatch))
            .where((DsTokenSwatch row) => !row.measure)
            .map((DsTokenSwatch row) => row.token),
        <String>['--background', '--card', '--muted', '--accent'],
      );
    });

    testWidgets('the value ramp reads ink, mid, bright, dark',
        (WidgetTester tester) async {
      // Deliberately not the action ramp's order (ink, bright, mid, dark) —
      // colors-map §7 flags the difference as shipped, not as a slip.
      await _pumpPage(tester);

      expect(_rowDy(tester, '--color-value-ink'),
          lessThan(_rowDy(tester, '--color-value')));
      expect(_rowDy(tester, '--color-value'),
          lessThan(_rowDy(tester, '--color-value-bright')));
      expect(_rowDy(tester, '--color-value-bright'),
          lessThan(_rowDy(tester, '--color-value-dark')));

      expect(_rowDy(tester, '--color-action-ink'),
          lessThan(_rowDy(tester, '--color-action-bright')));
      expect(_rowDy(tester, '--color-action-bright'),
          lessThan(_rowDy(tester, '--color-action')));
      expect(_rowDy(tester, '--color-action'),
          lessThan(_rowDy(tester, '--color-action-dark')));
    });

    testWidgets('the state row queries the semantic destructive token',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      expect(find.text('--destructive'), findsOneWidget);
      // …and prints what the browser reads back. `globals.css` authors
      // `hsl(0 72.2% 50.6%)`; Tailwind's minifier serves `#dc2626`, and the
      // readout is the served text, not the authored one.
      expect(find.text('#dc2626'), findsOneWidget);
    });
  });

  group('the measurement is live', () {
    testWidgets('dark muted-foreground prints its value and its ratio',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      expect(find.text('Muted foreground'), findsOneWidget);
      expect(find.text('#d4d4d8'), findsOneWidget);
      // `.type-micro` uppercases at paint, so this is the rendered string.
      expect(
        find.textContaining('CONTRAST 13.5:1 · AAA', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('flipping the theme re-measures the whole page',
        (WidgetTester tester) async {
      final ({DsThemeController theme, AppRouter router}) scope =
          await _pumpPage(tester);

      // Dark: the deep end of the action ramp fails on the page…
      expect(
        find.textContaining('CONTRAST 1.9:1 · FAILS', findRichText: true),
        findsOneWidget,
      );

      scope.theme.setMode(DsThemeMode.light);
      await tester.pump();

      // …and on light it is exactly reversed: 1.9 now belongs to the bright
      // end, and muted foreground drops from 13.5 AAA to 6.0 AA.
      expect(
        find.textContaining('CONTRAST 13.5:1 · AAA', findRichText: true),
        findsNothing,
      );
      expect(
        find.textContaining('CONTRAST 6.0:1 · AA', findRichText: true),
        findsOneWidget,
      );
      expect(find.text('#62626a'), findsOneWidget);
      // The ink token is the one whose printed text flips with the block, and
      // on light it lands on the same hex the deep end already prints.
      expect(find.text('#143694'), findsNWidgets(2));
    });
  });

  group('the copy', () {
    testWidgets('header, blurb and the page\'s own five chips',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      expect(find.text('FOUNDATIONS'), findsOneWidget);
      expect(find.text('Colors'), findsOneWidget);
      expect(
        find.textContaining('Zinc for everything structural, blue for action'),
        findsOneWidget,
      );
      for (final String chip in <String>[
        'Monochrome',
        'Action ramp',
        'Value ramp',
        'What is not a token',
      ]) {
        expect(find.text(chip), findsOneWidget, reason: 'chip "$chip"');
      }
      // The fifth chip is the one string the page renders twice: the chip
      // itself, and the `#state` heading further down.
      expect(find.text('State'), findsNWidgets(2));
      // The nav registry's list is NOT what this page shows (drift §12.1).
      expect(find.text('70 / 20 / 10 balance'), findsNothing);
    });

    testWidgets('five sections, each under its own heading',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      for (final String heading in <String>[
        'Monochrome — zinc',
        'Action — the thing that acts',
        'Value — the thing that is worth something',
        'What is deliberately not a colour token',
      ]) {
        expect(find.text(heading), findsOneWidget, reason: heading);
      }
      // `#state` shares its heading with the header chip above it.
      expect(find.text('State'), findsNWidgets(2));
    });

    testWidgets('the lead note names its two files as code chips',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      // `.type-label` uppercases the title, and renders it muted in every tone.
      expect(find.text('MEASURED, NOT ASSERTED'), findsOneWidget);
      expect(find.text('app/globals.css'), findsOneWidget);
      expect(find.text('RULES.md'), findsOneWidget);
      expect(
        find.textContaining(
          'read from the live stylesheet',
          findRichText: true,
        ),
        findsOneWidget,
      );
    });

    testWidgets('four notes, in the tones the reference gives them',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final List<DsNote> notes =
          tester.widgetList<DsNote>(find.byType(DsNote)).toList();
      expect(notes.map((DsNote n) => n.tone), <DsNoteTone>[
        DsNoteTone.action, // Measured, not asserted
        DsNoteTone.value, // The one step that is not a mirror
        DsNoteTone.action, // One text-safe shade per theme
        DsNoteTone.value, // Why info is cyan and success is emerald
      ]);
      // `#value` is the section with no note at all.
      expect(find.text('THE ONE STEP THAT IS NOT A MIRROR'), findsOneWidget);
      expect(
        find.text(
          'ONE TEXT-SAFE SHADE PER THEME — AND IT IS NOT THE SAME SHADE',
        ),
        findsOneWidget,
      );
      expect(find.text('WHY INFO IS CYAN AND SUCCESS IS EMERALD'),
          findsOneWidget);
    });

    testWidgets('the state note ships its doubled word',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      // JSX collapses the line break between the two, and "in the same same
      // row" is what a reader sees. Verbatim means verbatim.
      expect(
        find.textContaining('in the same same row', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('the muted-foreground note keeps the copy the badge contradicts',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      // Drift §12.4: the note says "about 13:1"; the badge above it computes
      // 13.5. Both are on the page, and both stay.
      expect(
        find.textContaining('which measures about 13:1', findRichText: true),
        findsOneWidget,
      );
    });
  });

  group('#beyond', () {
    testWidgets('two panels, and the em really is italic',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      expect(find.text('TEXTURE'), findsOneWidget);
      expect(find.text('MEANING'), findsOneWidget);
      // The texture utilities are named in copy only — nothing on this page
      // renders a foil, bloom or sheen specimen.
      expect(_chip(tester, 'foil-value'), 'foil-value');
      expect(_chip(tester, 'bloom-cosmic'), 'bloom-cosmic');
      expect(_chip(tester, 'sheen-action'), 'sheen-action');
      expect(
        find.textContaining(
          'Nothing may be communicated by colour alone.',
        ),
        findsOneWidget,
      );

      final Text paragraph = tester.widgetList<Text>(find.byType(Text)).firstWhere(
            (Text text) =>
                text.textSpan?.toPlainText().startsWith(
                      'A surface that has to feel rare',
                    ) ??
                false,
          );
      final TextSpan em = (paragraph.textSpan! as TextSpan)
          .children!
          .whereType<TextSpan>()
          .firstWhere((TextSpan span) => span.text == 'texture');
      expect(em.style!.fontStyle, FontStyle.italic);
    });
  });

  group('the foot nav', () {
    testWidgets('colors has no previous, and its next is Typography',
        (WidgetTester tester) async {
      final ({DsThemeController theme, AppRouter router}) scope =
          await _pumpPage(tester);

      expect(find.text('PREVIOUS'), findsNothing);
      expect(find.text('NEXT'), findsOneWidget);
      expect(find.text('Typography'), findsOneWidget);

      // The card is far below the fold; scroll to it before tapping.
      await tester.ensureVisible(find.text('Typography'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Typography'));
      await tester.pumpAndSettle();

      expect(scope.router.route, '$dsRoot/typography');
    });
  });
}
