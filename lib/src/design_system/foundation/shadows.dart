/// Elevation owned by the Flutter design system.
///
/// Two families. `e1`–`e4` are ambient depth. The rest are MACHINE surfaces:
/// things that look like they can be physically pressed — which is why a button
/// here carries an inner top highlight and an inner bottom shade rather than a
/// flat fill.
///
/// **The geometry is fixed; the ink is not.** Every colour below is an
/// `--ink-*` / `--rim` / `--wall` variable that the theme blocks set, so each
/// layer stores a `Color Function(ThemeTokens)` rather than a colour. Light
/// mode gets weaker, cooler, tighter ink and an inverted rim — same shapes,
/// same names, same components.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import './colors.dart';
import './theme.dart';

/// One layered shadow specification:
/// `[inset] <dx> <dy> <blur> <spread> <color>`.
///
/// The four numbers retain the original design geometry. Conversion to
/// Flutter's Skia blur model happens in [blurRadius].
@immutable
class ShadowLayer {
  const ShadowLayer(
    this.dx,
    this.dy,
    this.blur,
    this.spread,
    this.color, {
    this.inset = false,
  });

  /// CSS `offset-x`.
  final double dx;

  /// CSS `offset-y`.
  final double dy;

  /// CSS `blur-radius`. Per the CSS spec this is **twice** the Gaussian sigma.
  final double blur;

  /// CSS `spread-radius`. Maps 1:1 onto [BoxShadow.spreadRadius].
  final double spread;

  /// Resolved against the live theme — the whole point of the ink family.
  final Color Function(ThemeTokens) color;

  /// CSS `inset` keyword. Flutter has no inset-shadow primitive; these layers
  /// are painted by `Surface` (effects layer) instead of [BoxShadow].
  final bool inset;

  Offset get offset => Offset(dx, dy);

  /// The [BoxShadow.blurRadius] that reproduces the CSS blur.
  ///
  /// **Recorded decision.** CSS defines its blur as "a Gaussian blur with a
  /// standard deviation equal to half the blur radius" → `sigma = blur / 2`.
  /// Flutter derives sigma from the radius the other way round, via
  /// `Shadow.convertRadiusToSigma(r) = r * 0.57735 + 0.5` (and `0` for `r <= 0`).
  /// Passing the CSS blur straight through would inflate every halo by ~19%
  /// (a 28px CSS blur would render at sigma 16.67 instead of 14), which is
  /// visible in a side-by-side of `e4`. So invert Flutter's formula instead.
  ///
  /// Known limit: Flutter's `+0.5` offset makes sigmas below 0.5 unreachable,
  /// so a CSS blur of 1px or less collapses to a hard edge. That affects only
  /// the 1px contact layers of `e1`.
  double get blurRadius {
    if (blur <= 0) return 0;
    final double sigma = blur / 2;
    final double radius = (sigma - 0.5) / 0.57735;
    return radius > 0 ? radius : 0;
  }

  BoxShadow toBoxShadow(ThemeTokens theme) => BoxShadow(
    color: color(theme),
    offset: offset,
    blurRadius: blurRadius,
    spreadRadius: spread,
  );
}

/// A complete `--shadow-*` token: an ordered list of layers, painted
/// bottom-most last exactly as CSS paints a comma-separated `box-shadow`.
@immutable
class ShadowStyle {
  const ShadowStyle(this.layers);

  final List<ShadowLayer> layers;

  /// The non-`inset` layers, ready for `BoxDecoration.boxShadow`.
  ///
  /// CSS paints the first-listed shadow on top; Flutter paints
  /// `BoxDecoration.boxShadow` in list order, first-painted therefore
  /// bottom-most. The list is reversed so the stacking order matches.
  List<BoxShadow> outerShadows(ThemeTokens theme) => <BoxShadow>[
    for (final ShadowLayer layer in layers.reversed)
      if (!layer.inset) layer.toBoxShadow(theme),
  ];

  /// The `inset` layers, for `Surface` to paint inside the shape.
  List<ShadowLayer> get insetLayers => <ShadowLayer>[
    for (final ShadowLayer l in layers)
      if (l.inset) l,
  ];

  bool get hasInset => layers.any((ShadowLayer l) => l.inset);
}

// ── Ink resolvers ───────────────────────────────────────────────────────────
// Named functions rather than closures so every spec below reads like the CSS.

Color _ink1(ThemeTokens t) => t.ink1;
Color _ink2(ThemeTokens t) => t.ink2;
Color _ink3(ThemeTokens t) => t.ink3;
Color _ink4(ThemeTokens t) => t.ink4;
Color _rim(ThemeTokens t) => t.rim;
Color _rimStrong(ThemeTokens t) => t.rimStrong;
Color _wall(ThemeTokens t) => t.wall;

/// `color-mix(in oklab, <ramp> N%, transparent)` — mixing toward `transparent`
/// in premultiplied oklab preserves the hue and scales alpha, so it resolves to
/// the ramp colour at N% alpha (design spec §3).
Color _actionAt(double alpha) => Palette.action.withValues(alpha: alpha);
Color _actionBrightAt(double alpha) =>
    Palette.actionBright.withValues(alpha: alpha);
Color _valueAt(double alpha) => Palette.value.withValues(alpha: alpha);

/// Neutral overlay ink used by compatibility elevations in both themes.
Color _overlayShadowInk(ThemeTokens t) => const Color(0x1A000000);

/// Every `--shadow-*` token in `app/globals.css` L354–387.
class Shadows {
  const Shadows._();

  /// `box-shadow: none` — an empty layer list.
  ///
  /// Not a token in globals.css; it is the absence of one, named so that a
  /// component with no elevation can still say which spec it paints instead
  /// of special-casing null.
  static const ShadowStyle none = ShadowStyle(<ShadowLayer>[]);

  /// Elevation for large overlay panels such as sheets and menus.
  static const ShadowStyle overlay = ShadowStyle(<ShadowLayer>[
    ShadowLayer(0, 10, 15, -3, _overlayShadowInk),
    ShadowLayer(0, 4, 6, -4, _overlayShadowInk),
  ]);

  /// Elevation for compact anchored surfaces such as popovers and selects.
  static const ShadowStyle popover = ShadowStyle(<ShadowLayer>[
    ShadowLayer(0, 4, 6, -1, _overlayShadowInk),
    ShadowLayer(0, 2, 4, -2, _overlayShadowInk),
  ]);

  /// Strong elevation for data-rich transient surfaces such as chart
  /// tooltips.
  static const ShadowStyle dataTooltip = ShadowStyle(<ShadowLayer>[
    ShadowLayer(0, 20, 25, -5, _overlayShadowInk),
    ShadowLayer(0, 8, 10, -6, _overlayShadowInk),
  ]);

  /// Subtle elevation for floating navigation and inset application shells.
  static const ShadowStyle floatingPanel = ShadowStyle(<ShadowLayer>[
    ShadowLayer(0, 1, 3, 0, _overlayShadowInk),
    ShadowLayer(0, 1, 2, -1, _overlayShadowInk),
  ]);

  /// `--shadow-e1: 0 1px 1px var(--ink-2), 0 1px 3px var(--ink-1)`
  static const ShadowStyle sm = ShadowStyle(<ShadowLayer>[
    ShadowLayer(0, 1, 1, 0, _ink2),
    ShadowLayer(0, 1, 3, 0, _ink1),
  ]);

  /// `--shadow-e2: 0 1px 2px var(--ink-2), 0 4px 10px -2px var(--ink-2)`
  static const ShadowStyle md = ShadowStyle(<ShadowLayer>[
    ShadowLayer(0, 1, 2, 0, _ink2),
    ShadowLayer(0, 4, 10, -2, _ink2),
  ]);

  /// `--shadow-e3: 0 2px 4px var(--ink-2), 0 14px 28px -8px var(--ink-3)`
  static const ShadowStyle lg = ShadowStyle(<ShadowLayer>[
    ShadowLayer(0, 2, 4, 0, _ink2),
    ShadowLayer(0, 14, 28, -8, _ink3),
  ]);

  /// `--shadow-e4: 0 4px 8px var(--ink-3), 0 28px 56px -14px var(--ink-4)`
  static const ShadowStyle xl = ShadowStyle(<ShadowLayer>[
    ShadowLayer(0, 4, 8, 0, _ink3),
    ShadowLayer(0, 28, 56, -14, _ink4),
  ]);

  /// `--shadow-key: 0 4px 0 var(--wall), 0 7px 12px var(--ink-3)`
  /// Raised key with a side wall — travels down into its socket when pressed.
  static const ShadowStyle keyRaised = ShadowStyle(<ShadowLayer>[
    ShadowLayer(0, 4, 0, 0, _wall),
    ShadowLayer(0, 7, 12, 0, _ink3),
  ]);

  /// `--shadow-key-down: 0 1px 0 var(--wall), inset 0 2px 5px var(--ink-3)`
  static const ShadowStyle keyPressed = ShadowStyle(<ShadowLayer>[
    ShadowLayer(0, 1, 0, 0, _wall),
    ShadowLayer(0, 2, 5, 0, _ink3, inset: true),
  ]);

  /// `--shadow-pressed: inset 0 2px 5px var(--ink-3), inset 0 1px 2px var(--ink-4)`
  /// Sunken socket. Inputs sit in one of these.
  static const ShadowStyle inset = ShadowStyle(<ShadowLayer>[
    ShadowLayer(0, 2, 5, 0, _ink3, inset: true),
    ShadowLayer(0, 1, 2, 0, _ink4, inset: true),
  ]);

  /// `--shadow-btn: inset 0 1px 0 var(--rim), inset 0 -2px 4px var(--ink-2),`
  /// `0 1px 2px var(--ink-2), 0 3px 8px -2px var(--ink-2)`
  static const ShadowStyle control = ShadowStyle(<ShadowLayer>[
    ShadowLayer(0, 1, 0, 0, _rim, inset: true),
    ShadowLayer(0, -2, 4, 0, _ink2, inset: true),
    ShadowLayer(0, 1, 2, 0, _ink2),
    ShadowLayer(0, 3, 8, -2, _ink2),
  ]);

  /// `--shadow-btn-primary: inset 0 1px 0 var(--rim-strong),`
  /// `inset 0 -2px 5px var(--ink-2), 0 1px 2px var(--ink-2),`
  /// `0 4px 10px -2px color-mix(in oklab, var(--color-action) 55%, transparent)`
  static final ShadowStyle controlPrimary = ShadowStyle(<ShadowLayer>[
    const ShadowLayer(0, 1, 0, 0, _rimStrong, inset: true),
    const ShadowLayer(0, -2, 5, 0, _ink2, inset: true),
    const ShadowLayer(0, 1, 2, 0, _ink2),
    ShadowLayer(0, 4, 10, -2, (_) => _actionAt(0.55)),
  ]);

  /// `--shadow-btn-value: inset 0 1px 0 var(--rim-strong),`
  /// `inset 0 -2px 5px var(--ink-1), 0 1px 2px var(--ink-2),`
  /// `0 4px 10px -2px color-mix(in oklab, var(--color-value) 45%, transparent)`
  static final ShadowStyle controlPremium = ShadowStyle(<ShadowLayer>[
    const ShadowLayer(0, 1, 0, 0, _rimStrong, inset: true),
    const ShadowLayer(0, -2, 5, 0, _ink1, inset: true),
    const ShadowLayer(0, 1, 2, 0, _ink2),
    ShadowLayer(0, 4, 10, -2, (_) => _valueAt(0.45)),
  ]);

  /// `--shadow-btn-down: inset 0 2px 4px var(--ink-3), 0 1px 1px var(--ink-1)`
  static const ShadowStyle controlPressed = ShadowStyle(<ShadowLayer>[
    ShadowLayer(0, 2, 4, 0, _ink3, inset: true),
    ShadowLayer(0, 1, 1, 0, _ink1),
  ]);

  /// `--shadow-chip: inset 0 1px 0 var(--rim), inset 0 -1px 2px var(--ink-2),`
  /// `0 1px 2px var(--ink-2)`
  static const ShadowStyle compactControl = ShadowStyle(<ShadowLayer>[
    ShadowLayer(0, 1, 0, 0, _rim, inset: true),
    ShadowLayer(0, -1, 2, 0, _ink2, inset: true),
    ShadowLayer(0, 1, 2, 0, _ink2),
  ]);

  /// `--shadow-glow-action:`
  /// `0 0 0 1px color-mix(in oklab, var(--color-action-bright) 45%, transparent),`
  /// `0 10px 34px -8px color-mix(in oklab, var(--color-action) 60%, transparent)`
  /// Rationed glow — selection and reward only.
  static final ShadowStyle glowAction = ShadowStyle(<ShadowLayer>[
    ShadowLayer(0, 0, 0, 1, (_) => _actionBrightAt(0.45)),
    ShadowLayer(0, 10, 34, -8, (_) => _actionAt(0.60)),
  ]);

  /// `--shadow-glow-value:`
  /// `0 0 0 1px color-mix(in oklab, var(--color-value) 45%, transparent),`
  /// `0 10px 34px -8px color-mix(in oklab, var(--color-value) 42%, transparent)`
  static final ShadowStyle glowValue = ShadowStyle(<ShadowLayer>[
    ShadowLayer(0, 0, 0, 1, (_) => _valueAt(0.45)),
    ShadowLayer(0, 10, 34, -8, (_) => _valueAt(0.42)),
  ]);

  /// `@keyframes pulls-pulse-live` (globals.css L2521–2530) — the expanding
  /// ring under a live control, sampled at [t] through one half of its cycle.
  ///
  /// ```css
  /// 0%, 100% { box-shadow: 0 0 0 0   rgba(61, 220, 151, 0.5); }
  /// 50%      { box-shadow: 0 0 0 5px rgba(61, 220, 151, 0);   }
  /// ```
  ///
  /// A **function** rather than a constant because this token only exists as
  /// two keyframe stops: there is no resting `--shadow-pulse-live` to name, and
  /// a caller animating it needs the value in between. [t] is 0 at either end
  /// of the cycle and 1 at the midpoint, already eased.
  ///
  /// The green is the reference's own literal. It is written inline in the
  /// keyframe and points at nothing in `:root` — it is not `--color-success`
  /// (`#10b981`) or any other member of the palette — so it is transcribed
  /// here, in the one layer allowed to hold a literal, rather than laundered
  /// into a token the stylesheet does not have.
  static ShadowStyle pulseLiveRing(double t) => ShadowStyle(<ShadowLayer>[
    ShadowLayer(
      0,
      0,
      0,
      _pulseLiveSpread * t,
      (_) => _pulseLiveInk.withValues(alpha: _pulseLiveAlpha * (1 - t)),
    ),
  ]);

  /// `rgba(61, 220, 151, …)`.
  static const Color _pulseLiveInk = Color(0xFF3DDC97);

  /// The ring's alpha at the top of the cycle.
  static const double _pulseLiveAlpha = 0.5;

  /// `0 0 0 0` → `0 0 0 5px`.
  static const double _pulseLiveSpread = 5;
}
