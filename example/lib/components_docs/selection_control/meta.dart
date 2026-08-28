/// Public documentation metadata for the `selection_control` component.
///
/// [SelectionControl] is the shared socket, focus ring, hit-area expander
/// and jelly squash that [HitArea] and [StateChangeFeedback] (also documented
/// here) compose, and that Checkbox, RadioGroup, and Switch each build
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
      'that Checkbox, RadioGroup, and Switch each wear.',
  // Registry dependencies are resolved by `elattar add selection-control`.
  dependencies: <String>['button', 'keyframes', 'surface', 'source-foundation'],
  exports: <String>['SelectionControl', 'HitArea', 'StateChangeFeedback'],
  sourcePath: 'lib/src/components/selection_control.dart',
);
