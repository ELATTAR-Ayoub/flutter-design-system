/// `components/ui/carousel.tsx` — the shadcn wrapper around Embla, and the one
/// component on the layout page whose behaviour is a third-party physics
/// engine rather than a stylesheet.
///
/// ## What was probed, and what it corrected
///
/// Driven on `/design-system/components/base/layout` at 1440×900 with a rAF
/// sampler (`scratchpad/bl-carousel*.js`, `bl-drag.js`, `bl-edge.js`).
///
///  1. **The arrows are 8px wide.** `CarouselPrevious` is `absolute -left-12`
///     and `CarouselNext` is `absolute -right-12`, so each 32px button hangs
///     48px outside a carousel that starts 24px inside a `Panel` whose frame is
///     `overflow-hidden`. Measured: `elementFromPoint` returns `<main>` at the
///     button's own centre, and returns the button only across
///     **x ∈ [1372, 1379]** — the sliver that survives the clip. The page's own
///     copy says *"Arrows are always visible"*. Six real clicks at the centre
///     moved nothing; a click on the sliver moves it. Reproduced exactly: the
///     buttons are laid out where the class list puts them and the panel clips
///     them, so the port is wrong in the same place and by the same 24px.
///  2. **The travel is an integrator, not a curve.** Sampled frame by frame,
///     the track's translate reproduces
///
///     ```
///     v = (v + (target − location) / 25) × 0.68;   location += v;
///     ```
///
///     at a fixed 1/60s step, to within 0.01px over the first ten frames
///     (measured −9.49 / −25.03 / −44.75 against 9.483 / 25.157 / 44.61).
///     Those are Embla's `duration: 25` and its internal 0.68 friction. There
///     is no easing curve to name and no end time — it asymptotes, and the
///     next click retargets from wherever it is. [_baseDuration], [_friction].
///  3. **Dragging is 1:1 in bounds and rubber-banded out of them.** Held at a
///     known displacement: −40 → −39.95, −100 → −100.0, −200 → −200.0 inside
///     the limits; +40 → 34.15, +100 → 83.75, +200 → 158.76, +400 → 286.65
///     past the start. The second set is not a fixed ratio — it is Embla's
///     `ScrollBounds`, which each frame pulls the target back toward the
///     location by `clamp(distancePastEdge ÷ (viewport × 50%), 0.1, 0.99)`.
///     [_ScrollBounds] is that, with its own constants.
///  4. **Release snaps to the nearest snap point.** −100 returned to 0 and
///     −200 went on to −348.99; both are the nearest, so nothing here needs a
///     velocity projection to explain it.
///  5. **The snap ladder is trimmed.** Six slides of 348.656 in a 1046-wide
///     container give a 1046px scroll extent, so the last three slide starts
///     all clamp to −1046 and collapse into one: **[0, −348.66, −697.31,
///     −1046]**, four stops, and `canScrollNext` goes false on the third click.
///     That is `containScroll: "trimSnaps"`, Embla's default. [_snapsFor].
///  6. **The keyboard path is the one that always worked.** `onKeyDownCapture`
///     on the region handles ArrowLeft/ArrowRight, and it moved the carousel
///     on the first press with the pointer nowhere near the sliver.
///
/// ## Why the arrows need no hit-area expander
///
/// The port's arrows are laid out inside a box that is wide enough to hold
/// them — [DsCarousel] asks for its own horizontal padding and grows its stack
/// outward by the difference — so every render object between the panel's clip
/// and the button contains the sliver, and Flutter's ancestor bounds checks
/// pass on their own. The clip then rejects the other 24px, which is the
/// browser's behaviour exactly. Compare `DsHitArea`, which exists for the
/// opposite case: a target that must answer *outside* every box on its chain.
library;

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../foundation/spacing.dart';
import 'button.dart';
import 'icon.dart';
import 'icon_paths.g.dart';

/// Embla's `duration` option. The wrapper passes only `align`, so this is the
/// library default — and it is a divisor in the integrator, not a time.
const double _baseDuration = 25;

/// Embla's internal scroll friction. Not an option; measured out of the trace.
const double _friction = 0.68;

/// `ScrollBounds`' `edgeOffsetTolerance` — 50% of the viewport.
const double _edgeOffsetTolerance = 0.5;

/// `ScrollBounds`' `pullBackThreshold` — 10% of the viewport.
const double _pullBackThreshold = 0.1;

/// `ScrollBounds`' friction clamp.
const double _frictionMin = 0.1;
const double _frictionMax = 0.99;

/// The fixed step Embla's engine integrates on, whatever the display does.
const double _stepSeconds = 1 / 60;

/// `-ml-4` on the track and `pl-4` on every item: one 16px gutter, paid for by
/// pulling the track left so the first card still starts at the viewport edge.
double get _gutter => ds(4);

/// `-left-12` / `-right-12` — how far outside the carousel each arrow sits.
double get _arrowReach => ds(12);

/// The engine: snap ladder, target, location, and the three-stage frame.
///
/// One frame is, in Embla's own order: the drag handler writes a target, then
/// `ScrollBounds` pulls that target back if the location is past a limit, then
/// `ScrollBody` integrates the location toward it.
class DsCarouselController extends ChangeNotifier {
  DsCarouselController({this.vsync});

  /// Null in a headless test: [_start] then lands on the target in one call,
  /// which is what `disableAnimations` asks of every other component here.
  final TickerProvider? vsync;

  /// `prefers-reduced-motion` / `MediaQuery.disableAnimations`, pushed down by
  /// [DsCarousel] every build.
  ///
  /// The engine has no duration to zero — it is an integrator — so the reduced
  /// path is *land on the target*, which is what a zeroed transition does
  /// everywhere else in this port.
  bool instant = false;
  Ticker? _ticker;
  Duration _last = Duration.zero;
  double _carry = 0;

  /// The track's translate, in pixels. Zero at the first slide, negative
  /// onwards.
  double get location => _location;
  double _location = 0;

  double _target = 0;
  double _velocity = 0;

  /// The measured container width — Embla measures the **container** (the
  /// `flex -ml-4` box), not the `overflow-hidden` viewport, which is why the
  /// scroll extent on the page is 1046 and not 1062.
  double _viewSize = 0;
  double _contentSize = 0;

  List<double> _snaps = const <double>[0];

  /// Every stop the carousel can rest at, trimmed — see [_snapsFor].
  List<double> get snaps => _snaps;

  int _index = 0;

  /// `api.selectedScrollSnap()`.
  int get selectedIndex => _index;

  /// `api.canScrollPrev()` — what `disabled` on `CarouselPrevious` reads.
  bool get canScrollPrev => _index > 0;

  /// `api.canScrollNext()`.
  bool get canScrollNext => _index < _snaps.length - 1;

  double get _minLimit => _snaps.isEmpty ? 0 : _snaps.last;
  double get _maxLimit => 0;

  bool _dragging = false;
  double _dragStartLocation = 0;
  double _dragStartPointer = 0;

  /// Set to zero for the duration of a drag, which is what makes tracking 1:1
  /// once the pointer stops moving.
  double _duration = _baseDuration;

  /// Handed the measured geometry after every layout.
  ///
  /// [slideSizes] are the item widths in order; [viewSize] is the container's.
  void setMetrics({
    required double viewSize,
    required List<double> slideSizes,
  }) {
    final double content = slideSizes.fold(0, (double a, double b) => a + b);
    if (viewSize == _viewSize && content == _contentSize) return;
    _viewSize = viewSize;
    _contentSize = content;
    _snaps = _snapsFor(viewSize: viewSize, slideSizes: slideSizes);
    _index = _index.clamp(0, _snaps.length - 1);
    _location = _snaps[_index];
    _target = _location;
    _velocity = 0;
    notifyListeners();
  }

  /// `containScroll: "trimSnaps"` — each slide's start, negated, clamped into
  /// the scrollable range, and collapsed where clamping made neighbours equal.
  static List<double> _snapsFor({
    required double viewSize,
    required List<double> slideSizes,
  }) {
    final double content = slideSizes.fold(0, (double a, double b) => a + b);
    final double maxScroll = math.max(0, content - viewSize);
    final List<double> out = <double>[];
    double start = 0;
    for (final double size in slideSizes) {
      final double snap = -math.min(start, maxScroll);
      if (out.isEmpty || (out.last - snap).abs() > 0.001) out.add(snap);
      start += size;
    }
    return out.isEmpty ? const <double>[0] : out;
  }

  /// `api.scrollTo(index)`.
  void scrollTo(int index) {
    if (_snaps.isEmpty) return;
    _index = index.clamp(0, _snaps.length - 1);
    _target = _snaps[_index];
    _duration = _baseDuration;
    _start();
    notifyListeners();
  }

  /// `api.scrollPrev()` — what the left arrow and ArrowLeft both call.
  void scrollPrev() => scrollTo(_index - 1);

  /// `api.scrollNext()`.
  void scrollNext() => scrollTo(_index + 1);

  /* ── drag ──────────────────────────────────────────────────────────────── */

  void dragStart(double pointerX) {
    _dragging = true;
    _dragStartLocation = _location;
    _dragStartPointer = pointerX;
    // `scrollBody.useDuration(0)` on pointer down.
    _duration = 0;
    _velocity = 0;
    _start();
  }

  void dragUpdate(double pointerX) {
    if (!_dragging) return;
    _target = _dragStartLocation + (pointerX - _dragStartPointer);
    // With a ticker this is a no-op — the loop is already running. Without
    // one it is the whole frame: target, bounds, body, in Embla's own order.
    _start();
  }

  void dragEnd() {
    if (!_dragging) return;
    _dragging = false;
    _duration = _baseDuration;
    // Measured: the release lands on the nearest snap, both directions.
    int best = 0;
    for (int i = 1; i < _snaps.length; i++) {
      if ((_snaps[i] - _location).abs() < (_snaps[best] - _location).abs()) {
        best = i;
      }
    }
    _index = best;
    _target = _snaps[best];
    _start();
    notifyListeners();
  }

  /* ── the frame ─────────────────────────────────────────────────────────── */

  void _start() {
    if (vsync == null || instant) {
      // No ticker: land on the target immediately. This is the path a
      // `disableAnimations` test takes.
      _location = _target;
      _velocity = 0;
      notifyListeners();
      return;
    }
    _ticker ??= vsync!.createTicker(_tick);
    if (!_ticker!.isActive) {
      _last = Duration.zero;
      _carry = 0;
      _ticker!.start();
    }
  }

  void _tick(Duration elapsed) {
    final double dt = _last == Duration.zero
        ? _stepSeconds
        : (elapsed - _last).inMicroseconds / Duration.microsecondsPerSecond;
    _last = elapsed;
    _carry += dt.clamp(0.0, 0.1);

    bool moved = false;
    while (_carry >= _stepSeconds) {
      _carry -= _stepSeconds;
      moved = _step() || moved;
    }
    if (moved) notifyListeners();

    if (!_dragging &&
        (_target - _location).abs() < 0.001 &&
        _velocity.abs() < 0.001) {
      _location = _target;
      _velocity = 0;
      _ticker?.stop();
      notifyListeners();
    }
  }

  bool _step() {
    _constrain();
    final double before = _location;
    if (_duration == 0) {
      _location = _target;
      _velocity = 0;
    } else {
      _velocity = (_velocity + (_target - _location) / _duration) * _friction;
      _location += _velocity;
    }
    return (_location - before).abs() > 0.0001;
  }

  /// Embla's `ScrollBounds.constrain`.
  void _constrain() {
    final double past = _location > _maxLimit
        ? _location - _maxLimit
        : _location < _minLimit
        ? _minLimit - _location
        : 0;
    if (past <= 0) return;
    final double tolerance = _viewSize * _edgeOffsetTolerance;
    final double friction = tolerance <= 0
        ? _frictionMax
        : (past / tolerance).clamp(_frictionMin, _frictionMax);
    final double diffToTarget = _target - _location;
    _target -= diffToTarget * friction;

    if (!_dragging && diffToTarget.abs() < _viewSize * _pullBackThreshold) {
      _target = _target.clamp(_minLimit, _maxLimit);
      _duration = _baseDuration;
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }
}

/// `<Carousel>` — region, viewport, track and the two arrows.
///
/// [padding] is the surrounding frame's own padding, moved inside so the
/// arrows can hang out of it: see the library note. Pass what the `Panel`
/// would have applied (`p-6`) and give the panel `flush: true`.
class DsCarousel extends StatefulWidget {
  const DsCarousel({
    super.key,
    required this.basis,
    required this.items,
    this.padding = EdgeInsets.zero,
    this.previousLabel = 'Previous slide',
    this.nextLabel = 'Next slide',
  });

  /// `basis-1/2 lg:basis-1/3` — the item's share of the **track**, which is the
  /// viewport plus one [_gutter].
  final double basis;

  /// One `CarouselItem`'s content each; the `pl-4` is applied here.
  final List<Widget> items;

  /// The frame padding this carousel applies for itself.
  final EdgeInsets padding;

  /// `<span className="sr-only">Previous slide</span>`.
  final String previousLabel;
  final String nextLabel;

  @override
  State<DsCarousel> createState() => _DsCarouselState();
}

class _DsCarouselState extends State<DsCarousel>
    with SingleTickerProviderStateMixin {
  late final DsCarouselController _controller = DsCarouselController(
    vsync: this,
  );
  final FocusNode _focus = FocusNode(debugLabel: 'DsCarousel');

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  /// `onKeyDownCapture` on the region: the path that reaches the engine
  /// whatever the panel does to the arrows.
  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _controller.scrollPrev();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _controller.scrollNext();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    // The stack has to reach [_arrowReach] past the carousel; [padding] pays
    // for as much of that as it has, and the rest is overflow.
    final double overhang = math.max(0, _arrowReach - widget.padding.left);
    // The engine has no `Duration` to hand [dsAnimationDuration]; the reduced
    // path is the same fact said the other way round.
    _controller.instant = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return Padding(
      padding: EdgeInsets.only(
        top: widget.padding.top,
        bottom: widget.padding.bottom,
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double slot = constraints.maxWidth;
          final double stackWidth = slot + overhang * 2;

          return Focus(
            focusNode: _focus,
            onKeyEvent: _onKey,
            child: Semantics(
              container: true,
              label: 'carousel',
              child: OverflowBox(
                alignment: Alignment.center,
                fit: OverflowBoxFit.deferToChild,
                minWidth: stackWidth,
                maxWidth: stackWidth,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: _arrowReach),
                      child: _Track(
                        controller: _controller,
                        basis: widget.basis,
                        items: widget.items,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: _Arrow(
                          controller: _controller,
                          forward: false,
                          label: widget.previousLabel,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: _Arrow(
                          controller: _controller,
                          forward: true,
                          label: widget.nextLabel,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// `CarouselContent` — the `overflow-hidden` viewport and the `flex -ml-4`
/// track inside it.
class _Track extends StatelessWidget {
  const _Track({
    required this.controller,
    required this.basis,
    required this.items,
  });

  final DsCarouselController controller;
  final double basis;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // The container Embla measures is the `-ml-4` box: one gutter wider
        // than the viewport it sits in.
        final double trackWidth = constraints.maxWidth + _gutter;
        final double itemWidth = trackWidth * basis;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.setMetrics(
            viewSize: trackWidth,
            slideSizes: List<double>.filled(items.length, itemWidth),
          );
        });

        return ClipRect(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: (DragStartDetails d) =>
                controller.dragStart(d.globalPosition.dx),
            onHorizontalDragUpdate: (DragUpdateDetails d) =>
                controller.dragUpdate(d.globalPosition.dx),
            onHorizontalDragEnd: (DragEndDetails d) => controller.dragEnd(),
            onHorizontalDragCancel: controller.dragEnd,
            child: AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? child) =>
                  Transform.translate(
                    offset: Offset(-_gutter + controller.location, 0),
                    child: child,
                  ),
              child: OverflowBox(
                alignment: Alignment.topLeft,
                fit: OverflowBoxFit.deferToChild,
                maxWidth: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (final Widget item in items)
                      SizedBox(
                        width: itemWidth,
                        child: Padding(
                          // `pl-4`.
                          padding: EdgeInsets.only(left: _gutter),
                          child: item,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// `CarouselPrevious` / `CarouselNext` — `variant="outline" size="icon-sm"`
/// plus `rounded-full`, which a [DsButton] is already.
class _Arrow extends StatelessWidget {
  const _Arrow({
    required this.controller,
    required this.forward,
    required this.label,
  });

  final DsCarouselController controller;
  final bool forward;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, _) {
        final bool enabled = forward
            ? controller.canScrollNext
            : controller.canScrollPrev;
        return DsButton(
          variant: DsButtonVariant.outline,
          size: DsButtonSize.iconSm,
          label: label,
          onPressed: enabled
              ? (forward ? controller.scrollNext : controller.scrollPrev)
              : null,
          child: DsIcon.lucide(
            forward ? DsLucide.chevronRight : DsLucide.chevronLeft,
            sizePx: DsButton.iconPxFor(DsButtonSize.iconSm),
            tone: DsIconTone.inherit,
          ),
        );
      },
    );
  }
}
