/// `components/ui/marker.tsx` — *"a note **about** a list, sitting in the
/// list."*
///
/// Its own docstring is the spec and the name is the trap:
///
/// > Not a highlight. The name misleads: this is not `<mark>`, it draws no
/// > background, and it will not emphasise a matched substring. It is the row
/// > that says something happened between the rows around it — "Stopped by
/// > you", "Context cleared", "Today", "3 messages hidden".
///
/// Three variants, and the choice is about what is being separated:
///
/// | variant | shape |
/// |---|---|
/// | [MarkerVariant.normal] | bare row |
/// | [MarkerVariant.separator] | rule — label — rule |
/// | [MarkerVariant.border] | label with a rule under it |
///
/// The separator's two rules are pseudo-elements — `before:h-px
/// before:min-w-0 before:flex-1 before:bg-border after:ml-1 …` — so they take
/// whatever the label leaves, with `mr-1` / `ml-1` (4px) between each rule and
/// the text, **on top of** the row's own `gap-2`. *(Measured on a 1030px row
/// with a 231.05px label: 387.469 + 4 + 231.05 + 4 + 387.484, and the two rules
/// differ by 0.015px because the label's width is fractional.)*
///
/// The row is `min-h-4` — a 16px floor no marker on the page reaches, because
/// `text-sm`'s own line box is 18.5714.
///
/// **Not ported:** `asChild`, and the `[a]:` rules under it — a marker with a
/// link in it is the file's own idea and nothing in the corpus writes one.
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

import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';

/// `markerVariants` — the cva's three.
enum MarkerVariant {
  /// `default` — *"bare row, for a container that already frames it."*
  ///
  /// Named [normal] because `default` is a Dart keyword.
  normal,

  /// `separator` — *"divides before from after."*
  separator,

  /// `border` — *"heads what follows."* `border-b border-border pb-2`.
  border,
}

/// A quiet row between rows.
class Marker extends StatelessWidget {
  const Marker({
    super.key,
    this.variant = MarkerVariant.normal,
    this.icon,
    required this.label,
  });

  final MarkerVariant variant;

  /// `<MarkerIcon>` — `size-4 shrink-0`, `aria-hidden`.
  final Widget? icon;

  /// `<MarkerContent>`. `flex-none` and `text-center` under the separator
  /// variant, which is what stops the label from eating the rules.
  final String label;

  /// `gap-2` — between the icon and the content.
  static double get gap => space(2);

  /// `min-h-4`.
  static double get minHeight => space(4);

  /// `before:mr-1` / `after:ml-1` — the air between a rule and the label.
  static double get ruleGap => space(1);

  /// `pb-2` on the `border` variant.
  static double get borderPadding => space(2);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Widget text = StyledText(
      label,
      TextStyles.small,
      color: theme.mutedForeground,
      align: variant == MarkerVariant.separator ? TextAlign.center : null,
    );

    final Widget rule = Expanded(
      child: SizedBox(
        height: BorderWidths.hairline,
        child: ColoredBox(color: theme.border),
      ),
    );

    final List<Widget> children = <Widget>[
      if (variant == MarkerVariant.separator) ...<Widget>[
        rule,
        SizedBox(width: ruleGap),
      ],
      if (icon != null) ...<Widget>[
        SizedBox.square(dimension: space(4), child: icon),
        SizedBox(width: gap),
      ],
      // `flex-none` under `separator`; a plain flex item otherwise, and the
      // only child that carries width there.
      if (variant == MarkerVariant.separator)
        Flexible(child: text)
      else
        Expanded(child: text),
      if (variant == MarkerVariant.separator) ...<Widget>[
        SizedBox(width: ruleGap),
        rule,
      ],
    ];

    Widget row = ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );

    if (variant == MarkerVariant.border) {
      row = Container(
        padding: EdgeInsets.only(bottom: borderPadding),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.border,
              width: BorderWidths.hairline,
            ),
          ),
        ),
        child: row,
      );
    }
    return row;
  }
}
