# Public release program status

## Current phase

Phase G — Shots. Complete: Wave 0, Wave 1 and the Wave 2 integration are done
and verified. Next is Phase H — Skills.

## Overall state

Ready for next phase, with public-release blockers preserved.

## Release version

`0.0.1`

## Last verified commit/worktree state

- Branch `public-release-v0.0.1-phase-f`. The previous entry in this file
  claimed branch `main` at `c20838e` with uncommitted Phase A–E files; that was
  stale and is corrected here.
- Last commit `7860c58` — "feat(shots): wire Shots into the site and close
  Phase G", the Wave 2 integration. All of Phase G is committed.
- The three commits that closed the phase, oldest first:
  - `48c390b` — "fix(cli): rewrite imports only in the directive prologue"
  - `611c7a9` — "fix(docs): restore copy affordance and cover the untested paths"
  - `7860c58` — Wave 2: route wiring, asset-loaded Shot source, placeholder
    retirement, repaired and new tests, registry regenerated once.
- Working tree clean. Nothing to preserve.
- Registry generates and validates **20** schema-v1 items (17 + 3 Shots).
- Root `flutter analyze` clean; root `flutter test` 1473 passing.
- Example `flutter analyze` clean; example `flutter test` 943 passing.
- Example release web build passes with `--base-href /flutter-design-system/`.
  Run it from PowerShell — Git Bash rewrites the `--base-href` value into a
  Windows path and the build refuses it.

## Completed phases

- [Phase A — Public repository foundation](phase-a-public-repository.md)
- [Phase B — Website shell](phase-b-website-shell.md)
- [Phase C — Documentation system](phase-c-documentation-system.md)
- [Phase D — Registry pilot](phase-d-registry-pilot.md)
- [Phase E — CLI MVP](phase-e-cli-mvp.md)
- [Phase F — Component documentation](phase-f-component-documentation.md)
- [Phase G — Shots](phase-g-shots.md)

## Active work packages

None assigned. Phase H — Skills is scoped and ready to start; see
`docs/superpowers/plans/2026-08-23-phase-h-skills-scope.md`.

## Accepted work in current phase

- Registry `shot` item kind, `@app/` install target, and the import rewriting
  that makes an installed Shot compile in a consumer project (`158e9eb`).
- Three Shots — `settings-profile`, `sign-in-flow`, `dashboard-overview` — with
  registry manifests and a mechanical product-neutrality source guard
  (`6c94bac`).
- Filterable Shots index (`7cac208`); `DocsFileTree` primitive and Shot detail
  page (`8145ed5`).
- Wave 2: route wiring including the chrome-free preview arm above the
  `siteRouteFor` guard, real Shot source threaded to the detail page through the
  asset bundle, `PublicShotsPage` retired, catalog/manifest parity test, registry
  regenerated once.

## Rejected or revision work

- Wave 2, first draft: worked around a duplicate `PublicNavigate` typedef with a
  `show` clause in `main.dart` instead of deleting the duplicate. Corrected —
  the typedef and the three separate spellings of `/shots` are collapsed to one
  each.

## Blockers

Open:

- `LICENSE` is still a placeholder; redistribution rights are not confirmed.
- `publish_to: 'none'` remains; publication/deployment is not authorized.
- Package mode lacks a real `elattar_core` package.
- Browser visual/accessibility captures are incomplete for the component guides
  and for the new Shots routes.

Closed in Phase G:

- ~~Example analyze gate~~ — repaired in `a5f6c89`.
- ~~Full-suite and web-build confirmation after the Phase F Windows launcher
  stall~~ — both completed on a fresh runner in this phase.

Known and non-blocking:

- The release web build reports a CupertinoIcons tree-shaking warning. It is
  unchanged, expected, and retained for audit.
- `.github/workflows/ci.yml` does not run the registry validator or the
  `packages/elattar_cli` suite. Phase G grew both materially. A concurrent
  worker has an in-flight change to that file.

## Next three actions

1. Start Phase H — Skills at finding 1 of its scope plan: move the skill out of
   `.agents/skills/`, which no harness scans, and replace the `/skills`
   placeholder this phase left behind.
2. Browser-review the Shots and component routes at narrow and wide viewports,
   and close the accessibility findings.
3. Resolve licensing and `elattar_core`, and add the registry validator and the
   `packages/elattar_cli` suite to CI, before any deployment.

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

1. `docs/superpowers/reports/public-release/phase-g-shots.md`.
2. `docs/superpowers/plans/2026-08-23-phase-h-skills-scope.md`.
3. `AGENTS.md` and `.agents/skills/elattar-flutter-ui-director/SKILL.md`.
4. `example/lib/shots_docs/catalog.dart` and `example/lib/site/site_routes.dart`.
5. `example/lib/site/pages/public_pages.dart` — the Skills placeholder Phase H
   replaces.

## Do not redo

- Existing-repository decision, source-foundation default, and
  `lib/components/ui/` destination.
- Phase A–G accepted work and recorded revisions.
- Version remains `0.0.1`.
- Phase G rulings: Phase G is Shots; two directories (`shots/` shipped,
  `shots_docs/` never shipped); product-neutrality is a source guard plus a
  symbol trace, not prose; previews are widget tests, not goldens.
- The Shot detail page loads source from the asset bundle. Do not replace it
  with a generated or hand-copied Dart literal.
