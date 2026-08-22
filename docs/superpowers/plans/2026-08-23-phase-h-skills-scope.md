# Phase H — Skills: supervisor scope

Derived from a read-only research pass, 2026-08-23.

## Finding 1 — the skill is inert and has never been loaded

`.agents/skills/` is not a path any harness scans. Claude Code reads
`~/.claude/skills/`, `<repo>/.claude/skills/`, and plugin marketplaces. The
skill's only activation today is `AGENTS.md` line 3 telling an agent to go read
the file by hand.

Moving it is therefore not cosmetic housekeeping — it is what makes the skill
real for the first time.

## Finding 2 — the site already publishes an invented install command

`example/lib/site/pages/public_pages.dart:335` renders:

    npx skills add ELATTAR-Ayoub/flutter-design-system

Nothing in the repo implements or verifies this. The IA plan states plainly:
"Do not publish an invented command." This is a live gate violation in shipped
code and it dies in Phase H's shared-file edit.

## Finding 3 — the Codex support claim cannot be satisfied

`agents/openai.yaml` imitates a file that upstream packaging tooling describes
as OpenAI-owned metadata, seeded from an official package rather than
hand-authored. There is no `.codex-plugin/plugin.json`, no archive step, and no
self-serve install route. Hand-writing the YAML does not make the skill
installable in Codex.

**Ruling:** either delete `agents/openai.yaml`, or keep it only against a dated,
recorded Codex run. No claimed support without a transcript.

## Finding 4 — the skill would not work where it gets installed

`references/system-map.md` routes the agent to `lib/src/foundation/`,
`example/lib/`, `test/token_guard_test.dart`. A consumer who runs
`elattar init` + `elattar add button` has none of those — they have
`lib/components/ui/` and `lib/design_system/foundation/`.

Do not ship two skills. Add a mode discrimination step: detect the CLI's own
manifest -> consumer paths; detect `lib/elattar_design_system.dart` -> this
repository. Same for `references/verify.md`, which hardcodes `Push-Location example`.

Without this, the exit gate passes while the product fails.

## Ruling — source of truth

Move `.agents/skills/elattar-flutter-ui-director/` to
`skills/elattar-flutter-ui-director/` and make the repo its own Claude Code
plugin marketplace (`.claude-plugin/marketplace.json` + `plugin.json`, plugin
source `"./"`).

One directory then serves four consumers — the repo's own agents, the plugin
install path, the manual-copy path, and the website's published tree. Zero
copies, so nothing can drift, and no parity test is needed for a copy that does
not exist. The IA plan already names this destination.

Rejected: separate repo (drift, cross-repo PRs), pub.dev (wrong channel;
`publish_to: 'none'`), registry item (`target_mapper.dart` is dirty under Phase G
W0-A right now, and a skill goes into an agent config dir, not `lib/`).

## Ruling — the CLI does not own skill install

`packages/elattar_cli/**` and `tool/registry_builder/**` are dirty under Phase G.
The CLI spec contains zero occurrences of "skill". The harness already does
install/update/inspect/remove correctly with commit-SHA tracking. An
`elattar skill install` would be a worse re-implementation of `cp -r`.

Two published routes instead: the plugin route and a manual copy route. The
manual route is mandatory in all cases per IA §11.3.

## Waves

**H1 — packaging.** The directory move, dual-mode path fix, plugin manifests,
version stamp (the skill has none today, so "update" is currently unverifiable),
`AGENTS.md`/`README.md`/`CONTRIBUTING.md` path updates, and the decision record
the plan names at `reports/public-release/decisions/005-public-skill-location.md`.

**H2 — site page.** `example/lib/skills_docs/catalog.dart` + `skills_page.dart`
+ test, mirroring the components and shots catalogs. **Hard dependency on Phase G
G2** for `example/lib/docs/docs_file_tree.dart` — H2 must not duplicate it.

**H3 — verification.** Root-suite tests plus the recorded human transcripts CI
cannot produce.

**SHARED, supervisor-serialized:** `example/lib/main.dart`,
`site/site_routes.dart`, `site/pages/public_pages.dart` (retire
`PublicSkillsPage`, killing the invented command), `example/test/public_pages_test.dart`
(asserts `find.text('A shared way of working.')` — breaks by construction, same
class as the Phase G `Signal Studio` breakage; a Wave 1 worker must not "fix" it).

## Verification split — what CI can prove vs what it cannot

CI-provable, in root `test/` so the existing workflow picks them up:
1. Exactly one `SKILL.md` declares this skill (the machine-checkable form of the gate)
2. Frontmatter conformance — re-implemented in Dart, **not** shelled out to a
   validator living in a machine-local plugin cache that CI would not have
3. Every relative link in `SKILL.md` resolves; no orphaned reference
4. Every repo path the skill names still exists — the highest-value test here,
   because a stale skill misleads every agent that loads it
5. Plugin manifest wiring resolves to the same `SKILL.md`
6. Install/remove round trip against a temp dir, sha256 per file
7. Website/skill parity, including a `verifiedCommands` allowlist a human must
   consciously edit — the structural fix for Finding 2

Not CI-provable: `/plugin marketplace add|install|update|uninstall` are harness
commands. H3 records dated transcripts per route and per agent, including proof
the skill appears in the harness's own skill listing — the check that currently
fails for `.agents/skills/`. **A route with no transcript is not published.**

## Blockers carried

- `LICENSE` is a placeholder. A plugin marketplace entry and a "copy this into
  your agent config" instruction are both redistribution invitations with no
  grant attached. H1 cannot write the skill's LICENSE and must not publish
  install instructions until the owner chooses one. Owner decision, not agent work.
- If the repository is not yet public, every GitHub-based install command is
  unverifiable end to end. Publishing one anyway would repeat exactly the sin of
  the `npx skills add` line.
- IA §11.2 item 10 "version compatibility" cannot be honored literally on first
  release. The honest statement is "v0.0.1, first release, tested against
  <harness+version>". Anything richer is invented.
