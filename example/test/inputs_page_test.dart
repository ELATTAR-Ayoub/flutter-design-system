/// The inputs page's contract: every specimen is a field that really takes
/// text, the two drifted state cells are page-local paint over live controls,
/// every `type-num` on the page renders at the measured 13px rather than the
/// 15 the class declares, the copy ships as the reference wrote it — the twice
/// false opening Note included — and the page stacks to the reference's own
/// measured heights at the 1440 frame, field by field.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/inputs.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/// The design frame, tall enough that the whole page is laid out at once.
///
/// Width matters: `StateGrid cols={4}` is `grid-cols-2 sm:grid-cols-4` with no
/// `lg:` step, so 640 is the only breakpoint this page has and 1440 is well
/// past it.
const Size _desktop = Size(1440, 6000);

/// `max-w-lg` — `--container-lg`, 32rem. The measure every `FieldGroup` and the
/// composed `<form>` are cut to.
const double _measureLg = 512;

/// `max-w-40` — the Quantity and Referral groups.
final double _measure40 = ds(40);

/* ── The reference's own stack ───────────────────────────────────────────── */

/// The frame the reference is measured at, and the only width these numbers
/// mean anything at.
const Size _referenceFrame = Size(1440, 900);

/// `--width-content` — the reading column every wrap on the page follows.
const double _columnWidth = 1080;

/// The reference's own column height: `main` 5182.3 less `py-12` twice.
///
/// Reads back as `scrollHeight` 5246 — the column sits 112px down the document
/// (`main` at 64, plus its own 48px of top padding) and pays another 48 below.
const double _columnHeight = 5086.3;

/// Every section's top and height, **page-relative**: the live measurement's
/// document offsets less the 112px the column starts at.
///
/// Measured off the running reference at 1440×900, light. `height` is the CSS
/// border box, so it excludes `mb-20`; [_sectionBox] takes the port's 80px of
/// bottom padding back off before comparing.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'states': (top: 415.8, height: 386.6),
  'types': (top: 882.5, height: 1047.2),
  'textarea': (top: 2009.7, height: 450.6),
  'otp': (top: 2540.3, height: 334.3),
  'validation': (top: 2954.6, height: 618.5),
  'form': (top: 3653.1, height: 460.5),
  'api': (top: 4193.7, height: 319.3),
  'rules': (top: 4593, height: 312.3),
};

/// Every control row the reference gives an `id`, page-relative, in the order
/// the section builds them.
///
/// The section tops above would pass on a page whose fields were the right
/// total height in the wrong places; these are what say the stack inside each
/// panel is the reference's. The password field is absent because it is the one
/// field with no `id` — drift 10, and the gap in this table is its fingerprint.
const Map<String, List<double>> _controlOracle = <String, List<double>>{
  // i-text · i-email · (password) · i-search · i-num · i-phone · i-amount ·
  // i-invite · i-referral
  'types': <double>[
    1067.7,
    1181,
    -1,
    1380.3,
    1466.2,
    1579.5,
    1692.9,
    1778.8,
    1864.7,
  ],
  'textarea': <double>[2175.3, 2328.7],
  'validation': <double>[3139.7, 3252.2, 3364.6],
  'form': <double>[3838.3, 3951.7],
};

/// `h-10` on every control row on the page but the two textareas.
final double _rowHeight = DsInput.height;

/// `min-h-20` — both textarea demos hold one line and rest on the floor.
final double _textareaHeight = DsTextarea.minHeight;

/// `FieldLabel` — 13px on `leading-snug`'s 1.375.
const double _labelLine = 17.875;

/// `FieldError` — 13px on `text-sm`'s own 1.428571. The reference measures 18.6.
const double _errorLine = 18.5714;

/// `FieldDescription` — 13px on `leading-normal`'s 1.5.
const double _descriptionLine = 19.5;

/// `section.mb-20` — 80px, which the port pays as padding inside the section's
/// own box because Flutter has no margins.
final double _sectionGap = ds(20);

/// Two logical pixels — the band the delivered pages hold. Slack for the
/// sub-pixel a different Skia build might round differently, not for drift.
const double _tolerance = 2;

/// What a bare `Text` costs a line box, and the whole of this page's residual
/// against the reference.
///
/// A [DsText] wraps its paragraph in a `DsLineBox`, which is what holds the
/// engine's own line metrics to the CSS box the class declares. `field.dart`
/// builds its `FieldLabel` and `FieldError` out of a bare `Text` instead, so
/// both take the engine's rounding — **up to the next half pixel**: 17.875
/// renders 18.0 and 18.5714 renders 19.0, while `FieldDescription`'s 19.5 is
/// already on the step and is exact.
const double _lineQuantum = 0.5;

/// The accumulated ceiling that residual puts on this page: 16 labels at 0.125
/// plus 3 errors at 0.4286 — **3.29px**, which is the entire difference between
/// this column and the reference's.
///
/// Stated as a one-sided ceiling rather than an offset, so the moment
/// `field.dart` routes its label and its error through `DsLineBox` the residual
/// goes to zero and every assertion below still holds. Nothing on this page
/// contributes to it: the page's own copy is [DsText] throughout.
const double _fieldLineBoxResidual = 3.3;

/// The reference's own number, allowing the field family's line-box residual
/// above it and nothing below.
Matcher _stacksTo(double want) => inInclusiveRange(
      want - _tolerance,
      want + _tolerance + _fieldLineBoxResidual,
    );

/// The reference's own font binaries.
///
/// **Load-bearing, not hygiene.** Every number above is a line box, and without
/// these the engine measures a fallback face — the heights below become fiction
/// and this file becomes a structure test.
Future<void> _loadFont(String family, String file) async {
  final ByteData bytes = ByteData.sublistView(
    File('../assets/fonts/$file').readAsBytesSync(),
  );
  final FontLoader loader = FontLoader('packages/elattar_design_system/$family')
    ..addFont(Future<ByteData>.value(bytes));
  await loader.load();
}

extension on WidgetTester {
  /// Sizes the viewport in logical pixels, so `MediaQuery` breakpoints read the
  /// numbers the CSS media queries would.
  void useViewport(Size size) {
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  }

  /// The page as the shell mounts it, under reduced motion.
  ///
  /// `#form` mounts a premium [DsButton], whose `DsFoilValue` runs two
  /// `infinite` animations — a tree holding one of those never comes to rest,
  /// so `pumpAndSettle` would hang here rather than fail. Reduced motion routes
  /// every duration in the package through [dsAnimationDuration], so both loops
  /// are stopped before they start and what paints is the page at rest. The
  /// [MediaQuery] goes *below* [MaterialApp], which installs its own from the
  /// view and would otherwise win.
  Future<void> pumpInputsPage({DsThemeMode mode = DsThemeMode.dark}) async {
    useViewport(_desktop);
    await pumpWidget(
      DsTheme(
        controller: DsThemeController(mode: mode),
        child: AppRouterScope(
          router: AppRouter(route: '$dsRoot/components/base/inputs'),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (BuildContext context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                // `<body class="… text-foreground">`, which [DocsShell]
                // installs in the app. Load-bearing here and not hygiene: an
                // input's colour is `inherit` (Preflight) and `.type-*` classes
                // that declare none inherit it too, so without this the typed
                // values would read the framework's own fallback ink rather
                // than the token.
                child: DefaultTextStyle(
                  style: DsText.styleOf(
                    context,
                    DsType.body,
                    color: DsTheme.of(context).foreground,
                  ),
                  child: const SingleChildScrollView(child: InputsPage()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // One frame to build, one to let every zero-duration transition land on its
    // end value.
    await pump();
    await pump(const Duration(milliseconds: 300));
  }
}

/// The page inside the real [DocsShell] at the reference frame, and the reading
/// column's own [RenderBox] — the origin every number in the oracles is
/// measured from.
///
/// `main.dart` is the supervisor's at integration, so the page is handed to the
/// shell directly rather than looked up through `pageFor`.
Future<RenderBox> pumpInputsInShell(
  WidgetTester tester, {
  DsThemeMode mode = DsThemeMode.light,
}) async {
  tester.view.physicalSize = _referenceFrame;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final DsThemeController theme = DsThemeController(mode: mode);
  const String route = '$dsRoot/components/base/inputs';
  final AppRouter router = AppRouter(route: route);
  addTearDown(theme.dispose);
  addTearDown(router.dispose);

  const Widget page = InputsPage();
  await tester.pumpWidget(
    DsTheme(
      controller: theme,
      child: AppRouterScope(
        router: router,
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: DocsShell(route: route, child: page),
        ),
      ),
    ),
  );
  // No reduced-motion wrapper and no settle: the premium button's two
  // `infinite` controllers never come to rest, and geometry is settled on the
  // first laid-out frame.
  await tester.pump();

  return tester.renderObject<RenderBox>(find.byWidget(page));
}

/// The `<section id="…">` — the page's spine, and what a claim about one
/// section is scoped to. Several strings live in two sections at once: "Email"
/// and "Username" are both a `#types` label and a `#validation` label.
Finder _section(String id) => find.byWidgetPredicate(
      (Widget widget) => widget is DsSection && widget.id == id,
    );

/// The section with [id] in [origin]'s coordinates, with `mb-20` taken back off
/// its height so the number compares to the reference's CSS border box.
({double top, double height}) _sectionBox(
  WidgetTester tester,
  RenderBox origin,
  String id,
) {
  final RenderBox box = tester.renderObject<RenderBox>(_section(id));
  return (
    top: box.localToGlobal(Offset.zero, ancestor: origin).dy,
    height: box.size.height - _sectionGap,
  );
}

/// Every control **row** inside the section with [id], in DOM order.
///
/// A row is what the reference gives an `id` to: a bare `Input`, an
/// `InputGroup` or a `Textarea`. The stripped `DsInput` inside a group is
/// excluded — it is the value, not the row, and it paints nothing.
List<RenderBox> _controlsIn(WidgetTester tester, String id) =>
    tester.renderObjectList<RenderBox>(
      find.descendant(
        of: _section(id),
        matching: find.byWidgetPredicate(
          (Widget w) =>
              w is DsInputGroup ||
              w is DsTextarea ||
              (w is DsInput && !w.bare) ||
              // The page's own painted pill — `#validation` field 3 and the two
              // drifted state cells. The component's surface is stripped there,
              // so there is no `DsInput` left in a shape a finder can match:
              // what carries the row is a 40px box holding a surface directly.
              (w is SizedBox &&
                  w.height == DsInput.height &&
                  w.child is DsMachineSurface),
        ),
      ),
    ).toList();

/// The `DsStateCell` labelled [label].
Finder _cell(String label) => find.byWidgetPredicate(
      (Widget widget) => widget is DsStateCell && widget.label == label,
    );

/// Every `DsField` on the page, in DOM order.
List<DsField> _fields(WidgetTester tester) =>
    tester.widgetList<DsField>(find.byType(DsField)).toList();

/// The `<code>` chip [text], read back from however many slices the line
/// breaker left it in.
String _chip(WidgetTester tester, String text) => tester
    .widgetList<DsCode>(find.byType(DsCode))
    .where((DsCode code) => code.chip == text)
    .map((DsCode code) => code.text)
    .join();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
    await _loadFont('Redaction35', 'Redaction35-Italic.ttf');
  });

  /* ── Header and the opening Note ───────────────────────────────────────── */

  testWidgets('the eyebrow says "Base" twice, and the chips are the ten', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    // DRIFT 1. `${group.title} · Base` where the group is already called "Base
    // Components". `.type-label` uppercases at paint; the separator is U+00B7.
    expect(find.text('BASE COMPONENTS · BASE'), findsOneWidget);
    expect(find.text('Inputs'), findsOneWidget);
    expect(
      find.text(
        'Text entry in every shape the product needs, with the full validation '
        'and state matrix.',
      ),
      findsOneWidget,
    );

    for (final String chip in <String>[
      'Text Input',
      'Email Input',
      'Password Input',
      'Search Input',
      'Number Input',
      'Phone Number Input',
      'Verification Code',
      'Input Group',
      // A plain ASCII ampersand, not `&amp;` and not `＆`.
      'Field & Label',
    ]) {
      expect(find.text(chip), findsOneWidget, reason: 'header chip "$chip"');
    }
    // The one chip whose string is also a section heading further down.
    expect(find.text('Textarea'), findsNWidgets(3),
        reason: 'the chip, the section heading, and the panel label');

    expect(find.text('PREVIOUS'), findsOneWidget);
    expect(find.text('Buttons'), findsOneWidget);
    expect(find.text('NEXT'), findsOneWidget);
    expect(find.text('Forms'), findsOneWidget);
  });

  testWidgets('the opening Note is false twice and ships as written', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    // A Note title renders `--muted-foreground` in every tone, uppercased.
    expect(find.text('RESTYLED FROM STOCK'), findsOneWidget);

    final List<DsNote> notes =
        tester.widgetList<DsNote>(find.byType(DsNote)).toList();
    expect(notes, hasLength(2), reason: 'the page-level one, and #validation');
    expect(notes.first.tone, DsNoteTone.action);
    // DRIFT 17 — the first `tone="error"` in the corpus, and its ink is
    // unreachable: title and body both render muted-foreground.
    expect(notes.last.tone, DsNoteTone.error);

    // DRIFT 2 — `input.tsx` is `rounded-pill`, 999px; the 10 is `--radius`,
    // which only `input-group.tsx` reads. DRIFT 3 — every field in the family
    // is `bg-card`, not `bg-muted`.
    expect(
      find.textContaining(
        'Inputs ship from shadcn at 32px tall with a 12px radius. Both were '
        'changed: 40px and 10px, so a field sits level with a default',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect(
      find.textContaining(
        'rather than transparent, so they read as editable against a card '
        'without a heavy border.',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect(_chip(tester, 'Button'), 'Button');
    expect(_chip(tester, 'bg-muted'), 'bg-muted');
  });

  /* ── #states ───────────────────────────────────────────────────────────── */

  testWidgets('#states shows eight appearances in a four-up lattice', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    expect(find.text('States'), findsOneWidget);
    expect(
      find.text(
        'The full matrix. Every input in the product must be able to show all '
        'eight — a form that cannot express an error is not finished.',
      ),
      findsOneWidget,
    );

    expect(find.byType(DsStateGrid), findsOneWidget);
    expect(
      tester.widget<DsStateGrid>(find.byType(DsStateGrid)).cols,
      4,
      reason: '`grid-cols-2 sm:grid-cols-4` — no `lg:` step',
    );

    // Eight cells, eight labels, in the reference's own order. `.type-micro`
    // uppercases the label; `.type-caption` leaves the note in sentence case.
    for (final String label in <String>[
      'DEFAULT',
      'HOVER',
      'FOCUS',
      'FILLED',
      'ERROR',
      'SUCCESS',
      'DISABLED',
      'READ ONLY',
    ]) {
      expect(find.text(label), findsOneWidget, reason: 'cell label "$label"');
    }
    for (final String note in <String>[
      'Border strengthens',
      'Blue ring',
      // Also an `#api` key further down, which is why the note is scoped.
      'aria-invalid',
      '45% opacity',
      'Value, not editable',
    ]) {
      expect(
        find.descendant(of: _section('states'), matching: find.text(note)),
        findsOneWidget,
        reason: 'cell note "$note"',
      );
    }
    expect(
      tester.widgetList<DsStateCell>(find.byType(DsStateCell)),
      hasLength(8),
      reason: '8 cells fill two four-up rows exactly — no orphan',
    );

    // The seeded values, verbatim. `0xA71c…4F2b` carries a U+2026.
    expect(find.text('Eclipse Vault'), findsOneWidget);
    expect(find.text('not-an-email'), findsOneWidget);
    expect(find.text('0xA71c…4F2b'), findsOneWidget);
    expect(find.text('Unavailable'), findsOneWidget);
    // `collector@pulls.xyz` is the Success value *and* the Email placeholder.
    expect(find.text('collector@pulls.xyz'), findsNWidgets(2));
    // Three cells share the "Search packs" placeholder — Default, Hover, Focus.
    expect(find.text('Search packs'), findsNWidgets(3));
  });

  testWidgets('the Hover cell is the Default cell (drift 4)', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    // `className="border-input"` repeats a class the base list already carries,
    // and no member of this family declares a `hover:` rule at all — so there
    // is nothing for the port to reproduce but the identity.
    DsInput specimen(String label) => tester.widget<DsInput>(
          find.descendant(of: _cell(label), matching: find.byType(DsInput)),
        );

    final DsInput byDefault = specimen('Default');
    final DsInput hover = specimen('Hover');
    expect(hover.placeholder, byDefault.placeholder);
    expect(hover.invalid, byDefault.invalid);
    expect(hover.readOnly, byDefault.readOnly);
    expect(hover.enabled, byDefault.enabled);
    expect(hover.initialValue, byDefault.initialValue);
    expect(
      hover.bare,
      isFalse,
      reason: 'the cell paints nothing of its own — it is the component',
    );
    expect(
      tester.getSize(find.descendant(
        of: _cell('Hover'),
        matching: find.byType(DsInput),
      )),
      tester.getSize(find.descendant(
        of: _cell('Default'),
        matching: find.byType(DsInput),
      )),
    );
  });

  testWidgets('the Focus cell paints the Button ring, not the field ring', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    // DRIFT 5. `border-ring ring-3 ring-ring/50` is the *Button*'s recipe; a
    // real `:focus-visible` on this component is `border-primary/50` +
    // `ring-ring/35`. Both halves of the mistake are pinned so neither is
    // quietly reconciled with the component.
    final DsMachineSurface still = tester.widget<DsMachineSurface>(
      find.descendant(
        of: _cell('Focus'),
        matching: find.byType(DsMachineSurface),
      ),
    );
    final DsThemeData theme = DsThemeData.dark;
    expect(
      (still.border! as Border).top.color,
      theme.ring,
      reason: '`border-ring`, where the real focus border is `--primary` @ 50%',
    );
    // `DsButton.withFocusRing` prepends the ring, which is where Tailwind's
    // fixed `box-shadow` order puts `--tw-ring-shadow` — in front of the socket.
    expect(
      still.spec.layers.first.color(theme),
      theme.ring.withValues(alpha: 0.50),
      reason: '`ring-ring/50`, where the real focus ring is 35%',
    );
    // The socket is still under it: a ring is added to `shadow-pressed`, never
    // a replacement for it.
    expect(still.spec.layers.length, DsShadows.pressed.layers.length + 1);

    // And the field beneath the paint is genuinely editable.
    expect(
      tester
          .widget<DsInput>(
            find.descendant(
              of: _cell('Focus'),
              matching: find.byType(DsInput),
            ),
          )
          .bare,
      isTrue,
      reason: 'the strip list, so the cell paints the pill itself',
    );
  });

  testWidgets('the Success cell is the one green border in the family', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    final DsMachineSurface still = tester.widget<DsMachineSurface>(
      find.descendant(
        of: _cell('Success'),
        matching: find.byType(DsMachineSurface),
      ),
    );
    expect(
      (still.border! as Border).top.color,
      DsPalette.value.withValues(alpha: 0.50),
      reason: '`border-value/50` — rgba(163, 230, 53, 0.50)',
    );
    expect(
      still.spec,
      same(DsShadows.pressed),
      reason: 'no ring — the cell declares only a border',
    );
  });

  testWidgets('Read only changes the ink and nothing else', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    // `input.tsx` has no `read-only:` variant, so the whole of this cell's
    // difference is `className="text-muted-foreground"` — and an input's colour
    // is `inherit`, which is why the class arrives as an ambient style.
    final EditableText value = tester.widget<EditableText>(
      find.descendant(
        of: _cell('Read only'),
        matching: find.byType(EditableText),
      ),
    );
    expect(value.style.color, DsThemeData.dark.mutedForeground);
    expect(value.readOnly, isTrue);
    expect(value.controller.text, '0xA71c…4F2b');

    // The Filled cell, one row up, is the same component with no wrap.
    expect(
      tester
          .widget<EditableText>(
            find.descendant(
              of: _cell('Filled'),
              matching: find.byType(EditableText),
            ),
          )
          .style
          .color,
      DsThemeData.dark.foreground,
    );
  });

  /* ── #types ────────────────────────────────────────────────────────────── */

  testWidgets('#types builds nine fields, labels and descriptions verbatim', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    expect(find.text('Input types'), findsOneWidget);
    expect(
      find.text(
        'Every text-entry shape the product needs. The type attribute is not '
        'cosmetic — it drives the mobile keyboard, autofill and validation.',
      ),
      findsOneWidget,
    );
    expect(find.text('TYPES'), findsOneWidget, reason: 'the panel label');

    final List<DsField> fields = tester
        .widgetList<DsField>(
          find.descendant(of: _section('types'), matching: find.byType(DsField)),
        )
        .toList();
    expect(
      fields.map((DsField f) => f.label).toList(),
      <String>[
        'Username',
        'Email',
        'Password',
        'Search',
        'Quantity',
        'Phone number',
        'Deposit amount',
        'Invite code',
        'Referral percentage',
      ],
    );

    // Four descriptions, and the four fields that have none.
    expect(
      fields.map((DsField f) => f.description).toList(),
      <String?>[
        'Shown on live pulls and the leaderboard.',
        null,
        'Visibility toggle is a real control with an aria-pressed state, not a '
            'decorative icon.',
        null,
        'Numerical values use the shared mono foundation, even inside inputs.',
        'Country code is a separate addon so it never gets validated as part '
            'of the number.',
        null,
        null,
        null,
      ],
    );

    // Placeholders and seeds, verbatim.
    for (final String text in <String>[
      'voidwing',
      'Search packs, cards and sets',
      '555 0134 908',
      '0.00',
      'ECLIPSE-2K4A',
    ]) {
      expect(
        find.descendant(of: _section('types'), matching: find.text(text)),
        findsOneWidget,
        reason: 'placeholder "$text"',
      );
    }
    expect(find.text('packs'), findsOneWidget);
    expect(find.text('+1'), findsOneWidget);
    expect(find.text('Apply'), findsOneWidget);
    expect(find.text('USD'), findsNWidgets(2), reason: '#types and #form');
  });

  testWidgets('every mono field takes the resolved 13px spec, not type-num', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    // Ruling I7, and the one mistake worth guarding against: `DsType.numBase`
    // is 15px, and `.type-num` under a `text-sm` utility is 13. Six values and
    // three addons on this page ride the collapse.
    final List<DsInputGroupInput> values = tester
        .widgetList<DsInputGroupInput>(find.byType(DsInputGroupInput))
        .toList();
    expect(
      values.map((DsInputGroupInput v) => v.textSpec).toList(),
      <DsTypeSpec?>[
        null, // i-email
        null, // password
        null, // i-search
        DsComponentType.inputNum, // i-num
        DsComponentType.inputNum, // i-phone
        DsComponentType.inputNum, // i-amount
        DsComponentType.inputSerial, // i-invite
        DsComponentType.inputNum, // i-referral
        DsComponentType.inputNum, // v2
        DsComponentType.inputNum, // f-amount
      ],
    );
    for (final DsInputGroupInput value in values) {
      expect(
        value.textSpec,
        isNot(same(DsType.numBase)),
        reason: 'DsType.numBase renders 15px; the browser paints 13',
      );
    }
    // The three `InputGroupText` addons that carry a `.type-*` class: `+1` is
    // `type-num-sm` and the two `$`s are `type-num`, and all three collapse
    // onto the same 13px rung.
    final List<DsInputGroupText> addons = tester
        .widgetList<DsInputGroupText>(find.byType(DsInputGroupText))
        .toList();
    expect(
      addons.map((DsInputGroupText a) => (a.text, a.spec)).toList(),
      <(String, DsTypeSpec?)>[
        ('packs', null),
        ('+1', DsComponentType.inputNum),
        (r'$', DsComponentType.inputNum),
        ('USD', null),
        (r'$', DsComponentType.inputNum),
        (r'$', DsComponentType.inputNum),
        ('USD', null),
      ],
    );
    expect(DsComponentType.inputNum.size, DsComponentType.textSm.size);
    expect(DsComponentType.inputSerial.size, DsComponentType.textSm.size);
  });

  testWidgets('addon glyphs are md, addon-button glyphs are sm', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    // DRIFT 9, collapsed to an identity by `DsIcon.strokeFor`: the addon's
    // `size-4` class beats `Icon`'s 14px attributes while `strokeWidth` stays
    // computed from 14, and 48/16 and 48/14 snap to the same 2.4 rung. So the
    // cell is `md` and the drift costs no code.
    final List<DsIcon> addonGlyphs = tester
        .widgetList<DsIcon>(
          find.descendant(
            of: find.byType(DsInputGroupAddon),
            matching: find.byType(DsIcon),
          ),
        )
        .toList();
    // Six glyphs inside addons — AtSign, Lock, Eye, Search, Ticket, Percent —
    // and exactly one of them sits inside a button.
    expect(addonGlyphs, hasLength(6));
    expect(
      addonGlyphs.where((DsIcon g) => g.size == DsIconSize.md),
      hasLength(5),
    );
    expect(
      tester.widgetList<DsIcon>(
        find.descendant(
          of: find.byType(DsInputGroupButton),
          matching: find.byType(DsIcon),
        ),
      ),
      hasLength(1),
      reason: "the password toggle is the page's only addon-button glyph",
    );
    expect(
      tester
          .widget<DsIcon>(
            find.descendant(
              of: find.byType(DsInputGroupButton),
              matching: find.byType(DsIcon),
            ),
          )
          .size,
      DsIconSize.sm,
    );
    for (final DsIcon glyph in addonGlyphs) {
      expect(glyph.tone, DsIconTone.subtle, reason: 'every one is `subtle`');
    }
    // The drift collapses because both rungs snap to the same stroke.
    expect(DsIcon.strokeFor(DsIcon.pxFor(DsIconSize.md)), 2.4);
    expect(DsIcon.strokeFor(DsIcon.pxFor(DsIconSize.sm)), 2.4);
  });

  testWidgets('the password toggle is a real control with a pressed state', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    Finder glyph(DsIconGlyph want) => find.byWidgetPredicate(
          (Widget widget) => widget is DsIcon && widget.glyph == want,
        );
    EditableText secret() => tester
        .widgetList<EditableText>(find.byType(EditableText))
        .firstWhere(
          (EditableText field) =>
              field.controller.text == 'correct-horse-battery',
        );

    final Finder toggle = find.byType(DsInputGroupButton).first;
    expect(tester.widget<DsInputGroupButton>(toggle).toggled, isFalse);
    expect(tester.widget<DsInputGroupButton>(toggle).label, 'Show password');
    expect(glyph(DsIconGlyph.eye), findsOneWidget);
    expect(glyph(DsIconGlyph.eyeOff), findsNothing);
    expect(secret().obscureText, isTrue);

    await tester.tap(toggle);
    await tester.pump();

    expect(tester.widget<DsInputGroupButton>(toggle).toggled, isTrue);
    expect(tester.widget<DsInputGroupButton>(toggle).label, 'Hide password');
    expect(glyph(DsIconGlyph.eyeOff), findsOneWidget);
    expect(glyph(DsIconGlyph.eye), findsNothing);
    expect(secret().obscureText, isFalse);
  });

  testWidgets('the password label is bound to nothing (drift 10)', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    // `<FieldLabel>Password</FieldLabel>` carries no `htmlFor`; the control is
    // named by `aria-label` instead, so clicking the label does nothing — while
    // Do #1 on the same page says "Label every field visibly". Reproduced by
    // withholding the focus node every other labelled field is given.
    final List<DsField> types = tester
        .widgetList<DsField>(
          find.descendant(of: _section('types'), matching: find.byType(DsField)),
        )
        .toList();
    for (final DsField field in types) {
      expect(
        field.focusNode == null,
        field.label == 'Password',
        reason: '"${field.label}" — 7 of the 9 carry `htmlFor`',
      );
    }
  });

  /* ── #textarea ─────────────────────────────────────────────────────────── */

  testWidgets('#textarea builds two demos on the radius ladder', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    expect(find.text('Textarea'), findsNWidgets(3));
    expect(
      find.text(
        'Auto-grows with content via field-sizing. Used for shipping notes and '
        'support messages.',
      ),
      findsOneWidget,
    );

    expect(find.byType(DsTextarea), findsNWidgets(2));
    expect(find.text('Shipping note'), findsOneWidget);
    expect(find.text('Anything the packing team should know'), findsOneWidget);
    expect(find.text('Grows as you type. Minimum height is 80px.'),
        findsOneWidget);
    expect(find.text('With an error'), findsOneWidget);
    expect(find.text('Too short'), findsOneWidget);
    expect(
      find.text('Please provide at least 20 characters.'),
      findsOneWidget,
    );

    // The family's only member on the radius ladder: everything else here is
    // `rounded-pill`, and half of an 80px pill would swallow the first line.
    final DsMachineSurface surface = tester.widget<DsMachineSurface>(
      find.descendant(
        of: find.byType(DsTextarea).first,
        matching: find.byType(DsMachineSurface),
      ),
    );
    expect(surface.radius, BorderRadius.circular(DsRadii.lg));
  });

  /* ── #otp ──────────────────────────────────────────────────────────────── */

  testWidgets('#otp builds two 208px strips, both static at rest', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    // The nav registry spells the chip "Verification Code" and `.type-label`
    // uppercases the panel label, so the sentence-case string is the heading
    // alone — three renderings of one name, no two of them the same string.
    expect(find.text('Verification code'), findsOneWidget);
    expect(find.text('Verification Code'), findsOneWidget, reason: 'the chip');
    expect(find.text('VERIFICATION CODE'), findsOneWidget, reason: 'the panel');
    // DRIFT 13 lives in this sentence — the slots are `text-sm` Inter.
    expect(
      find.text(
        'Email verification and two-factor authentication. Six digits, grouped '
        'three and three, using the numerical mono foundation.',
      ),
      findsOneWidget,
    );
    // `.type-label` uppercases both demo labels at paint.
    expect(find.text('EMPTY'), findsOneWidget);
    expect(find.text('PARTIALLY FILLED'), findsOneWidget);

    final List<DsInputOtp> strips =
        tester.widgetList<DsInputOtp>(find.byType(DsInputOtp)).toList();
    expect(strips, hasLength(2));
    expect(strips.first.initialValue, isNull);
    expect(strips.last.initialValue, '4082');
    for (final DsInputOtp strip in strips) {
      expect(strip.maxLength, 6);
      expect(strip.groups, <int>[3, 3]);
    }

    // 96 + 16 + 96. Borders live inside the 32px slot boxes, so a group is
    // exactly its slot count times 32.
    expect(DsInputOtp.widthFor(const <int>[3, 3]), 208);
    for (final Size size
        in tester.widgetList<DsInputOtp>(find.byType(DsInputOtp)).map(
              (DsInputOtp strip) =>
                  tester.getSize(find.byWidget(strip)),
            )) {
      expect(size, Size(208, DsInputOtp.slotSize));
    }

    // DRIFT 16 — the active ring and the caret are focus-only and nothing
    // autofocuses, so twelve slots paint and none of them is active.
    final List<DsInputOtpSlot> slots =
        tester.widgetList<DsInputOtpSlot>(find.byType(DsInputOtpSlot)).toList();
    expect(slots, hasLength(12));
    expect(slots.every((DsInputOtpSlot slot) => !slot.active), isTrue);
    expect(slots.every((DsInputOtpSlot slot) => !slot.showsCaret), isTrue);
    // The seeded four, and eight empties.
    expect(
      slots.map((DsInputOtpSlot slot) => slot.char).toList(),
      <String?>[
        null, null, null, null, null, null, //
        '4', '0', '8', '2', null, null,
      ],
    );
  });

  /* ── #validation ───────────────────────────────────────────────────────── */

  testWidgets('#validation says what is wrong and what to do about it', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    expect(find.text('Validation messages'), findsOneWidget);
    expect(
      find.text(
        'An error must say what is wrong and what to do about it. Errors '
        'appear below the field, never as a tooltip, and never only as a red '
        'border.',
      ),
      findsOneWidget,
    );
    // The page's Field & Label chapter; there is no section by that name.
    expect(find.text('FIELD ANATOMY'), findsOneWidget);

    expect(find.text('Withdrawal amount'), findsOneWidget);
    expect(find.text('collector@pulls'), findsOneWidget);
    expect(find.text('2,400.00'), findsOneWidget);
    expect(find.text('voidwing'), findsNWidgets(2),
        reason: 'the #types placeholder and this seeded value');
    expect(
      find.text('That address is missing a domain. Try collector@pulls.xyz.'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Exceeds your available balance of \$1,204.80. Bonus balance cannot be '
        'withdrawn.',
      ),
      findsOneWidget,
    );
    expect(find.text('Available.'), findsOneWidget);

    // The one description on the page that overrides `--muted-foreground`.
    expect(
      tester.widget<DsText>(
        find.ancestor(
          of: find.text('Available.'),
          matching: find.byType(DsText),
        ),
      ).color,
      DsThemeData.dark.valueInk,
    );

    // The closing Note, whose tone reaches the border and the wash and nothing
    // else (drift 17).
    expect(find.text('NEVER COLOUR ALONE'), findsOneWidget);
    expect(_chip(tester, 'aria-invalid'), 'aria-invalid');
    expect(_chip(tester, 'aria-describedby'), 'aria-describedby');
    expect(
      find.textContaining(
        'A red border on its own is invisible to a colour-blind user.',
        findRichText: true,
      ),
      findsOneWidget,
    );
  });

  testWidgets('no Field on the page is invalid — only its control is', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    // DRIFT 11. `fieldVariants` keys off `data-[invalid=true]`, which this page
    // never sets — it puts `aria-invalid` on the control instead. So no label
    // here ever turns red, despite the `#api` row claiming Field "handles the
    // invalid colouring for the whole group".
    for (final DsField field in _fields(tester)) {
      expect(
        field.invalid,
        isFalse,
        reason: '"${field.label}" must leave its label `--foreground`',
      );
    }
    // …and the three controls that *are* marked really carry it. The scope is
    // what `aria-invalid` becomes: three controls sit under one that says
    // invalid while the field above it says valid.
    final List<DsFieldScope> scopes = tester
        .widgetList<DsFieldScope>(find.byType(DsFieldScope))
        .where((DsFieldScope scope) => scope.invalid)
        .toList();
    expect(
      scopes,
      hasLength(3),
      reason: 'the errored textarea, and #validation fields 1 and 2',
    );
  });

  /* ── #form ─────────────────────────────────────────────────────────────── */

  testWidgets('#form assembles two fields, a rule and two buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    expect(find.text('A complete form'), findsOneWidget);
    expect(
      find.text(
        'Everything assembled: labels above fields, 20px between fields, '
        'description under the field it describes, and the primary action '
        'separated by a rule.',
      ),
      findsOneWidget,
    );
    expect(find.text('DEPOSIT FUNDS'), findsOneWidget, reason: 'panel label');

    expect(find.text('Amount'), findsOneWidget);
    expect(
      find.text('Minimum \$10.00. Deposits clear instantly.'),
      findsOneWidget,
    );
    expect(find.text('Promo code'), findsOneWidget);
    expect(find.text('Optional'), findsOneWidget);

    final List<DsButton> buttons = tester
        .widgetList<DsButton>(
          find.descendant(of: _section('form'), matching: find.byType(DsButton)),
        )
        .toList();
    expect(
      buttons.map((DsButton b) => b.variant).toList(),
      <DsButtonVariant>[DsButtonVariant.premium, DsButtonVariant.ghost],
    );
    for (final DsButton button in buttons) {
      expect(button.size, DsButtonSize.md);
      expect(button.emphasis, DsButtonEmphasis.none);
      expect(button.onPressed, isNotNull);
    }
    expect(find.text('Deposit Funds'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  /* ── #api and #rules ───────────────────────────────────────────────────── */

  testWidgets('#api prints six rows, two of them repeating the Note', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    expect(find.text('API'), findsOneWidget);
    expect(
      tester.widget<DsSection>(_section('api')).description,
      isNull,
    );

    for (final String key in <String>[
      'Input',
      'Textarea',
      'InputGroup',
      'Field',
      'InputOTP',
      'aria-invalid',
    ]) {
      expect(
        find.descendant(of: _section('api'), matching: find.text(key)),
        findsOneWidget,
        reason: 'api key "$key"',
      );
    }
    // DRIFT 3 restated: "bg-muted fill" against a family that is `bg-card`,
    // and DRIFT 2 restated: "10px radius" against `rounded-pill`.
    expect(
      find.text(
        'Native input props. 40px tall, 10px radius, bg-muted fill. Set type '
        'for the right keyboard and autofill.',
      ),
      findsOneWidget,
    );
    // Escaped straight double quotes in the source, and a literal spaced pipe.
    expect(
      find.text(
        'Wraps a control with addons. Use InputGroupAddon align="inline-start" '
        '| "inline-end".',
      ),
      findsOneWidget,
    );
    // DRIFT 11 restated as an API promise the page never keeps.
    expect(
      find.text(
        'Field + FieldLabel + FieldDescription + FieldError. Handles the '
        'invalid colouring for the whole group.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('#rules states five of each — the first page in the corpus to', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    expect(find.text('Rules'), findsOneWidget);
    expect(tester.widget<DsSection>(_section('rules')).description, isNull);
    expect(find.text('DO'), findsOneWidget);
    // `Don&rsquo;t` — the heading is the only curly apostrophe in the pair.
    expect(find.text('DON’T'), findsOneWidget);

    final DsDoDont rules = tester.widget<DsDoDont>(find.byType(DsDoDont));
    expect(rules.dos, hasLength(5));
    expect(rules.donts, hasLength(5));

    for (final String rule in <String>[
      'Label every field visibly; placeholders disappear the moment typing '
          'starts.',
      'Use the numerical mono foundation for money and quantities, and '
          'type-serial for serial codes.',
      // U+2014 em dashes.
      'Set the right type — email, tel, number, search — so mobile keyboards '
          'and autofill work.',
      'Say what is wrong and how to fix it, and link the message with '
          'aria-describedby.',
      'Mark optional fields as optional rather than marking every required '
          'one.',
      // Straight apostrophes, as the source array has them.
      "Don't use a placeholder as the label.",
      "Don't signal an error with a red border alone.",
      "Don't show validation errors while the user is still typing their first "
          'attempt.',
      "Don't put a currency symbol inside the value; it belongs in an addon.",
      "Don't disable a submit button without saying what is missing.",
    ]) {
      expect(find.text(rule), findsOneWidget, reason: 'rule "$rule"');
    }
  });

  /* ── Live behaviour ────────────────────────────────────────────────────── */

  testWidgets('the fields really take text, and the placeholders go', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage();

    final Finder username = find.descendant(
      of: _section('types'),
      matching: find.byType(EditableText),
    );
    await tester.enterText(username.first, 'ex');
    await tester.pump();

    expect(
      tester.widget<EditableText>(username.first).controller.text,
      'ex',
    );
    expect(
      find.text('voidwing'),
      findsOneWidget,
      reason: 'the placeholder goes; the #validation seed of the same string '
          'stays',
    );
  });

  testWidgets('light renders the same page, re-inked', (
    WidgetTester tester,
  ) async {
    await tester.pumpInputsPage(mode: DsThemeMode.light);

    expect(tester.takeException(), isNull);
    expect(find.byType(DsStateCell), findsNWidgets(8));
    expect(find.byType(DsInputGroup), findsNWidgets(10));
    expect(find.byType(DsTextarea), findsNWidgets(2));
    expect(find.byType(DsInputOtp), findsNWidgets(2));
    expect(find.text('RESTYLED FROM STOCK'), findsOneWidget);

    // …and the ink really did flip.
    expect(
      tester.widget<DsText>(
        find.ancestor(
          of: find.text('Available.'),
          matching: find.byType(DsText),
        ),
      ).color,
      DsThemeData.light.valueInk,
    );
    expect(DsThemeData.light.valueInk, isNot(DsThemeData.dark.valueInk));
  });

  /* ── Geometry ──────────────────────────────────────────────────────────── */

  group('stacks to the reference at the 1440 frame', () {
    testWidgets('the column is --width-content, and as tall as the web page', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpInputsInShell(tester);

      expect(
        column.size.width,
        _columnWidth,
        reason: 'every wrap on the page follows the column',
      );
      expect(
        column.size.height,
        _stacksTo(_columnHeight),
        reason: 'the reference stacks to $_columnHeight — `main` 5182.3 less '
            'its two `py-12`, which reads back as scrollHeight 5246',
      );
    });

    testWidgets('every section starts and ends where the reference does', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpInputsInShell(tester);

      for (final MapEntry<String, ({double top, double height})> want
          in _sectionOracle.entries) {
        final ({double top, double height}) got =
            _sectionBox(tester, column, want.key);
        expect(
          got.top,
          _stacksTo(want.value.top),
          reason: '#${want.key} starts at ${got.top.toStringAsFixed(2)}, '
              'the reference at ${want.value.top}',
        );
        // Heights stay on the tight band: no section on this page carries
        // enough field labels for the residual to reach 2px inside one box.
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
      final RenderBox column = await pumpInputsInShell(tester);

      // Stated separately from the tops above because it is the one failure
      // that reads as every section after it having moved.
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

    testWidgets('every control row lands where the reference puts it', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpInputsInShell(tester);

      for (final MapEntry<String, List<double>> want
          in _controlOracle.entries) {
        final List<RenderBox> rows = _controlsIn(tester, want.key);
        expect(
          rows,
          hasLength(want.value.length),
          reason: '#${want.key} builds ${want.value.length} control rows',
        );
        for (int i = 0; i < rows.length; i++) {
          // −1 marks the one row the reference gives no `id`: the password
          // field, drift 10.
          if (want.value[i] < 0) continue;
          final double top =
              rows[i].localToGlobal(Offset.zero, ancestor: column).dy;
          expect(
            top,
            _stacksTo(want.value[i]),
            reason: '#${want.key} row $i starts at ${top.toStringAsFixed(2)}, '
                'the reference at ${want.value[i]}',
          );
          expect(
            rows[i].size.height,
            closeTo(
              want.key == 'textarea' ? _textareaHeight : _rowHeight,
              _tolerance,
            ),
            reason: '#${want.key} row $i height',
          );
        }
      }
    });

    testWidgets('the message lines are the three leadings the family types', (
      WidgetTester tester,
    ) async {
      await pumpInputsInShell(tester);

      // `FieldLabel` states `leading-snug`, `FieldDescription` states
      // `leading-normal`, and `FieldError` states nothing and keeps `text-sm`'s
      // own ratio. Three consecutive lines, three different line boxes — which
      // is why the reference measures 18.6 under one field and 19.5 under the
      // next.
      //
      // Each is pinned to `[declared, declared + _lineQuantum)`: the two the
      // family builds out of a bare `Text` round up to the next half pixel and
      // the one that goes through `DsText` does not, and that difference is the
      // whole of this page's residual. A band rather than an equality so the
      // pin survives `field.dart` routing both through `DsLineBox`, which is
      // the fix and which lands both of them on the declared number.
      for (final RenderBox label in tester.renderObjectList<RenderBox>(
        find.byType(DsFieldLabel),
      )) {
        expect(
          label.size.height,
          inInclusiveRange(_labelLine, _labelLine + _lineQuantum),
          reason: '13px on `leading-snug` is $_labelLine',
        );
      }
      for (final RenderBox error in tester.renderObjectList<RenderBox>(
        find.descendant(
          of: _section('validation'),
          matching: find.byType(DsFieldError),
        ),
      )) {
        expect(
          error.size.height,
          inInclusiveRange(_errorLine, _errorLine + _lineQuantum),
          reason: "13px on `text-sm`'s own ratio is $_errorLine",
        );
      }
      for (final RenderBox description in tester.renderObjectList<RenderBox>(
        find.byType(DsFieldDescription),
      )) {
        expect(
          description.size.height,
          _descriptionLine,
          reason: 'a `DsText` holds the exact CSS box, and this one is on it',
        );
      }
      expect(
        tester
            .renderObject<RenderBox>(find.ancestor(
              of: find.text('Available.'),
              matching: find.byType(DsText),
            ))
            .size
            .height,
        _descriptionLine,
        reason: 'the one description the page types itself',
      );
    });

    testWidgets('a state cell is a quarter of the lattice, less its padding', (
      WidgetTester tester,
    ) async {
      await pumpInputsInShell(tester);

      // 1080 − 2 (the lattice's own border) − 3 (the `gap-px` gutters) = 1075,
      // ÷ 4 = 268.75 per cell; less 2×20 of `p-5` the field renders 228.75.
      const double cell = (_columnWidth - 2 - 3) / 4;
      for (final RenderBox tile in tester.renderObjectList<RenderBox>(
        find.byType(DsStateCell),
      )) {
        expect(tile.size.width, closeTo(cell, _tolerance));
      }
      for (final RenderBox field in tester.renderObjectList<RenderBox>(
        find.descendant(
          of: find.byType(DsStateGrid),
          matching: find.byType(DsInput),
        ),
      )) {
        expect(field.size.width, closeTo(cell - 2 * ds(5), _tolerance));
      }
    });

    testWidgets('the measures are 512 and 160, not the column', (
      WidgetTester tester,
    ) async {
      await pumpInputsInShell(tester);

      // `max-w-lg` on every `FieldGroup` and on the composed `<form>`.
      for (final RenderBox group in tester.renderObjectList<RenderBox>(
        find.byType(DsFieldGroup),
      )) {
        expect(group.size.width, lessThanOrEqualTo(_measureLg));
      }
      // `max-w-40` on the Quantity and Referral groups, and on nothing else.
      final Iterable<double> widths = tester
          .renderObjectList<RenderBox>(find.byType(DsInputGroup))
          .map((RenderBox box) => box.size.width);
      expect(
        widths.where((double w) => w == _measure40),
        hasLength(2),
        reason: 'Quantity and Referral percentage',
      );
      expect(widths.every((double w) => w <= _measureLg), isTrue);
    });

    testWidgets('the foot nav collapses its own margin against `mb-20`', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpInputsInShell(tester);

      final ({double top, double height}) rules =
          _sectionBox(tester, column, 'rules');
      final RenderBox nav =
          tester.renderObject<RenderBox>(find.byType(DsPageFootNav));
      final double top = nav.localToGlobal(Offset.zero, ancestor: column).dy;

      expect(
        top - (rules.top + rules.height),
        closeTo(_sectionGap, _tolerance),
        reason: 'adjoining margins collapse to the larger of the two',
      );
      expect(
        top + nav.size.height,
        _stacksTo(_columnHeight),
        reason: 'the nav is the last thing in the column',
      );
    });

    testWidgets('dark stacks exactly as light does', (
      WidgetTester tester,
    ) async {
      // The reference's heights are theme-equal — nothing on this page changes
      // shape with the ink — so this port's must be too.
      final RenderBox dark =
          await pumpInputsInShell(tester, mode: DsThemeMode.dark);
      expect(dark.size.height, _stacksTo(_columnHeight));
    });
  });
}
