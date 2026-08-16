/// `components/ui/card.tsx` — the generic container, and the one place in the
/// corpus where a component's whole layout is driven by a custom property.
///
/// ```
/// [--card-spacing:--spacing(4)]                → 16px
/// data-[size=sm]:[--card-spacing:--spacing(3)] → 12px
/// flex flex-col gap-(--card-spacing) py-(--card-spacing)
/// has-data-[slot=card-footer]:pb-0
/// ```
///
/// So the padding and the gap are **one number**, and a footer cancels the
/// bottom of it because `CardFooter` brings its own `p-(--card-spacing)` and a
/// band of its own. *(Measured on the data page's first card: `padding: 16px
/// 0px 0px`, `gap: 16px`, and a 73px footer — 16 + a 40px button + 16, plus its
/// 1px top rule.)*
///
/// The edge is `ring-1 ring-foreground/10`, not a border: an **outset** 1px
/// shadow that costs the box nothing, which is why a card in a 482px column
/// measures 482 and not 480. `rounded-xl` and `overflow-hidden` clip the
/// footer's band to the bottom corners.
///
/// `CardHeader` is a two-column grid whose second column exists only when a
/// `CardAction` is in it:
///
/// ```
/// grid auto-rows-min items-start gap-1
/// has-data-[slot=card-action]:grid-cols-[1fr_auto]
/// has-data-[slot=card-description]:grid-rows-[auto_auto]
/// ```
///
/// `gap-1` is both gaps, so the action sits 4px from the title column as well
/// as the description sitting 4px under the title. *(Measured: a 450px header
/// inside splits 404.47 + 4 + 41.53.)*
///
/// **Not ported:** `data-size="sm"` (no card in the corpus passes it), the
/// `*:[img:first-child]` / `has-[>img:first-child]:pt-0` image rules (no card
/// holds an image), and `[.border-b]:pb-(--card-spacing)` on the header, which
/// waits for a caller to add a bottom border and none does.
library;

import 'package:flutter/widgets.dart';

import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';

/// `ring-1 ring-foreground/10` — the same alpha the overlay family's ring uses.
const double _ringAlpha = 0.10;

/// `bg-muted/50` on `CardFooter`.
const double _bandAlpha = 0.50;

/// The card's own surface.
class DsCard extends StatelessWidget {
  const DsCard({
    super.key,
    required this.children,
    this.fill,
    this.ringColor,
  });

  /// `CardHeader`, `CardContent`, `CardFooter` — in the order they are written.
  final List<Widget> children;

  /// Overrides `bg-card` — the stat page's navigating card hovers to
  /// `bg-accent`.
  final Color? fill;

  /// Overrides `ring-foreground/10` — the same card hovers to
  /// `ring-action/45`.
  final Color? ringColor;

  /// `[--card-spacing:--spacing(4)]` — the padding *and* the gap.
  static double get spacing => ds(4);

  /// `rounded-xl`.
  static double get radius => DsRadii.xl;

  /// `ring-1`.
  static double get ringWidth => DsWidths.hairline;

  /// The default ring colour.
  static Color ringOf(DsThemeData theme) =>
      theme.foreground.withValues(alpha: _ringAlpha);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final BorderRadius shape = BorderRadius.circular(radius);
    final Color ring = ringColor ?? ringOf(theme);
    // `has-data-[slot=card-footer]:pb-0`.
    final bool footer = children.isNotEmpty && children.last is DsCardFooter;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: DsShadowSpec(<DsShadowLayer>[
          DsShadowLayer(0, 0, 0, ringWidth, (DsThemeData _) => ring),
        ]).outerShadows(theme),
      ),
      child: ClipRRect(
        borderRadius: shape,
        child: ColoredBox(
          color: fill ?? theme.card,
          child: Padding(
            padding: EdgeInsets.only(
              top: spacing,
              bottom: footer ? 0 : spacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (int i = 0; i < children.length; i++) ...<Widget>[
                  if (i > 0) SizedBox(height: spacing),
                  children[i],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `<CardHeader>` — `grid auto-rows-min items-start gap-1
/// px-(--card-spacing)`.
class DsCardHeader extends StatelessWidget {
  const DsCardHeader({
    super.key,
    required this.title,
    this.description,
    this.action,
  });

  /// `<CardTitle>`.
  final Widget title;

  /// `<CardDescription>` — its presence is what adds the second grid row.
  final Widget? description;

  /// `<CardAction>` — `col-start-2 row-span-2 row-start-1 self-start
  /// justify-self-end`, and its presence is what adds the second column.
  final Widget? action;

  /// `gap-1` — both the row gap and the column gap.
  static double get gap => ds(1);

  @override
  Widget build(BuildContext context) {
    final Widget column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        title,
        if (description != null) ...<Widget>[
          SizedBox(height: gap),
          description!,
        ],
      ],
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DsCard.spacing),
      child: action == null
          ? column
          : Row(
              // `items-start` on the grid, `self-start` on the action: both
              // rows are top-aligned, and the action spans them without
              // stretching.
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // `1fr` — the title column takes what is left.
                Expanded(child: column),
                SizedBox(width: gap),
                // `auto` + `justify-self-end`.
                action!,
              ],
            ),
    );
  }
}

/// `<CardTitle>` — `font-heading text-base leading-snug font-medium`.
class DsCardTitle extends StatelessWidget {
  const DsCardTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) =>
      DsText(text, DsComponentType.cardTitle);
}

/// `<CardDescription>` — `text-sm text-muted-foreground`.
class DsCardDescription extends StatelessWidget {
  const DsCardDescription(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => DsText(
        text,
        DsComponentType.textSm,
        color: DsTheme.of(context).mutedForeground,
      );
}

/// `<CardContent>` — `px-(--card-spacing)` and nothing else.
class DsCardContent extends StatelessWidget {
  const DsCardContent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: DsCard.spacing),
        child: child,
      );
}

/// `<CardFooter>` — `flex items-center rounded-b-xl border-t bg-muted/50
/// p-(--card-spacing)`.
///
/// The class carries `rounded-b-xl` and the card already clips, so the corner
/// is drawn once; what the band needs from this widget is its rule and its
/// fill.
class DsCardFooter extends StatelessWidget {
  const DsCardFooter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Container(
      padding: EdgeInsets.all(DsCard.spacing),
      decoration: BoxDecoration(
        color: theme.muted.withValues(alpha: _bandAlpha),
        border: Border(
          top: BorderSide(color: theme.border, width: DsWidths.hairline),
        ),
      ),
      child: child,
    );
  }
}
