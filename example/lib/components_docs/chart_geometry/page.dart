/// Public documentation page for the `chart_geometry` component.
///
/// **A page about functions, not a widget.** `chart_geometry.dart` declares
/// no `Widget` at all — no `StatelessWidget`, no `StatefulWidget`, not even
/// a `CustomPainter`. It is eleven pure functions plus three small
/// `@immutable` scale classes and one enum, imported by `chart-cartesian`
/// and `chart-polar` and by nothing else. So "Preview" here cannot stage a
/// live component the way `button`'s does; instead every `ShowcaseSection`
/// below draws, with a `CustomPaint`, exactly what the named function
/// returns — an axis, a scale, a path, a sector — and prints the function's
/// own return value underneath as a live caption, computed at build time,
/// not transcribed.
///
/// **Section order.** Preview, Installation, Usage, then one section per
/// facet: Ticks & scales (`elChartNiceTicks`, `elChartNiceDomain`,
/// `ElLinearScale`), Band & point (`ElBandScale`, `ElPointScale`), Bar
/// layout (`elBarSlots`, `elBarRRect`), Curves (`ElCurveType`,
/// `elCurvePath`, `elAreaPath`), Polar (`elPolarToCartesian`,
/// `elPolarMaxRadius`, `elSectorPath`, `elSectorWithCornerPath`,
/// `elPolarPolygonPath`) — then the eight standing disclosures.
///
/// **Read, not inferred.** `chart_geometry.dart` imports only `dart:math`
/// and `dart:ui` — no `package:flutter/widgets.dart`, no theme, no colour.
/// Every colour drawn below comes from this *documentation page* reading
/// `ElTheme.of(context)`, never from the library itself, and Dependencies
/// says so plainly.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import '../chart_cartesian/meta.dart' as chart_cartesian;
import '../chart_polar/meta.dart' as chart_polar;
import 'meta.dart';

/// The declaration: every section this page shows, in TOC order. `final`,
/// not `const`: `InstallSection.command` reads `chartGeometryDoc.command`, a
/// computed getter, not a constant expression.
final ComponentDocSpec chartGeometryDocSpec = ComponentDocSpec(
  name: 'chart-geometry',
  title: 'Chart Geometry',
  description: chartGeometryDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'What the three most load-bearing functions in the file produce, '
          'drawn together: a value axis (elChartNiceTicks through an '
          'ElLinearScale), six category positions (ElBandScale), and a path '
          "(elCurvePath). Nothing here is a widget — it is these functions' "
          'own return values, painted.',
      specimen: const _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'chart-geometry has a real registry manifest, `elattar add '
          'chart-geometry` installs lib/src/components/chart_geometry.dart. '
          'Its registryDependencies list is empty — this is the leaf of the '
          'chart family\'s dependency graph, and every other chart item '
          'depends on it. The Manual tab is for a project not using the '
          'CLI.',
      command: chartGeometryDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/chart_geometry.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/chart_geometry.dart's generated "
              '@ui/chart_geometry.dart payload into components/ui.',
          code:
              "// Copy the generated chart_geometry source here when using "
              'manual mode.\n// It imports only dart:math and dart:ui — no '
              'Flutter package of its own.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so elChartNiceTicks, ElLinearScale, and '
              'the rest are reachable the same way the CLI path already '
              'makes them.',
          code: "export 'chart_geometry.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct call: nice a domain, build the scale it '
          'implies, and read a pixel position off it. Every value axis on '
          'chart-cartesian is this same sequence.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'ticks-scales',
      title: 'Ticks & scales',
      description:
          'elChartNiceTicks rounds a data extent outward to round numbers; '
          'elChartNiceDomain is the side effect that matters most — the '
          'niced ticks\' own extremes become the axis domain, not the raw '
          'data. ElLinearScale.nice runs both and maps the niced interval '
          'onto a pixel range.',
      specimen: const _TicksScalesSpecimen(),
      code: _ticksScalesCode,
      label: 'Ticks and scales specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'band-point',
      title: 'Band & point',
      description:
          'The same six categories read two ways. ElBandScale divides the '
          'extent into six equal bands and centres each — what a Bar '
          'divides up and what a category axis tick centres on. '
          'ElPointScale instead puts the first and last point ON the plot '
          'edges, which is what a Line or Area vertex sits on.',
      specimen: const _BandPointSpecimen(),
      code: _bandPointCode,
      label: 'Band and point specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'bar-layout',
      title: 'Bar layout',
      description:
          'elBarSlots divides one band among however many bars share it — '
          'a 10% category gap on each side, a 4px gap between bars, and a '
          'JS-style int-truncated width, which is why a band ends up with '
          'an asymmetric gap rather than a symmetric one. elBarRRect turns '
          'the resulting rectangle and a per-corner radius list into the '
          'RRect a bar actually paints.',
      specimen: const _BarLayoutSpecimen(),
      code: _barLayoutCode,
      label: 'Bar layout specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'curves',
      title: 'Curves',
      description:
          'The four ElCurveType interpolators, through the same five '
          'points: linear (straight segments), step (a flat run then a '
          'jump, split at the segment midpoint), natural (a cubic spline '
          'solving the same tridiagonal system d3-shape does), and '
          'monotone (Steffen 1990 tangents — the one guaranteed not to '
          'overshoot a local peak).',
      specimen: const _CurvesSpecimen(),
      code: _curvesCode,
      label: 'Curves specimen view',
      minHeight: el(160),
    ),
    ShowcaseSection(
      id: 'polar',
      title: 'Polar',
      description:
          'elPolarToCartesian places six points at equal angles around a '
          'circle — the one function every polar chart on the page reads '
          'through, degrees counter-clockwise from three o\'clock, negated '
          'going in because screen space grows downward. Beside it, a plain '
          'elSectorPath wedge, a rounded-corner elSectorWithCornerPath '
          'wedge, and the elPolarPolygonPath outline a Radar series draws '
          'through the same six points.',
      specimen: const _PolarSpecimen(),
      code: _polarCode,
      label: 'Polar specimen view',
      minHeight: el(160),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter each exported class declares, every '
          'ElCurveType value, and every exported top-level function, one '
          'row per function rather than one table per class, since a free '
          'function has no fields of its own.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElBandScale', anchor: 'api-elbandscale'),
        DocsTocEntry(title: 'ElPointScale', anchor: 'api-elpointscale'),
        DocsTocEntry(title: 'ElLinearScale', anchor: 'api-ellinearscale'),
        DocsTocEntry(title: 'ElBarSlot', anchor: 'api-elbarslot'),
        DocsTocEntry(title: 'ElCurveType', anchor: 'api-elcurvetype'),
        DocsTocEntry(title: 'Functions', anchor: 'api-functions'),
      ],
      child: const _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'N/A, honestly: every function here is pure — same input, same '
          'output, no field it mutates — and ElBandScale, ElPointScale and '
          'ElLinearScale are all @immutable value classes. There is no '
          'state for a matrix to describe.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description:
          'N/A. chart_geometry.dart declares no Widget of any kind, so '
          'there is no Semantics node, no accessible name, and nothing for '
          'a screen reader to reach — there is no tree here for one to '
          'walk.',
      child: const _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'N/A, for the same reason: no Widget means no FocusNode and no '
          'key handling anywhere in this file.',
      child: const _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: const _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: const _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: const _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: chartGeometryDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/chart_geometry_test.dart',
            description:
                'Covers this page: the article mounts, every exported '
                'function and class this page claims to document, the full '
                'API table, and both themes at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/chart_geometry/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class ChartGeometryDocPage extends StatelessWidget {
  const ChartGeometryDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: chartGeometryDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: chartGeometryDoc.title,
      description: chartGeometryDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Chart Geometry'),
    ],
    toc: chartGeometryDocSpec.toc,
    previous: DocsPageLink(
      title: chart_cartesian.chartCartesianDoc.title,
      route: chart_cartesian.chartCartesianDoc.route,
    ),
    next: DocsPageLink(
      title: chart_polar.chartPolarDoc.title,
      route: chart_polar.chartPolarDoc.route,
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('chart-geometry-doc-article'),
      child: ComponentDocPage(spec: chartGeometryDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return SizedBox(
      width: el(96),
      height: el(48),
      child: CustomPaint(painter: _PreviewPainter(theme: theme)),
    );
  }
}

class _PreviewPainter extends CustomPainter {
  const _PreviewPainter({required this.theme});

  final ElThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    final List<double> ticks = elChartNiceTicks(0, 300, tickCount: 4);
    final ElLinearScale value = ElLinearScale.nice(
      dataMin: 0,
      dataMax: 300,
      rangeStart: size.height,
      rangeEnd: 0,
    );
    final Paint grid = Paint()
      ..color = theme.border.withValues(alpha: 0.5)
      ..strokeWidth = ElWidths.hairline;
    for (final double t in ticks) {
      final double y = value.scale(t);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    const int n = 6;
    final ElBandScale band = ElBandScale(count: n, start: 0, extent: size.width);
    const List<double> desktop = <double>[186, 305, 237, 73, 209, 214];
    final Paint dot = Paint()..color = theme.chart2;
    for (int i = 0; i < n; i++) {
      canvas.drawCircle(
        Offset(band.center(i), size.height),
        ElWidths.hairline * 2,
        dot,
      );
    }

    final List<Offset> points = <Offset>[
      for (int i = 0; i < n; i++) Offset(band.center(i), value.scale(desktop[i])),
    ];
    final Path curve = elCurvePath(points, ElCurveType.monotone);
    canvas.drawPath(
      curve,
      Paint()
        ..color = theme.chart1
        ..strokeWidth = ElWidths.hairline * 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _PreviewPainter old) => old.theme != theme;
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'final ticks = elChartNiceTicks(0, 300, tickCount: 4); // [0, 100, 200, 300]\n'
    'final value = ElLinearScale.nice(\n'
    '  dataMin: 0, dataMax: 300, rangeStart: height, rangeEnd: 0,\n'
    ');\n'
    'final band = ElBandScale(count: 6, start: 0, extent: width);\n'
    'final points = [for (var i = 0; i < 6; i++) Offset(band.center(i), value.scale(desktop[i]))];\n'
    'final path = elCurvePath(points, ElCurveType.monotone);';

/// The smallest correct call: nice a domain, build the scale it implies, and
/// read a pixel position off it — the same sequence every value axis on
/// chart-cartesian runs.
const String _usageCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'final ElLinearScale scale = ElLinearScale.nice(\n'
    '  dataMin: 0,\n'
    '  dataMax: 300,\n'
    '  rangeStart: 226, // the bottom of the plot\n'
    '  rangeEnd: 0, // the top of the plot\n'
    ');\n\n'
    'final double y = scale.scale(214); // a pixel position';

class _TicksScalesSpecimen extends StatelessWidget {
  const _TicksScalesSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final List<double> ticks = elChartNiceTicks(4, 286, tickCount: 5);
    final ({double min, double max}) domain = elChartNiceDomain(
      4,
      286,
      tickCount: 5,
    );
    final double width = el(80);
    final double height = el(40);
    final ElLinearScale scale = ElLinearScale(
      domainMin: domain.min,
      domainMax: domain.max,
      rangeStart: height,
      rangeEnd: 0,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: width,
          height: height,
          child: CustomPaint(
            painter: _TicksPainter(theme: theme, ticks: ticks, scale: scale),
          ),
        ),
        SizedBox(height: el(2)),
        ElText(
          'elChartNiceTicks(4, 286, tickCount: 5) → '
          '[${ticks.map((double v) => v.toStringAsFixed(0)).join(', ')}]\n'
          'domain: [${domain.min.toStringAsFixed(0)}, '
          '${domain.max.toStringAsFixed(0)}]',
          ElType.code,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

class _TicksPainter extends CustomPainter {
  const _TicksPainter({
    required this.theme,
    required this.ticks,
    required this.scale,
  });

  final ElThemeData theme;
  final List<double> ticks;
  final ElLinearScale scale;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint grid = Paint()
      ..color = theme.border.withValues(alpha: 0.5)
      ..strokeWidth = ElWidths.hairline;
    for (final double t in ticks) {
      final double y = scale.scale(t);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      Paint()
        ..color = theme.border
        ..strokeWidth = ElWidths.hairline,
    );
  }

  @override
  bool shouldRepaint(covariant _TicksPainter old) =>
      old.ticks != ticks || old.theme != theme;
}

const String _ticksScalesCode =
    'final ticks = elChartNiceTicks(4, 286, tickCount: 5); // [0, 100, 200, 300]\n'
    'final domain = elChartNiceDomain(4, 286, tickCount: 5); // (min: 0, max: 300)\n'
    'final scale = ElLinearScale(\n'
    '  domainMin: domain.min, domainMax: domain.max,\n'
    '  rangeStart: height, rangeEnd: 0,\n'
    ');\n'
    'final y = scale.scale(214); // a pixel position';

class _BandPointSpecimen extends StatelessWidget {
  const _BandPointSpecimen();

  static const int _n = 6;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final double width = el(80);
    final ElBandScale band = ElBandScale(count: _n, start: 0, extent: width);
    final ElPointScale point = ElPointScale(count: _n, start: 0, extent: width);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: width,
          height: el(16),
          child: CustomPaint(
            painter: _BandPointPainter(theme: theme, band: band, point: point, n: _n),
          ),
        ),
        SizedBox(height: el(2)),
        ElText(
          'band.center(i): [${List<double>.generate(_n, band.center).map((double v) => v.toStringAsFixed(1)).join(', ')}]\n'
          'point.at(i): [${List<double>.generate(_n, point.at).map((double v) => v.toStringAsFixed(1)).join(', ')}]',
          ElType.code,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

class _BandPointPainter extends CustomPainter {
  const _BandPointPainter({
    required this.theme,
    required this.band,
    required this.point,
    required this.n,
  });

  final ElThemeData theme;
  final ElBandScale band;
  final ElPointScale point;
  final int n;

  @override
  void paint(Canvas canvas, Size size) {
    final double bandY = size.height * 0.25;
    final double pointY = size.height * 0.75;
    final Paint bandDot = Paint()..color = theme.chart1;
    final Paint pointDot = Paint()..color = theme.chart2;
    for (int i = 0; i < n; i++) {
      canvas.drawCircle(Offset(band.center(i), bandY), ElWidths.hairline * 2, bandDot);
      canvas.drawCircle(Offset(point.at(i), pointY), ElWidths.hairline * 2, pointDot);
    }
  }

  @override
  bool shouldRepaint(covariant _BandPointPainter old) =>
      old.theme != theme || old.band != band || old.point != point;
}

const String _bandPointCode =
    'final band = ElBandScale(count: 6, start: 0, extent: width);\n'
    'final point = ElPointScale(count: 6, start: 0, extent: width);\n'
    '// band.center(0) sits half a band in from the edge\n'
    '// point.at(0) sits ON the edge, point.at(5) on the other';

class _BarLayoutSpecimen extends StatelessWidget {
  const _BarLayoutSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final double bandSize = el(24);
    final List<ElBarSlot> slots = elBarSlots(bandSize: bandSize, barCount: 2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: bandSize,
          height: el(24),
          child: CustomPaint(
            painter: _BarLayoutPainter(theme: theme, slots: slots, bandHeight: el(24)),
          ),
        ),
        SizedBox(height: el(2)),
        ElText(
          'elBarSlots(bandSize: ${bandSize.toStringAsFixed(0)}, barCount: 2) → '
          '[${slots.map((ElBarSlot s) => '(offset: ${s.offset.toStringAsFixed(1)}, size: ${s.size.toStringAsFixed(1)})').join(', ')}]',
          ElType.code,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

class _BarLayoutPainter extends CustomPainter {
  const _BarLayoutPainter({
    required this.theme,
    required this.slots,
    required this.bandHeight,
  });

  final ElThemeData theme;
  final List<ElBarSlot> slots;
  final double bandHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final List<Color> colors = <Color>[theme.chart1, theme.chart2];
    for (int i = 0; i < slots.length; i++) {
      final ElBarSlot slot = slots[i];
      final Rect rect = Rect.fromLTWH(slot.offset, 0, slot.size, bandHeight);
      canvas.drawRRect(
        elBarRRect(rect, const <double>[ElRadii.sm, ElRadii.sm, 0, 0]),
        Paint()..color = colors[i % colors.length],
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarLayoutPainter old) =>
      old.slots != slots || old.theme != theme;
}

const String _barLayoutCode =
    'final slots = elBarSlots(bandSize: 96, barCount: 2);\n'
    '// [(offset: 9.6, size: 39), (offset: 52.6, size: 39)]\n'
    'final rect = Rect.fromLTWH(slots[0].offset, 0, slots[0].size, height);\n'
    'canvas.drawRRect(elBarRRect(rect, [radius, radius, 0, 0]), paint);';

class _CurvesSpecimen extends StatelessWidget {
  const _CurvesSpecimen();

  static const List<double> _values = <double>[80, 220, 40, 260, 120];

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final double width = el(80);
    final double height = el(40);
    final List<Offset> points = <Offset>[
      for (int i = 0; i < _values.length; i++)
        Offset(
          width * i / (_values.length - 1),
          height - height * _values[i] / 300,
        ),
    ];
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _CurvesPainter(theme: theme, points: points),
      ),
    );
  }
}

class _CurvesPainter extends CustomPainter {
  const _CurvesPainter({required this.theme, required this.points});

  final ElThemeData theme;
  final List<Offset> points;

  @override
  void paint(Canvas canvas, Size size) {
    const List<ElCurveType> types = <ElCurveType>[
      ElCurveType.linear,
      ElCurveType.step,
      ElCurveType.natural,
      ElCurveType.monotone,
    ];
    final List<Color> colors = <Color>[
      theme.chart1,
      theme.chart2,
      theme.chart3,
      theme.chart4,
    ];
    for (int i = 0; i < types.length; i++) {
      final Path path = elCurvePath(points, types[i]);
      canvas.drawPath(
        path,
        Paint()
          ..color = colors[i]
          ..strokeWidth = ElWidths.hairline * 1.5
          ..style = PaintingStyle.stroke,
      );
    }
    for (final Offset p in points) {
      canvas.drawCircle(p, ElWidths.hairline * 1.5, Paint()..color = theme.foreground);
    }
  }

  @override
  bool shouldRepaint(covariant _CurvesPainter old) =>
      old.points != points || old.theme != theme;
}

const String _curvesCode =
    'final points = [Offset(0, 60), Offset(20, 10), Offset(40, 70), Offset(60, 5), Offset(80, 45)];\n\n'
    'elCurvePath(points, ElCurveType.linear);   // straight segments\n'
    'elCurvePath(points, ElCurveType.step);     // flat run, then a jump\n'
    'elCurvePath(points, ElCurveType.natural);  // cubic spline\n'
    'elCurvePath(points, ElCurveType.monotone); // Steffen tangents, no overshoot';

class _PolarSpecimen extends StatelessWidget {
  const _PolarSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return SizedBox(
      width: el(64),
      height: el(64),
      child: CustomPaint(painter: _PolarPainter(theme: theme)),
    );
  }
}

class _PolarPainter extends CustomPainter {
  const _PolarPainter({required this.theme});

  final ElThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset centre = Offset(size.width / 2, size.height / 2);
    final double radius = elPolarMaxRadius(size.width, size.height);

    // Six points at equal angles, elRadarChart's own spacing (360 / 6 = 60°
    // apart), drawn as the polygon a Radar series traces.
    const int n = 6;
    final List<Offset> ring = <Offset>[
      for (int i = 0; i < n; i++)
        elPolarToCartesian(centre.dx, centre.dy, radius, i * 360 / n),
    ];
    canvas.drawPath(
      elPolarPolygonPath(ring),
      Paint()
        ..color = theme.chart1
        ..strokeWidth = ElWidths.hairline
        ..style = PaintingStyle.stroke,
    );
    for (final Offset p in ring) {
      canvas.drawCircle(p, ElWidths.hairline * 1.5, Paint()..color = theme.chart1);
    }

    // A plain wedge, elSectorPath.
    canvas.drawPath(
      elSectorPath(
        cx: centre.dx,
        cy: centre.dy,
        innerRadius: 0,
        outerRadius: radius * 0.55,
        startAngle: 90,
        endAngle: 150,
      ),
      Paint()..color = theme.chart2,
    );

    // A rounded-corner wedge, elSectorWithCornerPath.
    canvas.drawPath(
      elSectorWithCornerPath(
        cx: centre.dx,
        cy: centre.dy,
        innerRadius: radius * 0.62,
        outerRadius: radius * 0.9,
        startAngle: 200,
        endAngle: 320,
        cornerRadius: ElRadii.sm,
      ),
      Paint()..color = theme.chart4,
    );
  }

  @override
  bool shouldRepaint(covariant _PolarPainter old) => old.theme != theme;
}

const String _polarCode =
    'final centre = Offset(size.width / 2, size.height / 2);\n'
    'final radius = elPolarMaxRadius(size.width, size.height);\n\n'
    'final ring = [for (var i = 0; i < 6; i++) elPolarToCartesian(centre.dx, centre.dy, radius, i * 60)];\n'
    'canvas.drawPath(elPolarPolygonPath(ring), paint); // a Radar outline\n\n'
    'canvas.drawPath(elSectorPath(cx: centre.dx, cy: centre.dy, innerRadius: 0,\n'
    '  outerRadius: radius, startAngle: 90, endAngle: 150), paint); // a Pie wedge\n\n'
    'canvas.drawPath(elSectorWithCornerPath(cx: centre.dx, cy: centre.dy,\n'
    '  innerRadius: r0, outerRadius: r1, startAngle: 200, endAngle: 320,\n'
    '  cornerRadius: 6), paint); // a rounded RadialBar segment';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elbandscale',
        child: DocsApiTable(title: 'ElBandScale', facts: _bandScaleFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elpointscale',
        child: DocsApiTable(title: 'ElPointScale', facts: _pointScaleFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-ellinearscale',
        child: DocsApiTable(title: 'ElLinearScale', facts: _linearScaleFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elbarslot',
        child: DocsApiTable(title: 'ElBarSlot', facts: _barSlotFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elcurvetype',
        child: DocsApiTable(title: 'ElCurveType', facts: _curveTypeFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-functions',
        child: DocsApiTable(title: 'Functions', facts: _functionFacts),
      ),
    ],
  );
}

const List<DocsApiFact> _bandScaleFacts = <DocsApiFact>[
  DocsApiFact(name: 'count', type: 'int', description: 'Required. How many bands divide extent.'),
  DocsApiFact(name: 'start', type: 'double', description: 'Required. The plot edge the first band starts at.'),
  DocsApiFact(name: 'extent', type: 'double', description: 'Required. The full run the bands divide.'),
  DocsApiFact(
    name: 'reversed',
    type: 'bool',
    description: 'Categories run the other way — a layout: vertical chart\'s Y axis. Default false.',
  ),
  DocsApiFact(name: 'bandwidth', type: 'double (getter)', description: 'extent / count.'),
  DocsApiFact(name: 'bandStart', type: "double Function(int)", description: "A band's leading edge."),
  DocsApiFact(
    name: 'center',
    type: 'double Function(int)',
    description: "A band's centre — where a tick label and a Line/Area vertex sit when bars share the plot.",
  ),
];

const List<DocsApiFact> _pointScaleFacts = <DocsApiFact>[
  DocsApiFact(name: 'count', type: 'int', description: 'Required.'),
  DocsApiFact(name: 'start', type: 'double', description: 'Required.'),
  DocsApiFact(name: 'extent', type: 'double', description: 'Required.'),
  DocsApiFact(name: 'step', type: 'double (getter)', description: 'extent / (count - 1).'),
  DocsApiFact(
    name: 'at',
    type: 'double Function(int)',
    description: 'The first and last point land ON start and start + extent; a band reading would tuck them in half a band instead.',
  ),
];

const List<DocsApiFact> _linearScaleFacts = <DocsApiFact>[
  DocsApiFact(name: 'domainMin', type: 'double', description: 'Required.'),
  DocsApiFact(name: 'domainMax', type: 'double', description: 'Required.'),
  DocsApiFact(
    name: 'rangeStart',
    type: 'double',
    description: 'Where domainMin lands. For a Y axis this is the BOTTOM of the plot, so the larger pixel value.',
  ),
  DocsApiFact(name: 'rangeEnd', type: 'double', description: 'Required.'),
  DocsApiFact(name: 'scale', type: 'double Function(double)', description: 'Maps a domain value to a pixel position.'),
  DocsApiFact(
    name: 'ticks',
    type: 'List<double> Function({int tickCount})',
    description: 'elChartNiceTicks over this scale\'s own domain.',
  ),
  DocsApiFact(
    name: 'ElLinearScale.nice',
    type: 'factory (dataMin, dataMax, rangeStart, rangeEnd, {tickCount = 5, includeZero = true})',
    description:
        'Nices the extent (folding 0 into the domain by default, matching '
        "a value axis's domain={[0, 'auto']}), then builds the scale from "
        'the niced interval.',
  ),
];

/// `typedef ElBarSlot = ({double offset, double size})` — a Dart record, not
/// a class, so it has no constructor of its own; its two fields are
/// documented the same way a class's constructor parameters are.
const List<DocsApiFact> _barSlotFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'offset',
    type: 'double',
    description: "One bar's leading edge, from the band's own start.",
  ),
  DocsApiFact(name: 'size', type: 'double', description: "The bar's own width (or height, under a vertical layout)."),
];

const List<DocsApiFact> _curveTypeFacts = <DocsApiFact>[
  DocsApiFact(name: 'linear', type: 'ElCurveType', description: 'Straight segments between points.'),
  DocsApiFact(
    name: 'natural',
    type: 'ElCurveType',
    description: 'A natural cubic spline — the Thomas-algorithm solve d3-shape\'s curveNatural runs.',
  ),
  DocsApiFact(
    name: 'monotone',
    type: 'ElCurveType',
    description: 'Steffen 1990 tangents. Resolves to curveMonotoneX in the reference on every horizontal chart on the page.',
  ),
  DocsApiFact(
    name: 'step',
    type: 'ElCurveType',
    description: 'A flat run then a vertical jump, split at the segment midpoint.',
  ),
];

const List<DocsApiFact> _functionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'elChartNiceTicks',
    type: '(double min, double max, {int tickCount = 5, bool allowDecimals = true}) → List<double>',
    description: 'The tick values a numeric axis actually renders — recharts\' getNiceTickValues.',
  ),
  DocsApiFact(
    name: 'elChartNiceDomain',
    type: '(double min, double max, {int tickCount, bool allowDecimals}) → ({double min, double max})',
    description: 'The domain a numeric axis ends up with — the niced ticks\' own extremes.',
  ),
  DocsApiFact(
    name: 'elBarSlots',
    type: '({double bandSize, int barCount, double barCategoryGapRatio = 0.1, double barGap = 4}) → List<ElBarSlot>',
    description: 'One bar\'s offset and width inside its own band, for however many bars share it.',
  ),
  DocsApiFact(
    name: 'elBarRRect',
    type: '(Rect rect, List<double> radii) → RRect',
    description: 'A bar rectangle plus a [tl, tr, br, bl] radius list, each clamped to min(|w|, |h|) / 2.',
  ),
  DocsApiFact(
    name: 'elCurvePath',
    type: '(List<Offset> points, ElCurveType type) → Path',
    description: 'The open curve through points, d3-shape\'s line() with the matching curve factory.',
  ),
  DocsApiFact(
    name: 'elAreaPath',
    type: '(List<Offset> top, List<Offset> base, ElCurveType type) → Path',
    description: 'The filled band between top and base — d3-shape\'s area().',
  ),
  DocsApiFact(
    name: 'elPolarToCartesian',
    type: '(double cx, double cy, double radius, double angle) → Offset',
    description: 'Degrees counter-clockwise from three o\'clock, negated on the way into screen space.',
  ),
  DocsApiFact(
    name: 'elPolarMaxRadius',
    type: '(double width, double height, {double inset = 10}) → double',
    description: 'The radius a polar chart fills — min(width - inset, height - inset) / 2.',
  ),
  DocsApiFact(
    name: 'elSectorPath',
    type: '({required double cx, cy, innerRadius, outerRadius, startAngle, endAngle}) → Path',
    description: 'A wedge with square corners — recharts\' getSectorPath.',
  ),
  DocsApiFact(
    name: 'elSectorWithCornerPath',
    type: '({..., required double cornerRadius}) → Path',
    description: 'The rounded-arc case, falling back to elSectorPath when the sweep is too narrow for two corner circles.',
  ),
  DocsApiFact(
    name: 'elPolarPolygonPath',
    type: '(List<Offset> points) → Path',
    description: 'The closed polygon a Radar series or a polygon PolarGrid ring draws.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Any function in this file',
    treatment:
        'N/A — pure functions and @immutable value classes. Calling '
        'elChartNiceTicks(0, 300) twice returns two equal lists; nothing '
        'here has a field it can mutate.',
    userSignal: 'N/A — there is no widget, so nothing a reader interacts with.',
  ),
  DocsStateFact(
    state: 'Entrance animation',
    treatment:
        'N/A here. ElCartesianChart and the three chart-polar widgets each '
        'own an AnimationController and pass its progress into their own '
        'painters; this file supplies the geometry those painters draw at '
        'a given t, not the animation itself.',
    userSignal: 'N/A',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No Widget, so no Semantics tree: `grep -n "Semantics" lib/src/'
            'components/chart_geometry.dart` returns nothing.',
        'Every function returns a value — a List<double>, an Offset, a '
            'Path, a record — never a rendered node. Whatever accessibility '
            'story a real chart has is entirely chart-cartesian\'s and '
            'chart-polar\'s to tell; see those pages.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No FocusNode, no key handling, no Widget at all in this file.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching — every function takes its own extent, '
            'width, height or radius as an explicit parameter, supplied by '
            'the caller\'s own LayoutBuilder. Nothing here reads '
            'MediaQuery or a breakpoint token.',
        'A caller reruns these functions on every build with the box it '
            'was given that frame, which is what makes a chart resize '
            'correctly: chart-cartesian\'s own _CartesianLayout.resolve is '
            'called fresh inside a LayoutBuilder, not cached across '
            'rebuilds.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/chart_geometry.dart — one file, no '
            'companions.',
        'Imports: dart:math and dart:ui (Offset, Path, Rect, RRect, '
            'Radius) only. No package:flutter import of any kind, and no '
            'foundation/ import either — this file is the one place in the '
            'whole chart family with zero Flutter or theme dependency.',
        'registryDependencies: empty, verbatim from registry/components/'
            'chart-geometry.json. Nothing this file needs; everything else '
            'in the chart family needs it — chart-cartesian and '
            'chart-polar both list chart-geometry among their own.',
        'No colour is read anywhere in this file. Every Color used on '
            'this page\'s own specimens above comes from this '
            'documentation page reading ElTheme.of(context), never from '
            'chart_geometry.dart itself, which does not import theme.dart '
            'at all.',
      ]);
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'N/A — chart_geometry.dart declares no colour, no shadow, no '
            'radius, and no type role of its own. It returns geometry: '
            'positions, paths, and rectangles. Colour, elevation and type '
            'are entirely the caller\'s concern, applied when the geometry '
            'is painted.',
        'The one token this file DOES read is a radius value, but only as '
            'a caller-supplied double parameter (elBarRRect\'s radii, '
            'elSectorWithCornerPath\'s cornerRadius) — it never resolves '
            'ElRadii.* itself.',
      ]);
}

Widget _bullets(ElThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText('•  $line', ElType.small, color: theme.mutedForeground),
      ),
      SizedBox(height: el(2)),
    ],
  ],
);
