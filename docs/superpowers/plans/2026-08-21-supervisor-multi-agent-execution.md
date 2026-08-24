# Supervisor-led multi-agent execution plan

**Status:** Binding operating plan for implementation
**Date:** 2026-08-21
**Applies to:** public repository preparation, package, registry, CLI, website, component documentation, Shots, and Skills
**Companion specifications:**

- `docs/superpowers/plans/2026-08-21-public-release-registry-cli.md`
- `docs/superpowers/plans/2026-08-21-public-website-ui-information-architecture.md`

## 1. Purpose

Execute the Elattar public-release program with one high-capability supervisor and bounded implementation agents. The supervisor owns architecture, task decomposition, integration, evidence review, and final acceptance. Sub-agents perform scoped research, implementation, testing, documentation, and independent audits.

The workflow optimizes for:

- Lower total model cost than using the flagship model for every edit.
- Parallel progress on genuinely independent work.
- Clear file ownership.
- Evidence-based review.
- Safe recovery across token limits, agents, sessions, and context compaction.
- A durable written record of completed work and exact next actions.

Sub-agents accelerate delivery; they do not transfer accountability away from the supervisor.

## 2. Model policy

### 2.1 Supervisor

```text
Preferred model: GPT-5.6 Sol
Default reasoning: high
Exceptional reasoning: xhigh for critical architecture or difficult integration
```

Responsibilities:

- Interpret the product specifications.
- Inspect repository state and constraints.
- Design phases, waves, ownership, and acceptance gates.
- Select worker models according to risk.
- Resolve contradictions between workers.
- Review diffs, tests, and visual evidence.
- Own shared integration points.
- Request revisions when evidence is insufficient.
- Write phase-close reports and continuation state.
- Decide whether a phase is accepted, rejected, or blocked.

The supervisor should avoid routine implementation when delegation is cheaper and safe. It may make small integration changes when that is clearer than creating another worker handoff.

### 2.2 Standard coding worker

```text
Preferred model: GPT-5.4
Default reasoning: medium
```

Use for:

- Flutter implementation.
- Dart CLI implementation.
- Registry tooling.
- Tests and fixtures.
- Documentation pages.
- CI workflows.
- Bounded refactors with clear acceptance criteria.

### 2.3 Complex implementation or review worker

```text
Preferred model: GPT-5.6 Terra
Default reasoning: medium
```

Use for:

- Complex responsive Flutter UI.
- Dependency resolver design.
- Safe YAML/pubspec mutation.
- Conflict and migration behavior.
- Difficult defect diagnosis.
- Independent review of high-risk phases.

### 2.4 Mechanical/high-volume worker

```text
Preferred model: GPT-5.6 Luna
Default reasoning: low or medium
```

Use for:

- Inventories.
- Repetitive registry metadata.
- Link validation.
- Fixture generation.
- Documentation cross-checks.
- Straightforward migrations with explicit patterns.

### 2.5 Selection rule

Choose by task shape, not title:

| Task shape | Model route |
|---|---|
| Architecture, reconciliation, final acceptance | Sol supervisor |
| Bounded coding with clear contract | GPT-5.4 worker |
| Ambiguous or high-risk implementation | Terra worker |
| Repetitive, deterministic, high-volume work | Luna worker |

Do not use three agents to solve the same problem unless deliberate comparison is part of the task.

## 3. Concurrency and hierarchy

The active environment provides four concurrent agent slots, including the supervisor. A normal wave is:

```text
Supervisor
├── Worker A
├── Worker B
└── Worker C
```

Workers may create child agents only when:

- The parent owns a sufficiently large work package.
- The child task is independently bounded.
- A concurrency slot is available.
- Parent and child file ownership cannot conflict.
- The parent remains responsible for reviewing the child's result.

Nested delegation uses the same shared concurrency pool. It is not unlimited. Prefer a shallow hierarchy unless a child can complete meaningful work in parallel.

All agents share the same workspace. Parallel agents must never edit overlapping files unless the supervisor explicitly serializes the work.

## 4. Preflight: establish the baseline

Before implementation delegation, the supervisor must:

1. Read `AGENTS.md` and applicable skills.
2. Read the public release/CLI plan.
3. Read the website UI/IA plan.
4. Inspect the public barrel, foundation, components, examples, and tests.
5. Inspect `git status` and preserve user changes.
6. Run the existing applicable analysis and tests.
7. Record pre-existing failures separately from new regressions.
8. Build a dependency graph of phases and shared files.
9. Mark files that remain supervisor-owned.
10. Create the program status ledger described in Section 13.

No implementation worker starts until the supervisor can state:

- What source is authoritative.
- What work is already modified.
- Which tasks are independent.
- Which files are shared integration points.
- What evidence closes the phase.

## 5. Work-package contract

Every delegated task includes:

```text
Objective:
One concrete outcome.

Inputs:
Exact specifications, references, and existing APIs to inspect.

Owns:
Files/directories the worker may edit.

May read:
Relevant context outside ownership.

Must not edit:
Shared or other-worker files.

Requirements:
Behavioral and technical constraints.

Verification:
Exact tests, analysis, builds, and captures required.

Deliverable:
Code/report plus the structured handoff in Section 7.

Stop conditions:
Conditions requiring supervisor direction rather than assumption.
```

Example:

```text
Objective:
Implement the registry schema and validator.

Owns:
- registry/schema/**
- tool/registry_builder/**
- test/registry/**

May read:
- lib/**
- docs/**

Must not edit:
- lib/src/components/**
- example/lib/**
- packages/elattar_cli/**

Deliver:
- Schema implementation
- Five fixture manifests
- Unit tests
- Validation command
- Changed-file list
- Test results
- Limitations
```

## 6. Research before implementation

Use read-only research waves when unresolved decisions could cause incompatible implementations.

Initial research wave:

```text
R1-A: Public package, asset, and licensing audit
R1-B: Registry dependency and source-transformation audit
R1-C: Website route and documentation-content audit
```

Research workers return evidence-backed reports, not code. The supervisor reconciles:

- Conflicting recommendations.
- Missing dependencies.
- Package boundaries.
- Legal blockers.
- Shared-file risks.
- Implementation sequence.

The reconciliation becomes a recorded decision before coding begins.

## 7. Worker handoff contract

Every worker returns:

```text
Outcome:
What was implemented or discovered.

Files changed:
Exact list.

Decisions:
Implementation judgments and why they were made.

Public APIs used:
Verified El* APIs, foundations, or external contracts.

States covered:
Loading, empty, error, success, disabled, focus, reduced motion, or N/A reasons.

Tests added:
Exact tests and their purpose.

Commands run:
Exact commands and results.

Visual verification:
Routes, themes, widths, and captures inspected.

Limitations:
Incomplete, uncertain, or unverified details.

Shared-file requests:
Integration changes reserved for the supervisor.

Recommended next task:
The next bounded action enabled by this result.
```

A worker is not accepted as complete without this handoff.

## 8. Supervisor review and revision

### 8.1 Scope review

- Worker changed only owned files.
- Work matches the assignment.
- No unrelated refactor entered the diff.
- User changes remain intact.

### 8.2 Architecture review

- Public `El*` APIs are used correctly.
- No competing token or theme system was introduced.
- Product composition stays outside package components.
- Registry output derives from the authoritative package.
- Consumer components install under `lib/components/ui/`.
- Source/package foundation modes remain coherent.

### 8.3 Correctness review

- Read the complete diff.
- Inspect new APIs and tests.
- Verify failure and recovery behavior.
- Run focused checks.
- Run the phase gate.
- Check formatting and generated drift.

### 8.4 Visual review

For website/UI work:

- Light and dark.
- Mobile and wide.
- Keyboard and focus.
- Loading, empty, error, and recovery.
- Reduced motion.
- Long content and text scale.
- Relevant screenshots/captures.

### 8.5 Revision message

Rejected work receives precise evidence and correction scope:

```text
Status: not accepted

Evidence:
- Exact file/line or failing behavior.
- Exact failing command or capture.

Required revision:
1. Concrete correction.
2. Missing test.
3. Required verification.

Ownership:
Do not modify unrelated or shared files.
```

Normally the same worker revises its work because it already owns the context. Replace the worker when the approach is structurally wrong, another specialty is required, two correction attempts fail, or an independent implementation is intentionally needed.

## 9. Independent audits

Before closing a high-risk phase, assign a read-only auditor who did not implement it.

Audit examples:

- Registry installation and integrity safety.
- CLI conflict and overwrite behavior.
- Website accessibility and responsive behavior.
- Licensing and public asset references.
- Component documentation completeness.
- Migration data-loss risk.

Auditors report findings with severity, evidence, and remediation. Fixes return to the owning implementation worker. The supervisor verifies the fix and closes the finding.

## 10. Shared integration ownership

The supervisor normally owns:

- Root `pubspec.yaml`.
- Main package barrel.
- Global route registry.
- Documentation navigation source.
- Repository-wide workflows.
- Release versions and tags.
- Registry `latest` pointer.
- Final changelog and phase status.

If shared integration becomes too large, assign one dedicated integration worker after other workers finish. Never allow multiple active writers on the same integration file.

## 11. Execution phases

### Phase A — Public repository foundation

Workers:

```text
A1: Package metadata and public README
A2: Governance, security, contribution, and issue templates
A3: CI and GitHub Pages workflow
```

Exit gate:

- Repository is understandable publicly.
- CI passes.
- Documentation builds.
- Package publication dry-run is reviewed.
- No private or unlicensed content is exposed.

### Phase B — Website shell

Workers:

```text
B1: Route/content metadata and navigation model
B2: Header, mobile menu, search, theme selector, and footer
B3: Home page and living showcase
```

Exit gate:

- Home, Docs, Components, Shots, and Skills resolve.
- Mobile and desktop navigation work.
- Light, Dark, and System work.
- Search states exist.
- Analysis/tests pass.
- Required visual captures are reviewed.

### Phase C — Documentation system

Workers:

```text
C1: Documentation shell, sidebar, article, and TOC
C2: Preview/code, command copy, and installation UI
C3: API tables, state matrix, and install-facts compositions
```

Exit gate:

- Documentation handles narrow and wide layouts.
- Code is selectable and overflow-safe.
- Copy success/failure is accessible.
- Long content and API tables remain usable.
- Only system tokens and verified APIs are used.

### Phase D — Registry pilot

Workers:

```text
D1: Registry schema, parser, and validator
D2: Generator and import transformation
D3: Foundation plus button, input, card, dialog, and select manifests
```

Exit gate:

- No manually maintained second component implementation.
- Dependency graph validates.
- Generated payloads are deterministic.
- Pilot items install into clean fixtures.
- Fixtures pass `flutter analyze`.

### Phase E — CLI MVP

Workers:

```text
E1: Project discovery, config, and manifest
E2: Registry client, cache, and dependency resolver
E3: Planner, installer, pubspec editor, and barrels
```

Then a serialized integration task:

```text
E4: Wire init, add, list, search, info, and doctor
```

Exit gate:

```console
elattar init
elattar add button
flutter analyze
```

works in clean cross-platform fixtures.

### Phase F — Component documentation

Repeat waves with exclusive page ownership. Example:

```text
F1: Button, Button Group, Toggle, and Kbd
F2: Input, Textarea, Input Group, and Input OTP
F3: Dialog, Alert Dialog, Sheet, and Drawer
```

Each page delivers preview/code, command/manual installation, usage, API, variants, states, accessibility, dependencies, source links, and tests.

Exit gate:

- Every stable registry item has an individual route.
- Navigation has no placeholder promises.
- Component facts agree with registry and public source.

### Phase G — Shots

Workers:

```text
G1: Shots catalog and filters
G2: Shot detail, preview/code, and file tree
G3: First three installable shots and isolated previews
```

Exit gate:

- Shots remain product-neutral application compositions.
- Dependencies install components into `lib/components/ui/`.
- Each Shot has deterministic light/dark and viewport previews.

### Phase H — Skills

Workers:

```text
H1: Public skill packaging and source-of-truth strategy
H2: Skills documentation page
H3: Installer fixtures and supported-agent verification
```

Exit gate:

- One public skill source of truth exists.
- Published installation methods are actually verified.
- Users can install, update, inspect, and remove the skill using documented methods.

### Phase I — Release and independent final audit

Workers:

```text
I1: Full repository verification and package/CLI dry-runs
I2: Accessibility, responsive, and visual audit
I3: Public content, licensing, links, registry, and documentation audit
```

Supervisor integrates findings, requests fixes, reruns gates, writes the release report, and authorizes publication only when blocking findings are closed.

## 12. Mandatory phase-close documentation

After every phase, before starting the next phase, the supervisor must write:

```text
docs/superpowers/reports/public-release/phase-<letter>-<name>.md
```

Examples:

```text
phase-a-public-repository.md
phase-b-website-shell.md
phase-c-documentation-system.md
phase-d-registry-pilot.md
```

Every phase report contains:

```markdown
# Phase <letter> — <name> report

## Status
Accepted | Accepted with follow-up | Rejected | Blocked

## Objective
What this phase was expected to deliver.

## Completed work
Concrete implemented outcomes.

## Files changed
Grouped exact paths.

## Agent assignments
Task, model tier, ownership, and result for each worker.

## Decisions made
Architecture or product rulings and their evidence.

## Verification performed
Commands, test counts/results, builds, and captures.

## Supervisor review
What was inspected and what revisions were requested.

## Independent audit
Findings, severity, fixes, and closure status.

## Known limitations
Anything incomplete or intentionally deferred.

## What is next
Ordered bounded tasks for the next phase.

## Restart instructions
Exact files to read and first commands to run in a new session.
```

The next phase cannot be marked in progress until the previous phase report exists.

## 13. Program status and continuation ledger

Maintain one compact source of current execution state:

```text
docs/superpowers/reports/public-release/STATUS.md
```

It is updated:

- At program initialization.
- When a wave begins.
- When a worker is accepted or rejected.
- At every phase close.
- Before an intentional session handoff.
- Before context/token exhaustion when foreseeable.

Required structure:

```markdown
# Public release program status

## Current phase
Phase and current wave.

## Overall state
In progress | Blocked | Ready for next phase | Complete

## Last verified commit/worktree state
Branch, commit when available, and dirty files that must be preserved.

## Completed phases
Links to phase reports.

## Active work packages
Owner, model tier, files, status, and expected deliverable.

## Accepted work in current phase
Completed tasks and evidence.

## Rejected or revision work
Owner, finding, and required correction.

## Blockers
Exact blocker, evidence, and authority needed.

## Next three actions
Concrete ordered steps—not broad goals.

## Commands to resume
Exact read-only baseline and focused verification commands.

## Files to read first
Specifications, last report, and touched integration files.

## Do not redo
Completed research, accepted implementations, and settled decisions.
```

This file is operational state, not a narrative diary. Keep it concise and current.

## 14. Session and supervisor handoff protocol

When moving to a new session, agent, or supervisor:

### 14.1 Outgoing supervisor

1. Stop assigning new work.
2. Collect available worker handoffs.
3. Record any still-running work package and ownership.
4. Run a read-only `git status` and preserve dirty files.
5. Update `STATUS.md`.
6. Update the current phase report, even if the phase is incomplete.
7. Write exact next actions and resume commands.
8. State unresolved decisions without guessing their outcome.

### 14.2 Incoming supervisor

Read in this order:

1. `AGENTS.md`.
2. Applicable skills.
3. This supervisor plan.
4. Public release/CLI specification.
5. Website UI/IA specification.
6. `reports/public-release/STATUS.md`.
7. Current phase report.
8. Relevant changed files and tests.

Then:

1. Run the recorded baseline commands.
2. Compare actual repository state with the ledger.
3. Do not repeat accepted research or work.
4. Reconcile any discrepancy in `STATUS.md` before delegating.
5. Continue from the first listed next action.

### 14.3 Handoff quality gate

A handoff is sufficient only when another supervisor can answer:

- What is complete?
- What evidence proves it?
- What is currently being edited and by whom?
- What failed or remains uncertain?
- What exact task comes next?
- Which files must not be overwritten?
- Which commands establish the current baseline?

## 15. Decision records

Material decisions receive short records under:

```text
docs/superpowers/reports/public-release/decisions/
```

Examples:

```text
001-existing-repository.md
002-source-foundation-default.md
003-components-ui-destination.md
004-registry-source-of-truth.md
005-public-skill-location.md
```

Each record states context, decision, alternatives considered, consequences, and status. Do not record hidden model reasoning; record inspectable evidence and the chosen outcome.

## 16. Token and context controls

1. Supervisor reads shared architecture once and delegates narrow context.
2. Workers receive only relevant specification sections and paths.
3. Prefer limited-history forks over full conversation history.
4. Use GPT-5.4 or Luna for bounded work.
5. Use Terra where ambiguity or risk justifies it.
6. Reserve Sol for architecture, reconciliation, and acceptance.
7. Reuse the owning worker for revisions.
8. Do not spawn an agent for work faster than delegating and reviewing it.
9. Keep worker reports structured and concise.
10. Run at most three parallel workers while the supervisor remains active.
11. Stop downstream work when a phase gate fails.
12. Use scripts for mechanical inventories and validation.
13. Keep shared-file edits centralized.
14. Update continuation documentation before context is lost.
15. Treat lower token use as an improvement only when acceptance evidence remains complete.

## 17. Failure and blocker handling

When a task fails:

1. Record the failing command and output summary.
2. Determine whether it is pre-existing, worker-introduced, environmental, or specification ambiguity.
3. Assign correction to the owning worker when scoped.
4. Escalate to the supervisor for architecture or shared-file issues.
5. Update `STATUS.md` if it changes the next action.
6. Do not mark a phase accepted because its token budget or session time ended.

A blocker report contains the exact condition, repeated attempts, evidence, safe alternatives tried, and the user/external decision required.

## 18. Completion contract

The program is complete only when:

- Every phase has an accepted report.
- `STATUS.md` points to all final evidence and states Complete.
- Full repository, package, CLI, registry, website, and skill gates pass.
- Independent audits have no unresolved release blockers.
- Public licensing and attribution are reviewed.
- The final release report lists published versions, URLs, commands, verification, and known limitations.

The supervisor then writes:

```text
docs/superpowers/reports/public-release/final-release-report.md
```

That report becomes the durable handoff for maintenance after launch.
