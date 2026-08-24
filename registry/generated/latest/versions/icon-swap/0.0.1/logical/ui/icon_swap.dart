/// `components/ui/icon-swap.tsx` — the two-state control's vertical wheel.
///
/// The component's own docstring states the rule: *"every control that
/// alternates between icons swaps them through this. View mode, play/pause,
/// favourite, mute, expand. No crossfades, no instant swaps — a control that
/// changes meaning should show you it changed."*
///
/// It is a carousel, not a fade. The icons form a strip in the order given, all
/// of them stacked in **one** grid cell (`col-start-1 row-start-1`), and each
/// holds its place at `(index − activeIndex)` steps from centre. Advancing
/// rolls the strip up — the leaver exits through the top, the arriver rises
/// from below — and going back rolls it down. Neither direction is
/// special-cased: both fall out of the offset arithmetic, which is why a
/// reversal is the genuine inverse rather than a replayed forward pass.
///
/// The motion is two tables and one composition, and this file owns only the
/// composition:
///
/// * the roll is [ElSwapRoll] — `@utility swap-roll` (globals.css L2265–2271),
///   `--duration-slow` on `--ease-spring`, applied to **transform and opacity
///   together**, 160% of the strip cell per step;
/// * the squash is [ElJelly] — `.anim-jelly`, `yuki-jelly 0.6s var(--ease-out)
///   both` (L2365–2367), worn by the **inner** span of the active cell only and
///   delayed by [ElSwapRoll.squashDelay];
/// * the composition is the timeline: `t=0` roll starts → `t=150` squash starts
///   → `t=400` roll settles → `t=750` squash ends.
///
/// Two consequences of one shared spring, both shipped rather than fixed:
///
/// DRIFT (buttons-map 20). The panel's copy says *"No crossfades"*. The
/// stylesheet transitions `opacity` on the same 400ms spring as the transform,
/// and because the curve exceeds 1 the value clamps at ≈147ms — so there **is**
/// a ~150ms crossfade inside the roll. The stylesheet is what renders; the copy
/// ships verbatim elsewhere and the mechanism ships here.
///
/// The arriving glyph **overshoots**: `--ease-spring` peaks at ≈1.098 around
/// 57% of the run, so it sails ≈9.8% of one step past centre — ~2.5px at a 16px
/// glyph, ~3.1px at 20px — and settles back. That is the point of using the
/// spring rather than `--ease-out` here.
///
/// One asymmetry worth naming, because it is the opposite of the one
/// `ElSlidingPillGroup` makes. The pill deliberately **skips** its first
/// placement — flying in from the left edge on mount looks like a glitch. This
/// widget deliberately **plays** its first squash: `anim-jelly` is an
/// animation, and a freshly mounted element runs its animation, so every demo
/// on the page squashes once on load. The roll, being a *transition*, does not
/// run on the initial style — so on mount the strip is already in place and
/// only the glyph moves.
library;

import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/widgets.dart';

import '../motion/keyframes.dart';
import '../theme_scope.dart';

/// A fixed clip window with a strip of [icons] rolling through it.
///
/// Decorative by itself. The reference marks every inactive cell `aria-hidden`
/// and puts the accessible name on the **Button that contains the IconSwap**
/// (`aria-label` describing what pressing it will do, plus `aria-pressed` when
/// it is a toggle) — so the port excludes the inactive cells from the semantics
/// tree and contributes no name of its own. Put it inside a `ElButton` as the
/// child, never beside one.
class ElIconSwap extends StatefulWidget {
  const ElIconSwap({
    super.key,
    required this.icons,
    required this.activeIndex,
    required this.window,
    required this.cell,
  });

  /// The strip, in wheel order — index 0 sits at the top.
  ///
  /// The reference takes `Record<string, ReactNode>` and reads the strip order
  /// off the object's insertion order. A Dart map would preserve that order
  /// too, but every call site in this port is a static pair, so the honest
  /// shape is the list and the index: nothing is being looked up.
  final List<Widget> icons;

  /// Which cell is at centre. Out of range clamps to 0, mirroring
  /// `Math.max(0, keys.indexOf(active))` — an index the strip does not contain
  /// is the Dart analogue of a key it does not contain, and the reference shows
  /// the first icon for that, not the last.
  final int activeIndex;

  /// The clip box — `className="size-5"` (20px) on three demos, `size-6` (24px)
  /// on the play/pause one.
  ///
  /// A prop in the reference and a required parameter here rather than
  /// something derived: the window is always 4px larger than the glyph in the
  /// four demos, but that is a fact about those demos, not a rule the component
  /// enforces.
  final double window;

  /// The strip cell's own height — the **glyph's** height, 16 (`Icon size="md"`)
  /// or 20 (`size="lg"`). Not [window].
  ///
  /// A CSS percentage translate resolves against the translated element's own
  /// border box, and each cell is `inline-flex items-center justify-center`
  /// around a single icon, so the cell is glyph-sized and one step is
  /// [ElSwapRoll.travelFor] of *that* — 25.6px at 16, 32px at 20.
  ///
  /// DIVERGENCE. The browser measures this; here it is declared. Passing a
  /// [cell] that disagrees with the glyph's real box changes the travel exactly
  /// as a differently-sized glyph would in the browser — it is not clamped or
  /// corrected, because there is nothing to correct it against.
  final double cell;

  /// `Math.max(0, keys.indexOf(active))`, in index form.
  static int resolveIndex(int index, int count) =>
      index >= 0 && index < count ? index : 0;

  @override
  State<ElIconSwap> createState() => _ElIconSwapState();
}

class _ElIconSwapState extends State<ElIconSwap> with TickerProviderStateMixin {
  /// The squash's delay and the squash itself on **one** clock.
  ///
  /// `ElKeyframePlayer` has no delay parameter and a second controller started
  /// from a `Timer` would have to be cancelled on dispose, on every
  /// interruption, and specially cased under reduced motion. Running the whole
  /// 750ms and mapping the tail costs one division and leaves the widget with
  /// exactly two tickers, both of which a widget test can pump.
  static final Duration _squashRun = ElSwapRoll.squashDelay + ElJelly.duration;

  /// Where `yuki-jelly`'s own 0% sits on that clock — 150/750 = 0.2.
  static final double _squashStart =
      ElSwapRoll.squashDelay.inMicroseconds / _squashRun.inMicroseconds;

  /// The transform+opacity transition. Both properties, one clock, because the
  /// stylesheet declares them in one `transition`.
  late final AnimationController _roll = AnimationController(
    vsync: this,
    duration: ElSwapRoll.duration,
  );

  /// The delayed squash on the arriving glyph.
  late final AnimationController _squash = AnimationController(
    vsync: this,
    duration: _squashRun,
  );

  /// The strip position the current roll started from, in steps. A double
  /// because an interrupted transition restarts from wherever the strip is,
  /// which is rarely a whole step.
  late double _from;

  /// The strip position it is heading for — the resolved [ElIconSwap.activeIndex].
  late int _to;

  /// Each cell's opacity when the current roll began, for the same reason.
  late List<double> _fromOpacity;

  /// Reduced-motion state as of the last resolution, or null before the first.
  /// Tracked so that a MediaQuery change which is *not* a reduced-motion change
  /// leaves a running roll alone.
  bool? _stilled;

  /// The first-mount squash fires once, from the first [didChangeDependencies]
  /// rather than [initState], because reduced motion is only readable once
  /// there is an inherited scope to read it from.
  bool _squashPlayed = false;

  int get _active =>
      ElIconSwap.resolveIndex(widget.activeIndex, widget.icons.length);

  @override
  void initState() {
    super.initState();
    _to = _active;
    _from = _to.toDouble();
    _fromOpacity = _opacitiesFor(_to);
    // A CSS transition does not run on the initial style: on the first frame
    // the strip is simply already where it belongs. Landing the roll here is
    // that, and it is why only the squash plays on mount.
    _roll.value = _roll.upperBound;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _readMotion();
    if (_squashPlayed) return;
    _squashPlayed = true;
    // The reference's first mount: the active cell's inner span appears with
    // `anim-jelly` on it, so it runs. Every demo squashes once on page load.
    _squash.forward(from: 0);
  }

  @override
  void didUpdateWidget(ElIconSwap old) {
    super.didUpdateWidget(old);
    final int next = _active;
    if (next == _to) return;

    // A transition interrupted mid-flight restarts from the value on screen,
    // not from the target it was abandoning — so capture the current frame
    // before re-aiming. This is what makes 1→0 mid-roll read as the strip
    // rolling back rather than as a jump.
    _from = _strip(_rollT);
    _fromOpacity = _currentOpacities();
    _to = next;
    _roll.forward(from: 0);
    // The reference replays the squash by flipping the inner span's React key:
    // an unmount/remount restarts the CSS animation from t=0, mid-flight
    // restarts included. `forward(from: 0)` is that same intent.
    _squash.forward(from: 0);
  }

  @override
  void dispose() {
    _roll.dispose();
    _squash.dispose();
    super.dispose();
  }

  /// Applies `prefers-reduced-motion` to both clocks.
  ///
  /// Supervisor ruling B13: reduced motion is *instant*, never *disabled*. The
  /// blanket rule (globals.css L2534–2544) collapses `transition-duration` and
  /// `animation-duration` to 0.01ms, so the swap still happens and still lands
  /// — on its final frame, on the frame it was asked for.
  ///
  /// It leaves `animation-delay` alone, and here that is unobservable rather
  /// than a shortcut: `anim-jelly` fills `both`, its backwards fill during the
  /// delay is stop 0 = `scale3d(1,1,1)`, and its final stop is the same value.
  /// Collapsing the delay along with the duration therefore renders identically
  /// to honouring it.
  void _readMotion() {
    _roll.duration = elAnimationDuration(context, ElSwapRoll.duration);
    _squash.duration = elAnimationDuration(context, _squashRun);

    final bool stilled = _roll.duration == Duration.zero;
    if (_stilled == stilled) return;
    _stilled = stilled;
    if (!stilled) return;
    // Turning the OS switch on mid-roll must not strand the strip half-way up
    // the window: both clocks jump to their last frame.
    _roll.value = _roll.upperBound;
    _squash.value = _squash.upperBound;
  }

  /// `--ease-spring` applied to the roll's linear progress. Deliberately not
  /// clamped: values above 1 are the overshoot.
  double get _rollT => ElSwapRoll.curve.transform(_roll.value);

  /// The strip's centre, in steps, at eased progress [t].
  double _strip(double t) => _from + (_to - _from) * t;

  /// Cell [i]'s opacity at eased progress [t].
  ///
  /// Clamped for the same reason the browser clamps it — `opacity` takes a
  /// used value in 0..1 and the spring overshoots both ends — with the added
  /// motive that [Opacity] asserts on anything outside the range.
  double _opacity(int i, double t) => clampDouble(
    _fromOpacityAt(i) + ((i == _to ? 1 : 0) - _fromOpacityAt(i)) * t,
    0,
    1,
  );

  /// Zero for a cell that did not exist when the roll began — a freshly mounted
  /// inactive span is `opacity-0` and has nothing to transition from.
  double _fromOpacityAt(int i) => i < _fromOpacity.length ? _fromOpacity[i] : 0;

  List<double> _currentOpacities() {
    final double t = _rollT;
    return <double>[
      for (int i = 0; i < widget.icons.length; i++) _opacity(i, t),
    ];
  }

  List<double> _opacitiesFor(int active) => <double>[
    for (int i = 0; i < widget.icons.length; i++) i == active ? 1 : 0,
  ];

  /// `yuki-jelly`'s own 0..1, read off the shared clock. Everything before
  /// [_squashStart] is the delay, which the `both` fill holds at stop 0.
  double get _jellyT =>
      clampDouble((_squash.value - _squashStart) / (1 - _squashStart), 0, 1);

  @override
  Widget build(BuildContext context) {
    // Re-read on every pass, the way `ElPress` and `ElSlidingPillGroup` do:
    // the OS switch can flip between two frames of a running roll.
    _roll.duration = elAnimationDuration(context, ElSwapRoll.duration);
    _squash.duration = elAnimationDuration(context, _squashRun);

    final double step = ElSwapRoll.travelFor(widget.cell);

    return SizedBox(
      // `relative inline-grid place-items-center overflow-hidden size-N` — the
      // fixed clip window. The Stack is the single grid cell every strip cell
      // shares, and centring it is `place-items-center`.
      width: widget.window,
      height: widget.window,
      child: ClipRect(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            for (int i = 0; i < widget.icons.length; i++)
              AnimatedBuilder(
                animation: _roll,
                builder: (BuildContext context, Widget? child) {
                  final double t = _rollT;
                  // `--swap-offset: {i - activeIdx}`, and CSS +Y is down, so
                  // the sign carries straight over: a cell above centre is
                  // negative and exits through the top.
                  final double offset = i - _strip(t);
                  return Transform.translate(
                    offset: Offset(0, offset * step),
                    child: Opacity(opacity: _opacity(i, t), child: child),
                  );
                },
                // `aria-hidden={!isActive}`. The name lives on the Button.
                child: ExcludeSemantics(
                  excluding: i != _to,
                  child: i == _to
                      ? _squashed(widget.icons[i])
                      : widget.icons[i],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// The inner span: `anim-jelly` on the active glyph, and nothing else.
  ///
  /// Separate from the cell's own transform because the reference keeps them on
  /// separate elements — a single element cannot carry both a transitioned
  /// `translateY` and an animated `scale3d` without one clobbering the other,
  /// which is the same reason this is a nested [Transform] rather than a
  /// composed matrix.
  Widget _squashed(Widget icon) => AnimatedBuilder(
    animation: _squash,
    builder: (BuildContext context, Widget? child) {
      final Offset scale = ElJelly.scale.transform(_jellyT);
      return Transform.scale(scaleX: scale.dx, scaleY: scale.dy, child: child);
    },
    child: icon,
  );
}
