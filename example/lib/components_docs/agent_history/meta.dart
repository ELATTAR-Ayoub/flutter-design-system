/// Public documentation metadata for the `agent-history` component.
///
/// `registry/components/agent-history.json` exists and is installable
/// today: [dependencies] below is that manifest's own
/// `registryDependencies`, copied verbatim — `agent-core`, `alert`,
/// `alert-dialog`, `button`, `command`, `dialog`, `dropdown-menu`, `empty`,
/// `field`, `icon`, `input`, `item`, `surface`, `menu`, `popover`,
/// `source-foundation`, `spinner`.
///
/// `lib/src/components/ui/agent_history.dart` ports three reference files —
/// `history-card.tsx`, `chat-history.tsx`, `history-search.tsx` — plus one
/// motion helper the three of them share. [exports] lists every public
/// name the file declares; the page documents [HistoryCard],
/// [HistorySearch], and [ChatHistory] (the three real widgets), the
/// two enums that shape a card's destructive and rename affordances, and
/// [RowMotion], [BlurSwitch], and [FlipController] (the shared
/// motion machinery) in full.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry agentHistoryDoc = ComponentDocEntry(
  name: 'agent_history',
  title: 'Agent History',
  description:
      'Every conversation, as cards you can pin, rename, share and '
      'delete — a searchable palette over them, and the drawer that '
      'holds the whole list.',
  dependencies: <String>[
    'agent-core',
    'alert',
    'alert-dialog',
    'button',
    'command',
    'dialog',
    'dropdown-menu',
    'empty',
    'field',
    'icon',
    'input',
    'item',
    'surface',
    'menu',
    'popover',
    'source-foundation',
    'spinner',
  ],
  exports: <String>[
    'HistoryCard',
    'HistorySearch',
    'ChatHistory',
    'HistoryConfirm',
    'HistoryRename',
    'RowMotion',
    'BlurSwitch',
    'FlipController',
  ],
  sourcePath: 'lib/src/components/ui/agent_history.dart',
);
