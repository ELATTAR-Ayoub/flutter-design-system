/// The one way icons enter the product — `components/ui/icon.tsx`.
///
/// Lucide is the source set, but it is never reached for directly. Going
/// through this widget guarantees the three things that component's own
/// docstring requires: a size from a fixed ladder, a tone from the token
/// palette, and a decision about accessibility on every instance — an icon
/// either has a label and is announced, or has none and is hidden.
///
/// The web renders lucide's React components, which are `<svg>` elements. Here
/// the geometry is embedded (see `icon_paths.dart`) and stroked directly, so
/// there is no icon font and no glyph-hinting to fight — the design spec's one
/// noted upside over the previous build.
library;

import 'package:flutter/widgets.dart';

import '../foundation/theme.dart';
import '../theme_scope.dart';
import 'icon_paths.dart';

/// `ICON_SIZES` — the fixed ladder, in px.
///
/// Named for Tailwind's own size steps; `xl2`/`xl3` are the `2xl`/`3xl` keys
/// spelled the way Dart allows.
enum DsIconSize {
  /// 12px.
  xs,

  /// 14px.
  sm,

  /// 16px — the default.
  md,

  /// 20px.
  lg,

  /// 24px.
  xl,

  /// 32px — `2xl`.
  xl2,

  /// 40px — `3xl`.
  xl3,
}

/// `ICON_TONES` — every tone maps to a token, never to a raw colour.
enum DsIconTone {
  /// `text-foreground`. Primary text.
  normal,

  /// `text-muted-foreground`. Secondary text — most icons beside body copy.
  muted,

  /// `text-muted-foreground` as well. A separate name because metadata and
  /// decorative affordances are a different *intent*, and the two are free to
  /// diverge later without a rename at every call site.
  subtle,

  /// `text-action-ink`. Interactive, selected, active.
  action,

  /// `text-value-ink`. Reward, premium, ranking — worth.
  value,

  /// `text-success-ink`.
  success,

  /// `text-warning-ink`.
  warning,

  /// `text-info-ink`.
  info,

  /// `text-destructive-ink`.
  error,

  /// `text-current` — the colour of whatever contains it. The **default**,
  /// for use inside buttons.
  inherit,
}

/// The stroke lucide draws its 24-unit grid for.
const double _authoredStroke = 2;

/// The two rungs the ternary in `icon.tsx` snaps to, and its two thresholds.
const double _heavyStroke = 2.4;
const double _lightStroke = 1.6;
const double _heavyAbove = 2.6;
const double _lightBelow = 1.5;

/// One lucide glyph, stroked at a size and tone from the ladder.
class DsIcon extends StatelessWidget {
  const DsIcon(
    this.glyph, {
    super.key,
    this.size = DsIconSize.md,
    this.tone = DsIconTone.inherit,
    this.sizePx,
    this.strokeOverride,
    this.label,
  });

  final DsIconGlyph glyph;

  /// A rung of the ladder. Ignored when [sizePx] is given.
  final DsIconSize size;

  final DsIconTone tone;

  /// An off-ladder px size.
  ///
  /// Exists because the reference has an off-ladder instance and ships it:
  /// the overview's group cards render `<Icon icon={ArrowRight} size="md"
  /// className="size-5">`, where the class beats the attribute and the arrow
  /// comes out **20px carrying md's 2.4 stroke** — which `size="lg"` would not
  /// produce. That quirk is kept, so the escape hatch has to exist.
  final double? sizePx;

  /// Overrides [strokeFor]. The theme toggle needs it: it renders its three
  /// lucide components directly at 14px with lucide's default stroke 2, not
  /// through this component's formula, which would give 2.4.
  final double? strokeOverride;

  /// The accessible name. Provide it when the icon is the only thing carrying
  /// meaning; omit it when adjacent text already says the same, and the icon
  /// is hidden from assistive tech.
  final String? label;

  /// `ICON_SIZES[size]`.
  static double pxFor(DsIconSize size) => switch (size) {
        DsIconSize.xs => 12,
        DsIconSize.sm => 14,
        DsIconSize.md => 16,
        DsIconSize.lg => 20,
        DsIconSize.xl => 24,
        DsIconSize.xl2 => 32,
        DsIconSize.xl3 => 40,
      };

  /// The `strokeWidth` the reference computes for a glyph rendered at [px].
  ///
  /// A transcript of one expression in `icon.tsx`:
  ///
  /// ```tsx
  /// strokeWidth={(2 * 24) / px > 2.6 ? 2.4 : (2 * 24) / px < 1.5 ? 1.6 : 2}
  /// ```
  ///
  /// Read it carefully: the middle branch is a **literal 2**, not the raw
  /// `48/px`. It is a three-rung snap (2.4 / 2 / 1.6), not a clamp — so the
  /// ladder comes out 2.4, 2.4, 2.4, **2, 2, 2**, 1.6, where a clamp reading
  /// would give 2.4, 2, 1.5 for the top three. The comment above it explains
  /// why it exists at all: *"Lucide's 24px grid is drawn for a 2px stroke.
  /// Scaling the stroke with the box keeps optical weight even across the size
  /// ladder."*
  static double strokeFor(double px) {
    final double scaled = (_authoredStroke * DsIconPaths.viewBox) / px;
    if (scaled > _heavyAbove) return _heavyStroke;
    if (scaled < _lightBelow) return _lightStroke;
    return _authoredStroke;
  }

  /// The token [tone] resolves to in [context].
  ///
  /// [DsIconTone.inherit] is `text-current`: it takes the colour of the
  /// surrounding text, which in Flutter is the nearest [DefaultTextStyle] —
  /// how a `DsButton` colours the icon inside it — falling back to
  /// `--foreground`, the colour `<body>` sets.
  static Color colorFor(BuildContext context, DsIconTone tone) {
    final DsThemeData theme = DsTheme.of(context);
    return switch (tone) {
      DsIconTone.normal => theme.foreground,
      DsIconTone.muted || DsIconTone.subtle => theme.mutedForeground,
      DsIconTone.action => theme.actionInk,
      DsIconTone.value => theme.valueInk,
      DsIconTone.success => theme.successInk,
      DsIconTone.warning => theme.warningInk,
      DsIconTone.info => theme.infoInk,
      DsIconTone.error => theme.destructiveInk,
      DsIconTone.inherit =>
        DefaultTextStyle.of(context).style.color ?? theme.foreground,
    };
  }

  @override
  Widget build(BuildContext context) {
    final double px = sizePx ?? pxFor(size);
    final Widget painted = SizedBox(
      width: px,
      height: px,
      child: CustomPaint(
        painter: _GlyphPainter(
          glyph: glyph,
          color: colorFor(context, tone),
          strokeWidth: strokeOverride ?? strokeFor(px),
        ),
      ),
    );

    if (label == null) return ExcludeSemantics(child: painted);
    return Semantics(label: label, image: true, child: painted);
  }
}

class _GlyphPainter extends CustomPainter {
  _GlyphPainter({
    required this.glyph,
    required this.color,
    required this.strokeWidth,
  });

  final DsIconGlyph glyph;
  final Color color;

  /// In lucide's 24-unit space, exactly as the SVG `stroke-width` attribute
  /// is — the canvas scale below converts it, which is what the browser does
  /// when it fits a `viewBox` into a smaller box.
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    canvas.save();
    canvas.scale(size.width / DsIconPaths.viewBox,
        size.height / DsIconPaths.viewBox);
    canvas.drawPath(
      DsIconPaths.pathFor(glyph),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        // lucide's own SVG attributes: `stroke-linecap="round"`,
        // `stroke-linejoin="round"`, `fill="none"`.
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_GlyphPainter old) =>
      old.glyph != glyph ||
      old.color != color ||
      old.strokeWidth != strokeWidth;
}
