/// Public documentation page for the `voice` component.
///
/// Written from nothing: no page existed for this registry item before this
/// file. Read end to end from `lib/src/components/voice.dart` (three
/// widgets, two reference files) and from `test/agent_voice_test.dart`
/// (which covers this family together with the orb).
///
/// **No microphone crosses.** Web Audio, `getUserMedia` and
/// `SpeechRecognition` are browser APIs with no Flutter equivalent this
/// package will pull a plugin for, so [ElLiveWaveform.samples] and
/// [ElBarVisualizer.spectrum] are left null on every specimen here — the
/// source's own documented branch for a closed microphone, not a shortcut
/// this page took. [ElBarVisualizer.active] is the one exception the source
/// itself carves out: a signal that playback is running, not a reading of
/// it, and it is shown in full below.
///
/// **`ElMicControl`'s menu half is not built.** The source's own docstring
/// records that upstream renders a device/voice picker chevron beside the
/// mic only when more than one device or a speech toggle exists, and that
/// branch depends on `enumerateDevices` and `speechSynthesis` — two more
/// browser APIs this package does not reach for. The specimen below is the
/// single 34×34 pill the source's own reference measures with none of those
/// wired, which is the whole public surface [ElMicControl] has.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec voiceDocSpec = ComponentDocSpec(
  name: 'voice',
  title: 'Voice',
  description: voiceDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The mic pill, the time-domain waveform, and the twelve-band '
          'visualiser, wired together the way the reference composes '
          'them: one row, one shared signal. Nothing here fabricates '
          'audio — the mic arms, but the two visualisers stay flat and '
          'at their floor because there is genuinely nothing to draw '
          'without a real analyser.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'voice has a real registry manifest, `elattar add voice` '
          'installs lib/src/components/voice.dart and resolves its three '
          'registryDependencies automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: voiceDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/voice.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/voice.dart's generated "
              '@ui/voice.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated voice source here when using manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElLiveWaveform, ElBarVisualizer '
              'and ElMicControl are reachable the same way the CLI path '
              'already makes them.',
          code: "export 'voice.dart';",
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
      id: 'live-waveform',
      title: 'Live waveform',
      description:
          'ElLiveWaveform draws the trace held in samples, already '
          'centred (−1 … 1). Null — every specimen on this page — draws '
          '"a flat line, which is the truth," the source\'s own words '
          'for a closed microphone. width and height default to 120×28; '
          'the wider lane below is what the agent voice console passes.',
      specimen: _LiveWaveformSpecimen(),
      code: _liveWaveformCode,
      label: 'Live waveform specimen view',
    ),
    ShowcaseSection(
      id: 'bar-visualizer',
      title: 'Bar visualizer',
      description:
          'ElBarVisualizer draws twelve frequency bands from spectrum '
          '(0 … 255 per bin), null here for the same reason. At rest '
          'every bar sits at its 0.06 floor, "present-but-quiet rather '
          'than broken." active: true is the one exception the source '
          'carves out for itself: a sine-driven oscillator that signals '
          'playback is running without reading it — it never stops '
          'animating while active stays true.',
      specimen: _BarVisualizerSpecimen(),
      code: _barVisualizerCode,
      label: 'Bar visualizer specimen view',
    ),
    ShowcaseSection(
      id: 'mic-control',
      title: 'Mic control',
      description:
          'ElMicControl is one pill, always: the bordered tint changes '
          'on listening, never a second control that appears only while '
          'live. Press the first pill to arm it. The third is disabled: '
          'true, which mutes the tap without changing the fill.',
      specimen: _MicControlSpecimen(),
      code: _micControlCode,
      label: 'Mic control specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter each of the three exported '
          'widgets declares: one table per class.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElLiveWaveform', anchor: 'api-ellivewaveform'),
        DocsTocEntry(title: 'ElBarVisualizer', anchor: 'api-elbarvisualizer'),
        DocsTocEntry(title: 'ElMicControl', anchor: 'api-elmiccontrol'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Three different signal states, read straight off '
          '_BarsPainter._levels, _WaveformPainter.paint and _MicButton, '
          'not inferred.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'voice.dart wires no key handling of its own anywhere in the '
          'file — every fact here is either inherited from ElButton or '
          'about what does not happen.',
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
    DisclosureSection(id: 'theming', title: 'Theming', child: _ThemingContent()),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: voiceDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/agent_voice_test.dart',
            description:
                'Covers ElLiveWaveform, ElBarVisualizer and ElMicControl '
                'together with ElVoiceOrb — the family this page and the '
                'voice-orb page split apart.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/voice_test.dart',
            description:
                'Covers this page: the article mounts, the full API '
                'table, and every specimen this page claims to show.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/voice/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class VoiceDocPage extends StatelessWidget {
  const VoiceDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: voiceDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / AGENT',
      title: voiceDoc.title,
      description: voiceDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Voice'),
    ],
    toc: voiceDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('voice-doc-article'),
      child: ComponentDocPage(spec: voiceDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  bool _listening = false;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      KeyedSubtree(
        key: const ValueKey<String>('voice-preview:mic'),
        child: ElMicControl(
          listening: _listening,
          onToggle: () => setState(() => _listening = !_listening),
        ),
      ),
      SizedBox(width: el(6)),
      const KeyedSubtree(
        key: ValueKey<String>('voice-preview:waveform'),
        child: ElLiveWaveform(width: 160, height: 40),
      ),
      SizedBox(width: el(6)),
      const KeyedSubtree(
        key: ValueKey<String>('voice-preview:bars'),
        child: ElBarVisualizer(),
      ),
    ],
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'Row(\n'
    '  children: [\n'
    '    ElMicControl(\n'
    '      listening: listening,\n'
    '      onToggle: () => setState(() => listening = !listening),\n'
    '    ),\n'
    '    const ElLiveWaveform(width: 160, height: 40),\n'
    '    const ElBarVisualizer(),\n'
    '  ],\n'
    ')';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

const ElLiveWaveform()''';

class _LiveWaveformSpecimen extends StatelessWidget {
  const _LiveWaveformSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(6),
    runSpacing: el(4),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: const <Widget>[
      KeyedSubtree(
        key: ValueKey<String>('voice-example:waveform-default'),
        child: ElLiveWaveform(),
      ),
      KeyedSubtree(
        key: ValueKey<String>('voice-example:waveform-wide'),
        child: ElLiveWaveform(width: 320, height: 48),
      ),
    ],
  );
}

const String _liveWaveformCode =
    '// Closed microphone: samples null draws a flat line.\n'
    'const ElLiveWaveform() // 120×28, the source\'s own default\n'
    'const ElLiveWaveform(width: 320, height: 48) // the console\'s lane';

class _BarVisualizerSpecimen extends StatelessWidget {
  const _BarVisualizerSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(6),
    runSpacing: el(4),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: const <Widget>[
      KeyedSubtree(
        key: ValueKey<String>('voice-example:bars-floor'),
        child: ElBarVisualizer(),
      ),
      KeyedSubtree(
        key: ValueKey<String>('voice-example:bars-active'),
        child: ElBarVisualizer(active: true),
      ),
    ],
  );
}

const String _barVisualizerCode =
    '// No spectrum, not active: twelve bars at their 0.06 floor.\n'
    'const ElBarVisualizer()\n\n'
    '// No spectrum, active: a sine oscillator signals playback is\n'
    '// running — it animates for as long as active stays true.\n'
    'const ElBarVisualizer(active: true)';

class _MicControlSpecimen extends StatefulWidget {
  const _MicControlSpecimen();

  @override
  State<_MicControlSpecimen> createState() => _MicControlSpecimenState();
}

class _MicControlSpecimenState extends State<_MicControlSpecimen> {
  bool _listening = false;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(6),
    runSpacing: el(4),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      KeyedSubtree(
        key: const ValueKey<String>('voice-example:mic-idle'),
        child: ElMicControl(
          listening: _listening,
          onToggle: () => setState(() => _listening = !_listening),
        ),
      ),
      const KeyedSubtree(
        key: ValueKey<String>('voice-example:mic-listening'),
        child: ElMicControl(listening: true),
      ),
      const KeyedSubtree(
        key: ValueKey<String>('voice-example:mic-disabled'),
        child: ElMicControl(listening: false, disabled: true),
      ),
    ],
  );
}

const String _micControlCode =
    '// Tap toggles listening, which is the only prop that changes\n'
    '// the pill\'s fill, border and glyph colour.\n'
    'ElMicControl(\n'
    '  listening: listening,\n'
    '  onToggle: () => setState(() => listening = !listening),\n'
    ')\n\n'
    '// disabled mutes the tap without changing the fill.\n'
    'const ElMicControl(listening: false, disabled: true)';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-ellivewaveform',
        child: DocsApiTable(
          title: 'ElLiveWaveform',
          facts: _liveWaveformFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elbarvisualizer',
        child: DocsApiTable(
          title: 'ElBarVisualizer',
          facts: _barVisualizerFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elmiccontrol',
        child: DocsApiTable(title: 'ElMicControl', facts: _micControlFacts),
      ),
    ],
  );
}

const List<DocsApiFact> _liveWaveformFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'samples',
    type: 'ValueListenable<Float32List>?',
    description:
        'Optional. Defaults to null. The time-domain trace, already '
        'centred to −1 … 1 (what analyser.getByteTimeDomainData would '
        'have written, pre-transformed). Null draws a flat line at the '
        "midpoint: a closed microphone, drawn honestly.",
  ),
  DocsApiFact(
    name: 'width',
    type: 'double',
    description: 'Optional. Defaults to 120 (defaultWidth).',
  ),
  DocsApiFact(
    name: 'height',
    type: 'double',
    description: 'Optional. Defaults to 28 (defaultHeight).',
  ),
];

const List<DocsApiFact> _barVisualizerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'spectrum',
    type: 'ValueListenable<Float32List>?',
    description:
        'Optional. Defaults to null. Frequency bins, 0 … 255 per bin '
        'in bin order (what analyser.getByteFrequencyData would have '
        'written). Null with active: false draws every bar at its floor.',
  ),
  DocsApiFact(
    name: 'active',
    type: 'bool',
    description:
        'Optional. Defaults to false. A sine-driven oscillator that '
        'signals playback is running when there is no analyser to read — '
        '"a signal that playback is running, not a reading of it." '
        'Animates continuously while true.',
  ),
  DocsApiFact(
    name: 'bars',
    type: 'int',
    description: 'Optional. Defaults to 12 (defaultBars).',
  ),
  DocsApiFact(
    name: 'width',
    type: 'double',
    description: 'Optional. Defaults to 96 (defaultWidth).',
  ),
  DocsApiFact(
    name: 'height',
    type: 'double',
    description: 'Optional. Defaults to 24 (defaultHeight).',
  ),
];

const List<DocsApiFact> _micControlFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'listening',
    type: 'bool',
    description:
        'Required. The only prop that changes the pill\'s fill, border '
        'and glyph colour, and the only thing driving the live pulse '
        'ring underneath the button.',
  ),
  DocsApiFact(
    name: 'onToggle',
    type: 'VoidCallback?',
    description:
        'Optional. Defaults to null, which disables the mic button the '
        'same way a null onPressed disables any ElButton.',
  ),
  DocsApiFact(
    name: 'disabled',
    type: 'bool',
    description:
        'Optional. Defaults to false. Passed straight through as a '
        'null onPressed on the inner ElButton when true.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Waveform · silent',
    treatment:
        'samples: null. _WaveformPainter draws a single flat line at '
        'size.height / 2 and returns — no interpolation, no fade.',
    userSignal: 'A dead flat line: the closed-microphone truth.',
  ),
  DocsStateFact(
    state: 'Waveform · signal',
    treatment:
        'samples non-null. Every value in the Float32List is plotted '
        'left to right, y = mid + value · mid · 0.9, so the trace never '
        'quite reaches the top or bottom edge.',
    userSignal: 'A moving trace of whatever is in the buffer.',
  ),
  DocsStateFact(
    state: 'Bars · silent',
    treatment:
        'spectrum: null, active: false. _levels() returns twelve zeros; '
        'the paint loop still applies math.max(floor, smoothed[i]), so '
        'every bar renders at 0.06 of the box height.',
    userSignal: 'Twelve short pills: present-but-quiet, not broken.',
  ),
  DocsStateFact(
    state: 'Bars · active',
    treatment:
        'spectrum: null, active: true. A per-bar sine oscillator drives '
        'each level, max(0.08, |sin(t·4 + i·0.7)| · 0.8 · (1 − |i/bars '
        '− 0.5|)); the ticker runs for as long as active stays true.',
    userSignal: 'The bars breathe, unevenly, never settling.',
  ),
  DocsStateFact(
    state: 'Bars · signal',
    treatment:
        'spectrum non-null. Each bar reduces one logarithmic band of the '
        'spectrum, smoothed 0.55 kept / 0.45 taken per frame.',
    userSignal: 'A live twelve-band meter, smoothed against jitter.',
  ),
  DocsStateFact(
    state: 'Mic · idle',
    treatment: 'listening: false. theme.border rim, no fill, no pulse.',
    userSignal: 'A plain 34×34 outlined pill around a mic glyph.',
  ),
  DocsStateFact(
    state: 'Mic · listening',
    treatment:
        'listening: true. theme.agent 45%-alpha border, theme.agent '
        '12%-alpha fill, the glyph inherits theme.agent through '
        'DefaultTextStyle, and a ring shadow pulses on a 2s ease-in-out '
        'clock (ElDurations.pulseLive) for as long as it stays true.',
    userSignal: 'A tinted, breathing pill: unmistakably armed.',
  ),
  DocsStateFact(
    state: 'Mic · disabled',
    treatment:
        'disabled: true forces a null onPressed on the inner ElButton, '
        'which takes over: 45% opacity, no pointer events, no focus.',
    userSignal: 'Faded and inert, whatever listening says.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The pulse ring routes through elAnimationDuration, which '
        'collapses ElDurations.pulseLive to zero under '
        'MediaQuery.disableAnimations — the ring hard-cuts to its rest '
        'frame instead of breathing. active: true keeps ticking '
        'regardless: it is a real per-frame integration, not an '
        'AnimationController this package can zero out.',
    userSignal:
        'The mic pill stops breathing; the active bar oscillator does not.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElLiveWaveform and ElBarVisualizer carry no Semantics node at '
            'all: each is a bare CustomPaint inside a RepaintBoundary. A '
            'screen reader has nothing to read off either one — a sighted-'
            'only signal, and an honest gap rather than an oversight.',
        'ElMicControl is accessible through the ElButton it composes '
            '(_MicButton): Semantics(button: true) with label switching '
            'between "Dictate" and "Stop dictation" as listening flips.',
        'Known gap: the live pulse ring is visual only. Nothing on the '
            'Semantics node reports that recording started beyond the '
            'label text changing — no busy or live-region flag.',
        'Touch target: the mic pill measures 34×34 (a 32px ElButtonSize'
            '.iconSm button plus a 1px border on every side), under the '
            '44px floor this system otherwise favours for a control.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElLiveWaveform and ElBarVisualizer take no focus and handle no '
            'key: both are painters with nothing beneath them but a '
            'RepaintBoundary and a CustomPaint.',
        'ElMicControl activates through the ElButton it composes: Enter, '
            'NumpadEnter and Space toggle a focused, enabled mic pill, '
            'the same as any other button in this system.',
        'canRequestFocus on the inner button follows disabled the same '
            'way ElButton\'s own onPressed: null does: a disabled mic is '
            'removed from Tab order, not just dimmed in place.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching anywhere in voice.dart: BuildContext '
            'width is never read for a layout decision.',
        'width and height on both visualisers are plain constructor '
            'doubles the caller sets, never viewport-driven; the agent '
            'voice console\'s own 320×48 waveform is a call-site choice, '
            'not a rule this file applies.',
        'Platform parity: the same widget tree renders on every '
            'platform this package targets — no dart:io Platform branch '
            'anywhere in the file.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/voice.dart — one file, three widgets, '
            'no companions; the registry manifest lists exactly one '
            'entry under "files".',
        'Flutter imports: dart:math (the band reduction), package:'
            'flutter/foundation.dart (ValueListenable, Float32List), '
            'package:flutter/scheduler.dart (Ticker, createTicker), '
            'package:flutter/widgets.dart.',
        'Foundation imports: foundation/motion.dart (elAnimationDuration), '
            'foundation/shadows.dart (ElShadows.pulseLiveRing), '
            'foundation/spacing.dart (el()), foundation/theme.dart, '
            'theme_scope.dart (ElTheme).',
        'Component imports: button.dart (ElButton, the mic pill\'s '
            'body), icon.dart and icon_paths.g.dart (ElIcon.lucide, '
            'ElLucide.mic).',
        'registryDependencies, resolved automatically by `elattar add '
            'voice`: button, icon, source-foundation — copied verbatim '
            'from registry/components/voice.json.',
      ]),
      SizedBox(height: el(3)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Icon', route: '/components/icon'),
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
        'theme.agent is the one colour both visualisers paint with: the '
            'waveform stroke and every bar fill, matching the reference\'s '
            'own --viz-ink: var(--agent), set once and read live off '
            'ElTheme.of(context) at every paint.',
        'ElMicControl at rest borders on theme.border with no fill; '
            'listening moves to theme.agent at two different alphas — '
            '45% for the border, 12% for the fill — plus theme.agent as '
            'the glyph\'s ink through DefaultTextStyle.',
        'The pulse ring is ElShadows.pulseLiveRing(eased), a theme-aware '
            'shadow spec resolved through outerShadows(theme) each frame, '
            'not a bespoke shadow value at the call site.',
        'Flipping ElThemeController re-resolves every one of these on '
            'the next frame: nothing here is cached.',
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
