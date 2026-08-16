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
/// **Why this does not compose `DsPopover`.** Three of the four things it would
/// borrow are wrong here: `DsPopover` slides on the bottom side only (ruling
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
/// Not ported: `TooltipProvider` as an object. Its one job is
/// `delayDuration={200}`, which is set once for the whole application and is
/// therefore a constant — [DsDurations.tooltipDelay] — rather than a scope. The
/// prose beside the specimens makes the same point: *"set once on the provider
/// in the root layout so timing cannot vary between screens."*
library;

import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';

/// `zoom-in-95` / `zoom-out-95`.
const double _zoom = 0.95;

/// One `MouseRegion` around a trigger, and a labelled diamond above it.
class DsTooltip extends StatefulWidget {
  const DsTooltip({
    super.key,
    required this.label,
    required this.child,
    this.delay = DsDurations.tooltipDelay,
  });

  /// The content. *"Content must be a short label."*
  final String label;

  /// `TooltipTrigger asChild` — the control, rendered verbatim.
  final Widget child;

  final Duration delay;

  /// `size-2.5` — the arrow's box, before the 45° turn.
  static double get arrowSize => ds(2.5);

  /// `rounded-xs` on the arrow.
  static double get arrowRadius => DsRadii.xs;

  /// `translate-y-[calc(-50% - 2px)]` — half the arrow, plus two.
  static double get arrowLift => arrowSize / 2 + DsRadii.xs;

  /// `px-3`.
  static double get horizontalPadding => ds(3);

  /// `py-1.5`.
  static double get verticalPadding => ds(1.5);

  /// `slide-in-from-bottom-2` — two spacing units of travel.
  static double get slide => ds(2);

  @override
  State<DsTooltip> createState() => _DsTooltipState();
}

class _DsTooltipState extends State<DsTooltip>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _portal = OverlayPortalController();
  final GlobalKey _anchorKey = GlobalKey();

  /// Built in [initState], never lazily: a tooltip nobody hovered would
  /// otherwise create its ticker inside [dispose].
  late final AnimationController _animation;

  /// The `delayDuration` timer, cancelled if the pointer leaves first.
  Object? _pending;

  @override
  void initState() {
    super.initState();
    _animation =
        AnimationController(vsync: this, duration: DsDurations.overlay);
  }

  @override
  void dispose() {
    _pending = null;
    _animation.dispose();
    super.dispose();
  }

  /// The hover delay is **not** routed through [dsAnimationDuration]: it is a
  /// dwell time, not motion, and `prefers-reduced-motion` has nothing to say
  /// about how long a pointer must rest before a label appears.
  void _enter() {
    final Object token = Object();
    _pending = token;
    Future<void>.delayed(widget.delay, () {
      if (!mounted || _pending != token) return;
      _pending = null;
      _portal.show();
      _animation
        ..duration = dsAnimationDuration(context, DsDurations.overlay)
        ..forward(from: 0);
    });
  }

  void _exit() {
    _pending = null;
    if (!_portal.isShowing) return;
    _animation.duration = dsAnimationDuration(context, DsDurations.overlay);
    _animation.reverse().whenComplete(() {
      if (_animation.value != 0 || !mounted) return;
      _portal.hide();
    });
  }

  Widget _buildOverlay(BuildContext overlayContext) {
    final RenderObject? object = _anchorKey.currentContext?.findRenderObject();
    final RenderObject? theatre =
        Overlay.maybeOf(overlayContext)?.context.findRenderObject();
    if (object is! RenderBox ||
        theatre is! RenderBox ||
        !object.hasSize ||
        !theatre.hasSize) {
      return const SizedBox.shrink();
    }
    final Rect anchor =
        object.localToGlobal(Offset.zero, ancestor: theatre) & object.size;

    return Positioned.fill(
      child: IgnorePointer(
        child: CustomSingleChildLayout(
          delegate: _TooltipLayout(anchor: anchor),
          child: _TooltipTransition(
            animation: _animation,
            child: DsTooltipContent(label: widget.label),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => OverlayPortal(
        controller: _portal,
        overlayChildBuilder: _buildOverlay,
        child: MouseRegion(
          onEnter: (_) => _enter(),
          onExit: (_) => _exit(),
          child: KeyedSubtree(key: _anchorKey, child: widget.child),
        ),
      );
}

/// Puts the tooltip above its trigger, centred, and keeps it on screen.
class _TooltipLayout extends SingleChildLayoutDelegate {
  const _TooltipLayout({required this.anchor});

  final Rect anchor;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final double x = (anchor.center.dx - childSize.width / 2)
        .clamp(0.0, (size.width - childSize.width).clamp(0.0, double.infinity));
    // The child is the content PLUS the arrow's lane, so its own bottom is the
    // trigger's top.
    final double y = (anchor.top - childSize.height)
        .clamp(0.0, (size.height - childSize.height).clamp(0.0, double.infinity));
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_TooltipLayout old) => old.anchor != anchor;
}

/// `TooltipContent` and its arrow, as one box: the label's pill on top and a
/// 10px arrow lane under it.
///
/// The lane is what makes the measured 10px gap between the content's bottom
/// edge and the trigger fall out of layout rather than out of an offset — Radix
/// reserves the arrow's height in exactly the same way, which is why
/// `sideOffset={0}` still leaves a gap.
class DsTooltipContent extends StatelessWidget {
  const DsTooltipContent({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ConstrainedBox(
          // `max-w-xs`.
          constraints: BoxConstraints(maxWidth: DsContainers.xs),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.foreground,
              borderRadius: BorderRadius.circular(DsRadii.md),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: DsTooltip.horizontalPadding,
                vertical: DsTooltip.verticalPadding,
              ),
              child: DsText(
                label,
                DsComponentType.tooltipLabel,
                color: theme.background,
              ),
            ),
          ),
        ),
        SizedBox(
          height: DsTooltip.arrowSize,
          child: CustomPaint(painter: _ArrowPainter(color: theme.foreground)),
        ),
      ],
    );
  }
}

/// The diamond. A 10px square turned 45° about its own centre, with the centre
/// lifted `50% + 2px` out of the lane it sits in.
///
/// Painted rather than composed out of [Transform.rotate] and [ClipRRect] for
/// the painter rule's reason: a rotated, rounded square is one rendered path,
/// and rendering it as one is what lets a pixel pin hold it.
class _ArrowPainter extends CustomPainter {
  const _ArrowPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double side = DsTooltip.arrowSize;
    // The pill is `align="center"` on its trigger and the arrow is centred on
    // the trigger too, so the two centres coincide — measured 344.5 against
    // 344.63, an eighth of a pixel apart.
    final double cx = size.width / 2;
    // `translate-y-[calc(-50% - 2px)]`, measured from the lane's own top.
    final double cy = -DsRadii.xs;

    final RRect square = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: side, height: side),
      Radius.circular(DsTooltip.arrowRadius),
    );
    canvas
      ..save()
      ..translate(cx, cy)
      ..rotate(_quarterTurn)
      ..translate(-cx, -cy)
      ..drawRRect(square, Paint()..color = color)
      ..restore();
  }

  /// `rotate-45`, in radians.
  static const double _quarterTurn = 0.7853981633974483;

  @override
  bool shouldRepaint(_ArrowPainter old) => old.color != color;
}

/// `animate-in fade-in-0 zoom-in-95 slide-in-from-bottom-2` and its
/// `animate-out` twin, minus the slide the twin does not have.
class _TooltipTransition extends StatelessWidget {
  const _TooltipTransition({required this.animation, required this.child});

  final Animation<double> animation;

  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (BuildContext context, Widget? child) {
          final double t = DsCurves.out.transform(animation.value.clamp(0, 1));
          final bool entering = animation.status != AnimationStatus.reverse;
          return Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, entering ? DsTooltip.slide * (1 - t) : 0),
              child: Transform.scale(
                scale: _zoom + (1 - _zoom) * t,
                // The bottom edge of the box is where the trigger is.
                alignment: Alignment.bottomCenter,
                child: child,
              ),
            ),
          );
        },
      );
}
