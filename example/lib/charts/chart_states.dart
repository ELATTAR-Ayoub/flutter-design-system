/// The state switch and skeletons, `components/space/charts/state.tsx` and
/// `components/space/charts/skeletons.tsx`.
library;

import 'dart:math' as math;

import 'package:elattar_design_system/elattar_design_system.dart';
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
import 'package:flutter/widgets.dart' as flutter show AspectRatio;

import 'chart_data.dart';
import 'chart_specimen.dart';

/* ── ChartStates, `components/space/charts/state.tsx` ──────────────────────── */

/// One chart, its three states, and the control that moves between them.
///
/// `state.tsx`'s own header carries the four rulings this reproduces:
///
///  * **It renders its own `Panel`.** A family section is a grid of
///    `ChartStates`, never a grid of `Panel`s containing them.
///  * **The buttons are a `ToggleGroup`, and that is a rule not a preference.**
///    §4: a group with an active option owns one pill that travels.
///  * **The swap is one event.** `anim-content-change` on the arriving content and
///    nothing on the leaving content, replayed by a changed key: which is also
///    what remounts the chart so its own entrance replays at the same moment.
///  * **`controls` is a component TYPE, not a node.** A control strip owns
///    state the chart underneath reads, so it has to sit ABOVE the keyed slot
///    to survive the swap. Rendered inside `children` it would exist only in
///    `ready`, and the panel would then GROW by the strip's height the moment
///    you left `loading`: measured 393.39 → 453.39 on `AreaInteractive` and
///    393.39 → 487.78 on `BarInteractive`, which is §5's *"a layout jump is
///    worse than the spinner it avoided"*.
class ChartStateSwitch extends StatefulWidget {
  const ChartStateSwitch({
    super.key,
    required this.skeleton,
    this.controls,
    required this.child,
  });

  final ChartSkeletonKind skeleton;

  /// The specimen's own control strip, as a wrapper around the state slot.
  final Widget Function(BuildContext context, Widget child)? controls;

  final Widget child;

  @override
  State<ChartStateSwitch> createState() => _ChartStateSwitchState();
}

/// The three states, in the order the strip lists them.
enum _ChartState { empty, loading, ready }

class _ChartStateSwitchState extends State<ChartStateSwitch> {
  /// Opens on `ready`: which is drift 12: nothing on the page is ever seen
  /// loading unless a reader presses for it.
  _ChartState _state = _ChartState.ready;

  @override
  Widget build(BuildContext context) {
    final Widget slot = ContentChange(
      replayKey: ValueKey<_ChartState>(_state),
      child: switch (_state) {
        _ChartState.loading => _ChartSkeleton(kind: widget.skeleton),
        _ChartState.empty => _ChartEmpty(
          onLoad: () => setState(() => _state = _ChartState.ready),
        ),
        _ChartState.ready => widget.child,
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: ToggleGroup(
            size: ToggleSize.sm,
            items: const <ToggleGroupItem>[
              ToggleGroupItem(label: 'Empty'),
              ToggleGroupItem(label: 'Loading'),
              ToggleGroupItem(label: 'Ready'),
            ],
            selectedIndex: _state.index,
            // Radix clears the value when the active item is pressed again.
            // A chart has to be in one of the three, so a null is ignored.
            onChanged: (int? next) {
              if (next == null) return;
              setState(() => _state = _ChartState.values[next]);
            },
          ),
        ),
        // The 20px below the toggle group belonged to the panel; the panel
        // now sits outside this widget, so the slot keeps that same gap
        // above it and the call site's Panel keeps its own padding clean.
        SizedBox(height: space(5)),
        if (widget.controls != null) widget.controls!(context, slot) else slot,
      ],
    );
  }
}

/// `Empty` at `PLOT` with a dashed border, and a way forward.
///
/// §5's table: *"`Empty` is for 'nothing is there yet', **and it always offers a
/// way forward**. The button loads the series and returns to `ready`, which is
/// the same journey a real retry would make."*
class _ChartEmpty extends StatelessWidget {
  const _ChartEmpty({required this.onLoad});

  final VoidCallback onLoad;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return SizedBox(
      height: plotHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(color: theme.border, width: BorderWidths.hairline),
        ),
        child: Center(
          child: Empty(
            children: <Widget>[
              EmptyHeader(
                children: <Widget>[
                  const _ChartEmptyMedia(),
                  const EmptyTitle('No data in this range'),
                  const EmptyDescription(
                    'Nothing came back for the period selected. Load the '
                    'sample series to see the shape this chart draws.',
                  ),
                ],
              ),
              EmptyContent(
                children: <Widget>[
                  Button(
                    size: ButtonSize.sm,
                    onPressed: onLoad,
                    child: const Text('Load sample data'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// `EmptyMedia variant="icon"` carrying `ChartLineIcon`.
///
/// **A page-local copy of `EmptyMedia`, and the reason is narrow.** That
/// widget takes a [IconGlyph]: the curated set: and `chart-line` is not in
/// it; it lives only in the generated lucide registry. Widening `empty.dart`
/// would be a change to the feedback family's file, so the tile is rebuilt here
/// out of `EmptyMedia`'s own public geometry: nothing below restates a
/// number, and if that widget retunes, this follows.
class _ChartEmptyMedia extends StatelessWidget {
  const _ChartEmptyMedia();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: EmptyMedia.marginBottom),
      child: Container(
        width: EmptyMedia.box,
        height: EmptyMedia.box,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.muted,
          borderRadius: BorderRadius.circular(EmptyMedia.radius),
        ),
        child: Icon.lucide(
          Lucide.chartLine,
          sizePx: EmptyMedia.glyphSize,
          strokeOverride: EmptyMedia.glyphStroke,
          tone: IconTone.inherit,
        ),
      ),
    );
  }
}

/* ── Skeletons, `components/space/charts/skeletons.tsx` ────────────────────── */

/// One skeleton per chart family, each shaped like the family it stands in for.
///
/// `skeletons.tsx` states the two requirements and their order: *"The footprint
/// is the requirement, not the drawing"*: every skeleton renders at `PLOT`, so
/// the box cannot move when the state changes: and the shape is the smaller,
/// second one, because *"a grey rectangle would satisfy the footprint and tell
/// the reader nothing about what is arriving"*.
///
/// The reference draws each shape as a `Skeleton` div under a `clip-path`,
/// because `anim-shimmer` is a background gradient and *"a background does not
/// paint inside an SVG `<path>`, so a skeleton drawn as SVG geometry would be a
/// still silhouette with the shimmer running behind it: the one thing on the
/// page that looks loaded while it is loading."* Flutter has no such split: a
/// [Skeleton] inside a [ClipPath] shimmers inside the curve, which is what
/// the `clip-path` was for.
class _ChartSkeleton extends StatelessWidget {
  const _ChartSkeleton({required this.kind});

  final ChartSkeletonKind kind;

  /// The one imaginary series, as **percent down from the top of the plot**.
  /// Six points, because every recurring dataset in `data.ts` has six.
  static const List<double> _series = <double>[64, 38, 50, 22, 44, 16];

  @override
  Widget build(BuildContext context) => SizedBox(
    height: plotHeight,
    child: switch (kind) {
      ChartSkeletonKind.area => const _CartesianSkeleton(shape: _Shape.area),
      ChartSkeletonKind.bar => const _CartesianSkeleton(shape: _Shape.bar),
      ChartSkeletonKind.line => const _CartesianSkeleton(shape: _Shape.line),
      ChartSkeletonKind.pie => const _PolarSkeleton(shape: _Shape.pie),
      ChartSkeletonKind.radar => const _PolarSkeleton(shape: _Shape.radar),
      ChartSkeletonKind.radial => const _PolarSkeleton(shape: _Shape.radial),
      ChartSkeletonKind.tooltip => const _TooltipSkeleton(),
    },
  );
}

enum _Shape { area, bar, line, pie, radar, radial }

/// The cartesian frame: plot area, axis rule, tick labels.
class _CartesianSkeleton extends StatelessWidget {
  const _CartesianSkeleton({required this.shape});

  final _Shape shape;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final int ticks = shape == _Shape.bar ? 5 : _ChartSkeleton._series.length;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: space(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: _Plot(shape: shape)),
          SizedBox(height: space(2)),
          SizedBox(
            height: BorderWidths.hairline,
            child: ColoredBox(color: theme.border),
          ),
          SizedBox(height: space(2)),
          Row(
            children: <Widget>[
              for (int i = 0; i < ticks; i++) ...<Widget>[
                if (i > 0) SizedBox(width: space(4)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: space(8)),
                      child: Skeleton(height: space(2)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// The shimmer, clipped to the family's own silhouette.
class _Plot extends StatelessWidget {
  const _Plot({required this.shape});

  final _Shape shape;

  @override
  Widget build(BuildContext context) {
    if (shape == _Shape.bar) {
      final List<double> bars = _ChartSkeleton._series.take(5).toList();
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints c) => Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            for (int i = 0; i < bars.length; i++) ...<Widget>[
              if (i > 0) SizedBox(width: space(4)),
              Expanded(
                child: Skeleton(
                  height: c.maxHeight * (100 - bars[i]) / 100,
                  radius: Radii.sm,
                ),
              ),
            ],
          ],
        ),
      );
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) => Stack(
        children: <Widget>[
          Positioned.fill(
            child: ClipPath(
              clipper: _SeriesClipper(
                series: _ChartSkeleton._series,
                stroke: shape == _Shape.line,
              ),
              child: const Skeleton(radius: 0),
            ),
          ),
          if (shape == _Shape.line)
            for (int i = 0; i < _ChartSkeleton._series.length; i++)
              Positioned(
                left:
                    c.maxWidth * i / (_ChartSkeleton._series.length - 1) -
                    space(1),
                top: c.maxHeight * _ChartSkeleton._series[i] / 100 - space(1),
                child: Skeleton(
                  width: space(2),
                  height: space(2),
                  radius: Radii.full,
                ),
              ),
        ],
      ),
    );
  }
}

/// `band()` and `stroke()` from `skeletons.tsx`, as a clipper.
class _SeriesClipper extends CustomClipper<Path> {
  const _SeriesClipper({required this.series, required this.stroke});

  final List<double> series;
  final bool stroke;

  /// The line skeleton's half-thickness, as a percentage of the plot.
  static const double _half = 2;

  @override
  Path getClip(Size size) {
    double x(int i) => size.width * i / (series.length - 1);
    double y(double pct) => size.height * pct / 100;
    final Path path = Path();
    if (stroke) {
      path.moveTo(x(0), y(series.first - _half));
      for (int i = 1; i < series.length; i++) {
        path.lineTo(x(i), y(series[i] - _half));
      }
      for (int i = series.length - 1; i >= 0; i--) {
        path.lineTo(x(i), y(series[i] + _half));
      }
    } else {
      path.moveTo(x(0), y(series.first));
      for (int i = 1; i < series.length; i++) {
        path.lineTo(x(i), y(series[i]));
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_SeriesClipper old) =>
      old.series != series || old.stroke != stroke;
}

/// The polar frame: one centred square, as tall as the plot allows.
class _PolarSkeleton extends StatelessWidget {
  const _PolarSkeleton({required this.shape});

  final _Shape shape;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: space(2)),
    child: Center(
      child: flutter.AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: <Widget>[
            for (final _Annulus a in _rings)
              Positioned.fill(
                child: Opacity(
                  opacity: a.opacity,
                  child: ClipPath(
                    clipper: _AnnulusClipper(a),
                    child: const Skeleton(radius: 0),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );

  /// The three polar silhouettes, in `skeletons.tsx`'s own numbers.
  List<_Annulus> get _rings => switch (shape) {
    _Shape.pie => const <_Annulus>[
      _Annulus(sweep: 360, steps: 48, outer: 46, inner: 27),
    ],
    _Shape.radar => const <_Annulus>[
      _Annulus(sweep: 360, steps: 6, outer: 46, inner: 44, opacity: 0.5),
      _Annulus(sweep: 360, steps: 6, outer: 34, inner: 30),
    ],
    _ => const <_Annulus>[
      _Annulus(sweep: 250, steps: 32, outer: 46, inner: 37),
      _Annulus(sweep: 190, steps: 32, outer: 34, inner: 25),
      _Annulus(sweep: 120, steps: 32, outer: 22, inner: 13),
    ],
  };
}

/// A ring, or a slice of one, as a single closed polygon.
///
/// `skeletons.tsx` cuts the hole *"the way SVG cuts one without a second
/// subpath: walk the outer edge forward, walk the inner edge back, and let the
/// two coincident radial segments cancel"*, because `clip-path: polygon()` has
/// no arc primitive. Flutter's [Path] does, but the polygon is kept: `steps` is
/// the smoothness, and 6 is what draws the radar's hexagon rather than a circle.
@immutable
class _Annulus {
  const _Annulus({
    required this.sweep,
    required this.steps,
    required this.outer,
    required this.inner,
    this.opacity = 1,
  });

  final double sweep;
  final int steps;
  final double outer;
  final double inner;
  final double opacity;

  /// Polar charts start at twelve o'clock, so every sweep does too.
  static const double top = -90;
}

class _AnnulusClipper extends CustomClipper<Path> {
  const _AnnulusClipper(this.spec);

  final _Annulus spec;

  @override
  Path getClip(Size size) {
    Offset at(double deg, double r) {
      final double rad = deg * math.pi / 180;
      return Offset(
        size.width * (50 + r * math.cos(rad)) / 100,
        size.height * (50 + r * math.sin(rad)) / 100,
      );
    }

    final Path path = Path();
    for (int i = 0; i <= spec.steps; i++) {
      final Offset p = at(
        _Annulus.top + spec.sweep * i / spec.steps,
        spec.outer,
      );
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    for (int i = spec.steps; i >= 0; i--) {
      final Offset p = at(
        _Annulus.top + spec.sweep * i / spec.steps,
        spec.inner,
      );
      path.lineTo(p.dx, p.dy);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_AnnulusClipper old) => old.spec != spec;
}

/// A bar plot plus a floating tooltip block.
///
/// *"The block mirrors `ChartTooltipContent`'s own frame, `min-w-32`, a `lg`
/// radius, a half-strength border on `bg-background`: so what arrives lands in
/// the same outline the placeholder drew."*
class _TooltipSkeleton extends StatelessWidget {
  const _TooltipSkeleton();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) => Stack(
        children: <Widget>[
          const Positioned.fill(child: _CartesianSkeleton(shape: _Shape.bar)),
          Positioned(
            left: c.maxWidth / 2 - ChartTooltipContent.minWidth / 2,
            top: c.maxHeight * 14 / 100,
            child: Container(
              width: ChartTooltipContent.minWidth,
              padding: EdgeInsets.all(space(2.5)),
              decoration: BoxDecoration(
                color: theme.background,
                borderRadius: BorderRadius.circular(Radii.lg),
                border: Border.all(
                  color: theme.border.withValues(alpha: 0.5),
                  width: BorderWidths.hairline,
                ),
                boxShadow: Shadows.md.outerShadows(theme),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.6,
                    child: Skeleton(height: space(2)),
                  ),
                  for (int i = 0; i < 2; i++) ...<Widget>[
                    SizedBox(height: space(2)),
                    Row(
                      children: <Widget>[
                        Skeleton(
                          width: space(2),
                          height: space(2),
                          radius: Radii.xs,
                        ),
                        SizedBox(width: space(1.5)),
                        Expanded(child: Skeleton(height: space(2))),
                        SizedBox(width: space(1.5)),
                        Skeleton(width: space(4), height: space(2)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
