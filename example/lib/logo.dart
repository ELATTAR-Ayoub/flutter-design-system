/// The wordmark, `components/el/logo.tsx`.
///
/// The reference's own note explains the shape: *"The mark is typographic on
/// purpose: no illustrated logo to license or re-draw. The chevron glyph
/// doubles as the favicon-scale mark. The value colour is reserved for rare,
/// meaningful emphasis, so the wordmark stays clean at the smallest scale it
/// ever appears in."*
///
/// Two paths, painted rather than shipped as an asset: the same treatment
/// [ElIcon] gives lucide, and for the same reason: an SVG that has to be
/// tinted per theme is geometry, not an image.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

/// `M6 15.5 12 6l6 9.5`: the chevron, `stroke-linecap="square"`.
const ElIconPathElement _chevron = ElIconPathElement('M6 15.5 12 6l6 9.5');

/// `M6 19h12`: the rule under it. No `stroke-linecap`, so SVG's default
/// `butt` applies; the chevron's square caps are what make the two read as
/// one drawing rather than a tick over a line.
const ElIconPathElement _underline = ElIconPathElement('M6 19h12');

/// `size-7`: the tile.
final double _tilePx = el(7);

/// `size-4`: the SVG inside it.
final double _glyphPx = el(4);

/// The `stroke-width="2.4"` both paths carry.
///
/// Not typed as a literal: 2.4 is what the icon system computes for anything
/// drawn on lucide's 24-unit grid at 16px, which is exactly what this is.
final double _glyphStroke = ElIcon.strokeFor(_glyphPx);

/// The blue tile with the chevron in it, `LogoMark`.
class ElLogoMark extends StatelessWidget {
  const ElLogoMark({super.key});

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ExcludeSemantics(
      child: Container(
        width: _tilePx,
        height: _tilePx,
        decoration: BoxDecoration(
          // `bg-action`: the raw ramp, not `--primary`: the tile is the same
          // blue in both themes.
          color: ElPalette.action,
          borderRadius: BorderRadius.circular(ElRadii.md),
        ),
        child: Center(
          child: SizedBox(
            width: _glyphPx,
            height: _glyphPx,
            child: CustomPaint(
              painter: _MarkPainter(
                chevron: theme.primaryForeground,
                underline: ElPalette.valueBright,
                strokeWidth: _glyphStroke,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `Logo`: mark plus wordmark, `gap-2.5`.
class Logo extends StatelessWidget {
  const Logo({super.key, this.showMark = true});

  /// The reference's `showMark` prop. Nothing in the docs app turns it off,
  /// but the signature is the component's, not this app's.
  final bool showMark;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (showMark) ...<Widget>[const ElLogoMark(), SizedBox(width: el(2.5))],
        ElText('ELATTAR', ElType.wordmark, color: theme.foreground),
      ],
    );
  }
}

class _MarkPainter extends CustomPainter {
  const _MarkPainter({
    required this.chevron,
    required this.underline,
    required this.strokeWidth,
  });

  final Color chevron;
  final Color underline;

  /// In the 24-unit space of the `viewBox`, as the SVG attribute is: the
  /// canvas scale converts it.
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    canvas.save();
    canvas.scale(
      size.width / ElIconPaths.viewBox,
      size.height / ElIconPaths.viewBox,
    );
    _stroke(canvas, _chevron, chevron, StrokeCap.square, StrokeJoin.miter);
    _stroke(canvas, _underline, underline, StrokeCap.butt, StrokeJoin.miter);
    canvas.restore();
  }

  void _stroke(
    Canvas canvas,
    ElIconPathElement element,
    Color color,
    StrokeCap cap,
    StrokeJoin join,
  ) {
    final Path path = Path();
    element.addTo(path);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = cap
        ..strokeJoin = join,
    );
  }

  @override
  bool shouldRepaint(_MarkPainter old) =>
      old.chevron != chevron ||
      old.underline != underline ||
      old.strokeWidth != strokeWidth;
}
