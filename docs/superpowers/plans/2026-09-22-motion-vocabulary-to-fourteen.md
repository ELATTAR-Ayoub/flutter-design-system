# Flutter Motion Vocabulary → Fourteen Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bring the Flutter package's motion vocabulary down to the same fourteen names the web design system landed on 2026-09-22, so a consumer re-themes one file (`lib/src/design_system/foundation/motion.dart`) and every component follows — and so `lib/motion-names.ts` on the web side names real Flutter symbols again.

**Architecture:** `lib/src/components/ui/keyframes.dart` becomes the home of exactly eleven motion recipes (`EnterMotion` … `CaretMotion`, plus `SwapRollMotion`) and the `KeyframePlayer` that plays them. `Press` stays in `press.dart` and becomes the one click feel (scale 0.9); `ActiveIndicator` stays as it is. Component-owned motion — `AgentCubeMotion`, `ChartMotion`, the sheet's edge slide, the drawer's vaul slide — stays in its component file and is explicitly not vocabulary. Every overlay (`dialog`, `alert_dialog`, `popover`, `tooltip`, `hover_card`, `menu`, `combobox`, `select`) plays `OpenMotion` / `CloseMotion` through one shared `OpenTransition` instead of its own hand-rolled tween. `MotionDurations` loses every constant the fourteen no longer read; the Radix/sonner/vaul **behaviour timers** (delays, lifetimes, tick intervals) are not animations and stay. `MotionCurves` keeps the web's seven.

**Tech Stack:** Flutter (stable), `flutter analyze`, `flutter test`, `dart run tool/registry_builder/bin/build.dart .`, the web repo's `scripts/verify-flutter-symbols.mjs` (run with `FLUTTER_DS_ROOT` pointing at this checkout).

## Global Constraints

- Work in a git worktree of this repo; `main` has uncommitted site work (`example/lib/site/*`, `.github/workflows/pages.yml`) that must not be touched or committed.
- Every task ends green on `flutter analyze` and `flutter test`, and with a commit. The final task also rebuilds and validates the registry and runs the web repo's Flutter-symbol check.
- `test/token_guard_test.dart` is the literal guard: no `Duration(...)`, `Cubic(...)` or scale literal outside `lib/src/design_system/foundation/` and the files its `_exemptDirs` already names. `keyframes.dart` is exempt (it is where recipes are defined). No new exemptions except the two this plan names (Task 2).
- **The fourteen, and their Flutter spellings (do not re-litigate):**

| Web | Flutter |
|---|---|
| anim-enter | `EnterMotion` |
| anim-exit | `ExitMotion` |
| anim-open | `OpenMotion` |
| anim-close | `CloseMotion` |
| anim-expand / anim-collapse | `ExpandMotion` (collapse = the same controller reversed) |
| anim-change | `ChangeMotion` |
| anim-spin | `SpinMotion` |
| anim-shimmer / anim-shimmer-text | `ShimmerMotion` |
| anim-progress-indeterminate | `ProgressMotion` |
| anim-pulse | `PulseMotion` |
| anim-caret | `CaretMotion` |
| press | `Press` (scale 0.9) |
| toggle-slide | `ActiveIndicator` (unchanged) |
| swap-roll | `SwapRollMotion` |

- Retired class names never appear in `lib/`, `example/lib/` or `test/` again except in `CHANGELOG.md` and the rename record this plan writes. The list: `EntranceMotion`, `SpringEntranceMotion`, `StateChangeMotion`, `DiscreteProgressMotion`, `TextRevealMotion`, `TextRevealFrame`, `RevealMotion`, `LoadingShimmerMotion`, `LivePulseMotion`, `SweepMotion`, `TravelMotion`, `CheckmarkDrawMotion`, `DashDrawMotion`, `DotSelectionMotion`, `ContentSwapMotion`, `FadeUp`, `RowMotion`, `MenuMotion`, `InteractiveCard`, `_PanelIn`, `_FadeIn`, `_ConfirmSlide`, `BlurSwitchController`.
- Retired `MotionDurations` members: `reward`, `popIn`, `springUp`, `signOn`, `ratchet`, `checkDraw`, `dashDraw`, `dotPop`, `pressSpringUp`, `copyConfirmation`, `liftY`, `keyDownY`, `frame`, `overlayExit`, `close`, `collapse` (the last three become plain reads of `normal`). Retired `MotionTransforms` members: `press` (0.94), `clickSpringScale`, `pressSpringScale`, `buttonPress`, `sliderThumbHoverScale`, `sliderThumbActiveScale`, `liftY`, `keyDownY` — replaced by one `MotionTransforms.press = 0.9`. Retired `MotionCurves` members: `balanced`, `decelerate`, `symmetric`, `linear`, `vaul` (vaul's curve moves into `drawer.dart`).
- Every mention of `yuki-*`, `pulls-*`, `globals.css L…` line citations and "the reference" in doc comments under `lib/` and `example/lib/` is rewritten to describe the Flutter code as the authority. `AGENTS.md` already says the Flutter package is authoritative; the comments have to agree.
- The web repo (`D:\DESIGN\Design-System-2026-8\design-system`) must be updated in the same working session: `lib/motion-names.ts`'s `flutter:` fields and `docs/contracts/flutter-web-foundation-parity.md` name the new symbols. That is Task 8 here and is a separate commit in the web repo.

---

## File map

| File | After this plan |
|---|---|
| `lib/src/design_system/foundation/motion.dart` | `MotionDurations`: 7-step scale + per-loop/surface + behaviour timers · `MotionTransforms.press = 0.9` only · `MotionCurves`: emphasized, enter, exit, move, settle, standard, outFlex |
| `lib/src/components/ui/keyframes.dart` | `StepCurve`, `Keyframes`, `KeyframeFill`, `KeyframePlayer` + exactly 12 recipe classes: `EnterMotion`, `ExitMotion`, `OpenMotion`, `CloseMotion`, `ExpandMotion`, `ChangeMotion`, `SpinMotion`, `ShimmerMotion`, `ProgressMotion`, `PulseMotion`, `CaretMotion`, `SwapRollMotion` |
| `lib/src/components/ui/open_transition.dart` | **new** — `OpenTransition` (moved out of `dialog.dart`), plays `OpenMotion` forward and `CloseMotion` in reverse; used by every overlay |
| `lib/src/components/ui/press.dart` | `Press` with a fixed scale of `MotionTransforms.press`; the `scale` parameter is removed |
| `lib/src/components/ui/hover_builder.dart` | `InteractiveCard` removed; `HoverBuilder` stays (it is a hover *state* helper, not motion) |
| `lib/src/components/ui/agent_transcript.dart`, `agent_history.dart`, `agent_core.dart`, `agent_face.dart` | consume `EnterMotion` / `ExitMotion` / `ShimmerMotion` / `PulseMotion`; local `FadeUp`, `RowMotion`, `_PanelIn`, `_FadeIn`, `_ConfirmSlide`, `BlurSwitchController` deleted |
| `menu.dart` + `context_menu`, `dropdown_menu`, `menubar`, `agent_attach_menu` | `MenuMotion` deleted; menus play `OpenTransition` |
| `dialog`, `alert_dialog`, `popover`, `tooltip`, `hover_card`, `combobox`, `select`, `collapsible`, `accordion`, `checkbox`, `radio`, `questionnaire`, `selection_control`, `input_otp`, `skeleton`, `spinner`, `progress`, `icon_swap`, `active_indicator`, `sidebar`, `slider`, `attachment`, `agent_attachments`, `agent_launcher`, `toaster` | migrated call sites (Task 5) |
| `agent_avatar.dart` (`AgentCubeMotion`), `chart.dart` (`ChartMotion`), `sheet.dart` (`SheetTransition`), `drawer.dart` (`_DrawerTransition` + vaul curve) | unchanged, documented as component-owned |
| `test/motion_test.dart`, `test/foundation_type_motion_test.dart`, `test/token_guard_test.dart` | assert the fourteen, the pruned scale, and the retired names' absence |
| `example/lib/components_docs/keyframes/page.dart`, `press/page.dart`, `content_change/page.dart` | the fourteen on the UI each animates; one press |
| `lib/elattar_design_system.dart` | exports `open_transition.dart`; nothing retired is exported |
| `registry/component_inventory.json`, `registry/generated/**` | `keyframes` owns `keyframes.dart` + `open_transition.dart`; rebuilt |
| `docs/references/motion-rename.md` | **new** — the before/after table |
| `CHANGELOG.md` | entry |
| web: `lib/motion-names.ts`, `docs/contracts/flutter-web-foundation-parity.md` | new Flutter symbols |

---

### Task 1: The contract — tests go RED

**Files:**
- Modify: `test/motion_test.dart` (add a `group('the fourteen')` and a retired-name sweep; leave the old groups for Task 4 to delete)
- Modify: `test/foundation_type_motion_test.dart:600-620` (the `MotionDurations` pins)

**Interfaces:**
- Produces: `kRetiredMotionSymbols` (test-side list) that every later task keeps green.

- [ ] **Step 1: Add the retired-symbol sweep to `test/motion_test.dart`**

At the top of the file, after the imports:

```dart
/// Retired 2026-09-22 with the fourteen. A symbol here may appear only in
/// CHANGELOG.md and docs/references/motion-rename.md.
const List<String> kRetiredMotionSymbols = <String>[
  'EntranceMotion', 'SpringEntranceMotion', 'StateChangeMotion',
  'DiscreteProgressMotion', 'TextRevealMotion', 'TextRevealFrame',
  'RevealMotion', 'LoadingShimmerMotion', 'LivePulseMotion', 'SweepMotion',
  'TravelMotion', 'CheckmarkDrawMotion', 'DashDrawMotion', 'DotSelectionMotion',
  'ContentSwapMotion', 'FadeUp', 'RowMotion', 'MenuMotion', 'InteractiveCard',
  '_PanelIn', '_FadeIn', '_ConfirmSlide', 'BlurSwitchController',
  'MotionDurations.reward', 'MotionDurations.popIn', 'MotionDurations.springUp',
  'MotionDurations.signOn', 'MotionDurations.ratchet', 'MotionDurations.checkDraw',
  'MotionDurations.dashDraw', 'MotionDurations.dotPop', 'MotionDurations.pressSpringUp',
  'MotionDurations.copyConfirmation', 'MotionDurations.liftY', 'MotionDurations.keyDownY',
  'MotionDurations.frame', 'MotionDurations.overlayExit', 'MotionDurations.close',
  'MotionDurations.collapse',
  'MotionTransforms.clickSpringScale', 'MotionTransforms.pressSpringScale',
  'MotionTransforms.buttonPress', 'MotionTransforms.sliderThumbHoverScale',
  'MotionTransforms.sliderThumbActiveScale', 'MotionTransforms.liftY',
  'MotionTransforms.keyDownY',
  'MotionCurves.balanced', 'MotionCurves.decelerate', 'MotionCurves.symmetric',
  'MotionCurves.linear', 'MotionCurves.vaul',
  'yuki-', 'pulls-', 'globals.css L',
];
```

And a group at the end of `main()`:

```dart
  group('the fourteen', () {
    final List<File> sources = <Directory>[
      Directory('lib'),
      Directory('example/lib'),
      Directory('test'),
    ]
        .expand((Directory d) => d.listSync(recursive: true))
        .whereType<File>()
        .where((File f) => f.path.endsWith('.dart'))
        .where((File f) => !f.path.endsWith('motion_test.dart'))
        .toList();

    test('no source names a retired motion symbol', () {
      final List<String> hits = <String>[];
      for (final File f in sources) {
        final String text = f.readAsStringSync();
        for (final String s in kRetiredMotionSymbols) {
          if (text.contains(s)) hits.add('${f.path}: $s');
        }
      }
      expect(hits, isEmpty, reason: hits.join('\n'));
    });

    test('keyframes.dart declares exactly the twelve recipes', () {
      final String text = File('lib/src/components/ui/keyframes.dart').readAsStringSync();
      final Iterable<String> declared = RegExp(r'^class (\w+Motion) ', multiLine: true)
          .allMatches(text)
          .map((RegExpMatch m) => m.group(1)!);
      expect(declared.toSet(), <String>{
        'EnterMotion', 'ExitMotion', 'OpenMotion', 'CloseMotion', 'ExpandMotion',
        'ChangeMotion', 'SpinMotion', 'ShimmerMotion', 'ProgressMotion',
        'PulseMotion', 'CaretMotion', 'SwapRollMotion',
      });
    });

    test('the press scale is 0.9 and there is only one', () {
      expect(MotionTransforms.press, 0.9);
    });
  });
```

Add `import 'dart:io';` if the file lacks it.

- [ ] **Step 2: Pin the pruned duration scale in `test/foundation_type_motion_test.dart`**

Find the block that pins `MotionDurations.tick … reward` (around line 603). Remove the `reward` line and add, right after the `open` line:

```dart
      expect(MotionDurations.bloom, const Duration(milliseconds: 1000));
      // The scale is seven steps. `close`, `collapse`, `overlayExit` were
      // aliases of `normal` / `overlayEnter` and are read as those now.
```

- [ ] **Step 3: Run and confirm RED for the right reasons**

Run: `flutter test test/motion_test.dart test/foundation_type_motion_test.dart`
Expected: `no source names a retired motion symbol` FAILS with hundreds of hits; `declares exactly the twelve recipes` FAILS (it finds the old fifteen); `press scale` FAILS (0.94). Everything else still passes.

- [ ] **Step 4: Commit**

```bash
git add test/motion_test.dart test/foundation_type_motion_test.dart
git commit -m "motion: declare the fourteen-name vocabulary (tests RED)"
```

---

### Task 2: Prune the foundation — `motion.dart`

**Files:**
- Modify: `lib/src/design_system/foundation/motion.dart`
- Modify: `test/token_guard_test.dart:20-40` (`_exemptDirs` gains `lib/src/components/ui/open_transition.dart` — it will hold the open/close stop tables — and nothing else)

**Interfaces:**
- Produces: `MotionDurations` with exactly these members — scale: `tick, fast, normal, slow, overlayEnter, open, bloom`; per-loop/surface: `stateChange, spin, caret, shimmer, shimmerText, pulseLive, pressIn, pressOut, beatHover, beatPress, foilDrift, glint, glintHover, cosmicDriftDeep, cosmicDriftNear, sway, swayAlt, expand`; behaviour timers unchanged: `drawerOpen, drawerClose, tooltipShowDelay, hoverCardShowDelay, hoverCardHideDelay, menuSubOpenDelay, menuTypeaheadReset, navigationMenuOpenDelay, navigationMenuCloseDelay, navigationMenuSkipDelay, scrollAreaHideDelay, selectAutoScrollTick, toastLifetime, toastUnmountDelay, toastTransition, toastCollapsedExitTransform, toastSwipeOutDuration, toastPromiseSwapIn, attachmentStatusShimmer, attachmentSaving`. `MotionTransforms.press = 0.9`, `MotionTransforms.swapRollTravel` kept. `MotionCurves`: `emphasized, enter, exit, move, settle, standard, outFlex` and `all`.

- [ ] **Step 1: Delete the retired durations**

Remove the declarations (and their doc comments) for `reward`, `popIn`, `springUp`, `signOn`, `ratchet`, `checkDraw`, `dashDraw`, `dotPop`, `pressSpringUp`, `copyConfirmation`, `frame`, `overlayExit`, `close`, `collapse`. Keep `expand` (420ms — it is `open`'s value but disclosure is timed independently on web too: `anim-expand` reads `--duration-open`; keep the alias so a retune of one does not silently retune the other) — actually **no**: web reads `--duration-open` for expand. Delete `expand` too and read `open` at the call site. Keep `liftY`/`keyDownY` deletion in `MotionTransforms` (Step 2).

- [ ] **Step 2: One press scale**

Replace the whole `class MotionTransforms { … }` body with:

```dart
class MotionTransforms {
  const MotionTransforms._();

  /// The one click feel: anything pressed shrinks to this and springs back.
  /// Web: `@utility press { &:active { transform: scale(0.9) } }`.
  static const double press = 0.9;

  /// `swap-roll` — the IconSwap wheel moves each icon this fraction of its
  /// own height per step.
  static const double swapRollTravel = 1.6;
}
```

(Check `swapRollTravel`'s current value before writing — copy it, do not retype.)

- [ ] **Step 3: Seven curves**

Delete `balanced`, `decelerate`, `symmetric`, `linear`, `vaul` from `MotionCurves` and from its `all` list. Move `vaul`'s `Cubic` literal into `lib/src/components/ui/drawer.dart` as a private `const Cubic _vaulCurve = …` with a one-line comment ("vaul's own curve; the drawer is a third-party feel, not vocabulary") — `drawer.dart` must then be added to `_exemptDirs` in `test/token_guard_test.dart` for that literal. Where `MotionCurves.linear` was used, write `Curves.linear`.

- [ ] **Step 4: Rewrite the file's doc comments**

Every comment that cites `globals.css L…`, `--duration-base`, `yuki-*`, "the reference", "probed on the live reference" is replaced by a sentence that describes the Flutter constant on its own terms. Keep the *why* where there is one (e.g. why `open` is longer than `overlayEnter`). The file header becomes:

```dart
/// The motion scale. Seven steps for everything that arrives, leaves, opens
/// or presses; one constant per looping animation and per surface; and the
/// behaviour timers (delays, lifetimes, tick intervals) that are not
/// animations at all. Mirrors `styles/motion.css` in the web design system —
/// same names, same numbers.
```

- [ ] **Step 5: Analyze, expect call-site errors, commit anyway**

Run: `flutter analyze`
Expected: errors ONLY of the form `The getter 'X' isn't defined for the type 'MotionDurations'` / `'MotionTransforms'` / `'MotionCurves'` in component files — those are Task 4/5's. Record the count in the commit body. No other error class.

```bash
git add lib/src/design_system/foundation/motion.dart lib/src/components/ui/drawer.dart test/token_guard_test.dart
git commit -m "motion: prune the scale to the seven steps, one press, seven curves"
```

---

### Task 3: `OpenTransition` becomes the one overlay motion

**Files:**
- Create: `lib/src/components/ui/open_transition.dart`
- Modify: `lib/src/components/ui/dialog.dart:585-700` (cut `OpenTransition` out; import the new file)
- Modify: `lib/elattar_design_system.dart` (export `open_transition.dart` after `keyframes.dart`)
- Modify: `registry/component_inventory.json` (`keyframes` owner also lists `lib/src/components/ui/open_transition.dart`)

**Interfaces:**
- Produces:
  ```dart
  class OpenTransition extends StatelessWidget {
    const OpenTransition({super.key, required this.animation, required this.child});
    final Animation<double> animation; // 0→1 opening, driven in reverse to close
    final Widget child;
  }
  ```
  playing `OpenMotion` stops forward and `CloseMotion` stops when `animation.status` is reversing. Also `OpenMotion` / `CloseMotion` recipe classes (their stop tables), placed in `keyframes.dart` by Task 4 — until then `open_transition.dart` keeps the tables it moved.

- [ ] **Step 1: Move the class verbatim**

Cut from `dialog.dart` everything from `/* ── The jelly ─── */` through the end of `class OpenTransition` (and any private helper it uses — `_inBreak`, `_outBreak`, `_inScale`, `_inShift`, `_outScale`, `_outShift`, the builder). Paste into the new file with this header:

```dart
/// The overlay entrance and exit — web's `anim-open` / `anim-close`.
///
/// One widget, every overlay: dialog, alert dialog, popover, tooltip, hover
/// card, menu, combobox, select. Forward it plays [OpenMotion] (scale 0.92 →
/// 1.02 → 1 with a 24 → −4 → 0 rise, on `emphasized` over `open`); reversed it
/// plays [CloseMotion] (1 → 1.01 → 0.94, 0 → −4 → 16, on `move` over
/// `normal`). Leaving never takes as long as arriving.
///
/// The sheet and the drawer do NOT use this: a panel that belongs to an edge
/// slides from it (`sheet.dart`, `drawer.dart`), which is component-owned
/// motion, not vocabulary.
library;
```

`dialog.dart` imports `'open_transition.dart'` and keeps using `OpenTransition` exactly as before.

- [ ] **Step 2: Export and register**

`lib/elattar_design_system.dart`: add `export './src/components/ui/open_transition.dart';` directly under the `keyframes.dart` export. `registry/component_inventory.json`: under the entry whose `"owner": "keyframes"` add a sibling entry for `open_transition.dart` with the same owner (copy the shape of the existing entry).

- [ ] **Step 3: Verify**

Run: `flutter analyze lib/src/components/ui/dialog.dart lib/src/components/ui/open_transition.dart` → clean (apart from Task 2's pending getter errors elsewhere).
Run: `flutter test test/dialogs_test.dart` → PASS.

```bash
git add lib/src/components/ui/open_transition.dart lib/src/components/ui/dialog.dart lib/elattar_design_system.dart registry/component_inventory.json
git commit -m "motion: OpenTransition is the one overlay motion, in its own file"
```

---

### Task 4: Rewrite `keyframes.dart` to the twelve recipes

**Files:**
- Modify: `lib/src/components/ui/keyframes.dart` (keep §A `StepCurve`, `KeyframeStop`, `Keyframes`, `_LerpTween`, `KeyframeFill`, `KeyframePlayer`; replace everything after with the twelve)
- Modify: `lib/src/components/ui/open_transition.dart` (its stop tables move into `OpenMotion` / `CloseMotion` and it reads them from there)
- Modify: `test/motion_test.dart` (delete the `the finite keyframe tables`, `yuki-sign-on`, `pulls-shimmer`, `travel chip` groups; add one test per recipe below)

**Interfaces:**
- Produces, all in `keyframes.dart`, each a `const X._()` class with `static const Duration duration`, `static const Curve curve`, `static const KeyframeFill fill` and typed `Animatable`s:

```dart
/// anim-enter — 12px rise + fade + 0.97 scale, `slow` on `enter`.
class EnterMotion {
  const EnterMotion._();
  static const Duration duration = MotionDurations.slow;
  static const Curve curve = MotionCurves.enter;
  static const KeyframeFill fill = KeyframeFill.both;
  static const double rise = 12;
  static const double fromScale = 0.97;
  /// Stagger step for lists: half a tick per row (web `--enter-stage`).
  static Duration delayFor(int stage) => MotionDurations.tick * stage ~/ 2;
  static final Animatable<double> opacity = Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: curve));
  static final Animatable<double> translateY = Tween<double>(begin: rise, end: 0).chain(CurveTween(curve: curve));
  static final Animatable<double> scale = Tween<double>(begin: fromScale, end: 1).chain(CurveTween(curve: curve));
}

/// anim-exit — 6px drop + fade + 0.98, `fast` on `exit`.
class ExitMotion {
  const ExitMotion._();
  static const Duration duration = MotionDurations.fast;
  static const Curve curve = MotionCurves.exit;
  static const KeyframeFill fill = KeyframeFill.both;
  static const double drop = 6;
  static const double toScale = 0.98;
  static final Animatable<double> opacity = Tween<double>(begin: 1, end: 0).chain(CurveTween(curve: curve));
  static final Animatable<double> translateY = Tween<double>(begin: 0, end: drop).chain(CurveTween(curve: curve));
  static final Animatable<double> scale = Tween<double>(begin: 1, end: toScale).chain(CurveTween(curve: curve));
}

/// anim-open — the overlay entrance. Stops copied from OpenTransition.
class OpenMotion {
  const OpenMotion._();
  static const Duration duration = MotionDurations.open;
  static const Curve curve = MotionCurves.emphasized;
  static const KeyframeFill fill = KeyframeFill.both;
  static const List<KeyframeStop<double>> opacityStops = <KeyframeStop<double>>[KeyframeStop(0, 0), KeyframeStop(60, 1)];
  static const List<KeyframeStop<double>> scaleStops = <KeyframeStop<double>>[KeyframeStop(0, 0.92), KeyframeStop(60, 1.02), KeyframeStop(100, 1)];
  static const List<KeyframeStop<double>> translateYStops = <KeyframeStop<double>>[KeyframeStop(0, 24), KeyframeStop(60, -4), KeyframeStop(100, 0)];
  static final Animatable<double> opacity = Keyframes.doubles(opacityStops, curve: curve);
  static final Animatable<double> scale = Keyframes.doubles(scaleStops, curve: curve);
  static final Animatable<double> translateY = Keyframes.doubles(translateYStops, curve: curve);
}

/// anim-close — the overlay exit. Anticipates up 4, drops 16, fades.
class CloseMotion {
  const CloseMotion._();
  static const Duration duration = MotionDurations.normal;
  static const Curve curve = MotionCurves.move;
  static const KeyframeFill fill = KeyframeFill.both;
  static const List<KeyframeStop<double>> opacityStops = <KeyframeStop<double>>[KeyframeStop(0, 1), KeyframeStop(30, 1), KeyframeStop(100, 0)];
  static const List<KeyframeStop<double>> scaleStops = <KeyframeStop<double>>[KeyframeStop(0, 1), KeyframeStop(30, 1.01), KeyframeStop(100, 0.94)];
  static const List<KeyframeStop<double>> translateYStops = <KeyframeStop<double>>[KeyframeStop(0, 0), KeyframeStop(30, -4), KeyframeStop(100, 16)];
  static final Animatable<double> opacity = Keyframes.doubles(opacityStops, curve: curve);
  static final Animatable<double> scale = Keyframes.doubles(scaleStops, curve: curve);
  static final Animatable<double> translateY = Keyframes.doubles(translateYStops, curve: curve);
}

/// anim-expand / anim-collapse — disclosure on height. One controller: forward
/// on `open` / `emphasized`, reverse on `normal` / `move`.
class ExpandMotion {
  const ExpandMotion._();
  static const Duration duration = MotionDurations.open;
  static const Curve curve = MotionCurves.emphasized;
  static const Duration collapseDuration = MotionDurations.normal;
  static const Curve collapseCurve = MotionCurves.move;
}

/// anim-change — squash-and-stretch in place. Stops are StateChangeMotion's.
class ChangeMotion { /* duration stateChange, curve enter, fill both, scaleStops as before */ }

/// anim-spin — one full turn, linear, forever.
class SpinMotion {
  const SpinMotion._();
  static const Duration duration = MotionDurations.spin;
  static const Curve curve = Curves.linear;
  static const KeyframeFill fill = KeyframeFill.none;
  static const bool loops = true;
}

/// anim-shimmer / anim-shimmer-text — LoadingShimmerMotion's body, renamed;
/// `textDuration` is the text variant's slower period.
class ShimmerMotion { /* as LoadingShimmerMotion + static const Duration textDuration = MotionDurations.shimmerText; */ }

/// anim-progress-indeterminate — a third-width sliver, −100% → 300%, linear.
class ProgressMotion {
  const ProgressMotion._();
  static const Duration duration = MotionDurations.shimmer; // web literal 1.4s == shimmer
  static const Curve curve = Curves.linear;
  static const bool loops = true;
  static const double sliverFraction = 1 / 3;
  static const double fromFraction = -1;
  static const double toFraction = 3;
}

/// anim-pulse — LivePulseMotion's body, renamed.
class PulseMotion { /* as LivePulseMotion */ }

/// anim-caret — on for half the period, off for half. steps(1, end).
class CaretMotion {
  const CaretMotion._();
  static const Duration duration = MotionDurations.caret;
  static const bool loops = true;
  static bool visibleAt(double t) => t < 0.5;
}

/// swap-roll — ContentSwapMotion's body, renamed.
class SwapRollMotion { /* as ContentSwapMotion */ }
```

- [ ] **Step 1: Replace the recipe section**

Delete every class after `KeyframePlayer`'s state class. Add the twelve above, copying stop tables verbatim from the classes they replace where the interface block says "as before". `OpenMotion` / `CloseMotion` tables come from `open_transition.dart`'s `_inScale/_inShift/_outScale/_outShift` + breaks; then rewrite `OpenTransition` to read `OpenMotion.*` / `CloseMotion.*` and delete its private tables.

- [ ] **Step 2: Rewrite the file header**

Replace the library doc comment (everything before `library;`) with:

```dart
/// The twelve motion recipes — the design system's whole animation
/// vocabulary on Flutter, mirroring `styles/motion.css` on the web:
///
///   EnterMotion · ExitMotion        content arriving / leaving in place
///   OpenMotion · CloseMotion        an overlay arriving / leaving
///   ExpandMotion                    disclosure on height (reverse = collapse)
///   ChangeMotion                    "this value just changed"
///   SpinMotion · ShimmerMotion · ProgressMotion · PulseMotion · CaretMotion
///                                   the loops: the signal nothing has stalled
///   SwapRollMotion                  the IconSwap wheel
///
/// Plus `Press` (press.dart) and `ActiveIndicator` (active_indicator.dart) —
/// the two transitions — which makes fourteen. A recipe is data: duration,
/// curve, fill and stop tables. A component plays it through [KeyframePlayer]
/// or its own controller. Adding a thirteenth recipe is a design decision,
/// not a convenience.
///
/// Three mechanics decide everything here: a timing function eases between
/// adjacent stops, not across the run ([Keyframes.track] is a
/// [TweenSequence] with one curved item per gap); a property declared at some
/// stops and not others holds ([ConstantTween] tails); and [KeyframeFill]
/// decides what reduced motion freezes to — `both` holds the last stop, a
/// loop with no fill reverts to rest.
```

- [ ] **Step 3: Tests**

In `test/motion_test.dart` delete the retired groups named in Files. Add under `group('the fourteen')`:

```dart
    test('EnterMotion rises 12 and fades in over slow on enter', () {
      expect(EnterMotion.duration, MotionDurations.slow);
      expect(EnterMotion.translateY.transform(0), 12);
      expect(EnterMotion.translateY.transform(1), 0);
      expect(EnterMotion.opacity.transform(1), 1);
      expect(EnterMotion.delayFor(2), MotionDurations.tick);
    });
    test('ExitMotion is faster than EnterMotion', () {
      expect(ExitMotion.duration < EnterMotion.duration, isTrue);
      expect(ExitMotion.opacity.transform(1), 0);
    });
    test('OpenMotion overshoots to 1.02 at 60% and CloseMotion drops 16', () {
      expect(OpenMotion.scale.transform(0.6), closeTo(1.02, 1e-9));
      expect(CloseMotion.translateY.transform(1), 16);
      expect(CloseMotion.duration < OpenMotion.duration, isTrue);
    });
    test('ChangeMotion squashes to 1.18×0.82 at 30%', () {
      expect(ChangeMotion.scale.transform(0.3), const Offset(1.18, 0.82));
    });
    test('CaretMotion is a hard blink', () {
      expect(CaretMotion.visibleAt(0.49), isTrue);
      expect(CaretMotion.visibleAt(0.5), isFalse);
    });
    test('ProgressMotion sweeps a third-width sliver off both edges', () {
      expect(ProgressMotion.fromFraction, -1);
      expect(ProgressMotion.toFraction, 3);
    });
```

- [ ] **Step 4: Verify**

Run: `flutter test test/motion_test.dart -n "the fourteen"` — the `declares exactly the twelve recipes` and the six new tests PASS; `no source names a retired motion symbol` still FAILS (call sites, Task 5).
Run: `flutter analyze lib/src/components/ui/keyframes.dart lib/src/components/ui/open_transition.dart` — clean.

```bash
git add lib/src/components/ui/keyframes.dart lib/src/components/ui/open_transition.dart test/motion_test.dart
git commit -m "motion: keyframes.dart holds the twelve recipes and nothing else"
```

---

### Task 5: Migrate every call site

**Files (all under `lib/src/components/ui/` unless noted):**
- `press.dart` — remove the `scale` parameter; `_PressState` uses `MotionTransforms.press`; `upDuration` default stays `pressOut`
- `button.dart`, `slider.dart`, `toggle.dart`, `bubble.dart`, `kbd.dart`, `breadcrumb.dart`, `input_group.dart`, `navigation_menu.dart`, `accordion.dart`, `action_feedback.dart`, `spinner.dart`, `toaster.dart`, `icon_swap.dart`, `active_indicator.dart` — drop any `scale:` argument to `Press`; `slider.dart`'s thumb hover/active scales become plain `Press`
- `hover_builder.dart` — delete `InteractiveCard`; its one consumer (grep `InteractiveCard(`) becomes `HoverBuilder` + `Press`
- `agent_transcript.dart` — delete `FadeUp`; play `EnterMotion` through `KeyframePlayer`; `EntranceMotion`/`SpringEntranceMotion` uses → `EnterMotion`; `LivePulseMotion` → `PulseMotion`
- `agent_history.dart` — delete `RowMotion`, `_PanelIn`, `_FadeIn`, `_ConfirmSlide`; rows play `EnterMotion` with `EnterMotion.delayFor(index + 2)` and `ExitMotion` on leave; the panel and its scrim play `EnterMotion` with `rise: 0` (add an optional `rise` override to the player call, not to the recipe) — accept that a removed row no longer collapses its own gap, as web did
- `agent_core.dart` — delete `BlurSwitchController`; the transcript swap plays `ExitMotion` then `EnterMotion`
- `agent_face.dart` — `LoadingShimmerMotion` → `ShimmerMotion` with `ShimmerMotion.textDuration`
- `skeleton.dart` — `ShimmerMotion`
- `checkbox.dart`, `radio.dart`, `questionnaire.dart`, `selection_control.dart` — `CheckmarkDrawMotion` / `DashDrawMotion` / `DotSelectionMotion` → the indicator plays `ChangeMotion` on mount (delete the dash-draw painters' offset animation; the tick is painted whole)
- `input_otp.dart` — `TextRevealMotion` → `CaretMotion` (`visibleAt`)
- `spinner.dart` — `SpinMotion`
- `progress.dart` — indeterminate branch plays `ProgressMotion`
- `icon_swap.dart` — `ContentSwapMotion` → `SwapRollMotion`, `StateChangeMotion` → `ChangeMotion`
- `active_indicator.dart`, `sidebar.dart` — `StateChangeMotion` → `ChangeMotion`
- `collapsible.dart`, `accordion.dart` — `MotionDurations.expand/collapse` → `ExpandMotion.duration / collapseDuration`, curves from `ExpandMotion`
- `dialog.dart`, `alert_dialog.dart` — `MotionDurations.close` → `CloseMotion.duration`
- `popover.dart`, `tooltip.dart`, `hover_card.dart`, `combobox.dart`, `select.dart` — delete `_PopoverTransition`, `_TooltipTransition`, `_HoverCardTransition` (and select/combobox's equivalents); wrap content in `OpenTransition(animation: controller, child: …)` with the controller on `OpenMotion.duration` / `reverseDuration: CloseMotion.duration`
- `menu.dart` (+ `context_menu`, `dropdown_menu`, `menubar`, `agent_attach_menu`) — delete `MenuMotion`; menus use `OpenTransition` the same way
- `attachment.dart`, `agent_attachments.dart`, `agent_launcher.dart` — already use `OpenTransition`; update the import to `open_transition.dart`
- `drawer.dart` — `MotionCurves.vaul` → `_vaulCurve` (Task 2 placed it)
- every file — comment sweep: `yuki-*`, `pulls-*`, `globals.css L…`, "the reference" → describe the Flutter code

- [ ] **Step 1: Mechanical rename first**

Run from the repo root (Git Bash):

```bash
grep -rl "EntranceMotion\|SpringEntranceMotion\|StateChangeMotion\|LoadingShimmerMotion\|LivePulseMotion\|ContentSwapMotion\|CheckmarkDrawMotion\|DashDrawMotion\|DotSelectionMotion" lib example/lib --include=*.dart \
 | xargs sed -i -e 's/\bSpringEntranceMotion\b/EnterMotion/g' -e 's/\bEntranceMotion\b/EnterMotion/g' -e 's/\bStateChangeMotion\b/ChangeMotion/g' -e 's/\bLoadingShimmerMotion\b/ShimmerMotion/g' -e 's/\bLivePulseMotion\b/PulseMotion/g' -e 's/\bContentSwapMotion\b/SwapRollMotion/g' -e 's/\bCheckmarkDrawMotion\b/ChangeMotion/g' -e 's/\bDashDrawMotion\b/ChangeMotion/g' -e 's/\bDotSelectionMotion\b/ChangeMotion/g'
```

Then `flutter analyze` and fix by hand every remaining error — the list above says what each file becomes. Do NOT grep-replace duration/transform members; each one is a judgment (`MotionDurations.close` → `CloseMotion.duration`, `popIn` → `EnterMotion.duration`, etc.).

- [ ] **Step 2: The hand work, file by file, in the order listed in Files**

For each file: make the change, run `flutter analyze <file>`, run the test that covers it (`test/motion_test.dart` for press/indicator/icon-swap, `test/dialogs_test.dart` for overlays, `test/menus_test.dart`, `test/inputs_test.dart` for checkbox/radio/otp, `test/agent_*_test.dart` for the console, `test/feedback_effects_test.dart` for skeleton/spinner/progress). Fix tests that asserted a retired name or the 0.94 scale — assert the new name / 0.9 instead; never delete an assertion without replacing it.

- [ ] **Step 3: Comment sweep**

Run: `grep -rn "yuki-\|pulls-\|globals.css L\|the reference" lib example/lib --include=*.dart | wc -l` and drive it to 0. A comment that only exists to cite the reference is deleted; one that explains a decision keeps the decision and loses the citation.

- [ ] **Step 4: Full verification**

Run: `flutter analyze` → No issues.
Run: `flutter test` → all pass, including `no source names a retired motion symbol`.

```bash
git add -A lib test
git commit -m "motion: migrate every component to the fourteen"
```

---

### Task 6: The docs — keyframes, press, content-change pages

**Files:**
- Rewrite: `example/lib/components_docs/keyframes/page.dart` (1440 lines → the fourteen, each on the UI it animates, one Replay per card, one Replay all; copy from the web page `components/docs/page/fourteen-motions.tsx` in the design-system repo — same subjects, same one-line "what it is for" copy)
- Rewrite: `example/lib/components_docs/press/page.dart` (one `Press` on a Button, a Badge, a row and a Card; remove the four-variant specimen)
- Modify: `example/lib/components_docs/content_change/page.dart` (one entrance, `EnterMotion`)
- Modify: `example/lib/components_docs/*/meta.dart` files that name a retired motion
- Modify: `example/lib/docs_pages/*` only if they name a retired motion (grep)

- [ ] **Step 1: keyframes page**

Fourteen `DocsShowcase` cards in this order: enter (four staggered rows), exit (rows, second leaves on Replay and returns), open (dialog on scrim), close (same, leaves on Replay), expand (accordion), change (`$1,240` ↔ `$2,480`), spin (`Spinner`), shimmer (`Skeleton` ×3), progress (`Progress()` with no value), pulse (live dot), caret (four OTP boxes), press (`Button` with a simulated press: set the pressed state for 700ms), toggle-slide (`ActiveIndicator` between "Inbox"/"Sent"), swap-roll (`IconSwap` heart ↔ star). Each card: name as code, the stage, one sentence — use the web page's sentences verbatim. A `ValueNotifier<int>` bumped by Replay all that every card's `KeyframePlayer` keys on.

- [ ] **Step 2: press page**

Delete the specimens for the retired variants. Keep the keyboard-press demo (it asserts `[data-pressed]`-equivalent behaviour: `Press` responds to Space/Enter). Copy: "One class, press. Anything clickable shrinks to 90% the instant you press it and springs back when you let go."

- [ ] **Step 3: Verify**

Run: `flutter analyze example` → clean. Run: `cd example && flutter test` → pass. Run: `dart run skills/elattar-flutter-ui-director/scripts/check_ui_completeness.dart` → pass. Launch the example (`cd example && flutter run -d chrome`) and open `/components/keyframes` and `/components/press`; every card replays. Record what you saw in the report; a screenshot if the harness allows.

```bash
git add example
git commit -m "docs: the fourteen on the UI each one animates; one press"
```

---

### Task 7: Records, registry, changelog

**Files:**
- Create: `docs/references/motion-rename.md`
- Modify: `CHANGELOG.md`
- Modify: `skills/elattar-flutter-ui-director/references/system-map.md` (motion row names the twelve recipes + Press + ActiveIndicator)
- Regenerate: `registry/generated/**` via `dart run tool/registry_builder/bin/build.dart .` then `dart run tool/registry_builder/bin/validate.dart registry/generated/latest/registry.json`

- [ ] **Step 1: The rename record**

```markdown
# Motion rename record — 2026-09-22, the fourteen

Mirrors the web design system's `docs/references/motion-rename.md`.

| Retired | Now |
|---|---|
| EntranceMotion, SpringEntranceMotion, FadeUp, RowMotion, _PanelIn, _FadeIn, _ConfirmSlide | EnterMotion |
| BlurSwitchController (exit half), RowMotion (leave) | ExitMotion |
| every overlay's private transition, MenuMotion | OpenMotion / CloseMotion via OpenTransition |
| collapsible/accordion's own durations | ExpandMotion |
| StateChangeMotion, CheckmarkDrawMotion, DashDrawMotion, DotSelectionMotion | ChangeMotion |
| spinner's own, DiscreteProgressMotion | SpinMotion |
| LoadingShimmerMotion, AgentStatusText's sweep | ShimmerMotion |
| progress's own | ProgressMotion |
| LivePulseMotion | PulseMotion |
| TextRevealMotion (OTP) | CaretMotion |
| Press (0.94), InteractiveCard, clickSpringScale, pressSpringScale, buttonPress, slider thumb scales, liftY, keyDownY | Press (0.9) |
| ContentSwapMotion | SwapRollMotion |
| RevealMotion, SweepMotion, TravelMotion, TextRevealMotion's flicker | removed |
| MotionDurations reward, popIn, springUp, signOn, ratchet, checkDraw, dashDraw, dotPop, pressSpringUp, copyConfirmation, frame, overlayExit, close, collapse, expand | removed |
| MotionCurves balanced, decelerate, symmetric, linear, vaul | removed (vaul's curve lives in drawer.dart) |

Component-owned, not vocabulary: AgentCubeMotion (agent_avatar.dart), ChartMotion (chart.dart), SheetTransition (sheet.dart), the drawer's slide (drawer.dart).
```

- [ ] **Step 2: CHANGELOG** — under Unreleased: `### Changed — motion vocabulary is fourteen names` with the four bullets from the web CHANGELOG adapted to Flutter symbols. Mark the breaking API changes: `Press.scale` removed; the retired classes removed; `MotionDurations`/`MotionCurves` members removed.

- [ ] **Step 3: Registry** — run the two commands in Files; commit the regenerated output.

```bash
git add docs/references/motion-rename.md CHANGELOG.md skills registry
git commit -m "docs: record the fourteen-name motion vocabulary; rebuild the registry"
```

---

### Task 8: Web parity — the other repo

**Files (in `D:\DESIGN\Design-System-2026-8\design-system`):**
- Modify: `lib/motion-names.ts` — `flutter:` fields
- Modify: `docs/contracts/flutter-web-foundation-parity.md` — the same symbols
- Run: `FLUTTER_DS_ROOT="D:/DESIGN/Design-System-2026-8/flutter-design-system" node scripts/verify-flutter-symbols.mjs`

- [ ] **Step 1: New Flutter symbols in the map**

`MOTION_UTILITIES` and `MOTION_KEYFRAMES` `flutter:` values become: `anim-enter`/`ds-enter` → `EnterMotion`; `anim-exit`/`ds-exit` → `ExitMotion`; `anim-open`/`ds-open` → `OpenMotion`; `anim-close`/`ds-close` → `CloseMotion`; `anim-expand`/`ds-expand` → `ExpandMotion`; `anim-collapse` → `ExpandMotion (reversed)`; `anim-change`/`ds-change` → `ChangeMotion`; `anim-spin`/`ds-spin` → `SpinMotion`; `anim-shimmer`/`ds-shimmer` → `ShimmerMotion`; `anim-shimmer-text` → `ShimmerMotion (textDuration)`; `anim-progress-indeterminate`/`ds-progress-indeterminate` → `ProgressMotion`; `anim-pulse`/`ds-pulse` → `PulseMotion`; `anim-caret`/`ds-caret` → `CaretMotion`; `press` → `Press`; `toggle-slide` → `ActiveIndicator`; `swap-roll` → `SwapRollMotion`. Durations: remove the rows whose Flutter constants were retired; `--ease-*` unchanged.

- [ ] **Step 2: Parity doc** — same substitutions in §Motion; delete the "web-first until the Flutter port converges" sentence.

- [ ] **Step 3: Verify both repos**

Web: `FLUTTER_DS_ROOT=… npx vitest run test/foundation/motion-names.test.ts` → PASS (all 6). `npm run verify` → exit 0.
Flutter (worktree): `flutter analyze && flutter test` → clean.

Commit in the web repo: `motion: the parity map names the Flutter fourteen`. Push both.

---

## Self-review

**Spec coverage.** Fourteen names → Task 4 (twelve recipes) + Task 5 (`Press`, `ActiveIndicator`). Overlays on one motion → Tasks 3 and 5. Component-owned stays put → Global Constraints + Task 7 record. Durations/curves pruned → Task 2. Old-reference comments gone → Task 5 Step 3. Docs → Task 6. Registry → Task 7. Web coupling → Task 8. Dirty main → worktree in Global Constraints.

**Behaviour changes accepted (same as web):** checkbox tick pops instead of drawing; a removed history row no longer closes its own gap; the transcript switch is exit-then-enter rather than a blur; slider thumbs press at 0.9 like everything else; buttons squash to 0.9 with no popup-trigger exception.

**Type consistency.** `EnterMotion.delayFor(int)` returns `Duration`, used in Task 5 as `EnterMotion.delayFor(index + 2)`. `ExpandMotion.collapseDuration` / `collapseCurve` named identically in Tasks 4 and 5. `OpenTransition(animation:, child:)` signature unchanged from `dialog.dart` so its six existing consumers compile untouched. `kRetiredMotionSymbols` is test-side only.
