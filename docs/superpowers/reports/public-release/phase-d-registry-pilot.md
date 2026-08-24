# Phase D — Registry pilot report

> **Historical snapshot.** This report records what was true on the date and
> at the commit named in it. It is kept for the reasoning, not as a statement
> of the current release — several findings below were closed afterwards. For
> what is true now, read
> [`v0.0.1-public-release-baseline.md`](v0.0.1-public-release-baseline.md),
> which classifies every finding here against the commit that fixed it, and
> the root [`CHANGELOG.md`](../../../../CHANGELOG.md).

## Status

Accepted.

## Objective

Create schema v1, deterministic generation, dependency validation, and a source-derived pilot registry.

## Completed work

- Typed schema/parser and validator for registry documents and items.
- Validation for versions, hashes, safe logical targets, duplicates, missing/cyclic dependencies, and semantic dependency declarations.
- Deterministic generator that verifies authoritative source hashes and emits aggregate/index/per-item payloads.
- Import and font-package transformation planning.
- Source foundation plus button, input, card, dialog, and select manifests.
- Internal support manifests for their real transitive component, effect, and motion dependencies.
- Generated 17 single-owner items under `registry/generated/latest/`.

## Files changed

- `registry/schema/**`
- `registry/foundations/**`
- `registry/components/**`
- `registry/effects/**`
- `registry/motion/**`
- `registry/generated/**`
- `tool/registry_builder/**`
- `test/registry_builder_test.dart`

## Agent assignments

- D1, Luna: schema/parser/validator; accepted, 6 tests.
- D2, Luna: deterministic generator; accepted after real-manifest integration revision, 4 tests.
- D3, Luna: curated manifests; accepted after schema-alignment and single-owner dependency revisions.
- Dependency auditor, GPT-5.4: exact transitive source graph and font/import risks.

## Decisions made

- Curated manifests describe semantic ownership; payload code is generated from the authoritative package.
- Every logical target has one registry owner. Reuse is expressed through dependencies, not duplicated payloads.
- Fonts live under `@foundation/fonts/`; the pilot requires no texture or shader.
- Support items are explicit internal registry entries so dependency resolution remains inspectable.

## Verification performed

- Real generator: 17 items generated successfully.
- Generated registry validator: schema v1 valid with 17 items.
- Registry builder + generator suite: 10 tests passed.
- Determinism fixture builds twice with identical trees.
- `git diff --check`: no whitespace errors.

## Supervisor review

Rejected two intermediate handoffs: first for schema/manifest field mismatch, then for duplicate target ownership. Both were corrected and revalidated against the real repository.

## Independent audit

The dependency audit identified non-obvious button/input/select support graphs, package-prefixed typography fonts, and confirmed no pilot shader/texture requirement. All findings were incorporated.

## Known limitations

- Generated source has not yet been installed into a consumer fixture; that is the Phase E gate.
- Licensing of redistributed fonts and other public assets remains a release blocker.

## What is next

Phase E implements project discovery/config/manifest, registry resolution/cache, safe installation/pubspec/barrels, then wires the MVP commands.

## Restart instructions

Read this report and the CLI plan; run `dart run tool/registry_builder/bin/build.dart .`, validate the generated registry, and run the 10 registry tests.
