/// `components/ui/alert.tsx` — one surface, five meanings.
///
/// Its docstring is the reason the component looks the way it does: *"Every
/// variant shares the same background, the same border and the same text
/// colour. What changes is **the icon and the bloom behind it**, nothing else.
/// That is a deliberate reversal of stock shadcn, which tints the whole card
/// and recolours the copy. Tinting had two problems here: five
/// differently-tinted cards stacked on a page read as a traffic light rather
/// than as one component, and colouring the body text is the least legible
/// place to spend a hue — lime-on-lime-tint especially."*
///
/// So a variant sets exactly three things: `*:[svg]:text-<x>-ink`, `--bloom-1`
/// and `--bloom-2`. Nothing else in the class list moves.
///
/// | property | class | value |
/// |---|---|---|
/// | layout | `grid w-full has-[>svg]:grid-cols-[auto_1fr]` | two columns when there is an icon |
/// | gaps | `gap-1` / `has-[>svg]:gap-x-3` | **4px** rows, **12px** columns |
/// | padding | `px-4 py-3.5` | **16 / 14** — *"rather than stock's 10/8 so an alert reads as a block of its own"* |
/// | shape | `rounded-lg border border-border bg-card` | 12px, 1px, `--card` |
/// | text | `text-sm text-card-foreground text-left` | 13px |
/// | icon | `*:[svg]:row-span-2 translate-y-0.5 size-4` | column 1 spanning both rows, nudged **2px** down, 16px |
/// | title | `font-medium group-has-[>svg]/alert:col-start-2` | 500, column 2 |
/// | description | `text-sm text-balance text-muted-foreground` | 13px muted |
/// | role | `role="alert"` on the root | no `aria-live`, no `aria-atomic` |
///
/// The bloom is live: both drifts, the hover swell and the starfield all run —
/// see `ElBloomCosmic`, which is where the forms page's deferral was closed.
/// `alert.tsx` L85's `<span data-slot="alert-stars" class="starfield"/>` is
/// mounted by the bloom rather than written here, because the toast reaches the
/// same effect through a different selector and both resolve against the same
/// padding box.
///
/// [ElAlert.action] closes the other half of that deferral —
/// `AlertAction`, `absolute top-2 right-2`, with the reserved lane F10 rules on
/// (see the field's own doc).
///
/// Still recorded rather than guessed:
///  * `text-balance` → `md:text-pretty` on the description. Flutter's line
///    breaker has neither mode, so the description wraps greedily. The
///    reference's balanced last line is unreachable, not skipped — supervisor
///    ruling F3 keeps the record and measures parity against a greedy wrap.
library;

import 'package:flutter/widgets.dart';

import '../effects/bloom_cosmic.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';

/// The five `cva` variants, in the reference's own declaration order.
enum ElAlertVariant {
  /// `variant="default"` — `*:[svg]:text-muted-foreground`,
  /// `[--bloom-1: var(--color-action-bright)] [--bloom-2: var(--color-action)]`.
  ///
  /// Named [normal] because `default` is a Dart keyword; [label] is the string
  /// a state matrix prints.
  normal,

  /// `*:[svg]:text-destructive-ink`,
  /// `[--bloom-1: var(--destructive)] [--bloom-2: var(--color-action)]`.
  destructive,

  /// `*:[svg]:text-success-ink`,
  /// `[--bloom-1: var(--color-success)] [--bloom-2: var(--color-value)]`.
  success,

  /// `*:[svg]:text-warning-ink`,
  /// `[--bloom-1: var(--color-warning)] [--bloom-2: var(--color-action)]`.
  ///
  /// The pair carries the longest comment in `alert.tsx`: it used to be the
  /// value ramp's two ends and *"worked only by accident"*, glowing purple
  /// under an amber glyph once the value ramp moved. The toast never got the
  /// fix — see `ElBloomCosmic.toastWarning`.
  warning,

  /// `*:[svg]:text-info-ink`,
  /// `[--bloom-1: var(--color-info)] [--bloom-2: var(--color-action)]`.
  info;

  /// The key the `cva` spells this variant with.
  String get label => this == ElAlertVariant.normal ? 'default' : name;

  /// `*:[svg]:text-<x>-ink` — the one colour a variant spends.
  Color inkOf(ElThemeData theme) => switch (this) {
    ElAlertVariant.normal => theme.mutedForeground,
    ElAlertVariant.destructive => theme.destructiveInk,
    ElAlertVariant.success => theme.successInk,
    ElAlertVariant.warning => theme.warningInk,
    ElAlertVariant.info => theme.infoInk,
  };
}

/// A persistent condition worth explaining — RULES §5's whole reservation for
/// this component.
class ElAlert extends StatelessWidget {
  const ElAlert({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.variant = ElAlertVariant.normal,
  });

  /// `--spacing * 2` — `AlertAction`'s `top-2 right-2`.
  static double get actionInset => el(2);

  /// `pr-20` — the right padding the base switches to when an action is
  /// present, in place of `px-4`'s 16.
  ///
  /// **Unconditional, and that is the point** (supervisor ruling F10).
  /// `has-data-[slot=alert-action]:pr-20` widens the lane whether or not the
  /// button would have collided with anything: on the feedback page's
  /// "Withdrawal under review" it shortens the description column from 968px to
  /// **904px**, and that is what makes the two action Alerts wrap differently
  /// from the other three. Sizing the lane to the button instead would be a
  /// better layout and a different page.
  static double get actionLane => el(20);

  /// `AlertTitle` — `font-medium`, column 2.
  final String title;

  /// `AlertDescription` — 13px muted, under the title.
  final String? description;

  /// The glyph, at `size-4` and `tone="inherit"`.
  ///
  /// Supplied rather than chosen, exactly as the reference supplies it: the
  /// page writes `<Icon icon={XCircle} size="md" tone="inherit" />` and the
  /// variant only says what colour it comes out. Its colour arrives through
  /// the surrounding [DefaultTextStyle], which is what `text-current` means.
  final Widget? icon;

  /// `AlertAction` — the absolutely-positioned top-right slot
  /// (`alert.tsx` L120–128), and the reason the root sets `relative` itself
  /// while `bloom-cosmic` deliberately does not.
  ///
  /// A slot, not a button: the page writes
  /// `<AlertAction><Button variant="secondary" size="sm">Retry</Button></AlertAction>`,
  /// so what goes here is whatever the call site puts there — a 32px `secondary
  /// sm` button on both of the feedback page's two, at 8px from the top and
  /// right of the **border** box.
  ///
  /// Its presence also widens the base's right padding; see [actionLane].
  final Widget? action;

  final ElAlertVariant variant;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final BorderRadius radius = BorderRadius.circular(ElRadii.lg);

    Widget column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElText(title, ElComponentType.buttonLabel, color: theme.cardForeground),
        if (description != null) ...<Widget>[
          // `gap-1` — the grid's row gap.
          SizedBox(height: el(1)),
          ElText(
            description!,
            ElComponentType.sheetBody,
            color: theme.mutedForeground,
          ),
        ],
      ],
    );

    if (icon != null) {
      column = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            // `translate-y-0.5` — 2px, so a 16px glyph optically centres on
            // the first line of a 13px title.
            padding: EdgeInsets.only(top: el(0.5)),
            child: DefaultTextStyle.merge(
              style: TextStyle(color: variant.inkOf(theme)),
              child: icon!,
            ),
          ),
          // `gap-x-3`.
          SizedBox(width: el(3)),
          Expanded(child: column),
        ],
      );
    }

    Widget alert = Padding(
      // `px-4 py-3.5`, with `has-data-[slot=alert-action]:pr-20` replacing the
      // right half of `px-4` whenever an action is mounted.
      padding: EdgeInsets.fromLTRB(
        el(4),
        el(3.5),
        action == null ? el(4) : ElAlert.actionLane,
        el(3.5),
      ),
      child: column,
    );

    alert = switch (variant) {
      ElAlertVariant.normal => ElBloomCosmic.action(
        radius: radius,
        fill: theme.card,
        child: alert,
      ),
      ElAlertVariant.destructive => ElBloomCosmic.destructive(
        radius: radius,
        fill: theme.card,
        child: alert,
      ),
      ElAlertVariant.success => ElBloomCosmic.success(
        radius: radius,
        fill: theme.card,
        child: alert,
      ),
      ElAlertVariant.warning => ElBloomCosmic.warning(
        radius: radius,
        fill: theme.card,
        child: alert,
      ),
      ElAlertVariant.info => ElBloomCosmic.info(
        radius: radius,
        fill: theme.card,
        child: alert,
      ),
    };

    // The border sits outside the bloom's clip, which is what `overflow:
    // hidden` clipping to the padding box means.
    alert = DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.border, width: ElWidths.hairline),
        borderRadius: radius,
      ),
      child: Padding(
        // `box-sizing: border-box` — the border is paid for out of the
        // surface's own box, the same correction `ElMachineSurface` makes.
        padding: EdgeInsets.all(ElWidths.hairline),
        child: alert,
      ),
    );

    if (action != null) {
      // `position: absolute; top: 8px; right: 8px` against the root, which is
      // `relative` — so the offsets are from the **border** box, outside the
      // bloom's clip, and the button is never dimmed by the light behind it.
      alert = Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          alert,
          Positioned(
            top: ElAlert.actionInset,
            right: ElAlert.actionInset,
            child: action!,
          ),
        ],
      );
    }

    return Semantics(
      container: true,
      // `role="alert"`, which is an assertive live region and the reason the
      // server-error surface announces itself when it appears.
      liveRegion: true,
      child: alert,
    );
  }
}
