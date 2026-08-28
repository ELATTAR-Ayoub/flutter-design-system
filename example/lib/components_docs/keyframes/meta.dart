/// Public documentation metadata for the `keyframes` motion primitive.
///
/// `keyframes` is registry `type: "motion"` — `registry/components/keyframes.json`,
/// not `registry/components/` — and [dependencies] is that manifest's own
/// `registryDependencies` list, copied verbatim: `source-foundation`. The
/// file `lib/src/components/ui/keyframes.dart` is the reference's fourteen
/// `@keyframes`, transcribed whole: nine `anim-*` utilities the reference's
/// own motion page demonstrates, two more (a sweep bar, a travel chip) that
/// page declares for its own duration and easing demos, three that belong to
/// the checkbox and the radio (`check-draw`, `dash-draw`, `dot-pop`), and one
/// transition — `swap-roll` — that is not a keyframe at all but lives here
/// because it is the one motion table `icon_swap.dart` needs.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry keyframesDoc = ComponentDocEntry(
  name: 'keyframes',
  title: 'Keyframes',
  description:
      'The reference\'s fourteen `@keyframes`, transcribed whole: each '
      'table is a TweenSequence with one item per gap between stops, '
      'driven by KeyframePlayer through a linear clock so every easing '
      'lives in the table rather than in the player.',
  // registry/components/keyframes.json's own registryDependencies, verbatim.
  dependencies: <String>['source-foundation'],
  exports: <String>[
    'StepCurve',
    'KeyframeFill',
    'KeyframeStop',
    'Keyframes',
    'KeyframePlayer',
    'EntranceMotion',
    'StateChangeMotion',
    'SpringEntranceMotion',
    'OpenMotion',
    'DiscreteProgressMotion',
    'TextRevealFrame',
    'TextRevealMotion',
    'RevealMotion',
    'LoadingShimmerMotion',
    'LivePulseMotion',
    'SweepMotion',
    'TravelMotion',
    'CheckmarkDrawMotion',
    'DashDrawMotion',
    'DotSelectionMotion',
    'ContentSwapMotion',
  ],
  sourcePath: 'lib/src/components/ui/keyframes.dart',
);
