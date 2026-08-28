/// Raw colour of the design system — the ramps, the state hues, and the colour
/// maths the reference stylesheet performs in CSS.
///
/// Source of truth: `app/globals.css` in the reference repo
/// (`D:/DESIGN/Design-System-2026-8/design-system/app/globals.css`).
/// Line references in this file point at that stylesheet.
///
/// This file and its siblings under `lib/src/foundation/` are the ONLY place in
/// the package where a literal is allowed; `test/token_guard_test.dart` enforces
/// that. Every doc comment carries the CSS declaration it transcribes, so the
/// file reads as a transcript rather than as a set of choices.
library;

import 'dart:math' as math;
import 'dart:ui' show Color;

// ─────────────────────────────────────────────────────────────────────────────
// hsl()
// ─────────────────────────────────────────────────────────────────────────────

/// CSS `hsl(h s% l% / a)` — the exact conversion a browser rasterises.
///
/// [h] is degrees (wrapped), [s] and [l] are percentages `0..100`, [a] is a
/// straight alpha `0..1`. Channels are rounded the way CSS serialises them —
/// `round(x * 255)` on the `0..1` float — which is why `hsl(213 94% 78%)` lands
/// on `#92C2FC` and not on the `#93C5FD` the stylesheet's comment claimed for
/// three brands (globals.css L99–105; the hsl values are authoritative).
///
/// Alpha is kept as a straight (non-premultiplied) double and is NOT quantised:
/// `hsl(240 20% 20% / 0.04)` stays 0.04, never a pre-composited opaque colour.
Color hslColor(double h, double s, double l, [double a = 1]) {
  final double sat = s / 100;
  final double lig = l / 100;

  final double c = (1 - (2 * lig - 1).abs()) * sat;
  final double hp = (h % 360) / 60;
  final double x = c * (1 - (hp % 2 - 1).abs());
  final double m = lig - c / 2;

  final double r;
  final double g;
  final double b;
  if (hp < 1) {
    r = c;
    g = x;
    b = 0;
  } else if (hp < 2) {
    r = x;
    g = c;
    b = 0;
  } else if (hp < 3) {
    r = 0;
    g = c;
    b = x;
  } else if (hp < 4) {
    r = 0;
    g = x;
    b = c;
  } else if (hp < 5) {
    r = x;
    g = 0;
    b = c;
  } else {
    r = c;
    g = 0;
    b = x;
  }

  return Color.from(
    alpha: a,
    red: _to8Bit(r + m),
    green: _to8Bit(g + m),
    blue: _to8Bit(b + m),
  );
}

/// CSS's channel serialisation: clamp to `0..1`, then `round(x * 255) / 255`.
/// Going through the 8-bit grid is what makes [hslColor] agree with the hexes read
/// off the live page, and what makes two tokens spelled the same compare equal.
double _to8Bit(double channel) => (channel.clamp(0, 1) * 255).round() / 255;

/// A hex literal from the stylesheet, e.g. `#a3e635` → `_hex(0xFFA3E635)`.
Color _hex(int argb) => Color(argb);

/// CSS `transparent` — `rgb(0 0 0 / 0)`.
///
/// Legal everywhere in the package (the token guard exempts it by name): it is
/// the absence of a colour, not a colour choice.
const Color transparent = Color(0x00000000);

// ─────────────────────────────────────────────────────────────────────────────
// OKLab / OKLCH
// ─────────────────────────────────────────────────────────────────────────────

/// The colour maths `globals.css` performs in CSS and Flutter has no primitive
/// for: `color-mix(in oklab, …)` and `oklch(from … )` relative colours.
///
/// Both are pervasive in the reference — every glow, wash, rim and bloom stop
/// goes through one of them (globals-map §10.1–10.2) — so they are computed
/// here rather than eyeballed into hex.
class OklabColor {
  /// CSS `color-mix(in oklab, [a] `tA`%, [b])`.
  ///
  /// [tA] is the weight of [a] in `0..1` (CSS puts the percentage on the first
  /// colour). Interpolation is done on **premultiplied** OKLab components, as
  /// the CSS Color 5 spec requires, with alpha interpolated separately.
  ///
  /// Two results are produced analytically rather than through the round trip,
  /// because the round trip would only add float noise to an exact answer:
  /// * an endpoint (`tA` at 0 or 1) returns that operand untouched;
  /// * mixing toward a fully transparent colour — the `color-mix(in oklab, X
  ///   45%, transparent)` form used by `--shadow-glow-action` and friends
  ///   (globals.css L382–387) — returns X at `45%` of its own alpha, which is
  ///   what premultiplied mixing works out to when the other side contributes
  ///   nothing.
  static Color mix(Color a, Color b, double tA) {
    if (tA >= 1) return a;
    if (tA <= 0) return b;
    if (a == b) return a;
    if (b.a == 0) return a.withValues(alpha: a.a * tA);
    if (a.a == 0) return b.withValues(alpha: b.a * (1 - tA));

    final double tB = 1 - tA;
    final _Oklab la = _Oklab.fromColor(a);
    final _Oklab lb = _Oklab.fromColor(b);

    // Premultiply by alpha, lerp, then un-premultiply by the mixed alpha.
    final double alpha = a.a * tA + b.a * tB;
    final double wa = a.a * tA / alpha;
    final double wb = b.a * tB / alpha;

    return _Oklab(
      la.l * wa + lb.l * wb,
      la.a * wa + lb.a * wb,
      la.b * wa + lb.b * wb,
    ).toColor(alpha: alpha);
  }

  /// Reads [color] as OKLCH: lightness `0..1`, chroma, hue in degrees `0..360`.
  static ({double l, double c, double h}) toOklch(Color color) {
    final _Oklab lab = _Oklab.fromColor(color);
    final double c = math.sqrt(lab.a * lab.a + lab.b * lab.b);
    double h = math.atan2(lab.b, lab.a) * 180 / math.pi;
    if (h < 0) h += 360;
    return (l: lab.l, c: c, h: h);
  }

  /// CSS `oklch(l c h / alpha)`, gamut-mapped into sRGB.
  ///
  /// **Gamut mapping — chroma reduction** (the recorded project decision):
  /// if `(l, c, h)` converts to a linear-sRGB triple with any channel outside
  /// `[0, 1]`, chroma is binary-searched downward toward 0 with lightness and
  /// hue held fixed, for the largest chroma that still fits; the residual
  /// per-channel error left by the search (< 1e-5) is then clamped away.
  /// Reducing chroma — rather than clipping channels — is what keeps the hue
  /// from swinging when a requested colour is too saturated to exist, which is
  /// exactly the case for `--bubble-tinted` on light (L 0.93 at 40% of the
  /// action ramp's chroma is well outside sRGB).
  static Color fromOklch(double l, double c, double h, {double alpha = 1}) {
    final double rad = h * math.pi / 180;
    final double cos = math.cos(rad);
    final double sin = math.sin(rad);

    _Oklab at(double chroma) => _Oklab(l, chroma * cos, chroma * sin);
    if (at(c).fitsSrgb) return at(c).toColor(alpha: alpha);

    double lo = 0;
    double hi = c;
    for (int i = 0; i < 32; i++) {
      final double mid = (lo + hi) / 2;
      if (at(mid).fitsSrgb) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    return at(lo).toColor(alpha: alpha);
  }

  /// CSS relative colour syntax: `oklch(from [source] <l> calc(c * K) h)`.
  ///
  /// [source] is read as OKLCH; [lightness] replaces `l` outright, [chromaScale]
  /// is the `K` in `calc(c * K)`, and the hue is carried over unless [hue]
  /// overrides it. The result is gamut-mapped by [fromOklch].
  ///
  /// This is how `--bubble-tinted` / `--bubble-tinted-hover` are defined in both
  /// theme blocks (globals.css L602–603 light, L811–812 dark) — derived from
  /// `--primary` so they follow a rebrand, which is why they are computed here
  /// instead of frozen into two hexes.
  static Color fromOklchRelative(
    Color source, {
    required double lightness,
    required double chromaScale,
    double? hue,
    double? alpha,
  }) {
    final ({double l, double c, double h}) from = toOklch(source);
    return fromOklch(
      lightness,
      from.c * chromaScale,
      hue ?? from.h,
      alpha: alpha ?? source.a,
    );
  }
}

/// Björn Ottosson's OKLab, with the sRGB transfer function on either side.
class _Oklab {
  const _Oklab(this.l, this.a, this.b);

  factory _Oklab.fromColor(Color color) {
    final double r = _linear(color.r);
    final double g = _linear(color.g);
    final double b = _linear(color.b);

    final double lc = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b;
    final double mc = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b;
    final double sc = 0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b;

    final double l = _cbrt(lc);
    final double m = _cbrt(mc);
    final double s = _cbrt(sc);

    return _Oklab(
      0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s,
      1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s,
      0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s,
    );
  }

  final double l;
  final double a;
  final double b;

  /// Linear sRGB, before the transfer function and before any clamping — the
  /// triple the gamut test looks at.
  (double, double, double) get _linearSrgb {
    final double lc = l + 0.3963377774 * a + 0.2158037573 * b;
    final double mc = l - 0.1055613458 * a - 0.0638541728 * b;
    final double sc = l - 0.0894841775 * a - 1.2914855480 * b;

    final double l3 = lc * lc * lc;
    final double m3 = mc * mc * mc;
    final double s3 = sc * sc * sc;

    return (
      4.0767416621 * l3 - 3.3077115913 * m3 + 0.2309699292 * s3,
      -1.2684380046 * l3 + 2.6097574011 * m3 - 0.3413193965 * s3,
      -0.0041960863 * l3 - 0.7034186147 * m3 + 1.7076147010 * s3,
    );
  }

  /// True when the colour exists in sRGB — no channel outside `[0, 1]` beyond
  /// the tolerance the binary search leaves behind.
  bool get fitsSrgb {
    const double epsilon = 0.00001;
    final (double r, double g, double b) = _linearSrgb;
    return r >= -epsilon &&
        r <= 1 + epsilon &&
        g >= -epsilon &&
        g <= 1 + epsilon &&
        b >= -epsilon &&
        b <= 1 + epsilon;
  }

  Color toColor({double alpha = 1}) {
    final (double r, double g, double b) = _linearSrgb;
    return Color.from(
      alpha: alpha,
      red: _gamma(r).clamp(0, 1),
      green: _gamma(g).clamp(0, 1),
      blue: _gamma(b).clamp(0, 1),
    );
  }

  /// sRGB → linear light.
  static double _linear(double c) =>
      c <= 0.04045 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();

  /// Linear light → sRGB.
  static double _gamma(double c) => c <= 0.0031308
      ? 12.92 * c
      : 1.055 * math.pow(c, 1 / 2.4).toDouble() - 0.055;

  /// Sign-preserving cube root — the LMS values can go slightly negative for
  /// colours near the gamut edge.
  static double _cbrt(double x) =>
      x < 0 ? -math.pow(-x, 1 / 3).toDouble() : math.pow(x, 1 / 3).toDouble();
}

// ─────────────────────────────────────────────────────────────────────────────
// The ramps — `@theme static`, globals.css L71–433
// ─────────────────────────────────────────────────────────────────────────────

/// The raw palette: two brand ramps and the state hues.
///
/// Theme-independent by definition — these are the colours themselves, and
/// nothing here flips between light and dark. Which END of a ramp carries a
/// glyph is a per-theme answer and lives on `ThemeTokens.actionText` / `premiumText`
/// (globals.css L586–594 / L782–802).
///
/// "Three blues, three limes. Nothing else. Monochrome comes from zinc via the
/// shadcn semantic tokens" (L81–83).
class Palette {
  /// `--color-action-bright: hsl(213 94% 78%)` — globals.css L103. Ink on dark.
  /// Rasterises `#92C2FC`.
  static final Color actionBright = hslColor(213, 94, 78);

  /// `--color-action: hsl(217 91% 53%)` — globals.css L104. The fill.
  /// Rasterises `#1A6EF4`.
  static final Color action = hslColor(217, 91, 53);

  /// `--color-action-dark: hsl(224 76% 33%)` — globals.css L105. Ink on light.
  /// Rasterises `#143694`.
  static final Color actionDark = hslColor(224, 76, 33);

  /// `--color-value-bright: #d9f99d` — globals.css L107. Lime, lifted.
  static final Color valueBright = _hex(0xFFD9F99D);

  /// `--color-value: #a3e635` — globals.css L108. Lime, the fill.
  static final Color value = _hex(0xFFA3E635);

  /// `--color-value-dark: #4d7c0f` — globals.css L109. Lime, ink on light.
  static final Color valueDark = _hex(0xFF4D7C0F);

  /// `--color-value-foreground: hsl(240 10% 8%)` — globals.css L127.
  ///
  /// The one foreground in this system that deliberately does NOT flip with the
  /// theme: the value foil is an opaque metal ramp, the same lime on a white
  /// page as on a black one, so its label has to be dark in both (L111–126).
  static final Color valueForeground = hslColor(240, 10, 8);

  /// `--color-success: #10b981` — globals.css L148. Emerald 500.
  static final Color success = _hex(0xFF10B981);

  /// `--color-warning: #fbbf24` — globals.css L149. Amber 400.
  static final Color warning = _hex(0xFFFBBF24);

  /// `--color-info: #22d3ee` — globals.css L150. Cyan 400.
  static final Color info = _hex(0xFF22D3EE);

  /// `--color-success-deep: #047857` — globals.css L158. Emerald 700.
  static final Color successDeep = _hex(0xFF047857);

  /// `--color-warning-deep: #b45309` — globals.css L159. Amber 700.
  static final Color warningDeep = _hex(0xFFB45309);

  /// `--color-info-deep: #0e7490` — globals.css L160. Cyan 700.
  static final Color infoDeep = _hex(0xFF0E7490);

  /// `--color-destructive-lifted: #f87171` — globals.css L164. Red 400, used
  /// only where destructive has to carry text.
  static final Color destructiveLifted = _hex(0xFFF87171);

  /// `--color-destructive-deep: hsl(0 72.2% 46%)` — globals.css L165.
  /// Light-theme ink on red washes.
  static final Color destructiveDeep = hslColor(0, 72.2, 46);
}
