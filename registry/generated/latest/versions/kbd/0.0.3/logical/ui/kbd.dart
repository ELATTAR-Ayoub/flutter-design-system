/// `components/ui/kbd.tsx` — the keyboard hint, and the one object in the
/// system that owns an elevation token and never wears it.
///
/// A `<kbd>` here is 20px tall, 20px minimum wide, 6px cornered, filled with
/// `--muted`, set in 12px/500 sans on `--muted-foreground`. That is the whole
/// component.
///
/// Every class, resolved (buttons-map §8):
///
/// | class | value |
/// |---|---|
/// | `pointer-events-none` | inert to the mouse — hits pass through to whatever is behind |
/// | `select-none` | not selectable |
/// | minimum 20 × 20, content-wide | so `K` and `Esc` read as the same object and a single glyph still reads as a key rather than as a letter — and a scaled legend grows the key instead of being clipped by it |
/// | `items-center justify-center` | the glyph is centred in both axes |
/// | `gap-1` | 4px between children |
/// | `rounded-sm` | `--radius-sm` **6px** ([Radii.sm]) |
/// | `bg-muted` | — |
/// | `px-1` | 4px |
/// | `font-sans text-xs font-medium` | 12px / 500 — [TextStyles.code] |
/// | `text-muted-foreground` | — |
/// | `[&_svg:not([class*='size-'])]:size-3` | 12px glyphs |
/// | `in-data-[slot=tooltip-content]:…` | a recolour inside a tooltip |
///
/// The last two are recorded rather than built: no `Kbd` on this page holds an
/// icon (all three are text — `Ctrl`, `K`, `Space`, `Esc`), and this port has
/// no tooltip for the context selector to match against.
///
/// DOCUMENTED DRIFT (buttons-map drift 18): `--shadow-key`, `--shadow-key-down`
/// and the `press-key` utility exist for exactly this object — they are
/// `Shadows.keyRaised`, `Shadows.keyPressed` and `Press` in this package, and the
/// shadows page documents them one foundations page away as a raised key with a
/// side wall that travels down into its socket. `Kbd` reaches for none of them:
/// no border, no shadow, no press. It ships flat here too. The token set is
/// aspirational; the component is what renders.
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

import './surface.dart';
import '../../design_system/foundation/shadows.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';

/// A keyboard key.
///
/// Takes the key's legend as a string, because that is all the page ever passes
/// it (`<Kbd>Ctrl</Kbd>`). The `gap-1` and `size-3` rules in the class list are
/// for a `Kbd` holding an icon beside its text; nothing here does, so [gap] is
/// exposed rather than applied — the same arrangement `Button.gapFor` uses
/// for the same reason.
class Kbd extends StatelessWidget {
  const Kbd(this.text, {super.key});

  /// The legend, as authored.
  final String text;

  /// The floor a key sits on, so `K` and `Esc` read as the same object.
  ///
  /// A **minimum**, not a height: the legend is real text, and a reader at
  /// 200% scale gets a taller key rather than a clipped one.
  static double get minHeight => space(5);

  /// The floor a one-character key sits on, so a single glyph still reads as a
  /// key rather than as a letter.
  static double get minWidth => space(5);

  /// `px-1` — 4px.
  static double get paddingX => space(1);

  /// `gap-1` — 4px between a glyph and its label, for a caller composing one.
  static double get gap => space(1);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    final Widget key = Surface(
      // Spelled out rather than omitted: the interesting fact about this
      // component is the elevation it does NOT carry (drift 18), and a surface
      // that names `none` says so where a bare [DecoratedBox] would merely be
      // silent about it.
      spec: Shadows.none,
      radius: BorderRadius.circular(Radii.sm),
      fill: theme.muted,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Kbd.paddingX),
        // `justify-center` — which only shows once `min-w-5` has forced the box
        // wider than its glyph. `widthFactor: 1` keeps `w-fit` below that.
        child: Center(
          widthFactor: 1,
          child: StyledText(
            text,
            TextStyles.code,
            color: theme.mutedForeground,
            maxLines: 1,
            softWrap: false,
          ),
        ),
      ),
    );

    return IgnorePointer(
      // `select-none`. Inert unless the page puts a [SelectionArea] above it,
      // which is exactly when the CSS rule starts mattering too.
      child: SelectionContainer.disabled(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: Kbd.minWidth,
            minHeight: Kbd.minHeight,
          ),
          child: key,
        ),
      ),
    );
  }
}

/// `KbdGroup` (`kbd.tsx:16–24`) — `inline-flex items-center gap-1`.
///
/// DOCUMENTED DRIFT (buttons-map drift 19): the function renders a `<kbd>`
/// while its props are typed `React.ComponentProps<"div">`, so the shortcut
/// ships as `<kbd><kbd>Ctrl</kbd><kbd>K</kbd></kbd>` — a key containing two
/// keys. Flutter has no element name to get wrong, so there is nothing here to
/// reproduce literally; what can be reproduced is what the nesting *means*.
///
/// A nested `<kbd>` is one keyboard object, not a container of two, and that is
/// how it should be announced: "Ctrl K", once. [MergeSemantics] is that reading
/// — it folds the children's own labels into a single node rather than
/// inventing a name for the group or leaving two unrelated letters behind. The
/// alternative, a [Semantics] container with `explicitChildNodes`, would hand a
/// screen reader two keys and let the user work out that they are one shortcut,
/// which is the reading the reference's markup argues against.
class KbdGroup extends StatelessWidget {
  const KbdGroup({super.key, required this.children});

  /// The keys, in order — `[Kbd('Ctrl'), Kbd('K')]`.
  final List<Widget> children;

  /// `gap-1` — 4px.
  static double get gap => space(1);

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (int i = 0; i < children.length; i++) ...<Widget>[
            if (i > 0) SizedBox(width: KbdGroup.gap),
            children[i],
          ],
        ],
      ),
    );
  }
}
