/// Public documentation metadata for the `questionnaire` component.
///
/// `questionnaire` HAS a real `registry/components/questionnaire.json`
/// manifest: [dependencies] below is that manifest's own
/// `registryDependencies` list, copied verbatim: `button`, `input`, `kbd`,
/// `keyframes`, `source-foundation`.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry questionnaireDoc = ComponentDocEntry(
  name: 'questionnaire',
  title: 'Questionnaire',
  description:
      'A structured question, answered inline: one item on screen at a '
      'time, moved by Progress, Previous, Skip, Next and Submit — it is '
      'a wizard, not a stack of fields.',
  // registry/components/questionnaire.json's own registryDependencies,
  // verbatim.
  dependencies: <String>['button', 'input', 'kbd', 'keyframes', 'source-foundation'],
  exports: <String>[
    'ElQuestionnaireShortcuts',
    'ElQuestionnaireController',
    'ElQuestionnaire',
    'ElQuestionnaireProgress',
    'ElQuestionnaireItem',
    'ElQuestionnaireTitle',
    'ElQuestionnaireDescription',
    'ElQuestionnaireChoices',
    'ElQuestionnaireChoice',
    'ElQuestionnaireInput',
    'ElQuestionnaireError',
    'ElQuestionnaireActions',
    'ElQuestionnairePrevious',
    'ElQuestionnaireSkip',
    'ElQuestionnaireNext',
    'ElQuestionnaireSubmit',
  ],
  sourcePath: 'lib/src/components/questionnaire.dart',
);
