/// The five chart tokens, `components/space/charts/data.ts`'s colour section.
library;

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

/* ── Colour ──────────────────────────────────────────────────────────────── */

/// The five chart tokens, resolved once per build.
///
/// `--chart-1` … `-5`, *"declared once per theme in `app/globals.css`, and
/// mirrored between them on purpose: 2 and 3 swap, and so do 4 and 5, so the
/// reading order of a stack survives the theme flip instead of inverting with
/// it. There is no sixth, and adding one needs a written reason."*
class ChartInk {
  const ChartInk(this.theme);

  final ThemeTokens theme;

  /// `var(--color-chart-N)` for N in 1…5.
  Color slot(int n) => switch (n) {
    1 => theme.chart1,
    2 => theme.chart2,
    3 => theme.chart3,
    4 => theme.chart4,
    _ => theme.chart5,
  };

  /// A datum's own `fill`, read off its `slot` field.
  Color ofRow(Map<String, Object?> row) => slot((row['slot'] as int?) ?? 1);

  /// The rows with their `fill` resolved, for the widgets that read it back.
  List<Map<String, Object?>> rows(List<Map<String, Object?>> data) =>
      <Map<String, Object?>>[
        for (final Map<String, Object?> row in data)
          <String, Object?>{...row, 'fill': ofRow(row)},
      ];

  /* ── The four configs the registry reuses ─────────────────────────────── */

  ChartConfig get desktop => ChartConfig(<String, ChartSeries>{
    'desktop': ChartSeries(label: 'Desktop', color: slot(1)),
  });

  ChartConfig get desktopMobile => ChartConfig(<String, ChartSeries>{
    'desktop': ChartSeries(label: 'Desktop', color: slot(1)),
    'mobile': ChartSeries(label: 'Mobile', color: slot(2)),
  });

  /// *"`visitors` carries the axis label and deliberately has no colour: it is
  /// the value key, not a series."*
  ChartConfig get browser => ChartConfig(<String, ChartSeries>{
    'visitors': const ChartSeries(label: 'Visitors'),
    'chrome': ChartSeries(label: 'Chrome', color: slot(1)),
    'safari': ChartSeries(label: 'Safari', color: slot(2)),
    'firefox': ChartSeries(label: 'Firefox', color: slot(3)),
    'edge': ChartSeries(label: 'Edge', color: slot(4)),
    'other': ChartSeries(label: 'Other', color: slot(5)),
  });

  ChartConfig get sport => ChartConfig(<String, ChartSeries>{
    'running': ChartSeries(label: 'Running', color: slot(1)),
    'swimming': ChartSeries(label: 'Swimming', color: slot(2)),
  });

  /// Month keys, because the slices are months rather than series.
  ChartConfig get pieMonths => ChartConfig(<String, ChartSeries>{
    'visitors': const ChartSeries(label: 'Visitors'),
    'desktop': const ChartSeries(label: 'Desktop'),
    'mobile': const ChartSeries(label: 'Mobile'),
    'january': ChartSeries(label: 'January', color: slot(1)),
    'february': ChartSeries(label: 'February', color: slot(2)),
    'march': ChartSeries(label: 'March', color: slot(3)),
    'april': ChartSeries(label: 'April', color: slot(4)),
    'may': ChartSeries(label: 'May', color: slot(5)),
  });
}
