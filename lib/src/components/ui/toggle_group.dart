/// `components/ui/toggle-group.tsx` — three mutually exclusive options and one
/// travelling pill.
///
/// RULES §4 again: *selection travels, never blinks.* The item does not light
/// up when it is chosen — it **gives up** its own background so the group's
/// single pill can slide underneath it. The source says so itself
/// (`toggle-group.tsx` L91–93): *"Must come AFTER `toggleVariants`:
/// tailwind-merge keeps the last class in a group, and the variant paints its
/// own selected background. The travelling pill is the background now, so the
/// item gives up its own."*
///
/// **Root** (L53–56): `relative flex w-fit flex-row items-center
/// gap-[--spacing(var(--gap))] rounded-lg`, with the group writing
/// `--gap: 2` inline → **8px**. `position: relative` is only the pill's
/// containing block, and `rounded-lg` is **inert**: the root has no fill, no
/// border and no `overflow-hidden`, so nothing is there to round or to clip.
/// The port paints neither.
///
/// **Item** (L85–96): `relative z-10 shrink-0` + all of
/// `toggleVariants(default/default)` — i.e. a [Toggle] — + the two-class
/// override quoted above. Resolved:
///
/// | item state | box | fill | ink |
/// |---|---|---|---|
/// | rest, unselected | 32px tall, 12px radius, 10px padding, 13px / 500 | none | `--foreground` |
/// | hover, unselected | same | `--muted` | `--foreground` |
/// | **selected** | same | **transparent** — the pill paints it | `--primary-foreground` |
/// | focus-visible | same | — | a `0 0 0 3px` ring at `--ring` @50% |
///
/// `relative z-10` puts the whole row above the pill, which the group renders
/// as its first child — and [ActiveIndicator] already paints it first, so
/// the stacking is reproduced by construction rather than by a z-index. The
/// item's `focus:z-10 focus-visible:z-10` is inert at this spacing: the ring
/// extends 3px into an 8px gap and cannot reach a neighbour.
///
/// **The pill** (`sliding-indicator.tsx` L169–184): `--primary` at
/// `rounded-pill`, wearing `--shadow-chip`; it travels on `slide-pill` (250ms
/// `--ease-spring` for transform/width/height, 150ms `--ease-out` for opacity)
/// and squashes on `anim-jelly` concurrently with the travel.
/// [ActiveIndicator] is the transcription of all of that, including the
/// measure-then-place that keeps the first placement from flying in from the
/// left.
///
/// DOCUMENTED DRIFT (buttons-map drift 9): **the pill is a stadium and the item
/// under it is a 12px rounded rect** — `rounded-pill` over `rounded-lg`, a 16px
/// corner over a 12px one in the same slot. Hover-on-unselected and selected
/// are therefore two different shapes. Both ship as coded.
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
import '../../design_system/foundation/colors.dart';
import '../../design_system/foundation/shadows.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import './active_indicator.dart';
import '../../design_system/foundation/theme_scope.dart';
import './toggle.dart';

/// Nothing selected.
///
/// Radix `type="single"` permits clearing the selection by clicking the active
/// item, and [ActiveIndicator] documents an out-of-range `activeIndex` as
/// exactly that case: the pill fades to `opacity: 0` and stays measured where
/// it was. −1 is the value its own doc comment names.
const int _deselected = -1;

/// One option in a [ToggleGroup].
///
/// A **model**, not a widget, and deliberately so. The reference gets
/// item-ness from React context — a `ToggleGroupItem` reads its variant, size
/// and spacing from the provider its parent installed, and any other child of
/// the root would simply not be an item. Dart has no equivalent for a
/// `List<Widget>`: a widget list would let a caller drop a [Padding] into the
/// row, and the travelling pill would then measure it and slide onto a gap.
/// A list of models cannot express that, and the group can hand every item the
/// same resolved skin without a lookup.
@immutable
class ToggleGroupItem {
  const ToggleGroupItem({required this.label, this.child, this.enabled = true});

  /// The option's name — both what it says and what a screen reader announces.
  ///
  /// The page's three are `Newest`, `Price` and `Popular`.
  final String label;

  /// What the item renders, when it is not simply its [label].
  ///
  /// Null — the default, and the only case the reference exercises — renders
  /// the label as text in the item's own resolved class.
  final Widget? child;

  /// `disabled` on a Radix `Item`. Never set on this page; declared because
  /// the primitive declares it, and because a disabled option in a live group
  /// is a real state rather than a hypothetical one.
  final bool enabled;
}

/// A segmented control: three or more options, one selected at a time, one
/// pill travelling between them.
///
/// The page's own caption states the constraint the component exists under:
/// *"A toggle group is for three or more mutually exclusive options. With
/// exactly two, use IconSwap — a segmented control for a binary choice wastes
/// space and reads as weaker than it is."*
///
/// **Why the selection is an index rather than a value.** Radix keys its items
/// by string (`value="newest"`, `defaultValue="newest"`) because the DOM has
/// no ordering primitive to key them by — the indicator has to find the active
/// item with a CSS selector. This port's substrate is the opposite:
/// [ActiveIndicator] is positional, it measures the child *at an index*, so
/// a value-keyed API here would resolve to an index at every call site anyway
/// and would hand back an `indexWhere` miss (−1) in place of the type safety
/// it promised. `null` for "nothing selected" is Radix's empty-string value,
/// spelled the way Dart spells absence.
///
/// **Deselection is real** (supervisor ruling B7). Tapping the selected option
/// clears the selection: [onChanged] receives `null`, [selectedIndex] becomes
/// null, `activeIndex` becomes [_deselected], and the pill fades out where it
/// stands. That is what Radix `type="single"` does, and it is the one path
/// through [ActiveIndicator] that nothing else in the port exercises.
///
/// **Two props of the reference's root are not ported.** `spacing` (default 2)
/// and `orientation` (default `horizontal`) each select a whole dormant branch
/// of the item's class list — `spacing={0}` collapses the gap and turns the
/// row into a bordered segmented control with first/last corner rounding and
/// collapsed inner borders; `orientation="vertical"` stacks and stretches it.
/// The page passes neither, no `#api` row prints them, and a parameter that
/// silently did nothing would be worse than an absent one. They are recorded
/// here instead.
///
/// **Roving focus is not ported either.** Radix wraps the items in a
/// `RovingFocusGroup`: one Tab stop for the whole group, arrow keys to move
/// within it. Flutter's traversal gives every item its own Tab stop. Building
/// half of a roving group — arrow keys without the single tab stop, or the
/// reverse — would be worse than the honest divergence, so the divergence is
/// stated rather than approximated.
class ToggleGroup extends StatelessWidget {
  const ToggleGroup({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.variant = ToggleVariant.standard,
    this.size = ToggleSize.md,
    this.label,
  });

  /// The options, in paint order.
  final List<ToggleGroupItem> items;

  /// Which option is selected, or null for none — the state the pill reads.
  final int? selectedIndex;

  /// Called with the new selection: the tapped index, or **null** when the
  /// tapped option was already selected.
  final ValueChanged<int?> onChanged;

  /// Passed to every item, the way the root's context provider passes it
  /// (`toggle-group.tsx` L60–62). The page passes neither this nor [size], so
  /// both fall back to the cva's defaults.
  final ToggleVariant variant;

  final ToggleSize size;

  /// The group's own accessible name.
  ///
  /// The page sets none — the panel's heading names it — so this is null by
  /// default and no container node is emitted when it stays null.
  final String? label;

  /// `--gap: 2` resolved through `gap-[--spacing(var(--gap))]` — 8px.
  static double get gap => space(2);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    final Widget group = ActiveIndicator(
      activeIndex: selectedIndex ?? _deselected,
      gap: gap,
      indicator: Surface(
        // `bg-primary` — the one blue selection on the page — at
        // `rounded-pill`, wearing `--shadow-chip`'s inner rim and inner shade.
        spec: Shadows.compactControl,
        radius: BorderRadius.circular(Radii.full),
        fill: theme.primary,
        child: const SizedBox.expand(),
      ),
      children: <Widget>[
        for (int i = 0; i < items.length; i++)
          Toggle(
            pressed: i == selectedIndex,
            // Tapping the selected option clears the selection rather than
            // re-asserting it: `Toggle` always asks for `!pressed`, so the
            // selected item arrives here with `on == false`.
            onChanged: items[i].enabled
                ? (bool on) => onChanged(on ? i : null)
                : null,
            variant: variant,
            size: size,
            label: items[i].label,
            // `type="single"`: one choice among others, not three independent
            // switches.
            inExclusiveGroup: true,
            // The two trailing declarations of `toggle-group.tsx` L94 —
            // `data-[state=on]:bg-transparent data-[state=on]:text-primary-
            // foreground`. The item gives up its fill so the pill shows
            // through, and flips to white ink because what is under it is now
            // `--primary`.
            pressedFill: transparent,
            pressedInk: theme.primaryForeground,
            // A bare [Text]: the toggle installs its own [DefaultTextStyle],
            // which already carries the resolved class, `transition-all`'s
            // animated ink and `whitespace-nowrap`. Re-resolving the class
            // through [StyledText] here would restate all three.
            child: items[i].child ?? Text(items[i].label),
          ),
      ],
    );

    if (label == null) return group;
    return Semantics(container: true, label: label, child: group);
  }
}
