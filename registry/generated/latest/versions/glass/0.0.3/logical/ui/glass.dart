/// Glass — `app/globals.css` L1560–1617.
///
/// A surface *in front of* the page rather than cut out of it. Three utilities,
/// one material, split by scale:
///
/// * `glass-panel` (L1563–1584) — card scale. Translucent `--card`, a backdrop
///   blur, a hairline rim of the ink colour and `--shadow-e2` beneath. The
///   page's own light shows through it, which is the whole reason to reach for
///   this over `bg-card`.
/// * `glass-panel-deep` (L1586–1609) — byte-identical to `glass-panel` except
///   its ambient layer is `--shadow-e4`.
/// * `glass-control` (L1612–1617) — control scale. A `--foreground` wash and
///   two inset layers, and nothing else: no blur, no saturate, no ambient
///   shadow. At 44px there is nothing behind it worth blurring, and `e2` under
///   something that small reads as grime rather than as depth.
///
/// **Neither needs a `dark:` variant.** Every fill and rim is
/// `color-mix(in oklab, X N%, transparent)` over `--card` or `--foreground`, so
/// a light edge on dark and a dark edge on light fall out of the same
/// expression. The top highlight is `--rim-strong` — the same token every
/// raised control carries, which is what keeps a glass card in the same world
/// as a button.
///
/// **Elevation is chosen inside the utility, not at the call site.** In CSS
/// `glass-panel shadow-e4` *does not work*: both own `box-shadow`, both are
/// Tailwind utilities, and whichever Tailwind emits later wins outright — so
/// the glass rim and the top highlight simply vanish and what is left is a
/// translucent rectangle with a drop shadow. Measured, not reasoned:
/// `getComputedStyle(panel).boxShadow` came back with no `inset` layer at all,
/// and stacking any `shadow-*` on either glass utility fails the same way.
///
/// **That failure mode does not reproduce in Flutter.** [Surface]
/// takes one [ShadowStyle] and paints every layer of it, so a caller passing
/// its own ambient could not clobber the insets. The two named variants exist
/// anyway, for two reasons that survive the port: `glass-panel-deep` needs a
/// home, and the shadows page's copy — "Two utilities, one material" — stays
/// honest only while the deep variant is a named thing rather than something a
/// call site improvises. `e4` rather than `e2` because elevation reads as a
/// ratio of object to shadow: the ambient depth that floats a 400px dialog
/// leaves a 1440px panel looking welded down.
///
/// **`overflow: hidden` is deliberately not set** (globals.css L1560–1562), so
/// nothing here clips [GlassPanel.child]. The two clips in this file are
/// structural, not stylistic: one bounds the backdrop filter to the shape,
/// which is the minimum that filter needs to exist at all, and the other keeps
/// the ambient shadow out of the border box the way CSS does — see
/// [_AmbientShadowPainter], which is the one place this port deliberately does
/// not go through `BoxDecoration`.
///
/// ## What the shadows page's specimens actually render (shadows-map §7.4)
///
/// Both glass boxes sit on an opaque `bg-background` Panel body, so **the
/// backdrop is a flat colour**: the blur is a no-op and `saturate(1.5)` on a
/// near-neutral is nearly the identity. On dark the backdrop shifts to
/// rgb(8.93, 8.93, 11.93) after the saturate, before the fill composites over
/// it. The composited results:
///
/// | specimen | dark | light |
/// |---|---|---|
/// | `glass-panel` | ≈ rgb(20, 20, 23) | white — the fill is invisible, and only the rim and `e2` describe the shape |
/// | `glass-control` | ≈ rgb(40, 40, 43) | ≈ rgb(238, 238, 238) |
///
/// Recorded because it is the answer to "why do these look inert": on that one
/// page the material is doing nothing a flat fill could not. It still belongs
/// there, because the page is documenting the utility rather than the specimen.
///
/// ## Drifts (recorded, not fixed)
///
/// * **Drift 3** — the section copy and the CSS comment (globals.css L1544)
///   both say "a 44px disc"; the specimen renders `h-12`, which is **48px**.
///   Three places, one number, and the render is 48. Supervisor ruling S8:
///   render 48, print 44. Sizing the specimen is the page's job, but this file
///   is where a reader will look for the reason.
/// * **Drift 4** — the section says "Two utilities, one material" and there are
///   three. The Panel label narrows honestly to "glass-panel and
///   glass-control"; the description does not.
library;

// ignore_for_file: unused_element

import 'dart:math' as math;
import 'dart:ui' as ui;

// `listEquals` is not among the names `widgets.dart` re-exports, so the
// foundation import is load-bearing here exactly as it is in `surface`.
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

import '../../design_system/foundation/colors.dart';
import '../../design_system/foundation/shadows.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/surfaces.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/theme_scope.dart';
import './surface.dart';

// ── Fills and rims ──────────────────────────────────────────────────────────
// `color-mix(in oklab, X N%, transparent)` resolves to X at alpha N: mixing
// toward a fully transparent colour in premultiplied oklab zeroes the other
// side's contribution and scales alpha (`colors.dart:116`, shadows-map §4). The
// alphas are named here so the utility keeps deriving its colours from the live
// theme instead of freezing two hexes per token.

/// `background-color: color-mix(in oklab, var(--card) 74%, transparent)` —
/// `glass-panel`, globals.css L1563–1584.
const double _panelFillAlpha = SurfaceOpacity.glassPanel;

/// `inset 0 0 0 1px color-mix(in oklab, var(--foreground) 12%, transparent)` —
/// the same block.
const double _panelRimAlpha = 0.12;

/// `background-color: color-mix(in oklab, var(--foreground) 7%, transparent)` —
/// `glass-control`, globals.css L1612–1617.
const double _controlFillAlpha = 0.07;

/// `inset 0 0 0 1px color-mix(in oklab, var(--foreground) 16%, transparent)` —
/// the same block. Heavier than the panel's 12% because a control has no
/// ambient shadow to describe its edge; the ring is the whole silhouette.
const double _controlRimAlpha = 0.16;

Color _panelFill(ThemeTokens t) =>
    OklabColor.mix(t.card, transparent, _panelFillAlpha);

Color _clearPanelFill(ThemeTokens t) =>
    OklabColor.mix(t.card, transparent, SurfaceOpacity.navigationGlass);

Color _controlFill(ThemeTokens t) =>
    OklabColor.mix(t.foreground, transparent, _controlFillAlpha);

Color _rimStrong(ThemeTokens t) => t.rimStrong;

Color _panelRing(ThemeTokens t) =>
    OklabColor.mix(t.foreground, transparent, _panelRimAlpha);

Color _controlRing(ThemeTokens t) =>
    OklabColor.mix(t.foreground, transparent, _controlRimAlpha);

// ── The backdrop: `@apply backdrop-blur-xl backdrop-saturate-150` ───────────

/// `backdrop-saturate-150` → `saturate(1.5)`.
const double _panelSaturation = 1.5;

/// The luminance coefficients of SVG's `feColorMatrix type="saturate"`
/// (Filter Effects §15.16), which is what CSS's `saturate()` shorthand is
/// defined as. They are constants of the transform, not a design choice —
/// changing one would stop this being `saturate()` — so they are the only
/// numbers in this file that are not derived from a token.
const double _lumR = 0.213;
const double _lumG = 0.715;
const double _lumB = 0.072;

/// CSS `saturate([s])` as a colour filter. `s` of 1 is the identity, 0 is
/// greyscale, above 1 pushes colour outward from the luminance axis.
///
/// Flutter ships no saturate filter, so it is built from the definition. The
/// matrix rows below are `feColorMatrix`'s, with the luminance vector
/// (`_lumR`, `_lumG`, `_lumB`) held fixed and each channel pulled `s` of the
/// way from that vector toward itself:
///
/// ```
///  0.213+0.787s  0.715-0.715s  0.072-0.072s  0  0
///  0.213-0.213s  0.715+0.285s  0.072-0.072s  0  0
///  0.213-0.213s  0.715-0.715s  0.072+0.928s  0  0
///  0             0             0             1  0
/// ```
///
/// At `s` = 1.5 that resolves to the matrix in shadows-map §13.5. It is
/// generated rather than pasted so the derivation stays visible and a different
/// `s` is one call away — the three coefficients are the only constants.
///
/// Two things this gets right by construction: alpha is untouched (row four is
/// the identity), and the offset column is zero, so Flutter's 0–255 scaling of
/// that column never comes into it. CSS's shorthand filter functions operate on
/// sRGB values — not the linearRGB that a bare SVG `feColorMatrix` would
/// default to — which is also the space [ui.ColorFilter.matrix] works in.
ui.ColorFilter saturate(double s) => ui.ColorFilter.matrix(<double>[
  _lumR + (1 - _lumR) * s, _lumG - _lumG * s, _lumB - _lumB * s, 0, 0, //
  _lumR - _lumR * s, _lumG + (1 - _lumG) * s, _lumB - _lumB * s, 0, 0, //
  _lumR - _lumR * s, _lumG - _lumG * s, _lumB + (1 - _lumB) * s, 0, 0, //
  0, 0, 0, 1, 0, //
]);

/// `backdrop-blur-xl backdrop-saturate-150`, composed in CSS's own order.
///
/// **No halving.** The argument of a CSS `filter: blur()` **is** the standard
/// deviation (Filter Effects §8.4), unlike `box-shadow`'s blur radius, which is
/// twice sigma and which [ShadowLayer.blurRadius] converts. So `--blur-xl`
/// goes straight into [ui.ImageFilter.blur] as sigma, exactly as the docs
/// header already does with the same token.
///
/// Tailwind emits the two functions blur-before-saturate, and CSS applies
/// filter functions left to right, so blur is the `inner` filter. (A saturate
/// matrix is a linear per-pixel transform and a blur is a linear combination of
/// pixels, so the two very nearly commute; the order is transcribed because it
/// is knowable, not because it is load-bearing.)
final ui.ImageFilter _glassBackdrop = ui.ImageFilter.compose(
  outer: saturate(_panelSaturation),
  inner: ui.ImageFilter.blur(sigmaX: Blurs.xl, sigmaY: Blurs.xl),
);

// ── The shadow specs ────────────────────────────────────────────────────────

/// `inset 0 1px 0 var(--rim-strong)` — the top highlight, carried by all three
/// utilities. Shared rather than restated so the three specs are identical
/// objects where the CSS is identical text.
const ShadowLayer _topHighlight = ShadowLayer(
  0,
  1,
  0,
  0,
  _rimStrong,
  inset: true,
);

/// `inset 0 0 0 1px …` — a **hard 1px inner ring**: no offset, no blur, 1px of
/// spread. It is the hairline rim, and it is an inset layer rather than a
/// [Border] because that is what the CSS declares and because it must sit
/// inside the shape, under nothing.
const ShadowLayer _panelRingLayer = ShadowLayer(
  0,
  0,
  0,
  1,
  _panelRing,
  inset: true,
);

const ShadowLayer _controlRingLayer = ShadowLayer(
  0,
  0,
  0,
  1,
  _controlRing,
  inset: true,
);

/// The two glass-panel insets plus whichever ambient the variant carries.
///
/// The variants differ in [ambient] and in nothing else — expressed as one
/// function of the ambient rather than two lists, so that stays structurally
/// true instead of being asserted.
ShadowStyle _panelShadow(ShadowStyle ambient) => ShadowStyle(<ShadowLayer>[
  _topHighlight,
  _panelRingLayer,
  ...ambient.layers,
]);

final ShadowStyle _panelSpec = _panelShadow(Shadows.md);
final ShadowStyle _panelDeepSpec = _panelShadow(Shadows.xl);

/// Two inset layers only — `glass-control` declares no outer shadow.
const ShadowStyle _controlSpec = ShadowStyle(<ShadowLayer>[
  _topHighlight,
  _controlRingLayer,
]);

// ── The ambient shadow, clipped out of the border box ───────────────────────

/// How far past the shape a blurred outer layer still puts ink.
///
/// The same arithmetic as `surface.dart`'s private `_ringReach`, and
/// for the same reason: a Gaussian is spent by three sigma and sigma is half
/// the CSS blur, so `1.5 × blur` would cover it and `2 × blur` is that with
/// room to spare. The offset and spread move the ink before it is blurred; the
/// floor keeps a zero-blur layer's clip off the shape's own edge.
double _shadowReach(ShadowLayer layer) =>
    layer.blur * 2 + layer.spread.abs() + layer.offset.distance + 4;

/// Everything outside [shape], out to the furthest any of [ambient] reaches.
///
/// This is the clip that makes the port obey CSS Backgrounds §7.1.1.
Path _outsideShape(RRect shape, List<ShadowLayer> ambient) {
  double reach = 0;
  for (final ShadowLayer layer in ambient) {
    reach = math.max(reach, _shadowReach(layer));
  }
  return Path.combine(
    PathOperation.difference,
    Path()..addRect(shape.outerRect.inflate(reach)),
    Path()..addRRect(shape),
  );
}

/// The non-`inset` layers of a glass spec, painted **only outside** the shape.
///
/// **Why this exists instead of `BoxDecoration.boxShadow`.** CSS Backgrounds
/// §7.1.1: an outer `box-shadow` "is not painted inside the border-box" — the
/// browser casts it as if the box were opaque and then clips the box's own area
/// out of it. Flutter does not: `BoxDecoration._paintShadows` draws each shadow
/// as a solid blurred RRect over the whole area and relies on the fill to cover
/// it. Under an opaque fill that is invisible, which is why every other surface
/// in this port is right without doing this — but `glass-panel`'s fill is
/// `--card` at 74%, so a quarter of the ambient ink was showing through the
/// middle of the panel: measured at 7/255 of grey wash on light, where §7.4
/// says the composited result is pure white.
///
/// So the ambient is lifted out of [Surface] and painted here, under a
/// clip that excludes the shape. **Do not "simplify" this back into the
/// decoration** — it will look identical on dark and wrong on light.
///
/// Within the clip this mirrors `BoxDecoration._paintShadows` exactly, radii
/// included (the shape's radius re-applied to the shifted and inflated rect,
/// rather than an [RRect] inflate that would grow the radii too), so the only
/// difference between a glass panel's ambient and any other surface's is the
/// clip itself.
class _AmbientShadowPainter extends CustomPainter {
  const _AmbientShadowPainter({
    required this.ambient,
    required this.radius,
    required this.theme,
  });

  /// The non-`inset` layers, in CSS order.
  final List<ShadowLayer> ambient;
  final BorderRadius radius;
  final ThemeTokens theme;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || ambient.isEmpty) return;
    final RRect shape = radius.toRRect(Offset.zero & size);

    canvas.save();
    canvas.clipPath(_outsideShape(shape, ambient));
    // CSS paints the first-listed shadow on top, so the list is walked
    // backwards — the same reversal `ShadowStyle.outerShadows` makes.
    for (final ShadowLayer layer in ambient.reversed) {
      final Rect bounds = shape.outerRect
          .shift(layer.offset)
          .inflate(layer.spread);
      if (bounds.isEmpty) continue;

      final Paint paint = Paint()..color = layer.color(theme);
      // `layer.blurRadius` already un-does Flutter's radius→sigma formula, so
      // putting it back through that formula lands on the CSS sigma exactly.
      final double sigma = Shadow.convertRadiusToSigma(layer.blurRadius);
      if (sigma > 0) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.normal, sigma);
      }
      canvas.drawRRect(radius.toRRect(bounds), paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_AmbientShadowPainter old) =>
      old.theme != theme ||
      old.radius != radius ||
      !listEquals(old.ambient, ambient);
}

// ── The surface ─────────────────────────────────────────────────────────────

/// The one implementation behind all three utilities.
///
/// **The layer cake, bottom to top, is CSS's own paint order:** the ambient
/// shadow (outside the shape only), the backdrop filter, the translucent fill,
/// the inset layers, the content.
///
/// **Why that is a [Stack] and not one [Surface].** Two of those
/// layers cannot go where `Surface` puts them. The blurred backdrop
/// has to land *under* the fill, so it cannot be the surface's child; and it
/// cannot be the surface's parent either, because the clip that bounds the
/// filter to the shape would take the ambient shadow with it. The ambient
/// itself has to be clipped out of the border box (see
/// [_AmbientShadowPainter]), which `BoxDecoration` cannot do. What is left for
/// `Surface` is exactly what only it can do: the inset layers, over
/// the content, in CSS's order.
class _ElGlassSurface extends StatelessWidget {
  const _ElGlassSurface({
    required this.spec,
    required this.fill,
    required this.backdrop,
    required this.radius,
    required this.padding,
    required this.child,
  });

  final ShadowStyle spec;

  /// Resolved against the live theme, like every [ShadowLayer] colour.
  final Color Function(ThemeTokens) fill;

  /// `null` for `glass-control`, which declares no `backdrop-filter`. An
  /// identity filter is not free, so it gets no [BackdropFilter] at all rather
  /// than a no-op one.
  final ui.ImageFilter? backdrop;

  final BorderRadius radius;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Widget content = padding == null
        ? child
        : Padding(padding: padding!, child: child);

    final ui.ImageFilter? filter = backdrop;
    if (filter == null) {
      // `glass-control` is the only utility with no `backdrop-filter`, and it
      // also declares no outer shadow — so one `Surface` is the whole
      // of it, and none of the machinery above is needed. The assert ties those
      // two facts together: a future backdrop-less utility that *did* carry an
      // ambient would otherwise silently get the bleeding version.
      assert(
        spec.layers.every((ShadowLayer l) => l.inset),
        'a glass utility with no backdrop must declare no outer shadow',
      );
      return Surface(
        spec: spec,
        radius: radius,
        fill: fill(theme),
        child: content,
      );
    }

    final List<ShadowLayer> ambient = <ShadowLayer>[
      for (final ShadowLayer layer in spec.layers)
        if (!layer.inset) layer,
    ];

    return Stack(
      // `passthrough` hands the incoming constraints to the sizing child
      // unchanged, so wrapping it in a Stack changes nothing about how it
      // sizes — a glass panel in a tightly-constrained box still fills that
      // box. `topLeft` rather than the default `topStart` because the alignment
      // is a no-op under `passthrough` and there is no reason to require a
      // Directionality for it. `Clip.none` because the ambient shadow paints
      // outside the stack's bounds by design.
      fit: StackFit.passthrough,
      alignment: Alignment.topLeft,
      clipBehavior: Clip.none,
      children: <Widget>[
        // 1 · the ambient, everywhere except inside the shape.
        Positioned.fill(
          child: CustomPaint(
            painter: _AmbientShadowPainter(
              ambient: ambient,
              radius: radius,
              theme: theme,
            ),
          ),
        ),
        // 2 · `backdrop-filter`, then `background-color` over it. Both are
        // clipped to the border box, which is also the clip the filter needs
        // to bound itself at all.
        Positioned.fill(
          child: ClipRRect(
            borderRadius: radius,
            child: BackdropFilter(
              filter: filter,
              child: ColoredBox(color: fill(theme)),
            ),
          ),
        ),
        // 3 · the inset layers over the content — the part only
        // `Surface` can paint. It carries no fill and no outer layers
        // here; both are already on the canvas beneath it.
        Surface(
          spec: ShadowStyle(spec.insetLayers),
          radius: radius,
          child: content,
        ),
      ],
    );
  }
}

/// `@utility glass-panel` — globals.css L1563–1584.
///
/// ```css
/// @apply backdrop-blur-xl backdrop-saturate-150;
/// background-color: color-mix(in oklab, var(--card) 74%, transparent);
/// box-shadow:
///   inset 0 1px 0 var(--rim-strong),
///   inset 0 0 0 1px color-mix(in oklab, var(--foreground) 12%, transparent),
///   var(--shadow-e2);
/// ```
///
/// [radius] is the caller's: the CSS utility sets none, and the shadows page's
/// specimen supplies `rounded-4xl`. Nothing is clipped to it except the
/// backdrop filter — see the library comment on `overflow: hidden`.
enum GlassVariant { panel, navigation, prominent, control }

/// A translucent material whose variant describes its UI job, not its recipe.
class Glass extends StatelessWidget {
  const Glass({
    super.key,
    this.variant = GlassVariant.panel,
    required this.radius,
    this.padding,
    required this.child,
  });

  final GlassVariant variant;
  final BorderRadius radius;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  @visibleForTesting
  static ShadowStyle debugShadow(GlassVariant variant) => switch (variant) {
    GlassVariant.panel || GlassVariant.navigation => _panelSpec,
    GlassVariant.prominent => _panelDeepSpec,
    GlassVariant.control => _controlSpec,
  };

  @visibleForTesting
  static Path debugAmbientClip(RRect shape, List<ShadowLayer> ambient) =>
      _outsideShape(shape, ambient);

  @visibleForTesting
  static ui.ImageFilter? debugBackdrop(GlassVariant variant) =>
      variant == GlassVariant.control ? null : _glassBackdrop;

  @visibleForTesting
  static Color debugFill(GlassVariant variant, ThemeTokens theme) =>
      switch (variant) {
        GlassVariant.panel || GlassVariant.prominent => _panelFill(theme),
        GlassVariant.navigation => _clearPanelFill(theme),
        GlassVariant.control => _controlFill(theme),
      };

  @override
  Widget build(BuildContext context) => switch (variant) {
    GlassVariant.panel => _GlassPanel(
      radius: radius,
      padding: padding,
      child: child,
    ),
    GlassVariant.navigation => _GlassPanelClear(
      radius: radius,
      padding: padding,
      child: child,
    ),
    GlassVariant.prominent => _GlassPanelDeep(
      radius: radius,
      padding: padding,
      child: child,
    ),
    GlassVariant.control => _GlassControl(
      radius: radius,
      padding: padding,
      child: child,
    ),
  };
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.radius, this.padding, required this.child});

  /// The shape. The fill, both inset layers, the ambient shadow and the
  /// backdrop clip all follow it.
  final BorderRadius radius;

  /// The utility declares none; a call site that wants inner air passes it.
  final EdgeInsetsGeometry? padding;

  final Widget child;

  /// The three-layer spec this paints, whole and in CSS order: top highlight,
  /// 1px ring, `--shadow-e2`. The split into inset and ambient happens at paint
  /// time and does not change what this returns.
  @visibleForTesting
  static ShadowStyle get debugShadow => _panelSpec;

  /// The region the ambient layers are allowed to ink, given the painted
  /// [shape] — everything outside it and nothing within.
  ///
  /// Exposed for the same reason as [Surface.debugInsetRing]: this is
  /// the one place the port departs from `BoxDecoration`, and that CSS
  /// Backgrounds §7.1.1 clip is worth pinning without a pixel read. Shared with
  /// [GlassPanelDeep]; `glass-control` has no ambient at all.
  @visibleForTesting
  static Path debugAmbientClip(RRect shape, List<ShadowLayer> ambient) =>
      _outsideShape(shape, ambient);

  /// The composed `blur(24px) saturate(1.5)`, shared with [GlassPanelDeep].
  @visibleForTesting
  static ui.ImageFilter? get debugBackdrop => _glassBackdrop;

  /// `--card` at 74%, resolved against [theme].
  @visibleForTesting
  static Color debugFill(ThemeTokens theme) => _panelFill(theme);

  @override
  Widget build(BuildContext context) => _ElGlassSurface(
    spec: _panelSpec,
    fill: _panelFill,
    backdrop: _glassBackdrop,
    radius: radius,
    padding: padding,
    child: child,
  );
}

/// A clearer card-scale glass panel for floating navigation chrome.
///
/// Geometry, backdrop blur/saturation, rim, highlight and `e2` ambient are
/// identical to [GlassPanel]. Only the foundation-owned fill opacity is
/// lower, so content moving beneath remains visibly present through the blur.
class _GlassPanelClear extends StatelessWidget {
  const _GlassPanelClear({
    required this.radius,
    this.padding,
    required this.child,
  });

  final BorderRadius radius;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  /// The same highlight, ring and `e2` ambient as [GlassPanel].
  @visibleForTesting
  static ShadowStyle get debugShadow => _panelSpec;

  /// The same CSS-correct ambient exclusion as [GlassPanel].
  @visibleForTesting
  static Path debugAmbientClip(RRect shape, List<ShadowLayer> ambient) =>
      _outsideShape(shape, ambient);

  /// The same composed blur and saturation as [GlassPanel].
  @visibleForTesting
  static ui.ImageFilter? get debugBackdrop => _glassBackdrop;

  /// The live theme's card colour at the navigation-glass opacity.
  @visibleForTesting
  static Color debugFill(ThemeTokens theme) => _clearPanelFill(theme);

  @override
  Widget build(BuildContext context) => _ElGlassSurface(
    spec: _panelSpec,
    fill: _clearPanelFill,
    backdrop: _glassBackdrop,
    radius: radius,
    padding: padding,
    child: child,
  );
}

/// `@utility glass-panel-deep` — globals.css L1586–1609.
///
/// Byte-identical to [GlassPanel] except the ambient layer is
/// `var(--shadow-e4)` instead of `var(--shadow-e2)`. Same fill, same rim, same
/// top highlight, same backdrop.
///
/// It is a separate utility rather than a parameter because in CSS it had to
/// be — see the library comment. Here it stays one because the elevation is a
/// property of the surface's scale, not of the call site's mood.
class _GlassPanelDeep extends StatelessWidget {
  const _GlassPanelDeep({
    required this.radius,
    this.padding,
    required this.child,
  });

  /// The shape. The fill, both inset layers, the ambient shadow and the
  /// backdrop clip all follow it.
  final BorderRadius radius;

  /// The utility declares none; a call site that wants inner air passes it.
  final EdgeInsetsGeometry? padding;

  final Widget child;

  /// [GlassPanel.debugShadow] with `--shadow-e4`'s layers in place of
  /// `--shadow-e2`'s. The first two layers are the same objects.
  @visibleForTesting
  static ShadowStyle get debugShadow => _panelDeepSpec;

  /// See [GlassPanel.debugAmbientClip] — the same clip, a deeper ambient.
  @visibleForTesting
  static Path debugAmbientClip(RRect shape, List<ShadowLayer> ambient) =>
      _outsideShape(shape, ambient);

  /// The composed `blur(24px) saturate(1.5)`, shared with [GlassPanel].
  @visibleForTesting
  static ui.ImageFilter? get debugBackdrop => _glassBackdrop;

  /// `--card` at 74%, resolved against [theme].
  @visibleForTesting
  static Color debugFill(ThemeTokens theme) => _panelFill(theme);

  @override
  Widget build(BuildContext context) => _ElGlassSurface(
    spec: _panelDeepSpec,
    fill: _panelFill,
    backdrop: _glassBackdrop,
    radius: radius,
    padding: padding,
    child: child,
  );
}

/// `@utility glass-control` — globals.css L1612–1617.
///
/// ```css
/// background-color: color-mix(in oklab, var(--foreground) 7%, transparent);
/// box-shadow:
///   inset 0 1px 0 var(--rim-strong),
///   inset 0 0 0 1px color-mix(in oklab, var(--foreground) 16%, transparent);
/// ```
///
/// **No blur, no saturate, no outer shadow — two inset layers only.** The
/// reference's own reason: at 44px there is nothing behind it worth blurring,
/// and `e2` under something that small reads as grime rather than as depth.
/// So this mounts no [BackdropFilter] and no [Stack]; it is a
/// [Surface] and nothing else.
class _GlassControl extends StatelessWidget {
  const _GlassControl({
    required this.radius,
    this.padding,
    required this.child,
  });

  /// The shape. Both inset layers follow it. The shadows page's specimen is a
  /// `rounded-pill` stadium.
  final BorderRadius radius;

  /// The utility declares none; the specimen's `px-4` is the call site's.
  final EdgeInsetsGeometry? padding;

  final Widget child;

  /// Two inset layers, no ambient: the top highlight and the 1px ring.
  @visibleForTesting
  static ShadowStyle get debugShadow => _controlSpec;

  /// Always `null` — the utility declares no `backdrop-filter`, so no
  /// [BackdropFilter] is mounted.
  @visibleForTesting
  static ui.ImageFilter? get debugBackdrop => null;

  /// `--foreground` at 7%, resolved against [theme].
  @visibleForTesting
  static Color debugFill(ThemeTokens theme) => _controlFill(theme);

  @override
  Widget build(BuildContext context) => _ElGlassSurface(
    spec: _controlSpec,
    fill: _controlFill,
    backdrop: null,
    radius: radius,
    padding: padding,
    child: child,
  );
}
