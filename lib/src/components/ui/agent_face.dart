/// `components/agent/parts/agent-face.tsx` — what the assistant looks like
/// right now, and the sentence beside it.
///
/// Two objects share the face's slot, and the file's own docstring says the
/// choice is not a style one:
///
/// > The avatar draws the twenty states of an agent *working*. That is what the
/// > handoff describes, and it is why none of its scenes is called "listening".
/// >
/// > The orb draws the microphone and the speaker — a conversation happening in
/// > the room rather than work happening on a server.
///
/// *"Voice wins while it is active, because a live microphone is the more urgent
/// fact."*
///
/// ## The avatar seam
///
/// `AgentFace` takes `avatar?: AvatarRenderer` and defaults it to `CubeAvatar`.
/// [AgentFace] takes [AgentAvatarBuilder] and defaults to
/// [AgentAvatarRegistry.renderer], which is seeded with [AgentAvatar]. The
/// indirection is not decoration: the console, the welcome card and the
/// launcher all pass the same renderer down, and a product that swaps the
/// artwork swaps one function rather than three imports.
///
/// The registry also carries the **voice** half — the orb and the two
/// visualisers — for the same reason and with one extra: those three live in
/// `voice.dart` and `effects/voice_indicator.dart`, and a console that imported the
/// shader-backed orb directly would pull a `FragmentProgram` into every test
/// that mounts a transcript. Through the registry the default is the real orb
/// and a test can put a cheap one in front of it.
///
/// ## `anim-shimmer-text` is not the `shimmer` utility
///
/// [AttachmentStatusText] (`attachment.dart`) is shadcn's `shimmer`: 2s linear, a
/// `3ch + 40px` band, base ink → white. The status line wears `anim-shimmer-text`
/// (globals.css L3056–3068), which is a **different** animation and was measured
/// as such on the live console:
///
/// ```
/// background-image: linear-gradient(100deg, --muted-foreground 30%,
///                                           --agent 50%,
///                                           --muted-foreground 70%)
/// background-size: 220% 100%
/// background-clip: text
/// color: transparent
/// animation: pulls-shimmer 2.6s var(--ease-in-out) infinite
/// ```
///
/// So this file paints its own, sharing `pulls-shimmer`'s travel constants with
/// [LoadingShimmerMotion] rather than restating them. The `100deg` tilt is dropped: on the
/// 13.8px line box a `.type-chip` renders, ten degrees of lean is 2.4px of
/// vertical run against ~48px of horizontal, and [AttachmentStatusText] already sets
/// the precedent of treating a small angle as horizontal.
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import './voice_indicator.dart';
import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import './keyframes.dart';
import '../../design_system/foundation/theme_scope.dart';
import './agent_avatar.dart';
import './agent_core.dart';
import './voice.dart';

/// `AvatarRenderer` — *"one implementation of the face, not a fixture."*
///
/// Positional rather than named so a call site can hand over [AgentAvatar.new]
/// -shaped closures without restating every label.
typedef AgentAvatarBuilder =
    Widget Function(
      BuildContext context,
      AgentState state,
      AgentAvatarSize size,
      Color? accent,
      double? speed,
    );

/// The orb, as the face draws it: state, live level, and the box the avatar
/// would have occupied.
typedef AgentOrbBuilder =
    Widget Function(
      BuildContext context,
      VoiceIndicatorState state,
      ValueListenable<double>? level,
      double size,
    );

/// The two visualisers `StatusLine` puts beside the label.
typedef AgentVisualiserBuilder =
    Widget Function(BuildContext context, AgentVoice voice, Size box);

/// Where the avatar family plugs in.
///
/// Every field is pre-seeded with the real component, so the console works with
/// no wiring at all; assigning one swaps the artwork everywhere at once, which
/// is the `avatar` prop's job written as a default rather than as a
/// requirement.
abstract final class AgentAvatarRegistry {
  /// `avatar: Avatar = CubeAvatar`.
  static AgentAvatarBuilder renderer = _cube;

  /// `<Orb state=… analyser=… size={FACE_SIZE[size]} />`.
  static AgentOrbBuilder orb = _orb;

  /// `<LiveWaveform analyser={…} width={64} height={16} />`.
  static AgentVisualiserBuilder waveform = _waveform;

  /// `<BarVisualizer analyser={…} active bars={8} width={48} height={16} />`.
  static AgentVisualiserBuilder bars = _bars;

  static Widget _cube(
    BuildContext context,
    AgentState state,
    AgentAvatarSize size,
    Color? accent,
    double? speed,
  ) => AgentAvatar(state: state, size: size, accent: accent, speed: speed ?? 1);

  static Widget _orb(
    BuildContext context,
    VoiceIndicatorState state,
    ValueListenable<double>? level,
    double size,
  ) => VoiceIndicator(state: state, level: level, size: size);

  static Widget _waveform(BuildContext context, AgentVoice voice, Size box) =>
      LiveWaveform(
        samples: voice.samples,
        width: box.width,
        height: box.height,
      );

  static Widget _bars(BuildContext context, AgentVoice voice, Size box) =>
      BarVisualizer(
        spectrum: voice.spectrum,
        active: true,
        bars: AgentStatusLine.bars,
        width: box.width,
        height: box.height,
      );
}

/// `VoiceState` — *"live audio for the visualisers. Null when the source cannot
/// provide any."*
///
/// The reference carries an `AnalyserNode`; the port carries the two listenables
/// `voice.dart`'s visualisers already read, because Flutter has no Web Audio
/// analyser and inventing one would be a seam with nothing behind it.
@immutable
class AgentVoice {
  const AgentVoice({
    this.listening = false,
    this.speaking = false,
    this.samples,
    this.spectrum,
    this.level,
  });

  /// Nothing is happening in the room. The face falls through to the avatar.
  static const AgentVoice rest = AgentVoice();

  final bool listening;
  final bool speaking;

  /// Time-domain samples, for [LiveWaveform].
  final ValueListenable<Float32List>? samples;

  /// Frequency bins, for [BarVisualizer].
  final ValueListenable<Float32List>? spectrum;

  /// 0–1, for the orb's shader.
  final ValueListenable<double>? level;

  /// `const inVoice = Boolean(voice?.listening || voice?.speaking)`.
  bool get isActive => listening || speaking;
}

/// `FACE_SIZE` — `agent-face.tsx` L34.
///
/// `{ sm: 32, md: 48, lg: 80, xl: 128 }`, which is [AgentAvatarSize.box] exactly.
/// Named here because the orb takes a *number* where the avatar takes a rung,
/// and the reference's own map is what bridges them.
double agentFaceSize(AgentAvatarSize size) => size.box;

/// `AgentFace`.
class AgentFace extends StatelessWidget {
  const AgentFace({
    super.key,
    required this.state,
    this.voice = AgentVoice.rest,
    this.avatar,
    this.size = AgentAvatarSize.md,
    this.accent,
    this.speed,
  });

  final AgentState state;
  final AgentVoice voice;

  /// Null takes [AgentAvatarRegistry.renderer] — *"swap the renderer, keep
  /// the machine."*
  final AgentAvatarBuilder? avatar;

  final AgentAvatarSize size;
  final Color? accent;
  final double? speed;

  @override
  Widget build(BuildContext context) {
    if (voice.isActive) {
      // `<span className="grid shrink-0 place-items-center" role="img"
      //        aria-label={listening ? "Listening" : "Speaking"}>`
      return Semantics(
        image: true,
        label: voice.listening ? 'Listening' : 'Speaking',
        child: Center(
          child: AgentAvatarRegistry.orb(
            context,
            voice.listening
                ? VoiceIndicatorState.listening
                : VoiceIndicatorState.talking,
            voice.level,
            agentFaceSize(size),
          ),
        ),
      );
    }
    return (avatar ?? AgentAvatarRegistry.renderer)(
      context,
      state,
      size,
      accent,
      speed,
    );
  }
}

/// `StatusLine` — the sentence beside the face.
///
/// *"Shimmers while the agent is working and sits still when it is not, so the
/// status can be read at a glance without parsing the word."*
///
/// DRIFT (carried from `agent_core.dart`): `states.ts` L43 promises *"present
/// participles with an ellipsis for anything ongoing"* and not one label in
/// `AGENT_STATE_LABEL` carries one. The line reads `Planning`, never
/// `Planning…`. Reproduced.
class AgentStatusLine extends StatelessWidget {
  const AgentStatusLine({
    super.key,
    required this.state,
    this.voice = AgentVoice.rest,
  });

  final AgentState state;
  final AgentVoice voice;

  /// `gap-2` between the label and whichever visualiser is showing.
  static double get gap => space(2);

  /// `<LiveWaveform … width={64} height={16} />`.
  static Size get waveformBox => Size(space(16), space(4));

  /// `<BarVisualizer … width={48} height={16} />`.
  static Size get barsBox => Size(space(12), space(4));

  /// `bars={8}`.
  static const int bars = 8;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    final String label = voice.listening
        ? 'Listening'
        : voice.speaking
        ? 'Speaking'
        : state.label;

    final bool live = voice.isActive || state.isBusy;

    // `aria-live="polite"` — *"a screen reader should mention that the state
    // changed, not interrupt the user mid-sentence to do it."*
    final Widget text = Semantics(
      liveRegion: true,
      child: StyledText(
        label,
        TextStyles.chip,
        // The shimmer paints `color: transparent` and lets the gradient
        // through, so the ink under the mask only matters when it is still.
        color: live ? theme.foreground : theme.mutedForeground,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(child: live ? AgentStatusText(child: text) : text),
        if (voice.listening) ...<Widget>[
          SizedBox(width: gap),
          AgentAvatarRegistry.waveform(context, voice, waveformBox),
        ] else if (voice.speaking) ...<Widget>[
          SizedBox(width: gap),
          AgentAvatarRegistry.bars(context, voice, barsBox),
        ],
      ],
    );
  }
}

/// `@utility anim-shimmer-text` — globals.css L3056–3068.
///
/// *"A highlight travelling through live text — the agent's status line while it
/// works. Clipped to the glyphs rather than painted behind them, so it reads as
/// the words themselves being lit rather than as a loading bar. One of the few
/// things that animate forever, and it earns it the same way `anim-pulse-live`
/// does: it is the signal that the agent has not stalled."*
///
/// Measured on the live console mid-turn: `pulls-shimmer`, **2.6s**,
/// `cubic-bezier(0.65, 0, 0.35, 1)` (`--ease-in-out`), `infinite`, no fill —
/// so reduced motion reverts to stop 0, the tile parked at `200%`.
///
/// `background-size: 220% 100%` and `background-position: X%` put the tile's
/// left edge at `(W − S)·X/100 = −1.2·W·X/100`. At the `200%` stop that is
/// `−2.4W`; at `−200%`, `+2.4W`. [LoadingShimmerMotion.fromPercent] / [LoadingShimmerMotion.toPercent]
/// carry the two stops; only the tile factor differs from the utility they
/// belong to.
class AgentStatusText extends StatelessWidget {
  const AgentStatusText({super.key, required this.child});

  /// `animation: pulls-shimmer 2.6s …` — [MotionDurations.shimmerText], which the
  /// foundation already carries under exactly this name.
  static const Duration period = MotionDurations.shimmerText;

  /// `background-size: 220% 100%`.
  static const double tileFactor = 2.2; // allow-hardcoded: background-size

  /// The gradient's three stops: `--muted-foreground 30%, --agent 50%,
  /// --muted-foreground 70%`.
  static const List<double> stops = <double>[
    0.30, // allow-hardcoded: anim-shimmer-text gradient stop
    0.50, // allow-hardcoded: anim-shimmer-text gradient stop
    0.70, // allow-hardcoded: anim-shimmer-text gradient stop
  ];

  final Widget child;

  /// The tile's left edge, in the box's own coordinates, at linear progress [t].
  ///
  /// `--ease-in-out` is applied here, exactly as [LoadingShimmerMotion.offsetAt] applies
  /// its own curve, so a probe and the paint cannot disagree about where the
  /// band is.
  static double offsetAt(double t, double width) {
    final double eased = MotionCurves.move.transform(t.clamp(0.0, 1.0));
    final double percent =
        LoadingShimmerMotion.fromPercent +
        (LoadingShimmerMotion.toPercent - LoadingShimmerMotion.fromPercent) *
            eased;
    return width * (1 - tileFactor) * percent;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Color base = theme.mutedForeground;
    final Color band = theme.agentAccent;

    return KeyframePlayer(
      duration: period,
      // `infinite`, and no `animation-fill-mode` — motion-map §8.2's no-fill
      // row, which freezes to stop 0.
      repeat: true,
      fill: KeyframeFill.none,
      child: child,
      builder: (BuildContext context, double t, Widget? child) => ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (Rect bounds) {
          final double tile = bounds.width * tileFactor;
          final double left = offsetAt(t, bounds.width);
          final double y = bounds.height / 2;
          return ui.Gradient.linear(
            Offset(left, y),
            Offset(left + math.max(tile, 1), y),
            <Color>[base, band, base],
            stops,
            // `background-repeat` defaults to `repeat`, which is why the box is
            // never empty at the extremes.
            TileMode.repeated,
          );
        },
        child: child,
      ),
    );
  }
}
