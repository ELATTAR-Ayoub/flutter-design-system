/// `components/ui/separator.tsx` — a hairline, and nothing else.
///
/// The whole component is one class list:
///
/// ```
/// shrink-0 bg-border
/// data-horizontal:h-px data-horizontal:w-full
/// data-vertical:w-px data-vertical:self-stretch
/// ```
///
/// So a separator has **no length of its own on its long axis**: horizontal is
/// `w-full` — as wide as whatever holds it — and vertical is `self-stretch`,
/// which is a flex-item override that fills the line's cross size regardless of
/// the container's `align-items`. That asymmetry is why the vertical arm below
/// takes its height from the incoming constraint rather than naming one: the
/// data page's three-figure strip is `flex h-6 items-center gap-4`, and the two
/// rules in it are 24px tall while the numbers beside them stay centred.
///
/// **Not ported:** `decorative` (Radix's flag choosing between
/// `role="separator"` and `aria-hidden`; the port hides both, since a
/// [Semantics] divider node carries no information a Flutter reader can use)
/// and `orientation`'s `aria-orientation`, which follows it.
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
import '../../design_system/foundation/theme_scope.dart';

/// `orientation` — the prop, defaulting to `horizontal` exactly as the
/// component's own default parameter does.
enum SeparatorOrientation {
  /// `data-horizontal:h-px data-horizontal:w-full`.
  horizontal,

  /// `data-vertical:w-px data-vertical:self-stretch`.
  vertical,
}

/// A 1px `--border` rule.
class Separator extends StatelessWidget {
  const Separator({
    super.key,
    this.orientation = SeparatorOrientation.horizontal,
  });

  /// `<Separator orientation="vertical" />`.
  const Separator.vertical({super.key})
    : orientation = SeparatorOrientation.vertical;

  final SeparatorOrientation orientation;

  /// `h-px` / `w-px` — the rule's thickness on its short axis.
  static double get thickness => BorderWidths.hairline;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final bool horizontal = orientation == SeparatorOrientation.horizontal;

    return SizedBox(
      // The long axis is deliberately unset: `w-full` and `self-stretch` both
      // mean "whatever the parent gives me", which is what a null does here.
      width: horizontal ? null : thickness,
      height: horizontal ? thickness : null,
      child: ColoredBox(color: theme.border),
    );
  }
}
