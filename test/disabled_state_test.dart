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
  });
}
