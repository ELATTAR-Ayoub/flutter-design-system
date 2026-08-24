import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The component layer: the three primitives the docs shell is assembled from.

Widget host(Widget child, {ElThemeMode mode = ElThemeMode.dark}) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(1440, 900)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ElTheme(
        controller: ElThemeController(mode: mode),
        child: Center(child: child),
      ),
    ),
  );
}

/// A navigable host, for the one component that pushes a route.
///
/// `ElTheme` sits **above** the app, matching what the example app does: the
/// Navigator's overlay has to be inside the theme scope, or a pushed route
/// cannot resolve a token.
Widget navHost(Widget child, {ElThemeMode mode = ElThemeMode.dark}) {
  return ElTheme(
    controller: ElThemeController(mode: mode),
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
  group('ElIcon', () {
    testWidgets('the size ladder is 12/14/16/20/24/32/40', (
      WidgetTester t,
    ) async {
      const Map<ElIconSize, double> ladder = <ElIconSize, double>{
        ElIconSize.xs: 12,
        ElIconSize.sm: 14,
        ElIconSize.md: 16,
        ElIconSize.lg: 20,
        ElIconSize.xl: 24,
        ElIconSize.xl2: 32,
        ElIconSize.xl3: 40,
      };
      for (final MapEntry<ElIconSize, double> step in ladder.entries) {
        expect(ElIcon.pxFor(step.key), step.value);
      }
      expect(ladder.length, ElIconSize.values.length);
    });

    testWidgets('md renders 16×16', (WidgetTester t) async {
      await t.pumpWidget(host(const ElIcon(ElIconGlyph.menu)));
      expect(t.getSize(find.byType(ElIcon)), const Size(16, 16));
    });

    test('stroke follows the reference ternary, not a clamp', () {
      // components/ui/icon.tsx:
      //   strokeWidth={(2 * 24) / px > 2.6 ? 2.4 : (2 * 24) / px < 1.5 ? 1.6 : 2}
      // The middle branch is a literal 2 — it is NOT the raw 48/px. That makes
      // lg, xl and 2xl all stroke 2.0, where a clamp reading would give
      // 2.4 / 2.0 / 1.5.
      expect(ElIcon.strokeFor(12), 2.4); // 4.00 > 2.6
      expect(ElIcon.strokeFor(14), 2.4); // 3.43 > 2.6
      expect(ElIcon.strokeFor(16), 2.4); // 3.00 > 2.6
      expect(ElIcon.strokeFor(20), 2.0); // 2.40 — middle branch
      expect(ElIcon.strokeFor(24), 2.0); // 2.00 — middle branch
      expect(ElIcon.strokeFor(32), 2.0); // 1.50 is NOT < 1.5 — middle branch
      expect(ElIcon.strokeFor(40), 1.6); // 1.20 < 1.5
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

      final ElThemeData dark = ElThemeData.dark;
      expect(ElIcon.colorFor(context, ElIconTone.normal), dark.foreground);
      expect(ElIcon.colorFor(context, ElIconTone.muted), dark.mutedForeground);
      expect(ElIcon.colorFor(context, ElIconTone.subtle), dark.mutedForeground);
      expect(ElIcon.colorFor(context, ElIconTone.action), dark.actionInk);
      expect(ElIcon.colorFor(context, ElIconTone.value), dark.valueInk);
      expect(ElIcon.colorFor(context, ElIconTone.success), dark.successInk);
      expect(ElIcon.colorFor(context, ElIconTone.warning), dark.warningInk);
      expect(ElIcon.colorFor(context, ElIconTone.info), dark.infoInk);
      expect(ElIcon.colorFor(context, ElIconTone.error), dark.destructiveInk);
    });

    testWidgets('inherit takes the surrounding text colour', (
      WidgetTester t,
    ) async {
      late BuildContext inside;
      await t.pumpWidget(
        host(
          DefaultTextStyle(
            style: TextStyle(color: ElThemeData.dark.valueInk),
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
        ElIcon.colorFor(inside, ElIconTone.inherit),
        ElThemeData.dark.valueInk,
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
        ElIcon.colorFor(bare, ElIconTone.inherit),
        ElThemeData.dark.foreground,
      );
    });

    testWidgets('every glyph paints in both themes', (WidgetTester t) async {
      for (final ElThemeMode mode in <ElThemeMode>[
        ElThemeMode.dark,
        ElThemeMode.light,
      ]) {
        for (final ElIconGlyph glyph in ElIconGlyph.values) {
          await t.pumpWidget(
            host(ElIcon(glyph, size: ElIconSize.xl), mode: mode),
          );
          expect(t.takeException(), isNull, reason: '$glyph in $mode');
        }
      }
    });

    testWidgets('sizePx and strokeOverride win', (WidgetTester t) async {
      await t.pumpWidget(
        host(const ElIcon(ElIconGlyph.check, sizePx: 18, strokeOverride: 3)),
      );
      expect(t.getSize(find.byType(ElIcon)), const Size(18, 18));
      expect(t.takeException(), isNull);
    });
  });

  group('ElButton', () {
    ElMachineSurface surfaceOf(WidgetTester t) =>
        t.widget<ElMachineSurface>(find.byType(ElMachineSurface));

    testWidgets('all nine rungs render at their cva height', (
      WidgetTester t,
    ) async {
      Future<Size> sizeOf(ElButtonSize size) async {
        await t.pumpWidget(
          host(
            ElButton(
              variant: ElButtonVariant.outline,
              size: size,
              onPressed: () {},
              child: const ElIcon(ElIconGlyph.menu),
            ),
          ),
        );
        return t.getSize(find.byType(ElButton));
      }

      // The five text rungs — 24 / 32 / 40 / 48 / 56.
      expect((await sizeOf(ElButtonSize.xs)).height, el(6));
      expect((await sizeOf(ElButtonSize.sm)).height, el(8));
      expect((await sizeOf(ElButtonSize.md)).height, el(10));
      expect((await sizeOf(ElButtonSize.lg)).height, el(12));
      expect((await sizeOf(ElButtonSize.xl)).height, el(14));
      // The four squares, which are square.
      expect(await sizeOf(ElButtonSize.iconXs), Size(el(6), el(6)));
      expect(await sizeOf(ElButtonSize.iconSm), Size(el(8), el(8)));
      expect(await sizeOf(ElButtonSize.icon), Size(el(10), el(10)));
      expect(await sizeOf(ElButtonSize.iconLg), Size(el(12), el(12)));
    });

    testWidgets('outline is card on input with --shadow-btn', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          ElButton(
            variant: ElButtonVariant.outline,
            onPressed: () {},
            child: const ElIcon(ElIconGlyph.menu),
          ),
        ),
      );

      final ElMachineSurface surface = surfaceOf(t);
      expect(surface.fill, ElThemeData.dark.card);
      expect((surface.border! as Border).top.color, ElThemeData.dark.input);
      expect(surface.spec, same(ElShadows.btn));
      expect(surface.radius, BorderRadius.circular(ElRadii.pill));
    });

    testWidgets('outline fills with --muted on hover', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          ElButton(
            variant: ElButtonVariant.outline,
            onPressed: () {},
            child: const ElIcon(ElIconGlyph.menu),
          ),
        ),
      );

      await hoverOver(t, find.byType(ElButton));
      await t.pumpAndSettle();
      expect(surfaceOf(t).fill, ElThemeData.dark.muted);
    });

    testWidgets('outline drops into --shadow-btn-down while held', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          ElButton(
            variant: ElButtonVariant.outline,
            onPressed: () {},
            child: const ElIcon(ElIconGlyph.menu),
          ),
        ),
      );

      final TestGesture gesture = await t.startGesture(
        t.getCenter(find.byType(ElButton)),
      );
      await t.pump();
      expect(surfaceOf(t).spec, same(ElShadows.btnDown));

      await gesture.up();
      await t.pump(ElDurations.base);
      expect(surfaceOf(t).spec, same(ElShadows.btn));
    });

    testWidgets('ghost is bare, muted, and shadowless', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          ElButton(
            variant: ElButtonVariant.ghost,
            onPressed: () {},
            child: const ElIcon(ElIconGlyph.x),
          ),
        ),
      );

      final ElMachineSurface surface = surfaceOf(t);
      expect(surface.fill, elTransparent);
      // The base class list is `border border-transparent` for every variant:
      // a real 1px border, invisible but paid for in inner width.
      expect((surface.border! as Border).top.color, elTransparent);
      expect((surface.border! as Border).top.width, ElWidths.hairline);
      expect(surface.spec.layers, isEmpty);
      expect(
        t
            .widget<DefaultTextStyle>(
              find
                  .descendant(
                    of: find.byType(ElButton),
                    matching: find.byType(DefaultTextStyle),
                  )
                  .first,
            )
            .style
            .color,
        ElThemeData.dark.mutedForeground,
      );
    });

    testWidgets('ghost takes --secondary and --foreground on hover', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          ElButton(
            variant: ElButtonVariant.ghost,
            onPressed: () {},
            child: const ElIcon(ElIconGlyph.x),
          ),
        ),
      );

      await hoverOver(t, find.byType(ElButton));
      await t.pumpAndSettle();
      expect(surfaceOf(t).fill, ElThemeData.dark.secondary);
    });

    /// The scale the button is currently drawn at — the first [Transform] under
    /// it, which is the one `scale-95` maps to.
    double scaleOf(WidgetTester t) => t
        .widget<Transform>(
          find
              .descendant(
                of: find.byType(ElButton),
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
          ElButton(
            variant: ElButtonVariant.outline,
            onPressed: () {},
            child: const ElIcon(ElIconGlyph.menu),
          ),
        ),
      );

      expect(scaleOf(t), 1.0);

      await t.startGesture(t.getCenter(find.byType(ElButton)));
      // RETUNED (behaviour-audit B1). This used to pump `--duration-tick`
      // before asserting, on the theory that `btn-spring`'s `:active`
      // duration eased the squish over 80ms. It does not: Tailwind v4 compiles
      // `scale-95` to the standalone `scale` property, which is **not** in
      // `btn-spring`'s transition-property list. One frame is all it takes on
      // the reference, so one frame is all this pumps — stricter, and true.
      await t.pump();
      expect(scaleOf(t), ElTransforms.buttonScale);
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
          ElButton(
            variant: ElButtonVariant.outline,
            onPressed: () {},
            child: const ElIcon(ElIconGlyph.menu),
          ),
        ),
      );
      expect(scaleOf(t), 1.0, reason: 'at rest');

      final List<double> frames = <double>[];
      final TestGesture press = await t.startGesture(
        t.getCenter(find.byType(ElButton)),
      );

      // Measured: 9.5ms after `pointerdown` — the very next frame — the button
      // is already fully at 0.95, with no intermediate value sampled.
      await t.pump();
      expect(scaleOf(t), ElTransforms.buttonScale);
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
      // overshoot the port used to carry through `ElPress`.
      expect(frames.toSet(), <double>{ElTransforms.buttonScale, 1.0});
    });

    testWidgets('B6 — a 10, 20 or 30ms tap still shows the full 0.95', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          ElButton(
            variant: ElButtonVariant.outline,
            onPressed: () {},
            child: const ElIcon(ElIconGlyph.menu),
          ),
        ),
      );

      // The port used to reach 0.9756 / 0.9592 / 0.9497 for these three holds,
      // then play a shortened spring backwards. Instant means depth cannot
      // depend on hold length.
      for (final int ms in <int>[10, 20, 30]) {
        final TestGesture tap = await t.startGesture(
          t.getCenter(find.byType(ElButton)),
        );
        await t.pump();
        expect(scaleOf(t), ElTransforms.buttonScale, reason: '${ms}ms hold');
        await t.pump(Duration(milliseconds: ms));
        expect(scaleOf(t), ElTransforms.buttonScale, reason: '${ms}ms hold');

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
            ElButton(
              variant: ElButtonVariant.outline,
              suppressPressScale: true,
              onPressed: () {},
              child: const ElIcon(ElIconGlyph.menu),
            ),
          ),
        );

        final List<double> frames = <double>[scaleOf(t)];
        final TestGesture press = await t.startGesture(
          t.getCenter(find.byType(ElButton)),
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
          ElButton(
            variant: ElButtonVariant.outline,
            suppressPressScale: true,
            onPressed: () {},
            child: const ElIcon(ElIconGlyph.menu),
          ),
        ),
      );

      final TestGesture press = await t.startGesture(
        t.getCenter(find.byType(ElButton)),
      );
      await t.pump();
      // `active:shadow-btn-down` carries no `not-` guard, so a trigger sinks
      // into its socket exactly like every other button.
      expect(surfaceOf(t).spec, same(ElShadows.btnDown));
      expect(scaleOf(t), 1.0);

      await press.up();
      await t.pump(ElDurations.base);
      expect(surfaceOf(t).spec, same(ElShadows.btn));
    });

    testWidgets('B2 — the pressed shadow hard-cuts: the token pair cannot '
        'interpolate', (WidgetTester t) async {
      await t.pumpWidget(
        host(ElButton(onPressed: () {}, child: const ElIcon(ElIconGlyph.menu))),
      );
      ElShadowSpec spec() =>
          t.widget<ElSheenAction>(find.byType(ElSheenAction)).spec;

      // `--shadow-btn-primary` is 4 layers (2 inset, 2 not) against
      // `--shadow-btn-down`'s 2 (1 inset, 1 not). Mismatched layer counts AND
      // mismatched `inset` flags: CSS refuses to interpolate, and the browser
      // was measured swapping the value inside a single frame. A later
      // well-meaning tween here would be motion the reference never shows.
      final List<ElShadowSpec> seen = <ElShadowSpec>[spec()];
      final TestGesture press = await t.startGesture(
        t.getCenter(find.byType(ElButton)),
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

      expect(seen.first, same(ElShadows.btnPrimary));
      expect(seen[1], same(ElShadows.btnDown), reason: 'the very next frame');
      expect(seen.last, same(ElShadows.btnPrimary));
      for (final ElShadowSpec s in seen) {
        expect(
          identical(s, ElShadows.btnPrimary) || identical(s, ElShadows.btnDown),
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
          ElButton(
            variant: ElButtonVariant.premium,
            onPressed: () {},
            child: const ElIcon(ElIconGlyph.menu),
          ),
        ),
      );
      ElShadowSpec spec() =>
          t.widget<ElFoilValue>(find.byType(ElFoilValue)).spec;

      expect(spec(), same(ElShadows.btnValue));
      // Measured at **1.2ms** after `pointerover`: `--shadow-btn-value` (8
      // computed layers, insets) → `--shadow-glow-value` (6, none). Snap.
      await hoverOver(t, find.byType(ElButton));
      expect(spec(), same(ElShadows.glowValue));
    });

    testWidgets('B12 — the focus ring springs its spread 0 → 3.29 → 3', (
      WidgetTester t,
    ) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(
        host(
          ElButton(
            variant: ElButtonVariant.outline,
            focusNode: node,
            onPressed: () {},
            child: const ElIcon(ElIconGlyph.menu),
          ),
        ),
      );

      // The ring lands in one of the token's leading transparent placeholder
      // slots, so the layer count and the per-layer `inset` flags never change
      // and `box-shadow` interpolates normally — the opposite case to B2/B3.
      expect(surfaceOf(t).spec, same(ElShadows.btn), reason: 'no ring at rest');

      node.requestFocus();
      await t.pump();
      double spread() => surfaceOf(t).spec.layers.first.spread;
      double alpha() =>
          surfaceOf(t).spec.layers.first.color(ElThemeData.dark).a;

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
        ElButton(
          variant: ElButtonVariant.outline,
          onPressed: enabled ? () {} : null,
          child: const ElIcon(ElIconGlyph.menu),
        ),
      );
      double opacity() => t
          .widget<Opacity>(
            find
                .descendant(
                  of: find.byType(ElButton),
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
      // colours: measured 1 → 0.3969 at Δ~180 → 0.45 at Δ~280, an undershoot of
      // (0.45 − 0.3969) / (1 − 0.45) = +9.65%.
      expect(lowest, closeTo(0.3969, 0.005));
      await t.pump(const Duration(milliseconds: 250));
      expect(opacity(), closeTo(0.45, 1e-9));
    });

    testWidgets('fires onPressed', (WidgetTester t) async {
      int presses = 0;
      await t.pumpWidget(
        host(
          ElButton(
            variant: ElButtonVariant.outline,
            onPressed: () => presses++,
            child: const ElIcon(ElIconGlyph.menu),
          ),
        ),
      );

      await t.tap(find.byType(ElButton));
      await t.pump(ElDurations.base);
      expect(presses, 1);
    });

    testWidgets('a null onPressed disables it', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          const ElButton(
            variant: ElButtonVariant.outline,
            child: ElIcon(ElIconGlyph.menu),
          ),
        ),
      );

      await t.tap(find.byType(ElButton), warnIfMissed: false);
      await t.pump(ElDurations.base);
      expect(t.takeException(), isNull);

      final Opacity opacity = t.widget<Opacity>(
        find
            .descendant(
              of: find.byType(ElButton),
              matching: find.byType(Opacity),
            )
            .first,
      );
      expect(opacity.opacity, lessThan(1));
    });

    testWidgets('shows the click cursor only while enabled', (
      WidgetTester t,
    ) async {
      Widget button({required bool enabled}) => host(
        ElButton(
          variant: ElButtonVariant.outline,
          onPressed: enabled ? () {} : null,
          child: const ElIcon(ElIconGlyph.menu),
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
      expect(ElButtonSize.values, <ElButtonSize>[
        ElButtonSize.xs,
        ElButtonSize.sm,
        ElButtonSize.md,
        ElButtonSize.lg,
        ElButtonSize.xl,
        ElButtonSize.iconXs,
        ElButtonSize.iconSm,
        ElButtonSize.icon,
        ElButtonSize.iconLg,
      ]);
    });

    test('height — 24 / 32 / 40 / 48 / 56, squares included', () {
      expect(ElButton.heightFor(ElButtonSize.xs), 24);
      expect(ElButton.heightFor(ElButtonSize.sm), 32);
      expect(ElButton.heightFor(ElButtonSize.md), 40);
      expect(ElButton.heightFor(ElButtonSize.lg), 48);
      expect(ElButton.heightFor(ElButtonSize.xl), 56);
      expect(ElButton.heightFor(ElButtonSize.iconXs), 24);
      expect(ElButton.heightFor(ElButtonSize.iconSm), 32);
      expect(ElButton.heightFor(ElButtonSize.icon), 40);
      expect(ElButton.heightFor(ElButtonSize.iconLg), 48);
    });

    test('gap — 4 / 6 / 8 / 10 / 10, and none on any square', () {
      expect(ElButton.gapFor(ElButtonSize.xs), 4);
      expect(ElButton.gapFor(ElButtonSize.sm), 6);
      expect(ElButton.gapFor(ElButtonSize.md), 8);
      // `lg` and `xl` share `gap-2.5`; the ladder does not step here.
      expect(ElButton.gapFor(ElButtonSize.lg), 10);
      expect(ElButton.gapFor(ElButtonSize.xl), 10);
      for (final ElButtonSize square in ElButtonSize.values.where(
        ElButton.isSquare,
      )) {
        expect(
          ElButton.gapFor(square),
          0,
          reason: '${square.name} declares no gap',
        );
      }
    });

    test('padding-x — 10 / 14 / 16 / 24 / 32, and none on any square', () {
      expect(ElButton.paddingXFor(ElButtonSize.xs), 10);
      expect(ElButton.paddingXFor(ElButtonSize.sm), 14);
      expect(ElButton.paddingXFor(ElButtonSize.md), 16);
      expect(ElButton.paddingXFor(ElButtonSize.lg), 24);
      expect(ElButton.paddingXFor(ElButtonSize.xl), 32);
      for (final ElButtonSize square in ElButtonSize.values.where(
        ElButton.isSquare,
      )) {
        expect(ElButton.paddingXFor(square), 0);
      }
    });

    test('exactly four rungs are squares', () {
      expect(ElButtonSize.values.where(ElButton.isSquare), <ElButtonSize>[
        ElButtonSize.iconXs,
        ElButtonSize.iconSm,
        ElButtonSize.icon,
        ElButtonSize.iconLg,
      ]);
    });

    test('the svg override — 12 / 14 / 16 / 16 / 20 across the pairs', () {
      // `[&_svg:not([class*='size-'])]:size-*`. `md` and `lg` are the two text
      // rungs that never override the base `size-4`, which is why a 48px `lg`
      // button and a 40px `md` button hold the same 16px glyph.
      expect(ElButton.iconPxFor(ElButtonSize.xs), 12);
      expect(ElButton.iconPxFor(ElButtonSize.sm), 14);
      expect(ElButton.iconPxFor(ElButtonSize.md), 16);
      expect(ElButton.iconPxFor(ElButtonSize.lg), 16);
      expect(ElButton.iconPxFor(ElButtonSize.xl), 20);
      expect(ElButton.iconPxFor(ElButtonSize.iconXs), 12);
      expect(ElButton.iconPxFor(ElButtonSize.iconSm), 14);
      expect(ElButton.iconPxFor(ElButtonSize.icon), 16);
      expect(ElButton.iconPxFor(ElButtonSize.iconLg), 20);
    });

    test('five rungs, three type sizes, three leadings — drift 15', () {
      ElTypeSpec spec(ElButtonSize size) =>
          ElButton.typeFor(size, ElButtonEmphasis.none)!;

      // Three sizes across five rungs: only `xs` is unique.
      expect(spec(ElButtonSize.xs).size, 12);
      expect(spec(ElButtonSize.sm).size, 13);
      expect(spec(ElButtonSize.md).size, 13);
      expect(spec(ElButtonSize.lg).size, 15);
      expect(spec(ElButtonSize.xl).size, 15);

      // And the leadings do not agree with the sizes. `text-xs`, `text-sm` and
      // `text-base` are Tailwind steps repointed at this scale, so their stock
      // `--text-*--line-height` companions survive and apply to the new size;
      // `text-small` and `text-body` are bespoke and have no companion, so
      // their leading is **inherited** — from Preflight's `html { line-height:
      // 1.5 }`, which nothing between `html` and a button overrides.
      //
      // CORRECTED (the sidebar family): those two shipped as `null`, which
      // Flutter reads as "the face's own leading" rather than as "inherit". It
      // was invisible for as long as every button had a fixed height and
      // centred its label; `SidebarMenuButton` is the corpus's first `h-auto`
      // button and it measures the difference — a default row is 37.5 tall on
      // the reference and came out 34.
      expect(spec(ElButtonSize.xs).height, closeTo(1 / 0.75, 1e-12));
      expect(spec(ElButtonSize.sm).height, 1.5);
      expect(spec(ElButtonSize.md).height, closeTo(1.25 / 0.875, 1e-12));
      expect(spec(ElButtonSize.lg).height, 1.5);
      expect(spec(ElButtonSize.xl).height, closeTo(1.5 / 1, 1e-12));

      // Computed line boxes: 16.0 / 19.5 / 18.571 / 22.5 / 22.5.
      expect(spec(ElButtonSize.xs).height! * 12, closeTo(16.0, 1e-9));
      expect(spec(ElButtonSize.sm).height! * 13, closeTo(19.5, 1e-9));
      expect(spec(ElButtonSize.md).height! * 13, closeTo(18.571, 1e-3));
      expect(spec(ElButtonSize.lg).height! * 15, closeTo(22.5, 1e-9));
      expect(spec(ElButtonSize.xl).height! * 15, closeTo(22.5, 1e-9));

      // Every text rung is `font-medium`.
      for (final ElButtonSize size in <ElButtonSize>[
        ElButtonSize.xs,
        ElButtonSize.sm,
        ElButtonSize.md,
        ElButtonSize.lg,
        ElButtonSize.xl,
      ]) {
        expect(spec(size).weight, FontWeight.w500);
      }
    });

    test('the four squares declare no text class at all', () {
      for (final ElButtonSize square in ElButtonSize.values.where(
        ElButton.isSquare,
      )) {
        expect(
          ElButton.typeFor(square, ElButtonEmphasis.none),
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
            child: ElButton(
              variant: ElButtonVariant.ghost,
              size: ElButtonSize.icon,
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
                  of: find.byType(ElButton),
                  matching: find.byType(DefaultTextStyle),
                )
                .first,
          )
          .style;
      expect(resolved.fontSize, 31);
      expect(resolved.fontFamily, 'Ambient');
      expect(resolved.color, ElThemeData.dark.mutedForeground);
    });
  });

  group('ElButton emphasis: caps', () {
    TextStyle labelStyleOf(WidgetTester t) => t
        .widget<DefaultTextStyle>(
          find
              .descendant(
                of: find.byType(ElButton),
                matching: find.byType(DefaultTextStyle),
              )
              .first,
        )
        .style;

    testWidgets('is 12px / 600 / 0.09em on every rung, including default', (
      WidgetTester t,
    ) async {
      for (final ElButtonSize size in ElButtonSize.values) {
        await t.pumpWidget(
          host(
            ElButton(
              variant: ElButtonVariant.premium,
              size: size,
              emphasis: ElButtonEmphasis.caps,
              onPressed: () {},
              child: const Text('Claim Reward'),
            ),
          ),
        );

        final TextStyle style = labelStyleOf(t);
        expect(style.fontSize, 12, reason: '${size.name}: text-num-sm');
        // `--tracking-cta: 0.09em`, resolved against the 12px size.
        expect(
          style.letterSpacing,
          closeTo(0.09 * 12, 1e-9),
          reason: '${size.name}: tracking-cta',
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

    testWidgets('shrinks the default rung from 13px to 12 — drift 22', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(ElButton(onPressed: () {}, child: const Text('Open Pack'))),
      );
      expect(labelStyleOf(t).fontSize, 13);

      await t.pumpWidget(
        host(
          ElButton(
            emphasis: ElButtonEmphasis.caps,
            onPressed: () {},
            child: const Text('Claim Reward'),
          ),
        ),
      );
      expect(labelStyleOf(t).fontSize, 12);
    });

    testWidgets('uppercases the glyphs and leaves the accessible name alone', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          ElButton(
            variant: ElButtonVariant.premium,
            emphasis: ElButtonEmphasis.caps,
            onPressed: () {},
            child: const Text('Claim Reward'),
          ),
        ),
      );

      final Text rendered = t.widget<Text>(
        find.descendant(of: find.byType(ElButton), matching: find.byType(Text)),
      );
      // `text-transform` repaints the glyphs; the DOM text — and therefore the
      // accessible name — stays as authored.
      expect(rendered.data, 'CLAIM REWARD');
      expect(rendered.semanticsLabel, 'Claim Reward');
    });

    testWidgets('leaves a non-Text child alone', (WidgetTester t) async {
      await t.pumpWidget(
        host(
          ElButton(
            emphasis: ElButtonEmphasis.caps,
            onPressed: () {},
            child: const ElIcon(ElIconGlyph.menu),
          ),
        ),
      );
      expect(t.takeException(), isNull);
      expect(find.byType(ElIcon), findsOneWidget);
    });
  });

  group('ElButton.loading', () {
    testWidgets('prepends a spinner and disables the button', (
      WidgetTester t,
    ) async {
      int presses = 0;
      await t.pumpWidget(
        host(
          ElButton(
            loading: true,
            onPressed: () => presses++,
            child: const Text('Saving'),
          ),
        ),
      );

      expect(find.byType(ElSpinner), findsOneWidget);
      // The spinner leads: `<>{loading && <Spinner />}{children}</>`.
      final Offset spinner = t.getCenter(find.byType(ElSpinner));
      final Offset label = t.getCenter(find.text('Saving'));
      expect(spinner.dx, lessThan(label.dx));

      // `disabled = disabled || loading` — the callback is live and still must
      // not fire.
      await t.tap(find.byType(ElButton), warnIfMissed: false);
      await t.pump(ElDurations.base);
      expect(presses, 0);

      final Opacity opacity = t.widget<Opacity>(
        find
            .descendant(
              of: find.byType(ElButton),
              matching: find.byType(Opacity),
            )
            .first,
      );
      expect(opacity.opacity, 0.45);
    });

    testWidgets('the width DOES jump, by 24px on the default rung — drift 3', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(ElButton(onPressed: () {}, child: const Text('Saving'))),
      );
      final double resting = t.getSize(find.byType(ElButton)).width;

      await t.pumpWidget(
        host(
          ElButton(
            loading: true,
            onPressed: () {},
            child: const Text('Saving'),
          ),
        ),
      );
      final double busy = t.getSize(find.byType(ElButton)).width;

      // 16px of glyph plus the rung's own `gap-2`. Four separate sentences in
      // the reference say this does not happen.
      expect(
        busy - resting,
        closeTo(ElSpinner.px + ElButton.gapFor(ElButtonSize.md), 1e-9),
      );
    });

    testWidgets('the gap in front of the label is the rung\'s own', (
      WidgetTester t,
    ) async {
      for (final ElButtonSize size in <ElButtonSize>[
        ElButtonSize.xs,
        ElButtonSize.sm,
        ElButtonSize.md,
        ElButtonSize.lg,
        ElButtonSize.xl,
      ]) {
        await t.pumpWidget(
          host(
            ElButton(size: size, onPressed: () {}, child: const Text('Saving')),
          ),
        );
        final double resting = t.getSize(find.byType(ElButton)).width;

        await t.pumpWidget(
          host(
            ElButton(
              size: size,
              loading: true,
              onPressed: () {},
              child: const Text('Saving'),
            ),
          ),
        );
        final double busy = t.getSize(find.byType(ElButton)).width;

        expect(
          busy - resting,
          closeTo(ElSpinner.px + ElButton.gapFor(size), 1e-9),
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
          ElButton(
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
        t.getSemantics(find.byType(ElButton).first),
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

  group('ElSpinner', () {
    testWidgets('is 16px and turns once every 900ms, linearly', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const ElSpinner()));

      expect(t.getSize(find.byType(ElSpinner)), const Size(16, 16));

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
      await t.pumpWidget(host(const ElSpinner()));
      // `role="status"` and `aria-label="Loading"` are handed to `Icon` and
      // dropped by its destructure; the glyph renders `aria-hidden`.
      expect(find.byType(ExcludeSemantics), findsWidgets);
      expect(t.getSemantics(find.byType(ElSpinner)).label, isEmpty);
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
            child: ElTheme(
              controller: ElThemeController(mode: ElThemeMode.dark),
              child: const Center(child: ElSpinner()),
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
      await t.pump(ElDurations.spin);
      expect(turnsNow(), 0);
      await t.pump(ElDurations.spin);
      expect(turnsNow(), 0);
    });
  });

  group('ElToggle', () {
    ElMachineSurface surfaceOf(WidgetTester t) => t.widget<ElMachineSurface>(
      find
          .descendant(
            of: find.byType(ElToggle),
            matching: find.byType(ElMachineSurface),
          )
          .first,
    );

    Widget toggle({
      bool pressed = false,
      bool enabled = true,
      ElToggleSize size = ElToggleSize.md,
      ElToggleVariant variant = ElToggleVariant.standard,
    }) => host(
      ElToggle(
        pressed: pressed,
        size: size,
        variant: variant,
        label: 'Favourite',
        onChanged: enabled ? (bool _) {} : null,
        child: const ElIcon(ElIconGlyph.heart),
      ),
    );

    testWidgets('is 32 tall with a 32 floor and a 12px radius — not a pill', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(toggle());
      final Size box = t.getSize(find.byType(ElToggle));
      // `h-8 min-w-8 px-2.5` around a 16px glyph: 16 + 20 = 36 × 32.
      expect(box.height, el(8));
      expect(box.width, el(9));
      expect(
        surfaceOf(t).radius,
        BorderRadius.circular(ElRadii.lg),
        reason: 'rounded-lg — a Toggle is not a pill',
      );
    });

    test('the ladder: 28 / 32 / 36, and sm clamps its own radius', () {
      expect(ElToggle.heightFor(ElToggleSize.sm), 28);
      expect(ElToggle.heightFor(ElToggleSize.md), 32);
      expect(ElToggle.heightFor(ElToggleSize.lg), 36);
      expect(ElToggle.minWidthFor(ElToggleSize.sm), 28);
      expect(ElToggle.minWidthFor(ElToggleSize.md), 32);
      expect(ElToggle.minWidthFor(ElToggleSize.lg), 36);
      // `rounded-[min(var(--radius-md),12px)]` — 10px today, and it stays a
      // live clamp so a rebrand that raises --radius-md still ceilings at 12.
      expect(ElToggle.radiusFor(ElToggleSize.sm), ElRadii.md);
      expect(ElToggle.radiusFor(ElToggleSize.md), ElRadii.lg);
      expect(ElToggle.radiusFor(ElToggleSize.lg), ElRadii.lg);
      // All three rungs declare the same `px-2.5` and `gap-1`.
      expect(ElToggle.paddingX, 10);
      expect(ElToggle.gap, 4);
    });

    testWidgets('rest is bare — no fill, no border box, no shadow', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(toggle());
      final ElMachineSurface surface = surfaceOf(t);
      expect(surface.fill, elTransparent);
      // `variant="default"` is `bg-transparent` with no `border` class at all,
      // which is exactly why `focus-visible:border-ring` is inert on it.
      expect(surface.border, isNull);
      expect(surface.spec.layers.single.color(ElThemeData.dark).a, 0);
    });

    testWidgets('hover fills with --muted and moves no ink — drift 10', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(toggle());
      final Color restingInk = t
          .widget<DefaultTextStyle>(
            find
                .descendant(
                  of: find.byType(ElToggle),
                  matching: find.byType(DefaultTextStyle),
                )
                .first,
          )
          .style
          .color!;

      await hoverOver(t, find.byType(ElToggle));
      await t.pump(ElDurations.base);
      await t.pump(ElDurations.base);

      expect(surfaceOf(t).fill, ElThemeData.dark.muted);
      // `hover:text-foreground` restates the colour the element already
      // inherits: the base sets no resting ink, so the hover half is inert.
      expect(
        t
            .widget<DefaultTextStyle>(
              find
                  .descendant(
                    of: find.byType(ElToggle),
                    matching: find.byType(DefaultTextStyle),
                  )
                  .first,
            )
            .style
            .color,
        restingInk,
      );
      expect(restingInk, ElThemeData.dark.foreground);
    });

    testWidgets('the pressed fill is --muted — GREY, not blue — drift 5', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(toggle(pressed: true));
      await t.pump(ElDurations.base);
      await t.pump(ElDurations.base);
      // The panel's own caption says "the pressed state fills with the blue
      // tint — selection is always blue". `data-[state=on]:bg-muted` says
      // otherwise, and blue selection is real one panel further down.
      expect(surfaceOf(t).fill, ElThemeData.dark.muted);
      expect(surfaceOf(t).fill, isNot(ElThemeData.dark.primary));
    });

    testWidgets('disabled is 50%, not the Button\'s 45% — drift 12', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(toggle(enabled: false));
      final Opacity opacity = t.widget<Opacity>(
        find
            .descendant(
              of: find.byType(ElToggle),
              matching: find.byType(Opacity),
            )
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
      // both read `none` in every state, `:active` included. `ElButton` does
      // not reach for `ElPress` either any more (B1) — it snaps its own scale —
      // but this assertion is about the utility being absent, which is what a
      // regression here would reintroduce.
      expect(
        find.descendant(
          of: find.byType(ElToggle),
          matching: find.byType(ElPress),
        ),
        findsNothing,
      );

      final TestGesture hold = await t.startGesture(
        t.getCenter(find.byType(ElToggle)),
      );
      await t.pump(ElDurations.tick);
      final Size held = t.getSize(find.byType(ElToggle));
      expect(held.height, el(8));
      await hold.up();
      await t.pump(ElDurations.base);
    });

    testWidgets('focus draws the 3px ring at --ring @50%', (
      WidgetTester t,
    ) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(
        host(
          ElToggle(
            pressed: false,
            focusNode: node,
            label: 'Favourite',
            onChanged: (bool _) {},
            child: const ElIcon(ElIconGlyph.heart),
          ),
        ),
      );

      node.requestFocus();
      await t.pump();
      await t.pump(ElDurations.base);
      await t.pump(ElDurations.base);

      final ElShadowLayer ring = surfaceOf(t).spec.layers.single;
      expect(ring.spread, 3);
      expect(ring.blur, 0);
      expect(
        ring.color(ElThemeData.dark),
        ElThemeData.dark.ring.withValues(alpha: 0.50),
      );
    });

    testWidgets('toggles on tap and on Space', (WidgetTester t) async {
      final List<bool> changes = <bool>[];
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(
        host(
          ElToggle(
            pressed: false,
            focusNode: node,
            label: 'Favourite',
            onChanged: changes.add,
            child: const ElIcon(ElIconGlyph.heart),
          ),
        ),
      );

      await t.tap(find.byType(ElToggle));
      await t.pump();
      node.requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.space);
      await t.pump();
      // Both routes ask for the opposite of the state they were handed.
      expect(changes, <bool>[true, true]);
    });
  });

  group('ElToggleGroup', () {
    Widget group({int? selected, ValueChanged<int?>? onChanged}) => host(
      ElToggleGroup(
        selectedIndex: selected,
        onChanged: onChanged ?? (int? _) {},
        items: const <ElToggleGroupItem>[
          ElToggleGroupItem(label: 'Newest'),
          ElToggleGroupItem(label: 'Price'),
          ElToggleGroupItem(label: 'Popular'),
        ],
      ),
    );

    test('the group gap is `--gap: 2`, i.e. 8px', () {
      expect(ElToggleGroup.gap, el(2));
    });

    testWidgets('lays three items out 8px apart', (WidgetTester t) async {
      await t.pumpWidget(group(selected: 0));
      await t.pump();

      final Rect first = t.getRect(find.byType(ElToggle).at(0));
      final Rect second = t.getRect(find.byType(ElToggle).at(1));
      expect(second.left - first.right, closeTo(el(2), 1e-9));
    });

    testWidgets('the pill is a --primary stadium over a 12px item — drift 9', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(group(selected: 0));
      await t.pump();
      await t.pump();

      // The pill: `bg-primary rounded-pill shadow-chip`.
      final ElMachineSurface pill = t.widget<ElMachineSurface>(
        find
            .descendant(
              of: find.byType(ElSlidingPillGroup),
              matching: find.byType(ElMachineSurface),
            )
            .first,
      );
      expect(pill.fill, ElThemeData.dark.primary);
      expect(pill.radius, BorderRadius.circular(ElRadii.pill));
      expect(pill.spec, same(ElShadows.chip));

      // The item underneath it is still `rounded-lg`. Two shapes, one slot:
      // hover-on-unselected paints a 12px rect where selection paints a
      // 16px stadium.
      final ElMachineSurface item = t.widget<ElMachineSurface>(
        find
            .descendant(
              of: find.byType(ElToggle).at(0),
              matching: find.byType(ElMachineSurface),
            )
            .first,
      );
      expect(item.radius, BorderRadius.circular(ElRadii.lg));
    });

    testWidgets('the selected item gives up its fill and flips to white ink', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(group(selected: 1));
      await t.pump(ElDurations.base);
      await t.pump(ElDurations.base);

      ElMachineSurface itemAt(int i) => t.widget<ElMachineSurface>(
        find
            .descendant(
              of: find.byType(ElToggle).at(i),
              matching: find.byType(ElMachineSurface),
            )
            .first,
      );
      TextStyle inkAt(int i) => t
          .widget<DefaultTextStyle>(
            find
                .descendant(
                  of: find.byType(ElToggle).at(i),
                  matching: find.byType(DefaultTextStyle),
                )
                .first,
          )
          .style;

      // `data-[state=on]:bg-transparent` — declared last on purpose, because
      // the pill is the background now.
      expect(itemAt(1).fill, elTransparent);
      expect(inkAt(1).color, ElThemeData.dark.primaryForeground);
      // Its unselected neighbours are unchanged.
      expect(itemAt(0).fill, elTransparent);
      expect(inkAt(0).color, ElThemeData.dark.foreground);
    });

    testWidgets('tapping the selected item deselects — ruling B7', (
      WidgetTester t,
    ) async {
      final List<int?> changes = <int?>[];
      await t.pumpWidget(group(selected: 1, onChanged: changes.add));
      await t.pump();

      // Radix `type="single"` clears on a second press of the active item.
      await t.tap(find.byType(ElToggle).at(1));
      await t.pump();
      expect(changes, <int?>[null]);

      // And an unselected neighbour still selects normally.
      await t.tap(find.byType(ElToggle).at(2));
      await t.pump();
      expect(changes, <int?>[null, 2]);
    });

    testWidgets('nothing selected hides the pill', (WidgetTester t) async {
      await t.pumpWidget(group(selected: null));
      await t.pump();
      await t.pump();
      await t.pump(ElDurations.fast);
      await t.pump(ElDurations.fast);

      // `activeIndex: -1` — the substrate's documented out-of-range path, and
      // the reason it exists at all.
      final AnimatedOpacity fade = t.widget<AnimatedOpacity>(
        find
            .descendant(
              of: find.byType(ElSlidingPillGroup),
              matching: find.byType(AnimatedOpacity),
            )
            .first,
      );
      expect(fade.opacity, 0);
    });
  });

  group('ElButtonGroup', () {
    // The three groups the page renders, verbatim (buttons-map §6.2).
    List<Widget> groupA() => <Widget>[
      ElButton(
        variant: ElButtonVariant.outline,
        onPressed: () {},
        child: const Text('Newest'),
      ),
      ElButton(
        variant: ElButtonVariant.outline,
        onPressed: () {},
        child: const Text('Price'),
      ),
      ElButton(
        variant: ElButtonVariant.outline,
        onPressed: () {},
        child: const Text('Popularity'),
      ),
    ];

    List<Widget> groupB() => <Widget>[
      const ElButtonGroupText('Quantity'),
      const ElButtonGroupSeparator(),
      ElButton(
        variant: ElButtonVariant.outline,
        size: ElButtonSize.icon,
        label: 'Decrease quantity',
        onPressed: () {},
        child: const ElIcon(ElIconGlyph.minus),
      ),
      const ElButtonGroupText('3', numeric: true),
      ElButton(
        variant: ElButtonVariant.outline,
        size: ElButtonSize.icon,
        label: 'Increase quantity',
        onPressed: () {},
        child: const ElIcon(ElIconGlyph.plus),
      ),
    ];

    List<Widget> groupC() => <Widget>[
      ElButton(onPressed: () {}, child: const Text('Open Pack')),
      const ElButtonGroupSeparator(),
      ElButton(
        size: ElButtonSize.icon,
        label: 'More open options',
        onPressed: () {},
        child: const ElIcon(ElIconGlyph.chevronDown),
      ),
    ];

    test('group A: pill on the left, 12px on the right — drift 7', () {
      final List<Widget> a = groupA();
      // The leading member keeps its own radius; the trailing one is forced to
      // `--radius-lg` by an `!important` rule. Asymmetric by construction.
      expect(ElButtonGroup.radiiOf(a, 0).topLeft.x, ElRadii.pill);
      expect(ElButtonGroup.radiiOf(a, 0).topRight.x, 0);
      // Interior corners are squared on both sides.
      expect(ElButtonGroup.radiiOf(a, 1).topLeft.x, 0);
      expect(ElButtonGroup.radiiOf(a, 1).topRight.x, 0);
      expect(ElButtonGroup.radiiOf(a, 2).topLeft.x, 0);
      expect(ElButtonGroup.radiiOf(a, 2).topRight.x, ElRadii.lg);
    });

    test('group B is symmetric only because it opens with a Text cell', () {
      final List<Widget> b = groupB();
      // 12px both ends — and the left 12 is the `ButtonGroupText`'s own
      // `rounded-lg`, not anything the group did.
      expect(ElButtonGroup.radiiOf(b, 0).topLeft.x, ElRadii.lg);
      expect(ElButtonGroup.radiiOf(b, 4).topRight.x, ElRadii.lg);
    });

    test('group C: pill left, 12px right', () {
      final List<Widget> c = groupC();
      expect(ElButtonGroup.radiiOf(c, 0).topLeft.x, ElRadii.pill);
      expect(ElButtonGroup.radiiOf(c, 2).topRight.x, ElRadii.lg);
    });

    test('the rounding rule reaches PAST a Text cell — drift 8', () {
      // `ButtonGroupText` sets no `data-slot`, so it can never satisfy
      // `[&>[data-slot]:not(:has(~[data-slot]))]` and the rule lands on the
      // last member that can — here the Button, which is not last.
      final List<Widget> trailing = <Widget>[
        ElButton(onPressed: () {}, child: const Text('Open Pack')),
        const ElButtonGroupText('of 12'),
      ];
      expect(
        ElButtonGroup.radiiOf(trailing, 0).topRight.x,
        ElRadii.lg,
        reason: 'an interior Button forced to 12px by the reach-past',
      );
    });

    test('only the first member keeps a left border — border-l-0', () {
      final List<Widget> a = groupA();
      expect(ElButtonGroup.hasLeftBorder(a, 0), isTrue);
      expect(ElButtonGroup.hasLeftBorder(a, 1), isFalse);
      expect(ElButtonGroup.hasLeftBorder(a, 2), isFalse);
    });

    testWidgets('members are flush and stretch to the tallest', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(ElButtonGroup(children: groupB())));

      // `items-stretch` is what gives the height-less Text cell its 40px.
      final double rowHeight = t.getSize(find.byType(ElButtonGroup)).height;
      expect(rowHeight, el(10));
      expect(t.getSize(find.byType(ElButtonGroupText).first).height, el(10));

      // `gap` is 0 — the `has-[>[data-slot=button-group]]:gap-2` rule needs a
      // nested group, and nothing on this page nests.
      final Rect text = t.getRect(find.byType(ElButtonGroupText).first);
      final Rect rule = t.getRect(find.byType(ElButtonGroupSeparator));
      expect(rule.left, closeTo(text.right, 1e-9));
    });

    testWidgets('the separator is 1px wide and inset 1px top and bottom', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(ElButtonGroup(children: groupC())));

      // `self-stretch` makes the separator's own box the full row height…
      expect(t.getSize(find.byType(ElButtonGroupSeparator)).height, el(10));

      // …and `my-px` is a *margin*, so the painted rule stops one pixel short
      // at each end. `w-px` is the width.
      final Size rule = t.getSize(
        find.descendant(
          of: find.byType(ElButtonGroupSeparator),
          matching: find.byType(ColoredBox),
        ),
      );
      expect(rule.width, ElWidths.hairline);
      expect(rule.height, el(10) - 2 * ElWidths.hairline);
    });

    testWidgets('a Text cell is --muted at 13/500, 10px in from its border', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(ElButtonGroup(children: groupB())));

      final DecoratedBox box = t.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(ElButtonGroupText).first,
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect((box.decoration as BoxDecoration).color, ElThemeData.dark.muted);
      expect(ElButtonGroupText.paddingX, 10);

      final TextStyle style = t
          .widget<Text>(
            find.descendant(
              of: find.byType(ElButtonGroupText).first,
              matching: find.byType(Text),
            ),
          )
          .style!;
      expect(style.fontSize, 13);
      expect(style.fontFamily, contains('InterLocal'));
    });

    testWidgets('className="type-num" renders 13px/500 mono — drift 16', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(ElButtonGroup(children: groupB())));

      final TextStyle style = t
          .widget<Text>(
            find.descendant(
              of: find.byType(ElButtonGroupText).at(1),
              matching: find.byType(Text),
            ),
          )
          .style!;
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

  group('ElKbd', () {
    test('20 tall, 20 minimum wide, 4px padding, 4px gaps', () {
      expect(ElKbd.height, 20);
      expect(ElKbd.minWidth, 20);
      expect(ElKbd.paddingX, 4);
      expect(ElKbd.gap, 4);
      expect(ElKbdGroup.gap, 4);
    });

    testWidgets(
      'is a flat 6px --muted chip — no border, no shadow — drift 18',
      (WidgetTester t) async {
        await t.pumpWidget(host(const ElKbd('Esc')));

        final ElMachineSurface surface = t.widget<ElMachineSurface>(
          find
              .descendant(
                of: find.byType(ElKbd),
                matching: find.byType(ElMachineSurface),
              )
              .first,
        );
        expect(surface.fill, ElThemeData.dark.muted);
        expect(surface.radius, BorderRadius.circular(ElRadii.sm));
        // `--shadow-key`, `--shadow-key-down` and `press-key` all exist for
        // exactly this object, one foundations page away, and Kbd uses none.
        expect(surface.spec.layers, isEmpty);
        expect(surface.border, isNull);
      },
    );

    testWidgets('is 20px tall and never narrower than 20', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const ElKbd('K')));
      final Size box = t.getSize(find.byType(ElKbd));
      expect(box.height, 20);
      // A single narrow glyph plus 4+4 of padding is under the floor, so
      // `min-w-5` decides.
      expect(box.width, 20);

      await t.pumpWidget(host(const ElKbd('Space')));
      expect(t.getSize(find.byType(ElKbd)).width, greaterThan(20));
    });

    testWidgets('the key label is 12px/500 at --muted-foreground', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const ElKbd('Ctrl')));
      final TextStyle style = t
          .widget<Text>(
            find.descendant(
              of: find.byType(ElKbd),
              matching: find.byType(Text),
            ),
          )
          .style!;
      expect(style.fontSize, 12);
      expect(style.color, ElThemeData.dark.mutedForeground);
    });

    testWidgets('a group is one shortcut, 4px apart — drift 19', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(const ElKbdGroup(children: <Widget>[ElKbd('Ctrl'), ElKbd('K')])),
      );

      final Rect ctrl = t.getRect(find.byType(ElKbd).at(0));
      final Rect k = t.getRect(find.byType(ElKbd).at(1));
      expect(k.left - ctrl.right, closeTo(ElKbdGroup.gap, 1e-9));

      // `<kbd><kbd>Ctrl</kbd><kbd>K</kbd></kbd>` is one keyboard object, and
      // it is announced as one.
      expect(
        find.descendant(
          of: find.byType(ElKbdGroup),
          matching: find.byType(MergeSemantics),
        ),
        findsOneWidget,
      );
    });
  });

  group('ElIconSwap', () {
    Widget swap(int active) => host(
      ElIconSwap(
        activeIndex: active,
        window: 20,
        cell: 16,
        icons: const <Widget>[
          ElIcon(ElIconGlyph.layoutGrid),
          ElIcon(ElIconGlyph.rows3),
        ],
      ),
    );

    testWidgets('is a fixed clip window, whatever the strip is doing', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(swap(0));
      expect(t.getSize(find.byType(ElIconSwap)), const Size(20, 20));
    });

    test('an unknown index clamps to 0, as Math.max(0, indexOf) does', () {
      expect(ElIconSwap.resolveIndex(-1, 2), 0);
      expect(ElIconSwap.resolveIndex(7, 2), 0);
      expect(ElIconSwap.resolveIndex(1, 2), 1);
    });

    testWidgets('the leaver exits through the top and the arriver rises', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(swap(0));
      await t.pump(ElSwapRoll.duration);
      await t.pump(ElSwapRoll.duration);

      double yOf(int i) => t.getRect(find.byType(ElIcon).at(i)).center.dy;
      final double windowCentre = t.getRect(find.byType(ElIconSwap)).center.dy;

      // At rest: glyph 0 centred, glyph 1 parked one full step BELOW.
      expect(yOf(0), closeTo(windowCentre, 0.51));
      expect(yOf(1) - yOf(0), closeTo(ElSwapRoll.travelFor(16), 0.51));

      await t.pumpWidget(swap(1));
      await t.pump(ElSwapRoll.duration);
      await t.pump(ElSwapRoll.duration);
      await t.pump(ElJelly.duration);

      // After the roll the strip has moved up by exactly one step: glyph 1 is
      // centred and glyph 0 has left through the top.
      expect(yOf(1), closeTo(windowCentre, 0.51));
      expect(yOf(0), lessThan(windowCentre));
      expect(yOf(1) - yOf(0), closeTo(ElSwapRoll.travelFor(16), 0.51));
    });

    testWidgets('the arriving glyph squashes on FIRST MOUNT too', (
      WidgetTester t,
    ) async {
      // The one place IconSwap is the inverse of the sliding pill: the pill
      // deliberately lands its first placement silently, and every IconSwap
      // demo deliberately squashes once on page load.
      List<double> scalesUnderSwap() => t
          .widgetList<Transform>(
            find.descendant(
              of: find.byType(ElIconSwap),
              matching: find.byType(Transform),
            ),
          )
          .map((Transform x) => x.transform.storage[0])
          .toList();

      await t.pumpWidget(swap(0));
      await t.pump();

      // `animation-delay: var(--duration-fast)` — still identity at 150ms…
      await t.pump(ElSwapRoll.squashDelay);
      expect(
        scalesUnderSwap().every((double s) => (s - 1).abs() < 1e-6),
        isTrue,
        reason: 'the delay holds stop 0',
      );

      // …and 30% into the 600ms jelly it is at the table's widest stop, 1.18.
      await t.pump(const Duration(milliseconds: 180));
      expect(scalesUnderSwap().any((double s) => s > 1.1), isTrue);

      // It settles back to identity by the end of the run.
      await t.pump(ElJelly.duration);
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
          child: ElTheme(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: Center(
              child: ElIconSwap(
                activeIndex: active,
                window: 20,
                cell: 16,
                icons: const <Widget>[
                  ElIcon(ElIconGlyph.play),
                  ElIcon(ElIconGlyph.pause),
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

      final double windowCentre = t.getRect(find.byType(ElIconSwap)).center.dy;
      expect(
        t.getRect(find.byType(ElIcon).at(1)).center.dy,
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

    double centre(WidgetTester t) =>
        t.getRect(find.byType(ElIconSwap)).center.dy;
    double yOf(WidgetTester t, int i) =>
        t.getRect(find.byType(ElIcon).at(i)).center.dy;
    List<double> opacities(WidgetTester t) => t
        .widgetList<Opacity>(
          find.descendant(
            of: find.byType(ElIconSwap),
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
      expect(ElSwapRoll.travelFor(16), closeTo(25.6, 1e-9));
      expect(ElSwapRoll.travelFor(20), closeTo(32, 1e-9));
      expect(ElTransforms.swapRollTravel, 1.6);

      await t.pumpWidget(swap(0));
      await t.pump(ElSwapRoll.duration);
      await t.pump(ElJelly.duration);
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
      expect(ElSwapRoll.duration, const Duration(milliseconds: 400));
      expect(ElSwapRoll.curve, ElCurves.spring);

      await t.pumpWidget(swap(0));
      await t.pump(ElSwapRoll.duration);
      await t.pump(ElJelly.duration);
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
        furthest / ElSwapRoll.travelFor(16),
        closeTo(0.0977, 0.015),
        reason: 'measured +9.77% of travel past centre, mid-flight',
      );

      await t.pump(ElSwapRoll.duration);
      await t.pump(ElJelly.duration);
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
      await t.pump(ElSwapRoll.duration);
      await t.pump(ElJelly.duration);

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
      await t.pump(ElJelly.duration);
      expect(opacities(t), <double>[0, 1]);
    });

    testWidgets('S3b: the crossfade is done at 163ms, the roll is not', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(swap(0));
      await t.pump(ElSwapRoll.duration);
      await t.pump(ElJelly.duration);
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
      await t.pump(ElSwapRoll.duration);
      await t.pump(ElJelly.duration);
      final double home = centre(t);

      await t.pumpWidget(swap(1));
      await t.pump(ElSwapRoll.duration);
      await t.pump(ElJelly.duration);
      expect(
        yOf(t, 0),
        lessThan(home),
        reason: 'advance: leaver exits the TOP',
      );
      final double advanced = home - yOf(t, 0);

      await t.pumpWidget(swap(0));
      await t.pump(ElSwapRoll.duration);
      await t.pump(ElJelly.duration);
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
      expect(ElSwapRoll.squashDelay, const Duration(milliseconds: 150));
      expect(ElJelly.duration, const Duration(milliseconds: 600));
      expect(
        ElSwapRoll.squashDelay + ElJelly.duration,
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
      await t.pump(ElSwapRoll.duration);
      await t.pump(ElJelly.duration);

      expect(
        find.descendant(
          of: find.byType(ElIconSwap),
          matching: find.byType(ElIcon),
        ),
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
      await t.pump(ElSwapRoll.squashDelay);
      await t.pump(const Duration(milliseconds: 180));
      final List<double> scales = t
          .widgetList<Transform>(
            find.descendant(
              of: find.byType(ElIconSwap),
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
      await t.pump(ElJelly.duration);
    });

    testWidgets('S8: an interruption re-targets from the CURRENT transform and '
        'runs the full 400ms', (WidgetTester t) async {
      // Measured at a reversal 264ms into a 400ms roll — mid-overshoot, with
      // the strip at −28.10 rather than its −25.60 target. CSS re-targets from
      // where the box actually is and restarts the whole duration; snapping to
      // the target first, or finishing early, are both the regression.
      await t.pumpWidget(swap(0));
      await t.pump(ElSwapRoll.duration);
      await t.pump(ElJelly.duration);
      final double home = centre(t);

      await t.pumpWidget(swap(1));
      await t.pump(const Duration(milliseconds: 264));
      final double interrupted = yOf(t, 0);
      expect(
        home - interrupted,
        greaterThan(ElSwapRoll.travelFor(16)),
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

      await t.pump(ElSwapRoll.duration);
      await t.pump(ElJelly.duration);
      expect(yOf(t, 0), closeTo(home, 0.51));
    });
  });

  group('ElSheet', () {
    Widget trigger({double? width}) => navHost(
      Builder(
        builder: (BuildContext context) {
          return ElButton(
            variant: ElButtonVariant.outline,
            onPressed: () => ElSheet.showLeft(
              context,
              width: width ?? ElWidths.sidebarMobile,
              builder: (BuildContext c) => ElText('Design system', ElType.nav),
            ),
            child: const ElIcon(ElIconGlyph.menu),
          );
        },
      ),
    );

    testWidgets('opens a 288px panel against the left edge', (
      WidgetTester t,
    ) async {
      useFrame(t);
      await t.pumpWidget(trigger());
      await t.tap(find.byType(ElButton));
      await t.pumpAndSettle();

      expect(find.text('Design system'), findsOneWidget);
      final Rect panel = t.getRect(find.byType(ElSheetPanel));
      expect(panel.width, ElWidths.sidebarMobile);
      expect(panel.left, 0);
      expect(panel.height, 900);
    });

    testWidgets('honours an explicit width', (WidgetTester t) async {
      useFrame(t);
      await t.pumpWidget(trigger(width: ElWidths.sidebar));
      await t.tap(find.byType(ElButton));
      await t.pumpAndSettle();

      expect(t.getRect(find.byType(ElSheetPanel)).width, ElWidths.sidebar);
    });

    testWidgets('the right-hand hairline comes out of the 288, not off it', (
      WidgetTester t,
    ) async {
      // `w-72` under `box-sizing: border-box`: 288px including the border, so
      // the sheet's content is 287 wide and the panel's right edge is where
      // the page resumes.
      useFrame(t);
      await t.pumpWidget(trigger());
      await t.tap(find.byType(ElButton));
      await t.pumpAndSettle();

      expect(
        t.getSize(find.byType(ElSafeArea)).width,
        ElWidths.sidebarMobile - ElWidths.hairline,
      );
    });

    testWidgets('slides in from 40px out, over the overlay duration', (
      WidgetTester t,
    ) async {
      useFrame(t);
      await t.pumpWidget(trigger());
      await t.tap(find.byType(ElButton));
      await t.pump(); // route pushed, animation at zero

      // CORRECTED 2026-08-16, measured. `slide-in-from-left-10` is **not** 10
      // spacing units: the installed tw-animate-css resolves it to
      // `calc(.1 * 100%)`, a percentage of the element's own border box. The
      // live sheet's first `enter` frame reads `matrix(1,0,0,1,38.4,0)` against
      // a 384px panel — so the 288px docs sheet travels 28.8, not 40.
      expect(
        t.getRect(find.byType(ElSheetPanel)).left,
        closeTo(-ElWidths.sidebarMobile * 0.1, 0.5),
      );

      await t.pump(ElDurations.overlay);
      expect(t.getRect(find.byType(ElSheetPanel)).left, closeTo(0, 0.5));
    });

    testWidgets('blurs and tints what is behind it', (WidgetTester t) async {
      useFrame(t);
      await t.pumpWidget(trigger());
      await t.tap(find.byType(ElButton));
      await t.pumpAndSettle();

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('a tap outside dismisses it', (WidgetTester t) async {
      useFrame(t);
      await t.pumpWidget(trigger());
      await t.tap(find.byType(ElButton));
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
  group('ElButton state matrix', () {
    /// The one [ElMachineSurface] a flat variant paints itself with. The two
    /// gradient variants also contain one — the inset half of their spec —
    /// so those read [ElSheenAction] / [ElFoilValue] instead.
    ElMachineSurface surfaceOf(WidgetTester t) =>
        t.widget<ElMachineSurface>(find.byType(ElMachineSurface));

    ElSheenAction sheenOf(WidgetTester t) =>
        t.widget<ElSheenAction>(find.byType(ElSheenAction));

    ElFoilValue foilOf(WidgetTester t) =>
        t.widget<ElFoilValue>(find.byType(ElFoilValue));

    TextStyle labelStyleOf(WidgetTester t) => t
        .widget<DefaultTextStyle>(
          find
              .descendant(
                of: find.byType(ElButton),
                matching: find.byType(DefaultTextStyle),
              )
              .first,
        )
        .style;

    Color borderOf(WidgetTester t) =>
        (surfaceOf(t).border! as Border).top.color;

    Future<void> mount(
      WidgetTester t,
      ElButtonVariant variant, {
      ElThemeMode mode = ElThemeMode.dark,
      FocusNode? focusNode,
    }) => t.pumpWidget(
      host(
        ElButton(
          variant: variant,
          focusNode: focusNode,
          onPressed: () {},
          child: const ElIcon(ElIconGlyph.check),
        ),
        mode: mode,
      ),
    );

    /// Hover, then run the 250ms `btn-spring` colour transition to its end.
    Future<TestGesture> hoverAndSettle(WidgetTester t) async {
      final TestGesture mouse = await hoverOver(t, find.byType(ElButton));
      await t.pump(ElDurations.base);
      await t.pump(ElDurations.base);
      return mouse;
    }

    Future<TestGesture> holdDown(WidgetTester t) async {
      final TestGesture g = await t.startGesture(
        t.getCenter(find.byType(ElButton)),
      );
      await t.pump();
      await t.pump(ElDurations.tick);
      return g;
    }

    Future<void> focusAndSettle(WidgetTester t, FocusNode node) async {
      node.requestFocus();
      await t.pump();
      await t.pump(ElDurations.base);
      await t.pump(ElDurations.base);
    }

    testWidgets('the cva default is `default`, i.e. primary', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          ElButton(onPressed: () {}, child: const ElIcon(ElIconGlyph.check)),
        ),
      );
      expect(
        find.byType(ElSheenAction),
        findsOneWidget,
        reason: 'defaultVariants.variant = "default" in button.tsx',
      );
      expect(
        t.widget<ElButton>(find.byType(ElButton)).variant,
        ElButtonVariant.primary,
      );
    });

    testWidgets('the enum carries all seven cva variants, in source order', (
      WidgetTester t,
    ) async {
      expect(ElButtonVariant.values, <ElButtonVariant>[
        ElButtonVariant.primary,
        ElButtonVariant.premium,
        ElButtonVariant.secondary,
        ElButtonVariant.outline,
        ElButtonVariant.ghost,
        ElButtonVariant.destructive,
        ElButtonVariant.link,
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
        ElButtonVariant variant,
      ) async {
        await t.pumpWidget(
          host(
            ElButton(
              variant: variant,
              expanded: true,
              onPressed: () {},
              child: const ElIcon(ElIconGlyph.check),
            ),
          ),
        );
        await t.pump(ElDurations.base);
        await t.pump(ElDurations.base);
      }

      testWidgets('ghost: --secondary over --foreground, with no pointer '
          'anywhere near it', (WidgetTester t) async {
        await mountExpanded(t, ElButtonVariant.ghost);
        // `aria-expanded:bg-secondary aria-expanded:text-foreground` — the
        // pair its hover already paints, held while the menu is open. The gap
        // this closes is exactly the pointer-less case.
        expect(surfaceOf(t).fill, ElThemeData.dark.secondary);
        expect(labelStyleOf(t).color, ElThemeData.dark.foreground);
      });

      testWidgets('outline: --muted, which is its own hover fill', (
        WidgetTester t,
      ) async {
        await mountExpanded(t, ElButtonVariant.outline);
        expect(surfaceOf(t).fill, ElThemeData.dark.muted);
      });

      testWidgets('secondary: --accent, likewise', (WidgetTester t) async {
        await mountExpanded(t, ElButtonVariant.secondary);
        expect(surfaceOf(t).fill, ElThemeData.dark.accent);
      });

      testWidgets('the other four declare no `aria-expanded:` class at all', (
        WidgetTester t,
      ) async {
        // The two ramps read `hovered` themselves, and an open trigger is not
        // a hovered one.
        await mountExpanded(t, ElButtonVariant.primary);
        expect(sheenOf(t).hovered, isFalse);
        expect(sheenOf(t).spec, same(ElShadows.btnPrimary));

        await mountExpanded(t, ElButtonVariant.premium);
        expect(foilOf(t).hovered, isFalse);
        expect(foilOf(t).spec, same(ElShadows.btnValue));

        // The two flat ones are compared against their own rest. The pumps
        // matter: the element survives a re-pump, so the fill springs from the
        // *previous* variant's colour and a reading taken on the first frame
        // would be the one before it.
        Future<Color?> restFillOf(ElButtonVariant variant) async {
          await mount(t, variant);
          await t.pump(ElDurations.base);
          await t.pump(ElDurations.base);
          return surfaceOf(t).fill;
        }

        for (final ElButtonVariant variant in <ElButtonVariant>[
          ElButtonVariant.destructive,
          ElButtonVariant.link,
        ]) {
          final Color? rest = await restFillOf(variant);
          await mountExpanded(t, variant);
          expect(surfaceOf(t).fill, rest, reason: '$variant is unmoved by it');
        }

        // …and the teeth for that comparison: destructive's hover IS a
        // different fill, so the equality above is an assertion rather than
        // two identical nothings agreeing.
        final Color? rest = await restFillOf(ElButtonVariant.destructive);
        await hoverAndSettle(t);
        expect(surfaceOf(t).fill, isNot(rest));
      });
    });

    group('primary — sheen-action bg-primary shadow-btn-primary', () {
      testWidgets('rest: btn-primary, white ink, transparent border', (
        WidgetTester t,
      ) async {
        await mount(t, ElButtonVariant.primary);
        final ElSheenAction sheen = sheenOf(t);
        expect(sheen.spec, same(ElShadows.btnPrimary));
        expect(sheen.hovered, isFalse);
        expect(sheen.pressed, isFalse);
        expect((sheen.border! as Border).top.color, elTransparent);
        expect(labelStyleOf(t).color, ElThemeData.dark.primaryForeground);
      });

      testWidgets('hover starts the beat and changes nothing else', (
        WidgetTester t,
      ) async {
        await mount(t, ElButtonVariant.primary);
        await hoverAndSettle(t);
        expect(sheenOf(t).hovered, isTrue);
        expect(
          sheenOf(t).spec,
          same(ElShadows.btnPrimary),
          reason: 'hover changes no shadow on the default variant',
        );
      });

      testWidgets('active: drops to btn-down and runs one beat', (
        WidgetTester t,
      ) async {
        await mount(t, ElButtonVariant.primary);
        final TestGesture g = await holdDown(t);
        expect(sheenOf(t).spec, same(ElShadows.btnDown));
        expect(sheenOf(t).pressed, isTrue);

        await g.up();
        await t.pump(ElDurations.base);
        expect(sheenOf(t).spec, same(ElShadows.btnPrimary));
      });

      testWidgets('focus-visible: --ring border plus a 3px ring in front', (
        WidgetTester t,
      ) async {
        final FocusNode node = FocusNode();
        addTearDown(node.dispose);
        await mount(t, ElButtonVariant.primary, focusNode: node);
        await focusAndSettle(t, node);

        final ElSheenAction sheen = sheenOf(t);
        expect((sheen.border! as Border).top.color, ElThemeData.dark.ring);
        // `focus-visible:ring-3 focus-visible:ring-ring/50`, prepended so it
        // composites IN FRONT of --tw-shadow (Tailwind v4's slot order).
        final ElShadowLayer ring = sheen.spec.layers.first;
        expect(ring.inset, isFalse);
        expect(
          <double>[ring.dx, ring.dy, ring.blur, ring.spread],
          <double>[0, 0, 0, 3],
        );
        expect(
          ring.color(ElThemeData.dark),
          ElThemeData.dark.ring.withValues(alpha: 0.50),
        );
        expect(
          sheen.spec.layers.length,
          ElShadows.btnPrimary.layers.length + 1,
        );
      });
    });

    group('premium — foil-value shadow-btn-value', () {
      testWidgets('rest: btn-value under a foil, semibold', (
        WidgetTester t,
      ) async {
        await mount(t, ElButtonVariant.premium);
        expect(foilOf(t).spec, same(ElShadows.btnValue));
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
        for (final ElThemeMode mode in <ElThemeMode>[
          ElThemeMode.dark,
          ElThemeMode.light,
        ]) {
          await mount(t, ElButtonVariant.premium, mode: mode);
          expect(
            labelStyleOf(t).color,
            ElPalette.valueForeground,
            reason: '--color-value-foreground is fixed at #121216 ($mode)',
          );
        }
      });

      testWidgets('hover: shadow-glow-value replaces the token wholesale', (
        WidgetTester t,
      ) async {
        await mount(t, ElButtonVariant.premium);
        await hoverAndSettle(t);
        expect(foilOf(t).spec, same(ElShadows.glowValue));
        expect(foilOf(t).hovered, isTrue);
        // The inset rim and the inner shade DISAPPEAR — the glow is not added
        // to the machine surface, it replaces it.
        expect(ElShadows.glowValue.hasInset, isFalse);
      });

      testWidgets('active outranks hover: btn-down wins over the glow', (
        WidgetTester t,
      ) async {
        await mount(t, ElButtonVariant.premium);
        await hoverAndSettle(t);
        expect(foilOf(t).spec, same(ElShadows.glowValue));

        await holdDown(t);
        expect(foilOf(t).spec, same(ElShadows.btnDown));
        expect(foilOf(t).hovered, isTrue, reason: 'still hovered underneath');
      });
    });

    group('secondary — bg-secondary, no shadow at all', () {
      testWidgets('rest and hover', (WidgetTester t) async {
        await mount(t, ElButtonVariant.secondary);
        expect(surfaceOf(t).fill, ElThemeData.dark.secondary);
        expect(
          surfaceOf(t).spec.layers,
          isEmpty,
          reason: 'drift 1: the shadows page copy claims shadow-btn here',
        );
        expect(labelStyleOf(t).color, ElThemeData.dark.secondaryForeground);

        await hoverAndSettle(t);
        expect(surfaceOf(t).fill, ElThemeData.dark.accent);
      });

      testWidgets('active changes nothing but the scale', (
        WidgetTester t,
      ) async {
        await mount(t, ElButtonVariant.secondary);
        await hoverAndSettle(t);
        await holdDown(t);
        expect(surfaceOf(t).fill, ElThemeData.dark.accent);
        expect(surfaceOf(t).spec.layers, isEmpty);
      });
    });

    group('destructive — a tint, not a fill', () {
      testWidgets('rest: 10% wash inside a 25% border, destructive ink', (
        WidgetTester t,
      ) async {
        await mount(t, ElButtonVariant.destructive);
        final ElThemeData dark = ElThemeData.dark;
        expect(surfaceOf(t).fill, dark.destructive.withValues(alpha: 0.10));
        expect(borderOf(t), dark.destructive.withValues(alpha: 0.25));
        expect(surfaceOf(t).spec.layers, isEmpty);
        expect(labelStyleOf(t).color, dark.destructiveInk);
      });

      testWidgets('hover deepens both, to 20% and 40%', (WidgetTester t) async {
        await mount(t, ElButtonVariant.destructive);
        await hoverAndSettle(t);
        final ElThemeData dark = ElThemeData.dark;
        expect(surfaceOf(t).fill, dark.destructive.withValues(alpha: 0.20));
        expect(borderOf(t), dark.destructive.withValues(alpha: 0.40));
      });

      testWidgets('focus overrides both halves of the base ring', (
        WidgetTester t,
      ) async {
        final FocusNode node = FocusNode();
        addTearDown(node.dispose);
        await mount(t, ElButtonVariant.destructive, focusNode: node);
        await focusAndSettle(t, node);

        final ElThemeData dark = ElThemeData.dark;
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
        await mount(t, ElButtonVariant.link);
        expect(surfaceOf(t).fill, elTransparent);
        expect(borderOf(t), elTransparent);
        expect(surfaceOf(t).spec.layers, isEmpty);
        expect(labelStyleOf(t).color, ElThemeData.dark.actionInk);
        expect(labelStyleOf(t).decoration, isNot(TextDecoration.underline));
      });

      testWidgets('hover:underline', (WidgetTester t) async {
        await mount(t, ElButtonVariant.link);
        await hoverAndSettle(t);
        expect(labelStyleOf(t).decoration, TextDecoration.underline);
      });
    });

    group('ElButtonSurface — the class-list override', () {
      /// `variant="outline"` under a class list appended to it, which is how
      /// the reference restyles a `Button` and what this class is a parameter
      /// for.
      Future<void> mountSurface(WidgetTester t, ElButtonSurface surface) =>
          t.pumpWidget(
            host(
              ElButton(
                variant: ElButtonVariant.outline,
                surface: surface,
                onPressed: () {},
                child: const ElIcon(ElIconGlyph.check),
              ),
            ),
          );

      /// `--agent/50` — the colour both call sites of the fifth override name.
      final Color agentRim = ElThemeData.dark.agent.withValues(
        alpha: ElAgentLauncher.hoverRimAlpha,
      );

      testWidgets('hoverBorder moves the rim on hover, and only on hover', (
        WidgetTester t,
      ) async {
        // The assertion has teeth only if the two colours differ — a rim that
        // happened to equal the outline variant's own would pass this test
        // with the field deleted.
        expect(agentRim, isNot(ElThemeData.dark.input));

        await mountSurface(t, ElButtonSurface(hoverBorder: agentRim));
        expect(
          borderOf(t),
          ElThemeData.dark.input,
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
        await t.pump(ElDurations.base);
        await t.pump(ElDurations.base);
        expect(borderOf(t), ElThemeData.dark.input);
      });

      testWidgets('an absent hoverBorder leaves the resting override standing', (
        WidgetTester t,
      ) async {
        // CSS's own fallback, and [hoverFill]'s: a class list that names no
        // `hover:border-*` keeps the border it does name. Every override in
        // the corpus before this one was of exactly that shape, so this is the
        // case that must not have regressed.
        await mountSurface(t, ElButtonSurface(border: ElThemeData.dark.ring));
        expect(borderOf(t), ElThemeData.dark.ring);
        await hoverAndSettle(t);
        expect(borderOf(t), ElThemeData.dark.ring);
      });

      testWidgets('hoverBorder alone does not disturb the other four slots', (
        WidgetTester t,
      ) async {
        await mountSurface(t, ElButtonSurface(hoverBorder: agentRim));
        await hoverAndSettle(t);
        // `outline`'s own hover fill and ink, unchanged: the fifth field is
        // additive, not a replacement for the surface it lands on.
        expect(surfaceOf(t).fill, ElThemeData.dark.muted);
        expect(labelStyleOf(t).color, ElThemeData.dark.foreground);
      });
    });

    testWidgets('outline and ghost still take the base focus ring', (
      WidgetTester t,
    ) async {
      for (final ElButtonVariant variant in <ElButtonVariant>[
        ElButtonVariant.outline,
        ElButtonVariant.ghost,
      ]) {
        final FocusNode node = FocusNode();
        addTearDown(node.dispose);
        await mount(t, variant, focusNode: node);
        await focusAndSettle(t, node);

        expect(
          borderOf(t),
          ElThemeData.dark.ring,
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
      // `ElShadowSpec.outerShadows` reverses the list to reproduce that — so a
      // prepended ring must come out LAST, i.e. painted last, i.e. on top.
      final ElShadowSpec ringed = ElButton.withFocusRing(
        ElShadows.btn,
        ElPalette.action,
      );
      expect(ringed.layers.first.spread, 3);
      final List<BoxShadow> painted = ringed.outerShadows(ElThemeData.dark);
      expect(painted.last.spreadRadius, 3);
      expect(painted.last.color, ElPalette.action);
      // The inset half is untouched — the ring is not inset.
      expect(ringed.insetLayers, ElShadows.btn.insetLayers);
    });

    testWidgets('every variant paints in both themes', (WidgetTester t) async {
      for (final ElThemeMode mode in <ElThemeMode>[
        ElThemeMode.dark,
        ElThemeMode.light,
      ]) {
        for (final ElButtonVariant variant in ElButtonVariant.values) {
          await mount(t, variant, mode: mode);
          await t.pump(ElDurations.base);
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
          ElButton(
            variant: ElButtonVariant.outline,
            focusNode: node,
            onPressed: () => presses++,
            child: const ElIcon(ElIconGlyph.check),
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

  group('ElInput', () {
    ElMachineSurface surfaceOf(WidgetTester t) =>
        t.widget<ElMachineSurface>(find.byType(ElMachineSurface));

    Color borderOf(WidgetTester t) =>
        (surfaceOf(t).border! as Border).top.color;

    Widget field({
      TextEditingController? controller,
      FocusNode? focusNode,
      ElThemeMode mode = ElThemeMode.dark,
    }) => host(
      SizedBox(
        // `max-w-sm` = 24rem = 384px, the cap the shadows page applies.
        width: 384,
        child: ElInput(
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

      expect(t.getSize(find.byType(ElInput)).height, el(10));
      expect(t.getSize(find.byType(ElInput)).width, 384);
      expect(surfaceOf(t).radius, BorderRadius.circular(ElRadii.pill));
      expect(surfaceOf(t).fill, ElThemeData.dark.card);
      expect(borderOf(t), ElThemeData.dark.input);
      expect(surfaceOf(t).spec, same(ElShadows.pressed));
      expect(ElInput.height, el(10));
    });

    testWidgets('shows the placeholder at muted until something is typed', (
      WidgetTester t,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);
      await t.pumpWidget(field(controller: controller));

      expect(find.text('Search packs, cards and sets'), findsOneWidget);
      expect(
        t.widget<ElText>(find.byType(ElText).first).color,
        ElThemeData.dark.mutedForeground,
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
      expect(editable.cursorColor, ElThemeData.dark.foreground);
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
      await t.pump(ElDurations.base);
      await t.pump(ElDurations.base);

      final ElThemeData dark = ElThemeData.dark;
      expect(
        borderOf(t),
        dark.primary.withValues(alpha: 0.50),
        reason: 'focus-visible:border-primary/50 — --primary, not --ring',
      );

      final ElShadowSpec spec = surfaceOf(t).spec;
      final ElShadowLayer ring = spec.layers.first;
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
      expect(spec.insetLayers, ElShadows.pressed.insetLayers);
      expect(spec.layers.length, ElShadows.pressed.layers.length + 1);
    });

    testWidgets('has no hover state at all', (WidgetTester t) async {
      await t.pumpWidget(field());
      final Color restBorder = borderOf(t);

      await hoverOver(t, find.byType(ElInput));
      await t.pump(ElDurations.base);
      await t.pump(ElDurations.base);

      expect(borderOf(t), restBorder);
      expect(
        surfaceOf(t).spec,
        same(ElShadows.pressed),
        reason: 'the field is already sunken and only its ring changes',
      );
    });

    testWidgets('renders in both themes', (WidgetTester t) async {
      for (final ElThemeMode mode in <ElThemeMode>[
        ElThemeMode.dark,
        ElThemeMode.light,
      ]) {
        await t.pumpWidget(field(mode: mode));
        await t.pump(ElDurations.base);
        expect(t.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
