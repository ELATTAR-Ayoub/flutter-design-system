/// `components/ui/badge.tsx` — *"a chip with depth, not a coloured
/// rectangle."*
///
/// Its own docstring is the spec, and it is worth quoting because two of the
/// three things it asks for are paint the port has to build rather than
/// tokens it can name:
///
/// > Every filled variant carries `ramp-chip` (a light-from-above gradient)
/// > and `shadow-chip` (the badge entry in the machine shadow family). Stock
/// > shadcn ships a flat fill; next to buttons that have an inner highlight
/// > and a real shadow, a flat chip looks like a sticker someone pasted on.
/// >
/// > `shadow-chip` deliberately reads as *raised but not pressable* — it has
/// > the inner top highlight of a control but none of the travel. A badge is a
/// > label, not a button, and it must not invite a click.
/// >
/// > Unfilled variants (outline, ghost, link) get neither: there is no surface
/// > to light, and a shadow under transparent text is just dirt.
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
/// icon call site (see [DsBadge.glyph]) and all five chips there measure the
/// full `px-2`, because `Icon` writes no `data-icon` for the selector to find.
library;

import 'package:flutter/widgets.dart';

import '../foundation/colors.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../effects/machine_surface.dart';
import '../theme_scope.dart';

/// `bg-<hue>/12` — the tint every semantic variant is filled with.
const double _tintAlpha = 0.12;

/// `@utility ramp-chip` (globals.css L1531–1538):
/// `linear-gradient(to bottom, rgb(255 255 255 / .18) 0%,`
/// `rgb(255 255 255 / .05) 48%, rgb(0 0 0 / .14) 100%)`.
///
/// A `background-image` over the `background-color`, so it composites on top
/// of the fill rather than replacing it — which is what a [DecoratedBox] with
/// both a `color` and a `gradient` cannot do (the gradient wins outright).
/// Painted as its own layer here for that reason.
final LinearGradient _rampChip = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: <Color>[
    dsHsl(0, 0, 100).withValues(alpha: 0.18),
    dsHsl(0, 0, 100).withValues(alpha: 0.05),
    dsHsl(0, 0, 0).withValues(alpha: 0.14),
  ],
  stops: const <double>[0, 0.48, 1],
);

/// `badgeVariants` — the cva's ten, in its own order.
enum DsBadgeVariant {
  /// `ramp-chip bg-primary text-primary-foreground shadow-chip`.
  ///
  /// Named [primary] because `default` is a Dart keyword, the same rename
  /// `DsButtonVariant.primary` carries.
  primary,

  /// `ramp-chip bg-secondary text-secondary-foreground shadow-chip`.
  secondary,

  /// `ramp-chip bg-destructive/12 text-destructive-ink shadow-chip`.
  destructive,

  /// `border-input text-muted-foreground` — no ramp, no shadow, no fill.
  outline,

  /// `text-muted-foreground` and nothing else at rest.
  ghost,

  /// `text-action-ink underline-offset-4` — the underline is a hover rule, so
  /// at rest this is coloured text in a pill-shaped box.
  link,

  /// *"Added for this system."* `ramp-chip bg-action/12 text-action-ink
  /// shadow-chip` — the media dialog's "New release".
  action,

  /// `ramp-chip bg-value/12 text-value-ink shadow-btn-value` — *"the lime one,
  /// used for Featured, Limited and anything carrying value — the only badge
  /// that gets the lime cast under it, because lime is worth."* The one
  /// variant that does **not** wear `shadow-chip`.
  premium,

  /// `ramp-chip bg-success/12 text-success-ink shadow-chip`.
  success,

  /// `ramp-chip bg-warning/12 text-warning-ink shadow-chip`.
  warning,

  /// `ramp-chip bg-info/12 text-info-ink shadow-chip`.
  info;

  /// Whether the variant is filled — and therefore whether it carries the ramp
  /// and a shadow at all.
  bool get filled => switch (this) {
        DsBadgeVariant.outline ||
        DsBadgeVariant.ghost ||
        DsBadgeVariant.link =>
          false,
        _ => true,
      };
}

/// A chip. 20px tall, pill-shaped, sized to its label.
class DsBadge extends StatelessWidget {
  const DsBadge({
    super.key,
    required this.label,
    this.variant = DsBadgeVariant.primary,
    this.spec,
    this.paddingX,
    this.minWidth,
    this.glyph,
  });

  final String label;

  final DsBadgeVariant variant;

  /// Overrides [DsComponentType.badgeLabel].
  ///
  /// `SidebarMenuBadge` writes `.type-num-xs` onto the chip, which resolves to
  /// [DsComponentType.sidebarMenuBadge] rather than to the class it names —
  /// see that spec for the cascade. The [DsFieldLabel] `spec:` precedent
  /// (ruling S4): a resolved style the component cannot derive is a prop, not
  /// a branch.
  final DsTypeSpec? spec;

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
  static double get glyphGap => ds(1);

  /// `[&>svg]:size-3!` — the 12px every chip glyph is forced to.
  static double get glyphSize => ds(3);

  /// `h-5` — a hard 20px border box, label height notwithstanding.
  static double get height => ds(5);

  /// `px-2`.
  static double get horizontalPadding => ds(2);

  /// The `background-color` the variant fills with, or null for the three
  /// unfilled ones.
  Color? _fill(DsThemeData theme) => switch (variant) {
        DsBadgeVariant.primary => theme.primary,
        DsBadgeVariant.secondary => theme.secondary,
        DsBadgeVariant.destructive =>
          theme.destructive.withValues(alpha: _tintAlpha),
        DsBadgeVariant.action =>
          DsPalette.action.withValues(alpha: _tintAlpha),
        DsBadgeVariant.premium => DsPalette.value.withValues(alpha: _tintAlpha),
        DsBadgeVariant.success =>
          DsPalette.success.withValues(alpha: _tintAlpha),
        DsBadgeVariant.warning =>
          DsPalette.warning.withValues(alpha: _tintAlpha),
        DsBadgeVariant.info => DsPalette.info.withValues(alpha: _tintAlpha),
        DsBadgeVariant.outline ||
        DsBadgeVariant.ghost ||
        DsBadgeVariant.link =>
          null,
      };

  Color _ink(DsThemeData theme) => switch (variant) {
        DsBadgeVariant.primary => theme.primaryForeground,
        DsBadgeVariant.secondary => theme.secondaryForeground,
        DsBadgeVariant.destructive => theme.destructiveInk,
        DsBadgeVariant.outline ||
        DsBadgeVariant.ghost =>
          theme.mutedForeground,
        DsBadgeVariant.link || DsBadgeVariant.action => theme.actionInk,
        DsBadgeVariant.premium => theme.valueInk,
        DsBadgeVariant.success => theme.successInk,
        DsBadgeVariant.warning => theme.warningInk,
        DsBadgeVariant.info => theme.infoInk,
      };

  /// `shadow-chip` everywhere but `premium`, which takes `shadow-btn-value`.
  DsShadowSpec _shadow() => variant == DsBadgeVariant.premium
      ? DsShadows.btnValue
      : DsShadows.chip;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final BorderRadius radius = BorderRadius.circular(DsRadii.pill);

    // `border border-transparent` on every variant but `outline`, which points
    // it at `--input`. The border is real either way: it is paid for out of
    // the 20px box, which is what leaves 14px of content.
    final BoxBorder border = Border.all(
      color: variant == DsBadgeVariant.outline ? theme.input : dsTransparent,
      width: DsWidths.hairline,
    );

    final Widget text = DsText(
      label,
      spec ?? DsComponentType.badgeLabel,
      color: _ink(theme),
    );

    Widget content = Padding(
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
                  text,
                ],
              ),
      ),
    );

    if (variant.filled) {
      // `background-image` over `background-color`: the ramp is a separate
      // layer, painted between the fill and the label.
      content = Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Positioned.fill(
            child: DecoratedBox(
              decoration:
                  BoxDecoration(gradient: _rampChip, borderRadius: radius),
            ),
          ),
          content,
        ],
      );
    }

    // `overflow-hidden` — the 16px line box in a 14px content box is clipped,
    // not accommodated.
    final Widget box = ClipRRect(borderRadius: radius, child: content);

    return Align(
      // `w-fit shrink-0` — the chip is as wide as its label and no wider, and
      // it starts where its line does.
      alignment: AlignmentDirectional.centerStart,
      widthFactor: 1,
      heightFactor: 1,
      // `h-5` is the BORDER box: the hairline is paid out of the 20, which is
      // why the height sits outside the surface rather than inside it.
      // `min-w-*` is the same box, so it sits here too.
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidth ?? 0,
          minHeight: height,
          maxHeight: height,
        ),
        child: variant.filled
            ? DsMachineSurface(
                spec: _shadow(),
                radius: radius,
                fill: _fill(theme),
                border: border,
                child: box,
              )
            : DecoratedBox(
                decoration: BoxDecoration(border: border, borderRadius: radius),
                child: Padding(padding: border.dimensions, child: box),
              ),
      ),
    );
  }
}
