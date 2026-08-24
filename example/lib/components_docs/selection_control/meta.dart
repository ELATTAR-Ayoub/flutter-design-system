/// Public documentation metadata for the `selection_control` component.
///
/// [ElSelectionControl] is the shared socket, focus ring, hit-area expander
/// and jelly squash that [ElHitArea] and [ElJellyReplay] (also documented
/// here) compose, and that ElCheckbox, ElRadioGroup, and ElSwitch each build
/// their own skin on top of. It carries no shadcn/Base UI counterpart page of
/// any kind — it is an invented internal primitive — so it has none of the
/// "Checked state"/"Group"/"Table" sections a real checkbox page would; its
/// own sections are named for the reader problems its source actually
/// solves: the hit area, the focus ring, inert vs disabled, and the jelly
/// replay.
///
/// Install with `elattar add selection-control`; the CLI resolves the declared
/// dependency closure.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry selectionControlDoc = ComponentDocEntry(
  name: 'selection_control',
  title: 'Selection Control',
  description:
      'The shared socket, focus ring, hit-area expander, and jelly squash '
      'that ElCheckbox, ElRadioGroup, and ElSwitch each wear.',
  // Registry dependencies are resolved by `elattar add selection-control`.
  dependencies: <String>[
    'button',
    'keyframes',
    'machine-surface',
    'source-foundation',
  ],
  exports: <String>['ElSelectionControl', 'ElHitArea', 'ElJellyReplay'],
  sourcePath: 'lib/src/components/selection_control.dart',
);
