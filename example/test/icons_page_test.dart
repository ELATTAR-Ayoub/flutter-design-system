/// The icons page, held to `icons-map.md` §1–8.
///
/// The page documents the component every other page is drawn with, so what is
/// worth pinning is that the specimens really are that component: seven live
/// glyphs at the seven ladder sizes, ten resolving ten tokens, five inside real
/// buttons, and all 63 curated entries in the whitelist's own order. Alongside
/// them, the three places a Dart spelling could leak into rendered copy —
/// `2xl`, `3xl` and `default` — and the one deliberate translation, the Dart
/// usage block.
///
/// No `pumpAndSettle` anywhere: the harness mounts the page under
/// `disableAnimations`, which is the reduced-motion gate every controller in
/// the package routes through, so a single `pump` is a finished frame.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/icons.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/// Desktop, above `lg`: both grids on the page are 3-up, which is the shape
/// the reference is composed at. Tall enough that the whole page is laid out in
/// one pass, so every finder reaches below the fold.
const Size _viewport = Size(1440, 9000);

/// The `<code>` chip [text], read back from however many slices the line
/// breaker left it in.
String _chip(WidgetTester tester, String text) => tester
    .widgetList<DsCode>(find.byType(DsCode))
    .where((DsCode code) => code.chip == text)
    .map((DsCode code) => code.text)
    .join();

Widget _harness(DsThemeController controller, AppRouter router) => DsTheme(
      controller: controller,
      child: AppRouterScope(
        router: router,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Builder(
            builder: (BuildContext context) => MediaQuery(
              // Global constraint 3. `dsAnimationDuration` collapses to zero
              // under this flag, exactly as the reference's blanket
              // `prefers-reduced-motion` rule collapses every animation to
              // 0.01ms — so nothing here is ever mid-flight.
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: DefaultTextStyle(
                // `<body class="… text-foreground">`. The shell states this
                // and this harness mounts the page without the shell, so it
                // has to be restated: `DsIconTone.inherit` is `text-current`,
                // and this is the declaration it inherits.
                style: DsText.styleOf(
                  context,
                  DsType.body,
                  color: DsTheme.of(context).foreground,
                ),
                // The shell's own scroller. `SingleChildScrollView` lays out
                // its whole child, so the 63-cell registry is in the tree even
                // though most of it is far below the viewport.
                child: const SingleChildScrollView(child: IconsPage()),
              ),
            ),
          ),
        ),
      ),
    );

Future<DsThemeController> _pumpPage(
  WidgetTester tester, {
  DsThemeMode mode = DsThemeMode.dark,
}) async {
  tester.view.physicalSize = _viewport;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final DsThemeController theme = DsThemeController(mode: mode);
  await tester.pumpWidget(_harness(theme, AppRouter(route: '$dsRoot/icons')));
  await tester.pump();
  return theme;
}

/// The panel whose header strip reads [label].
Finder _panel(String label) => find.byWidgetPredicate(
      (Widget widget) => widget is DsPanel && widget.label == label,
    );

/// Every [DsIcon] inside the panel labelled [label], in reading order.
List<DsIcon> _iconsIn(WidgetTester tester, String label) => tester
    .widgetList<DsIcon>(
      find.descendant(of: _panel(label), matching: find.byType(DsIcon)),
    )
    .toList();

/// The four `#set` panels' labels, in `icons.ts` order.
const List<String> _groupLabels = <String>[
  'Navigation & structure',
  'Actions',
  'Collectible domain',
  'Money & status',
];

/// `test/icon_paths_test.dart`'s `_curated`, restated as the order this page
/// must print — 21 + 19 + 11 + 12.
///
/// Restated rather than imported: the package test guards the *geometry* in
/// this order, and this file guards that the page renders the same order. Two
/// independent transcripts of one whitelist is the point; sharing one list
/// would make a single typo agree with itself.
const List<DsIconGlyph> _curatedOrder = <DsIconGlyph>[
  DsIconGlyph.package, DsIconGlyph.radio, DsIconGlyph.layers, DsIconGlyph.gift,
  DsIconGlyph.trophy, DsIconGlyph.wallet, DsIconGlyph.user, DsIconGlyph.search,
  DsIconGlyph.bell, DsIconGlyph.settings, DsIconGlyph.logOut,
  DsIconGlyph.layoutGrid, DsIconGlyph.rows3, DsIconGlyph.chevronDown,
  DsIconGlyph.chevronUp, DsIconGlyph.chevronLeft, DsIconGlyph.chevronRight,
  DsIconGlyph.arrowLeft, DsIconGlyph.arrowRight, DsIconGlyph.ellipsis,
  DsIconGlyph.externalLink,
  DsIconGlyph.packageOpen, DsIconGlyph.shoppingCart, DsIconGlyph.heart,
  DsIconGlyph.eye, DsIconGlyph.eyeOff, DsIconGlyph.share2, DsIconGlyph.copy,
  DsIconGlyph.filter, DsIconGlyph.slidersHorizontal, DsIconGlyph.plus,
  DsIconGlyph.minus, DsIconGlyph.refreshCw, DsIconGlyph.download,
  DsIconGlyph.upload, DsIconGlyph.truck, DsIconGlyph.trash2, DsIconGlyph.ban,
  DsIconGlyph.x, DsIconGlyph.check,
  DsIconGlyph.sparkles, DsIconGlyph.crown, DsIconGlyph.flame, DsIconGlyph.zap,
  DsIconGlyph.star, DsIconGlyph.tag, DsIconGlyph.percent, DsIconGlyph.medal,
  DsIconGlyph.activity, DsIconGlyph.trendingUp, DsIconGlyph.trendingDown,
  DsIconGlyph.circleDollarSign, DsIconGlyph.creditCard,
  DsIconGlyph.arrowDownLeft, DsIconGlyph.arrowUpRight, DsIconGlyph.hourglass,
  DsIconGlyph.clock, DsIconGlyph.lock, DsIconGlyph.shield,
  DsIconGlyph.shieldCheck, DsIconGlyph.info, DsIconGlyph.helpCircle,
  DsIconGlyph.alertTriangle,
];

/* ── Vertical parity ─────────────────────────────────────────────────────── */

/// The reference's own frame.
const Size _referenceFrame = Size(1440, 900);

/// Where the reading column starts in the document: `main` sits under the 64px
/// sticky header and opens with `py-12`.
const double _columnTop = DsWidths.siteHeader + 48;

/// `.type-code` at `leading-relaxed` — 12.5 × 1.625.
///
/// **The one sanctioned delta on this page** (ruling I-Q1). The Dart usage
/// block is eight lines where the reference's TSX is nine, because Dart has a
/// barrel and the two-import head collapses to one. So `#component` is
/// expected to measure exactly this much shorter than the web oracle, and
/// every section below it starts exactly this much higher. Anything else is a
/// defect.
const double _oneCodeLine = 12.5 * 1.625;

/// A `DsSection`'s box carries its own `mb-20`; `getBoundingClientRect()` on
/// the web's `<section>` does not include the margin. 80px, once per section.
const double _sectionMargin = 80;

/// The live reference, measured at 1440×900 light with fonts loaded, as
/// document offsets — restated here in the page's own coordinates, which is
/// what `find.byWidget(page)` measures against.
typedef _Oracle = ({String id, double top, double height});

const List<_Oracle> _webSections = <_Oracle>[
  (id: 'component', top: 407.9, height: 720.1),
  (id: 'sizes', top: 1208, height: 487.2),
  (id: 'tones', top: 1775.2, height: 402.4),
  (id: 'in-context', top: 2257.6, height: 224.3),
  (id: 'set', top: 2561.9, height: 2219.4),
  (id: 'rules', top: 4861.3, height: 360.3),
];

/// `main`'s own height less its `py-12`: the reading column, web side.
const double _webColumnHeight = 5386.6 - 96;

/// Half a CSS pixel — the probe files' own bar, tighter than the ±2px asked
/// for and below anything either engine can paint.
const double _tolerance = 0.5;

Future<void> _loadFont(String family, String file) async {
  final ByteData bytes = ByteData.sublistView(
    File('../assets/fonts/$file').readAsBytesSync(),
  );
  final FontLoader loader = FontLoader('packages/elattar_design_system/$family')
    ..addFont(Future<ByteData>.value(bytes));
  await loader.load();
}

/// Mounts the page inside the real [DocsShell] at the reference's frame and
/// returns the reading column's own render box.
Future<RenderBox> _pumpInShell(WidgetTester tester) async {
  tester.view.physicalSize = _referenceFrame;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  const String route = '$dsRoot/icons';
  final DsThemeController theme = DsThemeController(mode: DsThemeMode.light);
  final AppRouter router = AppRouter(route: route);
  addTearDown(theme.dispose);
  addTearDown(router.dispose);

  // `main.dart` has no `icons` arm yet — the supervisor wires it at
  // integration — so the page is handed to the shell directly.
  const Widget page = IconsPage();
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
  await tester.pump();
  return tester.renderObject<RenderBox>(find.byWidget(page));
}

/// Every `DsSection`'s box, in the reading column's coordinates.
List<({String id, Rect rect})> _sectionBoxes(
  WidgetTester tester,
  RenderBox column,
) =>
    <({String id, Rect rect})>[
      for (final Element element
          in find.byType(DsSection).evaluate().toList())
        (
          id: (element.widget as DsSection).id,
          rect: () {
            final RenderBox box = element.findRenderObject()! as RenderBox;
            return box.localToGlobal(Offset.zero, ancestor: column) & box.size;
          }(),
        ),
    ];

void main() {
  group('the page in the group', () {
    testWidgets('the header reads the registry, chips and all',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      expect(find.text('FOUNDATIONS'), findsOneWidget);
      expect(find.text('Icons'), findsOneWidget);
      expect(
        find.text(
          'The Icon component wrapping Lucide: fixed sizes, stroke rules, and '
          'the curated icon set, grouped by domain.',
        ),
        findsOneWidget,
      );

      // DRIFT 1: six chips, and the last three name Panels inside `#set`
      // rather than sections. Static labels, so they port as data — and
      // scoped to the header, because two of them collide with a section
      // heading further down the page, which is the mismatch in miniature.
      for (final String chip in <String>[
        'Icon component',
        'Sizes',
        'Tones',
        'Navigation set',
        'Action set',
        'Domain set',
      ]) {
        expect(
          find.descendant(
            of: find.byType(DsPageHeader),
            matching: find.text(chip),
          ),
          findsOneWidget,
          reason: chip,
        );
      }
      // Only two of the six chips name a section: `Sizes` and `Tones`.
      expect(find.text('Sizes'), findsNWidgets(2));
      expect(find.text('Tones'), findsNWidgets(2));
      expect(find.text('Navigation set'), findsOneWidget);
      // The three chips that name no section, and the two sections that get no
      // chip — both halves of the mismatch, asserted rather than tidied.
      expect(find.text('Icons in controls'), findsOneWidget);
      expect(find.text('Rules'), findsOneWidget);
    });

    testWidgets('six sections, in the reference\'s order',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final List<DsSection> sections =
          tester.widgetList<DsSection>(find.byType(DsSection)).toList();
      expect(
        sections.map((DsSection s) => s.id),
        <String>['component', 'sizes', 'tones', 'in-context', 'set', 'rules'],
      );
      expect(
        sections.map((DsSection s) => s.title),
        <String>[
          'The Icon component',
          'Sizes',
          'Tones',
          'Icons in controls',
          // `ICON_COUNT` is a reduce over the groups, not a literal.
          'The curated set — 63 glyphs',
          'Rules',
        ],
      );
      // `#rules` is the one section with no description.
      expect(sections.last.description, isNull);
    });

    testWidgets('the foot nav is previous-only, and keeps half the row',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      // `icons` is the last category in `foundations`, and `siblings` does not
      // fall through to the next group — `at(6)` is undefined and the guard
      // returns null. This is the only page in the system whose foot nav has
      // an empty half.
      expect(find.text('PREVIOUS'), findsOneWidget);
      expect(find.text('Motion'), findsOneWidget);
      expect(find.text('NEXT'), findsNothing);

      final double nav = tester.getSize(find.byType(DsPageFootNav)).width;
      final double card = tester
          .getSize(find.descendant(
            of: find.byType(DsPageFootNav),
            matching: find.byType(DsPress),
          ))
          .width;
      // `flex-1` on both halves with `gap-4` between: the card is exactly half
      // the row less 8px, and does not stretch into the empty slot.
      expect(card, closeTo((nav - ds(4)) / 2, 0.01));
    });
  });

  group('#component — the usage block', () {
    testWidgets('ships the Dart API, not the reference\'s TSX (ruling I-Q1)',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final DsCodeBlock block =
          tester.widget<DsCodeBlock>(find.byType(DsCodeBlock));
      final List<String> lines = block.code.split('\n');

      // Eight lines where the reference has nine: the two-import head collapses
      // to one, because Dart has a barrel and there is no `lucide-react` to
      // import beside it.
      expect(lines, hasLength(8));
      expect(lines[1], isEmpty);
      expect(lines[5], isEmpty);
      expect(
        lines.first,
        "import 'package:elattar_design_system/elattar_design_system.dart';",
      );

      // The comment wording, the em dashes (U+2014) and the straight ASCII
      // quotes are the reference's, carried over unchanged.
      expect(
        lines[2],
        '// Decorative — adjacent text already says "Open Pack",',
      );
      expect(lines[3], '// so the glyph is hidden from screen readers.');
      expect(lines[6], '// Meaningful — icon-only control, so it must be named.');

      // Both examples are executable, and both name a real member of the API
      // this page documents.
      expect(
        lines[4],
        'const DsIcon(DsIconGlyph.packageOpen, size: DsIconSize.md, '
        'tone: DsIconTone.inherit)',
      );
      expect(
        lines[7],
        'const DsIcon(DsIconGlyph.heart, size: DsIconSize.lg, '
        "tone: DsIconTone.value, label: 'Add to favourites')",
      );

      // Nothing of the TSX survives — this is a translation, not a patch.
      expect(block.code, isNot(contains('lucide-react')));
      expect(block.code, isNot(contains('@/components/ui/icon')));
      // DRIFT 5 is the one on this page that does NOT ship: the reference's
      // snippet imports `PackageOpen` and then uses `Heart`. The barrel brings
      // both, so the hole closes rather than being reintroduced.
      expect(block.code, contains('DsIconGlyph.heart'));
    });

    testWidgets('the pre keeps its own line breaks and scrolls sideways',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final Finder scroller = find.descendant(
        of: find.byType(DsCodeBlock),
        matching: find.byType(SingleChildScrollView),
      );
      expect(
        tester.widget<SingleChildScrollView>(scroller).scrollDirection,
        Axis.horizontal,
        reason: '`overflow-x-auto` — the sample scrolls rather than reflowing',
      );

      final Finder sample = find.descendant(
        of: find.byType(DsCodeBlock),
        matching: find.byType(Text),
      );
      // `white-space: pre`.
      expect(tester.widget<Text>(sample).softWrap, isFalse);

      // DRIFT 8, measured on the CSS line box rather than the engine's: the
      // `leading-relaxed` utility beats `.type-code`'s own 1.4, so a line is
      // 12.5 × 1.625 = 20.3125px and eight of them come to 162.5. The engine
      // rounds each line to 20 and would hand back 160; at `.type-code`'s
      // declared 1.4 the block would be 140.
      final Finder box = find.descendant(
        of: find.byType(DsCodeBlock),
        matching: find.byType(DsLineBox),
      );
      expect(tester.getSize(box).height, closeTo(8 * 12.5 * 1.625, 0.01));
      expect(tester.getSize(sample).height, 8 * 20.0);

      // Ruling I-Q8, both halves of it. The scroller ships because
      // `overflow-x-auto scrollbar-thin` is in the class list, not because the
      // sample is wide: at a full-width column it has nothing to scroll, and
      // the reference's TSX never scrolled at 1440 either. Narrow the column
      // and it earns its place — without reflowing, which is the whole
      // difference between a `<pre>` and a paragraph.
      Finder scrollable() => find.descendant(
            of: find.byType(DsCodeBlock),
            matching: find.byType(Scrollable),
          );
      expect(
        tester.state<ScrollableState>(scrollable()).position.axis,
        Axis.horizontal,
      );
      expect(
        tester.state<ScrollableState>(scrollable()).position.maxScrollExtent,
        0,
        reason: 'nothing to scroll while the column is wider than the sample',
      );

      tester.view.physicalSize = const Size(700, 9000);
      await tester.pump();
      expect(
        tester.state<ScrollableState>(scrollable()).position.maxScrollExtent,
        greaterThan(0),
      );
      // Eight lines still, at the same leading: the sample scrolled, it did
      // not re-break.
      expect(tester.getSize(box).height, closeTo(8 * 12.5 * 1.625, 0.01));
    });

    testWidgets('the Meta prints the ladder off the ladder',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      for (final String key in <String>['icon', 'size', 'tone', 'label']) {
        expect(find.text(key), findsOneWidget, reason: key);
      }
      // The two top rungs print `2xl`/`3xl` — the object keys — where the Dart
      // enum spells them `xl2`/`xl3`. The separators are U+00B7.
      expect(
        find.textContaining(
          'xs 12 · sm 14 · md 16 · lg 20 · xl 24 · 2xl 32 · 3xl 40. Default md.',
          findRichText: true,
        ),
        findsOneWidget,
      );
      expect(find.textContaining('xl2', findRichText: true), findsNothing);
      expect(find.textContaining('xl3', findRichText: true), findsNothing);
    });

    testWidgets('the stroke note ships its approximate claim verbatim',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      // A `DsNote` title is muted-foreground in every tone, so it renders
      // uppercase through `.type-label`.
      expect(find.text('STROKE SCALES WITH THE BOX'), findsOneWidget);
      expect(
        find.text(
          'Lucide is drawn on a 24px grid for a 2px stroke. Rendered at 12px '
          'that stroke reads twice as heavy, and at 40px it reads thin. The '
          'component compensates automatically, so a 12px icon and a 40px icon '
          'carry the same optical weight.',
        ),
        findsOneWidget,
      );
      // …and the ladder it describes disagrees with it. `strokeFor` is a
      // three-rung snap, not a clamp, so the rendered stroke climbs across the
      // ladder instead of holding. The copy ships; the ternary is what runs.
      const List<double> rendered = <double>[
        1.2, 1.4, 1.6, 20 / 12, 2.0, 8 / 3, 8 / 3, //
      ];
      for (int i = 0; i < DsIconSize.values.length; i++) {
        final double px = DsIcon.pxFor(DsIconSize.values[i]);
        expect(
          DsIcon.strokeFor(px) * px / DsIconPaths.viewBox,
          closeTo(rendered[i], 1e-9),
          reason: DsIconSize.values[i].label,
        );
      }
    });
  });

  group('#sizes', () {
    testWidgets('seven live glyphs, one per rung, each its own size',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final List<DsIcon> ladder = _iconsIn(tester, 'The ladder');
      expect(ladder, hasLength(7));
      expect(ladder.map((DsIcon i) => i.size), DsIconSize.values);
      expect(
        ladder.map((DsIcon i) => i.glyph).toSet(),
        <DsIconGlyph>{DsIconGlyph.packageOpen},
      );
      expect(
        ladder.map((DsIcon i) => i.tone).toSet(),
        <DsIconTone>{DsIconTone.muted},
      );

      // The specimen is the size it names.
      final List<Size> boxes = tester
          .renderObjectList<RenderBox>(find.descendant(
            of: _panel('The ladder'),
            matching: find.byType(DsIcon),
          ))
          .map((RenderBox box) => box.size)
          .toList();
      expect(
        boxes.map((Size s) => s.width),
        <double>[12, 14, 16, 20, 24, 32, 40],
      );
      expect(boxes.map((Size s) => s.height == s.width).toSet(), <bool>{true});
    });

    testWidgets('the ladder prints the object key, not the Dart identifier',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      // `2xl` and `3xl` reach the screen; `xl2` and `xl3` never do.
      for (final DsIconSize size in DsIconSize.values) {
        expect(
          find.text(size.label),
          findsWidgets,
          reason: '${size.name} prints as ${size.label}',
        );
      }
      expect(find.text('2XL'), findsNothing); // `.type-num-sm` does not shout.
      // `.type-micro` does: `text-transform: uppercase` reaches the unit as
      // well as the digits, so the caption under each glyph reads `12PX`. The
      // string is authored lowercase and transformed at paint time, exactly as
      // CSS does it — which is what keeps the copy greppable.
      for (final int px in <int>[12, 14, 16, 20, 24, 32, 40]) {
        expect(find.text('${px}PX'), findsOneWidget, reason: '${px}px');
        expect(find.text('${px}px'), findsNothing);
      }
    });

    testWidgets('every rung states what it is for', (WidgetTester tester) async {
      await _pumpPage(tester);

      // The mono span, a literal space, then the em-dashed sentence.
      expect(
        find.textContaining(
          'xs · 12px — Pips and inline markers inside badges.',
          findRichText: true,
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          '3xl · 40px — Hero and error illustrations.',
          findRichText: true,
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'md · 16px — The default. Inside standard buttons, rows, inputs.',
          findRichText: true,
        ),
        findsOneWidget,
      );
    });
  });

  group('#tones', () {
    testWidgets('ten tones in ICON_TONES order, printed by key',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final List<DsIcon> tones = _iconsIn(tester, 'Ten tones');
      expect(tones, hasLength(10));
      expect(tones.map((DsIcon i) => i.tone), DsIconTone.values);
      // One glyph, ten colours: `Icon icon={Search} size="lg"`.
      expect(
        tones.map((DsIcon i) => i.glyph).toSet(),
        <DsIconGlyph>{DsIconGlyph.search},
      );
      expect(
        tones.map((DsIcon i) => i.size).toSet(),
        <DsIconSize>{DsIconSize.lg},
      );

      // `default` is the printed key; `normal` is the Dart spelling and must
      // not reach the screen.
      expect(find.text('default'), findsOneWidget);
      expect(find.text('normal'), findsNothing);
      for (final DsIconTone tone in DsIconTone.values) {
        expect(find.text(tone.label), findsOneWidget, reason: tone.label);
      }
      expect(
        find.text('Takes the parent colour — the default inside buttons.'),
        findsOneWidget,
      );
    });

    testWidgets('muted and subtle are two names for one colour (I-Q6)',
        (WidgetTester tester) async {
      await _pumpPage(tester);
      final BuildContext context = tester.element(find.text('subtle'));

      // Cells 2 and 3 ship as identical swatches on purpose: `subtle` is a
      // separate *intent*, not a separate token, so the two can diverge later
      // without a rename at every call site.
      expect(
        DsIcon.colorFor(context, DsIconTone.subtle),
        DsIcon.colorFor(context, DsIconTone.muted),
      );
      expect(DsIconTone.subtle.label, isNot(DsIconTone.muted.label));

      // …and `inherit` resolves to plain `--foreground`, because nothing on
      // this page sets a text colour on the panel body.
      expect(
        DsIcon.colorFor(context, DsIconTone.inherit),
        DsTheme.of(context).foreground,
      );
    });
  });

  group('#in-context', () {
    testWidgets('five pairings on five variants, four of them labelled',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final List<DsButton> buttons = tester
          .widgetList<DsButton>(find.descendant(
            of: _panel('Correct pairings'),
            matching: find.byType(DsButton),
          ))
          .toList();
      expect(buttons, hasLength(5));
      expect(
        buttons.map((DsButton b) => b.variant),
        <DsButtonVariant>[
          DsButtonVariant.primary,
          DsButtonVariant.secondary,
          DsButtonVariant.outline,
          DsButtonVariant.destructive,
          DsButtonVariant.ghost,
        ],
      );
      expect(
        buttons.map((DsButton b) => b.size),
        <DsButtonSize>[
          DsButtonSize.md,
          DsButtonSize.md,
          DsButtonSize.md,
          DsButtonSize.md,
          // `size="icon"` — a 40px square with no padding.
          DsButtonSize.icon,
        ],
      );

      for (final String label in <String>['Open Pack', 'Remove']) {
        expect(find.text(label), findsOneWidget, reason: label);
      }
      // Two of the four labels collide with the registry below them: `Search`
      // is also a curated glyph *name*, and `Favourite` is the single meaning
      // `Heart` is pinned to. Both are the page agreeing with itself.
      expect(find.text('Search'), findsNWidgets(2));
      expect(find.text('Favourite'), findsNWidgets(2));
      // Every button is live: a null callback would disable it to opacity 45%.
      expect(buttons.every((DsButton b) => b.onPressed != null), isTrue);
    });

    testWidgets('all five glyphs paint at 16px with stroke 2.4 (drift 2)',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final List<DsIcon> glyphs = _iconsIn(tester, 'Correct pairings');
      expect(glyphs, hasLength(5));
      expect(
        glyphs.map((DsIcon i) => i.glyph),
        <DsIconGlyph>[
          DsIconGlyph.packageOpen,
          DsIconGlyph.heart,
          DsIconGlyph.search,
          DsIconGlyph.trash2,
          DsIconGlyph.heart,
        ],
      );
      // Ruling I-Q3: the reference asks the four labelled buttons for
      // `size="sm"` and the base class list's `size-4` overrides it to 16px,
      // while `strokeWidth` — not being CSS — keeps the value computed for
      // 14px. `strokeFor(14)` and `strokeFor(16)` are both 2.4, so the two
      // coincide and 16px is written directly.
      expect(
        glyphs.map((DsIcon i) => i.size).toSet(),
        <DsIconSize>{DsIconSize.md},
      );
      expect(DsIcon.strokeFor(14), DsIcon.strokeFor(16));
      expect(DsIcon.strokeFor(16), 2.4);

      final Set<Size> boxes = tester
          .renderObjectList<RenderBox>(find.descendant(
            of: _panel('Correct pairings'),
            matching: find.byType(DsIcon),
          ))
          .map((RenderBox box) => box.size)
          .toSet();
      expect(boxes, <Size>{const Size(16, 16)});
    });

    testWidgets('the icon-only button names itself, and takes the value tone',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final List<DsButton> buttons = tester
          .widgetList<DsButton>(find.descendant(
            of: _panel('Correct pairings'),
            matching: find.byType(DsButton),
          ))
          .toList();
      final DsIcon glyph = _iconsIn(tester, 'Correct pairings').last;

      // The accessible name lives on the control, so the glyph carries none
      // and is hidden — the `label` Meta row, demonstrated.
      expect(buttons.last.label, 'Add to favourites');
      expect(glyph.label, isNull);
      expect(find.text('Add to favourites'), findsNothing);

      // DRIFT 3: the description names *destructive* as "the one exception",
      // and the panel then ships a value-toned ghost button as the exception.
      // The destructive button inherits like the rest.
      expect(glyph.tone, DsIconTone.value);
      expect(_toneInside(tester, buttons[3]), DsIconTone.inherit);
    });
  });

  group('#set — the curated 63', () {
    testWidgets('four panels, each noting its own count',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      for (final String label in _groupLabels) {
        expect(_panel(label), findsOneWidget, reason: label);
      }
      for (final String note in <String>[
        '21 glyphs',
        '19 glyphs',
        '11 glyphs',
        '12 glyphs',
      ]) {
        expect(find.text(note), findsOneWidget, reason: note);
      }
      // 21 + 19 + 11 + 12 = 63, and the heading counts the set it stands over.
      expect(find.text('The curated set — 63 glyphs'), findsOneWidget);

      expect(
        find.text(
          'Moving around the product. Directional glyphs only ever point the '
          'way they move.',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'Things the user does. Destructive actions use only Trash2 and Ban.',
        ),
        findsOneWidget,
      );
      // The shouted RARITY and NOT, and the file path as plain text rather
      // than a `Code` chip.
      expect(
        find.text(
          "The product's own vocabulary. Note that RARITY is NOT here — the "
          'eight tiers use their own drawn marks (circle, diamond, star) in '
          'components/pulls/rarity-symbol.tsx, never a Lucide glyph.',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'Wallet and state. Balance types are distinguished by glyph as well '
          'as by colour, so bonus never reads as real money.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('63 tiles in the whitelist\'s order, all 20px and muted',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final List<DsIcon> tiles = <DsIcon>[
        for (final String label in _groupLabels) ..._iconsIn(tester, label),
      ];
      expect(tiles, hasLength(63));
      expect(tiles.map((DsIcon i) => i.glyph).toList(), _curatedOrder);
      expect(
        tiles.map((DsIcon i) => i.size).toSet(),
        <DsIconSize>{DsIconSize.lg},
      );
      expect(
        tiles.map((DsIcon i) => i.tone).toSet(),
        <DsIconTone>{DsIconTone.muted},
      );
      // 20px lands in the ternary's middle branch, where the authored stroke
      // survives untouched.
      expect(DsIcon.strokeFor(20), 2);
    });

    testWidgets('every entry prints its name and its single meaning',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      // The first and last of each group, plus the three deprecated lucide
      // aliases that print under their curated names (ruling I-Q2).
      const Map<String, String> spot = <String, String>{
        'Package': 'Packs — marketplace nav',
        'ExternalLink': 'Leaves the product',
        'PackageOpen': 'Open Pack — the primary action',
        'Check': 'Confirm, selected',
        'Sparkles': 'Reveal and reward moments',
        'TrendingDown': 'Rank down, value loss',
        'CircleDollarSign': 'Available balance',
        'Filter': 'Filter drawer trigger',
        'HelpCircle': 'Help, odds explainer',
        'AlertTriangle': 'Warning state',
        'SlidersHorizontal': 'Sort and advanced filters',
      };
      spot.forEach((String name, String use) {
        expect(find.text(name), findsOneWidget, reason: name);
        expect(find.text(use), findsOneWidget, reason: use);
      });

      // `truncate` is declared and, at this frame, never fires: the longest
      // name fits its column.
      final Text longest = tester.widget<Text>(find.text('SlidersHorizontal'));
      expect(longest.maxLines, 1);
      expect(longest.overflow, TextOverflow.ellipsis);
    });
  });

  group('#rules', () {
    testWidgets('four dos and four donts, contradiction included',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      expect(find.text('DO'), findsOneWidget);
      // `Don&rsquo;t` — a right single quotation mark in the heading only.
      expect(find.text('DON’T'), findsOneWidget);

      expect(
        find.text(
          'Use tone="inherit" inside buttons so the icon follows the button\'s '
          'state.',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'Keep one meaning per glyph: Package is always a pack, Layers is '
          'always the Stash.',
        ),
        findsOneWidget,
      );
      // DRIFT 4: the rule means `<Search />` and typed the component it tells
      // you to use. The angle brackets are literal text and render as such.
      expect(
        find.text(
          "Don't render a raw <Icon icon={Search} /> from lucide-react in a "
          'screen; go through Icon.',
        ),
        findsOneWidget,
      );
      expect(
        find.text("Don't reuse Trash2 or Ban for anything non-destructive."),
        findsOneWidget,
      );
    });

    testWidgets('the closing note names the whitelist in a code chip',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      expect(_chip(tester, 'lib/ds/icons.ts'), 'lib/ds/icons.ts');
      expect(
        find.textContaining(
          'Adding a glyph means adding it there with its single meaning — that '
          'file is the whitelist.',
          findRichText: true,
        ),
        findsOneWidget,
      );
      // No title: the whole note is one muted line.
      final DsNote note = tester.widgetList<DsNote>(find.byType(DsNote)).last;
      expect(note.title, isNull);
      expect(note.tone, DsNoteTone.action);
    });
  });

  group('vertical parity at the 1440 frame', () {
    // Without the reference's own font binaries the test engine measures Ahem,
    // every line height is fiction and every wrap point is wrong — so a
    // geometry assertion made without these is measuring nothing.
    setUpAll(() async {
      await _loadFont('InterLocal', 'InterVariable.ttf');
      await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
      await _loadFont('Redaction35', 'Redaction35-Italic.ttf');
    });

    testWidgets('the reading column is --width-content',
        (WidgetTester tester) async {
      final RenderBox column = await _pumpInShell(tester);
      // Guarded first: every wrap point below, and so every height, depends on
      // this one number.
      expect(column.size.width, DsWidths.content);
    });

    testWidgets('every section lands on the reference',
        (WidgetTester tester) async {
      final RenderBox column = await _pumpInShell(tester);
      final List<({String id, Rect rect})> boxes =
          _sectionBoxes(tester, column);

      expect(
        boxes.map((({String id, Rect rect}) b) => b.id).toList(),
        _webSections.map((_Oracle o) => o.id).toList(),
      );

      // One map, compared whole: a per-section `closeTo` stops at the first
      // failure, and what a parity regression needs to show is the shape of
      // the drift across the page, not its first symptom.
      final Map<String, String> measured = <String, String>{};
      final Map<String, String> oracle = <String, String>{};
      String line(double top, double height) =>
          'top ${top.toStringAsFixed(1)} · h ${height.toStringAsFixed(1)}';

      for (int i = 0; i < _webSections.length; i++) {
        final _Oracle web = _webSections[i];
        final ({double top, double height}) want = _expected(web);
        final Rect got = boxes[i].rect;
        // Quantised to the tolerance so the comparison is the assertion and
        // the printout is the diff.
        double q(double v) => (v / _tolerance).roundToDouble() * _tolerance;
        measured[web.id] = line(q(got.top), q(got.height));
        oracle[web.id] = line(q(want.top), q(want.height));
      }
      expect(measured, oracle);
    });

    testWidgets('the column stacks to the reference, less the sanctioned line',
        (WidgetTester tester) async {
      final RenderBox column = await _pumpInShell(tester);
      expect(
        column.size.height,
        closeTo(_webColumnHeight - _oneCodeLine, _tolerance),
      );
    });
  });

  group('both themes', () {
    testWidgets('the page assembles the same way on light',
        (WidgetTester tester) async {
      await _pumpPage(tester, mode: DsThemeMode.light);

      expect(find.byType(DsSection), findsNWidgets(6));
      expect(find.text('The curated set — 63 glyphs'), findsOneWidget);
      expect(
        <DsIcon>[
          for (final String label in _groupLabels) ..._iconsIn(tester, label),
        ],
        hasLength(63),
      );
      expect(find.text('PREVIOUS'), findsOneWidget);
      expect(find.text('NEXT'), findsNothing);
    });

    testWidgets('the tones resolve through the live theme, and follow it',
        (WidgetTester tester) async {
      final DsThemeController theme = await _pumpPage(tester);
      BuildContext context = tester.element(find.text('error'));

      expect(
        DsIcon.colorFor(context, DsIconTone.error),
        DsThemeData.dark.destructiveInk,
      );
      expect(
        DsIcon.colorFor(context, DsIconTone.normal),
        DsThemeData.dark.foreground,
      );

      theme.setMode(DsThemeMode.light);
      await tester.pump();
      context = tester.element(find.text('error'));

      // `#f87171` on dark, `hsl(0 72.2% 46%)` on light — the tone is a token,
      // and a token is what flips.
      expect(
        DsIcon.colorFor(context, DsIconTone.error),
        DsThemeData.light.destructiveInk,
      );
      expect(
        DsIcon.colorFor(context, DsIconTone.normal),
        DsThemeData.light.foreground,
      );
      expect(
        DsThemeData.light.destructiveInk,
        isNot(DsThemeData.dark.destructiveInk),
      );
    });
  });
}

/// Where the reference puts [web]'s top in the reading column, and how tall the
/// Flutter box that stands in for it should be.
///
/// Two adjustments, and only two. Every `DsSection` box carries its own
/// `mb-20`, which `getBoundingClientRect()` leaves out — so 80px goes on every
/// height. And the sanctioned I-Q1 line comes off `#component`'s height, which
/// pulls every section below it up by exactly the same amount.
({double top, double height}) _expected(_Oracle web) {
  final bool isComponent = web.id == 'component';
  return (
    top: web.top - _columnTop - (isComponent ? 0 : _oneCodeLine),
    height: web.height + _sectionMargin - (isComponent ? _oneCodeLine : 0),
  );
}

/// The tone of the one glyph inside [button].
DsIconTone _toneInside(WidgetTester tester, DsButton button) => tester
    .widgetList<DsIcon>(
      find.descendant(
        of: find.byWidget(button),
        matching: find.byType(DsIcon),
      ),
    )
    .single
    .tone;
