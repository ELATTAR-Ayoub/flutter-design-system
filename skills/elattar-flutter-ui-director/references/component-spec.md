# Component definition of done

Applies to anything added to the system component tree, and to any product
component reused on more than one surface. A component is not done when it
renders. It is done when all of the following exist.

Add a system primitive only when it has a reusable contract. One off
composition stays in product code. See [system-map.md](system-map.md) for which
directory that is in your mode.

## The eight requirements

| # | Requirement | Evidence |
| --- | --- | --- |
| 1 | **Usage.** What it is for, and what it is not for. | Doc block at the top of the file. |
| 2 | **API.** Named parameters, sensible defaults, no required parameter that has an obvious default. | The constructor. |
| 3 | **Variants.** Every variant carries meaning, and the enum is closed. | Enum plus one specimen per value. |
| 4 | **States.** Default, hover, focus visible, pressed, disabled, loading, selected, error, read only, as they apply. | One test per applicable state. |
| 5 | **Keyboard.** Reachable by Tab, operable without a pointer, documented keys. | Keyboard map in the doc block, and a test for the primary key. |
| 6 | **Semantics.** A label, a role, and the state exposed to assistive technology. | `Semantics` in the tree, asserted in a test. |
| 7 | **Responsive.** Behavior at narrow and wide, and under long or scaled text. | Specimen at two widths, one test at large text scale. |
| 8 | **Theming.** Correct in light and dark, all color from `ThemeScope`. | Rendered in both themes, and `test/token_guard_test.dart` passes in repository mode. |

Plus a specimen or documentation route where the mode has one, and focused
widget tests that fail when the contract breaks.

## Interaction states

Do not ship a control that is missing these. Each must be visually distinct and
must not rely on color alone.

- **Default.**
- **Hover** on pointer devices. Use `HoverBuilder` or the component's own hover
  handling, never a manual `MouseRegion` that reimplements it.
- **Focus visible.** A keyboard user must see where they are. Never remove a
  focus ring without providing a stronger one.
- **Pressed.** `Press` and `ActionFeedback` exist for this.
- **Disabled.** Not clickable, not focusable when it is permanently unavailable,
  focusable and explained when it is temporarily unavailable.
- **Loading.** For controls that start work, such as `Button(loading: true)`.
- **Selected or checked.** Exposed to assistive technology, not only painted.
- **Error.** For inputs, paired with a message and not color alone.
- **Read only.** Distinct from disabled: readable, focusable, copyable.

## Documentation block

Copy [component-doc.md](../templates/component-doc.md). It records usage,
variants, states, keyboard, semantics, responsive, and theming in one block
above the class, so a consumer reading the source sees the contract without
leaving the file.

## Anti patterns

| Anti pattern | Correction |
| --- | --- |
| A `bool` parameter per variant | One closed enum |
| A variant that only changes color | Give it meaning, or delete it |
| A component that fetches its own data | Take state as a parameter; the surface owns the request |
| A component that shows its own toast | Return the event; the surface decides the channel |
| Disabled by wrapping in reduced opacity | Use the component's disabled state |
| Hover implemented locally | `HoverBuilder` or the component's own handling |
| A specimen that shows only the default state | One specimen per variant and state |

## Checklist

- [ ] All eight requirements have evidence.
- [ ] Every applicable interaction state renders and is tested.
- [ ] The doc block is present and matches the API.
- [ ] The component takes state and emits events; it neither fetches nor toasts.
- [ ] Specimen covers variants and states, in both themes.
