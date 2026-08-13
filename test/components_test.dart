import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart';
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
        onPressed: () => presses++,
        child: const DsIcon(DsIconGlyph.menu),
      )));

      await t.tap(find.byType(DsButton));
      await t.pump(DsDurations.base);
      expect(presses, 1);
    });

    testWidgets('a null onPressed disables it', (WidgetTester t) async {
      await t.pumpWidget(host(const DsButton(child: DsIcon(DsIconGlyph.menu))));

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
}
