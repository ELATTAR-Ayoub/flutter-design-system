# Phase G — Shots: supervisor scope

Derived from a read-only architecture pass, 2026-08-22. Supervisor rulings are
recorded here; workers receive extracts, not this whole file.

## Ruling 1 — Phase G is Shots

Three documents disagreed. `docs/superpowers/plans/2026-08-21-supervisor-multi-agent-execution.md`
§11 says Phase G is Shots; `STATUS.md` and the Phase F report say "public preview
hardening"; the IA plan numbers Shots as Phase F.

**The master execution plan governs.** Phase G is Shots. The hardening items
(browser review, accessibility captures, `elattar_core`, licensing) are Phase G
*entry-gate carryover*, not a phase — they are tracked as blockers and close
before Phase I, not before G1 starts.

## Ruling 2 — two directories, never one

| Directory | Nature | Shipped to users |
|---|---|---|
| `example/lib/shots/<dir>/` | The installable composition. Hashed by the generator, copied into consumer projects. | Yes |
| `example/lib/shots_docs/` | Catalog, index, detail, preview host. Website chrome. | No |

Keeping them apart stops the generator's source globs from ever hashing a
documentation page.

## Ruling 3 — the exit gate was unachievable as written

The plan's gate says "Dependencies install components into `lib/components/ui/`".
`DartImportTransformer.transform` skips any URI carrying a scheme, so a shot's
`package:elattar_design_system/...` import is never rewritten. A shot installed
today compiles only in a project that already depends on the published package —
the opposite of the copy-first premise, and no existing test catches it.

This is a new capability, not a config tweak. It is Wave 0 work (W0-A) and it
blocks G3.

## Ruling 4 — "product-neutral" is restated as two mechanical checks

The prose gate is not machine-checkable. It is replaced by:
1. A source guard over `example/lib/shots/**`, mirroring
   `example/test/showcase_source_guard_test.dart` (bans `Theme.of(`, `Colors.`,
   `Color(`, bare `Text(`, `TextStyle(`, `Scaffold(`, hardcoded layout numbers…).
2. Every `Ds*` symbol used must trace to a declared registry dependency.

Plus explicit visual review. Not golden images — this repo has no golden
infrastructure and standing one up is a phase of its own.

## Ruling 5 — deterministic previews are widget tests, not goldens

Reuse the existing rig: real test-view sizing (`tester.view.physicalSize`, not
synthetic `MediaQuery` — this was a Phase F review correction), a live
`DsThemeController` flipped in place, `MediaQueryData.disableAnimations` as the
motion freeze, and `DsClock` for any shot rendering a date.

## The seventeen-item ceiling

A shot may only depend on registry items that exist. The registry holds exactly
seventeen: `source-foundation`, `press-motion`, `machine-surface`, `foil-value`,
`sheen-action`, `icon`, `spinner`, `ds-rule`, `field`, `popover`, `tooltip`,
`button`, `card`, `dialog`, `alert-dialog`, `input`, `select`.

Consequence: **`DsGrid`, `DsPageHeader` and `DsSection` are off-limits** — they
live in the example app's own kit, not the package and not the registry. So are
`DsBadge`, `DsSeparator`, `DsTable`, `DsAvatar`, `DsTabs`, `DsTextarea`: real
components, but not registry items. Responsive layout is hand-rolled from
`MediaQuery.sizeOf(context).width` against `DsBreakpoints`.

`foil-value` is deliberately excluded from the first three shots — it runs two
infinite animations that the deterministic-preview gate would have to freeze.

## Waves

**Wave 0 — serial, supervisor-owned. Nothing else may start on these files.**
1. `example/lib/shots_docs/catalog.dart` — the metadata contract (supervisor, done).
2. W0-A: registry `shot` kind, `@app/` prefix, `registry/shots/` scan,
   `_copyInPackageMode` arm, and the import-rewrite capability above.
   The enum addition breaks CLI compilation until the switch arm lands, which is
   exactly why it cannot be left to a Wave 1 worker.

**Wave 1 — genuinely parallel, zero file overlap. Each worker writes only new files.**
- G1 — `shots_docs/shots_index_page.dart` + test
- G2 — `docs/docs_file_tree.dart` (new Phase-C-style primitive; `docs_code.dart`
  stacks every file with no selection state) + `shots_docs/shot_detail_page.dart` + tests
- G3 — three shot compositions, `shots_docs/shot_preview_host.dart`,
  `registry/shots/*.json`, preview + source-guard tests

**Wave 2 — supervisor integration, after all three return.**
`example/lib/main.dart` route arms — the preview arm must sit **above** the
`siteRouteFor` guard, or the chrome-free preview inherits header, footer and
search. `site_routes.dart` deep links and search index. Retire `PublicShotsPage`.
Repair `site_routes_test.dart` (five-item header contract) and
`public_pages_test.dart` (asserts `find.text('Signal Studio')` — expected to
break; a Wave 1 worker who sees it must not "fix" it). Regenerate
`registry/generated/latest/**` once. Phase-close report.

## Known risks carried into Phase G

- `.github/workflows/ci.yml` never runs the registry validator or the
  `packages/elattar_cli` suite — including `cli_integration_test.dart`, the only
  test proving `init` + `add` works. Phase G materially grows registry surface,
  so this pre-existing gap becomes a Phase G risk.
- `registry/generated/latest/**` is committed machine output. Generation stays
  exclusively in Wave 2 or three workers produce a guaranteed merge conflict.
- Catalog and manifests each state a shot's dependencies. Nothing cross-checks
  them today; Wave 2 adds a test that they agree.
