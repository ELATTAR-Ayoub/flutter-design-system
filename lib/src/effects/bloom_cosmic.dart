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
/// **Static.** The reference runs `cosmic-drift-deep 18s` and
/// `cosmic-drift-near 11s`, both `infinite alternate`, plus a hover `scale`
/// over `--duration-bloom`. Neither is ported here: RULES §4 rations perpetual
/// motion, an Alert on a form is not the live indicator, and the four
/// animations are properly the `feedback` page's subject. What renders is the
/// element's own resting style — the frame a `prefers-reduced-motion` browser
/// settles on, since both animations declare no `animation-fill-mode` and so
/// revert rather than hold.
///
/// FOLLOW-UP, recorded rather than fixed:
///  * the drift animations and the hover scale, with the `feedback` page;
///  * `.starfield` — thirteen hand-placed sparkles and two more infinite
///    sways, carried by an `alert-stars` span in the reference and by
///    `[data-content]` on a toast. Same argument, same page.
library;

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../foundation/colors.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../theme_scope.dart';

// ── The per-theme bloom variables ───────────────────────────────────────────
// `--bloom-void` / `--bloom-l` / `--bloom-c` / `--bloom-lift` / `--bloom-hot-c`
// are declared in the two theme blocks (globals.css L680–715 light, L885–898
// dark) beside every other token — but `DsThemeData` does not carry them yet
// and `foundation/theme.dart` is not this task's file. They live here, next to
// the only effect that reads them, until that file is next opened.
//
// FOLLOW-UP: move these five onto `DsThemeData` and delete `_BloomInk.of`.

/// Light: `--bloom-l: 0.6` — every hue is darkened before it is blurred,
/// because a pale wash multiplied into white paper disappears.
const double _lightL = 0.6;

/// Light: `--bloom-c: 1.55` — and pushed well past its own chroma to survive
/// the same multiply.
const double _lightC = 1.55;

/// Light: `--bloom-lift: 0`, `--bloom-hot-c: 1` — so `--bloom-hot` is
/// `--bloom-core` exactly. On paper the hot core is pure pigment.
const double _lightLift = 0;
const double _lightHotC = 1;

/// Dark: `--bloom-l: 1`, `--bloom-c: 1` — identity. The hues go in as they are.
const double _darkL = 1;
const double _darkC = 1;

/// Dark: `--bloom-lift: 0.85`, `--bloom-hot-c: 0.5` — the hot core is lifted
/// 85% of the way to white and half-desaturated, which is what makes it read
/// as light on glass rather than as paint.
const double _darkLift = 0.85;
const double _darkHotC = 0.5;

/// `opacity: 0.75` on `.dark`, `0.34` on `:root`/`.light` (globals.css
/// L3235–3245). The utility's own `0.75` on `::before` is overridden by both.
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

/// The three working colours a bloom resolves to, for one theme and one pair.
@immutable
class _BloomInk {
  const _BloomInk({
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
      other is _BloomInk &&
      other.core == core &&
      other.glow == glow &&
      other.hot == hot &&
      other.voidInk == voidInk &&
      other.opacity == opacity &&
      other.blend == blend;

  @override
  int get hashCode => Object.hash(core, glow, hot, voidInk, opacity, blend);
}

/// Paints `bloom-cosmic` behind [child].
///
/// Mount it inside whatever draws the surface's border — the CSS clips both
/// layers to the padding box — and give it the surface's own [fill], which the
/// blend composites against.
class DsBloomCosmic extends StatelessWidget {
  /// An arbitrary pair, for a caller that is transcribing a declaration this
  /// file has no named constructor for.
  const DsBloomCosmic({
    super.key,
    required this.bloom1,
    required this.bloom2,
    required this.radius,
    required this.fill,
    required this.child,
  });

  /// The utility's own defaults — `--bloom-1: var(--color-action-bright)`,
  /// `--bloom-2: var(--color-action)`. Also `Alert variant="default"`.
  const DsBloomCosmic.action({
    super.key,
    required this.radius,
    required this.fill,
    required this.child,
  })  : bloom1 = _actionBright,
        bloom2 = _action;

  /// `[--bloom-1: var(--destructive)] [--bloom-2: var(--color-action)]` —
  /// `Alert variant="destructive"` and `.cn-toast[data-type="error"]`.
  const DsBloomCosmic.destructive({
    super.key,
    required this.radius,
    required this.fill,
    required this.child,
  })  : bloom1 = _destructive,
        bloom2 = _action;

  /// `[--bloom-1: var(--color-success)] [--bloom-2: var(--color-value)]` —
  /// `Alert variant="success"` and `.cn-toast[data-type="success"]`.
  const DsBloomCosmic.success({
    super.key,
    required this.radius,
    required this.fill,
    required this.child,
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
  })  : bloom1 = _warning,
        bloom2 = _action;

  /// `[--bloom-1: var(--color-info)] [--bloom-2: var(--color-action)]` —
  /// `Alert variant="info"` and `.cn-toast[data-type="info"]`.
  const DsBloomCosmic.info({
    super.key,
    required this.radius,
    required this.fill,
    required this.child,
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
  })  : bloom1 = _valueBright,
        bloom2 = _valueDark;

  /// `.cn-toast[data-type="loading"]` —
  /// `[--bloom-1: var(--color-action-bright)] [--bloom-2: var(--color-value)]`.
  const DsBloomCosmic.loading({
    super.key,
    required this.radius,
    required this.fill,
    required this.child,
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
  /// Spelled as the two ends of the lightness axis rather than as an ARGB
  /// literal: CSS `white` *is* `hsl(0 0% 100%)`, and this file states no
  /// colour of its own.
  static Color voidFor(DsThemeKind kind) => switch (kind) {
        DsThemeKind.light => dsHsl(0, 0, 100),
        DsThemeKind.dark => dsHsl(0, 0, 0),
      };

  _BloomInk _ink(DsThemeData theme) {
    final bool light = theme.kind == DsThemeKind.light;
    final double l = light ? _lightL : _darkL;
    final double c = light ? _lightC : _darkC;
    final double lift = light ? _lightLift : _darkLift;
    final double hotC = light ? _lightHotC : _darkHotC;

    Color relit(Color source) {
      final ({double l, double c, double h}) from = DsOklab.toOklch(source);
      return DsOklab.fromOklch(from.l * l, from.c * c, from.h);
    }

    final Color core = relit(bloom2(theme));
    final ({double l, double c, double h}) coreLch = DsOklab.toOklch(core);

    return _BloomInk(
      core: core,
      glow: relit(bloom1(theme)),
      // `calc(l + (1 - l) * var(--bloom-lift))` on the core's own lightness.
      hot: DsOklab.fromOklch(
        coreLch.l + (1 - coreLch.l) * lift,
        coreLch.c * hotC,
        coreLch.h,
      ),
      voidInk: voidFor(theme.kind),
      opacity: light ? _lightOpacity : _darkOpacity,
      blend: blendFor(theme.kind),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return ClipRRect(
      // `overflow: hidden` — *"the bloom needs something to clip against."*
      borderRadius: radius,
      child: CustomPaint(
        painter: _BloomPainter(fill: fill, ink: _ink(theme)),
        child: child,
      ),
    );
  }
}

class _BloomPainter extends CustomPainter {
  const _BloomPainter({required this.fill, required this.ink});

  final Color fill;
  final _BloomInk ink;

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
      old.fill != fill || old.ink != ink;
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
