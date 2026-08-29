# Pages and sections

A page is a composition of regions. Each region loads, fails, and recovers on
its own. Treating a page as one state machine produces the two worst outcomes in
this system: a full page spinner that hides a working header, and a full page
error because one widget's request failed.

## Anatomy

| Part | Contains | Notes |
| --- | --- | --- |
| Frame | App shell, navigation, `SafeArea` | Renders before data. Never inside a loading branch. |
| Header | Title, context, one primary action | Renders from route parameters, not from the request. |
| Toolbar | Filters, search, view switches | Disabled while the first load runs, not hidden. |
| Content regions | The real work | Each owns its states. |
| Detail or overlay | `Sheet` on narrow, side panel or `Dialog` on wide | Focus is trapped and restored. |

The frame, header, and toolbar are structural. They render immediately, in every
state. Only content regions swap between skeleton, data, empty, and error.

## Region rules

- One request, one region, one set of states. If a region needs two requests,
  either it has two regions or it composes them into one state before rendering.
- A region failing shows `Alert` inside its own bounds. The rest of the page
  keeps working.
- Page level failure is only for a page that cannot render at all: the route
  parameter is invalid, the record does not exist, or the user lacks access.
  Then use `Empty`, keep navigation reachable, and offer a way back.
- A region that is empty is still a region. It keeps its heading and its
  frame, so the page does not visibly reflow when data arrives.

## Section blueprint

Every content region answers, in this order:

1. What is this, in a heading.
2. What is happening right now, in its state.
3. What the user can do, in one control.

Compose it from `Card`, `CardHeader`, `CardTitle`, `CardDescription`,
`CardContent`, `CardFooter`, or from `Item` for a list row, or a bare column
with a `StyledText` heading and a `Separator`. See
[async-section.md](../templates/async-section.md) for the full shape.

## Flows

A multi step flow adds three requirements to every page in it:

- Where the user is, and how many steps remain.
- A way back that does not lose input.
- A save point, or an explicit statement that progress is not saved.

The final step confirms what will happen before it happens, in the user's words,
including anything irreversible or billable.

## Lists and tables

- The empty case and the filtered empty case are different. See
  [states.md](states.md).
- A row is either fully interactive or not at all. A row that is clickable in
  one column and dead in the rest is a bug people report as "the app froze".
- Pagination keeps the rows on screen while the next page loads. `Pagination`
  handles the control; the state handling is yours.
- A table on narrow widths becomes stacked `Card` or `Item` rows, not a
  horizontal scroll of a desktop table, unless the columns are genuinely a
  matrix the user reads across.

## Forms

- Group with `FieldGroup` and `FieldSet`, label with `FieldLabel`, explain with
  `FieldDescription`, fail with `FieldError`.
- Validate on submit by default, and on blur for fields with a format the user
  can get wrong silently. Do not validate on every keystroke before first blur.
- The submit control owns the `submitting` state and blocks a second press.
- Server side validation maps back onto fields. A `validation` error that lands
  in a toast is a defect: the user cannot see which field to fix.
- A dirty form guards navigation. See [states.md](states.md).

## Checklist

- [ ] Frame, header, and toolbar render in every state.
- [ ] Each region owns its own states.
- [ ] A region failure does not blank the page.
- [ ] Empty regions keep their heading and frame.
- [ ] Lists distinguish empty from no results.
- [ ] Narrow widths restructure rather than shrink.
- [ ] Forms label, group, validate, and guard unsaved changes.
- [ ] Flows show position, allow going back, and confirm before the irreversible step.
