/// The CSS line box, restored over an engine that rounds it.
///
/// A browser lays a line box out at exactly `font-size × line-height`: a
/// 13px/1.5 paragraph is 19.5px per line, and everything below it starts at a
/// fractional offset. Flutter's paragraph engine rounds each line's ascent and
/// its descent to whole pixels before adding them — `LineMetrics.height` is
/// documented as `round(ascent + descent)` — so the same paragraph measures
/// 19px or 20px per line depending on where the two halves land.
///
/// The error is at most half a pixel per line and it **accumulates**: a
/// foundation page is a few hundred lines deep, and by its foot the port sat
/// 65px below the reference. [DsLineBox] gives a paragraph back the height CSS
/// gives it, so every box under it lands where the browser puts it. Where the
/// engine already agrees — a line whose rounded metrics happen to be exact, or
/// a future engine that stops rounding — the correction is the identity.
///
/// [DsInlineBox] is the other half of the same story: a CSS **inline** element
/// (the `<code>` chip in a sentence) contributes only its own `line-height` to
/// the line box it sits in, while its border box is the font's content area
/// plus its padding and border, which is free to overflow that line. A Flutter
/// `WidgetSpan` makes no such distinction — whatever the widget measures is
/// what the line grows to. [DsInlineBox] hides the frame from the line.
library;

import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// How far a measured height may sit off a whole number of lines before the
/// correction gives up.
///
/// A paragraph whose runs do not all share one line height has no per-line
/// metric to correct against, fails this test, and is left exactly as the
/// engine laid it out.
const double _lineTolerance = 0.01;

/// One-glyph probes, so the engine's line box for a style is measured once.
final Map<TextStyle, double> _engineLineCache = <TextStyle, double>{};

/// What the engine actually produces for a single line of [style].
///
/// Measured rather than derived: the rounding turns on the font's own ascent
/// and descent, which only the engine knows.
double dsEngineLineHeight(TextStyle style) {
  return _engineLineCache.putIfAbsent(style, () {
    final TextPainter painter = TextPainter(
      // allow-hardcoded: a probe glyph, not copy.
      text: TextSpan(text: 'x', style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    final double height = painter.height;
    painter.dispose();
    return height;
  });
}

/// Font metrics per style, so an inline box is measured once.
final Map<TextStyle, double> _contentAreaCache = <TextStyle, double>{};

/// The CSS **content area** for [style]: the font's ascent plus its descent,
/// each rounded to a whole pixel first, which is what Blink does before it
/// draws an inline element's border box.
double dsContentAreaHeight(TextStyle style) {
  return _contentAreaCache.putIfAbsent(style, () {
    final TextPainter painter = TextPainter(
      // allow-hardcoded: a probe glyph, not copy.
      text: TextSpan(text: 'x', style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    final ui.LineMetrics line = painter.computeLineMetrics().first;
    final double height =
        line.ascent.roundToDouble() + line.descent.roundToDouble();
    painter.dispose();
    return height;
  });
}

/// `font-size × line-height`, or 0 when the class states no line height and
/// there is nothing to correct towards.
double _cssLineHeight(TextStyle style) {
  final double? size = style.fontSize;
  final double? ratio = style.height;
  return size == null || ratio == null ? 0 : size * ratio;
}

/// Wraps a paragraph so that its box is the height CSS would give it.
class DsLineBox extends SingleChildRenderObjectWidget {
  const DsLineBox({
    super.key,
    required this.style,
    this.lineHeight,
    required Widget super.child,
  });

  /// The resolved style of the paragraph inside: its size and line-height are
  /// the target, and its font decides what the engine currently produces.
  final TextStyle style;

  /// The target for one line, when it is not `font-size × line-height` — an
  /// inline box, whose height is the font's content area (see
  /// [dsContentAreaHeight]).
  final double? lineHeight;

  double get _target => lineHeight ?? _cssLineHeight(style);

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderLineBox(_target, dsEngineLineHeight(style));

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _RenderLineBox)
      ..cssLine = _target
      ..engineLine = dsEngineLineHeight(style);
  }
}

class _RenderLineBox extends RenderProxyBox {
  /// Positional because both fields are private, and a named parameter may
  /// not be: the CSS line height first, then the engine's.
  _RenderLineBox(this._cssLine, this._engineLine);

  double _cssLine;
  set cssLine(double value) {
    if (value == _cssLine) return;
    _cssLine = value;
    markNeedsLayout();
  }

  double _engineLine;
  set engineLine(double value) {
    if (value == _engineLine) return;
    _engineLine = value;
    markNeedsLayout();
  }

  /// Half the correction: CSS spreads leading evenly above and below, so the
  /// glyphs stay centred in the box they were centred in.
  double _dy = 0;

  double _correct(double height) {
    if (_cssLine <= 0 || _engineLine <= 0) return height;
    final double lines = height / _engineLine;
    final int whole = lines.round();
    if (whole < 1 || (lines - whole).abs() > _lineTolerance) return height;
    return whole * _cssLine;
  }

  @override
  double computeMinIntrinsicHeight(double width) =>
      _correct(super.computeMinIntrinsicHeight(width));

  @override
  double computeMaxIntrinsicHeight(double width) =>
      _correct(super.computeMaxIntrinsicHeight(width));

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final RenderBox? child = this.child;
    if (child == null) return constraints.smallest;
    final Size size = child.getDryLayout(constraints);
    return constraints.constrain(Size(size.width, _correct(size.height)));
  }

  @override
  double? computeDryBaseline(
    BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    final RenderBox? child = this.child;
    if (child == null) return null;
    final double? distance = child.getDryBaseline(constraints, baseline);
    if (distance == null) return null;
    final Size size = child.getDryLayout(constraints);
    return distance + (_correct(size.height) - size.height) / 2;
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    final RenderBox? child = this.child;
    if (child == null) return null;
    final double? distance = child.getDistanceToActualBaseline(baseline);
    return distance == null ? null : distance + _dy;
  }

  @override
  void performLayout() {
    final RenderBox? child = this.child;
    if (child == null) {
      _dy = 0;
      size = computeSizeForNoChild(constraints);
      return;
    }
    child.layout(constraints, parentUsesSize: true);
    size = constraints.constrain(
      Size(child.size.width, _correct(child.size.height)),
    );
    _dy = (size.height - child.size.height) / 2;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? child = this.child;
    if (child != null) context.paintChild(child, offset + Offset(0, _dy));
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final RenderBox? child = this.child;
    if (child == null) return false;
    return result.addWithPaintOffset(
      offset: Offset(0, _dy),
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) =>
          child.hitTest(result, position: transformed),
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.translateByDouble(0, _dy, 0, 1);
  }
}

/// A CSS inline box: paints [child] whole, but reports it [trim] shorter.
///
/// The trimmed amount is the child's own vertical padding and border — the
/// part a browser paints outside the line box without letting the line grow
/// for it. Baseline-aligned inside a paragraph, the chip then sits on the
/// sentence's baseline and bleeds over the leading, exactly as `<code>` does.
class DsInlineBox extends SingleChildRenderObjectWidget {
  const DsInlineBox({
    super.key,
    required this.trim,
    required Widget super.child,
  });

  /// Total vertical padding + border of [child] — split evenly top and bottom.
  final double trim;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderInlineBox(trim);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _RenderInlineBox).trim = trim;
  }
}

class _RenderInlineBox extends RenderProxyBox {
  _RenderInlineBox(this._trim);

  double _trim;
  set trim(double value) {
    if (value == _trim) return;
    _trim = value;
    markNeedsLayout();
  }

  double get _dy => -_trim / 2;

  double _trimmed(double height) => (height - _trim).clamp(0, double.infinity);

  @override
  double computeMinIntrinsicHeight(double width) =>
      _trimmed(super.computeMinIntrinsicHeight(width));

  @override
  double computeMaxIntrinsicHeight(double width) =>
      _trimmed(super.computeMaxIntrinsicHeight(width));

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final RenderBox? child = this.child;
    if (child == null) return constraints.smallest;
    final Size size = child.getDryLayout(constraints);
    return constraints.constrain(Size(size.width, _trimmed(size.height)));
  }

  @override
  double? computeDryBaseline(
    BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    final double? distance = child?.getDryBaseline(constraints, baseline);
    return distance == null ? null : distance + _dy;
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    final double? distance = child?.getDistanceToActualBaseline(baseline);
    return distance == null ? null : distance + _dy;
  }

  @override
  void performLayout() {
    final RenderBox? child = this.child;
    if (child == null) {
      size = computeSizeForNoChild(constraints);
      return;
    }
    child.layout(constraints, parentUsesSize: true);
    size = constraints.constrain(
      Size(child.size.width, _trimmed(child.size.height)),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? child = this.child;
    if (child != null) context.paintChild(child, offset + Offset(0, _dy));
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final RenderBox? child = this.child;
    if (child == null) return false;
    return result.addWithPaintOffset(
      offset: Offset(0, _dy),
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) =>
          child.hitTest(result, position: transformed),
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.translateByDouble(0, _dy, 0, 1);
  }
}
