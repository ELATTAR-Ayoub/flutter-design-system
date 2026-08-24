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
/// | `inline-flex h-5 w-fit min-w-5` | **20px tall**, content-wide, never narrower than **20px** — so `K` and `Esc` are the same height and a single glyph still reads as a key rather than as a letter |
/// | `items-center justify-center` | the glyph is centred in both axes |
/// | `gap-1` | 4px between children |
/// | `rounded-sm` | `--radius-sm` **6px** ([ElRadii.sm]) |
/// | `bg-muted` | — |
/// | `px-1` | 4px |
/// | `font-sans text-xs font-medium` | 12px / 500 — [ElComponentType.kbdKey] |
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
/// `ElShadows.key`, `ElShadows.keyDown` and `ElPress` in this package, and the
/// shadows page documents them one foundations page away as a raised key with a
/// side wall that travels down into its socket. `Kbd` reaches for none of them:
/// no border, no shadow, no press. It ships flat here too. The token set is
/// aspirational; the component is what renders.
library;

import 'package:flutter/widgets.dart';

import '../effects/machine_surface.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';

/// A keyboard key.
///
/// Takes the key's legend as a string, because that is all the page ever passes
/// it (`<Kbd>Ctrl</Kbd>`). The `gap-1` and `size-3` rules in the class list are
/// for a `Kbd` holding an icon beside its text; nothing here does, so [gap] is
/// exposed rather than applied — the same arrangement `ElButton.gapFor` uses
/// for the same reason.
class ElKbd extends StatelessWidget {
  const ElKbd(this.text, {super.key});

  /// The legend, as authored.
  final String text;

  /// `h-5` — 20px.
  static double get height => el(5);

  /// `min-w-5` — 20px, the floor a one-character key sits on.
  static double get minWidth => el(5);

  /// `px-1` — 4px.
  static double get paddingX => el(1);

  /// `gap-1` — 4px between a glyph and its label, for a caller composing one.
  static double get gap => el(1);

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);

    final Widget key = ElMachineSurface(
      // Spelled out rather than omitted: the interesting fact about this
      // component is the elevation it does NOT carry (drift 18), and a surface
      // that names `none` says so where a bare [DecoratedBox] would merely be
      // silent about it.
      spec: ElShadows.none,
      radius: BorderRadius.circular(ElRadii.sm),
      fill: theme.muted,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ElKbd.paddingX),
        // `justify-center` — which only shows once `min-w-5` has forced the box
        // wider than its glyph. `widthFactor: 1` keeps `w-fit` below that.
        child: Center(
          widthFactor: 1,
          child: ElText(
            text,
            ElComponentType.kbdKey,
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
        child: SizedBox(
          height: ElKbd.height,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: ElKbd.minWidth),
            child: key,
          ),
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
class ElKbdGroup extends StatelessWidget {
  const ElKbdGroup({super.key, required this.children});

  /// The keys, in order — `[ElKbd('Ctrl'), ElKbd('K')]`.
  final List<Widget> children;

  /// `gap-1` — 4px.
  static double get gap => el(1);

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (int i = 0; i < children.length; i++) ...<Widget>[
            if (i > 0) SizedBox(width: ElKbdGroup.gap),
            children[i],
          ],
        ],
      ),
    );
  }
}
