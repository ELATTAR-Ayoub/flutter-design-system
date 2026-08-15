/// `sheen-action` — the default Button's surface (`app/globals.css`
/// L2090–2160), its `@keyframes action-beat` (L2059–2088), and the one blend
/// mode in the system that flips with the theme (L3289–3295).
///
/// The utility's own comment sets the brief: *"The default button's surface.
/// Quieter than the value foil on purpose — the primary action should be
/// interesting, not precious."* Three parts, only one of which moves at rest:
///
/// 1. **The ramp** — the element's own `background-image`, a five-stop
///    `linear-gradient(176deg, …)`. Static and opaque; it covers the
///    `bg-primary` fill beneath it completely, which is why this widget takes
///    no fill of its own.
/// 2. **The texture** (`::after`) — three background layers at `opacity: 0.75`
///    through `mix-blend-mode: soft-light`, held STATIC because *"default
///    buttons appear many times per screen, and a permanently animating one
///    would break the rule that only the live indicator moves forever."*
/// 3. **The beat** (`::before`) — an ellipse expanding from the centre in a
///    double thump on hover, fired once on press.
///
/// **Every stop is derived, none is frozen.** The stylesheet writes each one as
/// `color-mix(in oklab, …)`, so each is computed here from [DsPalette] through
/// [DsOklab.mix] rather than pasted in as the hex it happens to resolve to
/// today. The values shadows-map §5.3 resolves for the three mixed stops are
/// verification targets, not source — a rebrand of the action ramp has to carry
/// through this file untouched, and no hex from that table appears in `lib/`.
/// `color-mix(…, X N%, transparent)` is the same colour at `N%` alpha
/// (colors.dart L110–115), so the texture's inks are [DsPalette.actionBright]
/// at an alpha, never an `rgba()` literal.
///
/// **Painting order.** CSS paints a box in one fixed order: outer
/// `box-shadow`, `background-color`, `background-image`, inset `box-shadow`,
/// border, inline content, then positioned `::before`/`::after`.
/// [DsMachineSurface.fill] is a flat [Color] and cannot carry a gradient, so
/// the ramp is spliced in from outside by a [Stack] whose children are that
/// list in that order: the outer shadows, the ramp, the surface (inset shadows,
/// border, label), then the two blended pseudo-layers. Only the surface is a
/// non-positioned child, so it is what the [Stack] measures itself against; the
/// other three are [Positioned.fill] and follow it. That last step — pseudo-
/// layers after inline content — is why the texture and the beat composite over
/// the label rather than under it.
///
/// **Blending.** `isolate` on the Button makes its `mix-blend-mode` layers
/// composite against the button's own surface rather than against the page
/// (shadows-map §13.4). Here that falls out of the paint order rather than
/// needing a copy of the backdrop: the ramp is opaque, it went into the same
/// canvas moments earlier, and every layer is clipped to the same rounded rect,
/// so the destination under a blend op IS the button's own surface. What each
/// pseudo-element does need is a **group**: `mix-blend-mode` and `opacity`
/// apply to the pseudo-element as a whole, so its background layers composite
/// among themselves with source-over first and the result blends once. That is
/// one [Canvas.saveLayer] per pseudo-element carrying the blend mode and the
/// opacity — deliberately not a blend mode per background layer, which would
/// blend each one into the last and is a different picture.
///
/// The one thing that arrangement forbids is a [RepaintBoundary] *between* the
/// ramp and the blended layers: a boundary hands them a compositing layer of
/// their own, their destination becomes transparent black, and soft-light
/// against nothing is just the source. The boundary therefore goes around the
/// whole widget, where it still stops an animating button from repainting the
/// page.
///
/// **Reduced motion.** Every duration is re-read through [dsAnimationDuration]
/// on each build, so under `MediaQuery.disableAnimations` the beat's period is
/// [Duration.zero] and it freezes at frame 0 — `opacity: 0; scale(0.55)`, which
/// is invisible. That is the port of the reference's blanket
/// `prefers-reduced-motion` rule (globals.css L2533–2541), not a divergence
/// from it: that rule collapses every animation to 0.01ms at
/// `animation-iteration-count: 1`, and with no `animation-fill-mode` the
/// element falls back to its base style — which for `::before` is exactly
/// frame 0.
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/theme.dart';
import '../theme_scope.dart';
import 'machine_surface.dart';

// ── The utility's own geometry ───────────────────────────────────────────────
// Angles, sizes and stop positions belonging to this one effect. No other
// surface in the system refers to them, so they live with the effect that owns
// them rather than in `foundation/` — the same call `page_glow.dart` makes for
// the body glow.
//
// allow-hardcoded: sheen-action gradient geometry (globals.css L2093–2160)

/// `background-image: linear-gradient(176deg, …)` — the ramp (L2093–2100).
const double _rampAngle = 176;

/// `repeating-linear-gradient(104deg, … 0 1px, transparent 1px 7px)` — 1px
/// striations on a 7px pitch, the first of the texture's three layers.
const double _striationAngle = 104;
const double _striationWidth = 1;
const double _striationPitch = 7;

/// `linear-gradient(100deg, transparent 28%, … 48%, transparent 68%)` — one
/// broad diagonal sheen, `background-size: 190% 100%`.
const double _diagonalAngle = 100;
const double _diagonalWidth = 1.90;
const double _diagonalIn = 0.28;
const double _diagonalPeak = 0.48;
const double _diagonalOut = 0.68;

/// `radial-gradient(120% 150% at 24% -20%, …, transparent 60%)` — a corner
/// light, `background-size: 100% 100%`.
const double _cornerRadiusX = 1.20;
const double _cornerRadiusY = 1.50;
const double _cornerCentreX = 0.24;
const double _cornerCentreY = -0.20;
const double _cornerFade = 0.60;

/// `radial-gradient(ellipse 46% 130% at 50% 50%, …, … 55%, transparent 72%)` —
/// the beat's ellipse, taller than the button on purpose: the box it is drawn
/// in clips it top and bottom, so what shows is a band, not an egg.
const double _beatRadiusX = 0.46;
const double _beatRadiusY = 1.30;
const double _beatCentre = 0.50;
const double _beatMid = 0.55;
const double _beatFade = 0.72;

// ── The utility's own alphas ────────────────────────────────────────────────
// `color-mix(in oklab, <colour> N%, transparent)` resolves to that colour at
// `N%` of its own alpha (colors.dart L110–115), so each of these is an alpha on
// `--color-action-bright` rather than the `rgba(146,194,252,…)` a devtools
// readout would show.

/// The striations' ink — `--color-action-bright` 34% (globals.css L2138).
const double _striationAlpha = 0.34;

/// The diagonal sheen's peak — `--color-action-bright` 52% (L2144).
const double _diagonalAlpha = 0.52;

/// The corner light — `--color-action-bright` 45% (L2149).
const double _cornerAlpha = 0.45;

/// `::after { opacity: 0.75 }` (L2158) — group alpha over all three layers.
const double _textureOpacity = 0.75;

/// The beat's core and its 55% stop — `--color-action-bright` at 85% and 30%
/// (L2111–2112).
const double _beatCoreAlpha = 0.85;
const double _beatMidAlpha = 0.30;

/// Which rule is driving `::before`. `:active` outranks `:hover` — Tailwind
/// orders the variants that way, and the utility declares them in that order.
enum _Beat { hover, press }

/// The `sheen-action` surface: ramp, texture, beat, wrapped around [child].
///
/// Takes the same [DsShadowSpec], [BorderRadius] and [BoxBorder] a
/// [DsMachineSurface] would, and splices the ramp in where CSS puts it. The
/// caller stays in charge of which spec is live — `--shadow-btn-primary` at
/// rest, `--shadow-btn-down` while pressed, either of them already carrying a
/// prepended focus-ring layer — because that state table belongs to the Button,
/// not to its surface.
class DsSheenAction extends StatefulWidget {
  const DsSheenAction({
    super.key,
    required this.spec,
    required this.radius,
    this.border,
    this.hovered = false,
    this.pressed = false,
    required this.child,
  });

  /// The `--shadow-*` token to paint: outer layers under the ramp, inset layers
  /// over it.
  final DsShadowSpec spec;

  /// The shape. The ramp, both pseudo-layers and the inset shadows are all
  /// clipped to it — `border-radius: inherit` on the pseudo-elements, and
  /// `overflow-hidden` on the Button itself.
  final BorderRadius radius;

  /// `border border-transparent` on the Button — a real 1px border that costs
  /// a pixel of inner width, painted over the inset shadows.
  final BoxBorder? border;

  /// `:hover` — runs the beat on a 2.6s loop.
  final bool hovered;

  /// `:active` — one 620ms beat, and it outranks [hovered].
  final bool pressed;

  final Widget child;

  /// The ramp's five stops, oklab-mixed from [DsPalette] exactly as
  /// `linear-gradient(176deg, …)` does (globals.css L2093–2100).
  ///
  /// `176deg` is 4° off straight down — CSS measures gradient angles clockwise
  /// from "to top", so 180° is top-to-bottom and 176° tilts that 4°
  /// counter-clockwise.
  @visibleForTesting
  static final List<Color> rampColors = <Color>[
    DsOklab.mix(DsPalette.actionBright, DsPalette.action, 0.20),
    DsPalette.action,
    DsOklab.mix(DsPalette.actionDark, DsPalette.action, 0.50),
    DsPalette.action,
    DsOklab.mix(DsPalette.actionBright, DsPalette.action, 0.10),
  ];

  /// Where [rampColors] sit, as the `0..1` fractions Skia wants rather than the
  /// `0% 44% 53% 76% 100%` the stylesheet writes.
  @visibleForTesting
  static const List<double> rampStops = <double>[0, 0.44, 0.53, 0.76, 1];

  /// `mix-blend-mode` for `::before` — the one blend in the system that depends
  /// on the theme (globals.css L3289–3295).
  ///
  /// The utility declares `screen`; `:root` and `.light` then override it to
  /// `multiply`, and `.dark` restates `screen`. The stylesheet gives no reason
  /// for the split, so none is invented here.
  static BlendMode beatBlendFor(DsThemeKind kind) => switch (kind) {
        DsThemeKind.light => BlendMode.multiply,
        DsThemeKind.dark => BlendMode.screen,
      };

  /// `@keyframes action-beat`'s `transform` track (globals.css L2059–2088).
  ///
  /// ```css
  /// 0%   { transform: scale(0.55); opacity: 0;    }
  /// 10%  { transform: scale(1);    opacity: 0.62; }
  /// 24%  { transform: scale(1.32); opacity: 0;    }
  /// 30%  { transform: scale(0.7);  opacity: 0;    }
  /// 40%  { transform: scale(1.06); opacity: 0.34; }
  /// 54%  { transform: scale(1.38); opacity: 0;    }
  /// 100% { transform: scale(1.38); opacity: 0;    }
  /// ```
  ///
  /// A strong beat, a weaker echo, then rest: the last segment is 46% of the
  /// cycle holding still, 1196ms of the 2600ms hover loop. Weights are the gaps
  /// between those percentages and each segment carries `--ease-out` of its
  /// own, because that is what a CSS `animation-timing-function` does — it
  /// eases *between* keyframes, and applying it once across the run would smear
  /// the double thump into a wobble.
  @visibleForTesting
  static final Animatable<double> beatScale = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      // allow-hardcoded: action-beat keyframes (globals.css L2059–2088)
      _beatStep(0.55, 1, 10),
      // allow-hardcoded: action-beat keyframes
      _beatStep(1, 1.32, 14),
      // allow-hardcoded: action-beat keyframes
      _beatStep(1.32, 0.7, 6),
      // allow-hardcoded: action-beat keyframes
      _beatStep(0.7, 1.06, 10),
      // allow-hardcoded: action-beat keyframes
      _beatStep(1.06, 1.38, 14),
      // allow-hardcoded: action-beat keyframes
      _beatStep(1.38, 1.38, 46),
    ],
  );

  /// `@keyframes action-beat`'s `opacity` track — same keyframe percentages,
  /// therefore the same weights, as [beatScale].
  @visibleForTesting
  static final Animatable<double> beatOpacity = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      // allow-hardcoded: action-beat keyframes (globals.css L2059–2088)
      _beatStep(0, 0.62, 10),
      // allow-hardcoded: action-beat keyframes
      _beatStep(0.62, 0, 14),
      // allow-hardcoded: action-beat keyframes
      _beatStep(0, 0, 6),
      // allow-hardcoded: action-beat keyframes
      _beatStep(0, 0.34, 10),
      // allow-hardcoded: action-beat keyframes
      _beatStep(0.34, 0, 14),
      // allow-hardcoded: action-beat keyframes
      _beatStep(0, 0, 46),
    ],
  );

  @override
  State<DsSheenAction> createState() => _DsSheenActionState();
}

/// One keyframe gap: from one declared value to the next, over its share of the
/// cycle, on `--ease-out`. The shape `sliding_pill.dart` uses for `yuki-jelly`
/// (L257–262).
TweenSequenceItem<double> _beatStep(double from, double to, double weight) =>
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: from, end: to)
          .chain(CurveTween(curve: DsCurves.out)),
      weight: weight,
    );

class _DsSheenActionState extends State<DsSheenAction>
    with SingleTickerProviderStateMixin {
  /// The beat. Its duration is a placeholder for construction only — [build]
  /// re-reads it through [dsAnimationDuration] on every pass, the way
  /// `DsPress` does.
  late final AnimationController _beat = AnimationController(
    vsync: this,
    duration: DsDurations.beatHover,
  );

  /// What the controller is currently running, and at what period. Null while
  /// nothing is: no pointer on the button, or reduced motion.
  _Beat? _playing;
  Duration? _period;

  @override
  void dispose() {
    _beat.dispose();
    super.dispose();
  }

  /// Starts, retimes or stops the beat.
  ///
  /// **Recorded decision.** A press restarts the animation from frame 0. A
  /// browser would not: `:hover::before` and `:active::before` name the same
  /// `animation-name`, so changing `animation-duration` retimes the running
  /// animation and keeps its elapsed time, which after a second of hovering
  /// lands the press somewhere past the end of a 620ms cycle. The utility's own
  /// comment says what the press is for — *"A press is one hard thump, not a
  /// rhythm"* — and one hard thump is what this plays.
  void _drive(_Beat? rule, Duration period) {
    if (rule == null || period == Duration.zero) {
      if (_playing != null) {
        _beat.stop();
        _playing = null;
        _period = null;
      }
      return;
    }
    if (rule == _playing && period == _period) return;
    _playing = rule;
    _period = period;
    _beat.duration = period;
    switch (rule) {
      case _Beat.hover:
        _beat.repeat();
      case _Beat.press:
        _beat.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final BlendMode blend = DsSheenAction.beatBlendFor(DsTheme.kindOf(context));

    final _Beat? rule = widget.pressed
        ? _Beat.press
        : widget.hovered
            ? _Beat.hover
            : null;
    _drive(
      rule,
      switch (rule) {
        _Beat.press => dsAnimationDuration(context, DsDurations.beatPress),
        _Beat.hover => dsAnimationDuration(context, DsDurations.beatHover),
        null => Duration.zero,
      },
    );

    return RepaintBoundary(
      // A paint-order device, not a layout one. [StackFit.passthrough] hands
      // the surface the [Stack]'s own constraints, so a Button that arrives
      // inside a `SizedBox(height: 40)` still lays its label out against 40px
      // rather than shrink-wrapping it and floating it at the top; the default
      // [StackFit.loose] would loosen that minimum away. [Alignment.topLeft]
      // then never moves anything — the sizing child *is* the stack's size —
      // and asks for no [Directionality] to say so.
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.topLeft,
        children: <Widget>[
          // 1 — outer `box-shadow`, under everything, from the border box.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: widget.radius,
                boxShadow: widget.spec.outerShadows(theme),
              ),
            ),
          ),
          // 2 — `background-image`: the ramp.
          Positioned.fill(
            child: ClipRRect(
              borderRadius: widget.radius,
              child: const CustomPaint(painter: _RampPainter()),
            ),
          ),
          // 3 — inset `box-shadow`, border, then inline content. The one
          // non-positioned child, so the Stack takes its size from here.
          DsMachineSurface(
            spec: DsShadowSpec(widget.spec.insetLayers),
            radius: widget.radius,
            border: widget.border,
            child: widget.child,
          ),
          // 4 — the positioned pseudo-elements, over the label.
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius: widget.radius,
                child: AnimatedBuilder(
                  animation: _beat,
                  builder: (BuildContext context, Widget? _) => CustomPaint(
                    painter: _PseudoPainter(
                      beat: _playing == null ? 0 : _beat.value,
                      blend: blend,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// `background-image: linear-gradient(176deg, …)` on the element itself.
class _RampPainter extends CustomPainter {
  const _RampPainter();

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final Rect box = Offset.zero & size;
    final (Offset from, Offset to) = _gradientLine(_rampAngle, box);
    canvas.drawRect(
      box,
      Paint()
        ..shader = ui.Gradient.linear(
          from,
          to,
          DsSheenAction.rampColors,
          DsSheenAction.rampStops,
        ),
    );
  }

  /// Nothing here depends on state: the stops come from [DsPalette], which does
  /// not flip with the theme.
  @override
  bool shouldRepaint(_RampPainter old) => false;
}

/// `::before` then `::after`, in that order.
///
/// Tree order decides it: both pseudo-elements are `position: absolute` at
/// `z-index: auto`, so they paint as positioned descendants in the order they
/// appear in the box tree — `::before` first, the texture over it.
class _PseudoPainter extends CustomPainter {
  const _PseudoPainter({required this.beat, required this.blend});

  /// `action-beat`'s progress, `0..1`. Zero whenever nothing is driving it,
  /// which is also frame 0 — the resting `opacity: 0; scale(0.55)`.
  final double beat;

  /// [DsSheenAction.beatBlendFor] for the live theme.
  final BlendMode blend;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final Rect box = Offset.zero & size;
    _paintBeat(canvas, box);
    _paintTexture(canvas, box);
  }

  /// `::before` — one radial gradient, scaled about its own centre, at the
  /// theme's blend mode and the keyframe's opacity.
  void _paintBeat(Canvas canvas, Rect box) {
    final double opacity = DsSheenAction.beatOpacity.transform(beat);
    if (opacity <= 0) return;
    final double scale = DsSheenAction.beatScale.transform(beat);

    // `opacity` and `mix-blend-mode` are the pseudo-element's, so they apply to
    // the finished layer rather than to the gradient inside it.
    canvas.saveLayer(box, _groupPaint(opacity, blend));
    canvas.save();
    // `transform-origin: 50% 50%`, and the element's own box scales with it —
    // which is what crops the ellipse's top and bottom.
    canvas.translate(box.center.dx, box.center.dy);
    canvas.scale(scale);
    canvas.translate(-box.center.dx, -box.center.dy);
    canvas.drawRect(
      box,
      Paint()
        ..shader = _radialShader(
          box,
          radiusX: _beatRadiusX,
          radiusY: _beatRadiusY,
          centreX: _beatCentre,
          centreY: _beatCentre,
          colors: <Color>[
            DsPalette.actionBright.withValues(alpha: _beatCoreAlpha),
            DsPalette.actionBright.withValues(alpha: _beatMidAlpha),
            DsPalette.actionBright.withValues(alpha: 0),
          ],
          stops: const <double>[0, _beatMid, _beatFade],
        ),
    );
    canvas.restore();
    canvas.restore();
  }

  /// `::after` — three background layers under one group alpha and one
  /// soft-light blend.
  void _paintTexture(Canvas canvas, Rect box) {
    canvas.saveLayer(box, _groupPaint(_textureOpacity, BlendMode.softLight));
    // CSS paints the FIRST-listed background layer on top, so the three are
    // walked backwards — the same reversal `DsShadowSpec.outerShadows` makes.
    _paintCorner(canvas, box);
    _paintDiagonal(canvas, box);
    _paintStriations(canvas, box);
    canvas.restore();
  }

  /// Layer 3 — `radial-gradient(120% 150% at 24% -20%, …)` at
  /// `background-size: 100% 100%`.
  void _paintCorner(Canvas canvas, Rect box) {
    final Rect image = _imageRect(box, sizeX: 1, sizeY: 1);
    canvas.drawRect(
      image,
      Paint()
        ..shader = _radialShader(
          image,
          radiusX: _cornerRadiusX,
          radiusY: _cornerRadiusY,
          centreX: _cornerCentreX,
          centreY: _cornerCentreY,
          colors: <Color>[
            DsPalette.actionBright.withValues(alpha: _cornerAlpha),
            DsPalette.actionBright.withValues(alpha: 0),
          ],
          stops: const <double>[0, _cornerFade],
        ),
    );
  }

  /// Layer 2 — `linear-gradient(100deg, …)` at `background-size: 190% 100%`,
  /// so the sheen is drawn across a box nearly twice the button's width and
  /// only its left half shows.
  void _paintDiagonal(Canvas canvas, Rect box) {
    final Rect image = _imageRect(box, sizeX: _diagonalWidth, sizeY: 1);
    final (Offset from, Offset to) = _gradientLine(_diagonalAngle, image);
    canvas.drawRect(
      image,
      Paint()
        ..shader = ui.Gradient.linear(
          from,
          to,
          <Color>[
            // `transparent` next to a colour keeps that colour's hue: browsers
            // interpolate gradient stops premultiplied, where a zero-alpha stop
            // contributes no colour at all (`page_glow.dart` L109–117).
            DsPalette.actionBright.withValues(alpha: 0),
            DsPalette.actionBright.withValues(alpha: _diagonalAlpha),
            DsPalette.actionBright.withValues(alpha: 0),
          ],
          const <double>[_diagonalIn, _diagonalPeak, _diagonalOut],
        ),
    );
  }

  /// Layer 1 — `repeating-linear-gradient(104deg, … 0 1px, transparent
  /// 1px 7px)` at `background-size: 100% 100%`.
  void _paintStriations(Canvas canvas, Rect box) {
    final Rect image = _imageRect(box, sizeX: 1, sizeY: 1);
    final (Offset from, Offset to) = _gradientLine(_striationAngle, image);
    // A CSS repeating gradient tiles the span between its first and last stop
    // along the gradient line. Handing Skia one tile and `TileMode.repeated`
    // is the same statement: the shader's `from`→`to` becomes the pitch.
    final Offset tile = (to - from) / (to - from).distance * _striationPitch;
    final double duty = _striationWidth / _striationPitch;
    canvas.drawRect(
      image,
      Paint()
        ..shader = ui.Gradient.linear(
          from,
          from + tile,
          <Color>[
            DsPalette.actionBright.withValues(alpha: _striationAlpha),
            DsPalette.actionBright.withValues(alpha: _striationAlpha),
            DsPalette.actionBright.withValues(alpha: 0),
            DsPalette.actionBright.withValues(alpha: 0),
          ],
          <double>[0, duty, duty, 1],
          TileMode.repeated,
        ),
    );
  }

  @override
  bool shouldRepaint(_PseudoPainter old) =>
      old.beat != beat || old.blend != blend;
}

// ── CSS background painting ─────────────────────────────────────────────────
// Flutter has no repeating-gradient primitive and no `background-size` /
// `background-position` model, so these four helpers are what stands in for
// them. `foil_value.dart` carries the same four verbatim: the plan's ownership
// list has no home for a shared file, and duplication that both sides document
// beats an unowned third file.

/// CSS `linear-gradient(<deg>, …)` → the two ends of its gradient line, in the
/// coordinates of the box the image is sized to.
///
/// CSS measures the angle **clockwise from "to top"**: `0deg` points up,
/// `90deg` right, `180deg` down. Flutter's canvas has y growing downward, so
/// "up" is `-y` and the direction is `(sin θ, -cos θ)`. The line is centred on
/// the box and long enough that the corners fall on its ends' perpendiculars —
/// `L = |W·sin θ| + |H·cos θ|` (CSS Images 3 §3.4.1) — which is what makes a
/// 176deg ramp reach its last stop exactly at the bottom edge.
///
/// Endpoints are computed in pixels rather than as an [Alignment] pair because
/// [Alignment] is a fraction of each half-extent independently: feeding it a
/// direction vector stretches the angle by the box's aspect ratio, and a 4°
/// tilt on a 130×40 button would arrive as something nearer 13°.
(Offset, Offset) _gradientLine(double degrees, Rect box) {
  final double theta = degrees * math.pi / 180;
  final double dx = math.sin(theta);
  final double dy = -math.cos(theta);
  final double length = (box.width * dx).abs() + (box.height * dy).abs();
  final Offset half = Offset(dx, dy) * (length / 2);
  return (box.center - half, box.center + half);
}

/// The rect a `background-size` / `background-position` pair puts one
/// background image in.
///
/// Sizes are fractions of the element's box (`190% 100%` → `sizeX: 1.9`).
/// Positions are the CSS percentages: a percentage aligns that point of the
/// image with the same point of the box, which works out to
/// `offset = (box − image) × percentage`. With an image wider than its box that
/// subtraction is negative, so a rising percentage walks the image **left**.
Rect _imageRect(
  Rect box, {
  required double sizeX,
  required double sizeY,
  double posX = 0,
  double posY = 0,
}) {
  final double width = box.width * sizeX;
  final double height = box.height * sizeY;
  return Rect.fromLTWH(
    box.left + (box.width - width) * posX,
    box.top + (box.height - height) * posY,
    width,
    height,
  );
}

/// A pseudo-element's `opacity` + `mix-blend-mode`, as the paint for the
/// [Canvas.saveLayer] that groups its background layers.
///
/// Only the alpha and the blend mode of this paint are read when the layer is
/// composited, so the colour it is hung on is arbitrary — `transparent` says
/// that plainly.
Paint _groupPaint(double opacity, BlendMode blend) => Paint()
  ..blendMode = blend
  ..color = dsTransparent.withValues(alpha: opacity);

/// CSS `radial-gradient(<rx> <ry> at <cx> <cy>, …)`, every value a fraction of
/// [box]'s own width or height.
///
/// [ui.Gradient.radial] takes a single scalar radius and cannot describe a
/// two-radius ellipse, so a unit circle is mapped onto the ellipse by a matrix
/// instead — the trick `page_glow.dart` L119–128 documents.
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
