/// The twelve motion recipes — the design system's whole animation
/// vocabulary on Flutter, mirroring `styles/motion.css` on the web:
///
///   EnterMotion · ExitMotion        content arriving / leaving in place
///   OpenMotion · CloseMotion        an overlay arriving / leaving
///   ExpandMotion                    disclosure on height (reverse = collapse)
///   ChangeMotion                    "this value just changed"
///   SpinMotion · ShimmerMotion · ProgressMotion · PulseMotion · CaretMotion
///                                   the loops: the signal nothing has stalled
///   SwapRollMotion                  the IconSwap wheel
///
/// Plus `Press` (press.dart) and `ActiveIndicator` (active_indicator.dart) —
/// the two transitions — which makes fourteen. A recipe is data: duration,
/// curve, fill and stop tables. A component plays it through [KeyframePlayer]
/// or its own controller. Adding a thirteenth recipe is a design decision,
/// not a convenience.
///
/// Three mechanics decide everything here: a timing function eases between
/// adjacent stops, not across the run ([Keyframes.track] is a
/// [TweenSequence] with one curved item per gap); a property declared at some
/// stops and not others holds ([ConstantTween] tails); and [KeyframeFill]
/// decides what reduced motion freezes to — `both` holds the last stop, a
/// loop with no fill reverts to rest.
library;

import 'dart:math' as math;

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
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/theme_scope.dart';

// ─────────────────────────────────────────────────────────────────────────────
// A · steps()
// ─────────────────────────────────────────────────────────────────────────────

/// CSS `steps(n)` — the timing function with no interpolation in it.
///
/// Two of the web system's animations need it and Flutter ships nothing
/// equivalent: a stepped ratchet spin, `steps(8)`, and a hard-cut text
/// reveal, `steps(1, end)`.
///
/// CSS `steps(n)` means `steps(n, jump-end)`: **`n` held positions**, the first
/// at 0 and the last at `(n−1)/n`. The output `1` belongs to the instant the
/// animation ends, which for an infinite loop is the same instant as the next
/// cycle's 0 — so a stepped ratchet never displays 360°, it wraps to 0°.
///
/// [transform] is overridden rather than `transformInternal` on purpose. The
/// base [Curve] short-circuits `t == 0.0` and `t == 1.0` to themselves, and
/// `t == 1.0` is exactly the frame this curve must not answer `n/n = 1` for.
/// Consequence worth knowing at the call site: `CurvedAnimation` performs the
/// same short-circuit itself, so a ratchet driven through one would still show
/// 360° on the wrap frame.
@immutable
class StepCurve extends Curve {
  const StepCurve(this.count, {this.jumpEnd = true}) : assert(count > 0);

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
    final double index = math.min(
      (t * count).floorToDouble() + 1,
      count.toDouble(),
    );
    return index / count;
  }

  @override
  bool operator ==(Object other) =>
      other is StepCurve && other.count == count && other.jumpEnd == jumpEnd;

  @override
  int get hashCode => Object.hash(count, jumpEnd);

  @override
  String toString() =>
      'StepCurve($count, ${jumpEnd ? 'jump-end' : 'jump-start'})';
}

// ─────────────────────────────────────────────────────────────────────────────
// B · fill mode
// ─────────────────────────────────────────────────────────────────────────────

/// CSS `animation-fill-mode`, as far as this system's motion vocabulary
/// uses it.
///
/// The hinge of the reduced-motion table (motion-map §8.2). The blanket rule
/// collapses durations and iteration counts; it never touches fill mode, so
/// fill mode alone decides the frozen frame.
enum KeyframeFill {
  /// `both` — the first stop applies before the run and the last one is held
  /// after it. Every finite animation on the page declares it.
  both,

  /// No fill mode declared: outside its run the element wears its own resting
  /// style, which is what a keyframe table calls stop 0. Every looper.
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
class KeyframeStop<T> {
  const KeyframeStop(this.percent, this.value);

  /// The keyframe's own `0%`…`100%`.
  final double percent;

  /// The value declared for this property at [percent].
  final T value;

  @override
  String toString() => '$percent% → $value';
}

/// Turns a keyframe table into an [Animatable].
///
/// The generalisation of the private `_jellyScale` in `active_indicator.dart`: one
/// [TweenSequenceItem] per gap between adjacent stops, each carrying its own
/// [CurveTween], weighted by the gap in percentage points.
class Keyframes {
  const Keyframes._();

  /// [stops] must start at `0%` and ascend.
  ///
  /// A table whose last stop is short of 100% **holds** its last value for the
  /// remainder — that is what CSS does with a property that stops being
  /// declared, and it is modelled here as an explicit [ConstantTween] tail
  /// rather than left to emerge from two equal values.
  ///
  /// [lerp] keeps this generic over the value type; [doubles] and [offsets]
  /// are the two shapes the twelve recipes actually need.
  static Animatable<T> track<T>(
    List<KeyframeStop<T>> stops, {
    required Curve curve,
    required T Function(T a, T b, double t) lerp,
  }) {
    assert(stops.isNotEmpty, 'a keyframe table has at least one stop');
    assert(stops.first.percent == 0, 'a keyframe table starts at 0%');
    assert(stops.last.percent <= 100, 'a keyframe table ends by 100%');

    final List<TweenSequenceItem<T>> items = <TweenSequenceItem<T>>[];
    for (int i = 1; i < stops.length; i++) {
      assert(stops[i].percent > stops[i - 1].percent, 'stops ascend');
      items.add(
        TweenSequenceItem<T>(
          tween: _LerpTween<T>(
            begin: stops[i - 1].value,
            end: stops[i].value,
            lerpValue: lerp,
          ).chain(CurveTween(curve: curve)),
          weight: stops[i].percent - stops[i - 1].percent,
        ),
      );
    }

    final double declared = stops.last.percent;
    if (declared < 100) {
      items.add(
        TweenSequenceItem<T>(
          tween: ConstantTween<T>(stops.last.value),
          weight: 100 - declared,
        ),
      );
    }
    return TweenSequence<T>(items);
  }

  /// [track] for a scalar property — opacity, a translation, a rotation.
  static Animatable<double> doubles(
    List<KeyframeStop<double>> stops, {
    required Curve curve,
  }) => track<double>(stops, curve: curve, lerp: _lerpDouble);

  /// [track] for a two-axis property. `dx` carries `scaleX`, `dy` `scaleY` —
  /// the spelling `active_indicator.dart` established for `scale3d`.
  static Animatable<Offset> offsets(
    List<KeyframeStop<Offset>> stops, {
    required Curve curve,
  }) => track<Offset>(stops, curve: curve, lerp: _lerpOffset);

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;

  static Offset _lerpOffset(Offset a, Offset b, double t) =>
      Offset.lerp(a, b, t)!;
}

/// A [Tween] whose interpolation is supplied, so [Keyframes.track] can be
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
/// ([Keyframes.track]) and never here; a player that eased its own clock
/// would ease twice.
///
/// Reduced motion is the behaviour this widget exists for. `effectiveMotionDuration`
/// collapses the run, and [fill] decides the frame it collapses to: `both`
/// lands on the final stop, no fill lands on stop 0 (motion-map §8.2). It is
/// resolved by stopping the controller and setting its value outright, not by
/// running a zero-length animation — a zero-period `repeat()` has no meaning.
///
/// **There is deliberately no `replay()`.** The web system replays by
/// re-keying (motion-map §11): React remounts the element, and a freshly
/// mounted element
/// starts its CSS animation at t=0, mid-flight restarts included. Wrapping this
/// widget in `KeyedSubtree(key: ValueKey('$name-$run'))` reproduces that
/// exactly, because the controller is created in `initState` and started on the
/// first `didChangeDependencies`. A broadcast `forward(from: 0)` would not: it
/// cannot express a `both`-fill animation on a demo that has not been built
/// yet.
class KeyframePlayer extends StatefulWidget {
  const KeyframePlayer({
    super.key,
    required this.duration,
    required this.builder,
    this.fill = KeyframeFill.both,
    this.repeat = false,
    this.child,
  });

  /// The animation's own length. Some callers take a different one per demo,
  /// so this is a parameter rather than a table constant.
  final Duration duration;

  /// Decides the reduced-motion freeze frame, and nothing else.
  final KeyframeFill fill;

  /// The loopers. Also what puts a [RepaintBoundary] around [builder]'s
  /// output: something that animates forever must not repaint its neighbours.
  final bool repeat;

  /// Handed linear progress in `0..1`.
  final Widget Function(BuildContext context, double t, Widget? child) builder;

  /// Passed through to [builder] unrebuilt, the [AnimatedBuilder] contract.
  final Widget? child;

  @override
  State<KeyframePlayer> createState() => _KeyframePlayerState();
}

class _KeyframePlayerState extends State<KeyframePlayer>
    with SingleTickerProviderStateMixin {
  /// The duration named here is a placeholder for the first frame only:
  /// [build] re-reads it through [effectiveMotionDuration] on every pass, the way
  /// `Press` and `ActiveIndicator` do.
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
        effectiveMotionDuration(context, widget.duration) == Duration.zero;
    if (_stilled == stilled) return;
    _stilled = stilled;
    _play();
  }

  @override
  void didUpdateWidget(KeyframePlayer old) {
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
      // §8.2, the whole point of [KeyframeFill]: `both` holds the final
      // stop, no fill reverts to the element's resting style.
      _controller.value = widget.fill == KeyframeFill.both
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
    _controller.duration = effectiveMotionDuration(context, widget.duration);
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
// D · the twelve recipes
// ─────────────────────────────────────────────────────────────────────────────

/// anim-enter — 12px rise + fade + 0.97 scale, `slow` on `enter`.
class EnterMotion {
  const EnterMotion._();
  static const Duration duration = MotionDurations.slow;
  static const Curve curve = MotionCurves.enter;
  static const KeyframeFill fill = KeyframeFill.both;
  static const double rise = 12;
  static const double fromScale = 0.97;

  /// Stagger step for lists: half a tick per row (web `--enter-stage`).
  static Duration delayFor(int stage) => MotionDurations.tick * stage ~/ 2;
  static final Animatable<double> opacity = Tween<double>(
    begin: 0,
    end: 1,
  ).chain(CurveTween(curve: curve));
  static final Animatable<double> translateY = Tween<double>(
    begin: rise,
    end: 0,
  ).chain(CurveTween(curve: curve));
  static final Animatable<double> scale = Tween<double>(
    begin: fromScale,
    end: 1,
  ).chain(CurveTween(curve: curve));
}

/// anim-exit — 6px drop + fade + 0.98, `fast` on `exit`.
class ExitMotion {
  const ExitMotion._();
  static const Duration duration = MotionDurations.fast;
  static const Curve curve = MotionCurves.exit;
  static const KeyframeFill fill = KeyframeFill.both;
  static const double drop = 6;
  static const double toScale = 0.98;
  static final Animatable<double> opacity = Tween<double>(
    begin: 1,
    end: 0,
  ).chain(CurveTween(curve: curve));
  static final Animatable<double> translateY = Tween<double>(
    begin: 0,
    end: drop,
  ).chain(CurveTween(curve: curve));
  static final Animatable<double> scale = Tween<double>(
    begin: 1,
    end: toScale,
  ).chain(CurveTween(curve: curve));
}

/// anim-open — the overlay entrance. Stop tables [OpenTransition] reads
/// directly, rather than keeping a private copy of its own.
class OpenMotion {
  const OpenMotion._();
  static const Duration duration = MotionDurations.open;
  static const Curve curve = MotionCurves.emphasized;
  static const KeyframeFill fill = KeyframeFill.both;

  /// The one keyframe stop the web entrance declares between its ends.
  static const double break_ = 0.60;

  static const List<KeyframeStop<double>> opacityStops = <KeyframeStop<double>>[
    KeyframeStop(0, 0),
    KeyframeStop(60, 1),
  ];
  static const List<KeyframeStop<double>> scaleStops = <KeyframeStop<double>>[
    KeyframeStop(0, 0.92),
    KeyframeStop(60, 1.02),
    KeyframeStop(100, 1),
  ];
  static const List<KeyframeStop<double>> translateYStops =
      <KeyframeStop<double>>[
        KeyframeStop(0, 24),
        KeyframeStop(60, -4),
        KeyframeStop(100, 0),
      ];
  static final Animatable<double> opacity = Keyframes.doubles(
    opacityStops,
    curve: curve,
  );
  static final Animatable<double> scale = Keyframes.doubles(
    scaleStops,
    curve: curve,
  );
  static final Animatable<double> translateY = Keyframes.doubles(
    translateYStops,
    curve: curve,
  );
}

/// anim-close — the overlay exit. Anticipates up 4, drops 16, fades. Stop
/// tables [OpenTransition] reads directly.
class CloseMotion {
  const CloseMotion._();
  static const Duration duration = MotionDurations.normal;
  static const Curve curve = MotionCurves.move;
  static const KeyframeFill fill = KeyframeFill.both;

  /// The web exit's one keyframe stop.
  static const double break_ = 0.30;

  static const List<KeyframeStop<double>> opacityStops = <KeyframeStop<double>>[
    KeyframeStop(0, 1),
    KeyframeStop(30, 1),
    KeyframeStop(100, 0),
  ];
  static const List<KeyframeStop<double>> scaleStops = <KeyframeStop<double>>[
    KeyframeStop(0, 1),
    KeyframeStop(30, 1.01),
    KeyframeStop(100, 0.94),
  ];
  static const List<KeyframeStop<double>> translateYStops =
      <KeyframeStop<double>>[
        KeyframeStop(0, 0),
        KeyframeStop(30, -4),
        KeyframeStop(100, 16),
      ];
  static final Animatable<double> opacity = Keyframes.doubles(
    opacityStops,
    curve: curve,
  );
  static final Animatable<double> scale = Keyframes.doubles(
    scaleStops,
    curve: curve,
  );
  static final Animatable<double> translateY = Keyframes.doubles(
    translateYStops,
    curve: curve,
  );
}

/// anim-expand / anim-collapse — disclosure on height. One controller: forward
/// on `open` / `emphasized`, reverse on `normal` / `move`. No `Animatable`
/// here on purpose — a collapsible/accordion drives a [SizeTransition] off
/// these durations and curves directly.
class ExpandMotion {
  const ExpandMotion._();
  static const Duration duration = MotionDurations.open;
  static const Curve curve = MotionCurves.emphasized;
  static const Duration collapseDuration = MotionDurations.normal;
  static const Curve collapseCurve = MotionCurves.move;
}

/// anim-change — squash-and-stretch in place. The same stop table the
/// retired `StateChangeMotion` used to carry.
///
/// ```css
/// 0%   { transform: scale3d(1,    1,    1); }
/// 30%  { transform: scale3d(1.18, 0.82, 1); }
/// 45%  { transform: scale3d(0.88, 1.12, 1); }
/// 60%  { transform: scale3d(1.06, 0.94, 1); }
/// 78%  { transform: scale3d(0.98, 1.02, 1); }
/// 100% { transform: scale3d(1,    1,    1); }
/// ```
class ChangeMotion {
  const ChangeMotion._();
  static const Duration duration = MotionDurations.stateChange;
  static const Curve curve = MotionCurves.enter;
  static const KeyframeFill fill = KeyframeFill.both;

  static const List<KeyframeStop<Offset>> scaleStops = <KeyframeStop<Offset>>[
    KeyframeStop(0, Offset(1, 1)),
    KeyframeStop(30, Offset(1.18, 0.82)),
    KeyframeStop(45, Offset(0.88, 1.12)),
    KeyframeStop(60, Offset(1.06, 0.94)),
    KeyframeStop(78, Offset(0.98, 1.02)),
    KeyframeStop(100, Offset(1, 1)),
  ];

  static final Animatable<Offset> scale = Keyframes.offsets(
    scaleStops,
    curve: curve,
  );
}

/// anim-spin — one full turn, linear, forever.
class SpinMotion {
  const SpinMotion._();
  static const Duration duration = MotionDurations.spin;
  static const Curve curve = Curves.linear;
  static const KeyframeFill fill = KeyframeFill.none;
  static const bool loops = true;
}

/// anim-shimmer / anim-shimmer-text — the skeleton sweep, the same body
/// `LoadingShimmerMotion` used to carry; `textDuration` is the text variant's
/// slower period.
///
/// ```css
/// background: linear-gradient(90deg, var(--popover) 0%, var(--accent) 50%,
///                             var(--popover) 100%);
/// background-size: 200% 100%;
/// ```
/// ```css
/// from { background-position:  200% 0; }
/// to   { background-position: -200% 0; }
/// ```
class ShimmerMotion {
  const ShimmerMotion._();
  static const Duration duration = MotionDurations.shimmer;

  /// The agent's status line variant — the same sweep, at nearly twice the
  /// period.
  static const Duration textDuration = MotionDurations.shimmerText;
  static const Curve curve = MotionCurves.move;
  static const KeyframeFill fill = KeyframeFill.none;
  static const bool loops = true;

  /// `background-size: 200% 100%` — the tile is twice the box wide.
  static const double tileFactor = 2;

  /// `from { background-position: 200% 0 }`, as a fraction.
  static const double fromPercent = 2;

  /// `to { background-position: -200% 0 }`.
  static const double toPercent = -2;

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
  static LinearGradient gradient(ThemeTokens theme) => LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[theme.popover, theme.accent, theme.popover],
    stops: const <double>[0, 0.5, 1],
    tileMode: TileMode.repeated,
  );
}

/// anim-progress-indeterminate — a third-width sliver, −100% → 300%, linear.
class ProgressMotion {
  const ProgressMotion._();
  static const Duration duration = MotionDurations.shimmer; // web literal 1.4s == shimmer
  static const Curve curve = Curves.linear;
  static const bool loops = true;
  static const double sliverFraction = 1 / 3;
  static const double fromFraction = -1;
  static const double toFraction = 3;
}

/// anim-pulse — the live indicator's ring, the same body `LivePulseMotion`
/// used to carry.
///
/// ```css
/// 0%, 100% { opacity: 1;    box-shadow: 0 0 0 0   rgba(61, 220, 151, 0.5); }
/// 50%      { opacity: 0.75; box-shadow: 0 0 0 5px rgba(61, 220, 151, 0); }
/// ```
class PulseMotion {
  const PulseMotion._();
  static const Duration duration = MotionDurations.pulseLive;
  static const Curve curve = MotionCurves.move;
  static const KeyframeFill fill = KeyframeFill.none;
  static const bool loops = true;

  /// The demo's dot: `size-2` (8px) `rounded-full bg-success`.
  static double get dotDiameter => space(2);
  static double get dotRadius => space(2) / 2;
  static Color get dotColor => Palette.success;

  /// `rgba(61, 220, 151, …)` — a hard-coded green left over from an earlier
  /// palette, distinct from `bg-success`. Ported as written.
  static final Color ringColor = const Color(0xFF3DDC97);

  /// The 50% stop's `box-shadow` spread.
  static const double ringSpread = 5;

  /// The 0%/100% stops' ring alpha.
  static const double ringAlpha = 0.5;

  /// 0 at the resting stops, 1 at the 50% stop: the ring's own progress, which
  /// drives both its radius and its fade.
  static const List<KeyframeStop<double>> ringPhaseStops =
      <KeyframeStop<double>>[
        KeyframeStop(0, 0),
        KeyframeStop(50, 1),
        KeyframeStop(100, 0),
      ];

  static const List<KeyframeStop<double>> dotOpacityStops =
      <KeyframeStop<double>>[
        KeyframeStop(0, 1),
        KeyframeStop(50, 0.75),
        KeyframeStop(100, 1),
      ];

  static final Animatable<double> ringPhase = Keyframes.doubles(
    ringPhaseStops,
    curve: curve,
  );

  static final Animatable<double> dotOpacity = Keyframes.doubles(
    dotOpacityStops,
    curve: curve,
  );

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

/// anim-caret — on for half the period, off for half. steps(1, end).
class CaretMotion {
  const CaretMotion._();
  static const Duration duration = MotionDurations.caret;
  static const bool loops = true;
  static bool visibleAt(double t) => t < 0.5;
}

/// swap-roll — the IconSwap wheel, the same body `ContentSwapMotion` used to
/// carry.
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
/// changes.
class SwapRollMotion {
  const SwapRollMotion._();

  /// `--duration-slow`, on both properties.
  static const Duration duration = MotionDurations.slow;

  /// `--ease-spring`, on both properties. Not `--ease-out`: the wheel is meant
  /// to overshoot.
  static const Curve curve = MotionCurves.emphasized;

  /// `160%` of the translated box per step — [MotionTransforms.swapRollTravel].
  ///
  /// A CSS percentage translate resolves against the element's **own** border
  /// box, so [travelFor] takes the strip cell's height, which is the glyph's
  /// height: every cell is `place-items-center` around one icon.
  static double travelFor(double cellHeight) =>
      cellHeight * MotionTransforms.swapRollTravel;

  /// `animation-delay: var(--duration-fast)` on the inner squash
  /// (`icon-swap.tsx`) — the roll is a third of the way home before the glyph
  /// starts to squash.
  static const Duration squashDelay = MotionDurations.fast;
}
