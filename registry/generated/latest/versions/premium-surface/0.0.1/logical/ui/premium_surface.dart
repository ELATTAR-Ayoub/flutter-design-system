/// `premium-surface` — the premium Button's surface (`app/globals.css` L1948–2040),
/// with `@keyframes value-foil-drift` (L1915–1928) and `@keyframes value-glint`
/// (L1930–1946).
///
/// The utility's own comment says what it is after: *"The premium button's
/// surface, in whatever the value ramp currently is — lime today. Three parts,
/// because real metal has three."*
///
/// 1. **The metal ramp** — the element's `background-image`, a seven-stop
///    `linear-gradient(176deg, …)`: light, dark, light, with a darker band
///    across the middle. *"That band is the edge of the metal, and it is what
///    separates a foil from 'a coloured rectangle'."*
/// 2. **The foil** (`::after`) — striations plus a broad sheen at
///    `opacity: 0.95` on `mix-blend-mode: soft-light`, drifting *"slowly and
///    forever … so it keeps its hue rather than bleaching."*
/// 3. **The glint** (`::before`) — one narrow, very bright band on
///    `mix-blend-mode: screen` that idles for just over half its cycle and then
///    crosses. *"So it reads as light catching the surface rather than as a
///    loop."*
///
/// **Every stop is derived, none is frozen — including the four that
/// shadows-map §5.4 prints as bare hex.** The map resolved those four for its
/// own readers; the stylesheet writes every one of them as `color-mix(in oklab,
/// var(--color-value-bright) N%, white)` — the sheen's peak 95% at L2014, the
/// corner light 75% at L2020, the glint's shoulders 45% at L1985/L1987 and its
/// core 15% at L1986 — so they are computed here from [Palette] through
/// [OklabColor.mix] like every other stop, and a rebrand of the value ramp carries
/// through this file untouched. Each derivation was checked against the map's
/// hex and lands on it exactly; no hex from that table appears in `lib/`.
/// `color-mix(…, X N%, transparent)` is the same colour at `N%` alpha
/// (colors.dart L110–115), so the striations are [Palette.valueBright] at an
/// alpha rather than the `rgba(217,249,157,…)` a devtools readout shows.
///
/// **Painting order.** CSS paints a box in one fixed order: outer `box-shadow`,
/// `background-color`, `background-image`, inset `box-shadow`, border, inline
/// content, then positioned `::before`/`::after`. [Surface.fill] is a
/// flat [Color] and cannot carry a gradient, so the ramp is spliced in from
/// outside by a [Stack] whose children are that list in that order: the outer
/// shadows, the ramp, the surface (inset shadows, border, label), then the two
/// blended pseudo-layers. Only the surface is a non-positioned child, so it is
/// what the [Stack] measures itself against; the other three are
/// [Positioned.fill] and follow it. That last step — pseudo-layers after inline
/// content — is why the foil and the glint composite over the label rather than
/// under it, and `::before` paints before `::after` because both are
/// `z-index: auto` and positioned descendants paint in tree order.
///
/// **Blending.** `isolate` on the Button makes its `mix-blend-mode` layers
/// composite against the button's own surface rather than against the page
/// (shadows-map §13.4). Here that falls out of the paint order rather than
/// needing a copy of the backdrop: the ramp is opaque, it went into the same
/// canvas moments earlier, and every layer is clipped to the same rounded rect,
/// so the destination under a blend op IS the button's own surface. What each
/// pseudo-element does need is a **group**: `mix-blend-mode` and `opacity`
/// apply to the pseudo-element as a whole, so its three background layers
/// composite among themselves with source-over first and the result blends
/// once. That is one [Canvas.saveLayer] per pseudo-element carrying the blend
/// mode and the opacity — deliberately not a blend mode per background layer,
/// which would blend each one into the last and is a different picture.
///
/// The one thing that arrangement forbids is a [RepaintBoundary] *between* the
/// ramp and the blended layers: a boundary hands them a compositing layer of
/// their own, their destination becomes transparent black, and soft-light
/// against nothing is just the source. The boundary therefore goes around the
/// whole widget, where it still stops a perpetually drifting button from
/// repainting the page.
///
/// **Both loops run off ONE elapsed clock, and the glint's hover retiming
/// therefore JUMPS — measured** (see [PremiumSurface.phaseAt]). CSS keeps an
/// animation's elapsed `currentTime` across a change to `animation-duration`
/// and re-divides it; it does not preserve the phase. `premium-surface:hover::before`
/// changes nothing but the duration — 5.5s → 2.4s — so the glint teleports to
/// wherever the same elapsed time lands on the shorter timeline. The port used
/// to resume the controller from its current phase, which continues smoothly
/// and is a different animation.
///
/// **Reduced motion.** Both loops re-read their period through
/// [effectiveMotionDuration] on each build, so under `MediaQuery.disableAnimations`
/// they get [Duration.zero], stop, and paint frame 0 — the glint invisible at
/// `opacity: 0`, the foil at the drift's opening offsets. That is the port of
/// the reference's blanket `prefers-reduced-motion` rule (globals.css
/// L2533–2541), not a divergence from it: that rule collapses **every**
/// animation on the page to 0.01ms at `animation-iteration-count: 1`, the foil
/// included, and with no `animation-fill-mode` the element falls back to its
/// base style. (One hair's breadth of difference: the CSS base style declares
/// no `background-position` at all, so a browser lands the second foil layer at
/// `0%` where frame 0 puts it at `-60%`. Frame 0 is what freezes here, because
/// "the first frame of the animation" is the honest still of an animation.)
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart' show Ticker;
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import '../../design_system/foundation/colors.dart';
import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/shadows.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/theme_scope.dart';
import './surface.dart';

/// The CSS keyword `white`, the far side of five `color-mix()` stops here.
///
/// Spelled through [hslColor] rather than as a hex so it arrives by the same
/// converter every other colour in the port does.
final Color _white = hslColor(0, 0, 100);

// ── The utility's own geometry ───────────────────────────────────────────────
// Angles, sizes and stop positions belonging to this one effect. No other
// surface in the system refers to them, so they live with the effect that owns
// them rather than in `foundation/` — the same call `background_effect.dart` makes for
// the body glow.
//
// allow-hardcoded: premium-surface gradient geometry (globals.css L1964–2030)

/// `background-image: linear-gradient(176deg, …)` — the metal ramp
/// (L1964–1973).
const double _rampAngle = 176;

/// `background-size: 170% 100%, 210% 100%, 100% 100%` on `::after`
/// (L2023–2026), and the `50%` every layer holds vertically. All three images
/// are exactly as tall as the button, so that `50%` resolves to no offset at
/// all — it is carried because the keyframes carry it.
const List<double> _foilSizes = <double>[1.70, 2.10, 1.00];
const double _foilPosY = 0.50;

/// `repeating-linear-gradient(104deg, … 0 1px, transparent 1px 5px)` — 1px
/// striations on a **5px** pitch (L2006–2010). The sheen's are on 7px; this is
/// metal, and it is meant to read finer.
const double _striationAngle = 104;
const double _striationWidth = 1;
const double _striationPitch = 5;

/// `linear-gradient(100deg, transparent 30%, … 46%, … 54%, transparent 70%)` —
/// the broad sheen (L2011–2017).
const double _sheenAngle = 100;
const double _sheenIn = 0.30;
const double _sheenPeak = 0.46;
const double _sheenTail = 0.54;
const double _sheenOut = 0.70;

/// `radial-gradient(130% 170% at 22% -10%, …, transparent 62%)` — the corner
/// light (L2018–2022).
const double _cornerRadiusX = 1.30;
const double _cornerRadiusY = 1.70;
const double _cornerCentreX = 0.22;
const double _cornerCentreY = -0.10;
const double _cornerFade = 0.62;

/// The glint's `linear-gradient(104deg, …)` and its `background-size: 260%
/// 100%` (L1982–1990) — a band drawn across a box two and a half times the
/// button's width, so only a slice of it is ever on screen.
const double _glintAngle = 104;
const double _glintWidth = 2.60;
const double _glintIn = 0.38;
const double _glintEdgeLead = 0.46;
const double _glintCore = 0.50;
const double _glintEdgeTail = 0.54;
const double _glintOut = 0.62;

// ── The utility's own alphas and mixes ──────────────────────────────────────

/// The striations' ink — `--color-value-bright` 80% (L2008), i.e. that colour
/// at 0.80 alpha.
const double _striationAlpha = 0.80;

/// The sheen's brightest stop, `color-mix(in oklab, --color-value-bright 95%,
/// white)` (L2014), and its tail, `--color-value-bright` 60% (L2015) — one a
/// mix toward white, the other a mix toward transparent.
const double _sheenPeakMix = 0.95;
const double _sheenTailAlpha = 0.60;

/// The corner light — `color-mix(in oklab, --color-value-bright 75%, white)`
/// (L2020).
const double _cornerMix = 0.75;

/// The glint's shoulders and its core — `--color-value-bright` mixed 45% and
/// **15%** toward white (L1985–1987). The lower the mix, the more white: the
/// core is the brightest colour in the system.
const double _glintEdgeMix = 0.45;
const double _glintCoreMix = 0.15;

/// The premium Button's surface: metal ramp, drifting foil, sweeping glint,
/// wrapped around [child].
///
/// Takes the same [ShadowStyle], [BorderRadius] and [BoxBorder] a
/// [Surface] would, and splices the ramp in where CSS puts it. The
/// caller stays in charge of which spec is live — `--shadow-btn-value` at rest,
/// `--shadow-glow-value` on hover, `--shadow-btn-down` while pressed, any of
/// them already carrying a prepended focus-ring layer — because that state
/// table belongs to the Button, not to its surface.
class PremiumSurface extends StatefulWidget {
  const PremiumSurface({
    super.key,
    required this.spec,
    required this.radius,
    this.border,
    this.hovered = false,
    required this.child,
  });

  /// The `--shadow-*` token to paint: outer layers under the ramp, inset layers
  /// over it.
  final ShadowStyle spec;

  /// The shape. The ramp, both pseudo-layers and the inset shadows are all
  /// clipped to it — `border-radius: inherit` on the pseudo-elements, and
  /// `overflow-hidden` on the Button itself.
  final BorderRadius radius;

  /// `border border-transparent` on the Button — a real 1px border that costs
  /// a pixel of inner width, painted over the inset shadows.
  final BoxBorder? border;

  /// `:hover` — *"Hover pushes the metal: the glint runs more often and the
  /// foil brightens"* (L2033).
  final bool hovered;

  final Widget child;

  /// The ramp's seven stops, oklab-mixed from [Palette] exactly as
  /// `linear-gradient(176deg, …)` does (L1964–1973).
  ///
  /// `176deg` is 4° off straight down — CSS measures gradient angles clockwise
  /// from "to top", so 180° is top-to-bottom and 176° tilts that 4°
  /// counter-clockwise.
  ///
  /// **The 52% band is contrast-critical and per-brand. Do not adjust it.** It
  /// is the edge of the metal and the worst-case stop under the foil's ink;
  /// 42% of `--color-value-dark` is the figure measured *for lime*, which is a
  /// high-luminance hue. The stylesheet records what happens to a darker ramp
  /// at the same depth (L1956–1958): 4.11:1, *"a premium button whose label
  /// fails AA across the band running through its middle"*, needing 30%
  /// instead. Re-measure after any change to the value ramp — no guard can, and
  /// the failure looks exactly like a design choice.
  @visibleForTesting
  static final List<Color> rampColors = <Color>[
    OklabColor.mix(Palette.valueBright, _white, 0.94),
    Palette.valueBright,
    Palette.value,
    OklabColor.mix(Palette.valueDark, Palette.value, 0.42),
    Palette.value,
    Palette.valueBright,
    OklabColor.mix(Palette.valueBright, _white, 0.90),
  ];

  /// Where [rampColors] sit, as the `0..1` fractions Skia wants rather than the
  /// `0% 22% 44% 52% 62% 88% 100%` the stylesheet writes.
  @visibleForTesting
  static const List<double> rampStops = <double>[
    0,
    0.22,
    0.44,
    0.52,
    0.62,
    0.88,
    1,
  ];

  /// `::after { mix-blend-mode: soft-light }` (L2028) — the foil keeps the
  /// ramp's hue instead of bleaching it.
  static const BlendMode foilBlend = BlendMode.softLight;

  /// `::before { mix-blend-mode: screen }` (L1993), in **both** themes.
  ///
  /// The stylesheet says so where the theme-dependent blends are collected
  /// (L3297–3300), and gives the reason: the metal ramp is opaque, so the foil
  /// *"is its own base rather than a layer over the page"* and never needs the
  /// multiply/screen split `action-feedback::before` needs. It is listed there
  /// only so that whoever checks "which effects are theme-dependent" finds the
  /// answer in one place: this one is not.
  static const BlendMode glintBlend = BlendMode.screen;

  /// `::after { opacity: 0.95 }` (L2029), and `:hover::after { opacity: 1 }`
  /// (L2037–2039).
  ///
  /// It **snaps**. `transition` is not an inherited property and the
  /// pseudo-element declares none, so the Button's own `btn-spring` does not
  /// reach it — shadows-map §10 row 4 credits that transition, but a browser
  /// steps this one. Nothing is lost: it is 0.05 of opacity on a soft-light
  /// layer.
  @visibleForTesting
  static const double foilOpacity = 0.95;
  @visibleForTesting
  static const double foilHoverOpacity = 1;

  /// `@keyframes value-foil-drift`'s three `background-position` tracks at 0%
  /// and 100% (L1915–1928), as the CSS percentages.
  ///
  /// ```css
  /// 0%   { background-position: 0%   50%, -60% 50%, 50% 50%; }
  /// 100% { background-position: 140% 50%, 160% 50%, 50% 50%; }
  /// ```
  ///
  /// Layer 3 — the corner light — is **stationary**: same value at both ends.
  /// Layers 1 and 2 travel 140 and 220 percentage points of their own sizing
  /// box, and because each image is wider than the button
  /// (`(box − image) × percentage`, see [_imageRect]) a rising percentage walks
  /// them left.
  @visibleForTesting
  // allow-hardcoded: value-foil-drift keyframes (globals.css L1915–1928)
  static const List<double> driftFrom = <double>[0, -0.60, 0.50];
  @visibleForTesting
  // allow-hardcoded: value-foil-drift keyframes (globals.css L1915–1928)
  static const List<double> driftTo = <double>[1.40, 1.60, 0.50];

  /// Where background layer [layer] sits at drift progress [t].
  ///
  /// A plain lerp because `value-foil-drift` is declared `linear` (L2030) —
  /// **no curve at all**. The controller's raw value drives it; there is no
  /// [CurvedAnimation] anywhere near this, and `MotionCurves` has no `linear`
  /// member to reach for by mistake.
  @visibleForTesting
  static double driftPosition(int layer, double t) =>
      driftFrom[layer] + (driftTo[layer] - driftFrom[layer]) * t;

  /// `@keyframes value-glint`'s `background-position` track (L1930–1946), as
  /// the CSS percentage.
  ///
  /// ```css
  /// 0%, 54% { background-position: 135% 50%; opacity: 0; }
  /// 60%     { opacity: 1; }
  /// 94%     { opacity: 1; }
  /// 100%    { background-position: -55% 50%; opacity: 0; }
  /// ```
  ///
  /// Position is declared at 0, 54 and 100 only, so it **holds** at 135% for
  /// the first 54% of the cycle and then sweeps to −55% across the remaining
  /// 46% on `--ease-in-out`. The band is idle for just over half of every pass.
  ///
  /// **Which way it crosses.** 135% → −55% is a falling number, and it is
  /// tempting to read that as travel to the left; it is not. A background
  /// percentage offsets by `(box − image) × percentage`, and this image is
  /// 260% of the box, so the multiplier is negative: the falling percentage
  /// walks the image **right**, and the bright band enters at the button's left
  /// edge and leaves at its right. (shadows-map §5.4 reads it the other way.
  /// The arithmetic above is what a browser runs.)
  @visibleForTesting
  static final Animatable<double> glintPosition = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      // allow-hardcoded: value-glint keyframes (globals.css L1930–1946)
      TweenSequenceItem<double>(tween: ConstantTween<double>(1.35), weight: 54),
      // allow-hardcoded: value-glint keyframes
      _glintStep(1.35, -0.55, 46),
    ],
  );

  /// `@keyframes value-glint`'s `opacity` track — the ramp up over 54→60% and
  /// back down over 94→100% that keeps the band from appearing mid-air.
  ///
  /// Weights are the gaps between the declared percentages, and each moving
  /// segment carries `--ease-in-out` of its own: that is what a CSS
  /// `animation-timing-function` does — it eases *between* keyframes, not
  /// across the run.
  @visibleForTesting
  static final Animatable<double> glintOpacity = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      // allow-hardcoded: value-glint keyframes (globals.css L1930–1946)
      TweenSequenceItem<double>(tween: ConstantTween<double>(0), weight: 54),
      // allow-hardcoded: value-glint keyframes
      _glintStep(0, 1, 6),
      // allow-hardcoded: value-glint keyframes
      TweenSequenceItem<double>(tween: ConstantTween<double>(1), weight: 34),
      // allow-hardcoded: value-glint keyframes
      _glintStep(1, 0, 6),
    ],
  );

  /// Where an `infinite` animation stands after [elapsed], at the duration it
  /// is *currently* declared at — the B10b ruling, as arithmetic.
  ///
  /// A CSS animation has one clock and it counts **elapsed time**. Changing
  /// `animation-duration` on a running animation neither restarts it nor keeps
  /// it where it visually was: the browser divides the same elapsed time by the
  /// new duration and paints whatever frame that lands on.
  ///
  /// **Recorded ruling: the retiming jump is the reference's own.** The port
  /// used to keep the phase — `c.duration = period; c.repeat();` resumes an
  /// [AnimationController] from its normalised value — on the argument that a
  /// smooth glint is what light on metal looks like. A browser does something
  /// else, and it was traced doing it (behaviour-audit §3.7, B10b):
  /// `pointerover` at t=1214.8 switches `animation-duration` 5.5s → 2.4s
  /// without restarting the animation, so the same elapsed time is divided by
  /// the new duration, and in the **very next frame** the glint went from
  /// `opacity 0.0000, background-position 135%` — idling, invisible, parked at
  /// the right — to `opacity 1.0000, −49.86%`, fully bright and almost off the
  /// left edge. It finished that sweep in ~210ms and then idled 1268ms, which
  /// is 54% of 2400ms to the millisecond. That pop is real reference behaviour,
  /// not an artifact of the probe.
  ///
  /// The drift is on the same clock and reads the same way; it simply never
  /// changes duration (`11s` hovered or not, measured), so it never jumps.
  @visibleForTesting
  static double phaseAt(Duration elapsed, Duration period) {
    final int t = elapsed.inMicroseconds;
    final int d = period.inMicroseconds;
    if (d <= 0 || t <= 0) return 0;
    return (t % d) / d;
  }

  @override
  State<PremiumSurface> createState() => _FoilValueState();
}

/// One `value-glint` keyframe gap, on `--ease-in-out`. The shape
/// `active_indicator.dart` uses for `yuki-jelly` (L257–262).
TweenSequenceItem<double> _glintStep(double from, double to, double weight) =>
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: from,
        end: to,
      ).chain(CurveTween(curve: MotionCurves.move)),
      weight: weight,
    );

class _FoilValueState extends State<PremiumSurface>
    with SingleTickerProviderStateMixin {
  /// **One clock for both pseudo-elements**, and the reason it is a bare
  /// [Ticker] rather than two [AnimationController]s: what a browser preserves
  /// across a change to `animation-duration` is elapsed time, and a [Ticker]
  /// hands that over directly. Neither animation is ever restarted — both are
  /// `infinite` and both have been running since the element was rendered — so
  /// there is exactly one number to keep, and this is it.
  ///
  /// Built in [initState] rather than lazily: under reduced motion the clock
  /// never starts, and a `late final` would then be created for the first time
  /// inside [dispose], where the [TickerMode] lookup it needs is no longer
  /// legal.
  late final Ticker _clock;

  /// Both animations' `currentTime`, and the repaint trigger for the shared
  /// painter (`::after` blends over `::before`'s result, so they paint
  /// together).
  final ValueNotifier<Duration> _elapsed = ValueNotifier<Duration>(
    Duration.zero,
  );

  /// Whether the clock is running. It stops for exactly one reason — reduced
  /// motion — because both of these animations are `infinite` and have no
  /// resting state.
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _clock = createTicker(_onTick);
  }

  @override
  void dispose() {
    _clock.dispose();
    _elapsed.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) => _elapsed.value = elapsed;

  /// Starts or stills the shared clock. Where the two animations stand once it
  /// is running is [PremiumSurface.phaseAt], which is where the B10b ruling is
  /// recorded.
  void _run(bool running) {
    if (running == _running) return;
    _running = running;
    if (running) {
      _clock.start();
      return;
    }
    _clock.stop();
    _elapsed.value = Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    final Duration driftPeriod = effectiveMotionDuration(
      context,
      MotionDurations.foilDrift,
    );
    final Duration glintPeriod = effectiveMotionDuration(
      context,
      widget.hovered ? MotionDurations.glintHover : MotionDurations.glint,
    );
    _run(driftPeriod > Duration.zero || glintPeriod > Duration.zero);

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
          // 2 — `background-image`: the metal ramp.
          Positioned.fill(
            child: ClipRRect(
              borderRadius: widget.radius,
              child: const CustomPaint(painter: _RampPainter()),
            ),
          ),
          // 3 — inset `box-shadow`, border, then inline content. The one
          // non-positioned child, so the Stack takes its size from here.
          Surface(
            spec: ShadowStyle(widget.spec.insetLayers),
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
                  animation: _elapsed,
                  builder: (BuildContext context, Widget? _) => CustomPaint(
                    painter: _PseudoPainter(
                      drift: PremiumSurface.phaseAt(
                        _elapsed.value,
                        driftPeriod,
                      ),
                      glint: PremiumSurface.phaseAt(
                        _elapsed.value,
                        glintPeriod,
                      ),
                      opacity: widget.hovered
                          ? PremiumSurface.foilHoverOpacity
                          : PremiumSurface.foilOpacity,
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
          PremiumSurface.rampColors,
          PremiumSurface.rampStops,
        ),
    );
  }

  /// Nothing here depends on state: the stops come from [Palette], which does
  /// not flip with the theme. The value ramp is the one surface in the system
  /// that looks the same on a white page as on a black one.
  @override
  bool shouldRepaint(_RampPainter old) => false;
}

/// `::before` then `::after`, in that order.
///
/// Tree order decides it: both pseudo-elements are `position: absolute` at
/// `z-index: auto`, so they paint as positioned descendants in the order they
/// appear in the box tree — the glint first, the foil soft-lighting over it.
class _PseudoPainter extends CustomPainter {
  const _PseudoPainter({
    required this.drift,
    required this.glint,
    required this.opacity,
  });

  /// `value-foil-drift` progress, `0..1`, linear.
  final double drift;

  /// `value-glint` progress, `0..1`. The easing is inside the animatables.
  final double glint;

  /// `::after`'s own opacity — [PremiumSurface.foilOpacity], or
  /// [PremiumSurface.foilHoverOpacity] while hovered.
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final Rect box = Offset.zero & size;
    _paintGlint(canvas, box);
    _paintFoil(canvas, box);
  }

  /// `::before` — one band on a 260%-wide image, screened, at the keyframe's
  /// opacity and position.
  void _paintGlint(Canvas canvas, Rect box) {
    final double alpha = PremiumSurface.glintOpacity.transform(glint);
    if (alpha <= 0) return;

    final Rect image = _imageRect(
      box,
      sizeX: _glintWidth,
      sizeY: 1,
      posX: PremiumSurface.glintPosition.transform(glint),
      posY: _foilPosY,
    );
    final (Offset from, Offset to) = _gradientLine(_glintAngle, image);
    final Color edge = OklabColor.mix(
      Palette.valueBright,
      _white,
      _glintEdgeMix,
    );

    // `opacity` and `mix-blend-mode` are the pseudo-element's, so they apply to
    // the finished layer rather than to the gradient inside it. The layer's
    // bounds are the button's box, which is also `overflow-hidden`.
    canvas.saveLayer(box, _groupPaint(alpha, PremiumSurface.glintBlend));
    canvas.drawRect(
      image,
      Paint()
        ..shader = ui.Gradient.linear(
          from,
          to,
          <Color>[
            // `transparent` next to a colour keeps that colour's hue: browsers
            // interpolate gradient stops premultiplied, where a zero-alpha stop
            // contributes no colour at all (`background_effect.dart` L109–117).
            edge.withValues(alpha: 0),
            edge,
            OklabColor.mix(Palette.valueBright, _white, _glintCoreMix),
            edge,
            edge.withValues(alpha: 0),
          ],
          const <double>[
            _glintIn,
            _glintEdgeLead,
            _glintCore,
            _glintEdgeTail,
            _glintOut,
          ],
        ),
    );
    canvas.restore();
  }

  /// `::after` — three background layers under one group alpha and one
  /// soft-light blend.
  void _paintFoil(Canvas canvas, Rect box) {
    canvas.saveLayer(box, _groupPaint(opacity, PremiumSurface.foilBlend));
    // CSS paints the FIRST-listed background layer on top, so the three are
    // walked backwards — the same reversal `ShadowStyle.outerShadows` makes.
    _paintCorner(canvas, box);
    _paintSheen(canvas, box);
    _paintStriations(canvas, box);
    canvas.restore();
  }

  /// Layer 3 — `radial-gradient(130% 170% at 22% -10%, …)` at
  /// `background-size: 100% 100%`. The stationary one.
  void _paintCorner(Canvas canvas, Rect box) {
    final Rect image = _imageRect(
      box,
      sizeX: _foilSizes[2],
      sizeY: 1,
      posX: PremiumSurface.driftPosition(2, drift),
      posY: _foilPosY,
    );
    final Color light = OklabColor.mix(Palette.valueBright, _white, _cornerMix);
    canvas.drawRect(
      image,
      Paint()
        ..shader = _radialShader(
          image,
          radiusX: _cornerRadiusX,
          radiusY: _cornerRadiusY,
          centreX: _cornerCentreX,
          centreY: _cornerCentreY,
          colors: <Color>[light, light.withValues(alpha: 0)],
          stops: const <double>[0, _cornerFade],
        ),
    );
  }

  /// Layer 2 — `linear-gradient(100deg, …)` at `background-size: 210% 100%`,
  /// travelling 220 percentage points of that box across the cycle.
  void _paintSheen(Canvas canvas, Rect box) {
    final Rect image = _imageRect(
      box,
      sizeX: _foilSizes[1],
      sizeY: 1,
      posX: PremiumSurface.driftPosition(1, drift),
      posY: _foilPosY,
    );
    final (Offset from, Offset to) = _gradientLine(_sheenAngle, image);
    final Color peak = OklabColor.mix(
      Palette.valueBright,
      _white,
      _sheenPeakMix,
    );
    canvas.drawRect(
      image,
      Paint()
        ..shader = ui.Gradient.linear(
          from,
          to,
          <Color>[
            peak.withValues(alpha: 0),
            peak,
            Palette.valueBright.withValues(alpha: _sheenTailAlpha),
            Palette.valueBright.withValues(alpha: 0),
          ],
          const <double>[_sheenIn, _sheenPeak, _sheenTail, _sheenOut],
        ),
    );
  }

  /// Layer 1 — `repeating-linear-gradient(104deg, … 0 1px, transparent
  /// 1px 5px)` at `background-size: 170% 100%`.
  void _paintStriations(Canvas canvas, Rect box) {
    final Rect image = _imageRect(
      box,
      sizeX: _foilSizes[0],
      sizeY: 1,
      posX: PremiumSurface.driftPosition(0, drift),
      posY: _foilPosY,
    );
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
            Palette.valueBright.withValues(alpha: _striationAlpha),
            Palette.valueBright.withValues(alpha: _striationAlpha),
            Palette.valueBright.withValues(alpha: 0),
            Palette.valueBright.withValues(alpha: 0),
          ],
          <double>[0, duty, duty, 1],
          TileMode.repeated,
        ),
    );
  }

  @override
  bool shouldRepaint(_PseudoPainter old) =>
      old.drift != drift || old.glint != glint || old.opacity != opacity;
}

// ── CSS background painting ─────────────────────────────────────────────────
// Flutter has no repeating-gradient primitive and no `background-size` /
// `background-position` model, so these four helpers are what stands in for
// them. `action_feedback.dart` carries the same four verbatim: the plan's
// ownership list has no home for a shared file, and duplication that both sides
// document beats an unowned third file.

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
/// Sizes are fractions of the element's box (`210% 100%` → `sizeX: 2.1`).
/// Positions are the CSS percentages: a percentage aligns that point of the
/// image with the same point of the box, which works out to
/// `offset = (box − image) × percentage`. With an image wider than its box that
/// subtraction is negative, so a rising percentage walks the image **left** —
/// which is how `value-foil-drift` makes the foil travel, and why the glint's
/// falling percentage sends it the other way.
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
  ..color = transparent.withValues(alpha: opacity);

/// CSS `radial-gradient(<rx> <ry> at <cx> <cy>, …)`, every value a fraction of
/// [box]'s own width or height.
///
/// [ui.Gradient.radial] takes a single scalar radius and cannot describe a
/// two-radius ellipse, so a unit circle is mapped onto the ellipse by a matrix
/// instead — the trick `background_effect.dart` L119–128 documents.
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
