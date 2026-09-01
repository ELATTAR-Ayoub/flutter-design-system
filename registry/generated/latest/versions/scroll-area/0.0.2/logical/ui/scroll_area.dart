/// `components/ui/scroll-area.tsx` — the browser rail replaced by a composed
/// one.
///
/// ```tsx
/// <ScrollAreaPrimitive.Root data-slot="scroll-area" className={cn("relative", className)}>
///   <ScrollAreaPrimitive.Viewport className="size-full rounded-[inherit] …" >{children}</ScrollAreaPrimitive.Viewport>
///   <ScrollBar />
///   <ScrollAreaPrimitive.Corner />
/// </ScrollAreaPrimitive.Root>
/// ```
///
/// ## What the probe found that the source does not say
///
/// Driven on `/design-system/components/base/layout` at 1440×900:
///
///  1. **There is no rail at rest.** Radix's `type` defaults to `"hover"`, so
///     `[data-slot="scroll-area-scrollbar"]` is *not in the DOM* until the
///     pointer enters the root — measured absent at rest, `data-state="visible"`
///     within one frame of `pointerenter`, and gone again between 542ms and
///     650ms after `pointerleave` (Radix's `scrollHideDelay`, 600ms). It
///     mounts and unmounts; nothing fades. [_hideDelay].
///  2. **The viewport's overflow is per axis, and it is `hidden` on any axis
///     that has no `ScrollBar`.** Measured inline style: `overflow: hidden
///     scroll`. The wrapper above renders exactly one `ScrollBar`, the vertical
///     one, so **a horizontal rail only exists if the caller adds it** — which
///     the API table on the page says in as many words (*"Add ScrollBar for a
///     horizontal bar"*) and the page's own horizontal specimen then does not
///     do. That specimen's 764px of cards sit in a 480px viewport with
///     `overflow-x: hidden`: 284px are clipped and no gesture reaches them.
///     [horizontalBar] is that switch, and it is `false` by default because
///     the wrapper's own default is one vertical bar.
///  3. **The rail is a 10px lane, the thumb is 7px of it.** `w-2.5` = 10, less
///     `border-l` 1px (transparent) and `p-px` 1px on each side. Measured bar
///     10 × 254 at the viewport's right edge; thumb 7 wide, 1px in from the
///     bar's own left padding.
///  4. **Thumb length and travel are the textbook ratios**, confirmed to
///     0.001px: `thumbLength = track × viewport ÷ content` (254/622 × 252 =
///     102.90675) and `thumbTop = scrolled ÷ scrollable × (track − thumb)`
///     (120/368 × 149.093 = 48.617).
///  5. **Dragging the thumb is proportional and clicking the track centres the
///     thumb on the pointer** — a 50px thumb drag moved the viewport 123px
///     against a computed 123.41, and a click near the track's foot went
///     straight to the 368px maximum.
///
/// ## `min-width: 100%; display: table`
///
/// Radix wraps the children in a box carrying exactly that pair, which is one
/// statement in two halves: **shrink-wrap the content**, and **never below the
/// viewport's width**. [_Viewport] is the same pair — [IntrinsicWidth] for the
/// table box, a [BoxConstraints.minWidth] floor for the percentage — and it is
/// what lets one component serve both of the page's specimens: the row list
/// takes the viewport's 480 and justifies against it, while the card rail sizes
/// to its own 764 and overflows.
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
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
import 'package:flutter/widgets.dart' as flutter show ScrollPosition;

import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/theme_scope.dart';

/// `w-2.5` — the rail's lane.
/// When a rail is on screen.
///
/// Radix's `<ScrollArea type>`, reduced to the two values this port actually
/// uses. `hover` is the reference's own default and the one a reading surface
/// wants: the rail is a pointer affordance, and a rail that is always there is
/// a permanent 10px stripe down the side of the text.
///
/// `always` exists because a specimen has the opposite problem. A rail nobody
/// can see is a rail nobody can review, and a documentation page whose whole
/// subject is the scrollbar cannot demonstrate it only on hover.
enum ScrollBarVisibility {
  /// Visible while the pointer is over the area, then faded out. The default.
  hover,

  /// Visible whenever the axis has somewhere to scroll to.
  always,
}

double get _railWidth => space(2.5);

/// `p-px` on the bar, plus its 1px transparent `border-l`: the thumb sits
/// 2px in from the lane's leading edge and 1px in from every other one.
const double _railPadding = BorderWidths.hairline;

/// Radix's own floor on the thumb, in pixels — not a token, and not stated
/// anywhere in the reference's source.
// allow-hardcoded: a third-party library's constant, with no token to read it
// from.
const double _minThumbLength = 18;

/// The key on [_Rail]'s [ExcludeSemantics] wrap — public so a test can find
/// this exact node rather than any platform-injected scrollbar's own.
@visibleForTesting
const Key thumbSemanticsKey = ValueKey<String>(
  'scrollAreaThumbExcludeSemantics',
);

/// `scrollHideDelay`, Radix's default. Measured between 542ms and 650ms.
///
/// Not a motion token: `globals.css` never names it, and nothing else in the
/// system waits this long. It is a third-party library's own constant.
const Duration _hideDelay = Duration(
  milliseconds: 600, // allow-hardcoded: Radix's own `scrollHideDelay`.
);

/// A styled scroll container: the reference's `ScrollArea`.
///
/// The caller supplies the frame (border, radius, height) exactly as the
/// reference puts it on `className`; [borderRadius] is `rounded-[inherit]`,
/// which is what the viewport clips its content to.
///
/// TARGET SIZING — the platform decision, made explicit: **the scrollbar
/// thumb is pointer-only.** [_Rail] never mounts until [MouseRegion.onEnter]
/// fires, and touch has no hover event — Radix's own `type="hover"` default,
/// reproduced — so on a touch device the thumb is never in the tree at all,
/// let alone a tap target that would need [TouchTargets.minimum]. Growing it
/// to 44px anyway would mean either enlarging a 10px rail that exists to stay
/// out of the reading column's way, or layering an invisible hit box a
/// hovering mouse would never ask for. Neither answers a real need: the
/// [_Viewport] underneath is a plain [SingleChildScrollView], which already
/// scrolls by touch drag and, once focused, by the platform's own keyboard
/// scrolling — both paths reach every pixel the thumb can reach, without the
/// thumb. So the thumb stays a mouse/trackpad convenience — a visual position
/// indicator with a pointer-drag shortcut — and [_Rail] wraps it in
/// [ExcludeSemantics] so a screen reader is never told to tap a control nothing
/// but a mouse can reliably hit. [test/target_sizing_test.dart] and
/// `test/scroll_area_platform_test.dart` hold this contract: the scrollable
/// scrolls by drag and by keyboard with the thumb never shown, and the thumb
/// carries no semantics once it is.
class ScrollArea extends StatefulWidget {
  const ScrollArea({
    super.key,
    this.borderRadius,
    this.horizontalBar = false,
    this.barVisibility = ScrollBarVisibility.hover,
    this.controller,
    required this.child,
  });

  /// `rounded-[inherit]` on the viewport — the frame's own inner corner.
  final BorderRadius? borderRadius;

  /// `<ScrollBar orientation="horizontal" />`, which the wrapper does not
  /// render for you. Without it the horizontal axis is `overflow-x: hidden`.
  final bool horizontalBar;

  /// When the rails are on screen. See [ScrollBarVisibility]; `hover` is the
  /// reference's default and the one every reading surface in this system
  /// uses.
  final ScrollBarVisibility barVisibility;

  /// Drives the vertical axis from outside; otherwise one is made here.
  final ScrollController? controller;

  final Widget child;

  @override
  State<ScrollArea> createState() => _ScrollAreaState();
}

class _ScrollAreaState extends State<ScrollArea> {
  ScrollController? _owned;
  late final ScrollController _horizontal = ScrollController();
  bool _hovered = false;

  /// Whether a rail should paint right now.
  ///
  /// `always` does not mean "paint a rail on a box with nothing to scroll":
  /// each [_Rail] already returns nothing when its own axis has no travel, so
  /// this only decides whether hover is required on top of that.
  bool get _visible =>
      widget.barVisibility == ScrollBarVisibility.always || _hovered;

  ScrollController get _vertical =>
      widget.controller ?? (_owned ??= ScrollController());

  @override
  void dispose() {
    _owned?.dispose();
    _horizontal.dispose();
    super.dispose();
  }

  /// Which hide is pending. Radix's `clearTimeout` on `pointerenter`, said in
  /// the vocabulary a `Future.delayed` has: a re-entry inside the 600ms bumps
  /// the generation and the older timer finds itself stale.
  int _generation = 0;

  /// `pointerenter` clears the pending hide and shows in the same frame.
  void _show() {
    _generation++;
    if (_hovered) return;
    setState(() => _hovered = true);
  }

  /// `pointerleave` starts `scrollHideDelay`. The rail unmounts when it fires
  /// — there is no fade to run, so the timer is the whole animation.
  void _scheduleHide() {
    final int mine = ++_generation;
    Future<void>.delayed(_hideDelay, () {
      if (!mounted || mine != _generation) return;
      setState(() => _hovered = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return MouseRegion(
      onEnter: (_) => _show(),
      onExit: (_) => _scheduleHide(),
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        child: Stack(
          children: <Widget>[
            _Viewport(
              vertical: _vertical,
              horizontal: _horizontal,
              horizontalBar: widget.horizontalBar,
              child: widget.child,
            ),
            if (_visible)
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                width: _railWidth,
                child: _Rail(controller: _vertical, colour: theme.border),
              ),
            // `<ScrollBar orientation="horizontal" />`. Only when the axis was
            // asked for: with `horizontalBar` false the axis does not scroll at
            // all, so a rail would report travel that does not exist.
            if (_visible && widget.horizontalBar)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: _railWidth,
                child: _Rail(
                  controller: _horizontal,
                  colour: theme.border,
                  axis: Axis.horizontal,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// `data-slot="scroll-area-viewport"` and the `min-width:100%; display:table`
/// box Radix puts inside it.
class _Viewport extends StatelessWidget {
  const _Viewport({
    required this.vertical,
    required this.horizontal,
    required this.horizontalBar,
    required this.child,
  });

  final ScrollController vertical;
  final ScrollController horizontal;
  final bool horizontalBar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // `display: table` — shrink-wrap the content.
    //
    // Deliberately not a `LayoutBuilder`, which cannot answer an intrinsic
    // query — and a `ScrollArea` inside a `Grid` is asked for one, because
    // the grid gives every cell in a row the tallest cell's height.
    final Widget table = IntrinsicWidth(child: child);

    // `size-full` on the viewport, and the `min-width: 100%` the table box
    // reads off it. A [Stack] hands its non-positioned children **loose**
    // constraints, so without this the scroll view shrink-wraps to its
    // content and there is no 100% to be a minimum of: measured at 154.4
    // against a 660px frame, with the whole subtree dropping out of the hit
    // path because nothing under it reached the pointer any more. With the
    // floor in place the scroll view is tight, and `widthConstraints()` hands
    // that same tight width down to the table.
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: SingleChildScrollView(
        controller: vertical,
        child: horizontalBar
            // `<ScrollBar orientation="horizontal" />`: the axis really scrolls,
            // and the width floor goes with it, exactly as `overflow-x: scroll`
            // drops `min-width: 100%`'s hold on a wider table.
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: horizontal,
                child: table,
              )
            // `overflow-x: hidden` — laid out at its natural width, clipped, and
            // unreachable by any gesture. The reference's card rail, faithfully.
            : ClipRect(
                child: OverflowBox(
                  alignment: Alignment.topLeft,
                  fit: OverflowBoxFit.deferToChild,
                  maxWidth: double.infinity,
                  child: table,
                ),
              ),
      ),
    );
  }
}

/// `data-slot="scroll-area-scrollbar"` plus its thumb.
class _Rail extends StatefulWidget {
  const _Rail({
    required this.controller,
    required this.colour,
    this.axis = Axis.vertical,
  });

  final ScrollController controller;
  final Color colour;

  /// Which axis this rail reports. Radix renders a `<ScrollBar>` per axis and
  /// the two are the same component turned ninety degrees, so this is one
  /// widget with an axis rather than two that would drift apart.
  final Axis axis;

  @override
  State<_Rail> createState() => _RailState();
}

class _RailState extends State<_Rail> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() => setState(() {});

  /// `thumbLength = track × viewport ÷ content`, floored at [_minThumbLength].
  double _thumbLength(double track, flutter.ScrollPosition position) {
    final double content =
        position.viewportDimension + position.maxScrollExtent;
    if (content <= 0) return track;
    final double ratio = position.viewportDimension / content;
    return (track * ratio).clamp(_minThumbLength, track);
  }

  void _jumpTo(double pixels, flutter.ScrollPosition position) {
    widget.controller.jumpTo(
      pixels.clamp(position.minScrollExtent, position.maxScrollExtent),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.hasClients) return const SizedBox.shrink();
    final flutter.ScrollPosition position = widget.controller.position;
    // `hasContentDimensions` before `maxScrollExtent`, which throws until the
    // viewport has applied its dimensions. Hover never reached this on the
    // first frame because a pointer cannot be inside a box that has not been
    // laid out yet; [ScrollBarVisibility.always] builds the rail immediately
    // and does.
    if (!position.hasContentDimensions) return const SizedBox.shrink();
    if (position.maxScrollExtent <= 0) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool vertical = widget.axis == Axis.vertical;
        // `p-px` at both ends of whichever axis this is.
        final double extent = vertical
            ? constraints.maxHeight
            : constraints.maxWidth;
        final double track = extent - _railPadding * 2;
        final double thumb = _thumbLength(track, position);
        final double travel = track - thumb;
        final double fraction = position.maxScrollExtent <= 0
            ? 0
            : (position.pixels / position.maxScrollExtent).clamp(0.0, 1.0);

        void toThumbCentre(double local) {
          final double top = (local - _railPadding - thumb / 2).clamp(
            0,
            travel,
          );
          _jumpTo(
            travel <= 0 ? 0 : top / travel * position.maxScrollExtent,
            position,
          );
        }

        // TARGET SIZING: pointer-only, per the decision on [ScrollArea] —
        // excluded from the semantics tree so a screen reader never offers a
        // control a touch or keyboard user cannot reliably operate. The
        // viewport it sits over remains fully reachable by drag and by
        // keyboard on its own. Keyed so a test can find this exact node
        // without also matching a platform-injected `Scrollbar`'s own
        // `ExcludeSemantics` — desktop `ScrollBehavior`s wrap every
        // `Scrollable` in one automatically, this widget's own thumb
        // notwithstanding.
        return ExcludeSemantics(
          key: thumbSemanticsKey,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            // A click anywhere on the track centres the thumb on the pointer —
            // measured going straight to the maximum from a click near the foot.
            onTapDown: (TapDownDetails d) => toThumbCentre(
              vertical ? d.localPosition.dy : d.localPosition.dx,
            ),
            onVerticalDragUpdate: vertical
                ? (DragUpdateDetails d) {
                    if (travel <= 0) return;
                    _jumpTo(
                      position.pixels +
                          d.delta.dy / travel * position.maxScrollExtent,
                      position,
                    );
                  }
                : null,
            onHorizontalDragUpdate: vertical
                ? null
                : (DragUpdateDetails d) {
                    if (travel <= 0) return;
                    _jumpTo(
                      position.pixels +
                          d.delta.dx / travel * position.maxScrollExtent,
                      position,
                    );
                  },
            child: Stack(
              children: <Widget>[
                Positioned(
                  // 1px of transparent border on the rail's own leading edge
                  // and 1px of `p-px`, on whichever axis is the cross one.
                  top: vertical
                      ? _railPadding + fraction * travel
                      : _railPadding * 2,
                  bottom: vertical ? null : _railPadding,
                  left: vertical
                      ? _railPadding * 2
                      : _railPadding + fraction * travel,
                  right: vertical ? _railPadding : null,
                  height: vertical ? thumb : null,
                  width: vertical ? null : thumb,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: widget.colour,
                      borderRadius: BorderRadius.circular(Radii.full),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// The wheel/trackpad behaviour a nested scroll view needs so a gesture that
/// starts inside a [ScrollArea] does not also move the page.
///
/// Exposed because the two specimens on the layout page sit inside the docs
/// shell's own scroll view, and Flutter's default is to hand the overscroll on
/// to the parent.
class ScrollAreaBehavior extends ScrollBehavior {
  const ScrollAreaBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;

  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}
