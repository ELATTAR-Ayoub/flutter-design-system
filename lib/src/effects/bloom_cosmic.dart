/// `bloom-cosmic` — the iridescence behind an Alert and a toast
/// (`app/globals.css` L1663–1877, theme split at L3235–3245).
///
/// Two blurred pseudo-elements hung off the bottom-right corner of a surface,
/// each a stack of radial gradients in the variant's own two hues, composited
/// through one blend mode. Its own comment sets the brief: the deep layer is
/// *"large, dim, slow — this is the one that reads as distance"*, the near one
/// *"tighter, brighter, lit toward `--bloom-hot` at the core"*.
///
/// **Every hue is derived, none is frozen.** The stylesheet computes the three
/// working colours with relative-colour syntax:
///
/// ```css
/// --bloom-core: oklch(from var(--bloom-2) calc(l * var(--bloom-l))
///                                          calc(c * var(--bloom-c)) h);
/// --bloom-glow: oklch(from var(--bloom-1) calc(l * var(--bloom-l))
///                                          calc(c * var(--bloom-c)) h);
/// --bloom-hot:  oklch(from var(--bloom-core)
///                     calc(l + (1 - l) * var(--bloom-lift))
///                     calc(c * var(--bloom-hot-c)) h);
/// ```
///
/// so they are computed here through [DsOklab] from the two hues a variant
/// declares, and no hex from the reference appears anywhere in this file. A
/// rebrand of the action ramp carries through untouched.
///
/// **The gradients end on `--bloom-void`, not on `transparent`.** That is the
/// mechanism the whole effect turns on: the void is `white` on light and
/// `black` on dark, and each is the identity operand of that theme's blend —
/// `multiply` by white and `screen` by black both leave the destination alone.
/// So the ramps fade to nothing by fading to the colour their blend cannot
/// see, and a port that faded them to alpha 0 instead would leave a visible
/// rectangular edge wherever the blur ran out.
///
/// **Painting order.** CSS paints the element's background, then its border,
/// then in-flow content, then positioned descendants — but `overflow: hidden`
/// clips the two pseudo-elements to the **padding** box, so they cover the
/// fill and never the border. This widget therefore paints [fill] and the two
/// layers itself, behind [child], and expects to be mounted *inside* whatever
/// draws the border. `isolation: isolate` needs no layer of its own for the
/// same reason `sheen-action` needs none: [fill] is opaque and went into this
/// canvas moments earlier, so the destination under a blend op IS the
/// surface's own paint.
///
/// **Live.** Both layers drift forever and both swell on hover — the deferral
/// this file used to carry is closed, on the page the deferral named.
///
/// ```css
/// cosmic-drift-deep 18s var(--ease-in-out) infinite alternate   /* ::before */
/// cosmic-drift-near 11s var(--ease-in-out) infinite alternate   /* ::after  */
/// &::before, &::after { scale: 1; transition: scale var(--duration-bloom) var(--ease-out) }
/// &:hover::before { scale: 2.2 }  &:hover::after { scale: 2.5 }
/// ```
///
/// The periods are coprime-ish on purpose (globals.css L1859–1860): the pair
/// takes minutes to return to the same arrangement, which is what stops a
/// corner light from reading as a loop.
///
/// **The composition problem, and the shape of the answer.** CSS gets this for
/// free — the drift is the `transform` property and the swell is the
/// standalone `scale` property, and two properties multiply. The stylesheet
/// says so outright (L1826–1830): `transform: scale()` would be *ignored*
/// here, because an animation beats a plain declaration on the property it
/// animates, so the swell had to be written on a different property. Flutter
/// has one matrix, so the two are multiplied by hand in CSS Transforms 2's own
/// order — the individual `scale` first, then the `transform` list — both
/// about the layer's own `transform-origin`. See [DsBloomDrift.matrixFor].
///
/// **The layer's `filter` is inside its transform, not outside.** A CSS
/// `filter` renders in the element's local space and the transform maps the
/// filtered result, so a layer at `scale(1.2)` carries a blur 1.2× as wide in
/// the parent. The painter therefore transforms the canvas *first* and opens
/// the blurred `saveLayer` inside it; drawing the blur first and scaling the
/// result would hold the halo's width fixed while the light grew.
///
/// Supervisor ruling F2: all of it builds, always. The only gate is
/// `dsAnimationDuration` — there is deliberately no out-of-view pause, because
/// the reference has none and a page whose lights stop when they leave the fold
/// is a different page.
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../motion/keyframes.dart';
import '../theme_scope.dart';
import 'starfield.dart';

// ── CLOSED: the per-theme bloom variables ───────────────────────────────────
// `--bloom-void` / `--bloom-l` / `--bloom-c` / `--bloom-lift` / `--bloom-hot-c`
// used to live here as eight file-local constants under a standing FOLLOW-UP —
// they are declared in the two theme blocks (globals.css L699–715 light,
// L885–898 dark) beside every other token, and `foundation/theme.dart` was not
// that task's file. Supervisor ruling F9 opened it: they are now
// `DsThemeData.bloomVoid` / `.bloomL` / `.bloomC` / `.bloomLift` / `.bloomHotC`
// and this file reads them like any other token. The FOLLOW-UP also asked for
// `DsBloomInk.of` to be deleted; there is no such member and has not been since
// the resolver became the instance method [DsBloomCosmic._ink], which is part
// of what made the note stale.
//
// What did NOT move, and why: `--bloom-core`, `--bloom-glow` and `--bloom-hot`
// are `oklch(from var(--bloom-2) …)` — they read a custom property that only
// exists on the host element, so they cannot be flattened into a theme block
// and stay derivations here. `--star-glow` splits along the same seam; see
// `DsStarfield.glowFor`.

/// `opacity: 0.75` on `.dark`, `0.34` on `:root`/`.light` (globals.css
/// L3235–3245). The utility's own `0.75` on `::before` is overridden by both.
///
/// Not a `--bloom-*` custom property: this is the theme blend split's own
/// declaration on the pseudo-elements, one selector away from the five above,
/// and it moves with [DsBloomCosmic.blendFor] rather than with the theme's
/// token list.
const double _darkOpacity = 0.75;
const double _lightOpacity = 0.34;

// ── `::before` — the deep field ─────────────────────────────────────────────
// `inset: -95% -4.5rem -95% auto; width: min(95%, 26rem)`.

const double _deepInsetY = 0.95; // `-95%` top and bottom
const double _deepInsetRight = 72; // `-4.5rem`
const double _deepWidthFraction = 0.95; // `min(95%, …)`
const double _deepWidthCap = 416; // `min(…, 26rem)`

/// `filter: blur(calc(var(--spacing) * 4))` — CSS `filter` takes its length as
/// the Gaussian **standard deviation**, so it is a sigma and needs no
/// conversion (the same rule `DsBlurs` records).
final double _deepBlur = ds(4);

// ── `::after` — the near field ──────────────────────────────────────────────
// `inset: -80% -3.5rem -80% auto; width: min(86%, 21rem)`.

const double _nearInsetY = 0.80;
const double _nearInsetRight = 56; // `-3.5rem`
const double _nearWidthFraction = 0.86;
const double _nearWidthCap = 336; // `21rem`

/// `filter: blur(calc(var(--spacing) * 2.5))`.
final double _nearBlur = ds(2.5);

/// `mask-image: radial-gradient(78% 108% at 96% 78%, black 0, black 28%,
/// transparent 84%)` — *"radial, not linear: a linear fade leaves hard top and
/// bottom edges where the light meets the surface."*
const double _maskRadiusX = 0.78;
const double _maskRadiusY = 1.08;
const double _maskCentreX = 0.96;
const double _maskCentreY = 0.78;
const List<double> _maskStops = <double>[0, 0.28, 0.84];

// ── The two drifts, and the hover swell ─────────────────────────────────────

/// One `@keyframes cosmic-drift-*` stop: a percentage translate, a rotation and
/// a scale, exactly as the stylesheet writes it.
///
/// The translate is in **percent of the layer's own box** — CSS resolves a
/// percentage translation against the translated element, and the two layers
/// are 416 × 200.44 and 336 × 179.72 on the feedback page's Alert, not against
/// the host. A port that resolved it against the host would drift the deep
/// layer nearly three times too far.
@immutable
class DsBloomDriftStop {
  const DsBloomDriftStop(
    this.percent, {
    required this.translate,
    required this.degrees,
    required this.scale,
  });

  /// The keyframe's own `0%`…`100%`.
  final double percent;

  /// `translate3d(x%, y%, 0)` as fractions — `-11%, 8%` is `Offset(-0.11, 0.08)`.
  final Offset translate;

  /// `rotate(<n>deg)`.
  final double degrees;

  /// `scale(<n>)`.
  final double scale;
}

/// `@keyframes cosmic-drift-deep` / `cosmic-drift-near` — globals.css
/// L1864–1877, and the hover swell that multiplies onto them (L1836–1846).
///
/// Both run `var(--ease-in-out)` `infinite alternate`, so the controller walks
/// 0→1→0 forever and the easing is applied here, per gap, by
/// [DsKeyframes.doubles]'s own rule: the clock stays linear so nothing is eased
/// twice.
@immutable
class DsBloomDrift {
  /// The four tracks are built **once, at construction**, not per frame: this
  /// runs on every tick of every mounted bloom (the feedback page rests at ten
  /// hosts, twenty layers), and rebuilding four [TweenSequence]s per layer per
  /// frame would allocate for no reason. Which is why [deep] and [near] are
  /// `static final` rather than `const` — the same shape `DsShadows.btnPrimary`
  /// takes for the same kind of reason.
  DsBloomDrift({
    required this.duration,
    required this.stops,
    required this.hoverScale,
    required this.originX,
    required this.originY,
  })  : translateX = _track(stops, _readX),
        translateY = _track(stops, _readY),
        rotation = _track(stops, _readRadians),
        scale = _track(stops, _readScale);

  /// `::before` — 18s, three stops, `transform-origin: 88% 82%`, swelling to
  /// 2.2 on hover.
  static final DsBloomDrift deep = DsBloomDrift(
    duration: DsDurations.cosmicDriftDeep,
    originX: 0.88,
    originY: 0.82,
    hoverScale: 2.2,
    stops: <DsBloomDriftStop>[
      DsBloomDriftStop(0, translate: Offset.zero, degrees: 0, scale: 1),
      DsBloomDriftStop(50,
          translate: Offset(-0.11, 0.08), degrees: 7, scale: 1.2),
      DsBloomDriftStop(100,
          translate: Offset(0.06, -0.09), degrees: -5, scale: 1.08),
    ],
  );

  /// `::after` — 11s, four stops, `transform-origin: 90% 86%`, swelling to 2.5.
  ///
  /// Note stop 0: `scale(1.04)`, not 1. The near field is *born* slightly
  /// larger than its box, which is the difference between the two layers'
  /// resting frames and the reason [restingMatrixFor] is not simply this
  /// table at `t = 0` — see that member.
  static final DsBloomDrift near = DsBloomDrift(
    duration: DsDurations.cosmicDriftNear,
    originX: 0.90,
    originY: 0.86,
    hoverScale: 2.5,
    stops: <DsBloomDriftStop>[
      DsBloomDriftStop(0, translate: Offset.zero, degrees: 0, scale: 1.04),
      DsBloomDriftStop(35,
          translate: Offset(-0.03, -0.02), degrees: -9, scale: 1.18),
      DsBloomDriftStop(70,
          translate: Offset(0.03, 0.02), degrees: 6, scale: 1),
      DsBloomDriftStop(100,
          translate: Offset(-0.02, 0.01), degrees: -4, scale: 1.14),
    ],
  );

  /// `animation-duration`.
  final Duration duration;

  /// The keyframe table, in the stylesheet's order.
  final List<DsBloomDriftStop> stops;

  /// `&:hover::before { scale: 2.2 }` — the standalone `scale` property, over
  /// [DsDurations.bloom] on `--ease-out`.
  final double hoverScale;

  /// `transform-origin`'s x, as a fraction of the layer's own width.
  final double originX;

  /// …and its y.
  final double originY;

  /// `translate3d(x%, …)` as a fraction of the layer's width, eased.
  final Animatable<double> translateX;

  /// `translate3d(…, y%, 0)` as a fraction of the layer's **height**.
  final Animatable<double> translateY;

  /// `rotate(…)`, in radians — the table states degrees, [Matrix4] wants
  /// radians, and converting once at the table keeps the call site honest.
  final Animatable<double> rotation;

  /// `scale(…)`.
  final Animatable<double> scale;

  /// The `transform` list at linear progress [t], as one matrix about the
  /// layer's origin.
  ///
  /// CSS applies a transform list left to right — `translate3d`, then
  /// `rotate`, then `scale` — so the rotation happens in the translated frame
  /// and the scale in the rotated one.
  Matrix4 driftMatrix(Rect layer, double t) {
    final double clamped = t.clamp(0.0, 1.0);
    final Offset o = _originIn(layer);
    final double s = scale.transform(clamped);
    return Matrix4.identity()
      ..translateByDouble(o.dx, o.dy, 0, 1)
      ..translateByDouble(
        translateX.transform(clamped) * layer.width,
        translateY.transform(clamped) * layer.height,
        0,
        1,
      )
      ..rotateZ(rotation.transform(clamped))
      ..scaleByDouble(s, s, 1, 1)
      ..translateByDouble(-o.dx, -o.dy, 0, 1);
  }

  /// The drift with the hover swell multiplied onto it.
  ///
  /// CSS Transforms 2 composes the individual properties **before** the
  /// `transform` property: `translate`, `rotate`, `scale`, then `transform`.
  /// Only `scale` is used here, so the swell is the outer factor and the drift
  /// the inner — which is why a hovered layer grows about its own origin
  /// instead of about wherever the drift has carried it.
  Matrix4 matrixFor(
    Rect layer, {
    required double driftT,
    required double hoverT,
  }) {
    final Offset o = _originIn(layer);
    final double swell = _swellAt(hoverT);
    return Matrix4.identity()
      ..translateByDouble(o.dx, o.dy, 0, 1)
      ..scaleByDouble(swell, swell, 1, 1)
      ..translateByDouble(-o.dx, -o.dy, 0, 1)
      ..multiply(driftMatrix(layer, driftT));
  }

  /// The frame a `prefers-reduced-motion` browser settles on — the element's
  /// **resting style**, which is `transform: none`, with the hover swell still
  /// applied because a transition is collapsed rather than removed.
  ///
  /// Deliberately not `driftMatrix(layer, 0)`. The blanket rule (globals.css
  /// L2534–2542) collapses `animation-duration` to 0.01ms and
  /// `animation-iteration-count` to 1, so both animations *finish* rather than
  /// freeze; neither declares an `animation-fill-mode`, so what is left is the
  /// element's own `transform`, which the utility never sets. For [deep] that
  /// happens to equal stop 0; for [near] it does **not** — stop 0 is
  /// `scale(1.04)` and the resting style is `scale(1)`, a 4% difference that
  /// the reference genuinely shows between a still browser and a moving one.
  /// This is also exactly the frame the static bloom shipped for the forms
  /// page, so nothing that page renders moves.
  Matrix4 restingMatrixFor(Rect layer, {required double hoverT}) {
    final Offset o = _originIn(layer);
    final double swell = _swellAt(hoverT);
    return Matrix4.identity()
      ..translateByDouble(o.dx, o.dy, 0, 1)
      ..scaleByDouble(swell, swell, 1, 1)
      ..translateByDouble(-o.dx, -o.dy, 0, 1);
  }

  Offset _originIn(Rect layer) => Offset(
        layer.left + layer.width * originX,
        layer.top + layer.height * originY,
      );

  /// `1` at rest, [hoverScale] held, on `--ease-out` over `--duration-bloom`.
  double _swellAt(double hoverT) =>
      1 + (hoverScale - 1) * DsCurves.out.transform(hoverT.clamp(0.0, 1.0));

  static double _readX(DsBloomDriftStop s) => s.translate.dx;
  static double _readY(DsBloomDriftStop s) => s.translate.dy;
  static double _readScale(DsBloomDriftStop s) => s.scale;
  static double _readRadians(DsBloomDriftStop s) => s.degrees * math.pi / 180;

  static Animatable<double> _track(
    List<DsBloomDriftStop> stops,
    double Function(DsBloomDriftStop) read,
  ) =>
      DsKeyframes.doubles(
        <DsKeyframeStop<double>>[
          for (final DsBloomDriftStop stop in stops)
            DsKeyframeStop<double>(stop.percent, read(stop)),
        ],
        curve: DsCurves.inOut,
      );
}

// ── Hue resolvers ───────────────────────────────────────────────────────────
// Named functions rather than closures, so each named constructor below reads
// as the `[--bloom-1: …] [--bloom-2: …]` pair it transcribes. The shape mirrors
// `DsShadowLayer.color`: a variant's hue may be a raw ramp entry or a theme
// token, and only the theme knows which.

Color _actionBright(DsThemeData t) => DsPalette.actionBright;
Color _action(DsThemeData t) => DsPalette.action;
Color _value(DsThemeData t) => DsPalette.value;
Color _valueBright(DsThemeData t) => DsPalette.valueBright;
Color _valueDark(DsThemeData t) => DsPalette.valueDark;
Color _success(DsThemeData t) => DsPalette.success;
Color _warning(DsThemeData t) => DsPalette.warning;
Color _info(DsThemeData t) => DsPalette.info;
Color _destructive(DsThemeData t) => t.destructive;

/// The three working colours a bloom resolves to, for one theme and one pair,
/// plus the two things the theme's blend split decides.
///
/// Public because it is the whole derivation in one object: a probe that wants
/// to check `--bloom-hot` against a measured hex should not have to rasterise a
/// gradient to reach it.
@immutable
class DsBloomInk {
  const DsBloomInk({
    required this.core,
    required this.glow,
    required this.hot,
    required this.voidInk,
    required this.opacity,
    required this.blend,
  });

  /// `--bloom-core` — `--bloom-2`, relit.
  final Color core;

  /// `--bloom-glow` — `--bloom-1`, relit.
  final Color glow;

  /// `--bloom-hot` — [core], lifted toward white and desaturated by the amount
  /// the theme asks for.
  final Color hot;

  /// `--bloom-void`, and the identity operand of [blend].
  final Color voidInk;

  final double opacity;
  final BlendMode blend;

  @override
  bool operator ==(Object other) =>
      other is DsBloomInk &&
      other.core == core &&
      other.glow == glow &&
      other.hot == hot &&
      other.voidInk == voidInk &&
      other.opacity == opacity &&
      other.blend == blend;

  @override
  int get hashCode => Object.hash(core, glow, hot, voidInk, opacity, blend);
}

/// Paints `bloom-cosmic` behind [child], and hangs `.starfield` over it.
///
/// Mount it inside whatever draws the surface's border — the CSS clips both
/// layers to the padding box — and give it the surface's own [fill], which the
/// blend composites against.
///
/// **Stateful** (supervisor ruling F1): four infinite drifts and a hover swell
/// need clocks. It carries three controllers — deep, near, and one hover that
/// times both the bloom's `scale` and the starfield's `translate`/`scale`,
/// because one `--duration-bloom` declaration times all of them.
///
/// The [MouseRegion] is on this widget rather than on the Alert or the toast
/// for a reason worth stating: the CSS `:hover` is on the `.bloom-cosmic`
/// element itself, and this widget's box is that element's **padding** box. A
/// host's 1px border is therefore outside this hover where CSS counts it
/// inside — one pixel of lag on a 1000ms transition, recorded rather than
/// worked around.
class DsBloomCosmic extends StatefulWidget {
  /// An arbitrary pair, for a caller that is transcribing a declaration this
  /// file has no named constructor for.
  const DsBloomCosmic({
    super.key,
    required this.bloom1,
    required this.bloom2,
    required this.radius,
    required this.fill,
    required this.child,
    this.starfield = true,
  });

  /// The utility's own defaults — `--bloom-1: var(--color-action-bright)`,
  /// `--bloom-2: var(--color-action)`. Also `Alert variant="default"`.
  const DsBloomCosmic.action({
    super.key,
    required this.radius,
    required this.fill,
    required this.child,
    this.starfield = true,
  })  : bloom1 = _actionBright,
        bloom2 = _action;

  /// `[--bloom-1: var(--destructive)] [--bloom-2: var(--color-action)]` —
  /// `Alert variant="destructive"` and `.cn-toast[data-type="error"]`.
  const DsBloomCosmic.destructive({
    super.key,
    required this.radius,
    required this.fill,
    required this.child,
    this.starfield = true,
  })  : bloom1 = _destructive,
        bloom2 = _action;

  /// `[--bloom-1: var(--color-success)] [--bloom-2: var(--color-value)]` —
  /// `Alert variant="success"` and `.cn-toast[data-type="success"]`.
  const DsBloomCosmic.success({
    super.key,
    required this.radius,
    required this.fill,
    required this.child,
    this.starfield = true,
  })  : bloom1 = _success,
        bloom2 = _value;

  /// `[--bloom-1: var(--color-warning)] [--bloom-2: var(--color-action)]` —
  /// `Alert variant="warning"`.
  ///
  /// Its source carries the longest comment in `alert.tsx`: the pair used to be
  /// `--color-value-bright` / `--color-value-dark` and *"worked only by
  /// accident"*, because a lime bloom under an amber glyph reads as warm light
  /// only while the value ramp happens to be lime. See [toastWarning] — the
  /// toast never got the fix.
  const DsBloomCosmic.warning({
    super.key,
    required this.radius,
    required this.fill,
    required this.child,
    this.starfield = true,
  })  : bloom1 = _warning,
        bloom2 = _action;

  /// `[--bloom-1: var(--color-info)] [--bloom-2: var(--color-action)]` —
  /// `Alert variant="info"` and `.cn-toast[data-type="info"]`.
  const DsBloomCosmic.info({
    super.key,
    required this.radius,
    required this.fill,
    required this.child,
    this.starfield = true,
  })  : bloom1 = _info,
        bloom2 = _action;

  /// `.cn-toast[data-type="warning"]` —
  /// `[--bloom-1: var(--color-value-bright)] [--bloom-2: var(--color-value-dark)]`.
  ///
  /// DOCUMENTED DRIFT: this is the pair [warning] was moved **off**, and the
  /// toast still carries it. A warning Alert glows in its own amber; a warning
  /// toast glows lime under the same amber glyph. Both ship as written.
  const DsBloomCosmic.toastWarning({
    super.key,
    required this.radius,
    required this.fill,
    required this.child,
    this.starfield = true,
  })  : bloom1 = _valueBright,
        bloom2 = _valueDark;

  /// `.cn-toast[data-type="loading"]` —
  /// `[--bloom-1: var(--color-action-bright)] [--bloom-2: var(--color-value)]`.
  const DsBloomCosmic.loading({
    super.key,
    required this.radius,
    required this.fill,
    required this.child,
    this.starfield = true,
  })  : bloom1 = _actionBright,
        bloom2 = _value;

  /// `--bloom-1` — the companion hue, thrown clear to the opposite diagonal.
  final Color Function(DsThemeData) bloom1;

  /// `--bloom-2` — the core.
  final Color Function(DsThemeData) bloom2;

  /// The surface's own corner. `overflow: hidden` clips to the padding box, so
  /// a caller inside a 1px border may pass the outer radius unchanged: the
  /// difference is one pixel of corner on a shape that is already blurred by
  /// sixteen.
  final BorderRadius radius;

  /// The surface's `background-color`, painted first so the blend has the
  /// destination CSS gives it.
  final Color fill;

  final Widget child;

  /// Whether `.starfield` hangs over the two bloom layers.
  ///
  /// True for both hosts the reference has, and by two different mechanisms:
  /// the Alert writes the span itself (`alert.tsx` L85) and every toast is
  /// caught by `.bloom-cosmic [data-content]::before`. Mounting it here rather
  /// than in either component is what makes the toast's measured accident come
  /// out right — `[data-content]` is unpositioned, so its pseudo-elements'
  /// `inset: 0` resolves against the toast, which is this widget's box.
  ///
  /// A parameter rather than a constant because a third host would be opting
  /// *in* to sparkles, and that should be a decision someone writes down.
  final bool starfield;

  /// `mix-blend-mode` — `screen` on `.dark`, `multiply` on `:root`/`.light`
  /// (globals.css L3235–3245). The same split `sheen-action` carries, and the
  /// reason the ramps end on `--bloom-void`: white and black are the two
  /// blends' identity operands.
  static BlendMode blendFor(DsThemeKind kind) => switch (kind) {
        DsThemeKind.light => BlendMode.multiply,
        DsThemeKind.dark => BlendMode.screen,
      };

  /// `--bloom-void` — `white` on light, `black` on dark.
  ///
  /// A thin reader over [DsThemeData.bloomVoid], kept because half the callers
  /// of this file hold a [DsThemeKind] and not a whole theme, and because the
  /// name says which custom property is being asked for.
  static Color voidFor(DsThemeKind kind) => switch (kind) {
        DsThemeKind.light => DsThemeData.light.bloomVoid,
        DsThemeKind.dark => DsThemeData.dark.bloomVoid,
      };

  /// One pseudo-element's box on a host padding box of [box].
  ///
  /// Exposed because the two `min()` caps are the entire reason the effect
  /// works on two hosts of wildly different widths, and no widget assertion can
  /// reach them: `min(95%, 26rem)` and `min(86%, 21rem)` mean the corner light
  /// is roughly the same **physical** size on a 356px toast and a 1030px Alert.
  /// Both caps bite on the Alert; neither bites on the toast. A port that used
  /// a bare 95%/86% would flood the Alert, and this is the pin that would fail.
  @visibleForTesting
  static Rect layerRectFor(Rect box, {required bool deep}) => deep
      ? _BloomPainter._layerRect(
          box,
          insetY: _deepInsetY,
          insetRight: _deepInsetRight,
          widthFraction: _deepWidthFraction,
          widthCap: _deepWidthCap,
        )
      : _BloomPainter._layerRect(
          box,
          insetY: _nearInsetY,
          insetRight: _nearInsetRight,
          widthFraction: _nearWidthFraction,
          widthCap: _nearWidthCap,
        );

  /// `--bloom-core` / `--bloom-glow` / `--bloom-hot`, resolved for [theme] and
  /// this host's own pair.
  ///
  /// The three relative-OKLCH derivations, and the reason they are not theme
  /// fields: each reads `--bloom-1` or `--bloom-2`, which exist only on the
  /// host element. The four scalars they multiply by *are* theme fields.
  ///
  /// Exposed rather than private so a probe can assert the derivation against
  /// the map's measured hexes without rasterising anything.
  @visibleForTesting
  DsBloomInk inkFor(DsThemeData theme) {
    Color relit(Color source) {
      final ({double l, double c, double h}) from = DsOklab.toOklch(source);
      return DsOklab.fromOklch(
        from.l * theme.bloomL,
        from.c * theme.bloomC,
        from.h,
      );
    }

    final Color core = relit(bloom2(theme));
    final ({double l, double c, double h}) coreLch = DsOklab.toOklch(core);

    return DsBloomInk(
      core: core,
      glow: relit(bloom1(theme)),
      // `calc(l + (1 - l) * var(--bloom-lift))` on the core's own lightness.
      hot: DsOklab.fromOklch(
        coreLch.l + (1 - coreLch.l) * theme.bloomLift,
        coreLch.c * theme.bloomHotC,
        coreLch.h,
      ),
      voidInk: theme.bloomVoid,
      opacity:
          theme.kind == DsThemeKind.light ? _lightOpacity : _darkOpacity,
      blend: blendFor(theme.kind),
    );
  }

  @override
  State<DsBloomCosmic> createState() => _DsBloomCosmicState();
}

class _DsBloomCosmicState extends State<DsBloomCosmic>
    with TickerProviderStateMixin {
  /// The two drifts. The durations named here are placeholders for the first
  /// frame only — [build] re-reads both through [dsAnimationDuration] on every
  /// pass, the way `DsSpinner` and `DsKeyframePlayer` do.
  late final AnimationController _deep = AnimationController(
    vsync: this,
    duration: DsBloomDrift.deep.duration,
  );
  late final AnimationController _near = AnimationController(
    vsync: this,
    duration: DsBloomDrift.near.duration,
  );

  /// `transition: scale var(--duration-bloom) var(--ease-out)` — one clock for
  /// both pseudo-elements *and* for the starfield's two clusters, because one
  /// declaration times all four.
  late final AnimationController _hover = AnimationController(
    vsync: this,
    duration: DsDurations.bloom,
  );

  /// Null until the first resolution, so a MediaQuery change that is *not* a
  /// reduced-motion change does not restart the drifts.
  bool? _stilled;

  bool _hovered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool stilled =
        dsAnimationDuration(context, DsBloomDrift.deep.duration) ==
            Duration.zero;
    if (_stilled == stilled) return;
    _stilled = stilled;
    _play();
  }

  @override
  void dispose() {
    _deep.dispose();
    _near.dispose();
    _hover.dispose();
    super.dispose();
  }

  /// Supervisor ruling F2: both loopers build in full, and `dsAnimationDuration`
  /// is the only gate. No out-of-view pause — the reference has none.
  void _play() {
    if (_stilled ?? false) {
      _deep.stop();
      _near.stop();
      return;
    }
    // `infinite alternate`: the clock runs 0→1→0 forever, and the keyframe
    // easing lives in the tracks, so nothing is eased twice.
    _deep.repeat(reverse: true);
    _near.repeat(reverse: true);
  }

  void _setHovered(bool hovered) {
    if (_hovered == hovered) return;
    setState(() => _hovered = hovered);
    if (hovered) {
      _hover.forward();
    } else {
      _hover.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool stilled = _stilled ?? false;
    _deep.duration =
        dsAnimationDuration(context, DsBloomDrift.deep.duration);
    _near.duration =
        dsAnimationDuration(context, DsBloomDrift.near.duration);
    _hover.duration = dsAnimationDuration(context, DsDurations.bloom);

    Widget content = widget.child;
    if (widget.starfield) {
      content = Stack(
        // The incoming constraints reach the content unchanged: a bloom on a
        // `w-full` Alert is handed a tight width, and `StackFit.loose` would
        // hand the column a loose one and collapse the surface onto its text.
        fit: StackFit.passthrough,
        children: <Widget>[
          // `position: absolute; inset: 0`. First in the list, so it paints
          // UNDER the content — which is the reference's own order: the
          // `alert-stars` span precedes the children in the DOM and both sit at
          // `z-index: 1`.
          Positioned.fill(
            child: DsStarfield(
              bloom2: widget.bloom2(theme),
              hovered: _hovered,
            ),
          ),
          widget.child,
        ],
      );
    }

    return MouseRegion(
      // `pointer-events` is untouched: this only watches, and `opaque: false`
      // keeps it from claiming the region from whatever is underneath.
      opaque: false,
      onEnter: (PointerEnterEvent _) => _setHovered(true),
      onExit: (PointerExitEvent _) => _setHovered(false),
      child: ClipRRect(
        // `overflow: hidden` — *"the bloom needs something to clip against."*
        // It is also what keeps a layer at `scale(2.5)` inside the card.
        borderRadius: widget.radius,
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: Listenable.merge(<Listenable>[_deep, _near, _hover]),
            builder: (BuildContext context, Widget? child) => CustomPaint(
              painter: _BloomPainter(
                fill: widget.fill,
                ink: widget.inkFor(theme),
                deepT: _deep.value,
                nearT: _near.value,
                hoverT: _hover.value,
                stilled: stilled,
              ),
              child: child,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

class _BloomPainter extends CustomPainter {
  const _BloomPainter({
    required this.fill,
    required this.ink,
    required this.deepT,
    required this.nearT,
    required this.hoverT,
    required this.stilled,
  });

  final Color fill;
  final DsBloomInk ink;

  /// `cosmic-drift-deep`'s linear progress.
  final double deepT;

  /// `cosmic-drift-near`'s.
  final double nearT;

  /// The hover swell's, shared by both layers.
  final double hoverT;

  /// Whether the drifts are stilled and the layers sit on their resting frame.
  final bool stilled;

  /// One layer's whole transform: the drift with the swell multiplied on, or
  /// the resting frame with the swell alone.
  Matrix4 _matrix(DsBloomDrift drift, Rect layer, double t) => stilled
      ? drift.restingMatrixFor(layer, hoverT: hoverT)
      : drift.matrixFor(layer, driftT: t, hoverT: hoverT);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final Rect box = Offset.zero & size;
    canvas.drawRect(box, Paint()..color = fill);
    _paintDeep(canvas, box);
    _paintNear(canvas, box);
  }

  /// `::before` — two gradients, `blur(16px)`, at the theme's blend.
  void _paintDeep(Canvas canvas, Rect box) {
    final Rect layer = _layerRect(
      box,
      insetY: _deepInsetY,
      insetRight: _deepInsetRight,
      widthFraction: _deepWidthFraction,
      widthCap: _deepWidthCap,
    );

    // The element's `transform` maps its already-filtered rendering into the
    // parent, so it goes on OUTSIDE the blurred group: a layer at `scale(1.2)`
    // must carry a 1.2× wider halo, which is what CSS renders and what
    // blurring after the scale would not.
    canvas.save();
    canvas.transform(_matrix(DsBloomDrift.deep, layer, deepT).storage);
    canvas.saveLayer(layer.inflate(_deepBlur * 3), _groupPaint(_deepBlur));
    // CSS paints the FIRST-listed background layer on top, so the two are
    // walked backwards — the same reversal `DsShadowSpec.outerShadows` makes.
    _drawRadial(
      canvas,
      layer,
      radiusX: 0.44,
      radiusY: 0.54,
      centreX: 0.94,
      centreY: 0.40,
      colors: <Color>[DsOklab.mix(ink.glow, ink.core, 0.60), ink.voidInk],
      stops: const <double>[0, 0.78],
    );
    _drawRadial(
      canvas,
      layer,
      radiusX: 0.48,
      radiusY: 0.58,
      centreX: 0.74,
      centreY: 0.86,
      colors: <Color>[
        ink.core,
        DsOklab.mix(ink.core, ink.voidInk, 0.45),
        ink.voidInk,
      ],
      stops: const <double>[0, 0.54, 0.84],
    );
    canvas.restore();
    canvas.restore();
  }

  /// `::after` — three gradients under one radial mask, `blur(10px)`, at the
  /// theme's blend.
  void _paintNear(Canvas canvas, Rect box) {
    final Rect layer = _layerRect(
      box,
      insetY: _nearInsetY,
      insetRight: _nearInsetRight,
      widthFraction: _nearWidthFraction,
      widthCap: _nearWidthCap,
    );

    canvas.save();
    canvas.transform(_matrix(DsBloomDrift.near, layer, nearT).storage);
    canvas.saveLayer(layer.inflate(_nearBlur * 3), _groupPaint(_nearBlur));
    // `mask-image` applies to the finished background stack, so the three
    // layers composite among themselves inside their own group first.
    canvas.saveLayer(layer, Paint());
    // The bridge, then the companion, then the hot core — reversed, as above.
    _drawRadial(
      canvas,
      layer,
      radiusX: 0.46,
      radiusY: 0.58,
      centreX: 0.84,
      centreY: 0.46,
      colors: <Color>[
        DsOklab.mix(ink.glow, ink.core, 0.50),
        DsOklab.mix(ink.core, ink.voidInk, 0.50),
        ink.voidInk,
      ],
      stops: const <double>[0, 0.52, 0.82],
    );
    _drawRadial(
      canvas,
      layer,
      radiusX: 0.44,
      radiusY: 0.52,
      centreX: 0.64,
      centreY: 0.12,
      colors: <Color>[
        DsOklab.mix(ink.core, ink.hot, 0.60),
        ink.core,
        ink.voidInk,
      ],
      stops: const <double>[0, 0.34, 0.82],
    );
    _drawRadial(
      canvas,
      layer,
      radiusX: 0.42,
      radiusY: 0.56,
      centreX: 0.92,
      centreY: 0.84,
      colors: <Color>[
        DsOklab.mix(ink.glow, ink.hot, 0.35),
        ink.glow,
        DsOklab.mix(ink.glow, ink.voidInk, 0.45),
        ink.voidInk,
      ],
      stops: const <double>[0, 0.28, 0.56, 0.82],
    );
    // `black 0, black 28%, transparent 84%` — only the alpha of a mask is
    // read, so the opaque end is hung on the void rather than on a colour this
    // file would otherwise have to name.
    canvas.drawRect(
      layer,
      Paint()
        ..blendMode = BlendMode.dstIn
        ..shader = _radialShader(
          layer,
          radiusX: _maskRadiusX,
          radiusY: _maskRadiusY,
          centreX: _maskCentreX,
          centreY: _maskCentreY,
          colors: <Color>[
            ink.voidInk,
            ink.voidInk,
            ink.voidInk.withValues(alpha: 0),
          ],
          stops: _maskStops,
        ),
    );
    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  /// A pseudo-element's `filter`, `opacity` and `mix-blend-mode`, as the paint
  /// for the [Canvas.saveLayer] that groups its background layers.
  ///
  /// All three apply to the element as a whole rather than to the gradients
  /// inside it, which is exactly what one group layer expresses. Only the
  /// alpha of this paint is read, so the colour it hangs on is arbitrary —
  /// `transparent` says that plainly.
  Paint _groupPaint(double sigma) => Paint()
    ..blendMode = ink.blend
    ..color = dsTransparent.withValues(alpha: ink.opacity)
    ..imageFilter = ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);

  /// One pseudo-element's box, from its `inset` and `width`.
  ///
  /// `left: auto` with a right offset and a width means the box hangs off the
  /// right edge; `top`/`bottom` are both set, so the height falls out of them
  /// and `height: auto` resolves to `H − top − bottom`.
  static Rect _layerRect(
    Rect box, {
    required double insetY,
    required double insetRight,
    required double widthFraction,
    required double widthCap,
  }) {
    final double width =
        (box.width * widthFraction).clamp(0.0, widthCap).toDouble();
    final double right = box.right + insetRight;
    final double top = box.top - box.height * insetY;
    final double height = box.height * (1 + insetY * 2);
    return Rect.fromLTWH(right - width, top, width, height);
  }

  void _drawRadial(
    Canvas canvas,
    Rect layer, {
    required double radiusX,
    required double radiusY,
    required double centreX,
    required double centreY,
    required List<Color> colors,
    required List<double> stops,
  }) {
    canvas.drawRect(
      layer,
      Paint()
        ..shader = _radialShader(
          layer,
          radiusX: radiusX,
          radiusY: radiusY,
          centreX: centreX,
          centreY: centreY,
          colors: colors,
          stops: stops,
        ),
    );
  }

  @override
  bool shouldRepaint(_BloomPainter old) =>
      old.fill != fill ||
      old.ink != ink ||
      old.deepT != deepT ||
      old.nearT != nearT ||
      old.hoverT != hoverT ||
      old.stilled != stilled;
}

/// CSS `radial-gradient(<rx> <ry> at <cx> <cy>, …)`, every value a fraction of
/// [box]'s own width or height.
///
/// [ui.Gradient.radial] takes a single scalar radius and cannot describe a
/// two-radius ellipse, so a unit circle is mapped onto the ellipse by a matrix
/// instead — the trick `page_glow.dart` documents.
ui.Shader _radialShader(
  Rect box, {
  required double radiusX,
  required double radiusY,
  required double centreX,
  required double centreY,
  required List<Color> colors,
  required List<double> stops,
}) {
  final Rect ellipse = Rect.fromCenter(
    center: Offset(
      box.left + box.width * centreX,
      box.top + box.height * centreY,
    ),
    width: box.width * radiusX * 2,
    height: box.height * radiusY * 2,
  );
  return ui.Gradient.radial(
    Offset.zero,
    1,
    colors,
    stops,
    TileMode.clamp,
    Float64List.fromList(<double>[
      ellipse.width / 2, 0, 0, 0, //
      0, ellipse.height / 2, 0, 0, //
      0, 0, 1, 0, //
      ellipse.center.dx, ellipse.center.dy, 0, 1, //
    ]),
  );
}
