# Contributing

Thanks for helping improve this repository.

The package version is `0.0.1`, the first public release. The Flutter package in this repository is the authoritative implementation: the registry, the CLI and the website all derive from it, and should stay aligned with it rather than growing parallel behaviour.

## Before you start

- Search existing issues and pull requests before opening a new one.
- Keep changes scoped. Small, reviewable pull requests move fastest.
- If your change affects product UI, components, motion, responsive behavior, or accessibility, follow [`AGENTS.md`](AGENTS.md) and the [`elattar-flutter-ui-director`](skills/elattar-flutter-ui-director/SKILL.md) skill contract.
- Do not move product UI into `lib/src/components/` unless that is already the correct package surface.
- Do not add hardcoded visual or motion literals in `lib/` or `example/lib/` when the design-system tokens already cover the need. The repository enforces this with `test/token_guard_test.dart`.

## Activating the agent skill locally

The skill lives at [`skills/elattar-flutter-ui-director/`](skills/elattar-flutter-ui-director/). It moved there from `.agents/skills/` — that older path is gone, and nothing reads it. There is exactly one copy in this repository; do not create a second one.

**If your agent reads `AGENTS.md`** — nothing to install. [`AGENTS.md`](AGENTS.md) sits at the repository root and routes to the skill, so cloning is the whole setup. This is the path to use when in doubt.

**If your agent loads Claude Code plugins** — the repository root is also a plugin marketplace. `.claude-plugin/marketplace.json` declares one plugin sourced from `"./"`, and `.claude-plugin/plugin.json` points at `./skills/elattar-flutter-ui-director`. Adding your local clone as a marketplace therefore loads the skill straight from your working tree, with no copy step and no path to keep in sync.

That plugin route is wired but not yet signed off: no recorded run per harness exists, so treat it as untested and fall back to the `AGENTS.md` path. If you do exercise it, note the harness and version in your pull request — that is exactly the evidence the sign-off needs.

Do not copy the skill into a personal agent configuration directory and edit it there. Edit it in the tree and send a pull request, otherwise your changes cannot be reviewed and will drift from the repository the skill describes.

## Good first contribution areas

- Fix a bug in a public `El*` API or its tests.
- Improve documentation or examples for the package.
- Add verification coverage for an existing component or effect.
- Improve the CLI (`packages/elattar_cli/`) or the registry (`registry/`, `tool/registry_builder/`). Both are published as of `0.0.1`, which raises the bar rather than lowering it: a change to either reaches installed projects, so extending their test coverage is as welcome as extending their behaviour.
- Improve accessibility, keyboard handling, semantics, focus order, or reduced-motion behavior.

## Workflow

1. Create a branch from the current default branch.
2. Make the smallest change that fully addresses the problem.
3. Add or update tests when behavior changes.
4. Run the relevant verification commands locally.
5. Open a pull request with context, evidence, and any follow-up work.

## Verification

Run the smallest relevant set, and run the full package checks before asking for review on behavior changes:

```powershell
flutter analyze
flutter test
flutter test test/token_guard_test.dart test/license_distribution_test.dart
```

If you touch the CLI, the registry builder, or anything a registry item
distributes:

```powershell
Push-Location packages/elattar_cli
dart format --output=none --set-exit-if-changed .
dart analyze
dart test
Pop-Location

dart run tool/registry_builder/bin/build.dart .
dart run tool/registry_builder/bin/validate.dart registry/generated/latest/registry.json
git diff --exit-code -- registry/generated/latest
```

That last line is the one that matters: the generated registry is checked in,
and a source change without a rebuild leaves published hashes that no longer
match the files they describe.

If you change the example app, also verify it directly:

```powershell
Push-Location example
flutter analyze
flutter test
Pop-Location
```

If your change affects the web demo or release behavior, maintainers may additionally ask for:

```powershell
Push-Location example
flutter build web --release
Pop-Location
```

## Pull request expectations

Please include:

- What changed and why.
- Which files or APIs are intentionally affected.
- How you verified the change.
- Screenshots or recordings for UI changes when they help reviewers compare behavior.
- Any known gaps, tradeoffs, or follow-up work.

## Design-system rules

- Prefer public `El*` APIs over reaching into private internals.
- Keep new behavior token-driven and theme-aware.
- Preserve accessibility semantics and keyboard behavior.
- Match existing naming and placement conventions.
- Avoid mixing unrelated refactors into the same pull request.

## Third-party code and assets

Only submit code, fonts, textures, images, or other assets when you have the right to contribute them. If redistribution or licensing status is unclear, open an issue first instead of sending the asset in a pull request.

Anything this repository redistributes needs three things, and
`test/license_distribution_test.dart` fails without them: the upstream license
text reproduced verbatim under `third_party/`, a row in
`THIRD_PARTY_NOTICES.md` recording the source URL, version, retrieval date and
content hash, and — if a registry item distributes it — a `licenses` entry on
that item so the notice installs into the consumer's `LICENSES/` directory
alongside the file it covers.

Contributions to this repository are accepted under its MIT license.

## Planning and roadmap work

The repository contains planning and audit documents under `docs/superpowers/`. Those are useful context, and the phase reports in particular are dated snapshots rather than current statements — implemented behaviour and passing tests win whenever they disagree.

## Need a different issue type?

Use the issue forms for bugs, component requests, docs, accessibility, and CLI or registry work. If none fits well, start with the closest one and explain the mismatch in the first field.
