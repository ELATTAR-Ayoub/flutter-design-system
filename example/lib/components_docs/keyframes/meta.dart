/// Public documentation metadata for the `keyframes` motion primitive.
///
/// `keyframes` is registry `type: "motion"` — `registry/motion/keyframes.json`,
/// not `registry/components/` — and [dependencies] is that manifest's own
/// `registryDependencies` list, copied verbatim: `source-foundation`. The
/// file `lib/src/motion/keyframes.dart` is the reference's fourteen
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
      'driven by ElKeyframePlayer through a linear clock so every easing '
      'lives in the table rather than in the player.',
  // registry/motion/keyframes.json's own registryDependencies, verbatim.
  dependencies: <String>['source-foundation'],
  exports: <String>[
    'ElSteps',
    'ElKeyframeFill',
    'ElKeyframeStop',
    'ElKeyframes',
    'ElKeyframePlayer',
    'ElPopIn',
    'ElJelly',
    'ElSpringUp',
    'ElJellyIn',
    'ElRatchet',
    'ElSignOnFrame',
    'ElSignOn',
    'ElReveal',
    'ElShimmer',
    'ElPulseLive',
    'ElSweep',
    'ElTravel',
    'ElCheckDraw',
    'ElDashDraw',
    'ElDotPop',
    'ElSwapRoll',
  ],
  sourcePath: 'lib/src/motion/keyframes.dart',
);
