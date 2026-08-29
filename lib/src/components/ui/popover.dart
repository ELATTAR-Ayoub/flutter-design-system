/// `components/ui/popover.tsx` — the anchored overlay, and the first one in
/// the port that is a primitive rather than a component's private machinery.
///
/// Scope, per supervisor ruling L11: **side / align / sideOffset and a real
/// collision flip; no arrow, no nested portals.** A popover that runs off the
/// screen is a bug rather than a drift, so the flip is built. An arrow is paint
/// nothing on the ported pages asks for, and a popover inside a popover is
/// `menus`/`dialogs` territory — the same shape as the ruling that scoped
/// `Select` in phase 3.
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
///
/// ## What the `menus` family added (2026-08-16)
///
/// Ruling L11 scoped this to *"side/align/offset + collision flip; no arrow; no
/// nested portals"*, with nested portals **deferred until a page needed them**.
/// The menus page needs one — a context-menu submenu is a popover mounted from
/// inside a popover's content — so the deferral is discharged here, and four
/// more knobs arrived with it. Every one is a **measured** difference between
/// what `popover.tsx` declares and what `dropdown-menu.tsx`,
/// `context-menu.tsx` and `menubar.tsx` declare; none changes a default, so no
/// shipped consumer moves.
///
/// | knob | why | measured |
/// |---|---|---|
/// | [Popover.origin] | Radix and base-ui write **different** transform origins | an open dropdown computes `--radix-dropdown-menu-content-transform-origin: 0% 0px` — the content's own **corner** — where the combobox's base-ui popup computes `172px calc(100% + 6px)`, the **anchor's centre** |
/// | [Popover.slideSides] | `popover.tsx` writes one `slide-in-from-*`; every menu writes four | a submenu at `side=right` enters with `translateX −8 → 0` (x 695 → 703 over 320ms) |
/// | [Popover.anchorPoint] | a context menu has no trigger box — Radix anchors it to a **virtual element** at the pointer | the content lands at `pointer + (2, 0)`, `side=right align=start` |
/// | [Popover.animateOut] | `MenubarContent`'s class list carries `data-open:animate-in` and **no `animate-out` twin** | its sibling `MenubarSubContent` carries both |
/// | [Popover.barrier] | a submenu is one dismissable branch with its parent, not a second layer over it | with a barrier of its own, a pointer moving from the submenu back onto a parent row would never reach the row |
library;

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
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
import 'package:flutter/widgets.dart' as flutter show OverlayPortal;

import './surface.dart';
import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/shadows.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/theme_scope.dart';

/// `ring-1 ring-foreground/10` — every overlay in the family wears it.
const double _ringAlpha = 0.10;

/// `zoom-in-95` / `zoom-out-95` — tw-animate-css's own scale, the same 95% the
/// stock `scale-95` utility means. Not [MotionTransforms.buttonPress]: that records
/// a *press*, and an overlay that borrowed it would follow a retuned button.
const double _zoom = 0.95;

/// Which edge of the trigger the popup is placed against — Radix's `side`.
enum PopoverSide {
  /// Above the trigger.
  top,

  /// Below it — Radix's default, and both sites on the selects page.
  bottom,

  /// To the left.
  left,

  /// To the right.
  right;

  /// The side a collision flips this one onto.
  PopoverSide get opposite => switch (this) {
    PopoverSide.top => PopoverSide.bottom,
    PopoverSide.bottom => PopoverSide.top,
    PopoverSide.left => PopoverSide.right,
    PopoverSide.right => PopoverSide.left,
  };

  /// True for [top] and [bottom] — the sides whose main axis is vertical.
  bool get isVertical => this == PopoverSide.top || this == PopoverSide.bottom;
}

/// How the popup lines up on the cross axis — Radix's `align`.
enum PopoverAlign {
  /// Leading edges flush. What both consumers pass.
  start,

  /// Centred on the trigger — Radix's default.
  center,

  /// Trailing edges flush.
  end,
}

/// Which library's `transform-origin` the zoom grows from.
///
/// The two overlay libraries in the corpus disagree, and both answers are
/// measured on the live reference — so this is a fact about the consumer, not a
/// tuning knob.
enum PopoverAnchorMode {
  /// base-ui's `--transform-origin`: **it points at the trigger.**
  ///
  /// *(Measured 2026-08-15: an open combobox popup computes
  /// `172px calc(100% + 6px)` — 172 is half of its 344px anchor, and
  /// `100% + 6px` is its own far edge plus the 6px `sideOffset`.)* The default,
  /// because `Popover`'s first two consumers are both base-ui's.
  anchor,

  /// Radix's `--radix-*-content-transform-origin`: **the popup's own corner.**
  ///
  /// *(Measured 2026-08-16: an open `DropdownMenuContent` at
  /// `side=bottom align=start` computes `0% 0px`; a `ContextMenuContent` at
  /// `side=right align=start` computes `0px 0%`; a `MenubarContent` at
  /// `side=bottom align=start` computes `0% 0px`.)* Radix's own middleware
  /// writes `{start: '0%', center: '50%', end: '100%'}` on the cross axis and
  /// `0px` / `100%` on the main one — it reads the **resolved placement** and
  /// nothing else, so neither the `sideOffset` nor the collision shift moves
  /// it.
  corner,

  /// CSS's own initial value — `50% 50%`, the popup's own middle.
  ///
  /// A model in its own right because one overlay in the corpus reaches it by
  /// **failure**: `NavigationMenuViewport` writes `origin-top-center`
  /// (`components/ui/navigation-menu.tsx` L164), which is not a Tailwind
  /// utility — the scale has `origin-top`, `origin-center` and
  /// `origin-top-left`, and no `origin-top-center` — so the class compiles to
  /// nothing and the property keeps its initial value. Measured 2026-08-16 on
  /// an open Packs panel: `transform-origin` computes **`288px 89px`** on a
  /// 576 × 178 viewport, which is dead centre and is not the top of anything.
  ///
  /// Spelled as a model rather than reproduced by picking a wrong side,
  /// because it is not a placement fact: no `side` or `align` combination makes
  /// [corner] or [anchor] answer the centre, and a reader of the call site
  /// should see that this popup zooms from its own middle on purpose.
  selfCenter,
}

/// What an open popup lays under itself to catch a pointer aimed elsewhere.
///
/// Radix's `modal` prop and its `DismissableLayer` nesting, on one axis —
/// because the three answers are exactly the three configurations the corpus
/// uses, and no consumer needs two independent switches.
enum PopoverBarrier {
  /// `modal={true}` — the layer is **opaque** to hit testing, so nothing
  /// outside the popup can be hovered or clicked while it is open; the pointer
  /// dismisses instead. `DropdownMenu`'s and `ContextMenu`'s own default, and
  /// what every popover in the port shipped with.
  modal,

  /// `modal={false}` — the layer is **translucent**: an outside pointer both
  /// dismisses *and* reaches whatever it landed on.
  ///
  /// This is what makes a menubar work. *(Measured 2026-08-16: with one menu
  /// open, `pointerover` on a sibling trigger at t=167.3 flipped both
  /// `data-state` attributes by t=168.5.)* A modal layer would swallow that
  /// hover and the strip could never hand over.
  nonModal,

  /// No layer at all — a **submenu**. Radix nests a `MenuSub`'s content inside
  /// its parent's dismissable branch rather than stacking a second one, and a
  /// layer here would sit over the parent's rows: a pointer moving from an open
  /// submenu back onto a sibling row would land on the barrier instead of the
  /// row, and the submenu would never close.
  none,
}

/// Where the positioner put the popup, after the flip and the shift.
@immutable
class PopoverPlacement {
  const PopoverPlacement({
    required this.offset,
    required this.side,
    required this.origin,
  });

  /// The popup's top-left, in the overlay's coordinate space.
  final Offset offset;

  /// The side it ended up on — [PopoverSide.opposite] of the requested one
  /// when the flip fired. Radix writes this back as `data-side`, which is why
  /// `data-[side=bottom]:slide-in-from-top-2` can only be resolved after
  /// placement.
  final PopoverSide side;

  /// `--radix-popover-content-transform-origin`: the corner nearest the
  /// trigger, which is where the zoom grows from.
  final Alignment origin;

  @override
  bool operator ==(Object other) =>
      other is PopoverPlacement &&
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
/// popup is capped by [PopoverAnchorMetrics.availableHeight] instead — a
/// popup that hangs off the screen is the one outcome this must not produce.
PopoverPlacement popoverPlacement({
  required Rect anchor,
  required Size content,
  required Size viewport,
  PopoverSide side = PopoverSide.bottom,
  PopoverAlign align = PopoverAlign.center,
  double sideOffset = 0,
  double collisionPadding = 0,
  PopoverAnchorMode origin = PopoverAnchorMode.anchor,
}) {
  double roomOn(PopoverSide s) => switch (s) {
    PopoverSide.top => anchor.top - sideOffset - collisionPadding,
    PopoverSide.bottom =>
      viewport.height - collisionPadding - anchor.bottom - sideOffset,
    PopoverSide.left => anchor.left - sideOffset - collisionPadding,
    PopoverSide.right =>
      viewport.width - collisionPadding - anchor.right - sideOffset,
  };

  final double needed = side.isVertical ? content.height : content.width;
  final double roomPreferred = roomOn(side);
  final double roomOpposite = roomOn(side.opposite);

  final PopoverSide resolved = roomPreferred >= needed
      ? side
      : roomOpposite >= needed
      ? side.opposite
      : roomPreferred >= roomOpposite
      ? side
      : side.opposite;

  // The cross axis: align, then shift back inside the viewport.
  double crossFor(
    double anchorStart,
    double anchorSize,
    double contentSize,
    double viewportSize,
  ) {
    final double placed = switch (align) {
      PopoverAlign.start => anchorStart,
      PopoverAlign.center => anchorStart + anchorSize / 2 - contentSize / 2,
      PopoverAlign.end => anchorStart + anchorSize - contentSize,
    };
    final double ceiling = viewportSize - collisionPadding - contentSize;
    return placed
        .clamp(
          collisionPadding,
          ceiling < collisionPadding ? collisionPadding : ceiling,
        )
        .toDouble();
  }

  final Offset offset = switch (resolved) {
    PopoverSide.bottom => Offset(
      crossFor(anchor.left, anchor.width, content.width, viewport.width),
      anchor.bottom + sideOffset,
    ),
    PopoverSide.top => Offset(
      crossFor(anchor.left, anchor.width, content.width, viewport.width),
      anchor.top - sideOffset - content.height,
    ),
    PopoverSide.right => Offset(
      anchor.right + sideOffset,
      crossFor(anchor.top, anchor.height, content.height, viewport.height),
    ),
    PopoverSide.left => Offset(
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

  // Radix's cross axis, on the other hand, is a keyword per `align` and
  // nothing else — `{start: '0%', center: '50%', end: '100%'}` — and its main
  // axis is the flat edge, `0px` or `100%`, with no `sideOffset` term.
  final double crossKeyword = switch (align) {
    PopoverAlign.start => -1,
    PopoverAlign.center => 0,
    PopoverAlign.end => 1,
  };

  final Alignment resolvedOrigin = switch (origin) {
    // `transform-origin: 50% 50%` — the initial value, and what an unmatched
    // `origin-*` class leaves behind.
    PopoverAnchorMode.selfCenter => Alignment.center,
    PopoverAnchorMode.corner => switch (resolved) {
      PopoverSide.bottom => Alignment(crossKeyword, -1),
      PopoverSide.top => Alignment(crossKeyword, 1),
      PopoverSide.right => Alignment(-1, crossKeyword),
      PopoverSide.left => Alignment(1, crossKeyword),
    },
    PopoverAnchorMode.anchor => switch (resolved) {
      PopoverSide.bottom || PopoverSide.top => Alignment(
        alignmentOf(anchor.center.dx, offset.dx, content.width),
        resolved == PopoverSide.bottom
            ? -1 - 2 * sideOffset / (content.height <= 0 ? 1 : content.height)
            : 1 + 2 * sideOffset / (content.height <= 0 ? 1 : content.height),
      ),
      PopoverSide.right || PopoverSide.left => Alignment(
        resolved == PopoverSide.right
            ? -1 - 2 * sideOffset / (content.width <= 0 ? 1 : content.width)
            : 1 + 2 * sideOffset / (content.width <= 0 ? 1 : content.width),
        alignmentOf(anchor.center.dy, offset.dy, content.height),
      ),
    },
  };

  return PopoverPlacement(
    offset: offset,
    side: resolved,
    origin: resolvedOrigin,
  );
}

/// What the positioner knows about the trigger before the popup has been
/// measured — Radix's `--radix-popover-*` variables and base-ui's
/// `--anchor-width` / `--available-*`, handed to the content builder.
@immutable
class PopoverAnchorMetrics {
  const PopoverAnchorMetrics({
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
typedef PopoverContentBuilder =
    Widget Function(BuildContext context, PopoverAnchorMetrics metrics);

/// The popup's own paint — `rounded-lg bg-popover text-popover-foreground
/// shadow-md ring-1 ring-foreground/10`.
///
/// Shared by all three overlays on the selects page (selects-map drift 11:
/// *"`shadow-md` is Tailwind's stock elevation and it is now on three
/// overlays"*). Tailwind composites its ring slot in front of the shadow slot,
/// which is what prepending the ring layer means here — the same order
/// `Button.withFocusRing` documents.
class PopoverSurface extends StatelessWidget {
  const PopoverSurface({
    super.key,
    required this.child,
    this.radius,
    this.shadow,
    this.ring = true,
    this.border,
  });

  final Widget child;

  /// `rounded-lg` unless a caller says otherwise.
  final BorderRadius? radius;

  /// The elevation under the ring — `shadow-md` unless a caller says
  /// otherwise. Every `*SubContent` in the menu family writes `shadow-lg`.
  final ShadowStyle? shadow;

  /// `ring-1 ring-foreground/10`. **False for `ContextMenuSubContent`**, which
  /// is the one overlay in the corpus that writes a real `border` instead.
  final bool ring;

  /// A real border, when the class list writes one. It costs the box 2px, the
  /// way `box-sizing: border-box` does not — a `border` on a shrink-wrapping
  /// popup makes it wider, and *(measured)* the context menu's submenu is
  /// 87.125 tall where its rows add up to 85.125.
  final BoxBorder? border;

  /// The spec every overlay in the family wears: a 1px `--foreground`/10 ring
  /// over Tailwind's stock `shadow-md`.
  static ShadowStyle spec(ThemeTokens theme) => specOf();

  /// The same recipe with either half swapped out.
  static ShadowStyle specOf({ShadowStyle? shadow, bool ring = true}) =>
      ShadowStyle(<ShadowLayer>[
        if (ring)
          ShadowLayer(
            0,
            0,
            0,
            BorderWidths.hairline,
            (ThemeTokens t) => t.foreground.withValues(alpha: _ringAlpha),
          ),
        ...(shadow ?? Shadows.tailwindMd).layers,
      ]);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Surface(
      spec: specOf(shadow: shadow, ring: ring),
      radius: radius ?? BorderRadius.circular(Radii.lg),
      fill: theme.popover,
      border: border,
      // `text-popover-foreground` — an ambient style, the way the class is.
      //
      // The decoration is reset with it, and that is not decoration for its
      // own sake. A popup that is mounted as a raw `OverlayEntry` builds in
      // the Overlay's context, not the caller's, so it inherits whatever
      // `DefaultTextStyle` sits above the Navigator — in a `WidgetsApp` with
      // no `Material` that is the "you forgot a Material" style: red ink
      // under a double yellow underline. `StyledText` sets its own colour and
      // never a decoration, so the ink came out right and every row in an
      // open `Select` wore two yellow lines. Merging a colour alone left the
      // underline behind; a popup surface owns its whole text style.
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: theme.popoverForeground,
          decoration: TextDecoration.none,
        ),
        child: child,
      ),
    );
  }
}

/// An overlay anchored to [anchor], open when [open] says so.
class Popover extends StatefulWidget {
  const Popover({
    super.key,
    required this.open,
    required this.anchor,
    required this.content,
    this.side = PopoverSide.bottom,
    this.align = PopoverAlign.center,
    this.sideOffset = 0,
    this.collisionPadding = 0,
    this.animate = true,
    this.animateOut = true,
    this.origin = PopoverAnchorMode.anchor,
    this.slideSides = const <PopoverSide>{PopoverSide.bottom},
    this.anchorPoint,
    this.barrier = PopoverBarrier.modal,
    this.onDismiss,
  });

  /// Radix's `open`. The caller owns it; see the library doc.
  final bool open;

  /// The trigger. It is measured, never wrapped in a gesture: `PopoverTrigger
  /// asChild` hands its props to a real `Button`, and in this port the button
  /// keeps its own `onPressed`.
  final Widget anchor;

  final PopoverContentBuilder content;

  final PopoverSide side;
  final PopoverAlign align;

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
  /// `NativeSelect` mounts its menu under: an operating system's picker does
  /// not zoom.
  final bool animate;

  /// Whether the **exit** half of that set exists.
  ///
  /// `PopoverContent`, `DropdownMenuContent`, `ContextMenuContent` and every
  /// `*SubContent` in the corpus write `data-closed:animate-out
  /// data-closed:fade-out-0 data-closed:zoom-out-95`. **`MenubarContent` does
  /// not** — its class list stops after `data-open:zoom-in-95`, so the menubar's
  /// menus zoom in and vanish. False is that missing twin: the popup unmounts
  /// on the frame `open` goes false. Ignored while [animate] is false, which
  /// already means "no animation at either end".
  final bool animateOut;

  /// Whose `transform-origin` the zoom grows from — see [PopoverAnchorMode].
  final PopoverAnchorMode origin;

  /// The sides whose **entrance** carries a `slide-in-from-*` utility.
  ///
  /// `popover.tsx` writes one (`data-[side=bottom]:slide-in-from-top-2`); all
  /// three menu files write four. The travel is always 2 spacing units
  /// *towards* the trigger's side — measured on an open submenu at
  /// `side=right`, which enters from 8px to its left.
  final Set<PopoverSide> slideSides;

  /// A **virtual anchor**: a zero-size rect at this point, in global
  /// coordinates, instead of [Popover.anchor]'s measured box.
  ///
  /// Radix's `ContextMenu` anchors its content to a virtual element built from
  /// the `contextmenu` event's client coordinates, which is why a right-click
  /// menu opens at the pointer and not at the corner of the thing right-clicked.
  /// [anchor] still renders and is still hit-tested — it is the target, it is
  /// simply no longer the box.
  final Offset? anchorPoint;

  /// What the popup lays under itself to catch an outside pointer — Radix's
  /// `modal`, and its `DismissableLayer` nesting.
  final PopoverBarrier barrier;

  /// A pointer outside the popup, or Escape while focus is inside it.
  final VoidCallback? onDismiss;

  @override
  State<Popover> createState() => _PopoverState();
}

class _PopoverState extends State<Popover> with SingleTickerProviderStateMixin {
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
  PopoverPlacement? _placement;

  bool get _showing => _portal.isShowing;

  /// Set while a frame-boundary sync is already queued, so a burst of prop
  /// changes costs one callback rather than one each.
  bool _syncQueued = false;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: MotionDurations.overlayEnter,
    );
    if (widget.open) _sync();
  }

  @override
  void didUpdateWidget(Popover old) {
    super.didUpdateWidget(old);
    if (widget.open != old.open) _sync();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  /// Brings the portal into line with [Popover.open], at the frame boundary.
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
      ? effectiveMotionDuration(context, MotionDurations.overlayEnter)
      : Duration.zero;

  void _hide() {
    if (!_showing) return;
    // `MenubarContent` writes no `animate-out`: there is no exit to run, so the
    // controller is not reversed at all and the portal goes in this frame.
    if (!widget.animateOut) {
      _animation.value = 0;
      _portal.hide();
      return;
    }
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
  void _report(PopoverPlacement placement) {
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
    final RenderObject? theatre = Overlay.maybeOf(
      overlayContext,
    )?.context.findRenderObject();
    if (object is! RenderBox ||
        theatre is! RenderBox ||
        !object.hasSize ||
        !theatre.hasSize) {
      return const SizedBox.shrink();
    }
    final RenderBox overlay = theatre;

    // Radix's virtual element, when the caller supplies one: a zero-size box at
    // the pointer, in the overlay's own coordinate space.
    final Offset? point = widget.anchorPoint;
    final Rect anchor = point == null
        ? object.localToGlobal(Offset.zero, ancestor: overlay) & object.size
        : (overlay.globalToLocal(point) & Size.zero);
    final Size viewport = overlay.size;
    final PopoverAnchorMetrics metrics = PopoverAnchorMetrics(
      rect: anchor,
      viewport: viewport,
      availableWidth: viewport.width - widget.collisionPadding * 2,
      availableHeight: switch (widget.side) {
        PopoverSide.bottom =>
          viewport.height -
              widget.collisionPadding -
              anchor.bottom -
              widget.sideOffset,
        PopoverSide.top =>
          anchor.top - widget.sideOffset - widget.collisionPadding,
        PopoverSide.left ||
        PopoverSide.right => viewport.height - widget.collisionPadding * 2,
      },
    );

    // The transform origin is the previous layout's answer; the first frame
    // uses the requested side, which is also the resolved one whenever nothing
    // collides.
    final Alignment origin =
        _placement?.origin ??
        // [PopoverAnchorMode.selfCenter] does not depend on the placement at
        // all, so it is right from the first frame rather than from the second.
        (widget.origin == PopoverAnchorMode.selfCenter
            ? Alignment.center
            : switch (widget.side) {
                PopoverSide.bottom => Alignment(_alignAxis, -1),
                PopoverSide.top => Alignment(_alignAxis, 1),
                PopoverSide.right => Alignment(-1, _alignAxis),
                PopoverSide.left => Alignment(1, _alignAxis),
              });
    final PopoverSide side = _placement?.side ?? widget.side;

    return Stack(
      // The theatre hands an overlay child loose constraints; without this the
      // stack would collapse around children that are all positioned.
      fit: StackFit.expand,
      children: <Widget>[
        // Radix renders no scrim; a pointer anywhere else dismisses. How much
        // of that pointer the layer keeps is [PopoverBarrier]'s subject: a
        // modal layer swallows it, a non-modal one lets it through to whatever
        // it landed on, and a submenu lays no layer at all.
        if (widget.barrier != PopoverBarrier.none)
          Positioned.fill(
            child: GestureDetector(
              behavior: widget.barrier == PopoverBarrier.modal
                  ? HitTestBehavior.opaque
                  : HitTestBehavior.translucent,
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
              origin: widget.origin,
              onPlaced: _report,
            ),
            child: _animate(
              origin: origin,
              // `data-[side=bottom]:slide-in-from-top-2`, and its three
              // siblings on a menu. The travel is towards the trigger, so the
              // resolved side names the axis and the sign.
              slide: widget.slideSides.contains(side) ? side : null,
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
    required PopoverSide? slide,
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
    PopoverAlign.start => -1,
    PopoverAlign.center => 0,
    PopoverAlign.end => 1,
  };

  @override
  Widget build(BuildContext context) {
    // The popup is built from this build scope, so a list that narrows on a
    // keystroke narrows in the same frame the keystroke was handled in.
    return flutter.OverlayPortal(
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
    required this.origin,
    required this.onPlaced,
  });

  final Rect anchor;
  final PopoverSide side;
  final PopoverAlign align;
  final double sideOffset;
  final double collisionPadding;
  final PopoverAnchorMode origin;
  final ValueChanged<PopoverPlacement> onPlaced;

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
    final PopoverPlacement placement = popoverPlacement(
      anchor: anchor,
      content: childSize,
      viewport: size,
      side: side,
      align: align,
      sideOffset: sideOffset,
      collisionPadding: collisionPadding,
      origin: origin,
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
      old.collisionPadding != collisionPadding ||
      old.origin != origin;
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

  /// The resolved side, when its entrance carries a `slide-in-from-*`; null
  /// when the class list writes none for that side.
  final PopoverSide? slide;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // `slide-in-from-*-2` — 2 spacing units of travel, and the exit has no
    // twin, so the offset is pinned to the forward run.
    final double travel = space(2);
    // The popup starts displaced **away** from the trigger's side and closes
    // the gap: `side=bottom` writes `slide-in-from-top`, `side=right` writes
    // `slide-in-from-left`.
    final Offset unit = switch (slide) {
      null => Offset.zero,
      PopoverSide.bottom => const Offset(0, -1),
      PopoverSide.top => const Offset(0, 1),
      PopoverSide.right => const Offset(-1, 0),
      PopoverSide.left => const Offset(1, 0),
    };
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (BuildContext context, Widget? child) {
        final double t = MotionCurves.enter.transform(
          animation.value.clamp(0, 1),
        );
        final bool entering = animation.status != AnimationStatus.reverse;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: entering ? unit * (travel * (1 - t)) : Offset.zero,
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
