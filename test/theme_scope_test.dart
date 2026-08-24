import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The scope layer: who owns the theme, how `system` resolves, and how a
/// `.type-*` class becomes glyphs on screen.

/// The minimum ancestry `ElTheme`/`ElText` need, with the platform brightness
/// and the viewport under the test's control — the first is what `system` mode
/// follows, the second is what the `clamp()` classes measure against.
Widget host({
  required ElThemeController controller,
  required Widget child,
  Brightness platformBrightness = Brightness.dark,
  Size size = const Size(1440, 900),
}) {
  return MediaQuery(
    data: MediaQueryData(size: size, platformBrightness: platformBrightness),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ElTheme(controller: controller, child: child),
    ),
  );
}

/// Reads the resolved theme and records every build, so a test can prove that
/// a mode change actually reached a dependent rather than only the notifier.
class Probe extends StatelessWidget {
  const Probe({super.key, required this.onBuild});

  final void Function(ElThemeData theme) onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild(ElTheme.of(context));
    return const SizedBox.shrink();
  }
}

void main() {
  group('ElThemeController', () {
    test('resolves the two explicit modes without consulting the platform', () {
      final ElThemeController c = ElThemeController(mode: ElThemeMode.dark);
      expect(c.resolve(Brightness.light), ElThemeKind.dark);

      c.setMode(ElThemeMode.light);
      expect(c.resolve(Brightness.dark), ElThemeKind.light);
    });

    test('system mode follows the platform brightness', () {
      final ElThemeController c = ElThemeController(mode: ElThemeMode.system);
      expect(c.resolve(Brightness.dark), ElThemeKind.dark);
      expect(c.resolve(Brightness.light), ElThemeKind.light);
    });

    test('defaults to dark — the reference ThemeProvider does', () {
      expect(ElThemeController().mode, ElThemeMode.dark);
    });

    test('notifies once per real change, never on a no-op set', () {
      final ElThemeController c = ElThemeController();
      int notifications = 0;
      c.addListener(() => notifications++);

      c.setMode(ElThemeMode.dark); // already dark
      expect(notifications, 0);

      c.setMode(ElThemeMode.light);
      expect(notifications, 1);
    });
  });

  group('ElTheme', () {
    testWidgets('mode dark resolves ElThemeData.dark', (WidgetTester t) async {
      ElThemeData? seen;
      await t.pumpWidget(
        host(
          controller: ElThemeController(mode: ElThemeMode.dark),
          child: Probe(onBuild: (ElThemeData d) => seen = d),
        ),
      );

      expect(seen, same(ElThemeData.dark));
      expect(seen!.background, ElThemeData.dark.background);
    });

    testWidgets('setMode(light) rebuilds a dependent', (WidgetTester t) async {
      final ElThemeController controller = ElThemeController();
      final List<ElThemeKind> builds = <ElThemeKind>[];
      await t.pumpWidget(
        host(
          controller: controller,
          child: Probe(onBuild: (ElThemeData d) => builds.add(d.kind)),
        ),
      );
      expect(builds, <ElThemeKind>[ElThemeKind.dark]);

      controller.setMode(ElThemeMode.light);
      await t.pump();

      expect(builds, <ElThemeKind>[ElThemeKind.dark, ElThemeKind.light]);
    });

    testWidgets('system mode follows MediaQuery.platformBrightness', (
      WidgetTester t,
    ) async {
      final ElThemeController controller = ElThemeController(
        mode: ElThemeMode.system,
      );
      ElThemeData? seen;

      await t.pumpWidget(
        host(
          controller: controller,
          platformBrightness: Brightness.light,
          child: Probe(onBuild: (ElThemeData d) => seen = d),
        ),
      );
      expect(seen, same(ElThemeData.light));

      await t.pumpWidget(
        host(
          controller: controller,
          child: Probe(onBuild: (ElThemeData d) => seen = d),
        ),
      );
      expect(seen, same(ElThemeData.dark));
    });

    testWidgets('controllerOf and modeOf expose the live controller', (
      WidgetTester t,
    ) async {
      final ElThemeController controller = ElThemeController();
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

      expect(ElTheme.controllerOf(captured), same(controller));
      expect(ElTheme.modeOf(captured), ElThemeMode.dark);
    });
  });

  group('ElText', () {
    Future<Text> render(
      WidgetTester t,
      ElText text, {
      ElThemeMode mode = ElThemeMode.dark,
    }) async {
      await t.pumpWidget(
        host(
          controller: ElThemeController(mode: mode),
          child: text,
        ),
      );
      return t.widget<Text>(find.byType(Text));
    }

    testWidgets('uppercases when the class does', (WidgetTester t) async {
      await render(t, ElText('Remaining supply', ElType.label));
      expect(find.text('REMAINING SUPPLY'), findsOneWidget);
    });

    testWidgets('leaves a class without text-transform alone', (
      WidgetTester t,
    ) async {
      await render(t, ElText('Remaining supply', ElType.body));
      expect(find.text('Remaining supply'), findsOneWidget);
    });

    testWidgets("takes the class's own colour from the live theme", (
      WidgetTester t,
    ) async {
      final Text dark = await render(t, ElText('x', ElType.label));
      expect(dark.style!.color, ElThemeData.dark.mutedForeground);

      final Text light = await render(
        t,
        ElText('x', ElType.label),
        mode: ElThemeMode.light,
      );
      expect(light.style!.color, ElThemeData.light.mutedForeground);
    });

    testWidgets('a class with no colour of its own inherits', (
      WidgetTester t,
    ) async {
      // No DefaultTextStyle above it → the surface colour, `--foreground`.
      final Text bare = await render(t, ElText('x', ElType.body));
      expect(bare.style!.color, ElThemeData.dark.foreground);

      // Inside one → whatever that ancestor set, exactly like CSS inheritance.
      await t.pumpWidget(
        host(
          controller: ElThemeController(),
          child: DefaultTextStyle(
            style: TextStyle(color: ElThemeData.dark.actionInk),
            child: ElText('x', ElType.body),
          ),
        ),
      );
      expect(
        t.widget<Text>(find.byType(Text)).style!.color,
        ElThemeData.dark.actionInk,
      );
    });

    testWidgets('an explicit colour beats both', (WidgetTester t) async {
      final Text text = await render(
        t,
        ElText('x', ElType.label, color: ElThemeData.dark.valueInk),
      );
      expect(text.style!.color, ElThemeData.dark.valueInk);
    });

    testWidgets('renders the class metrics', (WidgetTester t) async {
      final Text text = await render(t, ElText('x', ElType.numSm));
      final TextStyle style = text.style!;
      expect(style.fontSize, ElType.numSm.size);
      expect(style.height, ElType.numSm.height);
      expect(
        style.letterSpacing,
        closeTo(ElType.numSm.tracking! * ElType.numSm.size!, 1e-9),
      );
      expect(style.fontFeatures, isNotEmpty);
    });

    testWidgets('fontSize carries the fluid classes', (WidgetTester t) async {
      final Text text = await render(
        t,
        ElText('x', ElType.display, fontSize: ElType.displaySize(1440)),
      );
      expect(text.style!.fontSize, ElType.displaySize(1440));
    });

    testWidgets('styleOf resolves the same style for spans', (
      WidgetTester t,
    ) async {
      late TextStyle style;
      await t.pumpWidget(
        host(
          controller: ElThemeController(),
          child: Builder(
            builder: (BuildContext c) {
              style = ElText.styleOf(c, ElType.label);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(style.color, ElThemeData.dark.mutedForeground);
      expect(style.fontSize, ElType.label.size);
    });
  });

  group('ElFluid', () {
    testWidgets('reads the clamp against the viewport width', (
      WidgetTester t,
    ) async {
      late double display;
      late double h1;
      await t.pumpWidget(
        host(
          controller: ElThemeController(),
          child: Builder(
            builder: (BuildContext c) {
              display = ElFluid.display(c);
              h1 = ElFluid.h1(c);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(display, ElType.displaySize(1440)); // 4.4vw of 1440 = 63.36
      expect(h1, ElType.h1Size(1440)); // 2.8vw = 40.32, clamped to 40
    });
  });
}
