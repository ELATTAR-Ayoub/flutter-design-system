/// `components/ui/item.tsx` — a structured list row: media, content, actions.
///
/// ## The gap the group does not mean
///
/// `ItemGroup` is `flex w-full flex-col gap-4 has-data-[size=sm]:gap-2.5
/// has-data-[size=xs]:gap-2`. The two `has-*` rules are meant to read "when the
/// *items* in me are small, tighten"; what they compile to is
/// `&:has(*[data-size="sm"])`, which matches **any descendant** carrying that
/// attribute. `Button` writes `data-size={size}`, and the data page's payment
/// rows each end in a `<Button variant="ghost" size="sm">Manage</Button>` — so
/// the group's gap is **10px, not 16**. *(Measured: `gap: 10px` on the
/// `[data-slot=item-group]`, with every `[data-slot=item]` reporting
/// `data-size="default"`.)* Reproduced as measured; see [DsItemGroup.gap].
///
/// ## The rest, measured
///
/// * `Item` at `size="default"` is `gap-2.5 px-3 py-2.5` inside a 1px
///   transparent border, `rounded-lg` (12px), `items-center`, `flex-wrap`.
/// * `transition-colors duration-fast` — **`duration-fast` is a no-op.**
///   `item.tsx:45` is the known site: the computed style is
///   `transition-duration: 0.25s`, the stylesheet default, because
///   `duration-<word>` is not a Tailwind utility and nothing emits it. Probed
///   on this page along with the rest.
/// * `ItemMedia` at `variant="icon"` forces its glyph to `size-4` (16px) and,
///   whenever the row has a description, takes `self-start` plus
///   `translate-y-0.5` — a 2px nudge that lines the glyph up with the title's
///   cap height rather than with the row's centre. *(Measured: media top 2px
///   below content top.)*
/// * `ItemContent` is `flex-1 flex-col gap-1`.
///
/// **Not ported:** `asChild` and with it the whole `[a]:hover:bg-muted` /
/// `[button]:hover:bg-muted` pair — the hover surface is keyed to the element
/// the row *is*, and the rows in the base corpus are plain `<div>`s, so none of
/// it ever matches. `ItemSeparator`, `ItemHeader` and `ItemFooter` (no call
/// site), `variant="muted"` (no call site), `size` `sm`/`xs` (their rungs are
/// byte-identical to `default` for `sm`, and their only *visible* effect is on
/// the group's gap, which is what the drift above reproduces anyway), and
/// `focus-visible:` — a `<div>` takes no focus.
///
/// **Reopened by the agent family (2026-08-16).** `variant="outline"` and
/// `items-start` both have a call site now — `agent/parts/history-card.tsx`
/// renders `<Item variant="outline" className="… items-start …">` — so
/// [DsItemVariant] and [DsItem.alignStart] are built rather than recorded.
library;

import 'package:flutter/widgets.dart';

import '../foundation/colors.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';

/// `<ItemGroup>` — `role="list"`, `flex w-full flex-col`.
class DsItemGroup extends StatelessWidget {
  const DsItemGroup({super.key, required this.children, this.gapOverride});

  final List<Widget> children;

  /// A `gap-*` written at the call site, which beats the base list through
  /// tailwind-merge.
  ///
  /// The agent's history list passes `gap-1` (**4px** *measured*) and the
  /// drawer's navigation group `gap-0.5` (2px); the data page passes none and
  /// keeps [gap]. Null is that base case, drift included.
  final double? gapOverride;

  /// `has-data-[size=sm]:gap-2.5` — 10px, matched by the `size="sm"` buttons
  /// inside the rows rather than by the rows themselves. See the library doc.
  static double get gap => ds(2.5);

  @override
  Widget build(BuildContext context) {
    final double pitch = gapOverride ?? gap;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < children.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: pitch),
          children[i],
        ],
      ],
    );
  }
}

/// `itemVariants`' first axis.
enum DsItemVariant {
  /// `border-transparent`. Named [normal] because `default` is a Dart keyword.
  normal,

  /// `border-border` — what the agent's history card passes.
  outline,

  /// `border-transparent bg-muted/50`. RECORDED, NOT BUILT: no call site.
  muted,
}

/// One row.
class DsItem extends StatelessWidget {
  const DsItem({
    super.key,
    this.media,
    required this.content,
    this.actions,
    this.variant = DsItemVariant.normal,
    this.alignStart = false,
  });

  /// `<ItemMedia>`.
  final Widget? media;

  /// `<ItemContent>`.
  final Widget content;

  /// `<ItemActions>`.
  final Widget? actions;

  /// `data-variant` — which border the row wears.
  final DsItemVariant variant;

  /// `items-start`, written at the call site over the base list's
  /// `items-center`.
  ///
  /// It moves the **actions** and nothing else: [DsItemMedia] is already
  /// `self-start` whenever the row has a description, and [DsItemContent] fills
  /// the row either way. *(Measured on the history card: `item-actions` and
  /// `item-content` share a top edge at y=801.25.)*
  final bool alignStart;

  /// `gap-2.5` — 10px, between media, content and actions.
  static double get gap => ds(2.5);

  /// `px-3 py-2.5`.
  static EdgeInsets get padding =>
      EdgeInsets.symmetric(horizontal: ds(3), vertical: ds(2.5));

  /// `rounded-lg`.
  static double get radius => DsRadii.lg;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    // `border-transparent` on `default` — real, and paid for out of the row's
    // width, which is why every variant keeps the same 1px.
    final Color stroke = switch (variant) {
      DsItemVariant.normal || DsItemVariant.muted => dsTransparent,
      DsItemVariant.outline => theme.border,
    };
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: variant == DsItemVariant.muted
            ? theme.muted.withValues(alpha: mutedFillAlpha)
            : null,
        border: Border.all(color: stroke, width: DsWidths.hairline),
      ),
      // `items-center` with one child overriding it to `self-start` is a
      // per-child cross alignment, which a [Row] has no property for. Giving
      // every child the row's height and letting each align inside its own
      // slot is the same layout, and the only one Flutter spells.
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (media != null) ...<Widget>[media!, SizedBox(width: gap)],
            Expanded(child: content),
            if (actions != null) ...<Widget>[
              SizedBox(width: gap),
              Align(
                alignment:
                    alignStart ? Alignment.topCenter : Alignment.center,
                child: actions!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// `bg-muted/50` on [DsItemVariant.muted]. RECORDED, NOT BUILT beyond this
  /// constant — no call site paints it.
  static const double mutedFillAlpha = 0.50;
}

/// `<ItemMedia variant="icon">` — `flex shrink-0 items-center justify-center`
/// with `[&_svg:not([class*='size-'])]:size-4`.
///
/// [nudged] is `group-has-data-[slot=item-description]/item:self-start` plus
/// `:translate-y-0.5`: when the row carries a description, the glyph leaves the
/// row's centre line, pins to the top and drops 2px.
class DsItemMedia extends StatelessWidget {
  const DsItemMedia({super.key, required this.child, this.nudged = true});

  final Widget child;

  final bool nudged;

  /// `size-4` — the glyph box the variant forces.
  static double get size => ds(4);

  /// `translate-y-0.5`.
  static double get nudge => ds(0.5);

  @override
  Widget build(BuildContext context) {
    final Widget box = SizedBox.square(dimension: size, child: child);
    // Inside [DsItem] this sits in a stretched slot, so the alignment has a
    // row height to work against; standing alone it fills whatever it is
    // given, which is what `self-start` on a flex item does too.
    return Align(
      alignment: nudged ? Alignment.topCenter : Alignment.center,
      child: nudged
          ? Padding(padding: EdgeInsets.only(top: nudge), child: box)
          : box,
    );
  }
}

/// `<ItemContent>` — `flex flex-1 flex-col gap-1`.
class DsItemContent extends StatelessWidget {
  const DsItemContent({super.key, required this.children});

  final List<Widget> children;

  /// `gap-1`.
  static double get gap => ds(1);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < children.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: gap),
            children[i],
          ],
        ],
      );
}

/// `<ItemTitle>` — `line-clamp-1 flex w-fit items-center gap-2 text-sm
/// leading-snug font-medium`.
class DsItemTitle extends StatelessWidget {
  const DsItemTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Align(
        // `w-fit` — the title is as wide as its string, not as wide as the row.
        alignment: AlignmentDirectional.centerStart,
        child: DsText(
          text,
          DsComponentType.itemTitle,
          // `line-clamp-1`.
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
}

/// `<ItemDescription>` — `line-clamp-2 text-left text-sm leading-normal
/// font-normal text-muted-foreground`.
class DsItemDescription extends StatelessWidget {
  const DsItemDescription(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => DsText(
        text,
        DsComponentType.itemDescription,
        color: DsTheme.of(context).mutedForeground,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
}

/// `<ItemActions>` — `flex items-center gap-2`.
class DsItemActions extends StatelessWidget {
  const DsItemActions({super.key, required this.children});

  final List<Widget> children;

  /// `gap-2`.
  static double get gap => ds(2);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (int i = 0; i < children.length; i++) ...<Widget>[
            if (i > 0) SizedBox(width: gap),
            children[i],
          ],
        ],
      );
}
