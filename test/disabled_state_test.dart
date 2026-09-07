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
import 'package:flutter/services.dart' show LogicalKeyboardKey;
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

    testWidgets('agent surfaces carry a reason', (WidgetTester tester) async {
      await tester.pumpWidget(_hostWithOverlay(Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AgentComposer(
            controller: TextEditingController(),
            onSubmit: () {},
            disabled: true,
            disabledReason: 'r-composer',
          ),
          AgentAttachMenu(
            onPickFiles: () {},
            onRunCommand: (_) {},
            disabled: true,
            disabledReason: 'r-attach',
          ),
          MicControl(
            listening: false,
            disabled: true,
            disabledReason: 'r-mic',
          ),
        ],
      )));
      await tester.pumpAndSettle();
      // At least one: the composer carries its reason on both the input and
      // the send button (both disabled controls, both explaining the same
      // thing), so more than one Tooltip sharing the text is legitimate.
      for (final String s in <String>['r-composer', 'r-attach', 'r-mic']) {
        expect(tip(s), findsWidgets, reason: s);
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

    testWidgets('Select and NativeSelect triggers carry a reason', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_hostWithOverlay(Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Select<int>(
            value: null,
            onChanged: (_) {},
            enabled: false,
            disabledReason: 'r-select',
            options: const <SelectOption<int>>[
              SelectOption<int>(value: 1, label: 'one'),
            ],
          ),
          NativeSelect<int>(
            value: null,
            onChanged: (_) {},
            enabled: false,
            disabledReason: 'r-native',
            options: const <SelectOption<int>>[
              SelectOption<int>(value: 1, label: 'one'),
            ],
          ),
        ],
      )));
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate(
          (Widget w) => w is Tooltip && w.label == 'r-select',
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (Widget w) => w is Tooltip && w.label == 'r-native',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'a disabled Select option keeps its row hittable for hover and '
      'carries a reason',
      (WidgetTester tester) async {
        await tester.pumpWidget(_hostWithOverlay(
          Select<int>(
            value: null,
            onChanged: (_) {},
            options: const <SelectOption<int>>[
              SelectOption<int>(value: 1, label: 'one'),
              SelectOption<int>(
                value: 2,
                label: 'two',
                enabled: false,
                disabledReason: 'r-opt',
              ),
            ],
          ),
        ));
        await tester.tap(find.byType(Select<int>));
        await tester.pumpAndSettle();
        final Finder wrapper = find.ancestor(
          of: find.text('two'),
          matching: find.byType(Disabled),
        );
        expect(wrapper, findsOneWidget);
        expect(tester.widget<Disabled>(wrapper).blockPointer, isFalse);
        expect(
          find.byWidgetPredicate(
            (Widget w) => w is Tooltip && w.label == 'r-opt',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'a disabled Combobox item keeps its row hittable for hover and '
      'carries a reason',
      (WidgetTester tester) async {
        await tester.pumpWidget(_hostWithOverlay(
          SizedBox(
            width: 320,
            child: Combobox<int>(
              value: null,
              onChanged: (_) {},
              items: const <ComboboxItem<int>>[
                ComboboxItem<int>(value: 1, label: 'one'),
                ComboboxItem<int>(
                  value: 2,
                  label: 'two',
                  enabled: false,
                  disabledReason: 'r-combo',
                ),
              ],
            ),
          ),
        ));
        await tester.tap(find.byType(InputGroupInput));
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pumpAndSettle();
        // Two `Disabled` ancestors are expected here: InputGroup's own
        // field-level one (always mounted, inert while the combobox itself
        // is enabled) and the row's — see `input_group.dart:305`. Only the
        // row's carries `disabled: true` and `blockPointer: false`.
        final Finder wrapper = find.ancestor(
          of: find.text('two'),
          matching: find.byType(Disabled),
        );
        final Disabled rowWrapper = tester
            .widgetList<Disabled>(wrapper)
            .singleWhere((Disabled d) => d.disabled);
        expect(rowWrapper.blockPointer, isFalse);
        expect(
          find.byWidgetPredicate(
            (Widget w) => w is Tooltip && w.label == 'r-combo',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'a disabled CommandItem keeps its row hittable for hover and '
      'carries a reason',
      (WidgetTester tester) async {
        await tester.pumpWidget(_hostWithOverlay(
          SizedBox(
            width: 320,
            height: 300,
            child: Command(
              groups: const <CommandGroup>[
                CommandGroup(
                  items: <CommandItem>[
                    CommandItem(label: 'one'),
                    CommandItem(
                      label: 'two',
                      enabled: false,
                      disabledReason: 'r-command',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
        await tester.pumpAndSettle();
        final Finder wrapper = find.ancestor(
          of: find.text('two'),
          matching: find.byType(Disabled),
        );
        expect(wrapper, findsOneWidget);
        expect(tester.widget<Disabled>(wrapper).blockPointer, isFalse);
        expect(
          find.byWidgetPredicate(
            (Widget w) => w is Tooltip && w.label == 'r-command',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'the MenuItem family keeps its rows hittable for hover and carries a '
      'reason',
      (WidgetTester tester) async {
        final FocusNode trigger = FocusNode(debugLabel: 'menu trigger');
        addTearDown(trigger.dispose);
        await tester.pumpWidget(_hostWithOverlay(
          DropdownMenu(
            trigger: Button(
              focusNode: trigger,
              onPressed: () {},
              child: const Text('Open'),
            ),
            children: const <MenuChild>[
              MenuItem(
                label: 'item',
                enabled: false,
                disabledReason: 'r-item',
              ),
              MenuCheckboxItem(
                label: 'checkbox',
                checked: false,
                enabled: false,
                disabledReason: 'r-checkbox',
              ),
              MenuSub(
                label: 'sub',
                enabled: false,
                disabledReason: 'r-sub',
                children: <MenuChild>[MenuItem(label: 'nested')],
              ),
            ],
          ),
        ));
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        for (final (String label, String reason) in <(String, String)>[
          ('item', 'r-item'),
          ('checkbox', 'r-checkbox'),
          ('sub', 'r-sub'),
        ]) {
          final Finder wrapper = find.ancestor(
            of: find.text(label),
            matching: find.byType(Disabled),
          );
          expect(wrapper, findsOneWidget, reason: label);
          expect(
            tester.widget<Disabled>(wrapper).blockPointer,
            isFalse,
            reason: label,
          );
          expect(
            find.byWidgetPredicate(
              (Widget w) => w is Tooltip && w.label == reason,
            ),
            findsOneWidget,
            reason: reason,
          );
        }
      },
    );

    testWidgets('a disabled DropdownMenu trigger carries a reason', (
      WidgetTester tester,
    ) async {
      final FocusNode trigger = FocusNode(debugLabel: 'dropdown trigger');
      addTearDown(trigger.dispose);
      await tester.pumpWidget(_hostWithOverlay(
        DropdownMenu(
          enabled: false,
          disabledReason: 'r-dropdown',
          trigger: Button(
            focusNode: trigger,
            onPressed: () {},
            child: const Text('Open'),
          ),
          children: const <MenuChild>[MenuItem(label: 'row')],
        ),
      ));
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate(
          (Widget w) => w is Tooltip && w.label == 'r-dropdown',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'a disabled DropdownMenu trigger blocks pointer events and does not '
      'invoke its callback',
      (WidgetTester tester) async {
        int taps = 0;
        await tester.pumpWidget(_hostWithOverlay(
          DropdownMenu(
            enabled: false,
            disabledReason: 'r-dd',
            trigger: Button(onPressed: () => taps++, child: const Text('open')),
            children: const <MenuChild>[MenuItem(label: 'row')],
          ),
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();
        expect(taps, 0);

        expect(
          find.byWidgetPredicate(
            (Widget w) => w is Tooltip && w.label == 'r-dd',
          ),
          findsOneWidget,
        );

        final Finder wrappers = find.ancestor(
          of: find.text('open'),
          matching: find.byType(Disabled),
        );
        expect(
          tester
              .widgetList<Disabled>(wrappers)
              .any((Disabled d) => d.disabled),
          isTrue,
          reason: 'the DropdownMenu-level Disabled wrapper should be '
              'disabled',
        );
      },
    );

    testWidgets(
      'an enabled DropdownMenu trigger still invokes its callback on tap',
      (WidgetTester tester) async {
        int taps = 0;
        await tester.pumpWidget(_hostWithOverlay(
          DropdownMenu(
            trigger: Button(onPressed: () => taps++, child: const Text('open')),
            children: const <MenuChild>[MenuItem(label: 'row')],
          ),
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();
        expect(taps, 1);
      },
    );
  });
}
