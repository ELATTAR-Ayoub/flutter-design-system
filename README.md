# Elattar Design System

A Flutter design system you install as **source you own**, not as a dependency
you track.

`elattar add button` copies `button.dart` into your project, rewrites its
imports to point at your own files, and records what it did. From that moment
the file is yours: read it, edit it, delete half of it. Nothing upgrades it
behind your back.

```bash
dart install elattar_cli
cd my_flutter_app
elattar init --foundation source
elattar add button
```

[Quickstart](#quickstart) • [What you get](#what-you-get) • [Agent skill](#agent-skill) • [Development](#development) • [License](#license) • [Contributing](#contributing)

## Status

`0.0.1`, the first public release.

| | |
| --- | --- |
| CLI | `elattar_cli` `0.0.1` — code, tests and CI gates complete (`dart pub publish --dry-run` reports 0 warnings); not yet published to pub.dev |
| Registry | 99 items — 84 components, 9 effects, 5 motion, 1 foundation — schema v1 |
| Documentation | <https://flutter.elattar.dev> |
| License | MIT for Elattar's own work; see [License](#license) |
| Tests | 1510 package, 795 example, 118 CLI, 45 tooling |

The root `elattar_design_system` package is **not** on pub.dev, and that is
the design rather than a gap: source installation through the CLI is the
product. The package remains the authoritative implementation and can be
consumed directly from Git when you want the dependency model instead — see
[Full package](#full-package).

## Quickstart

```bash
dart install elattar_cli
```

Then, from inside a Flutter project:

```bash
elattar init --foundation source   # foundation, fonts, config, notices
elattar add button                 # one component and its dependencies
elattar add --all                  # or the whole registry
```

`elattar doctor` checks the result. `elattar add <name> --dry-run` shows every
file a command would write without writing any of them.

Full instructions, PATH recovery, offline use and troubleshooting are in the
[CLI package README](packages/elattar_cli/README.md) and on the
[installation page](https://flutter.elattar.dev/docs/installation).

### Where components come from

The CLI reads a hosted registry pinned to its own version —
`/registry/0.0.1/` — and that path is immutable. Publishing a change means
publishing a new version, never rewriting a released one, so what you install
today is what you install next year. `--registry` points at a mirror or a
local directory when you want one.

Every manifest and payload is verified against its declared sha256, and
everything is downloaded and checked **before the first file is written**, so a
failed download leaves your project untouched rather than half-installed.

## What you get

- **Foundation** — colour (OKLab/OKLCH with chroma-reduction gamut mapping),
  typography, spacing, radii, shadows, surfaces, media queries, motion tokens
  with a reduced-motion resolver, and a path-drawn icon registry.
- **Components** — buttons, inputs and the field family, forms with a
  dependency-free validator, selection, selects and pickers, dialogs and
  overlays, menus, navigation, feedback, data display, charts, chat, layout
  primitives, sidebar, and a complete agent-console family.
- **Effects and motion** — surface, background effect, action feedback,
  premium surface, glass, feedback surface, ambient pattern, media scrim,
  the voice indicator; hover builder, press, active indicator, content
  change, keyframes.
- **Three faces** — Inter, Geist Mono and Redaction 35, wired into your
  `pubspec.yaml` under the family names the installed typography asks for.

## Minimal usage

```dart
import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    ThemeScope(
      controller: ThemeController(),
      child: const MaterialApp(home: DemoPage()),
    ),
  );
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return ColoredBox(
      color: theme.background,
      child: Center(
        child: Button(
          onPressed: () {},
          child: const StyledText('Continue', TextStyles.label),
        ),
      ),
    );
  }
}
```

In a project set up by the CLI, the two generated barrels replace that single
package import:

```dart
import 'components/ui/ui.dart';
import 'design_system/foundation.dart';
```

## Full package

If you would rather depend on the package than own the source:

```yaml
dependencies:
  elattar_design_system:
    git:
      url: https://github.com/ELATTAR-Ayoub/flutter-design-system.git
      ref: v0.0.1
```

A `path:` dependency works the same way, and is what this repository's own
`example/pubspec.yaml` uses.

## Agent skill

This repository carries a coding-agent skill,
[`elattar-flutter-ui-director`](skills/elattar-flutter-ui-director/SKILL.md),
that teaches an agent to build Flutter UI from this design system: inventory
the public `El*` APIs before inventing a widget, resolve every visual value
from foundation tokens, cover loading/empty/error/success and accessibility
states, respect responsive contracts, and run the right verification ladder.

It is mode-aware. In a checkout of this repository it uses the package layout
(`lib/src/design_system/foundation/`, `lib/src/components/ui/`, `example/lib/`). In an
application that installed the design system through the CLI, it detects
`elattar.yaml` and uses that project's layout instead. One skill directory
serves both; there is no second copy to drift.

**In this repository** — nothing to install. [`AGENTS.md`](AGENTS.md) sits at
the root and routes any agent that reads it into the skill.

**Elsewhere** — the repository root is also a single-plugin Claude Code
marketplace ([`.claude-plugin/`](.claude-plugin/)), so it can be added as a
plugin source directly. See [`/skills`](https://flutter.elattar.dev/skills)
for each route and its current verification state; routes that have not been
demonstrated end to end say so rather than being presented as working.

## Development

```bash
flutter pub get
flutter analyze
flutter test
```

The docs app:

```bash
cd example
flutter pub get
flutter run
```

The registry, after changing any distributed source:

```bash
dart run tool/registry_builder/bin/build.dart .
dart run tool/registry_builder/bin/validate.dart registry/generated/latest/registry.json
git diff --exit-code -- registry/generated/latest
```

Entry points: [`lib/elattar_design_system.dart`](lib/elattar_design_system.dart)
(the public barrel), [`example/lib/main.dart`](example/lib/main.dart) (the docs
app), [`tool/README.md`](tool/README.md) (every generator and what reruns it).

## Verification

```bash
flutter analyze && flutter test
cd example && flutter analyze && flutter test
cd packages/elattar_cli && dart analyze && dart test
```

`test/token_guard_test.dart` mechanically enforces the no-literal rule — no raw
colours, sizes, radii, shadows, curves or durations outside the foundation
directory. `example/test/public_claims_test.dart` enforces that the site never
tells a reader something untrue about what can be installed. The pixel-parity
rig is documented in [`tool/verify/README.md`](tool/verify/README.md).

## License

Elattar's own work is **MIT** — see [`LICENSE`](LICENSE).

That covers Elattar's code and nothing else. This repository also
redistributes fonts, icon geometry and a shader written by other people, under
their licenses. Every one of them is recorded — upstream source, version,
retrieval date and hash — in
[`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md), and the license texts are
reproduced verbatim under [`third_party/`](third_party/).

Components you install are copied into your project and become your code. The
notices come with them, into your project's `LICENSES/` directory. Keep them:
carrying the notice is the condition MIT, ISC and the SIL Open Font License
each attach to the grant. None of them asks for visible credit in your
application's interface.

## Contributing

- Issues: [github.com/ELATTAR-Ayoub/flutter-design-system/issues](https://github.com/ELATTAR-Ayoub/flutter-design-system/issues)
- Pull requests: [github.com/ELATTAR-Ayoub/flutter-design-system/pulls](https://github.com/ELATTAR-Ayoub/flutter-design-system/pulls)
- Guide: [`CONTRIBUTING.md`](CONTRIBUTING.md)
- Security: [`SECURITY.md`](SECURITY.md)

If you are changing package behaviour, include the smallest relevant test
coverage and note any effect on the example app.
