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
/// Scope, per supervisor ruling F1: the fidelity the forms page renders. The
/// bloom is mounted **static** — see `DsBloomCosmic`, which records why the two
/// infinite drifts and the starfield wait for the `feedback` page.
///
/// Not ported, and recorded rather than guessed:
///  * `AlertAction` (`absolute top-2 right-2`, with `has-data-[slot=alert-action]:pr-20`)
///    — no call site on this page;
///  * `text-balance` → `md:text-pretty` on the description. Flutter's line
///    breaker has neither mode, so the description wraps greedily. The
///    reference's balanced last line is unreachable, not skipped.
library;

import 'package:flutter/widgets.dart';

import '../effects/bloom_cosmic.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';

/// The five `cva` variants, in the reference's own declaration order.
enum DsAlertVariant {
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
  /// fix — see `DsBloomCosmic.toastWarning`.
  warning,

  /// `*:[svg]:text-info-ink`,
  /// `[--bloom-1: var(--color-info)] [--bloom-2: var(--color-action)]`.
  info;

  /// The key the `cva` spells this variant with.
  String get label => this == DsAlertVariant.normal ? 'default' : name;

  /// `*:[svg]:text-<x>-ink` — the one colour a variant spends.
  Color inkOf(DsThemeData theme) => switch (this) {
        DsAlertVariant.normal => theme.mutedForeground,
        DsAlertVariant.destructive => theme.destructiveInk,
        DsAlertVariant.success => theme.successInk,
        DsAlertVariant.warning => theme.warningInk,
        DsAlertVariant.info => theme.infoInk,
      };
}

/// A persistent condition worth explaining — RULES §5's whole reservation for
/// this component.
class DsAlert extends StatelessWidget {
  const DsAlert({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.variant = DsAlertVariant.normal,
  });

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

  final DsAlertVariant variant;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final BorderRadius radius = BorderRadius.circular(DsRadii.lg);

    Widget column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DsText(title, DsComponentType.buttonLabel, color: theme.cardForeground),
        if (description != null) ...<Widget>[
          // `gap-1` — the grid's row gap.
          SizedBox(height: ds(1)),
          DsText(
            description!,
            DsComponentType.sheetBody,
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
            padding: EdgeInsets.only(top: ds(0.5)),
            child: DefaultTextStyle.merge(
              style: TextStyle(color: variant.inkOf(theme)),
              child: icon!,
            ),
          ),
          // `gap-x-3`.
          SizedBox(width: ds(3)),
          Expanded(child: column),
        ],
      );
    }

    Widget alert = Padding(
      // `px-4 py-3.5`.
      padding: EdgeInsets.symmetric(horizontal: ds(4), vertical: ds(3.5)),
      child: column,
    );

    alert = switch (variant) {
      DsAlertVariant.normal => DsBloomCosmic.action(
          radius: radius,
          fill: theme.card,
          child: alert,
        ),
      DsAlertVariant.destructive => DsBloomCosmic.destructive(
          radius: radius,
          fill: theme.card,
          child: alert,
        ),
      DsAlertVariant.success => DsBloomCosmic.success(
          radius: radius,
          fill: theme.card,
          child: alert,
        ),
      DsAlertVariant.warning => DsBloomCosmic.warning(
          radius: radius,
          fill: theme.card,
          child: alert,
        ),
      DsAlertVariant.info => DsBloomCosmic.info(
          radius: radius,
          fill: theme.card,
          child: alert,
        ),
    };

    // The border sits outside the bloom's clip, which is what `overflow:
    // hidden` clipping to the padding box means.
    alert = DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.border, width: DsWidths.hairline),
        borderRadius: radius,
      ),
      child: Padding(
        // `box-sizing: border-box` — the border is paid for out of the
        // surface's own box, the same correction `DsMachineSurface` makes.
        padding: EdgeInsets.all(DsWidths.hairline),
        child: alert,
      ),
    );

    return Semantics(
      container: true,
      // `role="alert"`, which is an assertive live region and the reason the
      // server-error surface announces itself when it appears.
      liveRegion: true,
      child: alert,
    );
  }
}
