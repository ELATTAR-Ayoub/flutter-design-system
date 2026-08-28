# Phase G — Shots report

> **Historical snapshot.** This report records what was true on the date and
> at the commit named in it. It is kept for the reasoning, not as a statement
> of the current release — several findings below were closed afterwards. For
> what is true now, read
> [`v0.0.1-public-release-baseline.md`](v0.0.1-public-release-baseline.md),
> which classifies every finding here against the commit that fixed it, and
> the root [`CHANGELOG.md`](../../../../CHANGELOG.md).

## Status

Accepted with follow-up. Committed as `7860c58`, "feat(shots): wire Shots into
the site and close Phase G".

The Shots capability is complete and wired into the public site. The follow-up
items are the Phase G entry-gate carryover recorded in the scope plan
(licensing, `elattar_core`, browser captures), not defects in the phase's own
work.

## Objective

Deliver "Shots": installable, product-neutral application compositions assembled
from registry components, documented on the public site and installable through
the CLI.

Concretely:

- A registry `shot` item kind that installs into `@app/`, plus the import
  rewriting that makes an installed Shot compile in a consumer project.
- Three Shots.
- A filterable Shots index, a per-Shot detail page, and a chrome-free preview.
- Route, search and catalog integration, retiring the placeholder pages the
  real ones replace.

## Completed work

- **Registry `shot` kind (W0-A).** `registry/shots/` is scanned, `@app/` targets
  are honoured, and the import transformer rewrites a Shot's umbrella import
  into the consumer's generated barrels. Ruling 3 recorded that a Shot installed
  before this change compiled only in a project that already depended on the
  published package.
- **Three Shots.** `settings-profile`, `sign-in-flow`, `dashboard-overview` in
  `example/lib/shots/`, each with a registry manifest.
- **Shots index.** `/shots` is `ShotsIndexPage`: every catalog entry as a card,
  filterable by family and by platform, with an empty state and a reset.
- **Shot detail.** `/shots/<slug>` is `ShotDetailPage`: install command, file
  tree, dependency list, preview link, sidebar, breadcrumb and prev/next.
- **Chrome-free preview.** `/shots/<slug>/preview` mounts one composition on the
  page background, with no header, footer or search.
- **Real source on the page.** The compositions are declared as Flutter assets,
  so the detail page's file tree shows the bytes the generator hashes and the
  CLI copies rather than a transcription of them.
- **Placeholder retirement.** `PublicShotsPage` (four hand-written cards
  pointing at design-system specimens) and the invented `npx skills add …`
  command are gone.
- **Catalog/manifest parity.** A new test cross-checks the two places a Shot's
  dependencies and files are declared.
- **Registry regenerated.** 20 items, schema v1, validated.

## Files changed

### Added

- `example/lib/shots/settings_profile/settings_profile_shot.dart`
- `example/lib/shots/sign_in_flow/sign_in_flow_shot.dart`
- `example/lib/shots/dashboard_overview/dashboard_overview_shot.dart`
- `example/lib/shots_docs/catalog.dart`
- `example/lib/shots_docs/shots_index_page.dart`
- `example/lib/shots_docs/shot_detail_page.dart`
- `example/lib/shots_docs/shot_preview_host.dart`
- `example/lib/docs/docs_file_tree.dart`
- `registry/shots/settings-profile.json`
- `registry/shots/sign-in-flow.json`
- `registry/shots/dashboard-overview.json`
- `example/test/shots_index_test.dart`
- `example/test/shot_detail_test.dart`
- `example/test/shots_preview_test.dart`
- `example/test/shots_source_guard_test.dart`
- `example/test/docs_file_tree_test.dart`
- `example/test/shots_catalog_parity_test.dart`
- `registry/generated/latest/versions/{settings-profile,sign-in-flow,dashboard-overview}/`

### Integrated (Wave 2, single writer)

- `example/lib/main.dart`
- `example/lib/site/site_routes.dart`
- `example/lib/site/pages/public_pages.dart`
- `example/pubspec.yaml`
- `example/test/site_routes_test.dart`
- `example/test/public_pages_test.dart`
- `registry/generated/latest/index.json`
- `registry/generated/latest/registry.json`

Regeneration also touched about thirty other files under
`registry/generated/latest/` without changing their content: the generator
writes LF and the working copy is CRLF, so `git diff` reported nothing for them.
The three Shots are the whole of the real change — 144 added lines across
`index.json` and `registry.json`, plus the three new `versions/<shot>/`
directories. Expect the same harmless churn on any future regeneration.

### Corrected during Wave 2 review

- `example/lib/shots_docs/shots_index_page.dart` (duplicate typedef removed)
- `example/lib/shots_docs/shot_detail_page.dart` (duplicate route constant removed)
- `example/test/shots_index_test.dart` (import follows the surviving typedef)

## Agent assignments

| Worker | Task | Ownership | Result |
| --- | --- | --- | --- |
| Supervisor | `shots_docs/catalog.dart` — the metadata contract | Wave 0, serial | Accepted |
| W0-A | Registry `shot` kind, `@app/` prefix, `registry/shots/` scan, package-mode copy arm, import rewriting | `tool/registry_builder/`, `packages/elattar_cli/` | Accepted (`158e9eb`) |
| G1 | Filterable Shots index + test | `shots_docs/shots_index_page.dart` | Accepted (`7cac208`) |
| G2 | `DocsFileTree` primitive + Shot detail page + tests | `docs/docs_file_tree.dart`, `shots_docs/shot_detail_page.dart` | Accepted (`8145ed5`) |
| G3 | Three compositions, preview host, manifests, preview and source-guard tests | `example/lib/shots/`, `shots_docs/shot_preview_host.dart`, `registry/shots/` | Accepted (`6c94bac`) |
| W2 | Route wiring, source loading, placeholder retirement, test repair, parity test, registry regeneration, phase close | `main.dart`, `site_routes.dart`, `public_pages.dart`, the three tests, `registry/generated/` | This report |

Wave 1 was genuinely parallel: three workers, zero shared files. Everything that
could not be parallelised — the route table, the public pages, the shared tests
and the generated registry — was deferred to a single Wave 2 writer, which is
why `registry/generated/latest/**` has one author and no merge conflict.

## Decisions made

**The preview route is resolved above the `siteRouteFor` guard.**
`/shots/<slug>/preview` begins with the public shots prefix. Left to fall
through, the guard would resolve it as a site destination and wrap the
composition in the header, footer and search chrome the preview exists to omit.
The arm is therefore first in the switch, and `siteRouteFor` deliberately
returns null for a preview route so the two halves cannot disagree. Both halves
are asserted: `site_routes_test.dart` for the data, `public_pages_test.dart` for
the mounted tree.

**Shot sources are Flutter assets, not generated Dart.**
`ShotDetailPage` takes its file contents as data, because a widget cannot read
the filesystem on web or mobile — which is exactly where the page is read. Of
the two ways to supply that data, declaring the compositions as assets and
loading them through `rootBundle` was chosen over generating a Dart map at build
time: the asset *is* the file the registry hashes, so there is no second copy to
drift, no generation step to forget, and no committed machine output to review.
A hand-copied Dart literal was ruled out outright — it would drift on the first
edit and the source guard would not catch it.

**One spelling of `/shots`.**
Three copies existed: `publicShotsRoute` in `public_pages.dart`, a private
`_shotsIndexRoute` in `shot_detail_page.dart`, and `shotsRoute` in
`site_routes.dart`. `shotsRoute` survives — it is what the header nav, the
search index and the router already read — and the other two are gone. The
`PublicNavigate` typedef was duplicated in the index page on the stated but
false premise that the original was private; the duplicate is gone too.

Both fixes point a `shots_docs/` page at a `site/` library — the detail page at
`site/site_routes.dart` for the route, the index page at
`site/pages/public_pages.dart` for the typedef. That direction is the right one
and introduces no cycle: `site_routes.dart` reads `shots_docs/catalog.dart`, and
the catalog imports nothing of its own.

**The Skills page publishes no install command.**
`PublicSkillsPage` rendered `npx skills add ELATTAR-Ayoub/flutter-design-system`,
which nothing in this repository implements, publishes or verifies. Deleting the
page's code block is the fix; the page now states plainly that the skill is read
from the repository and that there is no published install route yet. A test
asserts the page renders no code block at all, so the command cannot return by
accident. The real Skills page is Phase H.

**Catalog and manifests are cross-checked.**
The scope plan carried this as a known risk: a Shot's dependencies and files are
declared twice, and nothing compared them. `shots_catalog_parity_test.dart` now
does, per Shot, including that the bundled source matches the file on disk
byte-for-byte.

## Verification performed

Run from a clean working tree at `public-release-v0.0.1-phase-f`, in the order
the release gate specifies.

| Command | Result |
| --- | --- |
| `dart run tool/registry_builder/bin/build.dart .` | `Generated 20 item(s) at .\registry\generated\latest.` |
| `dart run tool/registry_builder/bin/validate.dart registry/generated/latest/registry.json` | `Registry valid: 20 item(s), schema v1.` |
| `flutter analyze` (root) | `No issues found! (ran in 14.5s)` |
| `flutter test` (root) | `00:56 +1473: All tests passed!` |
| `flutter analyze` (example) | `No issues found! (ran in 9.7s)` |
| `flutter test` (example) | `05:00 +943: All tests passed!` |
| `flutter build web --release --base-href /flutter-design-system/` | `√ Built build\web` |

The release web build is the gate. The known CupertinoIcons warning is
unchanged and non-blocking; nothing else was reported beyond Flutter's own
informational Wasm dry-run suggestion.

Run the web build from PowerShell, not from Git Bash. MSYS path conversion
rewrites `--base-href /flutter-design-system/` into
`C:/Program Files/Git/flutter-design-system/`, and the build stops with
"--base-href should start and end with /". That is a shell artifact, not a
build failure, but it will read as one.

This closes the Phase F verification follow-up: the full suite and the release
web build both completed on a fresh runner, with no repeat of the Windows
launcher stall recorded in the Phase F report.

## Supervisor review

One correction was issued mid-Wave-2 and applied before completion: an
independent review found that `shots_index_page.dart` declared a second
`PublicNavigate` typedef justified by a comment that was factually wrong, and
that `/shots` had three constants across three files. The first Wave 2 draft
routed around the typedef collision with a `show` clause in `main.dart`; that
was rejected as papering over the duplication. Both duplicates were deleted at
the source, with narrow authorisation to edit the two Wave 1 files for that
purpose only.

## Independent audit

| Finding | Severity | Fix | Status |
| --- | --- | --- | --- |
| Invented `npx skills add …` published on `/skills` | High — the IA plan forbids publishing an unverified command | Page rewritten with no install command; test forbids a code block on that page | Closed |
| Two pages competing to serve `/shots` | Medium | `PublicShotsPage` deleted; `ShotsIndexPage` is the only answer | Closed |
| Duplicate `PublicNavigate` typedef with a false justifying comment | Medium | Duplicate deleted; the public one is imported | Closed |
| Three constants spelling `/shots` | Medium | Collapsed to `shotsRoute` | Closed |
| Catalog and manifests never cross-checked | Medium — silent drift between documented and installed dependencies | `shots_catalog_parity_test.dart` | Closed |
| A Shot installed into a consumer project did not compile (Ruling 3) | High | W0-A import rewriting | Closed |
| `rootBundle` caches the `Future`, not the string, so a second `await` of the same asset in a later widget test never completes | Low — test infrastructure | Loader is not memoised; the parity test evicts between tests | Closed |
| CI runs neither the registry validator nor the CLI suite | Medium — Phase G materially grew both | Out of scope for this phase; carried | Open at time of writing — **closed in `48c390b`**, later in this same phase's commit range (`ci.yml:42-64` now runs the `packages/elattar_cli` suite plus registry build/validate). This row was inherited stale into `STATUS.md` and `phase-h-skills.md`; corrected in both per Phase I finding F22. |

## Known limitations

- The three Shots deliberately exclude `premium-surface`; it runs two infinite
  animations that the deterministic-preview gate would have to freeze.
- Responsive layout inside a Shot is hand-rolled from `MediaQuery.sizeOf`
  against `Breakpoints`, because `Grid`, `PageHeader` and `Section` are
  example-app kit rather than registry items.
- Visual review of the new routes is by widget test and by reading, not by
  golden image. This repository has no golden infrastructure (Ruling 5).
- Browser visual and accessibility captures for the Shots routes are not done.
- The entry-gate carryover is unchanged: placeholder `LICENSE`,
  `publish_to: 'none'`, and no real `elattar_core`.

## What is next

Phase H — Skills. In order:

1. Move the skill to a path a harness actually scans; `.agents/skills/` is
   scanned by nothing (Phase H scope, finding 1).
2. Resolve the Codex support claim: delete `agents/openai.yaml` or keep it only
   against a dated, recorded run.
3. Rewrite the skill's references for a consumer project, which has none of the
   repository paths the current text routes an agent to.
4. Build the real `/skills` page on top of whatever install route actually
   exists, replacing the placeholder this phase left.
5. Close the carryover blockers before Phase I: licensing, `elattar_core`, and
   browser captures. (CI coverage for the registry validator and CLI suite
   was already closed in `48c390b`, an ancestor of this phase's own close —
   this line was stale the moment it was written; corrected per Phase I
   finding F22.)

## Restart instructions

Read, in order:

1. `docs/superpowers/reports/public-release/STATUS.md`
2. This report
3. `docs/superpowers/plans/2026-08-23-phase-h-skills-scope.md`
4. `example/lib/shots_docs/catalog.dart` and `example/lib/site/site_routes.dart`
5. `example/lib/site/pages/public_pages.dart` — the Skills placeholder Phase H replaces

Then run:

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
```
