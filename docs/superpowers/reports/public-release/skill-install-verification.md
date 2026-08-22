# Skill install verification — `elattar-flutter-ui-director`

## The rule

**A route with no transcript is not published.** A CI-green test suite proves
the skill's own files are internally consistent and truthful about this
repository. It does not prove any agent, in any harness, on any machine, can
actually get the skill loaded. Those two things are different claims, and
this document exists because Phase H's exit gate requires both, separately,
before either is announced.

Every row in [Recorded runs](#recorded-runs-not-yet-collected) below stays
**EMPTY** — no invented date, no invented output — until a human runs the
exact command on the exact harness and pastes back what actually happened,
including the harness's own skill listing showing the skill present. An
agent (this one included) cannot type a slash command into a separate
interactive harness session on the user's behalf; that is precisely the gap
this document is for.

## Scope of this report

Owned by worker H3 (Phase H — Skills, verification wave). Covers the
`elattar-flutter-ui-director` skill at `skills/elattar-flutter-ui-director/`.
Companion to the automated suites:

- `test/skill_package_test.dart` — Tests 1–5 (source of truth, frontmatter,
  links, this-repository claims, plugin manifest wiring).
- `test/skill_install_fixture_test.dart` — Test 6 (manual-copy install/remove
  round trip against a `~/.claude/skills/`-shaped fixture).

Both run under the root `flutter test` CI already runs. Neither test suite,
nor this document, was written by the same worker who packaged the skill
(H1) — this is an independent check of H1's output, not a self-report.

## What "verified" means here

Two different bars, kept apart on purpose:

| | Can a machine check it today? | What it actually proves |
| --- | --- | --- |
| **Structural** (below) | Yes — `flutter test`, `gh`, reading files | The skill's files are self-consistent and match this checkout. |
| **Recorded run** (below) | No — needs a human at a real harness | The skill actually loads and activates somewhere an agent runs. |

A green structural section is necessary, not sufficient. Do not read it as
"the skill works" — read it as "nothing here would stop the skill from
working, if a route existed to load it."

---

## Structural findings (filled in — reproducible now)

Run from the repository root, `public-release-v0.0.1-phase-f` at commit
`c90aaa6360a28a105f15cae70e3a91adc23778bb` (working tree, uncommitted at time
of writing — see the PER TEST section of the handoff for the exact
verification transcript). Flutter `3.44.8` stable, Dart `3.12.2`.

### 1. One source of truth

```
flutter test test/skill_package_test.dart
```

`Test 1 — one source of truth` passed: exactly one `SKILL.md` under the
repository (excluding `.git`, `.dart_tool`, `build`, `.idea`, `.superpowers`)
declares `name: elattar-flutter-ui-director`, at
`skills/elattar-flutter-ui-director/SKILL.md`. Mutation-tested by hand during
this work: temporarily restoring a second copy under `.claude/skills/` made
the test fail with both paths named in the failure message; deleting the
copy restored a pass.

### 2. Frontmatter conformance

`Test 2` passed. Frontmatter keys are `name`, `description` — a subset of
the documented `{name, description, license, allowed-tools, metadata,
compatibility}`. `name` is 27 characters, kebab-case. `description` is 463
characters (limit 1024) and contains no `<`/`>`. The rules are implemented
directly in Dart in the test file — no external validator is invoked, so this
result reproduces on a CI runner with nothing installed beyond the Flutter
SDK already required to run the suite.

### 3. The skill's own links resolve

`Test 3` passed. `SKILL.md` links to 7 distinct `references/*.md` files;
all 7 exist on disk; all 7 files present under `references/` are linked from
`SKILL.md`. No dangling link, no orphaned reference file.

### 4. The skill's repo claims are still true

`Test 4` (three sub-tests) passed against `references/system-map.md`, which
is now mode-aware (`## Consumer mode` / `## Repository mode` / a mode
translation table, added after this worker's tests were first drafted).
The classifier separates a this-repository claim from a consumer-project
claim using three signals present in the actual file: the enclosing `##`
heading, an inline `**Consumer mode**` marker (the `Step 0` probe table), and
table column headers containing "consumer" (the mode-translation table).

All six paths the exit gate names explicitly are still claimed as
this-repository sources of truth and still exist:
`lib/elattar_design_system.dart`, `lib/src/foundation/`,
`lib/src/components/`, `lib/src/theme_scope.dart`,
`test/token_guard_test.dart`, `tool/verify/README.md`. Every other
this-repository path claim in the file (`lib/src/effects/`,
`lib/src/motion/`, `example/lib/`, `test/`, `example/test/`, `registry/`,
`packages/elattar_cli/`) also resolves.

Mutation-tested by hand: rewriting `lib/src/theme_scope.dart` to a
nonexistent filename in the file caused both the named-path test and the
general scan to fail, each naming the exact stale path and the source line.
Consumer-only paths (`lib/components/ui/`, `lib/design_system/foundation/`,
`elattar.yaml`, `.elattar/manifest.json`) are correctly excluded from the
this-repository existence check — asserting they existed here would be
wrong, since they describe a CLI-consumer project layout this repository
does not have.

### 5. Plugin manifest wiring

`Test 5` passed. `.claude-plugin/marketplace.json` declares one plugin,
`elattar-design-system`, source `"./"`. `.claude-plugin/plugin.json` sets
`version: "0.0.1"` (semver-shaped) and lists
`skills: ["./skills/elattar-flutter-ui-director"]`. Resolving
`<source>/skills/elattar-flutter-ui-director/SKILL.md` lands on the exact
file Test 1 found — same content, byte for byte. Mutation-tested by hand:
setting `version` to `"not-a-version"` failed with that exact string named as
not semver-shaped.

### 6. Install/remove round trip

```
flutter test test/skill_install_fixture_test.dart
```

Passed. The pure-Dart SHA-256 used for the comparison is verified against
three independently-cross-checked NIST test vectors (`hashlib.sha256`,
`openssl dgst -sha256`, and Node's `crypto` module all agree) in a
self-check group in the same file, so a broken hash implementation cannot
produce a false pass on the round trip below it.

**Important caveat, recorded here rather than glossed over:** as of this
writing, **no external install command is published anywhere in this
repository.** `README.md` states so explicitly ("No external install
command is published yet") and
[`decisions/005-public-skill-location.md`](decisions/005-public-skill-location.md)
records why — the root `LICENSE` is a placeholder, and a copy-paste
instruction with no grant attached is a redistribution invitation nobody has
authorized yet. There is therefore no published prose for this test to
parse. What it verifies instead is the *mechanism* a future manual-copy
instruction can only ever describe correctly: a plain recursive copy of
`skills/elattar-flutter-ui-director/` (the single source of truth Test 1
found) into a fixture shaped like `~/.claude/skills/`, and a plain recursive
delete. Confirmed: the installed tree has exactly the published file list
(no missing, no extra files), every file is sha256-identical to the source,
a sibling already-installed skill in the fixture is untouched by install,
and after removal the installed skill's directory is gone while the sibling
remains byte-for-byte unchanged. If a published manual-copy instruction ever
does something other than a plain recursive copy/delete of that exact
directory (a symlink, an archive, a different destination name), this test's
assumption needs re-pointing at the actual published prose, and this
document needs the caveat updated.

### Repository visibility

```
gh repo view ELATTAR-Ayoub/flutter-design-system --json visibility,isPrivate
```

```json
{"isPrivate":true,"visibility":"PRIVATE"}
```

Checked 2026-08-23. **The repository is private.** Every GitHub-based install
command — `/plugin marketplace add ELATTAR-Ayoub/flutter-design-system`,
`git clone https://github.com/...`, a raw-file fetch, an installer pointed at
the GitHub URL — is unverifiable end to end for anyone who is not already
authorized against this repository, and unusable by anyone else at all. This
is exactly the failure mode Finding 2 named for the site's now-retired
`npx skills add ELATTAR-Ayoub/flutter-design-system` line: do not publish a
command that depends on reachability nobody outside the owner currently has.

### A dead end worth recording, so it is not retried

This worker checked whether the `ListPlugins` / `SearchPlugins` tools
available in this session could stand in for a real `/plugin install`
transcript. They cannot: those tools query claude.ai's own org-level plugin
catalog (`ListPlugins(keywords: ["elattar", "flutter design system"])`
returned zero results, as expected), which is a different system from
Claude Code's local `.claude-plugin/marketplace.json` mechanism invoked by
the `/plugin marketplace add` / `/plugin install` slash commands in an
interactive CLI session. There is no tool available to this agent that
performs the equivalent of typing those slash commands into a harness and
reading back its skill listing. That gap is real, not a missing integration
this document should paper over.

---

## What is structural vs. what needs the repo reachable

Stated explicitly, per the brief:

**Provable now, independent of repository visibility** (all of Section
"Structural findings" above):
- One source of truth, frontmatter conformance, link resolution, repo-claim
  accuracy, plugin manifest wiring, and the install/remove mechanism.
- A **local-path** plugin route (`/plugin marketplace add <path-to-this-clone>`
  run against a clone or working copy someone already has on disk) — this
  needs a human at a harness, but it does *not* need the repository to be
  public, since it never asks GitHub for anything.
- The in-repo, no-install route (`AGENTS.md` at the repository root) — also
  reachable by anyone who already has the clone, public or not.

**Blocked on the repository becoming public:**
- `/plugin marketplace add ELATTAR-Ayoub/flutter-design-system` (GitHub-form
  marketplace add).
- Any install command that clones, fetches, or curls from
  `github.com/ELATTAR-Ayoub/flutter-design-system` on a machine that is not
  already authorized.
- A GitHub-based manual-copy instruction (`git clone ...; cp -r ...`) — moot
  regardless, since no such instruction is published yet (LICENSE gate).

**Blocked on the owner's licensing decision**, independent of visibility:
- Any published manual-copy instruction at all. See
  [`decisions/005-public-skill-location.md`](decisions/005-public-skill-location.md)
  §"Publication gate".

---

## Recorded runs (not yet collected)

Each row below is a template. Do not fill a row from memory, a prior
session, or what "should" happen — run the exact command on the exact
harness, then paste what the harness actually printed, including the
harness's own skill listing (the check that fails today for the old
`.agents/skills/` path, per Finding 1). An unfilled row means the route is
not published; say so rather than leaving the reader to guess why a link is
missing.

### Route A — Claude Code plugin, local path (does not need the repo to be public)

```
/plugin marketplace add <absolute-path-to-this-clone>
/plugin install elattar-design-system
```

| Field | Value |
| --- | --- |
| Harness + version | _(e.g. Claude Code x.y.z — run `claude --version`)_ |
| Date | _(YYYY-MM-DD)_ |
| Operator | _(who ran it)_ |
| Exact commands run | _(paste, including the marketplace path used)_ |
| Exact output | _(paste verbatim, including any errors)_ |
| Proof of activation | _(paste the harness's own skill listing — e.g. `/plugin list` or equivalent — showing `elattar-flutter-ui-director` present)_ |
| Result | _(PASS / FAIL — and if FAIL, what broke)_ |

### Route B — Claude Code plugin, GitHub form (BLOCKED — repository is private)

```
/plugin marketplace add ELATTAR-Ayoub/flutter-design-system
/plugin install elattar-design-system
```

Do not attempt this route until `gh repo view ELATTAR-Ayoub/flutter-design-system
--json isPrivate` returns `false`. Re-run the visibility check above and
update this row only after it flips.

| Field | Value |
| --- | --- |
| Status | **BLOCKED** — repository private as of 2026-08-23 |
| Harness + version | _(pending)_ |
| Date | _(pending)_ |
| Exact commands run | _(pending)_ |
| Exact output | _(pending)_ |
| Proof of activation | _(pending)_ |
| Result | _(pending)_ |

### Route C — Manual copy (BLOCKED — no command is published)

No install command exists to test. `README.md` prints none by design; see
the LICENSE gate above. This row stays blocked structurally, not just
un-run — there is nothing yet for a human to type. Once the owner chooses a
license and H1 (or whoever owns `README.md` at that point) publishes an
exact command, add it here, then run it against a fresh
`~/.claude/skills/`-equivalent directory on a real machine and record the
result. `test/skill_install_fixture_test.dart` verifies the underlying
copy/delete mechanism today; it does not and cannot verify prose that does
not exist.

| Field | Value |
| --- | --- |
| Status | **BLOCKED** — no command published (LICENSE placeholder) |
| Published command | _(none — fill in once README.md prints one)_ |
| Harness / agent | _(pending)_ |
| Date | _(pending)_ |
| Exact commands run | _(pending)_ |
| Proof of activation | _(pending — e.g. the agent's own "loaded skills" or config listing)_ |
| Result | _(pending)_ |

### Route D — `AGENTS.md`, no install step (does not need the repo to be public)

Clone (or open an existing working copy of) the repository and start an
agent session inside it. No copy, no plugin command — `AGENTS.md` at the
repository root is expected to route the agent into
`skills/elattar-flutter-ui-director/SKILL.md` on its own.

This route needs a transcript as much as the others: Finding 1 in Phase H's
scope established that the skill's *only* activation before this phase was
"an agent reads `AGENTS.md` by hand," and that was never actually
demonstrated end to end. "The file is there and an agent could read it" is
not the same claim as "an agent, unprompted, did read it and changed its
behavior accordingly."

| Field | Value |
| --- | --- |
| Harness + version | _(pending — record once per harness tested, e.g. Claude Code, Codex CLI)_ |
| Date | _(pending)_ |
| Operator | _(pending)_ |
| Prompt given to the agent | _(pending — the task, not a hint to go read AGENTS.md)_ |
| Evidence the agent read `AGENTS.md` and the skill | _(pending — quote the agent's own tool calls / file reads)_ |
| Evidence skill guidance changed the agent's behavior | _(pending)_ |
| Result | _(pending)_ |

---

## Handoff note

This document and the two test files are the H3 deliverable for Phase H. It
does not, and cannot, close the loop that ships an install route to a real
user — that is Route A/B/D transcripts plus the owner's licensing decision
for Route C, none of which an automated worker can produce honestly. Publish
nothing that claims otherwise.
