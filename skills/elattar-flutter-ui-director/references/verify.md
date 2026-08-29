# Verification ladder

Resolve the mode from [system-map.md](system-map.md) Step 0 first, then run that
mode's ladder. Run focused checks while implementing and the applicable full
ladder before handoff.

## Consumer mode

The design system lives inside the consumer's own package, so one project root
runs everything. There is no `example/` directory and no capture rig.

```powershell
flutter analyze
flutter test
```

Add the release build for the target you actually ship:

```powershell
flutter build web --release
flutter build apk --release
```

If the `elattar` CLI is available, confirm the install is coherent before
blaming your own code:

```powershell
elattar doctor
```

`elattar add --dry-run <item>` shows what an install would write without
touching the tree — use it to check whether a needed component is already
installed rather than hand-writing a primitive.

Inspect intended routes at device size in light/dark and narrow/wide variants
with `flutter run`. Record what you inspected; there is no capture rig here.

## Repository mode

```powershell
flutter analyze
flutter test
Push-Location example
flutter analyze
flutter test
flutter build web --release
Pop-Location
```

For an Android delivery, build the intended entrypoint explicitly:

```powershell
Push-Location example
flutter build apk --release --target lib/<entrypoint>.dart
Pop-Location
```

Read `tool/verify/README.md` for the capture rig. Inspect intended routes at
device size in light/dark and narrow/wide variants.

`test/token_guard_test.dart` enforces the no-literal rule mechanically; run it
directly while iterating on visual code.

## Handoff — both modes

Before handoff confirm: relevant public APIs were inventoried; all visual choices
resolve from the system; relevant feedback/recovery states and accessibility are
covered; product work stayed out of system-owned directories; reusable additions
have export/specimen/tests where the mode supports them; and the actual
analysis/test/build/capture results are recorded with limitations.

State the mode you worked in and the commands you actually ran. Do not report a
command from the other mode's ladder.

## The scanner

A dependency free heuristic pass over product code. It catches the mechanical
failures that ship most often: an exception reaching user copy, awaited work
with no loading state, a collection rendered with no empty branch, a trigger
whose handler does nothing, an icon only control with no label, a visual literal
outside the foundation, `Theme.of` used as a second visual system, and copy that
leaks jargon or a placeholder.

```powershell
dart run skills/elattar-flutter-ui-director/scripts/check_ui_completeness.dart
```

It defaults to product code: `example/lib` in repository mode, `lib` in consumer
mode, with the installed system directories excluded. Pass explicit paths to
narrow it, and `--exclude=<substring>` to drop a directory. `--rules` lists the
rules.

It is heuristics, not an analyzer. A specimen or documentation app trips
`dead-press` on every demo control that intentionally does nothing, so exclude
those directories rather than pretending the findings are real. Suppress a
single justified case with `// ui-check: ignore` on the line, or a whole file
with `// ui-check: ignore-file`, and say why in the handoff. Never suppress to
make the run quiet.

Exit code 0 means clean, 1 means findings, 2 means a usage error, so it can gate
a commit.

## Completeness gate

Fill this before claiming any surface is done. Every line needs evidence: a
command you ran, a capture you looked at, or a file and line. "Looks right" is
not evidence, and a green analyzer is not a render review.

**Contract**

- [ ] A UI contract exists for the surface, and what shipped matches it.

**States**

- [ ] Every region handles loading, refreshing, ready, empty, no results, and failure, as they apply.
- [ ] First load preserves layout; refresh never blanks or shifts data.
- [ ] Empty and no results have different copy and different actions.
- [ ] Every write has a submitting state and cannot be submitted twice.
- [ ] Destructive work confirms; hard to reverse work offers undo.

**Errors**

- [ ] Exceptions are mapped at the data boundary, never formatted in a widget.
- [ ] Every failure shows a title, a body, and one next step.
- [ ] Validation lands on fields; diagnostics are collapsed and after the next step.

**Feedback**

- [ ] Every trigger has one channel and a next step. No dead presses.
- [ ] Busy state past ~400 ms, words past ~2 s, an exit past ~10 s.
- [ ] One `Toaster` and one `ToastController`; retry and undo actions work.

**Access**

- [ ] Icon only controls labelled; inputs have visible labels.
- [ ] Tab order matches reading order; focus visible, trapped, and restored.
- [ ] Async results and failures are announced.
- [ ] 200 percent text scale renders; targets at least 44 by 44 on touch.
- [ ] No status carried by color alone; reduced motion respected.

**Responsive and theme**

- [ ] Structure changes at breakpoints rather than scaling down.
- [ ] Insets spent once; the keyboard covers neither the field nor the submit.
- [ ] Every state rendered and inspected in light and dark.
- [ ] No visual literal outside the foundation; the token guard passes in repository mode.

**Components**

- [ ] Anything reusable meets all eight requirements in component-spec.md.

**Verification**

- [ ] The mode's ladder ran, and the results are reported as they came out.
- [ ] The scanner ran, and every finding is fixed or justified.
- [ ] Captures exist for both themes and at least a narrow and a wide width.
