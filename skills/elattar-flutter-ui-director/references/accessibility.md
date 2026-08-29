# Accessibility

Checkable rules. Each one is either true of the surface or it is not.

## Labels

- Every icon only control has a label. `Button` takes `label`; elsewhere wrap in
  `Semantics(label: ...)`. "Filter invoices", not "filter".
- Every input has a visible `FieldLabel`. A placeholder is not a label: it
  disappears exactly when the user needs it.
- Decorative graphics are excluded from the tree, not labelled. `AmbientPattern`,
  `BackgroundEffect`, and `Glass` are decoration.
- An image that carries information has a description. A chart has a text
  alternative: the value, the trend, or a table nearby.

## Focus

- Tab order follows reading order. If it does not, the layout is fighting the
  widget order and the widget order is what to fix.
- Focus is always visible. Never remove a focus ring without a stronger one.
- Overlays trap focus: `Dialog`, `AlertDialog`, `Sheet`, `Drawer`, `Popover`,
  `DropdownMenu`, `ContextMenu`, `Command`.
- Closing an overlay returns focus to the control that opened it. Losing focus to
  the page root strands a keyboard user.
- Escape closes any dismissible overlay.
- Opening a dialog moves focus into it, to the first control or the safest one.
  For a destructive confirmation, that is `AlertDialogCancel`.

## Keyboard

Everything a pointer can do, a keyboard can do.

| Pattern | Keys |
| --- | --- |
| Buttons, links | Tab to reach, Enter or Space to activate |
| Checkbox, `Switch`, `Toggle` | Space |
| `Radio`, `ToggleGroup`, `Tabs` | Arrows move within the group, Tab leaves it |
| `Select`, `Combobox`, `DropdownMenu`, `Menu` | Enter or Space or Down to open, arrows to move, Enter to choose, Escape to close |
| Overlays | Escape to close |
| Lists and tables | Tab reaches row actions, or the row itself is one stop |
| `Command` | Type to filter, arrows to move, Enter to run |

A composite control is one tab stop with internal arrow navigation, not a tab
stop per child. Do not add a global shortcut that shadows browser or platform
keys, and document any shortcut with `Kbd`.

## Announcements

A screen reader user gets nothing from a silent swap. Announce, using
`SemanticsService.announce` or a live region, when:

- An asynchronous action the user started completes or fails.
- A list changes size after a filter or search: "12 invoices".
- Content is inserted above the current position.
- A validation summary appears on submit.

Do not announce every keystroke, every hover, or content the user is reading.

## Text and targets

- Support text scale to at least 200 percent without clipping or overlap. Test
  it: it is where fixed heights break.
- Never fix the height of anything containing text. Let it grow, or scroll it.
- Touch targets are at least 44 by 44 logical pixels on touch platforms,
  including the invisible hit area of small icon buttons.
- Line length stays readable. Use `LayoutWidths` and `Containers` rather than
  letting a paragraph run the width of a desktop window.

## Color and motion

- Never communicate with color alone. A status carries an icon, a word, or a
  shape as well. This is a rule for `Badge`, `Alert`, `Progress`, `Toast`, and
  every chart series.
- Meet contrast in both themes. Verify, do not assume: `ThemeScope` gives the
  correct pair, but a custom composition can still fail.
- Respect `MediaQuery.disableAnimations`. Motion becomes instant, and nothing
  depends on an animation to be understood.
- Nothing flashes more than three times a second.

## Checklist

- [ ] Every icon only control has a label.
- [ ] Every input has a visible label.
- [ ] Tab order matches reading order and focus is always visible.
- [ ] Overlays trap focus, close on Escape, and restore focus on close.
- [ ] Composite controls are one tab stop with arrow navigation.
- [ ] Async completion, failure, and result counts are announced.
- [ ] 200 percent text scale renders without clipping.
- [ ] Touch targets are at least 44 by 44 on touch platforms.
- [ ] No status is communicated by color alone.
- [ ] Reduced motion is respected.
