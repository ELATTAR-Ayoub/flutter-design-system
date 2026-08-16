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

import 'package:flutter/widgets.dart';

import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../motion/swap_in.dart';
import '../theme_scope.dart';
import 'icon.dart';
import 'icon_paths.g.dart';
import 'skeleton.dart';

/// `opacity-45` — *"contrast-exempt (WCAG 2.1 SC 1.4.3, trap 9): it only has
/// to read as unavailable, and the shimmer is what separates it from
/// loading."*
const double _disabledOpacity = 0.45;

/// `StatDirection`.
enum DsStatDirection {
  /// `{ icon: ArrowUp, sign: "+", word: "Up" }`.
  up,

  /// `{ icon: ArrowDown, sign: "−", word: "Down" }` — U+2212, not a hyphen.
  down,

  /// `{ icon: Minus, sign: "", word: "No change" }`.
  flat;

  DsLucideGlyph get glyph => switch (this) {
        DsStatDirection.up => DsLucide.arrowUp,
        DsStatDirection.down => DsLucide.arrowDown,
        DsStatDirection.flat => DsLucide.minus,
      };

  /// The sign the component writes onto the magnitude.
  String get sign => switch (this) {
        DsStatDirection.up => '+',
        // U+2212 MINUS SIGN.
        DsStatDirection.down => '−',
        DsStatDirection.flat => '',
      };

  /// The `sr-only` word, which the port hands to [Semantics].
  String get word => switch (this) {
        DsStatDirection.up => 'Up',
        DsStatDirection.down => 'Down',
        DsStatDirection.flat => 'No change',
      };
}

/// `StatDelta` — *"the magnitude, unsigned. The component writes the sign."*
typedef DsStatDelta = ({String value, DsStatDirection direction});

/// `StatState`.
enum DsStatState {
  ready,
  loading,
  error,
  empty;

  /// `blank` in the component — the two states that replace the figure with an
  /// em dash.
  bool get blank => this == DsStatState.error || this == DsStatState.empty;
}

/// `<StatDeltaMark>` — the mark on its own, *"exported so a caller that already
/// has a label can reuse the mark instead of redrawing it."*
///
/// `betterWhen` is **required** here rather than defaulted, and the component
/// says why: *"a caller reaching past `Stat` for the mark alone is already
/// thinking about direction and should say which one it means."*
class DsStatDeltaMark extends StatelessWidget {
  const DsStatDeltaMark({
    super.key,
    required this.delta,
    required this.betterWhen,
  });

  final DsStatDelta delta;

  /// `"up"` or `"down"` — which direction earns the favourable colour.
  final DsStatDirection betterWhen;

  /// `gap-1`.
  static double get gap => ds(1);

  /// The ink: muted when flat, `--success-ink` when the move is favourable,
  /// plain `--foreground` when it is not.
  ///
  /// *"It is deliberately not a red/green pair … Red means error here, and a
  /// revenue dip is not an error."*
  Color ink(DsThemeData theme) {
    if (delta.direction == DsStatDirection.flat) return theme.mutedForeground;
    return delta.direction == betterWhen ? theme.successInk : theme.foreground;
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final Color color = ink(theme);

    return Semantics(
      // `<span className="sr-only">{word},</span>` — read before the number.
      label: '${delta.direction.word},',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DsIcon.lucide(
            delta.direction.glyph,
            size: DsIconSize.xs,
            tone: DsIconTone.inherit,
          ),
          SizedBox(width: gap),
          DsText(
            '${delta.direction.sign}${delta.value}',
            DsType.numSm,
            color: color,
          ),
        ],
      ),
    );
  }
}

/// The figure.
class DsStat extends StatelessWidget {
  const DsStat({
    super.key,
    required this.label,
    required this.value,
    this.delta,
    this.betterWhen = DsStatDirection.up,
    this.hint,
    this.state = DsStatState.ready,
    this.message,
    this.disabled = false,
  });

  final String label;

  /// `React.ReactNode` — a string at every call site in the corpus.
  final String value;

  /// *"Pass it while loading too — its presence is what reserves the delta
  /// line."*
  final DsStatDelta? delta;

  final DsStatDirection betterWhen;

  /// The trailing comparison — *"vs last month"*.
  final String? hint;

  final DsStatState state;

  /// *"What failed, or why there is nothing yet. Replaces `hint` in those
  /// states."*
  final String? message;

  final bool disabled;

  /// `mt-2` — under the label, and under the figure.
  static double get rowGap => ds(2);

  /// `gap-2` on the delta row, both axes (`flex-wrap`).
  static double get deltaGap => ds(2);

  /// `<Skeleton className="h-5 w-28"/>` — the figure's placeholder.
  static Size get figureSkeleton => Size(ds(28), ds(5));

  /// `<Skeleton className="h-2.5 w-14"/>` — the delta's.
  static Size get deltaSkeleton => Size(ds(14), ds(2.5));

  /// `gap-1.5` between the error glyph and its message.
  static double get messageGap => ds(1.5);

  /// The `.type-num-lg` line box the figure slot always holds.
  static double get figureHeight => DsType.numLg.size! * DsType.numLg.height!;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool loading = state == DsStatState.loading;
    final bool blank = state.blank;

    Widget figure;
    if (loading) {
      figure = DsSkeleton(
        width: figureSkeleton.width,
        height: figureSkeleton.height,
      );
    } else if (blank) {
      // `&mdash;` — U+2014, `aria-hidden`, with an `sr-only` "No value" beside
      // it.
      figure = Semantics(
        label: 'No value',
        child: DsText('—', DsType.numLg, color: theme.mutedForeground),
      );
    } else {
      figure = DsSwapIn(
        // `<span key={state}>` — a `loading → ready` transition replays it.
        replayKey: state,
        child: DsText(value, DsType.numLg, color: theme.foreground),
      );
    }

    final bool hasDeltaRow =
        delta != null || hint != null || (blank && message != null);

    Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DsText(label, DsType.label),
        SizedBox(height: rowGap),
        // The slot holds the line box whatever is in it — see the library doc.
        SizedBox(
          height: figureHeight,
          child: Align(alignment: AlignmentDirectional.centerStart, child: figure),
        ),
        if (hasDeltaRow) ...<Widget>[
          SizedBox(height: rowGap),
          Wrap(
            spacing: deltaGap,
            runSpacing: deltaGap,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              if (delta != null)
                if (loading)
                  DsSkeleton(
                    width: deltaSkeleton.width,
                    height: deltaSkeleton.height,
                  )
                else if (!blank)
                  DsStatDeltaMark(delta: delta!, betterWhen: betterWhen),
              if (state == DsStatState.error && message != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    DsIcon.lucide(
                      DsLucide.triangleAlert,
                      size: DsIconSize.xs,
                      tone: DsIconTone.inherit,
                    ),
                    SizedBox(width: messageGap),
                    DsText(message!, DsType.small,
                        color: theme.destructiveInk),
                  ],
                )
              else if (state == DsStatState.empty && message != null)
                DsText(message!, DsType.small)
              else if (hint != null)
                DsText(hint!, DsType.small),
            ],
          ),
        ],
      ],
    );

    if (disabled) {
      body = Opacity(opacity: _disabledOpacity, child: body);
    }
    return Semantics(enabled: !disabled, child: body);
  }
}
