# Feedback

No dead presses. Every interactive control answers within one frame, and every
action the user starts has a visible ending.

## One channel per trigger

Each trigger declares exactly one primary channel in the UI contract. Two
channels for one action is noise: a dialog that also toasts, a toast that also
writes an inline banner.

| Channel | Use when | Component |
| --- | --- | --- |
| `inline` | The result is visible in place: a value changes, a row appears, a section fills | The component's own state |
| `optimistic` | Small reversible write: toggle, reorder, mark read | Inline, with rollback per [states.md](states.md) |
| `field` | Input is rejected | `FieldError` through `Form` and `Field` |
| `toast` | The result is real but off screen, or the surface is about to change | `ToastController` inside a mounted `Toaster` |
| `dialog` | The user must decide, or must confirm something destructive | `Dialog`, `AlertDialog`, `Sheet` on narrow widths |
| `navigation` | The action moves the user somewhere | The destination is itself the feedback, and it must not arrive empty |

A control that opens an overlay is answered by the overlay appearing. A control
that saves is answered by the saved value or a toast, never by nothing.

## Timing

| Elapsed | What the user sees |
| --- | --- |
| Immediate | Press state on the control. `Press`, `ActionFeedback`, and the components' built in states already do this. Do not suppress it. |
| ~400 ms | `Button(loading: true)`, `Skeleton`, or `Progress`. The control is disabled against a second press. |
| ~2 s | Words: what is running, and how much is left when it is countable. |
| ~10 s | An exit: cancel, continue in the background, or an honest estimate. |

Use `ToastController.promise` for a request whose outcome should replace a
pending toast, rather than showing a spinner toast that never settles.

## Announcing state changes

A sighted user sees a section swap from skeleton to content. A screen reader
user hears nothing unless it is announced. Any asynchronous change that the user
started must be announced: completion, failure, and the arrival of results.
See [accessibility.md](accessibility.md) for the mechanics.

## Toast discipline

- Mount exactly one `Toaster` per app, near the root, above routes.
- One `ToastController`, provided down the tree. Do not create one per page.
- A toast is a receipt, not a message board. If the user must act on it later,
  it belongs inline.
- Errors that are retryable carry a `ToastAction` retry, and the retry works.
- Success toasts for reversible work carry undo, and the undo window is longer
  than the toast's own default when the work matters.
- Never stack more than a few. Never toast on every keystroke, every save of an
  autosaving field, or every navigation.

## Always show the next step

Every terminal state answers two questions: what is happening or what happened,
and what the user should do now. This applies to empty, error, forbidden, not
found, success that unblocks something, and any wait longer than a moment.

If there is genuinely nothing to do, say so explicitly: "Nothing to do here yet.
We will notify you when the import finishes." Silence reads as breakage.

The next step is one control, labelled with a verb and the object: "Create your
first project", "Clear filters", "Sign in", "Back to invoices". Not "OK", not
"Continue", not "Learn more" on its own.

## Checklist

- [ ] Every trigger in the contract names one channel.
- [ ] No `onPressed` body that changes nothing observable.
- [ ] Busy state past ~400 ms, words past ~2 s, an exit past ~10 s.
- [ ] Double submission is impossible while `submitting`.
- [ ] One `Toaster` and one `ToastController` for the app.
- [ ] Retry and undo actions in toasts actually work.
- [ ] Async completion and failure are announced to assistive technology.
- [ ] Every terminal state carries one next step control.
