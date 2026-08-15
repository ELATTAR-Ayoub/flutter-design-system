/// The buttons page, held to `buttons-map.md` §1–14.
///
/// The page's subject is the control the whole product presses, so what is
/// worth pinning here is that the specimens really are that control — eight
/// live variants, five real rungs, four wheels that roll, a group whose pill
/// travels — and that the copy around them is the reference's own, drift
/// included. The component state matrices are pinned by the package suite;
/// this file pins **page** geometry and **page** copy, and asserts a
/// component's internals only where the page is what makes them visible (the
/// no-op Hover cell, the caps rung's smaller label).
///
/// No `pumpAndSettle` anywhere: the harness mounts the page under
/// `disableAnimations`, which is the reduced-motion gate every controller in
/// the package routes through, so a single `pump` is a finished frame. The
/// spinner in the Loading cell, the foil on four premium buttons and the four
/// IconSwap wheels are all loopers; settling them is not a thing that happens.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/buttons.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/// Desktop, above `lg`: the variants grid is 4-up and the states grid is the
/// single clean row of five it is only ever composed at. Tall enough that the
/// whole page lays out in one pass, so every finder reaches below the fold.
const Size _viewport = Size(1440, 9000);

const String _route = '$dsRoot/components/base/buttons';

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
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: DefaultTextStyle(
                // `<body class="… text-foreground">`. The shell states this and
                // this harness mounts the page without the shell, so it has to
                // be restated: the four `icon-*` rungs declare no `text-*` at
                // all and inherit whatever the page is set in.
                style: DsText.styleOf(
                  context,
                  DsType.body,
                  color: DsTheme.of(context).foreground,
                ),
                child: const SingleChildScrollView(child: ButtonsPage()),
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
  addTearDown(theme.dispose);
  final AppRouter router = AppRouter(route: _route);
  addTearDown(router.dispose);

  await tester.pumpWidget(_harness(theme, router));
  await tester.pump();
  return theme;
}

/// The panel whose header strip reads [label].
Finder _panel(String label) => find.byWidgetPredicate(
      (Widget widget) => widget is DsPanel && widget.label == label,
    );

/// Every [DsButton] inside the panel labelled [label], in reading order.
List<DsButton> _buttonsIn(WidgetTester tester, String label) => tester
    .widgetList<DsButton>(
      find.descendant(of: _panel(label), matching: find.byType(DsButton)),
    )
    .toList();

/// The cell whose `.type-micro` label reads [label].
Finder _cell(String label) => find.byWidgetPredicate(
      (Widget widget) => widget is DsStateCell && widget.label == label,
    );

/// The one button standing in the cell labelled [label].
DsButton _cellButton(WidgetTester tester, String label) => tester
    .widgetList<DsButton>(
      find.descendant(of: _cell(label), matching: find.byType(DsButton)),
    )
    .single;

/// The four demo captions, in the order the wrap renders them.
List<String> _swapCaptions(WidgetTester tester) => tester
    .widgetList<DsText>(
      find.descendant(
        of: _panel('IconSwap — the two-state control'),
        matching: find.byType(DsText),
      ),
    )
    .where((DsText text) => text.spec == DsType.micro)
    .map((DsText text) => text.text)
    .toList();

/* ── Vertical parity ─────────────────────────────────────────────────────── */

/// The reference's own frame.
const Size _referenceFrame = Size(1440, 900);

/// Where the reading column starts in the document: `main` sits under the 64px
/// sticky header and opens with `py-12`.
const double _columnTop = DsWidths.siteHeader + 48;

/// A `DsSection`'s box carries its own `mb-20`; `getBoundingClientRect()` on
/// the web's `<section>` does not include the margin. 80px, once per section —
/// which is also why every web top below is the previous top plus the previous
/// height plus exactly this.
const double _sectionMargin = 80;

/// The live reference, measured at 1440×900 light with fonts loaded, as
/// document offsets.
typedef _Oracle = ({String id, double top, double height});

const List<_Oracle> _webSections = <_Oracle>[
  (id: 'variants', top: 407.9, height: 502.6),
  (id: 'sizes', top: 990.5, height: 437.3),
  (id: 'states', top: 1507.8, height: 444),
  (id: 'icons', top: 2031.8, height: 417.2),
  (id: 'groups', top: 2529, height: 332.8),
  (id: 'toggle', top: 2941.8, height: 708.3),
  (id: 'kbd', top: 3730.1, height: 256.8),
  (id: 'api', top: 4066.9, height: 274.8),
  (id: 'rules', top: 4421.7, height: 292.8),
];

/// `main`'s own height less its `py-12`: the reading column, web side.
const double _webColumnHeight = 4879.5 - 96;

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

  final DsThemeController theme = DsThemeController(mode: DsThemeMode.light);
  final AppRouter router = AppRouter(route: _route);
  addTearDown(theme.dispose);
  addTearDown(router.dispose);

  // `main.dart` has no `buttons` arm yet — the supervisor wires it at
  // integration — so the page is handed to the shell directly.
  const Widget page = ButtonsPage();
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
  await tester.pump();
  return tester.renderObject<RenderBox>(find.byWidget(page));
}

/// Every `DsSection`'s box, in the reading column's coordinates.
List<({String id, Rect rect})> _sectionBoxes(
  WidgetTester tester,
  RenderBox column,
) =>
    <({String id, Rect rect})>[
      for (final Element element in find.byType(DsSection).evaluate().toList())
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
    testWidgets('the header composes its eyebrow, and says Base twice',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      // DRIFT 1. `.type-label` uppercases at paint time, so the composed
      // string reaches the screen shouted — and the separator is U+00B7.
      expect(find.text('BASE COMPONENTS · BASE'), findsOneWidget);
      expect(find.text('Buttons'), findsOneWidget);
      expect(
        find.text(
          'Every variant, size and state, including the lime premium action '
          'reserved for money and reward moments.',
        ),
        findsOneWidget,
      );

      // Six chips against nine sections: the chip list is the registry's, and
      // `IconSwap` — a third of `#toggle` — has no chip (ruling B1).
      for (final String chip in <String>[
        'Button',
        'Button Group',
        'Icon Button',
        'Toggle',
        'Toggle Group',
        'Kbd',
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
    });

    testWidgets('nine sections, in the reference\'s order',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final List<DsSection> sections =
          tester.widgetList<DsSection>(find.byType(DsSection)).toList();
      expect(
        sections.map((DsSection s) => s.id),
        <String>[
          'variants',
          'sizes',
          'states',
          'icons',
          'groups',
          'toggle',
          'kbd',
          'api',
          'rules',
        ],
      );
      expect(
        sections.map((DsSection s) => s.title),
        <String>[
          'Variants',
          'Sizes',
          'States',
          'Icons and icon-only buttons',
          'Button Group',
          // A literal ampersand, not an entity.
          'Toggle & Toggle Group',
          'Kbd',
          'API',
          'Rules',
        ],
      );
      // `#api` and `#rules` are the two sections with no description; every
      // other one carries the reference's own sentence.
      expect(
        sections.map((DsSection s) => s.description == null),
        <bool>[false, false, false, false, false, false, false, true, true],
      );
      expect(
        sections[2].description,
        'Hover, focus and active are live below — interact with them '
        'directly. Disabled and loading are shown as rendered.',
      );
      expect(
        sections[5].description,
        'For state that persists rather than actions that fire. View mode, '
        'favourite, and filter chips that stay on.',
      );
    });

    testWidgets('the foot nav is next-only, and keeps half the row',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      // `buttons` is index 0 of `base` — the first page in the corpus whose
      // foot nav is missing its *left* half.
      expect(find.text('PREVIOUS'), findsNothing);
      expect(find.text('NEXT'), findsOneWidget);
      expect(find.text('Inputs'), findsOneWidget);

      final double nav = tester.getSize(find.byType(DsPageFootNav)).width;
      final double card = tester
          .getSize(find.descendant(
            of: find.byType(DsPageFootNav),
            matching: find.byType(DsPress),
          ))
          .width;
      expect(card, closeTo((nav - ds(4)) / 2, 0.01));
    });
  });

  group('#variants', () {
    testWidgets('eight cells, seven variants and one emphasis axis',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final List<DsStateCell> cells = tester
          .widgetList<DsStateCell>(find.byType(DsStateCell))
          .take(8)
          .toList();
      expect(
        cells.map((DsStateCell c) => c.label),
        <String>[
          'default',
          'premium',
          'secondary',
          'outline',
          'ghost',
          'destructive',
          'link',
          'premium + caps',
        ],
      );
      expect(
        cells.map((DsStateCell c) => c.note),
        <String>[
          'Primary action. Blue.',
          'Money & reward. Lime.',
          'Neutral, beside a primary.',
          'Must not compete.',
          'Toolbars, dismissals.',
          'Sell back, delete.',
          'Inline text action.',
          'Hero CTA treatment.',
        ],
      );

      for (final (String, String) pair in <(String, String)>[
        ('default', 'Open Pack'),
        ('premium', 'Deposit Funds'),
        ('secondary', 'View Hits'),
        ('outline', 'Filters'),
        ('ghost', 'Skip'),
        ('destructive', 'Sell All'),
        ('link', 'Forgot password?'),
        // `uppercase` is a paint-time transform, so the eighth label is the
        // only one whose rendered string differs from its source.
        ('premium + caps', 'CLAIM REWARD'),
      ]) {
        expect(
          find.descendant(of: _cell(pair.$1), matching: find.text(pair.$2)),
          findsOneWidget,
          reason: pair.$1,
        );
      }

      // The eighth cell is the seventh variant again with the third axis on
      // top — the grid shows seven variants in eight cells.
      expect(
        <DsButtonVariant>[
          for (final String label in <String>[
            'default',
            'premium',
            'secondary',
            'outline',
            'ghost',
            'destructive',
            'link',
            'premium + caps',
          ])
            _cellButton(tester, label).variant,
        ],
        <DsButtonVariant>[
          DsButtonVariant.primary,
          DsButtonVariant.premium,
          DsButtonVariant.secondary,
          DsButtonVariant.outline,
          DsButtonVariant.ghost,
          DsButtonVariant.destructive,
          DsButtonVariant.link,
          DsButtonVariant.premium,
        ],
      );
      // All eight at the `default` rung, all eight live.
      expect(
        <DsButtonSize>{
          for (final DsButton b in _cellsButtons(tester, 8)) b.size,
        },
        <DsButtonSize>{DsButtonSize.md},
      );
    });

    testWidgets('the caps cell is smaller than the seven beside it (drift 22)',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final DsButton caps = _cellButton(tester, 'premium + caps');
      expect(caps.emphasis, DsButtonEmphasis.caps);

      // `emphasis` is checked before `size`, because cva emits it last.
      final BuildContext context = tester.element(find.byWidget(caps));
      final TextStyle capsStyle = DsText.styleOf(
        context,
        DsButton.typeFor(DsButtonSize.md, DsButtonEmphasis.caps)!,
      );
      final TextStyle plainStyle = DsText.styleOf(
        context,
        DsButton.typeFor(DsButtonSize.md, DsButtonEmphasis.none)!,
      );
      expect(capsStyle.fontSize, lessThan(plainStyle.fontSize!));

      // `text-transform` is a paint-time transform, and it does not reach the
      // accessible name: the screen shouts and the label stays as authored.
      expect(find.text('CLAIM REWARD'), findsOneWidget);
      expect(find.text('Claim Reward'), findsNothing);
      expect(
        tester.widget<Text>(find.text('CLAIM REWARD')).semanticsLabel,
        'Claim Reward',
      );
    });

    testWidgets('the lime note names the variant in a code chip',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      // A `DsNote` title is muted-foreground in every tone, so it shouts.
      expect(find.text('THE LIME BUTTON IS RATIONED'), findsOneWidget);
      expect(_chip(tester, 'premium'), 'premium');
      expect(
        find.textContaining(
          'is the only variant permitted to glow, and only on hover. Use it '
          'for depositing, claiming, purchasing and confirming a withdrawal. '
          'A lime Cancel button would be a bug.',
          findRichText: true,
        ),
        findsOneWidget,
      );
      final DsNote note =
          tester.widgetList<DsNote>(find.byType(DsNote)).single;
      expect(note.tone, DsNoteTone.value);
    });
  });

  group('#sizes', () {
    testWidgets('five rungs, five heights, one shared baseline',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final List<DsButton> ladder = _buttonsIn(tester, 'The ladder');
      expect(ladder, hasLength(5));
      expect(
        ladder.map((DsButton b) => b.size),
        <DsButtonSize>[
          DsButtonSize.xs,
          DsButtonSize.sm,
          DsButtonSize.md,
          DsButtonSize.lg,
          DsButtonSize.xl,
        ],
      );
      expect(
        <String>['Extra small', 'Small', 'Medium', 'Large', 'Hero']
            .map((String l) => find.text(l).evaluate().length)
            .toSet(),
        <int>{1},
      );

      final List<Rect> boxes = tester
          .renderObjectList<RenderBox>(find.descendant(
            of: _panel('The ladder'),
            matching: find.byType(DsButton),
          ))
          .map((RenderBox box) =>
              box.localToGlobal(Offset.zero) & box.size)
          .toList();
      expect(
        boxes.map((Rect r) => r.height),
        <double>[24, 32, 40, 48, 56],
      );
      // `align="end"`: the caption block is identical under all five columns,
      // so aligning the columns' bottoms aligns the buttons' bottoms too.
      expect(
        boxes.map((Rect r) => (r.bottom * 100).round()).toSet(),
        hasLength(1),
      );
    });

    testWidgets('the ladder caption shouts and the use list does not',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      // `.type-micro` uppercases; `.type-num-sm` does not — and the same five
      // strings appear under both classes.
      for (final String rung in <String>[
        'xs · 24px',
        'sm · 32px',
        'default · 40px',
        'lg · 48px',
        'xl · 56px',
      ]) {
        expect(find.text(rung.toUpperCase()), findsOneWidget, reason: rung);
        expect(find.text(rung), findsNothing, reason: rung);
      }

      // The mono span, a literal space, then the em-dashed sentence.
      expect(
        find.textContaining(
          'xs · 24px — Chips inside a combobox. Internal use only.',
          findRichText: true,
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'default · 40px — The standard. Forms, dialogs, most actions.',
          findRichText: true,
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'xl · 56px — Landing hero and headline moments. Once per screen.',
          findRichText: true,
        ),
        findsOneWidget,
      );
    });
  });

  group('#states', () {
    testWidgets('five cells, and Hover is pixel-identical to Default (drift 13)',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final List<DsStateCell> cells = tester
          .widgetList<DsStateCell>(find.byType(DsStateCell))
          .skip(8)
          .take(5)
          .toList();
      expect(
        cells.map((DsStateCell c) => c.label),
        <String>['Default', 'Hover', 'Focus', 'Loading', 'Disabled'],
      );
      expect(
        cells.map((DsStateCell c) => c.note),
        <String?>[null, 'Hover it', 'Tab to it', 'Disabled, width held',
          '45% opacity'],
      );

      // `bg-action` repaints the colour `--primary` already is, in both
      // themes — which is why the cell that names hover shows none.
      expect(DsThemeData.dark.primary, DsPalette.action);
      expect(DsThemeData.light.primary, DsPalette.action);

      final DsButton fallback = _cellButton(tester, 'Default');
      final DsButton hover = _cellButton(tester, 'Hover');
      expect(hover.variant, fallback.variant);
      expect(hover.size, fallback.size);
      expect(hover.emphasis, fallback.emphasis);
      expect(
        tester.getSize(find.byWidget(hover)),
        tester.getSize(find.byWidget(fallback)),
      );
    });

    testWidgets('Loading is a busy disabled button; Disabled is a dead one',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final DsButton loading = _cellButton(tester, 'Loading');
      expect(loading.loading, isTrue);
      expect(loading.onPressed, isNull);
      // The spinner is prepended, not swapped in: the label is still there.
      expect(
        find.descendant(
          of: _cell('Loading'),
          matching: find.text('Open Pack'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: _cell('Loading'),
          matching: find.byType(DsSpinner),
        ),
        findsOneWidget,
      );

      final DsButton dead = _cellButton(tester, 'Disabled');
      expect(dead.loading, isFalse);
      expect(dead.onPressed, isNull);
      expect(
        find.descendant(
          of: _cell('Disabled'),
          matching: find.byType(DsSpinner),
        ),
        findsNothing,
      );

      // DRIFT 3, measured. "Disabled, width held" — and the prepended spinner
      // makes the Loading button exactly one glyph plus one gap wider.
      final double held = tester.getSize(find.byWidget(dead)).width;
      final double busy = tester.getSize(find.byWidget(loading)).width;
      expect(
        busy - held,
        closeTo(DsSpinner.px + DsButton.gapFor(DsButtonSize.md), 0.01),
      );
    });

    testWidgets('Focus is a drawn still, not a focused control (drift 14)',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final DsButton still = _cellButton(tester, 'Focus');
      // The ring and the border are painted over the button's own box, so the
      // still measures exactly what the resting cell beside it does.
      expect(
        tester.getSize(find.byWidget(still)),
        tester.getSize(find.byWidget(_cellButton(tester, 'Default'))),
      );
      final DsMachineSurface overlay = tester
          .widgetList<DsMachineSurface>(
            find.descendant(
              of: _cell('Focus'),
              matching: find.byType(DsMachineSurface),
            ),
          )
          .last;
      expect(overlay.spec.layers, hasLength(1));
      expect(overlay.spec.hasInset, isFalse);
      // The still is drawn, not held. The cell owns no focus node and nothing
      // inside it holds the page's focus — a genuinely focused specimen would
      // take focus on load and lose the state on the first Tab, which is not
      // what the reference renders.
      expect(still.focusNode, isNull);
      final BuildContext? holder =
          tester.binding.focusManager.primaryFocus?.context;
      expect(holder?.findAncestorWidgetOfExactType<DsStateCell>(), isNull);
    });

    testWidgets('six live variants, link excluded, and the 97% caption',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final List<DsButton> live =
          _buttonsIn(tester, 'Live — press and hold, or tab through');
      expect(
        live.map((DsButton b) => b.variant),
        <DsButtonVariant>[
          DsButtonVariant.primary,
          DsButtonVariant.premium,
          DsButtonVariant.secondary,
          DsButtonVariant.outline,
          DsButtonVariant.ghost,
          DsButtonVariant.destructive,
        ],
      );
      expect(live.every((DsButton b) => b.onPressed != null), isTrue);
      for (final String label in <String>[
        'Primary',
        'Premium',
        'Secondary',
        'Outline',
        'Ghost',
        'Destructive',
      ]) {
        expect(find.text(label), findsOneWidget, reason: label);
      }

      // DRIFT 2: three numbers, none of them the one the spring runs.
      expect(
        find.text(
          'Press scales to 97% over 150ms. Focus draws a blue ring that is '
          'never removed. Both behaviours are built into the variant base '
          'class, so no component has to remember them.',
        ),
        findsOneWidget,
      );
      expect(DsTransforms.buttonScale, 0.95);
    });
  });

  group('#icons', () {
    testWidgets('four labelled buttons, icon leading, all 16px (drift 6)',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final List<DsButton> labelled = _buttonsIn(tester, 'With a label');
      expect(
        labelled.map((DsButton b) => b.variant),
        <DsButtonVariant>[
          DsButtonVariant.primary,
          DsButtonVariant.premium,
          DsButtonVariant.secondary,
          DsButtonVariant.destructive,
        ],
      );
      for (final String label in <String>[
        'Open Pack',
        'Deposit Funds',
        'Share Pull',
        'Sell Selected',
      ]) {
        expect(
          find.descendant(
            of: _panel('With a label'),
            matching: find.text(label),
          ),
          findsOneWidget,
          reason: label,
        );
      }

      // The reference declares 14 and the base class list renders 16; the two
      // strokes coincide, which is the only reason it is invisible.
      final Set<Size> boxes = tester
          .renderObjectList<RenderBox>(find.descendant(
            of: _panel('With a label'),
            matching: find.byType(DsIcon),
          ))
          .map((RenderBox box) => box.size)
          .toSet();
      expect(boxes, <Size>{const Size(16, 16)});
      expect(DsIcon.strokeFor(14), DsIcon.strokeFor(16));

      // The glyph leads the label, spaced by the rung's own gap.
      final Rect glyph = tester.getRect(find.descendant(
        of: _panel('With a label'),
        matching: find.byType(DsIcon),
      ).first);
      final Rect text = tester.getRect(find.descendant(
        of: _panel('With a label'),
        matching: find.text('Open Pack'),
      ));
      expect(glyph.right, lessThan(text.left));
      expect(
        text.left - glyph.right,
        closeTo(DsButton.gapFor(DsButtonSize.md), 0.01),
      );
    });

    testWidgets('four icon-only buttons, each carrying its own name',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final List<DsButton> only = _buttonsIn(tester, 'Icon only');
      expect(
        only.map((DsButton b) => b.size),
        <DsButtonSize>[
          DsButtonSize.iconSm,
          DsButtonSize.icon,
          DsButtonSize.iconLg,
          DsButtonSize.icon,
        ],
      );
      expect(
        only.map((DsButton b) => b.variant),
        <DsButtonVariant>[
          DsButtonVariant.ghost,
          DsButtonVariant.outline,
          DsButtonVariant.primary,
          DsButtonVariant.ghost,
        ],
      );
      expect(
        only.map((DsButton b) => b.label),
        <String>[
          'Search packs',
          'Add to favourites',
          'Open pack',
          'Favourite this card',
        ],
      );
      // The name lives on the control, so no glyph carries one and none of the
      // four strings is rendered as copy.
      for (final DsIcon glyph in tester.widgetList<DsIcon>(find.descendant(
        of: _panel('Icon only'),
        matching: find.byType(DsIcon),
      ))) {
        expect(glyph.label, isNull);
      }
      expect(find.text('Search packs'), findsNothing);

      // Squares, and their glyphs at the rung's own px — the one panel where
      // the declared size and the rendered size agree.
      expect(
        tester
            .renderObjectList<RenderBox>(find.descendant(
              of: _panel('Icon only'),
              matching: find.byType(DsButton),
            ))
            .map((RenderBox box) => box.size)
            .toList(),
        <Size>[
          const Size(32, 32),
          const Size(40, 40),
          const Size(48, 48),
          const Size(40, 40),
        ],
      );
      expect(
        tester
            .renderObjectList<RenderBox>(find.descendant(
              of: _panel('Icon only'),
              matching: find.byType(DsIcon),
            ))
            .map((RenderBox box) => box.size.width)
            .toList(),
        <double>[14, 16, 20, 16],
      );

      // The last glyph is the one icon on the page that does not inherit its
      // button's ink.
      final List<DsIcon> glyphs = tester
          .widgetList<DsIcon>(find.descendant(
            of: _panel('Icon only'),
            matching: find.byType(DsIcon),
          ))
          .toList();
      expect(glyphs.last.tone, DsIconTone.value);
      expect(
        glyphs.take(3).map((DsIcon i) => i.tone).toSet(),
        <DsIconTone>{DsIconTone.inherit},
      );

      expect(
        find.text(
          'The last button uses the lime tone deliberately — a favourited '
          'card is a value signal, and that is one of lime’s permitted jobs.',
        ),
        findsOneWidget,
      );
      // The panel's `note` slot, used exactly once on the page.
      expect(
        tester
            .widgetList<DsPanel>(find.byType(DsPanel))
            .where((DsPanel p) => p.note != null)
            .map((DsPanel p) => p.note),
        <String>['aria-label required'],
      );
    });
  });

  group('#groups', () {
    testWidgets('three groups, flush, 40px tall', (WidgetTester tester) async {
      await _pumpPage(tester);

      final List<DsButtonGroup> groups =
          tester.widgetList<DsButtonGroup>(find.byType(DsButtonGroup)).toList();
      expect(groups, hasLength(3));
      expect(
        groups.map((DsButtonGroup g) => g.children.length),
        <int>[3, 5, 3],
      );

      for (final Size size in tester
          .renderObjectList<RenderBox>(find.byType(DsButtonGroup))
          .map((RenderBox box) => box.size)) {
        expect(size.height, ds(10));
      }

      for (final String label in <String>[
        'Newest',
        'Price',
        'Popularity',
        'Quantity',
        'Open Pack',
      ]) {
        expect(
          find.descendant(
            of: _panel('Segmented actions'),
            matching: find.text(label),
          ),
          findsOneWidget,
          reason: label,
        );
      }
      // The numeric cell and the three named steppers.
      expect(
        tester
            .widgetList<DsButtonGroupText>(find.byType(DsButtonGroupText))
            .map((DsButtonGroupText t) => (t.text, t.numeric))
            .toList(),
        <(String, bool)>[('Quantity', false), ('3', true)],
      );
      expect(
        _buttonsIn(tester, 'Segmented actions')
            .map((DsButton b) => b.label)
            .whereType<String>()
            .toList(),
        <String>[
          'Decrease quantity',
          'Increase quantity',
          'More open options',
        ],
      );
      expect(find.byType(DsButtonGroupSeparator), findsNWidgets(2));
    });
  });

  group('#toggle', () {
    testWidgets('three toggles: off, on, and one that cannot move',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      List<DsToggle> toggles() => tester
          .widgetList<DsToggle>(
            find.descendant(
              of: _panel('Toggle'),
              matching: find.byType(DsToggle),
            ),
          )
          .toList();

      expect(toggles(), hasLength(3));
      expect(
        toggles().map((DsToggle t) => t.pressed),
        <bool>[false, true, false],
      );
      expect(
        toggles().map((DsToggle t) => t.label),
        <String>['Favourite', 'Favourite, on', 'Favourite, unavailable'],
      );
      // A null handler is `disabled`.
      expect(toggles().last.onChanged, isNull);

      // Genuinely interactive (ruling B6).
      await tester.tap(find.byWidget(toggles().first));
      await tester.pump();
      expect(toggles().first.pressed, isTrue);
      await tester.tap(find.byWidget(toggles()[1]));
      await tester.pump();
      expect(toggles()[1].pressed, isFalse);

      // DRIFT 5: the caption promises blue and the fill is `--muted`.
      expect(
        find.text(
          'Off · On · Disabled. The pressed state fills with the blue tint — '
          'selection is always blue.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('the group selects, travels and deselects (ruling B7)',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      DsToggleGroup group() =>
          tester.widget<DsToggleGroup>(find.byType(DsToggleGroup));

      expect(
        group().items.map((DsToggleGroupItem i) => i.label),
        <String>['Newest', 'Price', 'Popular'],
      );
      // `defaultValue="newest"`.
      expect(group().selectedIndex, 0);

      // Scoped: `#groups` renders a Price button of its own two sections up,
      // which is the page agreeing with itself about what a sort control is
      // called.
      expect(find.text('Price'), findsNWidgets(2));
      final Finder price = find.descendant(
        of: find.byType(DsToggleGroup),
        matching: find.text('Price'),
      );

      await tester.tap(price);
      await tester.pump();
      expect(group().selectedIndex, 1);

      // Radix `type="single"` clears on a second click of the active option,
      // and the pill fades out where it stands.
      await tester.tap(price);
      await tester.pump();
      expect(group().selectedIndex, isNull);

      expect(
        find.text(
          'A toggle group is for three or more mutually exclusive options. '
          'With exactly two, use IconSwap below — a segmented control for a '
          'binary choice wastes space and reads as weaker than it is.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('four wheels, each rolling its own pair',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      final Finder panel = _panel('IconSwap — the two-state control');
      final List<DsIconSwap> wheels = tester
          .widgetList<DsIconSwap>(
            find.descendant(of: panel, matching: find.byType(DsIconSwap)),
          )
          .toList();
      expect(wheels, hasLength(4));
      // Window and cell: 20/16 on three, 24/20 on the play/pause one.
      expect(
        wheels.map((DsIconSwap s) => (s.window, s.cell)),
        <(double, double)>[(20, 16), (24, 20), (20, 16), (20, 16)],
      );
      expect(
        wheels.map((DsIconSwap s) => s.icons.length).toSet(),
        <int>{2},
      );
      expect(
        wheels.map((DsIconSwap s) => s.activeIndex),
        <int>[0, 0, 0, 0],
        reason: 'all four start at strip index 0, so the first click rolls up',
      );

      final List<DsButton> hosts = tester
          .widgetList<DsButton>(
            find.descendant(of: panel, matching: find.byType(DsButton)),
          )
          .toList();
      expect(
        hosts.map((DsButton b) => (b.variant, b.size)),
        <(DsButtonVariant, DsButtonSize)>[
          (DsButtonVariant.outline, DsButtonSize.icon),
          (DsButtonVariant.primary, DsButtonSize.iconLg),
          (DsButtonVariant.secondary, DsButtonSize.icon),
          (DsButtonVariant.ghost, DsButtonSize.icon),
        ],
      );
      expect(
        hosts.map((DsButton b) => b.label),
        <String>['Switch to list view', 'Play', 'Add to favourites', 'Mute'],
      );

      expect(
        _swapCaptions(tester),
        <String>['View · grid', 'Paused', 'Not favourited', 'Sound on'],
      );

      // Every one of them flips, and the name flips with the caption — which
      // is the point of the closing copy.
      for (final DsButton host in hosts) {
        await tester.tap(find.byWidget(host));
        await tester.pump();
      }
      expect(
        _swapCaptions(tester),
        <String>['View · list', 'Playing', 'Favourited', 'Muted'],
      );
      expect(
        tester
            .widgetList<DsButton>(
              find.descendant(of: panel, matching: find.byType(DsButton)),
            )
            .map((DsButton b) => b.label),
        <String>[
          'Switch to grid view',
          'Pause',
          'Remove from favourites',
          'Unmute',
        ],
      );
      expect(
        tester
            .widgetList<DsIconSwap>(
              find.descendant(of: panel, matching: find.byType(DsIconSwap)),
            )
            .map((DsIconSwap s) => s.activeIndex),
        <int>[1, 1, 1, 1],
      );
    });

    testWidgets('the panel copy, and its three code chips',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      // DRIFT 20: "No crossfades" — and the roll transitions opacity on the
      // same spring as the transform.
      expect(
        find.text(
          'Every control that alternates between two icons swaps them through '
          'a vertical strip. Click each one: the icons are a physical wheel, '
          'so the old icon exits through the top and the next rises from '
          'below, landing with a jelly squash. No crossfades, no instant '
          'swaps — a control that changed meaning should show you that it '
          'changed.',
        ),
        findsOneWidget,
      );
      for (final String chip in <String>[
        'IconSwap',
        'aria-label',
        'aria-pressed',
      ]) {
        expect(_chip(tester, chip), chip, reason: chip);
      }
      expect(
        find.textContaining(
          'inside a Button as its child, and give the button an',
          findRichText: true,
        ),
        findsOneWidget,
      );
    });
  });

  group('#kbd', () {
    testWidgets('three hints, one of them a group of two',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      expect(find.byType(DsKbdGroup), findsOneWidget);
      expect(find.byType(DsKbd), findsNWidgets(4));
      expect(
        tester.widgetList<DsKbd>(find.byType(DsKbd)).map((DsKbd k) => k.text),
        <String>['Ctrl', 'K', 'Space', 'Esc'],
      );
      // DRIFT 19: the group renders the same element its members do.
      expect(
        find.descendant(
          of: find.byType(DsKbdGroup),
          matching: find.byType(DsKbd),
        ),
        findsNWidgets(2),
      );

      for (final String hint in <String>[
        'Open search',
        'Reveal next card',
        'Skip the opening sequence',
      ]) {
        expect(find.text(hint), findsOneWidget, reason: hint);
      }
      // 20px tall, whatever it holds.
      for (final Size size in tester
          .renderObjectList<RenderBox>(find.byType(DsKbd))
          .map((RenderBox box) => box.size)) {
        expect(size.height, ds(5));
      }
    });
  });

  group('#api', () {
    testWidgets('five rows, verbatim — icon-xs and asChild included',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      for (final String key in <String>[
        'variant',
        'size',
        'emphasis',
        'loading',
        'asChild',
      ]) {
        expect(find.text(key), findsOneWidget, reason: key);
      }

      // The `size` row is the authority for the nine-rung ladder, and it names
      // `icon-xs`, which nothing on the page renders (drift 17). Built anyway
      // (ruling B3), so the printed row is true.
      expect(
        find.textContaining(
          'xs · sm · default · lg · xl · icon-xs · icon-sm · icon · icon-lg. '
          'Default: default.',
          findRichText: true,
        ),
        findsOneWidget,
      );
      expect(DsButtonSize.values, hasLength(9));
      expect(
        DsButtonSize.values.map((DsButtonSize s) => s.name),
        <String>[
          'xs',
          'sm',
          'md',
          'lg',
          'xl',
          'iconXs',
          'iconSm',
          'icon',
          'iconLg',
        ],
      );

      expect(
        find.textContaining(
          'default · premium · secondary · outline · ghost · destructive · '
          'link. Default: default.',
          findRichText: true,
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'none · caps. Caps applies uppercase with 0.09em tracking, for '
          'headline and money CTAs.',
          findRichText: true,
        ),
        findsOneWidget,
      );
      // DRIFT 3, printed a second time.
      expect(
        find.textContaining(
          'Adds a spinner, sets aria-busy and disables the button. The label '
          'stays so width does not jump.',
          findRichText: true,
        ),
        findsOneWidget,
      );
      // Ruling B4: the row ships and the prop does not.
      expect(
        find.textContaining(
          'Renders the child instead of a button — use for links that should '
          'look like buttons.',
          findRichText: true,
        ),
        findsOneWidget,
      );
    });
  });

  group('#rules', () {
    testWidgets('five dos and five donts, the width claim included',
        (WidgetTester tester) async {
      await _pumpPage(tester);

      expect(find.text('DO'), findsOneWidget);
      // `Don&rsquo;t` — a right single quotation mark in the heading only.
      expect(find.text('DON’T'), findsOneWidget);

      // DRIFT 3, a fourth time — and the apostrophes in the donts are the
      // straight ASCII ones.
      expect(
        find.text(
          "Use loading rather than swapping the label to 'Please wait' — the "
          'width stays stable.',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'Use premium lime only for money and reward actions — deposit, '
          'claim, buy, withdraw.',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          "Don't put two blue buttons side by side; make the lesser one "
          'secondary or outline.',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          "Don't write vague labels like Proceed, Continue Process or Submit "
          'Action.',
        ),
        findsOneWidget,
      );

      final DsDoDont rules = tester.widget<DsDoDont>(find.byType(DsDoDont));
      expect(rules.dos, hasLength(5));
      expect(rules.donts, hasLength(5));
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
        final Rect got = boxes[i].rect;
        double q(double v) => (v / _tolerance).roundToDouble() * _tolerance;
        measured[web.id] = line(q(got.top), q(got.height));
        oracle[web.id] = line(
          q(web.top - _columnTop),
          q(web.height + _sectionMargin),
        );
      }
      expect(measured, oracle);
    });

    testWidgets('the column stacks to the reference',
        (WidgetTester tester) async {
      final RenderBox column = await _pumpInShell(tester);
      expect(column.size.height, closeTo(_webColumnHeight, _tolerance));
    });
  });

  group('both themes', () {
    testWidgets('the page assembles the same way on light',
        (WidgetTester tester) async {
      await _pumpPage(tester, mode: DsThemeMode.light);

      expect(find.byType(DsSection), findsNWidgets(9));
      expect(find.byType(DsStateCell), findsNWidgets(13));
      expect(find.byType(DsIconSwap), findsNWidgets(4));
      expect(find.text('BASE COMPONENTS · BASE'), findsOneWidget);
      expect(find.text('NEXT'), findsOneWidget);
      expect(find.text('PREVIOUS'), findsNothing);
    });

    testWidgets('the destructive tint and the lime foil follow the theme',
        (WidgetTester tester) async {
      final DsThemeController theme = await _pumpPage(tester);
      expect(DsThemeData.dark.destructive, DsThemeData.light.destructive);
      // …and its ink does not: the tint is one colour in both themes, the
      // label on it is not.
      expect(
        DsThemeData.dark.destructiveInk,
        isNot(DsThemeData.light.destructiveInk),
      );

      theme.setMode(DsThemeMode.light);
      await tester.pump();
      expect(find.byType(DsStateCell), findsNWidgets(13));
      // The one foreground in the system that does not flip: the foil is an
      // opaque metal ramp, so its label is dark on both pages.
      expect(
        _cellButton(tester, 'premium').variant,
        DsButtonVariant.premium,
      );
    });
  });
}

/// The buttons standing in the first [count] state cells, in reading order.
List<DsButton> _cellsButtons(WidgetTester tester, int count) => tester
    .widgetList<DsButton>(
      find.descendant(
        of: find.byType(DsStateCell),
        matching: find.byType(DsButton),
      ),
    )
    .take(count)
    .toList();
