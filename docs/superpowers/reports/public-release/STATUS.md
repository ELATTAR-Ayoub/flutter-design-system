# Public release program status

## How to keep this file true

This file drifted three times in one program — twice by claiming committed
work was uncommitted, once by naming a stale HEAD and an undercounted commit
list. The failure shape was always the same: this file described its own
commit state from *inside* the commit that made that description wrong.

Two different kinds of claim live in this file, and they fail differently:

- **Measured values** (test counts, item counts, hashes, sizes) are correct
  the moment you run the command that produces them. Write them down then.
- **Git-state values** (HEAD commit, the commit list for a phase, whether the
  tree is clean) describe *this repository's own history*, which changes the
  instant a new commit lands — including the commit that edits this file.
  **Write these only in a commit made *after* the work they describe, never
  in the same commit.** A file cannot correctly state the hash of the commit
  that contains it.

Before writing any claim in this file, reproduce it from a command run at
that moment — `git log --oneline -1`, `git status --porcelain`, `git log
--oneline <range>`, the actual test runner output. Do not carry a number
forward from a phase report's prose without re-running the command yourself.

## Current phase

Phase H — Skills — is complete and committed (`cb0cc2a`, "feat(skills): mount
the Skills page and close Phase H"). Phase I — independent audit — opened
with `bc68e52`, "docs: record Phase I audit findings (content/licensing)"
(`docs/superpowers/reports/public-release/phase-i-audit-findings.md`).

Multiple Phase I workstreams are running concurrently and landing commits
while this file is being edited — e.g. `f020082`, "docs: record Phase I audit
findings (mechanics)"
(`docs/superpowers/reports/public-release/phase-i-audit-findings-mechanics.md`),
which appeared mid-session and is **not** addressed by this pass; verify its
ownership before acting on it. Do not treat any specific commit hash named in
this section as current — re-run `git log --oneline -1` per the rule above.

This worker's remediation slice covers the content/licensing audit's docs and
workflow findings (F17, F21–F25, F27): this file, `CHANGELOG.md`, `README.md`,
`CONTRIBUTING.md`, and several reports under
`docs/superpowers/reports/public-release/`. Licensing (F1–F6) and site-copy
(F8–F15) findings are explicitly reserved for other owners and are **not**
addressed by this pass.

## Overall state

Public-release blockers from prior phases are preserved and unresolved; the
repository is private, `LICENSE` is a placeholder, and `publish_to: 'none'`.
Phase I's audit found additional publication-layer defects (licensing,
site copy, a workflow that would auto-publish all of the above, and this
file's own drift) — see the audit findings file above for the full list.

## Release version

`0.0.1`

## Last verified commit/worktree state

- Branch `public-release-v0.0.1-phase-f`.
- Last commit at last check: `f020082` — "docs: record Phase I audit findings
  (mechanics)". Verified with `git log --oneline -1` — but Phase I has several
  workers landing commits concurrently (this file's own remediation pass
  started against `bc68e52` and `f020082` landed mid-session), so treat this
  hash as already possibly stale and re-run the command rather than trusting
  it.
- The five Phase H commits, oldest first (verified with
  `git log --oneline f19d14e^..cb0cc2a`):
  - `f19d14e` — promote the skill to `skills/`, add the plugin manifests, delete
    the Codex claim, update `AGENTS.md`/`README.md`/`CONTRIBUTING.md`, record
    Decision 005.
  - `c90aaa6` — make the skill's references mode-aware (repository vs. consumer).
  - `3817808` — root-suite structural tests plus the recorded-run ledger.
  - `594bb25` — the Skills catalog, `SkillsPage`, and its widget suite.
  - `cb0cc2a` — mount `/skills` on the real page, delete `PublicSkillsPage`,
    thread the skill's own bytes as a package asset, fold skill topics into
    search, close Phase H.
- **Working tree at `f020082` was clean before this remediation pass started**
  — confirmed by inspection: `git status --porcelain` at time of writing
  reports modifications only in this docs/workflow worker's own owned files
  (`.github/workflows/pages.yml`, `README.md`, `CHANGELOG.md`,
  `CONTRIBUTING.md`, and reports under
  `docs/superpowers/reports/public-release/`), nothing else. The Wave 2
  integration this file previously listed as uncommitted
  (`pubspec.yaml`, `example/lib/main.dart`, `example/lib/site/site_routes.dart`,
  `example/lib/site/pages/public_pages.dart`,
  `example/test/public_pages_test.dart`, `example/test/site_routes_test.dart`)
  is inside `cb0cc2a`, not pending. By the rule at the top of this file, this
  in-progress pass's own commit state is not pinned to a hash here — check
  `git log`/`git status` directly when you read this.
- Registry untouched. Phase H added no registry item and the builder was **not
  re-run** — a skill goes into an agent configuration directory, not `lib/`.
  The last figure actually observed is Phase G's **20** schema-v1 items; re-run
  the two registry commands below if you need that confirmed rather than
  inherited.
- Root `flutter analyze` clean; root `flutter test` **1482** passing (was 1473).
- Example `flutter analyze` clean; example `flutter test` **968** passing (was
  943).
- Example release web build passes with `--base-href /flutter-design-system/`.
  Run it from PowerShell — Git Bash rewrites the `--base-href` value into a
  Windows path and the build refuses it.
- The release bundle's copy of the skill is sha256-identical to
  `skills/elattar-flutter-ui-director/SKILL.md`; verified directly against
  `build/web/assets/packages/elattar_design_system/skills/…`.

## Completed phases

- [Phase A — Public repository foundation](phase-a-public-repository.md)
- [Phase B — Website shell](phase-b-website-shell.md)
- [Phase C — Documentation system](phase-c-documentation-system.md)
- [Phase D — Registry pilot](phase-d-registry-pilot.md)
- [Phase E — CLI MVP](phase-e-cli-mvp.md)
- [Phase F — Component documentation](phase-f-component-documentation.md)
- [Phase G — Shots](phase-g-shots.md)
- [Phase H — Skills](phase-h-skills.md)

## Active work packages

Phase I is scoped as an independent audit
(`phase-i-audit-findings.md`, `bc68e52`) plus a remediation pass. This
worker's slice (docs and workflow findings F17, F21–F25, F27) is in progress
on top of `bc68e52`; licensing (F1–F6) and site-copy (F8–F15) are separate,
unstarted work packages for other owners.

## Accepted work in current phase

- The skill moved from `.agents/skills/elattar-flutter-ui-director/` — a path
  **no harness scans**, so it had never once been loaded as a skill by anything
  — to `skills/elattar-flutter-ui-director/`, with the repository made its own
  single-plugin Claude Code marketplace (`f19d14e`).
- The Codex support claim deleted rather than softened: `agents/openai.yaml` is
  gone, there is no Codex install route, and nothing on the site names Codex
  (`f19d14e`).
- The skill's references made mode-aware, so an agent in a CLI-consumer project
  is not routed to repository-only paths (`c90aaa6`).
- Root-suite structural tests — one source of truth, frontmatter conformance in
  Dart, link resolution, repo-claim accuracy, plugin manifest wiring,
  install/remove round trip with sha256 — plus the recorded-run ledger
  ([`skill-install-verification.md`](skill-install-verification.md)) (`3817808`).
- The real `/skills` page: catalog, `SkillsPage`, and the `verifiedCommands`
  allowlist that makes an invented install command structurally unable to reach
  the site (`594bb25`).
- Wave 2 (`cb0cc2a`): `/skills` mounted on the real page, `PublicSkillsPage`
  deleted, the skill's own bytes threaded to the file tree as a **package**
  asset, skill topics folded into search, and the `npx` guard carried forward
  onto the mounted route.

## Rejected or revision work

- None in this phase. No mid-wave correction was issued.

## Blockers

Open:

- **The repository is PRIVATE.** Confirmed live 2026-08-23:
  `gh repo view ELATTAR-Ayoub/flutter-design-system --json visibility,isPrivate`
  returns `{"isPrivate":true,"visibility":"PRIVATE"}`. Every GitHub-based
  install command is unverifiable end to end and unusable by anyone not already
  authorized.
- `LICENSE` is still the placeholder string `TODO: Add your license here.`
  Redistribution rights are not confirmed, so no manual-copy instruction may be
  published.
- `publish_to: 'none'` remains; publication/deployment is not authorized.
- The four "Recorded runs" rows in
  [`skill-install-verification.md`](skill-install-verification.md) are genuinely
  empty and need a human at a real harness. No agent in this program can type a
  slash command into a separate interactive session and read back its skill
  listing. **A route with no transcript is not published.**
- The site prints `/plugin marketplace add ELATTAR-Ayoub/flutter-design-system`
  badged "Pending verification". It is real Claude Code syntax with an explicit
  blocker note, unlike the retired `npx` line — but it points at a private
  repository. Supervisor decision, recorded in the Phase H audit.
- Package mode lacks a real `elattar_core` package.
- Browser visual/accessibility captures are incomplete for the component guides,
  the Shots routes, and now `/skills`.

Closed in Phase G (inherited as stale into this file and both later phase
reports — see Phase I finding F22):

- ~~`.github/workflows/ci.yml` runs neither the registry validator nor the
  `packages/elattar_cli` suite.~~ False as written. `ci.yml:42-64` runs
  `dart pub get`/format/analyze/test in `packages/elattar_cli`, plus registry
  build and validate. Those steps landed in `48c390b`, an ancestor of Phase
  G's own close (`7860c58`) — so this row was already false the moment Phase
  G's report shipped it, and it was copied forward into `phase-g-shots.md`
  and `phase-h-skills.md` unverified. Verified now with
  `git show --stat 48c390b -- .github/workflows/ci.yml` and by reading the
  file directly.

Closed in Phase H:

- ~~The skill sits at a path no harness scans and has never been loaded~~ —
  moved to `skills/`, plugin manifests added.
- ~~Codex support claimed with no install route and no recorded run~~ — claim
  deleted.
- ~~The skill routes agents to repository paths a CLI consumer does not have~~ —
  mode discrimination added.
- ~~The skill carries no version, so "update" is unverifiable~~ — `plugin.json`
  version `0.0.1`, parity-tested against the site catalog.
- ~~`/skills` serves a placeholder~~ — replaced by the real page.

Known and non-blocking:

- The release web build reports a CupertinoIcons tree-shaking warning and
  Flutter's informational Wasm dry-run suggestion. Both unchanged and expected.
- The two `skills/` asset lines in the root `pubspec.yaml` add ~19 KB to every
  dependent application's bundle. Accepted deliberately over a duplicate tree;
  see Phase H, Decisions.

## Next three actions

1. Close the Phase I audit's blockers: the licensing decisions (F1–F6, owner
   decision), the site-copy defects (F8–F15, a separate worker), and confirm
   `.github/workflows/pages.yml`'s trigger stays `workflow_dispatch`-only
   until all of them land — see the comment block at the top of that file.
2. Collect the Route A (local-path plugin) and Route D (`AGENTS.md`) transcripts
   into `skill-install-verification.md`. Both are unblocked **today** — they
   need only a clone someone already has, not a public repository — and they are
   the cheapest available proof that the skill actually loads.
3. Close the three publication gates: choose a `LICENSE`, decide on
   `publish_to`, and make the repository public. Routes B and C stay blocked
   until then, and no install route can be announced.

## Commands to resume

```powershell
dart run tool/registry_builder/bin/build.dart .
dart run tool/registry_builder/bin/validate.dart registry/generated/latest/registry.json
flutter analyze
flutter test
Push-Location example
flutter analyze
flutter test
flutter build web --release --base-href /flutter-design-system/
Pop-Location
Push-Location packages/elattar_cli
dart analyze
dart test
Pop-Location
```

## Files to read first

1. `docs/superpowers/reports/public-release/phase-i-audit-findings.md` — the
   current phase's open findings.
2. `docs/superpowers/reports/public-release/phase-h-skills.md`.
3. `docs/superpowers/reports/public-release/decisions/005-public-skill-location.md`.
4. `docs/superpowers/reports/public-release/skill-install-verification.md` — in
   particular the empty "Recorded runs" section.
5. `AGENTS.md` and `skills/elattar-flutter-ui-director/SKILL.md`. The old
   `.agents/skills/…` path no longer exists.
6. `example/lib/skills_docs/catalog.dart` — `verifiedCommands`, and why an
   install command cannot reach the site without a human adding a line.

## Do not redo

- Existing-repository decision, source-foundation default, and
  `lib/components/ui/` destination.
- Phase A–H accepted work and recorded revisions.
- Version remains `0.0.1`.
- Phase G rulings: Phase G is Shots; two directories (`shots/` shipped,
  `shots_docs/` never shipped); product-neutrality is a source guard plus a
  symbol trace, not prose; previews are widget tests, not goldens.
- The Shot detail page loads source from the asset bundle. Do not replace it
  with a generated or hand-copied Dart literal.
- Phase H rulings: one skill directory, zero copies (Decision 005); the CLI does
  not own skill install; no claimed agent support without a transcript; no
  published command that is not in `verifiedCommands`.
- The Skills page loads the skill's source as a **package** asset
  (`packages/elattar_design_system/skills/…`, declared in the repository-root
  `pubspec.yaml`) because an asset path cannot climb above `example/`. Do not
  "fix" this by copying the skill into `example/assets/`, generating a Dart map,
  or symlinking — each recreates the second copy Decision 005 exists to prevent.
