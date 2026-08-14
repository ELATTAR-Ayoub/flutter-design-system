/// The colours page's engine — `components/ds/token-swatch.tsx`.
///
/// The premise of `/design-system/colors` is *measured, not asserted*: no hex
/// on that page is typed by hand, and no contrast claim is written down. The
/// web gets this from the platform — it paints a hidden probe `div`, asks the
/// browser to rasterise `var(--token)`, reads the computed `rgb()` back, and
/// does the WCAG arithmetic on whatever came out. A `MutationObserver` on
/// `<html>`'s `class` attribute drops the memo caches when next-themes flips
/// the theme, so every printed value and every ratio re-measures on the flip.
///
/// Flutter has no cascade to interrogate, so the two halves separate:
///
/// * **Resolution** ([DsTokenRegistry.resolve]) maps a CSS custom-property name
///   onto the live [DsThemeData]. It reads the package tokens — the same
///   objects every other widget paints with — so a swatch cannot disagree with
///   the thing it is documenting. It never re-parses [DsTokenRegistry
///   .printedValue]; the printed text is a *readout*, not a source.
/// * **The printed value** ([DsTokenRegistry.printedValue]) is the raw authored
///   CSS text after `var()` substitution, which is exactly what
///   `getComputedStyle().getPropertyValue()` hands back: `hsl(240 10% 3.9%)`,
///   `#a3e635`, `hsl(0 72.2% 50.6%)` — never a normalised `rgb()`. It is
///   per-theme wherever the underlying var flips, because substitution happens
///   after the cascade has picked a theme block.
///
/// The observer has no port and needs none: every widget here reads
/// `DsTheme.of(context)`, so a mode change rebuilds them and both halves
/// recompute. That is the same guarantee the observer buys the web, arrived at
/// by the framework rather than by a subscription.
library;

import 'dart:math' as math;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// WCAG 2.x
// ─────────────────────────────────────────────────────────────────────────────

// The formula's own constants. They are literals in the strict sense, but they
// are not design tokens and never will be: a rebrand cannot move them, and
// pushing them into `lib/src/foundation/` would file the accessibility standard
// under the colour system. They are named here instead, one per line, so the
// arithmetic below reads as the specification it transcribes.

/// WCAG 2.x relative luminance — the linearisation threshold on the `0..1`
/// channel. The reference writes it in `token-swatch.tsx`'s `luminance()`.
const double _linearThreshold = 0.03928; // allow-hardcoded: WCAG 2.x constant

/// The low-end slope below [_linearThreshold].
const double _linearSlope = 12.92; // allow-hardcoded: WCAG 2.x constant

/// The gamma-expansion offset: `((s + 0.055) / 1.055) ^ 2.4`.
const double _gammaOffset = 0.055; // allow-hardcoded: WCAG 2.x constant

/// The gamma-expansion divisor.
const double _gammaScale = 1.055; // allow-hardcoded: WCAG 2.x constant

/// The gamma-expansion exponent.
const double _gammaExponent = 2.4; // allow-hardcoded: WCAG 2.x constant

/// Red's share of relative luminance.
const double _luminanceRed = 0.2126; // allow-hardcoded: WCAG 2.x constant

/// Green's share of relative luminance.
const double _luminanceGreen = 0.7152; // allow-hardcoded: WCAG 2.x constant

/// Blue's share of relative luminance.
const double _luminanceBlue = 0.0722; // allow-hardcoded: WCAG 2.x constant

/// The flare term in `(hi + 0.05) / (lo + 0.05)` — the ambient light the
/// standard assumes falls on the screen, which is what keeps the ratio finite.
const double _contrastFlare = 0.05; // allow-hardcoded: WCAG 2.x constant

/// SC 1.4.6 Contrast (Enhanced).
const double _thresholdAaa = 7; // allow-hardcoded: WCAG 2.x success criterion

/// SC 1.4.3 Contrast (Minimum), body text.
const double _thresholdAa = 4.5; // allow-hardcoded: WCAG 2.x success criterion

/// SC 1.4.3 large text / SC 1.4.11 non-text contrast.
const double _thresholdLarge = 3; // allow-hardcoded: WCAG 2.x success criterion

/// One channel, sRGB → linear light.
///
/// [channel] is `0..1`. The web divides an `0..255` byte by 255 to get here;
/// Flutter's [Color.r] / [Color.g] / [Color.b] are already that quotient, and
/// because `dsHsl` quantises through the 8-bit grid the two agree exactly.
double _linearise(double channel) => channel <= _linearThreshold
    ? channel / _linearSlope
    : math
        .pow((channel + _gammaOffset) / _gammaScale, _gammaExponent)
        .toDouble();

/// WCAG relative luminance of three **opaque** `0..1` channels.
///
/// Takes loose channels rather than a [Color] so the alpha-composited case
/// never has to build one: the composite is an intermediate the standard needs
/// and the framework does not, and constructing a `Color` for it would put a
/// raw colour literal in a file that is not allowed to hold one.
double _relativeLuminance(double r, double g, double b) =>
    _luminanceRed * _linearise(r) +
    _luminanceGreen * _linearise(g) +
    _luminanceBlue * _linearise(b);

/// The WCAG 2.x contrast ratio between [fg] and [bg], `1.0 … 21.0`.
///
/// [fg] is alpha-composited over [bg] before its luminance is taken — the
/// reference does this so a wash measured against the page reports the ratio a
/// reader actually sees, not the ratio of the colour it was mixed from. [bg] is
/// used as given, exactly as `contrast()` in `token-swatch.tsx` does; a
/// translucent backdrop is not a case the page has.
///
/// Order does not matter: the brighter luminance always takes the numerator.
double dsContrastRatio(Color fg, Color bg) {
  final bool translucent = fg.a < 1;

  /// `composite()` — straight source-over on un-premultiplied channels.
  double over(double f, double b) =>
      translucent ? f * fg.a + b * (1 - fg.a) : f;

  final double a = _relativeLuminance(
    over(fg.r, bg.r),
    over(fg.g, bg.g),
    over(fg.b, bg.b),
  );
  final double b = _relativeLuminance(bg.r, bg.g, bg.b);
  final double hi = a > b ? a : b;
  final double lo = a > b ? b : a;
  return (hi + _contrastFlare) / (lo + _contrastFlare);
}

/// The badge's verdict word for [ratio].
///
/// Computed on the **raw** ratio, never on the printed one — that gap is
/// deliberate and visible on the page. `--color-value-dark` on dark measures
/// 3.98, which is below AA and is graded "AA large / UI only", yet the badge
/// beside it prints `4.0:1`. Rounding for the reader must not round for the
/// grader.
String dsContrastVerdict(double ratio) {
  if (ratio >= _thresholdAaa) return 'AAA';
  if (ratio >= _thresholdAa) return 'AA';
  if (ratio >= _thresholdLarge) return 'AA large / UI only';
  return 'Fails';
}

/// True when [ratio] passes at some level, which is the only thing the badge's
/// colouring distinguishes: the three passing verdicts all render in
/// `--value-ink`, and only `Fails` goes to `--destructive-ink`.
bool dsContrastPasses(double ratio) => ratio >= _thresholdLarge;

/// The colour the verdict word takes in [theme].
Color dsContrastVerdictColor(double ratio, DsThemeData theme) =>
    dsContrastPasses(ratio) ? theme.valueInk : theme.destructiveInk;

/// The printed ratio, `toFixed(1)` in the reference.
String dsContrastRatioLabel(double ratio) => ratio.toStringAsFixed(1);

/// Everything the badge says before the verdict, including the separator and
/// its trailing space — the reference's `Contrast {ratio.toFixed(1)}:1 ·{" "}`.
String dsContrastBadgePrefix(double ratio) =>
    'Contrast ${dsContrastRatioLabel(ratio)}:1 · ';

/// The whole badge as one string, **as authored**: `Contrast 13.5:1 · AAA`.
///
/// What renders is this string uppercased, because the badge is `.type-micro`
/// and that class carries `text-transform: uppercase` — so the pixels read
/// `CONTRAST 13.5:1 · AAA`. Both forms are worth having: this one is the copy
/// the reference source contains, and `.toUpperCase()` of it is the copy a
/// screenshot contains.
String dsContrastBadgeText(double ratio) =>
    '${dsContrastBadgePrefix(ratio)}${dsContrastVerdict(ratio)}';

// ─────────────────────────────────────────────────────────────────────────────
// The registry
// ─────────────────────────────────────────────────────────────────────────────

/// One CSS custom property: how it resolves, and what it prints.
class _DsToken {
  /// A property whose substituted text differs between the theme blocks —
  /// every `--*-ink`, and every semantic token the two blocks both declare.
  const _DsToken({
    required this.resolve,
    required this.light,
    required this.dark,
  });

  /// A property declared once in `@theme static`, so both themes print the
  /// same text — the ramps and the state hues.
  const _DsToken.constant({required this.resolve, required String value})
      : light = value,
        dark = value;

  /// Where the value lives on a resolved theme block. Always a field read:
  /// the token IS the theme's field, and going through anything else would
  /// re-introduce the second source of truth this file exists to remove.
  final Color Function(DsThemeData theme) resolve;

  /// The raw CSS text `:root, .light` substitutes to.
  final String light;

  /// The raw CSS text `.dark` substitutes to.
  final String dark;

  String printed(DsThemeKind kind) =>
      kind == DsThemeKind.dark ? dark : light;
}

/// Every token the docs can swatch, keyed by its CSS custom-property name.
///
/// The strings are transcriptions of `app/globals.css`, line by line — they are
/// the page's *readout*, and the one thing here that genuinely cannot be
/// derived, because a browser hands back the authored text rather than a
/// normalised colour. The [Color] on the other side of each row is never parsed
/// from them.
class DsTokenRegistry {
  const DsTokenRegistry._();

  static final Map<String, _DsToken> _tokens = <String, _DsToken>{
    // ── Monochrome: zinc (globals.css L549–574 light / L746–762 dark) ───────
    '--background': _DsToken(
      resolve: (DsThemeData t) => t.background,
      light: 'hsl(0 0% 100%)',
      dark: 'hsl(240 10% 3.9%)',
    ),
    '--foreground': _DsToken(
      resolve: (DsThemeData t) => t.foreground,
      light: 'hsl(240 10% 3.9%)',
      dark: 'hsl(0 0% 98%)',
    ),
    '--card': _DsToken(
      resolve: (DsThemeData t) => t.card,
      light: 'hsl(0 0% 100%)',
      dark: 'hsl(240 5.9% 10%)',
    ),
    '--card-foreground': _DsToken(
      resolve: (DsThemeData t) => t.cardForeground,
      light: 'hsl(240 10% 3.9%)',
      dark: 'hsl(0 0% 98%)',
    ),
    '--popover': _DsToken(
      resolve: (DsThemeData t) => t.popover,
      light: 'hsl(0 0% 100%)',
      dark: 'hsl(240 5.9% 10%)',
    ),
    '--popover-foreground': _DsToken(
      resolve: (DsThemeData t) => t.popoverForeground,
      light: 'hsl(240 10% 3.9%)',
      dark: 'hsl(0 0% 98%)',
    ),
    '--secondary': _DsToken(
      resolve: (DsThemeData t) => t.secondary,
      light: 'hsl(240 4.8% 95.9%)',
      dark: 'hsl(240 3.7% 15.9%)',
    ),
    '--secondary-foreground': _DsToken(
      resolve: (DsThemeData t) => t.secondaryForeground,
      light: 'hsl(240 5.9% 10%)',
      dark: 'hsl(0 0% 98%)',
    ),
    '--muted': _DsToken(
      resolve: (DsThemeData t) => t.muted,
      light: 'hsl(240 4.8% 95.9%)',
      dark: 'hsl(240 3.7% 15.9%)',
    ),
    '--muted-foreground': _DsToken(
      resolve: (DsThemeData t) => t.mutedForeground,
      light: 'hsl(240 4% 40%)',
      dark: 'hsl(240 4.9% 83.9%)',
    ),
    '--accent': _DsToken(
      resolve: (DsThemeData t) => t.accent,
      light: 'hsl(240 4.8% 95.9%)',
      dark: 'hsl(240 5.3% 26.1%)',
    ),
    '--accent-foreground': _DsToken(
      resolve: (DsThemeData t) => t.accentForeground,
      light: 'hsl(240 5.9% 10%)',
      dark: 'hsl(0 0% 98%)',
    ),
    '--border': _DsToken(
      resolve: (DsThemeData t) => t.border,
      light: 'hsl(240 5.9% 90%)',
      dark: 'hsl(240 3.7% 15.9%)',
    ),
    '--input': _DsToken(
      resolve: (DsThemeData t) => t.input,
      light: 'hsl(240 5.9% 90%)',
      dark: 'hsl(240 5.3% 26.1%)',
    ),
    '--page-glow': _DsToken(
      resolve: (DsThemeData t) => t.pageGlow,
      light: 'hsl(240 30% 98%)',
      dark: 'hsl(240 8% 10%)',
    ),

    // ── Brand (L582–584 / L772–780) ────────────────────────────────────────
    // `--primary: var(--color-action)` in both blocks, so it prints the ramp's
    // own text; `--ring` is the one that flips.
    '--primary': _DsToken.constant(
      resolve: (DsThemeData t) => t.primary,
      value: 'hsl(217 91% 53%)',
    ),
    '--primary-foreground': _DsToken.constant(
      resolve: (DsThemeData t) => t.primaryForeground,
      value: 'hsl(0 0% 100%)',
    ),
    '--ring': _DsToken(
      resolve: (DsThemeData t) => t.ring,
      light: 'hsl(217 91% 53%)',
      dark: 'hsl(213 94% 78%)',
    ),

    // ── The ramps, `@theme static` (L103–109) ──────────────────────────────
    // Declared once, outside both theme blocks, so the printed text is the same
    // in light and dark — only what they MEAN changes, and that is the ink
    // tokens' job.
    '--color-action-bright': _DsToken.constant(
      resolve: (DsThemeData t) => DsPalette.actionBright,
      value: 'hsl(213 94% 78%)',
    ),
    '--color-action': _DsToken.constant(
      resolve: (DsThemeData t) => DsPalette.action,
      value: 'hsl(217 91% 53%)',
    ),
    '--color-action-dark': _DsToken.constant(
      resolve: (DsThemeData t) => DsPalette.actionDark,
      value: 'hsl(224 76% 33%)',
    ),
    '--color-value-bright': _DsToken.constant(
      resolve: (DsThemeData t) => DsPalette.valueBright,
      value: '#d9f99d',
    ),
    '--color-value': _DsToken.constant(
      resolve: (DsThemeData t) => DsPalette.value,
      value: '#a3e635',
    ),
    '--color-value-dark': _DsToken.constant(
      resolve: (DsThemeData t) => DsPalette.valueDark,
      value: '#4d7c0f',
    ),
    '--color-value-foreground': _DsToken.constant(
      resolve: (DsThemeData t) => DsPalette.valueForeground,
      value: 'hsl(240 10% 8%)',
    ),

    // ── State hues, `@theme static` (L148–165) ─────────────────────────────
    '--color-success': _DsToken.constant(
      resolve: (DsThemeData t) => DsPalette.success,
      value: '#10b981',
    ),
    '--color-warning': _DsToken.constant(
      resolve: (DsThemeData t) => DsPalette.warning,
      value: '#fbbf24',
    ),
    '--color-info': _DsToken.constant(
      resolve: (DsThemeData t) => DsPalette.info,
      value: '#22d3ee',
    ),
    '--color-success-deep': _DsToken.constant(
      resolve: (DsThemeData t) => DsPalette.successDeep,
      value: '#047857',
    ),
    '--color-warning-deep': _DsToken.constant(
      resolve: (DsThemeData t) => DsPalette.warningDeep,
      value: '#b45309',
    ),
    '--color-info-deep': _DsToken.constant(
      resolve: (DsThemeData t) => DsPalette.infoDeep,
      value: '#0e7490',
    ),
    '--color-destructive-lifted': _DsToken.constant(
      resolve: (DsThemeData t) => DsPalette.destructiveLifted,
      value: '#f87171',
    ),
    '--color-destructive-deep': _DsToken.constant(
      resolve: (DsThemeData t) => DsPalette.destructiveDeep,
      value: 'hsl(0 72.2% 46%)',
    ),
    '--destructive': _DsToken.constant(
      resolve: (DsThemeData t) => t.destructive,
      value: 'hsl(0 72.2% 50.6%)',
    ),
    '--destructive-foreground': _DsToken.constant(
      resolve: (DsThemeData t) => t.destructiveForeground,
      value: 'hsl(0 0% 98%)',
    ),

    // ── The text-safe end of each ramp, per theme (L589–594 / L784–802) ────
    // `--color-action-ink: var(--action-ink)` (L490) and the theme block then
    // answers with a ramp end, so ONE substitution chain lands on two different
    // strings. This is the whole reason the printed value is per-theme.
    '--action-ink': _DsToken(
      resolve: (DsThemeData t) => t.actionInk,
      light: 'hsl(224 76% 33%)',
      dark: 'hsl(213 94% 78%)',
    ),
    '--color-action-ink': _DsToken(
      resolve: (DsThemeData t) => t.actionInk,
      light: 'hsl(224 76% 33%)',
      dark: 'hsl(213 94% 78%)',
    ),
    '--value-ink': _DsToken(
      resolve: (DsThemeData t) => t.valueInk,
      light: '#4d7c0f',
      dark: '#d9f99d',
    ),
    '--color-value-ink': _DsToken(
      resolve: (DsThemeData t) => t.valueInk,
      light: '#4d7c0f',
      dark: '#d9f99d',
    ),
    '--success-ink': _DsToken(
      resolve: (DsThemeData t) => t.successInk,
      light: '#047857',
      dark: '#10b981',
    ),
    '--color-success-ink': _DsToken(
      resolve: (DsThemeData t) => t.successInk,
      light: '#047857',
      dark: '#10b981',
    ),
    '--warning-ink': _DsToken(
      resolve: (DsThemeData t) => t.warningInk,
      light: '#b45309',
      dark: '#fbbf24',
    ),
    '--color-warning-ink': _DsToken(
      resolve: (DsThemeData t) => t.warningInk,
      light: '#b45309',
      dark: '#fbbf24',
    ),
    '--info-ink': _DsToken(
      resolve: (DsThemeData t) => t.infoInk,
      light: '#0e7490',
      dark: '#22d3ee',
    ),
    '--color-info-ink': _DsToken(
      resolve: (DsThemeData t) => t.infoInk,
      light: '#0e7490',
      dark: '#22d3ee',
    ),
    '--destructive-ink': _DsToken(
      resolve: (DsThemeData t) => t.destructiveInk,
      light: 'hsl(0 72.2% 46%)',
      dark: '#f87171',
    ),
    '--color-destructive-ink': _DsToken(
      resolve: (DsThemeData t) => t.destructiveInk,
      light: 'hsl(0 72.2% 46%)',
      dark: '#f87171',
    ),
  };

  /// Every registered custom-property name.
  static Iterable<String> get names => _tokens.keys;

  /// Whether [cssName] is registered — the guard a widget checks before asking
  /// for a value, so a typo renders the web's own `—` placeholder instead of
  /// crashing a docs page.
  static bool has(String cssName) => _tokens.containsKey(cssName);

  /// The live [Color] for [cssName] in [theme].
  ///
  /// Resolution goes through the package's own token objects — the same
  /// [DsThemeData] fields a button paints with. It deliberately does NOT parse
  /// [printedValue]: the printed text is documentation, and documentation that
  /// feeds back into rendering is how a docs page starts lying.
  static Color resolve(String cssName, DsThemeData theme) =>
      _require(cssName).resolve(theme);

  /// The raw CSS text `getComputedStyle().getPropertyValue(cssName)` returns
  /// under [kind] — after `var()` substitution, before any normalisation.
  static String printedValue(String cssName, DsThemeKind kind) =>
      _require(cssName).printed(kind);

  /// The measured ratio of [cssName] against [against] in [theme] — the port of
  /// `useContrast`.
  static double contrastRatio(
    String cssName,
    DsThemeData theme, {
    String against = _defaultAgainst,
  }) =>
      dsContrastRatio(resolve(cssName, theme), resolve(against, theme));

  static _DsToken _require(String cssName) {
    final _DsToken? token = _tokens[cssName];
    if (token == null) {
      throw ArgumentError.value(
        cssName,
        'cssName',
        'Not a registered design token. Add it to DsTokenRegistry with the '
            'raw text globals.css substitutes to in each theme block.',
      );
    }
    return token;
  }
}

/// `ContrastBadge`'s default: everything is measured against the page.
const String _defaultAgainst = '--background';

/// What the web renders when `getPropertyValue` comes back empty — and, before
/// hydration, for every token. Flutter has no hydration gap, so here it means
/// only one thing: the token is not registered.
const String _unresolved = '—';

// ─────────────────────────────────────────────────────────────────────────────
// Widgets
// ─────────────────────────────────────────────────────────────────────────────

/// The token's value as the stylesheet spells it — `TokenValue`.
///
/// `span.type-num-sm.text-muted-foreground`.
class DsTokenValue extends StatelessWidget {
  const DsTokenValue(this.token, {super.key});

  /// The CSS custom-property name, e.g. `--muted-foreground`.
  final String token;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final String value = DsTokenRegistry.has(token)
        ? DsTokenRegistry.printedValue(token, theme.kind)
        : _unresolved;
    return DsText(value, DsType.numSm, color: theme.mutedForeground);
  }
}

/// The measured ratio and its verdict — `ContrastBadge`.
///
/// `span.type-micro.text-muted-foreground` with only the verdict word tinted,
/// so it is one [Text.rich] rather than a [Row]: the verdict has to wrap with
/// the sentence, not beside it.
///
/// `.type-micro` uppercases, and `text-transform` is inherited, so the WHOLE
/// badge renders in caps — `CONTRAST 13.5:1 · AAA`. [dsContrastBadgeText] is
/// the authored casing; this widget paints its uppercase.
class DsContrastBadge extends StatelessWidget {
  const DsContrastBadge(this.token, {super.key, this.against = _defaultAgainst});

  /// The token being measured.
  final String token;

  /// The surface it is measured on. Defaults to `--background`, the page.
  final String against;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    if (!DsTokenRegistry.has(token) || !DsTokenRegistry.has(against)) {
      return DsText(_unresolved, DsType.micro, color: theme.mutedForeground);
    }

    final double ratio =
        DsTokenRegistry.contrastRatio(token, theme, against: against);

    // `.type-micro` sets its own colour, so the sentence needs no override; the
    // verdict span is the one place the markup writes a `text-*` utility.
    final TextStyle sentence = DsText.styleOf(context, DsType.micro);
    final TextStyle verdict = DsText.styleOf(
      context,
      DsType.micro,
      color: dsContrastVerdictColor(ratio, theme),
    );

    String cased(String text) =>
        DsType.micro.uppercase ? text.toUpperCase() : text;

    return DsRichText(
      TextSpan(
        style: sentence,
        children: <InlineSpan>[
          TextSpan(text: cased(dsContrastBadgePrefix(ratio))),
          TextSpan(text: cased(dsContrastVerdict(ratio)), style: verdict),
        ],
      ),
      DsType.micro,
    );
  }
}

/// One documented token: painted, named, valued and measured — `TokenSwatch`.
///
/// `grid items-center gap-4 p-4 sm:grid-cols-[5.5rem_minmax(0,13rem)_1fr]
/// sm:gap-6`. Below `sm` the three cells stack in one column at 16px gaps;
/// from `sm` up they are a row of 88px / 208px / flex at 24px gaps.
///
/// The two fixed tracks are written through [ds] rather than as pixels:
/// Tailwind's `--spacing` unit is 4px, so `5.5rem` is `ds(22)` and `13rem` is
/// `ds(52)` — the same arithmetic the framework does, kept in the same
/// vocabulary as every other measure on the page.
class DsTokenSwatch extends StatelessWidget {
  const DsTokenSwatch({
    super.key,
    required this.token,
    required this.name,
    required this.use,
    this.measure = true,
  });

  /// The CSS custom-property name — painted, printed, and named in the row.
  final String token;

  /// The human label, `p.type-h4.text-foreground`.
  final String name;

  /// What the token is for, `p.type-small.text-muted-foreground`.
  final String use;

  /// Off for tints and fills that never carry text: `--background`, `--card`,
  /// `--muted`, `--accent`. A ratio for a colour nothing is ever written in is
  /// a number without a question.
  final bool measure;

  /// `sm:grid-cols-[5.5rem_…]` — 5.5rem = 88px.
  static final double _swatchTrack = ds(22);

  /// `minmax(0, 13rem)` — 13rem = 208px, the middle track's cap.
  static final double _nameTrack = ds(52);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool wide = MediaQuery.sizeOf(context).width >= DsBreakpoints.sm;

    // `h-16 sm:h-14` — 64px, tightening to 56px once the row goes horizontal.
    final Widget swatch = SizedBox(
      height: wide ? ds(14) : ds(16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: DsTokenRegistry.has(token)
              ? DsTokenRegistry.resolve(token, theme)
              : dsTransparent,
          borderRadius: BorderRadius.circular(DsRadii.lg),
          // No child to inset: the swatch *is* the colour, and the hairline
          // only has to keep a white card visible on a white background.
          border: Border.all(color: theme.input, width: DsWidths.hairline),
        ),
      ),
    );

    final Widget identity = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DsText(name, DsType.h4, color: theme.foreground),
        SizedBox(height: ds(1)), // `mt-1`
        DsTokenValue(token),
        SizedBox(height: ds(1)), // `mt-1`
        DsText(token, DsType.numSm, color: theme.actionInk),
      ],
    );

    final Widget purpose = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DsText(use, DsType.small, color: theme.mutedForeground),
        if (measure) ...<Widget>[
          SizedBox(height: ds(2)), // `mt-2`
          DsContrastBadge(token),
        ],
      ],
    );

    return Padding(
      padding: EdgeInsets.all(ds(4)), // `p-4`
      child: wide
          ? Row(
              // `items-center`.
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: _swatchTrack, child: swatch),
                SizedBox(width: ds(6)), // `sm:gap-6`
                SizedBox(width: _nameTrack, child: identity),
                SizedBox(width: ds(6)),
                Expanded(child: purpose), // `1fr`
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                swatch,
                SizedBox(height: ds(4)), // `gap-4`
                identity,
                SizedBox(height: ds(4)),
                purpose,
              ],
            ),
    );
  }
}

/// The card the swatches sit in — `TokenSwatchList`.
///
/// `divide-y divide-border overflow-hidden rounded-xl border border-border
/// bg-card`: a 16px card with a 1px hairline BETWEEN rows and none before the
/// first or after the last, which is what `divide-y` means and what a naive
/// bottom-border-per-row gets wrong.
class DsTokenSwatchList extends StatelessWidget {
  const DsTokenSwatchList({super.key, required this.rows});

  /// The rows, normally [DsTokenSwatch]es.
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    final List<Widget> children = <Widget>[];
    for (int i = 0; i < rows.length; i++) {
      if (i > 0) {
        // `divide-y divide-border` — one hairline per GAP, not per row.
        children.add(Container(height: DsWidths.hairline, color: theme.border));
      }
      children.add(rows[i]);
    }

    return Container(
      // `overflow-hidden` — the corners clip the first and last row.
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(DsRadii.xl),
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
