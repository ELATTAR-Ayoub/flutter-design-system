/// The colors page's claim is that nothing on it is typed by hand. These are
/// the tests that hold the arithmetic to the numbers the reference renders.
///
/// Expected values come from `docs/superpowers/research/colors-map.md` §5–8,
/// which computed them with the page's own math. The map allows ±0.1 on the
/// last decimal (the browser rasterises through 8-bit `rgb()` before measuring);
/// anything wider than that is a real disagreement and fails here.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/token_swatch.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// `hsl(0 0% 100%)`.
final Color _white = dsHsl(0, 0, 100);

/// One row of the map's expected-badge tables.
typedef _Expected = ({String token, double ratio, String verdict});

/// colors-map §5–8, dark theme.
const List<_Expected> _dark = <_Expected>[
  (token: '--foreground', ratio: 19.0, verdict: 'AAA'),
  (token: '--muted-foreground', ratio: 13.5, verdict: 'AAA'),
  (token: '--color-action-ink', ratio: 10.7, verdict: 'AAA'),
  (token: '--color-action-bright', ratio: 10.7, verdict: 'AAA'),
  (token: '--color-action', ratio: 4.3, verdict: 'AA large / UI only'),
  (token: '--color-action-dark', ratio: 1.9, verdict: 'Fails'),
  (token: '--color-value-ink', ratio: 17.0, verdict: 'AAA'),
  (token: '--color-value', ratio: 13.2, verdict: 'AAA'),
  (token: '--color-value-bright', ratio: 17.0, verdict: 'AAA'),
  (token: '--color-value-dark', ratio: 3.98, verdict: 'AA large / UI only'),
  (token: '--color-success', ratio: 7.8, verdict: 'AAA'),
  (token: '--color-warning', ratio: 11.9, verdict: 'AAA'),
  (token: '--color-info', ratio: 11.0, verdict: 'AAA'),
  (token: '--destructive', ratio: 4.1, verdict: 'AA large / UI only'),
];

/// colors-map §5–8, light theme — where the ramps trade places.
const List<_Expected> _light = <_Expected>[
  (token: '--foreground', ratio: 19.9, verdict: 'AAA'),
  (token: '--muted-foreground', ratio: 6.0, verdict: 'AA'),
  (token: '--color-action-ink', ratio: 10.6, verdict: 'AAA'),
  (token: '--color-action-bright', ratio: 1.9, verdict: 'Fails'),
  (token: '--color-action', ratio: 4.6, verdict: 'AA'),
  (token: '--color-action-dark', ratio: 10.6, verdict: 'AAA'),
  (token: '--color-value-ink', ratio: 5.0, verdict: 'AA'),
  (token: '--color-value', ratio: 1.5, verdict: 'Fails'),
  (token: '--color-value-bright', ratio: 1.2, verdict: 'Fails'),
  (token: '--color-value-dark', ratio: 5.0, verdict: 'AA'),
  (token: '--color-success', ratio: 2.5, verdict: 'Fails'),
  (token: '--color-warning', ratio: 1.7, verdict: 'Fails'),
  (token: '--color-info', ratio: 1.8, verdict: 'Fails'),
  (token: '--destructive', ratio: 4.8, verdict: 'AA'),
];

Widget _scope(Widget child, DsThemeMode mode) => DsTheme(
      controller: DsThemeController(mode: mode),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(1440, 900)),
          child: Center(child: child),
        ),
      ),
    );

void main() {
  group('dsContrastRatio', () {
    test('the two headline numbers on zinc 950 and on white', () {
      // The plan calls this one "white on dark bg ≈ 19.0", and the token it
      // means is `--foreground`, which on dark is `hsl(0 0% 98%)` — near-white,
      // not white. That is the 19.0 the page prints.
      expect(
        dsContrastRatio(DsThemeData.dark.foreground, dsHsl(240, 10, 3.9)),
        closeTo(19.0, 0.15),
      );
      // Actual white against the same fill is the *light* theme's pair read
      // backwards, and measures 19.9 — colors-map §5's other foreground row.
      expect(
        dsContrastRatio(_white, dsHsl(240, 10, 3.9)),
        closeTo(19.9, 0.15),
      );
    });

    test('dark muted-foreground clears AAA on the page', () {
      expect(
        dsContrastRatio(
          DsThemeData.dark.mutedForeground,
          DsThemeData.dark.background,
        ),
        closeTo(13.5, 0.15),
      );
    });

    test('the light theme reverses the two ramp ends', () {
      expect(
        dsContrastRatio(DsPalette.valueDark, DsThemeData.light.background),
        closeTo(5.0, 0.15),
      );
      expect(
        dsContrastRatio(DsPalette.action, DsThemeData.light.background),
        closeTo(4.6, 0.15),
      );
      // The end that fails outright on white.
      expect(
        dsContrastRatio(DsPalette.actionBright, DsThemeData.light.background),
        closeTo(1.9, 0.15),
      );
    });

    test('order does not matter — the brighter side takes the numerator', () {
      final double forwards = dsContrastRatio(
        DsThemeData.dark.foreground,
        DsThemeData.dark.background,
      );
      final double backwards = dsContrastRatio(
        DsThemeData.dark.background,
        DsThemeData.dark.foreground,
      );
      expect(forwards, closeTo(backwards, 0.0001));
    });

    test('a translucent foreground is composited before it is measured', () {
      // A 12% action wash on the page reads as a near-page colour, not as
      // action's own ratio.
      final Color wash = DsPalette.action.withValues(alpha: 0.12);
      expect(
        dsContrastRatio(wash, DsThemeData.dark.background),
        lessThan(dsContrastRatio(DsPalette.action, DsThemeData.dark.background)),
      );
      expect(dsContrastRatio(wash, DsThemeData.dark.background), lessThan(1.5));
    });
  });

  group('dsContrastVerdict', () {
    test('grades on the raw ratio, at the standard\'s own thresholds', () {
      expect(dsContrastVerdict(21), 'AAA');
      expect(dsContrastVerdict(7), 'AAA');
      expect(dsContrastVerdict(6.99), 'AA');
      expect(dsContrastVerdict(4.5), 'AA');
      expect(dsContrastVerdict(4.49), 'AA large / UI only');
      expect(dsContrastVerdict(3), 'AA large / UI only');
      expect(dsContrastVerdict(2.99), 'Fails');
      expect(dsContrastVerdict(1), 'Fails');
    });

    test('rounding for the reader does not round for the grader', () {
      // `--color-value-dark` on dark: 3.98 prints as 4.0 and is still graded
      // below AA.
      const double raw = 3.98;
      expect(dsContrastRatioLabel(raw), '4.0');
      expect(dsContrastVerdict(raw), 'AA large / UI only');
      expect(dsContrastBadgeText(raw), 'Contrast 4.0:1 · AA large / UI only');
    });
  });

  group('the badge strings the page prints', () {
    ({double ratio, String text}) badge(String token, DsThemeKind kind) {
      final DsThemeData theme =
          kind == DsThemeKind.dark ? DsThemeData.dark : DsThemeData.light;
      final double ratio = DsTokenRegistry.contrastRatio(token, theme);
      return (ratio: ratio, text: dsContrastBadgeText(ratio));
    }

    test('dark muted-foreground', () {
      expect(badge('--muted-foreground', DsThemeKind.dark).text,
          'Contrast 13.5:1 · AAA');
    });

    test('dark value-dark — the 3.98 that prints 4.0', () {
      final ({double ratio, String text}) measured =
          badge('--color-value-dark', DsThemeKind.dark);
      expect(measured.ratio, lessThan(4.0));
      expect(measured.ratio, closeTo(3.98, 0.1));
      expect(measured.text, 'Contrast 4.0:1 · AA large / UI only');
    });

    test('light action-bright', () {
      expect(badge('--color-action-bright', DsThemeKind.light).text,
          'Contrast 1.9:1 · Fails');
    });
  });

  group('every swatched token matches colors-map', () {
    for (final (DsThemeKind kind, List<_Expected> table) in <(
      DsThemeKind,
      List<_Expected>
    )>[
      (DsThemeKind.dark, _dark),
      (DsThemeKind.light, _light),
    ]) {
      final DsThemeData theme =
          kind == DsThemeKind.dark ? DsThemeData.dark : DsThemeData.light;
      for (final _Expected row in table) {
        test('${kind.name} ${row.token}', () {
          final double ratio = DsTokenRegistry.contrastRatio(row.token, theme);
          expect(
            ratio,
            closeTo(row.ratio, 0.1),
            reason: '${row.token} on ${kind.name}: colors-map says '
                '${row.ratio}, we measure ${ratio.toStringAsFixed(3)}',
          );
          expect(dsContrastVerdict(ratio), row.verdict);
        });
      }
    }
  });

  group('DsTokenRegistry', () {
    test('prints the raw CSS text, per theme', () {
      expect(DsTokenRegistry.printedValue('--background', DsThemeKind.dark),
          'hsl(240 10% 3.9%)');
      expect(DsTokenRegistry.printedValue('--background', DsThemeKind.light),
          'hsl(0 0% 100%)');
      expect(DsTokenRegistry.printedValue('--muted-foreground', DsThemeKind.dark),
          'hsl(240 4.9% 83.9%)');
      expect(
          DsTokenRegistry.printedValue('--muted-foreground', DsThemeKind.light),
          'hsl(240 4% 40%)');
      expect(DsTokenRegistry.printedValue('--color-value', DsThemeKind.dark),
          '#a3e635');
      // A ramp token is declared once, so it prints the same text in both.
      expect(DsTokenRegistry.printedValue('--color-value', DsThemeKind.light),
          '#a3e635');
      expect(DsTokenRegistry.printedValue('--destructive', DsThemeKind.dark),
          'hsl(0 72.2% 50.6%)');
      // The ink tokens are the ones that flip.
      expect(
          DsTokenRegistry.printedValue('--color-action-ink', DsThemeKind.dark),
          'hsl(213 94% 78%)');
      expect(
          DsTokenRegistry.printedValue('--color-action-ink', DsThemeKind.light),
          'hsl(224 76% 33%)');
      expect(DsTokenRegistry.printedValue('--color-value-ink', DsThemeKind.dark),
          '#d9f99d');
      expect(
          DsTokenRegistry.printedValue('--color-value-ink', DsThemeKind.light),
          '#4d7c0f');
    });

    test('resolves through the live theme, not through the printed text', () {
      expect(DsTokenRegistry.resolve('--background', DsThemeData.dark),
          DsThemeData.dark.background);
      expect(DsTokenRegistry.resolve('--color-action-ink', DsThemeData.light),
          DsPalette.actionDark);
      expect(DsTokenRegistry.resolve('--color-value', DsThemeData.light),
          DsPalette.value);
    });

    test('an unregistered name is an error, not a silent zero', () {
      expect(DsTokenRegistry.has('--not-a-token'), isFalse);
      expect(() => DsTokenRegistry.resolve('--not-a-token', DsThemeData.dark),
          throwsArgumentError);
    });
  });

  group('the widgets', () {
    testWidgets('a swatch row prints name, value, token and badge',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _scope(
          const DsTokenSwatchList(
            rows: <Widget>[
              DsTokenSwatch(
                token: '--muted-foreground',
                name: 'Muted foreground',
                use: 'Secondary text, metadata, helper copy.',
              ),
            ],
          ),
          DsThemeMode.dark,
        ),
      );

      expect(find.text('Muted foreground'), findsOneWidget);
      expect(find.text('hsl(240 4.9% 83.9%)'), findsOneWidget);
      expect(find.text('--muted-foreground'), findsOneWidget);
      expect(find.text('Secondary text, metadata, helper copy.'), findsOneWidget);
      // `.type-micro` uppercases the whole badge.
      expect(
        find.textContaining('CONTRAST 13.5:1 · AAA', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('measure: false drops the badge — the pure fills',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _scope(
          const DsTokenSwatch(
            token: '--card',
            name: 'Card',
            use: 'Containers.',
            measure: false,
          ),
          DsThemeMode.dark,
        ),
      );

      expect(find.text('Card'), findsOneWidget);
      expect(find.byType(DsContrastBadge), findsNothing);
    });

    testWidgets('the badge re-measures when the theme flips',
        (WidgetTester tester) async {
      final DsThemeController controller =
          DsThemeController(mode: DsThemeMode.dark);
      await tester.pumpWidget(
        DsTheme(
          controller: controller,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: DsContrastBadge('--color-action-bright')),
          ),
        ),
      );

      expect(
        find.textContaining('CONTRAST 10.7:1 · AAA', findRichText: true),
        findsOneWidget,
      );

      controller.setMode(DsThemeMode.light);
      await tester.pump();

      expect(
        find.textContaining('CONTRAST 1.9:1 · FAILS', findRichText: true),
        findsOneWidget,
      );
    });
  });
}
