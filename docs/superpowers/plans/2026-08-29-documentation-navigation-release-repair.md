# Documentation, Navigation, and Release Repair Plan

> **For Claude:** use `superpowers:executing-plans` when available. Work
> mechanically and economically: use `rg`, bounded file reads, one deterministic
> migration script for repetitive edits, focused tests while iterating, and the
> full verification ladder only once at the end. Do not spend tokens manually
> editing hundreds of equivalent path strings.

**Goal:** Make the public website, documentation, contributor instructions, and
release gates accurately describe the new unprefixed API and repository
structure. Split the documentation left sidebar into `Sections`, `Components`,
`Effects`, `Agent`, and `Charts` without changing existing component URLs.

**Baseline:** `main` at `931bff8` on 2026-08-29, repository mode. The Flutter
package, registry manifests, generated registry, and current public API are the
source of truth. Historical plans/reports are records, not current docs.

## Required outcome

| Sidebar group | Content | Order |
| --- | --- | ---: |
| `Sections` | Introduction, Components, Installation, Theming, CLI, Typeset, Registry, Changelog, Skills | 1 |
| `Components` | General controls, navigation, feedback, overlays, and data-display components | 2 |
| `Effects` | Reusable visual, interaction, and motion effects | 3 |
| `Agent` | Agent-family components plus Voice and Voice Indicator | 4 |
| `Charts` | Chart, Chart Cartesian, Chart Geometry, Chart Polar | 5 |

Keep every component route stable as `/components/<name>`. This is an
information-architecture change, not a URL migration.

### Explicit Effects membership

`action-feedback`, `active-indicator`, `ambient-pattern`, `background-effect`,
`content-change`, `feedback-surface`, `glass`, `hover-builder`, `icon-swap`,
`keyframes`, `media-scrim`, `premium-surface`, `press`, and `surface`.

Use **Effects**, not **Animations**: these APIs can be static, animated, or both,
so the category remains accurate when users replace their implementation. In
current public naming, Foil is `PremiumSurface`, Bloom Cosmic is
`FeedbackSurface`, and starfield-style ambient decoration is `AmbientPattern`.
Keep ordinary state components such as Skeleton, Spinner, and Progress under
Components; keep Voice Indicator under Agent.

### Explicit Agent membership

`agent-attach-menu`, `agent-attachments`, `agent-avatar`, `agent-composer`,
`agent-console`, `agent-core`, `agent-face`, `agent-history`, `agent-launcher`,
`agent-markdown`, `agent-slash-palette`, `agent-transcript`, `voice`, and
`voice-indicator`.

Generic conversation primitives such as Attachment, Bubble, Message,
MessageScroller, and Questionnaire remain under Components.

## Audit facts to close

| Finding | Current evidence |
| --- | ---: |
| Missing `ComponentDocEntry.sourcePath` targets | 82 of 99 |
| Old `lib/src/components/...` references in current website/docs | 452 lines |
| Old `NavUser` wording in current website/docs | 8 lines |
| Stale contributor contract | `AGENTS.md` still requires public `El*` APIs |
| Stale skill contract | UI-director still describes `El*`, effects/motion folders, and shots |
| Failed CI | release audit still expects generated icons at their old paths |
| Deployment | Docs deployment is manual; no deployment run exists for `931bff8` |

CI failure to reproduce first:

```text
lib/src/components/icon_paths.g.dart is recorded as redistributed but is missing.
lib/src/components/icon_paths.g.index.dart is recorded as redistributed but is missing.
```

## Non-negotiables

1. Use ordinary unprefixed APIs (`Button`, `Card`, `Icon`, `TextStyles`,
   `space`); do not reintroduce `El*`.
2. Repository UI sources are under `lib/src/components/ui/`; the AgentConsole
   block is under `lib/src/blocks/agent_console/`; foundation is under
   `lib/src/design_system/foundation/`.
3. Consumer destinations remain `lib/components/ui/`, `lib/blocks/`, and
   `lib/design_system/foundation/`. Never confuse repository source paths with
   consumer install destinations.
4. Preserve the two untracked user-owned directories:
   `tool/verify/out/rail/` and `tool/verify/out/shadcn/`.
5. Do not rewrite historical files under `docs/superpowers/plans/`,
   `docs/superpowers/reports/`, or `docs/superpowers/research/` merely to make
   searches quiet. Update only documents presented as current instructions.
6. Do not deploy. Produce a verified deployable build; deployment remains a
   separate explicit owner action.

## Task 1 — Add one reusable documentation taxonomy

**Files**

- `example/lib/components_docs/catalog.dart`
- `example/test/components_docs/catalog_wiring_test.dart`

**Implementation**

1. Keep `componentDocs` as the complete route/search catalog.
2. Add `ComponentDocFamily { components, effects, agent, charts }`.
3. Add three small explicit name sets for Effects, Agent, and Charts, then one
   `componentDocFamily(entry)` classifier. Do not add a new field manually to
   all 99 metadata files.
4. Expose a helper that returns entries for one family, sorted by title.
5. Assert every entry is assigned exactly once, no configured name is missing,
   the union equals `componentDocs`, and each family is alphabetized.

This central classifier must be consumed by both the sidebar and the
Components index; no second list is allowed.

## Task 2 — Restructure the left sidebar and Components index

**Files**

- `example/lib/docs/docs_layout.dart`
- `example/lib/site/pages/public_pages.dart`
- `example/test/docs_pages_routing_test.dart`
- `example/test/docs_sidebar_test.dart`
- `example/test/public_pages_test.dart`
- `example/test/components_docs/button_route_integration_test.dart`
- rail-height/scroll tests that assert the old two-group shape

**Implementation**

1. Make `_defaultSidebarGroups` return exactly:
   `Sections`, `Components`, `Effects`, `Agent`, `Charts`.
2. Build the last four groups from the catalog taxonomy.
3. Preserve selected-state behavior and all `/components/<name>` routes.
4. Update `/components` to show four dense link sections—Components, Effects,
   Agent, and Charts—using the same taxonomy and existing
   `_ComponentLinkSection`.
5. Update its table of contents to the same four anchors.
6. Keep narrow behavior unchanged: the left rail still collapses according to
   the existing responsive contract; do not invent another mobile menu.

**Focused assertions**

- group order is exact;
- Button appears only in Components;
- PremiumSurface appears only in Effects;
- AgentComposer appears only in Agent;
- Chart appears only in Charts;
- active item remains selected in its owning group;
- every link resolves to its existing page;
- wide, narrow, text-scaled, light, and dark renders have no overflow.

## Task 3 — Repair documentation paths and renamed copy mechanically

**Primary roots**

- `example/lib/`
- `example/test/`
- `README.md`
- `CHANGELOG.md` only where text describes the current release/API
- `tool/README.md`

**Method**

1. Create one temporary, deterministic Dart migration script under
   `tool/migration/` with dry-run and apply modes.
2. Build replacements from actual files and registry manifests rather than
   guessing paths.
3. Apply these structural mappings:
   - UI: `lib/src/components/<file>` → `lib/src/components/ui/<file>`;
   - block: AgentConsole → `lib/src/blocks/agent_console/agent_console.dart`;
   - foundation → `lib/src/design_system/foundation/`;
   - renamed item/class prose: NavUser → UserMenu and the other approved
     semantic names from the 2026-08-28 naming plan.
4. Correct install prose so it distinguishes upstream source from the copied
   consumer destination.
5. Run the script twice; the second run must report zero changes.
6. Delete the temporary script unless it becomes a maintained validator.

Do not perform a repository-wide blind replacement. Comments and historical
reports may intentionally describe old code; public runtime documentation may
not.

## Task 4 — Make wrong documentation impossible to merge

**Files**

- `example/test/components_docs/catalog_wiring_test.dart`
- a small new current-doc guard test if needed

**Guards**

1. Every `ComponentDocEntry.sourcePath` resolves to an existing file or
   directory from repository root.
2. AgentConsole resolves to the block path.
3. No current website source contains `lib/src/components/<file>` without the
   `/ui/` segment.
4. No current website copy contains retired names such as `NavUser`,
   `SlidingPill`, `BloomCosmic`, `FoilValue`, `SheenAction`, `MachineSurface`,
   `PageGlow`, or `VoiceOrb`.
5. Tests must assert the new truth; never update a stale expected value merely
   to make a test agree with stale documentation.

## Task 5 — Update current contributor and skill contracts

**Files**

- `AGENTS.md`
- `skills/elattar-flutter-ui-director/SKILL.md`
- `skills/elattar-flutter-ui-director/references/system-map.md`
- other skill references containing retired names/paths
- `README.md`
- current release documentation linked from README/site

**Required corrections**

- public APIs are unprefixed;
- repository and consumer directory tables match the shipped structure;
- effects and motion widgets live with UI components;
- motion values live in foundation;
- application compositions use `blocks`, not `shots`;
- examples use `Button`, `Card`, `Icon`, `TextStyles`, and `space`;
- remove instructions that ask agents to search for or compose `El*` APIs.

Run `test/skill_package_test.dart` after the skill changes.

## Task 6 — Repair the release audit and CI blocker

**Files**

- `tool/release_audit/lib/audit.dart`
- release-audit tests/fixtures that encode redistributed paths
- `THIRD_PARTY_NOTICES.md` only if the audit shows drift

**Implementation**

1. Change the two generated icon ledger paths to
   `lib/src/components/ui/icon_paths.g.dart` and
   `lib/src/components/ui/icon_paths.g.index.dart`.
2. Search every provenance/license inventory for the old paths.
3. Run the release audit locally and require all checks to pass.
4. Do not change hashes or notices unless file bytes actually changed.

```powershell
dart run tool/release_audit/bin/verify.dart .
```

## Task 7 — Focused verification while iterating

Run only the checks relevant to each edit:

```powershell
dart format <changed-dart-files>
flutter test test/skill_package_test.dart
Push-Location example
flutter test test/components_docs/catalog_wiring_test.dart
flutter test test/docs_pages_routing_test.dart
flutter test test/docs_sidebar_test.dart
flutter test test/public_pages_test.dart
Pop-Location
dart run tool/release_audit/bin/verify.dart .
```

Use the repository's direct Flutter/Dart invocation if the local wrapper hangs.
Do not rerun the 16-minute example suite after every mechanical correction.

## Task 8 — Final verification and visual acceptance

Run the complete ladder once after focused checks are green:

```powershell
flutter analyze
flutter test
Push-Location example
flutter analyze
flutter test
Pop-Location
dart run tool/deploy_site/bin/build_site.dart
dart run tool/registry_builder/bin/validate.dart example/build/web/registry/0.0.1/registry.json
dart run tool/release_audit/bin/verify.dart .
git diff --check
```

Then inspect the documentation sidebar and `/components` index at:

- wide and narrow widths;
- light and dark themes;
- increased text scale;
- one ordinary component page, one Effects page, one Agent page, and one Charts
  page.

Acceptance requires readable group order, one selected item, keyboard-reachable
links, no clipped labels, no overflow, and no stale names or paths in rendered
copy.

## Task 9 — Delivery

1. Confirm `git status` contains no generated build artifacts and preserves the
   two user-owned verification folders.
2. Report changed files, audit counts before/after, focused/full test totals,
   build result, and visual routes inspected.
3. Commit only after every gate is green.
4. Push only if the owner explicitly asks.
5. Do not trigger the manual Docs deployment without separate approval.

## Definition of done

- all 99 documentation source paths resolve;
- stale current-doc path/name counts are zero;
- sidebar order is Sections → Components → Effects → Agent → Charts;
- component membership is exhaustive and non-overlapping;
- routes remain stable;
- release audit passes;
- package and example analysis/tests pass;
- production docs build and staged registry validation pass;
- visual review passes in both themes and narrow/wide layouts;
- CI is green before any deployment is requested.
