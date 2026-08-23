/// Public documentation metadata for the `button` component.
///
/// `button` HAS a real `registry/components/button.json` manifest —
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `source-foundation`, `press-motion`, `icon`, `spinner`,
/// `foil-value`, `machine-surface`, `sheen-action`. `page.dart` renders the
/// real `elattar add button` command from it rather than a "not available
/// yet" disclosure.
///
/// [ComponentDocEntry.description] is the one-sentence form for nav and
/// search. [buttonExpandedDescription] is the second, longer description the
/// page itself uses as its hero copy — "when to reach for a button versus a
/// link" — kept as a second top-level constant because [ComponentDocEntry]
/// (supervisor-owned, in `../catalog.dart`) carries only one description
/// field. The same shape `popover`'s `popoverExpandedDescription` and
/// `tooltip`'s `tooltipExpandedDescription` already use.
///
/// This page is the Phase F/J **reference shape** other component pages will
/// be reshaped to match — see `page.dart`'s own library doc for the section
/// order this establishes.
library;

import '../catalog.dart' show ComponentDocEntry;

/// The page's hero description: what a button is *for*, argued against its
/// one real neighbour rather than restated as a definition.
///
/// Every fact cited here is read straight off `lib/src/components/button.dart`:
/// seven `DsButtonVariant` values (including `premium`, which is not in
/// shadcn's own set), nine `DsButtonSize` rungs, and — the fact that actually
/// answers "button or link" — `_DsButtonState.build`'s final `Semantics`
/// node always sets `button: true`, on every variant, `link` included. A
/// `link`-variant `DsButton` is styled like an anchor (underline on hover,
/// `theme.actionInk`) but is built on exactly the same `Focus`/keyboard/
/// `GestureDetector` plumbing as every other variant: it activates on Enter,
/// Space, or a tap, and it carries no href, no route, and no navigation
/// semantics at all.
const String buttonExpandedDescription =
    'DsButton triggers an action — it calls onPressed, and nothing about its '
    'seven variants (primary, premium, secondary, outline, ghost, '
    'destructive, link) changes that contract. Reach for it whenever tapping '
    'should DO something in place: submit a form, save changes, delete a '
    'record, or open a menu, dialog, or popover. The link variant is styled '
    'to read as an inline anchor — no fill, no border, actionInk text that '
    'underlines on hover — but it is still a DsButton underneath: the same '
    'Semantics node reports button: true regardless of variant, the same '
    'Focus widget answers Enter and Space, and there is no href or route '
    'anywhere in its constructor. Reach for whatever this system\'s real '
    'navigation primitive is instead — a route push, DsNavigationMenu, a '
    'sidebar entry — the moment the control should change the visible page, '
    'extend browser history, or be deep-linkable; styling a DsButton as '
    '"link" never buys any of that, no matter how convincing the underline '
    'looks.';

const ComponentDocEntry buttonDoc = ComponentDocEntry(
  name: 'button',
  title: 'Button',
  description:
      'A pill-shaped control with seven variants, nine sizes, loading and '
      'disabled states, and a springing focus ring — for triggering an '
      'action, never for navigating to one.',
  // registry/components/button.json's own registryDependencies, verbatim.
  dependencies: <String>[
    'source-foundation',
    'press-motion',
    'icon',
    'spinner',
    'foil-value',
    'machine-surface',
    'sheen-action',
  ],
  exports: <String>[
    'DsButton',
    'DsButtonVariant',
    'DsButtonSize',
    'DsButtonEmphasis',
    'DsButtonSurface',
  ],
  sourcePath: 'lib/src/components/button.dart',
);
