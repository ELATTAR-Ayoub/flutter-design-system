# Phase H — Skills report

> **Historical snapshot.** This report records what was true on the date and
> at the commit named in it. It is kept for the reasoning, not as a statement
> of the current release — several findings below were closed afterwards. For
> what is true now, read
> [`v0.0.1-public-release-baseline.md`](v0.0.1-public-release-baseline.md),
> which classifies every finding here against the commit that fixed it, and
> the root [`CHANGELOG.md`](../../../../CHANGELOG.md).

## Status

Complete, pending supervisor review and commit. The Wave 0–3 worker output was
already committed and green at `594bb25`; this report closes the phase with the
shared-file integration on top of it, uncommitted at time of writing.

The capability is done and wired into the public site. Three publication
blockers are **not** closed and are not this phase's to close — they are owner
decisions, recorded below and carried into Phase I.

## Objective

Make the `elattar-flutter-ui-director` skill real — installable by a route that
exists, truthful about the repository it describes — and document it on the
public site at `/skills`, replacing the placeholder Phase G left behind.

Concretely:

- Move the skill to a path a harness actually scans, and make the repository its
  own single-plugin Claude Code marketplace.
- Teach the skill to tell a checkout of this repository apart from a consumer
  project that installed the design system with the CLI.
- Resolve the Codex support claim.
- Build the real Skills page on the install routes that actually exist, with the
  skill's own files rendered from the one copy on disk.
- Separate what CI can prove from what only a human at a harness can.

## The finding that framed the phase: the skill was inert

Before this phase the skill sat at `.agents/skills/elattar-flutter-ui-director/`.

No harness scans that path. Claude Code reads `~/.claude/skills/`, a
repository's `.claude/skills/`, and plugin marketplaces — `.agents/` is none of
them. The skill's only activation was `AGENTS.md` line 3 telling an agent to
open the file by hand, and that was never demonstrated end to end either.

So the honest statement of the starting position is not "the skill needed
tidying". It is: **the skill had never been loaded, as a skill, by anything.**
It carried no version, which made "update" an unverifiable claim as well.
Moving it is what made it real for the first time, and that is why the phase
existed.

## Completed work

- **Promotion and packaging (H1).** `.agents/skills/elattar-flutter-ui-director/`
  moved to `skills/elattar-flutter-ui-director/`, with
  `.claude-plugin/marketplace.json` (marketplace `elattar`) and
  `.claude-plugin/plugin.json` (plugin `elattar-design-system`, version `0.0.1`,
  `skills: ["./skills/elattar-flutter-ui-director"]`, source `"./"`). One
  directory now serves four consumers — the repository's own agents, the plugin
  route, a manual copy, and the website's file tree — with zero copies.
  `AGENTS.md`, `README.md`, `CONTRIBUTING.md` and
  `docs/elattar-flutter-ui-director-build.md` follow the new path. Recorded as
  [Decision 005](decisions/005-public-skill-location.md).
- **The Codex claim was deleted, not softened (H1).**
  `.agents/skills/elattar-flutter-ui-director/agents/openai.yaml` is gone
  (`f19d14e`). There is no `.codex-plugin/plugin.json`, no archive step, no
  self-serve install route and no recorded Codex run, so there is no Codex
  support to claim. The site names Claude Code and nothing else, and
  `site_routes_test.dart` now asserts that a search for "codex" does not
  resolve to `/skills`.
- **Dual-mode paths (H1).** `references/system-map.md` gained a Step 0 mode
  probe, a `## Consumer mode` / `## Repository mode` split and a mode
  translation table; `references/verify.md` no longer hardcodes
  `Push-Location example`. A consumer who ran `elattar init` has
  `lib/components/ui/` and `lib/design_system/foundation/`, not
  `lib/src/foundation/`; before this the exit gate would have passed while the
  product failed for every consumer.
- **The Skills page (H2).** `example/lib/skills_docs/catalog.dart` and
  `skills_page.dart`: overview and workflow, supported agents, install/update/
  inspect/remove per route with an explicit "Works today" or "Pending
  verification" badge, the reference file tree, and the version facts. It
  reuses `docs/docs_file_tree.dart`, `docs/docs_code.dart`, `docs/docs_facts.dart`
  and `docs/docs_layout.dart` rather than duplicating them — the hard
  dependency on Phase G's G2 was honoured.
- **The `verifiedCommands` allowlist (H2).** The structural fix for the invented
  command. `SkillsPage` renders commands only from a `SkillDocEntry`, and every
  one of those must appear verbatim in `catalog.dart`'s `verifiedCommands`. A
  command reaches the public site only after a human consciously adds a line to
  that list.
- **CI-provable verification (H3).** `test/skill_package_test.dart` (one source
  of truth; frontmatter conformance re-implemented in Dart rather than shelled
  out to a machine-local validator; every relative link resolves; every
  repository path the skill names still exists; plugin manifest wiring lands on
  the same `SKILL.md`) and `test/skill_install_fixture_test.dart` (install/remove
  round trip against a `~/.claude/skills/`-shaped fixture, sha256 per file,
  with the pure-Dart hash self-checked against NIST vectors). Both sit in the
  root suite CI already runs, and neither was written by the worker who packaged
  the skill.
- **The verification ledger (H3).**
  [`skill-install-verification.md`](skill-install-verification.md) separates
  "structural, provable now" from "needs a human at a harness", and keeps four
  route templates deliberately **empty**.
- **Site integration (W2).** `/skills` mounts the real page with the skill's own
  bytes, `PublicSkillsPage` is deleted, the search index carries the skill's
  topics, and the `npx` guard is carried forward onto the real route.

## Files changed

### Added (Waves 0–3, already committed)

- `skills/elattar-flutter-ui-director/**` (moved from `.agents/skills/…`)
- `.claude-plugin/marketplace.json`
- `.claude-plugin/plugin.json`
- `example/lib/skills_docs/catalog.dart`
- `example/lib/skills_docs/skills_page.dart`
- `example/test/skills_docs_test.dart`
- `test/skill_package_test.dart`
- `test/skill_install_fixture_test.dart`
- `docs/superpowers/reports/public-release/decisions/005-public-skill-location.md`
- `docs/superpowers/reports/public-release/skill-install-verification.md`

### Deleted (Waves 0–3, already committed)

- `.agents/skills/elattar-flutter-ui-director/agents/openai.yaml`

### Integrated (Wave 2, single writer — this report's change)

- `pubspec.yaml` (repository root) — two asset lines, see Decisions below
- `example/lib/main.dart`
- `example/lib/site/site_routes.dart`
- `example/lib/site/pages/public_pages.dart`
- `example/test/public_pages_test.dart`
- `example/test/site_routes_test.dart`

`example/pubspec.yaml` is deliberately **not** among them. The Shots wiring
declared its sources there; the skill's could not be declared there at all, for
the reason the next section gives.

## Agent assignments

| Worker | Task | Ownership | Result |
| --- | --- | --- | --- |
| H1 | Directory move, plugin manifests, Codex deletion, dual-mode path fix, version stamp, docs path updates, Decision 005 | `skills/`, `.claude-plugin/`, `AGENTS.md`, `README.md`, `CONTRIBUTING.md` | Accepted (`f19d14e`, `c90aaa6`) |
| H2 | Skills catalog, `SkillsPage`, `verifiedCommands` allowlist, widget suite | `example/lib/skills_docs/`, `example/test/skills_docs_test.dart` | Accepted (`594bb25`) |
| H3 | Root-suite structural tests and the recorded-run ledger | `test/skill_package_test.dart`, `test/skill_install_fixture_test.dart`, `skill-install-verification.md` | Accepted (`3817808`) |
| W2 | Route wiring, source loading, placeholder retirement, search integration, test repair, phase close | `main.dart`, `site_routes.dart`, `public_pages.dart`, the two shared tests, root `pubspec.yaml` | This report |

The serialization held: every shared file has one author, and the three Wave
files that would have collided — the route table, the public pages and
`public_pages_test.dart` — were all deferred here. `skills_docs_test.dart`
(H2's) and `public_pages_test.dart` (W2's) overlap in subject on purpose and
are described under Decisions.

## Decisions made

**The skill's source reaches the page as a *package* asset, not a copy.**

This is the phase's one genuinely new mechanism, and the constraint that forced
it is real: an asset path may not climb above its own project root, and
`skills/elattar-flutter-ui-director/` sits *above* `example/`. The Shots
solution — declare the sources in `example/pubspec.yaml` — cannot work here.
A widget cannot read the filesystem on web or mobile either, which is exactly
where `/skills` is read.

`skills/` is, however, inside the **package**'s root. `example/` depends on
`elattar_design_system` by path, and a package's declared assets are bundled
into every dependent app under `packages/<name>/<path>` — the same mechanism the
voice orb's perlin field already uses, and which `example/pubspec.yaml` already
documents in prose. So two lines were added to the repository-root
`pubspec.yaml`:

```yaml
    - skills/elattar-flutter-ui-director/
    - skills/elattar-flutter-ui-director/references/
```

and `main.dart`'s `skillSourceAssetKey` prefixes `packages/elattar_design_system/`
onto a `SkillDocEntry.sourcePath`. That is the whole translation.

Chosen over the alternatives because it is the only one with **zero copies**:

- *A build step copying `skills/` into `example/assets/`* — rejected. It creates
  a second committed tree, a generation step a contributor can forget, and
  review noise, in exchange for nothing the package-asset route does not already
  give. Decision 005's entire argument is "the cheapest correct answer to 'do
  not let two copies drift' is not to make a second copy."
- *A generated Dart map* — rejected for the same reason, plus 19 KB of Markdown
  embedded in a source file.
- *A symlinked asset directory* — rejected: it depends on `core.symlinks` and
  Developer Mode on Windows, which is this program's primary platform.
- *A hand-copied Dart literal* — ruled out outright by the brief and by the
  Phase G precedent. It drifts on the first edit.

**Nothing needs regenerating.** There is no build step to run and no generated
file to review. A contributor who edits the skill changes exactly one file, and
the page shows the change on the next build. The only thing that can break this
is deleting an asset line from the root `pubspec.yaml`, and
`public_pages_test.dart` fails loudly when that happens.

The cost, stated plainly: those two lines put ~19 KB of Markdown into the asset
bundle of every application that depends on `elattar_design_system`, not only
the docs app. That is a real if small tax on consumers for a file they will
never render. It was accepted because the package is `publish_to: 'none'`, the
skill is a first-class part of what this repository ships, and the alternative
was a duplicate tree — which this program has consistently judged the worse
failure.

**Proof, not assertion.** The claim "the bytes rendered are the real bytes" is
checked three ways: `public_pages_test.dart` compares what the production
loader returns against `File.readAsStringSync` for every one of the eight files;
it then asserts the mounted route hands exactly that map to `SkillsPage` and
that the file tree renders the first file verbatim as a single `Text`; and the
release web build was inspected directly — the bundled
`assets/packages/elattar_design_system/skills/elattar-flutter-ui-director/SKILL.md`
is sha256-identical to `skills/elattar-flutter-ui-director/SKILL.md`
(`E174F9A3…D66B64`).

**`/skills` is resolved from the catalog, not from a switch arm.**
`SkillDocEntry.route` is the literal `/skills` — one skill, no index/detail
split, and none was invented. So `publicPageFor` reads
`skillDocForRoute(route)` immediately after `shotDocForRoute(route)`, exactly as
the Shot detail route does, and the `skillsRoute =>` arm is gone rather than
restating the same fact twice.

**One spelling of `/skills`.** `publicSkillsRoute` in `public_pages.dart` was a
second copy of `site_routes.dart`'s `skillsRoute`. It is deleted and its one
remaining caller imports the real constant — the same correction Phase G made
for `/shots`, applied to the string the Skills placeholder left behind.

**Skill topics are folded into the `/skills` search row, not indexed beside it.**
A component guide and a Shot guide each own a route of their own, so each is a
separate `SearchRoute`. A skill does not: its route *is* `/skills`. Indexing it
separately would put two rows with the same path in the results and make the
search box answer "skills" twice. `_searchKeywordsFor` therefore merges the
skill's reference titles (the topics a reader searches by — "system map",
"traps", "verify", "state & accessibility"), its slug and title, its supported
agents, and its install-route ids into the existing destination.
`site_routes_test.dart` asserts both halves: exactly one `/skills` row, and
every reference title finding it.

**`siteRoutes` is still exactly five.** Nothing in this phase added a
destination; the header contract is unchanged and `site_routes_test.dart` still
asserts the list literally.

## The `npx` guard

The site shipped `npx skills add ELATTAR-Ayoub/flutter-design-system` — a
command nothing in this repository implements, publishes or verifies. Phase G
deleted the line and left a guard behind it. That guard had to survive this
phase intact, and it does, in three places:

1. **`example/test/public_pages_test.dart`** — the route-level guard, and the
   strongest of the three. It loads the skill's real source first, mounts
   `publicPageFor(skillsRoute)`, and asserts `find.textContaining('npx')`
   finds nothing. Because the real bytes are loaded, this now also covers the
   skill's own Markdown: an `npx` command arriving through `SKILL.md` or any
   reference file fails here.
2. **`example/test/skills_docs_test.dart`** (H2) — the widget-level guard, plus
   `verifiedCommands contains no npx text` at the data level.
3. **`example/lib/skills_docs/catalog.dart`** (H2) — the structural guard. The
   allowlist is the thing that makes 1 and 2 more than whack-a-mole.

The old assertion `find.byType(ElAgentCodeBlock), findsNothing` was **not**
carried forward literally, and this is a strengthening rather than a weakening.
That assertion was a proxy, available only because the placeholder had no
install section at all: "renders no code block" stood in for "prints no
unverified command". The real page prints commands legitimately, so the proxy
is replaced by the proposition it stood for — *every* command block rendered at
`/skills` must appear in `verifiedCommands`. The new check fails on cases the
old one could not even express: a plausible-looking but unvetted command, or a
command silently edited in the catalog without a matching allowlist line. It is
scoped to the `skill-command:` keys `_CommandBlock` assigns, because
`DocsSelectableCodeBlock` also renders reference-file source in the file tree,
and 6 KB of `SKILL.md` is not a published command.

## Test repairs

| Test | Change | Why it is not a weakening |
| --- | --- | --- |
| `public_pages_test.dart` — "skills stays legible at a narrow viewport and publishes no install command" | Split into four tests in a new `the skills route` group, all pumping `publicPageFor(skillsRoute)` instead of `const PublicSkillsPage()` | The subject moved from a deleted widget to the mounted route, which is the thing that actually ships. Everything the old test asserted is still asserted, on the real page. |
| …"resolves to the real Skills page, not the placeholder" (new) | Asserts `SkillsPage` with the catalog's slug, and that `find.text('A shared way of working.')` finds **nothing** | The retired page's own copy is now a negative assertion, so a rewrite that quietly restores the hand-written summary fails instead of passing by resemblance. |
| …"stays legible at a narrow viewport" | Same 390x844 sizing, real view metrics, `_skill.title` read from the catalog rather than a literal | Identical coverage; a renamed skill now fails at the catalog instead of here. |
| …"publishes no npx text and no command outside the allowlist" | `find.textContaining('npx')` retained verbatim; `ElAgentCodeBlock findsNothing` replaced by the `verifiedCommands` allowlist check over every rendered command block | See the section above. The `npx` assertion is unchanged and now runs against a page carrying the skill's real Markdown, so it covers strictly more text than before. |
| …"renders the real bytes of the skill on disk" (new) | Compares the production loader's output to `File.readAsStringSync` for all eight files, asserts the route hands that exact map to `SkillsPage`, and asserts the tree renders the first file verbatim | New coverage. This is the anti-drift test the source-loading approach requires. |
| `site_routes_test.dart` — "indexes the skill under the Skills destination, not beside it" (new) | Exactly one `/skills` search row; keywords contain the slug; `SkillDocEntry.route == skillsRoute` | New coverage. Guards against the duplicate-row failure the fold-in decision avoids. |
| `site_routes_test.dart` — "skill topics are searchable" (new) | Every reference title finds `/skills`; every supported agent finds it; "codex" does not | New coverage, and the machine-checkable form of the deleted Codex claim. |

`skills_docs_test.dart` (H2's) was not touched. The overlap with
`public_pages_test.dart` is deliberate and the split is the same one Phase G
used: `skills_docs_test.dart` owns `SkillsPage` in isolation, with synthetic
`fileSource`; `public_pages_test.dart` owns what `/skills` mounts, with the real
bytes loaded through the asset bundle.

## Verification performed

Run from `public-release-v0.0.1-phase-f`, HEAD `594bb25`, with the Wave 2
integration in the working tree. Final line of each command, verbatim:

| Command | Final line |
| --- | --- |
| `flutter analyze` (root) | `No issues found! (ran in 20.5s)` |
| `flutter test` (root) | `01:01 +1482: All tests passed!` |
| `flutter analyze` (example) | `No issues found! (ran in 13.4s)` |
| `flutter test` (example) | `04:53 +968: All tests passed!` |
| `flutter build web --release --base-href /flutter-design-system/` (example) | `√ Built build\web` |

Root suite `1473 → 1482` (+9, H3's structural tests). Example suite `943 → 968`
(+25, H2's widget suite plus this phase's route and search tests).

The web build reports the known CupertinoIcons font warning and Flutter's own
informational Wasm dry-run suggestion. Nothing else. Run it from PowerShell,
not Git Bash: MSYS rewrites `--base-href /flutter-design-system/` into an
absolute Windows path and the build refuses it.

One additional check, outside the standard gate, because the source-loading
approach is new:

```
sha256 build/web/assets/packages/elattar_design_system/skills/…/SKILL.md
  == sha256 skills/elattar-flutter-ui-director/SKILL.md   → True
```

The release bundle carries the real file, not a copy of it.

The registry was **not** regenerated. Phase H added no registry item — a skill
goes into an agent configuration directory, not `lib/` — so
`registry/generated/latest/` is untouched and still describes 20 items.

## Supervisor review

No mid-wave correction was issued in the integration wave. Two things were
found while reading the accepted work and are recorded in the audit below
rather than fixed, because both sit in files this wave must not edit.

## Independent audit

| Finding | Severity | Fix | Status |
| --- | --- | --- | --- |
| The skill was at a path no harness scans and had never been loaded | High — the capability did not exist | Moved to `skills/`, repo made a plugin marketplace | Closed |
| Codex support claimed with no install route and no recorded run | High — a false support claim | `agents/openai.yaml` deleted; only Claude Code is named; a search for "codex" must not resolve to `/skills` | Closed |
| The skill routed agents to repository paths a CLI consumer does not have | High — exit gate passes, product fails | Mode discrimination in `system-map.md` and `verify.md` | Closed |
| The skill carried no version, making "update" unverifiable | Medium | `plugin.json` version `0.0.1`, parity-tested against the catalog | Closed |
| `/skills` served a hand-written placeholder that could drift from the skill | Medium | `SkillsPage` reads the catalog; the file tree reads the skill's own bytes | Closed |
| An invented install command could return to the site | High — it shipped once already | `verifiedCommands` allowlist plus three guards, one of them at the mounted route with real source loaded | Closed |
| Two spellings of `/skills` (`publicSkillsRoute`, `skillsRoute`) | Low | Collapsed to `skillsRoute` | Closed |
| The site publishes `/plugin marketplace add ELATTAR-Ayoub/flutter-design-system` — a **GitHub-form** command against a repository that is currently **private** | Medium | Not fixed. The command is badged "Pending verification" with an explicit blocker note and the licensing statement above it, which is materially different from the unlabelled `npx` line — but a reader who runs it today gets a failure, and the Phase H scope's own blocker says a GitHub-based command is unverifiable end to end while the repository is unreachable. The catalog is accepted Wave work and outside this wave's edit scope. | **Open — supervisor decision** |
| `skill-install-verification.md` states "no external install command is published anywhere in this repository" and "`README.md` prints none by design". The first half stopped being true at `594bb25`, when the Skills page shipped three routes' worth of commands | Low — a stale sentence in a verification document, not a product defect | **Fixed in this same commit (`cb0cc2a`)**, which this report documents in its own summary above: `skill-install-verification.md` now reads "`README.md` publishes no external install command... The Skills page added in `594bb25` does render commands for three routes...". This row was left marked Open by mistake when the table was drafted; corrected per Phase I finding F23. | Closed (`cb0cc2a`) |
| CI runs neither the registry validator nor the `packages/elattar_cli` suite | Medium | Carried from Phase G, unchanged | Open at time of writing — **closed in `48c390b`**, an ancestor of Phase G's own close (`7860c58`), so this was already false when Phase G's report shipped it and was copied here unverified. `ci.yml:42-64` runs the CLI suite plus registry build/validate. Corrected per Phase I finding F22. |

## Known limitations

- **Publication is blocked by three independent gates**, and any one of them is
  enough on its own:
  1. `LICENSE` is the string `TODO: Add your license here.` A plugin marketplace
     entry and a "copy this into your agent config" instruction are both
     invitations to redistribute, with no grant attached. Owner decision.
  2. `publish_to: 'none'` in the root `pubspec.yaml`. Publication and deployment
     are not authorized.
  3. The repository is **private** — confirmed live on 2026-08-23 with
     `gh repo view ELATTAR-Ayoub/flutter-design-system --json visibility,isPrivate`
     returning `{"isPrivate":true,"visibility":"PRIVATE"}`. Every GitHub-based
     install command is therefore unverifiable end to end and unusable by anyone
     not already authorized against this repository.
- **The four "Recorded runs" rows in
  [`skill-install-verification.md`](skill-install-verification.md) are genuinely
  unfilled, and a human has to fill them.** Route A (local-path plugin), Route B
  (GitHub-form plugin, blocked on visibility), Route C (manual copy, blocked on
  the LICENSE gate — there is no published command to test yet) and Route D
  (`AGENTS.md`, no install step). No agent in this program can type a slash
  command into a separate interactive harness session and read back its own
  skill listing; that gap is real and was not papered over. **A route with no
  transcript is not published.** Note that Route A and Route D need only a clone
  someone already has — neither is blocked on the repository becoming public.
- The `ListPlugins` / `SearchPlugins` tools available to agents in this program
  query claude.ai's org-level plugin catalog, which is a different system from
  Claude Code's local `.claude-plugin/marketplace.json` mechanism. They cannot
  stand in for a real `/plugin install` transcript. Recorded so it is not
  retried.
- Version compatibility beyond "v0.0.1, first release" is not claimed. IA §11.2
  item 10 cannot be honoured literally on a first release, and the page says so.
- Visual review of `/skills` is by widget test and by reading, not by golden
  image. This repository has no golden infrastructure (Phase G, Ruling 5).
- Browser visual and accessibility captures for `/skills` are not done, the same
  carryover the Shots and component routes have.
- The two root-`pubspec.yaml` asset lines add ~19 KB to every dependent
  application's bundle. See Decisions.

## What is next

Phase I. In order:

1. Close the three publication gates — they are one owner decision, one config
   flip and one repository setting, and nothing downstream can be honestly
   announced until all three land.
2. Collect the Route A and Route D transcripts. Both are unblocked today: they
   need a clone someone already has, not a public repository. Filling those two
   rows is the cheapest available proof that the skill actually loads.
3. Once the repository is public, collect Route B; once the LICENSE is chosen,
   publish a manual-copy command and collect Route C.
4. Decide the audit's open GitHub-form-command question above.
5. Clear the standing carryover: `elattar_core` and browser captures for the
   component, Shots and Skills routes. (CI coverage for the registry
   validator and the CLI suite is not carryover — it landed in `48c390b`;
   see the audit table above, corrected per Phase I finding F22.)

## Restart instructions

Read, in order:

1. `docs/superpowers/reports/public-release/STATUS.md`
2. This report
3. `docs/superpowers/reports/public-release/decisions/005-public-skill-location.md`
4. `docs/superpowers/reports/public-release/skill-install-verification.md` —
   in particular the empty "Recorded runs" section
5. `example/lib/skills_docs/catalog.dart` — `verifiedCommands` and why it exists

Then run:

```powershell
flutter analyze
flutter test
Push-Location example
flutter analyze
flutter test
flutter build web --release --base-href /flutter-design-system/
Pop-Location
```
