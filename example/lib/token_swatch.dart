/// The colours page's engine, `components/space/token-swatch.tsx`.
///
/// The premise of `/design-system/colors` is *measured, not asserted*: no hex
/// on that page is typed by hand, and no contrast claim is written down. The
/// web gets this from the platform: it paints a hidden probe `div`, asks the
/// browser to rasterise `var(--token)`, reads the computed `rgb()` back, and
/// does the WCAG arithmetic on whatever came out. A `MutationObserver` on
/// `<html>`'s `class` attribute drops the memo caches when next-themes flips
/// the theme, so every printed value and every ratio re-measures on the flip.
///
/// Flutter has no cascade to interrogate, so the two halves separate:
///
/// * **Resolution** ([TokenRegistry.resolve]) maps a CSS custom-property name
///   onto the live [ThemeTokens]. It reads the package tokens: the same
///   objects every other widget paints with: so a swatch cannot disagree with
///   the thing it is documenting. It never re-parses [TokenRegistry
///   .printedValue]; the printed text is a *readout*, not a source.
/// * **The printed value** ([TokenRegistry.printedValue]) is the text
///   `getComputedStyle().getPropertyValue()` hands back: which is *not* the
///   text `app/globals.css` authors. The stylesheet writes `hsl(240 10% 3.9%)`;
///   the browser is served `#09090b`, because Tailwind v4 compiles the sheet
///   through Lightning CSS, whose colour minifier rewrites every colour to its
///   shortest form before the CSS ever leaves the dev server. So the page reads
///   back lowercase hex for all eighteen swatches, with `#ffffff` collapsed to
///   `#fff`. That is a pure function of the resolved colour, so it is *derived*
///   here ([elCssColorText]) rather than transcribed: a rebrand moves the token
///   and the readout follows, which is the same guarantee the web gets for free.
///   It stays per-theme wherever the underlying var flips.
///
/// The observer has no port and needs none: every widget here reads
/// `ThemeScope.of(context)`, so a mode change rebuilds them and both halves
/// recompute. That is the same guarantee the observer buys the web, arrived at
/// by the framework rather than by a subscription.
library;

import 'dart:math' as math;

import 'package:elattar_design_system/elattar_design_system.dart';
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

// ─────────────────────────────────────────────────────────────────────────────
// WCAG 2.x
// ─────────────────────────────────────────────────────────────────────────────

// The formula's own constants. They are literals in the strict sense, but they
// are not design tokens and never will be: a rebrand cannot move them, and
// pushing them into `lib/src/design_system/foundation/` would file the accessibility standard
// under the colour system. They are named here instead, one per line, so the
// arithmetic below reads as the specification it transcribes.

/// WCAG 2.x relative luminance: the linearisation threshold on the `0..1`
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

/// The flare term in `(hi + 0.05) / (lo + 0.05)`: the ambient light the
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
/// because `hslColor` quantises through the 8-bit grid the two agree exactly.
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
/// [fg] is alpha-composited over [bg] before its luminance is taken: the
/// reference does this so a wash measured against the page reports the ratio a
/// reader actually sees, not the ratio of the colour it was mixed from. [bg] is
/// used as given, exactly as `contrast()` in `token-swatch.tsx` does; a
/// translucent backdrop is not a case the page has.
///
/// Order does not matter: the brighter luminance always takes the numerator.
double elContrastRatio(Color fg, Color bg) {
  final bool translucent = fg.a < 1;

  /// `composite()`: straight source-over on un-premultiplied channels.
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
/// Computed on the **raw** ratio, never on the printed one: that gap is
/// deliberate and visible on the page. `--color-value-dark` on dark measures
/// 3.98, which is below AA and is graded "AA large / UI only", yet the badge
/// beside it prints `4.0:1`. Rounding for the reader must not round for the
/// grader.
String elContrastVerdict(double ratio) {
  if (ratio >= _thresholdAaa) return 'AAA';
  if (ratio >= _thresholdAa) return 'AA';
  if (ratio >= _thresholdLarge) return 'AA large / UI only';
  return 'Fails';
}

/// True when [ratio] passes at some level, which is the only thing the badge's
/// colouring distinguishes: the three passing verdicts all render in
/// `--value-ink`, and only `Fails` goes to `--destructive-ink`.
bool elContrastPasses(double ratio) => ratio >= _thresholdLarge;

/// The colour the verdict word takes in [theme].
Color elContrastVerdictColor(double ratio, ThemeTokens theme) =>
    elContrastPasses(ratio) ? theme.premiumText : theme.destructiveText;

/// The printed ratio, `toFixed(1)` in the reference.
String elContrastRatioLabel(double ratio) => ratio.toStringAsFixed(1);

/// Everything the badge says before the verdict, including the separator and
/// its trailing space: the reference's `Contrast {ratio.toFixed(1)}:1 ·{" "}`.
String elContrastBadgePrefix(double ratio) =>
    'Contrast ${elContrastRatioLabel(ratio)}:1 · ';

/// The whole badge as one string, **as authored**: `Contrast 13.5:1 · AAA`.
///
/// What renders is this string uppercased, because the badge is `.type-micro`
/// and that class carries `text-transform: uppercase`: so the pixels read
/// `CONTRAST 13.5:1 · AAA`. Both forms are worth having: this one is the copy
/// the reference source contains, and `.toUpperCase()` of it is the copy a
/// screenshot contains.
String elContrastBadgeText(double ratio) =>
    '${elContrastBadgePrefix(ratio)}${elContrastVerdict(ratio)}';

// ─────────────────────────────────────────────────────────────────────────────
// The serialisation the page reads back
// ─────────────────────────────────────────────────────────────────────────────

/// A colour written the way the reference's compiled stylesheet writes it.
///
/// `getComputedStyle().getPropertyValue('--background')` returns the declaration
/// text as the browser parsed it: but the browser never sees `globals.css`.
/// Tailwind v4 compiles it through Lightning CSS, whose colour minifier rewrites
/// every colour to the shortest equivalent form, so `hsl(240 10% 3.9%)` arrives
/// as `#09090b` and `hsl(0 0% 100%)` as `#fff`. Measured on the live dev server,
/// both themes, 2026-08-14: all forty-seven registered properties come back as
/// lowercase hex, three-digit wherever every byte's two nibbles match.
///
/// Two things the minifier does that this does not need to: it would prefer a
/// CSS named colour when one is shorter (`red` beats `#f00`), and it would emit
/// `rgb()` if that were ever shorter than hex (it is not, for an opaque colour).
/// No token in this system lands on a named colour; if a rebrand ever moved one
/// onto `red`, `contrast_test.dart`'s round-trip: which parses every printed
/// value back to a [Color]: is what would catch it.
///
/// Alpha follows the same rule in eight digits (`#000000df` is how the
/// reference's own captured-theme block arrives). No registered token is
/// translucent, so that arm documents the pipeline rather than the page.
String elCssColorText(Color color) {
  String byte(double channel) =>
      (channel * 255).round().toRadixString(16).padLeft(2, '0');

  final String digits = color.a >= 1
      ? '${byte(color.r)}${byte(color.g)}${byte(color.b)}'
      : '${byte(color.r)}${byte(color.g)}${byte(color.b)}${byte(color.a)}';

  // `#ffffff` → `#fff`: the CSS shorthand, available only when both nibbles of
  // every byte agree.
  final bool collapsible = <int>[
    for (int i = 0; i < digits.length; i += 2) i,
  ].every((int i) => digits[i] == digits[i + 1]);

  if (!collapsible) return '#$digits';
  return '#${<String>[for (int i = 0; i < digits.length; i += 2) digits[i]].join()}';
}

// ─────────────────────────────────────────────────────────────────────────────
// The registry
// ─────────────────────────────────────────────────────────────────────────────

/// Where a token's value lives on a resolved theme block.
///
/// Always a field read: the token IS the theme's field, and going through
/// anything else would re-introduce the second source of truth this file exists
/// to remove. The printed text is no longer a second half to keep in step: it
/// is [elCssColorText] of whatever this returns.
typedef _DsToken = Color Function(ThemeTokens theme);

/// Every token the docs can swatch, keyed by its CSS custom-property name.
///
/// One entry per property, and each entry is one field read. There is nothing
/// else to keep in step: the printed readout is derived from the same [Color]
/// the swatch paints, so the row cannot disagree with itself. The line
/// references point at `app/globals.css` in the reference repo.
class TokenRegistry {
  const TokenRegistry._();

  static final Map<String, _DsToken> _tokens = <String, _DsToken>{
    // ── Monochrome: zinc (globals.css L549–574 light / L746–762 dark) ───────
    '--background': (ThemeTokens t) => t.background,
    '--foreground': (ThemeTokens t) => t.foreground,
    '--card': (ThemeTokens t) => t.card,
    '--card-foreground': (ThemeTokens t) => t.cardForeground,
    '--popover': (ThemeTokens t) => t.popover,
    '--popover-foreground': (ThemeTokens t) => t.popoverForeground,
    '--secondary': (ThemeTokens t) => t.secondary,
    '--secondary-foreground': (ThemeTokens t) => t.secondaryForeground,
    '--muted': (ThemeTokens t) => t.muted,
    '--muted-foreground': (ThemeTokens t) => t.mutedForeground,
    '--accent': (ThemeTokens t) => t.accent,
    '--accent-foreground': (ThemeTokens t) => t.accentForeground,
    '--border': (ThemeTokens t) => t.border,
    '--input': (ThemeTokens t) => t.input,
    '--background-effect': (ThemeTokens t) => t.pageGlow,

    // ── Brand (L582–584 / L772–780) ────────────────────────────────────────
    // `--primary: var(--color-action)` in both blocks, so it reads the same in
    // either; `--ring` is the one that flips.
    '--primary': (ThemeTokens t) => t.primary,
    '--primary-foreground': (ThemeTokens t) => t.primaryForeground,
    '--ring': (ThemeTokens t) => t.ring,

    // ── The ramps, `@theme static` (L103–109) ──────────────────────────────
    // Declared once, outside both theme blocks, so these read identically in
    // light and dark: only what they MEAN changes, and that is the ink
    // tokens' job.
    '--color-action-bright': (ThemeTokens t) => Palette.actionBright,
    '--color-action': (ThemeTokens t) => Palette.action,
    '--color-action-dark': (ThemeTokens t) => Palette.actionDark,
    '--color-value-bright': (ThemeTokens t) => Palette.valueBright,
    '--color-value': (ThemeTokens t) => Palette.value,
    '--color-value-dark': (ThemeTokens t) => Palette.valueDark,
    '--color-value-foreground': (ThemeTokens t) => Palette.valueForeground,

    // ── State hues, `@theme static` (L148–165) ─────────────────────────────
    '--color-success': (ThemeTokens t) => Palette.success,
    '--color-warning': (ThemeTokens t) => Palette.warning,
    '--color-info': (ThemeTokens t) => Palette.info,
    '--color-success-deep': (ThemeTokens t) => Palette.successDeep,
    '--color-warning-deep': (ThemeTokens t) => Palette.warningDeep,
    '--color-info-deep': (ThemeTokens t) => Palette.infoDeep,
    '--color-destructive-lifted': (ThemeTokens t) => Palette.destructiveLifted,
    '--color-destructive-deep': (ThemeTokens t) => Palette.destructiveDeep,
    '--destructive': (ThemeTokens t) => t.destructive,
    '--destructive-foreground': (ThemeTokens t) => t.destructiveForeground,

    // ── The text-safe end of each ramp, per theme (L589–594 / L784–802) ────
    // `--color-action-ink: var(--action-ink)` (L490) and the theme block then
    // answers with a ramp end, so ONE substitution chain lands on two different
    // colours. This is the whole reason the printed value is per-theme.
    '--action-ink': (ThemeTokens t) => t.actionText,
    '--color-action-ink': (ThemeTokens t) => t.actionText,
    '--value-ink': (ThemeTokens t) => t.premiumText,
    '--color-value-ink': (ThemeTokens t) => t.premiumText,
    '--success-ink': (ThemeTokens t) => t.successText,
    '--color-success-ink': (ThemeTokens t) => t.successText,
    '--warning-ink': (ThemeTokens t) => t.warningText,
    '--color-warning-ink': (ThemeTokens t) => t.warningText,
    '--info-ink': (ThemeTokens t) => t.infoText,
    '--color-info-ink': (ThemeTokens t) => t.infoText,
    '--destructive-ink': (ThemeTokens t) => t.destructiveText,
    '--color-destructive-ink': (ThemeTokens t) => t.destructiveText,

    // ── The five chart tokens, per theme (L624–628 / L842–846) ─────────────
    // *"Declared once per theme in `app/globals.css`, and mirrored between them
    // on purpose: 2 and 3 swap, and so do 4 and 5, so the reading order of a
    // stack survives the theme flip instead of inverting with it… There is no
    // sixth, and adding one needs a written reason."* The charts page renders
    // all five through `TokenSwatchList`, with `measure: false` on every row —
    // a series fill is not text and is not held to the AA threshold, which is
    // exactly why a chart token must not be reused as a label colour.
    '--chart-1': (ThemeTokens t) => t.chart1,
    '--chart-2': (ThemeTokens t) => t.chart2,
    '--chart-3': (ThemeTokens t) => t.chart3,
    '--chart-4': (ThemeTokens t) => t.chart4,
    '--chart-5': (ThemeTokens t) => t.chart5,
    '--color-chart-1': (ThemeTokens t) => t.chart1,
    '--color-chart-2': (ThemeTokens t) => t.chart2,
    '--color-chart-3': (ThemeTokens t) => t.chart3,
    '--color-chart-4': (ThemeTokens t) => t.chart4,
    '--color-chart-5': (ThemeTokens t) => t.chart5,
  };

  /// Every registered custom-property name.
  static Iterable<String> get names => _tokens.keys;

  /// Whether [cssName] is registered: the guard a widget checks before asking
  /// for a value, so a typo renders the web's own `—` placeholder instead of
  /// crashing a docs page.
  static bool has(String cssName) => _tokens.containsKey(cssName);

  /// The live [Color] for [cssName] in [theme].
  ///
  /// Resolution goes through the package's own token objects: the same
  /// [ThemeTokens] fields a button paints with. It deliberately does NOT parse
  /// [printedValue]: the printed text is documentation, and documentation that
  /// feeds back into rendering is how a docs page starts lying.
  static Color resolve(String cssName, ThemeTokens theme) =>
      _require(cssName)(theme);

  /// The text `getComputedStyle().getPropertyValue(cssName)` returns under
  /// [kind]: the compiled stylesheet's shortest-hex form, not the `hsl()` the
  /// stylesheet source authors. See [elCssColorText].
  static String printedValue(String cssName, ResolvedColorMode kind) =>
      elCssColorText(resolve(cssName, themeOf(kind)));

  /// The theme block [kind] selects, `.dark` or `:root, .light`.
  static ThemeTokens themeOf(ResolvedColorMode kind) =>
      kind == ResolvedColorMode.dark ? ThemeTokens.dark : ThemeTokens.light;

  /// The measured ratio of [cssName] against [against] in [theme]: the port of
  /// `useContrast`.
  static double contrastRatio(
    String cssName,
    ThemeTokens theme, {
    String against = _defaultAgainst,
  }) => elContrastRatio(resolve(cssName, theme), resolve(against, theme));

  static _DsToken _require(String cssName) {
    final _DsToken? token = _tokens[cssName];
    if (token == null) {
      throw ArgumentError.value(
        cssName,
        'cssName',
        'Not a registered design token. Add it to TokenRegistry with the '
            'ThemeTokens field the theme blocks resolve it to.',
      );
    }
    return token;
  }
}

/// `ContrastBadge`'s default: everything is measured against the page.
const String _defaultAgainst = '--background';

/// What the web renders when `getPropertyValue` comes back empty: and, before
/// hydration, for every token. Flutter has no hydration gap, so here it means
/// only one thing: the token is not registered.
const String _unresolved = '—';

// ─────────────────────────────────────────────────────────────────────────────
// Widgets
// ─────────────────────────────────────────────────────────────────────────────

/// The token's value as the stylesheet spells it, `TokenValue`.
///
/// `span.type-num-sm.text-muted-foreground`.
class TokenValue extends StatelessWidget {
  const TokenValue(this.token, {super.key});

  /// The CSS custom-property name, e.g. `--muted-foreground`.
  final String token;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final String value = TokenRegistry.has(token)
        ? TokenRegistry.printedValue(token, theme.kind)
        : _unresolved;
    return StyledText(value, TextStyles.numberSm, color: theme.mutedForeground);
  }
}

/// The measured ratio and its verdict, `ContrastBadge`.
///
/// `span.type-micro.text-muted-foreground` with only the verdict word tinted,
/// so it is one [Text.rich] rather than a [Row]: the verdict has to wrap with
/// the sentence, not beside it.
///
/// `.type-micro` uppercases, and `text-transform` is inherited, so the WHOLE
/// badge renders in caps, `CONTRAST 13.5:1 · AAA`. [elContrastBadgeText] is
/// the authored casing; this widget paints its uppercase.
class ContrastBadge extends StatelessWidget {
  const ContrastBadge(this.token, {super.key, this.against = _defaultAgainst});

  /// The token being measured.
  final String token;

  /// The surface it is measured on. Defaults to `--background`, the page.
  final String against;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    if (!TokenRegistry.has(token) || !TokenRegistry.has(against)) {
      return StyledText(
        _unresolved,
        TextStyles.eyebrowSmall,
        color: theme.mutedForeground,
      );
    }

    final double ratio = TokenRegistry.contrastRatio(
      token,
      theme,
      against: against,
    );

    // `.type-micro` sets its own colour, so the sentence needs no override; the
    // verdict span is the one place the markup writes a `text-*` utility.
    final TextStyle sentence = StyledText.styleOf(
      context,
      TextStyles.eyebrowSmall,
    );
    final TextStyle verdict = StyledText.styleOf(
      context,
      TextStyles.eyebrowSmall,
      color: elContrastVerdictColor(ratio, theme),
    );

    String cased(String text) =>
        TextStyles.eyebrowSmall.uppercase ? text.toUpperCase() : text;

    return RichText(
      TextSpan(
        style: sentence,
        children: <InlineSpan>[
          TextSpan(text: cased(elContrastBadgePrefix(ratio))),
          TextSpan(text: cased(elContrastVerdict(ratio)), style: verdict),
        ],
      ),
      TextStyles.eyebrowSmall,
    );
  }
}

/// One documented token: painted, named, valued and measured, `TokenSwatch`.
///
/// `grid items-center gap-4 p-4 sm:grid-cols-[5.5rem_minmax(0,13rem)_1fr]
/// sm:gap-6`. Below `sm` the three cells stack in one column at 16px gaps;
/// from `sm` up they are a row of 88px / 208px / flex at 24px gaps.
///
/// The two fixed tracks are written through [space] rather than as pixels:
/// Tailwind's `--spacing` unit is 4px, so `5.5rem` is `space(22)` and `13rem` is
/// `space(52)`: the same arithmetic the framework does, kept in the same
/// vocabulary as every other measure on the page.
class TokenSwatch extends StatelessWidget {
  const TokenSwatch({
    super.key,
    required this.token,
    required this.name,
    required this.use,
    this.measure = true,
  });

  /// The CSS custom-property name: painted, printed, and named in the row.
  final String token;

  /// The human label, `p.type-h4.text-foreground`.
  final String name;

  /// What the token is for, `p.type-small.text-muted-foreground`.
  final String use;

  /// Off for tints and fills that never carry text: `--background`, `--card`,
  /// `--muted`, `--accent`. A ratio for a colour nothing is ever written in is
  /// a number without a question.
  final bool measure;

  /// `sm:grid-cols-[5.5rem_…]`, 5.5rem = 88px.
  static final double _swatchTrack = space(22);

  /// `minmax(0, 13rem)`, 13rem = 208px, the middle track's cap.
  static final double _nameTrack = space(52);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final bool wide = MediaQuery.sizeOf(context).width >= Breakpoints.sm;

    // `h-16 sm:h-14`, 64px, tightening to 56px once the row goes horizontal.
    final Widget swatch = SizedBox(
      height: wide ? space(14) : space(16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: TokenRegistry.has(token)
              ? TokenRegistry.resolve(token, theme)
              : transparent,
          borderRadius: BorderRadius.circular(Radii.lg),
          // No child to inset: the swatch *is* the colour, and the hairline
          // only has to keep a white card visible on a white background.
          border: Border.all(color: theme.input, width: BorderWidths.hairline),
        ),
      ),
    );

    final Widget identity = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText(name, TextStyles.h4, color: theme.foreground),
        SizedBox(height: space(1)), // `mt-1`
        TokenValue(token),
        SizedBox(height: space(1)), // `mt-1`
        StyledText(token, TextStyles.numberSm, color: theme.actionText),
      ],
    );

    final Widget purpose = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText(use, TextStyles.small, color: theme.mutedForeground),
        if (measure) ...<Widget>[
          SizedBox(height: space(2)), // `mt-2`
          ContrastBadge(token),
        ],
      ],
    );

    return Padding(
      padding: EdgeInsets.all(space(4)), // `p-4`
      child: wide
          ? Row(
              // `items-center`.
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: _swatchTrack, child: swatch),
                SizedBox(width: space(6)), // `sm:gap-6`
                SizedBox(width: _nameTrack, child: identity),
                SizedBox(width: space(6)),
                Expanded(child: purpose), // `1fr`
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                swatch,
                SizedBox(height: space(4)), // `gap-4`
                identity,
                SizedBox(height: space(4)),
                purpose,
              ],
            ),
    );
  }
}

/// The card the swatches sit in, `TokenSwatchList`.
///
/// `divide-y divide-border overflow-hidden rounded-xl border border-border
/// bg-card`: a 16px card with a 1px hairline BETWEEN rows and none before the
/// first or after the last, which is what `divide-y` means and what a naive
/// bottom-border-per-row gets wrong.
class TokenSwatchList extends StatelessWidget {
  const TokenSwatchList({super.key, required this.rows});

  /// The rows, normally [TokenSwatch]es.
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    final List<Widget> children = <Widget>[];
    for (int i = 0; i < rows.length; i++) {
      if (i > 0) {
        // `divide-y divide-border`: one hairline per GAP, not per row.
        children.add(
          Container(height: BorderWidths.hairline, color: theme.border),
        );
      }
      children.add(rows[i]);
    }

    return Container(
      // `overflow-hidden`: the corners clip the first and last row.
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(Radii.xl),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
