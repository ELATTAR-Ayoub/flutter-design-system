# Errors

The user never reads the backend. Status codes, stack traces, exception class
names, SQL, and provider strings are diagnostics. They belong in logs and behind
a details disclosure, never in a title or a body.

Every failure that reaches the UI is an `AppError`: a category, human copy, one
next step, and hidden diagnostics. Copy
[app-error.md](../templates/app-error.md) into product code and map every
exception at the boundary, not in the widget.

## Taxonomy

Eleven categories, closed set. If a failure does not fit, it is `unknown`.

| Category | Typical cause | Channel | Retryable |
| --- | --- | --- | --- |
| `offline` | No connectivity | `Alert` warning above the region, data kept | Yes, automatically on reconnect |
| `timeout` | Request exceeded its budget | `Alert` in region, or `Toast` for an action | Yes |
| `unauthenticated` | Session expired, 401 | Route to sign in, preserve where the user was | No, sign in instead |
| `forbidden` | 403, missing role | `Empty`, not an error | No |
| `notFound` | 404, deleted item | `Empty` with a way back | No |
| `conflict` | 409, someone else edited it | `AlertDialog`, the user must choose | No, resolve instead |
| `validation` | 422, rejected input | Field level `FieldError`, never a toast | No, fix the input |
| `rateLimited` | 429 | `Alert` with the wait, action disabled until then | Yes, after the wait |
| `server` | 5xx | `Alert` in region with retry | Yes |
| `cancelled` | The user cancelled | No UI at all | Not applicable |
| `unknown` | Anything unmapped | `Alert` in region with retry and a details disclosure | Yes |

`cancelled` is in the list so that cancellation stops being reported as a
failure. A cancelled request shows nothing.

## Copy

Three parts, in this order, and never more.

1. **Title.** What happened, in the user's world. Five to eight words. No codes,
   no jargon, no blame. Not "Error 500", not "Request failed".
2. **Body.** One sentence on what it means for them, and whether their data is
   safe. Skip it when the title already says everything.
3. **Next step.** Exactly one action, phrased as a verb. If the only honest
   action is waiting, say how long.

Filled table. Adapt the nouns, keep the shape.

| Category | Title | Body | Next step |
| --- | --- | --- | --- |
| `offline` | You are offline | Showing the last data we loaded. New changes are not saved yet. | Reconnect, then retry |
| `timeout` | This is taking too long | The server did not answer in time. Nothing was changed. | Try again |
| `unauthenticated` | Your session expired | You were signed out for security. Your work is kept. | Sign in |
| `forbidden` | You do not have access to this | Your account is missing the permission this page needs. | Ask an admin for access |
| `notFound` | This item no longer exists | It may have been deleted or moved. | Back to <the list> |
| `conflict` | Someone else changed this | Your copy and the saved copy are different. | Review both, then choose one |
| `validation` | Check the highlighted fields | Nothing was saved. | Fix the fields, then save |
| `rateLimited` | Too many requests | You reached the limit for now. | Wait <n> seconds, then retry |
| `server` | Something went wrong on our side | Your data is safe. Nothing was changed. | Try again, or contact support |
| `unknown` | Something went wrong | We could not complete that. Nothing was changed. | Try again |

Rules the copy must keep:

- Say whether their data is safe. Unsaved work is the first thing a user fears.
- Never blame the user. "Check the highlighted fields", not "Invalid input".
- Never say "Please". It adds a word and no information.
- Never write "unexpected", "oops", "uh oh", or an exclamation mark.
- One action. Two actions is a decision, and a decision belongs in a dialog.

The next step is rendered whether or not the failure is retryable. Attaching it
only to a retry button loses it on every failure that cannot be retried, which
is where the user most needs to be told what to do instead.

## Diagnostics

`AppError` keeps `diagnostics`: the original message, the status, and a
correlation id where one exists. Surface it only through a collapsed
`Collapsible` or `Accordion` labelled "Technical details", inside the `Alert`
or dialog, and always after the next step. Log it in full. Support needs the
correlation id, so show it when you have one.

## Where errors go

| Scope | Channel |
| --- | --- |
| One field | `FieldError` under the field, and the field keeps focus |
| One section | `Alert` inside the section, the rest of the page keeps working |
| One action | `ToastController.error` with a `ToastAction` retry |
| The whole page cannot render | Page level `Alert` or `Empty`, with navigation still reachable |
| A decision is required | `AlertDialog` with the two real options named |

A failure in one section never blanks the page. A toast never carries a message
the user must act on later, because it disappears.

## Checklist

- [ ] Exceptions are mapped to `AppError` at the data boundary.
- [ ] No widget builds a string from an exception.
- [ ] Every category has title, body, and one next step.
- [ ] Validation lands on fields, not in a toast.
- [ ] Diagnostics are collapsed and after the next step.
- [ ] `cancelled` renders nothing.
- [ ] Retry actually retries the same request.
