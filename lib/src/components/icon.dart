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
import 'icon_paths.g.dart';

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
  xl3;

  /// The key this rung is spelled with in `ICON_SIZES`, and therefore the
  /// string the icons page prints beside each specimen.
  ///
  /// Not `name`: `ICON_SIZES` keys the top two rungs **`2xl`** and **`3xl`**,
  /// and a Dart identifier cannot start with a digit, so this enum spells them
  /// [xl2] and [xl3]. That rename is a Dart constraint, not a design decision,
  /// and it must not leak into rendered copy — which is the whole reason this
  /// mapping exists rather than a `.name` call at the call site.
  String get label => switch (this) {
        DsIconSize.xs => 'xs',
        DsIconSize.sm => 'sm',
        DsIconSize.md => 'md',
        DsIconSize.lg => 'lg',
        DsIconSize.xl => 'xl',
        DsIconSize.xl2 => '2xl',
        DsIconSize.xl3 => '3xl',
      };
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
  inherit;

  /// The key this tone is spelled with in `ICON_TONES`, and therefore the
  /// string the icons page prints beside each swatch.
  ///
  /// Not `name`: `ICON_TONES`'s first key is **`default`**, which is a Dart
  /// reserved word, so this enum spells it [normal]. Same rule as
  /// [DsIconSize.label] — the rename is a language constraint and must not
  /// reach rendered copy.
  ///
  /// [muted] and [subtle] return different strings for the same colour on
  /// purpose; see [subtle]'s own doc for why the two names exist.
  String get label => switch (this) {
        DsIconTone.normal => 'default',
        DsIconTone.muted => 'muted',
        DsIconTone.subtle => 'subtle',
        DsIconTone.action => 'action',
        DsIconTone.value => 'value',
        DsIconTone.success => 'success',
        DsIconTone.warning => 'warning',
        DsIconTone.info => 'info',
        DsIconTone.error => 'error',
        DsIconTone.inherit => 'inherit',
      };
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
  }) : lucide = null;

  /// The same widget, over the **generated** registry rather than the curated
  /// enum.
  ///
  /// [DsIconGlyph] is the icons page's own whitelist — the glyphs that page
  /// prints and names. Every other page reaches for lucide directly, and until
  /// the chat family there was no call site that needed one outside the
  /// whitelist. `chat/page.tsx` imports seven (`BotIcon`, `CircleAlertIcon`,
  /// `FileTextIcon`, `ImageIcon`, `SheetIcon`, `UserIcon`, `XIcon`) and
  /// `message-scroller.tsx` an eighth (`ArrowDownIcon`); five of the eight are
  /// not on the whitelist and never will be, because the whitelist is a
  /// transcript of one page's registry rather than a budget.
  ///
  /// So this constructor takes a [DsLucideGlyph] from `icon_paths.g.dart` and
  /// paints it through exactly the same [paintGlyph] the enum path uses — same
  /// 24-unit space, same stroke formula, same clip. Nothing about the render is
  /// different; only where the geometry was looked up.
  const DsIcon.lucide(
    DsLucideGlyph this.lucide, {
    super.key,
    this.size = DsIconSize.md,
    this.tone = DsIconTone.inherit,
    this.sizePx,
    this.strokeOverride,
    this.label,
  }) : glyph = null;

  /// The curated glyph, or null when [lucide] carries the geometry.
  final DsIconGlyph? glyph;

  /// The generated-registry glyph, or null when [glyph] does.
  final DsLucideGlyph? lucide;

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

  /// Paints one glyph into [size], the way lucide's `<svg>` wrapper does.
  ///
  /// [path] and [fill] are in lucide's 24-unit space ([DsIconPaths.viewBox]);
  /// so is [strokeWidth], exactly as the SVG `stroke-width` attribute is — the
  /// canvas scale converts it, which is what a browser does when it fits a
  /// `viewBox` into a smaller box.
  ///
  /// **The clip is the `<svg>` viewport.** An outermost `<svg>` clips to its
  /// own box by default (`overflow: hidden`), and one glyph in lucide 1.28.0
  /// needs it: `save-off`'s sixth node is `"M29.5 11.5s5 5 4 5"`, a stroke that
  /// runs from x = 29.5 to x = 34.5, entirely outside the `viewBox="0 0 24 24"`
  /// its other six nodes are drawn in. It is an upstream defect, the browser
  /// hides it by clipping, and the generated registry reproduces it verbatim
  /// because a transcript that quietly repairs its source is not a transcript.
  /// Measured over all 1756 glyphs, `save-off` is the only one that leaves the
  /// grid (by 10.5 units); the runner-up touches x = 24 and no further. So this
  /// is a `clipRect`, matching the browser's rule, and not a special case for
  /// one glyph.
  ///
  /// It is [Canvas.clipRect] rather than a path intersection on purpose: the
  /// stroke and fill passes stay two plain `drawPath` calls on the geometry
  /// lucide ships. Nothing here combines paths and nothing blurs one.
  ///
  /// Public and [visibleForTesting] because the clip is only provable in
  /// rendered pixels, and the glyph that proves it lives in the generated
  /// registry rather than in [DsIconGlyph].
  @visibleForTesting
  static void paintGlyph(
    Canvas canvas,
    Size size, {
    required Path path,
    required Color color,
    required double strokeWidth,
    Path? fill,
  }) {
    if (size.isEmpty) return;
    canvas.save();
    canvas.scale(
        size.width / DsIconPaths.viewBox, size.height / DsIconPaths.viewBox);
    canvas.clipRect(
      const Rect.fromLTWH(0, 0, DsIconPaths.viewBox, DsIconPaths.viewBox),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        // lucide's own SVG attributes: `stroke-linecap="round"`,
        // `stroke-linejoin="round"`, `fill="none"`.
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    // Second pass: the nodes that override `fill="none"` with
    // `fill="currentColor"`. A node that sets `fill` keeps the inherited
    // `stroke`, so this paints *over* the stroke pass rather than instead of
    // it — the same two operations, in the same order, a browser performs for
    // `<circle … fill="currentColor">` inside lucide's `<svg>`. `tag`'s
    // 0.5-unit dot is the only one in the embedded set; every other glyph
    // skips this entirely because [DsIconPaths.fillPathFor] returns null.
    if (fill != null) {
      canvas.drawPath(fill, Paint()..color = color);
    }
    canvas.restore();
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
          lucide: lucide,
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
    required this.lucide,
    required this.color,
    required this.strokeWidth,
  });

  final DsIconGlyph? glyph;
  final DsLucideGlyph? lucide;
  final Color color;

  /// In lucide's 24-unit space, exactly as the SVG `stroke-width` attribute
  /// is — the canvas scale below converts it, which is what the browser does
  /// when it fits a `viewBox` into a smaller box.
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) => DsIcon.paintGlyph(
        canvas,
        size,
        path: glyph != null
            ? DsIconPaths.pathFor(glyph!)
            : lucide!.toPath(),
        fill: glyph != null
            ? DsIconPaths.fillPathFor(glyph!)
            : lucide!.toFillPath(),
        color: color,
        strokeWidth: strokeWidth,
      );

  @override
  bool shouldRepaint(_GlyphPainter old) =>
      old.glyph != glyph ||
      old.lucide != lucide ||
      old.color != color ||
      old.strokeWidth != strokeWidth;
}
