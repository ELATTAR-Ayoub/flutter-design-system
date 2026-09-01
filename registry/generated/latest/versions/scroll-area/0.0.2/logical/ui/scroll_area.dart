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
double get _railWidth => space(2.5);

/// `p-px` on the bar, plus its 1px transparent `border-l`: the thumb sits
/// 2px in from the lane's leading edge and 1px in from every other one.
const double _railPadding = BorderWidths.hairline;

/// Radix's own floor on the thumb, in pixels — not a token, and not stated
/// anywhere in the reference's source.
// allow-hardcoded: a third-party library's constant, with no token to read it
// from.
const double _minThumbLength = 18;

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
class ScrollArea extends StatefulWidget {
  const ScrollArea({
    super.key,
    this.borderRadius,
    this.horizontalBar = false,
    this.controller,
    required this.child,
  });

  /// `rounded-[inherit]` on the viewport — the frame's own inner corner.
  final BorderRadius? borderRadius;

  /// `<ScrollBar orientation="horizontal" />`, which the wrapper does not
  /// render for you. Without it the horizontal axis is `overflow-x: hidden`.
  final bool horizontalBar;

  /// Drives the vertical axis from outside; otherwise one is made here.
  final ScrollController? controller;

  final Widget child;

  @override
  State<ScrollArea> createState() => _ScrollAreaState();
}

class _ScrollAreaState extends State<ScrollArea> {
  ScrollController? _owned;
  late final ScrollController _horizontal = ScrollController();
  bool _visible = false;

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
    if (_visible) return;
    setState(() => _visible = true);
  }

  /// `pointerleave` starts `scrollHideDelay`. The rail unmounts when it fires
  /// — there is no fade to run, so the timer is the whole animation.
  void _scheduleHide() {
    final int mine = ++_generation;
    Future<void>.delayed(_hideDelay, () {
      if (!mounted || mine != _generation) return;
      setState(() => _visible = false);
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
  const _Rail({required this.controller, required this.colour});

  final ScrollController controller;
  final Color colour;

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
    if (position.maxScrollExtent <= 0) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // `p-px` top and bottom.
        final double track = constraints.maxHeight - _railPadding * 2;
        final double thumb = _thumbLength(track, position);
        final double travel = track - thumb;
        final double fraction = position.maxScrollExtent <= 0
            ? 0
            : (position.pixels / position.maxScrollExtent).clamp(0.0, 1.0);

        void toThumbCentre(double localY) {
          final double top = (localY - _railPadding - thumb / 2).clamp(
            0,
            travel,
          );
          _jumpTo(
            travel <= 0 ? 0 : top / travel * position.maxScrollExtent,
            position,
          );
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          // A click anywhere on the track centres the thumb on the pointer —
          // measured going straight to the maximum from a click near the foot.
          onTapDown: (TapDownDetails d) => toThumbCentre(d.localPosition.dy),
          onVerticalDragUpdate: (DragUpdateDetails d) {
            if (travel <= 0) return;
            _jumpTo(
              position.pixels + d.delta.dy / travel * position.maxScrollExtent,
              position,
            );
          },
          child: Stack(
            children: <Widget>[
              Positioned(
                top: _railPadding + fraction * travel,
                // 1px of transparent `border-l` and 1px of `p-px`.
                left: _railPadding * 2,
                right: _railPadding,
                height: thumb,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: widget.colour,
                    borderRadius: BorderRadius.circular(Radii.full),
                  ),
                ),
              ),
            ],
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
