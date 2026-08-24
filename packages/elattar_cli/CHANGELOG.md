# Changelog

This file covers the `elattar_cli` command only. The design system's own
changelog — components, tokens, effects, motion — lives at
[`CHANGELOG.md`](https://github.com/ELATTAR-Ayoub/flutter-design-system/blob/main/CHANGELOG.md)
in the repository root.

## 0.0.1

First published release.

### Commands

- `elattar init --foundation source` — writes `elattar.yaml`, installs the
  foundation (tokens, theme, typography, motion, the three font faces), wires
  the fonts into your `pubspec.yaml`, and creates `.elattar/manifest.json` as
  the record of what was installed and from which hashes.
- `elattar add <items…>` — installs items and everything they depend on.
  `--all` installs the complete registry.
- `elattar list`, `search <query>`, `info <name>` — read the catalog.
- `elattar doctor` — reports project, config, dependency resolution, manifest,
  and the registry it would use.

Every command takes `--registry PATH_OR_URL` and `--offline`. `init` and `add`
take `--dry-run`; `add` takes `--overwrite`.

### Registry

- Reads a **hosted, version-pinned registry** by default:
  `https://elattar-ayoub.github.io/flutter-design-system/registry/0.0.1/`.
  The path is immutable, so this version installs the same sources for as long
  as it exists — a later registry cannot change what `0.0.1` does.
- `--registry` also accepts a local directory, for contributors and mirrors.
  Inside a checkout of the design system, a local `registry/generated/latest`
  is discovered automatically and the CLI says so rather than choosing quietly.
- Every manifest and every payload is verified against its declared sha256
  **before anything is written**. A failed download or a substituted file
  aborts with your project untouched, not half-installed.
- Responses are bounded: request timeout, capped redirects, named redirect
  loops, and a size limit enforced while streaming.

### Offline

- A per-user cache under your platform's cache directory
  (`%LOCALAPPDATA%`, `~/Library/Caches`, or `$XDG_CACHE_HOME`), overridable
  with `ELATTAR_CACHE_DIR`.
- `--offline` reads only that cache and distinguishes a cache miss from a
  network failure, because they have different fixes.
- Writes are atomic, so an interrupted download never becomes a readable entry.

### Ownership and licensing

- Installed sources are copied into your project and become **your code**.
  Edit them freely; `elattar add --overwrite` is the only thing that replaces
  them, and it never touches files Elattar did not install.
- `init` writes `LICENSES/ELATTAR-MIT.txt`. Items that redistribute
  third-party material carry their own notice: the foundation installs the
  three font OFL notices, `icon` installs lucide's, `voice-orb` installs the
  ElevenLabs UI notice. Keep them — that is the condition all three licenses
  attach to the grant.

### Known limitations

- `--foundation package` is **refused**. It used to write a dependency on a
  package named `elattar_core` that does not exist, producing a project that
  could not resolve. It stays refused until such a package is really
  published; `--foundation source` is the supported path.
- The root `elattar_design_system` package is not on pub.dev. Source
  installation through this CLI is the distribution route.
- Conflicts are all-or-nothing: if any target file differs from what the
  registry holds, `add` exits 73 and writes nothing. Re-run with `--overwrite`
  once you have saved whatever you meant to keep.
