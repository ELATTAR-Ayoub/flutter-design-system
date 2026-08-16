/// `components/ui/avatar.tsx` — the circle, its rim, and the initials behind it.
///
/// Ported because `NavUser` cannot be built without it: the sidebar footer's
/// account row is an avatar, two lines of text and a chevron, and the avatar is
/// the only one of the three that had no widget.
///
/// **Scope.** `Avatar`, `AvatarImage` and `AvatarFallback` for the sidebar
/// family; `AvatarBadge`, `AvatarGroup` and `AvatarGroupCount` were recorded
/// as consumer-less here until the **data page**'s §Avatar arrived, and they
/// are built below it.
///
/// **`data-size` and `className="size-N"` are two different things**, and the
/// data page is where it shows: every one of its avatars reports
/// `data-size="default"` while wearing `size-6`, `size-8`, `size-10` and
/// `size-12`. The attribute drives the *fallback's* type rung and the
/// *badge's* diameter through `group-data-[size=…]` selectors; the class
/// drives only the box. That is why [DsAvatar.sizePx] exists beside
/// [DsAvatar.size] — the same split `DsIcon.sizePx` carries.
///
/// **The rim is a blended ring, and that is the whole trick.** Stock shadcn
/// draws no border at all. This system adds
/// `after:absolute after:inset-0 after:rounded-full after:border
/// after:border-border after:mix-blend-darken dark:after:mix-blend-lighten`,
/// so the hairline *darkens* whatever it sits on in light and *lightens* it in
/// dark — a rim that reads on a photograph and on a flat fill alike, without
/// ever being a solid line drawn over the subject. *(Measured on the sidebar
/// footer, dark, 2026-08-16: `border-top-width: 1px`, colour `rgb(39, 39, 42)`
/// — `--border` — and `mix-blend-mode: lighten`.)*
///
/// The ring is painted as one `drawDRRect`, per the painter rule: an outer
/// round-rect minus the inner one, in a single path, so a blur or a blend never
/// sees two overlapping shapes. A `Border` inside a `DecoratedBox` could not
/// carry the blend mode at all.
library;

import 'package:flutter/widgets.dart';

import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';

/// `Avatar size` — the cva's three rungs.
enum DsAvatarSize {
  /// `data-[size=sm]:size-6` — 24px.
  sm,

  /// `size-8` — 32px. The cva's own default, and the only rung the corpus
  /// renders today.
  md,

  /// `data-[size=lg]:size-10` — 40px.
  lg;

  /// The circle's diameter.
  double get px => switch (this) {
        DsAvatarSize.sm => ds(6),
        DsAvatarSize.md => ds(8),
        DsAvatarSize.lg => ds(10),
      };

  /// `group-data-[size=default]/avatar:size-2.5` and its two siblings — the
  /// diameter an [DsAvatarBadge] takes under this rung.
  double get badge => switch (this) {
        DsAvatarSize.sm => ds(2),
        DsAvatarSize.md => ds(2.5),
        DsAvatarSize.lg => ds(3),
      };
}

/// A `ring-2 ring-<colour>` hung on an avatar by its call site.
///
/// Two sites on the data page: the leaderboard leader's `ring-value` — *"one
/// of lime's permitted jobs"* — and the group's
/// `*:data-[slot=avatar]:ring-2 ring-background`, which is what lets four
/// circles overlap and still read as four. Both are **outset**: `box-shadow:
/// 0 0 0 2px`, painted outside the border box and costing the layout nothing,
/// which is why a 40px avatar wearing one still measures 40.
typedef DsAvatarRing = ({Color color, double width});

/// `ring-2` — the width both ring sites use.
double get dsAvatarRingWidth => 2;

/// A round identity mark: [image] if it loads, initials underneath if it does
/// not.
class DsAvatar extends StatelessWidget {
  const DsAvatar({
    super.key,
    required this.fallback,
    this.image,
    this.size = DsAvatarSize.md,
    this.fallbackSpec,
    this.sizePx,
    this.ring,
    this.badge,
    this.fallbackFill,
    this.fallbackInk,
  });

  /// `AvatarFallback`'s content — the initials, already computed.
  final String fallback;

  /// `AvatarImage src`. Null renders the fallback outright, which is what
  /// Radix does while an image is missing or still loading.
  final ImageProvider<Object>? image;

  final DsAvatarSize size;

  /// The fallback's resolved type.
  ///
  /// Defaults to [DsComponentType.textSm] — a bare `<AvatarFallback>` is
  /// `text-sm` with no weight class, so it inherits `html`'s 400.
  ///
  /// The two other rungs override the size (`group-data-[size=sm]:text-tag`
  /// 10px, `group-data-[size=lg]:text-body` 15px) and neither has a consumer
  /// in the corpus, so neither is built into the default: a caller that wants
  /// one states it, exactly as `NavUser` states
  /// [DsComponentType.avatarFallback] for its own `.type-num-sm` collision.
  final DsTypeSpec? fallbackSpec;

  /// `className="size-N"` — the box, when the class beats the attribute. The
  /// data page's four sizes are all this rather than [size].
  final double? sizePx;

  /// `className="ring-2 ring-<colour>"`.
  final DsAvatarRing? ring;

  /// `<AvatarBadge/>` — `absolute right-0 bottom-0 z-10`.
  final DsAvatarBadge? badge;

  /// Overrides `bg-muted` — the leader's `bg-value/12`.
  final Color? fallbackFill;

  /// Overrides `text-muted-foreground` — the leader's `text-value-ink`.
  final Color? fallbackInk;

  /// The resolved diameter: the class, or the attribute's rung.
  double get diameter => sizePx ?? size.px;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final double px = diameter;

    // `rounded-full` on a square: half the side, which is what a 9999px radius
    // resolves to once the box is known.
    final BorderRadius radius = BorderRadius.circular(px / 2);

    // `flex size-full items-center justify-center rounded-full bg-muted
    // text-muted-foreground`.
    final Widget content = DecoratedBox(
      decoration: BoxDecoration(
        color: fallbackFill ?? theme.muted,
        borderRadius: radius,
      ),
      child: Center(
        child: DsText(
          fallback,
          fallbackSpec ?? DsComponentType.textSm,
          color: fallbackInk ?? theme.mutedForeground,
        ),
      ),
    );

    Widget circle = SizedBox(
      width: px,
      height: px,
      child: Stack(
        // The badge hangs on the corner and its ring reaches past it.
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: <Widget>[
          content,
          if (image != null)
            // `aspect-square size-full rounded-full object-cover`.
            ClipRRect(
              borderRadius: radius,
              child: Image(image: image!, fit: BoxFit.cover),
            ),
          // `after:` — painted last, over both.
          IgnorePointer(
            child: CustomPaint(
              painter: DsAvatarRimPainter(
                color: theme.border,
                lighten: theme.kind == DsThemeKind.dark,
              ),
            ),
          ),
          if (badge != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: _AvatarBadgeBox(size: size, badge: badge!),
            ),
        ],
      ),
    );

    if (ring != null) {
      circle = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: DsShadowSpec(<DsShadowLayer>[
            DsShadowLayer(0, 0, 0, ring!.width, (DsThemeData _) => ring!.color),
          ]).outerShadows(theme),
        ),
        child: circle,
      );
    }
    return circle;
  }
}

/// `<AvatarBadge/>` — the status dot in the bottom-right corner.
///
/// `absolute right-0 bottom-0 z-10 inline-flex items-center justify-center
/// rounded-full bg-primary text-primary-foreground bg-blend-color ring-2
/// ring-background`. A value, not a widget: its diameter comes from the
/// avatar's `data-size` through [DsAvatarSize.badge], exactly as the
/// `group-data-[size=…]` selectors decide it.
///
/// **Not ported:** `bg-blend-color`, which needs a second background layer to
/// blend with and the element has one flat fill; and the
/// `group-data-[size=sm]:[&>svg]:hidden` rule, which needs a glyph and no
/// badge in the corpus has one.
class DsAvatarBadge {
  const DsAvatarBadge({required this.fill, this.child});

  /// `bg-primary` is the class list's default and every call site overrides
  /// it (`bg-value` on the data page), so it is required rather than
  /// defaulted.
  final Color fill;

  /// The glyph inside, sized by the avatar's rung. Null at every corpus site.
  final Widget? child;
}

class _AvatarBadgeBox extends StatelessWidget {
  const _AvatarBadgeBox({required this.size, required this.badge});

  final DsAvatarSize size;
  final DsAvatarBadge badge;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final double diameter = size.badge;
    final BorderRadius shape = BorderRadius.circular(diameter / 2);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        // `ring-2 ring-background` — outset, so the dot keeps its 10px box.
        boxShadow: DsShadowSpec(<DsShadowLayer>[
          DsShadowLayer(
            0,
            0,
            0,
            dsAvatarRingWidth,
            (DsThemeData t) => t.background,
          ),
        ]).outerShadows(theme),
      ),
      child: Container(
        width: diameter,
        height: diameter,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: badge.fill, borderRadius: shape),
        child: badge.child,
      ),
    );
  }
}

/// `<AvatarGroup>` — `flex -space-x-2`, with `ring-2 ring-background` forced
/// onto every avatar in it.
///
/// **The overlap is a negative margin, and Flutter has no such thing.** Each
/// child after the first is drawn 8px left of where the row placed it, which
/// puts every circle at the reference's own x — measured 325 / 349 / 373 / 397
/// for four 32px avatars, a 24px pitch, with the `+248` count at 421. What
/// that does *not* reproduce is the row's own width: the translated children
/// still hold their untranslated slots, so this box is `overlap × (n − 1)`
/// wider than the CSS one. Invisible here, and stated rather than worked
/// around, because the group is a block-level flex container and measures the
/// full column width in the reference too.
class DsAvatarGroup extends StatelessWidget {
  const DsAvatarGroup({super.key, required this.children});

  /// The avatars, then optionally a [DsAvatarGroupCount] last.
  final List<Widget> children;

  /// `-space-x-2` — 8px of overlap per neighbour.
  static double get overlap => ds(2);

  /// The ring the group forces onto each child.
  static DsAvatarRing ringOf(BuildContext context) =>
      (color: DsTheme.of(context).background, width: dsAvatarRingWidth);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < children.length; i++)
            Transform.translate(
              offset: Offset(-overlap * i, 0),
              child: children[i],
            ),
        ],
      );
}

/// `<AvatarGroupCount>` — `relative flex size-8 shrink-0 items-center
/// justify-center rounded-full bg-muted text-sm text-muted-foreground ring-2
/// ring-background`.
///
/// Not an avatar: it has no `::after` rim and no `data-size` of its own — it
/// reads the *group's* through `group-has-data-[size=…]/avatar-group`, which
/// on the data page resolves to the default 32px rung.
class DsAvatarGroupCount extends StatelessWidget {
  const DsAvatarGroupCount(this.label, {super.key, this.spec});

  final String label;

  /// The `.type-*` class stacked on `text-sm`; null is the bare utility.
  final DsTypeSpec? spec;

  /// `size-8` at the group's default rung.
  static double get diameter => ds(8);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final BorderRadius shape = BorderRadius.circular(diameter / 2);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: DsShadowSpec(<DsShadowLayer>[
          DsShadowLayer(
            0,
            0,
            0,
            dsAvatarRingWidth,
            (DsThemeData t) => t.background,
          ),
        ]).outerShadows(theme),
      ),
      child: Container(
        width: diameter,
        height: diameter,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: theme.muted, borderRadius: shape),
        child: DsText(
          label,
          spec ?? DsComponentType.textSm,
          color: theme.mutedForeground,
        ),
      ),
    );
  }
}

/// The `after:` hairline: one `drawDRRect` ring in `--border`, blended.
class DsAvatarRimPainter extends CustomPainter {
  const DsAvatarRimPainter({required this.color, required this.lighten});

  final Color color;

  /// `dark:after:mix-blend-lighten` against the light theme's
  /// `after:mix-blend-darken`.
  final bool lighten;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect outer = Offset.zero & size;
    final Radius corner = Radius.circular(size.shortestSide / 2);
    final RRect ring = RRect.fromRectAndRadius(outer, corner);
    // `border` is inside the box — `box-sizing: border-box` — so the inner
    // edge is one hairline in on every side, and the inner radius is what CSS
    // derives for it.
    final RRect hole = RRect.fromRectAndRadius(
      outer.deflate(DsWidths.hairline),
      Radius.circular(corner.x - DsWidths.hairline),
    );
    canvas.drawDRRect(
      ring,
      hole,
      Paint()
        ..color = color
        ..blendMode = lighten ? BlendMode.lighten : BlendMode.darken,
    );
  }

  @override
  bool shouldRepaint(DsAvatarRimPainter old) =>
      old.color != color || old.lighten != lighten;
}
