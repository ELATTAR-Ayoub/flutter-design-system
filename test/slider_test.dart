import 'dart:math' as math;
import 'dart:ui' as ui show Image, ImageByteFormat;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/rendering.dart' hide ScrollDirection;
import 'package:flutter/services.dart';
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

/// `Slider` — the fourth control family, and the first genuinely new painter
/// since phase 3.
///
/// Every number here was probed against the live reference at
/// `localhost:3000/design-system/components/base/selection`, 1440 × 900, dark,
/// on 2026-08-15 — the static geometry with `getComputedStyle` /
/// `getBoundingClientRect`, and every **behaviour** by driving a real pointer
/// or keyboard gesture with puppeteer and sampling the result on every
/// `requestAnimationFrame`. Where a class list and a driven gesture disagree,
/// the gesture is what these tests pin.
///
/// **No `pumpAndSettle` over a live tween** — the ring runs 250ms on the spring
/// and the scale runs not at all, so the frames are stepped by hand.

Widget host(
  Widget child, {
  ColorMode mode = ColorMode.dark,
  bool disableAnimations = false,
}) {
  return MediaQuery(
    data: MediaQueryData(
      size: const Size(1440, 900),
      disableAnimations: disableAnimations,
    ),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ThemeScope(
        controller: ThemeController(mode: mode),
        child: Center(child: child),
      ),
    ),
  );
}

/// The two panel sliders' measure — `max-w-md`, `--container-md`.
const double _panel = 448;

/// The matrix cells' `className="w-40"`.
const double _cell = 160;

/// `size-5` on a 20px knob, so the travel is the root less the knob.
double get _travel => _panel - Slider.thumbSize;

/// The track's content box: the root minus its 1px border on each side.
double get _content => _panel - 2 * BorderWidths.hairline;

/// Half a logical pixel — the band the two coordinate spaces are pinned to.
const double _tolerance = 0.5;

/// A slider at [width], holding [values], reporting into [seen].
Widget slider({
  required List<double> values,
  List<double>? seen,
  double width = _panel,
  double min = 0,
  double max = 100,
  double step = 1,
  bool enabled = true,
  bool live = true,
  String? label,
}) {
  return SizedBox(
    width: width,
    child: Slider(
      values: values,
      min: min,
      max: max,
      step: step,
      enabled: enabled,
      label: label,
      onChanged: live
          ? (List<double> next) {
              seen
                ?..clear()
                ..addAll(next);
            }
          : null,
    ),
  );
}

/// A stateful harness, for the tests that need the control to actually move.
class _Live extends StatefulWidget {
  const _Live({
    required this.initial,
    this.max = 100,
    this.step = 1,
    this.enabled = true,
  });

  final List<double> initial;
  final double max;
  final double step;
  final bool enabled;

  @override
  State<_Live> createState() => _LiveState();
}

class _LiveState extends State<_Live> {
  late List<double> values = List<double>.of(widget.initial);

  @override
  Widget build(BuildContext context) => SizedBox(
    width: _panel,
    child: Slider(
      values: values,
      max: widget.max,
      step: widget.step,
      enabled: widget.enabled,
      onChanged: (List<double> next) => setState(() => values = next),
    ),
  );
}

List<double> valuesOf(WidgetTester t) =>
    (t.state(find.byType(_Live)) as _LiveState).values;

/// Every [Surface] the slider paints, in tree order: the track, then
/// the range inside it, then one per thumb.
List<Surface> surfaces(WidgetTester t) => t
    .widgetList<Surface>(
      find.descendant(of: find.byType(Slider), matching: find.byType(Surface)),
    )
    .toList();

/// The rect of the nth painted surface, in the slider's own coordinates.
Rect surfaceRect(WidgetTester t, int index) {
  final Finder all = find.descendant(
    of: find.byType(Slider),
    matching: find.byType(Surface),
  );
  final RenderBox box = t.renderObject<RenderBox>(all.at(index));
  final RenderBox root = t.renderObject<RenderBox>(find.byType(Slider));
  return box.localToGlobal(Offset.zero, ancestor: root) & box.size;
}

/// The `ring-3` layer [Button.withFocusRing] prepends: zero offset, zero
/// blur, 3px spread, in front of `--shadow-btn`'s own four.
Color ringOf(Surface surface, ThemeTokens theme) =>
    surface.spec.layers.first.color(theme);

Color borderOf(Surface surface) => (surface.border! as Border).top.color;

/// One rasterised pixel ROW straight through the middle of [child].
///
/// The channel and its fill are a [CustomPainter]'s output, so what a
/// `ShadowStyle` claims and what lands on the canvas are two different
/// assertions. This reads the canvas.
Future<List<Color>> _row(
  WidgetTester t,
  Widget child, {
  required ColorMode mode,
}) async {
  await t.pumpWidget(
    host(
      RepaintBoundary(key: const Key('raster'), child: child),
      mode: mode,
    ),
  );
  await t.pump(MotionDurations.normal);
  await t.pump(MotionDurations.normal);

  final RenderRepaintBoundary box = t.renderObject(
    find.byKey(const Key('raster')),
  );
  final ui.Image image = (await t.runAsync(() => box.toImage(pixelRatio: 1)))!;
  final ByteData bytes = (await t.runAsync(
    () async => (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!,
  ))!;
  final int w = image.width;
  final int y = image.height ~/ 2;
  final List<Color> row = <Color>[
    for (int x = 0; x < w; x++)
      Color.from(
        alpha: bytes.getUint8((y * w + x) * 4 + 3) / 255,
        red: bytes.getUint8((y * w + x) * 4) / 255,
        green: bytes.getUint8((y * w + x) * 4 + 1) / 255,
        blue: bytes.getUint8((y * w + x) * 4 + 2) / 255,
      ),
  ];
  image.dispose();
  return row;
}

/// One rasterised pixel COLUMN at [x], for the parts of the socket that are a
/// vertical phenomenon.
///
/// `--shadow-pressed` is `inset 0 2px 5px` + `inset 0 1px 2px`: both have a
/// POSITIVE `dy`, so the displaced hole sits low and the ring they leave is a
/// band along the TOP inside edge. Reading a row across the channel cannot see
/// that; reading down through it can.
Future<List<Color>> _column(
  WidgetTester t,
  Widget child, {
  required ColorMode mode,
  required int x,
}) async {
  await t.pumpWidget(
    host(
      RepaintBoundary(key: const Key('raster'), child: child),
      mode: mode,
    ),
  );
  await t.pump(MotionDurations.normal);
  await t.pump(MotionDurations.normal);

  final RenderRepaintBoundary box = t.renderObject(
    find.byKey(const Key('raster')),
  );
  final ui.Image image = (await t.runAsync(() => box.toImage(pixelRatio: 1)))!;
  final ByteData bytes = (await t.runAsync(
    () async => (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!,
  ))!;
  final int w = image.width;
  final List<Color> column = <Color>[
    for (int y = 0; y < image.height; y++)
      Color.from(
        alpha: bytes.getUint8((y * w + x) * 4 + 3) / 255,
        red: bytes.getUint8((y * w + x) * 4) / 255,
        green: bytes.getUint8((y * w + x) * 4 + 1) / 255,
        blue: bytes.getUint8((y * w + x) * 4 + 2) / 255,
      ),
  ];
  image.dispose();
  return column;
}

double _luma(Color c) => c.r * 0.2126 + c.g * 0.7152 + c.b * 0.0722;

/// How far apart two colours are, as a plain RGB distance.
double _gap(Color a, Color b) => math.sqrt(
  math.pow(a.r - b.r, 2) + math.pow(a.g - b.g, 2) + math.pow(a.b - b.b, 2),
);

/// Which of [candidates] a rasterised pixel is nearest.
///
/// Exact equality is the wrong assertion on a **10px** channel: both of
/// `--shadow-pressed`'s inset layers blur 5px and 2px from the edges, so they
/// reach the middle of a box this shallow and tint every pixel of it. What
/// survives that — and what the design actually depends on — is which token a
/// pixel belongs to. This is the same shape of pin `inputs_test` makes on the
/// input socket, one rung more tolerant because the box is a fifth the height.
Color _nearest(Color pixel, List<Color> candidates) => candidates.reduce(
  (Color a, Color b) => _gap(pixel, a) <= _gap(pixel, b) ? a : b,
);

/// The thumbs' [FocusNode]s, in order.
///
/// Focus is requested directly rather than tabbed to: this harness has no
/// `WidgetsApp`, so there is no `Shortcuts`/`Actions` pair to turn a Tab key
/// into a traversal. What is under test is what a focused thumb does, not
/// Flutter's traversal.
List<FocusNode> thumbNodes(WidgetTester t) => t
    .widgetList<Focus>(
      find.descendant(of: find.byType(Slider), matching: find.byType(Focus)),
    )
    .map((Focus f) => f.focusNode!)
    .toList();

/// Focuses thumb [index] and lets the rebuild it schedules land.
///
/// Two pumps, and both are load-bearing: `requestFocus` is applied by the
/// [FocusManager] on the next frame, and the `onFocusChange` that follows calls
/// `setState`, which needs a frame of its own before the ring's tween has an
/// end to travel to. One pump leaves the tween built but not yet started.
Future<void> focusThumb(WidgetTester t, int index) async {
  thumbNodes(t)[index].requestFocus();
  await t.pump();
  await t.pump();
}

/// The centre of thumb [index], in global coordinates.
Offset thumbCentre(WidgetTester t, int index) =>
    t.getTopLeft(find.byType(Slider)) + surfaceRect(t, 2 + index).center;

void main() {
  // ───────────────────────────────────────────────────────────────────────────
  // Geometry — the two coordinate spaces
  // ───────────────────────────────────────────────────────────────────────────

  group('geometry', () {
    testWidgets('the root IS the track: 10px, and the knobs overflow it', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(slider(values: <double>[40])));

      final Size root = t.getSize(find.byType(Slider));
      expect(
        root.height,
        Slider.trackHeight,
        reason: 'the root box is the channel; `h-2.5` is 10px',
      );
      expect(root.width, _panel);

      // The track fills it; the knob stands 5px proud top and bottom.
      expect(
        surfaceRect(t, 0).height,
        Slider.trackHeight,
        reason: 'track `grow` + `data-horizontal:h-2.5`',
      );
      final Rect thumb = surfaceRect(t, 2);
      expect(thumb.size, Size(Slider.thumbSize, Slider.thumbSize));
      expect(
        thumb.top,
        closeTo(-(Slider.thumbSize - Slider.trackHeight) / 2, 0.01),
        reason: '`items-center` on a box shorter than the knob',
      );
    });

    testWidgets('the range is a percentage of the TRACK CONTENT box', (
      WidgetTester t,
    ) async {
      // The price panel: [10, 240] of 0–500 at 448 wide.
      await t.pumpWidget(
        host(slider(values: <double>[10, 240], min: 0, max: 500, step: 5)),
      );

      final Rect range = surfaceRect(t, 1);
      // Probed 8.90625 from the content edge, and 205.19 wide.
      expect(
        range.left - BorderWidths.hairline,
        closeTo(10 / 500 * _content, _tolerance),
        reason: 'left = 10/500 x 446 = 8.92, probed 8.90625',
      );
      expect(
        range.width,
        closeTo(230 / 500 * _content, _tolerance),
        reason: 'width = 230/500 x 446 = 205.16, probed 205.19',
      );
      expect(
        range.height,
        Slider.trackHeight - 2 * BorderWidths.hairline,
        reason: 'the range is the track content box tall — 8px',
      );
    });

    testWidgets('a single value fills from the start of the channel', (
      WidgetTester t,
    ) async {
      // The odds panel: [25] of 0–100. Probed: range 111.5 wide at offset 0.
      await t.pumpWidget(host(slider(values: <double>[25])));
      final Rect range = surfaceRect(t, 1);
      expect(
        range.left,
        closeTo(BorderWidths.hairline, _tolerance),
        reason: 'one thumb means the fill starts at the minimum',
      );
      expect(
        range.width,
        closeTo(25 / 100 * _content, _tolerance),
        reason: '25/100 x 446 = 111.5, probed exactly 111.5',
      );
    });

    testWidgets('the thumb travels the ROOT less its own width', (
      WidgetTester t,
    ) async {
      // Four independent cells, all probed exact.
      for (final (
            List<double> values,
            double width,
            double max,
            int index,
            double want,
          )
          probe
          in <(List<double>, double, double, int, double)>[
            (<double>[25], _panel, 100, 0, 107), // 0.25 x 428
            (<double>[40], _cell, 100, 0, 56), //  0.40 x 140
            (<double>[20, 70], _cell, 100, 0, 28), // 0.20 x 140
            (<double>[10, 240], _panel, 500, 1, 205.44), // 0.48 x 428
          ]) {
        await t.pumpWidget(
          host(
            slider(values: probe.$1, width: probe.$2, max: probe.$3, step: 5),
          ),
        );
        final Rect thumb = surfaceRect(t, 2 + probe.$4);
        expect(
          thumb.left,
          closeTo(probe.$5, _tolerance),
          reason: 'thumb ${probe.$4} of ${probe.$1} at ${probe.$2} wide',
        );
      }
    });

    testWidgets('the two spaces disagree everywhere but the midpoint', (
      WidgetTester t,
    ) async {
      // DRIFT 8. Radix's own, inherited verbatim — the fill and the knob are
      // measured against boxes 2px apart, so they line up only at 50%.
      await t.pumpWidget(host(slider(values: <double>[50])));
      expect(
        surfaceRect(t, 1).right,
        closeTo(surfaceRect(t, 2).left + Slider.thumbSize / 2, _tolerance),
        reason: 'at 50% the fill ends exactly under the knob\'s centre',
      );

      await t.pumpWidget(host(slider(values: <double>[25])));
      final double fillEnd = surfaceRect(t, 1).right;
      final double knobCentre = surfaceRect(t, 2).left + Slider.thumbSize / 2;
      expect(
        (fillEnd - knobCentre).abs(),
        greaterThan(_tolerance),
        reason: 'and nowhere else — this misalignment is the reference\'s',
      );
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // The painter, read off the canvas
  // ───────────────────────────────────────────────────────────────────────────

  group('rasterised', () {
    for (final ColorMode mode in <ColorMode>[ColorMode.light, ColorMode.dark]) {
      final ThemeTokens theme = mode == ColorMode.light
          ? ThemeTokens.light
          : ThemeTokens.dark;

      testWidgets('$mode: the fill is --action-ink and the channel is --muted', (
        WidgetTester t,
      ) async {
        final List<Color> row = await _row(
          t,
          slider(values: <double>[50]),
          mode: mode,
        );
        expect(row.length, _panel.round());

        // The three tokens this row could plausibly be painted in. `--primary`
        // is in the list precisely because it is the mistake the source
        // comment warns against: it measures 1.63:1 against `--muted` where
        // `--action-ink` measures 6.88:1.
        final List<Color> palette = <Color>[
          theme.actionText,
          theme.muted,
          theme.primary,
        ];
        expect(
          theme.actionText,
          isNot(theme.primary),
          reason: 'the anti-assertion has to be able to fail',
        );

        // Left of the midpoint is the lit fill; right of it is the socket.
        expect(
          _nearest(row[80], palette),
          theme.actionText,
          reason: '$mode: `bg-action-ink`, NOT `bg-primary`',
        );
        expect(
          _nearest(row[380], palette),
          theme.muted,
          reason: '$mode: `bg-muted` — the empty channel',
        );

        // And they are genuinely different surfaces, not one flat strip.
        expect(
          _gap(row[80], row[380]),
          greaterThan(0.1),
          reason: '$mode: the fill and the channel must read apart',
        );
      });

      testWidgets('$mode: the channel is a sunken socket, not a flat fill', (
        WidgetTester t,
      ) async {
        // An empty slider, read down a stretch of bare channel: the knob sits
        // at the far left and the fill is zero wide, so x = 300 is nothing but
        // the groove.
        final List<Color> column = await _column(
          t,
          slider(values: <double>[0]),
          mode: mode,
          x: 300,
        );
        expect(column.length, Slider.trackHeight.round());

        // Inside the 1px `--input` border, the top band carries the inset and
        // the bottom does not — the hole is displaced DOWN by 2px, so the ring
        // it leaves is along the top.
        expect(
          _luma(column[2]),
          lessThan(_luma(column[7])),
          reason:
              '$mode: the sunken band is at the top, as a positive dy '
              'puts it — an inverted socket paints the complement of this',
        );
        expect(
          _nearest(column[7], <Color>[theme.muted, theme.card]),
          theme.muted,
          reason: '$mode: an empty channel is `--muted`, not the card',
        );
      });
    }
  });

  // ───────────────────────────────────────────────────────────────────────────
  // The three shadow tokens
  // ───────────────────────────────────────────────────────────────────────────

  group('the raised/recessed pair', () {
    testWidgets('sunken track, lit fill, raised knob', (WidgetTester t) async {
      await t.pumpWidget(host(slider(values: <double>[40])));
      final ThemeTokens theme = ThemeScope.of(t.element(find.byType(Slider)));
      final List<Surface> painted = surfaces(t);

      expect(painted[0].spec, Shadows.inset, reason: 'track `shadow-pressed`');
      expect(painted[0].fill, theme.muted);
      expect(borderOf(painted[0]), theme.input, reason: '`border-input`');

      expect(
        painted[1].spec,
        Shadows.controlPrimary,
        reason: 'range `shadow-btn-primary` — the blue glow',
      );
      expect(painted[1].fill, theme.actionText);
      expect(
        painted[1].radius,
        BorderRadius.zero,
        reason: 'probed `border-radius: 0px`; the channel clips its ends',
      );

      expect(
        painted[2].fill,
        theme.foreground,
        reason: 'thumb `bg-foreground`',
      );
      expect(borderOf(painted[2]), theme.input);
      expect(
        painted[2].spec.layers.length,
        Shadows.control.layers.length + 1,
        reason: 'the ring slot is always present, at zero alpha when at rest',
      );
    });

    testWidgets('the range is clipped by the channel', (WidgetTester t) async {
      await t.pumpWidget(host(slider(values: <double>[40])));
      expect(
        find.descendant(
          of: find.byType(Slider),
          matching: find.byType(ClipRRect),
        ),
        findsOneWidget,
        reason: 'track `overflow-hidden` is what gives the fill its corners',
      );
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Ring and scale — measured to move DIFFERENTLY
  // ───────────────────────────────────────────────────────────────────────────

  group('the ring springs and the scale snaps', () {
    testWidgets('a focused thumb prepends ring-3 at half alpha', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(slider(values: <double>[40])));
      final ThemeTokens theme = ThemeScope.of(t.element(find.byType(Slider)));

      expect(
        ringOf(surfaces(t)[2], theme).a,
        0,
        reason: 'at rest the ring is its own hue at zero alpha',
      );

      await focusThumb(t, 0);
      expect(
        thumbNodes(t)[0].hasFocus,
        isTrue,
        reason:
            'the thumb has to actually hold focus for this to mean '
            'anything',
      );
      await t.pump(MotionDurations.normal);

      final Color ring = ringOf(surfaces(t)[2], theme);
      expect(
        ring.a,
        closeTo(0.5, 0.01),
        reason:
            'probed `oklab(... / 0.5) 0px 0px 0px 3px` on the focused '
            'thumb, in front of all four --shadow-btn layers',
      );
      expect(ring.r, closeTo(theme.ring.r, 0.01), reason: '`ring-ring/50`');
    });

    testWidgets(
      'the ring TWEENS — it is in transition-[transform,box-shadow]',
      (WidgetTester t) async {
        await t.pumpWidget(host(slider(values: <double>[40])));
        final ThemeTokens theme = ThemeScope.of(t.element(find.byType(Slider)));

        await focusThumb(t, 0);

        // An eighth of the way in: still climbing, and the whole assertion is
        // that it is caught between its two ends rather than at one of them.
        await t.pump(MotionDurations.normal ~/ 8);
        final double early = ringOf(surfaces(t)[2], theme).a;
        expect(early, greaterThan(0), reason: 'the ring has started');
        expect(
          early,
          lessThan(0.5),
          reason: 'and has not arrived — a box-shadow interpolates',
        );

        // Half way in it is already PAST its target. `--ease-spring` is
        // `cubic-bezier(0.34, 1.56, 0.64, 1)`, probed on the thumb's own
        // `transition-timing-function`, and a control point above 1 is what
        // overshoot means. An `--ease-out` ring could never produce this, which
        // is what makes it a pin on the curve and not merely on the duration.
        await t.pump(MotionDurations.normal ~/ 2 - MotionDurations.normal ~/ 8);
        expect(
          ringOf(surfaces(t)[2], theme).a,
          greaterThan(0.5),
          reason: 'the spring overshoots its target before settling back',
        );

        await t.pump(MotionDurations.normal);
        expect(
          ringOf(surfaces(t)[2], theme).a,
          closeTo(0.5, 0.01),
          reason: 'and settles on `ring-ring/50`',
        );
      },
    );

    testWidgets('the scale SNAPS — `scale` is not in that list', (
      WidgetTester t,
    ) async {
      // Measured: driving a real pointer over the knob and sampling every
      // frame produced `none -> 1.1 -> 1.25 -> 1.1` with ZERO intermediate
      // values across ~100 samples. Tailwind v4's `scale-*` sets the CSS
      // `scale` property; the thumb transitions `transform` and `box-shadow`.
      await t.pumpWidget(host(const _Live(initial: <double>[40])));

      double scaleNow() => t
          .widgetList<Transform>(
            find.descendant(
              of: find.byType(Slider),
              matching: find.byType(Transform),
            ),
          )
          .map((Transform x) => x.transform.getMaxScaleOnAxis())
          .first;

      expect(scaleNow(), 1, reason: 'at rest');

      final TestGesture gesture = await t.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(gesture.removePointer);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(thumbCentre(t, 0));
      await t.pump();
      // ONE frame after the pointer arrives it is already fully grown.
      expect(
        scaleNow(),
        MotionTransforms.sliderThumbHoverScale,
        reason: 'hover:scale-110 arrives whole, in a single frame',
      );

      await t.pump(MotionDurations.normal ~/ 2);
      expect(
        scaleNow(),
        MotionTransforms.sliderThumbHoverScale,
        reason: 'and it never passes through an intermediate value',
      );
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Interaction — every pin below is a driven gesture on the reference
  // ───────────────────────────────────────────────────────────────────────────

  group('pointer', () {
    testWidgets('a press maps against the ROOT width, not the thumb travel', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const _Live(initial: <double>[25])));
      final Offset origin = t.getTopLeft(find.byType(Slider));

      // Probed: a pointer 131px into a 448-wide root reported 29, and
      // 131/448 x 100 = 29.24. Against the 428 travel it would read 30.6.
      await t.tapAt(origin + const Offset(131, 5));
      await t.pump();
      expect(
        valuesOf(t).single,
        29,
        reason:
            'the pointer maps against the root; the knob renders '
            'against the travel — the same disagreement as the fill',
      );
    });

    testWidgets('a track press grabs the NEAREST thumb', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(const _Live(initial: <double>[10, 240], max: 500, step: 5)),
      );
      final Offset origin = t.getTopLeft(find.byType(Slider));

      // Probed: [10, 240], clicked 30% of the way between the knobs ->
      // [85, 240]. The low thumb moves; the high one is untouched.
      final double lowCentre = 10 / 500 * _travel + Slider.thumbSize / 2;
      final double highCentre = 240 / 500 * _travel + Slider.thumbSize / 2;
      await t.tapAt(
        origin + Offset(lowCentre + (highCentre - lowCentre) * 0.3, 5),
      );
      await t.pump();

      expect(valuesOf(t)[0], 85, reason: 'the near knob took the press');
      expect(valuesOf(t)[1], 240, reason: 'and the far one did not move');
    });

    testWidgets('a drag tracks the pointer with no tween', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const _Live(initial: <double>[25])));
      final Offset start =
          t.getTopLeft(find.byType(Slider)) +
          Offset(25 / 100 * _travel + Slider.thumbSize / 2, 5);

      final TestGesture gesture = await t.startGesture(start);
      await t.pump();
      await gesture.moveBy(const Offset(140, 0));
      // ONE frame — the position is `left`, which nothing interpolates.
      await t.pump();
      final double afterOneFrame = valuesOf(t).single;
      await t.pump(MotionDurations.normal);
      expect(
        valuesOf(t).single,
        afterOneFrame,
        reason: 'the value settled in the first frame and did not glide',
      );

      await gesture.up();
      await t.pump();
      expect(valuesOf(t).single, greaterThan(25));
    });

    testWidgets('thumbs stop at each other and may coincide', (
      WidgetTester t,
    ) async {
      // Probed: dragging the low knob of [0, 500] past the end produced
      // [500, 500] both DURING the drag and after release. No crossing.
      await t.pumpWidget(
        host(const _Live(initial: <double>[0, 500], max: 500, step: 5)),
      );
      final Offset origin = t.getTopLeft(find.byType(Slider));

      final TestGesture gesture = await t.startGesture(
        origin + Offset(Slider.thumbSize / 2, 5),
      );
      await t.pump();
      await gesture.moveTo(origin + const Offset(_panel + 60, 5));
      await t.pump();
      expect(valuesOf(t), <double>[
        500,
        500,
      ], reason: 'the low knob clamped at the high one and stopped');

      await gesture.up();
      await t.pump();
      expect(valuesOf(t), <double>[500, 500], reason: 'and stayed there');
    });

    testWidgets('every emitted value is a whole number of steps', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(const _Live(initial: <double>[10, 240], max: 500, step: 5)),
      );
      final Offset origin = t.getTopLeft(find.byType(Slider));
      final TestGesture gesture = await t.startGesture(
        origin + const Offset(20, 5),
      );
      for (int i = 1; i <= 12; i++) {
        await gesture.moveBy(const Offset(9, 0));
        await t.pump();
        expect(
          valuesOf(t)[0] % 5,
          0,
          reason: 'step=5 quantises every intermediate value too',
        );
      }
      await gesture.up();
      await t.pump();
    });
  });

  group('keyboard', () {
    Future<void> pumpFocused(WidgetTester t, {double step = 1}) async {
      await t.pumpWidget(host(_Live(initial: const <double>[50], step: step)));
      await focusThumb(t, 0);
    }

    testWidgets('arrows move one step, both axes', (WidgetTester t) async {
      await pumpFocused(t);
      for (final (LogicalKeyboardKey key, double want)
          in <(LogicalKeyboardKey, double)>[
            (LogicalKeyboardKey.arrowRight, 51),
            (LogicalKeyboardKey.arrowUp, 52),
            (LogicalKeyboardKey.arrowLeft, 51),
            (LogicalKeyboardKey.arrowDown, 50),
          ]) {
        await t.sendKeyEvent(key);
        await t.pump();
        expect(valuesOf(t).single, want, reason: key.keyLabel);
      }
    });

    testWidgets('the page keys move ten steps', (WidgetTester t) async {
      // Probed on the price slider: `step={5}` and PageUp moved 15 -> 65.
      await pumpFocused(t, step: 5);
      await t.sendKeyEvent(LogicalKeyboardKey.pageUp);
      await t.pump();
      expect(valuesOf(t).single, 100, reason: '50 + 5 x 10');
      await t.sendKeyEvent(LogicalKeyboardKey.pageDown);
      await t.pump();
      expect(valuesOf(t).single, 50);
    });

    testWidgets('home and end go to the ends', (WidgetTester t) async {
      await pumpFocused(t);
      await t.sendKeyEvent(LogicalKeyboardKey.home);
      await t.pump();
      expect(valuesOf(t).single, 0);
      await t.sendKeyEvent(LogicalKeyboardKey.end);
      await t.pump();
      expect(valuesOf(t).single, 100);
    });

    testWidgets('each thumb owns its own focus and its own keys', (
      WidgetTester t,
    ) async {
      // Radix gives every `<span role="slider">` its own `tabindex="0"`, so a
      // range is two tab stops and the arrows move whichever holds focus.
      await t.pumpWidget(host(const _Live(initial: <double>[20, 70])));
      expect(thumbNodes(t), hasLength(2));

      await focusThumb(t, 0);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await t.pump();
      expect(valuesOf(t), <double>[21, 70], reason: 'the first knob took it');

      await focusThumb(t, 1);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await t.pump();
      expect(valuesOf(t), <double>[
        21,
        71,
      ], reason: 'and the second is its own');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Disabled — drift 11: ONE dimming, at the root
  // ───────────────────────────────────────────────────────────────────────────

  group('disabled', () {
    testWidgets('the root dims once and the knob does not dim again', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(slider(values: <double>[40], enabled: false, live: false)),
      );

      // DRIFT 11. `disabled:opacity-50` on the thumb compiles to `:disabled`,
      // which the `<span>` Radix renders can never match. Probed on the
      // disabled matrix cell: root 0.5, thumb 1.
      final List<Opacity> dimmings = t
          .widgetList<Opacity>(
            find.descendant(
              of: find.byType(Slider),
              matching: find.byType(Opacity),
            ),
          )
          .toList();
      expect(
        dimmings,
        hasLength(1),
        reason: 'exactly one Opacity in the whole control',
      );
      expect(dimmings.single.opacity, 0.5);
    });

    testWidgets('a press moves nothing', (WidgetTester t) async {
      // Probed: clicking a disabled slider at 90% left the value at 40, even
      // though `pointer-events` reads `auto` — Radix refuses in JavaScript.
      await t.pumpWidget(
        host(const _Live(initial: <double>[40], enabled: false)),
      );
      await t.tapAt(
        t.getTopLeft(find.byType(Slider)) + const Offset(_panel * 0.9, 5),
      );
      await t.pump();
      expect(valuesOf(t).single, 40);
    });

    testWidgets('and it is not a tab stop', (WidgetTester t) async {
      await t.pumpWidget(
        host(slider(values: <double>[40], enabled: false, live: false)),
      );
      final Focus focus = t.widget<Focus>(
        find.descendant(of: find.byType(Slider), matching: find.byType(Focus)),
      );
      expect(
        focus.canRequestFocus,
        isFalse,
        reason: 'probed `tabindex: null` on the disabled thumb',
      );
    });

    testWidgets('a null onChanged is inoperable too', (WidgetTester t) async {
      await t.pumpWidget(host(slider(values: <double>[40], live: false)));
      expect(t.takeException(), isNull);
      // `enabled` is still true, so nothing dims — only the handler is gone.
      final Opacity dimming = t.widget<Opacity>(
        find.descendant(
          of: find.byType(Slider),
          matching: find.byType(Opacity),
        ),
      );
      expect(dimming.opacity, 1);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // The rest of the contract
  // ───────────────────────────────────────────────────────────────────────────

  group('the hit expander', () {
    testWidgets('answers 34 tall — `-inset-2` off the PADDING box', (
      WidgetTester t,
    ) async {
      // `after:absolute after:-inset-2` resolves against the containing
      // block's padding box, and the knob's 20px border box carries a 1px
      // border, so the pseudo-element grows from 18 × 18 to **34 × 34** —
      // probed as `34px × 34px` on the live reference. Reading the insets off
      // the border box instead would give 36.
      //
      // Read as a rect rather than driven with a tap: every render object
      // above [HitArea] bounds-checks itself first, so a snug parent rejects
      // a pointer in the margin before the expander is consulted. CSS has no
      // such gate. The rect is what the contract actually promises.
      await t.pumpWidget(host(slider(values: <double>[50])));
      final Rect expander = HitArea.debugExpanded(
        t.renderObject(
          find.descendant(
            of: find.byType(Slider),
            matching: find.byType(HitArea),
          ),
        ),
      );

      // The knob is centred on the 10px channel and reaches 17 either way.
      expect(
        expander.height,
        34,
        reason: 'the thumb expander is 34 tall, not 36',
      );
      expect(expander.top, -12);
      expect(expander.bottom, Slider.trackHeight + 12);

      // Horizontally a knob at either end sits half its width in, so the
      // expander clears the root by 17 - 10 = 7.
      expect(expander.left, -7);
      expect(expander.right, _panel + 7);
    });

    testWidgets('the hover region is the expander, not the painted knob', (
      WidgetTester t,
    ) async {
      // A pseudo-element belongs to its element, so hovering it hovers the
      // thumb — which is why `hover:scale-110` fires from 17px out and not
      // from the knob's own 10.
      await t.pumpWidget(host(const _Live(initial: <double>[50])));
      double scaleNow() => t
          .widgetList<Transform>(
            find.descendant(
              of: find.byType(Slider),
              matching: find.byType(Transform),
            ),
          )
          .map((Transform x) => x.transform.getMaxScaleOnAxis())
          .first;

      final Offset centre = thumbCentre(t, 0);
      final TestGesture gesture = await t.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(gesture.removePointer);
      await gesture.addPointer(location: Offset.zero);

      await gesture.moveTo(centre + const Offset(16.9, 0));
      await t.pump();
      expect(
        scaleNow(),
        MotionTransforms.sliderThumbHoverScale,
        reason: 'still inside the 34-wide expander',
      );

      await gesture.moveTo(centre + const Offset(17.1, 0));
      await t.pump();
      expect(scaleNow(), 1, reason: 'and past it the knob is not hovered');
    });
  });

  group('contract', () {
    testWidgets('reduced motion stills the ring', (WidgetTester t) async {
      await t.pumpWidget(
        host(const _Live(initial: <double>[40]), disableAnimations: true),
      );
      await focusThumb(t, 0);
      // Would never return if the ring were still interpolating.
      await t.pumpAndSettle();
      expect(t.hasRunningAnimations, isFalse);
    });

    testWidgets('it does not jelly', (WidgetTester t) async {
      // Alone of the four families it does not import
      // `use-replay-on-state-change` (selection-map §6.3).
      await t.pumpWidget(host(const _Live(initial: <double>[40])));
      expect(
        find.descendant(
          of: find.byType(Slider),
          matching: find.byType(StateChangeFeedback),
        ),
        findsNothing,
      );
    });

    testWidgets('each thumb announces itself as a slider', (
      WidgetTester t,
    ) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(
        host(slider(values: <double>[20, 70], label: 'Price range')),
      );
      expect(
        find.bySemanticsLabel('Price range'),
        findsNWidgets(2),
        reason:
            'Radix puts role="slider" on each thumb, so a range '
            'announces its name on both handles',
      );
      handle.dispose();
    });

    testWidgets('it paints in both themes without error', (
      WidgetTester t,
    ) async {
      for (final ColorMode mode in <ColorMode>[
        ColorMode.light,
        ColorMode.dark,
      ]) {
        await t.pumpWidget(
          host(
            slider(values: <double>[10, 240], min: 0, max: 500, step: 5),
            mode: mode,
          ),
        );
        await t.pump(MotionDurations.normal);
        expect(t.takeException(), isNull, reason: '$mode');
      }
    });
  });
}
