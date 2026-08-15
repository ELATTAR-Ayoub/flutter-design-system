/// The shadows page's contract: every specimen *is* the token it names — all
/// fourteen of them painted by [DsMachineSurface], the ambient four included —
/// `#in-use` is five real controls a reader can press and type into, the copy
/// ships as the reference wrote it (the 44px that renders at 48 included), and
/// the page stacks to the reference's own measured heights at the 1440 frame.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/shadows.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/// The design frame, tall enough that the whole page is laid out at once.
///
/// Width matters: `lg` (1024px) is where `#ambient` reaches four-up and
/// `#machine` three-up, so every column split on the page has fired at 1440.
const Size _desktop = Size(1440, 4000);

/// `h-24` — the height every specimen box on the page shares.
final double _specimenHeight = ds(24);

/// `max-w-sm` — Tailwind's container scale, which `globals.css` does not
/// override. The cap `#in-use` puts on its field.
const double _measureSm = 384;

/* ── The reference's own stack ───────────────────────────────────────────── */

/// The frame the reference is measured at, and the only width these numbers
/// mean anything at: `.type-h1` is `clamp(2rem, 2.8vw, 2.5rem)`, so the heading
/// alone is 8.8px shorter at 1080 than at 1440.
const Size _referenceFrame = Size(1440, 900);

/// `--width-content` — the reading column, which every wrap below depends on.
const double _columnWidth = 1080;

/// The reference's own column height: `main` 3605.1 less `py-12` twice.
///
/// Reads back as `scrollHeight` 3669 — the column sits 112px down the document
/// (`main` at 64, plus its own 48px of top padding) and pays another 48 below.
const double _columnHeight = 3509.1;

/// Every section's top and height, **page-relative**: the live measurement's
/// document offsets less the 112px the column starts at.
///
/// Measured off the running reference at 1440×900, light — the web's heights
/// are theme-equal, and so are this port's. `height` is the CSS border box, so
/// it excludes `mb-20`; [_sectionBox] takes the port's 80px of bottom padding
/// back off before comparing, which is also what makes the 80px rhythm between
/// consecutive sections checkable as `top + height + 80`.
const Map<String, ({double top, double height})> _sectionOracle =
    <String, ({double top, double height})>{
  'ambient': (top: 443.9, height: 346.4),
  'machine': (top: 870.3, height: 736.6),
  'in-use': (top: 1686.9, height: 351.3),
  'glow': (top: 2118.2, height: 331.3),
  'glass': (top: 2529.5, height: 455.3),
  'rules': (top: 3064.8, height: 263.3),
};

/// `section.mb-20` — 80px, which the port pays as padding inside the section's
/// own box because Flutter has no margins.
final double _sectionGap = ds(20);

/// Two logical pixels. The port currently lands inside 0.1 of every number
/// above; the slack is for the sub-pixel a different Skia build might round
/// differently, not for drift.
const double _tolerance = 2;

/// The reference's own font binaries.
///
/// **Load-bearing, not hygiene.** Without them the engine measures a fallback
/// face and every line height is fiction: this page stacks 589px taller with no
/// faces loaded, and 569.7 of that is Inter alone. Any harness that reports a
/// height for this page without loading these is reporting the fallback's
/// metrics, not the port's.
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
  /// `#in-use` mounts a premium [DsButton], whose `DsFoilValue` runs two
  /// `infinite` animations — a tree holding one of those never comes to rest,
  /// so `pumpAndSettle` would hang here rather than fail. Reduced motion is the
  /// port of `prefers-reduced-motion: reduce`: every duration in the package
  /// routes through [dsAnimationDuration], both loops are stopped before they
  /// start, and what paints is the page at rest. The [MediaQuery] therefore
  /// goes *below* [MaterialApp], which installs its own from the view and would
  /// otherwise win — and the frames below are pumped explicitly, never settled.
  Future<void> pumpShadowsPage({DsThemeMode mode = DsThemeMode.dark}) async {
    useViewport(_desktop);
    await pumpWidget(
      DsTheme(
        controller: DsThemeController(mode: mode),
        child: AppRouterScope(
          router: AppRouter(route: '$dsRoot/shadows'),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (BuildContext context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                // The shell's own scroll view: the page is far taller than any
                // viewport, and a `SingleChildScrollView` lays all of it out.
                child: const SingleChildScrollView(child: ShadowsPage()),
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
/// column's own [RenderBox] — the origin every number in [_sectionOracle] is
/// measured from.
///
/// The shell is what supplies the 1080 column: `main` is `flex-1` beside a
/// 240px rail and pays `px-12`, and the column inside it is capped at
/// `--width-content`. Measuring the page in anything else measures a different
/// column, and every wrap on the page follows the column.
///
/// `main.dart` is the supervisor's at integration, so the page is handed to the
/// shell directly rather than looked up through `pageFor` — the shell is the
/// same either way.
Future<RenderBox> pumpShadowsInShell(
  WidgetTester tester, {
  DsThemeMode mode = DsThemeMode.light,
}) async {
  tester.view.physicalSize = _referenceFrame;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final DsThemeController theme = DsThemeController(mode: mode);
  const String route = '$dsRoot/shadows';
  final AppRouter router = AppRouter(route: route);
  addTearDown(theme.dispose);
  addTearDown(router.dispose);

  const Widget page = ShadowsPage();
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
  // No reduced-motion wrapper and no settle: `DsFoilValue`'s two `infinite`
  // controllers never come to rest, and nothing here waits on them — geometry
  // is settled on the first laid-out frame.
  await tester.pump();

  return tester.renderObject<RenderBox>(find.byWidget(page));
}

/// The section with [id] in [origin]'s coordinates, with `mb-20` taken back off
/// its height so the number compares to the reference's CSS border box.
({double top, double height}) _sectionBox(
  WidgetTester tester,
  RenderBox origin,
  String id,
) {
  final RenderBox box = tester.renderObject<RenderBox>(
    find.byWidgetPredicate((Widget w) => w is DsSection && w.id == id),
  );
  return (
    top: box.localToGlobal(Offset.zero, ancestor: origin).dy,
    height: box.size.height - _sectionGap,
  );
}

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

/// [_chip], narrowed to the chips inside [scope].
///
/// `--card` is a chip twice in `#glass` — the `glass-panel` caption names it
/// and so does the note beneath — and two whole chips join into the same string
/// as one chip's slices. Scoping is what tells the two readings apart.
String _chipIn(WidgetTester tester, Finder scope, String text) => tester
    .widgetList<DsCode>(
      find.descendant(of: scope, matching: find.byType(DsCode)),
    )
    .where((DsCode code) => code.chip == text)
    .map((DsCode code) => code.text)
    .join();

/// The `<section id="…">` — the page's spine, and what a claim about one
/// section is scoped to. Several strings live in two sections at once:
/// `shadow-pressed` is a specimen *and* a chip, `--shadow-e2` a token *and* a
/// chip, `--card` a chip twice over.
Finder _section(String id) => find.byWidgetPredicate(
      (Widget widget) => widget is DsSection && widget.id == id,
    );

/// Every [DsMachineSurface] inside the section with [id], in DOM order.
List<DsMachineSurface> _surfacesIn(WidgetTester tester, String id) => tester
    .widgetList<DsMachineSurface>(
      find.descendant(
        of: _section(id),
        matching: find.byType(DsMachineSurface),
      ),
    )
    .toList();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
    await _loadFont('Redaction35', 'Redaction35-Italic.ttf');
  });

  testWidgets('the opening note states both families, in three faces', (
    WidgetTester tester,
  ) async {
    await tester.pumpShadowsPage();

    // A note title is `.type-label`, which uppercases at paint and renders
    // muted-foreground in every tone.
    expect(find.text('TWO FAMILIES, ONE IDEA'), findsOneWidget);

    final List<DsNote> notes =
        tester.widgetList<DsNote>(find.byType(DsNote)).toList();
    expect(
      notes,
      hasLength(2),
      reason: 'the page-level note, and the one inside #glass',
    );
    expect(notes.first.tone, DsNoteTone.action);

    expect(
      find.textContaining(
        'Ambient shadows describe how far a surface floats.',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect(
      find.textContaining(
        'everything feels like flat cardboard.',
        findRichText: true,
      ),
      findsOneWidget,
    );

    // `<strong>Machine</strong>` and `<em>pressed</em>`. globals.css styles
    // neither element outside `.prose`, so Preflight's `bolder` against an
    // inherited 400 computes to 700 — and Inter has no italic face to reach
    // for, so the emphasis is a synthesised oblique.
    final Text body = tester.widgetList<Text>(find.byType(Text)).firstWhere(
          (Text text) =>
              text.textSpan?.toPlainText().startsWith('Ambient shadows') ??
              false,
        );
    final List<TextSpan> runs =
        (body.textSpan! as TextSpan).children!.whereType<TextSpan>().toList();
    TextSpan run(String text) =>
        runs.firstWhere((TextSpan span) => span.text == text);
    expect(
      run('Machine').style!.fontWeight,
      FontWeight.bold,
      reason: 'Preflight `b, strong { font-weight: bolder }`',
    );
    expect(run('pressed').style!.fontStyle, FontStyle.italic);
  });

  testWidgets('#ambient names four classes, four tokens and four uses', (
    WidgetTester tester,
  ) async {
    await tester.pumpShadowsPage();

    expect(find.text('Ambient depth'), findsOneWidget);
    expect(
      find.text(
        'Four steps. On a near-black page a shadow reads as a soft darkening, '
        'so depth mostly comes from the surface ladder — these only confirm '
        'it.',
      ),
      findsOneWidget,
      reason: 'the spacing page states the same idea in different words',
    );
    // `.type-label` uppercases the strip; the arrow is a U+2192, not `->`.
    expect(find.text('E1 → E4'), findsOneWidget);

    for (int step = 1; step <= 4; step++) {
      expect(find.text('shadow-e$step'), findsOneWidget);
      expect(find.text('--shadow-e$step'), findsOneWidget);
    }

    // Character-identical to the spacing page's Elevation panel — the two pages
    // differ in their section description and nowhere else here.
    for (final String use in <String>[
      'Resting rows, chips, table headers. Barely there.',
      'Cards and pack cards at rest.',
      'Hovered cards, popovers, dropdowns, sticky bars.',
      'Dialogs, drawers, the pack-opening stage.',
    ]) {
      expect(find.text(use), findsOneWidget, reason: 'use copy "$use"');
    }
  });

  testWidgets('#machine names eight classes, eight tokens and eight uses', (
    WidgetTester tester,
  ) async {
    await tester.pumpShadowsPage();

    expect(find.text('Machine surfaces'), findsOneWidget);
    expect(
      find.text(
        'Depth that implies a mechanism. These carry inset highlights and '
        'shades, so a control looks like it has a top face and a side wall.',
      ),
      findsOneWidget,
    );
    expect(find.text('THE MACHINE SET'), findsOneWidget);

    for (final String cls in <String>[
      'shadow-btn',
      'shadow-btn-primary',
      'shadow-btn-value',
      'shadow-btn-down',
      'shadow-key',
      'shadow-key-down',
      'shadow-pressed',
      'shadow-chip',
    ]) {
      // The caption in `#in-use` names four of these as `<code>` chips, and a
      // chip with a hyphen is sliced — so the whole string is the specimen's.
      expect(find.text(cls), findsOneWidget, reason: '$cls specimen');
      expect(find.text('--$cls'), findsOneWidget, reason: '--$cls token');
    }

    for (final String use in <String>[
      // Drift 1, shipped: only `outline` carries `shadow-btn`.
      'Secondary, outline and destructive buttons. An inner top highlight and '
          'inner bottom shade make the surface read as a physical key.',
      'The primary button. Same depth plus a blue cast beneath it.',
      'The premium button. Lime cast, for money and reward actions.',
      'Any button while pressed. The surface sinks into its socket instead of '
          'merely dimming.',
      // Drift 8, shipped: `press-key` exists and is never demonstrated.
      'A raised key with a visible side wall. Used by the press-key utility.',
      'The same key, travelled 3px down into its socket.',
      'A sunken socket. Every input, textarea and input group sits in one.',
      'Badge and chip depth. Lighter than a button, but not flat.',
    ]) {
      expect(find.text(use), findsOneWidget, reason: 'use copy "$use"');
    }
  });

  testWidgets('every specimen is the token itself, painted the one way', (
    WidgetTester tester,
  ) async {
    await tester.pumpShadowsPage();

    // The spec objects are the ones `DsShadows` declares, not copies of their
    // layers: a specimen that restated the geometry would be a drawing of a
    // shadow rather than the shadow.
    final List<DsMachineSurface> machine = _surfacesIn(tester, 'machine');
    expect(machine, hasLength(8));
    final List<DsShadowSpec> expected = <DsShadowSpec>[
      DsShadows.btn,
      DsShadows.btnPrimary,
      DsShadows.btnValue,
      DsShadows.btnDown,
      DsShadows.key,
      DsShadows.keyDown,
      DsShadows.pressed,
      DsShadows.chip,
    ];
    for (int i = 0; i < expected.length; i++) {
      expect(machine[i].spec, same(expected[i]), reason: 'machine cell $i');
      // `rounded-pill bg-card` and **no border** — the two ways a machine cell
      // differs from an ambient one.
      expect(machine[i].border, isNull, reason: 'machine cell $i has a border');
      expect(machine[i].radius, BorderRadius.circular(DsRadii.pill));
    }

    // `grid h-24 place-items-center`, on all twelve.
    expect(
      tester
          .renderObjectList<RenderBox>(
            find.descendant(
              of: _section('machine'),
              matching: find.byType(DsMachineSurface),
            ),
          )
          .map((RenderBox box) => box.size.height)
          .toSet(),
      <double>{_specimenHeight},
    );

    // The ambient four take the same path — `e1`–`e4` are outer-only and a
    // `BoxDecoration` could paint them, and the page keeps one code path so the
    // difference between the families stays the shape and the border.
    final List<DsMachineSurface> ambient = _surfacesIn(tester, 'ambient');
    expect(
      ambient.map((DsMachineSurface cell) => cell.spec),
      <DsShadowSpec>[DsShadows.e1, DsShadows.e2, DsShadows.e3, DsShadows.e4],
    );
    for (final DsMachineSurface cell in ambient) {
      expect(cell.border, isNotNull, reason: '`border border-border`');
      expect(cell.radius, BorderRadius.circular(DsRadii.lg));
    }
  });

  testWidgets('#in-use mounts the five real variants, in DOM order', (
    WidgetTester tester,
  ) async {
    await tester.pumpShadowsPage();

    expect(find.text('Raised against recessed'), findsOneWidget);
    expect(
      find.text(
        'The rule in one panel. Press the buttons and focus the field — the '
        'button sinks, the field is already sunken and only its ring changes.',
      ),
      findsOneWidget,
    );
    expect(find.text('PRESS AND FOCUS THESE'), findsOneWidget);

    final List<DsButton> buttons =
        tester.widgetList<DsButton>(find.byType(DsButton)).toList();
    expect(
      buttons.map((DsButton button) => button.variant).toList(),
      <DsButtonVariant>[
        DsButtonVariant.primary,
        DsButtonVariant.premium,
        DsButtonVariant.secondary,
        DsButtonVariant.outline,
        DsButtonVariant.ghost,
      ],
    );
    for (final String label in <String>[
      'Open Pack',
      'Deposit Funds',
      'View Hits',
      'Filters',
      'Skip',
    ]) {
      expect(find.text(label), findsOneWidget, reason: 'button "$label"');
    }
    // Enabled, not decorative: `onPressed: null` is `disabled:` here, and would
    // take the press states the section is written about off the page.
    expect(
      buttons.every((DsButton button) => button.onPressed != null),
      isTrue,
    );

    // Drift 1 made visible on the page that states it. Every button paints
    // through a `DsMachineSurface`, six with the field — but `primary` and
    // `premium` splice a gradient ramp in where CSS puts it and hand their
    // surface the inset layers alone, so only the flat three name a whole spec.
    final List<DsMachineSurface> surfaces = _surfacesIn(tester, 'in-use');
    expect(surfaces, hasLength(6));
    expect(surfaces[0].spec.layers, DsShadows.btnPrimary.insetLayers);
    expect(surfaces[1].spec.layers, DsShadows.btnValue.insetLayers);
    expect(
      surfaces[2].spec,
      same(DsShadows.none),
      reason: '"View Hits" is flat, where the `--shadow-btn` copy claims it',
    );
    expect(surfaces[3].spec, same(DsShadows.btn), reason: '"Filters"');
    expect(surfaces[4].spec, same(DsShadows.none), reason: '"Skip"');
  });

  testWidgets('#in-use caps a real field at 384px, in a permanent socket', (
    WidgetTester tester,
  ) async {
    await tester.pumpShadowsPage();

    expect(find.byType(DsInput), findsOneWidget);
    expect(find.text('Search packs, cards and sets'), findsOneWidget);

    // `<div class="mt-6 max-w-sm">` around a `w-full` Input.
    expect(tester.getSize(find.byType(DsInput)).width, _measureSm);
    // `h-10` — deliberately level with a default `DsButton`.
    expect(tester.getSize(find.byType(DsInput)).height, DsInput.height);

    // *"It is a socket, and it never rises."* — the field's surface at rest is
    // the same `--shadow-pressed` the specimen above it prints.
    expect(_surfacesIn(tester, 'in-use').last.spec, same(DsShadows.pressed));
  });

  testWidgets('the field really takes text, and the placeholder goes', (
    WidgetTester tester,
  ) async {
    await tester.pumpShadowsPage();

    // "Focus the field" is the section's own promise, so the field is editable
    // in fact rather than in appearance.
    await tester.enterText(find.byType(EditableText), 'ex');
    await tester.pump();

    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      'ex',
    );
    expect(
      find.text('Search packs, cards and sets'),
      findsNothing,
      reason: '`::placeholder` shows only while the value is empty',
    );
  });

  testWidgets("#in-use's caption quotes five chips", (
    WidgetTester tester,
  ) async {
    await tester.pumpShadowsPage();

    // Drift 2 lives in what this sentence claims: the premium button carries
    // `shadow-btn-value`, and two of the five carry nothing at all.
    for (final String chip in <String>[
      'shadow-btn',
      'shadow-btn-primary',
      'shadow-btn-down',
      ':active',
      'shadow-pressed',
    ]) {
      expect(_chip(tester, chip), chip, reason: 'chip "$chip"');
    }
    expect(
      find.textContaining(
        'it is a socket, and it never rises.',
        findRichText: true,
      ),
      findsOneWidget,
    );
  });

  testWidgets('#glow names both utilities and says what each one means', (
    WidgetTester tester,
  ) async {
    await tester.pumpShadowsPage();

    // The heading, and the header chip further up that names this section.
    expect(find.text('Rationed glow'), findsNWidgets(2));
    expect(
      find.text(
        'Two glows, and they are the scarcest thing in the system. Both derive '
        'from the accent tokens, so they follow the palette automatically.',
      ),
      findsOneWidget,
    );
    expect(find.text('SELECTED AND CELEBRATED'), findsOneWidget);
    expect(find.text('glow-action'), findsOneWidget);
    expect(find.text('glow-value'), findsOneWidget);

    // Drift 6: the spacing page says "Signals" and names different occasions
    // for the same two glows. Both copies ship.
    expect(
      find.textContaining(
        'Selected pack, focused primary CTA, active opening stage. Says ',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect(
      find.textContaining(
        'Celebrated tiers, reward unlocks, premium actions. Says ',
        findRichText: true,
      ),
      findsOneWidget,
    );
    // Each caption's `<em>` clause, with the full stop outside it.
    expect(
      find.textContaining('this is the thing you chose', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('this is worth something', findRichText: true),
      findsOneWidget,
    );

    expect(
      _surfacesIn(tester, 'glow').map((DsMachineSurface cell) => cell.spec),
      <DsShadowSpec>[DsShadows.glowAction, DsShadows.glowValue],
    );
  });

  testWidgets('#glass mounts both surfaces and quotes four chips', (
    WidgetTester tester,
  ) async {
    await tester.pumpShadowsPage();

    // The heading, and the header chip further up that names this section.
    expect(find.text('Glass'), findsNWidgets(2));
    // Drift 4: there are three utilities, and only the panel label narrows
    // honestly to the two that are shown.
    expect(
      find.text(
        'A surface in front of the page rather than cut out of it. Two '
        'utilities, one material — the split is scale, not taste.',
      ),
      findsOneWidget,
    );
    expect(find.text('GLASS-PANEL AND GLASS-CONTROL'), findsOneWidget);

    expect(find.byType(DsGlassPanel), findsOneWidget);
    expect(find.byType(DsGlassControl), findsOneWidget);
    expect(find.text('glass-panel'), findsOneWidget);
    expect(find.text('glass-control'), findsOneWidget);

    final Finder glass = _section('glass');
    expect(
      _chipIn(tester, glass, '--card'),
      '--card--card',
      reason: 'the caption names it and so does the note below it',
    );
    expect(_chipIn(tester, glass, '--shadow-e2'), '--shadow-e2');
    expect(_chipIn(tester, glass, 'bg-card'), 'bg-card');
    expect(_chipIn(tester, glass, 'e2'), 'e2');
    expect(
      find.textContaining(
        'The page’s own light shows through it',
        findRichText: true,
      ),
      findsOneWidget,
      reason: 'a U+2019 right single quotation mark, not an apostrophe',
    );

    // The note, whose title carries a bare `dark:` — the class-variant prefix,
    // colon and all, rather than a typo.
    final Finder note = find.descendant(
      of: glass,
      matching: find.byType(DsNote),
    );
    expect(find.text('NEITHER NEEDS A DARK: VARIANT'), findsOneWidget);
    for (final String chip in <String>[
      '--card',
      '--foreground',
      '--rim-strong',
    ]) {
      expect(_chipIn(tester, note, chip), chip, reason: 'note chip "$chip"');
    }
  });

  testWidgets('the glass control says 44px and measures 48', (
    WidgetTester tester,
  ) async {
    await tester.pumpShadowsPage();

    // Drift 3. The copy, the CSS comment and the utility's own rationale all
    // say 44; the class is `h-12`. Both halves ship, and this is the test that
    // stops either one being quietly reconciled with the other.
    expect(
      find.textContaining(
        'at 44px there is nothing behind it worth blurring',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect(tester.getSize(find.byType(DsGlassControl)).height, ds(12));
  });

  testWidgets('#rules states four of each, and describes nothing', (
    WidgetTester tester,
  ) async {
    await tester.pumpShadowsPage();

    expect(find.text('Rules'), findsOneWidget);
    expect(
      tester.widget<DsSection>(_section('rules')).description,
      isNull,
      reason: 'the one section on the page with no description',
    );

    expect(find.text('DO'), findsOneWidget);
    // `Don&rsquo;t` — the heading is the only curly apostrophe in the pair.
    expect(find.text('DON’T'), findsOneWidget);

    for (final String rule in <String>[
      'Use the surface ladder plus a hairline for depth first; add a shadow '
          'only to confirm it.',
      'Give anything pressable a machine shadow, and sink it to '
          'shadow-btn-down on active.',
      'Keep every field in a sunken shadow-pressed socket.',
      'Reserve the two glows for selection and reward.',
      // Straight apostrophes, as the source array has them.
      "Don't put an ambient shadow on a control — it will read as floating "
          'rather than pressable.',
      "Don't raise an input; recessed is what makes it read as editable.",
      "Don't glow a resting surface, and never glow navigation.",
      "Don't invent a shadow inline — every value is a token.",
    ]) {
      expect(find.text(rule), findsOneWidget, reason: 'rule "$rule"');
    }
  });

  testWidgets('the header and foot nav place the page in the group', (
    WidgetTester tester,
  ) async {
    await tester.pumpShadowsPage();

    expect(find.text('FOUNDATIONS'), findsOneWidget);
    expect(find.text('Shadows'), findsOneWidget);
    expect(
      find.text(
        'Two families: ambient depth, and machine surfaces that look like they '
        'can be physically pressed. Ported from Yukirhythm.',
      ),
      findsOneWidget,
    );
    for (final String chip in <String>[
      // An en dash (U+2013), not a hyphen.
      'Ambient e1–e4',
      'Machine keys',
      'Sunken sockets',
      'Control depth',
    ]) {
      expect(find.text(chip), findsOneWidget, reason: 'header chip "$chip"');
    }
    // The two chips that name a section further down, whose heading renders the
    // same string. The other four are the page's own words for its sections.
    expect(find.text('Rationed glow'), findsNWidgets(2));
    expect(find.text('Glass'), findsNWidgets(2));

    expect(find.text('PREVIOUS'), findsOneWidget);
    expect(find.text('Spacing & Layout'), findsOneWidget);
    expect(find.text('NEXT'), findsOneWidget);
    expect(find.text('Motion'), findsOneWidget);
  });

  testWidgets('light renders the same page, re-inked', (
    WidgetTester tester,
  ) async {
    await tester.pumpShadowsPage(mode: DsThemeMode.light);

    expect(tester.takeException(), isNull);

    // Same shapes, same names, same components — the geometry of every shadow
    // is fixed and only its ink is themed.
    expect(_surfacesIn(tester, 'ambient'), hasLength(4));
    expect(_surfacesIn(tester, 'machine'), hasLength(8));
    expect(find.byType(DsButton), findsNWidgets(5));
    expect(find.byType(DsInput), findsOneWidget);
    expect(find.byType(DsGlassPanel), findsOneWidget);
    expect(find.byType(DsGlassControl), findsOneWidget);
    expect(find.text('TWO FAMILIES, ONE IDEA'), findsOneWidget);
    // The note's own claim, which this test is the proof of.
    expect(find.text('NEITHER NEEDS A DARK: VARIANT'), findsOneWidget);

    // …and the ink really did flip: a token name is `text-action-ink`, which is
    // `#92C2FC` on dark and `#143694` here.
    expect(
      tester.widget<Text>(find.text('--shadow-e1')).style!.color,
      DsThemeData.light.actionInk,
    );
    expect(DsThemeData.light.actionInk, isNot(DsThemeData.dark.actionInk));
  });

  /* ── Geometry ──────────────────────────────────────────────────────────── */

  group('stacks to the reference at the 1440 frame', () {
    testWidgets('the column is --width-content, and as tall as the web page', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpShadowsInShell(tester);

      expect(
        column.size.width,
        _columnWidth,
        reason: 'every wrap on the page follows the column; get this wrong '
            'and every height below it is measuring a different page',
      );
      expect(
        column.size.height,
        closeTo(_columnHeight, _tolerance),
        reason: 'the reference stacks to $_columnHeight — `main` 3605.1 less '
            'its two `py-12`, which reads back as scrollHeight 3669',
      );
    });

    testWidgets('every section starts and ends where the reference does', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpShadowsInShell(tester);

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
      final RenderBox column = await pumpShadowsInShell(tester);

      // Stated separately from the tops above because it is the one failure
      // that reads as every section after it having moved: a section that grew
      // by a pixel shifts five tops, and only this says which of the two broke.
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

    testWidgets('the foot nav collapses its own margin against `mb-20`', (
      WidgetTester tester,
    ) async {
      final RenderBox column = await pumpShadowsInShell(tester);

      final ({double top, double height}) rules =
          _sectionBox(tester, column, 'rules');
      final RenderBox nav =
          tester.renderObject<RenderBox>(find.byType(DsPageFootNav));
      final double top = nav.localToGlobal(Offset.zero, ancestor: column).dy;

      // CSS collapses the section's 80px bottom margin against the nav's own
      // `mt-8`, so the gap is 80 and not 112. `DsPageFootNav` does that
      // collapse by hand; this is the page that would show it if it stopped.
      expect(
        top - (rules.top + rules.height),
        closeTo(_sectionGap, _tolerance),
        reason: 'adjoining margins collapse to the larger of the two',
      );
      expect(
        top + nav.size.height,
        closeTo(_columnHeight, _tolerance),
        reason: 'the nav is the last thing in the column',
      );
    });

    testWidgets('dark stacks exactly as light does', (
      WidgetTester tester,
    ) async {
      // The reference's heights are theme-equal — the geometry of every shadow
      // is fixed and only its ink is themed — so this port's must be too.
      final RenderBox dark =
          await pumpShadowsInShell(tester, mode: DsThemeMode.dark);
      expect(dark.size.height, closeTo(_columnHeight, _tolerance));
    });
  });
}
