/// Public documentation page for the `voice-orb` registry item.
///
/// Written from nothing: no page existed for this registry item before this
/// file. Read end to end from `lib/src/effects/voice_orb.dart` (603 lines,
/// `orb.tsx` ported over a vendored Three.js shader) and from
/// `test/agent_voice_test.dart`.
///
/// **Staged as a component, against its own registry type.** `voice-orb` is
/// `"type": "effect"` in `registry/generated/latest/registry.json` — see
/// `meta.dart`'s own library note — but it is a real, always-visible
/// surface with its own states rather than a treatment applied to a host,
/// so every section below is a [ShowcaseSection], the shape every component
/// page uses, not [EffectSection].
///
/// **`state` is carried but barely read.** The source's own library note,
/// divergence 2: `orb.tsx` always runs in manual mode, and in manual mode
/// the vendored shader never inspects `agentState` — the four states below
/// differ only in the random phase each seed produces, not in colour or
/// motion. Reproduced here exactly as upstream does it, with the same four
/// stable seeds the agent voice console page already uses, so this page and
/// that one draw the same pixels for the same reason.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

/// `AGENT_STATE` in `OrbStates`, `agent_voice.dart`'s own order — reused so
/// the two pages draw the same four labelled discs.
const List<(ElOrbState, String)> _orbStates = <(ElOrbState, String)>[
  (ElOrbState.idle, 'idle'),
  (ElOrbState.listening, 'listening'),
  (ElOrbState.thinking, 'thinking'),
  (ElOrbState.talking, 'talking'),
];

/// Stable per-cell seeds, `agent_voice.dart`'s own: fixed so a capture rig
/// and this page's own test see one image rather than a new one per boot.
const List<int> _orbSeeds = <int>[10, 20, 30, 40];

final ComponentDocSpec voiceOrbDocSpec = ComponentDocSpec(
  name: 'voice-orb',
  title: 'Voice Orb',
  description: voiceOrbDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The four ElOrbState values, each a differently seeded disc. '
          'They read the same because state is barely read: manual mode '
          "never inspects it — see this page's own library note.",
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(72),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'voice-orb has a real registry manifest, `elattar add '
          'voice-orb` installs lib/src/effects/voice_orb.dart plus its '
          'shader, its perlin texture, and its vendored licence, and '
          'resolves source-foundation automatically. The Manual tab is '
          'for a project not using the CLI.',
      command: voiceOrbDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/effects/voice_orb.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/effects/voice_orb.dart's generated "
              '@effects/voice_orb.dart payload, plus '
              '@shaders/orb.frag and @assets/textures/perlin-noise.png, '
              'into your own project.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated voice-orb source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/effects/effects.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElVoiceOrb, ElOrbState and '
              'ElOrbProgram are reachable the same way the CLI path '
              'already makes them.',
          code: "export 'voice_orb.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction. Every example '
          'below only changes named arguments on top of this.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'level',
      title: 'Level',
      description:
          'level is the one prop that visibly moves the orb: a '
          'ValueListenable<double> the caller already reads, never a '
          'stream this widget opens itself. Null (left) leaves the orb '
          'at rest; a held 0.8 (right) is what a loud, sustained input '
          'looks like once the 0.2-per-frame follow catches up.',
      specimen: _LevelSpecimen(),
      code: _levelCode,
      label: 'Level specimen view',
    ),
    ShowcaseSection(
      id: 'size',
      title: 'Size',
      description:
          'size is a single double, the box the disc is drawn inside — '
          "the disc itself is size * ElVoiceOrb.discFraction (0.912…) "
          'across, measured against the live reference rather than only '
          'derived from its camera geometry.',
      specimen: _SizeSpecimen(),
      code: _sizeCode,
      label: 'Size specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter ElVoiceOrb declares, every '
          'ElOrbState value, and the public statics on ElVoiceOrb and '
          'ElOrbProgram: one table per exported class or enum.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElVoiceOrb', anchor: 'api-elvoiceorb'),
        DocsTocEntry(
          title: 'ElVoiceOrb statics',
          anchor: 'api-elvoiceorb-static',
        ),
        DocsTocEntry(title: 'ElOrbState', anchor: 'api-elorbstate'),
        DocsTocEntry(title: 'ElOrbProgram', anchor: 'api-elorbprogram'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off _ElVoiceOrbState._tick and _play directly, not '
          'inferred: the ticker is a hand-integrated feedback loop, not '
          'an AnimationController curve.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description:
          'ElVoiceOrb carries no Semantics node anywhere in the file: '
          'the paint chain is RepaintBoundary > CustomPaint > '
          '_OrbPainter, and nothing wraps it in a Semantics widget.',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'ElVoiceOrb takes no focus and handles no key: there is no '
          'Focus widget anywhere in voice_orb.dart. It is a painted '
          'surface, not a control.',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: voiceOrbDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/agent_voice_test.dart',
            description:
                'Covers ElVoiceOrb, held to the painter rule in full — '
                'rendered pixels, not recipe parameters — together with '
                'ElLiveWaveform, ElBarVisualizer and ElMicControl.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/voice_orb_test.dart',
            description:
                'Covers this page: the article mounts, the full API '
                'table, and every ElOrbState this page claims to show.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/voice_orb/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class VoiceOrbDocPage extends StatelessWidget {
  const VoiceOrbDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: voiceOrbDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / AGENT',
      title: voiceOrbDoc.title,
      description: voiceOrbDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Voice Orb'),
    ],
    toc: voiceOrbDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('voice-orb-doc-article'),
      child: ComponentDocPage(spec: voiceOrbDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  static const double _orbSize = 112;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(8),
    runSpacing: el(6),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      for (int i = 0; i < _orbStates.length; i++)
        _OrbCell(
          orbKey: 'voice-orb-preview:${_orbStates[i].$2}',
          state: _orbStates[i].$1,
          label: _orbStates[i].$2,
          seed: _orbSeeds[i],
        ),
    ],
  );
}

class _OrbCell extends StatelessWidget {
  const _OrbCell({
    required this.orbKey,
    required this.state,
    required this.label,
    required this.seed,
  });

  final String orbKey;
  final ElOrbState state;
  final String label;
  final int seed;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        KeyedSubtree(
          key: ValueKey<String>(orbKey),
          child: ElVoiceOrb(
            state: state,
            size: _PreviewSpecimen._orbSize,
            seed: seed,
          ),
        ),
        SizedBox(height: el(3)),
        ElText(label, ElType.small, color: theme.mutedForeground),
      ],
    );
  }
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    '// Each seed is fixed, so the disc\'s own random phase stays stable\n'
    '// across rebuilds.\n'
    'ElVoiceOrb(state: ElOrbState.idle, size: 112, seed: 10)\n'
    'ElVoiceOrb(state: ElOrbState.listening, size: 112, seed: 20)\n'
    'ElVoiceOrb(state: ElOrbState.thinking, size: 112, seed: 30)\n'
    'ElVoiceOrb(state: ElOrbState.talking, size: 112, seed: 40)';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

const ElVoiceOrb()''';

class _LevelSpecimen extends StatelessWidget {
  const _LevelSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(8),
    runSpacing: el(6),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      const KeyedSubtree(
        key: ValueKey<String>('voice-orb-example:level-rest'),
        child: ElVoiceOrb(seed: 1),
      ),
      KeyedSubtree(
        key: const ValueKey<String>('voice-orb-example:level-loud'),
        child: ElVoiceOrb(
          state: ElOrbState.listening,
          level: _heldLevel,
          seed: 1,
        ),
      ),
    ],
  );

  /// A held, non-animating level: `ElVoiceOrb.level` is read once per tick
  /// rather than rebuilding this widget, so a plain `ValueNotifier` that
  /// never changes is enough to show the "loud, sustained input" shape
  /// without inventing a fake waveform.
  static final ValueListenable<double> _heldLevel = ValueNotifier<double>(0.8);
}

const String _levelCode =
    '// Null: the orb sits at rest, chasing a target of 0.\n'
    'const ElVoiceOrb(seed: 1)\n\n'
    '// A caller\'s own analyser reading, already read into a\n'
    '// ValueListenable<double> — this widget never opens one itself.\n'
    'ElVoiceOrb(state: ElOrbState.listening, level: myLevel, seed: 1)';

class _SizeSpecimen extends StatelessWidget {
  const _SizeSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(8),
    runSpacing: el(6),
    crossAxisAlignment: WrapCrossAlignment.end,
    children: const <Widget>[
      KeyedSubtree(
        key: ValueKey<String>('voice-orb-example:size-sm'),
        child: ElVoiceOrb(size: 48, seed: 7),
      ),
      KeyedSubtree(
        key: ValueKey<String>('voice-orb-example:size-default'),
        child: ElVoiceOrb(seed: 7),
      ),
      KeyedSubtree(
        key: ValueKey<String>('voice-orb-example:size-lg'),
        child: ElVoiceOrb(size: 160, seed: 7),
      ),
    ],
  );
}

const String _sizeCode =
    'ElVoiceOrb(size: 48, seed: 7)\n'
    'const ElVoiceOrb(seed: 7) // size defaults to 96\n'
    'ElVoiceOrb(size: 160, seed: 7)';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elvoiceorb',
        child: DocsApiTable(title: 'ElVoiceOrb', facts: _voiceOrbFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elvoiceorb-static',
        child: DocsApiTable(
          title: 'ElVoiceOrb statics',
          facts: _voiceOrbStaticFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elorbstate',
        child: DocsApiTable(title: 'ElOrbState', facts: _orbStateFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elorbprogram',
        child: DocsApiTable(title: 'ElOrbProgram', facts: _orbProgramFacts),
      ),
    ],
  );
}

const List<DocsApiFact> _voiceOrbFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'state',
    type: 'ElOrbState',
    description:
        'Optional. Defaults to ElOrbState.idle. Splits the follow '
        "target between listening (level drives uInputVolume) and "
        'everything else (level drives uOutputVolume) — see the '
        'ElOrbState table below. Barely visible while level is null.',
  ),
  DocsApiFact(
    name: 'level',
    type: 'ValueListenable<double>?',
    description:
        'Optional. Defaults to null, which leaves the orb at rest. The '
        '0–1 level a caller already reads off its own analyser; read '
        'inside the ticker every frame, never triggering a rebuild of '
        'this widget itself.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'double',
    description: 'Optional. Defaults to 96 (defaultSize).',
  ),
  DocsApiFact(
    name: 'seed',
    type: 'int?',
    description:
        'Optional. Defaults to null, which takes a random seed on '
        'mount, as upstream does — two orbs with no seed are never in '
        'phase. Pass one for a reproducible, pinnable disc.',
  ),
];

const List<DocsApiFact> _voiceOrbStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElVoiceOrb.defaultSize',
    type: 'static const double',
    description: "96 — the vendor's own default box.",
  ),
  DocsApiFact(
    name: 'ElVoiceOrb.discFraction',
    type: 'static const double',
    description:
        'The fraction of size the disc actually covers, 0.9122577… — '
        "derived from the vendor's camera geometry, then measured "
        'against the live reference to half a pixel.',
  ),
  DocsApiFact(
    name: 'ElVoiceOrb.offsetsForSeed(seed)',
    type: 'static List<double>',
    description:
        '@visibleForTesting. The seven phase offsets a given seed '
        "produces — exposed so a test can prove the ported splitmix32 "
        "is bit-identical to the browser's own.",
  ),
];

const List<DocsApiFact> _orbStateFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'idle',
    type: 'enum value',
    description: "The vendor's null agent state. Alive, but not engaged.",
  ),
  DocsApiFact(
    name: 'listening',
    type: 'enum value',
    description: 'The user is speaking. level drives uInputVolume.',
  ),
  DocsApiFact(
    name: 'talking',
    type: 'enum value',
    description: 'The assistant is speaking. level drives uOutputVolume.',
  ),
  DocsApiFact(
    name: 'thinking',
    type: 'enum value',
    description:
        'Working, not speaking. level drives uOutputVolume, exactly as '
        'talking does — the split the shader draws is listening against '
        'everything else.',
  ),
];

const List<DocsApiFact> _orbProgramFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElOrbProgram.load()',
    type: 'static Future<ElOrbProgram?>',
    description:
        'Compiles shaders/orb.frag and decodes the perlin texture once '
        'per isolate; every call after the first returns the same '
        'future, so twenty orbs on a page compile one programme between '
        'them. Resolves null on failure rather than throwing.',
  ),
  DocsApiFact(
    name: 'ElOrbProgram.loaded',
    type: 'static ElOrbProgram?',
    description: 'The loaded pair, or null while it is still arriving.',
  ),
  DocsApiFact(
    name: 'ElOrbProgram.lastError',
    type: 'static Object?',
    description:
        'Why the last load() gave up, or null if it did not — kept so a '
        'test report can tell an absent asset bundle apart from a real '
        'toolchain failure.',
  ),
  DocsApiFact(
    name: 'ElOrbProgram.resetForTest()',
    type: 'static void',
    description:
        '@visibleForTesting. Forgets what was loaded, so a suite can '
        'prove both the success and the failure branch.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Loading',
    treatment:
        'The shader has not compiled yet (ElOrbProgram.loaded is '
        'null): build returns SizedBox.square(dimension: size) and '
        'paints nothing — "guessing a colour would produce a visible '
        'flash of the wrong one."',
    userSignal: 'An empty box the size the orb will occupy.',
  ),
  DocsStateFact(
    state: 'Fade-in',
    treatment:
        'uOpacity climbs 0 → 1 at delta * 2 once the shader is ready — '
        'half a second to full opacity.',
    userSignal: 'The disc eases in rather than popping into view.',
  ),
  DocsStateFact(
    state: 'level: null',
    treatment:
        'The ticker still runs — uTime always advances — but curIn and '
        'curOut both chase a target of 0 at the same 0.2-per-frame '
        'follow every other state uses.',
    userSignal: 'A quiet, resting disc: alive, not engaged.',
  ),
  DocsStateFact(
    state: 'level fed, listening',
    treatment:
        'targetIn = level, targetOut = 0. curIn chases the fed value; '
        'animation speed itself chases a target derived from curOut, '
        'so a listening orb\'s motion is driven by the OTHER volume\'s '
        'own trailing value.',
    userSignal: 'The disc brightens and quickens toward the fed level.',
  ),
  DocsStateFact(
    state: 'level fed, talking or thinking',
    treatment: 'targetOut = level, targetIn = 0 — the mirror of listening.',
    userSignal: 'The same motion, driven by the other channel.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The ticker stops rather than collapsing to a zero-duration '
        'curve — there is no curve to collapse, it is a hand-integrated '
        'loop. uOpacity is forced to 1 first, so a frozen entrance ends '
        'on a fully visible disc rather than freezing on an invisible one.',
    userSignal: 'The disc stops moving, fully visible, on its last frame.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No Semantics node anywhere in voice_orb.dart: the widget tree '
            'is RepaintBoundary > CustomPaint, nothing more. A screen '
            'reader has no accessible name, role or value for the orb at '
            'all — a sighted-only signal, matching the source\'s own '
            'framing of state as barely read.',
        'A caller composing ElVoiceOrb into a larger control (as '
            'ElAgentFace does) is responsible for whatever Semantics that '
            'larger control needs; this widget contributes none of its '
            'own.',
        'No touch target: the orb takes no gesture of any kind, so §2\'s '
            'target-size rule does not apply to it.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No Focus widget anywhere in voice_orb.dart: the orb cannot be '
            'focused and answers to no key.',
        'Not in Tab order: canRequestFocus is never set because there is '
            'no FocusNode to set it on.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching anywhere in voice_orb.dart: '
            'BuildContext width is never read.',
        'size is a plain constructor double the caller sets; nothing in '
            'this file ties it to a viewport.',
        'Platform parity: the shader and its texture are the only '
            'platform-sensitive part, and that sensitivity is the '
            'backend (SkSL vs Impeller), not the device class — the '
            'source\'s own note records one GLSL construct SkSL rejected '
            'outright that Impeller accepted, fixed once, in the shader '
            'itself, not per platform here.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/effects/voice_orb.dart, plus two non-Dart assets '
            'the manifest ships alongside it: shaders/orb.frag (the '
            'ported fragment programme) and assets/textures/'
            'perlin-noise.png (the noise field it samples).',
        'Flutter imports: dart:async, dart:math, dart:ui, package:'
            'flutter/foundation.dart (ValueListenable, @visibleForTesting), '
            'package:flutter/scheduler.dart (Ticker, createTicker), '
            'package:flutter/services.dart (rootBundle), package:flutter/'
            'widgets.dart.',
        'Foundation imports: foundation/colors.dart (ElPalette — the '
            'orb\'s two gradient stops are ramp members read here rather '
            'than added to ElThemeData), foundation/theme.dart, '
            'theme_scope.dart (ElTheme).',
        'registryDependencies, resolved automatically by `elattar add '
            'voice-orb`: source-foundation alone — copied verbatim from '
            'this item\'s registry entry.',
        'The manifest also carries a licences field naming '
            'third_party/elevenlabs-ui/LICENSE, installed as '
            '@license/ElevenLabs-UI-MIT.txt: the orb itself is vendored '
            'from ElevenLabs\' UI kit, and that attribution ships with '
            'every install — not a registryDependency, a licence file.',
      ]),
      SizedBox(height: el(2)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(
            label: 'Source Foundation',
            route: '/components/source_foundation',
          ),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Two gradient stops, resolved from ElThemeKind against '
            'ElPalette rather than from ElThemeData: light reads '
            'ElPalette.action / ElPalette.actionDark, dark reads '
            'ElPalette.actionBright / ElPalette.action — the same '
            'ruling this port applies wherever a token the shader needs '
            'is not on ElThemeData itself.',
        'Both stops are converted sRGB → linear before they reach the '
            'shader (_OrbPainter._linear): the vendored fragment writes '
            'straight to an sRGB framebuffer with no encoding step, so '
            'feeding it raw sRGB paints a visibly brighter disc than the '
            'live reference. Reproduced, not corrected.',
        'inverted (ElThemeKind.dark) reorders which stop the shader '
            'treats as the near colour — read fresh from ElTheme.kindOf '
            'every build, so flipping the theme controller re-resolves '
            'both stops on the next frame.',
        'Nothing about the shape, the disc fraction, or the shader '
            'itself is theme-aware: only colour is.',
      ]);
}

Widget _bullets(ElThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText('•  $line', ElType.small, color: theme.mutedForeground),
      ),
      SizedBox(height: el(2)),
    ],
  ],
);
