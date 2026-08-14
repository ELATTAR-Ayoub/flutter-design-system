/// The spacing page's contract: the specimens *are* the values they name, and
/// the copy ships exactly as the reference wrote it — drift included.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/pages/spacing.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The `<code>` chip [text], read back from however many slices the line
/// breaker left it in.
///
/// A chip is one [WidgetSpan] per break opportunity CSS gives it, so a chip
/// with a hyphen renders as two [DsCode]s and `find.text` no longer sees it
/// whole. Joining the slices that name the same chip returns the chip itself
/// exactly when it is on screen once and nothing was lost in the slicing.
String _chip(WidgetTester tester, String text) => tester
    .widgetList<DsCode>(find.byType(DsCode))
    .where((DsCode code) => code.chip == text)
    .map((DsCode code) => code.text)
    .join();

/// The design frame, tall enough that the whole page is laid out at once.
///
/// Width matters: `xl` (1280px) is where the elevation grid reaches four-up and
/// every `sm:` column split has fired.
const Size _desktop = Size(1440, 2400);

extension on WidgetTester {
  /// Sizes the viewport in logical pixels, so `MediaQuery` breakpoints read the
  /// numbers the CSS media queries would.
  void useViewport(Size size) {
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  }

  Future<void> pumpSpacingPage({DsThemeMode mode = DsThemeMode.dark}) async {
    useViewport(_desktop);
    await pumpWidget(
      DsTheme(
        controller: DsThemeController(mode: mode),
        child: AppRouterScope(
          router: AppRouter(),
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            // The shell's own scroll view: the page is far taller than any
            // viewport, and a `SingleChildScrollView` lays all of it out.
            home: SingleChildScrollView(child: SpacingPage()),
          ),
        ),
      ),
    );
    await pumpAndSettle();
  }
}

/// Every solid `bg-action` box on the page — which is the ten scale bars and
/// nothing else (the grid demo's cells are the same ramp at 12%).
Finder get _scaleBars => find.byWidgetPredicate(
      (Widget widget) =>
          widget is DecoratedBox &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).color == DsPalette.action,
    );

void main() {
  testWidgets('every bar is exactly the step it names', (
    WidgetTester tester,
  ) async {
    await tester.pumpSpacingPage();

    final List<Size> bars = tester
        .renderObjectList<RenderBox>(_scaleBars)
        .map((RenderBox box) => box.size)
        .toList();

    expect(
      bars.map((Size size) => size.width).toList(),
      <double>[4, 8, 12, 16, 24, 32, 40, 48, 64, 80],
      reason: 'the bar is the measure — `style={{ width: s.px }}`',
    );
    // `h-3` on all ten.
    expect(bars.map((Size size) => size.height).toSet(), <double>{ds(3)});
  });

  testWidgets('the scale table prints the px and the class for each step', (
    WidgetTester tester,
  ) async {
    await tester.pumpSpacingPage();

    for (final int n in <int>[1, 2, 3, 4, 6, 8, 10, 12, 16, 20]) {
      expect(find.text('gap-$n'), findsOneWidget);
      // `4px` … `80px`; the three that also name a radius rung show twice.
      expect(find.text('${ds(n).toInt()}px'), findsWidgets);
    }

    expect(find.text('THE ONLY SPACING RULE'), findsOneWidget);
    expect(
      find.text(
        'If a gap is not on this scale, it is wrong. There is no 18px, no 30px '
        'and no 50px anywhere in the product.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('the radius ladder shows seven rungs, the pill bare', (
    WidgetTester tester,
  ) async {
    await tester.pumpSpacingPage();

    expect(find.text('SEVEN STEPS'), findsOneWidget);
    for (final String rung in <String>[
      'rounded-sm',
      'rounded-md',
      'rounded-lg',
      'rounded-xl',
      'rounded-2xl',
      'rounded-3xl',
      'rounded-pill',
    ]) {
      expect(find.text(rung), findsOneWidget);
    }

    // The reference's own special case: every other box prints `Npx`, the pill
    // prints the number alone.
    expect(find.text('999'), findsOneWidget);
    expect(find.text('999px'), findsNothing);
    expect(find.text('${DsRadii.xl3.toInt()}px'), findsWidgets);
  });

  testWidgets('elevation names four neutral steps and two rationed glows', (
    WidgetTester tester,
  ) async {
    await tester.pumpSpacingPage();

    for (int step = 1; step <= 4; step++) {
      expect(find.text('shadow-e$step'), findsOneWidget);
      expect(find.text('--shadow-e$step'), findsOneWidget);
    }

    expect(find.text('RATIONED GLOW'), findsOneWidget);
    expect(find.text('Selected · rare · premium only'), findsOneWidget);
    expect(find.text('glow-action'), findsOneWidget);
    expect(find.text('glow-value'), findsOneWidget);
    // The caption's `<em>` clause.
    expect(
      find.textContaining('this is the thing you chose', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('this is worth something', findRichText: true),
      findsOneWidget,
    );
  });

  testWidgets('the grid demo paints twelve numbered columns', (
    WidgetTester tester,
  ) async {
    await tester.pumpSpacingPage();

    expect(find.text('12 COLUMNS · 24PX GUTTERS'), findsOneWidget);
    for (int column = 1; column <= 12; column++) {
      expect(find.text('$column'), findsOneWidget);
    }
  });

  testWidgets('the 1320px drift ships verbatim, twice', (
    WidgetTester tester,
  ) async {
    await tester.pumpSpacingPage();

    // globals.css declares `--width-page: 1200px`; the copy has said 1320 since
    // before the token existed, and says it in both sections.
    expect(
      find.textContaining('1320px', findRichText: true),
      findsNWidgets(2),
    );
    expect(DsWidths.page, isNot(1320));

    expect(find.text('--width-page'), findsOneWidget);
    expect(find.text('2xl — 1536px'), findsOneWidget);
  });

  testWidgets('the breakpoints note quotes three code chips', (
    WidgetTester tester,
  ) async {
    await tester.pumpSpacingPage();

    expect(find.text('WHY THE SCALE WAS NOT OVERRIDDEN'), findsOneWidget);
    for (final String chip in <String>['--breakpoint-xl', 'xl:', 'md:']) {
      expect(_chip(tester, chip), chip);
    }
  });

  testWidgets('the rules pair states four dos and four donts', (
    WidgetTester tester,
  ) async {
    await tester.pumpSpacingPage();

    expect(find.text('DO'), findsOneWidget);
    expect(find.text('DON’T'), findsOneWidget);
    expect(
      find.text(
        'Pick gaps from the scale — 4, 8, 12, 16, 24, 32, 40, 48, 64, 80.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        "Don't invent in-between spacing values to make something 'fit'.",
      ),
      findsOneWidget,
    );
  });

  testWidgets('the header and foot nav place the page in the group', (
    WidgetTester tester,
  ) async {
    await tester.pumpSpacingPage();

    expect(find.text('FOUNDATIONS'), findsOneWidget);
    expect(find.text('Spacing & Layout'), findsOneWidget);
    expect(
      find.text(
        'The 8-point spacing scale, radius ladder, elevation set, 12-column '
        'grid and responsive breakpoints.',
      ),
      findsOneWidget,
    );
    for (final String chip in <String>['Radius', 'Grid', 'Content width']) {
      expect(find.text(chip), findsOneWidget);
    }

    expect(find.text('PREVIOUS'), findsOneWidget);
    expect(find.text('Typography'), findsOneWidget);
    expect(find.text('NEXT'), findsOneWidget);
    expect(find.text('Shadows'), findsOneWidget);
  });
}
