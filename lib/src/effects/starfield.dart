/// `.starfield` — thirteen hand-placed sparkles and two slow sways
/// (`app/globals.css` L3364–3488).
///
/// The companion to `bloom-cosmic`: the bloom is the corner light, this is the
/// dust in it. Two clusters hang off the same corner of the same padding box —
/// a dense one on the bottom-right, a thin one on the top-right — and each
/// rocks a few degrees about the corner it is anchored to, on periods so long
/// (44s and 33s) that the movement is never a movement, only the fact that the
/// arrangement is different every time you look.
///
/// **Anchored, not tiled** (L3371–3377). Both backgrounds are `no-repeat` at
/// their natural size, so a 70px toast and a 742px alert render *the same
/// thing* in the same corner rather than a field scaled to fit. The
/// consequence is that a short host **clips** the cluster instead of shrinking
/// it, and which sparkles survive is therefore a property of the host's height
/// — see [DsStarfieldCluster.tileOriginIn]. A port that rescaled would change
/// the population.
///
/// ## Where it hangs, and the measured catch
///
/// | host | how the reference mounts it |
/// |---|---|
/// | Alert | `<span data-slot="alert-stars" class="starfield" aria-hidden/>` (`alert.tsx` L85) — the bloom already owns both of the root's pseudo-elements, so the sparkles need an element of their own. It is `position: absolute`, which also keeps it out of the grid so `grid-cols-[auto_1fr]` never counts it as a column. |
/// | toast | `.bloom-cosmic [data-content]::before / ::after` (L3403–3406) — a **descendant** combinator, not a child one, because sonner owns the live markup and may wrap the content slot; a `>` would work on the DS preview and silently do nothing on the real toast. |
///
/// **`[data-content]` is not positioned.** So the pseudo-elements' `inset: 0`
/// resolves against the nearest positioned ancestor, which is `.cn-toast`
/// itself — measured on the live preview, `[data-content]::before`'s
/// `transform-origin` is `354px 51.5px`, the toast's whole padding box, while
/// `[data-content]` is only 122.08px wide. **On a toast the sparkle box is the
/// entire toast.** That is why this widget is mounted by `DsBloomCosmic`
/// rather than by either host: the bloom's own box already *is* the padding
/// box on both, so hanging the starfield there reproduces the Alert's span and
/// the toast's accident with one mounting.
///
/// ## The three properties, and why they cannot be one transform
///
/// The sway animates the **`rotate`** longhand; the hover moves **`translate`**
/// and **`scale`** (L3387–3391). In modern CSS those are three independent
/// properties that multiply, so a cluster can be mid-rotation and mid-nudge at
/// once; written as one `transform` they would overwrite each other and a hover
/// would kill the sway. Flutter has one matrix, so the composition is done by
/// hand here in the order the spec gives — `translate`, then `rotate`, then
/// `scale`, then any `transform` (there is none) — all about the same origin.
/// [DsStarfieldCluster.matrixFor] is that one expression.
///
/// Origin is the anchored corner, and the amplitudes are an oscillation rather
/// than a revolution (L3393–3395): a full turn would swing the cluster clear of
/// the box for half its cycle.
///
/// ## One starfield, both themes
///
/// The fill is a literal `#ffffff` in **both** blocks (L3466–3471). What the
/// theme changes is the glow around it: `--star-glow` and `--star-glow-size`.
/// On dark that is white at half alpha; on light it is the host's own
/// `--bloom-2` at 85%, which is the one place a sparkle knows what variant it
/// is sitting on — see [DsStarfield.glowFor].
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../components/icon_paths.dart';
import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/theme.dart';
import '../theme_scope.dart';

// ── What this file states, and what it reads ────────────────────────────────
// The two `--star-glow*` theme tokens live on `DsThemeData`
// (`starGlowSize` / `starGlowMix`) with every other token. What is left here
// is the utility's own geometry: the two tile sizes, the thirteen
// opacity/translate/scale triples, the sway amplitudes, the hover offsets and
// the `* 3` on the wide pass — all declared inside `@utility .starfield`
// rather than in a theme block, and all transcribed beside the only effect
// that draws them, on `bloom_cosmic.dart`'s precedent for `_deepWidthCap`.

/// The second `drop-shadow`'s radius is `calc(var(--star-glow-size) * 3)`
/// (globals.css L3422) — the utility's own multiplier, not a theme token.
const double _wideGlowFactor = 3;

/// CSS `drop-shadow()`'s third length is a **blur radius**, read the way
/// `box-shadow` reads one — twice the Gaussian standard deviation.
///
/// Worth stating because the neighbouring effect does the opposite:
/// `filter: blur(16px)` takes its length as the sigma directly, with no
/// conversion at all (`bloom_cosmic.dart`'s `_deepBlur`). Two lengths in one
/// `filter` list, two different meanings — and reading `drop-shadow` as a sigma
/// would double every glow on the page.
///
/// Unlike `DsShadowLayer.blurRadius` there is nothing to invert here: that
/// getter exists to feed Flutter's own radius→sigma formula through
/// [BoxShadow], and this feeds [ui.ImageFilter.blur], which takes the sigma.
double _dropShadowSigma(double cssBlurRadius) => cssBlurRadius / 2;

/// One `<path transform="translate(x,y) scale(s)" opacity="…"/>` inside a
/// cluster's SVG.
///
/// Every instance is the same 24×24 four-point star
/// ([DsIconPaths.sparkleElement]), so an instance is only ever three numbers
/// and a place to put them.
@immutable
class DsSparkle {
  const DsSparkle({
    required this.opacity,
    required this.x,
    required this.y,
    required this.scale,
  });

  /// The `opacity` attribute — 0.38 to 0.95 across the thirteen.
  final double opacity;

  /// `translate(x, …)`, in the cluster's tile coordinates.
  final double x;

  /// `translate(…, y)`.
  final double y;

  /// `scale(s)` — 0.12 to 0.46, so a sparkle is 2.88px to 11.04px across.
  final double scale;

  /// The `24s × 24s` box this instance occupies, top-left at `(x, y)`.
  ///
  /// An SVG `transform` on a `<path>` maps the path's own coordinate system, so
  /// the star's 0…24 extent becomes 0…24s and the translate places that.
  Rect get box => Rect.fromLTWH(
        x,
        y,
        DsIconPaths.viewBox * scale,
        DsIconPaths.viewBox * scale,
      );

  @override
  bool operator ==(Object other) =>
      other is DsSparkle &&
      other.opacity == opacity &&
      other.x == x &&
      other.y == y &&
      other.scale == scale;

  @override
  int get hashCode => Object.hash(opacity, x, y, scale);
}

/// One of the two pseudo-elements: a tile of sparkles, a corner to hang it on,
/// a sway, and a hover lean.
@immutable
class DsStarfieldCluster {
  const DsStarfieldCluster({
    required this.tile,
    required this.corner,
    required this.sway,
    required this.fromDegrees,
    required this.toDegrees,
    required this.hoverTranslate,
    required this.hoverScale,
    required this.sparkles,
  });

  /// `background-size`, which is also the SVG's `viewBox` — the two agree, so
  /// the tile's coordinates are px and a sparkle needs no second scale.
  final Size tile;

  /// Both `background-position` and `transform-origin`, which name the same
  /// corner: the cluster is anchored to it *and* rotates about it. Anchoring to
  /// one corner and pivoting about another would swing the far end of the
  /// cluster through the surface.
  final Alignment corner;

  /// `animation-duration` — [DsDurations.sway] 44s here, [DsDurations.swayAlt]
  /// 33s on the other. Coprime-ish for the same reason the bloom's 18/11 are.
  final Duration sway;

  /// `@keyframes star-sway { from { rotate: -6deg } … }` — degrees.
  final double fromDegrees;

  /// `… to { rotate: 6deg } }`.
  final double toDegrees;

  /// `:hover` `translate: -5px 3px` — a nudge *toward* the surface's middle, so
  /// the cluster leans in rather than drifting off the corner.
  final Offset hoverTranslate;

  /// `:hover` `scale: 1.06`.
  final double hoverScale;

  /// The instances, in the SVG's own paint order.
  final List<DsSparkle> sparkles;

  /// `background-position: right bottom` / `right top` with `no-repeat`, as the
  /// tile's top-left corner in the box's coordinates.
  ///
  /// **This is where sparkles go missing.** On the feedback page's Alert the
  /// padding box is 1028 × 69.125 and cluster A's tile is 96 tall, so the
  /// origin lands at y = −26.875 and the top 26.875px of the tile is outside
  /// the box: sparkle 5 (tile-y 16…20.32) never renders at all and sparkle 2
  /// (24…30.24) shows 3.365px of itself. On a 51.5px toast the origin is
  /// −44.5 and sparkles 2 *and* 5 go, 6 keeps 0.78px, and 1 · 3 · 4 · 7 · 8
  /// survive. Horizontally nothing is ever lost: cluster A's instances span
  /// tile-x 112…252 inside a 260px tile and both hosts are wider than 260.
  ///
  /// The `x` is `right` on both clusters, so it is not switched on [corner].
  Offset tileOriginIn(Size box) => Offset(
        box.width - tile.width,
        corner.y > 0 ? box.height - tile.height : 0,
      );

  /// `transform-origin` in the box's coordinates — `100% 100%` or `100% 0%`.
  Offset originIn(Size box) => Offset(
        box.width,
        corner.y > 0 ? box.height : 0,
      );

  /// The `rotate` longhand at linear progress [t], in degrees.
  ///
  /// `infinite alternate` is what the controller does (it runs 0→1→0); the
  /// easing lives here, so a probe and the paint cannot disagree about where
  /// the cluster is.
  double swayDegreesAt(double t) {
    final double eased = DsCurves.inOut.transform(t.clamp(0.0, 1.0));
    return fromDegrees + (toDegrees - fromDegrees) * eased;
  }

  /// The `translate` longhand at hover progress [u] — 0 at rest, 1 held.
  Offset hoverTranslateAt(double u) {
    final double eased = DsCurves.out.transform(u.clamp(0.0, 1.0));
    return hoverTranslate * eased;
  }

  /// The `scale` longhand at hover progress [u].
  double hoverScaleAt(double u) {
    final double eased = DsCurves.out.transform(u.clamp(0.0, 1.0));
    return 1 + (hoverScale - 1) * eased;
  }

  /// The three longhands composed, about [originIn].
  ///
  /// CSS Transforms 2 fixes the order: `translate`, then `rotate`, then
  /// `scale`, then the `transform` property. The hover nudge is therefore the
  /// **outermost** factor and is not itself rotated by the sway — which is
  /// visible, because a −5px lean under a 6° rotation would otherwise arrive at
  /// a different place at each end of the cycle.
  Matrix4 matrixFor(
    Size box, {
    required double swayT,
    required double hoverT,
  }) {
    final Offset o = originIn(box);
    final Offset t = hoverTranslateAt(hoverT);
    final double s = hoverScaleAt(hoverT);
    return Matrix4.identity()
      ..translateByDouble(o.dx, o.dy, 0, 1)
      ..translateByDouble(t.dx, t.dy, 0, 1)
      ..rotateZ(swayDegreesAt(swayT) * math.pi / 180)
      ..scaleByDouble(s, s, 1, 1)
      ..translateByDouble(-o.dx, -o.dy, 0, 1);
  }

  /// The matrix a `prefers-reduced-motion` browser settles on: the element's
  /// own resting style, plus whatever the hover transition has reached.
  ///
  /// `star-sway` declares no `animation-fill-mode`, and the blanket rule
  /// (globals.css L2534–2542) collapses its duration to 0.01ms and its
  /// iteration count to 1 — so it *finishes* rather than freezing, and reverts
  /// to the element's own `rotate`, which is **0°, not the keyframe's −6°**.
  /// The transitions are collapsed rather than removed, so a hovered cluster
  /// still leans; it just arrives instantly.
  Matrix4 stilledMatrixFor(Size box, {required double hoverT}) {
    final Offset o = originIn(box);
    final Offset t = hoverTranslateAt(hoverT);
    final double s = hoverScaleAt(hoverT);
    return Matrix4.identity()
      ..translateByDouble(o.dx, o.dy, 0, 1)
      ..translateByDouble(t.dx, t.dy, 0, 1)
      ..scaleByDouble(s, s, 1, 1)
      ..translateByDouble(-o.dx, -o.dy, 0, 1);
  }
}

/// `::before` — the dense bottom-right cluster, `viewBox="0 0 260 96"`,
/// eight sparkles (globals.css L3474).
const DsStarfieldCluster dsStarfieldDense = DsStarfieldCluster(
  tile: Size(260, 96),
  corner: Alignment.bottomRight,
  sway: DsDurations.sway,
  fromDegrees: -6,
  toDegrees: 6,
  hoverTranslate: Offset(-5, 3),
  hoverScale: 1.06,
  sparkles: <DsSparkle>[
    DsSparkle(opacity: 0.95, x: 214, y: 54, scale: 0.46),
    DsSparkle(opacity: 0.78, x: 240, y: 24, scale: 0.26),
    DsSparkle(opacity: 0.85, x: 180, y: 76, scale: 0.32),
    DsSparkle(opacity: 0.66, x: 248, y: 72, scale: 0.20),
    DsSparkle(opacity: 0.55, x: 196, y: 16, scale: 0.18),
    DsSparkle(opacity: 0.58, x: 146, y: 40, scale: 0.22),
    DsSparkle(opacity: 0.50, x: 232, y: 92, scale: 0.16),
    DsSparkle(opacity: 0.42, x: 112, y: 66, scale: 0.15),
  ],
);

/// `::after` — the thin top-right cluster, `viewBox="0 0 200 64"`, five
/// sparkles (globals.css L3478).
const DsStarfieldCluster dsStarfieldThin = DsStarfieldCluster(
  tile: Size(200, 64),
  corner: Alignment.topRight,
  sway: DsDurations.swayAlt,
  fromDegrees: 5,
  toDegrees: -5,
  hoverTranslate: Offset(-3, -2),
  hoverScale: 1.04,
  sparkles: <DsSparkle>[
    DsSparkle(opacity: 0.78, x: 168, y: 18, scale: 0.24),
    DsSparkle(opacity: 0.55, x: 132, y: 42, scale: 0.17),
    DsSparkle(opacity: 0.60, x: 190, y: 46, scale: 0.18),
    DsSparkle(opacity: 0.42, x: 96, y: 14, scale: 0.13),
    DsSparkle(opacity: 0.38, x: 150, y: 60, scale: 0.12),
  ],
);

/// Paints the two clusters over the whole of its box.
///
/// Give it tight constraints — `Positioned.fill` inside the host's clip is what
/// `position: absolute; inset: 0` means, and it is how `DsBloomCosmic` mounts
/// it. Its own painting is [IgnorePointer]-wrapped for `pointer-events: none`,
/// so [hovered] has to arrive from the host: it is the host's `:hover`, not the
/// sparkles'.
class DsStarfield extends StatefulWidget {
  const DsStarfield({
    super.key,
    required this.bloom2,
    this.hovered = false,
  });

  /// The host's resolved `--bloom-2`, which `--star-glow` reads on light.
  ///
  /// Passed in rather than resolved here because only the host knows its own
  /// variant — an `info` alert and a `warning` toast declare different pairs,
  /// and on light their sparkles glow in those two different colours.
  final Color bloom2;

  /// The host's `:hover`.
  final bool hovered;

  /// The two clusters, in paint order — `::before` under `::after`.
  static const List<DsStarfieldCluster> clusters = <DsStarfieldCluster>[
    dsStarfieldDense,
    dsStarfieldThin,
  ];

  /// The `#ffffff` the SVG fills every instance with — the same in **both**
  /// theme blocks (globals.css L3466–3471), which is why it is not a theme
  /// field.
  ///
  /// It is the background image's own content, like the `d` string beside it,
  /// and it is spelled as the top of the lightness axis rather than as an ARGB
  /// literal on `DsBloomCosmic.voidFor`'s precedent: CSS `white` *is*
  /// `hsl(0 0% 100%)`, and this file states no colour of its own.
  static final Color starInk = dsHsl(0, 0, 100);

  /// `--star-glow` — the colour of both `drop-shadow` passes.
  ///
  /// The strength is `theme.starGlowMix`, one number for both blocks; what
  /// differs is what it is applied to. Dark is `rgb(255 255 255 / 0.5)`, which
  /// is [starInk] — the sparkle's own light — at that alpha. Light is
  /// `color-mix(in oklab, var(--bloom-2) 85%, transparent)`: mixing toward
  /// `transparent` in premultiplied oklab preserves the hue and scales the
  /// alpha, so it resolves to the **host's** hue at 0.85. That is the one place
  /// a sparkle knows which variant it is sitting on.
  static Color glowFor(DsThemeData theme, Color bloom2) => switch (theme.kind) {
        DsThemeKind.dark =>
          starInk.withValues(alpha: theme.starGlowMix),
        DsThemeKind.light =>
          DsOklab.mix(bloom2, dsTransparent, theme.starGlowMix),
      };

  /// The two `drop-shadow` sigmas, tight then wide, for `--star-glow-size`.
  ///
  /// The utility's own comment (L3418–3423) says why there are two and why they
  /// are `drop-shadow` rather than `box-shadow`: the sparkles are alpha in a
  /// background image, so a box shadow would trace the rectangle instead of the
  /// stars. *"Tight = the star's own light; wide = that light reaching the
  /// surface."*
  static ({double tight, double wide}) sigmasFor(DsThemeData theme) => (
        tight: _dropShadowSigma(theme.starGlowSize),
        wide: _dropShadowSigma(theme.starGlowSize * _wideGlowFactor),
      );

  /// The sparkles of [cluster] that put at least one pixel inside a box of
  /// [box] — the population the clipping leaves.
  ///
  /// Exposed because "which sparkles render" is a derived fact that no widget
  /// assertion can reach: it falls out of [DsStarfieldCluster.tileOriginIn] and
  /// the host's height, and the map's whole *anchored, not tiled* note exists
  /// to stop a port from rescaling it away.
  @visibleForTesting
  static List<DsSparkle> visibleIn(DsStarfieldCluster cluster, Size box) {
    final Offset origin = cluster.tileOriginIn(box);
    return <DsSparkle>[
      for (final DsSparkle sparkle in cluster.sparkles)
        if (sparkle.box.shift(origin).overlaps(Offset.zero & box)) sparkle,
    ];
  }

  @override
  State<DsStarfield> createState() => _DsStarfieldState();
}

class _DsStarfieldState extends State<DsStarfield>
    with TickerProviderStateMixin {
  /// One controller per cluster: the two sways have different periods, which is
  /// the entire reason the field never reads as one rigid sheet.
  ///
  /// The durations named here are placeholders for the first frame only —
  /// [build] re-reads both through [dsAnimationDuration] on every pass, the way
  /// `DsSpinner` and `DsKeyframePlayer` do.
  late final List<AnimationController> _sways = <AnimationController>[
    for (final DsStarfieldCluster cluster in DsStarfield.clusters)
      AnimationController(vsync: this, duration: cluster.sway),
  ];

  /// `transition: translate --duration-bloom --ease-out, scale …` — one
  /// controller for both properties, because one declaration times both.
  late final AnimationController _hover = AnimationController(
    vsync: this,
    duration: DsDurations.bloom,
  );

  /// Null until the first resolution, so a MediaQuery change that is *not* a
  /// reduced-motion change does not restart the sways.
  bool? _stilled;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool stilled =
        dsAnimationDuration(context, DsDurations.sway) == Duration.zero;
    if (_stilled == stilled) return;
    _stilled = stilled;
    _play();
  }

  @override
  void didUpdateWidget(DsStarfield old) {
    super.didUpdateWidget(old);
    if (old.hovered != widget.hovered) _settleHover();
  }

  @override
  void dispose() {
    for (final AnimationController controller in _sways) {
      controller.dispose();
    }
    _hover.dispose();
    super.dispose();
  }

  /// Supervisor ruling F2: every rest-state looper builds, in full, and the
  /// only gate is the reduced-motion switch. There is deliberately no
  /// out-of-view pause — the reference has none, and a page whose sparkles stop
  /// when they leave the fold is a different page.
  void _play() {
    if (_stilled ?? false) {
      for (final AnimationController controller in _sways) {
        controller.stop();
      }
      return;
    }
    for (final AnimationController controller in _sways) {
      // `infinite alternate` — forward, then backward, forever. The keyframe
      // easing is applied per-cluster in `swayDegreesAt`, so this clock stays
      // linear and nothing is eased twice.
      controller.repeat(reverse: true);
    }
  }

  void _settleHover() {
    if (widget.hovered) {
      _hover.forward();
    } else {
      _hover.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool stilled = _stilled ?? false;
    for (int i = 0; i < _sways.length; i++) {
      _sways[i].duration =
          dsAnimationDuration(context, DsStarfield.clusters[i].sway);
    }
    _hover.duration = dsAnimationDuration(context, DsDurations.bloom);

    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: Listenable.merge(<Listenable>[..._sways, _hover]),
          builder: (BuildContext context, Widget? child) => CustomPaint(
            painter: _StarfieldPainter(
              swayT: <double>[
                for (final AnimationController c in _sways) c.value,
              ],
              hoverT: _hover.value,
              stilled: stilled,
              glow: DsStarfield.glowFor(theme, widget.bloom2),
              sigmas: DsStarfield.sigmasFor(theme),
            ),
          ),
        ),
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  const _StarfieldPainter({
    required this.swayT,
    required this.hoverT,
    required this.stilled,
    required this.glow,
    required this.sigmas,
  });

  final List<double> swayT;
  final double hoverT;
  final bool stilled;
  final Color glow;
  final ({double tight, double wide}) sigmas;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final Rect box = Offset.zero & size;

    for (int i = 0; i < DsStarfield.clusters.length; i++) {
      final DsStarfieldCluster cluster = DsStarfield.clusters[i];
      canvas.save();
      // The element's own transform maps its already-filtered rendering into
      // the parent, so it goes on outermost and everything below happens in the
      // cluster's local space.
      canvas.transform(
        (stilled
                ? cluster.stilledMatrixFor(size, hoverT: hoverT)
                : cluster.matrixFor(size, swayT: swayT[i], hoverT: hoverT))
            .storage,
      );
      _paintCluster(canvas, box, cluster);
      canvas.restore();
    }
  }

  /// `filter: drop-shadow(0 0 G) drop-shadow(0 0 3G)`, chained exactly as CSS
  /// chains a filter list: the second pass shadows the **output of the first**,
  /// not the source. With one colour at one alpha the difference is a few
  /// percent of alpha in the tight ring — but the chain is what the declaration
  /// says, and it costs one more pass over thirteen small paths.
  void _paintCluster(Canvas canvas, Rect box, DsStarfieldCluster cluster) {
    // A filter's result is not clipped to the element, so the layer has to hold
    // the widest glow's full reach. A Gaussian is spent by three sigma.
    final Rect bounds = box.inflate(sigmas.wide * 3 + sigmas.tight * 3);

    void tinted(double sigma, void Function(Canvas) draw) {
      canvas.saveLayer(
        bounds,
        Paint()
          // `feFlood` + `composite in`: a drop shadow reads the input's ALPHA
          // and floods it with the shadow colour. `srcIn` is that, and it is
          // why the per-instance opacities survive into the glow.
          ..colorFilter = ColorFilter.mode(glow, BlendMode.srcIn)
          ..imageFilter = ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      );
      draw(canvas);
      canvas.restore();
    }

    void source(Canvas canvas) => _paintSparkles(canvas, box, cluster);

    // Pass 1's output: the sparkles over their own tight glow.
    void tightPass(Canvas canvas) {
      tinted(sigmas.tight, source);
      source(canvas);
    }

    tinted(sigmas.wide, tightPass);
    tightPass(canvas);
  }

  /// The tile, anchored and **clipped** — never rescaled.
  void _paintSparkles(Canvas canvas, Rect box, DsStarfieldCluster cluster) {
    canvas.save();
    // `background-clip: border-box` with `no-repeat`: whatever hangs past the
    // element is simply not painted. This is the clip that removes sparkle 5
    // from a 69px Alert.
    canvas.clipRect(box);
    final Offset origin = cluster.tileOriginIn(box.size);
    for (final DsSparkle sparkle in cluster.sparkles) {
      canvas.save();
      canvas.translate(origin.dx + sparkle.x, origin.dy + sparkle.y);
      canvas.scale(sparkle.scale);
      canvas.drawPath(
        DsIconPaths.sparkle(),
        Paint()..color = DsStarfield.starInk.withValues(alpha: sparkle.opacity),
      );
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_StarfieldPainter old) =>
      old.hoverT != hoverT ||
      old.stilled != stilled ||
      old.glow != glow ||
      old.sigmas != sigmas ||
      !listEquals(old.swayT, swayT);
}
