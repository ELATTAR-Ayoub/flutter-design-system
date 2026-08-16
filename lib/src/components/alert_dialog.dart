/// `components/ui/alert-dialog.tsx` — *"for actions that cannot be undone."*
///
/// It shares `DialogContent`'s panel, its jelly and its scrim, and departs from
/// it in exactly one place. The reference states the departure at length, in
/// the header's own source comment, and it is the reason this is a separate
/// file rather than a `variant`:
///
/// > NO BAND HERE, and this is the one place Alert Dialog departs from Dialog.
/// > `DialogHeader` bands because a normal dialog is a container for a task:
/// > the header names it, the body is the work, the footer closes it, and three
/// > zones make that structure legible.
/// > An alert dialog is not a container for a task. It is a single question,
/// > and the question IS the content. Banding the header wraps that one
/// > sentence in a card box and demotes the most important words on screen into
/// > a caption for whatever sits under them — which is exactly backwards. The
/// > title and description now sit directly on the panel with nothing competing
/// > for them.
/// > The footer keeps its band, because the footer is the decision.
///
/// Measured open (2026-08-16, 1440x900), against the plain dialog beside it:
///
/// | part | measured |
/// |---|---|
/// | content | 384 (`max-w-xs` base, `sm:max-w-sm`), `p-4`, `gap-4`, 16px radius, ring only — the same panel |
/// | header | **inside** the padding at 352 wide, `grid` with `place-items-start` and `text-left` at `sm:`, `gap-1.5` 6px |
/// | title | `font-heading text-base font-medium` and **no `leading-none`** — 15px in a 22.5px box, where the dialog's is 15 in 15 |
/// | footer | the same band as the dialog's, bleeding to 384 with a 1px top rule |
/// | dismissal | Escape closes it; **a click on the overlay does not** — measured both ways |
///
/// ## Two drifts, reproduced
///
///  1. **Escape closes it.** The section's own description promises *"no
///     overlay click, no escape-to-cancel by accident"*. Half of that is true:
///     `page.mouse.click(60, 60)` leaves the content mounted, and
///     `keyboard.press('Escape')` unmounts it. Radix's `AlertDialog` blocks
///     `onPointerDownOutside` and not `onEscapeKeyDown`, and the reference
///     passes neither handler. The copy renders as written and so does the
///     behaviour.
///  2. **Both buttons carry a tooltip of their own label.** `fullLabel =
///     tooltip ?? (typeof children === "string" ? children : null)`, and a
///     non-null `fullLabel` wraps the button in a `Tooltip` whose content *is*
///     the label. So hovering "Sell all for $2,481.00" shows a tooltip reading
///     "Sell all for $2,481.00". It exists for the `shrink!` case where the
///     label is truncated; on this page nothing truncates, and it fires anyway.
///
/// Not built: `AlertDialogMedia` and the `size="sm"` two-column footer. Both
/// are real exports with no consumer in the corpus — the `asChild` precedent —
/// and [DsAlertDialogSize] records the second so a caller can ask for it.
library;

import 'package:flutter/widgets.dart';

import '../effects/machine_surface.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';
import 'button.dart';
import 'dialog.dart';
import 'tooltip.dart';

/// `bg-muted/50` — the footer band.
const double _bandAlpha = 0.5;

/// `data-size` — `default` and `sm`, whose only difference is the footer.
enum DsAlertDialogSize {
  /// `data-[size=default]:max-w-xs data-[size=default]:sm:max-w-sm`, and a
  /// header that starts left rather than centred from `sm:` up.
  ///
  /// Named [normal] because `default` is a Dart keyword.
  normal,

  /// `max-w-xs` at every width, a header that stays centred, and a footer that
  /// becomes `grid grid-cols-2`.
  ///
  /// RECORDED, NOT BUILT: nothing in the corpus passes it. The enum carries it
  /// so the gap is a named absence rather than a silent one.
  sm,
}

/// `AlertDialog` — trigger, portal, overlay, content.
class DsAlertDialog extends StatelessWidget {
  const DsAlertDialog({
    super.key,
    required this.trigger,
    required this.content,
    this.onOpenChange,
  });

  final DsModalTriggerBuilder trigger;
  final DsModalContentBuilder content;
  final ValueChanged<bool>? onOpenChange;

  @override
  Widget build(BuildContext context) => DsModalPortal(
        trigger: trigger,
        content: content,
        onOpenChange: onOpenChange,
        // *"Not dismissible by overlay click"* — and measured refusing to be.
        dismissOnOverlayTap: false,
        transition: (
          BuildContext context,
          Animation<double> animation,
          Widget child,
        ) =>
            DsJellyTransition(animation: animation, child: child),
      );
}

/// `AlertDialogContent` — the panel.
class DsAlertDialogContent extends StatelessWidget {
  const DsAlertDialogContent({
    super.key,
    required this.header,
    required this.footer,
    this.size = DsAlertDialogSize.normal,
  });

  final DsAlertDialogHeader header;
  final DsAlertDialogFooter footer;
  final DsAlertDialogSize size;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final double pad = DsDialogContent.padding;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: size == DsAlertDialogSize.normal
            ? DsDialogContent.maxWidth
            : DsContainers.xs,
      ),
      child: DefaultTextStyle(
        // `text-popover-foreground` and **no `text-sm`** — the content itself
        // stays at the document's own 16px, and every string inside it carries
        // its own class. Measured: `font-size: 16px` on the content, 15 on the
        // title, 13 on the description.
        style: DefaultTextStyle.of(context)
            .style
            .copyWith(color: theme.popoverForeground),
        child: DsMachineSurface(
          // The same panel as `DialogContent`'s — one ring, no elevation —
          // named from the one place so the two cannot drift apart.
          spec: DsDialogContent.ringSpec,
          radius: BorderRadius.circular(DsDialogContent.radius),
          fill: theme.popover,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // The header is inside `p-4`, unlike the dialog's banded one.
              Padding(
                padding: EdgeInsets.fromLTRB(pad, pad, pad, 0),
                child: header,
              ),
              // `gap-4`.
              SizedBox(height: pad),
              // The footer bleeds: `-mx-4 -mb-4`.
              footer,
            ],
          ),
        ),
      ),
    );
  }
}

/// `AlertDialogHeader` — the question, straight on the panel.
class DsAlertDialogHeader extends StatelessWidget {
  const DsAlertDialogHeader({
    super.key,
    required this.title,
    required this.description,
  });

  final Widget title;
  final Widget description;

  /// `gap-1.5`.
  static double get gap => ds(1.5);

  @override
  Widget build(BuildContext context) => Column(
        // `sm:place-items-start sm:text-left` — the branch every measured frame
        // is in. Below `sm` it is `place-items-center text-center`, which the
        // port's 1440 frame never reaches.
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[title, SizedBox(height: gap), description],
      );
}

/// `AlertDialogTitle` — `font-heading text-base font-medium`, no leading
/// override.
class DsAlertDialogTitle extends StatelessWidget {
  const DsAlertDialogTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => DsText(
        text,
        DsComponentType.overlayTitle,
        color: DsTheme.of(context).foreground,
      );
}

/// `AlertDialogDescription` — `text-sm text-balance text-muted-foreground
/// md:text-pretty`.
///
/// `text-balance` and `text-pretty` are RECORDED AND UNREACHABLE, on the
/// feedback page's F3 precedent: Flutter's line breaker has no balanced or
/// pretty mode, so the description wraps greedily and the measured height is
/// the greedy one. The reference's own 55.69px three-line box is what the
/// oracle pins.
class DsAlertDialogDescription extends StatelessWidget {
  const DsAlertDialogDescription(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => DsText(
        text,
        DsComponentType.sheetBody,
        color: DsTheme.of(context).mutedForeground,
      );
}

/// `AlertDialogFooter` — the band, because *"the footer is the decision"*.
class DsAlertDialogFooter extends StatelessWidget {
  const DsAlertDialogFooter({
    super.key,
    required this.cancel,
    required this.action,
  });

  /// `AlertDialogCancel`, rendered first — the safe choice on the left.
  final Widget cancel;

  /// `AlertDialogAction`.
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final double pad = DsDialogContent.padding;

    // [Container] pays for the rule out of the band's own box — see
    // `DsDialogFooter`.
    return Container(
      decoration: BoxDecoration(
        color: theme.muted.withValues(alpha: _bandAlpha),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(DsDialogContent.radius),
        ),
        border: Border(
          top: BorderSide(color: theme.border, width: DsWidths.hairline),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(pad),
        child: Row(
          // `sm:flex-row sm:justify-end`.
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // `min-w-0 shrink!` on both. `Button`'s own base is
            // `shrink-0 max-w-full`, and this is the one place the system
            // overrides it — which is what lets a long consequence label
            // truncate instead of pushing the panel wider. The danger zone's
            // *"Delete my account and all files"* beside *"Keep my account"*
            // needs 373px inside a 352px band, and both shrink to fit.
            Flexible(child: cancel),
            SizedBox(width: ds(2)),
            Flexible(child: action),
          ],
        ),
      ),
    );
  }
}

/// `AlertDialogAction` — *"the confirming button. Defaults to `destructive`
/// because that is what an alert dialog is for."*
///
/// The reference declares `loading` here rather than inheriting `Button`'s, and
/// says why at length: `Button asChild` renders its child verbatim and sets
/// `disabled={undefined}`, so a `loading` passed to a `Button asChild` *"would
/// have been accepted by the type and then done nothing at all — a silent no-op
/// on the one button in the system where 'did that register?' matters most."*
/// The port has no `asChild`, so [DsButton.loading] is the real thing and the
/// prop simply forwards — but the reasoning is kept, because it is the
/// justification for the state existing at all.
class DsAlertDialogAction extends StatelessWidget {
  const DsAlertDialogAction({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = DsButtonVariant.destructive,
    this.size = DsButtonSize.md,
    this.loading = false,
    this.tooltip,
  });

  final String label;
  final VoidCallback? onPressed;
  final DsButtonVariant variant;
  final DsButtonSize size;

  /// *"Swaps in a spinner, sets `aria-busy`, and blocks a second press."*
  final bool loading;

  /// `tooltip ?? children` — see the library doc's drift 2. Passing null does
  /// **not** mean "no tooltip": the label becomes the tooltip.
  final String? tooltip;

  @override
  Widget build(BuildContext context) => DsTooltip(
        label: tooltip ?? label,
        child: DsButton(
          variant: variant,
          size: size,
          loading: loading,
          onPressed: loading ? null : onPressed,
          child: _ButtonLabel(label),
        ),
      );
}

/// `AlertDialogCancel` — `variant="outline"`, and the same tooltip rule.
class DsAlertDialogCancel extends StatelessWidget {
  const DsAlertDialogCancel({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = DsButtonVariant.outline,
    this.size = DsButtonSize.md,
    this.tooltip,
  });

  final String label;
  final VoidCallback? onPressed;
  final DsButtonVariant variant;
  final DsButtonSize size;
  final String? tooltip;

  @override
  Widget build(BuildContext context) => DsTooltip(
        label: tooltip ?? label,
        child: DsButton(
          variant: variant,
          size: size,
          onPressed: onPressed,
          child: _ButtonLabel(label),
        ),
      );
}

/// `ButtonLabel` — `min-w-0 truncate`, the span both `AlertDialogAction` and
/// `AlertDialogCancel` wrap their children in.
///
/// It is the other half of `shrink!`: a shrinking button whose label could not
/// truncate would simply overflow. It is also why the tooltip fallback exists —
/// a truncated consequence is exactly the label a reader needs spelled out.
class _ButtonLabel extends StatelessWidget {
  const _ButtonLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      );
}
