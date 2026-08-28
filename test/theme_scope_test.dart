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

/// The scope layer: who owns the theme, how `system` resolves, and how a
/// `.type-*` class becomes glyphs on screen.

/// The minimum ancestry `ThemeScope`/`StyledText` need, with the platform brightness
/// and the viewport under the test's control — the first is what `system` mode
/// follows, the second is what the `clamp()` classes measure against.
Widget host({
  required ThemeController controller,
  required Widget child,
  Brightness platformBrightness = Brightness.dark,
  Size size = const Size(1440, 900),
}) {
  return MediaQuery(
    data: MediaQueryData(size: size, platformBrightness: platformBrightness),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ThemeScope(controller: controller, child: child),
    ),
  );
}

/// Reads the resolved theme and records every build, so a test can prove that
/// a mode change actually reached a dependent rather than only the notifier.
class Probe extends StatelessWidget {
  const Probe({super.key, required this.onBuild});

  final void Function(ThemeTokens theme) onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild(ThemeScope.of(context));
    return const SizedBox.shrink();
  }
}

void main() {
  group('ThemeController', () {
    test('resolves the two explicit modes without consulting the platform', () {
      final ThemeController c = ThemeController(mode: ColorMode.dark);
      expect(c.resolve(Brightness.light), ResolvedColorMode.dark);

      c.setMode(ColorMode.light);
      expect(c.resolve(Brightness.dark), ResolvedColorMode.light);
    });

    test('system mode follows the platform brightness', () {
      final ThemeController c = ThemeController(mode: ColorMode.system);
      expect(c.resolve(Brightness.dark), ResolvedColorMode.dark);
      expect(c.resolve(Brightness.light), ResolvedColorMode.light);
    });

    test('defaults to dark — the reference ThemeProvider does', () {
      expect(ThemeController().mode, ColorMode.dark);
    });

    test('notifies once per real change, never on a no-op set', () {
      final ThemeController c = ThemeController();
      int notifications = 0;
      c.addListener(() => notifications++);

      c.setMode(ColorMode.dark); // already dark
      expect(notifications, 0);

      c.setMode(ColorMode.light);
      expect(notifications, 1);
    });
  });

  group('ThemeScope', () {
    testWidgets('mode dark resolves ThemeTokens.dark', (WidgetTester t) async {
      ThemeTokens? seen;
      await t.pumpWidget(
        host(
          controller: ThemeController(mode: ColorMode.dark),
          child: Probe(onBuild: (ThemeTokens d) => seen = d),
        ),
      );

      expect(seen, same(ThemeTokens.dark));
      expect(seen!.background, ThemeTokens.dark.background);
    });

    testWidgets('setMode(light) rebuilds a dependent', (WidgetTester t) async {
      final ThemeController controller = ThemeController();
      final List<ResolvedColorMode> builds = <ResolvedColorMode>[];
      await t.pumpWidget(
        host(
          controller: controller,
          child: Probe(onBuild: (ThemeTokens d) => builds.add(d.kind)),
        ),
      );
      expect(builds, <ResolvedColorMode>[ResolvedColorMode.dark]);

      controller.setMode(ColorMode.light);
      await t.pump();

      expect(builds, <ResolvedColorMode>[
        ResolvedColorMode.dark,
        ResolvedColorMode.light,
      ]);
    });

    testWidgets('system mode follows MediaQuery.platformBrightness', (
      WidgetTester t,
    ) async {
      final ThemeController controller = ThemeController(
        mode: ColorMode.system,
      );
      ThemeTokens? seen;

      await t.pumpWidget(
        host(
          controller: controller,
          platformBrightness: Brightness.light,
          child: Probe(onBuild: (ThemeTokens d) => seen = d),
        ),
      );
      expect(seen, same(ThemeTokens.light));

      await t.pumpWidget(
        host(
          controller: controller,
          child: Probe(onBuild: (ThemeTokens d) => seen = d),
        ),
      );
      expect(seen, same(ThemeTokens.dark));
    });

    testWidgets('controllerOf and modeOf expose the live controller', (
      WidgetTester t,
    ) async {
      final ThemeController controller = ThemeController();
      late BuildContext captured;

      await t.pumpWidget(
        host(
          controller: controller,
          child: Builder(
            builder: (BuildContext c) {
              captured = c;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(ThemeScope.controllerOf(captured), same(controller));
      expect(ThemeScope.modeOf(captured), ColorMode.dark);
    });
  });

  group('StyledText', () {
    Future<Text> render(
      WidgetTester t,
      StyledText text, {
      ColorMode mode = ColorMode.dark,
    }) async {
      await t.pumpWidget(
        host(
          controller: ThemeController(mode: mode),
          child: text,
        ),
      );
      return t.widget<Text>(find.byType(Text));
    }

    testWidgets('uppercases when the class does', (WidgetTester t) async {
      await render(t, StyledText('Remaining supply', TextStyles.eyebrow));
      expect(find.text('REMAINING SUPPLY'), findsOneWidget);
    });

    testWidgets('leaves a class without text-transform alone', (
      WidgetTester t,
    ) async {
      await render(t, StyledText('Remaining supply', TextStyles.body));
      expect(find.text('Remaining supply'), findsOneWidget);
    });

    testWidgets("takes the class's own colour from the live theme", (
      WidgetTester t,
    ) async {
      final Text dark = await render(t, StyledText('x', TextStyles.eyebrow));
      expect(dark.style!.color, ThemeTokens.dark.mutedForeground);

      final Text light = await render(
        t,
        StyledText('x', TextStyles.eyebrow),
        mode: ColorMode.light,
      );
      expect(light.style!.color, ThemeTokens.light.mutedForeground);
    });

    testWidgets('a class with no colour of its own inherits', (
      WidgetTester t,
    ) async {
      // No DefaultTextStyle above it → the surface colour, `--foreground`.
      final Text bare = await render(t, StyledText('x', TextStyles.body));
      expect(bare.style!.color, ThemeTokens.dark.foreground);

      // Inside one → whatever that ancestor set, exactly like CSS inheritance.
      await t.pumpWidget(
        host(
          controller: ThemeController(),
          child: DefaultTextStyle(
            style: TextStyle(color: ThemeTokens.dark.actionText),
            child: StyledText('x', TextStyles.body),
          ),
        ),
      );
      expect(
        t.widget<Text>(find.byType(Text)).style!.color,
        ThemeTokens.dark.actionText,
      );
    });

    testWidgets('an explicit colour beats both', (WidgetTester t) async {
      final Text text = await render(
        t,
        StyledText(
          'x',
          TextStyles.eyebrow,
          color: ThemeTokens.dark.premiumText,
        ),
      );
      expect(text.style!.color, ThemeTokens.dark.premiumText);
    });

    testWidgets('renders the class metrics', (WidgetTester t) async {
      final Text text = await render(t, StyledText('x', TextStyles.numberSm));
      final TextStyle style = text.style!;
      expect(style.fontSize, TextStyles.numberSm.size);
      expect(style.height, TextStyles.numberSm.height);
      expect(
        style.letterSpacing,
        closeTo(
          TextStyles.numberSm.tracking! * TextStyles.numberSm.size!,
          1e-9,
        ),
      );
      expect(style.fontFeatures, isNotEmpty);
    });

    testWidgets('fontSize carries the fluid classes', (WidgetTester t) async {
      final Text text = await render(
        t,
        StyledText(
          'x',
          TextStyles.display,
          fontSize: TextStyles.displaySize(1440),
        ),
      );
      expect(text.style!.fontSize, TextStyles.displaySize(1440));
    });

    testWidgets('styleOf resolves the same style for spans', (
      WidgetTester t,
    ) async {
      late TextStyle style;
      await t.pumpWidget(
        host(
          controller: ThemeController(),
          child: Builder(
            builder: (BuildContext c) {
              style = StyledText.styleOf(c, TextStyles.eyebrow);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(style.color, ThemeTokens.dark.mutedForeground);
      expect(style.fontSize, TextStyles.eyebrow.size);
    });
  });

  group('Fluid', () {
    testWidgets('reads the clamp against the viewport width', (
      WidgetTester t,
    ) async {
      late double display;
      late double h1;
      await t.pumpWidget(
        host(
          controller: ThemeController(),
          child: Builder(
            builder: (BuildContext c) {
              display = Fluid.display(c);
              h1 = Fluid.h1(c);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(display, TextStyles.displaySize(1440)); // 4.4vw of 1440 = 63.36
      expect(h1, TextStyles.h1Size(1440)); // 2.8vw = 40.32, clamped to 40
    });
  });
}
