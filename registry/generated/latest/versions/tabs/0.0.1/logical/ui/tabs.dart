/// `components/ui/tabs.tsx` — one travelling mark and a set of views behind it.
///
/// RULES §4 for the third time: *selection travels, never blinks.* The list
/// owns **one** indicator that physically slides from the old tab to the new
/// one and lands with a jelly squash; a trigger never paints its own selected
/// background. It is the same `useSlidingIndicator` hook `ToggleGroup` uses, so
/// it is the same [ElSlidingPillGroup] here and the same single definition of
/// the squash.
///
/// **The 40 / 4 / 32 ladder is the port's, and the page says so.** The section's
/// trailing caption reads *"40px track, 4px inset, 32px triggers on 16px
/// padding — the same ladder as every other control. Stock shadcn ships
/// 32 / 3 / 25, none of which is on the 8-point scale."* Measured on the live
/// reference at 1440 × 900 (2026-08-16): the track is 40 tall on `p-1`, the
/// triggers 32 on `px-4`, and `gap-1` between them.
///
/// **Two variants, two marks** (`tabs.tsx` L36–50, L82–96):
///
/// | | `standard` | `line` |
/// |---|---|---|
/// | track | `bg-muted` at `rounded-pill`, `p-1`, `gap-1` | transparent, no radius, no padding, `gap-2` |
/// | mark | the full trigger rect: `bg-primary` `rounded-pill` `shadow-chip` | a 2px rule on the trigger's bottom edge: `bg-action-ink` `rounded-pill` |
/// | active ink | `--primary-foreground` | `--foreground` |
///
/// The source's own note on why the rule is `-ink` rather than the pill's
/// `--primary` (L86–91): *"a 2px rule is the thinnest mark in the system and
/// the one with least room to be dark… a mark with no foreground of its own is
/// legible only by contrast with what is behind it, which is the question
/// `-ink` answers. The filled `default` pill keeps `bg-primary`, because it
/// carries the active label on top and is judged on that pairing instead."*
///
/// **The trigger's own transition is colour-only** — `transition-colors
/// duration-base ease-out` (L113). Probed: `transition-property` reads the
/// ten-entry colour list at `0.25s` on `cubic-bezier(0.22, 1, 0.36, 1)`. The
/// `duration-base` in that class list emits nothing (see
/// [ElDurations.transitionDefault]); the 250ms it happens to run at is the
/// framework default, and this file spells it as such.
///
/// **`orientation` is recorded, not built.** The root's
/// `data-horizontal:flex-col`, the list's `group-data-vertical/tabs:*` branch
/// and the indicator's `inset-y-0 right-0 w-0.5` half all describe a vertical
/// tab set. The page passes no `orientation`, so every one of those is dormant
/// — the `asChild` precedent: a parameter that selected a whole unbuilt branch
/// would be worse than an absent one.
library;

import 'package:flutter/widgets.dart';

import '../effects/machine_surface.dart';
import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../motion/sliding_pill.dart';
import '../theme_scope.dart';
import 'button.dart';

/// `focus-visible:ring-ring/50` — the alpha every focus ring in the system
/// wears.
const double _focusRingAlpha = 0.50;

/// `tabsListVariants`' two rungs (`tabs.tsx` L38–48).
enum ElTabsVariant {
  /// `variant="default"` — the filled pill on a `--muted` track.
  ///
  /// Named [standard] because `default` is a Dart keyword, the rename
  /// [ElToggleVariant.standard] already carries.
  standard,

  /// `variant="line"` — a 2px rule under a bare row.
  line,
}

/// One tab: its trigger's label, and the view that belongs to it.
///
/// A **model**, not a widget, for [ElToggleGroupItem]'s reason: the travelling
/// indicator measures the child *at an index*, and a widget list would let a
/// caller drop a [Padding] into the row for the mark to slide onto.
@immutable
class ElTabItem {
  const ElTabItem({required this.label, this.content});

  /// The trigger's label — what it says and what a screen reader announces.
  final String label;

  /// The `TabsContent` this trigger reveals, or null where the reference
  /// declares no content for it.
  ///
  /// Null is a real state on this page rather than an omission: the account
  /// tab set declares five triggers and **one** `TabsContent`, and the line
  /// variant four triggers and one. Radix simply renders nothing for a value
  /// with no content, and so does this.
  final Widget? content;
}

/// A tab set: a track of triggers with one mark travelling between them, and
/// the selected item's view underneath.
///
/// **Controlled**, where the reference is uncontrolled (`defaultValue="live"`).
/// The port's convention across `ElSelect`, `ElCalendar` and `ElToggleGroup` is
/// that the page owns the value; an uncontrolled twin would be a second state
/// machine for the same widget, and the two would have to be kept in step.
class ElTabs extends StatelessWidget {
  const ElTabs({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.variant = ElTabsVariant.standard,
  });

  final List<ElTabItem> items;

  /// Which tab is active. Radix's `value`, resolved to an index for
  /// [ElSlidingPillGroup]'s positional substrate — [ElToggleGroup]'s own
  /// argument, and its own trade.
  final int selectedIndex;

  final ValueChanged<int> onChanged;

  final ElTabsVariant variant;

  /// `group-data-horizontal/tabs:h-10` on the list — the track.
  static double get trackHeight => el(10);

  /// `group-data-horizontal/tabs:h-8` on the trigger.
  static double get triggerHeight => el(8);

  /// `px-4` on the trigger — §3's *"16px padding"*.
  static double get triggerPaddingX => el(4);

  /// `h-0.5` — the `line` variant's rule.
  static double get ruleHeight => el(0.5);

  /// `flex gap-2` on the root: the space between the track and the view.
  static double get rootGap => el(2);

  /// `p-1` on the `standard` track, and nothing on `line` — where the 4px each
  /// side comes from `items-center` centring a 32px trigger in a 40px box
  /// instead. The two arrive at the same inset by different routes, and the
  /// probe reads `translate(4px, 4px)` on one indicator and `translate(0, 4px)`
  /// on the other because of it.
  static double get trackPadding => el(1);

  /// `gap-1` on `standard`, `gap-2` on `line`.
  static double gapFor(ElTabsVariant variant) =>
      variant == ElTabsVariant.line ? el(2) : el(1);

  EdgeInsets get _trackInset => variant == ElTabsVariant.line
      // `items-center`, spelled as the inset it resolves to.
      ? EdgeInsets.symmetric(vertical: (trackHeight - triggerHeight) / 2)
      : EdgeInsets.all(trackPadding);

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final bool line = variant == ElTabsVariant.line;

    final Widget track = SizedBox(
      height: trackHeight,
      child: ElSlidingPillGroup(
        activeIndex: selectedIndex,
        gap: gapFor(variant),
        padding: _trackInset,
        // The `line` rule scales about its own bottom edge — see
        // [ElSlidingPillGroup.jellyAlignment].
        jellyAlignment: line ? Alignment.bottomCenter : Alignment.center,
        pill: line
            ? Align(
                // `absolute inset-x-0 bottom-0 h-0.5`.
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: ruleHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.actionInk,
                      borderRadius: BorderRadius.circular(ElRadii.pill),
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              )
            : ElMachineSurface(
                // `block size-full rounded-pill bg-primary shadow-chip` —
                // `SlidingIndicator`'s own default jelly span.
                spec: ElShadows.chip,
                radius: BorderRadius.circular(ElRadii.pill),
                fill: theme.primary,
                child: const SizedBox.expand(),
              ),
        children: <Widget>[
          for (int i = 0; i < items.length; i++)
            _ElTabsTrigger(
              label: items[i].label,
              active: i == selectedIndex,
              variant: variant,
              onTap: () => onChanged(i),
            ),
        ],
      ),
    );

    final Widget? content = selectedIndex >= 0 && selectedIndex < items.length
        ? items[selectedIndex].content
        : null;

    return Column(
      // `inline-flex w-fit` on the list inside a `flex-col` root: the track
      // hugs its triggers and starts at the column's leading edge, while
      // `TabsContent`'s `flex-1` fills it.
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(alignment: AlignmentDirectional.centerStart, child: track),
        if (content != null) ...<Widget>[
          SizedBox(height: rootGap),
          // `text-sm` on `TabsContent` — an ambient size the view inherits,
          // not a style applied to a string.
          DefaultTextStyle.merge(
            style: ElText.styleOf(
              context,
              ElComponentType.textSm,
              color: theme.foreground,
            ),
            child: content,
          ),
        ],
      ],
    );
  }
}

/// One trigger. Private: a tab out of its list has no indicator to give its
/// background up to, which is the whole component.
class _ElTabsTrigger extends StatefulWidget {
  const _ElTabsTrigger({
    required this.label,
    required this.active,
    required this.variant,
    required this.onTap,
  });

  final String label;
  final bool active;
  final ElTabsVariant variant;
  final VoidCallback onTap;

  @override
  State<_ElTabsTrigger> createState() => _ElTabsTriggerState();
}

class _ElTabsTriggerState extends State<_ElTabsTrigger> {
  bool _hovered = false;

  void _hover(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  /// `text-muted-foreground` → `hover:text-foreground` →
  /// `data-active:text-primary-foreground` / `…:text-foreground`.
  ///
  /// The two `data-active:` rules are emitted after the hover rule and win on
  /// the active trigger, which is why the active branch is tested first.
  Color _ink(ElThemeData theme) {
    if (widget.active) {
      return widget.variant == ElTabsVariant.line
          ? theme.foreground
          : theme.primaryForeground;
    }
    return _hovered ? theme.foreground : theme.mutedForeground;
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _hover(true),
      onExit: (_) => _hover(false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Semantics(
          button: true,
          selected: widget.active,
          inMutuallyExclusiveGroup: true,
          label: widget.label,
          child: SizedBox(
            height: ElTabs.triggerHeight,
            child: TweenAnimationBuilder<Color?>(
              // `transition-colors` at the framework's own default duration and
              // easing — the `duration-base ease-out` in the class list restates
              // both and emits neither.
              tween: ColorTween(end: _ink(theme)),
              duration: elAnimationDuration(
                context,
                ElDurations.transitionDefault,
              ),
              curve: ElCurves.out,
              builder: (BuildContext context, Color? ink, Widget? _) => ElMachineSurface(
                // `focus-visible:ring-3 focus-visible:ring-ring/50` over a
                // trigger with no elevation of its own.
                spec: ElButton.withFocusRing(
                  ElShadows.none,
                  theme.ring.withValues(alpha: _focusRingAlpha),
                  progress: 0,
                ),
                radius: BorderRadius.circular(ElRadii.pill),
                // `data-active:bg-transparent`, and no resting fill either:
                // the travelling mark is the background.
                fill: elTransparent,
                // `border border-transparent` — invisible and **two pixels
                // wide**, which is 6 of the first track's 280.38. The port
                // measured 274.36 before it was paid.
                border: Border.all(
                  color: elTransparent,
                  width: ElWidths.hairline,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ElTabs.triggerPaddingX,
                  ),
                  child: Center(
                    // `flex-1` inside a `w-fit` track: the intrinsic pass sizes
                    // every trigger to its own label plus the padding, which is
                    // why the three on §3's first set measure 92.67 / 85.09 /
                    // 86.61 rather than a third each.
                    widthFactor: 1,
                    child: ElText(
                      widget.label,
                      // `text-sm font-medium` — the same resolved style a
                      // `size="default"` Button label wears.
                      ElComponentType.buttonLabel,
                      color: ink ?? _ink(theme),
                      softWrap: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
