/// `components/ui/drawer.tsx` — *"the mobile bottom sheet. Draggable, and the
/// correct container for card actions on a phone where a dialog would feel
/// oversized."*
///
/// The one overlay on the page that is **not** Radix. It wraps `vaul`, which
/// brings its own stylesheet, its own keyframes and its own easing — so it is
/// also the one overlay whose motion the design system's tokens do not reach.
/// Measured (2026-08-16, 1440x900):
///
/// | part | measured |
/// |---|---|
/// | panel | `inset-x-0 bottom-0` — the full 1440 — `mt-24`, `max-h-[80vh]` 720, `rounded-t-xl` 16, 1px top border, `--popover` fill, `text-sm` |
/// | handle | `mx-auto mt-4 h-1 w-24 rounded-full bg-muted` — 96 x 4, and only on the bottom direction |
/// | header | `p-4 gap-0.5 text-center` |
/// | footer | `mt-auto flex-col gap-2 p-4` |
/// | enter | `slideFromBottom` — `translate3d(0, 100%, 0)` to nothing — over **500ms** on `cubic-bezier(0.32, 0.72, 0, 1)` |
/// | overlay | `fadeIn`, the same 500ms and the same curve |
/// | drag | `transform: matrix(1,0,0,1,0,60)` measured at 60px of pointer travel — the panel follows the finger 1:1 |
/// | release | past the threshold the drawer unmounts; short of it, it returns |
///
/// **No gap anywhere in the column.** `DrawerContent` sets none, so the handle,
/// the header, the body and the footer stack flush — measured 304.06 total for
/// 1 + 20 + 75.06 + 136 + 72.
///
/// **Vaul's own `@keyframes` are the port's spec**, quoted from the live
/// stylesheet rather than from the package:
///
/// ```css
/// @keyframes slideFromBottom {
///   0%   { transform: translate3d(0, var(--initial-transform, 100%), 0); }
///   100% { transform: translate3d(0, 0, 0); }
/// }
/// @keyframes fadeIn { 0% { opacity: 0 } 100% { opacity: 1 } }
/// ```
///
/// The `100%` is the panel's **own height**, which is why the entrance is a
/// [FractionalTranslation] and not a pixel offset.
///
/// Not ported: the other three directions (`vaul-drawer-direction` left/right/
/// top), which `DrawerContent`'s class list carries and no caller in the corpus
/// asks for; `snapPoints`; and the background-scale effect, which the reference
/// does not enable.
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';
import 'dialog.dart';

/// vaul's `closeThreshold` default — a quarter of the drawer's own height.
const double _closeThreshold = 0.25;

/// `Drawer` — trigger, portal, overlay, panel, and the drag.
class ElDrawer extends StatefulWidget {
  const ElDrawer({super.key, required this.trigger, required this.content});

  final ElModalTriggerBuilder trigger;
  final ElModalContentBuilder content;

  @override
  State<ElDrawer> createState() => _ElDrawerState();
}

class _ElDrawerState extends State<ElDrawer> {
  final GlobalKey<ElModalPortalState> _portal = GlobalKey<ElModalPortalState>();

  /// How far the pointer has taken the panel down, in logical pixels.
  double _drag = 0;

  /// The panel's measured height, so the threshold is a fraction of the thing
  /// being dragged rather than of the screen.
  double _height = 0;

  void _update(DragUpdateDetails details) {
    setState(() {
      // Downward only: vaul dampens an upward drag on a bottom drawer to
      // nothing, because there is nowhere for it to go.
      _drag = (_drag + details.delta.dy).clamp(0.0, double.infinity);
    });
  }

  void _end(DragEndDetails details) {
    final bool past = _height > 0 && _drag > _height * _closeThreshold;
    setState(() => _drag = 0);
    if (past) _portal.currentState?.close();
  }

  @override
  Widget build(BuildContext context) => ElModalPortal(
    key: _portal,
    trigger: widget.trigger,
    alignment: Alignment.bottomCenter,
    // USER-ORDERED MOBILE ADAPTATION — out of the host's 90vw x 75vh box,
    // because this component is already the answer the clamp is reaching
    // for. The drawer *is* the phone container: `inset-x-0` is a full-bleed
    // width that a 90vw cap would break, and `max-h-[80vh]` is vaul's own
    // cap in the same units as the clamp's 75vh, applied in
    // [ElDrawerContent].
    //
    // Its body is also the one panel in the family that is deliberately
    // NOT scrollable: a [Scrollable] inside the panel would win the gesture
    // arena against the drag-to-dismiss recognizer wrapped around it — the
    // deepest vertical-drag recognizer takes the sweep — and vaul's own
    // answer to that (only drag when the inner scroller is at its top) is
    // not ported. The 80vh cap is what keeps it on screen.
    clampToViewport: false,
    // vaul's clock, not `--duration-overlay` — see the library doc.
    enterDuration: ElDurations.drawer,
    exitDuration: ElDurations.drawer,
    overlayDuration: ElDurations.drawer,
    overlayCurve: ElCurves.vaul,
    transition:
        (BuildContext context, Animation<double> animation, Widget child) =>
            _DrawerTransition(animation: animation, drag: _drag, child: child),
    content: (BuildContext context, VoidCallback close) => RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        VerticalDragGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
              VerticalDragGestureRecognizer.new,
              (VerticalDragGestureRecognizer instance) => instance
                ..onUpdate = _update
                ..onEnd = _end,
            ),
      },
      child: _Measured(
        onMeasured: (double h) => _height = h,
        child: widget.content(context, close),
      ),
    ),
  );
}

/// Reports its child's height without rebuilding on it.
class _Measured extends SingleChildRenderObjectWidget {
  const _Measured({required this.onMeasured, required Widget child})
    : super(child: child);

  final ValueChanged<double> onMeasured;

  @override
  _RenderMeasured createRenderObject(BuildContext context) =>
      _RenderMeasured(onMeasured);

  @override
  void updateRenderObject(BuildContext context, _RenderMeasured object) {
    object.onMeasured = onMeasured;
  }
}

class _RenderMeasured extends RenderProxyBox {
  _RenderMeasured(this.onMeasured);

  ValueChanged<double> onMeasured;

  @override
  void performLayout() {
    super.performLayout();
    onMeasured(size.height);
  }
}

/// `slideFromBottom` plus whatever the finger is currently adding.
class _DrawerTransition extends StatelessWidget {
  const _DrawerTransition({
    required this.animation,
    required this.drag,
    required this.child,
  });

  final Animation<double> animation;

  /// The live drag, in pixels — a *pixel* offset on top of the entrance's
  /// *fractional* one, exactly as vaul's inline `transform` sits on top of its
  /// keyframes.
  final double drag;

  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    child: child,
    builder: (BuildContext context, Widget? child) {
      final double t = ElCurves.vaul.transform(animation.value.clamp(0, 1));
      return FractionalTranslation(
        translation: Offset(0, 1 - t),
        child: Transform.translate(offset: Offset(0, drag), child: child),
      );
    },
  );
}

/// `DrawerContent` — the panel.
class ElDrawerContent extends StatelessWidget {
  const ElDrawerContent({super.key, required this.children});

  /// `flex h-auto flex-col` with **no gap**.
  final List<Widget> children;

  /// `mt-24` — the strip of page the drawer may never cover.
  static double get topGutter => el(24);

  /// `max-h-[80vh]`.
  static const double maxHeightFraction = 0.8;

  /// `rounded-t-xl`.
  static double get radius => ElRadii.xl;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final Size viewport = MediaQuery.sizeOf(context);
    final BorderRadius shape = BorderRadius.vertical(
      top: Radius.circular(radius),
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        // `inset-x-0` — the panel is as wide as the viewport, so it takes the
        // incoming maximum rather than shrink-wrapping its content.
        minWidth: double.infinity,
        maxHeight: viewport.height * maxHeightFraction,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.popover,
          borderRadius: shape,
          border: Border(
            top: BorderSide(color: theme.border, width: ElWidths.hairline),
          ),
        ),
        child: ClipRRect(
          borderRadius: shape,
          child: Padding(
            padding: EdgeInsets.only(top: ElWidths.hairline),
            child: DefaultTextStyle(
              style: ElText.styleOf(
                context,
                ElComponentType.sheetBody,
                color: theme.popoverForeground,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[const ElDrawerHandle(), ...children],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `mx-auto mt-4 h-1 w-24 shrink-0 rounded-full bg-muted`, shown only on the
/// bottom direction.
class ElDrawerHandle extends StatelessWidget {
  const ElDrawerHandle({super.key});

  /// `w-24`.
  static double get width => el(24);

  /// `h-1`.
  static double get height => el(1);

  @override
  Widget build(BuildContext context) => Padding(
    // `mt-4`.
    padding: EdgeInsets.only(top: el(4)),
    child: Center(
      child: SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: ElTheme.of(context).muted,
            borderRadius: BorderRadius.circular(ElRadii.pill),
          ),
        ),
      ),
    ),
  );
}

/// `DrawerHeader` — `flex flex-col gap-0.5 p-4`, centred on the bottom
/// direction.
class ElDrawerHeader extends StatelessWidget {
  const ElDrawerHeader({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.all(el(4)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < children.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: el(0.5)),
          children[i],
        ],
      ],
    ),
  );
}

/// `DrawerFooter` — `mt-auto flex flex-col gap-2 p-4`.
///
/// The `mt-auto` has nothing to push against here: the panel is `h-auto` and
/// its column is exactly as tall as its children, so the automatic margin
/// resolves to zero. Measured — the footer's top is its predecessor's bottom.
class ElDrawerFooter extends StatelessWidget {
  const ElDrawerFooter({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.all(el(4)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < children.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: el(2)),
          children[i],
        ],
      ],
    ),
  );
}

/// `DrawerTitle` — `font-heading text-base font-medium text-foreground`.
class ElDrawerTitle extends StatelessWidget {
  const ElDrawerTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => ElText(
    text,
    ElComponentType.overlayTitle,
    color: ElTheme.of(context).foreground,
    align: TextAlign.center,
  );
}

/// `DrawerDescription` — `text-sm text-muted-foreground`.
class ElDrawerDescription extends StatelessWidget {
  const ElDrawerDescription(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => ElText(
    text,
    ElComponentType.sheetBody,
    color: ElTheme.of(context).mutedForeground,
    align: TextAlign.center,
  );
}
