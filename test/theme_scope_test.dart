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

    testWidgets('renders the string exactly as it was authored', (
      WidgetTester t,
    ) async {
      // No role transforms its text. A component that wants an uppercase
      // treatment performs it itself and keeps the authored accessible name.
      for (final TextStyleToken role in TextStyles.all) {
        await render(t, StyledText('Remaining supply', role));
        expect(
          find.text('Remaining supply'),
          findsOneWidget,
          reason: role.name,
        );
      }
    });

    testWidgets('no role paints ink of its own', (WidgetTester t) async {
      for (final TextStyleToken role in TextStyles.all) {
        final Text dark = await render(t, StyledText('x', role));
        expect(
          dark.style!.color,
          ThemeTokens.dark.foreground,
          reason: role.name,
        );

        final Text light = await render(
          t,
          StyledText('x', role),
          mode: ColorMode.light,
        );
        expect(
          light.style!.color,
          ThemeTokens.light.foreground,
          reason: role.name,
        );
      }
    });

    testWidgets('every role inherits its ink', (WidgetTester t) async {
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
        StyledText('x', TextStyles.small, color: ThemeTokens.dark.premiumText),
      );
      expect(text.style!.color, ThemeTokens.dark.premiumText);
    });

    testWidgets('renders the role metrics', (WidgetTester t) async {
      final Text text = await render(t, StyledText('x', TextStyles.numberSm));
      final TextStyle style = text.style!;
      final TypeStep step = TextStyles.numberSm.step;
      expect(style.fontSize, step.size);
      expect(style.height, step.ratio);
      expect(
        style.letterSpacing,
        closeTo(TextStyles.numberSm.tracking! * step.size, 1e-9),
      );
      expect(style.fontFeatures, isNotEmpty);
    });

    testWidgets('a responsive role resolves against the viewport', (
      WidgetTester t,
    ) async {
      // The host renders at 1440 logical pixels.
      final Text text = await render(t, StyledText('x', TextStyles.display));
      expect(text.style!.fontSize, TextStyles.display.desktop.size);
    });

    testWidgets('TypeWidthScope overrides the width a role resolves at', (
      WidgetTester t,
    ) async {
      late TextStyle style;
      await t.pumpWidget(
        host(
          controller: ThemeController(),
          child: TypeWidthScope(
            width: 390,
            child: Builder(
              builder: (BuildContext c) {
                style = StyledText.styleOf(c, TextStyles.display);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(style.fontSize, TextStyles.display.mobile.size);
    });

    testWidgets('an explicit fontSize keeps the role leading ratio', (
      WidgetTester t,
    ) async {
      final Text text = await render(
        t,
        StyledText('x', TextStyles.body, fontSize: 40),
      );
      expect(text.style!.fontSize, 40);
      expect(text.style!.height, TextStyles.body.step.ratio);
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
              style = StyledText.styleOf(c, TextStyles.small);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(
        style.color,
        ThemeTokens.dark.foreground,
        reason: 'no role owns ink; small inherits the surface foreground',
      );
      expect(style.fontSize, TextStyles.small.step.size);
    });

    testWidgets('stepOf reports the step a role resolves to', (
      WidgetTester t,
    ) async {
      late TypeStep step;
      await t.pumpWidget(
        host(
          controller: ThemeController(),
          child: Builder(
            builder: (BuildContext c) {
              step = StyledText.stepOf(c, TextStyles.h1);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(step, TextStyles.h1.desktop);
    });
  });
}
