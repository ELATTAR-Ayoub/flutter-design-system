import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The scope layer: who owns the theme, how `system` resolves, and how a
/// `.type-*` class becomes glyphs on screen.

/// The minimum ancestry `DsTheme`/`DsText` need, with the platform brightness
/// and the viewport under the test's control — the first is what `system` mode
/// follows, the second is what the `clamp()` classes measure against.
Widget host({
  required DsThemeController controller,
  required Widget child,
  Brightness platformBrightness = Brightness.dark,
  Size size = const Size(1440, 900),
}) {
  return MediaQuery(
    data: MediaQueryData(size: size, platformBrightness: platformBrightness),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: DsTheme(controller: controller, child: child),
    ),
  );
}

/// Reads the resolved theme and records every build, so a test can prove that
/// a mode change actually reached a dependent rather than only the notifier.
class Probe extends StatelessWidget {
  const Probe({super.key, required this.onBuild});

  final void Function(DsThemeData theme) onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild(DsTheme.of(context));
    return const SizedBox.shrink();
  }
}

void main() {
  group('DsThemeController', () {
    test('resolves the two explicit modes without consulting the platform', () {
      final DsThemeController c = DsThemeController(mode: DsThemeMode.dark);
      expect(c.resolve(Brightness.light), DsThemeKind.dark);

      c.setMode(DsThemeMode.light);
      expect(c.resolve(Brightness.dark), DsThemeKind.light);
    });

    test('system mode follows the platform brightness', () {
      final DsThemeController c = DsThemeController(mode: DsThemeMode.system);
      expect(c.resolve(Brightness.dark), DsThemeKind.dark);
      expect(c.resolve(Brightness.light), DsThemeKind.light);
    });

    test('defaults to dark — the reference ThemeProvider does', () {
      expect(DsThemeController().mode, DsThemeMode.dark);
    });

    test('notifies once per real change, never on a no-op set', () {
      final DsThemeController c = DsThemeController();
      int notifications = 0;
      c.addListener(() => notifications++);

      c.setMode(DsThemeMode.dark); // already dark
      expect(notifications, 0);

      c.setMode(DsThemeMode.light);
      expect(notifications, 1);
    });
  });

  group('DsTheme', () {
    testWidgets('mode dark resolves DsThemeData.dark', (WidgetTester t) async {
      DsThemeData? seen;
      await t.pumpWidget(host(
        controller: DsThemeController(mode: DsThemeMode.dark),
        child: Probe(onBuild: (DsThemeData d) => seen = d),
      ));

      expect(seen, same(DsThemeData.dark));
      expect(seen!.background, DsThemeData.dark.background);
    });

    testWidgets('setMode(light) rebuilds a dependent', (WidgetTester t) async {
      final DsThemeController controller = DsThemeController();
      final List<DsThemeKind> builds = <DsThemeKind>[];
      await t.pumpWidget(host(
        controller: controller,
        child: Probe(onBuild: (DsThemeData d) => builds.add(d.kind)),
      ));
      expect(builds, <DsThemeKind>[DsThemeKind.dark]);

      controller.setMode(DsThemeMode.light);
      await t.pump();

      expect(builds, <DsThemeKind>[DsThemeKind.dark, DsThemeKind.light]);
    });

    testWidgets('system mode follows MediaQuery.platformBrightness',
        (WidgetTester t) async {
      final DsThemeController controller =
          DsThemeController(mode: DsThemeMode.system);
      DsThemeData? seen;

      await t.pumpWidget(host(
        controller: controller,
        platformBrightness: Brightness.light,
        child: Probe(onBuild: (DsThemeData d) => seen = d),
      ));
      expect(seen, same(DsThemeData.light));

      await t.pumpWidget(host(
        controller: controller,
        child: Probe(onBuild: (DsThemeData d) => seen = d),
      ));
      expect(seen, same(DsThemeData.dark));
    });

    testWidgets('controllerOf and modeOf expose the live controller',
        (WidgetTester t) async {
      final DsThemeController controller = DsThemeController();
      late BuildContext captured;

      await t.pumpWidget(host(
        controller: controller,
        child: Builder(builder: (BuildContext c) {
          captured = c;
          return const SizedBox.shrink();
        }),
      ));

      expect(DsTheme.controllerOf(captured), same(controller));
      expect(DsTheme.modeOf(captured), DsThemeMode.dark);
    });
  });

  group('DsText', () {
    Future<Text> render(
      WidgetTester t,
      DsText text, {
      DsThemeMode mode = DsThemeMode.dark,
    }) async {
      await t.pumpWidget(host(
        controller: DsThemeController(mode: mode),
        child: text,
      ));
      return t.widget<Text>(find.byType(Text));
    }

    testWidgets('uppercases when the class does', (WidgetTester t) async {
      await render(t, DsText('Remaining supply', DsType.label));
      expect(find.text('REMAINING SUPPLY'), findsOneWidget);
    });

    testWidgets('leaves a class without text-transform alone',
        (WidgetTester t) async {
      await render(t, DsText('Remaining supply', DsType.body));
      expect(find.text('Remaining supply'), findsOneWidget);
    });

    testWidgets("takes the class's own colour from the live theme",
        (WidgetTester t) async {
      final Text dark = await render(t, DsText('x', DsType.label));
      expect(dark.style!.color, DsThemeData.dark.mutedForeground);

      final Text light = await render(t, DsText('x', DsType.label),
          mode: DsThemeMode.light);
      expect(light.style!.color, DsThemeData.light.mutedForeground);
    });

    testWidgets('a class with no colour of its own inherits',
        (WidgetTester t) async {
      // No DefaultTextStyle above it → the surface colour, `--foreground`.
      final Text bare = await render(t, DsText('x', DsType.body));
      expect(bare.style!.color, DsThemeData.dark.foreground);

      // Inside one → whatever that ancestor set, exactly like CSS inheritance.
      await t.pumpWidget(host(
        controller: DsThemeController(),
        child: DefaultTextStyle(
          style: TextStyle(color: DsThemeData.dark.actionInk),
          child: DsText('x', DsType.body),
        ),
      ));
      expect(t.widget<Text>(find.byType(Text)).style!.color,
          DsThemeData.dark.actionInk);
    });

    testWidgets('an explicit colour beats both', (WidgetTester t) async {
      final Text text = await render(
        t,
        DsText('x', DsType.label, color: DsThemeData.dark.valueInk),
      );
      expect(text.style!.color, DsThemeData.dark.valueInk);
    });

    testWidgets('renders the class metrics', (WidgetTester t) async {
      final Text text = await render(t, DsText('x', DsType.numSm));
      final TextStyle style = text.style!;
      expect(style.fontSize, DsType.numSm.size);
      expect(style.height, DsType.numSm.height);
      expect(style.letterSpacing,
          closeTo(DsType.numSm.tracking! * DsType.numSm.size!, 1e-9));
      expect(style.fontFeatures, isNotEmpty);
    });

    testWidgets('fontSize carries the fluid classes', (WidgetTester t) async {
      final Text text = await render(
        t,
        DsText('x', DsType.display, fontSize: DsType.displaySize(1440)),
      );
      expect(text.style!.fontSize, DsType.displaySize(1440));
    });

    testWidgets('styleOf resolves the same style for spans',
        (WidgetTester t) async {
      late TextStyle style;
      await t.pumpWidget(host(
        controller: DsThemeController(),
        child: Builder(builder: (BuildContext c) {
          style = DsText.styleOf(c, DsType.label);
          return const SizedBox.shrink();
        }),
      ));
      expect(style.color, DsThemeData.dark.mutedForeground);
      expect(style.fontSize, DsType.label.size);
    });
  });

  group('DsFluid', () {
    testWidgets('reads the clamp against the viewport width',
        (WidgetTester t) async {
      late double display;
      late double h1;
      await t.pumpWidget(host(
        controller: DsThemeController(),
        child: Builder(builder: (BuildContext c) {
          display = DsFluid.display(c);
          h1 = DsFluid.h1(c);
          return const SizedBox.shrink();
        }),
      ));

      expect(display, DsType.displaySize(1440)); // 4.4vw of 1440 = 63.36
      expect(h1, DsType.h1Size(1440)); // 2.8vw = 40.32, clamped to 40
    });
  });
}
