/// `components/ui/hover-card.tsx` — *"a richer preview on hover, for pointer
/// users only."*
///
/// Measured open on the dialogs page (2026-08-16, 1440x900):
///
/// | part | measured |
/// |---|---|
/// | surface | `w-64` overridden to `w-72` by the call site — **288** — `p-2.5` 10px, `rounded-lg` 12px, `--popover` fill, `shadow-md` under a 1px `--foreground`/10 ring |
/// | placement | `side="bottom"`, `align="center"`, `sideOffset={4}` — measured 3.77px of gap and the two centres 0.06px apart |
/// | open | 728.3ms from pointer entry to first frame — Radix's `openDelay` default of 700, which the reference does not override |
/// | close | 329.3ms from the pointer leaving to `data-state="closed"` — the `closeDelay` default of 300 |
/// | enter | `animate-in fade-in-0 zoom-in-95 slide-in-from-top-2` over `--duration-overlay` 320ms on `--ease-out` |
/// | exit | `fade-out-0 zoom-out-95`, no slide |
///
/// **What it composes and what it does not.** The geometry is a popover's, so
/// the placement comes from [elPopoverPlacement] and the paint from
/// [ElPopoverSurface] — the same two objects the combobox and the date picker
/// use. What it cannot borrow is [ElPopover] itself: that widget lays a
/// full-screen opaque [GestureDetector] under its popup so a pointer anywhere
/// else dismisses it, which is correct for a click-opened panel and fatal for a
/// hover-opened one. The barrier would take the pointer off the trigger, the
/// trigger's `MouseRegion` would fire `onExit`, and the card would close and
/// reopen forever. A hover card is dismissed by the pointer *leaving*, and
/// nothing else.
///
/// **The close delay is what makes it usable at all** — the 300ms is the window
/// in which the pointer crosses the 4px gap between the trigger and the card,
/// and the card keeps itself open while the pointer is inside it.
library;

import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import '../foundation/spacing.dart';
import '../theme_scope.dart';
import 'popover.dart';

/// `zoom-in-95` / `zoom-out-95`.
const double _zoom = 0.95;

/// `HoverCard` — trigger, portal, content.
class ElHoverCard extends StatefulWidget {
  const ElHoverCard({
    super.key,
    required this.trigger,
    required this.content,
    this.width,
    this.openDelay = ElDurations.hoverCardOpenDelay,
    this.closeDelay = ElDurations.hoverCardCloseDelay,
  });

  /// `HoverCardTrigger asChild`.
  final Widget trigger;

  /// `HoverCardContent`'s children — laid out under [ElHoverCardContent]'s
  /// `p-2.5`.
  final Widget content;

  /// The call site's `className="w-72"`, which beats the component's own
  /// `w-64`. Both are literal widths, so this is a number rather than a
  /// max-width; null takes [defaultWidth].
  final double? width;

  /// `w-72` — 288, the dialogs page's override and the only one in the corpus.
  ///
  /// The component's own `w-64` (256) is never rendered anywhere in the port,
  /// so it is recorded here and not defaulted to.
  static double get defaultWidth => el(72);

  final Duration openDelay;
  final Duration closeDelay;

  /// `sideOffset={4}`.
  static double get sideOffset => el(1);

  /// `slide-in-from-top-2`.
  static double get slide => el(2);

  @override
  State<ElHoverCard> createState() => _ElHoverCardState();
}

class _ElHoverCardState extends State<ElHoverCard>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _portal = OverlayPortalController();
  final GlobalKey _anchorKey = GlobalKey();

  /// Built in [initState], never lazily — see `ElPopover`'s note.
  late final AnimationController _animation;

  /// Whichever dwell timer is outstanding — open or close, never both.
  Object? _pending;

  /// Set while the pointer is inside the card itself, which is what stops the
  /// close timer from firing as the pointer crosses the gap.
  bool _insideCard = false;

  ElPopoverPlacement? _placement;

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
    _animation.dispose();
    super.dispose();
  }

  void _scheduleOpen() {
    final Object token = Object();
    _pending = token;
    Future<void>.delayed(widget.openDelay, () {
      if (!mounted || _pending != token) return;
      _pending = null;
      if (_portal.isShowing) return;
      _placement = null;
      _portal.show();
      _animation
        ..duration = elAnimationDuration(context, ElDurations.overlay)
        ..forward(from: 0);
    });
  }

  void _scheduleClose() {
    final Object token = Object();
    _pending = token;
    Future<void>.delayed(widget.closeDelay, () {
      if (!mounted || _pending != token || _insideCard) return;
      _pending = null;
      if (!_portal.isShowing) return;
      _animation.duration = elAnimationDuration(context, ElDurations.overlay);
      _animation.reverse().whenComplete(() {
        if (_animation.value != 0 || !mounted) return;
        _portal.hide();
      });
    });
  }

  void _report(ElPopoverPlacement placement) {
    if (_placement == placement) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _placement == placement) return;
      setState(() => _placement = placement);
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
      child: CustomSingleChildLayout(
        delegate: _HoverCardLayout(anchor: anchor, onPlaced: _report),
        child: MouseRegion(
          onEnter: (_) {
            _insideCard = true;
            _pending = null;
          },
          onExit: (_) {
            _insideCard = false;
            _scheduleClose();
          },
          child: _HoverCardTransition(
            animation: _animation,
            origin: _placement?.origin ?? Alignment.topCenter,
            child: SizedBox(
              width: widget.width ?? ElHoverCard.defaultWidth,
              child: ElHoverCardContent(child: widget.content),
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
    child: MouseRegion(
      onEnter: (_) => _scheduleOpen(),
      onExit: (_) => _scheduleClose(),
      child: KeyedSubtree(key: _anchorKey, child: widget.trigger),
    ),
  );
}

/// Places the card with the popover positioner — the same `flip()` then
/// `shift()` pair `@radix-ui/react-popper` composes for both.
class _HoverCardLayout extends SingleChildLayoutDelegate {
  const _HoverCardLayout({required this.anchor, required this.onPlaced});

  final Rect anchor;
  final ValueChanged<ElPopoverPlacement> onPlaced;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final ElPopoverPlacement placement = elPopoverPlacement(
      anchor: anchor,
      content: childSize,
      viewport: size,
      sideOffset: ElHoverCard.sideOffset,
    );
    onPlaced(placement);
    return placement.offset;
  }

  @override
  bool shouldRelayout(_HoverCardLayout old) => old.anchor != anchor;
}

/// `HoverCardContent` — the surface, with its `p-2.5` inside it.
class ElHoverCardContent extends StatelessWidget {
  const ElHoverCardContent({super.key, required this.child});

  final Widget child;

  /// `p-2.5`.
  static double get padding => el(2.5);

  @override
  Widget build(BuildContext context) => ElPopoverSurface(
    child: Padding(padding: EdgeInsets.all(padding), child: child),
  );
}

/// `animate-in fade-in-0 zoom-in-95 slide-in-from-top-2`, and its twin without
/// the slide.
class _HoverCardTransition extends StatelessWidget {
  const _HoverCardTransition({
    required this.animation,
    required this.origin,
    required this.child,
  });

  final Animation<double> animation;

  /// `--radix-hover-card-content-transform-origin`, measured `50% 0px`.
  final Alignment origin;

  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    child: child,
    builder: (BuildContext context, Widget? child) {
      final double t = ElCurves.out.transform(animation.value.clamp(0, 1));
      final bool entering = animation.status != AnimationStatus.reverse;
      return Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, entering ? -ElHoverCard.slide * (1 - t) : 0),
          child: Transform.scale(
            scale: _zoom + (1 - _zoom) * t,
            alignment: origin,
            child: child,
          ),
        ),
      );
    },
  );
}
