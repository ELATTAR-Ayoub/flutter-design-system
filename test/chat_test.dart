/// The chat family, against the numbers the live reference reports.
///
/// Every pin here is a measurement, not a class read. The probes are
/// `scratchpad/ba2-chat-inv.js`, `ba2-chat-scroll.js`, `ba2-chat-inter.js`,
/// `ba2-chat-hover.js` and `ba2-chat-media.js`, all run at 1440×900 on
/// 2026-08-16 against `http://localhost:3000/design-system/components/base/chat`.
///
/// The two painted surfaces — the scroll-fade mask and the idle attachment's
/// dashed border — carry **rendered-pixel** pins as well as geometry, per the
/// standing painter rule. Neither blurs a combined path: the fade is one
/// [LinearGradient] under [BlendMode.dstIn] and the dash is a stroked
/// rounded-rect walked with [ui.PathMetric].
library;

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:elattar_design_system/src/components/ui/icon_paths.g.index.dart';
import 'package:flutter/rendering.dart' hide ScrollDirection;
import 'package:flutter/services.dart' show FontLoader;
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

Widget host(Widget child, {ColorMode mode = ColorMode.dark}) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ThemeScope(
      controller: ThemeController(mode: mode),
      child: Center(child: child),
    ),
  ),
);

/// What [overlayHost] is currently showing.
Widget _hosted = const SizedBox.shrink();

/// A host with an [Overlay], for the one specimen that portals — the media
/// preview mounts an `OverlayPortal` and needs a theatre to render into.
Widget overlayHost(Widget child, {ColorMode mode = ColorMode.dark}) {
  _hosted = child;
  return MediaQuery(
    data: const MediaQueryData(size: Size(1440, 900)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ThemeScope(
        controller: ThemeController(mode: mode),
        child: Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(builder: (BuildContext _) => Center(child: _hosted)),
          ],
        ),
      ),
    ),
  );
}

ThemeTokens themeIn(WidgetTester t, Type of) =>
    ThemeScope.of(t.element(find.byType(of).first));

Size sizeOf(WidgetTester t, Finder f) => t.renderObject<RenderBox>(f).size;

/// The key every rasterised specimen mounts its boundary under.
const Key rasterKey = Key('raster');

/// One rendered frame, as raw RGBA — the recipe `feedback_effects_test.dart`
/// established: a **keyed** boundary (never `byType`, which finds the view's
/// own), and `toImage` / `toByteData` each in their own `runAsync`.
Future<ByteData> raster(WidgetTester t) async {
  final RenderRepaintBoundary box = t.renderObject(find.byKey(rasterKey));
  final ui.Image image = (await t.runAsync(() => box.toImage(pixelRatio: 1)))!;
  final ByteData bytes = (await t.runAsync(
    () async => (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!,
  ))!;
  rasterWidth = image.width;
  image.dispose();
  return bytes;
}

/// The width of the last [raster], so a pixel can be indexed.
int rasterWidth = 0;

/// One pixel out of a [raster].
Color pixelAt(ByteData data, int x, int y) {
  final int i = (y * rasterWidth + x) * 4;
  return Color.fromARGB(
    data.getUint8(i + 3),
    data.getUint8(i),
    data.getUint8(i + 1),
    data.getUint8(i + 2),
  );
}

/// The column the reference lays a transcript out in.
const double _column = 1020;

/// The reference's own font binaries — load-bearing, not hygiene: every height
/// pinned below is a line box, and a fallback face measures a different one.
Future<void> _loadFont(String family, String file) async {
  final ByteData bytes = ByteData.sublistView(
    File('assets/fonts/$file').readAsBytesSync(),
  );
  final FontLoader loader = FontLoader('packages/elattar_design_system/$family')
    ..addFont(Future<ByteData>.value(bytes));
  await loader.load();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
  });

  /// The reference frame. Without it the test surface is 800 x 600 and a
  /// 1078px scroller is measured against a viewport it does not fit in.
  setUp(() {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.instance;
    binding.platformDispatcher.implicitView!
      ..physicalSize = const Size(1440, 900)
      ..devicePixelRatio = 1;
    addTearDown(binding.platformDispatcher.implicitView!.reset);
  });

  /* ── Bubble ───────────────────────────────────────────────────────────── */

  group('BubbleContent — the painted surface', () {
    testWidgets('one line is 39.13 tall on every variant but ghost', (
      WidgetTester t,
    ) async {
      for (final BubbleVariant v in BubbleVariant.values) {
        await t.pumpWidget(
          host(
            SizedBox(
              width: _column,
              child: Bubble(
                variant: v,
                child: const BubbleContent(child: Text('Up 14% overnight')),
              ),
            ),
          ),
        );
        final double h = sizeOf(t, find.byType(BubbleContent)).height;
        // One body line box, the bubble's own padding, and its hairline
        // border. `ghost` drops the padding and keeps the border.
        final double line = TextStyles.body.step.leading;
        final double border = BorderWidths.hairline * 2;
        expect(
          h,
          closeTo(
            v == BubbleVariant.ghost
                ? line + border
                : line + space(2) * 2 + border,
            0.2,
          ),
          reason: 'variant ${v.label}',
        );
      }
    });

    testWidgets('13px on a 21.125px line box — leading-relaxed, not text-sm', (
      WidgetTester t,
    ) async {
      expect(TextStyles.body.step, const TypeStep(16, 24));
    });

    testWidgets('the fills are the seven the reference paints', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          SizedBox(
            width: _column,
            child: Column(
              children: <Widget>[
                for (final BubbleVariant v in BubbleVariant.values)
                  Bubble(
                    variant: v,
                    child: const BubbleContent(child: Text('x')),
                  ),
              ],
            ),
          ),
        ),
      );
      final ThemeTokens theme = themeIn(t, Bubble);
      final List<BoxDecoration> decorations = t
          .widgetList<AnimatedContainer>(
            find.descendant(
              of: find.byType(BubbleContent),
              matching: find.byType(AnimatedContainer),
            ),
          )
          .map((AnimatedContainer c) => c.decoration! as BoxDecoration)
          .toList();

      expect(decorations[0].color, theme.primary);
      expect(decorations[1].color, theme.secondary);
      expect(decorations[2].color, theme.muted);
      expect(decorations[3].color, theme.messageAccent);
      expect(decorations[4].color, theme.background);
      expect(decorations[5].color!.a, 0);
      expect(
        decorations[6].color,
        // dark: `bg-destructive/20`.
        theme.destructive.withValues(alpha: 0.20),
      );
      // Only `outline` paints a visible border.
      expect((decorations[4].border! as Border).top.color, theme.border);
      expect((decorations[0].border! as Border).top.color.a, 0);
    });

    testWidgets('a div bubble has no transition; an asChild one runs 250ms', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          SizedBox(
            width: _column,
            child: Column(
              children: <Widget>[
                const Bubble(child: BubbleContent(child: Text('inert'))),
                Bubble(
                  child: BubbleContent(
                    onPressed: () {},
                    child: const Text('control'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      final List<AnimatedContainer> boxes = t
          .widgetList<AnimatedContainer>(
            find.descendant(
              of: find.byType(BubbleContent),
              matching: find.byType(AnimatedContainer),
            ),
          )
          .toList();
      // Measured `transition-property: all` at 0s on a div.
      expect(boxes[0].duration, Duration.zero);
      // Measured 0.25s on `cubic-bezier(0.22, 1, 0.36, 1)`.
      expect(boxes[1].duration, MotionDurations.normal);
      expect(boxes[1].curve, MotionCurves.enter);
    });

    testWidgets('ghost is the only variant allowed the full column', (
      WidgetTester t,
    ) async {
      const String long =
          'Six cards, two of them graded, and every one of them listed inside '
          'the same eleven minutes on four accounts that had never bought this '
          'set before today, which is the part worth looking at.';
      for (final BubbleVariant v in <BubbleVariant>[
        BubbleVariant.muted,
        BubbleVariant.ghost,
      ]) {
        await t.pumpWidget(
          host(
            SizedBox(
              width: _column,
              child: Bubble(
                variant: v,
                child: const BubbleContent(child: Text(long)),
              ),
            ),
          ),
        );
        final double w = sizeOf(t, find.byType(BubbleContent)).width;
        if (v == BubbleVariant.ghost) {
          expect(w, closeTo(_column, 0.5));
        } else {
          expect(w, lessThanOrEqualTo(_column * Bubble.maxWidthFraction + 0.5));
        }
      }
    });
  });

  /* ── Reactions ────────────────────────────────────────────────────────── */

  group('BubbleReactions', () {
    const List<BubbleReaction> reactions = <BubbleReaction>[
      BubbleReaction(emoji: 'A', count: 12, label: 'fire', mine: true),
      BubbleReaction(emoji: 'B', count: 8, label: 'a heart'),
    ];

    testWidgets('the data rail drops its padding; the bare rail keeps 2/6', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          SizedBox(
            width: 400,
            child: Bubble(
              reactions: const BubbleReactions(children: <Widget>[Text('A')]),
              child: const BubbleContent(child: Text('Nice pull')),
            ),
          ),
        ),
      );
      Container rail = t.widget<Container>(
        find
            .descendant(
              of: find.byType(BubbleReactions),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(
        rail.padding,
        EdgeInsets.symmetric(horizontal: space(1.5), vertical: space(0.5)),
      );

      await t.pumpWidget(
        host(
          SizedBox(
            width: 400,
            child: Bubble(
              reactions: const BubbleReactions(reactions: reactions),
              child: const BubbleContent(child: Text('Nice pull')),
            ),
          ),
        ),
      );
      rail = t.widget<Container>(
        find
            .descendant(
              of: find.byType(BubbleReactions),
              matching: find.byType(Container),
            )
            .first,
      );
      // `has-[button]:p-0`.
      expect(rail.padding, EdgeInsets.zero);
    });

    testWidgets('the rail rings 3px of --card and sits at z-index 10', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          SizedBox(
            width: 400,
            child: Bubble(
              reactions: const BubbleReactions(children: <Widget>[Text('A')]),
              child: const BubbleContent(child: Text('Nice pull')),
            ),
          ),
        ),
      );
      final ThemeTokens theme = themeIn(t, Bubble);
      final Container rail = t.widget<Container>(
        find
            .descendant(
              of: find.byType(BubbleReactions),
              matching: find.byType(Container),
            )
            .first,
      );
      final BoxShadow ring =
          (rail.decoration! as BoxDecoration).boxShadow!.single;
      expect(ring.color, theme.card);
      expect(ring.spreadRadius, BubbleReactions.ring);
      expect(ring.blurRadius, 0);
      expect(ring.offset, Offset.zero);
    });

    testWidgets('side flips the overhang; align flips the inset', (
      WidgetTester t,
    ) async {
      for (final BubbleSide side in BubbleSide.values) {
        await t.pumpWidget(
          host(
            SizedBox(
              width: 400,
              child: Bubble(
                reactions: BubbleReactions(
                  side: side,
                  children: const <Widget>[Text('A')],
                ),
                child: const BubbleContent(child: Text('Nice pull')),
              ),
            ),
          ),
        );
        final FractionalTranslation shift = t.widget<FractionalTranslation>(
          find.descendant(
            of: find.byType(BubbleReactions),
            matching: find.byType(FractionalTranslation),
          ),
        );
        expect(
          shift.translation.dy,
          side == BubbleSide.top
              ? -BubbleReactions.overhang
              : BubbleReactions.overhang,
        );
      }
    });

    testWidgets(
      'the count opens over 250ms on ease-out — the duration-fast no-op',
      (WidgetTester t) async {
        await t.pumpWidget(
          host(
            SizedBox(
              width: 400,
              child: Bubble(
                reactions: const BubbleReactions(reactions: reactions),
                child: const BubbleContent(child: Text('Nice pull')),
              ),
            ),
          ),
        );
        final TweenAnimationBuilder<double> reveal = t
            .widgetList<TweenAnimationBuilder<double>>(
              find.byType(TweenAnimationBuilder<double>),
            )
            .first;
        expect(reveal.duration, MotionDurations.normal);
        expect(reveal.curve, MotionCurves.enter);
      },
    );

    testWidgets('showCount: always cuts — no transition at all', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          SizedBox(
            width: 400,
            child: Bubble(
              reactions: const BubbleReactions(
                showCount: ShowCount.always,
                reactions: reactions,
              ),
              child: const BubbleContent(child: Text('Nice pull')),
            ),
          ),
        ),
      );
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
    });

    testWidgets(
      'the pill is 28 tall and mine carries border + fill + pressed',
      (WidgetTester t) async {
        await t.pumpWidget(
          host(
            SizedBox(
              width: 400,
              child: Bubble(
                reactions: const BubbleReactions(
                  showCount: ShowCount.always,
                  reactions: reactions,
                ),
                child: const BubbleContent(child: Text('Nice pull')),
              ),
            ),
          ),
        );
        final List<Container> pills = t
            .widgetList<Container>(
              find.descendant(
                of: find.byType(BubbleReactions),
                matching: find.byType(Container),
              ),
            )
            .where((Container c) => c.constraints?.maxHeight == space(7))
            .toList();
        expect(pills, hasLength(2));
        final ThemeTokens theme = themeIn(t, Bubble);
        final BoxDecoration mine = pills[0].decoration! as BoxDecoration;
        final BoxDecoration theirs = pills[1].decoration! as BoxDecoration;
        expect(mine.color, Palette.action.withValues(alpha: 0.10));
        expect(
          (mine.border! as Border).top.color,
          Palette.action.withValues(alpha: 0.40),
        );
        expect(theirs.color, theme.muted);
        expect((theirs.border! as Border).top.color, theme.border);

        // The `sr-only` span is in the tree at rest, in both modes.
        expect(find.bySemanticsLabel('12 reacted with fire'), findsOneWidget);
        expect(find.bySemanticsLabel('8 reacted with a heart'), findsOneWidget);
      },
    );

    testWidgets('the pill wears `press`, not the button squish', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          SizedBox(
            width: 400,
            child: Bubble(
              reactions: const BubbleReactions(reactions: reactions),
              child: const BubbleContent(child: Text('Nice pull')),
            ),
          ),
        ),
      );
      final Press press = t.widgetList<Press>(find.byType(Press)).first;
      // Measured: 0.9374 min at ~39ms, spring back peaking at 1.0058.
      expect(press.scale, MotionTransforms.press);
      expect(press.downDuration, MotionDurations.pressIn);
      expect(press.upDuration, MotionDurations.normal);
    });
  });

  /* ── Message ──────────────────────────────────────────────────────────── */

  group('Message', () {
    testWidgets('the avatar lifts 32px only when the row carries a footer', (
      WidgetTester t,
    ) async {
      for (final bool withFooter in <bool>[false, true]) {
        await t.pumpWidget(
          host(
            SizedBox(
              width: _column,
              child: Message(
                avatar: MessageAvatar(
                  size: space(8),
                  lifted: withFooter,
                  child: const SizedBox(),
                ),
                content: MessageContent(
                  header: const MessageHeader(text: 'Atlas'),
                  footer: withFooter
                      ? const MessageFooter(text: '09:41')
                      : null,
                  children: const <Widget>[
                    Bubble(child: BubbleContent(child: Text('hi'))),
                  ],
                ),
              ),
            ),
          ),
        );
        final Finder lift = find.descendant(
          of: find.byType(MessageAvatar),
          matching: find.byType(Transform),
        );
        expect(lift, withFooter ? findsOneWidget : findsNothing);
      }
    });

    testWidgets(
      'align: end reverses the row and pushes the column to the end',
      (WidgetTester t) async {
        await t.pumpWidget(
          host(
            SizedBox(
              width: _column,
              child: Message(
                align: BubbleAlign.end,
                avatar: MessageAvatar(size: space(8), child: const SizedBox()),
                content: const MessageContent(
                  children: <Widget>[
                    Bubble(child: BubbleContent(child: Text('Leave it.'))),
                  ],
                ),
              ),
            ),
          ),
        );
        final RenderBox row = t.renderObject<RenderBox>(find.byType(Message));
        final RenderBox avatar = t.renderObject<RenderBox>(
          find.byType(MessageAvatar),
        );
        final RenderBox bubble = t.renderObject<RenderBox>(
          find.byType(BubbleContent),
        );
        final double avatarX = avatar
            .localToGlobal(Offset.zero, ancestor: row)
            .dx;
        final double bubbleX = bubble
            .localToGlobal(Offset.zero, ancestor: row)
            .dx;
        // `flex-row-reverse`: the avatar is on the right of everything.
        expect(avatarX, greaterThan(bubbleX));
        // `self-end` on the bubble.
        expect(
          bubbleX + bubble.size.width,
          closeTo(avatarX - Message.gap, 0.5),
        );
      },
    );

    testWidgets('header and footer are 12/16/500 inset 12px, zero on ghost', (
      WidgetTester t,
    ) async {
      expect(TextStyles.small.step, const TypeStep(14, 20));

      for (final bool ghost in <bool>[false, true]) {
        await t.pumpWidget(
          host(
            SizedBox(
              width: _column,
              child: Message(
                ghost: ghost,
                content: const MessageContent(
                  header: MessageHeader(text: 'Atlas'),
                  children: <Widget>[
                    Bubble(child: BubbleContent(child: Text('hi'))),
                  ],
                ),
              ),
            ),
          ),
        );
        final Padding pad = t.widget<Padding>(
          find
              .descendant(
                of: find.byType(MessageHeader),
                matching: find.byType(Padding),
              )
              .first,
        );
        expect(
          (pad.padding as EdgeInsets).left,
          ghost ? 0 : MessageHeader.inset,
        );
        expect(
          sizeOf(t, find.byType(MessageHeader)).height,
          closeTo(TextStyles.small.step.leading, 0.05),
        );
      }
    });

    testWidgets('the column stacks on a 10px gap and the group on 8', (
      WidgetTester t,
    ) async {
      expect(MessageContent.gap, 10);
      expect(MessageGroup.gap, 8);
      expect(Message.gap, 8);
      expect(BubbleGroup.gap, 8);
    });
  });

  /* ── Message scroller ─────────────────────────────────────────────────── */

  group('MessageScroller', () {
    Widget scroller(
      MessageScrollerController c, {
      int turns = 11,
      double height = 320,
    }) => host(
      SizedBox(
        width: 1078,
        height: height,
        child: MessageScrollerProvider(
          controller: c,
          child: MessageScroller(
            viewport: MessageScrollerViewport(
              child: MessageScrollerContent(
                padding: EdgeInsets.all(space(6)),
                children: <Widget>[
                  for (int i = 0; i < turns; i++)
                    MessageScrollerItem(
                      messageId: 'm$i',
                      child: Message(
                        content: MessageContent(
                          children: <Widget>[
                            Bubble(
                              variant: BubbleVariant.muted,
                              child: BubbleContent(child: Text('turn $i')),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            button: const MessageScrollerButton(),
          ),
        ),
      ),
    );

    testWidgets('the content column is 10px narrower — the stable gutter', (
      WidgetTester t,
    ) async {
      final MessageScrollerController c = MessageScrollerController(
        defaultScrollPosition: ScrollPosition.start,
      );
      addTearDown(c.dispose);
      await t.pumpWidget(scroller(c));
      await t.pump();
      // Measured: a 1078px viewport hands its content 1068.
      expect(
        sizeOf(t, find.byType(MessageScrollerContent)).width,
        1078 - MessageScrollerViewport.gutter,
      );
    });

    testWidgets('eleven single-line turns stack to 718.38', (
      WidgetTester t,
    ) async {
      final MessageScrollerController c = MessageScrollerController(
        defaultScrollPosition: ScrollPosition.start,
      );
      addTearDown(c.dispose);
      await t.pumpWidget(scroller(c));
      await t.pump();
      // The content padding, eleven single-line bubbles, and ten gaps.
      final double bubble =
          TextStyles.body.step.leading +
          space(2) * 2 +
          BorderWidths.hairline * 2;
      expect(
        sizeOf(t, find.byType(MessageScrollerContent)).height,
        closeTo(space(6) * 2 + 11 * bubble + 10 * space(6), 1.5),
      );
    });

    testWidgets('defaultScrollPosition: start rests at the top', (
      WidgetTester t,
    ) async {
      final MessageScrollerController c = MessageScrollerController(
        defaultScrollPosition: ScrollPosition.start,
      );
      addTearDown(c.dispose);
      await t.pumpWidget(scroller(c));
      await t.pump();
      expect(c.offset, 0);
      expect(c.scrollable(ScrollDirection.end), isTrue);
      expect(c.scrollable(ScrollDirection.start), isFalse);
    });

    testWidgets('the edge threshold is 8, inclusive', (WidgetTester t) async {
      final MessageScrollerController c = MessageScrollerController(
        defaultScrollPosition: ScrollPosition.start,
      );
      addTearDown(c.dispose);
      await t.pumpWidget(scroller(c));
      await t.pump();
      final double max = c.maxOffset;

      // Measured: still active at 8px from the end, inactive at 4.
      c.scroll.jumpTo(max - 8);
      await t.pump();
      expect(c.scrollable(ScrollDirection.end), isTrue);
      c.scroll.jumpTo(max - 4);
      await t.pump();
      expect(c.scrollable(ScrollDirection.end), isFalse);
    });

    testWidgets('the button snaps its transforms and fades over 250ms', (
      WidgetTester t,
    ) async {
      final MessageScrollerController c = MessageScrollerController(
        defaultScrollPosition: ScrollPosition.start,
      );
      addTearDown(c.dispose);
      await t.pumpWidget(scroller(c));
      await t.pump();

      AnimatedOpacity fade() => t.widget<AnimatedOpacity>(
        find.descendant(
          of: find.byType(MessageScrollerButton),
          matching: find.byType(AnimatedOpacity),
        ),
      );
      // The button wears three transforms: the translate, the scale, and the
      // arrow's own `rotate-180` hook. The scale is the second.
      double scale() => t
          .widgetList<Transform>(
            find.descendant(
              of: find.byType(MessageScrollerButton),
              matching: find.byType(Transform),
            ),
          )
          .elementAt(1)
          .transform
          .storage[0];

      expect(fade().opacity, 1);
      expect(fade().curve, MotionCurves.enter);
      // Active: no scale.
      expect(scale(), 1);

      c.scroll.jumpTo(c.maxOffset);
      await t.pump();
      expect(fade().opacity, 0);
      // `data-[active=false]:ease-in`.
      expect(fade().curve, MotionCurves.exit);
      expect(fade().duration, MotionDurations.normal);
      // `scale-95` — one frame, not a tween.
      expect(scale(), closeTo(MessageScrollerButton.inactiveScale, 0.001));
    });

    testWidgets('the button disables itself once the edge is reached', (
      WidgetTester t,
    ) async {
      final MessageScrollerController c = MessageScrollerController(
        defaultScrollPosition: ScrollPosition.start,
      );
      addTearDown(c.dispose);
      await t.pumpWidget(scroller(c));
      await t.pump();
      expect(t.widget<Button>(find.byType(Button)).onPressed, isNotNull);
      c.scroll.jumpTo(c.maxOffset);
      await t.pump();
      expect(t.widget<Button>(find.byType(Button)).onPressed, isNull);
      expect(
        find.descendant(
          of: find.byType(MessageScrollerButton),
          matching: find.byType(IgnorePointer),
        ),
        // Two: this component's `pointer-events-none`, and the disabled
        // `Button`'s own.
        findsNWidgets(2),
      );
    });

    testWidgets('the button carries the five measured colour overrides', (
      WidgetTester t,
    ) async {
      final MessageScrollerController c = MessageScrollerController(
        defaultScrollPosition: ScrollPosition.start,
      );
      addTearDown(c.dispose);
      await t.pumpWidget(scroller(c));
      await t.pump();
      final ThemeTokens theme = themeIn(t, MessageScroller);
      final Button button = t.widget<Button>(find.byType(Button));
      expect(button.variant, ButtonVariant.secondary);
      expect(button.size, ButtonSize.iconSm);
      expect(button.surface!.fill, theme.background);
      expect(button.surface!.hoverFill, theme.muted);
      expect(button.surface!.border, theme.border);
      expect(button.surface!.ink, theme.foreground);
    });

    testWidgets('pressing it rides a √distance smooth scroll to the end', (
      WidgetTester t,
    ) async {
      final MessageScrollerController c = MessageScrollerController(
        defaultScrollPosition: ScrollPosition.start,
      );
      addTearDown(c.dispose);
      await t.pumpWidget(scroller(c));
      await t.pump();
      final double max = c.maxOffset;

      await t.tap(find.byType(MessageScrollerButton));
      await t.pump();
      expect(c.autoscrolling, isTrue);
      // 398px measured 335ms; this transcript's own travel is close to it, so
      // a third of the way in it is moving and not yet arrived.
      await t.pump(const Duration(milliseconds: 110));
      expect(c.offset, greaterThan(0));
      expect(c.offset, lessThan(max));
      await t.pump(const Duration(seconds: 1));
      expect(c.offset, closeTo(max, 0.5));
      expect(c.autoscrolling, isFalse);
    });

    testWidgets('scrollToMessage finds an item by its id', (
      WidgetTester t,
    ) async {
      final MessageScrollerController c = MessageScrollerController(
        defaultScrollPosition: ScrollPosition.start,
      );
      addTearDown(c.dispose);
      await t.pumpWidget(scroller(c));
      await t.pump();
      await t.pump();
      unawaited(c.scrollToMessage('m9'));
      await t.pump();
      await t.pump(const Duration(seconds: 1));
      expect(c.offset, greaterThan(0));
    });
  });

  /* ── scroll-fade-b ────────────────────────────────────────────────────── */

  group('ScrollFade — the measured mask', () {
    test('the full fade is min(12%, 40px) of the viewport', () {
      // 12% of 320 is 38.4, under the 40px cap.
      expect(
        ScrollFade.fadeFor(height: 320, offset: 0, max: 398),
        closeTo(38.4, 0.001),
      );
      // 12% of 400 is 48, over the cap.
      expect(
        ScrollFade.fadeFor(height: 400, offset: 0, max: 398),
        closeTo(40, 0.001),
      );
    });

    test('it holds full height until the last 96px of travel', () {
      // Measured: full at scrollTop 299 of 398 (the range opens at 302).
      expect(
        ScrollFade.fadeFor(height: 320, offset: 299, max: 398),
        closeTo(38.4, 0.001),
      );
    });

    test('the three sampled factors reproduce', () {
      const double full = 38.4;
      // 358 / 398 — 58.33% through the 96px range, measured 0.358826 remaining.
      expect(
        ScrollFade.fadeFor(height: 320, offset: 358, max: 398) / full,
        closeTo(0.3588, 0.003),
      );
      // 374 — 75%, measured 0.129162.
      expect(
        ScrollFade.fadeFor(height: 320, offset: 374, max: 398) / full,
        closeTo(0.1292, 0.003),
      );
      // 382 — 87.5%, measured 0.0561308.
      expect(
        ScrollFade.fadeFor(height: 320, offset: 382, max: 398) / full,
        closeTo(0.0561, 0.003),
      );
      // The end.
      expect(ScrollFade.fadeFor(height: 320, offset: 398, max: 398), 0);
    });

    test('the curve is CSS ease-in-out, not --ease-in-out', () {
      // The measurement that separates them: 0.6412 against 0.716.
      expect(MotionCurves.symmetric.transform(0.5833), closeTo(0.6437, 0.005));
      expect(MotionCurves.move.transform(0.5833), isNot(closeTo(0.6437, 0.02)));
    });

    testWidgets('rendered: the bottom row is transparent and the top is opaque', (
      WidgetTester t,
    ) async {
      final MessageScrollerController c = MessageScrollerController(
        defaultScrollPosition: ScrollPosition.start,
      );
      addTearDown(c.dispose);
      await t.pumpWidget(
        host(
          RepaintBoundary(
            key: rasterKey,
            child: SizedBox(
              width: 200,
              height: 320,
              child: MessageScrollerProvider(
                controller: c,
                child: MessageScroller(
                  viewport: MessageScrollerViewport(
                    child: const MessageScrollerContent(
                      // One unbroken white column: `gap-6` between twenty boxes
                      // would put transparent stripes where the mask is sampled.
                      children: <Widget>[
                        SizedBox(
                          height: 800,
                          child: ColoredBox(color: Color(0xFFFFFFFF)),
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
      await t.pump();

      final ByteData shot = await raster(t);

      // The mask is 38.4px tall at the bottom of a 320px viewport: the last
      // row is fully transparent, and a row above the mask is fully opaque.
      expect(pixelAt(shot, 10, 319).a, closeTo(0, 0.02));
      expect(pixelAt(shot, 10, 240).a, closeTo(1, 0.02));
    });
  });

  /* ── Attachment ───────────────────────────────────────────────────────── */

  group('Attachment', () {
    Widget card({
      AttachmentState state = AttachmentState.done,
      AttachmentSize size = AttachmentSize.md,
      AttachmentOrientation orientation = AttachmentOrientation.horizontal,
      bool content = true,
    }) => host(
      SizedBox(
        width: 400,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Attachment(
            state: state,
            size: size,
            orientation: orientation,
            media: AttachmentMedia(
              child: Icon.lucide(
                Lucide.fileText,
                sizePx: AttachmentMedia.glyphFor(size, orientation),
              ),
            ),
            content: content
                ? const AttachmentContent(
                    title: AttachmentTitle('rarity-table.csv'),
                    description: AttachmentDescription('18 KB'),
                  )
                : null,
          ),
        ),
      ),
    );

    testWidgets('padding is uniform — the has-content rules are dead', (
      WidgetTester t,
    ) async {
      const Map<AttachmentSize, double> measured = <AttachmentSize, double>{
        AttachmentSize.md: 8,
        AttachmentSize.sm: 6,
        AttachmentSize.xs: 4,
      };
      for (final MapEntry<AttachmentSize, double> e in measured.entries) {
        expect(Attachment.paddingFor(e.key), e.value);
      }
    });

    testWidgets(
      'the three horizontal rungs step down and still fit their copy',
      (WidgetTester t) async {
        // Each rung grows around the copy it holds rather than pinning a box
        // the copy has to fit inside, so the assertion is the ordering and the
        // touch floor rather than three numbers.
        double previous = double.infinity;
        for (final AttachmentSize size in <AttachmentSize>[
          AttachmentSize.md,
          AttachmentSize.sm,
          AttachmentSize.xs,
        ]) {
          await t.pumpWidget(card(size: size));
          final double h = sizeOf(t, find.byType(Attachment)).height;
          expect(h, lessThan(previous), reason: size.label);
          expect(
            h,
            greaterThanOrEqualTo(TextStyles.small.step.leading * 2),
            reason: '${size.label} holds a title and a description',
          );
          previous = h;
          // `min-w-40`.
          expect(
            sizeOf(t, find.byType(Attachment)).width,
            greaterThanOrEqualTo(Attachment.horizontalMinWidth),
          );
        }
      },
    );

    testWidgets('a vertical card is 96 wide, or 120 once it carries content', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        card(orientation: AttachmentOrientation.vertical, content: false),
      );
      expect(sizeOf(t, find.byType(Attachment)).width, 96);
      await t.pumpWidget(card(orientation: AttachmentOrientation.vertical));
      expect(sizeOf(t, find.byType(Attachment)).width, 120);
    });

    testWidgets('the wells are 40 / 32 / 28 and xs takes the tighter radius', (
      WidgetTester t,
    ) async {
      expect(AttachmentMedia.wellFor(AttachmentSize.md), 40);
      expect(AttachmentMedia.wellFor(AttachmentSize.sm), 32);
      expect(AttachmentMedia.wellFor(AttachmentSize.xs), 28);
      expect(AttachmentMedia.radiusFor(AttachmentSize.md), Radii.lg);
      expect(AttachmentMedia.radiusFor(AttachmentSize.xs), Radii.md);
      expect(Attachment.radiusFor(AttachmentSize.md), Radii.xl);
      expect(Attachment.radiusFor(AttachmentSize.xs), Radii.lg);
    });

    testWidgets('the glyph is 16 / 16 / 14, and 24 in a vertical card', (
      WidgetTester t,
    ) async {
      const AttachmentOrientation h = AttachmentOrientation.horizontal;
      const AttachmentOrientation v = AttachmentOrientation.vertical;
      expect(AttachmentMedia.glyphFor(AttachmentSize.md, h), 16);
      expect(AttachmentMedia.glyphFor(AttachmentSize.sm, h), 16);
      expect(AttachmentMedia.glyphFor(AttachmentSize.xs, h), 14);
      expect(AttachmentMedia.glyphFor(AttachmentSize.md, v), 24);
      expect(AttachmentMedia.glyphFor(AttachmentSize.sm, v), 24);
      // `xs` is written after `vertical`, so it wins even there.
      expect(AttachmentMedia.glyphFor(AttachmentSize.xs, v), 14);
    });

    testWidgets('a vertical sm well stays 32 wide inside a 120 tile', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        card(
          size: AttachmentSize.sm,
          orientation: AttachmentOrientation.vertical,
        ),
      );
      // The *well*, not the slot: a vertical card stretches its children, so
      // the media slot spans the tile and lays a fixed well out at its start.
      expect(
        sizeOf(
          t,
          find
              .descendant(
                of: find.byType(AttachmentMedia),
                matching: find.byType(SizedBox),
              )
              .first,
        ),
        const Size(32, 32),
      );

      await t.pumpWidget(card(orientation: AttachmentOrientation.vertical));
      // `default` takes `w-full`: 120 less `p-2` twice and the border twice.
      expect(sizeOf(t, find.byType(AttachmentMedia)).width, closeTo(102, 0.5));
    });

    testWidgets('error tints the border, the well and the description', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          SizedBox(
            width: 400,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Attachment(
                state: AttachmentState.error,
                media: AttachmentMedia(
                  child: Icon.lucide(Lucide.circleAlert, sizePx: 16),
                ),
                content: const AttachmentContent(
                  title: AttachmentTitle('rarity-table.csv'),
                  description: AttachmentDescription('Upload failed'),
                ),
              ),
            ),
          ),
        ),
      );
      final ThemeTokens theme = themeIn(t, Attachment);
      final BoxDecoration well =
          t
                  .widget<Container>(
                    find
                        .descendant(
                          of: find.byType(AttachmentMedia),
                          matching: find.byType(Container),
                        )
                        .first,
                  )
                  .decoration!
              as BoxDecoration;
      expect(well.color, theme.destructive.withValues(alpha: 0.10));

      final Text desc = t.widget<Text>(find.text('Upload failed'));
      expect(desc.style?.color, theme.destructiveText);
    });

    testWidgets('idle is the only dashed card', (WidgetTester t) async {
      for (final AttachmentState s in AttachmentState.values) {
        await t.pumpWidget(card(state: s));
        // `Icon` is a `CustomPaint` too, so the dash is found by the slot it
        // paints in rather than by type.
        expect(
          find.descendant(
            of: find.byType(Attachment),
            matching: find.byWidgetPredicate(
              (Widget w) => w is CustomPaint && w.foregroundPainter != null,
            ),
          ),
          s == AttachmentState.idle ? findsOneWidget : findsNothing,
          reason: s.name,
        );
      }
    });

    testWidgets('rendered: the dashed border alternates ink and gap', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          RepaintBoundary(
            key: rasterKey,
            child: SizedBox(
              width: 160,
              height: 80,
              child: Attachment(
                state: AttachmentState.idle,
                media: AttachmentMedia(
                  child: Icon.lucide(Lucide.fileText, sizePx: 16),
                ),
              ),
            ),
          ),
        ),
      );
      await t.pump();

      final ByteData shot = await raster(t);

      // Walk the top edge across the straight run and count the runs of ink.
      // A 3-on/3-off dash over 70px of straight edge must change state at
      // least a dozen times; a solid border never changes at all.
      // The card's fill paints under the whole edge, so the dash is read as
      // "nearer `--border` than `--card`" rather than by alpha: the two are
      // rgb(39,39,42) and rgb(24,24,27) in dark, 15/255 apart.
      final ThemeTokens theme = themeIn(t, Attachment);
      double distance(Color a, Color b) =>
          (a.r - b.r).abs() + (a.g - b.g).abs() + (a.b - b.b).abs();
      int flips = 0;
      bool? previous;
      for (int x = 40; x < 110; x++) {
        final Color px = pixelAt(shot, x, 0);
        final bool ink = distance(px, theme.border) < distance(px, theme.card);
        if (previous != null && ink != previous) flips++;
        previous = ink;
      }
      // 70px of straight edge on a 3-on / 3-off rhythm is eleven full cycles.
      expect(flips, greaterThan(8));
    });

    testWidgets('the title shimmers only while uploading or processing', (
      WidgetTester t,
    ) async {
      for (final AttachmentState s in AttachmentState.values) {
        await t.pumpWidget(card(state: s));
        final bool shimmering =
            s == AttachmentState.uploading || s == AttachmentState.processing;
        expect(
          find.byType(AttachmentStatusText),
          shimmering ? findsOneWidget : findsNothing,
          reason: s.name,
        );
      }
    });

    testWidgets('the image variant dims to 60% unless done or idle', (
      WidgetTester t,
    ) async {
      for (final AttachmentState s in AttachmentState.values) {
        await t.pumpWidget(
          host(
            SizedBox(
              width: 400,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Attachment(
                  state: s,
                  orientation: AttachmentOrientation.vertical,
                  media: const AttachmentMedia(
                    variant: AttachmentMediaVariant.image,
                    child: ColoredBox(color: Color(0xFF00FF00)),
                  ),
                ),
              ),
            ),
          ),
        );
        final double opacity = t
            .widget<Opacity>(
              find.descendant(
                of: find.byType(AttachmentMedia),
                matching: find.byType(Opacity),
              ),
            )
            .opacity;
        final bool lit = s == AttachmentState.done || s == AttachmentState.idle;
        expect(opacity, lit ? 1 : AttachmentMedia.imageDimmed, reason: s.name);
      }
    });

    testWidgets('the save control rolls to a check for 1600ms and fires once', (
      WidgetTester t,
    ) async {
      final List<String> saved = <String>[];
      await t.pumpWidget(
        host(
          SizedBox(
            width: 400,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Attachment(
                media: AttachmentMedia(
                  child: Icon.lucide(Lucide.fileText, sizePx: 16),
                ),
                content: const AttachmentContent(
                  title: AttachmentTitle('grading-report.pdf'),
                ),
                actions: AttachmentActions(
                  children: <Widget>[
                    AttachmentAction(
                      downloadName: 'grading-report.pdf',
                      onDownload: saved.add,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(t.widget<IconSwap>(find.byType(IconSwap)).activeIndex, 0);
      await t.tap(find.byType(AttachmentAction));
      await t.pump();
      expect(saved, <String>['grading-report.pdf']);
      expect(t.widget<IconSwap>(find.byType(IconSwap)).activeIndex, 1);

      await t.pump(AttachmentAction.savingWindow);
      await t.pump();
      expect(t.widget<IconSwap>(find.byType(IconSwap)).activeIndex, 0);
      // Settle the swap's own tickers.
      await t.pump(const Duration(seconds: 1));
    });

    testWidgets('a save control is a ghost icon-xs button with a label', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          SizedBox(
            width: 400,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Attachment(
                media: AttachmentMedia(
                  child: Icon.lucide(Lucide.fileText, sizePx: 16),
                ),
                actions: const AttachmentActions(
                  children: <Widget>[
                    AttachmentAction(downloadName: 'grading-report.pdf'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      final Button button = t.widget<Button>(find.byType(Button));
      expect(button.variant, ButtonVariant.ghost);
      expect(button.size, ButtonSize.iconXs);
      expect(button.label, 'Download grading-report.pdf');
      expect(sizeOf(t, find.byType(Button)), const Size(24, 24));
      await t.pump(const Duration(seconds: 1));
    });

    testWidgets('a previewable well mounts a zoom-in trigger over the media', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        overlayHost(
          SizedBox(
            width: 400,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Attachment(
                orientation: AttachmentOrientation.vertical,
                media: const AttachmentMedia(
                  variant: AttachmentMediaVariant.image,
                  previewName: 'sample-card.png',
                  preview: ColoredBox(color: Color(0xFF00FF00)),
                  child: ColoredBox(color: Color(0xFF00FF00)),
                ),
                content: const AttachmentContent(
                  title: AttachmentTitle('sample-card.png'),
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(AttachmentTrigger), findsOneWidget);
      expect(
        t.widget<AttachmentTrigger>(find.byType(AttachmentTrigger)).label,
        'Open sample-card.png full size',
      );
      final MouseRegion region = t.widget<MouseRegion>(
        find
            .descendant(
              of: find.byType(AttachmentTrigger),
              matching: find.byType(MouseRegion),
            )
            .first,
      );
      expect(region.cursor, SystemMouseCursors.zoomIn);
    });

    testWidgets('the tray keeps 12px gaps and fades only where it can travel', (
      WidgetTester t,
    ) async {
      expect(AttachmentGroup.gap, 12);
      expect(AttachmentGroup.paddingY, 4);
      expect(AttachmentGroup.scrollPadding, 4);
    });
  });

  /* ── The shared foundation extensions ─────────────────────────────────── */

  group('foundation', () {
    test('MotionCurves.symmetric preserves measured scroll geometry', () {
      expect(MotionCurves.symmetric, const Cubic(0.42, 0, 0.58, 1));
      expect(MotionCurves.symmetric, isNot(MotionCurves.move));
      // Not on `all`: it is a stock keyword the system did not choose.
      expect(MotionCurves.all.contains(MotionCurves.symmetric), isFalse);
    });

    test('MotionDurations.frame is one 60 Hz frame', () {
      expect(MotionDurations.frame.inMicroseconds, 16667);
      // The measured law: 100px in ~168ms, 398px in ~335ms.
      expect((MotionDurations.frame * 10).inMilliseconds, closeTo(167, 2));
      expect((MotionDurations.frame * 19.95).inMilliseconds, closeTo(332, 4));
    });

    test('chat anatomy reads at the two public copy roles', () {
      expect(TextStyles.body.step, const TypeStep(16, 24));
      expect(TextStyles.small.step, const TypeStep(14, 20));
    });

    testWidgets('Icon.lucide paints the generated registry', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const Icon.lucide(Lucide.bot)));
      expect(sizeOf(t, find.byType(Icon)), const Size(16, 16));
      expect(Lucide.bot.name, 'bot');
      expect(lucideByName['circle-alert'], Lucide.circleAlert);
    });
  });
}

/// `unawaited`, without pulling `dart:async` into the import list for one call.
void unawaited(Future<void> future) {}
