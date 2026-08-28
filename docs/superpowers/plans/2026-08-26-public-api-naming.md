# Public API naming Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make every public name in `elattar_design_system` guessable — named after the job it does, one name per thing — before `0.0.1` is published and every rename becomes a breaking change.

**Architecture:** Four mechanical passes over the public surface, cheapest and safest first: hide what nothing uses, merge the two type classes, rename the names that lie, then fix the registry's categories. Each pass ends with the full suite green and the generated registry rebuilt, because renaming a public symbol changes the bytes the CLI ships.

**Tech Stack:** Flutter 3.44.8, Dart 3.12.2. Package `lib/`, docs app `example/`, four Dart tool packages under `tool/`.

## Global Constraints

- **Nothing is published yet.** That is the entire reason for this plan's timing. Do not publish, tag, or deploy.
- **Every rename must also update `registry/generated/latest/`.** The registry ships the package's source verbatim; a renamed symbol changes those payloads and their sha256. CI fails if the committed registry does not match a fresh build. Rebuild with:
  `dart run tool/registry_builder/bin/build.dart .`
- **`example/lib/` consumes the package through the public barrel**, so every rename lands in the docs app too — 99 component pages reference these names. Fix them in the same task, never in a follow-up.
- **Guards that must stay green.** Extend, never weaken:
  `test/token_guard_test.dart`, `example/test/docs/docs_page_shape_test.dart`,
  `example/test/docs/docs_install_test.dart`,
  `example/test/docs/docs_no_uppercase_test.dart`,
  `example/test/docs/docs_rail_bounds_test.dart`,
  `tool/release_audit` (version/provenance).
- **No deprecation shims.** Nothing has consumed this API yet, so an alias layer would be dead weight on day one. Rename outright.
- **Commit after every task.** Never combine two tasks in one commit.

## How to run tests

Windows-side `flutter test` is blocked by Smart App Control, which refuses the unsigned `flutter_tester.exe`. **Do not run `flutter test` on Windows and never change that setting.** Use the WSL helper, in the **foreground**, never backgrounded and never wrapped in a Monitor:

```bash
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=<yours> ft root test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=<yours> ft root analyze"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=<yours> ft example analyze lib test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=<yours> ft example test"
```

Give every concurrent agent its own `FT_ID`. Never run bare `flutter analyze` from `example/` — stale build artifacts produce thousands of false errors; always scope to `lib test`. `ft example test` is ~1,345 tests; `ft root test` is ~1,510. Run both at the end of every task.

The plain-Dart packages run natively on Windows:
```bash
cd packages/elattar_cli && dart analyze && dart test
cd tool/release_audit && dart analyze && dart test
```

## Naming rules this plan applies

1. Name it after the **job**, never the appearance. `jelly` → `open`.
2. **Scope to real use.** Used only by buttons → `pressButton`. Used everywhere → `press`.
3. **One thing, one name.** Registry name, file name and class name must agree.
4. **Few names.** Anything with no consumer outside its own file leaves the public surface.
5. **Keep what is already guessable.** `fast`/`base`/`slow`, `primary`, `foreground`, `h1` are fine.

## Measured facts this plan relies on

Every count below came from a grep across `lib/` and `example/lib/` during the audit. Re-measure before acting if a number looks wrong.

| Symbol | Call sites |
| --- | --- |
| `el(n)` | 3,749 — **not renamed** |
| `MachineSurface` | 67 across 38 files |
| `Type.small` | 697 |
| `Type.label` | 53 |
| `ComponentType.textSm` | 47 |
| `ComponentType.sheetBody` | 29 across 12 components |
| `Durations.transitionDefault` | 29 — **not renamed** |
| `Durations.base` | 26 — **not renamed** |
| `Type.micro` | 24 |
| `BloomCosmic` | 11 |

---

## Task 1: Hide the theme's internal plumbing

`ThemeData` exposes 61 members. Roughly 33 are legitimate shadcn-parity tokens; the rest are single-effect plumbing a consumer scrolling for a colour has to wade through. None has a consumer outside its own defining file.

**Files:**
- Modify: `lib/src/design_system/foundation/theme.dart`
- Modify: `lib/src/design_system/foundation/shadows.dart`
- Modify: `lib/src/components/ui/feedback_surface.dart`
- Modify: `lib/src/components/ui/ambient_pattern.dart`
- Modify: `lib/src/components/ui/agent_avatar.dart`
- Test: `test/foundation_colors_test.dart` — the existing home for `ThemeData` and `Palette` assertions. There is no `foundation_theme_test.dart`; do not create one.

**Interfaces:**
- Consumes: nothing.
- Produces: a smaller `ThemeData`. Later tasks assume these members are gone from the public surface.

- [ ] **Step 1: Write the failing test**

Add to `test/foundation_colors_test.dart`:

```dart
  test('the theme exposes only tokens a consumer would reach for', () {
    // ThemeData is the object a consumer reads colour off. Every member is
    // a name they have to scroll past. These were single-effect plumbing —
    // starfield glow parameters, bloom drift stops, the agent cube's twelve
    // faces — reachable only by the one file that painted with them.
    //
    // Measured before removal: 61 public members, of which ~33 are the
    // shadcn-parity set (background/foreground/card/popover/primary/
    // secondary/muted/accent/border/input/ring/destructive, chart1-5, the
    // eight sidebar aliases). The rest are below.
    const List<String> gone = <String>[
      'bloomVoid', 'bloomL', 'bloomC', 'bloomLift', 'bloomHotC',
      'starGlowSize', 'starGlowMix',
      'ink1', 'ink2', 'ink3', 'ink4',
      'rim', 'rimStrong', 'wall',
      'cube',
    ];
    final String source =
        File('lib/src/design_system/foundation/theme.dart').readAsStringSync();
    for (final String name in gone) {
      expect(
        RegExp('\\bfinal\\s+\\w[\\w<>?]*\\s+$name\\b').hasMatch(source),
        isFalse,
        reason:
            '$name is still a public field on ThemeData. It has no consumer '
            'outside its own effect, so it is noise on the one object every '
            'user reads colour from.',
      );
    }
  });
```

`File` needs `import 'dart:io';` at the top of that test file if it is not already there.

- [ ] **Step 2: Run it to make sure it fails**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n1 ft root test test/foundation_colors_test.dart"`
Expected: FAIL — every name still matches.

- [ ] **Step 3: Move each member to its owner**

For the five `bloom*` colours: delete the fields from `ThemeData` and declare them as private statics or a private class inside `lib/src/components/ui/feedback_surface.dart`, resolved from the theme's public tokens the same way they are today. Same shape for `starGlowSize`/`starGlowMix` into `starfield.dart`, `ink1`–`ink4`/`rim`/`rimStrong`/`wall` into `shadows.dart`, and `cube` plus the whole `AgentCubeTokens` class into `agent_avatar.dart`.

Each of these is currently read exactly once or twice. Follow the reference from the call site backwards; do not invent a new resolution path.

- [ ] **Step 4: Run the tests**

```bash
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n1 ft root analyze"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n1 ft root test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n1 ft example analyze lib test"
```
Expected: all clean. If `example/` fails, a docs page was reading one of these — that is a real consumer and the member stays public. Report it rather than forcing the removal.

- [ ] **Step 5: Rebuild the registry**

```bash
dart run tool/registry_builder/bin/build.dart .
dart run tool/registry_builder/bin/validate.dart .
```

- [ ] **Step 6: Commit**

```bash
git add lib/ test/ registry/generated/
git commit -m "refactor(theme): take single-effect plumbing off the public theme"
```

---

## Task 2: Hide the keyframes nothing plays

Six keyframe classes have zero consumers in `lib/`. Only the motion demo page and tests construct them. Two (`Sweep`, `Travel`) say so in their own doc comments.

**Files:**
- Modify: `lib/src/components/ui/keyframes.dart`
- Modify: `lib/src/design_system/foundation/motion.dart`
- Modify: `example/lib/pages/motion.dart`
- Modify: `example/lib/components_docs/keyframes/page.dart`
- Test: `test/foundation_type_motion_test.dart`

**Interfaces:**
- Consumes: nothing.
- Produces: `JellyIn`, `Ratchet`, `SignOn`, `SignOnFrame`, `Reveal`, `Sweep`, `Travel` no longer exported; `Durations.reward`, `signOn`, `ratchet`, `ratchetStep`, `pressSpringUp` no longer public.

- [ ] **Step 1: Decide per class, then write the test**

These are demo-only *today*. Two are documented as deliberately demo-only; the other four simply never picked up a consumer. **Read each one and decide whether it is a real animation the system will use, or a transcription that exists for completeness.** If it is a real animation, leave it public and say so in the report. If it exists only so the motion page can show the reference's fourteen keyframes, make it private.

For every class you make private, add to `test/foundation_type_motion_test.dart`:

```dart
  test('the keyframe table exports only animations something plays', () {
    // The reference declares fourteen @keyframes. Transcribing all fourteen
    // was right; exporting all fourteen was not. A public class no component
    // plays is a name a user has to rule out.
    const List<String> private = <String>[
      'JellyIn', 'Ratchet', 'SignOn', 'SignOnFrame',
      'Reveal', 'Sweep', 'Travel',
    ];
    final String barrel =
        File('lib/elattar_design_system.dart').readAsStringSync();
    final String source = File('lib/src/components/ui/keyframes.dart').readAsStringSync();
    for (final String name in private) {
      expect(
        RegExp('\\bclass\\s+$name\\b').hasMatch(source),
        isFalse,
        reason: '$name is still a public class with no consumer in lib/',
      );
      expect(barrel.contains(name), isFalse, reason: '$name still exported');
    }
  });
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n2 ft root test test/foundation_type_motion_test.dart"`
Expected: FAIL.

- [ ] **Step 3: Make them private and repoint the demo**

Rename each class to a leading-underscore name inside `keyframes.dart`. The motion demo page and the `keyframes` docs page construct them; those pages must stop doing so. Replace the demo's use with the same visual built from `Keyframes` directly, or drop that panel and say so in the page's own prose — do not leave a page describing an animation the reader cannot reach.

Do the same for the durations that back only these: `reward`, `signOn`, `ratchet`, `ratchetStep`, `pressSpringUp`.

- [ ] **Step 4: Run the tests**

```bash
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n2 ft root test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n2 ft example analyze lib test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n2 ft example test test/components_docs/keyframes_test.dart"
```

- [ ] **Step 5: Rebuild the registry and commit**

```bash
dart run tool/registry_builder/bin/build.dart .
git add lib/ example/ test/ registry/generated/
git commit -m "refactor(motion): stop exporting keyframes nothing plays"
```

---

## Task 3: Merge ComponentType into Type

Two classes, 27 and 38 members, **zero shared names**. A user writing `Type.buttonLabel` gets a compile error and no hint, because the name lives on the other class. The repository's own rollout plan wrote `Type.inputSerial` and `Type.buttonLabelCaps` — both wrong, both on `ComponentType`. The document warning about the trap fell into it.

**Files:**
- Modify: `lib/src/design_system/foundation/typography.dart`
- Modify: `lib/elattar_design_system.dart`
- Modify: every file referencing `ComponentType` (grep first — expect ~40 in `lib/`, ~60 in `example/lib/`)
- Test: `test/foundation_type_motion_test.dart`

**Interfaces:**
- Consumes: nothing.
- Produces: one `Type` carrying all 65 specs. `ComponentType` no longer exists. Tasks 4 and 5 rename members *on the merged class*.

- [ ] **Step 1: Write the failing test**

```dart
  test('there is one type class, and it holds every spec', () {
    // 27 + 38 members, zero overlapping names, so the merge cannot collide.
    // The split was real — one class transcribed globals.css's .type-* rules,
    // the other the cascades components resolved inline — but it was never
    // inferable from the API: same shape, same file, same call pattern. The
    // only way to know which class a name lived on was to have been told.
    const List<String> fromComponentType = <String>[
      'buttonLabel', 'cardTitle', 'dialogTitle', 'fieldLabel', 'menuLabel',
      'tableHead', 'tooltipLabel', 'badgeLabel', 'avatarFallback',
      'textareaBody', 'kbdKey', 'sidebarMenuBadge',
    ];
    const List<String> fromElType = <String>[
      'h1', 'h2', 'h3', 'h4', 'body', 'small', 'lead', 'code', 'caption',
      'section', 'display',
    ];
    final String source =
        File('lib/src/design_system/foundation/typography.dart').readAsStringSync();

    expect(
      RegExp(r'\bclass\s+ComponentType\b').hasMatch(source),
      isFalse,
      reason: 'ComponentType still exists — the split is what confuses',
    );
    for (final String name in <String>[...fromComponentType, ...fromElType]) {
      expect(
        RegExp('TypeSpec\\s+$name\\b').hasMatch(source),
        isTrue,
        reason: '$name is missing from the merged Type',
      );
    }
  });
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n3 ft root test test/foundation_type_motion_test.dart"`
Expected: FAIL — `ComponentType` still exists.

- [ ] **Step 3: Merge**

Move every member of `ComponentType` into `Type`, keeping each member's doc comment verbatim — those comments carry the CSS provenance and are the reason the values are trusted. Delete the now-empty `ComponentType` and its export.

Then replace every reference:

```bash
grep -rln "ComponentType" lib example test | \
  xargs sed -i 's/\bElComponentType\./Type./g'
grep -rn "ComponentType" lib example test | grep -v "^Binary"
```

The second command must print nothing except doc comments that deliberately describe the history. Rewrite those to say the classes were merged and why — do not delete the provenance.

- [ ] **Step 4: Run everything**

```bash
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n3 ft root analyze"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n3 ft root test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n3 ft example analyze lib test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n3 ft example test"
```

- [ ] **Step 5: Update the uppercase guard**

`example/test/docs/docs_no_uppercase_test.dart` bans seven roles by name. Two of them — `inputSerial`, `buttonLabelCaps` — were listed under the wrong class in the plan that created the guard. With one class the ban list is unambiguous; update it to the merged names and note in the file that the previous list named a class two of them never lived on.

- [ ] **Step 6: Rebuild the registry and commit**

```bash
dart run tool/registry_builder/bin/build.dart .
git add lib/ example/ test/ registry/generated/
git commit -m "refactor(type): one type class, not two"
```

---

## Task 4: Rename the type roles that lie

**Files:**
- Modify: `lib/src/design_system/foundation/typography.dart`
- Modify: every consumer (grep per name)
- Modify: `example/test/docs/docs_no_uppercase_test.dart`
- Test: `test/foundation_type_motion_test.dart`

**Interfaces:**
- Consumes: Task 3's merged `Type`.
- Produces: `Type.body`, `Type.bodySm`, `Type.overline`, `Type.overlineSm`.

| Now | Becomes | Why | Sites |
| --- | --- | --- | --- |
| `sheetBody` | `body` | used by 12 unrelated components — dialog, select, input, message, drawer — under a name saying "sheet" | 29 |
| `textSm` | `bodySm` | pure size name; it is the de facto default body text across 13 components | 47 |
| `label` | `overline` | uppercase eyebrow; collides in meaning with five sentence-case `*Label` members | 53 |
| `micro` | `overlineSm` | names its size, not its job; it is the smaller rung of the same eyebrow ladder | 24 |

Note the collision this resolves: after the merge, `Type.body` already exists (the 15px reading size) and `sheetBody` wants that name. **They are different specs.** Read both before merging names — if their values differ, the reading size keeps `body` and `sheetBody` becomes `bodyCompact`. Verify, then pick, and record which you chose in the commit message.

- [ ] **Step 1: Write the failing test**

```dart
  test('type roles are named for their job', () {
    final String source =
        File('lib/src/design_system/foundation/typography.dart').readAsStringSync();
    for (final String gone in <String>['sheetBody', 'textSm', 'micro']) {
      expect(
        RegExp('TypeSpec\\s+$gone\\b').hasMatch(source),
        isFalse,
        reason: '$gone names a size or the wrong component, not a job',
      );
    }
    for (final String present in <String>['bodySm', 'overline', 'overlineSm']) {
      expect(
        RegExp('TypeSpec\\s+$present\\b').hasMatch(source),
        isTrue,
        reason: '$present is missing',
      );
    }
  });
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n4 ft root test test/foundation_type_motion_test.dart"`
Expected: FAIL.

- [ ] **Step 3: Rename, one name at a time**

```bash
grep -rln "Type\.textSm" lib example test | xargs sed -i 's/Type\.textSm/Type.bodySm/g'
grep -rln "Type\.micro"  lib example test | xargs sed -i 's/Type\.micro/Type.overlineSm/g'
grep -rln "Type\.label"  lib example test | xargs sed -i 's/Type\.label/Type.overline/g'
```

`sheetBody` last, after the `body` collision above is settled. Rename the declarations in `typography.dart` too — `sed` over call sites does not touch the definition.

- [ ] **Step 4: Run everything and update the guard**

```bash
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n4 ft root test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n4 ft example analyze lib test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n4 ft example test"
```

`docs_no_uppercase_test.dart` bans `label` and `micro` by name — update to `overline` and `overlineSm` or the guard silently stops guarding.

- [ ] **Step 5: Rebuild the registry and commit**

```bash
dart run tool/registry_builder/bin/build.dart .
git add lib/ example/ test/ registry/generated/
git commit -m "refactor(type): name the roles for their job"
```

---

## Task 5: Rename the motion names that lie

**Files:**
- Modify: `lib/src/design_system/foundation/motion.dart`
- Modify: `lib/src/components/ui/keyframes.dart`
- Modify: `lib/src/components/ui/collapsible.dart`, `dialog.dart`, `sidebar.dart`, `icon_swap.dart`, `selection_control.dart`, `message_scroller.dart`
- Modify: `lib/src/components/ui/active_indicator.dart`
- Test: `test/foundation_type_motion_test.dart`

**Interfaces:**
- Consumes: nothing.
- Produces: `Durations.open`, `Durations.squash`, `Durations.scrollFrameBudget`, `Squash`.

| Now | Becomes | Why |
| --- | --- | --- |
| `Durations.jelly` (420ms) | `open` | dialog opening, collapsible expanding — confirmed at the call sites |
| `Durations.animJelly` (600ms) | `squash` | backs `Jelly`, the arrival squash shared by active_indicator, sidebar, icon_swap, selection_control |
| `Jelly` | `Squash` | same |
| `Durations.frame` (16667µs) | `scrollFrameBudget` | a 60Hz frame budget for smooth-scroll maths, not a duration token |

**Not renamed, and this reverses an earlier judgement:** `base` and `transitionDefault` are both 250ms, but `transitionDefault` is the most-used token in the system (29 sites to `base`'s 26), is already job-named, and the two carry different declared CSS sources. Deleting either is churn with no gain.

- [ ] **Step 1: Write the failing test**

```dart
  test('durations are named for what they animate', () {
    final String source = File('lib/src/design_system/foundation/motion.dart').readAsStringSync();
    for (final String gone in <String>['jelly', 'animJelly', 'frame']) {
      expect(
        RegExp('Duration\\s+$gone\\s*=').hasMatch(source),
        isFalse,
        reason: '$gone says how it looks, not what it does',
      );
    }
    for (final String present in <String>['open', 'squash', 'scrollFrameBudget']) {
      expect(
        RegExp('Duration\\s+$present\\s*=').hasMatch(source),
        isTrue,
        reason: '$present is missing',
      );
    }
    // Kept deliberately: same value, different source, both heavily used.
    expect(RegExp(r'Duration\s+base\s*=').hasMatch(source), isTrue);
    expect(
      RegExp(r'Duration\s+transitionDefault\s*=').hasMatch(source),
      isTrue,
    );
  });
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n5 ft root test test/foundation_type_motion_test.dart"`
Expected: FAIL.

- [ ] **Step 3: Rename**

`animJelly` before `jelly`, or the shorter name's `sed` will corrupt the longer one:

```bash
grep -rln "Durations\.animJelly" lib example test | xargs sed -i 's/Durations\.animJelly/Durations.squash/g'
grep -rln "Durations\.jelly"     lib example test | xargs sed -i 's/Durations\.jelly/Durations.open/g'
grep -rln "Durations\.frame"     lib example test | xargs sed -i 's/Durations\.frame/Durations.scrollFrameBudget/g'
grep -rln "\bElJelly\b"            lib example test | xargs sed -i 's/\bElJelly\b/Squash/g'
```

Then the declarations in `motion.dart` and the class in `keyframes.dart`. Update each doc comment: `jelly`'s explains the 420ms overshoot and stays, but must stop calling itself jelly.

- [ ] **Step 4: Run everything**

```bash
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n5 ft root test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n5 ft example analyze lib test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n5 ft example test"
```

- [ ] **Step 5: Rebuild the registry and commit**

```bash
dart run tool/registry_builder/bin/build.dart .
git add lib/ example/ test/ registry/generated/
git commit -m "refactor(motion): name the durations for what they animate"
```

---

## Task 6: Rename the effect classes

**Files:**
- Rename: `lib/src/components/ui/premium_surface.dart` → `value_shimmer.dart`
- Rename: `lib/src/components/ui/action_feedback.dart` → `action_beat.dart`
- Rename: `lib/src/components/ui/feedback_surface.dart` → `feedback_glow.dart`
- Modify: `lib/elattar_design_system.dart`, `lib/src/components/ui/button.dart`, `alert.dart`, `toaster.dart`
- Modify: `registry/components/*.json` and the example's `components_docs/` directories for each
- Test: `test/effects_test.dart`

**Interfaces:**
- Consumes: nothing.
- Produces: `ValueShimmer`, `ActionBeat`, `FeedbackGlow`.

| Now | Becomes | Sites |
| --- | --- | --- |
| `FoilValue` | `ValueShimmer` | 1 (Button, premium) |
| `SheenAction` | `ActionBeat` | 1 (Button, default) |
| `BloomCosmic` | `FeedbackGlow` | 11 (Alert, Toaster) |

`MediaScrim`, `PageGlow` and `Starfield` **keep their names** — "scrim", "page glow" and "starfield" each say what the thing is.

This task moves files, so the registry item names, the docs directories and the routes move with them. Rule 3: registry name, file name and class name must agree. `premium-surface` → `value-shimmer`, `action-feedback` → `action-beat`, `feedback-surface` → `feedback-glow`.

- [ ] **Step 1: Write the failing test**

```dart
  test('effects are named for what they do', () {
    final String barrel = File('lib/elattar_design_system.dart').readAsStringSync();
    for (final String gone in <String>[
      'FoilValue', 'SheenAction', 'BloomCosmic',
    ]) {
      expect(barrel.contains(gone), isFalse, reason: '$gone still exported');
    }
    for (final String present in <String>[
      'ValueShimmer', 'ActionBeat', 'FeedbackGlow',
    ]) {
      expect(barrel.contains(present), isTrue, reason: '$present missing');
    }
  });
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n6 ft root test test/effects_test.dart"`
Expected: FAIL.

- [ ] **Step 3: Rename classes, files, registry items and docs pages**

```bash
git mv lib/src/components/ui/premium_surface.dart   lib/src/components/ui/value_shimmer.dart
git mv lib/src/components/ui/action_feedback.dart lib/src/components/ui/action_beat.dart
git mv lib/src/components/ui/feedback_surface.dart lib/src/components/ui/feedback_glow.dart
git mv registry/components/premium-surface.json   registry/components/value-shimmer.json
git mv registry/components/action-feedback.json registry/components/action-beat.json
git mv registry/components/feedback-surface.json registry/components/feedback-glow.json
git mv example/lib/components_docs/premium_surface   example/lib/components_docs/value_shimmer
git mv example/lib/components_docs/action_feedback example/lib/components_docs/action_beat
git mv example/lib/components_docs/feedback_surface example/lib/components_docs/feedback_glow
```

Then the identifiers, the `name:` inside each manifest and each `meta.dart`, the imports, `catalog.dart`, `specs.dart` and `main.dart`'s route map. The docs test files move too.

- [ ] **Step 4: Run everything**

```bash
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n6 ft root test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n6 ft example analyze lib test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n6 ft example test"
```

`docs_install_test.dart` asserts every registry item has a page and every page's command names a real item. Renaming an item changes both sides; if that test fails, one side was missed.

- [ ] **Step 5: Rebuild the registry and commit**

```bash
dart run tool/registry_builder/bin/build.dart .
dart run tool/registry_builder/bin/validate.dart .
git add -A lib/ example/ registry/ test/
git commit -m "refactor(effects): name the effects for what they do"
```

---

## Task 7: MachineSurface → RaisedSurface

The most-consumed effect in the system: **67 call sites across 38 files**. It is the name a user meets most, and "machine" tells them nothing. Approved explicitly as in-scope.

**Files:**
- Rename: `lib/src/components/ui/surface.dart` → `raised_surface.dart`
- Modify: 24 files under `lib/src/components/`, 3 under `lib/src/components/ui/`, 14 under `example/lib/`
- Modify: `registry/components/surface.json` → `raised-surface.json`
- Modify: `example/lib/components_docs/surface/` → `raised_surface/`
- Test: `test/machine_surface_test.dart` → `test/raised_surface_test.dart`

**Interfaces:**
- Consumes: nothing.
- Produces: `RaisedSurface`, and `RaisedSurfaceSpec` if the spec type is named to match.

- [ ] **Step 1: Write the failing test**

```dart
  test('the raised surface is named for what it does', () {
    final String barrel = File('lib/elattar_design_system.dart').readAsStringSync();
    expect(barrel.contains('MachineSurface'), isFalse);
    expect(barrel.contains('RaisedSurface'), isTrue);
  });
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n7 ft root test test/machine_surface_test.dart"`
Expected: FAIL.

- [ ] **Step 3: Rename mechanically, then read the diff**

```bash
git mv lib/src/components/ui/surface.dart lib/src/components/ui/raised_surface.dart
git mv test/machine_surface_test.dart test/raised_surface_test.dart
git mv registry/components/surface.json registry/components/raised-surface.json
git mv example/lib/components_docs/surface example/lib/components_docs/raised_surface
grep -rln "MachineSurface\|surface\|surface" lib example test registry tool | \
  xargs sed -i -e 's/MachineSurface/RaisedSurface/g' \
               -e 's/surface/raised_surface/g' \
               -e 's/surface/raised-surface/g'
git diff --stat
```

**Then read the diff.** A blind `sed` across 38 files will also rewrite the word inside prose that explains the metaphor. Some of that prose is worth keeping and rewording, not renaming — a doc comment reading "the surface metaphor" becomes nonsense as "the raised-surface metaphor" if the sentence was explaining why it was called that.

- [ ] **Step 4: Run absolutely everything**

```bash
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n7 ft root analyze"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n7 ft root test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n7 ft example analyze lib test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n7 ft example test"
```

This is the task most likely to break something. All 1,510 package tests and all 1,345 example tests must pass before the commit.

- [ ] **Step 5: Rebuild the registry and commit**

```bash
dart run tool/registry_builder/bin/build.dart .
dart run tool/registry_builder/bin/validate.dart .
git add -A
git commit -m "refactor(effects): machine surface is a raised surface"
```

---

## Task 8: One glass class, not four

`GlassVariant.panel`, `GlassVariant.navigation`, `GlassVariant.prominent` and `GlassVariant.control` take the same three parameters, differ only in fill and blur, and are thin wrappers over one private `_GlassSurface`. `Button` already solves this shape with one class and a variant enum.

Only three exist in the source CSS; `GlassVariant.navigation` is a Flutter-only addition. An enum makes that honest instead of implying four co-equal utilities.

**Files:**
- Modify: `lib/src/components/ui/glass.dart`
- Modify: `example/lib/showcase/showcase_app.dart`, `showcase_dashboard.dart`, `example/lib/pages/shadows.dart`
- Modify: `example/lib/components_docs/glass/page.dart`
- Test: `test/effects_test.dart`

**Interfaces:**
- Consumes: nothing.
- Produces: `Glass({GlassVariant variant, BorderRadius radius, EdgeInsets padding, Widget child})` and `enum GlassVariant { panel, panelClear, panelDeep, control }`.

- [ ] **Step 1: Write the failing test**

```dart
  test('glass is one class with a variant, like every other family', () {
    final String barrel = File('lib/elattar_design_system.dart').readAsStringSync();
    for (final String gone in <String>[
      'GlassVariant.navigation', 'GlassVariant.prominent', 'GlassVariant.control',
    ]) {
      expect(barrel.contains(gone), isFalse, reason: '$gone still exported');
    }
    expect(barrel.contains('GlassVariant'), isTrue);
  });

  testWidgets('each variant paints its own fill', (WidgetTester tester) async {
    for (final GlassVariant variant in GlassVariant.values) {
      await tester.pumpWidget(
        Theme(
          controller: ThemeController(mode: ThemeMode.dark),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Glass(variant: variant, child: const SizedBox(height: 40)),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull, reason: '$variant threw');
    }
  });
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n8 ft root test test/effects_test.dart"`
Expected: FAIL — `GlassVariant` undefined.

- [ ] **Step 3: Collapse the four**

Add the enum, give `Glass` a `variant` parameter defaulting to `GlassVariant.panel`, and move each old class's fill/blur/shadow choice into a switch over the enum — reading the values off the existing classes, not re-deriving them. Delete the three extra classes.

Document on `GlassVariant.panelClear` that it has no counterpart in the reference CSS, which its own former class name concealed.

- [ ] **Step 4: Run the tests**

```bash
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n8 ft root test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n8 ft example analyze lib test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n8 ft example test test/components_docs/glass_test.dart"
```

- [ ] **Step 5: Rebuild the registry and commit**

```bash
dart run tool/registry_builder/bin/build.dart .
git add lib/ example/ test/ registry/generated/
git commit -m "refactor(glass): one class and a variant, like every other family"
```

---

## Task 9: One thing, one name

Two items where the registry name, the file name and the class name disagree.

**Files:**
- Modify: `registry/components/press.json` (item name `press` → `press`)
- Modify: `lib/src/components/ui/active_indicator.dart` (`SlidingPillGroup` → `SlidingPill`)
- Modify: `example/lib/components_docs/press/` → `press/`
- Modify: `catalog.dart`, `specs.dart`, `main.dart`, the meta and page files
- Test: `test/registry_naming_test.dart` (create)

**Interfaces:**
- Consumes: nothing.
- Produces: registry item `press`; class `SlidingPill`.

- [ ] **Step 1: Write the failing test**

```dart
// test/registry_naming_test.dart
/// A registry item, the file that implements it and the class it exports must
/// agree. `press` / `press.dart` / `Press` was three names for one
/// thing, and `active-indicator` / `active_indicator.dart` / `SlidingPillGroup` was
/// a fourth shape again.
library;

import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

void main() {
  test('every registry item name matches its file stem', () {
    final Map<String, Object?> registry = jsonDecode(
      File('registry/generated/latest/registry.json').readAsStringSync(),
    ) as Map<String, Object?>;

    final List<String> mismatched = <String>[];
    for (final Object? raw in registry['items']! as List<Object?>) {
      final Map<String, Object?> item = raw! as Map<String, Object?>;
      final String name = item['name']! as String;
      final String? link = item['sourceLink'] as String?;
      if (link == null) continue;
      final String stem = link.split('/').last.replaceAll('.dart', '');
      if (stem != name.replaceAll('-', '_')) {
        mismatched.add('$name -> $stem');
      }
    }
    expect(mismatched, isEmpty, reason: mismatched.join('\n'));
  });
}
```

This test will surface every mismatch, not only the two known ones. Some may be legitimate — `source-foundation` covers a whole directory. Add a documented allowlist for those, naming each and why.

- [ ] **Step 2: Run it to make sure it fails**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n9 ft root test test/registry_naming_test.dart"`
Expected: FAIL, listing `press` and any others.

- [ ] **Step 3: Rename**

```bash
git mv registry/components/press.json registry/components/press.json 2>/dev/null || true
git mv example/lib/components_docs/press example/lib/components_docs/press
grep -rln "press" lib example registry tool | xargs sed -i 's/press/press/g'
grep -rln "SlidingPillGroup" lib example test | xargs sed -i 's/SlidingPillGroup/SlidingPill/g'
```

- [ ] **Step 4: Run the tests**

```bash
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n9 ft root test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n9 ft example analyze lib test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n9 ft example test"
```

- [ ] **Step 5: Rebuild the registry and commit**

```bash
dart run tool/registry_builder/bin/build.dart .
git add -A
git commit -m "refactor(registry): one name per thing"
```

---

## Task 10: Categories a user can guess

`effect` holds nine unrelated things, `motion` holds five, and `icon-swap` is filed as a `component`. `action-feedback` (an interaction animation) sits under `effect` while `lift` (also an interaction animation) sits under `motion`.

**Files:**
- Modify: every `registry/{components,effects,motion}/*.json` whose `type` changes
- Modify: `tool/registry_builder/` if `type` is a closed set there
- Modify: `example/lib/components_docs/*/meta.dart` where the eyebrow names the category
- Modify: `example/lib/docs/docs_layout.dart` if the sidebar groups by type
- Test: `test/registry_naming_test.dart`

**Interfaces:**
- Consumes: Tasks 6, 7 and 9's renames.
- Produces: five categories.

| Category | Items |
| --- | --- |
| `surface` | glass, raised-surface, media-scrim, **value-shimmer** |
| `atmosphere` | background-effect, starfield, feedback-glow |
| `interaction` | action-beat, lift, press, active-indicator, content-change, icon-swap |
| `primitive` | keyframes |
| `component` | voice-indicator (moves **out** of effect), and the existing 84 |

`value-shimmer` goes to **surface**, decided explicitly: it paints a container's fill like glass and raised-surface do, and its perpetual drift is a property of that surface rather than a response to the user.

- [ ] **Step 1: Write the failing test**

```dart
  test('every non-component item is in a category a user could guess', () {
    const Map<String, String> expected = <String, String>{
      'glass': 'surface',
      'raised-surface': 'surface',
      'media-scrim': 'surface',
      'value-shimmer': 'surface',
      'background-effect': 'atmosphere',
      'starfield': 'atmosphere',
      'feedback-glow': 'atmosphere',
      'action-beat': 'interaction',
      'lift': 'interaction',
      'press': 'interaction',
      'active-indicator': 'interaction',
      'content-change': 'interaction',
      'icon-swap': 'interaction',
      'keyframes': 'primitive',
      'voice-indicator': 'component',
    };
    final Map<String, Object?> registry = jsonDecode(
      File('registry/generated/latest/registry.json').readAsStringSync(),
    ) as Map<String, Object?>;
    final Map<String, String> actual = <String, String>{
      for (final Object? raw in registry['items']! as List<Object?>)
        (raw! as Map<String, Object?>)['name']! as String:
            (raw as Map<String, Object?>)['type']! as String,
    };
    expected.forEach((String name, String type) {
      expect(actual[name], type, reason: '$name is filed as ${actual[name]}');
    });
  });
```

- [ ] **Step 2: Run it to make sure it fails**

Run: `wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n10 ft root test test/registry_naming_test.dart"`
Expected: FAIL.

- [ ] **Step 3: Retype each item**

Edit the `type` in each source manifest under `registry/`. If `tool/registry_builder/` validates `type` against a closed set, widen it there first and update its own tests. The docs pages' eyebrows (`COMPONENTS / EFFECTS`) name the old categories — update those too, or a page will announce a category the registry no longer has.

- [ ] **Step 4: Run everything**

```bash
dart run tool/registry_builder/bin/build.dart .
dart run tool/registry_builder/bin/validate.dart .
cd tool/registry_builder && dart test && cd ../..
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n10 ft root test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n10 ft example analyze lib test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=n10 ft example test"
```

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "refactor(registry): categories a reader can guess"
```

---

## Task 11: Final gate

- [ ] **Step 1: The whole ladder**

```bash
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=nf ft root analyze"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=nf ft root test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=nf ft example analyze lib test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=nf ft example test"
cd packages/elattar_cli && dart analyze && dart test && dart pub publish --dry-run && cd ../..
cd tool/release_audit && dart test && cd ../..
```

`dart pub publish --dry-run` must report **0 warnings** on a clean tree. `--dry-run` only — never a real publish.

- [ ] **Step 2: Prove the registry is reproducible**

```bash
dart run tool/registry_builder/bin/build.dart .
git diff --exit-code -- registry/generated/latest
```

Must exit 0. A non-empty diff means a task rebuilt the registry from a different source state than it committed — which is what CI's own gate checks.

- [ ] **Step 3: Look at the site**

```bash
cd example && flutter build web --release --base-href /flutter-design-system/
```

Serve `build/web` and open three pages that these renames touched hardest: `/components/button` (raised-surface, value-shimmer, action-beat, the type roles), `/components/glass` (the collapsed variant enum), `/components/keyframes` (the classes that went private). Confirm each renders and its API tables name the new symbols.

This step exists because a green suite has already shipped four visible defects in this repository — a doubled heading on all 99 pages, clipped rails, unclickable rail rows, and a Back button that left the site. Tests assert what someone thought to check.

- [ ] **Step 4: Write the report**

`docs/superpowers/reports/naming/public-api-naming-review.md`, recording the commands actually run with their outcomes, every rename with its measured call-site count, every name deliberately **kept** and why, and anything that could not be verified. Commit with `git add -f` — a bare `reports/` pattern in `.gitignore` over-matches that directory.

---

## Out of scope

- `el(n)` — 3,749 call sites, mnemonic documented, no rename earns that.
- `Widths`, `Radii`, `Breakpoints`, `Containers`, `Shadows` — audited and found correct. An earlier claim that `Widths` mixed border widths with layout widths was **wrong**: there is no `Widths.md`. The `md = 10` is `Radii.md`, a corner radius, correctly placed.
- `Durations.base` / `transitionDefault` — same value, both kept. See Task 5.
- `Palette`'s ramp names — the raw layer, documented as theme-independent by design.
- The charts gallery and the six site fixes — separate spec,
  `docs/superpowers/specs/2026-08-26-charts-and-site-fixes-design.md`.

## Risks

- **Task 7 is the dangerous one.** 67 sites, 38 files, and a mechanical `sed` that will also hit prose explaining the old metaphor. Read the diff before committing.
- **Renames change the registry payloads.** Every task rebuilds it; Task 11 Step 2 proves reproducibility. A task that forgets leaves CI red.
- **`Type.body` may already be taken** when `sheetBody` wants that name. Task 4 says to check the two specs' values before choosing, rather than assuming they are the same.
- **The docs app is a consumer.** 99 component pages reference these names, so `ft example test` is not optional in any task.
