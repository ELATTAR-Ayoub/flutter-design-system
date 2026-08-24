# Elattar public release, registry, documentation, and CLI — Full Plan

**Status:** Proposed implementation specification
**Date:** 2026-08-21
**Repository:** `ELATTAR-Ayoub/flutter-design-system`
**Primary audience:** Flutter application developers
**Product model:** An open-source Flutter package plus a shadcn-style source registry and installer

## 1. Goal

Publish Elattar as a public Flutter design system with three coherent ways to use it:

1. A public Flutter package for consumers who want centrally maintained components.
2. A source-first CLI that copies the foundation and selected components into an application.
3. A public documentation website that previews, explains, and installs every supported item.

The primary CLI experience is:

```console
dart install elattar_cli
elattar init
elattar add button
```

The default `init` behavior copies the design-system foundation into the consumer's project. This is the core ownership promise: the application's colors, typography, spacing, surfaces, shadows, media rules, theme behavior, and basic motion language become local source files that the consumer can inspect and change.

The compact alternative is:

```console
elattar init --foundation package
```

In both modes, every installed component goes to:

```text
lib/components/ui/
```

That location is a binding product convention.

## 2. Product principles

1. **Source ownership by default.** `elattar init` is equivalent to `elattar init --foundation source`.
2. **One component location.** Source and package foundation modes both use `lib/components/ui/`.
3. **Flutter-native behavior.** The CLI works with Dart files, `pubspec.yaml`, Flutter assets, fonts, shaders, formatting, and analysis rather than imitating CSS or Tailwind concepts literally.
4. **One authoritative implementation.** The existing Flutter package under `lib/` remains the source of truth. Registry artifacts are generated and verified from it; they are not a separately hand-maintained implementation.
5. **Safe local ownership.** Existing or customized files are never overwritten silently.
6. **Deterministic installs.** Registry versions, dependency resolution, generated barrels, and file hashes make the same command produce a predictable result.
7. **Honest upgrades.** Package-mode upgrades and source-mode upgrades are different workflows and are documented as such.
8. **Complete components.** A registry item includes required source, dependencies, assets, shaders, configuration, documentation, states, and tests—not only its primary Dart file.
9. **The package remains authoritative.** Public `El*` APIs, foundations, tests, specimens, and token guards define what the website and registry may distribute.

## 3. Distribution architecture

The public product consists of four deliverables.

### 3.1 `elattar_design_system`

The complete maintained Flutter package. Consumers install it with:

```console
flutter pub add elattar_design_system
```

This mode is appropriate when a team wants simple version upgrades and does not need local component source ownership.

### 3.2 `elattar_core`

A small public Flutter package used only by CLI consumers who select package-backed foundations. It owns:

- Foundation tokens and semantic theme types.
- Theme scope and controller.
- Typography resolution.
- Standard fonts and ordinary shared assets.
- Small foundational utilities required by copied components.

It does not own the copied components in `lib/components/ui/`.

Whether `elattar_core` begins as a separately published package or as a deliberately constrained sublibrary of `elattar_design_system` is an implementation decision for Phase 3. The public CLI contract must use the logical name `elattar_core`; publishing should not proceed until pub.dev name availability and package boundaries are confirmed.

### 3.3 `elattar_cli`

A pure Dart executable package containing:

- Project discovery and validation.
- Configuration parsing.
- Registry fetching and caching.
- Dependency graph resolution.
- File planning and conflict detection.
- Dart import transformation.
- `pubspec.yaml` editing.
- Barrel generation.
- Formatting, dependency resolution, and validation orchestration.

The executable is exposed as `elattar`.

### 3.4 Static registry and documentation website

The registry is hosted as versioned static JSON and source payloads. The documentation website consumes the same metadata for installation commands, dependencies, source links, and item status.

## 4. Consumer project layouts

### 4.1 Default source-foundation mode

After `elattar init`:

```text
my_app/
├── .elattar/
│   ├── manifest.json
│   └── snapshots/
├── elattar.yaml
├── pubspec.yaml
├── assets/
│   └── elattar/
│       └── fonts/
│           ├── InterVariable.ttf
│           ├── GeistMono-Variable.ttf
│           └── Redaction35-Italic.ttf
├── lib/
│   ├── design_system/
│   │   ├── design_system.dart
│   │   ├── foundation/
│   │   │   ├── colors.dart
│   │   │   ├── date_format.dart
│   │   │   ├── foundation.dart
│   │   │   ├── media.dart
│   │   │   ├── motion.dart
│   │   │   ├── shadows.dart
│   │   │   ├── spacing.dart
│   │   │   ├── surfaces.dart
│   │   │   ├── theme.dart
│   │   │   └── typography.dart
│   │   ├── text_layout.dart
│   │   ├── theme_scope.dart
│   │   ├── effects/
│   │   └── motion/
│   └── components/
│       └── ui/
│           └── ui.dart
└── shaders/
    └── elattar/
```

`effects/` and non-foundational motion widgets begin empty. They are populated only when selected components require them.

### 4.2 Package-foundation mode

After `elattar init --foundation package`:

```text
my_app/
├── .elattar/
│   ├── manifest.json
│   └── snapshots/
├── elattar.yaml
├── pubspec.yaml
└── lib/
    └── components/
        └── ui/
            └── ui.dart
```

`pubspec.yaml` contains an `elattar_core` dependency. Components still belong to the application and remain in `lib/components/ui/`.

### 4.3 Installed components

After:

```console
elattar add button dialog input
```

both modes contain:

```text
lib/components/ui/
├── button.dart
├── dialog.dart
├── input.dart
└── ui.dart
```

The CLI maintains `ui.dart` as a sorted generated barrel without removing user-authored exports.

## 5. Foundation contract

### 5.1 Colors

Source mode stores colors in:

```text
lib/design_system/foundation/colors.dart
```

The file separates primitive palette values from semantic roles. Components consume semantic theme colors through `ElTheme.of(context)` and never depend directly on product-specific palette choices.

### 5.2 Typography

Source mode stores type definitions in:

```text
lib/design_system/foundation/typography.dart
```

Standard font binaries are copied into `assets/elattar/fonts/`, and the CLI adds the required `flutter.fonts` declarations to `pubspec.yaml`.

### 5.3 Flutter equivalent of Tailwind setup

The typed foundation replaces Tailwind's configuration and utilities:

| Web concern | Flutter source |
|---|---|
| CSS color variables | `colors.dart` and semantic theme data |
| Font variables and type utilities | `typography.dart` |
| Spacing scale | `spacing.dart` and `el(...)` |
| Radius, border, and surface utilities | `surfaces.dart` |
| Shadow utilities | `shadows.dart` |
| Breakpoints and containers | `media.dart` |
| Transition durations and curves | `motion.dart` |
| Global theme scope | `theme_scope.dart` |

### 5.4 Basic versus optional motion

`init` installs the basic motion language:

- Named durations.
- Named curves.
- Reduced-motion resolution.
- Shared timing and transition tokens.

Optional motion implementations such as press, lift, swap-in, sliding-pill, and keyframe helpers are registry dependencies installed only when requested or transitively required.

### 5.5 Assets and shaders

Registry items explicitly declare required assets and shaders. Normal assets are copied and added to `pubspec.yaml`. Shader-backed items also copy the shader into the root application because Flutter root projects must declare shaders themselves.

## 6. Configuration contract

The root configuration file is `elattar.yaml`.

### 6.1 Default configuration

```yaml
schema: https://elattar.dev/schema/config.json
registry: https://elattar.dev/registry
foundation: source
style: default

paths:
  foundation: lib/design_system/foundation
  theme: lib/design_system
  components: lib/components/ui
  effects: lib/design_system/effects
  motion: lib/design_system/motion
  assets: assets/elattar
  shaders: shaders/elattar

barrels:
  design_system: lib/design_system/design_system.dart
  components: lib/components/ui/ui.dart
```

### 6.2 Package-foundation configuration

```yaml
schema: https://elattar.dev/schema/config.json
registry: https://elattar.dev/registry
foundation: package
style: default

package:
  name: elattar_core
  version: ^1.0.0

paths:
  components: lib/components/ui

barrels:
  components: lib/components/ui/ui.dart
```

### 6.3 Precedence

Configuration is resolved in this order, highest priority first:

1. Command-line option.
2. `elattar.yaml`.
3. CLI default.

Changing `foundation:` in YAML does not itself perform migration. If the configured mode differs from `.elattar/manifest.json`, mutating commands stop and direct the user to `elattar migrate foundation`.

### 6.4 Schema evolution

The config schema is versioned. The CLI must reject unknown future schema versions with a useful upgrade message and provide `elattar config migrate` for supported migrations.

## 7. Registry contract

### 7.1 Registry structure

```text
registry/
├── registry.json
├── foundations/
├── components/
├── effects/
├── motion/
├── blocks/
├── presets/
└── generated/
    ├── latest/
    └── versions/
```

Supported item types:

- `foundation`
- `component`
- `effect`
- `motion`
- `asset`
- `block`
- `preset`

### 7.2 Registry item fields

Every item declares:

- Stable name, title, description, type, and version.
- Minimum Dart and Flutter versions.
- Source files and destination roles.
- Registry dependencies.
- Pub dependencies and version constraints.
- Assets, fonts, and shaders.
- Import placeholders or transformations.
- Setup instructions when automation is not safe.
- Documentation route and source link.
- Deprecation and replacement metadata.
- Integrity hashes.

Example:

```json
{
  "name": "button",
  "type": "component",
  "version": "0.1.0",
  "description": "Semantic button with variants, sizes, loading, focus, and disabled states.",
  "files": [
    {
      "source": "lib/src/components/button.dart",
      "target": "@ui/button.dart"
    }
  ],
  "registryDependencies": ["icon", "press-motion"],
  "pubDependencies": {},
  "assets": [],
  "shaders": []
}
```

### 7.3 Dependency resolution

The resolver must:

1. Load the requested item and version.
2. Resolve transitive registry dependencies.
3. Detect cycles and incompatible constraints.
4. Deduplicate already installed compatible items.
5. Resolve pub dependencies.
6. Resolve assets, fonts, and shaders.
7. Produce a complete dry-run plan before writing.
8. Install in topological order.

Imports alone are not sufficient registry metadata. Import scanning assists validation, while curated manifests remain authoritative for semantic relationships, assets, shaders, and setup.

### 7.4 Registry generation

A builder under `tool/registry_builder/` reads the package barrel, sources, curated manifests, tests, and specimens. It generates distributable payloads and fails on:

- Public exports without an applicable registry decision.
- Missing source files.
- Missing declared dependencies.
- Undeclared internal imports.
- Circular dependency graphs.
- Unknown item types or targets.
- Hash mismatches.
- Missing documentation routes.
- Components without focused package tests and specimens.

## 8. CLI implementation behavior

### 8.1 Project discovery

The CLI walks upward from the current directory until it finds `pubspec.yaml`. It validates that the project depends on the Flutter SDK before performing Flutter-specific mutations. `--project <path>` overrides discovery.

### 8.2 Planning before mutation

Every mutating command builds an operation plan containing:

- Files to create.
- Files to modify.
- Files with conflicts.
- Registry and pub dependencies.
- Asset and shader changes.
- Commands that will run afterward.

`--dry-run` prints this plan and performs no writes.

### 8.3 File ownership and conflict safety

`.elattar/manifest.json` records installed items, registry versions, source hashes, installed hashes, destinations, and foundation mode.

The CLI behavior is:

- Missing destination: create it.
- Destination matches prior installed hash: safe to replace during an explicit update.
- Destination differs from prior installed hash: treat as locally modified.
- Locally modified destination: never overwrite without an explicit conflict choice.
- `--overwrite`: permitted only after showing affected files; unsuitable as an implicit default.

Snapshots are retained for diff and migration workflows. Material deletion should be recoverable or backed up.

### 8.4 Import transformation

Registry payloads use logical targets such as `@ui/`, `@foundation/`, `@effects/`, and `@motion/`. The CLI resolves these against `elattar.yaml` and generates valid relative imports for source mode or `package:elattar_core/...` imports for package mode.

Components must not embed a consumer package name.

### 8.5 `pubspec.yaml` mutation

The CLI uses a YAML-aware editor and handles:

- Dependencies and dev dependencies.
- Fonts.
- Assets.
- Shaders.

It preserves unrelated user configuration and detects incompatible existing constraints. It must not reconstruct the entire file from a lossy map serializer.

### 8.6 Generated barrels

The CLI owns marked generated regions rather than the whole barrel:

```dart
// elattar:exports:start
export 'button.dart';
// elattar:exports:end
```

User-authored content outside the region remains untouched. Exports are deterministic and sorted.

### 8.7 Post-install verification

Unless `--skip-checks` is supplied, a successful mutation runs the applicable sequence:

```console
dart format <changed Dart files>
flutter pub get
flutter analyze
```

The first implementation may scope analysis to what Flutter safely supports, but the command output must state exactly what was verified. On failure, the CLI reports changed files and recovery steps rather than claiming success.

### 8.8 Non-interactive use

All prompts have flags. `--yes` accepts safe defaults; it never authorizes overwriting modified files. Commands return stable exit codes and support `--json` for automation.

### 8.9 Telemetry

The MVP collects no telemetry. Future telemetry must be opt-in, documented, anonymous by construction, and configurable in `elattar.yaml`.

## 9. Complete CLI command reference

The public executable is `elattar`.

### 9.1 Global commands and options

```console
elattar --help
```

Prints command help and common examples.

```console
elattar --version
```

Prints CLI version, supported registry schema version, and runtime Dart version.

Common options:

| Option | Meaning |
|---|---|
| `--project <path>` | Operate on a specific Flutter project instead of discovering one. |
| `--config <path>` | Use a non-default configuration file. |
| `--registry <url-or-path>` | Override the registry for this command. |
| `--yes`, `-y` | Accept safe defaults and suppress ordinary confirmation prompts. |
| `--dry-run` | Print the complete operation without changing the project. |
| `--json` | Emit machine-readable output. |
| `--verbose`, `-v` | Show resolution and execution details. |
| `--offline` | Use cached registry data and perform no network fetch. |
| `--skip-checks` | Skip post-write format/analyze checks; print a warning. |

### 9.2 `elattar init`

```console
elattar init
```

Initializes source-foundation mode by default. It creates `elattar.yaml`, copies the foundation and fonts, creates barrels and tracking metadata, updates `pubspec.yaml`, and verifies the project.

```console
elattar init --foundation source
```

Explicit form of the default.

```console
elattar init --foundation package
```

Uses `elattar_core` for foundations while still installing future components into `lib/components/ui/`.

```console
elattar init --style <preset>
```

Initializes with a named registry preset while retaining the same semantic contracts.

```console
elattar init --components-path lib/shared/ui
```

Overrides the component destination and records it in `elattar.yaml`. The recommended and generated default remains `lib/components/ui`.

```console
elattar init --yes
```

Runs non-interactively using source foundations and all safe defaults.

`init` must refuse to replace an existing initialization. Reconfiguration belongs to `config` or `migrate`.

### 9.3 `elattar add`

```console
elattar add button
elattar add button input dialog
```

Installs one or more items plus transitive dependencies. Components always resolve to the configured UI directory.

```console
elattar add --all
```

Installs all stable public component items. It excludes examples, deprecated items, experimental items, and blocks unless flags explicitly include them.

```console
elattar add button@0.2.0
```

Installs a specific registry item version when available.

```console
elattar add ./button.json
elattar add https://example.com/registry/button.json
```

Installs from an explicit local or remote registry item after schema and integrity validation.

Relevant options:

| Option | Meaning |
|---|---|
| `--all` | Install all stable components. |
| `--include-experimental` | Permit explicitly experimental items. |
| `--overwrite` | Replace conflicting files after explicit confirmation. |
| `--no-dependencies` | Refuse installation if missing registry dependencies exist; never create a broken partial install. |

### 9.4 `elattar list`

```console
elattar list
```

Lists registry items with installed, available, experimental, and deprecated status.

```console
elattar list --installed
elattar list --available
elattar list --type component
```

Filters the catalog.

### 9.5 `elattar search`

```console
elattar search dialog
```

Searches names, titles, descriptions, tags, and aliases in the active registry.

```console
elattar search "date picker" --type component
```

Limits results by item type.

### 9.6 `elattar info`

```console
elattar info select
```

Shows description, status, versions, files, dependencies, assets, documentation URL, and whether the item is installed or locally modified.

```console
elattar info select --tree
```

Prints the resolved dependency tree.

### 9.7 `elattar diff`

```console
elattar diff button
```

Compares the locally installed files with their installed registry version.

```console
elattar diff button --latest
```

Compares local files with the latest compatible registry version.

```console
elattar diff --all
```

Reports drift for every installed item. It never changes files.

### 9.8 `elattar update`

```console
elattar update button
elattar update button input
```

Updates selected installed items after resolving dependencies and showing conflicts.

```console
elattar update --all
```

Plans compatible updates for all installed items.

```console
elattar update button --interactive
```

Walks through locally modified conflicts individually. Automatic update is not part of the first CLI MVP; it ships only after diff and conflict behavior are proven.

### 9.9 `elattar remove`

```console
elattar remove button
```

Removes an installed item when no remaining installed item depends on it.

```console
elattar remove button --prune
```

Also proposes removal of now-unused transitive dependencies. Modified files are retained or backed up unless the user explicitly confirms deletion.

```console
elattar remove button --force
```

Allows removal despite dependents only after printing the breakage it will cause. This option should remain deliberately difficult to misuse.

### 9.10 `elattar doctor`

```console
elattar doctor
```

Diagnoses:

- Flutter/Dart compatibility.
- Missing or invalid `elattar.yaml`.
- Foundation mode drift.
- Missing files, fonts, assets, or shaders.
- Broken barrel exports.
- Pubspec mismatches.
- Dependency conflicts.
- Registry availability and cache state.
- Locally modified installed files.
- Formatting and analysis failures.

```console
elattar doctor --fix
```

Applies only unambiguous repairs, such as restoring a missing generated export or pubspec declaration. It does not overwrite customized source.

### 9.11 `elattar migrate foundation`

```console
elattar migrate foundation --to package
```

Plans migration from copied foundations to `elattar_core`, rewrites component imports, adds the dependency, and preserves customized foundation files in a backup. It reports custom tokens that cannot be represented by package configuration.

```console
elattar migrate foundation --to source
```

Copies the compatible foundation version locally, rewrites component imports, moves required fonts/assets into the project, and removes the core dependency when unused.

Migration always supports `--dry-run` and never deletes customized foundations without explicit confirmation.

### 9.12 `elattar config`

```console
elattar config show
```

Prints the resolved configuration and the source of every value.

```console
elattar config get paths.components
```

Prints one resolved setting.

```console
elattar config set paths.components lib/components/ui
```

Updates a supported non-migrating setting after validating it. Path changes affecting installed files require a migration plan rather than silently moving them.

```console
elattar config validate
```

Validates the YAML file and referenced paths without mutating the project.

```console
elattar config migrate
```

Updates an older supported configuration schema after showing the changes.

### 9.13 `elattar registry`

```console
elattar registry list
```

Lists configured registries and cache status.

```console
elattar registry add <name> <url>
```

Adds a named registry to `elattar.yaml` after validating its index.

```console
elattar registry remove <name>
```

Removes a configured registry if installed items do not require it, or warns about affected items.

```console
elattar registry validate [path-or-url]
```

Validates a registry index, item schemas, dependency graph, targets, and integrity hashes. This supports third-party registry authors.

```console
elattar registry cache clear
```

Clears only the CLI's recoverable registry cache, not installed files or snapshots.

### 9.14 `elattar completion`

```console
elattar completion bash
elattar completion zsh
elattar completion fish
elattar completion powershell
```

Prints a shell completion script for the selected shell.

## 10. CLI release scope

### 10.1 MVP commands

The first usable preview includes:

- `init`
- `add`
- `list`
- `search`
- `info`
- `doctor`
- `config show`
- `config validate`
- `registry validate`
- Global `--dry-run`, `--yes`, `--json`, and `--project`

### 10.2 Beta commands

After installation behavior is stable:

- `diff`
- `remove`
- `config set`
- `config migrate`
- `registry add/remove`
- Shell completion

### 10.3 Stable commands

Only after conflict fixtures and migration tests are mature:

- `update`
- `migrate foundation`
- `doctor --fix`

## 11. Documentation website plan

The existing Flutter example app becomes the public documentation website. It consumes public `El*` APIs and foundation tokens; it does not create an unrelated web-only visual system.

### 11.1 Required sections

1. Homepage with positioning, live preview, GitHub, pub.dev, and both install modes.
2. Getting started for package and CLI workflows.
3. Complete CLI reference generated or validated from the executable command model.
4. Foundations: colors, typography, spacing, surfaces, shadows, media, and motion.
5. Component catalog with search and group navigation.
6. One page per component with specimen, install command, import, API, dependencies, states, accessibility, responsive behavior, and source link.
7. Effects and motion catalog.
8. Blocks and composed examples.
9. Theming and customization for both foundation modes.
10. Upgrade, diff, migration, and conflict guidance.
11. Changelog, roadmap, contributing, security, license, and attribution.

### 11.2 Component page contract

Each public component page includes:

- Live light and dark specimens.
- Narrow and wide behavior where relevant.
- Copyable `elattar add <name>` command.
- Package-mode import and source-mode import.
- Variants, sizes, and constructor API.
- Normal, loading, empty, error, success, disabled, focus, and recovery states where applicable.
- Keyboard and semantics notes.
- Registry dependencies and installed files.
- Required assets or shaders.
- GitHub source and issue links.
- Previous and next navigation.

### 11.3 Website interaction and accessibility

- Search and command palette are keyboard accessible.
- Copy actions confirm success through the system toaster.
- Registry failures provide retry and direct GitHub fallback links.
- Deep links and browser back/forward behavior work on GitHub Pages.
- Long text, text scaling, narrow screens, safe areas, focus order, and reduced motion are verified.
- Code remains selectable and readable.
- Loading preserves layout with system skeletons.

### 11.4 Hosting

GitHub Actions builds `example/` with the repository Pages base path, uploads `build/web`, and deploys through GitHub Pages. The release excludes public source maps unless deliberately required. A custom domain can be added later without changing the registry contract.

## 12. Public package readiness

Before the first public release:

1. Confirm final names on pub.dev.
2. Audit redistribution rights for fonts, images, textures, shaders, vendored code, and design lineage.
3. Replace the placeholder root README.
4. Complete `homepage`, `repository`, `issue_tracker`, topics, SDK constraints, and description.
5. Decide the public license and add required third-party notices.
6. Add `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, issue templates, and pull-request guidance.
7. Run `dart pub publish --dry-run` for every publishable package.
8. Generate and inspect `dart doc` output.
9. Establish a verified publisher when a domain is available.
10. Publish initial versions manually, then enable OIDC tag-based automation.

Published APIs and versions are treated as durable. `0.x` releases may evolve, but breaking changes must still be documented and versioned.

## 13. Repository and CI plan

Proposed additions:

```text
packages/elattar_cli/
packages/elattar_core/             # if split after the boundary spike
registry/
tool/registry_builder/
.github/workflows/ci.yml
.github/workflows/docs.yml
.github/workflows/release-package.yml
.github/workflows/release-cli.yml
```

### 13.1 Pull-request CI

- Root `flutter analyze`.
- Root `flutter test` including the token guard.
- Example `flutter analyze` and `flutter test`.
- CLI `dart analyze` and `dart test`.
- Registry schema and graph validation.
- Golden registry generation drift check.
- Fixture installation tests in source and package modes.
- `flutter build web --release` for the docs app.
- Documentation link and command-reference drift checks.

### 13.2 Release workflows

- Tags must match package versions.
- Full CI runs before publishing.
- Registry payloads are immutable per version.
- `latest` is updated only after the versioned payload succeeds.
- Documentation deploys only from the protected release branch or approved workflow.
- Pub.dev publishing uses GitHub OIDC after initial manual publication.

## 14. Test strategy

### 14.1 CLI unit tests

- Configuration parsing and precedence.
- Path normalization on Windows, macOS, and Linux.
- Dependency resolution and cycles.
- Manifest and hash behavior.
- Import transformation.
- Pubspec editing.
- Generated barrel preservation.
- Stable JSON and exit-code output.

### 14.2 Fixture integration tests

For each supported platform, create temporary Flutter apps and verify:

- Default source initialization.
- Package foundation initialization.
- Custom component destination.
- Single and transitive component installs.
- Repeat installs are idempotent.
- Existing file conflicts.
- Locally modified installed files.
- Assets, fonts, and shaders.
- Offline cache behavior.
- Failed network and malformed registry recovery.
- Diff, removal, update, and both migration directions when those commands ship.

Every stable registry item is installed into a clean fixture and must pass formatting and analysis.

### 14.3 Package and website verification

Follow the repository verification ladder:

```console
flutter analyze
flutter test
cd example
flutter analyze
flutter test
flutter build web --release
```

Render documentation routes in light/dark and narrow/wide conditions. Verify focus, reduced motion, long content, and relevant loading/error states.

## 15. Implementation phases

### Phase 0 — Naming, rights, and release decisions

- Confirm product, package, CLI, registry, and domain names.
- Check pub.dev availability.
- Complete the asset and source license audit.
- Decide organization ownership and release authority.
- Record package-versus-core boundary decision criteria.

**Exit:** names are reservable, public distribution is legally supportable, and no bundled asset has unknown rights.

### Phase 1 — Public repository and package

- Replace README and complete package metadata.
- Add public governance and security documents.
- Add core Flutter CI.
- Deploy the current documentation app to GitHub Pages.
- Prepare and publish the first package prerelease.

**Exit:** a new user can discover, install, run, and report issues without private instructions.

### Phase 2 — Registry foundation and five-component pilot

Build the schema, generator, validator, static output, and manifests for:

- Foundation bundle.
- Button.
- Input.
- Card.
- Dialog.
- Select.

These exercise simple files, composition, overlays, state, and transitive dependencies.

**Exit:** generated items install manually into clean fixture applications and pass analysis.

### Phase 3 — CLI MVP

- Create the pure Dart CLI package.
- Implement discovery, config, registry client, cache, resolver, planner, installer, pubspec editor, barrels, manifest, and verification runner.
- Implement the MVP commands.
- Validate source and package foundation boundaries with real fixtures.
- Publish a prerelease CLI.

**Exit:** `elattar init` and `elattar add button` work from a clean Flutter app on Windows, macOS, and Linux.

### Phase 4 — Registry coverage

Migrate items by family:

1. Foundations.
2. Buttons and inputs.
3. Forms, selection, and selects.
4. Dialogs, overlays, and menus.
5. Navigation and layout.
6. Feedback and data display.
7. Charts.
8. Chat and agent components.
9. Effects and shader-backed components.
10. Site composition and blocks.

**Exit:** every stable public export has an explicit registry status and every distributable item passes fixture installation.

### Phase 5 — Safe ownership tools

- Ship diff.
- Ship guarded removal and pruning.
- Add snapshots and conflict fixtures.
- Ship update only when locally modified files are handled safely.
- Ship source-to-package and package-to-source foundation migration.

**Exit:** no supported upgrade or migration path silently destroys consumer changes.

### Phase 6 — Documentation completion

- Add command-reference pages.
- Add install/import/dependency data to every component page.
- Add search, copy feedback, source links, upgrade guidance, and registry recovery states.
- Add blocks and end-to-end examples.
- Complete visual, responsive, and accessibility verification.

**Exit:** the website is sufficient as the only onboarding and reference material for a new consumer.

### Phase 7 — Stable release

- Freeze schema v1 and config v1.
- Define compatibility and deprecation policy.
- Complete release automation.
- Publish stable package, core if applicable, and CLI versions.
- Tag immutable registry artifacts.

**Exit:** stable commands, schemas, paths, and ownership rules are documented and enforced.

## 16. Binding acceptance criteria

The initiative is complete when:

1. `elattar init` defaults to copied source foundations.
2. `elattar init --foundation package` provides the compact alternative.
3. Both modes install every component under `lib/components/ui/` by default.
4. Colors, typography, spacing, surfaces, shadows, media, theme, and basic motion are installed coherently.
5. Components resolve all transitive source, pub, asset, font, and shader requirements.
6. Existing customized files are never overwritten silently.
7. Every mutating operation supports a reliable dry run.
8. Registry payloads are generated and validated from the authoritative Flutter package.
9. Every stable item installs into a clean fixture and passes analysis.
10. The public website documents package mode, both CLI foundation modes, every stable component, accessibility, and upgrade ownership.
11. GitHub Pages, CI, package releases, CLI releases, and versioned registry publication are automated and reproducible.
12. Licensing and third-party attribution have been reviewed before public publication.

## 17. Recommended delivery order

Do not block public usefulness on the complete CLI. Deliver in this order:

1. Public repository readiness.
2. Documentation deployment.
3. Maintained Flutter package prerelease.
4. Registry schema and pilot items.
5. CLI preview with source foundations as the default.
6. Full component registry coverage.
7. Diff, update, removal, and migration safety.
8. Stable releases.

The enduring user promise is concise:

> `elattar init` gives the application its design language.
> `elattar add` gives it selected components.
> Components always live in `lib/components/ui/`, and source-mode files belong to the consumer.
