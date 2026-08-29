/// `components/agent/voice/orb.tsx` — the voice face.
///
/// *"Two things in this console have a state to show: the agent, which has
/// twenty, and the microphone, which has three. The avatar draws the first;
/// this draws the second."*
///
/// The orb itself is ElevenLabs' — vendored upstream in `voice/orb-vendor.tsx`
/// as a Three.js mesh under a GLSL fragment shader. That shader is ported
/// character-for-character to `shaders/orb.frag`; its header lists the five
/// edits Flutter forced and nothing else moved. **This** file is the port of
/// `orb.tsx`, the seam upstream sits behind, and it keeps that file's two jobs:
///
///   **Colour it from the theme.** A shader cannot resolve a CSS custom
///   property, so `orb.tsx` reads `--orb-from` / `--orb-to` through
///   `getComputedStyle` and hands THREE a real colour. Here they are resolved
///   from [ResolvedColorMode] against [Palette] (ruling S3's precedent: raw-palette
///   access is this port's pattern where a token is not on [ThemeTokens]).
///
///   **Keep it off the microphone.** Upstream's `volumeMode: "auto"` opens its
///   own `getUserMedia`. The console already holds one, so the orb runs in
///   manual mode and is fed the level that is already being read — *"one
///   stream, two consumers"*. In the port that level arrives as
///   [VoiceIndicator.level], a plain listenable, for the reason in the divergence
///   note below.
///
/// ## Two divergences, both recorded
///
///  1. **There is no `AnalyserNode`.** Web Audio is a browser API with no
///     Flutter equivalent that does not cost a plugin, and this package takes
///     no third-party dependency. `orb.tsx`'s per-frame reduction —
///     `getByteFrequencyData`, mean bin, `/110`, clamp to 1 — is the caller's
///     job now; what crosses the seam is the same 0–1 number it produced.
///     [VoiceIndicator.level] is that number. Everything downstream of it, from the
///     listening/talking split to the `0.2` follow, is upstream's arithmetic
///     unchanged.
///  2. **`state` is not read while `level` is null**, and that is upstream's
///     behaviour rather than a shortcut. `orb.tsx` always passes
///     `volumeMode: "manual"`, and in manual mode the vendor never looks at
///     `agentState` — so the four labelled orbs on the voice page render from
///     the same two zeroes and differ only in their random phase. Probed on the
///     live reference 2026-08-16: the four canvases' mean disc colour is
///     rgb(55.7, 68.9, 151.2) / (25.3, 39.6, 130.7) / (56.9, 70.1, 152.4) /
///     (45.6, 59.1, 143.8) — four samples of one distribution, not four states.
///     The prop is carried anyway, exactly as upstream carries it, because a
///     caller that supplies a level gets the listening/talking split from it.
///
/// ## The browser probe
///
/// The painter rule pairs rendered-pixel pins with a probe of the target that
/// actually ships, and this one earned it twice. Built to CanvasKit and
/// sampled with `scratchpad/ag-orb-web.js` on 2026-08-16:
///
///  * **Geometry, exact.** The disc measures **102px across a 112px box,
///    first inked column at x=5** — the live reference's own numbers to the
///    pixel.
///  * **Colour, in family.** Mean disc colour across the four seeded orbs is
///    rgb(52.4, 65.8, 149.3), against the reference's four random-phase orbs
///    at rgb(45.9, 59.4, 144.5) — inside the spread of its own samples, and
///    nowhere near the rgb(48.7, 91.3, 184.4) that feeding the shader raw sRGB
///    would have produced.
///
/// Two defects surfaced only there, and neither could have been caught by a
/// widget test:
///
///  1. `(i % 2 == 1)` in the vendored GLSL is **rejected outright by SkSL**
///    while Impeller accepts it, so the compiled asset silently carried Vulkan
///    stage data alone and `FragmentProgram.fromAsset` failed with what read
///    like a toolchain limit. Rewritten as `((i / 2) * 2 != i)`.
///  2. A [ui.FragmentShader] built and disposed inside `paint` rasterises with
///    **every uniform at zero** in a release web build — the picture is
///    rasterised after `paint` returns. A diagnostic variant that encoded its
///    own uniforms proved it: `FlutterFragCoord()` was correct and `uSize` read
///    0, so `vUv` divided by nothing and every fragment fell outside the disc.
///    The shader is now built once per widget and re-set per frame.
///
/// ## The clock
///
/// `useFrame` gives upstream a delta per frame and it integrates: `uTime` at
/// half speed, `uAnimation` at a speed that itself chases the output volume,
/// the two volumes each following their target at `0.2`, and a fade-in that
/// takes half a second. None of that is expressible as an [AnimationController]
/// curve — it is a feedback loop — so this drives a bare [Ticker] and does the
/// same integration. Reduced motion stops the ticker where every other looper
/// in this package stops its controller, and the last frame stays on screen.
library;

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' show rootBundle;
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

import '../../design_system/foundation/colors.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/theme_scope.dart';

/// `orb.tsx` L35 — `export type OrbState`.
///
/// *"`idle` is its null state: alive, but not engaged."* The mapping to the
/// vendor's own vocabulary is upstream's `AGENT_STATE` record; [idle] is the
/// one that maps to `null`.
enum VoiceIndicatorState {
  /// The vendor's `null` agent state.
  idle,

  /// The user is speaking. Level drives `uInputVolume`.
  listening,

  /// The assistant is speaking. Level drives `uOutputVolume`.
  talking,

  /// Working, not speaking. Level drives `uOutputVolume`, as [talking] does —
  /// the split `orb.tsx` draws is *"listening"* against everything else.
  thinking,
}

/* ── The programme, loaded once ──────────────────────────────────────────── */

/// The shader and its perlin field, cached for the whole isolate.
///
/// `useTexture` memoises upstream; here the pair is a single future so that
/// twenty orbs on a matrix page compile one programme and decode one image
/// between them. Failure resolves to `null` rather than throwing: a missing
/// asset must leave the surrounding page standing, and the widget simply paints
/// nothing — which is `orb.tsx`'s own first-frame behaviour, where `colors` is
/// null until the element exists and *"guessing a colour would produce a
/// visible flash of the wrong one"*.
class VoiceIndicatorProgram {
  VoiceIndicatorProgram._(this.program, this.noise);

  /// The compiled `shaders/orb.frag`.
  final ui.FragmentProgram program;

  /// `assets/textures/perlin-noise.png`, decoded.
  final ui.Image noise;

  static Future<VoiceIndicatorProgram?>? _pending;
  static VoiceIndicatorProgram? _loaded;
  static Object? _lastError;

  /// Why the last [load] gave up, or null if it did not.
  ///
  /// Kept because the two ways it can fail are not the same news: an absent
  /// bundle is an invocation flag, and a bundle whose shader carries no stage
  /// data for the current backend is a toolchain fact worth naming in a test
  /// report rather than hiding behind a null.
  static Object? get lastError => _lastError;

  /// The loaded pair, or null while it is still arriving.
  static VoiceIndicatorProgram? get loaded => _loaded;

  /// Compiles and decodes on first call; every later call gets the same future.
  static Future<VoiceIndicatorProgram?> load() {
    if (_pending != null) return _pending!;
    return _pending = _load();
  }

  static Future<VoiceIndicatorProgram?> _load() async {
    try {
      // Two keys, one asset. A package's own test suite IS the root project,
      // so its assets are keyed bare; an app that depends on the package reaches
      // the same files under `packages/<name>/`. Trying the prefixed key first
      // keeps the app path — the one that ships — on the fast branch.
      // The bare key is BOTH the package's own test bundle and a consuming
      // app's, because `shaders:` is root-project-only — see the block in
      // `example/pubspec.yaml`. The prefixed key is tried first anyway, so the
      // day flutter_tools starts handing shaders down, this needs no change.
      final ui.FragmentProgram program = await _firstOf(
        ui.FragmentProgram.fromAsset,
        <String>[_shaderAsset, _bareShaderAsset],
      );
      final ByteData bytes = await _firstOf(rootBundle.load, <String>[
        _noiseAsset,
        _bareNoiseAsset,
      ]);
      final ui.Codec codec = await ui.instantiateImageCodec(
        bytes.buffer.asUint8List(),
      );
      final ui.FrameInfo frame = await codec.getNextFrame();
      _lastError = null;
      return _loaded = VoiceIndicatorProgram._(program, frame.image);
    } catch (error, stack) {
      _lastError = error;
      // A design-system gallery that throws because one decoration could not
      // load is worse than one that draws nineteen sections and an empty box.
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'elattar_design_system',
          context: ErrorDescription('loading the voice orb shader'),
        ),
      );
      return null;
    }
  }

  /// Test seam: forget what was loaded so a suite can prove both branches.
  @visibleForTesting
  static void resetForTest() {
    _pending = null;
    _loaded = null;
    _lastError = null;
  }

  static Future<T> _firstOf<T>(
    Future<T> Function(String key) load,
    List<String> keys,
  ) async {
    Object? last;
    for (final String key in keys) {
      try {
        return await load(key);
      } catch (error) {
        last = error;
      }
    }
    throw last!;
  }

  static const String _bareShaderAsset = 'shaders/orb.frag';
  static const String _shaderAsset =
      'packages/elattar_design_system/$_bareShaderAsset';
  static const String _bareNoiseAsset = 'assets/textures/perlin-noise.png';
  static const String _noiseAsset =
      'packages/elattar_design_system/$_bareNoiseAsset';
}

/* ── The orb ─────────────────────────────────────────────────────────────── */

/// `orb.tsx` L45 — `export function Orb`.
class VoiceIndicator extends StatefulWidget {
  const VoiceIndicator({
    super.key,
    this.state = VoiceIndicatorState.idle,
    this.level,
    this.size = defaultSize,
    this.seed,
  });

  /// `state = "idle"`.
  final VoiceIndicatorState state;

  /// The 0–1 level the caller already reads. Null leaves the orb at rest —
  /// *"Live audio, when the source has any. Null leaves the orb at rest."*
  ///
  /// A [ValueListenable] rather than a `double` for the reason `orb.tsx` uses
  /// refs: *"the orb samples these inside its render loop, so a state update
  /// per frame would re-render React sixty times a second to move a number the
  /// shader could have read directly."* A listenable is read in the ticker and
  /// never rebuilds this widget.
  final ValueListenable<double>? level;

  /// `size = 96`.
  final double size;

  /// The vendor's `seed`. Null takes a random one, as upstream does — which is
  /// why two orbs side by side are never in phase.
  final int? seed;

  /// `size = 96` — the vendor's own default.
  static const double defaultSize = 96;

  /// The fraction of the box the disc covers.
  ///
  /// Upstream draws `circleGeometry(3.5, 64)` under r3f's default camera —
  /// 75° vertical fov at z = 5, so the frustum is `2 · 5 · tan 37.5° =
  /// 7.67327` units tall and the 7-unit disc fills `7 / 7.67327` of it. Derived
  /// and then **measured**, because a derived number is a guess until it is
  /// not: the live 112px canvases render a disc exactly 102px across
  /// (0.910714 against this 0.912258 — half a pixel each side).
  static const double discFraction = 0.9122577609888439;

  /// The seven phase offsets a given seed produces.
  ///
  /// Exposed so a test can prove the ported `splitmix32` is bit-identical to
  /// the browser's — that sequence is the only part of the orb reproducible
  /// across the two runtimes, and it is what makes a seeded orb pinnable at
  /// all.
  @visibleForTesting
  static List<double> offsetsForSeed(int seed) =>
      _VoiceIndicatorState._makeOffsets(seed).toList();

  @override
  State<VoiceIndicator> createState() => _VoiceIndicatorState();
}

class _VoiceIndicatorState extends State<VoiceIndicator>
    with SingleTickerProviderStateMixin {
  /// `offsets` — seven phases, `random() * Math.PI * 2`.
  late Float32List _offsets = _makeOffsets(widget.seed);

  /// The vendor's five integrators.
  double _uTime = 0;
  double _uAnimation = _animationStart;
  double _uOpacity = 0;
  double _curIn = 0;
  double _curOut = 0;
  double _animSpeed = _speedFloor;

  Ticker? _ticker;
  Duration _last = Duration.zero;
  bool _stilled = false;
  VoiceIndicatorProgram? _resources = VoiceIndicatorProgram.loaded;

  /// ONE shader, held for as long as the widget is.
  ///
  /// Not one per `paint`. A [ui.FragmentShader] created and disposed inside a
  /// paint call rasterises with **every uniform at zero** in a release web
  /// build — the picture is rasterised after `paint` returns, and disposing
  /// before that drops the uniform block. Probed on a CanvasKit build: with a
  /// per-paint shader the orb was invisible everywhere, and a diagnostic
  /// variant that encoded its own uniforms into the output read `uSize = 0`
  /// while `FlutterFragCoord()` was correct — so the coordinates were right,
  /// the rect was right, and the uniforms simply were not there. Held and
  /// re-set per frame, it draws.
  ui.FragmentShader? _shader;

  /// Bumped once per painted frame so the [CustomPaint] repaints without this
  /// widget rebuilding.
  final ValueNotifier<int> _frame = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    if (_resources == null) {
      VoiceIndicatorProgram.load().then((VoiceIndicatorProgram? loaded) {
        if (!mounted || loaded == null) return;
        setState(() {
          _resources = loaded;
          _shader = loaded.program.fragmentShader();
        });
      });
    } else {
      _shader = _resources!.program.fragmentShader();
    }
    _ticker = createTicker(_tick);
  }

  @override
  void didUpdateWidget(VoiceIndicator old) {
    super.didUpdateWidget(old);
    if (old.seed != widget.seed) _offsets = _makeOffsets(widget.seed);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The same question [effectiveMotionDuration] answers for every other looper in
    // this package, asked of a clock that has no duration to collapse: a ticker
    // integrates real time, so "reduced" means *stop it*, and the frame it
    // stopped on stays on screen. Reduced is zero-duration, never "disabled" —
    // the orb is still drawn.
    final bool stilled = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (_stilled == stilled && (_ticker?.isActive ?? false) == !stilled) return;
    _stilled = stilled;
    _play();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _frame.dispose();
    _shader?.dispose();
    super.dispose();
  }

  void _play() {
    final Ticker ticker = _ticker!;
    if (_stilled) {
      ticker.stop();
      // The fade-in is an entrance, and the blanket reduced-motion rule the
      // reference states for the avatar applies in spirit here: a frozen
      // entrance freezes at its END, not at its start. Leaving `uOpacity` at 0
      // would make "reduced motion" mean "no orb", which is the trap
      // `globals.css` L3186 calls out by name.
      _uOpacity = 1;
      _frame.value++;
      return;
    }
    _last = Duration.zero;
    if (!ticker.isActive) ticker.start();
  }

  /// `useFrame((_, delta) => …)` — orb-vendor.tsx L198.
  void _tick(Duration elapsed) {
    final double delta = _last == Duration.zero
        ? 0
        : (elapsed - _last).inMicroseconds / Duration.microsecondsPerSecond;
    _last = elapsed;
    if (delta <= 0) return;

    _uTime += delta * _timeRate;

    if (_uOpacity < 1) {
      _uOpacity = math.min(1, _uOpacity + delta * _fadeRate);
    }

    // `volumeMode: "manual"` — always, because `orb.tsx` always passes it. The
    // vendor's `auto` branch (its own oscillators per agent state) is dead in
    // this codebase and is not ported; see divergence 2 in the library note.
    final double level = widget.level?.value.clamp(0.0, 1.0).toDouble() ?? 0;
    final bool listening = widget.state == VoiceIndicatorState.listening;
    final double targetIn = listening ? level : 0;
    final double targetOut = listening ? 0 : level;

    _curIn += (targetIn - _curIn) * _follow;
    _curOut += (targetOut - _curOut) * _follow;

    final double targetSpeed =
        _speedFloor + (1 - math.pow(_curOut - 1, 2).toDouble()) * _speedRange;
    _animSpeed += (targetSpeed - _animSpeed) * _speedFollow;
    _uAnimation += delta * _animSpeed;

    _frame.value++;
  }

  @override
  Widget build(BuildContext context) {
    final ui.FragmentShader? shader = _shader;
    final double size = widget.size;

    // `colors ? <VendorOrb …/> : null` — nothing until there is something real
    // to draw with.
    if (shader == null || _resources == null) {
      return SizedBox.square(dimension: size);
    }

    final ResolvedColorMode kind = ThemeScope.kindOf(context);
    final (Color from, Color to) = _orbStops(kind);

    return RepaintBoundary(
      child: CustomPaint(
        size: Size.square(size),
        painter: _OrbPainter(
          shader: shader,
          noise: _resources!.noise,
          repaint: _frame,
          state: this,
          from: from,
          to: to,
          inverted: kind == ResolvedColorMode.dark,
        ),
      ),
    );
  }

  /// `--orb-from` / `--orb-to`, globals.css L733–734 (light) and L940–941
  /// (dark).
  ///
  /// *"Declared as their own tokens rather than read off `--agent` directly,
  /// because a shader cannot resolve a CSS variable … Keeping them separate
  /// also means the orb can be tuned without moving the accent every icon
  /// uses."* Both stops are ramp members, so they read off [Palette] rather
  /// than adding two fields to [ThemeTokens] that nothing else would consume.
  static (Color, Color) _orbStops(ResolvedColorMode kind) => switch (kind) {
    ResolvedColorMode.light => (Palette.action, Palette.actionDark),
    ResolvedColorMode.dark => (Palette.actionBright, Palette.action),
  };

  static Float32List _makeOffsets(int? seed) {
    // `splitmix32(seed ?? Math.floor(Math.random() * 2 ** 32))`, ported below.
    final _SplitMix32 random = _SplitMix32(seed ?? _entropy.nextInt(1 << 32));
    return Float32List.fromList(<double>[
      for (int i = 0; i < 7; i++) random.next() * math.pi * 2,
    ]);
  }

  static final math.Random _entropy = math.Random();

  /// `u.uTime.value += delta * 0.5`.
  static const double _timeRate = 0.5;

  /// `u.uOpacity.value + delta * 2`.
  static const double _fadeRate = 2;

  /// `cur += (target - cur) * 0.2`.
  static const double _follow = 0.2;

  /// `animSpeedRef += (targetSpeed - animSpeedRef) * 0.12`.
  static const double _speedFollow = 0.12;

  /// `0.1 + (1 - (curOut - 1)²) * 0.9` — floor and range.
  static const double _speedFloor = 0.1;
  static const double _speedRange = 0.9;

  /// `uAnimation: new THREE.Uniform(0.1)` — the uniform's initial value, which
  /// happens to equal the speed floor and is not the same number.
  static const double _animationStart = 0.1;
}

/* ── The painter ─────────────────────────────────────────────────────────── */

class _OrbPainter extends CustomPainter {
  _OrbPainter({
    required this.shader,
    required this.noise,
    required Listenable repaint,
    required this.state,
    required this.from,
    required this.to,
    required this.inverted,
  }) : super(repaint: repaint);

  final ui.FragmentShader shader;
  final ui.Image noise;
  final _VoiceIndicatorState state;
  final Color from;
  final Color to;
  final bool inverted;

  @override
  void paint(Canvas canvas, Size size) {
    final double side = size.shortestSide * VoiceIndicator.discFraction;
    if (side <= 0) return;

    final Float32List offsets = state._offsets;

    // Uniform order is the declaration order in `shaders/orb.frag`; a vec_n_
    // consumes n consecutive float slots.
    int i = 0;
    void put(double value) => shader.setFloat(i++, value);
    void putColor(Color color) {
      put(_linear(color.r));
      put(_linear(color.g));
      put(_linear(color.b));
    }

    put(side); // uSize.x
    put(side); // uSize.y
    put(state._uTime);
    put(state._uAnimation);
    put(inverted ? 1 : 0);
    for (int n = 0; n < 7; n++) {
      put(offsets[n]); // uOffsetsA.xyzw, then uOffsetsB.xyz
    }
    putColor(from); // uColor1
    putColor(to); // uColor2
    put(state._curIn);
    put(state._curOut);
    put(state._uOpacity);
    shader.setImageSampler(0, noise);

    final Offset origin = Offset(
      (size.width - side) / 2,
      (size.height - side) / 2,
    );
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.drawRect(Rect.fromLTWH(0, 0, side, side), Paint()..shader = shader);
    canvas.restore();
  }

  /// sRGB → linear-sRGB, the transfer function `THREE.ColorManagement` applies
  /// to every colour handed to `new THREE.Color(…)` since r152.
  ///
  /// See the colour-space note in `shaders/orb.frag`: the vendored shader
  /// writes its result straight to an sRGB framebuffer with no encoding step,
  /// so the orb renders darker than the token it is drawn from. Measured on the
  /// live reference, and reproduced rather than corrected.
  static double _linear(double channel) => channel <= 0.04045
      ? channel / 12.92
      : math.pow((channel + 0.055) / 1.055, 2.4).toDouble();

  @override
  bool shouldRepaint(_OrbPainter old) =>
      old.from != from ||
      old.to != to ||
      old.inverted != inverted ||
      old.shader != shader;
}

/* ── The vendor's RNG ────────────────────────────────────────────────────── */

/// `orb-vendor.tsx` L300 — `splitmix32`, ported exactly.
///
/// Dart has no `>>>` on a signed 64-bit `int` that behaves like JavaScript's on
/// a 32-bit one, and `Math.imul` is a 32-bit multiply that wraps. Both are
/// spelled out against a `0xFFFFFFFF` mask so the sequence is bit-identical to
/// the browser's for the same seed — which is what makes a seeded orb pinnable
/// in a test.
class _SplitMix32 {
  _SplitMix32(int seed) : _a = seed & _mask;

  int _a;

  static const int _mask = 0xFFFFFFFF;

  int _imul(int a, int b) => (a * b) & _mask;

  double next() {
    _a = (_a + 0x9E3779B9) & _mask;
    int t = _a ^ (_a >>> 16);
    t = _imul(t, 0x21F0AAAD);
    t = t ^ (t >>> 15);
    t = _imul(t, 0x735A2D97);
    t = t ^ (t >>> 15);
    return (t & _mask) / 4294967296;
  }
}
