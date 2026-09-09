/// Public documentation page for the `voice-source` component.
///
/// Written from nothing: no page existed for this registry item before this
/// file, even though `registry/components/voice-source.json` shipped with
/// commit `0c601dd` and has carried a real `documentationRoute` since —
/// `example/test/components_docs/current_doc_paths_test.dart`'s "every
/// documentationRoute is the catalog entry it belongs to" caught the gap.
///
/// **What this page documents is a contract, not a widget.** Read end to
/// end from `lib/src/components/ui/voice_source_base.dart` (the
/// [VoiceSource] interface and [VoiceSourceStatus] enum) and
/// `lib/src/components/ui/voice_source_stub.dart` ([createVoiceSource], the
/// package's own honest no-op — every platform this package ships to on
/// its own, the web included, per that file's own docs on why). There is
/// nothing here with a shape of its own to stage, so — the same call
/// `source_foundation/page.dart` already made for the same reason — the
/// preview below is an [EffectSection]: the seam applied to [MicControl],
/// [LiveWaveform] and [BarVisualizer], the three widgets it exists to feed,
/// rather than a lie about a "VoiceSource specimen."
///
/// **The preview's [VoiceSource] is a fake, and says so.** `createVoiceSource`
/// never leaves [VoiceSourceStatus.idle] — that is the entire point of the
/// stub — so wiring it into this page would show three widgets that never
/// move, which teaches a reader nothing about what implementing the
/// interface buys them. `_DemoVoiceSource` below is a page-local,
/// synthetic implementation — a sine wave standing in for a real analyser —
/// built only to demonstrate the shape a real implementation
/// (`example/lib/voice_source_web.dart` in this repository) actually fills.
/// It is not exported, and it is not what `elattar add voice-source`
/// installs.
library;

import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import 'meta.dart';

final ComponentDocSpec voiceSourceDocSpec = ComponentDocSpec(
  name: 'voice_source',
  title: 'Voice Source',
  description: voiceSourceDoc.description,
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The seam applied to the three widgets it feeds: pressing the '
          'mic calls VoiceSource.start, MicControl.listening tracks '
          'VoiceSourceStatus.active, and LiveWaveform.samples / '
          'BarVisualizer.spectrum read the same ValueListenables the '
          'source publishes. The source behind this specimen is a '
          'page-local fake that invents a sine wave — see this file\'s '
          'own docs for why createVoiceSource itself, the package\'s '
          'real no-op, would show three widgets that never move.',
      host: const _PreviewSpecimen(),
      code: _previewCode,
      label: 'Voice source specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'voice-source has a real registry manifest, `elattar add '
          'voice-source` installs lib/src/components/ui/voice_source.dart. '
          'Its registryDependencies list is empty — nothing else in the '
          'registry is required to compile it, though it is only useful '
          'wired into AgentConsole.voiceSource or into MicControl / '
          'LiveWaveform / BarVisualizer directly (see voice). The Manual '
          'tab is for a project not using the CLI.',
      command: voiceSourceDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/voice_source.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/voice_source.dart's generated "
              '@ui/voice_source.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated voice_source source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so VoiceSource, VoiceSourceStatus '
              'and createVoiceSource are reachable the same way the '
              'CLI path already makes them.',
          code: "export 'voice_source.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The default resolves to this package\'s own no-op — every '
          'platform, the web included, because a browser capture rig '
          'needs dart:js_interop, which cannot live under lib/. Supply a '
          'real implementation through AgentConsole.voiceSource instead of '
          'writing to this default.',
      code: _usageCode,
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'VoiceSource\'s five members, VoiceSourceStatus\'s six values, '
          'and the createVoiceSource factory — everything '
          'voice_source_base.dart and voice_source_stub.dart export.',
      child: const _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Every VoiceSourceStatus value, read straight off '
          'voice_source_base.dart\'s own docs, not inferred.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: const _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      child: const _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: const _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: const _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: const _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: voiceSourceDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from. voice_source.dart is the barrel; the '
                'interface lives in voice_source_base.dart and the '
                'shipped no-op in voice_source_stub.dart.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/voice_source_test.dart',
            description:
                'Covers VoiceSourceStatus, the stub\'s lifecycle, and '
                'AgentConsole wiring its own default lazily.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value:
                'example/test/components_docs/voice_source_test.dart',
            description:
                'Covers this page: the article mounts, the full API '
                'table, and every specimen this page claims to show.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/voice_source/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class VoiceSourceDocPage extends StatelessWidget {
  const VoiceSourceDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: voiceSourceDoc.route,
    intro: DocsPageIntro(
      title: voiceSourceDoc.title,
      description: voiceSourceDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Voice Source'),
    ],
    toc: voiceSourceDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('voice-source-doc-article'),
      child: ComponentDocPage(spec: voiceSourceDocSpec, header: false),
    ),
  );
}

/* ── Preview: a fake VoiceSource driving the three widgets it feeds ──────── */

/// A page-local, synthetic [VoiceSource] — not exported, not what `elattar
/// add voice-source` installs. See this file's own library docs for why
/// `createVoiceSource` itself would show nothing moving here.
class _DemoVoiceSource implements VoiceSource {
  _DemoVoiceSource();

  final ValueNotifier<VoiceSourceStatus> _status =
      ValueNotifier<VoiceSourceStatus>(VoiceSourceStatus.idle);
  final ValueNotifier<Float32List> _samples = ValueNotifier<Float32List>(
    Float32List(0),
  );
  final ValueNotifier<Float32List> _spectrum = ValueNotifier<Float32List>(
    Float32List(0),
  );
  Timer? _frameTimer;
  double _phase = 0;

  @override
  ValueListenable<VoiceSourceStatus> get status => _status;

  @override
  ValueListenable<Float32List> get samples => _samples;

  @override
  ValueListenable<Float32List> get spectrum => _spectrum;

  @override
  Future<void> start() async {
    if (_status.value == VoiceSourceStatus.active) return;
    _status.value = VoiceSourceStatus.active;
    _frameTimer?.cancel();
    _frameTimer = Timer.periodic(MotionDurations.tick, (_) => _emitFrame());
  }

  @override
  void stop() {
    _frameTimer?.cancel();
    _frameTimer = null;
    if (_status.value == VoiceSourceStatus.active) {
      _status.value = VoiceSourceStatus.idle;
    }
    _samples.value = Float32List(0);
    _spectrum.value = Float32List(0);
  }

  void _emitFrame() {
    _phase += 0.35;
    final Float32List wave = Float32List(32);
    for (int i = 0; i < wave.length; i++) {
      wave[i] = math.sin(_phase + i * 0.4) * 0.6;
    }
    _samples.value = wave;
    final Float32List bins = Float32List(12);
    for (int i = 0; i < bins.length; i++) {
      bins[i] = (math.sin(_phase + i) * 0.5 + 0.5) * 220;
    }
    _spectrum.value = bins;
  }

  @override
  void dispose() {
    _frameTimer?.cancel();
    _status.dispose();
    _samples.dispose();
    _spectrum.dispose();
  }
}

class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  final _DemoVoiceSource _source = _DemoVoiceSource();

  @override
  void dispose() {
    _source.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_source.status.value == VoiceSourceStatus.active) {
      _source.stop();
    } else {
      _source.start();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<
    VoiceSourceStatus
  >(
    valueListenable: _source.status,
    builder: (BuildContext context, VoiceSourceStatus status, _) => Wrap(
      spacing: space(6),
      runSpacing: space(6),
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        KeyedSubtree(
          key: const ValueKey<String>('voice-source-preview:mic'),
          child: MicControl(
            listening: status == VoiceSourceStatus.active,
            onToggle: _toggle,
          ),
        ),
        KeyedSubtree(
          key: const ValueKey<String>('voice-source-preview:waveform'),
          child: LiveWaveform(samples: _source.samples, width: 160, height: 40),
        ),
        KeyedSubtree(
          key: const ValueKey<String>('voice-source-preview:bars'),
          child: BarVisualizer(spectrum: _source.spectrum),
        ),
      ],
    ),
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    '// voiceSource: a real, dart:js_interop-backed VoiceSource on the web\n'
    '// — see example/lib/voice_source_web.dart in this repository.\n'
    'AgentConsole(\n'
    '  // ...\n'
    '  voiceSource: voiceSource,\n'
    ')\n\n'
    '// Or wire the three widgets voice.dart exports directly:\n'
    'MicControl(\n'
    '  listening: voiceSource.status.value == VoiceSourceStatus.active,\n'
    '  onToggle: () => voiceSource.status.value == VoiceSourceStatus.active\n'
    '      ? voiceSource.stop()\n'
    '      : voiceSource.start(),\n'
    ')\n'
    'LiveWaveform(samples: voiceSource.samples)\n'
    'BarVisualizer(spectrum: voiceSource.spectrum)';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

class MyVoiceSource implements VoiceSource {
  final ValueNotifier<VoiceSourceStatus> _status =
      ValueNotifier(VoiceSourceStatus.idle);
  final ValueNotifier<Float32List> _samples = ValueNotifier(Float32List(0));
  final ValueNotifier<Float32List> _spectrum = ValueNotifier(Float32List(0));

  @override
  ValueListenable<VoiceSourceStatus> get status => _status;
  @override
  ValueListenable<Float32List> get samples => _samples;
  @override
  ValueListenable<Float32List> get spectrum => _spectrum;

  @override
  Future<void> start() async {
    // Request the microphone; never throw — every failure lands in status.
  }

  @override
  void stop() { /* release the stream */ }

  @override
  void dispose() {
    _status.dispose();
    _samples.dispose();
    _spectrum.dispose();
  }
}

AgentConsole(voiceSource: MyVoiceSource(), /* ... */);''';

/* ── API Reference ─────────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(title: 'VoiceSource', facts: _voiceSourceFacts),
      SizedBox(height: space(5)),
      const DocsApiTable(
        title: 'createVoiceSource()',
        facts: _createVoiceSourceFacts,
      ),
    ],
  );
}

const List<DocsApiFact> _voiceSourceFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'status',
    type: 'ValueListenable<VoiceSourceStatus>',
    description: 'Lifecycle and permission state. Starts at .idle.',
  ),
  DocsApiFact(
    name: 'samples',
    type: 'ValueListenable<Float32List>',
    description:
        'Time-domain samples, −1 … 1 — exactly what LiveWaveform.samples '
        'wants. Empty until a frame has arrived.',
  ),
  DocsApiFact(
    name: 'spectrum',
    type: 'ValueListenable<Float32List>',
    description:
        'Frequency bins, 0 … 255 — exactly what BarVisualizer.spectrum '
        'wants. Empty until a frame has arrived.',
  ),
  DocsApiFact(
    name: 'start()',
    type: 'Future<void>',
    description:
        'Requests the microphone and starts the frame loop. Never '
        'throws — every failure lands in status instead.',
  ),
  DocsApiFact(
    name: 'stop()',
    type: 'void',
    description:
        'Stops the frame loop and releases the stream. Safe when not '
        'capturing; leaves a denied/unavailable/error status where it '
        'found it.',
  ),
  DocsApiFact(
    name: 'dispose()',
    type: 'void',
    description:
        'Releases everything, including the listenables themselves. '
        'start must not be called again afterwards.',
  ),
];

const List<DocsApiFact> _createVoiceSourceFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'createVoiceSource',
    type: 'VoiceSource Function()',
    description:
        'The package\'s own default: an honest no-op on every platform '
        'this package ships to on its own, the web included. '
        'AgentConsole calls this lazily only when '
        'AgentConsole.voiceSource is not supplied.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'idle',
    treatment: 'Not capturing. Before start() and after a clean stop().',
    userSignal: 'MicControl at rest.',
  ),
  DocsStateFact(
    state: 'requesting',
    treatment:
        "start() has been called and the platform's permission prompt, "
        'if there is one, has not resolved yet.',
    userSignal:
        'Not a terminal state a caller shows text for — see '
        'voice_source_base.dart\'s own docs.',
  ),
  DocsStateFact(
    state: 'active',
    treatment: 'Capturing. samples and spectrum receive frames.',
    userSignal: 'MicControl.listening: true.',
  ),
  DocsStateFact(
    state: 'denied',
    treatment: 'The user denied the microphone permission.',
    userSignal:
        'A terminal failure a caller can put into words — see '
        'AgentConsole\'s own "Microphone access was denied."',
  ),
  DocsStateFact(
    state: 'unavailable',
    treatment:
        'No capture is possible here: an insecure origin, no '
        'mediaDevices API, or no input device.',
    userSignal: 'AgentConsole\'s own "Microphone unavailable."',
  ),
  DocsStateFact(
    state: 'error',
    treatment: 'Permission was granted but the audio graph failed to build.',
    userSignal: 'AgentConsole\'s own "Could not start the microphone."',
  ),
];

/* ── Prose sections ────────────────────────────────────────────────────── */

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'VoiceSource renders nothing of its own — it is a data source, not '
            'a widget. Every accessibility fact belongs to the widget '
            'reading it: MicControl\'s own semantics label, documented on '
            'the voice page.',
        'The one thing this seam owns is turning a terminal '
            'VoiceSourceStatus into words a screen reader can announce — '
            'AgentConsole does that by feeding denied/unavailable/error '
            'into MicControl.disabledReason as a tooltip.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'voice_source_base.dart and voice_source_stub.dart wire no key '
            'handling anywhere in either file — a VoiceSource is not '
            'focusable, and has no keyboard surface of its own to '
            'document.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'VoiceSource has no layout of its own — no width, no height, no '
            'breakpoint. It is a pair of ValueListenables and a status, '
            'consumed by widgets that already document their own '
            'responsive behaviour.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _bullets(ThemeScope.of(context), <String>[
            'registryDependencies is empty — voice-source compiles on '
                'its own, with nothing else installed.',
            'It is only useful wired somewhere: AgentConsole.voiceSource '
                'consumes it directly, and MicControl / LiveWaveform / '
                'BarVisualizer (voice) are the three widgets its samples, '
                'spectrum and status feed.',
          ]),
          SizedBox(height: space(3)),
          const DocsLinkRow(
            links: <DocsLink>[
              DocsLink(label: 'Agent Console', route: '/components/agent-console'),
              DocsLink(label: 'Voice', route: '/components/voice'),
            ],
          ),
        ],
      );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'VoiceSource paints nothing and reads no ThemeTokens — it has no '
            'theming surface of its own. Every colour a reader sees in '
            'the preview above belongs to MicControl, LiveWaveform or '
            'BarVisualizer, all documented on the voice page.',
      ]);
}

Widget _bullets(ThemeTokens theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: StyledText(
          '•  $line',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ),
      SizedBox(height: space(2)),
    ],
  ],
);
