/// `components/ui/popover.tsx` — the anchored overlay, and the first one in
/// the port that is a primitive rather than a component's private machinery.
///
/// Scope, per supervisor ruling L11: **side / align / sideOffset and a real
/// collision flip; no arrow, no nested portals.** A popover that runs off the
/// screen is a bug rather than a drift, so the flip is built. An arrow is paint
/// nothing on the ported pages asks for, and a popover inside a popover is
/// `menus`/`dialogs` territory — the same shape as the ruling that scoped
/// `DsSelect` in phase 3.
///
/// `PopoverContent`'s class list, with the two twMerge casualties struck
/// (selects-map §10.2):
///
/// ```
/// z-50 flex w-72̶ →w-auto origin-(--radix-popover-content-transform-origin)
/// flex-col gap-2.5 rounded-lg bg-popover p-2.5̶ →p-0 text-sm
/// text-popover-foreground shadow-md ring-1 ring-foreground/10 outline-hidden
/// data-[side=bottom]:slide-in-from-top-2
/// data-open:animate-in data-open:fade-in-0 data-open:zoom-in-95
/// data-closed:animate-out data-closed:fade-out-0 data-closed:zoom-out-95
/// ```
///
/// | part | value |
/// |---|---|
/// | surface | 12px radius, `--popover` fill, Tailwind-stock `shadow-md` under a 1px `--foreground`/10 ring |
/// | enter | opacity 0→1, scale 0.95→1, and — **on the bottom side only** — a −8px slide, over `--duration-overlay` on `--ease-out` |
/// | exit | opacity 1→0, scale 1→0.95. No slide: `slide-in-from-*` is an entrance utility and the class list writes no exit twin |
/// | origin | the corner nearest the trigger, which is what `--radix-popover-content-transform-origin` resolves to |
///
/// **This is the one overlay in the family that animates, and its opposite
/// number is in the same file tree**: `SelectContent` ships the identical
/// animation set and cancels all of it with
/// `data-[align-trigger=true]:animate-none` (selects-map drift 9). Same design
/// system, same overlay job, opposite answers — both are reproduced.
///
/// **Open state is a prop, not a controller.** `open` is read the way Radix
/// reads `open`: the caller owns the boolean, and [onDismiss] reports the two
/// gestures that ask for it to become false. A combobox opens from typing and
/// a date picker from a button press; neither wants an overlay object with a
/// lifecycle of its own, and a controller would have to be created and disposed
/// by every call site for nothing.
///
/// **Focus is the content's business.** Nothing here steals it: the combobox
/// keeps the caret in its input while its popup is open, and the date picker's
/// calendar carries `autoFocus` and takes it for itself. What this widget does
/// supply is the Escape key *when focus is already inside the popup* — key
/// events travel up from the focused node, so a `Focus` wrapped around the
/// content sees them, and a caller whose focus stays outside (the combobox)
/// handles Escape where the focus is.
library;

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../effects/machine_surface.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../theme_scope.dart';

/// `ring-1 ring-foreground/10` — every overlay in the family wears it.
const double _ringAlpha = 0.10;

/// `zoom-in-95` / `zoom-out-95` — tw-animate-css's own scale, the same 95% the
/// stock `scale-95` utility means. Not [DsTransforms.buttonScale]: that records
/// a *press*, and an overlay that borrowed it would follow a retuned button.
const double _zoom = 0.95;

/// Which edge of the trigger the popup is placed against — Radix's `side`.
enum DsPopoverSide {
  /// Above the trigger.
  top,

  /// Below it — Radix's default, and both sites on the selects page.
  bottom,

  /// To the left.
  left,

  /// To the right.
  right;

  /// The side a collision flips this one onto.
  DsPopoverSide get opposite => switch (this) {
        DsPopoverSide.top => DsPopoverSide.bottom,
        DsPopoverSide.bottom => DsPopoverSide.top,
        DsPopoverSide.left => DsPopoverSide.right,
        DsPopoverSide.right => DsPopoverSide.left,
      };

  /// True for [top] and [bottom] — the sides whose main axis is vertical.
  bool get isVertical =>
      this == DsPopoverSide.top || this == DsPopoverSide.bottom;
}

/// How the popup lines up on the cross axis — Radix's `align`.
enum DsPopoverAlign {
  /// Leading edges flush. What both consumers pass.
  start,

  /// Centred on the trigger — Radix's default.
  center,

  /// Trailing edges flush.
  end,
}

/// Where the positioner put the popup, after the flip and the shift.
@immutable
class DsPopoverPlacement {
  const DsPopoverPlacement({
    required this.offset,
    required this.side,
    required this.origin,
  });

  /// The popup's top-left, in the overlay's coordinate space.
  final Offset offset;

  /// The side it ended up on — [DsPopoverSide.opposite] of the requested one
  /// when the flip fired. Radix writes this back as `data-side`, which is why
  /// `data-[side=bottom]:slide-in-from-top-2` can only be resolved after
  /// placement.
  final DsPopoverSide side;

  /// `--radix-popover-content-transform-origin`: the corner nearest the
  /// trigger, which is where the zoom grows from.
  final Alignment origin;

  @override
  bool operator ==(Object other) =>
      other is DsPopoverPlacement &&
      other.offset == offset &&
      other.side == side &&
      other.origin == origin;

  @override
  int get hashCode => Object.hash(offset, side, origin);
}

/// The positioner, as a pure function: floating-ui's `flip()` then `shift()`,
/// which is the pair `@radix-ui/react-popper` composes.
///
/// The main axis carries the side and the [sideOffset]; the cross axis carries
/// the align and is clamped into the viewport rather than flipped, because
/// sliding a popup along its trigger keeps it attached and flipping it across
/// would not. When **neither** side fits, the one with more room wins and the
/// popup is capped by [DsPopoverAnchorMetrics.availableHeight] instead — a
/// popup that hangs off the screen is the one outcome this must not produce.
DsPopoverPlacement dsPopoverPlacement({
  required Rect anchor,
  required Size content,
  required Size viewport,
  DsPopoverSide side = DsPopoverSide.bottom,
  DsPopoverAlign align = DsPopoverAlign.center,
  double sideOffset = 0,
  double collisionPadding = 0,
}) {
  double roomOn(DsPopoverSide s) => switch (s) {
        DsPopoverSide.top => anchor.top - sideOffset - collisionPadding,
        DsPopoverSide.bottom =>
          viewport.height - collisionPadding - anchor.bottom - sideOffset,
        DsPopoverSide.left => anchor.left - sideOffset - collisionPadding,
        DsPopoverSide.right =>
          viewport.width - collisionPadding - anchor.right - sideOffset,
      };

  final double needed = side.isVertical ? content.height : content.width;
  final double roomPreferred = roomOn(side);
  final double roomOpposite = roomOn(side.opposite);

  final DsPopoverSide resolved = roomPreferred >= needed
      ? side
      : roomOpposite >= needed
          ? side.opposite
          : roomPreferred >= roomOpposite
              ? side
              : side.opposite;

  // The cross axis: align, then shift back inside the viewport.
  double crossFor(double anchorStart, double anchorSize, double contentSize,
      double viewportSize) {
    final double placed = switch (align) {
      DsPopoverAlign.start => anchorStart,
      DsPopoverAlign.center =>
        anchorStart + anchorSize / 2 - contentSize / 2,
      DsPopoverAlign.end => anchorStart + anchorSize - contentSize,
    };
    final double ceiling = viewportSize - collisionPadding - contentSize;
    return placed
        .clamp(collisionPadding, ceiling < collisionPadding ? collisionPadding : ceiling)
        .toDouble();
  }

  final Offset offset = switch (resolved) {
    DsPopoverSide.bottom => Offset(
        crossFor(anchor.left, anchor.width, content.width, viewport.width),
        anchor.bottom + sideOffset,
      ),
    DsPopoverSide.top => Offset(
        crossFor(anchor.left, anchor.width, content.width, viewport.width),
        anchor.top - sideOffset - content.height,
      ),
    DsPopoverSide.right => Offset(
        anchor.right + sideOffset,
        crossFor(anchor.top, anchor.height, content.height, viewport.height),
      ),
    DsPopoverSide.left => Offset(
        anchor.left - sideOffset - content.width,
        crossFor(anchor.top, anchor.height, content.height, viewport.height),
      ),
  };

  // The transform origin — `--radix-popover-content-transform-origin`, and
  // base-ui's `--transform-origin`. **It points at the trigger, not at a
  // corner.**
  //
  // *(Measured on the live reference, 2026-08-15: an open combobox popup
  // computes `--transform-origin: 172px calc(100% + 6px)` — 172 is half of its
  // 344px anchor, and `100% + 6px` is its own far edge plus the 6px
  // `sideOffset`.)* So the cross axis is the **anchor's centre** expressed in
  // the popup's box, which for a `start`-aligned popup 28px wider than its
  // anchor is near-centred rather than hard left; and the main axis is the
  // popup edge facing the trigger, pushed out by the gap between them.
  double alignmentOf(double point, double origin, double extent) =>
      extent <= 0 ? 0 : (point - origin) / extent * 2 - 1;

  final Alignment origin = switch (resolved) {
    DsPopoverSide.bottom || DsPopoverSide.top => Alignment(
        alignmentOf(anchor.center.dx, offset.dx, content.width),
        resolved == DsPopoverSide.bottom
            ? -1 - 2 * sideOffset / (content.height <= 0 ? 1 : content.height)
            : 1 + 2 * sideOffset / (content.height <= 0 ? 1 : content.height),
      ),
    DsPopoverSide.right || DsPopoverSide.left => Alignment(
        resolved == DsPopoverSide.right
            ? -1 - 2 * sideOffset / (content.width <= 0 ? 1 : content.width)
            : 1 + 2 * sideOffset / (content.width <= 0 ? 1 : content.width),
        alignmentOf(anchor.center.dy, offset.dy, content.height),
      ),
  };

  return DsPopoverPlacement(offset: offset, side: resolved, origin: origin);
}

/// What the positioner knows about the trigger before the popup has been
/// measured — Radix's `--radix-popover-*` variables and base-ui's
/// `--anchor-width` / `--available-*`, handed to the content builder.
@immutable
class DsPopoverAnchorMetrics {
  const DsPopoverAnchorMetrics({
    required this.rect,
    required this.viewport,
    required this.availableWidth,
    required this.availableHeight,
  });

  /// The trigger's box, in the overlay's coordinate space.
  final Rect rect;

  /// The overlay's own box — the collision boundary.
  final Size viewport;

  /// `--available-width`.
  final double availableWidth;

  /// `--available-height`: how much room the requested side leaves. Read
  /// before the flip, exactly as the CSS variable is — it is the number a
  /// `max-h-(--available-height)` cap is resolved against at open time.
  final double availableHeight;

  /// `--anchor-width`. The combobox's popup is sized off this and then
  /// overruled by its own `min-w-[calc(var(--anchor-width)+--spacing(7))]`.
  double get anchorWidth => rect.width;
}

/// Builds the popup, given what the positioner knows about the trigger.
typedef DsPopoverContentBuilder = Widget Function(
  BuildContext context,
  DsPopoverAnchorMetrics metrics,
);

/// The popup's own paint — `rounded-lg bg-popover text-popover-foreground
/// shadow-md ring-1 ring-foreground/10`.
///
/// Shared by all three overlays on the selects page (selects-map drift 11:
/// *"`shadow-md` is Tailwind's stock elevation and it is now on three
/// overlays"*). Tailwind composites its ring slot in front of the shadow slot,
/// which is what prepending the ring layer means here — the same order
/// `DsButton.withFocusRing` documents.
class DsPopoverSurface extends StatelessWidget {
  const DsPopoverSurface({super.key, required this.child, this.radius});

  final Widget child;

  /// `rounded-lg` unless a caller says otherwise.
  final BorderRadius? radius;

  /// The spec every overlay in the family wears: a 1px `--foreground`/10 ring
  /// over Tailwind's stock `shadow-md`.
  static DsShadowSpec spec(DsThemeData theme) => DsShadowSpec(<DsShadowLayer>[
        DsShadowLayer(
          0,
          0,
          0,
          DsWidths.hairline,
          (DsThemeData t) => t.foreground.withValues(alpha: _ringAlpha),
        ),
        ...DsShadows.tailwindMd.layers,
      ]);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsMachineSurface(
      spec: spec(theme),
      radius: radius ?? BorderRadius.circular(DsRadii.lg),
      fill: theme.popover,
      // `text-popover-foreground` — an ambient style, the way the class is.
      child: DefaultTextStyle.merge(
        style: TextStyle(color: theme.popoverForeground),
        child: child,
      ),
    );
  }
}

/// An overlay anchored to [anchor], open when [open] says so.
class DsPopover extends StatefulWidget {
  const DsPopover({
    super.key,
    required this.open,
    required this.anchor,
    required this.content,
    this.side = DsPopoverSide.bottom,
    this.align = DsPopoverAlign.center,
    this.sideOffset = 0,
    this.collisionPadding = 0,
    this.animate = true,
    this.onDismiss,
  });

  /// Radix's `open`. The caller owns it; see the library doc.
  final bool open;

  /// The trigger. It is measured, never wrapped in a gesture: `PopoverTrigger
  /// asChild` hands its props to a real `Button`, and in this port the button
  /// keeps its own `onPressed`.
  final Widget anchor;

  final DsPopoverContentBuilder content;

  final DsPopoverSide side;
  final DsPopoverAlign align;

  /// `sideOffset` — 6px on the combobox positioner, 4px on the date picker's.
  final double sideOffset;

  /// Radix's `collisionPadding`, whose own default is 0 on `Popover.Content`.
  final double collisionPadding;

  /// Whether the popup runs the enter/exit set at all.
  ///
  /// Both answers are the reference's own: `PopoverContent` and
  /// `ComboboxContent` animate at 320ms, and `SelectContent` ships the
  /// identical class list and cancels every line of it with
  /// `data-[align-trigger=true]:animate-none` (selects-map drift 9). False is
  /// that cancellation — the popup appears, whole, in one frame. It is what
  /// `DsNativeSelect` mounts its menu under: an operating system's picker does
  /// not zoom.
  final bool animate;

  /// A pointer outside the popup, or Escape while focus is inside it.
  final VoidCallback? onDismiss;

  @override
  State<DsPopover> createState() => _DsPopoverState();
}

class _DsPopoverState extends State<DsPopover>
    with SingleTickerProviderStateMixin {
  final GlobalKey _anchorKey = GlobalKey();

  /// Built in [initState] rather than lazily: a popover that never opened
  /// would otherwise construct its controller inside [dispose], where creating
  /// a ticker means an inherited-widget lookup on an element that is already
  /// deactivated.
  late final AnimationController _animation;

  /// The portal the popup renders through.
  ///
  /// **Not an `OverlayEntry`.** An entry is a sibling subtree: inserting one, or
  /// marking one dirty, calls `setState` on the `Overlay` — and both of those
  /// happen here while an ancestor is mid-build, because `open` is a prop and a
  /// combobox flips it inside its own `setState`. The framework rejects that
  /// outright. `OverlayPortal` keeps the popup a **child of this widget** in the
  /// element tree while rendering it into the overlay's theatre, so it rebuilds
  /// in the same build scope as the anchor and no cross-tree invalidation
  /// exists to be illegal. The visibility toggle is the one thing left that
  /// mutates the overlay, and it waits for the frame boundary.
  final OverlayPortalController _portal = OverlayPortalController();

  /// Where the last layout put the popup.
  ///
  /// The flip is decided during layout, from a size only the layout knows, and
  /// the transform origin depends on the answer — so it is reported back out of
  /// the delegate and applied on the next frame. A popup whose side flips
  /// therefore zooms from the requested corner for one frame and from the
  /// resolved one for the rest of the 320ms; a popup that does not flip, which
  /// is every popup on the ported pages, is correct from the first.
  DsPopoverPlacement? _placement;

  bool get _showing => _portal.isShowing;

  /// Set while a frame-boundary sync is already queued, so a burst of prop
  /// changes costs one callback rather than one each.
  bool _syncQueued = false;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: DsDurations.overlay,
    );
    if (widget.open) _sync();
  }

  @override
  void didUpdateWidget(DsPopover old) {
    super.didUpdateWidget(old);
    if (widget.open != old.open) _sync();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  /// Brings the portal into line with [DsPopover.open], at the frame boundary.
  ///
  /// Showing and hiding both `setState`, and every caller flips `open` from
  /// inside its own build — a keystroke that filters a list, a button that
  /// opens a picker. Waiting for the end of the frame is what makes a
  /// declarative `open` legal at all, and it costs the popup nothing: an
  /// overlay child could not have been laid out before the next frame anyway.
  void _sync() {
    if (_syncQueued) return;
    _syncQueued = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _syncQueued = false;
      if (!mounted) return;
      if (widget.open) {
        _show();
      } else {
        _hide();
      }
    });
  }

  void _show() {
    if (_showing) return;
    _placement = null;
    _portal.show();
    _animation
      ..duration = _duration
      ..forward(from: 0);
  }

  /// `--duration-overlay`, unless the class list cancels the animation or the
  /// platform asks for reduced motion — both of which mean "no time at all".
  Duration get _duration => widget.animate
      ? dsAnimationDuration(context, DsDurations.overlay)
      : Duration.zero;

  void _hide() {
    if (!_showing) return;
    _animation.duration = _duration;
    _animation.reverse().whenComplete(() {
      // A reopen mid-exit takes the controller forward again; only the run that
      // actually reached zero may pull the popup.
      if (_animation.value != 0 || !mounted) return;
      _portal.hide();
    });
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey != LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    widget.onDismiss?.call();
    return KeyEventResult.handled;
  }

  /// Called from the layout delegate, which is mid-layout — so the report is
  /// deferred to the frame boundary rather than setting state under way.
  void _report(DsPopoverPlacement placement) {
    if (_placement == placement) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _placement == placement) return;
      setState(() => _placement = placement);
    });
  }

  Widget _buildOverlay(BuildContext overlayContext) {
    final RenderObject? object = _anchorKey.currentContext?.findRenderObject();
    // The overlay is an ancestor of this widget, so it is laid out before the
    // popup asks where it is — which is what makes the anchor's box
    // expressible in the coordinate space the placement returns.
    final RenderObject? theatre =
        Overlay.maybeOf(overlayContext)?.context.findRenderObject();
    if (object is! RenderBox ||
        theatre is! RenderBox ||
        !object.hasSize ||
        !theatre.hasSize) {
      return const SizedBox.shrink();
    }
    final RenderBox overlay = theatre;

    final Rect anchor =
        object.localToGlobal(Offset.zero, ancestor: overlay) & object.size;
    final Size viewport = overlay.size;
    final DsPopoverAnchorMetrics metrics = DsPopoverAnchorMetrics(
      rect: anchor,
      viewport: viewport,
      availableWidth: viewport.width - widget.collisionPadding * 2,
      availableHeight: switch (widget.side) {
        DsPopoverSide.bottom => viewport.height -
            widget.collisionPadding -
            anchor.bottom -
            widget.sideOffset,
        DsPopoverSide.top =>
          anchor.top - widget.sideOffset - widget.collisionPadding,
        DsPopoverSide.left ||
        DsPopoverSide.right =>
          viewport.height - widget.collisionPadding * 2,
      },
    );

    // The transform origin is the previous layout's answer; the first frame
    // uses the requested side, which is also the resolved one whenever nothing
    // collides.
    final Alignment origin = _placement?.origin ??
        switch (widget.side) {
          DsPopoverSide.bottom => Alignment(_alignAxis, -1),
          DsPopoverSide.top => Alignment(_alignAxis, 1),
          DsPopoverSide.right => Alignment(-1, _alignAxis),
          DsPopoverSide.left => Alignment(1, _alignAxis),
        };
    final DsPopoverSide side = _placement?.side ?? widget.side;

    return Stack(
      // The theatre hands an overlay child loose constraints; without this the
      // stack would collapse around children that are all positioned.
      fit: StackFit.expand,
      children: <Widget>[
        // Radix renders no scrim; a pointer anywhere else dismisses.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onDismiss,
          ),
        ),
        Positioned.fill(
          child: CustomSingleChildLayout(
            delegate: _PopoverLayout(
              anchor: anchor,
              side: widget.side,
              align: widget.align,
              sideOffset: widget.sideOffset,
              collisionPadding: widget.collisionPadding,
              onPlaced: _report,
            ),
            child: _animate(
              origin: origin,
              // `data-[side=bottom]:slide-in-from-top-2` — the one side the
              // class list writes a slide for.
              slide: side == DsPopoverSide.bottom,
              child: Focus(
                canRequestFocus: false,
                skipTraversal: true,
                onKeyEvent: _onKey,
                child: Builder(
                  builder: (BuildContext context) =>
                      widget.content(context, metrics),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// The transition, or nothing at all: `animate-none` does not mean "run the
  /// animation at zero" — it means the popup was never wrapped in one, which is
  /// the difference between a first frame at `scale(.95)` and a first frame
  /// that is simply the menu.
  Widget _animate({
    required Alignment origin,
    required bool slide,
    required Widget child,
  }) {
    if (!widget.animate) return child;
    return _PopoverTransition(
      animation: _animation,
      origin: origin,
      slide: slide,
      child: child,
    );
  }

  double get _alignAxis => switch (widget.align) {
        DsPopoverAlign.start => -1,
        DsPopoverAlign.center => 0,
        DsPopoverAlign.end => 1,
      };

  @override
  Widget build(BuildContext context) {
    // The popup is built from this build scope, so a list that narrows on a
    // keystroke narrows in the same frame the keystroke was handled in.
    return OverlayPortal(
      controller: _portal,
      overlayChildBuilder: _buildOverlay,
      child: KeyedSubtree(key: _anchorKey, child: widget.anchor),
    );
  }
}

/// Places the popup, and reports where it landed.
class _PopoverLayout extends SingleChildLayoutDelegate {
  const _PopoverLayout({
    required this.anchor,
    required this.side,
    required this.align,
    required this.sideOffset,
    required this.collisionPadding,
    required this.onPlaced,
  });

  final Rect anchor;
  final DsPopoverSide side;
  final DsPopoverAlign align;
  final double sideOffset;
  final double collisionPadding;
  final ValueChanged<DsPopoverPlacement> onPlaced;

  /// `max-h-(--available-height) max-w-(--available-width)`, applied as
  /// constraints rather than as paint: the popup may be any size it likes up to
  /// the room the boundary leaves.
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final double room = side.isVertical
        ? (anchor.top - sideOffset - collisionPadding) >
                (constraints.maxHeight -
                    collisionPadding -
                    anchor.bottom -
                    sideOffset)
            ? anchor.top - sideOffset - collisionPadding
            : constraints.maxHeight -
                collisionPadding -
                anchor.bottom -
                sideOffset
        : constraints.maxHeight - collisionPadding * 2;
    return BoxConstraints(
      maxWidth: constraints.maxWidth - collisionPadding * 2,
      maxHeight: room < 0 ? 0 : room,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final DsPopoverPlacement placement = dsPopoverPlacement(
      anchor: anchor,
      content: childSize,
      viewport: size,
      side: side,
      align: align,
      sideOffset: sideOffset,
      collisionPadding: collisionPadding,
    );
    onPlaced(placement);
    return placement.offset;
  }

  @override
  bool shouldRelayout(_PopoverLayout old) =>
      old.anchor != anchor ||
      old.side != side ||
      old.align != align ||
      old.sideOffset != sideOffset ||
      old.collisionPadding != collisionPadding;
}

/// `animate-in fade-in-0 zoom-in-95 slide-in-from-top-2` and its `animate-out`
/// twin, on one controller.
class _PopoverTransition extends StatelessWidget {
  const _PopoverTransition({
    required this.animation,
    required this.origin,
    required this.slide,
    required this.child,
  });

  final Animation<double> animation;
  final Alignment origin;

  /// Whether the entrance carries `slide-in-from-top-2`.
  final bool slide;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // `slide-in-from-top-2` — 2 spacing units of travel, and the exit has no
    // twin, so the offset is pinned to the forward run.
    final double travel = ds(2);
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (BuildContext context, Widget? child) {
        final double t = DsCurves.out.transform(animation.value.clamp(0, 1));
        final bool entering = animation.status != AnimationStatus.reverse;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, slide && entering ? -travel * (1 - t) : 0),
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
}
