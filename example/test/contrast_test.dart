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

/// One row of the map's printed-value tables — all eighteen swatches,
/// including the four pure fills the page renders with `measure: false`.
typedef _Printed = ({String token, String dark, String light});

/// colors-map §5–8, the "value shown" columns. Every one of these is the raw
/// authored CSS text after `var()` substitution — never a normalised `rgb()`.
const List<_Printed> _printed = <_Printed>[
  // §5 `#monochrome` — the first four carry no badge; they are fills.
  (token: '--background', dark: 'hsl(240 10% 3.9%)', light: 'hsl(0 0% 100%)'),
  (token: '--card', dark: 'hsl(240 5.9% 10%)', light: 'hsl(0 0% 100%)'),
  (token: '--muted', dark: 'hsl(240 3.7% 15.9%)', light: 'hsl(240 4.8% 95.9%)'),
  (token: '--accent', dark: 'hsl(240 5.3% 26.1%)', light: 'hsl(240 4.8% 95.9%)'),
  (token: '--foreground', dark: 'hsl(0 0% 98%)', light: 'hsl(240 10% 3.9%)'),
  (
    token: '--muted-foreground',
    dark: 'hsl(240 4.9% 83.9%)',
    light: 'hsl(240 4% 40%)'
  ),
  // §6 `#action` — only the ink token flips; the three ramp ends are static.
  (
    token: '--color-action-ink',
    dark: 'hsl(213 94% 78%)',
    light: 'hsl(224 76% 33%)'
  ),
  (
    token: '--color-action-bright',
    dark: 'hsl(213 94% 78%)',
    light: 'hsl(213 94% 78%)'
  ),
  (token: '--color-action', dark: 'hsl(217 91% 53%)', light: 'hsl(217 91% 53%)'),
  (
    token: '--color-action-dark',
    dark: 'hsl(224 76% 33%)',
    light: 'hsl(224 76% 33%)'
  ),
  // §7 `#value` — page order is ink, mid, bright, dark.
  (token: '--color-value-ink', dark: '#d9f99d', light: '#4d7c0f'),
  (token: '--color-value', dark: '#a3e635', light: '#a3e635'),
  (token: '--color-value-bright', dark: '#d9f99d', light: '#d9f99d'),
  (token: '--color-value-dark', dark: '#4d7c0f', light: '#4d7c0f'),
  // §8 `#state`.
  (token: '--color-success', dark: '#10b981', light: '#10b981'),
  (token: '--color-warning', dark: '#fbbf24', light: '#fbbf24'),
  (token: '--color-info', dark: '#22d3ee', light: '#22d3ee'),
  (
    token: '--destructive',
    dark: 'hsl(0 72.2% 50.6%)',
    light: 'hsl(0 72.2% 50.6%)'
  ),
];

DsThemeData _theme(DsThemeKind kind) =>
    kind == DsThemeKind.dark ? DsThemeData.dark : DsThemeData.light;

final RegExp _hexText = RegExp(r'^#([0-9a-f]{6})$');
final RegExp _hslText = RegExp(r'^hsl\(([\d.]+) ([\d.]+)% ([\d.]+)%\)$');

/// Turns a printed value back into a [Color] — **for the tests only.**
///
/// This deliberately does not exist in `token_swatch.dart`. The engine's two
/// halves have to stay independent: if resolution ever went through the printed
/// string, the page could no longer catch itself printing the wrong one. Here
/// it is exactly the tool for proving the halves agree.
Color _parseCss(String text) {
  final RegExpMatch? hex = _hexText.firstMatch(text);
  if (hex != null) return Color(int.parse('FF${hex[1]}', radix: 16));

  final RegExpMatch? hsl = _hslText.firstMatch(text);
  expect(hsl, isNotNull, reason: 'unparseable printed value: $text');
  return dsHsl(
    double.parse(hsl![1]!),
    double.parse(hsl[2]!),
    double.parse(hsl[3]!),
  );
}

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
    test('the page swatches eighteen rows, and all of them are registered', () {
      expect(_printed, hasLength(18));
      for (final _Printed row in _printed) {
        expect(
          DsTokenRegistry.has(row.token),
          isTrue,
          reason: '${row.token} is swatched on the page but not registered',
        );
      }
      // Fourteen of the eighteen carry a badge; the four pure fills do not.
      expect(_dark, hasLength(14));
      expect(_light, hasLength(14));
      final Set<String> measured =
          _dark.map((_Expected e) => e.token).toSet();
      expect(
        _printed
            .map((_Printed r) => r.token)
            .where((String t) => !measured.contains(t))
            .toList(),
        <String>['--background', '--card', '--muted', '--accent'],
      );
      expect(_light.map((_Expected e) => e.token).toSet(), measured);
    });

    for (final _Printed row in _printed) {
      test('${row.token} prints the map\'s value in both themes', () {
        expect(
          DsTokenRegistry.printedValue(row.token, DsThemeKind.dark),
          row.dark,
        );
        expect(
          DsTokenRegistry.printedValue(row.token, DsThemeKind.light),
          row.light,
        );
      });
    }

    test('colors-map\'s one arithmetic slip: dark --foreground', () {
      // The map's §5 table badges this row `Contrast 19.0:1 · AAA`. Zinc 50 is
      // rgb(250,250,250) and zinc 950 is rgb(10,10,10); the page's own formula
      // on those bytes gives 19.0611, which `toFixed(1)` renders as **19.1**.
      // The raw numbers are 0.06 apart — inside the map's stated ±0.1 — so the
      // engine stands and the transcript is what needs the correction. Pinned
      // here so the disagreement is a recorded fact rather than a surprise.
      final double raw =
          DsTokenRegistry.contrastRatio('--foreground', DsThemeData.dark);
      expect(raw, closeTo(19.0611, 0.0005));
      expect(raw, closeTo(19.0, 0.1)); // still inside the map's allowance
      expect(dsContrastBadgeText(raw), 'Contrast 19.1:1 · AAA');
    });

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

    test('what a token paints is what it prints — every token, both themes',
        () {
      // The strongest guarantee this file can make: the swatch colour and the
      // readout beside it are the same colour, arrived at by two independent
      // routes (a `DsThemeData` field, and a CSS string parsed here).
      for (final String token in DsTokenRegistry.names) {
        for (final DsThemeKind kind in DsThemeKind.values) {
          expect(
            DsTokenRegistry.resolve(token, _theme(kind)),
            _parseCss(DsTokenRegistry.printedValue(token, kind)),
            reason: '$token on ${kind.name}: the painted colour and the printed '
                'value disagree — one of the two halves is wrong',
          );
        }
      }
    });

    test('an unregistered name is an error, not a silent zero', () {
      expect(DsTokenRegistry.has('--not-a-token'), isFalse);
      expect(() => DsTokenRegistry.resolve('--not-a-token', DsThemeData.dark),
          throwsArgumentError);
      expect(
        () => DsTokenRegistry.printedValue('--not-a-token', DsThemeKind.dark),
        throwsArgumentError,
      );
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

    testWidgets('the badge renders uppercase, and only the verdict is tinted',
        (WidgetTester tester) async {
      // `.type-micro` carries `text-transform: uppercase`, and the property is
      // inherited, so the verdict span uppercases with the sentence around it.
      // The authored copy is `Contrast 13.5:1 · AAA`; the pixels are its caps.
      expect(DsType.micro.uppercase, isTrue);

      await tester.pumpWidget(
        _scope(const DsContrastBadge('--muted-foreground'), DsThemeMode.dark),
      );

      final double raw = DsTokenRegistry.contrastRatio(
        '--muted-foreground',
        DsThemeData.dark,
      );
      expect(dsContrastBadgeText(raw), 'Contrast 13.5:1 · AAA');

      final TextSpan root =
          tester.widget<Text>(find.byType(Text)).textSpan! as TextSpan;
      expect(root.toPlainText(), dsContrastBadgeText(raw).toUpperCase());

      final List<InlineSpan> spans = root.children!;
      expect(spans, hasLength(2));
      expect((spans[0] as TextSpan).text, 'CONTRAST 13.5:1 · ');
      expect((spans[1] as TextSpan).text, 'AAA');
      // The sentence is muted; only the verdict word takes value ink.
      expect(root.style!.color, DsThemeData.dark.mutedForeground);
      expect((spans[1] as TextSpan).style!.color, DsThemeData.dark.valueInk);
    });

    testWidgets('a failing verdict takes destructive ink instead',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _scope(const DsContrastBadge('--color-value'), DsThemeMode.light),
      );

      final TextSpan root =
          tester.widget<Text>(find.byType(Text)).textSpan! as TextSpan;
      expect(root.toPlainText(), 'CONTRAST 1.5:1 · FAILS');
      expect(
        (root.children![1] as TextSpan).style!.color,
        DsThemeData.light.destructiveInk,
      );
    });

    testWidgets('a badge can be measured against a surface other than the page',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _scope(
          const DsContrastBadge('--destructive', against: '--card'),
          DsThemeMode.dark,
        ),
      );

      final double onCard = dsContrastRatio(
        DsThemeData.dark.destructive,
        DsThemeData.dark.card,
      );
      // colors-map drift #5: red measures ~4.1 on the page and lower on a card.
      expect(onCard, lessThan(4.1));
      expect(
        tester.widget<Text>(find.byType(Text)).textSpan!.toPlainText(),
        dsContrastBadgeText(onCard).toUpperCase(),
      );
    });

    testWidgets('an unregistered token renders the em dash, never a crash',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _scope(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DsTokenValue('--not-a-token'),
              DsContrastBadge('--not-a-token'),
            ],
          ),
          DsThemeMode.dark,
        ),
      );

      expect(find.text('—'), findsNWidgets(2));
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
