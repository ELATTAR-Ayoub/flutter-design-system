/// `components/ui/accordion.tsx` — a set of related disclosures where only one
/// should be open.
///
/// The page mounts it as `type="single" collapsible defaultValue="odds"`, which
/// is three statements: one open item at a time, clicking the open item closes
/// it outright, and the FAQ opens on its first question.
///
/// **Resolved, measured on the live reference at 1440 × 900 (2026-08-16):**
///
/// | slot | class list | measured |
/// |---|---|---|
/// | root | `flex w-full flex-col` | a bare column |
/// | item | `not-last:border-b` | 1px `--border` under all but the last |
/// | trigger | `py-2.5 rounded-lg border border-transparent text-sm font-medium transition-all` + `flex flex-1 items-start justify-between` | **40.56** tall: 10 + 18.5714 + 10 + a 1px transparent border on each edge |
/// | content | `overflow-hidden text-sm` + `anim-unfold` / `anim-fold` | 47.13 open, `display: none` closed |
/// | content inner | `h-(--radix-accordion-content-height) pt-0 pb-2.5` | the panel's own height, 10px of it padding |
///
/// The transparent border is not decoration and is not skipped: it is two of
/// those 40.56 pixels, and `focus-visible:border-ring` is what it exists for.
///
/// **DRIFT — the whole `**:data-[slot=accordion-trigger-icon]:*` block is
/// dead.** The trigger declares `ml-auto`, `size-4` and `text-muted-foreground`
/// through that variant, and `Icon`'s props do not include `data-slot`, so the
/// attribute never reaches the DOM and the selector matches nothing. Probed:
/// `document.querySelectorAll('[data-slot="accordion-trigger-icon"]')` returns
/// **zero** elements, while the chevrons still measure 16 × 16 and still sit
/// hard right. Both survive by accident — 16px is `Icon`'s own `md` default and
/// `justify-between` was already pushing the last child to the end. The one
/// declaration with nothing to fall back on is the colour: the chevrons render
/// `--foreground`, not `--muted-foreground`. Reproduced as measured.
///
/// **The chevron is a swap, not a rotation.** `AccordionTrigger` renders two
/// `Icon`s — `ChevronDownIcon` and `ChevronUpIcon` — and hides one with
/// `group-aria-expanded/accordion-trigger:hidden`. Nothing rotates and nothing
/// animates; the probe reads `rotate: none` on both in both states. (The
/// navigation menu's chevron, one section up, *does* rotate — see
/// `navigation_menu.dart`. Two disclosure chevrons on one page, two different
/// mechanics.)
library;

import 'package:flutter/widgets.dart';

import '../effects/machine_surface.dart';
import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../text_layout.dart';
import '../theme_scope.dart';
import 'button.dart';
import 'collapsible.dart';
import 'icon.dart';
import 'icon_paths.dart';

/// One question and its answer.
@immutable
class ElAccordionItem {
  const ElAccordionItem({required this.title, required this.content});

  /// The trigger's label.
  final String title;

  /// The `AccordionContent`'s child. Its `pb-2.5` belongs to the component;
  /// anything else is the caller's.
  final Widget content;
}

/// `type="single" collapsible` — one open item, or none.
class ElAccordion extends StatelessWidget {
  const ElAccordion({
    super.key,
    required this.items,
    required this.openIndex,
    required this.onChanged,
  });

  final List<ElAccordionItem> items;

  /// Which item is open, or null for none.
  ///
  /// Radix keys by string `value`; this port keys by index for
  /// [ElTabs]' reason — the list is positional and an `indexWhere` miss would
  /// hand back −1 in place of the type safety a value key promised. `null` is
  /// Radix's empty-string value, spelled the way Dart spells absence.
  final int? openIndex;

  /// `collapsible` — tapping the open item reports **null**, not its own index.
  final ValueChanged<int?> onChanged;

  /// `py-2.5` on the trigger.
  static double get triggerPaddingY => el(2.5);

  /// `pb-2.5` on the content's inner box.
  static double get contentPaddingBottom => el(2.5);

  /// `size-4` — what the icons render at, from `Icon`'s own `md` default
  /// rather than from the dead variant that also says so.
  static double get chevronPx => el(4);

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < items.length; i++)
          // A [Container] rather than a bare [DecoratedBox]: a CSS border
          // occupies layout, and only [Container] passes a decoration's own
          // `dimensions` down as padding. The seam is 1px of the item's height,
          // and three of them are 2px of the section's.
          Container(
            decoration: BoxDecoration(
              border: i == items.length - 1
                  // `not-last:border-b` — the last item has no seam under it,
                  // which is what keeps the set from looking like a table.
                  ? null
                  : Border(
                      bottom: BorderSide(
                        color: theme.border,
                        width: ElWidths.hairline,
                      ),
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _ElAccordionTrigger(
                  title: items[i].title,
                  expanded: i == openIndex,
                  onTap: () => onChanged(i == openIndex ? null : i),
                ),
                ElUnfold(
                  open: i == openIndex,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: contentPaddingBottom),
                    child: DefaultTextStyle.merge(
                      // `text-sm` on the content — ambient, so a paragraph
                      // inside it inherits rather than being handed a style.
                      style: ElText.styleOf(
                        context,
                        ElComponentType.textSm,
                        color: theme.foreground,
                      ),
                      child: items[i].content,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// `AccordionHeader` + `AccordionTrigger`.
class _ElAccordionTrigger extends StatefulWidget {
  const _ElAccordionTrigger({
    required this.title,
    required this.expanded,
    required this.onTap,
  });

  final String title;
  final bool expanded;
  final VoidCallback onTap;

  @override
  State<_ElAccordionTrigger> createState() => _ElAccordionTriggerState();
}

class _ElAccordionTriggerState extends State<_ElAccordionTrigger> {
  bool _hovered = false;
  bool _focused = false;

  void _hover(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);

    // `transition-all` with no duration utility beside it: the framework
    // default on the framework default easing, which globals.css L395–396
    // points at `--duration-base` and `--ease-out`. Probed: `all | 0.25s |
    // cubic-bezier(0.22, 1, 0.36, 1)`.
    final Duration transition = elAnimationDuration(
      context,
      ElDurations.transitionDefault,
    );

    return Semantics(
      button: true,
      expanded: widget.expanded,
      label: widget.title,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _hover(true),
        onExit: (_) => _hover(false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Focus(
            onFocusChange: (bool value) => setState(() => _focused = value),
            child: TweenAnimationBuilder<Color?>(
              tween: ColorTween(end: _focused ? theme.ring : elTransparent),
              duration: transition,
              curve: ElCurves.out,
              builder: (BuildContext context, Color? border, Widget? _) {
                return ElMachineSurface(
                  // `focus-visible:ring-3 focus-visible:ring-ring/50` over a
                  // surface with no elevation of its own.
                  spec: ElButton.withFocusRing(
                    ElShadows.none,
                    _focused
                        ? theme.ring.withValues(alpha: _focusRingAlpha)
                        : theme.ring.withValues(alpha: 0),
                  ),
                  radius: BorderRadius.circular(ElRadii.lg),
                  fill: elTransparent,
                  // `border border-transparent` — invisible and two pixels
                  // tall, which is why the trigger measures 40.56 and not
                  // 38.57.
                  border: Border.all(
                    color: border ?? elTransparent,
                    width: ElWidths.hairline,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: ElAccordion.triggerPaddingY,
                    ),
                    child: Row(
                      // `items-start`: the chevron's top edge aligns with the
                      // label's line box, not with its centre — so a question
                      // that wraps to two lines keeps its chevron on the first.
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Builder(
                            builder: (BuildContext context) {
                              // `text-sm font-medium`, plus the one thing
                              // hover does here: `hover:underline`. A
                              // decoration is neither a spec nor a colour, so
                              // this is the one label in the family that
                              // resolves its own style — and therefore the one
                              // that has to ask for [ElLineBox] by hand, where
                              // [ElText] would have brought it.
                              final TextStyle style = ElText.styleOf(
                                context,
                                ElComponentType.buttonLabel,
                                color: theme.foreground,
                              );
                              return ElLineBox(
                                style: style,
                                child: Text(
                                  widget.title,
                                  style: style.copyWith(
                                    decoration: _hovered
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                    decorationColor: theme.foreground,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // The one icon that is visible. `text-current` against
                        // the trigger's own `--foreground` — the dead
                        // `text-muted-foreground` is documented on the library.
                        ElIcon(
                          widget.expanded
                              ? ElIconGlyph.chevronUp
                              : ElIconGlyph.chevronDown,
                          sizePx: ElAccordion.chevronPx,
                          tone: ElIconTone.normal,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// `focus-visible:ring-ring/50` — the alpha every focus ring in the system
/// wears.
const double _focusRingAlpha = 0.50;
