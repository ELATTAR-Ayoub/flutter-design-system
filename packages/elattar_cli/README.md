# elattar_cli

Installs [Elattar](https://github.com/ELATTAR-Ayoub/flutter-design-system)'s
Flutter design system into your project **as source you own**.

There is no `elattar_design_system` dependency to add. `elattar add button`
copies `button.dart` into `lib/components/ui/`, rewrites its imports to point
at your project's own files, and records what it did. From that moment the file
is yours: read it, edit it, delete half of it. Nothing upgrades it behind your
back.

```bash
dart install elattar_cli
cd my_flutter_app
elattar init --foundation source
elattar add button
```

## Install

```bash
dart install elattar_cli
```

On older SDKs, or if you prefer the long spelling:

```bash
dart pub global activate elattar_cli
```

Both put an `elattar` executable on your PATH.

To compile the CLI from the repository instead, taking the default branch
rather than the released version, which is what a contributor wants:

```bash
dart pub global activate --source git \
  https://github.com/ELATTAR-Ayoub/flutter-design-system.git \
  --git-path packages/elattar_cli
```

### `elattar: command not found`

The executable landed in pub's bin directory, which is not on your PATH yet.
Add it:

| Platform | Directory | Add to |
| --- | --- | --- |
| macOS / Linux | `$HOME/.pub-cache/bin` | `~/.zshrc`, `~/.bashrc` |
| Windows | `%LOCALAPPDATA%\Pub\Cache\bin` | your user `Path` variable |

```bash
export PATH="$HOME/.pub-cache/bin:$PATH"
```

If `$PUB_CACHE` is set, the directory is `$PUB_CACHE/bin` instead. Until you
fix the PATH, `dart pub global run elattar_cli:elattar <args>` works from
anywhere.

### Update and uninstall

```bash
dart install elattar_cli          # re-run: installs the newest version
dart pub global deactivate elattar_cli
```

Uninstalling the CLI does not touch anything it installed. Those files are
your project's source now.

## Commands

Run `elattar` with no arguments for the same summary.

| Command | What it does |
| --- | --- |
| `elattar init --foundation source` | Sets the project up: `elattar.yaml`, the foundation sources, the three font faces wired into your `pubspec.yaml`, `LICENSES/ELATTAR-MIT.txt`, and `.elattar/manifest.json`. |
| `elattar add <items…>` | Installs items and everything they depend on. |
| `elattar add --all` | Installs the whole registry. |
| `elattar list` | Every item, with type and description. |
| `elattar search <query>` | Ranked matches over names, descriptions and routes. |
| `elattar info <name>` | One item: version, files, dependencies, targets. |
| `elattar doctor` | Checks the project, config, dependency resolution, manifest and registry. |

### Options

| Option | Applies to | Meaning |
| --- | --- | --- |
| `--registry PATH_OR_URL` | all | Read from this registry instead of the default. A local directory or an `http`/`https` URL. |
| `--offline` | all | Read only from the local cache. Never touches the network. |
| `--dry-run` | `init`, `add` | Print every file that would be written and change nothing. |
| `--overwrite` | `add` | Replace files that differ from the registry's copy. |
| `--foundation source` | `init` | The supported foundation mode. See *Foundation modes*. |
| `--verbose`, `-v` | `doctor` | Include the cache path. |

### Exit codes

| Code | Meaning |
| --- | --- |
| `0` | Success. |
| `1` | `doctor` found problems, or an unexpected internal error. |
| `64` | Usage: an unknown flag, a bad registry value, a registry path that does not exist. |
| `65` | A payload failed its sha256 check, or the dependency graph has a cycle. |
| `66` | No such item in the registry. |
| `70` | The registry could not be read: network failure, timeout, or a cache miss under `--offline`. |
| `72` | No Flutter project found from here. |
| `73` | Conflicts: files on disk differ from the registry's copies. Nothing was written. |
| `78` | `elattar.yaml` or `.elattar/manifest.json` is missing or unusable. |

## Where components come from

By default this CLI reads a **hosted, version-pinned registry**:

```
https://flutter.elattar.dev/registry/0.0.1/
```

That path is immutable. `elattar_cli 0.0.1` will install the same sources in a
year that it installs today, because a later release publishes a new versioned
path rather than changing this one. Nothing you install can change under you
without you changing the CLI version.

Point somewhere else with `--registry`:

```bash
elattar add button --registry https://mirror.example.com/elattar/0.0.1/
elattar add button --registry ../flutter-design-system/registry/generated/latest
```

A URL is recorded in `elattar.yaml` and is safe to commit. A local path is
recorded only when it sits **inside** your project — an absolute path in a
committed config file works on exactly one machine.

Inside a checkout of the design system itself, a local
`registry/generated/latest` is found automatically. When that happens the CLI
prints a note saying so, so a locally-built registry can never quietly stand in
for the published one.

### Integrity

Every manifest and every payload is checked against the sha256 the registry
declares, and **everything is downloaded and verified before the first file is
written**. A dropped connection or a substituted payload aborts the whole
command with your project exactly as it was — never half-installed behind a
barrel that references files which never arrived.

Requests are bounded: a 30-second timeout, at most five redirects, redirect
loops reported by name, and a 16 MiB response ceiling enforced while streaming.

## Offline

Downloads are cached per user, so a second command can run with no network:

```bash
elattar add button            # populates the cache
elattar add card --offline    # reads only the cache
```

| Platform | Cache location |
| --- | --- |
| Windows | `%LOCALAPPDATA%\elattar\registry\v1` |
| macOS | `~/Library/Caches/elattar/registry/v1` |
| Linux | `$XDG_CACHE_HOME/elattar/registry/v1`, else `~/.cache/…` |

Set `ELATTAR_CACHE_DIR` to override — useful in CI, where the cache belongs
inside the workspace.

`--offline` distinguishes the two ways it can fail. *"Nothing cached"* means
run once online first; a connection error means the network. If the cache
directory cannot be written at all, `doctor` says so rather than letting you
discover it when you are already on a plane.

Entries are written atomically, so an interrupted download never becomes a
readable cache entry.

## When `add` refuses

If a file `add` would write already exists and differs from the registry's
copy, the command exits `73`, lists every conflict, and writes **nothing** —
not even the files that would have been fine.

```
add found 2 conflict(s):
 - lib/components/ui/button.dart: Existing file differs from registry source.
```

That is usually correct: you edited an installed file, which you are meant to
be able to do. Your options:

1. **Keep your version** — leave it alone. Nothing was written.
2. **Take the registry's version** — save your changes somewhere, then
   `elattar add button --overwrite`.
3. **See what would change first** — `elattar add button --dry-run` lists every
   destination without touching any of them.

`--overwrite` only replaces files this command would install. It never deletes
or rewrites anything else in your project, including license files you added
yourself.

## Foundation modes

`--foundation source` copies the foundation into
`lib/design_system/foundation/`. It is the only supported mode.

`--foundation package` is **refused**, up front, before your project is
touched. It used to write a dependency on a package named `elattar_core` that
has never existed, so `flutter pub get` failed and the project could not build
— and re-running `init` did not undo it. It stays refused until such a package
is really published.

## What lands in your project

```
elattar.yaml                   # foundation mode and registry
.elattar/manifest.json         # what is installed, at which version, from which hashes
LICENSES/                      # Elattar's MIT notice, plus any third-party notice
lib/components/ui/             # installed components, and the generated ui.dart barrel
lib/design_system/foundation/  # tokens, theme, typography, motion
lib/design_system/effects/     # installed effects
lib/design_system/motion/      # installed motion
assets/elattar/fonts/          # the three faces, wired into your pubspec.yaml
```

`.elattar/manifest.json` is authoritative for what is installed and where.
`elattar.yaml` records only the foundation mode and the registry.

## Licensing

The CLI and Elattar's own sources are MIT — see
[`LICENSE`](LICENSE). That covers Elattar's work and nothing else.

Items that redistribute somebody else's material bring the notice with them,
into your project's `LICENSES/` directory:

| Installing | Puts in `LICENSES/` |
| --- | --- |
| anything (`init`) | `ELATTAR-MIT.txt` |
| the foundation | `Inter-OFL-1.1.txt`, `Geist-Mono-OFL-1.1.txt`, `Redaction-OFL-1.1.txt` |
| `icon`, and so most components | `Lucide-ISC.txt` |
| `voice-indicator` | `ElevenLabs-UI-MIT.txt` |

Keep those files. MIT, ISC and the SIL Open Font License all make carrying the
notice the condition of the grant. None of them asks for visible credit in your
application's interface.

Full provenance for every redistributed file — upstream source, version,
retrieval date and hash — is in
[`THIRD_PARTY_NOTICES.md`](https://github.com/ELATTAR-Ayoub/flutter-design-system/blob/main/THIRD_PARTY_NOTICES.md).

## Links

- Documentation — <https://flutter.elattar.dev>
- Source and issues — <https://github.com/ELATTAR-Ayoub/flutter-design-system>
