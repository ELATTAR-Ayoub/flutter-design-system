/// Public documentation metadata for the `action-feedback` effect.
///
/// `action-feedback` HAS a real `registry/components/action-feedback.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `surface`, `source-foundation` —
/// `surface` because [ActionFeedback] splices its own ramp and its
/// two blended pseudo-layers around an inner [Surface], which is
/// what actually paints the inset shadows, the border and the label.
/// `page.dart` renders the real `elattar add action-feedback` command from it.
///
/// Not a component: `lib/src/components/ui/action_feedback.dart` exports one
/// `StatefulWidget`, [ActionFeedback], with no variant and no size — it is
/// the surface this system's own primary Button paints itself with,
/// documented here as the effect it is: a static five-stop ramp, a static
/// blended texture, and a double-thump "beat" that plays on hover and
/// retimes — without restarting — on press.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry actionFeedbackDoc = ComponentDocEntry(
  name: 'action_feedback',
  title: 'Action Feedback',
  description:
      'The default Button\'s surface: a derived five-stop ramp, a static '
      'blended texture, and a double-thump light that beats on hover and '
      'retimes — without restarting — the instant the surface is pressed.',
  // registry/components/action-feedback.json's own registryDependencies, verbatim.
  dependencies: <String>['surface', 'source-foundation'],
  exports: <String>['ActionFeedback'],
  sourcePath: 'lib/src/components/ui/action_feedback.dart',
);
