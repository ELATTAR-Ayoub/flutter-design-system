# Public release program status

## Current phase

Phase F — Component documentation complete. Ready for Phase G — Public preview hardening.

## Overall state

Ready for next phase, with public-release blockers preserved.

## Release version

`0.0.1`

## Last verified commit/worktree state

- Branch `main`; baseline commit `c20838e`.
- Preserve all uncommitted Phase A–E task files.
- Root and example analysis pass; the Phase E Pages release web build passes.
- CLI analysis passes; 8 tests pass, including clean consumer `init` + `add button` + `flutter analyze`.
- Registry generates and validates 17 schema-v1 items.

## Completed phases

- [Phase A — Public repository foundation](phase-a-public-repository.md)
- [Phase B — Website shell](phase-b-website-shell.md)
- [Phase C — Documentation system](phase-c-documentation-system.md)
- [Phase D — Registry pilot](phase-d-registry-pilot.md)
- [Phase E — CLI MVP](phase-e-cli-mvp.md)
- [Phase F — Component documentation](phase-f-component-documentation.md)

## Active work packages

Fresh-run global verification and browser review for Phase G.

## Accepted work in current phase

Five registry-backed component guides, shared component catalog, deep links, catalog integration, and search integration.

## Rejected or revision work

All focused Phase F findings are closed. The Windows Flutter wrapper stalled during the final global gate; no failing test output was produced, and the rerun is explicitly carried into Phase G.

## Blockers

- `LICENSE` is still a placeholder; redistribution rights are not confirmed.
- `publish_to: 'none'` remains; publication/deployment is not authorized.
- Package mode lacks a real `elattar_core` package.
- Web build reports a non-blocking CupertinoIcons warning.
- Browser visual/accessibility captures for new routes are incomplete.
- Full-suite and web-build confirmation needs a fresh Flutter runner after the local launcher stall.

## Next three actions

1. Browser-review the five component guides at narrow and wide viewports.
2. Re-run the global suite and release web build in a fresh Flutter runner.
3. Build `elattar_core` or hide package mode, then resolve licensing/assets before publication.

## Commands to resume

```powershell
dart run tool/registry_builder/bin/build.dart .
dart run tool/registry_builder/bin/validate.dart registry/generated/latest/registry.json
Push-Location packages/elattar_cli
dart analyze
dart test
Pop-Location
flutter analyze
Push-Location example
flutter analyze
flutter build web --release --base-href /flutter-design-system/
Pop-Location
```

## Files to read first

1. `AGENTS.md` and the Flutter UI skill.
2. Supervisor execution plan.
3. Phase F report.
4. `example/lib/components_docs/catalog.dart`.
5. `example/lib/site/site_routes.dart`.

## Do not redo

- Existing-repository decision, source-foundation default, and `lib/components/ui/` destination.
- Phase A–F accepted work and recorded revisions.
- Version remains `0.0.1`.
