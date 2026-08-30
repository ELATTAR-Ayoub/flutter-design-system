# States

Every surface that reads data or runs work declares its states before a widget
is written. A surface here is a page, a section inside a page, or a component.
A page is not one state machine: each region owns its own.

## The state model

Use one sealed model so a state cannot be forgotten. Copy
[ui-state.md](../templates/ui-state.md) into product code, once per app.

`UiState<T>`

| Variant | Meaning |
| --- | --- |
| `idle` | Nothing requested yet. Only legal before a load starts. |
| `loading` | First load. No previous data exists. |
| `refreshing` | Reload with data already on screen. Data stays visible. |
| `ready` | Data present and non empty. |
| `empty` | The request succeeded and the collection is legitimately empty. |
| `noResults` | The request succeeded but a filter, search, or date range removed everything. |
| `failed` | The request failed. Carries an `AppError`, never a raw exception. |

`SubmitState` for writes: `idle`, `submitting`, `succeeded`, `failed`.

Pagination is not a variant. It is `ready` plus a `loadingMore` flag on the
page cursor, because the list must stay on screen while the next page arrives.

Teams already on Bloc or Riverpod keep their container and map into these
variants. `AsyncValue.loading` splits into `loading` and `refreshing` by whether
previous data exists, and `AsyncValue.data` splits into `ready`, `empty`, and
`noResults` by the collection and the active filter. Do not skip the split: the
split is the point.

## State to component

Only these components render these states. Do not hand roll an equivalent.

| State | Render | Rules |
| --- | --- | --- |
| `loading` | `Skeleton` in the shape of the real content | Preserve the final layout: same count, same heights, same paddings. A centred `Spinner` on a page that will render a table is a layout jump. |
| `refreshing` | Keep the `ready` tree. Add `Spinner` in the region header or `Progress` at the top. | Never replace data with skeletons on a refresh. Never shift layout. |
| `loadingMore` | `Skeleton` rows appended at the tail, or a `Spinner` in the footer | The existing rows do not move. |
| `ready` | The real content | Nothing else. |
| `empty` | `Empty` with `EmptyMedia`, `EmptyTitle`, `EmptyDescription`, and `EmptyContent` holding one `Button` | The description says why it is empty. The button is the next step. |
| `noResults` | The same `Empty` parts with different copy | The action clears the filter or widens the range. Never offer "create" as the only way out of a filtered view. |
| `failed` | `Alert` inline for one region. `Toast` via `ToastController.error` for a transient action. `AlertDialog` only when the user must decide before continuing. | Copy comes from [errors.md](errors.md). Never print the exception. |
| `submitting` | `Button(loading: true)` and the form disabled | The control that started the work owns the busy state. Block a second submit. |
| `succeeded` | `ToastController.success` with a `ToastAction` for undo where undo exists, or an inline confirmation that persists | Confirm consequential work. Do not toast something the user can already see. |
| `forbidden` | `Empty`, not `Alert` | The user is not broken and there is nothing to retry. Say what access is missing and who grants it. |
| `notFound` | `Empty` with a way back | Offer the list the item belongs to. |
| `offline` | `Alert(variant: AlertVariant.warning)` above the region, data kept and marked stale | Do not blank the screen because the network dropped. |
| `validating` | Field level state, no page state | See `Form`, `Field`, `FieldError`, `ValidationRule`, `Validators`, `ValidateMode`. |
| `disabled` | The component's own disabled state | Never a wrapper with reduced opacity. Give the reason in a `Tooltip` when it is not obvious. |

## Components that carry their own state

Some primitives already model the states, and hand rolling around them is how a
surface ends up with two ideas of "loading". Check the constructor before
wrapping: `Stat` takes `state: StatState.ready | loading | error | empty`, and
`Button` takes `loading`. Use the parameter rather than swapping the widget out.

## Optimistic updates

Allowed when the write is small, reversible, and the failure is rare: toggles,
reorder, mark as read. Apply the change immediately, keep the previous value,
and on failure restore it and show a `Toast` of type `error` with a retry
action. Never apply optimism to money, deletion, or anything the user cannot
observe being wrong.

## Destructive and irreversible work

A destructive action confirms first with `AlertDialog`, and the confirmation
names the object and the consequence: "Delete 3 invoices? They cannot be
restored." `AlertDialogAction` carries the verb, not the word "OK".
`AlertDialogCancel` is the default focus.

Work that is hard to reverse but not destructive skips the dialog and offers
undo in the success toast instead. That is faster and it is a real safety net.

## Unsaved changes

A form with a dirty field intercepts navigation and route pop, and asks with
`AlertDialog`: keep editing, discard, or save. A form that silently loses typing
is a defect, not a nicety.

## Timing

| Elapsed | Requirement |
| --- | --- |
| Immediately | The pressed control shows its own press state. |
| ~400 ms | A busy state appears: `Button(loading: true)`, `Skeleton`, or `Progress`. |
| ~2 s | Add words. Say what is happening: "Uploading 3 files". |
| ~10 s | Offer an exit: cancel, run in background, or an explanation of the wait. |

Use `MotionDurations` for anything animated. These thresholds are policy for
when a state appears, not values to hardcode as animation timings.

## Checklist

- [ ] Each region names its own states, not just the page.
- [ ] `empty` and `noResults` are distinguished and worded differently.
- [ ] First load preserves layout with `Skeleton`.
- [ ] Refresh never blanks or shifts existing data.
- [ ] Every failure path carries an `AppError`, never an exception.
- [ ] Every write has `submitting` and cannot be double submitted.
- [ ] Destructive work confirms, hard to reverse work offers undo.
- [ ] Every terminal state offers a next step.
