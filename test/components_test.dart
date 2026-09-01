import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
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

/// The component layer: the three primitives the docs shell is assembled from.

Widget host(Widget child, {ColorMode mode = ColorMode.dark}) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(1440, 900)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ThemeScope(
        controller: ThemeController(mode: mode),
        child: Center(child: child),
      ),
    ),
  );
}

/// A navigable host, for the one component that pushes a route.
///
/// `ThemeScope` sits **above** the app, matching what the example app does: the
/// Navigator's overlay has to be inside the theme scope, or a pushed route
/// cannot resolve a token.
Widget navHost(Widget child, {ColorMode mode = ColorMode.dark}) {
  return ThemeScope(
    controller: ThemeController(mode: mode),
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
  final TestGesture mouse = await t.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await mouse.addPointer(location: Offset.zero);
  addTearDown(mouse.removePointer);
  await t.pump();
  await mouse.moveTo(t.getCenter(target));
  await t.pump();
  return mouse;
}

void main() {
  group('Icon', () {
    testWidgets('the size ladder is 12/14/16/20/24/32/40', (
      WidgetTester t,
    ) async {
      const Map<IconSize, double> ladder = <IconSize, double>{
        IconSize.xs: 12,
        IconSize.sm: 14,
        IconSize.md: 16,
        IconSize.lg: 20,
        IconSize.xl: 24,
        IconSize.xl2: 32,
        IconSize.xl3: 40,
      };
      for (final MapEntry<IconSize, double> step in ladder.entries) {
        expect(Icon.pxFor(step.key), step.value);
      }
      expect(ladder.length, IconSize.values.length);
    });

    testWidgets('md renders 16×16', (WidgetTester t) async {
      await t.pumpWidget(host(const Icon(IconGlyph.menu)));
      expect(t.getSize(find.byType(Icon)), const Size(16, 16));
    });

    test('stroke follows the reference ternary, not a clamp', () {
      // components/ui/icon.tsx:
      //   strokeWidth={(2 * 24) / px > 2.6 ? 2.4 : (2 * 24) / px < 1.5 ? 1.6 : 2}
      // The middle branch is a literal 2 — it is NOT the raw 48/px. That makes
      // lg, xl and 2xl all stroke 2.0, where a clamp reading would give
      // 2.4 / 2.0 / 1.5.
      expect(Icon.strokeFor(12), 2.4); // 4.00 > 2.6
      expect(Icon.strokeFor(14), 2.4); // 3.43 > 2.6
      expect(Icon.strokeFor(16), 2.4); // 3.00 > 2.6
      expect(Icon.strokeFor(20), 2.0); // 2.40 — middle branch
      expect(Icon.strokeFor(24), 2.0); // 2.00 — middle branch
      expect(Icon.strokeFor(32), 2.0); // 1.50 is NOT < 1.5 — middle branch
      expect(Icon.strokeFor(40), 1.6); // 1.20 < 1.5
    });

    testWidgets('tones resolve against the live theme', (WidgetTester t) async {
      late BuildContext context;
      await t.pumpWidget(
        host(
          Builder(
            builder: (BuildContext c) {
              context = c;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      final ThemeTokens dark = ThemeTokens.dark;
      expect(Icon.colorFor(context, IconTone.normal), dark.foreground);
      expect(Icon.colorFor(context, IconTone.muted), dark.mutedForeground);
      expect(Icon.colorFor(context, IconTone.subtle), dark.mutedForeground);
      expect(Icon.colorFor(context, IconTone.action), dark.actionText);
      expect(Icon.colorFor(context, IconTone.value), dark.premiumText);
      expect(Icon.colorFor(context, IconTone.success), dark.successText);
      expect(Icon.colorFor(context, IconTone.warning), dark.warningText);
      expect(Icon.colorFor(context, IconTone.info), dark.infoText);
      expect(Icon.colorFor(context, IconTone.error), dark.destructiveText);
    });

    testWidgets('inherit takes the surrounding text colour', (
      WidgetTester t,
    ) async {
      late BuildContext inside;
      await t.pumpWidget(
        host(
          DefaultTextStyle(
            style: TextStyle(color: ThemeTokens.dark.premiumText),
            child: Builder(
              builder: (BuildContext c) {
                inside = c;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(
        Icon.colorFor(inside, IconTone.inherit),
        ThemeTokens.dark.premiumText,
      );
    });

    testWidgets('inherit falls back to the surface colour', (
      WidgetTester t,
    ) async {
      late BuildContext bare;
      await t.pumpWidget(
        host(
          Builder(
            builder: (BuildContext c) {
              bare = c;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(
        Icon.colorFor(bare, IconTone.inherit),
        ThemeTokens.dark.foreground,
      );
    });

    testWidgets('every glyph paints in both themes', (WidgetTester t) async {
      for (final ColorMode mode in <ColorMode>[
        ColorMode.dark,
        ColorMode.light,
      ]) {
        for (final IconGlyph glyph in IconGlyph.values) {
          await t.pumpWidget(host(Icon(glyph, size: IconSize.xl), mode: mode));
          expect(t.takeException(), isNull, reason: '$glyph in $mode');
        }
      }
    });

    testWidgets('sizePx and strokeOverride win', (WidgetTester t) async {
      await t.pumpWidget(
        host(const Icon(IconGlyph.check, sizePx: 18, strokeOverride: 3)),
      );
      expect(t.getSize(find.byType(Icon)), const Size(18, 18));
      expect(t.takeException(), isNull);
    });
  });

  group('Button', () {
    Surface surfaceOf(WidgetTester t) =>
        t.widget<Surface>(find.byType(Surface));

    testWidgets('all nine rungs render at their cva height', (
      WidgetTester t,
    ) async {
      Future<Size> sizeOf(ButtonSize size) async {
        await t.pumpWidget(
          host(
            Button(
              variant: ButtonVariant.outline,
              size: size,
              onPressed: () {},
              child: const Icon(IconGlyph.menu),
            ),
          ),
        );
        return t.getSize(find.byType(Button));
      }

      // The five text rungs — 24 / 32 / 40 / 48 / 56.
      expect((await sizeOf(ButtonSize.xs)).height, space(6));
      expect((await sizeOf(ButtonSize.sm)).height, space(8));
      expect((await sizeOf(ButtonSize.md)).height, space(10));
      expect((await sizeOf(ButtonSize.lg)).height, space(12));
      expect((await sizeOf(ButtonSize.xl)).height, space(14));
      // The four squares, which are square.
      expect(await sizeOf(ButtonSize.iconXs), Size(space(6), space(6)));
      expect(await sizeOf(ButtonSize.iconSm), Size(space(8), space(8)));
      expect(await sizeOf(ButtonSize.icon), Size(space(10), space(10)));
      expect(await sizeOf(ButtonSize.iconLg), Size(space(12), space(12)));
    });

    testWidgets('outline is card on input with --shadow-btn', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          Button(
            variant: ButtonVariant.outline,
            onPressed: () {},
            child: const Icon(IconGlyph.menu),
          ),
        ),
      );

      final Surface surface = surfaceOf(t);
      expect(surface.fill, ThemeTokens.dark.card);
      expect((surface.border! as Border).top.color, ThemeTokens.dark.input);
      expect(surface.spec, same(Shadows.control));
      expect(surface.radius, BorderRadius.circular(Radii.full));
    });

    testWidgets('outline fills with --muted on hover', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          Button(
            variant: ButtonVariant.outline,
            onPressed: () {},
            child: const Icon(IconGlyph.menu),
          ),
        ),
      );

      await hoverOver(t, find.byType(Button));
      await t.pumpAndSettle();
      expect(surfaceOf(t).fill, ThemeTokens.dark.muted);
    });

    testWidgets('outline drops into --shadow-btn-down while held', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          Button(
            variant: ButtonVariant.outline,
            onPressed: () {},
            child: const Icon(IconGlyph.menu),
          ),
        ),
      );

      final TestGesture gesture = await t.startGesture(
        t.getCenter(find.byType(Button)),
      );
      await t.pump();
      expect(surfaceOf(t).spec, same(Shadows.controlPressed));

      await gesture.up();
      await t.pump(MotionDurations.normal);
      expect(surfaceOf(t).spec, same(Shadows.control));
    });

    testWidgets('ghost is bare, muted, and shadowless', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          Button(
            variant: ButtonVariant.ghost,
            onPressed: () {},
            child: const Icon(IconGlyph.x),
          ),
        ),
      );

      final Surface surface = surfaceOf(t);
      expect(surface.fill, transparent);
      // The base class list is `border border-transparent` for every variant:
      // a real 1px border, invisible but paid for in inner width.
      expect((surface.border! as Border).top.color, transparent);
      expect((surface.border! as Border).top.width, BorderWidths.hairline);
      expect(surface.spec.layers, isEmpty);
      expect(
        t
            .widget<DefaultTextStyle>(
              find
                  .descendant(
                    of: find.byType(Button),
                    matching: find.byType(DefaultTextStyle),
                  )
                  .first,
            )
            .style
            .color,
        ThemeTokens.dark.mutedForeground,
      );
    });

    testWidgets('ghost takes --secondary and --foreground on hover', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          Button(
            variant: ButtonVariant.ghost,
            onPressed: () {},
            child: const Icon(IconGlyph.x),
          ),
        ),
      );

      await hoverOver(t, find.byType(Button));
      await t.pumpAndSettle();
      expect(surfaceOf(t).fill, ThemeTokens.dark.secondary);
    });

    /// The scale the button is currently drawn at — the first [Transform] under
    /// it, which is the one `scale-95` maps to.
    double scaleOf(WidgetTester t) => t
        .widget<Transform>(
          find
              .descendant(
                of: find.byType(Button),
                matching: find.byType(Transform),
              )
              .first,
        )
        .transform
        .storage[0];

    testWidgets('squishes to 0.95 — the button scale, not press\'s 0.94', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          Button(
            variant: ButtonVariant.outline,
            onPressed: () {},
            child: const Icon(IconGlyph.menu),
          ),
        ),
      );

      expect(scaleOf(t), 1.0);

      await t.startGesture(t.getCenter(find.byType(Button)));
      // RETUNED (behaviour-audit B1). This used to pump `--duration-tick`
      // before asserting, on the theory that `btn-spring`'s `:active`
      // duration eased the squish over 80ms. It does not: Tailwind v4 compiles
      // `scale-95` to the standalone `scale` property, which is **not** in
      // `btn-spring`'s transition-property list. One frame is all it takes on
      // the reference, so one frame is all this pumps — stricter, and true.
      await t.pump();
      expect(scaleOf(t), MotionTransforms.buttonPress);
    });

    // ── Measured behaviour — behaviour-audit §3 ────────────────────────────
    // Every number below is a trace off the live reference at 1440×900, driven
    // with real pointer/keyboard input and rAF-sampled at ~16.6ms. Each of
    // these fails against the port as it stood before this wave.

    testWidgets('B1 — the press scale snaps both ways, with no frame between', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          Button(
            variant: ButtonVariant.outline,
            onPressed: () {},
            child: const Icon(IconGlyph.menu),
          ),
        ),
      );
      expect(scaleOf(t), 1.0, reason: 'at rest');

      final List<double> frames = <double>[];
      final TestGesture press = await t.startGesture(
        t.getCenter(find.byType(Button)),
      );

      // Measured: 9.5ms after `pointerdown` — the very next frame — the button
      // is already fully at 0.95, with no intermediate value sampled.
      await t.pump();
      expect(scaleOf(t), MotionTransforms.buttonPress);
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
      // overshoot the port used to carry through `Press`.
      expect(frames.toSet(), <double>{MotionTransforms.buttonPress, 1.0});
    });

    testWidgets('B6 — a 10, 20 or 30ms tap still shows the full 0.95', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          Button(
            variant: ButtonVariant.outline,
            onPressed: () {},
            child: const Icon(IconGlyph.menu),
          ),
        ),
      );

      // The port used to reach 0.9756 / 0.9592 / 0.9497 for these three holds,
      // then play a shortened spring backwards. Instant means depth cannot
      // depend on hold length.
      for (final int ms in <int>[10, 20, 30]) {
        final TestGesture tap = await t.startGesture(
          t.getCenter(find.byType(Button)),
        );
        await t.pump();
        expect(
          scaleOf(t),
          MotionTransforms.buttonPress,
          reason: '${ms}ms hold',
        );
        await t.pump(Duration(milliseconds: ms));
        expect(
          scaleOf(t),
          MotionTransforms.buttonPress,
          reason: '${ms}ms hold',
        );

        await tap.up();
        await t.pump();
        expect(scaleOf(t), 1.0, reason: 'one frame after a ${ms}ms hold');
      }
    });

    // ── The two attributes `asChild` merges into a trigger ─────────────────

    testWidgets(
      'aria-haspopup: a trigger does not squish, for the whole press',
      (WidgetTester t) async {
        await t.pumpWidget(
          host(
            Button(
              variant: ButtonVariant.outline,
              suppressPressScale: true,
              onPressed: () {},
              child: const Icon(IconGlyph.menu),
            ),
          ),
        );

        final List<double> frames = <double>[scaleOf(t)];
        final TestGesture press = await t.startGesture(
          t.getCenter(find.byType(Button)),
        );
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

        expect(frames.toSet(), <double>{
          1.0,
        }, reason: 'one value for the whole press, and it is unity');
      },
    );

    testWidgets('…and it exempts the scale alone: the socket still takes it', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          Button(
            variant: ButtonVariant.outline,
            suppressPressScale: true,
            onPressed: () {},
            child: const Icon(IconGlyph.menu),
          ),
        ),
      );

      final TestGesture press = await t.startGesture(
        t.getCenter(find.byType(Button)),
      );
      await t.pump();
      // `active:shadow-btn-down` carries no `not-` guard, so a trigger sinks
      // into its socket exactly like every other button.
      expect(surfaceOf(t).spec, same(Shadows.controlPressed));
      expect(scaleOf(t), 1.0);

      await press.up();
      await t.pump(MotionDurations.normal);
      expect(surfaceOf(t).spec, same(Shadows.control));
    });

    testWidgets('B2 — the pressed shadow hard-cuts: the token pair cannot '
        'interpolate', (WidgetTester t) async {
      await t.pumpWidget(
        host(Button(onPressed: () {}, child: const Icon(IconGlyph.menu))),
      );
      ShadowStyle spec() =>
          t.widget<ActionFeedback>(find.byType(ActionFeedback)).spec;

      // `--shadow-btn-primary` is 4 layers (2 inset, 2 not) against
      // `--shadow-btn-down`'s 2 (1 inset, 1 not). Mismatched layer counts AND
      // mismatched `inset` flags: CSS refuses to interpolate, and the browser
      // was measured swapping the value inside a single frame. A later
      // well-meaning tween here would be motion the reference never shows.
      final List<ShadowStyle> seen = <ShadowStyle>[spec()];
      final TestGesture press = await t.startGesture(
        t.getCenter(find.byType(Button)),
      );
      for (int i = 0; i < 8; i++) {
        await t.pump(const Duration(milliseconds: 16));
        seen.add(spec());
      }
      await press.up();
      for (int i = 0; i < 8; i++) {
        await t.pump(const Duration(milliseconds: 16));
        seen.add(spec());
      }

      expect(seen.first, same(Shadows.controlPrimary));
      expect(
        seen[1],
        same(Shadows.controlPressed),
        reason: 'the very next frame',
      );
      expect(seen.last, same(Shadows.controlPrimary));
      for (final ShadowStyle s in seen) {
        expect(
          identical(s, Shadows.controlPrimary) ||
              identical(s, Shadows.controlPressed),
          isTrue,
          reason: 'no third, interpolated value may ever appear',
        );
      }
    });

    testWidgets('B3 — premium\'s hover glow hard-cuts too', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          Button(
            variant: ButtonVariant.premium,
            onPressed: () {},
            child: const Icon(IconGlyph.menu),
          ),
        ),
      );
      ShadowStyle spec() =>
          t.widget<PremiumSurface>(find.byType(PremiumSurface)).spec;

      expect(spec(), same(Shadows.controlPremium));
      // Measured at **1.2ms** after `pointerover`: `--shadow-btn-value` (8
      // computed layers, insets) → `--shadow-glow-value` (6, none). Snap.
      await hoverOver(t, find.byType(Button));
      expect(spec(), same(Shadows.glowValue));
    });

    testWidgets('B12 — the focus ring springs its spread 0 → 3.29 → 3', (
      WidgetTester t,
    ) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(
        host(
          Button(
            variant: ButtonVariant.outline,
            focusNode: node,
            onPressed: () {},
            child: const Icon(IconGlyph.menu),
          ),
        ),
      );

      // The ring lands in one of the token's leading transparent placeholder
      // slots, so the layer count and the per-layer `inset` flags never change
      // and `box-shadow` interpolates normally — the opposite case to B2/B3.
      expect(
        surfaceOf(t).spec,
        same(Shadows.control),
        reason: 'no ring at rest',
      );

      node.requestFocus();
      await t.pump();
      double spread() => surfaceOf(t).spec.layers.first.spread;
      double alpha() =>
          surfaceOf(t).spec.layers.first.color(ThemeTokens.dark).a;

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

    testWidgets('B11 — the disabled opacity springs, undershooting to 0.397', (
      WidgetTester t,
    ) async {
      Widget button({required bool enabled}) => host(
        Button(
          variant: ButtonVariant.outline,
          onPressed: enabled ? () {} : null,
          child: const Icon(IconGlyph.menu),
        ),
      );
      double opacity() => t
          .widget<Opacity>(
            find
                .descendant(
                  of: find.byType(Button),
                  matching: find.byType(Opacity),
                )
                .first,
          )
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
      // colours: measured 1 → 0.3969 at Δ~180 → 0.45 at Δ~280 when the resting
      // value was 0.45, an undershoot of (0.45 − 0.3969) / (1 − 0.45) = 9.65%
      // of the travel. The fraction is what btn-spring owns; the resting value
      // is `SurfaceOpacity.disabled`, so the undershoot is expressed against it
      // rather than re-measured by hand whenever the token moves.
      const double undershoot =
          SurfaceOpacity.disabled - 0.0965 * (1 - SurfaceOpacity.disabled);
      expect(lowest, closeTo(undershoot, 0.005));
      await t.pump(const Duration(milliseconds: 250));
      expect(opacity(), closeTo(SurfaceOpacity.disabled, 1e-9));
    });

    testWidgets('fires onPressed', (WidgetTester t) async {
      int presses = 0;
      await t.pumpWidget(
        host(
          Button(
            variant: ButtonVariant.outline,
            onPressed: () => presses++,
            child: const Icon(IconGlyph.menu),
          ),
        ),
      );

      await t.tap(find.byType(Button));
      await t.pump(MotionDurations.normal);
      expect(presses, 1);
    });

    testWidgets('a null onPressed disables it', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          const Button(
            variant: ButtonVariant.outline,
            child: Icon(IconGlyph.menu),
          ),
        ),
      );

      await t.tap(find.byType(Button), warnIfMissed: false);
      await t.pump(MotionDurations.normal);
      expect(t.takeException(), isNull);

      final Opacity opacity = t.widget<Opacity>(
        find
            .descendant(of: find.byType(Button), matching: find.byType(Opacity))
            .first,
      );
      expect(opacity.opacity, lessThan(1));
    });

    testWidgets('shows the click cursor only while enabled', (
      WidgetTester t,
    ) async {
      Widget button({required bool enabled}) => host(
        Button(
          variant: ButtonVariant.outline,
          onPressed: enabled ? () {} : null,
          child: const Icon(IconGlyph.menu),
        ),
      );
      MouseRegion region() => t.widget<MouseRegion>(find.byType(MouseRegion));

      await t.pumpWidget(button(enabled: true));
      expect(region().cursor, SystemMouseCursors.click);

      await t.pumpWidget(button(enabled: false));
      expect(region().cursor, isNot(SystemMouseCursors.click));
    });
  });

  group('the nine-rung cva ladder', () {
    // buttons-map §3.1, resolved to pixels. Every value below is the class the
    // reference declares, multiplied out: `--spacing` is 0.25rem, so `gap-1.5`
    // is 6 and `px-2.5` is 10.

    test('the enum is nine members in the cva\'s declaration order', () {
      expect(ButtonSize.values, <ButtonSize>[
        ButtonSize.xs,
        ButtonSize.sm,
        ButtonSize.md,
        ButtonSize.lg,
        ButtonSize.xl,
        ButtonSize.iconXs,
        ButtonSize.iconSm,
        ButtonSize.icon,
        ButtonSize.iconLg,
      ]);
    });

    test('height — 24 / 32 / 40 / 48 / 56, squares included', () {
      expect(Button.heightFor(ButtonSize.xs), 24);
      expect(Button.heightFor(ButtonSize.sm), 32);
      expect(Button.heightFor(ButtonSize.md), 40);
      expect(Button.heightFor(ButtonSize.lg), 48);
      expect(Button.heightFor(ButtonSize.xl), 56);
      expect(Button.heightFor(ButtonSize.iconXs), 24);
      expect(Button.heightFor(ButtonSize.iconSm), 32);
      expect(Button.heightFor(ButtonSize.icon), 40);
      expect(Button.heightFor(ButtonSize.iconLg), 48);
    });

    test('gap — 4 / 6 / 8 / 10 / 10, and none on any square', () {
      expect(Button.gapFor(ButtonSize.xs), 4);
      expect(Button.gapFor(ButtonSize.sm), 6);
      expect(Button.gapFor(ButtonSize.md), 8);
      // `lg` and `xl` share `gap-2.5`; the ladder does not step here.
      expect(Button.gapFor(ButtonSize.lg), 10);
      expect(Button.gapFor(ButtonSize.xl), 10);
      for (final ButtonSize square in ButtonSize.values.where(
        Button.isSquare,
      )) {
        expect(
          Button.gapFor(square),
          0,
          reason: '${square.name} declares no gap',
        );
      }
    });

    test('padding-x — 10 / 14 / 16 / 24 / 32, and none on any square', () {
      expect(Button.paddingXFor(ButtonSize.xs), 10);
      expect(Button.paddingXFor(ButtonSize.sm), 14);
      expect(Button.paddingXFor(ButtonSize.md), 16);
      expect(Button.paddingXFor(ButtonSize.lg), 24);
      expect(Button.paddingXFor(ButtonSize.xl), 32);
      for (final ButtonSize square in ButtonSize.values.where(
        Button.isSquare,
      )) {
        expect(Button.paddingXFor(square), 0);
      }
    });

    test('exactly four rungs are squares', () {
      expect(ButtonSize.values.where(Button.isSquare), <ButtonSize>[
        ButtonSize.iconXs,
        ButtonSize.iconSm,
        ButtonSize.icon,
        ButtonSize.iconLg,
      ]);
    });

    test('the svg override — 12 / 14 / 16 / 16 / 20 across the pairs', () {
      // `[&_svg:not([class*='size-'])]:size-*`. `md` and `lg` are the two text
      // rungs that never override the base `size-4`, which is why a 48px `lg`
      // button and a 40px `md` button hold the same 16px glyph.
      expect(Button.iconPxFor(ButtonSize.xs), 12);
      expect(Button.iconPxFor(ButtonSize.sm), 14);
      expect(Button.iconPxFor(ButtonSize.md), 16);
      expect(Button.iconPxFor(ButtonSize.lg), 16);
      expect(Button.iconPxFor(ButtonSize.xl), 20);
      expect(Button.iconPxFor(ButtonSize.iconXs), 12);
      expect(Button.iconPxFor(ButtonSize.iconSm), 14);
      expect(Button.iconPxFor(ButtonSize.icon), 16);
      expect(Button.iconPxFor(ButtonSize.iconLg), 20);
    });

    test('five rungs, three type sizes, three leadings — drift 15', () {
      TextStyleToken spec(ButtonSize size) =>
          Button.typeFor(size, ButtonEmphasis.none)!;

      // Two reading sizes across five rungs, both from the public scale.
      expect(spec(ButtonSize.xs).step, TextStyles.small.step);
      expect(spec(ButtonSize.sm).step, TextStyles.small.step);
      expect(spec(ButtonSize.md).step, TextStyles.body.step);
      expect(spec(ButtonSize.lg).step, TextStyles.body.step);
      expect(spec(ButtonSize.xl).step, TextStyles.body.step);

      // No rung publishes a new role, and none is smaller than `small`.
      for (final ButtonSize size in <ButtonSize>[
        ButtonSize.xs,
        ButtonSize.sm,
        ButtonSize.md,
        ButtonSize.lg,
        ButtonSize.xl,
      ]) {
        expect(TextStyles.all, isNot(contains(spec(size))));
        expect(spec(size).step.size, greaterThanOrEqualTo(14));
        expect(spec(size).wght, 500, reason: 'a label is medium at every rung');
      }

      // The four square rungs carry no label type at all.
      for (final ButtonSize size in <ButtonSize>[
        ButtonSize.iconXs,
        ButtonSize.iconSm,
        ButtonSize.icon,
        ButtonSize.iconLg,
      ]) {
        expect(Button.typeFor(size, ButtonEmphasis.none), isNull);
      }

      // `caps` keeps the rung's step and changes only weight and tracking.
      final TextStyleToken caps = Button.typeFor(
        ButtonSize.md,
        ButtonEmphasis.caps,
      )!;
      expect(caps.step, TextStyles.body.step);
      expect(caps.wght, 600);
      expect(caps.tracking, greaterThan(0));

      // A label's leading is the role's, so a wrapping label in a height-auto
      // button (a sidebar row) grows by whole line boxes.
      expect(spec(ButtonSize.sm).step.leading, 20);
      expect(spec(ButtonSize.md).step.leading, 24);

      // Every text rung is `font-medium`.
      for (final ButtonSize size in <ButtonSize>[
        ButtonSize.xs,
        ButtonSize.sm,
        ButtonSize.md,
        ButtonSize.lg,
        ButtonSize.xl,
      ]) {
        expect(spec(size).weight, FontWeight.w500);
      }
    });

    test('the four squares declare no text class at all', () {
      for (final ButtonSize square in ButtonSize.values.where(
        Button.isSquare,
      )) {
        expect(
          Button.typeFor(square, ButtonEmphasis.none),
          isNull,
          reason: '${square.name} sets no text-*; it inherits from the page',
        );
      }
    });

    testWidgets('a square rung inherits the page\'s type and takes only ink', (
      WidgetTester t,
    ) async {
      // The CSS consequence of the null above: an `icon-*` button changes the
      // colour of the text inside it and nothing else.
      const TextStyle ambient = TextStyle(fontSize: 31, fontFamily: 'Ambient');
      await t.pumpWidget(
        host(
          DefaultTextStyle(
            style: ambient,
            child: Button(
              variant: ButtonVariant.ghost,
              size: ButtonSize.icon,
              onPressed: () {},
              child: const Text('x'),
            ),
          ),
        ),
      );

      final TextStyle resolved = t
          .widget<DefaultTextStyle>(
            find
                .descendant(
                  of: find.byType(Button),
                  matching: find.byType(DefaultTextStyle),
                )
                .first,
          )
          .style;
      expect(resolved.fontSize, 31);
      expect(resolved.fontFamily, 'Ambient');
      expect(resolved.color, ThemeTokens.dark.mutedForeground);
    });
  });

  group('Button emphasis: caps', () {
    TextStyle labelStyleOf(WidgetTester t) => t
        .widget<DefaultTextStyle>(
          find
              .descendant(
                of: find.byType(Button),
                matching: find.byType(DefaultTextStyle),
              )
              .first,
        )
        .style;

    testWidgets('keeps its rung and adds weight and tracking', (
      WidgetTester t,
    ) async {
      for (final ButtonSize size in ButtonSize.values) {
        final TextStyleToken? role = Button.typeFor(size, ButtonEmphasis.none);
        // The four square rungs own no label type, so there is no rung for
        // caps to keep.
        if (role == null) continue;
        await t.pumpWidget(
          host(
            Button(
              variant: ButtonVariant.premium,
              size: size,
              emphasis: ButtonEmphasis.caps,
              onPressed: () {},
              child: const Text('Claim Reward'),
            ),
          ),
        );

        final TextStyle style = labelStyleOf(t);
        final double rung = role.step.size;
        expect(
          style.fontSize,
          rung,
          reason: '${size.name}: caps keeps the rung it is on',
        );
        expect(
          style.letterSpacing,
          closeTo(0.09 * rung, 1e-9),
          reason: '${size.name}: caps tracking',
        );
        expect(
          style.fontVariations!
              .firstWhere((FontVariation v) => v.axis == 'wght')
              .value,
          600,
          reason: '${size.name}: font-semibold',
        );
      }
    });

    testWidgets('never shrinks the rung it is applied to', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(Button(onPressed: () {}, child: const Text('Open Pack'))),
      );
      expect(labelStyleOf(t).fontSize, TextStyles.body.step.size);

      await t.pumpWidget(
        host(
          Button(
            emphasis: ButtonEmphasis.caps,
            onPressed: () {},
            child: const Text('Claim Reward'),
          ),
        ),
      );
      expect(labelStyleOf(t).fontSize, TextStyles.body.step.size);
    });

    testWidgets('uppercases the glyphs and leaves the accessible name alone', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          Button(
            variant: ButtonVariant.premium,
            emphasis: ButtonEmphasis.caps,
            onPressed: () {},
            child: const Text('Claim Reward'),
          ),
        ),
      );

      final Text rendered = t.widget<Text>(
        find.descendant(of: find.byType(Button), matching: find.byType(Text)),
      );
      // `text-transform` repaints the glyphs; the DOM text — and therefore the
      // accessible name — stays as authored.
      expect(rendered.data, 'CLAIM REWARD');
      expect(rendered.semanticsLabel, 'Claim Reward');
    });

    testWidgets('leaves a non-Text child alone', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          Button(
            emphasis: ButtonEmphasis.caps,
            onPressed: () {},
            child: const Icon(IconGlyph.menu),
          ),
        ),
      );
      expect(t.takeException(), isNull);
      expect(find.byType(Icon), findsOneWidget);
    });
  });

  group('Button.loading', () {
    testWidgets('prepends a spinner and disables the button', (
      WidgetTester t,
    ) async {
      int presses = 0;
      await t.pumpWidget(
        host(
          Button(
            loading: true,
            onPressed: () => presses++,
            child: const Text('Saving'),
          ),
        ),
      );

      expect(find.byType(Spinner), findsOneWidget);
      // The spinner leads: `<>{loading && <Spinner />}{children}</>`.
      final Offset spinner = t.getCenter(find.byType(Spinner));
      final Offset label = t.getCenter(find.text('Saving'));
      expect(spinner.dx, lessThan(label.dx));

      // `disabled = disabled || loading` — the callback is live and still must
      // not fire.
      await t.tap(find.byType(Button), warnIfMissed: false);
      await t.pump(MotionDurations.normal);
      expect(presses, 0);

      final Opacity opacity = t.widget<Opacity>(
        find
            .descendant(of: find.byType(Button), matching: find.byType(Opacity))
            .first,
      );
      expect(opacity.opacity, SurfaceOpacity.disabled);
    });

    testWidgets('the width DOES jump, by 24px on the default rung — drift 3', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(Button(onPressed: () {}, child: const Text('Saving'))),
      );
      final double resting = t.getSize(find.byType(Button)).width;

      await t.pumpWidget(
        host(
          Button(loading: true, onPressed: () {}, child: const Text('Saving')),
        ),
      );
      final double busy = t.getSize(find.byType(Button)).width;

      // 16px of glyph plus the rung's own `gap-2`. Four separate sentences in
      // the reference say this does not happen.
      expect(
        busy - resting,
        closeTo(Spinner.px + Button.gapFor(ButtonSize.md), 1e-9),
      );
    });

    testWidgets('the gap in front of the label is the rung\'s own', (
      WidgetTester t,
    ) async {
      for (final ButtonSize size in <ButtonSize>[
        ButtonSize.xs,
        ButtonSize.sm,
        ButtonSize.md,
        ButtonSize.lg,
        ButtonSize.xl,
      ]) {
        await t.pumpWidget(
          host(
            Button(size: size, onPressed: () {}, child: const Text('Saving')),
          ),
        );
        final double resting = t.getSize(find.byType(Button)).width;

        await t.pumpWidget(
          host(
            Button(
              size: size,
              loading: true,
              onPressed: () {},
              child: const Text('Saving'),
            ),
          ),
        );
        final double busy = t.getSize(find.byType(Button)).width;

        expect(
          busy - resting,
          closeTo(Spinner.px + Button.gapFor(size), 1e-9),
          reason: '${size.name}: spinner + gap-*',
        );
      }
    });

    testWidgets('exposes the disabled half of aria-busy — ruling B9', (
      WidgetTester t,
    ) async {
      // `aria-busy` has no analogue in the pinned SDK; what a loading button
      // can still say is that it is not actionable, which is the state the
      // reference's `disabled = disabled || loading` puts it in.
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(
        host(
          Button(
            loading: true,
            label: 'Save Account',
            onPressed: () {},
            child: const Text('Saving'),
          ),
        ),
      );

      // `isSemantics`, not `matchesSemantics`: the assertion is about three
      // flags, and a whole-node match would also be pinning whichever actions
      // the gesture layer happens to expose under an `IgnorePointer`.
      expect(
        t.getSemantics(find.byType(Button).first),
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

  group('Spinner', () {
    testWidgets('is 16px and turns once every 900ms, linearly', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const Spinner()));

      expect(t.getSize(find.byType(Spinner)), const Size(16, 16));

      double turnsNow() => t
          .widget<RotationTransition>(find.byType(RotationTransition))
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

    testWidgets('is silent to assistive tech — drift 4, ruling B9', (
      WidgetTester t,
    ) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(host(const Spinner()));
      // `role="status"` and `aria-label="Loading"` are handed to `Icon` and
      // dropped by its destructure; the glyph renders `aria-hidden`.
      expect(find.byType(ExcludeSemantics), findsWidgets);
      expect(t.getSemantics(find.byType(Spinner)).label, isEmpty);
      handle.dispose();
      await t.pumpWidget(host(const SizedBox()));
    });

    testWidgets('reduced motion holds it upright at 0° — ruling B13', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(1440, 900),
            disableAnimations: true,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: ThemeScope(
              controller: ThemeController(mode: ColorMode.dark),
              child: const Center(child: Spinner()),
            ),
          ),
        ),
      );

      double turnsNow() => t
          .widget<RotationTransition>(find.byType(RotationTransition))
          .turns
          .value;

      // `pulls-spin` declares no fill mode, so the blanket reduced-motion rule
      // leaves it at the element's resting style rather than its final stop.
      expect(turnsNow(), 0);
      await t.pump(MotionDurations.spin);
      expect(turnsNow(), 0);
      await t.pump(MotionDurations.spin);
      expect(turnsNow(), 0);
    });
  });

  group('Toggle', () {
    Surface surfaceOf(WidgetTester t) => t.widget<Surface>(
      find
          .descendant(of: find.byType(Toggle), matching: find.byType(Surface))
          .first,
    );

    Widget toggle({
      bool pressed = false,
      bool enabled = true,
      ToggleSize size = ToggleSize.md,
      ToggleVariant variant = ToggleVariant.standard,
    }) => host(
      Toggle(
        pressed: pressed,
        size: size,
        variant: variant,
        label: 'Favourite',
        onChanged: enabled ? (bool _) {} : null,
        child: const Icon(IconGlyph.heart),
      ),
    );

    testWidgets(
      'the reference reads 32 tall; TARGET SIZING floors the real layout '
      'at the touch minimum, and the radius is still 12px — not a pill',
      (WidgetTester t) async {
        await t.pumpWidget(toggle());
        final Size box = t.getSize(find.byType(Toggle));
        // `h-8 min-w-8 px-2.5` around a 16px glyph reads 36 × 32 on the
        // reference. This used to assert that number exactly; a Toggle is a
        // real tap target, so its layout box — not an invisible margin
        // around it, see `TapTarget` — is now floored at
        // TouchTargets.minimum, and both dimensions clear it.
        expect(box.height, TouchTargets.minimum);
        expect(box.width, TouchTargets.minimum);
        expect(
          surfaceOf(t).radius,
          BorderRadius.circular(Radii.lg),
          reason: 'rounded-lg — a Toggle is not a pill',
        );
      },
    );

    test('the ladder: 28 / 32 / 36, and sm clamps its own radius', () {
      expect(Toggle.heightFor(ToggleSize.sm), 28);
      expect(Toggle.heightFor(ToggleSize.md), 32);
      expect(Toggle.heightFor(ToggleSize.lg), 36);
      expect(Toggle.minWidthFor(ToggleSize.sm), 28);
      expect(Toggle.minWidthFor(ToggleSize.md), 32);
      expect(Toggle.minWidthFor(ToggleSize.lg), 36);
      // `rounded-[min(var(--radius-md),12px)]` — 10px today, and it stays a
      // live clamp so a rebrand that raises --radius-md still ceilings at 12.
      expect(Toggle.radiusFor(ToggleSize.sm), Radii.md);
      expect(Toggle.radiusFor(ToggleSize.md), Radii.lg);
      expect(Toggle.radiusFor(ToggleSize.lg), Radii.lg);
      // All three rungs declare the same `px-2.5` and `gap-1`.
      expect(Toggle.paddingX, 10);
      expect(Toggle.gap, 4);
    });

    testWidgets('rest is bare — no fill, no border box, no shadow', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(toggle());
      final Surface surface = surfaceOf(t);
      expect(surface.fill, transparent);
      // `variant="default"` is `bg-transparent` with no `border` class at all,
      // which is exactly why `focus-visible:border-ring` is inert on it.
      expect(surface.border, isNull);
      expect(surface.spec.layers.single.color(ThemeTokens.dark).a, 0);
    });

    testWidgets('hover fills with --muted and moves no ink — drift 10', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(toggle());
      final Color restingInk = t
          .widget<DefaultTextStyle>(
            find
                .descendant(
                  of: find.byType(Toggle),
                  matching: find.byType(DefaultTextStyle),
                )
                .first,
          )
          .style
          .color!;

      await hoverOver(t, find.byType(Toggle));
      await t.pump(MotionDurations.normal);
      await t.pump(MotionDurations.normal);

      expect(surfaceOf(t).fill, ThemeTokens.dark.muted);
      // `hover:text-foreground` restates the colour the element already
      // inherits: the base sets no resting ink, so the hover half is inert.
      expect(
        t
            .widget<DefaultTextStyle>(
              find
                  .descendant(
                    of: find.byType(Toggle),
                    matching: find.byType(DefaultTextStyle),
                  )
                  .first,
            )
            .style
            .color,
        restingInk,
      );
      expect(restingInk, ThemeTokens.dark.foreground);
    });

    testWidgets('the pressed fill is --muted — GREY, not blue — drift 5', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(toggle(pressed: true));
      await t.pump(MotionDurations.normal);
      await t.pump(MotionDurations.normal);
      // The panel's own caption says "the pressed state fills with the blue
      // tint — selection is always blue". `data-[state=on]:bg-muted` says
      // otherwise, and blue selection is real one panel further down.
      expect(surfaceOf(t).fill, ThemeTokens.dark.muted);
      expect(surfaceOf(t).fill, isNot(ThemeTokens.dark.primary));
    });

    testWidgets('disabled is 50%, not the Button\'s 45% — drift 12', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(toggle(enabled: false));
      final Opacity opacity = t.widget<Opacity>(
        find
            .descendant(of: find.byType(Toggle), matching: find.byType(Opacity))
            .first,
      );
      expect(opacity.opacity, 0.50);
    });

    testWidgets('has no press feedback at all — drift 11', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(toggle());
      // A Toggle's class list has no `:active` rule and no `press` utility, so
      // nothing may scale it — measured (audit G2): `scale` and `transform`
      // both read `none` in every state, `:active` included. `Button` does
      // not reach for `Press` either any more (B1) — it snaps its own scale —
      // but this assertion is about the utility being absent, which is what a
      // regression here would reintroduce.
      expect(
        find.descendant(of: find.byType(Toggle), matching: find.byType(Press)),
        findsNothing,
      );

      final TestGesture hold = await t.startGesture(
        t.getCenter(find.byType(Toggle)),
      );
      await t.pump(MotionDurations.tick);
      final Size held = t.getSize(find.byType(Toggle));
      // TARGET SIZING: the reference reads `h-8` (32); the real layout is
      // floored at TouchTargets.minimum (44) — see the geometry test above.
      expect(held.height, TouchTargets.minimum);
      await hold.up();
      await t.pump(MotionDurations.normal);
    });

    testWidgets('focus draws the 3px ring at --ring @50%', (
      WidgetTester t,
    ) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(
        host(
          Toggle(
            pressed: false,
            focusNode: node,
            label: 'Favourite',
            onChanged: (bool _) {},
            child: const Icon(IconGlyph.heart),
          ),
        ),
      );

      node.requestFocus();
      await t.pump();
      await t.pump(MotionDurations.normal);
      await t.pump(MotionDurations.normal);

      final ShadowLayer ring = surfaceOf(t).spec.layers.single;
      expect(ring.spread, 3);
      expect(ring.blur, 0);
      expect(
        ring.color(ThemeTokens.dark),
        ThemeTokens.dark.ring.withValues(alpha: 0.50),
      );
    });

    testWidgets('toggles on tap and on Space', (WidgetTester t) async {
      final List<bool> changes = <bool>[];
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(
        host(
          Toggle(
            pressed: false,
            focusNode: node,
            label: 'Favourite',
            onChanged: changes.add,
            child: const Icon(IconGlyph.heart),
          ),
        ),
      );

      await t.tap(find.byType(Toggle));
      await t.pump();
      node.requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.space);
      await t.pump();
      // Both routes ask for the opposite of the state they were handed.
      expect(changes, <bool>[true, true]);
    });
  });

  group('ToggleGroup', () {
    Widget group({int? selected, ValueChanged<int?>? onChanged}) => host(
      ToggleGroup(
        selectedIndex: selected,
        onChanged: onChanged ?? (int? _) {},
        items: const <ToggleGroupItem>[
          ToggleGroupItem(label: 'Newest'),
          ToggleGroupItem(label: 'Price'),
          ToggleGroupItem(label: 'Popular'),
        ],
      ),
    );

    test('the group gap is `--gap: 2`, i.e. 8px', () {
      expect(ToggleGroup.gap, space(2));
    });

    testWidgets('lays three items out 8px apart', (WidgetTester t) async {
      await t.pumpWidget(group(selected: 0));
      await t.pump();

      final Rect first = t.getRect(find.byType(Toggle).at(0));
      final Rect second = t.getRect(find.byType(Toggle).at(1));
      expect(second.left - first.right, closeTo(space(2), 1e-9));
    });

    testWidgets('the pill is a --primary stadium over a 12px item — drift 9', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(group(selected: 0));
      await t.pump();
      await t.pump();

      // The indicator: `bg-primary rounded-pill shadow-chip`.
      final Surface pill = t.widget<Surface>(
        find
            .descendant(
              of: find.byType(ActiveIndicator),
              matching: find.byType(Surface),
            )
            .first,
      );
      expect(pill.fill, ThemeTokens.dark.primary);
      expect(pill.radius, BorderRadius.circular(Radii.full));
      expect(pill.spec, same(Shadows.compactControl));

      // The item underneath it is still `rounded-lg`. Two shapes, one slot:
      // hover-on-unselected paints a 12px rect where selection paints a
      // 16px stadium.
      final Surface item = t.widget<Surface>(
        find
            .descendant(
              of: find.byType(Toggle).at(0),
              matching: find.byType(Surface),
            )
            .first,
      );
      expect(item.radius, BorderRadius.circular(Radii.lg));
    });

    testWidgets('the selected item gives up its fill and flips to white ink', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(group(selected: 1));
      await t.pump(MotionDurations.normal);
      await t.pump(MotionDurations.normal);

      Surface itemAt(int i) => t.widget<Surface>(
        find
            .descendant(
              of: find.byType(Toggle).at(i),
              matching: find.byType(Surface),
            )
            .first,
      );
      TextStyle inkAt(int i) => t
          .widget<DefaultTextStyle>(
            find
                .descendant(
                  of: find.byType(Toggle).at(i),
                  matching: find.byType(DefaultTextStyle),
                )
                .first,
          )
          .style;

      // `data-[state=on]:bg-transparent` — declared last on purpose, because
      // the pill is the background now.
      expect(itemAt(1).fill, transparent);
      expect(inkAt(1).color, ThemeTokens.dark.primaryForeground);
      // Its unselected neighbours are unchanged.
      expect(itemAt(0).fill, transparent);
      expect(inkAt(0).color, ThemeTokens.dark.foreground);
    });

    testWidgets('tapping the selected item deselects — ruling B7', (
      WidgetTester t,
    ) async {
      final List<int?> changes = <int?>[];
      await t.pumpWidget(group(selected: 1, onChanged: changes.add));
      await t.pump();

      // Radix `type="single"` clears on a second press of the active item.
      await t.tap(find.byType(Toggle).at(1));
      await t.pump();
      expect(changes, <int?>[null]);

      // And an unselected neighbour still selects normally.
      await t.tap(find.byType(Toggle).at(2));
      await t.pump();
      expect(changes, <int?>[null, 2]);
    });

    testWidgets('nothing selected hides the pill', (WidgetTester t) async {
      await t.pumpWidget(group(selected: null));
      await t.pump();
      await t.pump();
      await t.pump(MotionDurations.fast);
      await t.pump(MotionDurations.fast);

      // `activeIndex: -1` — the substrate's documented out-of-range path, and
      // the reason it exists at all.
      final AnimatedOpacity fade = t.widget<AnimatedOpacity>(
        find
            .descendant(
              of: find.byType(ActiveIndicator),
              matching: find.byType(AnimatedOpacity),
            )
            .first,
      );
      expect(fade.opacity, 0);
    });
  });

  group('ButtonGroup', () {
    // The three groups the page renders, verbatim (buttons-map §6.2).
    List<Widget> groupA() => <Widget>[
      Button(
        variant: ButtonVariant.outline,
        onPressed: () {},
        child: const Text('Newest'),
      ),
      Button(
        variant: ButtonVariant.outline,
        onPressed: () {},
        child: const Text('Price'),
      ),
      Button(
        variant: ButtonVariant.outline,
        onPressed: () {},
        child: const Text('Popularity'),
      ),
    ];

    List<Widget> groupB() => <Widget>[
      const ButtonGroupText('Quantity'),
      const ButtonGroupSeparator(),
      Button(
        variant: ButtonVariant.outline,
        size: ButtonSize.icon,
        label: 'Decrease quantity',
        onPressed: () {},
        child: const Icon(IconGlyph.minus),
      ),
      const ButtonGroupText('3', numeric: true),
      Button(
        variant: ButtonVariant.outline,
        size: ButtonSize.icon,
        label: 'Increase quantity',
        onPressed: () {},
        child: const Icon(IconGlyph.plus),
      ),
    ];

    List<Widget> groupC() => <Widget>[
      Button(onPressed: () {}, child: const Text('Open Pack')),
      const ButtonGroupSeparator(),
      Button(
        size: ButtonSize.icon,
        label: 'More open options',
        onPressed: () {},
        child: const Icon(IconGlyph.chevronDown),
      ),
    ];

    test('group A: pill on the left, 12px on the right — drift 7', () {
      final List<Widget> a = groupA();
      // The leading member keeps its own radius; the trailing one is forced to
      // `--radius-lg` by an `!important` rule. Asymmetric by construction.
      expect(ButtonGroup.radiiOf(a, 0).topLeft.x, Radii.full);
      expect(ButtonGroup.radiiOf(a, 0).topRight.x, 0);
      // Interior corners are squared on both sides.
      expect(ButtonGroup.radiiOf(a, 1).topLeft.x, 0);
      expect(ButtonGroup.radiiOf(a, 1).topRight.x, 0);
      expect(ButtonGroup.radiiOf(a, 2).topLeft.x, 0);
      expect(ButtonGroup.radiiOf(a, 2).topRight.x, Radii.lg);
    });

    test('group B is symmetric only because it opens with a Text cell', () {
      final List<Widget> b = groupB();
      // 12px both ends — and the left 12 is the `ButtonGroupText`'s own
      // `rounded-lg`, not anything the group did.
      expect(ButtonGroup.radiiOf(b, 0).topLeft.x, Radii.lg);
      expect(ButtonGroup.radiiOf(b, 4).topRight.x, Radii.lg);
    });

    test('group C: pill left, 12px right', () {
      final List<Widget> c = groupC();
      expect(ButtonGroup.radiiOf(c, 0).topLeft.x, Radii.full);
      expect(ButtonGroup.radiiOf(c, 2).topRight.x, Radii.lg);
    });

    test('the rounding rule reaches PAST a Text cell — drift 8', () {
      // `ButtonGroupText` sets no `data-slot`, so it can never satisfy
      // `[&>[data-slot]:not(:has(~[data-slot]))]` and the rule lands on the
      // last member that can — here the Button, which is not last.
      final List<Widget> trailing = <Widget>[
        Button(onPressed: () {}, child: const Text('Open Pack')),
        const ButtonGroupText('of 12'),
      ];
      expect(
        ButtonGroup.radiiOf(trailing, 0).topRight.x,
        Radii.lg,
        reason: 'an interior Button forced to 12px by the reach-past',
      );
    });

    test('only the first member keeps a left border — border-l-0', () {
      final List<Widget> a = groupA();
      expect(ButtonGroup.hasLeftBorder(a, 0), isTrue);
      expect(ButtonGroup.hasLeftBorder(a, 1), isFalse);
      expect(ButtonGroup.hasLeftBorder(a, 2), isFalse);
    });

    testWidgets('members are flush and stretch to the tallest', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(ButtonGroup(children: groupB())));

      // `items-stretch` is what gives the height-less Text cell its 40px.
      final double rowHeight = t.getSize(find.byType(ButtonGroup)).height;
      expect(rowHeight, space(10));
      expect(t.getSize(find.byType(ButtonGroupText).first).height, space(10));

      // `gap` is 0 — the `has-[>[data-slot=button-group]]:gap-2` rule needs a
      // nested group, and nothing on this page nests.
      final Rect text = t.getRect(find.byType(ButtonGroupText).first);
      final Rect rule = t.getRect(find.byType(ButtonGroupSeparator));
      expect(rule.left, closeTo(text.right, 1e-9));
    });

    testWidgets('the separator is 1px wide and inset 1px top and bottom', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(ButtonGroup(children: groupC())));

      // `self-stretch` makes the separator's own box the full row height…
      expect(t.getSize(find.byType(ButtonGroupSeparator)).height, space(10));

      // …and `my-px` is a *margin*, so the painted rule stops one pixel short
      // at each end. `w-px` is the width.
      final Size rule = t.getSize(
        find.descendant(
          of: find.byType(ButtonGroupSeparator),
          matching: find.byType(ColoredBox),
        ),
      );
      expect(rule.width, BorderWidths.hairline);
      expect(rule.height, space(10) - 2 * BorderWidths.hairline);
    });

    testWidgets('a Text cell is --muted at 13/500, 10px in from its border', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(ButtonGroup(children: groupB())));

      final DecoratedBox box = t.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(ButtonGroupText).first,
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect((box.decoration as BoxDecoration).color, ThemeTokens.dark.muted);
      expect(ButtonGroupText.paddingX, 10);

      final TextStyle style = t
          .widget<Text>(
            find.descendant(
              of: find.byType(ButtonGroupText).first,
              matching: find.byType(Text),
            ),
          )
          .style!;
      expect(style.fontSize, TextStyles.nav.step.size);
      expect(style.fontFamily, contains('InterLocal'));
    });

    testWidgets('a numeric cell keeps the numeric role whole', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(ButtonGroup(children: groupB())));

      final TextStyle style = t
          .widget<Text>(
            find.descendant(
              of: find.byType(ButtonGroupText).at(1),
              matching: find.byType(Text),
            ),
          )
          .style!;
      expect(style.fontSize, TextStyles.numberBase.step.size);
      expect(
        style.fontVariations!
            .firstWhere((FontVariation v) => v.axis == 'wght')
            .value,
        TextStyles.numberBase.wght,
        reason: 'the numeric role arrives whole, weight included',
      );
      // …and everything they do not declare survives.
      expect(style.fontFamily, contains('GeistMono'));
      expect(
        style.letterSpacing,
        closeTo(-0.01 * TextStyles.numberBase.step.size, 1e-9),
      );
      expect(style.fontFeatures, contains(const FontFeature.tabularFigures()));
    });
  });

  group('Kbd', () {
    test('20 minimum tall and wide, 4px padding, 4px gaps', () {
      expect(Kbd.minHeight, 20);
      expect(Kbd.minWidth, 20);
      expect(Kbd.paddingX, 4);
      expect(Kbd.gap, 4);
      expect(KbdGroup.gap, 4);
    });

    testWidgets(
      'is a flat 6px --muted chip — no border, no shadow — drift 18',
      (WidgetTester t) async {
        await t.pumpWidget(host(const Kbd('Esc')));

        final Surface surface = t.widget<Surface>(
          find
              .descendant(of: find.byType(Kbd), matching: find.byType(Surface))
              .first,
        );
        expect(surface.fill, ThemeTokens.dark.muted);
        expect(surface.radius, BorderRadius.circular(Radii.sm));
        // `--shadow-key`, `--shadow-key-down` and `press-key` all exist for
        // exactly this object, one foundations page away, and Kbd uses none.
        expect(surface.spec.layers, isEmpty);
        expect(surface.border, isNull);
      },
    );

    testWidgets('never smaller than 20 x 20, and grows with its legend', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const Kbd('K')));
      final Size box = t.getSize(find.byType(Kbd));
      // A single narrow glyph plus its padding is under the floor, so the
      // minimum decides both dimensions.
      expect(box.height, greaterThanOrEqualTo(Kbd.minHeight));
      expect(box.width, greaterThanOrEqualTo(Kbd.minWidth));

      await t.pumpWidget(host(const Kbd('Space')));
      expect(t.getSize(find.byType(Kbd)).width, greaterThan(box.width));
    });

    testWidgets('the key label is the code role at --muted-foreground', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const Kbd('Ctrl')));
      final TextStyle style = t
          .widget<Text>(
            find.descendant(of: find.byType(Kbd), matching: find.byType(Text)),
          )
          .style!;
      expect(style.fontSize, TextStyles.code.step.size);
      expect(style.fontFamily, contains(Fonts.mono));
      expect(style.color, ThemeTokens.dark.mutedForeground);
    });

    testWidgets('a group is one shortcut, 4px apart — drift 19', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(const KbdGroup(children: <Widget>[Kbd('Ctrl'), Kbd('K')])),
      );

      final Rect ctrl = t.getRect(find.byType(Kbd).at(0));
      final Rect k = t.getRect(find.byType(Kbd).at(1));
      expect(k.left - ctrl.right, closeTo(KbdGroup.gap, 1e-9));

      // `<kbd><kbd>Ctrl</kbd><kbd>K</kbd></kbd>` is one keyboard object, and
      // it is announced as one.
      expect(
        find.descendant(
          of: find.byType(KbdGroup),
          matching: find.byType(MergeSemantics),
        ),
        findsOneWidget,
      );
    });
  });

  group('IconSwap', () {
    Widget swap(int active) => host(
      IconSwap(
        activeIndex: active,
        window: 20,
        cell: 16,
        icons: const <Widget>[
          Icon(IconGlyph.layoutGrid),
          Icon(IconGlyph.rows3),
        ],
      ),
    );

    testWidgets('is a fixed clip window, whatever the strip is doing', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(swap(0));
      expect(t.getSize(find.byType(IconSwap)), const Size(20, 20));
    });

    test('an unknown index clamps to 0, as Math.max(0, indexOf) does', () {
      expect(IconSwap.resolveIndex(-1, 2), 0);
      expect(IconSwap.resolveIndex(7, 2), 0);
      expect(IconSwap.resolveIndex(1, 2), 1);
    });

    testWidgets('the leaver exits through the top and the arriver rises', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(swap(0));
      await t.pump(ContentSwapMotion.duration);
      await t.pump(ContentSwapMotion.duration);

      double yOf(int i) => t.getRect(find.byType(Icon).at(i)).center.dy;
      final double windowCentre = t.getRect(find.byType(IconSwap)).center.dy;

      // At rest: glyph 0 centred, glyph 1 parked one full step BELOW.
      expect(yOf(0), closeTo(windowCentre, 0.51));
      expect(yOf(1) - yOf(0), closeTo(ContentSwapMotion.travelFor(16), 0.51));

      await t.pumpWidget(swap(1));
      await t.pump(ContentSwapMotion.duration);
      await t.pump(ContentSwapMotion.duration);
      await t.pump(StateChangeMotion.duration);

      // After the roll the strip has moved up by exactly one step: glyph 1 is
      // centred and glyph 0 has left through the top.
      expect(yOf(1), closeTo(windowCentre, 0.51));
      expect(yOf(0), lessThan(windowCentre));
      expect(yOf(1) - yOf(0), closeTo(ContentSwapMotion.travelFor(16), 0.51));
    });

    testWidgets('the arriving glyph squashes on FIRST MOUNT too', (
      WidgetTester t,
    ) async {
      // The one place IconSwap is the inverse of the sliding indicator: the pill
      // deliberately lands its first placement silently, and every IconSwap
      // demo deliberately squashes once on page load.
      List<double> scalesUnderSwap() => t
          .widgetList<Transform>(
            find.descendant(
              of: find.byType(IconSwap),
              matching: find.byType(Transform),
            ),
          )
          .map((Transform x) => x.transform.storage[0])
          .toList();

      await t.pumpWidget(swap(0));
      await t.pump();

      // `animation-delay: var(--duration-fast)` — still identity at 150ms…
      await t.pump(ContentSwapMotion.squashDelay);
      expect(
        scalesUnderSwap().every((double s) => (s - 1).abs() < 1e-6),
        isTrue,
        reason: 'the delay holds stop 0',
      );

      // …and 30% into the 600ms jelly it is at the table's widest stop, 1.18.
      await t.pump(const Duration(milliseconds: 180));
      expect(scalesUnderSwap().any((double s) => s > 1.1), isTrue);

      // It settles back to identity by the end of the run.
      await t.pump(StateChangeMotion.duration);
      expect(
        scalesUnderSwap().every((double s) => (s - 1).abs() < 1e-6),
        isTrue,
      );
    });

    testWidgets('reduced motion lands the swap instantly — ruling B13', (
      WidgetTester t,
    ) async {
      Widget stilled(int active) => MediaQuery(
        data: const MediaQueryData(
          size: Size(1440, 900),
          disableAnimations: true,
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: ThemeScope(
            controller: ThemeController(mode: ColorMode.dark),
            child: Center(
              child: IconSwap(
                activeIndex: active,
                window: 20,
                cell: 16,
                icons: const <Widget>[
                  Icon(IconGlyph.play),
                  Icon(IconGlyph.pause),
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

      final double windowCentre = t.getRect(find.byType(IconSwap)).center.dy;
      expect(
        t.getRect(find.byType(Icon).at(1)).center.dy,
        closeTo(windowCentre, 0.51),
      );
    });

    /* ── S1–S8: guards over measured-correct behaviour ────────────────────── */

    // `docs/superpowers/research/behavior-audit.md` §2.4 traced all eight legs
    // of this module against the reference in the browser and found **every
    // one a match** — the only module of the three audited that was wholly
    // correct. These guards exist for that reason and not despite it: the
    // audit's own §"Explicitly protect" lists the icon swap entire, and a leg
    // with no test is a leg a well-meaning later "fix" can quietly retune. Each
    // number below is the measured web value, not a derivation.

    double centre(WidgetTester t) => t.getRect(find.byType(IconSwap)).center.dy;
    double yOf(WidgetTester t, int i) =>
        t.getRect(find.byType(Icon).at(i)).center.dy;
    List<double> opacities(WidgetTester t) => t
        .widgetList<Opacity>(
          find.descendant(
            of: find.byType(IconSwap),
            matching: find.byType(Opacity),
          ),
        )
        .map((Opacity o) => o.opacity)
        .toList();

    testWidgets('S1: the strip travels 160% of the CELL, at both call sites', (
      WidgetTester t,
    ) async {
      // Measured 25.6px against a 16px glyph. A CSS percentage translate
      // resolves against the element's own border box, so the multiplier hangs
      // off the cell and never off the 20/24px clip window.
      expect(ContentSwapMotion.travelFor(16), closeTo(25.6, 1e-9));
      expect(ContentSwapMotion.travelFor(20), closeTo(32, 1e-9));
      expect(MotionTransforms.swapRollTravel, 1.6);

      await t.pumpWidget(swap(0));
      await t.pump(ContentSwapMotion.duration);
      await t.pump(StateChangeMotion.duration);
      expect(
        yOf(t, 1) - yOf(t, 0),
        closeTo(25.6, 0.51),
        reason: 'the parked cell sits one full step below, not one window',
      );
    });

    testWidgets('S2: 400ms on the spring, and the overshoot is NOT clamped', (
      WidgetTester t,
    ) async {
      // 400ms `--ease-spring`, peaking 9.77% past centre. The transform is left
      // unclamped on purpose — clamping it is the "fix" this guards against.
      expect(ContentSwapMotion.duration, const Duration(milliseconds: 400));
      expect(ContentSwapMotion.curve, MotionCurves.emphasized);

      await t.pumpWidget(swap(0));
      await t.pump(ContentSwapMotion.duration);
      await t.pump(StateChangeMotion.duration);
      final double home = centre(t);

      await t.pumpWidget(swap(1));
      double furthest = 0;
      for (int ms = 0; ms < 400; ms += 10) {
        await t.pump(const Duration(milliseconds: 10));
        // The arriver rises to centre; past it, dy goes negative.
        final double past = home - yOf(t, 1);
        if (past > furthest) furthest = past;
      }
      expect(
        furthest / ContentSwapMotion.travelFor(16),
        closeTo(0.0977, 0.015),
        reason: 'measured +9.77% of travel past centre, mid-flight',
      );

      await t.pump(ContentSwapMotion.duration);
      await t.pump(StateChangeMotion.duration);
      expect(
        yOf(t, 1),
        closeTo(home, 0.51),
        reason: 'and it settles ON centre',
      );
    });

    testWidgets('S3: opacity rides the same clock and is CLAMPED', (
      WidgetTester t,
    ) async {
      // Not a second, shorter duration: the spring first reaches y=1 at ~40% of
      // 400ms and the browser clamps the overshoot, so the crossfade is
      // visually finished at 163ms while the strip is still travelling.
      await t.pumpWidget(swap(0));
      await t.pump(ContentSwapMotion.duration);
      await t.pump(StateChangeMotion.duration);

      await t.pumpWidget(swap(1));
      for (int ms = 0; ms < 400; ms += 10) {
        await t.pump(const Duration(milliseconds: 10));
        for (final double o in opacities(t)) {
          expect(
            o,
            inInclusiveRange(0, 1),
            reason: 'the browser clamps; so must this',
          );
        }
      }
      await t.pump(StateChangeMotion.duration);
      expect(opacities(t), <double>[0, 1]);
    });

    testWidgets('S3b: the crossfade is done at 163ms, the roll is not', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(swap(0));
      await t.pump(ContentSwapMotion.duration);
      await t.pump(StateChangeMotion.duration);
      final double home = centre(t);

      await t.pumpWidget(swap(1));
      await t.pump(const Duration(milliseconds: 163));
      expect(opacities(t), <double>[
        0,
        1,
      ], reason: 'measured: opacity pinned from 163ms');
      expect(
        (yOf(t, 1) - home).abs(),
        greaterThan(0.51),
        reason: 'and the strip has 237ms still to run',
      );
    });

    testWidgets('S4: reverse is the exact arithmetic inverse of advance', (
      WidgetTester t,
    ) async {
      // Advance sends the leaver up and out the top; reversing mirrors it with
      // no special-casing anywhere — `offset = i - strip(t)` does both.
      await t.pumpWidget(swap(0));
      await t.pump(ContentSwapMotion.duration);
      await t.pump(StateChangeMotion.duration);
      final double home = centre(t);

      await t.pumpWidget(swap(1));
      await t.pump(ContentSwapMotion.duration);
      await t.pump(StateChangeMotion.duration);
      expect(
        yOf(t, 0),
        lessThan(home),
        reason: 'advance: leaver exits the TOP',
      );
      final double advanced = home - yOf(t, 0);

      await t.pumpWidget(swap(0));
      await t.pump(ContentSwapMotion.duration);
      await t.pump(StateChangeMotion.duration);
      expect(
        yOf(t, 1),
        greaterThan(home),
        reason: 'reverse: the leaver goes back out the BOTTOM',
      );
      expect(yOf(t, 1) - home, closeTo(advanced, 0.51));
    });

    testWidgets('S5: the squash waits 150ms, then runs 600 — one 750ms clock', (
      WidgetTester t,
    ) async {
      expect(ContentSwapMotion.squashDelay, const Duration(milliseconds: 150));
      expect(StateChangeMotion.duration, const Duration(milliseconds: 600));
      expect(
        ContentSwapMotion.squashDelay + StateChangeMotion.duration,
        const Duration(milliseconds: 750),
        reason: 'total visible motion, roll included, is 750ms',
      );
    });

    testWidgets('S6: every glyph is built at once, the inactive one at zero', (
      WidgetTester t,
    ) async {
      // Not an AnimatedSwitcher: the strip is one Stack holding all of them,
      // which is why the leaver can be seen travelling out.
      await t.pumpWidget(swap(0));
      await t.pump(ContentSwapMotion.duration);
      await t.pump(StateChangeMotion.duration);

      expect(
        find.descendant(of: find.byType(IconSwap), matching: find.byType(Icon)),
        findsNWidgets(2),
      );
      expect(opacities(t), <double>[1, 0]);
      expect(
        (yOf(t, 1) - yOf(t, 0)).abs(),
        closeTo(25.6, 0.51),
        reason: 'parked at +step, present and invisible',
      );
    });

    testWidgets('S7: no roll on FIRST BUILD, but the jelly runs once', (
      WidgetTester t,
    ) async {
      // Measured from before hydration: the roll transform never leaves the
      // identity matrix on mount. The active glyph is on centre in frame one —
      // a mount that rolls in from off-screen is the regression.
      await t.pumpWidget(swap(1));
      await t.pump();
      expect(
        yOf(t, 1),
        closeTo(centre(t), 0.51),
        reason: 'the active glyph is home on the very first frame',
      );
      expect(opacities(t), <double>[0, 1], reason: 'and no crossfade either');

      // …while `yuki-jelly` (delay 0.15s, `both`) does run its full 600ms once.
      await t.pump(ContentSwapMotion.squashDelay);
      await t.pump(const Duration(milliseconds: 180));
      final List<double> scales = t
          .widgetList<Transform>(
            find.descendant(
              of: find.byType(IconSwap),
              matching: find.byType(Transform),
            ),
          )
          .map((Transform x) => x.transform.storage[0])
          .toList();
      expect(
        scales.any((double s) => s > 1.1),
        isTrue,
        reason: 'stop 2 of the jelly, 1.18',
      );
      await t.pump(StateChangeMotion.duration);
    });

    testWidgets('S8: an interruption re-targets from the CURRENT transform and '
        'runs the full 400ms', (WidgetTester t) async {
      // Measured at a reversal 264ms into a 400ms roll — mid-overshoot, with
      // the strip at −28.10 rather than its −25.60 target. CSS re-targets from
      // where the box actually is and restarts the whole duration; snapping to
      // the target first, or finishing early, are both the regression.
      await t.pumpWidget(swap(0));
      await t.pump(ContentSwapMotion.duration);
      await t.pump(StateChangeMotion.duration);
      final double home = centre(t);

      await t.pumpWidget(swap(1));
      await t.pump(const Duration(milliseconds: 264));
      final double interrupted = yOf(t, 0);
      expect(
        home - interrupted,
        greaterThan(ContentSwapMotion.travelFor(16)),
        reason: 'at 264ms the leaver is PAST its target, mid-overshoot',
      );

      await t.pumpWidget(swap(0));
      await t.pump();
      expect(
        yOf(t, 0),
        closeTo(interrupted, 0.51),
        reason:
            'the reversal starts from where the strip is, not from the '
            'target it never reached',
      );

      // Still travelling most of the way through a fresh 400ms…
      await t.pump(const Duration(milliseconds: 200));
      expect(
        (yOf(t, 0) - home).abs(),
        greaterThan(0.51),
        reason: 'a shortened or scaled-down return is the regression',
      );

      await t.pump(ContentSwapMotion.duration);
      await t.pump(StateChangeMotion.duration);
      expect(yOf(t, 0), closeTo(home, 0.51));
    });
  });

  group('Sheet', () {
    Widget trigger({double? width}) => navHost(
      Builder(
        builder: (BuildContext context) {
          return Button(
            variant: ButtonVariant.outline,
            onPressed: () => Sheet.showLeft(
              context,
              width: width ?? LayoutWidths.sidebarMobile,
              builder: (BuildContext c) =>
                  StyledText('Design system', TextStyles.nav),
            ),
            child: const Icon(IconGlyph.menu),
          );
        },
      ),
    );

    testWidgets('opens a 288px panel against the left edge', (
      WidgetTester t,
    ) async {
      useFrame(t);
      await t.pumpWidget(trigger());
      await t.tap(find.byType(Button));
      await t.pumpAndSettle();

      expect(find.text('Design system'), findsOneWidget);
      final Rect panel = t.getRect(find.byType(SheetPanel));
      expect(panel.width, LayoutWidths.sidebarMobile);
      expect(panel.left, 0);
      expect(panel.height, 900);
    });

    testWidgets('honours an explicit width', (WidgetTester t) async {
      useFrame(t);
      await t.pumpWidget(trigger(width: LayoutWidths.sidebar));
      await t.tap(find.byType(Button));
      await t.pumpAndSettle();

      expect(t.getRect(find.byType(SheetPanel)).width, LayoutWidths.sidebar);
    });

    testWidgets('the right-hand hairline comes out of the 288, not off it', (
      WidgetTester t,
    ) async {
      // `w-72` under `box-sizing: border-box`: 288px including the border, so
      // the sheet's content is 287 wide and the panel's right edge is where
      // the page resumes.
      useFrame(t);
      await t.pumpWidget(trigger());
      await t.tap(find.byType(Button));
      await t.pumpAndSettle();

      expect(
        t.getSize(find.byType(SafeArea)).width,
        LayoutWidths.sidebarMobile - BorderWidths.hairline,
      );
    });

    testWidgets('slides in from 40px out, over the overlay duration', (
      WidgetTester t,
    ) async {
      useFrame(t);
      await t.pumpWidget(trigger());
      await t.tap(find.byType(Button));
      await t.pump(); // route pushed, animation at zero

      // CORRECTED 2026-08-16, measured. `slide-in-from-left-10` is **not** 10
      // spacing units: the installed tw-animate-css resolves it to
      // `calc(.1 * 100%)`, a percentage of the element's own border box. The
      // live sheet's first `enter` frame reads `matrix(1,0,0,1,38.4,0)` against
      // a 384px panel — so the 288px docs sheet travels 28.8, not 40.
      expect(
        t.getRect(find.byType(SheetPanel)).left,
        closeTo(-LayoutWidths.sidebarMobile * 0.1, 0.5),
      );

      await t.pump(MotionDurations.overlayEnter);
      expect(t.getRect(find.byType(SheetPanel)).left, closeTo(0, 0.5));
    });

    testWidgets('blurs and tints what is behind it', (WidgetTester t) async {
      useFrame(t);
      await t.pumpWidget(trigger());
      await t.tap(find.byType(Button));
      await t.pumpAndSettle();

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('a tap outside dismisses it', (WidgetTester t) async {
      useFrame(t);
      await t.pumpWidget(trigger());
      await t.tap(find.byType(Button));
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
  // NOTE: not one `pumpAndSettle` below. `premium-surface` runs two forever-loops
  // and `action-feedback`'s beat runs while hovered, so a settle would never
  // return. `pump(Duration)` with explicit steps only.
  group('Button state matrix', () {
    /// The one [Surface] a flat variant paints itself with. The two
    /// gradient variants also contain one — the inset half of their spec —
    /// so those read [ActionFeedback] / [PremiumSurface] instead.
    Surface surfaceOf(WidgetTester t) =>
        t.widget<Surface>(find.byType(Surface));

    ActionFeedback sheenOf(WidgetTester t) =>
        t.widget<ActionFeedback>(find.byType(ActionFeedback));

    PremiumSurface foilOf(WidgetTester t) =>
        t.widget<PremiumSurface>(find.byType(PremiumSurface));

    TextStyle labelStyleOf(WidgetTester t) => t
        .widget<DefaultTextStyle>(
          find
              .descendant(
                of: find.byType(Button),
                matching: find.byType(DefaultTextStyle),
              )
              .first,
        )
        .style;

    Color borderOf(WidgetTester t) =>
        (surfaceOf(t).border! as Border).top.color;

    Future<void> mount(
      WidgetTester t,
      ButtonVariant variant, {
      ColorMode mode = ColorMode.dark,
      FocusNode? focusNode,
    }) => t.pumpWidget(
      host(
        Button(
          variant: variant,
          focusNode: focusNode,
          onPressed: () {},
          child: const Icon(IconGlyph.check),
        ),
        mode: mode,
      ),
    );

    /// Hover, then run the 250ms `btn-spring` colour transition to its end.
    Future<TestGesture> hoverAndSettle(WidgetTester t) async {
      final TestGesture mouse = await hoverOver(t, find.byType(Button));
      await t.pump(MotionDurations.normal);
      await t.pump(MotionDurations.normal);
      return mouse;
    }

    Future<TestGesture> holdDown(WidgetTester t) async {
      final TestGesture g = await t.startGesture(
        t.getCenter(find.byType(Button)),
      );
      await t.pump();
      await t.pump(MotionDurations.tick);
      return g;
    }

    Future<void> focusAndSettle(WidgetTester t, FocusNode node) async {
      node.requestFocus();
      await t.pump();
      await t.pump(MotionDurations.normal);
      await t.pump(MotionDurations.normal);
    }

    testWidgets('the cva default is `default`, i.e. primary', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(Button(onPressed: () {}, child: const Icon(IconGlyph.check))),
      );
      expect(
        find.byType(ActionFeedback),
        findsOneWidget,
        reason: 'defaultVariants.variant = "default" in button.tsx',
      );
      expect(
        t.widget<Button>(find.byType(Button)).variant,
        ButtonVariant.primary,
      );
    });

    testWidgets('the enum carries all seven cva variants, in source order', (
      WidgetTester t,
    ) async {
      expect(ButtonVariant.values, <ButtonVariant>[
        ButtonVariant.primary,
        ButtonVariant.premium,
        ButtonVariant.secondary,
        ButtonVariant.outline,
        ButtonVariant.ghost,
        ButtonVariant.destructive,
        ButtonVariant.link,
      ]);
    });

    group('aria-expanded — an open trigger holds its hover fill', () {
      /// [mount], plus the attribute `DropdownMenuTrigger asChild` merges into
      /// the `Button` it renders.
      ///
      /// The two pumps are belt and braces: `btn-spring` carries colour over
      /// 250ms, but a button mounted already-expanded has nothing to spring
      /// *from*, so the fill is right on the first frame and stays right.
      Future<void> mountExpanded(WidgetTester t, ButtonVariant variant) async {
        await t.pumpWidget(
          host(
            Button(
              variant: variant,
              expanded: true,
              onPressed: () {},
              child: const Icon(IconGlyph.check),
            ),
          ),
        );
        await t.pump(MotionDurations.normal);
        await t.pump(MotionDurations.normal);
      }

      testWidgets('ghost: --secondary over --foreground, with no pointer '
          'anywhere near it', (WidgetTester t) async {
        await mountExpanded(t, ButtonVariant.ghost);
        // `aria-expanded:bg-secondary aria-expanded:text-foreground` — the
        // pair its hover already paints, held while the menu is open. The gap
        // this closes is exactly the pointer-less case.
        expect(surfaceOf(t).fill, ThemeTokens.dark.secondary);
        expect(labelStyleOf(t).color, ThemeTokens.dark.foreground);
      });

      testWidgets('outline: --muted, which is its own hover fill', (
        WidgetTester t,
      ) async {
        await mountExpanded(t, ButtonVariant.outline);
        expect(surfaceOf(t).fill, ThemeTokens.dark.muted);
      });

      testWidgets('secondary: --accent, likewise', (WidgetTester t) async {
        await mountExpanded(t, ButtonVariant.secondary);
        expect(surfaceOf(t).fill, ThemeTokens.dark.accent);
      });

      testWidgets('the other four declare no `aria-expanded:` class at all', (
        WidgetTester t,
      ) async {
        // The two ramps read `hovered` themselves, and an open trigger is not
        // a hovered one.
        await mountExpanded(t, ButtonVariant.primary);
        expect(sheenOf(t).hovered, isFalse);
        expect(sheenOf(t).spec, same(Shadows.controlPrimary));

        await mountExpanded(t, ButtonVariant.premium);
        expect(foilOf(t).hovered, isFalse);
        expect(foilOf(t).spec, same(Shadows.controlPremium));

        // The two flat ones are compared against their own rest. The pumps
        // matter: the element survives a re-pump, so the fill springs from the
        // *previous* variant's colour and a reading taken on the first frame
        // would be the one before it.
        Future<Color?> restFillOf(ButtonVariant variant) async {
          await mount(t, variant);
          await t.pump(MotionDurations.normal);
          await t.pump(MotionDurations.normal);
          return surfaceOf(t).fill;
        }

        for (final ButtonVariant variant in <ButtonVariant>[
          ButtonVariant.destructive,
          ButtonVariant.link,
        ]) {
          final Color? rest = await restFillOf(variant);
          await mountExpanded(t, variant);
          expect(surfaceOf(t).fill, rest, reason: '$variant is unmoved by it');
        }

        // …and the teeth for that comparison: destructive's hover IS a
        // different fill, so the equality above is an assertion rather than
        // two identical nothings agreeing.
        final Color? rest = await restFillOf(ButtonVariant.destructive);
        await hoverAndSettle(t);
        expect(surfaceOf(t).fill, isNot(rest));
      });
    });

    group('primary — action-feedback bg-primary shadow-btn-primary', () {
      testWidgets('rest: btn-primary, white ink, transparent border', (
        WidgetTester t,
      ) async {
        await mount(t, ButtonVariant.primary);
        final ActionFeedback sheen = sheenOf(t);
        expect(sheen.spec, same(Shadows.controlPrimary));
        expect(sheen.hovered, isFalse);
        expect(sheen.pressed, isFalse);
        expect((sheen.border! as Border).top.color, transparent);
        expect(labelStyleOf(t).color, ThemeTokens.dark.primaryForeground);
      });

      testWidgets('hover starts the beat and changes nothing else', (
        WidgetTester t,
      ) async {
        await mount(t, ButtonVariant.primary);
        await hoverAndSettle(t);
        expect(sheenOf(t).hovered, isTrue);
        expect(
          sheenOf(t).spec,
          same(Shadows.controlPrimary),
          reason: 'hover changes no shadow on the default variant',
        );
      });

      testWidgets('active: drops to btn-down and runs one beat', (
        WidgetTester t,
      ) async {
        await mount(t, ButtonVariant.primary);
        final TestGesture g = await holdDown(t);
        expect(sheenOf(t).spec, same(Shadows.controlPressed));
        expect(sheenOf(t).pressed, isTrue);

        await g.up();
        await t.pump(MotionDurations.normal);
        expect(sheenOf(t).spec, same(Shadows.controlPrimary));
      });

      testWidgets('focus-visible: --ring border plus a 3px ring in front', (
        WidgetTester t,
      ) async {
        final FocusNode node = FocusNode();
        addTearDown(node.dispose);
        await mount(t, ButtonVariant.primary, focusNode: node);
        await focusAndSettle(t, node);

        final ActionFeedback sheen = sheenOf(t);
        expect((sheen.border! as Border).top.color, ThemeTokens.dark.ring);
        // `focus-visible:ring-3 focus-visible:ring-ring/50`, prepended so it
        // composites IN FRONT of --tw-shadow (Tailwind v4's slot order).
        final ShadowLayer ring = sheen.spec.layers.first;
        expect(ring.inset, isFalse);
        expect(
          <double>[ring.dx, ring.dy, ring.blur, ring.spread],
          <double>[0, 0, 0, 3],
        );
        expect(
          ring.color(ThemeTokens.dark),
          ThemeTokens.dark.ring.withValues(alpha: 0.50),
        );
        expect(
          sheen.spec.layers.length,
          Shadows.controlPrimary.layers.length + 1,
        );
      });
    });

    group('premium — premium-surface shadow-btn-value', () {
      testWidgets('rest: btn-value under a foil, semibold', (
        WidgetTester t,
      ) async {
        await mount(t, ButtonVariant.premium);
        expect(foilOf(t).spec, same(Shadows.controlPremium));
        expect(foilOf(t).hovered, isFalse);
        expect(
          labelStyleOf(t).fontWeight,
          FontWeight.w600,
          reason: 'font-semibold beats the base font-medium',
        );
      });

      testWidgets('the value foreground does not flip with the theme', (
        WidgetTester t,
      ) async {
        for (final ColorMode mode in <ColorMode>[
          ColorMode.dark,
          ColorMode.light,
        ]) {
          await mount(t, ButtonVariant.premium, mode: mode);
          expect(
            labelStyleOf(t).color,
            Palette.valueForeground,
            reason: '--color-value-foreground is fixed at #121216 ($mode)',
          );
        }
      });

      testWidgets('hover: shadow-glow-value replaces the token wholesale', (
        WidgetTester t,
      ) async {
        await mount(t, ButtonVariant.premium);
        await hoverAndSettle(t);
        expect(foilOf(t).spec, same(Shadows.glowValue));
        expect(foilOf(t).hovered, isTrue);
        // The inset rim and the inner shade DISAPPEAR — the glow is not added
        // to the machine surface, it replaces it.
        expect(Shadows.glowValue.hasInset, isFalse);
      });

      testWidgets('active outranks hover: btn-down wins over the glow', (
        WidgetTester t,
      ) async {
        await mount(t, ButtonVariant.premium);
        await hoverAndSettle(t);
        expect(foilOf(t).spec, same(Shadows.glowValue));

        await holdDown(t);
        expect(foilOf(t).spec, same(Shadows.controlPressed));
        expect(foilOf(t).hovered, isTrue, reason: 'still hovered underneath');
      });
    });

    group('secondary — bg-secondary, no shadow at all', () {
      testWidgets('rest and hover', (WidgetTester t) async {
        await mount(t, ButtonVariant.secondary);
        expect(surfaceOf(t).fill, ThemeTokens.dark.secondary);
        expect(
          surfaceOf(t).spec.layers,
          isEmpty,
          reason: 'drift 1: the shadows page copy claims shadow-btn here',
        );
        expect(labelStyleOf(t).color, ThemeTokens.dark.secondaryForeground);

        await hoverAndSettle(t);
        expect(surfaceOf(t).fill, ThemeTokens.dark.accent);
      });

      testWidgets('active changes nothing but the scale', (
        WidgetTester t,
      ) async {
        await mount(t, ButtonVariant.secondary);
        await hoverAndSettle(t);
        await holdDown(t);
        expect(surfaceOf(t).fill, ThemeTokens.dark.accent);
        expect(surfaceOf(t).spec.layers, isEmpty);
      });
    });

    group('destructive — a tint, not a fill', () {
      testWidgets('rest: 10% wash inside a 25% border, destructive ink', (
        WidgetTester t,
      ) async {
        await mount(t, ButtonVariant.destructive);
        final ThemeTokens dark = ThemeTokens.dark;
        expect(surfaceOf(t).fill, dark.destructive.withValues(alpha: 0.10));
        expect(borderOf(t), dark.destructive.withValues(alpha: 0.25));
        expect(surfaceOf(t).spec.layers, isEmpty);
        expect(labelStyleOf(t).color, dark.destructiveText);
      });

      testWidgets('hover deepens both, to 20% and 40%', (WidgetTester t) async {
        await mount(t, ButtonVariant.destructive);
        await hoverAndSettle(t);
        final ThemeTokens dark = ThemeTokens.dark;
        expect(surfaceOf(t).fill, dark.destructive.withValues(alpha: 0.20));
        expect(borderOf(t), dark.destructive.withValues(alpha: 0.40));
      });

      testWidgets('focus overrides both halves of the base ring', (
        WidgetTester t,
      ) async {
        final FocusNode node = FocusNode();
        addTearDown(node.dispose);
        await mount(t, ButtonVariant.destructive, focusNode: node);
        await focusAndSettle(t, node);

        final ThemeTokens dark = ThemeTokens.dark;
        expect(borderOf(t), dark.destructive.withValues(alpha: 0.50));
        expect(
          surfaceOf(t).spec.layers.first.color(dark),
          dark.destructive.withValues(alpha: 0.25),
          reason: 'focus-visible:ring-destructive/25, not ring-ring/50',
        );
      });
    });

    group('link — text only', () {
      testWidgets('rest: action ink on nothing', (WidgetTester t) async {
        await mount(t, ButtonVariant.link);
        expect(surfaceOf(t).fill, transparent);
        expect(borderOf(t), transparent);
        expect(surfaceOf(t).spec.layers, isEmpty);
        expect(labelStyleOf(t).color, ThemeTokens.dark.actionText);
        expect(labelStyleOf(t).decoration, isNot(TextDecoration.underline));
      });

      testWidgets('hover:underline', (WidgetTester t) async {
        await mount(t, ButtonVariant.link);
        await hoverAndSettle(t);
        expect(labelStyleOf(t).decoration, TextDecoration.underline);
      });
    });

    group('ButtonStyleRecipe — the class-list override', () {
      /// `variant="outline"` under a class list appended to it, which is how
      /// the reference restyles a `Button` and what this class is a parameter
      /// for.
      Future<void> mountSurface(WidgetTester t, ButtonStyleRecipe surface) =>
          t.pumpWidget(
            host(
              Button(
                variant: ButtonVariant.outline,
                surface: surface,
                onPressed: () {},
                child: const Icon(IconGlyph.check),
              ),
            ),
          );

      /// `--agent/50` — the colour both call sites of the fifth override name.
      final Color agentRim = ThemeTokens.dark.agentAccent.withValues(
        alpha: AgentLauncher.hoverRimAlpha,
      );

      testWidgets('hoverBorder moves the rim on hover, and only on hover', (
        WidgetTester t,
      ) async {
        // The assertion has teeth only if the two colours differ — a rim that
        // happened to equal the outline variant's own would pass this test
        // with the field deleted.
        expect(agentRim, isNot(ThemeTokens.dark.input));

        await mountSurface(t, ButtonStyleRecipe(hoverBorder: agentRim));
        expect(
          borderOf(t),
          ThemeTokens.dark.input,
          reason:
              '`hover:border-*` is a hover utility: at rest the '
              "variant's own hairline is untouched",
        );

        final TestGesture mouse = await hoverAndSettle(t);
        expect(borderOf(t), agentRim);

        // …and back off it, on the same 250ms `btn-spring` clock the fill and
        // the ink ride. Nothing about the animation was taught this value —
        // the border colour was already spring-carried and only the *value*
        // was missing, which is why the KNOWN GAP closed as one field.
        await mouse.moveTo(Offset.zero);
        await t.pump();
        await t.pump(MotionDurations.normal);
        await t.pump(MotionDurations.normal);
        expect(borderOf(t), ThemeTokens.dark.input);
      });

      testWidgets('an absent hoverBorder leaves the resting override standing', (
        WidgetTester t,
      ) async {
        // CSS's own fallback, and [hoverFill]'s: a class list that names no
        // `hover:border-*` keeps the border it does name. Every override in
        // the corpus before this one was of exactly that shape, so this is the
        // case that must not have regressed.
        await mountSurface(t, ButtonStyleRecipe(border: ThemeTokens.dark.ring));
        expect(borderOf(t), ThemeTokens.dark.ring);
        await hoverAndSettle(t);
        expect(borderOf(t), ThemeTokens.dark.ring);
      });

      testWidgets('hoverBorder alone does not disturb the other four slots', (
        WidgetTester t,
      ) async {
        await mountSurface(t, ButtonStyleRecipe(hoverBorder: agentRim));
        await hoverAndSettle(t);
        // `outline`'s own hover fill and ink, unchanged: the fifth field is
        // additive, not a replacement for the surface it lands on.
        expect(surfaceOf(t).fill, ThemeTokens.dark.muted);
        expect(labelStyleOf(t).color, ThemeTokens.dark.foreground);
      });
    });

    testWidgets('outline and ghost still take the base focus ring', (
      WidgetTester t,
    ) async {
      for (final ButtonVariant variant in <ButtonVariant>[
        ButtonVariant.outline,
        ButtonVariant.ghost,
      ]) {
        final FocusNode node = FocusNode();
        addTearDown(node.dispose);
        await mount(t, variant, focusNode: node);
        await focusAndSettle(t, node);

        expect(
          borderOf(t),
          ThemeTokens.dark.ring,
          reason: 'focus-visible:border-ring on $variant',
        );
        expect(
          surfaceOf(t).spec.layers.first.spread,
          3,
          reason: 'focus-visible:ring-3 on $variant',
        );
      }
    });

    testWidgets('the focus ring composites in front of the surface shadow', (
      WidgetTester t,
    ) async {
      // CSS paints the FIRST-listed box-shadow on top, and
      // `ShadowStyle.outerShadows` reverses the list to reproduce that — so a
      // prepended ring must come out LAST, i.e. painted last, i.e. on top.
      final ShadowStyle ringed = Button.withFocusRing(
        Shadows.control,
        Palette.action,
      );
      expect(ringed.layers.first.spread, 3);
      final List<BoxShadow> painted = ringed.outerShadows(ThemeTokens.dark);
      expect(painted.last.spreadRadius, 3);
      expect(painted.last.color, Palette.action);
      // The inset half is untouched — the ring is not inset.
      expect(ringed.insetLayers, Shadows.control.insetLayers);
    });

    testWidgets('every variant paints in both themes', (WidgetTester t) async {
      for (final ColorMode mode in <ColorMode>[
        ColorMode.dark,
        ColorMode.light,
      ]) {
        for (final ButtonVariant variant in ButtonVariant.values) {
          await mount(t, variant, mode: mode);
          await t.pump(MotionDurations.normal);
          expect(t.takeException(), isNull, reason: '$variant in $mode');
        }
      }
    });

    testWidgets('Enter and Space activate a focused button', (
      WidgetTester t,
    ) async {
      int presses = 0;
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(
        host(
          Button(
            variant: ButtonVariant.outline,
            focusNode: node,
            onPressed: () => presses++,
            child: const Icon(IconGlyph.check),
          ),
        ),
      );

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

  group('Input', () {
    Surface surfaceOf(WidgetTester t) =>
        t.widget<Surface>(find.byType(Surface));

    Color borderOf(WidgetTester t) =>
        (surfaceOf(t).border! as Border).top.color;

    Widget field({
      TextEditingController? controller,
      FocusNode? focusNode,
      ColorMode mode = ColorMode.dark,
    }) => host(
      SizedBox(
        // `max-w-sm` = 24rem = 384px, the cap the shadows page applies.
        width: 384,
        child: Input(
          controller: controller,
          focusNode: focusNode,
          placeholder: 'Search packs, cards and sets',
        ),
      ),
      mode: mode,
    );

    testWidgets('is a 40px pill sitting in a permanent socket', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(field());

      expect(t.getSize(find.byType(Input)).height, space(10));
      expect(t.getSize(find.byType(Input)).width, 384);
      expect(surfaceOf(t).radius, BorderRadius.circular(Radii.full));
      expect(surfaceOf(t).fill, ThemeTokens.dark.card);
      expect(borderOf(t), ThemeTokens.dark.input);
      expect(surfaceOf(t).spec, same(Shadows.inset));
      expect(Input.height, space(10));
    });

    testWidgets('shows the placeholder at muted until something is typed', (
      WidgetTester t,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);
      await t.pumpWidget(field(controller: controller));

      expect(find.text('Search packs, cards and sets'), findsOneWidget);
      expect(
        t.widget<StyledText>(find.byType(StyledText).first).color,
        ThemeTokens.dark.mutedForeground,
      );

      await t.enterText(find.byType(EditableText), 'charizard');
      await t.pump();
      expect(find.text('Search packs, cards and sets'), findsNothing);
      expect(controller.text, 'charizard');
    });

    testWidgets('is genuinely editable — a real caret and a real value', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(field());
      expect(find.byType(EditableText), findsOneWidget);

      await t.enterText(find.byType(EditableText), 'base set');
      await t.pump();
      final EditableText editable = t.widget<EditableText>(
        find.byType(EditableText),
      );
      expect(editable.controller.text, 'base set');
      expect(editable.focusNode.hasFocus, isTrue);
      expect(editable.cursorColor, ThemeTokens.dark.foreground);
      expect(editable.readOnly, isFalse);
    });

    testWidgets('focus tints the border and ADDS a ring — the socket stays', (
      WidgetTester t,
    ) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(field(focusNode: node));

      node.requestFocus();
      await t.pump();
      await t.pump(MotionDurations.normal);
      await t.pump(MotionDurations.normal);

      final ThemeTokens dark = ThemeTokens.dark;
      expect(
        borderOf(t),
        dark.primary.withValues(alpha: 0.50),
        reason: 'focus-visible:border-primary/50 — --primary, not --ring',
      );

      final ShadowStyle spec = surfaceOf(t).spec;
      final ShadowLayer ring = spec.layers.first;
      expect(
        <double>[ring.dx, ring.dy, ring.blur, ring.spread],
        <double>[0, 0, 0, 3],
      );
      expect(ring.color(dark).r, closeTo(dark.ring.r, 1e-9));
      expect(
        ring.color(dark).a,
        closeTo(0.35, 1e-6),
        reason: 'focus-visible:ring-ring/35',
      );
      // The socket is still every one of its own layers, untouched.
      expect(spec.insetLayers, Shadows.inset.insetLayers);
      expect(spec.layers.length, Shadows.inset.layers.length + 1);
    });

    testWidgets('has no hover state at all', (WidgetTester t) async {
      await t.pumpWidget(field());
      final Color restBorder = borderOf(t);

      await hoverOver(t, find.byType(Input));
      await t.pump(MotionDurations.normal);
      await t.pump(MotionDurations.normal);

      expect(borderOf(t), restBorder);
      expect(
        surfaceOf(t).spec,
        same(Shadows.inset),
        reason: 'the field is already sunken and only its ring changes',
      );
    });

    testWidgets('renders in both themes', (WidgetTester t) async {
      for (final ColorMode mode in <ColorMode>[
        ColorMode.dark,
        ColorMode.light,
      ]) {
        await t.pumpWidget(field(mode: mode));
        await t.pump(MotionDurations.normal);
        expect(t.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
