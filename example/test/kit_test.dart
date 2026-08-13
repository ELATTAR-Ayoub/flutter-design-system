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
