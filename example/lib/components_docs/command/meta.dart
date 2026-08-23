/// Public documentation metadata for the paired command and combobox
/// components.
///
/// One page, one [ComponentDocEntry] ([commandDoc]): the same
/// one-entry-two-components shape `sheet/page.dart` already uses for Sheet
/// and Drawer. Both are "filter as you type" surfaces built from
/// `lib/src/components/command.dart` and `lib/src/components/combobox.dart`,
/// and the distinction between them: what they filter *for*, and how: is
/// the whole reason this page exists rather than two thin ones.
///
/// [ComponentDocEntry] carries one `sourcePath`; because both components have
/// real source files, this one names the primary of the two
/// (`command.dart`, since the folder and route are named after it) and
/// [comboboxSourcePath] names the second, the same pattern
/// `sheet/meta.dart`'s own `drawerSourcePath` uses.
///
/// Neither `command` nor `combobox` has a `registry/components/*.json`
/// manifest, so [dependencies] below names the real modules the two source
/// files import from `lib/src/components/` (for the Dependencies panel), not
/// a validated `registryDependencies` list: inventing a registry name here
/// is exactly the failure mode the Phase J supervisor notes warn about, and
/// this file does not need to. `page.dart`'s Installation section says
/// plainly that both are already usable through the published package —
/// they are exported from the barrel: but neither is yet installable
/// through `elattar add`.
library;

import '../catalog.dart';

/// IA §9.2's expanded description: not what either component *is*, but which
/// job each one does, so a reader picks correctly on the first try.
const String commandExpandedDescription =
    'Both surfaces narrow a list as you type, and that is the only thing '
    'they have in common: reach for the wrong one and you get either a '
    'menu with no anchor or a form field that cannot be summoned globally. '
    'Command is a global action launcher: it renders inline with nothing to '
    'anchor to: no trigger, no popover, no positioner: because the '
    'reference itself only ever mounts it inside a page panel or, for the '
    'variant this port has not built, a centred dialog. Picking a row runs '
    'a callback (onSelect) and produces no persistent value of its own; the '
    'caller is expected to close whatever container it opened Command in. '
    'This site\'s own header search is a real, live example: pressing the '
    'search trigger opens Command with nothing to anchor to but the search '
    'panel itself, and every row is an onSelect that calls onNavigate and '
    'dismisses the panel: there is nothing to keep selected afterward. '
    'Combobox is the opposite shape: a form control that anchors to its own '
    'trigger: a real DsPopover, positioned against the input the way '
    'DsSelect positions against its own trigger: and produces a '
    'controlled value (T?) that persists after the popup closes, the way '
    'DsSelect does but with a text field standing in for the closed '
    'display. It composes with DsField and DsFieldScope for label, hint, '
    'invalid and enabled the same way DsInput and DsSelect do. Reach for '
    'Command when the job is "run one of N actions from anywhere"; reach '
    'for Combobox when the job is "pick one value, in this one field, and '
    'keep it selected." Select is Combobox\'s own closer neighbour, not '
    'Command\'s: reach for DsSelect instead of Combobox when the list is '
    'short enough that typing to filter would not save a scroll, and reach '
    'for Combobox once the list is long enough that scrolling it is worse '
    'than typing a few letters: the reference bases both consumers of '
    'Combobox on that same list-length judgment.';

const ComponentDocEntry commandDoc = ComponentDocEntry(
  name: 'command',
  title: 'Command & Combobox',
  description:
      'Two filter-as-you-type surfaces for two different jobs: an inline, '
      'always-open action launcher with a fuzzy-ranked filter, and an '
      'anchored form control with a plain substring filter.',
  // What lib/src/components/command.dart and lib/src/components/combobox.dart
  // actually import from lib/src/components/: real source-level
  // dependencies, not a registry dependency list. See the library note above
  // for why: neither component has a manifest yet.
  dependencies: <String>[
    'source-foundation',
    'icon',
    'input',
    'input_group',
    'field',
    'popover',
    'select',
  ],
  exports: <String>[
    // lib/src/components/command.dart
    'DsCommand',
    'DsCommandItem',
    'DsCommandGroup',
    'dsCommandScore',
    // lib/src/components/combobox.dart
    'DsCombobox',
    'DsComboboxItem',
    'dsCollatorContains',
  ],
  sourcePath: 'lib/src/components/command.dart',
);

/// The family's second source file. [ComponentDocEntry] carries one
/// [ComponentDocEntry.sourcePath], and combobox lives in its own library —
/// the same pattern `sheet/meta.dart`'s own `drawerSourcePath` uses.
const String comboboxSourcePath = 'lib/src/components/combobox.dart';
