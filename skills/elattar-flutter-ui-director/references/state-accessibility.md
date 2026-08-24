# States, feedback, and accessibility

Define relevant states before implementation:

| State | Expected treatment |
| --- | --- |
| Loading | Preserve known layout with `ElSkeleton`; use spinner/progress for live work; prevent duplicate submit. |
| Empty | Explain why content is absent and provide the useful next action with `ElEmpty`. |
| Error | Give a specific recovery path through an alert, inline feedback, or retry. |
| Success | Confirm consequential completion with an accessible toast/inline state and undo/retry when useful. |
| Disabled/focus/selected | Retain component semantics, visible state, keyboard parity, and a reason where it is not obvious. |

Scope an `ElToastController` and `ElToaster` deliberately; avoid unbounded or stale notification stacks. Every interactive control needs a discoverable label and logical focus order. Test long/localized text, text scale, narrow width, safe areas, keyboard, reduced motion, and non-color status communication as relevant.
