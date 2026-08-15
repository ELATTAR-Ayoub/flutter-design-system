/// `@keyframes` — the reference's fourteen, transcribed whole.
///
/// Nine are the `anim-*` utilities the motion page demonstrates
/// (`app/globals.css` L2424–2531); two more — `ds-sweep` (L2195–2202) and
/// `ds-travel` (L2203–2210) — are declared for that page's own duration bars
/// and easing chips. Three belong to the form controls and appear on no
/// foundations page at all: `check-draw`, `dash-draw` and `dot-pop`
/// (L2212–2242), added in §E when the checkbox and the radio arrived.
///
/// §F holds one entry that is **not** a keyframe — `swap-roll`, a transition
/// utility (L2265–2271) — because the IconSwap wheel it drives needs exactly
/// one motion table and this is the file that holds motion tables. Its own doc
/// says so; nothing else in here is a transition.
///
/// Three mechanics decide everything in this file:
///
/// * **A CSS `animation-timing-function` eases between adjacent keyframes, not
///   across the run.** So a keyframe table is a [TweenSequence] with one item
///   per gap, each wrapped in its own [CurveTween], weights = the percentage
///   gaps — the pattern `sliding_pill.dart` already uses for `yuki-jelly`, and
///   which [DsKeyframes.track] generalises.
/// * **A property declared at some stops and not others HOLDS.** `yuki-pop-in`
///   writes `opacity` at 0% and 55% only, and it stays 1 from 55% to the end.
///   That is a modelled tail ([ConstantTween]), not an accident of the last two
///   values happening to be equal.
/// * **`animation-fill-mode` decides what reduced motion freezes to.** The
///   blanket `prefers-reduced-motion` rule (L2534–2565) collapses every
///   duration to 0.01ms and every loop to one iteration, but it touches neither
///   fill mode nor delay: a `both` animation holds its final stop, while the
///   three loopers here declare no fill at all and revert to the element's
///   resting style — stop 0. [DsKeyframeFill] is that distinction, and
///   [DsKeyframePlayer] is where it is enforced.
///
/// DRIFT (motion-map D10). The page's own reduced-motion copy reads *"Looping
/// animations run exactly once, then hold"*. The first half is the blanket
/// rule; the second half is true only of `forwards`/`both`, and the three
/// loopers on that very page declare no fill mode, so they **revert**. Copy
/// ships verbatim; the mechanism is per-demo, and the mechanism is here.
library;

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../theme_scope.dart';

// ─────────────────────────────────────────────────────────────────────────────
// A · steps()
// ─────────────────────────────────────────────────────────────────────────────

/// CSS `steps(n)` — the timing function with no interpolation in it.
///
/// Two animations need it and Flutter ships nothing equivalent:
/// `yuki-ratchet` `steps(8)` (globals.css L2416–2418) and `yuki-sign-on`
/// `steps(1, end)` (L2420–2422).
///
/// CSS `steps(n)` means `steps(n, jump-end)`: **`n` held positions**, the first
/// at 0 and the last at `(n−1)/n`. The output `1` belongs to the instant the
/// animation ends, which for an infinite loop is the same instant as the next
/// cycle's 0 — so `yuki-ratchet` never displays 360°, it wraps to 0°.
///
/// [transform] is overridden rather than `transformInternal` on purpose. The
/// base [Curve] short-circuits `t == 0.0` and `t == 1.0` to themselves, and
/// `t == 1.0` is exactly the frame this curve must not answer `n/n = 1` for.
/// Consequence worth knowing at the call site: `CurvedAnimation` performs the
/// same short-circuit itself, so a ratchet driven through one would still show
/// 360° on the wrap frame. Drive it through [DsRatchet.turnsAt] instead.
///
/// Supervisor ruling M7 follows from the same guard: under reduced motion the
/// ratchet runs one collapsed iteration and, having no fill mode, reverts to
/// the element's own transform — **0°**, not 315° and not 360°.
@immutable
class DsSteps extends Curve {
  const DsSteps(this.count, {this.jumpEnd = true}) : assert(count > 0);

  /// `n` — the number of held positions.
  final int count;

  /// `jump-end` (the CSS default, and what a bare `steps(n)` means) holds
  /// `0 … (n−1)/n`. `jump-start` holds `1/n … 1`, which is why it deliberately
  /// does not answer 0 at `t == 0`: CSS says the first jump happens at the
  /// start of the first interval.
  final bool jumpEnd;

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0, 'parametric value $t is outside [0, 1].');
    if (jumpEnd) {
      // The wrap frame: t == 1.0 holds the last position rather than reaching
      // the end value, which is what makes 360° unobservable.
      final double index = t >= 1.0
          ? (count - 1).toDouble()
          : (t * count).floorToDouble();
      return index / count;
    }
    final double index =
        math.min((t * count).floorToDouble() + 1, count.toDouble());
    return index / count;
  }

  @override
  bool operator ==(Object other) =>
      other is DsSteps && other.count == count && other.jumpEnd == jumpEnd;

  @override
  int get hashCode => Object.hash(count, jumpEnd);

  @override
  String toString() =>
      'DsSteps($count, ${jumpEnd ? 'jump-end' : 'jump-start'})';
}

// ─────────────────────────────────────────────────────────────────────────────
// B · fill mode
// ─────────────────────────────────────────────────────────────────────────────

/// CSS `animation-fill-mode`, as far as the reference uses it.
///
/// The hinge of the reduced-motion table (motion-map §8.2). The blanket rule
/// collapses durations and iteration counts; it never touches fill mode, so
/// fill mode alone decides the frozen frame:
///
/// | animation | fill | frozen at |
/// |---|---|---|
/// | `anim-pop-in`, `anim-jelly`, `anim-spring-up`, `anim-jelly-in`, `anim-sign-on`, `anim-reveal`, `ds-sweep`, `ds-travel` | `both` | the final stop |
/// | `anim-ratchet`, `anim-shimmer`, `anim-pulse-live` | *(none declared)* | stop 0 |
enum DsKeyframeFill {
  /// `both` — the first stop applies before the run and the last one is held
  /// after it. Every finite animation on the page declares it.
  both,

  /// No fill mode declared: outside its run the element wears its own resting
  /// style, which is what a keyframe table calls stop 0. All three loopers.
  none,
}

// ─────────────────────────────────────────────────────────────────────────────
// C · tables → Animatable, and the player that drives them
// ─────────────────────────────────────────────────────────────────────────────

/// One `<percent>% { … }` entry of a keyframe table, for one property.
///
/// [percent] is the CSS percentage (0–100), not a fraction: the tables read as
/// transcripts of the stylesheet, and the weights fall out as plain gaps.
@immutable
class DsKeyframeStop<T> {
  const DsKeyframeStop(this.percent, this.value);

  /// The keyframe's own `0%`…`100%`.
  final double percent;

  /// The value declared for this property at [percent].
  final T value;

  @override
  String toString() => '$percent% → $value';
}

/// Turns a keyframe table into an [Animatable].
///
/// The generalisation of the private `_jellyScale` in `sliding_pill.dart`: one
/// [TweenSequenceItem] per gap between adjacent stops, each carrying its own
/// [CurveTween], weighted by the gap in percentage points.
class DsKeyframes {
  const DsKeyframes._();

  /// [stops] must start at `0%` and ascend.
  ///
  /// A table whose last stop is short of 100% **holds** its last value for the
  /// remainder — that is what CSS does with a property that stops being
  /// declared, and it is modelled here as an explicit [ConstantTween] tail
  /// rather than left to emerge from two equal values.
  ///
  /// [lerp] keeps this generic over the value type; [doubles] and [offsets]
  /// are the two shapes the reference actually needs.
  static Animatable<T> track<T>(
    List<DsKeyframeStop<T>> stops, {
    required Curve curve,
    required T Function(T a, T b, double t) lerp,
  }) {
    assert(stops.isNotEmpty, 'a keyframe table has at least one stop');
    assert(stops.first.percent == 0, 'a keyframe table starts at 0%');
    assert(stops.last.percent <= 100, 'a keyframe table ends by 100%');

    final List<TweenSequenceItem<T>> items = <TweenSequenceItem<T>>[];
    for (int i = 1; i < stops.length; i++) {
      assert(stops[i].percent > stops[i - 1].percent, 'stops ascend');
      items.add(TweenSequenceItem<T>(
        tween: _LerpTween<T>(
          begin: stops[i - 1].value,
          end: stops[i].value,
          lerpValue: lerp,
        ).chain(CurveTween(curve: curve)),
        weight: stops[i].percent - stops[i - 1].percent,
      ));
    }

    final double declared = stops.last.percent;
    if (declared < 100) {
      items.add(TweenSequenceItem<T>(
        tween: ConstantTween<T>(stops.last.value),
        weight: 100 - declared,
      ));
    }
    return TweenSequence<T>(items);
  }

  /// [track] for a scalar property — opacity, a translation, a rotation.
  static Animatable<double> doubles(
    List<DsKeyframeStop<double>> stops, {
    required Curve curve,
  }) =>
      track<double>(stops, curve: curve, lerp: _lerpDouble);

  /// [track] for a two-axis property. `dx` carries `scaleX`, `dy` `scaleY` —
  /// the spelling `sliding_pill.dart` established for `scale3d`.
  static Animatable<Offset> offsets(
    List<DsKeyframeStop<Offset>> stops, {
    required Curve curve,
  }) =>
      track<Offset>(stops, curve: curve, lerp: _lerpOffset);

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;

  static Offset _lerpOffset(Offset a, Offset b, double t) =>
      Offset.lerp(a, b, t)!;
}

/// A [Tween] whose interpolation is supplied, so [DsKeyframes.track] can be
/// generic over value types [Tween] cannot subtract.
class _LerpTween<T> extends Tween<T> {
  _LerpTween({required T begin, required T end, required this.lerpValue})
      : super(begin: begin, end: end);

  final T Function(T a, T b, double t) lerpValue;

  @override
  T lerp(double t) => lerpValue(begin as T, end as T, t);
}

/// Runs one keyframe animation's clock and hands its progress to [builder].
///
/// The progress is **linear** on purpose. A CSS `animation-timing-function`
/// eases between adjacent keyframes, so the easing lives in the tracks
/// ([DsKeyframes.track]) and never here; a player that eased its own clock
/// would ease twice.
///
/// Reduced motion is the behaviour this widget exists for. `dsAnimationDuration`
/// collapses the run, and [fill] decides the frame it collapses to: `both`
/// lands on the final stop, no fill lands on stop 0 (motion-map §8.2). It is
/// resolved by stopping the controller and setting its value outright, not by
/// running a zero-length animation — a zero-period `repeat()` has no meaning.
///
/// **There is deliberately no `replay()`.** The reference replays by re-keying
/// (motion-map §11): React remounts the element, and a freshly mounted element
/// starts its CSS animation at t=0, mid-flight restarts included. Wrapping this
/// widget in `KeyedSubtree(key: ValueKey('$name-$run'))` reproduces that
/// exactly, because the controller is created in `initState` and started on the
/// first `didChangeDependencies`. A broadcast `forward(from: 0)` would not: it
/// cannot express `ds-sweep`'s `both` fill on a demo that has not been built
/// yet.
class DsKeyframePlayer extends StatefulWidget {
  const DsKeyframePlayer({
    super.key,
    required this.duration,
    required this.builder,
    this.fill = DsKeyframeFill.both,
    this.repeat = false,
    this.child,
  });

  /// The animation's own length. `ds-sweep` takes a different one per row —
  /// the durations panel *is* the duration scale — so this is a parameter
  /// rather than a table constant.
  final Duration duration;

  /// Decides the reduced-motion freeze frame, and nothing else.
  final DsKeyframeFill fill;

  /// The three loopers. Also what puts a [RepaintBoundary] around [builder]'s
  /// output: something that animates forever must not repaint its neighbours.
  final bool repeat;

  /// Handed linear progress in `0..1`.
  final Widget Function(BuildContext context, double t, Widget? child) builder;

  /// Passed through to [builder] unrebuilt, the [AnimatedBuilder] contract.
  final Widget? child;

  @override
  State<DsKeyframePlayer> createState() => _DsKeyframePlayerState();
}

class _DsKeyframePlayerState extends State<DsKeyframePlayer>
    with SingleTickerProviderStateMixin {
  /// The duration named here is a placeholder for the first frame only:
  /// [build] re-reads it through [dsAnimationDuration] on every pass, the way
  /// `DsPress` and `DsSlidingPillGroup` do.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  /// Null until the first resolution. Tracked so that a MediaQuery change that
  /// is *not* a reduced-motion change — a window resize, a text-scale change —
  /// does not restart every demo on the page.
  bool? _stilled;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool stilled =
        dsAnimationDuration(context, widget.duration) == Duration.zero;
    if (_stilled == stilled) return;
    _stilled = stilled;
    _play();
  }

  @override
  void didUpdateWidget(DsKeyframePlayer old) {
    super.didUpdateWidget(old);
    if (old.duration != widget.duration ||
        old.repeat != widget.repeat ||
        old.fill != widget.fill) {
      _play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _play() {
    if (_stilled ?? false) {
      _controller.stop();
      // §8.2, the whole point of [DsKeyframeFill]: `both` holds the final
      // stop, no fill reverts to the element's resting style.
      _controller.value = widget.fill == DsKeyframeFill.both
          ? _controller.upperBound
          : _controller.lowerBound;
      return;
    }
    _controller.duration = widget.duration;
    if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    _controller.duration = dsAnimationDuration(context, widget.duration);
    final Widget result = AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) =>
          widget.builder(context, _controller.value, child),
      child: widget.child,
    );
    return widget.repeat ? RepaintBoundary(child: result) : result;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// D · the eleven tables
// ─────────────────────────────────────────────────────────────────────────────

/// `@keyframes yuki-pop-in` — globals.css L2424–2430, worn by `.anim-pop-in`
/// (`animation: yuki-pop-in 0.55s var(--ease-out) both`, L2361–2363).
///
/// ```css
/// 0%   { opacity: 0; transform: scale3d(0.25, 0.25, 1); }
/// 55%  { opacity: 1; transform: scale3d(0.92, 1.08, 1); }
/// 80%  {             transform: scale3d(1.04, 0.97, 1); }
/// 92%  {             transform: scale3d(0.99, 1.01, 1); }
/// 100% {             transform: scale3d(1,    1,    1); }
/// ```
///
/// *"Pops from 25%, never from 0, so it always reads as arriving rather than
/// materialising."* [opacity] is declared at two stops only and holds 1 from
/// 55% on.
///
/// Its reduced-motion row carries a belt-and-braces special case
/// (`opacity: 1; transform: none !important`, L2503–2506) that the `both` fill
/// already delivers: the final stop *is* opacity 1 and identity.
class DsPopIn {
  const DsPopIn._();

  static const Duration duration = DsDurations.popIn;
  static const Curve curve = DsCurves.out;
  static const DsKeyframeFill fill = DsKeyframeFill.both;

  static const List<DsKeyframeStop<double>> opacityStops =
      <DsKeyframeStop<double>>[
    DsKeyframeStop(0, 0), // allow-hardcoded: yuki-pop-in geometry
    DsKeyframeStop(55, 1), // allow-hardcoded: yuki-pop-in geometry
  ];

  static const List<DsKeyframeStop<Offset>> scaleStops =
      <DsKeyframeStop<Offset>>[
    DsKeyframeStop(0, Offset(0.25, 0.25)), // allow-hardcoded: yuki-pop-in
    DsKeyframeStop(55, Offset(0.92, 1.08)), // allow-hardcoded: yuki-pop-in
    DsKeyframeStop(80, Offset(1.04, 0.97)), // allow-hardcoded: yuki-pop-in
    DsKeyframeStop(92, Offset(0.99, 1.01)), // allow-hardcoded: yuki-pop-in
    DsKeyframeStop(100, Offset(1, 1)), // allow-hardcoded: yuki-pop-in
  ];

  static final Animatable<double> opacity =
      DsKeyframes.doubles(opacityStops, curve: curve);

  /// `dx` = `scaleX`, `dy` = `scaleY`.
  static final Animatable<Offset> scale =
      DsKeyframes.offsets(scaleStops, curve: curve);
}

/// `@keyframes yuki-jelly` — globals.css L2431–2438, worn by `.anim-jelly`
/// (`animation: yuki-jelly 0.6s var(--ease-out) both`, L2365–2367).
///
/// ```css
/// 0%   { transform: scale3d(1,    1,    1); }
/// 30%  { transform: scale3d(1.18, 0.82, 1); }
/// 45%  { transform: scale3d(0.88, 1.12, 1); }
/// 60%  { transform: scale3d(1.06, 0.94, 1); }
/// 78%  { transform: scale3d(0.98, 1.02, 1); }
/// 100% { transform: scale3d(1,    1,    1); }
/// ```
///
/// *"The reward. Squashes to 1.18×0.82 and wobbles back. Reserve it for wins."*
///
/// FOLLOW-UP. A private twin of this table survives as `_jellyScale` in
/// `lib/src/motion/sliding_pill.dart` (L242–262), which predates this file and
/// is the pattern it generalises. Collapsing the two — pointing
/// `DsSlidingPillGroup` at [scale] and deleting `_jellyScale` — is a separate
/// change to a file this one does not own, and is deliberately not made here.
class DsJelly {
  const DsJelly._();

  static const Duration duration = DsDurations.animJelly;
  static const Curve curve = DsCurves.out;
  static const DsKeyframeFill fill = DsKeyframeFill.both;

  static const List<DsKeyframeStop<Offset>> scaleStops =
      <DsKeyframeStop<Offset>>[
    DsKeyframeStop(0, Offset(1, 1)), // allow-hardcoded: yuki-jelly geometry
    DsKeyframeStop(30, Offset(1.18, 0.82)), // allow-hardcoded: yuki-jelly
    DsKeyframeStop(45, Offset(0.88, 1.12)), // allow-hardcoded: yuki-jelly
    DsKeyframeStop(60, Offset(1.06, 0.94)), // allow-hardcoded: yuki-jelly
    DsKeyframeStop(78, Offset(0.98, 1.02)), // allow-hardcoded: yuki-jelly
    DsKeyframeStop(100, Offset(1, 1)), // allow-hardcoded: yuki-jelly
  ];

  static final Animatable<Offset> scale =
      DsKeyframes.offsets(scaleStops, curve: curve);
}

/// `@keyframes yuki-spring-up` — globals.css L2439–2445, worn by
/// `.anim-spring-up` (`animation: yuki-spring-up 0.8s var(--ease-settle) both`,
/// L2369–2371).
///
/// ```css
/// 0%   { opacity: 0; transform: translateY(32px); }
/// 55%  { opacity: 1; transform: translateY(-4px); }
/// 76%  {             transform: translateY(1.5px); }
/// 90%  {             transform: translateY(-0.5px); }
/// 100% {             transform: translateY(0); }
/// ```
///
/// The one table that uses `--ease-settle` rather than `--ease-out`, and the
/// one whose copy is arithmetically exact: *"Rises 32px, overshoots by 4, then
/// settles in three decreasing bounces"* — −4, +1.5, −0.5.
class DsSpringUp {
  const DsSpringUp._();

  static const Duration duration = DsDurations.springUp;
  static const Curve curve = DsCurves.settle;
  static const DsKeyframeFill fill = DsKeyframeFill.both;

  static const List<DsKeyframeStop<double>> opacityStops =
      <DsKeyframeStop<double>>[
    DsKeyframeStop(0, 0), // allow-hardcoded: yuki-spring-up geometry
    DsKeyframeStop(55, 1), // allow-hardcoded: yuki-spring-up geometry
  ];

  static const List<DsKeyframeStop<double>> translateYStops =
      <DsKeyframeStop<double>>[
    DsKeyframeStop(0, 32), // allow-hardcoded: yuki-spring-up geometry
    DsKeyframeStop(55, -4), // allow-hardcoded: yuki-spring-up geometry
    DsKeyframeStop(76, 1.5), // allow-hardcoded: yuki-spring-up geometry
    DsKeyframeStop(90, -0.5), // allow-hardcoded: yuki-spring-up geometry
    DsKeyframeStop(100, 0), // allow-hardcoded: yuki-spring-up geometry
  ];

  static final Animatable<double> opacity =
      DsKeyframes.doubles(opacityStops, curve: curve);

  static final Animatable<double> translateY =
      DsKeyframes.doubles(translateYStops, curve: curve);
}

/// `@keyframes yuki-jelly-in` — globals.css L2446–2450, worn by
/// `.anim-jelly-in` (`animation: yuki-jelly-in var(--duration-jelly)
/// var(--ease-spring) both`, L2376–2378).
///
/// ```css
/// 0%   { opacity: 0; transform: scale(0.92) translateY(24px); }
/// 60%  { opacity: 1; transform: scale(1.02) translateY(-4px); }
/// 100% { opacity: 1; transform: scale(1)    translateY(0); }
/// ```
///
/// The utility's own comment (L2372–2375) is worth carrying: the keyframes
/// drive **`transform`, never `translate`**, so the animation composes with a
/// dialog's centring translate instead of fighting it. In Flutter terms the
/// same discipline is a [Transform] *inside* whatever positions the element,
/// never a change to its position.
class DsJellyIn {
  const DsJellyIn._();

  static const Duration duration = DsDurations.jelly;
  static const Curve curve = DsCurves.spring;
  static const DsKeyframeFill fill = DsKeyframeFill.both;

  static const List<DsKeyframeStop<double>> opacityStops =
      <DsKeyframeStop<double>>[
    DsKeyframeStop(0, 0), // allow-hardcoded: yuki-jelly-in geometry
    DsKeyframeStop(60, 1), // allow-hardcoded: yuki-jelly-in geometry
    DsKeyframeStop(100, 1), // allow-hardcoded: yuki-jelly-in geometry
  ];

  static const List<DsKeyframeStop<double>> scaleStops =
      <DsKeyframeStop<double>>[
    DsKeyframeStop(0, 0.92), // allow-hardcoded: yuki-jelly-in geometry
    DsKeyframeStop(60, 1.02), // allow-hardcoded: yuki-jelly-in geometry
    DsKeyframeStop(100, 1), // allow-hardcoded: yuki-jelly-in geometry
  ];

  static const List<DsKeyframeStop<double>> translateYStops =
      <DsKeyframeStop<double>>[
    DsKeyframeStop(0, 24), // allow-hardcoded: yuki-jelly-in geometry
    DsKeyframeStop(60, -4), // allow-hardcoded: yuki-jelly-in geometry
    DsKeyframeStop(100, 0), // allow-hardcoded: yuki-jelly-in geometry
  ];

  static final Animatable<double> opacity =
      DsKeyframes.doubles(opacityStops, curve: curve);

  /// Uniform: CSS `scale(s)` is `scaleX == scaleY`, unlike the `scale3d`
  /// tables above.
  static final Animatable<double> scale =
      DsKeyframes.doubles(scaleStops, curve: curve);

  static final Animatable<double> translateY =
      DsKeyframes.doubles(translateYStops, curve: curve);
}

/// `@keyframes yuki-ratchet` — globals.css L2471–2473, worn by `.anim-ratchet`
/// (`animation: yuki-ratchet 1.4s steps(8) infinite`, L2416–2418).
///
/// ```css
/// to { transform: rotate(360deg); }
/// ```
///
/// There is no `0%` stop: the implicit one is the element's own transform,
/// which is none. *"Stepped mechanical spin. Eight discrete positions, not a
/// smooth rotation — it reads as a mechanism."*
///
/// Eight held 45° positions of [DsDurations.ratchetStep] (175ms) each: 0°, 45°,
/// 90°, 135°, 180°, 225°, 270°, 315°. **360° is never displayed** — see
/// [DsSteps]. Infinite and unfilled, so it is one of the three demos the page
/// deliberately leaves unkeyed: a loop has nothing to replay.
class DsRatchet {
  const DsRatchet._();

  static const Duration duration = DsDurations.ratchet;
  static const DsKeyframeFill fill = DsKeyframeFill.none;
  static const bool loops = true;

  /// `steps(8)`, i.e. `steps(8, jump-end)`.
  static const int positions = 8; // allow-hardcoded: steps(8) (globals.css L2417)
  static const Curve curve = DsSteps(positions);

  /// One held position — derived in the foundation layer from 1.4s ÷ 8.
  static Duration get step => DsDurations.ratchetStep;

  /// The full turn the `to` stop names, as a fraction: 0 … 7/8.
  static double turnsAt(double t) => curve.transform(t.clamp(0.0, 1.0));

  /// [turnsAt] in radians, ready for `Transform.rotate`.
  static double radiansAt(double t) => turnsAt(t) * 2 * math.pi;

  /// [turnsAt] in degrees — 0, 45, 90 … 315.
  static double degreesAt(double t) => turnsAt(t) * 360;
}

/// One hard cut of `yuki-sign-on`: everything that changes at a stop, held
/// until the next one.
@immutable
class DsSignOnFrame {
  const DsSignOnFrame({
    required this.percent,
    required this.opacity,
    required this.brightness,
    required this.glowBlurs,
  });

  /// The stop this frame belongs to. It holds until the next stop's time.
  final double percent;

  /// CSS `opacity`, applied **after** [brightnessFilter] — see [DsSignOn].
  final double opacity;

  /// The multiplier inside `filter: brightness(x)`.
  final double brightness;

  /// The `text-shadow` blur radii **in CSS px**, innermost first. Empty is
  /// `text-shadow: none`.
  final List<double> glowBlurs;

  /// `filter: brightness(x)` — a per-channel sRGB multiply, clamped, which is
  /// exactly what a colour matrix with `x` down its diagonal does (ruling M3:
  /// ship the live filter; the map's precomputed colour table is a probe
  /// oracle, not the source).
  ColorFilter get brightnessFilter => ColorFilter.matrix(<double>[
        brightness, 0, 0, 0, 0, //
        0, brightness, 0, 0, 0, //
        0, 0, brightness, 0, 0, //
        0, 0, 0, 1, 0, //
      ]);

  /// [glowBlurs] as painter shadows in [color] — `currentColor`, which on this
  /// demo is `text-value-ink`.
  List<Shadow> shadows(Color color) => <Shadow>[
        for (final double blur in glowBlurs)
          Shadow(color: color, blurRadius: DsSignOn.blurRadiusFor(blur)),
      ];
}

/// `@keyframes yuki-sign-on` — globals.css L2474–2481, worn by `.anim-sign-on`
/// (`animation: yuki-sign-on 0.9s steps(1, end) both`, L2420–2422).
///
/// *"Neon power-up: flickers on, drops out, catches. Drives text-shadow, so it
/// only works on text."*
///
/// `steps(1, jump-end)` applied *between every pair of stops* means *no
/// interpolation at all*: each stop's value is held until the next stop's time,
/// then snaps. Six hard cuts, so this is modelled as a discrete timeline
/// ([frameAt]) rather than as a tween.
///
/// | stop | window | opacity | text-shadow | brightness |
/// |---|---|---|---|---|
/// | 0% | 0–144ms | 0.12 | none | 0.5 |
/// | 16% | 144–252ms | 1 | `0 0 8px`, `0 0 22px` | 1.35 |
/// | 28% | 252–396ms | 0.2 | none | 0.6 |
/// | 44% | 396–504ms | 1 | `0 0 8px`, `0 0 22px` | 1.3 |
/// | 56% | 504–630ms | 0.35 | `0 0 4px` | 0.75 |
/// | 70%, 100% | 630–900ms, then held | 1 | `0 0 6px`, `0 0 18px` | 1.15 |
///
/// **The resting state is not neutral.** `both` holds the 70% frame forever, so
/// the word keeps its glow at brightness 1.15 after the animation ends. Do not
/// fade it out.
///
/// Render order is the filter spec's: draw the text **and its shadows**, apply
/// [DsSignOnFrame.brightnessFilter], then apply [DsSignOnFrame.opacity].
///
/// DRIFT D9. The page's own Don't #3 reads *"Don't flash, strobe or rapidly
/// alternate brightness; it is an accessibility hazard"*, and this animation
/// alternates opacity 0.12 → 1 → 0.2 → 1 → 0.35 → 1 with brightness 0.5 → 1.35
/// → 0.6 → 1.3 → 0.75 → 1.15 across six cuts in 900ms — about 3.3 alternations
/// per second. Under the 3Hz hazard threshold, but it is the exact behaviour
/// the rule names. Both ship.
class DsSignOn {
  const DsSignOn._();

  static const Duration duration = DsDurations.signOn;
  static const DsKeyframeFill fill = DsKeyframeFill.both;

  /// `steps(1, end)`. Recorded for the transcript; [frameAt] is what evaluates
  /// the timeline, because a one-step curve between every pair of stops is a
  /// lookup, not an interpolation.
  static const Curve curve = DsSteps(1);

  /// The 100% stop repeats the 70% stop verbatim, so the table has six rows,
  /// not seven.
  static const List<DsSignOnFrame> frames = <DsSignOnFrame>[
    // allow-hardcoded: yuki-sign-on geometry (globals.css L2474–2481)
    DsSignOnFrame(
      percent: 0,
      opacity: 0.12,
      brightness: 0.5,
      glowBlurs: <double>[],
    ),
    // allow-hardcoded: yuki-sign-on geometry (globals.css L2474–2481)
    DsSignOnFrame(
      percent: 16,
      opacity: 1,
      brightness: 1.35,
      glowBlurs: <double>[8, 22],
    ),
    // allow-hardcoded: yuki-sign-on geometry (globals.css L2474–2481)
    DsSignOnFrame(
      percent: 28,
      opacity: 0.2,
      brightness: 0.6,
      glowBlurs: <double>[],
    ),
    // allow-hardcoded: yuki-sign-on geometry (globals.css L2474–2481)
    DsSignOnFrame(
      percent: 44,
      opacity: 1,
      brightness: 1.3,
      glowBlurs: <double>[8, 22],
    ),
    // allow-hardcoded: yuki-sign-on geometry (globals.css L2474–2481)
    DsSignOnFrame(
      percent: 56,
      opacity: 0.35,
      brightness: 0.75,
      glowBlurs: <double>[4],
    ),
    // allow-hardcoded: yuki-sign-on geometry (globals.css L2474–2481)
    DsSignOnFrame(
      percent: 70,
      opacity: 1,
      brightness: 1.15,
      glowBlurs: <double>[6, 18],
    ),
  ];

  /// The frame in force at linear progress [t] — the last stop whose percentage
  /// has been reached. At `t == 1` that is the 70% frame, which `both` then
  /// holds for good.
  static DsSignOnFrame frameAt(double t) {
    final double percent = t.clamp(0.0, 1.0) * 100;
    DsSignOnFrame held = frames.first;
    for (final DsSignOnFrame frame in frames) {
      if (frame.percent > percent) break;
      held = frame;
    }
    return held;
  }

  /// The [Shadow.blurRadius] that reproduces a CSS `text-shadow` blur.
  ///
  /// `text-shadow: 0 0 Npx c` is offset 0 and **blur N** — the same quantity
  /// `box-shadow` spells third, and therefore the same conversion. Borrowed
  /// from [DsShadowLayer.blurRadius] rather than re-derived, so a correction
  /// there carries here: CSS defines its blur as sigma = blur ÷ 2 while Flutter
  /// derives sigma from a radius, and the port inverts Flutter's formula instead
  /// of inflating every halo.
  static double blurRadiusFor(double cssBlur) =>
      DsShadowLayer(0, 0, cssBlur, 0, _unusedColor).blurRadius;

  /// [DsShadowLayer] resolves its colour against the theme; this one is only
  /// ever asked for its blur.
  static Color _unusedColor(DsThemeData theme) => dsTransparent;
}

/// `@keyframes pulls-reveal` — globals.css L2503–2512, worn by `.anim-reveal`
/// (`animation: pulls-reveal var(--duration-reward) var(--ease-out) both`,
/// L2341–2343).
///
/// ```css
/// from { opacity: 0; transform: rotateY(-38deg) scale(0.9); }
/// to   { opacity: 1; transform: none; }
/// ```
///
/// *"The card turning face-up. Rotates on the Y axis. Ours, not Yuki's."*
///
/// **Orthographic** (ruling M4). The element carries no `perspective`, and
/// neither does any ancestor, so the rotation has no foreshortening: it is a
/// flat horizontal squash. [transformAt] therefore never sets the perspective
/// entry of the matrix. Adding it would look better and would be wrong.
/// cos(38°) = 0.78801, so at t=0 the box is 78.8% of its width — and 0.9 of
/// that again from the uniform scale.
///
/// Like `.anim-pop-in` this one also gets the blanket rule's redundant special
/// case (`opacity: 1; transform: none !important`); the `both` fill already
/// holds exactly that.
class DsReveal {
  const DsReveal._();

  static const Duration duration = DsDurations.reward;
  static const Curve curve = DsCurves.out;
  static const DsKeyframeFill fill = DsKeyframeFill.both;

  /// The `from` stop's `rotateY`.
  static const double fromDegrees = -38; // allow-hardcoded: pulls-reveal
  static const double fromRadians = fromDegrees * math.pi / 180;

  /// The `from` stop's uniform `scale`.
  static const double fromScale = 0.9; // allow-hardcoded: pulls-reveal

  static const List<DsKeyframeStop<double>> opacityStops =
      <DsKeyframeStop<double>>[
    DsKeyframeStop(0, 0), // allow-hardcoded: pulls-reveal geometry
    DsKeyframeStop(100, 1), // allow-hardcoded: pulls-reveal geometry
  ];

  static const List<DsKeyframeStop<double>> rotationYStops =
      <DsKeyframeStop<double>>[
    DsKeyframeStop(0, fromRadians),
    DsKeyframeStop(100, 0),
  ];

  static const List<DsKeyframeStop<double>> scaleStops =
      <DsKeyframeStop<double>>[
    DsKeyframeStop(0, fromScale),
    DsKeyframeStop(100, 1), // allow-hardcoded: pulls-reveal geometry
  ];

  static final Animatable<double> opacity =
      DsKeyframes.doubles(opacityStops, curve: curve);

  /// Radians, for `Transform` — CSS states it in degrees.
  static final Animatable<double> rotationY =
      DsKeyframes.doubles(rotationYStops, curve: curve);

  static final Animatable<double> scale =
      DsKeyframes.doubles(scaleStops, curve: curve);

  /// `rotateY(θ) scale(s)`, in that order: CSS applies a transform list left to
  /// right, so the scale happens in the rotated frame.
  ///
  /// Note what is *not* here: no `setEntry(3, 2, …)`. That entry is the
  /// perspective divisor, and the reference has no perspective to divide by.
  static Matrix4 transformAt(double t) {
    final double s = scale.transform(t.clamp(0.0, 1.0));
    return Matrix4.identity()
      ..rotateY(rotationY.transform(t.clamp(0.0, 1.0)))
      // CSS `scale(s)` is the 2-D one: z is left alone.
      ..scaleByDouble(s, s, 1.0, 1.0);
  }
}

/// `@keyframes pulls-shimmer` — globals.css L2513–2520, worn by `.anim-shimmer`
/// (L2344–2353), which also supplies the paint the keyframes slide:
///
/// ```css
/// background: linear-gradient(90deg, var(--popover) 0%, var(--accent) 50%,
///                             var(--popover) 100%);
/// background-size: 200% 100%;
/// animation: pulls-shimmer 1.4s var(--ease-in-out) infinite;
/// ```
/// ```css
/// from { background-position:  200% 0; }
/// to   { background-position: -200% 0; }
/// ```
///
/// *"Skeleton loading. Must match the footprint of the content it replaces."*
///
/// The arithmetic that makes this readable: a CSS percentage
/// `background-position` is `(containerW − imageW) · pct`, and the tile is
/// `2W` wide, so the offset is `−W · pct`. `200%` puts the tile's left edge at
/// **−2W** and `−200%` at **+2W**; the bright `--accent` band sits at the
/// tile's midpoint and therefore crosses from **−W to +3W, left to right**, once
/// per cycle.
///
/// `background-repeat` defaults to `repeat`, which is not decoration — it is
/// why the box is never empty at the extremes, and why this port's
/// reduced-motion freeze agrees with motion-map §8.2 even though the two name
/// different numbers. §8.2 says a no-fill looper reverts to the element's own
/// `background-position: 0% 0` (offset 0); a stop-0 freeze puts it at −2W. Those
/// differ by exactly one tile period, so they paint the same pixels: dark at the
/// left edge, the `--accent` band at the box's right edge. Paint it with a
/// repeating tile, not a single band.
///
/// Colours resolve from the live theme on every build. Freezing them would
/// break the light theme, where both stops are near-white.
class DsShimmer {
  const DsShimmer._();

  static const Duration duration = DsDurations.shimmer;
  static const Curve curve = DsCurves.inOut;
  static const DsKeyframeFill fill = DsKeyframeFill.none;
  static const bool loops = true;

  /// `background-size: 200% 100%` — the tile is twice the box wide.
  static const double tileFactor = 2; // allow-hardcoded: background-size: 200%

  /// `from { background-position: 200% 0 }`, as a fraction.
  static const double fromPercent = 2; // allow-hardcoded: pulls-shimmer

  /// `to { background-position: -200% 0 }`.
  static const double toPercent = -2; // allow-hardcoded: pulls-shimmer

  /// `2W` on a box of [width].
  static double tileWidth(double width) => width * tileFactor;

  /// The tile's left edge, in the box's own coordinates, at linear progress
  /// [t]. The curve is applied here so the page and its probes cannot disagree
  /// about where the band is.
  static double offsetAt(double t, double width) {
    final double eased = curve.transform(t.clamp(0.0, 1.0));
    final double percent = fromPercent + (toPercent - fromPercent) * eased;
    return -width * percent;
  }

  /// Where the bright `--accent` stop is: the tile's midpoint. Travels from
  /// `−width` to `+3·width`.
  static double bandCenterAt(double t, double width) =>
      offsetAt(t, width) + width;

  /// `linear-gradient(90deg, --popover 0%, --accent 50%, --popover 100%)`,
  /// resolved against the live theme.
  static LinearGradient gradient(DsThemeData theme) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: <Color>[theme.popover, theme.accent, theme.popover],
        stops: const <double>[0, 0.5, 1],
        tileMode: TileMode.repeated,
      );
}

/// `@keyframes pulls-pulse-live` — globals.css L2521–2531, worn by
/// `.anim-pulse-live` (`animation: pulls-pulse-live 2s var(--ease-in-out)
/// infinite`, L2354–2356).
///
/// ```css
/// 0%, 100% { opacity: 1;    box-shadow: 0 0 0 0   rgba(61, 220, 151, 0.5); }
/// 50%      { opacity: 0.75; box-shadow: 0 0 0 5px rgba(61, 220, 151, 0); }
/// ```
///
/// *"The only animation allowed to run forever, and only on the live
/// indicator."*
///
/// Offset 0, blur 0, **spread** 0 → 5px, alpha 0.5 → 0: a hard-edged ring
/// growing out of the 8px dot as it fades. Flutter has no hard CSS spread, so
/// the ring is a filled circle of [ringRadiusAt] behind the dot, at
/// [ringAlphaAt]; both halves of the cycle interpolate on `--ease-in-out`,
/// which is what makes the return leg a contraction rather than a cut.
///
/// Under reduced motion this reverts to stop 0 — ring phase 0, i.e. a circle of
/// exactly the dot's own radius, hidden behind it. Which is motion-map §8.2's
/// *"plain 8px `--color-success` dot, no ring, opacity 1"* arrived at from the
/// other direction.
///
/// DRIFT D14. `rgba(61, 220, 151, α)` is **#3DDC97**, a hard-coded green left
/// over from an earlier palette, while the dot it rings is `bg-success`
/// **#10b981**. Two different greens, in both themes, on one 8px indicator.
/// Ported as written — there is nothing for the ring colour to derive from.
class DsPulseLive {
  const DsPulseLive._();

  static const Duration duration = DsDurations.pulseLive;
  static const Curve curve = DsCurves.inOut;
  static const DsKeyframeFill fill = DsKeyframeFill.none;
  static const bool loops = true;

  /// The demo's dot: `size-2` (8px) `rounded-full bg-success`.
  static double get dotDiameter => ds(2);
  static double get dotRadius => ds(2) / 2;
  static Color get dotColor => DsPalette.success;

  /// `rgba(61, 220, 151, …)` — drift D14, a palette orphan.
  static final Color ringColor =
      const Color(0xFF3DDC97); // allow-hardcoded: rgba(61,220,151) ring (L2521)

  /// The 50% stop's `box-shadow` spread.
  static const double ringSpread = 5; // allow-hardcoded: pulls-pulse-live

  /// The 0%/100% stops' ring alpha.
  static const double ringAlpha = 0.5; // allow-hardcoded: pulls-pulse-live

  /// 0 at the resting stops, 1 at the 50% stop: the ring's own progress, which
  /// drives both its radius and its fade.
  static const List<DsKeyframeStop<double>> ringPhaseStops =
      <DsKeyframeStop<double>>[
    DsKeyframeStop(0, 0), // allow-hardcoded: pulls-pulse-live geometry
    DsKeyframeStop(50, 1), // allow-hardcoded: pulls-pulse-live geometry
    DsKeyframeStop(100, 0), // allow-hardcoded: pulls-pulse-live geometry
  ];

  static const List<DsKeyframeStop<double>> dotOpacityStops =
      <DsKeyframeStop<double>>[
    DsKeyframeStop(0, 1), // allow-hardcoded: pulls-pulse-live geometry
    DsKeyframeStop(50, 0.75), // allow-hardcoded: pulls-pulse-live geometry
    DsKeyframeStop(100, 1), // allow-hardcoded: pulls-pulse-live geometry
  ];

  static final Animatable<double> ringPhase =
      DsKeyframes.doubles(ringPhaseStops, curve: curve);

  static final Animatable<double> dotOpacity =
      DsKeyframes.doubles(dotOpacityStops, curve: curve);

  /// `4 + 5·phase`: the CSS spread measured out from the dot's own edge.
  static double ringRadiusAt(double t) =>
      dotRadius + ringSpread * ringPhase.transform(t.clamp(0.0, 1.0));

  /// `0.5 · (1 − phase)`.
  static double ringAlphaAt(double t) =>
      ringAlpha * (1 - ringPhase.transform(t.clamp(0.0, 1.0)));

  static Color ringColorAt(double t) =>
      ringColor.withValues(alpha: ringAlphaAt(t));

  static double dotOpacityAt(double t) =>
      dotOpacity.transform(t.clamp(0.0, 1.0));
}

/// `@keyframes ds-sweep` — globals.css L2195–2202, the motion page's own.
///
/// ```css
/// from { width: 0; }
/// to   { width: 100%; }
/// ```
///
/// Applied inline per duration row as `ds-sweep {ms}ms var(--ease-out) both`.
/// **There is no duration constant here on purpose**: the durations panel *is*
/// the duration scale, so the caller supplies one of the six from
/// [DsDurations] per row, and the page's source carries an
/// `allow-dynamic-motion:` note saying so.
///
/// Two paint details travel with the table. The track is `overflow-hidden`, so
/// a clip is enough — no `Positioned` arithmetic. And the bar itself carries
/// `rounded-sm`, so at small widths it renders as a 6px-radius pill rather than
/// a square sliver.
///
/// Its reduced-motion row is the page's own joke on itself: `both` holds `to`,
/// so all six bars freeze full-width and identical, and the section's entire
/// point is destroyed by design.
class DsSweep {
  const DsSweep._();

  static const Curve curve = DsCurves.out;
  static const DsKeyframeFill fill = DsKeyframeFill.both;

  static const List<DsKeyframeStop<double>> widthFactorStops =
      <DsKeyframeStop<double>>[
    DsKeyframeStop(0, 0), // allow-hardcoded: ds-sweep geometry
    DsKeyframeStop(100, 1), // allow-hardcoded: ds-sweep geometry
  ];

  /// `0 → 1`, for a `FractionallySizedBox.widthFactor` inside the clipped
  /// track.
  static final Animatable<double> widthFactor =
      DsKeyframes.doubles(widthFactorStops, curve: curve);
}

/// `@keyframes ds-travel` — globals.css L2203–2210, the motion page's other
/// own, and **a verified no-op**.
///
/// ```css
/// from { transform: translateX(0); }
/// to   { transform: translateX(calc(100% - 1.5rem)); }
/// ```
///
/// Ruling M1: the supervisor confirmed live that all four easing chips hold
/// `matrix(1,0,0,1,0,0)` across the run on a 482px track. The mechanism is the
/// CSS transform spec — a percentage inside `translateX` resolves against **the
/// transformed element's own border box**, never its parent's. The chip is
/// `size-6`, 24px, so `100%` is 24px and `calc(100% − 1.5rem)` is **0px**. The
/// animation runs its full [DsDurations.bloom] and translates by nothing; the
/// four panels communicate their curve through the graph alone, and the lime
/// square is static.
///
/// So this ships as `translateX(elementWidth − 24px)`: it evaluates to 0 at the
/// one call site, and stays faithful if the utility is ever reused on a wider
/// element. **If upstream ever fixes it**, the intended reading is "travel the
/// track, minus the chip's own width" — one line here: pass the *track's* width
/// to [distanceFor] instead of the chip's.
///
/// Curve is the caller's: each easing panel runs the chip under its own curve,
/// over a deliberately identical time, so the four can be judged against each
/// other.
class DsTravel {
  const DsTravel._();

  static const Duration duration = DsDurations.bloom;
  static const DsKeyframeFill fill = DsKeyframeFill.both;

  /// `1.5rem`, the `size-6` chip's own width, subtracted by the `calc`.
  static double get inset => ds(6);

  /// `calc(100% - 1.5rem)` where `100%` is [elementWidth]. Zero on the 24px
  /// chip; 458 on the 482px track it looks like it should be crossing.
  static double distanceFor(double elementWidth) => elementWidth - inset;

  /// The `translateX` in force at linear progress [t].
  static double translationAt(
    double t,
    double elementWidth, {
    required Curve curve,
  }) =>
      distanceFor(elementWidth) * curve.transform(t.clamp(0.0, 1.0));
}

// ─────────────────────────────────────────────────────────────────────────────
// E · the selection-control tables
// ─────────────────────────────────────────────────────────────────────────────
// Three more `@keyframes` (globals.css L2212–2242) and their three `anim-*`
// utilities (L2243–2253). They belong to the form controls rather than to the
// motion page, which is why they are not among the eleven above and why the
// motion page never demonstrates them.
//
// Two of the three animate `stroke-dashoffset`, a property Flutter has no
// direct spelling for. The transcription keeps the CSS number and leaves the
// drawing to the consumer: a checkbox paints its tick with a
// `PathMetric.extractPath` window, and `dashoffset → 0` is that window opening
// from nothing to the whole stroke. Recording the offset rather than a
// "fraction drawn" keeps the table diffable against the stylesheet.

/// `@keyframes check-draw` — globals.css L2212–2219, worn by
/// `.anim-check-draw` (`stroke-dasharray: 22; animation: check-draw 280ms
/// var(--ease-out) both`, L2243–2246).
///
/// ```css
/// from { stroke-dashoffset: 22; }
/// to   { stroke-dashoffset: 0; }
/// ```
///
/// The checkbox tick draws itself on. `stroke-dasharray: 22` makes the dash as
/// long as the path (the hand-authored `M5 12.5 10 17.5 19 7` measures just
/// under 22 units), so one dash covers the whole stroke and the offset slides
/// it into view from the start point.
class DsCheckDraw {
  const DsCheckDraw._();

  static const Duration duration = DsDurations.checkDraw;
  static const Curve curve = DsCurves.out;
  static const DsKeyframeFill fill = DsKeyframeFill.both;

  /// `stroke-dasharray: 22` — the utility's own declaration, not a keyframe.
  /// Also the `from` offset, because one dash has to cover the whole path.
  static const double dashArray = 22; // allow-hardcoded: check-draw geometry

  static const List<DsKeyframeStop<double>> dashOffsetStops =
      <DsKeyframeStop<double>>[
    DsKeyframeStop(0, dashArray),
    DsKeyframeStop(100, 0),
  ];

  static final Animatable<double> dashOffset =
      DsKeyframes.doubles(dashOffsetStops, curve: curve);

  /// The same table read as "how much of the stroke is painted", `0..1` — the
  /// form a [Path] consumer wants.
  ///
  /// Derived from [dashOffset] rather than tabulated beside it: two tables
  /// stating the same animation is how they drift.
  static double drawnFractionAt(double t) =>
      1 - dashOffset.transform(t.clamp(0.0, 1.0)) / dashArray;
}

/// `@keyframes dash-draw` — globals.css L2220–2227, worn by `.anim-dash-draw`
/// (`stroke-dasharray: 12; animation: dash-draw 200ms var(--ease-out) both`,
/// L2247–2250).
///
/// ```css
/// from { stroke-dashoffset: 12; }
/// to   { stroke-dashoffset: 0; }
/// ```
///
/// The checkbox's indeterminate bar, `M6 12h12` — 12 units long, drawn over
/// 200ms rather than the tick's 280 because there is less of it to draw. Same
/// mechanism, different length; the pair is why both numbers are stated.
class DsDashDraw {
  const DsDashDraw._();

  static const Duration duration = DsDurations.dashDraw;
  static const Curve curve = DsCurves.out;
  static const DsKeyframeFill fill = DsKeyframeFill.both;

  /// `stroke-dasharray: 12`.
  static const double dashArray = 12; // allow-hardcoded: dash-draw geometry

  static const List<DsKeyframeStop<double>> dashOffsetStops =
      <DsKeyframeStop<double>>[
    DsKeyframeStop(0, dashArray),
    DsKeyframeStop(100, 0),
  ];

  static final Animatable<double> dashOffset =
      DsKeyframes.doubles(dashOffsetStops, curve: curve);

  /// See [DsCheckDraw.drawnFractionAt].
  static double drawnFractionAt(double t) =>
      1 - dashOffset.transform(t.clamp(0.0, 1.0)) / dashArray;
}

/// `@keyframes dot-pop` — globals.css L2228–2242, worn by `.anim-dot-pop`
/// (`animation: dot-pop 320ms var(--ease-spring) both`, L2251–2253).
///
/// ```css
/// 0%   { transform: scale(0);    opacity: 0; }
/// 55%  { transform: scale(1.35); opacity: 1; }
/// 100% { transform: scale(1);    opacity: 1; }
/// ```
///
/// The radio dot arriving. The one table here that runs on `--ease-spring`
/// rather than `--ease-out`, and it overshoots twice over: the 1.35 stop is the
/// keyframe's own overshoot, and the spring curve overshoots *between* stops on
/// top of it.
///
/// [opacity] is declared at all three stops and reaches 1 at 55%, the same
/// instant the dot is at its widest — so the flash and the peak land together.
class DsDotPop {
  const DsDotPop._();

  static const Duration duration = DsDurations.dotPop;
  static const Curve curve = DsCurves.spring;
  static const DsKeyframeFill fill = DsKeyframeFill.both;

  static const List<DsKeyframeStop<double>> scaleStops =
      <DsKeyframeStop<double>>[
    DsKeyframeStop(0, 0), // allow-hardcoded: dot-pop geometry
    DsKeyframeStop(55, 1.35), // allow-hardcoded: dot-pop geometry
    DsKeyframeStop(100, 1), // allow-hardcoded: dot-pop geometry
  ];

  static const List<DsKeyframeStop<double>> opacityStops =
      <DsKeyframeStop<double>>[
    DsKeyframeStop(0, 0), // allow-hardcoded: dot-pop geometry
    DsKeyframeStop(55, 1), // allow-hardcoded: dot-pop geometry
    DsKeyframeStop(100, 1), // allow-hardcoded: dot-pop geometry
  ];

  static final Animatable<double> scale =
      DsKeyframes.doubles(scaleStops, curve: curve);

  static final Animatable<double> opacity =
      DsKeyframes.doubles(opacityStops, curve: curve);
}

// ─────────────────────────────────────────────────────────────────────────────
// F · a transition, not a keyframe
// ─────────────────────────────────────────────────────────────────────────────

/// `@utility swap-roll` — globals.css L2265–2271, the IconSwap wheel.
///
/// ```css
/// --swap-offset: 0;
/// transform: translateY(calc(var(--swap-offset) * 160%));
/// transition:
///   transform var(--duration-slow) var(--ease-spring),
///   opacity   var(--duration-slow) var(--ease-spring);
/// ```
///
/// A **transition**, not an animation: there are no stops, only a from-state
/// and a to-state, and the browser interpolates whenever `--swap-offset`
/// changes. It is recorded in this file rather than inline in `icon_swap.dart`
/// because it is the one motion table that file needs and because its three
/// facts — 400ms, `--ease-spring`, 160% per step — are stated once here and
/// nowhere else.
///
/// Two consequences of the curve, both visible and both deliberate:
///
/// * **The arriver sails past centre.** `--ease-spring` peaks at ≈1.098 around
///   57% of the run, so a glyph rolling in overshoots its resting position by
///   ≈9.8% of one step — ~2.5px at 16px, ~3.1px at 20px — before settling.
/// * **There is a crossfade inside the roll.** `opacity` rides the same spring,
///   and because the curve exceeds 1 the value clamps: full opacity is reached
///   at ≈147ms of the 400ms roll. The panel's own copy says *"No crossfades"*
///   (buttons-map drift 20); the stylesheet says otherwise, and this is the
///   stylesheet.
///
/// The squash that lands on the arriving glyph is [DsJelly], delayed by
/// `--duration-fast` — see `icon_swap.dart`, which owns that composition.
class DsSwapRoll {
  const DsSwapRoll._();

  /// `--duration-slow`, on both properties.
  static const Duration duration = DsDurations.slow;

  /// `--ease-spring`, on both properties. Not `--ease-out`: the wheel is meant
  /// to overshoot.
  static const Curve curve = DsCurves.spring;

  /// `160%` of the translated box per step — [DsTransforms.swapRollTravel].
  ///
  /// A CSS percentage translate resolves against the element's **own** border
  /// box, so [travelFor] takes the strip cell's height, which is the glyph's
  /// height: every cell is `place-items-center` around one icon.
  static double travelFor(double cellHeight) =>
      cellHeight * DsTransforms.swapRollTravel;

  /// `animation-delay: var(--duration-fast)` on the inner squash
  /// (`icon-swap.tsx`) — the roll is a third of the way home before the glyph
  /// starts to squash.
  static const Duration squashDelay = DsDurations.fast;
}
