/// The kit's anatomy — the handful of facts every page depends on and no page
/// should have to re-check.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(
  Widget child, {
  DsThemeMode mode = DsThemeMode.dark,
  AppRouter? router,
}) {
  return DsTheme(
    controller: DsThemeController(mode: mode),
    child: AppRouterScope(
      router: router ?? AppRouter(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SingleChildScrollView(child: child),
      ),
    ),
  );
}

TextStyle _styleOf(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text)).style!;

/// [child] laid out at exactly [width], left-aligned, so a measurement is the
/// widget's own arithmetic rather than the test view's.
Widget _atWidth(Widget child, {double width = 400}) => _harness(
      Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: width, child: child),
      ),
    );

void main() {
  group('DsNote', () {
    // The rendering fact colors-map §3 flags: `.type-label` declares its own
    // `color: var(--muted-foreground)`, which beats the wrapper's tone ink.
    for (final DsNoteTone tone in DsNoteTone.values) {
      testWidgets('$tone title renders muted-foreground, not the tone ink',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _harness(
            DsNote(
              tone: tone,
              title: 'Measured, not asserted',
              child: const Text('body'),
            ),
          ),
        );

        // `.type-label` is uppercase, so this is the rendered string.
        final TextStyle title = _styleOf(tester, 'MEASURED, NOT ASSERTED');
        expect(title.color, DsThemeData.dark.mutedForeground);
        expect(title.color, isNot(DsThemeData.dark.actionInk));
        expect(title.color, isNot(DsThemeData.dark.valueInk));
        expect(title.color, isNot(DsThemeData.dark.destructiveInk));
      });
    }

    testWidgets('the tone shows in the wash and the border only',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _harness(
          const DsNote(
            tone: DsNoteTone.value,
            title: 'The one step that is not a mirror',
            child: Text('body'),
          ),
        ),
      );

      final BoxDecoration box = tester
          .widget<Container>(
            find
                .ancestor(
                  of: find.text('THE ONE STEP THAT IS NOT A MIRROR'),
                  matching: find.byType(Container),
                )
                .first,
          )
          .decoration! as BoxDecoration;

      expect(box.color, DsPalette.value.withValues(alpha: 0.08));
      expect(
        (box.border! as Border).top.color,
        DsPalette.value.withValues(alpha: 0.30),
      );
    });
  });

  group('DsSection', () {
    testWidgets('the h2 wears .type-h3 and the description wears .type-small',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _harness(
          const DsSection(
            id: 'monochrome',
            title: 'Monochrome — zinc',
            description: 'Six steps on shadcn’s own token names.',
            child: Text('body'),
          ),
        ),
      );

      final TextStyle heading = _styleOf(tester, 'Monochrome — zinc');
      expect(heading.fontSize, DsType.h3.size);
      expect(heading.color, DsThemeData.dark.foreground);
      // …and not the class its element name would suggest.
      expect(heading.fontSize, isNot(DsType.h2.size));

      final TextStyle description =
          _styleOf(tester, 'Six steps on shadcn’s own token names.');
      expect(description.fontSize, DsType.small.size);
      expect(description.color, DsThemeData.dark.mutedForeground);
    });

    testWidgets('registers an anchor for in-page links',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _harness(
          const DsSection(id: 'prose', title: 'Prose', child: Text('body')),
        ),
      );
      expect(DsSection.anchorKey('prose').currentContext, isNotNull);
      expect(DsSection.anchorKey('nothing-here').currentContext, isNull);
    });
  });

  group('DsPageHeader', () {
    testWidgets('eyebrow takes action ink; chips render in order',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _harness(
          const DsPageHeader(
            eyebrow: 'Foundations',
            title: 'Colors',
            blurb: 'Zinc for everything structural.',
            contents: <String>['Monochrome', 'Action ramp', 'Value ramp'],
          ),
        ),
      );

      expect(_styleOf(tester, 'FOUNDATIONS').color, DsThemeData.dark.actionInk);
      // `clamp(2rem, 2.8vw, 2.5rem)` against the test view's 800px width.
      expect(_styleOf(tester, 'Colors').fontSize, DsType.h1Size(800));
      expect(
        _styleOf(tester, 'Zinc for everything structural.').color,
        DsThemeData.dark.mutedForeground,
      );
      for (final String chip in <String>[
        'Monochrome',
        'Action ramp',
        'Value ramp',
      ]) {
        expect(find.text(chip), findsOneWidget);
      }
    });
  });

  testWidgets('DsCode is a mono chip in muted ink', (WidgetTester tester) async {
    await tester.pumpWidget(_harness(const DsCode('app/globals.css')));
    final TextStyle style = _styleOf(tester, 'app/globals.css');
    expect(style.fontSize, DsType.code.size);
    expect(style.color, DsThemeData.dark.mutedForeground);
  });

  testWidgets('DsDoDont heads each column in its own ink',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      _harness(
        const DsDoDont(
          dos: <String>['Use the scale.'],
          donts: <String>['Invent a value.'],
        ),
      ),
    );

    expect(_styleOf(tester, 'DO').color, DsThemeData.dark.valueInk);
    // `Don&rsquo;t` — the right single quote, verbatim.
    expect(_styleOf(tester, 'DON’T').color, DsThemeData.dark.destructiveInk);
    expect(find.text('Use the scale.'), findsOneWidget);
    expect(find.text('Invent a value.'), findsOneWidget);
  });

  group('DsPageFootNav', () {
    testWidgets('colors has no previous and points at Typography',
        (WidgetTester tester) async {
      final AppRouter router = AppRouter();
      await tester.pumpWidget(
        _harness(
          const DsPageFootNav(groupId: 'foundations', slug: 'colors'),
          router: router,
        ),
      );

      expect(find.text('PREVIOUS'), findsNothing);
      expect(find.text('NEXT'), findsOneWidget);
      expect(find.text('Typography'), findsOneWidget);

      await tester.tap(find.text('Typography'));
      await tester.pumpAndSettle();
      expect(router.route, '$dsRoot/typography');
    });

    testWidgets('spacing sits between Typography and Shadows',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _harness(const DsPageFootNav(groupId: 'foundations', slug: 'spacing')),
      );
      expect(find.text('PREVIOUS'), findsOneWidget);
      expect(find.text('Typography'), findsOneWidget);
      expect(find.text('NEXT'), findsOneWidget);
      expect(find.text('Shadows'), findsOneWidget);
    });
  });

  testWidgets('DsIndexCard links, and the group variant carries its label',
      (WidgetTester tester) async {
    final AppRouter router = AppRouter();
    await tester.pumpWidget(
      _harness(
        DsIndexGrid(
          children: <Widget>[
            const DsIndexCard(
              href: '$dsRoot/colors',
              title: 'Colors',
              blurb: 'Surfaces, the action and value ramps.',
              contents: <String>['Surfaces', 'Action ramp'],
            ),
            const DsIndexCard.group(
              href: '$dsRoot/components/base',
              label: '14 sets',
              title: 'Base Components',
              blurb: 'The shadcn chassis.',
              contents: <String>['Buttons'],
            ),
          ],
        ),
        router: router,
      ),
    );

    expect(_styleOf(tester, 'Colors').fontSize, DsType.h4.size);
    // The group card's title is a step larger, over an action-ink label.
    expect(_styleOf(tester, 'Base Components').fontSize, DsType.h3.size);
    expect(_styleOf(tester, '14 SETS').color, DsThemeData.dark.actionInk);

    await tester.tap(find.text('Colors'));
    await tester.pumpAndSettle();
    expect(router.route, '$dsRoot/colors');
  });

  testWidgets('DsPanel strips its label and note across the header band',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      _harness(
        const DsPanel(
          label: 'Texture',
          note: 'max-w-(--width-prose) · 720px',
          child: Text('body'),
        ),
      ),
    );

    expect(_styleOf(tester, 'TEXTURE').color, DsThemeData.dark.mutedForeground);
    final TextStyle note = _styleOf(tester, 'max-w-(--width-prose) · 720px');
    expect(note.fontSize, DsType.numSm.size);
    expect(note.color, DsThemeData.dark.mutedForeground);
  });

  // `box-sizing: border-box` is global in Tailwind, so a framed box spends its
  // own width on its border: a 400px panel with `p-6` gives its specimen
  // 400 − 2·24 − 2·1. Flutter's `Container` reproduces that automatically
  // (`decoration.padding`); a bare `DecoratedBox` does not, and the two pixels
  // it hands back are enough to move a line-wrap point — which is how this was
  // found (index-card blurbs measured 309.33px here against 307.33 in Chrome).
  group('border-box', () {
    const Key body = Key('body');

    testWidgets('DsPanel spends its frame on its own width',
        (WidgetTester tester) async {
      const double outer = 400;
      await tester.pumpWidget(
        _atWidth(
          const DsPanel(
            label: 'Seven steps',
            child: SizedBox(key: body, height: 40),
          ),
        ),
      );

      expect(
        tester.getSize(find.byKey(body)).width,
        outer - 2 * ds(6) - 2 * DsWidths.hairline,
      );
      // …and the strip above it starts at the border's inner edge, not on it.
      expect(
        tester.getTopLeft(find.text('SEVEN STEPS')).dx,
        closeTo(ds(5) + DsWidths.hairline, 0.01),
      );
    });

    testWidgets('a flush DsPanel body is still inset by the frame',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _atWidth(
          const DsPanel(flush: true, child: SizedBox(key: body, height: 40)),
        ),
      );
      expect(
        tester.getSize(find.byKey(body)).width,
        400 - 2 * DsWidths.hairline,
      );
    });

    testWidgets('DsDividedList rows clear the frame, and each divider is a '
        'real pixel of row height', (WidgetTester tester) async {
      const Key first = Key('row-0');
      const Key second = Key('row-1');
      await tester.pumpWidget(
        _atWidth(
          const DsDividedList(
            children: <Widget>[
              SizedBox(key: first, height: 40),
              SizedBox(key: second, height: 40),
            ],
          ),
        ),
      );

      for (final Key key in <Key>[first, second]) {
        expect(
          tester.getSize(find.byKey(key)).width,
          400 - 2 * DsWidths.hairline,
          reason: '$key',
        );
      }
      // `divide-y` is a `border-top` on the second row: it adds to that row's
      // height rather than painting over its first pixel.
      expect(
        tester.getTopLeft(find.byKey(second)).dy -
            tester.getBottomLeft(find.byKey(first)).dy,
        DsWidths.hairline,
      );
    });

    testWidgets('an index card blurb measures p-5 in from the frame',
        (WidgetTester tester) async {
      // The measurement that started this: at the overview's 1080 column the
      // six-up card is 349.33 wide, and `border p-5` leaves its copy 307.33 —
      // the number Chrome reports. Without the border inset it read 309.33,
      // and "every contrast ratio" wrapped a word later than on the web.
      const double outer = 349.33;
      await tester.pumpWidget(
        _atWidth(
          const SizedBox(
            // A grid row is an `IntrinsicHeight`; on its own the card's `grow`
            // blurb needs a bounded height from somewhere.
            height: 240,
            child: DsIndexCard(
              href: '$dsRoot/colors',
              title: 'Colors',
              blurb: 'Surfaces, the action and value ramps, text, hairlines, '
                  'semantic states, and every contrast ratio measured live in '
                  'both themes.',
              contents: <String>['Surfaces'],
            ),
          ),
          width: outer,
        ),
      );

      final RenderBox blurb = tester.renderObject<RenderBox>(
        find.text(
          'Surfaces, the action and value ramps, text, hairlines, semantic '
          'states, and every contrast ratio measured live in both themes.',
        ),
      );
      expect(
        blurb.constraints.maxWidth,
        closeTo(outer - 2 * ds(5) - 2 * DsWidths.hairline, 0.01),
      );
    });
  });

  testWidgets('DsMeta puts the key in mono action ink beside its value',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      _harness(
        DsMeta(
          items: <DsMetaItem>[
            (k: '--width-prose', v: const TextSpan(text: '720px')),
          ],
        ),
      ),
    );

    final TextStyle key = _styleOf(tester, '--width-prose');
    expect(key.fontSize, DsType.numSm.size);
    expect(key.color, DsThemeData.dark.actionInk);
    expect(find.textContaining('720px', findRichText: true), findsOneWidget);
  });
}
