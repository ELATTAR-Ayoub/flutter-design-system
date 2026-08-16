/// `components/ui/collapsible.tsx` — one independent disclosure, and the
/// `anim-unfold` / `anim-fold` pair both disclosure primitives share.
///
/// The page's framing: *"Accordion for a set of related disclosures where only
/// one should be open — the FAQ. Collapsible for a single independent section,
/// like an advanced filter block."*
///
/// The source's own note on the mechanic (`collapsible.tsx` L24–35): *"Opens by
/// animating its own height on `--ease-spring`, so the panel pushes what is
/// below it out of the way and settles with a slight overshoot — `anim-unfold`
/// and `anim-fold` from the motion system, not a bespoke transition.
/// `--unfold-h` points the shared keyframes at Radix's measured height. That
/// indirection is what lets Collapsible and Accordion share one definition
/// despite exposing differently-named variables. `overflow-hidden` is
/// load-bearing: without it the overshoot reads as content spilling out of the
/// panel rather than the panel breathing."*
///
/// The keyframes themselves (`app/globals.css` L2396–2400, L2458–2465):
///
/// ```css
/// @utility anim-unfold { animation: yuki-unfold var(--duration-jelly) var(--ease-spring) both; }
/// @utility anim-fold   { animation: yuki-fold   var(--duration-base)  var(--ease-in-out) both; }
/// @keyframes yuki-unfold { 0% { height: 0; opacity: 0 } 100% { height: var(--unfold-h); opacity: 1 } }
/// @keyframes yuki-fold   { 0% { height: var(--unfold-h); opacity: 1 } 100% { height: 0; opacity: 0 } }
/// ```
///
/// Both were driven and sampled on the live reference (1440 × 900,
/// 2026-08-16). Fifty milliseconds after a click the opening panel read
/// `height: 27.88` of its settled 47.13 at `opacity: 0.592`, and the closing
/// one `43.2` at `0.917` — which is `--ease-spring` at 50/420 and
/// `--ease-in-out` at 50/250 respectively, to within the sampler's own frame.
/// Height and opacity move in exact lock-step, because they are two properties
/// of one keyframe table rather than two transitions.
library;

import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import '../theme_scope.dart';

/// The shared disclosure animation: `anim-unfold` opening, `anim-fold` closing.
///
/// Renders nothing at all while closed and settled — Radix unmounts a
/// `Content` without `forceMount`, and the probe finds `display: none` on every
/// closed panel on the page.
///
/// **Interruption is a replacement, not a reversal.** A CSS animation that is
/// swapped mid-flight starts its successor at that successor's own 0% stop —
/// so closing a panel that is still opening snaps it to full height and then
/// folds from there. [_open] / [_close] do exactly that by seeking the
/// controller to the endpoint before running it, rather than reversing from
/// wherever the previous run had reached.
class DsUnfold extends StatefulWidget {
  const DsUnfold({super.key, required this.open, required this.child});

  final bool open;

  /// Measured at its natural height and clipped, which is what
  /// `--unfold-h: var(--radix-*-content-height)` resolves to: the panel's own
  /// laid-out height, never a guess.
  final Widget child;

  @override
  State<DsUnfold> createState() => _DsUnfoldState();
}

class _DsUnfoldState extends State<DsUnfold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: DsDurations.jelly,
    reverseDuration: DsDurations.base,
    value: widget.open ? 1 : 0,
  );

  /// `--ease-spring` opening, `--ease-in-out` closing.
  ///
  /// [FlippedCurve] is what turns a forward easing into the same easing read
  /// along a reversing controller: `1 − f(1 − t)`, which is the shape
  /// `yuki-fold` traces as it walks its own 0% → 100% while the controller
  /// walks 1 → 0.
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: DsCurves.spring,
    reverseCurve: FlippedCurve(DsCurves.inOut),
  );

  @override
  void didUpdateWidget(DsUnfold old) {
    super.didUpdateWidget(old);
    if (widget.open == old.open) return;
    _controller.duration =
        dsAnimationDuration(context, DsDurations.jelly);
    _controller.reverseDuration =
        dsAnimationDuration(context, DsDurations.base);
    if (widget.open) {
      _controller.forward(from: 0);
    } else {
      _controller.value = 1;
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (BuildContext context, Widget? child) {
        if (!widget.open && _controller.isDismissed) {
          return const SizedBox.shrink();
        }
        final double t = _curve.value;
        return ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            // `--ease-spring` overshoots, and `height` takes the overshoot:
            // above 1 the box is taller than its content and `overflow-hidden`
            // shows the extra as breathing room under it, which is the whole
            // effect the source's note is protecting.
            heightFactor: t < 0 ? 0 : t,
            child: Opacity(
              // …while `opacity` is clamped by the compositor, exactly as CSS
              // clamps it. The two properties share one curve and part company
              // only at the extreme.
              opacity: t.clamp(0.0, 1.0),
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// A single independent disclosure — a trigger with a panel under it.
///
/// **Controlled**, and thin on purpose: the reference's `Collapsible` is three
/// Radix primitives with `data-slot` attributes and no styling of its own, and
/// `CollapsibleTrigger asChild` hands its behaviour to whatever the caller
/// passes (a `Button variant="outline" className="w-full justify-between"` on
/// this page). Everything visible therefore belongs to the caller and to
/// [DsUnfold]; this widget owns the stacking and nothing else.
class DsCollapsible extends StatelessWidget {
  const DsCollapsible({
    super.key,
    required this.open,
    required this.trigger,
    required this.content,
  });

  final bool open;

  /// `CollapsibleTrigger asChild` — the caller's own control, already wired to
  /// flip [open].
  final Widget trigger;

  /// `CollapsibleContent`. Its own top padding is the caller's (`pt-4` here),
  /// because the reference passes it as a `className` rather than declaring it
  /// in the component.
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        trigger,
        DsUnfold(open: open, child: content),
      ],
    );
  }
}
