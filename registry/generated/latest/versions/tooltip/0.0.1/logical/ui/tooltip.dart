/// `components/ui/tooltip.tsx` — *"a short label for a control whose purpose is
/// not obvious. It is not a place for content, and it is never the only way to
/// learn something."*
///
/// Measured open on the dialogs page (2026-08-16, 1440x900):
///
/// | part | measured |
/// |---|---|
/// | surface | `bg-foreground` fill, `text-background` ink, `px-3 py-1.5` → 28px tall, `rounded-md` 10px, `max-w-xs` 320, `w-fit` |
/// | label | `text-xs` — 12px in a 16px line box, weight inherited from `html`'s 400 |
/// | side | `top`, `align="center"`, and the content's bottom edge sits **10px** above the trigger — Radix reserves the arrow's own height even though `sideOffset` is 0 |
/// | arrow | a 10px square (`size-2.5`) with `rounded-xs` 2px corners, `rotate-45`, `translate-y-[calc(-50%_-_2px)]`, filled `--foreground`; its centre lands 2px above the content's bottom edge and on the trigger's centre line |
/// | delay | `TooltipProvider delayDuration={200}` in `app/layout.tsx`, measured 232.5ms to first frame |
/// | enter | `animate-in fade-in-0 zoom-in-95` plus `data-[side=top]:slide-in-from-bottom-2` — 8px of upward travel — over `--duration-overlay` 320ms on `--ease-out` |
/// | exit | `fade-out-0 zoom-out-95`. **No slide**: `slide-in-from-*` is an entrance utility and the class list writes no exit twin |
///
/// **Why this does not compose `ElPopover`.** Three of the four things it would
/// borrow are wrong here: `ElPopover` slides on the bottom side only (ruling
/// L11 scoped it to the selects page's two consumers), it draws no arrow by the
/// same ruling, and it dismisses on an outside pointer — a tooltip closes when
/// the pointer *leaves the trigger*, which is a different gesture entirely. The
/// hover card, whose geometry really is a popover's, does compose it.
///
/// **Pointer only, and that is the component's own position.** The page says
/// so twice — *"a richer preview on hover, for pointer users only"* and
/// *"anything inside a hover card must also be reachable another way"*. There
/// is no long-press path here because there is none in the reference.
///
/// ## USER-ORDERED MOBILE ADAPTATION — a tap opens it on touch
///
/// On the toast top-anchor's precedent (`toaster.dart`, *"the compact anchor —
/// user-ordered"*): the reference is a mouse document, the order is a phone,
/// and the order wins.
///
/// Hover does not exist on a touch screen. Everything above about the pointer
/// is still true of a pointer — and on a finger it describes a label that can
/// never open at all, which on an icon-only control (a collapsed sidebar rail,
/// an `AlertDialogAction` whose text has truncated) is the only name the
/// control has. So the port adds a second way in:
///
///  * **A tap on the trigger opens it, and a second tap closes it.** No dwell
///    on the way in — `delayDuration` is a hover-intent filter, there to stop
///    labels flashing as a cursor crosses a toolbar, and a tap has already
///    declared its intent.
///  * **A tap anywhere else closes it**, through a translucent barrier that
///    observes the pointer without taking it: the tap it dismisses on still
///    reaches whatever it landed on.
///  * **It dismisses itself after [ElTooltip.touchDwell]** if nothing else
///    closes it first, so a label can never be stranded on screen.
///
/// **Routed on the event's own [PointerDeviceKind], never on the platform.** A
/// hybrid machine gets both paths at once and each pointer is judged as it
/// arrives: a finger taps, a mouse hovers, a stylus hovers. Nothing about the
/// hover path moves — same 200ms dwell, same enter/exit contract, same
/// geometry — and the trigger keeps every gesture it had, because the tap is
/// watched with a [Listener] rather than competed for with a recogniser.
///
/// Not ported: `TooltipProvider` as an object. Its one job is
/// `delayDuration={200}`, which is set once for the whole application and is
/// therefore a constant — [ElDurations.tooltipDelay] — rather than a scope. The
/// prose beside the specimens makes the same point: *"set once on the provider
/// in the root layout so timing cannot vary between screens."*
library;

import 'dart:async' show Timer;

import 'package:flutter/gestures.dart'
    show
        PointerDeviceKind,
        PointerDownEvent,
        PointerEnterEvent,
        PointerExitEvent;
import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';

/// `zoom-in-95` / `zoom-out-95`.
const double _zoom = 0.95;

/// `TooltipContent side` — the two the corpus asks for.
///
/// `top` is the component's own default and what the dialogs page measures.
/// `right` arrives with `SidebarMenuButton`, whose tooltip is the *only* label
/// a collapsed rail has: `<TooltipContent side="right" align="center" …>`.
enum ElTooltipSide {
  /// The default. Content above the trigger, arrow lane below it.
  top,

  /// Content to the trigger's right, arrow lane to its left.
  right,
}

/// One `MouseRegion` around a trigger, a [Listener] watching it for taps, and a
/// labelled diamond beside it.
class ElTooltip extends StatefulWidget {
  const ElTooltip({
    super.key,
    required this.label,
    required this.child,
    this.delay = ElDurations.tooltipDelay,
    this.side = ElTooltipSide.top,
    this.hidden = false,
  });

  /// The content. *"Content must be a short label."*
  final String label;

  /// `TooltipTrigger asChild` — the control, rendered verbatim.
  final Widget child;

  final Duration delay;

  /// Which edge of the trigger the content sits on.
  final ElTooltipSide side;

  /// `hidden` on the content — the trigger keeps its hover behaviour and
  /// nothing is rendered.
  ///
  /// `SidebarMenuButton` passes `hidden={state !== "collapsed" || isMobile}`:
  /// every row on the reference is wrapped in a `Tooltip`, and the label only
  /// appears once the panel has collapsed to a rail and the row's own text has
  /// gone. Expressed as a prop rather than by omitting the wrapper, because
  /// that is what the reference does — the tooltip exists either way.
  final bool hidden;

  /// `size-2.5` — the arrow's box, before the 45° turn.
  static double get arrowSize => el(2.5);

  /// `rounded-xs` on the arrow.
  static double get arrowRadius => ElRadii.xs;

  /// `translate-y-[calc(-50% - 2px)]` — half the arrow, plus two.
  static double get arrowLift => arrowSize / 2 + ElRadii.xs;

  /// `px-3`.
  static double get horizontalPadding => el(3);

  /// `py-1.5`.
  static double get verticalPadding => el(1.5);

  /// `slide-in-from-bottom-2` — two spacing units of travel.
  static double get slide => el(2);

  /// How long a **tap**-opened label stays up on its own — 1.5s.
  ///
  /// The reference cannot supply this number: it has no touch path, so there is
  /// nothing to measure. The platform can, and does — Flutter's own
  /// `Tooltip._defaultShowDuration` is `1500ms` and is passed as `touchDelay`,
  /// which is exactly this quantity: how long a label lingers after a touch
  /// opened it. Taking the host platform's answer for a question the reference
  /// never asked is [ElCurves.cssEase]'s argument one layer up — a foreign
  /// default, adopted rather than invented.
  ///
  /// Spelled as ten beats of [ElDurations.fast] rather than typed, because the
  /// literal belongs in `foundation/` and this file is not it. The two agree to
  /// the microsecond.
  ///
  /// Like [delay], it is **not** routed through [elAnimationDuration]: a dwell
  /// is not motion, and `prefers-reduced-motion` has nothing to say about how
  /// long a label a finger asked for stays legible.
  static Duration get touchDwell => ElDurations.fast * 10;

  @override
  State<ElTooltip> createState() => _ElTooltipState();
}

class _ElTooltipState extends State<ElTooltip>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _portal = OverlayPortalController();
  final GlobalKey _anchorKey = GlobalKey();

  /// Built in [initState], never lazily: a tooltip nobody hovered would
  /// otherwise create its ticker inside [dispose].
  late final AnimationController _animation;

  /// The `delayDuration` timer, cancelled if the pointer leaves first.
  Object? _pending;

  /// [ElTooltip.touchDwell]'s timer, cancelled the moment anything else closes
  /// the label.
  ///
  /// A real [Timer] rather than [_pending]'s token-and-[Future.delayed] idiom,
  /// and the difference is the duration: 200ms of dead token outlives nothing,
  /// where 1.5s of it holds a callback long after the label it was counting for
  /// has gone — and, under `flutter_test`, past the end of the test that armed
  /// it, which the binding fails on.
  Timer? _dwell;

  /// Whether the label on screen was opened by a **tap**.
  ///
  /// The two dismissals must not cross: a hover-opened label is the pointer's
  /// to close and a finger must not steal it, and a tap-opened one has no
  /// pointer to leave, so nothing but another tap (or [ElTooltip.touchDwell])
  /// may take it down.
  bool _byTouch = false;

  /// Whether the label is **meant** to be up.
  ///
  /// Not the same as `_portal.isShowing`, which stays true for the whole exit
  /// animation — a toggle that read the portal would answer "still open" for
  /// 320ms after a closing tap and refuse to reopen.
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: ElDurations.overlay,
    );
  }

  @override
  void dispose() {
    _pending = null;
    _dwell?.cancel();
    _animation.dispose();
    super.dispose();
  }

  /// The hover delay is **not** routed through [elAnimationDuration]: it is a
  /// dwell time, not motion, and `prefers-reduced-motion` has nothing to say
  /// about how long a pointer must rest before a label appears.
  void _enter(PointerEnterEvent event) {
    // The tap path owns touch. A finger raises no enter on the platforms this
    // ships to, but a synthesised or hybrid one would, and it must not buy a
    // second opening on top of the one [_down] already gave it.
    if (event.kind == PointerDeviceKind.touch) return;
    if (widget.hidden) return;
    final Object token = Object();
    _pending = token;
    Future<void>.delayed(widget.delay, () {
      if (!mounted || _pending != token) return;
      _pending = null;
      _show();
    });
  }

  void _exit(PointerExitEvent event) {
    // Same rule read backwards, and the one that keeps a hybrid device honest:
    // a mouse leaving the trigger closes what the mouse opened, and leaves what
    // the finger did to [ElTooltip.touchDwell] and to the next tap.
    if (event.kind == PointerDeviceKind.touch || _byTouch) return;
    _hide();
  }

  /// The trigger's own pointer-downs — **watched, not competed for.** A
  /// [Listener] never joins the gesture arena, so the control underneath keeps
  /// every gesture it had: the button still fires, the row still navigates, and
  /// the label arrives beside it.
  void _down(PointerDownEvent event) {
    if (event.kind != PointerDeviceKind.touch || widget.hidden) return;
    if (_open) {
      _hide();
      return;
    }
    // No dwell on the way in: `delayDuration` is a hover-intent filter and a
    // tap has already declared its intent.
    _byTouch = true;
    _show();
    _dwell?.cancel();
    _dwell = Timer(ElTooltip.touchDwell, () {
      if (mounted) _hide();
    });
  }

  void _show() {
    // Any opening supersedes one still counting down — otherwise a finger that
    // taps a control the cursor is already resting on gets the label now AND a
    // replayed entrance 200ms later, on the hover timer it never cancelled.
    _pending = null;
    _open = true;
    _portal.show();
    _animation
      ..duration = elAnimationDuration(context, ElDurations.overlay)
      ..forward(from: 0);
  }

  void _hide() {
    _pending = null;
    _dwell?.cancel();
    _dwell = null;
    _open = false;
    _byTouch = false;
    if (!_portal.isShowing) return;
    _animation.duration = elAnimationDuration(context, ElDurations.overlay);
    _animation.reverse().whenComplete(() {
      if (_animation.value != 0 || !mounted) return;
      _portal.hide();
    });
  }

  Widget _buildOverlay(BuildContext overlayContext) {
    final RenderObject? object = _anchorKey.currentContext?.findRenderObject();
    final RenderObject? theatre = Overlay.maybeOf(
      overlayContext,
    )?.context.findRenderObject();
    if (object is! RenderBox ||
        theatre is! RenderBox ||
        !object.hasSize ||
        !theatre.hasSize) {
      return const SizedBox.shrink();
    }
    final Rect anchor =
        object.localToGlobal(Offset.zero, ancestor: theatre) & object.size;

    return Positioned.fill(
      // The outside-tap dismissal, and the reason it is a [Listener] on
      // [HitTestBehavior.translucent] rather than a barrier: translucent puts
      // this box in the hit-test result WITHOUT claiming the hit, so everything
      // underneath is hit-tested exactly as it would have been. The tap that
      // dismisses the label still reaches whatever it landed on — which is the
      // difference between a tooltip and a modal, and a tooltip is not one.
      //
      // The handler reads [_byTouch] when the event arrives rather than at
      // build time, so the hover path passes through it untouched and the
      // overlay never has to be rebuilt to arm or disarm this.
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (PointerDownEvent event) {
          if (!_byTouch) return;
          // A down on the trigger belongs to [_down], which toggles. Letting
          // both fire would close and reopen on the same tap.
          if (anchor.contains(event.localPosition)) return;
          _hide();
        },
        child: IgnorePointer(
          child: CustomSingleChildLayout(
            delegate: _TooltipLayout(anchor: anchor, side: widget.side),
            child: _TooltipTransition(
              animation: _animation,
              side: widget.side,
              child: ElTooltipContent(label: widget.label, side: widget.side),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => OverlayPortal(
    controller: _portal,
    overlayChildBuilder: _buildOverlay,
    child: Listener(
      onPointerDown: _down,
      child: MouseRegion(
        onEnter: _enter,
        onExit: _exit,
        child: KeyedSubtree(key: _anchorKey, child: widget.child),
      ),
    ),
  );
}

/// Puts the tooltip on its trigger's chosen edge, centred, and keeps it on
/// screen.
class _TooltipLayout extends SingleChildLayoutDelegate {
  const _TooltipLayout({required this.anchor, required this.side});

  final Rect anchor;
  final ElTooltipSide side;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double clamp(double v, double extent) =>
        v.clamp(0.0, extent.clamp(0.0, double.infinity));

    switch (side) {
      case ElTooltipSide.top:
        final double x = clamp(
          anchor.center.dx - childSize.width / 2,
          size.width - childSize.width,
        );
        // The child is the content PLUS the arrow's lane, so its own bottom is
        // the trigger's top.
        final double y = clamp(
          anchor.top - childSize.height,
          size.height - childSize.height,
        );
        return Offset(x, y);
      case ElTooltipSide.right:
        // Same construction one quarter turn round: the lane is the child's
        // leading column, so its own left edge is the trigger's right.
        // *(Measured on a collapsed rail row: anchor right 340, content left
        // 350 — the lane's own 10px, with `sideOffset` at 0.)*
        final double x = clamp(anchor.right, size.width - childSize.width);
        final double y = clamp(
          anchor.center.dy - childSize.height / 2,
          size.height - childSize.height,
        );
        return Offset(x, y);
    }
  }

  @override
  bool shouldRelayout(_TooltipLayout old) =>
      old.anchor != anchor || old.side != side;
}

/// `TooltipContent` and its arrow, as one box: the label's pill on top and a
/// 10px arrow lane under it.
///
/// The lane is what makes the measured 10px gap between the content's bottom
/// edge and the trigger fall out of layout rather than out of an offset — Radix
/// reserves the arrow's height in exactly the same way, which is why
/// `sideOffset={0}` still leaves a gap.
class ElTooltipContent extends StatelessWidget {
  const ElTooltipContent({
    super.key,
    required this.label,
    this.side = ElTooltipSide.top,
  });

  final String label;

  /// Which edge the lane sits on — below the pill on [ElTooltipSide.top], left
  /// of it on [ElTooltipSide.right].
  final ElTooltipSide side;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final Widget pill = ConstrainedBox(
      // `max-w-xs`.
      constraints: BoxConstraints(maxWidth: ElContainers.xs),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.foreground,
          borderRadius: BorderRadius.circular(ElRadii.md),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ElTooltip.horizontalPadding,
            vertical: ElTooltip.verticalPadding,
          ),
          child: ElText(
            label,
            ElComponentType.tooltipLabel,
            color: theme.background,
          ),
        ),
      ),
    );

    // The lane is a `size-2.5` SQUARE, not a strip that spans the pill.
    //
    // It used to be sized by `crossAxisAlignment: stretch`, and that is a bug
    // under an overlay's constraints: the positioner loosens the theatre's own
    // box before it lays the content out, so `stretch` handed the flex's cross
    // axis `constraints.maxWidth` — the whole viewport. The pill inherited it
    // through `ConstrainedBox.enforce` (a parent's tight width beats a
    // `max-w-xs`), and `getPositionForChild` then clamped a viewport-wide child
    // to x = 0. What shipped on a 1915px window was a full-width white bar with
    // its label at the far edge, over the sidebar, instead of a pill above its
    // trigger — both halves of it, the width and the position, out of this one
    // line.
    //
    // Nothing about the drawn geometry changes: the box's own centre is the
    // pill's centre either way, so the diamond still lands on the trigger's
    // centre line, still 2px inside the facing edge, and the lane still spends
    // exactly [ElTooltip.arrowSize] of layout — which is where the measured
    // 10px gap comes from. The 45° turn takes the diamond past its box on the
    // diagonal (10 → ~14.1) and always did; a [CustomPaint] does not clip.
    final Widget lane = SizedBox.square(
      dimension: ElTooltip.arrowSize,
      child: CustomPaint(
        painter: _ArrowPainter(color: theme.foreground, side: side),
      ),
    );

    // Default cross-axis alignment — `center` — on both, so the box wraps its
    // pill on the cross axis instead of the constraints it was offered.
    return switch (side) {
      ElTooltipSide.top => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[pill, lane],
      ),
      ElTooltipSide.right => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[lane, pill],
      ),
    };
  }
}

/// The diamond. A 10px square turned 45° about its own centre, with the centre
/// lifted `50% + 2px` out of the lane it sits in.
///
/// Painted rather than composed out of [Transform.rotate] and [ClipRRect] for
/// the painter rule's reason: a rotated, rounded square is one rendered path,
/// and rendering it as one is what lets a pixel pin hold it.
class _ArrowPainter extends CustomPainter {
  const _ArrowPainter({required this.color, this.side = ElTooltipSide.top});

  final Color color;

  /// Which lane this is painting in, and therefore which way the diamond's
  /// centre is pushed out of it.
  final ElTooltipSide side;

  @override
  void paint(Canvas canvas, Size size) {
    final double square = ElTooltip.arrowSize;
    // On `top` the pill is `align="center"` on its trigger and the arrow is
    // centred on the trigger too, so the two centres coincide — measured 344.5
    // against 344.63, an eighth of a pixel apart. On `right` the same holds one
    // quarter turn round: the diamond's centre lands on the trigger's centre
    // line and **2px inside** the content's facing edge *(measured: centre
    // (352, 379) against a content box at x 350 and a centre line at 379)*.
    final Offset centre = switch (side) {
      // `translate-y-[calc(-50% - 2px)]`, measured from the lane's own top.
      ElTooltipSide.top => Offset(size.width / 2, -ElRadii.xs),
      ElTooltipSide.right => Offset(size.width + ElRadii.xs, size.height / 2),
    };

    final RRect diamond = RRect.fromRectAndRadius(
      Rect.fromCenter(center: centre, width: square, height: square),
      Radius.circular(ElTooltip.arrowRadius),
    );
    canvas
      ..save()
      ..translate(centre.dx, centre.dy)
      ..rotate(_quarterTurn)
      ..translate(-centre.dx, -centre.dy)
      ..drawRRect(diamond, Paint()..color = color)
      ..restore();
  }

  /// `rotate-45`, in radians.
  static const double _quarterTurn = 0.7853981633974483;

  @override
  bool shouldRepaint(_ArrowPainter old) =>
      old.color != color || old.side != side;
}

/// `animate-in fade-in-0 zoom-in-95 slide-in-from-bottom-2` and its
/// `animate-out` twin, minus the slide the twin does not have.
class _TooltipTransition extends StatelessWidget {
  const _TooltipTransition({
    required this.animation,
    required this.child,
    this.side = ElTooltipSide.top,
  });

  final Animation<double> animation;

  /// `data-[side=top]:slide-in-from-bottom-2` against
  /// `data-[side=right]:slide-in-from-left-2` — the travel is always **toward**
  /// the trigger, so the axis follows the side.
  final ElTooltipSide side;

  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    child: child,
    builder: (BuildContext context, Widget? child) {
      final double t = ElCurves.out.transform(animation.value.clamp(0, 1));
      final bool entering = animation.status != AnimationStatus.reverse;
      final double travel = entering ? ElTooltip.slide * (1 - t) : 0;
      return Opacity(
        opacity: t,
        child: Transform.translate(
          offset: switch (side) {
            ElTooltipSide.top => Offset(0, travel),
            ElTooltipSide.right => Offset(-travel, 0),
          },
          child: Transform.scale(
            scale: _zoom + (1 - _zoom) * t,
            // The edge of the box the trigger is on.
            alignment: switch (side) {
              ElTooltipSide.top => Alignment.bottomCenter,
              ElTooltipSide.right => Alignment.centerLeft,
            },
            child: child,
          ),
        ),
      );
    },
  );
}
