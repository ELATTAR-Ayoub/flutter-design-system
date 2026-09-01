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
/// 65px below the reference. [LineBox] gives a paragraph back the height CSS
/// gives it, so every box under it lands where the browser puts it. Where the
/// engine already agrees — a line whose rounded metrics happen to be exact, or
/// a future engine that stops rounding — the correction is the identity.
///
/// [InlineBox] is the other half of the same story: a CSS **inline** element
/// (the `<code>` chip in a sentence) contributes only its own `line-height` to
/// the line box it sits in, while its border box is the font's content area
/// plus its padding and border, which is free to overflow that line. A Flutter
/// `WidgetSpan` makes no such distinction — whatever the widget measures is
/// what the line grows to. [InlineBox] hides the frame from the line.
library;

import 'dart:ui' as ui;

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
double engineLineHeight(TextStyle style) {
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
double contentAreaHeight(TextStyle style) {
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
class LineBox extends SingleChildRenderObjectWidget {
  const LineBox({
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
  /// [contentAreaHeight]).
  final double? lineHeight;

  double get _target => lineHeight ?? _cssLineHeight(style);

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderLineBox(_target, engineLineHeight(style));

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _RenderLineBox)
      ..cssLine = _target
      ..engineLine = engineLineHeight(style);
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
class InlineBox extends SingleChildRenderObjectWidget {
  const InlineBox({super.key, required this.trim, required Widget super.child});

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

/* ── Break opportunities around an inline box ────────────────────────────── */

/// Characters a line may not break **before** — UAX #14 LB13 (`× CL`, `× CP`,
/// `× IS`, `× SY`, `× EX`): closing brackets and quotes, and the punctuation
/// that belongs to whatever it follows.
const String _noBreakBefore = ')]}\u00bb\u201d\u2019.,:;!?/';

/// Characters a line may not break **after** — UAX #14 LB14 (`OP SP* ×`):
/// opening brackets and quotes.
const String _noBreakAfter = '([{\u00ab\u201c\u2018';

/// Restores the break opportunities CSS has around an inline box.
///
/// A `<code>` chip in a sentence is text as far as line breaking is concerned.
/// `…action-feedback) and…` may break *inside* the chip, at its hyphen — UAX #14
/// allows a break after a hyphen — but never between the chip and the `)`,
/// because LB13 forbids a break before a closing bracket. Chrome therefore
/// sets `sheen-` at the end of the line and `action)` at the start of the next.
///
/// Flutter renders the chip as a [WidgetSpan], and the engine gives every
/// placeholder a soft break opportunity on both sides unconditionally —
/// measurably so: `aaaa<box>bbbb` breaks between the box and `bbbb` though no
/// rule in UAX #14 allows it, and a U+2060 WORD JOINER at that seam does not
/// suppress it. Flutter's opportunity set around a chip is thus a strict
/// superset of CSS's, and the greedy breaker takes an opportunity the browser
/// does not have.
///
/// The repair is to delete the surplus opportunities rather than to nudge the
/// legal ones: punctuation the line may not break away from is moved *into*
/// the placeholder, so chip and bracket reach the breaker as one object. With
/// the two engines then offering the same opportunities over the same widths,
/// the same greedy walk produces the same lines. Nothing here can move a line
/// that already breaks where the browser breaks it, because a line that did
/// not use a deleted opportunity cannot notice that it is gone.
InlineSpan glueInlineBoxes(InlineSpan root, TextStyle base) {
  final _Glue glue = _Glue(base);
  glue._collect(root, base);
  glue._plan();
  return glue._seams.isEmpty ? root : glue._rebuild(root);
}

/// What a placeholder swallowed from its neighbours.
class _Seam {
  String head = '';
  String tail = '';
  TextStyle? headStyle;
  TextStyle? tailStyle;
}

/// Two passes over one span tree: read the seams, then write them.
///
/// Both passes walk in the same order and count the same leaves — a [TextSpan]
/// carrying text, and a placeholder — so a leaf's index means the same thing
/// in each.
class _Glue {
  _Glue(this.base);

  final TextStyle base;

  final List<bool> _isBox = <bool>[];
  final List<String> _texts = <String>[];
  final List<TextStyle> _styles = <TextStyle>[];

  final Map<int, _Seam> _seams = <int, _Seam>{};
  final Map<int, int> _fromStart = <int, int>{};
  final Map<int, int> _fromEnd = <int, int>{};

  int _at = 0;

  void _collect(InlineSpan span, TextStyle inherited) {
    final TextStyle style = span.style == null
        ? inherited
        : inherited.merge(span.style);
    if (span is TextSpan) {
      final String? text = span.text;
      if (text != null && text.isNotEmpty) {
        _isBox.add(false);
        _texts.add(text);
        _styles.add(style);
      }
      for (final InlineSpan child in span.children ?? const <InlineSpan>[]) {
        _collect(child, style);
      }
    } else if (span is PlaceholderSpan) {
      _isBox.add(true);
      _texts.add('\uFFFC');
      _styles.add(style);
    }
  }

  /// Reads the seams once the leaves are known.
  void _plan() {
    for (int i = 0; i < _isBox.length; i++) {
      if (!_isBox[i]) continue;
      final _Seam seam = _Seam();
      if (i + 1 < _isBox.length && !_isBox[i + 1]) {
        final String next = _texts[i + 1];
        int n = 0;
        while (n < next.length && _noBreakBefore.contains(next[n])) {
          n++;
        }
        if (n > 0) {
          seam.tail = next.substring(0, n);
          seam.tailStyle = _styles[i + 1];
          _fromStart[i + 1] = n;
        }
      }
      if (i > 0 && !_isBox[i - 1]) {
        final String prev = _texts[i - 1];
        int n = 0;
        while (n < prev.length &&
            _noBreakAfter.contains(prev[prev.length - 1 - n])) {
          n++;
        }
        if (n > 0) {
          seam.head = prev.substring(prev.length - n);
          seam.headStyle = _styles[i - 1];
          _fromEnd[i - 1] = n;
        }
      }
      if (seam.head.isNotEmpty || seam.tail.isNotEmpty) _seams[i] = seam;
    }
    // A leaf short enough to be claimed from both ends would be double-counted;
    // leave such a seam alone rather than drop characters.
    _fromStart.removeWhere(
      (int i, int n) => n + (_fromEnd[i] ?? 0) > _texts[i].length,
    );
    _fromEnd.removeWhere(
      (int i, int n) => n + (_fromStart[i] ?? 0) > _texts[i].length,
    );
  }

  InlineSpan _rebuild(InlineSpan span) {
    if (span is TextSpan) {
      String? text = span.text;
      if (text != null && text.isNotEmpty) {
        final int i = _at++;
        final int a = _fromStart[i] ?? 0;
        final int b = _fromEnd[i] ?? 0;
        text = text.substring(a, text.length - b);
      }
      final List<InlineSpan>? children = span.children;
      return TextSpan(
        text: text,
        children: children == null
            ? null
            : <InlineSpan>[
                for (final InlineSpan child in children) _rebuild(child),
              ],
        style: span.style,
        recognizer: span.recognizer,
        mouseCursor: span.mouseCursor,
        onEnter: span.onEnter,
        onExit: span.onExit,
        semanticsLabel: span.semanticsLabel,
        semanticsIdentifier: span.semanticsIdentifier,
        locale: span.locale,
        spellOut: span.spellOut,
      );
    }
    if (span is! PlaceholderSpan) return span;
    // Counted whatever kind of placeholder it is, so this walk stays in step
    // with the one that read the seams; only a widget has a child to glue to.
    final int i = _at++;
    final _Seam? seam = _seams[i];
    if (seam == null || span is! WidgetSpan) return span;
    return WidgetSpan(
      alignment: span.alignment,
      baseline: span.baseline,
      style: span.style,
      child: _GluedBox(
        head: seam.head,
        headStyle: seam.headStyle ?? base,
        tail: seam.tail,
        tailStyle: seam.tailStyle ?? base,
        child: span.child,
      ),
    );
  }
}

/// An inline box and the punctuation a line may not break away from it.
///
/// The punctuation renders in the style it came from and contributes only its
/// content area, exactly as [InlineBox] leaves the chip contributing only
/// its own — the line box's height stays the paragraph's business, so gluing
/// changes where lines break and never how tall they are.
class _GluedBox extends StatelessWidget {
  const _GluedBox({
    required this.head,
    required this.headStyle,
    required this.tail,
    required this.tailStyle,
    required this.child,
  });

  final String head;
  final TextStyle headStyle;
  final String tail;
  final TextStyle tailStyle;
  final Widget child;

  static Widget _punctuation(String text, TextStyle style) => LineBox(
    style: style,
    lineHeight: contentAreaHeight(style),
    child: Text(text, style: style, softWrap: false),
  );

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    children: <Widget>[
      if (head.isNotEmpty) _punctuation(head, headStyle),
      // The punctuation is the fixed part and the box is the part that gives:
      // an inline chip whose own content is wider than the column it sits in
      // — a long token at 200% text on a 320px phone — shrinks to the room
      // that is left rather than painting past the edge of the paragraph.
      Flexible(child: child),
      if (tail.isNotEmpty) _punctuation(tail, tailStyle),
    ],
  );
}
