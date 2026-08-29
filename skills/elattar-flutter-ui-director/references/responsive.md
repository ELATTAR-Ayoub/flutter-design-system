# Responsive and platform

Responsive means the information structure changes. It does not mean the desktop
layout gets smaller. A dense table squeezed into 360 points is not a mobile
design, it is a defect with a horizontal scrollbar.

## Breakpoints

`Breakpoints.sm` 640, `Breakpoints.md` 768, `Breakpoints.lg` 1024,
`Breakpoints.xl` 1280. Use them to choose structure. Use `LayoutWidths`,
`Containers`, `space(...)`, and component contracts for the resulting values.

Read the width with `LayoutBuilder` for a region and `MediaQuery` for the page.
Never branch on a platform check to guess a size.

## What changes at each width

| Concern | Narrow | Wide |
| --- | --- | --- |
| Navigation | Bottom bar, `Drawer`, or `Sheet` | `Sidebar` or a persistent rail |
| Filters | `Sheet` behind one control, with the active count visible | Inline row above the content |
| Table | Stacked `Card` or `Item` rows carrying the two or three fields that matter | Full `Table` |
| Detail | Full screen route or `Sheet` | Side panel beside the list, or `Dialog` |
| Primary action | Pinned in the header, or one prominent control | In the header beside the title |
| Multi column form | One column | Grouped columns via `FieldGroup` |
| Long text | `Containers.prose` width and comfortable measure | Same measure, not the full window |

Decide by content width, not by device name. A phone in landscape and a small
window on a laptop are the same problem.

## Insets and safe areas

- Use `SafeArea` at page boundaries. Read its source and tests before combining
  it with bars, bottom navigation, sheets, or nested scroll views.
- Never spend the same inset twice. Double padding at the bottom of a scroll
  view under a bottom bar is the usual symptom.
- The keyboard is an inset. A focused field must stay visible when it opens, and
  the submit control must remain reachable.
- Bottom overlays clear the home indicator and the bottom bar.

## Input

- Pointer and touch coexist on the same build. Hover is an enhancement and never
  the only way to reach an action. An action hidden until hover is unreachable
  on touch, so keep it visible, or in a menu, or both.
- Touch targets at least 44 by 44 logical pixels. See
  [accessibility.md](accessibility.md).
- Scroll views nest deliberately. A horizontal list inside a vertical page needs
  its own `ScrollArea` and must not swallow the vertical drag.

## Content that breaks layouts

Test each of these, because each one breaks a fixed layout:

- Long single word strings, such as an email address or an id.
- Localized text roughly a third longer than English.
- Text scale at 200 percent.
- Zero items, one item, and several hundred items.
- The narrowest supported width, and a very wide window.
- Landscape, and a resized desktop window.

## Motion

Use `MotionDurations`, `MotionCurves`, and the motion widgets. Never a raw
`Duration` or a stock Flutter curve outside the foundation directory. Respect
`MediaQuery.disableAnimations`: motion becomes instant, and no information is
carried by the animation alone.

## Checklist

- [ ] Structure changes at breakpoints, not just scale.
- [ ] Navigation, filters, tables, and detail views each have a narrow form.
- [ ] `SafeArea` used once per boundary, no doubled insets.
- [ ] The keyboard does not cover the focused field or the submit control.
- [ ] No action is hover only.
- [ ] Long text, localized text, and 200 percent text scale all render.
- [ ] Zero, one, and many items all render.
- [ ] Motion comes from the foundation and respects reduced motion.
