import 'package:elattar_design_system/elattar_design_system.dart';
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
import 'package:flutter_test/flutter_test.dart';

/// The effects layer: the two gradient button surfaces (`action-feedback`,
/// `premium-surface`) and the three glass utilities.
///
/// **The map's resolved hexes are ORACLES, not source.** Every stop the CSS
/// writes as `color-mix(in oklab, …)` is derived at runtime from `Palette`,
/// so a rebrand carries; these tests are what pins the derivation to the
/// numbers measured off the live page (shadows-map §5.3, §5.4, §7.4).
///
/// **No `pumpAndSettle` anywhere in this file.** `premium-surface` runs two
/// forever-loops and `action-feedback`'s beat runs while hovered, so a settle
/// would never return. `pump(Duration)` with explicit steps only, and the
/// freeze probes run under `MediaQuery(disableAnimations: true)`.

Widget host(
  Widget child, {
  ColorMode mode = ColorMode.dark,
  bool disableAnimations = false,
}) {
  return MediaQuery(
    data: MediaQueryData(
      size: const Size(1440, 900),
      disableAnimations: disableAnimations,
    ),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ThemeScope(
        controller: ThemeController(mode: mode),
        child: Center(child: child),
      ),
    ),
  );
}

/// `#RRGGBB`, the way the map writes a resolved stop.
String hex(Color c) {
  String two(double v) =>
      (v * 255).round().toRadixString(16).padLeft(2, '0').toUpperCase();
  return '#${two(c.r)}${two(c.g)}${two(c.b)}';
}

/// Straight (non-premultiplied) source-over: [over] composited onto [under].
///
/// What the browser does when a translucent glass fill lands on an opaque
/// backdrop — the arithmetic behind §7.4's four composited values.
Color composite(Color over, Color under) {
  double ch(double o, double u) => o * over.a + u * (1 - over.a);
  return Color.from(
    alpha: 1,
    red: ch(over.r, under.r),
    green: ch(over.g, under.g),
    blue: ch(over.b, under.b),
  );
}

/// The `feColorMatrix type="saturate"` transform at [s], applied to an opaque
/// colour — `backdrop-saturate-150` is `s = 1.5`.
///
/// Coefficients are the SVG spec's luminance weights (0.213 / 0.715 / 0.072),
/// the same ones `glass.dart` builds its matrix from. Written out here rather
/// than reused from the source so the test is an independent check.
Color applySaturation(Color c, double s) {
  const double lr = 0.213;
  const double lg = 0.715;
  const double lb = 0.072;
  double ch(double kr, double kg, double kb) =>
      (kr * c.r + kg * c.g + kb * c.b).clamp(0.0, 1.0);
  return Color.from(
    alpha: c.a,
    red: ch(lr + (1 - lr) * s, lg - lg * s, lb - lb * s),
    green: ch(lr - lr * s, lg + (1 - lg) * s, lb - lb * s),
    blue: ch(lr - lr * s, lg - lg * s, lb + (1 - lb) * s),
  );
}

/// The phase the pseudo-element painter under [of] is currently being fed.
///
/// The port's equivalent of the rAF probe reading `getComputedStyle(space,
/// '::before')` on the reference: [field] is `beat` on `action-feedback`, `drift`
/// or `glint` on `premium-surface`. Both painters are the **last** `CustomPaint` in
/// their stack, because CSS paints the positioned pseudo-elements after the
/// ramp, the inset shadows and the inline content.
double phaseOf(WidgetTester t, Finder of, String field) {
  final CustomPaint paint = t.widget<CustomPaint>(
    find.descendant(of: of, matching: find.byType(CustomPaint)).last,
  );
  final dynamic painter = paint.painter;
  return switch (field) {
    'beat' => painter.beat as double,
    'drift' => painter.drift as double,
    _ => painter.glint as double,
  };
}

void main() {
  // ── The composited glass oracles — shadows-map §7.4 ──────────────────────
  // Both glass boxes sit on an opaque Panel body, so the 24px blur is a no-op
  // and `saturate(1.5)` on a near-neutral is nearly identity. These are the
  // four values the live page rasterises, and they are what the utilities'
  // fills have to reproduce.
  group('glass composites (§7.4 oracles)', () {
    test('glass-panel: --card @74% over the page background', () {
      // dark: #09090B saturates to rgb(8.93, 8.93, 11.93), then the fill.
      final Color darkBackdrop = applySaturation(
        ThemeTokens.dark.background,
        1.5,
      );
      final Color darkFill = OklabColor.mix(
        ThemeTokens.dark.card,
        transparent,
        0.74,
      );
      expect(hex(composite(darkFill, darkBackdrop)), '#141417');

      // light: white saturates to white (a neutral is fixed), and a 74% white
      // fill over white is invisible — only the rim and e2 describe the shape.
      final Color lightBackdrop = applySaturation(
        ThemeTokens.light.background,
        1.5,
      );
      final Color lightFill = OklabColor.mix(
        ThemeTokens.light.card,
        transparent,
        0.74,
      );
      expect(hex(lightBackdrop), '#FFFFFF');
      expect(hex(composite(lightFill, lightBackdrop)), '#FFFFFF');
    });

    test('glass-control: --foreground @7% over --card, unfiltered', () {
      // No blur and no saturate on the control, so the backdrop is --card as
      // it stands.
      final Color darkFill = OklabColor.mix(
        ThemeTokens.dark.foreground,
        transparent,
        0.07,
      );
      expect(hex(composite(darkFill, ThemeTokens.dark.card)), '#28282B');

      final Color lightFill = OklabColor.mix(
        ThemeTokens.light.foreground,
        transparent,
        0.07,
      );
      expect(hex(composite(lightFill, ThemeTokens.light.card)), '#EEEEEE');
    });

    test('the fills themselves are the CSS colour at the CSS alpha', () {
      // `color-mix(in oklab, X N%, transparent)` resolves to X at alpha N:
      // premultiplied interpolation zeroes `transparent`'s contribution.
      final Color panelDark = OklabColor.mix(
        ThemeTokens.dark.card,
        transparent,
        0.74,
      );
      expect(hex(panelDark), hex(ThemeTokens.dark.card));
      expect(panelDark.a, closeTo(0.74, 1e-9));

      final Color rimDark = OklabColor.mix(
        ThemeTokens.dark.foreground,
        transparent,
        0.12,
      );
      expect(hex(rimDark), hex(ThemeTokens.dark.foreground));
      expect(rimDark.a, closeTo(0.12, 1e-9));
    });
  });

  // ── action-feedback — shadows-map §5.3 ──────────────────────────────────────
  group('ActionFeedback', () {
    Widget surface({bool hovered = false, bool pressed = false}) =>
        ActionFeedback(
          spec: pressed ? Shadows.controlPressed : Shadows.controlPrimary,
          radius: BorderRadius.circular(Radii.full),
          border: Border.all(color: transparent, width: BorderWidths.hairline),
          hovered: hovered,
          pressed: pressed,
          child: const SizedBox(width: 120, height: 40),
        );

    test('the ramp is five derived stops on the map\'s hexes', () {
      // linear-gradient(176deg, …) — every stop mixed from Palette at run
      // time, so a rebrand carries. These hexes are the oracle, not the source.
      expect(ActionFeedback.rampStops, <double>[0, 0.44, 0.53, 0.76, 1]);
      expect(ActionFeedback.rampColors.map(hex).toList(), <String>[
        '#3680F6',
        '#1A6EF4',
        '#1851C3',
        '#1A6EF4',
        '#2977F5',
      ]);
      // 44% and 76% are `--color-action` itself, not a mix.
      expect(ActionFeedback.rampColors[1], Palette.action);
      expect(ActionFeedback.rampColors[3], Palette.action);
    });

    test('the beat blend mode is the one thing that flips with the theme', () {
      // globals.css L3289–3295 — the sheen's ::before needs multiply on a
      // light surface and screen on a dark one.
      expect(
        ActionFeedback.beatBlendFor(ResolvedColorMode.light),
        BlendMode.multiply,
      );
      expect(
        ActionFeedback.beatBlendFor(ResolvedColorMode.dark),
        BlendMode.screen,
      );
    });

    test('action-beat samples at every keyframe stop', () {
      // globals.css L2059–2088: a double thump, then 46% of the cycle at rest.
      // Tolerance is 1e-3, not 1e-6: `TweenSequence` accumulates its segment
      // boundaries in floating point (0.3 + 0.15 == 0.44999999999999996) and
      // Flutter's `Cubic` solves its x-parameter by binary search to a
      // documented 0.001 bound, so a sample taken exactly on a boundary can
      // read a hair into the next segment.
      const double tol = 1e-3;
      const List<({double at, double scale, double opacity})> stops =
          <({double at, double scale, double opacity})>[
            (at: 0.00, scale: 0.55, opacity: 0),
            (at: 0.10, scale: 1.00, opacity: 0.62),
            (at: 0.24, scale: 1.32, opacity: 0),
            (at: 0.30, scale: 0.70, opacity: 0),
            (at: 0.40, scale: 1.06, opacity: 0.34),
            (at: 0.54, scale: 1.38, opacity: 0),
            (at: 1.00, scale: 1.38, opacity: 0),
          ];
      for (final ({double at, double scale, double opacity}) s in stops) {
        expect(
          ActionFeedback.beatScale.transform(s.at),
          closeTo(s.scale, tol),
          reason: 'scale at ${(s.at * 100).round()}%',
        );
        expect(
          ActionFeedback.beatOpacity.transform(s.at),
          closeTo(s.opacity, tol),
          reason: 'opacity at ${(s.at * 100).round()}%',
        );
      }
    });

    test('the last 46% of the cycle is dead rest', () {
      // 1196ms of the 2600ms hover cycle: the thump ends at 54% and nothing
      // moves again until the loop wraps.
      for (final double t in <double>[0.6, 0.75, 0.9, 0.99]) {
        expect(ActionFeedback.beatOpacity.transform(t), closeTo(0, 1e-6));
        expect(ActionFeedback.beatScale.transform(t), closeTo(1.38, 1e-6));
      }
    });

    testWidgets('at rest nothing animates; hover starts the beat', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(surface()));
      await t.pump(MotionDurations.normal);
      expect(
        t.hasRunningAnimations,
        isFalse,
        reason: 'the ramp and the texture are static',
      );

      await t.pumpWidget(host(surface(hovered: true)));
      await t.pump(const Duration(milliseconds: 16));
      expect(
        t.hasRunningAnimations,
        isTrue,
        reason: 'action-beat 2.6s --ease-out infinite',
      );
    });

    testWidgets('reduced motion stills the beat', (WidgetTester t) async {
      await t.pumpWidget(host(surface(hovered: true), disableAnimations: true));
      // Would never return if the beat were still looping.
      await t.pumpAndSettle();
      expect(t.hasRunningAnimations, isFalse);
    });

    // ── Elapsed-time semantics — behaviour-audit §3.6, B7/B8 ───────────────
    // A CSS animation counts elapsed time. Changing `animation-duration`
    // re-divides that same elapsed time; it neither restarts the animation nor
    // preserves the frame it was on. The port used to preserve the phase, which
    // is a third thing that matches neither.

    test('phaseAt re-divides elapsed time rather than keeping phase', () {
      // Infinite (`:hover`) wraps…
      expect(
        ActionFeedback.phaseAt(
          const Duration(milliseconds: 137),
          MotionDurations.beatHover,
          repeats: true,
        ),
        closeTo(137 / 2600, 1e-9),
      );
      // …and the SAME elapsed time on the press's 620ms lands somewhere else
      // entirely. Verified on the reference to four significant figures:
      // 137.4 / 620 = 22.2%, which is the 24% keyframe's approach — predicted
      // `scale 1.32`, measured 1.3197 in the frame after `pointerdown`.
      final double pressed = ActionFeedback.phaseAt(
        const Duration(microseconds: 137400),
        MotionDurations.beatPress,
        repeats: false,
      );
      expect(pressed, closeTo(0.2216, 1e-4));
      expect(
        ActionFeedback.beatScale.transform(pressed),
        closeTo(1.3197, 0.001),
      );
      expect(ActionFeedback.beatOpacity.transform(pressed), closeTo(0, 0.01));

      // One iteration and no `animation-fill-mode`: past the end, the element
      // falls back to its base style, which for this ::before is frame 0.
      expect(
        ActionFeedback.phaseAt(
          const Duration(milliseconds: 2500),
          MotionDurations.beatPress,
          repeats: false,
        ),
        0,
      );
    });

    testWidgets('B8 — a press deep into a hover produces NO thump', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(surface(hovered: true)));
      await t.pump(const Duration(milliseconds: 2500));
      expect(
        phaseOf(t, find.byType(ActionFeedback), 'beat'),
        closeTo(2500 / 2600, 1e-6),
      );

      // The rule swaps to `action-beat 620ms ease-out 1`, same animation-name,
      // so the clock is kept and re-divided — and 2500ms is already past a
      // single 620ms iteration. Measured on the reference: `opacity 0.000,
      // scale 0.550` held for the whole 278ms hold.
      await t.pumpWidget(host(surface(hovered: true, pressed: true)));
      expect(phaseOf(t, find.byType(ActionFeedback), 'beat'), 0);
      await t.pump(const Duration(milliseconds: 278));
      expect(phaseOf(t, find.byType(ActionFeedback), 'beat'), 0);
      expect(ActionFeedback.beatScale.transform(0), 0.55);
      expect(ActionFeedback.beatOpacity.transform(0), 0);
    });

    testWidgets('B8 — a press early in a hover DOES thump, at the re-divided '
        'frame', (WidgetTester t) async {
      await t.pumpWidget(host(surface(hovered: true)));
      await t.pump(const Duration(milliseconds: 137));

      await t.pumpWidget(host(surface(hovered: true, pressed: true)));
      final double beat = phaseOf(t, find.byType(ActionFeedback), 'beat');
      expect(beat, closeTo(137 / 620, 1e-6));
      expect(ActionFeedback.beatScale.transform(beat), closeTo(1.3199, 0.001));

      // Releasing hands the same elapsed clock back to the 2.6s rule.
      await t.pumpWidget(host(surface(hovered: true)));
      expect(
        phaseOf(t, find.byType(ActionFeedback), 'beat'),
        closeTo(137 / 2600, 1e-6),
      );
    });

    testWidgets('B7 — hover-out deletes the animation; the next hover starts '
        'at frame 0', (WidgetTester t) async {
      await t.pumpWidget(host(surface(hovered: true)));
      await t.pump(const Duration(milliseconds: 400));
      expect(phaseOf(t, find.byType(ActionFeedback), 'beat'), greaterThan(0));

      // `animation-name: none` within 1.4ms of `pointerout` — ::before snaps to
      // its base style mid-thump, and the clock goes with it.
      await t.pumpWidget(host(surface()));
      expect(phaseOf(t, find.byType(ActionFeedback), 'beat'), 0);

      // The port used to resume the controller from wherever it stopped.
      await t.pumpWidget(host(surface(hovered: true)));
      expect(
        phaseOf(t, find.byType(ActionFeedback), 'beat'),
        0,
        reason: 'a fresh animation, at frame 0',
      );
      await t.pump(const Duration(milliseconds: 100));
      expect(
        phaseOf(t, find.byType(ActionFeedback), 'beat'),
        closeTo(100 / 2600, 1e-6),
      );
    });

    testWidgets('paints in both themes, at rest, hovered and pressed', (
      WidgetTester t,
    ) async {
      for (final ColorMode mode in <ColorMode>[
        ColorMode.dark,
        ColorMode.light,
      ]) {
        for (final Widget s in <Widget>[
          surface(),
          surface(hovered: true),
          surface(hovered: true, pressed: true),
        ]) {
          await t.pumpWidget(host(s, mode: mode, disableAnimations: true));
          await t.pump(MotionDurations.normal);
          expect(t.takeException(), isNull, reason: '$mode');
        }
      }
    });
  });

  // ── premium-surface — shadows-map §5.4 ────────────────────────────────────────
  group('PremiumSurface', () {
    Widget surface({bool hovered = false}) => PremiumSurface(
      spec: hovered ? Shadows.glowValue : Shadows.controlPremium,
      radius: BorderRadius.circular(Radii.full),
      border: Border.all(color: transparent, width: BorderWidths.hairline),
      hovered: hovered,
      child: const SizedBox(width: 140, height: 40),
    );

    test('the metal ramp is seven derived stops on the map\'s hexes', () {
      expect(PremiumSurface.rampStops, <double>[
        0,
        0.22,
        0.44,
        0.52,
        0.62,
        0.88,
        1,
      ]);
      expect(PremiumSurface.rampColors.map(hex).toList(), <String>[
        '#DBF9A3',
        '#D9F99D',
        '#A3E635',
        '#7EB825', // the edge of the metal — contrast-critical, do not move
        '#A3E635',
        '#D9F99D',
        '#DDFAA8',
      ]);
      expect(PremiumSurface.rampColors[1], Palette.valueBright);
      expect(PremiumSurface.rampColors[2], Palette.value);
      expect(PremiumSurface.rampColors[4], Palette.value);
      expect(PremiumSurface.rampColors[5], Palette.valueBright);
    });

    test('the foil is soft-light and the glint is screen in BOTH themes', () {
      // globals.css L3297–3300 says so explicitly: the foil is its own opaque
      // base, so it never needs the multiply/screen split the sheen needs.
      expect(PremiumSurface.foilBlend, BlendMode.softLight);
      expect(PremiumSurface.glintBlend, BlendMode.screen);
      expect(PremiumSurface.foilOpacity, 0.95);
      expect(PremiumSurface.foilHoverOpacity, 1);
    });

    test('value-foil-drift travels two layers and parks the third', () {
      // globals.css L1915–1928. Layers 1 and 2 travel 140% and 220% of their
      // own sizing box; layer 3 (the radial corner light) is stationary.
      expect(PremiumSurface.driftPosition(0, 0), closeTo(0, 1e-9));
      expect(PremiumSurface.driftPosition(0, 1), closeTo(1.40, 1e-9));
      expect(PremiumSurface.driftPosition(1, 0), closeTo(-0.60, 1e-9));
      expect(PremiumSurface.driftPosition(1, 1), closeTo(1.60, 1e-9));
      expect(PremiumSurface.driftPosition(2, 0), closeTo(0.50, 1e-9));
      expect(PremiumSurface.driftPosition(2, 1), closeTo(0.50, 1e-9));
      // Linear, so the midpoint is exactly halfway.
      expect(PremiumSurface.driftPosition(0, 0.5), closeTo(0.70, 1e-9));
      expect(PremiumSurface.driftPosition(1, 0.5), closeTo(0.50, 1e-9));
    });

    test('value-glint idles for 54% of the cycle, then crosses once', () {
      // globals.css L1930–1946. Position is declared only at 0/54/100, so it
      // HOLDS at 135% through the idle and then sweeps to −55%.
      const double tol = 1e-3;
      for (final double t in <double>[0, 0.2, 0.4, 0.54]) {
        expect(
          PremiumSurface.glintPosition.transform(t),
          closeTo(1.35, tol),
          reason: 'held at 135% through ${(t * 100).round()}%',
        );
        expect(PremiumSurface.glintOpacity.transform(t), closeTo(0, tol));
      }
      expect(PremiumSurface.glintPosition.transform(1), closeTo(-0.55, tol));

      // Opacity ramps 0→1 over 54–60% and 1→0 over 94–100%.
      expect(PremiumSurface.glintOpacity.transform(0.60), closeTo(1, tol));
      expect(PremiumSurface.glintOpacity.transform(0.94), closeTo(1, tol));
      expect(PremiumSurface.glintOpacity.transform(1), closeTo(0, tol));
      // Mid-sweep the band is somewhere between its two ends.
      final double mid = PremiumSurface.glintPosition.transform(0.8);
      expect(mid, lessThan(1.35));
      expect(mid, greaterThan(-0.55));
    });

    testWidgets('two forever-loops run at rest', (WidgetTester t) async {
      await t.pumpWidget(host(surface()));
      await t.pump(const Duration(milliseconds: 16));
      expect(
        t.hasRunningAnimations,
        isTrue,
        reason: 'value-foil-drift 11s + value-glint 5.5s, both infinite',
      );
    });

    // ── Elapsed-time semantics — behaviour-audit §3.7, B10b ────────────────

    test('phaseAt keeps one elapsed clock and re-divides it', () {
      // 2217ms in, the glint is 40% through a 5.5s pass — idle, invisible,
      // parked at 135% — and 92% through a 2.4s one, which is the far end of
      // the sweep. Hovering changes nothing but the duration, and this is the
      // elapsed time that reproduces the audit's own two sampled frames.
      const Duration elapsed = Duration(milliseconds: 2217);
      final double rest = PremiumSurface.phaseAt(
        elapsed,
        MotionDurations.glint,
      );
      final double hovered = PremiumSurface.phaseAt(
        elapsed,
        MotionDurations.glintHover,
      );
      expect(rest, closeTo(0.4031, 1e-3));
      expect(hovered, closeTo(0.92375, 1e-5));

      // The measured pair, from the two frames either side of `pointerover`:
      // `opacity 0.0000, background-position 135%` → `opacity 1.0000, −49.86%`.
      expect(PremiumSurface.glintOpacity.transform(rest), 0);
      expect(PremiumSurface.glintPosition.transform(rest), closeTo(1.35, 1e-6));
      expect(PremiumSurface.glintOpacity.transform(hovered), closeTo(1, 1e-9));
      expect(
        PremiumSurface.glintPosition.transform(hovered),
        closeTo(-0.4986, 1e-3),
      );

      // The drift is on the same clock and never changes duration, so it never
      // jumps: 11s, hovered or not.
      expect(
        PremiumSurface.phaseAt(elapsed, MotionDurations.foilDrift),
        closeTo(2217 / 11000, 1e-9),
      );
    });

    testWidgets('B10b — the glint TELEPORTS when hover retimes it', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(surface()));
      await t.pump(const Duration(milliseconds: 2217));
      expect(
        phaseOf(t, find.byType(PremiumSurface), 'glint'),
        closeTo(0.4031, 1e-3),
      );

      // One frame, no elapsed time, only `animation-duration: 2.4s`. The port
      // used to continue smoothly from the same phase at the new rate; the
      // browser was measured jumping from idle-and-invisible to fully bright
      // and almost off the left edge in the very next frame.
      await t.pumpWidget(host(surface(hovered: true)));
      final double glint = phaseOf(t, find.byType(PremiumSurface), 'glint');
      expect(glint, closeTo(0.92375, 1e-5));
      expect(PremiumSurface.glintOpacity.transform(glint), closeTo(1, 1e-9));
      expect(
        PremiumSurface.glintPosition.transform(glint),
        closeTo(-0.4986, 1e-3),
      );

      // The drift, on the same clock and the same 11s, does not move with it.
      expect(
        phaseOf(t, find.byType(PremiumSurface), 'drift'),
        closeTo(2217 / 11000, 1e-6),
      );
    });

    testWidgets('reduced motion stills both loops', (WidgetTester t) async {
      await t.pumpWidget(host(surface(), disableAnimations: true));
      // The whole point: `pumpAndSettle` would hang on a live foil, so this
      // returning IS the assertion. It is also what makes a page test
      // possible at all (shadows-map §15 Q2).
      await t.pumpAndSettle();
      expect(t.hasRunningAnimations, isFalse);
    });

    testWidgets('paints in both themes, at rest and hovered', (
      WidgetTester t,
    ) async {
      for (final ColorMode mode in <ColorMode>[
        ColorMode.dark,
        ColorMode.light,
      ]) {
        for (final bool hovered in <bool>[false, true]) {
          await t.pumpWidget(
            host(
              surface(hovered: hovered),
              mode: mode,
              disableAnimations: true,
            ),
          );
          await t.pump(MotionDurations.normal);
          expect(t.takeException(), isNull, reason: '$mode hovered=$hovered');
        }
      }
    });
  });

  // ── glass — shadows-map §7 ───────────────────────────────────────────────
  group('media primitives', () {
    test('portrait media is the named 9:16 contract', () {
      expect(AspectRatios.portrait, 9 / 16);
    });

    test('scrim is transparent at the top and readable at the bottom', () {
      final LinearGradient gradient = MediaScrim.debugGradient;
      expect(gradient.begin, Alignment.topCenter);
      expect(gradient.end, Alignment.bottomCenter);
      expect(gradient.stops, MediaScrimTokens.stops);
      expect(gradient.colors, hasLength(3));
      expect(gradient.colors.first.a, 0);
      expect(gradient.colors[1].a, MediaScrimTokens.middleAlpha);
      expect(gradient.colors.last.a, MediaScrimTokens.bottomAlpha);
      expect(MediaScrim.debugInk, MediaScrimTokens.ink);
      expect(MediaScrimTokens.foreground.a, 1);
    });

    testWidgets('scrim preserves child sizing in both themes', (
      WidgetTester t,
    ) async {
      for (final ColorMode mode in <ColorMode>[
        ColorMode.dark,
        ColorMode.light,
      ]) {
        await t.pumpWidget(
          host(
            const SizedBox(
              width: 180,
              height: 320,
              child: MediaScrim(
                child: SizedBox.expand(key: Key('media-scrim-child')),
              ),
            ),
            mode: mode,
          ),
        );
        expect(t.getSize(find.byType(MediaScrim)), const Size(180, 320));
        expect(
          t.getSize(find.byKey(const Key('media-scrim-child'))),
          const Size(180, 320),
        );
        expect(t.takeException(), isNull, reason: '$mode');
      }
    });
  });

  group('glass utilities', () {
    /// The twenty numbers behind a `ColorFilter.matrix`.
    ///
    /// `ColorFilter` keeps its matrix private and offers no accessor, so the
    /// only public route to it is `toString()`, which prints the list
    /// verbatim. Coupled to a debug string on purpose: the alternative is
    /// rasterising a swatch to infer twenty coefficients from three channels.
    List<double> matrixOf(Object filter) =>
        RegExp(r'-?\d+(?:\.\d+)?(?:e-?\d+)?')
            .allMatches(filter.toString())
            .map((RegExpMatch m) => double.parse(m[0]!))
            .toList();

    test('saturate reproduces the feColorMatrix at s = 1.5', () {
      // shadows-map §13.5. `closeTo`, not `equals`: the coefficients are
      // computed rather than pasted, so 0.213 + 0.787 * 1.5 lands on
      // 1.3935000000000002.
      final List<double> m = matrixOf(saturate(1.5));
      expect(m, hasLength(20));
      const List<double> want = <double>[
        1.3935, -0.3575, -0.0360, 0, 0, //
        -0.1065, 1.1425, -0.0360, 0, 0, //
        -0.1065, -0.3575, 1.4640, 0, 0, //
        0, 0, 0, 1, 0, //
      ];
      for (int i = 0; i < 20; i++) {
        expect(m[i], closeTo(want[i], 1e-12), reason: 'matrix[$i]');
      }
    });

    test('saturate(1) is the identity — the filter is opt-in, not baked', () {
      final List<double> m = matrixOf(saturate(1));
      const List<double> identity = <double>[
        1, 0, 0, 0, 0, //
        0, 1, 0, 0, 0, //
        0, 0, 1, 0, 0, //
        0, 0, 0, 1, 0, //
      ];
      for (int i = 0; i < 20; i++) {
        expect(m[i], closeTo(identity[i], 1e-12), reason: 'matrix[$i]');
      }
    });

    test('the two panels differ in exactly their ambient layer', () {
      // `glass-panel-deep` is byte-identical to `glass-panel` except for
      // `--shadow-e4` in place of `--shadow-e2` (§7.5). `ShadowLayer` has
      // no `operator ==`, so these compare by identity — which is the
      // stronger claim: the layers are literally the same objects.
      expect(
        Glass.debugShadow(GlassVariant.panel).layers.sublist(2),
        Shadows.md.layers,
      );
      expect(
        Glass.debugShadow(GlassVariant.prominent).layers.sublist(2),
        Shadows.xl.layers,
      );
      expect(
        Glass.debugShadow(GlassVariant.prominent).insetLayers,
        Glass.debugShadow(GlassVariant.panel).insetLayers,
      );
      expect(Glass.debugShadow(GlassVariant.panel).insetLayers, hasLength(2));
    });

    test('clear glass keeps standard mechanics with a lower fill', () {
      expect(
        Glass.debugShadow(GlassVariant.navigation),
        same(Glass.debugShadow(GlassVariant.panel)),
      );
      expect(
        Glass.debugBackdrop(GlassVariant.navigation),
        same(Glass.debugBackdrop(GlassVariant.panel)),
      );
      expect(Glass.debugBackdrop(GlassVariant.navigation), isNotNull);

      for (final ThemeTokens theme in <ThemeTokens>[
        ThemeTokens.dark,
        ThemeTokens.light,
      ]) {
        final Color clear = Glass.debugFill(GlassVariant.navigation, theme);
        final Color standard = Glass.debugFill(GlassVariant.panel, theme);
        expect(
          clear,
          OklabColor.mix(
            theme.card,
            transparent,
            SurfaceOpacity.navigationGlass,
          ),
        );
        expect(clear.a, lessThan(standard.a));
      }
    });

    test('the inner ring is a hard 1px: no offset, no blur, 1px spread', () {
      // `inset 0 0 0 1px color-mix(in oklab, var(--foreground) 12%, transparent)`
      final ShadowLayer ring = Glass.debugShadow(
        GlassVariant.panel,
      ).insetLayers[1];
      expect(
        <double>[ring.dx, ring.dy, ring.blur, ring.spread],
        <double>[0, 0, 0, 1],
      );
      expect(
        ring.color(ThemeTokens.dark),
        OklabColor.mix(ThemeTokens.dark.foreground, transparent, 0.12),
      );

      // …and the top highlight above it is `--rim-strong`, the same token
      // every raised control carries.
      final ShadowLayer rim = Glass.debugShadow(
        GlassVariant.panel,
      ).insetLayers[0];
      expect(
        <double>[rim.dx, rim.dy, rim.blur, rim.spread],
        <double>[0, 1, 0, 0],
      );
      expect(rim.color(ThemeTokens.dark), ThemeTokens.dark.rimStrong);
    });

    test('glass-control is two inset layers and nothing else', () {
      // No blur, no saturate, no outer shadow.
      expect(Glass.debugBackdrop(GlassVariant.control), isNull);
      expect(Glass.debugShadow(GlassVariant.control).hasInset, isTrue);
      expect(Glass.debugShadow(GlassVariant.control).layers, hasLength(2));
      expect(
        Glass.debugShadow(GlassVariant.control).outerShadows(ThemeTokens.dark),
        isEmpty,
      );

      final ShadowLayer ring = Glass.debugShadow(
        GlassVariant.control,
      ).insetLayers[1];
      expect(
        ring.color(ThemeTokens.light),
        OklabColor.mix(ThemeTokens.light.foreground, transparent, 0.16),
      );
    });

    test(
      'the panels carry the composed backdrop; the control carries none',
      () {
        expect(Glass.debugBackdrop(GlassVariant.panel), isNotNull);
        expect(Glass.debugBackdrop(GlassVariant.prominent), isNotNull);
        expect(
          Glass.debugBackdrop(GlassVariant.prominent),
          Glass.debugBackdrop(GlassVariant.panel),
        );
        expect(Glass.debugBackdrop(GlassVariant.control), isNull);
      },
    );

    test('the fills are the utilities\' own color-mix, per theme', () {
      for (final ThemeTokens theme in <ThemeTokens>[
        ThemeTokens.dark,
        ThemeTokens.light,
      ]) {
        expect(
          Glass.debugFill(GlassVariant.panel, theme),
          OklabColor.mix(theme.card, transparent, 0.74),
        );
        expect(
          Glass.debugFill(GlassVariant.prominent, theme),
          OklabColor.mix(theme.card, transparent, 0.74),
        );
        expect(
          Glass.debugFill(GlassVariant.control, theme),
          OklabColor.mix(theme.foreground, transparent, 0.07),
        );
      }
    });

    test('the ambient clip keeps outer ink out of the border box', () {
      // CSS Backgrounds §7.1.1: an outer box-shadow is not painted inside the
      // border box. `BoxDecoration` draws a solid blurred RRect and lets an
      // opaque fill hide it — which a 74% fill does not, so the panels clip.
      final RRect shape = RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 200, 96),
        const Radius.circular(Radii.xl4),
      );
      final Path clip = Glass.debugAmbientClip(
        shape,
        Shadows.md.layers.where((ShadowLayer l) => !l.inset).toList(),
      );
      expect(
        clip.contains(const Offset(100, 48)),
        isFalse,
        reason: 'the centre of the panel takes no ambient ink',
      );
      expect(
        clip.contains(const Offset(100, 120)),
        isTrue,
        reason: 'below the panel it does',
      );
    });

    testWidgets('all four paint in both themes', (WidgetTester t) async {
      final BorderRadius slab = BorderRadius.circular(Radii.xl4);
      for (final ColorMode mode in <ColorMode>[
        ColorMode.dark,
        ColorMode.light,
      ]) {
        for (final Widget glass in <Widget>[
          Glass(
            variant: GlassVariant.panel,
            radius: slab,
            child: const SizedBox(width: 200, height: 96),
          ),
          Glass(
            variant: GlassVariant.navigation,
            radius: slab,
            child: const SizedBox(width: 200, height: 96),
          ),
          Glass(
            variant: GlassVariant.prominent,
            radius: slab,
            child: const SizedBox(width: 200, height: 96),
          ),
          Glass(
            variant: GlassVariant.control,
            radius: BorderRadius.circular(Radii.full),
            padding: EdgeInsets.symmetric(horizontal: space(4)),
            // Drift 3: the copy and the CSS comment both say 44px; the
            // specimen is `h-12`. Ruling S8 — render 48, print 44.
            child: const SizedBox(height: 48),
          ),
        ]) {
          await t.pumpWidget(host(glass, mode: mode));
          await t.pump();
          expect(t.takeException(), isNull, reason: '$mode');
        }
      }
    });

    testWidgets('a panel mounts one BackdropFilter and a control mounts none', (
      WidgetTester t,
    ) async {
      final BorderRadius slab = BorderRadius.circular(Radii.xl4);
      await t.pumpWidget(
        host(
          Glass(
            variant: GlassVariant.panel,
            radius: slab,
            child: const SizedBox(width: 200, height: 96),
          ),
        ),
      );
      expect(find.byType(BackdropFilter), findsOneWidget);

      await t.pumpWidget(
        host(
          Glass(
            variant: GlassVariant.control,
            radius: BorderRadius.circular(Radii.full),
            child: const SizedBox(width: 120, height: 48),
          ),
        ),
      );
      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('clear glass mounts the shared backdrop filter', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          Glass(
            variant: GlassVariant.navigation,
            radius: BorderRadius.circular(Radii.xl4),
            child: const SizedBox(width: 200, height: 96),
          ),
        ),
      );
      expect(find.byType(BackdropFilter), findsOneWidget);
    });
  });
}
