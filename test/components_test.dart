import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The component layer: the three primitives the docs shell is assembled from.

Widget host(Widget child, {DsThemeMode mode = DsThemeMode.dark}) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(1440, 900)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: DsTheme(
        controller: DsThemeController(mode: mode),
        child: Center(child: child),
      ),
    ),
  );
}

/// A navigable host, for the one component that pushes a route.
///
/// `DsTheme` sits **above** the app, matching what the example app does: the
/// Navigator's overlay has to be inside the theme scope, or a pushed route
/// cannot resolve a token.
Widget navHost(Widget child, {DsThemeMode mode = DsThemeMode.dark}) {
  return DsTheme(
    controller: DsThemeController(mode: mode),
    child: WidgetsApp(
      color: const Color(0xFF000000),
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
          PageRouteBuilder<T>(
        settings: settings,
        pageBuilder:
            (BuildContext c, Animation<double> a, Animation<double> s) =>
                builder(c),
      ),
      home: child,
    ),
  );
}

/// Puts the test view at the 1440 frame the port is verified against.
void useFrame(WidgetTester t) {
  t.view.physicalSize = const Size(1440, 900);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);
}

Future<TestGesture> hoverOver(WidgetTester t, Finder target) async {
  final TestGesture mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: Offset.zero);
  addTearDown(mouse.removePointer);
  await t.pump();
  await mouse.moveTo(t.getCenter(target));
  await t.pump();
  return mouse;
}

void main() {
  group('DsIcon', () {
    testWidgets('the size ladder is 12/14/16/20/24/32/40',
        (WidgetTester t) async {
      const Map<DsIconSize, double> ladder = <DsIconSize, double>{
        DsIconSize.xs: 12,
        DsIconSize.sm: 14,
        DsIconSize.md: 16,
        DsIconSize.lg: 20,
        DsIconSize.xl: 24,
        DsIconSize.xl2: 32,
        DsIconSize.xl3: 40,
      };
      for (final MapEntry<DsIconSize, double> step in ladder.entries) {
        expect(DsIcon.pxFor(step.key), step.value);
      }
      expect(ladder.length, DsIconSize.values.length);
    });

    testWidgets('md renders 16×16', (WidgetTester t) async {
      await t.pumpWidget(host(const DsIcon(DsIconGlyph.menu)));
      expect(t.getSize(find.byType(DsIcon)), const Size(16, 16));
    });

    test('stroke follows the reference ternary, not a clamp', () {
      // components/ui/icon.tsx:
      //   strokeWidth={(2 * 24) / px > 2.6 ? 2.4 : (2 * 24) / px < 1.5 ? 1.6 : 2}
      // The middle branch is a literal 2 — it is NOT the raw 48/px. That makes
      // lg, xl and 2xl all stroke 2.0, where a clamp reading would give
      // 2.4 / 2.0 / 1.5.
      expect(DsIcon.strokeFor(12), 2.4); // 4.00 > 2.6
      expect(DsIcon.strokeFor(14), 2.4); // 3.43 > 2.6
      expect(DsIcon.strokeFor(16), 2.4); // 3.00 > 2.6
      expect(DsIcon.strokeFor(20), 2.0); // 2.40 — middle branch
      expect(DsIcon.strokeFor(24), 2.0); // 2.00 — middle branch
      expect(DsIcon.strokeFor(32), 2.0); // 1.50 is NOT < 1.5 — middle branch
      expect(DsIcon.strokeFor(40), 1.6); // 1.20 < 1.5
    });

    testWidgets('tones resolve against the live theme', (WidgetTester t) async {
      late BuildContext context;
      await t.pumpWidget(host(Builder(builder: (BuildContext c) {
        context = c;
        return const SizedBox.shrink();
      })));

      final DsThemeData dark = DsThemeData.dark;
      expect(DsIcon.colorFor(context, DsIconTone.normal), dark.foreground);
      expect(DsIcon.colorFor(context, DsIconTone.muted), dark.mutedForeground);
      expect(DsIcon.colorFor(context, DsIconTone.subtle), dark.mutedForeground);
      expect(DsIcon.colorFor(context, DsIconTone.action), dark.actionInk);
      expect(DsIcon.colorFor(context, DsIconTone.value), dark.valueInk);
      expect(DsIcon.colorFor(context, DsIconTone.success), dark.successInk);
      expect(DsIcon.colorFor(context, DsIconTone.warning), dark.warningInk);
      expect(DsIcon.colorFor(context, DsIconTone.info), dark.infoInk);
      expect(DsIcon.colorFor(context, DsIconTone.error), dark.destructiveInk);
    });

    testWidgets('inherit takes the surrounding text colour',
        (WidgetTester t) async {
      late BuildContext inside;
      await t.pumpWidget(host(DefaultTextStyle(
        style: TextStyle(color: DsThemeData.dark.valueInk),
        child: Builder(builder: (BuildContext c) {
          inside = c;
          return const SizedBox.shrink();
        }),
      )));
      expect(DsIcon.colorFor(inside, DsIconTone.inherit),
          DsThemeData.dark.valueInk);
    });

    testWidgets('inherit falls back to the surface colour',
        (WidgetTester t) async {
      late BuildContext bare;
      await t.pumpWidget(host(Builder(builder: (BuildContext c) {
        bare = c;
        return const SizedBox.shrink();
      })));
      expect(DsIcon.colorFor(bare, DsIconTone.inherit),
          DsThemeData.dark.foreground);
    });

    testWidgets('every glyph paints in both themes', (WidgetTester t) async {
      for (final DsThemeMode mode in <DsThemeMode>[
        DsThemeMode.dark,
        DsThemeMode.light,
      ]) {
        for (final DsIconGlyph glyph in DsIconGlyph.values) {
          await t.pumpWidget(host(DsIcon(glyph, size: DsIconSize.xl), mode: mode));
          expect(t.takeException(), isNull, reason: '$glyph in $mode');
        }
      }
    });

    testWidgets('sizePx and strokeOverride win', (WidgetTester t) async {
      await t.pumpWidget(host(const DsIcon(
        DsIconGlyph.check,
        sizePx: 18,
        strokeOverride: 3,
      )));
      expect(t.getSize(find.byType(DsIcon)), const Size(18, 18));
      expect(t.takeException(), isNull);
    });
  });

  group('DsButton', () {
    DsMachineSurface surfaceOf(WidgetTester t) =>
        t.widget<DsMachineSurface>(find.byType(DsMachineSurface));

    testWidgets('all nine rungs render at their cva height',
        (WidgetTester t) async {
      Future<Size> sizeOf(DsButtonSize size) async {
        await t.pumpWidget(host(DsButton(
          variant: DsButtonVariant.outline,
          size: size,
          onPressed: () {},
          child: const DsIcon(DsIconGlyph.menu),
        )));
        return t.getSize(find.byType(DsButton));
      }

      // The five text rungs — 24 / 32 / 40 / 48 / 56.
      expect((await sizeOf(DsButtonSize.xs)).height, ds(6));
      expect((await sizeOf(DsButtonSize.sm)).height, ds(8));
      expect((await sizeOf(DsButtonSize.md)).height, ds(10));
      expect((await sizeOf(DsButtonSize.lg)).height, ds(12));
      expect((await sizeOf(DsButtonSize.xl)).height, ds(14));
      // The four squares, which are square.
      expect(await sizeOf(DsButtonSize.iconXs), Size(ds(6), ds(6)));
      expect(await sizeOf(DsButtonSize.iconSm), Size(ds(8), ds(8)));
      expect(await sizeOf(DsButtonSize.icon), Size(ds(10), ds(10)));
      expect(await sizeOf(DsButtonSize.iconLg), Size(ds(12), ds(12)));
    });

    testWidgets('outline is card on input with --shadow-btn',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        variant: DsButtonVariant.outline,
        onPressed: () {},
        child: const DsIcon(DsIconGlyph.menu),
      )));

      final DsMachineSurface surface = surfaceOf(t);
      expect(surface.fill, DsThemeData.dark.card);
      expect((surface.border! as Border).top.color, DsThemeData.dark.input);
      expect(surface.spec, same(DsShadows.btn));
      expect(surface.radius, BorderRadius.circular(DsRadii.pill));
    });

    testWidgets('outline fills with --muted on hover', (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        variant: DsButtonVariant.outline,
        onPressed: () {},
        child: const DsIcon(DsIconGlyph.menu),
      )));

      await hoverOver(t, find.byType(DsButton));
      await t.pumpAndSettle();
      expect(surfaceOf(t).fill, DsThemeData.dark.muted);
    });

    testWidgets('outline drops into --shadow-btn-down while held',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        variant: DsButtonVariant.outline,
        onPressed: () {},
        child: const DsIcon(DsIconGlyph.menu),
      )));

      final TestGesture gesture =
          await t.startGesture(t.getCenter(find.byType(DsButton)));
      await t.pump();
      expect(surfaceOf(t).spec, same(DsShadows.btnDown));

      await gesture.up();
      await t.pump(DsDurations.base);
      expect(surfaceOf(t).spec, same(DsShadows.btn));
    });

    testWidgets('ghost is bare, muted, and shadowless', (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        variant: DsButtonVariant.ghost,
        onPressed: () {},
        child: const DsIcon(DsIconGlyph.x),
      )));

      final DsMachineSurface surface = surfaceOf(t);
      expect(surface.fill, dsTransparent);
      // The base class list is `border border-transparent` for every variant:
      // a real 1px border, invisible but paid for in inner width.
      expect((surface.border! as Border).top.color, dsTransparent);
      expect((surface.border! as Border).top.width, DsWidths.hairline);
      expect(surface.spec.layers, isEmpty);
      expect(
        t.widget<DefaultTextStyle>(find
            .descendant(
              of: find.byType(DsButton),
              matching: find.byType(DefaultTextStyle),
            )
            .first)
            .style
            .color,
        DsThemeData.dark.mutedForeground,
      );
    });

    testWidgets('ghost takes --secondary and --foreground on hover',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        variant: DsButtonVariant.ghost,
        onPressed: () {},
        child: const DsIcon(DsIconGlyph.x),
      )));

      await hoverOver(t, find.byType(DsButton));
      await t.pumpAndSettle();
      expect(surfaceOf(t).fill, DsThemeData.dark.secondary);
    });

    /// The scale the button is currently drawn at — the first [Transform] under
    /// it, which is the one `scale-95` maps to.
    double scaleOf(WidgetTester t) => t
        .widget<Transform>(find
            .descendant(
              of: find.byType(DsButton),
              matching: find.byType(Transform),
            )
            .first)
        .transform
        .storage[0];

    testWidgets('squishes to 0.95 — the button scale, not press\'s 0.94',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        variant: DsButtonVariant.outline,
        onPressed: () {},
        child: const DsIcon(DsIconGlyph.menu),
      )));

      expect(scaleOf(t), 1.0);

      await t.startGesture(t.getCenter(find.byType(DsButton)));
      // RETUNED (behaviour-audit B1). This used to pump `--duration-tick`
      // before asserting, on the theory that `btn-spring`'s `:active`
      // duration eased the squish over 80ms. It does not: Tailwind v4 compiles
      // `scale-95` to the standalone `scale` property, which is **not** in
      // `btn-spring`'s transition-property list. One frame is all it takes on
      // the reference, so one frame is all this pumps — stricter, and true.
      await t.pump();
      expect(scaleOf(t), DsTransforms.buttonScale);
    });

    // ── Measured behaviour — behaviour-audit §3 ────────────────────────────
    // Every number below is a trace off the live reference at 1440×900, driven
    // with real pointer/keyboard input and rAF-sampled at ~16.6ms. Each of
    // these fails against the port as it stood before this wave.

    testWidgets('B1 — the press scale snaps both ways, with no frame between',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        variant: DsButtonVariant.outline,
        onPressed: () {},
        child: const DsIcon(DsIconGlyph.menu),
      )));
      expect(scaleOf(t), 1.0, reason: 'at rest');

      final List<double> frames = <double>[];
      final TestGesture press =
          await t.startGesture(t.getCenter(find.byType(DsButton)));

      // Measured: 9.5ms after `pointerdown` — the very next frame — the button
      // is already fully at 0.95, with no intermediate value sampled.
      await t.pump();
      expect(scaleOf(t), DsTransforms.buttonScale);
      for (int i = 0; i < 24; i++) {
        await t.pump(const Duration(milliseconds: 16));
        frames.add(scaleOf(t));
      }

      // …and 10.5ms after `pointerup` it is fully back, with no overshoot.
      await press.up();
      await t.pump();
      expect(scaleOf(t), 1.0);
      for (int i = 0; i < 24; i++) {
        await t.pump(const Duration(milliseconds: 16));
        frames.add(scaleOf(t));
      }

      // The whole press, sampled: two values and nothing else. No 80ms
      // down-stroke, no 250ms spring back, and none of the ≈1.005 release
      // overshoot the port used to carry through `DsPress`.
      expect(frames.toSet(), <double>{DsTransforms.buttonScale, 1.0});
    });

    testWidgets('B6 — a 10, 20 or 30ms tap still shows the full 0.95',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        variant: DsButtonVariant.outline,
        onPressed: () {},
        child: const DsIcon(DsIconGlyph.menu),
      )));

      // The port used to reach 0.9756 / 0.9592 / 0.9497 for these three holds,
      // then play a shortened spring backwards. Instant means depth cannot
      // depend on hold length.
      for (final int ms in <int>[10, 20, 30]) {
        final TestGesture tap =
            await t.startGesture(t.getCenter(find.byType(DsButton)));
        await t.pump();
        expect(scaleOf(t), DsTransforms.buttonScale, reason: '${ms}ms hold');
        await t.pump(Duration(milliseconds: ms));
        expect(scaleOf(t), DsTransforms.buttonScale, reason: '${ms}ms hold');

        await tap.up();
        await t.pump();
        expect(scaleOf(t), 1.0, reason: 'one frame after a ${ms}ms hold');
      }
    });

    // ── The two attributes `asChild` merges into a trigger ─────────────────

    testWidgets('aria-haspopup: a trigger does not squish, for the whole press',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        variant: DsButtonVariant.outline,
        suppressPressScale: true,
        onPressed: () {},
        child: const DsIcon(DsIconGlyph.menu),
      )));

      final List<double> frames = <double>[scaleOf(t)];
      final TestGesture press =
          await t.startGesture(t.getCenter(find.byType(DsButton)));
      await t.pump();
      frames.add(scaleOf(t));
      // The same 24 frames B1 samples a squishing button over, plus the two
      // short holds B6 uses: `not-aria-[haspopup]` is not a shorter squish.
      for (int i = 0; i < 24; i++) {
        await t.pump(const Duration(milliseconds: 16));
        frames.add(scaleOf(t));
      }
      await press.up();
      await t.pump();
      frames.add(scaleOf(t));

      expect(frames.toSet(), <double>{1.0},
          reason: 'one value for the whole press, and it is unity');
    });

    testWidgets('…and it exempts the scale alone: the socket still takes it',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        variant: DsButtonVariant.outline,
        suppressPressScale: true,
        onPressed: () {},
        child: const DsIcon(DsIconGlyph.menu),
      )));

      final TestGesture press =
          await t.startGesture(t.getCenter(find.byType(DsButton)));
      await t.pump();
      // `active:shadow-btn-down` carries no `not-` guard, so a trigger sinks
      // into its socket exactly like every other button.
      expect(surfaceOf(t).spec, same(DsShadows.btnDown));
      expect(scaleOf(t), 1.0);

      await press.up();
      await t.pump(DsDurations.base);
      expect(surfaceOf(t).spec, same(DsShadows.btn));
    });

    testWidgets('B2 — the pressed shadow hard-cuts: the token pair cannot '
        'interpolate', (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        onPressed: () {},
        child: const DsIcon(DsIconGlyph.menu),
      )));
      DsShadowSpec spec() =>
          t.widget<DsSheenAction>(find.byType(DsSheenAction)).spec;

      // `--shadow-btn-primary` is 4 layers (2 inset, 2 not) against
      // `--shadow-btn-down`'s 2 (1 inset, 1 not). Mismatched layer counts AND
      // mismatched `inset` flags: CSS refuses to interpolate, and the browser
      // was measured swapping the value inside a single frame. A later
      // well-meaning tween here would be motion the reference never shows.
      final List<DsShadowSpec> seen = <DsShadowSpec>[spec()];
      final TestGesture press =
          await t.startGesture(t.getCenter(find.byType(DsButton)));
      for (int i = 0; i < 8; i++) {
        await t.pump(const Duration(milliseconds: 16));
        seen.add(spec());
      }
      await press.up();
      for (int i = 0; i < 8; i++) {
        await t.pump(const Duration(milliseconds: 16));
        seen.add(spec());
      }

      expect(seen.first, same(DsShadows.btnPrimary));
      expect(seen[1], same(DsShadows.btnDown), reason: 'the very next frame');
      expect(seen.last, same(DsShadows.btnPrimary));
      for (final DsShadowSpec s in seen) {
        expect(
          identical(s, DsShadows.btnPrimary) || identical(s, DsShadows.btnDown),
          isTrue,
          reason: 'no third, interpolated value may ever appear',
        );
      }
    });

    testWidgets('B3 — premium\'s hover glow hard-cuts too',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        variant: DsButtonVariant.premium,
        onPressed: () {},
        child: const DsIcon(DsIconGlyph.menu),
      )));
      DsShadowSpec spec() =>
          t.widget<DsFoilValue>(find.byType(DsFoilValue)).spec;

      expect(spec(), same(DsShadows.btnValue));
      // Measured at **1.2ms** after `pointerover`: `--shadow-btn-value` (8
      // computed layers, insets) → `--shadow-glow-value` (6, none). Snap.
      await hoverOver(t, find.byType(DsButton));
      expect(spec(), same(DsShadows.glowValue));
    });

    testWidgets('B12 — the focus ring springs its spread 0 → 3.29 → 3',
        (WidgetTester t) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(host(DsButton(
        variant: DsButtonVariant.outline,
        focusNode: node,
        onPressed: () {},
        child: const DsIcon(DsIconGlyph.menu),
      )));

      // The ring lands in one of the token's leading transparent placeholder
      // slots, so the layer count and the per-layer `inset` flags never change
      // and `box-shadow` interpolates normally — the opposite case to B2/B3.
      expect(surfaceOf(t).spec, same(DsShadows.btn), reason: 'no ring at rest');

      node.requestFocus();
      await t.pump();
      double spread() => surfaceOf(t).spec.layers.first.spread;
      double alpha() =>
          surfaceOf(t).spec.layers.first.color(DsThemeData.dark).a;

      double peak = 0;
      double peakAlpha = 0;
      Duration peakAt = Duration.zero;
      double? firstFrame;
      for (int f = 1; f <= 20; f++) {
        await t.pump(const Duration(milliseconds: 16));
        firstFrame ??= spread();
        if (spread() > peak) {
          peak = spread();
          peakAlpha = alpha();
          peakAt = Duration(milliseconds: 16 * f);
        }
      }

      // It does not simply appear. Before this wave frame 1 was already 3.0.
      expect(firstFrame, lessThan(3));
      // Measured: 3.290px at Δ134 — `--ease-spring`'s +9.66% overshoot, at 54%
      // of the 250ms duration.
      expect(peak, closeTo(3.29, 0.02));
      expect(peakAt.inMilliseconds, closeTo(134, 40));
      // …and the ring's alpha tracks the spread in exact proportion, because
      // what interpolates is the whole layer from a transparent 0-spread
      // placeholder: measured 0.548 at the same frame the spread peaks.
      expect(peakAlpha, closeTo(0.5 * peak / 3, 1e-6));
      expect(peakAlpha, closeTo(0.548, 0.005));

      await t.pump(const Duration(milliseconds: 250));
      expect(spread(), closeTo(3, 1e-9));
      expect(alpha(), closeTo(0.5, 1e-9));
    });

    testWidgets('B11 — the disabled opacity springs, undershooting to 0.397',
        (WidgetTester t) async {
      Widget button({required bool enabled}) => host(DsButton(
            variant: DsButtonVariant.outline,
            onPressed: enabled ? () {} : null,
            child: const DsIcon(DsIconGlyph.menu),
          ));
      double opacity() => t
          .widget<Opacity>(find
              .descendant(
                of: find.byType(DsButton),
                matching: find.byType(Opacity),
              )
              .first)
          .opacity;

      await t.pumpWidget(button(enabled: true));
      expect(opacity(), 1.0);

      await t.pumpWidget(button(enabled: false));
      double lowest = 1;
      for (int i = 0; i < 20; i++) {
        await t.pump(const Duration(milliseconds: 16));
        if (opacity() < lowest) lowest = opacity();
      }
      // `opacity` IS in btn-spring's transition list, so it springs like the
      // colours: measured 1 → 0.3969 at Δ~180 → 0.45 at Δ~280, an undershoot of
      // (0.45 − 0.3969) / (1 − 0.45) = +9.65%.
      expect(lowest, closeTo(0.3969, 0.005));
      await t.pump(const Duration(milliseconds: 250));
      expect(opacity(), closeTo(0.45, 1e-9));
    });

    testWidgets('fires onPressed', (WidgetTester t) async {
      int presses = 0;
      await t.pumpWidget(host(DsButton(
        variant: DsButtonVariant.outline,
        onPressed: () => presses++,
        child: const DsIcon(DsIconGlyph.menu),
      )));

      await t.tap(find.byType(DsButton));
      await t.pump(DsDurations.base);
      expect(presses, 1);
    });

    testWidgets('a null onPressed disables it', (WidgetTester t) async {
      await t.pumpWidget(host(const DsButton(
        variant: DsButtonVariant.outline,
        child: DsIcon(DsIconGlyph.menu),
      )));

      await t.tap(find.byType(DsButton), warnIfMissed: false);
      await t.pump(DsDurations.base);
      expect(t.takeException(), isNull);

      final Opacity opacity = t.widget<Opacity>(find
          .descendant(of: find.byType(DsButton), matching: find.byType(Opacity))
          .first);
      expect(opacity.opacity, lessThan(1));
    });
  });

  group('the nine-rung cva ladder', () {
    // buttons-map §3.1, resolved to pixels. Every value below is the class the
    // reference declares, multiplied out: `--spacing` is 0.25rem, so `gap-1.5`
    // is 6 and `px-2.5` is 10.

    test('the enum is nine members in the cva\'s declaration order', () {
      expect(DsButtonSize.values, <DsButtonSize>[
        DsButtonSize.xs,
        DsButtonSize.sm,
        DsButtonSize.md,
        DsButtonSize.lg,
        DsButtonSize.xl,
        DsButtonSize.iconXs,
        DsButtonSize.iconSm,
        DsButtonSize.icon,
        DsButtonSize.iconLg,
      ]);
    });

    test('height — 24 / 32 / 40 / 48 / 56, squares included', () {
      expect(DsButton.heightFor(DsButtonSize.xs), 24);
      expect(DsButton.heightFor(DsButtonSize.sm), 32);
      expect(DsButton.heightFor(DsButtonSize.md), 40);
      expect(DsButton.heightFor(DsButtonSize.lg), 48);
      expect(DsButton.heightFor(DsButtonSize.xl), 56);
      expect(DsButton.heightFor(DsButtonSize.iconXs), 24);
      expect(DsButton.heightFor(DsButtonSize.iconSm), 32);
      expect(DsButton.heightFor(DsButtonSize.icon), 40);
      expect(DsButton.heightFor(DsButtonSize.iconLg), 48);
    });

    test('gap — 4 / 6 / 8 / 10 / 10, and none on any square', () {
      expect(DsButton.gapFor(DsButtonSize.xs), 4);
      expect(DsButton.gapFor(DsButtonSize.sm), 6);
      expect(DsButton.gapFor(DsButtonSize.md), 8);
      // `lg` and `xl` share `gap-2.5`; the ladder does not step here.
      expect(DsButton.gapFor(DsButtonSize.lg), 10);
      expect(DsButton.gapFor(DsButtonSize.xl), 10);
      for (final DsButtonSize square in DsButtonSize.values.where(
        DsButton.isSquare,
      )) {
        expect(DsButton.gapFor(square), 0, reason: '${square.name} declares no gap');
      }
    });

    test('padding-x — 10 / 14 / 16 / 24 / 32, and none on any square', () {
      expect(DsButton.paddingXFor(DsButtonSize.xs), 10);
      expect(DsButton.paddingXFor(DsButtonSize.sm), 14);
      expect(DsButton.paddingXFor(DsButtonSize.md), 16);
      expect(DsButton.paddingXFor(DsButtonSize.lg), 24);
      expect(DsButton.paddingXFor(DsButtonSize.xl), 32);
      for (final DsButtonSize square in DsButtonSize.values.where(
        DsButton.isSquare,
      )) {
        expect(DsButton.paddingXFor(square), 0);
      }
    });

    test('exactly four rungs are squares', () {
      expect(
        DsButtonSize.values.where(DsButton.isSquare),
        <DsButtonSize>[
          DsButtonSize.iconXs,
          DsButtonSize.iconSm,
          DsButtonSize.icon,
          DsButtonSize.iconLg,
        ],
      );
    });

    test('the svg override — 12 / 14 / 16 / 16 / 20 across the pairs', () {
      // `[&_svg:not([class*='size-'])]:size-*`. `md` and `lg` are the two text
      // rungs that never override the base `size-4`, which is why a 48px `lg`
      // button and a 40px `md` button hold the same 16px glyph.
      expect(DsButton.iconPxFor(DsButtonSize.xs), 12);
      expect(DsButton.iconPxFor(DsButtonSize.sm), 14);
      expect(DsButton.iconPxFor(DsButtonSize.md), 16);
      expect(DsButton.iconPxFor(DsButtonSize.lg), 16);
      expect(DsButton.iconPxFor(DsButtonSize.xl), 20);
      expect(DsButton.iconPxFor(DsButtonSize.iconXs), 12);
      expect(DsButton.iconPxFor(DsButtonSize.iconSm), 14);
      expect(DsButton.iconPxFor(DsButtonSize.icon), 16);
      expect(DsButton.iconPxFor(DsButtonSize.iconLg), 20);
    });

    test('five rungs, three type sizes, three leadings — drift 15', () {
      DsTypeSpec spec(DsButtonSize size) =>
          DsButton.typeFor(size, DsButtonEmphasis.none)!;

      // Three sizes across five rungs: only `xs` is unique.
      expect(spec(DsButtonSize.xs).size, 12);
      expect(spec(DsButtonSize.sm).size, 13);
      expect(spec(DsButtonSize.md).size, 13);
      expect(spec(DsButtonSize.lg).size, 15);
      expect(spec(DsButtonSize.xl).size, 15);

      // And the leadings do not agree with the sizes. `text-xs`, `text-sm` and
      // `text-base` are Tailwind steps repointed at this scale, so their stock
      // `--text-*--line-height` companions survive and apply to the new size;
      // `text-small` and `text-body` are bespoke, have no companion, and emit
      // font-size only.
      expect(spec(DsButtonSize.xs).height, closeTo(1 / 0.75, 1e-12));
      expect(spec(DsButtonSize.sm).height, isNull);
      expect(spec(DsButtonSize.md).height, closeTo(1.25 / 0.875, 1e-12));
      expect(spec(DsButtonSize.lg).height, isNull);
      expect(spec(DsButtonSize.xl).height, closeTo(1.5 / 1, 1e-12));

      // Computed line boxes: 16.0 / — / 18.571 / — / 22.5.
      expect(spec(DsButtonSize.xs).height! * 12, closeTo(16.0, 1e-9));
      expect(spec(DsButtonSize.md).height! * 13, closeTo(18.571, 1e-3));
      expect(spec(DsButtonSize.xl).height! * 15, closeTo(22.5, 1e-9));

      // Every text rung is `font-medium`.
      for (final DsButtonSize size in <DsButtonSize>[
        DsButtonSize.xs,
        DsButtonSize.sm,
        DsButtonSize.md,
        DsButtonSize.lg,
        DsButtonSize.xl,
      ]) {
        expect(spec(size).weight, FontWeight.w500);
      }
    });

    test('the four squares declare no text class at all', () {
      for (final DsButtonSize square in DsButtonSize.values.where(
        DsButton.isSquare,
      )) {
        expect(
          DsButton.typeFor(square, DsButtonEmphasis.none),
          isNull,
          reason: '${square.name} sets no text-*; it inherits from the page',
        );
      }
    });

    testWidgets('a square rung inherits the page\'s type and takes only ink',
        (WidgetTester t) async {
      // The CSS consequence of the null above: an `icon-*` button changes the
      // colour of the text inside it and nothing else.
      const TextStyle ambient = TextStyle(fontSize: 31, fontFamily: 'Ambient');
      await t.pumpWidget(host(DefaultTextStyle(
        style: ambient,
        child: DsButton(
          variant: DsButtonVariant.ghost,
          size: DsButtonSize.icon,
          onPressed: () {},
          child: const Text('x'),
        ),
      )));

      final TextStyle resolved = t
          .widget<DefaultTextStyle>(find
              .descendant(
                of: find.byType(DsButton),
                matching: find.byType(DefaultTextStyle),
              )
              .first)
          .style;
      expect(resolved.fontSize, 31);
      expect(resolved.fontFamily, 'Ambient');
      expect(resolved.color, DsThemeData.dark.mutedForeground);
    });
  });

  group('DsButton emphasis: caps', () {
    TextStyle labelStyleOf(WidgetTester t) => t
        .widget<DefaultTextStyle>(find
            .descendant(
              of: find.byType(DsButton),
              matching: find.byType(DefaultTextStyle),
            )
            .first)
        .style;

    testWidgets('is 12px / 600 / 0.09em on every rung, including default',
        (WidgetTester t) async {
      for (final DsButtonSize size in DsButtonSize.values) {
        await t.pumpWidget(host(DsButton(
          variant: DsButtonVariant.premium,
          size: size,
          emphasis: DsButtonEmphasis.caps,
          onPressed: () {},
          child: const Text('Claim Reward'),
        )));

        final TextStyle style = labelStyleOf(t);
        expect(style.fontSize, 12, reason: '${size.name}: text-num-sm');
        // `--tracking-cta: 0.09em`, resolved against the 12px size.
        expect(style.letterSpacing, closeTo(0.09 * 12, 1e-9),
            reason: '${size.name}: tracking-cta');
        expect(
          style.fontVariations!
              .firstWhere((FontVariation v) => v.axis == 'wght')
              .value,
          600,
          reason: '${size.name}: font-semibold',
        );
      }
    });

    testWidgets('shrinks the default rung from 13px to 12 — drift 22',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        onPressed: () {},
        child: const Text('Open Pack'),
      )));
      expect(labelStyleOf(t).fontSize, 13);

      await t.pumpWidget(host(DsButton(
        emphasis: DsButtonEmphasis.caps,
        onPressed: () {},
        child: const Text('Claim Reward'),
      )));
      expect(labelStyleOf(t).fontSize, 12);
    });

    testWidgets('uppercases the glyphs and leaves the accessible name alone',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        variant: DsButtonVariant.premium,
        emphasis: DsButtonEmphasis.caps,
        onPressed: () {},
        child: const Text('Claim Reward'),
      )));

      final Text rendered = t.widget<Text>(find.descendant(
        of: find.byType(DsButton),
        matching: find.byType(Text),
      ));
      // `text-transform` repaints the glyphs; the DOM text — and therefore the
      // accessible name — stays as authored.
      expect(rendered.data, 'CLAIM REWARD');
      expect(rendered.semanticsLabel, 'Claim Reward');
    });

    testWidgets('leaves a non-Text child alone', (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        emphasis: DsButtonEmphasis.caps,
        onPressed: () {},
        child: const DsIcon(DsIconGlyph.menu),
      )));
      expect(t.takeException(), isNull);
      expect(find.byType(DsIcon), findsOneWidget);
    });
  });

  group('DsButton.loading', () {
    testWidgets('prepends a spinner and disables the button',
        (WidgetTester t) async {
      int presses = 0;
      await t.pumpWidget(host(DsButton(
        loading: true,
        onPressed: () => presses++,
        child: const Text('Saving'),
      )));

      expect(find.byType(DsSpinner), findsOneWidget);
      // The spinner leads: `<>{loading && <Spinner />}{children}</>`.
      final Offset spinner = t.getCenter(find.byType(DsSpinner));
      final Offset label = t.getCenter(find.text('Saving'));
      expect(spinner.dx, lessThan(label.dx));

      // `disabled = disabled || loading` — the callback is live and still must
      // not fire.
      await t.tap(find.byType(DsButton), warnIfMissed: false);
      await t.pump(DsDurations.base);
      expect(presses, 0);

      final Opacity opacity = t.widget<Opacity>(find
          .descendant(of: find.byType(DsButton), matching: find.byType(Opacity))
          .first);
      expect(opacity.opacity, 0.45);
    });

    testWidgets('the width DOES jump, by 24px on the default rung — drift 3',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        onPressed: () {},
        child: const Text('Saving'),
      )));
      final double resting = t.getSize(find.byType(DsButton)).width;

      await t.pumpWidget(host(DsButton(
        loading: true,
        onPressed: () {},
        child: const Text('Saving'),
      )));
      final double busy = t.getSize(find.byType(DsButton)).width;

      // 16px of glyph plus the rung's own `gap-2`. Four separate sentences in
      // the reference say this does not happen.
      expect(busy - resting,
          closeTo(DsSpinner.px + DsButton.gapFor(DsButtonSize.md), 1e-9));
    });

    testWidgets('the gap in front of the label is the rung\'s own',
        (WidgetTester t) async {
      for (final DsButtonSize size in <DsButtonSize>[
        DsButtonSize.xs,
        DsButtonSize.sm,
        DsButtonSize.md,
        DsButtonSize.lg,
        DsButtonSize.xl,
      ]) {
        await t.pumpWidget(host(DsButton(
          size: size,
          onPressed: () {},
          child: const Text('Saving'),
        )));
        final double resting = t.getSize(find.byType(DsButton)).width;

        await t.pumpWidget(host(DsButton(
          size: size,
          loading: true,
          onPressed: () {},
          child: const Text('Saving'),
        )));
        final double busy = t.getSize(find.byType(DsButton)).width;

        expect(busy - resting, closeTo(DsSpinner.px + DsButton.gapFor(size), 1e-9),
            reason: '${size.name}: spinner + gap-*');
      }
    });

    testWidgets('exposes the disabled half of aria-busy — ruling B9',
        (WidgetTester t) async {
      // `aria-busy` has no analogue in the pinned SDK; what a loading button
      // can still say is that it is not actionable, which is the state the
      // reference's `disabled = disabled || loading` puts it in.
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(host(DsButton(
        loading: true,
        label: 'Save Account',
        onPressed: () {},
        child: const Text('Saving'),
      )));

      // `isSemantics`, not `matchesSemantics`: the assertion is about three
      // flags, and a whole-node match would also be pinning whichever actions
      // the gesture layer happens to expose under an `IgnorePointer`.
      expect(
        t.getSemantics(find.byType(DsButton).first),
        isSemantics(
          label: 'Save Account',
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
        ),
      );
      handle.dispose();
    });
  });

  group('DsSpinner', () {
    testWidgets('is 16px and turns once every 900ms, linearly',
        (WidgetTester t) async {
      await t.pumpWidget(host(const DsSpinner()));

      expect(t.getSize(find.byType(DsSpinner)), const Size(16, 16));

      double turnsNow() =>
          t.widget<RotationTransition>(find.byType(RotationTransition))
              .turns
              .value;

      expect(turnsNow(), 0);
      // Quarter of `pulls-spin`'s 0.9s. `linear` on purpose — a quarter of the
      // clock has to be a quarter of the turn, or the spinner is easing.
      await t.pump(const Duration(milliseconds: 225));
      expect(turnsNow(), closeTo(0.25, 1e-6));
      await t.pump(const Duration(milliseconds: 225));
      expect(turnsNow(), closeTo(0.5, 1e-6));
      await t.pump(const Duration(milliseconds: 225));
      expect(turnsNow(), closeTo(0.75, 1e-6));

      // It repeats forever, so it is never allowed to settle — land the test
      // on a still frame rather than pumping to quiescence.
      await t.pumpWidget(host(const SizedBox()));
    });

    testWidgets('is silent to assistive tech — drift 4, ruling B9',
        (WidgetTester t) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(host(const DsSpinner()));
      // `role="status"` and `aria-label="Loading"` are handed to `Icon` and
      // dropped by its destructure; the glyph renders `aria-hidden`.
      expect(find.byType(ExcludeSemantics), findsWidgets);
      expect(
        t.getSemantics(find.byType(DsSpinner)).label,
        isEmpty,
      );
      handle.dispose();
      await t.pumpWidget(host(const SizedBox()));
    });

    testWidgets('reduced motion holds it upright at 0° — ruling B13',
        (WidgetTester t) async {
      await t.pumpWidget(MediaQuery(
        data: const MediaQueryData(
          size: Size(1440, 900),
          disableAnimations: true,
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: DsTheme(
            controller: DsThemeController(mode: DsThemeMode.dark),
            child: const Center(child: DsSpinner()),
          ),
        ),
      ));

      double turnsNow() =>
          t.widget<RotationTransition>(find.byType(RotationTransition))
              .turns
              .value;

      // `pulls-spin` declares no fill mode, so the blanket reduced-motion rule
      // leaves it at the element's resting style rather than its final stop.
      expect(turnsNow(), 0);
      await t.pump(DsDurations.spin);
      expect(turnsNow(), 0);
      await t.pump(DsDurations.spin);
      expect(turnsNow(), 0);
    });
  });

  group('DsToggle', () {
    DsMachineSurface surfaceOf(WidgetTester t) =>
        t.widget<DsMachineSurface>(find.descendant(
          of: find.byType(DsToggle),
          matching: find.byType(DsMachineSurface),
        ).first);

    Widget toggle({
      bool pressed = false,
      bool enabled = true,
      DsToggleSize size = DsToggleSize.md,
      DsToggleVariant variant = DsToggleVariant.standard,
    }) =>
        host(DsToggle(
          pressed: pressed,
          size: size,
          variant: variant,
          label: 'Favourite',
          onChanged: enabled ? (bool _) {} : null,
          child: const DsIcon(DsIconGlyph.heart),
        ));

    testWidgets('is 32 tall with a 32 floor and a 12px radius — not a pill',
        (WidgetTester t) async {
      await t.pumpWidget(toggle());
      final Size box = t.getSize(find.byType(DsToggle));
      // `h-8 min-w-8 px-2.5` around a 16px glyph: 16 + 20 = 36 × 32.
      expect(box.height, ds(8));
      expect(box.width, ds(9));
      expect(
        surfaceOf(t).radius,
        BorderRadius.circular(DsRadii.lg),
        reason: 'rounded-lg — a Toggle is not a pill',
      );
    });

    test('the ladder: 28 / 32 / 36, and sm clamps its own radius', () {
      expect(DsToggle.heightFor(DsToggleSize.sm), 28);
      expect(DsToggle.heightFor(DsToggleSize.md), 32);
      expect(DsToggle.heightFor(DsToggleSize.lg), 36);
      expect(DsToggle.minWidthFor(DsToggleSize.sm), 28);
      expect(DsToggle.minWidthFor(DsToggleSize.md), 32);
      expect(DsToggle.minWidthFor(DsToggleSize.lg), 36);
      // `rounded-[min(var(--radius-md),12px)]` — 10px today, and it stays a
      // live clamp so a rebrand that raises --radius-md still ceilings at 12.
      expect(DsToggle.radiusFor(DsToggleSize.sm), DsRadii.md);
      expect(DsToggle.radiusFor(DsToggleSize.md), DsRadii.lg);
      expect(DsToggle.radiusFor(DsToggleSize.lg), DsRadii.lg);
      // All three rungs declare the same `px-2.5` and `gap-1`.
      expect(DsToggle.paddingX, 10);
      expect(DsToggle.gap, 4);
    });

    testWidgets('rest is bare — no fill, no border box, no shadow',
        (WidgetTester t) async {
      await t.pumpWidget(toggle());
      final DsMachineSurface surface = surfaceOf(t);
      expect(surface.fill, dsTransparent);
      // `variant="default"` is `bg-transparent` with no `border` class at all,
      // which is exactly why `focus-visible:border-ring` is inert on it.
      expect(surface.border, isNull);
      expect(surface.spec.layers.single.color(DsThemeData.dark).a, 0);
    });

    testWidgets('hover fills with --muted and moves no ink — drift 10',
        (WidgetTester t) async {
      await t.pumpWidget(toggle());
      final Color restingInk = t
          .widget<DefaultTextStyle>(find.descendant(
            of: find.byType(DsToggle),
            matching: find.byType(DefaultTextStyle),
          ).first)
          .style
          .color!;

      await hoverOver(t, find.byType(DsToggle));
      await t.pump(DsDurations.base);
      await t.pump(DsDurations.base);

      expect(surfaceOf(t).fill, DsThemeData.dark.muted);
      // `hover:text-foreground` restates the colour the element already
      // inherits: the base sets no resting ink, so the hover half is inert.
      expect(
        t
            .widget<DefaultTextStyle>(find.descendant(
              of: find.byType(DsToggle),
              matching: find.byType(DefaultTextStyle),
            ).first)
            .style
            .color,
        restingInk,
      );
      expect(restingInk, DsThemeData.dark.foreground);
    });

    testWidgets('the pressed fill is --muted — GREY, not blue — drift 5',
        (WidgetTester t) async {
      await t.pumpWidget(toggle(pressed: true));
      await t.pump(DsDurations.base);
      await t.pump(DsDurations.base);
      // The panel's own caption says "the pressed state fills with the blue
      // tint — selection is always blue". `data-[state=on]:bg-muted` says
      // otherwise, and blue selection is real one panel further down.
      expect(surfaceOf(t).fill, DsThemeData.dark.muted);
      expect(surfaceOf(t).fill, isNot(DsThemeData.dark.primary));
    });

    testWidgets('disabled is 50%, not the Button\'s 45% — drift 12',
        (WidgetTester t) async {
      await t.pumpWidget(toggle(enabled: false));
      final Opacity opacity = t.widget<Opacity>(find
          .descendant(of: find.byType(DsToggle), matching: find.byType(Opacity))
          .first);
      expect(opacity.opacity, 0.50);
    });

    testWidgets('has no press feedback at all — drift 11',
        (WidgetTester t) async {
      await t.pumpWidget(toggle());
      // A Toggle's class list has no `:active` rule and no `press` utility, so
      // nothing may scale it — measured (audit G2): `scale` and `transform`
      // both read `none` in every state, `:active` included. `DsButton` does
      // not reach for `DsPress` either any more (B1) — it snaps its own scale —
      // but this assertion is about the utility being absent, which is what a
      // regression here would reintroduce.
      expect(
        find.descendant(
          of: find.byType(DsToggle),
          matching: find.byType(DsPress),
        ),
        findsNothing,
      );

      final TestGesture hold =
          await t.startGesture(t.getCenter(find.byType(DsToggle)));
      await t.pump(DsDurations.tick);
      final Size held = t.getSize(find.byType(DsToggle));
      expect(held.height, ds(8));
      await hold.up();
      await t.pump(DsDurations.base);
    });

    testWidgets('focus draws the 3px ring at --ring @50%',
        (WidgetTester t) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(host(DsToggle(
        pressed: false,
        focusNode: node,
        label: 'Favourite',
        onChanged: (bool _) {},
        child: const DsIcon(DsIconGlyph.heart),
      )));

      node.requestFocus();
      await t.pump();
      await t.pump(DsDurations.base);
      await t.pump(DsDurations.base);

      final DsShadowLayer ring = surfaceOf(t).spec.layers.single;
      expect(ring.spread, 3);
      expect(ring.blur, 0);
      expect(
        ring.color(DsThemeData.dark),
        DsThemeData.dark.ring.withValues(alpha: 0.50),
      );
    });

    testWidgets('toggles on tap and on Space', (WidgetTester t) async {
      final List<bool> changes = <bool>[];
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(host(DsToggle(
        pressed: false,
        focusNode: node,
        label: 'Favourite',
        onChanged: changes.add,
        child: const DsIcon(DsIconGlyph.heart),
      )));

      await t.tap(find.byType(DsToggle));
      await t.pump();
      node.requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.space);
      await t.pump();
      // Both routes ask for the opposite of the state they were handed.
      expect(changes, <bool>[true, true]);
    });
  });

  group('DsToggleGroup', () {
    Widget group({int? selected, ValueChanged<int?>? onChanged}) =>
        host(DsToggleGroup(
          selectedIndex: selected,
          onChanged: onChanged ?? (int? _) {},
          items: const <DsToggleGroupItem>[
            DsToggleGroupItem(label: 'Newest'),
            DsToggleGroupItem(label: 'Price'),
            DsToggleGroupItem(label: 'Popular'),
          ],
        ));

    test('the group gap is `--gap: 2`, i.e. 8px', () {
      expect(DsToggleGroup.gap, ds(2));
    });

    testWidgets('lays three items out 8px apart', (WidgetTester t) async {
      await t.pumpWidget(group(selected: 0));
      await t.pump();

      final Rect first = t.getRect(find.byType(DsToggle).at(0));
      final Rect second = t.getRect(find.byType(DsToggle).at(1));
      expect(second.left - first.right, closeTo(ds(2), 1e-9));
    });

    testWidgets('the pill is a --primary stadium over a 12px item — drift 9',
        (WidgetTester t) async {
      await t.pumpWidget(group(selected: 0));
      await t.pump();
      await t.pump();

      // The pill: `bg-primary rounded-pill shadow-chip`.
      final DsMachineSurface pill = t.widget<DsMachineSurface>(
        find.descendant(
          of: find.byType(DsSlidingPillGroup),
          matching: find.byType(DsMachineSurface),
        ).first,
      );
      expect(pill.fill, DsThemeData.dark.primary);
      expect(pill.radius, BorderRadius.circular(DsRadii.pill));
      expect(pill.spec, same(DsShadows.chip));

      // The item underneath it is still `rounded-lg`. Two shapes, one slot:
      // hover-on-unselected paints a 12px rect where selection paints a
      // 16px stadium.
      final DsMachineSurface item = t.widget<DsMachineSurface>(
        find.descendant(
          of: find.byType(DsToggle).at(0),
          matching: find.byType(DsMachineSurface),
        ).first,
      );
      expect(item.radius, BorderRadius.circular(DsRadii.lg));
    });

    testWidgets('the selected item gives up its fill and flips to white ink',
        (WidgetTester t) async {
      await t.pumpWidget(group(selected: 1));
      await t.pump(DsDurations.base);
      await t.pump(DsDurations.base);

      DsMachineSurface itemAt(int i) => t.widget<DsMachineSurface>(
            find.descendant(
              of: find.byType(DsToggle).at(i),
              matching: find.byType(DsMachineSurface),
            ).first,
          );
      TextStyle inkAt(int i) => t
          .widget<DefaultTextStyle>(find.descendant(
            of: find.byType(DsToggle).at(i),
            matching: find.byType(DefaultTextStyle),
          ).first)
          .style;

      // `data-[state=on]:bg-transparent` — declared last on purpose, because
      // the pill is the background now.
      expect(itemAt(1).fill, dsTransparent);
      expect(inkAt(1).color, DsThemeData.dark.primaryForeground);
      // Its unselected neighbours are unchanged.
      expect(itemAt(0).fill, dsTransparent);
      expect(inkAt(0).color, DsThemeData.dark.foreground);
    });

    testWidgets('tapping the selected item deselects — ruling B7',
        (WidgetTester t) async {
      final List<int?> changes = <int?>[];
      await t.pumpWidget(group(selected: 1, onChanged: changes.add));
      await t.pump();

      // Radix `type="single"` clears on a second press of the active item.
      await t.tap(find.byType(DsToggle).at(1));
      await t.pump();
      expect(changes, <int?>[null]);

      // And an unselected neighbour still selects normally.
      await t.tap(find.byType(DsToggle).at(2));
      await t.pump();
      expect(changes, <int?>[null, 2]);
    });

    testWidgets('nothing selected hides the pill', (WidgetTester t) async {
      await t.pumpWidget(group(selected: null));
      await t.pump();
      await t.pump();
      await t.pump(DsDurations.fast);
      await t.pump(DsDurations.fast);

      // `activeIndex: -1` — the substrate's documented out-of-range path, and
      // the reason it exists at all.
      final AnimatedOpacity fade = t.widget<AnimatedOpacity>(find.descendant(
        of: find.byType(DsSlidingPillGroup),
        matching: find.byType(AnimatedOpacity),
      ).first);
      expect(fade.opacity, 0);
    });
  });

  group('DsButtonGroup', () {
    // The three groups the page renders, verbatim (buttons-map §6.2).
    List<Widget> groupA() => <Widget>[
          DsButton(
            variant: DsButtonVariant.outline,
            onPressed: () {},
            child: const Text('Newest'),
          ),
          DsButton(
            variant: DsButtonVariant.outline,
            onPressed: () {},
            child: const Text('Price'),
          ),
          DsButton(
            variant: DsButtonVariant.outline,
            onPressed: () {},
            child: const Text('Popularity'),
          ),
        ];

    List<Widget> groupB() => <Widget>[
          const DsButtonGroupText('Quantity'),
          const DsButtonGroupSeparator(),
          DsButton(
            variant: DsButtonVariant.outline,
            size: DsButtonSize.icon,
            label: 'Decrease quantity',
            onPressed: () {},
            child: const DsIcon(DsIconGlyph.minus),
          ),
          const DsButtonGroupText('3', numeric: true),
          DsButton(
            variant: DsButtonVariant.outline,
            size: DsButtonSize.icon,
            label: 'Increase quantity',
            onPressed: () {},
            child: const DsIcon(DsIconGlyph.plus),
          ),
        ];

    List<Widget> groupC() => <Widget>[
          DsButton(onPressed: () {}, child: const Text('Open Pack')),
          const DsButtonGroupSeparator(),
          DsButton(
            size: DsButtonSize.icon,
            label: 'More open options',
            onPressed: () {},
            child: const DsIcon(DsIconGlyph.chevronDown),
          ),
        ];

    test('group A: pill on the left, 12px on the right — drift 7', () {
      final List<Widget> a = groupA();
      // The leading member keeps its own radius; the trailing one is forced to
      // `--radius-lg` by an `!important` rule. Asymmetric by construction.
      expect(DsButtonGroup.radiiOf(a, 0).topLeft.x, DsRadii.pill);
      expect(DsButtonGroup.radiiOf(a, 0).topRight.x, 0);
      // Interior corners are squared on both sides.
      expect(DsButtonGroup.radiiOf(a, 1).topLeft.x, 0);
      expect(DsButtonGroup.radiiOf(a, 1).topRight.x, 0);
      expect(DsButtonGroup.radiiOf(a, 2).topLeft.x, 0);
      expect(DsButtonGroup.radiiOf(a, 2).topRight.x, DsRadii.lg);
    });

    test('group B is symmetric only because it opens with a Text cell', () {
      final List<Widget> b = groupB();
      // 12px both ends — and the left 12 is the `ButtonGroupText`'s own
      // `rounded-lg`, not anything the group did.
      expect(DsButtonGroup.radiiOf(b, 0).topLeft.x, DsRadii.lg);
      expect(DsButtonGroup.radiiOf(b, 4).topRight.x, DsRadii.lg);
    });

    test('group C: pill left, 12px right', () {
      final List<Widget> c = groupC();
      expect(DsButtonGroup.radiiOf(c, 0).topLeft.x, DsRadii.pill);
      expect(DsButtonGroup.radiiOf(c, 2).topRight.x, DsRadii.lg);
    });

    test('the rounding rule reaches PAST a Text cell — drift 8', () {
      // `ButtonGroupText` sets no `data-slot`, so it can never satisfy
      // `[&>[data-slot]:not(:has(~[data-slot]))]` and the rule lands on the
      // last member that can — here the Button, which is not last.
      final List<Widget> trailing = <Widget>[
        DsButton(onPressed: () {}, child: const Text('Open Pack')),
        const DsButtonGroupText('of 12'),
      ];
      expect(DsButtonGroup.radiiOf(trailing, 0).topRight.x, DsRadii.lg,
          reason: 'an interior Button forced to 12px by the reach-past');
    });

    test('only the first member keeps a left border — border-l-0', () {
      final List<Widget> a = groupA();
      expect(DsButtonGroup.hasLeftBorder(a, 0), isTrue);
      expect(DsButtonGroup.hasLeftBorder(a, 1), isFalse);
      expect(DsButtonGroup.hasLeftBorder(a, 2), isFalse);
    });

    testWidgets('members are flush and stretch to the tallest',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButtonGroup(children: groupB())));

      // `items-stretch` is what gives the height-less Text cell its 40px.
      final double rowHeight = t.getSize(find.byType(DsButtonGroup)).height;
      expect(rowHeight, ds(10));
      expect(t.getSize(find.byType(DsButtonGroupText).first).height, ds(10));

      // `gap` is 0 — the `has-[>[data-slot=button-group]]:gap-2` rule needs a
      // nested group, and nothing on this page nests.
      final Rect text = t.getRect(find.byType(DsButtonGroupText).first);
      final Rect rule = t.getRect(find.byType(DsButtonGroupSeparator));
      expect(rule.left, closeTo(text.right, 1e-9));
    });

    testWidgets('the separator is 1px wide and inset 1px top and bottom',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButtonGroup(children: groupC())));

      // `self-stretch` makes the separator's own box the full row height…
      expect(t.getSize(find.byType(DsButtonGroupSeparator)).height, ds(10));

      // …and `my-px` is a *margin*, so the painted rule stops one pixel short
      // at each end. `w-px` is the width.
      final Size rule = t.getSize(find.descendant(
        of: find.byType(DsButtonGroupSeparator),
        matching: find.byType(ColoredBox),
      ));
      expect(rule.width, DsWidths.hairline);
      expect(rule.height, ds(10) - 2 * DsWidths.hairline);
    });

    testWidgets('a Text cell is --muted at 13/500, 10px in from its border',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButtonGroup(children: groupB())));

      final DecoratedBox box = t.widget<DecoratedBox>(find.descendant(
        of: find.byType(DsButtonGroupText).first,
        matching: find.byType(DecoratedBox),
      ).first);
      expect((box.decoration as BoxDecoration).color, DsThemeData.dark.muted);
      expect(DsButtonGroupText.paddingX, 10);

      final TextStyle style = t.widget<Text>(find.descendant(
        of: find.byType(DsButtonGroupText).first,
        matching: find.byType(Text),
      )).style!;
      expect(style.fontSize, 13);
      expect(style.fontFamily, contains('InterLocal'));
    });

    testWidgets('className="type-num" renders 13px/500 mono — drift 16',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButtonGroup(children: groupB())));

      final TextStyle style = t.widget<Text>(find.descendant(
        of: find.byType(DsButtonGroupText).at(1),
        matching: find.byType(Text),
      )).style!;
      // The utilities beat `.type-num` on the two properties they share…
      expect(style.fontSize, 13, reason: 'text-sm beats --text-body 15');
      expect(
        style.fontVariations!
            .firstWhere((FontVariation v) => v.axis == 'wght')
            .value,
        500,
        reason: 'font-medium beats .type-num\'s 600',
      );
      // …and everything they do not declare survives.
      expect(style.fontFamily, contains('GeistMono'));
      expect(style.letterSpacing, closeTo(-0.01 * 13, 1e-9));
      expect(style.fontFeatures, contains(const FontFeature.tabularFigures()));
    });
  });

  group('DsKbd', () {
    test('20 tall, 20 minimum wide, 4px padding, 4px gaps', () {
      expect(DsKbd.height, 20);
      expect(DsKbd.minWidth, 20);
      expect(DsKbd.paddingX, 4);
      expect(DsKbd.gap, 4);
      expect(DsKbdGroup.gap, 4);
    });

    testWidgets('is a flat 6px --muted chip — no border, no shadow — drift 18',
        (WidgetTester t) async {
      await t.pumpWidget(host(const DsKbd('Esc')));

      final DsMachineSurface surface = t.widget<DsMachineSurface>(
        find.descendant(
          of: find.byType(DsKbd),
          matching: find.byType(DsMachineSurface),
        ).first,
      );
      expect(surface.fill, DsThemeData.dark.muted);
      expect(surface.radius, BorderRadius.circular(DsRadii.sm));
      // `--shadow-key`, `--shadow-key-down` and `press-key` all exist for
      // exactly this object, one foundations page away, and Kbd uses none.
      expect(surface.spec.layers, isEmpty);
      expect(surface.border, isNull);
    });

    testWidgets('is 20px tall and never narrower than 20', (WidgetTester t) async {
      await t.pumpWidget(host(const DsKbd('K')));
      final Size box = t.getSize(find.byType(DsKbd));
      expect(box.height, 20);
      // A single narrow glyph plus 4+4 of padding is under the floor, so
      // `min-w-5` decides.
      expect(box.width, 20);

      await t.pumpWidget(host(const DsKbd('Space')));
      expect(t.getSize(find.byType(DsKbd)).width, greaterThan(20));
    });

    testWidgets('the key label is 12px/500 at --muted-foreground',
        (WidgetTester t) async {
      await t.pumpWidget(host(const DsKbd('Ctrl')));
      final TextStyle style = t.widget<Text>(find.descendant(
        of: find.byType(DsKbd),
        matching: find.byType(Text),
      )).style!;
      expect(style.fontSize, 12);
      expect(style.color, DsThemeData.dark.mutedForeground);
    });

    testWidgets('a group is one shortcut, 4px apart — drift 19',
        (WidgetTester t) async {
      await t.pumpWidget(host(const DsKbdGroup(children: <Widget>[
        DsKbd('Ctrl'),
        DsKbd('K'),
      ])));

      final Rect ctrl = t.getRect(find.byType(DsKbd).at(0));
      final Rect k = t.getRect(find.byType(DsKbd).at(1));
      expect(k.left - ctrl.right, closeTo(DsKbdGroup.gap, 1e-9));

      // `<kbd><kbd>Ctrl</kbd><kbd>K</kbd></kbd>` is one keyboard object, and
      // it is announced as one.
      expect(
        find.descendant(
          of: find.byType(DsKbdGroup),
          matching: find.byType(MergeSemantics),
        ),
        findsOneWidget,
      );
    });
  });

  group('DsIconSwap', () {
    Widget swap(int active) => host(DsIconSwap(
          activeIndex: active,
          window: 20,
          cell: 16,
          icons: const <Widget>[
            DsIcon(DsIconGlyph.layoutGrid),
            DsIcon(DsIconGlyph.rows3),
          ],
        ));

    testWidgets('is a fixed clip window, whatever the strip is doing',
        (WidgetTester t) async {
      await t.pumpWidget(swap(0));
      expect(t.getSize(find.byType(DsIconSwap)), const Size(20, 20));
    });

    test('an unknown index clamps to 0, as Math.max(0, indexOf) does', () {
      expect(DsIconSwap.resolveIndex(-1, 2), 0);
      expect(DsIconSwap.resolveIndex(7, 2), 0);
      expect(DsIconSwap.resolveIndex(1, 2), 1);
    });

    testWidgets('the leaver exits through the top and the arriver rises',
        (WidgetTester t) async {
      await t.pumpWidget(swap(0));
      await t.pump(DsSwapRoll.duration);
      await t.pump(DsSwapRoll.duration);

      double yOf(int i) => t.getRect(find.byType(DsIcon).at(i)).center.dy;
      final double windowCentre =
          t.getRect(find.byType(DsIconSwap)).center.dy;

      // At rest: glyph 0 centred, glyph 1 parked one full step BELOW.
      expect(yOf(0), closeTo(windowCentre, 0.51));
      expect(yOf(1) - yOf(0), closeTo(DsSwapRoll.travelFor(16), 0.51));

      await t.pumpWidget(swap(1));
      await t.pump(DsSwapRoll.duration);
      await t.pump(DsSwapRoll.duration);
      await t.pump(DsJelly.duration);

      // After the roll the strip has moved up by exactly one step: glyph 1 is
      // centred and glyph 0 has left through the top.
      expect(yOf(1), closeTo(windowCentre, 0.51));
      expect(yOf(0), lessThan(windowCentre));
      expect(yOf(1) - yOf(0), closeTo(DsSwapRoll.travelFor(16), 0.51));
    });

    testWidgets('the arriving glyph squashes on FIRST MOUNT too',
        (WidgetTester t) async {
      // The one place IconSwap is the inverse of the sliding pill: the pill
      // deliberately lands its first placement silently, and every IconSwap
      // demo deliberately squashes once on page load.
      List<double> scalesUnderSwap() => t
          .widgetList<Transform>(find.descendant(
            of: find.byType(DsIconSwap),
            matching: find.byType(Transform),
          ))
          .map((Transform x) => x.transform.storage[0])
          .toList();

      await t.pumpWidget(swap(0));
      await t.pump();

      // `animation-delay: var(--duration-fast)` — still identity at 150ms…
      await t.pump(DsSwapRoll.squashDelay);
      expect(scalesUnderSwap().every((double s) => (s - 1).abs() < 1e-6), isTrue,
          reason: 'the delay holds stop 0');

      // …and 30% into the 600ms jelly it is at the table's widest stop, 1.18.
      await t.pump(const Duration(milliseconds: 180));
      expect(scalesUnderSwap().any((double s) => s > 1.1), isTrue);

      // It settles back to identity by the end of the run.
      await t.pump(DsJelly.duration);
      expect(scalesUnderSwap().every((double s) => (s - 1).abs() < 1e-6), isTrue);
    });

    testWidgets('reduced motion lands the swap instantly — ruling B13',
        (WidgetTester t) async {
      Widget stilled(int active) => MediaQuery(
            data: const MediaQueryData(
              size: Size(1440, 900),
              disableAnimations: true,
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: DsTheme(
                controller: DsThemeController(mode: DsThemeMode.dark),
                child: Center(
                  child: DsIconSwap(
                    activeIndex: active,
                    window: 20,
                    cell: 16,
                    icons: const <Widget>[
                      DsIcon(DsIconGlyph.play),
                      DsIcon(DsIconGlyph.pause),
                    ],
                  ),
                ),
              ),
            ),
          );

      await t.pumpWidget(stilled(0));
      await t.pump();
      await t.pumpWidget(stilled(1));
      // One frame, no waiting: instant, not disabled and not frozen part-way.
      await t.pump();
      await t.pump();

      final double windowCentre =
          t.getRect(find.byType(DsIconSwap)).center.dy;
      expect(t.getRect(find.byType(DsIcon).at(1)).center.dy,
          closeTo(windowCentre, 0.51));
    });

    /* ── S1–S8: guards over measured-correct behaviour ────────────────────── */

    // `docs/superpowers/research/behavior-audit.md` §2.4 traced all eight legs
    // of this module against the reference in the browser and found **every
    // one a match** — the only module of the three audited that was wholly
    // correct. These guards exist for that reason and not despite it: the
    // audit's own §"Explicitly protect" lists the icon swap entire, and a leg
    // with no test is a leg a well-meaning later "fix" can quietly retune. Each
    // number below is the measured web value, not a derivation.

    double centre(WidgetTester t) =>
        t.getRect(find.byType(DsIconSwap)).center.dy;
    double yOf(WidgetTester t, int i) =>
        t.getRect(find.byType(DsIcon).at(i)).center.dy;
    List<double> opacities(WidgetTester t) => t
        .widgetList<Opacity>(find.descendant(
          of: find.byType(DsIconSwap),
          matching: find.byType(Opacity),
        ))
        .map((Opacity o) => o.opacity)
        .toList();

    testWidgets('S1: the strip travels 160% of the CELL, at both call sites',
        (WidgetTester t) async {
      // Measured 25.6px against a 16px glyph. A CSS percentage translate
      // resolves against the element's own border box, so the multiplier hangs
      // off the cell and never off the 20/24px clip window.
      expect(DsSwapRoll.travelFor(16), closeTo(25.6, 1e-9));
      expect(DsSwapRoll.travelFor(20), closeTo(32, 1e-9));
      expect(DsTransforms.swapRollTravel, 1.6);

      await t.pumpWidget(swap(0));
      await t.pump(DsSwapRoll.duration);
      await t.pump(DsJelly.duration);
      expect(yOf(t, 1) - yOf(t, 0), closeTo(25.6, 0.51),
          reason: 'the parked cell sits one full step below, not one window');
    });

    testWidgets('S2: 400ms on the spring, and the overshoot is NOT clamped',
        (WidgetTester t) async {
      // 400ms `--ease-spring`, peaking 9.77% past centre. The transform is left
      // unclamped on purpose — clamping it is the "fix" this guards against.
      expect(DsSwapRoll.duration, const Duration(milliseconds: 400));
      expect(DsSwapRoll.curve, DsCurves.spring);

      await t.pumpWidget(swap(0));
      await t.pump(DsSwapRoll.duration);
      await t.pump(DsJelly.duration);
      final double home = centre(t);

      await t.pumpWidget(swap(1));
      double furthest = 0;
      for (int ms = 0; ms < 400; ms += 10) {
        await t.pump(const Duration(milliseconds: 10));
        // The arriver rises to centre; past it, dy goes negative.
        final double past = home - yOf(t, 1);
        if (past > furthest) furthest = past;
      }
      expect(furthest / DsSwapRoll.travelFor(16), closeTo(0.0977, 0.015),
          reason: 'measured +9.77% of travel past centre, mid-flight');

      await t.pump(DsSwapRoll.duration);
      await t.pump(DsJelly.duration);
      expect(yOf(t, 1), closeTo(home, 0.51), reason: 'and it settles ON centre');
    });

    testWidgets('S3: opacity rides the same clock and is CLAMPED',
        (WidgetTester t) async {
      // Not a second, shorter duration: the spring first reaches y=1 at ~40% of
      // 400ms and the browser clamps the overshoot, so the crossfade is
      // visually finished at 163ms while the strip is still travelling.
      await t.pumpWidget(swap(0));
      await t.pump(DsSwapRoll.duration);
      await t.pump(DsJelly.duration);

      await t.pumpWidget(swap(1));
      for (int ms = 0; ms < 400; ms += 10) {
        await t.pump(const Duration(milliseconds: 10));
        for (final double o in opacities(t)) {
          expect(o, inInclusiveRange(0, 1),
              reason: 'the browser clamps; so must this');
        }
      }
      await t.pump(DsJelly.duration);
      expect(opacities(t), <double>[0, 1]);
    });

    testWidgets('S3b: the crossfade is done at 163ms, the roll is not',
        (WidgetTester t) async {
      await t.pumpWidget(swap(0));
      await t.pump(DsSwapRoll.duration);
      await t.pump(DsJelly.duration);
      final double home = centre(t);

      await t.pumpWidget(swap(1));
      await t.pump(const Duration(milliseconds: 163));
      expect(opacities(t), <double>[0, 1],
          reason: 'measured: opacity pinned from 163ms');
      expect((yOf(t, 1) - home).abs(), greaterThan(0.51),
          reason: 'and the strip has 237ms still to run');
    });

    testWidgets('S4: reverse is the exact arithmetic inverse of advance',
        (WidgetTester t) async {
      // Advance sends the leaver up and out the top; reversing mirrors it with
      // no special-casing anywhere — `offset = i - strip(t)` does both.
      await t.pumpWidget(swap(0));
      await t.pump(DsSwapRoll.duration);
      await t.pump(DsJelly.duration);
      final double home = centre(t);

      await t.pumpWidget(swap(1));
      await t.pump(DsSwapRoll.duration);
      await t.pump(DsJelly.duration);
      expect(yOf(t, 0), lessThan(home), reason: 'advance: leaver exits the TOP');
      final double advanced = home - yOf(t, 0);

      await t.pumpWidget(swap(0));
      await t.pump(DsSwapRoll.duration);
      await t.pump(DsJelly.duration);
      expect(yOf(t, 1), greaterThan(home),
          reason: 'reverse: the leaver goes back out the BOTTOM');
      expect(yOf(t, 1) - home, closeTo(advanced, 0.51));
    });

    testWidgets('S5: the squash waits 150ms, then runs 600 — one 750ms clock',
        (WidgetTester t) async {
      expect(DsSwapRoll.squashDelay, const Duration(milliseconds: 150));
      expect(DsJelly.duration, const Duration(milliseconds: 600));
      expect(DsSwapRoll.squashDelay + DsJelly.duration,
          const Duration(milliseconds: 750),
          reason: 'total visible motion, roll included, is 750ms');
    });

    testWidgets('S6: every glyph is built at once, the inactive one at zero',
        (WidgetTester t) async {
      // Not an AnimatedSwitcher: the strip is one Stack holding all of them,
      // which is why the leaver can be seen travelling out.
      await t.pumpWidget(swap(0));
      await t.pump(DsSwapRoll.duration);
      await t.pump(DsJelly.duration);

      expect(find.descendant(
        of: find.byType(DsIconSwap),
        matching: find.byType(DsIcon),
      ), findsNWidgets(2));
      expect(opacities(t), <double>[1, 0]);
      expect((yOf(t, 1) - yOf(t, 0)).abs(), closeTo(25.6, 0.51),
          reason: 'parked at +step, present and invisible');
    });

    testWidgets('S7: no roll on FIRST BUILD, but the jelly runs once',
        (WidgetTester t) async {
      // Measured from before hydration: the roll transform never leaves the
      // identity matrix on mount. The active glyph is on centre in frame one —
      // a mount that rolls in from off-screen is the regression.
      await t.pumpWidget(swap(1));
      await t.pump();
      expect(yOf(t, 1), closeTo(centre(t), 0.51),
          reason: 'the active glyph is home on the very first frame');
      expect(opacities(t), <double>[0, 1], reason: 'and no crossfade either');

      // …while `yuki-jelly` (delay 0.15s, `both`) does run its full 600ms once.
      await t.pump(DsSwapRoll.squashDelay);
      await t.pump(const Duration(milliseconds: 180));
      final List<double> scales = t
          .widgetList<Transform>(find.descendant(
            of: find.byType(DsIconSwap),
            matching: find.byType(Transform),
          ))
          .map((Transform x) => x.transform.storage[0])
          .toList();
      expect(scales.any((double s) => s > 1.1), isTrue,
          reason: 'stop 2 of the jelly, 1.18');
      await t.pump(DsJelly.duration);
    });

    testWidgets('S8: an interruption re-targets from the CURRENT transform and '
        'runs the full 400ms', (WidgetTester t) async {
      // Measured at a reversal 264ms into a 400ms roll — mid-overshoot, with
      // the strip at −28.10 rather than its −25.60 target. CSS re-targets from
      // where the box actually is and restarts the whole duration; snapping to
      // the target first, or finishing early, are both the regression.
      await t.pumpWidget(swap(0));
      await t.pump(DsSwapRoll.duration);
      await t.pump(DsJelly.duration);
      final double home = centre(t);

      await t.pumpWidget(swap(1));
      await t.pump(const Duration(milliseconds: 264));
      final double interrupted = yOf(t, 0);
      expect(home - interrupted, greaterThan(DsSwapRoll.travelFor(16)),
          reason: 'at 264ms the leaver is PAST its target, mid-overshoot');

      await t.pumpWidget(swap(0));
      await t.pump();
      expect(yOf(t, 0), closeTo(interrupted, 0.51),
          reason: 'the reversal starts from where the strip is, not from the '
              'target it never reached');

      // Still travelling most of the way through a fresh 400ms…
      await t.pump(const Duration(milliseconds: 200));
      expect((yOf(t, 0) - home).abs(), greaterThan(0.51),
          reason: 'a shortened or scaled-down return is the regression');

      await t.pump(DsSwapRoll.duration);
      await t.pump(DsJelly.duration);
      expect(yOf(t, 0), closeTo(home, 0.51));
    });
  });

  group('DsSheet', () {
    Widget trigger({double? width}) => navHost(
          Builder(builder: (BuildContext context) {
            return DsButton(
              variant: DsButtonVariant.outline,
              onPressed: () => DsSheet.showLeft(
                context,
                width: width ?? DsWidths.sidebarMobile,
                builder: (BuildContext c) => DsText('Design system', DsType.nav),
              ),
              child: const DsIcon(DsIconGlyph.menu),
            );
          }),
        );

    testWidgets('opens a 288px panel against the left edge',
        (WidgetTester t) async {
      useFrame(t);
      await t.pumpWidget(trigger());
      await t.tap(find.byType(DsButton));
      await t.pumpAndSettle();

      expect(find.text('Design system'), findsOneWidget);
      final Rect panel = t.getRect(find.byType(DsSheetPanel));
      expect(panel.width, DsWidths.sidebarMobile);
      expect(panel.left, 0);
      expect(panel.height, 900);
    });

    testWidgets('honours an explicit width', (WidgetTester t) async {
      useFrame(t);
      await t.pumpWidget(trigger(width: DsWidths.sidebar));
      await t.tap(find.byType(DsButton));
      await t.pumpAndSettle();

      expect(t.getRect(find.byType(DsSheetPanel)).width, DsWidths.sidebar);
    });

    testWidgets('the right-hand hairline comes out of the 288, not off it',
        (WidgetTester t) async {
      // `w-72` under `box-sizing: border-box`: 288px including the border, so
      // the sheet's content is 287 wide and the panel's right edge is where
      // the page resumes.
      useFrame(t);
      await t.pumpWidget(trigger());
      await t.tap(find.byType(DsButton));
      await t.pumpAndSettle();

      expect(
        t.getSize(find.byType(SafeArea)).width,
        DsWidths.sidebarMobile - DsWidths.hairline,
      );
    });

    testWidgets('slides in from 40px out, over the overlay duration',
        (WidgetTester t) async {
      useFrame(t);
      await t.pumpWidget(trigger());
      await t.tap(find.byType(DsButton));
      await t.pump(); // route pushed, animation at zero

      // CORRECTED 2026-08-16, measured. `slide-in-from-left-10` is **not** 10
      // spacing units: the installed tw-animate-css resolves it to
      // `calc(.1 * 100%)`, a percentage of the element's own border box. The
      // live sheet's first `enter` frame reads `matrix(1,0,0,1,38.4,0)` against
      // a 384px panel — so the 288px docs sheet travels 28.8, not 40.
      expect(
        t.getRect(find.byType(DsSheetPanel)).left,
        closeTo(-DsWidths.sidebarMobile * 0.1, 0.5),
      );

      await t.pump(DsDurations.overlay);
      expect(t.getRect(find.byType(DsSheetPanel)).left, closeTo(0, 0.5));
    });

    testWidgets('blurs and tints what is behind it', (WidgetTester t) async {
      useFrame(t);
      await t.pumpWidget(trigger());
      await t.tap(find.byType(DsButton));
      await t.pumpAndSettle();

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('a tap outside dismisses it', (WidgetTester t) async {
      useFrame(t);
      await t.pumpWidget(trigger());
      await t.tap(find.byType(DsButton));
      await t.pumpAndSettle();
      expect(find.text('Design system'), findsOneWidget);

      await t.tapAt(const Offset(1200, 450));
      await t.pumpAndSettle();
      expect(find.text('Design system'), findsNothing);
    });
  });

  // ── The state matrix ─────────────────────────────────────────────────────
  // shadows-map §5.2 and §5.5: five variants x four states = 20 button states,
  // plus the Input's two = 22. `destructive` and `link` complete the enum
  // (supervisor ruling S5) and are exercised here too.
  //
  // NOTE: not one `pumpAndSettle` below. `foil-value` runs two forever-loops
  // and `sheen-action`'s beat runs while hovered, so a settle would never
  // return. `pump(Duration)` with explicit steps only.
  group('DsButton state matrix', () {
    /// The one [DsMachineSurface] a flat variant paints itself with. The two
    /// gradient variants also contain one — the inset half of their spec —
    /// so those read [DsSheenAction] / [DsFoilValue] instead.
    DsMachineSurface surfaceOf(WidgetTester t) =>
        t.widget<DsMachineSurface>(find.byType(DsMachineSurface));

    DsSheenAction sheenOf(WidgetTester t) =>
        t.widget<DsSheenAction>(find.byType(DsSheenAction));

    DsFoilValue foilOf(WidgetTester t) =>
        t.widget<DsFoilValue>(find.byType(DsFoilValue));

    TextStyle labelStyleOf(WidgetTester t) => t
        .widget<DefaultTextStyle>(find
            .descendant(
              of: find.byType(DsButton),
              matching: find.byType(DefaultTextStyle),
            )
            .first)
        .style;

    Color borderOf(WidgetTester t) =>
        (surfaceOf(t).border! as Border).top.color;

    Future<void> mount(
      WidgetTester t,
      DsButtonVariant variant, {
      DsThemeMode mode = DsThemeMode.dark,
      FocusNode? focusNode,
    }) =>
        t.pumpWidget(host(
          DsButton(
            variant: variant,
            focusNode: focusNode,
            onPressed: () {},
            child: const DsIcon(DsIconGlyph.check),
          ),
          mode: mode,
        ));

    /// Hover, then run the 250ms `btn-spring` colour transition to its end.
    Future<TestGesture> hoverAndSettle(WidgetTester t) async {
      final TestGesture mouse = await hoverOver(t, find.byType(DsButton));
      await t.pump(DsDurations.base);
      await t.pump(DsDurations.base);
      return mouse;
    }

    Future<TestGesture> holdDown(WidgetTester t) async {
      final TestGesture g =
          await t.startGesture(t.getCenter(find.byType(DsButton)));
      await t.pump();
      await t.pump(DsDurations.tick);
      return g;
    }

    Future<void> focusAndSettle(WidgetTester t, FocusNode node) async {
      node.requestFocus();
      await t.pump();
      await t.pump(DsDurations.base);
      await t.pump(DsDurations.base);
    }

    testWidgets('the cva default is `default`, i.e. primary',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        onPressed: () {},
        child: const DsIcon(DsIconGlyph.check),
      )));
      expect(find.byType(DsSheenAction), findsOneWidget,
          reason: 'defaultVariants.variant = "default" in button.tsx');
      expect(t.widget<DsButton>(find.byType(DsButton)).variant,
          DsButtonVariant.primary);
    });

    testWidgets('the enum carries all seven cva variants, in source order',
        (WidgetTester t) async {
      expect(DsButtonVariant.values, <DsButtonVariant>[
        DsButtonVariant.primary,
        DsButtonVariant.premium,
        DsButtonVariant.secondary,
        DsButtonVariant.outline,
        DsButtonVariant.ghost,
        DsButtonVariant.destructive,
        DsButtonVariant.link,
      ]);
    });

    group('aria-expanded — an open trigger holds its hover fill', () {
      /// [mount], plus the attribute `DropdownMenuTrigger asChild` merges into
      /// the `Button` it renders.
      ///
      /// The two pumps are belt and braces: `btn-spring` carries colour over
      /// 250ms, but a button mounted already-expanded has nothing to spring
      /// *from*, so the fill is right on the first frame and stays right.
      Future<void> mountExpanded(
        WidgetTester t,
        DsButtonVariant variant,
      ) async {
        await t.pumpWidget(host(DsButton(
          variant: variant,
          expanded: true,
          onPressed: () {},
          child: const DsIcon(DsIconGlyph.check),
        )));
        await t.pump(DsDurations.base);
        await t.pump(DsDurations.base);
      }

      testWidgets('ghost: --secondary over --foreground, with no pointer '
          'anywhere near it', (WidgetTester t) async {
        await mountExpanded(t, DsButtonVariant.ghost);
        // `aria-expanded:bg-secondary aria-expanded:text-foreground` — the
        // pair its hover already paints, held while the menu is open. The gap
        // this closes is exactly the pointer-less case.
        expect(surfaceOf(t).fill, DsThemeData.dark.secondary);
        expect(labelStyleOf(t).color, DsThemeData.dark.foreground);
      });

      testWidgets('outline: --muted, which is its own hover fill',
          (WidgetTester t) async {
        await mountExpanded(t, DsButtonVariant.outline);
        expect(surfaceOf(t).fill, DsThemeData.dark.muted);
      });

      testWidgets('secondary: --accent, likewise', (WidgetTester t) async {
        await mountExpanded(t, DsButtonVariant.secondary);
        expect(surfaceOf(t).fill, DsThemeData.dark.accent);
      });

      testWidgets('the other four declare no `aria-expanded:` class at all',
          (WidgetTester t) async {
        // The two ramps read `hovered` themselves, and an open trigger is not
        // a hovered one.
        await mountExpanded(t, DsButtonVariant.primary);
        expect(sheenOf(t).hovered, isFalse);
        expect(sheenOf(t).spec, same(DsShadows.btnPrimary));

        await mountExpanded(t, DsButtonVariant.premium);
        expect(foilOf(t).hovered, isFalse);
        expect(foilOf(t).spec, same(DsShadows.btnValue));

        // The two flat ones are compared against their own rest. The pumps
        // matter: the element survives a re-pump, so the fill springs from the
        // *previous* variant's colour and a reading taken on the first frame
        // would be the one before it.
        Future<Color?> restFillOf(DsButtonVariant variant) async {
          await mount(t, variant);
          await t.pump(DsDurations.base);
          await t.pump(DsDurations.base);
          return surfaceOf(t).fill;
        }

        for (final DsButtonVariant variant in <DsButtonVariant>[
          DsButtonVariant.destructive,
          DsButtonVariant.link,
        ]) {
          final Color? rest = await restFillOf(variant);
          await mountExpanded(t, variant);
          expect(surfaceOf(t).fill, rest, reason: '$variant is unmoved by it');
        }

        // …and the teeth for that comparison: destructive's hover IS a
        // different fill, so the equality above is an assertion rather than
        // two identical nothings agreeing.
        final Color? rest = await restFillOf(DsButtonVariant.destructive);
        await hoverAndSettle(t);
        expect(surfaceOf(t).fill, isNot(rest));
      });
    });

    group('primary — sheen-action bg-primary shadow-btn-primary', () {
      testWidgets('rest: btn-primary, white ink, transparent border',
          (WidgetTester t) async {
        await mount(t, DsButtonVariant.primary);
        final DsSheenAction sheen = sheenOf(t);
        expect(sheen.spec, same(DsShadows.btnPrimary));
        expect(sheen.hovered, isFalse);
        expect(sheen.pressed, isFalse);
        expect((sheen.border! as Border).top.color, dsTransparent);
        expect(labelStyleOf(t).color, DsThemeData.dark.primaryForeground);
      });

      testWidgets('hover starts the beat and changes nothing else',
          (WidgetTester t) async {
        await mount(t, DsButtonVariant.primary);
        await hoverAndSettle(t);
        expect(sheenOf(t).hovered, isTrue);
        expect(sheenOf(t).spec, same(DsShadows.btnPrimary),
            reason: 'hover changes no shadow on the default variant');
      });

      testWidgets('active: drops to btn-down and runs one beat',
          (WidgetTester t) async {
        await mount(t, DsButtonVariant.primary);
        final TestGesture g = await holdDown(t);
        expect(sheenOf(t).spec, same(DsShadows.btnDown));
        expect(sheenOf(t).pressed, isTrue);

        await g.up();
        await t.pump(DsDurations.base);
        expect(sheenOf(t).spec, same(DsShadows.btnPrimary));
      });

      testWidgets('focus-visible: --ring border plus a 3px ring in front',
          (WidgetTester t) async {
        final FocusNode node = FocusNode();
        addTearDown(node.dispose);
        await mount(t, DsButtonVariant.primary, focusNode: node);
        await focusAndSettle(t, node);

        final DsSheenAction sheen = sheenOf(t);
        expect((sheen.border! as Border).top.color, DsThemeData.dark.ring);
        // `focus-visible:ring-3 focus-visible:ring-ring/50`, prepended so it
        // composites IN FRONT of --tw-shadow (Tailwind v4's slot order).
        final DsShadowLayer ring = sheen.spec.layers.first;
        expect(ring.inset, isFalse);
        expect(<double>[ring.dx, ring.dy, ring.blur, ring.spread],
            <double>[0, 0, 0, 3]);
        expect(ring.color(DsThemeData.dark),
            DsThemeData.dark.ring.withValues(alpha: 0.50));
        expect(sheen.spec.layers.length,
            DsShadows.btnPrimary.layers.length + 1);
      });
    });

    group('premium — foil-value shadow-btn-value', () {
      testWidgets('rest: btn-value under a foil, semibold',
          (WidgetTester t) async {
        await mount(t, DsButtonVariant.premium);
        expect(foilOf(t).spec, same(DsShadows.btnValue));
        expect(foilOf(t).hovered, isFalse);
        expect(labelStyleOf(t).fontWeight, FontWeight.w600,
            reason: 'font-semibold beats the base font-medium');
      });

      testWidgets('the value foreground does not flip with the theme',
          (WidgetTester t) async {
        for (final DsThemeMode mode in <DsThemeMode>[
          DsThemeMode.dark,
          DsThemeMode.light,
        ]) {
          await mount(t, DsButtonVariant.premium, mode: mode);
          expect(labelStyleOf(t).color, DsPalette.valueForeground,
              reason: '--color-value-foreground is fixed at #121216 ($mode)');
        }
      });

      testWidgets('hover: shadow-glow-value replaces the token wholesale',
          (WidgetTester t) async {
        await mount(t, DsButtonVariant.premium);
        await hoverAndSettle(t);
        expect(foilOf(t).spec, same(DsShadows.glowValue));
        expect(foilOf(t).hovered, isTrue);
        // The inset rim and the inner shade DISAPPEAR — the glow is not added
        // to the machine surface, it replaces it.
        expect(DsShadows.glowValue.hasInset, isFalse);
      });

      testWidgets('active outranks hover: btn-down wins over the glow',
          (WidgetTester t) async {
        await mount(t, DsButtonVariant.premium);
        await hoverAndSettle(t);
        expect(foilOf(t).spec, same(DsShadows.glowValue));

        await holdDown(t);
        expect(foilOf(t).spec, same(DsShadows.btnDown));
        expect(foilOf(t).hovered, isTrue, reason: 'still hovered underneath');
      });
    });

    group('secondary — bg-secondary, no shadow at all', () {
      testWidgets('rest and hover', (WidgetTester t) async {
        await mount(t, DsButtonVariant.secondary);
        expect(surfaceOf(t).fill, DsThemeData.dark.secondary);
        expect(surfaceOf(t).spec.layers, isEmpty,
            reason: 'drift 1: the shadows page copy claims shadow-btn here');
        expect(labelStyleOf(t).color, DsThemeData.dark.secondaryForeground);

        await hoverAndSettle(t);
        expect(surfaceOf(t).fill, DsThemeData.dark.accent);
      });

      testWidgets('active changes nothing but the scale',
          (WidgetTester t) async {
        await mount(t, DsButtonVariant.secondary);
        await hoverAndSettle(t);
        await holdDown(t);
        expect(surfaceOf(t).fill, DsThemeData.dark.accent);
        expect(surfaceOf(t).spec.layers, isEmpty);
      });
    });

    group('destructive — a tint, not a fill', () {
      testWidgets('rest: 10% wash inside a 25% border, destructive ink',
          (WidgetTester t) async {
        await mount(t, DsButtonVariant.destructive);
        final DsThemeData dark = DsThemeData.dark;
        expect(surfaceOf(t).fill, dark.destructive.withValues(alpha: 0.10));
        expect(borderOf(t), dark.destructive.withValues(alpha: 0.25));
        expect(surfaceOf(t).spec.layers, isEmpty);
        expect(labelStyleOf(t).color, dark.destructiveInk);
      });

      testWidgets('hover deepens both, to 20% and 40%',
          (WidgetTester t) async {
        await mount(t, DsButtonVariant.destructive);
        await hoverAndSettle(t);
        final DsThemeData dark = DsThemeData.dark;
        expect(surfaceOf(t).fill, dark.destructive.withValues(alpha: 0.20));
        expect(borderOf(t), dark.destructive.withValues(alpha: 0.40));
      });

      testWidgets('focus overrides both halves of the base ring',
          (WidgetTester t) async {
        final FocusNode node = FocusNode();
        addTearDown(node.dispose);
        await mount(t, DsButtonVariant.destructive, focusNode: node);
        await focusAndSettle(t, node);

        final DsThemeData dark = DsThemeData.dark;
        expect(borderOf(t), dark.destructive.withValues(alpha: 0.50));
        expect(surfaceOf(t).spec.layers.first.color(dark),
            dark.destructive.withValues(alpha: 0.25),
            reason: 'focus-visible:ring-destructive/25, not ring-ring/50');
      });
    });

    group('link — text only', () {
      testWidgets('rest: action ink on nothing', (WidgetTester t) async {
        await mount(t, DsButtonVariant.link);
        expect(surfaceOf(t).fill, dsTransparent);
        expect(borderOf(t), dsTransparent);
        expect(surfaceOf(t).spec.layers, isEmpty);
        expect(labelStyleOf(t).color, DsThemeData.dark.actionInk);
        expect(labelStyleOf(t).decoration, isNot(TextDecoration.underline));
      });

      testWidgets('hover:underline', (WidgetTester t) async {
        await mount(t, DsButtonVariant.link);
        await hoverAndSettle(t);
        expect(labelStyleOf(t).decoration, TextDecoration.underline);
      });
    });

    testWidgets('outline and ghost still take the base focus ring',
        (WidgetTester t) async {
      for (final DsButtonVariant variant in <DsButtonVariant>[
        DsButtonVariant.outline,
        DsButtonVariant.ghost,
      ]) {
        final FocusNode node = FocusNode();
        addTearDown(node.dispose);
        await mount(t, variant, focusNode: node);
        await focusAndSettle(t, node);

        expect(borderOf(t), DsThemeData.dark.ring,
            reason: 'focus-visible:border-ring on $variant');
        expect(surfaceOf(t).spec.layers.first.spread, 3,
            reason: 'focus-visible:ring-3 on $variant');
      }
    });

    testWidgets('the focus ring composites in front of the surface shadow',
        (WidgetTester t) async {
      // CSS paints the FIRST-listed box-shadow on top, and
      // `DsShadowSpec.outerShadows` reverses the list to reproduce that — so a
      // prepended ring must come out LAST, i.e. painted last, i.e. on top.
      final DsShadowSpec ringed =
          DsButton.withFocusRing(DsShadows.btn, DsPalette.action);
      expect(ringed.layers.first.spread, 3);
      final List<BoxShadow> painted = ringed.outerShadows(DsThemeData.dark);
      expect(painted.last.spreadRadius, 3);
      expect(painted.last.color, DsPalette.action);
      // The inset half is untouched — the ring is not inset.
      expect(ringed.insetLayers, DsShadows.btn.insetLayers);
    });

    testWidgets('every variant paints in both themes', (WidgetTester t) async {
      for (final DsThemeMode mode in <DsThemeMode>[
        DsThemeMode.dark,
        DsThemeMode.light,
      ]) {
        for (final DsButtonVariant variant in DsButtonVariant.values) {
          await mount(t, variant, mode: mode);
          await t.pump(DsDurations.base);
          expect(t.takeException(), isNull, reason: '$variant in $mode');
        }
      }
    });

    testWidgets('Enter and Space activate a focused button',
        (WidgetTester t) async {
      int presses = 0;
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(host(DsButton(
        variant: DsButtonVariant.outline,
        focusNode: node,
        onPressed: () => presses++,
        child: const DsIcon(DsIconGlyph.check),
      )));

      node.requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pump();
      expect(presses, 1);

      await t.sendKeyEvent(LogicalKeyboardKey.space);
      await t.pump();
      expect(presses, 2);
    });
  });

  group('DsInput', () {
    DsMachineSurface surfaceOf(WidgetTester t) =>
        t.widget<DsMachineSurface>(find.byType(DsMachineSurface));

    Color borderOf(WidgetTester t) =>
        (surfaceOf(t).border! as Border).top.color;

    Widget field({
      TextEditingController? controller,
      FocusNode? focusNode,
      DsThemeMode mode = DsThemeMode.dark,
    }) =>
        host(
          SizedBox(
            // `max-w-sm` = 24rem = 384px, the cap the shadows page applies.
            width: 384,
            child: DsInput(
              controller: controller,
              focusNode: focusNode,
              placeholder: 'Search packs, cards and sets',
            ),
          ),
          mode: mode,
        );

    testWidgets('is a 40px pill sitting in a permanent socket',
        (WidgetTester t) async {
      await t.pumpWidget(field());

      expect(t.getSize(find.byType(DsInput)).height, ds(10));
      expect(t.getSize(find.byType(DsInput)).width, 384);
      expect(surfaceOf(t).radius, BorderRadius.circular(DsRadii.pill));
      expect(surfaceOf(t).fill, DsThemeData.dark.card);
      expect(borderOf(t), DsThemeData.dark.input);
      expect(surfaceOf(t).spec, same(DsShadows.pressed));
      expect(DsInput.height, ds(10));
    });

    testWidgets('shows the placeholder at muted until something is typed',
        (WidgetTester t) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);
      await t.pumpWidget(field(controller: controller));

      expect(find.text('Search packs, cards and sets'), findsOneWidget);
      expect(t.widget<DsText>(find.byType(DsText).first).color,
          DsThemeData.dark.mutedForeground);

      await t.enterText(find.byType(EditableText), 'charizard');
      await t.pump();
      expect(find.text('Search packs, cards and sets'), findsNothing);
      expect(controller.text, 'charizard');
    });

    testWidgets('is genuinely editable — a real caret and a real value',
        (WidgetTester t) async {
      await t.pumpWidget(field());
      expect(find.byType(EditableText), findsOneWidget);

      await t.enterText(find.byType(EditableText), 'base set');
      await t.pump();
      final EditableText editable =
          t.widget<EditableText>(find.byType(EditableText));
      expect(editable.controller.text, 'base set');
      expect(editable.focusNode.hasFocus, isTrue);
      expect(editable.cursorColor, DsThemeData.dark.foreground);
      expect(editable.readOnly, isFalse);
    });

    testWidgets('focus tints the border and ADDS a ring — the socket stays',
        (WidgetTester t) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(field(focusNode: node));

      node.requestFocus();
      await t.pump();
      await t.pump(DsDurations.base);
      await t.pump(DsDurations.base);

      final DsThemeData dark = DsThemeData.dark;
      expect(borderOf(t), dark.primary.withValues(alpha: 0.50),
          reason: 'focus-visible:border-primary/50 — --primary, not --ring');

      final DsShadowSpec spec = surfaceOf(t).spec;
      final DsShadowLayer ring = spec.layers.first;
      expect(<double>[ring.dx, ring.dy, ring.blur, ring.spread],
          <double>[0, 0, 0, 3]);
      expect(ring.color(dark).r, closeTo(dark.ring.r, 1e-9));
      expect(ring.color(dark).a, closeTo(0.35, 1e-6),
          reason: 'focus-visible:ring-ring/35');
      // The socket is still every one of its own layers, untouched.
      expect(spec.insetLayers, DsShadows.pressed.insetLayers);
      expect(spec.layers.length, DsShadows.pressed.layers.length + 1);
    });

    testWidgets('has no hover state at all', (WidgetTester t) async {
      await t.pumpWidget(field());
      final Color restBorder = borderOf(t);

      await hoverOver(t, find.byType(DsInput));
      await t.pump(DsDurations.base);
      await t.pump(DsDurations.base);

      expect(borderOf(t), restBorder);
      expect(surfaceOf(t).spec, same(DsShadows.pressed),
          reason: 'the field is already sunken and only its ring changes');
    });

    testWidgets('renders in both themes', (WidgetTester t) async {
      for (final DsThemeMode mode in <DsThemeMode>[
        DsThemeMode.dark,
        DsThemeMode.light,
      ]) {
        await t.pumpWidget(field(mode: mode));
        await t.pump(DsDurations.base);
        expect(t.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
