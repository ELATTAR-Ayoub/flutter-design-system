import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The effects layer: the two things CSS does that Flutter has no primitive
/// for — an inset box-shadow, and a background gradient whose radii are
/// percentages of the box rather than of its shortest side.

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

/// The 100×40 pill the plan names — a button-shaped surface.
Widget surface(DsShadowSpec spec, {Color? fill}) => SizedBox(
      width: 100,
      height: 40,
      child: DsMachineSurface(
        spec: spec,
        radius: BorderRadius.circular(DsRadii.pill),
        fill: fill,
        child: const SizedBox.expand(),
      ),
    );

void main() {
  group('DsMachineSurface', () {
    testWidgets('paints an inset spec inside a 100×40 pill without error',
        (WidgetTester t) async {
      expect(DsShadows.btn.hasInset, isTrue);
      await t.pumpWidget(host(surface(DsShadows.btn)));
      expect(t.takeException(), isNull);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('paints an outer-only spec without error',
        (WidgetTester t) async {
      expect(DsShadows.e3.hasInset, isFalse);
      await t.pumpWidget(host(surface(DsShadows.e3)));
      expect(t.takeException(), isNull);
    });

    testWidgets('paints both themes without error', (WidgetTester t) async {
      for (final DsThemeMode mode in DsThemeMode.values) {
        await t.pumpWidget(host(surface(DsShadows.pressed), mode: mode));
        expect(t.takeException(), isNull, reason: 'mode $mode');
      }
    });

    testWidgets('hands the outer layers to the decoration, in CSS order',
        (WidgetTester t) async {
      await t.pumpWidget(host(surface(DsShadows.btn)));

      final BoxDecoration decoration = t
          .widget<DecoratedBox>(find
              .descendant(
                of: find.byType(DsMachineSurface),
                matching: find.byType(DecoratedBox),
              )
              .first)
          .decoration as BoxDecoration;

      final List<BoxShadow> expected =
          DsShadows.btn.outerShadows(DsThemeData.dark);
      expect(decoration.boxShadow, hasLength(expected.length));
      expect(decoration.boxShadow, hasLength(2)); // btn has 2 outer, 2 inset
      for (int i = 0; i < expected.length; i++) {
        expect(decoration.boxShadow![i].color, expected[i].color);
        expect(decoration.boxShadow![i].offset, expected[i].offset);
        expect(decoration.boxShadow![i].blurRadius, expected[i].blurRadius);
        expect(decoration.boxShadow![i].spreadRadius, expected[i].spreadRadius);
      }
    });

    testWidgets('a border is paid for out of the child, as border-box does',
        (WidgetTester t) async {
      // The surface is what every outline button is built on, and a button is
      // `border px-4`: the border lives *inside* the declared box, so the
      // label gets the box less two hairlines — not two pixels more.
      const Key content = Key('content');
      await t.pumpWidget(host(SizedBox(
        width: 100,
        height: 40,
        child: DsMachineSurface(
          spec: DsShadows.btn,
          radius: BorderRadius.circular(DsRadii.pill),
          border: Border.all(
            color: DsThemeData.dark.input,
            width: DsWidths.hairline,
          ),
          child: const SizedBox.expand(key: content),
        ),
      )));

      expect(
        t.getSize(find.byKey(content)),
        Size(100 - 2 * DsWidths.hairline, 40 - 2 * DsWidths.hairline),
      );
    });

    testWidgets('a borderless surface takes the whole box',
        (WidgetTester t) async {
      const Key content = Key('content');
      await t.pumpWidget(host(SizedBox(
        width: 100,
        height: 40,
        child: DsMachineSurface(
          spec: DsShadows.e1,
          radius: BorderRadius.circular(DsRadii.pill),
          child: const SizedBox.expand(key: content),
        ),
      )));

      expect(t.getSize(find.byKey(content)), const Size(100, 40));
    });

    testWidgets('re-resolves its ink when the theme flips',
        (WidgetTester t) async {
      final DsThemeController controller = DsThemeController();
      Widget tree() => MediaQuery(
            data: const MediaQueryData(size: Size(1440, 900)),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: DsTheme(
                controller: controller,
                child: Center(child: surface(DsShadows.e3)),
              ),
            ),
          );

      await t.pumpWidget(tree());
      BoxDecoration decorationNow() => t
          .widget<DecoratedBox>(find
              .descendant(
                of: find.byType(DsMachineSurface),
                matching: find.byType(DecoratedBox),
              )
              .first)
          .decoration as BoxDecoration;

      expect(decorationNow().boxShadow!.first.color,
          DsShadows.e3.outerShadows(DsThemeData.dark).first.color);

      controller.setMode(DsThemeMode.light);
      await t.pump();

      expect(decorationNow().boxShadow!.first.color,
          DsShadows.e3.outerShadows(DsThemeData.light).first.color);
    });

    group('the inset ring', () {
      // `--shadow-btn`'s two inset layers, and what each one is for:
      // a 1px rim of light along the top inside edge, and a 4px shade rising
      // from the bottom inside edge.
      final RRect shape = RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 100, 40),
        const Radius.circular(DsRadii.pill),
      );

      test('a positive dy pushes the hole down, lighting the top edge', () {
        // `inset 0 1px 0 var(--rim)` — the hole sits 1px lower than the shape,
        // so the ring covers a sliver along the TOP and nothing at the bottom.
        final Path ring = DsMachineSurface.debugInsetRing(
          shape,
          const DsShadowLayer(0, 1, 0, 0, _rim, inset: true),
        );

        expect(ring.contains(const Offset(50, 0.5)), isTrue, reason: 'top rim');
        expect(ring.contains(const Offset(50, 39.5)), isFalse,
            reason: 'bottom edge is untouched by a downward hole');
        expect(ring.contains(const Offset(50, 20)), isFalse, reason: 'centre');
      });

      test('a negative dy pushes the hole up, shading the bottom edge', () {
        // `inset 0 -2px 4px var(--ink-2)`.
        final Path ring = DsMachineSurface.debugInsetRing(
          shape,
          const DsShadowLayer(0, -2, 4, 0, _ink2, inset: true),
        );

        expect(ring.contains(const Offset(50, 39)), isTrue, reason: 'bottom');
        expect(ring.contains(const Offset(50, 0.5)), isFalse, reason: 'top');
        expect(ring.contains(const Offset(50, 20)), isFalse, reason: 'centre');
      });

      test('spread thickens the ring on every side', () {
        final Path ring = DsMachineSurface.debugInsetRing(
          shape,
          const DsShadowLayer(0, 0, 0, 3, _ink2, inset: true),
        );

        expect(ring.contains(const Offset(50, 1)), isTrue);
        expect(ring.contains(const Offset(50, 39)), isTrue);
        expect(ring.contains(const Offset(50, 20)), isFalse);
      });

      test('reaches well outside the shape so the blur has no far edge', () {
        final Path ring = DsMachineSurface.debugInsetRing(
          shape,
          const DsShadowLayer(0, -2, 4, 0, _ink2, inset: true),
        );
        // The clip hides everything beyond the shape; what matters is that the
        // ring's outer boundary is far enough out that its own blurred edge
        // never shows inside.
        expect(ring.getBounds().top, lessThan(-4));
        expect(ring.getBounds().bottom, greaterThan(44));
      });
    });
  });

  group('DsPageGlow', () {
    testWidgets('paints in both themes without error', (WidgetTester t) async {
      for (final DsThemeMode mode in <DsThemeMode>[
        DsThemeMode.dark,
        DsThemeMode.light,
      ]) {
        await t.pumpWidget(host(
          const SizedBox(width: 800, height: 600, child: DsPageGlow()),
          mode: mode,
        ));
        expect(t.takeException(), isNull, reason: 'mode $mode');
      }
    });

    test('the ellipse is 120%×90% of the box, centred at 62%/34%', () {
      // `radial-gradient(120% 90% at 62% 34%, …)` — CSS sizes the two radii
      // against the box's own width and height, which is exactly what Flutter's
      // shortest-side `RadialGradient.radius` cannot express.
      const Size box = Size(1000, 500);
      final Rect ellipse = DsPageGlow.debugEllipse(box);

      expect(ellipse.center, const Offset(620, 170));
      expect(ellipse.width, 2 * 1.2 * 1000);
      expect(ellipse.height, 2 * 0.9 * 500);
    });

    testWidgets('renders its child above the glow', (WidgetTester t) async {
      await t.pumpWidget(host(
        SizedBox(
          width: 800,
          height: 600,
          child: DsPageGlow(child: DsText('Design System', DsType.h2)),
        ),
      ));
      expect(find.text('Design System'), findsOneWidget);
    });
  });
}

Color _rim(DsThemeData t) => t.rim;
Color _ink2(DsThemeData t) => t.ink2;
