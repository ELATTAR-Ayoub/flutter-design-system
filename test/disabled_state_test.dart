/// One disabled opacity, and nothing allowed to hold a second copy of it.
///
/// Eighteen components each declared a private constant for "how far a
/// disabled control fades", and they did not agree: 0.45 in Button, Input,
/// Stat and Textarea, 0.45 again on InputGroup's trailing button, 0.60 in
/// AgentComposer, 0.50 everywhere else. A disabled input beside a disabled
/// select therefore read as two different states, and nothing in the tree
/// said which was right.
///
/// Disabled is one state, so it is one number, and it lives in the foundation
/// with every other token. This suite pins the number, proves the controls a
/// reader actually meets are dimmed to it, and fails the build if a component
/// starts carrying its own copy again.
library;

import 'dart:io';

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

Widget _host(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ThemeScope(
      controller: ThemeController(mode: ColorMode.dark),
      child: Center(child: child),
    ),
  ),
);

// A real [Overlay] ancestor is required here: [Tooltip] shows its content
// through an [OverlayPortal], which asserts one exists. Routing `home`
// through [WidgetsApp] (rather than `Overlay(initialEntries: …)`, which only
// reads its entries once) keeps every rebuild live — see
// `disabled_wrapper_test.dart`'s identical host.
Widget _hostWithOverlay(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ThemeScope(
      controller: ThemeController(mode: ColorMode.dark),
      child: WidgetsApp(
        color: const Color(0xFF000000),
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
            PageRouteBuilder<T>(
              settings: settings,
              pageBuilder: (BuildContext context, Animation<double> a, Animation<double> b) => builder(context),
            ),
        home: Center(child: child),
      ),
    ),
  ),
);

/// The outermost [Opacity] a component wraps itself in when disabled.
double _dim(WidgetTester tester, Type of) => tester
    .widgetList<Opacity>(
      find.descendant(of: find.byType(of), matching: find.byType(Opacity)),
    )
    .map((Opacity o) => o.opacity)
    .firstWhere((double o) => o < 1);

void main() {
  group('the token', () {
    test('a disabled control fades to half', () {
      expect(SurfaceOpacity.disabled, 0.5);
    });

    test('the public aliases forward to it rather than restating it', () {
      // These three are API — a consumer composing its own disabled row reads
      // them — so they stay, and they agree with the token by construction.
      expect(Command.disabledOpacity, SurfaceOpacity.disabled);
      expect(FieldLabel.disabledOpacity, SurfaceOpacity.disabled);
      expect(AgentComposer.disabledInputOpacity, SurfaceOpacity.disabled);
    });

    test('no component keeps a private copy of the number', () {
      // The guard, not the convention: a new component that writes
      // `const double _disabledOpacity = 0.45` compiles and looks right, and
      // that is exactly how the corpus drifted to three different values.
      // Captures the value rather than trying to exclude it with a lookahead:
      // `\s*` backtracks to zero, so `(?!SurfaceOpacity...)` after it always
      // succeeded and the guard flagged the three correct forwarders.
      final RegExp declaration = RegExp(
        r'(?:static\s+)?const\s+double\s+\w*[Dd]isabled\w*Opacity\s*=\s*'
        r'([^;]+);',
      );
      final List<String> offenders = <String>[];
      for (final File file in Directory(
        'lib/src',
      ).listSync(recursive: true).whereType<File>()) {
        if (!file.path.endsWith('.dart')) continue;
        final List<String> lines = file.readAsStringSync().split('\n');
        for (int i = 0; i < lines.length; i++) {
          final RegExpMatch? match = declaration.firstMatch(lines[i]);
          if (match != null &&
              match.group(1)!.trim() != 'SurfaceOpacity.disabled') {
            offenders.add(
              '${file.path.replaceAll(r'\', '/')}:${i + 1}  '
              '${lines[i].trim()}',
            );
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'read SurfaceOpacity.disabled instead of restating it:\n'
            '${offenders.join('\n')}',
      );
    });
  });

  group('the controls a reader meets', () {
    testWidgets('a disabled Input dims to the token', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_host(const Input(enabled: false)));
      expect(_dim(tester, Input), SurfaceOpacity.disabled);
    });

    testWidgets('a disabled Textarea dims to the token', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_host(const Textarea(enabled: false)));
      expect(_dim(tester, Textarea), SurfaceOpacity.disabled);
    });

    testWidgets('a disabled Select dims to the token', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          Select<String>(
            enabled: false,
            value: 'a',
            onChanged: (_) {},
            options: const <SelectChild<String>>[
              SelectOption<String>(value: 'a', label: 'A'),
            ],
          ),
        ),
      );
      expect(_dim(tester, Select<String>), SurfaceOpacity.disabled);
    });

    testWidgets('a disabled Button dims to the token', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_host(const Button(child: Text('Save'))));
      await tester.pumpAndSettle();
      expect(_dim(tester, Button), closeTo(SurfaceOpacity.disabled, 0.001));
    });

    Finder tip(String s) =>
        find.byWidgetPredicate((Widget w) => w is Tooltip && w.label == s);

    testWidgets('Input, Textarea, InputOtp and InputGroup carry a reason', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_hostWithOverlay(Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Input(
            controller: TextEditingController(),
            enabled: false,
            disabledReason: 'r-input',
          ),
          Textarea(
            controller: TextEditingController(),
            enabled: false,
            disabledReason: 'r-textarea',
          ),
          InputOtp(
            maxLength: 4,
            groups: const <int>[4],
            enabled: false,
            disabledReason: 'r-otp',
          ),
          InputGroup(
            enabled: false,
            disabledReason: 'r-group',
            child: Input(controller: TextEditingController()),
          ),
        ],
      )));
      await tester.pumpAndSettle();
      for (final String s in <String>['r-input', 'r-textarea', 'r-otp', 'r-group']) {
        expect(tip(s), findsOneWidget, reason: s);
      }
      expect(_dim(tester, Textarea), SurfaceOpacity.disabled);
    });

    testWidgets('selection controls, Toggle, Slider and Stat carry a reason', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_hostWithOverlay(Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Checkbox(
            state: CheckboxState.unchecked,
            onChanged: (_) {},
            enabled: false,
            disabledReason: 'r-checkbox',
          ),
          Switch(
            value: false,
            onChanged: (_) {},
            enabled: false,
            disabledReason: 'r-switch',
          ),
          RadioGroup<int>(
            value: 1,
            onChanged: (_) {},
            children: <Widget>[
              RadioGroupItem<int>(
                value: 1,
                enabled: false,
                disabledReason: 'r-radio',
              ),
            ],
          ),
          Toggle(
            pressed: false,
            onChanged: null,
            disabledReason: 'r-toggle',
            child: const Text('t'),
          ),
          ToggleGroup(
            items: const <ToggleGroupItem>[
              ToggleGroupItem(
                label: 'a',
                enabled: false,
                disabledReason: 'r-tgi',
              ),
            ],
            selectedIndex: null,
            onChanged: (_) {},
          ),
          Slider(
            values: const <double>[0.5],
            onChanged: (_) {},
            enabled: false,
            disabledReason: 'r-slider',
          ),
          const Stat(
            label: 'x',
            value: '1',
            disabled: true,
            disabledReason: 'r-stat',
          ),
        ],
      )));
      await tester.pumpAndSettle();
      for (final String s in <String>[
        'r-checkbox',
        'r-switch',
        'r-radio',
        'r-toggle',
        'r-tgi',
        'r-slider',
        'r-stat',
      ]) {
        expect(tip(s), findsOneWidget, reason: s);
      }
    });

    testWidgets('a disabled Textarea no longer takes the tap', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(Textarea(controller: TextEditingController(), enabled: false)),
      );
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(Textarea),
          matching: find.byWidgetPredicate(
            (Widget w) => w is IgnorePointer && w.ignoring,
          ),
        ),
        findsOneWidget,
      );
    });
  });
}
