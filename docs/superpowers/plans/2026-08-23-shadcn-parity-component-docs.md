# shadcn Parity for Component Documentation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Every component documentation page mirrors its own shadcn counterpart page, section for section, so a reader who knows shadcn finds the same answers in the same order.

**Architecture:** One worker per component. Each worker fetches its own counterpart URL, reads that page's real section list, and reshapes our page to match it. There is no shared section template: breadcrumb's sections exist because breadcrumb has those problems, and button's are different. The only thing constant across pages is the frame: demo, Installation, Usage, then that component's own sections, then API Reference, then our extra disclosure sections.

**Tech Stack:** Flutter, Dart, the Phase C docs primitives (`DocsLayout`, `DocsCodeExample`, `DocsApiTable`, `DocsInstallFacts`, `DocsFileTree`), WebFetch for reading the reference.

## Global Constraints

- Every worker reads its OWN counterpart page. Never derive a section list from a different component.
- Counterpart URL: `https://ui.shadcn.com/docs/components/base/<slug>`. If that 404s, try `https://ui.shadcn.com/docs/components/<slug>`. If both fail, report it and use judgement from the component's own source.
- No `Examples` wrapper heading. Example sections are top level, siblings of Installation and Usage.
- API Reference is the last shadcn section, one prop table per class in the family.
- Our extra sections go AFTER API Reference, in this order: States, Accessibility, Responsive, Dependencies, Theming, Source. They are not in shadcn and they are not to be dropped.
- Where their page has a section our component genuinely cannot do, SKIP it and say which. Never fake a capability.
- Where our component has something theirs does not, add a section in their style, named for what it does rather than for the enum value.
- Section names describe a reader's problem, not an enum. Theirs read `Custom separator`, `Collapsed`, `Link component`, `RTL`. Never `Default`, `Secondary`, `Destructive` as three separate sections.
- Never use a spaced em dash in any string, comment or doc comment. Use a colon, a comma, or two sentences.
- Tokens only: no `Colors.`, no `Color(`, no `TextStyle(`, no bare `Text(` for prose, no hardcoded numeric layout, no raw `Duration(`. `Text()` as a `ElButton` child is the established convention and is fine.
- `ElType.label` uppercases its text. A `find.text` on a case-carrying identifier rendered in a label will fail. Use `ElType.small` or `ElType.code` for identifiers.
- Never `pumpAndSettle()` on a looping animation. It hangs forever.
- Workers do NOT run the full test suites. They run only their own component's test file. The supervisor runs both suites once per batch.

---

## File Structure

Per component `<name>`, the worker owns exactly three files that already exist:

```
example/lib/components_docs/<name>/meta.dart
example/lib/components_docs/<name>/page.dart
example/test/components_docs/<name>_test.dart
```

Everything else is forbidden. The catalog, routes, `main.dart` and `docs_layout.dart` are supervisor-owned and already wired: adding or renaming a section inside a page needs no change to any of them.

---

## The reference frame

Read from `https://ui.shadcn.com/docs/components/base/breadcrumb` on 2026-08-23. Its actual order:

```
[live demo, before any heading]
Installation          Command and Manual tabs
Usage                 imports plus basic construction
Composition           a tree of the widget hierarchy
Basic                 <- from here down, this component's own sections
Custom separator
Dropdown
Collapsed
Link component
RTL
API Reference         one prop table per class
```

Note what is NOT there: no `Examples` parent, no `Variants` section listing enum values, no `Status`. The middle block is entirely specific to breadcrumb.

---

## Component to counterpart mapping

Thirty-seven directories exist. Their counterparts:

| Ours | Counterpart slug | Note |
|---|---|---|
| accordion | accordion | |
| alert | alert | |
| alert_dialog | alert-dialog | |
| avatar | avatar | |
| badge | badge | |
| breadcrumb | breadcrumb | the frame reference |
| button | button | already partly reshaped |
| calendar | calendar | |
| carousel | carousel | our page also covers nav_user and marker |
| checkbox | checkbox | |
| collapsible | collapsible | |
| command | command | our page also covers combobox |
| dropdown_menu | dropdown-menu | our page also covers menu |
| field | field | |
| icon | none | our page covers icon, spinner, rule. Spinner has a counterpart, use it for that part |
| input_group | input-group | our page also covers button-group and input-otp, all three have counterparts |
| native_select | native-select | our page also covers selection_control and form |
| navigation_menu | navigation-menu | our page also covers menubar, context-menu, hover-card |
| pagination | pagination | |
| popover | popover | |
| progress | progress | our page also covers skeleton |
| radio | radio-group | slug differs from ours |
| scroll_area | scroll-area | our page also covers resizable and aspect-ratio |
| separator | separator | our page also covers empty and kbd |
| sheet | sheet | our page also covers drawer |
| sidebar | sidebar | largest family |
| slider | slider | |
| stat | none | our page covers stat, item, empty, kbd. Item, Empty and Kbd have counterparts |
| switch | switch | |
| table | table | |
| tabs | tabs | |
| textarea | textarea | |
| toaster | toast | slug differs from ours |
| toggle | toggle | our page also covers toggle-group |
| tooltip | tooltip | |
| rule, spinner | metadata only | no page of their own, skip |

Where our page covers several components, read EVERY counterpart it covers and merge their sections, keeping each component's sections grouped under its own name.

---

## Per-component task template

Every worker runs this identical cycle. The component name is the only variable.

### Task: reshape `<name>`

**Files:**
- Modify: `example/lib/components_docs/<name>/page.dart`
- Modify: `example/lib/components_docs/<name>/meta.dart` if the description needs to change
- Modify: `example/test/components_docs/<name>_test.dart`
- Read, never modify: `lib/src/components/<name>.dart`

**Interfaces:**
- Consumes: `DocsLayout`, `DocsTocEntry`, `DocsCodeExample`, `DocsApiTable`, `DocsInstallFacts` from `example/lib/docs/`. `const ComponentDocEntry <name>Doc` from the sibling `meta.dart`.
- Produces: nothing new. The class name and constructor stay exactly as they are, because `main.dart` dispatches on them.

- [ ] **Step 1: read the counterpart.** WebFetch `https://ui.shadcn.com/docs/components/base/<slug>` and ask for the literal section list in order, what appears under each, and how examples are presented. Write the list down before touching code.

- [ ] **Step 2: read our source.** Open `lib/src/components/<name>.dart`. For each of their sections, decide: do we have this capability, do we not have it, or do we have something they lack.

- [ ] **Step 3: write the mapping.** Three columns, in the report: their section, our section, and the verdict, one of `mirror`, `skip because our component has no such capability`, or `ours only`.

- [ ] **Step 4: update the test first.** Assert the new section list renders, in order. This will fail against the current page.

- [ ] **Step 5: run the test, confirm it fails** for the right reason: sections not found.

```
cd example && flutter test test/components_docs/<name>_test.dart
```

- [ ] **Step 6: reshape the page.** Rename and regroup sections to the mapping. Keep every existing specimen's widget code. Delete any `Examples` wrapper. Add a `Composition` section if theirs has one. Move `API Reference` to be the last shadcn section, with our six extra sections after it.

- [ ] **Step 7: run the test until green.**

- [ ] **Step 8: verify only your own files.**

```
cd example
dart format lib/components_docs/<name> test/components_docs/<name>_test.dart
dart format --output=none --set-exit-if-changed lib/components_docs/<name> test/components_docs/<name>_test.dart
flutter analyze lib/components_docs/<name> test/components_docs/<name>_test.dart
flutter test test/components_docs/<name>_test.dart
```

The format check must print `(0 changed)`. Note `--output=none` means do not write, so `(N changed)` is a failure, not a pass. Do NOT run the full suite: the supervisor does that once per batch.

- [ ] **Step 9: report.** Their section list, our final section list, the three-column mapping, anything skipped and why, and the verbatim final line of each verify command.

---

## Batching

Nine workers at a time, roughly four batches. Order by how much a reader is likely to hit the page:

**Batch 1:** button, badge, alert, avatar, checkbox, switch, tabs, tooltip, separator
**Batch 2:** accordion, breadcrumb, card via button_card_pages, collapsible, field, input_group, radio, slider, textarea
**Batch 3:** alert_dialog, sheet, popover, dropdown_menu, navigation_menu, command, toaster, pagination, table
**Batch 4:** calendar, carousel, native_select, progress, scroll_area, sidebar, stat, toggle, icon

After each batch the supervisor:
1. Runs `cd example && flutter analyze` and `flutter test`
2. Runs `flutter test` at the repo root, which includes the token guard over `example/lib`
3. Commits the batch, then starts the next

## Known traps, so nobody rediscovers them

- Overlay components need `MaterialApp` in the test harness for a real `Overlay`, otherwise they silently never open.
- A specimen below the fold needs `tester.ensureVisible(finder)` before `tap`, otherwise the tap misses.
- `ensureVisible` is the FIX for a missed tap. The diagnostic for whether a missed tap would even be NOTICED is different: would the assertion after the tap fail if nothing had happened? On 2026-08-24 a test tapped a footer pager link at y=2821.8 in a 900px viewport. The tap landed outside the render tree, navigation never occurred, and the failure surfaced only because `destination` was asserted afterwards. A sweep of 87 `tap` sites found exactly one file with no `ensureVisible` at all, and it was safe for two independent reasons: its target sits high in the sidebar rail, and its assertion is `expect(page.offset, greaterThan(0))`, which cannot pass if the tap did nothing. Prefer assertions that FAIL on a no-op tap. A tap whose effect is asserted cannot miss quietly; a tap followed by a weaker check can miss forever.
- Authorisation is not obligation. A brief that permits adding a key, a parameter or a file is granting an option, not issuing an instruction. On 2026-08-24 a worker was authorised to add a `ValueKey` and declined, because `docs-layout-prev-next` already existed and served. A worker that takes every permission granted leaves permanent surface area nobody needed. Phrase permissions as "you MAY add X if no suitable Y exists", and treat a worker that reports "I did not need the thing you allowed" as having done the job better, not less.
- A string that also appears in an install-facts panel makes `find.text` ambiguous. Scope with `find.descendant`, do not loosen the matcher.
- `flutter analyze` on this project can take five to ten minutes. Scope it to your own paths.
- About 77 files under `example/` are already format dirty from a Dart formatter version change. That is pre existing. Do not reformat the tree, only your own files.
- `OverflowBox` cannot rescue a child from an unbounded parent. It reports `constraints.biggest` taken from the INCOMING constraints, so under an unbounded-height ancestor such as a `SingleChildScrollView` it hands the child infinity no matter what `minHeight`/`maxHeight` you pass it. There is no parameter setting that fixes this. Use a `LayoutBuilder` to obtain a finite height, then a `Stack(clipBehavior: Clip.none)` whose single NON-positioned child is the content, since `RenderStack` sizes itself from that child. Anything that must escape the bounds goes in as `Positioned`. This cost a full diagnostic wave on 2026-08-23 in `example/lib/docs/docs_layout.dart`.
- A widget test that overrides `MediaQuery` but leaves `tester.view.physicalSize` alone is still running at 800x600. The override changes what the widget tree BELIEVES, not the surface it is laid out on. Tests written this way can pass for the wrong reason: a tap that misses because the target is off-screen is indistinguishable from a tap that hit a no-op handler. Set both, or set neither and assert nothing about viewport-dependent layout.
- Do not report a mid-run progress counter as a total. `flutter test` prints a running tally that looks like a result. The only number to quote is the final summary line. Four worker reports on 2026-08-23 were wrong this way, in both directions.
- `dart format --output=none --set-exit-if-changed` printing `(N changed)` for N > 0 is a FAILURE. `--output=none` means it did not write the file, so the change it is reporting is still outstanding. Three workers read this as a pass.
- A check that meets a form it does not understand must report UNKNOWN, not pass and not fail. Nearly every check written on 2026-08-23 had only two outputs, so an unrecognised input silently became a verdict. Two real instances: a scan for uncollected test files required `package:flutter_test` and so declared five valid `package:test` files defective, and a single-line grep could not see multi-line entries and so reported them absent. In both cases the honest answer was "this file is outside what I can read". Design the third branch deliberately, and make the count of unreadable inputs part of the result.
- A check whose PASSING output is empty must be shown capable of being non-empty before its emptiness means anything. On 2026-08-24 a session confirmed "nothing has changed since my run" with `find -newermt "2026-08-24 23:20"` while the clock read 05:20. That predicate could not match a file under any circumstances. It returned empty, empty read as "nothing changed", and that read as confirmation. The check had one possible output and was quoted as though it had two. Same principle as an audit proving able to fail on a synthetic bad input: construct a case the check MUST flag, watch it flag it, then trust the empty result.
- Never pipe a test run through `tail`. On 2026-08-24 a full-suite result was gathered with `flutter test 2>&1 | grep -E '...' | tail -40`, which silently discarded every failure occurring early in the run. The four files reported as the complete failure set were merely the last four to fail, and an entire directory of failures was cut off before anyone saw it. The suite was reported green over a tree that was not. Capture to a file and read the file. `head`, `tail` and truncating reporters turn a partial view into a confident total.
- Captured output is scratch and must never be committed. Redirecting a run to a file is correct, but the file then sits UNTRACKED at whatever directory the command ran in, and `git add -A` takes it. On 2026-08-24 three capture files were sitting at the repo root minutes before a commit. This is the same shape as the two mangled-filename strays found that morning: both land at the root, both are untracked, and both are invisible to every check except reading `git status --porcelain`. Write captures to `.captures/`, which is gitignored, and read `git status --porcelain` before staging rather than trusting `git add -A`.
- Sort a failure list by SYMPTOM before sorting it by OWNER. On 2026-08-24 five failing test files across two people's lanes all failed at narrow viewports, concentrated at 390x844. Grouped by owner it read as five separate bugs and one session dispatched three individual fixes. Grouped by symptom it was obviously one bug wearing five costumes, sharing one dependency: `docs_layout.dart`. Three individual patches would each have papered over the real cause and each would then have had to be found and reverted. Owner-grouping answers "who fixes it" and destroys the only structure that identifies WHAT to fix.
- Cluster detection and cause attribution are SEPARATE steps, and being right about the first does not license skipping evidence for the second. On 2026-08-24 five narrow-viewport failures across two lanes were correctly identified as one cluster, then wrongly attributed to the shared `docs_layout.dart` rewrite. The real shared factor was the authoring: five demo `Row`s written the same day against the same `ElPanel` chrome, which leaves about 298px of a 390px viewport. Because the dispatch was framed as a DIAGNOSIS with the suspect file in scope rather than as a fix, the hypothesis was disproved instead of implemented. Had it been framed as "fix the bug in docs_layout.dart", a worker would have produced a plausible change to code that is not even reachable at those widths, and the real overflows would have survived behind a repaired-looking layout. Name the suspect, hand over the disproof route, and let the agent kill it.
- Count where a pattern FAILS, not where it appears. On 2026-08-24 an audit for classes hardcoding a constant `ValueKey` inside `build()` found 196 sites across 142 files in `example/lib`. Narrowed to the condition that actually breaks, a class that both hardcodes the key AND is constructed more than once in the same file, it found exactly ONE candidate. Same code, same day, two orders of magnitude apart, and only the second number is actionable. A page widget mounted once per route is harmless. Reporting the 196 as a defect count would have manufactured a crisis out of a safe pattern.
- Fix the defect that exists, not the shape that resembles it, and let the compiler arbitrate. On 2026-08-24 two docs specimens hardcoded a `ValueKey` in `build()`, the same shape as two siblings that were genuinely broken. Parameterising them compiled and dropped the audit count, but `flutter analyze` then reported `unused_element_parameter: A value for optional parameter 'specimenKey' isn't ever given`, which was exactly true: each is mounted once, so the parameter was dead API. The change would have added unused surface and two warnings to a clean tree to pre-empt a defect nothing can trigger. Correct resolution was to revert and document the constraint in a doc comment naming the sibling to copy if a second mount is ever added. Same code shape, opposite correct answers, discriminated by whether it actually breaks. A blanket rule of "parameterise every hardcoded key" would have produced warnings at many of the 196 sites.
- Before working around a component's behaviour in a test, check whether the component ALREADY models the state you want. On 2026-08-24 a worker hit a `pumpAndSettle` timeout caused by `ElSpinner`, which calls `AnimationController.repeat()`, and wrapped it in `TickerMode(enabled: false)`. `ElSpinner` already had a first-class, documented way to stop: `elAnimationDuration` in `theme_scope.dart:332` returns `Duration.zero` when `MediaQuery.maybeDisableAnimationsOf` is true, and the spinner reads exactly that to still itself at 0 degrees upright, mirroring the CSS reduced-motion rule. The workaround was worse than wrong-side: it reimplemented an existing capability locally and got the semantics wrong, since freezing mid-rotation is not the resting style the reference holds. The correct fixes were both already in the codebase: bounded pumping (`pump()` then `pump(Duration)`), used in `icon_test.dart`, or setting `disableAnimations: true` to exercise the real reduced-motion path.
- A file restriction is a constraint on FILES, so a worker can satisfy it with an in-scope change that is still wrong. The escape hatch must be conditioned on the OUTCOME instead: "if the only way to make this pass is to disable, freeze, shorten or bypass a behaviour the page exists to demonstrate, STOP and report, even if the change is inside your allowed files". Enumerate the equivalent wrong answers by name, because forbidding one only moves the worker to the next: `TickerMode`, a zero duration, a static placeholder, and a conditional that swaps the widget out under test are the same answer in different clothes.
- Convention documented in the ARTIFACT is not reachable from a BRIEF. `pumpAndSettle` on a looping animation was already known and correctly avoided across this suite. Three separate authors hit it independently, solved it the same way, and each documented it where they were working: `progress_test.dart` lines 19, 108, 353 and 411, plus file-level doc comments in `alert_test.dart:8` and `toaster_test.dart:8` both reading "No pumpAndSettle anywhere in this file." The knowledge was captured at least six times. A worker dispatched with "you own these three files" still rediscovered the hazard and invented a worse remedy, because it has no reason to read another component's test header. The count of real calls to comment mentions is 86 to 15. When a convention is being followed by hand across many files, lift it out of the artifacts into a file a brief can cite, or into a lint. Writing it down again at each site does not make it findable.
- A line classifier that calls anything starting with `//` a comment is fooled by code samples inside string literals. On 2026-08-24 a repair pass restored quoted text on non-comment lines and protected comment lines. It wrongly protected two lines inside a triple-quoted `_usage` string in `icons.dart`, a Dart snippet rendered to the reader in a code block, whose lines legitimately begin with `//`. They are string CONTENT, not comments, and the classifier could not tell. Only a re-run caught it. Any classifier operating line-by-line over Dart must account for multi-line string literals, or state that it cannot and have its output checked by a test rather than by inspection.
- Exclude the already-correct form explicitly, or it inflates the count. The same audit had to skip interpolated keys such as `'row:${id}'`, which are unique per instance by construction. A check that cannot distinguish `'row'` from `'row:${id}'` reports the safe pattern as the defect. Whenever a check looks for a bad form, enumerate the good forms it must not flag, and state how many it excluded.
- `find.text` on a section title is ambiguous ONLY at or above `ElBreakpoints.xl` (1280). Below that the ON THIS PAGE rail does not render; at or above it `_TableOfContents` repeats every section title verbatim, so the same string exists twice. A test therefore passes at 800 and fails at 1440 for reasons that have nothing to do with the component under test. Any audit for this hazard must model the viewport each test sets, or it reports on a condition it cannot see. The fix is always to scope the finder to the region the assertion means, for example `find.descendant(of: find.byKey(ValueKey('<name>-doc-article')), matching: find.text(title))`, and to keep requiring exactly one match. Never loosen to `findsWidgets`: that converts a real ambiguity into a permanently silent one.
- An audit that silently SKIPS an input it cannot parse produces a number true only of the inputs it read. This is distinct from misclassifying: the skipped item never enters the denominator, so the ratio looks complete. Two instances on 2026-08-24: an anchor cross-reference reported "11 files, 0 orphans" while skipping `stat_test.dart` entirely, because that file does not use `ElSection.anchorKey`, and a stale entry sat there the whole time; and a `find.text` ambiguity audit reported "3 ambiguous, 32 clean" while being structurally unable to read the three files that call `find.text(variable)` rather than a literal, one of which was actively failing on precisely that hazard. Corrected, it read 3 ambiguous, 29 clean, 5 NOT ANALYSED. Always emit the skipped count alongside the pass count, and treat pass + fail < total as a defect in the audit.
- A subagent's closing "All tests passed!" asserts ONLY over the command that agent ran. It is a true statement that becomes false when a reader promotes it from "these four files pass" to "this is fixed". The promotion is silent because the sentence does not carry its own scope. On 2026-08-24 a report correctly named its cause as a bulk sweep across roughly 123 files, correctly listed 9 files as its fix, ran 4 test files, and ended green. All three numbers were in one message. The supervisor quoted the tree as green and 38 failures were waiting. Require every report to state WHAT IT RAN alongside WHAT IT CHANGED, and read the verdict last.
- Put CAUSE-SCOPE and FIX-SCOPE side by side before reading any verdict. Sweep touched 123, fix touched 9, tested 4. Any two of those differing by an order of magnitude is the signal, and it needs no re-run to see. This is the same shape as `pass + fail < total`: a denominator sitting in plain sight next to a numerator that does not match it. Both are arithmetic, not judgement, which is why they work when attention has already failed.
- A fix that makes a test pass by removing a capability decides open questions by side effect. On 2026-08-24 `registry_builder_test` failed because it asserted against manifests deleted that morning. Deleting the generator's shot handling would have made it pass and would ALSO have silently settled an open question the repository owner had not yet answered. Correct fix was a synthetic fixture that keeps the capability under test without depending on content that no longer ships. Before deleting anything to make a test green, ask what OPTION the deletion removes from somebody else.
- Verify the PATH, not only the unit. `shot_install_test.dart` passes against a scratch registry it builds itself, so it proves the installer logic is intact and proves nothing about the shipped registry. A green unit test over synthetic input is not evidence that the end-to-end route works. State which of the two a result covers whenever reporting it.
- A misrouted write is silent and survives a green suite. On 2026-08-23 two test drafts were written to the REPO ROOT with flattened Windows absolute paths as filenames, colon rendered as U+F03A. Nothing ran them, the real files were fine, and the suite was green throughout. Before deleting such a stray, diff it against the real file: the dangerous case is the stray holding the NEWER content, which means the real file never received the work. Check `git status --porcelain` for unexpected filenames, not just unexpected paths.

## Out of scope

This plan reshapes pages that already exist. It does not create pages for the 48 components still undocumented, and it does not add registry manifests. Both are separate work.
