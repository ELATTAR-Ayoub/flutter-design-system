/// The colors page's claim is that nothing on it is typed by hand. These are
/// the tests that hold the arithmetic to the numbers the reference renders.
///
/// Expected ratios come from `docs/superpowers/research/colors-map.md` §5–8,
/// which computed them with the page's own math. The map allows ±0.1 on the
/// last decimal (the browser rasterises through 8-bit `rgb()` before measuring);
/// anything wider than that is a real disagreement and fails here.
///
/// Expected **printed values** do not come from the map — §5–8's "value shown"
/// columns were wrong, and the map's dated correction says so. They were read
/// off the live dev server's DOM on 2026-08-14, both themes, all eighteen rows.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/token_swatch.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

/// `hsl(0 0% 100%)`.
final Color _white = hslColor(0, 0, 100);

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

/// The eighteen `TokenValue` lines as the reference actually renders them —
/// `textContent` read straight off `/design-system/colors` in Chrome, once per
/// theme, on 2026-08-14.
///
/// Every one is lowercase hex, because the browser is never served the `hsl()`
/// that `globals.css` authors: Tailwind v4 compiles the sheet through Lightning
/// CSS, whose colour minifier rewrites each declaration to its shortest form
/// before the dev server hands it over. `hsl(0 0% 100%)` arrives as `#fff` —
/// three digits, not six — and that shorthand is the only shape variation in
/// the whole table.
const List<_Printed> _printed = <_Printed>[
  // §5 `#monochrome` — the first four carry no badge; they are fills.
  (token: '--background', dark: '#09090b', light: '#fff'),
  (token: '--card', dark: '#18181b', light: '#fff'),
  (token: '--muted', dark: '#27272a', light: '#f4f4f5'),
  (token: '--accent', dark: '#3f3f46', light: '#f4f4f5'),
  (token: '--foreground', dark: '#fafafa', light: '#09090b'),
  (token: '--muted-foreground', dark: '#d4d4d8', light: '#62626a'),
  // §6 `#action` — only the ink token flips; the three ramp ends are static.
  (token: '--color-action-ink', dark: '#92c2fc', light: '#143694'),
  (token: '--color-action-bright', dark: '#92c2fc', light: '#92c2fc'),
  (token: '--color-action', dark: '#1a6ef4', light: '#1a6ef4'),
  (token: '--color-action-dark', dark: '#143694', light: '#143694'),
  // §7 `#value` — page order is ink, mid, bright, dark.
  (token: '--color-value-ink', dark: '#d9f99d', light: '#4d7c0f'),
  (token: '--color-value', dark: '#a3e635', light: '#a3e635'),
  (token: '--color-value-bright', dark: '#d9f99d', light: '#d9f99d'),
  (token: '--color-value-dark', dark: '#4d7c0f', light: '#4d7c0f'),
  // §8 `#state`.
  (token: '--color-success', dark: '#10b981', light: '#10b981'),
  (token: '--color-warning', dark: '#fbbf24', light: '#fbbf24'),
  (token: '--color-info', dark: '#22d3ee', light: '#22d3ee'),
  (token: '--destructive', dark: '#dc2626', light: '#dc2626'),
];

ThemeTokens _theme(ResolvedColorMode kind) =>
    kind == ResolvedColorMode.dark ? ThemeTokens.dark : ThemeTokens.light;

final RegExp _hexText = RegExp(r'^#([0-9a-f]{3}|[0-9a-f]{6})$');

/// Turns a printed value back into a [Color] — **for the tests only.**
///
/// The printed text is now derived from the painted colour, so this is no
/// longer a check that two hand-kept halves agree; it is a check that the
/// derivation is *lossless and correctly shaped*. A byte rounded the wrong way,
/// a channel out of order, or a three-digit collapse applied when the nibbles
/// do not actually match all land here as a colour that is not the one the
/// theme holds. The strict pattern is half the test: anything the reference's
/// minifier would not emit — an `hsl()`, an uppercase digit, a named colour —
/// fails to parse rather than sliding through.
Color _parseCss(String text) {
  final RegExpMatch? hex = _hexText.firstMatch(text);
  expect(hex, isNotNull, reason: 'unparseable printed value: $text');

  final String digits = hex![1]!;
  final String full = digits.length == 3
      ? digits.split('').map((String d) => '$d$d').join()
      : digits;
  return Color(int.parse('FF$full', radix: 16));
}

Widget _scope(Widget child, ColorMode mode) => ThemeScope(
  controller: ThemeController(mode: mode),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(size: Size(1440, 900)),
      child: Center(child: child),
    ),
  ),
);

void main() {
  group('elContrastRatio', () {
    test('the two headline numbers on zinc 950 and on white', () {
      // The plan calls this one "white on dark bg ≈ 19.0", and the token it
      // means is `--foreground`, which on dark is `hsl(0 0% 98%)` — near-white,
      // not white. That is the 19.0 the page prints.
      expect(
        elContrastRatio(ThemeTokens.dark.foreground, hslColor(240, 10, 3.9)),
        closeTo(19.0, 0.15),
      );
      // Actual white against the same fill is the *light* theme's pair read
      // backwards, and measures 19.9 — colors-map §5's other foreground row.
      expect(
        elContrastRatio(_white, hslColor(240, 10, 3.9)),
        closeTo(19.9, 0.15),
      );
    });

    test('dark muted-foreground clears AAA on the page', () {
      expect(
        elContrastRatio(
          ThemeTokens.dark.mutedForeground,
          ThemeTokens.dark.background,
        ),
        closeTo(13.5, 0.15),
      );
    });

    test('the light theme reverses the two ramp ends', () {
      expect(
        elContrastRatio(Palette.valueDark, ThemeTokens.light.background),
        closeTo(5.0, 0.15),
      );
      expect(
        elContrastRatio(Palette.action, ThemeTokens.light.background),
        closeTo(4.6, 0.15),
      );
      // The end that fails outright on white.
      expect(
        elContrastRatio(Palette.actionBright, ThemeTokens.light.background),
        closeTo(1.9, 0.15),
      );
    });

    test('order does not matter — the brighter side takes the numerator', () {
      final double forwards = elContrastRatio(
        ThemeTokens.dark.foreground,
        ThemeTokens.dark.background,
      );
      final double backwards = elContrastRatio(
        ThemeTokens.dark.background,
        ThemeTokens.dark.foreground,
      );
      expect(forwards, closeTo(backwards, 0.0001));
    });

    test('a translucent foreground is composited before it is measured', () {
      // A 12% action wash on the page reads as a near-page colour, not as
      // action's own ratio.
      final Color wash = Palette.action.withValues(alpha: 0.12);
      expect(
        elContrastRatio(wash, ThemeTokens.dark.background),
        lessThan(elContrastRatio(Palette.action, ThemeTokens.dark.background)),
      );
      expect(elContrastRatio(wash, ThemeTokens.dark.background), lessThan(1.5));
    });
  });

  group('elContrastVerdict', () {
    test('grades on the raw ratio, at the standard\'s own thresholds', () {
      expect(elContrastVerdict(21), 'AAA');
      expect(elContrastVerdict(7), 'AAA');
      expect(elContrastVerdict(6.99), 'AA');
      expect(elContrastVerdict(4.5), 'AA');
      expect(elContrastVerdict(4.49), 'AA large / UI only');
      expect(elContrastVerdict(3), 'AA large / UI only');
      expect(elContrastVerdict(2.99), 'Fails');
      expect(elContrastVerdict(1), 'Fails');
    });

    test('rounding for the reader does not round for the grader', () {
      // `--color-value-dark` on dark: 3.98 prints as 4.0 and is still graded
      // below AA.
      const double raw = 3.98;
      expect(elContrastRatioLabel(raw), '4.0');
      expect(elContrastVerdict(raw), 'AA large / UI only');
      expect(elContrastBadgeText(raw), 'Contrast 4.0:1 · AA large / UI only');
    });
  });

  group('the badge strings the page prints', () {
    ({double ratio, String text}) badge(String token, ResolvedColorMode kind) {
      final ThemeTokens theme = kind == ResolvedColorMode.dark
          ? ThemeTokens.dark
          : ThemeTokens.light;
      final double ratio = TokenRegistry.contrastRatio(token, theme);
      return (ratio: ratio, text: elContrastBadgeText(ratio));
    }

    test('dark muted-foreground', () {
      expect(
        badge('--muted-foreground', ResolvedColorMode.dark).text,
        'Contrast 13.5:1 · AAA',
      );
    });

    test('dark value-dark — the 3.98 that prints 4.0', () {
      final ({double ratio, String text}) measured = badge(
        '--color-value-dark',
        ResolvedColorMode.dark,
      );
      expect(measured.ratio, lessThan(4.0));
      expect(measured.ratio, closeTo(3.98, 0.1));
      expect(measured.text, 'Contrast 4.0:1 · AA large / UI only');
    });

    test('light action-bright', () {
      expect(
        badge('--color-action-bright', ResolvedColorMode.light).text,
        'Contrast 1.9:1 · Fails',
      );
    });
  });

  group('every swatched token matches colors-map', () {
    test('the page swatches eighteen rows, and all of them are registered', () {
      expect(_printed, hasLength(18));
      for (final _Printed row in _printed) {
        expect(
          TokenRegistry.has(row.token),
          isTrue,
          reason: '${row.token} is swatched on the page but not registered',
        );
      }
      // Fourteen of the eighteen carry a badge; the four pure fills do not.
      expect(_dark, hasLength(14));
      expect(_light, hasLength(14));
      final Set<String> measured = _dark.map((_Expected e) => e.token).toSet();
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
          TokenRegistry.printedValue(row.token, ResolvedColorMode.dark),
          row.dark,
        );
        expect(
          TokenRegistry.printedValue(row.token, ResolvedColorMode.light),
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
      final double raw = TokenRegistry.contrastRatio(
        '--foreground',
        ThemeTokens.dark,
      );
      expect(raw, closeTo(19.0611, 0.0005));
      expect(raw, closeTo(19.0, 0.1)); // still inside the map's allowance
      expect(elContrastBadgeText(raw), 'Contrast 19.1:1 · AAA');
    });

    for (final (ResolvedColorMode kind, List<_Expected> table)
        in <(ResolvedColorMode, List<_Expected>)>[
          (ResolvedColorMode.dark, _dark),
          (ResolvedColorMode.light, _light),
        ]) {
      final ThemeTokens theme = kind == ResolvedColorMode.dark
          ? ThemeTokens.dark
          : ThemeTokens.light;
      for (final _Expected row in table) {
        test('${kind.name} ${row.token}', () {
          final double ratio = TokenRegistry.contrastRatio(row.token, theme);
          expect(
            ratio,
            closeTo(row.ratio, 0.1),
            reason:
                '${row.token} on ${kind.name}: colors-map says '
                '${row.ratio}, we measure ${ratio.toStringAsFixed(3)}',
          );
          expect(elContrastVerdict(ratio), row.verdict);
        });
      }
    }
  });

  group('TokenRegistry', () {
    test('prints the compiled stylesheet\'s hex, per theme', () {
      // `globals.css` authors `hsl(240 10% 3.9%)` here; the browser is served
      // — and therefore reads back — the minifier's `#09090b`.
      expect(
        TokenRegistry.printedValue('--background', ResolvedColorMode.dark),
        '#09090b',
      );
      expect(
        TokenRegistry.printedValue('--background', ResolvedColorMode.light),
        '#fff',
      );
      expect(
        TokenRegistry.printedValue(
          '--muted-foreground',
          ResolvedColorMode.dark,
        ),
        '#d4d4d8',
      );
      expect(
        TokenRegistry.printedValue(
          '--muted-foreground',
          ResolvedColorMode.light,
        ),
        '#62626a',
      );
      // A token authored as hex passes through untouched.
      expect(
        TokenRegistry.printedValue('--color-value', ResolvedColorMode.dark),
        '#a3e635',
      );
      // A ramp token is declared once, so it prints the same text in both.
      expect(
        TokenRegistry.printedValue('--color-value', ResolvedColorMode.light),
        '#a3e635',
      );
      expect(
        TokenRegistry.printedValue('--destructive', ResolvedColorMode.dark),
        '#dc2626',
      );
      // The ink tokens are the ones that flip.
      expect(
        TokenRegistry.printedValue(
          '--color-action-ink',
          ResolvedColorMode.dark,
        ),
        '#92c2fc',
      );
      expect(
        TokenRegistry.printedValue(
          '--color-action-ink',
          ResolvedColorMode.light,
        ),
        '#143694',
      );
      expect(
        TokenRegistry.printedValue('--color-value-ink', ResolvedColorMode.dark),
        '#d9f99d',
      );
      expect(
        TokenRegistry.printedValue(
          '--color-value-ink',
          ResolvedColorMode.light,
        ),
        '#4d7c0f',
      );
    });

    test('the three-digit collapse is the only shape variation', () {
      // `#ffffff` is the one value in this system whose bytes all have matching
      // nibbles, and the reference prints it `#fff`. Everything else is six
      // digits — including `#fafafa`, which looks collapsible and is not
      // (`fa` is two different nibbles).
      expect(elCssColorText(hslColor(0, 0, 100)), '#fff');
      expect(elCssColorText(ThemeTokens.dark.foreground), '#fafafa');
      expect(elCssColorText(ThemeTokens.light.background), '#fff');
      expect(elCssColorText(ThemeTokens.light.card), '#fff');
      // Every registered token, both themes, is one of the two hex shapes and
      // is lowercase — the minifier never emits anything else here.
      for (final String token in TokenRegistry.names) {
        for (final ResolvedColorMode kind in ResolvedColorMode.values) {
          expect(
            TokenRegistry.printedValue(token, kind),
            matches(_hexText),
            reason: '$token on ${kind.name}',
          );
        }
      }
    });

    test('resolves through the live theme, not through the printed text', () {
      expect(
        TokenRegistry.resolve('--background', ThemeTokens.dark),
        ThemeTokens.dark.background,
      );
      expect(
        TokenRegistry.resolve('--color-action-ink', ThemeTokens.light),
        Palette.actionDark,
      );
      expect(
        TokenRegistry.resolve('--color-value', ThemeTokens.light),
        Palette.value,
      );
    });

    test('what a token paints is what it prints — every token, both themes', () {
      // The swatch colour and the readout beside it are the same colour. Since
      // the readout is derived, this proves the derivation loses nothing on the
      // way out and comes back to the byte it started from.
      for (final String token in TokenRegistry.names) {
        for (final ResolvedColorMode kind in ResolvedColorMode.values) {
          expect(
            TokenRegistry.resolve(token, _theme(kind)),
            _parseCss(TokenRegistry.printedValue(token, kind)),
            reason:
                '$token on ${kind.name}: the painted colour and the printed '
                'value disagree — one of the two halves is wrong',
          );
        }
      }
    });

    test('an unregistered name is an error, not a silent zero', () {
      expect(TokenRegistry.has('--not-a-token'), isFalse);
      expect(
        () => TokenRegistry.resolve('--not-a-token', ThemeTokens.dark),
        throwsArgumentError,
      );
      expect(
        () =>
            TokenRegistry.printedValue('--not-a-token', ResolvedColorMode.dark),
        throwsArgumentError,
      );
    });
  });

  group('the widgets', () {
    testWidgets('a swatch row prints name, value, token and badge', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _scope(
          const TokenSwatchList(
            rows: <Widget>[
              TokenSwatch(
                token: '--muted-foreground',
                name: 'Muted foreground',
                use: 'Secondary text, metadata, helper copy.',
              ),
            ],
          ),
          ColorMode.dark,
        ),
      );

      expect(find.text('Muted foreground'), findsOneWidget);
      expect(find.text('#d4d4d8'), findsOneWidget);
      expect(find.text('--muted-foreground'), findsOneWidget);
      expect(
        find.text('Secondary text, metadata, helper copy.'),
        findsOneWidget,
      );
      // `.type-micro` uppercases the whole badge.
      expect(
        find.textContaining('CONTRAST 13.5:1 · AAA', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('at sm the row is an 88 / 208 / flex grid with 24px gaps', (
      WidgetTester tester,
    ) async {
      // `sm:grid-cols-[5.5rem_minmax(0,13rem)_1fr] sm:gap-6 p-4`, and the
      // swatch tightens from `h-16` to `sm:h-14`.
      await tester.pumpWidget(
        _scope(
          const TokenSwatch(
            token: '--muted-foreground',
            name: 'Muted foreground',
            use: 'Secondary text, metadata, helper copy.',
          ),
          ColorMode.dark,
        ),
      );

      final Finder swatch = find.byType(DecoratedBox);
      expect(tester.getSize(swatch), Size(space(22), space(14)));

      final double left = tester.getTopLeft(swatch).dx;
      // Column two starts after the swatch track plus one gap…
      expect(
        tester.getTopLeft(find.text('Muted foreground')).dx,
        closeTo(left + space(22) + space(6), 0.01),
      );
      // …and column three after the 13rem name track plus another gap.
      expect(
        tester
            .getTopLeft(find.text('Secondary text, metadata, helper copy.'))
            .dx,
        closeTo(left + space(22) + space(6) + space(52) + space(6), 0.01),
      );
    });

    testWidgets('below sm the three cells stack instead', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ThemeScope(
          controller: ThemeController(mode: ColorMode.dark),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              // Under the `sm` breakpoint.
              data: const MediaQueryData(size: Size(400, 900)),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 400,
                  child: const TokenSwatch(
                    token: '--muted-foreground',
                    name: 'Muted foreground',
                    use: 'Secondary text, metadata, helper copy.',
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final Finder swatch = find.byType(DecoratedBox);
      // `h-16` — the taller mobile swatch, full width of the column.
      expect(tester.getSize(swatch).height, space(16));

      final Offset mark = tester.getTopLeft(swatch);
      final Offset name = tester.getTopLeft(find.text('Muted foreground'));
      expect(name.dy, greaterThan(mark.dy));
      expect(name.dx, closeTo(mark.dx, 0.01));
    });

    testWidgets(
      'the badge renders as authored, and only the verdict is tinted',
      (WidgetTester tester) async {
        // No type role transforms its text, so the pixels are the authored copy.

        await tester.pumpWidget(
          _scope(const ContrastBadge('--muted-foreground'), ColorMode.dark),
        );

        final double raw = TokenRegistry.contrastRatio(
          '--muted-foreground',
          ThemeTokens.dark,
        );
        expect(elContrastBadgeText(raw), 'Contrast 13.5:1 · AAA');

        final TextSpan root =
            tester.widget<Text>(find.byType(Text)).textSpan! as TextSpan;
        expect(root.toPlainText(), elContrastBadgeText(raw).toUpperCase());

        final List<InlineSpan> spans = root.children!;
        expect(spans, hasLength(2));
        expect((spans[0] as TextSpan).text, 'CONTRAST 13.5:1 · ');
        expect((spans[1] as TextSpan).text, 'AAA');
        // The sentence is muted; only the verdict word takes value ink.
        expect(root.style!.color, ThemeTokens.dark.mutedForeground);
        expect(
          (spans[1] as TextSpan).style!.color,
          ThemeTokens.dark.premiumText,
        );
      },
    );

    testWidgets('a failing verdict takes destructive ink instead', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _scope(const ContrastBadge('--color-value'), ColorMode.light),
      );

      final TextSpan root =
          tester.widget<Text>(find.byType(Text)).textSpan! as TextSpan;
      expect(root.toPlainText(), 'CONTRAST 1.5:1 · FAILS');
      expect(
        (root.children![1] as TextSpan).style!.color,
        ThemeTokens.light.destructiveText,
      );
    });

    testWidgets('a badge can be measured against a surface other than the page', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _scope(
          const ContrastBadge('--destructive', against: '--card'),
          ColorMode.dark,
        ),
      );

      final double onCard = elContrastRatio(
        ThemeTokens.dark.destructive,
        ThemeTokens.dark.card,
      );
      // colors-map drift #5: red measures ~4.1 on the page and lower on a card.
      expect(onCard, lessThan(4.1));
      expect(
        tester.widget<Text>(find.byType(Text)).textSpan!.toPlainText(),
        elContrastBadgeText(onCard).toUpperCase(),
      );
    });

    testWidgets('an unregistered token renders the em dash, never a crash', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _scope(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TokenValue('--not-a-token'),
              ContrastBadge('--not-a-token'),
            ],
          ),
          ColorMode.dark,
        ),
      );

      expect(find.text('—'), findsNWidgets(2));
    });

    testWidgets('measure: false drops the badge — the pure fills', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _scope(
          const TokenSwatch(
            token: '--card',
            name: 'Card',
            use: 'Containers.',
            measure: false,
          ),
          ColorMode.dark,
        ),
      );

      expect(find.text('Card'), findsOneWidget);
      expect(find.byType(ContrastBadge), findsNothing);
    });

    testWidgets('the badge re-measures when the theme flips', (
      WidgetTester tester,
    ) async {
      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        ThemeScope(
          controller: controller,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: ContrastBadge('--color-action-bright')),
          ),
        ),
      );

      expect(
        find.textContaining('CONTRAST 10.7:1 · AAA', findRichText: true),
        findsOneWidget,
      );

      controller.setMode(ColorMode.light);
      await tester.pump();

      expect(
        find.textContaining('CONTRAST 1.9:1 · FAILS', findRichText: true),
        findsOneWidget,
      );
    });
  });
}
