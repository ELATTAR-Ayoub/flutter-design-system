/// Public documentation metadata for the popover component.
///
/// `popover` already has a real `registry/components/popover.json` manifest
///: like `tooltip`, [dependencies] is that manifest's own
/// `registryDependencies` list, verbatim: `['source-foundation']`. `page.dart`
/// renders the real `elattar add popover` command from it rather than the
/// "not available yet" disclosure most unrouted components carry.
///
/// [ComponentDocEntry.description] is the one-sentence form for nav and
/// search. [popoverExpandedDescription] carries the IA §9.2 "when to use this
/// instead of a neighbour" guidance: against Tooltip, Dropdown Menu, and
/// Hover Card: kept as a second top-level constant, the same shape
/// `tooltip`'s `tooltipExpandedDescription` uses, because [ComponentDocEntry]
/// itself carries only one description field and is supervisor-owned.
library;

import '../catalog.dart';

/// IA §9.2's expanded description: popover against its three closest overlay
/// neighbours, not a restatement of what an anchored overlay is.
const String popoverExpandedDescription =
    'Reach for a popover when a trigger needs to open genuinely interactive '
    'content of its own: form fields, buttons, a scrollable list: anchored '
    'to that trigger, dismissed by an outside click or Escape once focus is '
    'inside it. That is a different job from its three closest neighbours. A '
    'Tooltip is a single short line of non-interactive text that opens on a '
    '200ms hover or a bare tap and owns no open state of its own; reach for '
    'a popover instead the moment the content needs its own controls. A '
    'Dropdown Menu is a fixed list of commands where picking one closes the '
    'menu, not a surface to keep interacting inside; use it when the content '
    'is a menu of actions rather than a form or a preview. A Hover Card is a '
    'richer, still non-interactive preview that opens and closes on pointer '
    'proximity alone: it reuses this primitive\'s own placement math and '
    'surface paint (dsPopoverPlacement, DsPopoverSurface) but deliberately '
    'cannot use DsPopover itself, because its outside-tap dismiss barrier '
    'would fight a hover-driven open/close cycle. Popover is also the shared '
    'positioning engine other overlays build on: DsSelect and Hover Card '
    'reuse its placement and paint without the whole widget, and DsCombobox, '
    'the calendar date picker, every menu family (Dropdown Menu, Context '
    'Menu, Menubar, the agent attach menu), and Navigation Menu all mount '
    'their popups through DsPopover directly.';

const ComponentDocEntry popoverDoc = ComponentDocEntry(
  name: 'popover',
  title: 'Popover',
  description:
      'An anchored overlay with semantic side, alignment, and collision '
      'handling that other overlays in this system build their own '
      'placement on.',
  // registry/components/popover.json's own registryDependencies, verbatim —
  // a worker that invented a name here is exactly the failure mode the
  // Phase J supervisor notes warn about, and this one does not need to.
  dependencies: <String>['source-foundation'],
  exports: <String>[
    'DsPopover',
    'DsPopoverSide',
    'DsPopoverAlign',
    'DsPopoverOriginModel',
    'DsPopoverBarrier',
    'DsPopoverPlacement',
    'DsPopoverAnchorMetrics',
    'DsPopoverContentBuilder',
    'DsPopoverSurface',
    'dsPopoverPlacement',
  ],
  sourcePath: 'lib/src/components/popover.dart',
);
