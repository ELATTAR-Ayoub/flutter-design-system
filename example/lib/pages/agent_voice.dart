/// `/design-system/components/agent/voice`: the listening and speaking
/// surface: live waveform, bar visualiser, and the controls that arm them.
///
/// Four sections, and two of them are prose about contracts rather than
/// specimens: which is the page's own shape, not an abbreviation of it.
///
/// ## Probes
///
/// Everything pinned below was measured on the live reference at 1440×900 on
/// 2026-08-16, before any of it was built:
/// `scratchpad/ag-voice-inv.js` (DOM + computed-style inventory of every
/// control, canvas and box on the page), `ag-orb-px.js` and `ag-orb-extent.js`
/// (the orb canvases, screenshotted and scanned), `ag-orb-raster.js` (the
/// vendored fragment shader re-run standalone at fixed uniforms, against the
/// live orbs' own colour statistics) and `tool/verify/section-oracle.js` for
/// the geometry.
///
/// ## Probe corrections: what the source said and the browser did not
///
///  1. **`MicControl` renders as a single 34 × 34 button, never a pair.** The
///     component's whole doc-comment is about *"one pill, always"* with a
///     chevron half beside the mic, and `hasMenu` gates that half on
///     `devices.length > 1 || canPickVoice || canToggleSpeech`. `VoiceDemo`
///     passes no voices, no speech toggle and no device list, so the branch is
///     dead on this page: measured 34 × 34, 1px border, a 32px button, 1px
///     border: with one child. A pair would have been 59 wide.
///  2. **The mic button's glyph does not follow its size.** `size="icon"` is
///     the 40px cva rung; `className="size-8"` overrides the box to 32 and
///     `className="size-4"` pins the svg at 16, where a 32px icon button's own
///     default would be 14. Measured: a 32px button around a 16×16 svg at
///     2.4px stroke.
///  3. **The four labelled orbs are not four states.** `Orb.tsx` always passes
///     `volumeMode: "manual"`, and in manual mode the vendored shader never
///     reads `agentState`: with no analyser both volumes are 0 for all four.
///     Screenshotted, the four discs' mean colours are (55.7, 68.9, 151.2),
///     (25.3, 39.6, 130.7), (56.9, 70.1, 152.4) and (45.6, 59.1, 143.8): four
///     draws from one distribution, differing only in the random phase each
///     mount seeds itself with.
///  4. **The orb is drawn darker than its own tokens.** `Orb.tsx` hands THREE
///     two `getComputedStyle` colours; `THREE.ColorManagement` converts them
///     sRGB → linear working space, and the vendored shader writes straight to
///     an sRGB framebuffer with no encoding step. Re-running the same shader
///     standalone settles it: linear uniforms give a disc mean of
///     (31.3, 45.4, 135.1) and raw sRGB ones (48.7, 91.3, 184.4), against the
///     live (45.9, 59.4, 144.5) averaged. Reproduced, not corrected.
///  5. **The disc is 0.91226 of its canvas, measured rather than assumed.**
///     The mesh is `circleGeometry(3.5, 64)` under r3f's default camera; the
///     live 112px canvases render a disc exactly **102px** across.
///  6. **`dictation.isSupported` is TRUE in this browser**, so the placeholder
///     reads *"Arm the microphone and say something."* rather than *"This
///     browser has no speech recognition."*, Chrome always exposes
///     `webkitSpeechRecognition`, permission or not.
///  7. **The waveform does not fill its lane.** Its wrapper is
///     `min-w-0 flex-1` and measures 852, while the canvas inside it is the
///     fixed 320 the call site asks for. The row is 34 + 24 + 852 + 24 + 96.
///  8. **The bars sit at their floor, not at zero.** With no analyser every
///     level is 0 and the smoothing settles to 0, but the paint takes
///     `max(0.06, …)`: so twelve 6.167 × 1.44 pills, and a radius asked for
///     as 3.08 that the canvas scales down to fit.
///
/// ## Divergence: flagged for sign-off
///
/// **This page cannot open a microphone, and no port of it can.** Web Audio,
/// `getUserMedia` and `SpeechRecognition` are three browser APIs with no
/// Flutter equivalent that does not cost a plugin, and the package takes no
/// third-party dependency. The reference's own note says the specimen is
/// worthless if the data is fake, *"A waveform drawn from fake data would
/// prove nothing about whether the waveform works"*: so nothing here
/// fabricates one.
///
/// What that costs is smaller than it sounds, because the components specify
/// the silent branch themselves: *"they flatten to a resting line rather than
/// inventing a signal."* So the port renders exactly what the reference renders
/// **before you arm it**, which is also the only state the capture rig ever
/// sees. The control still arms: the pill tints, the glyph goes agent-blue and
/// the live ring pulses: and the waveform stays flat because there is
/// genuinely nothing to draw. `ElLiveWaveform.samples` and
/// `ElBarVisualizer.spectrum` are the seam a product with a real audio plugin
/// feeds.
///
/// ## Drift register: recorded, shipped as written
///
///  1. **The eyebrow says "Components" after a group already called that.**
///     `` `${group.title} · Components` `` with `group.title = "Agent"`, so it
///     reads *"Agent · Components"* while every base page reads *"Base
///     Components · Base"*. Two different drifts, one per family.
///  2. **The note promises a microphone the specimen may not get.** *"Arming
///     the control below asks the browser for microphone access"*: true of the
///     reference in a browser that grants it, and the copy makes no allowance
///     for a refusal. Reproduced verbatim; the divergence above is the port's
///     own footnote, not an edit to theirs.
///  3. **`§orb`'s caption contradicts the component underneath it.** *"It
///     reacts to level rather than to state"* sits above four orbs labelled by
///     state, which: per probe 3: is exactly right and exactly why they all
///     look the same. The page is describing the bug as a feature and it is
///     neither; it is the manual-mode contract.
///  4. **`§dictation` and `§speech` document an API the page never runs.** The
///     two `Meta` tables list `useDictation`'s eight fields and
///     `speakableText`'s job with no specimen for either. Ported as the copy
///     they are.
///  5. **The `Heard` box reserves a line it cannot fill.** `min-h-6` on the
///     paragraph holds 24px whether or not anything was heard, so the box is
///     85 tall in both states.
///  6. **`type-label` on "Heard" is 11px uppercase over a 16px body.** The
///     pairing is the reference's; noted because it is the only place on the
///     page where a label sits directly above body copy at that ratio.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import '../nav.dart';

/// `AGENT_STATE` in `OrbStates`: the four the specimen draws, in its order.
const List<(ElOrbState, String)> _orbStates = <(ElOrbState, String)>[
  (ElOrbState.idle, 'idle'),
  (ElOrbState.listening, 'listening'),
  (ElOrbState.thinking, 'thinking'),
  (ElOrbState.talking, 'talking'),
];

/// A fixed phase per cell.
///
/// Upstream seeds each mount from `Math.random()`, so the four orbs are never
/// in phase with each other: which is the visible fact probe 3 turns on. The
/// port keeps four *different* seeds for the same reason, and keeps them
/// *stable* so the capture rig and the page test see one image rather than a
/// new one per boot. `seed` is the vendor's own prop; passing it is upstream's
/// supported way to do exactly this.
const List<int> _orbSeeds = <int>[10, 20, 30, 40];

class AgentVoicePage extends StatelessWidget {
  const AgentVoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ElCategoryHit here = findCategory('agent', 'voice');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElPageHeader(
          // DRIFT 1.
          eyebrow: '${here.group.title} · Components',
          title: here.category.title,
          blurb: here.category.blurb,
          contents: here.category.contents,
        ),
        // `className="mb-12"`, 48px, above the first section rather than
        // inside it.
        Padding(
          padding: EdgeInsets.only(bottom: el(12)),
          child: const ElNote(
            tone: ElNoteTone.value,
            title: 'This specimen opens your microphone',
            // DRIFT 2.
            child: _MicrophoneNote(),
          ),
        ),
        const _LiveSection(),
        const _OrbSection(),
        const _DictationSection(),
        const _SpeechSection(),
        const ElPageFootNav(groupId: 'agent', slug: 'voice'),
      ],
    );
  }
}

class _MicrophoneNote extends StatelessWidget {
  const _MicrophoneNote();

  @override
  Widget build(BuildContext context) => ElText(
    'Arming the control below asks the browser for microphone access and '
    'reads the level from a live analyser. Nothing is recorded, stored or '
    'sent anywhere: the amplitude drives the waveform and the transcript '
    'is written into the box beside it, both in this tab. A waveform drawn '
    'from fake data would prove nothing about whether the waveform works, '
    'which is why this one is real.',
    ElType.small,
  );
}

/* ── 1 · The listening surface ───────────────────────────────────────────── */

class _LiveSection extends StatelessWidget {
  const _LiveSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'live',
    title: 'The listening surface',
    description:
        'One pill, always. The border makes the two halves read '
        'as a single object; the fill is what changes when it goes live.',
    child: ElPanel(
      label: 'MicControl · LiveWaveform · BarVisualizer',
      child: _VoiceDemo(),
    ),
  );
}

/// `agent-demo.tsx` L741, `export function VoiceDemo`.
///
/// The reference holds one piece of state (`heard`) and one hook
/// (`useDictation`). Here the hook is the seam that does not cross, so the
/// state is the arm switch alone: see the divergence note in the library
/// comment. Every visual state the demo has is still reachable: press the mic.
class _VoiceDemo extends StatefulWidget {
  const _VoiceDemo();

  @override
  State<_VoiceDemo> createState() => _VoiceDemoState();
}

class _VoiceDemoState extends State<_VoiceDemo> {
  bool _listening = false;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // `flex flex-wrap items-center gap-6`, 34 + 24 + 852 + 24 + 96 across
        // 1030, the waveform's lane taking the slack (probe 7).
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElMicControl(
              listening: _listening,
              onToggle: () => setState(() => _listening = !_listening),
            ),
            SizedBox(width: el(6)),
            const Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElLiveWaveform(width: 320, height: 48),
              ),
            ),
            SizedBox(width: el(6)),
            const ElBarVisualizer(),
          ],
        ),
        SizedBox(height: el(6)),
        // `rounded-lg border border-border bg-background p-5`, 85 tall: 2 of
        // border, 40 of padding, 43 of content. A [DecoratedBox] paints its
        // border without reserving room for it and comes out 2px short —
        // [Container] adds `decoration.padding` around the child, which is what
        // `box-sizing: border-box` does here.
        Container(
          decoration: BoxDecoration(
            color: theme.background,
            border: Border.all(color: theme.border, width: ElWidths.hairline),
            borderRadius: BorderRadius.circular(ElRadii.lg),
          ),
          padding: EdgeInsets.all(el(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: el(2)),
                child: ElText(
                  'Heard',
                  ElType.label,
                  color: theme.mutedForeground,
                ),
              ),
              // `min-h-6`: the line is reserved whether or not it is
              // filled (DRIFT 5). The placeholder is the supported branch:
              // probe 6.
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: el(6)),
                child: ElText(
                  'Arm the microphone and say something.',
                  ElType.body,
                  color: theme.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/* ── 2 · Orb states ──────────────────────────────────────────────────────── */

class _OrbSection extends StatelessWidget {
  const _OrbSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'orb',
    title: 'Orb states',
    // DRIFT 3.
    description:
        'Where the cube says what the agent is doing, the orb '
        'says that it is hearing you. It reacts to level rather than to '
        'state, which is why it belongs next to the microphone and not in '
        'the header.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // `grid grid-cols-2 gap-px … sm:grid-cols-4`: the kit's lattice
        // is the same frame, but the cell is the page's own: `p-6 gap-4`
        // with the label UNDER the specimen, where [ElStateCell]'s block
        // is `p-5` with a well above a name.
        ElStateGrid.columns(
          base: 2,
          sm: 4,
          children: <Widget>[
            for (int i = 0; i < _orbStates.length; i++)
              _OrbCell(
                state: _orbStates[i].$1,
                label: _orbStates[i].$2,
                seed: _orbSeeds[i],
              ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: el(6)),
          child: const _OrbNote(),
        ),
      ],
    ),
  );
}

/// One tile: `flex flex-col items-center gap-4 bg-background p-6`, holding a
/// 112px orb over its name.
class _OrbCell extends StatelessWidget {
  const _OrbCell({
    required this.state,
    required this.label,
    required this.seed,
  });

  final ElOrbState state;
  final String label;
  final int seed;

  /// `<Orb state={state} size={112} />`.
  static const double orbSize = 112;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ElStateCell.bare(
      padding: EdgeInsets.all(el(6)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ElVoiceOrb(state: state, size: orbSize, seed: seed),
          SizedBox(height: el(4)),
          // `.type-micro` carries everything but the transform: the call site
          // uppercases, because a Flutter TextStyle cannot.
          ElText(
            label.toUpperCase(),
            ElType.micro,
            color: theme.mutedForeground,
          ),
        ],
      ),
    );
  }
}

class _OrbNote extends StatelessWidget {
  const _OrbNote();

  @override
  Widget build(BuildContext context) => ElRichText(
    TextSpan(
      children: <InlineSpan>[
        const TextSpan(
          text:
              'Dictation and the orb share one analyser rather than '
              'opening two streams. Two ',
        ),
        ElCode.span('getUserMedia'),
        const TextSpan(
          text:
              ' calls on the same device is a permission prompt the user '
              'has already answered and a second stream the browser may or '
              'may not give you, so the orb runs in manual mode and is fed '
              'from the analyser that is already open: one stream, two '
              'consumers.',
        ),
      ],
    ),
    ElType.small,
  );
}

/* ── 3 · The dictation contract ──────────────────────────────────────────── */

class _DictationSection extends StatelessWidget {
  const _DictationSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'dictation',
    title: 'The dictation contract',
    description:
        'Speech recognition is a browser API with genuinely '
        'different support across engines, so the hook states what it can '
        'do rather than assuming.',
    // DRIFT 4.
    child: ElMeta(
      items: <ElMetaItem>[
        (
          k: 'isSupported',
          v: TextSpan(
            text:
                'boolean: false is a normal outcome, not an error '
                'state',
          ),
        ),
        (k: 'isListening', v: TextSpan(text: 'boolean')),
        (
          k: 'level',
          v: TextSpan(
            text: 'number, 0 to 1, smoothed. Drives the scalar meter.',
          ),
        ),
        (
          k: 'analyser',
          v: TextSpan(
            text:
                'AnalyserNode | null: live node for the waveform; null '
                'while the microphone is closed',
          ),
        ),
        (
          k: 'devices / deviceId / setDeviceId',
          v: TextSpan(
            text:
                'AudioInput[]: labels are blank until permission has '
                'been granted once',
          ),
        ),
        (k: 'start / stop / toggle', v: TextSpan(text: '() => void')),
        (k: 'error', v: TextSpan(text: 'string | null')),
      ],
    ),
  );
}

/* ── 4 · Speaking back ───────────────────────────────────────────────────── */

class _SpeechSection extends StatelessWidget {
  const _SpeechSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'speech',
    title: 'Speaking back',
    description:
        'The fourth seam. useBrowserSpeech is one SpeechAdapter, '
        'not the only one: a product with its own voice implements the '
        'same interface and the controls do not move.',
    child: ElNote(title: 'Markdown is not speakable', child: _SpeechNote()),
  );
}

class _SpeechNote extends StatelessWidget {
  const _SpeechNote();

  @override
  Widget build(BuildContext context) => ElRichText(
    TextSpan(
      children: <InlineSpan>[
        const TextSpan(
          text:
              'Reading a raw answer aloud gets you asterisks, pipe '
              'characters and fenced code read as punctuation. ',
        ),
        ElCode.span('speakableText'),
        const TextSpan(
          text:
              ' strips the markup, drops code blocks entirely and turns '
              'a table into a sentence before any of it reaches the '
              'synthesiser. It is exported separately because it is a pure '
              'function, and because a product supplying its own adapter '
              'still needs it.',
        ),
      ],
    ),
    ElType.small,
  );
}
