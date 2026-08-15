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

    testWidgets('sizes: sm 32 high, md 40 high, icon 40², icon-sm 32²',
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

      expect((await sizeOf(DsButtonSize.sm)).height, ds(8));
      expect((await sizeOf(DsButtonSize.md)).height, ds(10));
      expect(await sizeOf(DsButtonSize.icon), Size(ds(10), ds(10)));
      expect(await sizeOf(DsButtonSize.iconSm), Size(ds(8), ds(8)));
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

    testWidgets('squishes to 0.95 — the button scale, not press\'s 0.94',
        (WidgetTester t) async {
      await t.pumpWidget(host(DsButton(
        variant: DsButtonVariant.outline,
        onPressed: () {},
        child: const DsIcon(DsIconGlyph.menu),
      )));

      final Transform transform = t.widget<Transform>(find
          .descendant(of: find.byType(DsButton), matching: find.byType(Transform))
          .first);
      expect(transform.transform.storage[0], 1.0);

      await t.startGesture(t.getCenter(find.byType(DsButton)));
      await t.pump();
      // `btn-spring`: :active transition-duration is --duration-tick, 80ms.
      await t.pump(DsDurations.tick);

      final Transform pressed = t.widget<Transform>(find
          .descendant(of: find.byType(DsButton), matching: find.byType(Transform))
          .first);
      expect(pressed.transform.storage[0],
          closeTo(DsTransforms.buttonScale, 1e-6));
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

      // `slide-in-from-left-10` = 10 spacing units = 40px.
      expect(t.getRect(find.byType(DsSheetPanel)).left, closeTo(-ds(10), 0.5));

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
