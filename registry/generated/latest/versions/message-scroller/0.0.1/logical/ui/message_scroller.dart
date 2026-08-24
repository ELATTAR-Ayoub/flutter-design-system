/// `components/ui/message-scroller.tsx` — a transcript viewport that manages
/// its own scroll.
///
/// From `@shadcn/react`, not Radix: a provider, a viewport, per-item message
/// ids, a scroll anchor, and a button that hides itself once that direction has
/// nowhere left to go.
///
/// ## Measured on the live reference
///
/// Sampled at 1440×900 on 2026-08-16 with the scroller scrolled into the
/// browser viewport (`scratchpad/ba2-chat-scroll.js`). Everything below is a
/// number the page reports, not a class read.
///
/// | fact | measured |
/// |---|---|
/// | root | `relative flex size-full min-h-0 flex-col overflow-hidden` — 1078 × 320 |
/// | viewport | the scrolling box; **10px of scrollbar gutter**, so the content column is 1068 |
/// | content | `p-6 gap-6 h-max min-h-full` — 718.38 tall over eleven 39.13px items |
/// | item | `min-w-0 shrink-0`, 1020 wide |
/// | button | 32px, pill, absolute `bottom-4` and centred, `--background` fill on a `--border` hairline |
///
/// ## `scroll-fade-b` is scroll-driven, and the port drives it the same way
///
/// The viewport wears `scroll-fade-b` from `shadcn/tailwind.css` — **not**
/// `globals.css`, which is the whole subject of the page's own Note. It is a
/// mask plus a **scroll-timeline animation**:
///
/// * the mask is `linear-gradient(#000 0, #000 calc(100% - F), transparent
///   100%)` where the full fade is `min(12%, 40px)` of the viewport height —
///   **38.4px** at this specimen's 320;
/// * `animation-range: calc(100% - 96px) 100%` on `scroll(self y)` with
///   `animation-fill-mode: both` shrinks `F` from full to zero across the last
///   **96px** of travel, on the CSS `ease-in-out` keyword
///   ([ElCurves.cssEaseInOut], *not* `--ease-in-out`).
///
/// So the fade is at full height for the first 302 of this specimen's 398px of
/// travel and closes over the last 96. [ElScrollFade] reproduces exactly that,
/// and the three sampled factors (0.3588 / 0.1292 / 0.0561 at 58.3% / 75% /
/// 87.5% of the range) are what the package test pins.
///
/// ## The button's declared transition loses — measured
///
/// `message-scroller.tsx` L109 asks for
/// `transition-[translate,scale,opacity] duration-base`. The computed value is
/// `transform, background-color, border-color, color, box-shadow, opacity` —
/// `Button`'s own list, which tailwind-merge keeps because both classes land in
/// the same group. **`translate` and `scale` are therefore not in the
/// transition list and snap**, and only `opacity` animates. Traced:
///
/// | leg | measured |
/// |---|---|
/// | hide | `scale 1 → 0.95` and `translate-y-0 → 100%` cut in one frame; opacity 1 → 0 over **250ms** on [ElCurves.curveIn] (`data-[active=false]:ease-in`) |
/// | show | the same two cut back; opacity 0 → 1 over **250ms** on [ElCurves.out] |
///
/// `duration-base` and `duration-slow` on that same class list are both
/// `duration-<word>` no-ops — the corpus-wide finding — and the measurement
/// agrees: 250ms, the stylesheet default, on both legs.
///
/// ## `content-visibility: auto` — recorded, not reproduced
///
/// `MessageScrollerItem` carries `[content-visibility:auto]` and
/// `[contain-intrinsic-size:auto_calc(var(--spacing)*40)]`. Probed both ways:
/// with the scroller **off** the browser viewport every one of the eleven items
/// reports the placeholder **160px** and the content box is 2048 tall; with it
/// **on** screen they report their real 39.13 and the box is 718.38. It is a
/// paint optimisation with a visible failure mode (a wrong guess makes the
/// scrollbar jump), and the reader only ever sees the second state. Flutter has
/// no off-screen skip with a remembered size, so the port renders the second
/// state always. Neither number reaches the page's height: the panel body is a
/// fixed `h-80`.
library;

import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../theme_scope.dart';
import 'button.dart';
import 'icon.dart';
import 'icon_paths.g.dart';

/// `defaultScrollPosition` — where the viewport rests on first paint.
enum ElScrollPosition {
  /// The top. What the chat page passes, so both the fade and the button are
  /// visible without touching anything.
  start,

  /// The bottom. The provider's own default.
  end,

  /// The item marked [ElMessageScrollerItem.scrollAnchor], falling back to
  /// [end] when there is none.
  lastAnchor,
}

/// Which edge a [ElMessageScrollerButton] travels to.
enum ElScrollDirection {
  /// Up, to the oldest message.
  start,

  /// Down, to the newest — the default.
  end,
}

/// `MessageScrollerProvider` — the state the whole family reads.
///
/// Owned by whatever mounts the scroller, exactly as the reference's provider
/// is mounted above its own tree.
class ElMessageScrollerController extends ChangeNotifier {
  ElMessageScrollerController({
    this.autoScroll = false,
    this.defaultScrollPosition = ElScrollPosition.end,
    double? scrollEdgeThreshold,
  }) : scrollEdgeThreshold = scrollEdgeThreshold ?? defaultEdgeThreshold {
    scroll.addListener(_onScroll);
  }

  /// `scrollEdgeThreshold` — *"the px tolerance for counting as at an edge"*,
  /// default **8**.
  ///
  /// Measured as a `>=`: at 8px from the end the button is still
  /// `data-active="true"`, at 4px it is false.
  static const double defaultEdgeThreshold = 8;

  /// `autoScroll` — follow new content while already at the end.
  final bool autoScroll;

  final ElScrollPosition defaultScrollPosition;

  final double scrollEdgeThreshold;

  /// The viewport's own controller. Public because the viewport attaches it and
  /// a test drives it.
  final ScrollController scroll = ScrollController();

  /// `data-autoscrolling` — set for as long as a programmatic scroll is
  /// running, and what hides the scrollbar thumb and track while it does.
  bool get autoscrolling => _autoscrolling;
  bool _autoscrolling = false;

  /// The offsets of every registered [ElMessageScrollerItem], by message id.
  final Map<String, double> _anchors = <String, double>{};

  /// Whether the viewport can still travel toward [direction].
  ///
  /// `useMessageScrollerScrollable`. False is what stamps
  /// `data-active="false"` on a button and takes it off the screen.
  bool scrollable(ElScrollDirection direction) {
    if (!scroll.hasClients) return direction == ElScrollDirection.end;
    final ScrollPosition p = scroll.position;
    return switch (direction) {
      ElScrollDirection.start =>
        p.pixels - p.minScrollExtent >= scrollEdgeThreshold,
      ElScrollDirection.end =>
        p.maxScrollExtent - p.pixels >= scrollEdgeThreshold,
    };
  }

  /// How far the viewport has scrolled, in px. 0 before it has clients.
  double get offset => scroll.hasClients ? scroll.position.pixels : 0;

  /// The travel the viewport has, in px.
  double get maxOffset => scroll.hasClients
      ? scroll.position.maxScrollExtent - scroll.position.minScrollExtent
      : 0;

  void _onScroll() => notifyListeners();

  /// Records where an item sits, so [scrollToMessage] can find it.
  void registerAnchor(String id, double offset) {
    if (_anchors[id] == offset) return;
    _anchors[id] = offset;
  }

  /// Where the item carrying `scrollAnchor` sits — the resting point
  /// [ElScrollPosition.lastAnchor] restores to.
  double? scrollAnchorOffset;

  /// Records it. Last writer wins, which is what *"last anchor"* means.
  void registerScrollAnchor(double offset) => scrollAnchorOffset = offset;

  /// `scrollToEnd()` — the smooth jump the button performs.
  Future<void> scrollToEnd() => _smoothTo(scroll.position.maxScrollExtent);

  /// `scrollToStart()`.
  Future<void> scrollToStart() => _smoothTo(scroll.position.minScrollExtent);

  /// `scrollToMessage(id)` — the reason a product would reach for this
  /// component at all, per the page's own §5.
  Future<void> scrollToMessage(String id) {
    final double? at = _anchors[id];
    if (at == null) return Future<void>.value();
    return _smoothTo(
      at.clamp(
        scroll.position.minScrollExtent,
        scroll.position.maxScrollExtent,
      ),
    );
  }

  /// The port of `scrollTo({behavior: "smooth"})`.
  ///
  /// Chrome, not the stylesheet, owns this timing. Measured
  /// (`ba2-chat-inter.js`): 100px settles in ~168ms, 398px in ~335ms — `√d` to
  /// within a frame, so the duration is [ElDurations.frame] × `√distance` and
  /// the shape is [ElCurves.cssEase].
  ///
  /// **Residual, recorded:** the fitted curve tracks the samples at the two
  /// ends and runs up to ~9% of the travel *behind* Chrome through the middle
  /// of the 398px jump (measured 0.764 of the distance at 45% of the window
  /// against this curve's ~0.68). Chrome's own animator is not a public curve;
  /// pinning the duration law and the family is as close as a transcript gets.
  Future<void> _smoothTo(double target) async {
    if (!scroll.hasClients) return;
    final double distance = (target - scroll.position.pixels).abs();
    if (distance == 0) return;
    _autoscrolling = true;
    notifyListeners();
    await scroll.position.animateTo(
      target,
      duration: ElDurations.frame * math.sqrt(distance),
      curve: ElCurves.cssEase,
    );
    _autoscrolling = false;
    notifyListeners();
  }

  /// `autoScroll` — called by the content when a new item arrives.
  void followNewContent() {
    if (!autoScroll || !scroll.hasClients) return;
    if (!scrollable(ElScrollDirection.end)) {
      scroll.jumpTo(scroll.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}

/// Publishes a [ElMessageScrollerController] to the subtree — the port of
/// `MessageScrollerProvider`.
class ElMessageScrollerProvider
    extends InheritedNotifier<ElMessageScrollerController> {
  const ElMessageScrollerProvider({
    super.key,
    required ElMessageScrollerController controller,
    required super.child,
  }) : super(notifier: controller);

  static ElMessageScrollerController of(BuildContext context) {
    final ElMessageScrollerProvider? found = context
        .dependOnInheritedWidgetOfExactType<ElMessageScrollerProvider>();
    assert(found != null, 'No ElMessageScrollerProvider above this widget.');
    return found!.notifier!;
  }
}

/// `MessageScroller` — the positioned frame.
///
/// `relative flex size-full min-h-0 flex-col overflow-hidden`: everything else
/// nests inside it, and the button is absolute against it.
class ElMessageScroller extends StatelessWidget {
  const ElMessageScroller({super.key, required this.viewport, this.button});

  final Widget viewport;

  /// [ElMessageScrollerButton], absolutely positioned against this frame.
  final Widget? button;

  @override
  Widget build(BuildContext context) => ClipRect(
    child: Stack(fit: StackFit.expand, children: <Widget>[viewport, ?button]),
  );
}

/// `MessageScrollerViewport` — the element that actually scrolls.
///
/// Carries `scroll-fade-b` for the bottom mask, a **stable scrollbar gutter**
/// so the column does not shift when the bar appears, and hides its own thumb
/// while an autoscroll is running.
class ElMessageScrollerViewport extends StatefulWidget {
  const ElMessageScrollerViewport({
    super.key,
    required this.child,
    this.semanticsLabel = 'Messages',
  });

  /// `scrollbar-gutter: stable` under `scrollbar-width: thin` — measured as a
  /// **10px** reservation: the 1078px viewport hands its content 1068.
  static const double gutter = 10;

  /// What `scrollbar-width: thin` actually paints: an 8px track with a pill
  /// thumb in `--border` (globals.css L2831–2851).
  static double get thumbThickness => el(2);

  /// `role="region" aria-label="Messages"` on the live element.
  final String semanticsLabel;

  final Widget child;

  @override
  State<ElMessageScrollerViewport> createState() =>
      _ElMessageScrollerViewportState();
}

class _ElMessageScrollerViewportState extends State<ElMessageScrollerViewport> {
  bool _restored = false;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final ElMessageScrollerController c = ElMessageScrollerProvider.of(context);

    // `defaultScrollPosition` — applied once, after the first layout, which is
    // where the provider's effect runs on the web too.
    if (!_restored) {
      _restored = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !c.scroll.hasClients) return;
        switch (c.defaultScrollPosition) {
          case ElScrollPosition.start:
            c.scroll.jumpTo(c.scroll.position.minScrollExtent);
          case ElScrollPosition.end:
            c.scroll.jumpTo(c.scroll.position.maxScrollExtent);
          case ElScrollPosition.lastAnchor:
            // *"last-anchor"*, falling back to the end when nothing carries
            // `scrollAnchor` — which is every item on this page.
            c.scroll.jumpTo(
              (c.scrollAnchorOffset ?? c.scroll.position.maxScrollExtent).clamp(
                c.scroll.position.minScrollExtent,
                c.scroll.position.maxScrollExtent,
              ),
            );
        }
      });
    }

    Widget scroller = ScrollConfiguration(
      // `overscroll-contain` plus the browser's own non-bouncing overscroll.
      behavior: const _ViewportScrollBehavior(),
      child: SingleChildScrollView(
        controller: c.scroll,
        physics: const ClampingScrollPhysics(),
        child: Padding(
          // `scrollbar-gutter: stable` — the reservation is *inside* the
          // viewport, so the content column starts 10px narrower and does not
          // move when the bar shows up.
          padding: const EdgeInsetsDirectional.only(
            end: ElMessageScrollerViewport.gutter,
          ),
          child: widget.child,
        ),
      ),
    );

    scroller = RawScrollbar(
      controller: c.scroll,
      // `data-autoscrolling:scrollbar-thumb-transparent` — measured going
      // fully transparent for the length of a programmatic scroll.
      thumbColor: c.autoscrolling ? elTransparent : theme.border,
      thickness: ElMessageScrollerViewport.thumbThickness,
      radius: Radius.circular(ElRadii.pill),
      thumbVisibility: true,
      child: scroller,
    );

    return Semantics(
      container: true,
      label: widget.semanticsLabel,
      child: ElScrollFade(controller: c, child: scroller),
    );
  }
}

/// Blocks the glow overscroll and lets a trackpad drive the viewport.
class _ViewportScrollBehavior extends ScrollBehavior {
  const _ViewportScrollBehavior();

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

/// `scroll-fade-b` — the bottom mask, driven by the scroll offset.
///
/// See the library note for the derivation. The mask is a straight vertical
/// [LinearGradient] applied with [BlendMode.dstIn]: one gradient, one blend, no
/// combined path and nothing blurred.
class ElScrollFade extends StatelessWidget {
  const ElScrollFade({
    super.key,
    required this.controller,
    required this.child,
  });

  /// `min(12%, calc(var(--spacing) * 10))` — the full fade height.
  static const double fadeFraction = 0.12;
  static double get fadeCap => el(10);

  /// `--scroll-fade-reveal: calc(var(--spacing) * 24)` — the travel the fade
  /// closes over.
  static double get reveal => el(24);

  final ElMessageScrollerController controller;
  final Widget child;

  /// The fade's painted height for a viewport [height] at [offset] of [max].
  ///
  /// `animation-fill-mode: both` is what holds it at full height before the
  /// range opens and at zero after it closes.
  static double fadeFor({
    required double height,
    required double offset,
    required double max,
  }) {
    final double full = math.min(height * fadeFraction, fadeCap);
    if (max <= 0) return full;
    final double start = max - reveal;
    final double t = ((offset - start) / reveal).clamp(0.0, 1.0);
    return full * (1 - ElCurves.cssEaseInOut.transform(t));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double height = constraints.maxHeight;
        if (!height.isFinite || height <= 0) return child;
        final double fade = fadeFor(
          height: height,
          offset: controller.offset,
          max: controller.maxOffset,
        );
        // The mask is mounted even at zero fade. Returning [child] bare there
        // would change the element tree's *shape* the instant the reader
        // reaches the last 96px, and Flutter rebuilds a changed subtree from
        // scratch — which discards the `Scrollable` mid-animation and snaps the
        // viewport back to zero. Measured while chasing exactly that: the
        // smooth scroll reached 396.7 of 397 and then read 0 on the next frame.
        final double stop = (1 - fade / height).clamp(0.0, 1.0);
        return ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (Rect bounds) => LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // A mask stencil, not a colour: `mask-image` reads only the
            // alpha channel, and these are the gradient's own `#000` and
            // `transparent` stops.
            // allow-hardcoded: mask alpha stencil, not a design colour.
            colors: const <Color>[
              Color(0xFF000000), // allow-hardcoded: mask alpha stencil
              Color(0xFF000000), // allow-hardcoded: mask alpha stencil
              Color(0x00000000), // allow-hardcoded: mask alpha stencil
            ],
            stops: <double>[0, stop, 1],
          ).createShader(bounds),
          child: child,
        );
      },
    );
  }
}

/// `MessageScrollerContent` — `flex h-max min-h-full flex-col gap-6`.
class ElMessageScrollerContent extends StatelessWidget {
  const ElMessageScrollerContent({
    super.key,
    required this.children,
    this.padding,
  });

  /// `gap-6` — 24px.
  static double get gap => el(6);

  final List<Widget> children;

  /// The page passes `className="p-6"`; the component itself declares none.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding ?? EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < children.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: gap),
          children[i],
        ],
      ],
    ),
  );
}

/// `MessageScrollerItem` — one turn, addressable.
class ElMessageScrollerItem extends StatefulWidget {
  const ElMessageScrollerItem({
    super.key,
    required this.child,
    this.messageId,
    this.scrollAnchor = false,
  });

  /// `contain-intrinsic-size: auto calc(var(--spacing) * 40)` — the height the
  /// browser assumes for a skipped item. Recorded; see the library note for
  /// why the port does not paint it.
  static double get assumedOffscreenHeight => el(40);

  final Widget child;

  /// `messageId` — what `scrollToMessage` looks the item up by.
  final String? messageId;

  /// `scrollAnchor` — makes this the resting point for
  /// [ElScrollPosition.lastAnchor].
  final bool scrollAnchor;

  @override
  State<ElMessageScrollerItem> createState() => _ElMessageScrollerItemState();
}

class _ElMessageScrollerItemState extends State<ElMessageScrollerItem> {
  @override
  Widget build(BuildContext context) {
    // `messageId` is only useful if something records where the item sat, so
    // the item measures itself once per layout and hands the offset up. That is
    // what makes `scrollToMessage` and `defaultScrollPosition: lastAnchor` real
    // rather than declared.
    if (widget.messageId != null || widget.scrollAnchor) {
      final ElMessageScrollerController c = ElMessageScrollerProvider.of(
        context,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !c.scroll.hasClients) return;
        final RenderObject? box = context.findRenderObject();
        final RenderObject? viewport = c.scroll.position.context.storageContext
            .findRenderObject();
        if (box is! RenderBox || viewport is! RenderBox) return;
        final double dy =
            box.localToGlobal(Offset.zero, ancestor: viewport).dy +
            c.scroll.position.pixels;
        if (widget.messageId != null) c.registerAnchor(widget.messageId!, dy);
        if (widget.scrollAnchor) c.registerScrollAnchor(dy);
      });
    }
    return widget.child;
  }
}

/// `MessageScrollerButton` — `direction start | end`.
///
/// Renders a [ElButton] and hides itself the moment that direction has nowhere
/// left to go. See the library note: only the opacity is animated, because the
/// component's own `transition-[translate,scale,opacity]` loses to `Button`'s
/// list and takes `translate` and `scale` out of it.
class ElMessageScrollerButton extends StatelessWidget {
  const ElMessageScrollerButton({
    super.key,
    this.direction = ElScrollDirection.end,
  });

  /// `data-[direction=end]:bottom-4` / `data-[direction=start]:top-4`.
  static double get inset => el(4);

  /// `data-[active=false]:scale-95`.
  static const double inactiveScale = 0.95;

  final ElScrollDirection direction;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final ElMessageScrollerController c = ElMessageScrollerProvider.of(context);
    final bool active = c.scrollable(direction);
    final double size = ElButton.heightFor(ElButtonSize.iconSm);

    Widget button = ElButton(
      variant: ElButtonVariant.secondary,
      size: ElButtonSize.iconSm,
      // The five class overrides on top of `secondary`, measured:
      // `border-border bg-background text-foreground hover:bg-muted
      // hover:text-foreground`.
      surface: ElButtonSurface(
        fill: theme.background,
        hoverFill: theme.muted,
        border: theme.border,
        ink: theme.foreground,
        hoverInk: theme.foreground,
      ),
      label: direction == ElScrollDirection.end
          ? 'Scroll to end'
          : 'Scroll to start',
      onPressed: active
          ? () => direction == ElScrollDirection.end
                ? c.scrollToEnd()
                : c.scrollToStart()
          : null,
      child: Transform.rotate(
        // `data-[direction=start]:[&_svg]:rotate-180`.
        angle: direction == ElScrollDirection.start ? math.pi : 0,
        child: ElIcon.lucide(
          ElLucide.arrowDown,
          sizePx: ElButton.iconPxFor(ElButtonSize.iconSm),
          tone: ElIconTone.inherit,
        ),
      ),
    );

    // `data-[active=false]:scale-95` and `translate-y-full` — both **snap**,
    // measured in one frame each. `opacity` is the only animated leg.
    button = Transform.translate(
      offset: Offset(
        0,
        active
            ? 0
            : direction == ElScrollDirection.end
            ? size
            : -size,
      ),
      child: Transform.scale(
        scale: active ? 1 : inactiveScale,
        child: AnimatedOpacity(
          opacity: active ? 1 : 0,
          duration: elAnimationDuration(context, ElDurations.transitionDefault),
          // `data-[active=true]:ease-out` / `data-[active=false]:ease-in`.
          curve: active ? ElCurves.out : ElCurves.curveIn,
          child: button,
        ),
      ),
    );

    if (!active) {
      // `data-[active=false]:pointer-events-none`.
      button = IgnorePointer(child: button);
    }

    return Positioned(
      top: direction == ElScrollDirection.start ? inset : null,
      bottom: direction == ElScrollDirection.end ? inset : null,
      left: 0,
      right: 0,
      // `inset-s-1/2 -translate-x-1/2` — centred on the frame.
      child: Align(alignment: Alignment.center, child: button),
    );
  }
}
