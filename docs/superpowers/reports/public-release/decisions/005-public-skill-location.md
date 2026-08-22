# Decision 005 — Public skill location

## Status

Accepted, 2026-08-23. Mechanism landed; **publication gated on the owner's licensing decision.**

## Context

The `elattar-flutter-ui-director` skill sat at `.agents/skills/elattar-flutter-ui-director/`.

No harness scans that path. Claude Code reads `~/.claude/skills/`, a repository's
`.claude/skills/`, and plugin marketplaces — none of which is `.agents/`. The
skill's only activation was `AGENTS.md` telling an agent to open the file by
hand. It had therefore never been loaded as a skill by anything, in this
repository or elsewhere, and it carried no version, which made "update" an
unverifiable claim.

The public website plan (IA §11, §12.1) names a dedicated Skills page and a
distribution location under `skills/`, and states plainly: do not publish an
invented command, and never let two skill copies drift.

## Options considered

### A. In-repository, promoted to `skills/` + repo-as-marketplace — chosen

Move the directory to `skills/elattar-flutter-ui-director/` and add
`.claude-plugin/marketplace.json` and `.claude-plugin/plugin.json` with plugin
source `"./"`. The repository root becomes its own single-plugin marketplace, and
the working directory *is* the payload.

- One copy. The repository's own agents, the plugin route, a manual copy, and the
  website's published file tree all read the same bytes.
- No generation step, so no parity test is needed for a mirror that does not
  exist. The cheapest correct answer to "do not let two copies drift" is not to
  make a second copy.
- Version and skill content move together in one commit, so a version bump is
  always a real content bump.
- The website's file-tree section can render the directory directly.

Tradeoff: the marketplace manifests sit at the repository root, so the design-system
repository advertises itself as a plugin marketplace. That is accurate — it does
ship a plugin — but it does mean a consumer who adds the marketplace clones the
whole repository, not just the skill. For a skill that must stay in step with the
package it describes, that coupling is a feature.

### B. Separate skill repository — rejected

A dedicated repository would let the skill version independently.

Rejected: the skill's entire content is a description of *this* repository's
layout, APIs, and verification ladder. Splitting them guarantees drift, and every
component change that touches the skill becomes a cross-repository pull request.
IA §12.2 already rejected the same split for the website.

### C. Published package (pub.dev) — rejected

Wrong channel. A skill is Markdown consumed by an agent harness, not Dart
consumed by the Flutter tool. The root package is `publish_to: 'none'` and
unpublished, and pub.dev has no concept of installing files into an agent
configuration directory.

### D. Registry item, installed by `elattar add` — rejected

The registry and CLI install *source files into `lib/`*. A skill belongs in an
agent configuration directory, not in the consumer's Dart source tree, so the
existing target mapper does not describe it.

The CLI specification contains zero occurrences of "skill". An
`elattar skill install` would be a re-implementation of what the plugin harness
already does correctly — install, update, inspect, remove, with commit-SHA
tracking — and a worse one. Additionally, `packages/elattar_cli/**` and
`tool/registry_builder/**` are dirty under Phase G, so touching them here would
collide.

## Consequences

- `.agents/` is deleted. Nothing reads it; leaving an inert copy behind would be
  the drift this decision exists to prevent.
- `agents/openai.yaml` is deleted. It imitated a file that upstream packaging
  tooling describes as OpenAI-owned metadata seeded from an official package.
  There is no `.codex-plugin/plugin.json`, no archive step, and no self-serve
  install route in this repository. Hand-writing the YAML did not make the skill
  installable in Codex, and no run was ever recorded. `AGENTS.md` is read
  automatically on clone and is a real, demonstrable route; a Codex *install
  route* is not, and is not claimed.
- The skill gained a version. `plugin.json` carries `0.0.1`, matching the package
  version in `pubspec.yaml`. Verified against the local plugin cache: a plugin
  whose `plugin.json` omits `version` is recorded by the harness as
  `"version": "unknown"`, which is precisely the state that makes "update"
  unverifiable. The marketplace entry deliberately omits `version` so
  `plugin.json` is the single source; a real marketplace on this machine
  (`banana-claude`) resolves its installed version this way.
- The skill became mode-aware rather than repository-specific. It previously
  routed agents to `lib/src/foundation/`, `example/lib/`, and
  `test/token_guard_test.dart` — none of which exist in a consumer project, which
  has `lib/components/ui/` and `lib/design_system/`. A consumer could have
  installed a skill that could not work where it was installed. `system-map.md`
  now discriminates on `elattar.yaml` / `.elattar/manifest.json` versus
  `lib/elattar_design_system.dart` before naming any path. One skill, two path
  sets — not two skills.
- The package version and the plugin version are now coupled by convention at
  `0.0.1`. They can legitimately diverge later (a skill wording fix is not a
  package release); if they do, the coupling should be dropped explicitly rather
  than allowed to rot.

## Publication gate

The mechanism is complete. Publication is not, and this is the owner's call.

1. **Licensing.** The root `LICENSE` reads `TODO: Add your license here.` A
   marketplace entry and a "copy this into your agent config" instruction are
   both invitations to redistribute, with no grant attached. No
   `skills/elattar-flutter-ui-director/LICENSE.txt` was written, and
   `plugin.json` deliberately omits a `license` field rather than assert one.
   Until the owner chooses a license, no install route ships.
2. **Recorded runs.** `/plugin marketplace add`, `/plugin install`, and
   `/plugin update` are harness commands; CI cannot execute them. Each route
   needs a dated transcript, per harness, including proof the skill appears in
   that harness's own skill listing — the check that fails today for
   `.agents/skills/`. A route with no transcript is not published.
3. **Repository visibility.** While the repository is private, every GitHub-based
   install command is unverifiable end to end. Publishing one anyway would repeat
   the `npx skills add ELATTAR-Ayoub/flutter-design-system` error already shipped
   to the site — an invented command that nothing in the repository implements.

`README.md` and `CONTRIBUTING.md` therefore describe the mechanism and the
in-repository `AGENTS.md` route, and print no external install command. Version
compatibility is stated as "`0.0.1`, first release" — anything richer would be
invented on a first release.
