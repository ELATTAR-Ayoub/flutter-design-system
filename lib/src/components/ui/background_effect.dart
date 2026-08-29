/// The page atmosphere — `app/globals.css` L983–993.
///
/// ```css
/// body {
///   @apply bg-background text-foreground;
///   background-image: radial-gradient(120% 90% at 62% 34%,
///                                     var(--background-effect) 0%, transparent 64%);
///   background-attachment: fixed;
///   background-repeat: no-repeat;
/// }
/// ```
///
/// Its own comment states the intent: *"a flat fill at zinc 950 reads as black
/// paint, and the same fill under a wide, slightly lifted glow reads as a deep
/// room."* It is the floor of every page, and it does not animate — RULES §4
/// allows exactly two perpetual motions and this is neither.
library;

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
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

import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/theme_scope.dart';

// The gradient's own geometry, transcribed from the one `radial-gradient()`
// above. Not tokens — no other surface in the system refers to them — so they
// live with the effect that owns them rather than in `foundation/`.
//
// allow-hardcoded: body background-effect gradient geometry (globals.css L985–989)
const double _radiusX = 1.20; // `120%` of the box WIDTH
const double _radiusY = 0.90; // `90%`  of the box HEIGHT
const double _centerX = 0.62; // `at 62% …`
const double _centerY = 0.34; // `… 34%`
const double _fadeStop = 0.64; // `transparent 64%`

/// Paints `--background` with the page glow over it, and [child] over that.
///
/// **Placement.** `background-attachment: fixed` resolves the gradient against
/// the viewport and pins it there, so this belongs *behind* the scroll view —
/// a `Stack` child sized to the viewport — never inside it. Scroll it and the
/// atmosphere scrolls with the content, which is the one thing the reference
/// explicitly does not do.
class BackgroundEffect extends StatelessWidget {
  const BackgroundEffect({super.key, this.child});

  /// Painted over the glow. Omit it when the glow is a `Stack` layer of its
  /// own, in which case this widget expands to fill its constraints.
  final Widget? child;

  /// The ellipse the gradient's `100%` stop lies on, for [size].
  ///
  /// Exposed because this is the whole difficulty of the port: CSS sizes a
  /// radial gradient's two radii against the box's **own** width and height,
  /// while Flutter's [RadialGradient.radius] is a single fraction of the
  /// box's **shortest side** and cannot describe this shape at all.
  @visibleForTesting
  static Rect debugEllipse(Size size) => Rect.fromCenter(
    center: Offset(size.width * _centerX, size.height * _centerY),
    width: size.width * _radiusX * 2,
    height: size.height * _radiusY * 2,
  );

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return CustomPaint(
      painter: _BackgroundEffectPainter(
        background: theme.background,
        glow: theme.pageGlow,
      ),
      child: child ?? const SizedBox.expand(),
    );
  }
}

class _BackgroundEffectPainter extends CustomPainter {
  const _BackgroundEffectPainter({
    required this.background,
    required this.glow,
  });

  final Color background;
  final Color glow;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final Rect box = Offset.zero & size;
    canvas.drawRect(box, Paint()..color = background);

    final Rect ellipse = BackgroundEffect.debugEllipse(size);
    canvas.drawRect(
      box,
      Paint()
        ..shader = ui.Gradient.radial(
          // A unit circle at the origin, mapped onto `ellipse` by the matrix
          // below — the only way to reach a two-radius radial gradient, since
          // `Gradient.radial` itself takes a single scalar radius.
          Offset.zero,
          1,
          <Color>[glow, _faded],
          const <double>[0, _fadeStop],
          TileMode.clamp,
          _ellipseMatrix(ellipse),
        ),
    );
  }

  /// The CSS `transparent` keyword, kept on the glow's own hue.
  ///
  /// **Recorded decision.** `transparent` is `rgba(0, 0, 0, 0)`, and browsers
  /// interpolate gradient stops in *premultiplied* space, where a zero-alpha
  /// stop contributes no colour — so the ramp stays `--background-effect` all the way
  /// out. Skia interpolates unpremultiplied, so handing it a literal
  /// transparent-black would drag every midpoint toward black and ring the
  /// glow with a dirty halo. Fading the glow's own colour to alpha 0 is what
  /// the browser actually renders.
  Color get _faded => glow.withValues(alpha: 0);

  /// Maps the unit circle onto [ellipse]: scale by its radii, then translate
  /// to its centre. Column-major, as `Gradient.radial` expects.
  static Float64List _ellipseMatrix(Rect ellipse) =>
      Float64List.fromList(<double>[
        ellipse.width / 2, 0, 0, 0, //
        0, ellipse.height / 2, 0, 0, //
        0, 0, 1, 0, //
        ellipse.center.dx, ellipse.center.dy, 0, 1, //
      ]);

  @override
  bool shouldRepaint(_BackgroundEffectPainter old) =>
      old.background != background || old.glow != glow;
}
