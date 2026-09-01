# Flutter Design System 0.0.2 Release-Readiness Recovery Plan

Date: 2026-09-01

Mode: repository mode

Status: ready for execution

## Objective

Take ownership of the current uncommitted `0.0.2` worktree, preserve the useful
typography, interaction, accessibility, responsive, registry, and documentation
changes already present, correct anything that is demonstrably broken, and
produce a trustworthy release-readiness verdict.

The work is complete only when the implementation, tests, current visual
evidence, audit ledger, documentation, registry payloads, and reported command
results all describe the same tree.

Do not commit, tag, push, publish, deploy, delete verification output, or move a
released reference without explicit owner approval.

## Current known state

- `main` remains at `3209094`; the release work is uncommitted.
- The package, CLI identity, and current registry identify `0.0.2`.
- Released `0.0.1` payloads currently have no tracked byte differences from the
  `v0.0.1` tag.
- The registry contains 94 new per-item `0.0.2` payload directories and retains
  five unchanged items at `0.0.1`.
- Target sizing source now appears to enforce a real 44 logical pixel minimum
  for Menu, Select, Combobox, Command, Toggle, and ToggleGroup.
- ScrollArea documents and tests a pointer-only thumb while retaining touch and
  keyboard scrolling on the viewport.
- New focused overlay, target-sizing, responsive, performance, and registry
  immutability tests exist but are untracked and are not reflected in the audit
  ledger's recorded suite counts.
- The responsive route test no longer skips any route and samples mobile,
  tablet, desktop, both themes, 100% and 200% text, and reduced motion.
- The audit ledger is stale: it still contains seven `open` cells, the obsolete
  18-page responsive deferral, a stale ButtonGroup statement, old test counts,
  and pending foundation rows.
- Existing rollout screenshots predate the 2026-09-01 changes. One recent dark
  desktop probe is not enough to satisfy the visual gate.
- The UI completeness scanner previously reported 398 findings that have not
  yet been fully classified.
- A recorded test-binding performance run reports the 500-item scrolling list
  at approximately 17.3 ms/frame. This requires an honest interpretation rather
  than an automatic pass/fail claim.

## Operating rules

1. Preserve every existing user and collaborator change. Never use destructive
   Git recovery commands.
2. Treat Flutter package source, public barrels, focused tests, and rendered
   output as authoritative. The old web implementation is lineage only.
3. Use existing components and foundation tokens. Do not hardcode replacement
   components or visual and motion literals.
4. Keep product and documentation composition outside
   `lib/src/components/ui/`. Change a package component only for a reusable
   contract defect.
5. Run focused checks while iterating. Run the complete expensive verification
   ladder once after the focused batches stabilize.
6. Read command exit codes from the command itself. Never infer success from
   `grep`, `tail`, `Tee-Object`, or another pipeline stage.
7. Do not turn a finding into `n/a`, an exclusion, or a suppression merely to
   make a count green. Every disposition needs a concrete reason.
8. Released `0.0.1` payload paths are immutable and must remain present,
   complete, and byte-identical.

## Workstream 1 — Freeze and inventory

- Record the starting commit, branch, package versions, registry versions, and
  current released-payload hashes.
- Inventory every modified, deleted, and untracked file at file level.
- Distinguish authored source, tests, docs, manifests, generated payloads,
  release locks, captures, build output, and unrelated pre-existing output.
- Inspect active Flutter, Dart, and shell processes. Stop only a process proven
  to belong to an abandoned verification run; do not interrupt another active
  task silently.
- Confirm repository mode through `lib/elattar_design_system.dart`.

Acceptance:

- The starting state can be reconstructed from the inventory.
- No existing work is discarded or overwritten.
- Flutter commands can run without an unexplained tool lock.

## Workstream 2 — Source-to-evidence map

Build a compact evidence map covering every affected public component and
foundation contract across these axes:

- typography;
- interaction and disabled behavior;
- keyboard and focus;
- overlay lifecycle and dismissal;
- semantics and accessible naming;
- 44 by 44 target sizing;
- responsive structure and 200% text;
- reduced motion and `TickerMode`;
- controller, listener, focus-node, and overlay disposal;
- visual behavior and performance;
- registry ownership and public API exposure.

Classify each applicable cell as:

- `verified`: named automated test or recorded current visual/performance
  evidence;
- `audited`: static inspection only;
- `n/a`: the behavior genuinely cannot apply;
- `open`: unresolved defect or missing evidence.

Shared-kernel evidence may cover multiple components only when each consumer is
confirmed to use the kernel without overriding the behavior being tested.

Acceptance:

- Every changed behavior maps to source, documentation, and evidence.
- No ledger status is copied forward without revalidation.

## Workstream 3 — Focused behavioral verification and repair

Run the focused suites before touching unrelated code:

- `test/interaction_kernel_test.dart`;
- `test/target_sizing_test.dart`;
- `test/scroll_area_platform_test.dart`;
- `test/tabs_keyboard_test.dart`;
- `test/select_combobox_keyboard_test.dart`;
- `test/overlay_lifecycle_test.dart`;
- `test/overlay_dialog_family_test.dart`;
- `test/overlay_menu_family_test.dart`;
- `test/overlay_popover_family_test.dart`;
- existing selection, menu, dialog, and disposal suites;
- `test/registry_released_immutability_test.dart`.

Verify specifically:

- Menu, Select, Combobox, and Command rows occupy at least 44 logical pixels in
  their real layout boxes and keep popup height, alignment, and scroll math in
  sync.
- ToggleGroup items meet the same minimum without overlapping invisible hit
  areas.
- ScrollArea remains usable by touch drag and keyboard without exposing its
  pointer-only thumb as an inaccessible semantic control.
- Tabs are one tab stop with documented arrow, Home, End, and RTL behavior.
- Dialog, AlertDialog, Sheet, Drawer, Menu, DropdownMenu, ContextMenu, Select,
  Combobox, Command, and Popover follow their documented focus, dismissal,
  restoration, semantics, disabled, and disposal contracts.
- Non-modal exceptions are explicit and tested rather than silently treated as
  modal or `n/a`.

Fix only reproducible defects. Prefer one shared-kernel correction over repeated
component patches.

Acceptance:

- All focused suites pass with their own exit code.
- Every remaining behavioral limitation is explicit and intentional.
- Released registry payloads remain untouched.

## Workstream 4 — Responsive documentation and text scaling

Validate every documentation and specimen route at:

- mobile: 390 by 844;
- tablet: 768 by 1024;
- desktop: 1440 by 900;
- light and dark themes;
- text scales 1.0 and 2.0;
- reduced motion for animated routes.

During iteration, use the two hardest corners and affected routes. At the final
gate, run the complete configured matrix once.

Fix documentation composition defects in `example/lib`, using native Flutter
responsive structures:

- rigid horizontal pairs become `Wrap` or a narrow `Column`;
- wide tables become a narrow card/list presentation where appropriate;
- fixed action footers wrap or stack;
- grids derive their column count from available width;
- charts receive explicit responsive constraints;
- sidebar specimens provide a narrow drawer or sheet representation;
- ButtonGroup and Pagination remain content-sized; their parent decides whether
  to scroll, wrap, or use another narrow composition.

Acceptance:

- Zero skipped routes.
- Zero pending responsive allowlists.
- No overflow, clipping, fallback error text, or unreachable action at the
  supported configurations.

## Workstream 5 — UI completeness scanner

Run:

```powershell
dart run skills/elattar-flutter-ui-director/scripts/check_ui_completeness.dart example/lib
```

Classify every finding:

- real defect: fix it;
- intentional inert documentation specimen: exclude the narrowest appropriate
  directory or line and record why;
- false positive: document the exact pattern and evidence;
- unresolved: keep it as a release blocker.

Pay particular attention to:

- dead presses;
- raw visual and motion literals;
- missing loading and empty states;
- unlabelled icon controls;
- leaked diagnostics or placeholder copy.

Acceptance:

- Every scanner finding is fixed or individually/scopingly justified.
- No blanket file suppression hides real product behavior.
- `test/token_guard_test.dart` remains green.

## Workstream 6 — Current visual review

Use `tool/verify/README.md` and create new post-change captures. Do not use the
August rollout images as proof for September changes.

Inspect at minimum:

- typography catalog;
- Button and ButtonGroup;
- Menu, Select, Combobox, and Command;
- Tabs and ToggleGroup;
- Dialog, AlertDialog, Popover, Sheet, and Drawer;
- tables and data-display specimens;
- charts;
- agent console;
- every route that previously failed at 200% text.

Capture representative narrow, tablet, and wide states in both themes. Inspect:

- font resolution;
- contrast and semantic ink;
- Flutter fallback error styling;
- focus rings;
- long and scaled text;
- clipping and overlap;
- scroll reachability;
- overlay placement and dismissal surfaces;
- reduced-motion behavior.

Acceptance:

- Current captures exist for both themes and narrow/wide widths, with tablet
  evidence where structure changes.
- Every inspected route and state is recorded.
- Visual and performance ledger cells are not marked verified from static code
  inspection alone.

## Workstream 7 — Performance

Run `test/performance_budget_test.dart` after functional behavior stabilizes.
Record test-binding limitations: it covers framework layout/paint behavior, not
device raster or GPU performance.

Investigate:

- animated painters;
- Spinner and other repeating motion;
- Cartesian charts;
- the 500-item scrolling list;
- opening and animating overlays.

Treat the approximately 17.3 ms/frame long-list measurement as a finding to
understand. Determine whether it is repeatable, dominated by test-binding
overhead, or caused by avoidable rebuilding. Do not weaken a budget merely to
obtain a pass.

Acceptance:

- Performance evidence is repeatable and scoped honestly.
- Any real regression is fixed or explicitly blocks release.
- No report claims raster/GPU performance from a widget-test measurement.

## Workstream 8 — Registry and distribution safety

Verify:

- every locked `0.0.1` path exists;
- every locked byte has its recorded SHA-256;
- no unexpected file appears in a released version directory;
- ordinary generation never deletes historical item/version directories;
- only the exact item/version being generated can be replaced;
- the 94-item `0.0.2` dependency closure is coherent;
- the five unchanged items remain pinned to `0.0.1` intentionally;
- root package, CLI identity, registry version, manifests, source links, and
  changelog agree;
- clean consumers can install mixed `0.0.1`/`0.0.2` dependencies over HTTP.

Acceptance:

- `git diff v0.0.1 -- registry/generated/latest/versions` reports no released
  payload drift.
- Immutability, registry builder, validator, staging, release audit, and clean
  consumer tests pass.
- No generated payload is edited manually.

## Workstream 9 — Reconcile documentation and ledger

Update the audit and public documentation after the implementation and evidence
are stable:

- remove the seven stale `open` cells only when the new evidence proves them;
- remove the obsolete 18-page deferral;
- correct ButtonGroup's stale scrolling claim;
- resolve or explain pending foundation rows;
- replace old root/example/tool suite counts;
- record the new overlay, target-sizing, responsive, performance, and registry
  tests;
- keep `verified`, `audited`, `n/a`, and `open` semantically distinct;
- update CLI, typeset, theming, component, changelog, and release documentation
  wherever public behavior changed.

Acceptance:

- The ledger contains zero unresolved findings.
- The ledger, changelog, generated registry, and current source agree.
- No documentation promises behavior that is absent or hides a known
  limitation.

## Workstream 10 — Final release gate

Run the expensive ladder once after every focused batch is stable. Preserve each
command's direct exit code and final summary.

```powershell
flutter analyze
flutter test

Push-Location example
flutter analyze
flutter test
flutter build web --release
Pop-Location

Push-Location packages/elattar_cli
dart analyze
dart test
Pop-Location
```

Also run:

- registry builder tests;
- registry validator;
- release audit tests and verifier;
- release registry staging tests for `0.0.1` and `0.0.2`;
- deploy-site tests;
- typography API surface tests;
- token guard;
- responsive route matrix;
- performance suite;
- UI completeness scanner;
- clean-consumer HTTP install, analyze, and run;
- formatting check;
- `git diff --check`;
- final file-level worktree accounting.

Do not pipe a test command into a reporting command when deciding whether it
passed.

Acceptance:

- Every required command exits successfully from the command itself.
- The test totals include all newly added tests.
- No skipped test hides a supported route or required behavior.
- The web release build is produced from the same verified tree.

## Final handoff

Report:

1. starting and ending worktree state;
2. defects fixed and why;
3. shared kernels changed;
4. responsive routes corrected;
5. scanner findings by disposition;
6. visual routes, states, widths, and themes inspected;
7. performance measurements and limitations;
8. exact test commands, exit codes, and totals;
9. registry hashes, version structure, and clean-consumer result;
10. remaining limitations and whether each blocks release;
11. exact authored/generated/output file accounting;
12. confirmation that nothing was committed, tagged, pushed, published,
    deployed, or deleted without approval.

## Definition of done

- Zero skipped responsive routes.
- Zero unresolved audit findings.
- Zero unexplained scanner findings.
- Current visual evidence exists in both themes at narrow and wide widths.
- Applicable interactive components satisfy keyboard, focus, semantics,
  disposal, responsive, reduced-motion, and 44 by 44 target contracts.
- Full analyzers, tests, build, registry, release, and consumer gates pass with
  trustworthy exit codes.
- `0.0.1` remains present and byte-identical.
- `0.0.2` versions, documentation, manifests, payloads, and public behavior are
  coherent.
- The final report describes the exact tree that was verified.

