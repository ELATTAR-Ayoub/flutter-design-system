/// The typography page's contract: every class it claims to specimen is on the
/// page, the copy is the reference's (drift included), and the prose demo
/// exercises the whole `.prose` layer.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/pages/typography.dart';
import 'package:example/shell.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wide enough for `lg` (the two-column [_Spec] split) and tall enough that the
/// whole page lays out in one pass — it is the longest page in the port.
const Size _surface = Size(1440, 4000);

extension on WidgetTester {
  void useViewport(Size size) {
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  }

  /// The page as the shell mounts it: theme scope + router above, one scroll
  /// port around.
  Future<void> pumpPage({AppRouter? router, Size size = _surface}) async {
    useViewport(size);
    await pumpWidget(
      DsTheme(
        controller: DsThemeController(),
        child: AppRouterScope(
          router: router ?? AppRouter(route: '$dsRoot/typography'),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQueryData(size: size),
              child: const SingleChildScrollView(child: TypographyPage()),
            ),
          ),
        ),
      ),
    );
    await pumpAndSettle();
  }
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

TextStyle _styleOf(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text)).style!;

/// Every rendering of [text] — several strings appear more than once on this
/// page, which is the page's own point: a class name is a specimen row *and* a
/// code chip in the prose demo, a figure is a specimen *and* a tabular row.
Iterable<TextStyle> _stylesOf(WidgetTester tester, String text) =>
    tester.widgetList<Text>(find.text(text)).map((Text text) => text.style!);

/// Asserts a `Spec` row for [cls]: the name with its leading dot, in
/// `.type-code text-action-ink`. Chips of the same name elsewhere are muted,
/// so the ink is what identifies the row.
void _expectSpecRow(WidgetTester tester, String cls) {
  final Iterable<TextStyle> row = _stylesOf(tester, cls).where(
    (TextStyle style) => style.color == DsThemeData.dark.actionInk,
  );
  expect(row, hasLength(1), reason: '$cls specimen row missing');
  expect(row.single.fontSize, DsType.code.size);
}

void main() {
  testWidgets('the header states the two-face rule, drift and all', (
    WidgetTester tester,
  ) async {
    await tester.pumpPage();

    expect(find.text('FOUNDATIONS'), findsOneWidget);
    expect(find.text('Typography'), findsOneWidget);
    // Verbatim — it names Space Grotesk while the tokens render Inter.
    expect(
      find.text(
        'Two faces only: Space Grotesk for every word, Geist Mono for every '
        'number. Full specimen of each type class, plus the prose block that '
        'reaches the same scale without one.',
      ),
      findsOneWidget,
    );

    // `findsWidgets`: two of the seven chips name a section further down the
    // page, and the section heading renders the same string.
    for (final String chip in <String>[
      'Display',
      'Headings',
      'Body',
      'Labels',
      'Numerics',
      'Prose',
      'Rules',
    ]) {
      expect(find.text(chip), findsWidgets, reason: 'chip $chip missing');
    }
  });

  testWidgets('#rule mounts a specimen of each face', (
    WidgetTester tester,
  ) async {
    await tester.pumpPage();

    expect(find.text('SPACE GROTESK — WORDS'), findsOneWidget);
    expect(find.text('GEIST MONO — NUMERICAL VALUES'), findsOneWidget);

    // `type-display text-foreground` against `type-num-xl text-value-ink`.
    final TextStyle words = _styleOf(tester, 'Aa');
    expect(words.fontSize, DsType.displaySize(_surface.width));
    expect(words.color, DsThemeData.dark.foreground);

    final TextStyle numbers = _styleOf(tester, '0123');
    expect(numbers.fontSize, DsType.numXl.size);
    expect(numbers.color, DsThemeData.dark.valueInk);

    expect(find.text('--font-sans'), findsOneWidget);
    expect(find.text('--font-mono'), findsOneWidget);
    expect(find.text('THE RULE'), findsOneWidget);
    expect(
      find.textContaining('Words use Space Grotesk through', findRichText: true),
      findsOneWidget,
    );
  });

  testWidgets('#words specimens all ten classes it stacks', (
    WidgetTester tester,
  ) async {
    await tester.pumpPage();

    // The description says nine; the reference shows ten. Both are kept.
    expect(
      find.textContaining('Nine classes cover every piece of text'),
      findsOneWidget,
    );

    for (final String cls in <String>[
      '.type-display',
      '.type-h1',
      '.type-h2',
      '.type-h3',
      '.type-h4',
      '.type-lead',
      '.type-body',
      '.type-small',
      '.type-label',
      '.type-micro',
    ]) {
      _expectSpecRow(tester, cls);
    }

    // The samples themselves, at the size their class declares.
    final TextStyle display = _styleOf(tester, 'Pull something legendary');
    expect(display.fontSize, DsType.displaySize(_surface.width));

    expect(_styleOf(tester, 'Pack Marketplace').fontSize,
        DsType.h1Size(_surface.width));
    expect(_styleOf(tester, 'Featured Packs').fontSize, DsType.h2.size);
    expect(_styleOf(tester, 'Eclipse Vault — Series I').fontSize,
        DsType.h3.size);
    expect(_styleOf(tester, 'Voidwing Ascendant').fontSize, DsType.h4.size);

    // `.type-label` and `.type-micro` uppercase at paint, and bring their own
    // muted colour — the reference overrides neither.
    expect(_styleOf(tester, 'REMAINING SUPPLY').color,
        DsThemeData.dark.mutedForeground);
    expect(_styleOf(tester, 'LIMITED EDITION').fontSize, DsType.micro.size);
  });

  testWidgets('#numbers specimens five steps and argues for tabular figures', (
    WidgetTester tester,
  ) async {
    await tester.pumpPage();

    for (final String cls in <String>[
      '.type-num-xl',
      '.type-num-lg',
      '.type-num-md',
      '.type-num',
      '.type-num-sm',
    ]) {
      _expectSpecRow(tester, cls);
    }

    expect(_styleOf(tester, r'$12,480.65').fontSize, DsType.numXl.size);
    expect(_styleOf(tester, '412 / 2,000').color,
        DsThemeData.dark.mutedForeground);

    expect(find.text('WHY TABULAR MATTERS'), findsOneWidget);
    expect(find.text('font-variant-numeric: tabular-nums'), findsOneWidget);
    expect(find.text('TABULAR — THE PRODUCT'), findsOneWidget);
    expect(find.text('PROPORTIONAL — REJECTED'), findsOneWidget);

    // Each of the four figures is printed by both columns; two of them are
    // also a specimen or a pairing card elsewhere on the page.
    for (final String value in <String>[
      r'$1,240.00',
      r'$48.00',
      r'$7.15',
      r'$11,908.40',
    ]) {
      expect(
        find.text(value),
        findsAtLeast(2),
        reason: '$value pair missing',
      );
    }
    expect(find.text('Row'), findsNWidgets(8));

    // `$7.15` appears nowhere else, so its two renderings are the two columns:
    // `.type-num` (mono, tabular) against `.type-section` (sans, 13/600).
    final List<TextStyle> figures = _stylesOf(tester, r'$7.15').toList();
    expect(figures, hasLength(2));
    expect(figures.first.fontFamily, contains(DsFonts.mono));
    expect(figures.first.fontSize, DsType.numBase.size);
    expect(figures.first.fontFeatures, isNotNull);
    // …and the rejected column is not mono at all.
    expect(figures.last.fontFamily, contains(DsFonts.sans));
    expect(figures.last.fontSize, DsType.section.size);
    expect(figures.last.fontFeatures, isNull);
  });

  testWidgets('#pairing puts a word class beside a numeric one', (
    WidgetTester tester,
  ) async {
    await tester.pumpPage();

    expect(find.text('CANONICAL PAIRINGS'), findsOneWidget);
    expect(find.text('PACK PRICE'), findsOneWidget);
    expect(find.text('AVAILABLE BALANCE'), findsOneWidget);
    expect(find.text('LEGENDARY ODDS'), findsOneWidget);

    // The pack-price card prints `$48.00` in the same class its specimen row
    // does, so both renderings are `.type-num-md` in value ink.
    expect(
      _stylesOf(tester, r'$48.00').where(
        (TextStyle style) =>
            style.fontSize == DsType.numMd.size &&
            style.color == DsThemeData.dark.valueInk,
      ),
      hasLength(2),
    );
    expect(_styleOf(tester, r'$1,204.80').fontSize, DsType.numLg.size);
    expect(_styleOf(tester, r'$1,204.80').color, DsThemeData.dark.foreground);
    expect(find.text('1 in 240'), findsOneWidget);
    expect(find.text('6 cards per pack'), findsOneWidget);
    expect(
      find.textContaining(r'+$120.00', findRichText: true),
      findsOneWidget,
    );
  });

  group('#prose', () {
    testWidgets('renders the whole unclassed document', (
      WidgetTester tester,
    ) async {
        await tester.pumpPage();

      expect(find.text('LONG-FORM CONTENT'), findsOneWidget);
      expect(find.text('max-w-(--width-prose) · 720px'), findsOneWidget);

      // h2 and h3 render at their `.type-*` sizes through the element
      // selector, not a class.
      expect(_styleOf(tester, 'Refunds and cancellations').fontSize,
          DsType.h2.size);
      expect(_styleOf(tester, 'What a reader is entitled to').fontSize,
          DsType.h3.size);
      expect(find.text('Ordered steps'), findsOneWidget);

      // The override demo: an `h4` carrying `.type-label` renders as the
      // label, uppercase and muted.
      final TextStyle override =
          _styleOf(tester, 'AN EXPLICIT CLASS STILL WINS INSIDE PROSE');
      expect(override.fontSize, DsType.label.size);
      expect(override.color, DsThemeData.dark.mutedForeground);

      // Lists, both markers, and the nested step.
      expect(find.text('A refund within fourteen days of purchase.'),
          findsOneWidget);
      expect(find.text('the clause it was refused under, and'), findsOneWidget);
      expect(find.text('•'), findsNWidgets(5));
      expect(find.text('1.'), findsOneWidget);
      expect(find.text('3.'), findsOneWidget);

      // Blockquote — muted italic.
      final TextStyle quote = _styleOf(
        tester,
        'Nested lists take the interior step rather than the block step, so a '
        'sub-clause reads as part of its parent rather than as a new paragraph.',
      );
      expect(quote.fontStyle, FontStyle.italic);
      expect(quote.color, DsThemeData.dark.mutedForeground);

      // The table: `th` wears `.type-label`, so its heads are uppercase.
      expect(find.text('REQUEST'), findsOneWidget);
      expect(find.text('WINDOW'), findsOneWidget);
      expect(find.text('REFUNDED TO'), findsOneWidget);
      expect(find.text('Unopened item'), findsOneWidget);
      expect(find.text('Original payment method'), findsNWidgets(2));

      // The in-page link, and the anchor it scrolls to.
      expect(
        find.textContaining('a link identified by hue alone',
            findRichText: true),
        findsOneWidget,
      );
      expect(DsSection.anchorKey('prose').currentContext, isNotNull);
    });

    testWidgets('the Meta block states what .prose does and does not own', (
      WidgetTester tester,
    ) async {
        await tester.pumpPage();

      for (final String key in <String>[
        'What it owns',
        'Anchors',
        'Wide tables scroll',
        'What it does not own',
        '--width-prose',
        'Headings start at h2',
      ]) {
        expect(find.text(key), findsOneWidget, reason: 'meta key $key missing');
      }

      final TextStyle key = _styleOf(tester, '--width-prose');
      expect(key.fontSize, DsType.numSm.size);
      expect(key.color, DsThemeData.dark.actionInk);
      expect(
        find.textContaining('720px. Narrower than --width-content (1080px)',
            findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('the error note keeps its italics and its chips', (
      WidgetTester tester,
    ) async {
        await tester.pumpPage();

      // A `DsNote` title is muted-foreground in every tone.
      expect(_styleOf(tester, 'TWO MECHANISMS THAT DO NOT WORK').color,
          DsThemeData.dark.mutedForeground);
      expect(_chip(tester, '@apply type-h2'), '@apply type-h2');
      expect(_chip(tester, '[&_h2]:type-h2'), '[&_h2]:type-h2');
      expect(
        find.textContaining('Cannot apply unknown utility class',
            findRichText: true),
        findsOneWidget,
      );
    });
  });

  testWidgets('#rules states four of each, verbatim', (
    WidgetTester tester,
  ) async {
    await tester.pumpPage();

    expect(find.text('DO'), findsOneWidget);
    // `Don&rsquo;t` — the right single quotation mark.
    expect(find.text('DON’T'), findsOneWidget);

    expect(
      find.text(
        'Keep .type-micro as the absolute floor at 10.5px, and only for '
        'uppercase labels.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Always apply a .type-* or .type-num-* class — never a raw pixel size '
        'in a utility.',
      ),
      findsOneWidget,
    );
    // The don't that names a third typeface the CSS actually ships.
    expect(
      find.text(
        "Don't add a third typeface for display; heavy Space Grotesk at tight "
        'tracking already carries the hero.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        "Don't use proportional figures anywhere money, odds or counts appear.",
      ),
      findsOneWidget,
    );
  });

  testWidgets('lays out at 375px, where the table rule came from', (
    WidgetTester tester,
  ) async {
    // The Meta rows stack, the Spec rows stack, and the table becomes its own
    // scroll port rather than being clipped — the reference records 375px as
    // the width that forced `display:block; width:max-content`.
    await tester.pumpPage(size: const Size(375, 12000));

    expect(tester.takeException(), isNull);
    _expectSpecRow(tester, '.type-display');
    expect(find.text('Pull something legendary'), findsOneWidget);
    expect(find.text('REFUNDED TO'), findsOneWidget);
  });

  testWidgets('the foot nav sits between Colors and Spacing & Layout', (
    WidgetTester tester,
  ) async {
    final AppRouter router = AppRouter(route: '$dsRoot/typography');
    await tester.pumpPage(router: router);

    expect(find.text('PREVIOUS'), findsOneWidget);
    expect(find.text('Colors'), findsOneWidget);
    expect(find.text('NEXT'), findsOneWidget);
    expect(find.text('Spacing & Layout'), findsOneWidget);

    // The longest page in the port: the foot nav is ~7400px down, so it has to
    // be scrolled to before it can be tapped. `ensureVisible` rather than
    // `scrollUntilVisible`, which cannot choose between this page's two
    // scrollables — the second is the prose table's own scroll port.
    await tester.ensureVisible(find.text('Spacing & Layout'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Spacing & Layout'));
    await tester.pumpAndSettle();
    expect(router.route, '$dsRoot/spacing');
  });
}
