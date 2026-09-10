/// `components/ui/progress.tsx` — a filled channel, not a hair.
///
/// Radix `Progress.Root` + `Progress.Indicator`, restyled to the **same 10px
/// sunken channel the Slider's track uses** (`progress.tsx` L9–17), because it
/// is the same object: a filled channel. The only difference is the missing
/// thumb, because you cannot grab this one. Stock shadcn ships `h-1`, a 4px
/// hair, which reads as a different component entirely next to a price filter.
///
/// | part | class list | rendered |
/// |---|---|---|
/// | root | `relative flex h-2.5 w-full items-center overflow-hidden rounded-pill border border-input bg-muted shadow-pressed` | **10px** tall, r999, 1px `--input`, `--muted` fill, the sunken socket |
/// | indicator | `size-full flex-1 transition-transform duration-base ease-out` + tone | the content box (root − 2px of border), translated |
///
/// **The fill is a translation, not a width.** The indicator is full width and
/// `style={{ transform: 'translateX(-' + (100 - value) + '%)' }}` slides it out
/// of the root's `overflow: hidden`. That is not the same as shrinking it: the
/// tone shadows carry an inset rim along the **whole** bar, and a width-driven
/// port would pin that rim to the fill's leading edge instead of letting it run
/// off the end. [Progress] therefore translates, exactly as written.
///
/// **Every fill names the `-ink` end of its ramp**, never the raw hue
/// (`progress.tsx` L19–41). The page's own note gives the arithmetic: a 10px
/// channel carries no foreground, so the only thing that makes it visible is
/// its contrast with the track — measured, `--primary` is **1.63:1** against
/// `--muted` and `--action-ink` is **6.97:1**; on light, raw `--color-success`
/// is 1.73:1 and `--success-ink` is 4.93:1.
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
import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/shadows.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/theme_scope.dart';

/// `progressIndicatorVariants` — five tones (`progress.tsx` L43–64).
enum ProgressTone {
  /// `bg-action-ink shadow-btn-primary`.
  ///
  /// Named [normal] because `default` is a Dart keyword; [label] is the key the
  /// `cva` spells it with.
  normal,

  /// `bg-value-ink shadow-btn-value` — the one place a progress track leaves
  /// the action ramp, because progression toward a reward is a value signal.
  value,

  /// `bg-success-ink shadow-btn`.
  success,

  /// `bg-warning-ink shadow-btn`.
  warning,

  /// `bg-destructive-ink shadow-btn`.
  ///
  /// For a reading **outside its safe band**, never for one that merely fell. A
  /// figure moving the wrong way is news, not a fault — RULES §1.4 — and it
  /// stays on [normal].
  destructive;

  /// The key the `cva` spells this tone with.
  String get label => this == ProgressTone.normal ? 'default' : name;

  /// `bg-<x>-ink` — the fill.
  Color inkOf(ThemeTokens theme) => switch (this) {
    ProgressTone.normal => theme.actionText,
    ProgressTone.value => theme.premiumText,
    ProgressTone.success => theme.successText,
    ProgressTone.warning => theme.warningText,
    ProgressTone.destructive => theme.destructiveText,
  };

  /// `shadow-btn-primary` / `shadow-btn-value` / `shadow-btn` — the two lit
  /// tones carry their ramp's own glow, the other three the plain machine
  /// shadow.
  ShadowStyle get shadow => switch (this) {
    ProgressTone.normal => Shadows.controlPrimary,
    ProgressTone.value => Shadows.controlPremium,
    ProgressTone.success ||
    ProgressTone.warning ||
    ProgressTone.destructive => Shadows.control,
  };
}

/// A determinate progress channel.
///
/// ## Two page-level facts this component cannot state for itself
///
/// Both belong to the call site, and both are recorded here because the call
/// site is a different file and a reader of *this* one would otherwise correct
/// them:
///
/// **DRIFT 6 — the first bar has no accessible name.** `page.tsx:339` is a bare
/// `<Progress value={20.6} />`; every other bar on the page passes an
/// `aria-label`, including the two that sit beside an identical `type-label`.
/// Its readout "412 / 2,000" is a sibling `<span>`, unassociated. [label] is
/// therefore **optional** rather than required, so the page can reproduce the
/// omission instead of quietly fixing it.
///
/// **DRIFT 7 — `PROGRESS_TONES`' comment contradicts its contents.** The page
/// declares the second panel's rows behind this comment, verbatim
/// (`page.tsx:52–54`):
///
/// > `default` and `value` are shown above in their own context, so this row is
/// > the four that say something about the reading itself.
///
/// …and the array's first entry is `{ tone: "default", label: "Steps today",
/// value: 72 }`. Four entries, one of which is `default`; `value` is indeed
/// absent. Counting both panels, the page's seven bars are **three `default`**,
/// one `value`, one `success`, one `warning` and one `destructive`. The array
/// itself is page content and lives with the page; the comment is transcribed
/// here so that porting it verbatim is a decision someone already made.
class Progress extends StatelessWidget {
  const Progress({
    super.key,
    required this.value,
    this.tone = ProgressTone.normal,
    this.label,
  });

  /// `h-2.5` — the channel, and the Slider track's own height.
  static double get height => space(2.5);

  /// `transition-transform duration-base ease-out`.
  ///
  /// `duration-base` is a `duration-<word>` utility, which Tailwind v4 cannot
  /// generate (there is no `--duration-*` theme namespace), so it emits nothing
  /// and the transition falls through to `--default-transition-duration`. That
  /// is [MotionDurations.normal], not [MotionDurations.normal] — two
  /// declarations that agree at 250ms today. Measured on the live page as
  /// `transform 250ms cubic-bezier(0.22, 1, 0.36, 1)`.
  static Duration get transition => MotionDurations.normal;

  /// `value` — 0…100. The reference passes fractions (20.6, 66.7) and so may a
  /// caller.
  final double value;

  final ProgressTone tone;

  /// `aria-label`. Null reproduces the reference's own first bar — see the
  /// class doc, drift 6.
  final String? label;

  /// `transform: translateX(-(100 - value)%)`, as a fraction of the
  /// indicator's own width.
  ///
  /// Derived rather than typed so the page and any probe read one expression:
  /// 100 is fully retracted (−1), 0 is fully shown.
  double get translation => -(100 - value.clamp(0, 100)) / 100;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final BorderRadius radius = BorderRadius.circular(Radii.full);

    return Semantics(
      label: label,
      value: '${value.round()}%',
      child: SizedBox(
        height: height,
        child: Surface(
          // `bg-muted shadow-pressed border border-input rounded-pill`.
          spec: Shadows.inset,
          radius: radius,
          fill: theme.muted,
          border: Border.all(color: theme.input, width: BorderWidths.hairline),
          child: ClipRRect(
            // `overflow: hidden` — the clip the translation slides out of.
            borderRadius: radius,
            child: _AnimatedFractionalTranslation(
              // CSS translates by a percentage of the translated box, which is
              // exactly what a fractional translation is.
              translation: Offset(translation, 0),
              duration: effectiveMotionDuration(context, transition),
              curve: MotionCurves.enter,
              // `size-full flex-1` with the tone's own fill and shadow. Its
              // radius is [BorderRadius.zero]: the indicator declares none of
              // its own and takes its shape from the root's clip.
              child: Surface(
                spec: tone.shadow,
                radius: BorderRadius.zero,
                fill: tone.inkOf(theme),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// [FractionalTranslation] under the indicator's own `transition-transform`.
///
/// Private: it is [Progress]'s own plumbing, not a component, and the barrel
/// exports what a call site is meant to reach for.
///
/// Flutter ships `AnimatedSlide`, which is this — but it also ships it with a
/// default curve and no way to say "the transition is the element's, not the
/// caller's". Spelling it out keeps the duration and the curve beside the
/// declaration they transcribe, and keeps the reduced-motion collapse in one
/// place: a zero duration lands the fill on its value without a tween, which is
/// what a 0.01ms transition does.
class _AnimatedFractionalTranslation extends ImplicitlyAnimatedWidget {
  const _AnimatedFractionalTranslation({
    required this.translation,
    required super.duration,
    required super.curve,
    required this.child,
  });

  final Offset translation;
  final Widget child;

  @override
  AnimatedWidgetBaseState<_AnimatedFractionalTranslation> createState() =>
      _AnimatedFractionalTranslationState();
}

class _AnimatedFractionalTranslationState
    extends AnimatedWidgetBaseState<_AnimatedFractionalTranslation> {
  Tween<Offset>? _translation;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _translation =
        visitor(
              _translation,
              widget.translation,
              (dynamic value) => Tween<Offset>(begin: value as Offset),
            )
            as Tween<Offset>?;
  }

  @override
  Widget build(BuildContext context) => FractionalTranslation(
    translation: _translation!.evaluate(animation),
    child: widget.child,
  );
}
