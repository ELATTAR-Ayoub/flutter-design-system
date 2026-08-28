/// Public documentation metadata for the `toggle` component.
///
/// **Split from toggle-group.** This entry used to describe both `Toggle`
/// and `ToggleGroup` on one page. They are two separately barrel-exported
/// public components (`lib/elattar_design_system.dart` L106 exports
/// `src/components/toggle.dart`, L107 exports `src/components/toggle_group.dart`),
/// with two separate shadcn counterparts, so each now owns its own
/// `ComponentDocEntry` and its own page. `components_docs/toggle_group/meta.dart`
/// carries the group's.
///
/// [ComponentDocEntry.exports] names only what `toggle.dart` itself declares:
/// `Toggle` and the two enums it owns, `ToggleVariant` and `ToggleSize`.
/// The group re-uses both enums but declares neither, so neither is claimed
/// twice.
///

/// dependencies to resolve automatically. /// Registry dependencies are resolved by `elattar add toggle`.
/// dependencies to resolve automatically.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry toggleDoc = ComponentDocEntry(
  name: 'toggle',
  title: 'Toggle',
  description:
      'A two-state pressed control for state that persists, rather than an '
      'action that fires.',
  dependencies: <String>['button', 'icon', 'surface', 'source-foundation'],
  exports: <String>['Toggle', 'ToggleVariant', 'ToggleSize'],
  sourcePath: 'lib/src/components/toggle.dart',
);
