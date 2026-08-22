# Elattar Design System

Elattar's Flutter design system package: foundations, components, effects, and motion primitives exposed through public `Ds*` APIs.

[Install](#install-today) • [Agent Skill](#agent-skill) • [Development](#development) • [Verification](#verification) • [Contributing](#contributing)

## Status

Version `0.0.1` is the first repository release cut for the maintained Flutter package in this repo.

What exists today:

- The Flutter package under `lib/`
- A docs and specimen app under `example/`
- Package and example test coverage in `test/` and `example/test/`

What is planned and not shipped yet:

- A public CLI with commands like `elattar init` and `elattar add button`
- A generated static component registry for source-copy installs
- A hosted public documentation site built from the existing local `example/` app

## Install Today

This package is not published on pub.dev yet. Until publication, consume it from this repository.

From Git:

```yaml
dependencies:
  elattar_design_system:
    git:
      url: https://github.com/ELATTAR-Ayoub/flutter-design-system.git
```

From a local checkout:

```yaml
dependencies:
  elattar_design_system:
    path: ../flutter-design-system
```

Then run:

```console
flutter pub get
```

## Minimal Usage

```dart
import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    DsTheme(
      controller: DsThemeController(),
      child: const MaterialApp(home: DemoPage()),
    ),
  );
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return ColoredBox(
      color: theme.background,
      child: Center(
        child: DsButton(
          onPressed: () {},
          child: const DsText('Continue', DsType.label),
        ),
      ),
    );
  }
}
```

## What `0.0.1` Covers

The current package includes:

- Foundation tokens and theme data for color, typography, spacing, surfaces, shadows, media, and motion
- Public `Ds*` components spanning forms, selection, overlays, feedback, navigation, data display, charts, chat, and agent-oriented UI
- Visual effects and motion helpers used by the maintained component set
- Bundled package assets for fonts, textures, and the orb shader path used by package tests and the example app

The example app is the best place to inspect real specimens and integration patterns:

- Local docs app entry: [`example/lib/main.dart`](example/lib/main.dart)
- Showcase entry: [`example/lib/showcase_main.dart`](example/lib/showcase_main.dart)

## Agent Skill

This repository carries a coding-agent skill, `elattar-flutter-ui-director`, that teaches an agent to build Flutter UI from this design system: inventory the public `Ds*` APIs before inventing a widget, resolve every visual value from foundation tokens, cover loading/empty/error/success and accessibility states, respect responsive contracts, and run the right verification ladder.

- Skill source: [`skills/elattar-flutter-ui-director/SKILL.md`](skills/elattar-flutter-ui-director/SKILL.md)
- Repository contract: [`AGENTS.md`](AGENTS.md)

The skill is mode-aware. In a checkout of this repository it uses the package layout (`lib/src/foundation/`, `lib/src/components/`, `example/lib/`). In an application that installed the design system through the CLI, it detects `elattar.yaml` and uses that project's layout instead. One skill directory serves both; there is no second copy to drift.

### Using it here

Clone the repository and point your agent at it. Agents that read `AGENTS.md` pick up the contract on their own; the file routes them into the skill. No installation step is involved, because the skill is already in the tree you cloned.

### Using it elsewhere

The repository also contains Claude Code plugin manifests (`.claude-plugin/marketplace.json` and `.claude-plugin/plugin.json`, plugin version `0.0.1`) that expose `skills/` as a plugin payload directly from the repository root.

No external install command is published yet. Two things must land first: this repository has a placeholder `LICENSE`, so there is no grant attached to redistributing the skill, and each install route needs a recorded run before it is documented as working. A command that has not been demonstrated will not be printed here. See [`docs/superpowers/reports/public-release/decisions/005-public-skill-location.md`](docs/superpowers/reports/public-release/decisions/005-public-skill-location.md).

## Planned CLI And Registry

The product direction for this repository includes a source-first installer flow, but it is not part of `0.0.1` yet.

These commands are planned, not currently available:

```console
dart install elattar_cli
elattar init
elattar add button
```

Today, the supported way to use the design system is as the maintained Flutter package from this repository.

## Development

Clone the repository and work from the root package:

```console
flutter pub get
flutter analyze
flutter test
```

To run the docs app locally:

```console
cd example
flutter pub get
flutter run
```

Helpful entry points:

- Package barrel: [`lib/elattar_design_system.dart`](lib/elattar_design_system.dart)
- Root package metadata: [`pubspec.yaml`](pubspec.yaml)
- Example app package metadata: [`example/pubspec.yaml`](example/pubspec.yaml)

## Verification

Core verification in this repository currently centers on Flutter analysis, widget tests, and the parity tooling under [`tool/verify/README.md`](tool/verify/README.md).

Typical checks:

```console
flutter analyze
flutter test
cd example
flutter test
```

Additional focused checks live in:

- [`test/`](test)
- [`example/test/`](example/test)
- [`tool/verify/README.md`](tool/verify/README.md)

## Contributing

Contributions are welcome, but the repository is still in its first public release phase.

Use:

- Issues for bugs, API gaps, and release feedback: [github.com/ELATTAR-Ayoub/flutter-design-system/issues](https://github.com/ELATTAR-Ayoub/flutter-design-system/issues)
- Pull requests for focused improvements: [github.com/ELATTAR-Ayoub/flutter-design-system/pulls](https://github.com/ELATTAR-Ayoub/flutter-design-system/pulls)
- Contribution guide: [`CONTRIBUTING.md`](CONTRIBUTING.md)

If you are changing package behavior, please include the smallest relevant test coverage and note any effect on the example app.

## Repository

- Repository: [github.com/ELATTAR-Ayoub/flutter-design-system](https://github.com/ELATTAR-Ayoub/flutter-design-system)
- Issue tracker: [github.com/ELATTAR-Ayoub/flutter-design-system/issues](https://github.com/ELATTAR-Ayoub/flutter-design-system/issues)
