/// Elevation — `app/globals.css` L340–387.
///
/// Two families. `e1`–`e4` are ambient depth. The rest are MACHINE surfaces:
/// things that look like they can be physically pressed — which is why a button
/// here carries an inner top highlight and an inner bottom shade rather than a
/// flat fill.
///
/// **The geometry is fixed; the ink is not.** Every colour below is an
/// `--ink-*` / `--rim` / `--wall` variable that the theme blocks set, so each
/// layer stores a `Color Function(DsThemeData)` rather than a colour. Light
/// mode gets weaker, cooler, tighter ink and an inverted rim — same shapes,
/// same names, same components.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'colors.dart';
import 'theme.dart';

/// One CSS `box-shadow` layer, in CSS units:
/// `[inset] <dx> <dy> <blur> <spread> <color>`.
///
/// The four numbers are the **raw CSS values**, so this class reads as a
/// transcript of globals.css. The CSS→Skia blur conversion happens in
/// [blurRadius], not here.
@immutable
class DsShadowLayer {
  const DsShadowLayer(
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
  final Color Function(DsThemeData) color;

  /// CSS `inset` keyword. Flutter has no inset-shadow primitive; these layers
  /// are painted by `DsMachineSurface` (effects layer) instead of [BoxShadow].
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

  BoxShadow toBoxShadow(DsThemeData theme) => BoxShadow(
        color: color(theme),
        offset: offset,
        blurRadius: blurRadius,
        spreadRadius: spread,
      );
}

/// A complete `--shadow-*` token: an ordered list of layers, painted
/// bottom-most last exactly as CSS paints a comma-separated `box-shadow`.
@immutable
class DsShadowSpec {
  const DsShadowSpec(this.layers);

  final List<DsShadowLayer> layers;

  /// The non-`inset` layers, ready for `BoxDecoration.boxShadow`.
  ///
  /// CSS paints the first-listed shadow on top; Flutter paints
  /// `BoxDecoration.boxShadow` in list order, first-painted therefore
  /// bottom-most. The list is reversed so the stacking order matches.
  List<BoxShadow> outerShadows(DsThemeData theme) => <BoxShadow>[
        for (final DsShadowLayer layer in layers.reversed)
          if (!layer.inset) layer.toBoxShadow(theme),
      ];

  /// The `inset` layers, for `DsMachineSurface` to paint inside the shape.
  List<DsShadowLayer> get insetLayers =>
      <DsShadowLayer>[for (final DsShadowLayer l in layers) if (l.inset) l];

  bool get hasInset => layers.any((DsShadowLayer l) => l.inset);
}

// ── Ink resolvers ───────────────────────────────────────────────────────────
// Named functions rather than closures so every spec below reads like the CSS.

Color _ink1(DsThemeData t) => t.ink1;
Color _ink2(DsThemeData t) => t.ink2;
Color _ink3(DsThemeData t) => t.ink3;
Color _ink4(DsThemeData t) => t.ink4;
Color _rim(DsThemeData t) => t.rim;
Color _rimStrong(DsThemeData t) => t.rimStrong;
Color _wall(DsThemeData t) => t.wall;

/// `color-mix(in oklab, <ramp> N%, transparent)` — mixing toward `transparent`
/// in premultiplied oklab preserves the hue and scales alpha, so it resolves to
/// the ramp colour at N% alpha (design spec §3).
Color _actionAt(double alpha) => DsPalette.action.withValues(alpha: alpha);
Color _actionBrightAt(double alpha) =>
    DsPalette.actionBright.withValues(alpha: alpha);
Color _valueAt(double alpha) => DsPalette.value.withValues(alpha: alpha);

/// Tailwind's own `shadow-lg` ink: `rgb(0 0 0 / 0.1)`, the same in both
/// themes because it is not part of the `--ink-*` family.
Color _tailwindShadowInk(DsThemeData t) => const Color(0x1A000000);

/// Every `--shadow-*` token in `app/globals.css` L354–387.
class DsShadows {
  const DsShadows._();

  /// `box-shadow: none` — an empty layer list.
  ///
  /// Not a token in globals.css; it is the absence of one, named so that a
  /// component with no elevation can still say which spec it paints instead
  /// of special-casing null.
  static const DsShadowSpec none = DsShadowSpec(<DsShadowLayer>[]);

  /// Tailwind's stock `shadow-lg`, carried because `SheetContent` asks for it
  /// by that name (`components/ui/sheet.tsx`) and `globals.css` never
  /// redeclares `--shadow-lg` — so the framework default is what renders.
  ///
  /// Deliberately outside the `e1`–`e4` ladder: it is not part of this
  /// system's elevation vocabulary, and calling it `e3` would launder a
  /// foreign value into the token set.
  static const DsShadowSpec tailwindLg = DsShadowSpec(<DsShadowLayer>[
    DsShadowLayer(0, 10, 15, -3, _tailwindShadowInk),
    DsShadowLayer(0, 4, 6, -4, _tailwindShadowInk),
  ]);

  /// Tailwind's stock `shadow-md`, carried for the same reason as
  /// [tailwindLg]: `SelectContent` asks for it by that name
  /// (`components/ui/select.tsx`) and `globals.css` never redeclares
  /// `--shadow-md`, so the framework default is what renders.
  ///
  /// `0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)`.
  ///
  /// DOCUMENTED DRIFT (forms-map drift 16): it is the only elevation on the
  /// forms page not drawn from the `--shadow-*` token set — fixed black at
  /// 10%, with no theme response at all, under a popover whose fill flips.
  static const DsShadowSpec tailwindMd = DsShadowSpec(<DsShadowLayer>[
    DsShadowLayer(0, 4, 6, -1, _tailwindShadowInk),
    DsShadowLayer(0, 2, 4, -2, _tailwindShadowInk),
  ]);

  /// Tailwind's stock `shadow-xl`, carried for the same reason as [tailwindLg]
  /// and [tailwindMd]: `ChartTooltipContent` asks for it by that name
  /// (`components/ui/chart.tsx` — `rounded-lg border border-border/50
  /// bg-background px-2.5 py-1.5 text-xs shadow-xl`) and `globals.css` never
  /// redeclares `--shadow-xl`, so the framework default is what renders.
  ///
  /// `0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)`.
  ///
  /// The third foreign elevation in the system, and the third one to arrive
  /// through a vendored shadcn component rather than through a design
  /// decision — which is why it stays outside the `e1`–`e4` ladder like the
  /// other two.
  static const DsShadowSpec tailwindXl = DsShadowSpec(<DsShadowLayer>[
    DsShadowLayer(0, 20, 25, -5, _tailwindShadowInk),
    DsShadowLayer(0, 8, 10, -6, _tailwindShadowInk),
  ]);

  /// Tailwind's stock `shadow-sm`, the fourth foreign elevation and the
  /// smallest: `Sidebar`'s `floating` variant lifts its panel with it
  /// (`group-data-[variant=floating]:shadow-sm`) and its `inset` variant lifts
  /// the **main column** with it (`md:peer-data-[variant=inset]:shadow-sm`).
  /// `globals.css` never redeclares `--shadow-sm`, so the framework default is
  /// what renders.
  ///
  /// `0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)`.
  static const DsShadowSpec tailwindSm = DsShadowSpec(<DsShadowLayer>[
    DsShadowLayer(0, 1, 3, 0, _tailwindShadowInk),
    DsShadowLayer(0, 1, 2, -1, _tailwindShadowInk),
  ]);

  /// `--shadow-e1: 0 1px 1px var(--ink-2), 0 1px 3px var(--ink-1)`
  static const DsShadowSpec e1 = DsShadowSpec(<DsShadowLayer>[
    DsShadowLayer(0, 1, 1, 0, _ink2),
    DsShadowLayer(0, 1, 3, 0, _ink1),
  ]);

  /// `--shadow-e2: 0 1px 2px var(--ink-2), 0 4px 10px -2px var(--ink-2)`
  static const DsShadowSpec e2 = DsShadowSpec(<DsShadowLayer>[
    DsShadowLayer(0, 1, 2, 0, _ink2),
    DsShadowLayer(0, 4, 10, -2, _ink2),
  ]);

  /// `--shadow-e3: 0 2px 4px var(--ink-2), 0 14px 28px -8px var(--ink-3)`
  static const DsShadowSpec e3 = DsShadowSpec(<DsShadowLayer>[
    DsShadowLayer(0, 2, 4, 0, _ink2),
    DsShadowLayer(0, 14, 28, -8, _ink3),
  ]);

  /// `--shadow-e4: 0 4px 8px var(--ink-3), 0 28px 56px -14px var(--ink-4)`
  static const DsShadowSpec e4 = DsShadowSpec(<DsShadowLayer>[
    DsShadowLayer(0, 4, 8, 0, _ink3),
    DsShadowLayer(0, 28, 56, -14, _ink4),
  ]);

  /// `--shadow-key: 0 4px 0 var(--wall), 0 7px 12px var(--ink-3)`
  /// Raised key with a side wall — travels down into its socket when pressed.
  static const DsShadowSpec key = DsShadowSpec(<DsShadowLayer>[
    DsShadowLayer(0, 4, 0, 0, _wall),
    DsShadowLayer(0, 7, 12, 0, _ink3),
  ]);

  /// `--shadow-key-down: 0 1px 0 var(--wall), inset 0 2px 5px var(--ink-3)`
  static const DsShadowSpec keyDown = DsShadowSpec(<DsShadowLayer>[
    DsShadowLayer(0, 1, 0, 0, _wall),
    DsShadowLayer(0, 2, 5, 0, _ink3, inset: true),
  ]);

  /// `--shadow-pressed: inset 0 2px 5px var(--ink-3), inset 0 1px 2px var(--ink-4)`
  /// Sunken socket. Inputs sit in one of these.
  static const DsShadowSpec pressed = DsShadowSpec(<DsShadowLayer>[
    DsShadowLayer(0, 2, 5, 0, _ink3, inset: true),
    DsShadowLayer(0, 1, 2, 0, _ink4, inset: true),
  ]);

  /// `--shadow-btn: inset 0 1px 0 var(--rim), inset 0 -2px 4px var(--ink-2),`
  /// `0 1px 2px var(--ink-2), 0 3px 8px -2px var(--ink-2)`
  static const DsShadowSpec btn = DsShadowSpec(<DsShadowLayer>[
    DsShadowLayer(0, 1, 0, 0, _rim, inset: true),
    DsShadowLayer(0, -2, 4, 0, _ink2, inset: true),
    DsShadowLayer(0, 1, 2, 0, _ink2),
    DsShadowLayer(0, 3, 8, -2, _ink2),
  ]);

  /// `--shadow-btn-primary: inset 0 1px 0 var(--rim-strong),`
  /// `inset 0 -2px 5px var(--ink-2), 0 1px 2px var(--ink-2),`
  /// `0 4px 10px -2px color-mix(in oklab, var(--color-action) 55%, transparent)`
  static final DsShadowSpec btnPrimary = DsShadowSpec(<DsShadowLayer>[
    const DsShadowLayer(0, 1, 0, 0, _rimStrong, inset: true),
    const DsShadowLayer(0, -2, 5, 0, _ink2, inset: true),
    const DsShadowLayer(0, 1, 2, 0, _ink2),
    DsShadowLayer(0, 4, 10, -2, (_) => _actionAt(0.55)),
  ]);

  /// `--shadow-btn-value: inset 0 1px 0 var(--rim-strong),`
  /// `inset 0 -2px 5px var(--ink-1), 0 1px 2px var(--ink-2),`
  /// `0 4px 10px -2px color-mix(in oklab, var(--color-value) 45%, transparent)`
  static final DsShadowSpec btnValue = DsShadowSpec(<DsShadowLayer>[
    const DsShadowLayer(0, 1, 0, 0, _rimStrong, inset: true),
    const DsShadowLayer(0, -2, 5, 0, _ink1, inset: true),
    const DsShadowLayer(0, 1, 2, 0, _ink2),
    DsShadowLayer(0, 4, 10, -2, (_) => _valueAt(0.45)),
  ]);

  /// `--shadow-btn-down: inset 0 2px 4px var(--ink-3), 0 1px 1px var(--ink-1)`
  static const DsShadowSpec btnDown = DsShadowSpec(<DsShadowLayer>[
    DsShadowLayer(0, 2, 4, 0, _ink3, inset: true),
    DsShadowLayer(0, 1, 1, 0, _ink1),
  ]);

  /// `--shadow-chip: inset 0 1px 0 var(--rim), inset 0 -1px 2px var(--ink-2),`
  /// `0 1px 2px var(--ink-2)`
  static const DsShadowSpec chip = DsShadowSpec(<DsShadowLayer>[
    DsShadowLayer(0, 1, 0, 0, _rim, inset: true),
    DsShadowLayer(0, -1, 2, 0, _ink2, inset: true),
    DsShadowLayer(0, 1, 2, 0, _ink2),
  ]);

  /// `--shadow-glow-action:`
  /// `0 0 0 1px color-mix(in oklab, var(--color-action-bright) 45%, transparent),`
  /// `0 10px 34px -8px color-mix(in oklab, var(--color-action) 60%, transparent)`
  /// Rationed glow — selection and reward only.
  static final DsShadowSpec glowAction = DsShadowSpec(<DsShadowLayer>[
    DsShadowLayer(0, 0, 0, 1, (_) => _actionBrightAt(0.45)),
    DsShadowLayer(0, 10, 34, -8, (_) => _actionAt(0.60)),
  ]);

  /// `--shadow-glow-value:`
  /// `0 0 0 1px color-mix(in oklab, var(--color-value) 45%, transparent),`
  /// `0 10px 34px -8px color-mix(in oklab, var(--color-value) 42%, transparent)`
  static final DsShadowSpec glowValue = DsShadowSpec(<DsShadowLayer>[
    DsShadowLayer(0, 0, 0, 1, (_) => _valueAt(0.45)),
    DsShadowLayer(0, 10, 34, -8, (_) => _valueAt(0.42)),
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
  static DsShadowSpec pulseLiveRing(double t) => DsShadowSpec(<DsShadowLayer>[
        DsShadowLayer(
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
