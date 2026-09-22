/// Public documentation metadata for the `keyframes` motion primitive.
///
/// `keyframes` is registry `type: "motion"` — `registry/components/keyframes.json`,
/// not `registry/components/` — and [dependencies] is that manifest's own
/// `registryDependencies` list, copied verbatim: `source-foundation`. The
/// file `lib/src/components/ui/keyframes.dart` is the reference's twelve
/// `@keyframes`, transcribed whole, plus the scaffolding ([StepCurve],
/// [KeyframeFill], [KeyframeStop], [Keyframes], [KeyframePlayer]) that turns
/// a table into an [Animatable] and drives it. `Press` and `ActiveIndicator`
/// are the other two of the fourteen, each documented on its own page.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry keyframesDoc = ComponentDocEntry(
  name: 'keyframes',
  title: 'Keyframes',
  description:
      'The reference\'s twelve `@keyframes`, transcribed whole: each '
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
    'EnterMotion',
    'ExitMotion',
    'OpenMotion',
    'CloseMotion',
    'ExpandMotion',
    'ChangeMotion',
    'SpinMotion',
    'ShimmerMotion',
    'ProgressMotion',
    'PulseMotion',
    'CaretMotion',
    'SwapRollMotion',
  ],
  sourcePath: 'lib/src/components/ui/keyframes.dart',
);
