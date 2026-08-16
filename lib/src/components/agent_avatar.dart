/// `components/agent/avatar/` — the default face, whole.
///
/// Four reference files fold into one library, because they are one object: an
/// isometric projection, twenty scene recipes written against it, the fourteen
/// keyframes those recipes name, and the component that runs them.
///
/// | reference | what lands here |
/// |---|---|
/// | `avatar/cube.tsx` | [DsAgentCube], [DsAgentCubeSpec], [DsCubeScene] |
/// | `avatar/scenes.ts` | [dsAgentCubeScene], the nineteen recipes |
/// | `avatar/types.ts` | [DsAgentAvatarSize] and [DsCubeAvatar]'s four props |
/// | `avatar/cube-avatar.tsx` | [DsCubeAvatar], the crossfade, the idle cube |
/// | `globals.css` L3109–3177 | [DsAgentCubeKeyframes], the fourteen tables |
/// | `globals.css` L720–731 / L914–932 | [DsAgentCubeTokens] |
///
/// ## One projection, three polygons, one sort
///
/// `cube.tsx` states the geometry and this file does not restate it in another
/// form: `screenX = (x − y) · 13`, `screenY = (x + y) · 6.5 − z · 13`, three
/// face polygons in the cube's own coordinates, and a painter's sort on
/// `x + y + boost` with `z` breaking ties. Everything else in the family is a
/// list of coordinates.
///
/// **The viewBox is measured, not declared** — `cube.tsx`'s own decision, and
/// the reason it matters here is that Flutter has no `overflow: visible` to
/// fall back on. A [CustomPaint] does not clip, which is the property this file
/// depends on: `pull` lifts a cube 20 units above the measured box, `bounce`
/// 16, `drop` starts 24 above it, and every one of them is outside the bounds
/// the viewBox pins. Nothing in here may be wrapped in a [ClipRect].
///
/// ## The clock is elapsed time, not a controller position
///
/// A scene holds up to twenty cubes on up to three different periods
/// (`searching` composes a 2.6s glide over a 1.3s bob) with up to twenty
/// distinct delays. One [AnimationController] cannot express that; a CSS
/// animation's clock can, because it counts **elapsed time** and each element
/// divides it by its own duration. So the avatar runs one [Ticker] and every
/// cube resolves its own phase out of it — the same mechanism `sheen_action.dart`
/// already uses, and for the same reason.
///
/// A positive `animation-delay` with `animation-fill-mode: none` means the
/// element shows its **own** resting style until the animation starts. For the
/// `appear` and `drop` families that resting style is the inline `opacity: 0`
/// the helpers set, which `cube.tsx` calls load-bearing: *"without it every cube
/// in the scene flashes at full opacity on the first frame."* [DsAgentCubeMotion
/// .startsHidden] is that inline style.
///
/// ## Reduced motion is stated, not inherited
///
/// globals.css L3195–3215 writes the rule out by hand rather than letting the
/// blanket `prefers-reduced-motion` collapse apply, because `appear` and `drop`
/// **end at opacity 0** and the blanket rule would freeze half these scenes to
/// nothing at all. The explicit rule is `animation: none; opacity: 1;
/// transform: none`, and [DsCubeScene.frozen] is exactly that: every cube fully
/// opaque, at its grid position, not moving. It is emphatically NOT "the clock
/// stopped at zero" — at zero `blinkfade` reads 0.15 and `appear` reads 0.
///
/// ## What is deliberately absent
///
/// The status line. `parts/agent-face.tsx`'s `StatusLine` belongs to the
/// console family and has one consumer on this page; it stays page-local until
/// a second consumer earns the promotion. `anim-shimmer-text`'s duration is in
/// [DsDurations.shimmerText] because the page-local copy needs a token to read.
library;

import 'dart:math' as math;
import 'dart:typed_data' show Float64List;
import 'dart:ui' as ui;

import 'package:flutter/scheduler.dart' show Ticker;
import 'package:flutter/widgets.dart';

import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../motion/keyframes.dart';
import '../theme_scope.dart';
import 'agent_core.dart';

/* ── A · the isometric unit ──────────────────────────────────────────────── */

/// `cube.tsx` L20–37 — the projection, the three faces and the measured box.
///
/// *"Geometry is the design handoff's, unchanged."*
class DsAgentCube {
  const DsAgentCube._();

  /// Half-width. `const HW = 13`.
  static const double halfWidth = 13;

  /// Half-height. `const HH = 6.5`.
  static const double halfHeight = 6.5;

  /// Cube height. `const CH = 13`.
  static const double cubeHeight = 13;

  /// `const PAD = 10` — the measured viewBox's margin on all four sides.
  static const double pad = 10;

  /// `strokeWidth={0.8}` on every polygon of every cube.
  static const double strokeWidth = 0.8;

  /// `strokeDasharray` on a dashed cube — `const DASH = "3 2.5"`.
  static const List<double> dash = <double>[3, 2.5];

  /// `const face = 44 * scale * 1.35` — the idle cube's edge, in CSS pixels.
  ///
  /// The one non-isometric state's geometry lives beside the isometric unit
  /// rather than inside the private widget, because it is the other half of the
  /// same measurement: 28.512px at `lg` against a 26-unit isometric cube.
  static const double idleFaceUnit = 44;
  static const double idleFaceFactor = 1.35;

  /// `perspective: ${360 * scale}px`.
  static const double idlePerspectiveUnit = 360;

  static double idleFace(double scale) => idleFaceUnit * scale * idleFaceFactor;

  static double idlePerspective(double scale) => idlePerspectiveUnit * scale;

  /// `translateZ(${half}px)` — *"The face size scales with the avatar, so
  /// `translateZ` is half of it."*
  static double idleTranslateZ(double scale) => idleFace(scale) / 2;

  /// `screenX = (x − y) · HW`, `screenY = (x + y) · HH − z · CH`.
  static Offset iso(double x, double y, [double z = 0]) => Offset(
        (x - y) * halfWidth,
        (x + y) * halfHeight - z * cubeHeight,
      );

  /// `FACE.top` — `"0,0 13,6.5 0,13 -13,6.5"`, relative to the cube's origin.
  static const List<Offset> topFace = <Offset>[
    Offset(0, 0),
    Offset(halfWidth, halfHeight),
    Offset(0, cubeHeight),
    Offset(-halfWidth, halfHeight),
  ];

  /// `FACE.left` — `"-13,6.5 0,13 0,26 -13,19.5"`.
  static const List<Offset> leftFace = <Offset>[
    Offset(-halfWidth, halfHeight),
    Offset(0, cubeHeight),
    Offset(0, halfHeight * 2 + cubeHeight),
    Offset(-halfWidth, halfHeight + cubeHeight),
  ];

  /// `FACE.right` — `"13,6.5 0,13 0,26 13,19.5"`.
  static const List<Offset> rightFace = <Offset>[
    Offset(halfWidth, halfHeight),
    Offset(0, cubeHeight),
    Offset(0, halfHeight * 2 + cubeHeight),
    Offset(halfWidth, halfHeight + cubeHeight),
  ];

  /// `CubeScene`'s measured viewBox, in scene units.
  ///
  /// *"A scene's extent depends on its own geometry, and hand-tuning twenty
  /// viewBoxes is how a scene silently clips the first time someone edits a
  /// recipe."*
  static Rect viewBoxOf(List<DsAgentCubeSpec> cubes) {
    double minX = double.infinity;
    double maxX = double.negativeInfinity;
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    for (final DsAgentCubeSpec cube in cubes) {
      final Offset s = iso(cube.x, cube.y, cube.z);
      minX = math.min(minX, s.dx - halfWidth);
      maxX = math.max(maxX, s.dx + halfWidth);
      minY = math.min(minY, s.dy);
      maxY = math.max(maxY, s.dy + halfHeight * 2 + cubeHeight);
    }

    return Rect.fromLTWH(
      minX - pad,
      minY - pad,
      maxX - minX + pad * 2,
      maxY - minY + pad * 2,
    );
  }

  /// `sortCubes` — back to front by depth, then by height.
  ///
  /// *"`x + y` is distance from the viewer in the isometric grid… `boost` lifts
  /// a cube out of that ordering entirely, and `z` breaks ties within one grid
  /// cell so a stack draws bottom-up."*
  ///
  /// `Array.prototype.sort` has been **stable** since ES2019 and [List.sort] is
  /// not, so the source index is the last comparator rather than left to the
  /// algorithm: three of the recipes push cubes that tie on both keys, and an
  /// unstable sort would reorder the draw within a cell frame to frame.
  static List<DsAgentCubeSpec> sorted(List<DsAgentCubeSpec> cubes) {
    final List<int> order = List<int>.generate(cubes.length, (int i) => i);
    order.sort((int a, int b) {
      final DsAgentCubeSpec ca = cubes[a];
      final DsAgentCubeSpec cb = cubes[b];
      final double depth = (ca.x + ca.y + ca.boost) - (cb.x + cb.y + cb.boost);
      if (depth != 0) return depth < 0 ? -1 : 1;
      if (ca.z != cb.z) return ca.z < cb.z ? -1 : 1;
      return a - b;
    });
    return <DsAgentCubeSpec>[for (final int i in order) cubes[i]];
  }
}

/* ── B · the tokens ──────────────────────────────────────────────────────── */

// ── CLOSED: the twelve `--agent-cube-*` tokens ──────────────────────────────
// `DsAgentCubeTokens` used to be declared here, under a standing FOLLOW-UP that
// said exactly why it should not be: the twelve customs are declared in the two
// theme blocks (globals.css L720–731 light, L914–932 dark) beside every other
// token, and `foundation/theme.dart` was not the avatar lane's file to open.
// This pass is the opening. The class is `DsThemeData`'s neighbour now and the
// tokens ride [DsThemeData.cube]; `DsAgentCubeTokens.light` / `.dark` are
// unchanged, so nothing that spends them had to move with them.
//
// `DsAgentCubeTokens.of(BuildContext)` did **not** travel, and its two call
// sites read `DsTheme.of(context).cube` instead — it was a second resolver for
// what the theme scope already does, which is the same tidy-up
// `bloom_cosmic.dart` made when its five knobs moved.
//
// What did NOT move, and why: [DsAgentCubeFaces] below mixes an accent cube's
// top and right faces out of `accent` and `accentShade` in oklab, so it is a
// derivation rather than a declaration — the same seam `--bloom-core` splits
// along, and it stays next to the cubes it lights.

/// The four colours one cube is drawn in, plus its dash.
///
/// `cube.tsx`'s `NEUTRAL` / `ACCENT` / `ERROR` / `GHOST`, resolved. The accent's
/// top and right faces are *derived* rather than declared, *"exactly as the
/// handoff specifies, so that a caller setting `--agent-cube-accent` to any hue
/// gets a correctly lit cube instead of three unrelated colours"* — `oklab` for
/// the lighting mixes because it keeps perceived lightness linear, `srgb` for
/// the transparency mix because that one is compositing rather than shading.
class DsAgentCubeFaces {
  const DsAgentCubeFaces({
    required this.top,
    required this.left,
    required this.right,
    required this.stroke,
    this.dash,
  });

  final Color top;
  final Color left;
  final Color right;
  final Color stroke;

  /// [DsAgentCube.dash] on the ghost, null everywhere else.
  final List<double>? dash;

  /// `color-mix(in oklab, var(--agent-cube-accent) 55%, var(--agent-cube-top))`.
  static const double accentTopMix = 0.55;

  /// `color-mix(in oklab, … 80%, var(--agent-cube-accent-shade))`.
  static const double accentRightMix = 0.80;

  /// `color-mix(in oklab, … 45%, var(--agent-cube-stroke))`.
  static const double accentStrokeMix = 0.45;

  /// `color-mix(in srgb, X 45%, transparent)` — which is X at 45% of its own
  /// alpha, measured `color(srgb 0.101961 0.431373 0.956863 / 0.45)` on the
  /// live reference.
  static const double ghostAlpha = 0.45;

  /// `color-mix(in oklab, var(--agent-cube-accent) 70%, var(--agent-cube-ghost-ink))`.
  static const double ghostStrokeMix = 0.70;

  static DsAgentCubeFaces neutral(DsAgentCubeTokens t) => DsAgentCubeFaces(
        top: t.top,
        left: t.left,
        right: t.right,
        stroke: t.stroke,
      );

  static DsAgentCubeFaces error(DsAgentCubeTokens t) => DsAgentCubeFaces(
        top: t.errorTop,
        left: t.errorLeft,
        right: t.errorRight,
        stroke: t.errorStroke,
      );

  static DsAgentCubeFaces accent(DsAgentCubeTokens t, Color accent) =>
      DsAgentCubeFaces(
        top: DsOklab.mix(accent, t.top, accentTopMix),
        left: accent,
        right: DsOklab.mix(accent, t.accentShade, accentRightMix),
        stroke: DsOklab.mix(accent, t.stroke, accentStrokeMix),
      );

  /// *"The 'missing box' — an accent cube at 45%, dashed. Reads as a slot to
  /// fill."*
  static DsAgentCubeFaces ghost(DsAgentCubeTokens t, Color accent) {
    final DsAgentCubeFaces lit = DsAgentCubeFaces.accent(t, accent);
    return DsAgentCubeFaces(
      top: lit.top.withValues(alpha: lit.top.a * ghostAlpha),
      left: lit.left.withValues(alpha: lit.left.a * ghostAlpha),
      right: lit.right.withValues(alpha: lit.right.a * ghostAlpha),
      stroke: DsOklab.mix(accent, t.ghostInk, ghostStrokeMix),
      dash: DsAgentCube.dash,
    );
  }

  /// `faces(cube)` — red beats dashed beats accent beats neutral.
  static DsAgentCubeFaces forCube(
    DsAgentCubeSpec cube,
    DsAgentCubeTokens tokens,
    Color accent,
  ) {
    if (cube.red) return DsAgentCubeFaces.error(tokens);
    if (cube.dashed) return DsAgentCubeFaces.ghost(tokens, accent);
    if (cube.accent) return DsAgentCubeFaces.accent(tokens, accent);
    return DsAgentCubeFaces.neutral(tokens);
  }
}

/* ── C · the fourteen keyframes ──────────────────────────────────────────── */

/// `@keyframes agent-cube-*` — globals.css L3109–3177.
///
/// *"Easing is always var(--ease-in-out) except spin3d, which is linear — a
/// rotating cube that eases looks like it is struggling, same as a spinner."*
enum DsAgentCubeKeyframe {
  bob,
  rise,
  appear,
  drop,
  glide,
  blinkfade,
  blinkslow,
  lift,
  lift2,
  settle,
  pull,
  shake,
  bounce,

  /// The one keyframe no isometric scene names: the idle cube's three-axis
  /// rotation, run `linear`.
  spin3d,
}

/// The fourteen tables, as [Animatable]s over `0..1`.
///
/// Every travel below is a bare number rather than a token, on `keyframes.dart`'s
/// own precedent: a keyframe table is a transcript of a stylesheet block, and
/// the constraint is that the transcript lives in one place — which is this
/// class.
class DsAgentCubeKeyframes {
  const DsAgentCubeKeyframes._();

  /// `var(--ease-in-out)`, every table except [DsAgentCubeKeyframe.spin3d].
  static const Curve curve = DsCurves.inOut;

  /// `animation-fill-mode` is never declared on a cube, so every one of these
  /// reverts to the element's own resting style outside its active phase.
  static const DsKeyframeFill fill = DsKeyframeFill.none;

  /// `glide`'s travel — `translate(39px, 19.5px)`, which is exactly three
  /// isometric half-widths across and three half-heights down.
  static const Offset glideTravel = Offset(39, 19.5);

  static final Map<DsAgentCubeKeyframe, Animatable<Offset>?> _translate =
      <DsAgentCubeKeyframe, Animatable<Offset>?>{
    // 0%,100% { translateY(0) } 50% { translateY(-5px) }
    DsAgentCubeKeyframe.bob: _y(<(double, double)>[(0, 0), (50, -5), (100, 0)]),
    // 0%,55%,100% { 0 } 20%,35% { -11px }
    DsAgentCubeKeyframe.rise: _y(<(double, double)>[
      (0, 0),
      (20, -11),
      (35, -11),
      (55, 0),
      (100, 0),
    ]),
    // 0% { translateY(8px) } 10%,93% { translateY(0) } — and nothing after, so
    // the table holds 0 through the two opacity-only stops.
    DsAgentCubeKeyframe.appear: _y(<(double, double)>[(0, 8), (10, 0)]),
    // 0% { translateY(-24px) } 18% { translateY(0) }
    DsAgentCubeKeyframe.drop: _y(<(double, double)>[(0, -24), (18, 0)]),
    DsAgentCubeKeyframe.glide: DsKeyframes.offsets(
      <DsKeyframeStop<Offset>>[
        const DsKeyframeStop<Offset>(0, Offset.zero),
        const DsKeyframeStop<Offset>(100, glideTravel),
      ],
      curve: curve,
    ),
    DsAgentCubeKeyframe.blinkfade: null,
    DsAgentCubeKeyframe.blinkslow: null,
    // 0%,100% { 0 } 45%,60% { -6.5px }
    DsAgentCubeKeyframe.lift: _y(<(double, double)>[
      (0, 0),
      (45, -6.5),
      (60, -6.5),
      (100, 0),
    ]),
    DsAgentCubeKeyframe.lift2: _y(<(double, double)>[
      (0, 0),
      (45, -13),
      (60, -13),
      (100, 0),
    ]),
    DsAgentCubeKeyframe.settle:
        _y(<(double, double)>[(0, 0), (50, -3), (100, 0)]),
    // 0%,60%,100% { 0 } 25%,40% { -20px }
    DsAgentCubeKeyframe.pull: _y(<(double, double)>[
      (0, 0),
      (25, -20),
      (40, -20),
      (60, 0),
      (100, 0),
    ]),
    // 20% -2.5, 40% 2.5, 60% -2, 80% 2 — the one table that crosses zero.
    DsAgentCubeKeyframe.shake: _y(<(double, double)>[
      (0, 0),
      (20, -2.5),
      (40, 2.5),
      (60, -2),
      (80, 2),
      (100, 0),
    ]),
    DsAgentCubeKeyframe.bounce: _y(<(double, double)>[
      (0, 0),
      (35, -16),
      (55, 0),
      (70, -6),
      (82, 0),
      (100, 0),
    ]),
    DsAgentCubeKeyframe.spin3d: null,
  };

  static final Map<DsAgentCubeKeyframe, Animatable<double>?> _opacity =
      <DsAgentCubeKeyframe, Animatable<double>?>{
    // 0% 0 → 10% 1 → 93% 1 → 95% 0 → 100% 0. It ENDS at zero on purpose:
    // *"cubes arrive one by one and then hard-cut back, Game Boy logo style."*
    DsAgentCubeKeyframe.appear: _a(<(double, double)>[
      (0, 0),
      (10, 1),
      (93, 1),
      (95, 0),
      (100, 0),
    ]),
    DsAgentCubeKeyframe.drop: _a(<(double, double)>[
      (0, 0),
      (18, 1),
      (93, 1),
      (95, 0),
      (100, 0),
    ]),
    // 0%,100% { 0.15 } 50% { 0.95 }
    DsAgentCubeKeyframe.blinkfade: _a(<(double, double)>[
      (0, 0.15),
      (50, 0.95),
      (100, 0.15),
    ]),
    // 0%,100% { 1 } 50% { 0.25 }
    DsAgentCubeKeyframe.blinkslow: _a(<(double, double)>[
      (0, 1),
      (50, 0.25),
      (100, 1),
    ]),
  };

  /// The `translateY`-only tables, which is all of them but `glide`.
  static Animatable<Offset> _y(List<(double, double)> stops) =>
      DsKeyframes.offsets(
        <DsKeyframeStop<Offset>>[
          for (final (double percent, double y) in stops)
            DsKeyframeStop<Offset>(percent, Offset(0, y)),
        ],
        curve: curve,
      );

  static Animatable<double> _a(List<(double, double)> stops) =>
      DsKeyframes.doubles(
        <DsKeyframeStop<double>>[
          for (final (double percent, double v) in stops)
            DsKeyframeStop<double>(percent, v),
        ],
        curve: curve,
      );

  /// The translation [name] is at fractional progress [t], or [Offset.zero]
  /// where the table declares none.
  static Offset translateAt(DsAgentCubeKeyframe name, double t) =>
      _translate[name]?.transform(t) ?? Offset.zero;

  /// The opacity [name] is at fractional progress [t], or 1 where the table
  /// declares none.
  static double opacityAt(DsAgentCubeKeyframe name, double t) =>
      _opacity[name]?.transform(t) ?? 1;
}

/* ── D · one cube, and its motion ────────────────────────────────────────── */

/// `anim(name, seconds, timing, options)` — one `animation` shorthand.
///
/// Scenes declare motion through the reference's two helpers rather than
/// writing the shorthand, *"so the speed multiplier is applied in exactly one
/// place"*; both are folded into this type.
class DsAgentCubeMotion {
  const DsAgentCubeMotion(
    this.name,
    this.seconds, {
    this.delay = 0,
    this.alternate = false,
    this.startsHidden = false,
  });

  /// `appear(seconds, delay, timing)` — `agent-cube-appear` plus the inline
  /// `opacity: 0` that is its resting style during the delay.
  const DsAgentCubeMotion.appear(double seconds, double delay)
      : this(
          DsAgentCubeKeyframe.appear,
          seconds,
          delay: delay,
          startsHidden: true,
        );

  /// `drop(seconds, delay, timing)`.
  const DsAgentCubeMotion.drop(double seconds, double delay)
      : this(
          DsAgentCubeKeyframe.drop,
          seconds,
          delay: delay,
          startsHidden: true,
        );

  final DsAgentCubeKeyframe name;

  /// `animation-duration`, already divided by the avatar's `speed`.
  final double seconds;

  /// `animation-delay`, already divided by `speed`.
  final double delay;

  /// `animation-direction: alternate` — the two `glide`s and nothing else.
  final bool alternate;

  /// The element's own `opacity: 0`, which is what shows while the delay runs
  /// and `animation-fill-mode` is `none`.
  final bool startsHidden;

  /// `(seconds / speed).toFixed(2)` — the reference formats the shorthand to
  /// two decimals and the browser parses that string, so the rounding is
  /// observable and is reproduced rather than divided away.
  DsAgentCubeMotion dividedBy(double speed) {
    if (speed == 1) return this;
    double round2(double v) => (v * 100).roundToDouble() / 100;
    return DsAgentCubeMotion(
      name,
      round2(seconds / speed),
      delay: round2(delay / speed),
      alternate: alternate,
      startsHidden: startsHidden,
    );
  }

  /// Where this animation stands after [elapsed] seconds of wall clock.
  ///
  /// Before the delay elapses the animation has not started and, with no fill
  /// mode, the element shows its own style: [startsHidden] decides whether that
  /// is invisible or plain.
  ({double opacity, Offset translate}) sampleAt(double elapsed) {
    if (elapsed < delay || seconds <= 0) {
      return (
        opacity: startsHidden ? 0 : 1,
        translate: Offset.zero,
      );
    }
    final double cycles = (elapsed - delay) / seconds;
    final int whole = cycles.floor();
    double t = cycles - whole;
    if (alternate && whole.isOdd) t = 1 - t;
    return (
      opacity: DsAgentCubeKeyframes.opacityAt(name, t),
      translate: DsAgentCubeKeyframes.translateAt(name, t),
    );
  }
}

/// `type Cube` — one entry in a scene recipe.
class DsAgentCubeSpec {
  const DsAgentCubeSpec({
    required this.x,
    required this.y,
    this.z = 0,
    this.accent = false,
    this.red = false,
    this.dashed = false,
    this.boost = 0,
    this.motion,
    this.outer,
  });

  final double x;
  final double y;
  final double z;

  final bool accent;

  /// *"The only scene that leaves the accent"* — `error`, and nothing else.
  final bool red;

  /// Draws the ghost palette and the dash.
  final bool dashed;

  /// *"Forces this cube to the front of the painter's sort. Anything that
  /// floats above or moves across the scene needs it, or it disappears behind
  /// the geometry it is supposed to be travelling over."*
  final double boost;

  /// Animation applied to the cube itself.
  final DsAgentCubeMotion? motion;

  /// *"A second wrapper, for scenes that compose two motions (glide + bob)."*
  final DsAgentCubeMotion? outer;

  DsAgentCubeSpec dividedBy(double speed) => DsAgentCubeSpec(
        x: x,
        y: y,
        z: z,
        accent: accent,
        red: red,
        dashed: dashed,
        boost: boost,
        motion: motion?.dividedBy(speed),
        outer: outer?.dividedBy(speed),
      );
}

/// `type Scene = { cubes: Cube[]; width: number }`.
class DsAgentCubeScene {
  const DsAgentCubeScene({required this.cubes, required this.width});

  final List<DsAgentCubeSpec> cubes;

  /// The scene's own rendered width in CSS pixels **before** the size scale —
  /// `scene.width × scale` is what the `<svg>` carries.
  final double width;
}

/* ── E · the nineteen recipes ────────────────────────────────────────────── */

/// `const W = 168` — *"Default scene width. Overridden per scene where the
/// geometry is wider or narrower."*
const double _w = 168;

/// `RING` — *"The eight perimeter cells of a 3×3, in ring order. Used by two
/// scenes."*
const List<(double, double)> _ring = <(double, double)>[
  (0, 0),
  (1, 0),
  (2, 0),
  (2, 1),
  (2, 2),
  (1, 2),
  (0, 2),
  (0, 1),
];

/// *"Forces this cube to the front of the painter's sort"* — every recipe that
/// floats a cube writes the same 100.
const double _boost = 100;

/// `sceneFor(state, timing)` — the recipe for [state], with [speed] already
/// divided through every duration and delay.
///
/// [DsAgentState.idle] has no entry, and the reference says why: *"it is a real
/// CSS 3D cube rather than an isometric projection, so it is drawn directly in
/// `CubeAvatar`."* Asking for it here is a programming error.
DsAgentCubeScene dsAgentCubeScene(DsAgentState state, {double speed = 1}) {
  assert(
    state != DsAgentState.idle,
    'idle is not an isometric scene — DsCubeAvatar draws it directly',
  );
  final DsAgentCubeScene scene = _scenes[state]!();
  if (speed == 1) return scene;
  return DsAgentCubeScene(
    cubes: <DsAgentCubeSpec>[
      for (final DsAgentCubeSpec cube in scene.cubes) cube.dividedBy(speed),
    ],
    width: scene.width,
  );
}

final Map<DsAgentState, DsAgentCubeScene Function()> _scenes =
    <DsAgentState, DsAgentCubeScene Function()>{
  /// *"Five cubes waiting their turn, bobbing in sequence."*
  DsAgentState.queued: () => DsAgentCubeScene(
        width: 190,
        cubes: <DsAgentCubeSpec>[
          for (int x = 0; x < 5; x += 1)
            DsAgentCubeSpec(
              x: x.toDouble(),
              y: 0,
              accent: x == 2,
              motion: DsAgentCubeMotion(
                DsAgentCubeKeyframe.bob,
                2.2,
                delay: x * 0.22,
              ),
            ),
        ],
      ),

  /// *"A staircase assembling itself — each column one step taller than the
  /// last."*
  DsAgentState.planning: () {
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[];
    for (int x = 0; x < 4; x += 1) {
      for (int y = 0; y < 2; y += 1) {
        for (int z = 0; z <= x; z += 1) {
          cubes.add(DsAgentCubeSpec(
            x: x.toDouble(),
            y: y.toDouble(),
            z: z.toDouble(),
            accent: z == x,
            motion: DsAgentCubeMotion.appear(3.6, x * 0.35 + z * 0.12),
          ));
        }
      }
    }
    return DsAgentCubeScene(width: 160, cubes: cubes);
  },

  /// *"One cube pulled up out of the middle of a stack, over and over."*
  DsAgentState.retrieving: () {
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[];
    for (int x = 0; x < 3; x += 1) {
      for (int y = 0; y < 3; y += 1) {
        cubes.add(x == 1 && y == 1
            ? DsAgentCubeSpec(
                x: x.toDouble(),
                y: y.toDouble(),
                boost: _boost,
                accent: true,
                motion:
                    const DsAgentCubeMotion(DsAgentCubeKeyframe.pull, 2.6),
              )
            : DsAgentCubeSpec(x: x.toDouble(), y: y.toDouble()));
      }
    }
    return DsAgentCubeScene(width: _w, cubes: cubes);
  },

  /// *"Cubes falling onto a platform, one after another."*
  DsAgentState.ingesting: () {
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[];
    for (int x = 0; x < 2; x += 1) {
      for (int y = 0; y < 2; y += 1) {
        cubes.add(DsAgentCubeSpec(x: x.toDouble(), y: y.toDouble()));
        cubes.add(DsAgentCubeSpec(
          x: x.toDouble(),
          y: y.toDouble(),
          z: 1,
          accent: true,
          motion: DsAgentCubeMotion.drop(2.8, (x * 2 + y) * 0.4),
        ));
      }
    }
    return DsAgentCubeScene(width: 120, cubes: cubes);
  },

  /// *"A diagonal ripple across a 4×4 — deliberately no opacity change."*
  DsAgentState.running: () {
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[];
    for (int x = 0; x < 4; x += 1) {
      for (int y = 0; y < 4; y += 1) {
        cubes.add(DsAgentCubeSpec(
          x: x.toDouble(),
          y: y.toDouble(),
          accent: x + y == 3,
          motion: DsAgentCubeMotion(
            DsAgentCubeKeyframe.settle,
            1.6,
            delay: (x + y) * 0.15,
          ),
        ));
      }
    }
    return DsAgentCubeScene(width: _w, cubes: cubes);
  },

  /// *"Two islands, and a courier gliding from one to the other."*
  DsAgentState.delegating: () {
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[];
    for (final int base in <int>[0, 4]) {
      for (int x = base; x < base + 2; x += 1) {
        for (int y = 0; y < 2; y += 1) {
          cubes.add(DsAgentCubeSpec(
            x: x.toDouble(),
            y: y.toDouble(),
            motion: DsAgentCubeMotion(
              DsAgentCubeKeyframe.settle,
              3,
              delay: base != 0 ? 1.5 : 0,
            ),
          ));
        }
      }
    }
    // *"No bob on the courier: it travels in a straight line, which is what
    // makes it read as carrying something rather than wandering."*
    cubes.add(const DsAgentCubeSpec(
      x: 1,
      y: 0,
      z: 1,
      boost: _boost,
      accent: true,
      outer: DsAgentCubeMotion(
        DsAgentCubeKeyframe.glide,
        2.2,
        alternate: true,
      ),
    ));
    return DsAgentCubeScene(width: 190, cubes: cubes);
  },

  /// *"A slot at the near corner, blinking to be filled."*
  DsAgentState.awaitingApproval: () {
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[];
    for (int x = 0; x < 3; x += 1) {
      for (int y = 0; y < 3; y += 1) {
        cubes.add(x == 2 && y == 2
            ? DsAgentCubeSpec(
                x: x.toDouble(),
                y: y.toDouble(),
                boost: _boost,
                dashed: true,
                motion: const DsAgentCubeMotion(
                  DsAgentCubeKeyframe.blinkslow,
                  2.2,
                ),
              )
            : DsAgentCubeSpec(x: x.toDouble(), y: y.toDouble()));
      }
    }
    return DsAgentCubeScene(width: _w, cubes: cubes);
  },

  /// *"A pulse chasing the perimeter, checking each cell in turn."*
  DsAgentState.validating: () {
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[
      const DsAgentCubeSpec(x: 1, y: 1),
    ];
    for (int i = 0; i < _ring.length; i += 1) {
      final (double x, double y) = _ring[i];
      cubes.add(DsAgentCubeSpec(
        x: x,
        y: y,
        accent: true,
        motion: DsAgentCubeMotion(
          DsAgentCubeKeyframe.blinkfade,
          2,
          delay: i * 0.25,
        ),
      ));
    }
    return DsAgentCubeScene(width: _w, cubes: cubes);
  },

  /// *"One cube bouncing off the stack and landing again."*
  DsAgentState.retrying: () {
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[];
    for (int x = 0; x < 2; x += 1) {
      for (int y = 0; y < 2; y += 1) {
        cubes.add(DsAgentCubeSpec(x: x.toDouble(), y: y.toDouble()));
      }
    }
    cubes.add(const DsAgentCubeSpec(
      x: 0,
      y: 0,
      z: 1,
      boost: _boost,
      accent: true,
      motion: DsAgentCubeMotion(DsAgentCubeKeyframe.bounce, 2),
    ));
    return DsAgentCubeScene(width: 120, cubes: cubes);
  },

  /// *"The centre cube shaking, in red. The only scene that leaves the
  /// accent."*
  DsAgentState.error: () {
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[];
    for (int x = 0; x < 3; x += 1) {
      for (int y = 0; y < 3; y += 1) {
        cubes.add(x == 1 && y == 1
            ? DsAgentCubeSpec(
                x: x.toDouble(),
                y: y.toDouble(),
                red: true,
                motion:
                    const DsAgentCubeMotion(DsAgentCubeKeyframe.shake, 1.4),
              )
            : DsAgentCubeSpec(x: x.toDouble(), y: y.toDouble()));
      }
    }
    return DsAgentCubeScene(width: _w, cubes: cubes);
  },

  /// *"The perimeter assembling first, then the conclusion in the middle."*
  DsAgentState.summarizing: () {
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[];
    for (int i = 0; i < _ring.length; i += 1) {
      final (double x, double y) = _ring[i];
      cubes.add(DsAgentCubeSpec(
        x: x,
        y: y,
        motion: DsAgentCubeMotion.appear(4, i * 0.26),
      ));
    }
    cubes.add(const DsAgentCubeSpec(
      x: 1,
      y: 1,
      accent: true,
      motion: DsAgentCubeMotion.appear(4, 2.1),
    ));
    return DsAgentCubeScene(width: _w, cubes: cubes);
  },

  /// *"A diagonal wave of consideration across a 3×3."*
  DsAgentState.thinking: () {
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[];
    for (int x = 0; x < 3; x += 1) {
      for (int y = 0; y < 3; y += 1) {
        cubes.add(DsAgentCubeSpec(
          x: x.toDouble(),
          y: y.toDouble(),
          accent: x == 1 && y == 1,
          motion: DsAgentCubeMotion(
            DsAgentCubeKeyframe.bob,
            1.8,
            delay: 0.16 * (x + y),
          ),
        ));
      }
    }
    return DsAgentCubeScene(width: _w, cubes: cubes);
  },

  /// *"Scattered cells rising in sequence — work happening in several
  /// places."*
  DsAgentState.processing: () {
    const Map<String, double> raised = <String, double>{
      '0,1': 0,
      '1,3': 0.6,
      '2,0': 1.2,
      '3,2': 1.8,
      '1,1': 2.4,
    };
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[];
    for (int x = 0; x < 4; x += 1) {
      for (int y = 0; y < 4; y += 1) {
        final double? delay = raised['$x,$y'];
        cubes.add(DsAgentCubeSpec(
          x: x.toDouble(),
          y: y.toDouble(),
          accent: delay != null,
          motion: delay == null
              ? null
              : DsAgentCubeMotion(
                  DsAgentCubeKeyframe.rise,
                  3,
                  delay: delay,
                ),
        ));
      }
    }
    return DsAgentCubeScene(width: _w, cubes: cubes);
  },

  /// *"Two blocks, and a bridge being built between them."*
  DsAgentState.callingTools: () {
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[];
    for (final int base in <int>[0, 4]) {
      for (int x = base; x < base + 2; x += 1) {
        for (int y = 0; y < 2; y += 1) {
          cubes.add(DsAgentCubeSpec(
            x: x.toDouble(),
            y: y.toDouble(),
            motion:
                const DsAgentCubeMotion(DsAgentCubeKeyframe.settle, 2.4),
          ));
        }
      }
    }
    for (final (double x, double y, double delay) in <(double, double, double)>[
      (2, 0, 0),
      (2, 1, 0.3),
      (3, 0, 0.6),
      (3, 1, 0.9),
    ]) {
      cubes.add(DsAgentCubeSpec(
        x: x,
        y: y,
        accent: true,
        motion: DsAgentCubeMotion.appear(3, delay),
      ));
    }
    return DsAgentCubeScene(width: 196, cubes: cubes);
  },

  /// *"A scanner hunting over a platform with holes in it."*
  DsAgentState.searching: () {
    const Map<String, String> holes = <String, String>{
      '2,1': 'dashed',
      '1,3': 'gone',
      '3,0': 'gone',
    };
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[];
    for (int x = 0; x < 4; x += 1) {
      for (int y = 0; y < 4; y += 1) {
        final String? hole = holes['$x,$y'];
        if (hole == 'gone') continue;
        cubes.add(DsAgentCubeSpec(
          x: x.toDouble(),
          y: y.toDouble(),
          dashed: hole == 'dashed',
        ));
      }
    }
    // *"Two motions composed: the outer glides across, the inner bobs in
    // place."*
    cubes.add(const DsAgentCubeSpec(
      x: 0,
      y: 1,
      z: 1.5,
      boost: _boost,
      accent: true,
      outer: DsAgentCubeMotion(
        DsAgentCubeKeyframe.glide,
        2.6,
        alternate: true,
      ),
      motion: DsAgentCubeMotion(DsAgentCubeKeyframe.bob, 1.3),
    ));
    return DsAgentCubeScene(width: _w, cubes: cubes);
  },

  /// *"Three layers lifting apart, like pages coming off a stack."*
  DsAgentState.reading: () {
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[];
    for (int z = 0; z < 3; z += 1) {
      for (int x = 0; x < 3; x += 1) {
        for (int y = 0; y < 2; y += 1) {
          cubes.add(DsAgentCubeSpec(
            x: x.toDouble(),
            y: y.toDouble(),
            z: z.toDouble(),
            accent: z == 2,
            // *"Same duration and phase on both lifted layers, so they travel
            // together and never intersect."*
            motion: z == 0
                ? null
                : DsAgentCubeMotion(
                    z == 1
                        ? DsAgentCubeKeyframe.lift
                        : DsAgentCubeKeyframe.lift2,
                    2.2,
                  ),
          ));
        }
      }
    }
    return DsAgentCubeScene(width: 150, cubes: cubes);
  },

  /// *"Rows surfacing from the back — older context coming forward."*
  DsAgentState.recalling: () {
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[];
    for (int row = 0; row < 3; row += 1) {
      for (int x = 0; x < 4; x += 1) {
        cubes.add(DsAgentCubeSpec(
          x: x.toDouble(),
          y: 2 - row.toDouble(),
          accent: row == 0,
          motion: row == 2
              ? null
              : DsAgentCubeMotion.appear(3.2, (1 - row) * 0.5 + x * 0.12),
        ));
      }
    }
    return DsAgentCubeScene(width: _w, cubes: cubes);
  },

  /// *"A grid filling in cube by cube, left to right, like typing."*
  DsAgentState.writing: () {
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[];
    for (int y = 0; y < 3; y += 1) {
      for (int x = 0; x < 4; x += 1) {
        cubes.add(DsAgentCubeSpec(
          x: x.toDouble(),
          y: y.toDouble(),
          accent: y == 2 && x == 3,
          motion: DsAgentCubeMotion.appear(3.4, (y * 4 + x) * 0.13),
        ));
      }
    }
    return DsAgentCubeScene(width: _w, cubes: cubes);
  },

  /// *"A solid, finished block, breathing in phase."*
  DsAgentState.done: () {
    final List<DsAgentCubeSpec> cubes = <DsAgentCubeSpec>[];
    for (int x = 0; x < 2; x += 1) {
      for (int y = 0; y < 2; y += 1) {
        for (int z = 0; z < 2; z += 1) {
          cubes.add(DsAgentCubeSpec(
            x: x.toDouble(),
            y: y.toDouble(),
            z: z.toDouble(),
            accent: z == 1,
            motion:
                const DsAgentCubeMotion(DsAgentCubeKeyframe.settle, 3.2),
          ));
        }
      }
    }
    return DsAgentCubeScene(width: 110, cubes: cubes);
  },
};

/* ── F · the scene widget ────────────────────────────────────────────────── */

/// `CubeScene` — one `<svg>` of one scene, at one instant.
///
/// The widget's own box is `width × width · viewBoxHeight / viewBoxWidth`,
/// which is what an `<svg width={n}>` with no height resolves to. Its painting
/// is **not** clipped to that box: [CustomPaint] does not clip, and this file
/// depends on it (see the library note).
class DsCubeScene extends StatelessWidget {
  const DsCubeScene({
    super.key,
    required this.scene,
    required this.width,
    required this.accent,
    this.elapsed = 0,
    this.frozen = false,
  });

  final DsAgentCubeScene scene;

  /// The rendered width, `scene.width × scale`.
  final double width;

  /// The resolved `--agent-cube-accent`.
  final Color accent;

  /// Seconds of wall clock since the scene mounted.
  final double elapsed;

  /// globals.css L3195–3215 — *"no animation, everything visible, no
  /// transforms."*
  final bool frozen;

  @override
  Widget build(BuildContext context) {
    final Rect viewBox = DsAgentCube.viewBoxOf(scene.cubes);
    final double scale = width / viewBox.width;

    return SizedBox(
      width: width,
      height: viewBox.height * scale,
      child: CustomPaint(
        painter: _CubeScenePainter(
          cubes: DsAgentCube.sorted(scene.cubes),
          viewBox: viewBox,
          tokens: DsTheme.of(context).cube,
          accent: accent,
          elapsed: elapsed,
          frozen: frozen,
        ),
      ),
    );
  }
}

class _CubeScenePainter extends CustomPainter {
  _CubeScenePainter({
    required this.cubes,
    required this.viewBox,
    required this.tokens,
    required this.accent,
    required this.elapsed,
    required this.frozen,
  });

  final List<DsAgentCubeSpec> cubes;
  final Rect viewBox;
  final DsAgentCubeTokens tokens;
  final Color accent;
  final double elapsed;
  final bool frozen;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final double scale = size.width / viewBox.width;

    canvas.save();
    canvas.scale(scale);
    canvas.translate(-viewBox.left, -viewBox.top);

    for (final DsAgentCubeSpec cube in cubes) {
      _paintCube(canvas, cube, scale);
    }

    canvas.restore();
  }

  void _paintCube(Canvas canvas, DsAgentCubeSpec cube, double scale) {
    // Two nested <g>s: the outer carries `glide`, the inner the cube's own
    // motion. Both are transforms on the same subtree, so they add.
    final ({double opacity, Offset translate}) outer = frozen
        ? (opacity: 1.0, translate: Offset.zero)
        : cube.outer?.sampleAt(elapsed) ??
            (opacity: 1.0, translate: Offset.zero);
    final ({double opacity, Offset translate}) inner = frozen
        ? (opacity: 1.0, translate: Offset.zero)
        : cube.motion?.sampleAt(elapsed) ??
            (opacity: 1.0, translate: Offset.zero);

    final double opacity = outer.opacity * inner.opacity;
    if (opacity <= 0) return;

    final Offset origin =
        DsAgentCube.iso(cube.x, cube.y, cube.z) + outer.translate +
            inner.translate;

    final DsAgentCubeFaces faces =
        DsAgentCubeFaces.forCube(cube, tokens, accent);

    canvas.save();
    canvas.translate(origin.dx, origin.dy);

    // A CSS `opacity` on a <g> composites the group as one object, so a
    // translucent ghost's overlapping faces must not double-darken each other.
    final bool layered = opacity < 1;
    if (layered) {
      canvas.saveLayer(
        // Generous: `pull` and `bounce` travel well outside the cube's own
        // 26×26 box, and the bounds only have to contain what is drawn.
        Rect.fromCenter(
          center: Offset.zero,
          width: DsAgentCube.halfWidth * 4,
          height: DsAgentCube.cubeHeight * 6,
        ),
        Paint()..color = dsTransparent.withValues(alpha: opacity),
      );
    }

    // *"Draw order within a cube is fixed: left, right, then top. The top face
    // has to land last or the two side faces overdraw its lower edges."*
    _paintFace(canvas, DsAgentCube.leftFace, faces.left, faces, scale);
    _paintFace(canvas, DsAgentCube.rightFace, faces.right, faces, scale);
    _paintFace(canvas, DsAgentCube.topFace, faces.top, faces, scale);

    if (layered) canvas.restore();
    canvas.restore();
  }

  void _paintFace(
    Canvas canvas,
    List<Offset> points,
    Color fill,
    DsAgentCubeFaces faces,
    double scale,
  ) {
    final Path path = Path()..addPolygon(points, true);
    canvas.drawPath(path, Paint()..color = fill);

    final Paint stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = DsAgentCube.strokeWidth
      ..strokeJoin = StrokeJoin.round
      ..color = faces.stroke;

    final List<double>? dash = faces.dash;
    canvas.drawPath(dash == null ? path : _dashed(path, dash), stroke);
  }

  /// `stroke-dasharray: 3 2.5`, walked with [ui.PathMetric].
  ///
  /// The path is walked rather than the stroke being blurred or combined — the
  /// standing painter rule. A dash pattern is a geometry operation and stays
  /// one.
  static Path _dashed(Path source, List<double> pattern) {
    final Path out = Path();
    for (final ui.PathMetric metric in source.computeMetrics()) {
      double distance = 0;
      int index = 0;
      while (distance < metric.length) {
        final double step = pattern[index % pattern.length];
        final double end = math.min(distance + step, metric.length);
        if (index.isEven) {
          out.addPath(metric.extractPath(distance, end), Offset.zero);
        }
        distance = end;
        index += 1;
      }
    }
    return out;
  }

  @override
  bool shouldRepaint(_CubeScenePainter old) =>
      old.elapsed != elapsed ||
      old.frozen != frozen ||
      old.accent != accent ||
      old.tokens != tokens ||
      !identical(old.cubes, cubes);
}

/* ── G · idle, a real cube ───────────────────────────────────────────────── */

/// `IdleCube` — the one state that is not a projection.
///
/// *"Six faces on a `preserve-3d` parent, rotating on X, Y and Z at once.
/// Linear, and slow: this is the resting state, and anything faster reads as
/// activity."*
///
/// CSS `perspective: P` is `Matrix4..setEntry(3, 2, -1/P)`, and `preserve-3d`
/// means each face's own transform composes with the parent's rather than
/// flattening — so a face's world point is `Rparent · Mface · v` and its screen
/// point is that divided through the perspective's `w`. The faces are painted
/// far-to-near by projected depth, which is what a browser's `preserve-3d`
/// sort does, and back-face culling is deliberately absent because
/// `backface-visibility` defaults to `visible`.
class _IdleCube extends StatelessWidget {
  const _IdleCube({
    required this.scale,
    required this.accent,
    required this.motion,
    required this.elapsed,
    required this.frozen,
  });

  final double scale;
  final Color accent;
  final DsAgentCubeMotion motion;
  final double elapsed;
  final bool frozen;

  double get face => DsAgentCube.idleFace(scale);

  @override
  Widget build(BuildContext context) {
    final double size = face;
    // `agent-cube-spin3d` is linear and runs a full turn on all three axes.
    final double turns = frozen || motion.seconds <= 0
        ? 0
        : (elapsed / motion.seconds) % 1;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _IdleCubePainter(
          face: size,
          perspective: DsAgentCube.idlePerspective(scale),
          radians: turns * 2 * math.pi,
          tokens: DsTheme.of(context).cube,
          accent: accent,
        ),
      ),
    );
  }
}

class _IdleCubePainter extends CustomPainter {
  _IdleCubePainter({
    required this.face,
    required this.perspective,
    required this.radians,
    required this.tokens,
    required this.accent,
  });

  final double face;
  final double perspective;
  final double radians;
  final DsAgentCubeTokens tokens;
  final Color accent;

  /// `border: 1px` on every face, `box-sizing: border-box`.
  static const double borderWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final double half = face / 2;
    final Offset centre = size.center(Offset.zero);

    final DsAgentCubeFaces lit = DsAgentCubeFaces.accent(tokens, accent);

    // The six, in the reference's own declaration order.
    final List<(Color, Matrix4)> faces = <(Color, Matrix4)>[
      (lit.top, Matrix4.identity()..rotateX(math.pi / 2)),
      (tokens.back, Matrix4.identity()..rotateX(-math.pi / 2)),
      (accent, Matrix4.identity()),
      (tokens.left, Matrix4.identity()..rotateY(math.pi)),
      (lit.right, Matrix4.identity()..rotateY(math.pi / 2)),
      (tokens.right, Matrix4.identity()..rotateY(-math.pi / 2)),
    ];

    // `rotateX(a) rotateY(a) rotateZ(a)`, in that order.
    final Matrix4 parent = Matrix4.identity()
      ..rotateX(radians)
      ..rotateY(radians)
      ..rotateZ(radians);

    final List<(double, Color, List<Offset>)> projected =
        <(double, Color, List<Offset>)>[];

    for (final (Color fill, Matrix4 local) in faces) {
      // `translateZ(half)` — the face pushed out to the cube's surface.
      final Matrix4 model = local.clone()..translateByDouble(0, 0, half, 1);
      final Matrix4 world = parent * model as Matrix4;

      // The four corners as one packed triple array, so the transform runs
      // through [Matrix4] itself rather than through a vector type this
      // package does not depend on.
      final Float64List points = Float64List.fromList(<double>[
        -half, -half, 0, //
        half, -half, 0, //
        half, half, 0, //
        -half, half, 0, //
      ]);
      world.applyToVector3Array(points);

      double depth = 0;
      final List<Offset> corners = <Offset>[];
      for (int i = 0; i < 4; i += 1) {
        final double x = points[i * 3];
        final double y = points[i * 3 + 1];
        final double z = points[i * 3 + 2];
        depth += z;
        // `perspective: P` is `m[3][2] = -1/P`, so the divisor is `1 − z/P`.
        final double w = 1 - z / perspective;
        corners.add(centre + Offset(x / w, y / w));
      }
      projected.add((depth / 4, fill, corners));
    }

    // Painter's algorithm: farthest (most negative z) first.
    projected.sort((
      (double, Color, List<Offset>) a,
      (double, Color, List<Offset>) b,
    ) =>
        a.$1.compareTo(b.$1));

    for (final (double _, Color fill, List<Offset> corners) in projected) {
      final Path quad = Path()..addPolygon(corners, true);
      canvas.save();
      // `box-sizing: border-box` — the 1px border is paid for out of the face,
      // so the stroke is clipped to the quad and drawn at twice the width,
      // which leaves exactly one pixel INSIDE the edge.
      canvas.clipPath(quad);
      canvas.drawPath(quad, Paint()..color = fill);
      canvas.drawPath(
        quad,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth * 2
          ..color = tokens.stroke,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_IdleCubePainter old) =>
      old.radians != radians ||
      old.face != face ||
      old.perspective != perspective ||
      old.accent != accent ||
      old.tokens != tokens;
}

/* ── H · the avatar ──────────────────────────────────────────────────────── */

/// `AvatarSize` — *"Rendered width of the scene box. Scenes size themselves
/// within it."*
///
/// The page's own captions name the four: 32px *"inline, beside a chip"*, 48px
/// *"launcher, console header"*, 80px *"welcome card"*, 128px *"empty state,
/// hero"*.
///
/// Named `DsAgentAvatarSize` rather than `DsAvatarSize` because the base
/// group's `Avatar` — a different component in a different family — already
/// holds that name in this package's one flat namespace. The reference keeps
/// them apart by folder (`components/agent/avatar/types.ts` against
/// `components/ui/avatar.tsx`); a barrel cannot.
enum DsAgentAvatarSize {
  /// `size-8`, `scale: 0.19`.
  sm(8, 0.19),

  /// `size-12`, `scale: 0.29`.
  md(12, 0.29),

  /// `size-20`, `scale: 0.48`.
  lg(20, 0.48),

  /// `size-32`, `scale: 0.78`.
  xl(32, 0.78);

  const DsAgentAvatarSize(this._box, this.scale);

  final int _box;

  /// The multiplier the scene's own width is rendered at.
  final double scale;

  /// The square the avatar occupies.
  double get box => ds(_box);
}

/// `CubeAvatar` — *"The default face: twenty isometric cube scenes."*
///
/// *"This is one implementation of `AvatarRenderer`, not a fixture. The console
/// takes the renderer as a prop and defaults to this one; swapping in different
/// artwork is a prop, not a fork."*
///
/// Two things are handled here rather than in the scenes, both quoted from
/// `cube-avatar.tsx`:
///
/// * **The cross-fade.** *"Changing state replaces the entire SVG, and a hard
///   swap between two busy scenes reads as a glitch. The outgoing scene is held
///   for the length of one fade while the incoming one fades over it."*
/// * **Idle.** *"It is the only state that is not an isometric projection…
///   It gets its own branch because it genuinely is a different object."*
class DsCubeAvatar extends StatefulWidget {
  const DsCubeAvatar({
    super.key,
    this.state = DsAgentState.idle,
    this.size = DsAgentAvatarSize.md,
    this.accent,
    this.speed = 1,
  });

  /// *"The only required one — which of the twenty to draw."* Defaults to
  /// [DsAgentState.idle], as the reference's own signature does.
  final DsAgentState state;

  /// *"The console needs it at three scales; a renderer may ignore this."*
  final DsAgentAvatarSize size;

  /// *"The brand hook, so one avatar set serves several products."*
  ///
  /// `accent = "var(--agent)"` in the reference; null here resolves to the same
  /// token, which is what makes the avatar follow a retheme.
  final Color? accent;

  /// *"A global multiplier, for tuning the whole set at once."* Every duration
  /// in the set divides by it.
  final double speed;

  /// `const CROSSFADE_MS = 150` — *"Matches --duration-fast. The handoff asks
  /// for 150–200ms between states."*
  static Duration get crossfade => DsDurations.fast;

  /// `agent-cube-spin3d 9s linear infinite` — idle's own clock, and the one
  /// duration in the family that is not a scene recipe's.
  static const DsAgentCubeMotion spin =
      DsAgentCubeMotion(DsAgentCubeKeyframe.spin3d, 9);

  @override
  State<DsCubeAvatar> createState() => _DsCubeAvatarState();
}

class _DsCubeAvatarState extends State<DsCubeAvatar>
    with TickerProviderStateMixin {
  /// A bare [Ticker] rather than an [AnimationController], for the reason
  /// `DsSheenAction` states: a scene runs up to three periods and twenty
  /// delays against one clock, and what that clock counts is elapsed time.
  late final Ticker _clock = createTicker(_onTick);

  /// The incoming scene's `agent-cube-scene-in 150ms var(--ease-out) both`.
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: DsCubeAvatar.crossfade,
  );

  double _elapsed = 0;
  bool _frozen = false;

  /// The state being faded out, or null when nothing is transitioning.
  DsAgentState? _outgoing;

  /// Seconds of clock the outgoing scene had already run, so it does not
  /// restart from zero underneath the fade.
  double _outgoingElapsed = 0;

  @override
  void initState() {
    super.initState();
    _fade.value = 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool frozen =
        dsAnimationDuration(context, DsCubeAvatar.crossfade) == Duration.zero;
    if (frozen == _frozen && (_clock.isActive || frozen)) return;
    _frozen = frozen;
    if (frozen) {
      _clock.stop();
      _elapsed = 0;
    } else if (!_clock.isActive) {
      _clock.start();
    }
  }

  @override
  void didUpdateWidget(DsCubeAvatar old) {
    super.didUpdateWidget(old);
    if (old.state == widget.state) return;
    setState(() {
      _outgoing = old.state;
      _outgoingElapsed = _elapsed;
    });
    if (_frozen) {
      _fade.value = 1;
      _dropOutgoing();
      return;
    }
    _fade
      ..duration = DsCubeAvatar.crossfade
      ..forward(from: 0).whenCompleteOrCancel(_dropOutgoing);
  }

  void _dropOutgoing() {
    if (!mounted || _outgoing == null) return;
    setState(() => _outgoing = null);
  }

  void _onTick(Duration elapsed) {
    setState(() => _elapsed = elapsed.inMicroseconds / 1e6);
  }

  @override
  void dispose() {
    _clock.dispose();
    _fade.dispose();
    super.dispose();
  }

  /// `absolute inset-0 grid place-items-center` on a scene box that is
  /// **wider than the avatar**.
  ///
  /// `lg` is an 80px box holding an 80.64px `thinking` scene, and `xl` a 128px
  /// box holding a 152.88px `calling_tools` one. CSS lays the child out at its
  /// own width and lets it overflow; a Flutter [Stack] hands its children the
  /// parent's constraints as a maximum, which would silently shrink every
  /// scene to the box. [OverflowBox] is the difference.
  Widget _loose(Widget child) => OverflowBox(
        minWidth: 0,
        maxWidth: double.infinity,
        minHeight: 0,
        maxHeight: double.infinity,
        child: child,
      );

  Widget _scene(DsAgentState state, Color accent, double elapsed) {
    if (state == DsAgentState.idle) {
      return _IdleCube(
        scale: widget.size.scale,
        accent: accent,
        motion: DsCubeAvatar.spin.dividedBy(widget.speed),
        elapsed: elapsed,
        frozen: _frozen,
      );
    }
    final DsAgentCubeScene scene =
        dsAgentCubeScene(state, speed: widget.speed);
    return DsCubeScene(
      scene: scene,
      width: scene.width * widget.size.scale,
      accent: accent,
      elapsed: elapsed,
      frozen: _frozen,
    );
  }

  @override
  Widget build(BuildContext context) {
    // *"The single knob. Every accent face in the set is mixed from this."*
    final Color accent = widget.accent ?? DsTheme.of(context).agent;
    final DsAgentState? outgoing = _outgoing;

    return Semantics(
      image: true,
      // `role="img" aria-label={AGENT_STATE_LABEL[state]}`.
      label: widget.state.label,
      child: SizedBox(
        width: widget.size.box,
        height: widget.size.box,
        child: Stack(
          // `overflow: visible` on the scene, and the whole reason the painter
          // is allowed to draw past its box.
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            // *"The outgoing scene sits underneath at full opacity and is
            // simply dropped when the fade ends."*
            if (outgoing != null && outgoing != widget.state)
              _loose(_scene(outgoing, accent, _outgoingElapsed)),
            // *"Only the incoming one animates — it mounts fresh, and a CSS
            // transition on a freshly-mounted element has no prior value to
            // travel from, so this has to be a keyframe rather than a
            // transition or the 'fade' is an instant swap."*
            _loose(
              AnimatedBuilder(
                animation: _fade,
                builder: (BuildContext context, Widget? child) => Opacity(
                  opacity: DsCurves.out.transform(_fade.value),
                  child: child,
                ),
                child: _scene(widget.state, accent, _elapsed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
