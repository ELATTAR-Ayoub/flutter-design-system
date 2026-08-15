/// The forms page's contract: four forms that really validate, submit, fail and
/// say so; the reference's own copy, drift included; the toast queue running
/// sonner's constants; focus-on-error landing on **every** field type where the
/// reference lands on none (ruling F4); and the whole page stacking to the
/// reference's measured pristine geometry at the 1440 frame.
///
/// The geometry group pumps the **pristine** state — nothing typed, nothing
/// submitted, menus closed — because that is the state the oracle was measured
/// in (ruling B12/I8/F3). Every number in `_sectionOracle`, `_rowOracle`,
/// `_descriptionOracle` and `_composedOracle` is a **declared** box read off
/// the running reference, not a currently rendered one: the field family's
/// three line-heights are 17.875 / 19.5 / 18.571 and a renderer that quantizes
/// them up a half pixel per line is the thing these pins exist to catch. As
/// built, every anchor lands within **0.08px** of the reference, which is why
/// they hold a half-pixel band rather than the delivered pages' two.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/forms.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

const String _route = '$dsRoot/components/base/forms';

/// The behaviour frame, tall enough that the whole page is laid out at once and
/// every control is hit-testable without scrolling.
const Size _desktop = Size(1440, 6000);

/// The frame the reference is measured at, and the only width these numbers
/// mean anything at.
const Size _referenceFrame = Size(1440, 900);

/// `--width-content` — the reading column every wrap on the page follows.
const double _columnWidth = 1080;

/// `<form className="max-w-md">` — 28rem, on all four forms.
const double _measureMd = 448;

/* ── The reference's own stack, pristine ─────────────────────────────────── */

/// The reference's column height: `main` 5064.7 less `py-12` twice.
///
/// Reads back as `scrollHeight` 5129 — the column sits 112px down the document
/// (`main` at 64, plus its own 48px of top padding) and pays another 48 below.
const double _columnHeight = 4968.7;

/// Every section's top and height, **page-relative**: the live measurement's
/// document offsets less the 112px the column starts at.
///
/// `height` is the CSS border box, so it excludes `mb-20`; [_sectionBox] takes
/// the port's 80px of bottom padding back off before comparing.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'form': (top: 295.9, height: 851.3),
  'validation': (top: 1227.2, height: 778),
  'field-errors': (top: 2085.3, height: 687.7),
  'submit-states': (top: 2852.9, height: 347.5),
  'server-errors': (top: 3280.4, height: 639.7),
  'composed-fields': (top: 4000.1, height: 787.6),
};

/// Every `h-10` control row the reference gives an `id`, page-relative, in the
/// order its section builds them.
///
/// `#submit-states` is absent because it holds no fields at all — it is the one
/// section with no `Panel` and no form.
const Map<String, List<double>> _rowOracle = <String, List<double>>{
  'form': <double>[481.1, 594.4],
  'validation': <double>[1412.4, 1525.8],
  'field-errors': <double>[2250.9],
  'server-errors': <double>[3465.6],
};

/// Every `FieldDescription`, page-relative, in the order its section builds
/// them. Each is one line — 13px on `.type-small`'s 1.5.
const Map<String, List<double>> _descriptionOracle = <String, List<double>>{
  'form': <double>[529.1, 642.4],
  'validation': <double>[1460.4, 1573.8],
  'field-errors': <double>[2298.9],
  'server-errors': <double>[3513.6],
  // `bio` — the one composed field with a description.
  'composed-fields': <double>[4455.7],
};

/// `#composed-fields`, control by control. Five shapes, five heights, and the
/// reason this section is 787.6 tall rather than a stack of 40s.
const ({
  ({double top, double height}) plan,
  ({double top, double height}) radios,
  ({double top, double height}) daily,
  ({double top, double height}) weekly,
  ({double top, double height}) bio,
  ({double top, double height}) alerts,
  ({double top, double height}) terms,
}) _composedOracle = (
  plan: (top: 4185.3, height: 40),
  radios: (top: 4269.8, height: 52),
  daily: (top: 4269.8, height: 20),
  weekly: (top: 4301.8, height: 20),
  bio: (top: 4367.7, height: 80),
  alerts: (top: 4495.2, height: 24),
  terms: (top: 4539.2, height: 20),
);

/// `h-10` on every text row and on the select trigger.
final double _rowHeight = DsInput.height;

/// `FieldDescription` — 13px on `.type-small`'s 1.5.
const double _descriptionLine = 19.5;

/// `FieldError` — 13px on `text-sm`'s own 1.428571, which no `type-*` class
/// expresses.
const double _errorLine = 18.571;

/// `FieldLegend variant="label"` — `text-sm` with no `leading-*` override, so
/// it keeps the utility's ratio rather than the label's 1.375.
const double _legendLine = 18.571;

/// `section.mb-20` — 80px, which the port pays as padding inside the section's
/// own box because Flutter has no margins.
final double _sectionGap = ds(20);

/// Two logical pixels — the band the delivered pages hold on the aggregates
/// (the column, a section box), where a different Skia build's rounding has the
/// most room to accumulate.
const double _tolerance = 2;

/// Half a pixel — the band every *anchor* holds, because they all measure to
/// within 0.08 of the reference.
///
/// Tighter on purpose: a control row, a description and a composed-field box
/// are each one line box away from their neighbour, so this is the band that
/// catches a leading quantised up half a pixel per line. The aggregates above
/// keep the looser one.
const double _fineTolerance = 0.5;

/// The reference's own font binaries.
///
/// **Load-bearing, not hygiene.** Every number above is a line box; without
/// these the engine measures a fallback face and this file becomes a structure
/// test.
Future<void> _loadFont(String family, String file) async {
  final ByteData bytes = ByteData.sublistView(
    File('../assets/fonts/$file').readAsBytesSync(),
  );
  final FontLoader loader = FontLoader('packages/elattar_design_system/$family')
    ..addFont(Future<ByteData>.value(bytes));
  await loader.load();
}

extension on WidgetTester {
  void useViewport(Size size) {
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  }

  /// The page under reduced motion, with the toast host beside it.
  ///
  /// Three things this harness has to bring that the page does not:
  ///
  /// * the **body `DefaultTextStyle`** `DocsShell` installs — without it every
  ///   colour-inheriting string (a typed input value, anything Preflight leaves
  ///   at `color: inherit`) renders the framework's debug ink;
  /// * `MediaQuery(disableAnimations: true)`, **below** `MaterialApp` so the
  ///   framework's own does not win. The Pending cell's spinner is `infinite`,
  ///   so a tree holding it never comes to rest and `pumpAndSettle` would hang
  ///   rather than fail;
  /// * the toaster, mounted the way `shell.dart` mounts it — a full-size slot
  ///   in a `Stack`, never an `Overlay` entry, because an overlay entry would
  ///   not inherit the reduced-motion override above.
  Future<void> pumpFormsPage({DsThemeMode mode = DsThemeMode.light}) async {
    useViewport(_desktop);
    final DsThemeController theme = DsThemeController(mode: mode);
    final AppRouter router = AppRouter(route: _route);
    addTearDown(theme.dispose);
    addTearDown(router.dispose);
    addTearDown(docsToasts.clear);

    await pumpWidget(
      DsTheme(
        controller: theme,
        child: AppRouterScope(
          router: router,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (BuildContext context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                child: DefaultTextStyle(
                  style: DsText.styleOf(
                    context,
                    DsType.body,
                    color: DsTheme.of(context).foreground,
                  ),
                  child: Stack(
                    children: <Widget>[
                      const SingleChildScrollView(child: FormsPage()),
                      Positioned.fill(
                        child: DsToaster(controller: docsToasts),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // One frame to build, one to let every zero-duration transition land.
    await pump();
    await pump(const Duration(milliseconds: 300));
  }

  /// Unmounts the tree so the toast host cancels its lifetime clocks.
  ///
  /// `DsToaster` runs a 4000ms `Timer` per visible toast and a 200ms one per
  /// leaving toast, and cancels both in `dispose` — which only runs if
  /// something takes the tree down.
  Future<void> teardownTree() => pumpWidget(const SizedBox.shrink());
}

/// The page inside the real [DocsShell] at the reference frame, and the reading
/// column's own [RenderBox] — the origin every oracle number is measured from.
///
/// `main.dart` is the supervisor's at integration, so the page is handed to the
/// shell directly rather than looked up through `pageFor`.
Future<RenderBox> pumpFormsInShell(
  WidgetTester tester, {
  DsThemeMode mode = DsThemeMode.light,
}) async {
  tester.view.physicalSize = _referenceFrame;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final DsThemeController theme = DsThemeController(mode: mode);
  final AppRouter router = AppRouter(route: _route);
  addTearDown(theme.dispose);
  addTearDown(router.dispose);
  addTearDown(docsToasts.clear);

  const Widget page = FormsPage();
  await tester.pumpWidget(
    DsTheme(
      controller: theme,
      child: AppRouterScope(
        router: router,
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: DocsShell(route: _route, child: page),
        ),
      ),
    ),
  );
  // No settle: the Pending cell's spinner never comes to rest, and geometry is
  // settled on the first laid-out frame. PRISTINE — nothing typed, nothing
  // submitted, no menu open, which is the state the oracle was measured in.
  await tester.pump();

  return tester.renderObject<RenderBox>(find.byWidget(page));
}

/* ── Finders ─────────────────────────────────────────────────────────────── */

Finder _section(String id) => find.byWidgetPredicate(
      (Widget widget) => widget is DsSection && widget.id == id,
    );

Finder _in(String id, Finder matching) =>
    find.descendant(of: _section(id), matching: matching);

/// The `DsField` labelled [label] inside section [id].
Finder _field(String id, String label) => _in(
      id,
      find.byWidgetPredicate(
        (Widget widget) => widget is DsField && widget.label == label,
      ),
    );

/// The text-editing surface of the field labelled [label] in section [id].
Finder _editable(String id, String label) =>
    find.descendant(of: _field(id, label), matching: find.byType(EditableText));

/// The section's `DsPanel`, or nothing where the section has none.
Finder _panel(String id) => _in(id, find.byType(DsPanel));

({double top, double height}) _boxIn(
  WidgetTester tester,
  RenderBox origin,
  Finder finder,
) {
  final RenderBox box = tester.renderObject<RenderBox>(finder);
  return (
    top: box.localToGlobal(Offset.zero, ancestor: origin).dy,
    height: box.size.height,
  );
}

/// The section with [id] in [origin]'s coordinates, with `mb-20` taken back off
/// its height so the number compares to the reference's CSS border box.
({double top, double height}) _sectionBox(
  WidgetTester tester,
  RenderBox origin,
  String id,
) {
  final ({double top, double height}) box = _boxIn(tester, origin, _section(id));
  return (top: box.top, height: box.height - _sectionGap);
}

List<double> _topsOf(WidgetTester tester, RenderBox origin, Finder finder) =>
    tester
        .renderObjectList<RenderBox>(finder)
        .map((RenderBox box) => box.localToGlobal(Offset.zero, ancestor: origin).dy)
        .toList();

/// The `DsNote` titled [title].
Finder _note(String title) => find.byWidgetPredicate(
      (Widget widget) => widget is DsNote && widget.title == title,
    );

/// Every `<code>` chip on the page, by the whole chip each slice belongs to.
Set<String> _chipNames(WidgetTester tester) => tester
    .widgetList<DsCode>(find.byType(DsCode))
    .map((DsCode code) => code.chip)
    .toSet();

/// The chip [text] inside the Note titled [title], read back from however many
/// slices the line breaker left it in.
String _chipIn(WidgetTester tester, String title, String text) => tester
    .widgetList<DsCode>(
      find.descendant(of: _note(title), matching: find.byType(DsCode)),
    )
    .where((DsCode code) => code.chip == text)
    .map((DsCode code) => code.text)
    .join();

/// Every message a `DsFieldError` in section [id] is currently rendering.
List<String> _messages(WidgetTester tester, String id) => tester
    .widgetList<DsFieldError>(_in(id, find.byType(DsFieldError)))
    .expand((DsFieldError error) => error.messages)
    .toList();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
    await _loadFont('Redaction35', 'Redaction35-Italic.ttf');
  });

  setUp(docsToasts.clear);

  /* ── Header, spine, foot nav ───────────────────────────────────────────── */

  testWidgets('the eyebrow says "Base" twice, and the chips are the six', (
    WidgetTester tester,
  ) async {
    await tester.pumpFormsPage();

    // DRIFT 1. `${group.title} · Base` where the group is already called "Base
    // Components". `.type-label` uppercases at paint; the separator is U+00B7.
    expect(find.text('BASE COMPONENTS · BASE'), findsOneWidget);
    expect(find.text('Forms'), findsOneWidget);
    expect(
      find.text(
        'Assembling inputs into something that validates, submits, fails and '
        'says so — with the accessible wiring guaranteed rather than '
        'remembered.',
      ),
      findsOneWidget,
    );

    // The six chips are exactly the six `DsSection` titles, and they are `<li>`
    // rather than links — no anchor wiring anywhere in the header.
    for (final String chip in <String>[
      'Form',
      'Validation',
      'Field errors',
      'Submit states',
      'Server errors',
      'Composed fields',
    ]) {
      expect(
        find.descendant(
          of: find.byType(DsPageHeader),
          matching: find.text(chip),
        ),
        findsOneWidget,
        reason: 'header chip "$chip"',
      );
      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is DsSection && widget.title == chip,
        ),
        findsOneWidget,
        reason: 'section heading "$chip"',
      );
    }

    expect(find.text('PREVIOUS'), findsOneWidget);
    expect(find.text('Inputs'), findsOneWidget);
    expect(find.text('NEXT'), findsOneWidget);
    expect(find.text('Selects & Pickers'), findsOneWidget);
  });

  testWidgets('six sections, and only §4 has no Panel', (
    WidgetTester tester,
  ) async {
    await tester.pumpFormsPage();

    for (final String description in <String>[
      'React Hook Form for state, Zod for the schema, and the Field family for '
          'everything you can see. form.tsx contributes no presentation at all '
          '— only ids and aria attributes.',
      'The schema is the source of truth. Zod owns what valid means; React '
          'Hook Form owns when the question gets asked.',
      'One rule fails, you get a sentence. Several fail, you get a list — the '
          'same component, deciding on its own.',
      'Every action needs two signals: the control confirms it heard you, the '
          'outcome confirms it worked.',
      'The field is valid and the submit still failed. This is the state most '
          'forms never draw, and the only one your users will actually hit.',
      // The angle brackets are a JSX string attribute, so they are text.
      'Select, RadioGroup, Textarea, Switch and Checkbox — none of them an '
          '<input>, all of them wired the same way.',
    ]) {
      expect(find.text(description), findsOneWidget, reason: description);
    }

    expect(find.byType(DsPanel), findsNWidgets(5));
    expect(_panel('submit-states'), findsNothing,
        reason: '§4 is the only section whose specimen is not on a Panel');
    expect(find.byType(DsStateGrid), findsOneWidget);

    // Panel labels, with their own punctuation: U+00B7 in §2, U+2014 in §3,
    // U+201C/U+201D in §5. Read off the widget rather than the rendered string
    // because `.type-label` uppercases at paint and the copy is authored in
    // sentence case.
    expect(
      tester
          .widgetList<DsPanel>(find.byType(DsPanel))
          .map((DsPanel panel) => panel.label),
      <String>[
        'A whole form, live',
        'mode: onSubmit · reValidateMode: onChange',
        'criteriaMode: all — type a weak password',
        'Submit “taken” to fail, anything else to succeed',
        'Five control shapes, one binding',
      ],
    );

    // All six carry a Note, in the default `action` tone.
    final List<DsNote> notes =
        tester.widgetList<DsNote>(find.byType(DsNote)).toList();
    expect(notes, hasLength(6));
    expect(notes.every((DsNote n) => n.tone == DsNoteTone.action), isTrue);
    for (final String title in <String>[
      'WHY THERE IS NO FORMITEM',
      'VALIDATE LATE, RE-VALIDATE EARLY',
      'WHAT THE WIRING ACTUALLY GUARANTEES',
      'BOTH SIGNALS, OR NEITHER COUNTS',
      'TWO PLACES, BECAUSE THEY ANSWER TWO QUESTIONS',
      'WHY FORMCONTROL IS A SLOT',
    ]) {
      expect(find.text(title), findsOneWidget, reason: 'note title "$title"');
    }

    // §1 / §2 / §5 are the only sections with a Meta; §3 the only one with a
    // DoDont.
    expect(find.byType(DsMeta), findsNWidgets(3));
    expect(_in('form', find.byType(DsMeta)), findsOneWidget);
    expect(_in('validation', find.byType(DsMeta)), findsOneWidget);
    expect(_in('server-errors', find.byType(DsMeta)), findsOneWidget);
    expect(find.byType(DsDoDont), findsOneWidget);
    expect(_in('field-errors', find.byType(DsDoDont)), findsOneWidget);
  });

  testWidgets('the Notes carry their chips and their two italics', (
    WidgetTester tester,
  ) async {
    await tester.pumpFormsPage();

    expect(
      _chipNames(tester),
      containsAll(<String>[
        'FormItem',
        'FormLabel',
        'FormDescription',
        'FormMessage',
        'field.tsx',
        'FieldError',
        'FieldLabel',
        'htmlFor',
        'aria-invalid',
        'aria-describedby',
        'role="alert"',
        'loading',
        'aria-busy',
        'setError("root.serverError")',
        'setError("handle")',
        'SelectTrigger',
        'Select',
        '<input>',
        'onValueChange',
        'onCheckedChange',
        'field',
      ]),
    );

    // A hyphenated chip is cut at every break opportunity UAX #14 gives it and
    // reads back whole, however many slices the line breaker left it in.
    expect(
      _chipIn(tester, 'What the wiring actually guarantees', 'aria-describedby'),
      'aria-describedby',
    );
    expect(
      _chipIn(
        tester,
        'Two places, because they answer two questions',
        'setError("root.serverError")',
      ),
      'setError("root.serverError")',
    );

    // U+2019 in "React Hook Form’s", and the `<em>` around "renders".
    expect(
      find.textContaining(
        'takes React Hook Form’s error shape verbatim',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect(
      find.textContaining(
        'a binding layer over one vocabulary is not that.',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect(
      find.textContaining(
        'holds what went wrong with the',
        findRichText: true,
      ),
      findsOneWidget,
    );
  });

  testWidgets('the three Metas print 5, 4 and 3 rows', (
    WidgetTester tester,
  ) async {
    await tester.pumpFormsPage();

    final List<DsMeta> metas =
        tester.widgetList<DsMeta>(find.byType(DsMeta)).toList();
    expect(metas.map((DsMeta m) => m.items.length), <int>[5, 4, 3]);

    expect(metas[0].items.first.k, 'Form');
    expect(metas[0].items.last.k, 'useFormField()');
    // The straight double quotes are the source's own.
    expect(
      (metas[1].items.first.v as TextSpan).text,
      '"onSubmit" — the default, and the right one.',
    );
    expect(metas[2].items.first.k, 'setError("root.serverError")');

    expect(
      find.text(
        'A Slot. Stamps id, aria-invalid and aria-describedby onto whatever '
        'control it wraps — input, trigger, switch or checkbox alike.',
        findRichText: true,
      ),
      findsOneWidget,
    );
  });

  testWidgets('the DoDont states three of each, curly quotes in do 2 only', (
    WidgetTester tester,
  ) async {
    await tester.pumpFormsPage();

    final DsDoDont doDont = tester.widget<DsDoDont>(find.byType(DsDoDont));
    expect(doDont.dos, hasLength(3));
    expect(doDont.donts, hasLength(3));
    expect(
      doDont.dos[1],
      'Write what to do next: “At least 10 characters.” not “Invalid.”',
    );
    // The line that names the anti-pattern in order to forbid it.
    expect(
      doDont.donts[2],
      'Paint error text with text-destructive. Only -ink carries text, and it '
      'is a different red per theme.',
    );
    expect(find.text('DO'), findsOneWidget);
    // U+2019.
    expect(find.text('DON’T'), findsOneWidget);
  });

  /* ── §1/§2 · the account form, twice ───────────────────────────────────── */

  testWidgets('both AccountForms are live and independent (ruling F9)', (
    WidgetTester tester,
  ) async {
    await tester.pumpFormsPage();

    // Four form *types*, five instances — `AccountForm` is rendered twice.
    expect(find.byType(DsFieldGroup), findsNWidgets(5));
    for (final String id in <String>['form', 'validation']) {
      expect(_field(id, 'Handle'), findsOneWidget);
      expect(_field(id, 'Email'), findsOneWidget);
    }

    // Typing into the first form leaves the second untouched: two controllers,
    // which is the whole of what `useId()` buys on the web.
    await tester.enterText(_editable('form', 'Handle'), 'ayoub_9');
    await tester.pump();

    expect(
      tester.widget<EditableText>(_editable('form', 'Handle')).controller.text,
      'ayoub_9',
    );
    expect(
      tester
          .widget<EditableText>(_editable('validation', 'Handle'))
          .controller
          .text,
      isEmpty,
    );
  });

  testWidgets('it asks nothing until submit, then on every keystroke', (
    WidgetTester tester,
  ) async {
    await tester.pumpFormsPage();

    // `mode: "onSubmit"` — an invalid value typed before the first submit says
    // nothing at all.
    await tester.enterText(_editable('form', 'Handle'), 'AB');
    await tester.pump();
    expect(_messages(tester, 'form'), isEmpty);

    await tester.tap(_in('form', find.text('Save Account')));
    await tester.pump();

    // `criteriaMode` is `firstError`, so `"AB"` raises `too_small` AND
    // `invalid_format` and renders only the first.
    expect(
      _messages(tester, 'form'),
      <String>['At least 3 characters.', 'That is not an email address.'],
    );
    // …and the second form, which was never submitted, still says nothing.
    expect(_messages(tester, 'validation'), isEmpty);

    // `reValidateMode: "onChange"` — from here every keystroke is checked.
    await tester.enterText(_editable('form', 'Handle'), 'Ayoub');
    await tester.pump();
    expect(
      _messages(tester, 'form'),
      contains('Lowercase letters, numbers and underscores only.'),
    );

    await tester.enterText(_editable('form', 'Handle'), 'ayoub_9');
    await tester.pump();
    expect(
      _messages(tester, 'form'),
      <String>['That is not an email address.'],
    );
  });

  testWidgets('the account schema renders one message per input', (
    WidgetTester tester,
  ) async {
    await tester.pumpFormsPage();

    await tester.tap(_in('form', find.text('Save Account')));
    await tester.pump();

    for (final (String typed, String want) in <(String, String)>[
      ('', 'At least 3 characters.'),
      ('ab', 'At least 3 characters.'),
      ('AB', 'At least 3 characters.'),
      ('Ayoub', 'Lowercase letters, numbers and underscores only.'),
      ('ayoub!', 'Lowercase letters, numbers and underscores only.'),
      ('aaaaaaaaaaaaaaaaaaaaa', 'No more than 20 characters.'),
    ]) {
      await tester.enterText(_editable('form', 'Handle'), typed);
      await tester.pump();
      expect(_messages(tester, 'form'), contains(want), reason: 'handle "$typed"');
    }

    await tester.enterText(_editable('form', 'Handle'), 'ayoub_9');
    await tester.pump();
    expect(
      _messages(tester, 'form'),
      isNot(contains('At least 3 characters.')),
    );

    // Zod 4's `z.email()` is stricter than HTML5's: `a@b` fails where a
    // browser's own `type="email"` accepts it.
    for (final String bad in <String>['', 'a@b', 'a b@c.dd', '.a@b.co']) {
      await tester.enterText(_editable('form', 'Email'), bad);
      await tester.pump();
      expect(
        _messages(tester, 'form'),
        contains('That is not an email address.'),
        reason: 'email "$bad"',
      );
    }
    await tester.enterText(_editable('form', 'Email'), 'you@example.com');
    await tester.pump();
    expect(_messages(tester, 'form'), isEmpty);
  });

  testWidgets('a valid submit spins for 900ms, toasts, and resets to the '
      'values it saved', (WidgetTester tester) async {
    await tester.pumpFormsPage();

    await tester.enterText(_editable('form', 'Handle'), 'ayoub_9');
    await tester.enterText(_editable('form', 'Email'), 'you@example.com');
    await tester.pump();

    await tester.tap(_in('form', find.text('Save Account')));
    await tester.pump();

    // DRIFT 2. The label swaps — the JSDoc's "the label stays in place" is
    // false here and only *looks* true because the group stretches the button.
    expect(_in('form', find.text('Saving')), findsOneWidget);
    expect(_in('form', find.text('Save Account')), findsNothing);
    expect(_in('form', find.byType(DsSpinner)), findsOneWidget);
    final DsButton pending = tester.widget<DsButton>(
      _in('form', find.byType(DsButton)),
    );
    expect(pending.loading, isTrue);
    expect(find.byType(DsToast), findsNothing, reason: 'nothing has landed yet');

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump();

    expect(find.text('Saved as @ayoub_9'), findsOneWidget);
    expect(_in('form', find.text('Save Account')), findsOneWidget);
    expect(_in('form', find.byType(DsSpinner)), findsNothing);

    // `form.reset(values)`: the values stay, the messages go, and the submit
    // history goes with them — so an invalid keystroke is silent again.
    expect(
      tester.widget<EditableText>(_editable('form', 'Handle')).controller.text,
      'ayoub_9',
    );
    await tester.enterText(_editable('form', 'Handle'), 'A');
    await tester.pump();
    expect(_messages(tester, 'form'), isEmpty,
        reason: 'a reset form is back to asking late');

    await tester.teardownTree();
  });

  /* ── §3 · the multi-error list ─────────────────────────────────────────── */

  testWidgets('the password form asks on the first keystroke and lists every '
      'unmet rule', (WidgetTester tester) async {
    await tester.pumpFormsPage();

    expect(_field('field-errors', 'New password'), findsOneWidget);
    expect(_messages(tester, 'field-errors'), isEmpty, reason: 'pristine');

    // `mode: "onChange"` — no submit needed. DRIFT 4: the section above argues
    // against exactly this.
    await tester.enterText(_editable('field-errors', 'New password'), 'a');
    await tester.pump();
    expect(_messages(tester, 'field-errors'), <String>[
      'At least 10 characters.',
      'One capital letter.',
      'One number.',
      'One symbol.',
    ]);
    // Two or more messages render as a bulleted list — the only place in the
    // corpus `FieldError`'s list branch fires.
    expect(_in('field-errors', find.text('•')), findsNWidgets(4));

    for (final (String typed, List<String> want) in <(String, List<String>)>[
      (
        'abcdefghij',
        <String>['One capital letter.', 'One number.', 'One symbol.'],
      ),
      ('Abcdefghij', <String>['One number.', 'One symbol.']),
      ('Abcdefghi1', <String>['One symbol.']),
      ('Abcdefghi1!', <String>[]),
    ]) {
      await tester.enterText(_editable('field-errors', 'New password'), typed);
      await tester.pump();
      expect(_messages(tester, 'field-errors'), want, reason: 'password "$typed"');
    }

    // One message is a bare string, not a one-item list.
    await tester.enterText(_editable('field-errors', 'New password'), 'Abcdefghi1');
    await tester.pump();
    expect(_in('field-errors', find.text('•')), findsNothing);
    expect(_in('field-errors', find.text('One symbol.')), findsOneWidget);

    // Valid renders no error node at all, rather than an empty one — the
    // anti-pattern the section's own Note names.
    await tester.enterText(
      _editable('field-errors', 'New password'),
      'Abcdefghi1!',
    );
    await tester.pump();
    expect(_in('field-errors', find.byType(DsFieldError)), findsNothing);

    await tester.tap(_in('field-errors', find.text('Set Password')));
    await tester.pump();
    expect(find.text('Password accepted'), findsOneWidget);

    // No `loading` on this button: the submit body is synchronous.
    expect(
      tester
          .widget<DsButton>(_in('field-errors', find.byType(DsButton)))
          .variant,
      DsButtonVariant.outline,
    );

    await tester.teardownTree();
  });

  /* ── §4 · submit states ────────────────────────────────────────────────── */

  testWidgets('four cells, one of them live and one-way', (
    WidgetTester tester,
  ) async {
    await tester.pumpFormsPage();

    for (final String label in <String>[
      'IDLE',
      'PENDING',
      'SUCCESS',
      'DISABLED',
    ]) {
      expect(_in('submit-states', find.text(label)), findsOneWidget);
    }
    for (final String note in <String>[
      'Nothing pending',
      'isSubmitting',
      'Outcome confirmed',
      'Nothing has changed',
    ]) {
      expect(_in('submit-states', find.text(note)), findsOneWidget);
    }
    expect(
      tester.widget<DsStateGrid>(find.byType(DsStateGrid)).cols,
      4,
      reason: '`grid-cols-2 sm:grid-cols-4` — no `lg:` step',
    );

    final List<DsButton> cells = tester
        .widgetList<DsButton>(_in('submit-states', find.byType(DsButton)))
        .toList();
    expect(cells, hasLength(4));
    // Idle: clickable with no handler, so NOT the disabled branch.
    expect(cells[0].onPressed, isNotNull);
    expect(cells[0].loading, isFalse);
    // Pending: static but animating — and `loading` implies disabled.
    expect(cells[1].loading, isTrue);
    expect(_in('submit-states', find.byType(DsSpinner)), findsOneWidget);
    // Disabled.
    expect(cells[3].onPressed, isNull);

    // Cell 3 is the one `useState` on the page outside the four forms.
    expect(cells[2].variant, DsButtonVariant.primary);
    await tester.tap(_in('submit-states', find.text('Click to save')));
    await tester.pump();

    expect(find.text('Account saved'), findsOneWidget);
    expect(_in('submit-states', find.text('Saved')), findsOneWidget);
    expect(
      tester
          .widgetList<DsButton>(_in('submit-states', find.byType(DsButton)))
          .elementAt(2)
          .variant,
      DsButtonVariant.secondary,
      reason: 'one-way: it stays Saved for the rest of the session',
    );

    await tester.teardownTree();
  });

  /* ── §5 · server errors ────────────────────────────────────────────────── */

  testWidgets('the default value fails on the server, and the two surfaces '
      'have different lifetimes', (WidgetTester tester) async {
    await tester.pumpFormsPage();

    // The field is VALID — nothing the resolver can see is wrong — and the
    // default is already `"taken"`, so the demo fails on the very first press.
    expect(
      tester
          .widget<EditableText>(_editable('server-errors', 'Claim a handle'))
          .controller
          .text,
      'taken',
    );
    expect(_in('server-errors', find.byType(DsAlert)), findsNothing);

    await tester.tap(_in('server-errors', find.text('Claim Handle')));
    await tester.pump();
    expect(_in('server-errors', find.text('Claiming')), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump();

    final DsAlert alert =
        tester.widget<DsAlert>(_in('server-errors', find.byType(DsAlert)));
    expect(alert.variant, DsAlertVariant.destructive);
    expect(alert.title, 'Could not save');
    expect(alert.description, 'That handle belongs to someone else.');
    expect(
      find.descendant(
        of: _in('server-errors', find.byType(DsAlert)),
        matching: find.byWidgetPredicate(
          (Widget w) => w is DsIcon && w.glyph == DsIconGlyph.circleX,
        ),
      ),
      findsOneWidget,
    );
    expect(_messages(tester, 'server-errors'), <String>['Already registered.']);
    expect(find.text('Could not claim that handle'), findsOneWidget);

    // DRIFT 8. One keystroke wipes the field error — re-validation runs and
    // `"taken"` still passes `min(3)` — while the Alert survives untouched.
    await tester.enterText(_editable('server-errors', 'Claim a handle'), 'takenn');
    await tester.pump();
    expect(_messages(tester, 'server-errors'), isEmpty);
    expect(_in('server-errors', find.byType(DsAlert)), findsOneWidget);

    // The next submit clears the Alert first, unconditionally.
    await tester.tap(_in('server-errors', find.text('Claim Handle')));
    await tester.pump();
    expect(_in('server-errors', find.byType(DsAlert)), findsNothing);

    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump();
    expect(find.text('Claimed @takenn'), findsOneWidget);

    await tester.teardownTree();
  });

  /* ── §6 · composed fields ──────────────────────────────────────────────── */

  testWidgets('five control shapes, one binding', (WidgetTester tester) async {
    await tester.pumpFormsPage();

    expect(_in('composed-fields', find.byType(DsSelect<String>)), findsOneWidget);
    expect(
      _in('composed-fields', find.byType(DsRadioGroupItem<String>)),
      findsNWidgets(2),
    );
    expect(_in('composed-fields', find.byType(DsTextarea)), findsOneWidget);
    expect(_in('composed-fields', find.byType(DsSwitch)), findsOneWidget);
    expect(_in('composed-fields', find.byType(DsCheckbox)), findsOneWidget);

    // The one `FieldSet` + `FieldLegend` on the page: a group of radios is a
    // fieldset with a legend, not a label with an `htmlFor`.
    expect(find.byType(DsFieldLegend), findsOneWidget);
    expect(find.text('Payout rhythm'), findsOneWidget);

    // DRIFT 20. `plan`, `payout` and `alerts` carry no description; `alerts` is
    // also the one field with no error slot at all.
    expect(
      _in('composed-fields', find.byType(DsFieldDescription)),
      findsOneWidget,
      reason: 'only `bio` has one',
    );
    expect(find.text('160 characters at most.'), findsOneWidget);

    // DRIFT 11. The trigger's `w-fit` loses to the field's `*:w-full`.
    expect(
      tester
          .widget<DsSelect<String>>(
            _in('composed-fields', find.byType(DsSelect<String>)),
          )
          .expand,
      isTrue,
    );

    // Pristine: the switch is on, the checkbox is off, nothing is chosen.
    expect(
      tester.widget<DsSwitch>(_in('composed-fields', find.byType(DsSwitch))).value,
      isTrue,
    );
    expect(
      tester
          .widget<DsCheckbox>(_in('composed-fields', find.byType(DsCheckbox)))
          .state,
      DsCheckboxState.unchecked,
    );
    expect(find.text('Choose a plan'), findsOneWidget);
  });

  testWidgets('submitting untouched fails three fields at once', (
    WidgetTester tester,
  ) async {
    await tester.pumpFormsPage();

    await tester.tap(_in('composed-fields', find.text('Save Preferences')));
    await tester.pump();

    expect(_messages(tester, 'composed-fields'), <String>[
      'Pick a plan.',
      'Pick a payout rhythm.',
      'You have to accept the terms.',
    ]);
    // `bio` is valid at 0 ≤ 160, and `alerts` cannot fail.
    expect(
      _messages(tester, 'composed-fields'),
      isNot(contains('160 characters is the ceiling.')),
    );
    expect(find.byType(DsToast), findsNothing);
  });

  testWidgets('RULING F4 — focus lands on the first invalid field whatever '
      'its shape', (WidgetTester tester) async {
    await tester.pumpFormsPage();

    // The reference focuses NOTHING here (drift 7): `plan`, `payout` and
    // `terms` are all hand-wired, so RHF finds no ref with a `.focus()` and
    // `shouldFocusError` silently does nothing. This port focuses the first
    // invalid field in registration order whatever it is, which is the one
    // divergence flagged for sign-off.
    await tester.tap(_in('composed-fields', find.text('Save Preferences')));
    await tester.pump();

    final FocusNode? onPlan = tester.binding.focusManager.primaryFocus;
    expect(onPlan?.debugLabel, 'plan');
    // …and it is the Select **trigger** that holds it — `FormControl` wraps the
    // trigger, not the Select, because the trigger is the focusable thing.
    expect(
      find.descendant(
        of: _in('composed-fields', find.byType(DsSelect<String>)),
        matching: find.byWidgetPredicate(
          (Widget w) => w is Focus && identical(w.focusNode, onPlan),
        ),
      ),
      findsOneWidget,
    );

    // Fix the first, and focus walks to the radio group — which forwards it to
    // the roving tab stop rather than parking on a container.
    await _pickPlan(tester, 'Free');
    await tester.tap(_in('composed-fields', find.text('Save Preferences')));
    await tester.pump();
    expect(_messages(tester, 'composed-fields').first, 'Pick a payout rhythm.');
    expect(
      _in('composed-fields', find.byType(DsRadioGroupItem<String>)).evaluate(),
      isNotEmpty,
    );
    expect(
      tester.binding.focusManager.primaryFocus?.debugLabel,
      'DsRadioGroupItem',
      reason: 'the group holds a skipTraversal node that forwards to an item',
    );

    // Fix the second, and it lands on the checkbox — the last field type the
    // reference cannot reach at all.
    await tester.tap(_in('composed-fields', find.text('Daily')));
    await tester.pump();
    await tester.tap(_in('composed-fields', find.text('Save Preferences')));
    await tester.pump();
    expect(_messages(tester, 'composed-fields'), <String>[
      'You have to accept the terms.',
    ]);
    expect(tester.binding.focusManager.primaryFocus?.debugLabel, 'terms');
  });

  testWidgets('every control really works, and a full form submits', (
    WidgetTester tester,
  ) async {
    await tester.pumpFormsPage();

    // The menu is CLOSED at rest (ruling F3) and opens on a tap.
    expect(find.text('Free'), findsNothing);
    await tester.tap(_in('composed-fields', find.byType(DsSelect<String>)));
    await tester.pump();
    for (final String option in <String>['Free', 'Pro', 'Vault']) {
      expect(find.text(option), findsOneWidget, reason: 'option "$option"');
    }
    await tester.tap(find.text('Pro'));
    await tester.pump();
    expect(find.text('Pro'), findsOneWidget);
    expect(find.text('Choose a plan'), findsNothing);

    // Tapping the words selects the radio: a `<label for>` pointed at a Radix
    // control forwards the click to it.
    await tester.tap(_in('composed-fields', find.text('Weekly')));
    await tester.pump();

    await tester.enterText(
      find.descendant(
        of: _in('composed-fields', find.byType(DsTextarea)),
        matching: find.byType(EditableText),
      ),
      'Opening packs since 2019.',
    );
    await tester.pump();

    // The switch starts on; tapping its label turns it off.
    await tester.tap(_in('composed-fields', find.text('Price alerts')));
    await tester.pump();
    expect(
      tester.widget<DsSwitch>(_in('composed-fields', find.byType(DsSwitch))).value,
      isFalse,
    );

    await tester.tap(_in('composed-fields', find.byType(DsCheckbox)));
    await tester.pump();
    expect(
      tester
          .widget<DsCheckbox>(_in('composed-fields', find.byType(DsCheckbox)))
          .state,
      DsCheckboxState.checked,
    );

    await tester.tap(_in('composed-fields', find.text('Save Preferences')));
    await tester.pump();
    expect(_messages(tester, 'composed-fields'), isEmpty);
    expect(find.text('Preferences saved'), findsOneWidget);

    await tester.teardownTree();
  });

  testWidgets('a bio over the ceiling is the only way `bio` fails', (
    WidgetTester tester,
  ) async {
    await tester.pumpFormsPage();

    await tester.enterText(
      find.descendant(
        of: _in('composed-fields', find.byType(DsTextarea)),
        matching: find.byType(EditableText),
      ),
      'x' * 161,
    );
    await tester.tap(_in('composed-fields', find.text('Save Preferences')));
    await tester.pump();

    expect(
      _messages(tester, 'composed-fields'),
      contains('160 characters is the ceiling.'),
    );
  });

  /* ── Toasts — sonner's own constants ───────────────────────────────────── */

  testWidgets('the toast host runs sonner\'s contract', (
    WidgetTester tester,
  ) async {
    await tester.pumpFormsPage();

    expect(DsToaster.width, 356);
    expect(DsToaster.gap, 14);
    expect(DsToaster.viewportOffset, 24);
    expect(DsToaster.visibleLimit, 3);
    expect(DsToaster.lifetime, const Duration(seconds: 4));
    expect(DsToaster.unmountDelay, const Duration(milliseconds: 200));

    // Nothing is painted until something is queued.
    expect(find.byType(DsToast), findsNothing);

    // The first is page-driven, so the glyph the page passes is under test too.
    // The rest go straight into the queue: every toast site on the page is
    // either one-way (this cell) or gated behind a valid submit, and what is
    // being measured here is the host's contract, not a form's.
    await tester.tap(_in('submit-states', find.text('Click to save')));
    await tester.pump();
    for (int i = 0; i < 3; i++) {
      docsToasts.success('Account saved', glyph: DsIconGlyph.circleCheck);
      await tester.pump();
    }
    expect(docsToasts.length, 4);
    expect(docsToasts.visibleCount, 3);
    expect(find.byType(DsToast), findsNWidgets(3));

    final RenderBox toast =
        tester.renderObject<RenderBox>(find.byType(DsToast).first);
    expect(toast.size.width, DsToaster.width);
    // `TOAST_ICONS` — success is lucide's `CircleCheck`.
    expect(
      find.descendant(
        of: find.byType(DsToast).first,
        matching: find.byWidgetPredicate(
          (Widget w) => w is DsIcon && w.glyph == DsIconGlyph.circleCheck,
        ),
      ),
      findsOneWidget,
    );

    // `TOAST_LIFETIME` 4000ms, then `TIME_BEFORE_UNMOUNT` 200ms.
    await tester.pump(const Duration(seconds: 4));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump();
    expect(docsToasts.length, lessThan(4), reason: 'the first has retired');

    docsToasts.clear();
    await tester.pump();
    expect(find.byType(DsToast), findsNothing);

    await tester.teardownTree();
  });

  testWidgets('a tap dismisses a toast', (WidgetTester tester) async {
    await tester.pumpFormsPage();

    await tester.tap(_in('submit-states', find.text('Click to save')));
    await tester.pump();
    expect(find.byType(DsToast), findsOneWidget);

    await tester.tap(find.byType(DsToast));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump();
    expect(docsToasts.length, 0);

    await tester.teardownTree();
  });

  testWidgets('the shell mounts the host as a Stack slot, not an Overlay '
      'entry', (WidgetTester tester) async {
    await pumpFormsInShell(tester);

    // Ruling F8, and the reason it is a Stack slot: the capture rig's
    // reduced-motion MediaQuery sits below MaterialApp and an Overlay entry
    // would not inherit it.
    expect(find.byType(DsToaster), findsOneWidget);
    expect(
      tester.widget<DsToaster>(find.byType(DsToaster)).controller,
      same(docsToasts),
    );
    expect(
      tester.widget<DsToaster>(find.byType(DsToaster)).position,
      DsToastPosition.bottomRight,
    );
  });

  /* ── Theme ─────────────────────────────────────────────────────────────── */

  testWidgets('dark renders the same page, re-inked', (
    WidgetTester tester,
  ) async {
    await tester.pumpFormsPage(mode: DsThemeMode.dark);

    expect(find.text('BASE COMPONENTS · BASE'), findsOneWidget);
    expect(find.byType(DsFieldGroup), findsNWidgets(5));
    expect(DsThemeData.light.destructiveInk,
        isNot(DsThemeData.dark.destructiveInk));
  });

  /* ── Geometry — pristine, at the 1440 frame ────────────────────────────── */

  group('stacks to the reference at the 1440 frame', () {
    testWidgets('the column is --width-content, and as tall as the web page', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpFormsInShell(tester);

      expect(column.size.width, _columnWidth);
      expect(
        column.size.height,
        closeTo(_columnHeight, _tolerance),
        reason: 'the reference stacks to $_columnHeight — `main` 5064.7 less '
            'its two `py-12`, which reads back as scrollHeight 5129',
      );
    });

    testWidgets('every section starts and ends where the reference does', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpFormsInShell(tester);

      for (final MapEntry<String, ({double top, double height})> want
          in _sectionOracle.entries) {
        final ({double top, double height}) got =
            _sectionBox(tester, column, want.key);
        expect(
          got.top,
          closeTo(want.value.top, _tolerance),
          reason: '#${want.key} starts at ${got.top.toStringAsFixed(2)}, '
              'the reference at ${want.value.top}',
        );
        expect(
          got.height,
          closeTo(want.value.height, _tolerance),
          reason: '#${want.key} is ${got.height.toStringAsFixed(2)} tall, '
              'the reference ${want.value.height}',
        );
      }
    });

    testWidgets('the rhythm between sections is `mb-20` and nothing else', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpFormsInShell(tester);

      final List<String> ids = _sectionOracle.keys.toList();
      for (int i = 1; i < ids.length; i++) {
        final ({double top, double height}) above =
            _sectionBox(tester, column, ids[i - 1]);
        final ({double top, double height}) below =
            _sectionBox(tester, column, ids[i]);
        expect(
          below.top - (above.top + above.height),
          closeTo(_sectionGap, _tolerance),
          reason: 'the gap between #${ids[i - 1]} and #${ids[i]}',
        );
      }
    });

    testWidgets('every text row lands where the reference puts it', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpFormsInShell(tester);

      for (final MapEntry<String, List<double>> want in _rowOracle.entries) {
        final List<RenderBox> rows = tester
            .renderObjectList<RenderBox>(_in(want.key, find.byType(DsInput)))
            .toList();
        expect(rows, hasLength(want.value.length),
            reason: '#${want.key} builds ${want.value.length} text rows');
        for (int i = 0; i < rows.length; i++) {
          final double top =
              rows[i].localToGlobal(Offset.zero, ancestor: column).dy;
          expect(
            top,
            closeTo(want.value[i], _fineTolerance),
            reason: '#${want.key} row $i starts at ${top.toStringAsFixed(2)}, '
                'the reference at ${want.value[i]}',
          );
          expect(rows[i].size.height, closeTo(_rowHeight, _fineTolerance));
        }
      }
    });

    testWidgets('every description lands where the reference puts it', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpFormsInShell(tester);

      for (final MapEntry<String, List<double>> want
          in _descriptionOracle.entries) {
        final List<double> tops = _topsOf(
          tester,
          column,
          _in(want.key, find.byType(DsFieldDescription)),
        );
        expect(tops, hasLength(want.value.length), reason: '#${want.key}');
        for (int i = 0; i < tops.length; i++) {
          expect(
            tops[i],
            closeTo(want.value[i], _fineTolerance),
            reason: '#${want.key} description $i at '
                '${tops[i].toStringAsFixed(2)}, the reference at '
                '${want.value[i]}',
          );
        }
      }

      // 13px on `.type-small`'s 1.5 — one of the family's three leadings, and
      // the one no `FieldError` shares.
      for (final RenderBox box in tester
          .renderObjectList<RenderBox>(find.byType(DsFieldDescription))) {
        expect(box.size.height, closeTo(_descriptionLine, _fineTolerance));
      }
    });

    testWidgets('#composed-fields stacks five shapes at five heights', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpFormsInShell(tester);

      void check(
        String what,
        Finder finder,
        ({double top, double height}) want,
      ) {
        final ({double top, double height}) got = _boxIn(tester, column, finder);
        expect(got.top, closeTo(want.top, _fineTolerance),
            reason: '$what starts at ${got.top.toStringAsFixed(2)}, the '
                'reference at ${want.top}');
        expect(got.height, closeTo(want.height, _fineTolerance),
            reason: '$what is ${got.height.toStringAsFixed(2)} tall, the '
                'reference ${want.height}');
      }

      const String id = 'composed-fields';
      check('the Plan trigger', _in(id, find.byType(DsSelect<String>)),
          _composedOracle.plan);
      check('the payout group', _in(id, find.byType(DsRadioGroup<String>)),
          _composedOracle.radios);
      check(
        'payout-daily',
        _in(id, find.byType(DsRadioGroupItem<String>)).first,
        _composedOracle.daily,
      );
      check(
        'payout-weekly',
        _in(id, find.byType(DsRadioGroupItem<String>)).last,
        _composedOracle.weekly,
      );
      check('the Bio textarea', _in(id, find.byType(DsTextarea)),
          _composedOracle.bio);
      check('the alerts row', _in(id, find.byType(DsSwitch)),
          _composedOracle.alerts);
      check('the terms row', _in(id, find.byType(DsCheckbox)),
          _composedOracle.terms);

      // A rendered `<legend>` is lifted out of the fieldset's anonymous content
      // box, so the fieldset's own `gap-3` never applies to it and only its
      // `mb-1.5` does: 6px, not 18.
      final ({double top, double height}) legend =
          _boxIn(tester, column, find.byType(DsFieldLegend));
      expect(legend.height, closeTo(_legendLine, _fineTolerance));
      expect(
        _composedOracle.radios.top - (legend.top + legend.height),
        closeTo(DsFieldLegend.spaceBelow, _fineTolerance),
        reason: 'the legend clears its group by `mb-1.5` alone',
      );
    });

    testWidgets('the measure is 448 on all four forms', (
      WidgetTester tester,
    ) async {
      await pumpFormsInShell(tester);

      final List<RenderBox> groups = tester
          .renderObjectList<RenderBox>(find.byType(DsFieldGroup))
          .toList();
      expect(groups, hasLength(5), reason: 'four forms, five instances');
      for (final RenderBox group in groups) {
        expect(group.size.width, _measureMd);
      }
      // The submit button stretches to the form, which is what makes the
      // Saving/Save Account swap look width-stable (drift 2).
      for (final RenderBox button in tester.renderObjectList<RenderBox>(
        find.descendant(
          of: find.byType(DsFieldGroup),
          matching: find.byType(DsButton),
        ),
      )) {
        expect(button.size.width, _measureMd);
      }
    });

    testWidgets('the foot nav collapses its own margin against `mb-20`', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpFormsInShell(tester);

      final ({double top, double height}) last =
          _sectionBox(tester, column, 'composed-fields');
      final RenderBox nav =
          tester.renderObject<RenderBox>(find.byType(DsPageFootNav));
      final double top = nav.localToGlobal(Offset.zero, ancestor: column).dy;

      expect(
        top - (last.top + last.height),
        closeTo(_sectionGap, _tolerance),
        reason: 'adjoining margins collapse to the larger of the two',
      );
      expect(top + nav.size.height, closeTo(_columnHeight, _tolerance));
    });

    testWidgets('the pristine page renders no error line at all', (
      WidgetTester tester,
    ) async {
      await pumpFormsInShell(tester);

      // Ruling F3: nothing typed, nothing submitted, menus closed — which is
      // why every number above is a measurement of the same page the browser
      // was measured on. `FieldError` returns null when valid.
      expect(find.byType(DsFieldError), findsNothing);
      expect(find.byType(DsAlert), findsNothing);
      expect(find.byType(DsToast), findsNothing);
      // The error leading is pinned here rather than measured, because nothing
      // on the pristine page renders one.
      expect(_errorLine, closeTo(13 * (1.25 / 0.875), 0.01));
    });

    testWidgets('dark stacks exactly as light does', (
      WidgetTester tester,
    ) async {
      final RenderBox dark =
          await pumpFormsInShell(tester, mode: DsThemeMode.dark);
      expect(dark.size.height, closeTo(_columnHeight, _tolerance));
    });
  });
}

/// Opens the Plan menu and takes the row labelled [option].
///
/// The menu is an `OverlayEntry`, so the row is found on the whole tree rather
/// than inside the section.
Future<void> _pickPlan(WidgetTester tester, String option) async {
  await tester.tap(_in('composed-fields', find.byType(DsSelect<String>)));
  await tester.pump();
  await tester.tap(find.text(option));
  await tester.pump();
}
