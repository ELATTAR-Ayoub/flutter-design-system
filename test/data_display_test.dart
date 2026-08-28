/// The data-display family, against the numbers the reference renders.
///
/// Everything pinned here was read off `/design-system/components/base/data` at
/// 1440 × 900 on 2026-08-16 — computed styles and `getBoundingClientRect`, plus
/// one probe that clones each table at `width: max-content` to recover the
/// per-column intrinsic widths the browser distributes from.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart'
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
        TableColumnWidth,
        ActionChip,
        AlertDialog,
        Badge,
        Card,
        CarouselController,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        DrawerHeader,
        Slider,
        Switch,
        TextFormField,
        Tooltip;
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/// Half a pixel — below anything either engine can paint.
const double _fine = 0.5;

Future<void> _loadFont(String family, String file) async {
  final ByteData bytes = ByteData.sublistView(
    File('assets/fonts/$file').readAsBytesSync(),
  );
  final FontLoader loader = FontLoader('packages/elattar_design_system/$family')
    ..addFont(Future<ByteData>.value(bytes));
  await loader.load();
}

Widget host(
  Widget child, {
  ColorMode mode = ColorMode.dark,
  Size size = const Size(1440, 900),
}) => MediaQuery(
  data: MediaQueryData(size: size),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ThemeScope(
      controller: ThemeController(mode: mode),
      child: Center(child: child),
    ),
  ),
);

/// A cell whose intrinsic width is exactly [width] — the browser's max-content
/// number, handed to the layout as a fact so the distribution can be checked
/// without depending on a font.
TableCellSpec _rigid(double width, {double height = 20}) => TableCellSpec(
  child: SizedBox(width: width, height: height),
);

/// The test surface defaults to 800 × 600; every number here is measured at
/// the reference's own frame.
void useSurface(WidgetTester tester, [Size size = const Size(1440, 900)]) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
}

void main() {
  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
  });

  group('Table — the column model', () {
    testWidgets(
      'slack is distributed in proportion to max-content, exactly as Chrome '
      'does',
      (WidgetTester tester) async {
        useSurface(tester);
        // The data table's five columns, at the max-content widths the clone
        // probe reported, less the 16px of `p-2` each cell pays. The select
        // column pays only 8 — `[&:has([role=checkbox])]:pr-0`.
        const List<double> content = <double>[
          20,
          82.703,
          52.516,
          57.828,
          51.891,
        ];
        const List<double> expected = <double>[
          85.422,
          301.141,
          209.031,
          225.25,
          207.156,
        ];

        await tester.pumpWidget(
          host(
            SizedBox(
              // The table's own box inside its 1px frame.
              width: 1028,
              child: Table(
                header: <TableCellSpec>[
                  TableCellSpec(
                    checkbox: true,
                    child: SizedBox(width: content[0], height: 20),
                  ),
                  for (int i = 1; i < content.length; i++) _rigid(content[i]),
                ],
                rows: const <TableRowSpec>[],
              ),
            ),
          ),
        );

        // The header cells ARE the columns: each is a `Container` the table
        // lays out at the resolved width.
        final List<RenderBox> columns = tester
            .renderObjectList<RenderBox>(
              find.descendant(
                of: find.byType(Table),
                matching: find.byType(Container),
              ),
            )
            .toList(growable: false);
        expect(columns.length, content.length);

        for (int i = 0; i < expected.length; i++) {
          expect(
            columns[i].size.width,
            closeTo(expected[i], _fine),
            reason: 'column $i is not the width Chrome computes',
          );
        }
      },
    );

    testWidgets('a header row is a hard 40, rule included', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 600,
            child: Table(
              header: <TableCellSpec>[_rigid(100), _rigid(100)],
              rows: const <TableRowSpec>[],
            ),
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(Table)).height,
        closeTo(Table.headerHeight, _fine),
      );
    });

    testWidgets(
      'a multi-row body stacks 37 / 37 / 36.5, and a single row pays neither '
      'half',
      (WidgetTester tester) async {
        Future<double> bodyOf(int rows) async {
          await tester.pumpWidget(
            host(
              SizedBox(
                width: 600,
                child: Table(
                  header: <TableCellSpec>[_rigid(100), _rigid(100)],
                  rows: <TableRowSpec>[
                    for (int i = 0; i < rows; i++)
                      TableRowSpec(
                        cells: <TableCellSpec>[_rigid(100), _rigid(100)],
                      ),
                  ],
                ),
              ),
            ),
          );
          return tester.getSize(find.byType(Table)).height - Table.headerHeight;
        }

        // A 20px cell in `p-2`: 36 of content box, plus the rule.
        expect(
          await bodyOf(1),
          closeTo(36, _fine),
          reason: 'one row shares no rule with anything',
        );
        expect(
          await bodyOf(2),
          closeTo(37 + 36.5, _fine),
          reason: 'two rows: 37 over 36.5',
        );
        expect(await bodyOf(5), closeTo(4 * 37 + 36.5, _fine));
      },
    );

    testWidgets(
      'a colSpan row is laid out beside the table at its own height',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          host(
            SizedBox(
              width: 600,
              child: Table(
                header: <TableCellSpec>[_rigid(100), _rigid(100)],
                rows: <TableRowSpec>[
                  TableRowSpec.span(
                    const SizedBox(height: 40),
                    spanHeight: space(48),
                  ),
                ],
              ),
            ),
          ),
        );
        // `h-48` — 192, and the head above it.
        expect(
          tester.getSize(find.byType(Table)).height,
          closeTo(Table.headerHeight + space(48), _fine),
        );
      },
    );

    testWidgets('a caption sits mt-4 under the body, centred', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 600,
            child: Table(
              caption: 'Showing the 5 most recent transactions of 248.',
              header: <TableCellSpec>[_rigid(100), _rigid(100)],
              rows: <TableRowSpec>[
                TableRowSpec(cells: <TableCellSpec>[_rigid(100), _rigid(100)]),
              ],
            ),
          ),
        ),
      );

      final StyledText caption = tester.widget<StyledText>(
        find.byWidgetPredicate(
          (Widget w) => w is StyledText && w.text.startsWith('Showing'),
        ),
      );
      expect(caption.align, TextAlign.center);
      expect(caption.spec, TextStyles.bodySmall);

      // head 40 + one row 36 + mt-4 16 + an 18.5714 line box.
      expect(
        tester.getSize(find.byType(Table)).height,
        closeTo(40 + 36 + 16 + 13 * (1.25 / 0.875), _fine),
      );
    });

    testWidgets(
      'a row lights to muted/50 on hover and to muted when selected',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          host(
            SizedBox(
              width: 600,
              child: Table(
                header: <TableCellSpec>[_rigid(100)],
                rows: <TableRowSpec>[
                  TableRowSpec(cells: <TableCellSpec>[_rigid(100)]),
                  TableRowSpec(
                    selected: true,
                    cells: <TableCellSpec>[_rigid(100)],
                  ),
                ],
              ),
            ),
          ),
        );

        final ThemeTokens theme = ThemeScope.of(
          tester.element(find.byType(Table)),
        );
        List<Color?> fills() => tester
            .widgetList<Container>(
              find.descendant(
                of: find.byType(Table),
                matching: find.byType(Container),
              ),
            )
            .map((Container c) => (c.decoration as BoxDecoration?)?.color)
            .toList();

        // The header cell has no fill; the two body cells do.
        expect(fills()[1]?.a ?? 0, 0);
        expect(fills()[2]?.toARGB32(), theme.muted.toARGB32());

        final TestGesture gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);
        // The first body row's middle: past the 40px head, half a 37px row in.
        await gesture.moveTo(
          tester.getTopLeft(find.byType(Table)) +
              Offset(50, Table.headerHeight + 18),
        );
        await tester.pump();
        await tester.pump(MotionDurations.normal);
        expect(fills()[1]!.a, closeTo(0.5, 0.02));
      },
    );
  });

  group('Card', () {
    testWidgets('a footer cancels the bottom padding and nothing else does', (
      WidgetTester tester,
    ) async {
      Future<double> heightOf({required bool footer}) async {
        await tester.pumpWidget(
          host(
            SizedBox(
              width: 482,
              child: Card(
                children: <Widget>[
                  const CardContent(child: SizedBox(height: 20)),
                  if (footer) const CardFooter(child: SizedBox(height: 40)),
                ],
              ),
            ),
          ),
        );
        return tester.getSize(find.byType(Card)).height;
      }

      // 16 + 20 + 16 = 52 without, and 16 + 20 + 16 + (16 + 40 + 16 + 1)
      // with — the footer's own `p-4` and its `border-t`.
      expect(await heightOf(footer: false), closeTo(52, _fine));
      expect(await heightOf(footer: true), closeTo(16 + 20 + 16 + 73, _fine));
    });

    testWidgets('the ring is outset, so the box keeps its width', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 482,
            child: Card(
              children: <Widget>[
                const CardContent(child: SizedBox(height: 20)),
              ],
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(Card)).width, 482);

      final ThemeTokens theme = ThemeScope.of(
        tester.element(find.byType(Card)),
      );
      expect(Card.ringOf(theme).a, closeTo(0.1, 0.001));
      expect(Card.ringWidth, BorderWidths.hairline);
    });

    testWidgets('a header with an action is two columns, 4px apart', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 482,
            child: Card(
              children: <Widget>[
                const CardHeader(
                  title: CardTitle('Weekly competition'),
                  description: CardDescription('Ends in 2 days.'),
                  action: SizedBox(width: 41.53, height: 20),
                ),
              ],
            ),
          ),
        ),
      );

      final Rect action = tester.getRect(
        find.byWidgetPredicate((Widget w) => w is SizedBox && w.width == 41.53),
      );
      final Rect header = tester.getRect(find.byType(CardHeader));
      final Rect title = tester.getRect(find.byType(CardTitle));
      // `justify-self-end`, inside the header's own `px-(--card-spacing)`.
      expect(action.right, closeTo(header.right - Card.spacing, _fine));
      // `self-start` — the action shares the title's top edge.
      expect(action.top, closeTo(title.top, _fine));
      // `gap-1` is the COLUMN gap too.
      expect(action.left - title.right, closeTo(CardHeader.gap, _fine));
    });
  });

  group('Item', () {
    testWidgets('the group\'s gap is 10, not 16', (WidgetTester tester) async {
      expect(ItemGroup.gap, space(2.5));

      await tester.pumpWidget(
        host(
          SizedBox(
            width: 600,
            child: ItemGroup(
              children: <Widget>[
                for (int i = 0; i < 2; i++)
                  Item(
                    content: ItemContent(
                      children: <Widget>[ItemTitle('Row $i')],
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

      final List<Rect> rows = tester
          .renderObjectList<RenderBox>(find.byType(Item))
          .map((RenderBox b) => b.localToGlobal(Offset.zero) & b.size)
          .toList();
      expect(rows[1].top - rows[0].bottom, closeTo(10, _fine));
    });

    testWidgets('a row is 63.38 tall with a title and a description', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 1078,
            child: Item(
              media: const ItemMedia(child: Icon.lucide(Lucide.arrowUpRight)),
              content: const ItemContent(
                children: <Widget>[
                  ItemTitle('Visa ···· 6411'),
                  ItemDescription('Expires 04/29 · Default'),
                ],
              ),
              actions: ItemActions(
                children: <Widget>[
                  Button(
                    variant: ButtonVariant.ghost,
                    size: ButtonSize.sm,
                    onPressed: () {},
                    child: const Text('Manage'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // 1 + 10 + (17.875 + 4 + 19.5) + 10 + 1.
      expect(tester.getSize(find.byType(Item)).height, closeTo(63.375, _fine));
    });

    testWidgets('the media pins to the top and drops 2px', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 600,
            child: Item(
              media: const ItemMedia(child: Icon.lucide(Lucide.arrowUpRight)),
              content: const ItemContent(
                children: <Widget>[
                  ItemTitle('Visa'),
                  ItemDescription('Expires 04/29'),
                ],
              ),
            ),
          ),
        ),
      );

      // The media slot is stretched to the row; the GLYPH inside it is what
      // `self-start` plus `translate-y-0.5` places.
      final Rect glyph = tester.getRect(find.byType(Icon));
      final Rect content = tester.getRect(find.byType(ItemContent));
      expect(glyph.top - content.top, closeTo(ItemMedia.nudge, _fine));
      expect(glyph.height, ItemMedia.size);
    });
  });

  group('Avatar', () {
    testWidgets(
      'the class beats the attribute for the box and not for the dot',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          host(
            Avatar(
              fallback: 'VW',
              sizePx: space(10),
              badge: AvatarBadge(fill: Palette.value),
            ),
          ),
        );

        expect(tester.getSize(find.byType(Avatar)), Size(space(10), space(10)));
        // `data-size` is still `md`, so the dot is `size-2.5`.
        final Rect dot = tester.getRect(
          find.byWidgetPredicate(
            (Widget w) =>
                w is Container && w.constraints?.maxWidth == space(2.5),
          ),
        );
        expect(dot.width, space(2.5));
        final Rect circle = tester.getRect(find.byType(Avatar));
        expect(dot.right, closeTo(circle.right, _fine));
        expect(dot.bottom, closeTo(circle.bottom, _fine));
      },
    );

    testWidgets('an outset ring costs the box nothing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          Avatar(
            fallback: '#1',
            sizePx: space(10),
            ring: (color: Palette.value, width: avatarRingWidth),
          ),
        ),
      );
      expect(tester.getSize(find.byType(Avatar)), Size(space(10), space(10)));
    });

    testWidgets('a group overlaps at 8px a neighbour', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 600,
            child: AvatarGroup(
              children: <Widget>[
                for (final String i in <String>['VW', 'EM', 'TC'])
                  Avatar(fallback: i, sizePx: space(8)),
                const AvatarGroupCount('+248'),
              ],
            ),
          ),
        ),
      );

      final List<double> lefts = <double>[
        ...tester
            .renderObjectList<RenderBox>(find.byType(Avatar))
            .map((RenderBox b) => b.localToGlobal(Offset.zero).dx),
        tester
            .renderObject<RenderBox>(find.byType(AvatarGroupCount))
            .localToGlobal(Offset.zero)
            .dx,
      ];
      for (int i = 1; i < lefts.length; i++) {
        expect(
          lefts[i] - lefts[i - 1],
          closeTo(space(8) - AvatarGroup.overlap, _fine),
          reason: 'a 32px circle at a 24px pitch',
        );
      }
    });
  });

  group('Marker and Separator', () {
    testWidgets('the separator variant puts a rule on each side of the label', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          const SizedBox(
            width: 1030,
            child: Marker(
              variant: MarkerVariant.separator,
              label: 'separator — divides before from after',
            ),
          ),
        ),
      );

      final List<Rect> rules = tester
          .renderObjectList<RenderBox>(find.byType(ColoredBox))
          .map((RenderBox b) => b.localToGlobal(Offset.zero) & b.size)
          .toList();
      expect(rules.length, 2);
      expect(rules[0].height, BorderWidths.hairline);
      expect(rules[1].height, BorderWidths.hairline);
      // The two rules split the leftovers evenly, to within the label's own
      // fractional width.
      expect(rules[0].width, closeTo(rules[1].width, 0.05));
    });

    testWidgets('the border variant pays pb-2 and draws a rule under itself', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          const SizedBox(
            width: 1030,
            child: Marker(
              variant: MarkerVariant.border,
              label: 'border — heads what follows',
            ),
          ),
        ),
      );
      // 18.5714 + pb-2 + the 1px rule.
      expect(
        tester.getSize(find.byType(Marker)).height,
        closeTo(13 * (1.25 / 0.875) + space(2) + BorderWidths.hairline, _fine),
      );
    });

    testWidgets('a separator is one pixel on its short axis, either way', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 448,
            height: space(6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const <Widget>[
                Expanded(child: SizedBox.shrink()),
                Separator.vertical(),
                Expanded(child: SizedBox.shrink()),
              ],
            ),
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(Separator)),
        Size(BorderWidths.hairline, space(6)),
        reason: '`self-stretch` fills the line, `w-px` does not',
      );

      await tester.pumpWidget(
        host(const SizedBox(width: 448, child: Separator())),
      );
      expect(
        tester.getSize(find.byType(Separator)),
        Size(448, BorderWidths.hairline),
      );
    });
  });

  group('Stat', () {
    Widget statHost(Stat stat) => host(SizedBox(width: 322, child: stat));

    testWidgets('the footprint is 75.89 in every state', (
      WidgetTester tester,
    ) async {
      const List<Stat> states = <Stat>[
        Stat(
          label: 'Revenue',
          value: r'$12,480',
          delta: (value: '8.2%', direction: StatDirection.up),
          hint: 'vs last month',
        ),
        Stat(
          label: 'Revenue',
          value: r'$12,480',
          delta: (value: '8.2%', direction: StatDirection.up),
          hint: 'vs last month',
          state: StatState.loading,
        ),
        Stat(
          label: 'Revenue',
          value: r'$12,480',
          delta: (value: '8.2%', direction: StatDirection.up),
          state: StatState.error,
          message: 'Could not load',
        ),
        Stat(
          label: 'Revenue',
          value: r'$12,480',
          delta: (value: '8.2%', direction: StatDirection.up),
          state: StatState.empty,
          message: 'No sales this period',
        ),
        Stat(
          label: 'Revenue',
          value: r'$12,480',
          delta: (value: '8.2%', direction: StatDirection.up),
          hint: 'vs last month',
          disabled: true,
        ),
      ];

      for (final Stat stat in states) {
        await tester.pumpWidget(statHost(stat));
        await tester.pump(MotionDurations.normal);
        expect(
          tester.getSize(find.byType(Stat)).height,
          closeTo(75.89, _fine),
          reason: '${stat.state} / disabled=${stat.disabled}',
        );
      }
    });

    testWidgets('the component writes the sign, and it is U+2212 for a fall', (
      WidgetTester tester,
    ) async {
      expect(StatDirection.up.sign, '+');
      expect(StatDirection.down.sign, '−');
      expect(StatDirection.flat.sign, '');

      await tester.pumpWidget(
        host(
          const StatDeltaMark(
            delta: (value: '4.1%', direction: StatDirection.down),
            betterWhen: StatDirection.up,
          ),
        ),
      );
      expect(find.text('−4.1%'), findsOneWidget);
    });

    testWidgets('the favourable direction earns success-ink and the other '
        'earns plain foreground', (WidgetTester tester) async {
      await tester.pumpWidget(
        host(
          const StatDeltaMark(
            delta: (value: '0.3%', direction: StatDirection.up),
            betterWhen: StatDirection.down,
          ),
        ),
      );
      final ThemeTokens theme = ThemeScope.of(
        tester.element(find.byType(StatDeltaMark)),
      );
      final StatDeltaMark mark = tester.widget<StatDeltaMark>(
        find.byType(StatDeltaMark),
      );
      expect(mark.ink(theme).toARGB32(), theme.foreground.toARGB32());

      await tester.pumpWidget(
        host(
          const StatDeltaMark(
            delta: (value: '8.2%', direction: StatDirection.up),
            betterWhen: StatDirection.up,
          ),
        ),
      );
      expect(
        tester
            .widget<StatDeltaMark>(find.byType(StatDeltaMark))
            .ink(theme)
            .toARGB32(),
        theme.successText.toARGB32(),
      );

      await tester.pumpWidget(
        host(
          const StatDeltaMark(
            delta: (value: '0.0%', direction: StatDirection.flat),
            betterWhen: StatDirection.up,
          ),
        ),
      );
      expect(
        tester
            .widget<StatDeltaMark>(find.byType(StatDeltaMark))
            .ink(theme)
            .toARGB32(),
        theme.mutedForeground.toARGB32(),
      );
    });

    testWidgets('a blank state puts an em dash where the figure was', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        statHost(
          const Stat(
            label: 'Revenue',
            value: r'$12,480',
            state: StatState.empty,
            message: 'No sales this period',
          ),
        ),
      );
      expect(find.text('—'), findsOneWidget);
      expect(find.text(r'$12,480'), findsNothing);
      expect(find.text('No sales this period'), findsOneWidget);
    });

    testWidgets('disabled is opacity-45 and nothing else', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        statHost(
          const Stat(
            label: 'Revenue',
            value: r'$12,480',
            hint: 'vs last month',
            disabled: true,
          ),
        ),
      );
      expect(
        tester.widget<Opacity>(find.byType(Opacity).first).opacity,
        closeTo(0.45, 0.001),
      );
      expect(find.text(r'$12,480'), findsOneWidget);
    });
  });

  group('Badge with a glyph', () {
    testWidgets('the chip forces 12px and keeps the full px-2', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          const Badge(
            label: 'Featured',
            variant: BadgeVariant.premium,
            glyph: Icon.lucide(Lucide.star, size: IconSize.xs),
          ),
        ),
      );

      expect(Badge.glyphSize, space(3));
      expect(Badge.glyphGap, space(1));
      final Rect chip = tester.getRect(find.byType(Badge));
      final Rect glyph = tester.getRect(find.byType(Icon));
      expect(glyph.width, space(3));
      // 8px of padding plus the 1px transparent border.
      expect(
        glyph.left - chip.left,
        closeTo(Badge.horizontalPadding + BorderWidths.hairline, _fine),
      );
      expect(chip.height, Badge.height);
    });
  });

  group('ContentChange', () {
    testWidgets('it lands on opacity 1 and scale 1', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(const ContentChange(child: SizedBox(width: 100, height: 20))),
      );
      await tester.pump(ContentChange.duration);
      await tester.pump(ContentChange.duration);

      expect(
        tester.widget<Opacity>(find.byType(Opacity)).opacity,
        closeTo(1, 0.001),
      );
      expect(tester.getSize(find.byType(SizedBox).last).width, 100);
    });

    testWidgets('a changed replayKey restarts it', (WidgetTester tester) async {
      await tester.pumpWidget(
        host(
          const ContentChange(
            replayKey: StatState.loading,
            child: SizedBox(width: 100, height: 20),
          ),
        ),
      );
      await tester.pump(ContentChange.duration);
      expect(
        tester.widget<Opacity>(find.byType(Opacity)).opacity,
        closeTo(1, 0.001),
      );

      await tester.pumpWidget(
        host(
          const ContentChange(
            replayKey: StatState.ready,
            child: SizedBox(width: 100, height: 20),
          ),
        ),
      );
      await tester.pump();
      expect(
        tester.widget<Opacity>(find.byType(Opacity)).opacity,
        lessThan(0.5),
        reason: 'a new key is a new node, and a new CSS animation',
      );
    });
  });
}
