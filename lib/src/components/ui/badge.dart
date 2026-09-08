/// `components/ui/badge.tsx` — a chip, not a button.
///
/// **Simplified, deliberately, from the reference.** The reference's own
/// `badge.tsx` docstring called for `ramp-chip` (a light-from-above
/// gradient) and `shadow-chip` (the machine shadow family's badge entry) on
/// every filled variant, `premium` wearing `shadow-btn-value` instead. This
/// port shipped that once; the project owner asked for it gone — *"no need
/// for the gradient and shadow for the badges, make them simple"* — so every
/// variant, `premium` included, is now a flat fill in its own colour with no
/// ramp layer and no elevation. `Shadows`/`Surface` no longer factor into
/// this file at all.
///
/// Measured open on the dialogs page's media dialog (2026-08-16, 1440x900):
/// `h-5` is a **hard 20px border box**, `px-2 py-0.5` inside a 1px transparent
/// border, `rounded-pill`, and the label is `text-xs font-medium` — 12px at
/// 500 in a 16px line box, which is *taller than the 14px content box the
/// padding leaves*. The chip does not grow: `h-5` wins and the line box is
/// centred and clipped by `overflow-hidden`. That is why this widget sizes
/// itself rather than letting its text do it.
///
/// **Not ported:** `asChild`, the `[a]:hover:` rules (every hover selector in
/// the cva is scoped to an anchor, and no badge in the corpus is a link),
/// `transition-all`, `focus-visible:` and `aria-invalid:` — a `<span>` takes
/// none of them. The `has-data-[icon=inline-*]` padding trims are
/// **unreachable**: the data page's *"With glyphs"* row is the corpus's one
/// icon call site (see [Badge.glyph]) and all five chips there measure the
/// full `px-2`, because `Icon` writes no `data-icon` for the selector to find.
library;

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
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';

/// `bg-<hue>/12` — the tint every semantic variant is filled with.
const double _tintAlpha = 0.12;

/// `badgeVariants` — the cva's ten, in its own order.
enum BadgeVariant {
  /// `bg-primary text-primary-foreground`, a flat fill.
  ///
  /// Named [primary] because `default` is a Dart keyword, the same rename
  /// `ButtonVariant.primary` carries.
  primary,

  /// `bg-secondary text-secondary-foreground`, a flat fill.
  secondary,

  /// `bg-destructive/12 text-destructive-ink`, a flat fill.
  destructive,

  /// `border-input text-muted-foreground` — no fill.
  outline,

  /// `text-muted-foreground` and nothing else at rest.
  ghost,

  /// `text-action-ink underline-offset-4` — the underline is a hover rule, so
  /// at rest this is coloured text in a pill-shaped box.
  link,

  /// *"Added for this system."* `bg-action/12 text-action-ink`, a flat fill —
  /// the media dialog's "New release".
  action,

  /// `bg-value/12 text-value-ink` — *"the lime one, used for Featured,
  /// Limited and anything carrying value — the only badge that gets the lime
  /// cast under it, because lime is worth."*
  premium,

  /// `bg-success/12 text-success-ink`, a flat fill.
  success,

  /// `bg-warning/12 text-warning-ink`, a flat fill.
  warning,

  /// `bg-info/12 text-info-ink`, a flat fill.
  info;

  /// Whether the variant is filled — and therefore whether it carries a
  /// `_fill` colour at all.
  bool get filled => switch (this) {
    BadgeVariant.outline || BadgeVariant.ghost || BadgeVariant.link => false,
    _ => true,
  };
}

/// A chip. 20px tall, pill-shaped, sized to its label.
class Badge extends StatelessWidget {
  const Badge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.primary,
    this.spec,
    this.paddingX,
    this.minWidth,
    this.glyph,
  });

  final String label;

  final BadgeVariant variant;

  /// Overrides [TextStyles.badge].
  ///
  /// `SidebarMenuBadge` writes `.type-num-xs` onto the chip, which resolves to
  /// [TextStyles.numberSm] rather than to the class it names —
  /// see that spec for the cascade. The [FieldLabel] `spec:` precedent
  /// (ruling S4): a resolved style the component cannot derive is a prop, not
  /// a branch.
  final TextStyleToken? spec;

  /// Overrides `px-2` — `SidebarMenuBadge`'s `px-1.5`.
  final double? paddingX;

  /// A `min-w-*` floor — `SidebarMenuBadge`'s `min-w-5`, so a one-digit count
  /// is a 20px circle rather than a 13px sliver.
  final double? minWidth;

  /// A leading glyph — the data page's *"With glyphs"* row, whose chips are
  /// written `Badge variant="premium"` around an `Icon icon={Star} size="xs"
  /// tone="inherit"` and a label.
  ///
  /// **This is the call site the class list waited for**, and the wait ends
  /// with the two padding trims still unreachable: `has-data-[icon=inline-end]`
  /// and `has-data-[icon=inline-start]` key off a `data-icon` attribute that
  /// `Icon` never writes, so a chip with a glyph in it keeps the full `px-2`.
  /// *(Measured on all five: `padding-left: 8px`, `padding-right: 8px`.)*
  ///
  /// The size is the class list's, not the caller's: `[&>svg]:size-3!` is an
  /// important rule on the chip, so every glyph is **12px** whatever `size` the
  /// `Icon` was given — which is what `size="xs"` asks for anyway at all five
  /// sites. `gap-1` sits between it and the label.
  final Widget? glyph;

  /// `gap-1` — 4px between the glyph and the label.
  static double get glyphGap => space(1);

  /// `[&>svg]:size-3!` — the 12px every chip glyph is forced to.
  static double get glyphSize => space(3);

  /// The floor a chip sits on, so a one-word status and a two-word one read
  /// as the same object.
  ///
  /// A **minimum**, not a height: the label is real text, and a reader at
  /// 200% scale gets a taller chip rather than a clipped one.
  static double get minHeight => space(5);

  /// `px-2`.
  static double get horizontalPadding => space(2);

  /// The `background-color` the variant fills with, or null for the three
  /// unfilled ones.
  Color? _fill(ThemeTokens theme) => switch (variant) {
    BadgeVariant.primary => theme.primary,
    BadgeVariant.secondary => theme.secondary,
    BadgeVariant.destructive => theme.destructive.withValues(alpha: _tintAlpha),
    BadgeVariant.action => Palette.action.withValues(alpha: _tintAlpha),
    BadgeVariant.premium => Palette.value.withValues(alpha: _tintAlpha),
    BadgeVariant.success => Palette.success.withValues(alpha: _tintAlpha),
    BadgeVariant.warning => Palette.warning.withValues(alpha: _tintAlpha),
    BadgeVariant.info => Palette.info.withValues(alpha: _tintAlpha),
    BadgeVariant.outline || BadgeVariant.ghost || BadgeVariant.link => null,
  };

  Color _ink(ThemeTokens theme) => switch (variant) {
    BadgeVariant.primary => theme.primaryForeground,
    BadgeVariant.secondary => theme.secondaryForeground,
    BadgeVariant.destructive => theme.destructiveText,
    BadgeVariant.outline || BadgeVariant.ghost => theme.mutedForeground,
    BadgeVariant.link || BadgeVariant.action => theme.actionText,
    BadgeVariant.premium => theme.premiumText,
    BadgeVariant.success => theme.successText,
    BadgeVariant.warning => theme.warningText,
    BadgeVariant.info => theme.infoText,
  };

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final BorderRadius radius = BorderRadius.circular(Radii.full);

    // `border border-transparent` on every variant but `outline`, which points
    // it at `--input`. The border is real either way: it is paid for out of
    // the 20px box, which is what leaves 14px of content.
    final BoxBorder border = Border.all(
      color: variant == BadgeVariant.outline ? theme.input : transparent,
      width: BorderWidths.hairline,
    );

    final Widget text = StyledText(
      label,
      spec ?? TextStyles.badge,
      color: _ink(theme),
    );

    final Widget content = Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingX ?? horizontalPadding),
      child: Center(
        widthFactor: 1,
        // `inline-flex items-center gap-1` — one child or two, on the chip's
        // own centre line.
        child: glyph == null
            ? text
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox.square(dimension: glyphSize, child: glyph),
                  SizedBox(width: glyphGap),
                  // The label yields before the glyph does: a chip inside a
                  // narrow row shortens its word rather than pushing its icon
                  // off the edge.
                  Flexible(child: text),
                ],
              ),
      ),
    );

    // `overflow-hidden` — the 16px line box in a 14px content box is clipped,
    // not accommodated.
    final Widget box = ClipRRect(borderRadius: radius, child: content);

    return Align(
      // `w-fit shrink-0` — the chip is as wide as its label and no wider, and
      // it starts where its line does.
      alignment: AlignmentDirectional.centerStart,
      widthFactor: 1,
      heightFactor: 1,
      // The floor is the BORDER box: the hairline is paid out of it, which is
      // why the constraint sits outside the fill rather than inside it.
      // `minWidth` is the same box, so it sits here too.
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidth ?? 0,
          minHeight: minHeight,
        ),
        // A flat fill, no gradient and no shadow — every variant, `premium`
        // included: *"no need for the gradient and shadow for the badges,
        // make them simple."*
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _fill(theme),
            border: border,
            borderRadius: radius,
          ),
          child: Padding(padding: border.dimensions, child: box),
        ),
      ),
    );
  }
}
