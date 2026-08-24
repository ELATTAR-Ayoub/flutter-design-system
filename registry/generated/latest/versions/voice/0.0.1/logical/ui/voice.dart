/// `components/agent/voice/` — the listening surface.
///
/// Three components, from two reference files:
///
/// | reference | what lands here |
/// |---|---|
/// | `voice/visualisers.tsx` | [ElLiveWaveform], [ElBarVisualizer] |
/// | `voice/pickers.tsx` | [ElMicControl] |
///
/// *"Two readings of the same signal. `LiveWaveform` draws the time-domain
/// trace — what the microphone is actually hearing, moment to moment.
/// `BarVisualizer` draws the frequency bands — the shape of a voice rather than
/// its shape in time."*
///
/// ## The one thing that does not cross
///
/// There is no `AnalyserNode`, and there is no microphone. Web Audio,
/// `getUserMedia` and `SpeechRecognition` are three browser APIs with no
/// Flutter equivalent that does not cost a plugin, and this package takes no
/// third-party dependency. So the seam moves out by one step: where the
/// reference passes an `AnalyserNode` and each visualiser calls
/// `getByteTimeDomainData` / `getByteFrequencyData` on it, these take the
/// buffer that call would have filled — [ElLiveWaveform.samples] and
/// [ElBarVisualizer.spectrum] — and everything downstream of the read is the
/// reference's arithmetic, unchanged.
///
/// **Nothing here invents a signal**, which is the reference's own rule and the
/// reason the port needs no apology for it:
///
/// > *"Both take an AnalyserNode and both degrade honestly without one: they
/// > flatten to a resting line rather than inventing a signal. Nothing here
/// > fabricates audio data. If the bars are moving, something is making
/// > noise."*
///
/// A port with no microphone is a port permanently on the null-analyser branch,
/// and that branch is specified, not improvised: a flat line at the midpoint
/// and twelve bars at their 0.06 floor. [ElBarVisualizer.active] is the one
/// exception the reference itself carves out — *"a signal that playback is
/// running, not a reading of it"* — and it is built in full.
///
/// The device and voice pickers on `MicControl` are **recorded, not built**;
/// see [ElMicControl].
library;

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../theme_scope.dart';
import 'button.dart';
import 'icon.dart';
import 'icon_paths.g.dart';

/* ── Live waveform ───────────────────────────────────────────────────────── */

/// `visualisers.tsx` L63 — `export function LiveWaveform`.
///
/// The trace is drawn from [samples], which hold what
/// `analyser.getByteTimeDomainData` would have written **already centred**: the
/// reference's `(view[i] - 128) / 128`, so −1 … 1. Null is a closed microphone
/// and draws *"a flat line, which is the truth."*
class ElLiveWaveform extends StatefulWidget {
  const ElLiveWaveform({
    super.key,
    this.samples,
    this.width = defaultWidth,
    this.height = defaultHeight,
  });

  /// The time-domain trace, −1 … 1. Null while the microphone is closed.
  final ValueListenable<Float32List>? samples;

  /// `width = 120`.
  final double width;

  /// `height = 28`.
  final double height;

  /// `width = 120` — the component's own default, which the voice page
  /// overrides to 320 and the status line to 64.
  static const double defaultWidth = 120;

  /// `height = 28`.
  static const double defaultHeight = 28;

  /// `ctx.lineWidth = 1.5`.
  static const double strokeWidth = 1.5;

  /// `const y = mid + value * mid * 0.9` — the trace never reaches the edge.
  static const double amplitude = 0.9;

  @override
  State<ElLiveWaveform> createState() => _ElLiveWaveformState();
}

class _ElLiveWaveformState extends State<ElLiveWaveform> {
  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        // `--viz-ink: var(--agent)`, set inline on the canvas by the component
        // itself — the fallback `currentColor` is unreachable because the
        // property is always there to be read.
        painter: _WaveformPainter(samples: widget.samples, ink: theme.agent),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  _WaveformPainter({required this.samples, required this.ink})
    : super(repaint: samples);

  final ValueListenable<Float32List>? samples;
  final Color ink;

  @override
  void paint(Canvas canvas, Size size) {
    final double mid = size.height / 2;
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ElLiveWaveform.strokeWidth
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = ink;

    final Float32List? view = samples?.value;
    final Path path = Path();

    if (view == null || view.length < 2) {
      // No stream: a flat line, which is the truth.
      path
        ..moveTo(0, mid)
        ..lineTo(size.width, mid);
      canvas.drawPath(path, paint);
      return;
    }

    for (int i = 0; i < view.length; i++) {
      final double x = (i / (view.length - 1)) * size.width;
      final double y = mid + view[i] * mid * ElLiveWaveform.amplitude;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WaveformPainter old) =>
      old.ink != ink || old.samples != samples;
}

/* ── Bar visualizer ──────────────────────────────────────────────────────── */

/// `visualisers.tsx` L122 — `export function BarVisualizer`.
///
/// [spectrum] holds what `analyser.getByteFrequencyData` would have written —
/// 0 … 255 per bin, in bin order — and the logarithmic band reduction over it
/// is the reference's, exponent and divisor included: *"linear bins put eleven
/// of twelve bars in frequencies a human voice barely occupies."*
class ElBarVisualizer extends StatefulWidget {
  const ElBarVisualizer({
    super.key,
    this.spectrum,
    this.active = false,
    this.bars = defaultBars,
    this.width = defaultWidth,
    this.height = defaultHeight,
  });

  /// Frequency bins, 0 … 255. Null while the microphone is closed.
  final ValueListenable<Float32List>? spectrum;

  /// *"Used when there is no analyser but something IS happening — browser
  /// speech synthesis exposes no audio, so the alternative to this is a dead
  /// meter while the assistant is audibly talking. It is a signal that playback
  /// is running, not a reading of it, and it only animates when `active` is
  /// set."*
  final bool active;

  /// `bars = 12`.
  final int bars;

  /// `width = 96`.
  final double width;

  /// `height = 24`.
  final double height;

  static const int defaultBars = 12;
  static const double defaultWidth = 96;
  static const double defaultHeight = 24;

  /// `const gap = 2`.
  static const double gap = 2;

  /// `smoothed = smoothed * 0.55 + level * 0.45`.
  static const double smoothingKeep = 0.55;
  static const double smoothingTake = 0.45;

  /// *"A floor, so the meter reads as present-but-quiet rather than broken."*
  static const double floor = 0.06;

  /// The band edges: `(i / bars) ** 1.6`.
  static const double bandExponent = 1.6;

  /// `sum / (to - from) / 190`.
  static const double bandDivisor = 190;

  /// The `active` oscillator: `max(0.08, |sin(t·4 + i·0.7)| · 0.8 ·
  /// (1 − |i / bars − 0.5|))`.
  static const double activeFloor = 0.08;
  static const double activeRate = 4;
  static const double activePhase = 0.7;
  static const double activeScale = 0.8;

  @override
  State<ElBarVisualizer> createState() => _ElBarVisualizerState();
}

class _ElBarVisualizerState extends State<ElBarVisualizer>
    with SingleTickerProviderStateMixin {
  late List<double> _smoothed = List<double>.filled(widget.bars, 0);
  final ValueNotifier<double> _seconds = ValueNotifier<double>(0);
  Ticker? _ticker;
  bool _stilled = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
  }

  @override
  void didUpdateWidget(ElBarVisualizer old) {
    super.didUpdateWidget(old);
    if (old.bars != widget.bars) {
      _smoothed = List<double>.filled(widget.bars, 0);
    }
    if (old.active != widget.active || old.spectrum != widget.spectrum) {
      _play();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stilled = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    _play();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _seconds.dispose();
    super.dispose();
  }

  /// The reference's rAF loop never stops; it simply repaints an unchanged
  /// picture once the smoothing has settled. Running the ticker only while a
  /// signal or [ElBarVisualizer.active] can move the bars produces the same
  /// pixels — this is not the out-of-view pause ruling F2 forbids, it is
  /// declining to repaint a still image sixty times a second.
  void _play() {
    final Ticker ticker = _ticker!;
    final bool wants = !_stilled && (widget.active || widget.spectrum != null);
    if (wants == ticker.isActive) return;
    if (wants) {
      ticker.start();
    } else {
      ticker.stop();
    }
  }

  void _tick(Duration elapsed) {
    _seconds.value = elapsed.inMicroseconds / Duration.microsecondsPerSecond;
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: _BarsPainter(
          repaint: Listenable.merge(<Listenable?>[_seconds, widget.spectrum]),
          seconds: _seconds,
          spectrum: widget.spectrum,
          active: widget.active,
          bars: widget.bars,
          smoothed: _smoothed,
          ink: theme.agent,
        ),
      ),
    );
  }
}

class _BarsPainter extends CustomPainter {
  _BarsPainter({
    required Listenable repaint,
    required this.seconds,
    required this.spectrum,
    required this.active,
    required this.bars,
    required this.smoothed,
    required this.ink,
  }) : super(repaint: repaint);

  final ValueListenable<double> seconds;
  final ValueListenable<Float32List>? spectrum;
  final bool active;
  final int bars;
  final List<double> smoothed;
  final Color ink;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double barWidth = (w - ElBarVisualizer.gap * (bars - 1)) / bars;

    final List<double> levels = _levels();
    final Paint paint = Paint()..color = ink;

    for (int i = 0; i < bars; i++) {
      smoothed[i] =
          smoothed[i] * ElBarVisualizer.smoothingKeep +
          levels[i] * ElBarVisualizer.smoothingTake;
      final double value = math.max(ElBarVisualizer.floor, smoothed[i]);
      final double barHeight = value * h;
      final double x = i * (barWidth + ElBarVisualizer.gap);
      final double y = (h - barHeight) / 2;
      // `ctx.roundRect(x, y, barWidth, barHeight, barWidth / 2)` — a canvas
      // radius larger than half the shorter side is scaled down to fit, which
      // is what happens at the floor (3.08 asked, 0.72 drawn). `RRect`'s own
      // scaling rule is the same one.
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          Radius.circular(barWidth / 2),
        ).scaleRadii(),
        paint,
      );
    }
  }

  List<double> _levels() {
    final Float32List? view = spectrum?.value;
    if (view != null && view.isNotEmpty) {
      final int count = view.length;
      return <double>[
        for (int i = 0; i < bars; i++)
          () {
            final int from =
                (count * math.pow(i / bars, ElBarVisualizer.bandExponent))
                    .floor();
            final int to = math.max(
              from + 1,
              (count * math.pow((i + 1) / bars, ElBarVisualizer.bandExponent))
                  .floor(),
            );
            double sum = 0;
            for (int j = from; j < to && j < count; j++) {
              sum += view[j];
            }
            return math
                .min(1, sum / (to - from) / ElBarVisualizer.bandDivisor)
                .toDouble();
          }(),
      ];
    }
    if (active) {
      final double t = seconds.value;
      return <double>[
        for (int i = 0; i < bars; i++)
          math.max(
            ElBarVisualizer.activeFloor,
            (math.sin(
                  t * ElBarVisualizer.activeRate +
                      i * ElBarVisualizer.activePhase,
                )).abs() *
                ElBarVisualizer.activeScale *
                (1 - (i / bars - 0.5).abs()),
          ),
      ];
    }
    return List<double>.filled(bars, 0);
  }

  @override
  bool shouldRepaint(_BarsPainter old) =>
      old.ink != ink || old.active != active || old.bars != bars;
}

/* ── Mic control ─────────────────────────────────────────────────────────── */

/// `pickers.tsx` L42 — `export function MicControl`.
///
/// *"One audio control for both directions. The button records; the chevron
/// beside it opens everything to do with sound … The pair is drawn as a single
/// pill at all times, not only while live. A grouping that appears on
/// activation teaches the user the two halves are related only after they have
/// already had to guess."*
///
/// ## The chevron half is recorded, not built
///
/// Upstream renders it only when `hasMenu` — more than one microphone, or a
/// voice to pick, or speech to toggle. On the reference's own specimen none of
/// those hold: probed on the live page, the pill measures **34 × 34** (1px
/// border, a 32px button, 1px border) with a single child, and the menu branch
/// never renders. Behind it sit `enumerateDevices` and `speechSynthesis`, two
/// more browser APIs with no dependency-free Flutter equivalent. So the branch
/// is documented here and not built — the [ElMicControl] surface is exactly the
/// surface the reference page exercises. The precedent is ruling S2's dormant
/// `data-vertical` branch: recorded, not built.
class ElMicControl extends StatelessWidget {
  const ElMicControl({
    super.key,
    required this.listening,
    this.onToggle,
    this.disabled = false,
  });

  /// `dictation.isListening` — the only thing that changes the pill's fill.
  final bool listening;

  /// `dictation.toggle`.
  final VoidCallback? onToggle;

  /// `disabled`.
  final bool disabled;

  /// `border-agent/45`.
  static const double liveBorderAlpha = 0.45;

  /// `bg-agent/12`.
  static const double liveFillAlpha = 0.12;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);

    return Container(
      // Tailwind's `border` sits OUTSIDE the 32px button — the live pill
      // measures 34 × 34 — and a [BoxDecoration] border reserves its own width
      // around the child, so nothing else is needed to reach it. Adding a
      // hairline of padding as well makes it 36.
      decoration: BoxDecoration(
        // `border-border flex items-center gap-px rounded-pill border`, and
        // `border-agent/45 bg-agent/12` once it is live.
        color: listening ? theme.agent.withValues(alpha: liveFillAlpha) : null,
        border: Border.all(
          color: listening
              ? theme.agent.withValues(alpha: liveBorderAlpha)
              : theme.border,
          width: ElWidths.hairline,
        ),
        borderRadius: BorderRadius.circular(ElRadii.pill),
      ),
      child: _MicButton(
        listening: listening,
        onToggle: onToggle,
        disabled: disabled,
      ),
    );
  }
}

/// The recording half — `size-8 rounded-pill`, plus `text-agent
/// anim-pulse-live hover:bg-transparent` while live.
class _MicButton extends StatefulWidget {
  const _MicButton({
    required this.listening,
    required this.onToggle,
    required this.disabled,
  });

  final bool listening;
  final VoidCallback? onToggle;
  final bool disabled;

  @override
  State<_MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<_MicButton>
    with SingleTickerProviderStateMixin {
  /// `anim-pulse-live { animation: pulls-pulse-live 2s var(--ease-in-out)
  /// infinite }` — globals.css L2354.
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: ElDurations.pulseLive,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(_MicButton old) {
    super.didUpdateWidget(old);
    if (old.listening != widget.listening) _sync();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _sync() {
    _pulse.duration = elAnimationDuration(context, ElDurations.pulseLive);
    if (widget.listening && _pulse.duration != Duration.zero) {
      if (!_pulse.isAnimating) _pulse.repeat();
    } else {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final Widget button = ElButton(
      variant: ElButtonVariant.ghost,
      // `size="icon" className="size-8 rounded-pill"` — the cva size is the
      // 40px one and the call site overrides it to 32, which is [iconSm]'s
      // box. The glyph does NOT follow: `className="size-4"` pins it at 16,
      // where [iconSm]'s own default would be 14. Measured on the live
      // reference: a 32px button around a 16px svg.
      size: ElButtonSize.iconSm,
      radius: BorderRadius.circular(ElRadii.pill),
      onPressed: widget.disabled ? null : widget.onToggle,
      label: widget.listening ? 'Stop dictation' : 'Dictate',
      child: const ElIcon.lucide(ElLucide.mic, sizePx: _glyphPx),
    );

    if (!widget.listening) return button;

    // `text-agent` while live. [ElIconTone.inherit] is `text-current`, so the
    // colour arrives the same way it does in the browser: from the text style
    // the button's content sits in.
    final Widget live = DefaultTextStyle.merge(
      style: TextStyle(color: theme.agent),
      child: button,
    );

    return AnimatedBuilder(
      animation: _pulse,
      builder: (BuildContext context, Widget? child) {
        // `0%,100% { opacity: 1; box-shadow: 0 0 0 0 rgba(61,220,151,.5) }`
        // `50%     { opacity: .75; box-shadow: 0 0 0 5px rgba(61,220,151,0) }`
        // The keyframe eases per interval on `--ease-in-out`, so each half is
        // curved on its own rather than one curve running across the pair.
        final double t = _pulse.value;
        final double leg = t < 0.5 ? t * 2 : (1 - t) * 2;
        final double eased = ElCurves.inOut.transform(leg.clamp(0.0, 1.0));
        return Opacity(
          opacity: 1 - eased * _pulseOpacityDrop,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ElRadii.pill),
              boxShadow: ElShadows.pulseLiveRing(eased).outerShadows(theme),
            ),
            child: child,
          ),
        );
      },
      child: live,
    );
  }

  /// `className="size-4"` on the icon, against [ElButtonSize.iconSm]'s 14.
  static const double _glyphPx = 16;

  /// `opacity: 1` → `0.75`.
  static const double _pulseOpacityDrop = 0.25;
}
