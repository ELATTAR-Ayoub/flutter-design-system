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
/// | [DsMarkerVariant.normal] | bare row |
/// | [DsMarkerVariant.separator] | rule — label — rule |
/// | [DsMarkerVariant.border] | label with a rule under it |
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

import 'package:flutter/widgets.dart';

import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';

/// `markerVariants` — the cva's three.
enum DsMarkerVariant {
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
class DsMarker extends StatelessWidget {
  const DsMarker({
    super.key,
    this.variant = DsMarkerVariant.normal,
    this.icon,
    required this.label,
  });

  final DsMarkerVariant variant;

  /// `<MarkerIcon>` — `size-4 shrink-0`, `aria-hidden`.
  final Widget? icon;

  /// `<MarkerContent>`. `flex-none` and `text-center` under the separator
  /// variant, which is what stops the label from eating the rules.
  final String label;

  /// `gap-2` — between the icon and the content.
  static double get gap => ds(2);

  /// `min-h-4`.
  static double get minHeight => ds(4);

  /// `before:mr-1` / `after:ml-1` — the air between a rule and the label.
  static double get ruleGap => ds(1);

  /// `pb-2` on the `border` variant.
  static double get borderPadding => ds(2);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final Widget text = DsText(
      label,
      DsComponentType.textSm,
      color: theme.mutedForeground,
      align: variant == DsMarkerVariant.separator ? TextAlign.center : null,
    );

    final Widget rule = Expanded(
      child: SizedBox(
        height: DsWidths.hairline,
        child: ColoredBox(color: theme.border),
      ),
    );

    final List<Widget> children = <Widget>[
      if (variant == DsMarkerVariant.separator) ...<Widget>[
        rule,
        SizedBox(width: ruleGap),
      ],
      if (icon != null) ...<Widget>[
        SizedBox.square(dimension: ds(4), child: icon),
        SizedBox(width: gap),
      ],
      // `flex-none` under `separator`; a plain flex item otherwise, and the
      // only child that carries width there.
      if (variant == DsMarkerVariant.separator)
        Flexible(child: text)
      else
        Expanded(child: text),
      if (variant == DsMarkerVariant.separator) ...<Widget>[
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

    if (variant == DsMarkerVariant.border) {
      row = Container(
        padding: EdgeInsets.only(bottom: borderPadding),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.border, width: DsWidths.hairline),
          ),
        ),
        child: row,
      );
    }
    return row;
  }
}
