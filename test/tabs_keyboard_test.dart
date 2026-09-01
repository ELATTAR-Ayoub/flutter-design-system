/// The composite keyboard contract, tested where it is owned.
///
/// A tab list is the one place in the catalogue where the keyboard rules are
/// not a leaf's business: the set owns the focus, and the tabs inside it share
/// a single Tab stop. That makes the contract a property of `Tabs` rather than
/// of its triggers, so it is asserted against the whole set.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart' show Material, MaterialApp;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child, {TextDirection direction = TextDirection.ltr}) =>
    ThemeScope(
      controller: ThemeController(mode: ColorMode.dark),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: direction,
          child: Builder(
            builder: (BuildContext context) => DefaultTextStyle(
              style: StyledText.styleOf(
                context,
                TextStyles.body,
                color: ThemeScope.of(context).foreground,
              ),
              child: Material(child: Center(child: child)),
            ),
          ),
        ),
      ),
    );

/// A live tab set that keeps the selection it is asked for.
class _Harness extends StatefulWidget {
  const _Harness();

  /// Three tabs: enough for a middle, and enough for both wraps to differ.
  static const int count = 3;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  int index = 0;

  @override
  Widget build(BuildContext context) => Tabs(
    items: <TabItem>[
      for (int i = 0; i < _Harness.count; i++)
        TabItem(label: 'Tab $i', content: Text('Panel $i')),
    ],
    selectedIndex: index,
    onChanged: (int next) => setState(() => index = next),
  );
}

Future<void> press(WidgetTester t, LogicalKeyboardKey key) async {
  await t.sendKeyEvent(key);
  await t.pumpAndSettle();
}

void main() {
  group('One Tab stop for the whole set', () {
    testWidgets('Tab lands on the tab that is showing, not on the first', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const _Harness()));
      // Arrive at the third tab the way a reader would, so the entry point
      // under test is a real selection rather than a poked field.
      await t.tap(find.text('Tab 2'));
      await t.pumpAndSettle();
      FocusManager.instance.primaryFocus?.unfocus();
      await t.pumpAndSettle();

      await press(t, LogicalKeyboardKey.tab);

      expect(FocusManager.instance.primaryFocus?.debugLabel, 'Tab Tab 2');
    });

    testWidgets('a second Tab leaves the set rather than stepping within it', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const _Harness()));
      await press(t, LogicalKeyboardKey.tab);
      expect(FocusManager.instance.primaryFocus?.debugLabel, 'Tab Tab 0');

      await press(t, LogicalKeyboardKey.tab);

      expect(
        FocusManager.instance.primaryFocus?.debugLabel,
        isNot(anyOf('Tab Tab 1', 'Tab Tab 2')),
        reason: 'three tabs are one stop, not three',
      );
    });
  });

  group('The arrows move between the tabs', () {
    testWidgets('Right moves on, and wraps at the end', (WidgetTester t) async {
      await t.pumpWidget(host(const _Harness()));
      await press(t, LogicalKeyboardKey.tab);

      await press(t, LogicalKeyboardKey.arrowRight);
      expect(find.text('Panel 1'), findsOneWidget);
      await press(t, LogicalKeyboardKey.arrowRight);
      expect(find.text('Panel 2'), findsOneWidget);
      await press(t, LogicalKeyboardKey.arrowRight);
      expect(find.text('Panel 0'), findsOneWidget);
    });

    testWidgets('Left moves back, and wraps at the start', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const _Harness()));
      await press(t, LogicalKeyboardKey.tab);

      await press(t, LogicalKeyboardKey.arrowLeft);

      expect(find.text('Panel 2'), findsOneWidget);
    });

    testWidgets('Home and End go to the ends', (WidgetTester t) async {
      await t.pumpWidget(host(const _Harness()));
      await press(t, LogicalKeyboardKey.tab);

      await press(t, LogicalKeyboardKey.end);
      expect(find.text('Panel 2'), findsOneWidget);
      await press(t, LogicalKeyboardKey.home);
      expect(find.text('Panel 0'), findsOneWidget);
    });

    testWidgets('focus travels with the selection', (WidgetTester t) async {
      await t.pumpWidget(host(const _Harness()));
      await press(t, LogicalKeyboardKey.tab);

      await press(t, LogicalKeyboardKey.arrowRight);

      expect(FocusManager.instance.primaryFocus?.debugLabel, 'Tab Tab 1');
    });

    testWidgets('right-to-left reads Right as backwards', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const _Harness(), direction: TextDirection.rtl));
      await press(t, LogicalKeyboardKey.tab);

      await press(t, LogicalKeyboardKey.arrowRight);

      expect(
        find.text('Panel 2'),
        findsOneWidget,
        reason: 'the arrow follows the reading direction, not the array',
      );
    });
  });

  group('A tab announces and measures like a tab', () {
    testWidgets('it is a selected button in a mutually exclusive group', (
      WidgetTester t,
    ) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(host(const _Harness()));

      final Iterable<Semantics> tabs = t
          .widgetList<Semantics>(find.byType(Semantics))
          .where((Semantics s) => s.properties.label == 'Tab 0');

      expect(
        tabs.any(
          (Semantics s) =>
              (s.properties.button ?? false) &&
              (s.properties.inMutuallyExclusiveGroup ?? false) &&
              (s.properties.selected ?? false),
        ),
        isTrue,
      );
      handle.dispose();
    });

    testWidgets('a 32px pill still answers a 44px finger', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const _Harness()));

      final RenderBox box = t.renderObject<RenderBox>(
        find.byType(TapTarget).first,
      );

      expect(box.size.height, Tabs.triggerHeight);
      expect(
        TapTarget.debugTarget(box).height,
        greaterThanOrEqualTo(TouchTargets.minimum),
      );
    });

    testWidgets('at 200% the pill grows rather than clipping the label', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: _Harness(),
          ),
        ),
      );

      expect(t.takeException(), isNull);
      expect(
        t.renderObject<RenderBox>(find.byType(TapTarget).first).size.height,
        greaterThan(Tabs.triggerHeight),
        reason: 'the trigger height is a floor, not a ceiling',
      );
    });
  });

  testWidgets('the focus nodes go out with the set', (WidgetTester t) async {
    await t.pumpWidget(host(const _Harness()));
    await press(t, LogicalKeyboardKey.tab);

    await t.pumpWidget(host(const SizedBox.shrink()));
    await t.pumpAndSettle();

    expect(t.takeException(), isNull);
  });
}
