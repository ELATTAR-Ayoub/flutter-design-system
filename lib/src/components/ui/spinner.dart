/// `components/ui/spinner.tsx` — the twelve-line component `loading` renders.
///
/// ```tsx
/// <Icon icon={Loader2Icon} data-slot="spinner" role="status" aria-label="Loading"
///       className={cn("size-4 anim-spin", className)} {...props} />
/// ```
///
/// Three facts, and each one is deliberate:
///
/// * **`size-4` is explicit**, so it escapes `Button`'s
///   `[&_svg:not([class*='size-'])]:size-4` override rather than being caught by
///   it. The distinction has no effect on this page — both roads lead to 16px —
///   but it means the spinner is 16px inside an `xl` button too, where the
///   override would have made it 20.
/// * **`linear` on purpose.** `anim-spin` is `pulls-spin 0.9s linear infinite`
///   (globals.css L2407–2409), and the utility's own comment says why
///   (L2403–2406): *"a spinner that eases is a spinner that looks like it is
///   struggling."* It is the only animation in the system that does not take a
///   `--ease-*` curve.
/// * **It is silent.** See [Spinner] itself — that one is a drift, not a
///   decision, and the port reproduces it under supervisor ruling B9.
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

import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/theme_scope.dart';
import './icon.dart';
import './icon_paths.dart';

/// A 16px `loader-circle` glyph rotating once every 900ms, forever.
///
/// ACCESSIBILITY — DOCUMENTED DRIFT (buttons-map drift 4 / forms-map drift 3),
/// reproduced under supervisor ruling B9 rather than corrected.
///
/// `spinner.tsx` hands `Icon` a `role="status"` and an `aria-label="Loading"`,
/// and `Icon` (`icon.tsx` L68–74) destructures only `{icon, size, tone, label,
/// className}` and spreads nothing — so both attributes, and `data-slot`, are
/// dropped on the floor. With no `label` reaching it, the glyph renders
/// `aria-hidden="true"`. The spinner announces nothing; the only signal a
/// screen reader gets from a loading button is its `aria-busy`.
///
/// Flutter has no equivalent of "props silently lost to a destructure", so the
/// port has to *choose*. It chooses the rendered behaviour over the written
/// intent, consistent with how every other drift on this page is treated: the
/// glyph is wrapped in [ExcludeSemantics] (which is what [Icon] does for a
/// null `label` anyway, spelled out here so the choice is visible), and
/// [Button] carries the busy state alone.
class Spinner extends StatefulWidget {
  const Spinner({super.key, this.size = Spinner.px, this.strokeOverride});

  /// `size-4` — 16px, stated explicitly on the class list.
  ///
  /// Named rather than inlined because [Button] has to reason about it: the
  /// spinner is what makes a loading button 24px wider than a resting one
  /// (16 for the glyph, 8 for the gap), and that arithmetic should read against
  /// one constant.
  static const double px = 16;

  /// The rendered box. Defaults to [px]; a caller that wants another size is
  /// doing what `className="size-5"` would do.
  final double size;

  /// The stroke, for a caller that wants one this widget would not choose.
  ///
  /// Left null it is **not** derived from [size], and that is the point —
  /// feedback-map drift 11. `Icon` computes `strokeWidth` from the `size`
  /// **prop**, and `spinner.tsx` never passes one, so every spinner on the
  /// reference is computed at `size="md"` (16px → 2.4) no matter what the
  /// className does to its box. Measured on the `feedback` page: the `size-5`
  /// and `size-6` spinners render 20px and 24px glyphs **still at 2.4**, where
  /// the ladder's own rule would have given them 2. Deriving from [size] would
  /// have drawn 1.92 and 2 — visibly thinner than the reference, and a
  /// correction the reference never made.
  final double? strokeOverride;

  @override
  State<Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner>
    with SingleTickerProviderStateMixin {
  /// The duration named here is a placeholder for the first frame only —
  /// [build] re-reads it through [effectiveMotionDuration] every pass, the way
  /// `Press`, `ActiveIndicator` and `KeyframePlayer` all do.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: MotionDurations.spin,
  );

  /// Null until the first resolution, so a MediaQuery change that is *not* a
  /// reduced-motion change does not restart the spin.
  bool? _stilled;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool stilled =
        effectiveMotionDuration(context, MotionDurations.spin) == Duration.zero;
    if (_stilled == stilled) return;
    _stilled = stilled;
    _play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Reduced motion (supervisor ruling B13): the blanket CSS rule collapses
  /// `animation-duration` to 0.01ms **and `animation-iteration-count` to 1**,
  /// so the spinner does not stop existing — it completes one 0.01ms turn and
  /// holds. `pulls-spin` declares no fill mode, so what it holds is the
  /// element's resting style: **0°, upright, still**. Stopping the controller
  /// at its lower bound is that frame.
  void _play() {
    if (_stilled ?? false) {
      _controller.stop();
      _controller.value = _controller.lowerBound;
      return;
    }
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    _controller.duration = effectiveMotionDuration(
      context,
      MotionDurations.spin,
    );

    // `@keyframes pulls-spin { to { transform: rotate(360deg) } }`
    // (globals.css L2451–2453) — one property, one stop, and an implicit `from`
    // of the element's current 0°. A whole turn per cycle, so progress in 0..1
    // maps straight onto turns and there is no keyframe table to transcribe.
    return RepaintBoundary(
      child: ExcludeSemantics(
        child: RotationTransition(
          turns: _controller,
          child: Icon(
            IconGlyph.loaderCircle,
            // `Icon`'s own default: `size="md"`, which is 16px and therefore
            // stroke 2.4. The `size-4` class then sets the *rendered* box to
            // the same 16 — the one place on this page where the declared size
            // and the rendered size agree.
            sizePx: widget.size,
            // …and everywhere it does NOT agree, the stroke stays behind with
            // the prop. See [strokeOverride].
            strokeOverride: widget.strokeOverride ?? Icon.strokeFor(Spinner.px),
            tone: IconTone.inherit,
          ),
        ),
      ),
    );
  }
}
