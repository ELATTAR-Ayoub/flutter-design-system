# Traps

| Trap | Correction |
| --- | --- |
| Styled local `Container`/`Text` | Use `Card`, `StyledText`, variants, and foundation tokens. |
| Page-only color/radius/duration constant | Use semantic contracts; promote a foundation token only with cross-system evidence. |
| Rebuilding from memory | Search barrel, source, tests, and example first. |
| Assuming the repository layout in a consumer app | Resolve the mode in `system-map.md` Step 0 before naming a path. |
| One-off page inside the system component directory | Keep it in product code: `example/lib/` in the repository, your own `lib/` outside `lib/components/ui/` in a consumer app. |
| Screenshot-only skeleton/toast | Wire real transitions and test them. |
| "Responsive" means shrinking desktop | Reflow hierarchy and interaction density at system breakpoints. |
| Decoration carries state | Use semantic text and controls; keep effects subordinate. |
| Token-guard exception as shortcut | Prove and document an external-integration requirement on the exact line. |
| Green analyzer without render review | Capture light/dark and narrow/wide states, then inspect them. |
| Writing widgets before the contract | The contract takes minutes and is what the gate checks. See `ui-contract.md`. |
| One state machine for a whole page | Each region owns its states. A page level spinner hides a working header. |
| Full page error because one request failed | `Alert` inside the failing region; the rest of the page keeps working. |
| Empty and no results sharing copy | Different states, different wording, different exits. Offering "create" out of a filtered view is a dead end. |
| Refresh replaced by skeletons | Keep the data on screen. Skeletons on refresh read as data loss. |
| A centred `Spinner` where a table will render | `Skeleton` in the shape of the content, so nothing jumps. |
| `e.toString()` in a `Text` | Map to `AppError` at the boundary. See `errors.md`. |
| Validation error in a toast | It lands on the field, or the user cannot see what to fix. |
| A toast the user must act on later | Toasts disappear. Anything actionable is inline. |
| `onPressed: () {}` | A dead press. Every trigger produces feedback and a next step. |
| Double submit | The submit control owns `submitting` and blocks a second press. |
| Optimistic delete or payment | Optimism is for small reversible writes only. |
| Silent async completion | Announce it, or a screen reader user never learns it finished. |
| Icon-only button with no label | `Button(label: ...)`, or wrap in `Semantics`. |
| Focus lost when an overlay closes | Restore it to the control that opened the overlay. |
| Hover-only action | Unreachable on touch. Keep it visible, or in a menu. |
| Fixed height around text | Breaks at 200 percent text scale and in other languages. |
| Status shown by color alone | Pair it with an icon or a word, in both themes. |
| `Theme.of(context)` styling | A parallel visual system. Use `ThemeScope` and the system components. |
| "Oops", "Please wait", "Error: null" | See `copy.md`. Say what happened, and what to do next. |
| Suppressing scanner findings to get a quiet run | Fix them, or justify each one in the handoff. |
| `ScrollArea` as a page scroller | It wraps its child in an `IntrinsicWidth`. A `LayoutBuilder` descendant throws, and a wide table sizes past the viewport so its right-hand controls become unclickable. Use `SingleChildScrollView`, which is what the shipped agent console block uses. |
| A `LayoutBuilder` inside a scroller | Decide the structure once, above the scroller, and pass the result down. |
| A pinned header above a pinned composer or footer | At 200 percent text on a phone the two alone exceed the viewport and the middle gets a negative height. Let the header scroll; pin only what must stay reachable. |
| The next step living on the retry button | A non-retryable failure then has no next step at all, which is exactly where one is needed: a declined card, a forbidden page, a conflict. Render it either way. |
| Passing a raw string into `ErrorTurn.message` | Map to `AppError` first. The turn will render whatever it is given, backend text included. |
| Assuming an overlay restores focus | `Dialog`, `AlertDialog` and `SheetOverlay` trap focus and close on Escape, but they do not hand focus back. Keep a `FocusNode` on the trigger and request it on close. |
| Two controls sharing a row at large text | A `Row` overflows; a `Wrap` reflows. Anything that can grow with text scale belongs in a `Wrap` or behind an `Expanded`. |
| `pumpAndSettle` on a page with a skeleton | `Skeleton` and `Spinner` animate forever and ignore `MediaQuery.disableAnimations`, so the tree never settles. Pump a fixed number of `MotionDurations` beats instead. |
