/// `components/ui/aspect-ratio.tsx` — eleven lines, no styling of its own.
///
/// ```tsx
/// function AspectRatio({ ...props }) {
///   return <AspectRatioPrimitive.Root data-slot="aspect-ratio" {...props} />
/// }
/// ```
///
/// All of the geometry is Radix's, and Radix's is the padding-bottom trick.
/// Probed on `/design-system/components/base/layout`:
///
/// ```html
/// <div style="position:relative;width:100%;padding-bottom:133.333%">
///   <div data-slot="aspect-ratio" class="…" style="position:absolute;top:0;right:0;bottom:0;left:0">
/// ```
///
/// Two boxes, not one. The **outer** box is what takes part in flow: full
/// width, and a height of `width ÷ ratio` bought entirely with percentage
/// padding. The **inner** box is the one the caller's classes land on, and it
/// is absolutely positioned to the outer box's four edges.
///
/// The distinction is invisible until a class list puts a margin on it, which
/// the carousel's card does (`mb-4`). An absolutely positioned box with `top:
/// 0; bottom: 0` and `height: auto` resolves its height as *containing block
/// − insets − margins*, so `mb-4` does not push the next element down — the
/// slot stays `width ÷ ratio` tall and **the ratio box shrinks by 16px inside
/// it**. Measured on the carousel card: a 298.66px-wide slot is 398.203 tall
/// (`× 4/3`) and the bordered box inside it is **382.203**. That is [margin].
library;

import 'package:flutter/widgets.dart';

/// A box locked to [ratio], with the reference's two-box geometry.
///
/// [ratio] is the CSS prop verbatim — `5 / 7`, `3 / 4`, `16 / 9` — i.e.
/// **width ÷ height**, which is also Flutter's [AspectRatio] convention, so
/// the number crosses over unchanged.
class DsAspectRatio extends StatelessWidget {
  const DsAspectRatio({
    super.key,
    required this.ratio,
    this.margin = EdgeInsets.zero,
    this.child,
  });

  /// `ratio={5 / 7}` — width ÷ height.
  final double ratio;

  /// A margin on the **inner**, absolutely positioned box.
  ///
  /// Deflates the ratio box inside its slot rather than moving anything after
  /// it — see the library note. `mb-4` on the carousel card is the corpus's
  /// only instance.
  final EdgeInsets margin;

  /// What the class list styles: the bordered, filled box itself.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: ratio,
      child: margin == EdgeInsets.zero
          ? child
          : Padding(padding: margin, child: child),
    );
  }
}
