# Contributing

Thanks for helping improve this repository.

This project is currently in its public-foundation stage and the package version is `0.0.1`. The Flutter package in this repository is the authoritative implementation. Future website, registry, and CLI work should stay aligned with that source of truth rather than creating parallel behavior.

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

That plugin route is wired but not yet signed off: a recorded run per harness is tracked as release verification work, and until those exist, treat it as untested and fall back to the `AGENTS.md` path. If you do exercise it, note the harness and version in your pull request — that is exactly the evidence the sign-off needs.

Do not copy the skill into a personal agent configuration directory and edit it there. Edit it in the tree and send a pull request, otherwise your changes cannot be reviewed and will drift from the repository the skill describes.

## Good first contribution areas

- Fix a bug in a public `Ds*` API or its tests.
- Improve documentation or examples for the package.
- Add verification coverage for an existing component or effect.
- Improve the CLI (`packages/elattar_cli/`) or the registry (`registry/`, `tool/registry_builder/`) — both are implemented and tested in this repository already, just not published (`publish_to: none`, private repository). Extending their test coverage or closing gaps in what they scaffold is welcome.
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
flutter test test/token_guard_test.dart
```

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

- Prefer public `Ds*` APIs over reaching into private internals.
- Keep new behavior token-driven and theme-aware.
- Preserve accessibility semantics and keyboard behavior.
- Match existing naming and placement conventions.
- Avoid mixing unrelated refactors into the same pull request.

## Third-party code and assets

Only submit code, fonts, textures, images, or other assets when you have the right to contribute them. If redistribution or licensing status is unclear, open an issue first instead of sending the asset in a pull request.

## Planning and roadmap work

The repository contains active planning documents for future public release, registry, CLI, and website work. Those plans are useful context, but implemented package behavior and tests win when there is a conflict.

## Need a different issue type?

Use the issue forms for bugs, component requests, docs, accessibility, and future CLI or registry work. If none fits well, start with the closest one and explain the mismatch in the first field.
