/// `components/ui/stat.tsx` — a labelled figure, an optional delta, an
/// optional trailing hint.
///
/// ```
/// Revenue
/// $12,480
/// ↑ +8.2%   vs last month
/// ```
///
/// The file's own docstring is the spec, and two of its claims are load-bearing
/// enough to quote:
///
/// > It draws NO container. No border, no fill, no padding — so it composes
/// > into a `Card`, a `Panel`, a table cell or a page header without a second
/// > surface appearing inside the first. The host owns the box, and the host
/// > owns any interaction: a Stat is not a control.
///
/// > Trap 11: a mark whose only difference between states is hue is ONE signal,
/// > not two. So the direction is carried three ways before colour is
/// > considered: the glyph's shape; the sign the component writes onto the
/// > number; a visually hidden word for assistive tech.
///
/// ## The footprint is identical in every state, and that is measured
///
/// | slot | height |
/// |---|---|
/// | `.type-label` | 11 |
/// | `mt-2` | 8 |
/// | `.type-num-lg` | 29.39 |
/// | `mt-2` | 8 |
/// | the delta row | 19.5 |
/// | **total** | **75.89** |
///
/// — the same 75.89 in `ready`, `loading`, `error`, `empty` and `disabled`
/// *(measured on all five cells of the page's state grid)*. The figure slot
/// holds its own line box whatever is in it: the loading skeleton is `h-5`
/// (20px) inside a 29.39px line, and the blank states put an em dash there.
/// This widget reproduces that by giving the slot the line box as a fixed
/// height rather than by letting each state size it — which is the same
/// guarantee, stated once.
///
/// The one deliberate approximation: the browser sits the 20px skeleton on the
/// paragraph's baseline, 4px below the line box's top; this centres it, 0.695px
/// lower. Nothing downstream moves, because the slot's own height is fixed.
///
/// ## The delta
///
/// `−` is U+2212 MINUS SIGN, not a hyphen — *"the same width as the `+` in the
/// tabular numeric treatment, so a column of deltas keeps its digits
/// aligned."* `flat` writes no sign at all.
///
/// **Not ported:** nothing. `betterWhen`, `state`, `message` and `disabled` all
/// have call sites on the data page, and the `sr-only` direction word arrives
/// as a [Semantics] label rather than as a 1px box.
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
import '../../design_system/foundation/surfaces.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import './content_change.dart';
import '../../design_system/foundation/theme_scope.dart';
import './icon.dart';
import './icon_paths.g.dart';
import './skeleton.dart';

/// `StatDirection`.
enum StatDirection {
  /// `{ icon: ArrowUp, sign: "+", word: "Up" }`.
  up,

  /// `{ icon: ArrowDown, sign: "−", word: "Down" }` — U+2212, not a hyphen.
  down,

  /// `{ icon: Minus, sign: "", word: "No change" }`.
  flat;

  LucideGlyph get glyph => switch (this) {
    StatDirection.up => Lucide.arrowUp,
    StatDirection.down => Lucide.arrowDown,
    StatDirection.flat => Lucide.minus,
  };

  /// The sign the component writes onto the magnitude.
  String get sign => switch (this) {
    StatDirection.up => '+',
    // U+2212 MINUS SIGN.
    StatDirection.down => '−',
    StatDirection.flat => '',
  };

  /// The `sr-only` word, which the port hands to [Semantics].
  String get word => switch (this) {
    StatDirection.up => 'Up',
    StatDirection.down => 'Down',
    StatDirection.flat => 'No change',
  };
}

/// `StatDelta` — *"the magnitude, unsigned. The component writes the sign."*
typedef StatDelta = ({String value, StatDirection direction});

/// `StatState`.
enum StatState {
  ready,
  loading,
  error,
  empty;

  /// `blank` in the component — the two states that replace the figure with an
  /// em dash.
  bool get blank => this == StatState.error || this == StatState.empty;
}

/// `<StatDeltaMark>` — the mark on its own, *"exported so a caller that already
/// has a label can reuse the mark instead of redrawing it."*
///
/// `betterWhen` is **required** here rather than defaulted, and the component
/// says why: *"a caller reaching past `Stat` for the mark alone is already
/// thinking about direction and should say which one it means."*
class StatDeltaMark extends StatelessWidget {
  const StatDeltaMark({
    super.key,
    required this.delta,
    required this.betterWhen,
  });

  final StatDelta delta;

  /// `"up"` or `"down"` — which direction earns the favourable colour.
  final StatDirection betterWhen;

  /// `gap-1`.
  static double get gap => space(1);

  /// The ink: muted when flat, `--success-ink` when the move is favourable,
  /// plain `--foreground` when it is not.
  ///
  /// *"It is deliberately not a red/green pair … Red means error here, and a
  /// revenue dip is not an error."*
  Color ink(ThemeTokens theme) {
    if (delta.direction == StatDirection.flat) return theme.mutedForeground;
    return delta.direction == betterWhen ? theme.successText : theme.foreground;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Color color = ink(theme);

    return Semantics(
      // `<span className="sr-only">{word},</span>` — read before the number.
      label: '${delta.direction.word},',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon.lucide(
            delta.direction.glyph,
            size: IconSize.xs,
            tone: IconTone.inherit,
          ),
          SizedBox(width: gap),
          // The arrow is fixed and the number gives: a mark inside a `Wrap`
          // is offered the run's remaining width, and at 200% text a long
          // delta is wider than what is left of it.
          Flexible(
            child: StyledText(
              '${delta.direction.sign}${delta.value}',
              TextStyles.numberSm,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// The figure.
class Stat extends StatelessWidget {
  const Stat({
    super.key,
    required this.label,
    required this.value,
    this.delta,
    this.betterWhen = StatDirection.up,
    this.hint,
    this.state = StatState.ready,
    this.message,
    this.disabled = false,
  });

  final String label;

  /// `React.ReactNode` — a string at every call site in the corpus.
  final String value;

  /// *"Pass it while loading too — its presence is what reserves the delta
  /// line."*
  final StatDelta? delta;

  final StatDirection betterWhen;

  /// The trailing comparison — *"vs last month"*.
  final String? hint;

  final StatState state;

  /// *"What failed, or why there is nothing yet. Replaces `hint` in those
  /// states."*
  final String? message;

  final bool disabled;

  /// `mt-2` — under the label, and under the figure.
  static double get rowGap => space(2);

  /// `gap-2` on the delta row, both axes (`flex-wrap`).
  static double get deltaGap => space(2);

  /// `<Skeleton className="h-5 w-28"/>` — the figure's placeholder.
  static Size get figureSkeleton => Size(space(28), space(5));

  /// `<Skeleton className="h-2.5 w-14"/>` — the delta's.
  static Size get deltaSkeleton => Size(space(14), space(2.5));

  /// `gap-1.5` between the error glyph and its message.
  static double get messageGap => space(1.5);

  /// The room the figure slot reserves, so a skeleton, a number, and an error
  /// message occupy the same space and the card never reflows as a stat loads.
  ///
  /// A **minimum**, not a height: it is one `numberLg` line box at the current
  /// width, scaled by the reader's text scale, and the slot grows past it when
  /// the content is taller.
  static double figureMinHeightOf(BuildContext context) =>
      MediaQuery.textScalerOf(
        context,
      ).scale(StyledText.stepOf(context, TextStyles.numberLg).leading);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final bool loading = state == StatState.loading;
    final bool blank = state.blank;

    Widget figure;
    if (loading) {
      figure = Skeleton(
        width: figureSkeleton.width,
        height: figureSkeleton.height,
      );
    } else if (blank) {
      // `&mdash;` — U+2014, `aria-hidden`, with an `sr-only` "No value" beside
      // it.
      figure = Semantics(
        label: 'No value',
        child: StyledText(
          '—',
          TextStyles.numberLg,
          color: theme.mutedForeground,
        ),
      );
    } else {
      figure = ContentChange(
        // `<span key={state}>` — a `loading → ready` transition replays it.
        replayKey: state,
        child: StyledText(value, TextStyles.numberLg, color: theme.foreground),
      );
    }

    final bool hasDeltaRow =
        delta != null || hint != null || (blank && message != null);

    Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText(label, TextStyles.small),
        SizedBox(height: rowGap),
        // The slot reserves the line box whatever is in it, and grows past it
        // when the content is taller — see the library doc.
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: figureMinHeightOf(context)),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: figure,
          ),
        ),
        if (hasDeltaRow) ...<Widget>[
          SizedBox(height: rowGap),
          if (state == StatState.error && message != null)
            // Not put through the `Wrap` below: `Wrap` hands every child
            // *unbounded* main-axis constraints — that is how a run decides
            // what fits — so a `Flexible`/ellipsis inside one never actually
            // gets to shrink; the row just paints past a narrow cell at any
            // text scale. A direct `Column` child gets the card's real width
            // instead, which is what the glyph-fixed, message-gives shape
            // needs to work at all.
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon.lucide(
                  Lucide.triangleAlert,
                  size: IconSize.xs,
                  tone: IconTone.inherit,
                ),
                SizedBox(width: messageGap),
                Flexible(
                  child: StyledText(
                    message!,
                    TextStyles.small,
                    color: theme.destructiveText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          else
            Wrap(
              spacing: deltaGap,
              runSpacing: deltaGap,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                if (delta != null)
                  if (loading)
                    Skeleton(
                      width: deltaSkeleton.width,
                      height: deltaSkeleton.height,
                    )
                  else if (!blank)
                    StatDeltaMark(delta: delta!, betterWhen: betterWhen),
                if (state == StatState.empty && message != null)
                  StyledText(message!, TextStyles.small)
                else if (hint != null)
                  StyledText(hint!, TextStyles.small),
              ],
            ),
        ],
      ],
    );

    if (disabled) {
      body = Opacity(opacity: SurfaceOpacity.disabled, child: body);
    }
    return Semantics(enabled: !disabled, child: body);
  }
}
