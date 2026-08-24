/// Public documentation metadata for the `toggle-group` component.
///
/// **Split from toggle.** `ElToggleGroup` and `ElToggleGroupItem` used to be
/// documented on `components_docs/toggle/page.dart` alongside `ElToggle`.
/// They are their own barrel export (`lib/elattar_design_system.dart` L107
/// exports `src/components/toggle_group.dart`, separately from L106's
/// `src/components/toggle.dart`) with their own shadcn counterpart
/// (https://ui.shadcn.com/docs/components/base/toggle-group), so they now own
/// their own entry and their own page.
///
/// [ComponentDocEntry.exports] names only what `toggle_group.dart` itself
/// declares: `ElToggleGroup` and `ElToggleGroupItem`. `ElToggleVariant` and
/// `ElToggleSize` are `toggle.dart`'s own enums, which the group merely
/// forwards to every item, so they stay claimed by `toggleDoc` and are not
/// listed twice.
///
/// [ComponentDocEntry.sourcePath] names `toggle_group.dart`. The sibling file
/// every item is built from is named by [toggleGroupItemSourcePath] below and
/// rendered in the page's own Dependencies and Source sections.
///

/// dependencies to resolve automatically. /// Registry dependencies are resolved by `elattar add toggle-group`. /// Not yet added to `catalog.dart`'s `componentDocs` list: that aggregation is
/// supervisor-owned, and the page is deliberately not wired into the catalog /// This entry still feeds the page directly rather than `catalog.dart`, while the shipped CLI path is `elattar add toggle-group`.
/// dependencies to resolve automatically.
///
/// Not yet added to `catalog.dart`'s `componentDocs` list: that aggregation is
/// supervisor-owned, and the page is deliberately not wired into the catalog
/// or the router by this split.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry toggleGroupDoc = ComponentDocEntry(
  name: 'toggle-group',
  title: 'Toggle group',
  description:
      'A mutually exclusive segmented control: one selection at most, over a '
      'single travelling pill.',
  dependencies: <String>[
    'machine-surface',
    'sliding-pill',
    'source-foundation',
    'toggle',
  ],
  exports: <String>['ElToggleGroup', 'ElToggleGroupItem'],
  sourcePath: 'lib/src/components/toggle_group.dart',
);

/// The sibling source file every `ElToggleGroupItem` is rendered through:
/// `toggle_group.dart` builds one `ElToggle` per item. The single
/// [ComponentDocEntry.sourcePath] field has no room for it.
const String toggleItemSourcePath = 'lib/src/components/toggle.dart';

/// The travelling-pill engine `ElToggleGroup` renders through, shared with
/// `ElTabs`, `ElSidebar` and `IconSwap`. `ElToggle` does not import it.
const String slidingPillSourcePath = 'lib/src/motion/sliding_pill.dart';
