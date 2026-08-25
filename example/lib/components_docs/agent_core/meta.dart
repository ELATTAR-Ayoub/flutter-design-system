/// Public documentation metadata for the `agent-core` component.
///
/// `agent-core` HAS a real `registry/components/agent-core.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `icon`, `source-foundation`.
///
/// Unlike every other item in this family, `agent_core.dart` declares no
/// widget: it is *"the vocabulary every agent family renders"* — attachment
/// types, the turn union, the twenty-state machine, the transport contract,
/// and the pure functions that resolve, format and serialise them. The page
/// stages that vocabulary directly (state chips, a resolver walked live, the
/// formatting helpers against real inputs) rather than a widget preview.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry agentCoreDoc = ComponentDocEntry(
  name: 'agent-core',
  title: 'Agent Core',
  description:
      'The transport-agnostic vocabulary every agent family renders: '
      'attachments, the turn union, the twenty-state machine, the resolver '
      'that picks one, and the pure functions around them.',
  // registry/components/agent-core.json's own registryDependencies, verbatim.
  dependencies: <String>['icon', 'source-foundation'],
  exports: <String>[
    'ElAgentAttachmentKind',
    'ElAgentDeliverySent',
    'ElAgentDelivery',
    'ElAgentAttachment',
    'ElSerialisedMessage',
    'ElAgentTurnStatus',
    'ElAgentTurn',
    'ElUserTurn',
    'ElTextTurn',
    'ElToolTurn',
    'ElActionTurn',
    'ElApprovalOutcome',
    'ElErrorTurn',
    'ElPendingApproval',
    'ElAgentState',
    'ElToolStateMap',
    'ElAgentAttachmentSupport',
    'ElAgentCapabilities',
    'ElAgentSendOptions',
    'ElAgentTransport',
    'ElAgentSignals',
    'ElConversationSummary',
    'ElConversationStore',
    'ElSwitchPhase',
    'ElBlurSwitchController',
  ],
  sourcePath: 'lib/src/components/agent_core.dart',
);
