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
      child: WidgetsApp(
        color: const Color(0xFF000000),
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
            PageRouteBuilder<T>(
              settings: settings,
              pageBuilder:
                  (
                    BuildContext context,
                    Animation<double> a,
                    Animation<double> b,
                  ) => builder(context),
            ),
        home: Center(child: child),
      ),
    ),
  ),
);

/// A tall page: 20 filler blocks, then the form's two fields, then a CTA.
Widget _page(Form form, {Widget? cta, ScrollController? scrollController}) =>
    _host(
      FormScope(
        form: form,
        child: ListenableBuilder(
          listenable: form,
          builder: (BuildContext context, Widget? _) => SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: <Widget>[
                for (int i = 0; i < 20; i++) const SizedBox(height: 200),
                Field(
                  key: const ValueKey<String>('email-field'),
                  label: 'Email',
                  errors: form.field<String>('email').errors,
                  focusNode: form['email'].focusNode,
                  child: Input(controller: form.text('email').controller),
                ),
                const SizedBox(height: 1200),
                Field(
                  label: 'Handle',
                  errors: form.field<String>('handle').errors,
                  focusNode: form['handle'].focusNode,
                  child: Input(controller: form.text('handle').controller),
                ),
                const SizedBox(height: 600),
                cta ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );

/// Puts the test view at the 1440x900 frame [_host]'s `MediaQuery` claims.
/// `WidgetsApp` derives its own `MediaQuery` from the test view rather than
/// an ambient one, so the centring assertion (anchored at y=450) needs the
/// real view sized to match.
void _useFrame(WidgetTester t) {
  t.view.physicalSize = const Size(1440, 900);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);
}

Form _form() => Form(
  fields: <FormFieldBase>[
    TextFormField(
      name: 'email',
      initialValue: '',
      rules: <ValidationRule<String>>[
        ValidationRule.minLength(1, 'Enter your email'),
      ],
    ),
    TextFormField(
      name: 'handle',
      initialValue: '',
      rules: <ValidationRule<String>>[
        ValidationRule.minLength(1, 'Pick a handle'),
      ],
    ),
  ],
);

void main() {
  testWidgets(
    'revealFirstError validates, centres the first invalid field and focuses it',
    (WidgetTester t) async {
      _useFrame(t);
      final Form form = _form();
      addTearDown(form.dispose);
      await t.pumpWidget(_page(form));
      expect(find.text('Enter your email'), findsNothing);

      final Future<void> reveal = form.revealFirstError();
      await t.pumpAndSettle();
      await reveal;

      expect(find.text('Enter your email'), findsOneWidget);
      expect(form['email'].focusNode.hasFocus, isTrue);
      final Rect field = t.getRect(
        find.byKey(const ValueKey<String>('email-field')),
      );
      expect((field.center.dy - 450).abs(), lessThan(field.height));
    },
  );

  testWidgets('revealFirstError with nothing invalid does nothing', (
    WidgetTester t,
  ) async {
    _useFrame(t);
    final Form form = _form();
    addTearDown(form.dispose);
    form.text('email').controller.text = 'a@b.c';
    form.text('handle').controller.text = 'ab';
    final ScrollController scroll = ScrollController();
    addTearDown(scroll.dispose);
    await t.pumpWidget(_page(form, scrollController: scroll));
    final double before = scroll.position.pixels;
    final Future<void> reveal = form.revealFirstError();
    await t.pumpAndSettle();
    await reveal;
    expect(scroll.position.pixels, before);
  });

  testWidgets('a failed submit also scrolls', (WidgetTester t) async {
    _useFrame(t);
    final Form form = _form();
    addTearDown(form.dispose);
    final ScrollController scroll = ScrollController();
    addTearDown(scroll.dispose);
    await t.pumpWidget(_page(form, scrollController: scroll));
    final Future<bool> submitted = form.submit();
    await t.pumpAndSettle();
    expect(await submitted, isFalse);
    expect(scroll.position.pixels, greaterThan(0));
  });

  testWidgets('FormScope.maybeOf finds the form', (WidgetTester t) async {
    final Form form = _form();
    addTearDown(form.dispose);
    Form? seen;
    await t.pumpWidget(
      _host(
        FormScope(
          form: form,
          child: Builder(
            builder: (BuildContext c) {
              seen = FormScope.maybeOf(c);
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    expect(identical(seen, form), isTrue);
  });

  testWidgets(
    'a disabled Button inside FormScope reveals the first error on tap',
    (WidgetTester t) async {
      final Form form = _form();
      addTearDown(form.dispose);
      await t.pumpWidget(
        _page(form, cta: const Button(onPressed: null, child: Text('Submit'))),
      );
      await t.ensureVisible(find.text('Submit'));
      await t.pumpAndSettle();
      await t.tap(find.text('Submit'), warnIfMissed: false);
      await t.pumpAndSettle();
      expect(find.text('Enter your email'), findsOneWidget);
      expect(form['email'].focusNode.hasFocus, isTrue);
    },
  );

  testWidgets('onDisabledPressed wins over the FormScope default', (
    WidgetTester t,
  ) async {
    final Form form = _form();
    addTearDown(form.dispose);
    int hits = 0;
    await t.pumpWidget(
      _page(
        form,
        cta: Button(
          onPressed: null,
          onDisabledPressed: () => hits++,
          child: const Text('Submit'),
        ),
      ),
    );
    await t.ensureVisible(find.text('Submit'));
    await t.pumpAndSettle();
    await t.tap(find.text('Submit'), warnIfMissed: false);
    await t.pumpAndSettle();
    expect(hits, 1);
    expect(find.text('Enter your email'), findsNothing);
  });

  testWidgets('a loading Button does not reveal errors', (
    WidgetTester t,
  ) async {
    final Form form = _form();
    addTearDown(form.dispose);
    await t.pumpWidget(
      _page(
        form,
        cta: Button(
          onPressed: () {},
          loading: true,
          child: const Text('Submit'),
        ),
      ),
    );
    // Not pumpAndSettle: the spinner [loading] shows repeats forever, so
    // settling would never return. ensureVisible's own scroll animation is
    // bounded, so a fixed pump after it is enough.
    await t.ensureVisible(find.text('Submit'));
    await t.pump(const Duration(milliseconds: 500));
    await t.tap(find.text('Submit'), warnIfMissed: false);
    await t.pump();
    expect(find.text('Enter your email'), findsNothing);
  });

  testWidgets('Field.disabledReason reaches the control tooltip', (
    WidgetTester t,
  ) async {
    await t.pumpWidget(
      _host(
        Center(
          child: Field(
            label: 'Email',
            enabled: false,
            disabledReason: 'Locked after verification',
            child: Input(controller: TextEditingController()),
          ),
        ),
      ),
    );
    expect(
      find.byWidgetPredicate(
        (Widget w) => w is Tooltip && w.label == 'Locked after verification',
      ),
      findsOneWidget,
    );
  });

  testWidgets('after a reveal, fixing a field clears its message as you type', (
    WidgetTester t,
  ) async {
    final Form form = _form();
    addTearDown(form.dispose);
    await t.pumpWidget(_page(form));
    final Future<void> reveal = form.revealFirstError();
    await t.pumpAndSettle();
    await reveal;
    expect(form['email'].invalid, isTrue);

    form.text('email').controller.text = 'a@b.c';
    await t.pump();
    expect(form['email'].invalid, isFalse);

    form.reset();
    form.text('email').controller.text = '';
    await t.pump();
    // Reset restores the pre-reveal mode: no message until the next submit.
    expect(form['email'].invalid, isFalse);
  });
}
